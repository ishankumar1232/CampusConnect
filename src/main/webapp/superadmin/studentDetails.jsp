<%@ page import="com.campusconnect.bean.Student"%>

<%Student s =(Student)request.getAttribute("student");%>

<!DOCTYPE html>

<html>

<head>

<title>Student Details</title>

</head>

<body>

<h2 align="center">Student Details</h2>

<table border="1" align="center" cellpadding="10">

<tr>

<th>ID</th>

<td><%=s.getStudentId()%></td>

</tr>

<tr>

<th>Name</th>

<td><%=s.getName()%></td>

</tr>

<tr>

<th>Email</th>

<td><%=s.getEmail()%></td>

</tr>

<tr>

<th>Phone</th>

<td><%=s.getPhone()%></td>

</tr>

<tr>

<th>College ID</th>

<td><%=s.getCollegeId()%></td>

</tr>

<tr>

<th>Course ID</th>

<td><%=s.getCourseId()%></td>

</tr>

<tr>

<th>Gender</th>

<td><%=s.getGender()%></td>

</tr>

<tr>

<th>Status</th>

<td><%=s.getStatus()%></td>

</tr>

</table>

<br>

<center>

<a href="StudentManagementServlet">

<button>Back</button>

</a>

</center>

</body>

</html>