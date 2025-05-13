# Pulse University Music Festival
## Database Semester Project, for the "Databases" course (6th Semester) of the ECE School, NTUA

Welcome to the **Pulse University Music Festival** Database! This project aims to emulate a realistic database for a music festival, as well as storing and managing data related to many entities that may participate in a festival. To name some of them: artists, bands, visitors, tickets, a reselling queue implemented with FIFO logic, events that contain different performances, and buildings that host these events, and staff that work in said buildings. Our database is optimized to query and analyze data in an efficient manner.
This repository contains all the necessary files for setting up and running the **Music Festival Database** as well as the interactive web app designed for further visualisation of our database.

## Directory Features

- **Database Management**: Utilizes MySQL for robust and scalable data storage.
- **Data Generation**: Includes a Python script to create and manage dummy data for testing and development.
- **Triggers and Procedures**: Implements MySQL triggers and procedures to automate and streamline database operations [here](link_to_script).
- **Web Interface**: Provides a web-based interface for users to interact with the festival data, run custom SQL queries, and view results.

This project is ideal for event organizers, music enthusiasts, and anyone interested in managing large-scale music festivals.

## Database Features

- **Artist Management**: Store detailed information about artists, including their names, genres, and performance history.
- **Event Management**: Handle data related to events, such as event dates, locations, and ticketing.
- **Performance Scheduling**: Manage the scheduling of performances, including performance times, artists, and venues.
- **Genre Classification**: Classify artists and performances by genre, facilitating better organization and filtering.
- **Ticketing System**: Track ticket sales, availability, and pricing for different events and performances.
- **Festival Reviews**: Allow festival attendees to rate and review performances and events.


## Technical Details

### Technologies Used:

- **MySQL**: MySQL was used for setting up, storing and managing the database, as well as executing SQL queries.

- **MAMP**: MAMP was used to create a local development environment for managing the MySQL database and running the web application via Apache. 

- **Python**: Python was used for developing the application and generating the necessary data through the `fake_data.py` script.
  
- **Flask**: The web server for the application was created using Flask, which is a micro web framework for building Python applications.

- **Jinja2**: Jinja2 was used to dynamically generate HTML pages on the server side.

- **HTML/CSS**: HTML and CSS were used to develop the user interface (UI).

### Software Versions:

- **Python 3.3.12**
- **Flask 3.1.0**
- **MySQL 8.0.40**
- **Jinja2 3.1.6**
- **PHP 8.3.14**

### Assumptions:

1. **Limitations on SQL Query Types**: The application only allows SELECT queries for security reasons. Other SQL query types such as INSERT, UPDATE, or DELETE are not allowed.

2. **Data Sources**: Data is generated using the `fake_data.py` Python script. The generated data is random and is mainly intended for development and testing purposes.

3. **Database Structure**: The database includes key entities such as artists, music genres, festivals, and events. The relationships are defined through the `artist`, `band`, `event`, and `festival` tables.

4. **Artist and Band Data**: The system supports both artists and bands, who may belong to multiple music genres. The data for artists and bands is combined using the `artist_genre_view` and `band_genre_view` views.

5. **Performance**: For large databases with many artists and events, performance may be impacted when executing complex queries.
6. 

## Installation

To get started with the Music Festival Database, follow the steps below:

1. Clone the repository:

   ```bash
   git clone https://github.com/SotirisKav/music-festival.git
   cd music-festival

2. **Set up the MySQL database**:

   - Create a MySQL database and import the `ddl.sql` file to set up the necessary tables and relationships.
   
     ```bash
     mysql -u your_username -p your_database < ddl.sql
     ```

3. **Install the required Python libraries**:

   - Install all the necessary Python libraries specified in the `requirements.txt` file.
   
     ```bash
     pip install -r requirements.txt
     ```

4. **Run the app**:

   - Start the Flask app by running the following command:
   
     ```bash
     python app.py
     ```

   - Open your browser and visit `http://127.0.0.1:5000` to start interacting with the music festival database.
