SELECT f.festival_year,
  CONCAT(AVG(CASE s.experience
        WHEN 'beginner'         THEN 1
        WHEN 'intermediate'     THEN 2
        WHEN 'experienced'      THEN 3
        WHEN 'very experienced' THEN 4
        WHEN 'professional'     THEN 5
      END
    ), ' / 5') AS average_experience
FROM staff    AS s
JOIN building AS b ON s.building_id = b.building_id
JOIN event    AS e ON b.building_id = e.building_id
JOIN festival AS f ON e.festival_id  = f.festival_id
WHERE s.category = 'technical'
GROUP BY f.festival_year
ORDER BY average_experience ASC
LIMIT 1;