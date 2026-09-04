<%@page import="com.campusconnect.bean.RecruitmentDrive"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    RecruitmentDrive r = new RecruitmentDrive();

    r.setCompanyId(companyId);
    
    int totalDrives = r.TotalDriveMethod();
    int activeDrives = r.ActiveDriveMethod();
    int closedDrives = r.ClosedDriveMethod();
    int totalVacancies = r.TotalVacancyMethod();
    int campusDrives = r.CampusDriveMethod();
    int directDrives = r.DirectDriveMethod();
%>

<html>

<head>

    <title>Company Reports & Analytics</title>

</head>

<body>

<h2>Company Reports & Analytics</h2>

<table border="1" cellpadding="10" cellspacing="0">

    <tr>
        <th>Report</th>
        <th>Total</th>
    </tr>

    <tr>
        <td>Total Recruitment Drives</td>
        <td><%= totalDrives %></td>
    </tr>

    <tr>
    <td>Active Drives</td>
    <td><%= activeDrives %></td>
</tr>

    <tr>
    <td>Closed Drives</td>
    <td><%= closedDrives %></td>
</tr>

    <tr>
    <td>Total Vacancies</td>
    <td><%= totalVacancies %></td>
</tr>

    <tr>
    <td>Campus Drives</td>
    <td><%= campusDrives %></td>
</tr>

    <tr>
    <td>Direct Drives</td>
    <td><%= directDrives %></td>
</tr>

</table>

<br>

<a href="company-dashboard.jsp">Back to Dashboard</a>

</body>

</html>