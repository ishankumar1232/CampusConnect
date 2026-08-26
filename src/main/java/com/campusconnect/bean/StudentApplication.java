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
                "SELECT NVL(MAX(APPLICATION_ID),0)+1 "
              + "FROM APPLICATION";

            ResultSet rs = stmt.executeQuery(qid);

            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            String q1 =
                "INSERT INTO APPLICATION "
              + "(APPLICATION_ID, DRIVE_ID, STUDENT_ID, "
              + "APPLIED_DATE, STATUS, COLLEGE_SHORTLIST_STATUS) "
              + "VALUES ("
              + id + ", "
              + driveId + ", "
              + studentId + ", "
              + "SYSDATE, "
              + "'APPLIED', "
              + "'PENDING')";


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
                "SELECT A.APPLICATION_ID, "
              + "A.DRIVE_ID, "
              + "C.COMPANY_NAME, "
              + "R.JOB_TITLE, "
              + "A.APPLIED_DATE, "
              + "A.STATUS, "
              + "A.COLLEGE_SHORTLIST_STATUS "
              + "FROM APPLICATION A, "
              + "RECRUITMENT_DRIVE R, "
              + "COMPANY C "
              + "WHERE A.DRIVE_ID = R.DRIVE_ID "
              + "AND R.COMPANY_ID = C.COMPANY_ID "
              + "AND A.STUDENT_ID = " + studentId
              + " ORDER BY A.APPLICATION_ID";

            rs = stmt.executeQuery(q1);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    }
}