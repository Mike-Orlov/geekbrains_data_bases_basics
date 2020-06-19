USE booking;

INSERT INTO 
  genius_lvl (lvl, discount)
VALUES 
  (0, 0),
  (1, 0.1),
  (2, 0.2);

INSERT INTO 
  facilities (name)
VALUES 
  ('Parking'),
  ('Airport shuttle'),
  ('Room service'),
  ('Facilities for disabled guests'),
  ('Restaurant'),
  ('Non-smoking rooms'),
  ('Free WiFi'),
  ('Fitness centre'),
  ('Swimming pool'),
  ('Family rooms'),
  ('Pets allowed'),
  ('Spa and wellness centre'),
  ('Electric vehicle charging station');
 
INSERT INTO 
  property_types (name)
VALUES 
  ('Hotels'),
  ('Apartments'),
  ('Hostels'),
  ('Stand-alone homes'),
  ('Guest houses'),
  ('Motels'),
  ('Homestays'),
  ('Holiday homes'),
  ('Bed and breakfasts'),
  ('Villas');

INSERT INTO 
  reservation_statuses (name)
VALUES 
  ('Reserved'),
  ('Canceled'),
  ('Checked in'),
  ('Checked out');

INSERT INTO 
  photo_types (name)
VALUES 
  ('users'),
  ('properties');

INSERT INTO 
  room_types (name)
VALUES 
  ('Bed in 12-Bed Dormitory Room'),
  ('Bed in 10-Bed Dormitory Room'),
  ('Bed in 8-Bed Dormitory Room'),
  ('Bed in 6-Bed Dormitory Room'),
  ('Bed in 4-Bed Dormitory Room'),
  ('Deluxe King Room'),
  ('Deluxe Twin Room'),
  ('Standard Twin Room'),
  ('Standard Family Room'),
  ('Standard Single Bed Room');