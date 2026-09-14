<%@ page import="java.sql.*" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");

    if(collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }

    int totalStudents = 0;
    int pendingAdmissions = 0;
    int totalDrives = 0;
    int placedStudents = 0;
    int shortlistedStudents = 0;
    int rejectedApplications = 0;

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

        // Total Students
        String sql1 =
            "SELECT COUNT(*) FROM STUDENT WHERE COLLEGE_ID=?";

        ps = con.prepareStatement(sql1);
        ps.setInt(1, collegeId);
        rs = ps.executeQuery();

        if(rs.next()) {
            totalStudents = rs.getInt(1);
        }

        rs.close();
        ps.close();


        // Pending Admissions
        String sql2 =
            "SELECT COUNT(*) FROM ADMISSION " +
            "WHERE COLLEGE_ID=? AND STATUS='PENDING'";

        ps = con.prepareStatement(sql2);
        ps.setInt(1, collegeId);
        rs = ps.executeQuery();

        if(rs.next()) {
            pendingAdmissions = rs.getInt(1);
        }

        rs.close();
        ps.close();


        // Recruitment Drives
        String sql3 =
            "SELECT COUNT(*) " +
            "FROM DRIVE_COLLEGE " +
            "WHERE COLLEGE_ID=?";

        ps = con.prepareStatement(sql3);
        ps.setInt(1, collegeId);
        rs = ps.executeQuery();

        if(rs.next()) {
            totalDrives = rs.getInt(1);
        }

        rs.close();
        ps.close();


        // Placed Students
        String sql4 =
            "SELECT COUNT(*) " +
            "FROM SELECTION SE " +
            "JOIN APPLICATION A " +
            "ON SE.APPLICATION_ID=A.APPLICATION_ID " +
            "JOIN STUDENT S " +
            "ON A.STUDENT_ID=S.STUDENT_ID " +
            "WHERE S.COLLEGE_ID=? " +
            "AND SE.RESULT='SELECTED'";

        ps = con.prepareStatement(sql4);
        ps.setInt(1, collegeId);
        rs = ps.executeQuery();

        if(rs.next()) {
            placedStudents = rs.getInt(1);
        }

        rs.close();
        ps.close();


        // Shortlisted Applications
        String sql5 =
            "SELECT COUNT(*) " +
            "FROM APPLICATION A " +
            "JOIN STUDENT S " +
            "ON A.STUDENT_ID=S.STUDENT_ID " +
            "WHERE S.COLLEGE_ID=? " +
            "AND A.COLLEGE_SHORTLIST_STATUS='SHORTLISTED'";

        ps = con.prepareStatement(sql5);
        ps.setInt(1, collegeId);
        rs = ps.executeQuery();

        if(rs.next()) {
            shortlistedStudents = rs.getInt(1);
        }

        rs.close();
        ps.close();


        // Rejected Applications
        String sql6 =
            "SELECT COUNT(*) " +
            "FROM APPLICATION A " +
            "JOIN STUDENT S " +
            "ON A.STUDENT_ID=S.STUDENT_ID " +
            "WHERE S.COLLEGE_ID=? " +
            "AND A.COLLEGE_SHORTLIST_STATUS='REJECTED'";

        ps = con.prepareStatement(sql6);
        ps.setInt(1, collegeId);
        rs = ps.executeQuery();

        if(rs.next()) {
            rejectedApplications = rs.getInt(1);
        }

        rs.close();
        ps.close();

        con.close();

    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>

<head>

    <title>College Reports</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .header {
            background: #2c4358;
            color: white;
            padding: 25px 35px;
            font-size: 32px;
            font-weight: bold;
        }

        .back {
            margin: 30px;
        }

        .back a {
            color: #2196f3;
            text-decoration: none;
            font-size: 18px;
        }

        .box {
            background: white;
            margin: 20px 30px;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px #ccc;
        }

        h2 {
            color: #2c4358;
        }

        .cards {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .card {
            flex: 1;
            min-width: 200px;
            background: #f8fafc;
            padding: 25px;
            text-align: center;
            border-radius: 10px;
            border: 1px solid #ddd;
        }

        .card h3 {
            margin: 0;
            font-size: 35px;
            color: #3498db;
        }

        .card p {
            color: #555;
            font-size: 16px;
        }

        .report {
            margin-top: 30px;
        }

        .bar {
            background: #e5e7eb;
            height: 25px;
            border-radius: 5px;
            margin: 10px 0 20px;
        }

        .bar span {
            display: block;
            height: 25px;
            background: #3498db;
            border-radius: 5px;
        }

        .label {
            font-weight: bold;
            color: #333;
        }

    </style>

</head>

<body>

<div class="header">
    College Reports
</div>

<div class="back">
    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>
</div>


<div class="box">

    <h2>College Statistics</h2>

    <div class="cards">

        <div class="card">
            <h3><%=totalStudents%></h3>
            <p>Total Students</p>
        </div>

        <div class="card">
            <h3><%=pendingAdmissions%></h3>
            <p>Pending Admissions</p>
        </div>

        <div class="card">
            <h3><%=totalDrives%></h3>
            <p>Recruitment Drives</p>
        </div>

        <div class="card">
            <h3><%=placedStudents%></h3>
            <p>Placed Students</p>
        </div>

    </div>


    <div class="report">

        <h2>Recruitment Report</h2>

        <p class="label">
            Shortlisted Applications:
            <%=shortlistedStudents%>
        </p>

        <div class="bar">
            <span style="width:<%=shortlistedStudents * 10%>%;"></span>
        </div>


        <p class="label">
            Rejected Applications:
            <%=rejectedApplications%>
        </p>

        <div class="bar">
            <span style="width:<%=rejectedApplications * 10%>%;"></span>
        </div>


        <p class="label">
            Placed Students:
            <%=placedStudents%>
        </p>

        <div class="bar">
            <span style="width:<%=placedStudents * 10%>%;"></span>
        </div>

    </div>

</div>

</body>

</html>