<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>College Details</title>

</head>

<body>

<h1>College Details</h1>

<hr>

<%

    String collegeId = request.getParameter("collegeId");

    if(collegeId == null || collegeId.trim().equals(""))

    {

%>

        <p>Invalid College ID.</p>

<%

    }

    else

    {

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

            String sql =

                "SELECT COLLEGE_ID, " +
                "COLLEGE_NAME, " +
                "ADDRESS, " +
                "CITY, " +
                "STATE, " +
                "EMAIL, " +
                "PHONE, " +
                "STATUS " +
                "FROM COLLEGE " +
                "WHERE COLLEGE_ID = " + collegeId;

            rs = stmt.executeQuery(sql);

            if(rs.next())

            {

%>

<table border="1" cellpadding="10" cellspacing="0">

<tr>

    <th>College ID</th>

    <td>
        <%=rs.getInt("COLLEGE_ID")%>
    </td>

</tr>

<tr>

    <th>College Name</th>

    <td>
        <%=rs.getString("COLLEGE_NAME")%>
    </td>

</tr>

<tr>

    <th>Address</th>

    <td>
        <%=rs.getString("ADDRESS")%>
    </td>

</tr>

<tr>

    <th>City</th>

    <td>
        <%=rs.getString("CITY")%>
    </td>

</tr>

<tr>

    <th>State</th>

    <td>
        <%=rs.getString("STATE")%>
    </td>

</tr>

<tr>

    <th>Email</th>

    <td>
        <%=rs.getString("EMAIL")%>
    </td>

</tr>

<tr>

    <th>Phone</th>

    <td>
        <%=rs.getString("PHONE")%>
    </td>

</tr>

<tr>

    <th>Status</th>

    <td>
        <%=rs.getString("STATUS")%>
    </td>

</tr>

</table>

<br>

<a href="new_student_admission_request.jsp?collegeId=<%=collegeId%>">

    Select This College

</a>

<br><br>

<a href="new_student_colleges.jsp">

    Back to Available Colleges

</a>

<%

            }

            else

            {

%>

                <p>College not found.</p>

<%

            }

        }

        catch(Exception e)

        {

%>

            <p>Error: <%=e%></p>

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

    }

%>

</body>

</html>