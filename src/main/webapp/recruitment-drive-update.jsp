<%@ page import="com.campusconnect.bean.RecruitmentDrive" %>

<%

    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) {
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


    // Check required values

    if (driveId == null ||
        driveType == null ||
        jobTitle == null ||
        description == null ||
        vacancy == null ||
        eligibilityCgpa == null ||
        requiredBranch == null ||
        requiredSkills == null ||
        salary == null ||
        deadline == null ||
        status == null) {

        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }


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


    if (result) {

        response.sendRedirect("view-recruitment-drives.jsp");

        return;

    }

%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Update Failed</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f4f8fc;
            text-align: center;
            padding-top: 100px;
        }

        .box {
            background: white;
            width: 500px;
            margin: auto;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        h2 {
            color: #d32f2f;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 20px;
            background: #087ff0;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

    </style>

</head>

<body>

    <div class="box">

        <h2>Update Failed</h2>

        <p>
            Recruitment drive could not be updated.
        </p>

        <a href="view-recruitment-drives.jsp">
            Back to Recruitment Drives
        </a>

    </div>

</body>

</html>