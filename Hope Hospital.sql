--**PART 1 ** --
--Create the database for Hope Hospital
CREATE DATABASE HopeHospital;
--Switch to hospital's database
USE HopeHospital;
GO
--Create the different tables for the required entities
--Create table for patients
CREATE TABLE Patients(
	PatientID int NOT NULL PRIMARY KEY,
	PatientFirstName nvarchar(50) NOT NULL,
	PatientMiddleName nvarchar(50) NULL,
	PatientLastName nvarchar(50) NOT NULL,
	PatientGender varchar(20) NULL,
	PatientDOB date NOT NULL,
	PatientAddress nvarchar(100) NOT NULL,
	PatientInsuranceNo nvarchar(10) UNIQUE NOT NULL,
	CONSTRAINT CHK_UKInsuranceNumber CHECK (PatientInsuranceNo LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-D]'),
	PatientEmailAddress nvarchar(50) UNIQUE NULL CHECK (PatientEmailAddress LIKE '%_@_%._%'),
	PatientTelephone nvarchar(20) NULL CHECK (PatientTelephone LIKE '[0-9]%' AND PatientTelephone LIKE '[0-9]%[0-9]' AND PatientTelephone LIKE '[0-9]%[0-9]%[0-9]%'),
	PatientUserName nvarchar(50) UNIQUE NOT NULL,
	PatientPasswordHash BINARY(64) UNIQUE NOT NULL CHECK (LEN(PatientPasswordHash) >= 10),
	Salt UNIQUEIDENTIFIER,
	PatientLeftDate date NULL CHECK (PatientLeftDate <= GetDate()));

--DROP PROCEDURE uspAddPatient;
--Create procedure for the password hashing
CREATE PROCEDURE uspAddPatient
	@PatientUserName NVARCHAR(50),
	@PatientPasswordHash NVARCHAR(50),
	@PatientID int,
	@PatientFirstName nvarchar(50),
	@PatientMiddleName nvarchar(50),
	@PatientLastName nvarchar(50),
	@PatientGender varchar(20),
	@PatientDOB date,
	@PatientAddress nvarchar(100),
	@PatientInsuranceNo nvarchar(10),
	@PatientEmailAddress nvarchar(50),
	@PatientTelephone nvarchar(20),
	@PatientLeftDate date
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @salt UNIQUEIDENTIFIER=NEWID()
		INSERT INTO Patients(PatientUserName, PatientPasswordHash, Salt, PatientID, PatientFirstName, PatientMiddleName, PatientLastName, PatientGender, PatientDOB, PatientAddress, PatientInsuranceNo, PatientEmailAddress, PatientTelephone,PatientLeftDate)  
		VALUES(@PatientUserName,HASHBYTES('SHA2_512', @PatientPasswordHash+CAST(@salt AS NVARCHAR(36))), @salt, @PatientID, @PatientFirstName, @PatientMiddleName, @PatientLastName, @PatientGender, @PatientDOB, @PatientAddress,@PatientInsuranceNo,@PatientEmailAddress, @PatientTelephone,@PatientLeftDate);
		PRINT 'Form submitted successfully.';
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		PRINT 'Error while submitting form: ' + ERROR_MESSAGE();
	END CATCH
END;

--Inserting patients details using stored procedure
EXEC uspAddPatient
	@PatientUserName = 'Anie',
	@PatientPasswordHash = 'abcdefghij!1',
	@PatientID = 1001,
	@PatientFirstName = 'Anie',
	@PatientMiddleName = 'Sun',
	@PatientLastName = 'Kan',
	@PatientGender = 'Female',
	@PatientDOB = '1998-03-22',
	@PatientAddress = '2 Fallowfield',
	@PatientInsuranceNo = 'TH043643D',
	@PatientEmailAddress = 'askan@gmail.com',
	@PatientTelephone = '07356845010',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Lei',
	@PatientPasswordHash = 'betteryearsah1!',
	@PatientID = 1002,
	@PatientFirstName = 'Lei',
	@PatientMiddleName = 'Moon',
	@PatientLastName = 'Gham',
	@PatientGender = 'Prefer not to say',
	@PatientDOB = '1987-03-23',
	@PatientAddress = '3 Fallowfield',
	@PatientInsuranceNo = 'AB123932A',
	@PatientEmailAddress = 'lei@gmail.com',
	@PatientTelephone = '07356845030',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Reese',
	@PatientPasswordHash = 'reachoutfan2!',
	@PatientID = 1003,
	@PatientFirstName = 'Reese',
	@PatientMiddleName = 'star',
	@PatientLastName = 'Spoon',
	@PatientGender = 'Female',
	@PatientDOB = '1980-03-24',
	@PatientAddress = '4 Fallowfield',
	@PatientInsuranceNo = 'TH123456C',
	@PatientEmailAddress = 'reese@gmail.com',
	@PatientTelephone = '07356945010',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Shmuel',
	@PatientPasswordHash = 'rexinoutlife2!',
	@PatientID = 1004,
	@PatientFirstName = 'Shmuel',
	@PatientMiddleName = 'Life',
	@PatientLastName = 'Rabbi',
	@PatientGender = 'Male',
	@PatientDOB = '1977-03-25',
	@PatientAddress = '5 Fallowfield',
	@PatientInsuranceNo = 'AB123455D',
	@PatientEmailAddress = 'shmuel@gmail.com',
	@PatientTelephone = '07356845010',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Simon',
	@PatientPasswordHash = 'simonjesusall1$',
	@PatientID = 1005,
	@PatientFirstName = 'Simon',
	@PatientMiddleName = 'zeal',
	@PatientLastName = 'Peter',
	@PatientGender = 'Male',
	@PatientDOB = '1967-08-26',
	@PatientAddress = '6 Fallowfield',
	@PatientInsuranceNo = 'QW183476D',
	@PatientEmailAddress = 'simon@gmail.com',
	@PatientTelephone = '07356848210',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'James',
	@PatientPasswordHash = 'jamesjesusll2$',
	@PatientID = 1006,
	@PatientFirstName = 'James',
	@PatientMiddleName = 'Triangle',
	@PatientLastName = 'Thunder',
	@PatientGender = 'Female',
	@PatientDOB = '1983-11-27',
	@PatientAddress = '7 Fallowfield',
	@PatientInsuranceNo = 'QR123456C',
	@PatientEmailAddress = 'james@gmail.com',
	@PatientTelephone = '07583848210',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Travis',
	@PatientPasswordHash = 'travisgreenesmusic1$',
	@PatientID = 1007,
	@PatientFirstName = 'Travis',
	@PatientMiddleName = 'Music',
	@PatientLastName = 'Greenes',
	@PatientGender = 'Male',
	@PatientDOB = '1986-10-17',
	@PatientAddress = '7 Wilmslow road',
	@PatientInsuranceNo = 'SH125556C',
	@PatientEmailAddress = 'travisgreenes@gmail.com',
	@PatientTelephone = '07583849375',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Tony',
	@PatientPasswordHash = 'tonyfreshqll2$',
	@PatientID = 1008,
	@PatientFirstName = 'Tony',
	@PatientMiddleName = NULL,
	@PatientLastName = 'Fresh',
	@PatientGender = 'Male',
	@PatientDOB = '1993-11-02',
	@PatientAddress = '17 Fallowfield',
	@PatientInsuranceNo = 'QD133456C',
	@PatientEmailAddress = 'tony@gmail.com',
	@PatientTelephone = '07589648210',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Maverick',
	@PatientPasswordHash = 'maverickcityll2$',
	@PatientID = 1009,
	@PatientFirstName = 'Maverick',
	@PatientMiddleName = 'Love',
	@PatientLastName = 'City',
	@PatientGender = 'Female',
	@PatientDOB = '1993-12-27',
	@PatientAddress = '737 Wilmslow',
	@PatientInsuranceNo = 'RQ123466C',
	@PatientEmailAddress = 'maverick@gmail.com',
	@PatientTelephone = '07583849510',
	@PatientLeftDate = NULL;

EXEC uspAddPatient
	@PatientUserName = 'Ricky',
	@PatientPasswordHash = 'rickydonaldll2$',
	@PatientID = 1010,
	@PatientFirstName = 'Ricky',
	@PatientMiddleName = NULL,
	@PatientLastName = 'Donald',
	@PatientGender = 'Male',
	@PatientDOB = '1973-01-27',
	@PatientAddress = '47 Fallowfield',
	@PatientInsuranceNo = 'TH123458C',
	@PatientEmailAddress = NULL,
	@PatientTelephone = NULL,
	@PatientLeftDate = NULL;

---Creation of trigger for Patients that left the hospital
--Return Patient's table before the patient archive trigger
SELECT *
FROM Patients

---If a patient's status becomes inactive, move the data to the Archive table.
--Create the Archive table for Inactive Patients
CREATE TABLE ArchivePatients(
	APatientID int NOT NULL PRIMARY KEY,
	APatientFirstName nvarchar(50) NOT NULL,
	APatientMiddleName nvarchar(50) NULL,
	APatientLastName nvarchar(50) NOT NULL,
	APatientGender varchar(20) NULL,
	APatientDOB date NOT NULL,
	APatientAddress nvarchar(100) NOT NULL,
	APatientInsuranceNo nvarchar(10) UNIQUE NOT NULL,
	CONSTRAINT CHK_UKInsuranceNumberA CHECK (APatientInsuranceNo LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-D]'),
	APatientEmailAddress nvarchar(50) UNIQUE NULL CHECK (APatientEmailAddress LIKE '%_@_%._%'),
	APatientTelephone nvarchar(20) NULL CHECK (APatientTelephone LIKE '[0-9]%' AND APatientTelephone LIKE '[0-9]%[0-9]' AND APatientTelephone LIKE '[0-9]%[0-9]%[0-9]%'),
	APatientUserName nvarchar(50) UNIQUE NOT NULL,
	APatientPasswordHash BINARY(64) UNIQUE NOT NULL CHECK (LEN(APatientPasswordHash) >= 10),
	ASalt UNIQUEIDENTIFIER,
	APatientLeftDate date NULL CHECK (APatientLeftDate <= GetDate()));

--Trigger to delete the patient's details when the there is a left date.
--This left date will be initiated by the User interface software
DROP TRIGGER IF EXISTS patient_update_status;
GO
CREATE TRIGGER patient_update_status
ON Patients
AFTER UPDATE
AS 
BEGIN
	DELETE FROM Patients
	WHERE PatientLeftDate IS NOT NULL;

END;

--Trigger to move the inactive patients to the archives
DROP TRIGGER IF EXISTS patient_left_archive;
GO
CREATE TRIGGER patient_left_archive
ON Patients
AFTER DELETE
AS 
BEGIN
	INSERT INTO ArchivePatients
	SELECT *
	FROM
	DELETED 
END;

--Execute the trigger by updating the details of Patient 1007 and 1009.
UPDATE Patients
SET PatientLeftDate = '2024-01-31'
WHERE PatientID = 1007;

UPDATE Patients
SET PatientLeftDate = '2024-02-27'
WHERE PatientID = 1009;


--Return both tables after the patient archive trigger
SELECT *
FROM Patients

SELECT *
FROM ArchivePatients

--Create Department table
CREATE TABLE Department(
	DepartmentID int NOT NULL PRIMARY KEY,
	Specialty nvarchar(50) NOT NULL,
	FloorLevel nvarchar(15) NOT NULL,
	Sponsor nvarchar(15) NULL);

--Create Doctors table
CREATE TABLE Doctor(
	DoctorID int NOT NULL PRIMARY KEY,
	DoctorFirstName nvarchar(50) NOT NULL,
	DoctorMiddleName nvarchar(50) NULL,
	DoctorLastName nvarchar(50) NOT NULL,
	DepartmentID int NOT NULL FOREIGN KEY(DepartmentID) REFERENCES Department(DepartmentID),
	Certification nvarchar(100) NOT NULL);

--Create Doctor's Available table
CREATE TABLE Available(
	AvailableID int NOT NULL PRIMARY KEY,
	DoctorID int NOT NULL FOREIGN KEY(DoctorID) REFERENCES Doctor(DoctorID),
	AppointmentDateStartTime datetime NOT NULL,
	AppointmentDateEndTime datetime NOT NULL,
	AvailableStatus char(15) NOT NULL);

--Create Diagnosis table
CREATE TABLE Diagnosis(
	DiagnosisID int NOT NULL PRIMARY KEY,
	DiagnosisDetails nvarchar(100) NOT NULL,
	Medicines nvarchar(100) NOT NULL,
	Allergies nvarchar(100) NOT NULL,
	PrescribedDate date NOT NULL);

--Create Appointment table
CREATE TABLE Appointment(
	AppointmentID int NOT NULL PRIMARY KEY,
	PatientID int NOT NULL FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
	DoctorID int NOT NULL FOREIGN KEY(DoctorID) REFERENCES Doctor(DoctorID),
	AvailableID int NOT NULL FOREIGN KEY(AvailableID) REFERENCES Available(AvailableID),
	DiagnosisID int NULL FOREIGN KEY(DiagnosisID) REFERENCES Diagnosis(DiagnosisID),
	AppointmentDate date NOT NULL,
	AppointmentStatus char(10) NOT NULL);

--Create Past Appointment table
CREATE TABLE PastAppointment(
	AppointmentID int NOT NULL PRIMARY KEY,
	PatientID int NOT NULL FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
	DoctorID int NOT NULL FOREIGN KEY(DoctorID) REFERENCES Doctor(DoctorID),
	AvailableID int NOT NULL FOREIGN KEY(AvailableID) REFERENCES Available(AvailableID),
	DiagnosisID int NULL FOREIGN KEY(DiagnosisID) REFERENCES Diagnosis(DiagnosisID),
	AppointmentDate date NOT NULL,
	FeedbackDetails nvarchar(100) NULL);

---Inserting values into other tables

INSERT INTO Department
VALUES(3001,'Gastroenterologist','Second','NHS'),(3002,'Oncologist','Fourth','NatWest'),(3003,'Cardiologist','Fourth','NatWest'),(3004,'General Practitioner', 'First', NULL),
(3005,'Dermatologist', 'First', NULL),(3006,'Psychiatrist', 'Third','Lloyds'), (3007,'Pathologist','Fifth', NULL), (3008,'Ophthalmologist','Fifth', NULL),
(3009,'Neurologist','Third','Lloyds'),(3010,'Pediatrician','Second','NHS');

INSERT INTO Doctor
VALUES(2001,'New','Ney','Amsterdam',3001,'Certified Medical Assistant'),(2002,'Grey','Hey','Anatomy',3001, 'Certified Medical Assistant'),(2003,'Emily','Sey','Sharpe',3002, 'Certified Medical Assistant'),
(2004,'Benjamin','Bey','Button',3004,'Certified Medical Assistant'),(2005,'Franklin','Fey','Super',3004, 'Certified Medical Assistant'),(2006,'Robert','Rey','Knowles',3005, 'Certified Medical Assistant'),
(2007,'William','Psi','Abule',3006, 'Certified Medical Assistant'),(2008,'James','John','Greene',3007, 'Certified Medical Assistant, Certificate of Completion of Specialist Training (CCST)'),
(2009,'Olivia','Feyi','Tola',3008,'Certified Medical Assistant'),(2010,'Alex','Mc','Queen',3009, 'Certified Medical Assistant'),
(2011,'Sophia','James','Ava',3010, 'Certified Medical Assistant');


INSERT INTO Available
VALUES(5001,2001,'2024-02-05 09:00:00','2024-02-05 09:30:00', 'Not Available'),(5002,2002,'2024-02-06 10:00:00','2024-02-06 10:30:00', 'Not Available'),
(5003,2002,'2024-02-05 09:00:00','2024-02-05 09:30:00', 'Not Available'), (5004,2001,'2024-03-06 10:00:00','2024-03-06 10:30:00', 'Not Available'),
(5005,2003,'2024-02-26 12:00:00','2024-02-26 12:30:00', 'Not Available'), (5006,2003,'2024-03-07 10:00:00','2024-03-07 10:30:00', 'Not Available'),
(5007,2003,'2024-02-28 12:00:00','2024-02-28 12:30:00', 'Not Available'), (5008,2001,'2024-04-01 10:00:00','2024-04-01 10:30:00', 'Not Available'),
(5010, 2001, GETDATE(), DATEADD(MINUTE, 30, GETDATE()), 'Available'), (5011,2001,'2024-08-25 11:00:00','2024-02-25 11:30:00', 'Not Available'),
(5012,2005,'2024-01-02 10:00:00','2024-01-02 10:30:00', 'Not Available'),(5013,2005,'2024-01-14 10:00:00','2024-01-14 10:30:00', 'Not Available'),
(5014,2005,'2024-02-20 10:00:00','2024-02-20 10:30:00', 'Not Available'),(5015,2005,'2024-02-01 10:00:00','2024-02-01 10:30:00', 'Not Available'),
(5016,2003,'2024-02-16 10:00:00','2024-02-16 10:30:00', 'Available'),(5017,2003,'2024-03-17 10:00:00','2024-03-17 10:30:00', 'Available'),
(5018,2003,'2024-02-23 10:00:00','2024-02-23 10:30:00', 'Available'),(5019,2003,'2024-02-13 10:00:00','2024-02-13 10:30:00', 'Available');

INSERT INTO Diagnosis
VALUES(9001,'Rashes as a result of allergies, fever. Gastric issues','Malarone, Astymin,Panadol','Rashes','2024-02-05'),
(9002,'Rashes as a result of allergies, fever. Gastric issues','Malarone, Panadol','Rashes','2024-02-06'),
(9003,'Rashes as a result of allergies, fever. Gastric issues','Malarone, Vitamin C','Rashes','2024-02-05'),
(9004,'Rashes as a result of allergies, fever. Gastric issues','Malarone','Rashes','2024-03-06'),
(9005,'Pain in the breast, fever. Breast Cancer','Antihistamines, Vitamin C','Flu','2024-02-26'),
(9006,'Pain in the breast, fever. Breast Cancer','Antihistamines, Vitamin C','Flu','2024-03-07'),
(9007,'Rashes, fever. Skin Cancer','Malarone, Vitamin C','Rashes','2024-02-28'),
(9008,'Rashes have reduced. Gastric issues','Malarone, Vitamin C','Rashes','2024-04-01'),
(9009,'Diarrhea, fever','Doxycycline, Vitamin C','Food allergy','2024-01-02'),
(9010,'Fever, headache, malaria','Loratadine, Vitamin C','Flu','2024-01-14'),
(9011,'Rashes, acne. Skin irritation ','Doxycycline, Vitamin C','Rashes','2024-02-20'),
(9012,'Rashes, acne. Skin irritation reduced','Doxycycline, Vitamin C','Rashes','2024-02-01'),
(9013,'Pain in the breast, fever. Breast Cancer','Chloroquine, Vitamin C','Flu','2024-02-16'),
(9014,'Pain in the breast, fever. Breast Cancer','Imodium, Vitamin C','Flu','2024-03-17'),
(9015,'Rashes, fever. Skin Cancer','Malarone, Vitamin E','Rashes','2024-02-23'),
(9016,'Rashes, fever. Skin Cancer','Malarone, Vitamin C','Rashes','2024-02-13');


INSERT INTO Appointment
VALUES(4001,1001,2001,5001,9001,'2024-02-05','Completed'),(4002,1002,2001,5002,9002,'2024-02-06','Completed'),(4003,1002,2002,5003, 9003,'2024-02-05','Completed'),
(4004,1003,2002,5004, 9004,'2024-03-06','Completed'),(4005,1003,2003,5005,9005,'2024-02-26','Completed'),(4006,1004,2003,5006, 9006,'2024-03-07','Completed'),
(4007,1005,2003,5007, 9007,'2024-02-28','Completed'),(4008,1002,2001,5008,9008,'2024-04-01','Completed'),(4009,1002,2001,5010, NULL,GETDATE(),'Pending'),
(4010,1005,2003,5010, NULL,GETDATE(),'Pending'),(4011,1006,2002,5010, NULL,GETDATE(),'Pending'),(4012,1006,2001,5011, NULL,'2024-08-25','Pending'),
(4013,1006,2004,5012,9009,'2024-01-02','Completed'),(4014,1005,2005,5013,9010,'2024-01-14','Completed'),(4015,1002,2005,5014,9011,'2024-02-20','Completed'),
(4016,1003,2004,5015,9012,'2024-02-01','Completed');

--Stored Procedure for booking an appointment and the system to check the doctor's availability
CREATE PROCEDURE uspBookAppointment
    @AppointmentID int,
	@PatientID int,
	@DoctorID int,
	@AvailableID int,
	@DiagnosisID int,
	@AppointmentDate date,
	@AppointmentStatus char(10)
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO Appointment (AppointmentID, PatientID, DoctorID, AvailableID, DiagnosisID, AppointmentDate, AppointmentStatus)
	SELECT @AppointmentID, @PatientID, @DoctorID, @AvailableID, @DiagnosisID, @AppointmentDate, @AppointmentStatus
	WHERE @DoctorID IN (SELECT DoctorID FROM Available WHERE AvailableStatus = 'Available');

END 

--Insert values into the appointment table by executing the procedure BookAppointment
EXEC uspBookAppointment
    @AppointmentID = 4017,
	@PatientID = 1003,
	@DoctorID  = 2003,
	@AvailableID = 5016,
	@DiagnosisID = 9013,
	@AppointmentDate = '2024-02-16',
	@AppointmentStatus = 'Completed';

EXEC uspBookAppointment
    @AppointmentID = 4018,
	@PatientID = 1003,
	@DoctorID  = 2003,
	@AvailableID = 5017,
	@DiagnosisID = 9014,
	@AppointmentDate = '2024-03-17',
	@AppointmentStatus = 'Completed';

EXEC uspBookAppointment
    @AppointmentID = 4019,
	@PatientID = 1004,
	@DoctorID  = 2003,
	@AvailableID = 5018,
	@DiagnosisID = 9015,
	@AppointmentDate = '2024-02-23',
	@AppointmentStatus = 'Completed';

EXEC uspBookAppointment
    @AppointmentID = 4020,
	@PatientID = 1004,
	@DoctorID  = 2003,
	@AvailableID = 5018,
	@DiagnosisID = 9016,
	@AppointmentDate = '2024-02-13',
	@AppointmentStatus = 'Completed';

--View all created tables
SELECT *
FROM Patients;
SELECT *
FROM Doctor;
SELECT *
FROM Department;
SELECT *
FROM Appointment;
SELECT *
FROM Available;
SELECT *
FROM Diagnosis;
SELECT *
FROM PastAppointment;
SELECT *
FROM ArchivePatients;

--**PART 2 ** --

---Question 2----
--Add the constraint to check that the appointment is not in the past
--This code is executed before inserting values into the appointment table
--It ensures that the patients do not book appointments with date in the past.
ALTER TABLE Appointment
ADD CONSTRAINT APPT_CURRENT CHECK (AppointmentDate >= GETDATE());

---Question 3---
--Patients older than 40 and have cancer in their diagnosis
--This code is executed after all the past completed appointments have been moved to the PastAppointment table.
SELECT p.PatientID,p.PatientFirstName,p.PatientLastName,DATEDIFF(year, p.PatientDOB, GETDATE()) AS Age,pa.AppointmentDate,d.DiagnosisDetails
FROM Patients as p INNER JOIN PastAppointment AS pa
ON p.PatientID = pa.PatientID INNER JOIN Diagnosis AS d
ON pa.DiagnosisID = d.DiagnosisID
WHERE DATEDIFF(year, p.PatientDOB, GETDATE()) > 40 AND d.DiagnosisDetails LIKE '%cancer%';

--Question 4
--4a)Search the database of the hospital for matching character strings by name of medicine.
--Sort with most recent medicine prescribed date first.
CREATE FUNCTION find_data_based_On_medicine (@name nvarchar(50))
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT p.PatientID, pa.DoctorID, d.DiagnosisDetails, d.Medicines, d.PrescribedDate
		FROM Patients AS p INNER JOIN PastAppointment AS pa 
		ON p.PatientID = pa.PatientID INNER JOIN Diagnosis AS d 
		ON pa.DiagnosisID = d.DiagnosisID 
		WHERE LOWER(d.Medicines) LIKE '%' + LOWER(@name) + '%'		
	);

-- Search the hospital database for records with the medicine malarone
SELECT * 
FROM find_data_based_On_medicine('malarone')
ORDER BY PrescribedDate DESC;

--4b) Return full list of diagnosis and allergies for a specific patient who has an appointment today
CREATE PROCEDURE patient_medical_record
    @PatientID INT
AS
    SET NOCOUNT ON;
	BEGIN
    DECLARE @Today DATE = GETDATE();

    SELECT 
       p.PatientID,p.PatientFirstName,p.PatientLastName,a.DoctorID,d.DiagnosisDetails,d.Allergies,d.Medicines, a.AppointmentID, a.AppointmentDate
    FROM 
        Patients p
    INNER JOIN 
     (SELECT * FROM Appointment
		UNION ALL
		SELECT * FROM PastAppointment) AS a
	ON p.PatientID = a.PatientID
    LEFT JOIN Diagnosis d 
	ON a.DiagnosisID = d.DiagnosisID
	LEFT JOIN PastAppointment AS pa
	ON d.DiagnosisID= pa.DiagnosisID
	WHERE p.PatientID = @PatientID AND (CONVERT(DATE, a.AppointmentDate) = @Today OR a.AppointmentDate IS NOT NULL)
	END;

--Checking details for patient 1002 who has an appointment today.
EXEC patient_medical_record @PatientID = 1002;



--4c) Update the details of an existing doctor
--Show doctor's details before executing procedure
SELECT * 
FROM Doctor
WHERE DoctorID = 2004;

--Create the procedure to update doctor's details
CREATE PROCEDURE update_doctor @doctorid int, @cert nvarchar(100)
AS
	SET NOCOUNT ON
	BEGIN TRANSACTION
	BEGIN TRY
		UPDATE Doctor
		SET Certification = @cert
		WHERE DoctorID = @doctorid
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT ERROR_MESSAGE()
	END CATCH;

--Execute code
EXEC update_doctor @doctorid = 2004, @cert = 'Certified Medical Assistant,Certificate of Completion of Specialist Training (CCST)';

--Show doctor's details after executing procedure
SELECT * 
FROM Doctor
WHERE DoctorID = 2004;

--4d)Delete appointment whose status is already completed
--Delete from the Appointment table and save in the Past Appointmnet table
--Stored procedure to move completed appointments to the Past Appointment table
CREATE PROCEDURE archiveAppointment
AS
	SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
    -- Create a temporary table
    CREATE TABLE TempPastAppointment (
        AppointmentID INT,
        PatientID INT,
        DoctorID INT,
        AvailableID INT,
		DiagnosisID INT,
        AppointmentDate DATETIME
    );

    -- Delete and output deleted records into the temporary table--
    DELETE FROM Appointment
    OUTPUT deleted.AppointmentID, deleted.PatientID, deleted.DoctorID, deleted.AvailableID, deleted.DiagnosisID, deleted.AppointmentDate
    INTO TempPastAppointment
    WHERE AppointmentStatus = 'Completed';

    -- Insert from temporary table to the PastAppointment table
    INSERT INTO PastAppointment (AppointmentID, PatientID, DoctorID, AvailableID, DiagnosisID, AppointmentDate)
    SELECT AppointmentID, PatientID,DoctorID, AvailableID, DiagnosisID, AppointmentDate
    FROM TempPastAppointment;
    -- Drop the temporary staging table
    DROP TABLE TempPastAppointment;
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT ERROR_MESSAGE()
	END CATCH;

--Input example data for this.
EXEC archiveAppointment;

--Check after executing procedure
SELECT *
FROM PastAppointment;

--Question 5
--View all the appointments, doctors, specialty, feedback

-- Create the stored procedure for Patient to provide feedback once the appointment is completed and moved to the Past Appointmant table.
CREATE PROCEDURE uspFeedback
	@Patientid INT,
    @review NVARCHAR(MAX)

AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PastAppointment
    SET FeedbackDetails = @review
    WHERE PatientID = @Patientid

END;

EXEC uspFeedback @Patientid = 1002, @review = 'Great Service from the staff'; 

--Create the View for all the appointments, doctors, specialty
CREATE VIEW allAppointmentsDetails
AS
SELECT a.AppointmentID,a.AppointmentDate,do.DoctorID,do.DoctorFirstName, do.DoctorLastName, a.PatientID, de.DepartmentID,de.Specialty, pa.FeedbackDetails
FROM 
	(SELECT * FROM Appointment
	UNION ALL
	SELECT * FROM PastAppointment) AS a
LEFT JOIN Doctor AS do
ON a.DoctorID = do.DoctorID
LEFT JOIN Department AS de
ON do.DepartmentID = de.DepartmentID
--May not need this part
LEFT JOIN PastAppointment AS pa
ON a.AppointmentID = pa.AppointmentID

--Query the view to see the results
SELECT *
FROM allAppointmentsDetails;

--QUESTION 6
--Trigger to change state of Appointment to Available when cancelled
--If the patient cancels the appointment, AppointmentStatus will update to cancelled and this will trigger the update of the corresponding... 
--Available Status from "Not Available" to "Available" in the Available table, so that another patient can use that slot.
--Check before executing trigger
SELECT *
FROM Appointment AS ap INNER JOIN Available AS av
ON ap.AvailableID = av.AvailableID
WHERE ap.AppointmentID = 4012;


--Create trigger---
DROP TRIGGER IF EXISTS cancel_appt;
GO
CREATE TRIGGER cancel_appt 
ON Appointment
AFTER UPDATE
AS
BEGIN
    IF UPDATE(AppointmentStatus) -- Check if the status column was updated
    BEGIN
        DECLARE @AppointmentID INT;
        
        SELECT @AppointmentID = inserted.AvailableID
        FROM inserted
        WHERE inserted.AppointmentStatus = 'Cancelled';
        
        IF @AppointmentID IS NOT NULL
        BEGIN
            UPDATE Available
            SET AvailableStatus = 'Available'
            WHERE AvailableID = @AppointmentID;
        END;
    END;
END;

UPDATE Appointment
SET AppointmentStatus = 'Cancelled'
WHERE AppointmentID = 4012;

--Check after executing trigger
SELECT *
FROM Appointment AS ap INNER JOIN Available AS av
ON ap.AvailableID = av.AvailableID
WHERE ap.AppointmentID = 4012;

--Question 7
--Identify the number of completed appointments with the Gastroenterologists

SELECT COUNT(*) AS NumberOfCompletedGastroenterologistsAppointments
FROM (
    SELECT pa.*,d.DoctorFirstName, d.DoctorLastName, d.Certification, de.*
    FROM PastAppointment AS pa INNER JOIN Doctor AS d 
	ON pa.DoctorID = d.DoctorID INNER JOIN Department AS de 
	ON d.DepartmentID = de.DepartmentID
    WHERE de.Specialty = 'Gastroenterologist'
) AS Appointments;

--Question 8
--DATA INTEGRITY AND CONCURRENCY
--Stored Procedures
--Triggers
--Constriants in tables
---DATABASE SECURITY----
--Recommendations for database security
--1) Use of salting and hashing to store  patient's password
--2)Schemas and moving of Data base objects
--Creation of schema for the Patient
CREATE SCHEMA Patient;
GO
ALTER SCHEMA Patient TRANSFER dbo.Patients
ALTER SCHEMA Patient TRANSFER dbo.uspAddPatient
ALTER SCHEMA Patient TRANSFER dbo.uspBookAppointment
ALTER SCHEMA Patient TRANSFER dbo.cancel_appt

--Creation of schema for the Doctor
CREATE SCHEMA Doctor
GO
ALTER SCHEMA Doctor TRANSFER dbo.Doctor
ALTER SCHEMA Doctor TRANSFER dbo.Diagnosis
ALTER SCHEMA Doctor TRANSFER dbo.Available
ALTER SCHEMA Doctor TRANSFER dbo.update_doctor
ALTER SCHEMA Doctor TRANSFER dbo.patient_medical_record
--Test new schema
SELECT *
FROM Patient.Patients;


--3)Creation of Users and Roles and privileges
--Every database user will have a login to authenticate their acccess
--Sample login for Anie
CREATE LOGIN Anie
WITH PASSWORD = 'abcdefghij!1'

--Create database user for Sample patient Anie
CREATE USER Anie FOR LOGIN Anie;
GO
--Create Role for Patient and asssign the role to Anie
CREATE ROLE PatientRole;
--Further conditions need to be implemented so that Patient can see only data with their id.
GRANT SELECT,UPDATE ON SCHEMA :: Patient
TO PatientRole
--Add Anie to the Patient role
ALTER ROLE PatientRole ADD MEMBER Anie;

--Create Database user for the doctors
CREATE USER doctor_user WITHOUT LOGIN;---Restrict DELETE PRIVILEGES

--Create Role for Patient and asssign the role to Anie
CREATE ROLE DoctorRole;
--Further conditions need to be implemented so that Patient can see only data with their id.
GRANT SELECT,UPDATE ON SCHEMA :: Doctor
TO doctor_user

---Database Back up and Recovery-----
--1)The database back up file was created.
--File Name: 
-- 2)Maintenance plan was created
--Code to clear the error for the maintenance plan wizard
SP_CONFIGURE 'SHOW ADVANCE',1
GO
RECONFIGURE WITH OVERRIDE
GO
SP_CONFIGURE 'AGENT XPs',1
GO
RECONFIGURE WITH OVERRIDE
GO

--3)Ensure successful restoration of the back up.
--Ensure the back up is not corrupted
BACKUP DATABASE HopeHospital
TO DISK ='C:\ADB Backup\HopeHospital_Full_Backup.bak'
WITH CHECKSUM

--Ensure that it can be restored
RESTORE VERIFYONLY
FROM DISK ='C:\ADB Backup\HopeHospital_Full_Backup.bak'
WITH CHECKSUM;

