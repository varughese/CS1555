import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

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
        Olympic.logout();
        assert_ (Olympic.loggedInUser == null, "Set user variable to null after logout");
        // log in as organizer
        shouldBeTrue = Olympic.login("Hu Jintao", "Beijing");
        assert_ (shouldBeTrue, "Logs in organizer");
        Olympic.logout();
        Olympic.login("Nicole Jones", "nj");
        assert_(Olympic.loggedInUser.username.equals("Nicole Jones"), "Logs in coach and sets username");
        Olympic.logout();
    }

    public static void testUserCreateDrop() throws SQLException {
        int user_id = Olympic.createUser("rakan", "hates_databases", Olympic.UserType.ORGANIZER);
        assert_(user_id > 0, "Creates a user id (" + user_id + ") for rakan");
        int deleted = Olympic.dropUser("rakan");
        assert_(deleted == 1, "Deletes created user");
    }

    public static void testEvents() throws SQLException {
        int event_id = Olympic.createEvent(1, 4, new Date(), 'm');
        assert_(event_id > 0, "Creates an event, id (" + event_id + ")");
        int added = Olympic.addEventOutcome(2, 5, event_id,0, 1);
        assert_(added > 1, "Adds item to scoreboard");
    }

    public static void testTeam() throws SQLException {
        Olympic.logout();
        Olympic.login("Nicole Jones", "nj");
        int team_id = Olympic.createTeam(
          "London",
          2012,
          "Team Test",
          "USA",
          1,
          20
        );
        assert_(team_id >= 0, "Created new team with id " + team_id);
    }

    public static void main(String[] args) {
        try {
            testLoginLogout();
            testUserCreateDrop();
            Olympic.login("guest", "GUEST");
//            testEvents();
            testTeam();
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
