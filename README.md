Data Analysis and Problem Solving Repository

This repository contains solutions to problems using SQL, Excel, and Python. The focus is on data manipulation, aggregation, and basic problem solving.

Contents
SQL Problems
Hotel Management System
Created database schema using CREATE TABLE statements
Inserted sample data
Solved queries including:
Last booked room per user
Monthly billing calculations
Filtering based on bill amount
Most and least ordered items per month
Second highest billing customers per month
Clinic Management System
Designed schema with clinics, customers, sales, and expenses
Solved analytical queries including:
Revenue per sales channel
Top customers based on spending
Monthly revenue, expense, and profit
Most profitable clinic per city
Second least profitable clinic per state
Excel Problems
Ticket and Feedback Analysis

Data Mapping

Used XLOOKUP or INDEX-MATCH to populate ticket_created_at in feedbacks sheet using cms_id

Time-Based Analysis

Created helper columns:
Same Day using INT(created_at) = INT(closed_at)
Same Hour using HOUR(created_at) = HOUR(closed_at) with same day condition

Aggregation

Used COUNTIFS for formula-based calculations
Used Pivot Tables for outlet-wise summary:
Count of tickets closed on the same day
Count of tickets closed within the same hour
Python Problems
Time Conversion
Converted minutes into human readable format
Example: 130 becomes 2 hrs 10 minutes
Used integer division and modulus
Included input handling and error validation
Remove Duplicates from String
Removed duplicate characters using a loop
Preserved original order of characters
Example: programming becomes progamin
Included input validation
Project Structure
project/
│
├── sql/
│   ├── hotel_queries.sql
│   ├── clinic_queries.sql
│
├── excel/
│   ├── ticket_analysis.xlsx
│
├── python/
│   ├── time_conversion.py
│   ├── remove_duplicates.py
│
└── README.md
Tools Used
SQL (MySQL or PostgreSQL concepts)
Microsoft Excel (formulas and pivot tables)
Python
Key Concepts Covered
Data aggregation and filtering
SQL joins and grouping
Lookup functions in Excel
Pivot table analysis
String manipulation in Python
Input validation and error handling
How to Run
Python
python time_conversion.py
python remove_duplicates.py
SQL
Run queries in any SQL environment such as MySQL or PostgreSQL
Excel
Open the Excel file and use formulas or pivot tables
Notes
Data used is sample data for practice
Focus is on clear and structured problem solving
Solutions are written in an interview-ready format

If you want, I can also help you make a slightly more polished version specifically for GitHub (with proper formatting and spacing).