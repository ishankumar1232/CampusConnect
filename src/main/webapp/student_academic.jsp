<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Academic Details</title>


<script>

function validateForm()
{
    var qualification =
        document.forms["academicForm"]["qualification"].value;

    var year =
        document.forms["academicForm"]["year"].value;

    var percentage =
        document.forms["academicForm"]["percentage"].value;

    var cgpa =
        document.forms["academicForm"]["cgpa"].value;

    var backlogs =
        document.forms["academicForm"]["backlogs"].value;


    if(qualification == "" || qualification == null)
    {
        alert("Qualification is required");

        document.forms["academicForm"]
        ["qualification"].focus();

        return false;
    }


    if(year == "" || year == null)
    {
        alert("Year is required");

        document.forms["academicForm"]
        ["year"].focus();

        return false;
    }


    if(percentage == "" || percentage == null)
    {
        alert("Percentage is required");

        document.forms["academicForm"]
        ["percentage"].focus();

        return false;
    }


    if(percentage < 0 || percentage > 100)
    {
        alert("Percentage must be between 0 and 100");

        document.forms["academicForm"]
        ["percentage"].focus();

        return false;
    }


    if(cgpa == "" || cgpa == null)
    {
        alert("CGPA is required");

        document.forms["academicForm"]
        ["cgpa"].focus();

        return false;
    }


    if(cgpa < 0 || cgpa > 10)
    {
        alert("CGPA must be between 0 and 10");

        document.forms["academicForm"]
        ["cgpa"].focus();

        return false;
    }


    if(backlogs == "" || backlogs == null)
    {
        alert("Backlogs is required");

        document.forms["academicForm"]
        ["backlogs"].focus();

        return false;
    }


    if(backlogs < 0)
    {
        alert("Backlogs cannot be negative");

        document.forms["academicForm"]
        ["backlogs"].focus();

        return false;
    }


    return true;
}

</script>

</head>


<body>

<%

String editId =
    request.getParameter("editId");


String qualificationValue = "";
String yearValue = "";
String percentageValue = "";
String cgpaValue = "";
String backlogsValue = "";


if(editId != null &&
   !editId.equals(""))
{
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
            "SELECT QUALIFICATION, YEAR, " +
            "PERCENTAGE, CGPA, BACKLOGS " +
            "FROM STUDENT_ACADEMIC " +
            "WHERE ACADEMIC_ID=? " +
            "AND STUDENT_ID=?";


        ps = con.prepareStatement(sql);


        ps.setInt(
            1,
            Integer.parseInt(editId)
        );


        ps.setInt(
            2,
            studentId
        );


        rs = ps.executeQuery();


        if(rs.next())
        {
            qualificationValue =
                rs.getString("QUALIFICATION");

            yearValue =
                String.valueOf(
                    rs.getInt("YEAR")
                );

            percentageValue =
                String.valueOf(
                    rs.getDouble("PERCENTAGE")
                );

            cgpaValue =
                String.valueOf(
                    rs.getDouble("CGPA")
                );

            backlogsValue =
                String.valueOf(
                    rs.getInt("BACKLOGS")
                );
        }
    }
    catch(Exception e)
    {
        out.println(
            "Error: " + e.getMessage()
        );
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
}

%>


<h2>Academic Details</h2>


<p>

<span style="color:red">*</span>

Indicates Mandatory Fields

</p>


<form name="academicForm"
      method="post"
      action="studentAcademic"
      onsubmit="return validateForm();">


<input type="hidden"
       name="academicId"
       value="<%=editId == null ? "" : editId%>">


<table border="0"
       cellpadding="8">


<!-- QUALIFICATION -->

<tr>

<td>

Qualification

<span style="color:red">*</span>

</td>

<td>

<input type="text"
       name="qualification"
       value="<%=qualificationValue%>"
       placeholder="Example: B.Tech">

</td>

</tr>


<!-- YEAR -->

<tr>

<td>

Year

<span style="color:red">*</span>

</td>

<td>

<input type="number"
       name="year"
       value="<%=yearValue%>"
       placeholder="Example: 2026">

</td>

</tr>


<!-- PERCENTAGE -->

<tr>

<td>

Percentage

<span style="color:red">*</span>

</td>

<td>

<input type="number"
       name="percentage"
       value="<%=percentageValue%>"
       step="0.01"
       placeholder="Example: 85.50">

</td>

</tr>


<!-- CGPA -->

<tr>

<td>

CGPA

<span style="color:red">*</span>

</td>

<td>

<input type="number"
       name="cgpa"
       value="<%=cgpaValue%>"
       step="0.01"
       placeholder="Example: 8.50">

</td>

</tr>


<!-- BACKLOGS -->

<tr>

<td>

Backlogs

<span style="color:red">*</span>

</td>

<td>

<input type="number"
       name="backlogs"
       value="<%=backlogsValue%>"
       min="0"
       placeholder="Example: 0">

</td>

</tr>


<!-- BUTTON -->

<tr>

<td>

<input type="submit"
       value="<%=editId == null ? "Submit" : "Update"%>">

</td>


<td>

<input type="reset"
       value="Reset">

</td>

</tr>


</table>

</form>


<br>


<a href="student_academic_view.jsp">

View Academic Details

</a>


<br>
<br>


<a href="student_dashboard.jsp">

Back to Dashboard

</a>


</body>

</html>