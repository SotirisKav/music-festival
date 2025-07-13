# Pulse University Music Festival
## Database Semester Project, for the "Databases" course (6th Semester) of the ECE School, NTUA

Welcome to the **Pulse University Music Festival** Database! This project aims to emulate a realistic database for a music festival, as well as storing and managing data related to many entities that may participate in a festival. To name some of them: artists, bands, visitors, tickets, a reselling queue implemented with FIFO logic, events that contain different performances, and buildings that host these events, and staff that work in said buildings. Our database is optimized to query and analyze data in an efficient manner.
This repository contains all the necessary files for setting up and running the **Music Festival Database** as well as the interactive web app designed for further visualisation of our database.

## Directory Features

- **Database Management**: Utilizes MySQL for robust and scalable data storage.
- **Data Generation**: Includes a Python script to create and manage dummy data for testing and development.
- **Triggers and Procedures**: Implements MySQL triggers and procedures to automate and streamline database operations.
- **Web Interface**: Provides a web-based interface for users to interact with the festival data, run custom SQL queries, and view results.

This project is ideal for event organizers, music enthusiasts, and anyone interested in managing large-scale music festivals.

## Database Features

- **Artist Management**: Store detailed information about artists, including their names, genres, and performance history.
- **Event Management**: Handle data related to events, such as event dates, locations, and ticketing.
- **Performance Scheduling**: Manage the scheduling of performances, including performance times, artists, and venues.
- **Genre Classification**: Classify artists and performances by genre, facilitating better organization and filtering.
- **Ticketing System**: Track ticket sales, availability, and pricing for different events and performances.
- **Festival Reviews**: Allow festival attendees to rate and review performances and events.

## Assumptions:

1. Festivals start at 12:00a.m. and finish at 11:00p.m. 
2. All the events of a festival are being held at a specific building each day.
3. We set a lower time limit for each performance equal to 15 minutes.
4. A visitor is defined in our database as someone who holds tickets: scanned or not.
5. A visitor must be over the age of 16.

## Technical Details

### Technologies Used:

- **MySQL**: MySQL was used for setting up, storing and managing the database, as well as executing SQL queries.

- **MAMP**: MAMP was used to create a local development environment for managing the MySQL database and running the web application via Apache. 

- **Python**: Python was used for developing the application and generating the necessary data through the `fake_data.py` script.
  
- **Flask**: The web server for the application was created using Flask, which is a micro web framework for building Python applications.

- **Jinja2**: Jinja2 was used to dynamically generate HTML pages on the server side.

- **HTML/CSS**: HTML and CSS were used to develop the user interface (UI).

### Tech Stack:

- **Python 3.3.12**
- **Flask 3.1.0**
- **MySQL 8.0.40**
- **Jinja2 3.1.6**
- **Python Anywhere**

## Installation

To get started with the Music Festival Database, either visit the public URL:  

**[https://sotiriskav.pythonanywhere.com](https://sotiriskav.pythonanywhere.com)**

or if you wish to install the app locally, follow the steps mentioned below:

1. Clone the repository:

   ```bash
   git clone https://github.com/SotirisKav/music-festival.git
   cd music-festival

2. **Set up the MySQL database**:

   - Create a MySQL database and import the `install.sql` file to set up the necessary tables and relationships (optional import load.sql file to load the fake data).
   
     ```bash
     mysql -u root -p festival_db < install.sql
     mysql -u root -p festival_db < load.sql
     ```

3. **Install the required Python libraries**:

   - Install all the necessary Python libraries. 
   
     ```bash
     pip install -r requirements.txt
     ```

4. **Run the app**:

   - Start the Flask app by running the following command:
   
     ```bash
     python app.py
     ```

   - Open your browser and visit `http://127.0.0.1:5000` to start interacting with the music festival database.
