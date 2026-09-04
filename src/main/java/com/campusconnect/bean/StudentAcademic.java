package com.campusconnect.bean;

import java.sql.*;

public class StudentAcademic
{
    private int academicId;
    private int studentId;
    private String qualification;
    private int year;
    private double percentage;
    private double cgpa;
    private int backlogs;


    public StudentAcademic()
    {
    }


    public int getAcademicId()
    {
        return academicId;
    }

    public void setAcademicId(int academicId)
    {
        this.academicId = academicId;
    }


    public int getStudentId()
    {
        return studentId;
    }

    public void setStudentId(int studentId)
    {
        this.studentId = studentId;
    }


    public String getQualification()
    {
        return qualification;
    }

    public void setQualification(String qualification)
    {
        this.qualification = qualification;
    }


    public int getYear()
    {
        return year;
    }

    public void setYear(int year)
    {
        this.year = year;
    }


    public double getPercentage()
    {
        return percentage;
    }

    public void setPercentage(double percentage)
    {
        this.percentage = percentage;
    }


    public double getCgpa()
    {
        return cgpa;
    }

    public void setCgpa(double cgpa)
    {
        this.cgpa = cgpa;
    }


    public int getBacklogs()
    {
        return backlogs;
    }

    public void setBacklogs(int backlogs)
    {
        this.backlogs = backlogs;
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
                "SELECT NVL(MAX(ACADEMIC_ID),0)+1 "
                + "FROM STUDENT_ACADEMIC";

            ResultSet rs = stmt.executeQuery(qid);

            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            String q1 =
                "INSERT INTO STUDENT_ACADEMIC "
                + "(ACADEMIC_ID, STUDENT_ID, QUALIFICATION, YEAR, "
                + "PERCENTAGE, CGPA, BACKLOGS) "
                + "VALUES ("
                + id + ", "
                + studentId + ", '"
                + qualification + "', "
                + year + ", "
                + percentage + ", "
                + cgpa + ", "
                + backlogs + ")";


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
                "SELECT ACADEMIC_ID, QUALIFICATION, YEAR, "
              + "PERCENTAGE, CGPA, BACKLOGS "
              + "FROM STUDENT_ACADEMIC "
              + "WHERE STUDENT_ID = " + studentId
              + " ORDER BY YEAR DESC";

            rs = stmt.executeQuery(q1);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    }
}