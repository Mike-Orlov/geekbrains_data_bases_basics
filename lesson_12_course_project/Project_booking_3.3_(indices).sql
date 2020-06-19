USE booking;

SHOW TABLES;

CREATE UNIQUE INDEX users_email_uq ON users(email);
CREATE UNIQUE INDEX users_phone_uq ON users(phone);

CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE INDEX profiles_country_idx ON profiles(country);

CREATE INDEX photos_size_idx ON photos(size);
CREATE INDEX photos_filename_idx ON photos(filename);
CREATE INDEX photos_object_id_idx ON photos(object_id);

CREATE INDEX properties_country_city_idx ON properties(country, city);
CREATE INDEX properties_name_idx ON properties(name);