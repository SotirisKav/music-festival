SELECT 
    DATE(e.event_start_time) AS event_date,
    COUNT(DISTINCT CASE WHEN s.category = 'Technical' THEN s.staff_id END) AS technical_staff,
    COUNT(DISTINCT CASE WHEN s.category = 'Security' THEN s.staff_id END) AS security_staff,
    COUNT(DISTINCT CASE WHEN s.category = 'Support' THEN s.staff_id END) AS support_staff
FROM event e
JOIN festival f ON e.festival_id = f.festival_id
JOIN staff s ON s.building_id = e.building_id
GROUP BY event_date
ORDER BY event_date;