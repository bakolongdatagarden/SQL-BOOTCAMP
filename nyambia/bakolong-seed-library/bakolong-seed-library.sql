-- ##############################################
-- DATABASE CREATION
-- ##############################################

-- Create our database
CREATE DATABASE bakolong_seed_library;
-- Verify that worked ♠ 
SHOW DATABASES;
-- Use our database
USE bakolong_seed_library;
-- Verify that worked ♠
SELECT DATABASE();

-- ##############################################
-- TABLE CREATION
-- ##############################################

-- Create table for seed packs counting
CREATE TABLE seed_packs(
	pack_id INT PRIMARY KEY,
	seed_name VARCHAR(50) NOT NULL,
    variety VARCHAR(50) DEFAULT 'mystery',
    quantity ENUM('Few', 'Medium', 'Lots') NOT NULL,
    plant_type ENUM('Vegetable', 'Herb', 'Flower', 'Fruit', 'Other'),
    seed_source VARCHAR(100) DEFAULT 'mystery',
    date_acquired DATE NOT NULL
);

-- Verify that worked ♠
DESC seed_packs;

