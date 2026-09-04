package com.campusconnect.bean;

public class College {
    
    private int collegeId;
    private String collegeName;
    private String address;
    private String city;
    private String state;
    private String email;
    private String phone;
    private String status;

    // Default Constructor
    public College() {
    }

    // Parameterized Constructor
    public College(String collegeName, String address, 
                   String city, String state, 
                   String email, String phone, 
                   String status) {
        this.collegeName = collegeName;
        this.address = address;
        this.city = city;
        this.state = state;
        this.email = email;
        this.phone = phone;
        this.status = status;
    }

    // Getters and Setters
    public int getCollegeId() {
        return collegeId;
    }

    public void setCollegeId(int collegeId) {
        this.collegeId = collegeId;
    }

    public String getCollegeName() {
        return collegeName;
    }

    public void setCollegeName(String collegeName) {
        this.collegeName = collegeName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "College{" +
                "collegeId=" + collegeId +
                ", collegeName='" + collegeName + '\'' +
                ", city='" + city + '\'' +
                ", state='" + state + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}