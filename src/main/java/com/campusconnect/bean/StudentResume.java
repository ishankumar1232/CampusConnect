package com.campusconnect.bean;

import java.sql.*;
import com.campusconnect.util.DBConnection;

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
        String idSql = "SELECT NVL(MAX(RESUME_ID),0)+1 FROM RESUME";
        String insertSql =
            "INSERT INTO RESUME " +
            "(RESUME_ID, STUDENT_ID, RESUME_FILE, UPLOADED_DATE) " +
            "VALUES (?, ?, ?, SYSDATE)";

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(idSql))
        {
            int id = 1;
            if(rs.next())
            {
                id = rs.getInt(1);
            }
            this.resumeId = id;

            try (PreparedStatement ps = con.prepareStatement(insertSql))
            {
                ps.setInt(1, id);
                ps.setInt(2, studentId);
                ps.setString(3, resumeFile);

                return ps.executeUpdate() > 0;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE

    public boolean UpdateMethod()
    {
        String sql =
            "UPDATE RESUME SET RESUME_FILE=?, " +
            "UPLOADED_DATE=SYSDATE " +
            "WHERE RESUME_ID=? AND STUDENT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
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
    }

    // DELETE

    public boolean DeleteMethod()
    {
        String sql =
            "DELETE FROM RESUME " +
            "WHERE RESUME_ID=? AND STUDENT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setInt(1, resumeId);
            ps.setInt(2, studentId);

            return ps.executeUpdate() > 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }
}