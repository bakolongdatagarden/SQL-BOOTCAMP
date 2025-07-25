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
    ◘ SELECT all shirts: but only print out article and color
    ◘ SELECT all medium shirts: print out everything but shirt_id
    ◘ UPDATE all polo shirts: change their size to L
    ◘ UPDATE the shirt last worn 15 days ago: change last_worn to 0
    ◘ UPDATE all white shirts: change size to 'XS' and color to 'off white'
    ◘ DELETE all old shirts: last worn 200 days ago
    ◘ DELETE all tank tops
    ◘ DELETE all shirts
    ◘ DROP the entire shirts table 
*/

-- =================================================
-- CREATING
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

