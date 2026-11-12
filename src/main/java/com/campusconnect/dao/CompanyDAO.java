
package com.campusconnect.dao;

import java.sql.*;
import java.util.ArrayList;

import com.campusconnect.bean.Company;
import com.campusconnect.util.DBConnection;

public class CompanyDAO {

    // ==========================================
    // COMPANY REGISTRATION METHOD
    // ==========================================
    public boolean insertCompany(Company c) {

        String sql = "INSERT INTO COMPANY " +
                     "(COMPANY_ID, COMPANY_NAME, EMAIL, PHONE, PASSWORD, ADDRESS, WEBSITE, STATUS) " +
                     "VALUES (COMPANY_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getCompanyName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getPassword());
            ps.setString(5, c.getAddress());
            ps.setString(6, c.getWebsite());
            ps.setString(7, c.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    // ==========================================
    // COMPANY LOGIN METHOD
    // ==========================================
    public Company loginCompany(String email, String password) {

        Company c = null;

        String sql = "SELECT COMPANY_ID, COMPANY_NAME, EMAIL, PHONE, PASSWORD, " +
                     "ADDRESS, WEBSITE, STATUS, LOGO, BANNER " +
                     "FROM COMPANY WHERE EMAIL = ? AND PASSWORD = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

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

                    // Correct Oracle column names
                    c.setLogoUrl(rs.getString("LOGO"));
                    c.setBannerUrl(rs.getString("BANNER"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }


    // ==========================================
    // SUPER ADMIN - GET ALL COMPANIES
    // ==========================================
    public ArrayList<Company> getAllCompanies() {

        ArrayList<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM COMPANY";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ==========================================
    // SUPER ADMIN - APPROVE COMPANY
    // ==========================================
    public boolean approveCompany(int companyId) {

        String sql = "UPDATE COMPANY SET STATUS='Approved' WHERE COMPANY_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    // ==========================================
    // SUPER ADMIN - REJECT COMPANY
    // ==========================================
    public boolean rejectCompany(int companyId) {

        String sql = "UPDATE COMPANY SET STATUS='Rejected' WHERE COMPANY_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
