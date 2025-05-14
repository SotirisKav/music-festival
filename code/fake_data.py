from faker import Faker  # type: ignore
import random
from datetime import datetime, time, timedelta
from collections import defaultdict

fake = Faker()

# --- LOCATIONS ---
locations_info = {
    "Athens": ("Greece", "Europe", (23.70, 23.80), (37.95, 38.05)),
    "Amsterdam": ("Netherlands", "Europe", (4.85, 4.95), (52.35, 52.40)),
    "New York": ("USA", "North America", (-74.00, -73.95), (40.70, 40.80)),
    "Tokyo": ("Japan", "Asia", (139.68, 139.75), (35.65, 35.70)),
    "Rio de Janeiro": ("Brazil", "South America", (-43.25, -43.15), (-23.00, -22.90)),
    "Sydney": ("Australia", "Oceania", (151.20, 151.25), (-33.90, -33.85)),
    "Madrid": ("Spain", "Europe", (-3.72, -3.68), (40.40, 40.45)),
    "Berlin": ("Germany", "Europe", (13.32, 13.40), (52.50, 52.55)),
    "Hong Kong": ("China", "Asia", (114.15, 114.20), (22.30, 22.35)),
    "Istanbul": ("Turkey", "Asia", (28.95, 29.00), (41.00, 41.05)),
    "Shanghai": ("China", "Asia", (121.45, 121.50), (31.22, 31.25)),
    "Paris": ("France", "Europe", (2.30, 2.35), (48.85, 48.87)),
    "San Francisco": ("USA", "North America", (-122.42, -122.40), (37.78, 37.79)),
    "Toronto": ("Canada", "North America", (-79.40, -79.38), (43.65, 43.68)),
    "Seoul": ("South Korea", "Asia", (126.97, 127.03), (37.55, 37.60)),
    "Cape Town": ("South Africa", "Africa", (18.42, 18.45), (-33.93, -33.90)),
    "Buenos Aires": ("Argentina", "South America", (-58.45, -58.40), (-34.61, -34.59)),
    "Mexico City": ("Mexico", "North America", (-99.15, -99.10), (19.40, 19.45)),
    "Bangkok": ("Thailand", "Asia", (100.50, 100.55), (13.72, 13.78)),
    "Dubai": ("UAE", "Asia", (55.27, 55.30), (25.20, 25.25)),
    "Dublin": ("Ireland", "Europe", (-6.27, -6.22), (53.33, 53.36)),
    "Copenhagen": ("Denmark", "Europe", (12.54, 12.59), (55.67, 55.70)),
    "Helsinki": ("Finland", "Europe", (24.93, 24.96), (60.16, 60.18)),
    "Singapore": ("Singapore", "Asia", (103.81, 103.85), (1.28, 1.30))
}


data = []

# Generate 12 unique locations
unique_locations = random.sample(list(locations_info.items()), 12)

for i, (city, (country, continent, lon_range, lat_range)) in enumerate(unique_locations,start=1):
    address = fake.street_address().replace('"', "").replace("'", "")
    lon = round(random.uniform(*lon_range), 6)
    lat = round(random.uniform(*lat_range), 6)
    loc_sql = (
        f"INSERT INTO location (location_id, address, coordinates, city, country, continent) VALUES "
        f"({i}, '{address}', ST_GeomFromText('POINT({lon} {lat})'), '{city}', '{country}', '{continent}');"
    )
    data.append(loc_sql)

# --- FESTIVALS ---
poster_image_urls = [
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image1.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image2.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image3.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image4.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image5.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image6.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image7.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image8.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image9.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image10.png",
    "https://raw.githubusercontent.com/SotirisKav/music-festival/main/docs/image11.png"
]
festival_descriptions = [
    "An annual celebration of diverse musical genres under one sky, featuring global headliners and emerging artists.",
    "A weekend-long open-air festival combining live music, art installations, and gourmet food trucks.",
    "A city-center block-party style event showcasing indie rock, electronic sets, and local craft vendors.",
    "A seaside sunset festival with chilled beats, acoustic sessions, and panoramic ocean views.",
    "A multi-stage extravaganza spotlighting classical ensembles, jazz acts, and avant-garde performances.",
    "A family-friendly festival with interactive workshops, kid-friendly stages, and community art projects.",
    "A late-night electronic music event with immersive light shows and underground DJ lineups.",
    "A heritage folk festival celebrating traditional sounds, dance troupes, and artisanal crafts.",
    "A charity-driven music gathering where ticket proceeds support local music education programs.",
    "A green festival powered entirely by renewable energy, featuring eco-workshops and sustainable vendors.",
    "A boutique boutique festival set within a historic estate, mixing vintage vibes with modern acts.",
    "A cross-cultural music festival bridging East and West through collaborative performances and fusion acts.",
]
festival_location_ids = random.sample(range(1, 13), 12)
start_dates = []
end_dates = []
random.shuffle(poster_image_urls)
random.shuffle(festival_descriptions)
poster_image_url = []
festival_description = [] 
for i in range(12):
    festival_year = 2016+i
    start_dates.append(datetime(festival_year, random.randint(1, 12), random.randint(1, 25)))
    end_dates.append(start_dates[i] + timedelta(days=random.randint(1, 10)))
    poster_image_url.append(poster_image_urls[i])
    festival_description.append(festival_descriptions[i].replace('"', "").replace("'", ""))
    # Ensure the location_id is unique for each festival
    fest_sql = (
        f"INSERT INTO festival (festival_id, festival_year, start_date, end_date, location_id, poster_image_url," 
        f" festival_description) VALUES "
        f"({i+1}, {festival_year}, '{start_dates[i].date()}', '{end_dates[i].date()}', {festival_location_ids[i]}, '{poster_image_url[i]}', '{festival_description[i]}');"
    )
    data.append(fest_sql)

# --- BUILDINGS ---
equipment_pool = { 
    "PA speakers": ["https://thumbs.static-thomann.de/thumb/thumb250x250/pics/prod/230512.jpg"],
    "wireless microphones" : ["https://www.soundstar.gr/wp-content/uploads/2020/01/elite-mic-blue.jpg"],
    "mixing console": ["https://upload.wikimedia.org/wikipedia/commons/e/e4/SSL_SL9000J_%2872ch%29_%40_The_Cutting_Room_Recording_Studios%2C_NYC.jpg"],
    "Stage lights" : ["https://m.media-amazon.com/images/I/81ICAr-O9EL._AC_SL1500_.jpg"],
    "fog machine" : ["https://djmania.gr/36994-large_default/party-fog1200led-mhxanh-kapnou.jpg"],
    "DMX controller" : ["https://market1.gr/wp-content/uploads/2023/02/20190701100902_dmx_512_light_controller.webp"],
    "LED panels" : ["https://res.cloudinary.com/glowbackledstore/image/fetch/f_auto/https://cdn11.bigcommerce.com/s-51rsspef4j/images/stencil/1280x1280/products/896/10493/GlowbackLED_RGBW_Custom_LED_Panels_for_Web_680_x_560__54159.1678203080.jpg?c=1?imbypass=on"],
    "audio monitors" : ["https://djmania.gr/27424-home_default/multimedia-monitors-hxeia-m-audio-bx3.jpg"],
    "DI boxes" : ["https://musicland.gr/images/products/ashtondi10dibox.jpg"],
    "Subwoofers" : ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbQAC4KJoN-wegndQb9X8q4W_swrySLKtP_YbmkZ1HIQ&s&ec=72940542"],
    "DJ booth" : ["https://djmania.gr/32185-large_default/headliner-huntington-portable-dj-booth.jpg"],
    "moving head lights" : ["https://static.gooecloud.com/upload/img/GY369603158074/9b2cc46d3858620a44bd03aa7feee7d6.jpg?x-oss-process=image/format,webp/quality,Q_100"],
    "Projectors": ["https://d.scdn.gr/images/sku_main_images/048249/48249673/xlarge_20240603114830_magcubic_portable_projector_4k_projector_hd_me_wi_fi_kai_ensomatomena_icheia_leykos.jpeg"],
    "laser effects" : ["https://scx2.b-cdn.net/gfx/news/hires/2013/nplandardenp.jpg"],
    "ambient lighting" : ["https://thumbs.static-thomann.de/thumb/padthumb600x600/pics/bdb/_59/591166/19616009_800.jpg"],
    "In-ear monitors" : ["https://www.karatzios.gr//images/upload/items/30574.JPG"],
    "microphones" : ["https://thumbs.static-thomann.de/thumb/padthumb600x600/pics/bdb/_16/166058/12740867_800.jpg"],
    "MIDI controllers" : ["https://eshop.bonstudio.gr/image/cache/catalog/product-upload/LAUNCHKEY_MINI_37_MK4_2-1200x1200.jpg"],
    "Truss structures" : ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcYem_wdwhugemAvII0yTz0kk7I8LhlBgOfSkvh_zKqw&s&ec=72940542"],
    "power amps" : ["https://usa.yamaha.com/files/category_poweramps_202106_2abf68b4dba5e0b7550fb076d59b0d5e.jpg?impolicy=resize&imwid=1200&imhei=480"],
    "control desks" : ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTh31DhlrE8xmja-BJgM9LmHRvIyVCObgSFgpdYJxNH8Q&s&ec=72940542"],
    "Surround sound system" : ["https://www.fluance.com/media/catalog/product/cache/eaf9201cb9a6526c85e3e4abbda3f987/x/8/x871br-1500x1500.jpg"],
    "stage risers" : ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5vOCWf7h03L2HFoBH-i3YBoya7a0UaEBVwah63lsALA&s&ec=72940542"],
    "LED strips" : ["https://www.e-wireless.gr/images/detailed/20/rgb-strip-5050-60m.jpg"],
    "Digital console" : ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWPbIl5lcm_HyuGJPvGl4DLPZLc35G8h2GHSItGmoxKQ&s&ec=72940542"],
    "headsets" : ["https://multimedia.3m.com/mws/media/1072746J/3m-peltor-comtac-xpi-standard-headset-mt20h682fb-02.jpg?width=506"],
    "recording interface" : ["https://thumbs.static-thomann.de/thumb//thumb1000x/pics/cms/image/guide/en/home_recording/04_usb.jpg"],
    "Special effects (CO2 jets, confetti cannons, pyros)" : ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwagQ7vvoaZG940w2xOlvBunHtzSrTCi6ioCjawlF9qA&s&ec=72940542"],
    "Basic sound system and two spotlights" : ["https://thumbs.static-thomann.de/thumb/padthumb600x600/pics/bdb/_25/256728/8777694_800.jpg"],
    "Full touring-grade sound and lighting rig": ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh67K4QDmC3yzVLisYlXGdGcQphgWKWnd0I09w8GMhrA&s&ec=72940542"]
}
building_descriptions = [
    "A large indoor concert hall with state-of-the-art acoustics and stage lighting.",
    "An open-air amphitheater ideal for summer music festivals and theatrical performances.",
    "A multi-level cultural center with rehearsal rooms, studios, and a central stage.",
    "A flexible black box venue suited for experimental music performances.",
    "A restored industrial building with raw aesthetics and excellent acoustics.",
    "A minimalist performance space designed for acoustic sets and intimate shows.",
    "An underground venue with immersive lighting and surround sound capabilities.",
    "A high-capacity arena capable of hosting large-scale international music acts.",
    "A community arts space often used for jazz nights and local band showcases.",
    "A former church converted into a concert hall with gothic architecture.",
    "An eco-friendly venue built using sustainable materials and solar-powered lighting.",
    "A waterfront stage built on floating platforms with 360 deg audience access.",
]

max_capacity = {}

for b_id in range(1,31):
    name = f"{fake.last_name()} Stage"
    max_capacity[b_id] = random.randint(10, 75)
    equip = random.sample(list(equipment_pool.keys()), k=random.randint(3, 7))
    equipment = ", ".join(equip)
    description = random.choice(building_descriptions).replace('"', "").replace("'", "")
    equip_urls = [equipment_pool[e][0] for e in equip]
    equipment_urls = ", ".join(equip_urls)
    build_sql = (
        f"INSERT INTO building (building_id, building_name, building_description, maximum_capacity, necessary_equipment, equipment_image_url) "
        f"VALUES ({b_id}, '{name}', '{description}', {max_capacity[b_id]}, '{equipment}', '{equipment_urls}');"
    )
    data.append(build_sql)


# --- STAFF ---
experiences = ['beginner', 'intermediate', 'experienced', 'very experienced', 'professional']
roles_by_category = {
    "technical": [
        "Sound Technician",
        "Lighting Technician",
        "Stage Manager",
        "Backline Technician",
        "AV Specialist",
        "Broadcast Engineer",
        "Stage Rigger",
        "Technical Director",
        "Multimedia Operator",
        "IT Support Engineer"
    ],
    "security": [
        "Security Staff",
        "Entrance Control",
        "Crowd Manager",
        "Surveillance Operator",
        "Backstage Security",
        "Fire Safety Officer",
        "Gate Supervisor",
        "Perimeter Patrol",
        "Emergency Response Coordinator"
    ],
    "support": [
        "Hospitality Assistant",
        "Volunteer Coordinator",
        "First Aid Responder",
        "Info Desk Staff",
        "Cleaning Supervisor",
        "Food & Beverage Staff",
        "Transport Coordinator",
        "Artist Liaison",
        "Logistics Assistant",
        "Accreditation Officer"
    ]
}

staff_id = 1

def generate_staff(number_of_staff, category, b_id):
    global staff_id
    for _ in range(number_of_staff):
        first_name = fake.first_name().replace("'", "")
        last_name = fake.last_name().replace("'", "")
        age = random.randint(18, 65)
        role = random.choice(roles_by_category[category])
        experience = random.choice(experiences)

        data.append(
            f"INSERT INTO staff (staff_id, category, first_name, last_name, age, role, experience, building_id) VALUES "
            f"({staff_id}, '{category}', '{first_name}', '{last_name}', {age}, '{role}', '{experience}', {b_id});"
        )
        staff_id += 1


for b_id in range(1, 31):
    # Generate staff for each building
    n_security = random.randint(max(1, round(max_capacity[b_id] * 0.05)), 
    max(1, 10 * round(max_capacity[b_id] * 0.05)))
    n_support = random.randint(max(1, round(max_capacity[b_id] * 0.02)), 
    max(1, 10 * round(max_capacity[b_id] * 0.02)))
    n_technical = random.randint(5, 15) 

    generate_staff(n_security, "security", b_id)
    generate_staff(n_support, "support", b_id)
    generate_staff(n_technical, "technical", b_id)

# --- EVENTS ---
# Generate events for each festival
event_id = 1
event_info = []
maximum_event_tickets = {}
def generate_events(fest_id, building_id, number_of_events, festival_date):
    global event_id

    day_start = datetime.combine(festival_date, time(17, 0))
    day_end = datetime.combine(festival_date, time(23, 0))
    total_minutes = 360  # Total minutes in the time window (17:00 to 23:00)
    
    # Create random durations for the events
    # Randomly generate (n - 1) breakpoints to split the total duration into n intervals
    breaks = sorted(random.sample(range(1, total_minutes), number_of_events - 1))
    # Convert breakpoints into actual durations for each event
    durations = [a - b for a, b in zip(breaks + [total_minutes], [0] + breaks)]

    # Generate events according to the durations
    event_start_date = day_start
    for d in durations:
        event_end_date = event_start_date + timedelta(minutes=d)
        event_name = fake.catch_phrase().replace("'", "").replace('"', "")
        data.append(
            f"INSERT INTO event (event_id, event_name, event_start_time, event_end_time, festival_id, building_id) VALUES "
            f"({event_id}, '{event_name}', '{event_start_date}', '{event_end_date}', {fest_id}, {building_id});"
        )
        max_event_tickets = max_capacity[building_id]
        maximum_event_tickets[event_id] = max_event_tickets
        event_info.append({
            'id': event_id,
            'start_time': event_start_date,
            'end_time': event_end_date,
            'building_id': building_id
        })
        event_id += 1
        event_start_date = event_end_date

for fest_id in range(1,13):
    duration_days  = (end_dates[fest_id-1] - start_dates[fest_id-1]).days + 1
    # Generate buildings for each festival based on the duration of the festival
    # Ensure the number of buildings is at most one per day of the festival
    festival_buildings = random.sample(range(1,31),random.randint(1,duration_days))
    
    # Ensure that each building from festival_buildings is used at least once
    used_buildings = festival_buildings.copy()

    remaining = duration_days - len(used_buildings)
    
    # If there are remaining days without buildings, fill them with random buildings from festival_buildings
    if remaining > 0:
        # Randomly select additional buildings to fill the remaining days
        used_buildings += random.choices(festival_buildings, k=remaining)
    
    for day_offset in range(duration_days):
        number_of_events = random.randint(1, 3)  # Random number of events per day
        # Generate events for the festival
        event_date = start_dates[fest_id - 1] + timedelta(days=day_offset)
        generate_events(fest_id, used_buildings[day_offset], number_of_events, event_date)

total_events = event_id - 1

# --- ARTISTS AND BANDS ---
music_genres_subgenres = {
    "Rock": ["Alternative Rock", "Indie Rock", "Hard Rock"],
    "Pop": ["Synth-pop", "Electro-pop", "Indie Pop"],
    "Electronic": ["House", "Techno", "Trance"],
    "Jazz": ["Smooth Jazz", "Bebop", "Vocal Jazz"],
    "Hip-Hop": ["Trap", "Boom Bap", "Lo-fi"],
    "Classical": ["Baroque", "Romantic", "Contemporary"],
    "Reggae": ["Dub", "Dancehall", "Roots"],
    "Metal": ["Black Metal", "Power Metal", "Death Metal"]
}

# Generate music genres and subgenres
genre_id = 1
subgenre_id = 1
genre_info = {} # {genre_id: {"name": genre_name, "subgenre_ids": []}}
for genre, subgenres in music_genres_subgenres.items():
    genre_info[genre_id] = {
        "name": genre,
        "subgenre_ids": []
    }
    genre_sql = f"INSERT INTO genre (genre_id, genre_name) VALUES ({genre_id}, '{genre}');"
    data.append(genre_sql)
    for subgenre in subgenres:
        genre_info[genre_id]["subgenre_ids"].append(subgenre_id)
        subgenre_sql = f"INSERT INTO subgenre (subgenre_id, subgenre_name, genre_id) VALUES ({subgenre_id}, '{subgenre}', {genre_id});"
        data.append(subgenre_sql)
        subgenre_id += 1
    genre_id += 1

# Generate 36 artists
artist_image_urls = [
    "https://ew.com/thmb/IVjmtfkRu2ZP4GDYmiFkPUe7yTc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Weeknd-d4fb08e62a924691a18af068d9bfa972.jpg",
    "https://www.billboard.com/wp-content/uploads/2022/06/Beyonce-cr-Courtesy-of-Parkwood-Entertainment-press-2022-billboard-1548.jpg",
    "https://townsquare.media/site/812/files/2024/08/attachment-drake-1.jpg?w=780&q=75",
    "https://variety.com/wp-content/uploads/2017/11/kendrick-lamar-variety-hitmakers.jpg",
    "https://ca-times.brightspotcdn.com/dims4/default/aa11971/2147483647/strip/true/crop/3850x4749+0+0/resize/1200x1480!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F47%2F75%2Ffcdbe1b14591b3877dabb292bdd7%2Fgettyimages-677036417.jpg",
    "https://i.scdn.co/image/ab6761610000e5ebc36dd9eb55fb0db4911f25dd",
    "https://thevinylfactory.com/wp-content/uploads/2016/03/JB.jpg",
    "https://www.hollywoodreporter.com/wp-content/uploads/2023/02/Jay-Z-Harder-They-Fall-Carpet-GettyImages-1346461777-H-2023.jpg?w=1296&h=730&crop=1",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5ElvSNyZMrFDtXPKEbCKwePBoB9NloP02ay9WO9dfgA&s&ec=72940542",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbRS9NW1ifZLKaEP0I3pjpoA-1Kax7cXJmv0PjMKGhFA&s&ec=72940542",
    "https://i.scdn.co/image/ab6761610000e5eb99e4fca7c0b7cb166d915789",
    "https://ucarecdn.com/a5a3383e-8452-498b-81f3-3272da6137d9/-/crop/778x777/164,34/-/preview/-/progressive/yes/-/format/auto/",
    "https://m.media-amazon.com/images/M/MV5BMTg1NjQwMzU4MF5BMl5BanBnXkFtZTgwNTk5NjQ4NjE@._V1_FMjpg_UX1000_.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2YbrA18Tt9Uj3tCxMacS98U8JgYFCCQH4P9kBJHY_vA&s&ec=72940542",
    "https://m.media-amazon.com/images/M/MV5BM2JhZWJmMDEtNTU5MS00YmQ3LTk1NjMtOGFlMjM2MjZlNjg5XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
    "https://d3i6fh83elv35t.cloudfront.net/newshour/app/uploads/2015/12/GettyImages-85339538-1024x889.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDYDyWSrew31Q98r9WD7jVDCkL9j7i01_6lSqYsNIzKg&s&ec=72940542",
    "https://images.squarespace-cdn.com/content/v1/5ab4b825e2ccd1ccdd10d144/94357b7c-7702-4edd-acb5-f097fae72dcb/Bryan+Adams",
    "https://variety.com/wp-content/uploads/2025/02/GettyImages-2197299756-e1738943649162.jpg?w=1000&h=667&crop=1",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzQHJ3rAmXhXQ58TVE63HRWXCel0DouKN6rq2ksbtXcQ&s&ec=72940542",
    "https://ntvb.tmsimg.com/assets/assets/673344_v9_bb.jpg",
    "https://gdb.rferl.org/a6342480-4b26-46b9-b0a9-6510397d5c94_w1071_s_d3.jpg",
    "https://cdn-images.dzcdn.net/images/artist/935d35a45e061e7640a0becfa42cef6e/500x500.jpg",
    "https://preview.redd.it/madonna-young-and-pre-surgery-v0-dotws1k6bkpa1.jpg?width=720&format=pjpg&auto=webp&s=d51fe3671251515c4fdc8b47d27f0f59f8e32648",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQv6FWFg6nOro7cOo3XDlwn-IGOl0bkCd2QZkbO_-EUPA&s&ec=72940542",
    "https://ichef.bbci.co.uk/images/ic/480xn/p0bp7gb6.jpg.webp",
    "https://static01.nyt.com/images/2016/12/25/magazine/25tltl-prince1/25tltl-prince-master495.jpg",
    "https://yt3.googleusercontent.com/AqG9RNaBhi2G43JPWB8rXv_JrSdW0mU8kTegqVIIC-4TteZHuetVIa67QGviYjgD9eZNYnQZ=s900-c-k-c0x00ffffff-no-rj",
    "https://www.songhall.org/images/uploads/exhibits/Michael_Jackson.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTucBlRUkn7EI2VD_dHMuCKCxqy-5g5l_MZM2f3LRP_Fg&s&ec=72940542",
    "https://hips.hearstapps.com/hmg-prod/images/gettyimages-144485756.jpg?crop=1xw:1.0xh;center,top&resize=640:*",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToeGVuX1ltcwfSV7uzSAKosCgyoa22e6tATC3HuqnS7Q&s&ec=72940542",
    "https://i.scdn.co/image/ab67616100005174ba4ddda6af00a6927a4f307c",
    "https://media.zenfs.com/en/parade_250/edf923147e179d27291ca916156812ca",
    "https://www.eltonjohn.com/cms/wp-content/uploads/2023/10/1511444647ej_from_live.jpg",
    "https://media.gq-magazine.co.uk/photos/602fd67c9cae2cdede780a51/1:1/w_1280,h_1280,c_limit/18022021_Kurt_05.jpg"
]
artist_names = [
    "The Weeknd",
    "Beyonce",
    "Drake",
    "Kendrick Lamar",
    "George Michael",
    "Bruno Mars",
    "Jeff Buckley",
    "Jay-Z",
    "Adele",
    "Bruce Springsteen",
    "Rihanna",
    "Tyler, The Creator",
    "Lady Gaga",
    "Future",
    "Ariana Grande",
    "Frank Sinatra",
    "Billy Joel",
    "Bryan Adams",
    "Kanye West",
    "Frank Ocean",
    "A$AP Rocky",
    "Bob Dylan",
    "Elvis Presley",
    "Madonna",
    "Stevie Wonder",
    "Bob Marley",
    "Prince",
    "David Bowie",
    "Michael Jackson",
    "Amy Winehouse",
    "Whitney Houston",
    "Freddie Mercury",
    "John Lennon",
    "Travis Scott",
    "Elton John",
    "Kurt Cobain"
]

artist_nicknames = [
    "XO",          # The Weeknd
    "Queen B",     # Beyonce
    "Drizzy",      # Drake
    "K.Dot",       # Kendrick Lamar
    "Wham!",       # George Michael
    "Little Man",  # Bruno Mars
    "Buck",        # Jeff Buckley
    "Hov",         # Jay-Z
    "The Voice",   # Adele
    "The Boss",    # Bruce Springsteen
    "RiRi",        # Rihanna
    "Wolf Haley",  # Tyler, The Creator
    "Mother Monster", # Lady Gaga
    "Pluto",       # Future
    "Ari",         # Ariana Grande
    "Ol' Blue Eyes", # Frank Sinatra
    "The Piano Man", # Billy Joel
    "The Summer of 69", # Bryan Adams
    "Ye",          # Kanye West
    "Lonny",       # Frank Ocean
    "Pretty Flacko", # A$AP Rocky
    "Zimmy",       # Bob Dylan
    "The King",    # Elvis Presley
    "Material Girl", # Madonna
    "Little Stevie", # Stevie Wonder
    "The Tuff Gong", # Bob Marley
    "The Purple One", # Prince
    "Ziggy Stardust", # David Bowie
    "MJ",          # Michael Jackson
    "Winehouse",   # Amy Winehouse
    "Nippy",       # Whitney Houston
    "The King of Queen", # Freddie Mercury
    "The Walrus",  # John Lennon
    "La Flame",    # Travis Scott
    "Rocket Man",  # Elton John
    "The Nirvana King" # Kurt Cobain
]

artist_descriptions = [
    "A boundary-pushing artist whose atmospheric, emotive vocals and experimental R&B production make him one of the most innovative stars of modern pop music.",  # The Weeknd
    "A powerhouse vocalist with unmatched stage presence and an ability to blend genres, from R&B to pop, making her an international icon.",  # Beyonc?
    "A versatile rapper and artist whose introspective lyrics and chart-topping hits have made him a defining figure in hip-hop.",  # Drake
    "A poet and storyteller whose powerful rhymes and thought-provoking lyricism have solidified him as one of hip-hop's finest.",  # Kendrick Lamar
    "An iconic pop and soul singer whose heartfelt songs and revolutionary style reshaped the music landscape.",  # George Michael
    "A smooth and soulful vocalist known for his powerful voice, blending pop, funk, and soul in a way that has captured generations.",  # Bruno Mars
    "A gifted singer-songwriter whose haunting voice and emotional depth leave a lasting impact on listeners and critics alike.",  # Jeff Buckley
    "A rap mogul and cultural icon whose entrepreneurial spirit and impactful lyrics have made him one of the greatest in the game.",  # Jay-Z
    "A powerhouse vocalist with a rich and emotional voice that has earned her critical acclaim and a global following.",  # Adele
    "An American rock legend whose anthems and enduring stage presence have earned him the title of 'The Boss' in rock music.",  # Bruce Springsteen
    "A pop and R&B sensation known for her infectious melodies and empowering messages that resonate with fans worldwide.",  # Rihanna
    "A rapper and visionary known for his experimental approach to hip-hop and his boundary-pushing music.",  # Tyler, The Creator
    "A larger-than-life pop icon whose eclectic fashion and bold performances have solidified her as a trailblazer in the music industry.",  # Lady Gaga
    "An innovative rapper whose genre-defying production and introspective lyrics have made him a force in hip-hop and beyond.",  # Future
    "A pop star known for her stunning vocal range and unforgettable ballads, Ariana has become an icon for a generation.",  # Ariana Grande
    "A legendary crooner whose smooth vocals and timeless style have made him an icon in American music history.",  # Frank Sinatra
    "A singer-songwriter whose piano-driven hits have earned him a devoted following and a legacy as one of the greatest of all time.",  # Billy Joel
    "A Canadian singer known for his anthems of love, heartbreak, and resilience, with a career spanning multiple decades.",  # Bryan Adams
    "A revolutionary artist whose influence spans music, fashion, and culture, Kanye is a polarizing yet undeniable force in pop and hip-hop.",  # Kanye West
    "A soulful R&B singer whose introspective and innovative music has made him one of the most influential artists of his generation.",  # Frank Ocean
    "A rapper with a larger-than-life presence, known for his unique fashion and his raw, honest lyrics that have shaped modern hip-hop.",  # A$AP Rocky
    "A folk and rock legend whose timeless lyrics and melodies continue to inspire generations of musicians and fans alike.",  # Bob Dylan
    "The King of Rock and Roll, whose revolutionary music and electrifying stage presence forever changed the landscape of popular music.",  # Elvis Presley
    "A pop icon whose provocative style and boundary-pushing approach to music have made her one of the most influential artists in history.",  # Madonna
    "A legendary soul singer whose uplifting and emotionally charged songs have inspired generations of fans worldwide.",  # Stevie Wonder
    "A reggae icon whose spiritually charged lyrics and distinctive sound helped define the genre and spread its message globally.",  # Bob Marley
    "An enigmatic and genre-defying artist whose groundbreaking music and revolutionary style have cemented his status as an icon.",  # Prince
    "A British pop icon whose eclectic style and artistic reinventions have made him one of the most influential artists of all time.",  # David Bowie
    "The King of Pop, whose groundbreaking music, iconic dance moves, and global influence have made him a legend in pop culture.",  # Michael Jackson
    "A soulful and deeply emotional artist whose unique voice and deeply personal music have earned her a devoted following.",  # Amy Winehouse
    "A towering figure in the music world whose unparalleled vocal ability and trailblazing style have made her one of the most iconic pop stars of all time.",  # Whitney Houston
    "The legendary frontman of Queen, whose theatrical performances and powerful voice helped define rock music for decades.",  # Freddie Mercury
    "A visionary artist whose groundbreaking contributions to music and culture have solidified his place as one of the most influential figures in rock.",  # John Lennon
    "A rapper and producer whose high-energy performances and innovative music have made him one of the biggest stars in modern hip-hop.",  # Travis Scott
    "A British pop legend whose music, fashion, and activism have made him a trailblazer in pop and rock music.",  # Elton John
    "A grunge icon whose raw emotion and unapologetic lyrics have made him a defining figure in the alternative rock movement."  # Kurt Cobain
]

for artist_id in range(1, len(artist_names)+1):
    first_name = artist_names[artist_id - 1].split()[0].replace("'", "")
    last_name = artist_names[artist_id - 1].split()[-1] .replace("'", "")
    nickname = artist_nicknames[artist_id - 1].replace("'", "")
    date_of_birth = fake.date_of_birth(minimum_age=18, maximum_age=60).strftime('%Y-%m-%d')
    website = f"https://{nickname.lower()}.music.com"
    instagram = f"@{nickname.lower().replace(' ', '_')}"
    image_url = artist_image_urls[artist_id-1]
    description = artist_descriptions[artist_id - 1].replace('"', "").replace("'", "")

    artist_sql = (
        f"INSERT INTO artist (artist_id, artist_first_name, artist_last_name, artist_nickname, date_of_birth, "
        f"artist_website, artist_instagram, artist_image_url, artist_description) VALUES "
        f"({artist_id}, '{first_name}', '{last_name}', '{nickname}', '{date_of_birth}', "
        f"'{website}', '{instagram}', '{image_url}', '{description}');"
    )
    data.append(artist_sql)

# Generate genres and subgenres for each artist

def generate_artist_subgenres(artist_id, genre_id):
    possible_subgenres_id = genre_info[genre_id]["subgenre_ids"]
    sub_id = random.sample(possible_subgenres_id, k=random.randint(1, 3))  # Randomly select 1 or 3 subgenres
    for s_id in sub_id:
        artist_subgenre_sql = f"INSERT INTO artist_subgenre (artist_id, subgenre_id) VALUES ({artist_id}, {s_id});"
        data.append(artist_subgenre_sql)

for artist_id in range(1, 36):
    artist_genres_id = random.sample(range(1, genre_id), k=random.randint(1, 2))
    for gen_id in artist_genres_id:
        artist_genre_sql = f"INSERT INTO artist_genre (artist_id, genre_id) VALUES ({artist_id}, {gen_id});"
        data.append(artist_genre_sql)
        generate_artist_subgenres(artist_id, gen_id)
        

# Generate 16 bands
band_image_urls = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Beatles_ad_1965_just_the_beatles_crop.jpg/960px-Beatles_ad_1965_just_the_beatles_crop.jpg",
    "https://i.scdn.co/image/b040846ceba13c3e9c125d68389491094e7f2982",
    "https://cdn.britannica.com/41/197341-050-4859B808/The-Rolling-Stones-Bill-Wyman-Keith-Richards-1964.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Led_Zeppelin_-_promotional_image_%281971%29.jpg/1200px-Led_Zeppelin_-_promotional_image_%281971%29.jpg",
    "https://www.rollingstone.com/wp-content/uploads/2023/01/P82F7-c-Hipgnosis-Pink-Floyd-Music-Ltd.jpg",
    "https://www.billboard.com/wp-content/uploads/2023/10/U2-cr-Helena-Christensen-press-2023-billboard-pro-1260.jpg",
    "https://www.rollingstone.com/wp-content/uploads/2021/06/metallica-album-guide.jpg",
    "https://hips.hearstapps.com/hmg-prod/images/john-mcvie-christine-mcvie-stevie-nicks-mick-fleetwood-and-news-photo-1622483347.jpg?crop=0.699xw:1.00xh;0.248xw,0&resize=1200:*",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTX4UYNp46_L0v1wbsuPohQk2_q52W7MavJrkisKtIUQ&s&ec=72940542",
    "https://www.rollingstone.com/wp-content/uploads/2020/10/10025-01E-JC-white_group_4559_sRGB.jpg?w=1581&h=1054&crop=1",
    "https://ca-times.brightspotcdn.com/dims4/default/cb16b10/2147483647/strip/true/crop/4935x3290+0+0/resize/2400x1600!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F5b%2F33%2Ff367fb35474d864941e977e5f48e%2F927846-ca-0321-red-hot-chili-peppers-sunday-calendar-cover-mrt-02.jpg",
    "https://cdn.britannica.com/34/265634-050-F82CE0A4/guns-n-roses-at-uic-pavillion-chicago-illinois-august-21-1987.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFv3hPkHFqvBGC66x70VdqgxPlSzftYOjYti8oFRfwkA&s&ec=72940542",
    "https://cdn.britannica.com/98/162198-050-6452139D/Radiohead-business-models-British-performers-innovator-Internet-2012.jpg",
    "https://i.scdn.co/image/ab6761610000e5eb1ba8fc5f5c73e7e9313cc6eb",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwQtoqu0n7di7F8I9Cq0EwkkFUVTOhOBXhq7qHZEQJsQ&s&ec=72940542"
]

band_names = [
    "The Beatles",
    "Queen",
    "The Rolling Stones",
    "Led Zeppelin",
    "Pink Floyd",
    "U2",
    "Metallica",
    "Fleetwood Mac",
    "Nirvana",
    "AC/DC",
    "Red Hot Chili Peppers",
    "Guns N' Roses",
    "The Who",
    "Radiohead",
    "Coldplay",
    "Arctic Monkeys"
]

band_nicknames = [
    "The Fab Four",  # The Beatles
    "The Champions",  # Queen
    "The Stones",  # The Rolling Stones
    "Led Zep",  # Led Zeppelin
    "The Floyd",  # Pink Floyd
    "The Joshua Tree",  # U2
    "The Gods of Metal",  # Metallica
    "The Mac",  # Fleetwood Mac
    "The Seattle Sound",  # Nirvana
    "The Rock Gods",  # AC/DC
    "The Peppers",  # Red Hot Chili Peppers
    "Gunners",  # Guns N' Roses
    "The Mods",  # The Who
    "The Oxford Legends",  # Radiohead
    "The Coldplay Crew",  # Coldplay
    "The Arctic Boys"  # Arctic Monkeys
]

band_descriptions = [
    "An iconic band from Liverpool, England, that revolutionized pop music and became the best-selling music artists of all time.",  # The Beatles
    "A British rock band led by Freddie Mercury, known for their eclectic sound, theatrical performances, and anthemic hits like 'Bohemian Rhapsody'.",  # Queen
    "A legendary rock band, whose music blends blues, rock, and rebellion, becoming one of the longest-running rock icons.",  # The Rolling Stones
    "A rock band that redefined heavy metal and hard rock, led by Jimmy Page and Robert Plant, producing timeless classics.",  # Led Zeppelin
    "A British progressive rock band known for their concept albums and philosophical, psychedelic music that reshaped the genre.",  # Pink Floyd
    "An Irish rock band whose anthemic sound and activism made them one of the most influential groups of the late 20th century.",  # U2
    "A metal band known for their intense, aggressive sound and one of the most successful rock bands in the world.",  # Metallica
    "A legendary British-American rock band blending blues, rock, and folk, known for their classic album 'Rumours'.",  # Fleetwood Mac
    "A pioneering grunge band from Seattle, led by Kurt Cobain, known for their raw emotion, haunting lyrics, and impact on rock music.",  # Nirvana
    "An Australian hard rock band famous for their high-energy performances and timeless hits like 'Back in Black'.",  # AC/DC
    "A funk-infused rock band from California, known for their energetic performances and unique blend of rock, funk, and soul.",  # Red Hot Chili Peppers
    "A hard rock band from Los Angeles whose songs like 'Sweet Child O' Mine' and 'November Rain' became anthems of the 80s.",  # Guns N' Roses
    "A legendary British rock band who helped shape the mod movement, known for their dynamic stage presence and rock anthems.",  # The Who
    "A British alternative rock band known for their experimental sound, with hits like 'Creep' and 'Paranoid Android'.",  # Radiohead
    "A British alternative rock band that blends melodic rock with anthemic sounds, achieving worldwide success with albums like 'X&Y'.",  # Coldplay
    "A British rock band from Sheffield, known for their garage rock revival and energetic performances with songs like 'Do I Wanna Know?'.",  # Arctic Monkeys
]

for band_id in range(1, len(band_names)+1):  
    band_name = band_names[band_id - 1].replace("'", "")
    band_nickname = band_nicknames[band_id - 1].replace("'", "")
    date_of_formation = fake.date_between(start_date='-30y', end_date='-1y').strftime('%Y-%m-%d')
    website = f"https://{band_name.lower().replace(' ', '')}.com"
    instagram = f"@{band_name.lower().replace(' ', '_')}"
    image_url =  band_image_urls[band_id-1]
    description = band_descriptions[band_id - 1].replace('"', "").replace("'", "")
    band_sql = (
        f"INSERT INTO band (band_id, band_name, band_nickname, date_of_formation, "
        f"band_website, band_instagram, band_image_url, band_description) VALUES "
        f"({band_id}, '{band_name}', '{band_nickname}', '{date_of_formation}', "
        f"'{website}', '{instagram}', '{image_url}', '{description}');"
    )
    data.append(band_sql)

# Generate genres and subgenres for each band

def generate_band_subgenres(band_id, genre_id):
    possible_subgenres_id = genre_info[genre_id]["subgenre_ids"]
    sub_id = random.sample(possible_subgenres_id, k=random.randint(1, 3))  # Randomly select 1 or 3 subgenres
    for s_id in sub_id:
        band_subgenre_sql = f"INSERT INTO band_subgenre (band_id, subgenre_id) VALUES ({band_id}, {s_id});"
        data.append(band_subgenre_sql)

for band_id in range(1, 16):
    band_genres_id = random.sample(range(1, genre_id), k=random.randint(1, 2))
    for gen_id in band_genres_id:
        band_genre_sql = f"INSERT INTO band_genre (band_id, genre_id) VALUES ({band_id}, {gen_id});"
        data.append(band_genre_sql)
        generate_band_subgenres(band_id, gen_id)

# Generate band members
band_members = defaultdict(list)
artist_ids = list(range(1, 36)) # List of artist IDs

for band_id in range(1, 16): 
    num_members = random.randint(2, 6)  # random number of members for each band
    selected_artists = random.sample(artist_ids, k=num_members)
    for artist_id in selected_artists:
        artist_band_sql = f"INSERT INTO artist_band (artist_id, band_id) VALUES ({artist_id}, {band_id});"
        data.append(artist_band_sql)
        band_members[band_id].append(artist_id)

artist_schedule = defaultdict(list)       
band_schedule = defaultdict(list)         


artist_years = defaultdict(set)          
band_years = defaultdict(set)

# procedures for insertion of bands , artists in performances 
def has_conflict(start, end, slots):
    for s, e in slots:
        if not (end <= s or start >= e):  
            return True
    return False

def has_more_than_3_consecutive_years(years_set, current_year):
    years = sorted(years_set | {current_year})
    count = 1
    for i in range(1, len(years)):
        if years[i] == years[i - 1] + 1:
            count += 1
            if count > 3:
                return True
        else:
            count = 1
    return False


def assign_artist_or_band_with_member_check(perf_start, perf_end, festival_year):
    
    candidates = list(range(1, 36)) + ['b_' + str(b) for b in range(1, 16)]
    random.shuffle(candidates)

    for candidate in candidates:
        if isinstance(candidate, int):
            if has_conflict(perf_start, perf_end, artist_schedule[candidate]):
                continue
            if has_more_than_3_consecutive_years(artist_years[candidate], festival_year):
                continue
           
            artist_schedule[candidate].append((perf_start, perf_end))
            artist_years[candidate].add(festival_year)
            return candidate, None  # (artist_id, band_id)

        else:  
            band_id = int(candidate[2:])

            if has_conflict(perf_start, perf_end, band_schedule[band_id]):
                continue
            if has_more_than_3_consecutive_years(band_years[band_id], festival_year):
                continue

            members = band_members.get(band_id, [])
            conflict_found = False

            for member_id in members:
                if has_conflict(perf_start, perf_end, artist_schedule[member_id]) or \
                   has_more_than_3_consecutive_years(artist_years[member_id], festival_year):
                    conflict_found = True
                    break

            if conflict_found:
                continue
            
            band_schedule[band_id].append((perf_start, perf_end))
            band_years[band_id].add(festival_year)

            for member_id in members:
                artist_schedule[member_id].append((perf_start, perf_end))
                artist_years[member_id].add(festival_year)

            return None, band_id

    return None, None  

# --- PERFORMANCES ---
# Generate performances for each event
performance_id = 1
performance_data = []
event_performances = defaultdict(list)

def generate_performances(event):
    global performance_id

    start_time = event['start_time']
    end_time = event['end_time']
    event_id = event['id']
    festival_year = start_time.year

    current_time = start_time

    while current_time + timedelta(minutes=15 + 5) <= end_time:
        max_duration = min(180, int((end_time - current_time).total_seconds() // 60) - 5)
        if max_duration < 15:
            break

        duration = random.randint(15, max_duration)
        break_time = random.randint(5, min(30, int((end_time - current_time).total_seconds() // 60 - duration)))

        perf_type = random.choice(['Warm up', 'Headline', 'Guest', 'Special Appearance'])
        perf_end = current_time + timedelta(minutes=duration)

        artist_id, band_id = assign_artist_or_band_with_member_check(current_time, perf_end, festival_year)
        if artist_id is None and band_id is None:
            continue

        artist_str = str(artist_id) if artist_id else "NULL"
        band_str = str(band_id) if band_id else "NULL"

        performance_data.append(
            f"INSERT INTO performance (performance_id, performance_type, performance_start_time, "
            f"performance_duration, event_id, artist_id, band_id) VALUES "
            f"({performance_id}, '{perf_type}', '{current_time}', {duration}, {event_id},  {artist_str}, {band_str});"
        )
        event_performances[event_id].append(performance_id)
        performance_id += 1
        current_time = perf_end + timedelta(minutes=break_time)

    if len(event_performances[event_id]) == 0:
        total_event_minutes = int((end_time - start_time).total_seconds() // 60)
        fallback_duration = min(20, total_event_minutes)
        if fallback_duration < 15:
            return
        fallback_type = random.choice(['Headline', 'Guest', 'Special Appearance'])
        fallback_end = start_time + timedelta(minutes=fallback_duration)

        artist_id, band_id = assign_artist_or_band_with_member_check(start_time, fallback_end, festival_year)
        if artist_id is not None or band_id is not None:
            artist_str = str(artist_id) if artist_id else "NULL"
            band_str = str(band_id) if band_id else "NULL"

            performance_data.append(
                f"INSERT INTO performance (performance_id, performance_type, performance_start_time, "
                f"performance_duration, event_id, artist_id, band_id) VALUES "
                f"({performance_id}, '{fallback_type}', '{start_time}', {fallback_duration}, {event_id}, {artist_str}, {band_str});"
            )
            event_performances[event_id].append(performance_id)
            performance_id += 1
        else:
            pass



for event in event_info:
    generate_performances(event)

data.extend(performance_data)


# --- TICKETS ---
# Generate tickets for each visitor

ticket_price_ranges = {
    "VIP": (60, 120),
    "General Entrance": (10, 50),
    "Backstage": (100, 200)
}

# create a temporary list to store ticket info
ticket_info = []
data_2 = []

ticket_id = 1

# Create a dictionary to keep track of the number of tickets for each event
tickets_count = { event['id']: 0 for event in event_info }

sold_out_events = []

def generate_realistic_festival_age():
    #(min, max, weight) 
    age_brackets = [
        (16, 17, 3),   # few teenagers
        (18, 21, 15),  # college-age - moderate number
        (22, 25, 25),  # young professionals - many
        (26, 30, 30),  # peak demographic - most common
        (31, 35, 20),  # professionals - many
        (36, 45, 15),  # gen-X - moderate number
        (46, 60, 8),   # older attendees - fewer
        (61, 85, 4)    # seniors - rare at festivals
    ]

    # Choose a bracket based on weights
    brackets = [b for b in age_brackets]
    weights = [b[2] for b in age_brackets]

    min_age, max_age, _ = random.choices(brackets, weights=weights, k=1)[0]
    return random.randint(min_age, max_age)

def generate_tickets(visitor_id, event_ids):
    global ticket_id
    visitor_first_name = fake.first_name()
    visitor_last_name = fake.last_name()
    visitor_phone = fake.phone_number()
    visitor_email = fake.email()
    visitor_age = generate_realistic_festival_age()
    for event_id in event_ids:
        if tickets_count[event_id] < maximum_event_tickets[event_id]:
            tickets_count[event_id] += 1
            base = str(event_id).zfill(3)  # Formatting event_id to 3 digits
            # Generate a unique EAN code for each ticket
            # The EAN code is a combination of the event_id and a unique sequence number
            suffix = str(ticket_id).zfill(10)  # Formatting ticket_id to 10 digits
            ean_code = (base + suffix)[-13:]  # Ensure the EAN code is 13 digits long
            
            category = random.choice(['VIP', 'General Entrance', 'Backstage'])
            event_date = next((event['start_time'] for event in event_info if event['id'] == event_id), None)
            now = datetime.now()
            # Assume the ticket can be purchased between 1 day and 2 years before the event
            if event_date < datetime.now():
                purchase_date = event_date - timedelta(days=random.randint(1, 730), hours=random.randint(0, 23), minutes=random.randint(0, 59))
            else: 
                # Assume that for every future event, the ticket can be purchased
                # between between the start of the 2nd year before the event and now
                min_purchase_year = event_date.year - 2
                min_purchase_date = datetime(min_purchase_year, 1, 1, 0, 0, 0)
                delta = now - min_purchase_date
                random_seconds = random.randint(0, int(delta.total_seconds()))
                purchase_date = min_purchase_date + timedelta(seconds=random_seconds)

            min_price, max_price = ticket_price_ranges[category]
            ticket_price = round(random.uniform(min_price, max_price), 1)
            payment_method = random.choice(['Credit Card', 'Debit Card', 'Bank Transfer'])
                
            # Check if the event date is in the past
            # A ticket can be scanned only if the event date is in the past
            if random.random() < 0.7 and event_date < now:
                visitor_value = str(visitor_id)
                scanned = True  # Ticket has been used (scanned at the gate)
            else:
                visitor_value = "NULL"
                scanned = False
            ticket_sql = (
                f"INSERT INTO ticket ("
                f"ticket_id, EAN, holder_first_name, holder_last_name, holder_phone_number, "
                f"holder_email, holder_age, category, purchase_date, ticket_price, payment_method, "
                f"scanned, event_id, visitor_id"
                f") VALUES ("
                f"{ticket_id}, '{ean_code}', '{visitor_first_name}', '{visitor_last_name}', '{visitor_phone}', "
                f"'{visitor_email}', {visitor_age}, '{category}', '{purchase_date}', {ticket_price}, "
                f"'{payment_method}', {scanned}, {event_id}, {visitor_value}"
                f");"
            )
            ticket_info.append({
                'ticket_id': ticket_id,
                'EAN': ean_code,
                'category': category,
                'purchase_date': purchase_date,
                'ticket_price': ticket_price,
                'scanned': scanned,
                'event_id': event_id,
                'visitor_id': visitor_id
            })
            data_2.append(ticket_sql)

            ticket_id += 1
        else :
            # If the event is sold out, add it to the sold_out_events list
            if event_id not in sold_out_events:
                sold_out_events.append(event_id)

# --- VISITORS ---
# Generate 400 visitors

visitor_events = {} # Dictionary to store events for each visitor
for visitor_id in range(1, 401):
    visitor_sql = (
        f"INSERT INTO visitor (visitor_id) VALUES "
        f"({visitor_id});"
    )
    data.append(visitor_sql)
    visitor_events[visitor_id] = random.sample(range(1, total_events + 1), k=random.randint(1, 25))  # Randomly select 1 to 25 events for each visitor
    generate_tickets(visitor_id, visitor_events[visitor_id])  # Generate tickets for the selected events
    for event_id in visitor_events[visitor_id]:
        visitor_event_sql = (
            f"INSERT INTO visitor_event (visitor_id, event_id) VALUES "
            f"({visitor_id}, {event_id});"
        )
        data.append(visitor_event_sql)

data.extend(data_2)

# --- REVIEW ---
review_id = 1

def generate_review(visitor_id, performances):
    global review_id
    grade_choices = ['Very Unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very Satisfied']

    for perf_id in performances:
        artist_performance_grade = random.choice(grade_choices)
        lighting_sound_grade     = random.choice(grade_choices)
        stage_presence_grade     = random.choice(grade_choices) 
        organization_grade       = random.choice(grade_choices)
        final_impression_grade   = random.choice(grade_choices)

        review_sql = (
            f"INSERT INTO review (review_id, artist_performance_grade, lighting_sound_grade, "
            f"stage_presence_grade, organization_grade, final_impression_grade, visitor_id, performance_id) "
            f"VALUES ({review_id}, "
            f"'{artist_performance_grade}', '{lighting_sound_grade}', "
            f"'{stage_presence_grade}', '{organization_grade}', "
            f"'{final_impression_grade}', {visitor_id}, {perf_id});"
        )
        data.append(review_sql)
        review_id += 1

for v_id in range(1, 401):
    for event_id in visitor_events[v_id]:
        scanned = next(
            (t['scanned'] for t in ticket_info
             if t['event_id']==event_id and t['visitor_id']==v_id), None)
        if scanned:
            generate_review(v_id, event_performances[event_id])

# --- SELLER_QUEUE ---
# Generate seller queue

seller_data = []
seller_queue_id = 1

def generate_seller_queue(ticket_info, event_info, portion=0.3):
    global seller_queue_id

    
    eligible_tickets = [t for t in ticket_info if not t['scanned']]
    selected_tickets = random.sample(eligible_tickets, k=int(len(eligible_tickets) * portion))

    temp_seller_rows = []

    for ticket in selected_tickets:
        event = next(e for e in event_info if e['id'] == ticket['event_id'])

        purchase_date = ticket['purchase_date']
        event_end = event['end_time']
        latest_possible = min(event_end, datetime.now())

        if purchase_date >= latest_possible:
            continue  # skip future sell attempts

        sell_date = fake.date_time_between(start_date=purchase_date, end_date=latest_possible)

        temp_seller_rows.append({
            'ticket_id': ticket['ticket_id'],
            'ean': ticket['EAN'],
            'event_id': ticket['event_id'],
            'category': ticket['category'],
            'sell_date': sell_date,
            'ticket_price': ticket['ticket_price']
        })

   
    temp_seller_rows.sort(key=lambda x: x['sell_date'])

    for row in temp_seller_rows:
        seller_data.append(
            f"INSERT INTO Seller_Queue (Seller_queue_id, ticket_id, event_id, category, sell_date, ticket_price, processed) VALUES "
            f"({seller_queue_id}, {row['ticket_id']}, {row['event_id']}, '{row['category']}', "
            f"'{row['sell_date'].strftime('%Y-%m-%d %H:%M:%S')}', {row['ticket_price']}, FALSE);"
        )
        seller_queue_id += 1

    data.extend(seller_data)


generate_seller_queue(ticket_info, event_info)


# --- BUYER_QUEUE ---
# Generate buyer queue

buyer_queue_id = 1
buyer_data = []

def generate_buyer_queue_for_sold_out_events(sold_out_event, event_info, ticket_info):
    global buyer_queue_id

    temp_rows = []

    for event_id in sold_out_event:
        event = next((e for e in event_info if e['id'] == event_id), None)
        if not event:
            continue

        num_buyers = random.randint(1, 10)

        for _ in range(num_buyers):
            first_name = fake.first_name()
            last_name = fake.last_name()
            email = fake.email()
            phone = fake.phone_number()
            age = generate_realistic_festival_age()

            latest_possible = min(event['end_time'], datetime.now())
            if latest_possible <= (event['start_time'] - timedelta(days=365)):
                continue  # skip invalid window

            buy_date = fake.date_time_between(
                start_date=event['start_time'] - timedelta(days=365),
                end_date=latest_possible
            )

            use_specific_ean = random.choice([True, False])

            row = {
                'first_name': first_name,
                'last_name': last_name,
                'email': email,
                'phone': phone,
                'age': age,
                'buy_date': buy_date
            }

            if use_specific_ean:
                available_tickets = [t for t in ticket_info if t['event_id'] == event_id and not t['scanned']]
                if not available_tickets:
                    continue
                ticket = random.choice(available_tickets)
                row.update({
                    'event_id': 'NULL',
                    'ean': f"'{ticket['EAN']}'",
                    'category': 'NULL'
                })
            else:
                category = random.choice(['VIP', 'General Entrance', 'Backstage'])
                row.update({
                    'event_id': event_id,
                    'ean': 'NULL',
                    'category': f"'{category}'"
                })

            temp_rows.append(row)

   
    temp_rows.sort(key=lambda x: x['buy_date'])

    for row in temp_rows:
        insert_stmt = (
            f"INSERT INTO Buyer_Queue (Buyer_queue_id, first_name, last_name, email, phone_number, age, "
            f"event_id, EAN, category, buy_date, processed) VALUES ("
            f"{buyer_queue_id}, '{row['first_name']}', '{row['last_name']}', '{row['email']}', "
            f"'{row['phone']}', {row['age']}, {row['event_id']}, {row['ean']}, "
            f"{row['category']}, '{row['buy_date'].strftime('%Y-%m-%d %H:%M:%S')}', FALSE);"
        )
        buyer_data.append(insert_stmt)
        buyer_queue_id += 1

    data.extend(buyer_data)





generate_buyer_queue_for_sold_out_events(sold_out_events,event_info, ticket_info)


with open("load.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(data))