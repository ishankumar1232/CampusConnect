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

    <title>Notice Management</title>

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

        input, textarea {
            width: 95%;
            padding: 12px;
            margin-top: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }

        textarea {
            height: 120px;
            resize: vertical;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #444;
        }

        button {
            margin-top: 20px;
            padding: 11px 20px;
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

        .active {
            color: green;
            font-weight: bold;
        }

    </style>

</head>

<body>

<div class="header">
    Notice Management
</div>


<div class="back">

    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>

</div>


<!-- Add Notice -->

<div class="box">

    <h2>Add Notice</h2>

    <form action="NoticeController" method="post">

        <input type="hidden"
               name="action"
               value="add">

        <label>Notice Title</label>

        <input type="text"
               name="title"
               placeholder="Enter notice title"
               required>


        <label>Notice Content</label>

        <textarea name="content"
                  placeholder="Enter notice content"
                  required></textarea>


        <button type="submit">
            Publish Notice
        </button>

    </form>

</div>


<!-- Notice List -->

<div class="box">

    <h2>Notice List</h2>

    <table>

        <tr>
            <th>Notice ID</th>
            <th>Title</th>
            <th>Content</th>
            <th>Date</th>
            <th>Status</th>
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
            "SELECT NOTICE_ID, TITLE, CONTENT, " +
            "NOTICE_DATE, STATUS " +
            "FROM NOTICE " +
            "WHERE COLLEGE_ID=? " +
            "ORDER BY NOTICE_ID DESC";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        boolean found = false;

        while(rs.next()) {

            found = true;
%>

        <tr>

            <td>
                <%=rs.getInt("NOTICE_ID")%>
            </td>

            <td>
                <%=rs.getString("TITLE")%>
            </td>

            <td>
                <%=rs.getString("CONTENT")%>
            </td>

            <td>
                <%=rs.getDate("NOTICE_DATE")%>
            </td>

            <td class="active">
                <%=rs.getString("STATUS")%>
            </td>

            <td>

                <form action="NoticeController"
                      method="post">

                    <input type="hidden"
                           name="action"
                           value="delete">

                    <input type="hidden"
                           name="noticeId"
                           value="<%=rs.getInt("NOTICE_ID")%>">

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

            <td colspan="6">
                No notices found.
            </td>

        </tr>

<%
        }

    } catch(Exception e) {
%>

        <tr>

            <td colspan="6">
                Error: <%=e.getMessage()%>
            </td>

        </tr>

<%
    } finally {

        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(ps != null) try { ps.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}

    }
%>

    </table>

</div>

</body>

</html>