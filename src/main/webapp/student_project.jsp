<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Project</title>


<script>

function validateForm()
{
    var projectName =
        document.forms["projectForm"]["projectName"].value;

    var description =
        document.forms["projectForm"]["description"].value;

    var technologies =
        document.forms["projectForm"]["technologies"].value;


    /* Project Name */

    if(projectName == "" || projectName == null)
    {
        alert("Project Name is required");

        document.forms["projectForm"]
        ["projectName"].focus();

        return false;
    }


    /* Description */

    if(description == "" || description == null)
    {
        alert("Project Description is required");

        document.forms["projectForm"]
        ["description"].focus();

        return false;
    }


    /* Technologies */

    if(technologies == "" || technologies == null)
    {
        alert("Technologies are required");

        document.forms["projectForm"]
        ["technologies"].focus();

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


String projectNameValue = "";
String descriptionValue = "";
String technologiesValue = "";
String projectUrlValue = "";


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
            "SELECT PROJECT_NAME, DESCRIPTION, " +
            "TECHNOLOGIES, PROJECT_URL " +
            "FROM STUDENT_PROJECT " +
            "WHERE PROJECT_ID=? " +
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
            projectNameValue =
                rs.getString("PROJECT_NAME");

            descriptionValue =
                rs.getString("DESCRIPTION");

            technologiesValue =
                rs.getString("TECHNOLOGIES");

            projectUrlValue =
                rs.getString("PROJECT_URL");


            if(projectNameValue == null)
                projectNameValue = "";

            if(descriptionValue == null)
                descriptionValue = "";

            if(technologiesValue == null)
                technologiesValue = "";

            if(projectUrlValue == null)
                projectUrlValue = "";
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


<h2>Student Project</h2>


<p>

<span style="color:red">*</span>

Indicates Mandatory Fields

</p>


<form name="projectForm"
      method="post"
      action="studentProject"
      onsubmit="return validateForm();">


<input type="hidden"
       name="projectId"
       value="<%=editId == null ? "" : editId%>">


<table border="0"
       cellpadding="8">


<!-- PROJECT NAME -->

<tr>

<td>

Project Name

<span style="color:red">*</span>

</td>

<td>

<input type="text"
       name="projectName"
       value="<%=projectNameValue%>"
       placeholder="Enter Project Name">

</td>

</tr>


<!-- DESCRIPTION -->

<tr>

<td>

Description

<span style="color:red">*</span>

</td>

<td>

<textarea name="description"
          rows="5"
          cols="30"
          placeholder="Enter Project Description"><%=descriptionValue%></textarea>

</td>

</tr>


<!-- TECHNOLOGIES -->

<tr>

<td>

Technologies

<span style="color:red">*</span>

</td>

<td>

<input type="text"
       name="technologies"
       value="<%=technologiesValue%>"
       placeholder="Example: Java, Oracle, HTML">

</td>

</tr>


<!-- PROJECT URL -->

<tr>

<td>

Project URL

</td>

<td>

<input type="text"
       name="projectUrl"
       value="<%=projectUrlValue%>"
       placeholder="https://github.com/...">

</td>

</tr>


<!-- BUTTONS -->

<tr>

<td>

<input type="submit"
       value="<%=editId == null ? "Add Project" : "Update Project"%>">

</td>

<td>

<input type="reset"
       value="Reset">

</td>

</tr>


</table>

</form>


<br>


<a href="student_project_view.jsp">

View Projects

</a>


<br>
<br>


<a href="student_dashboard.jsp">

Back to Dashboard

</a>


</body>

</html>