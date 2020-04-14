import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

    public static void testTeamAndEvent() throws SQLException {
        Olympic.logout();
        Olympic.login("Nicole Jones", "nj");

        assert_(
                Olympic.dropTeamMember(-1) == 0,
                "Does not delete anyone with invalid participant id");

        int event_id = Olympic.createEvent(1, 4, new Date(), 'm');
        assert_(event_id > 0, "Creates an event, id (" + event_id + ")");

        int team_id = Olympic.createTeam(
          "London",
          2012,
          "Team Test",
          "USA",
          1,
          20
        );
        assert_(team_id >= 0, "Created new team with id " + team_id);
        Olympic.registerTeam(event_id, team_id);
        assert_(true, "Registered team (" + team_id + ") to (" + event_id + ")");
        int participant_id = Olympic.addParticipant("Daniel","Mosse", "Brazil", "Pittsburgh", new Date());
        assert_(participant_id > 0, "Added participant with id " + participant_id);
        Olympic.addTeamMember(team_id, participant_id);
        assert_(true, "Add team member with id " + participant_id + " to team " + team_id);
        int added = Olympic.addEventOutcome(2, team_id, event_id,participant_id, 1);
        assert_(added >= 1, "Adds item to scoreboard");


        assert_(
                Olympic.dropTeamMember(participant_id) == 1,
                "Deletes team member (participant id " + participant_id + ")");
    }

    public static void displays() throws SQLException {
        ArrayList<List<String>> res = Olympic.displaySport("400m");
        assert_(res.size() > 0, "Displays results for 400m");
        Olympic.CLI.prettyPrintResults(res);

        res = Olympic.displayEvent(213);
        assert_(res.size() > 0, "Displays results for event id 213");
        Olympic.CLI.prettyPrintResults(res);

        res = Olympic.countryRanking(2);
        assert_(res.size() > 0, "Displays country rankings");
        Olympic.CLI.prettyPrintResults(res);
    }

    public static void main(String[] args) {
        System.out.println("Starting tests, this does a lot of db reads/writes so be patient ... \n");
        try {
//            testLoginLogout();
//            testUserCreateDrop();
            Olympic.login("guest", "GUEST");
//            testTeamAndEvent();
            displays();
        } catch (SQLException e1) {
            System.out.println("SQL Error");
            while (e1 != null) {
                System.out.println("Message = " + e1.getMessage());
                System.out.println("SQLState = " + e1.getSQLState());
                System.out.println("SQLState = " + e1.getErrorCode());
                e1 = e1.getNextException();
            }
        }

        System.out.println("All done!");
    }
}
