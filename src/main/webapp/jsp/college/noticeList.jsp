<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.campusconnect.bean.Notice" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notice List - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            margin: 40px; 
            background: #f4f4f4; 
        }
        .container { 
            max-width: 1000px; 
            margin: auto; 
            background: white; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        h2 { 
            text-align: center; 
            color: #2c3e50; 
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
        }
        th, td { 
            padding: 12px; 
            text-align: left; 
            border-bottom: 1px solid #ddd; 
        }
        th { 
            background: #3498db; 
            color: white; 
        }
        tr:hover { 
            background: #f5f5f5; 
        }
        .btn { 
            padding: 8px 15px; 
            text-decoration: none; 
            border-radius: 4px; 
            margin-right: 5px; 
            font-size: 14px;
            display: inline-block;
        }
        .btn-edit { 
            background: #f39c12; 
            color: white; 
        }
        .btn-delete { 
            background: #e74c3c; 
            color: white; 
        }
        .btn-add { 
            background: #27ae60; 
            color: white; 
            display: inline-block; 
            margin-bottom: 15px; 
            text-decoration: none;
        }
        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 20px; 
            color: #3498db;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2> Notice List</h2>

        <a href="${pageContext.request.contextPath}/NoticeController?action=showAdd" class="btn btn-add">+ Add New Notice</a>

        <% List<Notice> noticeList = (List<Notice>) request.getAttribute("noticeList");
        
           if(noticeList == null || noticeList.isEmpty()) { 
        %>
            <p style="text-align: center; color: #777; padding: 20px;">No notices found. Add your first notice!</p>
        <% 
           } else { 
        %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>College ID</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Notice notice : noticeList) { 
                        String statusColor = "Active".equals(notice.getStatus()) ? "green" : "red";
                        String statusIcon = "Active".equals(notice.getStatus()) ? "✓ " : "";
                    %>
                        <tr>
                            <td><%= notice.getNoticeId() %></td>
                            <td><%= notice.getTitle() %></td>
                            <td><%= notice.getCollegeId() %></td>
                            <td><%= notice.getPostedDate() %></td>
                            <td>
                                <span style="color: <%= statusColor %>;"><%= statusIcon %><%= notice.getStatus() %></span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/NoticeController?action=edit&noticeId=<%= notice.getNoticeId() %>" 
                                   class="btn btn-edit">Edit</a>
                                <a href="${pageContext.request.contextPath}/NoticeController?action=delete&noticeId=<%= notice.getNoticeId() %>" 
                                   class="btn btn-delete" 
                                   onclick="return confirm('Are you sure you want to delete this notice?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="${pageContext.request.contextPath}/CollegeAdminController?action=dashboard" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>