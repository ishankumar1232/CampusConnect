package com.campusconnect.bean;

import java.sql.*;
import com.campusconnect.util.DBConnection;

public class Student {

    private int studentId;
    private int collegeId;
    private int courseId;
    private String name;
    private String email;
    private String phone;
    private String password;
    private Date dob;
    private String gender;
    private String address;
    private Date admissionDate;
    private String status;
    private String profileImage;
    private String placementStatus;
    private String collegeName;
    private String courseName;

    public Student() {

    }

    // Getters and Setters

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getCollegeId() {
        return collegeId;
    }

    public void setCollegeId(int collegeId) {
        this.collegeId = collegeId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getAdmissionDate() {
        return admissionDate;
    }

    public void setAdmissionDate(Date admissionDate) {
        this.admissionDate = admissionDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getPlacementStatus() {
    return placementStatus;
    }

    public void setPlacementStatus(String placementStatus) {
    this.placementStatus = placementStatus;
    }
    
 // ================= COLLEGE NAME =================

    public String getCollegeName() {
        return collegeName;
    }

    public void setCollegeName(String collegeName) {
        this.collegeName = collegeName;
    }

    // ================= COURSE NAME =================

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    // Student Registration

    public boolean InsertMethod() {

        String qid = "SELECT NVL(MAX(STUDENT_ID),0)+1 FROM STUDENT";
        String q1 =
            "INSERT INTO STUDENT " +
            "(STUDENT_ID, COLLEGE_ID, COURSE_ID, NAME, EMAIL, " +
            "PHONE, PASSWORD, DOB, GENDER, ADDRESS, " +
            "ADMISSION_DATE, STATUS) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, 'ACTIVE')";

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(qid)) {

            int id = 1;

            if(rs.next()) {
                id = rs.getInt(1);
            }
            this.studentId = id;

            try (PreparedStatement ps = con.prepareStatement(q1)) {
                ps.setInt(1, id);
                ps.setInt(2, collegeId);
                ps.setInt(3, courseId);
                ps.setString(4, name);
                ps.setString(5, email);
                ps.setString(6, phone);
                ps.setString(7, password);
                ps.setDate(8, dob);
                ps.setString(9, gender);
                ps.setString(10, address);

                int x = ps.executeUpdate();
                return x > 0;
            }

        }
        catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Student Login
    public boolean LoginMethod() {

        String sql =
            "SELECT STUDENT_ID, NAME, COLLEGE_ID, COURSE_ID, " +
            "EMAIL, PHONE, PROFILE_IMAGE " +
            "FROM STUDENT " +
            "WHERE LOWER(EMAIL) = LOWER(?) " +
            "AND PASSWORD = ? " +
            "AND (STATUS = 'ACTIVE' OR STATUS IS NULL)";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    this.studentId = rs.getInt("STUDENT_ID");
                    this.name = rs.getString("NAME");
                    this.collegeId = rs.getInt("COLLEGE_ID");
                    this.courseId = rs.getInt("COURSE_ID");
                    this.email = rs.getString("EMAIL");
                    this.phone = rs.getString("PHONE");
                    this.profileImage = rs.getString("PROFILE_IMAGE");

                    return true;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Total Students of a College

    public int getStudentCount(int collegeId) {

        int count = 0;
        String sql = "SELECT COUNT(*) FROM STUDENT WHERE COLLEGE_ID=?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, collegeId);

            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    count = rs.getInt(1);
                }
            }

        }
        catch(Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    // Update Student Profile
    public boolean updateProfile() {

        String sql =
            "UPDATE STUDENT SET " +
            "NAME=?, PHONE=?, DOB=?, GENDER=?, ADDRESS=? " +
            "WHERE STUDENT_ID=?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setDate(3, dob);
            ps.setString(4, gender);
            ps.setString(5, address);
            ps.setInt(6, studentId);

            int x = ps.executeUpdate();
            return x > 0;

        }
        catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update Profile Image
    public boolean updateProfileImage() {

        String sql =
            "UPDATE STUDENT SET PROFILE_IMAGE=? " +
            "WHERE STUDENT_ID=?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, profileImage);
            ps.setInt(2, studentId);

            int x = ps.executeUpdate();
            return x > 0;

        }
        catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public int InsertNewStudent(Connection con) throws Exception
    {
        int newId = 1;

        PreparedStatement ps1 = con.prepareStatement(
            "SELECT NVL(MAX(STUDENT_ID),0)+1 FROM STUDENT"
        );

        ResultSet rs = ps1.executeQuery();

        if(rs.next())
        {
            newId = rs.getInt(1);
        }

        rs.close();
        ps1.close();

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO STUDENT " +
            "(STUDENT_ID, COLLEGE_ID, COURSE_ID, NAME, EMAIL, PHONE, PASSWORD, " +
            "DOB, GENDER, ADDRESS, ADMISSION_DATE, STATUS) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,SYSDATE,'ACTIVE')"
        );

        ps.setInt(1, newId);
        ps.setInt(2, collegeId);
        ps.setInt(3, courseId);
        ps.setString(4, name);
        ps.setString(5, email);
        ps.setString(6, phone);
        ps.setString(7, password);
        ps.setDate(8, dob);
        ps.setString(9, gender);
        ps.setString(10, address);

        ps.executeUpdate();
        ps.close();

        return newId;
    }
}