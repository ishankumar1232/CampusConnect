<%@ page import="java.sql.*" %>
<%@ page import="com.campusconnect.bean.College" %>
<%@ page import="com.campusconnect.bean.Student" %>
<%@ page import="com.campusconnect.bean.Admission" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");
    String adminName = (String) session.getAttribute("adminName");

    if(collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }

    College college = new College();

    String collegeName =
        college.getCollegeNameById(collegeId);

    Student student = new Student();

    int totalStudents =
        student.getStudentCount(collegeId);

    Admission admission = new Admission();

    int admissionRequests =
        admission.getPendingAdmissionCount(collegeId);


    int recruitmentDrives = 0;
    int placedStudents = 0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );


        // Recruitment Drives

        String sql1 =
            "SELECT COUNT(*) " +
            "FROM DRIVE_COLLEGE " +
            "WHERE COLLEGE_ID=?";

        ps = con.prepareStatement(sql1);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        if(rs.next()) {
            recruitmentDrives = rs.getInt(1);
        }

        rs.close();
        ps.close();


        // Placed Students

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

        if(rs.next()) {
            placedStudents = rs.getInt(1);
        }

        rs.close();
        ps.close();

        con.close();

    } catch(Exception e) {

        e.printStackTrace();

    } finally {

        if(rs != null) {
            try {
                rs.close();
            } catch(Exception e) {}
        }

        if(ps != null) {
            try {
                ps.close();
            } catch(Exception e) {}
        }

        if(con != null) {
            try {
                con.close();
            } catch(Exception e) {}
        }

    }
%>

<!DOCTYPE html>
<html>

<head>

    <title>College Admin Dashboard</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .header {
            background: #2c4358;
            color: white;
            padding: 25px 40px;
            font-size: 30px;
            font-weight: bold;
        }

        .welcome {
            padding: 25px 40px 10px;
            color: #333;
        }

        .welcome h2 {
            margin: 0;
            color: #2c4358;
        }

        .welcome p {
            margin-top: 8px;
            color: #666;
            font-size: 16px;
        }


        /* Cards */

        .cards {
            display: flex;
            gap: 20px;
            padding: 20px 40px;
        }

        .card {
            background: white;
            flex: 1;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px #ccc;
            text-align: center;
        }

        .card h3 {
            margin: 0;
            font-size: 35px;
            color: #3498db;
        }

        .card p {
            margin-top: 10px;
            font-size: 17px;
            color: #555;
        }


        /* Menu */

        .menu {
            background: white;
            margin: 20px 40px;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px #ccc;
        }

        .menu h2 {
            color: #2c4358;
            margin-top: 0;
        }

        .menu a {
            display: block;
            padding: 14px;
            margin: 8px 0;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .menu a:hover {
            background: #217dbb;
        }


        /* Logout */

        .logout {
            background: #e74c3c !important;
        }

        .logout:hover {
            background: #c0392b !important;
        }


        /* Mobile */

        @media(max-width: 800px) {

            .cards {
                flex-direction: column;
            }

            .header {
                font-size: 25px;
            }

        }

    </style>

</head>


<body>


<!-- Header -->

<div class="header">

    College Admin Dashboard

</div>


<!-- Welcome -->

<div class="welcome">

    <h2>
        Welcome, <%=adminName%>
    </h2>

    <p>
        College:
        <strong><%=collegeName%></strong>
    </p>

</div>


<!-- Dashboard Cards -->

<div class="cards">


    <!-- Total Students -->

    <div class="card">

        <h3>
            <%=totalStudents%>
        </h3>

        <p>
            Total Students
        </p>

    </div>


    <!-- Admission Requests -->

    <div class="card">

        <h3>
            <%=admissionRequests%>
        </h3>

        <p>
            Admission Requests
        </p>

    </div>


    <!-- Recruitment Drives -->

    <div class="card">

        <h3>
            <%=recruitmentDrives%>
        </h3>

        <p>
            Recruitment Drives
        </p>

    </div>


    <!-- Placed Students -->

    <div class="card">

        <h3>
            <%=placedStudents%>
        </h3>

        <p>
            Placed Students
        </p>

    </div>

</div>


<!-- College Admin Menu -->

<div class="menu">

    <h2>
        College Management
    </h2>


    <a href="collegeProfile.jsp">
        College Profile
    </a>


    <a href="admissionManagement.jsp">
        Admission Management
    </a>


    <a href="studentManagement.jsp">
        Student Management
    </a>


    <a href="facultyManagement.jsp">
        Faculty Management
    </a>


    <a href="departmentManagement.jsp">
        Department Management
    </a>


    <a href="courseManagement.jsp">
        Course Management
    </a>


    <a href="recruitmentManagement.jsp">
        Recruitment Management
    </a>


    <a href="applicationManagement.jsp">
        Application Management
    </a>


    <a href="interviewManagement.jsp">
        Interview Management
    </a>


    <a href="selectionManagement.jsp">
        Selection Management
    </a>


    <a href="placementTracking.jsp">
        Placement Tracking
    </a>


    <a href="noticeManagement.jsp">
        Notices / Announcements
    </a>


    <a href="collegeReports.jsp">
        Reports
    </a>


    <a href="collegeAdminLogout.jsp"
       class="logout">

        Logout

    </a>

</div>


</body>

</html>
