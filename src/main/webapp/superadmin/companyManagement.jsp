<%@ page import="java.util.ArrayList" %>
<%@ page import="com.campusconnect.bean.Company" %>

<%
ArrayList<Company> list =
(ArrayList<Company>)request.getAttribute("companyList");
%>

<!DOCTYPE html>
<html>

<head>

<title>Company Management</title>

<style>

*{
    margin:0;
    padding:10px;
    box-sizing:border-box;
    font-family:Arial,Helvetica,sans-serif;
    

}

body{
    background:#eef2f7;
}

.container{
    width:95%;
    margin:30px auto;
}

h2{
    text-align:center;
    color:#0B3D91;
    margin-bottom:25px;
    font-size:34px;
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

table{
    width:100%;
    border-collapse:collapse;
    background:white;
    border-radius:10px;
    overflow:hidden;
    box-shadow:0 5px 15px rgba(0,0,0,.15);
}

th{
    background:#0B3D91;
    color:white;
    padding:14px;
    font-size:16px;
}

td{
    padding:14px;
    text-align:center;
    border-bottom:1px solid #ddd;
}

tr:nth-child(even){
    background:#f8f9fa;
}

tr:hover{
    background:#e8f0ff;
}

.approved{
    background:#28a745;
    color:white;
    padding:6px 12px;
    border-radius:20px;
    font-size:13px;
    font-weight:bold;
}

.pending{
    background:#ff9800;
    color:white;
    padding:6px 12px;
    border-radius:20px;
    font-size:13px;
    font-weight:bold;
}

.rejected{
    background:#dc3545;
    color:white;
    padding:6px 12px;
    border-radius:20px;
    font-size:13px;
    font-weight:bold;
}

.btnApprove{
    background:#198754;
    color:white;
    padding:8px 15px;
    text-decoration:none;
    border-radius:6px;
    font-size:14px;
    font-weight:bold;
}

.btnApprove:hover{
    background:#146c43;
}

.btnReject{
    background:#dc3545;
    color:white;
    padding:8px 15px;
    text-decoration:none;
    border-radius:6px;
    font-size:14px;
    font-weight:bold;
}

.btnReject:hover{
    background:#b02a37;
}

</style>

</head>

<body>

<a href="<%=request.getContextPath()%>/DashboardServlet"
class="back-btn">
&lt; Back to Dashboard
</a>

<h2 align="center">Company Management</h2>

<div style="clear:both;"></div>

<table>

<tr>

    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Phone</th>
    <th>Website</th>
    <th>Status</th>
    <th>Approve</th>
    <th>Reject</th>

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

<td>

<%
if(c.getStatus().equalsIgnoreCase("Approved")){
%>

<span class="approved">APPROVED</span>

<%
}
else if(c.getStatus().equalsIgnoreCase("Pending")){
%>

<span class="pending">PENDING</span>

<%
}
else{
%>

<span class="rejected">REJECTED</span>

<%
}
%>

</td>

<!-- APPROVE COLUMN -->

<td>



<a class="btnApprove"
href="<%=request.getContextPath()%>/ApproveCompanyServlet?id=<%=c.getCompanyId()%>">
Approve
</a>

</td>

<!-- REJECT COLUMN -->
<td>
<a class="btnReject"
href="<%=request.getContextPath()%>/RejectCompanyServlet?id=<%=c.getCompanyId()%>">
Reject
</a>
</td>

</tr>

<%

}

}

else{

%>

<tr>

<td colspan="8">
No Company Records Found
</td>

</tr>

<%

}

%>

</table>

</body>

</html>