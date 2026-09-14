package com.campusconnect.bean;

import java.sql.*;

public class StudentSkill
{
    private int skillId;
    private int studentId;
    private String skillName;


    public StudentSkill()
    {
    }


    public int getSkillId()
    {
        return skillId;
    }

    public void setSkillId(int skillId)
    {
        this.skillId = skillId;
    }


    public int getStudentId()
    {
        return studentId;
    }

    public void setStudentId(int studentId)
    {
        this.studentId = studentId;
    }


    public String getSkillName()
    {
        return skillName;
    }

    public void setSkillName(String skillName)
    {
        this.skillName = skillName;
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
                "SELECT NVL(MAX(SKILL_ID),0)+1 " +
                "FROM STUDENT_SKILL";


            ResultSet rs =
                stmt.executeQuery(qid);


            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            String q1 =
                "INSERT INTO STUDENT_SKILL " +
                "(SKILL_ID, STUDENT_ID, SKILL_NAME) " +
                "VALUES (" +
                id + ", " +
                studentId + ", '" +
                skillName + "')";


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
                "UPDATE STUDENT_SKILL " +
                "SET SKILL_NAME=? " +
                "WHERE SKILL_ID=? " +
                "AND STUDENT_ID=?";


            ps = con.prepareStatement(sql);


            ps.setString(1, skillName);
            ps.setInt(2, skillId);
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
                "DELETE FROM STUDENT_SKILL " +
                "WHERE SKILL_ID=? " +
                "AND STUDENT_ID=?";


            ps = con.prepareStatement(sql);


            ps.setInt(1, skillId);
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
                "SELECT SKILL_ID, SKILL_NAME " +
                "FROM STUDENT_SKILL " +
                "WHERE STUDENT_ID = " +
                studentId +
                " ORDER BY SKILL_ID";


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