<%
    String companyName = (String)session.getAttribute("companyName");
    String email = (String)session.getAttribute("email");

    if(companyName == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }
%>

<html>

<head>
    <title>Company Dashboard</title>
</head>

<body>

<h2>Welcome to Company Dashboard</h2>

<h3>Welcome <%= companyName %></h3>

<p>Company Email: <%= email %></p>

<p>Company Login Successful.</p>

<a href="company-profile.jsp">View Profile</a>

<br><br>

<a href="recruitment-drive.jsp">Create Recruitment Drive</a>

<br><br>

<a href="view-recruitment-drives.jsp">View Recruitment Drives</a>

<br><br>

<a href="company-reports.jsp">Reports & Analytics</a>

<br><br>

<a href="CompanyLogoutServlet">Logout</a>

</body>

</html>