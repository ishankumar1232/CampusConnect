<%@ page import="java.sql.*" %>

<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null || session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

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
            "SELECT R.DRIVE_ID, C.COMPANY_NAME, R.DRIVE_TYPE, "
          + "R.JOB_TITLE, R.DESCRIPTION, R.VACANCY, "
          + "R.ELIGIBILITY_CGPA, R.REQUIRED_BRANCH, "
          + "R.REQUIRED_SKILLS, R.SALARY, R.DEADLINE, R.STATUS "
          + "FROM RECRUITMENT_DRIVE R, COMPANY C "
          + "WHERE R.COMPANY_ID = C.COMPANY_ID "
          + "AND R.STATUS = 'OPEN' "
          + "ORDER BY R.DEADLINE";

        ResultSet rs = stmt.executeQuery(q);
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Available Placement Drives</title>

</head>


<body>

<h1>Available Placement Drives</h1>

<hr>


<table border="1" cellpadding="10">

<tr>

    <th>Drive ID</th>
    <th>Company</th>
    <th>Drive Type</th>
    <th>Job Title</th>
    <th>Description</th>
    <th>Vacancy</th>
    <th>Eligibility CGPA</th>
    <th>Required Branch</th>
    <th>Required Skills</th>
    <th>Salary</th>
    <th>Deadline</th>
    <th>Status</th>
    <th>Action</th>

</tr>


<%
        boolean found = false;

        while(rs.next())
        {
            found = true;
%>

<tr>

    <td>
        <%=rs.getInt("DRIVE_ID")%>
    </td>

    <td>
        <%=rs.getString("COMPANY_NAME")%>
    </td>

    <td>
        <%=rs.getString("DRIVE_TYPE")%>
    </td>

    <td>
        <%=rs.getString("JOB_TITLE")%>
    </td>

    <td>
        <%=rs.getString("DESCRIPTION")%>
    </td>

    <td>
        <%=rs.getInt("VACANCY")%>
    </td>

    <td>
        <%=rs.getDouble("ELIGIBILITY_CGPA")%>
    </td>

    <td>
        <%=rs.getString("REQUIRED_BRANCH")%>
    </td>

    <td>
        <%=rs.getString("REQUIRED_SKILLS")%>
    </td>

    <td>
        <%=rs.getDouble("SALARY")%>
    </td>

    <td>
        <%=rs.getDate("DEADLINE")%>
    </td>

    <td>
        <%=rs.getString("STATUS")%>
    </td>

    <td>

        <form method="post" action="studentApply">

            <input type="hidden"
                   name="driveId"
                   value="<%=rs.getInt("DRIVE_ID")%>">

            <input type="submit"
                   value="Apply">

        </form>

    </td>

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="13">
        No Placement Drives Available
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


<a href="student_dashboard.jsp">
Back to Dashboard
</a>


</body>

</html>