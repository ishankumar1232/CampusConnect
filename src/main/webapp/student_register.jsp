<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
    String admissionId =
        request.getParameter("admissionId");

    if(admissionId == null ||
       admissionId.trim().equals(""))
    {
        response.sendRedirect("new_student_colleges.jsp");
        return;
    }


    String name = "";
    String email = "";
    String phone = "";
    String collegeName = "";
    String courseName = "";


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
            "SELECT A.APPLICANT_NAME, " +
            "A.APPLICANT_EMAIL, " +
            "A.APPLICANT_PHONE, " +
            "C.COLLEGE_NAME, " +
            "CR.COURSE_NAME " +
            "FROM ADMISSION A " +
            "LEFT JOIN COLLEGE C " +
            "ON A.COLLEGE_ID = C.COLLEGE_ID " +
            "LEFT JOIN COURSE CR " +
            "ON A.APPLICANT_COURSE_ID = CR.COURSE_ID " +
            "WHERE A.ADMISSION_ID=? " +
            "AND A.STATUS='CONFIRMED' " +
            "AND A.STUDENT_ID IS NULL";


        ps = con.prepareStatement(sql);

        ps.setInt(
            1,
            Integer.parseInt(admissionId)
        );


        rs = ps.executeQuery();


        if(rs.next())
        {
            name =
                rs.getString("APPLICANT_NAME");

            email =
                rs.getString("APPLICANT_EMAIL");

            phone =
                rs.getString("APPLICANT_PHONE");

            collegeName =
                rs.getString("COLLEGE_NAME");

            courseName =
                rs.getString("COURSE_NAME");
        }
        else
        {
            rs.close();
            ps.close();
            con.close();

            out.println(
                "<h2>Registration Not Available</h2>"
            );

            out.println(
                "<p>Admission is not confirmed or registration is already completed.</p>"
            );

            return;
        }

    }
    catch(Exception e)
    {
        out.println(
            "<h2>Error</h2>"
        );

        out.println(
            "<p>" + e.getMessage() + "</p>"
        );

        return;
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
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Student Registration | CampusConnect
</title>


<style>

/* =====================================
   GLOBAL
===================================== */

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


/* =====================================
   HEADER
===================================== */

.header {

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


/* =====================================
   MAIN
===================================== */

.container {

    width: 90%;

    max-width: 900px;

    margin: 42px auto 70px;
}


/* =====================================
   PAGE TITLE
===================================== */

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


/* =====================================
   CARD
===================================== */

.card {

    background: white;

    border-radius: 20px;

    border:
        1px solid
        rgba(148,163,184,0.22);

    box-shadow:
        0 16px 45px
        rgba(15,45,90,0.09);

    padding: 30px;

    margin-bottom: 22px;

    position: relative;

    overflow: hidden;
}

.card::before {

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


/* =====================================
   SECTION TITLE
===================================== */

.section-title {

    color: #173c76;

    font-size: 21px;

    margin-bottom: 20px;

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


/* =====================================
   ADMISSION INFO
===================================== */

.info-grid {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 14px;
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

    padding: 16px;

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

    font-size: 14px;

    font-weight: bold;

    word-break: break-word;
}


/* =====================================
   FORM
===================================== */

.form-description {

    color: #718096;

    font-size: 14px;

    line-height: 1.6;

    margin-bottom: 20px;
}

.form-group {

    margin-top: 18px;
}

.form-group label {

    display: block;

    color: #344b68;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 8px;
}

.required {

    color: #e53935;
}

input[type="password"],
input[type="date"],
textarea {

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

input[type="password"]:hover,
input[type="date"]:hover,
textarea:hover {

    border-color: #b9cce4;
}

input[type="password"]:focus,
input[type="date"]:focus,
textarea:focus {

    border-color: #1769e0;

    background: white;

    box-shadow:
        0 0 0 3px
        rgba(23,105,224,0.10);
}

textarea {

    resize: vertical;

    min-height: 110px;
}


/* =====================================
   GENDER
===================================== */

.gender {

    display: flex;

    gap: 25px;

    margin-top: 8px;
}

.gender label {

    margin: 0;

    font-weight: normal;

    display: flex;

    align-items: center;

    gap: 7px;

    cursor: pointer;
}

.gender input {

    accent-color: #1769e0;

}


/* =====================================
   NOTE
===================================== */

.note {

    margin-top: 22px;

    padding: 15px;

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

    border-radius: 8px;

    font-size: 13px;

    color: #536984;

    line-height: 1.6;
}

.note b {

    color: #173c76;
}


/* =====================================
   BUTTONS
===================================== */

.buttons {

    display: flex;

    gap: 12px;

    margin-top: 26px;
}

button {

    border: none;

    border-radius: 9px;

    padding: 14px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.22s;
}

.register-btn {

    flex: 1;

    background:
        linear-gradient(
            135deg,
            #1769e0,
            #1258c4
        );

    color: white;

    box-shadow:
        0 8px 20px
        rgba(23,105,224,0.22);
}

.register-btn:hover {

    transform: translateY(-2px);

    box-shadow:
        0 12px 25px
        rgba(23,105,224,0.28);
}

.reset-btn {

    width: 130px;

    background: white;

    color: #1769e0;

    border:
        1px solid #1769e0;
}

.reset-btn:hover {

    background: #f0f6ff;

    transform: translateY(-2px);
}


/* =====================================
   FOOTER
===================================== */

.footer {

    margin-top: 60px;

    background: #091b3d;

    color: #dceaff;

    text-align: center;

    padding: 24px;

    font-size: 13px;
}


/* =====================================
   RESPONSIVE
===================================== */

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

    .card {

        padding: 24px 20px;
    }

    .info-grid {

        grid-template-columns: 1fr;
    }

    .buttons {

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

    var form =
        document.forms["studentForm"];


    var password =
        form["password"].value;

    var cpassword =
        form["cpassword"].value;

    var dob =
        form["dob"].value;

    var gender =
        form["gender"];

    var address =
        form["address"].value;


    /* PASSWORD */

    if(password == "")
    {
        alert("Password is required");

        form["password"].focus();

        return false;
    }


    if(password.length < 6)
    {
        alert(
            "Password must be at least 6 characters"
        );

        form["password"].focus();

        return false;
    }


    /* CONFIRM PASSWORD */

    if(cpassword == "")
    {
        alert(
            "Confirm Password is required"
        );

        form["cpassword"].focus();

        return false;
    }


    if(password != cpassword)
    {
        alert(
            "Passwords do not match"
        );

        form["cpassword"].focus();

        return false;
    }


    /* DOB */

    if(dob == "")
    {
        alert(
            "Date of Birth is required"
        );

        form["dob"].focus();

        return false;
    }


    /* GENDER */

    if(!gender[0].checked &&
       !gender[1].checked)
    {
        alert(
            "Please select Gender"
        );

        return false;
    }


    /* ADDRESS */

    if(address.trim() == "")
    {
        alert(
            "Address is required"
        );

        form["address"].focus();

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


    <!-- TITLE -->

    <div class="page-title">

        <h1>
            Student Registration
        </h1>

        <p>
            Complete your registration to create
            your CampusConnect student account.
        </p>

    </div>



    <!-- =================================
         ADMISSION INFORMATION
    ================================== -->

    <div class="card">

        <h2 class="section-title">

            Admission Details

        </h2>


        <div class="info-grid">


            <!-- ADMISSION ID -->

            <div class="info-box">

                <span class="info-label">
                    Admission ID
                </span>

                <span class="info-value">
                    <%= admissionId %>
                </span>

            </div>



            <!-- NAME -->

            <div class="info-box">

                <span class="info-label">
                    Name
                </span>

                <span class="info-value">
                    <%= name %>
                </span>

            </div>



            <!-- EMAIL -->

            <div class="info-box">

                <span class="info-label">
                    Email
                </span>

                <span class="info-value">
                    <%= email %>
                </span>

            </div>



            <!-- PHONE -->

            <div class="info-box">

                <span class="info-label">
                    Phone
                </span>

                <span class="info-value">
                    <%= phone %>
                </span>

            </div>



            <!-- COLLEGE -->

            <div class="info-box">

                <span class="info-label">
                    College
                </span>

                <span class="info-value">
                    <%= collegeName %>
                </span>

            </div>



            <!-- COURSE -->

            <div class="info-box">

                <span class="info-label">
                    Course
                </span>

                <span class="info-value">
                    <%= courseName %>
                </span>

            </div>


        </div>

    </div>



    <!-- =================================
         REGISTRATION FORM
    ================================== -->

    <div class="card">

        <h2 class="section-title">

            Create Your Account

        </h2>


        <p class="form-description">

            Your admission information is already
            verified. Complete the remaining details
            below to create your student account.

        </p>


        <form
            name="studentForm"
            method="post"
            action="studentRegister"
            onsubmit="return validateForm();">


            <!-- ADMISSION ID -->

            <input
                type="hidden"
                name="admissionId"
                value="<%= admissionId %>">



            <!-- PASSWORD -->

            <div class="form-group">

                <label>

                    Password

                    <span class="required">
                        *
                    </span>

                </label>


                <input
                    type="password"
                    name="password"
                    placeholder="Create a password"
                    maxlength="100"
                    autocomplete="new-password"
                    required>

            </div>



            <!-- CONFIRM PASSWORD -->

            <div class="form-group">

                <label>

                    Confirm Password

                    <span class="required">
                        *
                    </span>

                </label>


                <input
                    type="password"
                    name="cpassword"
                    placeholder="Confirm your password"
                    maxlength="100"
                    autocomplete="new-password"
                    required>

            </div>



            <!-- DOB -->

            <div class="form-group">

                <label>

                    Date of Birth

                    <span class="required">
                        *
                    </span>

                </label>


                <input
                    type="date"
                    name="dob"
                    required>

            </div>



            <!-- GENDER -->

            <div class="form-group">

                <label>

                    Gender

                    <span class="required">
                        *
                    </span>

                </label>


                <div class="gender">

                    <label>

                        <input
                            type="radio"
                            name="gender"
                            value="Male">

                        Male

                    </label>


                    <label>

                        <input
                            type="radio"
                            name="gender"
                            value="Female">

                        Female

                    </label>

                </div>

            </div>



            <!-- ADDRESS -->

            <div class="form-group">

                <label>

                    Address

                    <span class="required">
                        *
                    </span>

                </label>


                <textarea
                    name="address"
                    rows="4"
                    maxlength="200"
                    placeholder="Enter your complete address"
                    required></textarea>

            </div>



            <!-- NOTE -->

            <div class="note">

                <b>Note:</b>

                Your Name, Email, Phone, College and
                Course are taken automatically from your
                confirmed admission request.

            </div>



            <!-- BUTTONS -->

            <div class="buttons">

                <button
                    type="submit"
                    class="register-btn">

                    Complete Registration

                </button>


                <button
                    type="reset"
                    class="reset-btn">

                    Reset

                </button>

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