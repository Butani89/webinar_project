from flask import Flask, request, jsonify
import psycopg2
from flask_cors import CORS

app = Flask(__name__)
CORS(app) # Allows the website to communicate with the server

# Database settings (matches what we wrote in the bash script)
DB_CONFIG = {
    'dbname': 'webinar_db',
    'user': 'adminuser',
    'password': 'Password123!',
    'host': 'localhost'
}

# Function to create the table if it is missing
def init_db():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS attendees (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100),
                email VARCHAR(100),
                company VARCHAR(100),
                jobtitle VARCHAR(100)
            );
        """)
        conn.commit()
        cur.close()
        conn.close()
        print("Database and table are ready!")
    except Exception as e:
        print(f"Error starting database: {e}")

# Runs when the server starts
init_db()

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        # Save data to the table
        cur.execute(
            "INSERT INTO attendees (name, email, company, jobtitle) VALUES (%s, %s, %s, %s)",
            (data['name'], data['email'], data['company'], data['jobtitle'])
        )
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "Success"}), 200
    except Exception as e:
        print(e)
        return jsonify({"message": "Error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
