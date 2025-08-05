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
