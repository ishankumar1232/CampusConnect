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

    String editId = request.getParameter("editId");
    boolean editMode = (editId != null && !editId.trim().isEmpty());

    String qualificationValue = "";
    String yearValue = "";
    String percentageValue = "";
    String cgpaValue = "";
    String backlogsValue = "0";

    if (editMode) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (
                Connection con2 = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "CAMPUSCONNECT",
                    "campus123"
                );
                PreparedStatement ps2 = con2.prepareStatement(
                    "SELECT QUALIFICATION, YEAR, PERCENTAGE, CGPA, BACKLOGS FROM STUDENT_ACADEMIC WHERE ACADEMIC_ID=? AND STUDENT_ID=?"
                )
            ) {
                ps2.setInt(1, Integer.parseInt(editId.trim()));
                ps2.setInt(2, studentId);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        qualificationValue = rs2.getString("QUALIFICATION");
                        yearValue = String.valueOf(rs2.getInt("YEAR"));
                        percentageValue = String.valueOf(rs2.getDouble("PERCENTAGE"));
                        cgpaValue = String.valueOf(rs2.getDouble("CGPA"));
                        backlogsValue = String.valueOf(rs2.getInt("BACKLOGS"));

                        if (qualificationValue == null) qualificationValue = "";
                    }
                }
            }
        } catch (Exception e) {
            application.log("Error loading academic record for edit", e);
        }
    }

    String flashMsg = (String) session1.getAttribute("academicMsg");
    session1.removeAttribute("academicMsg");
    String flashErr = (String) session1.getAttribute("academicError");
    session1.removeAttribute("academicError");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= editMode ? "Edit Academic Record" : "Add Academic Details" %> | CampusConnect</title>

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

/* TOPBAR */
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
    max-width: 1280px;
    width: calc(100% - 88px);
}

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
    font-size: 13px;
    font-weight: 700;
    transition: .2s;
}

.btn-primary {
    background: var(--primary);
    color: white;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
}
.btn-primary:hover { background: var(--primary-hover); }

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

/* TWO COLUMN LAYOUT */
.academic-layout {
    display: grid;
    grid-template-columns: minmax(0, 1.45fr) minmax(0, 1fr);
    gap: 26px;
    align-items: start;
}

.card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    padding: 28px 32px;
}

.card-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 22px;
    padding-bottom: 14px;
    border-bottom: 1px solid var(--border-color);
}

.card-head h2 {
    font-size: 17px;
    font-weight: 800;
    color: var(--text-main);
    display: flex;
    align-items: center;
    gap: 10px;
}

/* FORM STYLING */
.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    font-size: 13.5px;
    font-weight: 700;
    color: var(--text-main);
    margin-bottom: 8px;
}

.input-wrapper {
    position: relative;
    display: flex;
    align-items: center;
}

.input-icon {
    position: absolute;
    left: 14px;
    color: #94a3b8;
    font-size: 15px;
    pointer-events: none;
}

.form-control {
    width: 100%;
    padding: 12px 16px 12px 42px;
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    background: #f8fafc;
    font-size: 14px;
    color: var(--text-main);
    transition: all 0.2s ease;
    outline: none;
}

.form-control:focus {
    border-color: var(--primary);
    background: #ffffff;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

.inline-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}

.quick-pills {
    display: flex;
    flex-wrap: wrap;
    gap: 7px;
    margin-top: 9px;
}

.pill-item {
    background: #f1f5f9;
    color: #475569;
    font-size: 11.5px;
    font-weight: 600;
    padding: 4px 10px;
    border-radius: 6px;
    cursor: pointer;
    border: 1px solid #e2e8f0;
    transition: .15s;
}

.pill-item:hover {
    background: #dbeafe;
    color: #1d4ed8;
    border-color: #bfdbfe;
}

.field-hint {
    font-size: 12px;
    color: var(--text-muted);
    margin-top: 6px;
    display: flex;
    align-items: center;
    gap: 5px;
}

.form-actions {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 28px;
}

.btn-submit {
    padding: 12px 26px;
    border-radius: 10px;
    background: var(--primary);
    color: white;
    border: none;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: .2s;
}
.btn-submit:hover { background: var(--primary-hover); }

.btn-reset {
    padding: 12px 20px;
    border-radius: 10px;
    background: #f1f5f9;
    color: #475569;
    border: 1px solid var(--border-color);
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    text-decoration: none;
    transition: .2s;
}
.btn-reset:hover { background: #e2e8f0; }

/* GUIDELINES CARD */
.guide-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.guide-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
}

.guide-icon {
    width: 34px;
    height: 34px;
    border-radius: 8px;
    background: var(--primary-light);
    color: var(--primary);
    display: grid;
    place-items: center;
    font-size: 14px;
    flex-shrink: 0;
}

.guide-text h4 {
    font-size: 13.5px;
    font-weight: 700;
    color: var(--text-main);
    margin-bottom: 3px;
}

.guide-text p {
    font-size: 12.5px;
    color: var(--text-muted);
    line-height: 1.45;
}

/* RESPONSIVE */
@media(max-width: 992px) {
    .academic-layout {
        grid-template-columns: 1fr;
    }
}

@media(max-width: 768px) {
    .main {
        margin-left: 70px;
        width: calc(100% - 70px);
        padding: 24px 20px;
    }
    .sidebar { width: 70px; }
    .side-link { width: 56px; }
    .inline-grid { grid-template-columns: 1fr; }
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
            <h1><i class="fa-solid fa-graduation-cap" style="color: var(--primary);"></i> <%= editMode ? "Update Academic Record" : "Add Academic Details" %></h1>
            <p>Enter your degree, passing year, marks, and active backlogs to qualify for recruitment drives.</p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="student_academic_view.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-list-check"></i> View Academic Records
            </a>
            <a href="student_dashboard.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

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

    <div class="academic-layout">

        <!-- FORM CARD -->
        <section class="card">
            <div class="card-head">
                <h2><i class="fa-solid fa-pen-to-square" style="color: var(--primary);"></i> <%= editMode ? "Edit Record" : "Academic Qualifications Entry" %></h2>
                <span style="font-size: 12px; color: var(--text-muted);"><strong style="color: #ef4444;">*</strong> Mandatory</span>
            </div>

            <form name="academicForm" id="academicForm" method="post" action="studentAcademic" onsubmit="return validateAcademicForm();">
                <input type="hidden" name="academicId" value="<%= editId == null ? "" : editId %>">

                <!-- QUALIFICATION -->
                <div class="form-group">
                    <label for="qualificationInput">Degree / Qualification <span style="color:#ef4444;">*</span></label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-user-graduate input-icon"></i>
                        <input type="text" id="qualificationInput" name="qualification" class="form-control"
                               value="<%= qualificationValue %>" placeholder="e.g. B.Tech (Computer Science)" required>
                    </div>
                    <div class="quick-pills">
                        <span class="pill-item" onclick="setQual('B.Tech')">B.Tech</span>
                        <span class="pill-item" onclick="setQual('B.E.')">B.E.</span>
                        <span class="pill-item" onclick="setQual('BCA')">BCA</span>
                        <span class="pill-item" onclick="setQual('MCA')">MCA</span>
                        <span class="pill-item" onclick="setQual('B.Sc Computer Science')">B.Sc CS</span>
                        <span class="pill-item" onclick="setQual('Diploma')">Diploma</span>
                        <span class="pill-item" onclick="setQual('Class 12th / Senior Secondary')">12th</span>
                        <span class="pill-item" onclick="setQual('Class 10th / Secondary')">10th</span>
                    </div>
                </div>

                <!-- PASSING YEAR -->
                <div class="form-group">
                    <label for="yearInput">Passing / Completion Year <span style="color:#ef4444;">*</span></label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-calendar-check input-icon"></i>
                        <input type="number" id="yearInput" name="year" class="form-control"
                               value="<%= yearValue %>" min="1990" max="2035" placeholder="e.g. 2026" required>
                    </div>
                    <div class="quick-pills">
                        <span class="pill-item" onclick="setYear(2026)">2026</span>
                        <span class="pill-item" onclick="setYear(2025)">2025</span>
                        <span class="pill-item" onclick="setYear(2024)">2024</span>
                        <span class="pill-item" onclick="setYear(2023)">2023</span>
                    </div>
                </div>

                <!-- PERCENTAGE & CGPA (INLINE) -->
                <div class="inline-grid">
                    <div class="form-group">
                        <label for="cgpaInput">CGPA (out of 10.0) <span style="color:#ef4444;">*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-award input-icon"></i>
                            <input type="number" id="cgpaInput" name="cgpa" class="form-control"
                                   value="<%= cgpaValue %>" step="0.01" min="0" max="10" placeholder="e.g. 8.50" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="percentageInput">Percentage (%) <span style="color:#ef4444;">*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-percent input-icon"></i>
                            <input type="number" id="percentageInput" name="percentage" class="form-control"
                                   value="<%= percentageValue %>" step="0.01" min="0" max="100" placeholder="e.g. 80.75" required>
                        </div>
                    </div>
                </div>
                <div class="field-hint">
                    <i class="fa-solid fa-calculator" style="color:var(--primary);"></i>
                    Entering CGPA automatically calculates standard Percentage (&times; 9.5). You can adjust either value.
                </div>

                <!-- BACKLOGS -->
                <div class="form-group" style="margin-top: 18px;">
                    <label for="backlogsInput">Active Backlogs <span style="color:#ef4444;">*</span></label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-triangle-exclamation input-icon"></i>
                        <input type="number" id="backlogsInput" name="backlogs" class="form-control"
                               value="<%= backlogsValue %>" min="0" max="50" placeholder="0 if all cleared" required>
                    </div>
                    <div class="quick-pills">
                        <span class="pill-item" onclick="setBacklogs(0)"><i class="fa-solid fa-check" style="color:#16a34a;"></i> 0 (Clean / All Clear)</span>
                        <span class="pill-item" onclick="setBacklogs(1)">1 Backlog</span>
                        <span class="pill-item" onclick="setBacklogs(2)">2 Backlogs</span>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fa-solid <%= editMode ? "fa-floppy-disk" : "fa-plus" %>"></i>
                        <%= editMode ? "Update Academic Record" : "Save Academic Details" %>
                    </button>
                    <a href="student_academic_view.jsp" class="btn-reset">
                        Cancel
                    </a>
                </div>
            </form>
        </section>

        <!-- ELIGIBILITY GUIDELINES -->
        <aside class="card">
            <div class="card-head">
                <h2><i class="fa-solid fa-circle-info" style="color: var(--primary);"></i> Placement Eligibility Guide</h2>
            </div>

            <div class="guide-list">
                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-sliders"></i></div>
                    <div class="guide-text">
                        <h4>Drive Cutoff Requirements</h4>
                        <p>Most corporate recruiting partners require a minimum aggregate of <strong>60% or 6.5 CGPA</strong> and 0 active backlogs to qualify for test links.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-id-card-clip"></i></div>
                    <div class="guide-text">
                        <h4>Recruiter Candidate Dossier</h4>
                        <p>All academic details registered here appear directly on your dossier when recruiters evaluate your job applications.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-layer-group"></i></div>
                    <div class="guide-text">
                        <h4>Record Multiple Qualifications</h4>
                        <p>You can add records for Class 10th, Class 12th, Diploma, and Graduation separately to maintain a complete history.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-shield-halved"></i></div>
                    <div class="guide-text">
                        <h4>Document Verification</h4>
                        <p>Ensure your marks and passing year match your semester marksheets. Colleges verify these before shortlisting for on-campus drives.</p>
                    </div>
                </div>
            </div>
        </aside>

    </div>

</main>

<script>
function setQual(val) {
    document.getElementById('qualificationInput').value = val;
    document.getElementById('qualificationInput').focus();
}

function setYear(val) {
    document.getElementById('yearInput').value = val;
    document.getElementById('yearInput').focus();
}

function setBacklogs(val) {
    document.getElementById('backlogsInput').value = val;
    document.getElementById('backlogsInput').focus();
}

// Auto-convert CGPA and Percentage
var cgpaInput = document.getElementById('cgpaInput');
var percInput = document.getElementById('percentageInput');

if (cgpaInput && percInput) {
    cgpaInput.addEventListener('input', function() {
        var val = parseFloat(this.value);
        if (!isNaN(val) && val >= 0 && val <= 10) {
            // Standard CBSE/AICTE formula: % = CGPA * 9.5
            var calcPerc = (val * 9.5).toFixed(2);
            if (calcPerc > 100) calcPerc = 100;
            percInput.value = calcPerc;
        }
    });

    percInput.addEventListener('input', function() {
        var val = parseFloat(this.value);
        if (!isNaN(val) && val >= 0 && val <= 100) {
            // Reciprocal formula: CGPA = % / 9.5
            var calcCgpa = (val / 9.5).toFixed(2);
            if (calcCgpa > 10) calcCgpa = 10;
            cgpaInput.value = calcCgpa;
        }
    });
}

function validateAcademicForm() {
    var qual = document.getElementById('qualificationInput').value.trim();
    var year = document.getElementById('yearInput').value.trim();
    var perc = document.getElementById('percentageInput').value.trim();
    var cgpa = document.getElementById('cgpaInput').value.trim();
    var backlogs = document.getElementById('backlogsInput').value.trim();

    if (!qual) {
        alert("Please enter your qualification or degree.");
        document.getElementById('qualificationInput').focus();
        return false;
    }

    if (!year || isNaN(year) || year < 1990 || year > 2035) {
        alert("Please enter a valid passing year (1990 - 2035).");
        document.getElementById('yearInput').focus();
        return false;
    }

    if (!cgpa || isNaN(cgpa) || cgpa < 0 || cgpa > 10) {
        alert("Please enter a valid CGPA between 0.00 and 10.00.");
        document.getElementById('cgpaInput').focus();
        return false;
    }

    if (!perc || isNaN(perc) || perc < 0 || perc > 100) {
        alert("Please enter a valid percentage between 0.00 and 100.00.");
        document.getElementById('percentageInput').focus();
        return false;
    }

    if (backlogs === "" || isNaN(backlogs) || backlogs < 0) {
        alert("Please enter backlogs (0 if none).");
        document.getElementById('backlogsInput').focus();
        return false;
    }

    return true;
}
</script>

</body>
</html>
