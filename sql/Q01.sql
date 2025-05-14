SELECT
  f.festival_year,
  CONCAT(FORMAT(SUM(CASE WHEN t.payment_method = 'Credit Card' THEN t.ticket_price END), 2), '$') AS credit_card,
  CONCAT(FORMAT(SUM(CASE WHEN t.payment_method = 'Debit Card' THEN t.ticket_price END), 2), '$') AS debit_card,
  CONCAT(FORMAT(SUM(CASE WHEN t.payment_method = 'Bank Transfer' THEN t.ticket_price END), 2), '$') AS e_banking,
  CONCAT(FORMAT(SUM(t.ticket_price), 2), '$') AS total_earnings
FROM ticket t
JOIN event e ON t.event_id = e.event_id
JOIN festival f ON e.festival_id = f.festival_id
GROUP BY f.festival_year
ORDER BY f.festival_year DESC;