A. Hotel Management — MySQL Queries
A.1 For every user in the system, get the user_id and last booked room_no
"SELECT user_id, room_no AS last_room_no, booking_date AS last_booking_date
FROM (
  SELECT 
    user_id, room_no, booking_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
  FROM bookings
) t
WHERE rn = 1;"


A.2 Booking_id and total billing amount of every booking created in November 2021
"SELECT 
  bc.booking_id,
  SUM(COALESCE(i.item_rate,0) * COALESCE(bc.item_quantity,0)) AS booking_total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE YEAR(b.booking_date) = 2021
  AND MONTH(b.booking_date) = 11
GROUP BY bc.booking_id
ORDER BY booking_total_amount DESC;"


A.3 bill_id and bill amount of all bills raised in October 2021 having bill amount > 1000
"SELECT
  bc.bill_id,
  SUM(COALESCE(i.item_rate,0) * COALESCE(bc.item_quantity,0)) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING bill_amount > 1000
ORDER BY bill_amount DESC;"


A.4 Determine the most ordered and least ordered item of each month of year 2021
"WITH monthly_totals AS (
  SELECT
    DATE_FORMAT(bc.bill_date, '%Y-%m') AS month_key,
    bc.item_id,
    SUM(COALESCE(bc.item_quantity,0)) AS qty_sum
  FROM booking_commercials bc
  WHERE bc.bill_date >= '2021-01-01'
    AND bc.bill_date <  '2022-01-01'
  GROUP BY month_key, bc.item_id
),
ranked AS (
  SELECT
    mt.*,
    RANK() OVER (PARTITION BY mt.month_key ORDER BY mt.qty_sum DESC) AS rnk_desc,
    RANK() OVER (PARTITION BY mt.month_key ORDER BY mt.qty_sum ASC)  AS rnk_asc
  FROM monthly_totals mt
)
SELECT month_key AS month, item_id, qty_sum,
       CASE 
         WHEN rnk_desc = 1 AND rnk_asc = 1 THEN 'ONLY_ITEM'   -- if only one item that month
         WHEN rnk_desc = 1 THEN 'MOST_ORDERED'
         WHEN rnk_asc  = 1 THEN 'LEAST_ORDERED'
         ELSE 'OTHER'
       END AS role
FROM ranked
WHERE rnk_desc = 1 OR rnk_asc = 1
ORDER BY month_key, role, qty_sum DESC;"


A.5 Find the customers with the second highest bill value of each month of year 2021
"WITH user_month_totals AS (
  SELECT 
    DATE_FORMAT(bc.bill_date, '%Y-%m') AS month_key,
    b.user_id,
    SUM(COALESCE(i.item_rate,0) * COALESCE(bc.item_quantity,0)) AS total_value
  FROM booking_commercials bc
  JOIN bookings b ON bc.booking_id = b.booking_id
  JOIN items i ON bc.item_id = i.item_id
  WHERE bc.bill_date >= '2021-01-01' AND bc.bill_date < '2022-01-01'
  GROUP BY month_key, b.user_id
),
ranked AS (
  SELECT
    umt.*,
    DENSE_RANK() OVER (PARTITION BY month_key ORDER BY total_value DESC) AS drank
  FROM user_month_totals umt
)
SELECT month_key, user_id, total_value
FROM ranked
WHERE drank = 2
ORDER BY month_key, total_value DESC;"