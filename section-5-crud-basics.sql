-- SECTION 5: CRUD BASICS
/*
This section is all about CRUD
- The 4 basic actions we want to be able to do to our data are:
	◘ Create
	◘ Read 
	◘ Update 
	◘ Delete
*/

-- =================================================
-- Getting Our New Dataset
-- ===================================================

SHOW TABLES;

-- let's drop the original cats table 
DROP TABLE cats;

-- C = CREATE

-- create a new 'cats' table
CREATE TABLE cats (
	cat_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    breed VARCHAR(100),
    age INT,
    PRIMARY KEY (cat_id)
);

DESC cats;

-- Insert some data
INSERT INTO cats (name, breed, age)
VALUES 
	('Ringo', 'Tabby', 4),
    ('Cindy','Maine Coon', 10),
    ('Dumbledore','Main Coon', 11),
    ('Egg','Persian', 4),
    ('Misty','Tabby', 13),
    ('George Michael','Ragdoll', 9),
	('Jackson','Sphynx', 7);
    
-- Inspect our data
SELECT * FROM cats;
    
    