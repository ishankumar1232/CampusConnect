package com.campusconnect.dao;

import com.campusconnect.bean.Course;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. ADD COURSE
    //====================================
    public boolean addCourse(Course course) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO COURSE VALUES"
                       + "(course_seq.NEXTVAL,?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, course.getDepartmentId());
            ps.setString(2, course.getCourseName());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Course Added Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 2. GET ALL COURSES
    //====================================
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM COURSE";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("COURSE_ID"));
                course.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                course.setCourseName(rs.getString("COURSE_NAME"));
                list.add(course);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //====================================
    // 3. GET COURSE BY ID
    //====================================
    public Course getCourseById(int courseId) {
        Course course = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM COURSE"
                       + " WHERE COURSE_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();

            if(rs.next()) {
                course = new Course();
                course.setCourseId(rs.getInt("COURSE_ID"));
                course.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                course.setCourseName(rs.getString("COURSE_NAME"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return course;
    }

    //====================================
    // 4. GET COURSES BY DEPARTMENT ID
    //====================================
    public List<Course> getCoursesByDepartmentId(int departmentId) {
        List<Course> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM COURSE"
                       + " WHERE DEPARTMENT_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, departmentId);
            rs = ps.executeQuery();

            while(rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("COURSE_ID"));
                course.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                course.setCourseName(rs.getString("COURSE_NAME"));
                list.add(course);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //====================================
    // 5. UPDATE COURSE
    //====================================
    public boolean updateCourse(Course course) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE COURSE SET"
                       + " DEPARTMENT_ID=?,"
                       + " COURSE_NAME=?"
                       + " WHERE COURSE_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, course.getDepartmentId());
            ps.setString(2, course.getCourseName());
            ps.setInt(3, course.getCourseId());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Course Updated Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 6. DELETE COURSE
    //====================================
    public boolean deleteCourse(int courseId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM COURSE"
                       + " WHERE COURSE_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, courseId);

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Course Deleted Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
}