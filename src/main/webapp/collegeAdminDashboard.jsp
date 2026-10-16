<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.campusconnect.bean.College" %>
<%@ page import="com.campusconnect.bean.Student" %>
<%@ page import="com.campusconnect.bean.Admission" %>

<%

    Integer collegeId =
        (Integer) session.getAttribute("collegeId");

    String adminName =
        (String) session.getAttribute("adminName");


    if(collegeId == null)
    {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }


    /* ================= COLLEGE ================= */

    College college = new College();

    String collegeName =
        college.getCollegeNameById(collegeId);

    String logoImage = "";
    String coverImage = "";
    String city = "";
    String state = "";


    /* ================= STUDENTS ================= */

    Student student = new Student();

    int totalStudents =
        student.getStudentCount(collegeId);


    /* ================= ADMISSIONS ================= */

    Admission admission = new Admission();

    int admissionRequests =
        admission.getPendingAdmissionCount(collegeId);


    int recruitmentDrives = 0;
    int placedStudents = 0;


    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;


    try
    {

        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );


        con = DriverManager.getConnection(

            "jdbc:oracle:thin:@localhost:1521:XE",

            "CAMPUSCONNECT",

            "campus123"

        );


        /* ================= COLLEGE DETAILS ================= */

        String collegeSql =

            "SELECT COLLEGE_NAME, CITY, STATE, " +
            "LOGO_IMAGE, COVER_IMAGE " +
            "FROM COLLEGE " +
            "WHERE COLLEGE_ID=?";


        ps = con.prepareStatement(collegeSql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();


        if(rs.next())
        {

            collegeName =
                rs.getString("COLLEGE_NAME");

            city =
                rs.getString("CITY");

            state =
                rs.getString("STATE");

            logoImage =
                rs.getString("LOGO_IMAGE");

            coverImage =
                rs.getString("COVER_IMAGE");

        }


        rs.close();
        ps.close();


        /* ================= RECRUITMENT DRIVES ================= */

        String sql1 =

            "SELECT COUNT(*) " +
            "FROM DRIVE_COLLEGE " +
            "WHERE COLLEGE_ID=?";


        ps = con.prepareStatement(sql1);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();


        if(rs.next())
        {
            recruitmentDrives =
                rs.getInt(1);
        }


        rs.close();
        ps.close();


        /* ================= PLACED STUDENTS ================= */

        String sql2 =

            "SELECT COUNT(*) " +

            "FROM SELECTION SE " +

            "JOIN APPLICATION A " +

            "ON SE.APPLICATION_ID=A.APPLICATION_ID " +

            "JOIN STUDENT S " +

            "ON A.STUDENT_ID=S.STUDENT_ID " +

            "WHERE S.COLLEGE_ID=? " +

            "AND SE.RESULT='SELECTED'";


        ps = con.prepareStatement(sql2);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();


        if(rs.next())
        {
            placedStudents =
                rs.getInt(1);
        }


        rs.close();
        ps.close();

    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    finally
    {

        if(rs != null)
        {
            try
            {
                rs.close();
            }
            catch(Exception e)
            {
            }
        }


        if(ps != null)
        {
            try
            {
                ps.close();
            }
            catch(Exception e)
            {
            }
        }


        if(con != null)
        {
            try
            {
                con.close();
            }
            catch(Exception e)
            {
            }
        }

    }

%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>College Admin Dashboard</title>


<style>

/* =====================================================
   BASIC
===================================================== */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}


body {

    font-family: Arial, sans-serif;

    background: #f4f7fb;

    color: #173b5c;

}


/* =====================================================
   SIDEBAR
===================================================== */

.sidebar {

    position: fixed;

    left: 0;

    top: 0;

    width: 260px;

    height: 100vh;

    background: #082f50;

    color: white;

    padding: 18px 15px;

    overflow-y: auto;

}


.logo-area {

    display: flex;

    align-items: center;

    gap: 12px;

    padding: 5px 10px 28px;

}


.logo-area img {

    width: 52px;

    height: 52px;

    border-radius: 50%;

    object-fit: cover;

    background: white;

    border: 2px solid white;

}


.logo-name {

    font-size: 21px;

    font-weight: bold;

}


.logo-name span {

    color: #19a8e8;

}


.logo-sub {

    font-size: 10px;

    color: #bcd3e4;

    margin-top: 4px;

}


/* =====================================================
   MENU
===================================================== */

.menu {

    margin-top: 5px;

}


.menu a {

    display: flex;

    align-items: center;

    gap: 14px;

    color: #e6f1f8;

    text-decoration: none;

    padding: 13px 14px;

    margin: 4px 0;

    border-radius: 9px;

    font-size: 14px;

    transition: 0.2s;

}


.menu a:hover {

    background: #124f78;

}


.menu a.active {

    background: linear-gradient(
        90deg,
        #087ff5,
        #168ff5
    );

    color: white;

}


.menu-icon {

    width: 28px;

    height: 28px;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 18px;

}


.logout-area {

    margin-top: 20px;

    padding-top: 15px;

    border-top: 1px solid #31536c;

}


.logout {

    display: flex;

    align-items: center;

    gap: 14px;

    padding: 13px 14px;

    color: white;

    text-decoration: none;

    border-radius: 9px;

}


.logout:hover {

    background: #d9363e;

}


/* =====================================================
   MAIN
===================================================== */

.main {

    margin-left: 260px;

    min-height: 100vh;

}


/* =====================================================
   TOPBAR
===================================================== */

.topbar {

    height: 72px;

    background: #07385e;

    display: flex;

    align-items: center;

    justify-content: flex-end;

    padding: 0 30px;

    color: white;

}


.admin-area {

    display: flex;

    align-items: center;

    gap: 13px;

}


.admin-logo {

    width: 48px;

    height: 48px;

    border-radius: 50%;

    object-fit: cover;

    background: white;

    border: 2px solid white;

}


.admin-details strong {

    display: block;

    font-size: 15px;

}


.admin-details span {

    display: block;

    margin-top: 3px;

    font-size: 12px;

    color: #c4d8e7;

}


/* =====================================================
   CONTENT
===================================================== */

.content {

    padding: 18px 22px;

}


/* =====================================================
   COLLEGE BANNER
===================================================== */

.college-banner {

    position: relative;

    height: 250px;

    border-radius: 16px;

    overflow: hidden;

    background: #0b3d64;

    box-shadow:
        0 5px 20px rgba(0,0,0,0.12);

}


.college-banner .cover {

    position: absolute;

    width: 100%;

    height: 100%;

    object-fit: cover;

}


.banner-overlay {

    position: absolute;

    inset: 0;

    background:
        linear-gradient(
            90deg,
            rgba(4,35,60,0.96),
            rgba(5,55,88,0.70),
            rgba(5,55,88,0.10)
        );

}


.banner-content {

    position: absolute;

    left: 38px;

    top: 35px;

    display: flex;

    align-items: center;

    gap: 25px;

    color: white;

}


.college-logo {

    width: 135px;

    height: 135px;

    border-radius: 50%;

    object-fit: cover;

    background: white;

    padding: 5px;

    border: 4px solid white;

}


.banner-text h1 {

    font-size: 32px;

    margin-bottom: 12px;

}


.location {

    font-size: 16px;

    margin-bottom: 16px;

}


.welcome-text {

    font-size: 15px;

    color: #d9eaf5;

}


.tagline {

    margin-top: 12px;

    color: #c9dce9;

    font-size: 14px;

    font-style: italic;

}


/* =====================================================
   STAT CARDS
===================================================== */

.stats {

    display: grid;

    grid-template-columns:
        repeat(4, 1fr);

    gap: 18px;

    margin-top: 18px;

}


.stat-card {

    background: white;

    min-height: 130px;

    padding: 20px;

    border-radius: 14px;

    display: flex;

    align-items: center;

    gap: 17px;

    border: 1px solid #e3ebf3;

    box-shadow:
        0 4px 15px rgba(0,0,0,0.07);

}


.stat-icon {

    width: 58px;

    height: 58px;

    border-radius: 50%;

    display: flex;

    align-items: center;

    justify-content: center;

    background: #e8f3ff;

    font-size: 27px;

}


.stat-number {

    font-size: 31px;

    font-weight: bold;

    color: #153e5f;

}


.stat-name {

    margin-top: 5px;

    color: #61758a;

    font-size: 14px;

}


.stat-link {

    display: block;

    margin-top: 8px;

    color: #1685ed;

    text-decoration: none;

    font-size: 12px;

}


.stat-link:hover {

    text-decoration: underline;

}


/* =====================================================
   QUICK ACTIONS
===================================================== */

.section-box {

    background: white;

    margin-top: 20px;

    padding: 20px;

    border-radius: 14px;

    box-shadow:
        0 4px 15px rgba(0,0,0,0.07);

}


.section-heading {

    font-size: 21px;

    font-weight: bold;

    margin-bottom: 18px;

    color: #173d5e;

}


.quick-actions {

    display: grid;

    grid-template-columns:
        repeat(6, 1fr);

    gap: 12px;

}


.action {

    min-height: 100px;

    display: flex;

    flex-direction: column;

    justify-content: center;

    align-items: center;

    text-align: center;

    text-decoration: none;

    border-radius: 11px;

    background: #edf7ff;

    color: #0879cf;

    transition: 0.2s;

}


.action:hover {

    transform: translateY(-3px);

    box-shadow:
        0 6px 14px rgba(0,0,0,0.10);

}


.action-icon {

    font-size: 28px;

    margin-bottom: 9px;

}


.action strong {

    font-size: 13px;

}


/* =====================================================
   LOWER PANELS
===================================================== */

.lower-section {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 20px;

    margin-top: 20px;

}


.panel {

    background: white;

    padding: 20px;

    border-radius: 14px;

    box-shadow:
        0 4px 15px rgba(0,0,0,0.07);

}


.panel-title {

    font-size: 20px;

    font-weight: bold;

    margin-bottom: 12px;

    color: #173d5e;

}


.activity {

    padding: 13px 5px;

    border-bottom: 1px solid #e6edf3;

    font-size: 14px;

}


.activity:last-child {

    border-bottom: none;

}


.activity-dot {

    display: inline-block;

    width: 9px;

    height: 9px;

    border-radius: 50%;

    background: #1685ed;

    margin-right: 10px;

}


.activity-time {

    float: right;

    color: #8999a8;

    font-size: 12px;

}


.notice {

    padding: 13px;

    border-radius: 9px;

    background: #eef7ff;

    margin-bottom: 9px;

    font-size: 14px;

}


.notice strong {

    display: block;

    margin-bottom: 5px;

    color: #214766;

}


.notice small {

    color: #718494;

}


/* =====================================================
   FOOTER
===================================================== */

.footer {

    margin-top: 20px;

    padding: 15px 20px;

    background: #07385e;

    color: white;

    display: flex;

    justify-content: space-between;

    font-size: 12px;

}


/* =====================================================
   RESPONSIVE
===================================================== */

@media(max-width: 1200px)
{

    .quick-actions {

        grid-template-columns:
            repeat(3, 1fr);

    }

}


@media(max-width: 950px)
{

    .stats {

        grid-template-columns:
            repeat(2, 1fr);

    }


    .lower-section {

        grid-template-columns: 1fr;

    }

}


@media(max-width: 700px)
{

    .sidebar {

        width: 75px;

    }


    .main {

        margin-left: 75px;

    }


    .logo-name,
    .logo-sub,
    .menu-text {

        display: none;

    }


    .menu a {

        justify-content: center;

    }


    .logout {

        justify-content: center;

    }


    .banner-content {

        left: 20px;

    }


    .college-logo {

        width: 100px;

        height: 100px;

    }


    .banner-text h1 {

        font-size: 22px;

    }


    .stats {

        grid-template-columns: 1fr;

    }


    .footer {

        flex-direction: column;

        gap: 6px;

    }

}

</style>

</head>


<body>


<!-- =====================================================
     SIDEBAR
===================================================== -->

<div class="sidebar">


    <div class="logo-area">


        <%
        if(logoImage != null &&
           !logoImage.trim().equals(""))
        {
        %>

            <img
                src="college_images/<%=logoImage%>"
                alt="College Logo"
            >

        <%
        }
        else
        {
        %>

            <img
                src="images/college-logo.png"
                alt="CampusConnect"
            >

        <%
        }
        %>


        <div>

            <div class="logo-name">

                Campus<span>Connect</span>

            </div>

            <div class="logo-sub">

                Empowering Campus Careers

            </div>

        </div>


    </div>



    <div class="menu">


        <a
            href="collegeAdminDashboard.jsp"
            class="active"
        >

            <span class="menu-icon">🏠</span>

            <span class="menu-text">
                Dashboard
            </span>

        </a>


        <a href="collegeProfile.jsp">

            <span class="menu-icon">🏫</span>

            <span class="menu-text">
                College Profile
            </span>

        </a>


        <a href="admissionManagement.jsp">

            <span class="menu-icon">📄</span>

            <span class="menu-text">
                Admission Management
            </span>

        </a>


        <a href="studentManagement.jsp">

            <span class="menu-icon">👥</span>

            <span class="menu-text">
                Student Management
            </span>

        </a>


        <a href="facultyManagement.jsp">

            <span class="menu-icon">👨‍🏫</span>

            <span class="menu-text">
                Faculty Management
            </span>

        </a>


        <a href="departmentManagement.jsp">

            <span class="menu-icon">🏢</span>

            <span class="menu-text">
                Department Management
            </span>

        </a>


        <a href="courseManagement.jsp">

            <span class="menu-icon">📚</span>

            <span class="menu-text">
                Course Management
            </span>

        </a>


        <a href="recruitmentManagement.jsp">

            <span class="menu-icon">💼</span>

            <span class="menu-text">
                Recruitment Management
            </span>

        </a>


        <a href="applicationManagement.jsp">

            <span class="menu-icon">📋</span>

            <span class="menu-text">
                Application Management
            </span>

        </a>


        <a href="interviewManagement.jsp">

            <span class="menu-icon">🎤</span>

            <span class="menu-text">
                Interview Management
            </span>

        </a>


        <a href="selectionManagement.jsp">

            <span class="menu-icon">✅</span>

            <span class="menu-text">
                Selection Management
            </span>

        </a>


        <a href="placementTracking.jsp">

            <span class="menu-icon">📈</span>

            <span class="menu-text">
                Placement Tracking
            </span>

        </a>


        <a href="noticeManagement.jsp">

            <span class="menu-icon">🔔</span>

            <span class="menu-text">
                Notices / Announcements
            </span>

        </a>


        <a href="collegeReports.jsp">

            <span class="menu-icon">📊</span>

            <span class="menu-text">
                Reports
            </span>

        </a>


    </div>



    <div class="logout-area">

        <a
            href="collegeAdminLogout.jsp"
            class="logout"
        >

            <span class="menu-icon">↪</span>

            <span class="menu-text">
                Logout
            </span>

        </a>

    </div>


</div>



<!-- =====================================================
     MAIN
===================================================== -->

<div class="main">


    <!-- TOPBAR -->

    <div class="topbar">


        <div class="admin-area">


            <%
            if(logoImage != null &&
               !logoImage.trim().equals(""))
            {
            %>

                <img
                    src="college_images/<%=logoImage%>"
                    class="admin-logo"
                    alt="College Logo"
                >

            <%
            }
            else
            {
            %>

                <img
                    src="images/college-logo.png"
                    class="admin-logo"
                    alt="College Logo"
                >

            <%
            }
            %>


            <div class="admin-details">

                <strong>
                    <%=collegeName%>
                </strong>

                <span>
                    College Admin
                </span>

            </div>


        </div>


    </div>



    <div class="content">


        <!-- COLLEGE BANNER -->

        <div class="college-banner">


            <%
            if(coverImage != null &&
               !coverImage.trim().equals(""))
            {
            %>

                <img
                    src="college_images/<%=coverImage%>"
                    class="cover"
                    alt="College Banner"
                >

            <%
            }
            else
            {
            %>

                <div
                    style="
                        position:absolute;
                        inset:0;
                        background:#123f64;
                    "
                ></div>

            <%
            }
            %>


            <div class="banner-overlay"></div>


            <div class="banner-content">


                <%
                if(logoImage != null &&
                   !logoImage.trim().equals(""))
                {
                %>

                    <img
                        src="college_images/<%=logoImage%>"
                        class="college-logo"
                        alt="College Logo"
                    >

                <%
                }
                else
                {
                %>

                    <img
                        src="images/college-logo.png"
                        class="college-logo"
                        alt="College Logo"
                    >

                <%
                }
                %>


                <div class="banner-text">


                    <h1>
                        <%=collegeName%>
                    </h1>


                    <div class="location">

                        📍 <%=city%>, <%=state%>

                    </div>


                    <div class="welcome-text">

                        Welcome back,
                        <strong>
                            <%=adminName%>
                        </strong>

                    </div>


                    <div class="tagline">

                        "Knowledge Today, Better Tomorrow"

                    </div>


                </div>


            </div>


        </div>



        <!-- STAT CARDS -->

        <div class="stats">


            <div class="stat-card">


                <div class="stat-icon">
                    🎓
                </div>


                <div>

                    <div class="stat-number">
                        <%=totalStudents%>
                    </div>

                    <div class="stat-name">
                        Total Students
                    </div>

                    <a
                        href="studentManagement.jsp"
                        class="stat-link"
                    >
                        View Details →
                    </a>

                </div>


            </div>



            <div class="stat-card">


                <div class="stat-icon">
                    📄
                </div>


                <div>

                    <div class="stat-number">
                        <%=admissionRequests%>
                    </div>

                    <div class="stat-name">
                        Admission Requests
                    </div>

                    <a
                        href="admissionManagement.jsp"
                        class="stat-link"
                    >
                        View Details →
                    </a>

                </div>


            </div>



            <div class="stat-card">


                <div class="stat-icon">
                    📢
                </div>


                <div>

                    <div class="stat-number">
                        <%=recruitmentDrives%>
                    </div>

                    <div class="stat-name">
                        Recruitment Drives
                    </div>

                    <a
                        href="recruitmentManagement.jsp"
                        class="stat-link"
                    >
                        View Details →
                    </a>

                </div>


            </div>



            <div class="stat-card">


                <div class="stat-icon">
                    💼
                </div>


                <div>

                    <div class="stat-number">
                        <%=placedStudents%>
                    </div>

                    <div class="stat-name">
                        Placed Students
                    </div>

                    <a
                        href="placementTracking.jsp"
                        class="stat-link"
                    >
                        View Details →
                    </a>

                </div>


            </div>


        </div>



        <!-- QUICK ACTIONS -->

        <div class="section-box">


            <div class="section-heading">

                ⚡ Quick Actions

            </div>


            <div class="quick-actions">


                <a
                    href="collegeProfile.jsp"
                    class="action"
                >

                    <div class="action-icon">
                        🏫
                    </div>

                    <strong>
                        Edit College Profile
                    </strong>

                </a>


                <a
                    href="admissionManagement.jsp"
                    class="action"
                >

                    <div class="action-icon">
                        📄
                    </div>

                    <strong>
                        Manage Admissions
                    </strong>

                </a>


                <a
                    href="studentManagement.jsp"
                    class="action"
                >

                    <div class="action-icon">
                        👥
                    </div>

                    <strong>
                        View Students
                    </strong>

                </a>


                <a
                    href="facultyManagement.jsp"
                    class="action"
                >

                    <div class="action-icon">
                        👨‍🏫
                    </div>

                    <strong>
                        Manage Faculty
                    </strong>

                </a>


                <a
                    href="recruitmentManagement.jsp"
                    class="action"
                >

                    <div class="action-icon">
                        📢
                    </div>

                    <strong>
                        Create Drive
                    </strong>

                </a>


                <a
                    href="collegeReports.jsp"
                    class="action"
                >

                    <div class="action-icon">
                        📊
                    </div>

                    <strong>
                        View Reports
                    </strong>

                </a>


            </div>


        </div>



        <!-- LOWER SECTION -->

        <div class="lower-section">


            <!-- RECENT ACTIVITIES -->

            <div class="panel">


                <div class="panel-title">

                    🕘 Recent Activities

                </div>


                <div class="activity">

                    <span class="activity-dot"></span>

                    New admission request received

                    <span class="activity-time">
                        Recent
                    </span>

                </div>


                <div class="activity">

                    <span
                        class="activity-dot"
                        style="background:#19b86b;"
                    ></span>

                    Student profile updated

                    <span class="activity-time">
                        Recent
                    </span>

                </div>


                <div class="activity">

                    <span
                        class="activity-dot"
                        style="background:#8e44ad;"
                    ></span>

                    Recruitment drive added

                    <span class="activity-time">
                        Recent
                    </span>

                </div>


                <div class="activity">

                    <span
                        class="activity-dot"
                        style="background:#e74c3c;"
                    ></span>

                    Faculty information updated

                    <span class="activity-time">
                        Recent
                    </span>

                </div>


            </div>



            <!-- ANNOUNCEMENTS -->

            <div class="panel">


                <div class="panel-title">

                    📣 Announcements

                </div>


                <div class="notice">

                    <strong>
                        Placement Drive Notice
                    </strong>

                    New recruitment drive has been scheduled.

                    <small>
                        Check recruitment details.
                    </small>

                </div>


                <div class="notice">

                    <strong>
                        Admission Process
                    </strong>

                    Please review pending admission requests.

                    <small>
                        Admission Management
                    </small>

                </div>


                <div class="notice">

                    <strong>
                        College Profile
                    </strong>

                    Keep college information updated.

                    <small>
                        College Profile
                    </small>

                </div>


            </div>


        </div>



        <!-- FOOTER -->

        <div class="footer">


            <div>

                © 2026 CampusConnect.
                All rights reserved.

            </div>


            <div>

                <%=collegeName%>
                |
                Empowering Campus Careers

            </div>


        </div>


    </div>


</div>


</body>

</html>