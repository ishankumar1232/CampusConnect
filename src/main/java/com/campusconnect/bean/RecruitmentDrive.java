package com.campusconnect.bean;

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

    public int getDriveId() {
        return driveId;
    }

    public void setDriveId(int driveId) {
        this.driveId = driveId;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getDriveType() {
        return driveType;
    }

    public void setDriveType(String driveType) {
        this.driveType = driveType;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getVacancy() {
        return vacancy;
    }

    public void setVacancy(int vacancy) {
        this.vacancy = vacancy;
    }

    public double getEligibilityCgpa() {
        return eligibilityCgpa;
    }

    public void setEligibilityCgpa(double eligibilityCgpa) {
        this.eligibilityCgpa = eligibilityCgpa;
    }

    public String getRequiredBranch() {
        return requiredBranch;
    }

    public void setRequiredBranch(String requiredBranch) {
        this.requiredBranch = requiredBranch;
    }

    public String getRequiredSkills() {
        return requiredSkills;
    }

    public void setRequiredSkills(String requiredSkills) {
        this.requiredSkills = requiredSkills;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public String getDeadline() {
        return deadline;
    }

    public void setDeadline(String deadline) {
        this.deadline = deadline;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}