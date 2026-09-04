package com.campusconnect.bean;

public class Course {

    private int courseId;
    private int departmentId;
    private String courseName;

    // Default Constructor
    public Course() {
    }

    // Parameterized Constructor
    public Course(int departmentId, String courseName) {
        this.departmentId = departmentId;
        this.courseName = courseName;
    }

    // Getters and Setters
    public int getCourseId() {
        return courseId;
    }
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getCourseName() {
        return courseName;
    }
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    @Override
    public String toString() {
        return "Course{" +
                "courseId=" + courseId +
                ", departmentId=" + departmentId +
                ", courseName='" + courseName + '\'' +
                '}';
    }
}