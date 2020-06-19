USE booking;

-- How much users in different age groups?

SELECT
  CASE
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) < 20 THEN 'Under 20'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 20 and 29 THEN '20 - 29'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 30 and 39 THEN '30 - 39'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 40 and 49 THEN '40 - 49'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 50 and 59 THEN '50 - 59'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 60 and 69 THEN '60 - 69'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 70 and 79 THEN '70 - 79'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) >= 80 THEN 'Over 80'
    WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) IS NULL THEN 'Not Filled In (NULL)'
  END as age_range,
  COUNT(*) AS count
FROM reservations 
  JOIN profiles ON reservations.user_id = profiles.user_id
  JOIN properties ON properties.id = reservations.property_id
  JOIN property_types ON property_types.id = properties.property_type_id
GROUP BY age_range
ORDER BY age_range;

-- Users rating by reviews quantity?

SELECT reviews.user_id AS user_id,
  CONCAT(users.first_name,' ',users.last_name) AS name, 
  COUNT(*) as reviews_qty
FROM reviews
  JOIN profiles ON reviews.user_id = profiles.user_id
  JOIN users ON profiles.user_id = users.id
GROUP BY reviews.user_id
ORDER BY reviews_qty DESC;

-- Top 10 properties that have more reservations?

SELECT DISTINCT
  properties.name,
  COUNT(reservations.id) OVER(PARTITION BY properties.id) AS reservation_qty
FROM reservations
  LEFT JOIN properties ON reservations.property_id = properties.id
ORDER BY reservation_qty DESC
LIMIT 10;