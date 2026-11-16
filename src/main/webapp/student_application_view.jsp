<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
    HttpSession session1 = request.getSession(false);

    if (session1 == null || session1.getAttribute("studentId") == null) {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = (Integer) session1.getAttribute("studentId");
    String studentName = "Student";
    String profileImage = null;

    if (session1.getAttribute("studentName") != null) {
        studentName = session1.getAttribute("studentName").toString();
    }

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );
            PreparedStatement ps = con.prepareStatement(
                "SELECT NAME, PROFILE_IMAGE FROM STUDENT WHERE STUDENT_ID = ?"
            )
        ) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbName = rs.getString("NAME");
                    if (dbName != null && !dbName.trim().isEmpty()) {
                        studentName = dbName;
                        session1.setAttribute("studentName", dbName);
                    }
                    profileImage = rs.getString("PROFILE_IMAGE");
                }
            }
        }
    } catch (Exception e) {
        application.log("Unable to load student info", e);
    }

    String firstLetter = "S";
    if (studentName != null && !studentName.trim().isEmpty()) {
        firstLetter = studentName.trim().substring(0, 1).toUpperCase();
    }

    // Flash Messages
    String flashMsg = (String) session1.getAttribute("applyMsg");
    session1.removeAttribute("applyMsg");
    String flashErr = (String) session1.getAttribute("applyError");
    session1.removeAttribute("applyError");

    class AppRecord {
        int applicationId;
        int driveId;
        String companyName;
        String jobTitle;
        String driveType;
        java.sql.Date appliedDate;
        String status;
        String collegeShortlistStatus;
    }

    List<AppRecord> appList = new ArrayList<>();
    int totalCount = 0;
    int shortlistedCount = 0;
    int pendingCount = 0;
    int selectedCount = 0;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );
            PreparedStatement ps = con.prepareStatement(
                "SELECT A.APPLICATION_ID, A.DRIVE_ID, C.COMPANY_NAME, R.JOB_TITLE, R.DRIVE_TYPE, " +
                "A.APPLIED_DATE, A.STATUS, A.COLLEGE_SHORTLIST_STATUS " +
                "FROM APPLICATION A " +
                "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
                "JOIN COMPANY C ON R.COMPANY_ID = C.COMPANY_ID " +
                "WHERE A.STUDENT_ID = ? " +
                "ORDER BY A.APPLICATION_ID DESC"
            )
        ) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AppRecord rec = new AppRecord();
                    rec.applicationId = rs.getInt("APPLICATION_ID");
                    rec.driveId = rs.getInt("DRIVE_ID");
                    rec.companyName = rs.getString("COMPANY_NAME");
                    rec.jobTitle = rs.getString("JOB_TITLE");
                    rec.driveType = rs.getString("DRIVE_TYPE");
                    rec.appliedDate = rs.getDate("APPLIED_DATE");
                    rec.status = rs.getString("STATUS");
                    rec.collegeShortlistStatus = rs.getString("COLLEGE_SHORTLIST_STATUS");

                    if (rec.driveType == null) rec.driveType = "On-Campus";
                    if (rec.status == null) rec.status = "APPLIED";
                    if (rec.collegeShortlistStatus == null) rec.collegeShortlistStatus = "PENDING";

                    totalCount++;
                    if ("SELECTED".equalsIgnoreCase(rec.status)) {
                        selectedCount++;
                    } else if ("SHORTLISTED".equalsIgnoreCase(rec.status) || "SHORTLISTED".equalsIgnoreCase(rec.collegeShortlistStatus)) {
                        shortlistedCount++;
                    } else if ("REJECTED".equalsIgnoreCase(rec.status) || "REJECTED".equalsIgnoreCase(rec.collegeShortlistStatus)) {
                        // rejected
                    } else {
                        pendingCount++;
                    }

                    appList.add(rec);
                }
            }
        }
    } catch (Exception e) {
        application.log("Error loading applications for student: " + studentId, e);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Applications | CampusConnect</title>

<!-- Google Fonts & FontAwesome Icons -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --bg-color: #f8fafc;
    --card-bg: #ffffff;
    --primary: #2563eb;
    --primary-hover: #1d4ed8;
    --primary-light: #eff6ff;
    --text-main: #0f172a;
    --text-muted: #64748b;
    --border-color: #e2e8f0;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
    --shadow-md: 0 10px 25px -5px rgba(0,0,0,0.05);
    --radius-lg: 16px;
    --radius-md: 12px;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Plus Jakarta Sans', sans-serif;
}

body {
    background-color: var(--bg-color);
    color: var(--text-main);
    display: flex;
    min-height: 100vh;
}

a {
    text-decoration: none;
    color: inherit;
}

/* TOP NAVIGATION */
.topbar {
    height: 76px;
    background: linear-gradient(110deg, #08142d, #142b52);
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 28px;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 20;
    box-shadow: 0 5px 20px rgba(8, 21, 47, .16);
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 23px;
    font-weight: 800;
    letter-spacing: -.6px;
}

.brand-mark {
    width: 40px;
    height: 40px;
    display: grid;
    place-items: center;
    background: linear-gradient(135deg, #327ff4, #62b5ff);
    border-radius: 12px;
    font-size: 22px;
    color: white;
}

.brand span {
    color: #79b7ff;
}

.top-right {
    display: flex;
    align-items: center;
    gap: 18px;
}

.student-info {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 14px;
    font-weight: 600;
}

.profile-link {
    display: block;
    width: 43px;
    height: 43px;
    border-radius: 50%;
    overflow: hidden;
    border: 2px solid #9ccaff;
    background: #244775;
    flex-shrink: 0;
}

.profile-photo {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.profile-initial {
    width: 100%;
    height: 100%;
    display: grid;
    place-items: center;
    color: white;
    font-size: 17px;
    font-weight: bold;
}

.logout {
    padding: 9px 16px;
    border: 1px solid rgba(255,255,255,0.3);
    border-radius: 9px;
    color: white;
    font-size: 13px;
    transition: .2s;
}

.logout:hover {
    background: var(--primary);
    border-color: var(--primary);
}

/* SIDEBAR */
.sidebar {
    position: fixed;
    left: 0;
    top: 76px;
    bottom: 0;
    width: 88px;
    background: linear-gradient(180deg, #0b1936, #112347);
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    padding: 20px 8px;
    z-index: 10;
    border-right: 1px solid rgba(255,255,255,0.05);
}

.side-link {
    width: 70px;
    min-height: 63px;
    border-radius: 12px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 6px;
    color: #b7c5dd;
    font-size: 10px;
    text-align: center;
    transition: .2s;
}

.side-icon {
    font-size: 20px;
    line-height: 1.2;
}

.side-link:hover,
.side-link.active {
    color: white;
    background: linear-gradient(135deg, #1764d9, #348cf7);
    box-shadow: 0 6px 18px rgba(35, 119, 239, .28);
}

/* MAIN CONTENT */
.main {
    margin-left: 88px;
    margin-top: 76px;
    padding: 32px 36px 40px;
    max-width: 1320px;
    width: calc(100% - 88px);
}

/* PAGE HEADER BAR */
.page-header-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    flex-wrap: wrap;
    gap: 16px;
}

.page-title h1 {
    font-size: 24px;
    font-weight: 800;
    color: var(--text-main);
    display: flex;
    align-items: center;
    gap: 10px;
}

.page-title p {
    font-size: 13.5px;
    color: var(--text-muted);
    margin-top: 4px;
}

.btn-header {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 18px;
    border-radius: 10px;
    font-size: 13.5px;
    font-weight: 700;
    transition: .2s;
}

.btn-primary {
    background: var(--primary);
    color: white;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
}
.btn-primary:hover { background: var(--primary-hover); transform: translateY(-1px); }

.btn-secondary {
    background: #e2e8f0;
    color: #334155;
}
.btn-secondary:hover { background: #cbd5e1; }

/* ALERTS */
.alert {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 18px;
    border-radius: 10px;
    font-size: 13.5px;
    font-weight: 600;
    margin-bottom: 22px;
}
.alert-success {
    background: #ecfdf5;
    color: #065f46;
    border: 1px solid #a7f3d0;
}
.alert-error {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
}

/* KPI CARDS */
.kpi-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 18px;
    margin-bottom: 26px;
}

.kpi-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    padding: 20px 22px;
    display: flex;
    align-items: center;
    gap: 16px;
    transition: transform .2s ease;
}
.kpi-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
}

.kpi-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    display: grid;
    place-items: center;
    font-size: 20px;
    flex-shrink: 0;
}

.kpi-icon.blue { background: #eff6ff; color: #2563eb; }
.kpi-icon.amber { background: #fffbeb; color: #d97706; }
.kpi-icon.green { background: #ecfdf5; color: #059669; }
.kpi-icon.purple { background: #f5f3ff; color: #7c3aed; }

.kpi-info h3 {
    font-size: 12px;
    font-weight: 700;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: .5px;
}

.kpi-info .kpi-value {
    font-size: 22px;
    font-weight: 800;
    color: var(--text-main);
    margin-top: 3px;
    line-height: 1.2;
}

.kpi-info .kpi-sub {
    font-size: 11.5px;
    color: var(--text-muted);
    margin-top: 4px;
}

/* TABLE CARD */
.content-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    overflow: hidden;
    margin-bottom: 28px;
}

.table-header {
    padding: 20px 24px;
    border-bottom: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 12px;
}

.table-header h2 {
    font-size: 16.5px;
    font-weight: 800;
    color: var(--text-main);
    display: flex;
    align-items: center;
    gap: 8px;
}

.count-badge {
    background: #f1f5f9;
    color: #475569;
    font-size: 12px;
    font-weight: 700;
    padding: 3px 10px;
    border-radius: 20px;
    border: 1px solid #e2e8f0;
}

.table-responsive {
    width: 100%;
    overflow-x: auto;
}

.data-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 13.5px;
}

.data-table th {
    background: #f8fafc;
    color: #475569;
    font-weight: 700;
    padding: 14px 20px;
    border-bottom: 1px solid var(--border-color);
    white-space: nowrap;
    text-transform: uppercase;
    font-size: 11.5px;
    letter-spacing: .5px;
}

.data-table td {
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    color: var(--text-main);
    vertical-align: middle;
}

.data-table tbody tr:hover {
    background: #f8fafc;
}

.data-table tbody tr:last-child td {
    border-bottom: none;
}

/* BADGES & PILLS */
.id-badge {
    display: inline-block;
    padding: 4px 8px;
    background: #f1f5f9;
    color: #64748b;
    border-radius: 6px;
    font-weight: 700;
    font-size: 12px;
    font-family: monospace;
}

.company-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.company-avatar {
    width: 38px;
    height: 38px;
    border-radius: 10px;
    background: linear-gradient(135deg, #1e3a8a, #3b82f6);
    color: white;
    display: grid;
    place-items: center;
    font-size: 15px;
    font-weight: 800;
    flex-shrink: 0;
}

.company-name {
    font-weight: 700;
    color: var(--text-main);
    font-size: 14px;
}

.drive-tag {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 11px;
    font-weight: 700;
    padding: 2px 7px;
    border-radius: 4px;
    margin-top: 3px;
}

.drive-tag.on-campus {
    background: #eff6ff;
    color: #2563eb;
    border: 1px solid #bfdbfe;
}

.drive-tag.off-campus {
    background: #f0fdfa;
    color: #0d9488;
    border: 1px solid #99f6e4;
}

.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 5px 11px;
    border-radius: 20px;
    font-size: 11.5px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: .3px;
}

.badge-applied {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}

.badge-pending {
    background: #fffbeb;
    color: #b45309;
    border: 1px solid #fde68a;
}

.badge-shortlisted {
    background: #ecfdf5;
    color: #059669;
    border: 1px solid #a7f3d0;
}

.badge-selected {
    background: #f5f3ff;
    color: #7c3aed;
    border: 1px solid #ddd6fe;
}

.badge-rejected {
    background: #fef2f2;
    color: #dc2626;
    border: 1px solid #fecaca;
}

/* ACTIONS */
.action-btn {
    padding: 6px 12px;
    border-radius: 8px;
    font-size: 12.5px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    transition: .15s;
    border: none;
    cursor: pointer;
    text-decoration: none;
}

.btn-withdraw {
    background: #fef2f2;
    color: #dc2626;
    border: 1px solid #fecaca;
}
.btn-withdraw:hover { background: #fee2e2; }

/* EMPTY STATE */
.empty-state {
    padding: 50px 24px;
    text-align: center;
    color: var(--text-muted);
}

.empty-state-icon {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: #f1f5f9;
    color: #94a3b8;
    display: grid;
    place-items: center;
    font-size: 26px;
    margin: 0 auto 16px;
}

.empty-state h3 {
    font-size: 16px;
    font-weight: 700;
    color: var(--text-main);
    margin-bottom: 6px;
}

.empty-state p {
    font-size: 13.5px;
    max-width: 440px;
    margin: 0 auto 20px;
    line-height: 1.5;
}

/* FOOTER */
.footer {
    text-align: center;
    color: var(--text-muted);
    font-size: 12px;
    padding: 24px 10px;
    border-top: 1px solid var(--border-color);
    margin-top: 40px;
}

/* RESPONSIVE */
@media(max-width: 768px) {
    .main {
        margin-left: 70px;
        width: calc(100% - 70px);
        padding: 24px 20px;
    }
    .sidebar { width: 70px; }
    .side-link { width: 56px; }
}
</style>
</head>

<body>

<!-- TOPBAR -->
<header class="topbar">
    <a href="student_dashboard.jsp" class="brand">
        <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
        <div>Campus<span>Connect</span></div>
    </a>

    <div class="top-right">
        <div class="student-info">
            <a href="student_profile.jsp" class="profile-link" title="Open My Profile">
                <% if (profileImage != null && !profileImage.trim().isEmpty()) { %>
                    <img class="profile-photo"
                         src="profile_images/<%= URLEncoder.encode(profileImage, StandardCharsets.UTF_8.name()) %>"
                         alt="Student Profile">
                <% } else { %>
                    <div class="profile-initial"><%= firstLetter %></div>
                <% } %>
            </a>
            <span class="student-name"><%= studentName %></span>
        </div>
        <a href="student_logout.jsp" class="logout">Logout</a>
    </div>
</header>

<!-- SIDEBAR -->
<aside class="sidebar">
    <a href="student_dashboard.jsp" class="side-link">
        <span class="side-icon"><i class="fa-solid fa-house"></i></span>
        <span>Home</span>
    </a>
    <a href="student_academic_view.jsp" class="side-link">
        <span class="side-icon"><i class="fa-solid fa-book-open"></i></span>
        <span>Academics</span>
    </a>
    <a href="student_drive_view.jsp" class="side-link active">
        <span class="side-icon"><i class="fa-solid fa-briefcase"></i></span>
        <span>Placements</span>
    </a>
    <a href="student_profile.jsp" class="side-link">
        <span class="side-icon"><i class="fa-solid fa-gear"></i></span>
        <span>Profile</span>
    </a>
</aside>

<!-- MAIN CONTENT -->
<main class="main">

    <div class="page-header-bar">
        <div class="page-title">
            <h1><i class="fa-solid fa-paper-plane" style="color: var(--primary);"></i> My Job Applications</h1>
            <p>Track your recruitment drive applications, shortlists, interview eligibility, and offers in real time.</p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="student_drive_view.jsp" class="btn-header btn-primary">
                <i class="fa-solid fa-magnifying-glass"></i> Explore Placement Drives
            </a>
            <a href="student_dashboard.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- FLASH MESSAGES -->
    <% if (flashMsg != null) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check" style="font-size: 18px;"></i>
            <%= flashMsg %>
        </div>
    <% } %>

    <% if (flashErr != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-triangle-exclamation" style="font-size: 18px;"></i>
            <%= flashErr %>
        </div>
    <% } %>

    <!-- KPI STATS CARDS -->
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-icon blue">
                <i class="fa-solid fa-paper-plane"></i>
            </div>
            <div class="kpi-info">
                <h3>Total Applied</h3>
                <div class="kpi-value"><%= totalCount %></div>
                <div class="kpi-sub">Placement drive submissions</div>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon amber">
                <i class="fa-solid fa-hourglass-half"></i>
            </div>
            <div class="kpi-info">
                <h3>Under Review</h3>
                <div class="kpi-value"><%= pendingCount %></div>
                <div class="kpi-sub">Awaiting shortlisting</div>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon green">
                <i class="fa-solid fa-user-check"></i>
            </div>
            <div class="kpi-info">
                <h3>Shortlisted</h3>
                <div class="kpi-value"><%= shortlistedCount %></div>
                <div class="kpi-sub">Invited to interview rounds</div>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon purple">
                <div style="font-size: 18px;"><i class="fa-solid fa-award"></i></div>
            </div>
            <div class="kpi-info">
                <h3>Offers &amp; Selected</h3>
                <div class="kpi-value"><%= selectedCount %></div>
                <div class="kpi-sub">Final selections achieved</div>
            </div>
        </div>
    </div>

    <!-- TABLE CARD -->
    <div class="content-card">
        <div class="table-header">
            <h2>
                <i class="fa-solid fa-list-check" style="color: var(--primary);"></i>
                Application Tracking History
            </h2>
            <span class="count-badge"><%= totalCount %> Application<%= totalCount == 1 ? "" : "s" %></span>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>App ID</th>
                        <th>Company &amp; Organization</th>
                        <th>Job Title &amp; Drive</th>
                        <th>Applied On</th>
                        <th>College Status</th>
                        <th>Company Decision</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (!appList.isEmpty()) {
                    for (AppRecord rec : appList) {
                        String compInitial = "C";
                        if (rec.companyName != null && !rec.companyName.trim().isEmpty()) {
                            compInitial = rec.companyName.trim().substring(0, 1).toUpperCase();
                        }

                        boolean isOnCampus = !"Off-Campus".equalsIgnoreCase(rec.driveType) && !"Off Campus".equalsIgnoreCase(rec.driveType);
                        boolean canWithdraw = ("APPLIED".equalsIgnoreCase(rec.status) || "PENDING".equalsIgnoreCase(rec.status)) &&
                                              ("PENDING".equalsIgnoreCase(rec.collegeShortlistStatus));
                %>
                    <tr>
                        <td>
                            <span class="id-badge">#APP-<%= rec.applicationId %></span>
                        </td>
                        <td>
                            <div class="company-cell">
                                <div class="company-avatar"><%= compInitial %></div>
                                <div>
                                    <div class="company-name"><%= rec.companyName %></div>
                                    <div style="font-size: 11px; color: var(--text-muted);">Drive #<%= rec.driveId %></div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div style="font-weight: 700; color: var(--text-main);"><%= rec.jobTitle %></div>
                            <span class="drive-tag <%= isOnCampus ? "on-campus" : "off-campus" %>">
                                <i class="fa-solid <%= isOnCampus ? "fa-building-columns" : "fa-globe" %>"></i>
                                <%= rec.driveType %>
                            </span>
                        </td>
                        <td>
                            <span style="font-size: 13px; color: var(--text-muted);">
                                <i class="fa-regular fa-calendar" style="margin-right: 4px;"></i>
                                <%= rec.appliedDate != null ? rec.appliedDate.toString() : "N/A" %>
                            </span>
                        </td>
                        <td>
                            <% if ("SHORTLISTED".equalsIgnoreCase(rec.collegeShortlistStatus)) { %>
                                <span class="status-badge badge-shortlisted">
                                    <i class="fa-solid fa-circle-check"></i> Shortlisted
                                </span>
                            <% } else if ("REJECTED".equalsIgnoreCase(rec.collegeShortlistStatus)) { %>
                                <span class="status-badge badge-rejected">
                                    <i class="fa-solid fa-circle-xmark"></i> Rejected
                                </span>
                            <% } else if (!isOnCampus) { %>
                                <span class="status-badge badge-applied" style="background:#f8fafc; color:#64748b; border-color:#e2e8f0;">
                                    Direct
                                </span>
                            <% } else { %>
                                <span class="status-badge badge-pending">
                                    <i class="fa-regular fa-clock"></i> Pending
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("SELECTED".equalsIgnoreCase(rec.status)) { %>
                                <span class="status-badge badge-selected">
                                    <i class="fa-solid fa-award"></i> Selected
                                </span>
                            <% } else if ("SHORTLISTED".equalsIgnoreCase(rec.status)) { %>
                                <span class="status-badge badge-shortlisted">
                                    <i class="fa-solid fa-circle-check"></i> Shortlisted
                                </span>
                            <% } else if ("REJECTED".equalsIgnoreCase(rec.status)) { %>
                                <span class="status-badge badge-rejected">
                                    <i class="fa-solid fa-circle-xmark"></i> Rejected
                                </span>
                            <% } else { %>
                                <span class="status-badge badge-applied">
                                    <i class="fa-solid fa-paper-plane"></i> Applied
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <% if (canWithdraw) { %>
                                <form method="post" action="studentApply" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to withdraw your application for <%= rec.jobTitle %> (#APP-<%= rec.applicationId %>)?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="applicationId" value="<%= rec.applicationId %>">
                                    <button type="submit" class="action-btn btn-withdraw" title="Withdraw application">
                                        <i class="fa-regular fa-trash-can"></i> Withdraw
                                    </button>
                                </form>
                            <% } else { %>
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 600;">
                                    <i class="fa-solid fa-lock" style="font-size: 11px;"></i> In Review
                                </span>
                            <% } %>
                        </td>
                    </tr>
                <%
                    }
                } else {
                %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <i class="fa-regular fa-paper-plane"></i>
                                </div>
                                <h3>No Placement Applications Yet</h3>
                                <p>You haven't applied to any active campus recruitment drives. Discover upcoming opportunities tailored to your branch and academic profile.</p>
                                <a href="student_drive_view.jsp" class="btn-header btn-primary">
                                    <i class="fa-solid fa-briefcase"></i> Explore Placement Drives
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer">
        CampusConnect Student Portal &bull; Campus Recruitment &amp; Placement Management System
    </footer>

</main>

</body>
</html>
