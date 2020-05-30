USE vk;

-- 3. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
 
SELECT 
  COUNT(target_types.id) AS users_likes,
  profiles.birthday AS age,
  profiles.user_id
  FROM profiles 
    LEFT JOIN likes
      ON profiles.user_id = likes.target_id
    LEFT JOIN target_types
      ON likes.target_type_id = target_types.id
        AND target_types.name = 'users'
  GROUP BY profiles.user_id
  ORDER BY age DESC
  LIMIT 10;
 
-- Проверка

SELECT
    (SELECT COUNT(id) FROM likes WHERE target_id = profiles.user_id AND target_type_id = (SELECT id FROM target_types WHERE name = 'users')) AS users_likes, 
	birthday AS age,
	user_id
  FROM profiles
  ORDER BY age DESC
  LIMIT 10;
 
-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT
  COUNT(likes.id) AS likes,
  gender
  FROM likes JOIN profiles ON likes.user_id = profiles.user_id
  GROUP BY gender;

-- Проверка

SELECT COUNT(id) FROM likes WHERE user_id IN(SELECT user_id FROM profiles WHERE gender = 'm');
SELECT COUNT(id) FROM likes WHERE user_id IN(SELECT user_id FROM profiles WHERE gender = 'w');

SELECT
  IF(
	(SELECT COUNT(id) FROM likes WHERE user_id IN(SELECT user_id FROM profiles WHERE gender = 'm')) >
	(SELECT COUNT(id) FROM likes WHERE user_id IN(SELECT user_id FROM profiles WHERE gender = 'w')),
	'men give more likes',
	'women give more likes'
  ) AS status
FROM
  profiles
GROUP BY status;

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- (критерии активности необходимо определить самостоятельно)
-- Критерии возьму социальные, публичные: сколько ставит лайков + публичных постов = показатель активности 

SELECT 
  COUNT(DISTINCT(likes.id)) + COUNT(DISTINCT(posts.id)) AS users_activity,
  profiles.user_id 
  FROM profiles
    LEFT JOIN likes ON likes.user_id = profiles.user_id
    LEFT JOIN posts ON posts.user_id = profiles.user_id AND posts.is_public = TRUE
  GROUP BY profiles.user_id 
  ORDER BY users_activity
  LIMIT 10;
  
-- Проверка
 
SELECT
    (SELECT COUNT(id) FROM likes WHERE user_id = profiles.user_id) +
    (SELECT COUNT(id) FROM posts WHERE user_id = profiles.user_id AND is_public = TRUE) AS users_activity,  
	user_id
  FROM profiles
  ORDER BY users_activity
  LIMIT 10;