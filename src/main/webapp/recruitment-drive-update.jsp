<%@page import="com.campusconnect.bean.RecruitmentDrive"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveId = request.getParameter("driveId");
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

    r.setDriveId(Integer.parseInt(driveId));
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


    boolean result = r.UpdateMethod();
%>

<html>

<head>

<title>Update Recruitment Drive</title>

</head>

<body>

<%
    if(result)
    {
%>

<h2>Recruitment Drive Updated Successfully</h2>

<p>The recruitment drive has been updated successfully.</p>

<a href="view-recruitment-drives.jsp">
View Recruitment Drives
</a>

<%
    }
    else
    {
%>

<h2>Recruitment Drive Update Failed</h2>

<p>Unable to update the recruitment drive.</p>

<a href="view-recruitment-drives.jsp">
Back to Recruitment Drives
</a>

<%
    }
%>

</body>

</html>