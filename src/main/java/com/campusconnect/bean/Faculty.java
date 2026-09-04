package com.campusconnect.bean;

public class Faculty {

    private int facultyId;
    private int collegeId;
    private int departmentId;
    private String name;
    private String email;
    private String phone;

    // Default Constructor
    public Faculty() {
    }

    // Parameterized Constructor
    public Faculty(int collegeId, int departmentId, String name,
                   String email, String phone) {
        this.collegeId = collegeId;
        this.departmentId = departmentId;
        this.name = name;
        this.email = email;
        this.phone = phone;
    }

    // Getters and Setters
    public int getFacultyId() {
        return facultyId;
    }
    public void setFacultyId(int facultyId) {
        this.facultyId = facultyId;
    }

    public int getCollegeId() {
        return collegeId;
    }
    public void setCollegeId(int collegeId) {
        this.collegeId = collegeId;
    }

    public int getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Override
    public String toString() {
        return "Faculty{" +
                "facultyId=" + facultyId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}