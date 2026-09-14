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

<title>Recruitment Management</title>

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
    color: green;
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
    <h1>Recruitment Management</h1>
</div>

<div class="container">

    <a href="collegeAdminDashboard.jsp" class="back">
        ← Back to Dashboard
    </a>

    <div class="card">

        <h2>Recruitment Drives</h2>

        <table>

            <tr>
                <th>Drive ID</th>
                <th>Company</th>
                <th>Drive Type</th>
                <th>Job Title</th>
                <th>Vacancy</th>
                <th>CGPA</th>
                <th>Branch</th>
                <th>Salary</th>
                <th>Deadline</th>
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
            "SELECT R.DRIVE_ID, " +
            "C.COMPANY_NAME, " +
            "R.DRIVE_TYPE, " +
            "R.JOB_TITLE, " +
            "R.VACANCY, " +
            "R.ELIGIBILITY_CGPA, " +
            "R.REQUIRED_BRANCH, " +
            "R.SALARY, " +
            "R.DEADLINE, " +
            "R.STATUS " +
            "FROM RECRUITMENT_DRIVE R " +
            "JOIN COMPANY C " +
            "ON R.COMPANY_ID = C.COMPANY_ID " +
            "JOIN DRIVE_COLLEGE DC " +
            "ON R.DRIVE_ID = DC.DRIVE_ID " +
            "WHERE DC.COLLEGE_ID = ? " +
            "ORDER BY R.DRIVE_ID";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;
%>

            <tr>

                <td><%= rs.getInt("DRIVE_ID") %></td>

                <td><%= rs.getString("COMPANY_NAME") %></td>

                <td><%= rs.getString("DRIVE_TYPE") %></td>

                <td><%= rs.getString("JOB_TITLE") %></td>

                <td><%= rs.getInt("VACANCY") %></td>

                <td><%= rs.getDouble("ELIGIBILITY_CGPA") %></td>

                <td><%= rs.getString("REQUIRED_BRANCH") %></td>

                <td>₹ <%= rs.getDouble("SALARY") %></td>

                <td><%= rs.getDate("DEADLINE") %></td>

                <td class="status">
                    <%= rs.getString("STATUS") %>
                </td>

            </tr>

<%
        }

        if(!found) {
%>

            <tr>
                <td colspan="10" class="no-data">
                    No recruitment drives found.
                </td>
            </tr>

<%
        }

    } catch(Exception e) {
%>

            <tr>
                <td colspan="10" class="no-data">
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