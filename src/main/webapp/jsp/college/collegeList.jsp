<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.campusconnect.bean.College" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>College List - CampusConnect</title>
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
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏛️ College List</h2>

        <a href="${pageContext.request.contextPath}/CollegeController?action=showAdd" class="btn btn-add">+ Add New College</a>

        <%
            List<College> collegeList = (List<College>) request.getAttribute("collegeList");
            if(collegeList == null || collegeList.isEmpty()) {
        %>
            <p style="text-align: center; color: #777; padding: 20px;">
                No colleges found. Add your first college!
            </p>
        <%
            } else {
        %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>College Name</th>
                        <th>Address</th>
                        <th>City</th>
                        <th>State</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for(College college : collegeList) {
                        String statusColor = "Active".equals(college.getStatus()) ? "green" : "red";
                        String statusIcon = "Active".equals(college.getStatus()) ? "✓ " : "";
                    %>
                        <tr>
                            <td><%= college.getCollegeId() %></td>
                            <td><%= college.getCollegeName() %></td>
                            <td><%= college.getAddress() %></td>
                            <td><%= college.getCity() %></td>
                            <td><%= college.getState() %></td>
                            <td><%= college.getEmail() %></td>
                            <td><%= college.getPhone() %></td>
                            <td>
                                <span style="color: <%= statusColor %>;"><%= statusIcon %><%= college.getStatus() %></span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/CollegeController?action=edit&collegeId=<%= college.getCollegeId() %>" 
                                   class="btn btn-edit">Edit</a>
                                <a href="${pageContext.request.contextPath}/CollegeController?action=delete&collegeId=<%= college.getCollegeId() %>" 
                                   class="btn btn-delete" 
                                   onclick="return confirm('Are you sure you want to delete?')">Delete</a>
                            </td>
                        </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        <%
            }
        %>

        <a href="${pageContext.request.contextPath}/CollegeAdminController?action=dashboard" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>