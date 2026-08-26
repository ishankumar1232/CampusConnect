<%@page import="com.campusconnect.bean.Company"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String companyName = request.getParameter("companyName");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String website = request.getParameter("website");

    Company c = new Company();

    c.setCompanyId(companyId);
    c.setCompanyName(companyName);
    c.setPhone(phone);
    c.setAddress(address);
    c.setWebsite(website);

    boolean result = c.UpdateMethod();
%>

<html>

<head>

<title>Company Profile Update</title>

</head>

<body>

<%
    if(result)
    {
%>

<h2>Company Profile Updated Successfully</h2>

<p>Your company profile has been updated successfully.</p>

<a href="company-profile.jsp">View Profile</a>

<%
    }
    else
    {
%>

<h2>Company Profile Update Failed</h2>

<p>Unable to update company profile.</p>

<a href="company-edit-profile.jsp">Try Again</a>

<%
    }
%>

</body>

</html>