<%@ page import="com.campusconnect.bean.SuperAdmin"%>
<%@ page import="com.campusconnect.bean.SystemSetting"%>

<%
SuperAdmin admin =
(SuperAdmin)session.getAttribute("admin");

if(admin==null){

    response.sendRedirect("login.jsp");
    return;

}

SystemSetting setting =
(SystemSetting)request.getAttribute("setting");
%>

<!DOCTYPE html>

<html>

<head>

<title>System Settings</title>

<style>

/* ========================================= */
/* RESET */
/* ========================================= */

*{

    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,Helvetica,sans-serif;

}

/* ========================================= */

body{

    background:#f4f6f9;

}

/* ========================================= */

.header{

    width:100%;
    background:#0B3D91;
    color:white;
    padding:18px;
    text-align:center;
    font-size:28px;
    font-weight:bold;

}

/* ========================================= */

.sidebar{

    position:fixed;

    width:230px;

    height:100%;

    background:#1f2937;

}

/* ========================================= */

.sidebar a{

    display:block;

    color:white;

    text-decoration:none;

    padding:18px;

    border-bottom:1px solid #555;

}

/* ========================================= */

.sidebar a:hover{

    background:#2563eb;

}

/* ========================================= */

.main{

    margin-left:245px;

    padding:30px;

}

/* ========================================= */

.page-title{

    color:#0B3D91;

    font-size:30px;

    margin-bottom:10px;

}

/* ========================================= */

.page-subtitle{

    color:gray;

    margin-bottom:30px;

}

/* ========================================= */

.setting-box{

    background:white;

    padding:25px;

    border-radius:10px;

    box-shadow:0 0 10px gray;

}

/* ========================================= */

table{

    width:100%;

    border-collapse:collapse;

}

/* ========================================= */

th{

    background:#0B3D91;

    color:white;

    padding:15px;

}

/* ========================================= */

td{

    padding:18px;

    border-bottom:1px solid #ddd;

}

/* ========================================= */

tr:hover{

    background:#f7f7f7;

}

/* ========================================= */

select{

    width:120px;

    padding:8px;

    border-radius:5px;

}

/* ========================================= */

.save-btn{

    margin-top:25px;

    background:#0B3D91;

    color:white;

    border:none;

    padding:14px 35px;

    font-size:16px;

    border-radius:6px;

    cursor:pointer;

}

.save-btn:hover{

    background:#2563eb;

}

/* ========================================= */
/* SUCCESS MESSAGE */
/* ========================================= */

.success-box{

    background:#d4edda;
    color:#155724;
    padding:15px;
    border-left:5px solid green;
    margin-bottom:20px;
    border-radius:6px;
    font-weight:bold;

}

/* ========================================= */
/* BADGES */
/* ========================================= */

.badge{

    color:white;
    padding:6px 16px;
    border-radius:20px;
    font-weight:bold;

}

.green{

    background:#28a745;

}

.red{

    background:#dc3545;

}

/* ========================================= */
/* FOOTER */
/* ========================================= */

.footer{

    margin-top:40px;
    text-align:center;
    color:#777;
    padding:20px;

}

</style>

</head>

<!-- ========================================= -->
<!-- HEADER -->
<!-- ========================================= -->

<div class="header">

    Campus Recruitment Management System

</div>

<!-- ========================================= -->
<!-- SIDEBAR -->
<!-- ========================================= -->

<div class="sidebar">

    <a href="<%=request.getContextPath()%>/DashboardServlet">
        Dashboard
    </a>

    <a href="<%=request.getContextPath()%>/CollegeManagementServlet">
        College Management
    </a>

    <a href="<%=request.getContextPath()%>/CompanyManagementServlet">
        Company Management
    </a>

    <a href="<%=request.getContextPath()%>/UserManagementServlet">
        User Management
    </a>

    <a href="<%=request.getContextPath()%>/StudentManagementServlet">
        Student Management
    </a>

    <a href="<%=request.getContextPath()%>/MonitorRecruitmentServlet">
        Recruitment Monitoring
    </a>

    <a href="<%=request.getContextPath()%>/SystemReportsServlet">
        Reports
    </a>

    <a style="background:#2563eb;"
       href="<%=request.getContextPath()%>/SystemSettingsServlet">
        System Settings
    </a>

    <a href="<%=request.getContextPath()%>/LogoutServlet">
        Logout
    </a>

</div>

<!-- ========================================= -->
<!-- MAIN -->
<!-- ========================================= -->

<div class="main">

<h2 class="page-title">

    System Settings

</h2>

<p class="page-subtitle">

Control the complete CampusConnect system from one place.

</p>

<div class="setting-box">

<form
action="<%=request.getContextPath()%>/SystemSettingsServlet"
method="post">

<table>

<tr>

<th>System Module</th>

<th>Current Status</th>

</tr>

<!-- =============================== -->

<tr>

<td>Student Registration</td>

<td>

<select name="studentRegistration">

<option
value="ON"
<%=setting.getStudentRegistration().equals("ON")?"selected":""%>>
ON
</option>

<option
value="OFF"
<%=setting.getStudentRegistration().equals("OFF")?"selected":""%>>
OFF
</option>

</select>

</td>

</tr>

<!-- =============================== -->

<tr>

<td>College Registration</td>

<td>

<select name="collegeRegistration">

<option
value="ON"
<%=setting.getCollegeRegistration().equals("ON")?"selected":""%>>
ON
</option>

<option
value="OFF"
<%=setting.getCollegeRegistration().equals("OFF")?"selected":""%>>
OFF
</option>

</select>

</td>

</tr>

<!-- =============================== -->

<tr>

<td>Company Registration</td>

<td>

<select name="companyRegistration">

<option
value="ON"
<%=setting.getCompanyRegistration().equals("ON")?"selected":""%>>
ON
</option>

<option
value="OFF"
<%=setting.getCompanyRegistration().equals("OFF")?"selected":""%>>
OFF
</option>

</select>

</td>

</tr>

<!-- =============================== -->

<tr>

<td>Admission Requests</td>

<td>

<select name="admissionRequest">

<option
value="ON"
<%=setting.getAdmissionRequest().equals("ON")?"selected":""%>>
ON
</option>

<option
value="OFF"
<%=setting.getAdmissionRequest().equals("OFF")?"selected":""%>>
OFF
</option>

</select>

</td>

</tr>

<!-- =============================== -->

<tr>

<td>Recruitment Drives</td>

<td>

<select name="recruitmentDrive">

<option
value="ON"
<%=setting.getRecruitmentDrive().equals("ON")?"selected":""%>>
ON
</option>

<option
value="OFF"
<%=setting.getRecruitmentDrive().equals("OFF")?"selected":""%>>
OFF
</option>

</select>

</td>

</tr>

<!-- =============================== -->

<tr>

<td>Maintenance Mode</td>

<td>

<select name="maintenanceMode">

<option
value="ON"
<%=setting.getMaintenanceMode().equals("ON")?"selected":""%>>
ON
</option>

<option
value="OFF"
<%=setting.getMaintenanceMode().equals("OFF")?"selected":""%>>
OFF
</option>

</select>

</td>

</tr>

</table>

<br>

<input
type="submit"
value="Save Settings"
class="save-btn">

</form>

</div>

<!-- ========================================= -->
<!-- SUCCESS MESSAGE -->
<!-- ========================================= -->

<%
String msg = request.getParameter("msg");

if(msg != null){
%>

<div class="success-box">

    ✔ System Settings Updated Successfully.

</div>

<%
}
%>

<!-- ========================================= -->
<!-- SYSTEM INFORMATION -->
<!-- ========================================= -->

<br>

<div class="setting-box">

<h2 style="color:#0B3D91;margin-bottom:20px;">

Current System Status

</h2>

<table>

<tr>

<th>Module</th>

<th>Status</th>

</tr>

<tr>

<td>Student Registration</td>

<td>

<%

if(setting.getStudentRegistration().equals("ON")){

%>

<span class="badge green">

ON

</span>

<%

}
else{

%>

<span class="badge red">

OFF

</span>

<%

}

%>

</td>

</tr>

<tr>

<td>College Registration</td>

<td>

<%

if(setting.getCollegeRegistration().equals("ON")){

%>

<span class="badge green">

ON

</span>

<%

}
else{

%>

<span class="badge red">

OFF

</span>

<%

}

%>

</td>

</tr>

<tr>

<td>Company Registration</td>

<td>

<%

if(setting.getCompanyRegistration().equals("ON")){

%>

<span class="badge green">

ON

</span>

<%

}
else{

%>

<span class="badge red">

OFF

</span>

<%

}

%>

</td>

</tr>

<tr>

<td>Admission Request</td>

<td>

<%

if(setting.getAdmissionRequest().equals("ON")){

%>

<span class="badge green">

ON

</span>

<%

}
else{

%>

<span class="badge red">

OFF

</span>

<%

}

%>

</td>

</tr>

<tr>

<td>Recruitment Drives</td>

<td>

<%

if(setting.getRecruitmentDrive().equals("ON")){

%>

<span class="badge green">

ON

</span>

<%

}
else{

%>

<span class="badge red">

OFF

</span>

<%

}

%>

</td>

</tr>

<tr>

<td>Maintenance Mode</td>

<td>

<%

if(setting.getMaintenanceMode().equals("ON")){

%>

<span class="badge red">

ON

</span>

<%

}
else{

%>

<span class="badge green">

OFF

</span>

<%

}

%>

</td>

</tr>

</table>

</div>

<!-- ========================================= -->
<!-- FOOTER -->
<!-- ========================================= -->

<div class="footer">

© 2026 CampusConnect

<br>

Super Admin Control Panel

</div>

</div>

</body>

</html>
<body>