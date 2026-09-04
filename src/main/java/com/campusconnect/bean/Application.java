package com.campusconnect.bean;

import java.util.Date;

public class Application {
    private int applicationId;
    private int studentId;
    private String studentName;
    private String studentEmail;
    private int driveId;
    private String driveTitle;
    private String companyName;
    private Date applicationDate;
    private String status;
    private String resumePath;

    // Getters and Setters
    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
    public int getDriveId() { return driveId; }
    public void setDriveId(int driveId) { this.driveId = driveId; }
    public String getDriveTitle() { return driveTitle; }
    public void setDriveTitle(String driveTitle) { this.driveTitle = driveTitle; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public Date getApplicationDate() { return applicationDate; }
    public void setApplicationDate(Date applicationDate) { this.applicationDate = applicationDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getResumePath() { return resumePath; }
    public void setResumePath(String resumePath) { this.resumePath = resumePath; }
}
