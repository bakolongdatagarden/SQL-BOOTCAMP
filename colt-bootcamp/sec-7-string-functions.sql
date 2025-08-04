/*
 ◘ String Functions are Different built-in operations we can perform on text columns
 ○ https://dev.mysql.com/doc/refman/8.0/en/string-functions.html
 */
-- =================================================
-- Loading Our Books Data
-- =================================================
/*
 ◘ We will be using pre-existing SQL code to load our books data. 
 */
-- First, let's CREATE and USE our book_shop database
SHOW DATABASES;
CREATE DATABASE book_shop;
USE book_shop;
SELECT
  DATABASE();
-- Now let's paste our data
-- a. CREATE our books table
CREATE TABLE books (
  book_id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(100),
  author_fname VARCHAR(100),
  author_lname VARCHAR(100),
  released_year INT,
  stock_quantity INT,
  pages INT,
  PRIMARY KEY(book_id)
);
-- INSPECT
DESC books;
-- b. Insert the Data
INSERT INTO
  books (
    title,
    author_fname,
    author_lname,
    released_year,
    stock_quantity,
    pages
  )
VALUES
  (
    'The Namesake',
    'Jhumpa',
    'Lahiri',
    2003,
    32,
    291
  ),
  (
    'Norse Mythology',
    'Neil',
    'Gaiman',
    2016,
    43,
    304
  ),
  ('American Gods', 'Neil', 'Gaiman', 2001, 12, 465),
  (
    'Interpreter of Maladies',
    'Jhumpa',
    'Lahiri',
    1996,
    97,
    198
  ),
  (
    'A Hologram for the King: A Novel',
    'Dave',
    'Eggers',
    2012,
    154,
    352
  ),
  ('The Circle', 'Dave', 'Eggers', 2013, 26, 504),
  (
    'The Amazing Adventures of Kavalier & Clay',
    'Michael',
    'Chabon',
    2000,
    68,
    634
  ),
  ('Just Kids', 'Patti', 'Smith', 2010, 55, 304),
  (
    'A Heartbreaking Work of Staggering Genius',
    'Dave',
    'Eggers',
    2001,
    104,
    437
  ),
  ('Coraline', 'Neil', 'Gaiman', 2003, 100, 208),
  (
    'What We Talk About When We Talk About Love: Stories',
    'Raymond',
    'Carver',
    1981,
    23,
    176
  ),
  (
    "Where I'm Calling From: Selected Stories",
    'Raymond',
    'Carver',
    1989,
    12,
    526
  ),
  ('White Noise', 'Don', 'DeLillo', 1985, 49, 320),
  (
    'Cannery Row',
    'John',
    'Steinbeck',
    1945,
    95,
    181
  ),
  (
    'Oblivion: Stories',
    'David',
    'Foster Wallace',
    2004,
    172,
    329
  ),
  (
    'Consider the Lobster',
    'David',
    'Foster Wallace',
    2005,
    92,
    343
  );
-- INSPECT
SELECT
  *
FROM
  books;
/*
 ◘ We can run this file from the command line 
 ○ Enter the command below, then password when prompted
 • mysql -u root -p
 ○ source sec-7-string-functions.sql
 */
-- =================================================
-- CONCAT
-- (Combine Data for Cleaner Output)
-- =================================================
/*
 ◘ FORMAT
 ○ SELECT CONCAT(x,y,z)
 ○ SELECT CONCAT (column, another column)
 */
-- We end up with concatenated result of these 3 strings
SELECT
  CONCAT('h', 'e', 'l');
-- Concatenate author first names with 3 exclamation points
SELECT
  CONCAT(author_fname, '!!!')
FROM
  books;
-- Concatenate author first names with last names
DESC books;
SELECT
  CONCAT(author_fname, author_lname)
FROM
  books;
-- The problem: there's no space between the names 
-- we can concatenate these with a space in a middle
SELECT
  CONCAT(author_fname, ' ', author_lname)
FROM
  books;
-- Another problem: the column name from above looks really long and not nice to look at
-- let's give it an alias
SELECT
  CONCAT(author_fname, ' ', author_lname) AS author_name
FROM
  books;
-- =================================================
-- CONCAT WS
-- (concat with a seperator)
-- =================================================
/*
 ◘ Same concept, concats whatever we tell it to
 ○ But now we provide what seperator we want in the first argument
 */
-- exclamation point will go between each string
SELECT
  CONCAT_WS('!', 'hi', 'bi', 'lol');
-- This will place a dash beteen each concatenated field
SELECT
  CONCAT_WS(' - ', title, author_fname, author_lname)
FROM
  books;
SELECT
  CONCAT_WS(' e &  a ', 1, 2, 3, 4);
SHOW DATABASES;
-- =================================================
-- SUBSTRING
-- (work with parts of strings)
-- =================================================
/*
 ◘ The first value (argument) has to be the string you want to sample
 • Then we have 2 additional numbers:
 ○ The second argument is a starting position 
 ○ The third argument is the length 
 ◘ So the example below is saying:
 • "Start at 1,and go to 2, to 3, to 4
 */
SELECT
  SUBSTRING('Hello World', 1, 4);
-- we get "Hell"
SELECT
  SUBSTRING('Hello World', 2, 4);
-- we get "ello"
-- We can also just provide a single number
-- This tells MySQL "Just go to the end"
SELECT
  SUBSTRING('Hello World', 7);
-- we get "World"
-- We can use a negative number to count backwards from the end of the string
SELECT
  SUBSTRING('Hello World', -1);
# gets the last character in the string
SELECT
  SUBSTRING('Hello World', -2);
-- Let's move back to our database to practice ... 
SELECT
  DATABASE();
SHOW DATABASES;
USE book_shop;
DESC books;
-- We just want to work with the first 15 characters of the title and abbreviate the rest
SELECT
  SUBSTRING(title, 1, 15)
FROM
  books;
-- shorter version (works exactly the same)
SELECT
  SUBSTR(title, 1, 15)
FROM
  books;
-- Get the first character of the author's last name for every book
SELECT
  SUBSTRING(author_lname, 1, 1),
  author_lname
FROM
  books;
-- with an alias for our substring ... 
SELECT
  SUBSTRING(author_lname, 1, 1) AS initial,
  author_lname
FROM
  books;
-- =================================================
-- COMBINING STRING FUNCTIONS
-- =================================================
-- get the first 10 characters of titles
SELECT
  SUBSTR(title, 1, 10)
FROM
  books;
-- we want to add '...' to make it clear these titles are shortened versions
-- combining SELECT and CONCAT (passing a function to another function)
SELECT
  CONCAT(SUBSTR(title, 1, 10), '...')
FROM
  books;
-- trying my own example
SELECT
  CONCAT("Book Title: ", SUBSTR(title, 1, 10), '...')
FROM
  books;
-- let's create a column that's just the author's initials (ex. J.L.)
SELECT
  SUBSTR(author_fname, 1, 1),
  SUBSTR(author_lname, 1, 1)
FROM
  books;
-- but we want them to be combined)
SELECT
  CONCAT(
    SUBSTR(author_fname, 1, 1),
    '.',
    SUBSTR(author_lname, 1, 1),
    '.'
  ) AS Initials
FROM
  books;
DESC books;
-- =================================================
-- REPLACE 
-- (replace parts of strings)
-- =================================================
/*
 ◘ We're not actually updating our data at all ... 
 • we're simply displaying and selecting information,
 • and changing the way it looks after we remove it 
 
 ◘ There are 3 string arguments 
 • 1. The string we will be operating on
 • 2. What we want to replace
 • 3. What we want to replace it with 
 */
-- ex. We replace the 'N' in 'Nyambi' with a z
SELECT
  REPLACE('Nyambi', 'N', 'Z');
-- Colt's example 
SELECT
  REPLACE('Hello World', 'Hell', '%$#@');
-- example replacing a space
SELECT
  REPLACE(
    'cheese bread coffee milk',
    ' ',
    ' and '
  );
-- Replace is case sensitive
SELECT
  REPLACE('hi', 'H', 'z');
-- this will be completely unchanged
-- Practicing with our books table
USE book_shop;
SELECT
  *
FROM
  books;
-- Let's replace all spaces in titles with dashes
SELECT
  REPLACE(title, ' ', '-')
FROM
  books;
-- Random example combining concat with replace
SELECT
  CONCAT('Book Title: ', REPLACE(title, ' ', '_'))
FROM
  books;
-- experiment: combining the lower, concat, and replace functions
SELECT
  LOWER(CONCAT('Book Title: ', REPLACE(title, ' ', '_')))
FROM
  books;
-- Here's your village name
SELECT
  CONCAT_WS('l', 'Nyambi', 'ten');
-- ###################################
-- PRACTICE 
-- ###################################
/*
 QUESTION 1
 Write a query that displays:
 • each book's title
 • concatenated with the text "by" 
 • and the author's full name (full name + space + last name)
 
 Ex.
 • "The Namesake by Jhumpa Lahiri"
 */
USE book_shop;
SELECT
  *
FROM
  books;
SELECT
  CONCAT(
    title,
    ' by ',
    author_fname,
    ' ',
    author_lname
  ) AS 'Title & Author'
FROM
  books;
/*
 QUESTION 2
 Using the books table, write a query that shows:
 • only the first 10 characters of each book title
 • but add "..." at the end to indicate it's been shortened
 */
SELECT
  CONCAT(SUBSTR(title, 1, 10), '...') AS 'Shortened Titles'
FROM
  books;
/*
 QUESTION 3
 Write a query that creates:
 • author initials in the format "First Initial. Last Initial." (ex "J.L." or N.G.")
 • and also shows the full author name	
 
 Your result should have two columns:
 
 • One showing initials like "J.L.", "N.G.", "D.E.", etc.
 • One showing the full name like "Jhumpa Lahiri", "Neil Gaiman", "Dave Eggers", etc.
 */
SELECT
  *
FROM
  books;
SELECT
  CONCAT(
    SUBSTR(author_fname, 1, 1),
    '.',
    SUBSTR(author_lname, 1, 1),
    '.'
  ) AS 'Initials',
  CONCAT_WS(' ', author_fname, author_lname) AS 'Full Name'
FROM
  books;
/*
 QUESTION 4
 Write a query that displays:
 • book titles where all spaces have been replaced with underscores (_),
 • and give this column the alias "web_friendly_title"
 */
SELECT
  REPLACE(title, ' ', '_') AS 'web_friendly_title'
FROM
  books;
/*
 QUESTION 5
 Write a query that combines multiple string functions to create a formatted book summary. 
 For each book, display:
 • "Book: [first 15 characters of title]...by[Author Intials] ([released_year])"
 
 Your result should look something like:
 • "Book: The Namesake... by J.L. (2003)"
 • "Book: Norse Mythology... by N.G. (2016)"
 • "Book: American Gods... by N.G. (2001)"
 */
SELECT
  CONCAT(
    'Book: ',
    SUBSTR(title, 1, 15),
    '...',
    ' by ',
    SUBSTR(author_fname, 1, 1),
    '.',
    SUBSTR(author_lname, 1, 1),
    '.',
    ' (',
    released_year,
    ')'
  ) AS 'Book Slug'
FROM
  books;
/*
 QUESTION 6
 Write a query that creates a "book code" by combining:
 • The first 3 characters of the author's last name (in uppercase)
 • a dash (-)
 • the last 2 digits of the release year
 • a dash (-)
 • the first letter of the title (in lowercase)    
 
 Your result should look something like:
 
 • "LAH-03-t" (for "The Namesake" by Jhumpa Lahiri, 2003)
 • "GAI-16-n" (for "Norse Mythology" by Neil Gaiman, 2016)
 */
SELECT
  CONCAT(
    UPPER(SUBSTRING(author_lname, 1, 3)),
    '-',
    SUBSTRING(released_year, -2, 2),
    '-',
    LOWER(SUBSTRING(title, 1, 1))
  ) AS 'Book Code'
FROM
  books;
-- #################################################
-- SESSION: 8/3/2025
-- #################################################
/*
 REVERSE
 • Takes a string we provide and reverses it	
 */
-- REVERSE 'Nyambi'
SELECT
  REVERSE('Nyambia');
SELECT
  *
FROM
  books;
-- get every author's reversed first name 
SELECT
  REVERSE(author_fname)
FROM
  books;
-- turn every person's name into a palindrome
SELECT
  CONCAT(author_fname, REVERSE(author_fname))
FROM
  books;
/*
 CHAR_LENGTH
 • returns the number of characters in a given string 
 */
-- get length of 'Nyambia'
SELECT
  CHAR_LENGTH('Nyambia');
-- byte length, totally different (although you'll get same answer for some things)
SELECT
  LENGTH('Nyambia');
-- get length of titles from our books table
SELECT
  title,
  CHAR_LENGTH(title) AS 'len'
FROM
  books;
/*
 UPPER & LOWER 
 • Change the casing of a string
 ○ UPPER() : Uppercase
 ○ LOWER() : Lowercase 
 */
SELECT
  UPPER('Nyambia');
SELECT
  LOWER('VILLAGE');
-- this also works ... 
SELECT
  UCASE('Bakolong');
SELECT
  LCASE('Bakolong');
SELECT
  UPPER(title)
FROM
  books;
/*
 Challenge: Wrote a query that generates a column where the results look like:
 "I LOVE THE NAMESAKE!!!"
 */
SELECT
  CONCAT('I LOVE ', UPPER(title), '!!!')
FROM
  books;
  
  
/* experiment query:
Randomly select a book from our table to recommend
*/
SELECT
  CONCAT(
    'You should read ',
    title,
    ' by ',
    author_fname,
    ' ',
    author_lname
  ) AS 'Recommendation'
FROM
  books
ORDER BY
  RAND()
LIMIT
  1;
  
-- #################################################
-- SESSION: 8/4/2025
-- #################################################

/*
    
*/
 
  