<%@ page contentType="text/html;charset=UTF-8" %>

<%

    String companyName = (String) session.getAttribute("companyName");

    String email = (String) session.getAttribute("email");

    if (companyName == null) {

        response.sendRedirect("company-login.jsp");

        return;

    }

    String logoPath = "images/company/tcs-logo.png";

    if (companyName.toLowerCase().contains("infosys")) {

        logoPath = "images/company/infosys-logo.png";

    }

    else if (companyName.toLowerCase().contains("google")) {

        logoPath = "images/company/google-logo.png";

    }

%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Create Recruitment Drive | CampusConnect</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>

        * {

            box-sizing: border-box;

            margin: 0;

            padding: 0;

        }

        body {

            font-family: Arial, Helvetica, sans-serif;

            background: #f4f7fb;

            color: #12385f;

        }

        /* ================= HEADER ================= */

        .top-header {

            background: #ffffff;

            padding: 32px 4%;

            border-bottom: 1px solid #e1e8f0;

            display: flex;

            justify-content: space-between;

            align-items: center;

        }

        .page-title h1 {

            font-size: 34px;

            color: #073b69;

            margin-bottom: 7px;

        }

        .page-title p {

            color: #65809e;

            font-size: 16px;

        }

        .back-link {

            color: #087ff5;

            text-decoration: none;

            font-size: 16px;

            font-weight: bold;

        }

        .back-link:hover {

            text-decoration: underline;

        }

        /* ================= MAIN ================= */

        .main-container {

            width: 88%;

            max-width: 1250px;

            margin: 38px auto 70px;

        }

        /* ================= COMPANY BANNER ================= */

        .company-banner {

            background: linear-gradient(110deg, #155d96, #087ff5);

            min-height: 150px;

            border-radius: 22px;

            padding: 28px 38px;

            display: flex;

            align-items: center;

            box-shadow: 0 12px 30px rgba(19, 90, 150, 0.16);

            margin-bottom: 30px;

        }

        .company-logo {

            width: 92px;

            height: 92px;

            background: #ffffff;

            border-radius: 18px;

            display: flex;

            justify-content: center;

            align-items: center;

            overflow: hidden;

            margin-right: 25px;

            flex-shrink: 0;

        }

        .company-logo img {

            width: 78px;

            height: 78px;

            object-fit: contain;

        }

        .company-details h2 {

            color: #ffffff;

            font-size: 28px;

            margin-bottom: 7px;

        }

        .company-details p {

            color: #e5f2ff;

            font-size: 15px;

        }

        .active-badge {

            margin-left: auto;

            border: 1px solid rgba(255,255,255,0.55);

            color: #ffffff;

            padding: 10px 20px;

            border-radius: 30px;

            font-size: 14px;

            font-weight: bold;

        }

        /* ================= GRID ================= */

        .content-grid {

            display: grid;

            grid-template-columns: minmax(0, 1fr) 310px;

            gap: 28px;

            align-items: start;

        }

        /* ================= FORM CARD ================= */

        .form-card {

            background: #ffffff;

            border-radius: 20px;

            border: 1px solid #e0e8f1;

            box-shadow: 0 8px 25px rgba(22, 68, 110, 0.07);

            overflow: hidden;

        }

        .card-header {

            padding: 28px 34px;

            border-bottom: 1px solid #e5ebf2;

        }

        .card-header h2 {

            font-size: 24px;

            color: #073b69;

            margin-bottom: 7px;

        }

        .card-header p {

            color: #7188a2;

            font-size: 15px;

        }

        .form-body {

            padding: 34px;

        }

        /* ================= FORM ================= */

        .form-row {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 25px;

            margin-bottom: 24px;

        }

        .form-group {

            display: flex;

            flex-direction: column;

        }

        .form-group.full {

            grid-column: 1 / -1;

        }

        .form-group label {

            font-size: 15px;

            font-weight: bold;

            color: #173f67;

            margin-bottom: 9px;

        }

        .required {

            color: #e53935;

        }

        input,

        select,

        textarea {

            width: 100%;

            border: 1px solid #ccd9e6;

            border-radius: 10px;

            padding: 13px 15px;

            font-size: 15px;

            color: #183f64;

            background: #ffffff;

            outline: none;

            transition: 0.2s;

        }

        input:focus,

        select:focus,

        textarea:focus {

            border-color: #087ff5;

            box-shadow: 0 0 0 3px rgba(8, 127, 245, 0.10);

        }

        input::placeholder,

        textarea::placeholder {

            color: #9aaabd;

        }

        textarea {

            resize: vertical;

            min-height: 120px;

            line-height: 1.5;

        }

        select {

            cursor: pointer;

        }

        .field-hint {

            font-size: 12px;

            color: #8497aa;

            margin-top: 7px;

        }

        /* ================= STATUS ================= */

        .status-box {

            background: #ecfaf3;

            border: 1px solid #c8eedb;

            border-radius: 10px;

            padding: 13px 15px;

            color: #087c48;

            font-size: 15px;

            font-weight: bold;

        }

        .status-dot {

            display: inline-block;

            width: 8px;

            height: 8px;

            background: #12b76a;

            border-radius: 50%;

            margin-right: 7px;

        }

        /* ================= BUTTONS ================= */

        .form-actions {

            border-top: 1px solid #e5ebf2;

            margin-top: 10px;

            padding-top: 26px;

            display: flex;

            gap: 12px;

        }

        .btn {

            border: none;

            border-radius: 10px;

            padding: 13px 24px;

            font-size: 15px;

            font-weight: bold;

            cursor: pointer;

            text-decoration: none;

            display: inline-block;

            transition: 0.2s;

        }

        .btn-primary {

            background: #087ff5;

            color: #ffffff;

        }

        .btn-primary:hover {

            background: #066dcc;

            transform: translateY(-1px);

        }

        .btn-secondary {

            background: #ffffff;

            color: #315779;

            border: 1px solid #ccd9e6;

        }

        .btn-secondary:hover {

            background: #f5f8fb;

        }

        /* ================= SIDE CARDS ================= */

        .side-card {

            background: #ffffff;

            border-radius: 18px;

            border: 1px solid #e0e8f1;

            box-shadow: 0 8px 25px rgba(22, 68, 110, 0.06);

            margin-bottom: 22px;

            overflow: hidden;

        }

        .side-header {

            padding: 23px;

            border-bottom: 1px solid #e7edf3;

        }

        .side-header h3 {

            color: #073b69;

            font-size: 20px;

            margin-bottom: 6px;

        }

        .side-header p {

            color: #7188a2;

            font-size: 13px;

            line-height: 1.5;

        }

        .side-body {

            padding: 23px;

        }

        .info-item {

            display: flex;

            align-items: flex-start;

            margin-bottom: 20px;

        }

        .info-item:last-child {

            margin-bottom: 0;

        }

        .info-icon {

            width: 36px;

            height: 36px;

            border-radius: 9px;

            background: #edf6ff;

            color: #087ff5;

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: bold;

            margin-right: 12px;

            flex-shrink: 0;

        }

        .info-text strong {

            display: block;

            color: #315779;

            font-size: 13px;

            margin-bottom: 4px;

        }

        .info-text span {

            color: #6f849c;

            font-size: 13px;

            line-height: 1.4;

        }

        /* ================= TIPS ================= */

        .tips {

            padding-left: 18px;

        }

        .tips li {

            margin-bottom: 13px;

            color: #6c8198;

            font-size: 13px;

            line-height: 1.5;

        }

        .tips li::marker {

            color: #087ff5;

        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 900px) {

            .content-grid {

                grid-template-columns: 1fr;

            }

            .side-card {

                margin-top: 0;

            }

        }

        @media (max-width: 700px) {

            .top-header {

                padding: 25px 5%;

            }

            .top-header {

                align-items: flex-start;

                gap: 15px;

            }

            .page-title h1 {

                font-size: 27px;

            }

            .main-container {

                width: 92%;

            }

            .company-banner {

                padding: 22px;

            }

            .company-logo {

                width: 70px;

                height: 70px;

                margin-right: 15px;

            }

            .company-logo img {

                width: 58px;

                height: 58px;

            }

            .company-details h2 {

                font-size: 22px;

            }

            .active-badge {

                display: none;

            }

            .form-row {

                grid-template-columns: 1fr;

                gap: 20px;

            }

            .form-group.full {

                grid-column: auto;

            }

            .form-body {

                padding: 24px;

            }

        }

        /* =========================================================
           COMPANY PORTAL SIDEBAR - SAME AS DASHBOARD
           ========================================================= */

        .sidebar {
            width: 285px;
            min-width: 285px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: linear-gradient(180deg, #092f55 0%, #062847 100%);
            color: white;
            display: flex;
            flex-direction: column;
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar::-webkit-scrollbar { width: 4px; }
        .sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); }

        .sidebar-logo {
            padding: 30px 26px 25px;
            margin: 0 16px;
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }

        .brand-name {
            font-size: 25px;
            font-weight: 800;
            letter-spacing: -1px;
            color: #ffffff;
        }

        .brand-name span { color: #2e8bf0; }

        .brand-subtitle {
            margin-top: 8px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 1.2px;
            color: #4da2ff;
        }

        .sidebar-content {
            padding: 24px 16px;
            flex: 1;
        }

        .menu-section-title {
            margin: 0 10px 10px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #42a0f5;
        }

        .menu-section-title:not(:first-child) { margin-top: 22px; }

        .menu-item {
            min-height: 48px;
            padding: 0 15px;
            margin-bottom: 5px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            gap: 17px;
            font-size: 16px;
            font-weight: 600;
            color: #edf5ff;
            text-decoration: none;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .menu-item i {
            width: 22px;
            text-align: center;
            font-size: 18px;
            color: #e9f3ff;
        }

        .menu-item:hover { background: rgba(49,139,238,0.22); }

        .menu-item.active {
            background: linear-gradient(90deg, #2683e9, #347fce);
            box-shadow: 0 5px 15px rgba(0,0,0,0.12);
        }

        .menu-item.active i { color: white; }

        .sidebar-bottom {
            padding: 10px 16px 25px;
            border-top: 1px solid rgba(255,255,255,0.15);
        }

        .sidebar-bottom .menu-item { margin-bottom: 3px; }
        .menu-item.logout { color: #ff7d7d; }
        .menu-item.logout i { color: #ff7d7d; }

        /* Existing page starts after the fixed sidebar. */
        .top-header {
            margin-left: 285px;
            width: calc(100% - 285px);
        }

        .main-container {
            width: auto;
            max-width: 1250px;
            margin: 38px 30px 70px 315px;
        }

        @media (max-width: 900px) {
            .sidebar {
                width: 220px;
                min-width: 220px;
            }

            .top-header {
                margin-left: 220px;
                width: calc(100% - 220px);
            }

            .main-container {
                width: auto;
                margin-left: 240px;
                margin-right: 20px;
            }
        }

        @media (max-width: 700px) {
            .sidebar {
                position: relative;
                width: 100%;
                min-width: 100%;
                height: auto;
            }

            .top-header {
                margin-left: 0;
                width: 100%;
            }

            .main-container {
                width: 92%;
                margin: 30px auto 60px;
            }
        }

    </style>

    <script>

        function validateForm() {

            var form = document.forms["myForm"];

            var driveType = form["driveType"].value.trim();

            var jobTitle = form["jobTitle"].value.trim();

            var description = form["description"].value.trim();

            var vacancy = form["vacancy"].value.trim();

            var eligibilityCgpa = form["eligibilityCgpa"].value.trim();

            var requiredBranch = form["requiredBranch"].value.trim();

            var requiredSkills = form["requiredSkills"].value.trim();

            var salary = form["salary"].value.trim();

            var deadline = form["deadline"].value.trim();

            /* Drive Type */

            if (driveType === "") {

                alert("Please select the Drive Type.");

                form["driveType"].focus();

                return false;

            }

            /* Job Title */

            if (jobTitle === "") {

                alert("Job Title is required.");

                form["jobTitle"].focus();

                return false;

            }

            /* Description */

            if (description === "") {

                alert("Job Description is required.");

                form["description"].focus();

                return false;

            }

            /* Vacancy */

            if (vacancy === "") {

                alert("Vacancy is required.");

                form["vacancy"].focus();

                return false;

            }

            if (!/^[0-9]+$/.test(vacancy)) {

                alert("Vacancy should contain numbers only.");

                form["vacancy"].focus();

                return false;

            }

            if (parseInt(vacancy) <= 0) {

                alert("Vacancy must be greater than 0.");

                form["vacancy"].focus();

                return false;

            }

            /* CGPA */

            if (eligibilityCgpa === "") {

                alert("Eligibility CGPA is required.");

                form["eligibilityCgpa"].focus();

                return false;

            }

            if (!/^[0-9]+(\.[0-9]+)?$/.test(eligibilityCgpa)) {

                alert("Please enter a valid CGPA.");

                form["eligibilityCgpa"].focus();

                return false;

            }

            var cgpaValue = parseFloat(eligibilityCgpa);

            if (cgpaValue < 0 || cgpaValue > 10) {

                alert("CGPA must be between 0 and 10.");

                form["eligibilityCgpa"].focus();

                return false;

            }

            /* Branch */

            if (requiredBranch === "") {

                alert("Required Branch is required.");

                form["requiredBranch"].focus();

                return false;

            }

            /* Skills */

            if (requiredSkills === "") {

                alert("Required Skills are required.");

                form["requiredSkills"].focus();

                return false;

            }

            /* Salary */

            if (salary === "") {

                alert("Salary is required.");

                form["salary"].focus();

                return false;

            }

            if (!/^[0-9]+(\.[0-9]+)?$/.test(salary)) {

                alert("Salary should contain numbers only.");

                form["salary"].focus();

                return false;

            }

            if (parseFloat(salary) <= 0) {

                alert("Salary must be greater than 0.");

                form["salary"].focus();

                return false;

            }

            /* Deadline */

            if (deadline === "") {

                alert("Deadline is required.");

                form["deadline"].focus();

                return false;

            }

            /*

             * Expected format:

             * DD-MM-YYYY

             */

            var datePattern = /^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-[0-9]{4}$/;

            if (!datePattern.test(deadline)) {

                alert("Please enter Deadline in DD-MM-YYYY format.");

                form["deadline"].focus();

                return false;

            }

            return true;

        }

    </script>

</head>

<body>

    <!-- =====================================================
         COMPANY PORTAL SIDEBAR
         ===================================================== -->

    <aside class="sidebar">

        <div class="sidebar-logo">
            <div class="brand-name">Campus<span>Connect</span></div>
            <div class="brand-subtitle">COMPANY PORTAL</div>
        </div>

        <div class="sidebar-content">

            <div class="menu-section-title">OVERVIEW</div>

            <a href="company-dashboard.jsp" class="menu-item">
                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a href="company-profile.jsp" class="menu-item">
                <i class="fa-solid fa-building"></i>
                <span>Company Profile</span>
            </a>

            <div class="menu-section-title">RECRUITMENT</div>

            <a href="recruitment-drive.jsp" class="menu-item active">
                <i class="fa-solid fa-plus"></i>
                <span>Create Drive</span>
            </a>

            <a href="view-recruitment-drives.jsp" class="menu-item">
                <i class="fa-solid fa-briefcase"></i>
                <span>Recruitment Drives</span>
            </a>

            <a href="company-applicants.jsp" class="menu-item">
                <i class="fa-solid fa-users"></i>
                <span>Applicants</span>
            </a>

            <a href="company-shortlisted.jsp" class="menu-item">
                <i class="fa-solid fa-star"></i>
                <span>Shortlisted Candidates</span>
            </a>

            <a href="company-interviews.jsp" class="menu-item">
                <i class="fa-regular fa-square"></i>
                <span>Interviews</span>
            </a>

            <a href="company-offers.jsp" class="menu-item">
                <i class="fa-regular fa-gem"></i>
                <span>Offers &amp; Selections</span>
            </a>

            <div class="menu-section-title">ANALYTICS</div>

            <a href="company-reports.jsp" class="menu-item">
                <i class="fa-solid fa-chart-column"></i>
                <span>Reports &amp; Analytics</span>
            </a>

            <a href="company-analytics.jsp" class="menu-item">
                <i class="fa-solid fa-chart-line"></i>
                <span>Analytics Insights</span>
            </a>

        </div>

        <div class="sidebar-bottom">

            <a href="company-settings.jsp" class="menu-item">
                <i class="fa-solid fa-gear"></i>
                <span>Settings</span>
            </a>

            <a href="CompanyLogoutServlet" class="menu-item logout">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>

        </div>

    </aside>

    <!-- ================= HEADER ================= -->

    <header class="top-header">

        <div class="page-title">

            <h1>Create Recruitment Drive</h1>

            <p>

                Publish a new opportunity and connect with eligible students.

            </p>

        </div>

        <a href="company-dashboard.jsp" class="back-link">

            Back to Dashboard

        </a>

    </header>

    <!-- ================= MAIN ================= -->

    <main class="main-container">

        <!-- ================= COMPANY BANNER ================= -->

        <section class="company-banner">

            <div class="company-logo">

                <img

                    src="<%= request.getContextPath() %>/<%= logoPath %>?v=2"

                    alt="<%= companyName %> Logo"

                    onerror="this.style.display='none';"

                >

            </div>

            <div class="company-details">

                <h2><%= companyName %></h2>

                <p><%= email != null ? email : "" %></p>

            </div>

            <div class="active-badge">

                ACTIVE ACCOUNT

            </div>

        </section>

        <!-- ================= CONTENT ================= -->

        <div class="content-grid">

            <!-- ================= FORM ================= -->

            <section class="form-card">

                <div class="card-header">

                    <h2>Recruitment Drive Details</h2>

                    <p>

                        Provide the job and eligibility information for this recruitment opportunity.

                    </p>

                </div>

                <div class="form-body">

                    <form

                        name="myForm"

                        method="post"

                        action="recruitment-drive-save.jsp"

                        onsubmit="return validateForm();"

                    >

                        <!-- ROW 1 -->

                        <div class="form-row">

                            <div class="form-group">

                                <label>

                                    Drive Type

                                    <span class="required">*</span>

                                </label>

                                <select name="driveType">

                                    <option value="">

                                        Select Drive Type

                                    </option>

                                    <option value="On Campus">

                                        On Campus

                                    </option>

                                    <option value="Off Campus">

                                        Off Campus

                                    </option>

                                </select>

                            </div>

                            <div class="form-group">

                                <label>

                                    Job Title

                                    <span class="required">*</span>

                                </label>

                                <input

                                    type="text"

                                    name="jobTitle"

                                    placeholder="e.g. Software Engineer"

                                    maxlength="100"

                                >

                            </div>

                        </div>

                        <!-- DESCRIPTION -->

                        <div class="form-row">

                            <div class="form-group full">

                                <label>

                                    Job Description

                                    <span class="required">*</span>

                                </label>

                                <textarea

                                    name="description"

                                    placeholder="Describe the role, responsibilities and expectations..."

                                    maxlength="1000"

                                ></textarea>

                                <span class="field-hint">

                                    Give students a clear understanding of the role and responsibilities.

                                </span>

                            </div>

                        </div>

                        <!-- ROW 2 -->

                        <div class="form-row">

                            <div class="form-group">

                                <label>

                                    Number of Vacancies

                                    <span class="required">*</span>

                                </label>

                                <input

                                    type="text"

                                    name="vacancy"

                                    maxlength="5"

                                    placeholder="e.g. 25"

                                >

                            </div>

                            <div class="form-group">

                                <label>

                                    Minimum Eligibility CGPA

                                    <span class="required">*</span>

                                </label>

                                <input

                                    type="text"

                                    name="eligibilityCgpa"

                                    placeholder="e.g. 7.5"

                                    maxlength="4"

                                >

                            </div>

                        </div>

                        <!-- ROW 3 -->

                        <div class="form-row">

                            <div class="form-group">

                                <label>

                                    Required Branch

                                    <span class="required">*</span>

                                </label>

                                <input

                                    type="text"

                                    name="requiredBranch"

                                    placeholder="e.g. CSE, IT, ECE"

                                    maxlength="100"

                                >

                            </div>

                            <div class="form-group">

                                <label>

                                    Salary / CTC

                                    <span class="required">*</span>

                                </label>

                                <input

                                    type="text"

                                    name="salary"

                                    placeholder="e.g. 600000"

                                    maxlength="12"

                                >

                                <span class="field-hint">

                                    Enter annual salary/CTC in INR.

                                </span>

                            </div>

                        </div>

                        <!-- SKILLS -->

                        <div class="form-row">

                            <div class="form-group full">

                                <label>

                                    Required Skills

                                    <span class="required">*</span>

                                </label>

                                <textarea

                                    name="requiredSkills"

                                    placeholder="e.g. Java, SQL, Data Structures, Spring Boot"

                                    maxlength="500"

                                ></textarea>

                                <span class="field-hint">

                                    Separate multiple skills using commas.

                                </span>

                            </div>

                        </div>

                        <!-- DEADLINE + STATUS -->

                        <div class="form-row">

                            <div class="form-group">

                                <label>

                                    Application Deadline

                                    <span class="required">*</span>

                                </label>

                                <input

                                    type="text"

                                    name="deadline"

                                    placeholder="DD-MM-YYYY"

                                    maxlength="10"

                                >

                                <span class="field-hint">

                                    Example: 30-09-2026

                                </span>

                            </div>

                            <div class="form-group">

                                <label>

                                    Drive Status

                                </label>

                                <div class="status-box">

                                    <span class="status-dot"></span>

                                    ACTIVE

                                </div>

                                <input

                                    type="hidden"

                                    name="status"

                                    value="ACTIVE"

                                >

                            </div>

                        </div>

                        <!-- BUTTONS -->

                        <div class="form-actions">

                            <button

                                type="submit"

                                class="btn btn-primary"

                            >

                                Create Recruitment Drive

                            </button>

                            <button

                                type="reset"

                                class="btn btn-secondary"

                            >

                                Reset Form

                            </button>

                            <a

                                href="company-dashboard.jsp"

                                class="btn btn-secondary"

                            >

                                Cancel

                            </a>

                        </div>

                    </form>

                </div>

            </section>

            <!-- ================= SIDEBAR ================= -->

            <aside>

                <!-- COMPANY INFO -->

                <div class="side-card">

                    <div class="side-header">

                        <h3>Company Information</h3>

                        <p>

                            This drive will be published under your company account.

                        </p>

                    </div>

                    <div class="side-body">

                        <div class="info-item">

                            <div class="info-icon">

                                C

                            </div>

                            <div class="info-text">

                                <strong>Company</strong>

                                <span>

                                    <%= companyName %>

                                </span>

                            </div>

                        </div>

                        <div class="info-item">

                            <div class="info-icon">

                                @

                            </div>

                            <div class="info-text">

                                <strong>Contact Email</strong>

                                <span>

                                    <%= email != null ? email : "Registered email" %>

                                </span>

                            </div>

                        </div>

                        <div class="info-item">

                            <div class="info-icon">

                                ✓

                            </div>

                            <div class="info-text">

                                <strong>Account Status</strong>

                                <span>

                                    Active and ready to recruit

                                </span>

                            </div>

                        </div>

                    </div>

                </div>

                <!-- TIPS -->

                <div class="side-card">

                    <div class="side-header">

                        <h3>Posting Tips</h3>

                        <p>

                            Make your recruitment drive clear and useful for students.

                        </p>

                    </div>

                    <div class="side-body">

                        <ul class="tips">

                            <li>

                                Use a clear and specific job title.

                            </li>

                            <li>

                                Mention the important technical skills required.

                            </li>

                            <li>

                                Set an eligibility CGPA that matches your recruitment criteria.

                            </li>

                            <li>

                                Clearly mention the number of available vacancies.

                            </li>

                            <li>

                                Provide a valid application deadline.

                            </li>

                        </ul>

                    </div>

                </div>

            </aside>

        </div>

    </main>

</body>

</html>