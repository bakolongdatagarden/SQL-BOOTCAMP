-- =============================================
-- SECTION: Create, Drop, Use
-- =============================================

# See what databases current exist
SHOW DATABASES;

# Create a new database
CREATE DATABASE nyambia; # you want the name to be obvious and meaningful 

# Drop and use a database
DROP DATABASE nyambia; # delete the database
SHOW DATABASES; # make sure it's gone

# Use a database
CREATE DATABASE nyambia; # recreate again for this example
USE nyambia; # the database we want to work inside of 
SELECT database(); # verify we're using the correct database 

# Create a new database and switch to it (USE it)
CREATE DATABASE seed_library;
SELECT database(); # we're currently using 'nyambia'
USE seed_library; # let's now use 'seed_library' (re-run previous command to verify)


-- =============================================
-- SECTION: Introducing Tables: Pt 1
-- =============================================

/* 
◘ Tables are what we put in our databases to hold data
◘ They are the true heart of SQL: DB's are made up of lots of tables 
◘ They describe the format and shape of our data
◘ Columns & Rows
	○ Columns are the headers
	○ Rows are the data entries 
◘ But before we get more into tables ... we need to discuss types of data ... 
*/

-- =============================================
-- SECTION: Introducing Tables: Pt 2
-- =============================================

/*
◘ When we define the structure of a table, we also specify what type of information is allowed
◘ Types: Numeric? String? Date? 
◘ Learn more about data types: https://dev.mysql.com/doc/refman/8.4/en/data-types.html

INT
◘ Integer is a whole number 
	○ 12, 0, -9999
    
VARCHAR 
◘ Variable length string
	○ 'coffee!'
    ○ '-9999' (this is a number, but it's in quotes so treated as a string)
◘ We can specify a maximum number of characters allowed 
	○ varchat(100)
*/