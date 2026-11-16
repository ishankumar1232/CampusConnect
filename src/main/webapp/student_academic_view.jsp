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

    String studentName = "Student";
    String profileImage = null;

    if (session1.getAttribute("studentName") != null) {
        studentName = session1.getAttribute("studentName").toString();
    }

    int studentId = (Integer) session1.getAttribute("studentId");

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
    String flashMsg = (String) session1.getAttribute("academicMsg");
    session1.removeAttribute("academicMsg");
    String flashErr = (String) session1.getAttribute("academicError");
    session1.removeAttribute("academicError");

    // Fetch Academic Records
    class AcademicRecord {
        int id;
        String qualification;
        int year;
        double percentage;
        double cgpa;
        int backlogs;
    }

    List<AcademicRecord> academicList = new ArrayList<>();
    double maxCgpa = 0.0;
    double maxPct = 0.0;
    int totalBacklogs = 0;
    String highestDegree = "None";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );
            PreparedStatement ps = con.prepareStatement(
                "SELECT ACADEMIC_ID, QUALIFICATION, YEAR, PERCENTAGE, CGPA, BACKLOGS " +
                "FROM STUDENT_ACADEMIC " +
                "WHERE STUDENT_ID=? " +
                "ORDER BY YEAR DESC, ACADEMIC_ID DESC"
            )
        ) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AcademicRecord rec = new AcademicRecord();
                    rec.id = rs.getInt("ACADEMIC_ID");
                    rec.qualification = rs.getString("QUALIFICATION");
                    rec.year = rs.getInt("YEAR");
                    rec.percentage = rs.getDouble("PERCENTAGE");
                    rec.cgpa = rs.getDouble("CGPA");
                    rec.backlogs = rs.getInt("BACKLOGS");

                    if (rec.cgpa > maxCgpa) maxCgpa = rec.cgpa;
                    if (rec.percentage > maxPct) maxPct = rec.percentage;
                    totalBacklogs += rec.backlogs;

                    if (academicList.isEmpty() && rec.qualification != null) {
                        highestDegree = rec.qualification;
                    }

                    academicList.add(rec);
                }
            }
        }
    } catch (Exception e) {
        application.log("Error fetching academic records", e);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Academic Details | CampusConnect</title>

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
.kpi-icon.purple { background: #f5f3ff; color: #7c3aed; }
.kpi-icon.green { background: #ecfdf5; color: #059669; }
.kpi-icon.amber { background: #fffbeb; color: #d97706; }
.kpi-icon.red { background: #fef2f2; color: #dc2626; }

.kpi-info h3 {
    font-size: 12px;
    font-weight: 700;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: .5px;
}

.kpi-info .kpi-value {
    font-size: 20px;
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

.qual-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.qual-icon {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    background: #eff6ff;
    color: #2563eb;
    display: grid;
    place-items: center;
    font-size: 16px;
    flex-shrink: 0;
}

.qual-title {
    font-weight: 700;
    color: var(--text-main);
    font-size: 14px;
}

.qual-level {
    font-size: 11.5px;
    color: var(--text-muted);
    margin-top: 2px;
}

.score-badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 4px 10px;
    border-radius: 8px;
    font-weight: 700;
    font-size: 12.5px;
}

.score-badge.cgpa {
    background: #f5f3ff;
    color: #7c3aed;
    border: 1px solid #ddd6fe;
}

.score-badge.pct {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}

.year-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    color: #334155;
    font-weight: 600;
    font-size: 13px;
}

.status-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 5px 11px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
}

.status-pill.clean {
    background: #ecfdf5;
    color: #059669;
    border: 1px solid #a7f3d0;
}

.status-pill.backlog {
    background: #fef2f2;
    color: #dc2626;
    border: 1px solid #fecaca;
}

/* ACTIONS */
.action-group {
    display: flex;
    align-items: center;
    gap: 8px;
}

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

.btn-edit {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}
.btn-edit:hover { background: #dbeafe; }

.btn-delete {
    background: #fef2f2;
    color: #dc2626;
    border: 1px solid #fecaca;
}
.btn-delete:hover { background: #fee2e2; }

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

/* QUICK GUIDELINES GRID */
.guidance-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 20px;
    margin-top: 10px;
}

.guidance-card {
    background: white;
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    padding: 22px 24px;
    box-shadow: var(--shadow-sm);
}

.guidance-card h3 {
    font-size: 15px;
    font-weight: 700;
    color: var(--text-main);
    display: flex;
    align-items: center;
    gap: 9px;
    margin-bottom: 12px;
}

.guidance-card p {
    font-size: 13px;
    color: var(--text-muted);
    line-height: 1.55;
}

.guidance-links {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 14px;
}

.guide-pill {
    background: #f8fafc;
    color: #334155;
    border: 1px solid #e2e8f0;
    font-size: 12px;
    font-weight: 600;
    padding: 5px 12px;
    border-radius: 8px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: .15s;
}
.guide-pill:hover {
    background: var(--primary-light);
    color: var(--primary);
    border-color: #bfdbfe;
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
    <a href="student_academic_view.jsp" class="side-link active">
        <span class="side-icon"><i class="fa-solid fa-book-open"></i></span>
        <span>Academics</span>
    </a>
    <a href="student_drive_view.jsp" class="side-link">
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
            <h1><i class="fa-solid fa-graduation-cap" style="color: var(--primary);"></i> Academic Qualifications</h1>
            <p>Review, update, and manage your educational background, scores, and backlog clearance records.</p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="student_academic.jsp" class="btn-header btn-primary">
                <i class="fa-solid fa-plus"></i> Add Academic Details
            </a>
            <a href="student_dashboard.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
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

    <!-- KPI STATS -->
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-icon blue">
                <i class="fa-solid fa-user-graduate"></i>
            </div>
            <div class="kpi-info">
                <h3>Latest / Top Degree</h3>
                <div class="kpi-value"><%= highestDegree %></div>
                <div class="kpi-sub"><%= academicList.size() %> qualification<%= academicList.size() == 1 ? "" : "s" %> recorded</div>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon purple">
                <i class="fa-solid fa-award"></i>
            </div>
            <div class="kpi-info">
                <h3>Highest CGPA</h3>
                <div class="kpi-value"><%= maxCgpa > 0 ? String.format("%.2f", maxCgpa) : "N/A" %></div>
                <div class="kpi-sub">Scale of 10.0</div>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon amber">
                <i class="fa-solid fa-percent"></i>
            </div>
            <div class="kpi-info">
                <h3>Top Percentage</h3>
                <div class="kpi-value"><%= maxPct > 0 ? String.format("%.2f%%", maxPct) : "N/A" %></div>
                <div class="kpi-sub">Aggregate score</div>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon <%= totalBacklogs == 0 ? "green" : "red" %>">
                <i class="fa-solid <%= totalBacklogs == 0 ? "fa-circle-check" : "fa-triangle-exclamation" %>"></i>
            </div>
            <div class="kpi-info">
                <h3>Backlog Status</h3>
                <div class="kpi-value" style="color: <%= totalBacklogs == 0 ? "#059669" : "#dc2626" %>;">
                    <%= totalBacklogs == 0 ? "All Cleared" : totalBacklogs + " Active" %>
                </div>
                <div class="kpi-sub"><%= totalBacklogs == 0 ? "100% Drive Eligible" : "May affect company shortlisting" %></div>
            </div>
        </div>
    </div>

    <!-- TABLE CARD -->
    <div class="content-card">
        <div class="table-header">
            <h2>
                <i class="fa-solid fa-book-open" style="color: var(--primary);"></i>
                Educational History Records
            </h2>
            <span class="count-badge"><%= academicList.size() %> Record<%= academicList.size() == 1 ? "" : "s" %></span>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Record ID</th>
                        <th>Qualification &amp; Degree</th>
                        <th>Passing Year</th>
                        <th>CGPA (10.0)</th>
                        <th>Percentage</th>
                        <th>Backlogs</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (!academicList.isEmpty()) {
                    for (AcademicRecord rec : academicList) {
                %>
                    <tr>
                        <td>
                            <span class="id-badge">#AC-<%= rec.id %></span>
                        </td>
                        <td>
                            <div class="qual-cell">
                                <div class="qual-icon">
                                    <i class="fa-solid fa-graduation-cap"></i>
                                </div>
                                <div>
                                    <div class="qual-title"><%= rec.qualification %></div>
                                    <div class="qual-level">Registered Qualification</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="year-badge">
                                <i class="fa-regular fa-calendar-check" style="color: var(--primary);"></i>
                                <%= rec.year %>
                            </span>
                        </td>
                        <td>
                            <span class="score-badge cgpa">
                                <i class="fa-solid fa-star" style="font-size: 11px;"></i>
                                <%= String.format("%.2f", rec.cgpa) %>
                            </span>
                        </td>
                        <td>
                            <span class="score-badge pct">
                                <%= String.format("%.2f%%", rec.percentage) %>
                            </span>
                        </td>
                        <td>
                            <% if (rec.backlogs == 0) { %>
                                <span class="status-pill clean">
                                    <i class="fa-solid fa-check"></i> 0 (Clean)
                                </span>
                            <% } else { %>
                                <span class="status-pill backlog">
                                    <i class="fa-solid fa-triangle-exclamation"></i> <%= rec.backlogs %> Backlog<%= rec.backlogs == 1 ? "" : "s" %>
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <div class="action-group">
                                <a href="student_academic.jsp?editId=<%= rec.id %>" class="action-btn btn-edit" title="Edit this record">
                                    <i class="fa-regular fa-pen-to-square"></i> Edit
                                </a>
                                <form method="post" action="studentAcademic" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to delete this qualification record (#AC-<%= rec.id %>)?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="academicId" value="<%= rec.id %>">
                                    <button type="submit" class="action-btn btn-delete" title="Delete this record">
                                        <i class="fa-regular fa-trash-can"></i> Delete
                                    </button>
                                </form>
                            </div>
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
                                    <i class="fa-solid fa-graduation-cap"></i>
                                </div>
                                <h3>No Academic Qualifications Found</h3>
                                <p>You have not added any academic details yet. Companies require your degree, marks, and passing year to evaluate job eligibility.</p>
                                <a href="student_academic.jsp" class="btn-header btn-primary">
                                    <i class="fa-solid fa-plus"></i> Add Your First Qualification
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- QUICK GUIDANCE -->
    <div class="guidance-grid">
        <div class="guidance-card">
            <h3><i class="fa-solid fa-lightbulb" style="color: #f59e0b;"></i> Placement Eligibility Rules</h3>
            <p>Most premier hiring partners require a minimum aggregate of <strong>60% or 6.5 CGPA</strong> across 10th, 12th, and Degree examinations, with <strong>0 active backlogs</strong> at the time of final selection.</p>
        </div>

        <div class="guidance-card">
            <h3><i class="fa-solid fa-compass" style="color: var(--primary);"></i> Complete Profile Checklist</h3>
            <p>Ensure your student profile is 100% complete before applying to on-campus or off-campus recruitment drives:</p>
            <div class="guidance-links">
                <a href="student_resume_view.jsp" class="guide-pill"><i class="fa-solid fa-file-pdf"></i> My Resume</a>
                <a href="student_project_view.jsp" class="guide-pill"><i class="fa-solid fa-code"></i> Projects Portfolio</a>
                <a href="student_skill_view.jsp" class="guide-pill"><i class="fa-solid fa-wand-magic-sparkles"></i> Technical Skills</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        CampusConnect Student Portal &bull; Campus Recruitment &amp; Placement Management System
    </footer>

</main>

</body>
</html>
