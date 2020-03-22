---------------------------------------------
-- HW 7
-- Mathew Varughese
-- MAV120

---------------------------------------------
-- Question #1:
DROP TABLE RECORDS CASCADE CONSTRAINTS;
DROP TABLE STATEMENTS CASCADE CONSTRAINTS;
DROP TABLE PAYMENTS CASCADE CONSTRAINTS;
DROP TABLE CUSTOMERS CASCADE CONSTRAINTS;
DROP TABLE DIRECTORY CASCADE CONSTRAINTS;

DROP TABLE COMP_BILL CASCADE CONSTRAINTS;
DROP TABLE COMPANY CASCADE CONSTRAINTS;
DROP MATERIALIZED VIEW MV_COMPANY_LATEST_DUE;


CREATE TABLE DIRECTORY(
pn      number(10)       not null,
fname   varchar2(20)    not null,
lname   varchar2(20 )    not null,
street          varchar2(40),
city            varchar2(20),
zip             number(5),
state           varchar2(20),
CONSTRAINT DIRECTORY_PK PRIMARY KEY (pn) Deferrable Initially Immediate
);

---CREATING CUSTOMERS TABLE
CREATE TABLE CUSTOMERS(
SSN         number(9) 	    not null,
fname       varchar2(20)    not null,
lname       varchar2(20)    not null,
cell_pn     number(10)      not null,
home_pn     number(10),
street      varchar2(40),
city        varchar2(20),
zip         number(5),
state       varchar2(20),
free_min    number,
dob       date,
CONSTRAINT CUSTOMERS_PK PRIMARY KEY (cell_pn) Deferrable Initially Immediate,
CONSTRAINT CUSTOMERS_FK1 FOREIGN KEY (cell_pn) REFERENCES DIRECTORY(pn) Deferrable Initially Immediate,
CONSTRAINT CUSTOMERS_FK2 FOREIGN KEY (home_pn) REFERENCES DIRECTORY(pn) Deferrable Initially Immediate,
CONSTRAINT CUSTOMERS_UN UNIQUE (SSN) Deferrable Initially Immediate
);

---CREATING RECORDS TABLE
CREATE TABLE RECORDS(
from_pn         number(10)      not null,
to_pn           number(10)      not null,
start_timestamp  TIMESTAMP       not null,
duration number(4),
type       varchar2(20)     not null,
CONSTRAINT RECORDS_PK PRIMARY KEY(from_pn, start_timestamp) Deferrable Initially Immediate,
CONSTRAINT RECORDS_FK1 FOREIGN KEY(from_pn) REFERENCES DIRECTORY(pn) Deferrable Initially Immediate,
CONSTRAINT RECORDS_FK2 FOREIGN KEY(to_pn) REFERENCES DIRECTORY(pn) Deferrable Initially Immediate
);

---CREATING STATEMENTS TABLE
CREATE TABLE STATEMENTS(
cell_pn         number(10)      not null,
start_date      DATE    not null,
end_date        DATE    not null,
total_minutes   number,
total_SMS       number,
amount_due      number(6,2),
CONSTRAINT STATEMENTS_PK PRIMARY KEY (cell_pn, start_date) Deferrable Initially Immediate,
CONSTRAINT STATEMENTS_FK FOREIGN KEY (cell_pn) REFERENCES CUSTOMERS(cell_pn) Deferrable Initially Immediate,
CONSTRAINT STATEMENTS_UN UNIQUE(cell_pn, end_date) Deferrable Initially Immediate
);

CREATE TABLE PAYMENTS(
cell_pn	number(10)	not null,
paid_on	TIMESTAMP,
amount_paid	number(6,2),
CONSTRAINT PAYMENTS_PK PRIMARY KEY(cell_pn, paid_on) Deferrable Initially Immediate,
CONSTRAINT PAYMENTS_FK FOREIGN KEY(cell_pn) REFERENCES CUSTOMERS(cell_pn) Deferrable Initially Immediate
);

ALTER TABLE RECORDS add Constraint records_UQ_toPn UNIQUE(to_pn, start_timestamp) Deferrable Initially Immediate;

ALTER TABLE STATEMENTS add Constraint statements_UQ_endDate UNIQUE(end_date, cell_pn) Deferrable Initially Immediate;

ALTER TABLE CUSTOMERS add free_SMS number;

ALTER TABLE STATEMENTS add previous_balance number(6,2);

ALTER TABLE CUSTOMERS modify free_min default 0;
ALTER TABLE CUSTOMERS modify free_SMS default 0;

Commit;
Purge recyclebin;

---------------------------------------------
-- Question #2:
CREATE TABLE COMPANY(
    comp_ID number not null,
    comp_name varchar2(20) not null,
    street varchar2(40),
    city varchar2(20),
    zip number(5),
    state varchar2(2),

    CONSTRAINT COMPANY_PK PRIMARY KEY (comp_ID) Deferrable Initially Immediate
);

---------------------------------------------
-- Question #3:

CREATE TABLE COMP_BILL(
    comp_ID number not null,
    start_date date not null,
    end_date date not null,
    total_minutes number(10, 2),
    amount_due number(10, 2),

    CONSTRAINT COMP_BILL_PK PRIMARY KEY(comp_ID, start_date) Deferrable Initially Immediate,
    CONSTRAINT COMP_BILL_FK FOREIGN KEY(comp_ID) REFERENCES COMPANY(comp_ID) Deferrable Initially Immediate
);

---------------------------------------------
-- Question #4:
ALTER TABLE DIRECTORY add comp_ID number;
ALTER TABLE DIRECTORY add Constraint directory_comp_id_fk FOREIGN KEY (comp_ID) REFERENCES COMPANY(comp_ID) INITIALLY IMMEDIATE DEFERRABLE;
ALTER TABLE DIRECTORY modify comp_ID NOT NULL;

---------------------------------------------
-- Question #5:
ALTER TABLE COMPANY add charge_rate number;
ALTER TABLE COMPANY modify charge_rate default 0.20;
ALTER TABLE COMPANY add Constraint company_positive_charge_rate CHECK (charge_rate >= 0) INITIALLY IMMEDIATE DEFERRABLE;

---------------------------------------------
-- Question #6:
ALTER TABLE COMP_BILL add Constraint end_date_gt_start_date CHECK(end_date > start_date) INITIALLY IMMEDIATE DEFERRABLE;

---------------------------------------------
-- Question #7:
set constraints all deferred;
BEGIN
INSERT INTO DIRECTORY values(7248881212, 'James', 'Kennedy'  , '5550 Fifth Avenue'  , 'Pittsburgh'   ,15216, 'PA',9);
INSERT INTO DIRECTORY values(7248884545, 'Robin', 'Gates'  , '6660 Sixth St'  , 'Pittsburgh'   ,15666, 'PA',9);
INSERT INTO COMPANY(comp_ID,comp_name,street,city,zip,state,charge_rate) values(9,'Q_Mobile','1111 Fifth Ave','Pittsburgh',15213,'PA',0.10);
END;
COMMIT;

---------------------------------------------
-- Question #8:
-- A)
CREATE OR REPLACE VIEW V_OUTSTANDING_BAL(full_name, cell_pn, city, balance)
AS
SELECT C.fname || ' ' || C.lname,
       C.cell_pn,
       C.city,
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

select full_name, cell_pn,
       CASE
           WHEN city = 'Pittsburgh' THEN balance - 20
           WHEN city = 'Philadelphia' THEN balance - 15
           ELSE balance END AS balance
       from V_OUTSTANDING_BAL;

-- B)

SELECT comp_name, state,
       CASE
            WHEN state = 'PA' AND comp_name != 'P_Mobile' AND (charge_rate - 0.05 < 0) THEN total_minutes * 0.01
            WHEN state = 'PA' AND comp_name != 'P_Mobile' THEN total_minutes * (charge_rate - 0.05)
            WHEN state != 'PA' THEN total_minutes * (charge_rate + 0.10)
            END AS new_amount_due
FROM
COMP_BILL JOIN COMPANY on COMP_BILL.comp_ID = COMPANY.comp_ID
WHERE start_date >= TO_DATE('01-APR-2019') AND end_date <= TO_DATE('31-JUL-2019');
---------------------------------------------
-- Question #9:
-- A)
CREATE MATERIALIZED VIEW MV_COMPANY_LATEST_DUE AS
SELECT COMPANY.COMP_ID, AMOUNT_DUE
FROM COMPANY JOIN (
SELECT c.comp_ID, amount_due FROM
(SELECT comp_ID, MAX(end_date) as end_date FROM COMP_BILL GROUP BY comp_ID) cend
LEFT JOIN COMP_BILL c ON c.comp_ID = cend.comp_ID AND c.end_date = cend.end_date) LATEST_COMP_BILL
ON COMPANY.comp_ID = LATEST_COMP_BILL.comp_ID;


CREATE OR REPLACE TRIGGER DISPLAY_LATEST_DUES
    AFTER UPDATE OF charge_rate ON COMPANY
    FOR EACH ROW
DECLARE
    latest_amount_due number;
BEGIN
    SELECT amount_due INTO latest_amount_due
    FROM MV_COMPANY_LATEST_DUE
    WHERE comp_ID = :new.comp_ID;
    DBMS_OUTPUT.PUT_LINE('Latest amount due for company ' || :new.comp_ID || ': ' || latest_amount_due);
END;


-- B)
CREATE OR REPLACE VIEW V_LATEST_STATEMENT AS
SELECT s.cell_pn, start_date, s.end_date FROM
(SELECT cell_pn, MAX(end_date) as end_date FROM STATEMENTS GROUP BY cell_pn) max_end_dates
LEFT JOIN STATEMENTS s ON s.cell_pn = max_end_dates.cell_pn AND s.end_date = max_end_dates.end_date;

-- Assumption: We increase the total minutes to both the from_pn and to_pn in the new records, and we update
-- the latest statement because we assume any new record will be created after the statement is already created.
CREATE OR REPLACE TRIGGER BILLING
AFTER INSERT ON RECORDS
FOR EACH ROW
WHEN (new.type = 'CALL')
DECLARE
    latest_start_date date;
BEGIN
    select start_date into latest_start_date from V_LATEST_STATEMENT WHERE cell_pn = :new.from_pn;
    update STATEMENTS
        set total_minutes = total_minutes + :new.duration
    where cell_pn = :new.from_pn AND start_date = latest_start_date;
    select start_date into latest_start_date from V_LATEST_STATEMENT WHERE cell_pn = :new.to_pn;
    update STATEMENTS
        set total_minutes = total_minutes + :new.duration
    where cell_pn = :new.to_pn AND start_date = latest_start_date;
END;

---------------------------------------------
-- Question #10:
-- A)
CREATE OR REPLACE PROCEDURE PROC_UPDATE_CHARGE_RATE(input_comp_id number, rate_charge number) AS
BEGIN
    UPDATE COMPANY
        set charge_rate = rate_charge
    WHERE comp_ID = input_comp_id;
END;


---------------------------------------------
-- Question #11:
-- A)
SELECT * FROM COMPANY;

set transaction read write;
set constraints all deferred;
call PROC_UPDATE_CHARGE_RATE(2, 0.33);
commit;

SELECT * FROM COMPANY;

-- B)
SELECT * FROM RECORDS;

INSERT INTO RECORDS
VALUES (4121231231, 4843504021, TO_TIMESTAMP('27-AUG-19:22:12', 'DD-MON-RR:HH24:MI'), 301, 'CALL');
INSERT INTO RECORDS
VALUES (4122582582, 4121231231, TO_TIMESTAMP('28-AUG-19:22:12', 'DD-MON-RR:HH24:MI'), 134, 'CALL');

SELECT * FROM RECORDS;

SELECT * FROM STATEMENTS;