<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%

    Integer collegeId =
        (Integer) session.getAttribute("collegeId");

    String adminName =
        (String) session.getAttribute("adminName");


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

<title>Student Management</title>


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
   PAGE TITLE
========================================= */

.page-title {

    margin-bottom: 20px;

}


.page-title h2 {

    margin: 0;

    color: #183f60;

    font-size: 25px;

}


.page-title p {

    margin: 7px 0 0;

    color: #718493;

    font-size: 13px;

}


/* =========================================
   TABLE CARD
========================================= */

.card {

    background: white;

    border-radius: 16px;

    border: 1px solid #e1eaf1;

    box-shadow:
        0 5px 18px rgba(0,0,0,0.07);

    overflow: hidden;

}


/* =========================================
   CARD HEADER
========================================= */

.card-header {

    padding: 20px 23px;

    border-bottom: 1px solid #e8eef3;

    display: flex;

    justify-content: space-between;

    align-items: center;

}


.card-header h3 {

    margin: 0;

    font-size: 18px;

    color: #183f60;

}


.college-id {

    font-size: 12px;

    color: #718493;

}


.college-id strong {

    color: #1685ed;

}


/* =========================================
   TABLE WRAPPER
========================================= */

.table-wrapper {

    width: 100%;

    overflow-x: auto;

}


/* =========================================
   TABLE
========================================= */

table {

    width: 100%;

    min-width: 950px;

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
   STUDENT ID
========================================= */

.student-id {

    color: #1685ed;

    font-weight: bold;

}


/* =========================================
   STUDENT NAME
========================================= */

.student-name {

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
   COURSE
========================================= */

.course {

    display: inline-block;

    padding: 5px 9px;

    background: #eef7ff;

    color: #1685ed;

    border-radius: 12px;

    font-size: 11px;

    font-weight: bold;

}


/* =========================================
   GENDER
========================================= */

.gender {

    color: #526979;

}


/* =========================================
   STATUS
========================================= */

.status {

    display: inline-block;

    padding: 6px 12px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;

}


.active {

    background: #e6f8ed;

    color: #159447;

}


.inactive {

    background: #ffe8e8;

    color: #d33b3b;

}


/* =========================================
   EMPTY DATA
========================================= */

.no-data {

    padding: 65px 20px;

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

@media(max-width: 700px)
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


    .card-header {

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

        &#127891;

    </div>


    <div>

        <h1>
            Student Management
        </h1>


        <p>
            Manage and view students of your college
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



    <!-- PAGE TITLE -->

    <div class="page-title">

        <h2>

            &#128101; Students of Your College

        </h2>


        <p>

            View student information, academic course and account status.

        </p>

    </div>



    <!-- =====================================
         CARD
    ====================================== -->

    <div class="card">


        <div class="card-header">


            <h3>

                &#127891; Student Directory

            </h3>


            <div class="college-id">

                College ID:

                <strong>
                    <%=collegeId%>
                </strong>

            </div>


        </div>



        <!-- TABLE -->

        <div class="table-wrapper">


        <%

            Connection con = null;

            PreparedStatement ps = null;

            ResultSet rs = null;


            try
            {

                Class.forName(
                    "oracle.jdbc.driver.OracleDriver"
                );


                con = DriverManager.getConnection(

                    "jdbc:oracle:thin:@localhost:1521:XE",

                    "CAMPUSCONNECT",

                    "campus123"

                );


                String sql =

                    "SELECT STUDENT_ID, NAME, EMAIL, PHONE, " +
                    "COURSE_ID, GENDER, STATUS " +

                    "FROM STUDENT " +

                    "WHERE COLLEGE_ID=? " +

                    "ORDER BY STUDENT_ID";


                ps = con.prepareStatement(sql);


                ps.setInt(
                    1,
                    collegeId.intValue()
                );


                rs = ps.executeQuery();


                boolean found = false;

        %>


        <table>


            <thead>

                <tr>

                    <th>
                        Student ID
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
                        &#128218; Course
                    </th>

                    <th>
                        &#9794;&#65039; Gender
                    </th>

                    <th>
                        Status
                    </th>

                </tr>

            </thead>


            <tbody>


        <%

                while(rs.next())
                {

                    found = true;


                    String status =
                        rs.getString("STATUS");

        %>


                <tr>


                    <!-- STUDENT ID -->

                    <td>

                        <span class="student-id">

                            #<%=rs.getInt("STUDENT_ID")%>

                        </span>

                    </td>



                    <!-- NAME -->

                    <td>

                        <span class="student-name">

                            <%=rs.getString("NAME")%>

                        </span>

                    </td>



                    <!-- EMAIL -->

                    <td>

                        <span class="email">

                            <%=rs.getString("EMAIL")%>

                        </span>

                    </td>



                    <!-- PHONE -->

                    <td>

                        <%=rs.getString("PHONE")%>

                    </td>



                    <!-- COURSE -->

                    <td>

                        <span class="course">

                            &#128218;

                            Course
                            <%=rs.getInt("COURSE_ID")%>

                        </span>

                    </td>



                    <!-- GENDER -->

                    <td>

                        <span class="gender">

                            <%=rs.getString("GENDER")%>

                        </span>

                    </td>



                    <!-- STATUS -->

                    <td>


                        <%

                            if("ACTIVE".equalsIgnoreCase(status))
                            {

                        %>

                            <span class="status active">

                                &#10003; ACTIVE

                            </span>

                        <%

                            }
                            else
                            {

                        %>

                            <span class="status inactive">

                                &#10007; <%=status%>

                            </span>

                        <%

                            }

                        %>


                    </td>


                </tr>


        <%

                }


                if(!found)
                {

        %>


                <tr>

                    <td colspan="7">


                        <div class="no-data">


                            <div class="no-data-icon">

                                &#128101;

                            </div>


                            <h3>

                                No Students Found

                            </h3>


                            <p>

                                No students are currently
                                registered under this college.

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

                    <td colspan="7">


                        <div class="no-data">


                            <div class="no-data-icon">

                                &#9888;

                            </div>


                            <h3>

                                Unable to Load Students

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

                if(rs != null)
                {
                    try
                    {
                        rs.close();
                    }
                    catch(Exception e)
                    {
                    }
                }


                if(ps != null)
                {
                    try
                    {
                        ps.close();
                    }
                    catch(Exception e)
                    {
                    }
                }


                if(con != null)
                {
                    try
                    {
                        con.close();
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

        <strong>Student Management:</strong>

        This section displays students belonging to the
        currently logged-in college.

    </div>


</div>


</body>

</html>