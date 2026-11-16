package com.campusconnect.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {

    private static String url = "jdbc:oracle:thin:@localhost:1521:XE";
    private static String user = "CAMPUSCONNECT";
    private static String password = "campus123";

    static {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input != null) {
                    Properties props = new Properties();
                    props.load(input);
                    if (props.getProperty("db.url") != null) url = props.getProperty("db.url").trim();
                    if (props.getProperty("db.user") != null) user = props.getProperty("db.user").trim();
                    if (props.getProperty("db.password") != null) password = props.getProperty("db.password").trim();
                }
            } catch (Exception ignored) {
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        Connection con = null;
        try {
            con = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
