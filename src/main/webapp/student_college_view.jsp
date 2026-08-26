<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Available Colleges</title>

</head>

<body>

<h1>Available Colleges</h1>

<hr>

<p>
Select a college to view its details and continue with the admission process.
</p>

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
            "SELECT COLLEGE_ID, " +
            "COLLEGE_NAME, " +
            "ADDRESS, " +
            "CITY, " +
            "STATE, " +
            "EMAIL, " +
            "PHONE " +
            "FROM COLLEGE " +
            "WHERE STATUS = 'ACTIVE' " +
            "ORDER BY COLLEGE_NAME";

        ps = con.prepareStatement(sql);

        rs = ps.executeQuery();

        boolean found = false;
%>

<table border="1" cellpadding="10" cellspacing="0">

<tr>

    <th>College ID</th>
    <th>College Name</th>
    <th>Address</th>
    <th>City</th>
    <th>State</th>
    <th>Email</th>
    <th>Phone</th>
    <th>Action</th>

</tr>

<%
        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("COLLEGE_ID")%>
    </td>

    <td>
        <%=rs.getString("COLLEGE_NAME")%>
    </td>

    <td>
        <%=rs.getString("ADDRESS")%>
    </td>

    <td>
        <%=rs.getString("CITY")%>
    </td>

    <td>
        <%=rs.getString("STATE")%>
    </td>

    <td>
        <%=rs.getString("EMAIL")%>
    </td>

    <td>
        <%=rs.getString("PHONE")%>
    </td>

    <td>

        <a href="new_student_college_compare.jsp?collegeId=<%=rs.getInt("COLLEGE_ID")%>">
            Compare
        </a>

    </td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="8">
        No Active Colleges Found
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

<a href="student_register.jsp">
    Student Registration
</a>

</body>

</html>