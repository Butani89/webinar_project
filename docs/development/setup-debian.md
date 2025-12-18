# Development Setup Guide for Debian 13 (Linux)

This guide provides step-by-step instructions to set up your local development environment on a Debian 13 system.

## 1. Prerequisites

Open your terminal and install the necessary system dependencies. You will need `git`, `python3`, `pip`, and `PostgreSQL`.

```bash
sudo apt update
sudo apt install git python3 python3-pip python3-venv postgresql postgresql-contrib libpq-dev -y
```

## 2. Clone the Repository

Clone the project source code to your local machine.

```bash
git clone https://github.com/Butani89/webinar_project.git
cd webinar_project
```

## 3. Database Setup

We need a local PostgreSQL database to run the backend.

1.  **Start the PostgreSQL service:**
    ```bash
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    ```

2.  **Create the Database and User:**
    Switch to the postgres user and run the SQL commands.

    ```bash
    sudo -u postgres psql
    ```

    Inside the PostgreSQL prompt (`postgres=#`), run:
    ```sql
    CREATE USER adminuser WITH PASSWORD 'Password123!';
    CREATE DATABASE webinar_db OWNER adminuser;
    \q
    ```
    *(Note: For local development, we use a simple password. Do not use this in production!)*

## 4. Python Backend Setup

1.  **Create a Virtual Environment:**
    Isolate your python dependencies.
    ```bash
    python3 -m venv venv
    ```

2.  **Activate the Environment:**
    ```bash
    source venv/bin/activate
    ```

3.  **Install Dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Configure Environment Variables:**
    The application needs to know where the database is, and we need to enable CORS for local dev.
    ```bash
    export DB_HOST=localhost
    export DB_PASSWORD=Password123!
    export FLASK_ENV=development
    ```

5.  **Run the Application:**
    ```bash
    python3 app.py
    ```
    You should see output indicating the server is running on `http://0.0.0.0:5000`.

## 5. Frontend Setup

The frontend is static HTML/JS. You can open `index.html` directly, but it is better to serve it via a simple HTTP server to avoid CORS issues or path problems.

1.  **Open a new terminal window.**
2.  **Navigate to the project folder.**
3.  **Run a simple Python HTTP server:**
    ```bash
    python3 -m http.server 8000
    ```
4.  **Access the App:**
    Open your browser and go to `http://localhost:8000`.

## 6. Running Tests

(If you have added tests, describe how to run them here, e.g., `pytest`)
