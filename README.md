/* ===========================
   1️⃣ CREATE DATABASE & USE IT
   =========================== */
CREATE DATABASE Project1;
USE Project1;

/* ===========================
   2️⃣ CREATE TABLES
   =========================== */

/* Users Table */
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    password VARCHAR(255),
    user_type ENUM('JobSeeker', 'Employer')
);

/* Job Seekers Table */
CREATE TABLE job_seekers (
    seeker_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    resume TEXT,
    skills VARCHAR(255),
    experience INT,
    education VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

/* Employers Table */
CREATE TABLE employers (
    employer_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    company_name VARCHAR(255),
    company_address TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

/* Jobs Table */
CREATE TABLE jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    employer_id INT,
    job_title VARCHAR(255),
    job_description TEXT,
    job_type ENUM('Full-time', 'Part-time', 'Contract'),
    location VARCHAR(255),
    salary_range VARCHAR(100),
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id)
);

/* Job Applications Table */
CREATE TABLE job_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    seeker_id INT,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Shortlisted', 'Rejected', 'Hired') DEFAULT 'Pending',
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id)
);

/* Seeker Skills Table */
CREATE TABLE seeker_skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    seeker_id INT,
    skill_name VARCHAR(100),
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id)
);

/* Admin Table */
CREATE TABLE admin (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

/* ===========================
   3️⃣ INSERT DATA
   =========================== */

/* Insert a Job Seeker */
INSERT INTO users (first_name, last_name, email, phone, password, user_type) 
VALUES ('John', 'Doe', 'john.doe@example.com', '555-1234', 'password123', 'JobSeeker');

SET @user_id = LAST_INSERT_ID();

INSERT INTO job_seekers (user_id, resume, skills, experience, education) 
VALUES (@user_id, 'Link to resume.pdf', 'Java, Python', 5, 'Bachelors in Computer Science');

/* Insert an Employer */
INSERT INTO users (first_name, last_name, email, phone, password, user_type)
SELECT 'Jane', 'Smith', 'jane.smith@company.com', '555-5678', 'employerpass', 'Employer'
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE email = 'jane.smith@company.com'
);

SET @user_id = LAST_INSERT_ID();

INSERT INTO employers (user_id, company_name, company_address) 
VALUES (@user_id, 'TechCorp', '123 Tech Street, Silicon Valley');

/* Insert a Job Posting */
INSERT INTO jobs (employer_id, job_title, job_description, job_type, location, salary_range)
VALUES (1, 'Software Developer', 'Develop and maintain web applications', 'Full-time', 'Remote', '$60,000 - $80,000');

/* Insert a Job Application */
INSERT INTO job_applications (job_id, seeker_id)
VALUES (1, 1);

/* ===========================
   4️⃣ FETCH & SEARCH DATA
   =========================== */
//***CONDITIONS***//
/* Get Jobs for Job Seekers Based on Location */
SELECT job_title, job_description, location, salary_range 
FROM jobs 
WHERE location = 'Remote';

//***CONDITIONS***//
/* Get Applications for a Specific Job (Employer) */
SELECT 
    u.first_name AS job_seeker_first_name,
    u.last_name AS job_seeker_last_name,
    a.status AS application_status,
    e.company_name AS employer_company,
    j.job_title AS job_position
FROM job_applications a
JOIN job_seekers js ON a.seeker_id = js.seeker_id
JOIN users u ON js.user_id = u.user_id
JOIN jobs j ON a.job_id = j.job_id
JOIN employers e ON j.employer_id = e.employer_id
WHERE a.job_id = 1;

//***CONDITIONS***//
/* Admin View All Job Postings */
SELECT j.job_title, e.company_name, j.location, j.salary_range, j.post_date
FROM jobs j
JOIN employers e ON j.employer_id = e.employer_id;

//***CONDITIONS***//
/* Advanced Job Search (Using Variables for Dynamic Filters) */
SET @keyword = 'Software';
SET @location = 'Remote';
SET @min_salary = 50000;
SET @max_salary = 100000;
SET @job_type = 'Full-time';

SELECT j.job_id, j.job_title, j.job_description, j.location, j.salary_range, j.job_type, 
       e.company_name, j.post_date
FROM jobs j
JOIN employers e ON j.employer_id = e.employer_id
WHERE 	
    (j.job_title LIKE CONCAT('%', @keyword, '%') OR j.job_description LIKE CONCAT('%', @keyword, '%'))
    AND (j.location LIKE CONCAT('%', @location, '%') OR @location = '')
    AND (j.salary_range BETWEEN @min_salary AND @max_salary OR @min_salary = 0 OR @max_salary = 999999)
    AND (j.job_type = @job_type OR @job_type = '')
ORDER BY j.post_date DESC;

//***CONDITIONS***//
/* Search & Filter Job Seekers by Skills, Experience, Education */
SET @skill = 'Python';
SET @min_experience = 2;
SET @education = 'Bachelors';

SELECT u.first_name, u.last_name, js.seeker_id, js.resume, js.skills, js.experience, js.education
FROM job_seekers js
JOIN users u ON js.user_id = u.user_id
WHERE 
    (js.skills LIKE CONCAT('%', @skill, '%') OR @skill = '')
    AND (js.experience >= @min_experience OR @min_experience = 0)
    AND (js.education LIKE CONCAT('%', @education, '%') OR @education = '')
ORDER BY js.experience DESC;

//***CONDITIONS***//
/*Employers can update the status of job applications (e.g., Shortlisted, Rejected, Hired)*/
UPDATE job_applications 
SET status = 'Shortlisted'  -- Change to 'Rejected' or 'Hired' as needed
WHERE application_id = 1;  -- Change the application ID dynamically

SELECT application_id, job_id, seeker_id, status
FROM job_applications
WHERE application_id = 1;  -- Change as needed

//***CONDITIONS***//
/*Admin can manage job seekers, employers, and job postings (approve/reject job posts, block/unblock users)*/
ALTER TABLE users ADD COLUMN status ENUM('Active', 'Blocked') DEFAULT 'Active';

/*Block user*/
UPDATE users 
SET status = 'Blocked'
WHERE user_id = 2;

/*Unblock user*/
UPDATE users 
SET status = 'Active'
WHERE user_id = 2;

/*View status for Block or Unblock for Users*/
SELECT user_id, first_name, last_name, email, user_type
FROM users 
WHERE status = 'Active';

/*Approving or Rejecting Job Posts*/	
ALTER TABLE jobs ADD COLUMN status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending';

/*Approve Jobs*/
UPDATE jobs 
SET status = 'Approved'
WHERE job_id = 1;

/*Reject Jobs*/
UPDATE jobs 
SET status = 'Rejected'
WHERE job_id = 1;

/*View status for Approve or Rejected for Jobs*/
SELECT job_id, job_title, employer_id, post_date 
FROM jobs 
WHERE status = 'Rejected';

/*Viewing all Employer's*/
SELECT e.employer_id, u.first_name, u.last_name, u.email, e.company_name, e.company_address
FROM employers e
JOIN users u ON e.user_id = u.user_id;

/*Viewing all Jobseeker's*/
SELECT js.seeker_id, u.first_name, u.last_name, u.email, js.skills, js.experience, js.education
FROM job_seekers js
JOIN users u ON js.user_id = u.user_id;

/*Notifications:*/
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,  
    message TEXT, 
    status ENUM('Unread', 'Read') DEFAULT 'Unread', 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

SET @application_id = 1;
SET @new_status = 'Shortlisted';

UPDATE job_applications 
SET status = @new_status
WHERE application_id = @application_id;

-- Get the job seeker's user_id for notification
SET @seeker_id = (SELECT seeker_id FROM job_applications WHERE application_id = @application_id);
SET @user_id = (SELECT user_id FROM job_seekers WHERE seeker_id = @seeker_id);

-- Insert notification
INSERT INTO notifications (user_id, message) 
VALUES (@user_id, CONCAT('Your job application status has changed to ', @new_status));

-- Notify Job Seekers of a New Job Posting--

SET @job_title = 'Software Developer';
SET @job_location = 'Remote';

-- Insert job posting
INSERT INTO jobs (employer_id, job_title, job_description, job_type, location, salary_range)
VALUES (1, @job_title, 'Exciting role in web development.', 'Full-time', @job_location, '$60,000 - $80,000');

-- Notify all job seekers
INSERT INTO notifications (user_id, message)
SELECT u.user_id, CONCAT('New job posted: ', @job_title, ' in ', @job_location)
FROM users u
JOIN job_seekers js ON u.user_id = js.user_id;

/*Update Notifications*/
UPDATE notifications 
SET status = 'Unread' 
WHERE user_id = 1;

/*View Read or Unread*/
SELECT notification_id, message, status, created_at 
FROM notifications 
WHERE user_id = 1  -- Replace with dynamic user_id
ORDER BY created_at desc;

/*Authenticate a User*/
SELECT user_id, user_type 
FROM users 
WHERE email = 'john.doe@example.com' AND password = 'password123';

/*Resume Upload (File Path Storage)*/
ALTER TABLE job_seekers ADD COLUMN resume VARCHAR(255);

/*Updating Resume*/
UPDATE job_seekers 
SET resume = 'uploads/resumes/john_doe_resume.pdf' 
WHERE user_id = 1;

/*View Resume*/
SELECT resume FROM job_seekers WHERE user_id = 1;

/***CONDITIONS***/
/*Creating Tables for Ratings and reviews*/
CREATE TABLE employer_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    employer_id INT,
    seeker_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id),
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id)
);

CREATE TABLE seeker_ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    seeker_id INT,
    employer_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id),
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id)
);

SELECT * FROM employers WHERE employer_id = 2;
INSERT INTO employers (user_id, company_name, company_address) 
VALUES (2, 'TechCorp', '123 Tech Street, Silicon Valley');

/*Inserting Ratings and Reviews*/
INSERT INTO seeker_ratings (seeker_id, employer_id, rating, review) 
VALUES (1, 2, 5, 'Excellent developer, very skilled!');
INSERT INTO employer_reviews (employer_id, seeker_id, rating, review) 
VALUES (2, 1, 4, 'Great company to work with!');

DESC seeker_ratings;
ALTER TABLE seeker_ratings 
ADD COLUMN rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

/*Job Seekers Review*/
SELECT u.first_name, u.last_name, sr.rating, sr.review, sr.rating_date 
FROM seeker_ratings sr
JOIN job_seekers js ON sr.seeker_id = js.seeker_id
JOIN users u ON js.user_id = u.user_id
WHERE sr.seeker_id = 1;


DESC employer_reviews;
ALTER TABLE employer_reviews 
ADD COLUMN review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

/*Employer Review*/
SELECT e.company_name, er.rating, er.review, er.review_date 
FROM employer_reviews er
JOIN employers e ON er.employer_id = e.employer_id
WHERE er.employer_id = 2;
