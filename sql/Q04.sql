-- SET PROFILING = 1;
-- SET SESSION optimizer_switch = 
-- 'hash_join=on,block_nested_loop=off,batched_key_access=off';
SELECT 
  a.artist_id,
  a.artist_first_name,
  a.artist_last_name,
  CONCAT(AVG(
    CASE r.artist_performance_grade
      WHEN 'Very Unsatisfied' THEN 1
      WHEN 'Unsatisfied'      THEN 2
      WHEN 'Neutral'          THEN 3
      WHEN 'Satisfied'        THEN 4
      WHEN 'Very Satisfied'   THEN 5
    END
  ), ' / 5')AS `Average Artist Performance Grade`,
  CONCAT(AVG(
    CASE r.final_impression_grade
      WHEN 'Very Unsatisfied' THEN 1
      WHEN 'Unsatisfied'      THEN 2
      WHEN 'Neutral'          THEN 3
      WHEN 'Satisfied'        THEN 4
      WHEN 'Very Satisfied'   THEN 5
    END
  ), ' / 5') AS `Average Final Impression Grade`
FROM review AS r  
JOIN performance AS p 
  ON r.performance_id = p.performance_id
JOIN artist AS a 
  ON a.artist_id = p.artist_id
WHERE a.artist_id = 10;
-- SHOW PROFILES;