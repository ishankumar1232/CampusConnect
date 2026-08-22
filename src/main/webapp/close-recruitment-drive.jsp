<%@page import="com.campusconnect.bean.RecruitmentDrive"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveId = request.getParameter("driveId");

    if(driveId == null)
    {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    RecruitmentDrive r = new RecruitmentDrive();

    r.setDriveId(Integer.parseInt(driveId));
    r.setCompanyId(companyId);

    boolean result = r.CloseMethod();
%>

<html>

<head>

<title>Close Recruitment Drive</title>

</head>

<body>

<%
    if(result)
    {
%>

<h2>Recruitment Drive Closed Successfully</h2>

<p>The recruitment drive has been closed successfully.</p>

<a href="view-recruitment-drives.jsp">
Back to Recruitment Drives
</a>

<%
    }
    else
    {
%>

<h2>Unable to Close Recruitment Drive</h2>

<p>The recruitment drive could not be closed.</p>

<a href="view-recruitment-drives.jsp">
Back to Recruitment Drives
</a>

<%
    }
%>

</body>

</html>