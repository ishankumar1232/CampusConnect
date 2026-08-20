<%@ page import="java.sql.*" %>

<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null || session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = (Integer)session1.getAttribute("studentId");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Placement Opportunities</title>

</head>

<body>

<h1>My Placement Opportunities</h1>

<hr>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql =
            "SELECT R.DRIVE_ID, " +
            "C.COMPANY_NAME, " +
            "R.DRIVE_TYPE, " +
            "R.JOB_TITLE, " +
            "R.DESCRIPTION, " +
            "R.VACANCY, " +
            "R.ELIGIBILITY_CGPA, " +
            "R.REQUIRED_BRANCH, " +
            "R.REQUIRED_SKILLS, " +
            "R.SALARY, " +
            "R.DEADLINE " +
            "FROM STUDENT S, " +
            "STUDENT_ACADEMIC SA, " +
            "COURSE CO, " +
            "RECRUITMENT_DRIVE R, " +
            "COMPANY C " +
            "WHERE S.STUDENT_ID = SA.STUDENT_ID " +
            "AND S.COURSE_ID = CO.COURSE_ID " +
            "AND R.COMPANY_ID = C.COMPANY_ID " +
            "AND R.STATUS = 'OPEN' " +
            "AND R.DEADLINE >= SYSDATE " +
            "AND SA.CGPA >= R.ELIGIBILITY_CGPA " +
            "AND LOWER(CO.COURSE_NAME) LIKE " +
            "'%' || LOWER(R.REQUIRED_BRANCH) || '%' " +
            "AND S.STUDENT_ID = ? " +
            "ORDER BY R.DEADLINE";

        ps = con.prepareStatement(sql);

        ps.setInt(1, studentId);

        rs = ps.executeQuery();

        boolean found = false;
%>

<table border="1" cellpadding="10">

<tr>

    <th>Drive ID</th>
    <th>Company</th>
    <th>Drive Type</th>
    <th>Job Title</th>
    <th>Description</th>
    <th>Vacancy</th>
    <th>Required CGPA</th>
    <th>Required Branch</th>
    <th>Required Skills</th>
    <th>Salary</th>
    <th>Deadline</th>

</tr>

<%
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

</tr>

<%
        }

        if(!found)
        {
%>

<tr>

    <td colspan="11">
        No Eligible Placement Opportunities Found
    </td>

</tr>

<%
        }
    }
    catch(Exception e)
    {
%>

<tr>

    <td colspan="11">
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

<a href="student_drive_view.jsp">
View All Placement Drives
</a>

<br><br>

<a href="student_dashboard.jsp">
Back to Dashboard
</a>

</body>

</html>