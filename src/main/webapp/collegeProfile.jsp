<%@ page import="java.sql.*" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");

    if(collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }

    String collegeName = "";
    String address = "";
    String city = "";
    String state = "";
    String email = "";
    String phone = "";
    String status = "";

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
            "SELECT COLLEGE_NAME, ADDRESS, CITY, STATE, " +
            "EMAIL, PHONE, STATUS " +
            "FROM COLLEGE " +
            "WHERE COLLEGE_ID=?";

        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();

        if(rs.next()) {

            collegeName = rs.getString("COLLEGE_NAME");
            address = rs.getString("ADDRESS");
            city = rs.getString("CITY");
            state = rs.getString("STATE");
            email = rs.getString("EMAIL");
            phone = rs.getString("PHONE");
            status = rs.getString("STATUS");
        }

    } catch(Exception e) {

        out.println("<h3>Error: " + e.getMessage() + "</h3>");

    } finally {

        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(ps != null) try { ps.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}

    }
%>

<!DOCTYPE html>
<html>

<head>

    <title>College Profile</title>

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
            margin: 20px auto;
            padding: 30px;
            width: 75%;
            border-radius: 12px;
            box-shadow: 0 2px 10px #ccc;
        }

        h2 {
            color: #2c4358;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #444;
        }

        input {
            width: 95%;
            padding: 12px;
            margin-top: 7px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }

        button {
            margin-top: 25px;
            padding: 12px 25px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #217dbb;
        }

        .status {
            margin-top: 20px;
            padding: 12px;
            background: #e8f5e9;
            color: green;
            border-radius: 5px;
            font-weight: bold;
        }

    </style>

</head>

<body>

<div class="header">
    College Profile
</div>


<div class="back">

    <a href="collegeAdminDashboard.jsp">
        ← Back to Dashboard
    </a>

</div>


<div class="box">

    <h2>Manage College Profile</h2>

    <form action="CollegeProfileController" method="post">

        <label>College Name</label>

        <input type="text"
               name="collegeName"
               value="<%=collegeName%>"
               required>


        <label>Address</label>

        <input type="text"
               name="address"
               value="<%=address%>"
               required>


        <label>City</label>

        <input type="text"
               name="city"
               value="<%=city%>"
               required>


        <label>State</label>

        <input type="text"
               name="state"
               value="<%=state%>"
               required>


        <label>Email</label>

        <input type="email"
               name="email"
               value="<%=email%>"
               required>


        <label>Phone</label>

        <input type="text"
               name="phone"
               value="<%=phone%>"
               required>


        <button type="submit">
            Update Profile
        </button>

    </form>


    <div class="status">
        Current Status: <%=status%>
    </div>

</div>

</body>

</html>