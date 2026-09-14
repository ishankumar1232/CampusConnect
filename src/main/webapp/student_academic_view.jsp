<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Academic Details</title>

</head>


<body>

<h2>Academic Details</h2>


<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;


try
{
    HttpSession session1 =
        request.getSession(false);


    if(session1 == null ||
       session1.getAttribute("studentId") == null)
    {
        response.sendRedirect(
            "student_login.jsp"
        );

        return;
    }


    int studentId =
        (Integer)session1.getAttribute(
            "studentId"
        );


    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );


    con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "CAMPUSCONNECT",
        "campus123"
    );


    String sql =
        "SELECT ACADEMIC_ID, QUALIFICATION, " +
        "YEAR, PERCENTAGE, CGPA, BACKLOGS " +
        "FROM STUDENT_ACADEMIC " +
        "WHERE STUDENT_ID=? " +
        "ORDER BY YEAR DESC";


    ps = con.prepareStatement(sql);


    ps.setInt(1, studentId);


    rs = ps.executeQuery();


    boolean found = false;

%>


<table border="1"
       cellpadding="10"
       cellspacing="0">


<tr>

<th>Academic ID</th>

<th>Qualification</th>

<th>Year</th>

<th>Percentage</th>

<th>CGPA</th>

<th>Backlogs</th>

<th>Edit</th>

<th>Delete</th>

</tr>


<%

while(rs.next())
{
    found = true;

%>


<tr>

<td>

<%=rs.getInt("ACADEMIC_ID")%>

</td>


<td>

<%=rs.getString("QUALIFICATION")%>

</td>


<td>

<%=rs.getInt("YEAR")%>

</td>


<td>

<%=rs.getDouble("PERCENTAGE")%>

</td>


<td>

<%=rs.getDouble("CGPA")%>

</td>


<td>

<%=rs.getInt("BACKLOGS")%>

</td>


<!-- EDIT -->

<td>

<a href="student_academic.jsp?editId=<%=rs.getInt("ACADEMIC_ID")%>">

Edit

</a>

</td>


<!-- DELETE -->

<td>

<form method="post"
      action="studentAcademic"
      onsubmit="return confirm('Are you sure you want to delete this record?');">


<input type="hidden"
       name="action"
       value="delete">


<input type="hidden"
       name="academicId"
       value="<%=rs.getInt("ACADEMIC_ID")%>">


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

<td colspan="8">

No Academic Details Found

</td>

</tr>


<%

}

%>


</table>


<br>


<a href="student_academic.jsp">

Add Academic Details

</a>


<br>
<br>


<a href="student_dashboard.jsp">

Back to Dashboard

</a>


<%

}
catch(Exception e)
{

%>


<h3>

Error: <%=e.getMessage()%>

</h3>


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


</body>

</html>