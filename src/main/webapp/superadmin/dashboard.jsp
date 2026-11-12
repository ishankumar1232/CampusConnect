<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.SuperAdmin"%>
<%@ page import="com.campusconnect.bean.DashboardBean"%>
<%@ page import="com.campusconnect.bean.SystemActivityLog"%>
<%
SuperAdmin admin =
(SuperAdmin)session.getAttribute("admin");
if(admin==null)
{
    response.sendRedirect("login.jsp");
    return;
}
DashboardBean dashboard =
(DashboardBean)request.getAttribute("dashboard");
ArrayList<SystemActivityLog> activityList =
(ArrayList<SystemActivityLog>)
request.getAttribute("activityList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Super Admin Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,Helvetica,sans-serif;
}
body{
background:#eef3f9;
}
/* ================= HEADER ================= */
.header{
width:100%;
background:linear-gradient(90deg,#0B3D91,#2563eb);
color:white;
padding:18px;
font-size:28px;
font-weight:bold;
text-align:center;
box-shadow:0 3px 12px rgba(0,0,0,.25);
letter-spacing:1px;
}
/* ================= SIDEBAR ================= */
.sidebar{
position:fixed;
left:0;
top:0;
width:240px;
height:100%;
background:#1f2937;
overflow:auto;
padding-top:75px;
}
.sidebar a{
display:block;
padding:16px;
color:white;
text-decoration:none;
font-size:16px;
border-bottom:1px solid #374151;
transition:.3s;
}
.sidebar a:hover{
background:#2563eb;
padding-left:28px;
}
/* ================= MAIN ================= */
.main{
margin-left:250px;
padding:30px;
}
/* ================= TITLE ================= */
.page-title{
font-size:28px;
font-weight:bold;
color:#0B3D91;
}
.page-subtitle{
margin-top:8px;
color:#666;
font-size:16px;
margin-bottom:25px;
}
/* ================= DASHBOARD CARDS ================= */
.card{
width:210px;
height:125px;
display:inline-block;
background:white;
margin:12px;
border-radius:15px;
box-shadow:0 5px 15px rgba(0,0,0,.15);
transition:.3s;
text-align:center;
}
.card:hover{
transform:translateY(-6px);
}
.card h2{
margin-top:18px;
font-size:20px;
color:#555;
}
.card h1{
margin-top:15px;
font-size:38px;
color:#2563eb;
}
/* ================= BOX ================= */
.box{
background:white;
padding:20px;
margin:25px 12px;
border-radius:12px;
box-shadow:0 4px 12px rgba(0,0,0,.15);
}
/* ================= NOTIFICATION ================= */
.notification{
background:#f8fafc;
border-left:5px solid #2563eb;
padding:14px;
margin:12px 0;
border-radius:8px;
font-size:15px;
}
/* ================= BUTTON ================= */
.action-btn{
display:inline-block;
padding:12px 22px;
background:#0B3D91;
color:white;
text-decoration:none;
border-radius:8px;
margin:8px;
transition:.3s;
font-weight:bold;
}
.action-btn:hover{
background:#2563eb;
transform:scale(1.05);
}
/* ================= TABLE ================= */
table{
width:100%;
border-collapse:collapse;
margin-top:15px;
}
table th{
background:#0B3D91;
color:white;
padding:12px;
}
table td{
padding:12px;
border-bottom:1px solid #ddd;
}
table tr:nth-child(even){
background:#f9f9f9;
}
table tr:hover{
background:#eef4ff;
}
/* ================= CHART ================= */
.chart-container{
    display:flex;
    flex-wrap:wrap;
    justify-content:center;
    align-items:flex-start;
    gap:20px;
    margin:30px ;
}

.chart-box{

    width:320px

    min-width:320px;

    background:#fff;

    border-radius:18px;

    padding:15px;

    box-shadow:0 8px 25px rgba(0,0,0,.12);

}
.chart-box h3{
text-align:center;
margin-bottom:15px;
color:#0B3D91;
}
.chart-wrapper{

    position:relative;

    width:100%;

    height:320px;

}

.chart-wrapper canvas{

    width:100%!important;

    height:320px!important;

}
.footer{
margin-top:40px;
padding:20px;
text-align:center;
color:#666;
}
</style>
</head>
<body>
<div class="header">
CampusConnect Recruitment Management System
</div>
<div class="sidebar">
<a href="<%=request.getContextPath()%>/DashboardServlet">
🏠 Dashboard
</a>
<a href="<%=request.getContextPath()%>/CollegeManagementServlet">
🏫 College Management
</a>
<a href="<%=request.getContextPath()%>/CompanyManagementServlet">
🏢 Company Management
</a>
<a href="<%=request.getContextPath()%>/UserManagementServlet">
👤 User Management
</a>
<a href="<%=request.getContextPath()%>/StudentManagementServlet">
🎓 Student Management
</a>
<a href="<%=request.getContextPath()%>/MonitorRecruitmentServlet">
💼 Recruitment Monitoring
</a>
<a href="<%=request.getContextPath()%>/SystemReportsServlet">
📊 Reports
</a>
<a href="<%=request.getContextPath()%>/SystemSettingsServlet">
⚙ System Settings
</a>
<a href="<%=request.getContextPath()%>/LogoutServlet">
🚪 Logout
</a>
</div>
<div class="main">
<div class="page-title">
Welcome,
<%=admin.getName()%>
</div>
<div class="page-subtitle">
Monitor, Control and Analyze the complete CampusConnect System
</div>
<!-- ================= DASHBOARD CARDS ================= -->
<div class="card">
<h2>Total Colleges</h2>
<h1><%=dashboard.getTotalColleges()%></h1>
</div>
<div class="card">
<h2>Total Companies</h2>
<h1><%=dashboard.getTotalCompanies()%></h1>
</div>
<div class="card">
<h2>Total Students</h2>
<h1><%=dashboard.getTotalStudents()%></h1>
</div>
<div class="card">
<h2>Placed Students</h2>
<h1><%=dashboard.getPlacedStudents()%></h1>
</div>
<div class="card">
<h2>Active Drives</h2>
<h1><%=dashboard.getActiveDrives()%></h1>
</div>
<div class="card">
<h2>Pending Approvals</h2>
<h1><%=dashboard.getPendingApprovals()%></h1>
</div>
<div class="card">
<h2>Reports</h2>
<h1>
<a href="<%=request.getContextPath()%>/SystemReportsServlet"
style="text-decoration:none;color:#2563eb;">
View
</a>
</h1>
</div>
<br><br>
<!-- ================= SYSTEM NOTIFICATIONS ================= -->
<div class="box">
<h2 style="color:#0B3D91; margin-bottom:20px;">
🔔 System Notifications
</h2>
<div class="notification">
🏫 Pending College Approvals :
<b>
<%=dashboard.getPendingColleges()%>
</b>
</div>
<div class="notification">
🏢 Pending Company Approvals :
<b>
<%=dashboard.getPendingCompanies()%>
</b>
</div>
<div class="notification">
👨‍🎓 Total Registered Students :
<b>
<%=dashboard.getTotalStudents()%>
</b>
</div>
<div class="notification">
💼 Active Recruitment Drives :
<b>
<%=dashboard.getActiveDrives()%>
</b>
</div>
<div class="notification">
📋 Total Pending Approvals :
<b>
<%=dashboard.getPendingApprovals()%>
</b>
</div>
</div>
<!-- ================= QUICK ACTIONS ================= -->
<div class="box">
<h2 style="color:#0B3D91; margin-bottom:20px;">
⚡ Quick Actions
</h2>
<a class="action-btn"
href="<%=request.getContextPath()%>/CollegeManagementServlet">
🏫 Colleges
</a>
<a class="action-btn"
href="<%=request.getContextPath()%>/CompanyManagementServlet">
🏢 Companies
</a>
<a class="action-btn"
href="<%=request.getContextPath()%>/StudentManagementServlet">
👨‍🎓 Students
</a>
<a class="action-btn"
href="<%=request.getContextPath()%>/MonitorRecruitmentServlet">
💼 Recruitment
</a>
<a class="action-btn"
href="<%=request.getContextPath()%>/SystemReportsServlet">
📊 Reports
</a>
<a class="action-btn"
href="<%=request.getContextPath()%>/SystemSettingsServlet">
⚙ Settings
</a>
<!-- ================= RECENT ACTIVITY ================= -->
<div class="box">
<h2 style="color:#0B3D91;margin-bottom:20px;">
📋 Recent Activities
</h2>
<table>
<tr>
<th width="20%">Date</th>
<th>Activity</th>
</tr>
<%
if(activityList!=null && activityList.size()>0){
for(SystemActivityLog log:activityList){
%>
<tr>
<td>
<%=log.getActivityDate()%>
</td>
<td>
<%=log.getActivity()%>
</td>
</tr>
<%
}
}else{
%>
<tr>
<td colspan="2"
style="text-align:center;color:red;">
No Activity Found
</td>
</tr>
<%
}
%>
</table>
</div>
<!-- ================= DASHBOARD CHARTS ================= -->

<!-- ================= ALL CHARTS ================= -->

<div class="chart-container">

    <!-- COLLEGE STATUS -->
    <div class="chart-box">
        <h3>🏫 College Status</h3>
        <div class="chart-wrapper">
            <canvas id="collegeChart"></canvas>
        </div>
    </div>

    <!-- COMPANY STATUS -->
    <div class="chart-box">
        <h3>🏢 Company Status</h3>
        <div class="chart-wrapper">
            <canvas id="companyChart"></canvas>
        </div>
    </div>

    <!-- RECRUITMENT STATUS -->
    <div class="chart-box">
        <h3>💼 Recruitment Status</h3>
        <div class="chart-wrapper">
            <canvas id="recruitmentChart"></canvas>
        </div>
    </div>

    <!-- APPLICATION VS SELECTION VS PLACEMENT -->
    <div class="chart-box">
        <h3>📄 Applications vs Selections vs Placements</h3>
        <div class="chart-wrapper">
            <canvas id="applicationChart"></canvas>
        </div>
    </div>

    <!-- COLLEGE WISE PLACEMENT -->
    <div class="chart-box">
        <h3>🎓 College Wise Placement</h3>
        <div class="chart-wrapper">
            <canvas id="collegePlacementChart"></canvas>
        </div>
    </div>

    <!-- MONTHLY RECRUITMENT TREND -->
    <div class="chart-box">
        <h3>📈 Monthly Recruitment Trend</h3>
        <div class="chart-wrapper">
            <canvas id="monthlyRecruitmentChart"></canvas>
        </div>
    </div>

</div>

<!-- ================= SYSTEM OVERVIEW ================= -->

<div class="system-overview-container">

    <div class="box">

        <h2 style="color:#0B3D91; margin-bottom:20px;">
            📊 System Overview
        </h2>

        <div class="notification">
            ✅ Approved Colleges :
            <b><%=dashboard.getApprovedColleges()%></b>
        </div>

        <div class="notification">
            🏢 Approved Companies :
            <b><%=dashboard.getApprovedCompanies()%></b>
        </div>

        <div class="notification">
            🎓 Total Students :
            <b><%=dashboard.getTotalStudents()%></b>
        </div>

        <div class="notification">
            💼 Active Recruitment Drives :
            <b><%=dashboard.getActiveDrives()%></b>
        </div>

        <div class="notification">
            🎯 Placed Students :
            <b><%=dashboard.getPlacedStudents()%></b>
        </div>

        <div class="notification">
            📋 Pending Approvals :
            <b><%=dashboard.getPendingApprovals()%></b>
        </div>

    </div>

</div>
<!-- ================= CHART JAVASCRIPT ================= -->
<script>
// ======================================================
// COLLEGE STATUS PIE CHART
// ======================================================
const collegeCtx = document.getElementById("collegeChart");
if(collegeCtx){
new Chart(collegeCtx,{
type:"pie",
data:{
labels:["Approved","Pending","Rejected"],
datasets:[{
data:[
<%=dashboard.getApprovedColleges()%>,
<%=dashboard.getPendingColleges()%>,
<%=dashboard.getRejectedColleges()%>
],
backgroundColor:[
"#28a745",
"#ffc107",
"#dc3545"
],
borderWidth:2
}]
},
options:{
responsive:true,
maintainAspectRatio:false,
plugins:{
legend:{
position:"bottom"
}
}
}
});
}

// ======================================================
// COMPANY STATUS PIE CHART
// ======================================================
const companyCtx=document.getElementById("companyChart");
if(companyCtx){
new Chart(companyCtx,{
type:"pie",
data:{
labels:["Approved","Pending","Rejected"],
datasets:[{
data:[
<%=dashboard.getApprovedCompanies()%>,
<%=dashboard.getPendingCompanies()%>,
<%=dashboard.getRejectedCompanies()%>
],
backgroundColor:[
"#28a745",
"#ffc107",
"#dc3545"
],
borderWidth:2
}]
},
options:{
responsive:true,
maintainAspectRatio:false,
plugins:{
legend:{
position:"bottom"
}
}
}
});
}

// ======================================================
// RECRUITMENT STATUS BAR CHART
// ======================================================
const recruitmentCtx=document.getElementById("recruitmentChart");
if(recruitmentCtx){
new Chart(recruitmentCtx,{
type:"bar",
data:{
labels:["Open","Active","Completed"],
datasets:[{
label:"Recruitment Drives",
data:[
<%=dashboard.getOpenDrives()%>,
<%=dashboard.getActiveDriveCount()%>,
<%=dashboard.getCompletedDrives()%>
],
backgroundColor:[
"#17a2b8",
"#28a745",
"#ffc107"
],
borderColor:[
"#138496",
"#1e7e34",
"#d39e00"
],
borderWidth:2,
borderRadius:8
}]
},
options:{
responsive:true,
maintainAspectRatio:false,
plugins:{
legend:{
display:false
}
},
scales:{
x:{
ticks:{
font:{
size:13,
weight:"bold"
}
}
},
y:{
beginAtZero:true,
ticks:{
stepSize:1
}
}
}
}
});
}

// ======================================================
// APPLICATION VS SELECTION VS PLACEMENT
// ======================================================
const applicationCtx=document.getElementById("applicationChart");
if(applicationCtx){
new Chart(applicationCtx,{
type:"bar",
data:{
labels:[
"Applications",
"Selections",
"Placements"
],
datasets:[{
label:"Students",
data:[
<%=dashboard.getTotalApplications()%>,
<%=dashboard.getTotalSelections()%>,
<%=dashboard.getTotalPlacements()%>
],
backgroundColor:[
"#007bff",
"#ffc107",
"#28a745"
],
borderColor:[
"#0056b3",
"#d39e00",
"#1e7e34"
],
borderWidth:2,
borderRadius:8
}]
},
options:{
responsive:true,
maintainAspectRatio:false,
plugins:{
legend:{
display:false
}
},
scales:{
x:{
ticks:{
color:"#333",
font:{
size:13,
weight:"bold"
},
maxRotation:0,
minRotation:0
}
},
y:{
beginAtZero:true,
ticks:{
stepSize:1
}
}
}
}
});
}

//================================================
//COLLEGE WISE PLACEMENT
//================================================
const collegePlacementCtx =
document.getElementById("collegePlacementChart");
if(collegePlacementCtx){
new Chart(collegePlacementCtx,{
type:"bar",
data:{
labels:[
<%
String[] collegeNames = dashboard.getCollegeNames();
if(collegeNames!=null){
for(int i=0;i<collegeNames.length;i++){
%>
"<%=collegeNames[i]%>"
<%= (i<collegeNames.length-1)?",":"" %>
<%
}
}
%>
],
datasets:[{
label:"Placed Students",
data:[
<%
int[] counts = dashboard.getCollegePlacementCounts();
if(counts!=null){
for(int i=0;i<counts.length;i++){
%>
<%=counts[i]%>
<%= (i<counts.length-1)?",":"" %>
<%
}
}
%>
],
backgroundColor:"#007bff",
borderRadius:8
}]
},
options:{
responsive:true,
maintainAspectRatio:false,
plugins:{
legend:{
display:false
}
},
scales:{
y:{
beginAtZero:true
}
}
}
});
}
//================================================
//MONTHLY RECRUITMENT TREND
//================================================
const monthlyCtx =
document.getElementById("monthlyRecruitmentChart");
if(monthlyCtx){
new Chart(monthlyCtx,{
type:"line",
data:{
labels:[
<%
String[] months = dashboard.getMonths();
if(months!=null){
for(int i=0;i<months.length;i++){
%>
"<%=months[i]%>"<%= (i<months.length-1)?",":"" %>
<%
}
}
%>
],
datasets:[{
label:"Recruitment Drives",
data:[
<%
int[] monthCounts =
dashboard.getMonthlyRecruitmentCounts();
if(monthCounts!=null){
for(int i=0;i<monthCounts.length;i++){
%>
<%=monthCounts[i]%><%= (i<monthCounts.length-1)?",":"" %>
<%
}
}
%>
],
borderColor:"#007bff",
backgroundColor:"rgba(0,123,255,0.2)",
fill:true,
tension:0.4
}]
},
options:{
responsive:true,
maintainAspectRatio:false,
plugins:{
legend:{
display:true
}
},
scales:{
y:{
beginAtZero:true,
ticks:{
stepSize:1
}
}
}
}
});
}
</script>
<!-- ================= FOOTER ================= -->
<div class="footer">
<hr style="margin-bottom:15px;">
<b>CampusConnect Recruitment Management System</b>
<br><br>
Super Admin Dashboard
<br>
Developed using
<b>Java • JSP • Servlet • Oracle Database</b>
<br><br>
© 2026 CampusConnect. All Rights Reserved.
</div>
</div>
</body>
</html>