import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

public class Olympic {
    public static User loggedInUser = null;
    private static final String username = "mav120";
    private static final String password = "4182213";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";

    private static Scanner sc = new Scanner(System.in);

    /** I separated this application into three components. I designed it
       this way to make testing easier. Since we only are allowed to have one
       file, it makes it pretty hard to read.

       Database Logic
        - Handle preparation of SQL statements and talk to database

       Application Logic
        - Deciding which users can have what options, logging
        - them in, and the glue between taking user input and talking to the database function

       The CLI Interface
        - Getting user input and displaying things to command line.
    */


    /*********************************************************

     _____       _______       ____           _____ ______
    |  __ \   /\|__   __|/\   |  _ \   /\    / ____|  ____|
    | |  | | /  \  | |  /  \  | |_) | /  \  | (___ | |__
    | |  | |/ /\ \ | | / /\ \ |  _ < / /\ \  \___ \|  __|
    | |__| / ____ \| |/ ____ \| |_) / ____ \ ____) | |____
    |_____/_/    \_\_/_/    \_\____/_/    \_\_____/|______|


     ********************************************************/

    private static Connection startConnection(boolean autoCommit) {
        Connection connection = null;
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, username, password);
            connection.setAutoCommit(autoCommit);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
        } catch (Exception e) {
            System.out.println(
                    "Error connecting to database. Printing stack trace: ");
            e.printStackTrace();
        }
        return connection;
    }

    private static Connection startConnection() { return startConnection(true); }

    /** Given a username, passkey, role id, add a new user to the system. The “last login” should be
     set with the creation date and time. Only organizers can add any kind of users to the system.*/
    public static int createUser(String username, String passkey, UserType userType) throws SQLException {
        if (loggedInUser == null) return -1;
        int role_id = userType.id;

        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO USER_ACCOUNT values(null, ?, ?, ?, null)");
        stmt.setString(1, username);
        stmt.setString(2, passkey);
        stmt.setInt(3, role_id);

        stmt.executeUpdate();

        PreparedStatement getId = connection.prepareStatement("SELECT user_accounts_sequence.currval FROM USER_ACCOUNT");
        ResultSet rs = getId.executeQuery();
        int user_id = -1;
        if (rs.next()) {
            user_id = (int) rs.getLong(1);
        }
        connection.close();
        return user_id;
    }

    /** This function should remove the user from the system */
    public static int dropUser(String username) throws SQLException {
        if (loggedInUser == null) return 0;
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("DELETE FROM USER_ACCOUNT WHERE username = ?");
        stmt.setString(1, username);
        int deleted = stmt.executeUpdate();
        connection.close();
        return deleted;
    }

    /** Given a sport ID, a venue ID, date/time and whether it is a men’s or women’s event, add a new
     event to the system */
    public static int createEvent(int sport_id, int venue_id, Date event_date, char gender) throws SQLException {
        if (loggedInUser == null) return -7;
        if (gender != 'm' && gender != 'f') {
            gender  = 'f';
        }
        Connection connection = startConnection(/*autoCommit=*/ false);
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO event values(null, ?, ?, ?, ?)");
        stmt.setInt(1, sport_id);
        stmt.setInt(2, venue_id);
        stmt.setString(3, gender+"");
        stmt.setDate(4, new java.sql.Date(event_date.getTime()));
        stmt.executeUpdate();

        PreparedStatement getId = connection.prepareStatement("SELECT event_sequence.currval FROM EVENT");
        ResultSet rs = getId.executeQuery();
        int event_id = -1;
        if (rs.next()) {
            event_id = (int) rs.getLong(1);
        }
        connection.commit();
        connection.close();
        return event_id;
    }


    /** Given an Olympic game, team, event, participant and position, add the outcome of the result
     to the scoreboard */
    public static int addEventOutcome(int olympic_id, int team_id, int event_id, int participant_id, int position) throws SQLException {
        if (loggedInUser == null) return -7;
        // I assume 'an Olympic game' means olympic_id. I have already shown with
        // the PROC_CREATE_TEAM procedure that I know how to find the olympic id given
        // other details. It was unclear to me what 'given an Olympic game' from the description
        // is. If it is the olympic number, I would create a procedure like PROC_CREATE_TEAM
        // and select olympic_id from OLYMPICS where olympic_num = ? and pass that into this
        // sql statement I have below.
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO scoreboard values(?, ?, ?, ?, ?, null)");
        stmt.setInt(1, olympic_id);
        stmt.setInt(2, event_id);
        stmt.setInt(3, team_id);
        stmt.setInt(4, participant_id);
        stmt.setInt(5, position);
        int updated = stmt.executeUpdate();
        connection.close();
        return updated;
    }

    /** Given an Olympic game (City, Year), sport, country, and the name of the team, add a new team
     to system. Team IDs should be auto-generated, and only coaches can create teams and their
     name is added as the team coach (team member). */
    public static int createTeam(
            String olympicCity,
            int year,
            String teamName,
            String country,
            int sport_id,
            int coach_id
    ) throws SQLException {
        // "In @153 Brian said "For this query I discussed the issue with Dr. Costa and
        // you can take the coach_id as an input parameter as the pdf is from an older
        // version before the project was changed for individual projects"
        if (loggedInUser == null) return -7;
        if (loggedInUser.userType != UserType.COACH) {
            System.out.println("Only coaches can create a team.");
            return -3;
        }
        Connection connection = startConnection(/*autoCommit=*/ false);
        CallableStatement cs = connection.prepareCall("{CALL PROC_CREATE_TEAM(?, ?, ?, ?, ?, ?)}");
        cs.setString(1, olympicCity);
        cs.setInt(2, year);
        cs.setString(3, teamName);
        cs.setString(4, country);
        cs.setInt(5, sport_id);
        cs.setInt(6, coach_id);
        int updatedRows = cs.executeUpdate();

        if (updatedRows <= 0) {
            System.out.println("Did not a matching olympics or country. Make sure you spelled those correctly.");
        }

        PreparedStatement getId = connection.prepareStatement("SELECT team_sequence.currval FROM dual");
        ResultSet rs = getId.executeQuery();
        int team_id = -1;
        if (rs.next()) {
            team_id = (int) rs.getLong(1);
        }
        connection.commit();
        connection.close();
        return team_id;
    }

    /** Given a team id and an event id, the team is register to an existing event. */
    public static void registerTeam(int event_id, int team_id) throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO EVENT_PARTICIPATION values(?, ?, 'e')");
        stmt.setInt(1, event_id);
        stmt.setInt(2, team_id);

        stmt.executeUpdate();
        connection.close();
    }

    /** Given the first name, last name, nationality, birth place, dob, create participant. */
    public static int addParticipant(String firstname, String lastname, String nationality, String birthPlace, Date dob) throws SQLException {
        if (loggedInUser == null) return -7;
        Connection connection = startConnection(/*autoCommit=*/ false);
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO PARTICIPANT values(null, ?, ?, ?, ?, ?)");
        stmt.setString(1, firstname);
        stmt.setString(2, lastname);
        stmt.setString(3, nationality);
        stmt.setString(4, birthPlace);
        stmt.setDate(5, new java.sql.Date(dob.getTime()));

        stmt.executeUpdate();

        PreparedStatement getId = connection.prepareStatement("SELECT participant_sequence.currval FROM dual");
        ResultSet rs = getId.executeQuery();
        int participant_id = -1;
        if (rs.next()) {
            participant_id = (int) rs.getLong(1);
        }
        connection.commit();
        connection.close();
        return participant_id;
    }

    /** Given a team ID and a participant, add the member to the team. Only the coach of the team */
    public static void addTeamMember(int team_id, int participant_id) throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO TEAM_MEMBER values(?, ?)");
        stmt.setInt(1, team_id);
        stmt.setInt(2, participant_id);
        stmt.executeUpdate();
        connection.close();
    }

    /** This function should remove the athlete from the system (i.e., deleting all of their information
     from the system).  */
    public static int dropTeamMember(int participant_id) throws SQLException {
        if (loggedInUser == null) return -7;
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("DELETE FROM PARTICIPANT WHERE PARTICIPANT_ID = ?");
        stmt.setInt(1, participant_id);
        int deletedCount = stmt.executeUpdate();
        connection.close();
        return deletedCount;
    }

    /** Given username and password, login in the system when an appropriate match is found with
     the appropriate role. Returns whether or not it logged in. */
    public static boolean login(String username, String password) throws SQLException {
        if (loggedInUser != null) {
            System.out.println("Already logged in!");
            return true;
        }
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("SELECT user_id, role_id, last_login FROM USER_ACCOUNT WHERE username=? AND passkey=?");
        stmt.setString(1, username);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            int user_id = rs.getInt("user_id");
            int role_id = rs.getInt("role_id");
            Date last_login = rs.getDate("last_login");
            switch (role_id) {
                case 2:
                    loggedInUser = new Organizer(user_id, username, last_login);
                    break;
                case 3:
                    loggedInUser = new Coach(user_id, username, last_login);
                    break;
                case 1:
                default:
                    loggedInUser = new Guest(user_id, username, last_login);
                    break;
            }

        } else {
            loggedInUser = null;
        }
        connection.close();
        return loggedInUser != null;
    }

    /** Given a sport name, it displays the Olympic year it was added, events of that sport, gender, the
     medals winners and their countries. (athletes who got medals should be displayed first according
     to medals i.e., gold, silver and bronze and sorted on the Olympic year). */
    public static ArrayList<List<String>> displaySport(String sportName) throws SQLException {
        if (loggedInUser == null) return null;
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("select * from DISPLAY_SPORT_INFO where lower(SPORT_NAME) = lower(?) order by OLYMPIC_YEAR, EVENT_ID, POINTS DESC");
        stmt.setString(1, sportName);
        ResultSet rs = stmt.executeQuery();
        ArrayList<List<String>> results = new ArrayList<List<String>>(50);
        results.add(Arrays.asList("Sport", "Year Added", "Event ID", "Olympics", "Gender", "Team ID", "Name", "Country", "Medal"));
        // TODO all of the rs.next() makes it skip!
        while(rs.next()) {
            results.add(Arrays.asList(
                    rs.getString("sport_name"),
                    rs.getString("year_added"),
                    rs.getString("event_id"),
                    rs.getString("olympic_num"),
                    rs.getString("gender"),
                    rs.getString("team_id"),
                    rs.getString("name"),
                    rs.getString("country"),
                    rs.getString("medal")
            ));
        }
        connection.close();
        return results;
    }

    /** Given an Olympic game (City, Year) and an event id, display the Olympic game, event name,
     participant and the position along with the earned medal. */
    public static ArrayList<List<String>> displayEvent(int event_id) throws SQLException {
        // As said on Piazza, we do not need the olympic ID since that is implicitly given in the event id
        // Look at 'createTeam' where I demonstrate how to use city and year to obtain an olympic ID.
        if (loggedInUser == null) return null;
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("select * from DISPLAY_SPORT_INFO where event_id = ?");
        stmt.setInt(1, event_id);
        ResultSet rs = stmt.executeQuery();
        ArrayList<List<String>> results = new ArrayList<List<String>>(50);
        results.add(Arrays.asList("Olympic Game", "Sport", "Name", "Position", "Medal"));
        while(rs.next()) {
            results.add(Arrays.asList(
                rs.getString("OLYMPIC_NUM"),
                rs.getString("sport_name"),
                rs.getString("name"),
                rs.getString("position"),
                rs.getString("medal")
            ));
        }
        connection.close();
        return results;
    }

    /** Given an olympic id, display all the participating countries (country abbreviation), the first year
     the country participated in the Olympics (first registered in the DB) along with the number
     of gold, silver and bronze medals and their ranking sorted in descending order. The rank is
     computed based on the points associated with each metal. */
    public static ArrayList<List<String>> countryRanking(int olympic_id) throws SQLException {
        if (loggedInUser == null) return null;
        Connection connection = startConnection();
        PreparedStatement stmt = connection.prepareStatement("SELECT RANK, COUNTRY_CODE, GOLD, SILVER, BRONZE, FIRST_YEAR FROM V_COUNTRY_RANKING WHERE olympic_id = ?");
        stmt.setInt(1, olympic_id);
        ResultSet rs = stmt.executeQuery();
        ArrayList<List<String>> results = new ArrayList<List<String>>(50);
        results.add(Arrays.asList("Rank", "Country", "Gold", "Silver", "Bronze", "First Year"));
        while(rs.next()) {
            results.add(Arrays.asList(
                    rs.getString("rank"),
                    rs.getString("country_code"),
                    rs.getString("gold"),
                    rs.getString("silver"),
                    rs.getString("bronze"),
                    rs.getString("first_year")
            ));
        }
        connection.close();
        return results;
    }

    /** Given an olympic id and a number k, display the top-k athletes based on their rank along with
     the number of gold, silver and bronze medals in a descending order of their rank. The rank is
     computed based on the points associated with each metal */
    public static ArrayList<List<String>> topkAthletes(int olympic_id, int k) throws SQLException {
        if (loggedInUser == null) return null;
        Connection connection = startConnection();
        String partialStmt = "SELECT RANK, NAME, GOLD, SILVER, BRONZE FROM V_PARTICIPANTS_RANKING";
        String qualifiersStmt = " WHERE OLYMPIC_ID = ? ORDER BY RANK FETCH NEXT ? ROWS ONLY";
        PreparedStatement stmt = connection.prepareStatement(partialStmt + qualifiersStmt);
        stmt.setInt(1, olympic_id);
        stmt.setInt(2, k);
        ResultSet rs = stmt.executeQuery();
        ArrayList<List<String>> results = new ArrayList<List<String>>(50);
        results.add(Arrays.asList("Rank", "Name", "Gold", "Silver", "Bronze"));
        while(rs.next()) {
            results.add(Arrays.asList(
                    rs.getString("rank"),
                    rs.getString("name"),
                    rs.getString("gold"),
                    rs.getString("silver"),
                    rs.getString("bronze")
            ));
        }
        connection.close();
        return results;
    }

    /**  Given an athlete, a olympic id and a number n, find all the athletes who
     are connected to this athlete based on the participation in the last n + 1 games. That is, it
     displays pairs of athletes that are n hops apart. For example if n is 1 and we have three athletes
     A, B, and C (A =/= B =/= C), then A and C are connected (1 hop apart), if A competes with B
     in the current Olympic games (olympic id) and C competed with B in the immediate previous
     Olympic (olympic id). */
    public static ArrayList<List<String>> connectedAthletes(int participant_id, int olympic_id, int n) throws SQLException {
        int MAX_HOPS = 3; // Panos said this on Piazza
        if (loggedInUser == null || n > MAX_HOPS || n < 0) return null;
        Connection connection = startConnection();
        String stmtPart = "SELECT DISTINCT NAME2 from V_P" + n + "_COMPETED_WITH_EACH_OTHER";
        PreparedStatement stmt = connection.prepareStatement(stmtPart + " WHERE pid1 = ? AND o1 = ?");
        ArrayList<List<String>> results = new ArrayList<List<String>>(50);
        stmt.setInt(1, participant_id);
        stmt.setInt(2, olympic_id);
        ResultSet rs = stmt.executeQuery();
        results.add(Arrays.asList("Name"));
        while(rs.next()) {
            results.add(Arrays.asList(
                    rs.getString("name2")
            ));
        }
        connection.close();
        return results;
    }

    /** The function should return the user to the top level of the UI after marking the time of the
     user’s logout in the user’s “last login” field of the USER ACCOUNT relation. */
    public static void logout() throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        int user_id = loggedInUser.getUserId();
        String username = loggedInUser.username;
        connection.setAutoCommit(false);
        connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
        CallableStatement cs = connection.prepareCall("{call PROC_USER_LOGOUT(?, ?)}");
        cs.setInt(1, user_id);
        cs.setString(2, username);
        cs.executeUpdate();
        connection.commit();
        connection.setAutoCommit(true);
        connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
        loggedInUser = null;
        connection.close();

    }

    /** Exit cleanly */
    public static void exit() {
        System.out.println("Goodbye!");
    }

    /********************************************

              _____  _____
        /\   |  __ \|  __ \
       /  \  | |__) | |__) |
      / /\ \ |  ___/|  ___/
     / ____ \| |    | |
    /_/    \_\_|    |_|

     This section is the controller between the view and the database. It handles
     business logic of the application.
     *********************************************/

    public static void main(String args[]) {
        Operation currentOperation = CLI.displayWelcomeScreen();

        while (currentOperation != Operation.EXIT) {
            executeOperation(currentOperation);
            System.out.println();
            if (currentOperation == Operation.LOGOUT) {
                currentOperation = CLI.displayWelcomeScreen();
            } else {
                currentOperation = CLI.displayUserMenu();
            }
        }

        executeOperation(Operation.EXIT);
    }

    public static void executeOperation(Operation op) {
        String sqlErrorMessage = "Sorry, that did not work. Make sure your IDs are correct and try again";
        try {
            switch (op) {
                case LOGIN:
                    CLI.promptLogin();
                    System.out.println(loggedInUser.getGreeting());
                    break;

                case CREATE_USER: {
                    sqlErrorMessage = "Could not create user! Are you sure they do not already exist?";
                    String username = CLI.getUserString("Username", 30);
                    String passkey = CLI.getUserString("Password", 20);
                    System.out.println("What type of user are they?");
                    System.out.println("\t1. Organizer\n\t2. Coach.");
                    System.out.println("All guests can log into the system with username guest and password GUEST.");
                    int choice = CLI.getUserInt(1, 2);
                    UserType userType = choice == 1 ? UserType.ORGANIZER : UserType.COACH;
                    System.out.println("Creating user ... ");
                    int user_id = createUser(username.trim(), passkey, userType);
                    System.out.println("Created! Their user id is " + user_id);
                    break;
                }

                case DROP_USER: {
                    String username = CLI.getUserString("Username", 30);
                    System.out.println("Deleting - " + username);
                    int deleted = dropUser(username);
                    if (deleted >= 1) {
                        System.out.println("Deleted!");
                    } else {
                        System.out.println("Did not find that user.");
                    }
                    break;
                }

                case CREATE_EVENT: {
                    int sportId = CLI.getUserInt("Sport ID", 0, Integer.MAX_VALUE);
                    int venueId = CLI.getUserInt("Venue ID", 0, Integer.MAX_VALUE);
                    String gender = CLI.getUserString("Male (m) or Female (f)", 1).toLowerCase();
                    Date eventTime = CLI.getUserDate("Event Time");
                    int event_id = createEvent(sportId, venueId, eventTime, gender.charAt(0));
                    System.out.println("Created! The event id is " + event_id);
                    break;
                }
                case ADD_EVENT_OUTCOME: {
                    int olympicId = CLI.getUserInt("Olympic ID", 0, Integer.MAX_VALUE);
                    int teamId = CLI.getUserInt("Team ID", 0, Integer.MAX_VALUE);
                    int eventId = CLI.getUserInt("Event ID", 0, Integer.MAX_VALUE);
                    int participantId = CLI.getUserInt("Participant ID", 0, Integer.MAX_VALUE);
                    int position = CLI.getUserInt("Position", 1, 100);
                    int added = addEventOutcome(olympicId, teamId, eventId, participantId, position);
                    if (added < 1) throw new SQLException();
                    System.out.println("Created!");
                    break;
                }

                case CREATE_TEAM: {
                    String olympicCity = CLI.getUserString("Olympic City", 30);
                    int olympicYear = CLI.getUserInt("Olympic Year", 1900, 2090);
                    String teamName = CLI.getUserString("Team Name", 50);
                    String country = CLI.getUserString("Country (3 Letter Code)", 10);
                    int sportId = CLI.getUserInt("Sport ID", 0, Integer.MAX_VALUE);
                    int coachId = CLI.getUserInt("Coach ID", 0, Integer.MAX_VALUE);
                    int team_id = createTeam(olympicCity, olympicYear, teamName, country, sportId, coachId);
                    System.out.println("Created! Their team id is " + team_id);
                    break;
                }

                case REGISTER_TEAM: {
                    int teamId = CLI.getUserInt("Team ID", 0, Integer.MAX_VALUE);
                    int eventId = CLI.getUserInt("Event ID", 0, Integer.MAX_VALUE);
                    registerTeam(eventId, teamId);
                    System.out.println("That team is registered!");
                    break;
                }

                case ADD_PARTICIPANT: {
                    String firstname = CLI.getUserString("First Name", 30);
                    String lastname = CLI.getUserString("Last Name", 30);
                    String nationality = CLI.getUserString("Nationality", 20);
                    String birthPlace = CLI.getUserString("Birth Place", 40);
                    Date dob = CLI.getUserDate("Date of Birth");
                    int participantId = addParticipant(firstname, lastname, nationality, birthPlace, dob);
                    System.out.println("Created! Their participant id is " + participantId);
                    break;
                }

                case ADD_TEAM_MEMBER: {
                    int teamId = CLI.getUserInt("Team ID", 0, Integer.MAX_VALUE);
                    int participantId = CLI.getUserInt("Participant ID", 0, Integer.MAX_VALUE);
                    addTeamMember(teamId, participantId);
                    System.out.println("Added!");
                    break;
                }

                case DROP_TEAM_MEMBER: {
                    int participantId = CLI.getUserInt("Participant ID", 0, Integer.MAX_VALUE);
                    int deleted = dropTeamMember(participantId);
                    if (deleted >= 1) {
                        System.out.println("Dropped!");
                    } else {
                        System.out.println("Could not drop. Is that a valid ID?");
                    }
                    break;
                }

                case DISPLAY_SPORT: {
                    String sportName = CLI.getUserString("Sport Name", 30);
                    CLI.prettyPrintResults(displaySport(sportName));
                    CLI.promptUserToContinue();
                    break;
                }

                case DISPLAY_EVENT: {
                    int eventId = CLI.getUserInt("Event ID", 0, Integer.MAX_VALUE);
                    CLI.prettyPrintResults(displayEvent(eventId));
                    CLI.promptUserToContinue();
                    break;
                }

                case COUNTRY_RANKING: {
                    int olympicId = CLI.getUserInt("Olympic ID", 0, 1000);
                    CLI.prettyPrintResults(Olympic.countryRanking(olympicId));
                    CLI.promptUserToContinue();
                    break;
                }

                case TOP_K_ATHLETES: {
                    int olympicId = CLI.getUserInt("Olympic ID", 0, 1000);
                    int k = CLI.getUserInt("k (as in, the top 'k')", 0, 10000);
                    CLI.prettyPrintResults(Olympic.topkAthletes(olympicId, k));
                    CLI.promptUserToContinue();
                    break;
                }

                case CONNECTED_ATHLETES: {
                    int participantId = CLI.getUserInt("Participant ID", 0, Integer.MAX_VALUE);
                    int olympicId = CLI.getUserInt("Olympic ID", 0, 1000);
                    int n = CLI.getUserInt("n (The total number of hops)", 0, 3);
                    CLI.prettyPrintResults(Olympic.connectedAthletes(participantId, olympicId, n));
                    CLI.promptUserToContinue();
                    break;
                }

                case LOGOUT:
                    logout();
                    CLI.clearConsole();
                    System.out.println("Logged you out!");
                    break;

                case EXIT:
                    exit();
                    break;
            }
        } catch (SQLException e) {
            System.out.println(sqlErrorMessage);
        }
    }


    public enum Operation {
        CREATE_USER("Create User"),
        DROP_USER("Remove User"),
        CREATE_EVENT("Create Event"),
        ADD_EVENT_OUTCOME("Add Event Outcome"),
        CREATE_TEAM("Create Team"),
        REGISTER_TEAM("Register Team"),
        ADD_PARTICIPANT("Add Participant"),
        ADD_TEAM_MEMBER("Add Team Member"),
        DROP_TEAM_MEMBER("Drop Team Member"),
        DISPLAY_SPORT("Display Sport"),
        DISPLAY_EVENT("Display Event"),
        COUNTRY_RANKING("Display Country Ranking"),
        TOP_K_ATHLETES("Display Top K Athletes"),
        CONNECTED_ATHLETES("Display Connected Athletes"),
        LOGOUT("Logout"),
        EXIT("Exit"),
        LOGIN("Login");

        private String description;

        Operation(String desc) {
            this.description = desc;
        }
    }


    public static abstract class User {
        public UserType userType;
        public String username;
        public int userId;
        public Date lastLoggedIn;

        public User(UserType userType, String username, int userId, Date lastLoggedIn) {
            this.userType = userType;
            this.userId = userId;
            this.username = username;
            this.lastLoggedIn = lastLoggedIn;
        }

        public abstract String getGreeting();

        public abstract Operation[] getSupportedOperations();

        public Operation getOperationFromMenuItemInput(int i) {
            // i is what the user typed in, and since arrays start
            // at 0, we will do (i - 1). All validation checking of
            // user input will be handled in the CLI class.
            return getSupportedOperations()[i-1];
        }

        public int getUserId() {
            return userId;
        }
    }

    public enum UserType {
        GUEST(1),
        ORGANIZER(2),
        COACH(3);

        public int id;

        UserType(int _id) { id = _id; }

    }

    public static class Guest extends User {
        public Guest(int userId, String username, Date lastLoggedIn) {
            super(UserType.GUEST, username, userId, lastLoggedIn);
        }

        public Operation[] ops = new Operation[] {
            Operation.DISPLAY_SPORT,
            Operation.DISPLAY_EVENT,
            Operation.COUNTRY_RANKING,
            Operation.TOP_K_ATHLETES,
            Operation.CONNECTED_ATHLETES,
            Operation.LOGOUT,
            Operation.EXIT
        };

        public String getGreeting() {
            return "Welcome!";
        }

        public Operation[] getSupportedOperations() {
            return ops;
        }
    }

    public static class Organizer extends User {
        public Organizer(int userId, String username, Date lastLoggedIn) {
            super(UserType.ORGANIZER, username, userId, lastLoggedIn);
        }

        public Operation[] ops = new Operation[] {
            Operation.CREATE_USER,
            Operation.DROP_USER,
            Operation.CREATE_EVENT,
            Operation.ADD_EVENT_OUTCOME,
            Operation.DISPLAY_SPORT,
            Operation.DISPLAY_EVENT,
            Operation.COUNTRY_RANKING,
            Operation.TOP_K_ATHLETES,
            Operation.CONNECTED_ATHLETES,
            Operation.LOGOUT,
            Operation.EXIT
        };

        public String getGreeting() {
            return "Welcome Organizer: " + username;
        }

        public Operation[] getSupportedOperations() {
            return ops;
        }
    }

    public static class Coach extends User {
        public Coach(int userId, String username, Date lastLoggedIn) {
            super(UserType.COACH, username, userId, lastLoggedIn);
        }

        public Operation[] ops = new Operation[] {
            Operation.CREATE_TEAM,
            Operation.REGISTER_TEAM,
            Operation.ADD_PARTICIPANT,
            Operation.ADD_TEAM_MEMBER,
            Operation.DROP_TEAM_MEMBER,
            Operation.DISPLAY_SPORT,
            Operation.DISPLAY_EVENT,
            Operation.COUNTRY_RANKING,
            Operation.TOP_K_ATHLETES,
            Operation.CONNECTED_ATHLETES,
            Operation.LOGOUT,
            Operation.EXIT
        };

        public String getGreeting() {
            return "Welcome Coach! " + username;
        }

        public Operation[] getSupportedOperations() {
            return ops;
        }
    }


    /***************************************************
      _____ _      _____
     / ____| |    |_   _|
    | |    | |      | |
    | |    | |      | |
    | |____| |____ _| |_
     \_____|______|_____|


     CLI Layer - this handles the user interfaces
     ****************************************************/

    public static class CLI {
        private static int getUserInt(String prompt, int minChoice, int maxChoice) {
            System.out.print(prompt + ": ");
            int choice = Integer.MIN_VALUE;

            // Getting user input is sooo annoying
            while (choice < minChoice || choice > maxChoice) {
                if (choice != Integer.MIN_VALUE) {
                    // Display this if the use integers a non int, or an int that is
                    // out of bounds
                    System.out.print("That was not a valid option! \n" + prompt+": ");
                }
                if (sc.hasNextInt()) {
                    choice = sc.nextInt();
                } else {
                    // Set choice to something other than Int.MIN_VALUE so
                    // next iteration of the while loop knows that it is incorrect
                    choice = -1;
                    // We have to do this to clear the rest of the line so they can
                    // reinput
                    sc.nextLine();
                }
            }

            sc.nextLine(); // Consume the '\n', because scanner is particular like that
            return choice;
        }

        private static int getUserInt(int minChoice, int maxChoice) {
            return getUserInt("\nEnter choice", minChoice, maxChoice);
        }


        private static String getUserString(String prompt, int maxCharLength) {
            String result;
            do {
                System.out.print(prompt + ": ");
                result = sc.nextLine();
            } while (result.length() > maxCharLength);
            return result;
        }

        private static Date getUserDate(String prompt) {
            System.out.println(prompt);
            int year = getUserInt("Year", 1900, 2090);
            int month = getUserInt("Month", 1, 12);
            int day = getUserInt("Day", 1, 30);
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
            Date parsedDate;

            try {
                parsedDate = dateFormat.parse(year + "/" + month + "/" + day);
            } catch (ParseException e) {
                System.out.println("Sorry, you entered in an invalid date. Let's try again.");
                return getUserDate(prompt);
            }
            return parsedDate;
        }

        private static void promptUserToContinue() {
            getUserInt("\nPress '1' to continue", 0, 100);
        }

        private static void clearConsole() {
            System.out.println("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
            System.out.println("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
            System.out.println("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
        }

        private static Operation displayWelcomeScreen() {
            System.out.println("WELCOME TO THE OLYMPICS");
            System.out.println("1. " + Operation.LOGIN.description);
            System.out.println("2. " + Operation.EXIT.description);

            int choice = getUserInt(1, 2);

            if (choice == 2) {
                return Operation.EXIT;
            } else {
                return Operation.LOGIN;
            }
        }

        private static void promptLogin() {
            System.out.print("Username: ");
            String username = sc.nextLine();

            System.out.print("Password: ");
            String password = sc.nextLine();

            try {
                boolean loggedIn = Olympic.login(username, password);
                if (loggedIn) {
                    clearConsole();
                    System.out.println("Successfully logged in!\n");
                } else {
                    System.out.println("\nUsername or password not recognized! Try again.\n");
                    promptLogin();
                }
            } catch (SQLException e) {
                System.out.println("That did not work! Lets try again.");
                promptLogin();
            }
        }

        private static Operation displayUserMenu() {
            Operation ops[] = loggedInUser.getSupportedOperations();
            System.out.println("Type in the number of the command you wish to run!");
            for (int i=0; i < ops.length; i++) {
                int no = i + 1;
                System.out.println(no + ". " + ops[i].description);
            }

            int choice = getUserInt(1, ops.length);
            return loggedInUser.getOperationFromMenuItemInput(choice);
        }


        public static void prettyPrintResults(ArrayList<List<String>> table) {
            if (table == null || table.size() <= 1) {
                System.out.println("No results found!\n");
                return;
            }
            // This prints out a "table" of data neatly like:
            // +-----+----------+--------+------+-------+-----------------+-------+------+
            // |Sport|Year Added|Event ID|Gender|Team ID|Name             |Country|Medal |
            // +-----+----------+--------+------+-------+-----------------+-------+------+
            // |400M |1896      |9       |Male  |34     |Jeremy Wariner   |USA    |GOLD  |
            // +-----+----------+--------+------+-------+-----------------+-------+------+
            // I would break this up into other
            // functions if I was allowed to use other class files, but to make it
            // easier to roll up in Intellij, it all goes in here. Inspired by
            // https://stackoverflow.com/questions/11383070/pretty-print-2d-array-in-java
            char BORDER_C = '+';
            char BORDER_H = '-';
            char BORDER_V = '|';
            int[] widths = new int[table.get(0).size()];
            // Find column with longest string and store in widths array
            for (List<String > row : table) {
                if (row != null) {
                    for (int c = 0; c < widths.length; c++ ) {
                        String cell = row.get(c);
                        int l = cell.length();
                        if (widths[c] < l) {
                            widths[c] = l;
                        }
                    }
                }
            }

            // Make a string like this: +---+---+----+ that matches the column lengths
            final StringBuilder hBuilder = new StringBuilder(256);
            hBuilder.append(BORDER_C);
            for (int w : widths) {
                for (int i = 0; i < w; i++) {
                    hBuilder.append(BORDER_H);
                }
                hBuilder.append(BORDER_C);
            }
            String horizontalBorder = hBuilder.toString();
            int lineLength = horizontalBorder.length();
            // Print out each row
            System.out.println(horizontalBorder);
            for (List<String> row : table) {
                if (row != null) {
                    StringBuilder rowBuilder = new StringBuilder(lineLength).append(BORDER_V);
                    for (int i = 0; i < widths.length; i++) {
                        String paddedCellValue = String.format("%1$-" + widths[i] + "s", row.get(i));
                        rowBuilder.append(paddedCellValue).append(BORDER_V);
                    }
                    System.out.println(rowBuilder.toString());
                    System.out.println(horizontalBorder);
                }
            }
        }
    }
}
