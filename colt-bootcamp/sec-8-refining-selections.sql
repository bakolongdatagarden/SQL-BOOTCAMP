-- #########################################################################
-- SECTION 8: REFINING SELECTIONS
-- #########################################################################
-- SESSION: 8/5/2025
-- #########################################################################
-- VIDEO: ADDING SOME NEW BOOKS
-- #########################################################################
-- Add three new books to 'books' table 
SELECT
  DATABASE();
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
  ('10% Happier', 'Dan', 'Harris', 2014, 29, 256),
  ('fake_book', 'Freida', 'Harris', 2001, 287, 428),
  (
    'Lincoln In The Bardo',
    'George',
    'Saunders',
    2017,
    1000,
    367
  );
-- Verify our entries 
SELECT
  *
FROM
  books;
-- #########################################################################
-- VIDEO: DISTINCT
-- #########################################################################
-- Notice when we run this query, some last names are repeated because author has multiple books
SELECT
  author_lname
FROM
  books;
-- Now using DISTINCT clause, it only prints one of each last_name
SELECT
  DISTINCT author_lname
FROM
  books;
-- Another example with released year 
SELECT
  released_year
FROM
  books;
-- Now with DISTINCT
SELECT
  DISTINCT released_year
FROM
  books;
SELECT
  *
FROM
  books;
/*
 FIXING AN ERROR
 • Accidentally duplicated last insert of 3 books
 • Let's delete them
 */
-- Delete the duplicate entries (run this once)
DELETE FROM
  books
WHERE
  (
    title = '10% Happier'
    AND author_fname = 'Dan'
    AND author_lname = 'Harris'
  )
  OR (
    title = 'fake_book'
    AND author_fname = 'Freida'
    AND author_lname = 'Harris'
  )
  OR (
    title = 'Lincoln In The Bardo'
    AND author_fname = 'George'
    AND author_lname = 'Saunders'
  )
LIMIT
  3;
-- Verify the deletion worked
SELECT
  *
FROM
  books;
-- Ok, back on track, we should have 19 rows returned
SELECT
  released_year
FROM
  books;
-- Now let's get distinct author full names
SELECT
  DISTINCT(CONCAT_WS(' ', author_fname, author_lname)) AS 'Author Name'
FROM
  books;
-- Another Way
-- translation: "Select the distinct combinations of author first and last names"
SELECT
  DISTINCT author_fname,
  author_lname
FROM
  books;
-- another DISTINCT combination
-- we basically get every row in our dataset
SELECT
  DISTINCT author_fname,
  author_lname,
  released_year
FROM
  books;
-- #########################################################################
-- VIDEO: ORDER BY
-- #########################################################################
-- insert Col't example 
INSERT INTO
  books (title, author_lname)
VALUES
  ('my life', 'steele');
-- verify
SELECT
  *
FROM
  books;
-- query ordered by the author's last name
SELECT
  book_id,
  author_fname,
  author_lname
FROM
  books
ORDER BY
  author_lname;
-- now ordered by author's first name 
-- note (NULL will always come first before any alphabetical values)
SELECT
  book_id,
  author_fname,
  author_lname
FROM
  books
ORDER BY
  author_fname;
-- ORDER BY is ASCENDING by default, but we can change that ... 
-- we use 'DESC' in this case for DESCENDING
SELECT
  book_id,
  author_fname,
  author_lname
FROM
  books
ORDER BY
  author_lname DESC;
-- we can do numbers too...
DESC books;
-- first, let's select title and pages 
SELECT
  title,
  pages
FROM
  books;
-- now same selection, ordered by page count
SELECT
  title,
  pages
FROM
  books
ORDER BY
  pages;
-- descending instead of ascending
SELECT
  title,
  pages
FROM
  books
ORDER BY
  pages DESC;
-- let's sort by released released_year
-- what if we're not even selecting released_year?
SELECT
  title,
  pages
FROM
  books
ORDER BY
  released_year;
-- ↑ it's ordered by released_year, you just don't see the column
-- ↓ here's proof
SELECT
  title,
  pages,
  released_year
FROM
  books
ORDER BY
  released_year;
SELECT
  DATABASE();
-- #########################################################################
-- VIDEO: MORE ON ORDER BY
-- #########################################################################
-- ORDER BY 2 = "order by the second columm"
SELECT
  title,
  author_fname,
  author_lname
FROM
  books
ORDER BY
  2;
-- ORDER BY '#' saves you typing
-- for example, here's this query ↓
SELECT
  book_id,
  author_fname,
  author_lname,
  pages
FROM
  books
ORDER BY
  pages;
-- ↓ shorter version, same result
SELECT
  book_id,
  author_fname,
  author_lname,
  pages
FROM
  books
ORDER BY
  4;
/*
 Using the ORDER BY # method could be both useful but also could make your code
 less meaninful and obvious.
 */
-- Moving on, we can also ORDER BY 2 columns
/*
 In this example, we:
 1. Order the table by the author's last name. Now we see all of the repeated last names grouped together.
 2. Now to get more specific, we then order by released_year
 
 • For example, there are two books written by Carver listed in order by released year: 
 - 1981 and 1989
 */
SELECT
  author_lname,
  released_year,
  title
FROM
  books
ORDER BY
  author_lname,
  released_year;
-- let's try with DESCENDING released_year
SELECT
  author_lname,
  released_year,
  title
FROM
  books
ORDER BY
  author_lname,
  released_year DESC;
-- We can also ORDER BY columns that aren't part of the the table, but results or values we've asked for (like ALIASES)
-- normal query 
SELECT
  CONCAT_WS(' ', author_fname, author_lname) AS 'Author'
FROM
  books;
-- ORDER BY 'Author' (our ALIAS for our query)
SELECT
  CONCAT_WS(' ', author_fname, author_lname) AS 'Author'
FROM
  books
ORDER BY
  Author;
/*
 # PRACTICE!!!
 • Asked Deepseek for 9 practice problems to solidify what we've learned so far
 */
-- Problem 1: Basic DISTINCT
-- • Write a query to display all unique author first names from the books table.
SELECT
  DISTINCT author_fname
FROM
  books;
-- Problem 2: DISTINCT Combinations
-- Write a query to show all unique combinations of author first and last names, ordered alphabetically by last name.
SELECT
  DISTINCT author_fname,
  author_lname
FROM
  books
ORDER BY
  author_lname;
-- Problem 3: ORDER BY Basics
-- Write a query to display book titles and their release years, ordered from newest to oldest.
DESC books;
SELECT
  title,
  released_year
FROM
  books
ORDER BY
  released_year DESC;
/*
 Problem 4: ORDER BY Multiple Columns
 • Write a query to display author last names, first names, and book titles, ordered by:
 1. Last name (A-Z)
 2. First name (A-Z)
 3. Title (A-Z)
 */
SELECT
  author_lname,
  author_fname,
  title
FROM
  books
ORDER BY
  author_lname,
  author_fname,
  title;
-- Problem 5: ORDER BY Column Position
-- Write a query to display book titles, release years, and page counts, ordered by the second column (release year) in descending order.
DESC books;
SELECT
  title,
  released_year,
  pages
FROM
  books
ORDER BY
  2 DESC;
/*
 -- Problem 6: ORDER BY with Concatenation
 • Write a query that displays:
 1. The full author name (concatenate author_fname and author_lname with a space) as Author, and
 2. The book title,
 • ordered by the full author name (A-Z).
 */
SELECT
  CONCAT_WS(' ', author_fname, author_lname) AS 'Author',
  title
FROM
  books
ORDER BY
  Author;
/*
 -- Problem 7: DISTINCT with Calculation
 • Write a query to show all unique combinations of:
 1. author_lname and
 2. Decade (calculated as FLOOR(released_year/10)*10),
 • ordered by decade.
 */
SELECT
  author_lname,
  FLOOR(released_year / 10) * 10 AS decade
FROM
  books
ORDER BY
  decade;
/*
 -- Problem 8: Complex ORDER BY
 • Write a query to display:
 1. Book titles
 2. Page counts
 3. Release years
 • Only for books with more than 200 pages, ordered by:
 1. Page count (highest to lowest)
 2. Release year (oldest to newest)
 */
SELECT
  title,
  pages,
  released_year
FROM
  books
WHERE
  pages > 200
ORDER BY
  pages DESC,
  released_year;
/*
 -- Problem 9: Advanced ORDER BY
 • Write a query to display:
 1. Full author name (concatenated first and last name)
 2. Book title
 3. Release year
 
 • Ordered by:
 1. Author's last name length (shortest to longest)
 2. Release year (newest to oldest)
 3. Title length
 */
SELECT
  CONCAT_WS(' ', author_fname, author_lname),
  title,
  released_year
FROM
  books
ORDER BY
  CHAR_LENGTH(author_lname),
  released_year DESC,
  CHAR_LENGTH(title)