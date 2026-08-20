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
            "SELECT ACADEMIC_ID, QUALIFICATION, YEAR, "
          + "PERCENTAGE, CGPA, BACKLOGS "
          + "FROM STUDENT_ACADEMIC "
          + "WHERE STUDENT_ID = " + studentId
          + " ORDER BY YEAR DESC";

        ResultSet rs = stmt.executeQuery(q);
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Academic Details</title>

</head>


<body>

<h1>Academic Details</h1>

<hr>


<table border="1" cellpadding="10">

<tr>

    <th>Academic ID</th>
    <th>Qualification</th>
    <th>Year</th>
    <th>Percentage</th>
    <th>CGPA</th>
    <th>Backlogs</th>

</tr>


<%

        boolean found = false;

        while(rs.next())
        {
            found = true;

%>

<tr>

    <td><%=rs.getInt("ACADEMIC_ID")%></td>

    <td><%=rs.getString("QUALIFICATION")%></td>

    <td><%=rs.getInt("YEAR")%></td>

    <td><%=rs.getDouble("PERCENTAGE")%></td>

    <td><%=rs.getDouble("CGPA")%></td>

    <td><%=rs.getInt("BACKLOGS")%></td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="6">
        No Academic Details Found
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

<a href="student_academic.jsp">
Add Academic Details
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>


</body>

</html>