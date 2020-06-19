USE booking;

-- Canceling reservation if the room is not vacant
DROP TRIGGER IF EXISTS wrong_reservation;
DELIMITER //
CREATE TRIGGER wrong_reservation BEFORE INSERT ON reservations
FOR EACH ROW
BEGIN
  IF (SELECT is_vacant
    FROM reservations JOIN properties_room_types
      ON reservations.property_id = properties_room_types.property_id 
        AND reservations.room_type_id = properties_room_types.room_type_id
    WHERE properties_room_types.property_id = NEW.property_id
      AND properties_room_types.room_type_id = NEW.room_type_id) = 0
  THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT prohibited, because the room is not vacant';
  END IF;
END//
DELIMITER ;

-- Check it!
INSERT INTO reservations (user_id, property_id, room_type_id, start_date, end_date, reservation_status_id)
VALUES (1, 1661, 1, NOW(), NOW(), 1);

-- Procedure returns min and max prices for rooms on booking.com

DROP PROCEDURE IF EXISTS max_min_price;
DELIMITER //
CREATE PROCEDURE max_min_price(OUT max_price INT, OUT min_price INT)
BEGIN
  DECLARE curr_price,max_finded,min_finded,done INT;

  DECLARE cur CURSOR FOR
    SELECT price
    FROM properties_room_types;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done = 1;

  SET max_finded = 0;
  SET min_finded = 1000000;
  SET done = 0;

  OPEN cur;
  WHILE done = 0 DO
    FETCH cur INTO curr_price;
    IF curr_price > max_finded THEN
      SET max_finded = curr_price;
    END IF;
    IF curr_price < min_finded THEN
      SET min_finded = curr_price;
    END IF;
  END WHILE;

  CLOSE cur;

  SET max_price = max_finded;
  SET min_price = min_finded;
 
END;
//
DELIMITER ;

CALL max_min_price(@max,@min);

SELECT @max;
SELECT @min;