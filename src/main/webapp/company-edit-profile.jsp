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

    if(!result)
    {
        out.println("Unable to load company details.");
        return;
    }
%>

<html>

<head>

<title>Edit Company Profile</title>

</head>

<body>

<h2>Edit Company Profile</h2>

<form method="post" action="company-update.jsp">

<table border="1" cellpadding="10" cellspacing="0">

<tr>
    <td>Company ID</td>
    <td>
        <input type="text"
               name="companyId"
               value="<%= c.getCompanyId() %>"
               readonly>
    </td>
</tr>

<tr>
    <td>Company Name</td>
    <td>
        <input type="text"
               name="companyName"
               value="<%= c.getCompanyName() %>">
    </td>
</tr>

<tr>
    <td>Email</td>
    <td>
        <input type="email"
               value="<%= c.getEmail() %>"
               readonly>
    </td>
</tr>

<tr>
    <td>Phone</td>
    <td>
        <input type="text"
               name="phone"
               value="<%= c.getPhone() %>">
    </td>
</tr>

<tr>
    <td>Address</td>
    <td>
        <textarea name="address"
                  rows="3"
                  cols="25"><%= c.getAddress() %></textarea>
    </td>
</tr>

<tr>
    <td>Website</td>
    <td>
        <input type="text"
               name="website"
               value="<%= c.getWebsite() %>">
    </td>
</tr>

<tr>
    <td>Status</td>
    <td>
        <input type="text"
               value="<%= c.getStatus() %>"
               readonly>
    </td>
</tr>

<tr>
    <td>
        <input type="submit" value="Update">
    </td>

    <td>
        <input type="reset" value="Reset">
    </td>
</tr>

</table>

</form>

<br>

<a href="company-profile.jsp">Back to Profile</a>

</body>

</html>