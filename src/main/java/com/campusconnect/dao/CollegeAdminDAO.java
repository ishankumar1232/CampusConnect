package com.campusconnect.dao;

import com.campusconnect.bean.CollegeAdmin;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CollegeAdminDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. ADD ADMIN
    //====================================
    public boolean addAdmin(CollegeAdmin admin) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO COLLEGE_ADMIN VALUES"
                       + "(admin_seq.NEXTVAL,?,?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, admin.getCollegeId());
            ps.setString(2, admin.getName());
            ps.setString(3, admin.getEmail());
            ps.setString(4, admin.getPassword());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Admin Added Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 2. GET ALL ADMINS
    //====================================
    public List<CollegeAdmin> getAllAdmins() {
        List<CollegeAdmin> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM COLLEGE_ADMIN";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                CollegeAdmin admin = new CollegeAdmin();
                admin.setAdminId(rs.getInt("ADMIN_ID"));
                admin.setCollegeId(rs.getInt("COLLEGE_ID"));
                admin.setName(rs.getString("NAME"));
                admin.setEmail(rs.getString("EMAIL"));
                admin.setPassword(rs.getString("PASSWORD"));
                list.add(admin);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //====================================
    // 3. GET ADMIN BY ID
    //====================================
    public CollegeAdmin getAdminById(int adminId) {
        CollegeAdmin admin = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM COLLEGE_ADMIN"
                       + " WHERE ADMIN_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, adminId);
            rs = ps.executeQuery();

            if(rs.next()) {
                admin = new CollegeAdmin();
                admin.setAdminId(rs.getInt("ADMIN_ID"));
                admin.setCollegeId(rs.getInt("COLLEGE_ID"));
                admin.setName(rs.getString("NAME"));
                admin.setEmail(rs.getString("EMAIL"));
                admin.setPassword(rs.getString("PASSWORD"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }

    //====================================
    // 4. ADMIN LOGIN
    //====================================
    public CollegeAdmin adminLogin(String email, String password) {
        CollegeAdmin admin = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM COLLEGE_ADMIN"
                       + " WHERE EMAIL=? AND PASSWORD=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if(rs.next()) {
                admin = new CollegeAdmin();
                admin.setAdminId(rs.getInt("ADMIN_ID"));
                admin.setCollegeId(rs.getInt("COLLEGE_ID"));
                admin.setName(rs.getString("NAME"));
                admin.setEmail(rs.getString("EMAIL"));
                admin.setPassword(rs.getString("PASSWORD"));
                admin.setCollegeName(rs.getString("COLLEGE_NAME"));  // ✅ ADDED THIS
                admin.setRole(rs.getString("ROLE"));
                admin.setStatus(rs.getString("STATUS"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }

    //====================================
    // 5. UPDATE ADMIN
    //====================================
    public boolean updateAdmin(CollegeAdmin admin) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE COLLEGE_ADMIN SET"
                       + " COLLEGE_ID=?,"
                       + " NAME=?,"
                       + " EMAIL=?,"
                       + " PASSWORD=?"
                       + " WHERE ADMIN_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, admin.getCollegeId());
            ps.setString(2, admin.getName());
            ps.setString(3, admin.getEmail());
            ps.setString(4, admin.getPassword());
            ps.setInt(5, admin.getAdminId());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Admin Updated Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    //====================================
    // 6. DELETE ADMIN
    //====================================
    public boolean deleteAdmin(int adminId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM COLLEGE_ADMIN"
                       + " WHERE ADMIN_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, adminId);

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
                System.out.println("Admin Deleted Successfully!");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
}