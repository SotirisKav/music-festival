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
