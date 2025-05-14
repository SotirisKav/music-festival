SELECT 
    a.artist_first_name AS first_name,
    a.artist_last_name AS last_name,
    COUNT(DISTINCT l.continent) AS performances_across_continents
FROM 
    artist a 
JOIN performance p ON p.artist_id = a.artist_id
JOIN event e ON e.event_id = p.event_id  
JOIN festival f ON f.festival_id = e.festival_id
JOIN location l ON f.location_id = l.location_id
GROUP BY 
    a.artist_id, a.artist_first_name, a.artist_last_name
HAVING 
    COUNT(DISTINCT l.continent) >= 3
ORDER BY
    performances_across_continents DESC;
