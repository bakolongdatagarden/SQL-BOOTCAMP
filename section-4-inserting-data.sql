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
    
    