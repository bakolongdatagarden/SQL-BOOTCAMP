CREATE DATABASE nyambia_herbs;
SHOW DATABASES;
SELECT DATABASE();
USE nyambia_herbs;

CREATE TABLE herbs_birdseye(
	herb_id INT PRIMARY KEY AUTO_INCREMENT,
	common_name VARCHAR(100) NOT NULL,
    latin_name VARCHAR(100) NOT NULL, 
    variety VARCHAR(100) DEFAULT 'unknown',
);