USE vk;

SHOW TABLES;

DESCRIBE users;

SELECT * FROM users LIMIT 50;
-- Correcting updated_at if it's earlier than object was created
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;
-- Correcting phone numbers to make it similar to Russian
UPDATE users SET phone = CONCAT(
  '+79',
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9),
  FLOOR(RAND() * 9)
);

SELECT * FROM user_statuses;
-- Correccting statuses
TRUNCATE user_statuses;
INSERT user_statuses (id, name)
VALUES
  (1, 'active'),
  (2, 'blocked'),
  (3, 'deleted');
-- Randomly populate table users with brand new statuses. Possible from 1 to 3.
UPDATE users SET status_id = FLOOR(1 + RAND() * 3);

SELECT * FROM profiles LIMIT 100;
SELECT COUNT(*) FROM media;
UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 5000);
UPDATE profiles SET is_private = TRUE WHERE user_id > FLOOR(1 + RAND() * 1000);

SELECT * FROM messages LIMIT 50;
-- Already OK after filldb

DESC media;
SELECT * FROM media LIMIT 50;

-- Table of possible extensions
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mp4'), ('png');
SELECT * FROM extensions;

-- Concat prifixes with filenames and random extensions
UPDATE media SET filename = CONCAT(
  'https://dropbox.net/vk/',
  filename,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1));

-- Sizes lower than 1000 looks not realistic, so correcting them randomly
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

-- Set new media types
SELECT * FROM media_types;
TRUNCATE media_types;
INSERT INTO media_types (id, name) VALUES
  (1, 'photo'),
  (2, 'video'),
  (3, 'audio')
;

-- Randomly assign possible media types from 1 to 3
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

-- Testing random names generator
SELECT CONCAT(first_name, ' ', last_name) FROM users ORDER BY RAND() LIMIT 1;

-- Construct JSON-objects (not exactly JSON, but looks like)
UPDATE media SET metadata = CONCAT(
  '{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users ORDER BY RAND() LIMIT 1),
  '"}'); 

-- Set column type. Now it's correct.
ALTER TABLE media MODIFY COLUMN metadata JSON;

SELECT * FROM friendship_statuses;
SELECT * FROM friendship;

-- Set new friendship statuses and make an update of dummy data
TRUNCATE friendship_statuses;
INSERT INTO friendship_statuses (name)
VALUES 
  ('Requested'),
  ('Confirmed'),
  ('Rejected');
UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3);

SELECT * FROM communities;
SELECT * FROM communities_users;

-- Temporary table to save names and then re-create communities table
DROP TABLE temp_communities;
CREATE TEMPORARY TABLE temp_communities LIKE communities;
DESC temp_communities;
SELECT * FROM temp_communities;
INSERT INTO temp_communities SELECT * FROM communities;
TRUNCATE communities;
INSERT INTO communities (name) SELECT name FROM temp_communities;
UPDATE communities_users SET community_id = FLOOR(1 + RAND() *109);

SELECT * FROM profiles;
-- Count how much profiles are younger then 18 y.o.
SELECT COUNT(*) FROM profiles WHERE birthday > '2002-11-05';
-- Create temporary table with already generated dates that earlier then '2002-11-05'
CREATE TEMPORARY TABLE profiles_copy (birthday DATE) SELECT birthday FROM profiles WHERE birthday < '2002-11-05';
-- Set them to random data from profiles_copy
UPDATE profiles SET birthday = (SELECT birthday FROM profiles_copy ORDER BY RAND() LIMIT 1) WHERE birthday > '2002-11-05';

-- my implementation proposal for 'posts' and 'likes'
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  media_id INT UNSIGNED DEFAULT NONE,
  community_id INT UNSIGNED DEFAULT NONE, -- if no community_id, it means users's post 
  body TEXT NOT NULL,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id, user_id)
);

DROP TABLE IF EXISTS media_likes;
CREATE TABLE media_likes (
  media_id INT UNSIGNED NOT NULL,
  like_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (media_id, like_id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL
);