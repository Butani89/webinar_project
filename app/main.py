import os
import sys
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from scripts.generate_art import generate_mushroom

app = Flask(__name__)

# Enable CORS for local development
if os.environ.get('FLASK_ENV') == 'development':
    CORS(app)
    print("CORS enabled for development environment.")

# Database settings
db_host = os.environ.get('DB_HOST', 'localhost')
db_password = os.environ.get('DB_PASSWORD')
admin_password = os.environ.get('ADMIN_PASSWORD', 'password')

if not db_password:
    print("Error: DB_PASSWORD environment variable not set.")
    sys.exit(1)

app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://adminuser:{db_password}@{db_host}/webinar_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Attendee(db.Model):
    """Model representing an attendee in the database.

    Attributes:
        id (int): Unique identifier for the attendee.
        name (str): Full name of the attendee.
        email (str): Email address of the attendee.
        company (str): Company or organization name (optional).
        jobtitle (str): Job title (optional, legacy field).
        experience (str): Attendee's experience level with mushrooms.
        date (str): Selected webinar date.
    """
    __tablename__ = 'attendees'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    company = db.Column(db.String(100))
    jobtitle = db.Column(db.String(100)) # Kept for backward compatibility if needed, or repurposed
    experience = db.Column(db.String(100))
    date = db.Column(db.String(50), nullable=False)
    image_url = db.Column(db.String(255), nullable=True)

# Create tables
with app.app_context():
    db.create_all()
    # Ensure directory for attendee images exists
    attendee_image_dir = os.path.join(app.static_folder, 'img', 'attendees')
    os.makedirs(attendee_image_dir, exist_ok=True)
    print("Database and table are ready!")
    print(f"Attendee image directory created: {attendee_image_dir}")

@app.route('/api/register', methods=['POST'])
def register():
    """Register a new attendee for the webinar.

    Validates the input JSON payload, creates a new Attendee record,
    and saves it to the database.

    Returns:
        tuple: A JSON response and an HTTP status code.
            - 201: Success.
            - 400: Missing required fields or invalid JSON.
            - 500: Internal server error.
    """
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
        db.session.commit() # Commit to get the new_attendee.id

        # Generate mushroom art
        attendee_image_filename = f"attendee_mushroom_{new_attendee.id}.png"
        attendee_image_path = os.path.join(app.static_folder, 'img', 'attendees', attendee_image_filename)
        generate_mushroom(new_attendee.id, attendee_image_path)
        
        # Update attendee with image URL
        new_attendee.image_url = f'/static/img/attendees/{attendee_image_filename}'
        db.session.commit() # Commit again to save the image_url

        return jsonify({"message": "Success", "image_url": new_attendee.image_url}), 201
    except Exception as e:
        print(f"Error registering attendee: {e}")
        return jsonify({"message": "Internal Server Error"}), 500

@app.route('/api/attendees', methods=['GET'])
def get_attendees():
    """Fetch all registered attendees.

    Requires 'X-Admin-Password' header for authentication.

    Returns:
        tuple: A JSON list of attendees and HTTP 200 status.
    """
    auth_header = request.headers.get('X-Admin-Password')
    if auth_header != admin_password:
        return jsonify({"message": "Unauthorized"}), 401

    try:
        attendees = Attendee.query.order_by(Attendee.id.desc()).all()
        result = []
        for attendee in attendees:
            result.append({
                "id": attendee.id,
                "name": attendee.name,
                "email": attendee.email,
                "company": attendee.company,
                "experience": attendee.experience,
                "date": attendee.date,
                "image_url": attendee.image_url
            })
        return jsonify(result), 200
    except Exception as e:
        print(f"Error fetching attendees: {e}")
        return jsonify({"message": "Internal Server Error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)