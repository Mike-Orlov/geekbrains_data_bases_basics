-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products 
-- в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа 
-- и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  log_created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  table_name VARCHAR(255),
  table_primary_key INT UNSIGNED NOT NULL,
  table_name_contains VARCHAR(255)
) COMMENT = 'Insert logs for tables: users, catalogs, products' ENGINE=Archive;

DROP TRIGGER IF EXISTS users_to_logs;
DELIMITER //
CREATE TRIGGER users_to_logs AFTER INSERT ON users
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, table_primary_key, table_name_contains) 
  VALUES ('users', NEW.id, NEW.name);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS catalogs_to_logs;
DELIMITER //
CREATE TRIGGER catalogs_to_logs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, table_primary_key, table_name_contains) 
  VALUES ('catalogs', NEW.id, NEW.name);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS products_to_logs;
DELIMITER //
CREATE TRIGGER products_to_logs AFTER INSERT ON products
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, table_primary_key, table_name_contains) 
  VALUES ('products', NEW.id, NEW.name);
END//
DELIMITER ;

-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP PROCEDURE IF EXISTS million_rows;
DELIMITER //
CREATE PROCEDURE million_rows ()
BEGIN
  DECLARE i BIGINT UNSIGNED DEFAULT 1;
  WHILE i < 1000001 DO
	INSERT INTO users (name) VALUES ('Hello');
	SET i = i + 1;
  END WHILE;
END//
DELIMITER ;

CALL million_rows ();