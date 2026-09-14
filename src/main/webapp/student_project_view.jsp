<%@ page import="java.sql.*" %>

<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null ||
       session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId =
        (Integer)session1.getAttribute("studentId");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>My Projects</title>

</head>


<body>

<h1>My Projects</h1>

<hr>


<table border="1"
       cellpadding="10"
       cellspacing="0">


<tr>

    <th>Project ID</th>

    <th>Project Name</th>

    <th>Description</th>

    <th>Technologies</th>

    <th>Project URL</th>

    <th>Edit</th>

    <th>Delete</th>

</tr>


<%

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );


        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );


        String q =
            "SELECT PROJECT_ID, PROJECT_NAME, " +
            "DESCRIPTION, TECHNOLOGIES, PROJECT_URL " +
            "FROM STUDENT_PROJECT " +
            "WHERE STUDENT_ID = ? " +
            "ORDER BY PROJECT_ID";


        ps = con.prepareStatement(q);

        ps.setInt(1, studentId);

        rs = ps.executeQuery();


        boolean found = false;


        while(rs.next())
        {
            found = true;

%>


<tr>

    <td>
        <%=rs.getInt("PROJECT_ID")%>
    </td>


    <td>
        <%=rs.getString("PROJECT_NAME")%>
    </td>


    <td>
        <%=rs.getString("DESCRIPTION")%>
    </td>


    <td>
        <%=rs.getString("TECHNOLOGIES")%>
    </td>


    <td>
        <%=rs.getString("PROJECT_URL")%>
    </td>


    <!-- EDIT -->

    <td>

        <a href="student_project.jsp?editId=<%=rs.getInt("PROJECT_ID")%>">

            Edit

        </a>

    </td>


    <!-- DELETE -->

    <td>

        <form method="post"
              action="studentProject"
              onsubmit="return confirm('Are you sure you want to delete this project?');">


            <input type="hidden"
                   name="action"
                   value="delete">


            <input type="hidden"
                   name="projectId"
                   value="<%=rs.getInt("PROJECT_ID")%>">


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

    <td colspan="7">

        No Projects Found

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

        Error: <%=e.getMessage()%>

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


<a href="student_project.jsp">

    Add Another Project

</a>


<br><br>


<a href="student_dashboard.jsp">

    Back to Dashboard

</a>


</body>

</html>