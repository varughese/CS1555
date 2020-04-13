import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Scanner;
import java.util.Date;

public class Olympic {
    public static User loggedInUser = null;
    private static final String username = "mav120";
    private static final String password = "4182213";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";

    private static Scanner sc = new Scanner(System.in);

    /* I attempt to separate this application into three components. I designed it
       this way to make testing easier.

       Database Logic
        - Handle preparation of SQL statements and talk to database

       Application Logic
        - Deciding which users can have what options, logging
        - them in, and the glue between user input and talking to the database

       The CLI Interface
        - Getting user input and displaying things to command line.
    */

    private static Connection startConnection() {
        Connection connection = null;
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, username, password);
            connection.setAutoCommit(true);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
        } catch (Exception e) {
            System.out.println(
                    "Error connecting to database. Printing stack trace: ");
            e.printStackTrace();
        }
        return connection;
    }

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
        Connection connection = startConnection();
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
        connection.close();
        return event_id;
    }


    /** Given an Olympic game, team, event, participant and position, add the outcome of the result
     to the scoreboard */
    public static int addEventOutcome(int olympic_id, int team_id, int event_id, int participant_id, int position) throws SQLException {
        if (loggedInUser == null) return -7;
        // I assume 'an Olympic game' means olympic_id. I have already shown with
        // the PROC_CREATE_TEAM procedure that I know how to find the olympic id given
        // other details.
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
        if (loggedInUser == null) return -7;
        if (loggedInUser.userType != UserType.COACH) {
            System.out.println("Only coaches can create a team.");
            return -3;
        }
        Connection connection = startConnection();
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
        Connection connection = startConnection();
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
    public static void dropTeamMember() throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
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
    public static void displaySport() throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given an Olympic game (City, Year) and an event id, display the Olympic game, event name,
     participant and the position along with the earned medal. */
    public static void displayEvent() throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given an olympic id, display all the participating countries (country abbreviation), the first year
     the country participated in the Olympics (first registered in the DB) along with the number
     of gold, silver and bronze medals and their ranking sorted in descending order. The rank is
     computed based on the points associated with each metal. */
    public static void countryRanking() throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given an olympic id and a number k, display the top-k athletes based on their rank along with
     the number of gold, silver and bronze medals in a descending order of their rank. The rank is
     computed based on the points associated with each metal */
    public static void topkAthletes() throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /**  Given an athlete, a olympic id and a number n, find all the athletes who
     are connected to this athlete based on the participation in the last n + 1 games. That is, it
     displays pairs of athletes that are n hops apart. For example if n is 1 and we have three athletes
     A, B, and C (A =/= B =/= C), then A and C are connected (1 hop apart), if A competes with B
     in the current Olympic games (olympic id) and C competed with B in the immediate previous
     Olympic (olympic id). */
    public static void connectedAthletes() throws SQLException {
        if (loggedInUser == null) return;
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
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

    public static void main(String args[]) {
        Operation currentOperation = CLI.displayWelcomeScreen();

        while (currentOperation != Operation.EXIT) {
            try {
                executeOperation(currentOperation);
                System.out.println();
                if (currentOperation == Operation.LOGOUT) {
                    currentOperation = CLI.displayWelcomeScreen();
                } else {
                    currentOperation = CLI.displayUserMenu();
                }
            } catch (SQLException e) {
                System.out.println("Hm. Something weird happened. Let's try again.");
            }
        }

        try {
            executeOperation(Operation.EXIT);
        } catch (SQLException e) {
            System.out.println("Error = " + e.getErrorCode());
        }
    }

    // Application logic layer - this handles business logic of the application.
    public static void executeOperation(Operation op) throws SQLException {
        switch (op) {
            case LOGIN:
                CLI.promptLogin();
                System.out.println(loggedInUser.getGreeting());
                break;

            case CREATE_USER: {
                String username = CLI.getUserString("Username", 30);
                String passkey = CLI.getUserString("Password", 20);
                System.out.println("What type of user are they?");
                System.out.println("\t1. Organizer\n\t2. Coach.");
                System.out.println("All guests can log into the system with username guest and password GUEST.");
                int choice = CLI.getUserOption(1, 2);
                UserType userType = choice == 1 ? UserType.ORGANIZER : UserType.COACH;
                System.out.println("Creating user ... ");
                try {
                    int user_id = createUser(username.trim(), passkey, userType);
                    System.out.println("Created! Their user id is " + user_id);
                } catch (SQLException e) {
                    System.out.println("Sorry, that user was not able to be created. Do they already exist?");
                }
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

            case CREATE_EVENT:
                System.out.println("TODO - " + op);
                Date eventTime = CLI.getUserDate();
                break;

            case ADD_EVENT_OUTCOME:
                System.out.println("TODO - " + op);
                break;

            case CREATE_TEAM: {
                String olympicCity = CLI.getUserString("Olympic City", 30);
                int olympicYear = CLI.getUserOption("Olympic Year", 1900, 2090);
                String teamName = CLI.getUserString("Team Name", 50);
                String country = CLI.getUserString("Country (3 Letter Code)", 10);
                int sportId = CLI.getUserOption("Sport ID", 0, Integer.MAX_VALUE);
                int coachId = CLI.getUserOption("Coach ID", 0, Integer.MAX_VALUE);
                try {
                    int team_id = createTeam(olympicCity, olympicYear, teamName, country, sportId, coachId);
                    System.out.println("Created! Their team id is " + team_id);
                } catch (SQLException e) {
                    System.out.println("Sorry, that did not work. Carefully check all of your inputs and make sure they are correct.");
                }
                break;
            }

            case REGISTER_TEAM:
                System.out.println("TODO - " + op);
                break;

            case ADD_PARTICIPANT:
                System.out.println("TODO - " + op);
                break;

            case ADD_TEAM_MEMBER:
                System.out.println("TODO - " + op);
                break;

            case DROP_TEAM_MEMBER:
                System.out.println("TODO - " + op);
                break;

            case DISPLAY_SPORT:
                System.out.println("TODO - " + op);
                break;

            case DISPLAY_EVENT:
                System.out.println("TODO - " + op);
                break;

            case COUNTRY_RANKING:
                System.out.println("TODO - " + op);
                break;

            case TOP_K_ATHLETES:
                System.out.println("TODO - " + op);
                break;

            case CONNECTED_ATHLETES:
                System.out.println("TODO - " + op);
                break;

            case LOGOUT:
                logout();
                CLI.clearConsole();
                System.out.println("Logged you out!");
                break;

            case EXIT:
                exit();
                break;
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


    // CLI Layer - this handles the user interfaces
    public static class CLI {
        private static int getUserOption(String prompt, int minChoice, int maxChoice) {
            System.out.print(prompt + ": ");
            int choice = Integer.MIN_VALUE;

            // Getting user input is sooo annoying
            while (choice < minChoice || choice > maxChoice) {
                if (choice != Integer.MIN_VALUE) {
                    // Display this if the use integers a non int, or an int that is
                    // out of bounds
                    System.out.print("That was not a valid option! \nEnter choice:");
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

        private static int getUserOption(int minChoice, int maxChoice) {
            return getUserOption("\nEnter choice", minChoice, maxChoice);
        }


        private static String getUserString(String prompt, int maxCharLength) {
            String result;
            do {
                System.out.print(prompt + ": ");
                result = sc.nextLine();
            } while (result.length() > maxCharLength);
            return result;
        }

        private static Date getUserDate() {
            System.out.println("Enter in a date, like yyyy/MM/dd");
            String str[] = {"year", "month", "day" };
            String date = "";

            for(int i=0; i<3; i++) {
                System.out.println("Enter " + str[i] + ": ");
                date = date + sc.next() + "/";
            }
            date = date.substring(0, date.length()-1);
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
            Date parsedDate;

            try {
                parsedDate = dateFormat.parse(date);
            } catch (ParseException e) {
                System.out.println("Sorry, you entered in an invalid date. Let's try again.");
                return getUserDate();
            }
            return parsedDate;
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

            int choice = getUserOption(1, 2);

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

            int choice = getUserOption(1, ops.length);
            return loggedInUser.getOperationFromMenuItemInput(choice);
        }

    }
}
