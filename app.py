from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
CORS(app)

# Database settings
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://adminuser:Password123!@localhost/webinar_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Attendee(db.Model):
    __tablename__ = 'attendees'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    email = db.Column(db.String(100))
    company = db.Column(db.String(100))
    jobtitle = db.Column(db.String(100))

# Create tables
with app.app_context():
    db.create_all()
    print("Database and table are ready!")

@app.route('/api/register', methods=['POST'])
def register():
    data = request.json
    try:
        new_attendee = Attendee(
            name=data['name'],
            email=data['email'],
            company=data.get('company'),
            jobtitle=data.get('jobtitle')
        )
        db.session.add(new_attendee)
        db.session.commit()
        return jsonify({"message": "Success"}), 200
    except Exception as e:
        print(e)
        return jsonify({"message": "Error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)