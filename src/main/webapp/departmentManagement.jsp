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

    <title>Department Management</title>

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

        input {
            padding: 10px;
            width: 300px;
            border: 1px solid #ccc;
            border-radius: 5px;
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
    Department Management
</div>


<div class="back">

    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>

</div>


<!-- Add Department -->

<div class="box">

    <h2>Add Department</h2>

    <form action="DepartmentController" method="post">

        <input type="hidden"
               name="action"
               value="add">

        <input type="text"
               name="departmentName"
               placeholder="Department Name"
               required>

        <button type="submit">
            Add Department
        </button>

    </form>

</div>


<!-- Department List -->

<div class="box">

    <h2>Department List</h2>

    <table>

        <tr>
            <th>Department ID</th>
            <th>Department Name</th>
            <th>Action</th>
        </tr>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql =
            "SELECT DEPARTMENT_ID, DEPARTMENT_NAME " +
            "FROM DEPARTMENT " +
            "WHERE COLLEGE_ID=? " +
            "ORDER BY DEPARTMENT_ID";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;
%>

        <tr>

            <td>
                <%=rs.getInt("DEPARTMENT_ID")%>
            </td>

            <td>
                <%=rs.getString("DEPARTMENT_NAME")%>
            </td>

            <td>

                <form action="DepartmentController"
                      method="post">

                    <input type="hidden"
                           name="action"
                           value="delete">

                    <input type="hidden"
                           name="departmentId"
                           value="<%=rs.getInt("DEPARTMENT_ID")%>">

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

            <td colspan="3">
                No departments found.
            </td>

        </tr>

<%
        }

    } catch(Exception e) {
%>

        <tr>

            <td colspan="3">
                Error: <%=e.getMessage()%>
            </td>

        </tr>

<%
    } finally {

        if(rs != null) {
            try { rs.close(); } catch(Exception e) {}
        }

        if(ps != null) {
            try { ps.close(); } catch(Exception e) {}
        }

        if(con != null) {
            try { con.close(); } catch(Exception e) {}
        }

    }
%>

    </table>

</div>

</body>

</html>