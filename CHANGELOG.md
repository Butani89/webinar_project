# Changelog

All notable changes to this project will be documented in this file.

## [2025-12-18] - Frontend Content Update & Deployment Automation

### Frontend
- **Page Metadata:** Added comprehensive meta tags (`description`, `keywords`, `author`, Open Graph, Twitter Cards) and improved the `<title>` for better SEO and social sharing.
- **Webinar Subject Change:** Updated the main webinar subject and description in `index.html` to: "Svamparnas Otroliga Liv: En djupdykning i myceliets psykologi och hur vi kan skapa musik tillsammans".

### CI/CD
- **Automated App Deployment:** Implemented `update-app.yml` GitHub Actions workflow to automatically deploy application code changes (e.g., frontend, backend code) to running VMs without full re-provisioning.

## [2025-12-18] - Architecture, Infrastructure & Security Overhaul

### Infrastructure
- **OS Consolidation:** Consolidated all Virtual Machines (Bastion, Proxy, Backend, Database) to use **Debian 13** for consistency and stability.
- **IaC Migration:** Fully migrated from imperative shell scripts (`provision_vm.sh`) to declarative **Azure Bicep** templates (`infra/main.bicep`). Removed the legacy `provision_vm.sh` script.
- **Network Security:** Implemented the **Bastion Pattern**. Traffic is now locked down:
    - SSH is only allowed via the Bastion Host.
    - Database and Backend VMs are isolated in the private VNet with no direct public internet access.
    - The Proxy VM handles all incoming HTTP/HTTPS traffic.
- **SSL & DNS:** Configured automatic DuckDNS updates and Certbot SSL certificate generation on the Proxy VM.

### CI/CD
- **GitHub Actions:** Created a deployment pipeline (`.github/workflows/deploy.yml`) that triggers on push to `main`.
- **Authentication:** Configured Azure Service Principal authentication with Client Secrets for secure, automated deployments.

### Backend (Python/Flask)
- **ORM Migration:** Refactored `app.py` to use **SQLAlchemy ORM** instead of raw SQL queries, improving security against injection attacks.
- **Input Validation:** Added robust input validation for the `/api/register` endpoint.
- **Data Model:** Updated the database schema to store `experience` and `date` in dedicated columns.
- **Security:** Removed permissive CORS configuration (relying on Nginx reverse proxy instead).

### Architecture
- **Decoupling:** Formally decoupled the Database from the App Server, moving PostgreSQL to its own dedicated Virtual Machine (`DatabaseVM`).

### Documentation
- **Deployment Guide:** Added a comprehensive deployment guide to `README.md`.
- **CI/CD Guide:** Added `CI_CD.md` detailing the secrets and setup required for GitHub Actions.
- **Changelog:** Initialized this changelog to track project history.

## [2025-12-16] - Provisioning Stabilization
- **Script Updates:** Multiple iterative updates to `provision_vm.sh` and `backend_setup.sh` to fix environment variable injection and package dependencies during the initial Azure testing phase.

## [2025-12-11] - Initial Release
- **Project Upload:** Initial upload of the core application files (`app.py`, `index.html`, `style.css`, `script.js`).

## [2025-12-04] - Frontend Development
- **UI/UX:** Initial development of the frontend interface, including styling and script logic.