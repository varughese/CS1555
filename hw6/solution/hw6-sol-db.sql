----------------------------------------
--- Sample solution of HW2 (Q2 + Q3)
----------------------------------------

---CREATING DIRECTORY TABLE FIRST, SINCE MANY TABLES REFERENCES IT
CREATE TABLE DIRECTORY
(
    pn     number(10)   not null,
    fname  varchar2(20) not null,
    lname  varchar2(20) not null,
    street varchar2(40),
    city   varchar2(20),
    zip    number(5),
    state  varchar2(20),
    CONSTRAINT DIRECTORY_PK PRIMARY KEY (pn)
);

---CREATING CUSTOMERS TABLE
CREATE TABLE CUSTOMERS
(
    SSN      number(9)    not null,
    fname    varchar2(20) not null,
    lname    varchar2(20) not null,
    cell_pn  number(10)   not null,
    home_pn  number(10),
    street   varchar2(40),
    city     varchar2(20),
    zip      number(5),
    state    varchar2(20),
    free_min number,
    dob      date,
    CONSTRAINT CUSTOMERS_PK PRIMARY KEY (cell_pn),
    CONSTRAINT CUSTOMERS_FK1 FOREIGN KEY (cell_pn) REFERENCES DIRECTORY (pn),
    CONSTRAINT CUSTOMERS_FK2 FOREIGN KEY (home_pn) REFERENCES DIRECTORY (pn),
    CONSTRAINT CUSTOMERS_UN UNIQUE (SSN)
);

---CREATING RECORDS TABLE
CREATE TABLE RECORDS
(
    from_pn         number(10)   not null,
    to_pn           number(10)   not null,
    start_timestamp TIMESTAMP    not null,
    duration        number(4),
    type            varchar2(20) not null,
    CONSTRAINT RECORDS_PK PRIMARY KEY (from_pn, start_timestamp),
    CONSTRAINT RECORDS_FK1 FOREIGN KEY (from_pn) REFERENCES DIRECTORY (pn),
    CONSTRAINT RECORDS_FK2 FOREIGN KEY (to_pn) REFERENCES DIRECTORY (pn)
);

---CREATING STATEMENTS TABLE
CREATE TABLE STATEMENTS
(
    cell_pn       number(10) not null,
    start_date    DATE       not null,
    end_date      DATE       not null,
    total_minutes number,
    total_SMS     number,
    amount_due    number(6, 2),
    CONSTRAINT STATEMENTS_PK PRIMARY KEY (cell_pn, start_date),
    CONSTRAINT STATEMENTS_FK FOREIGN KEY (cell_pn) REFERENCES CUSTOMERS (cell_pn),
    CONSTRAINT STATEMENTS_UN UNIQUE (cell_pn, end_date)
);

---CREATING PAYMENTS TABLE
CREATE TABLE PAYMENTS
(
    cell_pn     number(10) not null,
    paid_on     TIMESTAMP,
    amount_paid number(6, 2),
    CONSTRAINT PAYMENTS_PK PRIMARY KEY (cell_pn, paid_on),
    CONSTRAINT PAYMENTS_FK FOREIGN KEY (cell_pn) REFERENCES CUSTOMERS (cell_pn)
);



----------------------------------------
--- Sample solution for Question #3  ---
----------------------------------------

--a) In each table, add a Unique constraint for every of its alternate keys

ALTER TABLE RECORDS
    add Constraint records_UQ_toPn UNIQUE (to_pn, start_timestamp);

ALTER TABLE STATEMENTS
    add Constraint statements_UQ_endDate UNIQUE (end_date, cell_pn);

--b) Add a new attribute free_SMS to table CUSTOMERS,
--   which is the date of birth

ALTER TABLE CUSTOMERS
    add free_SMS number;

--c) Add a new attribute previous balance to table STATEMENTS,
--   which balance carried over from previous statement.

ALTER TABLE STATEMENTS
    add previous_balance number(6, 2);

--d) In table CUSTOMERS, the free_min and free_SMS default value should be set to 0

ALTER TABLE CUSTOMERS
    modify free_min default 0;
ALTER TABLE CUSTOMERS
    modify free_SMS default 0;

Commit;
Purge recyclebin;



----------------------------------------
--- Sample solution of HW2 (Q4)
----------------------------------------
INSERT INTO DIRECTORY
values (4121231231, 'Michael', 'Johnson', '320 Fifth Avenue', 'Pittsburgh', 15213, 'PA');
INSERT INTO DIRECTORY
values (4121232131, 'Michael', 'Johnson', '320 Fifth Avenue', 'Pittsburgh', 15213, 'PA');
INSERT INTO DIRECTORY
values (4124564564, 'Kate', 'Stevenson', '310 Fifth Avenue', 'Pittsburgh', 15213, 'PA');
INSERT INTO DIRECTORY
values (4127897897, 'Bill', 'Stevenson', '310 Fifth Avenue', 'Pittsburgh', 15213, 'PA');
INSERT INTO DIRECTORY
values (4123121231, 'Bill', 'Stevenson', '310 Fifth Avenue', 'Pittsburgh', 15213, 'PA');
INSERT INTO DIRECTORY
values (4127417417, 'Richard', 'Hurson', '340 Fifth Avenue', 'Pittsburgh', 15213, 'PA');
INSERT INTO DIRECTORY
values (4127417612, 'Richard', 'Hurson', '340 Fifth Avenue', 'Pittsburgh', 15213, 'PA');
INSERT INTO DIRECTORY
values (4122582582, 'Mary', 'Davis', '350 Fifth Avenue', 'Pittsburgh', 15217, 'PA');
INSERT INTO DIRECTORY
values (4122581324, 'Mary', 'Davis', '350 Fifth Avenue', 'Pittsburgh', 15217, 'PA');
INSERT INTO DIRECTORY
values (7247779797, 'Julia', 'Hurson', '3350 Fifth Avenue', 'Philadelphia', 22221, 'PA');
INSERT INTO DIRECTORY
values (7247778787, 'Chris', 'Lyn', '62 Sixth St', 'Philadelphia', 22222, 'PA');
INSERT INTO DIRECTORY
values (7243413412, 'Chris', 'Lyn', '62 Sixth St', 'Philadelphia', 22222, 'PA');
INSERT INTO DIRECTORY
values (7248889898, 'Jones', 'Steward', '350 Fifth Avenue', 'Philadelphia', 22222, 'PA');
INSERT INTO DIRECTORY
values (7249879879, 'James', 'Sam', '1210 Forbes Avenue', 'Philadelphia', 22132, 'PA');
INSERT INTO DIRECTORY
values (7249871253, 'James', 'Sam', '1210 Forbes Avenue', 'Philadelphia', 22132, 'PA');
INSERT INTO DIRECTORY
values (6243780132, 'Harry', 'Lee', '3721 Craig Street', 'Tridelphia', 16161, 'WV');
INSERT INTO DIRECTORY
values (6241121342, 'Kate', 'Lee', '3721 Craig Street', 'Tridelphia', 16161, 'WV');
INSERT INTO DIRECTORY
values (6242311322, 'Jack', 'Barry', '3521 Craig Street', 'Tridelphia', 16161, 'WV');
INSERT INTO DIRECTORY
values (6241456123, 'Neil', 'Jackson', '2134 Seventh St', 'Tridelphia', 16161, 'WV');
INSERT INTO DIRECTORY
values (4843504021, 'Frank', 'Shaw', '23 Fifth Avenue', 'Allentown', 14213, 'PA');
INSERT INTO DIRECTORY
values (4843504245, 'Frank', 'Shaw', '23 Fifth Avenue', 'Allentown', 14213, 'PA');
INSERT INTO DIRECTORY
values (4846235161, 'Liam', 'Allen', '345 Craig Street', 'Allentown', 14213, 'PA');
INSERT INTO DIRECTORY
values (4846452231, 'Justin', 'Blosser', '231 Tenth Street', 'Allentown', 14213, 'PA');
INSERT INTO DIRECTORY
values (4846452124, 'Justin', 'Blosser', '231 Tenth Street', 'Allentown', 14213, 'PA');

INSERT INTO CUSTOMERS
values (123456789, 'Michael', 'Johnson', 4121231231, 4121232131, '320 Fifth Avenue', 'Pittsburgh', 15213, 'PA', 300,
        '01-JAN-91', 100);
INSERT INTO CUSTOMERS
values (123232343, 'Kate', 'Stevenson', 4124564564, 4123121231, '310 Fifth Avenue', 'Pittsburgh', 15213, 'PA', 300,
        '05-FEB-90', 100);
INSERT INTO CUSTOMERS
values (445526754, 'Bill', 'Stevenson', 4127897897, 4123121231, '310 Fifth Avenue', 'Pittsburgh', 15213, 'PA', 600,
        '11-DEC-92', 500);
INSERT INTO CUSTOMERS
values (254678898, 'Richard', 'Hurson', 4127417417, 4127417612, '340 Fifth Avenue', 'Pittsburgh', 15213, 'PA', 600,
        '03-OCT-89', 500);
INSERT INTO CUSTOMERS
values (256796533, 'Mary', 'Davis', 4122582582, 4122581324, '350 Fifth Avenue', 'Pittsburgh', 15217, 'PA', 100,
        '04-MAR-93', 500);
INSERT INTO CUSTOMERS
values (245312567, 'Frank', 'Shaw', 4843504021, 4843504245, '23 Fifth Avenue', 'Allentown', 14213, 'PA', 0, '05-JUN-87',
        0);
INSERT INTO CUSTOMERS
values (251347682, 'Jones', 'Steward', 7248889898, null, '350 Fifth Avenue', 'Philadelphia', 22222, 'PA', 150,
        '04-JAN-90', 0);
INSERT INTO CUSTOMERS
values (312567834, 'James', 'Sam', 7249879879, 7249871253, '1210ForbesAvenue', 'Philadelphia', 22132, 'PA', 100,
        '15-AUG-88', 500);
INSERT INTO CUSTOMERS
values (421356312, 'Liam', 'Allen', 4846235161, null, '345 Craig Street', 'Allentown', 14213, 'PA', 0, '16-SEP-92', 0);
INSERT INTO CUSTOMERS
values (452167351, 'Justin', 'Blosser', 4846452231, 4846452124, '231 Tenth Street', 'Allentown', 14213, 'PA', 300,
        '01-MAY-90', 100);

INSERT INTO RECORDS
values (4121231231, 4124564564, TO_TIMESTAMP('01-Jan-19:11:05', 'DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS
values (4121231231, 7247779797, TO_TIMESTAMP('01-Jan-19:17:10', 'DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS
values (4121231231, 7247779797, TO_TIMESTAMP('01-Jan-19:17:15', 'DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS
values (6243780132, 6242311322, TO_TIMESTAMP('02-Aug-19:21:35', 'DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS
values (6243780132, 6242311322, TO_TIMESTAMP('02-Aug-19:23:12', 'DD-MON-RR:HH24:MI'), 200, 'call');
INSERT INTO RECORDS
values (4124564564, 7247778787, TO_TIMESTAMP('08-Aug-19:11:05', 'DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS
values (4127417417, 7248889898, TO_TIMESTAMP('02-Aug-19:05:32', 'DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS
values (7248889898, 7247779797, TO_TIMESTAMP('15-Aug-19:14:17', 'DD-MON-RR:HH24:MI'), 60, 'call');
INSERT INTO RECORDS
values (7248889898, 7247778787, TO_TIMESTAMP('01-Sep-19:11:03', 'DD-MON-RR:HH24:MI'), 300, 'call');
INSERT INTO RECORDS
values (7249879879, 7248889898, TO_TIMESTAMP('03-Sep-19:17:24', 'DD-MON-RR:HH24:MI'), 100, 'call');
INSERT INTO RECORDS
values (4127417417, 7249879879, TO_TIMESTAMP('05-Sep-19:18:24', 'DD-MON-RR:HH24:MI'), 123, 'call');
INSERT INTO RECORDS
values (6243780132, 4846235161, TO_TIMESTAMP('06-Aug-19:20:15', 'DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS
values (4843504021, 4846235161, TO_TIMESTAMP('07-Sep-19:15:23', 'DD-MON-RR:HH24:MI'), 50, 'call');
INSERT INTO RECORDS
values (4846235161, 4846452231, TO_TIMESTAMP('23-Sep-19:12:23', 'DD-MON-RR:HH24:MI'), 120, 'call');
INSERT INTO RECORDS
values (4846452231, 4846235161, TO_TIMESTAMP('25-Sep-19:13:34', 'DD-MON-RR:HH24:MI'), 200, 'call');
INSERT INTO RECORDS
values (4121231231, 6242311322, TO_TIMESTAMP('02-Aug-19:20:30', 'DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS
values (7247778787, 6242311322, TO_TIMESTAMP('02-Aug-19:20:31', 'DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS
values (6243780132, 6242311322, TO_TIMESTAMP('02-Aug-19:20:32', 'DD-MON-RR:HH24:MI'), 0, 'sms');
INSERT INTO RECORDS
values (6243780132, 6242311322, TO_TIMESTAMP('26-Sep-19:23:12', 'DD-MON-RR:HH24:MI'), 200, 'call');
INSERT INTO RECORDS
values (6241456123, 6241121342, TO_TIMESTAMP('29-Sep-19:23:11', 'DD-MON-RR:HH24:MI'), 100, 'call');
INSERT INTO RECORDS
values (4121231231, 6241121342, TO_TIMESTAMP('30-Sep-19:23:11', 'DD-MON-RR:HH24:MI'), 200, 'call');

INSERT INTO STATEMENTS
values (4121231231, '01-Sep-19', '30-Sep-19', 250, 0, 0, 39.99);
INSERT INTO STATEMENTS
values (4124564564, '01-Sep-19', '30-Sep-19', 600, 30, 200.99, 299.99);
INSERT INTO STATEMENTS
values (4127897897, '01-Sep-19', '30-Sep-19', 650, 27, 0, 59.99);
INSERT INTO STATEMENTS
values (4127417417, '01-Sep-19', '30-Sep-19', 517, 96, 49.99, 49.99);
INSERT INTO STATEMENTS
values (4122582582, '01-Sep-19', '30-Sep-19', 500, 270, 39.99, 139.99);
INSERT INTO STATEMENTS
values (4843504021, '01-Sep-19', '30-Sep-19', 230, 403, 0, 59.99);
INSERT INTO STATEMENTS
values (7248889898, '01-Sep-19', '30-Sep-19', 50, 0, 25.99, 25.99);
INSERT INTO STATEMENTS
values (7249879879, '01-Sep-19', '30-Sep-19', 700, 7, 50, 159.99);
INSERT INTO STATEMENTS
values (4846235161, '01-Sep-19', '30-Sep-19', 200, 83, 100, 199.99);
INSERT INTO STATEMENTS
values (4846452231, '01-Sep-19', '30-Sep-19', 500, 12, 59.99, 179.99);


INSERT INTO PAYMENTS
values (4121231231, '05-Aug-19', 39.99);
INSERT INTO PAYMENTS
values (4121231231, '04-Sep-19', 39.99);
INSERT INTO PAYMENTS
values (4124564564, '03-Aug-19', 100);
INSERT INTO PAYMENTS
values (4127897897, '06-Aug-19', 39.99);
INSERT INTO PAYMENTS
values (4127417417, '06-Aug-19', 10.00);

COMMIT;



--===============================
-- BEGINNING OF HW6 SOLUTIONS
--===============================
--
--
--


------------------------------------
-- Q1
------------------------------------

-- A)
CREATE OR REPLACE VIEW PA_NOT_CUSTOMERS (full_name, pn, city)
AS
SELECT D.fname || ' ' || D.lname, D.pn, D.city
FROM DIRECTORY D
         LEFT OUTER JOIN CUSTOMERS C ON D.pn = C.cell_pn
WHERE D.state = 'PA'
  AND C.cell_pn IS NULL;

-- Alternative

CREATE OR REPLACE VIEW PA_NOT_CUSTOMERS(FULL_NAME, PHONE_NUMBER, CITY)
AS SELECT FNAME|| ' ' || LNAME AS FULL_NAME, PN, CITY
FROM DIRECTORY
WHERE PN NOT IN (SELECT CELL_PN FROM CUSTOMERS) AND STATE = 'PA';

-- B)
CREATE MATERIALIZED VIEW MV_PA_CUSTOMERS (full_name, cell_pn, city)
AS
SELECT fname || ' ' || lname, cell_pn, city
FROM CUSTOMERS
WHERE state = 'PA';

-- C)
CREATE OR REPLACE VIEW NUMBER_OF_RECEIVED_CALLS(cell_pn, number_of_calls)
AS
SELECT to_pn, COUNT(*)
FROM RECORDS R
         JOIN CUSTOMERS C ON C.cell_pn = R.to_pn
WHERE TYPE='call'
GROUP BY to_pn;

-- D)
CREATE MATERIALIZED VIEW MV_OUTSTANDING_BAL(full_name, cell_pn, balance)
AS
SELECT C.fname || ' ' || C.lname,
       C.cell_pn,
       CASE
           WHEN total_due IS NULL AND total_paid IS NOT NULL THEN -total_paid
           WHEN total_paid IS NULL AND total_due IS NOT NULL THEN total_due
           WHEN (total_due - total_paid) IS NULL THEN 0
           ELSE (total_due - total_paid) END AS balance
FROM CUSTOMERS C
         LEFT OUTER JOIN
     (SELECT C1.cell_pn, SUM(amount_due) AS total_due, SUM(amount_paid) AS total_paid
      FROM CUSTOMERS C1
               LEFT JOIN PAYMENTS P ON C1.cell_pn = P.cell_pn
               JOIN STATEMENTS S ON C1.cell_pn = S.cell_pn
      GROUP BY C1.cell_pn
     ) CTDP ON C.cell_pn = CTDP.cell_pn
ORDER BY balance DESC;

------------------------------------
-- Q2
------------------------------------

-- A)
SELECT B1.full_name, B1.cell_pn
FROM MV_OUTSTANDING_BAL B1
         JOIN (
    SELECT MIN(balance) AS min_balance
    FROM MV_OUTSTANDING_BAL
) B2 on B1.balance = B2.min_balance;

-- B)
SELECT full_name, OB.balance, RC.number_of_calls
FROM MV_OUTSTANDING_BAL OB
         JOIN NUMBER_OF_RECEIVED_CALLS RC ON OB.cell_pn = RC.cell_pn
WHERE RC.number_of_calls =
      (SELECT MAX(number_of_calls)
       FROM NUMBER_OF_RECEIVED_CALLS);

-- C)
SELECT B1.full_name, B1.cell_pn
FROM MV_OUTSTANDING_BAL B1
         JOIN (
    SELECT MIN(balance) AS min_balance
    FROM MV_OUTSTANDING_BAL
    WHERE balance > 0
) B2 on B1.balance = B2.min_balance;

-- D)
SELECT pgh_non_customers / (pgh_non_customers +
                            (SELECT COUNT(*) AS pgh_customers
                             FROM MV_PA_CUSTOMERS
                             WHERE city = 'Pittsburgh')) AS ratio
FROM (SELECT COUNT(*) AS pgh_non_customers
      FROM PA_NOT_CUSTOMERS
      WHERE city = 'Pittsburgh');

------------------------------------
-- Q3
------------------------------------

INSERT INTO PAYMENTS
values (4124564564, '02-FEB-20', 90);
INSERT INTO DIRECTORY
values (1234565089, 'John', 'Do', '123 Cool St', 'Pittsburgh', 15213, 'PA');
COMMIT;

------------------------------------
-- Q4
------------------------------------

SELECT *
FROM MV_OUTSTANDING_BAL
WHERE cell_pn = 4124564564;
SELECT *
FROM PA_NOT_CUSTOMERS
WHERE pn = 1234565089;

BEGIN
    DBMS_MVIEW.REFRESH('MV_OUTSTANDING_BAL');
END;
/
-- Recall / is only needed in SQLplus













