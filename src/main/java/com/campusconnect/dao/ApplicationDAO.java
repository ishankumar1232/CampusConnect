package com.campusconnect.dao;

import com.campusconnect.bean.Application;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ApplicationDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //====================================
    // 1. ADD NEW APPLICATION
    //====================================
    public boolean addApplication(Application app) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO student_applications (application_id, student_id, drive_id, status, application_date, resume_path) VALUES (application_seq.NEXTVAL, ?, ?, ?, SYSDATE, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, app.getStudentId());
            ps.setInt(2, app.getDriveId());
            ps.setString(3, app.getStatus());
            ps.setString(4, app.getResumePath() != null ? app.getResumePath() : "N/A");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                status = true;
                System.out.println("Application Added Successfully!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return status;
    }

    //====================================
    // 2. GET ALL APPLICATIONS FOR A DRIVE
    //====================================
    public List<Application> getApplicationsByDrive(int driveId) {
        List<Application> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT a.*, s.NAME as STUDENT_NAME, s.EMAIL as STUDENT_EMAIL, " +
                         "c.COMPANY_NAME, d.DRIVE_TITLE " +
                         "FROM student_applications a " +
                         "JOIN students s ON a.STUDENT_ID = s.STUDENT_ID " +
                         "JOIN campus_drives d ON a.DRIVE_ID = d.DRIVE_ID " +
                         "JOIN companies c ON d.COMPANY_ID = c.COMPANY_ID " +
                         "WHERE a.DRIVE_ID = ? " +
                         "ORDER BY a.APPLICATION_DATE DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, driveId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Application app = new Application();
                app.setApplicationId(rs.getInt("application_id"));
                app.setStudentId(rs.getInt("student_id"));
                app.setStudentName(rs.getString("STUDENT_NAME"));
                app.setStudentEmail(rs.getString("STUDENT_EMAIL"));
                app.setDriveId(rs.getInt("drive_id"));
                app.setDriveTitle(rs.getString("DRIVE_TITLE"));
                app.setCompanyName(rs.getString("COMPANY_NAME"));
                app.setStatus(rs.getString("status"));
                app.setResumePath(rs.getString("resume_path"));
                app.setApplicationDate(rs.getTimestamp("application_date"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    //====================================
    // 3. GET ALL APPLICATIONS FOR A STUDENT
    //====================================
    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT a.*, d.DRIVE_TITLE, c.COMPANY_NAME " +
                         "FROM student_applications a " +
                         "JOIN campus_drives d ON a.DRIVE_ID = d.DRIVE_ID " +
                         "JOIN companies c ON d.COMPANY_ID = c.COMPANY_ID " +
                         "WHERE a.STUDENT_ID = ? " +
                         "ORDER BY a.APPLICATION_DATE DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Application app = new Application();
                app.setApplicationId(rs.getInt("application_id"));
                app.setStudentId(rs.getInt("student_id"));
                app.setDriveId(rs.getInt("drive_id"));
                app.setDriveTitle(rs.getString("DRIVE_TITLE"));
                app.setCompanyName(rs.getString("COMPANY_NAME"));
                app.setStatus(rs.getString("status"));
                app.setApplicationDate(rs.getTimestamp("application_date"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }

    //====================================
    // 4. GET APPLICATION BY ID
    //====================================
    public Application getApplicationById(int applicationId) {
        Application app = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT a.*, s.NAME as STUDENT_NAME, s.EMAIL as STUDENT_EMAIL, " +
                         "c.COMPANY_NAME, d.DRIVE_TITLE " +
                         "FROM student_applications a " +
                         "JOIN students s ON a.STUDENT_ID = s.STUDENT_ID " +
                         "JOIN campus_drives d ON a.DRIVE_ID = d.DRIVE_ID " +
                         "JOIN companies c ON d.COMPANY_ID = c.COMPANY_ID " +
                         "WHERE a.APPLICATION_ID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, applicationId);
            rs = ps.executeQuery();

            if (rs.next()) {
                app = new Application();
                app.setApplicationId(rs.getInt("application_id"));
                app.setStudentId(rs.getInt("student_id"));
                app.setStudentName(rs.getString("STUDENT_NAME"));
                app.setStudentEmail(rs.getString("STUDENT_EMAIL"));
                app.setDriveId(rs.getInt("drive_id"));
                app.setDriveTitle(rs.getString("DRIVE_TITLE"));
                app.setCompanyName(rs.getString("COMPANY_NAME"));
                app.setStatus(rs.getString("status"));
                app.setResumePath(rs.getString("resume_path"));
                app.setApplicationDate(rs.getTimestamp("application_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return app;
    }

    //====================================
    // 5. UPDATE APPLICATION STATUS
    //====================================
    public boolean updateApplicationStatus(int applicationId, String status) {
        boolean result = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE student_applications SET status = ?, application_date = SYSDATE WHERE application_id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, applicationId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                result = true;
                System.out.println("Application Status Updated to: " + status);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return result;
    }

    //====================================
    // 6. COUNT APPLICATIONS BY DRIVE
    //====================================
    public int countApplicationsByDrive(int driveId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM student_applications WHERE drive_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, driveId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 7. COUNT SELECTED STUDENTS (For Reports)
    //====================================
    public int countSelectedStudents(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM student_applications a " +
                         "JOIN campus_drives d ON a.DRIVE_ID = d.DRIVE_ID " +
                         "WHERE d.COLLEGE_ID = ? AND a.STATUS = 'Selected'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 8. COUNT SHORTLISTED STUDENTS (For Reports)
    //====================================
    public int countShortlistedStudents(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM student_applications a " +
                         "JOIN campus_drives d ON a.DRIVE_ID = d.DRIVE_ID " +
                         "WHERE d.COLLEGE_ID = ? AND a.STATUS = 'Shortlisted'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 9. COUNT TOTAL APPLICATIONS BY COLLEGE
    //====================================
    public int countTotalApplications(int collegeId) {
        int count = 0;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM student_applications a " +
                         "JOIN campus_drives d ON a.DRIVE_ID = d.DRIVE_ID " +
                         "WHERE d.COLLEGE_ID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return count;
    }

    //====================================
    // 10. DELETE APPLICATION
    //====================================
    public boolean deleteApplication(int applicationId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM student_applications WHERE application_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, applicationId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                status = true;
                System.out.println("Application Deleted Successfully!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return status;
    }

    //====================================
    // HELPER METHOD: CLOSE ALL RESOURCES
    //====================================
    private void closeResources() {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}