<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>College Admin Registration</title>

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f4f6f8;
}

.container {
    width: 400px;
    margin: 60px auto;
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
    margin-top: 10px;
}

input {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    margin-bottom: 15px;
    box-sizing: border-box;
}

button {
    width: 100%;
    padding: 10px;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #2980b9;
}

.login {
    text-align: center;
    margin-top: 20px;
}

.login a {
    color: #3498db;
    text-decoration: none;
}

</style>

</head>

<body>

<div class="container">

    <h2>College Admin Registration</h2>

    <form action="${pageContext.request.contextPath}/CollegeAdminController"
          method="post">

        <label>College ID</label>
        <input type="number" name="collegeId" value="1" required>

        <label>Name</label>
        <input type="text" name="name"
               placeholder="Enter admin name" required>

        <label>Email</label>
        <input type="email" name="email"
               placeholder="Enter email" required>

        <label>Password</label>
        <input type="password" name="password"
               placeholder="Enter password" required>

        <button type="submit">Register</button>

    </form>

    <div class="login">
        <a href="${pageContext.request.contextPath}/collegeAdminLogin.jsp">
            Already have an account? Login
        </a>
    </div>

</div>

</body>
</html>