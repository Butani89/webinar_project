@description('Location for all resources')
param location string = resourceGroup().location

@description('Username for the Virtual Machine')
param adminUsername string = 'azureuser'

@description('SSH Public Key for the Virtual Machine')
param adminPublicKey string

@description('Database Password')
@secure()
param dbPassword string

@description('DuckDNS Token')
@secure()
param duckDnsToken string

var vnetName = 'SvampVNet'
var subnetName = 'SvampSubnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = '10.0.1.0/24'

// --- NETWORK ---
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

// --- NSGs ---
resource proxyNsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'ProxyNSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTP'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
      {
        name: 'AllowHTTPS'
        properties: {
          priority: 101
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
    ]
  }
}

resource bastionNsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'BastionNSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSSH'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

resource internalNsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'InternalNSG'
  location: location
  properties: {
    securityRules: [] // Allow VNet inbound by default
  }
}

// --- PUBLIC IPs ---
resource proxyPublicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'FrontendProxyVM-ip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionPublicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'BastionVM-ip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// --- NETWORK INTERFACES ---
resource dbNic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'DatabaseVM-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: internalNsg.id
    }
  }
}

resource backendNic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'BackendVM-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: internalNsg.id
    }
  }
}

resource proxyNic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'FrontendProxyVM-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: proxyPublicIp.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: proxyNsg.id
    }
  }
}

resource bastionNic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'BastionVM-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: bastionPublicIp.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: bastionNsg.id
    }
  }
}

// --- VIRTUAL MACHINES ---

// 1. Database VM
resource dbVm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'DatabaseVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
        publisher: 'Debian'
        offer: 'debian-13'
        sku: '13'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: dbNic.id
        }
      ]
    }
    osProfile: {
      computerName: 'DatabaseVM'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
      // Inject Password into placeholder
      customData: base64(replace(loadTextContent('../scripts/db_setup.sh'), 'PLACEHOLDER_DB_PASSWORD', dbPassword))
    }
  }
}

// 2. Backend VM
resource backendVm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'BackendVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
        publisher: 'Debian'
        offer: 'debian-13'
        sku: '13'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: backendNic.id
        }
      ]
    }
    osProfile: {
      computerName: 'BackendVM'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
      // Inject DB Host (Private IP) and Password
      customData: base64(format('#!/bin/bash\nexport DB_HOST="{0}"\nexport DB_PASSWORD="{1}"\n{2}', dbNic.properties.ipConfigurations[0].properties.privateIPAddress, dbPassword, loadTextContent('../scripts/backend_setup.sh')))
    }
  }
  dependsOn: [
    dbVm // Ensure DB exists so we can get its IP (conceptually, though Bicep NIC resolution works)
  ]
}

// 3. Proxy VM
resource proxyVm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'FrontendProxyVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
        publisher: 'Debian'
        offer: 'debian-13'
        sku: '13'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: proxyNic.id
        }
      ]
    }
    osProfile: {
      computerName: 'FrontendProxyVM'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
      // Inject Token and Backend IP into template
      customData: base64(replace(replace(loadTextContent('./scripts/proxy_setup_template.sh'), '__DUCKDNS_TOKEN__', duckDnsToken), '__BACKEND_IP__', backendNic.properties.ipConfigurations[0].properties.privateIPAddress))
    }
  }
  dependsOn: [
    backendVm // Ensure Backend IP is ready
  ]
}

// 4. Bastion VM
resource bastionVm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'bastionVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
        publisher: 'Debian'
        offer: 'debian-13'
        sku: '13'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: bastionNic.id
        }
      ]
    }
    osProfile: {
      computerName: 'bastionVM'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
    }
  }
}

// --- OUTPUTS ---
output bastionPublicIp string = bastionPublicIp.properties.ipAddress
output proxyPublicIp string = proxyPublicIp.properties.ipAddress
output dbPrivateIp string = dbNic.properties.ipConfigurations[0].properties.privateIPAddress
