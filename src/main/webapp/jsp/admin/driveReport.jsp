<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Drive" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Drive Report - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; border-bottom: 2px solid #f39c12; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f39c12; color: white; }
        tr:hover { background: #f5f5f5; }
        .back-link { display: block; margin-top: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2> Campus Drive Report</h2>

        <% 
            List<Drive> drives = (List<Drive>) request.getAttribute("driveList");
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
        %>

        <% if(drives == null || drives.isEmpty()) { %>
            <p style="text-align: center; color: #777; padding: 20px;">No drives available.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Company</th>
                        <th>Position</th>
                        <th>Drive Date</th>
                        <th>Package</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Drive d : drives) { 
                        String statusColor = "blue";
                        if("Ongoing".equals(d.getStatus())) statusColor = "orange";
                        if("Completed".equals(d.getStatus())) statusColor = "green";
                    %>
                    <tr>
                        <td><strong><%= d.getCompanyName() %></strong></td>
                        <td><%= d.getPosition() %></td>
                        <td><%= d.getDriveDate() != null ? sdf.format(d.getDriveDate()) : "-" %></td>
                        <td>₹<%= d.getPackageCtc() %> LPA</td>
                        <td><span style="color: <%= statusColor %>; font-weight: bold;"><%= d.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="${pageContext.request.contextPath}/ReportController?action=dashboard" class="back-link">← Back to Reports</a>
    </div>
</body>
</html>