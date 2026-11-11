package com.campusconnect.bean;

public class SystemSetting {

    // ===========================
    // VARIABLES
    // ===========================

    private int settingId;

    private String studentRegistration;

    private String collegeRegistration;

    private String companyRegistration;

    private String admissionRequest;

    private String recruitmentDrive;

    private String maintenanceMode;

    // ===========================
    // DEFAULT CONSTRUCTOR
    // ===========================

    public SystemSetting() {

    }

    // ===========================
    // GETTERS
    // ===========================

    public int getSettingId() {
        return settingId;
    }

    public String getStudentRegistration() {
        return studentRegistration;
    }

    public String getCollegeRegistration() {
        return collegeRegistration;
    }

    public String getCompanyRegistration() {
        return companyRegistration;
    }

    public String getAdmissionRequest() {
        return admissionRequest;
    }

    public String getRecruitmentDrive() {
        return recruitmentDrive;
    }

    public String getMaintenanceMode() {
        return maintenanceMode;
    }

    // ===========================
    // SETTERS
    // ===========================

    public void setSettingId(int settingId) {
        this.settingId = settingId;
    }

    public void setStudentRegistration(String studentRegistration) {
        this.studentRegistration = studentRegistration;
    }

    public void setCollegeRegistration(String collegeRegistration) {
        this.collegeRegistration = collegeRegistration;
    }

    public void setCompanyRegistration(String companyRegistration) {
        this.companyRegistration = companyRegistration;
    }

    public void setAdmissionRequest(String admissionRequest) {
        this.admissionRequest = admissionRequest;
    }

    public void setRecruitmentDrive(String recruitmentDrive) {
        this.recruitmentDrive = recruitmentDrive;
    }

    public void setMaintenanceMode(String maintenanceMode) {
        this.maintenanceMode = maintenanceMode;
    }

}