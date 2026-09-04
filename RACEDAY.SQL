CREATE DATABASE RACEDAY;
Use RaceDay;

DROP TABLE Results;
DROP TABLE Enrolments;
DROP TABLE Categories;
DROP TABLE Events;
DROP TABLE Participants;
DROP TABLE Organisers;

CREATE TABLE Organisers  (
organisers_id INT IDENTITY(1,1) PRIMARY KEY,
organisers_email VARCHAR(100) UNIQUE NOT NULL,
password_hash VARCHAR(100) NOT NULL,
full_name VARCHAR(100) NOT NULL,
organisation_name VARCHAR(100) NULL,
contact_phone VARCHAR (100) NULL,
created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Participants (
participant_id INT IDENTITY(1,1) PRIMARY KEY,
participant_email VARCHAR(255) UNIQUE NOT NULL,
password_hash VARCHAR(255) NOT NULL,
full_name VARCHAR(100) NOT NULL,
date_of_birth DATE,
username VARCHAR(100) UNIQUE NOT NULL,
created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Events (
event_id INT IDENTITY(1,1) PRIMARY KEY,
organisers_id INT NOT NULL,
event_name VARCHAR(255)NOT NULL,
event_description TEXT,
event_date DATE NOT NULL,
event_location VARCHAR(255) NOT NULL,
distance DECIMAL(6,2) NOT NULL,
event_type VARCHAR(50) DEFAULT  'Run' CHECK (event_type IN ('Run','Walk','Cycle')),
created_at DATETIME DEFAULT GETDATE(),
FOREIGN KEY (organisers_id) REFERENCES Organisers(organisers_id)
);

CREATE TABLE Categories (
category_id INT IDENTITY(1,1) PRIMARY KEY,
category_name VARCHAR (100) NOT NULL,
category_description VARCHAR(250) NOT NULL,
category_distance VARCHAR(250) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
event_id INT FOREIGN KEY REFERENCES Events(event_id) ON DELETE CASCADE
);

CREATE TABLE Enrolments (
enrolment_id INT IDENTITY(1,1) PRIMARY KEY,
enrolment_date DATETIME DEFAULT GETDATE(),
status VARCHAR(20) DEFAULT 'Registered' CHECK (status IN ('Registered', 'Completed','Withdrawn')),
participant_id INT FOREIGN KEY REFERENCES Participants(participant_id),
category_id INT FOREIGN KEY REFERENCES Categories(category_id),
);

CREATE TABLE Results (

results_id INT IDENTITY(1,1) PRIMARY KEY,
finish_time TIME NULL,
position INT NULL,
notes TEXT,
updated_by INT NOT NULL,         --organiser who recorded the result
updated_at DATETIME DEFAULT GETDATE(),
enrolment_id INT FOREIGN KEY REFERENCES Enrolments(enrolment_id) ON DELETE CASCADE,
organisers_id INT FOREIGN KEY REFERENCES Organisers (organisers_id)
);

INSERT INTO Organisers (organisers_email, password_hash, full_name, organisation_name, contact_phone) VALUES
('organiser1@raceday.com', 'hashed_password_1', 'Theo Johnson', 'KZN Road Runners', '0821234567'),
('organiser2@raceday.com', 'hashed_password_2', 'Lindiwe Nkosi', 'Cape Town Cycle Club', '0839876543');

SELECT * FROM Organisers


INSERT INTO Participants (participant_email, password_hash, full_name, date_of_birth,username) VALUES
('participant1@raceday.com', 'hashed_password_3', 'Sipho Mthembu', '1995-08-23', 'sipho_m'),
('participant2@raceday.com', 'hashed_password_4', 'Emma van der Merwe', '2002-12-10', 'emma_vdm');

INSERT INTO Events (organisers_id, event_name,event_description, event_date, event_location, distance, event_type) VALUES
(1, 'Durban City Marathon', 'Annual road marathon with 10km, 21km and 42km categories.', '2026-05-10', 'Durban, KwaZulu-Natal', 42.2, 'Run'),
(2, 'Cape Town Cycle Tour', 'Scenic 109km cycle around the Cape Peninsula.', '2026-03-14', 'Cape Town, Western Cape', 109.0, 'Cycle'),
(1, 'Soweto Charity Walk', 'Community charity walk through Soweto.', '2026-07-20', 'Soweto, Gauteng', 10.0, 'Walk');

INSERT INTO Categories (event_id,category_name, category_distance ,category_description) VALUES
(1,'Runners', '10km', 'Short distance road race'),
(1,'Johnny Walker', '21km', 'Half marathon'),
(1,'Sprint Dasher', '42km', 'Full marathon'),
(2,'Cyclers', '10km', 'Full cycle tour distance'),
(3,'Walkers', '10km', 'Standard 10km walking route');

INSERT INTO Enrolments(participant_id,category_id,status) VALUES
(1, 1, 'Registered'),   -- Sipho in Durban 10km
(2, 2, 'Registered'),   -- Emma in Durban 21km
(1, 4, 'Registered'),   -- Sipho in Cape Town Cycle Tour
(2, 5, 'Registered');   -- Emma in Soweto Charity Walk (10km)
 
 INSERT INTO Results (enrolment_id,finish_time,position,notes,updated_by) VALUES
 (1, '00:45:23', 12, 'First race of season', 1),   -- Sipho's 10km result, recorded by Theo
 (2, '01:45:10', 35, 'Personal best', 1);           -- Emma's 21km result, recorded by Theo


SELECT * FROM Organisers;
SELECT * FROM Participants;
SELECT * FROM Events;
SELECT * FROM Enrolments;
SELECT * FROM Categories;
SELECT * FROM Results;


