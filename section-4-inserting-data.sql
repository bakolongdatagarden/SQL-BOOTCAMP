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




