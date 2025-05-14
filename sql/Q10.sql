SELECT
    v1.genre_name AS first_genre,
    v2.genre_name AS second_genre,
    COUNT(*) AS pair_count
FROM
    (SELECT ag.artist_id, ag.genre_id, g.genre_name
     FROM artist_genre ag
     JOIN genre g ON ag.genre_id = g.genre_id
     UNION ALL
     SELECT bg.band_id AS artist_id, bg.genre_id, g.genre_name
     FROM band_genre bg
     JOIN genre g ON bg.genre_id = g.genre_id) AS v1
JOIN
    (SELECT ag.artist_id, ag.genre_id, g.genre_name
     FROM artist_genre ag
     JOIN genre g ON ag.genre_id = g.genre_id
     UNION ALL
     SELECT bg.band_id AS artist_id, bg.genre_id, g.genre_name
     FROM band_genre bg
     JOIN genre g ON bg.genre_id = g.genre_id) AS v2
ON v1.artist_id = v2.artist_id AND v1.genre_id < v2.genre_id
GROUP BY v1.genre_name, v2.genre_name
ORDER BY pair_count DESC
LIMIT 3;