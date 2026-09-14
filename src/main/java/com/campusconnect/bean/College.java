package com.campusconnect.bean;

import java.sql.*;

public class College {

    private int collegeId;
    private String collegeName;
    private String address;
    private String city;
    private String state;
    private String email;
    private String phone;
    private String status;


    public College() {

    }


    public College(int collegeId, String collegeName, String address,
                   String city, String state, String email,
                   String phone, String status) {

        this.collegeId = collegeId;
        this.collegeName = collegeName;
        this.address = address;
        this.city = city;
        this.state = state;
        this.email = email;
        this.phone = phone;
        this.status = status;
    }


    public int getCollegeId() {
        return collegeId;
    }

    public void setCollegeId(int collegeId) {
        this.collegeId = collegeId;
    }


    public String getCollegeName() {
        return collegeName;
    }

    public void setCollegeName(String collegeName) {
        this.collegeName = collegeName;
    }


    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }


    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }


    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    // Get College Name

    public String getCollegeNameById(int id) {

        String name = "";

        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql =
                "SELECT COLLEGE_NAME FROM COLLEGE WHERE COLLEGE_ID=?";

            PreparedStatement ps =
                con.prepareStatement(sql);

            ps.setInt(1, id);

            ResultSet rs =
                ps.executeQuery();

            if(rs.next()) {

                name = rs.getString("COLLEGE_NAME");

            }

            rs.close();
            ps.close();
            con.close();

        }
        catch(Exception e) {

            e.printStackTrace();

        }

        return name;
    }


    @Override
    public String toString() {

        return collegeId + " " +
               collegeName + " " +
               address + " " +
               city + " " +
               state + " " +
               email + " " +
               phone + " " +
               status;
    }

}