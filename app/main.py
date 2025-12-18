import os
import sys
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)

# Enable CORS for local development
if os.environ.get('FLASK_ENV') == 'development':
    CORS(app)
    print("CORS enabled for development environment.")

# Database settings
db_host = os.environ.get('DB_HOST', 'localhost')
db_password = os.environ.get('DB_PASSWORD')

if not db_password:
    print("Error: DB_PASSWORD environment variable not set.")
    sys.exit(1)

app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://adminuser:{db_password}@{db_host}/webinar_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Attendee(db.Model):
    __tablename__ = 'attendees'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    company = db.Column(db.String(100))
    jobtitle = db.Column(db.String(100)) # Kept for backward compatibility if needed, or repurposed
    experience = db.Column(db.String(100))
    date = db.Column(db.String(50), nullable=False)

# Create tables
with app.app_context():
    db.create_all()
    print("Database and table are ready!")

@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json()
    
    if not data:
        return jsonify({"message": "Invalid JSON"}), 400

    required_fields = ['name', 'email', 'date']
    missing_fields = [field for field in required_fields if field not in data or not data[field]]

    if missing_fields:
        return jsonify({"message": f"Missing required fields: {', '.join(missing_fields)}"}), 400

    try:
        new_attendee = Attendee(
            name=data['name'],
            email=data['email'],
            company=data.get('company'),
            jobtitle=data.get('jobtitle'), # Optional
            experience=data.get('experience'),
            date=data['date']
        )
        db.session.add(new_attendee)
        db.session.commit()
        return jsonify({"message": "Success"}), 201
    except Exception as e:
        print(f"Error registering attendee: {e}")
        return jsonify({"message": "Internal Server Error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)