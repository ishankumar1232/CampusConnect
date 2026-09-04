<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Login - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            background: linear-gradient(135deg, #2c3e50, #27ae60); 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0; 
        }
        .login-box { 
            background: white; 
            padding: 40px; 
            border-radius: 8px; 
            box-shadow: 0 0 20px rgba(0,0,0,0.3); 
            width: 350px; 
        }
        h2 { 
            text-align: center; 
            color: #2c3e50; 
            margin-bottom: 30px; 
        }
        .form-group { 
            margin-bottom: 20px; 
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
        .register-link { 
            text-align: center; 
            margin-top: 15px; 
        }
        .register-link a { 
            color: #3498db; 
            text-decoration: none; 
        }
        .admin-link {
            text-align: center;
            margin-top: 10px;
            font-size: 13px;
        }
        .admin-link a {
            color: #777;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>👨‍ Student Login</h2>

        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/StudentController" method="post">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>

            <button type="submit">Login</button>
        </form>

        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/StudentController?action=showRegister">Register Here</a>
        </div>

        <div class="admin-link">
            <a href="${pageContext.request.contextPath}/CollegeAdminController?action=showLogin">Admin Login</a>
        </div>
    </div>
</body>
</html>