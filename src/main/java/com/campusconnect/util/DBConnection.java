
package com.campusconnect.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.InputStream;
import java.io.IOException;
import java.util.Properties;

public class DBConnection {

    private static final Properties properties = new Properties();

    static {
        try (InputStream input =
                DBConnection.class.getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (input == null) {
                throw new IOException(
                    "db.properties file not found in classpath."
                );
            }

            properties.load(input);

            Class.forName("oracle.jdbc.driver.OracleDriver");

        } catch (IOException | ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() {

        try {
            String url = properties.getProperty("db.url");
            String user = properties.getProperty("db.user");
            String password = properties.getProperty("db.password");

            if (url == null || user == null || password == null) {
                throw new SQLException(
                    "Database configuration is incomplete."
                );
            }

            return DriverManager.getConnection(
                url.trim(),
                user.trim(),
                password.trim()
            );

        } catch (SQLException e) {
            System.err.println("Database connection failed:");
            e.printStackTrace();
            return null;
        }
    }
}
