 package com.campusconnect.dao;

import com.campusconnect.bean.SuperAdmin;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.campusconnect.util.DBConnection;

public class SuperAdminDAO {

    public SuperAdmin login(String email, String password) {
        SuperAdmin admin = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();

            String sql = "SELECT ADMIN_ID, NAME, EMAIL, PASSWORD, STATUS FROM SUPER_ADMIN WHERE EMAIL=? AND PASSWORD=? AND STATUS='ACTIVE'";

            ps = con.prepareStatement(sql);
            ps.setString(1, email);   
            ps.setString(2, password);
            rs = ps.executeQuery();

            if(rs.next()) {
                admin = new SuperAdmin();
                admin.setAdminId(rs.getInt("ADMIN_ID"));
                admin.setName(rs.getString("NAME"));
                admin.setEmail(rs.getString("EMAIL"));
                admin.setPassword(rs.getString("PASSWORD"));
                admin.setStatus(rs.getString("STATUS")); 
            }
          
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e){}
            try { if(ps != null) ps.close(); } catch(Exception e){}
            try { if(con != null) con.close(); } catch(Exception e){}
        }
        return admin;
    } 

} 