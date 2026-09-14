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

    <title>Interview Management</title>

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

        input, select {
            padding: 7px;
            width: 120px;
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

        .shortlisted {
            color: green;
            font-weight: bold;
        }

    </style>

</head>

<body>

<div class="header">
    Interview Management
</div>


<div class="back">
    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>
</div>


<div class="box">

    <h2>Shortlisted Students</h2>

    <table>

        <tr>
            <th>Application ID</th>
            <th>Student Name</th>
            <th>Company</th>
            <th>Job Title</th>
            <th>Interview Date</th>
            <th>Mode</th>
            <th>Venue / Link</th>
            <th>Status</th>
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
            "I.INTERVIEW_ID, " +
            "I.INTERVIEW_DATE, " +
            "I.INTERVIEW_MODE, " +
            "I.VENUE_OR_LINK, " +
            "I.STATUS " +

            "FROM APPLICATION A " +

            "JOIN STUDENT S " +
            "ON A.STUDENT_ID = S.STUDENT_ID " +

            "JOIN RECRUITMENT_DRIVE R " +
            "ON A.DRIVE_ID = R.DRIVE_ID " +

            "JOIN COMPANY C " +
            "ON R.COMPANY_ID = C.COMPANY_ID " +

            "LEFT JOIN INTERVIEW I " +
            "ON A.APPLICATION_ID = I.APPLICATION_ID " +

            "WHERE S.COLLEGE_ID = ? " +
            "AND A.COLLEGE_SHORTLIST_STATUS = 'SHORTLISTED' " +

            "ORDER BY A.APPLICATION_ID";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;

            int applicationId = rs.getInt("APPLICATION_ID");

            Date interviewDate = rs.getDate("INTERVIEW_DATE");

            String mode = rs.getString("INTERVIEW_MODE");

            String venue = rs.getString("VENUE_OR_LINK");

            String status = rs.getString("STATUS");
%>

        <tr>

            <td>
                <%=applicationId%>
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

                <form action="InterviewController" method="post">

                    <input type="hidden"
                           name="applicationId"
                           value="<%=applicationId%>">

                    <input type="date"
                           name="interviewDate"
                           value="<%=interviewDate == null ? "" : interviewDate%>"
                           required>

            </td>

            <td>

                    <select name="interviewMode" required>

                        <option value="">Select</option>

                        <option value="ONLINE"
                            <%= "ONLINE".equals(mode) ? "selected" : "" %>>
                            ONLINE
                        </option>

                        <option value="OFFLINE"
                            <%= "OFFLINE".equals(mode) ? "selected" : "" %>>
                            OFFLINE
                        </option>

                    </select>

            </td>

            <td>

                    <input type="text"
                           name="venueOrLink"
                           value="<%=venue == null ? "" : venue%>"
                           placeholder="Venue / Link"
                           required>

            </td>

            <td>

                    <select name="status">

                        <option value="SCHEDULED"
                            <%= "SCHEDULED".equals(status) ? "selected" : "" %>>
                            SCHEDULED
                        </option>

                        <option value="COMPLETED"
                            <%= "COMPLETED".equals(status) ? "selected" : "" %>>
                            COMPLETED
                        </option>

                        <option value="CANCELLED"
                            <%= "CANCELLED".equals(status) ? "selected" : "" %>>
                            CANCELLED
                        </option>

                    </select>

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
                No shortlisted students found.
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