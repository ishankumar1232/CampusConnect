<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Registration - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            background: linear-gradient(135deg, #2c3e50, #27ae60); 
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
        .login-link { 
            text-align: center; 
            margin-top: 15px; 
        }
        .login-link a { 
            color: #3498db; 
            text-decoration: none; 
        }
    </style>
</head>
<body>
    <div class="register-box">
        <h2> Student Registration</h2>

        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/StudentController" method="post">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label>Full Name:</label>
                <input type="text" name="name" placeholder="Enter your name" required>
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" placeholder="Create password" required>
            </div>

            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone" placeholder="Enter phone number" required>
            </div>

            <div class="form-group">
                <label>College ID:</label>
                <input type="number" name="collegeId" placeholder="Enter your college ID" required>
            </div>

            <div class="form-group">
                <label>Department ID:</label>
                <input type="number" name="departmentId" placeholder="Enter department ID" required>
            </div>

            <div class="form-group">
                <label>Course ID:</label>
                <input type="number" name="courseId" placeholder="Enter course ID" required>
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
                <input type="number" step="0.01" name="cgpa" placeholder="Enter CGPA" required>
            </div>

            <button type="submit">Register</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/StudentController?action=showLogin">Login Here</a>
        </div>
    </div>
</body>
</html>