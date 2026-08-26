package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.User;
import com.campusconnect.util.DBConnection;

public class UserDAO {

    // View All Users
    public ArrayList<User> getAllUsers() {

        ArrayList<User> list = new ArrayList<User>();

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM USERS ORDER BY USER_ID";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("USER_ID"));
                user.setName(rs.getString("NAME"));
                user.setEmail(rs.getString("EMAIL"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRole(rs.getString("ROLE"));
                user.setStatus(rs.getString("STATUS"));

                list.add(user);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Activate User
    public boolean activateUser(int userId) {

        boolean flag = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "UPDATE USERS SET STATUS='ACTIVE' WHERE USER_ID=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            int i = ps.executeUpdate();

            if (i > 0) {
                flag = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    // Deactivate User
    public boolean deactivateUser(int userId) {

        boolean flag = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                    "UPDATE USERS SET STATUS='INACTIVE' WHERE USER_ID=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            int i = ps.executeUpdate();

            if (i > 0) {
                flag = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

}