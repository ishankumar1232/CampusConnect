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
<title>My Resumes | CampusConnect</title>

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

/* CONTENT CARD */
.content-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    overflow: hidden;
}

.table-responsive {
    width: 100%;
    overflow-x: auto;
}

.data-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 14px;
}

.data-table th {
    background: #f1f5f9;
    color: #334155;
    font-weight: 700;
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    white-space: nowrap;
}

.data-table td {
    padding: 18px 20px;
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

.doc-badge {
    display: inline-flex;
    align-items: center;
    gap: 10px;
}

.doc-icon {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    display: grid;
    place-items: center;
    font-size: 17px;
    flex-shrink: 0;
}

.doc-icon.pdf {
    background: #fee2e2;
    color: #dc2626;
}

.doc-icon.doc {
    background: #eff6ff;
    color: #2563eb;
}

.doc-name {
    font-weight: 700;
    color: var(--text-main);
    font-size: 13.5px;
    word-break: break-all;
}

.badge-active {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 4px 10px;
    background: #ecfdf5;
    color: #059669;
    border: 1px solid #a7f3d0;
    border-radius: 20px;
    font-size: 11.5px;
    font-weight: 700;
}

/* ACTION BUTTONS */
.actions-cell {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
}

.btn-action {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 7px;
    font-size: 12px;
    font-weight: 700;
    border: none;
    cursor: pointer;
    transition: .15s;
    text-decoration: none;
}

.btn-view {
    background: #059669;
    color: white;
}
.btn-view:hover { background: #047857; }

.btn-dl {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
}
.btn-dl:hover { background: #dbeafe; }

.btn-edit {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid var(--border-color);
}
.btn-edit:hover { background: #e2e8f0; }

.btn-delete {
    background: #fee2e2;
    color: #dc2626;
}
.btn-delete:hover { background: #fca5a5; }

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
    font-size: 28px;
    margin: 0 auto 16px;
}

.empty-state h3 {
    font-size: 17px;
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 6px;
}

.empty-state p {
    font-size: 13.5px;
    max-width: 420px;
    margin: 0 auto 20px;
    line-height: 1.5;
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
            <h1><i class="fa-solid fa-file-lines" style="color: var(--primary);"></i> My Resumes &amp; Documents</h1>
            <p>Review, preview, download, or replace your uploaded resume files.</p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="student_resume.jsp" class="btn-header btn-primary">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload / Replace Resume
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

    <div class="content-card">
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Resume Document</th>
                        <th>Upload Date</th>
                        <th>Status</th>
                        <th style="text-align: right; padding-right: 24px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    boolean found = false;

                    try {
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        con = DriverManager.getConnection(
                            "jdbc:oracle:thin:@localhost:1521:XE",
                            "CAMPUSCONNECT",
                            "campus123"
                        );

                        String sql = "SELECT RESUME_ID, RESUME_FILE, UPLOADED_DATE FROM RESUME WHERE STUDENT_ID=? ORDER BY RESUME_ID DESC";
                        ps = con.prepareStatement(sql);
                        ps.setInt(1, studentId);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            found = true;
                            int resumeId = rs.getInt("RESUME_ID");
                            String resumeFile = rs.getString("RESUME_FILE");
                            java.sql.Date uploadDate = rs.getDate("UPLOADED_DATE");
                            String safeFileName = resumeFile != null ? resumeFile : "";
                            boolean isPdf = safeFileName.toLowerCase().endsWith(".pdf");
                %>
                    <tr>
                        <td>
                            <div class="doc-badge">
                                <div class="doc-icon <%= isPdf ? "pdf" : "doc" %>">
                                    <i class="fa-solid <%= isPdf ? "fa-file-pdf" : "fa-file-word" %>"></i>
                                </div>
                                <div>
                                    <div class="doc-name"><%= safeFileName %></div>
                                    <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                        Document ID: #<%= resumeId %>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div style="font-weight: 600;"><%= uploadDate != null ? uploadDate.toString() : "-" %></div>
                        </td>
                        <td>
                            <span class="badge-active">
                                <i class="fa-solid fa-check"></i> Available to Recruiters
                            </span>
                        </td>
                        <td>
                            <div class="actions-cell" style="justify-content: flex-end;">
                                <a href="resume_files/<%= URLEncoder.encode(safeFileName, StandardCharsets.UTF_8.name()) %>" target="_blank" class="btn-action btn-view" title="Open in browser">
                                    <i class="fa-solid fa-eye"></i> View
                                </a>
                                <a href="resume_files/<%= URLEncoder.encode(safeFileName, StandardCharsets.UTF_8.name()) %>" download class="btn-action btn-dl" title="Download to device">
                                    <i class="fa-solid fa-download"></i> Download
                                </a>
                                <a href="student_resume.jsp?editId=<%= resumeId %>" class="btn-action btn-edit" title="Replace file">
                                    <i class="fa-solid fa-pen-to-square"></i> Replace
                                </a>
                                <form method="post" action="studentResume" onsubmit="return confirm('Are you sure you want to delete this resume?');" style="margin: 0; display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="resumeId" value="<%= resumeId %>">
                                    <input type="hidden" name="resumeFile" value="<%= safeFileName %>">
                                    <button type="submit" class="btn-action btn-delete" title="Delete resume">
                                        <i class="fa-solid fa-trash-can"></i> Delete
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <%
                        }

                        if (!found) {
                %>
                    <tr>
                        <td colspan="4">
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <i class="fa-regular fa-file-lines"></i>
                                </div>
                                <h3>No Resume Uploaded Yet</h3>
                                <p>You haven't uploaded a resume yet. Corporate recruiters require an uploaded resume before scheduling interviews.</p>
                                <a href="student_resume.jsp" class="btn-header btn-primary">
                                    <i class="fa-solid fa-cloud-arrow-up"></i> Upload Your First Resume
                                </a>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                %>
                    <tr>
                        <td colspan="4" style="padding: 30px; text-align: center; color: #dc2626;">
                            <i class="fa-solid fa-triangle-exclamation" style="font-size: 24px; margin-bottom: 8px; display: block;"></i>
                            Error loading resumes: <%= e.getMessage() %>
                        </td>
                    </tr>
                <%
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (con != null) con.close();
                        } catch (Exception ignored) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</main>

</body>
</html>
