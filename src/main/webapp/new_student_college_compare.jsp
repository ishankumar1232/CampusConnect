<%@ page import="java.sql.*" %>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>College Details | CampusConnect</title>


<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    background: #f4f7fb;
    color: #26364f;
}


/* HEADER */

.header {
    background: linear-gradient(135deg, #123c88, #1769e0);

    color: white;

    padding: 20px 7%;

    display: flex;

    justify-content: space-between;

    align-items: center;
}

.logo {
    font-size: 27px;
    font-weight: bold;
}

.logo span {
    color: #a9d0ff;
}

.back-btn-top {
    color: white;

    text-decoration: none;

    border: 1px solid rgba(255,255,255,0.7);

    padding: 10px 17px;

    border-radius: 7px;

    font-size: 14px;
}


/* MAIN */

.container {
    width: 90%;

    max-width: 1100px;

    margin: 45px auto;
}


/* TITLE */

.page-title {
    text-align: center;

    margin-bottom: 30px;
}

.page-title h1 {
    color: #173c76;

    font-size: 36px;

    margin-bottom: 10px;
}

.page-title p {
    color: #718096;

    font-size: 15px;
}


/* COLLEGE CARD */

.college-card {
    background: white;

    border-radius: 18px;

    overflow: hidden;

    border: 1px solid #e2e8f0;

    box-shadow:
    0 10px 30px rgba(30,60,100,0.10);
}


/* COLLEGE TOP */

.college-top {
    display: flex;

    min-height: 300px;
}


/* IMAGE */

.college-image {
    width: 42%;

    background: #e7f0ff;
}

.college-image img {
    width: 100%;

    height: 100%;

    min-height: 300px;

    object-fit: cover;
}


/* BASIC */

.college-basic {
    width: 58%;

    padding: 40px;

    display: flex;

    flex-direction: column;

    justify-content: center;
}

.college-basic h2 {
    color: #173c76;

    font-size: 30px;

    line-height: 1.3;

    margin-bottom: 15px;
}

.location {
    color: #68778d;

    font-size: 16px;

    margin-bottom: 20px;
}

.available {
    width: fit-content;

    background: #e9f8ef;

    color: #21854b;

    padding: 8px 15px;

    border-radius: 20px;

    font-size: 12px;

    font-weight: bold;
}


/* SECTION */

.section {
    background: white;

    margin-top: 25px;

    padding: 30px 35px;

    border-radius: 15px;

    border: 1px solid #e2e8f0;

    box-shadow:
    0 7px 25px rgba(30,60,100,0.07);
}

.section h3 {
    color: #173c76;

    font-size: 21px;

    margin-bottom: 20px;
}


/* INFO GRID */

.info-grid {
    display: grid;

    grid-template-columns: 1fr 1fr;

    gap: 15px;
}

.info-box {
    background: #f7faff;

    border: 1px solid #e2e9f3;

    padding: 17px;

    border-radius: 9px;
}

.info-label {
    display: block;

    color: #8995a7;

    font-size: 12px;

    margin-bottom: 7px;
}

.info-value {
    color: #344b68;

    font-size: 14px;

    word-break: break-word;
}


/* ADDRESS */

.address-box {
    background: #f7faff;

    border: 1px solid #e2e9f3;

    padding: 18px;

    border-radius: 9px;

    color: #344b68;

    font-size: 14px;

    line-height: 1.6;
}


/* COURSES */

.course-list {
    display: grid;

    grid-template-columns:
    repeat(3, 1fr);

    gap: 12px;
}

.course-item {
    background: #f7faff;

    border: 1px solid #e2e9f3;

    padding: 15px;

    border-radius: 8px;

    color: #344b68;

    font-size: 14px;
}


/* DEPARTMENTS */

.department-list {
    display: grid;

    grid-template-columns:
    repeat(3, 1fr);

    gap: 12px;
}

.department-item {
    background: #f7faff;

    border: 1px solid #e2e9f3;

    padding: 15px;

    border-radius: 8px;

    color: #344b68;

    font-size: 14px;
}


/* ACTION */

.actions {
    background: white;

    margin-top: 25px;

    padding: 25px 35px;

    border-radius: 15px;

    border: 1px solid #e2e8f0;

    display: flex;

    gap: 15px;
}

.select-btn {
    flex: 1;

    text-align: center;

    text-decoration: none;

    background: #1769e0;

    color: white;

    padding: 14px;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;
}

.select-btn:hover {
    background: #0d54bd;
}

.back-btn {
    flex: 1;

    text-align: center;

    text-decoration: none;

    background: white;

    color: #1769e0;

    border: 1px solid #1769e0;

    padding: 14px;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;
}


/* ERROR */

.error-box {
    background: white;

    padding: 50px;

    text-align: center;

    border-radius: 15px;

    box-shadow:
    0 8px 25px rgba(30,60,100,0.08);
}

.error-box h2 {
    color: #c0392b;

    margin-bottom: 10px;
}

.error-box p {
    color: #718096;

    margin-bottom: 20px;
}


/* FOOTER */

.footer {
    margin-top: 60px;

    background: #123c88;

    color: #dceaff;

    text-align: center;

    padding: 20px;

    font-size: 13px;
}


/* RESPONSIVE */

@media(max-width: 800px) {

    .college-top {
        flex-direction: column;
    }

    .college-image {
        width: 100%;
        height: 230px;
    }

    .college-image img {
        min-height: 230px;
    }

    .college-basic {
        width: 100%;
    }

    .info-grid {
        grid-template-columns: 1fr;
    }

    .course-list {
        grid-template-columns: 1fr 1fr;
    }

    .department-list {
        grid-template-columns: 1fr 1fr;
    }

    .actions {
        flex-direction: column;
    }

}

</style>

</head>


<body>


<!-- HEADER -->

<div class="header">

    <div class="logo">

        Campus<span>Connect</span>

    </div>


    <a href="new_student_colleges.jsp"
       class="back-btn-top">

        Back to Colleges

    </a>

</div>



<!-- MAIN -->

<div class="container">


<%

String collegeId =
request.getParameter("collegeId");


if(collegeId == null ||
   collegeId.trim().equals(""))
{

%>


<div class="page-title">

    <h1>
        College Details
    </h1>

    <p>
        Explore the college information before applying.
    </p>

</div>


<div class="error-box">

    <h2>
        Invalid College
    </h2>

    <p>
        No college was selected.
    </p>


    <a href="new_student_colleges.jsp"
       class="back-btn">

        Back to Available Colleges

    </a>

</div>


<%

}
else
{

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

        "SELECT COLLEGE_ID, " +
        "COLLEGE_NAME, " +
        "ADDRESS, " +
        "CITY, " +
        "STATE, " +
        "EMAIL, " +
        "PHONE " +
        "FROM COLLEGE " +
        "WHERE COLLEGE_ID = ? " +
        "AND STATUS = 'APPROVED'";


    ps = con.prepareStatement(sql);


    ps.setInt(
        1,
        Integer.parseInt(collegeId)
    );


    rs = ps.executeQuery();


    if(rs.next())
    {

%>


<!-- TITLE -->

<div class="page-title">

    <h1>
        College Details
    </h1>

    <p>
        Explore the college information before applying.
    </p>

</div>



<!-- COLLEGE HEADER -->

<div class="college-card">


    <div class="college-top">


        <div class="college-image">

            <img src="images/college-default.jpg"
                 alt="College Image">

        </div>


        <div class="college-basic">

            <h2>

                <%=rs.getString("COLLEGE_NAME")%>

            </h2>


            <div class="location">

                <%=rs.getString("CITY")%>,

                <%=rs.getString("STATE")%>

            </div>


            <span class="available">

                Available for Admission

            </span>

        </div>


    </div>


</div>



<!-- INFORMATION -->

<div class="section">

    <h3>
        College Information
    </h3>


    <div class="info-grid">


        <div class="info-box">

            <span class="info-label">
                College ID
            </span>

            <span class="info-value">

                <%=rs.getInt("COLLEGE_ID")%>

            </span>

        </div>


        <div class="info-box">

            <span class="info-label">
                College Name
            </span>

            <span class="info-value">

                <%=rs.getString("COLLEGE_NAME")%>

            </span>

        </div>


        <div class="info-box">

            <span class="info-label">
                City
            </span>

            <span class="info-value">

                <%=rs.getString("CITY")%>

            </span>

        </div>


        <div class="info-box">

            <span class="info-label">
                State
            </span>

            <span class="info-value">

                <%=rs.getString("STATE")%>

            </span>

        </div>


        <div class="info-box">

            <span class="info-label">
                Email
            </span>

            <span class="info-value">

                <%=rs.getString("EMAIL")%>

            </span>

        </div>


        <div class="info-box">

            <span class="info-label">
                Phone
            </span>

            <span class="info-value">

                <%=rs.getString("PHONE")%>

            </span>

        </div>


    </div>

</div>



<!-- ADDRESS -->

<div class="section">

    <h3>
        College Address
    </h3>


    <div class="address-box">

        <%=rs.getString("ADDRESS")%>,

        <%=rs.getString("CITY")%>,

        <%=rs.getString("STATE")%>

    </div>

</div>



<!-- COURSES -->

<div class="section">

    <h3>
        Available Courses
    </h3>


    <div class="course-list">


<%

PreparedStatement psCourse = null;

ResultSet rsCourse = null;


try
{

    psCourse = con.prepareStatement(

        "SELECT COURSE_ID, COURSE_NAME " +
        "FROM COURSE " +
        "ORDER BY COURSE_NAME"

    );


    rsCourse = psCourse.executeQuery();


    boolean courseFound = false;


    while(rsCourse.next())
    {

        courseFound = true;

%>


        <div class="course-item">

            <%=rsCourse.getString("COURSE_NAME")%>

        </div>


<%

    }


    if(!courseFound)
    {

%>


        <div class="course-item">

            No courses available.

        </div>


<%

    }

}
finally
{

    if(rsCourse != null)
        rsCourse.close();

    if(psCourse != null)
        psCourse.close();

}

%>


    </div>

</div>



<!-- DEPARTMENTS -->

<div class="section">

    <h3>
        Departments
    </h3>


    <div class="department-list">


<%

PreparedStatement psDepartment = null;

ResultSet rsDepartment = null;


try
{

    psDepartment = con.prepareStatement(

        "SELECT DEPARTMENT_ID, DEPARTMENT_NAME " +
        "FROM DEPARTMENT " +
        "ORDER BY DEPARTMENT_NAME"

    );


    rsDepartment =
    psDepartment.executeQuery();


    boolean departmentFound = false;


    while(rsDepartment.next())
    {

        departmentFound = true;

%>


        <div class="department-item">

            <%=rsDepartment.getString(
                "DEPARTMENT_NAME"
            )%>

        </div>


<%

    }


    if(!departmentFound)
    {

%>


        <div class="department-item">

            No departments available.

        </div>


<%

    }

}
finally
{

    if(rsDepartment != null)
        rsDepartment.close();

    if(psDepartment != null)
        psDepartment.close();

}

%>


    </div>

</div>



<!-- ACTIONS -->

<div class="actions">


    <a href="new_student_admission_request.jsp?collegeId=<%=rs.getInt("COLLEGE_ID")%>"
       class="select-btn">

        Select This College

    </a>


    <a href="new_student_colleges.jsp"
       class="back-btn">

        Back to Colleges

    </a>


</div>


<%

    }
    else
    {

%>


<div class="page-title">

    <h1>
        College Details
    </h1>

</div>


<div class="error-box">

    <h2>
        College Not Found
    </h2>

    <p>
        This college is not currently available
        for admission.
    </p>


    <a href="new_student_colleges.jsp"
       class="back-btn">

        Back to Available Colleges

    </a>

</div>


<%

    }

}
catch(Exception e)
{

%>


<div class="error-box">

    <h2>
        Database Error
    </h2>

    <p>
        <%=e.getMessage()%>
    </p>

</div>


<%

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


</div>



<!-- FOOTER -->

<div class="footer">

    CampusConnect |
    Campus Recruitment Management System

</div>


</body>

</html>