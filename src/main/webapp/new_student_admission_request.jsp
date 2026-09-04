<%@ page import="java.sql.*" %>

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

        /*
         * IMPORTANT:
         * Your COLLEGE table contains APPROVED colleges,
         * so use STATUS='APPROVED'
         */
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

/* =========================
   BASIC
========================= */

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


/* =========================
   HEADER
========================= */

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

.back-btn {
    color: white;

    text-decoration: none;

    border: 1px solid rgba(255,255,255,0.7);

    padding: 10px 17px;

    border-radius: 7px;

    font-size: 14px;
}

.back-btn:hover {
    background: rgba(255,255,255,0.15);
}


/* =========================
   MAIN
========================= */

.container {
    width: 90%;

    max-width: 1000px;

    margin: 45px auto;
}


/* =========================
   PAGE TITLE
========================= */

.page-title {
    text-align: center;

    margin-bottom: 35px;
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


/* =========================
   SELECTED COLLEGE
========================= */

.college-card {
    background: white;

    border-radius: 16px;

    border: 1px solid #e2e8f0;

    box-shadow:
        0 8px 25px rgba(30,60,100,0.08);

    padding: 25px;

    margin-bottom: 25px;
}

.section-title {
    color: #173c76;

    font-size: 21px;

    margin-bottom: 18px;
}


/* College information */

.college-info {
    display: grid;

    grid-template-columns: 1fr 1fr;

    gap: 15px;
}

.info-box {
    background: #f7faff;

    border: 1px solid #e2e9f3;

    padding: 16px;

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

    font-size: 15px;

    font-weight: bold;
}


/* =========================
   ADMISSION FORM
========================= */

.form-card {
    background: white;

    border-radius: 16px;

    border: 1px solid #e2e8f0;

    box-shadow:
        0 8px 25px rgba(30,60,100,0.08);

    padding: 30px;
}

.form-description {
    color: #718096;

    font-size: 14px;

    margin-bottom: 25px;

    line-height: 1.5;
}


/* =========================
   FORM GRID
========================= */

.form-grid {
    display: grid;

    grid-template-columns: 1fr 1fr;

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


/* =========================
   INPUTS
========================= */

.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;

    padding: 13px 14px;

    border: 1px solid #d6dfeb;

    border-radius: 8px;

    outline: none;

    font-size: 14px;

    background: #fbfdff;

    color: #344b68;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    border-color: #1769e0;

    box-shadow:
        0 0 0 3px rgba(23,105,224,0.10);
}

.form-group textarea {
    resize: vertical;

    min-height: 100px;
}


/* =========================
   BUTTONS
========================= */

.form-actions {
    margin-top: 25px;

    display: flex;

    gap: 12px;
}

.submit-btn {
    flex: 1;

    border: none;

    background: #1769e0;

    color: white;

    padding: 14px;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;
}

.submit-btn:hover {
    background: #0d54bd;
}

.reset-btn {
    width: 130px;

    border: 1px solid #1769e0;

    background: white;

    color: #1769e0;

    padding: 14px;

    border-radius: 8px;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;
}

.reset-btn:hover {
    background: #f0f6ff;
}


/* =========================
   NOTE
========================= */

.note {
    margin-top: 20px;

    background: #f0f6ff;

    border-left: 4px solid #1769e0;

    padding: 14px;

    border-radius: 6px;

    color: #536984;

    font-size: 13px;

    line-height: 1.5;
}


/* =========================
   FOOTER
========================= */

.footer {
    margin-top: 60px;

    background: #123c88;

    color: #dceaff;

    text-align: center;

    padding: 20px;

    font-size: 13px;
}


/* =========================
   RESPONSIVE
========================= */

@media(max-width: 700px) {

    .college-info {
        grid-template-columns: 1fr;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .form-group.full {
        grid-column: auto;
    }

    .form-actions {
        flex-direction: column;
    }

    .reset-btn {
        width: 100%;
    }

    .page-title h1 {
        font-size: 30px;
    }

}

</style>


<script>

function validateForm()
{
    var name =
        document.forms["admissionForm"]["name"].value.trim();

    var email =
        document.forms["admissionForm"]["email"].value.trim();

    var phone =
        document.forms["admissionForm"]["phone"].value.trim();

    var course =
        document.forms["admissionForm"]["courseId"].value;


    /* Name */

    if(name == "")
    {
        alert("Name is required");

        document.forms["admissionForm"]["name"].focus();

        return false;
    }


    var namePattern = /^[A-Za-z ]+$/;

    if(!namePattern.test(name))
    {
        alert("Name should contain letters only");

        document.forms["admissionForm"]["name"].focus();

        return false;
    }


    /* Email */

    if(email == "")
    {
        alert("Email is required");

        document.forms["admissionForm"]["email"].focus();

        return false;
    }


    var emailPattern =
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(!emailPattern.test(email))
    {
        alert("Enter a valid Email ID");

        document.forms["admissionForm"]["email"].focus();

        return false;
    }


    /* Phone */

    if(phone == "")
    {
        alert("Phone Number is required");

        document.forms["admissionForm"]["phone"].focus();

        return false;
    }


    var phonePattern = /^[0-9]{10}$/;

    if(!phonePattern.test(phone))
    {
        alert("Phone Number must contain exactly 10 digits");

        document.forms["admissionForm"]["phone"].focus();

        return false;
    }


    /* Course */

    if(course == "")
    {
        alert("Please select a course");

        document.forms["admissionForm"]["courseId"].focus();

        return false;
    }


    return true;
}

</script>

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
       class="back-btn">

        Back to Colleges

    </a>

</div>



<!-- =========================
     MAIN
========================= -->

<div class="container">


    <!-- TITLE -->

    <div class="page-title">

        <h1>
            Admission Request
        </h1>

        <p>
            Submit your admission request to the selected college.
        </p>

    </div>



    <!-- =========================
         SELECTED COLLEGE
    ========================= -->

    <div class="college-card">

        <h2 class="section-title">
            Selected College
        </h2>


        <div class="college-info">


            <div class="info-box">

                <span class="info-label">
                    College ID
                </span>

                <span class="info-value">

                    <%=collegeId%>

                </span>

            </div>


            <div class="info-box">

                <span class="info-label">
                    College Name
                </span>

                <span class="info-value">

                    <%=collegeName%>

                </span>

            </div>


            <div class="info-box">

                <span class="info-label">
                    City
                </span>

                <span class="info-value">

                    <%=city%>

                </span>

            </div>


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



    <!-- =========================
         ADMISSION FORM
    ========================= -->

    <div class="form-card">

        <h2 class="section-title">
            Applicant Details
        </h2>


        <p class="form-description">

            Please enter your details carefully.
            These details will be submitted to the selected
            college for admission approval.

        </p>


        <form name="admissionForm"

              method="post"

              action="NewStudentAdmissionRequest"

              onsubmit="return validateForm();">


            <!-- COLLEGE ID -->

            <input type="hidden"

                   name="collegeId"

                   value="<%=collegeId%>">



            <div class="form-grid">


                <!-- NAME -->

                <div class="form-group">

                    <label>

                        Full Name

                        <span class="required">*</span>

                    </label>


                    <input type="text"

                           name="name"

                           placeholder="Enter your full name"

                           maxlength="100"

                           required>

                </div>



                <!-- EMAIL -->

                <div class="form-group">

                    <label>

                        Email ID

                        <span class="required">*</span>

                    </label>


                    <input type="email"

                           name="email"

                           placeholder="Enter your email"

                           maxlength="100"

                           required>

                </div>



                <!-- PHONE -->

                <div class="form-group">

                    <label>

                        Phone Number

                        <span class="required">*</span>

                    </label>


                    <input type="text"

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

                        <span class="required">*</span>

                    </label>


                    <select name="courseId"
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


                        <option value="<%=rs2.getInt("COURSE_ID")%>">

                            <%=rs2.getString("COURSE_NAME")%>

                        </option>


                        <%

                                }

                            }
                            catch(Exception e)
                            {

                                out.println(
                                    "<option value=''>Unable to load courses</option>"
                                );

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

                Your admission request will be sent to the
                selected college. The college administrator
                will review and approve your request.

            </div>



            <!-- BUTTONS -->

            <div class="form-actions">


                <input type="submit"

                       value="Submit Admission Request"

                       class="submit-btn">


                <input type="reset"

                       value="Reset"

                       class="reset-btn">


            </div>


        </form>

    </div>


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