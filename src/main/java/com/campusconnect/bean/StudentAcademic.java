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


    // ================= ADD =================

    public boolean InsertMethod()
    {
        Connection con = null;
        Statement stmt = null;

        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            stmt = con.createStatement();

            String qid =
                "SELECT NVL(MAX(ACADEMIC_ID),0)+1 " +
                "FROM STUDENT_ACADEMIC";

            ResultSet rs = stmt.executeQuery(qid);

            if(rs.next())
            {
                academicId = rs.getInt(1);
            }

            rs.close();

            String q1 =
                "INSERT INTO STUDENT_ACADEMIC " +
                "(ACADEMIC_ID, STUDENT_ID, QUALIFICATION, YEAR, " +
                "PERCENTAGE, CGPA, BACKLOGS) VALUES (" +
                academicId + "," +
                studentId + ",'" +
                qualification + "'," +
                year + "," +
                percentage + "," +
                cgpa + "," +
                backlogs + ")";

            int x = stmt.executeUpdate(q1);

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
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql =
                "UPDATE STUDENT_ACADEMIC SET " +
                "QUALIFICATION=?, " +
                "YEAR=?, " +
                "PERCENTAGE=?, " +
                "CGPA=?, " +
                "BACKLOGS=? " +
                "WHERE ACADEMIC_ID=? " +
                "AND STUDENT_ID=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, qualification);
            ps.setInt(2, year);
            ps.setDouble(3, percentage);
            ps.setDouble(4, cgpa);
            ps.setInt(5, backlogs);
            ps.setInt(6, academicId);
            ps.setInt(7, studentId);

            int x = ps.executeUpdate();

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
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql =
                "DELETE FROM STUDENT_ACADEMIC " +
                "WHERE ACADEMIC_ID=? " +
                "AND STUDENT_ID=?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, academicId);
            ps.setInt(2, studentId);

            int x = ps.executeUpdate();

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
        try
        {
            Statement stmt = con.createStatement();

            String q1 =
                "SELECT ACADEMIC_ID, QUALIFICATION, YEAR, " +
                "PERCENTAGE, CGPA, BACKLOGS " +
                "FROM STUDENT_ACADEMIC " +
                "WHERE STUDENT_ID = " + studentId +
                " ORDER BY YEAR DESC";

            return stmt.executeQuery(q1);
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }
}