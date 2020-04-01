-- If new user account and role is guest, then set password to GUEST

CREATE OR REPLACE TRIGGER SET_GUEST_PASSWORD
    BEFORE UPDATE ON USER_ACCOUNT
    FOR EACH ROW
    WHEN(new.ROLE_ID = 0)
BEGIN

    SELECT amount_due INTO latest_amount_due
    FROM MV_COMPANY_LATEST_DUE
    WHERE comp_ID = :new.comp_ID;
    DBMS_OUTPUT.PUT_LINE('Latest amount due for company ' || :new.comp_ID || ': ' || latest_amount_due);
END;