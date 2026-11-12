<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.College"%>

<%
ArrayList<College> list =
(ArrayList<College>)request.getAttribute("collegeList");
%>

<!DOCTYPE html>
<html>

<head>

<title>College Management</title>

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
    margin:35px auto;
    background:white;
    padding:25px;
    border-radius:12px;
    box-shadow:0 5px 15px rgba(0,0,0,.15);
}

h2{
    text-align:center;
    color:#0B3D91;
    margin-bottom:25px;
    font-size:34px;
}

.back-btn{
    float:right;
    background:#0B3D91;
    color:white;
    padding:10px 20px;
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
}

th{
    background:#0B3D91;
    color:white;
    padding:14px;
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
    border-radius:6px;
    text-decoration:none;
    font-weight:bold;
}

.btnApprove:hover{
    background:#146c43;
}

.btnReject{
    background:#dc3545;
    color:white;
    padding:8px 15px;
    border-radius:6px;
    text-decoration:none;
    font-weight:bold;
}

.btnReject:hover{
    background:#b02a37;
}

</style>

</head>

<body>

<a href="<%=request.getContextPath()%>/DashboardServlet"
class="back-btn">Back to Dashboard
</a>

<h2>College Management</h2>

<div style="clear:both;"></div>

<table>

<tr>

    <th>ID</th>
    <th>College Name</th>
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

<td>

<%
if(c.getStatus().equalsIgnoreCase("APPROVED")){
%>

<span class="approved">
APPROVED
</span>

<%
}
else if(c.getStatus().equalsIgnoreCase("PENDING")){
%>

<span class="pending">
PENDING
</span>

<%
}
else{
%>

<span class="rejected">
REJECTED
</span>

<%
}
%>

</td>

<!-- APPROVE BUTTON -->

<td>

<a class="btnApprove"
href="<%=request.getContextPath()%>/ApproveCollegeServlet?id=<%=c.getCollegeId()%>">
Approve
</a>

</td>

<!-- REJECT BUTTON -->

<td>

<a class="btnReject"
href="<%=request.getContextPath()%>/RejectCollegeServlet?id=<%=c.getCollegeId()%>">
Reject
</a>

</td>

</tr>

<%

}

}

%>

</table>


</body>

</html>