SELECT 
    a.artist_id,
    a.artist_first_name, a.artist_last_name,
    'Jazz' AS genre_name,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM performance p
            JOIN event e ON p.event_id = e.event_id
            JOIN festival f ON e.festival_id = f.festival_id
            WHERE f.festival_year = 2024
              AND (
                  p.artist_id = a.artist_id
                  OR p.band_id IN (SELECT ab.band_id
                                   FROM artist_band AS ab
                                   WHERE ab.artist_id = a.artist_id)
              )
        )
        THEN 'YES'
        ELSE 'NO'
    END AS participated_in_2024
FROM artist a
JOIN artist_genre ag ON a.artist_id = ag.artist_id
JOIN genre g ON ag.genre_id = g.genre_id
WHERE g.genre_name = 'Jazz'; 