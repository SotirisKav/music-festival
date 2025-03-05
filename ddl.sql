CREATE TABLE festival (
    festival_year INT NOT NULL,
    duration INT NOT NULL,
    address VARCHAR(500) NOT NULL,
    PRIMARY KEY (festival_year),
    FOREIGN KEY (address) REFERENCES location(address)
);
KAVADINIO
DROP TABLE IF EXISTS location;
CREATE TABLE location (
	address VARCHAR(100) NOT NULL,
	coordinates POINT NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    continent VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS event;
CREATE TABLE event (
	building VARCHAR(100) NOT NULL
);

-- gia na kanoume to branch mas 
