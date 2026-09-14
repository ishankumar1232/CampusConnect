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

    <title>Selection Management</title>

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
            padding: 13px;
        }

        td {
            padding: 11px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        select {
            padding: 7px;
        }

        input {
            padding: 7px;
            width: 150px;
        }

        button {
            padding: 8px 14px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background: #217dbb;
        }

        .completed {
            color: green;
            font-weight: bold;
        }

    </style>

</head>

<body>

<div class="header">
    Selection Management
</div>


<div class="back">

    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>

</div>


<div class="box">

    <h2>Completed Interviews</h2>

    <table>

        <tr>
            <th>Application ID</th>
            <th>Student Name</th>
            <th>Company</th>
            <th>Job Title</th>
            <th>Interview Date</th>
            <th>Interview Status</th>
            <th>Result</th>
            <th>Remarks</th>
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
            "S.NAME, " +
            "C.COMPANY_NAME, " +
            "R.JOB_TITLE, " +
            "I.INTERVIEW_DATE, " +
            "I.STATUS AS INTERVIEW_STATUS, " +
            "SE.RESULT, " +
            "SE.REMARKS " +

            "FROM INTERVIEW I " +

            "JOIN APPLICATION A " +
            "ON I.APPLICATION_ID = A.APPLICATION_ID " +

            "JOIN STUDENT S " +
            "ON A.STUDENT_ID = S.STUDENT_ID " +

            "JOIN RECRUITMENT_DRIVE R " +
            "ON A.DRIVE_ID = R.DRIVE_ID " +

            "JOIN COMPANY C " +
            "ON R.COMPANY_ID = C.COMPANY_ID " +

            "LEFT JOIN SELECTION SE " +
            "ON I.APPLICATION_ID = SE.APPLICATION_ID " +

            "WHERE S.COLLEGE_ID = ? " +
            "AND I.STATUS = 'COMPLETED' " +

            "ORDER BY I.INTERVIEW_DATE DESC";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;

            String result = rs.getString("RESULT");

            String remarks = rs.getString("REMARKS");

%>

        <tr>

            <td>
                <%=rs.getInt("APPLICATION_ID")%>
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
                <%=rs.getDate("INTERVIEW_DATE")%>
            </td>

            <td class="completed">
                <%=rs.getString("INTERVIEW_STATUS")%>
            </td>

            <td>

                <form action="SelectionController" method="post">

                    <input type="hidden"
                           name="applicationId"
                           value="<%=rs.getInt("APPLICATION_ID")%>">

                    <select name="result" required>

                        <option value="">
                            Select
                        </option>

                        <option value="SELECTED"
                            <%= "SELECTED".equals(result) ? "selected" : "" %>>
                            SELECTED
                        </option>

                        <option value="REJECTED"
                            <%= "REJECTED".equals(result) ? "selected" : "" %>>
                            REJECTED
                        </option>

                    </select>

            </td>

            <td>

                    <input type="text"
                           name="remarks"
                           value="<%=remarks == null ? "" : remarks%>"
                           placeholder="Remarks">

            </td>

            <td>

                    <button type="submit">
                        Save
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
                No completed interviews found.
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