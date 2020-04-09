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
        System.out.println("WELCOME TO THE OLYMPICS");
        System.out.println("1. Login");
        System.out.println("2. Exit");

        System.out.print("Enter choice: ");
        int choice = sc.nextInt();

        while (choice != 2) {
            System.out.print("Enter choice: ");
            choice = sc.nextInt();
        }
    }
}
