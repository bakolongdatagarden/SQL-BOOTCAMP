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
-- =================================================

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
    
-- =================================================
-- Officially Introducing SELECT
-- ==================================================

/*
◘ How do retrieve (or READ) data that's in a table?
	○ SELECT * FROM cats;
    ○ '*' = give me all the columns 
    ○ but we don't have to get all the columns ...  we can specify what we want
*/

-- retrieve only the names from our cats table
SELECT name FROM cats;

-- age 
SELECT age FROM cats;

-- get name and age
SELECT name, age FROM cats;

-- name and breed
SELECT name, breed FROM cats;

-- =================================================
-- The WHERE Clause 
-- ==================================================

/*
◘ WHERE allows us to narrow down the rows we are working with 
*/

-- Retrieve information on  cats that are 4 years old
SELECT * FROM cats WHERE age=4;

-- we just want name and age of cats that are 4
SELECT name, age FROM cats where age=4;

-- now we just want name
SELECT name FROM cats where age=4;

-- math based off a piece of text
-- notice the text is case-insensitive 
SELECT * FROM cats where name='egg';


