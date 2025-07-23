-- =============================================
-- INSERT: The Basics
-- =============================================

/*
Adding Data to Your Tables

Example of an INSERT Statement

INSERT INTO cats(name, age)
VALUES ('Jetson', 7);

*/

SELECT DATABASE();

-- Remake the cats table 
CREATE TABLE cats (
	name VARCHAR(50),
    age INT
);

-- Verify 
SHOW TABLES;
DESC cats;

-- Insert our first row 
INSERT INTO cats (name, age)
VALUES ("Blue Steele", 5);

-- Let's insert one more row 
INSERT INTO cats (name, age)
VALUES ("Jenkins", 7);

-- =============================================
-- A Quick Preview of Select
-- =============================================

-- We've inserted 2 rows of data, how do we now everything worked as planned?

-- "give me everything you have from the cats table"
SELECT * FROM cats; 

-- =============================================
-- Multiple Inserts
-- =============================================

-- We can switch the order of columns with insert, just be consistent with values

INSERT INTO cats (age, name)
VALUES (2, "Beth");

SELECT * FROM cats;

-- Insert multiple values at once

INSERT INTO cats (name, age)
VALUES
	("Meatball", 5),
    ("Turkey", 1),
    ("Potato Face", 15);
    
    SELECT * FROM cats;
   
-- =============================================
-- Insert Exercise 
-- =============================================

/*
INSTRUCTIONS
◘ Create a people table 
	○ first_name - 20 char limit
    ○ last_name - 20 char limit
    ○ age 
    
◘ Insert your 1st person
	○ Tina, Belcher, 13
◘ Insert your 2nd person
	○ Bob, Belcher, 42
    
◘ Do a muli-insert
	○ Linda, Belcher, 45
	○ Phillip, Frond, 38
    ○ Calvin, Fischoeder, 70
*/

--  Create people table
CREATE TABLE people (
	first_name VARCHAR(20),
    last_name VARCHAR(20),
    age INT
);

-- Inspect 
DESC people;

-- Insert the first person
INSERT INTO people (first_name, last_name, age)
VALUES("Tina", "Belcher", 13);

-- Verify that worked
SELECT * FROM people;

-- Insert the second person
INSERT INTO people (first_name, last_name, age)
VALUES("Bob", "Belcher", 42);

-- Insert Multiple people
INSERT INTO people (first_name, last_name, age)
VALUES
	("Linda", "Belcher", 45),
	("Phillip", "Frond", 38),
	("Calvin", "Fischoeder", 70);

-- And now we delete it
DROP TABLE people;
SHOW DATABASES;