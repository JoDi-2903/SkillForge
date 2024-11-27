import argostranslate.translate as argo
from flask import Flask, jsonify, request
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

@app.route('/api/calendar-events', methods=['GET'])
def get_calendar_events():
    """
    Retrieve calendar events with optional filtering.
    
    Query Parameters:
    - language: 'DE' or 'EN' (required)
    - user_id: Optional user ID to filter events
    - event_type: Optional event types filter (comma-separated list)
    - subject_area: Optional subject areas filter (comma-separated list)
    
    Returns:
    JSON response with filtered calendar events
    """
    # Extract query parameters
    language = request.args.get('language', 'EN').upper()
    user_id = request.args.get('user_id', type=int)
    
    # Parse comma-separated lists into arrays
    event_types = request.args.get('event_type', '').split(',') if request.args.get('event_type') else []
    subject_areas = request.args.get('subject_area', '').split(',') if request.args.get('subject_area') else []
    
    # Remove empty strings from arrays
    event_types = [et.strip() for et in event_types if et.strip()]
    subject_areas = [sa.strip() for sa in subject_areas if sa.strip()]

    # Base query to join relevant tables
    query = db.session.query(
        TrainingCourses, 
        EventInformation, 
        EventDays
    ).join(
        EventInformation, 
        TrainingCourses.TrainingID == EventInformation.describes
    ).join(
        EventDays, 
        TrainingCourses.TrainingID == EventDays.consists_of
    )

    # Apply optional filters
    if user_id:
        query = query.join(
            Participates, 
            TrainingCourses.TrainingID == Participates.TrainingID
        ).filter(Participates.UserID == user_id)

    # Apply IN filters for multiple values
    if event_types:
        query = query.filter(EventInformation.EventType.in_(event_types))

    if subject_areas:
        query = query.filter(EventInformation.SubjectArea.in_(subject_areas))

    # Execute query
    results = query.all()

    # Prepare response
    calendar_events = []
    for training, event_info, event_day in results:
        # Select name based on language
        name = event_info.NameEN if language == 'EN' else event_info.NameDE

        event = {
            'training_id': training.TrainingID,
            'title': name,
            'event_type': event_info.EventType,
            'subject_area': event_info.SubjectArea,
            'dates': [{
                'day_id': event_day.DayID,
                'date': event_day.EventDate.isoformat(),
                'start_time': str(event_day.StartTime),
                'end_time': str(event_day.EndTime),
                'location': event_day.EventLocation,
                'federal_state': event_day.LocationFederalState
            }]
        }
        calendar_events.append(event)

    return jsonify(calendar_events)

@app.route('/api/event-details', methods=['GET'])
def get_event_details():
    """
    Retrieve detailed event information.
    
    Query Parameters:
    - language: 'DE' or 'EN' (required)
    - day_id: Optional Day ID to filter event
    - training_id: Optional Training ID to filter event
    
    Returns:
    JSON response with comprehensive event details
    """
    # Extract query parameters
    language = request.args.get('language', 'EN').upper()
    day_id = request.args.get('day_id', type=int)
    training_id = request.args.get('training_id', type=int)

    # Validate input parameters
    if not (day_id or training_id):
        return jsonify({
            'error': 'Either day_id or training_id must be provided'
        }), 400

    # Base query to join relevant tables
    query = db.session.query(
        TrainingCourses, 
        EventInformation, 
        EventDays
    ).join(
        EventInformation, 
        TrainingCourses.TrainingID == EventInformation.describes
    ).join(
        EventDays, 
        TrainingCourses.TrainingID == EventDays.consists_of
    )

    # Apply filtering based on input parameters
    if day_id:
        query = query.filter(EventDays.DayID == day_id)
    elif training_id:
        query = query.filter(TrainingCourses.TrainingID == training_id)

    # Execute query
    results = query.all()

    # If no results found
    if not results:
        return jsonify({
            'error': 'No event details found'
        }), 404

    # Prepare event details
    event_details = {}
    event_dates = []
    locations = set()

    for training, event_info, event_day in results:
        # Select name and description based on language
        name = event_info.NameEN if language == 'EN' else event_info.NameDE
        description = event_info.DescriptionEN if language == 'EN' else event_info.DescriptionDE

        # Collect event dates
        event_date = {
            'date': event_day.EventDate.isoformat(),
            'start_time': str(event_day.StartTime),
            'end_time': str(event_day.EndTime),
            'location': event_day.EventLocation,
            'federal_state': event_day.LocationFederalState
        }
        event_dates.append(event_date)
        locations.add((event_day.EventLocation, event_day.LocationFederalState))

        # Populate event details (do this only once)
        if not event_details:
            # Count registered participants
            participant_count = db.session.query(Participates)\
                .filter(Participates.TrainingID == training.TrainingID)\
                .count()

            event_details = {
                'training_id': training.TrainingID,
                'title': name,
                'description': description,
                'event_type': event_info.EventType,
                'subject_area': event_info.SubjectArea,
                'locations': [
                    {
                        'location': loc[0],
                        'federal_state': loc[1]
                    } for loc in locations
                ],
                'min_participants': training.MinParticipants,
                'max_participants': training.MaxParticipants,
                'current_participants': participant_count,
                'event_dates': event_dates
            }

    return jsonify(event_details)

@app.route('/api/event-registration-status', methods=['GET'])
def check_event_registration_status():
    """
    Check if a user is registered for a specific event.
    
    Query Parameters:
    - training_id: Training/Event ID (required)
    - user_id: User ID (required)
    
    Returns:
    JSON response with registration status
    """
    # Extract query parameters
    training_id = request.args.get('training_id', type=int)
    user_id = request.args.get('user_id', type=int)

    # Validate input parameters
    if not training_id or not user_id:
        return jsonify({
            'error': 'Both training_id and user_id are required'
        }), 400

    # Check if user is registered for the event
    registration = Participates.query.filter_by(
        TrainingID=training_id, 
        UserID=user_id
    ).first()

    return jsonify({
        'is_registered': registration is not None
    })

@app.route('/api/book-event', methods=['POST'])
def book_event():
    """
    Book an event for a user.
    
    JSON Body Parameters:
    - training_id: Training/Event ID (required)
    - user_id: User ID (required)
    
    Returns:
    JSON response with booking status and details
    """
    # Check content type
    if not request.is_json:
        return jsonify({
            'success': False, 
            'error': 'Request must be JSON'
        }), 415

    # Parse request data
    data = request.get_json()
    training_id = data.get('training_id')
    user_id = data.get('user_id')

    # Validate input parameters
    if not training_id or not user_id:
        return jsonify({
            'success': False,
            'error': 'Both training_id and user_id are required'
        }), 400

    try:
        # Check if user is already registered
        existing_registration = Participates.query.filter_by(
            TrainingID=training_id, 
            UserID=user_id
        ).first()

        if existing_registration:
            return jsonify({
                'success': False,
                'error': 'User is already registered for this event'
            }), 400

        # Check if training course exists
        training_course = TrainingCourses.query.get(training_id)
        if not training_course:
            return jsonify({
                'success': False,
                'error': 'Event not found'
            }), 404

        # Count current participants
        current_participants = Participates.query.filter_by(
            TrainingID=training_id
        ).count()

        # Check if event is full
        if current_participants >= training_course.MaxParticipants:
            return jsonify({
                'success': False,
                'error': 'Maximum number of participants reached'
            }), 400

        # Create new registration
        new_registration = Participates(
            TrainingID=training_id, 
            UserID=user_id
        )
        db.session.add(new_registration)
        db.session.commit()

        return jsonify({
            'success': True,
            'message': 'Successfully booked event'
        })

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/cancel-event-registration', methods=['DELETE'])
def cancel_event_registration():
    """
    Cancel a user's registration for an event.
    
    JSON Body Parameters:
    - training_id: Training/Event ID (required)
    - user_id: User ID (required)
    
    Returns:
    JSON response with cancellation status
    """
    # Check content type
    if not request.is_json:
        return jsonify({
            'success': False, 
            'error': 'Request must be JSON'
        }), 415
    
    # Parse request data
    data = request.get_json()
    training_id = data.get('training_id')
    user_id = data.get('user_id')

    # Validate input parameters
    if not training_id or not user_id:
        return jsonify({
            'success': False,
            'error': 'Both training_id and user_id are required'
        }), 400

    try:
        # Find the existing registration
        registration = Participates.query.filter_by(
            TrainingID=training_id, 
            UserID=user_id
        ).first()

        # Check if registration exists
        if not registration:
            return jsonify({
                'success': False,
                'error': 'User is not registered for this event'
            }), 400

        # Remove the registration
        db.session.delete(registration)
        db.session.commit()

        return jsonify({
            'success': True,
            'message': 'Successfully cancelled event registration'
        })

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/login', methods=['POST'])
def user_login():
    """
    User login endpoint with authentication and account management.
    
    Request Body:
    - username: User's username
    - password_hash: Hashed password
    
    Returns:
    JSON response with login status and user details
    """
    # Check content type
    if not request.is_json:
        return jsonify({
            'success': False, 
            'error': 'Request must be JSON'
        }), 415

    # Extract login credentials
    data = request.get_json()
    username = data.get('username')
    provided_password_hash = data.get('password_hash')

    # Validate input parameters
    if not username or not provided_password_hash:
        return jsonify({
            'success': False,
            'error': 'Username and password hash are required'
        }), 400

    try:
        # Find user by username
        user = Users.query.filter_by(Username=username).first()

        # Check if user exists
        if not user:
            return jsonify({
                'success': False,
                'error': 'Invalid username or password'
            }), 401

        # Check if account is active
        if not user.is_active:
            return jsonify({
                'success': False,
                'error': 'Account is locked. Please contact support.'
            }), 403

        # Verify password
        if user.PasswordHash != provided_password_hash:
            # Increment login attempts
            user.CountLoginAttempts += 1

            # Lock account after 5 failed attempts
            if user.CountLoginAttempts >= 5:
                user.is_active = False
                db.session.commit()
                return jsonify({
                    'success': False,
                    'error': 'Too many failed login attempts. Account locked.'
                }), 403

            db.session.commit()
            return jsonify({
                'success': False,
                'error': 'Invalid username or password'
            }), 401

        # Successful login: reset login attempts
        user.CountLoginAttempts = 0
        db.session.commit()

        # Return user details
        return jsonify({
            'success': True,
            'user_id': user.UserID,
            'is_admin': user.is_admin
        })

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': 'An unexpected error occurred'
        }), 500

@app.route('/api/admin/create-event', methods=['POST'])
def create_new_event():
    """
    Create a new event with optional automatic translation.
    
    Request Body Parameters:
    - training_course_data: Minimum/Maximum participants
    - event_info_data: Event details
    - event_days_data: List of event dates/times
    - auto_translate: Optional boolean flag for automatic translation
    - input_language: 'DE' or 'EN' (default: 'EN')
    
    Returns:
    JSON response with created event details or error message
    """
    # Parse request data
    data = request.get_json()
    
    # Validate input
    if not data:
        return jsonify({
            'success': False,
            'error': 'No input data provided'
        }), 400

    # Extract translation settings
    auto_translate = data.get('auto_translate', False)
    input_language = data.get('input_language', 'EN').upper()

    try:
        # Create TrainingCourses entry
        training_course_data = data.get('training_course_data', {})
        new_training_course = TrainingCourses(
            MinParticipants=training_course_data.get('min_participants', 7),
            MaxParticipants=training_course_data.get('max_participants', 25)
        )
        db.session.add(new_training_course)
        db.session.flush()  # Get the new TrainingID

        # Handle event information with optional translation
        event_info_data = data.get('event_info_data', {})
        
        # Prepare name and description
        if auto_translate:
            # Use single input with automatic translation
            name = event_info_data.get('name')
            description = event_info_data.get('description')

            if not name or not description:
                return jsonify({
                    'success': False,
                    'error': 'Name and description are required for auto-translation'
                }), 400

            # Perform translation
            if input_language == 'DE':
                name_de = name
                name_en = argo.translate(name, "de", "en")
                description_de = description
                description_en = argo.translate(description, "de", "en")
            else:
                name_en = name
                name_de = argo.translate(name, "en", "de")
                description_en = description
                description_de = argo.translate(description, "en", "de")
        else:
            # Manual input of both languages
            name_de = event_info_data.get('name_de')
            name_en = event_info_data.get('name_en')
            description_de = event_info_data.get('description_de')
            description_en = event_info_data.get('description_en')

            if not (name_de and name_en and description_de and description_en):
                return jsonify({
                    'success': False,
                    'error': 'Both language versions of name and description are required'
                }), 400

        # Create EventInformation entry
        new_event_info = EventInformation(
            NameDE=name_de,
            NameEN=name_en,
            DescriptionDE=description_de,
            DescriptionEN=description_en,
            SubjectArea=event_info_data.get('subject_area', 'Other'),
            EventType=event_info_data.get('event_type', 'Other'),
            describes=new_training_course.TrainingID
        )
        db.session.add(new_event_info)

        # Create EventDays entries
        event_days_data = data.get('event_days_data', [])
        if not event_days_data:
            return jsonify({
                'success': False,
                'error': 'At least one event date is required'
            }), 400

        event_days = []
        for day_info in event_days_data:
            new_event_day = EventDays(
                EventDate=day_info.get('event_date'),
                StartTime=day_info.get('start_time'),
                EndTime=day_info.get('end_time'),
                EventLocation=day_info.get('event_location'),
                LocationFederalState=day_info.get('location_federal_state'),
                consists_of=new_training_course.TrainingID
            )
            event_days.append(new_event_day)
            db.session.add(new_event_day)

        # Commit all changes
        db.session.commit()

        return jsonify({
            'success': True,
            'training_id': new_training_course.TrainingID,
            'message': 'Event created successfully'
        })

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

if __name__ == '__main__':
    app.run(debug=True)
