<%@ page import="java.sql.*" %>

<%
    HttpSession session1 =
        request.getSession(false);

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

<title>My Resume</title>

</head>


<body>

<h1>My Resume</h1>

<hr>


<table border="1"
       cellpadding="10">


<tr>

    <th>Resume ID</th>

    <th>Resume File</th>

    <th>Uploaded Date</th>

    <th>View</th>

    <th>Download</th>

    <th>Edit</th>

    <th>Delete</th>

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


        con =
            DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );


        String sql =
            "SELECT RESUME_ID, RESUME_FILE, " +
            "UPLOADED_DATE " +
            "FROM RESUME " +
            "WHERE STUDENT_ID=? " +
            "ORDER BY RESUME_ID";


        ps =
            con.prepareStatement(sql);

        ps.setInt(1, studentId);

        rs =
            ps.executeQuery();


        boolean found = false;


        while(rs.next())
        {
            found = true;


            int resumeId =
                rs.getInt("RESUME_ID");


            String resumeFile =
                rs.getString("RESUME_FILE");


%>


<tr>

<td>

<%=resumeId%>

</td>


<td>

<%=resumeFile%>

</td>


<td>

<%=rs.getDate("UPLOADED_DATE")%>

</td>


<!-- VIEW -->

<td>

<a href="resume_files/<%=resumeFile%>"
   target="_blank">

View

</a>

</td>


<!-- DOWNLOAD -->

<td>

<a href="resume_files/<%=resumeFile%>"
   download>

Download

</a>

</td>


<!-- EDIT -->

<td>

<a href="student_resume.jsp?editId=<%=resumeId%>">

Edit

</a>

</td>


<!-- DELETE -->

<td>

<form method="post"
      action="studentResume"
      onsubmit="return confirm('Are you sure you want to delete this resume?');">


<input type="hidden"
       name="action"
       value="delete">


<input type="hidden"
       name="resumeId"
       value="<%=resumeId%>">


<input type="hidden"
       name="resumeFile"
       value="<%=resumeFile%>">


<input type="submit"
       value="Delete">


</form>

</td>

</tr>


<%

        }


        if(!found)
        {

%>


<tr>

<td colspan="7">

No Resume Found

</td>

</tr>


<%

        }
    }
    catch(Exception e)
    {

%>


<tr>

<td colspan="7">

Error: <%=e.getMessage()%>

</td>

</tr>


<%

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