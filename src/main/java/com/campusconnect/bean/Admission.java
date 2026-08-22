package com.campusconnect.bean;
import java.sql.*;
import java.sql.Date;

public class Admission
{
    private int admissionId;
    private int studentId;
    private int collegeId;

    private String applicantName;
    private String applicantEmail;
    private String applicantPhone;

    private int applicantCourseId;

    private Date admissionDate;
    private String status;
    private Date approvedDate;


    public int getAdmissionId()
    {
        return admissionId;
    }

    public void setAdmissionId(int admissionId)
    {
        this.admissionId = admissionId;
    }


    public int getStudentId()
    {
        return studentId;
    }

    public void setStudentId(int studentId)
    {
        this.studentId = studentId;
    }


    public int getCollegeId()
    {
        return collegeId;
    }

    public void setCollegeId(int collegeId)
    {
        this.collegeId = collegeId;
    }


    public String getApplicantName()
    {
        return applicantName;
    }

    public void setApplicantName(String applicantName)
    {
        this.applicantName = applicantName;
    }


    public String getApplicantEmail()
    {
        return applicantEmail;
    }

    public void setApplicantEmail(String applicantEmail)
    {
        this.applicantEmail = applicantEmail;
    }


    public String getApplicantPhone()
    {
        return applicantPhone;
    }

    public void setApplicantPhone(String applicantPhone)
    {
        this.applicantPhone = applicantPhone;
    }


    public int getApplicantCourseId()
    {
        return applicantCourseId;
    }

    public void setApplicantCourseId(int applicantCourseId)
    {
        this.applicantCourseId = applicantCourseId;
    }


    public Date getAdmissionDate()
    {
        return admissionDate;
    }

    public void setAdmissionDate(Date admissionDate)
    {
        this.admissionDate = admissionDate;
    }


    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }


    public Date getApprovedDate()
    {
        return approvedDate;
    }

    public void setApprovedDate(Date approvedDate)
    {
        this.approvedDate = approvedDate;
    }
    public boolean InsertMethod()
    {
        boolean x = false;

        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            Statement stmt = con.createStatement();

            int newId = 1;

            ResultSet rs = stmt.executeQuery(
                "SELECT MAX(ADMISSION_ID) FROM ADMISSION"
            );

            if(rs.next())
            {
                if(rs.getObject(1) != null)
                {
                    newId = rs.getInt(1) + 1;
                }
            }

            String q =
                "INSERT INTO ADMISSION " +
                "(ADMISSION_ID, STUDENT_ID, COLLEGE_ID, " +
                "APPLICANT_NAME, APPLICANT_EMAIL, APPLICANT_PHONE, " +
                "APPLICANT_COURSE_ID, ADMISSION_DATE, STATUS) " +
                "VALUES (" +
                newId + ", NULL, " +
                collegeId + ", '" +
                applicantName + "', '" +
                applicantEmail + "', '" +
                applicantPhone + "', " +
                applicantCourseId + ", SYSDATE, 'PENDING')";

            int i = stmt.executeUpdate(q);

            if(i > 0)
            {
                x = true;
            }

            rs.close();
            stmt.close();
            con.close();
        }
        catch(Exception e)
        {
            System.out.println(e);
        }

        return x;
    }
}