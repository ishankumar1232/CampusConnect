<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>

<head>

    <title>Academic Details</title>

</head>

<body>

<h2>Academic Details</h2>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
        HttpSession session1 = request.getSession(false);

        if(session1 == null ||
           session1.getAttribute("studentId") == null)
        {
            response.sendRedirect("student_login.jsp");
            return;
        }

        int studentId =
            (Integer)session1.getAttribute("studentId");

        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql =
            "SELECT ACADEMIC_ID, QUALIFICATION, YEAR, " +
            "PERCENTAGE, CGPA, BACKLOGS " +
            "FROM STUDENT_ACADEMIC " +
            "WHERE STUDENT_ID=? " +
            "ORDER BY YEAR DESC";

        ps = con.prepareStatement(sql);

        ps.setInt(1, studentId);

        rs = ps.executeQuery();

        boolean found = false;
%>

<table border="1" cellpadding="10">

<tr>
    <th>Academic ID</th>
    <th>Qualification</th>
    <th>Year</th>
    <th>Percentage</th>
    <th>CGPA</th>
    <th>Backlogs</th>
    <th>Edit</th>
    <th>Delete</th>
</tr>

<%
        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("ACADEMIC_ID")%>
    </td>

    <td>
        <%=rs.getString("QUALIFICATION")%>
    </td>

    <td>
        <%=rs.getInt("YEAR")%>
    </td>

    <td>
        <%=rs.getDouble("PERCENTAGE")%>
    </td>

    <td>
        <%=rs.getDouble("CGPA")%>
    </td>

    <td>
        <%=rs.getInt("BACKLOGS")%>
    </td>

    <td>
        <a href="student_academic.jsp?editId=<%=rs.getInt("ACADEMIC_ID")%>">
            Edit
        </a>
    </td>

    <td>

        <form method="post"
              action="studentAcademic"
              onsubmit="return confirm('Delete this academic record?');">

            <input type="hidden"
                   name="action"
                   value="delete">

            <input type="hidden"
                   name="academicId"
                   value="<%=rs.getInt("ACADEMIC_ID")%>">

            <input type="submit"
                   value="Delete">

        </form>

    </td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>
    <td colspan="8">
        No Academic Details Found
    </td>
</tr>

<%
        }
    }
    catch(Exception e)
    {
%>

<tr>
    <td colspan="8">
        Error: <%=e.getMessage()%>
    </td>
</tr>

<%
    }
    finally
    {
        try
        {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        }
        catch(Exception e)
        {
        }
    }
%>

</table>

<br>

<a href="student_academic.jsp">
Add Academic Details
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>