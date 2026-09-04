<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Company Login | CampusConnect</title>

    <link rel="stylesheet"
          href="css/company-login.css">

    <script>

        function validateForm()
        {
            var email =
                document.forms["myForm"]["email"].value;

            var password =
                document.forms["myForm"]["password"].value;


            /* Both fields empty */

            if ((email == "" || email == null) &&
                (password == "" || password == null))
            {
                alert("Email and Password are required");

                document.forms["myForm"]["email"].focus();

                return false;
            }


            /* Email validation */

            if (email == "" || email == null)
            {
                alert("Email is required");

                document.forms["myForm"]["email"].focus();

                return false;
            }


            /* Password validation */

            if (password == "" || password == null)
            {
                alert("Password is required");

                document.forms["myForm"]["password"].focus();

                return false;
            }


            /* Password length */

            if (password.length < 6)
            {
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


        <!-- LEFT SIDE -->

        <div class="login-brand">

            <div class="logo">
                CampusConnect
            </div>


            <div class="brand-content">

                <h1>
                    Company<br>
                    Portal
                </h1>

                <p>
                    Manage recruitment and connect
                    with talented students.
                </p>

            </div>

        </div>


        <!-- RIGHT SIDE -->

        <div class="login-form-section">


            <div class="login-box">


                <h2>
                    Welcome back
                </h2>


                <p class="subtitle">
                    Sign in to your company account
                </p>


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
                               autocomplete="current-password">

                    </div>


                    <!-- LOGIN -->

                    <button type="submit"
                            class="login-button">

                        Login

                    </button>


                    <!-- RESET -->

                    <div class="form-actions">

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