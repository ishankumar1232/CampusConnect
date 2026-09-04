<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            background: #2c3e50; 
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
            padding: 10px;
            background: #fdeaea;
            border-radius: 4px;
        }
        .success-message {
            color: #27ae60;
            background: #eafaf1;
        }
        .register-link { 
            text-align: center; 
            margin-top: 20px; 
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .register-link a { 
            color: #3498db; 
            text-decoration: none; 
            font-weight: bold;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Admin Login</h2>

        <%-- Display Message (Error or Success) --%>
        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/CollegeAdminController" method="post">
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

        <%-- Registration Link --%>
        <div class="register-link" style="text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
    <p>Don't have an account? 
        <a href="${pageContext.request.contextPath}/CollegeAdminController?action=showRegister" 
           style="color: #3498db; text-decoration: none; font-weight: bold;">Register Here</a>
    </p>
</div>
    </div>
</body>
</html>