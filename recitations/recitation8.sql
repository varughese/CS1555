create table NOTDEF (
ssn number,
constraint pk_ssn_1 PRIMARY KEY(ssn)
);
create table DEFIMM (
ssn number,
constraint pk_ssn_2 PRIMARY KEY(ssn) Deferrable Initially Immediate
);
create table DEFDEF (
ssn number,
constraint pk_ssn_3 PRIMARY KEY(ssn) Deferrable Initially Deferred
);

INSERT INTO NOTDEF values(1234);
INSERT INTO NOTDEF values(1234);
COMMIT;

INSERT INTO DEFIMM values(1234);
INSERT INTO DEFIMM values(1234);
COMMIT;

INSERT INTO DEFDEF values(1234);
INSERT INTO DEFDEF values(1234);
COMMIT;


set constraints all deferred;
insert into NOTDEF values (1235);
insert into NOTDEF values (1235);
commit;

-- CREATE PROCEDURE transfer_fund(
-- from_account in varchar2,
-- to_account in varchar2,
-- amount in NUMBER
-- ) AS
--     from_account_balance NUMBER;
-- BEGIN
--     SELECT BALANCE INTO from_account_balance FROM ACCOUNT WHERE ACC_NO = from_account;
--     IF from_account_balance > amount then
--         update account set balance = balance - amount where acc_no = from_account;
--         update account set balance = balance + amount where acc_no = to_account;
--     ELSE
--         dbms_output.PUT_LINE('insufficient funds');
--     end if;
-- END;
-- /
--
--
-- set transaction read write name 'transfer1';
-- set constraints all deferred;
-- CALL transfer_fund('124', '123', 100);
-- commit;