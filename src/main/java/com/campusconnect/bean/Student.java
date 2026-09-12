package com.campusconnect.bean;

import java.sql.*;

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

    public Student() {
    }

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


    // Insert Student Record

    public boolean InsertMethod()
    {
        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();


            // Generate Student ID

            String qid =
                "SELECT NVL(MAX(STUDENT_ID),0)+1 FROM STUDENT";

            ResultSet rs = stmt.executeQuery(qid);

            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            // Insert Query

            String q1 =
                "INSERT INTO STUDENT "
                + "(STUDENT_ID, COLLEGE_ID, COURSE_ID, NAME, EMAIL, "
                + "PHONE, PASSWORD, DOB, GENDER, ADDRESS, "
                + "ADMISSION_DATE, STATUS) "
                + "VALUES ("
                + id + ", "
                + collegeId + ", "
                + courseId + ", '"
                + name + "', '"
                + email + "', '"
                + phone + "', '"
                + password + "', "
                + "TO_DATE('" + dob + "','YYYY-MM-DD'), '"
                + gender + "', '"
                + address + "', "
                + "SYSDATE, "
                + "'ACTIVE')";


            int x = stmt.executeUpdate(q1);


            if(x > 0)
            {
                con.close();
                return true;
            }
            else
            {
                con.close();
                return false;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }
    public boolean LoginMethod()
    {
        boolean result = false;

        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();

            String q1 = "SELECT STUDENT_ID FROM STUDENT "
                      + "WHERE EMAIL='" + email + "' "
                      + "AND PASSWORD='" + password + "' "
                      + "AND STATUS='ACTIVE'";

            ResultSet rs = stmt.executeQuery(q1);

            if(rs.next())
            {
                studentId = rs.getInt("STUDENT_ID");
                result = true;
            }

            rs.close();
            stmt.close();
            con.close();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return result;
    }
}