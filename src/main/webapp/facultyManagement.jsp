<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%

    Integer collegeId =
        (Integer) session.getAttribute("collegeId");

    if(collegeId == null)
    {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }

%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Faculty Management</title>


<style>

/* =========================================
   BASIC
========================================= */

* {
    box-sizing: border-box;
}


body {

    margin: 0;

    font-family: Arial, sans-serif;

    background: #f4f7fb;

    color: #183b5b;

}


/* =========================================
   HEADER
========================================= */

.header {

    background: linear-gradient(
        135deg,
        #07385e,
        #0d5b8f
    );

    color: white;

    padding: 22px 35px;

    display: flex;

    align-items: center;

    gap: 15px;

    box-shadow:
        0 3px 12px rgba(0,0,0,0.12);

}


.header-icon {

    width: 52px;

    height: 52px;

    border-radius: 13px;

    background: rgba(255,255,255,0.15);

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 28px;

}


.header h1 {

    margin: 0;

    font-size: 29px;

}


.header p {

    margin: 5px 0 0;

    font-size: 13px;

    color: #c9deec;

}


/* =========================================
   CONTAINER
========================================= */

.container {

    width: 94%;

    max-width: 1450px;

    margin: 25px auto 50px;

}


/* =========================================
   BACK
========================================= */

.back {

    margin-bottom: 20px;

}


.back a {

    display: inline-block;

    text-decoration: none;

    color: #1685ed;

    font-size: 15px;

    font-weight: bold;

    padding: 9px 14px;

    border-radius: 8px;

}


.back a:hover {

    background: #e8f4fc;

}


/* =========================================
   BOX
========================================= */

.box {

    background: white;

    margin-bottom: 22px;

    padding: 25px;

    border-radius: 16px;

    border: 1px solid #e1eaf1;

    box-shadow:
        0 5px 18px rgba(0,0,0,0.07);

}


/* =========================================
   BOX HEADER
========================================= */

.box-title {

    display: flex;

    align-items: center;

    gap: 10px;

    margin-bottom: 20px;

}


.box-title-icon {

    width: 42px;

    height: 42px;

    background: #eaf5ff;

    border-radius: 10px;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 22px;

}


.box-title h2 {

    margin: 0;

    color: #183f60;

    font-size: 22px;

}


/* =========================================
   ADD FACULTY FORM
========================================= */

.form-row {

    display: grid;

    grid-template-columns:
        1.2fr
        1.2fr
        1fr
        1.5fr
        auto;

    gap: 12px;

    align-items: center;

}


input,
select {

    width: 100%;

    padding: 12px 13px;

    border: 1px solid #d3dce4;

    border-radius: 8px;

    font-size: 14px;

    outline: none;

    background: white;

}


input:focus,
select:focus {

    border-color: #1685ed;

    box-shadow:
        0 0 0 3px rgba(22,133,237,0.10);

}


.add-btn {

    padding: 12px 20px;

    background: #1685ed;

    color: white;

    border: none;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    white-space: nowrap;

}


.add-btn:hover {

    background: #0874d1;

}


/* =========================================
   FORM NOTE
========================================= */

.form-note {

    margin-top: 13px;

    color: #7b8c98;

    font-size: 12px;

}


/* =========================================
   FACULTY LIST
========================================= */

.list-header {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 18px;

}


.list-header h2 {

    margin: 0;

    color: #183f60;

    font-size: 22px;

}


.college-id {

    color: #718493;

    font-size: 12px;

}


.college-id strong {

    color: #1685ed;

}


/* =========================================
   TABLE
========================================= */

.table-wrapper {

    width: 100%;

    overflow-x: auto;

}


table {

    width: 100%;

    min-width: 900px;

    border-collapse: collapse;

}


th {

    background: #0d78b5;

    color: white;

    padding: 15px 12px;

    font-size: 13px;

    text-align: center;

    white-space: nowrap;

}


td {

    padding: 15px 12px;

    border-bottom: 1px solid #edf1f4;

    text-align: center;

    font-size: 13px;

    color: #43596a;

}


tbody tr:hover {

    background: #f7fbfe;

}


tbody tr:last-child td {

    border-bottom: none;

}


/* =========================================
   FACULTY ID
========================================= */

.faculty-id {

    color: #1685ed;

    font-weight: bold;

}


/* =========================================
   FACULTY NAME
========================================= */

.faculty-name {

    color: #294b63;

    font-weight: bold;

}


/* =========================================
   EMAIL
========================================= */

.email {

    color: #61788a;

}


/* =========================================
   DEPARTMENT
========================================= */

.department {

    display: inline-block;

    padding: 7px 11px;

    background: #eef7ff;

    color: #176da5;

    border-radius: 15px;

    font-size: 11px;

    font-weight: bold;

}


/* =========================================
   DELETE
========================================= */

.delete {

    border: none;

    background: #e84c4c;

    color: white;

    padding: 8px 14px;

    border-radius: 6px;

    font-size: 12px;

    font-weight: bold;

    cursor: pointer;

}


.delete:hover {

    background: #c93737;

}


/* =========================================
   EMPTY
========================================= */

.no-data {

    padding: 60px 20px;

    text-align: center;

}


.no-data-icon {

    width: 65px;

    height: 65px;

    margin: auto;

    border-radius: 50%;

    background: #eaf5ff;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 30px;

}


.no-data h3 {

    margin: 15px 0 7px;

    color: #34546b;

}


.no-data p {

    margin: 0;

    color: #8494a0;

    font-size: 13px;

}


/* =========================================
   NOTE
========================================= */

.note {

    margin-top: 18px;

    padding: 14px 17px;

    background: #eff8ff;

    border-left: 4px solid #1685ed;

    border-radius: 8px;

    color: #627787;

    font-size: 12px;

    line-height: 1.6;

}


/* =========================================
   MOBILE
========================================= */

@media(max-width: 900px)
{

    .form-row {

        grid-template-columns: 1fr 1fr;

    }


    .add-btn {

        width: 100%;

    }

}


@media(max-width: 600px)
{

    .header {

        padding: 18px;

    }


    .header h1 {

        font-size: 22px;

    }


    .container {

        width: 94%;

    }


    .form-row {

        grid-template-columns: 1fr;

    }


    .list-header {

        display: block;

    }


    .college-id {

        margin-top: 8px;

    }

}

</style>

</head>


<body>


<!-- =========================================
     HEADER
========================================= -->

<div class="header">


    <div class="header-icon">

        &#128105;

    </div>


    <div>

        <h1>
            Faculty Management
        </h1>


        <p>
            Manage faculty members and departments
        </p>

    </div>


</div>



<!-- =========================================
     MAIN
========================================= -->

<div class="container">


    <!-- BACK -->

    <div class="back">

        <a href="collegeAdminDashboard.jsp">

            &#8592; Back to Dashboard

        </a>

    </div>



    <!-- =====================================
         ADD FACULTY
    ====================================== -->

    <div class="box">


        <div class="box-title">


            <div class="box-title-icon">

                &#10133;

            </div>


            <h2>

                Add Faculty

            </h2>


        </div>



        <form
            action="FacultyController"
            method="post"
        >


            <input
                type="hidden"
                name="action"
                value="add"
            >


            <div class="form-row">


                <!-- NAME -->

                <input
                    type="text"
                    name="name"
                    placeholder="Faculty Name"
                    required
                >


                <!-- EMAIL -->

                <input
                    type="email"
                    name="email"
                    placeholder="Email"
                    required
                >


                <!-- PHONE -->

                <input
                    type="text"
                    name="phone"
                    placeholder="Phone"
                    required
                >


                <!-- DEPARTMENT -->

                <select
                    name="departmentId"
                    required
                >


                    <option value="">

                        Select Department

                    </option>


        <%

            Connection con1 = null;

            PreparedStatement ps1 = null;

            ResultSet rs1 = null;


            try
            {

                Class.forName(
                    "oracle.jdbc.driver.OracleDriver"
                );


                con1 =
                    DriverManager.getConnection(

                        "jdbc:oracle:thin:@localhost:1521:XE",

                        "CAMPUSCONNECT",

                        "campus123"

                    );


                String sql1 =

                    "SELECT DEPARTMENT_ID, " +
                    "DEPARTMENT_NAME " +

                    "FROM DEPARTMENT " +

                    "WHERE COLLEGE_ID=? " +

                    "ORDER BY DEPARTMENT_NAME";


                ps1 =
                    con1.prepareStatement(sql1);


                ps1.setInt(
                    1,
                    collegeId
                );


                rs1 =
                    ps1.executeQuery();


                while(rs1.next())
                {

        %>


                    <option
                        value="<%=rs1.getInt("DEPARTMENT_ID")%>"
                    >

                        <%=rs1.getString("DEPARTMENT_NAME")%>

                    </option>


        <%

                }

            }
            catch(Exception e)
            {

        %>


                    <option value="">

                        Error loading departments

                    </option>


        <%

            }
            finally
            {

                if(rs1 != null)
                {
                    try
                    {
                        rs1.close();
                    }
                    catch(Exception e)
                    {
                    }
                }


                if(ps1 != null)
                {
                    try
                    {
                        ps1.close();
                    }
                    catch(Exception e)
                    {
                    }
                }


                if(con1 != null)
                {
                    try
                    {
                        con1.close();
                    }
                    catch(Exception e)
                    {
                    }
                }

            }

        %>


                </select>


                <!-- ADD BUTTON -->

                <button
                    type="submit"
                    class="add-btn"
                >

                    &#43; Add Faculty

                </button>


            </div>


        </form>


        <div class="form-note">

            &#128161;

            Enter faculty details and select the
            department before adding the faculty member.

        </div>


    </div>



    <!-- =====================================
         FACULTY LIST
    ====================================== -->

    <div class="box">


        <div class="list-header">


            <h2>

                &#128101; Faculty List

            </h2>


            <div class="college-id">

                College ID:

                <strong>
                    <%=collegeId%>
                </strong>

            </div>


        </div>



        <div class="table-wrapper">


        <%

            Connection con2 = null;

            PreparedStatement ps2 = null;

            ResultSet rs2 = null;


            try
            {

                Class.forName(
                    "oracle.jdbc.driver.OracleDriver"
                );


                con2 =
                    DriverManager.getConnection(

                        "jdbc:oracle:thin:@localhost:1521:XE",

                        "CAMPUSCONNECT",

                        "campus123"

                    );


                String sql2 =

                    "SELECT F.FACULTY_ID, " +
                    "F.NAME, " +
                    "F.EMAIL, " +
                    "F.PHONE, " +
                    "D.DEPARTMENT_NAME " +

                    "FROM FACULTY F " +

                    "LEFT JOIN DEPARTMENT D " +

                    "ON F.DEPARTMENT_ID=D.DEPARTMENT_ID " +

                    "WHERE F.COLLEGE_ID=? " +

                    "ORDER BY F.FACULTY_ID";


                ps2 =
                    con2.prepareStatement(sql2);


                ps2.setInt(
                    1,
                    collegeId
                );


                rs2 =
                    ps2.executeQuery();


                boolean found = false;

        %>


        <table>


            <thead>

                <tr>

                    <th>
                        Faculty ID
                    </th>

                    <th>
                        &#128100; Name
                    </th>

                    <th>
                        &#128231; Email
                    </th>

                    <th>
                        &#128222; Phone
                    </th>

                    <th>
                        &#127979; Department
                    </th>

                    <th>
                        Action
                    </th>

                </tr>

            </thead>


            <tbody>


        <%

                while(rs2.next())
                {

                    found = true;

        %>


                <tr>


                    <!-- FACULTY ID -->

                    <td>

                        <span class="faculty-id">

                            #<%=rs2.getInt("FACULTY_ID")%>

                        </span>

                    </td>



                    <!-- NAME -->

                    <td>

                        <span class="faculty-name">

                            <%=rs2.getString("NAME")%>

                        </span>

                    </td>



                    <!-- EMAIL -->

                    <td>

                        <span class="email">

                            <%=rs2.getString("EMAIL")%>

                        </span>

                    </td>



                    <!-- PHONE -->

                    <td>

                        <%=rs2.getString("PHONE")%>

                    </td>



                    <!-- DEPARTMENT -->

                    <td>

                        <span class="department">

                            &#127979;

                            <%=rs2.getString("DEPARTMENT_NAME")%>

                        </span>

                    </td>



                    <!-- DELETE -->

                    <td>


                        <form
                            action="FacultyController"
                            method="post"
                        >


                            <input
                                type="hidden"
                                name="action"
                                value="delete"
                            >


                            <input
                                type="hidden"
                                name="facultyId"
                                value="<%=rs2.getInt("FACULTY_ID")%>"
                            >


                            <button
                                type="submit"
                                class="delete"
                                onclick="return confirm('Are you sure you want to delete this faculty member?');"
                            >

                                &#10005; Delete

                            </button>


                        </form>


                    </td>


                </tr>


        <%

                }


                if(!found)
                {

        %>


                <tr>

                    <td colspan="6">


                        <div class="no-data">


                            <div class="no-data-icon">

                                &#128105;

                            </div>


                            <h3>

                                No Faculty Found

                            </h3>


                            <p>

                                No faculty members have been
                                added to this college yet.

                            </p>


                        </div>


                    </td>

                </tr>


        <%

                }

            }
            catch(Exception e)
            {

        %>


                <tr>

                    <td colspan="6">


                        <div class="no-data">


                            <div class="no-data-icon">

                                &#9888;

                            </div>


                            <h3>

                                Unable to Load Faculty

                            </h3>


                            <p>

                                Error:
                                <%=e.getMessage()%>

                            </p>


                        </div>


                    </td>

                </tr>


        <%

            }
            finally
            {

                if(rs2 != null)
                {
                    try
                    {
                        rs2.close();
                    }
                    catch(Exception e)
                    {
                    }
                }


                if(ps2 != null)
                {
                    try
                    {
                        ps2.close();
                    }
                    catch(Exception e)
                    {
                    }
                }


                if(con2 != null)
                {
                    try
                    {
                        con2.close();
                    }
                    catch(Exception e)
                    {
                    }
                }

            }

        %>


            </tbody>

        </table>


        </div>


    </div>



    <!-- =====================================
         NOTE
    ====================================== -->

    <div class="note">

        &#128161;

        <strong>Faculty Management:</strong>

        Faculty members are displayed according to
        the currently logged-in college.

    </div>


</div>


</body>

</html>