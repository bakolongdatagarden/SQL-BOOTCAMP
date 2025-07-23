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

-- =============================================
-- Working with NOT NULL
-- =============================================

/*
What does Null: Yes mean?
	◘ It means that NULL is permitted in that particular column
		○ In other words, it means the value is unknown
*/

-- Let's insert a cat with no age

INSERT INTO cats (name)
VALUES ("Todd");

SELECT * FROM cats; # so Todd's age will show "NULL"

/*
A lot of times though, we want to REQUIRE a value to be present
	◘ We wouldn't want to insert a cat with no name
    ◘ We can use a CONSTRAINT called "Not Null" to require data
*/

# Let's make a new table 

CREATE TABLE cats2(
	name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

DESC cats2;

-- The code below will genereate an error 
-- "Error Code: Field 'age' doesn't have a default value

-- INSERT INTO cats2(name)
-- VALUES("Bilbo");

SELECT * FROM cats2; # it didn't work, so the table cats2 is still empty

-- Let's try it again with required data
INSERT INTO cats2 (name, age)
VALUES ("Bilbo", 19);

SELECT * FROM cats2; # now it worked

-- =============================================
-- Sidenote: Quotes in MySQL
-- =============================================

/*
◘ Technically in my SQL use of double or single quotes doesn't matter
◘ But for other relational databases, you don't want to use double quotes
◘ So it's good practice moving forward to always work with single quotes
*/

-- Let's make a quick table

CREATE TABLE shops(
	name VARCHAR(100)
);

DESC shops;

-- Now insert using single quotes 

INSERT INTO shops (name)
VALUES ('Show  Emporium');

/*
◘ Now what about if we have a quote within a quote??
	○ we need to ESCAPE quotes
    ○ use '\' to escape quotes
*/


INSERT INTO shops (name)
VALUES ('Mario\'s pizza');

SELECT * FROM shops;

-- =============================================
-- Adding DEFAULT values
-- =============================================

/*
◘ Serves as a sort of placeholder instead of showing 'NULL'

	CREATE TABLE cats3(
		name VARCHAR(100) DEFAULT 'unnamed',
        age INT DEFAULT 99
    );
*/

-- Create a new cats table with DEFAULT values for name and age
CREATE TABLE cats3 (
    name VARCHAR(50) DEFAULT 'mystery',
    age INT DEFAULT 99
);

-- Inspect 
DESC cats3;

-- Insert a cat with no name

INSERT INTO cats3 (age)
VALUES (2);

SELECT * FROM cats3;

-- Insert a cat with no values present
INSERT INTO cats3()
VALUES ();

-- Using NOT NULL & DEFAULT together 

USE pet_shop;
SHOW TABLES;
CREATE TABLE cats4(	
	name VARCHAR(100) NOT NULL DEFAULT 'unnamed',
    age INT NOT NULL DEFAULT 99
);

DESC cats4;
SELECT * FROM cats4;

INSERT INTO cats4 (name)
VALUES('Yalla');

-- =============================================
-- Introducing Primary Keys 
-- =============================================

/*
Importance of Primary Keys:
◘ what if you have identical rows?
	○ we can use unique identifiers to rows so we can diferentiate even when everything looks the same 
◘ numeric ids starts at a number and increments from there 
◘ We declare a column a primary key column 
*/

CREATE TABLE unique_cats (
	cat_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

DESC unique_cats; # we'll see that 'Key' column is set to PRI (primary)

INSERT INTO unique_cats(cat_id, name, age)
VALUES(1, 'bingo', 2);

SELECT * FROM unique_cats;

