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

<table border="1" cellpadding="10" cellspacing="0">

<tr>

    <th>College Name</th>
    <th>City</th>
    <th>State</th>
    <th>Status</th>
    <th>Action</th>

</tr>

<%

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        stmt = con.createStatement();

        String q =
            "SELECT COLLEGE_ID, COLLEGE_NAME, CITY, STATE, STATUS " +
            "FROM COLLEGE " +
            "WHERE STATUS='ACTIVE' " +
            "ORDER BY COLLEGE_NAME";

        rs = stmt.executeQuery(q);

        while(rs.next())
        {
%>

<tr>

    <td>
        <%=rs.getString("COLLEGE_NAME")%>
    </td>

    <td>
        <%=rs.getString("CITY")%>
    </td>

    <td>
        <%=rs.getString("STATE")%>
    </td>

    <td>
        <%=rs.getString("STATUS")%>
    </td>

    <td>

        <a href="new_student_college_compare.jsp?collegeId=<%=rs.getInt("COLLEGE_ID")%>">

            Compare / View Details

        </a>

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

            if(stmt != null)
                stmt.close();

            if(con != null)
                con.close();
        }
        catch(Exception e)
        {
        }
    }

%>

</table>

</body>

</html>