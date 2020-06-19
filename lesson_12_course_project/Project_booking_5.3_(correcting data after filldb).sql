USE booking;

-- Correcting updated_at if it's earlier than object was created
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;
UPDATE profiles SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;
UPDATE photos SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;
UPDATE reviews SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;
UPDATE properties SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;
UPDATE reservations SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;
UPDATE properties_room_types SET updated_at = CURRENT_TIMESTAMP WHERE updated_at < created_at;

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

-- Updating profiles younger then 18 y.o. with pseudo-randomly generated birthdate 18+
CREATE TEMPORARY TABLE profiles_temp (birthday DATE) 
  SELECT birthday 
  FROM profiles 
  WHERE birthday < '2002-06-15';
UPDATE profiles 
  SET birthday = (SELECT birthday FROM profiles_temp ORDER BY RAND() LIMIT 1) 
  WHERE birthday > '2002-06-15';
DROP TABLE profiles_temp;

-- Randomizing genius_lvl_id with possible values from 1 to 3
UPDATE profiles SET genius_lvl_id = FLOOR(1 + RAND() * 3);

-- Let's say only 162 photos belong to Users (it's possible to have an account without photo and likely they do),
-- and other photos belong to Properties.
UPDATE photos SET photo_type_id = 2;
CREATE TEMPORARY TABLE photos_temp (id INT) 
  SELECT id 
  FROM photos 
  ORDER BY RAND() LIMIT 162; -- select 162 random photos
UPDATE photos SET photo_type_id = 1 WHERE id IN (SELECT id FROM photos_temp);
UPDATE photos SET object_id = FLOOR(1 + RAND() * 1000) WHERE photo_type_id = 1;
UPDATE photos SET object_id = FLOOR(1 + RAND() * 3000) WHERE photo_type_id = 2;

-- Making filenames more realistic
UPDATE photos SET filename = CONCAT(
  'https://dropbox.net/booking/',
  filename,
  '.jpg');

-- Making sizes more realistic too
UPDATE photos 
  SET size = FLOOR(50000 + (RAND() * 3500000)) 
  WHERE size < 50000 OR size > 3500000;

-- Correcting property rating from existing review ratings
UPDATE properties 
  SET rating = 
    (SELECT ROUND((SUM(rating) / COUNT(rating)), 1) 
    FROM reviews 
    WHERE properties.id = reviews.property_id);