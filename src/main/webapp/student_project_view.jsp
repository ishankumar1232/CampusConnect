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
            "SELECT PROJECT_ID, PROJECT_NAME, DESCRIPTION, "
          + "TECHNOLOGIES, PROJECT_URL "
          + "FROM STUDENT_PROJECT "
          + "WHERE STUDENT_ID = " + studentId
          + " ORDER BY PROJECT_ID";

        ResultSet rs = stmt.executeQuery(q);
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

<table border="1" cellpadding="10">

<tr>

    <th>Project ID</th>
    <th>Project Name</th>
    <th>Description</th>
    <th>Technologies</th>
    <th>Project URL</th>

</tr>

<%
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

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="5">
        No Projects Found
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

<a href="student_project.jsp">
Add Another Project
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>