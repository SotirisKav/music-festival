SELECT 
    artist_id,
    artist_name,
    age,
    total_performances
FROM artist_total_participations_view
WHERE total_performances <= (
    SELECT MAX(total_performances) - 5
    FROM artist_total_participations_view
)
ORDER BY total_performances DESC;