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

    <title>Application Management</title>

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

        .pending {
            color: orange;
            font-weight: bold;
        }

        .applied {
            color: #2196f3;
            font-weight: bold;
        }

        select {
            padding: 7px;
        }

        button {
            padding: 7px 12px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background: #217dbb;
        }

    </style>

</head>

<body>

<div class="header">
    Application Management
</div>


<div class="back">
    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>
</div>


<div class="box">

    <h2>Student Applications</h2>

    <table>

        <tr>
            <th>Application ID</th>
            <th>Student ID</th>
            <th>Student Name</th>
            <th>Company</th>
            <th>Job Title</th>
            <th>Applied Date</th>
            <th>Status</th>
            <th>Shortlist Status</th>
            <th>Action</th>
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
            "SELECT A.APPLICATION_ID, " +
            "A.STUDENT_ID, " +
            "S.NAME, " +
            "C.COMPANY_NAME, " +
            "R.JOB_TITLE, " +
            "A.APPLIED_DATE, " +
            "A.STATUS, " +
            "A.COLLEGE_SHORTLIST_STATUS " +

            "FROM APPLICATION A " +

            "JOIN STUDENT S " +
            "ON A.STUDENT_ID = S.STUDENT_ID " +

            "JOIN RECRUITMENT_DRIVE R " +
            "ON A.DRIVE_ID = R.DRIVE_ID " +

            "JOIN COMPANY C " +
            "ON R.COMPANY_ID = C.COMPANY_ID " +

            "WHERE S.COLLEGE_ID = ? " +

            "ORDER BY A.APPLICATION_ID";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;
%>

        <tr>

            <td>
                <%=rs.getInt("APPLICATION_ID")%>
            </td>

            <td>
                <%=rs.getInt("STUDENT_ID")%>
            </td>

            <td>
                <%=rs.getString("NAME")%>
            </td>

            <td>
                <%=rs.getString("COMPANY_NAME")%>
            </td>

            <td>
                <%=rs.getString("JOB_TITLE")%>
            </td>

            <td>
                <%=rs.getDate("APPLIED_DATE")%>
            </td>

            <td class="applied">
                <%=rs.getString("STATUS")%>
            </td>

            <td class="pending">
                <%=rs.getString("COLLEGE_SHORTLIST_STATUS")%>
            </td>

            <td>

                <form action="ApplicationShortlistController" method="post">

                    <input type="hidden"
                           name="applicationId"
                           value="<%=rs.getInt("APPLICATION_ID")%>">

                    <select name="shortlistStatus">

                        <option value="PENDING"
                            <%= "PENDING".equals(rs.getString("COLLEGE_SHORTLIST_STATUS")) ? "selected" : "" %>>
                            PENDING
                        </option>

                        <option value="SHORTLISTED"
                            <%= "SHORTLISTED".equals(rs.getString("COLLEGE_SHORTLIST_STATUS")) ? "selected" : "" %>>
                            SHORTLISTED
                        </option>

                        <option value="REJECTED"
                            <%= "REJECTED".equals(rs.getString("COLLEGE_SHORTLIST_STATUS")) ? "selected" : "" %>>
                            REJECTED
                        </option>

                    </select>

                    <button type="submit">
                        Update
                    </button>

                </form>

            </td>

        </tr>

<%
        }

        if(!found) {
%>

        <tr>
            <td colspan="9">
                No applications found.
            </td>
        </tr>

<%
        }

    } catch(Exception e) {
%>

        <tr>
            <td colspan="9">
                Error: <%=e.getMessage()%>
            </td>
        </tr>

<%
    } finally {

        if(rs != null) {
            try { rs.close(); } catch(Exception e) {}
        }

        if(ps != null) {
            try { ps.close(); } catch(Exception e) {}
        }

        if(con != null) {
            try { con.close(); } catch(Exception e) {}
        }

    }
%>

    </table>

</div>

</body>

</html>