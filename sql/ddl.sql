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