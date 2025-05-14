SELECT DISTINCT s.staff_id, s.staff_name, s.category
FROM event_staff_view AS s
WHERE s.category = 'support'
AND s.staff_id NOT IN (
    SELECT staff_id
    FROM event_staff_view
    WHERE event_date = '2022-08-09'
);