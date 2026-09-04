<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add College - CampusConnect</title>
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
        input, select { 
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
        <h2>Add New College</h2>

        <%-- Display Error Message if any --%>
        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <form action="CollegeController" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label>College Name:</label>
                <input type="text" name="collegeName" placeholder="Enter college name" required>
            </div>

            <div class="form-group">
                <label>Address:</label>
                <input type="text" name="address" placeholder="Enter full address" required>
            </div>

            <div class="form-group">
                <label>City:</label>
                <input type="text" name="city" placeholder="Enter city" required>
            </div>

            <div class="form-group">
                <label>State:</label>
                <input type="text" name="state" placeholder="Enter state" required>
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" placeholder="Enter email address" required>
            </div>

            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone" placeholder="Enter phone number" required>
            </div>

            <div class="form-group">
                <label>Status:</label>
                <select name="status" required>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <button type="submit">Add College</button>
        </form>

<a href="${pageContext.request.contextPath}/CollegeController?action=list">← Back to College List</a>    </div>
</body>
</html>