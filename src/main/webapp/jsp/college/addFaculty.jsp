<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Faculty - CampusConnect</title>
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
            background: #27ae60; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px; 
        }
        button:hover { 
            background: #219a52; 
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
    <div class="container">
        <h2>Add New Faculty</h2>

        <%-- Display Error Message if any --%>
        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <form action="FacultyController" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label>College ID:</label>
                <input type="number" name="collegeId" placeholder="Enter college ID" required>
            </div>

            <div class="form-group">
                <label>Department ID:</label>
                <input type="number" name="departmentId" placeholder="Enter department ID" required>
            </div>

            <div class="form-group">
                <label>Name:</label>
                <input type="text" name="name" placeholder="Enter faculty name" required>
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" placeholder="Enter email address" required>
            </div>

            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone" placeholder="Enter phone number" required>
            </div>

            <button type="submit">Add Faculty</button>
        </form>

<a href="${pageContext.request.contextPath}/FacultyController?action=list">← Back to Faculty List</a>    </div>
</body>
</html>