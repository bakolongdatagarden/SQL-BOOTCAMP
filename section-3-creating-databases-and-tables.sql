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





