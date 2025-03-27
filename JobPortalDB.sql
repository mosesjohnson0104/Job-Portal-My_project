CREATE DATABASE JobPortalDB;
USE JobPortalDB;

CREATE TABLE Jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    job_title VARCHAR(100),
    industry VARCHAR(100),
    location VARCHAR(100),
    posted_date DATE,
    status ENUM('Open', 'Closed') DEFAULT 'Open'
);

CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    contact_number VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    experience_years INT,
    qualification VARCHAR(100)
);

CREATE TABLE Applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    candidate_id INT,
    application_date DATE,
    application_status ENUM('Applied', 'In Review', 'Selected', 'Rejected') DEFAULT 'Applied',
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id)
);

CREATE TABLE Recruiters (
    recruiter_id INT PRIMARY KEY AUTO_INCREMENT,
    recruiter_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    contact_number VARCHAR(15)
);

CREATE TABLE Job_Recruiters (
    job_id INT,
    recruiter_id INT,
    PRIMARY KEY (job_id, recruiter_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    FOREIGN KEY (recruiter_id) REFERENCES Recruiters(recruiter_id)
);

-- Inserting Jobs
INSERT INTO Jobs (job_title, industry, location, posted_date, status)
VALUES 
('Data Analyst', 'IT', 'New York', '2024-02-01', 'Open'),
('Software Developer', 'IT', 'California', '2024-03-01', 'Open'),
('HR Manager', 'HR', 'Texas', '2024-01-15', 'Closed');

-- Inserting Candidates
INSERT INTO Candidates (first_name, last_name, contact_number, email, experience_years, qualification)
VALUES 
('John', 'Doe', '1234567890', 'john.doe@example.com', 3, 'BSc Computer Science'),
('Jane', 'Smith', '0987654321', 'jane.smith@example.com', 5, 'MSc Data Science'),
('Emily', 'Johnson', '5551234567', 'emily.johnson@example.com', 2, 'MBA');

-- Inserting Applications
INSERT INTO Applications (job_id, candidate_id, application_date, application_status)
VALUES 
(1, 1, '2024-02-10', 'Applied'),
(2, 2, '2024-03-05', 'In Review'),
(1, 3, '2024-02-20', 'Rejected');

-- Inserting Recruiters
INSERT INTO Recruiters (recruiter_name, email, contact_number)
VALUES 
('Alice Brown', 'alice.brown@example.com', '9876543210'),
('Michael Green', 'michael.green@example.com', '8765432109');

-- Linking Jobs to Recruiters
INSERT INTO Job_Recruiters (job_id, recruiter_id)
VALUES 
(1, 1),
(2, 2),
(3, 1);

-- Get Active Job Listings
SELECT * FROM Jobs WHERE status = 'Open';

-- Retrieve Candidate Applications
SELECT c.first_name, c.last_name, j.job_title, a.application_status 
FROM Applications a
JOIN Candidates c ON a.candidate_id = c.candidate_id
JOIN Jobs j ON a.job_id = j.job_id;

-- Job Applications by Recruiter
SELECT r.recruiter_name, j.job_title, COUNT(a.application_id) AS total_applications
FROM Job_Recruiters jr
JOIN Recruiters r ON jr.recruiter_id = r.recruiter_id
JOIN Jobs j ON jr.job_id = j.job_id
LEFT JOIN Applications a ON j.job_id = a.job_id
GROUP BY r.recruiter_name, j.job_title;

-- Search Jobs by Industry and Location
SELECT * 
FROM Jobs 
WHERE industry = 'IT' AND location = 'New York';

-- Search Candidates by Experience Range
SELECT * 
FROM Candidates 
WHERE experience_years BETWEEN 2 AND 5;

-- Search Candidates by Qualification
SELECT * 
FROM Candidates 
WHERE qualification LIKE '%Data Science%';

-- Search Applications by Job Title and Status
SELECT c.first_name, c.last_name, j.job_title, a.application_status 
FROM Applications a
JOIN Candidates c ON a.candidate_id = c.candidate_id
JOIN Jobs j ON a.job_id = j.job_id
WHERE j.job_title = 'Data Analyst' AND a.application_status = 'Applied';

-- Search Recruiters by Email Domain
SELECT * 
FROM Recruiters 
WHERE email LIKE '%@example.com';

-- Search Jobs Posted Within the Last 30 Days
SELECT * 
FROM Jobs 
WHERE posted_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Search Jobs without Applications
SELECT * 
FROM Jobs j
LEFT JOIN Applications a ON j.job_id = a.job_id
WHERE a.application_id IS NULL;

-- Search Candidates Who Applied to Multiple Jobs
SELECT c.first_name, c.last_name, COUNT(a.application_id) AS total_applications
FROM Candidates c
JOIN Applications a ON c.candidate_id = a.candidate_id
GROUP BY c.first_name, c.last_name
HAVING total_applications > 1;

-- Search Job Applications by Application Date Range
SELECT * 
FROM Applications 
WHERE application_date BETWEEN '2024-01-01' AND '2024-03-31';

-- Search Top 5 Jobs with the Most Applications
SELECT j.job_title, COUNT(a.application_id) AS total_applications
FROM Jobs j
JOIN Applications a ON j.job_id = a.job_id
GROUP BY j.job_title
ORDER BY total_applications DESC
LIMIT 5;

