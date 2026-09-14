package com.campusconnect.bean;

import java.sql.*;

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
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try
        {
            Class.forName(
                "oracle.jdbc.driver.OracleDriver"
            );

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );


            // Check whether already applied

            String checkSql =
                "SELECT APPLICATION_ID " +
                "FROM APPLICATION " +
                "WHERE DRIVE_ID=? " +
                "AND STUDENT_ID=?";


            ps = con.prepareStatement(checkSql);

            ps.setInt(1, driveId);
            ps.setInt(2, studentId);

            rs = ps.executeQuery();


            if(rs.next())
            {
                rs.close();
                ps.close();
                con.close();

                return false;
            }


            rs.close();
            ps.close();


            // Generate Application ID

            Statement stmt =
                con.createStatement();

            rs = stmt.executeQuery(
                "SELECT NVL(MAX(APPLICATION_ID),0)+1 " +
                "FROM APPLICATION"
            );


            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }


            rs.close();
            stmt.close();


            // Insert Application

            String sql =
                "INSERT INTO APPLICATION " +
                "(APPLICATION_ID, DRIVE_ID, STUDENT_ID, " +
                "APPLIED_DATE, STATUS, COLLEGE_SHORTLIST_STATUS) " +
                "VALUES (?, ?, ?, SYSDATE, 'APPLIED', 'PENDING')";


            ps = con.prepareStatement(sql);

            ps.setInt(1, id);
            ps.setInt(2, driveId);
            ps.setInt(3, studentId);


            int x =
                ps.executeUpdate();


            return x > 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();

            return false;
        }
        finally
        {
            try
            {
                if(rs != null)
                    rs.close();

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();
            }
            catch(Exception e)
            {
            }
        }
    }


    // ================= DELETE / WITHDRAW =================

    public boolean DeleteMethod()
    {
        Connection con = null;
        PreparedStatement ps = null;

        try
        {
            Class.forName(
                "oracle.jdbc.driver.OracleDriver"
            );

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );


            String sql =
                "DELETE FROM APPLICATION " +
                "WHERE APPLICATION_ID=? " +
                "AND STUDENT_ID=?";


            ps = con.prepareStatement(sql);

            ps.setInt(1, applicationId);
            ps.setInt(2, studentId);


            int x =
                ps.executeUpdate();


            return x > 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();

            return false;
        }
        finally
        {
            try
            {
                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();
            }
            catch(Exception e)
            {
            }
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