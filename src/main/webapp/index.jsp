<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>CampusConnect | Campus Recruitment Management System</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f7f9fc;
            color: #172033;
            line-height: 1.6;
        }

        /* ================= NAVBAR ================= */

        .navbar {
            height: 72px;
            background: rgba(255,255,255,0.97);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 7%;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid #e7ebf2;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: bold;
            color: #132f63;
        }

        .logo-box {
            width: 40px;
            height: 40px;
            background: #1769e0;
            color: white;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .logo span {
            color: #1769e0;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .nav-links a {
            text-decoration: none;
            color: #4c5668;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
        }

        .nav-links a:hover {
            color: #1769e0;
        }

        .nav-login {
            background: #132f63;
            color: white !important;
            padding: 10px 20px;
            border-radius: 8px;
        }

        .nav-login:hover {
            background: #1769e0;
        }


        /* ================= HERO ================= */

        .hero {
            min-height: 610px;
            padding: 85px 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 60px;
            background:
                radial-gradient(circle at 85% 20%, #dceaff 0, transparent 28%),
                linear-gradient(135deg, #f2f7ff, #ffffff);
        }

        .hero-content {
            width: 54%;
        }

        .badge {
            display: inline-block;
            padding: 7px 15px;
            background: #e5efff;
            color: #1769e0;
            border-radius: 30px;
            font-size: 12px;
            font-weight: bold;
            letter-spacing: 1px;
            margin-bottom: 20px;
        }

        .hero h1 {
            font-size: 58px;
            line-height: 1.08;
            color: #102b59;
            margin-bottom: 22px;
        }

        .hero h1 span {
            color: #1769e0;
        }

        .hero-text {
            max-width: 650px;
            color: #647084;
            font-size: 17px;
            margin-bottom: 32px;
        }

        .hero-buttons {
            display: flex;
            gap: 14px;
        }

        .primary-btn,
        .secondary-btn {
            display: inline-block;
            text-decoration: none;
            padding: 13px 24px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 14px;
            transition: 0.3s;
        }

        .primary-btn {
            background: #1769e0;
            color: white;
        }

        .primary-btn:hover {
            background: #0d54bd;
            transform: translateY(-2px);
        }

        .secondary-btn {
            border: 1px solid #ccd5e3;
            background: white;
            color: #243b64;
        }

        .secondary-btn:hover {
            border-color: #1769e0;
            color: #1769e0;
        }


        /* ================= HERO VISUAL ================= */

        .hero-visual {
            width: 43%;
            display: flex;
            justify-content: center;
        }

        .network-card {
            width: 450px;
            min-height: 360px;
            background: white;
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 20px 50px rgba(29, 58, 103, 0.14);
            border: 1px solid #e8edf5;
        }

        .network-title {
            text-align: center;
            color: #183665;
            font-size: 18px;
            margin-bottom: 30px;
        }

        .network {
            display: grid;
            grid-template-columns: 1fr 50px 1fr;
            grid-template-rows: 1fr 50px 1fr;
            align-items: center;
            justify-items: center;
        }

        .network-item {
            width: 120px;
            height: 105px;
            border-radius: 16px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
        }

        .network-icon {
            font-size: 32px;
            margin-bottom: 5px;
        }

        .student-network {
            background: #fff1df;
            color: #c96600;
            grid-column: 1;
            grid-row: 1;
        }

        .college-network {
            background: #e5f7eb;
            color: #168343;
            grid-column: 3;
            grid-row: 1;
        }

        .company-network {
            background: #e6efff;
            color: #1761bb;
            grid-column: 1;
            grid-row: 3;
        }

        .admin-network {
            background: #eee8ff;
            color: #6a43bd;
            grid-column: 3;
            grid-row: 3;
        }

        .network-center {
            grid-column: 2;
            grid-row: 2;
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #1769e0;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
            text-align: center;
            box-shadow: 0 8px 20px rgba(23,105,224,0.3);
        }

        .connector-horizontal {
            width: 80px;
            height: 2px;
            background: #d6dfed;
        }

        .connector-vertical {
            width: 2px;
            height: 55px;
            background: #d6dfed;
        }


        /* ================= STATS ================= */

        .stats {
            width: 86%;
            margin: -35px auto 0;
            position: relative;
            z-index: 10;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            padding: 28px;
        }

        .stat {
            text-align: center;
            border-right: 1px solid #e6eaf0;
        }

        .stat:last-child {
            border-right: none;
        }

        .stat h2 {
            color: #132f63;
            font-size: 28px;
        }

        .stat p {
            color: #748095;
            font-size: 13px;
        }


        /* ================= COMMON SECTION ================= */

        .section {
            padding: 90px 7%;
        }

        .section-heading {
            text-align: center;
            max-width: 650px;
            margin: 0 auto 50px;
        }

        .section-heading h2 {
            color: #102b59;
            font-size: 35px;
            margin-bottom: 12px;
        }

        .section-heading p {
            color: #6b7587;
            font-size: 15px;
        }


        /* ================= PORTAL CARDS ================= */

        .portal-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }

        .portal-card {
            background: white;
            border-radius: 18px;
            padding: 28px;
            border: 1px solid #e6eaf1;
            box-shadow: 0 6px 22px rgba(25,50,90,0.06);
            transition: 0.3s;
            position: relative;
            overflow: hidden;
        }

        .portal-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 18px 35px rgba(25,50,90,0.12);
        }

        .portal-card::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 4px;
        }

        .student-card::before {
            background: #f08a24;
        }

        .college-card::before {
            background: #22a35a;
        }

        .company-card::before {
            background: #1769e0;
        }

        .admin-card::before {
            background: #7547c7;
        }

        .portal-icon {
            width: 58px;
            height: 58px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 18px;
        }

        .student-icon {
            background: #fff1df;
        }

        .college-icon {
            background: #e5f7eb;
        }

        .company-icon {
            background: #e6efff;
        }

        .admin-icon {
            background: #eee8ff;
        }

        .portal-card h3 {
            font-size: 21px;
            color: #172f58;
            margin-bottom: 10px;
        }

        .portal-card p {
            color: #6b7587;
            font-size: 14px;
            min-height: 85px;
            margin-bottom: 18px;
        }

        .portal-link {
            display: block;
            text-align: center;
            padding: 11px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            font-size: 13px;
            margin-top: 8px;
            transition: 0.3s;
        }

        .student-link {
            background: #fff1df;
            color: #c96600;
        }

        .student-link:hover {
            background: #f08a24;
            color: white;
        }

        .college-link {
            background: #e5f7eb;
            color: #168343;
        }

        .college-link:hover {
            background: #22a35a;
            color: white;
        }

        .company-link {
            background: #e6efff;
            color: #1761bb;
        }

        .company-link:hover {
            background: #1769e0;
            color: white;
        }

        .admin-link {
            background: #eee8ff;
            color: #6a43bd;
        }

        .admin-link:hover {
            background: #7547c7;
            color: white;
        }


        /* ================= HOW IT WORKS ================= */

        .process-section {
            background: #f0f5fc;
        }

        .process {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 14px;
        }

        .process-step {
            background: white;
            padding: 25px 15px;
            text-align: center;
            border-radius: 14px;
            border: 1px solid #e3e9f2;
        }

        .process-number {
            width: 42px;
            height: 42px;
            background: #132f63;
            color: white;
            border-radius: 50%;
            margin: 0 auto 13px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: bold;
        }

        .process-step h4 {
            color: #20385f;
            font-size: 15px;
            margin-bottom: 7px;
        }

        .process-step p {
            color: #758095;
            font-size: 12px;
        }


        /* ================= FEATURES ================= */

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .feature-card {
            padding: 28px;
            background: white;
            border: 1px solid #e5eaf2;
            border-radius: 15px;
            transition: 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(0,0,0,0.08);
        }

        .feature-card h3 {
            color: #1c3762;
            font-size: 17px;
            margin-bottom: 10px;
        }

        .feature-card p {
            color: #6d7789;
            font-size: 13px;
        }


        /* ================= CTA ================= */

        .cta {
            margin: 0 7% 80px;
            padding: 65px 30px;
            border-radius: 22px;
            background: linear-gradient(135deg, #132f63, #1769e0);
            color: white;
            text-align: center;
        }

        .cta h2 {
            font-size: 34px;
            margin-bottom: 12px;
        }

        .cta p {
            color: #dbe8ff;
            margin-bottom: 25px;
        }

        .cta-button {
            display: inline-block;
            background: white;
            color: #13336b;
            padding: 13px 25px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
        }

        .cta-button:hover {
            background: #edf4ff;
        }


        /* ================= FOOTER ================= */

        footer {
            background: #091d3e;
            color: white;
            padding: 40px 7% 25px;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(255,255,255,0.12);
        }

        .footer-logo {
            font-size: 22px;
            font-weight: bold;
        }

        .footer-logo span {
            color: #67a6ff;
        }

        .footer-text {
            color: #aebbd0;
            font-size: 13px;
        }

        .copyright {
            text-align: center;
            color: #8493aa;
            font-size: 12px;
            margin-top: 20px;
        }


        /* ================= RESPONSIVE ================= */

        @media(max-width: 1100px) {

            .portal-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .feature-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .process {
                grid-template-columns: repeat(3, 1fr);
            }

            .hero h1 {
                font-size: 48px;
            }
        }


        @media(max-width: 800px) {

            .nav-links a:not(.nav-login) {
                display: none;
            }

            .hero {
                flex-direction: column;
                text-align: center;
            }

            .hero-content {
                width: 100%;
            }

            .hero-visual {
                width: 100%;
            }

            .hero-buttons {
                justify-content: center;
            }

            .stats {
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }

            .stat {
                border-right: none;
            }
        }


        @media(max-width: 550px) {

            .navbar {
                padding: 0 5%;
            }

            .hero {
                padding: 65px 5%;
            }

            .hero h1 {
                font-size: 38px;
            }

            .network-card {
                width: 100%;
                padding: 20px;
            }

            .network-item {
                width: 90px;
                height: 90px;
            }

            .portal-grid,
            .feature-grid,
            .process {
                grid-template-columns: 1fr;
            }

            .stats {
                width: 90%;
            }

            .cta {
                margin-left: 5%;
                margin-right: 5%;
            }

            .footer-content {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }

    </style>

</head>


<body>


<!-- ================= NAVBAR ================= -->

<nav class="navbar">

    <div class="logo">

        <div class="logo-box">
            CC
        </div>

        Campus<span>Connect</span>

    </div>


    <div class="nav-links">

        <a href="#home">Home</a>

        <a href="#portals">Portals</a>

        <a href="#process">How It Works</a>

        <a href="#features">Features</a>

        <a href="#portals" class="nav-login">
            Login
        </a>

    </div>

</nav>



<!-- ================= HERO ================= -->

<section class="hero" id="home">

    <div class="hero-content">

        <div class="badge">
            CAMPUS RECRUITMENT MANAGEMENT SYSTEM
        </div>


        <h1>

            Campus Recruitment,
            <span>Connected.</span>

        </h1>


        <p class="hero-text">

            CampusConnect brings students, colleges,
            companies and administrators together on one
            powerful platform for admissions, academics,
            recruitment and placement management.

        </p>


        <div class="hero-buttons">

            <a href="#portals" class="primary-btn">
                Explore Portals
            </a>

            <a href="#process" class="secondary-btn">
                How It Works
            </a>

        </div>

    </div>



    <!-- NETWORK VISUAL -->

    <div class="hero-visual">

        <div class="network-card">

            <div class="network-title">
                One Platform. Four Connected Portals.
            </div>


            <div class="network">

                <div class="network-item student-network">

                    <div class="network-icon">
                        🎓
                    </div>

                    Student

                </div>


                <div class="network-item college-network">

                    <div class="network-icon">
                        🏫
                    </div>

                    College

                </div>


                <div class="network-item company-network">

                    <div class="network-icon">
                        💼
                    </div>

                    Company

                </div>


                <div class="network-item admin-network">

                    <div class="network-icon">
                        🛡️
                    </div>

                    Super Admin

                </div>


                <div class="network-center">
                    CAMPUS<br>CONNECT
                </div>

            </div>

        </div>

    </div>

</section>



<!-- ================= STATS ================= -->

<div class="stats">

    <div class="stat">

        <h2>01</h2>

        <p>Unified Platform</p>

    </div>


    <div class="stat">

        <h2>04</h2>

        <p>Connected Modules</p>

    </div>


    <div class="stat">

        <h2>24/7</h2>

        <p>System Access</p>

    </div>


    <div class="stat">

        <h2>∞</h2>

        <p>Recruitment Opportunities</p>

    </div>

</div>



<!-- ================= PORTALS ================= -->

<section class="section" id="portals">

    <div class="section-heading">

        <h2>
            Choose Your Portal
        </h2>

        <p>
            Select your role to access the features
            designed specifically for you.
        </p>

    </div>


    <div class="portal-grid">


        <!-- STUDENT -->

        <div class="portal-card student-card">

            <div class="portal-icon student-icon">
                🎓
            </div>

            <h3>
                Student Portal
            </h3>

            <p>
                Explore colleges, submit admission requests,
                build your profile and apply for recruitment
                opportunities.
            </p>


            <a href="new_student_colleges.jsp"
               class="portal-link student-link">

                New Student

            </a>


            <a href="student_login.jsp"
               class="portal-link student-link">

                Existing Student

            </a>

        </div>



        <!-- COLLEGE -->

        <div class="portal-card college-card">

            <div class="portal-icon college-icon">
                🏫
            </div>

            <h3>
                College Portal
            </h3>

            <p>
                Manage students, faculty, departments,
                courses, placement drives and recruitment
                activities.
            </p>


            <!-- Replace # when college login is ready -->

            <a href="#"
               class="portal-link college-link">

                College Admin Login

            </a>

        </div>



        <!-- COMPANY -->

        <div class="portal-card company-card">

            <div class="portal-icon company-icon">
                💼
            </div>

            <h3>
                Company Portal
            </h3>

            <p>
                Create recruitment drives, view applications,
                shortlist students, conduct interviews and
                manage selections.
            </p>


            <a href="<%=request.getContextPath()%>/company-login.jsp"
               class="portal-link company-link">

                Company Login

            </a>

        </div>



        <!-- SUPER ADMIN -->

        <div class="portal-card admin-card">

            <div class="portal-icon admin-icon">
                🛡️
            </div>

            <h3>
                Super Admin
            </h3>

            <p>
                Manage colleges, companies, students,
                system activities and overall platform
                administration.
            </p>


            <a href="<%=request.getContextPath()%>/superadmin/login.jsp"
               class="portal-link admin-link">

                Super Admin Login

            </a>

        </div>

    </div>

</section>



<!-- ================= PROCESS ================= -->

<section class="section process-section" id="process">

    <div class="section-heading">

        <h2>
            How CampusConnect Works
        </h2>

        <p>
            From admission to recruitment, everything
            is connected through one simple journey.
        </p>

    </div>


    <div class="process">


        <div class="process-step">

            <div class="process-number">
                01
            </div>

            <h4>
                Explore Colleges
            </h4>

            <p>
                Students discover available colleges.
            </p>

        </div>


        <div class="process-step">

            <div class="process-number">
                02
            </div>

            <h4>
                Admission
            </h4>

            <p>
                Submit an admission request.
            </p>

        </div>


        <div class="process-step">

            <div class="process-number">
                03
            </div>

            <h4>
                Build Profile
            </h4>

            <p>
                Add academics, skills and projects.
            </p>

        </div>


        <div class="process-step">

            <div class="process-number">
                04
            </div>

            <h4>
                Apply
            </h4>

            <p>
                Apply for eligible recruitment drives.
            </p>

        </div>


        <div class="process-step">

            <div class="process-number">
                05
            </div>

            <h4>
                Interview
            </h4>

            <p>
                Participate in recruitment rounds.
            </p>

        </div>


        <div class="process-step">

            <div class="process-number">
                06
            </div>

            <h4>
                Selection
            </h4>

            <p>
                Receive selection and placement results.
            </p>

        </div>

    </div>

</section>



<!-- ================= FEATURES ================= -->

<section class="section" id="features">

    <div class="section-heading">

        <h2>
            Everything You Need
        </h2>

        <p>
            CampusConnect manages the complete campus
            recruitment ecosystem.
        </p>

    </div>


    <div class="feature-grid">


        <div class="feature-card">

            <h3>
                🎓 Student Management
            </h3>

            <p>
                Profiles, academics, skills, projects,
                resumes and applications.
            </p>

        </div>


        <div class="feature-card">

            <h3>
                🏫 College Management
            </h3>

            <p>
                Students, faculty, departments, courses
                and campus recruitment.
            </p>

        </div>


        <div class="feature-card">

            <h3>
                💼 Recruitment Management
            </h3>

            <p>
                Campus drives, direct drives, applications,
                shortlisting and interviews.
            </p>

        </div>


        <div class="feature-card">

            <h3>
                📊 Reports & Tracking
            </h3>

            <p>
                Track recruitment activities, applications,
                interviews and final selections.
            </p>

        </div>

    </div>

</section>



<!-- ================= CTA ================= -->

<section class="cta">

    <h2>
        Your Campus Journey Starts Here
    </h2>

    <p>
        Connect with the right college, student and
        recruitment opportunities through CampusConnect.
    </p>

    <a href="#portals" class="cta-button">
        Choose Your Portal
    </a>

</section>



<!-- ================= FOOTER ================= -->

<footer>

    <div class="footer-content">

        <div class="footer-logo">
            Campus<span>Connect</span>
        </div>


        <div class="footer-text">
            Campus Recruitment Management System
        </div>

    </div>


    <div class="copyright">

        © 2026 CampusConnect |
        Campus Recruitment Management System

    </div>

</footer>


</body>

</html>