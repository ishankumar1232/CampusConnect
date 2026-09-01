package com.campusconnect.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection con;
    public static Connection  getConnection() {


        try {
            if (con == null || con.isClosed()) {
            	Class.forName("oracle.jdbc.driver.OracleDriver");
            	 
            	String url = "jdbc:oracle:thin:@localhost:1521:XE";
            	String user = "CAMPUSCONNECT";  	//DATABSE USERNAME
            	String pass = "campus123";	//DATABSE PASSWORD
            	con = DriverManager.getConnection(url, user, pass);
            	System.out.println("Database Connected Successfully");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        return con;
    }
}