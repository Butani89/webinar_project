# Developer Guide

Welcome to the **Svamparnas Värld** developer documentation. This guide serves as the entry point for setting up your environment and understanding the development workflow.

## 🚀 Getting Started

Choose the setup guide for your operating system:

*   🐧 **[Setup for Debian 13 / Linux](docs/development/setup-debian.md)**
*   🪟 **[Setup for Windows 11](docs/development/setup-windows.md)**

## 📂 Project Structure

```text
/
├── app.py                  # Main Flask backend application
├── script.js               # Frontend logic
├── index.html              # Frontend markup
├── infra/                  # Infrastructure as Code
│   ├── main.bicep          # Azure Bicep template
│   └── scripts/            # Cloud-init scripts
├── .github/workflows/      # CI/CD Pipelines
└── deploy.sh               # Local deployment script
```

## 🛠 Workflow

We follow a simple **Feature Branch** workflow.

```mermaid
gitGraph
    commit
    commit
    branch feature/new-mushroom
    checkout feature/new-mushroom
    commit
    commit
    checkout main
    merge feature/new-mushroom
    commit
    branch fix/login-error
    checkout fix/login-error
    commit
    checkout main
    merge fix/login-error
    commit
```

1.  **Branching:** Create a new branch for every feature or bugfix (e.g., `feature/new-mushroom`, `fix/login-error`).
2.  **Local Test:** Ensure the app runs locally using the instructions above.
3.  **Pull Request:** Push your branch and create a PR to `main`.
4.  **Deployment:** Merging to `main` triggers the GitHub Action to deploy infrastructure changes.

## 🚀 Deploying Code Changes (Application Updates)

After pushing your code changes to the `main` branch, the GitHub Actions workflow will update the infrastructure if any Bicep files changed. However, for application code changes (`app.py`, `script.js`, etc.) on already running Virtual Machines, you need to trigger an update.

### Steps to Deploy Code Updates:

1.  **Push your changes** to the `main` branch as described in the "Workflow" section above. This makes your latest code available in the repository.

2.  **Run the local update script:**
    From your project's root directory on your local machine, execute:
    ```bash
    ./update_code.sh
    ```
    This script will securely connect to your Backend VM (via the Bastion Host), pull the latest code, and restart the application service.

    *(Note: The `update_code.sh` script automatically fetches the Bastion and Backend IP addresses from your last successful Bicep deployment. If you have redeployed with a new Bastion IP, ensure the script is up-to-date or re-run `az deployment group show` to get the latest IPs if you modified the script manually.)*

## 🧪 Testing

*   **Backend:** (Add details about running unit tests here, e.g., `pytest`)
*   **Infrastructure:** Validate Bicep templates using:
    ```bash
    az bicep build --file infra/main.bicep
    ```

## 🤝 Need Help?

Check the [CONTRIBUTING.md](CONTRIBUTING.md) file for communication channels and Code of Conduct.
