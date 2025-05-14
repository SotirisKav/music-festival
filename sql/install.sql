DROP database IF EXISTS festival_db;
CREATE database festival_db;
USE festival_db;

DROP TABLE IF EXISTS location;
CREATE TABLE location (
	location_id INT NOT NULL AUTO_INCREMENT,
    address VARCHAR(100) NOT NULL, 
    coordinates POINT NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    continent VARCHAR(50) NOT NULL,
    PRIMARY KEY (location_id)
);
CREATE INDEX idx_continent ON location(continent);

DROP TABLE IF EXISTS festival;
CREATE TABLE festival (
    festival_id INT NOT NULL AUTO_INCREMENT,
    festival_year INT NOT NULL UNIQUE, -- only one festival per year
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    poster_image_url VARCHAR(255),
    festival_description TEXT,
    location_id INT NOT NULL UNIQUE, -- to ensure that festivals takes place in different location every year
    PRIMARY KEY (festival_id),
    FOREIGN KEY (location_id) REFERENCES location (location_id),
    CHECK (
        start_date < end_date 
    )
);
CREATE INDEX idx_festival_year ON festival (festival_year);

DROP TABLE IF EXISTS building;
CREATE TABLE building (
    building_id INT NOT NULL AUTO_INCREMENT,
    building_name VARCHAR(100) NOT NULL,
    building_description TEXT NOT NULL,
    maximum_capacity INT NOT NULL CHECK(maximum_capacity > 0),
    necessary_equipment TEXT,
    equipment_image_url VARCHAR(1000),
    PRIMARY KEY (building_id)
);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
    staff_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK(category in('technical', 'security', 'support')),
    age INT NOT NULL CHECK(age >= 18 and age <= 65),
    role VARCHAR(50) NOT NULL,
    experience VARCHAR(50) NOT NULL CHECK(experience in ('beginner', 'intermediate', 'experienced', 'very experienced', 'professional')),
    building_id INT NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (building_id) REFERENCES building (building_id)
);
CREATE INDEX idx_staff_category ON staff (category);
CREATE INDEX idx_staff_experience ON staff (experience);

DROP TABLE IF EXISTS event;
CREATE TABLE event (
    event_id INT NOT NULL AUTO_INCREMENT,
    event_name VARCHAR(100) NOT NULL,
    event_start_time DATETIME NOT NULL,
    event_end_time DATETIME NOT NULL,
    festival_id INT NOT NULL,
    building_id INT NOT NULL,
    PRIMARY KEY (event_id),
    FOREIGN KEY (festival_id) REFERENCES festival(festival_id),
    FOREIGN KEY (building_id) REFERENCES building (building_id),
    CHECK (
        event_start_time < event_end_time AND
        TIME(event_start_time) >= '17:00:00' AND
        TIME(event_end_time) <= '23:00:00' AND
        DATE(event_start_time) = DATE(event_end_time)
    )
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
    genre_id INT NOT NULL AUTO_INCREMENT,
    genre_name VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (genre_id)
); 
CREATE INDEX idx_genre_name ON genre (genre_name);

DROP TABLE IF EXISTS subgenre;
CREATE TABLE subgenre (
    subgenre_id INT NOT NULL AUTO_INCREMENT,
    subgenre_name VARCHAR(50) NOT NULL UNIQUE,
    genre_id INT NOT NULL,
    PRIMARY KEY (subgenre_id),
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
);

DROP TABLE IF EXISTS artist;
CREATE TABLE artist(
    artist_id INT NOT NULL AUTO_INCREMENT,
    artist_first_name VARCHAR(50) NOT NULL,
    artist_last_name VARCHAR(50) NOT NULL,
    artist_nickname VARCHAR(50),
    date_of_birth DATE NOT NULL,
    artist_website VARCHAR(100),
    artist_instagram VARCHAR(100),
    artist_image_url VARCHAR(500),
    artist_description TEXT,
    PRIMARY KEY (artist_id)
);
CREATE INDEX idx_artist_age ON artist (date_of_birth);

DROP TABLE IF EXISTS artist_genre;
CREATE TABLE artist_genre (
    artist_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id),
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
);

DROP TABLE IF EXISTS artist_subgenre;
CREATE TABLE artist_subgenre (
    artist_id   INT NOT NULL,
    subgenre_id INT NOT NULL,
    PRIMARY KEY (artist_id, subgenre_id),
    FOREIGN KEY (artist_id)   REFERENCES artist  (artist_id),
    FOREIGN KEY (subgenre_id) REFERENCES subgenre(subgenre_id)
);

DROP TABLE IF EXISTS band;
CREATE TABLE band(
    band_id INT NOT NULL AUTO_INCREMENT,
    band_name VARCHAR(50) NOT NULL,
    band_nickname VARCHAR(50) NOT NULL,
    date_of_formation DATE NOT NULL,
    band_website VARCHAR(100) NOT NULL,
    band_instagram VARCHAR(100) NOT NULL,
    band_image_url VARCHAR(500),
    band_description TEXT,
    PRIMARY KEY (band_id)
);

DROP TABLE IF EXISTS band_genre;
CREATE TABLE band_genre (
    band_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (band_id, genre_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id),
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
); 

DROP TABLE IF EXISTS band_subgenre;
CREATE TABLE band_subgenre (
    band_id INT NOT NULL,
    subgenre_id INT NOT NULL,
    PRIMARY KEY (band_id, subgenre_id),
    FOREIGN KEY (band_id)   REFERENCES band  (band_id),
    FOREIGN KEY (subgenre_id) REFERENCES subgenre(subgenre_id)
);

DROP TABLE IF EXISTS artist_band;
CREATE TABLE artist_band(
    artist_id INT NOT NULL,
    band_id INT NOT NULL,
    PRIMARY KEY (artist_id,band_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id)
);

DROP TABLE IF EXISTS performance;
CREATE TABLE performance(
    performance_id INT NOT NULL AUTO_INCREMENT,
    performance_type VARCHAR(100) NOT NULL CHECK(performance_type in('Warm up', 'Headline', 'Guest', 'Special Appearance')),
    performance_start_time DATETIME NOT NULL,
    performance_duration INT NOT NULL
    CHECK (performance_duration >= 15 AND performance_duration <= 180),
        -- in minutes and in order to be able to calculate the end time of the performance we need to convert it with INTERVAL
    event_id INT NOT NULL,
    artist_id INT NULL,
    band_id INT NULL,
    PRIMARY KEY (performance_id),
    FOREIGN KEY (event_id) REFERENCES event (event_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id),
    CHECK ((artist_id IS NULL) <> (band_id   IS NULL)) -- XOR condition
);
CREATE INDEX idx_performance_type ON performance (performance_type);

DROP TABLE IF EXISTS visitor;
CREATE TABLE visitor (
    visitor_id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (visitor_id)
);

DROP TABLE IF EXISTS visitor_event;
CREATE TABLE visitor_event (
    visitor_id INT NOT NULL,
    event_id INT NOT NULL,
    PRIMARY KEY (visitor_id, event_id),
    FOREIGN KEY (visitor_id) REFERENCES visitor (visitor_id),
    FOREIGN KEY (event_id) REFERENCES event (event_id)
);

DROP TABLE IF EXISTS review;
CREATE TABLE review  (
    review_id INT NOT NULL AUTO_INCREMENT,
    artist_performance_grade VARCHAR(20) CHECK(artist_performance_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied')),
    lighting_sound_grade VARCHAR(20) CHECK(lighting_sound_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied')),
    stage_presence_grade VARCHAR(20) CHECK(stage_presence_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied')),
    organization_grade VARCHAR(20) CHECK(organization_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied')),
    final_impression_grade VARCHAR(20) CHECK(final_impression_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied')),
    visitor_id INT NOT NULL,
    performance_id INT NOT NULL,
    PRIMARY KEY (review_id),
    FOREIGN KEY(visitor_id) REFERENCES visitor (visitor_id),
    FOREIGN KEY (performance_id) REFERENCES performance (performance_id)
);
CREATE INDEX idx_artist_performance_grade ON review (artist_performance_grade);

DROP TABLE IF EXISTS ticket;
CREATE TABLE ticket (
    ticket_id INT NOT NULL AUTO_INCREMENT,
    EAN BIGINT NOT NULL UNIQUE,
    holder_first_name VARCHAR(30) NOT NULL,
    holder_last_name VARCHAR(30) NOT NULL,    
    holder_phone_number VARCHAR(50) NOT NULL,
    holder_email VARCHAR(50) NOT NULL CHECK (holder_email REGEXP '^[a-zA-Z0-9]+@[a-zA-Z0-9]+\\.[a-z]{2,}$'),
    holder_age INT NOT NULL CHECK(holder_age >= 16 AND holder_age <= 85),
    category VARCHAR(50) NOT NULL CHECK(category in('VIP', 'General Entrance', 'Backstage')),
    purchase_date DATETIME NOT NULL,
    ticket_price DECIMAL(10, 2) NOT NULL CHECK (ticket_price > 0),
    payment_method VARCHAR(20) NOT NULL CHECK(payment_method in('Credit Card', 'Debit Card', 'Bank Transfer')),
    scanned BOOLEAN NOT NULL DEFAULT FALSE,
    event_id INT NOT NULL,
    visitor_id INT,
    PRIMARY KEY (ticket_id),
    FOREIGN KEY (event_id) REFERENCES event (event_id),
    FOREIGN KEY (visitor_id) REFERENCES visitor (visitor_id)
);
CREATE INDEX idx_purchase_date ON ticket (purchase_date);
CREATE INDEX idx_scanned ON ticket (scanned);
CREATE INDEX idx_payment_method ON ticket (payment_method);

DROP TABLE IF EXISTS Seller_Queue;
CREATE TABLE Seller_Queue (
    Seller_queue_id INT NOT NULL AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL check(category in('VIP', 'General Entrance', 'Backstage')),
    sell_date DATETIME NOT NULL,
    ticket_price DECIMAL(10, 2) NOT NULL CHECK (ticket_price > 0),
    processed BOOLEAN NOT NULL DEFAULT FALSE,
    ticket_id INT NOT NULL,
    event_id INT NOT NULL,
    PRIMARY KEY (Seller_queue_id),
    FOREIGN KEY (ticket_id) REFERENCES ticket (ticket_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);
CREATE INDEX idx_sell_date ON Seller_Queue (sell_date);
CREATE INDEX idx_seller_processed ON Seller_Queue (processed);

DROP TABLE IF EXISTS Buyer_Queue;
CREATE TABLE Buyer_Queue (
    Buyer_queue_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    age INT NOT NULL CHECK(age >= 16 AND age <= 85),
    event_id INT NULL,
    EAN BIGINT NULL,
    category VARCHAR(50)  CHECK(category in('VIP', 'General Entrance', 'Backstage')),
    CHECK (
        (EAN IS NOT NULL AND (category IS NULL AND event_id IS NULL))OR
        (EAN IS NULL AND (category IS NOT NULL AND event_id IS NOT NULL))
    ),
    buy_date DATETIME NOT NULL,
    processed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (Buyer_queue_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);
CREATE INDEX idx_buy_date ON Buyer_Queue (buy_date);
CREATE INDEX idx_buyer_processed ON Buyer_Queue (processed);

DROP TRIGGER IF EXISTS event_festival_check;
DELIMITER //
CREATE TRIGGER event_festival_check
BEFORE INSERT ON event
FOR EACH ROW
BEGIN
    DECLARE festival_start DATETIME;
    DECLARE festival_end DATETIME;
    DECLARE event_count INT;
    SELECT start_date, end_date INTO festival_start, festival_end
    FROM festival
    WHERE festival.festival_id = NEW.festival_id;

    IF festival_start IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Festival year not found for event';
    END IF;

    IF NEW.event_start_time < festival_start OR NEW.event_start_time > festival_end THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Event date must be within the festival period';
    END IF;

    SELECT COUNT(*) INTO event_count
    FROM event e
    WHERE e.building_id = NEW.building_id
    AND (
        NEW.event_start_time < e.event_end_time AND
        e.event_start_time < NEW.event_end_time
    );
    IF event_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Venue already booked for another event during this time period';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS performance_check;
DELIMITER //
CREATE TRIGGER performance_check
BEFORE INSERT ON performance
FOR EACH ROW
BEGIN
  DECLARE ev_start     DATETIME;
  DECLARE ev_end       DATETIME;
  DECLARE prev_end     DATETIME;
  DECLARE next_start   DATETIME;
  DECLARE gap_before   INT;
  DECLARE gap_after    INT;
  DECLARE cnt          INT;
  DECLARE curr_year    INT;
  DECLARE past_count   INT;

  -- fetch event's start/end
  SELECT e.event_start_time, e.event_end_time
    INTO ev_start, ev_end
    FROM event e
   WHERE e.event_id = NEW.event_id;
  IF NEW.performance_start_time < ev_start
     OR ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60)) > ev_end
  THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Performance must be within its event''s time window.';
  END IF;

  -- performances cannot overlap
  SELECT COUNT(*) INTO cnt
    FROM performance p
   WHERE p.event_id = NEW.event_id
     AND NEW.performance_start_time
         < ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
     AND p.performance_start_time
         < ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60));
  IF cnt > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Another performance is already scheduled for this time.';
  END IF;

  -- ARTIST RULES
  IF NEW.artist_id IS NOT NULL THEN

    -- must be of age at least 18 at performance
    IF TIMESTAMPDIFF(
         YEAR,
         (SELECT a.date_of_birth FROM artist a WHERE a.artist_id = NEW.artist_id),
         NEW.performance_start_time
       ) < 18
    THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Artist must be at least 18 at performance time.';
    END IF;

    -- no overlapping artist performances
    SELECT COUNT(*) INTO cnt
      FROM performance p
     WHERE p.artist_id = NEW.artist_id
       AND NEW.performance_start_time
           < ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
       AND p.performance_start_time
           < ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60));
    IF cnt > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Artist is already booked for another performance.';
    END IF;
    
    -- artist is not already booked as part of a band
    SELECT COUNT(*) INTO cnt
      FROM performance p
      JOIN artist_band ab ON p.band_id = ab.band_id
     WHERE ab.artist_id = NEW.artist_id
       AND NEW.performance_start_time
           < ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
       AND p.performance_start_time
           < ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60));
    IF cnt > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Artist is already booked as part of a band at this time.';
    END IF;

    -- no > 3 consecutive festival-years
    SELECT f.festival_year INTO curr_year
      FROM event e
      JOIN festival f ON e.festival_id = f.festival_id
     WHERE e.event_id = NEW.event_id
     LIMIT 1;
    SELECT COUNT(DISTINCT f2.festival_year) INTO past_count
      FROM performance p2
      JOIN event e2       ON p2.event_id = e2.event_id
      JOIN festival f2     ON e2.festival_id = f2.festival_id
     WHERE p2.artist_id = NEW.artist_id
       AND f2.festival_year BETWEEN curr_year-3 AND curr_year-1;
    IF past_count = 3 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Artist cannot perform in more than 3 consecutive years.';
    END IF;

  END IF;

  -- BAND RULES
  IF NEW.band_id IS NOT NULL THEN

    -- a) no overlapping band performances
    SELECT COUNT(*) INTO cnt
      FROM performance p
     WHERE p.band_id = NEW.band_id
       AND NEW.performance_start_time
           < ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
       AND p.performance_start_time
           < ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60));
    IF cnt > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Band has an overlapping performance.';
    END IF;
    
    -- Check if any artist in the band has an overlapping solo performance
    SELECT COUNT(*) INTO cnt
      FROM artist_band ab 
      JOIN performance p ON ab.artist_id = p.artist_id
     WHERE ab.band_id = NEW.band_id
       AND NEW.performance_start_time
           < ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
       AND p.performance_start_time
           < ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60));
    IF cnt > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Band member is already booked for a solo performance at this time.';
    END IF;
    
    -- Check if any artist in the band is performing with another band
    SELECT COUNT(*) INTO cnt
      FROM artist_band ab1
      JOIN artist_band ab2 ON ab1.artist_id = ab2.artist_id AND ab1.band_id != ab2.band_id
      JOIN performance p ON ab2.band_id = p.band_id
     WHERE ab1.band_id = NEW.band_id
       AND NEW.performance_start_time
           < ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
       AND p.performance_start_time
           < ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60));
    IF cnt > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Band member is already booked with another band at this time.';
    END IF;

    -- no >3 consecutive festival-years for band
    -- reuse curr_year from above (fetch again if NULL)
    IF curr_year IS NULL THEN
      SELECT f.festival_year INTO curr_year
        FROM event e
        JOIN festival f ON e.festival_id = f.festival_id
       WHERE e.event_id = NEW.event_id
       LIMIT 1;
    END IF;
    SELECT COUNT(DISTINCT f2.festival_year) INTO past_count
      FROM performance p2
      JOIN event e2       ON p2.event_id = e2.event_id
      JOIN festival f2     ON e2.festival_id = f2.festival_id
     WHERE p2.band_id = NEW.band_id
       AND f2.festival_year BETWEEN curr_year-3 AND curr_year-1;
    IF past_count = 3 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Band cannot perform in more than 3 consecutive years.';
    END IF;

  END IF;

  -- enforce 5-30min break before
  SELECT ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
    INTO prev_end
    FROM performance p
   WHERE p.event_id = NEW.event_id
     AND DATE(p.performance_start_time) = DATE(NEW.performance_start_time)
     AND ADDTIME(p.performance_start_time, SEC_TO_TIME(p.performance_duration*60))
         <= NEW.performance_start_time
   ORDER BY p.performance_start_time DESC
   LIMIT 1;
  IF prev_end IS NOT NULL THEN
    SET gap_before = TIMESTAMPDIFF(MINUTE, prev_end, NEW.performance_start_time);
    IF gap_before < 5 OR gap_before > 30 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Break before performance must be 5-30 minutes.';
    END IF;
  END IF;

  -- enforce 5-30min break after
  SELECT p.performance_start_time
    INTO next_start
    FROM performance p
   WHERE p.event_id = NEW.event_id
     AND DATE(p.performance_start_time) = DATE(NEW.performance_start_time)
     AND p.performance_start_time >= 
         ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60))
   ORDER BY p.performance_start_time ASC
   LIMIT 1;
  IF next_start IS NOT NULL THEN
    SET gap_after = TIMESTAMPDIFF(
      MINUTE,
      ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration*60)),
      next_start
    );
    IF gap_after < 5 OR gap_after > 30 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Break after performance must be 5-30 minutes.';
    END IF;
  END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS staff_capacity_check;
DELIMITER //
CREATE TRIGGER staff_capacity_check
BEFORE DELETE ON staff
FOR EACH ROW
BEGIN
    DECLARE staff_count INT;
    DECLARE building_capacity INT;

    SELECT COUNT(*) INTO staff_count
    FROM staff
    WHERE building_id = OLD.building_id
    AND category = OLD.category;

    SELECT maximum_capacity INTO building_capacity
    FROM building
    WHERE building_id = OLD.building_id;

    IF OLD.CATEGORY = 'security' and staff_count - 1 < 0.05 * building_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Security staff must be at least 5% of building capacity';
    END IF;
    IF OLD.CATEGORY = 'support' and staff_count - 1 < 0.02 * building_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Support staff must be at least 2% of building capacity';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS ticket_check;
DELIMITER //
CREATE TRIGGER ticket_check
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    -- 1) declare everything first
    DECLARE vip_ticket_count    INT;
    DECLARE building_capacity   INT;
    DECLARE new_event_date      DATE;
    DECLARE holder_ticket_count INT;
    DECLARE ticket_count        INT;

    -- 2) get building capacity
    SELECT b.maximum_capacity
      INTO building_capacity
    FROM event e
    JOIN building b ON b.building_id = e.building_id
    WHERE e.event_id = NEW.event_id;

    -- 3) check VIP limit
    SELECT COUNT(*)
      INTO vip_ticket_count
    FROM ticket
    WHERE event_id = NEW.event_id
      AND category = 'VIP';

    IF vip_ticket_count >= FLOOR(0.10 * building_capacity) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'VIP tickets cannot exceed 10% of the building capacity';
    END IF;

    -- 4) get the date of the event
    SELECT DATE(event_start_time)
      INTO new_event_date
    FROM event
    WHERE event_id = NEW.event_id;

    -- 5) check one-ticket-per-visitor-per-day
    SELECT COUNT(*)
      INTO holder_ticket_count
    FROM ticket t
    JOIN event  e2 ON e2.event_id = t.event_id
    WHERE t.visitor_id = NEW.visitor_id
      AND DATE(e2.event_start_time) = new_event_date;

    IF holder_ticket_count >= 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Visitor can only buy one ticket for the same event in the same day';
    END IF;

    -- 6) check overall capacity
    SELECT COUNT(*)
      INTO ticket_count
    FROM ticket t
    JOIN event  e3 ON e3.event_id = t.event_id
    WHERE DATE(e3.event_start_time) = new_event_date;

    IF ticket_count >= building_capacity THEN
        -- Insert into Buyer_Queue when capacity is reached
        INSERT INTO Buyer_Queue (
            first_name, 
            last_name, 
            email, 
            phone_number, 
            age, 
            event_id, 
            EAN, 
            category, 
            buy_date, 
            processed
        ) VALUES (
            NEW.holder_first_name,
            NEW.holder_last_name,
            NEW.holder_email,
            NEW.holder_phone_number,
            NEW.holder_age,
            NEW.event_id,
            NULL,  -- Not a specific ticket request
            NEW.category,
            NOW(),
            FALSE
        );
        -- Then call match_tickets to find potential matches
        CALL match_tickets();
    END IF;
END//
DELIMITER ;

-- 1. Create a trigger for new sellers that sets processed flag and updates matched buyers
DROP TRIGGER IF EXISTS seller_before_insert;
DELIMITER //
CREATE TRIGGER seller_before_insert
BEFORE INSERT ON Seller_Queue
FOR EACH ROW
BEGIN
  DECLARE already_scanned BOOLEAN;
  DECLARE matching_buyer_id INT;
  DECLARE event_time DATETIME;
  
  -- Check if ticket has been scanned
  SELECT scanned INTO already_scanned
  FROM ticket 
  WHERE ticket_id = NEW.ticket_id;
  
  IF already_scanned THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot resell a ticket that has already been scanned';
  END IF;
  
  -- Check if the event has already passed
  SELECT e.event_start_time INTO event_time
  FROM ticket t
  JOIN event e ON t.event_id = e.event_id
  WHERE t.ticket_id = NEW.ticket_id;

  IF event_time < NOW() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot resell a ticket for a past event';
  END IF;
  
  -- Set timestamp
  SET NEW.sell_date = NOW();
  
  -- First check for a buyer looking for this specific EAN
  SELECT Buyer_queue_id INTO matching_buyer_id
  FROM Buyer_Queue
  WHERE EAN = ticket_ean
    AND processed = FALSE
  ORDER BY buy_date
  LIMIT 1;

  -- If no EAN match, then check for event+category match
  IF matching_buyer_id IS NULL THEN
    SELECT Buyer_queue_id INTO matching_buyer_id
    FROM Buyer_Queue
    WHERE event_id = NEW.event_id 
      AND category = NEW.category
      AND EAN IS NULL
      AND processed = FALSE
    ORDER BY buy_date
    LIMIT 1;
  END IF;

  -- If any match found, mark this seller as processed immediately
  IF matching_buyer_id IS NOT NULL THEN
    SET NEW.processed = TRUE;
    -- We'll mark the buyer as processed and update the ticket in seller_after_insert
  END IF;
END//
DELIMITER ;

-- 2. After seller is inserted, update buyer and ticket if a match was found
DROP TRIGGER IF EXISTS seller_after_insert;
DELIMITER //
CREATE TRIGGER seller_after_insert
AFTER INSERT ON Seller_Queue
FOR EACH ROW
BEGIN
  DECLARE b_id INT;
  DECLARE buyer_fname VARCHAR(30);
  DECLARE buyer_lname VARCHAR(30);
  DECLARE buyer_email VARCHAR(50);
  DECLARE buyer_phone VARCHAR(15);
  DECLARE buyer_age INT;

  IF NEW.processed THEN
    -- Get the matched buyer
    SELECT Buyer_queue_id, first_name, last_name, email, phone_number, age
    INTO b_id, buyer_fname, buyer_lname, buyer_email, buyer_phone, buyer_age
    FROM Buyer_Queue
    WHERE event_id = NEW.event_id
      AND category = NEW.category
      AND processed = FALSE
    ORDER BY buy_date
    LIMIT 1;
    
    -- Update buyer as processed
    UPDATE Buyer_Queue SET processed = TRUE WHERE Buyer_queue_id = b_id;
    
    -- Update the ticket with buyer info
    UPDATE ticket
    SET holder_first_name = buyer_fname,
        holder_last_name = buyer_lname,
        holder_email = buyer_email,
        holder_phone_number = buyer_phone,
        holder_age = buyer_age,
        scanned = FALSE,
        purchase_date = CURDATE(),
        visitor_id = NULL
    WHERE ticket_id = NEW.ticket_id;
  END IF;
END//
DELIMITER ;

-- 3. Similar approach for buyers - check for sellers first
DROP TRIGGER IF EXISTS buyer_before_insert;
DELIMITER //
CREATE TRIGGER buyer_before_insert
BEFORE INSERT ON Buyer_Queue
FOR EACH ROW
BEGIN
  DECLARE matching_seller_id INT;
  DECLARE matching_ticket_id INT;
  DECLARE event_time DATETIME;
  -- Check if the event has already passed (when buyer specifies an event)
  IF NEW.event_id IS NOT NULL THEN
    SELECT event_start_time INTO event_time
    FROM event
    WHERE event_id = NEW.event_id;

    IF event_time < NOW() THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot buy a ticket for a past event';
    END IF;
  END IF;

  -- Set timestamp
  SET NEW.buy_date = NOW();
  
  -- First check if buyer is looking for a specific ticket by EAN
  IF NEW.EAN IS NOT NULL THEN
    -- Look for a seller with that specific ticket
    SELECT sq.Seller_queue_id, sq.ticket_id 
    INTO matching_seller_id, matching_ticket_id
    FROM Seller_Queue sq
    JOIN ticket t ON sq.ticket_id = t.ticket_id
    WHERE t.EAN = NEW.EAN
      AND sq.processed = FALSE
    ORDER BY sq.sell_date
    LIMIT 1;
  ELSE
    -- Check for any matching ticket by event and category
    SELECT Seller_queue_id, ticket_id 
    INTO matching_seller_id, matching_ticket_id
    FROM Seller_Queue
    WHERE event_id = NEW.event_id
      AND category = NEW.category
      AND processed = FALSE
    ORDER BY sell_date
    LIMIT 1;
  END IF;
    
  -- If match found, mark this buyer as processed immediately
  IF matching_seller_id IS NOT NULL THEN
    SET NEW.processed = TRUE;
    -- We'll update seller and ticket in buyer_after_insert
  END IF;
END //
DELIMITER ;

-- 4. After buyer is inserted, update seller and ticket if a match was found
DROP TRIGGER IF EXISTS buyer_after_insert;
DELIMITER //
CREATE TRIGGER buyer_after_insert
AFTER INSERT ON Buyer_Queue
FOR EACH ROW
BEGIN
  DECLARE s_id INT;
  DECLARE t_id INT;
  IF NEW.processed THEN
    -- Get the matched seller
    SELECT Seller_queue_id, ticket_id
    INTO s_id, t_id
    FROM Seller_Queue
    WHERE event_id = NEW.event_id
      AND category = NEW.category
      AND processed = FALSE
    ORDER BY sell_date
    LIMIT 1;
    
    -- Update seller as processed
    UPDATE Seller_Queue SET processed = TRUE WHERE Seller_queue_id = s_id;
    
    -- Update the ticket with buyer info
    UPDATE ticket
    SET holder_first_name = NEW.first_name,
        holder_last_name = NEW.last_name,
        holder_email = NEW.email,
        holder_phone_number = NEW.phone_number,
        holder_age = NEW.age,
        scanned = FALSE,
        purchase_date = CURDATE(),
        visitor_id = NULL
    WHERE ticket_id = t_id;
  END IF;
END//
DELIMITER ;

-- STORED PROCEDURES
DELIMITER //

DROP PROCEDURE IF EXISTS match_tickets //
CREATE PROCEDURE match_tickets()
BEGIN
    -- Declare variables for temporary tables
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE s_id INT;
    DECLARE t_id INT;
    DECLARE b_id INT;
    DECLARE b_fname VARCHAR(30);
    DECLARE b_lname VARCHAR(30);
    DECLARE b_email VARCHAR(50);
    DECLARE b_phone VARCHAR(50);
    DECLARE b_age INT;
    
    -- Create temporary tables to store matches
    DROP TEMPORARY TABLE IF EXISTS EAN_Matches;
    CREATE TEMPORARY TABLE EAN_Matches (
        seller_id INT,
        ticket_id INT,
        buyer_id INT,
        first_name VARCHAR(30),
        last_name VARCHAR(30),
        phone VARCHAR(50),
        email VARCHAR(50),
        age INT
    );
    
    DROP TEMPORARY TABLE IF EXISTS Category_Matches;
    CREATE TEMPORARY TABLE Category_Matches (
        seller_id INT,
        ticket_id INT,
        buyer_id INT,
        first_name VARCHAR(30),
        last_name VARCHAR(30),
        phone VARCHAR(50),
        email VARCHAR(50),
        age INT
    );
    
    -- Find and store EAN matches in order
    INSERT INTO EAN_Matches
    SELECT 
        sq.Seller_queue_id,
        sq.ticket_id,
        bq.Buyer_queue_id,
        bq.first_name,
        bq.last_name,
        bq.phone_number,
        bq.email,
        bq.age
    FROM Seller_Queue sq
    JOIN ticket t ON sq.ticket_id = t.ticket_id
    JOIN Buyer_Queue bq ON bq.EAN = t.EAN AND bq.processed = FALSE
    WHERE sq.processed = FALSE AND t.scanned = FALSE
    ORDER BY sq.sell_date, bq.buy_date;
    
    -- Find and store category matches in order
    INSERT INTO Category_Matches
    SELECT 
        sq.Seller_queue_id,
        sq.ticket_id,
        bq.Buyer_queue_id,
        bq.first_name,
        bq.last_name,
        bq.phone_number,
        bq.email,
        bq.age
    FROM Seller_Queue sq
    JOIN ticket t ON sq.ticket_id = t.ticket_id
    JOIN Buyer_Queue bq ON bq.event_id = sq.event_id 
                      AND bq.category = sq.category 
                      AND bq.EAN IS NULL
                      AND bq.processed = FALSE
    WHERE sq.processed = FALSE 
      AND t.scanned = FALSE
      AND NOT EXISTS (SELECT 1 FROM EAN_Matches WHERE EAN_Matches.seller_id = sq.Seller_queue_id)
    ORDER BY sq.sell_date, bq.buy_date;
    
    -- Process EAN matches
    UPDATE Seller_Queue sq
    JOIN EAN_Matches m ON sq.Seller_queue_id = m.seller_id
    SET sq.processed = TRUE;
    
    UPDATE Buyer_Queue bq
    JOIN EAN_Matches m ON bq.Buyer_queue_id = m.buyer_id
    SET bq.processed = TRUE;
    
    UPDATE ticket t
    JOIN EAN_Matches m ON t.ticket_id = m.ticket_id
    SET t.holder_first_name = m.first_name,
        t.holder_last_name = m.last_name,
        t.holder_phone_number = m.phone,
        t.holder_email = m.email,
        t.holder_age = m.age;
    
    -- Process category matches
    UPDATE Seller_Queue sq
    JOIN Category_Matches m ON sq.Seller_queue_id = m.seller_id
    SET sq.processed = TRUE;
    
    UPDATE Buyer_Queue bq
    JOIN Category_Matches m ON bq.Buyer_queue_id = m.buyer_id
    SET bq.processed = TRUE;
    
    UPDATE ticket t
    JOIN Category_Matches m ON t.ticket_id = m.ticket_id
    SET t.holder_first_name = m.first_name,
        t.holder_last_name = m.last_name,
        t.holder_phone_number = m.phone,
        t.holder_email = m.email,
        t.holder_age = m.age;
    

    -- Re-enable safe updates mode
    SET SQL_SAFE_UPDATES = 1;
END //
DELIMITER ;

-- VIEWS 

DROP VIEW IF EXISTS artist_total_participations_view;
CREATE VIEW artist_total_participations_view AS
SELECT 
    artist_id,
    artist_name,
    age,
    COUNT(*) AS total_performances
FROM ( -- total permormances=solo performances UNION ALL(+) perfmormances in a band 

    -- solo performances
    SELECT 
        a.artist_id,
	    CONCAT(a.artist_first_name, ' ', a.artist_last_name) AS artist_name,
        TIMESTAMPDIFF(YEAR, a.date_of_birth, CURDATE()) AS age
    FROM artist AS a
    INNER JOIN performance AS p ON a.artist_id = p.artist_id
    INNER JOIN event AS e ON p.event_id = e.event_id
    INNER JOIN festival AS f ON e.festival_id = f.festival_id
    WHERE f.end_date <= CURDATE()
    UNION ALL
    -- performances in a band
    SELECT 
        a.artist_id,
		CONCAT(a.artist_first_name, ' ', a.artist_last_name) AS artist_name,
        TIMESTAMPDIFF(YEAR, a.date_of_birth, CURDATE()) AS age
    FROM artist a
    INNER JOIN artist_band AS ab ON a.artist_id = ab.artist_id
    INNER JOIN performance AS p ON ab.band_id = p.band_id
    INNER JOIN event AS e ON p.event_id = e.event_id
    INNER JOIN festival AS f ON e.festival_id = f.festival_id
    WHERE f.end_date <= CURDATE()
) AS total
GROUP BY artist_id,artist_name,age
ORDER BY total_performances DESC;

DROP VIEW IF EXISTS event_staff_view;
CREATE VIEW event_staff_view AS
SELECT 
    e.event_id,
    DATE(e.event_start_time) AS event_date,
    s.category,
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name
FROM event AS e
INNER JOIN building b ON e.building_id = b.building_id
INNER JOIN staff s ON s.building_id = b.building_id;

DROP VIEW IF EXISTS visitor_festival_attended_view;
CREATE VIEW visitor_festival_attended_view AS
SELECT 
  t.visitor_id,
  f.festival_year,
  COUNT(*) AS event_visited
FROM event AS e
JOIN ticket AS t ON t.event_id = e.event_id
JOIN festival AS f ON e.festival_id = f.festival_id
WHERE t.scanned = TRUE
GROUP BY t.visitor_id, f.festival_year
HAVING COUNT(*) > 3;

DROP VIEW IF EXISTS genre_total_performances_year_view;
CREATE VIEW genre_total_performances_year_view AS
SELECT 
    genre_name,
    festival_year,
    COUNT(*) AS total_genre_performances
FROM (
    -- Performances of artists
    SELECT 
        g.genre_name,
        f.festival_year
    FROM performance AS p
    INNER JOIN artist AS a ON p.artist_id = a.artist_id
    INNER JOIN artist_genre AS ag ON a.artist_id = ag.artist_id
    INNER JOIN genre g ON ag.genre_id = g.genre_id
    INNER JOIN event e ON p.event_id = e.event_id
    INNER JOIN festival f ON e.festival_id = f.festival_id
    WHERE f.end_date <= CURDATE()

    UNION ALL

    -- Perfrmances of bands
    SELECT 
        g.genre_name,
        f.festival_year
    FROM performance p
    INNER JOIN  band AS b ON p.band_id = b.band_id
    INNER JOIN  band_genre AS bg ON b.band_id = bg.band_id
    INNER JOIN  genre AS g ON bg.genre_id = g.genre_id
    INNER JOIN event AS e ON p.event_id = e.event_id
    INNER JOIN festival AS f ON e.festival_id = f.festival_id
    WHERE f.end_date <= CURDATE()
) AS total_genre_performances
GROUP BY genre_name, festival_year
ORDER BY festival_year, genre_name;