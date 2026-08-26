package com.campusconnect.bean;

import java.sql.*;

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

            String q1 = "INSERT INTO RECRUITMENT_DRIVE " +
                        "(DRIVE_ID, COMPANY_ID, DRIVE_TYPE, JOB_TITLE, DESCRIPTION, " +
                        "VACANCY, ELIGIBILITY_CGPA, REQUIRED_BRANCH, REQUIRED_SKILLS, " +
                        "SALARY, DEADLINE, STATUS) " +
                        "VALUES (DRIVE_SEQ.NEXTVAL, " +
                        getCompanyId() + ", '" +
                        getDriveType() + "', '" +
                        getJobTitle() + "', '" +
                        getDescription() + "', " +
                        getVacancy() + ", " +
                        getEligibilityCgpa() + ", '" +
                        getRequiredBranch() + "', '" +
                        getRequiredSkills() + "', " +
                        getSalary() + ", " +
                        "TO_DATE('" + getDeadline() + "', 'DD-MM-YYYY'), '" +
                        getStatus() + "')";

            int x = stmt.executeUpdate(q1);

            con.close();

            if(x > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }
    
    public ResultSet SelectMethod()
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

            String q1 = "SELECT * FROM RECRUITMENT_DRIVE " +
                        "WHERE COMPANY_ID = " + companyId +
                        " ORDER BY DRIVE_ID";

            ResultSet rs = stmt.executeQuery(q1);

            return rs;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }
    
    public ResultSet SelectByIdMethod()
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

            String q1 = "SELECT * FROM RECRUITMENT_DRIVE " +
                        "WHERE DRIVE_ID = " + driveId +
                        " AND COMPANY_ID = " + companyId;

            ResultSet rs = stmt.executeQuery(q1);

            return rs;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean UpdateMethod()
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

            String q1 = "UPDATE RECRUITMENT_DRIVE SET " +
                        "DRIVE_TYPE = '" + getDriveType() + "', " +
                        "JOB_TITLE = '" + getJobTitle() + "', " +
                        "DESCRIPTION = '" + getDescription() + "', " +
                        "VACANCY = " + getVacancy() + ", " +
                        "ELIGIBILITY_CGPA = " + getEligibilityCgpa() + ", " +
                        "REQUIRED_BRANCH = '" + getRequiredBranch() + "', " +
                        "REQUIRED_SKILLS = '" + getRequiredSkills() + "', " +
                        "SALARY = " + getSalary() + ", " +
                        "DEADLINE = TO_DATE('" + getDeadline() + "', 'YYYY-MM-DD'), " +
                        "STATUS = '" + getStatus() + "' " +
                        "WHERE DRIVE_ID = " + getDriveId() +
                        " AND COMPANY_ID = " + getCompanyId();

            int x = stmt.executeUpdate(q1);

            con.close();

            if(x > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }
        
        public boolean CloseMethod()
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

                String q1 = "UPDATE RECRUITMENT_DRIVE " +
                            "SET STATUS = 'CLOSED' " +
                            "WHERE DRIVE_ID = " + getDriveId() +
                            " AND COMPANY_ID = " + getCompanyId();

                int x = stmt.executeUpdate(q1);

                con.close();

                if(x > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
                return false;
            }
        }
        
        public int TotalDriveMethod()
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

                String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE " +
                            "WHERE COMPANY_ID = " + getCompanyId();

                ResultSet rs = stmt.executeQuery(q1);

                if(rs.next())
                {
                    int total = rs.getInt(1);

                    con.close();

                    return total;
                }

                con.close();

                return 0;
            }
            catch(Exception e)
            {
                e.printStackTrace();
                return 0;
            }
        }
        
        public int ActiveDriveMethod()
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

                String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE " +
                            "WHERE COMPANY_ID = " + getCompanyId() +
                            " AND STATUS = 'ACTIVE'";

                ResultSet rs = stmt.executeQuery(q1);

                if(rs.next())
                {
                    int total = rs.getInt(1);

                    con.close();

                    return total;
                }

                con.close();

                return 0;
            }
            catch(Exception e)
            {
                e.printStackTrace();
                return 0;
            }
        }
        
        public int ClosedDriveMethod()
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

                String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE " +
                            "WHERE COMPANY_ID = " + getCompanyId() +
                            " AND STATUS = 'CLOSED'";

                ResultSet rs = stmt.executeQuery(q1);

                if(rs.next())
                {
                    int total = rs.getInt(1);

                    con.close();

                    return total;
                }

                con.close();

                return 0;
            }
            catch(Exception e)
            {
                e.printStackTrace();
                return 0;
            }
        }
        
        public int TotalVacancyMethod()
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

                String q1 = "SELECT NVL(SUM(VACANCY), 0) " +
                            "FROM RECRUITMENT_DRIVE " +
                            "WHERE COMPANY_ID = " + getCompanyId();

                ResultSet rs = stmt.executeQuery(q1);

                if(rs.next())
                {
                    int total = rs.getInt(1);

                    con.close();

                    return total;
                }

                con.close();

                return 0;
            }
            catch(Exception e)
            {
                e.printStackTrace();
                return 0;
            }
        }
        
        public int CampusDriveMethod()
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

                String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE " +
                            "WHERE COMPANY_ID = " + getCompanyId() +
                            " AND DRIVE_TYPE = 'On Campus'";

                ResultSet rs = stmt.executeQuery(q1);

                if(rs.next())
                {
                    int total = rs.getInt(1);

                    con.close();

                    return total;
                }

                con.close();

                return 0;
            }
            catch(Exception e)
            {
                e.printStackTrace();
                return 0;
            }
        }
        
        public int DirectDriveMethod()
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

                String q1 = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE " +
                            "WHERE COMPANY_ID = " + getCompanyId() +
                            " AND DRIVE_TYPE = 'Direct'";

                ResultSet rs = stmt.executeQuery(q1);

                if(rs.next())
                {
                    int total = rs.getInt(1);

                    con.close();

                    return total;
                }

                con.close();

                return 0;
            }
            catch(Exception e)
            {
                e.printStackTrace();
                return 0;
            }
        }
    }
