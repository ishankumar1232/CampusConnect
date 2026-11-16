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

    String editId = request.getParameter("editId");
    boolean editMode = (editId != null && !editId.trim().isEmpty());
    String currentResumeFile = "";
    int currentResumeId = 0;
    java.sql.Date currentUploadDate = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            )
        ) {
            String sql;
            if (editMode) {
                sql = "SELECT RESUME_ID, RESUME_FILE, UPLOADED_DATE FROM RESUME WHERE RESUME_ID=? AND STUDENT_ID=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(editId.trim()));
                    ps.setInt(2, studentId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            currentResumeId = rs.getInt("RESUME_ID");
                            currentResumeFile = rs.getString("RESUME_FILE");
                            currentUploadDate = rs.getDate("UPLOADED_DATE");
                        }
                    }
                }
            } else {
                sql = "SELECT RESUME_ID, RESUME_FILE, UPLOADED_DATE FROM RESUME WHERE STUDENT_ID=? ORDER BY RESUME_ID DESC";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, studentId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            currentResumeId = rs.getInt("RESUME_ID");
                            currentResumeFile = rs.getString("RESUME_FILE");
                            currentUploadDate = rs.getDate("UPLOADED_DATE");
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        application.log("Unable to load resume record", e);
    }

    String flashMsg = (String) session1.getAttribute("resumeMsg");
    session1.removeAttribute("resumeMsg");
    String flashErr = (String) session1.getAttribute("resumeError");
    session1.removeAttribute("resumeError");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= editMode ? "Update Resume" : "Upload Resume / CV" %> | CampusConnect</title>

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

/* LAYOUT GRID */
.resume-layout {
    display: grid;
    grid-template-columns: minmax(0, 1.4fr) minmax(0, 1fr);
    gap: 24px;
    align-items: start;
}

.card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    padding: 28px;
}

.card-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
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

/* ACTIVE RESUME CARD */
.active-resume-box {
    background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
    border: 1px solid #a7f3d0;
    border-radius: var(--radius-md);
    padding: 18px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 24px;
    flex-wrap: wrap;
}

.resume-file-info {
    display: flex;
    align-items: center;
    gap: 14px;
}

.doc-icon-large {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    background: #dcfce7;
    color: #16a34a;
    display: grid;
    place-items: center;
    font-size: 22px;
    flex-shrink: 0;
}

.resume-name {
    font-size: 14.5px;
    font-weight: 800;
    color: #166534;
    word-break: break-all;
}

.resume-meta {
    font-size: 12px;
    color: #059669;
    margin-top: 3px;
}

.resume-actions {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
}

.btn-pill {
    padding: 7px 14px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: .15s;
}

.btn-pill-view {
    background: #059669;
    color: white;
}
.btn-pill-view:hover { background: #047857; }

.btn-pill-dl {
    background: white;
    color: #166534;
    border: 1px solid #bbf7d0;
}
.btn-pill-dl:hover { background: #f0fdf4; }

/* DRAG & DROP UPLOAD ZONE */
.dropzone {
    border: 2px dashed #93c5fd;
    border-radius: var(--radius-lg);
    background: #f8fafc;
    padding: 36px 24px;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s ease;
    position: relative;
}

.dropzone:hover,
.dropzone.dragover {
    border-color: var(--primary);
    background: var(--primary-light);
    transform: translateY(-2px);
}

.dropzone-icon {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: #dbeafe;
    color: var(--primary);
    display: grid;
    place-items: center;
    font-size: 26px;
    margin: 0 auto 16px;
    transition: transform 0.2s ease;
}

.dropzone:hover .dropzone-icon {
    transform: scale(1.08);
}

.dropzone-title {
    font-size: 16px;
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 6px;
}

.dropzone-desc {
    font-size: 13px;
    color: var(--text-muted);
    margin-bottom: 16px;
}

.dropzone-desc span {
    color: var(--primary);
    font-weight: 700;
    text-decoration: underline;
}

.format-tags {
    display: flex;
    justify-content: center;
    gap: 8px;
    flex-wrap: wrap;
}

.format-tag {
    padding: 4px 10px;
    background: #e2e8f0;
    border-radius: 6px;
    font-size: 11px;
    font-weight: 700;
    color: #475569;
}

/* SELECTED FILE PREVIEW */
.file-preview {
    display: none;
    margin-top: 20px;
    padding: 16px;
    background: #eff6ff;
    border: 1px solid #bfdbfe;
    border-radius: 10px;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
}

.file-preview.show {
    display: flex;
}

.file-preview-left {
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 0;
}

.file-preview-icon {
    font-size: 24px;
    color: var(--primary);
}

.file-preview-details {
    min-width: 0;
}

.file-preview-name {
    font-size: 13.5px;
    font-weight: 700;
    color: var(--text-main);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.file-preview-size {
    font-size: 11.5px;
    color: var(--text-muted);
}

.file-preview-remove {
    background: none;
    border: none;
    color: #dc2626;
    font-size: 16px;
    cursor: pointer;
    padding: 6px;
    border-radius: 6px;
}
.file-preview-remove:hover {
    background: #fee2e2;
}

/* FORM ACTIONS */
.form-actions {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 24px;
}

.btn-submit {
    padding: 12px 24px;
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
    width: 32px;
    height: 32px;
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
    .resume-layout {
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
            <h1><i class="fa-solid fa-file-arrow-up" style="color: var(--primary);"></i> <%= editMode ? "Update Resume" : "Upload Resume / CV" %></h1>
            <p>Upload your latest curriculum vitae so corporate recruiters and hiring partners can review your credentials.</p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="student_resume_view.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-file-lines"></i> View My Resumes
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

    <div class="resume-layout">

        <!-- UPLOAD SECTION -->
        <section class="card">
            <div class="card-head">
                <h2><i class="fa-solid fa-cloud-arrow-up" style="color: var(--primary);"></i> Resume File Submission</h2>
                <span style="font-size: 12px; color: var(--text-muted);"><strong style="color: #ef4444;">*</strong> Mandatory</span>
            </div>

            <% if (!currentResumeFile.isEmpty()) { %>
                <div class="active-resume-box">
                    <div class="resume-file-info">
                        <div class="doc-icon-large">
                            <i class="fa-solid fa-file-pdf"></i>
                        </div>
                        <div>
                            <div class="resume-name"><%= currentResumeFile %></div>
                            <div class="resume-meta">
                                Active on Profile &bull; Uploaded on <%= currentUploadDate != null ? currentUploadDate.toString() : "Recent" %>
                            </div>
                        </div>
                    </div>
                    <div class="resume-actions">
                        <a href="resume_files/<%= URLEncoder.encode(currentResumeFile, StandardCharsets.UTF_8.name()) %>" target="_blank" class="btn-pill btn-pill-view">
                            <i class="fa-solid fa-eye"></i> View Current
                        </a>
                        <a href="resume_files/<%= URLEncoder.encode(currentResumeFile, StandardCharsets.UTF_8.name()) %>" download class="btn-pill btn-pill-dl">
                            <i class="fa-solid fa-download"></i> Download
                        </a>
                    </div>
                </div>
            <% } %>

            <form name="resumeForm" method="post" action="studentResume" enctype="multipart/form-data" id="resumeUploadForm">
                <% if (editMode) { %>
                    <input type="hidden" name="resumeId" value="<%= editId %>">
                <% } else if (currentResumeId > 0) { %>
                    <!-- Optional hidden field if student wants to replace latest directly -->
                    <input type="hidden" name="resumeId" value="<%= currentResumeId %>">
                <% } %>

                <label for="resumeFileInput" class="dropzone" id="dropArea">
                    <input type="file" id="resumeFileInput" name="resumeFile" accept=".pdf,.doc,.docx" required style="display:none;">
                    <div class="dropzone-icon">
                        <i class="fa-solid fa-cloud-arrow-up"></i>
                    </div>
                    <div class="dropzone-title">Click to upload or drag &amp; drop</div>
                    <div class="dropzone-desc">Choose your resume from your device (<span>browse files</span>)</div>
                    <div class="format-tags">
                        <span class="format-tag">PDF</span>
                        <span class="format-tag">DOC</span>
                        <span class="format-tag">DOCX</span>
                        <span class="format-tag">Max 10 MB</span>
                    </div>
                </label>

                <!-- SELECTED PREVIEW -->
                <div class="file-preview" id="filePreview">
                    <div class="file-preview-left">
                        <i class="fa-solid fa-file-pdf file-preview-icon" id="previewIcon"></i>
                        <div class="file-preview-details">
                            <div class="file-preview-name" id="previewFileName">filename.pdf</div>
                            <div class="file-preview-size" id="previewFileSize">0 KB</div>
                        </div>
                    </div>
                    <button type="button" class="file-preview-remove" id="removeFileBtn" title="Remove selected file">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-paper-plane"></i> <%= (editMode || currentResumeId > 0) ? "Update & Replace Resume" : "Upload Resume" %>
                    </button>
                    <button type="reset" class="btn-reset" id="resetBtn">
                        <i class="fa-solid fa-rotate-left"></i> Reset
                    </button>
                </div>
            </form>
        </section>

        <!-- TIPS & RECRUITER VISIBILITY -->
        <aside class="card">
            <div class="card-head">
                <h2><i class="fa-solid fa-lightbulb" style="color: #f59e0b;"></i> Resume Best Practices</h2>
            </div>

            <div class="guide-list">
                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-file-circle-check"></i></div>
                    <div class="guide-text">
                        <h4>Prefer PDF Format</h4>
                        <p>PDF preserves your formatting, fonts, and layout across all devices used by corporate recruiters.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-diagram-project"></i></div>
                    <div class="guide-text">
                        <h4>Highlight Key Projects</h4>
                        <p>Include links to your GitHub repositories or live web demos for academic and personal projects.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-code"></i></div>
                    <div class="guide-text">
                        <h4>Align Skills with Job Drives</h4>
                        <p>Ensure programming languages and frameworks listed on your resume match your added CampusConnect skills.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-eye"></i></div>
                    <div class="guide-text">
                        <h4>Recruiter Visibility</h4>
                        <p>Whenever you apply for campus or off-campus recruitment drives, this document is shared directly with interviewers.</p>
                    </div>
                </div>
            </div>
        </aside>

    </div>

</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var fileInput = document.getElementById('resumeFileInput');
    var dropArea = document.getElementById('dropArea');
    var filePreview = document.getElementById('filePreview');
    var previewFileName = document.getElementById('previewFileName');
    var previewFileSize = document.getElementById('previewFileSize');
    var previewIcon = document.getElementById('previewIcon');
    var removeFileBtn = document.getElementById('removeFileBtn');
    var resetBtn = document.getElementById('resetBtn');

    function formatBytes(bytes) {
        if (bytes === 0) return '0 Bytes';
        var k = 1024;
        var sizes = ['Bytes', 'KB', 'MB', 'GB'];
        var i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    function handleFile(file) {
        if (!file) return;
        var ext = file.name.split('.').pop().toLowerCase();
        if (['pdf', 'doc', 'docx'].indexOf(ext) === -1) {
            alert('Please select a valid PDF, DOC, or DOCX document.');
            fileInput.value = '';
            filePreview.classList.remove('show');
            return;
        }

        if (file.size > 10 * 1024 * 1024) {
            alert('File size exceeds the 10 MB limit.');
            fileInput.value = '';
            filePreview.classList.remove('show');
            return;
        }

        previewFileName.textContent = file.name;
        previewFileSize.textContent = formatBytes(file.size) + ' • Ready to upload';
        
        if (ext === 'pdf') {
            previewIcon.className = 'fa-solid fa-file-pdf file-preview-icon';
            previewIcon.style.color = '#dc2626';
        } else {
            previewIcon.className = 'fa-solid fa-file-word file-preview-icon';
            previewIcon.style.color = '#2563eb';
        }

        filePreview.classList.add('show');
    }

    fileInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            handleFile(this.files[0]);
        }
    });

    // Drag & Drop
    ['dragenter', 'dragover'].forEach(function(eventName) {
        dropArea.addEventListener(eventName, function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropArea.classList.add('dragover');
        });
    });

    ['dragleave', 'drop'].forEach(function(eventName) {
        dropArea.addEventListener(eventName, function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropArea.classList.remove('dragover');
        });
    });

    dropArea.addEventListener('drop', function(e) {
        var dt = e.dataTransfer;
        var files = dt.files;
        if (files && files.length > 0) {
            fileInput.files = files;
            handleFile(files[0]);
        }
    });

    removeFileBtn.addEventListener('click', function() {
        fileInput.value = '';
        filePreview.classList.remove('show');
    });

    resetBtn.addEventListener('click', function() {
        fileInput.value = '';
        filePreview.classList.remove('show');
    });
});
</script>

</body>
</html>
