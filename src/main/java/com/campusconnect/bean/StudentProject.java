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


    // ================= ADD =================

    public boolean InsertMethod()
    {
        Connection con = null;
        Statement stmt = null;

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

            stmt = con.createStatement();


            String qid =
                "SELECT NVL(MAX(PROJECT_ID),0)+1 " +
                "FROM STUDENT_PROJECT";


            ResultSet rs =
                stmt.executeQuery(qid);


            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            String q1 =
                "INSERT INTO STUDENT_PROJECT " +
                "(PROJECT_ID, STUDENT_ID, PROJECT_NAME, " +
                "DESCRIPTION, TECHNOLOGIES, PROJECT_URL) " +
                "VALUES (" +
                id + ", " +
                studentId + ", '" +
                projectName + "', '" +
                description + "', '" +
                technologies + "', '" +
                projectUrl + "')";


            int x =
                stmt.executeUpdate(q1);


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
                if(stmt != null)
                    stmt.close();

                if(con != null)
                    con.close();
            }
            catch(Exception e)
            {
            }
        }
    }


    // ================= UPDATE =================

    public boolean UpdateMethod()
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
                "UPDATE STUDENT_PROJECT SET " +
                "PROJECT_NAME=?, " +
                "DESCRIPTION=?, " +
                "TECHNOLOGIES=?, " +
                "PROJECT_URL=? " +
                "WHERE PROJECT_ID=? " +
                "AND STUDENT_ID=?";


            ps = con.prepareStatement(sql);


            ps.setString(1, projectName);
            ps.setString(2, description);
            ps.setString(3, technologies);
            ps.setString(4, projectUrl);
            ps.setInt(5, projectId);
            ps.setInt(6, studentId);


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


    // ================= DELETE =================

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
                "DELETE FROM STUDENT_PROJECT " +
                "WHERE PROJECT_ID=? " +
                "AND STUDENT_ID=?";


            ps = con.prepareStatement(sql);


            ps.setInt(1, projectId);
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
                "SELECT PROJECT_ID, PROJECT_NAME, " +
                "DESCRIPTION, TECHNOLOGIES, PROJECT_URL " +
                "FROM STUDENT_PROJECT " +
                "WHERE STUDENT_ID = " +
                studentId +
                " ORDER BY PROJECT_ID";


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