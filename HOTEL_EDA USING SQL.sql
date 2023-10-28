CREATE DATABASE HOTELS;  -- Creating Database

USE HOTELS;  -- Make it default database


-- Creating Table
CREATE TABLE Hotel_Bookings(hotel char(100),	
is_canceled	int,
lead_time int,	
arrival_date_year int,
arrival_date_month	char(100),	
arrival_date_week_number	int,
arrival_date_day_of_month	int,
stays_in_weekend_nights int,	
stays_in_week_nights	int,
adults	int,
children	int,
babies	int,
meal	char(100),	
country	char(100),	
market_segment	char(100),	
distribution_channel	char(100),	
is_repeated_guest	int,
previous_cancellations	int,
previous_bookings_not_canceled	int,
reserved_room_type	char(100),
assigned_room_type	char(100),
booking_changes	int,
deposit_type	char(100),
agent	varchar(100),
company	varchar(100),
days_in_waiting_list 	int,
customer_type	char(100),
adr	float,
required_car_parking_spaces	int,
total_of_special_requests	int,
reservation_status	char(100),
reservation_status_date char(100));


-- DROPPING COLUMN WHICH NOT NEEDED
ALTER TABLE Hotel_Bookings
DROP COLUMN arrival_date_week_number,
DROP COLUMN arrival_date_day_of_month,
DROP COLUMN meal,	
DROP COLUMN reserved_room_type,
DROP COLUMN assigned_room_type,
DROP COLUMN adults,
DROP COLUMN children,
DROP COLUMN babies,
DROP COLUMN days_in_waiting_list ,
DROP COLUMN reserved_room_type,
DROP COLUMN assigned_room_type,
DROP COLUMN required_car_parking_spaces,
DROP COLUMN company;

ALTER TABLE Hotel_Bookings
ADD COLUMN Reservation_date date;

UPDATE Hotel_Bookings
SET Reservation_date = str_to_date(reservation_status_date, "%d-%m-%Y");

-- Total records from the table
SELECT * FROM Hotel_Bookings; 

/*DATA CLEANING*/
-- Check for missing values in the dataset
SELECT COUNT(*) AS TOTAL_ROWS, SUM(CASE WHEN AGENT IS NULL THEN 1 ELSE 0 END) AS MISSING_VALUES
FROM Hotel_Bookings;

SELECT adr
FROM Hotel_Bookings
ORDER BY ADR DESC
LIMIT 5;

DELETE FROM Hotel_Bookings
WHERE adr=5400;

SELECT adr
FROM Hotel_Bookings
WHERE adr<=0;

DELETE FROM Hotel_Bookings
WHERE adr<=0;

-- Records by Year
SELECT * 
FROM Hotel_Bookings
WHERE YEAR(Reservation_date) =2014;

SELECT * 
FROM Hotel_Bookings
WHERE YEAR(Reservation_date) =2015;

SELECT * 
FROM Hotel_Bookings
WHERE YEAR(Reservation_date) =2016;

SELECT * 
FROM Hotel_Bookings
WHERE YEAR(Reservation_date) =2017;

-- CANCELLATION STATUS
SELECT COUNT(CASE WHEN is_canceled=0 THEN "NO" END) AS NOT_CANCELLED,
       COUNT(CASE WHEN is_canceled=1 THEN "YES" END) AS CANCELLED
FROM Hotel_Bookings;

-- CANCELLATION BY HOTEL TYPE
SELECT hotel, SUM(is_canceled)
FROM Hotel_Bookings
GROUP BY 1;

-- CANCELLATION BY MONTH
SELECT MONTHNAME(Reservation_date), SUM(is_canceled)
FROM Hotel_Bookings
GROUP BY 1
ORDER BY 2 DESC;

-- ADR BY MONTH
SELECT MONTHNAME(Reservation_date), ROUND(SUM(adr),0)
FROM Hotel_Bookings
GROUP BY 1
ORDER BY 2 DESC;

-- CITY HOTEL CANCELLATION BY MONTH
SELECT MONTHNAME(Reservation_date), COUNT(is_canceled)
FROM Hotel_Bookings
WHERE hotel="City Hotel" AND is_canceled = 1
GROUP BY 1
ORDER BY 2 DESC;

-- CITY HOTEL ADR BY MONTH
SELECT MONTHNAME(Reservation_date), ROUND(SUM(adr),1)
FROM Hotel_Bookings
WHERE hotel="City Hotel"
GROUP BY 1
ORDER BY 2 DESC;

-- RESORT HOTEL ADR BY MONTH
SELECT MONTHNAME(Reservation_date), ROUND(SUM(adr),1)
FROM Hotel_Bookings
WHERE hotel="Resort Hotel"
GROUP BY 1
ORDER BY 2 DESC;


-- RESORT HOTEL CANCELLATION BY MONTH
SELECT MONTHNAME(Reservation_date), SUM(is_canceled)
FROM Hotel_Bookings
WHERE hotel="Resort Hotel"
GROUP BY 1
ORDER BY 2 DESC;


-- CANCELLATION BY COUNTRY
SELECT country, SUM(is_canceled)
FROM Hotel_Bookings
GROUP BY 1
ORDER BY 2 DESC;

-- CANCELLATION BY LEAD_TIME
SELECT lead_time, COUNT(*) AS TOTAL_BOOKINGS, SUM(is_canceled) AS CANCELLATION
FROM Hotel_Bookings 
GROUP BY 1
ORDER BY 3 DESC;

-- CANCELLATION ANALYSIS BY previous_cancellations
SELECT previous_cancellations, COUNT(*) AS TOTAL_BOOKINGS, SUM(is_canceled) AS CANCELLATION
FROM Hotel_Bookings 
GROUP BY 1
ORDER BY 1;

-- CANCELLATION BY market_segment
SELECT market_segment, SUM(is_canceled)
FROM Hotel_Bookings
GROUP BY 1
ORDER BY 2 DESC;

-- CANCELLATION BY distribution_channel
SELECT distribution_channel, SUM(is_canceled)
FROM Hotel_Bookings
GROUP BY 1
ORDER BY 2 DESC;

