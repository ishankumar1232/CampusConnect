<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.RecruitmentDrive"%>

<%
ArrayList<RecruitmentDrive> list = (ArrayList<RecruitmentDrive>)request.getAttribute("driveList");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Monitor Recruitment</title>


</head>

<body>

<h2 align="center">Recruitment Drives</h2>

<table border="1" align="center" cellpadding="8">

<tr>
<!-- TABLE COLUMNS -->

<th>Drive ID</th>
<th>Company ID</th>
<th>Type</th>
<th>Job</th>
<th>Vacancy</th>
<th>CGPA</th>
<th>Branch</th>
<th>Salary</th>
<th>Deadline</th>
<th>Status</th>
</tr>

<%

if(list!=null)
{

for(RecruitmentDrive d:list)
{

%>

<tr>

<td><%=d.getDriveId()%></td>
<td><%=d.getCompanyId()%></td>
<td><%=d.getDriveType()%></td>
<td><%=d.getJobTitle()%></td>
<td><%=d.getVacancy()%></td>
<td><%=d.getEligibilityCgpa()%></td>
<td><%=d.getRequiredBranch()%></td>
<td><%=d.getSalary()%></td>
<td><%=d.getDeadline()%></td>
<td><%=d.getStatus()%></td>

</tr>

<%
}
}
%>

</table>

</body>
</html>