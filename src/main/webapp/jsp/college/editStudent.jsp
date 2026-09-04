<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.Student" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Student - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; }
        .container { max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #2c3e50; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #2980b9; }
        .back-link { display: block; text-align: center; margin-top: 15px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <% Student student = (Student) request.getAttribute("student"); %>
    
    <div class="container">
        <h2>👨‍ Edit Student</h2>

        <% if(student != null) { %>
            
            <form action="${pageContext.request.contextPath}/StudentController" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="studentId" value="<%= student.getStudentId() %>">

                <div class="form-group">
                    <label>Name:</label>
                    <input type="text" name="name" value="<%= student.getName() %>" required>
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" value="<%= student.getEmail() %>" required>
                </div>

                <div class="form-group">
                    <label>Phone:</label>
                    <input type="text" name="phone" value="<%= student.getPhone() %>" required>
                </div>

                <div class="form-group">
                    <label>Department ID:</label>
                    <input type="number" name="departmentId" value="<%= student.getDepartmentId() %>" required>
                </div>

                <div class="form-group">
                    <label>Course ID:</label>
                    <input type="number" name="courseId" value="<%= student.getCourseId() %>" required>
                </div>

                <div class="form-group">
                    <label>Year:</label>
                    <select name="year" required>
                        <option value="1" <%= student.getYear()==1?"selected":"" %>>1st Year</option>
                        <option value="2" <%= student.getYear()==2?"selected":"" %>>2nd Year</option>
                        <option value="3" <%= student.getYear()==3?"selected":"" %>>3rd Year</option>
                        <option value="4" <%= student.getYear()==4?"selected":"" %>>4th Year</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>CGPA:</label>
                    <input type="number" step="0.01" name="cgpa" value="<%= student.getCgpa() %>" required>
                </div>

                <div class="form-group">
                    <label>Status:</label>
                    <select name="status" required>
                        <option value="Active" <%= "Active".equals(student.getStatus())?"selected":"" %>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(student.getStatus())?"selected":"" %>>Inactive</option>
                    </select>
                </div>

                <button type="submit">Update Student</button>
            </form>

        <% } else { %>
            <p style="text-align: center; color: red;">Student not found!</p>
        <% } %>

        <a href="${pageContext.request.contextPath}/StudentController?action=list" class="back-link">← Back to Student List</a>
    </div>
</body>
</html>