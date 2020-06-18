USE booking;

CREATE OR REPLACE VIEW view_users_for_marketing AS
  SELECT first_name, last_name, gender, birthday, country, genius_lvl_id
    FROM users JOIN profiles
    ON users.id = profiles.user_id
    ORDER BY country;
   
SELECT * FROM view_users_for_marketing LIMIT 10;

CREATE OR REPLACE VIEW view_reviews_by_properties AS
  SELECT properties.id, name AS `property name`, city, country, reviews.rating, reviews.description AS `reviews text`, reviews.created_at
    FROM properties LEFT JOIN reviews
    ON properties.id = reviews.property_id
    ORDER BY `property name`;
    
SELECT * FROM view_reviews_by_properties LIMIT 10;