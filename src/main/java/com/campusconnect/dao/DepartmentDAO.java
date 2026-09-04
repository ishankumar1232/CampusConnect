package com.campusconnect.dao;

import com.campusconnect.bean.Department;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. ADD DEPARTMENT
    //====================================
    public boolean addDepartment(Department dept) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO DEPARTMENT VALUES"
                       + "(department_seq.NEXTVAL,?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, dept.getCollegeId());
            ps.setString(2, dept.getDepartmentName());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Department Added Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 2. GET ALL DEPARTMENTS
    //====================================
    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM DEPARTMENT";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                Department dept = new Department();
                dept.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                dept.setCollegeId(rs.getInt("COLLEGE_ID"));
                dept.setDepartmentName(rs.getString("DEPARTMENT_NAME"));
                list.add(dept);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //====================================
    // 3. GET DEPARTMENT BY ID
    //====================================
    public Department getDepartmentById(int departmentId) {
        Department dept = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM DEPARTMENT"
                       + " WHERE DEPARTMENT_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, departmentId);
            rs = ps.executeQuery();

            if(rs.next()) {
                dept = new Department();
                dept.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                dept.setCollegeId(rs.getInt("COLLEGE_ID"));
                dept.setDepartmentName(rs.getString("DEPARTMENT_NAME"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return dept;
    }

    //====================================
    // 4. GET DEPARTMENTS BY COLLEGE ID
    //====================================
    public List<Department> getDepartmentsByCollegeId(int collegeId) {
        List<Department> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM DEPARTMENT"
                       + " WHERE COLLEGE_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            while(rs.next()) {
                Department dept = new Department();
                dept.setDepartmentId(rs.getInt("DEPARTMENT_ID"));
                dept.setCollegeId(rs.getInt("COLLEGE_ID"));
                dept.setDepartmentName(rs.getString("DEPARTMENT_NAME"));
                list.add(dept);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //====================================
    // 5. UPDATE DEPARTMENT
    //====================================
    public boolean updateDepartment(Department dept) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE DEPARTMENT SET"
                       + " COLLEGE_ID=?,"
                       + " DEPARTMENT_NAME=?"
                       + " WHERE DEPARTMENT_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, dept.getCollegeId());
            ps.setString(2, dept.getDepartmentName());
            ps.setInt(3, dept.getDepartmentId());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Department Updated Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 6. DELETE DEPARTMENT
    //====================================
    public boolean deleteDepartment(int departmentId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM DEPARTMENT"
                       + " WHERE DEPARTMENT_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, departmentId);

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Department Deleted Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
}