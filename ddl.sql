CREATE database festival_db;
USE festival_db;

DROP TABLE IF EXISTS location;
CREATE TABLE location (
	address VARCHAR(100) NOT NULL, 
    coordinates POINT NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    continent VARCHAR(50) NOT NULL,
    PRIMARY KEY (address)
);

CREATE TABLE festival (
    festival_year INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    address VARCHAR(100) NOT NULL,
    PRIMARY KEY (festival_year)
    FOREIGN KEY (address) REFERENCES location (address)
);

DROP TABLE IF EXISTS building;
CREATE TABLE building (
    building_name VARCHAR(100) NOT NULL,
    building_description VARCHAR(100),
    maximum_capacity INT NOT NULL,
    necessary_equipment VARCHAR(100),
    PRIMARY KEY (building_name)
);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
    staff_id INT NOT NULL AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL check(category in('technical', 'security', 'support')),
    name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    role VARCHAR(50) not null,
    experience VARCHAR(50) NOT NULL check (experience in ('beginner', 'intermediate', 'experienced', 'very experienced', 'professional')),
    PRIMARY KEY (staff_id)
);

DROP TABLE IF EXISTS building_staff;
CREATE TABLE building_staff (
    building_name VARCHAR(100) NOT NULL,
    staff_id INT NOT NULL, 
    number_of_visitors INT NOT NULL,
    PRIMARY KEY (building_name, staff_id),
    FOREIGN KEY (building_name) REFERENCES building (building_name),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);


DROP TABLE IF EXISTS event;
CREATE TABLE event (
    event_id INT NOT NULL AUTO_INCREMENT, -- kav we added event_id for unique identification, watch the er
    event_name VARCHAR(100) NOT NULL,
    building _name VARCHAR(100) NOT NULL, 
    event_date DATE NOT NULL,
    festival_year INT NOT NULL,
    PRIMARY KEY (event_id),
    FOREIGN KEY (festival_year) REFERENCES festival(festival_year),
    FOREIGN KEY (building_name) REFERENCES building (building_name)
);

DROP TABLE IF EXISTS performance;
CREATE TABLE performance(
    performance_id INT NOT NULL AUTO_INCREMENT,
    performance_type VARCHAR(100) NOT NULL,
    performance_time TIME NOT NULL,
    performance_duration INT NOT NULL, --in minutes
    event_id INT NOT NULL,
    building_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (performance_id),
    FOREIGN KEY (building_name) REFERENCES building (building_name),
    FOREIGN KEY (event_id) REFERENCES event (event_id)
);
 
/*
xreiazomaste triggers gia na kanoume insert sto event_performance

DROP TABLE IF EXISTS break_between_performances;
CREATE TABLE break_between_performances(
    current_performance_id INT NOT NULL,
    next_performance_id INT NOT NULL,
    break_duration INT NOT NULL , -- in minutes
    PRIMARY KEY (current_performance_id, next_performance_id),
    FOREIGN KEY (current_performance_id) REFERENCES performance (performance_id),
    FOREIGN KEY (next_performance_id) REFERENCES performance (performance_id)
);
*/

DROP TABLE IF EXISTS artist;
CREATE TABLE artist(
    artist_id INT NOT NULL AUTO_INCREMENT,
    artist_name VARCHAR(50) NOT NULL,
    artist_nickname VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    music_genre VARCHAR(50) NOT NULL,
    music_subgenre VARCHAR(50) NOT NULL,
    artist_website VARCHAR(100) NOT NULL,
    artist_email VARCHAR(100) NOT NULL,
    PRIMARY KEY (artist_id)
);

DROP TABLE IF EXISTS artist_performance;
CREATE TABLE artist_performance(
    artist_id INT NOT NULL,
    performance_id INT NOT NULL,
    PRIMARY KEY (artist_id, performance_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id),
    FOREIGN KEY (performance_id) REFERENCES performance (performance_id)
);
-- mallon xreiazomaste trigger gia na kanoume insert sto artist_performance

DROP TABLE IF EXISTS band;
CREATE TABLE band(
    band_id INT NOT NULL AUTO_INCREMENT,
    band_name VARCHAR(50) NOT NULL,
    band_nickname VARCHAR(50) NOT NULL,
    date_of_formation DATE NOT NULL,
    music_genre VARCHAR(50) NOT NULL,
    music_subgenre VARCHAR(50) NOT NULL,
    band_website VARCHAR(100) NOT NULL,
    band_instagram VARCHAR(100) NOT NULL,
    PRIMARY KEY (band_id)
);


DROP TABLE IF EXISTS artist_band;
CREATE TABLE artist_band(
    artist_id INT NOT NULL,
    band_id INT NOT NULL,
    PRIMARY KEY (arist_id,band_id),
    FOREIGN KEY (arist_id) REFERENCES artist (artist_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id)
);
 
DROP TABLE IF EXISTS visitor;
CREATE TABLE visitor (
    visitor_id INT NOT NULL AUTO_INCREMENT,
    festival_year INT NOT NULL,
    PRIMARY KEY (visitor_id),
    FOREIGN KEY (festival_year) REFERENCES festival (festival_year)
);

DROP TABLE IF EXISTS review;
CREATE TABLE review(
    review_id INT NOT NULL AUTO_INCREMENT,
    artist_performance_grade VARCHAR(20) check(artist_performance_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied')),
    lighting_sound_grade VARCHAR(20) check(lighting_sound_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied'))
    organization_grade VARCHAR(20)check(organization_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied'))
    final_impression_grade VARCHAR(20) check(final_impression_grade in('Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied')),
    visitor_id INT NOT NULL,
    performance_id INT NOT NULL,
    PRIMARY KEY (review_id),
    FOREIGN KEY(visitor_id) REFERENCES visitor (visitor_id),
    FOREIGN KEY (performance_id) REFERENCES performance (performance_id)
);

