from flask import Flask, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship

app = Flask(__name__)
CORS(app)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://dbuser:dbpasswort@db/skillforge_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define SQLAlchemy models to match database schema
class TrainingCourses(db.Model):
    __tablename__ = 'trainingcourses'
    TrainingID = db.Column(db.BigInteger, primary_key=True, autoincrement=True)
    MinParticipants = db.Column(db.Integer, default=7)
    MaxParticipants = db.Column(db.Integer, default=25)
    
    # Relationships
    event_info = relationship('EventInformation', back_populates='training', uselist=False)
    event_days = relationship('EventDays', back_populates='training')
    participants = relationship('Participates', back_populates='training')

class EventInformation(db.Model):
    __tablename__ = 'event_information'
    InformationID = db.Column(db.BigInteger, primary_key=True, autoincrement=True)
    NameDE = db.Column(db.String(50), nullable=False)
    NameEN = db.Column(db.String(50), nullable=False)
    DescriptionDE = db.Column(db.Text)
    DescriptionEN = db.Column(db.Text)
    SubjectArea = db.Column(db.String(25))
    EventType = db.Column(db.String(20), nullable=False)
    describes = db.Column(db.BigInteger, db.ForeignKey('trainingcourses.TrainingID'))
    
    # Relationship with training courses
    training = relationship('TrainingCourses', back_populates='event_info')

class EventDays(db.Model):
    __tablename__ = 'event_days'
    DayID = db.Column(db.BigInteger, primary_key=True, autoincrement=True)
    EventDate = db.Column(db.Date, nullable=False)
    StartTime = db.Column(db.Time)
    EndTime = db.Column(db.Time)
    EventLocation = db.Column(db.String(50))
    LocationFederalState = db.Column(db.String(50))
    consists_of = db.Column(db.BigInteger, db.ForeignKey('trainingcourses.TrainingID'))
    
    # Relationship with training courses
    training = relationship('TrainingCourses', back_populates='event_days')

class Participates(db.Model):
    __tablename__ = 'participates'
    TrainingID = db.Column(db.BigInteger, db.ForeignKey('trainingcourses.TrainingID'), primary_key=True)
    UserID = db.Column(db.BigInteger, db.ForeignKey('users.UserID'), primary_key=True)
    registration_date = db.Column(db.DateTime, server_default=db.func.current_timestamp())
    
    # Relationships
    training = relationship('TrainingCourses', back_populates='participants')
    user = relationship('Users', back_populates='participates')

class Users(db.Model):
    __tablename__ = 'users'
    UserID = db.Column(db.BigInteger, primary_key=True, autoincrement=True)
    Username = db.Column(db.String(50), nullable=False, unique=True)
    PasswordHash = db.Column(db.String(512), nullable=False)
    FirstName = db.Column(db.String(50), nullable=False)
    LastName = db.Column(db.String(50), nullable=False)
    Email = db.Column(db.String(50), nullable=False, unique=True)
    SpecializationField = db.Column(db.String(25), nullable=False)
    is_admin = db.Column(db.Boolean, default=False)
    is_active = db.Column(db.Boolean, default=True)
    CountLoginAttempts = db.Column(db.Integer, default=0)
    
    # Relationship
    participates = relationship('Participates', back_populates='user')

@app.route('/api/trainingcourses', methods=['GET'])
def get_training_courses():
    """
    Retrieve all training courses with their associated event information.
    
    Returns:
        JSON response containing training courses and their details.
    """
    # Query to fetch all training courses with their event information
    training_courses = TrainingCourses.query.all()
    
    # Prepare the response data
    result = []
    for course in training_courses:
        # Check if event_info exists to avoid potential None errors
        event_info = course.event_info if course.event_info else None
        
        course_data = {
            'TrainingID': course.TrainingID,
            'MinParticipants': course.MinParticipants,
            'MaxParticipants': course.MaxParticipants,
            'EventInfo': {
                'NameDE': event_info.NameDE if event_info else None,
                'NameEN': event_info.NameEN if event_info else None,
                'DescriptionDE': event_info.DescriptionDE if event_info else None,
                'DescriptionEN': event_info.DescriptionEN if event_info else None,
                'SubjectArea': event_info.SubjectArea if event_info else None,
                'EventType': event_info.EventType if event_info else None
            }
        }
        result.append(course_data)
    
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
