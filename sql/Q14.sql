SELECT 
    t1.genre_name,
    t1.festival_year AS year1,
    t2.festival_year AS year2,
    t1.total_genre_performances
FROM genre_total_performances_year_view AS t1
INNER JOIN genre_total_performances_year_view AS t2 
  ON t1.genre_name = t2.genre_name
 AND t2.festival_year = t1.festival_year + 1
 AND t1.total_genre_performances = t2.total_genre_performances
WHERE t1.total_genre_performances >= 3 AND t2.total_genre_performances>= 3
ORDER BY t1.genre_name, year1;
