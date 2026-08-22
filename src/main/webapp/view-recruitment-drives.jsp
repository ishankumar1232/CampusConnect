<%@page import="java.sql.ResultSet"%>
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

    ResultSet rs = r.SelectMethod();
%>

<html>

<head>

    <title>Recruitment Drives</title>

    <style>

        .action-btn
        {
            display: inline-block;

            padding: 5px 10px;

            margin: 2px;

            border: 1px solid #888;

            border-radius: 4px;

            background-color: #f2f2f2;

            color: #000;

            text-decoration: none;

            font-size: 13px;

            cursor: pointer;
        }

        .action-btn:hover
        {
            background-color: #e0e0e0;
        }

    </style>

</head>

<body>

<h2>My Recruitment Drives</h2>

<table border="1" cellpadding="8" cellspacing="0">

<tr>

    <th>Drive ID</th>

    <th>Drive Type</th>

    <th>Job Title</th>

    <th>Description</th>

    <th>Vacancy</th>

    <th>Eligibility CGPA</th>

    <th>Required Branch</th>

    <th>Required Skills</th>

    <th>Salary</th>

    <th>Deadline</th>

    <th>Status</th>

    <th>Action</th>

</tr>

<%

    boolean found = false;

    while(rs != null && rs.next())
    {

        found = true;

%>

<tr>

    <td>
        <%= rs.getInt("DRIVE_ID") %>
    </td>

    <td>
        <%= rs.getString("DRIVE_TYPE") %>
    </td>

    <td>
        <%= rs.getString("JOB_TITLE") %>
    </td>

    <td>
        <%= rs.getString("DESCRIPTION") %>
    </td>

    <td>
        <%= rs.getInt("VACANCY") %>
    </td>

    <td>
        <%= rs.getDouble("ELIGIBILITY_CGPA") %>
    </td>

    <td>
        <%= rs.getString("REQUIRED_BRANCH") %>
    </td>

    <td>
        <%= rs.getString("REQUIRED_SKILLS") %>
    </td>

    <td>
        <%= rs.getDouble("SALARY") %>
    </td>

    <td>
        <%= rs.getDate("DEADLINE") %>
    </td>

    <td>
        <%= rs.getString("STATUS") %>
    </td>

    <td>

        <a
            href="edit-recruitment-drive.jsp?driveId=<%= rs.getInt("DRIVE_ID") %>"
            class="action-btn">
            Edit
        </a>


        <a
            href="close-recruitment-drive.jsp?driveId=<%= rs.getInt("DRIVE_ID") %>"
            class="action-btn"
            onclick="return confirm('Are you sure you want to close this recruitment drive?');">
            Close
        </a>


<%

        if("On Campus".equalsIgnoreCase(rs.getString("DRIVE_TYPE")))
        {

%>

        <a
            href="select-drive-colleges.jsp?driveId=<%= rs.getInt("DRIVE_ID") %>"
            class="action-btn">
            Select Colleges
        </a>

<%

        }

%>

    </td>

</tr>

<%

    }

    if(!found)
    {

%>

<tr>

    <td colspan="12">

        No Recruitment Drives Found

    </td>

</tr>

<%

    }

%>

</table>

<br>

<a href="recruitment-drive.jsp">
    Create New Recruitment Drive
</a>

<br><br>

<a href="company-dashboard.jsp">
    Back to Dashboard
</a>

</body>

</html>