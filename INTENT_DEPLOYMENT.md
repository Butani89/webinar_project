# Intent: Fix Deployment Flow
**Date:** 2025-12-19 23:25
**Author:** Fredrick Amnehagen <fredrick@loopaware.com>

## Problem
- GitHub Actions deployment was failing due to authentication issues (AADSTS70025: no federated identity credentials).
- Infrastructure deployment was missing parameters introduced in the recent refactor (`adminPassword`, `duckDnsDomain`).
- Manual `deploy.sh` was also out of sync with infrastructure parameters.

## Solutions
1. **Azure Configuration**: Used Azure CLI to create a federated identity credential for the `gh-actions-webinar` App Registration, allowing OIDC authentication from the `main` branch of this repository.
2. **GitHub Secrets**: Added `ADMIN_PASSWORD` and `DUCKDNS_DOMAIN` to GitHub repository secrets.
3. **Workflow Updates**:
    - Updated `.github/workflows/deploy.yml` and `.github/workflows/update-app.yml` to use modern OIDC authentication (removing `client-secret`).
    - Added the missing Bicep parameters to the deployment step in `deploy.yml`.
4. **Script Updates**: Updated `deploy.sh` to include the new parameters for manual testing and local use.
