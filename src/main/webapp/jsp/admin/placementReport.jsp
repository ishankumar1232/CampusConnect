<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Application" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Placement Report - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; border-bottom: 2px solid #27ae60; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #27ae60; color: white; }
        tr:hover { background: #f5f5f5; }
        .back-link { display: block; margin-top: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🎓 Placement Report - Selected Students</h2>

        <% List<Application> selectedList = (List<Application>) request.getAttribute("selectedList"); %>

        <% if(selectedList == null || selectedList.isEmpty()) { %>
            <p style="text-align: center; color: #777; padding: 20px;">No placements yet.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Company</th>
                        <th>Position</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Application app : selectedList) { %>
                    <tr>
                        <td><strong><%= app.getStudentName() %></strong></td>
                        <td><%= app.getStudentEmail() %></td>
                        <td><%= app.getCompanyName() %></td>
                        <td><%= app.getDriveTitle() %></td>
                        <td><span style="color: green; font-weight: bold;">✓ <%= app.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="${pageContext.request.contextPath}/ReportController?action=dashboard" class="back-link">← Back to Reports</a>
    </div>
</body>
</html>