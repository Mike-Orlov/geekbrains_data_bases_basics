USE vk;

-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”
-- 1 Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.
UPDATE users
SET created_at = NOW(),
  updated_at = NOW();

-- 2 Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
-- и в них долгое время помещались значения в формате "20.10.2017 8:10". 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
ALTER TABLE users ADD created_at_good DATETIME;
ALTER TABLE users ADD updated_at_good DATETIME;
UPDATE users
SET created_at_good = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
    updated_at_good = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
ALTER TABLE users 
    DROP created_at, DROP updated_at, 
    RENAME COLUMN created_at_good TO created_at, RENAME COLUMN updated_at_good TO updated_at;

-- 3 В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако, нулевые запасы должны выводиться в конце, после всех записей.
SELECT 0 AS var, value FROM storehouses_products WHERE value > 0
UNION 
SELECT 1 AS var, value FROM storehouses_products WHERE value = 0
ORDER BY var, value;
-- Так сработает. Но почему-то если вместо value ставлю SELECT * в обеих строках, то выдаётся ошибка ("SELECT 0 AS var, * FROM..."). 
-- Не могу понять причину, можете подсказать?

-- 4 (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий ('may', 'august')
SELECT * FROM users WHERE month_name = 'may' OR month_name = 'august';

-- 5 (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
SELECT *
FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);

-- Практическое задание теме “Агрегация данных”
-- 1 Подсчитайте средний возраст пользователей в таблице users
SELECT 
  (SELECT
    SUM(TIMESTAMPDIFF(YEAR, birthday, NOW())) AS age
  FROM
    profiles) 
  / 
  (SELECT 
    COUNT(*) 
  FROM users) AS average_age;
 
-- 2 Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
SELECT * FROM profiles;
-- Заготовка для смены даты на текущий год
SELECT CONCAT(YEAR(NOW()), SUBSTRING(birthday, 5, 8)) FROM profiles;
-- Группируем по неделям с помощью WEEKDAY() и считаем
SELECT 
  COUNT(*), WEEKDAY(CONCAT(YEAR(NOW()), SUBSTRING(birthday, 5, 8))) AS weekday_num 
FROM 
  profiles 
GROUP BY 
  weekday_num 
ORDER BY weekday_num;

-- 3 (по желанию) Подсчитайте произведение чисел в столбце таблицы
SELECT ROUND(EXP(SUM(LOG([value]))),1)
FROM yourtable;