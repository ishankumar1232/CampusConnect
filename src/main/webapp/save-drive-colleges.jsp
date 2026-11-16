<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    Integer companyId = (Integer) session.getAttribute("companyId");
    String companyName = (String) session.getAttribute("companyName");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    if (companyName == null || companyName.trim().isEmpty()) {
        companyName = "Company Partner";
    }

    String driveIdParameter = request.getParameter("driveId");

    if (driveIdParameter == null || driveIdParameter.trim().isEmpty()) {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    int driveId;
    try {
        driveId = Integer.parseInt(driveIdParameter.trim());
    } catch (Exception e) {
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    String[] collegeIds = request.getParameterValues("collegeId");

    if (collegeIds == null || collegeIds.length == 0) {
        response.sendRedirect("select-drive-colleges.jsp?driveId=" + driveId);
        return;
    }

    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = null;
    Statement stmt = null;
    String jobTitle = "";
    String driveType = "";
    int inserted = 0;
    int alreadyExists = 0;
    int totalAssigned = 0;

    try {
        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        stmt = con.createStatement();

        // 1. Verify drive belongs to logged-in company
        String driveQuery =
            "SELECT DRIVE_ID, JOB_TITLE, DRIVE_TYPE " +
            "FROM RECRUITMENT_DRIVE " +
            "WHERE DRIVE_ID = " + driveId +
            " AND COMPANY_ID = " + companyId +
            " AND (UPPER(DRIVE_TYPE) = 'ON CAMPUS' OR UPPER(DRIVE_TYPE) = 'CAMPUS' OR UPPER(DRIVE_TYPE) = 'ON-CAMPUS')";

        ResultSet driveRs = stmt.executeQuery(driveQuery);

        if (!driveRs.next()) {
            driveRs.close();
            con.close();
            response.sendRedirect("view-recruitment-drives.jsp");
            return;
        }

        jobTitle = driveRs.getString("JOB_TITLE");
        driveType = driveRs.getString("DRIVE_TYPE");
        driveRs.close();

        // 2. Safely remove unselected colleges (only if no students from that college have applied yet)
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < collegeIds.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(Integer.parseInt(collegeIds[i].trim()));
        }

        String safeDelete =
            "DELETE FROM DRIVE_COLLEGE DC " +
            "WHERE DC.DRIVE_ID = " + driveId +
            " AND DC.COLLEGE_ID NOT IN (" + sb.toString() + ") " +
            " AND NOT EXISTS ( " +
            "   SELECT 1 FROM APPLICATION A " +
            "   JOIN STUDENT S ON A.STUDENT_ID = S.STUDENT_ID " +
            "   WHERE A.DRIVE_ID = DC.DRIVE_ID AND S.COLLEGE_ID = DC.COLLEGE_ID " +
            " )";
        stmt.executeUpdate(safeDelete);

        // 3. Insert newly selected colleges
        for (int i = 0; i < collegeIds.length; i++) {
            try {
                int collegeId = Integer.parseInt(collegeIds[i].trim());

                // Verify college exists and is active/approved
                String collegeQuery =
                    "SELECT COLLEGE_ID " +
                    "FROM COLLEGE " +
                    "WHERE COLLEGE_ID = " + collegeId +
                    " AND UPPER(STATUS) IN ('ACTIVE', 'APPROVED')";

                ResultSet collegeRs = stmt.executeQuery(collegeQuery);
                if (!collegeRs.next()) {
                    collegeRs.close();
                    continue;
                }
                collegeRs.close();

                // Check whether already assigned
                String checkQuery =
                    "SELECT COUNT(*) " +
                    "FROM DRIVE_COLLEGE " +
                    "WHERE DRIVE_ID = " + driveId +
                    " AND COLLEGE_ID = " + collegeId;

                ResultSet checkRs = stmt.executeQuery(checkQuery);
                checkRs.next();
                int count = checkRs.getInt(1);
                checkRs.close();

                if (count > 0) {
                    alreadyExists++;
                } else {
                    String insertQuery =
                        "INSERT INTO DRIVE_COLLEGE (DRIVE_ID, COLLEGE_ID) VALUES (" +
                        driveId + ", " + collegeId + ")";
                    int result = stmt.executeUpdate(insertQuery);
                    if (result > 0) {
                        inserted++;
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        // Count total currently assigned
        String totalQuery = "SELECT COUNT(*) FROM DRIVE_COLLEGE WHERE DRIVE_ID = " + driveId;
        ResultSet totalRs = stmt.executeQuery(totalQuery);
        if (totalRs.next()) {
            totalAssigned = totalRs.getInt(1);
        }
        totalRs.close();

    } catch (Exception e) {
        application.log("Error saving colleges for drive " + driveId, e);
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception ignore) {}
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Colleges Assigned Successfully | Drive #<%= driveId %> | CampusConnect</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --primary-light: #eff6ff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --success: #16a34a;
            --success-light: #dcfce7;
            --shadow-md: 0 10px 25px -5px rgba(0,0,0,0.06);
            --radius-lg: 16px;
            --radius-md: 12px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .topbar {
            height: 72px;
            background: linear-gradient(110deg, #08142d, #142b52);
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            box-shadow: 0 4px 20px rgba(8, 20, 45, 0.15);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: white;
            font-size: 21px;
            font-weight: 800;
        }

        .brand-mark {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: linear-gradient(135deg, #327ff4, #62b5ff);
            display: grid;
            place-items: center;
            font-size: 19px;
            color: white;
        }

        .brand span {
            color: #79b7ff;
        }

        .container {
            max-width: 680px;
            margin: 60px auto;
            padding: 0 24px;
            width: 100%;
        }

        .result-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 40px 32px;
            box-shadow: var(--shadow-md);
            text-align: center;
        }

        .success-icon-wrapper {
            width: 76px;
            height: 76px;
            border-radius: 50%;
            background: var(--success-light);
            color: var(--success);
            display: grid;
            place-items: center;
            font-size: 38px;
            margin: 0 auto 20px;
            animation: popIn 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        @keyframes popIn {
            0% { transform: scale(0.5); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .result-card h1 {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 8px;
        }

        .result-card p.subtitle {
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 28px;
            line-height: 1.5;
        }

        .stats-summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            margin-bottom: 32px;
        }

        .stat-box {
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 16px 12px;
        }

        .stat-box .number {
            font-size: 26px;
            font-weight: 800;
            color: var(--primary);
            line-height: 1.2;
        }

        .stat-box .label {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 4px;
            font-weight: 600;
        }

        .drive-info-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #f1f5f9;
            padding: 8px 16px;
            border-radius: 999px;
            font-size: 13px;
            color: #334155;
            font-weight: 600;
            margin-bottom: 32px;
        }

        .drive-info-pill span.dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #94a3b8;
        }

        .actions-row {
            display: flex;
            gap: 14px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: white;
            color: #334155;
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }
    </style>
</head>

<body>

    <header class="topbar">
        <a href="view-recruitment-drives.jsp" class="brand">
            <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
            <div>Campus<span>Connect</span></div>
        </a>
    </header>

    <main class="container">
        <div class="result-card">
            <div class="success-icon-wrapper">
                <i class="fa-solid fa-circle-check"></i>
            </div>

            <h1>Colleges Assigned Successfully</h1>
            <p class="subtitle">
                The targeted institutions have been updated in the system. Eligible students from these colleges can now view and apply for this placement drive.
            </p>

            <div class="drive-info-pill">
                <span><i class="fa-solid fa-hashtag"></i> Drive <%= driveId %></span>
                <span class="dot"></span>
                <span><i class="fa-solid fa-user-tie"></i> <%= jobTitle %></span>
                <span class="dot"></span>
                <span style="color: #16a34a;"><i class="fa-solid fa-network-wired"></i> <%= driveType %></span>
            </div>

            <div class="stats-summary">
                <div class="stat-box">
                    <div class="number" style="color: #16a34a;"><%= inserted %></div>
                    <div class="label">Newly Added</div>
                </div>
                <div class="stat-box">
                    <div class="number" style="color: #64748b;"><%= alreadyExists %></div>
                    <div class="label">Existing</div>
                </div>
                <div class="stat-box">
                    <div class="number" style="color: #2563eb;"><%= totalAssigned %></div>
                    <div class="label">Total Assigned</div>
                </div>
            </div>

            <div class="actions-row">
                <a href="select-drive-colleges.jsp?driveId=<%= driveId %>" class="btn btn-secondary">
                    <i class="fa-solid fa-pen-to-square"></i> Edit College Selection
                </a>
                <a href="view-recruitment-drives.jsp" class="btn btn-primary">
                    <i class="fa-solid fa-briefcase"></i> Return to Recruitment Drives
                </a>
            </div>
        </div>
    </main>

</body>
</html>
