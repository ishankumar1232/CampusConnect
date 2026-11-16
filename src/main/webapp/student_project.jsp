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

    String projectNameValue = "";
    String descriptionValue = "";
    String technologiesValue = "";
    String projectUrlValue = "";

    if (editMode) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (
                Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "CAMPUSCONNECT",
                    "campus123"
                );
                PreparedStatement ps = con.prepareStatement(
                    "SELECT PROJECT_NAME, DESCRIPTION, TECHNOLOGIES, PROJECT_URL FROM STUDENT_PROJECT WHERE PROJECT_ID=? AND STUDENT_ID=?"
                )
            ) {
                ps.setInt(1, Integer.parseInt(editId.trim()));
                ps.setInt(2, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        projectNameValue = rs.getString("PROJECT_NAME");
                        descriptionValue = rs.getString("DESCRIPTION");
                        technologiesValue = rs.getString("TECHNOLOGIES");
                        projectUrlValue = rs.getString("PROJECT_URL");

                        if (projectNameValue == null) projectNameValue = "";
                        if (descriptionValue == null) descriptionValue = "";
                        if (technologiesValue == null) technologiesValue = "";
                        if (projectUrlValue == null) projectUrlValue = "";
                    }
                }
            }
        } catch (Exception e) {
            application.log("Unable to load project for editing", e);
        }
    }

    String flashMsg = (String) session1.getAttribute("projectMsg");
    session1.removeAttribute("projectMsg");
    String flashErr = (String) session1.getAttribute("projectError");
    session1.removeAttribute("projectError");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= editMode ? "Edit Project" : "Add Project" %> | CampusConnect</title>

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
.project-layout {
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

/* FORM FIELDS */
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
    padding: 12px 16px;
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    background: #f8fafc;
    font-size: 14px;
    color: var(--text-main);
    transition: all 0.2s ease;
    outline: none;
}

.input-wrapper .form-control {
    padding-left: 42px;
}

.form-control:focus {
    border-color: var(--primary);
    background: #ffffff;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

textarea.form-control {
    resize: vertical;
    min-height: 120px;
    line-height: 1.5;
}

.quick-tech-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    margin-top: 8px;
}

.quick-tag {
    background: #f1f5f9;
    color: #475569;
    font-size: 11.5px;
    font-weight: 600;
    padding: 3px 9px;
    border-radius: 6px;
    cursor: pointer;
    border: 1px solid #e2e8f0;
    transition: .15s;
}

.quick-tag:hover {
    background: #dbeafe;
    color: #1d4ed8;
    border-color: #bfdbfe;
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
    .project-layout {
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
            <h1><i class="fa-solid fa-diagram-project" style="color: var(--primary);"></i> <%= editMode ? "Edit Project" : "Add Project" %></h1>
            <p>Showcase your academic, open-source, and personal portfolio projects to corporate recruiters.</p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="student_project_view.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-folder-open"></i> View My Projects
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

    <div class="project-layout">

        <!-- FORM CARD -->
        <section class="card">
            <div class="card-head">
                <h2><i class="fa-solid fa-pen-nib" style="color: var(--primary);"></i> <%= editMode ? "Update Project Details" : "New Project Entry" %></h2>
                <span style="font-size: 12px; color: var(--text-muted);"><strong style="color: #ef4444;">*</strong> Mandatory</span>
            </div>

            <form name="projectForm" method="post" action="studentProject" onsubmit="return validateProjectForm();">
                <input type="hidden" name="projectId" value="<%= editId == null ? "" : editId %>">

                <div class="form-group">
                    <label for="projectName">Project Title / Name <span style="color:#ef4444;">*</span></label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-diagram-project input-icon"></i>
                        <input type="text" id="projectName" name="projectName" class="form-control"
                               value="<%= projectNameValue %>" placeholder="e.g. Campus Recruitment Management Portal" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="technologies">Technologies &amp; Frameworks <span style="color:#ef4444;">*</span></label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-code input-icon"></i>
                        <input type="text" id="technologies" name="technologies" class="form-control"
                               value="<%= technologiesValue %>" placeholder="e.g. Java, Oracle 10g, Servlets, JSP, React" required>
                    </div>
                    <div class="quick-tech-tags">
                        <span class="quick-tag" onclick="addTech('Java')">+ Java</span>
                        <span class="quick-tag" onclick="addTech('Spring Boot')">+ Spring Boot</span>
                        <span class="quick-tag" onclick="addTech('React')">+ React</span>
                        <span class="quick-tag" onclick="addTech('Python')">+ Python</span>
                        <span class="quick-tag" onclick="addTech('SQL / Oracle')">+ SQL</span>
                        <span class="quick-tag" onclick="addTech('REST API')">+ REST API</span>
                        <span class="quick-tag" onclick="addTech('Node.js')">+ Node.js</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Project Description &amp; Responsibilities <span style="color:#ef4444;">*</span></label>
                    <textarea id="description" name="description" class="form-control" rows="5"
                              placeholder="Describe the problem solved, architecture, and your key technical contributions..." required><%= descriptionValue %></textarea>
                </div>

                <div class="form-group">
                    <label for="projectUrl">Project / Repository URL (Optional)</label>
                    <div class="input-wrapper">
                        <i class="fa-brands fa-github input-icon"></i>
                        <input type="url" id="projectUrl" name="projectUrl" class="form-control"
                               value="<%= projectUrlValue %>" placeholder="https://github.com/username/project or live demo link">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fa-solid <%= editMode ? "fa-floppy-disk" : "fa-plus" %>"></i>
                        <%= editMode ? "Update Project" : "Add Project" %>
                    </button>
                    <a href="student_project_view.jsp" class="btn-reset" style="text-decoration:none;">
                        Cancel
                    </a>
                </div>
            </form>
        </section>

        <!-- TIPS & RECRUITER VALUE -->
        <aside class="card">
            <div class="card-head">
                <h2><i class="fa-solid fa-lightbulb" style="color: #f59e0b;"></i> Portfolio Best Practices</h2>
            </div>

            <div class="guide-list">
                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-code-branch"></i></div>
                    <div class="guide-text">
                        <h4>Include GitHub / Live Links</h4>
                        <p>Recruiters love inspecting actual code and working prototypes. Add your GitHub repository link or hosted demo.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-microchip"></i></div>
                    <div class="guide-text">
                        <h4>Specify Full Tech Stack</h4>
                        <p>List both frontend and backend technologies, databases, APIs, and tools used so recruitment filters catch your profile.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-bullseye"></i></div>
                    <div class="guide-text">
                        <h4>Focus on Impact &amp; Role</h4>
                        <p>Briefly describe the purpose of the application, user authentication, data flow, and your personal role in the build.</p>
                    </div>
                </div>

                <div class="guide-item">
                    <div class="guide-icon"><i class="fa-solid fa-id-card-clip"></i></div>
                    <div class="guide-text">
                        <h4>Recruiter Dossier View</h4>
                        <p>All projects added here are automatically surfaced in the candidate dossier viewed by companies during shortlisting.</p>
                    </div>
                </div>
            </div>
        </aside>

    </div>

</main>

<script>
function validateProjectForm() {
    var name = document.getElementById("projectName").value.trim();
    var desc = document.getElementById("description").value.trim();
    var tech = document.getElementById("technologies").value.trim();

    if (!name) {
        alert("Please enter the project title.");
        document.getElementById("projectName").focus();
        return false;
    }
    if (!tech) {
        alert("Please specify the technologies used in this project.");
        document.getElementById("technologies").focus();
        return false;
    }
    if (!desc) {
        alert("Please write a brief description of the project.");
        document.getElementById("description").focus();
        return false;
    }
    return true;
}

function addTech(techName) {
    var techInput = document.getElementById("technologies");
    var current = techInput.value.trim();
    if (!current) {
        techInput.value = techName;
    } else {
        var items = current.split(',').map(function(s) { return s.trim().toLowerCase(); });
        if (items.indexOf(techName.toLowerCase()) === -1) {
            techInput.value = current + ", " + techName;
        }
    }
    techInput.focus();
}
</script>

</body>
</html>
