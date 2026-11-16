package com.campusconnect.bean;

public class SystemSetting {

    // VARIABLES

    private int settingId = 1;

    private String studentRegistration = "ON";

    private String collegeRegistration = "ON";

    private String companyRegistration = "ON";

    private String admissionRequest = "ON";

    private String recruitmentDrive = "ON";

    private String maintenanceMode = "OFF";

    // DEFAULT CONSTRUCTOR

    public SystemSetting() {

    }

    // GETTERS

    public int getSettingId() {
        return settingId;
    }

    public String getStudentRegistration() {
        return studentRegistration != null ? studentRegistration : "ON";
    }

    public String getCollegeRegistration() {
        return collegeRegistration != null ? collegeRegistration : "ON";
    }

    public String getCompanyRegistration() {
        return companyRegistration != null ? companyRegistration : "ON";
    }

    public String getAdmissionRequest() {
        return admissionRequest != null ? admissionRequest : "ON";
    }

    public String getRecruitmentDrive() {
        return recruitmentDrive != null ? recruitmentDrive : "ON";
    }

    public String getMaintenanceMode() {
        return maintenanceMode != null ? maintenanceMode : "OFF";
    }

    // SETTERS

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