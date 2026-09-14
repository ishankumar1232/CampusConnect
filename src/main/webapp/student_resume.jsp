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


    String editId =
        request.getParameter("editId");

    boolean editMode =
        editId != null &&
        !editId.trim().equals("");

    String oldFile = "";


    if(editMode)
    {
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
                "SELECT RESUME_FILE FROM RESUME " +
                "WHERE RESUME_ID=? AND STUDENT_ID=?";

            ps = con.prepareStatement(sql);

            ps.setInt(
                1,
                Integer.parseInt(editId)
            );

            ps.setInt(2, studentId);

            rs = ps.executeQuery();

            if(rs.next())
            {
                oldFile =
                    rs.getString("RESUME_FILE");
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
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
    }
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Student Resume</title>

</head>


<body>

<h2>

<%
    if(editMode)
    {
        out.print("Edit Resume");
    }
    else
    {
        out.print("Upload Resume");
    }
%>

</h2>


<p>

<span style="color:red;">*</span>
Indicates Mandatory Fields

</p>


<form name="resumeForm"
      method="post"
      action="studentResume"
      enctype="multipart/form-data">


<%
    if(editMode)
    {
%>

<input type="hidden"
       name="resumeId"
       value="<%=editId%>">

<%
    }
%>


<table border="0"
       cellpadding="8">


<tr>

<td>

Resume File
<span style="color:red;">*</span>

</td>


<td>

<input type="file"
       name="resumeFile"
       accept=".pdf,.doc,.docx"
       required>

</td>

</tr>


<%
    if(editMode)
    {
%>

<tr>

<td>

Current Resume

</td>

<td>

<%=oldFile%>

</td>

</tr>

<%
    }
%>


<tr>

<td>

<input type="submit"
       value="<%
       if(editMode)
       {
           out.print("Update Resume");
       }
       else
       {
           out.print("Upload Resume");
       }
       %>">

</td>


<td>

<input type="reset"
       value="Reset">

</td>

</tr>


</table>

</form>


<br>


<a href="student_resume_view.jsp">

View Resumes

</a>


<br><br>


<a href="student_dashboard.jsp">

Back to Dashboard

</a>


</body>

</html>