-- =================================================
-- =================================================
-- SECTION 6: CRUD CHALLENGE
-- =================================================
-- =================================================


-- =================================================
-- Introducing the CRUD Challenge
-- =================================================

/*
SCENARIO : Spring Cleaning (The Annual Closet Inventory)
	◘ 1. Create a new database (shirts_db) to keep track of all of our new shirts 
    ◘ 2. Create a new table (shirts)
		○ Columns: shirt_id, article, color, shirt_size, last worn
		○ Shirt id: primary key, auto increment
        ○ article = text , color = text
        ○ last_worn = integer 
	◘ 3. Insert the given data
    ◘ 4. Add a new shirt: purple polo shirt, size M, last worn 50 days ago
    ◘ 5. SELECT all shirts: but only print out article and color
    ◘ 6. SELECT all medium shirts: print out everything but shirt_id
    ◘ 7. UPDATE all polo shirts: change their size to L
    ◘ 8. UPDATE the shirt last worn 15 days ago: change last_worn to 0
    ◘ 9. UPDATE all white shirts: change size to 'XS' and color to 'off white'
    ◘ DELETE all old shirts: last worn 200 days ago
    ◘ DELETE all tank tops
    ◘ DELETE all shirts
    ◘ DROP the entire shirts table 
*/

-- =================================================
-- CREATE
-- =================================================

-- 1. CREATE a new database to keep track of the shirts 
CREATE DATABASE shirts_db;
SHOW DATABASES; -- verify it's there
USE shirts_db; -- use it

-- 2. CREATE a new table
CREATE TABLE shirts (
    shirt_id INT PRIMARY KEY AUTO_INCREMENT,
    article VARCHAR(50),
    color VARCHAR(50),
    shirt_size VARCHAR(5),
    last_worn INT
);

-- inspect our new table
DESC shirts;
    
-- 3. INSERT a set of data 
INSERT INTO shirts (article, color, shirt_size, last_worn)
VALUES 
	('t-shirt', 'white', 'S', 10),
	('t-shirt', 'green', 'S', 200),
	('polo shirt', 'black', 'M', 10),
	('tank top', 'blue', 'S', 50),
	('t-shirt', 'pink', 'S', 0),
	('polo shirt', 'red', 'M', 5),
	('tank top', 'white', 'S', 200),
	('tank top', 'blue', 'M', 15);
    
-- inspect 
SELECT * FROM shirts;
    
-- 4. ADD a new shirt 
INSERT INTO shirts (article, color, shirt_size, last_worn)
VALUES('polo shirt', 'purple', 'M', 50);

-- =================================================
-- READ
-- =================================================
SELECT * FROM shirts;


-- 5. SELECT all shirts: only print article and color
SELECT article, color FROM shirts;

-- 6. SELECT all medium shirts: print out everything but shirt_id
SELECT article, color, shirt_size, last_worn FROM shirts
WHERE shirt_size='M';

-- =================================================
-- UPDATE
-- =================================================
-- Toggle Safe Updates
SET SQL_SAFE_UPDATES = 0; # temporarily shut off safe update
SET SQL_SAFE_UPDATES = 1; # turn safe update back on 

SELECT * FROM shirts;

-- 7. UPDATE all polo shirts: change their size to 'L'
UPDATE shirts SET shirt_size='L'
WHERE article='polo shirt';

-- 8. UPDATE the shirt last worn 15 days ago: change last_worn to 0
-- a. inspect first
SELECT * FROM shirts
WHERE last_worn=15;

-- b. now update
UPDATE shirts SET last_worn=0
WHERE last_worn=15;

SELECT * FROM shirts;

-- 9. UPDATE all white shirts: change size to 'XS' and color to 'off white'
-- a. inspect first
SELECT * FROM shirts 
WHERE color='white';

-- b. update
UPDATE shirts SET shirt_size='XS', color='off white'
WHERE color='white';

-- =================================================
-- DELETE
-- =================================================

