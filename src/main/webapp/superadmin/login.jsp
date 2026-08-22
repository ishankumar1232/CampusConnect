<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Super Admin Login</title>



<style>

body{
font-family:Arial;
background:#f2f2f2;
margin:0;
}

.login-box{
width:350px;
margin:100px auto;
padding:30px 25px;
background:white;
border-radius:10px;
box-shadow:0px 0px 15px rgba(0,0,0,0.1); 
}

h2{
text-align:center;
margin-bottom:25px;
font-size:22px;
}

input{
width:100%;
padding:12px;
margin-bottom:15px;
border:1px solid #ccc; 
border-radius:4px;
box-sizing:border-box; 
font-size:14px;
outline:none;
}

input:focus{
border-color:#007bff; 
}

button{
width:100%;
padding:12px;
background:blue;
color:white;
border:none;
border-radius:10px; 
font-size:16px;
font-weight:bold;
cursor:pointer;
}

button:hover{
background:#0000cc; 
}

</style>

</head>

<body>

<div class="login-box">

<h2>Super Admin Login</h2>

<form action="${pageContext.request.contextPath}/SuperAdminLoginServlet" method="post">

<input type="email" name="email" placeholder="Enter Email" required>

<input type="password" name="password" placeholder="Enter Password" required>

<button type="submit">Login</button>

</form>

</div>

</body>
</html>