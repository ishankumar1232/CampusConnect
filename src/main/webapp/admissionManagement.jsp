<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");
    String adminName = (String) session.getAttribute("adminName");

    if(collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Admission Management</title>

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
    margin-bottom: 20px;
}

.back a {
    text-decoration: none;
    color: #3498db;
}

h2 {
    color: #2c3e50;
}

table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
    box-shadow: 0 0 8px #ccc;
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
    background-color: #f1f1f1;
}

.status {
    color: #e67e22;
    font-weight: bold;
}

</style>

</head>

<body>

<div class="header">

    <h1>Admission Management</h1>

</div>


<div class="container">

    <div class="back">

        <a href="collegeAdminDashboard.jsp">
            ← Back to Dashboard
        </a>

    </div>


    <h2>
        Pending Admission Requests
    </h2>


    <table>

        <tr>

            <th>Admission ID</th>
            <th>Applicant Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Course ID</th>
            <th>Date</th>
            <th>Status</th>
            <th>Action</th>

        </tr>

<%
    try {

        Class.forName("oracle.jdbc.driver.OracleDriver");

        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql =
            "SELECT ADMISSION_ID, APPLICANT_NAME, " +
            "APPLICANT_EMAIL, APPLICANT_PHONE, " +
            "APPLICANT_COURSE_ID, ADMISSION_DATE, STATUS " +
            "FROM ADMISSION " +
            "WHERE COLLEGE_ID=? AND STATUS='PENDING' " +
            "ORDER BY ADMISSION_ID";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId.intValue());

        ResultSet rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;
%>

        <tr>

            <td>
                <%= rs.getInt("ADMISSION_ID") %>
            </td>

            <td>
                <%= rs.getString("APPLICANT_NAME") %>
            </td>

            <td>
                <%= rs.getString("APPLICANT_EMAIL") %>
            </td>

            <td>
                <%= rs.getString("APPLICANT_PHONE") %>
            </td>

            <td>
                <%= rs.getInt("APPLICANT_COURSE_ID") %>
            </td>

            <td>
                <%= rs.getDate("ADMISSION_DATE") %>
            </td>

            <td class="status">
    <%= rs.getString("STATUS") %>
</td>

<td>

    <form action="AdmissionStatusController" method="post"
          style="display:inline;">

        <input type="hidden"
               name="admissionId"
               value="<%= rs.getInt("ADMISSION_ID") %>">

        <input type="hidden"
               name="status"
               value="APPROVED">

        <button type="submit">
            Approve
        </button>

    </form>


    <form action="AdmissionStatusController" method="post"
          style="display:inline;">

        <input type="hidden"
               name="admissionId"
               value="<%= rs.getInt("ADMISSION_ID") %>">

        <input type="hidden"
               name="status"
               value="REJECTED">

        <button type="submit">
            Reject
        </button>

    </form>

</td>

        </tr>

<%
        }

        if(!found) {
%>

        <tr>

            <td colspan="8">
                No Pending Admission Requests
            </td>

        </tr>

<%
        }

        rs.close();
        ps.close();
        con.close();

    } catch(Exception e) {
%>

        <tr>

            <td colspan="8">

                Error:
                <%= e.getMessage() %>

            </td>

        </tr>

<%
    }
%>

    </table>

</div>

</body>

</html>