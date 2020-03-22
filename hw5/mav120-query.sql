-- Mathew Varughese
-- MAV120

-- 3. [10 points each] Express the following queries in SQL and answer them using the database
-- you have created above. Do not use any views.

-- (a) List the full names (as one attribute) of P Mobile customers who live in Pittsburgh and
-- whose free SMSs is more than 100.
SELECT CONCAT(CONCAT(fname, ' '), lname) AS name
FROM CUSTOMERS
WHERE city = 'Pittsburgh'
AND free_SMS > 100;


-- (b) List the first name, last name and phone number of all customers who owe more than
-- $90. List them in ascending order of amount due.
SELECT fname, lname, cell_pn
FROM CUSTOMERS NATURAL JOIN STATEMENTS
WHERE  amount_due > 90
ORDER BY amount_due ASC;

-- (c) For each customer, list all phone numbers of people who sent SMSs to that customer in
-- a descending order of the SMS timestamp.

-- Assuming "sent" means the customer should be the "to_pn" of the table and we do not show any
-- customers that do not have any SMS messages

SELECT FNAME, LNAME, CELL_PN, r.FROM_PN  as SENDER
FROM CUSTOMERS c
LEFT JOIN RECORDS r
ON c.CELL_PN = r.TO_PN
WHERE TYPE = 'sms'
ORDER BY start_timestamp, c.cell_pn DESC;

-- (d) Calculate the average length of a phone call in September 2019.
SELECT AVG(duration)
FROM RECORDS
WHERE type = 'call' AND 
start_timestamp >= TO_TIMESTAMP('1-Sep-19:00:00','DD-MON-RR:HH24:MI') AND
start_timestamp <= TO_TIMESTAMP('1-Sep-30:23:59','DD-MON-RR:HH24:MI');

-- (e) Calculate the total amount of payments due for the month of September 2019 for each
-- zip code. List them in an ascending order.
SELECT zip, SUM(amount_due) AS total_due
FROM STATEMENTS r, CUSTOMERS c
WHERE
start_date >= '01-Sep-19' AND 
end_date <= '30-Sep-19' AND r.cell_pn = c.cell_pn
GROUP BY c.zip
ORDER BY total_due ASC;

-- (f) Find the first and last name of the customer who made the longest phone call on Jan
-- 1st, 2019.

-- Assumption - "Made a call" means they were the 'from_pn'
SELECT fname, lname
FROM CUSTOMERS c, RECORDS r 
WHERE c.cell_pn = r.from_pn AND
start_timestamp >= TO_TIMESTAMP('1-Jan-19:00:00','DD-MON-RR:HH24:MI') AND
start_timestamp <= TO_TIMESTAMP('1-Jan-19:23:59','DD-MON-RR:HH24:MI') AND
duration > 0
ORDER BY duration DESC
FETCH FIRST 1 ROWS ONLY;


-- (g) List the number of P Mobile customers in each state.
SELECT state, COUNT(cell_pn) 
FROM CUSTOMERS
GROUP BY state;

-- (h) List the full names of P Mobile customers who has not made any calls for the last 7
-- months.

-- Assumption - "Not made a call" means they could have received a call.
SELECT fname, lname
FROM CUSTOMERS
WHERE cell_pn NOT IN (
	SELECT from_pn
	FROM RECORDS
	WHERE start_timestamp >= ADD_MONTHS(SYSDATE, -7)
);

-- (i) List the top 2 cities with the highest local traffic (i.e., maximum number of local calls).
-- A local call is one where both the caller and dialed numbers are in the same city.
SELECT dto.city
FROM RECORDS r
JOIN DIRECTORY dfrom ON r.from_pn = dfrom.pn 
JOIN DIRECTORY dto ON r.to_pn = dto.pn
WHERE dfrom.city = dto.city
GROUP BY dto.city
ORDER BY COUNT(*) DESC
FETCH FIRST 2 ROWS ONLY;