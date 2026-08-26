<%@ page import="java.sql.*" %>

<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null || session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = (Integer)session1.getAttribute("studentId");

    String name = "";
    String email = "";
    String phone = "";
    String dob = "";
    String gender = "";
    String address = "";
    String collegeName = "";
    String courseName = "";
    String admissionDate = "";
    String status = "";

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        Statement stmt = con.createStatement();

        String q = "SELECT S.NAME, S.EMAIL, S.PHONE, S.DOB, "
                 + "S.GENDER, S.ADDRESS, S.ADMISSION_DATE, S.STATUS, "
                 + "C.COLLEGE_NAME, CR.COURSE_NAME "
                 + "FROM STUDENT S, COLLEGE C, COURSE CR "
                 + "WHERE S.COLLEGE_ID = C.COLLEGE_ID "
                 + "AND S.COURSE_ID = CR.COURSE_ID "
                 + "AND S.STUDENT_ID = " + studentId;

        ResultSet rs = stmt.executeQuery(q);

        if(rs.next())
        {
            name = rs.getString("NAME");
            email = rs.getString("EMAIL");
            phone = rs.getString("PHONE");
            dob = rs.getString("DOB");
            gender = rs.getString("GENDER");
            address = rs.getString("ADDRESS");
            collegeName = rs.getString("COLLEGE_NAME");
            courseName = rs.getString("COURSE_NAME");
            admissionDate = rs.getString("ADMISSION_DATE");
            status = rs.getString("STATUS");
        }

        rs.close();
        stmt.close();
        con.close();
    }
    catch(Exception e)
    {
        out.println("<h3>Error: " + e + "</h3>");
    }
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Student Profile</title>

</head>


<body>

<h1>Student Profile</h1>

<hr>


<table border="1" cellpadding="10">

<tr>
    <td><b>Student ID</b></td>
    <td><%=studentId%></td>
</tr>

<tr>
    <td><b>Name</b></td>
    <td><%=name%></td>
</tr>

<tr>
    <td><b>Email</b></td>
    <td><%=email%></td>
</tr>

<tr>
    <td><b>Phone</b></td>
    <td><%=phone%></td>
</tr>

<tr>
    <td><b>Date of Birth</b></td>
    <td><%=dob%></td>
</tr>

<tr>
    <td><b>Gender</b></td>
    <td><%=gender%></td>
</tr>

<tr>
    <td><b>Address</b></td>
    <td><%=address%></td>
</tr>

<tr>
    <td><b>College</b></td>
    <td><%=collegeName%></td>
</tr>

<tr>
    <td><b>Course</b></td>
    <td><%=courseName%></td>
</tr>

<tr>
    <td><b>Admission Date</b></td>
    <td><%=admissionDate%></td>
</tr>

<tr>
    <td><b>Status</b></td>
    <td><%=status%></td>
</tr>

</table>

<br>

<a href="student_dashboard.jsp">Back to Dashboard</a>

</body>

</html>