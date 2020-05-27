-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT * FROM users JOIN orders ON users.id = orders.user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT products.*, catalogs.name FROM products LEFT JOIN catalogs ON products.catalog_id = catalogs.id;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

-- Подготовка таблиц
DROP TABLE IF EXISTS flights;
CREATE TABLE IF NOT EXISTS flights (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `from` VARCHAR(255) NOT NULL,
  `to` VARCHAR(255) NOT NULL,
  CONSTRAINT flights_from_fk FOREIGN KEY (`from`) REFERENCES cities(label) ON UPDATE CASCADE,
  CONSTRAINT flights_to_fk FOREIGN KEY (`to`) REFERENCES cities(label) ON UPDATE CASCADE
);

DROP TABLE IF EXISTS cities;
CREATE TABLE IF NOT EXISTS cities (
  label VARCHAR(255) NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO cities
VALUES ('moscow', 'Москва'), ('irkutsk', 'Иркутск'), ('novgorod', 'Новгород'), ('kazan', 'Казань'), ('omsk', 'Омск');

INSERT INTO flights (`from`, `to`)
VALUES ('moscow', 'omsk'), ('novgorod', 'kazan'), ('irkutsk', 'moscow'), ('omsk', 'irkutsk'), ('moscow', 'kazan');

SELECT * FROM flights;
SELECT * FROM cities;

-- Запрос на JOIN
SELECT flights.* FROM flights JOIN cities ON flights.`from` = cities.label;

-- Финал с заменой через CASE
SELECT 
    flights.id,
    CASE (flights.`from`) 
      WHEN flights.`from` 
      THEN (SELECT name FROM cities WHERE cities.label = flights.`from`) END AS `from`,
    CASE (flights.`to`) 
      WHEN flights.`to` 
      THEN (SELECT name FROM cities WHERE cities.label = flights.`to`) END AS `to`
  FROM flights JOIN cities 
  ON flights.`from` = cities.label;