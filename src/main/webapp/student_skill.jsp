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
    String skillNameValue = "";

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
                    "SELECT SKILL_NAME FROM STUDENT_SKILL WHERE SKILL_ID=? AND STUDENT_ID=?"
                )
            ) {
                ps.setInt(1, Integer.parseInt(editId.trim()));
                ps.setInt(2, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        skillNameValue = rs.getString("SKILL_NAME");
                        if (skillNameValue == null) skillNameValue = "";
                    }
                }
            }
        } catch (Exception e) {
            application.log("Unable to load skill for editing", e);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= editMode ? "Edit Skill" : "Add Technical Skill" %> | CampusConnect</title>

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
    max-width: 1100px;
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

.card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    padding: 32px;
    max-width: 680px;
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

.quick-tech-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 14px;
}

.quick-tag {
    background: #f1f5f9;
    color: #475569;
    font-size: 12px;
    font-weight: 600;
    padding: 5px 12px;
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
    text-decoration: none;
    transition: .2s;
}
.btn-reset:hover { background: #e2e8f0; }

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
            <h1><i class="fa-solid fa-laptop-code" style="color: var(--primary);"></i> <%= editMode ? "Edit Skill" : "Add Technical Skill" %></h1>
            <p>Add programming languages, frameworks, databases, and dev tools to your student profile.</p>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="student_skill_view.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-code"></i> View My Skills
            </a>
            <a href="student_dashboard.jsp" class="btn-header btn-secondary">
                <i class="fa-solid fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <section class="card">
        <div class="card-head">
            <h2><i class="fa-solid fa-code" style="color: var(--primary);"></i> Skill Information</h2>
            <span style="font-size: 12px; color: var(--text-muted);"><strong style="color: #ef4444;">*</strong> Mandatory</span>
        </div>

        <form name="skillForm" method="post" action="studentSkill" onsubmit="return validateSkillForm();">
            <input type="hidden" name="skillId" value="<%= editId == null ? "" : editId %>">

            <div class="form-group">
                <label for="skillName">Skill Name <span style="color:#ef4444;">*</span></label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-terminal input-icon"></i>
                    <input type="text" id="skillName" name="skillName" class="form-control"
                           value="<%= skillNameValue %>" placeholder="e.g. Java, Python, Spring Boot, React, SQL" required>
                </div>

                <div style="font-size: 12px; color: var(--text-muted); margin-top: 10px;">Quick Suggestions (click to insert):</div>
                <div class="quick-tech-tags">
                    <span class="quick-tag" onclick="selectSkill('Java')">Java</span>
                    <span class="quick-tag" onclick="selectSkill('Python')">Python</span>
                    <span class="quick-tag" onclick="selectSkill('C++')">C++</span>
                    <span class="quick-tag" onclick="selectSkill('Spring Boot')">Spring Boot</span>
                    <span class="quick-tag" onclick="selectSkill('React')">React</span>
                    <span class="quick-tag" onclick="selectSkill('SQL / Oracle')">SQL</span>
                    <span class="quick-tag" onclick="selectSkill('JavaScript')">JavaScript</span>
                    <span class="quick-tag" onclick="selectSkill('Node.js')">Node.js</span>
                    <span class="quick-tag" onclick="selectSkill('Git')">Git</span>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-submit">
                    <i class="fa-solid <%= editMode ? "fa-floppy-disk" : "fa-plus" %>"></i>
                    <%= editMode ? "Update Skill" : "Save Skill" %>
                </button>
                <a href="student_skill_view.jsp" class="btn-reset">
                    Cancel
                </a>
            </div>
        </form>
    </section>

</main>

<script>
function validateSkillForm() {
    var skill = document.getElementById("skillName").value.trim();
    if (!skill) {
        alert("Please enter a skill name.");
        document.getElementById("skillName").focus();
        return false;
    }
    return true;
}

function selectSkill(name) {
    document.getElementById("skillName").value = name;
    document.getElementById("skillName").focus();
}
</script>

</body>
</html>
