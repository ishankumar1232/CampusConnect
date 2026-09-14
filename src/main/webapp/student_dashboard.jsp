<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null ||
       session1.getAttribute("studentId") == null)
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


    <style>

        body
        {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }


        h1
        {
            text-align: center;
            background-color: #1f4e79;
            color: white;
            padding: 25px;
            margin: 0;
        }


        .container
        {
            width: 80%;
            margin: 30px auto;
        }


        .dashboard
        {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);

            gap: 20px;
        }


        .card
        {
            background-color: white;
            padding: 25px;
            text-align: center;

            border-radius: 10px;

            box-shadow:
                0 3px 10px
                rgba(0,0,0,0.15);

            transition: 0.3s;
        }


        .card:hover
        {
            transform: translateY(-5px);

            box-shadow:
                0 6px 15px
                rgba(0,0,0,0.20);
        }


        .card a
        {
            text-decoration: none;
            color: #1f4e79;
            font-size: 17px;
            font-weight: bold;
        }


        .logout
        {
            background-color: #d9534f;
        }


        .logout a
        {
            color: white;
        }


        .footer
        {
            text-align: center;
            margin-top: 30px;
            color: #666;
        }


        @media(max-width: 800px)
        {
            .dashboard
            {
                grid-template-columns:
                    repeat(2, 1fr);
            }
        }


        @media(max-width: 500px)
        {
            .dashboard
            {
                grid-template-columns: 1fr;
            }
        }

    </style>

</head>


<body>


<h1>Student Dashboard</h1>


<div class="container">


<div class="dashboard">


    <div class="card">
        <a href="student_profile.jsp">
            My Profile
        </a>
    </div>


    <div class="card">
        <a href="student_academic.jsp">
            Add Academic Details
        </a>
    </div>


    <div class="card">
        <a href="student_academic_view.jsp">
            View Academic Details
        </a>
    </div>


    <div class="card">
        <a href="student_skill.jsp">
            Add Skills
        </a>
    </div>


    <div class="card">
        <a href="student_skill_view.jsp">
            View Skills
        </a>
    </div>


    <div class="card">
        <a href="student_project.jsp">
            Add Project
        </a>
    </div>


    <div class="card">
        <a href="student_project_view.jsp">
            View Projects
        </a>
    </div>


    <div class="card">
        <a href="student_resume.jsp">
            Upload Resume
        </a>
    </div>


    <div class="card">
        <a href="student_resume_view.jsp">
            View Resume
        </a>
    </div>


    <div class="card">
        <a href="student_drive_view.jsp">
            Available Placement Drives
        </a>
    </div>


    <div class="card">
        <a href="student_placement_opportunities.jsp">
            Placement Opportunities
        </a>
    </div>


    <div class="card">
        <a href="student_application_view.jsp">
            My Applications
        </a>
    </div>


    <div class="card">
        <a href="student_interview_view.jsp">
            Interview Details
        </a>
    </div>


    <div class="card">
        <a href="student_selection_view.jsp">
            Selection Result
        </a>
    </div>


    <div class="card">
        <a href="student_notice_view.jsp">
            Notifications
        </a>
    </div>


    <div class="card logout">
        <a href="student_logout.jsp">
            Logout
        </a>
    </div>


</div>


<div class="footer">

    CampusConnect Student Portal

</div>


</div>


</body>

</html>