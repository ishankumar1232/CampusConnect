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
                "SELECT NVL(MAX(SKILL_ID),0)+1 "
                + "FROM STUDENT_SKILL";

            ResultSet rs = stmt.executeQuery(qid);

            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }

            rs.close();


            String q1 =
                "INSERT INTO STUDENT_SKILL "
                + "(SKILL_ID, STUDENT_ID, SKILL_NAME) "
                + "VALUES ("
                + id + ", "
                + studentId + ", '"
                + skillName + "')";


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
                "SELECT SKILL_ID, SKILL_NAME "
              + "FROM STUDENT_SKILL "
              + "WHERE STUDENT_ID = " + studentId
              + " ORDER BY SKILL_ID";

            rs = stmt.executeQuery(q1);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    } 
}