<%@page import="java.sql.ResultSet"%>
<%@page import="com.campusconnect.bean.RecruitmentDrive"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveId = request.getParameter("driveId");

    if(driveId == null)
    {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    RecruitmentDrive r = new RecruitmentDrive();

    r.setCompanyId(companyId);
    r.setDriveId(Integer.parseInt(driveId));

    ResultSet rs = r.SelectByIdMethod();
%>

<html>

<head>

<title>Recruitment Drive Details</title>

</head>

<body>

<h2>Recruitment Drive Details</h2>

<%
    if(rs != null && rs.next())
    {
%>

<table border="1" cellpadding="10" cellspacing="0">

<tr>
    <th>Field</th>
    <th>Details</th>
</tr>

<tr>
    <td>Drive ID</td>
    <td><%= rs.getInt("DRIVE_ID") %></td>
</tr>

<tr>
    <td>Company ID</td>
    <td><%= rs.getInt("COMPANY_ID") %></td>
</tr>

<tr>
    <td>Drive Type</td>
    <td><%= rs.getString("DRIVE_TYPE") %></td>
</tr>

<tr>
    <td>Job Title</td>
    <td><%= rs.getString("JOB_TITLE") %></td>
</tr>

<tr>
    <td>Description</td>
    <td><%= rs.getString("DESCRIPTION") %></td>
</tr>

<tr>
    <td>Vacancy</td>
    <td><%= rs.getInt("VACANCY") %></td>
</tr>

<tr>
    <td>Eligibility CGPA</td>
    <td><%= rs.getDouble("ELIGIBILITY_CGPA") %></td>
</tr>

<tr>
    <td>Required Branch</td>
    <td><%= rs.getString("REQUIRED_BRANCH") %></td>
</tr>

<tr>
    <td>Required Skills</td>
    <td><%= rs.getString("REQUIRED_SKILLS") %></td>
</tr>

<tr>
    <td>Salary</td>
    <td><%= rs.getDouble("SALARY") %></td>
</tr>

<tr>
    <td>Deadline</td>
    <td><%= rs.getDate("DEADLINE") %></td>
</tr>

<tr>
    <td>Status</td>
    <td><%= rs.getString("STATUS") %></td>
</tr>

</table>

<%
    }
    else
    {
%>

<p>Recruitment Drive not found.</p>

<%
    }
%>

<br>

<a href="view-recruitment-drives.jsp">Back to Recruitment Drives</a>

<br><br>

<a href="company-dashboard.jsp">Back to Dashboard</a>

</body>

</html>