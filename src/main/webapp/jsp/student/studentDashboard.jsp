<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Student, com.campusconnect.bean.Drive" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f4f4f4; }
        .header { background: #27ae60; color: white; padding: 20px; text-align: center; }
        .container { max-width: 1200px; margin: 40px auto; padding: 20px; }
        .welcome-card { background: white; padding: 30px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .drive-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .drive-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .drive-card h3 { color: #2c3e50; margin-bottom: 15px; }
        .drive-card p { margin: 10px 0; color: #555; }
        .btn-apply { background: #3498db; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; display: inline-block; margin-top: 10px; }
        .btn-apply:hover { background: #2980b9; }
        .btn-applied { background: #95a5a6; color: white; padding: 10px 20px; border-radius: 4px; display: inline-block; cursor: not-allowed; }
        .nav-links { margin-top: 30px; text-align: center; }
        .nav-links a { margin: 0 10px; color: #3498db; text-decoration: none; }
        .logout { display: block; text-align: center; margin-top: 40px; }
        .logout a { color: #e74c3c; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <% 
        Student student = (Student) session.getAttribute("student"); 
        List<Drive> drives = (List<Drive>) request.getAttribute("driveList");
    %>

    <div class="header">
        <h1>👨‍🎓 Student Dashboard</h1>
        <p>Welcome, <%= student != null ? student.getName() : "Student" %>!</p>
    </div>

    <div class="container">
        <div class="welcome-card">
            <h2>Hello, <%= student != null ? student.getName() : "Student" %>!</h2>
            <p>College ID: <%= student != null ? student.getCollegeId() : "" %> | 
               Year: <%= student != null ? student.getYear() : "" %> | 
               CGPA: <%= student != null ? student.getCgpa() : "" %></p>
        </div>

        <h2>🎯 Available Campus Drives</h2>
        
        <% if(drives == null || drives.isEmpty()) { %>
            <p style="text-align: center; color: #777;">No drives available at the moment.</p>
        <% } else { %>
            <div class="drive-grid">
                <% 
                for(Drive d : drives) { 
                    if("Upcoming".equals(d.getStatus()) || "Ongoing".equals(d.getStatus())) {
                %>
                    <div class="drive-card">
                        <h3><%= d.getCompanyName() %></h3>
                        <p><strong>Position:</strong> <%= d.getPosition() %></p>
                        <p><strong>Package:</strong> ₹<%= d.getPackageCtc() %> LPA</p>
                        <p><strong>Eligibility:</strong> <%= d.getEligibilityCriteria() %></p>
                        <p><strong>Deadline:</strong> <%= d.getRegistrationDeadline() %></p>
                        
                        <a href="${pageContext.request.contextPath}/StudentController?action=apply&driveId=<%= d.getDriveId() %>" class="btn-apply">Apply Now</a>
                    </div>
                <% } } %>
            </div>
        <% } %>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/StudentController?action=viewStatus">📋 My Applications</a> |
            <a href="${pageContext.request.contextPath}/StudentController?action=profile">👤 My Profile</a>
        </div>

        <div class="logout">
            <a href="${pageContext.request.contextPath}/StudentController?action=logout"> Logout</a>
        </div>
    </div>
</body>
</html>