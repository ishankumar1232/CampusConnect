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

        String qid = "SELECT NVL(MAX(ADMIN_ID),0)+1 FROM COLLEGE_ADMIN";
        String q1 = "INSERT INTO COLLEGE_ADMIN (ADMIN_ID, COLLEGE_ID, NAME, EMAIL, PASSWORD) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = com.campusconnect.util.DBConnection.getConnection()) {

            if (con == null) return false;

            int id = 1;
            try (Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery(qid)) {
                if (rs.next()) {
                    id = rs.getInt(1);
                }
            }

            try (PreparedStatement ps = con.prepareStatement(q1)) {
                ps.setInt(1, id);
                ps.setInt(2, collegeId);
                ps.setString(3, name);
                ps.setString(4, email);
                ps.setString(5, password);

                int x = ps.executeUpdate();
                return x > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean LoginMethod() {

        boolean x = false;
        String sql = "SELECT ADMIN_ID, COLLEGE_ID, NAME FROM COLLEGE_ADMIN WHERE LOWER(EMAIL)=LOWER(?) AND PASSWORD=?";

        try (Connection con = com.campusconnect.util.DBConnection.getConnection()) {

            if (con == null) return false;

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        adminId = rs.getInt("ADMIN_ID");
                        collegeId = rs.getInt("COLLEGE_ID");
                        name = rs.getString("NAME");
                        x = true;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return x;
    }
}