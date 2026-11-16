<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
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

    String status = request.getParameter("status");
    if (status == null || status.trim().isEmpty()) {
        status = "success";
    }

    String appIdStr = request.getParameter("appId");
    String driveIdStr = request.getParameter("driveId");

    int appId = 0;
    int driveId = 0;
    try {
        if (appIdStr != null && !appIdStr.trim().isEmpty()) {
            appId = Integer.parseInt(appIdStr.trim());
        }
        if (driveIdStr != null && !driveIdStr.trim().isEmpty()) {
            driveId = Integer.parseInt(driveIdStr.trim());
        }
    } catch (Exception ignore) {}

    String jobTitle = "Campus Placement Drive";
    String companyName = "Corporate Partner";
    String driveType = "On-Campus";
    double salary = 0.0;
    String location = "Pan India";

    if (driveId > 0) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (
                Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "CAMPUSCONNECT",
                    "campus123"
                );
                PreparedStatement ps = con.prepareStatement(
                    "SELECT R.JOB_TITLE, R.DRIVE_TYPE, R.SALARY, R.LOCATION, C.COMPANY_NAME " +
                    "FROM RECRUITMENT_DRIVE R " +
                    "JOIN COMPANY C ON R.COMPANY_ID = C.COMPANY_ID " +
                    "WHERE R.DRIVE_ID = ?"
                )
            ) {
                ps.setInt(1, driveId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        jobTitle = rs.getString("JOB_TITLE");
                        driveType = rs.getString("DRIVE_TYPE");
                        salary = rs.getDouble("SALARY");
                        location = rs.getString("LOCATION");
                        companyName = rs.getString("COMPANY_NAME");

                        if (jobTitle == null) jobTitle = "Placement Drive";
                        if (driveType == null) driveType = "On-Campus";
                        if (companyName == null) companyName = "Corporate Hiring Partner";
                        if (location == null) location = "Multiple Locations";
                    }
                }
            }
        } catch (Exception e) {
            application.log("Error loading drive info for application status", e);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Application Status | CampusConnect</title>

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
    --success: #059669;
    --success-bg: #ecfdf5;
    --success-border: #a7f3d0;
    --warning: #d97706;
    --warning-bg: #fffbeb;
    --warning-border: #fde68a;
    --danger: #dc2626;
    --danger-bg: #fef2f2;
    --danger-border: #fecaca;
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
    padding: 40px 36px 60px;
    max-width: 900px;
    width: calc(100% - 88px);
    margin-right: auto;
}

/* STATUS CARD CONTAINER */
.status-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-md);
    overflow: hidden;
    animation: slideUp 0.35s ease-out;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(16px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.status-hero {
    padding: 44px 36px 36px;
    text-align: center;
    border-bottom: 1px solid var(--border-color);
}

.status-hero.success {
    background: linear-gradient(180deg, #f0fdf4 0%, #ffffff 100%);
}

.status-hero.warning {
    background: linear-gradient(180deg, #fffbeb 0%, #ffffff 100%);
}

.status-hero.danger {
    background: linear-gradient(180deg, #fef2f2 0%, #ffffff 100%);
}

.status-icon-wrapper {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: grid;
    place-items: center;
    font-size: 38px;
    margin: 0 auto 20px;
    box-shadow: 0 10px 25px -6px rgba(0,0,0,0.1);
}

.status-hero.success .status-icon-wrapper {
    background: var(--success-bg);
    color: var(--success);
    border: 2px solid var(--success-border);
}

.status-hero.warning .status-icon-wrapper {
    background: var(--warning-bg);
    color: var(--warning);
    border: 2px solid var(--warning-border);
}

.status-hero.danger .status-icon-wrapper {
    background: var(--danger-bg);
    color: var(--danger);
    border: 2px solid var(--danger-border);
}

.status-title {
    font-size: 26px;
    font-weight: 800;
    color: var(--text-main);
    letter-spacing: -0.5px;
    margin-bottom: 8px;
}

.status-subtitle {
    font-size: 14.5px;
    color: var(--text-muted);
    max-width: 580px;
    margin: 0 auto;
    line-height: 1.55;
}

/* DETAILS SECTION */
.status-body {
    padding: 32px 36px;
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
    background: #f8fafc;
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 22px;
    margin-bottom: 28px;
}

.detail-item {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.detail-label {
    font-size: 11.5px;
    font-weight: 700;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: .5px;
}

.detail-value {
    font-size: 15px;
    font-weight: 800;
    color: var(--text-main);
    display: flex;
    align-items: center;
    gap: 6px;
}

.badge-pill {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 11.5px;
    font-weight: 700;
}

.badge-campus {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}

.badge-pending {
    background: #fffbeb;
    color: #b45309;
    border: 1px solid #fde68a;
}

/* RECRUITMENT TIMELINE */
.timeline-card {
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 20px 24px;
    background: white;
    margin-bottom: 30px;
}

.timeline-title {
    font-size: 13.5px;
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.timeline-steps {
    display: flex;
    justify-content: space-between;
    position: relative;
}

.timeline-steps::before {
    content: '';
    position: absolute;
    top: 14px;
    left: 20px;
    right: 20px;
    height: 3px;
    background: #e2e8f0;
    z-index: 1;
}

.timeline-step {
    position: relative;
    z-index: 2;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    flex: 1;
}

.step-node {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: white;
    border: 3px solid #cbd5e1;
    display: grid;
    place-items: center;
    font-size: 12px;
    color: #64748b;
    margin-bottom: 8px;
    transition: .2s;
}

.timeline-step.completed .step-node {
    background: var(--success);
    border-color: var(--success);
    color: white;
}

.timeline-step.active .step-node {
    background: var(--primary);
    border-color: var(--primary);
    color: white;
    box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.2);
}

.step-label {
    font-size: 12px;
    font-weight: 700;
    color: var(--text-main);
}

.step-sub {
    font-size: 11px;
    color: var(--text-muted);
    margin-top: 2px;
}

/* ACTIONS */
.status-actions {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 14px;
    flex-wrap: wrap;
}

.btn {
    padding: 12px 24px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.2s ease;
    cursor: pointer;
    text-decoration: none;
    border: none;
}

.btn-primary {
    background: var(--primary);
    color: white;
    box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
}
.btn-primary:hover {
    background: var(--primary-hover);
    transform: translateY(-2px);
    box-shadow: 0 6px 18px rgba(37, 99, 235, 0.35);
}

.btn-secondary {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid var(--border-color);
}
.btn-secondary:hover {
    background: #e2e8f0;
    color: var(--text-main);
}

.btn-outline {
    background: transparent;
    color: var(--text-muted);
    border: 1px solid var(--border-color);
}
.btn-outline:hover {
    background: #f8fafc;
    color: var(--text-main);
}

/* FOOTER */
.footer {
    text-align: center;
    color: var(--text-muted);
    font-size: 12px;
    padding: 28px 10px;
    margin-top: 30px;
}

/* RESPONSIVE */
@media(max-width: 768px) {
    .main {
        margin-left: 70px;
        width: calc(100% - 70px);
        padding: 24px 16px;
    }
    .sidebar { width: 70px; }
    .side-link { width: 56px; }
    .status-body { padding: 24px 20px; }
    .status-hero { padding: 32px 20px; }
    .timeline-steps { flex-direction: column; gap: 16px; align-items: flex-start; }
    .timeline-steps::before { display: none; }
    .timeline-step { flex-direction: row; gap: 12px; text-align: left; }
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

    <div class="status-card">
        <% if ("success".equalsIgnoreCase(status)) { %>
            <!-- SUCCESS STATE -->
            <div class="status-hero success">
                <div class="status-icon-wrapper">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <h1 class="status-title">Application Submitted Successfully!</h1>
                <p class="status-subtitle">
                    Your profile and dossier have been delivered to <strong><%= companyName %></strong>. You can follow your application progress and upcoming interview schedules in your dashboard.
                </p>
            </div>

            <div class="status-body">
                <!-- DRIVE DETAILS GRID -->
                <div class="details-grid">
                    <% if (appId > 0) { %>
                    <div class="detail-item">
                        <span class="detail-label">Application ID</span>
                        <div class="detail-value">
                            <span style="font-family: monospace; color: var(--primary);">#APP-<%= appId %></span>
                        </div>
                    </div>
                    <% } %>

                    <div class="detail-item">
                        <span class="detail-label">Target Role</span>
                        <div class="detail-value"><%= jobTitle %></div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Company</span>
                        <div class="detail-value"><%= companyName %></div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Drive Model</span>
                        <div class="detail-value">
                            <span class="badge-pill badge-campus"><i class="fa-solid fa-building"></i> <%= driveType %></span>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Initial Status</span>
                        <div class="detail-value">
                            <span class="badge-pill badge-pending"><i class="fa-regular fa-clock"></i> Under Review</span>
                        </div>
                    </div>

                    <% if (salary > 0) { %>
                    <div class="detail-item">
                        <span class="detail-label">Offered CTC</span>
                        <div class="detail-value">&#8377;<%= String.format("%,.0f", salary) %> / yr</div>
                    </div>
                    <% } %>
                </div>

                <!-- TIMELINE STEPPER -->
                <div class="timeline-card">
                    <div class="timeline-title">
                        <i class="fa-solid fa-timeline" style="color: var(--primary);"></i>
                        Hiring Process Stages
                    </div>
                    <div class="timeline-steps">
                        <div class="timeline-step completed">
                            <div class="step-node"><i class="fa-solid fa-check"></i></div>
                            <div class="step-label">Application Sent</div>
                            <div class="step-sub">Profile Registered</div>
                        </div>
                        <div class="timeline-step active">
                            <div class="step-node">2</div>
                            <div class="step-label">Shortlisting</div>
                            <div class="step-sub">Under Review</div>
                        </div>
                        <div class="timeline-step">
                            <div class="step-node">3</div>
                            <div class="step-label">Interviews</div>
                            <div class="step-sub">Upcoming</div>
                        </div>
                        <div class="timeline-step">
                            <div class="step-node">4</div>
                            <div class="step-label">Offer Rollout</div>
                            <div class="step-sub">Final Decision</div>
                        </div>
                    </div>
                </div>

                <!-- ACTIONS -->
                <div class="status-actions">
                    <a href="student_application_view.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-paper-plane"></i> View My Applications
                    </a>
                    <a href="student_drive_view.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-briefcase"></i> Explore Other Drives
                    </a>
                    <a href="student_dashboard.jsp" class="btn btn-outline">
                        <i class="fa-solid fa-house"></i> Dashboard
                    </a>
                </div>
            </div>

        <% } else if ("already_applied".equalsIgnoreCase(status)) { %>
            <!-- ALREADY APPLIED STATE -->
            <div class="status-hero warning">
                <div class="status-icon-wrapper">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <h1 class="status-title">Already Applied For This Opportunity</h1>
                <p class="status-subtitle">
                    You have already submitted an application for <strong><%= jobTitle %></strong> at <strong><%= companyName %></strong>. Duplicate applications are prevented.
                </p>
            </div>

            <div class="status-body">
                <div class="details-grid">
                    <div class="detail-item">
                        <span class="detail-label">Role</span>
                        <div class="detail-value"><%= jobTitle %></div>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Company</span>
                        <div class="detail-value"><%= companyName %></div>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Application State</span>
                        <div class="detail-value">
                            <span class="badge-pill badge-pending">Active Application</span>
                        </div>
                    </div>
                </div>

                <div class="status-actions">
                    <a href="student_application_view.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-list-check"></i> Check Application Status
                    </a>
                    <a href="student_drive_view.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-arrow-left"></i> Back to Placement Drives
                    </a>
                </div>
            </div>

        <% } else { %>
            <!-- GENERIC ERROR STATE -->
            <div class="status-hero danger">
                <div class="status-icon-wrapper">
                    <i class="fa-solid fa-circle-xmark"></i>
                </div>
                <h1 class="status-title">Application Submission Failed</h1>
                <p class="status-subtitle">
                    We encountered an issue registering your application for this recruitment drive. Please try again or contact your college placement coordinator.
                </p>
            </div>

            <div class="status-body">
                <div class="status-actions">
                    <a href="student_drive_view.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-arrow-rotate-left"></i> Return to Placement Drives
                    </a>
                    <a href="student_dashboard.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-house"></i> Back to Dashboard
                    </a>
                </div>
            </div>
        <% } %>

    </div>

    <footer class="footer">
        CampusConnect Student Portal &bull; Campus Recruitment &amp; Placement Management System
    </footer>

</main>

</body>
</html>
