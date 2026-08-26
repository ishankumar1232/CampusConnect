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
     * Get selected college IDs.
     */

    String[] collegeIds = request.getParameterValues("collegeId");


    /*
     * Connect to Oracle.
     */

    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "CAMPUSCONNECT",
        "campus123"
    );


    /*
     * Verify that the drive belongs
     * to the logged-in company.
     */

    Statement stmt = con.createStatement();

    String driveQuery =
        "SELECT DRIVE_ID " +
        "FROM RECRUITMENT_DRIVE " +
        "WHERE DRIVE_ID = " + driveId +
        " AND COMPANY_ID = " + companyId +
        " AND DRIVE_TYPE = 'On Campus'";

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


    /*
     * Check whether at least one college
     * was selected.
     */

    if(collegeIds == null || collegeIds.length == 0)
    {
        con.close();

        out.println("<h3>Please select at least one college.</h3>");
        out.println(
            "<a href='select-drive-colleges.jsp?driveId=" +
            driveId +
            "'>Back to College Selection</a>"
        );

        return;
    }


    /*
     * Insert selected colleges.
     */

    int inserted = 0;
    int alreadyExists = 0;


    for(int i = 0; i < collegeIds.length; i++)
    {
        try
        {
            int collegeId = Integer.parseInt(collegeIds[i]);


            /*
             * Check whether the college exists
             * and is active.
             */

            String collegeQuery =
                "SELECT COLLEGE_ID " +
                "FROM COLLEGE " +
                "WHERE COLLEGE_ID = " + collegeId +
                " AND STATUS = 'ACTIVE'";

            ResultSet collegeRs =
                stmt.executeQuery(collegeQuery);


            if(!collegeRs.next())
            {
                continue;
            }


            /*
             * Check whether this college
             * is already assigned to the drive.
             */

            String checkQuery =
                "SELECT COUNT(*) " +
                "FROM DRIVE_COLLEGE " +
                "WHERE DRIVE_ID = " + driveId +
                " AND COLLEGE_ID = " + collegeId;

            ResultSet checkRs =
                stmt.executeQuery(checkQuery);


            checkRs.next();

            int count = checkRs.getInt(1);


            if(count > 0)
            {
                alreadyExists++;
            }
            else
            {
                String insertQuery =
                    "INSERT INTO DRIVE_COLLEGE " +
                    "(DRIVE_ID, COLLEGE_ID) " +
                    "VALUES (" +
                    driveId + ", " +
                    collegeId + ")";

                int result =
                    stmt.executeUpdate(insertQuery);


                if(result > 0)
                {
                    inserted++;
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }


    con.close();

%>

<html>

<head>

    <title>College Selection Result</title>

</head>

<body>

<h2>College Selection Result</h2>

<p>
    Colleges successfully assigned:
    <b><%= inserted %></b>
</p>

<p>
    Colleges already assigned:
    <b><%= alreadyExists %></b>
</p>

<br>

<a href="select-drive-colleges.jsp?driveId=<%= driveId %>">
    Back to College Selection
</a>

<br><br>

<a href="view-recruitment-drives.jsp">
    Back to Recruitment Drives
</a>

</body>

</html>