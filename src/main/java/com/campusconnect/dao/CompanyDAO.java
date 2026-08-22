 package com.campusconnect.dao;

import java.sql.*;
import java.util.ArrayList;

import com.campusconnect.bean.Company;
import com.campusconnect.util.DBConnection;

public class CompanyDAO {

   
    public ArrayList<Company> getAllCompanies() {
        ArrayList<Company> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM COMPANY";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Company c = new Company();
                c.setCompanyId(rs.getInt("COMPANY_ID"));
                c.setCompanyName(rs.getString("COMPANY_NAME"));
                c.setEmail(rs.getString("EMAIL"));
                c.setPhone(rs.getString("PHONE"));
                c.setPassword(rs.getString("PASSWORD"));
                c.setAddress(rs.getString("ADDRESS"));
                c.setWebsite(rs.getString("WEBSITE"));
                c.setStatus(rs.getString("STATUS"));
                list.add(c);
            }
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //  APPROVE METHOD
    public boolean approveCompany(int companyId) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE COMPANY SET STATUS='Approved' WHERE COMPANY_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, companyId);
            int i = ps.executeUpdate();
            if(i > 0) {
                status = true;
            }
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
    //  REJECT METHOD
    public boolean rejectCompany(int companyId) {
        boolean status = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE COMPANY SET STATUS='Rejected' WHERE COMPANY_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, companyId);
            int i = ps.executeUpdate();
            if(i > 0) {
                status = true;
            }
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}