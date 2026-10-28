<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Locale, com.campusconnect.util.DBConnection" %>
<%!
private String esc(String value) {
    if (value == null) return "";
    return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
}

private String safeStatus(String value) {
    if (value == null || value.trim().isEmpty()) return "PENDING";
    return value.trim().toUpperCase(Locale.ROOT);
}
%>

<%
Integer companyId = (Integer) session.getAttribute("companyId");

if (companyId == null) {
    response.sendRedirect("company-login.jsp");
    return;
}

String companyName = (String) session.getAttribute("companyName");
if (companyName == null) companyName = "Company";

String companyInitial = companyName.trim().isEmpty()
        ? "C" : companyName.trim().substring(0, 1).toUpperCase();

int total = 0, pending = 0, approved = 0, rejected = 0;
boolean hasError = false;

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    con = DBConnection.getConnection();

    String sql =
        "SELECT A.APPLICATION_ID, A.STUDENT_ID, S.NAME, S.EMAIL, S.PHONE, " +
        "R.DRIVE_ID, R.DRIVE_TYPE, R.JOB_TITLE, A.APPLIED_DATE, " +
        "A.STATUS, A.COLLEGE_SHORTLIST_STATUS " +
        "FROM APPLICATION A " +
        "JOIN STUDENT S ON A.STUDENT_ID = S.STUDENT_ID " +
        "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
        "WHERE R.COMPANY_ID = ? " +
        "AND UPPER(TRIM(A.COLLEGE_SHORTLIST_STATUS)) = 'SHORTLISTED' " +
        "ORDER BY A.APPLICATION_ID DESC";

    ps = con.prepareStatement(sql);
    ps.setInt(1, companyId);
    rs = ps.executeQuery();
} catch (Exception e) {
    hasError = true;
    application.log("Error loading shortlisted candidates", e);
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shortlisted Candidates | CampusConnect</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --navy: #092f55;
            --navy-dark: #062847;
            --blue: #2679df;
            --blue-light: #edf5ff;
            --text: #182b43;
            --muted: #718096;
            --border: #e4eaf2;
            --page: #f5f7fb;
            --white: #ffffff;
            --green: #07875b;
            --amber: #b76b00;
            --red: #c53b45;
            --radius: 12px;
            --shadow: 0 3px 12px rgba(25, 50, 85, .035);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI",
                         Roboto, Arial, sans-serif;
            background: var(--page);
            color: var(--text);
            font-size: 14px;
            line-height: 1.5;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        button, input, select {
            font: inherit;
        }

        /* ================= SIDEBAR - MATCHED TO company-applicants.jsp ================= */
        .sidebar {
            font-family: Arial, Helvetica, sans-serif;
            line-height: normal;
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
        .menu-item.logout, .menu-item.logout i { color: #ff7d7d; }

        /* Main layout */
        .main {
            margin-left: 300px;
            min-height: 100vh;
        }

        .topbar {
            height: 66px;
            background: var(--white);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 9px;
            color: var(--muted);
            font-size: 12px;
        }

        .breadcrumb i {
            font-size: 10px;
            color: #a2adbd;
        }

        .breadcrumb .current {
            color: var(--text);
            font-weight: 650;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .account-chip {
            display: flex;
            align-items: center;
            gap: 10px;
            padding-left: 14px;
            border-left: 1px solid var(--border);
        }

        .avatar {
            width: 35px;
            height: 35px;
            display: grid;
            place-items: center;
            border-radius: 10px;
            background: #eaf2ff;
            color: #2268bd;
            font-size: 13px;
            font-weight: 800;
        }

        .account-name {
            max-width: 165px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 12px;
            font-weight: 700;
        }

        .account-role {
            color: var(--muted);
            font-size: 11px;
        }

        /* Page header */
        .content {
            max-width: 1600px;
            margin: 0 auto;
            padding: 28px 32px 36px;
        }

        .page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 24px;
        }

        .eyebrow {
            color: #347ed0;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.15px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .page-title {
            color: #14385d;
            font-size: 27px;
            line-height: 1.25;
            letter-spacing: -.65px;
            font-weight: 750;
        }

        .page-description {
            color: var(--muted);
            font-size: 13px;
            margin-top: 7px;
            max-width: 620px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            padding-top: 7px;
            flex-shrink: 0;
        }

        .btn {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            min-height: 38px;
            padding: 0 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: .18s ease;
            border: 1px solid var(--border);
            background: white;
            color: #354b65;
        }

        .btn:hover {
            background: #f8fafc;
            border-color: #cbd7e5;
        }

        .btn-primary {
            background: var(--blue);
            color: white;
            border-color: var(--blue);
        }

        .btn-primary:hover {
            background: #1768c8;
            color: white;
        }

        /* Intro strip */
        .section-intro {
            display: flex;
            align-items: center;
            gap: 13px;
            margin-bottom: 17px;
        }

        .intro-icon {
            display: grid;
            place-items: center;
            width: 42px;
            height: 42px;
            border-radius: 11px;
            background: #e8f1ff;
            color: #2679df;
            font-size: 17px;
            flex-shrink: 0;
        }

        .section-intro h2 {
            color: #183a5d;
            font-size: 17px;
            letter-spacing: -.25px;
            font-weight: 750;
        }

        .section-intro p {
            color: var(--muted);
            font-size: 12px;
            margin-top: 3px;
        }

        /* Statistics */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 15px;
            margin-bottom: 23px;
        }

        .stat-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 19px 18px;
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
            box-shadow: var(--shadow);
        }

        .stat-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: grid;
            place-items: center;
            font-size: 16px;
            flex-shrink: 0;
        }

        .stat-icon.blue { background: #eaf2ff; color: #2675db; }
        .stat-icon.amber { background: #fff4df; color: #b8780c; }
        .stat-icon.green { background: #e4f7ed; color: #13865a; }
        .stat-icon.red { background: #ffebec; color: #d4484e; }

        .stat-value {
            font-size: 25px;
            line-height: 1.15;
            font-weight: 800;
            color: #183a5d;
            letter-spacing: -.6px;
        }

        .stat-label {
            color: #718096;
            font-size: 11px;
            margin-top: 4px;
            white-space: nowrap;
        }

        /* Candidate panel */
        .panel {
            background: white;
            border: 1px solid var(--border);
            border-radius: 13px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .panel-heading {
            padding: 19px 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            border-bottom: 1px solid var(--border);
        }

        .panel-heading h2 {
            font-size: 15px;
            font-weight: 750;
            color: #1c3c5d;
        }

        .panel-heading p {
            font-size: 12px;
            color: var(--muted);
            margin-top: 4px;
        }

        .live-indicator {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            color: #64748b;
            font-size: 11px;
            white-space: nowrap;
        }

        .live-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #16a36b;
        }

        .toolbar {
            padding: 14px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            border-bottom: 1px solid var(--border);
        }

        .toolbar-left,
        .toolbar-right {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .search-box {
            position: relative;
            width: 300px;
            max-width: 100%;
        }

        .search-box i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #8998aa;
            font-size: 12px;
            pointer-events: none;
        }

        .search-box input {
            width: 100%;
            height: 37px;
            padding: 0 12px 0 35px;
            border: 1px solid #dce4ee;
            border-radius: 8px;
            outline: none;
            background: #fff;
            color: var(--text);
            font-size: 12px;
            transition: border-color .15s, box-shadow .15s;
        }

        .search-box input:focus,
        .filter-select:focus {
            border-color: #6ba6ef;
            box-shadow: 0 0 0 3px rgba(38,121,223,.09);
        }

        .search-box input::placeholder {
            color: #9aa7b7;
        }

        .filter-select {
            height: 37px;
            min-width: 145px;
            padding: 0 30px 0 11px;
            border: 1px solid #dce4ee;
            border-radius: 8px;
            outline: none;
            background: white;
            color: #475b72;
            font-size: 12px;
            cursor: pointer;
        }

        .result-count {
            color: #718096;
            font-size: 11px;
            white-space: nowrap;
        }

        .result-count strong {
            color: #344a63;
            font-weight: 750;
        }

        /* Table */
        .table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .candidate-table {
            width: 100%;
            min-width: 1000px;
            border-collapse: collapse;
            text-align: left;
        }

        .candidate-table thead {
            background: #f8fafc;
        }

        .candidate-table th {
            color: #687b92;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .55px;
            text-transform: uppercase;
            padding: 13px 15px;
            white-space: nowrap;
            border-bottom: 1px solid var(--border);
        }

        .candidate-table td {
            padding: 15px;
            border-bottom: 1px solid #edf1f6;
            vertical-align: middle;
            color: #44566d;
            font-size: 12px;
        }

        .candidate-table tbody tr {
            transition: background .15s ease;
        }

        .candidate-table tbody tr:hover {
            background: #f8fbff;
        }

        .candidate-table tbody tr:last-child td {
            border-bottom: none;
        }

        .app-id {
            color: #55718f;
            font-weight: 750;
            font-size: 11px;
            white-space: nowrap;
        }

        .student-cell {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 175px;
        }

        .student-avatar {
            width: 35px;
            height: 35px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 10px;
            background: #edf3fc;
            color: #386ba6;
            font-size: 12px;
            font-weight: 800;
        }

        .student-name {
            color: #233e5b;
            font-weight: 750;
            font-size: 12px;
            max-width: 160px;
            overflow-wrap: anywhere;
        }

        .student-id {
            color: #8794a5;
            font-size: 10px;
            margin-top: 2px;
        }

        .contact-email {
            color: #426a99;
            max-width: 190px;
            overflow-wrap: anywhere;
        }

        .contact-phone {
            color: #8794a5;
            font-size: 11px;
            margin-top: 3px;
        }

        .job-title {
            color: #2c4561;
            font-weight: 700;
            min-width: 125px;
        }

        .drive-type {
            display: inline-block;
            background: #f0f4f9;
            border: 1px solid #e3eaf2;
            color: #586d84;
            border-radius: 6px;
            padding: 4px 8px;
            font-size: 10px;
            font-weight: 700;
            white-space: nowrap;
        }

        .date-text {
            color: #65778c;
            white-space: nowrap;
        }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 9px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 750;
            white-space: nowrap;
        }

        .status::before {
            content: "";
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
        }

        .status-pending {
            color: #a76a05;
            background: #fff5df;
        }

        .status-approved {
            color: #087b53;
            background: #e5f7ed;
        }

        .status-rejected {
            color: #bd3e49;
            background: #ffebed;
        }

        .status-college {
            color: #1670bf;
            background: #eaf3ff;
        }

        .empty-state {
            padding: 54px 20px 58px;
            text-align: center;
        }

        .empty-icon {
            width: 64px;
            height: 64px;
            display: grid;
            place-items: center;
            border-radius: 18px;
            background: #eff5fd;
            color: #7a9bc5;
            margin: 0 auto 17px;
            font-size: 24px;
        }

        .empty-state h3 {
            color: #284461;
            font-size: 15px;
            font-weight: 750;
            margin-bottom: 6px;
        }

        .empty-state p {
            color: #7c8b9e;
            font-size: 12px;
            max-width: 380px;
            margin: 0 auto 17px;
            line-height: 1.7;
        }

        .empty-state .btn {
            min-height: 35px;
        }

        .no-results {
            display: none;
            text-align: center;
            padding: 38px 20px;
            color: #8190a2;
            font-size: 12px;
        }

        .panel-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            border-top: 1px solid var(--border);
            background: #fcfdff;
            color: #8491a2;
            font-size: 10px;
        }

        .panel-footer i {
            margin-right: 5px;
        }

        .page-footer {
            text-align: center;
            padding: 23px 0 0;
            color: #97a2b1;
            font-size: 10px;
        }

        /* Responsive */
        @media (max-width: 1250px) {
            .content {
                padding: 25px 22px 32px;
            }

            .topbar {
                padding: 0 22px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .stat-card {
                padding: 17px;
            }
        }

        @media (max-width: 900px) {
            .sidebar {
                width: 76px;
            }

            .sidebar-logo {
                padding: 23px 5px;
                margin: 0 8px;
                text-align: center;
            }

            .brand {
                font-size: 0;
            }

            .brand::before {
                content: "CC";
                font-size: 22px;
                letter-spacing: -1px;
            }

            .brand-name span,
            .brand-subtitle,
            .menu-section-title,
            .menu-item span,
            .account-details {
                display: none;
            }

            .sidebar-content,
            .sidebar-bottom {
                padding-left: 10px;
                padding-right: 10px;
            }

            .menu-item {
                justify-content: center;
                padding: 0;
                min-height: 43px;
            }

            .menu-item i {
                font-size: 17px;
            }

            .main {
                margin-left: 76px;
            }

            .account-chip {
                border-left: 0;
                padding-left: 0;
            }
        }

        @media (max-width: 600px) {
            .topbar {
                height: 56px;
                padding: 0 15px;
            }

            .content {
                padding: 22px 13px 28px;
            }

            .page-header {
                flex-direction: column;
                gap: 12px;
                margin-bottom: 22px;
            }

            .page-title {
                font-size: 23px;
            }

            .header-actions {
                padding-top: 0;
            }

            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 9px;
            }

            .stat-card {
                gap: 9px;
                padding: 13px 10px;
            }

            .stat-icon {
                width: 34px;
                height: 34px;
                font-size: 13px;
            }

            .stat-value {
                font-size: 21px;
            }

            .stat-label {
                white-space: normal;
                line-height: 1.35;
                font-size: 10px;
            }

            .panel-heading {
                padding: 16px;
            }

            .toolbar {
                padding: 13px;
            }

            .toolbar-left,
            .toolbar-right,
            .search-box {
                width: 100%;
            }

            .filter-select {
                flex: 1;
                min-width: 0;
            }

            .live-indicator {
                display: none;
            }

            .panel-footer {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="brand-name">Campus<span>Connect</span></div>
        <div class="brand-subtitle">COMPANY PORTAL</div>
    </div>

    <nav class="sidebar-content">
        <div class="menu-section-title">OVERVIEW</div>

        <a href="company-dashboard.jsp" class="menu-item">
            <i class="fa-solid fa-house"></i><span>Dashboard</span>
        </a>

        <a href="company-profile.jsp" class="menu-item">
            <i class="fa-solid fa-building"></i><span>Company Profile</span>
        </a>

        <div class="menu-section-title">RECRUITMENT</div>

        <a href="recruitment-drive.jsp" class="menu-item">
            <i class="fa-solid fa-plus"></i><span>Create Drive</span>
        </a>

        <a href="view-recruitment-drives.jsp" class="menu-item">
            <i class="fa-solid fa-briefcase"></i><span>Recruitment Drives</span>
        </a>

        <a href="company-applicants.jsp" class="menu-item">
            <i class="fa-solid fa-users"></i><span>Applicants</span>
        </a>

        <a href="company-shortlisted.jsp" class="menu-item active">
            <i class="fa-solid fa-star"></i><span>Shortlisted Candidates</span>
        </a>

        <a href="company-interviews.jsp" class="menu-item">
            <i class="fa-regular fa-square"></i><span>Interviews</span>
        </a>

        <a href="company-offers.jsp" class="menu-item">
            <i class="fa-regular fa-gem"></i><span>Offers &amp; Selections</span>
        </a>

        <div class="menu-section-title">ANALYTICS</div>

        <a href="company-reports.jsp" class="menu-item">
            <i class="fa-solid fa-chart-column"></i><span>Reports &amp; Analytics</span>
        </a>

        <a href="company-analytics.jsp" class="menu-item">
            <i class="fa-solid fa-chart-line"></i><span>Analytics Insights</span>
        </a>
    </nav>

    <div class="sidebar-bottom">
        <a href="company-settings.jsp" class="menu-item">
            <i class="fa-solid fa-gear"></i><span>Settings</span>
        </a>

        <a href="CompanyLogoutServlet" class="menu-item logout">
            <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
        </a>
    </div>
</aside>

<!-- Main content -->
<main class="main">
    <header class="topbar">
        <div class="breadcrumb">
            <span>Company Portal</span>
            <i class="fa-solid fa-chevron-right"></i>
            <span>Recruitment</span>
            <i class="fa-solid fa-chevron-right"></i>
            <span class="current">Shortlisted Candidates</span>
        </div>

        <div class="topbar-right">
            <div class="account-chip">
                <div class="avatar"><%= esc(companyInitial) %></div>
                <div class="account-details">
                    <div class="account-name"><%= esc(companyName) %></div>
                    <div class="account-role">Company Account</div>
                </div>
            </div>
        </div>
    </header>

    <div class="content">
        <section class="page-header">
            <div>
                <div class="eyebrow">Recruitment Management</div>
                <h1 class="page-title">Shortlisted Candidates</h1>
                <p class="page-description">
                    Review candidates shortlisted by their colleges across your recruitment drives.
                </p>
            </div>

            <div class="header-actions">
                <a href="company-applicants.jsp" class="btn">
                    <i class="fa-solid fa-users"></i>
                    View All Applicants
                </a>
            </div>
        </section>

        <section class="section-intro">
            <div class="intro-icon">
                <i class="fa-solid fa-user-check"></i>
            </div>
            <div>
                <h2>Candidate Overview</h2>
                <p>Track college shortlisting and your company's current review status.</p>
            </div>
        </section>

        <!-- Statistics -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div>
                    <div class="stat-value" id="totalStat">0</div>
                    <div class="stat-label">Shortlisted applicants</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon amber">
                    <i class="fa-regular fa-clock"></i>
                </div>
                <div>
                    <div class="stat-value" id="pendingStat">0</div>
                    <div class="stat-label">Awaiting company review</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon green">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <div>
                    <div class="stat-value" id="approvedStat">0</div>
                    <div class="stat-label">Company approved</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon red">
                    <i class="fa-solid fa-circle-xmark"></i>
                </div>
                <div>
                    <div class="stat-value" id="rejectedStat">0</div>
                    <div class="stat-label">Company rejected</div>
                </div>
            </div>
        </section>

        <!-- Candidate table -->
        <section class="panel">
            <div class="panel-heading">
                <div>
                    <h2>Shortlisted Candidate List</h2>
                    <p>View applicant details and current recruitment status.</p>
                </div>
                <div class="live-indicator">
                    <span class="live-dot"></span>
                    College-shortlisted records
                </div>
            </div>

            <div class="toolbar">
                <div class="toolbar-left">
                    <div class="search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input
                            type="search"
                            id="candidateSearch"
                            placeholder="Search name, email, job title or application ID..."
                            aria-label="Search shortlisted candidates">
                    </div>
                </div>

                <div class="toolbar-right">
                    <select id="decisionFilter" class="filter-select"
                            aria-label="Filter by company decision">
                        <option value="all">All decisions</option>
                        <option value="pending">Awaiting review</option>
                        <option value="approved">Approved</option>
                        <option value="rejected">Rejected</option>
                    </select>

                    <select id="driveFilter" class="filter-select"
                            aria-label="Filter by drive type">
                        <option value="all">All drive types</option>
                        <option value="on campus">On Campus</option>
                        <option value="off campus">Off Campus</option>
                    </select>
                </div>
            </div>

            <% if (hasError) { %>
                <div class="empty-state">
                    <div class="empty-icon" style="color:#c53b45;background:#fff0f0;">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>
                    <h3>Unable to load candidates</h3>
                    <p>
                        Something went wrong while retrieving the shortlisted candidates.
                        Please refresh the page or check the server logs.
                    </p>
                    <button class="btn btn-primary" onclick="window.location.reload()">
                        <i class="fa-solid fa-rotate-right"></i> Try Again
                    </button>
                </div>
            <% } else { %>
                <div class="table-wrap">
                    <table class="candidate-table" id="candidateTable">
                        <thead>
                            <tr>
                                <th>Application ID</th>
                                <th>Candidate</th>
                                <th>Contact Details</th>
                                <th>Job Title</th>
                                <th>Drive Type</th>
                                <th>Applied Date</th>
                                <th>Company Decision</th>
                                <th>College Status</th>
                            </tr>
                        </thead>
                        <tbody id="candidateTableBody">
                        <%
                        try {
                            while (rs != null && rs.next()) {
                                total++;

                                int applicationId = rs.getInt("APPLICATION_ID");
                                int studentId = rs.getInt("STUDENT_ID");
                                String studentName = rs.getString("NAME");
                                String email = rs.getString("EMAIL");
                                String phone = rs.getString("PHONE");
                                String jobTitle = rs.getString("JOB_TITLE");
                                String driveType = rs.getString("DRIVE_TYPE");
                                String decision = safeStatus(rs.getString("STATUS"));
                                String collegeStatus = safeStatus(
                                        rs.getString("COLLEGE_SHORTLIST_STATUS")
                                );

                                if ("SHORTLISTED".equals(decision)) {
                                    approved++;
                                } else if ("REJECTED".equals(decision)) {
                                    rejected++;
                                } else {
                                    pending++;
                                }

                                String decisionClass = "status-pending";
                                String decisionLabel = "Awaiting Review";

                                if ("SHORTLISTED".equals(decision)) {
                                    decisionClass = "status-approved";
                                    decisionLabel = "Approved";
                                } else if ("REJECTED".equals(decision)) {
                                    decisionClass = "status-rejected";
                                    decisionLabel = "Rejected";
                                }

                                String appliedDate = "—";
                                java.sql.Date date = rs.getDate("APPLIED_DATE");

                                if (date != null) {
                                    appliedDate = new SimpleDateFormat("dd MMM yyyy")
                                            .format(date);
                                }

                                String initials = "S";

                                if (studentName != null && !studentName.trim().isEmpty()) {
                                    String[] parts = studentName.trim().split("\\s+");
                                    initials = parts[0].substring(0, 1).toUpperCase();

                                    if (parts.length > 1) {
                                        initials += parts[parts.length - 1]
                                                .substring(0, 1).toUpperCase();
                                    }
                                }

                                String safeDriveType = driveType == null ? "" : driveType;
                        %>
                            <tr class="candidate-row"
                                data-decision="<%= "SHORTLISTED".equals(decision) ? "approved" :
                                    "REJECTED".equals(decision) ? "rejected" : "pending" %>"
                                data-drive="<%= esc(safeDriveType.toLowerCase(Locale.ROOT)) %>">
                                <td>
                                    <span class="app-id">#APP-<%= applicationId %></span>
                                </td>
                                <td>
                                    <div class="student-cell">
                                        <div class="student-avatar"><%= esc(initials) %></div>
                                        <div>
                                            <div class="student-name"><%= esc(studentName) %></div>
                                            <div class="student-id">Student ID: <%= studentId %></div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="contact-email"><%= esc(email) %></div>
                                    <div class="contact-phone"><%= esc(phone) %></div>
                                </td>
                                <td>
                                    <div class="job-title"><%= esc(jobTitle) %></div>
                                </td>
                                <td>
                                    <span class="drive-type"><%= esc(driveType) %></span>
                                </td>
                                <td>
                                    <span class="date-text"><%= esc(appliedDate) %></span>
                                </td>
                                <td>
                                    <span class="status <%= decisionClass %>">
                                        <%= decisionLabel %>
                                    </span>
                                </td>
                                <td>
                                    <span class="status status-college">
                                        <i class="fa-solid fa-check" style="font-size:9px;"></i>
                                        <%= esc(collegeStatus) %>
                                    </span>
                                </td>
                            </tr>
                        <%
                            }
                        } catch (Exception e) {
                            hasError = true;
                            application.log("Error reading shortlisted candidate records", e);
                        }
                        %>
                        </tbody>
                    </table>
                </div>

                <div class="no-results" id="noResults">
                    <i class="fa-solid fa-magnifying-glass"
                       style="font-size:22px;display:block;margin-bottom:10px;color:#a0afc0;"></i>
                    No candidates match your search or selected filters.
                </div>

                <% if (total == 0 && !hasError) { %>
                    <div class="empty-state" id="emptyState">
                        <div class="empty-icon">
                            <i class="fa-solid fa-user-group"></i>
                        </div>
                        <h3>No shortlisted candidates yet</h3>
                        <p>
                            Candidates will appear here once their colleges shortlist
                            applications for your recruitment drives.
                        </p>
                        <a href="company-applicants.jsp" class="btn btn-primary">
                            <i class="fa-solid fa-users"></i>
                            View All Applicants
                        </a>
                    </div>
                <% } %>

                <div class="panel-footer">
                    <span>
                        <i class="fa-solid fa-shield-halved"></i>
                        Showing candidates associated with your company's recruitment drives.
                    </span>
                    <span id="footerCount"><%= total %> candidate(s)</span>
                </div>
            <% } %>
        </section>

        <footer class="page-footer">
            CampusConnect Company Portal &middot; Recruitment Management
        </footer>
    </div>
</main>

<script>
(function () {
    const searchInput = document.getElementById("candidateSearch");
    const decisionFilter = document.getElementById("decisionFilter");
    const driveFilter = document.getElementById("driveFilter");
    const rows = Array.from(document.querySelectorAll(".candidate-row"));
    const totalStat = document.getElementById("totalStat");
    const pendingStat = document.getElementById("pendingStat");
    const approvedStat = document.getElementById("approvedStat");
    const rejectedStat = document.getElementById("rejectedStat");
    const noResults = document.getElementById("noResults");
    const footerCount = document.getElementById("footerCount");

    function updateCandidates() {
        if (!searchInput || !decisionFilter || !driveFilter) return;

        const query = searchInput.value.trim().toLowerCase();
        const selectedDecision = decisionFilter.value;
        const selectedDrive = driveFilter.value;
        let visible = 0;
        let pending = 0;
        let approved = 0;
        let rejected = 0;

        rows.forEach(function (row) {
            const text = row.innerText.toLowerCase();
            const decision = row.dataset.decision || "pending";
            const drive = row.dataset.drive || "";
            const matchesSearch = text.includes(query);
            const matchesDecision =
                    selectedDecision === "all" || decision === selectedDecision;
            const matchesDrive =
                    selectedDrive === "all" || drive.includes(selectedDrive);
            const show = matchesSearch && matchesDecision && matchesDrive;

            row.style.display = show ? "" : "none";

            if (show) {
                visible++;

                if (decision === "approved") approved++;
                else if (decision === "rejected") rejected++;
                else pending++;
            }
        });

        // Statistics reflect the current filtered results.
        totalStat.textContent = visible;
        pendingStat.textContent = pending;
        approvedStat.textContent = approved;
        rejectedStat.textContent = rejected;

        if (footerCount) {
            footerCount.textContent = visible + " candidate(s)";
        }

        if (noResults) {
            noResults.style.display =
                    rows.length > 0 && visible === 0 ? "block" : "none";
        }
    }

    if (searchInput) searchInput.addEventListener("input", updateCandidates);
    if (decisionFilter) decisionFilter.addEventListener("change", updateCandidates);
    if (driveFilter) driveFilter.addEventListener("change", updateCandidates);

    updateCandidates();
})();
</script>

<%
try { if (rs != null) rs.close(); } catch (Exception ignored) {}
try { if (ps != null) ps.close(); } catch (Exception ignored) {}
try { if (con != null) con.close(); } catch (Exception ignored) {}
%>

</body>
</html>