-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello ()
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
  DECLARE time_now INT DEFAULT HOUR(NOW());
  DECLARE greetings VARCHAR(255);
  CASE 
    WHEN time_now >= 6 AND time_now < 12 THEN SET greetings = 'Good morning';
    WHEN time_now >= 12 AND time_now < 18 THEN SET greetings = 'Good afternoon';
    WHEN time_now >= 18 AND time_now < 24 THEN SET greetings = 'Good evening';
    WHEN time_now >= 0 AND time_now < 6 THEN SET greetings = 'Good night';
  END CASE;
  RETURN greetings;
END//
DELIMITER ;
SELECT hello();

-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS not_null;
DELIMITER //
CREATE TRIGGER not_null BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, because name and description are NULLs';
  ELSEIF NEW.description IS NULL THEN 
    SET NEW.description = NEW.name; -- Описание делаем как имя, логика базы позволяет. Но наоборот было бы не логично.
  END IF;
END//
DELIMITER ;

-- Проверка
INSERT INTO products (name, description, price)
VALUES ('AMD superchip', 'New powerful processor', 8000), 
  ('Intel XXX blade', NULL, 8900), 
  (NULL, 'Some description here', 4560);
 
SELECT * FROM products;

INSERT INTO products (name, description, price)
VALUES (NULL, NULL, 8000);

DELETE FROM products WHERE id > 7;

-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

DROP FUNCTION IF EXISTS fibonacci;
DELIMITER //
CREATE FUNCTION fibonacci (seq_len INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE a, c INT DEFAULT 0;
  DECLARE b INT DEFAULT 1;
  IF seq_len = 0 THEN SET c = 0;
	  ELSEIF seq_len = 1 THEN SET c = 1;
	  ELSE
		  WHILE seq_len <> 1 DO
		    SET c = a + b;
		    SET a = b;
		    SET b = c;
		    SET seq_len = seq_len - 1;
		  END WHILE;
  END IF;
  RETURN c;
END//
DELIMITER ;
SELECT fibonacci(10);