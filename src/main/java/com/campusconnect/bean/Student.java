package com.campusconnect.bean;

public class Student {
    private int studentId;
    private String name;
    private String email;
    private String password;
    private String phone;
    private int collegeId;
    private int departmentId;
    private int courseId;
    private int year;
    private double cgpa;
    private String status;

    // Default Constructor
    public Student() {}

    // Parameterized Constructor
    public Student(String name, String email, String password, String phone, 
                  int collegeId, int departmentId, int courseId, 
                  int year, double cgpa, String status) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.collegeId = collegeId;
        this.departmentId = departmentId;
        this.courseId = courseId;
        this.year = year;
        this.cgpa = cgpa;
        this.status = status;
    }

    // Getters and Setters
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getCollegeId() { return collegeId; }
    public void setCollegeId(int collegeId) { this.collegeId = collegeId; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public double getCgpa() { return cgpa; }
    public void setCgpa(double cgpa) { this.cgpa = cgpa; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Student{" +
                "studentId=" + studentId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}