<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String companyName = (String) session.getAttribute("companyName");
    String email = (String) session.getAttribute("email");

    if (companyName == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Company Dashboard | CampusConnect</title>

    <link rel="stylesheet"
          href="css/company-dashboard.css">

</head>

<body>

<div class="dashboard">


    <!-- ================= SIDEBAR ================= -->

    <div class="sidebar">

        <div class="logo">
            CampusConnect
            <span>Company Portal</span>
        </div>


        <div class="menu-title">
            OVERVIEW
        </div>

        <a href="company-dashboard.jsp"
           class="menu active">
            Dashboard
        </a>

        <a href="company-profile.jsp"
           class="menu">
            Company Profile
        </a>


        <div class="menu-title">
            RECRUITMENT
        </div>

        <a href="recruitment-drive.jsp"
           class="menu">
            Create Drive
        </a>

        <a href="view-recruitment-drives.jsp"
           class="menu">
            Recruitment Drives
        </a>

        <a href="company-reports.jsp"
           class="menu">
            Reports &amp; Analytics
        </a>


        <div class="sidebar-bottom">

            <a href="CompanyLogoutServlet"
               class="menu logout">
                Logout
            </a>

        </div>

    </div>


    <!-- ================= MAIN ================= -->

    <div class="main">


        <!-- ================= TOP BAR ================= -->

        <div class="topbar">

            <div>

                <span class="portal-title">
                    COMPANY PORTAL
                </span>

                <h1>
                    Dashboard
                </h1>

            </div>


            <!-- COMPANY PROFILE -->

            <div class="company-info">

                <button class="company-button"
                        onclick="toggleProfile()">

                    <span class="company-details">

                        <strong>
                            <%= companyName %>
                        </strong>

                        <span>
                            <%= email %>
                        </span>

                    </span>

                    <span class="arrow">
                        ▼
                    </span>

                </button>


                <div class="profile-dropdown"
                     id="profileDropdown">

                    <a href="company-profile.jsp">
                        View Profile
                    </a>

                    <a href="CompanyLogoutServlet">
                        Logout
                    </a>

                </div>

            </div>

        </div>


        <!-- ================= CONTENT ================= -->

        <div class="content">


            <!-- ================= WELCOME ================= -->

            <div class="welcome">

                <div class="welcome-content">

                    <span class="welcome-label">
                        COMPANY DASHBOARD
                    </span>

                    <h2>
                        Welcome back, <%= companyName %>
                    </h2>

                    <p>
                        Manage your recruitment activities and connect
                        with talented students across CampusConnect's
                        partner colleges — all from one place.
                    </p>


                    <div class="welcome-buttons">

                        <a href="recruitment-drive.jsp"
                           class="primary-button">
                            + Create Recruitment Drive
                        </a>

                        <a href="view-recruitment-drives.jsp"
                           class="secondary-button">
                            View Drives
                        </a>

                    </div>

                </div>

            </div>


            <!-- ================= QUICK ACTIONS ================= -->

            <div class="section">

                <div class="section-heading">

                    <div>

                        <h2>
                            Quick Actions
                        </h2>

                        <p class="section-text">
                            Jump straight into your most common
                            recruitment tasks
                        </p>

                    </div>

                </div>


                <div class="cards">


                    <!-- PROFILE -->

                    <a href="company-profile.jsp"
                       class="card">

                        <div class="card-icon">
                            ◯
                        </div>

                        <h3>
                            Company Profile
                        </h3>

                        <p>
                            View and update your company details,
                            industry information and contact preferences.
                        </p>

                        <span class="card-link">
                            Open →
                        </span>

                    </a>


                    <!-- CREATE DRIVE -->

                    <a href="recruitment-drive.jsp"
                       class="card">

                        <div class="card-icon">
                            +
                        </div>

                        <h3>
                            Create Recruitment Drive
                        </h3>

                        <p>
                            Set up a new drive with role details,
                            eligibility criteria and application deadlines.
                        </p>

                        <span class="card-link">
                            Open →
                        </span>

                    </a>


                    <!-- DRIVES -->

                    <a href="view-recruitment-drives.jsp"
                       class="card">

                        <div class="card-icon">
                            ☷
                        </div>

                        <h3>
                            Recruitment Drives
                        </h3>

                        <p>
                            Track every drive you've published and
                            review student applications as they arrive.
                        </p>

                        <span class="card-link">
                            Open →
                        </span>

                    </a>


                    <!-- REPORTS -->

                    <a href="company-reports.jsp"
                       class="card">

                        <div class="card-icon">
                            ▥
                        </div>

                        <h3>
                            Reports &amp; Analytics
                        </h3>

                        <p>
                            Review hiring outcomes and drive performance
                            once reporting data is available.
                        </p>

                        <span class="card-link">
                            Open →
                        </span>

                    </a>


                </div>

            </div>


            <!-- ================= ACTIVITY ================= -->

            <div class="section">

                <h2>
                    Recruitment Activity
                </h2>

                <p class="section-text">
                    A live summary of your drives and applicants
                </p>


                <div class="activity">

                    <div class="activity-icon">
                        ~
                    </div>

                    <h3>
                        No activity to show yet
                    </h3>

                    <p>
                        Once you create a recruitment drive,
                        your applicant and shortlisting metrics
                        will appear here automatically.
                    </p>

                </div>

            </div>


        </div>

    </div>

</div>


<!-- ================= PROFILE DROPDOWN ================= -->

<script>

function toggleProfile() {

    var dropdown =
        document.getElementById("profileDropdown");

    dropdown.classList.toggle("show");

}


document.addEventListener("click", function(event) {

    var button =
        document.querySelector(".company-button");

    var dropdown =
        document.getElementById("profileDropdown");


    if (!button.contains(event.target) &&
        !dropdown.contains(event.target)) {

        dropdown.classList.remove("show");

    }

});

</script>


</body>

</html>