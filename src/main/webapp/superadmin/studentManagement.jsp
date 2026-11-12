<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.Student"%>

<%
ArrayList<Student> list=(ArrayList<Student>)request.getAttribute("studentList");

int totalStudents=0;
int activeStudents=0;
int inactiveStudents=0;

if(list!=null){

    totalStudents=list.size();

    for(Student s:list){

        if("ACTIVE".equalsIgnoreCase(s.getStatus())){

            activeStudents++;

        }else{

            inactiveStudents++;

        }

    }

}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Student Management</title>

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

width:96%;
margin:25px auto;

}

.header{

display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:20px;

}

.header h2{

color:#0B3D91;
font-size:34px;

}

.back-btn{

background:#0B3D91;
color:white;
text-decoration:none;
padding:10px 18px;
border-radius:6px;
font-weight:bold;

}

.back-btn:hover{

background:#072c69;

}

.cards{

display:flex;
gap:20px;
margin-bottom:25px;
flex-wrap:wrap;

}

.card{

flex:1;
min-width:220px;
background:white;
padding:20px;
border-radius:10px;
box-shadow:0 2px 8px rgba(0,0,0,.15);
text-align:center;

}

.card h3{

color:#555;
margin-bottom:10px;

}

.card p{

font-size:30px;
font-weight:bold;
color:#0B3D91;

}

.search-box{

margin-bottom:20px;

}

.search-box input{

width:100%;
padding:12px;
font-size:15px;
border-radius:6px;
border:1px solid #bbb;

}

table{

width:100%;
border-collapse:collapse;
background:white;
box-shadow:0 4px 10px rgba(0,0,0,.15);

}

th{

background:#0B3D91;
color:white;
padding:14px;

}

td{

padding:12px;
text-align:center;
border-bottom:1px solid #ddd;

}

tr:nth-child(even){

background:#f9fbff;

}

tr:hover{

background:#eef5ff;

}

.status-active{

background:#28a745;
color:white;
padding:5px 12px;
border-radius:20px;
font-size:13px;
font-weight:bold;

}

.status-inactive{

background:#dc3545;
color:white;
padding:5px 12px;
border-radius:20px;
font-size:13px;
font-weight:bold;

}

.btn{

padding:8px 14px;
color:white;
text-decoration:none;
border-radius:5px;
font-size:13px;
margin:2px;
display:inline-block;

}

.view{

background:#0B3D91;

}

.activate{

background:#28a745;

}

.deactivate{

background:#dc3545;

}

.btn:hover{

opacity:.85;

}

</style>

<script>

function searchStudent(){

var input=document.getElementById("search").value.toUpperCase();

var table=document.getElementById("studentTable");

var tr=table.getElementsByTagName("tr");

for(var i=1;i<tr.length;i++){

var txt=tr[i].textContent||tr[i].innerText;

if(txt.toUpperCase().indexOf(input)>-1){

tr[i].style.display="";

}else{

tr[i].style.display="none";

}

}

}

</script>

</head>

<body>

<div class="container">

<div class="header">

<h2>Student Management</h2>

<a href="<%=request.getContextPath()%>/DashboardServlet"
class="back-btn">

← Dashboard

</a>

</div>

<div class="cards">

<div class="card">

<h3>Total Students</h3>

<p><%=totalStudents%></p>

</div>

<div class="card">

<h3>Active Students</h3>

<p style="color:green;"><%=activeStudents%></p>

</div>

<div class="card">

<h3>Inactive Students</h3>

<p style="color:red;"><%=inactiveStudents%></p>

</div>

</div>

<div class="search-box">

<input type="text"
id="search"
onkeyup="searchStudent()"
placeholder="Search Student Name / College / Course / Email">

</div>

<table id="studentTable">

<tr>

<th>ID</th>

<th>College</th>

<th>Course</th>

<th>Name</th>

<th>Email</th>

<th>Phone</th>

<th>Gender</th>

<th>Status</th>

<th>Action</th>

</tr>

<%
if(list!=null && !list.isEmpty()){

for(Student s:list){
%>

<tr>

<td><%=s.getStudentId()%></td>

<td><%=s.getCollegeName()%></td>

<td><%=s.getCourseName()%></td>

<td><%=s.getName()%></td>

<td><%=s.getEmail()%></td>

<td><%=s.getPhone()%></td>

<td><%=s.getGender()%></td>

<td>

<%
if("ACTIVE".equalsIgnoreCase(s.getStatus())){
%>

<span class="status-active">

ACTIVE

</span>

<%
}else{
%>

<span class="status-inactive">

INACTIVE

</span>

<%
}
%>

</td>

<td>

<a href="<%=request.getContextPath()%>/StudentDetailsServlet?id=<%=s.getStudentId()%>"
class="btn view">

View

</a>

<%
if("ACTIVE".equalsIgnoreCase(s.getStatus())){
%>

<a href="<%=request.getContextPath()%>/DeactivateStudentServlet?id=<%=s.getStudentId()%>"
class="btn deactivate"
onclick="return confirm('Deactivate this student?');">

Deactivate

</a>

<%
}else{
%>

<a href="<%=request.getContextPath()%>/ActivateStudentServlet?id=<%=s.getStudentId()%>"
class="btn activate"
onclick="return confirm('Activate this student?');">

Activate

</a>

<%
}
%>

</td>

</tr>

<%
}

}else{
%>

<tr>

<td colspan="9"
style="padding:30px;
font-size:18px;
font-weight:bold;
color:red;">

No Student Found

</td>

</tr>

<%
}
%>

</table>

<br><br>

<div style="text-align:center;
padding:18px;
background:white;
box-shadow:0 2px 8px rgba(0,0,0,.15);
border-radius:8px;
font-size:15px;
color:#555;">

<b>CampusConnect Recruitment Management System</b>

<br><br>

Super Admin Student Management Module

<br><br>

Developed Using

<b>Java • JSP • Servlet • Oracle Database</b>

<br><br>

© 2026 CampusConnect. All Rights Reserved.

</div>

</div>

</body>

</html>