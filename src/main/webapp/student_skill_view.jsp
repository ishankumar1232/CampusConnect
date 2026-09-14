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

    Connection con = null;
    Statement stmt = null;
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

        stmt = con.createStatement();

        String q =
            "SELECT SKILL_ID, SKILL_NAME " +
            "FROM STUDENT_SKILL " +
            "WHERE STUDENT_ID = " + studentId +
            " ORDER BY SKILL_ID";

        rs = stmt.executeQuery(q);
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>My Skills</title>

</head>


<body>

<h1>My Skills</h1>

<hr>


<table border="1"
       cellpadding="10"
       cellspacing="0">

<tr>

    <th>Skill ID</th>

    <th>Skill Name</th>

    <th>Edit</th>

    <th>Delete</th>

</tr>


<%

        boolean found = false;

        while(rs.next())
        {
            found = true;

%>


<tr>

    <td>

        <%=rs.getInt("SKILL_ID")%>

    </td>


    <td>

        <%=rs.getString("SKILL_NAME")%>

    </td>


    <!-- EDIT -->

    <td>

        <a href="student_skill.jsp?editId=<%=rs.getInt("SKILL_ID")%>">

            Edit

        </a>

    </td>


    <!-- DELETE -->

    <td>

        <form method="post"
              action="studentSkill"
              onsubmit="return confirm('Are you sure you want to delete this skill?');">

            <input type="hidden"
                   name="action"
                   value="delete">

            <input type="hidden"
                   name="skillId"
                   value="<%=rs.getInt("SKILL_ID")%>">

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

    <td colspan="4">

        No Skills Found

    </td>

</tr>


<%

        }

    }
    catch(Exception e)
    {

%>


<tr>

    <td colspan="4">

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


<br>


<a href="student_skill.jsp">

Add Another Skill

</a>


<br>
<br>


<a href="student_dashboard.jsp">

Back to Dashboard

</a>


</body>

</html>