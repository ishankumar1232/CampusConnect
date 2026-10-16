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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Placement Opportunities | CampusConnect</title>

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
    max-width: 1800px;
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
    font-weight: 750;
    color: var(--text-main);
}

.page-title p {
    font-size: 13px;
    color: var(--text-muted);
    margin-top: 4px;
}

.btn-primary {
    background: var(--primary);
    color: white;
    padding: 10px 18px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
    transition: .2s;
}

.btn-primary:hover {
    background: #1d4ed8;
    transform: translateY(-2px);
}

/* TABLE CARD CONTAINER */
.content-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    overflow: hidden;
    margin-bottom: 30px;
}

.table-responsive {
    width: 100%;
    overflow-x: auto;
}

.data-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 13px;
}

.data-table th {
    background: #f1f5f9;
    color: #334155;
    font-weight: 700;
    padding: 16px 18px;
    border-bottom: 1px solid var(--border-color);
    white-space: nowrap;
}

.data-table td {
    padding: 16px 18px;
    border-bottom: 1px solid var(--border-color);
    color: var(--text-main);
    white-space: nowrap;
}

.data-table tbody tr:hover {
    background: var(--primary-light);
}

.data-table tbody tr:last-child td {
    border-bottom: none;
}

/* ACTION BUTTONS */
.action-btn {
    padding: 6px 14px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    cursor: pointer;
    border: none;
    transition: .2s;
}

.btn-apply {
    background: #059669;
    color: white;
}

.btn-apply:hover {
    background: #047857;
}

.applied-badge {
    color: #059669;
    font-weight: 700;
    background: #dcfce7;
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    display: inline-block;
}

.empty-state {
    padding: 40px;
    text-align: center;
    color: var(--text-muted);
}

.empty-state i {
    font-size: 36px;
    margin-bottom: 12px;
    color: #cbd5e1;
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

@media(max-width: 900px) {
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
            <h1>Eligible Placement Opportunities <i class="fa-solid fa-bullseye" style="font-size: 20px; color: var(--primary);"></i></h1>
            <p>Drives tailored to your academic branch and CGPA eligibility</p>
        </div>
        <div style="display: flex; gap: 12px; flex-wrap: wrap;">
            <a href="student_application_view.jsp" class="btn-primary">
                <i class="fa-solid fa-paper-plane"></i> My Applications
            </a>
            <a href="student_dashboard.jsp" class="btn-primary" style="background: #475569; box-shadow: 0 4px 12px rgba(71, 85, 105, 0.2);">
                <i class="fa-solid fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- TABLE CARD -->
    <div class="content-card">
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Drive ID</th>
                        <th>Company</th>
                        <th>Type</th>
                        <th>Job Title</th>
                        <th>Description</th>
                        <th>Vacancy</th>
                        <th>Req. CGPA</th>
                        <th>Branch</th>
                        <th>Skills</th>
                        <th>Salary</th>
                        <th>Deadline</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("oracle.jdbc.driver.OracleDriver");

                        con = DriverManager.getConnection(
                            "jdbc:oracle:thin:@localhost:1521:XE",
                            "CAMPUSCONNECT",
                            "campus123"
                        );

                        String sql =
                            "SELECT R.DRIVE_ID, " +
                            "C.COMPANY_NAME, " +
                            "R.DRIVE_TYPE, " +
                            "R.JOB_TITLE, " +
                            "R.DESCRIPTION, " +
                            "R.VACANCY, " +
                            "R.ELIGIBILITY_CGPA, " +
                            "R.REQUIRED_BRANCH, " +
                            "R.REQUIRED_SKILLS, " +
                            "R.SALARY, " +
                            "R.DEADLINE, " +
                            "(SELECT COUNT(*) FROM APPLICATION A WHERE A.DRIVE_ID = R.DRIVE_ID AND A.STUDENT_ID = ?) AS ALREADY_APPLIED " +
                            "FROM STUDENT S, STUDENT_ACADEMIC SA, COURSE CO, RECRUITMENT_DRIVE R, COMPANY C " +
                            "WHERE S.STUDENT_ID = SA.STUDENT_ID " +
                            "AND S.COURSE_ID = CO.COURSE_ID " +
                            "AND R.COMPANY_ID = C.COMPANY_ID " +
                            "AND R.STATUS = 'OPEN' " +
                            "AND R.DEADLINE >= SYSDATE " +
                            "AND SA.CGPA >= R.ELIGIBILITY_CGPA " +
                            "AND LOWER(CO.COURSE_NAME) LIKE '%' || LOWER(R.REQUIRED_BRANCH) || '%' " +
                            "AND S.STUDENT_ID = ? " +
                            "ORDER BY R.DEADLINE";

                        ps = con.prepareStatement(sql);
                        ps.setInt(1, studentId);
                        ps.setInt(2, studentId);

                        rs = ps.executeQuery();
                        boolean found = false;

                        while(rs.next()) {
                            found = true;
                            int driveId = rs.getInt("DRIVE_ID");
                            int alreadyApplied = rs.getInt("ALREADY_APPLIED");
                %>
                    <tr>
                        <td><strong>#<%= driveId %></strong></td>
                        <td><strong><%= rs.getString("COMPANY_NAME") %></strong></td>
                        <td><%= rs.getString("DRIVE_TYPE") %></td>
                        <td><%= rs.getString("JOB_TITLE") %></td>
                        <td><%= rs.getString("DESCRIPTION") %></td>
                        <td><%= rs.getInt("VACANCY") %></td>
                        <td><%= rs.getDouble("ELIGIBILITY_CGPA") %></td>
                        <td><%= rs.getString("REQUIRED_BRANCH") %></td>
                        <td><%= rs.getString("REQUIRED_SKILLS") %></td>
                        <td>&#8377;<%= rs.getDouble("SALARY") %></td>
                        <td><%= rs.getDate("DEADLINE") %></td>
                        <td>
                        <%
                            if(alreadyApplied > 0) {
                        %>
                            <span class="applied-badge"><i class="fa-solid fa-check"></i> Applied</span>
                        <%
                            } else {
                        %>
                            <form method="post" action="studentApply" style="display:inline;">
                                <input type="hidden" name="driveId" value="<%= driveId %>">
                                <button type="submit" class="action-btn btn-apply">
                                    <i class="fa-solid fa-paper-plane"></i> Apply
                                </button>
                            </form>
                        <%
                            }
                        %>
                        </td>
                    </tr>
                <%
                        }

                        if(!found) {
                %>
                    <tr>
                        <td colspan="12" class="empty-state">
                            <i class="fa-regular fa-folder-open"></i><br>
                            No Eligible Placement Opportunities Found matching your CGPA and branch criteria.
                        </td>
                    </tr>
                <%
                        }
                    } catch(Exception e) {
                %>
                    <tr>
                        <td colspan="12" class="empty-state" style="color: #dc2626;">
                            <i class="fa-solid fa-triangle-exclamation"></i><br>
                            Error loading opportunities: <%= e.getMessage() %>
                        </td>
                    </tr>
                <%
                    } finally {
                        try {
                            if(rs != null) rs.close();
                            if(ps != null) ps.close();
                            if(con != null) con.close();
                        } catch(Exception e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer">
        CampusConnect Student Portal &bull; Campus Recruitment Management System
    </footer>

</main>

</body>
</html>