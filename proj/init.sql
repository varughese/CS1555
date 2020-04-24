-- Every time that the program starts you need to initialize
-- all the above tables with sample data from the last four Olympic games (Beijing, Paris, London, Rio)
-- for 6 events (3 atomic and 3 team events) and 6 countries (which have won medals). Note that this
-- script will help you validate the integrity constraints and triggers.

-- MAKE SURE TO RUN trigger.sql BEFORE YOU RUN THIS SCRIPT! This should
-- find a trigger:
SELECT COUNT(*) FROM USER_TRIGGERS WHERE TRIGGER_NAME='USER_ACCOUNT_ID';


-- Then run all of these:

INSERT INTO USER_ROLE values(1, 'guest');
INSERT INTO USER_ROLE values(2, 'organizer');
INSERT INTO USER_ROLE values(3, 'coach');


INSERT INTO USER_ACCOUNT values(0, 'guest', 'GUEST', 1, null);
INSERT INTO USER_ACCOUNT values(1, 'Carlos Arthur Nuzman', 'Rio', 2, null);
INSERT INTO USER_ACCOUNT values(2, 'Gianna Angelopoulos', 'Athens', 2, null);
INSERT INTO USER_ACCOUNT values(3, 'Hu Jintao', 'Beijing', 2, null);
INSERT INTO USER_ACCOUNT values(4, 'Sebastian Coe', 'London', 2, null);
INSERT INTO USER_ACCOUNT values(5, 'Paul Hadzor', 'ph', 3, null);
INSERT INTO USER_ACCOUNT values(6, 'Tom Crouse', 'tc', 3, null);
INSERT INTO USER_ACCOUNT values(7, 'Nicole Jones', 'nj', 3, null);
INSERT INTO USER_ACCOUNT values(8, 'Michael Yang', 'my', 3, null);
INSERT INTO USER_ACCOUNT values(9, 'Edward Burgess', 'eb', 3, null);
INSERT INTO USER_ACCOUNT values(10, 'Andrew Li', 'al', 3, null);
INSERT INTO USER_ACCOUNT values(11, 'Bobby Eppleman', 'be ', 3, null);
INSERT INTO USER_ACCOUNT values(12, 'Tim Pappas', 'tp', 3, null);
INSERT INTO USER_ACCOUNT values(13, 'Karin Hufnagl', 'kh', 3, null);
INSERT INTO USER_ACCOUNT values(14, 'Zachary Fifer', 'zf', 3, null);

INSERT INTO OLYMPICS values(0, 'XXVIII', 'Athens', '13-Aug-04', '29-Aug-04', 'https://www.olympic.org/athens-2004');
INSERT INTO OLYMPICS values(1, 'XXIX', 'Beijing', '08-Aug-08', '24-Aug-08', 'https://www.olympic.org/beijing-2008');
INSERT INTO OLYMPICS values(2, 'XXX', 'London', '27-Jul-12', '12-Aug-12', 'https://www.olympic.org/london-2012');
INSERT INTO OLYMPICS values(3, 'XXXI', 'Rio de Janeiro', '05-Aug-16', '21-Aug-16', 'https://www.olympic.org/rio-2016');


INSERT INTO COUNTRY values(1, 'United States', 'USA');
INSERT INTO COUNTRY values(0, 'Jamaica', 'JAM');
INSERT INTO COUNTRY values(2, 'Kenya', 'KEN');
INSERT INTO COUNTRY values(3, 'Grenada', 'GRN');
INSERT INTO COUNTRY values(4, 'Trinidad and Tobago', 'TTO');
INSERT INTO COUNTRY values(7, 'Great Britian', 'GBR');
INSERT INTO COUNTRY values(21, 'Bahamas', 'BAH');
INSERT INTO COUNTRY values(6, 'Brunei', 'BRN');
INSERT INTO COUNTRY values(176, 'Sudan', 'SUD');
INSERT INTO COUNTRY values(10, 'Algeria', 'ALG');
INSERT INTO COUNTRY values(25, 'Belgium', 'BEL');
INSERT INTO COUNTRY values(70, 'France', 'FRA');
INSERT INTO COUNTRY values(5, 'Botswana', 'BOT');
INSERT INTO COUNTRY values(180, 'Sweden', 'SWE');
INSERT INTO COUNTRY values(159, 'South Africa', 'RSA');
INSERT INTO COUNTRY values(18, 'Australia', 'AUS');
INSERT INTO COUNTRY values(24, 'Burundi', 'BDI');
INSERT INTO COUNTRY values(96, 'Italy', 'ITA');
INSERT INTO COUNTRY values(33, 'Brazil', 'BRA');
INSERT INTO COUNTRY values(39, 'Canada', 'CAN');
INSERT INTO COUNTRY values(54, 'Cuba', 'CUB');
INSERT INTO COUNTRY values(57, 'Denmark', 'DEN');
INSERT INTO COUNTRY values(60, 'Dominican Republic', 'DOM');


INSERT INTO SPORT values(0, '200M', 'Run 200 meters across the track', '06-Apr-1896', 1);
INSERT INTO SPORT values(1, '400M', 'Run 400 meters across the track', '06-Apr-1896', 1);
INSERT INTO SPORT values(2, '800M', 'Run two laps across the track', '06-Apr-1896', 1);
INSERT INTO SPORT values(3, '100M', 'Run 100 meters on the track', '06-Apr-1896', 1);
INSERT INTO SPORT values(4, '4x1', 'A relay, where people pass a baton', '06-Apr-1896', 4);
INSERT INTO SPORT values(5, '4x4', 'A relay, where people complete a mile in total', '06-Apr-1896', 4);
INSERT INTO SPORT values(6, 'Basketball', 'A game where people shoot a ball into a hoop', '06-Apr-1936', 5);


INSERT INTO VENUE values(0, 0, 'Olympic Stadium of Athens', 4);
INSERT INTO VENUE values(1, 0, 'Hellinikon Indoor Arena', 1);
INSERT INTO VENUE values(2, 1, 'Beijing National Stadium', 4);
INSERT INTO VENUE values(3, 1, 'Wukesong Indoor Stadium', 1);
INSERT INTO VENUE values(4, 2, 'London Stadium', 4);
INSERT INTO VENUE values(5, 2, 'Basketball Arena', 1);
INSERT INTO VENUE values(6, 3, 'Estadio Olimpico Nilton Santos', 4);
INSERT INTO VENUE values(7, 3, 'Caropica Arena 1', 1);


INSERT INTO EVENT values(0, 1, 0, 'm', '17-Aug-04');
INSERT INTO EVENT values(1, 2, 2, 'f', '20-Aug-08');
INSERT INTO EVENT values(2, 3, 4, 'm', '10-Aug-12');
INSERT INTO EVENT values(3, 4, 6, 'f', '20-Aug-16');
INSERT INTO EVENT values(4, 5, 6, 'm', '20-Aug-16');
INSERT INTO EVENT values(5, 6, 7, 'm', '10-Aug-12');
INSERT INTO EVENT values(6, 1, 6, 'm', '23-Aug-16');
INSERT INTO EVENT values(7, 1, 4, 'm', '10-Aug-12');
INSERT INTO EVENT values(8, 1, 2, 'm', '18-Aug-08');
INSERT INTO EVENT values(9, 1, 0, 'm', '28-Aug-04');
INSERT INTO EVENT values(10, 2, 0, 'm', '27-Aug-04');
INSERT INTO EVENT values(11, 2, 2, 'm', '15-Aug-08');
INSERT INTO EVENT values(12, 2, 4, 'm', '11-Aug-12');
INSERT INTO EVENT values(13, 2, 6, 'm', '16-Aug-16');


INSERT INTO MEDAL values(1, 'gold', 5);
INSERT INTO MEDAL values(2, 'silver', 3);
INSERT INTO MEDAL values(3, 'bronze', 1);


INSERT INTO PARTICIPANT values(0, 'Usain', 'Bolt', 'Jamaican', 'Sherwood Content', '21-Aug-86');
INSERT INTO PARTICIPANT values(1, 'Yohan', 'Blake', 'Jamaican', 'St. James', '26-Dec-89');
INSERT INTO PARTICIPANT values(2, 'Justin', 'Gatlin', 'American', 'Brooklyn', '10-Feb-82');
INSERT INTO PARTICIPANT values(3, 'Tyson ', 'Gay', 'American', 'Lexington', '09-Aug-82');
INSERT INTO PARTICIPANT values(4, 'Ryan ', 'Bailey', 'American', 'Portland', '13-Apr-89');
INSERT INTO PARTICIPANT values(5, 'Pamela ', 'Jelimo', 'Kenyan', 'Nandi District', '05-Dec-89');
INSERT INTO PARTICIPANT values(6, 'Jeremy', 'Wariner', 'American', 'McKinney', '31-Jan-84');
INSERT INTO PARTICIPANT values(7, 'Kevin', 'Durant', 'American', 'Washington DC', '29-Sep-88');
INSERT INTO PARTICIPANT values(8, 'Carmelo', 'Anthony', 'American', 'Brooklyn', '29-May-84');
INSERT INTO PARTICIPANT values(9, 'Kyrie', 'Irving', 'American', 'Melbourne', '23-Mar-92');
INSERT INTO PARTICIPANT values(10, 'Klay', 'Thompson', 'American', 'Los Angeles', '08-Feb-90');
INSERT INTO PARTICIPANT values(11, 'Demarcus', 'Cousins', 'American', 'Mobile', '13-Aug-90');
INSERT INTO PARTICIPANT values(12, 'Allyson', 'Felix', 'American', 'Los Angeles', '18-Nov-85');
INSERT INTO PARTICIPANT values(13, 'English', 'Gardner', 'American', 'Philadelphia', '22-Apr-92');
INSERT INTO PARTICIPANT values(14, 'Tianna', 'Bartoletta', 'American', 'Elyria', '30-Aug-85');
INSERT INTO PARTICIPANT values(15, 'Tori', 'Bowie', 'American', 'Sand Hill', '27-Aug-90');
INSERT INTO PARTICIPANT values(16, 'Lashawn', 'Merritt', 'American', 'Portsmouth', '27-Jun-86');
INSERT INTO PARTICIPANT values(17, 'Gil', 'Roberts', 'American', 'Oklahoma City', '15-Mar-89');
INSERT INTO PARTICIPANT values(18, 'Tony ', 'McQuay', 'American ', 'West Palm Beach', '16-Apr-90');
INSERT INTO PARTICIPANT values(19, 'Arman', 'Hall', 'American', 'Gainesville', '12-Feb-94');
INSERT INTO PARTICIPANT values(20, 'Paul', 'Hadzor', 'Jamaican', 'Pittsburgh', '06-Feb-60');
INSERT INTO PARTICIPANT values(21, 'Tom ', 'Crouse', 'American', 'Philadelphia', '17-Sep-75');
INSERT INTO PARTICIPANT values(22, 'Nicole', 'Jones', 'American', 'Malvern', '22-Nov-72');
INSERT INTO PARTICIPANT values(23, 'Michael', 'Yang', 'American', 'Paoli', '05-Jul-95');
INSERT INTO PARTICIPANT values(24, 'Edward', 'Burgess', 'American', 'Bryn Mawr', '26-Jun-92');
INSERT INTO PARTICIPANT values(25, 'Andrew', 'Li', 'American', 'Exton', '15-Aug-90');
INSERT INTO PARTICIPANT values(26, 'Bobby ', 'Eppleman', 'American', 'King of Prussia', '21-Feb-87');
INSERT INTO PARTICIPANT values(27, 'Tim', 'Pappas', 'American', 'Philadelphia', '13-Jan-80');
INSERT INTO PARTICIPANT values(28, 'Karin', 'Hufnagl', 'American', 'Glen Mills', '21-Mar-75');
INSERT INTO PARTICIPANT values(29, 'Zachary', 'Fifer', 'American', 'Newtown Square', '11-Jan-85');
INSERT INTO PARTICIPANT values(30, 'Wayde', 'Van Niekerk', 'South African', 'Cape Town  ', '15-Jul-92');
INSERT INTO PARTICIPANT values(31, 'Kirani', 'James', 'Grenada', 'Gouyave', '01-Sep-92');
INSERT INTO PARTICIPANT values(32, 'Machel', 'Cedenio', 'Trinidad', 'San Fernado', '06-Sep-95');
INSERT INTO PARTICIPANT values(33, 'Karabo', 'Sibanda', 'Botswana', 'Francistown', '02-Jul-98');
INSERT INTO PARTICIPANT values(34, 'Ali Khamis', 'Khamis', 'Bahrain', 'Manama', '30-Jun-95');
INSERT INTO PARTICIPANT values(35, 'Bralon', 'Taplin', 'Grenada', 'St. Georges', '08-May-92');
INSERT INTO PARTICIPANT values(36, 'Matthew', 'Hudson-Smith', 'Britsih', 'Wolverhampton', '26-Oct-94');
INSERT INTO PARTICIPANT values(37, 'Brianna', 'Bismark-Petit', 'South African', 'Cape Town  ', '02-Feb-50');
INSERT INTO PARTICIPANT values(38, 'Alex', 'Siaton', 'American', 'Philadelphia', '24-Jan-51');
INSERT INTO PARTICIPANT values(39, 'Luke', 'Lasure', 'Great Britain', 'London', '12-Nov-86');
INSERT INTO PARTICIPANT values(40, 'Emma ', 'Iacobucci', 'American', 'Madison', '24-Jan-51');
INSERT INTO PARTICIPANT values(41, 'Nate', 'Beebe', 'American', 'San Antonio', '22-May-52');
INSERT INTO PARTICIPANT values(42, 'Shane ', 'Johnston', 'American', 'Miami', '01-Jul-53');
INSERT INTO PARTICIPANT values(43, 'Katie', 'Ford', 'American', 'Tucson', '12-Jun-57');
INSERT INTO PARTICIPANT values(44, 'Jack', 'Barron', 'American', 'Honolulu', '01-Nov-60');
INSERT INTO PARTICIPANT values(45, 'Luguelin', 'Santos', 'Dominican', 'Monte Plata', '12-Nov-92');
INSERT INTO PARTICIPANT values(46, 'Lalonde', 'Gordon', 'Trinidad', 'Lowlands', '25-Nov-88');
INSERT INTO PARTICIPANT values(47, 'Chris', 'Brown', 'Bahamian', 'Eleuthera', '15-Oct-78');
INSERT INTO PARTICIPANT values(48, 'Kevin', 'Borlee', 'Belgian', 'Woluwe-Saint-Lambert', '22-Feb-88');
INSERT INTO PARTICIPANT values(49, 'Jonathan', 'Borlee', 'Belgian', 'Woluwe-Saint-Lambert', '22-Feb-88');
INSERT INTO PARTICIPANT values(50, 'Demetrius', 'Pinder', 'Bahamian', 'Grand Bahama', '13-Feb-89');
INSERT INTO PARTICIPANT values(51, 'Steven', 'Solomon', 'Australian', 'Vacluse', '16-May-93');
INSERT INTO PARTICIPANT values(52, 'Eric ', 'Wang', 'American', 'Toledo', '15-Aug-65');
INSERT INTO PARTICIPANT values(53, 'Brett', 'Zatlin', 'American', 'Norfolk', '05-Sep-60');
INSERT INTO PARTICIPANT values(54, 'Joe', 'Ellis', 'American', 'Aurora', '11-Feb-67');
INSERT INTO PARTICIPANT values(55, 'Ben ', 'Walsh', 'American', 'Boston', '12-Feb-67');
INSERT INTO PARTICIPANT values(56, 'Blair', 'Barstar', 'American', 'North Hempstead', '26-Nov-67');
INSERT INTO PARTICIPANT values(57, 'Andrew ', 'Schuck', 'American', 'Chesapeake', '30-Aug-71');
INSERT INTO PARTICIPANT values(58, 'Thomas', 'Brisbane', 'American', 'New Orleans', '05-May-72');
INSERT INTO PARTICIPANT values(59, 'Elise', 'Claffey', 'American', 'Toledo', '22-Sep-73');
INSERT INTO PARTICIPANT values(60, 'Leslie', 'Djhone', 'French', 'Abidjan', '18-Mar-81');
INSERT INTO PARTICIPANT values(61, 'Martyn', 'Rooney', 'British', 'Croydon', '03-Apr-87');
INSERT INTO PARTICIPANT values(62, 'Renny', 'Quow', 'Trinidad', 'Tobago', '25-Aug-87');
INSERT INTO PARTICIPANT values(63, 'Johan', 'Wissman', 'Swedish', 'Helsingborg', '02-Nov-82');
INSERT INTO PARTICIPANT values(64, 'David', 'Neville', 'American', 'Merrillville', '01-Jun-84');
INSERT INTO PARTICIPANT values(65, 'Sarah', 'Merriwether', 'American', 'Fort Wayne', '22-Sep-73');
INSERT INTO PARTICIPANT values(66, 'Mia', 'Cheslock', 'American', 'Chandler', '15-Dec-73');
INSERT INTO PARTICIPANT values(67, 'Kevin', 'Raftery', 'American', 'Stockton', '12-Mar-75');
INSERT INTO PARTICIPANT values(68, 'Josh', 'Spiess', 'American', 'Henderson', '21-Aug-77');
INSERT INTO PARTICIPANT values(69, 'Crosby', 'Spiess', 'American', 'Anaheim', '05-Sep-60');
INSERT INTO PARTICIPANT values(70, 'Pokemon', 'Gordon', 'American', 'Pittsburgh', '10-Apr-42');
INSERT INTO PARTICIPANT values(71, 'Otis', 'Harris', 'American', 'Edwards', '30-Jun-82');
INSERT INTO PARTICIPANT values(72, 'Derrick', 'Brew', 'American', 'Houston', '28-Dec-77');
INSERT INTO PARTICIPANT values(73, 'Alleyne', 'Francique', 'Grenada', 'St. Andrews', '07-Jun-76');
INSERT INTO PARTICIPANT values(74, 'Brandon', 'Simpson', 'Jamaican', 'Kingston', '06-Sep-81');
INSERT INTO PARTICIPANT values(75, 'Davian', 'Clarke', 'Jamican', 'Kingston', '30-Apr-76');
INSERT INTO PARTICIPANT values(76, 'Michael', 'Blackwood', 'Jamaican', 'Clarendon', '29-Aug-76');
INSERT INTO PARTICIPANT values(77, 'Lucy', 'Pepperman', 'American', 'Nashville', '21-Aug-77');
INSERT INTO PARTICIPANT values(78, 'Jack', 'Pepperman', 'American', 'Hialeah', '28-May-81');
INSERT INTO PARTICIPANT values(79, 'Gillian', 'Iacobucci', 'American', 'Chicago', '16-Oct-87');
INSERT INTO PARTICIPANT values(80, 'Emma ', 'Gray', 'American', 'Kansas City', '08-Jun-88');
INSERT INTO PARTICIPANT values(81, 'Veronica', 'Yonce', 'American', 'Anchorage', '16-May-92');
INSERT INTO PARTICIPANT values(82, 'Caroline', 'Duvivier', 'American', 'Riverside', '16-Jul-94');
INSERT INTO PARTICIPANT values(83, 'Wilson', 'Kipketer', 'Danish', 'Kapchemoiywo', '12-Dec-72');
INSERT INTO PARTICIPANT values(84, 'Ismail', 'Ismail', 'Sudanese', 'Khartoum', '01-Nov-84');
INSERT INTO PARTICIPANT values(85, 'Joseph', 'Mutua', 'Kenyan', 'Machakos', '10-Dec-78');
INSERT INTO PARTICIPANT values(86, 'Andrea', 'Longo', 'Italian', 'Piove di Sacco', '26-Jun-75');
INSERT INTO PARTICIPANT values(87, 'Jean Patrick', 'Nduwimana', 'Burundi', 'Bujumbura', '09-May-78');
INSERT INTO PARTICIPANT values(88, 'Ricky', 'Soos', 'English', 'Mansfield', '28-Jun-83');
INSERT INTO PARTICIPANT values(89, 'Osmar', 'Dos Santos', 'Brazilian', 'Marilia', '20-Oct-68');
INSERT INTO PARTICIPANT values(90, 'Jonathan', 'Johnson', 'American', 'Exton', '05-Mar-82');
INSERT INTO PARTICIPANT values(91, 'Stefanie', 'Schwab', 'American', 'Fresno', '19-Jun-61');
INSERT INTO PARTICIPANT values(92, 'Nikki', 'Pennington', 'American', 'Milwaukee', '21-Jan-64');
INSERT INTO PARTICIPANT values(93, 'Nick', 'Cionci', 'American', 'Lincoln', '25-Aug-69');
INSERT INTO PARTICIPANT values(94, 'Hayden', 'Coates', 'American', 'Jersey City', '21-May-75');
INSERT INTO PARTICIPANT values(95, 'Seth', 'Hoffritz', 'American', 'Phoenix', '06-Mar-77');
INSERT INTO PARTICIPANT values(96, 'Kevin', 'Babb', 'American', 'Fort Wayne', '22-May-80');
INSERT INTO PARTICIPANT values(97, 'Nate', 'Stahl', 'American', 'Charlotte', '12-Feb-81');
INSERT INTO PARTICIPANT values(98, 'Roman', 'Silen', 'American', 'Memphis', '30-Aug-85');
INSERT INTO PARTICIPANT values(99, 'Wilfred', 'Bungei', 'Kenyan', 'Kabirirsang', '24-Jul-80');
INSERT INTO PARTICIPANT values(100, 'Alfred', 'Yego', 'Kenyan', 'Eldoret', '28-Nov-86');
INSERT INTO PARTICIPANT values(101, 'Gary', 'Reed', 'Canadian', 'Toronto', '25-Oct-81');
INSERT INTO PARTICIPANT values(102, 'Yusuf', 'Kamel', 'Bahrain', 'Narok', '29-Mar-83');
INSERT INTO PARTICIPANT values(103, 'Yeimer', 'Lopez', 'Cuba', 'Buey Arriba', '28-Aug-82');
INSERT INTO PARTICIPANT values(104, 'Nabil', 'Madi', 'Algerian', 'Algiers', '09-Jun-81');
INSERT INTO PARTICIPANT values(105, 'Nadjim', 'Manseur', 'Algerian', 'Bejaia', '08-Jun-88');
INSERT INTO PARTICIPANT values(106, 'Max ', 'Miller', 'American', 'Birmingham', '05-Sep-45');
INSERT INTO PARTICIPANT values(107, 'Pierce ', 'Nolan', 'American', 'Baltimore', '21-Nov-63');
INSERT INTO PARTICIPANT values(108, 'Mike', 'Miller', 'American', 'Dallas', '22-Oct-70');
INSERT INTO PARTICIPANT values(109, 'Ean', 'Chasinoff', 'American', 'Rochester', '18-Mar-71');
INSERT INTO PARTICIPANT values(110, 'Kaya', 'Alber', 'American', 'Tampa', '02-Oct-71');
INSERT INTO PARTICIPANT values(111, 'Katie', 'Kirsch', 'American', 'Baton Rouge', '04-Jun-76');
INSERT INTO PARTICIPANT values(112, 'Geoffrey', 'Barratt', 'American', 'Plano', '28-Jul-80');
INSERT INTO PARTICIPANT values(113, 'Justin', 'Zupito', 'American', 'Bakersfield', '07-Jun-00');


INSERT INTO TEAM values(0, 3, 'USA 4x1', 1, 4, 24);
INSERT INTO TEAM values(1, 3, 'USA 4x4', 1, 5, 25);
INSERT INTO TEAM values(2, 3, 'USA Mens BBall', 1, 6, 21);
INSERT INTO TEAM values(3, 0, 'Team Wariner', 1, 1, 23);
INSERT INTO TEAM values(4, 1, 'Team Jelimo', 2, 2, 22);
INSERT INTO TEAM values(5, 2, 'Team Bolt', 0, 3, 20);
INSERT INTO TEAM values(6, 2, 'Team Blake', 0, 3, 26);
INSERT INTO TEAM values(7, 2, 'Team Gatlin', 1, 3, 27);
INSERT INTO TEAM values(8, 2, 'Team Gay', 1, 3, 28);
INSERT INTO TEAM values(9, 2, 'Team Bailey', 1, 3, 29);
INSERT INTO TEAM values(10, 3, 'Team Van Niekerk', 159, 1, 37);
INSERT INTO TEAM values(11, 3, 'Team James', 3, 1, 38);
INSERT INTO TEAM values(12, 3, 'Team Merrit', 1, 1, 39);
INSERT INTO TEAM values(13, 3, 'Team Cedenio', 4, 1, 40);
INSERT INTO TEAM values(14, 3, 'Team Sibanda', 5, 1, 41);
INSERT INTO TEAM values(15, 3, 'Team Khamis', 6, 1, 42);
INSERT INTO TEAM values(16, 3, 'Team Taplin', 3, 1, 43);
INSERT INTO TEAM values(17, 3, 'Team Hudson-Smith', 7, 1, 44);
INSERT INTO TEAM values(18, 2, 'Team Kirani', 3, 1, 52);
INSERT INTO TEAM values(19, 2, 'Team Santos', 60, 1, 53);
INSERT INTO TEAM values(20, 2, 'Team Gordon', 4, 1, 54);
INSERT INTO TEAM values(21, 2, 'Team Brown', 21, 1, 55);
INSERT INTO TEAM values(22, 2, 'Team Borlee', 25, 1, 56);
INSERT INTO TEAM values(23, 2, 'Team Borlee', 25, 1, 57);
INSERT INTO TEAM values(24, 2, 'Team Pinder', 21, 1, 58);
INSERT INTO TEAM values(25, 2, 'Team Solomon', 18, 1, 59);
INSERT INTO TEAM values(26, 1, 'Team Merritt', 1, 1, 66);
INSERT INTO TEAM values(27, 1, 'Team Wariner', 1, 1, 23);
INSERT INTO TEAM values(28, 1, 'Team Neville', 1, 1, 65);
INSERT INTO TEAM values(29, 1, 'Team Brown', 21, 1, 55);
INSERT INTO TEAM values(30, 1, 'Team Djhone', 70, 1, 70);
INSERT INTO TEAM values(31, 1, 'Team Roony', 7, 1, 67);
INSERT INTO TEAM values(32, 1, 'Team Quow', 4, 1, 68);
INSERT INTO TEAM values(33, 1, 'Team Wissman', 180, 1, 69);
INSERT INTO TEAM values(34, 0, 'Team Wariner', 1, 1, 23);
INSERT INTO TEAM values(35, 0, 'Team Harris', 1, 1, 77);
INSERT INTO TEAM values(36, 0, 'Team Brew', 1, 1, 78);
INSERT INTO TEAM values(37, 0, 'Team Francique', 3, 1, 79);
INSERT INTO TEAM values(38, 0, 'Team Simpson', 0, 1, 80);
INSERT INTO TEAM values(39, 0, 'Team Clarke', 0, 1, 81);
INSERT INTO TEAM values(40, 0, 'Team Djhone', 70, 1, 70);
INSERT INTO TEAM values(41, 0, 'Team Blackwood', 0, 1, 82);
INSERT INTO TEAM values(42, 0, 'Team Kipketer', 57, 2, 91);
INSERT INTO TEAM values(43, 0, 'Team Ismail', 176, 2, 92);
INSERT INTO TEAM values(44, 0, 'Team Mutua', 2, 2, 93);
INSERT INTO TEAM values(45, 0, 'Team Longo', 96, 2, 94);
INSERT INTO TEAM values(46, 0, 'Team Nduwimana', 24, 2, 95);
INSERT INTO TEAM values(47, 0, 'Team Soos', 7, 2, 96);
INSERT INTO TEAM values(48, 0, 'Team Dos Santos', 33, 2, 97);
INSERT INTO TEAM values(49, 0, 'Team Johnson', 1, 2, 98);
INSERT INTO TEAM values(50, 1, 'Team Bungei', 2, 2, 106);
INSERT INTO TEAM values(51, 1, 'Team Ismail', 176, 2, 107);
INSERT INTO TEAM values(52, 1, 'Team Yego', 2, 2, 108);
INSERT INTO TEAM values(53, 1, 'Team Reed', 39, 2, 109);
INSERT INTO TEAM values(54, 1, 'Team Kamel', 6, 2, 110);
INSERT INTO TEAM values(55, 1, 'Team Lopez', 54, 2, 111);
INSERT INTO TEAM values(56, 1, 'Team Madi', 10, 2, 112);
INSERT INTO TEAM values(57, 1, 'Team Manseur', 10, 2, 113);


INSERT INTO TEAM_MEMBER values(0, 12);
INSERT INTO TEAM_MEMBER values(0, 13);
INSERT INTO TEAM_MEMBER values(0, 14);
INSERT INTO TEAM_MEMBER values(0, 15);
INSERT INTO TEAM_MEMBER values(0, 24);
INSERT INTO TEAM_MEMBER values(1, 16);
INSERT INTO TEAM_MEMBER values(1, 17);
INSERT INTO TEAM_MEMBER values(1, 18);
INSERT INTO TEAM_MEMBER values(1, 19);
INSERT INTO TEAM_MEMBER values(1, 25);
INSERT INTO TEAM_MEMBER values(2, 7);
INSERT INTO TEAM_MEMBER values(2, 8);
INSERT INTO TEAM_MEMBER values(2, 9);
INSERT INTO TEAM_MEMBER values(2, 10);
INSERT INTO TEAM_MEMBER values(2, 11);
INSERT INTO TEAM_MEMBER values(2, 21);
INSERT INTO TEAM_MEMBER values(3, 6);
INSERT INTO TEAM_MEMBER values(3, 23);
INSERT INTO TEAM_MEMBER values(4, 5);
INSERT INTO TEAM_MEMBER values(4, 22);
INSERT INTO TEAM_MEMBER values(5, 0);
INSERT INTO TEAM_MEMBER values(5, 20);
INSERT INTO TEAM_MEMBER values(6, 1);
INSERT INTO TEAM_MEMBER values(6, 26);
INSERT INTO TEAM_MEMBER values(7, 2);
INSERT INTO TEAM_MEMBER values(7, 27);
INSERT INTO TEAM_MEMBER values(8, 3);
INSERT INTO TEAM_MEMBER values(8, 28);
INSERT INTO TEAM_MEMBER values(9, 4);
INSERT INTO TEAM_MEMBER values(9, 29);
INSERT INTO TEAM_MEMBER values(10, 30);
INSERT INTO TEAM_MEMBER values(11, 31);
INSERT INTO TEAM_MEMBER values(12, 16);
INSERT INTO TEAM_MEMBER values(13, 32);
INSERT INTO TEAM_MEMBER values(14, 33);
INSERT INTO TEAM_MEMBER values(15, 34);
INSERT INTO TEAM_MEMBER values(16, 35);
INSERT INTO TEAM_MEMBER values(17, 36);
INSERT INTO TEAM_MEMBER values(18, 31);
INSERT INTO TEAM_MEMBER values(19, 45);
INSERT INTO TEAM_MEMBER values(20, 46);
INSERT INTO TEAM_MEMBER values(21, 47);
INSERT INTO TEAM_MEMBER values(22, 48);
INSERT INTO TEAM_MEMBER values(23, 49);
INSERT INTO TEAM_MEMBER values(24, 50);
INSERT INTO TEAM_MEMBER values(25, 51);
INSERT INTO TEAM_MEMBER values(26, 16);
INSERT INTO TEAM_MEMBER values(27, 6);
INSERT INTO TEAM_MEMBER values(28, 64);
INSERT INTO TEAM_MEMBER values(29, 47);
INSERT INTO TEAM_MEMBER values(30, 60);
INSERT INTO TEAM_MEMBER values(31, 61);
INSERT INTO TEAM_MEMBER values(32, 62);
INSERT INTO TEAM_MEMBER values(33, 63);
INSERT INTO TEAM_MEMBER values(34, 6);
INSERT INTO TEAM_MEMBER values(35, 71);
INSERT INTO TEAM_MEMBER values(36, 72);
INSERT INTO TEAM_MEMBER values(37, 73);
INSERT INTO TEAM_MEMBER values(38, 74);
INSERT INTO TEAM_MEMBER values(39, 75);
INSERT INTO TEAM_MEMBER values(40, 60);
INSERT INTO TEAM_MEMBER values(41, 76);
INSERT INTO TEAM_MEMBER values(42, 83);
INSERT INTO TEAM_MEMBER values(43, 84);
INSERT INTO TEAM_MEMBER values(44, 85);
INSERT INTO TEAM_MEMBER values(45, 86);
INSERT INTO TEAM_MEMBER values(46, 87);
INSERT INTO TEAM_MEMBER values(47, 88);
INSERT INTO TEAM_MEMBER values(48, 89);
INSERT INTO TEAM_MEMBER values(49, 90);
INSERT INTO TEAM_MEMBER values(50, 99);
INSERT INTO TEAM_MEMBER values(51, 84);
INSERT INTO TEAM_MEMBER values(52, 100);
INSERT INTO TEAM_MEMBER values(53, 101);
INSERT INTO TEAM_MEMBER values(54, 102);
INSERT INTO TEAM_MEMBER values(55, 103);
INSERT INTO TEAM_MEMBER values(56, 104);
INSERT INTO TEAM_MEMBER values(57, 105);


INSERT INTO EVENT_PARTICIPATION values(4, 1, 'e');
INSERT INTO EVENT_PARTICIPATION values(5, 2, 'e');
INSERT INTO EVENT_PARTICIPATION values(1, 4, 'e');
INSERT INTO EVENT_PARTICIPATION values(3, 0, 'e');
INSERT INTO EVENT_PARTICIPATION values(2, 5, 'e');
INSERT INTO EVENT_PARTICIPATION values(2, 6, 'e');
INSERT INTO EVENT_PARTICIPATION values(2, 7, 'e');
INSERT INTO EVENT_PARTICIPATION values(2, 8, 'e');
INSERT INTO EVENT_PARTICIPATION values(2, 9, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 10, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 11, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 12, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 13, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 14, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 15, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 16, 'e');
INSERT INTO EVENT_PARTICIPATION values(6, 17, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 18, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 19, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 20, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 21, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 22, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 23, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 24, 'e');
INSERT INTO EVENT_PARTICIPATION values(7, 25, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 26, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 27, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 28, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 29, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 30, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 31, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 32, 'e');
INSERT INTO EVENT_PARTICIPATION values(8, 33, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 34, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 35, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 36, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 37, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 38, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 39, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 40, 'e');
INSERT INTO EVENT_PARTICIPATION values(9, 41, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 42, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 43, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 44, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 45, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 46, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 47, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 48, 'e');
INSERT INTO EVENT_PARTICIPATION values(10, 49, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 50, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 51, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 52, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 53, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 54, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 55, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 56, 'e');
INSERT INTO EVENT_PARTICIPATION values(11, 57, 'e');


INSERT INTO SCOREBOARD values(0, 9, 34, 6, 1, 1);
INSERT INTO SCOREBOARD values(0, 9, 35, 71, 2, 2);
INSERT INTO SCOREBOARD values(0, 9, 36, 72, 3, 3);
INSERT INTO SCOREBOARD values(0, 9, 37, 73, 4, null);
INSERT INTO SCOREBOARD values(0, 9, 38, 74, 5, null);
INSERT INTO SCOREBOARD values(0, 9, 39, 75, 6, null);
INSERT INTO SCOREBOARD values(0, 9, 40, 60, 7, null);
INSERT INTO SCOREBOARD values(0, 9, 41, 76, 8, null);
INSERT INTO SCOREBOARD values(1, 8, 26, 16, 1, 1);
INSERT INTO SCOREBOARD values(1, 8, 27, 6, 2, 2);
INSERT INTO SCOREBOARD values(1, 8, 28, 64, 3, 3);
INSERT INTO SCOREBOARD values(1, 8, 29, 47, 4, null);
INSERT INTO SCOREBOARD values(1, 8, 30, 60, 5, null);
INSERT INTO SCOREBOARD values(1, 8, 31, 61, 6, null);
INSERT INTO SCOREBOARD values(1, 8, 32, 62, 7, null);
INSERT INTO SCOREBOARD values(1, 8, 33, 63, 8, null);
INSERT INTO SCOREBOARD values(2, 7, 18, 31, 1, 1);
INSERT INTO SCOREBOARD values(2, 7, 19, 45, 2, 2);
INSERT INTO SCOREBOARD values(2, 7, 20, 46, 3, 3);
INSERT INTO SCOREBOARD values(2, 7, 21, 47, 4, null);
INSERT INTO SCOREBOARD values(2, 7, 22, 48, 5, null);
INSERT INTO SCOREBOARD values(2, 7, 23, 49, 6, null);
INSERT INTO SCOREBOARD values(2, 7, 24, 50, 7, null);
INSERT INTO SCOREBOARD values(2, 7, 25, 51, 8, null);
INSERT INTO SCOREBOARD values(3, 6, 10, 30, 1, 1);
INSERT INTO SCOREBOARD values(3, 6, 11, 31, 2, 2);
INSERT INTO SCOREBOARD values(3, 6, 12, 16, 3, 3);
INSERT INTO SCOREBOARD values(3, 6, 13, 32, 4, null);
INSERT INTO SCOREBOARD values(3, 6, 14, 33, 5, null);
INSERT INTO SCOREBOARD values(3, 6, 15, 34, 6, null);
INSERT INTO SCOREBOARD values(3, 6, 16, 35, 7, null);
INSERT INTO SCOREBOARD values(3, 6, 17, 36, 8, null);
INSERT INTO SCOREBOARD values(0, 10, 42, 83, 1, 1);
INSERT INTO SCOREBOARD values(0, 10, 43, 84, 2, 2);
INSERT INTO SCOREBOARD values(0, 10, 44, 85, 3, 3);
INSERT INTO SCOREBOARD values(0, 10, 45, 86, 4, null);
INSERT INTO SCOREBOARD values(0, 10, 46, 87, 5, null);
INSERT INTO SCOREBOARD values(0, 10, 47, 88, 6, null);
INSERT INTO SCOREBOARD values(0, 10, 48, 89, 7, null);
INSERT INTO SCOREBOARD values(0, 10, 49, 90, 8, null);
INSERT INTO SCOREBOARD values(1, 11, 50, 99, 1, 1);
INSERT INTO SCOREBOARD values(1, 11, 51, 84, 2, 2);
INSERT INTO SCOREBOARD values(1, 11, 52, 100, 3, 3);
INSERT INTO SCOREBOARD values(1, 11, 53, 101, 4, null);
INSERT INTO SCOREBOARD values(1, 11, 54, 102, 5, null);
INSERT INTO SCOREBOARD values(1, 11, 55, 103, 6, null);
INSERT INTO SCOREBOARD values(1, 11, 56, 104, 7, null);
INSERT INTO SCOREBOARD values(1, 11, 57, 105, 8, null);
INSERT INTO SCOREBOARD values(1, 1, 4, 5, 1, 1);
INSERT INTO SCOREBOARD values(2, 2, 5, 0, 1, 1);
INSERT INTO SCOREBOARD values(2, 2, 6, 1, 2, 2);
INSERT INTO SCOREBOARD values(2, 2, 7, 2, 3, 3);
INSERT INTO SCOREBOARD values(2, 2, 8, 3, 4, null);
INSERT INTO SCOREBOARD values(2, 2, 9, 4, 5, null);
INSERT INTO SCOREBOARD values(3, 5, 2, 7, 1, 1);
INSERT INTO SCOREBOARD values(3, 5, 2, 8, 1, 1);
INSERT INTO SCOREBOARD values(3, 5, 2, 9, 1, 1);
INSERT INTO SCOREBOARD values(3, 5, 2, 10, 1, 1);
INSERT INTO SCOREBOARD values(3, 5, 2, 11, 1, 1);
INSERT INTO SCOREBOARD values(3, 3, 0, 12, 1, 1);
INSERT INTO SCOREBOARD values(3, 3, 0, 13, 1, 1);
INSERT INTO SCOREBOARD values(3, 3, 0, 14, 1, 1);
INSERT INTO SCOREBOARD values(3, 3, 0, 15, 1, 1);
INSERT INTO SCOREBOARD values(3, 4, 1, 16, 1, 1);
INSERT INTO SCOREBOARD values(3, 4, 1, 17, 1, 1);
INSERT INTO SCOREBOARD values(3, 4, 1, 18, 1, 1);
INSERT INTO SCOREBOARD values(3, 4, 1, 19, 1, 1);
COMMIT;