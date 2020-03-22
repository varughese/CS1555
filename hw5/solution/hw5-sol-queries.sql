------------------------------------------------------
--- Sample Solution to Assignment #5   ---
------------------------------------------------------
------------------------------------------------------
--- QUESTION 3 ---
------------------------------------------------------

-- a) List the full names (as one attribute) of P_Mobile customers 
--    who live in Pittsburgh and whose free SMSs is more than 100.

SELECT fname || ' ' || lname AS full_name
FROM CUSTOMERS
WHERE city = 'Pittsburgh'
  AND free_SMS > 100;

------------------------------------------------------------------------------------------------
-- b) List the first name, last name and phone number of all customers who owe more than $90. 
--    List them in a ascending order of amount_due.

SELECT fname, lname, cell_pn
FROM STATEMENTS
         NATURAL JOIN CUSTOMERS
WHERE amount_due > 90 
ORDER BY amount_due ASC;  -- NOTE: ASC can be ommitted because ASC is the default

------------------------------------------------------------------------------------------------
-- c) For each customer, list all phone numbers of people who 
--    sent SMSs to that customer in a descending order of the SMS timestamp.

SELECT from_pn AS sender, start_timestamp AS timestamp
FROM CUSTOMERS
         JOIN records ON cell_pn = to_pn
WHERE type = 'sms'
ORDER BY start_timestamp DESC;

------------------------------------------------------------------------------------------------
-- d) Calculate the average length of a phone call in September 2019.

SELECT AVG(duration) AS average_call
FROM RECORDS
WHERE type = 'call'
  AND (EXTRACT(MONTH FROM start_timestamp) = 9)
  AND (EXTRACT(YEAR FROM start_timestamp) = '2019');

------------------------------------------------------------------------------------------------
-- e) Calculate the total amount of payments due for the month of 
--    September 2019 for each zip code. List them in an ascending order.

SELECT zip, SUM(amount_due) AS sum_amount_due
FROM customers
         NATURAL JOIN statements
WHERE (EXTRACT(MONTH FROM start_date) = 9)
  AND (EXTRACT(YEAR FROM start_date) = '2019')
GROUP BY zip
ORDER BY sum_amount_due ASC; 

------------------------------------------------------------------------------------------------
--f) Find the first and last name of the customer who made the longest phone call on Jan 1st, 2019.

SELECT fname, lname
FROM CUSTOMERS
         JOIN RECORDS ON cell_pn = from_pn
WHERE type = 'call'
  AND start_timestamp >= to_timestamp('01-JAN-19:00:00', 'DD-MON-RR:HH24:MI')
  AND start_timestamp < to_timestamp('02-JAN-19:00:00', 'DD-MON-RR:HH24:MI')
  AND duration = (SELECT MAX(duration)
                  FROM RECORDS
                  WHERE start_timestamp >= to_timestamp('01-JAN-19:00:00', 'DD-MON-RR:HH24:MI')
                    AND start_timestamp < to_timestamp('02-JAN-19:00:00', 'DD-MON-RR:HH24:MI')
                    AND type = 'call')
FETCH FIRST 1 ROWS ONLY; -- This is optional

-- Alternative

SELECT fname, lname
FROM CUSTOMERS
         JOIN RECORDS ON cell_pn = from_pn
WHERE type = 'call'
  AND start_timestamp >= to_timestamp('01-JAN-19:00:00', 'DD-MON-RR:HH24:MI')
  AND start_timestamp < to_timestamp('02-JAN-19:00:00', 'DD-MON-RR:HH24:MI')
GROUP BY fname, lname
ORDER BY , MAX(duration)  DESC
FETCH FIRST 1 ROWS ONLY; -- This is optional

------------------------------------------------------------------------------------------------
-- g) List the number of P Mobile customers in each state

SELECT state, COUNT(*) AS number_of_customers
FROM CUSTOMERS
GROUP BY state;

------------------------------------------------------------------------------------------------
-- h) List the full names of P Mobile customers who has not made any calls for the last 7 months.


SELECT fname || ' ' || lname AS full_name
FROM CUSTOMERS
WHERE cell_pn NOT IN (SELECT DISTINCT from_pn
                      FROM RECORDS
                      WHERE type = 'call'
                        AND start_timestamp > add_months(current_timestamp, -7));

-- Alternative 1

SELECT c1.fname || ' ' || c1.lname AS full_name
FROM CUSTOMERS c1
WHERE NOT EXISTS(SELECT *
                 FROM RECORDS r
                          JOIN customers c2 ON r.FROM_PN = c2.CELL_PN
                 WHERE r.type = 'call'
                   AND r.start_timestamp > add_months(current_timestamp, -7)
                   AND c1.CELL_PN = r.FROM_PN);

-- Alternative 2

SELECT c.fname || ' ' || c.lname AS full_name
FROM CUSTOMERS c
         LEFT OUTER JOIN (SELECT DISTINCT from_pn, duration
                          FROM RECORDS
                          WHERE type = 'call'
                            AND start_timestamp > add_months(current_timestamp, -7)
                         ) called_last_7_months
                         ON c.cell_pn = called_last_7_months.from_pn
WHERE duration IS NULL;

-- In the sample solutions above, for the months you can also use this (CURRENT_TIMESTAMP - Interval '7' month)

------------------------------------------------------------------------------------------------
-- i) List the top 2 cities with the highest local traffic (i.e., maximum number of local calls).
--    A local call is one where both the caller and dialed numbers are in the same city.


SELECT from_call.city, COUNT(*) AS num_local_calls
FROM RECORDS r
         JOIN directory from_call ON from_call.pn = r.from_PN
         JOIN directory to_call ON to_call.pn = r.to_PN
WHERE type = 'call'
  AND from_call.city = to_call.city
GROUP BY from_call.city
ORDER BY count(*) DESC, from_call.city -- from_call.city optional
FETCH FIRST 2 ROWS ONLY;

-- Alternative

SELECT from_call.city, COUNT(*) AS num_local_calls
FROM (RECORDS r
         JOIN directory from_call ON from_call.pn = r.from_PN)
         JOIN directory to_call ON to_call.pn = r.to_PN 
                                    AND from_call.city = to_call.city
WHERE type = 'call'
GROUP BY from_call.city
ORDER BY count(*) DESC, from_call.city -- from_call.city optional                                       
FETCH FIRST 2 ROWS ONLY;

