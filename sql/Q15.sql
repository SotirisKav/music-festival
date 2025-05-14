SELECT 
    CONCAT(t.holder_first_name, ' ', t.holder_last_name) AS visitor_full_name,
    CONCAT(a.artist_first_name, ' ', a.artist_last_name) AS artist_full_name,
    SUM( 
		CASE r.artist_performance_grade 
			WHEN 'Very Unsatisfied' THEN 1
			WHEN 'Unsatisfied' THEN 2
			WHEN 'Neutral' THEN 3
			WHEN 'Satisfied' THEN 4
            WHEN 'Very Satisfied' THEN 5	
		END 
     ) AS total_artist_score
FROM review as r
JOIN ticket as t ON r.visitor_id = t.visitor_id
JOIN performance as p ON r.performance_id = p.performance_id 
JOIN artist as a ON p.artist_id = a.artist_id
WHERE a.artist_id = 10
GROUP BY visitor_full_name, artist_full_name
ORDER BY total_artist_score DESC
LIMIT 5;
