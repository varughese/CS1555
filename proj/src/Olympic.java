import java.sql.*;
import java.util.Scanner;

public class Olympic {
    private static User loggedInUser = null;
    private static final String username = "mav120";
    private static final String password = "4182213";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";

    private static Scanner sc = new Scanner(System.in);

    /* I attempt to separate this application into three components. I designed it
       this way to make testing easier.

       Database Logic
        - Handle preparation of SQL statements and talk to database
       Application Logic
        - Mainly deciding which users can have what options, and cleanly logging
        - in, and the glue between user input and talking to the database
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
    public static void createUser(String username, String passkey, int role_id) throws SQLException {
        if (role_id > 3 || role_id < 2) {
            role_id = 2;
        }

        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO USER_ACCOUNT values(?, ?, ?)");
        stmt.setString(1, username);
        stmt.setString(2, passkey);
        stmt.setString(3, role_id+"");
        connection.close();
    }

    /** This function should remove the user from the system */
    public static void dropUser(String username) throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given a sport ID, a venue ID, date/time and whether it is a men’s or women’s event, add a new
     event to the system */
    public static void createEvent() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }


    /** Given an Olympic game, team, event, participant and position, add the outcome of the result
     to the scoreboard */
    public static void addEventOutcome() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given an Olympic game (City, Year), sport, country, and the name of the team, add a new team
     to system. Team IDs should be auto-generated, and only coaches can create teams and their
     name is added as the team coach (team member). */
    public static void createTeam() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given a team id and an event id, the team is register to an existing event. */
    public static void registerTeam() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given the first name, last name, nationality, birth place, do, create participant. */
    public static void addParticipant() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given a team ID and a participant, add the member to the team. Only the coach of the team */
    public static void addTeamMember() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** This function should remove the athlete from the system (i.e., deleting all of their information
     from the system).  */
    public static void dropTeamMember() throws SQLException {
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
        PreparedStatement stmt = connection.prepareStatement("SELECT role_id FROM USER_ACCOUNT WHERE username=? AND passkey=?");
        stmt.setString(1, username);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            int role_id = rs.getInt("role_id");
            switch (role_id) {
                case 2:
                    loggedInUser = new Organizer(username);
                    break;
                case 3:
                    loggedInUser = new Coach(username);
                    break;
                case 1:
                default:
                    loggedInUser = new Guest(username);
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
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given an Olympic game (City, Year) and an event id, display the Olympic game, event name,
     participant and the position along with the earned medal. */
    public static void displayEvent() throws SQLException {
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
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Given an olympic id and a number k, display the top-k athletes based on their rank along with
     the number of gold, silver and bronze medals in a descending order of their rank. The rank is
     computed based on the points associated with each metal */
    public static void topkAthletes() throws SQLException {
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
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** The function should return the user to the top level of the UI after marking the time of the
     user’s logout in the user’s “last login” field of the USER ACCOUNT relation. */
    public static void logout() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    /** Exit the program, cleanly! */
    public static void exit() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void main(String args[]) {
        Operation currentOperation = CLI.displayWelcomeScreen();
        while (currentOperation != Operation.EXIT) {
            executeOperation(currentOperation);
            System.out.println();
            currentOperation = CLI.displayUserMenu();
        }

        System.out.println("\nGoodbye!");
    }


    // Application logic layer - this handles business logic of the application.
    public static void executeOperation(Operation op) {
        switch (op) {
            case LOGIN:
                CLI.promptLogin();
                System.out.println(loggedInUser.getGreeting());
                break;
            case CREATE_USER:
                System.out.println("TODO - " + op);
                break;
            case DROP_USER:
                System.out.println("TODO - " + op);
                break;
            case CREATE_EVENT:
                System.out.println("TODO - " + op);
                break;
            case ADD_EVENT_OUTCOME:
                System.out.println("TODO - " + op);
                break;
            case CREATE_TEAM:
                System.out.println("TODO - " + op);
                break;
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
                System.out.println("TODO - " + op);
                break;
            case EXIT:
                System.out.println("TODO - " + op);
                break;
        }
    }


    public enum Operation {
        CREATE_USER(0, "Create User"),
        DROP_USER(1, "Remove User"),
        CREATE_EVENT(2, "Create Event"),
        ADD_EVENT_OUTCOME(3, "Add Event Outcome"),
        CREATE_TEAM(4, "Create Team"),
        REGISTER_TEAM(5, "Register Team"),
        ADD_PARTICIPANT(6, "Add Participant"),
        ADD_TEAM_MEMBER(7, "Add Team Member"),
        DROP_TEAM_MEMBER(8, "Drop Team Member"),
        DISPLAY_SPORT(9, "Display Sport"),
        DISPLAY_EVENT(10, "Display Event"),
        COUNTRY_RANKING(11, "Display Country Ranking"),
        TOP_K_ATHLETES(12, "Display Top K Athletes"),
        CONNECTED_ATHLETES(13, "Display Connected Athletes"),
        LOGOUT(14, "Logout"),
        EXIT(15, "Exit"),
        LOGIN(16, "Login");

        private int value;
        private String description;

        Operation(int value, String desc) {
            this.value = value;
            this.description = desc;
        }
    }


    private static abstract class User {
        public UserType userType;
        public String username;

        public User(UserType userType, String username) {
            this.userType = userType;
            this.username = username;
        }

        public abstract String getGreeting();

        public abstract Operation[] getSupportedOperations();

        public Operation getOperationFromMenuItemInput(int i) {
            // i is what the user typed in, and since arrays start
            // at 0, we will do (i - 1). All validation checking of
            // user input will be handled in the CLI class.
            return getSupportedOperations()[i-1];
        }
    }

    private enum UserType {
        GUEST,
        ORGANIZER,
        COACH
    }

    public static class Guest extends User {
        public Guest(String username) {
            super(UserType.GUEST, username);
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
        public Organizer(String username) {
            super(UserType.ORGANIZER, username);
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
        public Coach(String username) {
            super(UserType.COACH, username);
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
        private static int getUserOption(int minChoice, int maxChoice) {
            System.out.print("\nEnter choice: ");
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
