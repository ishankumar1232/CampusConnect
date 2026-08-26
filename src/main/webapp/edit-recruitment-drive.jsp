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

    if(rs == null || !rs.next())
    {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }
%>

<html>

<head>

<title>Edit Recruitment Drive</title>

</head>

<body>

<h2>Edit Recruitment Drive</h2>

<form method="post"
      action="recruitment-drive-update.jsp">


<table border="0" cellpadding="8">


<tr>

<td>Drive ID</td>

<td>

<input type="text"
       value="<%= rs.getInt("DRIVE_ID") %>"
       readonly>

</td>

</tr>


<tr>

<td>Drive Type</td>

<td>

<select name="driveType">

<option value="On Campus"
<%
if(rs.getString("DRIVE_TYPE").equals("On Campus"))
{
%>
selected
<%
}
%>
>
On Campus
</option>

<option value="Off Campus"
<%
if(rs.getString("DRIVE_TYPE").equals("Off Campus"))
{
%>
selected
<%
}
%>
>
Off Campus
</option>

</select>

</td>

</tr>


<tr>

<td>Job Title</td>

<td>

<input type="text"
       name="jobTitle"
       value="<%= rs.getString("JOB_TITLE") %>">

</td>

</tr>


<tr>

<td>Description</td>

<td>

<textarea name="description"
          rows="4"
          cols="30"><%= rs.getString("DESCRIPTION") %></textarea>

</td>

</tr>


<tr>

<td>Vacancy</td>

<td>

<input type="text"
       name="vacancy"
       value="<%= rs.getInt("VACANCY") %>">

</td>

</tr>


<tr>

<td>Eligibility CGPA</td>

<td>

<input type="text"
       name="eligibilityCgpa"
       value="<%= rs.getDouble("ELIGIBILITY_CGPA") %>">

</td>

</tr>


<tr>

<td>Required Branch</td>

<td>

<input type="text"
       name="requiredBranch"
       value="<%= rs.getString("REQUIRED_BRANCH") %>">

</td>

</tr>


<tr>

<td>Required Skills</td>

<td>

<textarea name="requiredSkills"
          rows="3"
          cols="30"><%= rs.getString("REQUIRED_SKILLS") %></textarea>

</td>

</tr>


<tr>

<td>Salary</td>

<td>

<input type="text"
       name="salary"
       value="<%= rs.getDouble("SALARY") %>">

</td>

</tr>


<tr>

<td>Deadline</td>

<td>

<input type="text"
       name="deadline"
       value="<%= rs.getDate("DEADLINE") %>"
       placeholder="DD-MM-YYYY">

</td>

</tr>


<tr>

<td>Status</td>

<td>

<select name="status">

<option value="ACTIVE"
<%
if(rs.getString("STATUS").equals("ACTIVE"))
{
%>
selected
<%
}
%>
>
ACTIVE
</option>

<option value="CLOSED"
<%
if(rs.getString("STATUS").equals("CLOSED"))
{
%>
selected
<%
}
%>
>
CLOSED
</option>

</select>

</td>

</tr>


<tr>

<td>

<input type="hidden"
       name="driveId"
       value="<%= rs.getInt("DRIVE_ID") %>">

<input type="submit"
       value="Update Drive">

</td>

<td>

<input type="reset"
       value="Reset">

</td>

</tr>


</table>

</form>

<br>

<a href="view-recruitment-drives.jsp">
Back to Recruitment Drives
</a>

</body>

</html>