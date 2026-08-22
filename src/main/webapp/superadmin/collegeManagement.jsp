 <%@page import="java.util.ArrayList"%>
<%@page import="com.campusconnect.bean.College"%>

<%

ArrayList<College> list=(ArrayList<College>)request.getAttribute("collegeList");

%>

<!DOCTYPE html>

<html>

<head>

<title>College Management</title>



<style>

table{

border-collapse:collapse;
width:100%;

}

th,td{

border:1px solid black;
padding:10px;
text-align:center;

}

</style>

</head>

<body>

<h2>College Management</h2>

<table>

<tr>
<!-- Table Columns -->

<th>ID</th>

<th>Name</th>

<th>City</th>

<th>State</th>

<th>Email</th>

<th>Phone</th>

<th>Status</th>

<th>Approve</th>

<th>Reject</th>

</tr>

<% 

 if(list!=null){ 
	
 for(College c:list){

%>

<tr>

<td><%=c.getCollegeId()%></td>

<td><%=c.getCollegeName()%></td>

<td><%=c.getCity()%></td>

<td><%=c.getState()%></td>

<td><%=c.getEmail()%></td>

<td><%=c.getPhone()%></td>

<td><%=c.getStatus()%></td>

<td>

<a href="<%=request.getContextPath()%>/ApproveCollegeServlet?id=<%=c.getCollegeId()%>">Approve</a>		<!-- APPROVE BUTTON -->

</td>

<td>

<a href="<%=request.getContextPath()%>/RejectCollegeServlet?id=<%=c.getCollegeId()%>">Reject</a>		<!-- REJECT BUTTON -->

</td>

</tr>

<%

}

}

%>

</table>

</body>

</html>