# DATABASE CREATION

DROP DATABASE IF EXISTS Clinic_management;
CREATE DATABASE IF NOT EXISTS Clinic_management;
USE Clinic_management;

# TABLE CLINICS
CREATE TABLE clinics (
    cid VARCHAR(20) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

# TABLE CUSTOMER
CREATE TABLE customer (
    uid VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(15)
);

# TABLE CLINIC_SALES
CREATE TABLE clinic_sales (
    oid VARCHAR(20) PRIMARY KEY,
    uid VARCHAR(20),
    cid VARCHAR(20),
    amount DECIMAL(10,2),
    datetime TIMESTAMP,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

# TABLE EXPENSES
CREATE TABLE expenses (
    eid VARCHAR(20) PRIMARY KEY,
    cid VARCHAR(20),
    description VARCHAR(100),
    amount DECIMAL(10,2),
    datetime TIMESTAMP,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

# INSERTING VALUES INTO THE RESPECTIVE TABLES
# I HAVE ADDED MULTIPLE ROWS FOR BETTER DEMONSTARTION OF THE QUERIES

# TABLE CLINICS
INSERT INTO clinics VALUES
('c1','Alpha Clinic','Mumbai','Maharashtra','India'),
('c2','Beta Clinic','Mumbai','Maharashtra','India'),
('c3','Gamma Clinic','Delhi','Delhi','India'),
('c4','Delta Clinic','Delhi','Delhi','India'),
('c5','Epsilon Clinic','Pune','Maharashtra','India'),
('c6','Zeta Clinic','Pune','Maharashtra','India'),
('c7','Eta Clinic','Bangalore','Karnataka','India'),
('c8','Theta Clinic','Bangalore','Karnataka','India'),
('c9','Iota Clinic','Chennai','Tamil Nadu','India'),
('c10','Kappa Clinic','Chennai','Tamil Nadu','India');

# TABLE CUSTOMER
INSERT INTO customer VALUES
('u1','John','9000000001'),
('u2','Alice','9000000002'),
('u3','Bob','9000000003'),
('u4','Charlie','9000000004'),
('u5','David','9000000005'),
('u6','Emma','9000000006'),
('u7','Frank','9000000007'),
('u8','Grace','9000000008'),
('u9','Henry','9000000009'),
('u10','Ivy','9000000010');

# TABLE CLINIC_SALES
INSERT INTO clinic_sales VALUES
('o1','u1','c1',5000,'2021-01-10 10:00:00','online'),
('o2','u2','c2',7000,'2021-01-15 11:00:00','offline'),
('o3','u3','c3',12000,'2021-02-05 09:30:00','online'),
('o4','u4','c4',8000,'2021-02-10 14:00:00','referral'),
('o5','u5','c5',15000,'2021-03-01 16:00:00','online'),
('o6','u6','c6',4000,'2021-03-12 18:00:00','offline'),
('o7','u7','c7',20000,'2021-01-20 12:00:00','online'),
('o8','u8','c8',6000,'2021-02-25 13:00:00','referral'),
('o9','u9','c9',9000,'2021-03-18 15:00:00','offline'),
('o10','u10','c10',11000,'2021-01-28 17:00:00','online'),
('o11','u2','c2',6000,'2021-01-18 10:00:00','online'),
('o12','u8','c8',8000,'2021-01-22 11:00:00','offline'),
('o13','u9','c9',7000,'2021-01-25 12:00:00','online');

# TABLE EXPENSES
INSERT INTO expenses VALUES
('e1','c1','rent',2000,'2021-01-10 08:00:00'),
('e2','c2','salary',5000,'2021-01-15 09:00:00'),
('e3','c3','equipment',7000,'2021-02-05 08:00:00'),
('e4','c4','maintenance',9000,'2021-02-10 10:00:00'),
('e5','c5','rent',3000,'2021-03-01 08:00:00'),
('e6','c6','salary',3500,'2021-03-12 09:00:00'),
('e7','c7','equipment',10000,'2021-01-20 09:00:00'),
('e8','c8','maintenance',2000,'2021-02-25 10:00:00'),
('e9','c9','rent',4000,'2021-03-18 09:00:00'),
('e10','c10','salary',6000,'2021-01-28 10:00:00'),
('e11','c2','extra',2000,'2021-01-18 08:00:00'),
('e12','c8','extra',3000,'2021-01-22 09:00:00'),
('e13','c9','extra',2000,'2021-01-25 09:00:00');


# QUERIES

# 1. Find the revenue we got from each sales channel in a given year
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel;

# 2. Find top 10 the most valuable customers for a given year
SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

# 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year
WITH revenue AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY month
),
expense AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY month
)
SELECT 
    r.month,
    r.total_revenue,
    COALESCE(e.total_expense, 0) AS total_expense,
    (r.total_revenue - COALESCE(e.total_expense, 0)) AS profit,
    CASE 
        WHEN (r.total_revenue - COALESCE(e.total_expense, 0)) > 0 
        THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM revenue r
LEFT JOIN expense e ON r.month = e.month
ORDER BY r.month;

# 4. For each city find the most profitable clinic for a given month
WITH sales AS (
    SELECT 
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = 2021
      AND EXTRACT(MONTH FROM datetime) = 1
    GROUP BY cid
),
expense AS (
    SELECT 
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = 2021
      AND EXTRACT(MONTH FROM datetime) = 1
    GROUP BY cid
),
profit_table AS (
    SELECT 
        c.city,
        c.cid,
        COALESCE(s.revenue,0) - COALESCE(e.expense,0) AS profit
    FROM clinics c
    LEFT JOIN sales s ON c.cid = s.cid
    LEFT JOIN expense e ON c.cid = e.cid
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM profit_table
)
SELECT city, cid, profit
FROM ranked
WHERE rnk = 1;

# 5. For each state find the second least profitable clinic for a given month
WITH sales AS (
    SELECT 
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = 2021
      AND EXTRACT(MONTH FROM datetime) = 1
    GROUP BY cid
),
expense AS (
    SELECT 
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = 2021
      AND EXTRACT(MONTH FROM datetime) = 1
    GROUP BY cid
),
profit_table AS (
    SELECT 
        c.state,
        c.cid,
        COALESCE(s.revenue,0) - COALESCE(e.expense,0) AS profit
    FROM clinics c
    LEFT JOIN sales s ON c.cid = s.cid
    LEFT JOIN expense e ON c.cid = e.cid
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM profit_table
)
SELECT state, cid, profit
FROM ranked
WHERE rnk = 2;