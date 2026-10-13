<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.campusconnect.bean.RecruitmentDrive" %>

<%
    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveId = request.getParameter("driveId");

    if (driveId == null || driveId.trim().equals("")) {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    RecruitmentDrive r = new RecruitmentDrive();

    r.setCompanyId(companyId);
    r.setDriveId(Integer.parseInt(driveId));

    ResultSet rs = r.SelectByIdMethod();

    if (rs == null || !rs.next()) {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    String dbDeadline = "";

    if (rs.getDate("DEADLINE") != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        dbDeadline = sdf.format(rs.getDate("DEADLINE"));
    }

    String currentStatus = rs.getString("STATUS");
    String currentDriveType = rs.getString("DRIVE_TYPE");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Edit Recruitment Drive</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f8fc;
            color: #123b63;
        }

        .header {
            background: white;
            padding: 35px 4%;
            border-bottom: 1px solid #dce6ef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            margin: 0;
            font-size: 32px;
            color: #0c4778;
        }

        .header p {
            margin-top: 8px;
            color: #66809b;
            font-size: 17px;
        }

        .back-dashboard {
            color: #087df0;
            text-decoration: none;
            font-weight: bold;
            font-size: 17px;
        }

        .container {
            width: 82%;
            margin: 45px auto;
        }

        .company-card {
            background: linear-gradient(110deg, #176da7, #087ff0);
            border-radius: 24px;
            padding: 35px 45px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 12px 30px rgba(0, 90, 160, 0.15);
            margin-bottom: 35px;
        }

        .company-info h2 {
            margin: 0 0 8px;
            font-size: 32px;
        }

        .company-info p {
            margin: 0;
            font-size: 18px;
        }

        .account-status {
            border: 1px solid rgba(255,255,255,0.7);
            padding: 13px 25px;
            border-radius: 30px;
            font-weight: bold;
        }

        .form-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            overflow: hidden;
        }

        .form-header {
            padding: 35px 45px;
            border-bottom: 1px solid #e0e8f0;
        }

        .form-header h2 {
            margin: 0;
            font-size: 29px;
            color: #0d4678;
        }

        .form-header p {
            margin-top: 10px;
            color: #7189a2;
            font-size: 16px;
        }

        form {
            padding: 35px 45px;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px 32px;
        }

        .full {
            grid-column: 1 / 3;
        }

        label {
            display: block;
            margin-bottom: 9px;
            font-weight: bold;
            color: #123f67;
            font-size: 16px;
        }

        .required {
            color: #e53935;
        }

        input,
        select,
        textarea {
            width: 100%;
            border: 1px solid #cbdbea;
            border-radius: 11px;
            padding: 14px 16px;
            font-size: 16px;
            font-family: Arial, sans-serif;
            color: #173f63;
            background: white;
            outline: none;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #087ff0;
            box-shadow: 0 0 0 3px rgba(8,127,240,0.10);
        }

        input[readonly] {
            background: #eef4f9;
            color: #6a8298;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .date-note {
            margin-top: 7px;
            font-size: 13px;
            color: #7890a6;
        }

        .status-box {
            background: #e9f9f1;
            color: #00834b;
            border: 1px solid #b9ecd4;
            border-radius: 11px;
            padding: 14px 16px;
            font-weight: bold;
        }

        .actions {
            margin-top: 35px;
            padding-top: 28px;
            border-top: 1px solid #e0e8f0;
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 14px 28px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            border: none;
            background: #087ff0;
            color: white;
        }

        .btn-primary:hover {
            background: #066dcc;
        }

        .btn-secondary {
            background: white;
            color: #496b89;
            border: 1px solid #cbdbea;
        }

        .btn-secondary:hover {
            background: #f4f8fc;
        }

        @media(max-width: 800px) {

            .container {
                width: 94%;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: 1;
            }

            .company-card {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

        }

    </style>

</head>

<body>

<div class="header">

    <div>
        <h1>Edit Recruitment Drive</h1>
        <p>Modify your recruitment opportunity details.</p>
    </div>

    <a href="company-dashboard.jsp" class="back-dashboard">
        Back to Dashboard
    </a>

</div>


<div class="container">

    <div class="company-card">

        <div class="company-info">

            <h2>TCS</h2>

            <p>tcs@gmail.com</p>

        </div>

        <div class="account-status">
            ACTIVE ACCOUNT
        </div>

    </div>


    <div class="form-card">

        <div class="form-header">

            <h2>Recruitment Drive Information</h2>

            <p>
                Update the details below and save your changes.
            </p>

        </div>


        <form method="post"
              action="recruitment-drive-update.jsp">

            <div class="grid">


                <!-- DRIVE ID -->

                <div>

                    <label>Drive ID</label>

                    <input type="text"
                           value="<%= rs.getInt("DRIVE_ID") %>"
                           readonly>

                    <input type="hidden"
                           name="driveId"
                           value="<%= rs.getInt("DRIVE_ID") %>">

                </div>


                <!-- DRIVE TYPE -->

                <div>

                    <label>
                        Drive Type <span class="required">*</span>
                    </label>

                    <select name="driveType" required>

                        <option value="On Campus"
                            <%= "On Campus".equalsIgnoreCase(currentDriveType) ? "selected" : "" %>>
                            On Campus
                        </option>

                        <option value="Off Campus"
                            <%= "Off Campus".equalsIgnoreCase(currentDriveType) ? "selected" : "" %>>
                            Off Campus
                        </option>

                    </select>

                </div>


                <!-- JOB TITLE -->

                <div class="full">

                    <label>
                        Job Title <span class="required">*</span>
                    </label>

                    <input type="text"
                           name="jobTitle"
                           value="<%= rs.getString("JOB_TITLE") %>"
                           required>

                </div>


                <!-- DESCRIPTION -->

                <div class="full">

                    <label>
                        Job Description <span class="required">*</span>
                    </label>

                    <textarea name="description"
                              required><%= rs.getString("DESCRIPTION") %></textarea>

                </div>


                <!-- VACANCY -->

                <div>

                    <label>
                        Number of Vacancies <span class="required">*</span>
                    </label>

                    <input type="number"
                           name="vacancy"
                           value="<%= rs.getInt("VACANCY") %>"
                           min="1"
                           required>

                </div>


                <!-- CGPA -->

                <div>

                    <label>
                        Minimum Eligibility CGPA <span class="required">*</span>
                    </label>

                    <input type="number"
                           name="eligibilityCgpa"
                           value="<%= rs.getDouble("ELIGIBILITY_CGPA") %>"
                           step="0.01"
                           min="0"
                           max="10"
                           required>

                </div>


                <!-- BRANCH -->

                <div>

                    <label>
                        Required Branch <span class="required">*</span>
                    </label>

                    <input type="text"
                           name="requiredBranch"
                           value="<%= rs.getString("REQUIRED_BRANCH") %>"
                           required>

                </div>


                <!-- SALARY -->

                <div>

                    <label>
                        Salary / CTC <span class="required">*</span>
                    </label>

                    <input type="number"
                           name="salary"
                           value="<%= rs.getDouble("SALARY") %>"
                           step="0.01"
                           min="0"
                           required>

                </div>


                <!-- SKILLS -->

                <div class="full">

                    <label>
                        Required Skills <span class="required">*</span>
                    </label>

                    <textarea name="requiredSkills"
                              required><%= rs.getString("REQUIRED_SKILLS") %></textarea>

                </div>


                <!-- DEADLINE -->

                <div>

                    <label>
                        Application Deadline <span class="required">*</span>
                    </label>

                    <input type="text"
                           name="deadline"
                           value="<%= dbDeadline %>"
                           placeholder="DD-MM-YYYY"
                           pattern="[0-9]{2}-[0-9]{2}-[0-9]{4}"
                           required>

                    <div class="date-note">
                        Format: DD-MM-YYYY
                    </div>

                </div>


                <!-- STATUS -->

                <div>

                    <label>Drive Status</label>

                    <select name="status">

                        <option value="ACTIVE"
                            <%= "ACTIVE".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>
                            ACTIVE
                        </option>

                        <option value="CLOSED"
                            <%= "CLOSED".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>
                            CLOSED
                        </option>

                    </select>

                </div>


            </div>


            <div class="actions">

                <button type="submit" class="btn btn-primary">
                    Update Recruitment Drive
                </button>

                <a href="view-recruitment-drives.jsp"
                   class="btn btn-secondary">
                    Cancel
                </a>

            </div>

        </form>

    </div>

</div>

</body>
</html>