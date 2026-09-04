package com.campusconnect.dao;

import com.campusconnect.bean.Company;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.*;

public class CompanyDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. ADD COMPANY
    //====================================
    public boolean addCompany(Company company) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO companies (company_id, company_name, industry, website, email, phone, address, description, contact_person, status) VALUES (company_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getIndustry());
            ps.setString(3, company.getWebsite());
            ps.setString(4, company.getEmail());
            ps.setString(5, company.getPhone());
            ps.setString(6, company.getAddress());
            ps.setString(7, company.getDescription());
            ps.setString(8, company.getContactPerson());
            ps.setString(9, company.getStatus());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return status;
    }

    //====================================
    // 2. GET ALL COMPANIES
    //====================================
    public List<Company> getAllCompanies() {
        List<Company> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM companies ORDER BY company_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                Company company = new Company();
                company.setCompanyId(rs.getInt("company_id"));
                company.setCompanyName(rs.getString("company_name"));
                company.setIndustry(rs.getString("industry"));
                company.setWebsite(rs.getString("website"));
                company.setEmail(rs.getString("email"));
                company.setPhone(rs.getString("phone"));
                company.setAddress(rs.getString("address"));
                company.setDescription(rs.getString("description"));
                company.setContactPerson(rs.getString("contact_person"));
                company.setStatus(rs.getString("status"));
                company.setCreatedDate(rs.getTimestamp("created_date"));
                list.add(company);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    //====================================
    // 3. GET COMPANY BY ID
    //====================================
    public Company getCompanyById(int companyId) {
        Company company = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM companies WHERE company_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, companyId);
            rs = ps.executeQuery();

            if(rs.next()) {
                company = new Company();
                company.setCompanyId(rs.getInt("company_id"));
                company.setCompanyName(rs.getString("company_name"));
                company.setIndustry(rs.getString("industry"));
                company.setWebsite(rs.getString("website"));
                company.setEmail(rs.getString("email"));
                company.setPhone(rs.getString("phone"));
                company.setAddress(rs.getString("address"));
                company.setDescription(rs.getString("description"));
                company.setContactPerson(rs.getString("contact_person"));
                company.setStatus(rs.getString("status"));
                company.setCreatedDate(rs.getTimestamp("created_date"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return company;
    }

    //====================================
    // 4. UPDATE COMPANY
    //====================================
    public boolean updateCompany(Company company) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE companies SET company_name=?, industry=?, website=?, email=?, phone=?, address=?, description=?, contact_person=?, status=? WHERE company_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getIndustry());
            ps.setString(3, company.getWebsite());
            ps.setString(4, company.getEmail());
            ps.setString(5, company.getPhone());
            ps.setString(6, company.getAddress());
            ps.setString(7, company.getDescription());
            ps.setString(8, company.getContactPerson());
            ps.setString(9, company.getStatus());
            ps.setInt(10, company.getCompanyId());

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return status;
    }

    //====================================
    // 5. DELETE COMPANY
    //====================================
    public boolean deleteCompany(int companyId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM companies WHERE company_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, companyId);

            int rows = ps.executeUpdate();
            if(rows > 0) {
                status = true;
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return status;
    }

    //====================================
    // HELPER METHOD TO CLOSE RESOURCES
    //====================================
    private void closeResources() {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(ps != null) ps.close(); } catch(Exception e) {}
        try { if(con != null) con.close(); } catch(Exception e) {}
    }
}