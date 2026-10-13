<%@ page import="com.campusconnect.bean.Company" %>

<%
    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    Company c = new Company();
    c.setCompanyId(companyId);

    boolean result = c.SelectMethod();

    if (!result) {
        out.println("Unable to load company details.");
        return;
    }

    String companyLogo = "";
    String companyInitial = "";

    String companyName = c.getCompanyName();

    if (companyName != null && companyName.length() > 0) {
        companyInitial = companyName.substring(0, 1).toUpperCase();
    }

    if ("TCS".equalsIgnoreCase(companyName)) {
        companyLogo = "images/company/tcs-logo.png";
    }
    else if ("Infosys".equalsIgnoreCase(companyName)) {
        companyLogo = "images/company/infosys-logo.png";
    }
    else if ("Google".equalsIgnoreCase(companyName)) {
        companyLogo = "images/company/google-logo.png";
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Edit Company Profile - CampusConnect</title>


    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;

            font-family: "Segoe UI", Arial, sans-serif;

            background: #f4f7fb;

            color: #0f355b;
        }


        /* ---------- HEADER ---------- */

        .top-header {

            background: white;

            padding: 28px 60px;

            border-bottom: 1px solid #e2e8f0;

            display: flex;

            justify-content: space-between;

            align-items: center;
        }


        .page-title {

            margin: 0;

            font-size: 34px;

            font-weight: 700;

            color: #0b355d;
        }


        .page-subtitle {

            margin-top: 6px;

            font-size: 16px;

            color: #7185a0;
        }


        .back-link {

            text-decoration: none;

            color: #0878e8;

            font-size: 16px;

            font-weight: 600;
        }


        .back-link:hover {

            color: #005ec4;
        }


        /* ---------- MAIN ---------- */

        .main-container {

            max-width: 1050px;

            margin: 40px auto;

            padding: 0 25px;
        }


        /* ---------- COMPANY HEADER ---------- */

        .company-header {

            background: linear-gradient(
                110deg,
                #155b96,
                #087bea
            );

            border-radius: 20px;

            padding: 30px 35px;

            display: flex;

            align-items: center;

            gap: 22px;

            color: white;

            box-shadow:
                0 12px 30px
                rgba(20, 91, 150, 0.18);

            margin-bottom: 28px;
        }


        .company-logo-box {

            width: 78px;

            height: 78px;

            background: white;

            border-radius: 16px;

            display: flex;

            align-items: center;

            justify-content: center;

            overflow: hidden;

            flex-shrink: 0;
        }


        .company-logo {

            width: 68px;

            height: 68px;

            object-fit: contain;
        }


        .company-initial {

            font-size: 38px;

            font-weight: 700;

            color: #087bea;
        }


        .company-name {

            margin: 0;

            font-size: 28px;

            color: white;
        }


        .company-email {

            margin-top: 5px;

            color: rgba(255,255,255,0.9);

            font-size: 15px;
        }


        /* ---------- FORM CARD ---------- */

        .form-card {

            background: white;

            border: 1px solid #e2e8f0;

            border-radius: 18px;

            box-shadow:
                0 8px 25px
                rgba(15, 53, 91, 0.06);

            overflow: hidden;
        }


        .form-header {

            padding: 30px 35px;

            border-bottom: 1px solid #e8edf3;
        }


        .form-title {

            margin: 0;

            font-size: 24px;

            color: #0b355d;
        }


        .form-description {

            margin: 7px 0 0;

            color: #7185a0;

            font-size: 15px;
        }


        .form-body {

            padding: 35px;
        }


        /* ---------- FORM GRID ---------- */

        .form-grid {

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 26px;
        }


        .form-group {

            display: flex;

            flex-direction: column;

            gap: 8px;
        }


        .full-width {

            grid-column: 1 / -1;
        }


        label {

            font-size: 15px;

            font-weight: 600;

            color: #24496f;
        }


        .required {

            color: #e55353;
        }


        input,
        textarea {

            width: 100%;

            padding: 14px 15px;

            border: 1px solid #cfd9e5;

            border-radius: 9px;

            font-family: inherit;

            font-size: 15px;

            color: #163d65;

            background: white;

            outline: none;

            transition: 0.2s;
        }


        input:focus,
        textarea:focus {

            border-color: #087bea;

            box-shadow:
                0 0 0 3px
                rgba(8,123,234,0.10);
        }


        input[readonly] {

            background: #f1f5f9;

            color: #7185a0;

            cursor: not-allowed;
        }


        textarea {

            min-height: 120px;

            resize: vertical;
        }


        /* ---------- STATUS ---------- */

        .status-box {

            width: 100%;

            padding: 14px 15px;

            border-radius: 9px;

            border: 1px solid #bfe7d0;

            background: #ecfaf2;

            color: #087a49;

            font-weight: 700;

            font-size: 15px;
        }


        .status-dot {

            display: inline-block;

            width: 8px;

            height: 8px;

            border-radius: 50%;

            background: #16b66a;

            margin-right: 7px;
        }


        /* ---------- BUTTON AREA ---------- */

        .button-area {

            margin-top: 32px;

            padding-top: 25px;

            border-top: 1px solid #e8edf3;

            display: flex;

            gap: 12px;
        }


        .button {

            display: inline-block;

            padding: 13px 25px;

            border-radius: 9px;

            font-family: inherit;

            font-size: 15px;

            font-weight: 700;

            text-decoration: none;

            cursor: pointer;

            border: none;
        }


        .save-button {

            background: #087bea;

            color: white;
        }


        .save-button:hover {

            background: #0568ca;
        }


        .reset-button {

            background: white;

            color: #24496f;

            border: 1px solid #cfd9e5;
        }


        .reset-button:hover {

            background: #f4f7fb;
        }


        .cancel-button {

            background: white;

            color: #24496f;

            border: 1px solid #cfd9e5;
        }


        .cancel-button:hover {

            background: #f4f7fb;
        }


        /* ---------- RESPONSIVE ---------- */

        @media (max-width: 750px) {

            .top-header {

                padding: 25px;

                flex-direction: column;

                align-items: flex-start;

                gap: 15px;
            }


            .form-grid {

                grid-template-columns: 1fr;
            }


            .full-width {

                grid-column: auto;
            }


            .company-header {

                padding: 25px;
            }


            .form-body {

                padding: 25px;
            }
        }


        @media (max-width: 500px) {

            .button-area {

                flex-direction: column;
            }

            .button {

                text-align: center;

                width: 100%;
            }
        }

    </style>

</head>


<body>


<!-- ================= HEADER ================= -->

<header class="top-header">

    <div>

        <h1 class="page-title">
            Edit Company Profile
        </h1>

        <div class="page-subtitle">
            Update your company information
        </div>

    </div>


    <a
        href="company-profile.jsp"
        class="back-link"
    >
        Back to Profile
    </a>

</header>



<!-- ================= MAIN ================= -->

<div class="main-container">


    <!-- COMPANY HEADER -->

    <div class="company-header">


        <div class="company-logo-box">

            <%

                if(companyLogo != null && !companyLogo.isEmpty())

                {

            %>

                <img
                    src="<%= companyLogo %>"
                    class="company-logo"
                    alt="<%= companyName %> Logo"
                >

            <%

                }

                else

                {

            %>

                <span class="company-initial">
                    <%= companyInitial %>
                </span>

            <%

                }

            %>

        </div>


        <div>

            <h2 class="company-name">
                <%= companyName %>
            </h2>

            <div class="company-email">
                <%= c.getEmail() %>
            </div>

        </div>


    </div>



    <!-- FORM CARD -->

    <div class="form-card">


        <div class="form-header">

            <h2 class="form-title">
                Company Information
            </h2>

            <p class="form-description">
                Update the details below and save your changes.
            </p>

        </div>



        <div class="form-body">


            <form
                method="post"
                action="company-update.jsp"
            >


                <div class="form-grid">


                    <!-- COMPANY ID -->

                    <div class="form-group">

                        <label>
                            Company ID
                        </label>

                        <input
                            type="text"
                            name="companyId"
                            value="<%= c.getCompanyId() %>"
                            readonly
                        >

                    </div>



                    <!-- COMPANY NAME -->

                    <div class="form-group">

                        <label>
                            Company Name
                            <span class="required">*</span>
                        </label>

                        <input
                            type="text"
                            name="companyName"
                            value="<%= c.getCompanyName() %>"
                            required
                        >

                    </div>



                    <!-- EMAIL -->

                    <div class="form-group">

                        <label>
                            Email Address
                        </label>

                        <input
                            type="email"
                            value="<%= c.getEmail() %>"
                            readonly
                        >

                    </div>



                    <!-- PHONE -->

                    <div class="form-group">

                        <label>
                            Phone Number
                            <span class="required">*</span>
                        </label>

                        <input
                            type="text"
                            name="phone"
                            value="<%= c.getPhone() %>"
                            required
                        >

                    </div>



                    <!-- ADDRESS -->

                    <div class="form-group full-width">

                        <label>
                            Company Address
                            <span class="required">*</span>
                        </label>

                        <textarea
                            name="address"
                            required
                        ><%= c.getAddress() %></textarea>

                    </div>



                    <!-- WEBSITE -->

                    <div class="form-group">

                        <label>
                            Official Website
                        </label>

                        <input
                            type="text"
                            name="website"
                            value="<%= c.getWebsite() %>"
                        >

                    </div>



                    <!-- STATUS -->

                    <div class="form-group">

                        <label>
                            Account Status
                        </label>

                        <div class="status-box">

                            <span class="status-dot"></span>

                            <%= c.getStatus() %>

                        </div>

                    </div>


                </div>



                <!-- BUTTONS -->

                <div class="button-area">


                    <button
                        type="submit"
                        class="button save-button"
                    >
                        Save Changes
                    </button>


                    <button
                        type="reset"
                        class="button reset-button"
                    >
                        Reset
                    </button>


                    <a
                        href="company-profile.jsp"
                        class="button cancel-button"
                    >
                        Cancel
                    </a>


                </div>


            </form>


        </div>


    </div>


</div>


</body>

</html>