<%@ page import="java.sql.*" %>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>College Details | CampusConnect</title>


<style>

/* =========================
   GLOBAL
========================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {

    background:
        radial-gradient(
            circle at 10% 5%,
            rgba(37,99,235,0.08),
            transparent 28%
        ),
        radial-gradient(
            circle at 90% 10%,
            rgba(14,165,233,0.07),
            transparent 25%
        ),
        #f5f8fc;

    color: #26364f;
}


/* =========================
   HEADER
========================= */

.header {

    position: sticky;
    top: 0;

    z-index: 100;

    background:
        linear-gradient(
            135deg,
            #091b3d,
            #123c88,
            #1769e0
        );

    color: white;

    padding: 17px 7%;

    display: flex;

    justify-content: space-between;

    align-items: center;

    box-shadow:
        0 8px 30px rgba(5,20,50,0.18);
}

.logo {

    font-size: 27px;

    font-weight: bold;

    letter-spacing: -0.5px;
}

.logo span {

    color: #a9d0ff;
}

.back-btn-top {

    color: white;

    text-decoration: none;

    border: 1px solid
        rgba(255,255,255,0.65);

    padding: 10px 17px;

    border-radius: 8px;

    font-size: 14px;

    background:
        rgba(255,255,255,0.06);

    transition: 0.25s;
}

.back-btn-top:hover {

    background: white;

    color: #123c88;

    transform: translateY(-1px);
}


/* =========================
   MAIN
========================= */

.container {

    width: 90%;

    max-width: 1180px;

    margin: 42px auto 70px;
}


/* =========================
   TITLE
========================= */

.page-title {

    text-align: center;

    margin-bottom: 30px;
}

.page-title h1 {

    color: #173c76;

    font-size: 40px;

    margin-bottom: 10px;

    letter-spacing: -1px;
}

.page-title p {

    color: #718096;

    font-size: 15px;
}


/* =========================
   COLLEGE CARD
========================= */

.college-card {

    background: white;

    border-radius: 22px;

    overflow: hidden;

    border:
        1px solid rgba(148,163,184,0.22);

    box-shadow:
        0 20px 55px
        rgba(15,45,90,0.12);
}


/* =========================
   COLLEGE TOP
========================= */

.college-top {

    display: flex;

    min-height: 350px;
}


/* =========================
   IMAGE
========================= */

.college-image {

    position: relative;

    width: 48%;

    min-height: 350px;

    background: #dbeafe;

    overflow: hidden;
}

.college-image > img {

    width: 100%;

    height: 100%;

    min-height: 350px;

    object-fit: cover;

    transition: 0.5s;
}

.college-card:hover
.college-image > img {

    transform: scale(1.03);
}


/* =========================
   FLOATING LOGO
========================= */

.floating-logo {

    position: absolute;

    left: 28px;

    bottom: 25px;

    z-index: 5;

    width: 92px;

    height: 92px;

    padding: 7px;

    background: white;

    border-radius: 18px;

    border:
        1px solid rgba(255,255,255,0.9);

    box-shadow:
        0 12px 30px rgba(0,0,0,0.20);
}

.floating-logo img {

    width: 100%;

    height: 100%;

    object-fit: contain;

    border-radius: 12px;
}


/* =========================
   COLLEGE BASIC
========================= */

.college-basic {

    width: 52%;

    padding: 48px;

    display: flex;

    flex-direction: column;

    justify-content: center;

    background:
        radial-gradient(
            circle at 100% 0%,
            rgba(37,99,235,0.06),
            transparent 35%
        ),
        white;
}

.college-basic h2 {

    color: #173c76;

    font-size: 34px;

    line-height: 1.3;

    margin-bottom: 15px;

    letter-spacing: -0.7px;
}

.location {

    width: fit-content;

    color: #68778d;

    font-size: 15px;

    margin-bottom: 20px;

    padding: 9px 13px;

    border-radius: 10px;

    background: #f4f7fb;

    border:
        1px solid #e4eaf2;
}

.available {

    width: fit-content;

    background: #e9f8ef;

    color: #21854b;

    padding: 9px 15px;

    border-radius: 20px;

    font-size: 12px;

    font-weight: bold;

    box-shadow:
        0 5px 14px
        rgba(33,133,75,0.10);
}


/* =========================
   SECTION
========================= */

.section {

    background: white;

    margin-top: 22px;

    padding: 31px;

    border-radius: 18px;

    border:
        1px solid #e2e8f0;

    box-shadow:
        0 12px 35px
        rgba(20,50,90,0.06);

    transition: 0.2s;
}

.section:hover {

    transform: translateY(-1px);

    box-shadow:
        0 15px 40px
        rgba(20,50,90,0.09);
}

.section h3 {

    color: #173c76;

    font-size: 20px;

    margin-bottom: 20px;

    display: flex;

    align-items: center;

    gap: 10px;
}

.section h3::before {

    content: "";

    width: 4px;

    height: 22px;

    border-radius: 10px;

    background:
        linear-gradient(
            180deg,
            #1769e0,
            #49a5ff
        );
}


/* =========================
   INFO GRID
========================= */

.info-grid {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 15px;
}

.info-box {

    background: #f7faff;

    border:
        1px solid #e2e9f3;

    padding: 17px;

    border-radius: 10px;

    transition: 0.2s;
}

.info-box:hover {

    border-color: #b9d3f7;

    background: #f2f7ff;

    transform: translateY(-2px);
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

    font-weight: 600;

    word-break: break-word;
}


/* =========================
   ADDRESS
========================= */

.address-box {

    background: #f7faff;

    border:
        1px solid #e2e9f3;

    padding: 18px;

    border-radius: 10px;

    color: #344b68;

    font-size: 14px;

    line-height: 1.6;
}


/* =========================
   COURSES
========================= */

.course-list {

    display: grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap: 12px;
}

.course-item {

    background: #f7faff;

    border:
        1px solid #e2e9f3;

    padding: 15px;

    border-radius: 10px;

    color: #344b68;

    font-size: 14px;

    transition: 0.2s;
}

.course-item:hover {

    background: #f2f7ff;

    border-color: #b9d3f7;

    transform: translateY(-2px);
}


/* =========================
   DEPARTMENTS
========================= */

.department-list {

    display: grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap: 12px;
}

.department-item {

    background: #f7faff;

    border:
        1px solid #e2e9f3;

    padding: 15px;

    border-radius: 10px;

    color: #344b68;

    font-size: 14px;

    transition: 0.2s;
}

.department-item:hover {

    background: #f2f7ff;

    border-color: #b9d3f7;

    transform: translateY(-2px);
}


/* =========================
   ACTIONS
========================= */

.actions {

    background:
        rgba(255,255,255,0.96);

    margin-top: 22px;

    padding: 17px;

    border-radius: 16px;

    border:
        1px solid #e2e8f0;

    display: flex;

    gap: 15px;

    position: sticky;

    bottom: 15px;

    z-index: 20;

    box-shadow:
        0 15px 40px
        rgba(15,45,90,0.14);
}

.select-btn {

    flex: 1;

    text-align: center;

    text-decoration: none;

    background:
        linear-gradient(
            135deg,
            #1769e0,
            #1258c4
        );

    color: white;

    padding: 14px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    box-shadow:
        0 8px 20px
        rgba(23,105,224,0.22);

    transition: 0.22s;
}

.select-btn:hover {

    transform: translateY(-2px);

    box-shadow:
        0 12px 25px
        rgba(23,105,224,0.28);
}

.back-btn {

    flex: 1;

    text-align: center;

    text-decoration: none;

    background: white;

    color: #1769e0;

    border:
        1px solid #1769e0;

    padding: 14px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    transition: 0.22s;
}

.back-btn:hover {

    background: #f1f6ff;

    transform: translateY(-2px);
}


/* =========================
   ERROR
========================= */

.error-box {

    background: white;

    padding: 50px;

    text-align: center;

    border-radius: 18px;

    border:
        1px solid #e2e8f0;

    box-shadow:
        0 12px 35px
        rgba(30,60,100,0.08);
}

.error-box h2 {

    color: #c0392b;

    margin-bottom: 10px;
}

.error-box p {

    color: #718096;

    margin-bottom: 20px;
}


/* =========================
   FOOTER
========================= */

.footer {

    margin-top: 60px;

    background: #091b3d;

    color: #dceaff;

    text-align: center;

    padding: 24px;

    font-size: 13px;
}


/* =========================
   RESPONSIVE
========================= */

@media(max-width: 800px) {

    .college-top {

        flex-direction: column;
    }

    .college-image {

        width: 100%;

        height: 245px;

        min-height: 245px;
    }

    .college-image > img {

        min-height: 245px;
    }

    .college-basic {

        width: 100%;

        padding: 30px 24px;
    }

    .info-grid {

        grid-template-columns: 1fr;
    }

    .course-list {

        grid-template-columns:
            1fr 1fr;
    }

    .department-list {

        grid-template-columns:
            1fr 1fr;
    }

    .actions {

        position: static;

        flex-direction: column;
    }

    .floating-logo {

        width: 74px;

        height: 74px;

        left: 18px;

        bottom: 17px;
    }
}


@media(max-width: 520px) {

    .header {

        padding: 14px 5%;
    }

    .logo {

        font-size: 23px;
    }

    .back-btn-top {

        padding: 8px 11px;

        font-size: 12px;
    }

    .container {

        width: 92%;

        margin-top: 28px;
    }

    .page-title h1 {

        font-size: 30px;
    }

    .course-list,
    .department-list {

        grid-template-columns: 1fr;
    }

    .college-basic h2 {

        font-size: 27px;
    }

    .section {

        padding: 24px 20px;
    }
}

</style>

</head>


<body>


<!-- =========================
     HEADER
========================= -->

<div class="header">

    <div class="logo">

        Campus<span>Connect</span>

    </div>


    <a href="new_student_colleges.jsp"
       class="back-btn-top">

        Back to Colleges

    </a>

</div>



<!-- =========================
     MAIN
========================= -->

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

        "PHONE, " +

        "LOGO_IMAGE, " +

        "COVER_IMAGE " +

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


<!-- =========================
     PAGE TITLE
========================= -->

<div class="page-title">

    <h1>
        College Details
    </h1>

    <p>
        Explore the college information before applying.
    </p>

</div>



<!-- =========================
     COLLEGE HEADER
========================= -->

<div class="college-card">


    <div class="college-top">


<%

String logoImage =
    rs.getString("LOGO_IMAGE");

String coverImage =
    rs.getString("COVER_IMAGE");


String logoPath =
    request.getContextPath()
    + "/images/college-logo.png";


String coverPath =
    request.getContextPath()
    + "/image/college-banner.png";


if(logoImage != null &&
   !logoImage.trim().equals(""))
{

    logoPath =
        request.getContextPath()
        + "/college_images/"
        + logoImage;
}


if(coverImage != null &&
   !coverImage.trim().equals(""))
{

    coverPath =
        request.getContextPath()
        + "/college_images/"
        + coverImage;
}

%>


        <!-- COLLEGE IMAGE -->

        <div class="college-image">

            <img src="<%=coverPath%>"
                 alt="College Cover Image">


            <!-- FLOATING LOGO -->

            <div class="floating-logo">

                <img src="<%=logoPath%>"
                     alt="College Logo">

            </div>

        </div>



        <!-- COLLEGE BASIC -->

        <div class="college-basic">

            <h2>

                <%=rs.getString(
                    "COLLEGE_NAME"
                )%>

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



<!-- =========================
     INFORMATION
========================= -->

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

                <%=rs.getInt(
                    "COLLEGE_ID"
                )%>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                College Name
            </span>

            <span class="info-value">

                <%=rs.getString(
                    "COLLEGE_NAME"
                )%>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                City
            </span>

            <span class="info-value">

                <%=rs.getString(
                    "CITY"
                )%>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                State
            </span>

            <span class="info-value">

                <%=rs.getString(
                    "STATE"
                )%>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                Email
            </span>

            <span class="info-value">

                <%=rs.getString(
                    "EMAIL"
                )%>

            </span>

        </div>



        <div class="info-box">

            <span class="info-label">
                Phone
            </span>

            <span class="info-value">

                <%=rs.getString(
                    "PHONE"
                )%>

            </span>

        </div>


    </div>

</div>



<!-- =========================
     ADDRESS
========================= -->

<div class="section">

    <h3>
        College Address
    </h3>


    <div class="address-box">

        <%=rs.getString(
            "ADDRESS"
        )%>,

        <%=rs.getString(
            "CITY"
        )%>,

        <%=rs.getString(
            "STATE"
        )%>

    </div>

</div>



<!-- =========================
     COURSES
========================= -->

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


    rsCourse =
        psCourse.executeQuery();


    boolean courseFound = false;


    while(rsCourse.next())
    {

        courseFound = true;

%>


        <div class="course-item">

            <%=rsCourse.getString(
                "COURSE_NAME"
            )%>

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



<!-- =========================
     DEPARTMENTS
========================= -->

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



<!-- =========================
     ACTIONS
========================= -->

<div class="actions">


    <a
        href="new_student_admission_request.jsp?collegeId=<%=rs.getInt("COLLEGE_ID")%>"
        class="select-btn">

        Select This College

    </a>


    <a
        href="new_student_colleges.jsp"
        class="back-btn">

        Back to Colleges

    </a>


</div>


<%

    }

    else
    {

%>


<!-- =========================
     NOT FOUND
========================= -->

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

        This college is not currently
        available for admission.

    </p>


    <a
        href="new_student_colleges.jsp"
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


<!-- =========================
     DATABASE ERROR
========================= -->

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



<!-- =========================
     FOOTER
========================= -->

<div class="footer">

    CampusConnect |

    Campus Recruitment Management System

</div>


</body>

</html>