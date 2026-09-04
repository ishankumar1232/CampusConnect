package com.campusconnect.bean;

public class CollegeAdmin {
    private int adminId;
    private int collegeId;
    private String name;
    private String email;
    private String password;
    private String collegeName;  // ✅ ADDED THIS FIELD
    private String role;
    private String status;

    // Default Constructor
    public CollegeAdmin() {
    }

    // Parameterized Constructor
    public CollegeAdmin(int collegeId, String name, String email, String password) {
        this.collegeId = collegeId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = "college_admin";
        this.status = "Active";
    }

    // Constructor with collegeName
    public CollegeAdmin(int collegeId, String name, String email, String password, String collegeName) {
        this.collegeId = collegeId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.collegeName = collegeName;
        this.role = "college_admin";
        this.status = "Active";
    }

    // All Getters and Setters
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public int getCollegeId() { return collegeId; }
    public void setCollegeId(int collegeId) { this.collegeId = collegeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getCollegeName() { return collegeName; }  // ✅ ADDED THIS
    public void setCollegeName(String collegeName) { this.collegeName = collegeName; }  // ✅ ADDED THIS

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "CollegeAdmin{" +
                "adminId=" + adminId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", collegeName='" + collegeName + '\'' +
                '}';
    }
}