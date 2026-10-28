<%@ page import="com.campusconnect.bean.RecruitmentDrive" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    Integer companyId = (Integer) session.getAttribute("companyId");
    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveType = request.getParameter("driveType");
    String jobTitle = request.getParameter("jobTitle");
    String description = request.getParameter("description");
    String vacancy = request.getParameter("vacancy");
    String eligibilityCgpa = request.getParameter("eligibilityCgpa");
    String requiredBranch = request.getParameter("requiredBranch");
    String requiredSkills = request.getParameter("requiredSkills");
    String salary = request.getParameter("salary");
    String deadline = request.getParameter("deadline");
    String status = request.getParameter("status");

    boolean result = false;
    String resultTitle = "Recruitment Drive Creation Failed";
    String resultMessage = "Unable to create the recruitment drive. Please check the details and try again.";

    try {
        boolean missingRequiredValue =
                driveType == null || driveType.trim().isEmpty() ||
                jobTitle == null || jobTitle.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                vacancy == null || vacancy.trim().isEmpty() ||
                eligibilityCgpa == null || eligibilityCgpa.trim().isEmpty() ||
                requiredBranch == null || requiredBranch.trim().isEmpty() ||
                requiredSkills == null || requiredSkills.trim().isEmpty() ||
                salary == null || salary.trim().isEmpty() ||
                deadline == null || deadline.trim().isEmpty() ||
                status == null || status.trim().isEmpty();

        if (!missingRequiredValue) {
            RecruitmentDrive drive = new RecruitmentDrive();
            drive.setCompanyId(companyId);
            drive.setDriveType(driveType.trim());
            drive.setJobTitle(jobTitle.trim());
            drive.setDescription(description.trim());
            drive.setVacancy(Integer.parseInt(vacancy.trim()));
            drive.setEligibilityCgpa(Double.parseDouble(eligibilityCgpa.trim()));
            drive.setRequiredBranch(requiredBranch.trim());
            drive.setRequiredSkills(requiredSkills.trim());
            drive.setSalary(Double.parseDouble(salary.trim()));
            drive.setDeadline(deadline.trim());
            drive.setStatus(status.trim());

            result = drive.InsertMethod();
        } else {
            resultMessage = "Some required details are missing. Please complete the form and try again.";
        }

        if (result) {
            resultTitle = "Recruitment Drive Created Successfully";
            resultMessage = "Your recruitment drive is now available to manage.";
        }
    } catch (Exception e) {
        application.log("Recruitment drive creation failed.", e);
        resultMessage = "The recruitment drive could not be created. Please review the form and try again.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= resultTitle %> | CampusConnect</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            margin: 0;
            padding: 32px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, Helvetica, sans-serif;
            color: #123d6b;
            background:
                radial-gradient(circle at 12% 10%, rgba(23, 111, 229, 0.10), transparent 30%),
                #f3f7fc;
        }

        .page-shell {
            width: min(100%, 760px);
        }

        .brand {
            margin: 0 0 18px 8px;
            color: #123d6b;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand span {
            color: #176fe5;
        }

        .result-card {
            overflow: hidden;
            border: 1px solid #e0e9f3;
            border-radius: 22px;
            background: #ffffff;
            box-shadow: 0 22px 55px rgba(25, 70, 120, 0.12);
        }

        .result-accent {
            height: 8px;
            background: linear-gradient(90deg, #2867bd, #176fe3);
        }

        .result-content {
            padding: clamp(32px, 7vw, 60px);
            text-align: center;
        }

        .result-icon {
            width: 76px;
            height: 76px;
            margin: 0 auto 22px;
            display: grid;
            place-items: center;
            border-radius: 50%;
            font-size: 38px;
            font-weight: 700;
        }

        .result-icon.success {
            color: #07884e;
            background: #e7f8ef;
            border: 1px solid #bdebd2;
        }

        .result-icon.failure {
            color: #c73636;
            background: #fff0f0;
            border: 1px solid #f1c8c8;
        }

        .eyebrow {
            margin: 0 0 10px;
            color: #66809f;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1.6px;
            text-transform: uppercase;
        }

        h1 {
            margin: 0;
            color: #123d6b;
            font-size: clamp(26px, 5vw, 36px);
            line-height: 1.2;
        }

        .message {
            max-width: 520px;
            margin: 14px auto 30px;
            color: #66809f;
            font-size: 16px;
            line-height: 1.65;
        }

        .actions {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .button {
            min-height: 48px;
            padding: 14px 22px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid transparent;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            transition: background 0.2s, border-color 0.2s, transform 0.2s;
        }

        .button:hover {
            transform: translateY(-1px);
        }

        .button-primary {
            color: #ffffff;
            background: #176fe5;
        }

        .button-primary:hover {
            background: #0f60cc;
        }

        .button-secondary {
            color: #496b89;
            border-color: #d6e1ee;
            background: #ffffff;
        }

        .button-secondary:hover {
            border-color: #b9cce0;
            background: #f5f8fc;
        }

        @media (max-width: 520px) {
            body {
                padding: 20px 14px;
            }

            .actions {
                flex-direction: column;
            }

            .button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <main class="page-shell">
        <div class="brand">Campus<span>Connect</span></div>

        <section class="result-card" aria-labelledby="resultTitle">
            <div class="result-accent"></div>
            <div class="result-content">
                <div class="result-icon <%= result ? "success" : "failure" %>" aria-hidden="true">
                    <%= result ? "&#10003;" : "!" %>
                </div>
                <p class="eyebrow">Company Portal</p>
                <h1 id="resultTitle"><%= resultTitle %></h1>
                <p class="message"><%= resultMessage %></p>

                <div class="actions">
                    <% if (result) { %>
                        <a class="button button-primary" href="view-recruitment-drives.jsp">
                            View Recruitment Drives <span aria-hidden="true">&nbsp;→</span>
                        </a>
                        <a class="button button-secondary" href="company-dashboard.jsp">
                            Back to Dashboard
                        </a>
                    <% } else { %>
                        <a class="button button-primary" href="recruitment-drive.jsp">
                            Try Again
                        </a>
                        <a class="button button-secondary" href="view-recruitment-drives.jsp">
                            View Recruitment Drives
                        </a>
                    <% } %>
                </div>
            </div>
        </section>
    </main>
</body>
</html>