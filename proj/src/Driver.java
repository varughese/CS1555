import java.sql.ResultSet;
import java.sql.SQLException;

public class Driver {
    public static void assert_(boolean b, String desc) {
        if (!b) {
            System.out.println("ERROR: Assertion failed " + desc);
        } else {
            System.out.println("Passing: " + desc);
        }
    }

    public static void testLoginLogout() throws SQLException {
        boolean shouldBeFalse = Olympic.login("jawn", "jawn");
        assert_ (!shouldBeFalse, "Does not log in incorrect password");
        boolean shouldBeTrue = Olympic.login("guest", "GUEST");
        assert_ (shouldBeTrue, "Logs in guest");
        // already logged in, should return true no matter what
        shouldBeTrue = Olympic.login("jawn", "jawn");
        assert_ (shouldBeTrue, "Logging in if already logged in returns true");

    }

    public static void main(String[] args) {
        try {
            testLoginLogout();
        } catch (SQLException e1) {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = " + e1.getSQLState());
                System.out.println("SQLState = " + e1.getErrorCode());
                e1 = e1.getNextException();
            }
        }
    }
}
