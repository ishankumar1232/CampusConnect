
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.campusconnect.bean.Student"%>

<%
Student s=(Student)request.getAttribute("student");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Student Details</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,Helvetica,sans-serif;
}

body{

background:#eef3fb;

}

.container{

width:80%;
margin:40px auto;

}

.header{

display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:25px;

}

.header h2{

color:#0B3D91;
font-size:34px;

}

.back{

background:#0B3D91;
color:white;
padding:10px 18px;
text-decoration:none;
border-radius:6px;
font-weight:bold;

}

.back:hover{

background:#072c69;

}

.card{

background:white;
border-radius:12px;
box-shadow:0 5px 12px rgba(0,0,0,.15);
overflow:hidden;

}

.card-header{

background:linear-gradient(90deg,#0B3D91,#1976d2);

padding:25px;

text-align:center;

color:white;

}

.profile{

width:90px;

height:90px;

border-radius:50%;

background:white;

color:#0B3D91;

font-size:42px;

font-weight:bold;

line-height:90px;

margin:auto;

margin-bottom:15px;

}

.card-header h3{

font-size:28px;

margin-bottom:8px;

}

.card-header p{

font-size:16px;

}

table{

width:100%;

border-collapse:collapse;

}

th{

width:35%;

background:#f4f7fc;

text-align:left;

padding:16px;

color:#0B3D91;

border-bottom:1px solid #ddd;

}

td{

padding:16px;

border-bottom:1px solid #ddd;

}

.status-active{

background:#28a745;

color:white;

padding:6px 14px;

border-radius:20px;

font-weight:bold;

}

.status-inactive{

background:#dc3545;

color:white;

padding:6px 14px;

border-radius:20px;

font-weight:bold;

}

.footer{

margin-top:25px;

text-align:center;

color:#666;

font-size:14px;

}

</style>

</head>

<body>

<div class="container">

<div class="header">

<h2>Student Details</h2>

<a href="<%=request.getContextPath()%>/StudentManagementServlet"
class="back">

← Back

</a>

</div>

<div class="card">

<div class="card-header">

<div class="profile">

<%=s.getName().substring(0,1).toUpperCase()%>

</div>

<h3><%=s.getName()%></h3>

<p><%=s.getEmail()%></p>

</div>

<table>

<tr>

<th>Student ID</th>

<td><%=s.getStudentId()%></td>

</tr>

<tr>

<th>College</th>

<td><%=s.getCollegeName()%></td>

</tr>

<tr>

<th>Course</th>

<td><%=s.getCourseName()%></td>

</tr>

<tr>

<th>Email</th>

<td><%=s.getEmail()%></td>

</tr>

<tr>

<th>Phone</th>

<td><%=s.getPhone()%></td>

</tr>

<tr>

<th>Gender</th>

<td><%=s.getGender()%></td>

</tr>

<tr>

<th>Status</th>

<td>

<%
if("ACTIVE".equalsIgnoreCase(s.getStatus())){
%>

<span class="status-active">ACTIVE</span>

<%
}else{
%>

<span class="status-inactive">INACTIVE</span>

<%
}
%>

</td>

</tr>

</table>

</div>

</div>

</body>

</html>
