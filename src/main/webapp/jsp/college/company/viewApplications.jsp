<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Application" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Applications - CampusConnect</title>
    <style>
        body { font-family: Arial; padding: 40px; background: #f4f4f4; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        tr:hover { background: #f5f5f5; }
        .btn { padding: 6px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 13px; margin-right: 5px; display: inline-block; }
        .btn-shortlist { background: #f39c12; }
        .btn-select { background: #27ae60; }
        .btn-reject { background: #e74c3c; }
        .btn:hover { opacity: 0.8; }
        .back-link { display: block; margin-top: 20px; color: #3498db; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
        .error-message { background: #f8d7da; color: #721c24; padding: 15px; border-radius: 6px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>👥 Student Applications</h2>
        
        <%-- ✅ FIX: Handle null driveId --%>
        <% 
            Integer driveIdObj = (Integer) request.getAttribute("driveId");
            int driveId = (driveIdObj != null) ? driveIdObj : 0;
            
            List<Application> list = (List<Application>) request.getAttribute("appList");
        %>

        <%-- Check for errors --%>
        <% if (driveId == 0) { %>
            <div class="error-message">
                <strong>⚠️ Error:</strong> Drive ID not found. Please go back and try again.
            </div>
        <% } %>

        <% if(list == null || list.isEmpty()) { %>
            <p style="text-align: center; color: #777; padding: 20px;">No applications yet.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th style="padding: 10px;">Student Name</th>
                        <th>Email</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Application a : list) { %>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td style="padding: 10px;"><strong><%= a.getStudentName() != null ? a.getStudentName() : "Unknown" %></strong></td>
                        <td><%= a.getStudentEmail() != null ? a.getStudentEmail() : "-" %></td>
                        <td>
                            <% 
                                String status = a.getStatus();
                                String statusColor = "gray";
                                if("Applied".equals(status)) statusColor = "gray";
                                else if("Shortlisted".equals(status)) statusColor = "#f39c12";
                                else if("Selected".equals(status)) statusColor = "green";
                                else if("Rejected".equals(status)) statusColor = "red";
                            %>
                            <span style="color: <%= statusColor %>; font-weight: bold;">
                                <%= status != null ? status : "Unknown" %>
                            </span>
                        </td>
                        <td>
                            <% if(!"Selected".equals(a.getStatus()) && !"Rejected".equals(a.getStatus())) { %>
                                <a href="${pageContext.request.contextPath}/ApplicationController?action=shortlist&appId=<%= a.getApplicationId() %>&driveId=<%= driveId %>" 
                                   class="btn btn-shortlist">Shortlist</a>
                                <a href="${pageContext.request.contextPath}/ApplicationController?action=select&appId=<%= a.getApplicationId() %>&driveId=<%= driveId %>" 
                                   class="btn btn-select">Select</a>
                                <a href="${pageContext.request.contextPath}/ApplicationController?action=reject&appId=<%= a.getApplicationId() %>&driveId=<%= driveId %>" 
                                   class="btn btn-reject">Reject</a>
                            <% } else { %>
                                <span style="color: #777;">Completed</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="${pageContext.request.contextPath}/DriveController?action=list" class="back-link">← Back to Drives</a>
    </div>
</body>
</html>