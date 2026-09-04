<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Application" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Applications - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        .status-applied { color: #777; }
        .status-shortlisted { color: #f39c12; font-weight: bold; }
        .status-selected { color: #27ae60; font-weight: bold; }
        .status-rejected { color: #e74c3c; }
        .back-link { display: block; margin-top: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2>📋 My Application Status</h2>

        <% 
            List<Application> apps = (List<Application>) request.getAttribute("appList");
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
        %>

        <% if(apps == null || apps.isEmpty()) { %>
            <p style="text-align: center; color: #777;">You haven't applied to any drives yet.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Company</th>
                        <th>Position</th>
                        <th>Applied Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Application app : apps) { 
                        String statusClass = "status-applied";
                        if("Shortlisted".equals(app.getStatus())) statusClass = "status-shortlisted";
                        if("Selected".equals(app.getStatus())) statusClass = "status-selected";
                        if("Rejected".equals(app.getStatus())) statusClass = "status-rejected";
                    %>
                    <tr>
                        <td><strong><%= app.getCompanyName() %></strong></td>
                        <td><%= app.getDriveTitle() %></td>
                        <td><%= app.getApplicationDate() != null ? sdf.format(app.getApplicationDate()) : "-" %></td>
                        <td><span class="<%= statusClass %>"><%= app.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="${pageContext.request.contextPath}/StudentController?action=dashboard" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>