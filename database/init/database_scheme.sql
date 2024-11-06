/*
 * Delete tables if they already exist
 * Deletion order matters due to foreign key constraints
 */
DROP TABLE IF EXISTS participates;

DROP TABLE IF EXISTS event_information;

DROP TABLE IF EXISTS event_days;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS trainingcourses;

----------------------------------------------------------------------------------
/*
 * Set up the tables with constraints and data types
 */
-- Create the table "trainingcourses"
CREATE TABLE
    IF NOT EXISTS trainingcourses (
        TrainingID bigint AUTO_INCREMENT,
        MinParticipants int DEFAULT 7,
        MaxParticipants int DEFAULT 25,
        PRIMARY KEY (TrainingID),
        CHECK (MinParticipants > 0),
        CHECK (MaxParticipants BETWEEN 1 AND 120),
        CHECK (MaxParticipants > MinParticipants)
    );

-- Create the table "event_information"
CREATE TABLE
    IF NOT EXISTS event_information (
        InformationID bigint AUTO_INCREMENT,
        NameDE varchar(50) NOT NULL,
        NameEN varchar(50) NOT NULL,
        DescriptionDE text,
        DescriptionEN text,
        SubjectArea varchar(25),
        EventType varchar(20) NOT NULL,
        PRIMARY KEY (InformationID),
        CHECK (SubjectArea IN (
            'Computer Science',
            'Electrical Engineering',
            'Mechanical Engineering',
            'Mechatronics',
            'Other'
        )),
        CHECK (EventType IN (
            'Workshop',
            'Seminar',
            'Lecture',
            'Further training',
            'Other'
        ))
    );

-- Create the table "event_days"
CREATE TABLE
    IF NOT EXISTS event_days (
        DayID bigint AUTO_INCREMENT,
        EventDate date NOT NULL,
        StartTime time,
        EndTime time,
        EventLocation varchar(50),
        LocationFederalState varchar(50),
        PRIMARY KEY (DayID),
        CHECK (EndTime > StartTime)
    );

-- Create the table "users"
CREATE TABLE
    IF NOT EXISTS users (
        UserID bigint AUTO_INCREMENT,
        Username varchar(50) NOT NULL,
        PasswordHash varchar(512) NOT NULL,
        FirstName varchar(50) NOT NULL,
        LastName varchar(50) NOT NULL,
        Email varchar(50) NOT NULL,
        SpecializationField varchar(25) NOT NULL,
        is_admin BOOLEAN DEFAULT FALSE,
        is_active BOOLEAN DEFAULT TRUE,
        CountLoginAttempts int DEFAULT 0,
        PRIMARY KEY (UserID),
        UNIQUE KEY unique_username (Username),
        UNIQUE KEY unique_email (Email),
        CHECK (SpecializationField IN (
            'Computer Science',
            'Electrical Engineering',
            'Mechanical Engineering',
            'Mechatronics',
            'Other'
        ))
    );

-- Create the table "participates"
CREATE TABLE
    IF NOT EXISTS participates (
        TrainingID bigint,
        UserID bigint,
        registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (TrainingID, UserID),
        INDEX idx_userid (UserID)
    );

----------------------------------------------------------------------------------
/*
 * Insert Foreign Keys, 
 * Create deletion rules
 */
-- Add columns for foreign key relationships
ALTER TABLE event_days
ADD COLUMN consists_of BIGINT;

ALTER TABLE event_information
ADD COLUMN describes BIGINT;

-- participates foreign keys
ALTER TABLE participates ADD CONSTRAINT fk_participates_training FOREIGN KEY (TrainingID) REFERENCES trainingcourses (TrainingID) ON DELETE CASCADE,
ADD CONSTRAINT fk_participates_user FOREIGN KEY (UserID) REFERENCES users (UserID) ON DELETE CASCADE;

-- event_days foreign key
ALTER TABLE event_days ADD CONSTRAINT fk_eventdays_training FOREIGN KEY (consists_of) REFERENCES trainingcourses (TrainingID) ON DELETE CASCADE;

-- event_information foreign key
ALTER TABLE event_information ADD CONSTRAINT fk_eventinfo_training FOREIGN KEY (describes) REFERENCES trainingcourses (TrainingID) ON DELETE CASCADE;
