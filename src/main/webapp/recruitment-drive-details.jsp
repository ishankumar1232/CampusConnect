<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.campusconnect.bean.RecruitmentDrive" %>

<%
    Integer companyId = (Integer) session.getAttribute("companyId");
    String companyName = (String) session.getAttribute("companyName");
    String email = (String) session.getAttribute("email");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveId = request.getParameter("driveId");

    if (driveId == null || driveId.trim().equals("")) {
        response.sendRedirect("company-dashboard.jsp");
        return;
    }

    RecruitmentDrive r = new RecruitmentDrive();
    r.setCompanyId(companyId);
    r.setDriveId(Integer.parseInt(driveId));

    ResultSet rs = r.SelectByIdMethod();
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Recruitment Drive Details</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f8fc;
            color: #123b63;
        }

        .header {
            background: #ffffff;
            padding: 34px 4%;
            border-bottom: 1px solid #dce6ef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 34px;
            margin-bottom: 8px;
            color: #0d3b66;
        }

        .header p {
            color: #6683a1;
            font-size: 17px;
        }

        .back-link {
            color: #087ff5;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
        }

        .container {
            width: 86%;
            max-width: 1250px;
            margin: 42px auto;
        }

        .company-banner {
            background: linear-gradient(135deg, #17649e, #087ff5);
            border-radius: 22px;
            padding: 30px 42px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            box-shadow: 0 12px 30px rgba(15, 110, 190, 0.18);
        }

        .company-left {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .company-logo {
            width: 92px;
            height: 92px;
            background: white;
            border-radius: 18px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }

        .company-logo img {
            max-width: 82%;
            max-height: 82%;
            object-fit: contain;
        }

        .company-logo .fallback {
            color: #087ff5;
            font-size: 35px;
            font-weight: bold;
        }

        .company-info h2 {
            font-size: 30px;
            margin-bottom: 8px;
        }

        .company-info p {
            font-size: 16px;
            opacity: 0.9;
        }

        .status {
            border: 1px solid rgba(255,255,255,0.55);
            padding: 12px 22px;
            border-radius: 30px;
            font-weight: bold;
            font-size: 14px;
        }

        .main-card {
            background: white;
            border-radius: 20px;
            border: 1px solid #e0e8f0;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(20, 70, 110, 0.06);
        }

        .card-header {
            padding: 28px 36px;
            border-bottom: 1px solid #e3ebf2;
        }

        .card-header h2 {
            color: #0d3b66;
            font-size: 25px;
            margin-bottom: 7px;
        }

        .card-header p {
            color: #7188a1;
        }

        .details {
            padding: 12px 36px 30px;
        }

        .row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 21px 0;
            border-bottom: 1px solid #edf1f5;
            gap: 30px;
        }

        .row:last-child {
            border-bottom: none;
        }

        .label {
            width: 30%;
            color: #52708e;
            font-weight: bold;
        }

        .value {
            width: 70%;
            color: #123b63;
            text-align: right;
            line-height: 1.6;
        }

        .description {
            text-align: left;
            white-space: pre-wrap;
        }

        .status-active {
            display: inline-block;
            background: #e6f8ef;
            color: #07844b;
            padding: 8px 17px;
            border-radius: 20px;
            font-weight: bold;
        }

        .buttons {
            padding: 25px 36px;
            border-top: 1px solid #e3ebf2;
            display: flex;
            gap: 14px;
        }

        .btn {
            text-decoration: none;
            padding: 13px 24px;
            border-radius: 9px;
            font-weight: bold;
            font-size: 15px;
            display: inline-block;
        }

        .btn-primary {
            background: #087ff5;
            color: white;
        }

        .btn-primary:hover {
            background: #066dcc;
        }

        .btn-secondary {
            background: white;
            color: #365d80;
            border: 1px solid #cbd9e6;
        }

        .btn-secondary:hover {
            background: #f4f8fc;
        }

        @media(max-width: 800px) {

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .company-banner {
                flex-direction: column;
                align-items: flex-start;
                gap: 25px;
            }

            .row {
                flex-direction: column;
                gap: 8px;
            }

            .label,
            .value {
                width: 100%;
                text-align: left;
            }

        }

    </style>

</head>

<body>

<div class="header">

    <div>
        <h1>Recruitment Drive Details</h1>
        <p>View complete information about this recruitment opportunity.</p>
    </div>

    <a class="back-link" href="company-dashboard.jsp">
        Back to Dashboard
    </a>

</div>

<div class="container">

    <div class="company-banner">

        <div class="company-left">

            <div class="company-logo">

                <%
                    String logoPath = "";

                    if (companyName != null &&
                        companyName.equalsIgnoreCase("TCS")) {

                        logoPath = "images/company/tcs-logo.png";

                    } else if (companyName != null &&
                               companyName.equalsIgnoreCase("Infosys")) {

                        logoPath = "images/company/infosys-logo.png";

                    } else if (companyName != null &&
                               companyName.equalsIgnoreCase("Google")) {

                        logoPath = "images/company/google-logo.png";
                    }
                %>

                <% if (!logoPath.equals("")) { %>

                    <img src="<%= logoPath %>"
                         alt="<%= companyName %> Logo">

                <% } else { %>

                    <span class="fallback">
                        <%= companyName != null
                            ? companyName.substring(0,1).toUpperCase()
                            : "C" %>
                    </span>

                <% } %>

            </div>

            <div class="company-info">

                <h2><%= companyName %></h2>

                <p><%= email %></p>

            </div>

        </div>

        <div class="status">
            ACTIVE ACCOUNT
        </div>

    </div>


    <div class="main-card">

        <div class="card-header">

            <h2>Recruitment Drive Information</h2>

            <p>
                Complete job, eligibility and recruitment details.
            </p>

        </div>

        <%
            if (rs != null && rs.next()) {
        %>

        <div class="details">

            <div class="row">

                <div class="label">Drive ID</div>

                <div class="value">
                    #<%= rs.getInt("DRIVE_ID") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Drive Type</div>

                <div class="value">
                    <%= rs.getString("DRIVE_TYPE") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Job Title</div>

                <div class="value">
                    <%= rs.getString("JOB_TITLE") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Job Description</div>

                <div class="value description">
                    <%= rs.getString("DESCRIPTION") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Number of Vacancies</div>

                <div class="value">
                    <%= rs.getInt("VACANCY") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Minimum Eligibility CGPA</div>

                <div class="value">
                    <%= rs.getDouble("ELIGIBILITY_CGPA") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Required Branch</div>

                <div class="value">
                    <%= rs.getString("REQUIRED_BRANCH") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Required Skills</div>

                <div class="value description">
                    <%= rs.getString("REQUIRED_SKILLS") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Salary / CTC</div>

                <div class="value">
                    ₹ <%= rs.getDouble("SALARY") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Application Deadline</div>

                <div class="value">
                    <%= rs.getString("DEADLINE") %>
                </div>

            </div>

            <div class="row">

                <div class="label">Drive Status</div>

                <div class="value">

                    <span class="status-active">
                        ● <%= rs.getString("STATUS") %>
                    </span>

                </div>

            </div>

        </div>


        <div class="buttons">

            <a class="btn btn-primary"
               href="recruitment-drive-update.jsp?driveId=<%= rs.getInt("DRIVE_ID") %>">

                Update Drive

            </a>

            <a class="btn btn-secondary"
               href="company-dashboard.jsp">

                Back to Dashboard

            </a>

        </div>

        <%
            } else {
        %>

        <div style="padding:40px;text-align:center;">

            <h3>Recruitment Drive Not Found</h3>

            <p style="margin-top:10px;color:#7188a1;">
                The requested recruitment drive could not be found.
            </p>

            <br>

            <a class="btn btn-primary"
               href="company-dashboard.jsp">

                Back to Dashboard

            </a>

        </div>

        <%
            }
        %>

    </div>

</div>

</body>
</html>