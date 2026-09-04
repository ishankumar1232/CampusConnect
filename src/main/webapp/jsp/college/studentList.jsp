<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.campusconnect.bean.Student" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; }
        .container { max-width: 1200px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #2c3e50; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        tr:hover { background: #f5f5f5; }
        .btn { padding: 8px 15px; text-decoration: none; border-radius: 4px; margin-right: 5px; font-size: 14px; display: inline-block; }
        .btn-edit { background: #f39c12; color: white; }
        .btn-delete { background: #e74c3c; color: white; }
        .btn-add { background: #27ae60; color: white; display: inline-block; margin-bottom: 15px; text-decoration: none; }
        .back-link { display: block; text-align: center; margin-top: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2>👨‍ Student List</h2>

        <a href="${pageContext.request.contextPath}/StudentController?action=showAdd" class="btn btn-add">+ Add New Student</a>

        <%
            List<Student> studentList = (List<Student>) request.getAttribute("studentList");
            if(studentList == null || studentList.isEmpty()) {
        %>
            <p style="text-align: center; color: #777; padding: 20px;">No students found.</p>
        <%
            } else {
        %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Dept ID</th>
                        <th>Course ID</th>
                        <th>Year</th>
                        <th>CGPA</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for(Student student : studentList) {
                        String statusColor = "Active".equals(student.getStatus()) ? "green" : "red";
                    %>
                        <tr>
                            <td><%= student.getStudentId() %></td>
                            <td><%= student.getName() %></td>
                            <td><%= student.getEmail() %></td>
                            <td><%= student.getPhone() %></td>
                            <td><%= student.getDepartmentId() %></td>
                            <td><%= student.getCourseId() %></td>
                            <td><%= student.getYear() %></td>
                            <td><%= student.getCgpa() %></td>
                            <td><span style="color: <%= statusColor %>;"><%= student.getStatus() %></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/StudentController?action=edit&studentId=<%= student.getStudentId() %>" class="btn btn-edit">Edit</a>
                                <a href="${pageContext.request.contextPath}/StudentController?action=delete&studentId=<%= student.getStudentId() %>" class="btn btn-delete" onclick="return confirm('Delete?')">Delete</a>
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