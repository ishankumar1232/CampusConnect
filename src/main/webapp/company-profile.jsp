<%@page import="com.campusconnect.bean.Company"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    Company c = new Company();

    c.setCompanyId(companyId);

    boolean result = c.SelectMethod();
%>

<html>

<head>
    <title>Company Profile</title>
</head>

<body>

<h2>Company Profile</h2>

<%
    if(result)
    {
%>

<table border="1" cellpadding="10" cellspacing="0">

<tr>
    <th>Field</th>
    <th>Details</th>
</tr>

<tr>
    <td>Company ID</td>
    <td><%= c.getCompanyId() %></td>
</tr>

<tr>
    <td>Company Name</td>
    <td><%= c.getCompanyName() %></td>
</tr>

<tr>
    <td>Email</td>
    <td><%= c.getEmail() %></td>
</tr>

<tr>
    <td>Phone</td>
    <td><%= c.getPhone() %></td>
</tr>

<tr>
    <td>Address</td>
    <td><%= c.getAddress() %></td>
</tr>

<tr>
    <td>Website</td>
    <td><%= c.getWebsite() %></td>
</tr>

<tr>
    <td>Status</td>
    <td><%= c.getStatus() %></td>
</tr>

</table>

<br>

<a href="company-edit-profile.jsp">Edit Profile</a>

<br><br>

<a href="company-dashboard.jsp">Back to Dashboard</a>

<%
    }
    else
    {
%>

<p>Unable to load company profile.</p>

<a href="company-dashboard.jsp">Back to Dashboard</a>

<%
    }
%>

</body>

</html>