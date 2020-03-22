------------------------------------------------------
--- Sample Solution to Assignment #5   ---
------------------------------------------------------
------------------------------------------------------
--- QUESTION 1 ---
------------------------------------------------------

--a)
ALTER TABLE PAYMENTS ADD PAYER_SSN number(9);
--b) 
ALTER TABLE PAYMENTS ADD CONSTRAINT PAYMENTS_FK_SSN FOREIGN KEY (PAYER_SSN) REFERENCES CUSTOMERS(SSN);

------------------------------------------------------
--- QUESTION 2 ---
------------------------------------------------------

INSERT INTO PAYMENTS values(4121231231, '05-Aug-19', 39.99, 123456789);
INSERT INTO PAYMENTS values(4121231231, '04-Sep-19', 39.99, 123456789);
INSERT INTO PAYMENTS values(4124564564, '03-Aug-19', 100, 123456789);
INSERT INTO PAYMENTS values(4127897897, '06-Aug-19', 39.99, 123456789);
INSERT INTO PAYMENTS values(4127417417, '06-Aug-19', 10.00, 123456789);