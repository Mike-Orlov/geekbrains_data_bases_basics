USE booking;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_genius_lvl_id_fk
    FOREIGN KEY (genius_lvl_id) REFERENCES genius_lvl(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES photos(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_password_id_fk
    FOREIGN KEY (password_id) REFERENCES passwords(id)
      ON DELETE RESTRICT;

ALTER TABLE photos
  ADD CONSTRAINT photos_photo_type_id_fk 
    FOREIGN KEY (photo_type_id) REFERENCES photo_types(id)
      ON DELETE RESTRICT;
      
ALTER TABLE properties
  ADD CONSTRAINT properties_property_type_id_fk 
    FOREIGN KEY (property_type_id) REFERENCES property_types(id)
      ON DELETE RESTRICT;
      
ALTER TABLE reviews
  ADD CONSTRAINT reviews_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT reviews_property_id_fk 
    FOREIGN KEY (property_id) REFERENCES properties(id)
      ON DELETE CASCADE;
     
ALTER TABLE properties_reviews
  ADD CONSTRAINT properties_reviews_review_id_fk 
    FOREIGN KEY (review_id) REFERENCES reviews(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT properties_reviews_property_id_fk 
    FOREIGN KEY (property_id) REFERENCES properties(id)
      ON DELETE CASCADE;
           
ALTER TABLE properties_facilities
  ADD CONSTRAINT properties_facilities_property_id_fk 
    FOREIGN KEY (property_id) REFERENCES properties(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT properties_facilities_facility_id_fk
    FOREIGN KEY (facility_id) REFERENCES facilities(id)
      ON DELETE RESTRICT;
      
ALTER TABLE properties_room_types
  ADD CONSTRAINT properties_room_type_id_fk 
    FOREIGN KEY (room_type_id) REFERENCES room_types(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT properties_property_id_fk
    FOREIGN KEY (property_id) REFERENCES properties(id)
      ON DELETE CASCADE;
      
ALTER TABLE reservations
  ADD CONSTRAINT reservations_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT reservations_property_id_fk
    FOREIGN KEY (property_id) REFERENCES properties(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT reservations_room_type_id_fk
    FOREIGN KEY (room_type_id) REFERENCES room_types(id)
      ON DELETE RESTRICT,
  ADD CONSTRAINT reservations_reservation_status_id_fk
    FOREIGN KEY (reservation_status_id) REFERENCES reservation_statuses(id)
      ON DELETE RESTRICT;