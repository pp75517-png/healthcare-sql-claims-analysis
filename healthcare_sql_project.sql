-- Create Database
CREATE DATABASE healthcare_sql;
USE healthcare_sql;

-- Patients Table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    state VARCHAR(50)
);

INSERT INTO patients VALUES
(1, 45, 'Male', 'California'),
(2, 30, 'Female', 'Texas'),
(3, 65, 'Male', 'New York'),
(4, 52, 'Female', 'Florida');

-- Claims Table
CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    patient_id INT,
    claim_amount DECIMAL(10,2),
    claim_date DATE,
    status VARCHAR(20)
);

INSERT INTO claims VALUES
(101, 1, 1200.50, '2024-01-15', 'Paid'),
(102, 2, 850.00, '2024-01-20', 'Denied'),
(103, 3, 3000.75, '2024-02-10', 'Paid'),
(104, 1, 450.00, '2024-02-18', 'Denied'),
(105, 4, 2200.00, '2024-03-05', 'Paid');

-- Denials Table
CREATE TABLE denials (
    denial_id INT PRIMARY KEY,
    claim_id INT,
    denial_code VARCHAR(20),
    denial_reason VARCHAR(100),
    denied_amount DECIMAL(10,2)
);

INSERT INTO denials VALUES
(1, 102, 'CO-50', 'Non-covered service', 850.00),
(2, 104, 'CO-97', 'Invalid diagnosis code', 450.00);

-- Claims & Denials Join
SELECT 
    p.patient_id,
    p.gender,
    p.state,
    c.claim_id,
    c.claim_amount,
    c.status,
    d.denial_code,
    d.denial_reason,
    d.denied_amount
FROM patients p
JOIN claims c ON p.patient_id = c.patient_id
LEFT JOIN denials d ON c.claim_id = d.claim_id;

-- Denial Rate KPI
SELECT 
    COUNT(DISTINCT d.claim_id) * 100.0 / COUNT(DISTINCT c.claim_id)
        AS denial_rate_percentage
FROM claims c
LEFT JOIN denials d ON c.claim_id = d.claim_id;

-- Total Denied Revenue
SELECT SUM(denied_amount) AS total_denied_revenue
FROM denials;
