## CS 1555 Term Project
Mathew Varughese
MAV120

How to run the project
1. Run `schema.sql`
2. Run `trigger.sql`
3. Run `init.sql`
4. `javac -cp lib/ojdbc7.jar src/*.java`

(For Windows, `cp` argument needs to be in quotes)

To run Driver that runs Tests
`java -cp lib/ojdbc7.jar:src/ Driver`

To run Olympics CLI
`java -cp lib/ojdbc7.jar:src/ Olympic`

Or, you can open the `proj.iml` file in `IntelliJ`, and compile and run the programs that way!



