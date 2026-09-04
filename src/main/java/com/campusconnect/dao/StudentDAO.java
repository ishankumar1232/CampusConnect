package com.campusconnect.dao;

import com.campusconnect.bean.Student;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.*;

public class StudentDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. ADD STUDENT
    //====================================
    public boolean addStudent(Student student) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO students (student_id, name, email, password, phone, college_id, department_id, course_id, year, cgpa, status) VALUES (student_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPassword());
            ps.setString(4, student.getPhone());
            ps.setInt(5, student.getCollegeId());
            ps.setInt(6, student.getDepartmentId());
            ps.setInt(7, student.getCourseId());
            ps.setInt(8, student.getYear());
            ps.setDouble(9, student.getCgpa());
            ps.setString(10, student.getStatus());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Student Added Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    //====================================
    // 2. GET ALL STUDENTS
    //====================================
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM students ORDER BY student_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                Student student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setName(rs.getString("name"));
                student.setEmail(rs.getString("email"));
                student.setPassword(rs.getString("password"));
                student.setPhone(rs.getString("phone"));
                student.setCollegeId(rs.getInt("college_id"));
                student.setDepartmentId(rs.getInt("department_id"));
                student.setCourseId(rs.getInt("course_id"));
                student.setYear(rs.getInt("year"));
                student.setCgpa(rs.getDouble("cgpa"));
                student.setStatus(rs.getString("status"));
                list.add(student);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return list;
    }

    //====================================
    // 3. GET STUDENT BY ID
    //====================================
    public Student getStudentById(int studentId) {
        Student student = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM students WHERE student_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if(rs.next()) {
                student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setName(rs.getString("name"));
                student.setEmail(rs.getString("email"));
                student.setPassword(rs.getString("password"));
                student.setPhone(rs.getString("phone"));
                student.setCollegeId(rs.getInt("college_id"));
                student.setDepartmentId(rs.getInt("department_id"));
                student.setCourseId(rs.getInt("course_id"));
                student.setYear(rs.getInt("year"));
                student.setCgpa(rs.getDouble("cgpa"));
                student.setStatus(rs.getString("status"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return student;
    }

    //====================================
    // 4. UPDATE STUDENT
    //====================================
    public boolean updateStudent(Student student) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE students SET name=?, email=?, phone=?, college_id=?, department_id=?, course_id=?, year=?, cgpa=?, status=? WHERE student_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPhone());
            ps.setInt(4, student.getCollegeId());
            ps.setInt(5, student.getDepartmentId());
            ps.setInt(6, student.getCourseId());
            ps.setInt(7, student.getYear());
            ps.setDouble(8, student.getCgpa());
            ps.setString(9, student.getStatus());
            ps.setInt(10, student.getStudentId());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Student Updated Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    //====================================
    // 5. DELETE STUDENT
    //====================================
    public boolean deleteStudent(int studentId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM students WHERE student_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Student Deleted Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }
}