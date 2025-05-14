SELECT 
  combined.artist_id,
  combined.festival_id,
  COUNT(*) AS warmup_count
FROM (
  --  solo
  SELECT 
    p.artist_id,
    e.festival_id
  FROM performance AS p
  JOIN event AS e ON p.event_id = e.event_id
  WHERE p.performance_type = 'Warm Up' AND p.artist_id IS NOT NULL
  UNION ALL
  -- As part of band
  SELECT 
    ab.artist_id,
    e.festival_id
  FROM performance AS p
  JOIN artist_band AS ab ON p.band_id = ab.band_id
  JOIN event AS e ON p.event_id = e.event_id
  WHERE p.performance_type = 'Warm Up' AND p.band_id IS NOT NULL
) AS combined
GROUP BY combined.artist_id, combined.festival_id
HAVING COUNT(*) > 2
ORDER BY artist_id;