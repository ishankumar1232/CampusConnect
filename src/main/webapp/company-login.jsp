<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Company Login | CampusConnect</title>

    <link rel="stylesheet" href="css/company-login.css?v=2">

    <script>

        function validateForm() {

            var email =
                document.forms["myForm"]["email"].value;

            var password =
                document.forms["myForm"]["password"].value;


            /* Both fields empty */

            if ((email == "" || email == null) &&
                (password == "" || password == null)) {

                alert("Email and Password are required");

                document.forms["myForm"]["email"].focus();

                return false;
            }


            /* Email validation */

            if (email == "" || email == null) {

                alert("Email is required");

                document.forms["myForm"]["email"].focus();

                return false;
            }


            /* Password validation */

            if (password == "" || password == null) {

                alert("Password is required");

                document.forms["myForm"]["password"].focus();

                return false;
            }


            /* Password length */

            if (password.length < 6) {

                alert("Password must be at least 6 characters");

                document.forms["myForm"]["password"].focus();

                return false;
            }


            return true;
        }

    </script>

</head>


<body>

    <div class="login-container">


        <!-- =========================
             LEFT BRAND PANEL
             ========================= -->

        <div class="login-brand">


            <!-- LOGO -->

            <div class="logo">
                Campus<span>Connect</span>
            </div>


            <!-- BRAND CONTENT -->

            <div class="brand-content">


                <!-- COMPANY ICON -->

                <div class="company-icon">

                    <div class="building">

                        <div class="building-top"></div>

                        <div class="building-body">

                            <span></span>
                            <span></span>
                            <span></span>
                            <span></span>

                        </div>

                    </div>

                </div>


                <!-- WELCOME -->

                <h1>
                    Welcome Back,<br>
                    <span>Company!</span>
                </h1>


                <!-- DESCRIPTION -->

                <p>
                    Access your company portal and manage your
                    recruitment activities from one place.
                </p>


                <!-- FEATURES -->

                <div class="features">


                    <div class="feature">

                        <span class="check">&#10003;</span>

                        <span>
                            Manage your company profile
                        </span>

                    </div>


                    <div class="feature">

                        <span class="check">&#10003;</span>

                        <span>
                            Create recruitment drives
                        </span>

                    </div>


                    <div class="feature">

                        <span class="check">&#10003;</span>

                        <span>
                            Review student applications
                        </span>

                    </div>


                    <div class="feature">

                        <span class="check">&#10003;</span>

                        <span>
                            Track interviews and selections
                        </span>

                    </div>


                </div>

            </div>

        </div>



        <!-- =========================
             RIGHT FORM PANEL
             ========================= -->

        <div class="login-form-section">


            <div class="login-box">


                <!-- HEADING -->

                <h2>
                    Company Sign In
                </h2>


                <!-- SUBTITLE -->

                <p class="subtitle">
                    Sign in to continue to your CampusConnect company account.
                </p>


                <!-- REQUIRED NOTE -->

                <p class="required-note">

                    <span class="required">*</span>
                    Indicates mandatory fields

                </p>


                <!-- LOGIN FORM -->

                <form name="myForm"
                      method="post"
                      action="CompanyLoginServlet"
                      onsubmit="return validateForm();">


                    <!-- EMAIL -->

                    <div class="form-group">

                        <label for="email">

                            Email ID
                            <span class="required">*</span>

                        </label>

                        <input type="email"
                               id="email"
                               name="email"
                               placeholder="Enter your email"
                               autocomplete="email">

                    </div>



                    <!-- PASSWORD -->

                    <div class="form-group">

                        <label for="password">

                            Password
                            <span class="required">*</span>

                        </label>

                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Enter your password"
                               autocomplete="current-password">

                    </div>



                    <!-- REMEMBER + FORGOT -->

                    <div class="login-options">


                        <label class="remember-me">

                            <input type="checkbox"
                                   name="remember">

                            <span>
                                Remember me
                            </span>

                        </label>


                        <a href="#"
                           class="forgot-password">

                            Forgot Password?

                        </a>


                    </div>



                    <!-- BUTTONS -->

                    <div class="button-row">

                        <button type="submit"
                                class="login-button">

                            Sign In

                        </button>


                        <button type="reset"
                                class="reset-button">

                            Reset

                        </button>

                    </div>


                </form>



                <!-- REGISTER -->

                <div class="register-link">

                    New Company?

                    <a href="company-registration.jsp">
                        Register Here
                    </a>

                </div>


            </div>

        </div>


    </div>

</body>

</html>