package com.campusconnect.bean;

public class Department {

    private int departmentId;
    private int collegeId;
    private String departmentName;

    // Default Constructor
    public Department() {
    }

    // Parameterized Constructor
    public Department(int collegeId, String departmentName) {
        this.collegeId = collegeId;
        this.departmentName = departmentName;
    }

    // Getters and Setters
    public int getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public int getCollegeId() {
        return collegeId;
    }
    public void setCollegeId(int collegeId) {
        this.collegeId = collegeId;
    }

    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    @Override
    public String toString() {
        return "Department{" +
                "departmentId=" + departmentId +
                ", collegeId=" + collegeId +
                ", departmentName='" + departmentName + '\'' +
                '}';
    }
}