package com.campusconnect.dao;

import java.sql.*;
import java.util.ArrayList;

import com.campusconnect.bean.Company;
import com.campusconnect.util.DBConnection;

public class CompanyDAO {

    // =====================================================
    // KRISHNA METHOD - COMPANY REGISTRATION
    // =====================================================
    public boolean insertCompany(Company c) {

        try {

            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();

            String q1 = "INSERT INTO COMPANY " +
                        "(COMPANY_ID, COMPANY_NAME, EMAIL, PHONE, PASSWORD, ADDRESS, WEBSITE, STATUS) " +
                        "VALUES (COMPANY_SEQ.NEXTVAL, '" +
                        c.getCompanyName() + "', '" +
                        c.getEmail() + "', '" +
                        c.getPhone() + "', '" +
                        c.getPassword() + "', '" +
                        c.getAddress() + "', '" +
                        c.getWebsite() + "', '" +
                        c.getStatus() + "')";

            int x = stmt.executeUpdate(q1);

            con.close();

            return x > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    // =====================================================
    // KRISHNA METHOD - COMPANY LOGIN
    // =====================================================
    public Company loginCompany(String email, String password) {

        Company c = null;

        try {

            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();

            String q1 = "SELECT * FROM COMPANY " +
                        "WHERE EMAIL = '" + email + "' " +
                        "AND PASSWORD = '" + password + "'";

            ResultSet rs = stmt.executeQuery(q1);

            if (rs.next()) {

                c = new Company();

                c.setCompanyId(rs.getInt("COMPANY_ID"));
                c.setCompanyName(rs.getString("COMPANY_NAME"));
                c.setEmail(rs.getString("EMAIL"));
                c.setPhone(rs.getString("PHONE"));
                c.setPassword(rs.getString("PASSWORD"));
                c.setAddress(rs.getString("ADDRESS"));
                c.setWebsite(rs.getString("WEBSITE"));
                c.setStatus(rs.getString("STATUS"));
            }

            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return c;
    }


    // =====================================================
    // SUPER ADMIN METHOD - GET ALL COMPANIES
    // =====================================================
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


    // =====================================================
    // SUPER ADMIN METHOD - APPROVE COMPANY
    // =====================================================
    public boolean approveCompany(int companyId) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                "UPDATE COMPANY SET STATUS='Approved' " +
                "WHERE COMPANY_ID=?";

            PreparedStatement ps =
                con.prepareStatement(sql);

            ps.setInt(1, companyId);

            int i = ps.executeUpdate();

            if (i > 0) {
                status = true;
            }

            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return status;
    }


    // =====================================================
    // SUPER ADMIN METHOD - REJECT COMPANY
    // =====================================================
    public boolean rejectCompany(int companyId) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String sql =
                "UPDATE COMPANY SET STATUS='Rejected' " +
                "WHERE COMPANY_ID=?";

            PreparedStatement ps =
                con.prepareStatement(sql);

            ps.setInt(1, companyId);

            int i = ps.executeUpdate();

            if (i > 0) {
                status = true;
            }

            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return status;
    }

}