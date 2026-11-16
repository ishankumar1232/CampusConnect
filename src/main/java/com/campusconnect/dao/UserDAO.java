package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.User;
import com.campusconnect.util.DBConnection;

public class UserDAO {

    // View All Users across platform roles
    public ArrayList<User> getAllUsers() {

        ArrayList<User> list = new ArrayList<User>();

        String sql =
                "SELECT ADMIN_ID AS USER_ID, NAME, EMAIL, PASSWORD, 'COLLEGE_ADMIN' AS ROLE, 'ACTIVE' AS STATUS, COLLEGE_ID AS ENTITY_ID FROM COLLEGE_ADMIN " +
                "UNION ALL " +
                "SELECT COMPANY_ID AS USER_ID, COMPANY_NAME AS NAME, EMAIL, PASSWORD, 'COMPANY' AS ROLE, NVL(STATUS, 'Pending') AS STATUS, COMPANY_ID AS ENTITY_ID FROM COMPANY " +
                "UNION ALL " +
                "SELECT STUDENT_ID AS USER_ID, NAME, EMAIL, PASSWORD, 'STUDENT' AS ROLE, NVL(STATUS, 'ACTIVE') AS STATUS, STUDENT_ID AS ENTITY_ID FROM STUDENT " +
                "UNION ALL " +
                "SELECT ADMIN_ID AS USER_ID, NAME, EMAIL, PASSWORD, 'SUPER_ADMIN' AS ROLE, NVL(STATUS, 'ACTIVE') AS STATUS, ADMIN_ID AS ENTITY_ID FROM SUPER_ADMIN " +
                "ORDER BY USER_ID";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("USER_ID"));
                user.setName(rs.getString("NAME"));
                user.setEmail(rs.getString("EMAIL"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRole(rs.getString("ROLE"));
                user.setStatus(rs.getString("STATUS"));
                user.setEntityId(rs.getInt("ENTITY_ID"));

                list.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Activate User
    public boolean activateUser(int userId) {

        boolean flag = false;

        try (Connection con = DBConnection.getConnection()) {

            String sqlStudent = "UPDATE STUDENT SET STATUS='ACTIVE' WHERE STUDENT_ID=?";
            try (PreparedStatement ps = con.prepareStatement(sqlStudent)) {
                ps.setInt(1, userId);
                if (ps.executeUpdate() > 0) flag = true;
            }

            String sqlCompany = "UPDATE COMPANY SET STATUS='Approved' WHERE COMPANY_ID=?";
            try (PreparedStatement ps = con.prepareStatement(sqlCompany)) {
                ps.setInt(1, userId);
                if (ps.executeUpdate() > 0) flag = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    // Activate User with Role Filtering
    public boolean activateUser(int userId, String role) {
        if (role == null || role.trim().isEmpty()) {
            return activateUser(userId);
        }
        boolean flag = false;
        try (Connection con = DBConnection.getConnection()) {
            if ("STUDENT".equalsIgnoreCase(role)) {
                String sql = "UPDATE STUDENT SET STATUS='ACTIVE' WHERE STUDENT_ID=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    if (ps.executeUpdate() > 0) flag = true;
                }
            } else if ("COMPANY".equalsIgnoreCase(role)) {
                String sql = "UPDATE COMPANY SET STATUS='Approved' WHERE COMPANY_ID=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    if (ps.executeUpdate() > 0) flag = true;
                }
            } else if ("COLLEGE_ADMIN".equalsIgnoreCase(role)) {
                String sql = "UPDATE COLLEGE SET STATUS='Approved' WHERE COLLEGE_ID=(SELECT COLLEGE_ID FROM COLLEGE_ADMIN WHERE ADMIN_ID=?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    if (ps.executeUpdate() > 0) flag = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }

    // Deactivate User
    public boolean deactivateUser(int userId) {

        boolean flag = false;

        try (Connection con = DBConnection.getConnection()) {

            String sqlStudent = "UPDATE STUDENT SET STATUS='INACTIVE' WHERE STUDENT_ID=?";
            try (PreparedStatement ps = con.prepareStatement(sqlStudent)) {
                ps.setInt(1, userId);
                if (ps.executeUpdate() > 0) flag = true;
            }

            String sqlCompany = "UPDATE COMPANY SET STATUS='Rejected' WHERE COMPANY_ID=?";
            try (PreparedStatement ps = con.prepareStatement(sqlCompany)) {
                ps.setInt(1, userId);
                if (ps.executeUpdate() > 0) flag = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    // Deactivate User with Role Filtering
    public boolean deactivateUser(int userId, String role) {
        if (role == null || role.trim().isEmpty()) {
            return deactivateUser(userId);
        }
        boolean flag = false;
        try (Connection con = DBConnection.getConnection()) {
            if ("STUDENT".equalsIgnoreCase(role)) {
                String sql = "UPDATE STUDENT SET STATUS='INACTIVE' WHERE STUDENT_ID=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    if (ps.executeUpdate() > 0) flag = true;
                }
            } else if ("COMPANY".equalsIgnoreCase(role)) {
                String sql = "UPDATE COMPANY SET STATUS='Rejected' WHERE COMPANY_ID=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    if (ps.executeUpdate() > 0) flag = true;
                }
            } else if ("COLLEGE_ADMIN".equalsIgnoreCase(role)) {
                String sql = "UPDATE COLLEGE SET STATUS='Rejected' WHERE COLLEGE_ID=(SELECT COLLEGE_ID FROM COLLEGE_ADMIN WHERE ADMIN_ID=?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    if (ps.executeUpdate() > 0) flag = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }

    // Assign / Create College Admin for a College
    public int createCollegeAdmin(int collegeId, String name, String email, String password) {
        int adminId = -1;
        String seqSql = "SELECT NVL(MAX(ADMIN_ID), 0) + 1 FROM COLLEGE_ADMIN";
        String insSql = "INSERT INTO COLLEGE_ADMIN (ADMIN_ID, COLLEGE_ID, NAME, EMAIL, PASSWORD) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement psSeq = con.prepareStatement(seqSql);
             ResultSet rs = psSeq.executeQuery()) {
            if (rs.next()) {
                adminId = rs.getInt(1);
            }
            try (PreparedStatement ps = con.prepareStatement(insSql)) {
                ps.setInt(1, adminId);
                ps.setInt(2, collegeId);
                ps.setString(3, name);
                ps.setString(4, email);
                ps.setString(5, password);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
        return adminId;
    }

}