-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
DELETE FROM sample.users WHERE id = 1;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products
--  и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW prod_cat AS 
  SELECT p.name AS product, c.name AS from_catalog
    FROM products p JOIN catalogs c 
      ON p.catalog_id = c.id
    ORDER BY product;
   
SELECT * FROM prod_cat;
    
-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at.
-- В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04',
-- '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август,
-- выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

DROP TABLE IF EXISTS my_table;
CREATE TEMPORARY TABLE my_table SELECT * FROM vk.users;

DROP TABLE IF EXISTS dates;
CREATE TEMPORARY TABLE dates (august_d DATE NOT NULL);
INSERT INTO dates
  VALUES ('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'), ('2018-08-05'), ('2018-08-06'), ('2018-08-07'), ('2018-08-08'), ('2018-08-09'), ('2018-08-10'), ('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'), ('2018-08-15'), ('2018-08-16'), ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'), ('2018-08-21'), ('2018-08-22'), ('2018-08-23'), ('2018-08-24'), ('2018-08-25'), ('2018-08-26'), ('2018-08-27'), ('2018-08-28'), ('2018-08-29'), ('2018-08-30'), ('2018-08-31');

-- Условие my_table.created_at LIKE '2018-08%' на случай если в исходной таблице оказались не только даты августа
SELECT 
  august_d, 
  IF(august_d = DATE(my_table.created_at), 1, 0) AS date_in_my_table 
FROM dates 
  LEFT JOIN my_table 
  ON august_d = DATE(my_table.created_at) 
    AND my_table.created_at LIKE '2018-08%';

-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at.
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

START TRANSACTION;
CREATE TEMPORARY TABLE only_five_tmp SELECT * FROM the_table ORDER BY created_at DESC LIMIT 5;
TRUNCATE the_table;
INSERT INTO the_table SELECT * FROM only_five_tmp;
DROP TABLE only_five_tmp;
COMMIT;