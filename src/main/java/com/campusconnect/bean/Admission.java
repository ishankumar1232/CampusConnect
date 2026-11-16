package com.campusconnect.bean;
import java.sql.*;
import java.sql.Date;
import com.campusconnect.util.DBConnection;

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
    private double admissionFee;

    public double getAdmissionFee() {
        return admissionFee;
    }

    public void setAdmissionFee(double admissionFee) {
        this.admissionFee = admissionFee;
    }

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
        String idSql = "SELECT NVL(MAX(ADMISSION_ID),0)+1 FROM ADMISSION";
        String q =
            "INSERT INTO ADMISSION " +
            "(ADMISSION_ID, STUDENT_ID, COLLEGE_ID, " +
            "APPLICANT_NAME, APPLICANT_EMAIL, " +
            "APPLICANT_PHONE, APPLICANT_COURSE_ID, " +
            "ADMISSION_DATE, STATUS, ADMISSION_FEE) " +
            "VALUES (?, NULL, ?, ?, ?, ?, ?, SYSDATE, 'PENDING', " +
            "NVL((SELECT DEFAULT_ADMISSION_FEE FROM COLLEGE WHERE COLLEGE_ID=?), 50000))";

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(idSql))
        {
            int newId = 1;
            if(rs.next())
            {
                newId = rs.getInt(1);
            }
            this.admissionId = newId;

            try (PreparedStatement ps = con.prepareStatement(q))
            {
                ps.setInt(1, newId);
                ps.setInt(2, collegeId);
                ps.setString(3, applicantName);
                ps.setString(4, applicantEmail);
                ps.setString(5, applicantPhone);
                ps.setInt(6, applicantCourseId);
                ps.setInt(7, collegeId);

                int i = ps.executeUpdate();
                return i > 0;
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

    // Count Pending Admission Requests
    public int getPendingAdmissionCount(int collegeId)
    {
        int count = 0;
        String sql =
            "SELECT COUNT(*) FROM ADMISSION " +
            "WHERE COLLEGE_ID=? AND STATUS='PENDING'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setInt(1, collegeId);
            try (ResultSet rs = ps.executeQuery())
            {
                if(rs.next())
                {
                    count = rs.getInt(1);
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return count;
    }

    public boolean updateAdmissionStatus(int admissionId, String status) {
        return updateAdmissionStatus(admissionId, status, 50000.0);
    }

    public boolean updateAdmissionStatus(int admissionId, String status, double admissionFee) {
        String sql =
            "UPDATE ADMISSION " +
            "SET STATUS=?, APPROVED_DATE=SYSDATE, ADMISSION_FEE=? " +
            "WHERE ADMISSION_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setString(1, status);
            ps.setDouble(2, admissionFee);
            ps.setInt(3, admissionId);

            int i = ps.executeUpdate();
            return i > 0;
        }
        catch(Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}