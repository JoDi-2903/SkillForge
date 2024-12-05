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
        PasswordHash varchar(512),
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

----------------------------------------------------------------------------------
/*
 * Fill the tables with example data
 */
INSERT INTO `trainingcourses` (`TrainingID`, `MinParticipants`, `MaxParticipants`) VALUES
(1, 7, 25),
(2, 7, 25),
(3, 7, 25),
(4, 7, 25),
(5, 7, 25),
(6, 7, 25),
(7, 7, 25),
(8, 7, 25);

INSERT INTO `users` (`UserID`, `Username`, `PasswordHash`, `FirstName`, `LastName`, `Email`, `SpecializationField`, `is_admin`, `is_active`, `CountLoginAttempts`) VALUES
(1, 'JoDi2903', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Jonathan', 'Diebel', 'notamail@email.com', 'Computer Science', 1, 1, 0),
(2, 'HitAndRun', NULL, 'Noah Lion', 'Meier', 'MrMeier@email.com', 'Computer Science', 0, 1, 0),
(3, 'Nehper', NULL, 'Nicki Matthias', 'Schuhmacher', 'MrSchuhmacher@email.com', 'Electrical Engineering', 0, 1, 0),
(4, 'Nutman', NULL, 'Juergen', 'Salz', 'MrSalz@email.com', 'Mechatronics', 0, 1, 0),
(5, 'Auftragsgriller30', '753692ec36adb4c794c973945eb2a99c1649703ea6f76bf259abb4fb838e013e', 'Arne Laudris', 'Fränznick', 'MrLaudris@email.com', 'Electrical Engineering', 1, 1, 0),
(6, 'DrSaumweber', NULL, 'Vicent', 'Saumweber', 'DrSaumweber@email.com', 'Mechanical Engineering', 0, 1, 0),
(7, 'TheMan', NULL, 'Timo', 'Wehrle-Brunner', 'MrWehrle-Brunner@email.com', 'Other', 0, 1, 0),
(8, 'Fish', NULL, 'Emma', 'Fischer', 'MsFischer@email.com', 'Computer Science', 0, 1, 0),
(9, 'Miller', NULL, 'Lukas ', 'Mueller', 'MrMueller@email.com', 'Computer Science', 0, 1, 0),
(10, 'Schmiede', NULL, 'Hannah ', 'Schmidt', 'MsSchmidt@email.com', 'Computer Science', 0, 1, 0),
(11, 'Spinnenweber', NULL, 'Maximilian', 'Weber', 'MrWeber@email.com', 'Computer Science', 0, 1, 0),
(12, 'Beck', NULL, 'Leonie ', 'Becker', 'MsBecker@email.com', 'Computer Science', 0, 1, 0),
(13, 'Schnitt', NULL, 'Elias ', 'Schneider', 'MrSchneider@email.com', 'Electrical Engineering', 0, 1, 0),
(14, 'Waffel', NULL, 'Sophie ', 'Wagner', 'MsWagner@email.com', 'Electrical Engineering', 0, 1, 0),
(15, 'Rasierer', NULL, 'Felix Braun', 'Braun', 'DrBraun@email.com', 'Mechanical Engineering', 0, 1, 0),
(16, 'Freddy', NULL, 'Charlotte ', 'Krueger', 'MsKrueger@email.com', 'Mechanical Engineering', 0, 1, 0),
(17, 'DrHofmann', NULL, 'Paul Hofmann', 'Hofmann', 'MrHofmann@email.com', 'Mechanical Engineering', 0, 1, 0),
(18, 'DrMeier', NULL, 'Anna Meier', 'Meier', 'DrMeier@email.com', 'Mechanical Engineering', 0, 1, 0),
(19, 'Keller', NULL, 'Jonas ', 'Keller', 'MrKeller@email.com', 'Mechatronics', 0, 1, 0),
(20, 'Falke', NULL, 'Laura ', 'Vogel', 'MsVogel@email.com', 'Mechatronics', 0, 1, 0),
(21, 'Hoffe', NULL, 'Tim ', 'Hoffmann', 'MrHoffmann@email.com', 'Mechatronics', 0, 1, 0),
(22, 'Anwalt', NULL, 'Lina ', 'Richter', 'MsRichter@email.com', 'Mechatronics', 0, 1, 0),
(23, 'Arche', NULL, 'Noah ', 'Schulz', 'MrSchulz@email.com', 'Other', 0, 1, 0),
(24, 'Lehmann', NULL, 'Marie ', 'Lehmann', 'MsLehmann@email.com', 'Other', 0, 1, 0),
(25, 'King', NULL, 'Elias ', 'Koenig', 'MrKoenig@email.com', 'Other', 0, 1, 0),
(26, 'Farmer', NULL, 'Clara ', 'Bauer', 'MsBauer@email.com', 'Other', 0, 1, 0),
(27, 'Lorenz', NULL, 'Simon', 'Lorenz', 'MrLorenz@email.com', 'Other', 0, 1, 0),
(28, 'Frankonia', NULL, 'Julia ', 'Frank', 'MsFrank@email.com', 'Electrical Engineering', 0, 1, 0);

INSERT INTO `event_days` (`DayID`, `EventDate`, `StartTime`, `EndTime`, `EventLocation`, `LocationFederalState`, `consists_of`) VALUES
(1, '2024-10-31', '10:00:00', '18:00:00', 'Heilbronn', 'BadenWuettenberg', 1),
(2, '2024-11-01', '08:00:00', '16:00:00', 'Heilbronn', 'BadenWuettenberg', 1),
(3, '2024-06-12', '06:00:00', '15:00:00', 'Berlin', 'Berlin', 2),
(4, '2024-07-30', '08:00:00', '20:00:00', 'Nuernberg', 'Bayern', 3),
(5, '2024-07-31', '08:00:00', '16:00:00', 'Nuernberg', 'Bayern', 3),
(6, '2024-09-19', '10:00:00', '16:00:00', 'Muenchen', 'Bayern', 3),
(7, '2024-09-20', '08:00:00', '18:00:00', 'Muenchen', 'Bayern', 3),
(8, '2024-09-21', '08:00:00', '18:00:00', 'Muenchen', 'Bayern', 3),
(9, '2024-12-02', '10:00:00', '22:00:00', 'Loerrach', 'Baden Wuettenberg', 4),
(10, '2024-12-03', '10:00:00', '22:00:00', 'Loerrach', 'Baden Wuettenberg', 4),
(11, '2024-02-01', '10:00:00', '18:00:00', 'Hannover', 'Niedersachsen', 5),
(12, '2024-02-02', '08:00:00', '14:00:00', 'Hannover', 'Niedersachsen', 5),
(13, '2024-05-06', '10:00:00', '18:00:00', 'Hannover', 'Niedersachsen', 5),
(14, '2024-05-07', '08:00:00', '14:00:00', 'Hannover', 'Niedersachsen', 5),
(15, '2024-08-21', '08:00:00', '20:00:00', 'Hamburg', 'Hamburg', 6),
(16, '2024-06-10', '10:00:00', '20:00:00', 'Dresden', 'Sachsen', 7),
(17, '2024-06-11', '08:00:00', '17:00:00', 'Dresden', 'Sachsen', 7),
(18, '2024-06-12', '08:00:00', '15:00:00', 'Dresden', 'Sachsen', 7),
(19, '2024-11-21', '10:00:00', '18:00:00', 'Koeln', 'Nordrhein Westfalen', 7),
(20, '2024-11-22', '08:00:00', '17:00:00', 'Koeln', 'Nordrhein Westfalen', 7),
(21, '2024-11-23', '08:00:00', '15:00:00', 'Koeln', 'Nordrhein Westfalen', 7),
(22, '2024-09-10', '06:00:00', '16:00:00', 'Mannheim', 'Baden Wuettenberg', 8),
(23, '2024-09-11', '08:00:00', '20:00:00', 'Mannheim', 'Baden Wuettenberg', 8);

INSERT INTO `event_information` (`InformationID`, `NameDE`, `NameEN`, `DescriptionDE`, `DescriptionEN`, `SubjectArea`, `EventType`, `describes`) VALUES
(1, 'Mikroelektronik und Sensorik', 'Microelectronics and Sensor Technology', 'Die Vorlesung Mikroelektronik und Sensorik bietet eine umfassende Einführung in die Grundlagen und Anwendungen moderner mikroelektronischer Systeme und Sensoriktechnologien. Ziel ist es, die Studierenden mit den Prinzipien, Konzepten und Herausforderungen in der Entwicklung von Mikroelektronik und Sensortechnologien vertraut zu machen, die in einer Vielzahl von Industriebereichen – von der Automobilindustrie bis zur Medizintechnik – zum Einsatz kommen.', 'The lecture Microelectronics and Sensor Technology offers a comprehensive introduction to the fundamentals and applications of modern microelectronic systems and sensor technologies. The aim is to familiarize students with the principles, concepts and challenges in the development of microelectronics and sensor technologies that are used in a wide range of industrial sectors - from the automotive industry to medical technology.', 'Electrical Engineering', 'Lecture', 1),
(2, 'Qualitätsverbesserungsprojekte I', 'Quality Improvement Projects I', 'Die Vorlesung Qualitätsverbesserungsprojekte I – Six-Sigma-Methode bietet eine umfassende Einführung in die Six-Sigma-Methode als eine der effektivsten und weit verbreiteten Methoden zur Qualitätsverbesserung in der Industrie. Sie richtet sich an Studierende, die lernen möchten, wie man kontinuierliche Verbesserungsprozesse gestaltet, um die Qualität von Produkten und Dienstleistungen nachhaltig zu erhöhen. Im Mittelpunkt steht die systematische Anwendung von Six-Sigma-Techniken zur Identifikation und Reduzierung von Fehlerquellen sowie zur Optimierung von Geschäftsprozessen.', 'The lecture Quality Improvement Projects I - Six Sigma Method provides a comprehensive introduction to the Six Sigma method as one of the most effective and widely used methods for quality improvement in industry. It is aimed at students who want to learn how to design continuous improvement processes in order to sustainably increase the quality of products and services. The focus is on the systematic application of Six Sigma techniques to identify and reduce sources of error and to optimize business processes.', 'Other', 'Workshop', 2),
(3, 'Höhere Festigkeitslehre und Werkstoffmechanik', 'Advanced strength of materials and mechanics', 'Die Vorlesung Höhere Festigkeitslehre und Werkstoffmechanik bietet eine vertiefte Auseinandersetzung mit den grundlegenden Konzepten und fortgeschrittenen Methoden der Festigkeitslehre und Werkstoffmechanik. Sie richtet sich an Studierende, die bereits über grundlegende Kenntnisse in der Festigkeitslehre verfügen und diese durch eine intensivere Betrachtung komplexer Phänomene und Anwendungen erweitern möchten. Ziel ist es, ein vertieftes Verständnis für die mechanischen Eigenschaften von Werkstoffen und deren Verhalten unter verschiedenen Belastungsbedingungen zu vermitteln, um Ingenieuren die Fähigkeit zu verleihen, strukturmechanische Probleme effizient zu analysieren und zu lösen.', 'The lecture Advanced Strength of Materials and Mechanics of Materials offers an in-depth examination of the fundamental concepts and advanced methods of strength of materials and mechanics of materials. It is aimed at students who already have a basic knowledge of strength of materials and would like to extend this by taking a closer look at complex phenomena and applications. The aim is to provide an in-depth understanding of the mechanical properties of materials and their behavior under different loading conditions in order to give engineers the ability to efficiently analyze and solve structural-mechanical problems.', 'Mechanical Engineering', 'Seminar', 3),
(4, 'Embedded Systems im Kraftfahrzeug', 'Embedded Systems in a car', 'Die Vorlesung Embedded Systems im Kraftfahrzeug bietet eine tiefgehende Einführung in die Funktionsweise und die Anwendung von eingebetteten Systemen in modernen Kraftfahrzeugen. Sie richtet sich an Studierende der Ingenieurwissenschaften, die ein Verständnis für die Rolle von Mikroprozessoren, Steuergeräten und Softwarearchitekturen in der Fahrzeugtechnik entwickeln möchten. Ziel der Vorlesung ist es, den Studierenden die Grundlagen und fortgeschrittenen Technologien der Embedded Systems zu vermitteln, die in heutigen Fahrzeugen für eine Vielzahl von Funktionen von der Motorsteuerung bis hin zu Fahrerassistenzsystemen verantwortlich sind.', 'The lecture Embedded Systems in Motor Vehicles provides an in-depth introduction to the functionality and application of embedded systems in modern motor vehicles. It is aimed at engineering students who wish to develop an understanding of the role of microprocessors, control units and software architectures in vehicle technology. The aim of the course is to teach students the fundamentals and advanced technologies of embedded systems, which are responsible for a wide range of functions in todays vehicles, from engine control to driver assistance systems.', 'Electrical Engineering', 'Lecture', 4),
(5, 'Leistungselektronik und Energiespeicher', 'Power electronics and energy storage', 'Die Vorlesung Leistungselektronik und Energiespeicher bietet eine fundierte Einführung in die Schlüsseltechnologien der modernen Leistungselektronik und deren Anwendung in Energiespeicherlösungen. Im Mittelpunkt stehen die grundlegenden Konzepte und Technologien, die für die Entwicklung, den Betrieb und die Optimierung von elektrischen Antriebssystemen, Energiespeichern und nachhaltigen Energiesystemen erforderlich sind. Die Vorlesung richtet sich an Studierende der Elektrotechnik und verwandter Disziplinen, die ein tiefes Verständnis für die Wechselwirkungen zwischen Leistungselektronik und Energiespeichertechnologien erwerben möchten.', 'The lecture Power Electronics and Energy Storage provides a sound introduction to the key technologies of modern power electronics and their application in energy storage solutions. The focus is on the fundamental concepts and technologies required for the development, operation and optimization of electric drive systems, energy storage systems and sustainable energy systems. The lecture is aimed at students of electrical engineering and related disciplines who wish to gain a deep understanding of the interactions between power electronics and energy storage technologies.', 'Mechatronics', 'Further training', 5),
(6, 'Software-Qualitätstechnik', 'Software Quality Engineering', 'Die Vorlesung Software Quality Engineering vermittelt den Studierenden die notwendigen Kenntnisse und Fähigkeiten, um Softwarequalitätsprozesse zu verstehen, zu implementieren und kontinuierlich zu verbessern. Dabei liegt der Fokus auf der Anwendung von systematischen Methoden zur Sicherstellung einer hohen Qualität in Softwareentwicklungsprozessen, von der Planung und Konzeption bis hin zur Implementierung und Wartung. Die Studierenden lernen, wie sie Qualität als integralen Bestandteil des gesamten Softwareentwicklungszyklus in einem agilen und nicht-agilen Umfeld umsetzen können.', 'The Software Quality Engineering course provides students with the necessary knowledge and skills to understand, implement and continuously improve software quality processes. The focus is on the application of systematic methods to ensure high quality in software development processes, from planning and design through to implementation and maintenance. Students learn how to implement quality as an integral part of the entire software development cycle in an agile and non-agile environment.', 'Computer Science', 'Further training', 6),
(7, 'Systementwicklung und Architektur', 'System development and architecture', 'Die Vorlesung Systementwicklung und Architektur vermittelt den Studierenden die grundlegenden Konzepte und Methoden, die erforderlich sind, um komplexe Softwaresysteme zu entwickeln und deren Architektur zu entwerfen. Ziel ist es, den Studierenden das nötige Wissen zu vermitteln, um Softwareprojekte effizient zu planen, zu strukturieren und erfolgreich umzusetzen. Der Fokus liegt auf dem Entwurf von Systemarchitekturen, die sowohl funktionale als auch nicht-funktionale Anforderungen berücksichtigen und den gesamten Lebenszyklus eines Systems – von der Anforderungsanalyse bis hin zur Wartung – abdecken.', 'The Systems Development and Architecture course teaches students the basic concepts and methods required to develop complex software systems and design their architecture. The aim is to provide students with the necessary knowledge to efficiently plan, structure and successfully implement software projects. The focus is on the design of system architectures that take into account both functional and non-functional requirements and cover the entire life cycle of a system - from requirements analysis to maintenance.', 'Computer Science', 'Other', 7),
(8, 'Verarbeitung von Kunststoffen', 'Processing of plastics', 'Die Vorlesung Verarbeitung von Kunststoffen vermittelt den Studierenden fundierte Kenntnisse über die verschiedenen Techniken und Verfahren zur Herstellung von Kunststoffprodukten. Ziel ist es, die Studierenden mit den physikalischen, chemischen und technologischen Grundlagen der Kunststoffverarbeitung vertraut zu machen und ihnen zu zeigen, wie Kunststoffe in industriellen Prozessen verarbeitet werden, um Produkte mit spezifischen Eigenschaften zu erhalten. Die Studierenden lernen, wie sie geeignete Verfahren für unterschiedliche Kunststoffarten auswählen und die Produktionsprozesse optimieren können.', 'The lecture Processing of Plastics provides students with in-depth knowledge of the various techniques and processes used to manufacture plastic products. The aim is to familiarize students with the physical, chemical and technological principles of plastics processing and to show them how plastics are processed in industrial processes in order to obtain products with specific properties. Students learn how to select suitable processes for different types of plastic and how to optimize production processes.', 'Mechanical Engineering', 'Workshop', 8);

INSERT INTO `participates` (`TrainingID`, `UserID`, `registration_date`) VALUES
(1, 1, CURRENT_TIMESTAMP),
(1, 2, CURRENT_TIMESTAMP),
(1, 3, CURRENT_TIMESTAMP),
(1, 4, CURRENT_TIMESTAMP),
(1, 5, CURRENT_TIMESTAMP),
(1, 6, CURRENT_TIMESTAMP),
(1, 7, CURRENT_TIMESTAMP),
(1, 8, CURRENT_TIMESTAMP),
(1, 9, CURRENT_TIMESTAMP),
(1, 10, CURRENT_TIMESTAMP),
(1, 11, CURRENT_TIMESTAMP),
(1, 12, CURRENT_TIMESTAMP),
(1, 13, CURRENT_TIMESTAMP),
(1, 14, CURRENT_TIMESTAMP),
(1, 15, CURRENT_TIMESTAMP),
(1, 16, CURRENT_TIMESTAMP),
(1, 17, CURRENT_TIMESTAMP),
(1, 18, CURRENT_TIMESTAMP),
(1, 19, CURRENT_TIMESTAMP),
(1, 20, CURRENT_TIMESTAMP),
(1, 21, CURRENT_TIMESTAMP),
(1, 22, CURRENT_TIMESTAMP),
(1, 23, CURRENT_TIMESTAMP),
(1, 24, CURRENT_TIMESTAMP),
(1, 25, CURRENT_TIMESTAMP),
(2, 26, CURRENT_TIMESTAMP),
(2, 27, CURRENT_TIMESTAMP),
(2, 28, CURRENT_TIMESTAMP),
(3, 11, CURRENT_TIMESTAMP),
(3, 12, CURRENT_TIMESTAMP),
(3, 13, CURRENT_TIMESTAMP),
(3, 14, CURRENT_TIMESTAMP),
(3, 15, CURRENT_TIMESTAMP),
(3, 16, CURRENT_TIMESTAMP),
(3, 17, CURRENT_TIMESTAMP),
(4, 21, CURRENT_TIMESTAMP),
(5, 22, CURRENT_TIMESTAMP),
(5, 23, CURRENT_TIMESTAMP),
(5, 24, CURRENT_TIMESTAMP),
(6, 25, CURRENT_TIMESTAMP),
(7, 26, CURRENT_TIMESTAMP),
(8, 27, CURRENT_TIMESTAMP);

----------------------------------------------------------------------------------
-- END OF FILE
