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

    <th>Withdraw</th>

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
            "SELECT A.APPLICATION_ID, " +
            "A.DRIVE_ID, " +
            "C.COMPANY_NAME, " +
            "R.JOB_TITLE, " +
            "A.APPLIED_DATE, " +
            "A.STATUS, " +
            "A.COLLEGE_SHORTLIST_STATUS " +
            "FROM APPLICATION A, " +
            "RECRUITMENT_DRIVE R, " +
            "COMPANY C " +
            "WHERE A.DRIVE_ID = R.DRIVE_ID " +
            "AND R.COMPANY_ID = C.COMPANY_ID " +
            "AND A.STUDENT_ID = ? " +
            "ORDER BY A.APPLICATION_ID";


        ps = con.prepareStatement(q);

        ps.setInt(1, studentId);

        rs = ps.executeQuery();


        boolean found = false;


        while(rs.next())
        {
            found = true;

            int applicationId =
                rs.getInt("APPLICATION_ID");

            String status =
                rs.getString("STATUS");

            String shortlistStatus =
                rs.getString(
                    "COLLEGE_SHORTLIST_STATUS"
                );

%>


<tr>

    <td>
        <%=applicationId%>
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
        <%=status%>
    </td>


    <td>
        <%=shortlistStatus%>
    </td>


    <!-- WITHDRAW -->

    <td>

<%
    /*
       Student should only withdraw an application
       which is still in the initial APPLIED/PENDING state.
    */

    if(("APPLIED".equalsIgnoreCase(status) ||
        "PENDING".equalsIgnoreCase(status)) &&
       ("PENDING".equalsIgnoreCase(shortlistStatus)))
    {
%>

        <form method="post"
              action="studentApplication"
              onsubmit="return confirm('Are you sure you want to withdraw this application?');">


            <input type="hidden"
                   name="action"
                   value="delete">


            <input type="hidden"
                   name="applicationId"
                   value="<%=applicationId%>">


            <input type="submit"
                   value="Withdraw">

        </form>

<%
    }
    else
    {
%>

        Cannot Withdraw

<%
    }
%>

    </td>

</tr>


<%

        }


        if(!found)
        {

%>


<tr>

    <td colspan="8">

        No Applications Found

    </td>

</tr>


<%

        }
    }
    catch(Exception e)
    {

%>


<tr>

    <td colspan="8">

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


<a href="student_drive_view.jsp">

View Placement Drives

</a>


<br><br>


<a href="student_dashboard.jsp">

Back to Dashboard

</a>


</body>

</html>