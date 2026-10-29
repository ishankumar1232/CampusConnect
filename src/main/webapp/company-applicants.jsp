<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"
    import="java.text.SimpleDateFormat"
    import="com.campusconnect.util.DBConnection" %>

<%!
    private String esc(String value) {
        if (value == null) return "";
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String formatDate(Date date) {
        if (date == null) return "-";
        return new SimpleDateFormat("dd-MM-yyyy").format(date);
    }

    private boolean isOnCampus(String driveType) {
        return driveType != null &&
               driveType.trim().toUpperCase().contains("ON CAMPUS");
    }
%>

<%
    /* ================= SESSION CHECK ================= */

    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String companyName = (String) session.getAttribute("companyName");
    String email = (String) session.getAttribute("email");

    if (companyName == null || companyName.trim().isEmpty()) {
        companyName = "Company";
    }

    if (email == null) {
        email = "";
    }

    /* ================= DATABASE ================= */

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int applicantCount = 0;
    int totalApplicants = 0;
    int pendingApplicants = 0;
    int shortlistedApplicants = 0;
    int rejectedApplicants = 0;

    String actionResult = request.getParameter("result");
    String actionStatus = request.getParameter("status");
    String actionMessage = request.getParameter("message");
    String actionDriveType = "";

    try {
        con = DBConnection.getConnection();

        /*
         * COMPANY-SIDE APPLICATION ACTIONS
         *
         * ON-CAMPUS:
         *   College must shortlist the student first
         *   (COLLEGE_SHORTLIST_STATUS = SHORTLISTED).
         *   Only then can the company approve/reject.
         *
         * OFF-CAMPUS:
         *   Company has the final approve/reject decision.
         *   College shortlist status does not block company action.
         *
         * Company actions update APPLICATION.STATUS only.
         * COLLEGE_SHORTLIST_STATUS is never modified here.
         */
        if ("POST".equalsIgnoreCase(request.getMethod())) {

            String action = request.getParameter("action");
            String targetStatus = null;

            if ("APPROVE".equalsIgnoreCase(action)) {
                targetStatus = "SHORTLISTED";
            } else if ("REJECT".equalsIgnoreCase(action)) {
                targetStatus = "REJECTED";
            } else if ("REVOKE".equalsIgnoreCase(action)
                    || "RECONSIDER".equalsIgnoreCase(action)) {
                targetStatus = "PENDING";
            }

            int actionApplicationId = 0;

            try {
                actionApplicationId = Integer.parseInt(
                        request.getParameter("applicationId"));
            } catch (NumberFormatException ignored) {
                // Invalid/missing ID handled below.
            }

            if (targetStatus == null || actionApplicationId <= 0) {
                response.sendError(400, "Invalid applicant action.");
                return;
            }

            /*
             * First verify that this application belongs to the logged-in
             * company and retrieve the drive/college status.
             */
            String verifySql =
                    "SELECT A.STATUS, A.COLLEGE_SHORTLIST_STATUS, R.DRIVE_TYPE " +
                    "FROM APPLICATION A " +
                    "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
                    "WHERE A.APPLICATION_ID = ? " +
                    "AND R.COMPANY_ID = ?";

            String currentStatus = null;
            String collegeStatus = null;
            String driveType = null;

            try (PreparedStatement verifyPs = con.prepareStatement(verifySql)) {
                verifyPs.setInt(1, actionApplicationId);
                verifyPs.setInt(2, companyId);

                try (ResultSet verifyRs = verifyPs.executeQuery()) {
                    if (verifyRs.next()) {
                        currentStatus = verifyRs.getString("STATUS");
                        collegeStatus = verifyRs.getString("COLLEGE_SHORTLIST_STATUS");
                        driveType = verifyRs.getString("DRIVE_TYPE");
                    }
                }
            }

            if (driveType == null) {
                response.sendError(404, "Application not found for this company.");
                return;
            }

            actionDriveType = driveType;

            boolean onCampus = isOnCampus(driveType);
            boolean collegeApproved =
                    "SHORTLISTED".equalsIgnoreCase(collegeStatus);

            /*
             * For ON-CAMPUS drives, company action is allowed only after
             * college approval/shortlisting.
             *
             * For OFF-CAMPUS drives, company is the final decision maker.
             */
            if (onCampus
                    && ("APPROVE".equalsIgnoreCase(action)
                        || "REJECT".equalsIgnoreCase(action)
                        || "RECONSIDER".equalsIgnoreCase(action))
                    && !collegeApproved) {

                if ("REJECTED".equalsIgnoreCase(collegeStatus)) {
                    response.sendRedirect(
                            "company-applicants.jsp?result=blocked&status=COLLEGE_REJECTED");
                } else {
                    response.sendRedirect(
                            "company-applicants.jsp?result=blocked&status=COLLEGE_PENDING");
                }
                return;
            }

            /*
             * Revoke approval is a company-side reversal. It returns the
             * company status to PENDING but never changes college status.
             */
            if ("REVOKE".equalsIgnoreCase(action)
                    && !"SHORTLISTED".equalsIgnoreCase(currentStatus)) {

                response.sendError(400, "Only shortlisted applicants can have approval revoked.");
                return;
            }

            if ("RECONSIDER".equalsIgnoreCase(action)
                    && !"REJECTED".equalsIgnoreCase(currentStatus)) {

                response.sendError(400, "Only rejected applicants can be reconsidered.");
                return;
            }

            String updateSql =
                    "UPDATE APPLICATION A " +
                    "SET STATUS = ? " +
                    "WHERE A.APPLICATION_ID = ? " +
                    "AND EXISTS (SELECT 1 FROM RECRUITMENT_DRIVE R " +
                    "            WHERE R.DRIVE_ID = A.DRIVE_ID " +
                    "            AND R.COMPANY_ID = ?)";

            try (PreparedStatement actionPs = con.prepareStatement(updateSql)) {

                actionPs.setString(1, targetStatus);
                actionPs.setInt(2, actionApplicationId);
                actionPs.setInt(3, companyId);

                if (actionPs.executeUpdate() != 1) {
                    response.sendError(404, "Application not found for this company.");
                    return;
                }
            }

            response.sendRedirect(
                    "company-applicants.jsp?result=updated&status="
                    + targetStatus
                    + "&driveType="
                    + java.net.URLEncoder.encode(driveType, "UTF-8"));

            return;
        }

        /* ================= APPLICANT STATS ================= */

        String statsSql =
                "SELECT COUNT(*), " +
                "       NVL(SUM(CASE WHEN UPPER(NVL(A.STATUS,'PENDING')) = 'PENDING' " +
                "                   THEN 1 ELSE 0 END), 0), " +
                "       NVL(SUM(CASE WHEN UPPER(A.STATUS) = 'SHORTLISTED' " +
                "                   THEN 1 ELSE 0 END), 0), " +
                "       NVL(SUM(CASE WHEN UPPER(A.STATUS) = 'REJECTED' " +
                "                   THEN 1 ELSE 0 END), 0) " +
                "FROM APPLICATION A " +
                "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
                "WHERE R.COMPANY_ID = ?";

        try (PreparedStatement statsPs = con.prepareStatement(statsSql)) {

            statsPs.setInt(1, companyId);

            try (ResultSet statsRs = statsPs.executeQuery()) {

                if (statsRs.next()) {
                    totalApplicants = statsRs.getInt(1);
                    pendingApplicants = statsRs.getInt(2);
                    shortlistedApplicants = statsRs.getInt(3);
                    rejectedApplicants = statsRs.getInt(4);
                }
            }
        }

        /* ================= APPLICANT LIST ================= */

        String sql =
                "SELECT A.APPLICATION_ID, " +
                "       A.STUDENT_ID, " +
                "       S.NAME, " +
                "       S.EMAIL, " +
                "       S.PHONE, " +
                "       R.DRIVE_ID, " +
                "       R.DRIVE_TYPE, " +
                "       R.JOB_TITLE, " +
                "       A.APPLIED_DATE, " +
                "       A.STATUS, " +
                "       A.COLLEGE_SHORTLIST_STATUS " +
                "FROM APPLICATION A " +
                "JOIN STUDENT S ON A.STUDENT_ID = S.STUDENT_ID " +
                "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
                "WHERE R.COMPANY_ID = ? " +
                "ORDER BY A.APPLICATION_ID DESC";

        ps = con.prepareStatement(sql);
        ps.setInt(1, companyId);
        rs = ps.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Applicants | CampusConnect</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #082f55;
        }

        body {
            overflow-x: hidden;
        }

        /* ================= SIDEBAR ================= */

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
           font-style: normal;
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

       /* ================= PAGE ================= */

        .page {
            margin-left: 300px;
            min-height: 100vh;
        }

        .top-header {
            min-height: 143px;
            background: white;
            border-bottom: 1px solid #dfe6ef;
            padding: 35px 42px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-left h1 {
            margin: 0;
            font-size: 36px;
            color: #082f55;
        }

        .header-left p {
            margin: 7px 0 0;
            font-size: 17px;
            color: #6d88a5;
        }

        .dashboard-link {
            color: #0878ed;
            text-decoration: none;
            font-size: 16px;
            font-weight: 700;
        }

        .dashboard-link:hover {
            text-decoration: underline;
        }

        .content {
            padding: 38px 36px 50px;
        }

        .page-heading {
            margin-bottom: 25px;
        }

        .page-heading h2 {
            margin: 0;
            font-size: 30px;
            color: #082f55;
        }

        .page-heading p {
            margin: 7px 0 0;
            color: #6d88a5;
            font-size: 16px;
        }

        /* ================= ALERTS ================= */

        .action-alert {
            display: flex;
            align-items: center;
            gap: 11px;
            margin: 0 0 22px;
            padding: 14px 17px;
            border: 1px solid #b7ebcd;
            border-radius: 10px;
            background: #edfbf3;
            color: #067647;
            font-weight: 600;
        }

        .action-alert.rejected {
            border-color: #ffd0d0;
            background: #fff1f1;
            color: #b42318;
        }

        .action-alert.warning {
            border-color: #f3d99b;
            background: #fff9e9;
            color: #9a6700;
        }

        .action-alert i {
            font-size: 17px;
        }

        /* ================= STATS ================= */

        .applicant-stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin: 0 0 25px;
        }

        .stat-card {
            display: flex;
            align-items: center;
            gap: 14px;
            min-height: 96px;
            padding: 18px 20px;
            background: #fff;
            border: 1px solid #e0e7ef;
            border-radius: 13px;
            box-shadow: 0 6px 18px rgba(12,55,90,.045);
        }

        .stat-icon {
            width: 46px;
            height: 46px;
            flex: 0 0 46px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            background: #eaf3ff;
            color: #176fe5;
            font-size: 18px;
        }

        .stat-icon.pending {
            background: #fff5dc;
            color: #b77900;
        }

        .stat-icon.shortlisted {
            background: #e7f8ef;
            color: #079455;
        }

        .stat-icon.rejected {
            background: #ffe8e8;
            color: #d14343;
        }

        .stat-value {
            display: block;
            color: #082f55;
            font-size: 24px;
            line-height: 1.1;
            font-weight: 800;
        }

        .stat-label {
            display: block;
            margin-top: 5px;
            color: #7188a3;
            font-size: 13px;
        }

        /* ================= CARD ================= */

        .applicants-card {
            background: white;
            border: 1px solid #e0e7ef;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(12,55,90,.06);
        }

        .card-header {
            padding: 26px 28px;
            border-bottom: 1px solid #e4eaf1;
        }

        .card-header h3 {
            margin: 0;
            font-size: 22px;
            color: #082f55;
        }

        .card-header p {
            margin: 6px 0 0;
            color: #7188a3;
            font-size: 14px;
        }

        /* ================= TOOLBAR ================= */

        .table-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 16px 20px;
            border-bottom: 1px solid #e4eaf1;
            background: #fff;
        }

        .table-tools {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .table-tools input,
        .table-tools select {
            min-height: 40px;
            border: 1px solid #d8e1eb;
            border-radius: 8px;
            padding: 0 12px;
            color: #31516f;
            background: #fff;
            font: inherit;
        }

        .table-tools input {
            width: min(290px, 55vw);
        }

        .table-tools input:focus,
        .table-tools select:focus {
            outline: 3px solid rgba(38,131,233,.16);
            border-color: #2683e9;
        }

        .result-count {
            color: #7188a3;
            font-size: 13px;
            white-space: nowrap;
        }

        /* ================= TABLE ================= */

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1160px;
        }

        th {
            background: #f7f9fc;
            color: #58718e;
            font-size: 12px;
            font-weight: 700;
            text-align: left;
            padding: 16px 18px;
            border-bottom: 1px solid #e0e7ef;
            text-transform: uppercase;
            letter-spacing: .5px;
        }

        td {
            padding: 18px;
            border-bottom: 1px solid #edf1f5;
            color: #31516f;
            font-size: 14px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: #f9fbfe;
        }

        .student-name {
            font-weight: 700;
            color: #082f55;
        }

        .student-email {
            color: #6d88a5;
            font-size: 13px;
            margin-top: 4px;
        }

        .job-title {
            font-weight: 700;
            color: #0b4e80;
        }

        /* ================= STATUS ================= */

        .status {
            display: inline-block;
            padding: 6px 11px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .status-active,
        .status-shortlisted {
            background: #e7f8ef;
            color: #079455;
        }

        .status-pending {
            background: #fff5dc;
            color: #b77900;
        }

        .status-rejected {
            background: #ffe8e8;
            color: #d14343;
        }

        .status-default {
            background: #edf2f7;
            color: #63778e;
        }

        .status-waiting {
            background: #eef4fb;
            color: #4289d5;
        }

        /* ================= ACTIONS ================= */

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            align-items: center;
        }

        .action-button {
            border: 0;
            border-radius: 7px;
            padding: 9px 12px;
            color: white;
            font-weight: 700;
            cursor: pointer;
            transition: .2s ease;
            white-space: nowrap;
            font-size: 13px;
        }

        .approve-button {
            background: #079455;
        }

        .approve-button:hover {
            background: #067647;
        }

        .reject-button {
            background: #d14343;
        }

        .reject-button:hover {
            background: #b42318;
        }

        .revoke-button {
            background: #7b8794;
        }

        .revoke-button:hover {
            background: #59636e;
        }

        .action-current {
            color: #7188a3;
            font-size: 13px;
        }

        .action-waiting {
            color: #4289d5;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.35;
            max-width: 165px;
        }

        .action-blocked {
            color: #d14343;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.35;
            max-width: 165px;
        }

        .drive-note {
            display: block;
            margin-top: 5px;
            font-size: 11px;
            color: #8a9bb0;
        }

        /* ================= EMPTY ================= */

        .empty-state {
            padding: 75px 25px;
            text-align: center;
        }

        .empty-icon {
            width: 64px;
            height: 64px;
            margin: 0 auto 18px;
            border-radius: 50%;
            background: #eef4fb;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #4289d5;
            font-size: 25px;
        }

        .empty-state h3 {
            margin: 0;
            font-size: 22px;
            color: #082f55;
        }

        .empty-state p {
            margin: 8px 0 22px;
            color: #7188a3;
            font-size: 15px;
        }

        .primary-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            border-radius: 8px;
            background: #176fe5;
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            transition: .2s ease;
        }

        .primary-button:hover {
            background: #0e5bc2;
        }

        .filter-empty {
            display: none;
            padding: 30px;
            text-align: center;
            color: #7188a3;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 1100px) {
            .sidebar {
                width: 270px;
            }

            .page {
                margin-left: 270px;
            }

            .applicant-stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 900px) {
            .sidebar {
                width: 220px;
                min-width: 220px;
            }

            .page {
                margin-left: 220px;
            }

            .top-header {
                padding: 30px;
            }

            .content {
                padding: 30px 24px;
            }
        }

        @media (max-width: 700px) {
            .sidebar {
                position: relative;
                width: 100%;
                min-width: 100%;
                height: auto;
            }

            .page {
                margin-left: 0;
            }

            .top-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .applicant-stats {
                grid-template-columns: 1fr 1fr;
                gap: 10px;
            }

            .stat-card {
                min-height: 82px;
                padding: 12px;
                gap: 10px;
            }

            .stat-icon {
                width: 38px;
                height: 38px;
                flex-basis: 38px;
            }

            .stat-value {
                font-size: 20px;
            }
        }
    </style>
</head>

<body>

<!-- ================= COMPANY PORTAL SIDEBAR ================= -->

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

        <a href="recruitment-drive.jsp" class="menu-item">
            <i class="fa-solid fa-plus"></i>
            <span>Create Drive</span>
        </a>

        <a href="view-recruitment-drives.jsp" class="menu-item">
            <i class="fa-solid fa-briefcase"></i>
            <span>Recruitment Drives</span>
        </a>

        <a href="company-applicants.jsp" class="menu-item active">
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

<!-- ================= PAGE ================= -->

<div class="page">

    <header class="top-header">
        <div class="header-left">
            <h1>Applicants</h1>
            <p>View students who have applied to your recruitment drives.</p>
        </div>

        <a href="view-recruitment-drives.jsp" class="dashboard-link">
            View Recruitment Drives
        </a>
    </header>

    <main class="content">

        <div class="page-heading">
            <h2>All Applicants</h2>
            <p>Applications received for your recruitment drives</p>
        </div>

        <!-- ================= ACTION MESSAGE ================= -->

        <%
            if ("updated".equalsIgnoreCase(actionResult)) {
        %>
            <div class="action-alert <%= "REJECTED".equalsIgnoreCase(actionStatus) ? "rejected" : "" %>" role="status">
                <i class="fa-solid <%= "REJECTED".equalsIgnoreCase(actionStatus)
                        ? "fa-circle-xmark"
                        : ("PENDING".equalsIgnoreCase(actionStatus)
                            ? "fa-rotate-left"
                            : "fa-circle-check") %>"></i>

                <span>
                    <%
                        if ("SHORTLISTED".equalsIgnoreCase(actionStatus)) {
                    %>
                        Applicant approved and moved to the shortlisted candidates.
                    <%
                        } else if ("REJECTED".equalsIgnoreCase(actionStatus)) {
                    %>
                        Applicant rejected. College review status remains unchanged.
                    <%
                        } else {
                    %>
                        Company decision has been reset to Pending.
                    <%
                        }
                    %>
                </span>
            </div>
        <%
            } else if ("blocked".equalsIgnoreCase(actionResult)) {
        %>
            <div class="action-alert warning" role="alert">
                <i class="fa-solid fa-clock"></i>

                <span>
                    <%
                        if ("COLLEGE_REJECTED".equalsIgnoreCase(actionStatus)) {
                    %>
                        This is an on-campus drive. The college has rejected this applicant, so the company cannot take the final decision.
                    <%
                        } else {
                    %>
                        This is an on-campus drive. The college must shortlist this applicant before the company can approve or reject the application.
                    <%
                        }
                    %>
                </span>
            </div>
        <%
            }
        %>

        <!-- ================= STATS ================= -->

        <section class="applicant-stats" aria-label="Applicant status summary">

            <div class="stat-card">
                <span class="stat-icon">
                    <i class="fa-solid fa-users"></i>
                </span>

                <span>
                    <strong class="stat-value"><%= totalApplicants %></strong>
                    <span class="stat-label">Total applicants</span>
                </span>
            </div>

            <div class="stat-card">
                <span class="stat-icon pending">
                    <i class="fa-regular fa-clock"></i>
                </span>

                <span>
                    <strong class="stat-value"><%= pendingApplicants %></strong>
                    <span class="stat-label">Pending review</span>
                </span>
            </div>

            <div class="stat-card">
                <span class="stat-icon shortlisted">
                    <i class="fa-solid fa-circle-check"></i>
                </span>

                <span>
                    <strong class="stat-value"><%= shortlistedApplicants %></strong>
                    <span class="stat-label">Shortlisted</span>
                </span>
            </div>

            <div class="stat-card">
                <span class="stat-icon rejected">
                    <i class="fa-solid fa-circle-xmark"></i>
                </span>

                <span>
                    <strong class="stat-value"><%= rejectedApplicants %></strong>
                    <span class="stat-label">Rejected</span>
                </span>
            </div>

        </section>

        <!-- ================= APPLICANT CARD ================= -->

        <div class="applicants-card">

            <div class="card-header">
                <h3>Applicant List</h3>
                <p>Students who have applied to opportunities posted by your company.</p>
            </div>

            <div class="table-wrapper">

                <div class="table-toolbar">

                    <div class="table-tools">
                        <input type="search"
                               id="applicantSearch"
                               placeholder="Search name, email, or job title"
                               aria-label="Search applicants">

                        <select id="statusFilter"
                                aria-label="Filter by application status">

                            <option value="">All statuses</option>
                            <option value="PENDING">Pending</option>
                            <option value="SHORTLISTED">Shortlisted</option>
                            <option value="REJECTED">Rejected</option>

                        </select>
                    </div>

                    <span class="result-count"
                          id="resultCount"
                          aria-live="polite"></span>

                </div>

                <table>

                    <thead>
                        <tr>
                            <th>Application ID</th>
                            <th>Student</th>
                            <th>Contact</th>
                            <th>Job Title</th>
                            <th>Drive Type</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                            <th>College Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>

<%
                    boolean hasApplicants = false;

                    while (rs.next()) {

                        hasApplicants = true;
                        applicantCount++;

                        int applicationId = rs.getInt("APPLICATION_ID");
                        String studentName = rs.getString("NAME");
                        String studentEmail = rs.getString("EMAIL");
                        String phone = rs.getString("PHONE");
                        String jobTitle = rs.getString("JOB_TITLE");
                        String driveType = rs.getString("DRIVE_TYPE");
                        Date appliedDate = rs.getDate("APPLIED_DATE");
                        String status = rs.getString("STATUS");
                        String collegeStatus =
                                rs.getString("COLLEGE_SHORTLIST_STATUS");

                        if (status == null || status.trim().isEmpty()) {
                            status = "PENDING";
                        }

                        if (collegeStatus == null
                                || collegeStatus.trim().isEmpty()) {
                            collegeStatus = "PENDING";
                        }

                        boolean onCampus = isOnCampus(driveType);
                        boolean collegeApproved =
                                "SHORTLISTED".equalsIgnoreCase(collegeStatus);

                        String statusClass = "status-default";

                        if ("SHORTLISTED".equalsIgnoreCase(status)) {
                            statusClass = "status-shortlisted";
                        } else if ("PENDING".equalsIgnoreCase(status)) {
                            statusClass = "status-pending";
                        } else if ("REJECTED".equalsIgnoreCase(status)) {
                            statusClass = "status-rejected";
                        }

                        /*
                         * Company Decision:
                         * For ON-CAMPUS drives, the company cannot make a
                         * decision until the college shortlists the student.
                         * Therefore the company-side status is displayed as
                         * AWAITING COLLEGE instead of PENDING.
                         *
                         * The actual APPLICATION.STATUS remains unchanged.
                         */
                        String companyDecisionDisplay = status;
                        String companyDecisionClass = statusClass;

                        if (onCampus && !collegeApproved) {
                            companyDecisionDisplay =
                                    "REJECTED".equalsIgnoreCase(collegeStatus)
                                            ? "NOT APPLICABLE"
                                            : "AWAITING COLLEGE";

                            companyDecisionClass =
                                    "REJECTED".equalsIgnoreCase(collegeStatus)
                                            ? "status-default"
                                            : "status-waiting";
                        }

                        String collegeStatusClass = "status-default";

                        if ("SHORTLISTED".equalsIgnoreCase(collegeStatus)) {
                            collegeStatusClass = "status-shortlisted";
                        } else if ("PENDING".equalsIgnoreCase(collegeStatus)) {
                            collegeStatusClass = "status-pending";
                        } else if ("REJECTED".equalsIgnoreCase(collegeStatus)) {
                            collegeStatusClass = "status-rejected";
                        }
%>

                        <tr class="applicant-row">

                            <td>
                                <strong>#<%= applicationId %></strong>
                            </td>

                            <td>
                                <div class="student-name">
                                    <%= esc(studentName) %>
                                </div>

                                <div class="student-email">
                                    <%= esc(studentEmail) %>
                                </div>
                            </td>

                            <td>
                                <%= esc(phone != null ? phone : "-") %>
                            </td>

                            <td>
                                <div class="job-title">
                                    <%= esc(jobTitle) %>
                                </div>
                            </td>

                            <td>
                                <%= esc(driveType) %>
                            </td>

                            <td>
                                <%= formatDate(appliedDate) %>
                            </td>

                            <td>
                                <span class="status <%= companyDecisionClass %>">
                                    <%= esc(companyDecisionDisplay) %>
                                </span>
                            </td>

                            <td>
                                <span class="status <%= collegeStatusClass %>">
                                    <%= esc(collegeStatus) %>
                                </span>
                            </td>

                            <td>
                                <div class="action-buttons">

<%
                                /*
                                 * ON-CAMPUS:
                                 * College approval is mandatory before company action.
                                 *
                                 * OFF-CAMPUS:
                                 * Company is the final decision maker.
                                 */

                                if (onCampus) {

                                    if (!collegeApproved) {

                                        if ("REJECTED".equalsIgnoreCase(collegeStatus)) {
%>
                                            <span class="action-blocked">
                                                Rejected by college
                                            </span>
<%
                                        } else {
%>
                                            <span class="action-waiting">
                                                Waiting for college approval
                                            </span>
<%
                                        }

                                    } else if ("PENDING".equalsIgnoreCase(status)) {
%>
                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Approve this applicant for the next recruitment stage?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="APPROVE">

                                            <button class="action-button approve-button"
                                                    type="submit">
                                                Approve
                                            </button>
                                        </form>

                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Reject this applicant?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="REJECT">

                                            <button class="action-button reject-button"
                                                    type="submit">
                                                Reject
                                            </button>
                                        </form>

                                    <%
                                    } else if ("SHORTLISTED".equalsIgnoreCase(status)) {
                                    %>
                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Revoke the company approval and return this applicant to Pending?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="REVOKE">

                                            <button class="action-button revoke-button"
                                                    type="submit">
                                                Revoke Approval
                                            </button>
                                        </form>

                                        <span class="action-current">
                                            Company approved
                                        </span>

                                    <%
                                    } else if ("REJECTED".equalsIgnoreCase(status)) {
                                    %>
                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Reconsider this rejected applicant and return to Pending?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="RECONSIDER">

                                            <button class="action-button approve-button"
                                                    type="submit">
                                                Reconsider
                                            </button>
                                        </form>

                                        <span class="action-current">
                                            Company rejected
                                        </span>
<%
                                    }
                                } else {

                                    /* OFF-CAMPUS: company has final decision */

                                    if ("PENDING".equalsIgnoreCase(status)) {
%>
                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Approve this applicant?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="APPROVE">

                                            <button class="action-button approve-button"
                                                    type="submit">
                                                Approve
                                            </button>
                                        </form>

                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Reject this applicant?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="REJECT">

                                            <button class="action-button reject-button"
                                                    type="submit">
                                                Reject
                                            </button>
                                        </form>

                                        <span class="drive-note">
                                            Company final decision
                                        </span>

<%
                                    } else if ("SHORTLISTED".equalsIgnoreCase(status)) {
%>
                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Revoke the company approval and return this applicant to Pending?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="REVOKE">

                                            <button class="action-button revoke-button"
                                                    type="submit">
                                                Revoke Approval
                                            </button>
                                        </form>

                                        <span class="action-current">
                                            Approved by company
                                        </span>

<%
                                    } else if ("REJECTED".equalsIgnoreCase(status)) {
%>
                                        <form method="post"
                                              action="company-applicants.jsp"
                                              onsubmit="return confirm('Reconsider this rejected applicant and return to Pending?');">

                                            <input type="hidden"
                                                   name="applicationId"
                                                   value="<%= applicationId %>">

                                            <input type="hidden"
                                                   name="action"
                                                   value="RECONSIDER">

                                            <button class="action-button approve-button"
                                                    type="submit">
                                                Reconsider
                                            </button>
                                        </form>

                                        <span class="action-current">
                                            Rejected by company
                                        </span>
<%
                                    }
                                }
%>

                                </div>
                            </td>

                        </tr>

<%
                    }

                    if (!hasApplicants) {
%>

                        <tr>
                            <td colspan="9">

                                <div class="empty-state">

                                    <div class="empty-icon">
                                        <i class="fa-solid fa-users"></i>
                                    </div>

                                    <h3>No Applicants Yet</h3>

                                    <p>
                                        No students have applied to your recruitment drives yet.
                                    </p>

                                    <a href="view-recruitment-drives.jsp"
                                       class="primary-button">

                                        <i class="fa-solid fa-briefcase"></i>
                                        View Recruitment Drives

                                    </a>

                                </div>

                            </td>
                        </tr>

<%
                    }
%>

                    </tbody>

                </table>

                <div class="filter-empty"
                     id="filterEmpty">
                    No applicants match your search or status filter.
                </div>

            </div>

        </div>

    </main>

</div>

<script>
(function () {

    const search = document.getElementById("applicantSearch");
    const statusFilter = document.getElementById("statusFilter");
    const rows = Array.from(document.querySelectorAll(".applicant-row"));
    const count = document.getElementById("resultCount");
    const noMatches = document.getElementById("filterEmpty");

    function filterApplicants() {

        const query = search.value.trim().toLowerCase();
        const status = statusFilter.value;
        let visible = 0;

        rows.forEach(function (row) {

            const matchesText =
                row.textContent.toLowerCase().includes(query);

            const rowStatus =
                row.cells[6].textContent.trim().toUpperCase();

            const matchesStatus =
                !status || rowStatus === status;

            const show =
                matchesText && matchesStatus;

            row.style.display =
                show ? "" : "none";

            if (show) {
                visible++;
            }
        });

        count.textContent =
            visible + (visible === 1 ? " applicant" : " applicants");

        noMatches.style.display =
            rows.length > 0 && visible === 0
                ? "block"
                : "none";
    }

    search.addEventListener("input", filterApplicants);
    statusFilter.addEventListener("change", filterApplicants);

    filterApplicants();

}());
</script>

</body>
</html>

<%
    } catch (Exception e) {

        e.printStackTrace();
%>

        <div style="
            padding:40px;
            font-family:Arial;
            color:#b42318;
            background:#fff1f0;
            margin:30px;
            border-radius:10px;
        ">

            <h2>Unable to load applicants</h2>

            <p>
                Please try again later.
            </p>

        </div>

<%
    } finally {

        try {
            if (rs != null) rs.close();
        } catch (Exception ignored) {}

        try {
            if (ps != null) ps.close();
        } catch (Exception ignored) {}

        try {
            if (con != null) con.close();
        } catch (Exception ignored) {}
    }
%>
