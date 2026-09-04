<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Drive" %>
<%@ page import="java.text.SimpleDateFormat" %> <!-- ✅ IMPORT THIS -->
<!DOCTYPE html>
<html>
<head><title>Drive List</title></head>
<body style="font-family: Arial; padding: 40px;">
    <h2>🎯 Campus Drives</h2>
    <a href="${pageContext.request.contextPath}/DriveController?action=showCreate" style="background: #27ae60; color: white; padding: 10px; text-decoration: none; border-radius: 4px;">+ Create New Drive</a>
    
    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr style="background: #f4f4f4; text-align: left;">
            <th style="padding: 10px;">Company</th>
            <th>Title</th>
            <th>Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        <% 
        List<Drive> list = (List<Drive>) request.getAttribute("driveList");
        if(list != null && !list.isEmpty()) { // ✅ Added isEmpty check
            for(Drive d : list) { 
                // ✅ Format the date safely
                String dateStr = "-";
                if(d.getDriveDate() != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
                    dateStr = sdf.format(d.getDriveDate());
                }
        %>
        <tr style="border-bottom: 1px solid #ddd;">
            <td style="padding: 10px;"><%= d.getCompanyName() %></td>
            <td><%= d.getDriveTitle() %></td>
            <td><%= dateStr %></td> <!-- ✅ Use formatted variable instead of direct getter -->
            <td><span style="color: <%= "Upcoming".equals(d.getStatus()) ? "green" : "orange" %>"><%= d.getStatus() %></span></td>
            <td>
                <a href="<%= response.encodeURL(request.getContextPath() + "/ApplicationController?action=list&driveId=" + d.getDriveId()) %>">View Applicants</a>
            </td>
        </tr>
        <% } } else { %>
            <tr><td colspan="5" style="text-align:center; padding: 20px;">No drives found.</td></tr>
        <% } %>
    </table>
    <br>
    <a href="${pageContext.request.contextPath}/CollegeAdminController?action=dashboard">← Back to Dashboard</a>
</body>
</html>