<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>College Admin Login</title>

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f4f6f8;
}

.container {
    width: 400px;
    margin: 80px auto;
    background-color: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 0 10px #ccc;
}

h2 {
    text-align: center;
    color: #2c3e50;
}

label {
    display: block;
    margin-top: 15px;
}

input {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    box-sizing: border-box;
}

button {
    width: 100%;
    padding: 10px;
    margin-top: 20px;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #2980b9;
}

.register {
    text-align: center;
    margin-top: 20px;
}

.register a {
    color: #3498db;
    text-decoration: none;
}

</style>

</head>

<body>

<div class="container">

    <h2>College Admin Login</h2>

    <form action="${pageContext.request.contextPath}/CollegeAdminLogin"
          method="post">

        <label>Email</label>

        <input type="email"
               name="email"
               placeholder="Enter email"
               required>


        <label>Password</label>

        <input type="password"
               name="password"
               placeholder="Enter password"
               required>


        <button type="submit">Login</button>

    </form>


    <div class="register">

        <a href="${pageContext.request.contextPath}/collegeAdminRegister.jsp">
            Don't have an account? Register
        </a>

    </div>

</div>

</body>
</html>