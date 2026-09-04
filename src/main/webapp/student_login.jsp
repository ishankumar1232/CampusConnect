<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Login | CampusConnect</title>


<style>

/* ================= GENERAL ================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    min-height: 100vh;
    background: linear-gradient(135deg, #eef5ff, #f8fbff);

    display: flex;
    align-items: center;
    justify-content: center;

    padding: 30px;
}


/* ================= MAIN BOX ================= */

.login-container {
    width: 990px;
    max-width: 100%;

    min-height: 610px;

    background: white;

    border-radius: 22px;

    overflow: hidden;

    display: flex;

    box-shadow:
        0 20px 60px rgba(30, 60, 100, 0.15);
}


/* ================= LEFT PANEL ================= */

.left-panel {

    width: 48%;

    background:
        linear-gradient(
            145deg,
            #174a9c,
            #1769e0
        );

    color: white;

    padding: 50px;

    display: flex;

    flex-direction: column;

    justify-content: center;
}


/* LOGO */

.logo {

    font-size: 27px;

    font-weight: bold;

    margin-bottom: 55px;
}

.logo span {
    color: #9dc9ff;
}


/* STUDENT ICON */

.student-icon {

    width: 68px;
    height: 68px;

    border-radius: 18px;

    background:
        rgba(255,255,255,0.15);

    display: flex;

    align-items: center;

    justify-content: center;

    margin-bottom: 25px;

    position: relative;
}


/* CSS PERSON ICON */

.student-icon:before {

    content: "";

    width: 17px;
    height: 17px;

    border: 3px solid white;

    border-radius: 50%;

    position: absolute;

    top: 12px;
}


.student-icon:after {

    content: "";

    width: 32px;
    height: 18px;

    border: 3px solid white;

    border-bottom: none;

    border-radius: 18px 18px 0 0;

    position: absolute;

    bottom: 11px;
}


/* LEFT HEADING */

.left-panel h1 {

    font-size: 38px;

    line-height: 1.2;

    margin-bottom: 18px;
}

.left-panel h1 span {

    color: #a9d0ff;
}


/* LEFT DESCRIPTION */

.left-panel > p {

    color: #dceaff;

    font-size: 14px;

    line-height: 1.8;

    max-width: 380px;
}


/* FEATURES */

.features {

    margin-top: 30px;
}


.feature {

    display: flex;

    align-items: center;

    gap: 12px;

    margin: 14px 0;

    font-size: 14px;

    color: #eef6ff;
}


/* CHECK ICON */

.check {

    width: 23px;
    height: 23px;

    border-radius: 50%;

    background:
        rgba(255,255,255,0.18);

    position: relative;

    flex-shrink: 0;
}


.check:after {

    content: "";

    width: 7px;
    height: 4px;

    border-left: 2px solid white;

    border-bottom: 2px solid white;

    position: absolute;

    left: 7px;
    top: 7px;

    transform: rotate(-45deg);
}


/* ================= RIGHT PANEL ================= */

.right-panel {

    width: 52%;

    padding: 55px 60px;

    display: flex;

    flex-direction: column;

    justify-content: center;
}


/* TITLE */

.right-panel h2 {

    color: #172f58;

    font-size: 32px;

    margin-bottom: 8px;
}


/* SUBTITLE */

.subtitle {

    color: #7a8495;

    font-size: 14px;

    margin-bottom: 28px;

    line-height: 1.5;
}


/* REQUIRED */

.required {

    color: #e53935;
}


/* ================= FORM ================= */

.form-group {

    margin-bottom: 20px;
}


.form-group label {

    display: block;

    color: #34425a;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 8px;
}


/* INPUT BOX */

.input-wrapper {

    position: relative;
}


/* INPUT */

.input-wrapper input {

    width: 100%;

    height: 50px;

    padding: 0 15px 0 45px;

    border: 1px solid #d9e1ed;

    border-radius: 9px;

    outline: none;

    background: #f8fbff;

    color: #26364f;

    font-size: 14px;

    transition: 0.3s;
}


.input-wrapper input:focus {

    border-color: #1769e0;

    background: white;

    box-shadow:
        0 0 0 3px rgba(23,105,224,0.10);
}


.input-wrapper input::placeholder {

    color: #a2adbd;
}


/* ================= INPUT ICONS ================= */


/* EMAIL ICON */

.input-icon {

    position: absolute;

    left: 16px;

    top: 50%;

    transform: translateY(-50%);

    width: 18px;

    height: 14px;

    border: 2px solid #8090a8;

    border-radius: 3px;

    pointer-events: none;
}


/* EMAIL ENVELOPE */

.email-icon:after {

    content: "";

    position: absolute;

    width: 9px;
    height: 9px;

    border-left: 2px solid #8090a8;

    border-bottom: 2px solid #8090a8;

    transform:
        rotate(-45deg)
        translate(-2px, -1px);

    left: 2px;

    top: 0px;
}


/* PASSWORD ICON */

.password-icon {

    width: 17px;

    height: 14px;

    border: 2px solid #8090a8;

    border-radius: 3px;

    left: 17px;
}


/* PASSWORD LOCK */

.password-icon:before {

    content: "";

    position: absolute;

    width: 8px;
    height: 8px;

    border: 2px solid #8090a8;

    border-bottom: none;

    border-radius: 8px 8px 0 0;

    left: 2px;

    top: -9px;
}


/* ================= OPTIONS ================= */

.options {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-top: 5px;

    margin-bottom: 25px;

    font-size: 13px;
}


/* REMEMBER */

.remember {

    display: flex;

    align-items: center;

    gap: 7px;

    color: #6d7788;
}


.remember input {

    width: 15px;
    height: 15px;

    accent-color: #1769e0;

    cursor: pointer;
}


/* FORGOT PASSWORD */

.forgot {

    color: #1769e0;

    text-decoration: none;

    font-weight: bold;
}


.forgot:hover {

    text-decoration: underline;
}


/* ================= BUTTONS ================= */

.buttons {

    display: flex;

    gap: 12px;

    width: 100%;
}


.signin-button {

    flex: 1;

    height: 50px;

    border: none;

    border-radius: 9px;

    background: #1769e0;

    color: white;

    font-size: 15px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.3s;
}


.signin-button:hover {

    background: #0d54bd;

    transform: translateY(-1px);

    box-shadow:
        0 7px 15px rgba(23,105,224,0.22);
}


.reset-button {

    width: 105px;

    height: 50px;

    border: 1px solid #d6deea;

    border-radius: 9px;

    background: white;

    color: #647085;

    font-size: 14px;

    cursor: pointer;

    transition: 0.3s;
}


.reset-button:hover {

    background: #f5f8fc;
}


/* ================= BOTTOM LINKS ================= */

.bottom-links {

    text-align: center;

    margin-top: 30px;

    color: #7b8596;

    font-size: 13px;

    line-height: 2;
}


.bottom-links a {

    color: #1769e0;

    text-decoration: none;

    font-weight: bold;
}


.bottom-links a:hover {

    text-decoration: underline;
}


/* ================= RESPONSIVE ================= */

@media(max-width: 800px) {

    body {

        padding: 15px;

    }


    .login-container {

        flex-direction: column;

    }


    .left-panel {

        width: 100%;

        padding: 35px;

    }


    .right-panel {

        width: 100%;

        padding: 40px 35px;

    }


    .features {

        display: none;

    }

}


@media(max-width: 500px) {

    .left-panel h1 {

        font-size: 30px;

    }


    .right-panel h2 {

        font-size: 27px;

    }


    .options {

        flex-direction: column;

        align-items: flex-start;

        gap: 12px;

    }

}

</style>


<script>

function validateForm()
{

    var email =
        document.forms["loginForm"]["email"].value;

    var password =
        document.forms["loginForm"]["password"].value;


    /* ================= ALL BLANK ================= */

    if((email == "" || email == null) &&
       (password == "" || password == null))
    {

        alert("All mandatory fields are blank");

        document.forms["loginForm"]["email"].focus();

        return false;
    }


    /* ================= EMAIL ================= */

    if(email == "" || email == null)
    {

        alert("Email is required");

        document.forms["loginForm"]["email"].focus();

        return false;
    }


    var emailPattern =
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/;


    if(!emailPattern.test(email))
    {

        alert("Enter a valid Email ID");

        document.forms["loginForm"]["email"].focus();

        return false;
    }


    /* ================= PASSWORD ================= */

    if(password == "" || password == null)
    {

        alert("Password is required");

        document.forms["loginForm"]["password"].focus();

        return false;
    }


    return true;

}

</script>

</head>


<body>


<div class="login-container">


    <!-- ================= LEFT SIDE ================= -->

    <div class="left-panel">


        <div class="logo">

            Campus<span>Connect</span>

        </div>


        <div class="student-icon"></div>


        <h1>

            Welcome Back,

            <span>Student!</span>

        </h1>


        <p>

            Access your student portal and manage your
            complete academic and recruitment journey
            from one place.

        </p>


        <div class="features">


            <div class="feature">

                <div class="check"></div>

                Manage your student profile

            </div>


            <div class="feature">

                <div class="check"></div>

                Track recruitment applications

            </div>


            <div class="feature">

                <div class="check"></div>

                Apply for placement drives

            </div>


            <div class="feature">

                <div class="check"></div>

                Track interviews and selections

            </div>


        </div>


    </div>


    <!-- ================= RIGHT SIDE ================= -->

    <div class="right-panel">


        <h2>

            Student Sign In

        </h2>


        <p class="subtitle">

            Sign in to continue to your
            CampusConnect account.

        </p>


        <p class="subtitle"
           style="margin-top:-15px;">

            <span class="required">*</span>
            Indicates mandatory fields

        </p>


        <form name="loginForm"

              method="post"

              action="studentLogin"

              onsubmit="return validateForm();">


            <!-- ================= EMAIL ================= -->

            <div class="form-group">


                <label>

                    Email ID
                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">


                    <span class="input-icon email-icon"></span>


                    <input type="email"

                           name="email"

                           placeholder="Enter your email">


                </div>


            </div>


            <!-- ================= PASSWORD ================= -->

            <div class="form-group">


                <label>

                    Password
                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">


                    <span class="input-icon password-icon"></span>


                    <input type="password"

                           name="password"

                           placeholder="Enter your password">


                </div>


            </div>


            <!-- ================= OPTIONS ================= -->

            <div class="options">


                <label class="remember">


                    <input type="checkbox"
                           name="remember">


                    Remember me


                </label>


                <a href="forgot_password.jsp"
                   class="forgot">

                    Forgot Password?

                </a>


            </div>


            <!-- ================= BUTTONS ================= -->

            <div class="buttons">


                <input type="submit"

                       value="Sign In"

                       class="signin-button">


                <input type="reset"

                       value="Reset"

                       class="reset-button">


            </div>


        </form>


        <!-- ================= BOTTOM ================= -->

        <div class="bottom-links">


            New student?

            <a href="new_student_colleges.jsp">

                Start Admission

            </a>


            <br>


            <a href="index.jsp">

                Back to CampusConnect

            </a>


        </div>


    </div>


</div>


</body>

</html>