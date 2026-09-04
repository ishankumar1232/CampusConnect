<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Company Registration | CampusConnect</title>

    <link rel="stylesheet"
          href="css/company-registration.css">

    <script>

        function validateForm()
        {
            var companyName = document.forms["myForm"]["companyName"].value;
            var email = document.forms["myForm"]["email"].value;
            var phone = document.forms["myForm"]["phone"].value;
            var password = document.forms["myForm"]["password"].value;
            var confirmPassword = document.forms["myForm"]["confirmPassword"].value;
            var address = document.forms["myForm"]["address"].value;
            var website = document.forms["myForm"]["website"].value;
            var status = document.forms["myForm"]["status"].value;


            // Check if all mandatory fields are blank

            if ((companyName == "" || companyName == null) &&
                (email == "" || email == null) &&
                (phone == "" || phone == null) &&
                (password == "" || password == null) &&
                (confirmPassword == "" || confirmPassword == null) &&
                (address == "" || address == null) &&
                (status == "" || status == null))
            {
                alert("All mandatory fields are blank");

                document.forms["myForm"]["companyName"].focus();

                return false;
            }


            // Company Name

            if (companyName == "" || companyName == null)
            {
                alert("Company Name is required");

                document.forms["myForm"]["companyName"].focus();

                return false;
            }

            var letters = /^[A-Za-z ]+$/;

            if (!letters.test(companyName))
            {
                alert("Company Name should contain letters only");

                document.forms["myForm"]["companyName"].focus();

                return false;
            }


            // Email

            if (email == "" || email == null)
            {
                alert("Email is required");

                document.forms["myForm"]["email"].focus();

                return false;
            }


            // Phone

            if (phone == "" || phone == null)
            {
                alert("Phone Number is required");

                document.forms["myForm"]["phone"].focus();

                return false;
            }

            var numbers = /^[0-9]+$/;

            if (!numbers.test(phone))
            {
                alert("Phone Number should contain numbers only");

                document.forms["myForm"]["phone"].focus();

                return false;
            }

            if (phone.length != 10)
            {
                alert("Phone Number must be 10 digits");

                document.forms["myForm"]["phone"].focus();

                return false;
            }


            // Password

            if (password == "" || password == null)
            {
                alert("Password is required");

                document.forms["myForm"]["password"].focus();

                return false;
            }

            if (password.length < 6)
            {
                alert("Password must be at least 6 characters");

                document.forms["myForm"]["password"].focus();

                return false;
            }


            // Confirm Password

            if (confirmPassword == "" || confirmPassword == null)
            {
                alert("Confirm Password is required");

                document.forms["myForm"]["confirmPassword"].focus();

                return false;
            }

            if (password != confirmPassword)
            {
                alert("Password and Confirm Password do not match");

                document.forms["myForm"]["confirmPassword"].focus();

                return false;
            }


            // Address

            if (address == "" || address == null)
            {
                alert("Address is required");

                document.forms["myForm"]["address"].focus();

                return false;
            }


            // Website

            if (website != "" && website != null)
            {
                if (website.indexOf("http://") != 0 &&
                    website.indexOf("https://") != 0)
                {
                    alert("Website should start with http:// or https://");

                    document.forms["myForm"]["website"].focus();

                    return false;
                }
            }


            // Status

            if (status == "" || status == null)
            {
                alert("Status is required");

                document.forms["myForm"]["status"].focus();

                return false;
            }


            alert("Form Submitted Successfully");

            return true;
        }

    </script>

</head>


<body>

<div class="registration-page">


    <!-- LEFT SIDE -->

    <div class="registration-brand">

        <div class="brand-logo">
            CampusConnect
        </div>

        <div class="brand-content">

            <span class="brand-label">
                COMPANY PORTAL
            </span>

            <h1>
                Join CampusConnect
            </h1>

            <p>
                Create your company account and connect
                with talented students from partner colleges.
            </p>

        </div>

    </div>


    <!-- RIGHT SIDE -->

    <div class="registration-section">

        <div class="registration-box">

            <h2>
                Create company account
            </h2>

            <p class="subtitle">
                Register your company to start recruiting
                through CampusConnect.
            </p>


            <p class="mandatory-note">
                <span>*</span> Indicates Mandatory Fields
            </p>


            <form name="myForm"
                  method="post"
                  action="CompanyServlet"
                  onsubmit="return validateForm();">


                <!-- COMPANY INFORMATION -->

                <div class="form-section">

                    <h3>Company Information</h3>


                    <div class="form-row">

                        <div class="form-group">

                            <label>
                                Company Name
                                <span>*</span>
                            </label>

                            <input type="text"
                                   name="companyName"
                                   placeholder="Enter company name"
                                   onkeypress="return ((event.charCode>=65 && event.charCode<=90)||(event.charCode>=97 && event.charCode<=122)||event.charCode==32)">

                        </div>


                        <div class="form-group">

                            <label>
                                Email ID
                                <span>*</span>
                            </label>

                            <input type="email"
                                   name="email"
                                   placeholder="Enter company email">

                        </div>

                    </div>


                    <div class="form-row">

                        <div class="form-group">

                            <label>
                                Phone Number
                                <span>*</span>
                            </label>

                            <input type="text"
                                   name="phone"
                                   maxlength="10"
                                   placeholder="10-digit phone number"
                                   onkeypress="return(event.charCode>=48 && event.charCode<=57)">

                        </div>


                        <div class="form-group">

                            <label>
                                Website
                            </label>

                            <input type="text"
                                   name="website"
                                   placeholder="https://example.com">

                        </div>

                    </div>


                    <div class="form-group full-width">

                        <label>
                            Address
                            <span>*</span>
                        </label>

                        <textarea name="address"
                                  rows="3"
                                  placeholder="Enter company address"></textarea>

                    </div>

                </div>


                <!-- ACCOUNT INFORMATION -->

                <div class="form-section">

                    <h3>Account Information</h3>


                    <div class="form-row">

                        <div class="form-group">

                            <label>
                                Password
                                <span>*</span>
                            </label>

                            <input type="password"
                                   name="password"
                                   placeholder="Minimum 6 characters">

                        </div>


                        <div class="form-group">

                            <label>
                                Confirm Password
                                <span>*</span>
                            </label>

                            <input type="password"
                                   name="confirmPassword"
                                   placeholder="Re-enter password">

                        </div>

                    </div>


                    <div class="form-group status-field">

                        <label>
                            Status
                            <span>*</span>
                        </label>

                        <input type="text"
                               name="status"
                               value="ACTIVE"
                               readonly>

                    </div>

                </div>


                <!-- BUTTONS -->

                <div class="form-buttons">

                    <input type="submit"
                           value="Create Company Account"
                           class="submit-button">

                    <input type="reset"
                           value="Reset"
                           class="reset-button">

                </div>


            </form>


            <div class="login-link">

                Already have a company account?

                <a href="company-login.jsp">
                    Sign In
                </a>

            </div>

        </div>

    </div>

</div>

</body>

</html>