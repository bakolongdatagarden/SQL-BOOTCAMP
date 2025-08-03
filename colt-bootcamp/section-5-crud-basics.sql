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
SELECT name, age FROM cats WHERE age=4;

-- now we just want name
SELECT name FROM cats WHERE age=4;

-- math based off a piece of text
-- notice the text is case-insensitive 
SELECT * FROM cats WHERE name='egg';

-- =================================================
-- Rapid Fire Exercises
-- ==================================================

-- 1. Select cat_id from all the rows
SELECT cat_id FROM cats;

-- 2. Select name & breed for all the rows
SELECT name, breed FROM cats;

-- 3. Retrieve the names and ages of  Tabby Cats
SELECT name, age FROM cats WHERE breed='Tabby';

-- 4. Retrieve the rows where cat_id and ages are the same
SELECT cat_id, age FROM cats WHERE cat_id=age;

-- =================================================
-- Aliases
-- ==================================================

/*
◘ When we're selecting data, we can rename a column to make it shorter or easier to understand
	○ We do this using the 'AS' keyword 
◘ This change is just temporary (for a specific query)
*/

-- for this query, we rename 'cat_id' to 'id'
SELECT cat_id AS id, name FROM cats;

-- we notice here that change is just temporary
-- 'cat_id' is still the name of the column 
DESC cats;

-- another example 
SELECT name AS kittyName FROM cats;

-- =================================================
-- Using UPDATE 
-- ==================================================

/*
◘ How do we UPDATE existing rows in a table?
	○ ex. a user changes their username or password
*/

SELECT * FROM cats;

SET SQL_SAFE_UPDATES = 0; # temporarily shut off safe update

-- update current Tabby breeds to be 'shorthair'
UPDATE cats SET breed='Shorthair'
WHERE breed='Tabby';

SET SQL_SAFE_UPDATES = 1; # turn safe update back on 

-- alter multiple columns at once 
UPDATE employees SET current_status='laid-off', last_name='who cares';

SELECT * FROM employees;

-- update Misty the cats age to be 14
UPDATE cats SET age=14
WHERE name='Misty';

-- =================================================
-- Quick Rule of Thumn
-- ==================================================

/*
◘ To avoid any unexpected updates, try SELECTing before you update 
	○ UPDATE cats SET age=14 WHERE name='Misty';
    ○ What if there are two cats named Misty? 
*/

SELECT cat_id AS id, name FROM cats WHERE name='Misty';

-- =================================================
-- Update Exercise
-- ==================================================

-- 1. Change Jackson's name to "Jack"

-- make sure there aren't two Jackons
SELECT * FROM cats 
WHERE name='Jackson';

-- ok, we're good. Now let's update his name
UPDATE cats SET name='Jack'
WHERE name='Jackson';

SELECT * FROM cats;

-- 2. Change Ringo's breed to "British Shorthair"

SELECT * FROM cats WHERE name='Ringo';

UPDATE cats SET breed='British Shorthair'
WHERE name='Ringo';

-- 3. Update both Maine Coons' ages to be 12

SELECT * FROM cats WHERE breed='Maine Coon';

-- There's a typo in breed name for Dumbledore, let's fix it

UPDATE cats SET breed='Maine Coon'
WHERE name='Dumbledore';

-- now check
SELECT * FROM cats WHERE breed='Maine Coon';

-- now try the challenge again: Update both Maine Coons' ages to be 12

UPDATE cats SET age=12
WHERE breed='Maine Coon';

# Did that work?
SELECT * FROM cats WHERE breed='Maine Coon';

-- =================================================
-- Introducing DELETE
-- ==================================================

SELECT * FROM cats;

-- Delete our cat named egg
DELETE FROM cats WHERE name='Egg';


-- This will Delete all the rows (clear out a table)
SELECT * FROM employees;
DELETE FROM employees;

-- =================================================
-- Delete Exercise 
-- ==================================================

-- DELETE all 4 year old cats

SELECT * FROM cats;

DELETE FROM cats
WHERE age=4;

-- DELETE the cats whose age is the same as their cat_id

SELECT * FROM cats
WHERE age=cat_id;

DELETE FROM cats
WHERE age=cat_id;

-- DELETE all cats

DELETE FROM cats;
