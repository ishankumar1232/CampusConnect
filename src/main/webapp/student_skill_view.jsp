<%@ page import="java.sql.*" %>

<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null || session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = (Integer)session1.getAttribute("studentId");

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        Statement stmt = con.createStatement();

        String q =
            "SELECT SKILL_ID, SKILL_NAME "
          + "FROM STUDENT_SKILL "
          + "WHERE STUDENT_ID = " + studentId
          + " ORDER BY SKILL_ID";

        ResultSet rs = stmt.executeQuery(q);
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

<table border="1" cellpadding="10">

<tr>

    <th>Skill ID</th>
    <th>Skill Name</th>

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

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="2">
        No Skills Found
    </td>

</tr>

<%
        }

        rs.close();
        stmt.close();
        con.close();
    }
    catch(Exception e)
    {
        out.println("<h3>Error: " + e + "</h3>");
    }
%>

</table>

<br>

<a href="student_skill.jsp">
Add Another Skill
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>