package com.campusconnect.bean;

import java.sql.*;
import com.campusconnect.util.DBConnection;

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
        String qid =
            "SELECT NVL(MAX(SKILL_ID),0)+1 " +
            "FROM STUDENT_SKILL";

        String q1 =
            "INSERT INTO STUDENT_SKILL " +
            "(SKILL_ID, STUDENT_ID, SKILL_NAME) " +
            "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(qid))
        {
            int id = 1;

            if(rs.next())
            {
                id = rs.getInt(1);
            }
            this.skillId = id;

            try (PreparedStatement ps = con.prepareStatement(q1))
            {
                ps.setInt(1, id);
                ps.setInt(2, studentId);
                ps.setString(3, skillName);

                int x = ps.executeUpdate();
                return x > 0;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

    // ================= UPDATE =================

    public boolean UpdateMethod()
    {
        String sql =
            "UPDATE STUDENT_SKILL " +
            "SET SKILL_NAME=? " +
            "WHERE SKILL_ID=? " +
            "AND STUDENT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setString(1, skillName);
            ps.setInt(2, skillId);
            ps.setInt(3, studentId);

            int x = ps.executeUpdate();
            return x > 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

    // ================= DELETE =================

    public boolean DeleteMethod()
    {
        String sql =
            "DELETE FROM STUDENT_SKILL " +
            "WHERE SKILL_ID=? " +
            "AND STUDENT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setInt(1, skillId);
            ps.setInt(2, studentId);

            int x = ps.executeUpdate();
            return x > 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
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