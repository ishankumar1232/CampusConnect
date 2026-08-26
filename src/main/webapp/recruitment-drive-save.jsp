<%@page import="com.campusconnect.bean.RecruitmentDrive"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveType = request.getParameter("driveType");
    String jobTitle = request.getParameter("jobTitle");
    String description = request.getParameter("description");
    String vacancy = request.getParameter("vacancy");
    String eligibilityCgpa = request.getParameter("eligibilityCgpa");
    String requiredBranch = request.getParameter("requiredBranch");
    String requiredSkills = request.getParameter("requiredSkills");
    String salary = request.getParameter("salary");
    String deadline = request.getParameter("deadline");
    String status = request.getParameter("status");


    RecruitmentDrive r = new RecruitmentDrive();

    r.setCompanyId(companyId);
    r.setDriveType(driveType);
    r.setJobTitle(jobTitle);
    r.setDescription(description);
    r.setVacancy(Integer.parseInt(vacancy));
    r.setEligibilityCgpa(Double.parseDouble(eligibilityCgpa));
    r.setRequiredBranch(requiredBranch);
    r.setRequiredSkills(requiredSkills);
    r.setSalary(Double.parseDouble(salary));
    r.setDeadline(deadline);
    r.setStatus(status);


    boolean result = r.InsertMethod();
%>

<html>

<head>

<title>Recruitment Drive</title>

</head>

<body>

<%
    if(result)
    {
%>

<h2>Recruitment Drive Created Successfully</h2>

<p>Your recruitment drive has been created successfully.</p>

<a href="company-dashboard.jsp">Back to Dashboard</a>

<%
    }
    else
    {
%>

<h2>Recruitment Drive Creation Failed</h2>

<p>Unable to create recruitment drive.</p>

<a href="recruitment-drive.jsp">Try Again</a>

<%
    }
%>

</body>

</html>