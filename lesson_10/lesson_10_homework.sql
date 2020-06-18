USE vk;

-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения 
-- и добавить необходимые индексы.

SHOW TABLES;

CREATE INDEX users_email_uq ON users(email);
CREATE INDEX users_phone_uq ON users(phone);

CREATE INDEX profiles_photo_id_uq ON profiles(photo_id);
CREATE INDEX profiles_country_city_idx ON profiles(country, city);

CREATE INDEX communities_name_idx ON communities(name);

CREATE INDEX posts_user_id_idx ON posts(user_id);
CREATE INDEX posts_community_id_idx ON posts(community_id);
CREATE INDEX posts_created_at_idx ON posts(created_at);

CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

CREATE INDEX media_size_idx ON media(size);
CREATE INDEX media_filename_uq ON media(filename);

CREATE INDEX likes_target_id_idx ON likes(target_id);
CREATE INDEX likes_created_at_idx ON likes(created_at);

-- 2. Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT DISTINCT 
  communities.name,
  COUNT(communities_users.user_id) OVER() 
    / (SELECT COUNT(*) FROM communities) AS average_users_in_group,
  FIRST_VALUE(users.id) OVER(PARTITION BY communities.id ORDER BY profiles.birthday DESC) AS youngest,
  FIRST_VALUE(users.id) OVER(PARTITION BY communities.id ORDER BY profiles.birthday) AS oldest,
  COUNT(communities_users.user_id) OVER(PARTITION BY communities.id) AS users_in_group,
  (SELECT COUNT(*) FROM users) AS users_all,
  COUNT(communities_users.user_id) OVER(PARTITION BY communities.id) 
    / (SELECT COUNT(*) FROM users) *100 AS '%_of_groups_users_in_total'
    FROM communities
      LEFT JOIN communities_users 
        ON communities_users.community_id = communities.id
      LEFT JOIN users 
        ON communities_users.user_id = users.id
      JOIN profiles 
        ON profiles.user_id = users.id;  