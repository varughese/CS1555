package edu.pitt.cs;

import java.sql.*;

public class JavaDemo {
    private static final String username = "mav120";
    private static final String password = "4182213";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";


    public static void main(String args[]) throws SQLException {

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

        Statement st = connection.createStatement();
        String query1 =
                "SELECT * FROM USER_ACCOUNT";
        ResultSet res1 = st.executeQuery(query1);
        String account_username;
        String passkey;
        while (res1.next()) {
            account_username = res1.getString("USERNAME");
            passkey = res1.getString("passkey");
            System.out.println(account_username + " " + passkey);
        }
    }
}