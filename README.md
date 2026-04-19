# HealthSys - Database Management System

## Project Description

HealthSys is a database management system designed for the healthcare sector. It allows the management of patients, medical staff, appointments, medical records, hospitalizations, and medication inventory.

The system uses **stored procedures** to automate operations and **views** to simplify data queries, improving efficiency in medical and administrative processes.

---

## Database Structure

The system includes the following main entities:

* Patient
* Medical_Staff
* Specialty
* Department
* Office
* Appointment
* Medical_Record
* Hospitalization
* Medication
* Inventory

---

## Stored Procedures

The following stored procedures were implemented:

* **ScheduleAppointment** → Schedules a new medical appointment
* **RegisterMedicalConsultation** → Records a patient's consultation
* **ManageHospitalization** → Registers a patient hospitalization
* **UpdateMedicalRecord** → Updates medical record notes
* **AssignMedication** → Updates medication inventory

---

## Views

The system includes the following views:

* **V_DailyDoctorSchedule** → Displays daily appointments per doctor
* **V_HospitalOccupancy** → Shows current hospital occupancy
* **V_PatientHistory** → Displays patient medical records
* **V_MedicationInventory** → Shows medication stock and expiration
* **V_DiagnosisStatistics** → Displays diagnosis statistics

---

## How to Use

1. Run the database script to create all tables.
2. Execute stored procedures to insert and manage data.
3. Use views to query and analyze information.
4. Ensure foreign key relationships are correctly implemented.

---

##  System Modules

* **Patient Management**
* **Appointment Scheduling**
* **Medical Records Management**
* **Hospitalization Management**
* **Medication Inventory Control**

---

## Author

Valéry Lilley Durán Restrepo
