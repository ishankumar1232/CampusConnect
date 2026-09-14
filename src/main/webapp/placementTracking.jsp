<%@ page import="java.sql.*" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");

    if(collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Placement Tracking</title>

    <style>
        body {
            margin: 0;
            font-family: Arial;
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
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px #ccc;
        }

        h2 {
            color: #2c4358;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background: #3498db;
            color: white;
            padding: 14px;
        }

        td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        .selected {
            color: green;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="header">
    Placement Tracking
</div>

<div class="back">
    <a href="collegeAdminDashboard.jsp">← Back to Dashboard</a>
</div>

<div class="box">

    <h2>Placed Students</h2>

    <table>

        <tr>
            <th>Student ID</th>
            <th>Student Name</th>
            <th>Company</th>
            <th>Job Title</th>
            <th>Drive ID</th>
            <th>Selection Date</th>
            <th>Result</th>
        </tr>

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
            "SELECT S.STUDENT_ID, S.NAME, " +
            "C.COMPANY_NAME, R.JOB_TITLE, " +
            "R.DRIVE_ID, SE.SELECTION_DATE, SE.RESULT " +
            "FROM SELECTION SE " +
            "JOIN APPLICATION A " +
            "ON SE.APPLICATION_ID = A.APPLICATION_ID " +
            "JOIN STUDENT S " +
            "ON A.STUDENT_ID = S.STUDENT_ID " +
            "JOIN RECRUITMENT_DRIVE R " +
            "ON A.DRIVE_ID = R.DRIVE_ID " +
            "JOIN COMPANY C " +
            "ON R.COMPANY_ID = C.COMPANY_ID " +
            "WHERE S.COLLEGE_ID = ? " +
            "AND SE.RESULT = 'SELECTED' " +
            "ORDER BY SE.SELECTION_DATE DESC";

        ps = con.prepareStatement(sql);
        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;
%>

        <tr>
            <td><%=rs.getInt("STUDENT_ID")%></td>
            <td><%=rs.getString("NAME")%></td>
            <td><%=rs.getString("COMPANY_NAME")%></td>
            <td><%=rs.getString("JOB_TITLE")%></td>
            <td><%=rs.getInt("DRIVE_ID")%></td>
            <td><%=rs.getDate("SELECTION_DATE")%></td>
            <td class="selected">
                <%=rs.getString("RESULT")%>
            </td>
        </tr>

<%
        }

        if(!found) {
%>

        <tr>
            <td colspan="7">
                No placed students found.
            </td>
        </tr>

<%
        }

    } catch(Exception e) {
%>

        <tr>
            <td colspan="7">
                Error: <%=e.getMessage()%>
            </td>
        </tr>

<%
    } finally {

        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(ps != null) try { ps.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}
    }
%>

    </table>

</div>

</body>
</html>