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


    public boolean InsertMethod()
    {
        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();


            String qid =
                "SELECT NVL(MAX(RESUME_ID),0)+1 "
                + "FROM RESUME";

            ResultSet rs = stmt.executeQuery(qid);

            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            String q1 =
                "INSERT INTO RESUME "
                + "(RESUME_ID, STUDENT_ID, RESUME_FILE, UPLOADED_DATE) "
                + "VALUES ("
                + id + ", "
                + studentId + ", '"
                + resumeFile + "', SYSDATE)";


            int x = stmt.executeUpdate(q1);


            if(x > 0)
            {
                con.close();
                return true;
            }
            else
            {
                con.close();
                return false;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }
    public ResultSet ViewMethod(Connection con)
    {
        ResultSet rs = null;

        try
        {
            Statement stmt = con.createStatement();

            String q1 =
                "SELECT RESUME_ID, RESUME_FILE, UPLOADED_DATE "
              + "FROM RESUME "
              + "WHERE STUDENT_ID = " + studentId
              + " ORDER BY RESUME_ID";

            rs = stmt.executeQuery(q1);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    }
}