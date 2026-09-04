package com.campusconnect.bean;

import java.sql.*;

public class StudentProject
{
    private int projectId;
    private int studentId;
    private String projectName;
    private String description;
    private String technologies;
    private String projectUrl;


    public StudentProject()
    {
    }


    public int getProjectId()
    {
        return projectId;
    }

    public void setProjectId(int projectId)
    {
        this.projectId = projectId;
    }


    public int getStudentId()
    {
        return studentId;
    }

    public void setStudentId(int studentId)
    {
        this.studentId = studentId;
    }


    public String getProjectName()
    {
        return projectName;
    }

    public void setProjectName(String projectName)
    {
        this.projectName = projectName;
    }


    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }


    public String getTechnologies()
    {
        return technologies;
    }

    public void setTechnologies(String technologies)
    {
        this.technologies = technologies;
    }


    public String getProjectUrl()
    {
        return projectUrl;
    }

    public void setProjectUrl(String projectUrl)
    {
        this.projectUrl = projectUrl;
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
                "SELECT NVL(MAX(PROJECT_ID),0)+1 "
                + "FROM STUDENT_PROJECT";

            ResultSet rs = stmt.executeQuery(qid);

            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            String q1 =
                "INSERT INTO STUDENT_PROJECT "
                + "(PROJECT_ID, STUDENT_ID, PROJECT_NAME, "
                + "DESCRIPTION, TECHNOLOGIES, PROJECT_URL) "
                + "VALUES ("
                + id + ", "
                + studentId + ", '"
                + projectName + "', '"
                + description + "', '"
                + technologies + "', '"
                + projectUrl + "')";


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
                "SELECT PROJECT_ID, PROJECT_NAME, DESCRIPTION, "
              + "TECHNOLOGIES, PROJECT_URL "
              + "FROM STUDENT_PROJECT "
              + "WHERE STUDENT_ID = " + studentId
              + " ORDER BY PROJECT_ID";

            rs = stmt.executeQuery(q1);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    }
}