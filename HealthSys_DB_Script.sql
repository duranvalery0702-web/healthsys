USE HealthSys;


CREATE TABLE Patient (
    id_patient INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    document VARCHAR(50) UNIQUE,
    birth_date DATE,
    gender VARCHAR(20),
    address VARCHAR(150),
    phone VARCHAR(20),
    email VARCHAR(100),
    blood_type VARCHAR(5),
    allergies TEXT,
    family_history TEXT,
    medical_insurance VARCHAR(100)
);

CREATE TABLE Specialty (
    id_specialty INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    training_requirements TEXT,
    equipment TEXT
);

CREATE TABLE Department (
    id_department INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager VARCHAR(100),
    location VARCHAR(100),
    extension VARCHAR(20),
    schedule VARCHAR(100)
);

CREATE TABLE Bed (
    id_bed INT AUTO_INCREMENT PRIMARY KEY,
    room VARCHAR(50),
    type VARCHAR(50),
    status VARCHAR(50),
    features TEXT
);

CREATE TABLE Diagnosis (
    code_cie10 VARCHAR(10) PRIMARY KEY,
    description TEXT,
    category VARCHAR(100),
    symptoms TEXT,
    treatments TEXT
);

CREATE TABLE Treatment (
    id_treatment INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    description TEXT,
    duration VARCHAR(50),
    contraindications TEXT,
    precautions TEXT
);

CREATE TABLE Medication (
    id_medication INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100),
    active_ingredient VARCHAR(100),
    presentation VARCHAR(100),
    concentration VARCHAR(50),
    pharmaceutical_form VARCHAR(100),
    administration_route VARCHAR(100),
    laboratory VARCHAR(100),
    indications TEXT,
    contraindications TEXT
);

CREATE TABLE Office (
    id_office INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100),
    id_department INT,
    capacity INT,
    equipment TEXT,
    FOREIGN KEY (id_department) REFERENCES Department(id_department)
);

CREATE TABLE Medical_Staff (
    id_doctor INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    id_specialty INT,
    subspecialty VARCHAR(100),
    academic_degree VARCHAR(100),
    university VARCHAR(100),
    years_experience INT,
    schedule VARCHAR(100),
    id_office INT,
    status VARCHAR(20),
    FOREIGN KEY (id_specialty) REFERENCES Specialty(id_specialty),
    FOREIGN KEY (id_office) REFERENCES Office(id_office)
);

CREATE TABLE Medical_Record (
    id_record INT AUTO_INCREMENT PRIMARY KEY,
    id_patient INT,
    consultation_date DATE,
    id_doctor INT,
    reason TEXT,
    symptoms TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4,2),
    heart_rate INT,
    oxygen_saturation INT,
    diagnosis TEXT,
    treatment TEXT,
    notes TEXT,
    FOREIGN KEY (id_patient) REFERENCES Patient(id_patient),
    FOREIGN KEY (id_doctor) REFERENCES Medical_Staff(id_doctor)
);

CREATE TABLE Appointment (
    id_appointment INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    time TIME,
    duration INT,
    id_patient INT,
    id_doctor INT,
    id_office INT,
    id_specialty INT,
    appointment_type VARCHAR(50),
    status VARCHAR(50),
    notes TEXT,
    FOREIGN KEY (id_patient) REFERENCES Patient(id_patient),
    FOREIGN KEY (id_doctor) REFERENCES Medical_Staff(id_doctor),
    FOREIGN KEY (id_office) REFERENCES Office(id_office),
    FOREIGN KEY (id_specialty) REFERENCES Specialty(id_specialty)
);

CREATE TABLE Hospitalization (
    id_hospitalization INT AUTO_INCREMENT PRIMARY KEY,
    id_patient INT,
    admission_date DATETIME,
    reason TEXT,
    id_doctor INT,
    admission_diagnosis TEXT,
    room VARCHAR(50),
    discharge_date DATETIME,
    notes TEXT,
    FOREIGN KEY (id_patient) REFERENCES Patient(id_patient),
    FOREIGN KEY (id_doctor) REFERENCES Medical_Staff(id_doctor)
);

CREATE TABLE Inventory (
    id_inventory INT AUTO_INCREMENT PRIMARY KEY,
    id_medication INT,
    batch VARCHAR(50),
    expiration_date DATE,
    quantity INT,
    location VARCHAR(100),
    price DECIMAL(10,2),
    FOREIGN KEY (id_medication) REFERENCES Medication(id_medication)
);

SHOW TABLES 

DELIMITER //

CREATE PROCEDURE ScheduleAppointment(
    IN p_date DATE,
    IN p_time TIME,
    IN p_id_patient INT,
    IN p_id_doctor INT
)
BEGIN
    INSERT INTO Appointment (date, time, id_patient, id_doctor, status)
    VALUES (p_date, p_time, p_id_patient, p_id_doctor, 'Scheduled');
END //

CREATE PROCEDURE RegisterMedicalConsultation(
    IN p_id_patient INT,
    IN p_id_doctor INT,
    IN p_diagnosis TEXT,
    IN p_treatment TEXT
)
BEGIN
    INSERT INTO Medical_Record (id_patient, id_doctor, consultation_date, diagnosis, treatment)
    VALUES (p_id_patient, p_id_doctor, NOW(), p_diagnosis, p_treatment);
END //

CREATE PROCEDURE ManageHospitalization(
    IN p_id_patient INT,
    IN p_id_doctor INT,
    IN p_reason TEXT
)
BEGIN
    INSERT INTO Hospitalization (id_patient, id_doctor, admission_date, reason)
    VALUES (p_id_patient, p_id_doctor, NOW(), p_reason);
END //

CREATE PROCEDURE UpdateMedicalRecord(
    IN p_id_record INT,
    IN p_notes TEXT
)
BEGIN
    UPDATE Medical_Record
    SET notes = p_notes
    WHERE id_record = p_id_record;
END //

CREATE PROCEDURE AssignMedication(
    IN p_id_medication INT,
    IN p_quantity INT
)
BEGIN
    UPDATE Inventory
    SET quantity = quantity - p_quantity
    WHERE id_medication = p_id_medication;
END //

DELIMITER ;

SHOW PROCEDURE STATUS WHERE Db = 'HealthSys';

CREATE VIEW V_DailyDoctorSchedule AS
SELECT date, time, id_doctor, id_patient
FROM Appointment;

CREATE VIEW V_HospitalOccupancy AS
SELECT room, COUNT(*) AS patients
FROM Hospitalization
WHERE discharge_date IS NULL
GROUP BY room;

CREATE VIEW V_PatientHistory AS
SELECT *
FROM Medical_Record;

CREATE VIEW V_MedicationInventory AS
SELECT m.brand_name, i.quantity, i.expiration_date
FROM Medication m
JOIN Inventory i ON m.id_medication = i.id_medication;

CREATE VIEW V_DiagnosisStatistics AS
SELECT diagnosis, COUNT(*) AS total
FROM Medical_Record
GROUP BY diagnosis;


SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';
