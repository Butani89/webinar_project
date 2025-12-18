# Development Setup Guide for Windows 11

There are two main ways to develop on Windows 11: using **WSL2 (Recommended)** or **Native Windows**.

## Option A: WSL2 (Windows Subsystem for Linux) - Recommended

Since our production environment is Debian Linux and our infrastructure scripts are written in Bash, using WSL2 provides the smoothest development experience.

### 1. Install WSL2
1.  Open PowerShell as Administrator.
2.  Run: `wsl --install`
3.  Restart your computer if prompted.
4.  By default, this installs Ubuntu. To install Debian specifically, run `wsl --install -d Debian` after the restart.

### 2. Follow the Linux Guide
Once inside your WSL terminal, follow the **[Debian 13 Setup Guide](setup-debian.md)**. All commands there will work perfectly in WSL.

---

## Option B: Native Windows

If you prefer to work directly in Windows without WSL.

### 1. Prerequisites

*   **Python:** Download and install Python 3.x from [python.org](https://www.python.org/). Check "Add Python to PATH" during installation.
*   **Git:** Download and install [Git for Windows](https://git-scm.com/download/win).
*   **PostgreSQL:** Download and install the [PostgreSQL Installer](https://www.postgresql.org/download/windows/).
    *   During setup, remember the password you set for the `postgres` superuser.

### 2. Clone the Repository

Open **PowerShell** or **Command Prompt**:

```powershell
git clone https://github.com/Butani89/webinar_project.git
cd webinar_project
```

### 3. Database Setup

1.  Open **pgAdmin** (installed with PostgreSQL) or use the SQL Shell (`psql`).
2.  Connect to your local server.
3.  Open the Query Tool and run:
    ```sql
    CREATE USER adminuser WITH PASSWORD 'Password123!';
    CREATE DATABASE webinar_db OWNER adminuser;
    ```

### 4. Backend Setup

1.  **Create Virtual Environment:**
    ```powershell
    python -m venv venv
    ```

2.  **Activate Environment:**
    ```powershell
    .\venv\Scripts\Activate
    ```

3.  **Install Dependencies:**
    ```powershell
    pip install -r requirements.txt
    ```

4.  **Set Environment Variables:**
    ```powershell
    $env:DB_HOST="localhost"
    $env:DB_PASSWORD="Password123!"
    ```

5.  **Run App:**
    ```powershell
    python app.py
    ```

### 5. Frontend Setup

1.  Open a new PowerShell window.
2.  Navigate to the project folder.
3.  Run the HTTP server:
    ```powershell
    python -m http.server 8000
    ```
4.  Open `http://localhost:8000` in your browser.

### ⚠️ Note on Infrastructure Scripts
The infrastructure scripts (`deploy.sh`, `infra/*`) are Bash scripts. To run these on Windows, you **must** use WSL2 or Git Bash, and you will need the Azure CLI installed in that environment.
