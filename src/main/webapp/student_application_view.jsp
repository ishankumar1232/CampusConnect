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
            "SELECT A.APPLICATION_ID, "
          + "A.DRIVE_ID, "
          + "C.COMPANY_NAME, "
          + "R.JOB_TITLE, "
          + "A.APPLIED_DATE, "
          + "A.STATUS, "
          + "A.COLLEGE_SHORTLIST_STATUS "
          + "FROM APPLICATION A, "
          + "RECRUITMENT_DRIVE R, "
          + "COMPANY C "
          + "WHERE A.DRIVE_ID = R.DRIVE_ID "
          + "AND R.COMPANY_ID = C.COMPANY_ID "
          + "AND A.STUDENT_ID = " + studentId
          + " ORDER BY A.APPLICATION_ID";

        ResultSet rs = stmt.executeQuery(q);
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>My Applications</title>

</head>

<body>

<h1>My Applications</h1>

<hr>

<table border="1" cellpadding="10">

<tr>

    <th>Application ID</th>
    <th>Drive ID</th>
    <th>Company</th>
    <th>Job Title</th>
    <th>Applied Date</th>
    <th>Status</th>
    <th>College Shortlist Status</th>

</tr>

<%
        boolean found = false;

        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("APPLICATION_ID")%>
    </td>

    <td>
        <%=rs.getInt("DRIVE_ID")%>
    </td>

    <td>
        <%=rs.getString("COMPANY_NAME")%>
    </td>

    <td>
        <%=rs.getString("JOB_TITLE")%>
    </td>

    <td>
        <%=rs.getDate("APPLIED_DATE")%>
    </td>

    <td>
        <%=rs.getString("STATUS")%>
    </td>

    <td>
        <%=rs.getString("COLLEGE_SHORTLIST_STATUS")%>
    </td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="7">
        No Applications Found
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

<a href="student_drive_view.jsp">
View Placement Drives
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>