-- Mathew Varughese MAV120
-- 2

DROP TABLE CUSTOMERS cascade constraints;
DROP TABLE RECORDS cascade constraints;
DROP TABLE STATEMENTS cascade constraints;
DROP TABLE PAYMENTS cascade constraints;
DROP TABLE DIRECTORY cascade constraints;

CREATE TABLE DIRECTORY(
    pn NUMBER(10),
    fname VARCHAR2(20),
    lname VARCHAR2(20),
    street VARCHAR2(20),
    city VARCHAR2(20),
    zip NUMBER(5),
    state VARCHAR2(20),

    CONSTRAINT PK_Directory PRIMARY KEY(pn)
);

CREATE TABLE CUSTOMERS(
    SSN NUMBER(9),
    fname VARCHAR2(20) NOT NULL,
    lname VARCHAR2(20) NOT NULL,
    cell_pn NUMBER(10),
    home_pn NUMBER(10),
    street VARCHAR2(20),
    city VARCHAR2(20),
    zip NUMBER(5),
    state VARCHAR2(20),
    free_min NUMBER,
    dob DATE,

    CONSTRAINT PK_Customers PRIMARY KEY(SSN),
    CONSTRAINT FK_Customers_cell_pn FOREIGN KEY(cell_pn) references DIRECTORY(pn),
    CONSTRAINT FK_Customers_home_pn FOREIGN KEY(home_pn) references DIRECTORY(pn)
);

CREATE TABLE RECORDS(
    from_pn NUMBER(10),
    to_pn NUMBER(10),
    start_timestamp TIMESTAMP,
    duration NUMBER(4),
    type VARCHAR2(20) CHECK (type IN ('call', 'sms')),

    CONSTRAINT PK_Records PRIMARY KEY(from_pn, to_pn, start_timestamp, type),
    CONSTRAINT FK_Records_from_pn FOREIGN KEY(to_pn) references DIRECTORY(pn),
    CONSTRAINT FK_Records_to_pn FOREIGN KEY(from_pn) references DIRECTORY(pn)

);

CREATE TABLE STATEMENTS(
    cell_pn NUMBER(10),
    start_date DATE,
    end_date DATE,
    total_minutes NUMBER,
    total_SMS NUMBER,
    amount_due NUMBER(6, 2),

    CONSTRAINT PK_Statements PRIMARY KEY(cell_pn, start_date, end_date)
);

CREATE TABLE PAYMENTS(
    cell_pn NUMBER(10),
    paid_on TIMESTAMP,
    amount_paid NUMBER(6, 2),

    CONSTRAINT PK_Payments PRIMARY KEY(cell_pn, paid_on, amount_paid)
);

-- 3a
ALTER TABLE CUSTOMERS ADD CONSTRAINT customer_Uniq_Cell_Pn UNIQUE (cell_pn);

-- 3b
ALTER TABLE CUSTOMERS ADD free_SMS NUMBER;

-- 3c
ALTER TABLE STATEMENTS ADD previous_balance NUMBER(6, 2);

-- 3d
ALTER TABLE CUSTOMERS MODIFY free_min DEFAULT 0;
ALTER TABLE CUSTOMERS MODIFY free_SMS DEFAULT 0;