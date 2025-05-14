SELECT *
FROM visitor_festival_attended_view AS v
WHERE (festival_year, event_visited) IN (
  SELECT festival_year, event_visited
  FROM visitor_festival_attended_view
  GROUP BY festival_year, event_visited
  HAVING COUNT(*) > 1
)
ORDER BY festival_year, event_visited;