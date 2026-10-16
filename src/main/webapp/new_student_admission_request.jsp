<%@ page import="java.sql.*" %>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String collegeId = request.getParameter("collegeId");

    if (collegeId == null || collegeId.trim().equals("")) {
        response.sendRedirect("new_student_colleges.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String collegeName = "";
    String city = "";
    String state = "";

    try {

        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        ps = con.prepareStatement(
            "SELECT COLLEGE_NAME, CITY, STATE " +
            "FROM COLLEGE " +
            "WHERE COLLEGE_ID = ? " +
            "AND STATUS = 'APPROVED'"
        );

        ps.setInt(1, Integer.parseInt(collegeId));

        rs = ps.executeQuery();

        if (rs.next()) {

            collegeName = rs.getString("COLLEGE_NAME");
            city = rs.getString("CITY");
            state = rs.getString("STATE");

        } else {

            response.sendRedirect("new_student_colleges.jsp");
            return;
        }

    } catch (Exception e) {

        out.println("Error: " + e);

    } finally {

        try {

            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();

        } catch (Exception e) {

        }
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Admission Request | CampusConnect</title>


<style>

/* =========================================
   GLOBAL
========================================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {

    min-height: 100vh;

    background:
        radial-gradient(
            circle at 8% 5%,
            rgba(37,99,235,0.09),
            transparent 28%
        ),
        radial-gradient(
            circle at 92% 12%,
            rgba(14,165,233,0.08),
            transparent 26%
        ),
        #f5f8fc;

    color: #26364f;
}


/* =========================================
   HEADER
========================================= */

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
        0 8px 30px
        rgba(5,20,50,0.18);
}

.logo {

    font-size: 27px;

    font-weight: bold;

    letter-spacing: -0.5px;
}

.logo span {

    color: #a9d0ff;
}

.back-btn {

    color: white;

    text-decoration: none;

    border:
        1px solid
        rgba(255,255,255,0.65);

    padding: 10px 17px;

    border-radius: 8px;

    font-size: 14px;

    background:
        rgba(255,255,255,0.06);

    transition: 0.25s;
}

.back-btn:hover {

    background: white;

    color: #123c88;

    transform: translateY(-1px);
}


/* =========================================
   MAIN
========================================= */

.container {

    width: 90%;

    max-width: 1050px;

    margin: 42px auto 70px;
}


/* =========================================
   PAGE TITLE
========================================= */

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


/* =========================================
   SELECTED COLLEGE
========================================= */

.college-card {

    position: relative;

    background: white;

    border-radius: 20px;

    border:
        1px solid
        rgba(148,163,184,0.22);

    box-shadow:
        0 16px 45px
        rgba(15,45,90,0.09);

    padding: 28px;

    margin-bottom: 24px;

    overflow: hidden;
}

.college-card::before {

    content: "";

    position: absolute;

    top: 0;
    left: 0;
    right: 0;

    height: 4px;

    background:
        linear-gradient(
            90deg,
            #1769e0,
            #49a5ff
        );
}

.section-title {

    color: #173c76;

    font-size: 21px;

    margin-bottom: 18px;

    display: flex;

    align-items: center;

    gap: 10px;
}

.section-title::before {

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


/* =========================================
   COLLEGE INFO
========================================= */

.college-info {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 15px;
}

.info-box {

    background:
        linear-gradient(
            135deg,
            #f8fbff,
            #f3f7fd
        );

    border:
        1px solid #e2e9f3;

    padding: 17px;

    border-radius: 11px;

    transition: 0.22s;
}

.info-box:hover {

    border-color: #b9d3f7;

    background: #f1f6ff;

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

    font-size: 15px;

    font-weight: bold;

    word-break: break-word;
}


/* =========================================
   ADMISSION FORM
========================================= */

.form-card {

    background: white;

    border-radius: 20px;

    border:
        1px solid
        rgba(148,163,184,0.22);

    box-shadow:
        0 16px 45px
        rgba(15,45,90,0.09);

    padding: 32px;
}

.form-description {

    color: #718096;

    font-size: 14px;

    margin-bottom: 26px;

    line-height: 1.6;
}


/* =========================================
   FORM GRID
========================================= */

.form-grid {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 20px;
}

.form-group {

    display: flex;

    flex-direction: column;
}

.form-group.full {

    grid-column: 1 / -1;
}

.form-group label {

    color: #344b68;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 8px;
}

.required {

    color: #e53935;
}


/* =========================================
   INPUTS
========================================= */

.form-group input,
.form-group select,
.form-group textarea {

    width: 100%;

    padding: 13px 14px;

    border:
        1px solid #d6dfeb;

    border-radius: 9px;

    outline: none;

    font-size: 14px;

    background: #fbfdff;

    color: #344b68;

    transition: 0.22s;
}

.form-group input:hover,
.form-group select:hover {

    border-color: #b9cce4;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {

    border-color: #1769e0;

    background: white;

    box-shadow:
        0 0 0 3px
        rgba(23,105,224,0.10);
}

.form-group textarea {

    resize: vertical;

    min-height: 100px;
}


/* =========================================
   COURSE SELECT
========================================= */

.course-select {

    cursor: pointer;
}


/* =========================================
   NOTE
========================================= */

.note {

    margin-top: 22px;

    background:
        linear-gradient(
            135deg,
            #f0f6ff,
            #f7faff
        );

    border:
        1px solid #d7e5f8;

    border-left:
        4px solid #1769e0;

    padding: 15px;

    border-radius: 8px;

    color: #536984;

    font-size: 13px;

    line-height: 1.6;
}

.note b {

    color: #173c76;
}


/* =========================================
   FORM ACTIONS
========================================= */

.form-actions {

    margin-top: 26px;

    display: flex;

    gap: 12px;
}

.submit-btn {

    flex: 1;

    border: none;

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

    cursor: pointer;

    box-shadow:
        0 8px 20px
        rgba(23,105,224,0.22);

    transition: 0.22s;
}

.submit-btn:hover {

    transform: translateY(-2px);

    box-shadow:
        0 12px 25px
        rgba(23,105,224,0.28);
}

.reset-btn {

    width: 130px;

    border:
        1px solid #1769e0;

    background: white;

    color: #1769e0;

    padding: 14px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.22s;
}

.reset-btn:hover {

    background: #f0f6ff;

    transform: translateY(-2px);
}


/* =========================================
   FOOTER
========================================= */

.footer {

    margin-top: 60px;

    background: #091b3d;

    color: #dceaff;

    text-align: center;

    padding: 24px;

    font-size: 13px;
}


/* =========================================
   RESPONSIVE
========================================= */

@media(max-width: 700px) {

    .header {

        padding: 14px 5%;
    }

    .logo {

        font-size: 23px;
    }

    .back-btn {

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

    .college-info {

        grid-template-columns: 1fr;
    }

    .form-grid {

        grid-template-columns: 1fr;
    }

    .form-group.full {

        grid-column: auto;
    }

    .form-card,
    .college-card {

        padding: 24px 20px;
    }

    .form-actions {

        flex-direction: column;
    }

    .reset-btn {

        width: 100%;
    }
}

</style>


<script>

function validateForm()
{

    var name =
        document.forms["admissionForm"]["name"]
        .value.trim();

    var email =
        document.forms["admissionForm"]["email"]
        .value.trim();

    var phone =
        document.forms["admissionForm"]["phone"]
        .value.trim();

    var course =
        document.forms["admissionForm"]["courseId"]
        .value;


    /* NAME */

    if(name == "")
    {

        alert("Name is required");

        document.forms["admissionForm"]["name"]
        .focus();

        return false;
    }


    var namePattern =
        /^[A-Za-z ]+$/;


    if(!namePattern.test(name))
    {

        alert(
            "Name should contain letters only"
        );

        document.forms["admissionForm"]["name"]
        .focus();

        return false;
    }


    /* EMAIL */

    if(email == "")
    {

        alert("Email is required");

        document.forms["admissionForm"]["email"]
        .focus();

        return false;
    }


    var emailPattern =
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/;


    if(!emailPattern.test(email))
    {

        alert("Enter a valid Email ID");

        document.forms["admissionForm"]["email"]
        .focus();

        return false;
    }


    /* PHONE */

    if(phone == "")
    {

        alert(
            "Phone Number is required"
        );

        document.forms["admissionForm"]["phone"]
        .focus();

        return false;
    }


    var phonePattern =
        /^[0-9]{10}$/;


    if(!phonePattern.test(phone))
    {

        alert(
            "Phone Number must contain exactly 10 digits"
        );

        document.forms["admissionForm"]["phone"]
        .focus();

        return false;
    }


    /* COURSE */

    if(course == "")
    {

        alert(
            "Please select a course"
        );

        document.forms["admissionForm"]["courseId"]
        .focus();

        return false;
    }


    return true;
}

</script>

</head>


<body>


<!-- =====================================
     HEADER
===================================== -->

<div class="header">

    <div class="logo">

        Campus<span>Connect</span>

    </div>


    <a
        href="new_student_colleges.jsp"
        class="back-btn">

        Back to Colleges

    </a>

</div>



<!-- =====================================
     MAIN
===================================== -->

<div class="container">


    <!-- PAGE TITLE -->

    <div class="page-title">

        <h1>
            Admission Request
        </h1>

        <p>
            Submit your admission request
            to the selected college.
        </p>

    </div>



    <!-- =================================
         SELECTED COLLEGE
    ================================== -->

    <div class="college-card">

        <h2 class="section-title">

            Selected College

        </h2>


        <div class="college-info">


            <!-- COLLEGE ID -->

            <div class="info-box">

                <span class="info-label">

                    College ID

                </span>

                <span class="info-value">

                    <%=collegeId%>

                </span>

            </div>



            <!-- COLLEGE NAME -->

            <div class="info-box">

                <span class="info-label">

                    College Name

                </span>

                <span class="info-value">

                    <%=collegeName%>

                </span>

            </div>



            <!-- CITY -->

            <div class="info-box">

                <span class="info-label">

                    City

                </span>

                <span class="info-value">

                    <%=city%>

                </span>

            </div>



            <!-- STATE -->

            <div class="info-box">

                <span class="info-label">

                    State

                </span>

                <span class="info-value">

                    <%=state%>

                </span>

            </div>


        </div>

    </div>



    <!-- =================================
         ADMISSION FORM
    ================================== -->

    <div class="form-card">


        <h2 class="section-title">

            Applicant Details

        </h2>


        <p class="form-description">

            Please enter your details carefully.
            These details will be submitted to the
            selected college for admission approval.

        </p>



        <form
            name="admissionForm"
            method="post"
            action="NewStudentAdmissionRequest"
            onsubmit="return validateForm();">


            <!-- COLLEGE ID -->

            <input
                type="hidden"
                name="collegeId"
                value="<%=collegeId%>">



            <div class="form-grid">


                <!-- NAME -->

                <div class="form-group">

                    <label>

                        Full Name

                        <span class="required">
                            *
                        </span>

                    </label>


                    <input
                        type="text"
                        name="name"
                        placeholder="Enter your full name"
                        maxlength="100"
                        required>

                </div>



                <!-- EMAIL -->

                <div class="form-group">

                    <label>

                        Email ID

                        <span class="required">
                            *
                        </span>

                    </label>


                    <input
                        type="email"
                        name="email"
                        placeholder="Enter your email"
                        maxlength="100"
                        required>

                </div>



                <!-- PHONE -->

                <div class="form-group">

                    <label>

                        Phone Number

                        <span class="required">
                            *
                        </span>

                    </label>


                    <input
                        type="text"
                        name="phone"
                        placeholder="Enter 10 digit phone number"
                        maxlength="10"
                        onkeypress="return event.charCode >= 48 && event.charCode <= 57"
                        required>

                </div>



                <!-- COURSE -->

                <div class="form-group">

                    <label>

                        Course

                        <span class="required">
                            *
                        </span>

                    </label>


                    <select
                        name="courseId"
                        class="course-select"
                        required>


                        <option value="">

                            Select Course

                        </option>


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


    ps2 =
        con2.prepareStatement(

            "SELECT COURSE_ID, COURSE_NAME " +

            "FROM COURSE " +

            "ORDER BY COURSE_NAME"
        );


    rs2 =
        ps2.executeQuery();


    while(rs2.next())
    {

%>


                        <option
                            value="<%=rs2.getInt("COURSE_ID")%>">

                            <%=rs2.getString("COURSE_NAME")%>

                        </option>


<%

    }

}

catch(Exception e)
{

%>


                        <option value="">

                            Unable to load courses

                        </option>


<%

}

finally
{

    try
    {

        if(rs2 != null)
            rs2.close();

        if(ps2 != null)
            ps2.close();

        if(con2 != null)
            con2.close();

    }

    catch(Exception e)
    {

    }
}

%>


                    </select>

                </div>


            </div>



            <!-- NOTE -->

            <div class="note">

                <b>Note:</b>

                Your admission request will be sent
                to the selected college. The college
                administrator will review and approve
                your request.

            </div>



            <!-- BUTTONS -->

            <div class="form-actions">


                <input
                    type="submit"
                    value="Submit Admission Request"
                    class="submit-btn">


                <input
                    type="reset"
                    value="Reset"
                    class="reset-btn">


            </div>


        </form>

    </div>


</div>



<!-- =====================================
     FOOTER
===================================== -->

<div class="footer">

    CampusConnect |

    Campus Recruitment Management System

</div>


</body>

</html>