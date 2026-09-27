<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null ||
       session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

    String studentName = "Student";

    if(session1.getAttribute("studentName") != null)
    {
        studentName =
            session1.getAttribute("studentName").toString();
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Dashboard | CampusConnect</title>


<style>

/* =========================================
   GLOBAL
========================================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    min-height: 100vh;

    background:
        radial-gradient(
            circle at 5% 5%,
            rgba(37,99,235,0.08),
            transparent 25%
        ),
        radial-gradient(
            circle at 95% 10%,
            rgba(14,165,233,0.07),
            transparent 25%
        ),
        #f5f8fc;

    color: #26364f;
}


/* =========================================
   NAVBAR
========================================= */

.navbar {

    height: 72px;

    background:
        linear-gradient(
            135deg,
            #081b3d,
            #123c88,
            #1769e0
        );

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding: 0 6%;

    color: white;

    box-shadow:
        0 8px 25px
        rgba(8,27,61,0.18);

    position: sticky;

    top: 0;

    z-index: 100;
}


.logo {

    font-size: 25px;

    font-weight: bold;

    letter-spacing: -0.5px;
}

.logo span {

    color: #a9d0ff;
}


.nav-right {

    display: flex;

    align-items: center;

    gap: 18px;
}


.student-mini {

    display: flex;

    align-items: center;

    gap: 10px;

    color: #e7f1ff;

    font-size: 14px;
}


.avatar {

    width: 38px;

    height: 38px;

    border-radius: 50%;

    background:
        rgba(255,255,255,0.16);

    border:
        1px solid
        rgba(255,255,255,0.3);

    display: flex;

    align-items: center;

    justify-content: center;

    font-weight: bold;
}


.logout-top {

    text-decoration: none;

    color: white;

    border:
        1px solid
        rgba(255,255,255,0.45);

    padding: 9px 15px;

    border-radius: 8px;

    font-size: 13px;

    transition: 0.25s;
}


.logout-top:hover {

    background: white;

    color: #123c88;
}


/* =========================================
   MAIN
========================================= */

.main {

    width: 88%;

    max-width: 1250px;

    margin: 35px auto 60px;
}


/* =========================================
   WELCOME BANNER
========================================= */

.welcome {

    position: relative;

    overflow: hidden;

    background:
        linear-gradient(
            135deg,
            #123c88,
            #1769e0
        );

    border-radius: 20px;

    padding: 32px 38px;

    color: white;

    margin-bottom: 30px;

    box-shadow:
        0 15px 35px
        rgba(23,105,224,0.18);
}


.welcome::after {

    content: "";

    position: absolute;

    width: 240px;

    height: 240px;

    border-radius: 50%;

    background:
        rgba(255,255,255,0.07);

    right: -80px;

    top: -100px;
}


.welcome::before {

    content: "";

    position: absolute;

    width: 150px;

    height: 150px;

    border-radius: 50%;

    background:
        rgba(255,255,255,0.05);

    right: 160px;

    bottom: -100px;
}


.welcome-content {

    position: relative;

    z-index: 2;
}


.welcome small {

    color: #cce2ff;

    font-size: 13px;
}


.welcome h1 {

    font-size: 31px;

    margin: 8px 0;

}


.welcome p {

    color: #dceaff;

    font-size: 14px;

    line-height: 1.6;
}


/* =========================================
   SECTION HEADER
========================================= */

.section-header {

    display: flex;

    align-items: center;

    justify-content: space-between;

    margin: 28px 0 16px;
}


.section-header h2 {

    font-size: 20px;

    color: #173c76;
}


.section-header p {

    font-size: 12px;

    color: #8290a4;
}


/* =========================================
   CARDS GRID
========================================= */

.dashboard {

    display: grid;

    grid-template-columns:
        repeat(4, 1fr);

    gap: 18px;
}


/* =========================================
   CARD
========================================= */

.card {

    background: white;

    min-height: 145px;

    padding: 22px;

    border-radius: 15px;

    border:
        1px solid
        rgba(148,163,184,0.20);

    box-shadow:
        0 7px 24px
        rgba(15,45,90,0.06);

    transition:
        transform 0.25s,
        box-shadow 0.25s,
        border-color 0.25s;

    position: relative;

    overflow: hidden;
}


.card::before {

    content: "";

    position: absolute;

    left: 0;

    top: 0;

    width: 4px;

    height: 100%;

    background:
        linear-gradient(
            180deg,
            #1769e0,
            #4da3ff
        );

    opacity: 0;

    transition: 0.25s;
}


.card:hover {

    transform: translateY(-5px);

    border-color: #c8dbf4;

    box-shadow:
        0 14px 30px
        rgba(15,45,90,0.11);
}


.card:hover::before {

    opacity: 1;
}


/* =========================================
   ICON
========================================= */

.card-icon {

    width: 45px;

    height: 45px;

    border-radius: 12px;

    background:
        linear-gradient(
            135deg,
            #edf5ff,
            #dcecff
        );

    color: #1769e0;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 19px;

    font-weight: bold;

    margin-bottom: 16px;
}


/* =========================================
   CARD TEXT
========================================= */

.card h3 {

    font-size: 15px;

    color: #263f63;

    margin-bottom: 6px;
}


.card p {

    font-size: 12px;

    color: #8995a7;

    line-height: 1.5;
}


.card a {

    position: absolute;

    inset: 0;

    text-decoration: none;

    color: transparent;

    font-size: 0;
}


/* =========================================
   SPECIAL CARD
========================================= */

.placement .card-icon {

    background:
        linear-gradient(
            135deg,
            #eafaf3,
            #d8f5e7
        );

    color: #15945b;
}


.recruitment .card-icon {

    background:
        linear-gradient(
            135deg,
            #fff4e8,
            #ffe5ca
        );

    color: #e67e22;
}


.account .card-icon {

    background:
        linear-gradient(
            135deg,
            #f0ebff,
            #e5dcff
        );

    color: #7357d8;
}


/* =========================================
   LOGOUT CARD
========================================= */

.logout-card {

    background:
        linear-gradient(
            135deg,
            #fff5f5,
            #fffafa
        );

    border:
        1px solid #f4d4d4;
}


.logout-card .card-icon {

    background:
        #fee8e8;

    color: #d9534f;
}


.logout-card h3 {

    color: #c94040;
}


.logout-card:hover {

    border-color: #e8baba;
}


/* =========================================
   FOOTER
========================================= */

.footer {

    text-align: center;

    margin-top: 45px;

    padding: 22px;

    color: #8290a4;

    font-size: 12px;
}


/* =========================================
   RESPONSIVE
========================================= */

@media(max-width: 1050px) {

    .dashboard {

        grid-template-columns:
            repeat(3, 1fr);
    }

}


@media(max-width: 800px) {

    .main {

        width: 92%;
    }

    .dashboard {

        grid-template-columns:
            repeat(2, 1fr);
    }

    .student-mini span {

        display: none;
    }

}


@media(max-width: 550px) {

    .navbar {

        padding: 0 4%;

        height: 65px;
    }

    .logo {

        font-size: 21px;
    }

    .logout-top {

        padding: 8px 10px;

        font-size: 12px;
    }

    .main {

        width: 92%;

        margin-top: 22px;
    }

    .welcome {

        padding: 25px;

        border-radius: 16px;
    }

    .welcome h1 {

        font-size: 25px;
    }

    .dashboard {

        grid-template-columns: 1fr;
    }

    .card {

        min-height: 125px;
    }

}

</style>

</head>


<body>


<!-- =========================================
     NAVBAR
========================================= -->

<div class="navbar">


    <div class="logo">

        Campus<span>Connect</span>

    </div>


    <div class="nav-right">


        <div class="student-mini">

            <div class="avatar">

                S

            </div>

            <span>
                Student Portal
            </span>

        </div>


        <a
            href="student_logout.jsp"
            class="logout-top">

            Logout

        </a>


    </div>

</div>



<!-- =========================================
     MAIN
========================================= -->

<div class="main">


    <!-- WELCOME -->

    <div class="welcome">

        <div class="welcome-content">

            <small>
                STUDENT PORTAL
            </small>

            <h1>
                Welcome Back, <%= studentName %>
            </h1>

            <p>
                Manage your academic profile,
                skills, projects and complete
                campus recruitment journey
                from one place.
            </p>

        </div>

    </div>



    <!-- =====================================
         PROFILE & ACADEMICS
    ====================================== -->

    <div class="section-header">

        <h2>
            Profile & Academics
        </h2>

        <p>
            Manage your student information
        </p>

    </div>


    <div class="dashboard">


        <div class="card account">

            <div class="card-icon">
                P
            </div>

            <h3>
                My Profile
            </h3>

            <p>
                View and update your personal profile.
            </p>

            <a href="student_profile.jsp">
                My Profile
            </a>

        </div>


        <div class="card">

            <div class="card-icon">
                A
            </div>

            <h3>
                Add Academic Details
            </h3>

            <p>
                Add your academic information.
            </p>

            <a href="student_academic.jsp">
                Add Academic Details
            </a>

        </div>


        <div class="card">

            <div class="card-icon">
                V
            </div>

            <h3>
                View Academic Details
            </h3>

            <p>
                View your saved academic records.
            </p>

            <a href="student_academic_view.jsp">
                View Academic Details
            </a>

        </div>


        <div class="card">

            <div class="card-icon">
                S
            </div>

            <h3>
                Add Skills
            </h3>

            <p>
                Add your technical and professional skills.
            </p>

            <a href="student_skill.jsp">
                Add Skills
            </a>

        </div>


        <div class="card">

            <div class="card-icon">
                V
            </div>

            <h3>
                View Skills
            </h3>

            <p>
                View all your added skills.
            </p>

            <a href="student_skill_view.jsp">
                View Skills
            </a>

        </div>


        <div class="card">

            <div class="card-icon">
                P
            </div>

            <h3>
                Add Project
            </h3>

            <p>
                Add your academic and personal projects.
            </p>

            <a href="student_project.jsp">
                Add Project
            </a>

        </div>


        <div class="card">

            <div class="card-icon">
                V
            </div>

            <h3>
                View Projects
            </h3>

            <p>
                View your existing project records.
            </p>

            <a href="student_project_view.jsp">
                View Projects
            </a>

        </div>


        <div class="card account">

            <div class="card-icon">
                R
            </div>

            <h3>
                Upload Resume
            </h3>

            <p>
                Upload your latest resume.
            </p>

            <a href="student_resume.jsp">
                Upload Resume
            </a>

        </div>


        <div class="card account">

            <div class="card-icon">
                V
            </div>

            <h3>
                View Resume
            </h3>

            <p>
                View your uploaded resume.
            </p>

            <a href="student_resume_view.jsp">
                View Resume
            </a>

        </div>


    </div>



    <!-- =====================================
         PLACEMENT & RECRUITMENT
    ====================================== -->

    <div class="section-header">

        <h2>
            Placement & Recruitment
        </h2>

        <p>
            Explore opportunities and applications
        </p>

    </div>


    <div class="dashboard">


        <div class="card placement">

            <div class="card-icon">
                D
            </div>

            <h3>
                Available Placement Drives
            </h3>

            <p>
                Explore available campus placement drives.
            </p>

            <a href="student_drive_view.jsp">
                Available Placement Drives
            </a>

        </div>


        <div class="card placement">

            <div class="card-icon">
                O
            </div>

            <h3>
                Placement Opportunities
            </h3>

            <p>
                Explore suitable placement opportunities.
            </p>

            <a href="student_placement_opportunities.jsp">
                Placement Opportunities
            </a>

        </div>


        <div class="card recruitment">

            <div class="card-icon">
                A
            </div>

            <h3>
                My Applications
            </h3>

            <p>
                Track your submitted applications.
            </p>

            <a href="student_application_view.jsp">
                My Applications
            </a>

        </div>


        <div class="card recruitment">

            <div class="card-icon">
                I
            </div>

            <h3>
                Interview Details
            </h3>

            <p>
                Check your interview schedules and details.
            </p>

            <a href="student_interview_view.jsp">
                Interview Details
            </a>

        </div>


        <div class="card recruitment">

            <div class="card-icon">
                R
            </div>

            <h3>
                Selection Result
            </h3>

            <p>
                View your recruitment selection results.
            </p>

            <a href="student_selection_view.jsp">
                Selection Result
            </a>

        </div>


        <div class="card account">

            <div class="card-icon">
                N
            </div>

            <h3>
                Notifications
            </h3>

            <p>
                View important college and recruitment updates.
            </p>

            <a href="student_notice_view.jsp">
                Notifications
            </a>

        </div>


        <div class="card logout-card">

            <div class="card-icon">
                X
            </div>

            <h3>
                Logout
            </h3>

            <p>
                Securely sign out from your student portal.
            </p>

            <a href="student_logout.jsp">
                Logout
            </a>

        </div>


    </div>



    <!-- FOOTER -->

    <div class="footer">

        CampusConnect Student Portal

        <br>

        <span>
            Campus Recruitment Management System
        </span>

    </div>


</div>


</body>

</html>