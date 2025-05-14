SELECT 
    artist_id,
    artist_name,
    age,
    total_performances
FROM artist_total_participations_view
WHERE age < 30
ORDER BY total_performances DESC