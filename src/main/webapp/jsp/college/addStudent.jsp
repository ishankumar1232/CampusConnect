<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Student - CampusConnect</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; }
        .container { max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #2c3e50; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #219a52; }
        .message { color: red; text-align: center; margin-bottom: 15px; }
        .back-link { display: block; text-align: center; margin-top: 15px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2>👨‍ Add New Student</h2>

        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/StudentController" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label>Name:</label>
                <input type="text" name="name" required>
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" required>
            </div>

            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>

            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone" required>
            </div>

            <div class="form-group">
                <label>Department ID:</label>
                <input type="number" name="departmentId" required>
            </div>

            <div class="form-group">
                <label>Course ID:</label>
                <input type="number" name="courseId" required>
            </div>

            <div class="form-group">
                <label>Year:</label>
                <select name="year" required>
                    <option value="1">1st Year</option>
                    <option value="2">2nd Year</option>
                    <option value="3">3rd Year</option>
                    <option value="4">4th Year</option>
                </select>
            </div>

            <div class="form-group">
                <label>CGPA:</label>
                <input type="number" step="0.01" name="cgpa" required>
            </div>

            <div class="form-group">
                <label>Status:</label>
                <select name="status" required>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <button type="submit">Add Student</button>
        </form>

        <a href="${pageContext.request.contextPath}/StudentController?action=list" class="back-link">← Back to Student List</a>
    </div>
</body>
</html>