<%@ page import="java.sql.*" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");

    if(collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <title>Course Management</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .header {
            background: #2c4358;
            color: white;
            padding: 25px 35px;
            font-size: 32px;
            font-weight: bold;
        }

        .back {
            margin: 30px;
        }

        .back a {
            color: #2196f3;
            text-decoration: none;
            font-size: 18px;
        }

        .box {
            background: white;
            margin: 20px 30px;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px #ccc;
        }

        h2 {
            color: #2c4358;
        }

        input, select {
            padding: 10px;
            margin: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        select {
            width: 300px;
        }

        input {
            width: 280px;
        }

        button {
            padding: 10px 18px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background: #217dbb;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        th {
            background: #3498db;
            color: white;
            padding: 13px;
        }

        td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        .delete {
            background: #e74c3c;
        }

        .delete:hover {
            background: #c0392b;
        }

    </style>

</head>

<body>

<div class="header">
    Course Management
</div>


<div class="back">

    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>

</div>


<!-- Add Course -->

<div class="box">

    <h2>Add Course</h2>

    <form action="CourseController" method="post">

        <input type="hidden"
               name="action"
               value="add">


        <select name="departmentId" required>

            <option value="">
                Select Department
            </option>

<%
    Connection con1 = null;
    PreparedStatement ps1 = null;
    ResultSet rs1 = null;

    try {

        Class.forName("oracle.jdbc.driver.OracleDriver");

        con1 = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql1 =
            "SELECT DEPARTMENT_ID, DEPARTMENT_NAME " +
            "FROM DEPARTMENT " +
            "WHERE COLLEGE_ID=? " +
            "ORDER BY DEPARTMENT_NAME";

        ps1 = con1.prepareStatement(sql1);

        ps1.setInt(1, collegeId);

        rs1 = ps1.executeQuery();

        while(rs1.next()) {
%>

            <option value="<%=rs1.getInt("DEPARTMENT_ID")%>">
                <%=rs1.getString("DEPARTMENT_NAME")%>
            </option>

<%
        }

    } catch(Exception e) {

        out.println("<option>Error loading departments</option>");

    } finally {

        if(rs1 != null) try { rs1.close(); } catch(Exception e) {}
        if(ps1 != null) try { ps1.close(); } catch(Exception e) {}
        if(con1 != null) try { con1.close(); } catch(Exception e) {}

    }
%>

        </select>


        <input type="text"
               name="courseName"
               placeholder="Course Name"
               required>


        <button type="submit">
            Add Course
        </button>

    </form>

</div>


<!-- Course List -->

<div class="box">

    <h2>Course List</h2>

    <table>

        <tr>
            <th>Course ID</th>
            <th>Course Name</th>
            <th>Department</th>
            <th>Action</th>
        </tr>

<%
    Connection con2 = null;
    PreparedStatement ps2 = null;
    ResultSet rs2 = null;

    try {

        Class.forName("oracle.jdbc.driver.OracleDriver");

        con2 = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql2 =
            "SELECT C.COURSE_ID, " +
            "C.COURSE_NAME, " +
            "D.DEPARTMENT_NAME " +
            "FROM COURSE C " +
            "JOIN DEPARTMENT D " +
            "ON C.DEPARTMENT_ID=D.DEPARTMENT_ID " +
            "WHERE D.COLLEGE_ID=? " +
            "ORDER BY C.COURSE_ID";

        ps2 = con2.prepareStatement(sql2);

        ps2.setInt(1, collegeId);

        rs2 = ps2.executeQuery();

        boolean found = false;

        while(rs2.next()) {

            found = true;
%>

        <tr>

            <td>
                <%=rs2.getInt("COURSE_ID")%>
            </td>

            <td>
                <%=rs2.getString("COURSE_NAME")%>
            </td>

            <td>
                <%=rs2.getString("DEPARTMENT_NAME")%>
            </td>

            <td>

                <form action="CourseController"
                      method="post">

                    <input type="hidden"
                           name="action"
                           value="delete">

                    <input type="hidden"
                           name="courseId"
                           value="<%=rs2.getInt("COURSE_ID")%>">

                    <button type="submit"
                            class="delete">
                        Delete
                    </button>

                </form>

            </td>

        </tr>

<%
        }

        if(!found) {
%>

        <tr>

            <td colspan="4">
                No courses found.
            </td>

        </tr>

<%
        }

    } catch(Exception e) {
%>

        <tr>

            <td colspan="4">
                Error: <%=e.getMessage()%>
            </td>

        </tr>

<%
    } finally {

        if(rs2 != null) try { rs2.close(); } catch(Exception e) {}
        if(ps2 != null) try { ps2.close(); } catch(Exception e) {}
        if(con2 != null) try { con2.close(); } catch(Exception e) {}

    }
%>

    </table>

</div>

</body>

</html>