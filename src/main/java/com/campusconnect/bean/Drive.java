package com.campusconnect.bean;

import java.util.Date;

public class Drive {
    private int driveId;
    private int companyId;
    private String companyName; 
    private int collegeId;
    private String driveTitle;
    private String position;
    private int noOfHires;
    private String eligibilityCriteria;
    private double packageCtc;
    private Date registrationDeadline;
    private Date driveDate; // ✅ Field exists
    private String status;
    private int createdBy;
    private Date createdDate;

    // Default Constructor
    public Drive() {}

    // Parameterized Constructor
    public Drive(int companyId, int collegeId, String driveTitle, String position, 
                int noOfHires, String eligibilityCriteria, double packageCtc,
                Date registrationDeadline, Date driveDate, String status, int createdBy) {
        this.companyId = companyId;
        this.collegeId = collegeId;
        this.driveTitle = driveTitle;
        this.position = position;
        this.noOfHires = noOfHires;
        this.eligibilityCriteria = eligibilityCriteria;
        this.packageCtc = packageCtc;
        this.registrationDeadline = registrationDeadline;
        this.driveDate = driveDate;
        this.status = status;
        this.createdBy = createdBy;
    }

    // Getters & Setters
    public int getDriveId() { return driveId; }
    public void setDriveId(int driveId) { this.driveId = driveId; }

    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public int getCollegeId() { return collegeId; }
    public void setCollegeId(int collegeId) { this.collegeId = collegeId; }

    public String getDriveTitle() { return driveTitle; }
    public void setDriveTitle(String driveTitle) { this.driveTitle = driveTitle; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public int getNoOfHires() { return noOfHires; }
    public void setNoOfHires(int noOfHires) { this.noOfHires = noOfHires; }

    public String getEligibilityCriteria() { return eligibilityCriteria; }
    public void setEligibilityCriteria(String eligibilityCriteria) { this.eligibilityCriteria = eligibilityCriteria; }

    public double getPackageCtc() { return packageCtc; }
    public void setPackageCtc(double packageCtc) { this.packageCtc = packageCtc; }

    public Date getRegistrationDeadline() { return registrationDeadline; }
    public void setRegistrationDeadline(Date registrationDeadline) { this.registrationDeadline = registrationDeadline; }

    public Date getDriveDate() { return driveDate; } // ✅ Getter exists
    public void setDriveDate(Date driveDate) { this.driveDate = driveDate; } // ✅ Setter exists

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}