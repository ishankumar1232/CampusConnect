<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Skills</title>


<script>

function validateForm()
{
    var skillName =
        document.forms["skillForm"]["skillName"].value;


    if(skillName == "" || skillName == null)
    {
        alert("Skill Name is required");

        document.forms["skillForm"]
        ["skillName"].focus();

        return false;
    }


    var letters =
        /^[A-Za-z0-9+#. ]+$/;


    if(!letters.test(skillName))
    {
        alert("Invalid Skill Name");

        document.forms["skillForm"]
        ["skillName"].focus();

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


String skillNameValue = "";


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
            "SELECT SKILL_NAME " +
            "FROM STUDENT_SKILL " +
            "WHERE SKILL_ID=? " +
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
            skillNameValue =
                rs.getString("SKILL_NAME");
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


<h2>Student Skills</h2>


<p>

<span style="color:red">*</span>

Indicates Mandatory Fields

</p>


<form name="skillForm"
      method="post"
      action="studentSkill"
      onsubmit="return validateForm();">


<input type="hidden"
       name="skillId"
       value="<%=editId == null ? "" : editId%>">


<table border="0"
       cellpadding="8">


<tr>

<td>

Skill Name

<span style="color:red">*</span>

</td>

<td>

<input type="text"
       name="skillName"
       value="<%=skillNameValue%>"
       placeholder="Example: Java">

</td>

</tr>


<tr>

<td>

<input type="submit"
       value="<%=editId == null ? "Add Skill" : "Update Skill"%>">

</td>


<td>

<input type="reset"
       value="Reset">

</td>

</tr>


</table>

</form>


<br>


<a href="student_skill_view.jsp">

View Skills

</a>


<br>
<br>


<a href="student_dashboard.jsp">

Back to Dashboard

</a>


</body>

</html>