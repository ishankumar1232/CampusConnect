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
            ps.setInt(
                1,
                Integer.parseInt(session1.getAttribute("studentId").toString())
            );

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
        application.log("Unable to load student dashboard data", e);
    }

    String firstLetter = "S";

    if (studentName != null && !studentName.trim().isEmpty()) {
        firstLetter = studentName.trim().substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Dashboard | CampusConnect</title>

<!-- Google Fonts & FontAwesome Icons -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --bg-color: #f8fafc;
    --card-bg: #ffffff;
    --primary: #2563eb;
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
    max-width: 1700px;
    width: calc(100% - 88px);
}

.utility-row {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-bottom: 20px;
}

.utility-btn {
    width: 40px;
    height: 38px;
    border-radius: 10px;
    background: white;
    border: 1px solid var(--border-color);
    display: grid;
    place-items: center;
    font-size: 16px;
    color: #1a4e91;
    box-shadow: var(--shadow-sm);
    transition: .2s;
}

.utility-btn:hover {
    background: var(--primary-light);
    border-color: var(--primary);
    transform: translateY(-2px);
}

/* WELCOME BANNER */
.welcome {
    background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
    color: white;
    padding: 32px 36px;
    border-radius: var(--radius-lg);
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 36px;
    box-shadow: var(--shadow-md);
}

.welcome-label {
    color: #9fcaff;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 2px;
    margin-bottom: 6px;
}

.welcome h1 {
    font-size: 26px;
    font-weight: 750;
    margin-bottom: 8px;
    letter-spacing: -.5px;
}

.welcome p {
    color: #dbeaff;
    font-size: 14px;
    line-height: 1.5;
}

/* SECTION HEADERS */
.section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin: 32px 0 18px;
}

.section-header h2 {
    font-size: 19px;
    font-weight: 750;
    color: var(--text-main);
}

.section-header p {
    font-size: 12px;
    color: var(--text-muted);
}

/* CARDS GRID */
.dashboard-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 20px;
}

.card {
    position: relative;
    padding: 24px;
    border-radius: var(--radius-lg);
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    transition: all .25s ease;
    overflow: hidden;
}

.card:hover {
    transform: translateY(-4px);
    background: white;
    border-color: #93c5fd;
    box-shadow: var(--shadow-md);
}

.card-icon {
    width: 44px;
    height: 44px;
    display: grid;
    place-items: center;
    border-radius: var(--radius-md);
    color: white;
    font-size: 18px;
    font-weight: 700;
    background: linear-gradient(135deg, #1e3a8a, #2563eb);
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
    margin-bottom: 16px;
}

.card.purple .card-icon {
    background: linear-gradient(135deg, #6d28d9, #8b5cf6);
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.2);
}

.card.green .card-icon {
    background: linear-gradient(135deg, #047857, #10b981);
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
}

.card.orange .card-icon {
    background: linear-gradient(135deg, #c2410c, #f97316);
    box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
}

.card.red .card-icon {
    background: linear-gradient(135deg, #be123c, #f43f5e);
    box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
}

.card h3 {
    font-size: 15px;
    font-weight: 700;
    color: var(--text-main);
    margin-bottom: 6px;
}

.card p {
    font-size: 13px;
    color: var(--text-muted);
    line-height: 1.5;
}

.card-link {
    position: absolute;
    inset: 0;
    z-index: 1;
    border-radius: inherit;
}

/* FOOTER */
.footer {
    text-align: center;
    color: var(--text-muted);
    font-size: 12px;
    padding: 40px 10px 20px;
    border-top: 1px solid var(--border-color);
    margin-top: 50px;
}

/* RESPONSIVE */
@media (max-width: 900px) {
    .main {
        margin-left: 70px;
        width: calc(100% - 70px);
        padding: 24px 20px;
    }
    .sidebar {
        width: 70px;
    }
    .side-link {
        width: 54px;
    }
    .welcome {
        flex-direction: column;
        align-items: flex-start;
        gap: 20px;
    }
}
</style>
</head>

<body>

<!-- TOP HEADER -->
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
                         src="<%= request.getContextPath() %>/profile_images/<%= URLEncoder.encode(profileImage, StandardCharsets.UTF_8.name()) %>"
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
    <a href="student_dashboard.jsp" class="side-link active">
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

    <div class="utility-row">
        <a class="utility-btn" href="student_notice_view.jsp" title="Notifications"><i class="fa-regular fa-bell"></i></a>
        <a class="utility-btn" href="student_profile.jsp" title="My Profile"><i class="fa-solid fa-gear"></i></a>
    </div>

    <!-- WELCOME BANNER (Progress Ring Removed) -->
    <section class="welcome">
        <div class="welcome-content">
            <div class="welcome-label">STUDENT PORTAL</div>
            <h1>Welcome Back, <%= studentName %></h1>
            <p>Your personalized hub for academic success and career growth.</p>
        </div>
    </section>

    <!-- PROFILE & ACADEMICS SECTION -->
    <div class="section-header">
        <h2>Profile &amp; Academics</h2>
        <p>Manage your student information</p>
    </div>

    <section class="dashboard-grid">
        <article class="card purple">
            <div class="card-icon"><i class="fa-regular fa-user"></i></div>
            <h3>My Profile</h3>
            <p>View and update your personal profile.</p>
            <a class="card-link" href="student_profile.jsp" aria-label="My Profile"></a>
        </article>

        <article class="card">
            <div class="card-icon"><i class="fa-solid fa-plus"></i></div>
            <h3>Add Academic Details</h3>
            <p>Add your academic information.</p>
            <a class="card-link" href="student_academic.jsp" aria-label="Add Academic Details"></a>
        </article>

        <article class="card">
            <div class="card-icon"><i class="fa-regular fa-file-lines"></i></div>
            <h3>View Academic Details</h3>
            <p>View your saved academic records.</p>
            <a class="card-link" href="student_academic_view.jsp" aria-label="View Academic Details"></a>
        </article>

        <article class="card">
            <div class="card-icon"><i class="fa-solid fa-laptop-code"></i></div>
            <h3>Add Skills</h3>
            <p>Add your technical and professional skills.</p>
            <a class="card-link" href="student_skill.jsp" aria-label="Add Skills"></a>
        </article>

        <article class="card">
            <div class="card-icon"><i class="fa-solid fa-code"></i></div>
            <h3>View Skills</h3>
            <p>View all your added skills.</p>
            <a class="card-link" href="student_skill_view.jsp" aria-label="View Skills"></a>
        </article>

        <article class="card">
            <div class="card-icon"><i class="fa-solid fa-folder-plus"></i></div>
            <h3>Add Project</h3>
            <p>Add your academic and personal projects.</p>
            <a class="card-link" href="student_project.jsp" aria-label="Add Project"></a>
        </article>

        <article class="card">
            <div class="card-icon"><i class="fa-regular fa-folder-open"></i></div>
            <h3>View Projects</h3>
            <p>View your existing project records.</p>
            <a class="card-link" href="student_project_view.jsp" aria-label="View Projects"></a>
        </article>

        <article class="card purple">
            <div class="card-icon"><i class="fa-solid fa-file-arrow-up"></i></div>
            <h3>Upload Resume</h3>
            <p>Upload your latest resume.</p>
            <a class="card-link" href="student_resume.jsp" aria-label="Upload Resume"></a>
        </article>

        <article class="card purple">
            <div class="card-icon"><i class="fa-regular fa-file-pdf"></i></div>
            <h3>View Resume</h3>
            <p>View your uploaded resume.</p>
            <a class="card-link" href="student_resume_view.jsp" aria-label="View Resume"></a>
        </article>
    </section>

    <!-- PLACEMENTS SECTION -->
    <div class="section-header">
        <h2>Placement &amp; Recruitment</h2>
        <p>Explore opportunities and applications</p>
    </div>

    <section class="dashboard-grid">
        <article class="card green">
            <div class="card-icon"><i class="fa-solid fa-building"></i></div>
            <h3>Available Placement Drives</h3>
            <p>Explore available campus placement drives.</p>
            <a class="card-link" href="student_drive_view.jsp" aria-label="Available Placement Drives"></a>
        </article>

        <article class="card green">
            <div class="card-icon"><i class="fa-solid fa-compass"></i></div>
            <h3>Placement Opportunities</h3>
            <p>Explore suitable placement opportunities.</p>
            <a class="card-link" href="student_placement_opportunities.jsp" aria-label="Placement Opportunities"></a>
        </article>

        <article class="card orange">
            <div class="card-icon"><i class="fa-solid fa-paper-plane"></i></div>
            <h3>My Applications</h3>
            <p>Track your submitted applications.</p>
            <a class="card-link" href="student_application_view.jsp" aria-label="My Applications"></a>
        </article>

        <article class="card orange">
            <div class="card-icon"><i class="fa-regular fa-calendar-days"></i></div>
            <h3>Interview Details</h3>
            <p>Check your interview schedules and details.</p>
            <a class="card-link" href="student_interview_view.jsp" aria-label="Interview Details"></a>
        </article>

        <article class="card green">
            <div class="card-icon"><i class="fa-solid fa-award"></i></div>
            <h3>Selection Result</h3>
            <p>View your recruitment selection results.</p>
            <a class="card-link" href="student_selection_view.jsp" aria-label="Selection Result"></a>
        </article>

        <article class="card red">
            <div class="card-icon"><i class="fa-regular fa-bell"></i></div>
            <h3>Notifications</h3>
            <p>View college and recruitment updates.</p>
            <a class="card-link" href="student_notice_view.jsp" aria-label="Notifications"></a>
        </article>
    </section>

    <footer class="footer">
        CampusConnect Student Portal &bull; Campus Recruitment Management System
    </footer>

</main>

</body>
</html>