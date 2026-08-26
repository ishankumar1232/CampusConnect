<%@ page import="java.sql.*" %>

<%
    String collegeId = request.getParameter("collegeId");

    if(collegeId == null || collegeId.trim().equals(""))
    {
        response.sendRedirect("new_student_colleges.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String collegeName = "";

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        ps = con.prepareStatement(
            "SELECT COLLEGE_NAME FROM COLLEGE WHERE COLLEGE_ID = ? AND STATUS = 'ACTIVE'"
        );

        ps.setInt(1, Integer.parseInt(collegeId));

        rs = ps.executeQuery();

        if(rs.next())
        {
            collegeName = rs.getString("COLLEGE_NAME");
        }
        else
        {
            response.sendRedirect("new_student_colleges.jsp");
            return;
        }
    }
    catch(Exception e)
    {
        out.println("Error: " + e);
    }
    finally
    {
        try
        {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        }
        catch(Exception e)
        {
        }
    }
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Admission Request</title>

</head>

<body>

<h1>Admission Request</h1>

<hr>

<h3>Selected College</h3>

<table border="1" cellpadding="10">

<tr>

    <th>College ID</th>

    <td>
        <%=collegeId%>
    </td>

</tr>

<tr>

    <th>College Name</th>

    <td>
        <%=collegeName%>
    </td>

</tr>

</table>

<br>

<h3>Applicant Details</h3>

<form method="post" action="NewStudentAdmissionRequest">

    <input type="hidden"
           name="collegeId"
           value="<%=collegeId%>">

    <table border="0" cellpadding="8">

        <tr>

            <td>
                Name
            </td>

            <td>
                <input type="text"
                       name="name"
                       placeholder="Enter Name"
                       required>
            </td>

        </tr>

        <tr>

            <td>
                Email
            </td>

            <td>
                <input type="email"
                       name="email"
                       placeholder="Enter Email"
                       required>
            </td>

        </tr>

        <tr>

            <td>
                Phone
            </td>

            <td>
                <input type="text"
                       name="phone"
                       maxlength="10"
                       placeholder="Enter 10 digit phone"
                       required>
            </td>

        </tr>

        <tr>

            <td>
                Course
            </td>

            <td>

                <select name="courseId" required>

                    <option value="">
                        Select Course
                    </option>

                    <%
                        Connection con2 = null;
                        PreparedStatement ps2 = null;
                        ResultSet rs2 = null;

                        try
                        {
                            Class.forName("oracle.jdbc.driver.OracleDriver");

                            con2 = DriverManager.getConnection(
                                "jdbc:oracle:thin:@localhost:1521:XE",
                                "CAMPUSCONNECT",
                                "campus123"
                            );

                            ps2 = con2.prepareStatement(
                                "SELECT COURSE_ID, COURSE_NAME " +
                                "FROM COURSE " +
                                "ORDER BY COURSE_NAME"
                            );

                            rs2 = ps2.executeQuery();

                            while(rs2.next())
                            {
                    %>

                    <option value="<%=rs2.getInt("COURSE_ID")%>">

                        <%=rs2.getString("COURSE_NAME")%>

                    </option>

                    <%
                            }
                        }
                        catch(Exception e)
                        {
                            out.println(e);
                        }
                        finally
                        {
                            try
                            {
                                if(rs2 != null) rs2.close();
                                if(ps2 != null) ps2.close();
                                if(con2 != null) con2.close();
                            }
                            catch(Exception e)
                            {
                            }
                        }
                    %>

                </select>

            </td>

        </tr>

        <tr>

            <td>

                <input type="submit"
                       value="Submit Admission Request">

            </td>

            <td>

                <input type="reset"
                       value="Reset">

            </td>

        </tr>

    </table>

</form>

<br>

<a href="new_student_colleges.jsp">
    Back to Available Colleges
</a>

</body>

</html>