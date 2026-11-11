<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.RecruitmentDrive"%>
<%@ page import="com.campusconnect.bean.SuperAdmin"%>

<%
SuperAdmin admin=(SuperAdmin)session.getAttribute("admin");

if(admin==null){
    response.sendRedirect("login.jsp");
    return;
}

ArrayList<RecruitmentDrive> list=
(ArrayList<RecruitmentDrive>)request.getAttribute("driveList");

int totalApplications=0;
int totalSelected=0;
int totalPlaced=0;

if(list!=null){
    for(RecruitmentDrive d:list){
        totalApplications+=d.getApplicationCount();
        totalSelected+=d.getSelectedCount();
        totalPlaced+=d.getPlacedCount();
    }
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Monitor Recruitment</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,Helvetica,sans-serif;
}

body{
background:#eef2f7;
}

.main{
width:98%;
margin:auto;
padding:20px;
}

.header{
background:#0B3D91;
color:white;
padding:18px;
text-align:center;
font-size:28px;
font-weight:bold;
margin-bottom:20px;
border-radius:8px;
}

.back-btn{
float:right;
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

h2{
text-align:center;
color:#0B3D91;
font-size:34px;
margin-bottom:25px;
}

.card-container{
display:flex;
justify-content:space-between;
gap:20px;
flex-wrap:wrap;
margin-bottom:30px;
}

.card{
flex:1;
min-width:220px;
background:white;
padding:20px;
border-radius:10px;
box-shadow:0 2px 10px rgba(0,0,0,.15);
text-align:center;
transition:.3s;
}

.card:hover{
transform:translateY(-5px);
}

.card h3{
color:#666;
margin-bottom:10px;
}

.card h1{
color:#0B3D91;
font-size:35px;
}

.search-box{
text-align:right;
margin-bottom:20px;
}

.search-box input{
width:300px;
padding:10px;
border-radius:6px;
border:1px solid #ccc;
outline:none;
}

table{
width:100%;
border-collapse:collapse;
background:white;
box-shadow:0 2px 10px rgba(0,0,0,.15);
}

th{
background:#0B3D91;
color:white;
padding:12px;
}

td{
padding:10px;
border:1px solid #ddd;
text-align:center;
}

tr:nth-child(even){
background:#f8f8f8;
}

tr:hover{
background:#eef5ff;
}

.badge-active{
background:#28a745;
color:white;
padding:5px 12px;
border-radius:20px;
}

.badge-open{
background:#17a2b8;
color:white;
padding:5px 12px;
border-radius:20px;
}

.badge-completed{
background:#ffc107;
color:black;
padding:5px 12px;
border-radius:20px;
}

.badge-closed{
background:#dc3545;
color:white;
padding:5px 12px;
border-radius:20px;
}

.footer{
margin-top:30px;
background:white;
padding:20px;
text-align:center;
border-radius:8px;
box-shadow:0 2px 10px rgba(0,0,0,.15);
color:#555;
}

</style>

</head>

<body>

<div class="main">

<div class="header">

Campus Recruitment Management System

</div>

<a href="<%=request.getContextPath()%>/DashboardServlet"
class="back-btn">

 Back to Dashboard

</a>

<br><br>

<h2>

Monitor Recruitment Drives

</h2>

<!-- ================= DASHBOARD CARDS ================= -->

<div class="card-container">

    <div class="card">
        <h3>Total Drives</h3>
     	<h1><%=request.getAttribute("totalDrives")%></h1>
    </div>

    <div class="card">
        <h3>Total Applications</h3>
      	<h1><%=request.getAttribute("totalApplications")%></h1>
    </div>

    <div class="card">
        <h3>Total Selected</h3>
        <h1><%=request.getAttribute("totalSelected")%></h1>
    </div>

    <div class="card">
        <h3>Total Placed</h3>
        <h1><%=request.getAttribute("totalPlaced")%></h1>
    </div>

</div>

<!-- ================= SEARCH BOX ================= -->

<div class="search-box">

<input
type="text"
id="searchBox"
placeholder="Search Company / Job Title / Drive Type..."
onkeyup="searchTable()">

</div>

<!-- ================= TABLE ================= -->

<table id="driveTable">

<tr>

<th>Drive ID</th>

<th>Company</th>

<th>Drive Type</th>

<th>Job Title</th>

<th>Vacancy</th>

<th>Applications</th>

<th>Selected</th>

<th>Placed</th>

<th>Salary</th>

<th>Deadline</th>

<th>Status</th>

</tr>

<%

if(list!=null && !list.isEmpty())
{

for(RecruitmentDrive d:list)
{

%>

<tr>

<td><%=d.getDriveId()%></td>

<td><%=d.getCompanyName()%></td>

<td><%=d.getDriveType()%></td>

<td><%=d.getJobTitle()%></td>

<td><%=d.getVacancy()%></td>

<td style="font-weight:bold;color:#007bff;">
<%=d.getApplications()%>
</td>

<td style="font-weight:bold;color:#ff9800;">
<%=d.getSelectedStudents()%>
</td>

<td style="font-weight:bold;color:green;">
<%=d.getPlacedStudents()%>
</td>

<td>

Rs. <%=d.getSalary()%>

</td>

<td>

<%=d.getDeadline()%>

</td>

<td>

<%

String status=d.getStatus();

if(status.equalsIgnoreCase("ACTIVE"))
{

%>

<span class="badge-active">

ACTIVE

</span>

<%

}

else if(status.equalsIgnoreCase("OPEN"))
{

%>

<span class="badge-open">

OPEN

</span>

<%

}

else if(status.equalsIgnoreCase("COMPLETED"))
{

%>

<span class="badge-completed">

COMPLETED

</span>

<%

}

else

{

%>

<span class="badge-closed">

<%=status%>

</span>

<%

}

%>

</td>

</tr>

<%

}

}

else

{

%>

<tr>

<td colspan="11">

No Recruitment Drives Found

</td>

</tr>

<%

}

%>

</table>

<br><br>

</div>

<!-- ================= SEARCH FUNCTION ================= -->

<script>

function searchTable(){

var input=document.getElementById("searchBox");

var filter=input.value.toUpperCase();

var table=document.getElementById("driveTable");

var tr=table.getElementsByTagName("tr");

for(var i=1;i<tr.length;i++){

var tdCompany=tr[i].getElementsByTagName("td")[1];

var tdDrive=tr[i].getElementsByTagName("td")[2];

var tdJob=tr[i].getElementsByTagName("td")[3];

if(tdCompany||tdDrive||tdJob){

var txt1=tdCompany.textContent||tdCompany.innerText;

var txt2=tdDrive.textContent||tdDrive.innerText;

var txt3=tdJob.textContent||tdJob.innerText;

if(txt1.toUpperCase().indexOf(filter)>-1 ||

txt2.toUpperCase().indexOf(filter)>-1 ||

txt3.toUpperCase().indexOf(filter)>-1){

tr[i].style.display="";

}

else{

tr[i].style.display="none";

}

}

}

}

</script>

</body>

</html>