# app.py
from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host='127.0.0.1',
        user='root',
        password='root',
        database='festival_db'
    )

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/festivals')
def festivals():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute('''
        SELECT f.festival_id, f.festival_year, f.poster_image_url,
               f.start_date, f.end_date, l.city, l.country
        FROM festival f
        JOIN location l ON f.location_id = l.location_id
        ORDER BY f.festival_year DESC
    ''')
    festivals = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('festivals.html', festivals=festivals)

@app.route('/festival_detail<int:festival_id>')
def festival_detail(festival_id):
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    # Festival details
    cur.execute('''
        SELECT f.*, l.city, l.country
        FROM festival f
        JOIN location l ON f.location_id = l.location_id
        WHERE f.festival_id = %s
    ''', (festival_id,))
    festival = cur.fetchone()

    # Events
    cur.execute('''
        SELECT e.*, b.building_name
        FROM event e
        JOIN building b ON e.building_id = b.building_id
        WHERE e.festival_id = %s
        ORDER BY e.event_start_time
    ''', (festival_id,))
    events = cur.fetchall()

    # Artists
    cur.execute('''
        SELECT DISTINCT a.*
        FROM artist a
        JOIN performance p ON a.artist_id = p.artist_id
        JOIN event e ON p.event_id = e.event_id
        WHERE e.festival_id = %s
    ''', (festival_id,))
    artists = cur.fetchall()

    # Bands
    cur.execute('''
        SELECT DISTINCT b.*
        FROM band b
        JOIN performance p ON b.band_id = p.band_id
        JOIN event e ON p.event_id = e.event_id
        WHERE e.festival_id = %s
    ''', (festival_id,))
    bands = cur.fetchall()

    cur.close()
    conn.close()
    return render_template('festival_detail.html', festival=festival, events=events, artists=artists, bands=bands)

@app.route('/artists')
def artists():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute('SELECT * FROM artist')
    artists = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('artists.html', artists=artists)

@app.route('/bands')
def bands():
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute('SELECT * FROM band')
    bands = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('bands.html', bands=bands)

@app.route('/query', methods=['GET', 'POST'])
def query():
    result = None
    error = None
    query_text = ''
    columns = []
    
    if request.method == 'POST':
        query_text = request.form['query']
        
        # Prevent destructive queries in this simple implementation
        query_lower = query_text.lower()
        if any(word in query_lower for word in ['drop', 'delete', 'truncate', 'insert', 'update', 'alter', 'create']):
            error = "For safety reasons, only SELECT queries are allowed."
        else:
            try:
                conn = get_db_connection()
                cur = conn.cursor(dictionary=True)
                cur.execute(query_text)
                
                if query_lower.strip().startswith('select'):
                    result = cur.fetchall()
                    if result:
                        columns = list(result[0].keys())
                else:
                    conn.commit()
                    result = [{'affected_rows': cur.rowcount}]
                    columns = ['affected_rows']
                
                cur.close()
                conn.close()
            except Exception as e:
                error = f"Error executing query: {str(e)}"
    
    # Get table names for the helper sidebar
    tables = []
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SHOW TABLES")
        tables = [table[0] for table in cur.fetchall()]
        cur.close()
        conn.close()
    except:
        # If we can't get tables, just continue
        pass
    
    return render_template('query.html', 
                          result=result, 
                          columns=columns, 
                          query=query_text, 
                          error=error,
                          tables=tables)

if __name__ == '__main__':
    app.run(debug=True)