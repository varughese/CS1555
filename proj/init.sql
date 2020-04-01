-- Every time that the program starts you need to initialize
-- all the above tables with sample data from the last four Olympic games (Beijing, Paris, London, Rio)
-- for 6 events (3 atomic and 3 team events) and 6 countries (which have won medals). Note that this
-- script will help you validate the integrity constraints and triggers.

INSERT INTO USER_ROLE values(1, 'Guest');
INSERT INTO USER_ROLE values(2, 'Organizer');
INSERT INTO USER_ROLE values(3, 'Coach');

INSERT INTO USER_ACCOUNT values(1, 'guest', 'GUEST', 1, null);
INSERT INTO USER_ACCOUNT values(2, 'Carlos Arthur Nuzman', 'Rio', 2, null);
INSERT INTO USER_ACCOUNT values(3, 'Gianna Angelopoulos', 'Athens', 2, null);
INSERT INTO USER_ACCOUNT values(4, 'Hu Jintao', 'Beijing', 2, null);
INSERT INTO USER_ACCOUNT values(5, 'Sebastian Coe', 'London', 2, null);

INSERT INTO OLYMPICS values(1, 'XXXI', 'Rio de Janeiro', '05-Aug-16', '21-Aug-16', 'https://www.olympic.org/rio-2016');
INSERT INTO OLYMPICS values(2, 'XXX', 'London', '27-Jul-12', '12-Aug-12', 'https://www.olympic.org/london-2012');
INSERT INTO OLYMPICS values(3, 'XXIX', 'Beijing', '08-Aug-08', '24-Aug-08', 'https://www.olympic.org/beijing-2008');
INSERT INTO OLYMPICS values(4, 'XXVIII', 'Athens', '13-Aug-04', '29-Aug-04', 'https://www.olympic.org/athens-2004');

INSERT INTO SPORT values(1, '400M Dash', 'a sprinting event around the track once', '6-Apr-1896', 1);
INSERT INTO SPORT values(2, '800M Dash', 'run two laps of the track', '6-Apr-1896', 1);
INSERT INTO SPORT values(3, '100M Dash', '100 meter run', '6-Apr-1896', 1);
INSERT INTO SPORT values(4, '4x100M Relay', 'four people sprint around the track with and pass a baton', '6-Apr-1896', 4);
INSERT INTO SPORT values(5, '4x400M Relay', 'four people do one lap around the track each', '6-Apr-1896', 4);
INSERT INTO SPORT values(6, 'Basketball', 'two teams shoot a ball into a hoop', '6-Apr-1936', 5);

INSERT INTO MEDAL (medal_id, medal_title, points) values (1, 'gold', 5);
INSERT INTO MEDAL (medal_id, medal_title, points) values (2, 'silver', 3);
INSERT INTO MEDAL (medal_id, medal_title, points) values (3, 'bronze', 1);
