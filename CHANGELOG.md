# Changelog

All notable changes to this project will be documented in this file.

## [2025-12-18] - Infrastructure & Security Overhaul

### Security
- **Secrets Management:** Removed all hardcoded credentials (Database passwords, DuckDNS tokens) from source code and scripts.
- **Secret Injection:** Implemented secure injection of generated secrets into VMs using Azure Bicep `customData` and environment variables.
- **Backend Hardening:** 
    - Implemented strict server-side input validation on the `/api/register` endpoint.
    - Removed permissive `CORS(app)` configuration; the application now relies on Nginx for same-origin proxying.
    - Added error handling to return specific HTTP 400 status codes for bad requests.

### Infrastructure
- **IaC Migration:** Replaced imperative `provision_vm.sh` script with declarative **Azure Bicep** templates (`infra/main.bicep`).
- **OS Consolidation:** Standardized all Virtual Machines (Bastion, Proxy, Backend, Database) to run **Debian 13**.
- **Network Security:** 
    - Configured Network Security Groups (NSGs) to strictly limit access (SSH only via Bastion, HTTP/HTTPS only on Proxy).
- **SSL/TLS:** 
    - Integrated **Certbot** for automatic SSL certificate generation and renewal on the Nginx proxy.
    - Added retry logic to Certbot setup to handle DNS propagation delays.
    - Configured DuckDNS dynamic IP updates via cron jobs (running every 5 minutes).

### CI/CD
- **GitHub Actions:** Added `.github/workflows/deploy.yml` to automate infrastructure deployment on push to `main`.
- **Authentication:** Configured Azure Service Principal with OpenID Connect (OIDC) and Secret-based authentication for secure CI/CD operations.

### Application
- **Database Model:** Refactored the `Attendee` model to store `experience` and `date` in separate columns instead of a combined string.
- **Frontend:** Updated `script.js` to send structured JSON data matching the new backend schema.

### Documentation
- **Updated README.md:** Reflected the change to Debian 13, Bicep deployment steps, and new architecture details.
- **Added CI_CD.md:** Created a comprehensive guide for setting up GitHub Actions secrets and workflow.
