Clinic Management Tables
"-- CLINICS
CREATE TABLE clinics (
  cid VARCHAR(50) NOT NULL,
  clinic_name VARCHAR(255) NOT NULL,
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (cid),
  KEY idx_clinics_city (city),
  KEY idx_clinics_state (state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CUSTOMER
CREATE TABLE customer (
  uid VARCHAR(50) NOT NULL,
  name VARCHAR(255),
  mobile VARCHAR(30),
  email VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (uid),
  KEY idx_customer_mobile (mobile)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CLINIC_SALES (orders / revenue)
CREATE TABLE clinic_sales (
  oid VARCHAR(50) NOT NULL,   -- order id
  uid VARCHAR(50) DEFAULT NULL,  -- customer id (optional)
  cid VARCHAR(50) NOT NULL,      -- clinic id
  amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  datetime DATETIME NOT NULL,
  sales_channel VARCHAR(100) DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (oid),
  KEY idx_cs_uid (uid),
  KEY idx_cs_cid (cid),
  KEY idx_cs_datetime (datetime),
  CONSTRAINT fk_cs_customer FOREIGN KEY (uid) REFERENCES customer (uid)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_cs_clinic FOREIGN KEY (cid) REFERENCES clinics (cid)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- EXPENSES
CREATE TABLE expenses (
  eid VARCHAR(50) NOT NULL,
  cid VARCHAR(50) NOT NULL,
  description VARCHAR(500),
  amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  datetime DATETIME NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (eid),
  KEY idx_expenses_cid (cid),
  KEY idx_expenses_datetime (datetime),
  CONSTRAINT fk_expenses_clinic FOREIGN KEY (cid) REFERENCES clinics (cid)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"


CLINIC MANAGEMENT — INSERT STATEMENTS
1. clinics
"INSERT INTO clinics (cid, clinic_name, city, state, country)
VALUES
('cnc-0100001', 'XYZ Clinic',     'Mumbai',   'Maharashtra', 'India'),
('cnc-0100002', 'Apollo Clinic',  'Delhi',    'Delhi',       'India'),
('cnc-0100003', 'Sunrise Clinic', 'Bengaluru','Karnataka',   'India');"


2. customer
"INSERT INTO customer (uid, name, mobile, email)
VALUES
('bk-09f3e-95hj', 'Jon Doe',   '97XXXXXXXX', 'jon.doe@example.com'),
('cus-1172-aa91', 'Mary Jane', '98XXXXXXXX', 'maryjane@example.com'),
('cus-9922-pp11', 'Amit Shah', '99XXXXXXXX', 'amitshah@example.com');"


3. clinic_sales
"INSERT INTO clinic_sales
(oid, uid, cid, amount, datetime, sales_channel)
VALUES
('ord-00100-00100', 'bk-09f3e-95hj', 'cnc-0100001', 24999, '2021-09-23 12:03:22', 'sodexo'),
('ord-00100-00101', 'cus-1172-aa91', 'cnc-0100002', 18000, '2021-09-23 14:10:11', 'online'),
('ord-00100-00102', 'cus-9922-pp11', 'cnc-0100003', 14000, '2021-11-01 10:05:00', 'offline'),
('ord-00100-00103', 'cus-1172-aa91', 'cnc-0100001', 22000, '2021-11-05 09:00:00', 'sodexo');"


4. expenses
"INSERT INTO expenses
(eid, cid, description, amount, datetime)
VALUES
('exp-0100-00100', 'cnc-0100001', 'First-aid supplies', 557,  '2021-09-23 07:36:48'),
('exp-0100-00101', 'cnc-0100001', 'Electricity bill',   3000, '2021-09-30 20:00:00'),
('exp-0100-00102', 'cnc-0100002', 'Equipment repair',   4200, '2021-09-23 18:30:00'),
('exp-0100-00103', 'cnc-0100003', 'Cleaning supplies',   950, '2021-11-01 08:30:00');"