<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Company" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company List - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        tr:hover { background: #f5f5f5; }
        .btn { padding: 8px 15px; text-decoration: none; border-radius: 4px; margin-right: 5px; font-size: 14px; display: inline-block; }
        .btn-add { background: #27ae60; color: white; margin-bottom: 15px; }
        .btn-edit { background: #f39c12; color: white; }
        .btn-delete { background: #e74c3c; color: white; }
        .back-link { display: block; margin-top: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏢 Company List</h2>

        <a href="${pageContext.request.contextPath}/CompanyController?action=showAdd" class="btn btn-add">+ Add New Company</a>

        <% 
            List<Company> companyList = (List<Company>) request.getAttribute("companyList");
        %>

        <% if(companyList == null || companyList.isEmpty()) { %>
            <p style="text-align: center; color: #777; padding: 20px;">No companies available.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Company Name</th>
                        <th>Industry</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Company c : companyList) { %>
                    <tr>
                        <td><%= c.getCompanyId() %></td>
                        <td><strong><%= c.getCompanyName() != null ? c.getCompanyName() : "Unknown" %></strong></td>
                        <td><%= c.getIndustry() != null ? c.getIndustry() : "-" %></td>
                        <td><%= c.getEmail() != null ? c.getEmail() : "-" %></td>
                        <td><%= c.getPhone() != null ? c.getPhone() : "-" %></td>
                        <td><%= c.getStatus() != null ? c.getStatus() : "Active" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/CompanyController?action=edit&companyId=<%= c.getCompanyId() %>" class="btn btn-edit">Edit</a>
                            <a href="${pageContext.request.contextPath}/CompanyController?action=delete&companyId=<%= c.getCompanyId() %>" class="btn btn-delete" onclick="return confirm('Delete?')">Delete</a>
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