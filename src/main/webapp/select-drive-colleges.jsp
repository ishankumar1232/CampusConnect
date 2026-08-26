<%@page import="java.sql.*"%>

<%
    Integer companyId = (Integer)session.getAttribute("companyId");

    if(companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveIdParameter = request.getParameter("driveId");

    if(driveIdParameter == null || driveIdParameter.trim().equals(""))
    {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    int driveId;

    try
    {
        driveId = Integer.parseInt(driveIdParameter);
    }
    catch(Exception e)
    {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }


    /*
     * Verify that this recruitment drive
     * belongs to the logged-in company.
     */

    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "CAMPUSCONNECT",
        "campus123"
    );

    Statement stmt = con.createStatement();


    String driveQuery =
        "SELECT DRIVE_ID, DRIVE_TYPE, JOB_TITLE " +
        "FROM RECRUITMENT_DRIVE " +
        "WHERE DRIVE_ID = " + driveId +
        " AND COMPANY_ID = " + companyId;

    ResultSet driveRs = stmt.executeQuery(driveQuery);


    if(!driveRs.next())
    {
        con.close();

        out.println("<h3>Invalid recruitment drive.</h3>");
        out.println(
            "<a href='view-recruitment-drives.jsp'>" +
            "Back to Recruitment Drives</a>"
        );

        return;
    }


    String driveType = driveRs.getString("DRIVE_TYPE");
    String jobTitle = driveRs.getString("JOB_TITLE");


    /*
     * College selection is only applicable
     * to On Campus drives.
     */

    if(driveType == null || !driveType.equalsIgnoreCase("On Campus"))
    {
        con.close();

        out.println(
            "<h3>College selection is available only for On Campus drives.</h3>"
        );

        out.println(
            "<a href='view-recruitment-drives.jsp'>" +
            "Back to Recruitment Drives</a>"
        );

        return;
    }


    /*
     * Fetch active colleges.
     */

    String collegeQuery =
        "SELECT COLLEGE_ID, COLLEGE_NAME, CITY, STATE " +
        "FROM COLLEGE " +
        "WHERE STATUS = 'ACTIVE' " +
        "ORDER BY COLLEGE_ID";

    ResultSet collegeRs = stmt.executeQuery(collegeQuery);

%>

<html>

<head>

    <title>Select Colleges</title>

</head>

<body>

<h2>Select Colleges for Recruitment Drive</h2>

<p>
    <b>Drive ID:</b>
    <%= driveId %>
</p>

<p>
    <b>Job Title:</b>
    <%= jobTitle %>
</p>

<p>
    <b>Drive Type:</b>
    <%= driveType %>
</p>

<hr>

<h3>Available Colleges</h3>

<form method="post" action="save-drive-colleges.jsp">

    <input
        type="hidden"
        name="driveId"
        value="<%= driveId %>">

<%
    boolean collegesFound = false;

    while(collegeRs.next())
    {
        collegesFound = true;
%>

        <p>

            <input
                type="checkbox"
                name="collegeId"
                value="<%= collegeRs.getInt("COLLEGE_ID") %>">

            <b>
                <%= collegeRs.getString("COLLEGE_NAME") %>
            </b>

            -
            <%= collegeRs.getString("CITY") %>

            ,
            <%= collegeRs.getString("STATE") %>

        </p>

<%
    }


    if(!collegesFound)
    {
%>

        <p>
            No active colleges are currently available.
        </p>

<%
    }

    con.close();
%>

    <br>

    <input
        type="submit"
        value="Save Selected Colleges">

</form>

<br>

<a href="view-recruitment-drives.jsp">
    Back to Recruitment Drives
</a>

</body>

</html>