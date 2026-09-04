<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.Faculty" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Faculty - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            margin: 40px; 
            background: #f4f4f4; 
        }
        .container { 
            max-width: 600px; 
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
        .form-group { 
            margin-bottom: 15px; 
        }
        label { 
            display: block; 
            margin-bottom: 5px; 
            font-weight: bold; 
        }
        input { 
            width: 100%; 
            padding: 10px; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            box-sizing: border-box; 
        }
        button { 
            width: 100%; 
            padding: 12px; 
            background: #3498db; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px; 
        }
        button:hover { 
            background: #2980b9; 
        }
        .message { 
            color: red; 
            text-align: center; 
            margin-bottom: 15px; 
        }
        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 15px; 
            color: #3498db; 
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%-- Get Faculty object from request attribute --%>
    <% Faculty faculty = (Faculty) request.getAttribute("faculty"); %>
    
    <div class="container">
        <h2>‍Edit Faculty</h2>

        <%-- Display Error Message if any --%>
        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <%-- Check if faculty object exists --%>
        <% if(faculty != null) { %>
            
            <form action="FacultyController" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="facultyId" value="<%= faculty.getFacultyId() %>">

                <div class="form-group">
                    <label>College ID:</label>
                    <input type="number" name="collegeId" value="<%= faculty.getCollegeId() %>" required>
                </div>

                <div class="form-group">
                    <label>Department ID:</label>
                    <input type="number" name="departmentId" value="<%= faculty.getDepartmentId() %>" required>
                </div>

                <div class="form-group">
                    <label>Name:</label>
                    <input type="text" name="name" value="<%= faculty.getName() %>" required>
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" value="<%= faculty.getEmail() %>" required>
                </div>

                <div class="form-group">
                    <label>Phone:</label>
                    <input type="text" name="phone" value="<%= faculty.getPhone() %>" required>
                </div>

                <button type="submit">Update Faculty</button>
            </form>

        <% } else { %>
            <p style="text-align: center; color: red;">Faculty not found!</p>
        <% } %>

<a href="${pageContext.request.contextPath}/FacultyController?action=list">← Back to Faculty List</a>    </div>
</body>
</html>