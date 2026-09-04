package com.campusconnect.dao;

import com.campusconnect.bean.Faculty;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FacultyDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. ADD FACULTY
    //====================================
    public boolean addFaculty(Faculty faculty) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO FACULTY VALUES"
                       + "(faculty_seq.NEXTVAL,?,?,?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, faculty.getCollegeId());
            ps.setInt(2, faculty.getDepartmentId());
            ps.setString(3, faculty.getName());
            ps.setString(4, faculty.getEmail());
            ps.setString(5, faculty.getPhone());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Faculty Added Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 2. GET ALL FACULTY
    //====================================
    public List<Faculty> getAllFaculty() {
        List<Faculty> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM FACULTY";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                Faculty f = new Faculty();
                f.setFacultyId(rs.getInt("FACULTY_ID"));
                f.setCollegeId(rs.getInt("COLLEGE_ID"));
                f.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                f.setName(rs.getString("NAME"));
                f.setEmail(rs.getString("EMAIL"));
                f.setPhone(rs.getString("PHONE"));
                list.add(f);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //====================================
    // 3. GET FACULTY BY ID
    //====================================
    public Faculty getFacultyById(int facultyId) {
        Faculty faculty = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM FACULTY"
                       + " WHERE FACULTY_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, facultyId);
            rs = ps.executeQuery();

            if(rs.next()) {
                faculty = new Faculty();
                faculty.setFacultyId(rs.getInt("FACULTY_ID"));
                faculty.setCollegeId(rs.getInt("COLLEGE_ID"));
                faculty.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                faculty.setName(rs.getString("NAME"));
                faculty.setEmail(rs.getString("EMAIL"));
                faculty.setPhone(rs.getString("PHONE"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return faculty;
    }

    //====================================
    // 4. GET FACULTY BY COLLEGE ID
    //====================================
    public List<Faculty> getFacultyByCollegeId(int collegeId) {
        List<Faculty> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM FACULTY"
                       + " WHERE COLLEGE_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            while(rs.next()) {
                Faculty f = new Faculty();
                f.setFacultyId(rs.getInt("FACULTY_ID"));
                f.setCollegeId(rs.getInt("COLLEGE_ID"));
                f.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                f.setName(rs.getString("NAME"));
                f.setEmail(rs.getString("EMAIL"));
                f.setPhone(rs.getString("PHONE"));
                list.add(f);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //====================================
    // 5. UPDATE FACULTY
    //====================================
    public boolean updateFaculty(Faculty faculty) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE FACULTY SET"
                       + " COLLEGE_ID=?,"
                       + " DEPARTMENT_ID=?,"
                       + " NAME=?,"
                       + " EMAIL=?,"
                       + " PHONE=?"
                       + " WHERE FACULTY_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, faculty.getCollegeId());
            ps.setInt(2, faculty.getDepartmentId());
            ps.setString(3, faculty.getName());
            ps.setString(4, faculty.getEmail());
            ps.setString(5, faculty.getPhone());
            ps.setInt(6, faculty.getFacultyId());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Faculty Updated Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 6. DELETE FACULTY
    //====================================
    public boolean deleteFaculty(int facultyId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM FACULTY"
                       + " WHERE FACULTY_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, facultyId);

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Faculty Deleted Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
}