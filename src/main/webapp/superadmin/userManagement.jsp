<%@page import="java.util.ArrayList"%>
<%@page import="com.campusconnect.bean.User"%>

<% ArrayList<User> list = (ArrayList<User>)request.getAttribute("userList"); %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>User Management</title>



<style>
*{
    margin:0;
    padding:10px;
    box-sizing:border-box;
    font-family:Arial, Helvetica, sans-serif;
}


h2{
    text-align:center;
    color:#0B3D91;
    margin-bottom:25px;
    font-size:34px;
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

.back-btn{
    float:right;
    display:inline-block;
    padding:10px 20px;
    background:#0B3D91;
    color:white;
    text-decoration:none;
    border-radius:6px;
    font-weight:bold;
    margin-bottom:20px;
}

.back-btn:hover{
    background:#072c69;
}
</style>

</head>

<body>

<a href="<%=request.getContextPath()%>/DashboardServlet"
class="back-btn">
 Back to Dashboard
</a>

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