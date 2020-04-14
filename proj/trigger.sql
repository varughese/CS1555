----------------
-- Auto incrementing IDs triggers
DROP SEQUENCE user_accounts_sequence;
DROP SEQUENCE olympics_sequence;
DROP SEQUENCE sport_sequence;
DROP SEQUENCE team_sequence;
DROP SEQUENCE venue_sequence;
DROP SEQUENCE event_sequence;
DROP SEQUENCE participant_sequence;
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

CREATE OR REPLACE TRIGGER participant_sequence
  BEFORE INSERT ON PARTICIPANT
  FOR EACH ROW
BEGIN
    IF :new.PARTICIPANT_ID IS NULL THEN
        SELECT participant_sequence.nextval
        INTO :new.PARTICIPANT_ID
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
    SELECT NVL(COUNT, 0), NVL(CAPACITY, 100) INTO e_count, e_capacity
    FROM V_VENUE_COUNT
    WHERE VENUE_ID = :new.venue_id AND EVENT_TIME = :new.event_time;
    IF e_count + 1 > e_capacity THEN
        RAISE capacity_reached_exception;
    end if;
EXCEPTION
  WHEN no_data_found
  THEN
    e_count := 0;
END;

CREATE OR REPLACE VIEW V_VENUE_COUNT AS
SELECT V.VENUE_ID, EVENT_TIME, COUNT, CAPACITY
FROM (SELECT EVENT_TIME, VENUE_ID, COUNT(*) as COUNT FROM EVENT GROUP BY EVENT_TIME, VENUE_ID) VENUE_COUNT
RIGHT JOIN VENUE V on VENUE_COUNT.VENUE_ID = V.VENUE_ID;


-- Ensure a team has the correct number of players for a sporting event they participate in
CREATE OR REPLACE TRIGGER ENFORCE_TEAM_MEMBER_COUNT
    BEFORE INSERT OR UPDATE ON EVENT_PARTICIPATION
    FOR EACH ROW
DECLARE
    max_team_size number;
    current_team_size number;
    too_many_team_members exception;
BEGIN
    SELECT TEAM_SIZE into max_team_size FROM V_EVENT_TEAM_SIZE WHERE EVENT_ID = :new.event_id;
    SELECT MEMBERS into current_team_size FROM V_TEAM_CURRENT_MEMBER_COUNT WHERE TEAM_ID = :new.team_id;
    IF current_team_size - 1 > max_team_size THEN
        -- we do minus 1 since coaches count as team member but do not participate!
        raise too_many_team_members;
    end if;
end;


CREATE OR REPLACE VIEW V_EVENT_TEAM_SIZE AS
SELECT EVENT_ID, TEAM_SIZE FROM SPORT S JOIN EVENT E ON S.SPORT_ID = E.SPORT_ID;

CREATE OR REPLACE VIEW V_TEAM_CURRENT_MEMBER_COUNT AS
SELECT TEAM.TEAM_ID, COUNT(PARTICIPANT.PARTICIPANT_ID) AS MEMBERS
FROM PARTICIPANT JOIN TEAM_MEMBER ON PARTICIPANT.PARTICIPANT_ID = TEAM_MEMBER.PARTICIPANT_ID
JOIN TEAM ON TEAM_MEMBER.TEAM_ID = TEAM.TEAM_ID GROUP BY TEAM.TEAM_ID;

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

CREATE OR REPLACE PROCEDURE PROC_USER_LOGOUT(user_id_ number, username_ varchar2) AS
BEGIN
    UPDATE USER_ACCOUNT
        set LAST_LOGIN = SYSDATE
    WHERE USER_ID = user_id_ AND USERNAME = username_;
END;

CREATE OR REPLACE PROCEDURE PROC_CREATE_TEAM(
    olympic_city_ varchar2,
    olympic_year_ number,
    team_name_ varchar2,
    country_ varchar2,
    sport_ number,
    coach_id_ number) AS
    olympic_id_ number := -1;
    country_id_ number := -1;
    incorrect_inputs exception;
BEGIN
    SELECT OLYMPIC_ID INTO olympic_id_ FROM OLYMPICS WHERE lower(HOST_CITY) = lower(olympic_city_) AND EXTRACT(year FROM OPENING_DATE) = olympic_year_;
    SELECT COUNTRY_ID INTO country_id_ FROM COUNTRY WHERE lower(COUNTRY) = lower(country_) OR lower(COUNTRY_CODE) = lower(country_);

    INSERT INTO TEAM values(null, olympic_id_, team_name_, country_id_, sport_, coach_id_);
end;

-- Example: CALL PROC_CREATE_TEAM('London', 2012, 'team test', 'USA', 4, 1);

-- this gigantic join view is for displaying sports
CREATE OR REPLACE VIEW DISPLAY_SPORT_INFO AS
select SPORT_NAME, EXTRACT(year from sport.DOB) AS YEAR_ADDED, event.event_id,
       CASE
           WHEN gender = 'm' THEN 'Male'
           WHEN gender = 'f' THEN 'Female'
       END as gender,
       t.team_id,
       TEAM_NAME, FNAME || ' ' || LNAME as name,
       COUNTRY_CODE AS COUNTRY,
       UPPER(MEDAL_TITLE) AS medal,
       OLYMPIC_NUM,
       POSITION
from SPORT JOIN EVENT ON sport.sport_id = event.sport_id
JOIN SCOREBOARD ON SCOREBOARD.EVENT_ID = event.EVENT_ID
JOIN TEAM T on SCOREBOARD.TEAM_ID = T.TEAM_ID
JOIN COUNTRY C2 on T.COUNTRY_ID = C2.COUNTRY_ID
JOIN MEDAL M on SCOREBOARD.MEDAL_ID = M.MEDAL_ID
JOIN PARTICIPANT P on SCOREBOARD.PARTICIPANT_ID = P.PARTICIPANT_ID
JOIN OLYMPICS O on SCOREBOARD.OLYMPIC_ID = O.OLYMPIC_ID
WHERE POSITION <= 3
ORDER BY O.OPENING_DATE, POSITION;

------------------------------------------------------------
-- The follow views make it easier to do countryRanking()
CREATE OR REPLACE VIEW V_SCOREBOARD_WITH_COUNTRY AS
SELECT COUNTRY_ID, OLYMPIC_ID, COUNTRY_CODE, EVENT_ID, TEAM_ID, POSITION, MEDAL_ID
FROM (SELECT EVENT_ID, TEAM_ID, POSITION, MEDAL_ID
FROM SCOREBOARD GROUP BY EVENT_ID, TEAM_ID, POSITION, MEDAL_ID) S
NATURAL JOIN TEAM TEAM_ID NATURAL JOIN COUNTRY COUNTRY_ID;

CREATE OR REPLACE VIEW V_COUNTRY_FIRST_OLYMPIC_YEAR AS
SELECT COUNTRY_ID, COUNTRY_CODE, EXTRACT(YEAR FROM MIN(OPENING_DATE)) AS FIRST_YEAR FROM
V_SCOREBOARD_WITH_COUNTRY NATURAL JOIN OLYMPICS OLYMPIC_ID GROUP BY COUNTRY_ID, COUNTRY_CODE;

CREATE OR REPLACE VIEW V_COUNTRY_MEDAL_COUNT AS
-- Introduce 'Medal Count' column just so countries that won no bronze medals
-- can show 0 bronze medals when the group by occurs. We union the actual
-- results with this for that reason, as then sum on medal count. Otherwise,
-- the group by would not show a count. Then, we will have duplicate rows, like
-- USA Gold 0 and USA Gold 5, and we get rid of the duplicates country/medal rows by doing a group
-- by again. THis query took me at least 30 minutes to get right.
SELECT OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE, MEDAL_ID, MEDAL_TITLE, MAX(MEDAL_COUNT) AS MEDAL_COUNT FROM
((SELECT OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE, MEDAL_ID, MEDAL_TITLE, COUNT(*) AS MEDAL_COUNT
FROM (SELECT EVENT_ID, TEAM_ID, POSITION, MEDAL_ID
FROM SCOREBOARD GROUP BY EVENT_ID, TEAM_ID, POSITION, MEDAL_ID) S
NATURAL JOIN TEAM TEAM_ID NATURAL JOIN COUNTRY COUNTRY_ID
NATURAL JOIN MEDAL MEDAL_ID
GROUP BY OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE, MEDAL_ID, MEDAL_TITLE)
UNION
(SELECT OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE, MEDAL_ID, MEDAL_TITLE, 0 AS MEDAL_COUNT FROM OLYMPICS, COUNTRY, MEDAL))
GROUP BY OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE, MEDAL_ID, MEDAL_TITLE
ORDER BY OLYMPIC_ID, COUNTRY_CODE, MEDAL_ID;

CREATE VIEW V_COUNTRY_MEDAL_COUNT_BY_TYPE AS
SELECT DISTINCT C.OLYMPIC_ID, C.COUNTRY_CODE,
(SELECT MEDAL_COUNT FROM V_COUNTRY_MEDAL_COUNT MC
    WHERE MEDAL_TITLE='gold'
    AND MC.OLYMPIC_ID=C.OLYMPIC_ID
    AND MC.COUNTRY_ID=C.COUNTRY_ID) AS GOLD_MEDAL_COUNT,
(SELECT MEDAL_COUNT FROM V_COUNTRY_MEDAL_COUNT MC
    WHERE MEDAL_TITLE='silver'
    AND MC.OLYMPIC_ID=C.OLYMPIC_ID
    AND MC.COUNTRY_ID=C.COUNTRY_ID) AS SILVER_MEDAL_COUNT,
(SELECT MEDAL_COUNT FROM V_COUNTRY_MEDAL_COUNT MC
    WHERE MEDAL_TITLE='bronze'
    AND MC.OLYMPIC_ID=C.OLYMPIC_ID
    AND MC.COUNTRY_ID=C.COUNTRY_ID)
       AS BRONZE_MEDAL_COUNT
FROM V_COUNTRY_MEDAL_COUNT C GROUP BY OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE, MEDAL_TITLE, MEDAL_COUNT;


CREATE OR REPLACE VIEW V_COUNTRY_TOTAL_POINTS AS
SELECT OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE, SUM(MEDAL_COUNT * POINTS) AS TOTAL_POINTS
FROM V_COUNTRY_MEDAL_COUNT LEFT JOIN MEDAL M on V_COUNTRY_MEDAL_COUNT.MEDAL_ID = M.MEDAL_ID
GROUP BY OLYMPIC_ID, COUNTRY_ID, COUNTRY_CODE ORDER BY OLYMPIC_ID, TOTAL_POINTS DESC, COUNTRY_CODE;


CREATE OR REPLACE VIEW V_COUNTRY_RANKING AS
SELECT OLYMPIC_ID,
       COUNTRY_ID,
        RANK() OVER (
           -- I am using this instead of what we did in recitation for the GPA to avoid developing carpal tunnel
           -- from writing even more views for this countryRanking() function
        PARTITION BY OLYMPIC_ID
        ORDER BY TOTAL_POINTS DESC
        ) RANK,
       COUNTRY_CODE,
       GOLD_MEDAL_COUNT AS GOLD,
       SILVER_MEDAL_COUNT AS SILVER,
       BRONZE_MEDAL_COUNT AS BRONZE,
       TOTAL_POINTS AS POINTS,
       FIRST_YEAR
FROM V_COUNTRY_MEDAL_COUNT_BY_TYPE NATURAL JOIN
    V_COUNTRY_FIRST_OLYMPIC_YEAR COUNTRY_ID NATURAL JOIN
    V_COUNTRY_TOTAL_POINTS COUNTRY_ID ORDER BY OLYMPIC_ID, RANK;