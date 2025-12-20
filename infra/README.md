# Infrastructure as Code (IaC)

This directory contains the platform-agnostic infrastructure code using OpenTofu and Ansible.

## Directory Structure

- `opentofu/`: Infrastructure provisioning (VMs, Networking, etc.)
  - `azure/`: Azure-specific OpenTofu configuration.
  - `proxmox/`: Proxmox-specific OpenTofu configuration.
  - `local/`: Local Docker-based testing environment.
- `ansible/`: Configuration management (Software installation, settings).

## Workflow

### 1. Provision Infrastructure

#### Local (Docker)
Ideal for development and testing Ansible roles.
```bash
cd infra/opentofu/local
tofu init
tofu apply
```

#### Azure
```bash
cd infra/opentofu/azure
tofu init
tofu apply
```

### 2. Generate Inventory & Configure

#### For Local Docker Target
Create an `inventory_local.ini`:
```ini
[all:vars]
ansible_connection=docker
ansible_user=root
ansible_password=root
# Adjust python interpreter if needed, though the image has python3
ansible_python_interpreter=/usr/bin/python3

[database]
webinar-local-database

[backend]
webinar-local-backend

[proxy]
webinar-local-proxy

[bastion]
webinar-local-bastion
```

Run playbook:
```bash
ansible-playbook -i inventory_local.ini infra/ansible/playbooks/site.yml
```

#### For Cloud/Proxmox Targets
Use the outputs from OpenTofu to create an Ansible inventory file.
*Example `inventory.ini`*:
```ini
[database]
10.0.1.4

[backend]
10.0.1.5
...
```

Run playbook:
```bash
ansible-playbook -i inventory.ini infra/ansible/playbooks/site.yml
```

## Requirements

- OpenTofu
- Ansible
- Azure CLI (for Azure)
- Proxmox Credentials (for Proxmox)
