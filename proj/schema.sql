DROP TABLE USER_ACCOUNT CASCADE CONSTRAINTS;
DROP TABLE USER_ROLE CASCADE CONSTRAINTS;
DROP TABLE OLYMPICS CASCADE CONSTRAINTS;
DROP TABLE SPORT CASCADE CONSTRAINTS;
DROP TABLE PARTICIPANT CASCADE CONSTRAINTS;
DROP TABLE COUNTRY CASCADE CONSTRAINTS;
DROP TABLE TEAM CASCADE CONSTRAINTS;
DROP TABLE TEAM_MEMBER CASCADE CONSTRAINTS;
DROP TABLE MEDAL CASCADE CONSTRAINTS;
DROP TABLE SCOREBOARD CASCADE CONSTRAINTS;
DROP TABLE VENUE CASCADE CONSTRAINTS;
DROP TABLE EVENT CASCADE CONSTRAINTS;
DROP TABLE EVENT_PARTICIPATION CASCADE CONSTRAINTS;

-- CREATE USER_ROLE TABLE
-- we have athletes login to the system using the Guest role in USER_ROLE.
CREATE TABLE USER_ROLE(
    role_id integer not null primary key,
    role_name varchar2(20)
);

-- CREATE USER_ACCOUNT TABLE
CREATE TABLE USER_ACCOUNT(
    user_id integer not null primary key,
    username varchar2(30) unique not null,
    passkey varchar2(20) not null,
    role_id integer not null,
    last_login date,

    CONSTRAINT fk_user_account_role_id FOREIGN KEY(role_id) REFERENCES USER_ROLE(role_id)
);

-- CREATE OLYMPICS TABLE
CREATE TABLE OLYMPICS(
    olympic_id integer not null primary key,
    olympic_num varchar2(30) unique,
    host_city varchar2(30),
    opening_date date,
    closing_date date,
    official_website varchar2(50),

    CHECK (closing_date > opening_date)
);

-- CREATE SPORT TABLE
CREATE TABLE SPORT(
    sport_id integer not null primary key,
    sport_name varchar2(30),
    description varchar2(80),
    dob date, -- This the date it became an olympic sport
    team_size integer
);

-- CREATE PARTICIPANT TABLE
CREATE TABLE PARTICIPANT(
    participant_id integer primary key not null,
    fname varchar2(30),
    lname varchar2(30),
    nationality varchar2(20),
    birth_place varchar2(40),
    dob date
);

-- CREATE COUNTRY TABLE
CREATE TABLE COUNTRY(
    country_id integer not null primary key,
    country varchar2(20),
    country_code varchar2(3)
);

-- CREATE TEAM TABLE
CREATE TABLE TEAM(
    team_id integer not null primary key,
    olympic_id integer,
    team_name varchar2(50),
    country_id integer,
    sport_id integer,
    coach_id integer,
    CONSTRAINT fk_team_olympic_id FOREIGN KEY (olympic_id) REFERENCES OLYMPICS(olympic_id),
    CONSTRAINT fk_team_country_id FOREIGN KEY (country_id) REFERENCES COUNTRY(country_id),
    CONSTRAINT fk_team_sport_id FOREIGN KEY (sport_id) REFERENCES SPORT(sport_id),
    CONSTRAINT fk_team_coach_id FOREIGN KEY (coach_id) REFERENCES USER_ACCOUNT(user_id)
);

-- CREATE TEAM MEMBER TABLE
CREATE TABLE TEAM_MEMBER(
    team_id integer,
    participant_id integer,
    CONSTRAINT fk_team_member_team FOREIGN KEY (team_id) REFERENCES TEAM(team_id),
    CONSTRAINT fk_team_member_participant FOREIGN KEY (participant_id) REFERENCES PARTICIPANT(participant_id),
    CONSTRAINT pk_team_member PRIMARY KEY (team_id, participant_id)
);

-- CREATE TABLE VENUE
CREATE TABLE VENUE(
    venue_id integer not null primary key,
    olympic_id integer,
    venue_name varchar2(30),
    capacity integer,
    CONSTRAINT fk_venue_olympic_id FOREIGN KEY (olympic_id) REFERENCES OLYMPICS(olympic_id)
);

-- CREATE TABLE EVENT
CREATE TABLE EVENT(
    event_id integer not null primary key,
    sport_id integer not null,
    venue_id integer not null,
    gender char not null,
    event_time date,
    CONSTRAINT fk_event_sport_id FOREIGN KEY (sport_id) REFERENCES SPORT(sport_id),
    CONSTRAINT fk_event_venue_id FOREIGN KEY (venue_id) REFERENCES VENUE(venue_id),
    CHECK (gender IN (0, 1))
);

-- CREATE EVENT_PARTICIPATION TABLE
CREATE TABLE EVENT_PARTICIPATION(
    event_id integer,
    team_id integer,
    status char,
    CHECK(status IN ('e', 'n')),
    CONSTRAINT pk_event_participation PRIMARY KEY (event_id, team_id),
    CONSTRAINT fk_event_participation_e FOREIGN KEY (event_id) REFERENCES EVENT(event_id),
    CONSTRAINT fk_event_participation_t FOREIGN KEY (team_id) REFERENCES TEAM(team_id)
);

-- CREATE MEDAL TABLE
CREATE TABLE MEDAL(
    medal_id integer not null primary key,
    medal_title varchar2(60) not null,
    points integer not null
);

-- CREATE SCOREBOARD TABLE
CREATE TABLE SCOREBOARD(
    olympic_id integer not null,
    event_id integer not null,
    team_id integer not null,
    participant_id integer not null,
    position integer,
    medal_id integer,
    CONSTRAINT pk_scoreboard PRIMARY KEY (olympic_id, event_id, team_id, participant_id),
    CONSTRAINT fk_scoreboard_olympic_id FOREIGN KEY (olympic_id) REFERENCES OLYMPICS(olympic_id),
    CONSTRAINT fk_scoreboard_event_id FOREIGN KEY (event_id) REFERENCES EVENT(event_id),
    CONSTRAINT fk_scoreboard_team_id FOREIGN KEY (team_id) REFERENCES TEAM(team_id),
    CONSTRAINT fk_scoreboard_medal_id FOREIGN KEY (medal_id) REFERENCES MEDAL(medal_id)
)