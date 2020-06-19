CREATE DATABASE IF NOT EXISTS booking;
USE booking;

-- Table of users
DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(100) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);  

-- Table of profiles
DROP TABLE IF EXISTS profiles;
CREATE TABLE IF NOT EXISTS profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY, 
  gender CHAR(1) NOT NULL,
  birthday DATE,
  country VARCHAR(130),
  genius_lvl_id INT UNSIGNED DEFAULT 0,
  photo_id INT UNSIGNED,
  password_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
); 

-- Separate genius levels, because discounts or another conditions may be changed
DROP TABLE IF EXISTS genius_lvl;
CREATE TABLE IF NOT EXISTS genius_lvl (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  lvl INT NOT NULL UNIQUE, 
  discount DECIMAL(3,2) UNSIGNED NOT NULL DEFAULT 0
);

-- Passwords are separated for security reasons
DROP TABLE IF EXISTS passwords;
CREATE TABLE IF NOT EXISTS passwords (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  pass VARCHAR(100) NOT NULL, 
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
); 

-- Photo storage for 'users' or 'properties'
DROP TABLE IF EXISTS photos;
CREATE TABLE IF NOT EXISTS photos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  object_id INT UNSIGNED NOT NULL,
  filename VARCHAR(255) NOT NULL,
  size INT NOT NULL,
  photo_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Possible types are 'users' or 'properties' for example
DROP TABLE IF EXISTS photo_types;
CREATE TABLE IF NOT EXISTS photo_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

-- Table of hosts of all types
DROP TABLE IF EXISTS properties;
CREATE TABLE IF NOT EXISTS properties (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT NOT NULL,
  rating FLOAT(3,1) UNSIGNED DEFAULT NULL,
  is_for_work BOOLEAN NOT NULL DEFAULT FALSE,
  city VARCHAR(100) NOT NULL,
  country VARCHAR(100) NOT NULL,
  adress VARCHAR(255) NOT NULL,
  property_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table of posible facilities
DROP TABLE IF EXISTS facilities;
CREATE TABLE IF NOT EXISTS facilities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE 
);

-- Many-to-many relations between properties and facilities
DROP TABLE IF EXISTS properties_facilities;
CREATE TABLE IF NOT EXISTS properties_facilities (
  property_id INT UNSIGNED NOT NULL,
  facility_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (property_id, facility_id)
);

-- Table of types for properties, like hostel, hotel, guesthouse etc.
DROP TABLE IF EXISTS property_types;
CREATE TABLE IF NOT EXISTS property_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE 
);

-- Here is room types, like "Bed in 12-Bed Dormitory Room", "Standard Twin Room" etc.
DROP TABLE IF EXISTS room_types;
CREATE TABLE IF NOT EXISTS room_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- Connects properties with their available rooms
DROP TABLE IF EXISTS properties_room_types;
CREATE TABLE IF NOT EXISTS properties_room_types (
  property_id INT UNSIGNED NOT NULL,
  room_type_id INT UNSIGNED NOT NULL,
  is_vacant BOOLEAN DEFAULT FALSE,  -- default 'false' to avoid incorrect reservations
  price DECIMAL(10,2) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (property_id, room_type_id)
);

-- Table of reviews
DROP TABLE IF EXISTS reviews;
CREATE TABLE IF NOT EXISTS reviews (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  property_id INT UNSIGNED NOT NULL,
  rating INT UNSIGNED NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Connects properties and reviews
DROP TABLE IF EXISTS properties_reviews;
CREATE TABLE IF NOT EXISTS properties_reviews (
  property_id INT UNSIGNED NOT NULL,
  review_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (property_id, review_id)
);

-- Table of reservations
DROP TABLE IF EXISTS reservations;
CREATE TABLE IF NOT EXISTS reservations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  property_id INT UNSIGNED NOT NULL,
  room_type_id INT UNSIGNED NOT NULL,
  start_date DATETIME NOT NULL,
  end_date DATETIME NOT NULL,
  reservation_status_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Possible reservation statuses: reserved, canceled, checked in, checked out
DROP TABLE IF EXISTS reservation_statuses;
CREATE TABLE IF NOT EXISTS reservation_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);