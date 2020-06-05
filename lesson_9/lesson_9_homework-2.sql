-- 1. Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.

USE shop;

CREATE USER shop_read IDENTIFIED WITH sha256_password BY 'pass2';
CREATE USER shop IDENTIFIED WITH sha256_password BY 'pass';

GRANT SELECT ON shop.* TO shop_read;
GRANT ALL ON shop.* TO shop;

UPDATE mysql.user SET Host = 'localhost' WHERE `User` = 'shop';
UPDATE mysql.user SET Host = 'localhost' WHERE `User` = 'shop_read';
SELECT Host, User FROM mysql.user;

-- 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
-- содержащие первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, 
-- однако, мог бы извлекать записи из представления username.

USE shop;

DROP TABLE IF EXISTS accounts2;
CREATE TABLE IF NOT EXISTS accounts2 (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  pass VARCHAR(255) NOT NULL
);

INSERT INTO accounts2 (name, pass)
VALUES ('Migel', '12345qwerty'), ('Ernesto', 'Erny1'), ('Juan', 'ytrewq543');

SELECT * FROM accounts2;

CREATE OR REPLACE VIEW username AS
  SELECT id, name FROM accounts2;

SELECT * FROM username;

CREATE USER user_read IDENTIFIED WITH sha256_password BY 'pass3';

GRANT SELECT ON shop.username TO user_read;

UPDATE mysql.user SET Host = 'localhost' WHERE `User` = 'user_read';
SELECT Host, User FROM mysql.user;
