-- This file just has the queries from JDBC
-- However, I suggest looking at Driver.java for a more comphrensive
-- test.
-- I ASSUME this is only used for reference. I did not account for edge cases
-- or race conditions in this file.

-- 1. createUser
INSERT INTO USER_ACCOUNT values(null, 'rakan', 'password', 2, null);

-- 2. dropUser
DELETE FROM USER_ACCOUNT WHERE username = 'rakan';

-- 3. createEvent
INSERT INTO EVENT values(null, 1, 4, 'm', '10-AUG-2012');

-- 4. addEventOutcome (Added this delete to make insertion example easier)
DELETE  FROM SCOREBOARD WHERE OLYMPIC_ID = 3 AND EVENT_ID = 4 AND
                                TEAM_ID = 1 AND PARTICIPANT_ID = 19 AND
                                POSITION = 1;
INSERT INTO SCOREBOARD values(3, 4, 1, 19, 1, null);

-- 5. createTeam
CALL PROC_CREATE_TEAM('London', 2012, 'Team Test', 'USA', 3, 2);

-- 6. registerTeam (Added a delete to make insertion easier, not mess up the DB which too many fake values)
INSERT INTO EVENT_PARTICIPATION values(EVENT_SEQUENCE.currval, team_sequence.currval, 'e');

-- 7. addParticipant
INSERT INTO PARTICIPANT values(null, 'Daniel', 'Mosse', 'Brazil', 'Brazil', '12-AUG-10');

-- 8. addTeamMember
INSERT INTO TEAM_MEMBER values(team_sequence.currval, PARTICIPANT_SEQUENCE.currval);

-- 9. dropTeamMember (Have to do this max participant id thing to delete what was created above)
DELETE FROM PARTICIPANT WHERE PARTICIPANT_ID = (SELECT MAX(PARTICIPANT_ID) FROM PARTICIPANT);

-- 10. login
SELECT user_id, role_id, last_login FROM USER_ACCOUNT WHERE username='Hu Jintao' AND passkey='Beijing';

-- 11. displaySport
-- I specifically put more work into the display functions in the Java code to make
-- them look nicer.
select * from DISPLAY_SPORT_INFO where lower(SPORT_NAME) = lower('400m') order by OLYMPIC_YEAR, EVENT_ID, POINTS DESC;

-- 12. displayEvent
select * from DISPLAY_SPORT_INFO where event_id = 3;

-- 13. countryRanking
SELECT RANK, COUNTRY_CODE, GOLD, SILVER, BRONZE, FIRST_YEAR FROM V_COUNTRY_RANKING WHERE olympic_id = 0;

-- 14. topKAthletes
SELECT RANK, NAME, GOLD, SILVER, BRONZE FROM V_PARTICIPANTS_RANKING WHERE OLYMPIC_ID = 1 ORDER BY RANK FETCH NEXT 5 ROWS ONLY;

-- 15. connectedAthletes
SELECT DISTINCT NAME2 from V_P0_COMPETED_WITH_EACH_OTHER WHERE pid1 = 0 AND o1 = 2;

-- 16. logout
call PROC_USER_LOGOUT(3, 'Hu Jintao');