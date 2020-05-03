CREATE DATABASE IF NOT EXISTS example;
USE example;
CREATE TABLE IF NOT EXISTS users (id INT, name VARCHAR(255) NOT NULL);
\! mysqldump example > example_copy.sql
-- Create new DB, because need it to make a dump into
CREATE DATABASE IF NOT EXISTS sample;
\! mysql sample < example_copy.sql
-- Making a dump of first 100 strings in a table
\! mysqldump mysql help_keyworld -w 'TRUE LIMIT 100' > help_keyworld_dump.sql