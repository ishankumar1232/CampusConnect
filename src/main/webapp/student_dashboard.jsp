<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null || session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Dashboard</title>

</head>


<body>

<h1>Student Dashboard</h1>

<hr>


<table border="1" cellpadding="12" cellspacing="0">


<tr>

    <td>
        <a href="student_profile.jsp">
            My Profile
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_academic.jsp">
            Add Academic Details
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_academic_view.jsp">
            View Academic Details
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_skill.jsp">
            Add Skills
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_skill_view.jsp">
            View Skills
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_project.jsp">
            Add Project
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_project_view.jsp">
            View Projects
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_resume.jsp">
            Upload Resume
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_resume_view.jsp">
            View Resume
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_drive_view.jsp">
            Available Placement Drives
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_application_view.jsp">
            My Applications
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_interview_view.jsp">
            Interview Details
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_selection_view.jsp">
            Selection Result
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_placement_opportunities.jsp">
    Placement Opportunities
</a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_notice_view.jsp">
            Notifications
        </a>
    </td>

</tr>


<tr>

    <td>
        <a href="student_login.jsp">
            Logout
        </a>
    </td>

</tr>


</table>


</body>

</html>