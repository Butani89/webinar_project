# Continuous Integration & Deployment (CI/CD)

The project uses GitHub Actions to enforce code quality and automate deployment.

## Workflows

### 1. Integration Pipeline (`development`)
**Trigger**: Push/PR to `development`.

This workflow ensures that the Ansible configuration and application code work correctly on a fresh **Debian 13** environment before merging.

1.  **Provision**: Spins up `database`, `backend`, `proxy` containers using `infra/opentofu/local`.
2.  **Configure**: Runs the Ansible Playbook `site.yml` against these containers.
3.  **Verify**: Checks if the application responds to HTTP requests.

### 2. Production Deployment (`production`)
**Trigger**: Push to `production`.

This workflow provisions the actual cloud infrastructure and updates the application.

1.  **Provision Infrastructure**: Runs `tofu apply` (Azure/Proxmox).
2.  **Configure Servers**: Runs `ansible-playbook` against the live inventory.

## Setup Instructions

### Secrets
To enable the Production deployment, you must set the following **GitHub Secrets**:

- `AZURE_CREDENTIALS`: (For Azure) Service Principal JSON.
- `SSH_PRIVATE_KEY`: Key to access the Bastion/VMs.
- `DUCKDNS_TOKEN`: Token for Dynamic DNS updates.
- `DB_PASSWORD`: Password for the PostgreSQL user.
- `ADMIN_PASSWORD`: Django Admin password.

## Troubleshooting

- **Local Test Failures**: Run `./scripts/ci_local_test.sh` locally to debug. It reproduces the exact steps the CI performs.
- **Ansible Errors**: Check the detailed logs in the GitHub Action run. Use `-vvv` in the Ansible command for more verbosity if needed.