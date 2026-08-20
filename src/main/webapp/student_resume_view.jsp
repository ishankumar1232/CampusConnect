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
            "SELECT RESUME_ID, RESUME_FILE, UPLOADED_DATE "
          + "FROM RESUME "
          + "WHERE STUDENT_ID = " + studentId
          + " ORDER BY RESUME_ID";

        ResultSet rs = stmt.executeQuery(q);
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>My Resume</title>

</head>

<body>

<h1>My Resume</h1>

<hr>

<table border="1" cellpadding="10">

<tr>

    <th>Resume ID</th>
    <th>Resume File</th>
    <th>Uploaded Date</th>

</tr>

<%
        boolean found = false;

        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("RESUME_ID")%>
    </td>

    <td>
        <%=rs.getString("RESUME_FILE")%>
    </td>

    <td>
        <%=rs.getDate("UPLOADED_DATE")%>
    </td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="3">
        No Resume Found
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

<a href="student_resume.jsp">
Upload Another Resume
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>