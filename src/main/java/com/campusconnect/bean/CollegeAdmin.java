package com.campusconnect.bean;

import java.sql.*;

public class CollegeAdmin {

    private int adminId;
    private int collegeId;
    private String name;
    private String email;
    private String password;

    public CollegeAdmin() {

    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public int getCollegeId() {
        return collegeId;
    }

    public void setCollegeId(int collegeId) {
        this.collegeId = collegeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


    // Insert College Admin

    public boolean InsertMethod() {

        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();

            String qid =
                "SELECT NVL(MAX(ADMIN_ID),0)+1 FROM COLLEGE_ADMIN";

            ResultSet rs = stmt.executeQuery(qid);

            int id = 1;

            if(rs.next()) {
                id = rs.getInt(1);
            }

            rs.close();

            String q1 =
                "INSERT INTO COLLEGE_ADMIN "
                + "(ADMIN_ID, COLLEGE_ID, NAME, EMAIL, PASSWORD) "
                + "VALUES ("
                + id + ", "
                + collegeId + ", '"
                + name + "', '"
                + email + "', '"
                + password + "')";

            int x = stmt.executeUpdate(q1);

            stmt.close();
            con.close();

            if(x > 0) {
                return true;
            }

        }
        catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean LoginMethod() {

        boolean x = false;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            java.sql.Connection con = java.sql.DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql = "SELECT * FROM COLLEGE_ADMIN WHERE EMAIL=? AND PASSWORD=?";

            java.sql.PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            java.sql.ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                adminId = rs.getInt("ADMIN_ID");
                collegeId = rs.getInt("COLLEGE_ID");
                name = rs.getString("NAME");

                x = true;
            }

            con.close();

        } catch(Exception e) {
            System.out.println(e);
        }

        return x;
    }
}