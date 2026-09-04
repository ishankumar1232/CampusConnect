package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.Student;
import com.campusconnect.util.DBConnection;

public class StudentDAO {

    // Get All Students
    public ArrayList<Student> getAllStudents() {

        ArrayList<Student> list = new ArrayList<Student>();

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM STUDENT";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Student s = new Student();

                s.setStudentId(rs.getInt("STUDENT_ID"));
                s.setCollegeId(rs.getInt("COLLEGE_ID"));
                s.setCourseId(rs.getInt("COURSE_ID"));
                s.setName(rs.getString("NAME"));
                s.setEmail(rs.getString("EMAIL"));
                s.setPhone(rs.getString("PHONE"));
                s.setGender(rs.getString("GENDER"));
                s.setStatus(rs.getString("STATUS"));

                list.add(s);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }


    // Activate Student
    public boolean activateStudent(int id) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "UPDATE STUDENT SET STATUS='ACTIVE' WHERE STUDENT_ID=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            if (ps.executeUpdate() > 0) {
                status = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return status;
    }


    // Deactivate Student
    public boolean deactivateStudent(int id) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "UPDATE STUDENT SET STATUS='INACTIVE' WHERE STUDENT_ID=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            if (ps.executeUpdate() > 0) {
                status = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return status;
    }


    // Get Student By ID
    public Student getStudentById(int id) {

        Student s = null;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "SELECT * FROM STUDENT WHERE STUDENT_ID=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                s = new Student();

                s.setStudentId(rs.getInt("STUDENT_ID"));
                s.setCollegeId(rs.getInt("COLLEGE_ID"));
                s.setCourseId(rs.getInt("COURSE_ID"));
                s.setName(rs.getString("NAME"));
                s.setEmail(rs.getString("EMAIL"));
                s.setPhone(rs.getString("PHONE"));
                s.setGender(rs.getString("GENDER"));
                s.setStatus(rs.getString("STATUS"));
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return s;
    }

}