<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.Student"%>

<% ArrayList<Student> list = (ArrayList<Student>)request.getAttribute("studentList"); %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Student Management</title>



</head>

<body>

<h2 align="center">Student Management</h2>

<table border="1" align="center" cellpadding="10">

<tr>

<th>ID</th>
<th>College</th>
<th>Course</th>
<th>Name</th>
<th>Email</th>
<th>Phone</th>
<th>Gender</th>
<th>Status</th>
<th>Action</th>

</tr>

<%
if(list!=null)
{
    for(Student s:list)
    {
%>

<tr>

<td><%=s.getStudentId()%></td>

<td><%=s.getCollegeId()%></td>

<td><%=s.getCourseId()%></td>

<td><%=s.getName()%></td>

<td><%=s.getEmail()%></td>

<td><%=s.getPhone()%></td>

<td><%=s.getGender()%></td>

<td><%=s.getStatus()%></td>

<td>

<!-- View Button -->

<a href="${pageContext.request.contextPath}/StudentDetailsServlet?id=<%=s.getStudentId()%>">

<button style="background:blue;color:white;">

View

</button>

</a>

&nbsp;

<%
if("ACTIVE".equalsIgnoreCase(s.getStatus()))
{
%>

<!-- Deactivate Button -->

<a href="${pageContext.request.contextPath}/DeactivateStudentServlet?id=<%=s.getStudentId()%>">

<button style="background:red;color:white;">

Deactivate

</button>

</a>

<%
}
else
{
%>

<!-- Activate Button -->

<a href="${pageContext.request.contextPath}/ActivateStudentServlet?id=<%=s.getStudentId()%>">

<button style="background:green;color:white;">

Activate

</button>

</a>

<%
}
%>

</td>

</tr>

<%
    }
}
%>

</table>

</body>

</html>