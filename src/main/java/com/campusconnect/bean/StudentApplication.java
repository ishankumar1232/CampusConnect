package com.campusconnect.bean;

import java.sql.*;
import com.campusconnect.util.DBConnection;

public class StudentApplication
{
    private int applicationId;
    private int driveId;
    private int studentId;
    private Date appliedDate;
    private String status;
    private String collegeShortlistStatus;

    public StudentApplication()
    {
    }

    public int getApplicationId()
    {
        return applicationId;
    }

    public void setApplicationId(int applicationId)
    {
        this.applicationId = applicationId;
    }

    public int getDriveId()
    {
        return driveId;
    }

    public void setDriveId(int driveId)
    {
        this.driveId = driveId;
    }

    public int getStudentId()
    {
        return studentId;
    }

    public void setStudentId(int studentId)
    {
        this.studentId = studentId;
    }

    public Date getAppliedDate()
    {
        return appliedDate;
    }

    public void setAppliedDate(Date appliedDate)
    {
        this.appliedDate = appliedDate;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getCollegeShortlistStatus()
    {
        return collegeShortlistStatus;
    }

    public void setCollegeShortlistStatus(String collegeShortlistStatus)
    {
        this.collegeShortlistStatus = collegeShortlistStatus;
    }

    // ================= INSERT / APPLY =================

    public boolean InsertMethod()
    {
        String checkSql =
            "SELECT APPLICATION_ID " +
            "FROM APPLICATION " +
            "WHERE DRIVE_ID=? " +
            "AND STUDENT_ID=?";

        String idSql =
            "SELECT NVL(MAX(APPLICATION_ID),0)+1 " +
            "FROM APPLICATION";

        String insertSql =
            "INSERT INTO APPLICATION " +
            "(APPLICATION_ID, DRIVE_ID, STUDENT_ID, " +
            "APPLIED_DATE, STATUS, COLLEGE_SHORTLIST_STATUS) " +
            "VALUES (?, ?, ?, SYSDATE, 'APPLIED', 'PENDING')";

        try (Connection con = DBConnection.getConnection())
        {
            // Check whether already applied
            try (PreparedStatement checkPs = con.prepareStatement(checkSql))
            {
                checkPs.setInt(1, driveId);
                checkPs.setInt(2, studentId);
                try (ResultSet checkRs = checkPs.executeQuery())
                {
                    if(checkRs.next())
                    {
                        return false;
                    }
                }
            }

            // Generate Application ID
            int id = 1;
            try (Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery(idSql))
            {
                if(rs.next())
                {
                    id = rs.getInt(1);
                }
            }
            this.applicationId = id;

            // Insert Application
            try (PreparedStatement ps = con.prepareStatement(insertSql))
            {
                ps.setInt(1, id);
                ps.setInt(2, driveId);
                ps.setInt(3, studentId);

                int x = ps.executeUpdate();
                return x > 0;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

    // ================= DELETE / WITHDRAW =================

    public boolean DeleteMethod()
    {
        String sql =
            "DELETE FROM APPLICATION " +
            "WHERE APPLICATION_ID=? " +
            "AND STUDENT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setInt(1, applicationId);
            ps.setInt(2, studentId);

            int x = ps.executeUpdate();
            return x > 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

    // ================= VIEW =================

    public ResultSet ViewMethod(Connection con)
    {
        ResultSet rs = null;

        try
        {
            Statement stmt =
                con.createStatement();

            String q1 =
                "SELECT A.APPLICATION_ID, " +
                "A.DRIVE_ID, " +
                "C.COMPANY_NAME, " +
                "R.JOB_TITLE, " +
                "A.APPLIED_DATE, " +
                "A.STATUS, " +
                "A.COLLEGE_SHORTLIST_STATUS " +
                "FROM APPLICATION A, " +
                "RECRUITMENT_DRIVE R, " +
                "COMPANY C " +
                "WHERE A.DRIVE_ID = R.DRIVE_ID " +
                "AND R.COMPANY_ID = C.COMPANY_ID " +
                "AND A.STUDENT_ID = " +
                studentId +
                " ORDER BY A.APPLICATION_ID";

            rs =
                stmt.executeQuery(q1);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    }
}