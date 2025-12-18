# CI/CD Setup with GitHub Actions

To enable automatic deployments, you need to configure the following **Secrets** in your GitHub Repository settings:

1.  **Azure Authentication (OIDC Recommended):**
    *   `AZURE_CLIENT_ID`
    *   `AZURE_TENANT_ID`
    *   `AZURE_SUBSCRIPTION_ID`
    *   *Follow this guide to set up OIDC:* [Azure Login with OIDC](https://github.com/Azure/login#configure-a-federated-credential-to-use-oidc-based-authentication)

2.  **Application Secrets:**
    *   `SSH_PUBLIC_KEY`: The public key (`cat ~/.ssh/id_rsa.pub`) to allow SSH access to the VMs.
    *   `DUCKDNS_TOKEN`: Your DuckDNS token (`6ed97e8a-fe91-4986-b4da-3bfc75de29c2`).

## Workflow Description
The `.github/workflows/deploy.yml` file is configured to:
1.  Trigger on every `push` to the `main` branch.
2.  Log in to Azure securely.
3.  Deploy the `infra/main.bicep` template to the `SvamparnasRG_Prod` resource group.

**Note:** This pipeline manages **Infrastructure**. Code updates on existing VMs require either a re-deployment (immutable infrastructure) or a separate deployment strategy (e.g., SSH/Ansible).
