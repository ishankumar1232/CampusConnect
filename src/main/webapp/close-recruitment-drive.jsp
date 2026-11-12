<%@ page import="com.campusconnect.bean.RecruitmentDrive" %>

<%
    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null)
    {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveId = request.getParameter("driveId");

    if (driveId == null)
    {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    RecruitmentDrive r = new RecruitmentDrive();

    r.setDriveId(Integer.parseInt(driveId));
    r.setCompanyId(companyId);

    boolean result = r.CloseMethod();
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <%
            if (result)
            {
        %>
            Recruitment Drive Closed
        <%
            }
            else
            {
        %>
            Unable to Close Recruitment Drive
        <%
            }
        %>
    </title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f8fc;
            color: #123f69;
            min-height: 100vh;
        }

        /* ================= HEADER ================= */

        .header {
            background: #ffffff;
            border-bottom: 1px solid #dce6ef;
            padding: 32px 4%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-left h1 {
            font-size: 36px;
            color: #124a78;
            margin-bottom: 8px;
        }

        .header-left p {
            font-size: 18px;
            color: #66809a;
        }

        .dashboard-link {
            text-decoration: none;
            color: #087cf0;
            font-size: 18px;
            font-weight: bold;
        }

        .dashboard-link:hover {
            text-decoration: underline;
        }

        /* ================= MAIN ================= */

        .main {
            min-height: calc(100vh - 130px);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 70px 20px;
        }

        .result-card {
            width: 100%;
            max-width: 1000px;
            background: #ffffff;
            border: 1px solid #dce6ef;
            border-radius: 24px;
            padding: 64px 70px;
            text-align: center;
            box-shadow: 0 18px 45px rgba(22, 70, 110, 0.10);
        }

        /* ================= SUCCESS ICON ================= */

        .success-icon {
            width: 102px;
            height: 102px;
            margin: 0 auto 30px;

            border-radius: 50%;

            background: #eafaf1;
            border: 2px solid #b9ebcf;

            display: flex;
            align-items: center;
            justify-content: center;
        }

        .success-check {
            width: 42px;
            height: 24px;

            border-left: 6px solid #159957;
            border-bottom: 6px solid #159957;

            transform: rotate(-45deg);
            margin-top: -8px;
        }

        /* ================= ERROR ICON ================= */

        .error-icon {
            width: 102px;
            height: 102px;
            margin: 0 auto 30px;

            border-radius: 50%;

            background: #fff1f1;
            border: 2px solid #f4c5c5;

            display: flex;
            align-items: center;
            justify-content: center;
        }

        .error-cross {
            position: relative;
            width: 42px;
            height: 42px;
        }

        .error-cross:before,
        .error-cross:after {
            content: "";
            position: absolute;
            width: 6px;
            height: 48px;
            background: #d93025;
            top: -3px;
            left: 18px;
            border-radius: 5px;
        }

        .error-cross:before {
            transform: rotate(45deg);
        }

        .error-cross:after {
            transform: rotate(-45deg);
        }

        /* ================= TEXT ================= */

        .result-card h2 {
            font-size: 34px;
            color: #123f69;
            margin-bottom: 18px;
        }

        .result-message {
            max-width: 650px;
            margin: 0 auto;

            font-size: 18px;
            line-height: 1.7;
            color: #657f98;
        }

        /* ================= STATUS ================= */

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            margin-top: 30px;
            padding: 12px 25px;

            border-radius: 30px;

            font-size: 16px;
            font-weight: bold;
        }

        .status-badge.closed {
            background: #fff6e8;
            border: 1px solid #ffd18a;
            color: #a86600;
        }

        .status-badge.failed {
            background: #fff1f1;
            border: 1px solid #f1bcbc;
            color: #b42318;
        }

        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .closed .status-dot {
            background: #e99a00;
        }

        .failed .status-dot {
            background: #d93025;
        }

        /* ================= BUTTONS ================= */

        .buttons {
            margin-top: 38px;

            display: flex;
            justify-content: center;
            gap: 16px;

            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            min-width: 220px;

            padding: 15px 28px;

            border-radius: 9px;

            text-decoration: none;

            font-size: 17px;
            font-weight: bold;

            transition: all 0.2s ease;
        }

        .btn-primary {
            background: #087ff5;
            color: white;
            box-shadow: 0 8px 18px rgba(8, 127, 245, 0.20);
        }

        .btn-primary:hover {
            background: #066ed5;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #ffffff;
            color: #087ff5;
            border: 1px solid #b9d7f5;
        }

        .btn-secondary:hover {
            background: #f2f8ff;
        }

        /* ================= FOOTER NOTE ================= */

        .note {
            margin-top: 32px;
            font-size: 14px;
            color: #8a9caf;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 700px) {

            .header {
                padding: 25px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 18px;
            }

            .header-left h1 {
                font-size: 30px;
            }

            .main {
                padding: 35px 15px;
            }

            .result-card {
                padding: 45px 25px;
            }

            .result-card h2 {
                font-size: 27px;
            }

            .result-message {
                font-size: 16px;
            }

            .btn {
                width: 100%;
            }

            .buttons {
                flex-direction: column;
            }
        }

    </style>

</head>


<body>


<!-- ================= HEADER ================= -->

<div class="header">

    <div class="header-left">

        <h1>Recruitment Drive</h1>

        <p>
            Manage and track your company's recruitment opportunities.
        </p>

    </div>


    <a href="company-dashboard.jsp"
       class="dashboard-link">

        Back to Dashboard

    </a>

</div>



<!-- ================= MAIN ================= -->

<div class="main">

    <div class="result-card">


        <%
            if (result)
            {
        %>


        <!-- SUCCESS ICON -->

        <div class="success-icon">

            <div class="success-check"></div>

        </div>


        <h2>
            Recruitment Drive Closed Successfully
        </h2>


        <p class="result-message">

            The recruitment drive has been successfully closed.
            This drive is no longer active for recruitment.

        </p>


        <div class="status-badge closed">

            <span class="status-dot"></span>

            DRIVE STATUS: CLOSED

        </div>


        <div class="buttons">

            <a href="view-recruitment-drives.jsp"
               class="btn btn-primary">

                View Recruitment Drives

            </a>


            <a href="company-dashboard.jsp"
               class="btn btn-secondary">

                Back to Dashboard

            </a>

        </div>


        <p class="note">

            You can view your closed recruitment drive from the
            Recruitment Drives section.

        </p>


        <%
            }
            else
            {
        %>


        <!-- ERROR ICON -->

        <div class="error-icon">

            <div class="error-cross"></div>

        </div>


        <h2>
            Unable to Close Recruitment Drive
        </h2>


        <p class="result-message">

            We could not close this recruitment drive.
            Please try again or return to the Recruitment Drives
            section.

        </p>


        <div class="status-badge failed">

            <span class="status-dot"></span>

            DRIVE STATUS: NOT CLOSED

        </div>


        <div class="buttons">

            <a href="view-recruitment-drives.jsp"
               class="btn btn-primary">

                Back to Recruitment Drives

            </a>


            <a href="company-dashboard.jsp"
               class="btn btn-secondary">

                Back to Dashboard

            </a>

        </div>


        <p class="note">

            If the problem continues, please check the recruitment
            drive details and try again.

        </p>


        <%
            }
        %>


    </div>

</div>


</body>

</html>