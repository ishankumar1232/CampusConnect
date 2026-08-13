package com.campusconnect.util;

import java.sql.Connection;

public class DBTest {

    public static void main(String[] args) {

        Connection con = DBConnection.getConnection();

        if (con != null) {
            System.out.println("CampusConnect Database Connected!");
        } else {
            System.out.println("Database Connection Failed!");
        }
    }
}