<%@ page import="com.campusconnect.bean.SuperAdmin" %>

<%
SuperAdmin admin = (SuperAdmin)session.getAttribute("admin");

if(admin==null)
{
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>System Reports</title>

<style>

*{
margin:0;
padding:10px;
font-family:Arial;
}

body{
    background:#f2f2f2;
}

h2{
    text-align:center;
    color:#0B3D91;
    margin-bottom:25px;
    font-size:34px;
}


.main{
    margin-left:240px;
    padding:25px;
}

table{
    width:70%;
    margin:auto;
    border-collapse:collapse;
    background:white;
    box-shadow:0px 0px 8px gray;
}

th{
    background:#0B3D91;
    color:white;
    padding:12px;
}

td{
    padding:12px;
    border:1px solid #ddd;
}

tr:nth-child(even){
    background:#f8f8f8;
}

.count{
    font-weight:bold;
    color:blue;
    text-align:center;
}

.back-btn{
    float:right;
    display:inline-block;
    padding:10px 20px;
    background:#0B3D91;
    color:white;
    text-decoration:none;
    border-radius:6px;
    font-weight:bold;
    margin-bottom:20px;
}

.back-btn:hover{
    background:#072c69;
}

</style>

</head>

<body>


<a href="<%=request.getContextPath()%>/DashboardServlet"
class="back-btn">
 Back to Dashboard
</a>





<div class="main">

<h2>
 System Reports
</h2>



<br><br>

<table>

<tr>
<th>Report</th>
<th>Count</th>
</tr>

<tr>
<td>Total Colleges</td>
<td class="count">${collegeCount}</td>
</tr>

<tr>
<td>Approved Colleges</td>
<td class="count">${approvedCollege}</td>
</tr>

<tr>
<td>Rejected Colleges</td>
<td class="count">${rejectedCollege}</td>
</tr>

<tr>
<td>Total Companies</td>
<td class="count">${companyCount}</td>
</tr>

<tr>
<td>Approved Companies</td>
<td class="count">${approvedCompany}</td>
</tr>

<tr>
<td>Rejected Companies</td>
<td class="count">${rejectedCompany}</td>
</tr>

<tr>
<td>Total Students</td>
<td class="count">${studentCount}</td>
</tr>

<tr>
<td>Active Students</td>
<td class="count">${activeStudent}</td>
</tr>

<tr>
<td>Inactive Students</td>
<td class="count">${inactiveStudent}</td>
</tr>

<tr>
<td>Total Recruitment Drives</td>
<td class="count">${driveCount}</td>
</tr>

<tr>
<td>Active Drives</td>
<td class="count">${activeDrive}</td>
</tr>

<tr>
<td>Closed Drives</td>
<td class="count">${closedDrive}</td>
</tr>

</table>

</div>

</body>
</html>