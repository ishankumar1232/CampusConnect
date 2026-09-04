package com.campusconnect.dao;

import com.campusconnect.bean.Drive;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class DriveDAO {
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Create a new drive
    public boolean createDrive(Drive drive) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO campus_drives (drive_id, company_id, college_id, drive_title, position, no_of_hires, eligibility_criteria, package_ctc, registration_deadline, drive_date, status, created_by) VALUES (drive_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            
            ps.setInt(1, drive.getCompanyId());
            ps.setInt(2, drive.getCollegeId());
            ps.setString(3, drive.getDriveTitle());
            ps.setString(4, drive.getPosition());
            ps.setInt(5, drive.getNoOfHires());
            ps.setString(6, drive.getEligibilityCriteria());
            ps.setDouble(7, drive.getPackageCtc());
            ps.setDate(8, new Date(drive.getRegistrationDeadline().getTime()));
            ps.setDate(9, new Date(drive.getDriveDate().getTime()));
            ps.setString(10, drive.getStatus());
            ps.setInt(11, drive.getCreatedBy());

            if(ps.executeUpdate() > 0) status = true;
        } catch(Exception e) { 
            e.printStackTrace(); 
        } finally {
            closeResources();
        }
        return status;
    }

    // Get all drives for a specific college (with Company Name joined)
    public List<Drive> getDrivesByCollege(int collegeId) {
        List<Drive> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT d.*, c.COMPANY_NAME FROM campus_drives d JOIN companies c ON d.COMPANY_ID = c.COMPANY_ID WHERE d.COLLEGE_ID = ? ORDER BY d.DRIVE_DATE DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            while(rs.next()) {
                Drive d = new Drive();
                d.setDriveId(rs.getInt("drive_id"));
                d.setCompanyId(rs.getInt("company_id"));
                d.setCompanyName(rs.getString("COMPANY_NAME"));
                d.setCollegeId(rs.getInt("college_id"));
                d.setDriveTitle(rs.getString("drive_title"));
                d.setPosition(rs.getString("position"));
                d.setNoOfHires(rs.getInt("no_of_hires"));
                d.setEligibilityCriteria(rs.getString("eligibility_criteria"));
                d.setPackageCtc(rs.getDouble("package_ctc"));
                
                // ✅ Fetching Dates safely
                d.setRegistrationDeadline(rs.getDate("registration_deadline"));
                d.setDriveDate(rs.getDate("drive_date"));
                
                d.setStatus(rs.getString("status"));
                list.add(d);
            }
        } catch(Exception e) { 
            e.printStackTrace(); 
        } finally {
            closeResources();
        }
        return list;
    }

    // Helper to close resources
    private void closeResources() {
        try { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); } 
        catch(SQLException e) { e.printStackTrace(); }
    }
}