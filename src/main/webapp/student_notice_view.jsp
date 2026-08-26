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

    <title>Notifications</title>

</head>

<body>

<h1>Notifications</h1>

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
            "SELECT N.NOTICE_ID, " +
            "N.TITLE, " +
            "N.CONTENT, " +
            "N.NOTICE_DATE, " +
            "N.STATUS " +
            "FROM NOTICE N, STUDENT S " +
            "WHERE N.COLLEGE_ID = S.COLLEGE_ID " +
            "AND S.STUDENT_ID = ? " +
            "AND N.STATUS = 'ACTIVE' " +
            "ORDER BY N.NOTICE_DATE DESC";

        ps = con.prepareStatement(sql);

        ps.setInt(1, studentId);

        rs = ps.executeQuery();

        boolean found = false;
%>

<table border="1" cellpadding="10">

<tr>

    <th>Notice ID</th>
    <th>Title</th>
    <th>Content</th>
    <th>Notice Date</th>
    <th>Status</th>

</tr>

<%
        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("NOTICE_ID")%>
    </td>

    <td>
        <%=rs.getString("TITLE")%>
    </td>

    <td>
        <%=rs.getString("CONTENT")%>
    </td>

    <td>
        <%=rs.getDate("NOTICE_DATE")%>
    </td>

    <td>
        <%=rs.getString("STATUS")%>
    </td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="5">
        No Notifications Found
    </td>

</tr>

<%
        }
    }
    catch(Exception e)
    {
%>

<tr>

    <td colspan="5">
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

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>