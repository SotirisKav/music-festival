-- SET PROFILING = 1;
SELECT
  r.visitor_id,
  e.event_id,
  e.event_name,
  AVG(
    (
      (CASE r.artist_performance_grade
         WHEN 'Very Unsatisfied' THEN 1
         WHEN 'Unsatisfied'      THEN 2
         WHEN 'Neutral'          THEN 3
         WHEN 'Satisfied'        THEN 4
         WHEN 'Very Satisfied'   THEN 5
       END)
    + (CASE r.lighting_sound_grade
         WHEN 'Very Unsatisfied' THEN 1
         WHEN 'Unsatisfied'      THEN 2
         WHEN 'Neutral'          THEN 3
         WHEN 'Satisfied'        THEN 4
         WHEN 'Very Satisfied'   THEN 5
       END)
	+ (CASE r.stage_presence_grade
         WHEN 'Very Unsatisfied' THEN 1
         WHEN 'Unsatisfied'      THEN 2
         WHEN 'Neutral'          THEN 3
         WHEN 'Satisfied'        THEN 4
         WHEN 'Very Satisfied'   THEN 5
       END)
    + (CASE r.organization_grade
         WHEN 'Very Unsatisfied' THEN 1
         WHEN 'Unsatisfied'      THEN 2
         WHEN 'Neutral'          THEN 3
         WHEN 'Satisfied'        THEN 4
         WHEN 'Very Satisfied'   THEN 5
       END)
    + (CASE r.final_impression_grade
         WHEN 'Very Unsatisfied' THEN 1
         WHEN 'Unsatisfied'      THEN 2
         WHEN 'Neutral'          THEN 3
         WHEN 'Satisfied'        THEN 4
         WHEN 'Very Satisfied'   THEN 5
       END)
    ) / 5.0
  ) AS avg_event_score
FROM review r FORCE INDEX (visitor_id)
JOIN performance AS p FORCE INDEX (PRIMARY)
	ON r.performance_id = p.performance_id
JOIN event AS e FORCE INDEX (PRIMARY)
	ON p.event_id       = e.event_id
WHERE r.visitor_id = 9
GROUP BY
  r.visitor_id,
  e.event_id,
  e.event_name
ORDER BY
  e.event_id;
-- SHOW PROFILES;