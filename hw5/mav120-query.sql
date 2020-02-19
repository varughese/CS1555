-- Mathew Varughese
-- MAV120

-- 3. [10 points each] Express the following queries in SQL and answer them using the database
-- you have created above. Do not use any views.

-- (a) List the full names (as one attribute) of P Mobile customers who live in Pittsburgh and
-- whose free SMSs is more than 100.
SELECT CONCAT(fname, " ", lname) AS name
FROM CUSTOMERS
WHERE city = 'Pittsburgh'
AND free_SMS > 100;


-- (b) List the first name, last name and phone number of all customers who owe more than
-- $90. List them in ascending order of amount due.
SELECT fname, lname, cell_pn
FROM CUSTOMERS INNER JOIN STATEMENTS
WHERE  amount_due > 90
ORDER BY amount_due DESC;

-- (c) For each customer, list all phone numbers of people who sent SMSs to that customer in
-- a descending order of the SMS timestamp.
SELECT c.cell_pn, r.to_pn
FROM CUSTOMERS c, RECORDS r
WHERE c.cell_pn = r.to_pn AND r.type = 'sms'
ORDER BY c.cell_pn, start_timestamp DESC;

-- (d) Calculate the average length of a phone call in September 2019.
SELECT AVG(duration)
FROM RECORDS
WHERE type = 'call' AND 
start_timestamp >= TO_TIMESTAMP('1-Sep-19:00:00') AND 
start_timestamp <= TO_TIMESTAMP('1-Sep-30:23:59')

-- (e) Calculate the total amount of payments due for the month of September 2019 for each
-- zip code. List them in an ascending order.
SELECT SUM(amount_due) AS total_due
FROM STATEMENTS r, CUSTOMERS c
WHERE type = 'call' AND 
start_date >= '01-Sep-19' AND 
end_date <= '30-Sep-19' AND r.cell_pn = c.cell_pn
GROUP BY zip_code
ORDER BY total_due DESC

-- (f) Find the first and last name of the customer who made the longest phone call on Jan
-- 1st, 2019.
SELECT fname, lname 
FROM CUSTOMERS c, RECORDS r 
WHERE c.id = r.id AND 
start_timestamp >= TO_TIMESTAMP('1-Jan-19:00:00') AND 
start_timestamp <= TO_TIMESTAMP('1-Jan-10:23:59')
ORDER BY duration
FETCH 1 ROWS;


-- (g) List the number of P Mobile customers in each state.
SELECT state, COUNT(cell_pn) 
FROM CUSTOMERS
GROUP BY state;

-- (h) List the full names of P Mobile customers who has not made any calls for the last 7
-- months.

-- Assumption - "Made a call" means they could have received a call.
SELECT fname, lname 
WHERE cell_pn NOT IN (
	SELECT from_pn FROM RECORDS 
	WHERE 
	start_timestamp >= ADD_MONTHS(SYSDATE, -7)
);

-- (i) List the top 2 cities with the highest local traffic (i.e., maximum number of local calls).
-- A local call is one where both the caller and dialed numbers are in the same city.
SELECT city, COUNT(*)  
FROM RECORDS r
JOIN DIRECTORY dfrom ON r.from_pn = dfrom.pn 
JOIN DIRECTORY dto ON r.to_pn = dto.pn
WHERE dfrom.city == dto.city
GROUP BY dfrom.city
ORDER BY COUNT(*)
FETCH 2 ROWS;

