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
    SELECT COUNT, CAPACITY INTO e_count, e_capacity
    FROM V_VENUE_COUNT WHERE VENUE_ID = :new.venue_id;

    IF e_count + 1 > e_capacity THEN
        RAISE capacity_reached_exception;
    end if;
END;


CREATE OR REPLACE VIEW V_VENUE_COUNT AS
SELECT V.VENUE_ID, COUNT, CAPACITY
FROM (SELECT VENUE_ID, COUNT(*) as COUNT FROM EVENT GROUP BY VENUE_ID) VENUE_COUNT
JOIN VENUE V on VENUE_COUNT.VENUE_ID = V.VENUE_ID;