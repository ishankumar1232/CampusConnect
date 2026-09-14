package com.campusconnect.bean;

import java.sql.*;

public class StudentResume
{
    private int resumeId;
    private int studentId;
    private String resumeFile;
    private Date uploadedDate;

    public StudentResume()
    {
    }

    public int getResumeId()
    {
        return resumeId;
    }

    public void setResumeId(int resumeId)
    {
        this.resumeId = resumeId;
    }

    public int getStudentId()
    {
        return studentId;
    }

    public void setStudentId(int studentId)
    {
        this.studentId = studentId;
    }

    public String getResumeFile()
    {
        return resumeFile;
    }

    public void setResumeFile(String resumeFile)
    {
        this.resumeFile = resumeFile;
    }

    public Date getUploadedDate()
    {
        return uploadedDate;
    }

    public void setUploadedDate(Date uploadedDate)
    {
        this.uploadedDate = uploadedDate;
    }


    // ADD

    public boolean InsertMethod()
    {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();

            rs = stmt.executeQuery(
                "SELECT NVL(MAX(RESUME_ID),0)+1 FROM RESUME"
            );

            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();
            stmt.close();


            String sql =
                "INSERT INTO RESUME " +
                "(RESUME_ID, STUDENT_ID, RESUME_FILE, UPLOADED_DATE) " +
                "VALUES (?, ?, ?, SYSDATE)";

            ps = con.prepareStatement(sql);

            ps.setInt(1, id);
            ps.setInt(2, studentId);
            ps.setString(3, resumeFile);

            return ps.executeUpdate() > 0;
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
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                if(con != null) con.close();
            }
            catch(Exception e)
            {
            }
        }
    }


    // UPDATE

    public boolean UpdateMethod()
    {
        Connection con = null;
        PreparedStatement ps = null;

        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql =
                "UPDATE RESUME SET RESUME_FILE=?, " +
                "UPLOADED_DATE=SYSDATE " +
                "WHERE RESUME_ID=? AND STUDENT_ID=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, resumeFile);
            ps.setInt(2, resumeId);
            ps.setInt(3, studentId);

            return ps.executeUpdate() > 0;
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
                if(ps != null) ps.close();
                if(con != null) con.close();
            }
            catch(Exception e)
            {
            }
        }
    }


    // DELETE

    public boolean DeleteMethod()
    {
        Connection con = null;
        PreparedStatement ps = null;

        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql =
                "DELETE FROM RESUME " +
                "WHERE RESUME_ID=? AND STUDENT_ID=?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, resumeId);
            ps.setInt(2, studentId);

            return ps.executeUpdate() > 0;
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
                if(ps != null) ps.close();
                if(con != null) con.close();
            }
            catch(Exception e)
            {
            }
        }
    }
}