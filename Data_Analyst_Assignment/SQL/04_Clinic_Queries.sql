B. Clinic Management — MySQL Queries
B.1 Find the revenue we got from each sales channel in a given year
"SET @the_year = 2021;

SELECT 
  cs.sales_channel,
  SUM(cs.amount) AS revenue
FROM clinic_sales cs
WHERE YEAR(cs.datetime) = @the_year
GROUP BY cs.sales_channel
ORDER BY revenue DESC;"


B.2 Find top 10 most valuable customers for a given year
"SET @the_year = 2021;

SELECT 
  cs.uid,
  COALESCE(c.name, '[unknown]') AS customer_name,
  SUM(cs.amount) AS total_spend
FROM clinic_sales cs
LEFT JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = @the_year
GROUP BY cs.uid, c.name
ORDER BY total_spend DESC
LIMIT 10;"


B.3 Month-wise revenue, expense, profit, status (profitable / not-profitable) for a given year
"SET @the_year = 2021;

-- derived table for months 1..12
SELECT 
  DATE_FORMAT(STR_TO_DATE(CONCAT(@the_year,'-',m.month,'-01'), '%Y-%m-%d'), '%Y-%m') AS month_key,
  COALESCE(r.revenue, 0) AS revenue,
  COALESCE(e.expense, 0) AS expense,
  COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
  CASE WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0 THEN 'PROFITABLE' ELSE 'NOT-PROFITABLE' END AS status
FROM (
  SELECT 1 AS month UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
  UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
) m
LEFT JOIN (
  SELECT MONTH(datetime) AS mn, SUM(amount) AS revenue
  FROM clinic_sales
  WHERE YEAR(datetime) = @the_year
  GROUP BY MONTH(datetime)
) r ON r.mn = m.month
LEFT JOIN (
  SELECT MONTH(datetime) AS mn, SUM(amount) AS expense
  FROM expenses
  WHERE YEAR(datetime) = @the_year
  GROUP BY MONTH(datetime)
) e ON e.mn = m.month
ORDER BY m.month;"


B.4 For each city find the most profitable clinic for a given month
"SET @year = 2021;
SET @month = 9;  -- September

WITH clinic_profit AS (
  SELECT
    c.cid,
    c.clinic_name,
    c.city,
    COALESCE(SUM(cs.amount), 0) AS revenue,
    COALESCE(SUM(e.amount), 0)  AS expense,
    COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) AS profit
  FROM clinics c
  LEFT JOIN clinic_sales cs 
    ON cs.cid = c.cid
    AND YEAR(cs.datetime) = @year AND MONTH(cs.datetime) = @month
  LEFT JOIN expenses e
    ON e.cid = c.cid
    AND YEAR(e.datetime) = @year AND MONTH(e.datetime) = @month
  GROUP BY c.cid, c.clinic_name, c.city
),
ranked AS (
  SELECT cp.*,
    ROW_NUMBER() OVER (PARTITION BY cp.city ORDER BY cp.profit DESC) AS rn
  FROM clinic_profit cp
)
SELECT cid, clinic_name, city, revenue, expense, profit
FROM ranked
WHERE rn = 1
ORDER BY city;"


B.5 For each state find the second least profitable clinic for a given month
"SET @year = 2021;
SET @month = 9;

WITH clinic_profit AS (
  SELECT
    c.cid,
    c.clinic_name,
    c.state,
    COALESCE(SUM(cs.amount), 0) AS revenue,
    COALESCE(SUM(e.amount), 0)  AS expense,
    COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) AS profit
  FROM clinics c
  LEFT JOIN clinic_sales cs 
    ON cs.cid = c.cid
    AND YEAR(cs.datetime) = @year AND MONTH(cs.datetime) = @month
  LEFT JOIN expenses e
    ON e.cid = c.cid
    AND YEAR(e.datetime) = @year AND MONTH(e.datetime) = @month
  GROUP BY c.cid, c.clinic_name, c.state
),
ranked AS (
  SELECT cp.*,
    ROW_NUMBER() OVER (PARTITION BY cp.state ORDER BY cp.profit ASC) AS rn
  FROM clinic_profit cp
)
SELECT cid, clinic_name, state, revenue, expense, profit
FROM ranked
WHERE rn = 2
ORDER BY state;"