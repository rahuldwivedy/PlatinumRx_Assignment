Hotel Management Tables
"-- USERS
CREATE TABLE users (
  user_id VARCHAR(50) NOT NULL,
  name VARCHAR(200),
  phone_number VARCHAR(30),
  mail_id VARCHAR(200),
  billing_address TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  KEY idx_users_mail (mail_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BOOKINGS
CREATE TABLE bookings (
  booking_id VARCHAR(50) NOT NULL,
  booking_date DATETIME NOT NULL,
  room_no VARCHAR(50),
  user_id VARCHAR(50) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id),
  KEY idx_bookings_user (user_id),
  KEY idx_bookings_date (booking_date),
  CONSTRAINT fk_bookings_user FOREIGN KEY (user_id) REFERENCES users (user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ITEMS (menu / billable items)
CREATE TABLE items (
  item_id VARCHAR(50) NOT NULL,
  item_name VARCHAR(255) NOT NULL,
  item_rate DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  uom VARCHAR(20) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (item_id),
  KEY idx_items_name (item_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BOOKING_COMMERCIALS (line-items for bookings / bills)
CREATE TABLE booking_commercials (
  id VARCHAR(50) NOT NULL,
  booking_id VARCHAR(50) NOT NULL,
  bill_id VARCHAR(50) DEFAULT NULL,
  bill_date DATETIME DEFAULT NULL,
  item_id VARCHAR(50) NOT NULL,
  item_quantity DECIMAL(12,4) NOT NULL DEFAULT 0.0000,
  unit_price DECIMAL(14,2) DEFAULT NULL,    -- optional override per line
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_bc_booking (booking_id),
  KEY idx_bc_bill (bill_id),
  KEY idx_bc_item (item_id),
  KEY idx_bc_bill_date (bill_date),
  CONSTRAINT fk_bc_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_bc_item FOREIGN KEY (item_id) REFERENCES items (item_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"


HOTEL MANAGEMENT SYSTEM — INSERT STATEMENTS
1. users
"INSERT INTO users (user_id, name, phone_number, mail_id, billing_address)
VALUES
('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX Street Y, ABC City'),
('88jdke9s-22xkpa', 'Alice Smith', '98XXXXXXXX', 'alice.smith@example.com', '12 Park Lane, Metro City'),
('77uexpl0-004mnb', 'Robert Brown', '99XXXXXXXX', 'rbrown@example.com', '45 MG Road, Bangalore');"


2. bookings
"INSERT INTO bookings (booking_id, booking_date, room_no, user_id)
VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-22k3a-19md', '2021-11-15 14:12:10', 'rm-238d-kkd9',   '88jdke9s-22xkpa'),
('bk-77qpa-55df', '2021-11-28 20:00:01', 'rm-908x-pp2a',   '77uexpl0-004mnb');"


3. items
"INSERT INTO items (item_id, item_name, item_rate)
VALUES
('itm-a9e8-q8fu',  'Tawa Paratha', 18.00),
('itm-a07vh-aer8', 'Mix Veg',      89.00),
('itm-w978-23u4',  'Paneer Tikka', 150.00),
('itm-33d9-9efv',  'Cold Coffee',  120.00);"


4. booking_commercials
"INSERT INTO booking_commercials
(id, booking_id, bill_id, bill_date, item_id, item_quantity)
VALUES
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('134lr-oyfo8-3qk4','bk-22k3a-19md', 'bl-34qhd-r7h8', '2021-11-15 16:10:10', 'itm-w978-23u4', 0.5),
('99pl-tyu77-k2jj','bk-77qpa-55df', 'bl-44plp-ss90', '2021-11-28 21:00:00', 'itm-33d9-9efv', 2);"