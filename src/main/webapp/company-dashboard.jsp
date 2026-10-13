<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,com.campusconnect.util.DBConnection" %>

<%
    // =========================================================
    // GET COMPANY DETAILS FROM SESSION
    // =========================================================

    String companyName = (String) session.getAttribute("companyName");
    String email = (String) session.getAttribute("email");

    String companyLogo = (String) session.getAttribute("companyLogo");
    String companyBanner = (String) session.getAttribute("companyBanner");
    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }


    // =========================================================
    // DEFAULT VALUES
    // =========================================================

    if (companyName == null || companyName.trim().equals("")) {
        companyName = "Company";
    }

    if (email == null) {
        email = "";
    }

    if (companyLogo == null || companyLogo.trim().equals("")) {
        companyLogo = "images/company/tcs-logo.png";
    }

    if (companyBanner == null || companyBanner.trim().equals("")) {
        companyBanner = "images/company/tcs-banner.png";
    }


    // =========================================================
    // COMPANY INITIAL
    // =========================================================

    String companyInitial = companyName.substring(0, 1).toUpperCase();

    int pendingApplications = 0;
    int pendingOffers = 0;
    boolean notificationDataError = false;
    try (Connection connection = DBConnection.getConnection()) {
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT COUNT(*) FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID = A.DRIVE_ID WHERE D.COMPANY_ID = ? AND UPPER(TRIM(A.STATUS)) = 'PENDING'")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) pendingApplications = rs.getInt(1); }
        }
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT COUNT(*) FROM OFFER WHERE COMPANY_ID = ? AND UPPER(TRIM(OFFER_STATUS)) = 'PENDING'")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) pendingOffers = rs.getInt(1); }
        }
    } catch (Exception e) {
        notificationDataError = true;
        application.log("Unable to load company dashboard notifications for companyId=" + companyId, e);
    }
    int actionCount = pendingApplications + pendingOffers;
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <%= companyName %> Dashboard | CampusConnect
    </title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="css/company-dashboard.css?v=10">

    <style>
        .top-header .header-right{gap:18px}
        .topbar-control{position:relative;display:flex;align-items:center}
        .notification-trigger{position:relative;width:42px;height:42px;display:grid;place-items:center;border:0;border-radius:12px;background:transparent;color:#153b63;cursor:pointer;transition:background .18s,color .18s}
        .notification-trigger:hover,.notification-trigger[aria-expanded="true"]{background:#f0f5fc;color:#1769c2}
        .notification-trigger i{font-size:19px}
        .notification-count{position:absolute;top:0;right:-1px;min-width:18px;height:18px;padding:0 4px;display:flex;align-items:center;justify-content:center;border:2px solid #fff;border-radius:12px;background:#e4545d;color:#fff;font-size:10px;font-weight:700;line-height:1}
        .header-divider{height:42px}
        .account-trigger{display:flex;align-items:center;padding:4px 8px;border:0;border-radius:12px;background:transparent;text-align:left;cursor:pointer;transition:background .18s}
        .account-trigger:hover,.account-trigger[aria-expanded="true"]{background:#f5f8fc}
        .profile-arrow{transition:transform .18s;color:#7d8ca1}
        .account-trigger[aria-expanded="true"] .profile-arrow{transform:rotate(180deg)}
        .topbar-menu{position:absolute;z-index:1000;top:calc(100% + 12px);right:0;width:350px;max-width:calc(100vw - 32px);overflow:hidden;border:1px solid #e1e8f1;border-radius:15px;background:#fff;box-shadow:0 18px 48px rgba(20,44,76,.18);animation:menuIn .16s ease-out}
        .topbar-menu[hidden]{display:none!important}
        @keyframes menuIn{from{opacity:0;transform:translateY(-5px)}to{opacity:1;transform:translateY(0)}}
        .menu-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:17px 18px;border-bottom:1px solid #edf1f6}
        .menu-head strong{display:block;color:#153b63;font-size:15px}.menu-head span{display:block;margin-top:3px;color:#8391a5;font-size:12px}
        .menu-head .menu-total{display:grid;place-items:center;min-width:29px;height:29px;padding:0 8px;border-radius:10px;background:#eef4ff;color:#2867cf;font-size:12px;font-weight:700}
        .notification-items{padding:6px 10px;max-height:340px;overflow:auto}
        .notification-item{display:flex;align-items:flex-start;gap:12px;padding:12px 9px;border-radius:10px;text-decoration:none;transition:background .16s}
        .notification-item:hover{background:#f6f9fd}
        .notification-icon{width:36px;height:36px;flex:0 0 36px;display:grid;place-items:center;border-radius:11px;background:#edf4ff;color:#2867cf}
        .notification-icon.offer{background:#fff4df;color:#bc7b08}.notification-icon.drive{background:#e8f7ef;color:#17834c}
        .notification-copy{min-width:0;flex:1}.notification-copy strong{display:block;color:#304967;font-size:13px}.notification-copy span{display:block;margin-top:4px;color:#8291a6;font-size:12px;line-height:1.45}.notification-copy b{color:#153b63}
        .notification-chevron{margin:11px 2px 0 auto;color:#a5b1c0;font-size:11px}
        .notification-empty{padding:29px 18px;text-align:center;color:#7e8da2}.notification-empty i{display:block;margin-bottom:10px;color:#25a36f;font-size:24px}.notification-empty strong{display:block;color:#304967;font-size:14px}.notification-empty span{display:block;margin-top:5px;font-size:12px}
        .menu-footer{padding:12px 18px;border-top:1px solid #edf1f6;background:#fbfcfe}.menu-footer a{color:#2867cf;text-decoration:none;font-size:12px;font-weight:700}.menu-footer a:hover{text-decoration:underline}
        .account-menu{width:270px;padding:8px}
        .account-menu-summary{display:flex;align-items:center;gap:11px;padding:11px 10px 14px;border-bottom:1px solid #edf1f6;margin-bottom:6px}
        .account-menu-summary .profile-circle{width:42px;height:42px;flex:0 0 42px}
        .account-menu-summary strong{display:block;max-width:175px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:#203f62;font-size:13px}
        .account-menu-summary span{display:block;max-width:175px;margin-top:3px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:#8794a7;font-size:11px}
        .account-menu-link{display:flex;align-items:center;gap:11px;padding:10px;border-radius:9px;color:#405773;text-decoration:none;font-size:13px;font-weight:600;transition:background .15s,color .15s}
        .account-menu-link i{width:17px;text-align:center;color:#8394aa}.account-menu-link:hover{background:#f4f7fb;color:#2065c6}.account-menu-link.logout{margin-top:5px;border-top:1px solid #edf1f6;border-radius:0 0 9px 9px;padding-top:14px;color:#c84c55}.account-menu-link.logout i{color:#c84c55}
        @media(max-width:600px){.topbar-menu{right:-8px;width:320px}.top-header .header-right{gap:8px}.profile-info{display:none}.account-trigger{gap:7px}.header-divider{margin:0 3px}}
    </style>

</head>


<body>


<!-- =========================================================
     MAIN WRAPPER
     ========================================================= -->

<div class="dashboard-wrapper">


    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">


        <!-- BRAND -->
        <div class="sidebar-logo">

            <div class="brand-name">
                Campus<span>Connect</span>
            </div>

            <div class="brand-subtitle">
                COMPANY PORTAL
            </div>

        </div>


        <!-- SIDEBAR CONTENT -->

        <div class="sidebar-content">


            <!-- ================= OVERVIEW ================= -->

            <div class="menu-section-title">
                OVERVIEW
            </div>


            <a href="company-dashboard.jsp"
               class="menu-item active">

                <i class="fa-solid fa-house"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a href="company-profile.jsp"
               class="menu-item">

                <i class="fa-solid fa-building"></i>

                <span>
                    Company Profile
                </span>

            </a>


            <!-- ================= RECRUITMENT ================= -->

            <div class="menu-section-title">
                RECRUITMENT
            </div>


            <a href="recruitment-drive.jsp"
               class="menu-item">

                <i class="fa-solid fa-plus"></i>

                <span>
                    Create Drive
                </span>

            </a>


            <a href="view-recruitment-drives.jsp"
               class="menu-item">

                <i class="fa-solid fa-briefcase"></i>

                <span>
                    Recruitment Drives
                </span>

            </a>


            <a href="company-applicants.jsp"
               class="menu-item">

                <i class="fa-solid fa-users"></i>

                <span>
                    Applicants
                </span>

            </a>


            <a href="company-shortlisted.jsp"
               class="menu-item">

                <i class="fa-solid fa-star"></i>

                <span>
                    Shortlisted Candidates
                </span>

            </a>


            <a href="company-interviews.jsp"
               class="menu-item">

                <i class="fa-regular fa-square"></i>

                <span>
                    Interviews
                </span>

            </a>


            <a href="company-offers.jsp"
               class="menu-item">

                <i class="fa-regular fa-gem"></i>

                <span>
                    Offers &amp; Selections
                </span>

            </a>


            <!-- ================= ANALYTICS ================= -->

            <div class="menu-section-title">
                ANALYTICS
            </div>


            <a href="company-reports.jsp"
               class="menu-item">

                <i class="fa-solid fa-chart-column"></i>

                <span>
                    Reports &amp; Analytics
                </span>

            </a>


            <a href="company-analytics.jsp"
               class="menu-item">

                <i class="fa-solid fa-chart-line"></i>

                <span>
                    Analytics Insights
                </span>

            </a>


        </div>


        <!-- ================= BOTTOM MENU ================= -->

        <div class="sidebar-bottom">


            <a href="company-settings.jsp"
               class="menu-item">

                <i class="fa-solid fa-gear"></i>

                <span>
                    Settings
                </span>

            </a>


            <a href="CompanyLogoutServlet"
               class="menu-item logout">

                <i class="fa-solid fa-right-from-bracket"></i>

                <span>
                    Logout
                </span>

            </a>


        </div>


    </aside>



    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main-content">


        <!-- =================================================
             TOP HEADER
             ================================================= -->

        <header class="top-header">


            <!-- PAGE TITLE -->

            <div class="page-title">

                <div class="portal-label">
                    COMPANY PORTAL
                </div>

                <h1>
                    Dashboard
                </h1>

            </div>


            <!-- HEADER RIGHT -->

            <div class="header-right">


                <!-- NOTIFICATION -->

                <div class="topbar-control">
                    <button type="button" class="notification-trigger" id="notificationButton" aria-label="Notifications<%= actionCount > 0 ? ", " + actionCount + " items need attention" : "" %>" aria-haspopup="true" aria-expanded="false" aria-controls="notificationMenu">
                        <i class="fa-regular fa-bell" aria-hidden="true"></i>
                        <% if (actionCount > 0) { %><span class="notification-count"><%= actionCount > 99 ? "99+" : String.valueOf(actionCount) %></span><% } %>
                    </button>
                    <div class="topbar-menu" id="notificationMenu" role="dialog" aria-label="Company notifications" hidden>
                        <div class="menu-head"><div><strong>Needs attention</strong><span>Current activity for <%= companyName %></span></div><span class="menu-total"><%= actionCount %></span></div>
                        <% if (notificationDataError) { %>
                            <div class="notification-empty"><i class="fa-solid fa-circle-exclamation" style="color:#d89122"></i><strong>Activity is unavailable</strong><span>Refresh the page to try again.</span></div>
                        <% } else if (actionCount == 0) { %>
                            <div class="notification-empty"><i class="fa-regular fa-circle-check"></i><strong>You're all caught up</strong><span>No pending applications or offers need attention.</span></div>
                        <% } else { %>
                            <div class="notification-items">
                                <% if (pendingApplications > 0) { %>
                                <a class="notification-item" href="company-applicants.jsp"><span class="notification-icon"><i class="fa-solid fa-users"></i></span><span class="notification-copy"><strong>Applications to review</strong><span><b><%= pendingApplications %></b> application<%= pendingApplications == 1 ? "" : "s" %> have PENDING company status.</span></span><i class="fa-solid fa-chevron-right notification-chevron"></i></a>
                                <% } %>
                                <% if (pendingOffers > 0) { %>
                                <a class="notification-item" href="company-offers.jsp"><span class="notification-icon offer"><i class="fa-regular fa-gem"></i></span><span class="notification-copy"><strong>Offers awaiting response</strong><span><b><%= pendingOffers %></b> offer<%= pendingOffers == 1 ? " is" : "s are" %> marked PENDING.</span></span><i class="fa-solid fa-chevron-right notification-chevron"></i></a>
                                <% } %>
                            </div>
                        <% } %>
                        <div class="menu-footer"><a href="company-reports.jsp">View recruitment reports <i class="fa-solid fa-arrow-right"></i></a></div>
                    </div>
                </div>


                <div class="header-divider"></div>


                <!-- COMPANY ACCOUNT -->

                <div class="topbar-control">
                <button type="button" class="company-account account-trigger" id="accountButton" aria-label="Company account menu" aria-haspopup="true" aria-expanded="false" aria-controls="accountMenu">


                    <!-- INITIAL CIRCLE -->

                    <span class="profile-circle">

                        <%= companyInitial %>

                    </span>


                    <!-- COMPANY DETAILS -->

                    <span class="profile-info">

                        <strong>
                            <%= companyName %>
                        </strong>

                        <span>
                            <%= email %>
                        </span>

                    </span>


                    <span class="profile-arrow">
                        ⌄
                    </span>


                </button>
                <div class="topbar-menu account-menu" id="accountMenu" role="menu" aria-label="Company account menu" hidden>
                    <div class="account-menu-summary"><div class="profile-circle"><%= companyInitial %></div><div><strong><%= companyName %></strong><span><%= email %></span></div></div>
                    <a class="account-menu-link" href="company-profile.jsp" role="menuitem"><i class="fa-solid fa-building"></i> Company profile</a>
                    <a class="account-menu-link" href="company-settings.jsp" role="menuitem"><i class="fa-solid fa-gear"></i> Settings</a>
                    <a class="account-menu-link logout" href="CompanyLogoutServlet" role="menuitem"><i class="fa-solid fa-right-from-bracket"></i> Log out</a>
                </div>
                </div>


            </div>


        </header>



        <!-- =================================================
             PAGE BODY
             ================================================= -->

        <div class="page-body">


            <!-- =================================================
                 HERO BANNER
                 ================================================= -->

            <section class="hero-banner">


                <!-- RIGHT SIDE COMPANY IMAGE -->

                <div class="hero-image">

                    <img src="<%= companyBanner %>"
                         alt="<%= companyName %> Banner">

                    <div class="image-overlay"></div>

                </div>


                <!-- HERO CONTENT -->

                <div class="hero-left">


                    <!-- COMPANY LOGO -->

                    <div class="hero-logo">

                        <img src="<%= companyLogo %>"
                             alt="<%= companyName %> Logo">

                    </div>


                    <!-- HERO TEXT -->

                    <div class="hero-content">


                        <div class="hero-small-title">

                            GOOD TO SEE YOU AGAIN,

                        </div>


                        <h2>

                            Welcome back,
                            <%= companyName %>

                            <span class="wave">
                                👋
                            </span>

                        </h2>


                        <p>

                            Together let's build the next generation
                            of talent. Hire. Engage. Grow. Partner with
                            top talent from leading campuses across India,
                            all in one place.

                        </p>


                        <!-- BUTTONS -->

                        <div class="hero-buttons">


                            <a href="recruitment-drive.jsp"
                               class="hero-btn primary-btn">

                                <span>＋</span>

                                Create Recruitment Drive

                            </a>


                            <a href="view-recruitment-drives.jsp"
                               class="hero-btn secondary-btn">

                                View All Drives

                            </a>


                        </div>


                    </div>


                </div>


                <!-- =================================================
                     HERO FEATURES
                     ================================================= -->

                <div class="hero-features">


                    <!-- HIRE -->

                    <div class="feature-item">

                        <div class="feature-icon">
                            ♟
                        </div>

                        <div>

                            <strong>
                                Hire
                            </strong>

                            <span>
                                Top Talent
                            </span>

                        </div>

                    </div>


                    <!-- BUILD -->

                    <div class="feature-item">

                        <div class="feature-icon">
                            ◈
                        </div>

                        <div>

                            <strong>
                                Build
                            </strong>

                            <span>
                                Stronger Teams
                            </span>

                        </div>

                    </div>


                    <!-- SHAPE -->

                    <div class="feature-item">

                        <div class="feature-icon">
                            ▥
                        </div>

                        <div>

                            <strong>
                                Shape
                            </strong>

                            <span>
                                A Better Tomorrow
                            </span>

                        </div>

                    </div>


                </div>


                <!-- =================================================
                     COMPANY QUOTE
                     ================================================= -->

                <div class="hero-quote">

                    <p>

                        "Building a more inclusive,
                        sustainable and brighter future
                        through the power of people."

                    </p>

                    <strong>

                        — <%= companyName %>

                    </strong>

                </div>


            </section>



            <!-- =================================================
                 STATISTICS
                 ================================================= -->

            <section class="stats-grid">


                <!-- TOTAL DRIVES -->

                <div class="stat-card">


                    <div class="stat-icon blue">
                        ♟
                    </div>


                    <div class="stat-info">

                        <strong>
                            0
                        </strong>

                        <span>
                            Total Drives
                        </span>

                    </div>


                    <a href="view-recruitment-drives.jsp">

                        View all →

                    </a>


                </div>



                <!-- APPLICATIONS -->

                <div class="stat-card">


                    <div class="stat-icon blue">
                        ▤
                    </div>


                    <div class="stat-info">

                        <strong>
                            0
                        </strong>

                        <span>
                            Total Applications
                        </span>

                    </div>


                    <a href="company-applicants.jsp">

                        View all →

                    </a>


                </div>



                <!-- INTERVIEWS -->

                <div class="stat-card">


                    <div class="stat-icon blue">
                        ◷
                    </div>


                    <div class="stat-info">

                        <strong>
                            0
                        </strong>

                        <span>
                            Interviews Scheduled
                        </span>

                    </div>


                    <a href="company-interviews.jsp">

                        View all →

                    </a>


                </div>



                <!-- OFFERS -->

                <div class="stat-card">


                    <div class="stat-icon green">
                        ✓
                    </div>


                    <div class="stat-info">

                        <strong>
                            0
                        </strong>

                        <span>
                            Offers Made
                        </span>

                    </div>


                    <a href="company-offers.jsp">

                        View all →

                    </a>


                </div>


            </section>



            <!-- =================================================
                 QUICK ACTIONS
                 ================================================= -->

            <section class="quick-actions">


                <div class="section-heading">

                    <h2>
                        Quick Actions
                    </h2>

                    <p>
                        Jump straight into your most common
                        recruitment tasks
                    </p>

                </div>


                <div class="quick-grid">


                    <!-- COMPANY PROFILE -->

                    <div class="quick-card">


                        <div class="quick-icon">
                            ▦
                        </div>


                        <div class="quick-content">

                            <h3>
                                Company Profile
                            </h3>

                            <p>

                                View and update your company
                                details, industry information
                                and contact preferences.

                            </p>

                            <a href="company-profile.jsp">

                                Open →

                            </a>

                        </div>


                    </div>



                    <!-- CREATE DRIVE -->

                    <div class="quick-card">


                        <div class="quick-icon">
                            ＋
                        </div>


                        <div class="quick-content">

                            <h3>
                                Create Recruitment Drive
                            </h3>

                            <p>

                                Set up a new drive with role
                                details, eligibility criteria
                                and application deadlines.

                            </p>

                            <a href="recruitment-drive.jsp">

                                Open →

                            </a>

                        </div>


                    </div>



                    <!-- RECRUITMENT DRIVES -->

                    <div class="quick-card">


                        <div class="quick-icon">
                            ☷
                        </div>


                        <div class="quick-content">

                            <h3>
                                Recruitment Drives
                            </h3>

                            <p>

                                Track every drive you've
                                published and review student
                                applications as they arrive.

                            </p>

                            <a href="view-recruitment-drives.jsp">

                                Open →

                            </a>

                        </div>


                    </div>



                    <!-- REPORTS -->

                    <div class="quick-card">


                        <div class="quick-icon">
                            ▥
                        </div>


                        <div class="quick-content">

                            <h3>
                                Reports &amp; Analytics
                            </h3>

                            <p>

                                Review hiring outcomes, drive
                                performance and gain insights
                                with detailed reports.

                            </p>

                            <a href="company-reports.jsp">

                                Open →

                            </a>

                        </div>


                    </div>


                </div>


            </section>



            <!-- =================================================
                 RECRUITMENT ACTIVITY
                 ================================================= -->

            <section class="activity-section">


                <div class="section-heading">

                    <h2>
                        Recruitment Activity
                    </h2>

                    <p>
                        A live summary of your drives and applicants
                    </p>

                </div>


                <div class="activity-box">


                    <div class="activity-empty">


                        <i>
                            ▤
                        </i>


                        <h3>
                            No recruitment activity yet
                        </h3>


                        <p>

                            Create your first recruitment drive
                            to start tracking activity.

                        </p>


                        <a href="recruitment-drive.jsp"
                           class="activity-button">

                            ＋ Create Recruitment Drive

                        </a>


                    </div>


                </div>


            </section>


        </div>


    </main>


</div>

<script>
(function () {
    var controls = [
        { button: document.getElementById("notificationButton"), menu: document.getElementById("notificationMenu") },
        { button: document.getElementById("accountButton"), menu: document.getElementById("accountMenu") }
    ];
    function closeAll(except) {
        controls.forEach(function (control) {
            if (control !== except) {
                control.menu.hidden = true;
                control.button.setAttribute("aria-expanded", "false");
            }
        });
    }
    controls.forEach(function (control) {
        control.button.addEventListener("click", function (event) {
            event.stopPropagation();
            var shouldOpen = control.menu.hidden;
            closeAll(control);
            control.menu.hidden = !shouldOpen;
            control.button.setAttribute("aria-expanded", String(shouldOpen));
        });
        control.menu.addEventListener("click", function (event) { event.stopPropagation(); });
    });
    document.addEventListener("click", function () { closeAll(null); });
    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeAll(null);
            var focused = controls.filter(function (control) { return document.activeElement === control.button; })[0];
            if (focused) focused.button.focus();
        }
    });
}());
</script>


</body>

</html>
