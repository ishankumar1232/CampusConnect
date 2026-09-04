 <%@page import="com.campusconnect.bean.SuperAdmin"%>

<%
SuperAdmin admin=(SuperAdmin)session.getAttribute("admin");

if(admin==null)
{
	response.sendRedirect("login.jsp");
	return;
}
%>

<!DOCTYPE html>

<html>

<head>

<title>Super Admin Dashboard</title>


<style>

*{
margin:0;
padding:0;
font-family:Arial;
}

body{
background:#f2f2f2;
}

.header{

background:#0B3D91;
color:white;
padding:18px;
font-size:24px;
text-align:center;

}

.sidebar{

width:230px;
height:100vh;
background:#1f2937;
float:left;

}

.sidebar a{

display:block;
padding:18px;
color:white;
text-decoration:none;
border-bottom:1px solid gray;

}

.sidebar a:hover{

background:#2563eb;

}

.main{

margin-left:240px;
padding:25px;

}

.card{

width:220px;
height:120px;
background:white;
display:inline-block;
margin:15px;
border-radius:10px;
box-shadow:0px 0px 8px gray;
text-align:center;

}

.card h2{

margin-top:20px;

}

.card h1{

margin-top:15px;
color:blue;

}

</style>

</head>

<body>

<div class="header">Campus Recruitment Management System</div> 				<!-- HEADING -->

<div class="sidebar">


<a href="dashboard.jsp">Dashboard</a> 					<!-- DASHBOARD -->



<a href="<%=request.getContextPath()%>/CollegeManagementServlet">College Management</a>  	<!-- COLLEGE MENEGEMENT -->

	

<a href="${pageContext.request.contextPath}/CompanyManagementServlet">Company Management</a>   <!-- COLLEGE MANAGEMENT -->



<a href="${pageContext.request.contextPath}/UserManagementServlet">User Management</a>  	<!-- USER MANAGEMENT -->



<a href="${pageContext.request.contextPath}/StudentManagementServlet">Student Management</a>    <!-- STUDENT MANAGEMENT -->



<a href="${pageContext.request.contextPath}/MonitorRecruitmentServlet">Monitor Recruitment</a>   <!-- MONITOR RECRUITMENT  -->



<a href="${pageContext.request.contextPath}/SystemReportsServlet">Reports</a>   	<!-- REPORTS -->



<a href="../LogoutServlet">Logout</a>		<!-- LOGOUT -->

</div>

<div class="main">

<h2>Welcome Super Admin</h2>


<br>

	<!-- TOTAL COLLEGES -->
<div class="card">

<h2>Total Colleges</h2>

<h1>10+</h1>

</div>


	<!--TOTAL COMPANIES-->
<div class="card">

<h2>Total Companies</h2>

<h1>20+</h1>

</div>


	<!--TOTAL STUDENTS-->
<div class="card">

<h2>Total Students</h2>

<h1>500+</h1>

</div>


	<!--PLACED STUDENTS-->
<div class="card">

<h2>Placed Students</h2>

<h1>180+</h1>

</div>

</div>

</body>

</html>