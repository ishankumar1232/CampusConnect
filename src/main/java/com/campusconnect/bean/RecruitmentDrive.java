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
    private String companyName;
    private int applicationCount;
    private int selectedCount;
    private int placedCount;
    private int applications;
    private int selectedStudents;
    private int placedStudents;

    // GETTERS AND SETTERS

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
    
    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public int getApplicationCount() {
        return applicationCount;
    }

    public void setApplicationCount(int applicationCount) {
        this.applicationCount = applicationCount;
    }

    public int getSelectedCount() {
        return selectedCount;
    }

    public void setSelectedCount(int selectedCount) {
        this.selectedCount = selectedCount;
    }

    public int getPlacedCount() {
        return placedCount;
    }

    public void setPlacedCount(int placedCount) {
        this.placedCount = placedCount;
    }
    
 // ================= APPLICATIONS =================

    public int getApplications() {
        return applications;
    }

    public void setApplications(int applications) {
        this.applications = applications;
    }

    // ================= SELECTED STUDENTS =================

    public int getSelectedStudents() {
        return selectedStudents;
    }

    public void setSelectedStudents(int selectedStudents) {
        this.selectedStudents = selectedStudents;
    }

    // ================= PLACED STUDENTS =================

    public int getPlacedStudents() {
        return placedStudents;
    }

    public void setPlacedStudents(int placedStudents) {
        this.placedStudents = placedStudents;
    }

    // INSERT METHOD

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

    // SELECT BY ID METHOD

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

    // UPDATE METHOD

    public boolean UpdateMethod()
    {
        boolean result = false;

        try
        {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return false;
            }

            String deadlineVal = getDeadline() != null ? getDeadline().trim() : "";
            String dateFormat = "DD-MM-YYYY";
            if (deadlineVal.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
                dateFormat = "YYYY-MM-DD";
            } else if (deadlineVal.matches("^\\d{2}/\\d{2}/\\d{4}$")) {
                dateFormat = "DD/MM/YYYY";
            } else if (deadlineVal.matches("^\\d{4}/\\d{2}/\\d{2}$")) {
                dateFormat = "YYYY/MM/DD";
            }

            String sql = "UPDATE RECRUITMENT_DRIVE SET " +
                        "DRIVE_TYPE = ?, " +
                        "JOB_TITLE = ?, " +
                        "DESCRIPTION = ?, " +
                        "VACANCY = ?, " +
                        "ELIGIBILITY_CGPA = ?, " +
                        "REQUIRED_BRANCH = ?, " +
                        "REQUIRED_SKILLS = ?, " +
                        "SALARY = ?, " +
                        "DEADLINE = TO_DATE(?, '" + dateFormat + "'), " +
                        "STATUS = ? " +
                        "WHERE DRIVE_ID = ? AND COMPANY_ID = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, getDriveType());
            ps.setString(2, getJobTitle());
            ps.setString(3, getDescription());
            ps.setInt(4, getVacancy());
            ps.setDouble(5, getEligibilityCgpa());
            ps.setString(6, getRequiredBranch());
            ps.setString(7, getRequiredSkills());
            ps.setDouble(8, getSalary());
            ps.setString(9, deadlineVal);
            ps.setString(10, getStatus());
            ps.setInt(11, getDriveId());
            ps.setInt(12, getCompanyId());

            int x = ps.executeUpdate();

            ps.close();
            con.close();

            if(x > 0)
            {
                result = true;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return result;
    }

    // CLOSE METHOD

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

    // RECRUITMENT METRIC METHODS

    public int TotalDriveMethod()
    {
        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return 0;

            String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ?";

            try (PreparedStatement ps = con.prepareStatement(q1))
            {
                ps.setInt(1, getCompanyId());
                try (ResultSet rs = ps.executeQuery())
                {
                    if(rs.next())
                    {
                        return rs.getInt(1);
                    }
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return 0;
    }

    public int ActiveDriveMethod()
    {
        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return 0;

            String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ? AND STATUS = 'ACTIVE'";

            try (PreparedStatement ps = con.prepareStatement(q1))
            {
                ps.setInt(1, getCompanyId());
                try (ResultSet rs = ps.executeQuery())
                {
                    if(rs.next())
                    {
                        return rs.getInt(1);
                    }
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return 0;
    }

    public int ClosedDriveMethod()
    {
        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return 0;

            String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ? AND STATUS = 'CLOSED'";

            try (PreparedStatement ps = con.prepareStatement(q1))
            {
                ps.setInt(1, getCompanyId());
                try (ResultSet rs = ps.executeQuery())
                {
                    if(rs.next())
                    {
                        return rs.getInt(1);
                    }
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return 0;
    }

    public int TotalVacancyMethod()
    {
        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return 0;

            String q1 = "SELECT NVL(SUM(VACANCY), 0) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ?";

            try (PreparedStatement ps = con.prepareStatement(q1))
            {
                ps.setInt(1, getCompanyId());
                try (ResultSet rs = ps.executeQuery())
                {
                    if(rs.next())
                    {
                        return rs.getInt(1);
                    }
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return 0;
    }

    public int CampusDriveMethod()
    {
        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return 0;

            String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ? AND (DRIVE_TYPE = 'Campus' OR DRIVE_TYPE = 'On Campus' OR DRIVE_TYPE = 'On-Campus')";

            try (PreparedStatement ps = con.prepareStatement(q1))
            {
                ps.setInt(1, getCompanyId());
                try (ResultSet rs = ps.executeQuery())
                {
                    if(rs.next())
                    {
                        return rs.getInt(1);
                    }
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return 0;
    }

    public int DirectDriveMethod()
    {
        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return 0;

            String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ? AND (DRIVE_TYPE = 'Direct' OR DRIVE_TYPE = 'Off Campus' OR DRIVE_TYPE = 'Off-Campus')";

            try (PreparedStatement ps = con.prepareStatement(q1))
            {
                ps.setInt(1, getCompanyId());
                try (ResultSet rs = ps.executeQuery())
                {
                    if(rs.next())
                    {
                        return rs.getInt(1);
                    }
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return 0;
    }
}
