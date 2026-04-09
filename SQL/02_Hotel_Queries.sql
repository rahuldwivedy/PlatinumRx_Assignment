# DATABASE CREATION

DROP DATABASE IF EXISTS Hotel_management;
CREATE DATABASE IF NOT EXISTS Hotel_management;
USE Hotel_management;

# TABLE USERS
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(15),
    mail_id VARCHAR(100),
    billing_address VARCHAR(255)
);

# TABLE BOOKINGS
CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date TIMESTAMP,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

# TABLE ITEMS
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);

# TABLE BOOKING_COMMERCIALS
CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date TIMESTAMP,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

# INSERTING VALUES INTO THE RESPECTIVE TABLES
# I HAVE ADDED MULTIPLE ROWS FOR BETTER DEMONSTARTION OF THE QUERIES

# TABLE  USERS
INSERT INTO users VALUES
('u1', 'John Doe', '9700000001', 'john@example.com', 'Mumbai'),
('u2', 'Alice Smith', '9700000002', 'alice@example.com', 'Delhi'),
('u3', 'Bob Brown', '9700000003', 'bob@example.com', 'Pune'),
('u4', 'Charlie White', '9700000004', 'charlie@example.com', 'Chennai'),
('u5', 'David Green', '9700000005', 'david@example.com', 'Kolkata'),
('u6', 'Emma Stone', '9700000006', 'emma@example.com', 'Hyderabad'),
('u7', 'Frank Ocean', '9700000007', 'frank@example.com', 'Bangalore'),
('u8', 'Grace Lee', '9700000008', 'grace@example.com', 'Jaipur'),
('u9', 'Henry Ford', '9700000009', 'henry@example.com', 'Ahmedabad'),
('u10', 'Ivy Clark', '9700000010', 'ivy@example.com', 'Goa');

# TABLE BOOKINGS
INSERT INTO bookings VALUES
('b1', '2021-10-05 10:00:00', 'r101', 'u1'),
('b2', '2021-10-15 12:00:00', 'r102', 'u2'),
('b3', '2021-11-03 09:30:00', 'r103', 'u3'),
('b4', '2021-11-10 14:20:00', 'r104', 'u4'),
('b5', '2021-12-01 16:00:00', 'r105', 'u5'),
('b6', '2021-12-12 18:30:00', 'r106', 'u6'),
('b7', '2021-09-20 11:15:00', 'r107', 'u7'),
('b8', '2021-09-25 08:45:00', 'r108', 'u8'),
('b9', '2021-11-18 20:00:00', 'r109', 'u9'),
('b10','2021-10-28 07:30:00', 'r110', 'u10');

# TABLE ITEMS
INSERT INTO items VALUES
('i1', 'Tawa Paratha', 18),
('i2', 'Mix Veg', 89),
('i3', 'Paneer Butter Masala', 150),
('i4', 'Dal Fry', 120),
('i5', 'Jeera Rice', 90),
('i6', 'Butter Naan', 25),
('i7', 'Masala Dosa', 70),
('i8', 'Idli', 40),
('i9', 'Cold Coffee', 60),
('i10','Gulab Jamun', 50);	

# TABLE BOOKING_COMMERCIALS
INSERT INTO booking_commercials VALUES
('c1', 'b1', 'bill1', '2021-10-05 12:00:00', 'i1', 3),
('c2', 'b1', 'bill1', '2021-10-05 12:00:00', 'i2', 2),
('c3', 'b2', 'bill2', '2021-10-15 13:00:00', 'i3', 2),
('c4', 'b2', 'bill2', '2021-10-15 13:00:00', 'i6', 5),
('c5', 'b3', 'bill3', '2021-11-03 11:00:00', 'i4', 3),
('c6', 'b3', 'bill3', '2021-11-03 11:00:00', 'i5', 2),
('c7', 'b4', 'bill4', '2021-11-10 16:00:00', 'i3', 4),
('c8', 'b4', 'bill4', '2021-11-10 16:00:00', 'i10', 6),
('c9', 'b5', 'bill5', '2021-12-01 18:00:00', 'i7', 5),
('c10','b5', 'bill5', '2021-12-01 18:00:00', 'i8', 4),
('c11','b6', 'bill6', '2021-12-12 20:00:00', 'i9', 3),
('c12','b7', 'bill7', '2021-09-20 13:00:00', 'i1', 10),
('c13','b8', 'bill8', '2021-09-25 10:00:00', 'i2', 6),
('c14','b9', 'bill9', '2021-11-18 22:00:00', 'i3', 7),
('c15','b10','bill10','2021-10-28 09:00:00', 'i4', 10);

# QUERIES

# 1. For every user in the system, get the user_id and last booked room_no
SELECT user_id, room_no
FROM (
    SELECT 
        user_id,
        room_no,
        booking_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;

# 2. Get booking_id and total billing amount of every booking created in November, 2021
SELECT 
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE EXTRACT(MONTH FROM bc.bill_date) = 11
  AND EXTRACT(YEAR FROM bc.bill_date) = 2021
GROUP BY bc.booking_id;

# 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE EXTRACT(MONTH FROM bc.bill_date) = 10
  AND EXTRACT(YEAR FROM bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

# 4. Determine the most ordered and least ordered item of each month of year 2021
WITH item_orders AS (
    SELECT 
        EXTRACT(MONTH FROM bill_date) AS month,
        item_id,
        SUM(item_quantity) AS total_qty
    FROM booking_commercials
    WHERE EXTRACT(YEAR FROM bill_date) = 2021
    GROUP BY month, item_id
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS most_rank,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS least_rank
    FROM item_orders
)
SELECT month, item_id, total_qty, 'MOST' AS type
FROM ranked
WHERE most_rank = 1

UNION ALL

SELECT month, item_id, total_qty, 'LEAST' AS type
FROM ranked
WHERE least_rank = 1;

# 5. Find the customers with the second highest bill value of each month of year 2021
WITH bill_values AS (
    SELECT 
        bc.bill_id,
        b.user_id,
        EXTRACT(MONTH FROM bc.bill_date) AS month,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE EXTRACT(YEAR FROM bc.bill_date) = 2021
    GROUP BY bc.bill_id, b.user_id, month
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) AS rnk
    FROM bill_values
)
SELECT month, user_id, bill_id, total_bill
FROM ranked
WHERE rnk = 2;
