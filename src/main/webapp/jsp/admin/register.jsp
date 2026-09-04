<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>College Admin Registration - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            background: #2c3e50; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh; 
            margin: 0; 
            padding: 20px;
        }
        .register-box { 
            background: white; 
            padding: 40px; 
            border-radius: 8px; 
            box-shadow: 0 0 20px rgba(0,0,0,0.3); 
            width: 400px; 
        }
        h2 { 
            text-align: center; 
            color: #2c3e50; 
            margin-bottom: 10px; 
        }
        .subtitle {
            text-align: center;
            color: #777;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .form-group { 
            margin-bottom: 20px; 
        }
        label { 
            display: block; 
            margin-bottom: 5px; 
            font-weight: bold; 
            color: #2c3e50;
        }
        input { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            box-sizing: border-box; 
            font-size: 14px;
        }
        button { 
            width: 100%; 
            padding: 14px; 
            background: #27ae60; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: bold;
        }
        button:hover { 
            background: #219a52; 
        }
        .message { 
            color: #e74c3c; 
            text-align: center; 
            margin-bottom: 15px; 
            padding: 10px;
            background: #fdeaea;
            border-radius: 4px;
        }
        .login-link { 
            text-align: center; 
            margin-top: 20px; 
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .login-link a { 
            color: #3498db; 
            text-decoration: none; 
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="register-box">
        <h2>College Admin Registration</h2>
        <p class="subtitle">Campus Recruitment Management System</p>

        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/CollegeAdminController" method="post">
            <input type="hidden" name="action" value="register">

           <div class="form-group">
    <label>Admin Name:</label>
    <input type="text" name="name" placeholder="Enter your full name" required>
</div>

<div class="form-group">
    <label>Email:</label>
    <input type="email" name="email" placeholder="Enter official email" required>
</div>

<div class="form-group">
    <label>Password:</label>
    <input type="password" name="password" placeholder="Create password" required>
</div>

<div class="form-group">
    <label>College Name:</label>  <!-- ✅ MAKE SURE THIS EXISTS -->
    <input type="text" name="collegeName" placeholder="Enter college name" required>
</div>

<div class="form-group">
    <label>College ID:</label>
    <input type="number" name="collegeId" placeholder="Enter college ID" required>
</div>

            <button type="submit">Register</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/CollegeAdminController?action=showLogin">Login Here</a>
        </div>
    </div>
</body>
</html>