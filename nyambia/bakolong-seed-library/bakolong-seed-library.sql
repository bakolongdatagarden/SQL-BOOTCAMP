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

SELECT * FROM seed_packs;

-- ##############################################
-- ALTER TABLE
-- add auto_increment to pack_id
-- ##############################################
ALTER TABLE seed_packs MODIFY pack_id INT AUTO_INCREMENT;
DESC seed_packs;

-- ##############################################
-- UPDATE 
-- ##############################################
-- Changed specific naming of different DPL branch locations to to general "DPL Seed Library"
SET SQL_SAFE_UPDATES = 0;
UPDATE seed_packs 
SET 
    seed_source = 'DPL Seed Library'
WHERE
    seed_source = 'Dallas Public Library';

SET SQL_SAFE_UPDATES = 1;

-- To-Do
-- Shell, bag and insert purple snap pea seeds, and asian long bean seeds.

-- ##############################################
-- RETURNING
-- ##############################################
SHOW DATABASES;
USE bakolong_seed_library;
SELECT * FROM seed_packs;

-- ################################################
-- ALTER TABLE:
-- plant_type column now includes Trees & Shrubs
-- ################################################

ALTER TABLE seed_packs 
MODIFY COLUMN plant_type ENUM('Vegetable', 'Herb', 'Flower', 'Fruit', 'Trees & Shrubs', 'Other');
DESC seed_packs;
SELECT * FROM seed_packs;

-- ################################################
-- UPDATE seed_packs
-- ################################################
SET SQL_SAFE_UPDATES = 0;
UPDATE seed_packs
SET seed_source = 'DPL Seed Library'
WHERE seed_source = 'Dallas Public Library';
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM seed_packs;

-- ################################################
-- DELETE OUR DATA
-- ################################################

DELETE FROM seed_packs;
SELECT * FROM seed_packs;

-- ################################################
-- Session: 8/2/2025
-- ################################################

-- ################################################
-- ALTER
-- ################################################

/*
◘ Task: ALTER the seed_packs table to MODIFY the 'quantity' column.
	• We will attempt to make quantity counts more precise by adding a 5-tier counting system.
*/

ALTER TABLE seed_packs
MODIFY COLUMN quantity ENUM('Very Few (1-5)', 'Few (6-20)', 'Medium (21-75)', 'Lots (76-200)', 'Bulk (200+)');
DESC seed_packs;

/*
We previously wiped out data for a clean slate, now let's make a new entry with our changes.
*/

SELECT * FROM seed_packs;

/*
With our new entry, pack_id is staring at 10 instead of 1. Just going to drop the original table and recreate 
with our new parameters.
*/

SET SQL_SAFE_UPDATES = 0;

DROP TABLE seed_packs;

CREATE TABLE seed_packs(
	pack_id INT PRIMARY KEY AUTO_INCREMENT,
	seed_name VARCHAR(50) NOT NULL,
    variety VARCHAR(50) DEFAULT 'mystery',
    quantity ENUM('Very Few (1-5)', 'Few (6-20)', 'Medium (21-75)', 'Lots (76-200)', 'Bulk (200+)') NOT NULL,
    plant_type ENUM('Vegetable', 'Herb', 'Flower', 'Fruit', 'Trees & Shrubs', 'Other') NOT NULL,
    seed_source VARCHAR(100) DEFAULT 'mystery',
    date_acquired DATE NOT NULL
);
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM seed_packs;


-- #######################################################################################
-- PRACTICE QUERIES 
-- #######################################################################################

/*
Seed Label
◘ Write a query that creates a "seed label" by:
	• concatenating the seed_name with "-" and the variety
    • give it the alias seed_label
*/

DESC seed_packs;

SELECT 
	CONCAT(seed_name, ' - ', variety) AS 'seed_label'
FROM seed_packs;

/*
	◘ Write a query that shows:
		• the first 8 characters of the seed_name,
        • followed by "..." 
        • and also displays the full plant_type 
        • use aliases "short_name" and "type"
        
	◘ Your result should look something like:

		• short_name: "Cantalou...", type: "Fruit"
		• short_name: "Waterm...", type: "Fruit"
		• short_name: "Turnip...", type: "Vegetable"
*/

SELECT 
    CONCAT(SUBSTR(seed_name, 1, 8),
            '...') AS 'short_name',
            plant_type AS 'type'
FROM
    seed_packs;


/*
	Which seeds do we currently have a 'Bulk' amount of?
*/
SELECT * FROM seed_packs
WHERE quantity='Bulk (200+)';

/**/
SELECT 
	CONCAT(
		'We received ',
        seed_name, 
        ' from ',
        seed_source, 
        ' on ',
        date_acquired)
FROM 
	seed_packs;
    
USE bakolong_seed_library;
SELECT * FROM seed_packs;