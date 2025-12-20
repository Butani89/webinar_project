#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}>>> Starting Local Integration Test <<<${NC}"

# 1. Install Dependencies (Simulated for CI environment)
# In a real CI, these would likely be pre-installed or part of the setup-env step.
# For this script, we assume tofu and ansible are available or we'd install them.
# Checking availability:
if ! command -v tofu &> /dev/null; then
    echo "OpenTofu not found. Please install it."
    exit 1
fi
if ! command -v ansible-playbook &> /dev/null; then
    echo "Ansible not found. Please install it."
    exit 1
fi

# 2. Provision Infrastructure (Docker)
echo -e "${GREEN}>>> Provisioning Infrastructure (OpenTofu/Docker)...${NC}"
cd infra/opentofu/local
tofu init
tofu apply -auto-approve
cd ../../..

# 3. Generate Inventory
echo -e "${GREEN}>>> Generating Ansible Inventory...${NC}"
./infra/scripts/generate_local_inventory.sh

# 4. Configure Infrastructure (Ansible)
echo -e "${GREEN}>>> Configuring Infrastructure (Ansible)...${NC}"
# We might need to wait a few seconds for SSH to be ready in the containers
echo "Waiting for containers to be SSH-ready..."
sleep 10
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i infra/ansible/inventory_local.ini infra/ansible/playbooks/site.yml

# 5. Verify Deployment
echo -e "${GREEN}>>> Verifying Deployment...${NC}"
# Check if the Proxy is responding (using the mapped port 8080 from main.tf)
if curl --retry 5 --retry-delay 5 -f http://localhost:8080; then
    echo -e "${GREEN}SUCCESS: Application is reachable!${NC}"
else
    echo "FAILURE: Application did not respond."
    exit 1
fi

# 6. Cleanup (Optional, can be disabled for debugging)
echo -e "${GREEN}>>> Cleaning up...${NC}"
cd infra/opentofu/local
tofu destroy -auto-approve
cd ../../..

echo -e "${GREEN}>>> Test Completed Successfully <<<${NC}"
