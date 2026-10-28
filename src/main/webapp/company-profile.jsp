<%@ page import="com.campusconnect.bean.Company" %>

<%
    // =========================================================
    // COMPANY SESSION CHECK
    // =========================================================

    Integer companyId =
            (Integer) session.getAttribute("companyId");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }


    // =========================================================
    // LOAD COMPANY
    // =========================================================

    Company c = new Company();

    c.setCompanyId(companyId);

    boolean result = c.SelectMethod();


    // =========================================================
    // COMPANY LOGO
    // =========================================================

    String companyLogo = c.getLogoUrl();
    if (companyLogo != null) {
        companyLogo = companyLogo.trim();
    }

    boolean useNameBasedFallback =
            companyLogo == null || companyLogo.isEmpty();

    if (!useNameBasedFallback) {
        String normalizedLogoPath = companyLogo
                .replace('\\', '/')
                .toLowerCase(java.util.Locale.ROOT);
        useNameBasedFallback =
                normalizedLogoPath.equals("images/company/tcs-logo.png") ||
                normalizedLogoPath.endsWith("/images/company/tcs-logo.png");
    }

    if (useNameBasedFallback) {
        String companyLogoName = c.getCompanyName() == null
                ? ""
                : c.getCompanyName().trim().toLowerCase(java.util.Locale.ROOT);

        if (companyLogoName.contains("infosys")) {
            companyLogo = "images/company/infosys-logo.png";
        } else if (companyLogoName.contains("google")) {
            companyLogo = "images/company/google-logo.png";
        } else if (companyLogoName.contains("tcs") ||
                companyLogoName.contains("tata consultancy")) {
            companyLogo = "images/company/tcs-logo.png";
        } else {
            companyLogo = "images/company/tcs-logo.png";
        }
    }

    // Prefix application-relative paths with the current web context.
    // Leave absolute HTTP(S) and scheme-relative URLs unchanged.
    if (!companyLogo.matches("(?i)^(https?:)?//.*$")) {
        String contextPath = request.getContextPath();

        if (!companyLogo.equals(contextPath) &&
                !companyLogo.startsWith(contextPath + "/")) {
            if (companyLogo.startsWith("/")) {
                companyLogo = contextPath + companyLogo;
            } else {
                companyLogo = contextPath + "/" + companyLogo;
            }
        }
    }
%>


<!DOCTYPE html>

<html lang="en">


<head>


    <meta charset="UTF-8">


    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


    <title>
        Company Profile | CampusConnect
    </title>


    <!-- =====================================================
         FONT AWESOME
         SAME ICON STYLE AS DASHBOARD
         ===================================================== -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <style>


        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        html {
            scroll-behavior: smooth;
        }


        body {

            font-family:
                Arial,
                Helvetica,
                sans-serif;

            background: #f4f7fb;

            color: #092d52;

            overflow-x: hidden;
        }


        a {
            text-decoration: none;

            color: inherit;
        }


        /* =====================================================
           MAIN WRAPPER
           EXACT DASHBOARD STRUCTURE
           ===================================================== */

        .dashboard-wrapper {

            display: flex;

            min-height: 100vh;

            width: 100%;
        }


        /* =====================================================
           SIDEBAR
           EXACT ORIGINAL DASHBOARD VALUES
           ===================================================== */

        .sidebar {

            width: 285px;

            min-width: 285px;

            height: 100vh;

            position: fixed;

            left: 0;

            top: 0;

            background:
                linear-gradient(
                    180deg,
                    #092f55 0%,
                    #062847 100%
                );

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 1000;

            overflow-y: auto;
        }


        /* SAME SCROLLBAR AS DASHBOARD */

        .sidebar::-webkit-scrollbar {

            width: 4px;
        }


        .sidebar::-webkit-scrollbar-thumb {

            background:
                rgba(255,255,255,0.2);
        }


        /* =====================================================
           SIDEBAR LOGO
           EXACT DASHBOARD VALUES
           ===================================================== */

        .sidebar-logo {

            padding:
                30px 26px 25px;

            margin:
                0 16px;

            border-bottom:
                1px solid
                rgba(255,255,255,0.15);
        }


        .brand-name {

            font-size: 25px;

            font-weight: 800;

            letter-spacing: -1px;

            color: #ffffff;
        }


        .brand-name span {

            color: #2e8bf0;
        }


        .brand-subtitle {

            margin-top: 8px;

            font-size: 13px;

            font-weight: 700;

            letter-spacing: 1.2px;

            color: #4da2ff;
        }


        /* =====================================================
           SIDEBAR CONTENT
           EXACT DASHBOARD VALUES
           ===================================================== */

        .sidebar-content {

            padding:
                24px 16px;

            flex: 1;
        }


        .menu-section-title {

            margin:
                0 10px 10px;

            font-size: 12px;

            font-weight: 800;

            letter-spacing: 1px;

            color: #42a0f5;
        }


        .menu-section-title:not(:first-child) {

            margin-top: 22px;
        }


        /* =====================================================
           MENU ITEM
           EXACT DASHBOARD VALUES
           ===================================================== */

        .menu-item {

            min-height: 48px;

            padding:
                0 15px;

            margin-bottom: 5px;

            border-radius: 9px;

            display: flex;

            align-items: center;

            gap: 17px;

            font-size: 16px;

            font-weight: 600;

            color: #edf5ff;

            transition:
                background 0.2s ease,
                transform 0.2s ease;
        }


        .menu-item i {

            width: 22px;

            text-align: center;

            font-size: 18px;

            color: #e9f3ff;
        }


        .menu-item:hover {

            background:
                rgba(49,139,238,0.22);
        }


        /* =====================================================
           ACTIVE ITEM
           EXACT DASHBOARD BLUE
           ===================================================== */

        .menu-item.active {

            background:
                linear-gradient(
                    90deg,
                    #2683e9,
                    #347fce
                );

            box-shadow:
                0 5px 15px
                rgba(0,0,0,0.12);
        }


        .menu-item.active i {

            color: white;
        }


        /* =====================================================
           SIDEBAR BOTTOM
           EXACT DASHBOARD VALUES
           ===================================================== */

        .sidebar-bottom {

            padding:
                10px 16px 25px;

            border-top:
                1px solid
                rgba(255,255,255,0.15);
        }


        .sidebar-bottom .menu-item {

            margin-bottom: 3px;
        }


        .menu-item.logout {

            color: #ff7d7d;
        }


        .menu-item.logout i {

            color: #ff7d7d;
        }


        /* =====================================================
           MAIN CONTENT
           EXACT DASHBOARD WIDTH
           ===================================================== */

        .main-content {

            margin-left: 285px;

            width:
                calc(100% - 285px);

            min-height: 100vh;

            background: #f5f8fc;
        }


        /* =====================================================
           PROFILE TOP HEADER
           ===================================================== */

        .top-header {

            height: 128px;

            background: white;

            border-bottom:
                1px solid #e2e9f1;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding:
                0 38px;
        }


        .page-title h1 {

            font-size: 32px;

            line-height: 1.1;

            color: #092e52;

            font-weight: 800;
        }


        .page-title p {

            margin-top: 8px;

            color: #6b82a0;

            font-size: 15px;
        }


        .back-dashboard {

            color: #0878ed;

            font-size: 15px;

            font-weight: 700;
        }


        .back-dashboard:hover {

            text-decoration: underline;
        }


        /* =====================================================
           PAGE BODY
           ===================================================== */

        .page-body {

            padding:
                28px 32px 50px;
        }


        /* =====================================================
           COMPANY HERO
           ===================================================== */

        .company-hero {

            width: 100%;

            min-height: 200px;

            border-radius: 18px;

            overflow: hidden;

            position: relative;

            background:
                linear-gradient(
                    90deg,
                    #11589a 0%,
                    #176aa9 46%,
                    #1c7ab9 100%
                );

            box-shadow:
                0 8px 25px
                rgba(13,61,105,0.12);

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding:
                35px 40px;
        }


        .company-identity {

            display: flex;

            align-items: center;

            gap: 24px;

            position: relative;

            z-index: 5;
        }


        .logo-container {

            width: 108px;

            height: 108px;

            background: white;

            border-radius: 15px;

            display: flex;

            align-items: center;

            justify-content: center;

            box-shadow:
                0 5px 15px
                rgba(0,0,0,0.15);

            flex-shrink: 0;
        }


        .company-logo {

            width: 82px;

            height: 82px;

            object-fit: contain;

            display: block;
        }


        .company-name {

            color: white;

            font-size: 35px;

            font-weight: 800;

            margin-bottom: 8px;
        }


        .company-email {

            color: #f2f8ff;

            font-size: 15px;
        }


        .hero-status {

            position: relative;

            z-index: 5;

            padding:
                10px 23px;

            border:
                1px solid
                rgba(255,255,255,0.5);

            border-radius: 25px;

            color: white;

            font-size: 14px;

            font-weight: 800;

            text-transform: uppercase;
        }


        /* =====================================================
           CONTENT GRID
           ===================================================== */

        .content-grid {

            display: grid;

            grid-template-columns:
                minmax(0, 2fr)
                minmax(280px, 1fr);

            gap: 30px;

            margin-top: 30px;

            align-items: start;
        }


        /* =====================================================
           CARD
           ===================================================== */

        .card {

            background: white;

            border:
                1px solid #e3eaf2;

            border-radius: 14px;

            box-shadow:
                0 8px 25px
                rgba(24,55,90,0.06);

            overflow: hidden;
        }


        .card-header {

            padding:
                27px 30px;

            border-bottom:
                1px solid #e7edf4;
        }


        .card-header h2 {

            margin: 0;

            font-size: 24px;

            color: #103b68;
        }


        .card-header p {

            margin:
                7px 0 0;

            color: #7085a1;

            font-size: 14px;
        }


        /* =====================================================
           DETAILS
           ===================================================== */

        .details {

            padding:
                10px 30px 25px;
        }


        .detail-row {

            min-height: 68px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 25px;

            border-bottom:
                1px solid #edf1f5;
        }


        .detail-row:last-child {

            border-bottom: none;
        }


        .detail-label {

            color: #5d7899;

            font-size: 14px;

            font-weight: 700;
        }


        .detail-value {

            color: #123f6d;

            font-size: 15px;

            text-align: right;

            word-break: break-word;
        }


        .website {

            color: #087cf0;

            text-decoration: none;
        }


        .website:hover {

            text-decoration: underline;
        }


        /* =====================================================
           SIDE CARD
           ===================================================== */

        .side-card {

            margin-bottom: 30px;
        }


        .side-content {

            padding:
                27px 30px;
        }


        .status-label {

            color: #7187a2;

            font-size: 14px;

            margin-bottom: 11px;
        }


        .status-badge {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            background: #e8f8ef;

            color: #087a45;

            border-radius: 25px;

            padding:
                9px 15px;

            font-weight: 700;

            font-size: 13px;
        }


        .status-dot {

            width: 8px;

            height: 8px;

            background: #16b86a;

            border-radius: 50%;
        }


        .company-id-section {

            margin-top: 28px;

            padding-top: 24px;

            border-top:
                1px solid #e8edf2;
        }


        .company-id-label {

            color: #7187a2;

            font-size: 14px;

            margin-bottom: 5px;
        }


        .company-id {

            font-size: 20px;

            font-weight: 800;

            color: #103b68;
        }


        /* =====================================================
           PROFILE SETTINGS
           ===================================================== */

        .settings-text {

            color: #6c829f;

            line-height: 1.7;

            font-size: 14px;

            margin-bottom: 23px;
        }


        .edit-button {

            display: block;

            width: 100%;

            text-align: center;

            background: #087cf0;

            color: white;

            padding: 13px 20px;

            border-radius: 9px;

            font-weight: 700;

            font-size: 15px;

            transition: 0.2s;
        }


        .edit-button:hover {

            background: #066fd8;
        }


        .dashboard-button {

            display: block;

            width: 100%;

            text-align: center;

            background: white;

            color: #087cf0;

            border:
                1px solid #087cf0;

            padding: 12px 20px;

            border-radius: 9px;

            font-weight: 700;

            font-size: 15px;

            margin-top: 12px;

            transition: 0.2s;
        }


        .dashboard-button:hover {

            background: #f0f7ff;
        }


        /* =====================================================
           RESPONSIVE
           SAME BREAKPOINTS AS DASHBOARD
           ===================================================== */

        @media (max-width: 1400px) {

            .sidebar {

                width: 255px;

                min-width: 255px;
            }


            .main-content {

                margin-left: 255px;

                width:
                    calc(100% - 255px);
            }
        }


        @media (max-width: 900px) {

            .sidebar {

                width: 220px;

                min-width: 220px;
            }


            .main-content {

                margin-left: 220px;

                width:
                    calc(100% - 220px);
            }


            .page-body {

                padding: 20px;
            }


            .content-grid {

                grid-template-columns: 1fr;
            }
        }


        @media (max-width: 700px) {

            .sidebar {

                position: relative;

                width: 100%;

                min-width: 100%;

                height: auto;
            }


            .dashboard-wrapper {

                flex-direction: column;
            }


            .main-content {

                margin-left: 0;

                width: 100%;
            }


            .top-header {

                height: auto;

                padding: 20px;

                gap: 20px;

                align-items: flex-start;

                flex-direction: column;
            }


            .company-hero {

                align-items: flex-start;

                flex-direction: column;

                gap: 25px;

                padding: 28px;
            }


            .detail-row {

                flex-direction: column;

                align-items: flex-start;

                justify-content: center;

                padding: 15px 0;

                gap: 7px;
            }


            .detail-value {

                text-align: left;
            }
        }


    </style>


</head>



<body>


<div class="dashboard-wrapper">


    <!-- =====================================================
         SIDEBAR
         EXACT SAME AS DASHBOARD
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



            <!-- DASHBOARD -->

            <a href="company-dashboard.jsp"
               class="menu-item">


                <i class="fa-solid fa-house"></i>


                <span>

                    Dashboard

                </span>


            </a>



            <!-- COMPANY PROFILE -->

            <a href="company-profile.jsp"
               class="menu-item active">


                <i class="fa-solid fa-building"></i>


                <span>

                    Company Profile

                </span>


            </a>



            <!-- ================= RECRUITMENT ================= -->


            <div class="menu-section-title">

                RECRUITMENT

            </div>



            <!-- CREATE DRIVE -->

            <a href="recruitment-drive.jsp"
               class="menu-item">


                <i class="fa-solid fa-plus"></i>


                <span>

                    Create Drive

                </span>


            </a>



            <!-- RECRUITMENT DRIVES -->

            <a href="view-recruitment-drives.jsp"
               class="menu-item">


                <i class="fa-solid fa-briefcase"></i>


                <span>

                    Recruitment Drives

                </span>


            </a>



            <!-- APPLICANTS -->

            <a href="company-applicants.jsp"
               class="menu-item">


                <i class="fa-solid fa-users"></i>


                <span>

                    Applicants

                </span>


            </a>



            <!-- SHORTLISTED -->

            <a href="company-shortlisted.jsp"
               class="menu-item">


                <i class="fa-solid fa-star"></i>


                <span>

                    Shortlisted Candidates

                </span>


            </a>



            <!-- INTERVIEWS -->

            <a href="company-interviews.jsp"
               class="menu-item">


                <i class="fa-regular fa-square"></i>


                <span>

                    Interviews

                </span>


            </a>



            <!-- OFFERS -->

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



            <!-- REPORTS -->

            <a href="company-reports.jsp"
               class="menu-item">


                <i class="fa-solid fa-chart-column"></i>


                <span>

                    Reports &amp; Analytics

                </span>


            </a>



            <!-- ANALYTICS -->

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


            <!-- SETTINGS -->

            <a href="company-settings.jsp"
               class="menu-item">


                <i class="fa-solid fa-gear"></i>


                <span>

                    Settings

                </span>


            </a>



            <!-- LOGOUT -->

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


<%
    if (result) {
%>


        <!-- =================================================
             TOP HEADER
             ================================================= -->

        <header class="top-header">


            <div class="page-title">


                <h1>

                    Company Profile

                </h1>


                <p>

                    Manage your company identity and account information

                </p>


            </div>



            <a href="company-dashboard.jsp"
               class="back-dashboard">

                Back to Dashboard

            </a>


        </header>



        <!-- =================================================
             PAGE BODY
             ================================================= -->

        <div class="page-body">


            <!-- =================================================
                 COMPANY HERO
                 ================================================= -->

            <section class="company-hero">


                <div class="company-identity">


                    <div class="logo-container">


                        <img
                            src="<%= companyLogo %>"
                            alt="<%= c.getCompanyName() %> Logo"
                            class="company-logo"
                        >


                    </div>



                    <div>


                        <div class="company-name">

                            <%= c.getCompanyName() %>

                        </div>


                        <div class="company-email">

                            <%= c.getEmail() %>

                        </div>


                    </div>


                </div>



                <div class="hero-status">

                    <%= c.getStatus() %>

                </div>


            </section>



            <!-- =================================================
                 CONTENT GRID
                 ================================================= -->

            <div class="content-grid">


                <!-- =============================================
                     COMPANY INFORMATION
                     ============================================= -->

                <div class="card">


                    <div class="card-header">


                        <h2>

                            Company Information

                        </h2>


                        <p>

                            Your registered company details

                        </p>


                    </div>



                    <div class="details">


                        <!-- COMPANY NAME -->

                        <div class="detail-row">


                            <div class="detail-label">

                                Company Name

                            </div>


                            <div class="detail-value">

                                <%= c.getCompanyName() %>

                            </div>


                        </div>



                        <!-- EMAIL -->

                        <div class="detail-row">


                            <div class="detail-label">

                                Email Address

                            </div>


                            <div class="detail-value">

                                <%= c.getEmail() %>

                            </div>


                        </div>



                        <!-- PHONE -->

                        <div class="detail-row">


                            <div class="detail-label">

                                Phone Number

                            </div>


                            <div class="detail-value">

                                <%= c.getPhone() %>

                            </div>


                        </div>



                        <!-- WEBSITE -->

                        <div class="detail-row">


                            <div class="detail-label">

                                Official Website

                            </div>


                            <div class="detail-value">


                                <a
                                    href="<%= c.getWebsite() %>"
                                    target="_blank"
                                    class="website"
                                >

                                    <%= c.getWebsite() %>

                                </a>


                            </div>


                        </div>



                        <!-- ADDRESS -->

                        <div class="detail-row">


                            <div class="detail-label">

                                Company Address

                            </div>


                            <div class="detail-value">

                                <%= c.getAddress() %>

                            </div>


                        </div>


                    </div>


                </div>



                <!-- =============================================
                     RIGHT SIDE
                     ============================================= -->

                <div>


                    <!-- ACCOUNT OVERVIEW -->

                    <div class="card side-card">


                        <div class="card-header">


                            <h2>

                                Account Overview

                            </h2>


                            <p>

                                Current account information

                            </p>


                        </div>



                        <div class="side-content">


                            <div class="status-label">

                                Account Status

                            </div>



                            <div class="status-badge">


                                <span class="status-dot"></span>


                                <%= c.getStatus() %>


                            </div>



                            <div class="company-id-section">


                                <div class="company-id-label">

                                    Company ID

                                </div>


                                <div class="company-id">

                                    #<%= c.getCompanyId() %>

                                </div>


                            </div>


                        </div>


                    </div>



                    <!-- PROFILE SETTINGS -->

                    <div class="card">


                        <div class="card-header">


                            <h2>

                                Profile Settings

                            </h2>


                            <p>

                                Keep your company information accurate and up to date.

                            </p>


                        </div>



                        <div class="side-content">


                            <div class="settings-text">

                                Update your company name, phone number,
                                address and official website whenever required.

                            </div>



                            <a
                                href="company-edit-profile.jsp"
                                class="edit-button"
                            >

                                Edit Company Profile

                            </a>



                            <a
                                href="company-dashboard.jsp"
                                class="dashboard-button"
                            >

                                Back to Dashboard

                            </a>


                        </div>


                    </div>


                </div>


            </div>


        </div>


<%
    }
    else {
%>


        <!-- =================================================
             ERROR
             ================================================= -->

        <div style="
            padding:60px;
            text-align:center;
        ">


            <h2>

                Unable to load company profile.

            </h2>


            <br>


            <a href="company-dashboard.jsp"
               style="color:#0878ed;font-weight:bold;">

                Back to Dashboard

            </a>


        </div>


<%
    }
%>


    </main>


</div>


</body>

</html>