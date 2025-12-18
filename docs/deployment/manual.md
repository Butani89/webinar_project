# Manual Deployment Guide

This guide explains how to deploy the infrastructure manually from your local machine. This is useful for testing infrastructure changes before pushing them to the CI/CD pipeline.

## Prerequisites

1.  **Azure CLI:** [Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
2.  **Azure Subscription:** You must be logged in.
    ```bash
    az login
    ```
3.  **OpenSSL:** Required to generate the random database password (usually pre-installed on Linux/Mac/WSL).

## The `deploy.sh` Script

We provide a helper script, `deploy.sh`, located in the root of the repository. This script automates the following:

1.  Generates a secure, random **Database Password**.
2.  Checks for (or generates) an **SSH Key pair**.
3.  Creates the **Resource Group**.
4.  Triggers the **Bicep Deployment**.

### Usage

1.  **Navigate to project root:**
    ```bash
    cd webinar_project
    ```

2.  **Run the script:**
    ```bash
    ./deploy.sh
    ```

### Output

Upon success, the script will output:
*   **Bastion Public IP:** Use this to SSH into the network.
*   **Proxy Public IP:** Use this to access the web app (or configure DNS).
*   **Database Private IP:** Internal VNet IP.
*   **Generated Database Password:** Save this if you need to manually connect to the DB.

## Accessing the Infrastructure

### SSH Access (The Bastion Pattern)

You cannot SSH directly into the App or Database servers. You must "jump" through the Bastion.

1.  **Connect to Bastion:**
    ```bash
    ssh azureuser@<BASTION_PUBLIC_IP>
    ```

2.  **Jump to Internal VM:**
    From the Bastion shell:
    ```bash
    ssh azureuser@<INTERNAL_IP>
    ```

### Web Access

Visit: `https://webinar-funtime-deluxe.duckdns.org`

*(Note: If you just deployed, wait 5-10 minutes for the VM setup scripts to install Nginx and request the SSL certificate.)*
