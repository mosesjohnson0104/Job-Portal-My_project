# Job Portal Project

## Description
This is a job portal project that allows users to search and apply for jobs, while employers can post job listings and manage applications. The platform aims to bridge the gap between job seekers and recruiters by providing an intuitive and efficient hiring process.

## Features
- User authentication (Login/Signup)
- Job listing and searching
- Job application submission
- Resume upload and management
- Employer dashboard to post and manage jobs
- Notification system for job alerts
- Ratings and reviews for employers and job seekers
- Admin panel for user and job post management
- Responsive UI/UX for a seamless experience

## Technologies Used
- Frontend: React.js, Tailwind CSS
- Backend: Node.js, Express.js
- Database: MySQL
- Authentication: JWT (JSON Web Token)
- Deployment: AWS / Heroku

## Database Schema
The job portal database consists of multiple tables to manage users, job seekers, employers, job postings, applications, notifications, and ratings. Below are the key tables:

### Users Table
- Stores user details with a user type (`JobSeeker`, `Employer`, `Admin`).

### Job Seekers Table
- Stores job seeker details including resume, skills, experience, and education.

### Employers Table
- Stores employer details including company name and address.

### Jobs Table
- Stores job listings with details like title, description, type, location, salary, and employer reference.

### Job Applications Table
- Manages applications with status updates (`Pending`, `Shortlisted`, `Rejected`, `Hired`).

### Notifications Table
- Stores notifications for job seekers and employers regarding job status updates.

### Ratings & Reviews Tables
- `employer_reviews`: Allows job seekers to rate and review employers.
- `seeker_ratings`: Allows employers to rate and review job seekers.

## Installation
### Prerequisites:
- Node.js installed
- MySQL database set up

### Steps:
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/job-portal.git
   cd job-portal
   ```
2. Install dependencies:
   ```sh
   npm install
   ```
3. Set up environment variables in a `.env` file:
   ```env
   DB_HOST=your_database_host
   DB_USER=your_database_user
   DB_PASSWORD=your_database_password
   DB_NAME=Project1
   JWT_SECRET=your_jwt_secret_key
   ```
4. Run the database script to create tables:
   ```sh
   mysql -u your_user -p your_database < database.sql
   ```
5. Run the development server:
   ```sh
   npm start
   ```
6. Open `http://localhost:3000` in your browser.

## Contribution
Feel free to contribute by submitting issues or pull requests.

## License
This project is licensed under the MIT License.

## Contact
For inquiries, contact us at `your-email@example.com`.

