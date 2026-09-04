package com.campusconnect.dao;

import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ReportDAO {
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. GET TOTAL STUDENTS BY COLLEGE
    //====================================
    public int getTotalStudents(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM STUDENTS WHERE COLLEGE_ID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 2. GET TOTAL DRIVES BY COLLEGE
    //====================================
    public int getTotalDrives(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM CAMPUS_DRIVES WHERE COLLEGE_ID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 3. GET DRIVES BY STATUS
    //====================================
    public int getDrivesByStatus(int collegeId, String status) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM CAMPUS_DRIVES WHERE COLLEGE_ID = ? AND STATUS = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            ps.setString(2, status);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 4. GET TOTAL COMPANIES
    //====================================
    public int getTotalCompanies() {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM COMPANIES";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 5. GET TOTAL APPLICATIONS BY COLLEGE
    //====================================
    public int getTotalApplications(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM STUDENT_APPLICATIONS sa " +
                         "JOIN CAMPUS_DRIVES d ON sa.DRIVE_ID = d.DRIVE_ID " +
                         "WHERE d.COLLEGE_ID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 6. GET TOTAL SELECTED STUDENTS
    //====================================
    public int getTotalSelected(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM STUDENT_APPLICATIONS sa " +
                         "JOIN CAMPUS_DRIVES d ON sa.DRIVE_ID = d.DRIVE_ID " +
                         "WHERE d.COLLEGE_ID = ? AND sa.STATUS = 'Selected'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 7. GET TOTAL SHORTLISTED STUDENTS
    //====================================
    public int getTotalShortlisted(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM STUDENT_APPLICATIONS sa " +
                         "JOIN CAMPUS_DRIVES d ON sa.DRIVE_ID = d.DRIVE_ID " +
                         "WHERE d.COLLEGE_ID = ? AND sa.STATUS = 'Shortlisted'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 8. GET PLACEMENT REPORT (Selected Students)
    //====================================
    public List<Map<String, Object>> getPlacementReport(int collegeId) {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT s.NAME as STUDENT_NAME, s.EMAIL as STUDENT_EMAIL, " +
                         "c.COMPANY_NAME, d.DRIVE_TITLE, d.PACKAGE_CTC, sa.STATUS, " +
                         "sa.APPLICATION_DATE " +
                         "FROM STUDENT_APPLICATIONS sa " +
                         "JOIN STUDENTS s ON sa.STUDENT_ID = s.STUDENT_ID " +
                         "JOIN CAMPUS_DRIVES d ON sa.DRIVE_ID = d.DRIVE_ID " +
                         "JOIN COMPANIES c ON d.COMPANY_ID = c.COMPANY_ID " +
                         "WHERE d.COLLEGE_ID = ? AND sa.STATUS = 'Selected' " +
                         "ORDER BY sa.APPLICATION_DATE DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("studentName", rs.getString("STUDENT_NAME"));
                record.put("studentEmail", rs.getString("STUDENT_EMAIL"));
                record.put("companyName", rs.getString("COMPANY_NAME"));
                record.put("driveTitle", rs.getString("DRIVE_TITLE"));
                record.put("packageCtc", rs.getDouble("PACKAGE_CTC"));
                record.put("status", rs.getString("STATUS"));
                record.put("applicationDate", rs.getTimestamp("APPLICATION_DATE"));
                list.add(record);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    //====================================
    // 9. GET DRIVE REPORT
    //====================================
    public List<Map<String, Object>> getDriveReport(int collegeId) {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT c.COMPANY_NAME, d.DRIVE_TITLE, d.POSITION, " +
                         "d.DRIVE_DATE, d.PACKAGE_CTC, d.STATUS, d.NO_OF_HIRES " +
                         "FROM CAMPUS_DRIVES d " +
                         "JOIN COMPANIES c ON d.COMPANY_ID = c.COMPANY_ID " +
                         "WHERE d.COLLEGE_ID = ? " +
                         "ORDER BY d.DRIVE_DATE DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("companyName", rs.getString("COMPANY_NAME"));
                record.put("driveTitle", rs.getString("DRIVE_TITLE"));
                record.put("position", rs.getString("POSITION"));
                record.put("driveDate", rs.getDate("DRIVE_DATE"));
                record.put("packageCtc", rs.getDouble("PACKAGE_CTC"));
                record.put("status", rs.getString("STATUS"));
                record.put("noOfHires", rs.getInt("NO_OF_HIRES"));
                list.add(record);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    //====================================
    // 10. GET DEPARTMENT-WISE STATISTICS
    //====================================
    public List<Map<String, Object>> getDepartmentStats(int collegeId) {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT dp.DEPARTMENT_NAME, COUNT(s.STUDENT_ID) as TOTAL_STUDENTS " +
                         "FROM DEPARTMENT dp " +
                         "LEFT JOIN STUDENTS s ON dp.DEPARTMENT_ID = s.DEPARTMENT_ID " +
                         "WHERE dp.COLLEGE_ID = ? " +
                         "GROUP BY dp.DEPARTMENT_NAME";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("departmentName", rs.getString("DEPARTMENT_NAME"));
                record.put("totalStudents", rs.getInt("TOTAL_STUDENTS"));
                list.add(record);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    //====================================
    // HELPER: CLOSE RESOURCES
    //====================================
    private void closeResources() {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
}