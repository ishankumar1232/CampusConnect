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

    String qualificationValue = "";
    String yearValue = "";
    String percentageValue = "";
    String cgpaValue = "";
    String backlogsValue = "";

    if (editId != null && !editId.equals("")) {
        Connection con2 = null;
        PreparedStatement ps2 = null;
        ResultSet rs2 = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con2 = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql = "SELECT QUALIFICATION, YEAR, PERCENTAGE, CGPA, BACKLOGS FROM STUDENT_ACADEMIC WHERE ACADEMIC_ID=? AND STUDENT_ID=?";
            ps2 = con2.prepareStatement(sql);
            ps2.setInt(1, Integer.parseInt(editId));
            ps2.setInt(2, studentId);
            rs2 = ps2.executeQuery();

            if (rs2.next()) {
                qualificationValue = rs2.getString("QUALIFICATION");
                yearValue = String.valueOf(rs2.getInt("YEAR"));
                percentageValue = String.valueOf(rs2.getDouble("PERCENTAGE"));
                cgpaValue = String.valueOf(rs2.getDouble("CGPA"));
                backlogsValue = String.valueOf(rs2.getInt("BACKLOGS"));
            }
        } catch (Exception e) {
            application.log("Error loading academic record for edit", e);
        } finally {
            try {
                if (rs2 != null) rs2.close();
                if (ps2 != null) ps2.close();
                if (con2 != null) con2.close();
            } catch (Exception e) {}
        }
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

<script>
function validateForm() {
    var qualification = document.forms["academicForm"]["qualification"].value.trim();
    var year = document.forms["academicForm"]["year"].value.trim();
    var percentage = document.forms["academicForm"]["percentage"].value.trim();
    var cgpa = document.forms["academicForm"]["cgpa"].value.trim();
    var backlogs = document.forms["academicForm"]["backlogs"].value.trim();

    if (qualification == "") {
        alert("Qualification is required");
        document.forms["academicForm"]["qualification"].focus();
        return false;
    }
    if (year == "") {
        alert("Year is required");
        document.forms["academicForm"]["year"].focus();
        return false;
    }
    if (percentage == "") {
        alert("Percentage is required");
        document.forms["academicForm"]["percentage"].focus();
        return false;
    }
    if (percentage < 0 || percentage > 100) {
        alert("Percentage must be between 0 and 100");
        document.forms["academicForm"]["percentage"].focus();
        return false;
    }
    if (cgpa == "") {
        alert("CGPA is required");
        document.forms["academicForm"]["cgpa"].focus();
        return false;
    }
    if (cgpa < 0 || cgpa > 10) {
        alert("CGPA must be between 0 and 10");
        document.forms["academicForm"]["cgpa"].focus();
        return false;
    }
    if (backlogs == "") {
        alert("Backlogs is required");
        document.forms["academicForm"]["backlogs"].focus();
        return false;
    }
    if (backlogs < 0) {
        alert("Backlogs cannot be negative");
        document.forms["academicForm"]["backlogs"].focus();
        return false;
    }
    return true;
}
</script>

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
    background: var(--blue);
    border-color: var(--blue);
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
    font-weight: 750;
    color: var(--text-main);
}

.page-title p {
    font-size: 13px;
    color: var(--text-muted);
    margin-top: 4px;
}

/* FORM CARD CONTAINER */
.form-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    padding: 32px;
    max-width: 750px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: var(--text-main);
    margin-bottom: 8px;
}

.form-group input {
    width: 100%;
    padding: 12px 16px;
    border-radius: var(--radius-md);
    border: 1px solid var(--border-color);
    background: #fdfdfd;
    font-size: 14px;
    color: var(--text-main);
    outline: none;
    transition: .2s;
}

.form-group input:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    background: white;
}

.form-actions {
    display: flex;
    gap: 12px;
    margin-top: 30px;
}

.btn-submit {
    background: var(--primary);
    color: white;
    padding: 12px 24px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    border: none;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
    transition: .2s;
}

.btn-submit:hover {
    background: #1d4ed8;
    transform: translateY(-2px);
}

.btn-reset {
    background: #f1f5f9;
    color: var(--text-muted);
    padding: 12px 20px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    border: 1px solid var(--border-color);
    cursor: pointer;
    transition: .2s;
}

.btn-reset:hover {
    background: #e2e8f0;
}

.nav-links-bottom {
    margin-top: 24px;
    display: flex;
    gap: 20px;
    font-size: 14px;
    font-weight: 600;
}

.nav-links-bottom a {
    color: var(--primary);
}

.nav-links-bottom a:hover {
    text-decoration: underline;
}

/* FOOTER */
.footer {
    text-align: center;
    color: var(--text-muted);
    font-size: 12px;
    padding: 20px 10px;
    border-top: 1px solid var(--border-color);
    margin-top: 40px;
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
            <h1>Academic Details</h1>
            <p><span style="color:red">*</span> Indicates Mandatory Fields</p>
        </div>
    </div>

    <!-- FORM CARD -->
    <div class="form-card">
        <form name="academicForm"
              method="post"
              action="studentAcademic"
              onsubmit="return validateForm();">

            <input type="hidden"
                   name="academicId"
                   value="<%= editId == null ? "" : editId %>">

            <!-- QUALIFICATION -->
            <div class="form-group">
                <label>Qualification <span style="color:red">*</span></label>
                <input type="text"
                       name="qualification"
                       value="<%= qualificationValue %>"
                       placeholder="Example: B.Tech">
            </div>

            <!-- YEAR -->
            <div class="form-group">
                <label>Year <span style="color:red">*</span></label>
                <input type="number"
                       name="year"
                       value="<%= yearValue %>"
                       placeholder="Example: 2026">
            </div>

            <!-- PERCENTAGE -->
            <div class="form-group">
                <label>Percentage <span style="color:red">*</span></label>
                <input type="number"
                       name="percentage"
                       value="<%= percentageValue %>"
                       step="0.01"
                       placeholder="Example: 85.50">
            </div>

            <!-- CGPA -->
            <div class="form-group">
                <label>CGPA <span style="color:red">*</span></label>
                <input type="number"
                       name="cgpa"
                       value="<%= cgpaValue %>"
                       step="0.01"
                       placeholder="Example: 8.50">
            </div>

            <!-- BACKLOGS -->
            <div class="form-group">
                <label>Backlogs <span style="color:red">*</span></label>
                <input type="number"
                       name="backlogs"
                       value="<%= backlogsValue %>"
                       min="0"
                       placeholder="Example: 0">
            </div>

            <!-- BUTTONS -->
            <div class="form-actions">
                <button type="submit" class="btn-submit">
                    <%= editId == null ? "Submit Record" : "Update Record" %>
                </button>
                <button type="reset" class="btn-reset">Reset</button>
            </div>

        </form>
    </div>

    <div class="nav-links-bottom">
        <a href="student_academic_view.jsp"><i class="fa-solid fa-arrow-left"></i> View Academic Details</a>
        <a href="student_dashboard.jsp"><i class="fa-solid fa-house"></i> Back to Dashboard</a>
    </div>

    <footer class="footer">
        CampusConnect Student Portal &bull; Campus Recruitment Management System
    </footer>

</main>

</body>
</html>