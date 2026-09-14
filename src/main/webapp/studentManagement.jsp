<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");

    if(collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Student Management</title>

<style>

body {
    font-family: Arial, sans-serif;
    margin: 0;
    background-color: #f4f6f8;
}

.header {
    background-color: #2c3e50;
    color: white;
    padding: 20px 30px;
}

.header h1 {
    margin: 0;
}

.container {
    padding: 30px;
}

.back {
    display: inline-block;
    margin-bottom: 20px;
    text-decoration: none;
    color: #3498db;
    font-weight: bold;
}

.card {
    background-color: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 0 8px #ccc;
    overflow-x: auto;
}

h2 {
    color: #2c3e50;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

th {
    background-color: #3498db;
    color: white;
    padding: 12px;
}

td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
    text-align: center;
}

tr:hover {
    background-color: #f5f9ff;
}

.status {
    font-weight: bold;
}

.active {
    color: green;
}

.inactive {
    color: red;
}

.no-data {
    text-align: center;
    padding: 30px;
    color: #777;
}

</style>

</head>

<body>

<div class="header">
    <h1>Student Management</h1>
</div>

<div class="container">

    <a href="collegeAdminDashboard.jsp" class="back">
        ← Back to Dashboard
    </a>

    <div class="card">

        <h2>Students of Your College</h2>

        <table>

            <tr>
                <th>Student ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Course ID</th>
                <th>Gender</th>
                <th>Status</th>
            </tr>

<%
    try {

        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql =
            "SELECT STUDENT_ID, NAME, EMAIL, PHONE, " +
            "COURSE_ID, GENDER, STATUS " +
            "FROM STUDENT " +
            "WHERE COLLEGE_ID=? " +
            "ORDER BY STUDENT_ID";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;

            String status = rs.getString("STATUS");
%>

            <tr>

                <td><%= rs.getInt("STUDENT_ID") %></td>

                <td><%= rs.getString("NAME") %></td>

                <td><%= rs.getString("EMAIL") %></td>

                <td><%= rs.getString("PHONE") %></td>

                <td><%= rs.getInt("COURSE_ID") %></td>

                <td><%= rs.getString("GENDER") %></td>

                <td class="status
                    <%= "ACTIVE".equalsIgnoreCase(status)
                        ? "active" : "inactive" %>">

                    <%= status %>

                </td>

            </tr>

<%
        }

        if(!found) {
%>

            <tr>
                <td colspan="7" class="no-data">
                    No students found for this college.
                </td>
            </tr>

<%
        }

    } catch(Exception e) {
%>

            <tr>
                <td colspan="7" class="no-data">
                    Error: <%= e.getMessage() %>
                </td>
            </tr>

<%
    } finally {

        try {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        } catch(Exception e) {
        }

    }
%>

        </table>

    </div>

</div>

</body>
</html>