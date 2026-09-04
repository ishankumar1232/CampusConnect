<%@page import="java.util.ArrayList"%>
<%@page import="com.campusconnect.bean.User"%>

<% ArrayList<User> list = (ArrayList<User>)request.getAttribute("userList"); %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>User Management</title>



<style>

body{
    font-family: Arial;
    background:#f2f2f2;
}

h2{
    text-align:center;
    color:blue;
}

table{
    border-collapse:collapse;
    width:90%;
    margin:auto;
    background:white;
}

th{
    background:blue;
    color:white;
}

th,td{
    padding:10px;
    text-align:center;
    border:1px solid black;
}

button{
    padding:6px 12px;
    border:none;
    color:white;
    cursor:pointer;
    border-radius:4px;
}

.approve{
    background:green;
}

.reject{
    background:red;
}

</style>

</head>

<body>

<h2>User Management</h2>

<table>

<tr>

<th>User ID</th>
<th>Name</th>
<th>Email</th>
<th>Role</th>
<th>Status</th>
<th>Action</th>

</tr>

<%

if(list!=null){

for(User u:list){

%>

<tr>

<td><%=u.getUserId()%></td>

<td><%=u.getName()%></td>

<td><%=u.getEmail()%></td>

<td><%=u.getRole()%></td>

<td><%=u.getStatus()%></td>

<td>

<a href="${pageContext.request.contextPath}/ActivateUserServlet?id=<%=u.getUserId()%>">

	<!-- ActivateServlet Connection -->
<a href="${pageContext.request.contextPath}/ActivateUserServlet?id=<%=u.getUserId()%>">
    <button class="approve">Activate</button>
</a>

	<!-- DeactivateServlet Connection -->
<a href="${pageContext.request.contextPath}/DeactivateUserServlet?id=<%=u.getUserId()%>">
    <button class="reject">Deactivate</button>
</a>

</a>

</td>

</tr>

<%

}

}

else{

%>

<tr>

<td colspan="6"> No Users Found </td>

</tr>

<%

}

%>

</table>

</body>
</html>