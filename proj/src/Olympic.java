import java.sql.*;
import java.util.Scanner;

public class Olympic {
    private static final String username = "mav120";
    private static final String password = "4182213";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";

    public static Scanner sc = new Scanner(System.in);


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

    public static void createUser(String username, String passkey, String role_id) throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("INSERT INTO USER_ACCOUNT values(?, ?, ?)");
        stmt.setString(1, username);
        stmt.setString(2, passkey);
        stmt.setString(3, role_id);
        connection.close();
    }

    public static void dropUser() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void createEvent() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void addEventOutcome() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void createTeam() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void registerTeam() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void addParticipant() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void addTeamMember() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void dropTeamMember() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void login() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void displaySport() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void displayEvent() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void countryRanking() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void topkAthletes() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void connectedAthletes() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void logout() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void exit() throws SQLException {
        Connection connection = startConnection();
        // TODO
        PreparedStatement stmt = connection.prepareStatement("SELECT * FROM TABLE_NAME");
        connection.close();
    }

    public static void main(String args[]) {
        CLI.displayWelcomeScreen();
        CLI.promptLogin();

    }

    private static class CLI {
        private static int getUserOption() {
            System.out.print("Enter choice: ");
            return sc.nextInt();
        }

        private static void displayWelcomeScreen() {
            System.out.println("WELCOME TO THE OLYMPICS");
            System.out.println("1. Login");
            System.out.println("2. Exit");

            int choice = getUserOption();

            if (choice == 2) {
                System.out.println("Goodbye!");
                return;
            } else if (choice == 1) {
                promptLogin();
            }
        }

        private static void promptLogin() {


            while (choice != 2) {
                System.out.print("Enter choice: ");
                choice = sc.nextInt();
            }

            System.out.println("\nWould you like to exit the program? Type \"no\" for no, anything else to exit.");
            String exitStr = sc.nextLine();
            if("no".equals(exitStr)) {
                promptLogin();
            }
        }
    }
}
