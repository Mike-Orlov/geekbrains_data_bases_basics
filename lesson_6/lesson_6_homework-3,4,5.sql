USE vk;

-- 3. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT
    (SELECT COUNT(id) FROM likes WHERE target_id = profiles.user_id AND (SELECT id FROM target_types WHERE name = 'users')) AS users_likes, 
	TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age,
	user_id
  FROM profiles
  ORDER BY age
  LIMIT 10;
 
-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
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
    (SELECT COUNT(id) FROM likes WHERE user_id = profiles.user_id) +
    (SELECT COUNT(id) FROM posts WHERE user_id = profiles.user_id AND is_public = TRUE) AS users_activity,  
	user_id
  FROM profiles
  ORDER BY users_activity
  LIMIT 10;