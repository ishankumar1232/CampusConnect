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

    <title>Selection Result</title>

</head>

<body>

<h1>My Selection Result</h1>

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
            "SELECT S.SELECTION_ID, " +
            "S.APPLICATION_ID, " +
            "C.COMPANY_NAME, " +
            "R.JOB_TITLE, " +
            "S.RESULT, " +
            "S.SELECTION_DATE, " +
            "S.REMARKS " +
            "FROM SELECTION S, APPLICATION A, " +
            "RECRUITMENT_DRIVE R, COMPANY C " +
            "WHERE S.APPLICATION_ID = A.APPLICATION_ID " +
            "AND A.DRIVE_ID = R.DRIVE_ID " +
            "AND R.COMPANY_ID = C.COMPANY_ID " +
            "AND A.STUDENT_ID = ? " +
            "ORDER BY S.SELECTION_ID";

        ps = con.prepareStatement(sql);

        ps.setInt(1, studentId);

        rs = ps.executeQuery();

        boolean found = false;
%>

<table border="1" cellpadding="10">

<tr>

    <th>Selection ID</th>
    <th>Application ID</th>
    <th>Company</th>
    <th>Job Title</th>
    <th>Result</th>
    <th>Selection Date</th>
    <th>Remarks</th>

</tr>

<%
        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("SELECTION_ID")%>
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
        <%=rs.getString("RESULT")%>
    </td>

    <td>
        <%=rs.getDate("SELECTION_DATE")%>
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

    <td colspan="7">
        No Selection Result Found
    </td>

</tr>

<%
        }
    }
    catch(Exception e)
    {
%>

<tr>

    <td colspan="7">
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