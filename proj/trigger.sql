----------------
-- Auto incrementing IDs triggers
CREATE SEQUENCE user_accounts_sequence start with 200;
CREATE SEQUENCE olympics_sequence start with 200;
CREATE SEQUENCE sport_sequence start with 200;
CREATE SEQUENCE team_sequence start with 200;
CREATE SEQUENCE venue_sequence start with 200;
CREATE SEQUENCE event_sequence start with 200;
CREATE SEQUENCE participant_sequence start with 200;

-- The database will always create the primary key. The init script
-- already has id's pre-populated.

CREATE OR REPLACE TRIGGER user_account_id
  BEFORE INSERT ON USER_ACCOUNT
  FOR EACH ROW
BEGIN
    IF :new.user_id IS NULL THEN
        SELECT user_accounts_sequence.nextval
        INTO :new.user_id
        FROM dual;
    END IF;
END;

CREATE OR REPLACE TRIGGER olympics_id
  BEFORE INSERT ON OLYMPICS
  FOR EACH ROW
BEGIN
    IF :new.OLYMPIC_ID IS NULL THEN
        SELECT olympics_sequence.nextval
        INTO :new.OLYMPIC_ID
        FROM dual;
    END IF;
END;

CREATE OR REPLACE TRIGGER sport_id
  BEFORE INSERT ON SPORT
  FOR EACH ROW
BEGIN
    IF :new.sport_id IS NULL THEN
        SELECT sport_sequence.nextval
        INTO :new.sport_id
        FROM dual;
    END IF;
END;

CREATE OR REPLACE TRIGGER team_id
  BEFORE INSERT ON TEAM
  FOR EACH ROW
BEGIN
    IF :new.team_id IS NULL THEN
        SELECT team_sequence.nextval
        INTO :new.team_id
        FROM dual;
    END IF;
END;

CREATE OR REPLACE TRIGGER venue_id
  BEFORE INSERT ON VENUE
  FOR EACH ROW
BEGIN
    IF :new.venue_id IS NULL THEN
        SELECT venue_sequence.nextval
        INTO :new.venue_id
        FROM dual;
    END IF;
END;

CREATE OR REPLACE TRIGGER event_id
  BEFORE INSERT ON EVENT
  FOR EACH ROW
BEGIN
    IF :new.event_id IS NULL THEN
        SELECT event_sequence.nextval
        INTO :new.event_id
        FROM dual;
    END IF;
END;

-- If new user account and role is guest, then set password to GUEST
CREATE OR REPLACE TRIGGER SET_GUEST_PASSWORD
    BEFORE INSERT ON USER_ACCOUNT
    FOR EACH ROW
    WHEN(new.ROLE_ID = 0)
BEGIN
    UPDATE USER_ACCOUNT
        set PASSKEY = 'GUEST'
    WHERE USER_ID = :new.user_id;
END;

-- This trigger is responsible to assign the appropriate medal based on the
-- position when new records are inserted or updated in the SCOREBOARD.
CREATE OR REPLACE TRIGGER ASSIGN_MEDAL
    BEFORE INSERT OR UPDATE ON SCOREBOARD
    FOR EACH ROW
BEGIN
    IF :new.position = 1 THEN
        :new.medal_id := 1; -- Gold
    ELSE IF :new.position = 2 THEN
        :new.medal_id := 2; -- Silver
    ELSE IF :new.position = 3 THEN
        :new.medal_id := 3; -- Bronze
    ELSE
        :new.medal_id := null;
    end if;
    end if;
    end if;
END;

-- This trigger is responsible for deleting all the data of an athlete who
-- was dismissed because of a violation. If the athlete is a member of a team sport, then the team
-- is also dismissed by setting the status not eligible (n) in participating in any event. If the athlete
-- participates in an atomic sport, then the corresponding teams are removed from the events.
CREATE OR REPLACE TRIGGER ATHLETE_DISMISSAL
    BEFORE DELETE ON PARTICIPANT
    FOR EACH ROW
BEGIN
    DELETE FROM SCOREBOARD WHERE PARTICIPANT_ID = :old.participant_id;
    FOR currteam IN (SELECT TEAM_SIZE, TEAM_ID FROM V_TEAM_SIZE_PARTICIPANT WHERE PARTICIPANT_ID = :old.participant_id) LOOP
        IF currteam.TEAM_SIZE = 1 THEN
            -- If team size is 1, this was an atomic sport, and we delete all associated tables and events
            DBMS_OUTPUT.PUT_LINE('Participant in atomic team, ' || currteam.TEAM_ID || ' getting all data removed');
            DELETE FROM EVENT_PARTICIPATION WHERE TEAM_ID = currteam.TEAM_ID;
            DELETE FROM TEAM_MEMBER WHERE PARTICIPANT_ID = :old.participant_id;
            DELETE FROM TEAM WHERE TEAM_ID = currteam.TEAM_ID;
        ELSE
            -- If team size is greater than 1, we mark
            DBMS_OUTPUT.PUT_LINE('Participants team is getting marked inelligible. '  || currteam.TEAM_ID);
            UPDATE EVENT_PARTICIPATION SET STATUS = 'n' WHERE TEAM_ID = currteam.TEAM_ID;
            DELETE FROM TEAM_MEMBER WHERE PARTICIPANT_ID = :old.participant_id;
        end if;
    END LOOP;
END;


CREATE OR REPLACE VIEW V_TEAM_SIZE_PARTICIPANT AS
SELECT TEAM_SIZE, TEAM_MEMBER.TEAM_ID, PARTICIPANT_ID FROM
    (SELECT TEAM_SIZE, TEAM_ID FROM SPORT JOIN TEAM ON SPORT.SPORT_ID = TEAM.SPORT_ID) teamsize
    JOIN TEAM_MEMBER ON teamsize.TEAM_ID = TEAM_MEMBER.TEAM_ID;

-- This trigger should check the maximum possible venue capacity before
-- the event is associated with it. In case the capacity is exceeded, an exception should be thrown
CREATE OR REPLACE TRIGGER ENFORCE_CAPACITY
    BEFORE INSERT OR UPDATE ON EVENT
    FOR EACH ROW
DECLARE
    e_count number;
    e_capacity number;
    capacity_reached_exception EXCEPTION;
BEGIN
    SELECT COUNT, NVL(CAPACITY, 0) INTO e_count, e_capacity
    FROM V_VENUE_COUNT
    WHERE VENUE_ID = :new.venue_id AND EVENT_TIME = :new.event_time;

    IF e_count + 1 > e_capacity THEN
        RAISE capacity_reached_exception;
    end if;
END;


CREATE OR REPLACE VIEW V_VENUE_COUNT AS
SELECT V.VENUE_ID, EVENT_TIME, COUNT, CAPACITY
FROM (SELECT EVENT_TIME, VENUE_ID, COUNT(*) as COUNT FROM EVENT GROUP BY EVENT_TIME, VENUE_ID) VENUE_COUNT
RIGHT JOIN VENUE V on VENUE_COUNT.VENUE_ID = V.VENUE_ID;


-- We ensure that an event is in the correct venue for the correct olympics
CREATE OR REPLACE TRIGGER VENUE_CHECK
BEFORE INSERT OR UPDATE ON EVENT_PARTICIPATION
FOR EACH ROW
DECLARE
    the_olympic_id number;
    the_venue_olympic_id number;
    incorrect_olympic_exception EXCEPTION;
BEGIN
    SELECT olympic_id INTO the_olympic_id FROM TEAM WHERE TEAM_ID = :new.team_id;

    SELECT olympic_id INTO the_venue_olympic_id FROM VENUE WHERE VENUE_ID = (
        SELECT VENUE_ID FROM EVENT WHERE EVENT.EVENT_ID = :new.event_id
    );

    IF the_olympic_id <> the_venue_olympic_id THEN
        DBMS_OUTPUT.PUT_LINE('The event is occuring at a venue that is for a different olympics');
        RAISE incorrect_olympic_exception;
    end if;
END;

-- Ensure events occur at correct venue
CREATE OR REPLACE TRIGGER VENUE_CHECK
BEFORE INSERT OR UPDATE ON EVENT_PARTICIPATION
FOR EACH ROW
DECLARE
    the_olympic_id number;
    the_venue_id number;
    the_venue_olympic_id number;
    incorrect_olympic_exception EXCEPTION;
BEGIN
    SELECT olympic_id INTO the_olympic_id FROM TEAM WHERE TEAM_ID = :new.team_id;
    SELECT olympic_id INTO the_venue_olympic_id FROM VENUE WHERE VENUE_ID = (
        SELECT VENUE_ID INTO the_venue_id FROM EVENT WHERE EVENT.EVENT_ID = :new.event_id
    );
    IF the_olympic_id <> the_venue_olympic_id THEN
        DBMS_OUTPUT.PUT_LINE('The event is occuring at a venue that is for a different olympics');
        RAISE incorrect_olympic_exception;
    end if;
END;

-- Make sure any new scoreboard entry is for a valid team
CREATE OR REPLACE TRIGGER SCOREBOARD_ELIGIBLE_TEAM
BEFORE INSERT OR UPDATE ON SCOREBOARD
FOR EACH ROW
DECLARE
    status char;
    ineligible_team_exception EXCEPTION;
BEGIN
    SELECT status INTO status FROM EVENT_PARTICIPATION
        WHERE event_id = :new.event_id
        AND team_id = :new.team_id;
    IF status = 'n' THEN
        DBMS_OUTPUT.PUT_LINE('Team is ineligible.');
        RAISE ineligible_team_exception;
    end if;
end;

-- Set a new user's last login to the current sys timestamp
CREATE OR REPLACE TRIGGER SET_USER_LAST_LOGIN
BEFORE INSERT ON USER_ACCOUNT
FOR EACH ROW
BEGIN
    SELECT SYSDATE INTO :new.last_login FROM dual;
end;