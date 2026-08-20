<%@ page import="java.sql.*" %>

<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null || session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = (Integer)session1.getAttribute("studentId");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Interview Details</title>

</head>

<body>

<h1>My Interview Details</h1>

<hr>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql =
            "SELECT I.INTERVIEW_ID, " +
            "I.APPLICATION_ID, " +
            "C.COMPANY_NAME, " +
            "R.JOB_TITLE, " +
            "I.INTERVIEW_DATE, " +
            "I.INTERVIEW_MODE, " +
            "I.VENUE_OR_LINK, " +
            "I.STATUS, " +
            "I.REMARKS " +
            "FROM INTERVIEW I, APPLICATION A, " +
            "RECRUITMENT_DRIVE R, COMPANY C " +
            "WHERE I.APPLICATION_ID = A.APPLICATION_ID " +
            "AND A.DRIVE_ID = R.DRIVE_ID " +
            "AND R.COMPANY_ID = C.COMPANY_ID " +
            "AND A.STUDENT_ID = ? " +
            "ORDER BY I.INTERVIEW_ID";

        ps = con.prepareStatement(sql);

        ps.setInt(1, studentId);

        rs = ps.executeQuery();

        boolean found = false;
%>

<table border="1" cellpadding="10">

<tr>

    <th>Interview ID</th>
    <th>Application ID</th>
    <th>Company</th>
    <th>Job Title</th>
    <th>Interview Date</th>
    <th>Mode</th>
    <th>Venue / Link</th>
    <th>Status</th>
    <th>Remarks</th>

</tr>

<%
        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("INTERVIEW_ID")%>
    </td>

    <td>
        <%=rs.getInt("APPLICATION_ID")%>
    </td>

    <td>
        <%=rs.getString("COMPANY_NAME")%>
    </td>

    <td>
        <%=rs.getString("JOB_TITLE")%>
    </td>

    <td>
        <%=rs.getTimestamp("INTERVIEW_DATE")%>
    </td>

    <td>
        <%=rs.getString("INTERVIEW_MODE")%>
    </td>

    <td>
        <%=rs.getString("VENUE_OR_LINK")%>
    </td>

    <td>
        <%=rs.getString("STATUS")%>
    </td>

    <td>
        <%=rs.getString("REMARKS")%>
    </td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="9">
        No Interview Details Found
    </td>

</tr>

<%
        }
    }
    catch(Exception e)
    {
%>

<tr>

    <td colspan="9">
        Error: <%=e%>
    </td>

</tr>

<%
    }
    finally
    {
        try
        {
            if(rs != null)
                rs.close();

            if(ps != null)
                ps.close();

            if(con != null)
                con.close();
        }
        catch(Exception e)
        {
        }
    }
%>

</table>

<br>

<a href="student_application_view.jsp">
My Applications
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>