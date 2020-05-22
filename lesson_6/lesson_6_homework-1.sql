SHOW TABLES;

DESC communities_users;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_user_id_fk
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE RESTRICT,
  ADD CONSTRAINT communities_users_community_id_fk
  FOREIGN KEY (community_id) REFERENCES communities(id)
    ON DELETE RESTRICT;

DESC media_users;   
ALTER TABLE media_users
  ADD CONSTRAINT media_users_user_id_fk
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE RESTRICT,
  ADD CONSTRAINT media_users_media_id_fk
  FOREIGN KEY (media_id) REFERENCES media(id)
    ON DELETE RESTRICT;

DESC friendship;   
ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE RESTRICT,
  ADD CONSTRAINT friendship_friend_id_fk
  FOREIGN KEY (friend_id) REFERENCES users(id)
    ON DELETE RESTRICT,
  ADD CONSTRAINT friendship_status_id_fk
  FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
    ON DELETE RESTRICT;

DESC media;
ALTER TABLE media MODIFY COLUMN media_type_id INT UNSIGNED;
ALTER TABLE media
  ADD CONSTRAINT media_media_type_id_fk
  FOREIGN KEY (media_type_id) REFERENCES media_types(id)
    ON DELETE SET NULL;

DESC messages;
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
  FOREIGN KEY (from_user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  ADD CONSTRAINT messages_to_user_id_fk
  FOREIGN KEY (to_user_id) REFERENCES users(id)
    ON DELETE CASCADE;

UPDATE posts SET community_id = NULL WHERE community_id = 0;
UPDATE posts SET media_id = NULL WHERE media_id = 0;

ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  ADD CONSTRAINT posts_community_id_fk
  FOREIGN KEY (community_id) REFERENCES communities(id)
    ON DELETE SET NULL,
  ADD CONSTRAINT posts_media_id_fk
  FOREIGN KEY (media_id) REFERENCES media(id)
    ON DELETE SET NULL;

-- Can't make FOREIGN KEY for "target_id"
DESC likes;
ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  ADD CONSTRAINT likes_target_type_id_fk
  FOREIGN KEY (target_type_id) REFERENCES target_types(id)
    ON DELETE RESTRICT;