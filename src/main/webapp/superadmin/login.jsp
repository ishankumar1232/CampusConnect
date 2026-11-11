<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Super Admin Login</title>

<style>

.top-buttons{
    position:absolute;
    top:20px;
    right:20px;
}

.home-btn{
    display:inline-block;
    padding:10px 18px;
    background:#ffffff;
    color:#0B3D91;
    border:2px solid #0B3D91;
    border-radius:8px;
    text-decoration:none;
    font-size:14px;
    font-weight:bold;
    transition:.3s;
}

.home-btn:hover{
    background:#0B3D91;
    color:white;
}

body{
    margin:0;
    padding:0;
    font-family:Arial,Helvetica,sans-serif;
    background:linear-gradient(135deg,#6a11cb,#2575fc);
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
}

.login-box{
    width:900px;
    height:500px;
    background:#171c3b;
    border-radius:18px;
    display:flex;
    overflow:hidden;
    box-shadow:0 20px 45px rgba(0,0,0,.35);
}

.left{
    width:38%;
    background:#20254d;
    padding:45px;
    box-sizing:border-box;
}

.right{
    width:62%;
    background:linear-gradient(135deg,#1d2150,#2b2f73);
    display:flex;
    justify-content:center;
    align-items:center;
    flex-direction:column;
    color:white;
    text-align:center;
}

.right h1{
    font-size:42px;
    margin-bottom:10px;
}

.right p{
    font-size:18px;
}

h2{
    color:white;
    text-align:center;
    margin-bottom:30px;
}

input{
    width:100%;
    padding:14px;
    margin-bottom:18px;
    border:none;
    border-radius:8px;
    background:#2d3368;
    color:white;
    font-size:15px;
    box-sizing:border-box;
}

input::placeholder{
    color:#c7c7c7;
}

input:focus{
    outline:none;
    border:2px solid #4da3ff;
}

button{
    width:100%;
    padding:14px;
    background:#ff1493;
    color:white;
    border:none;
    border-radius:8px;
    font-size:17px;
    font-weight:bold;
    cursor:pointer;
    transition:.3s;
}

button:hover{
    background:#ff0080;
}

.error{
    background:#ffdddd;
    color:#d8000c;
    border:1px solid #d8000c;
    padding:10px;
    margin-bottom:18px;
    border-radius:6px;
    text-align:center;
    font-size:14px;
}

</style>

</head>

<body>

<div class="top-buttons">

 	<a href="${pageContext.request.contextPath}/index.jsp"class="home-btn"> 🏠 Back to Home</a>
 
</div>

<div class="login-box">

    <div class="left">

        <h2>Super Admin Login</h2>

        <% if(request.getParameter("error")!=null){ %>

        <div class="error">❌ Invalid Email or Password </div>

        <% } %>

        <form action="${pageContext.request.contextPath}/SuperAdminLoginServlet" method="post">

            <input
                type="email"
                name="email"
                placeholder="Enter Email"
                value="<%=request.getParameter("email")==null ? "" : request.getParameter("email")%>"
                required>

            <input
                type="password"
                name="password"
                placeholder="Enter Password"
                required>

            <button type="submit">
                LOGIN
            </button>

        </form>

    </div>

    <div class="right">

        <h1>Welcome</h1>

        <p>Campus Recruitment Management System</p>

    </div>

</div>

</body>
</html>