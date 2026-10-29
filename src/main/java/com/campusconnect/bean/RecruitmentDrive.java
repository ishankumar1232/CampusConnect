package com.campusconnect.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import com.campusconnect.util.DBConnection;

public class RecruitmentDrive
{
    private int driveId;
    private int companyId;
    private String driveType;
    private String jobTitle;
    private String description;
    private int vacancy;
    private double eligibilityCgpa;
    private String requiredBranch;
    private String requiredSkills;
    private double salary;
    private String deadline;
    private String status;


    // =========================
    // GETTERS AND SETTERS
    // =========================

    public int getDriveId()
    {
        return driveId;
    }

    public void setDriveId(int driveId)
    {
        this.driveId = driveId;
    }


    public int getCompanyId()
    {
        return companyId;
    }

    public void setCompanyId(int companyId)
    {
        this.companyId = companyId;
    }


    public String getDriveType()
    {
        return driveType;
    }

    public void setDriveType(String driveType)
    {
        this.driveType = driveType;
    }


    public String getJobTitle()
    {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle)
    {
        this.jobTitle = jobTitle;
    }


    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }


    public int getVacancy()
    {
        return vacancy;
    }

    public void setVacancy(int vacancy)
    {
        this.vacancy = vacancy;
    }


    public double getEligibilityCgpa()
    {
        return eligibilityCgpa;
    }

    public void setEligibilityCgpa(double eligibilityCgpa)
    {
        this.eligibilityCgpa = eligibilityCgpa;
    }


    public String getRequiredBranch()
    {
        return requiredBranch;
    }

    public void setRequiredBranch(String requiredBranch)
    {
        this.requiredBranch = requiredBranch;
    }


    public String getRequiredSkills()
    {
        return requiredSkills;
    }

    public void setRequiredSkills(String requiredSkills)
    {
        this.requiredSkills = requiredSkills;
    }


    public double getSalary()
    {
        return salary;
    }

    public void setSalary(double salary)
    {
        this.salary = salary;
    }


    public String getDeadline()
    {
        return deadline;
    }

    public void setDeadline(String deadline)
    {
        this.deadline = deadline;
    }


    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }


    // =========================
    // INSERT METHOD
    // =========================

    public boolean InsertMethod()
    {
        boolean result = false;

        try
        {
            Connection con = DBConnection.getConnection();

            /*
             * Generate next DRIVE_ID.
             * This is used because we are not changing
             * the existing table structure or depending
             * on an unknown sequence name.
             */
            String idSql =
                    "SELECT NVL(MAX(DRIVE_ID),0) + 1 AS NEXT_ID " +
                    "FROM RECRUITMENT_DRIVE";

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery(idSql);

            if(rs.next())
            {
                driveId = rs.getInt("NEXT_ID");
            }

            rs.close();
            st.close();


            String sql =
                    "INSERT INTO RECRUITMENT_DRIVE " +
                    "(DRIVE_ID, COMPANY_ID, DRIVE_TYPE, JOB_TITLE, " +
                    "DESCRIPTION, VACANCY, ELIGIBILITY_CGPA, " +
                    "REQUIRED_BRANCH, REQUIRED_SKILLS, SALARY, " +
                    "DEADLINE, STATUS) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " +
                    "TO_DATE(?, 'DD-MM-YYYY'), ?)";


            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, driveId);
            ps.setInt(2, companyId);
            ps.setString(3, driveType);
            ps.setString(4, jobTitle);
            ps.setString(5, description);
            ps.setInt(6, vacancy);
            ps.setDouble(7, eligibilityCgpa);
            ps.setString(8, requiredBranch);
            ps.setString(9, requiredSkills);
            ps.setDouble(10, salary);
            ps.setString(11, deadline);
            ps.setString(12, status);


            int rows = ps.executeUpdate();

            if(rows > 0)
            {
                result = true;
            }

            ps.close();
            con.close();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return result;
    }


    // =========================
    // SELECT BY ID METHOD
    // =========================

    public ResultSet SelectByIdMethod()
    {
        ResultSet rs = null;

        try
        {
            Connection con = DBConnection.getConnection();

            String sql =
                    "SELECT * FROM RECRUITMENT_DRIVE " +
                    "WHERE DRIVE_ID = ? " +
                    "AND COMPANY_ID = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, driveId);
            ps.setInt(2, companyId);

            rs = ps.executeQuery();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    }
    
    
    public ResultSet SelectMethod()
    {
        ResultSet rs = null;

        try
        {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, companyId);

            rs = ps.executeQuery();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return rs;
    }


    // =========================
    // UPDATE METHOD
    // =========================

    public boolean UpdateMethod()
    {
        boolean result = false;

        try
        {
            Connection con = DBConnection.getConnection();

            String sql =
                    "UPDATE RECRUITMENT_DRIVE SET " +
                    "DRIVE_TYPE = ?, " +
                    "JOB_TITLE = ?, " +
                    "DESCRIPTION = ?, " +
                    "VACANCY = ?, " +
                    "ELIGIBILITY_CGPA = ?, " +
                    "REQUIRED_BRANCH = ?, " +
                    "REQUIRED_SKILLS = ?, " +
                    "SALARY = ?, " +
                    "DEADLINE = TO_DATE(?, 'DD-MM-YYYY'), " +
                    "STATUS = ? " +
                    "WHERE DRIVE_ID = ? " +
                    "AND COMPANY_ID = ?";


            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, driveType);
            ps.setString(2, jobTitle);
            ps.setString(3, description);
            ps.setInt(4, vacancy);
            ps.setDouble(5, eligibilityCgpa);
            ps.setString(6, requiredBranch);
            ps.setString(7, requiredSkills);
            ps.setDouble(8, salary);
            ps.setString(9, deadline);
            ps.setString(10, status);
            ps.setInt(11, driveId);
            ps.setInt(12, companyId);


            int rows = ps.executeUpdate();

            if(rows > 0)
            {
                result = true;
            }

            ps.close();
            con.close();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return result;
    }



public boolean CloseMethod()
{
    boolean result = false;

    try
    {
        Connection con = DBConnection.getConnection();

        String sql = "UPDATE RECRUITMENT_DRIVE "
                   + "SET STATUS = 'CLOSED' "
                   + "WHERE DRIVE_ID = ? "
                   + "AND COMPANY_ID = ?";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, driveId);
        ps.setInt(2, companyId);

        int rows = ps.executeUpdate();

        if(rows > 0)
        {
            result = true;
        }

        ps.close();
        con.close();
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }

    return result;
}
}