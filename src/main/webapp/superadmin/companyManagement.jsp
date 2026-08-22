<%@page import="java.util.ArrayList"%>
<%@page import="com.campusconnect.bean.Company"%>

<% ArrayList<Company> list = (ArrayList<Company>)request.getAttribute("companyList");%>

<!DOCTYPE html>

<html>

<head>

<title>Company Management</title>



</head>

<body>

<h2 align="center">Company Management</h2>

<table border="1" align="center" cellpadding="10">


<tr>
	<!-- Table Columns -->

<th>ID</th>
<th>Name</th>
<th>Email</th>
<th>Phone</th>
<th>Website</th>
<th>Status</th>
<th>Action</th>

</tr>

<%
if(list!=null){

for(Company c:list){

%>

<tr>

<td><%=c.getCompanyId()%></td>

<td><%=c.getCompanyName()%></td>

<td><%=c.getEmail()%></td>

<td><%=c.getPhone()%></td>

<td><%=c.getWebsite()%></td>

<td><%=c.getStatus()%></td>


<td>

<a href="${pageContext.request.contextPath}/ApproveCompanyServlet?id=<%=c.getCompanyId()%>"><button>Approve</button></a> 	<!-- APPROVE BUTTON SERVLET -->


<a href="${pageContext.request.contextPath}/RejectCompanyServlet?id=<%=c.getCompanyId()%>"><button>Reject</button></a> 		<!-- REJECT BUTTON SERVLET -->

</td>

</tr>

<%
}
}
%>

</table>

</body>

</html>