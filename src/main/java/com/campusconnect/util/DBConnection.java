package com.campusconnect.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:oracle:thin:@localhost:1521:XE";

    private static final String USER =
            "CAMPUSCONNECT";

    private static final String PASSWORD = "campus123";

    public static Connection getConnection() {

        Connection con = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );

            System.out.println("Database Connected Successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return con;
    }
}