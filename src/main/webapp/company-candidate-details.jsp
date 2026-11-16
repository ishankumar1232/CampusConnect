<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*, com.campusconnect.util.DBConnection" %>
<%!
private String esc(String value) {
    if (value == null) return "";
    return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
}

private String formatDate(java.util.Date date) {
    if (date == null) return "—";
    return new SimpleDateFormat("dd MMM yyyy").format(date);
}

private boolean isOnCampus(String driveType) {
    if (driveType == null) return false;
    String t = driveType.trim().toUpperCase(Locale.ROOT);
    return t.contains("ON CAMPUS") || (t.contains("CAMPUS") && !t.contains("OFF"));
}
%>

<%
Integer companyId = (Integer) session.getAttribute("companyId");
if (companyId == null) {
    response.sendRedirect("company-login.jsp");
    return;
}

String companyName = (String) session.getAttribute("companyName");
if (companyName == null || companyName.trim().isEmpty()) {
    companyName = "Company";
}

String companyInitial = companyName.trim().isEmpty() ? "C" : companyName.trim().substring(0, 1).toUpperCase(Locale.ROOT);

String offerCsrf = (String) session.getAttribute("offerCsrf");
if (offerCsrf == null) {
    offerCsrf = java.util.UUID.randomUUID().toString();
    session.setAttribute("offerCsrf", offerCsrf);
}

String appIdParam = request.getParameter("appId");
String studentIdParam = request.getParameter("studentId");

int targetAppId = 0;
int targetStudentId = 0;

try {
    if (appIdParam != null && !appIdParam.trim().isEmpty()) {
        targetAppId = Integer.parseInt(appIdParam.trim());
    }
    if (studentIdParam != null && !studentIdParam.trim().isEmpty()) {
        targetStudentId = Integer.parseInt(studentIdParam.trim());
    }
} catch (NumberFormatException ignored) {}

if (targetAppId <= 0 && targetStudentId <= 0) {
    response.sendRedirect("company-applicants.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

boolean found = false;

// Application and Student info
int applicationId = 0;
int studentId = 0;
String studentName = "";
String studentEmail = "";
String studentPhone = "";
String studentGender = "";
String studentStatus = "ACTIVE";
String collegeName = "";
String courseName = "";

int driveId = 0;
String jobTitle = "";
String driveType = "";
String salary = "";
java.sql.Date appliedDate = null;
String appStatus = "PENDING";
String collegeShortlistStatus = "PENDING";

// Additional dossier data
List<Map<String, Object>> academicList = new ArrayList<>();
List<String> skillList = new ArrayList<>();
List<Map<String, String>> projectList = new ArrayList<>();
String resumeFile = null;
java.sql.Date resumeDate = null;

try {
    con = DBConnection.getConnection();

    String appSql =
        "SELECT A.APPLICATION_ID, A.STUDENT_ID, A.STATUS AS APP_STATUS, A.COLLEGE_SHORTLIST_STATUS, A.APPLIED_DATE, " +
        "       S.NAME AS STUDENT_NAME, S.EMAIL AS STUDENT_EMAIL, S.PHONE AS STUDENT_PHONE, S.GENDER, S.STATUS AS STUDENT_STATUS, " +
        "       COL.COLLEGE_NAME, CR.COURSE_NAME, " +
        "       R.DRIVE_ID, R.JOB_TITLE, R.DRIVE_TYPE, R.SALARY " +
        "FROM APPLICATION A " +
        "JOIN STUDENT S ON A.STUDENT_ID = S.STUDENT_ID " +
        "LEFT JOIN COLLEGE COL ON S.COLLEGE_ID = COL.COLLEGE_ID " +
        "LEFT JOIN COURSE CR ON S.COURSE_ID = CR.COURSE_ID " +
        "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
        "WHERE R.COMPANY_ID = ? ";

    if (targetAppId > 0) {
        appSql += "AND A.APPLICATION_ID = ? ";
    } else {
        appSql += "AND A.STUDENT_ID = ? ";
    }

    ps = con.prepareStatement(appSql);
    ps.setInt(1, companyId);
    ps.setInt(2, targetAppId > 0 ? targetAppId : targetStudentId);
    rs = ps.executeQuery();

    if (rs.next()) {
        found = true;
        applicationId = rs.getInt("APPLICATION_ID");
        studentId = rs.getInt("STUDENT_ID");
        studentName = rs.getString("STUDENT_NAME");
        studentEmail = rs.getString("STUDENT_EMAIL");
        studentPhone = rs.getString("STUDENT_PHONE");
        studentGender = rs.getString("GENDER");
        studentStatus = rs.getString("STUDENT_STATUS");
        collegeName = rs.getString("COLLEGE_NAME");
        courseName = rs.getString("COURSE_NAME");

        driveId = rs.getInt("DRIVE_ID");
        jobTitle = rs.getString("JOB_TITLE");
        driveType = rs.getString("DRIVE_TYPE");
        salary = rs.getString("SALARY");
        appliedDate = rs.getDate("APPLIED_DATE");
        appStatus = rs.getString("APP_STATUS");
        collegeShortlistStatus = rs.getString("COLLEGE_SHORTLIST_STATUS");
    }

    if (found) {
        // 1. Resume
        try (PreparedStatement resPs = con.prepareStatement(
                "SELECT RESUME_FILE, UPLOADED_DATE FROM RESUME WHERE STUDENT_ID = ? ORDER BY RESUME_ID DESC")) {
            resPs.setInt(1, studentId);
            try (ResultSet resRs = resPs.executeQuery()) {
                if (resRs.next()) {
                    resumeFile = resRs.getString("RESUME_FILE");
                    resumeDate = resRs.getDate("UPLOADED_DATE");
                }
            }
        }

        // 2. Academic Records
        try (PreparedStatement acadPs = con.prepareStatement(
                "SELECT QUALIFICATION, YEAR, PERCENTAGE, CGPA, BACKLOGS FROM STUDENT_ACADEMIC WHERE STUDENT_ID = ? ORDER BY ACADEMIC_ID ASC")) {
            acadPs.setInt(1, studentId);
            try (ResultSet acadRs = acadPs.executeQuery()) {
                while (acadRs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("qualification", acadRs.getString("QUALIFICATION"));
                    m.put("year", acadRs.getInt("YEAR"));
                    m.put("percentage", acadRs.getDouble("PERCENTAGE"));
                    m.put("cgpa", acadRs.getDouble("CGPA"));
                    m.put("backlogs", acadRs.getInt("BACKLOGS"));
                    academicList.add(m);
                }
            }
        }

        // 3. Technical Skills
        try (PreparedStatement skPs = con.prepareStatement(
                "SELECT SKILL_NAME FROM STUDENT_SKILL WHERE STUDENT_ID = ? ORDER BY SKILL_NAME ASC")) {
            skPs.setInt(1, studentId);
            try (ResultSet skRs = skPs.executeQuery()) {
                while (skRs.next()) {
                    String sk = skRs.getString("SKILL_NAME");
                    if (sk != null && !sk.trim().isEmpty()) {
                        skillList.add(sk.trim());
                    }
                }
            }
        }

        // 4. Projects
        try (PreparedStatement prPs = con.prepareStatement(
                "SELECT PROJECT_NAME, DESCRIPTION, TECHNOLOGIES, PROJECT_URL FROM STUDENT_PROJECT WHERE STUDENT_ID = ? ORDER BY PROJECT_ID DESC")) {
            prPs.setInt(1, studentId);
            try (ResultSet prRs = prPs.executeQuery()) {
                while (prRs.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("name", prRs.getString("PROJECT_NAME"));
                    p.put("desc", prRs.getString("DESCRIPTION"));
                    p.put("tech", prRs.getString("TECHNOLOGIES"));
                    p.put("url", prRs.getString("PROJECT_URL"));
                    projectList.add(p);
                }
            }
        }
    }
} catch (Exception e) {
    application.log("Error loading candidate profile", e);
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (con != null) con.close(); } catch (Exception ignored) {}
}

if (!found) {
    response.sendRedirect("company-applicants.jsp?result=notfound");
    return;
}

boolean onCampus = isOnCampus(driveType);
boolean collegeApproved = "SHORTLISTED".equalsIgnoreCase(collegeShortlistStatus);

if (appStatus == null || appStatus.trim().isEmpty() || "APPLIED".equalsIgnoreCase(appStatus) || "AWAITING REVIEW".equalsIgnoreCase(appStatus)) {
    appStatus = "PENDING";
}

String initials = "S";
if (studentName != null && !studentName.trim().isEmpty()) {
    String[] parts = studentName.trim().split("\\s+");
    initials = parts[0].substring(0, 1).toUpperCase(Locale.ROOT);
    if (parts.length > 1) {
        initials += parts[parts.length - 1].substring(0, 1).toUpperCase(Locale.ROOT);
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= esc(studentName) %> - Candidate Dossier | CampusConnect</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --navy: #092f55;
            --navy-dark: #062847;
            --blue: #2563eb;
            --blue-light: #eff6ff;
            --text: #1e293b;
            --muted: #64748b;
            --border: #e2e8f0;
            --page: #f8fafc;
            --white: #ffffff;
            --green: #10b981;
            --green-dark: #059669;
            --red: #ef4444;
            --amber: #f59e0b;
            --radius: 12px;
            --shadow: 0 4px 16px rgba(15, 23, 42, 0.05);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--page);
            color: var(--text);
            min-height: 100vh;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, var(--navy) 0%, var(--navy-dark) 100%);
            color: var(--white);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 100;
        }

        .sidebar-brand {
            padding: 24px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .brand-icon {
            width: 38px;
            height: 38px;
            border-radius: 9px;
            background: var(--blue);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
        }

        .brand-text h1 {
            font-size: 17px;
            font-weight: 800;
            letter-spacing: -0.3px;
        }

        .brand-text span {
            font-size: 11px;
            color: #93c5fd;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        .sidebar-menu {
            flex: 1;
            padding: 16px 12px;
            overflow-y: auto;
        }

        .menu-section-title {
            font-size: 11px;
            font-weight: 700;
            color: #93c5fd;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 12px 12px 6px;
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            border-radius: 8px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
            transition: all 0.15s ease;
            margin-bottom: 3px;
        }

        .menu-item:hover {
            background: rgba(255, 255, 255, 0.08);
            color: var(--white);
        }

        .menu-item.active {
            background: var(--blue);
            color: var(--white);
        }

        .menu-item i {
            width: 18px;
            text-align: center;
            font-size: 15px;
        }

        .sidebar-bottom {
            padding: 14px 12px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .menu-item.logout { color: #fca5a5; }
        .menu-item.logout:hover { background: rgba(239, 68, 68, 0.15); color: #fee2e2; }

        /* Main Content */
        .main-wrapper {
            margin-left: 280px;
            flex: 1;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .topbar {
            height: 64px;
            background: var(--white);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .breadcrumbs {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--muted);
        }

        .breadcrumbs a {
            color: var(--blue);
            text-decoration: none;
            font-weight: 600;
        }

        .breadcrumbs a:hover { text-decoration: underline; }

        .breadcrumbs i { font-size: 10px; color: #94a3b8; }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .company-pill {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 5px 12px 5px 6px;
            background: #f1f5f9;
            border: 1px solid var(--border);
            border-radius: 20px;
        }

        .company-avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: var(--navy);
            color: white;
            font-size: 12px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .company-name {
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
        }

        .page-body {
            padding: 28px 32px 60px;
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
        }

        /* Hero Banner */
        .profile-hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 60%, #3b82f6 100%);
            border-radius: var(--radius);
            padding: 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 24px;
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.18);
        }

        .hero-left {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .hero-avatar {
            width: 80px;
            height: 80px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            border: 2px solid rgba(255, 255, 255, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            font-weight: 800;
            color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        }

        .hero-info h1 {
            font-size: 26px;
            font-weight: 800;
            margin-bottom: 4px;
            letter-spacing: -0.5px;
        }

        .hero-meta {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 14px;
            font-size: 13px;
            color: #dbeafe;
            margin-top: 6px;
        }

        .hero-meta span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-hero {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.18s ease;
            cursor: pointer;
            border: 0;
        }

        .btn-hero-white {
            background: white;
            color: #1e3a8a;
        }
        .btn-hero-white:hover {
            background: #f8fafc;
            transform: translateY(-1px);
        }

        .btn-hero-trans {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .btn-hero-trans:hover {
            background: rgba(255, 255, 255, 0.25);
        }

        /* Grid Layout */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }

        @media (max-width: 992px) {
            .content-grid { grid-template-columns: 1fr; }
        }

        /* Cards */
        .dossier-card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow);
        }

        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
        }

        .card-title {
            font-size: 15px;
            font-weight: 800;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-title i {
            color: var(--blue);
            font-size: 16px;
        }

        /* Application Details Card */
        .status-strip {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 16px 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 14px;
        }

        .strip-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .strip-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .strip-value {
            font-size: 14px;
            font-weight: 800;
            color: var(--text);
        }

        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .badge-oncampus { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .badge-offcampus { background: #f0fdfa; color: #0f766e; border: 1px solid #99f6e4; }
        .badge-shortlisted { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .badge-pending { background: #fffbeb; color: #d97706; border: 1px solid #fde68a; }
        .badge-rejected { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }
        .badge-na { background: #f1f5f9; color: #64748b; border: 1px solid #cbd5e1; }

        /* Resume Banner */
        .resume-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 20px;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 10px;
            flex-wrap: wrap;
            gap: 14px;
        }

        .resume-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .resume-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            background: #dcfce7;
            color: #16a34a;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .resume-meta strong {
            display: block;
            font-size: 14px;
            color: #15803d;
            font-weight: 700;
            word-break: break-all;
        }

        .resume-meta span {
            font-size: 11.5px;
            color: #4ade80;
            font-weight: 600;
        }

        .resume-actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-resume {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 7px;
            font-size: 12.5px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.15s ease;
        }

        .btn-resume-view {
            background: #16a34a;
            color: white;
        }
        .btn-resume-view:hover { background: #15803d; }

        .btn-resume-dl {
            background: white;
            color: #16a34a;
            border: 1px solid #86efac;
        }
        .btn-resume-dl:hover { background: #dcfce7; }

        .no-resume {
            padding: 24px;
            text-align: center;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 10px;
            color: var(--muted);
            font-size: 13px;
        }

        /* Table */
        .dossier-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .dossier-table th {
            text-align: left;
            padding: 10px 14px;
            background: #f8fafc;
            color: var(--muted);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            border-bottom: 1px solid var(--border);
        }

        .dossier-table td {
            padding: 12px 14px;
            border-bottom: 1px solid #f1f5f9;
            color: var(--text);
            font-weight: 600;
        }

        .dossier-table tr:last-child td { border-bottom: 0; }

        /* Skills */
        .skills-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .skill-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            background: #eff6ff;
            border: 1px solid #dbeafe;
            color: #1e40af;
            font-size: 12px;
            font-weight: 700;
        }

        .skill-pill i { font-size: 10px; color: #3b82f6; }

        /* Projects */
        .project-item {
            padding: 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            margin-bottom: 12px;
        }

        .project-item:last-child { margin-bottom: 0; }

        .project-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 6px;
        }

        .project-name {
            font-size: 14px;
            font-weight: 800;
            color: #0f172a;
        }

        .project-tech {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            color: #2563eb;
            background: #eff6ff;
            padding: 2px 8px;
            border-radius: 4px;
            margin-bottom: 6px;
        }

        .project-desc {
            font-size: 12.5px;
            color: #475569;
            line-height: 1.5;
        }

        .project-link {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            font-weight: 700;
            color: var(--blue);
            text-decoration: none;
            margin-top: 8px;
        }

        .project-link:hover { text-decoration: underline; }

        /* Sidebar Action Box */
        .action-box {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .btn-action-full {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px;
            border-radius: 8px;
            font-size: 13.5px;
            font-weight: 700;
            cursor: pointer;
            border: 0;
            transition: all 0.15s ease;
            text-decoration: none;
        }

        .btn-action-shortlist {
            background: #10b981;
            color: white;
        }
        .btn-action-shortlist:hover { background: #059669; }

        .btn-action-reject {
            background: #ef4444;
            color: white;
        }
        .btn-action-reject:hover { background: #dc2626; }

        .btn-action-schedule {
            background: var(--blue);
            color: white;
        }
        .btn-action-schedule:hover { background: #1d4ed8; }

        .btn-action-select {
            background: #059669;
            color: white;
        }
        .btn-action-select:hover { background: #047857; }

        .btn-action-revoke {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid var(--border);
        }
        .btn-action-revoke:hover { background: #e2e8f0; }

        .info-row {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f1f5f9;
            font-size: 13px;
        }

        .info-row:last-child { border-bottom: 0; }

        .info-label {
            color: var(--muted);
            font-weight: 600;
        }

        .info-value {
            color: var(--text);
            font-weight: 750;
            text-align: right;
            max-width: 60%;
        }
    </style>
</head>
<body>

<div class="layout">

    <!-- ================= SIDEBAR ================= -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-icon">
                <i class="fa-solid fa-graduation-cap"></i>
            </div>
            <div class="brand-text">
                <h1>CampusConnect</h1>
                <span>Company Portal</span>
            </div>
        </div>

        <div class="sidebar-menu">
            <div class="menu-section-title">OVERVIEW</div>

            <a href="company-dashboard.jsp" class="menu-item">
                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a href="company-profile.jsp" class="menu-item">
                <i class="fa-solid fa-building"></i>
                <span>Company Profile</span>
            </a>

            <div class="menu-section-title">RECRUITMENT</div>

            <a href="recruitment-drive.jsp" class="menu-item">
                <i class="fa-solid fa-plus"></i>
                <span>Create Drive</span>
            </a>

            <a href="view-recruitment-drives.jsp" class="menu-item">
                <i class="fa-solid fa-briefcase"></i>
                <span>Recruitment Drives</span>
            </a>

            <a href="company-applicants.jsp" class="menu-item active">
                <i class="fa-solid fa-users"></i>
                <span>Applicants</span>
            </a>

            <a href="company-shortlisted.jsp" class="menu-item">
                <i class="fa-solid fa-star"></i>
                <span>Shortlisted Candidates</span>
            </a>

            <a href="company-interviews.jsp" class="menu-item">
                <i class="fa-regular fa-calendar-check"></i>
                <span>Interviews</span>
            </a>

            <a href="company-offers.jsp" class="menu-item">
                <i class="fa-regular fa-gem"></i>
                <span>Offers &amp; Selections</span>
            </a>

            <div class="menu-section-title">ANALYTICS</div>

            <a href="company-reports.jsp" class="menu-item">
                <i class="fa-solid fa-chart-column"></i>
                <span>Reports &amp; Analytics</span>
            </a>
        </div>

        <div class="sidebar-bottom">
            <a href="CompanyLogoutServlet" class="menu-item logout">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- ================= MAIN WRAPPER ================= -->
    <div class="main-wrapper">

        <header class="topbar">
            <div class="breadcrumbs">
                <a href="company-dashboard.jsp">Dashboard</a>
                <i class="fa-solid fa-chevron-right"></i>
                <a href="company-applicants.jsp">Applicants</a>
                <i class="fa-solid fa-chevron-right"></i>
                <span>Candidate Dossier (#APP-<%= applicationId %>)</span>
            </div>

            <div class="topbar-right">
                <div class="company-pill">
                    <div class="company-avatar"><%= esc(companyInitial) %></div>
                    <span class="company-name"><%= esc(companyName) %></span>
                </div>
            </div>
        </header>

        <main class="page-body">

            <!-- Hero Banner -->
            <section class="profile-hero">
                <div class="hero-left">
                    <div class="hero-avatar">
                        <%= esc(initials) %>
                    </div>
                    <div class="hero-info">
                        <h1><%= esc(studentName) %></h1>
                        <p style="font-size: 14px; opacity: 0.9;">
                            <%= esc(courseName != null && !courseName.isEmpty() ? courseName : "Student") %> &bull; <%= esc(collegeName != null && !collegeName.isEmpty() ? collegeName : "Independent / Off-Campus") %>
                        </p>
                        <div class="hero-meta">
                            <span><i class="fa-solid fa-envelope"></i> <%= esc(studentEmail) %></span>
                            <span><i class="fa-solid fa-phone"></i> <%= esc(studentPhone != null && !studentPhone.isEmpty() ? studentPhone : "—") %></span>
                            <span><i class="fa-solid fa-id-badge"></i> Student ID: <%= studentId %></span>
                        </div>
                    </div>
                </div>

                <div class="hero-actions">
                    <a href="company-applicants.jsp" class="btn-hero btn-hero-trans">
                        <i class="fa-solid fa-arrow-left"></i> Back to Applicants
                    </a>
                    <% if ("SHORTLISTED".equalsIgnoreCase(appStatus)) { %>
                        <a href="company-interviews.jsp" class="btn-hero btn-hero-white">
                            <i class="fa-solid fa-calendar-plus"></i> Schedule Interview
                        </a>
                    <% } %>
                </div>
            </section>

            <!-- 2-Column Content Grid -->
            <div class="content-grid">

                <!-- Left Column (Dossier) -->
                <div class="grid-left">

                    <!-- Resume Document Card -->
                    <div class="dossier-card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fa-solid fa-file-pdf"></i>
                                Resume &amp; Curriculum Vitae
                            </h2>
                            <% if (resumeFile != null && !resumeFile.trim().isEmpty()) { %>
                                <span class="badge badge-shortlisted">
                                    <i class="fa-solid fa-circle-check"></i> File Uploaded
                                </span>
                            <% } %>
                        </div>

                        <% if (resumeFile != null && !resumeFile.trim().isEmpty()) { %>
                            <div class="resume-box">
                                <div class="resume-left">
                                    <div class="resume-icon">
                                        <i class="fa-solid fa-file-lines"></i>
                                    </div>
                                    <div class="resume-meta">
                                        <strong><%= esc(resumeFile) %></strong>
                                        <span style="color:#059669;">Uploaded on <%= formatDate(resumeDate) %></span>
                                    </div>
                                </div>
                                <div class="resume-actions">
                                    <a href="resume_files/<%= esc(resumeFile) %>" target="_blank" class="btn-resume btn-resume-view">
                                        <i class="fa-solid fa-eye"></i> View Resume
                                    </a>
                                    <a href="resume_files/<%= esc(resumeFile) %>" download class="btn-resume btn-resume-dl">
                                        <i class="fa-solid fa-download"></i> Download
                                    </a>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="no-resume">
                                <i class="fa-regular fa-folder-open" style="font-size: 28px; display: block; margin-bottom: 8px; color: #94a3b8;"></i>
                                No uploaded resume document found for this candidate.
                            </div>
                        <% } %>
                    </div>

                    <!-- Academic History -->
                    <div class="dossier-card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fa-solid fa-graduation-cap"></i>
                                Academic Credentials
                            </h2>
                            <span class="badge badge-oncampus"><%= academicList.size() %> Record(s)</span>
                        </div>

                        <% if (!academicList.isEmpty()) { %>
                            <table class="dossier-table">
                                <thead>
                                    <tr>
                                        <th>Qualification</th>
                                        <th>Passing Year</th>
                                        <th>Percentage</th>
                                        <th>CGPA</th>
                                        <th>Active Backlogs</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> acad : academicList) { %>
                                        <tr>
                                            <td><strong><%= esc((String) acad.get("qualification")) %></strong></td>
                                            <td><%= acad.get("year") %></td>
                                            <td><%= acad.get("percentage") %>%</td>
                                            <td><span style="color: #2563eb; font-weight:700;"><%= acad.get("cgpa") %> / 10</span></td>
                                            <td>
                                                <% int bl = (Integer) acad.get("backlogs"); %>
                                                <% if (bl == 0) { %>
                                                    <span style="color:#059669; font-weight:700;"><i class="fa-solid fa-check"></i> 0</span>
                                                <% } else { %>
                                                    <span style="color:#dc2626; font-weight:700;"><%= bl %> Backlog(s)</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <div class="no-resume">
                                No verified academic records listed yet.
                            </div>
                        <% } %>
                    </div>

                    <!-- Technical Skills -->
                    <div class="dossier-card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fa-solid fa-laptop-code"></i>
                                Skills &amp; Competencies
                            </h2>
                            <span class="badge badge-oncampus"><%= skillList.size() %> Skill(s)</span>
                        </div>

                        <% if (!skillList.isEmpty()) { %>
                            <div class="skills-container">
                                <% for (String skill : skillList) { %>
                                    <span class="skill-pill">
                                        <i class="fa-solid fa-code"></i> <%= esc(skill) %>
                                    </span>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="no-resume">
                                No technical skills listed by the candidate.
                            </div>
                        <% } %>
                    </div>

                    <!-- Projects Portfolio -->
                    <div class="dossier-card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fa-solid fa-diagram-project"></i>
                                Projects &amp; Portfolio
                            </h2>
                            <span class="badge badge-oncampus"><%= projectList.size() %> Project(s)</span>
                        </div>

                        <% if (!projectList.isEmpty()) { %>
                            <% for (Map<String, String> pr : projectList) { %>
                                <div class="project-item">
                                    <div class="project-header">
                                        <div class="project-name"><%= esc(pr.get("name")) %></div>
                                    </div>
                                    <% if (pr.get("tech") != null && !pr.get("tech").trim().isEmpty()) { %>
                                        <span class="project-tech">Tech: <%= esc(pr.get("tech")) %></span>
                                    <% } %>
                                    <p class="project-desc">
                                        <%= esc(pr.get("desc") != null ? pr.get("desc") : "No description provided.") %>
                                    </p>
                                    <% if (pr.get("url") != null && !pr.get("url").trim().isEmpty()) { %>
                                        <a href="<%= esc(pr.get("url")) %>" target="_blank" class="project-link">
                                            <i class="fa-solid fa-arrow-up-right-from-square"></i> View Project Link
                                        </a>
                                    <% } %>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="no-resume">
                                No project submissions recorded for this candidate.
                            </div>
                        <% } %>
                    </div>

                </div>

                <!-- Right Column (Application Metadata & Actions) -->
                <div class="grid-right">

                    <!-- Application Info -->
                    <div class="dossier-card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fa-solid fa-briefcase"></i>
                                Applied Drive
                            </h2>
                        </div>

                        <div class="status-strip">
                            <div class="strip-item">
                                <span class="strip-label">Application ID</span>
                                <span class="strip-value" style="color: #2563eb;">#APP-<%= applicationId %></span>
                            </div>
                            <div class="strip-item">
                                <span class="strip-label">Applied Date</span>
                                <span class="strip-value"><%= formatDate(appliedDate) %></span>
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Opportunity</span>
                            <span class="info-value"><%= esc(jobTitle) %></span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Drive Type</span>
                            <span class="info-value">
                                <% if (onCampus) { %>
                                    <span class="badge badge-oncampus"><i class="fa-solid fa-building-columns"></i> On-Campus</span>
                                <% } else { %>
                                    <span class="badge badge-offcampus"><i class="fa-solid fa-globe"></i> Off-Campus</span>
                                <% } %>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Package / Salary</span>
                            <span class="info-value"><%= esc(salary != null && !salary.isEmpty() ? salary : "Not Disclosed") %></span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Company Decision</span>
                            <span class="info-value">
                                <% if ("SHORTLISTED".equalsIgnoreCase(appStatus)) { %>
                                    <span class="badge badge-shortlisted"><i class="fa-solid fa-check"></i> Shortlisted</span>
                                <% } else if ("REJECTED".equalsIgnoreCase(appStatus)) { %>
                                    <span class="badge badge-rejected"><i class="fa-solid fa-xmark"></i> Rejected</span>
                                <% } else { %>
                                    <span class="badge badge-pending"><i class="fa-regular fa-clock"></i> Pending Review</span>
                                <% } %>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">College Status</span>
                            <span class="info-value">
                                <% if (onCampus) { %>
                                    <% if (collegeApproved) { %>
                                        <span class="badge badge-shortlisted"><i class="fa-solid fa-check"></i> College Verified</span>
                                    <% } else if ("REJECTED".equalsIgnoreCase(collegeShortlistStatus)) { %>
                                        <span class="badge badge-rejected"><i class="fa-solid fa-ban"></i> College Rejected</span>
                                    <% } else { %>
                                        <span class="badge badge-pending"><i class="fa-regular fa-clock"></i> Pending College</span>
                                    <% } %>
                                <% } else { %>
                                    <span class="badge badge-na"><i class="fa-solid fa-minus"></i> N/A (Direct Application)</span>
                                <% } %>
                            </span>
                        </div>
                    </div>

                    <!-- Direct Recruitment Decision Actions -->
                    <div class="dossier-card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fa-solid fa-sliders"></i>
                                Recruiter Decision
                            </h2>
                        </div>

                        <div class="action-box">
                            <% if (onCampus) { %>
                                <% if (!collegeApproved) { %>
                                    <div style="padding:14px; background:#fffbeb; border:1px solid #fde68a; border-radius:8px; font-size:12.5px; color:#92400e;">
                                        <i class="fa-solid fa-clock" style="margin-right:4px;"></i>
                                        This is an <strong>On-Campus</strong> application. The student's college placement cell must shortlist the student first before the company can finalize the shortlist.
                                    </div>
                                <% } else if ("PENDING".equalsIgnoreCase(appStatus)) { %>
                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Shortlist and approve <%= esc(studentName) %> for interview scheduling?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="APPROVE">
                                        <button class="btn-action-full btn-action-shortlist" type="submit">
                                            <i class="fa-solid fa-user-check"></i> Shortlist Candidate
                                        </button>
                                    </form>

                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Reject applicant <%= esc(studentName) %>?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="REJECT">
                                        <button class="btn-action-full btn-action-reject" type="submit">
                                            <i class="fa-solid fa-user-xmark"></i> Reject Candidate
                                        </button>
                                    </form>
                                <% } else if ("SHORTLISTED".equalsIgnoreCase(appStatus)) { %>
                                    <a href="company-interviews.jsp" class="btn-action-full btn-action-schedule">
                                        <i class="fa-solid fa-calendar-plus"></i> Schedule Interview
                                    </a>
                                    <form method="post" action="company-offers.jsp" onsubmit="return confirm('Select <%= esc(studentName) %> and proceed to create an official offer?');">
                                        <input type="hidden" name="csrf" value="<%= offerCsrf %>">
                                        <input type="hidden" name="action" value="markSelected">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <button class="btn-action-full btn-action-select" type="submit">
                                            <i class="fa-solid fa-award"></i> Mark Selected &amp; Issue Offer
                                        </button>
                                    </form>
                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Revoke shortlisting for <%= esc(studentName) %>?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="REVOKE">
                                        <button class="btn-action-full btn-action-revoke" type="submit">
                                            <i class="fa-solid fa-rotate-left"></i> Revoke Shortlist
                                        </button>
                                    </form>
                                <% } else if ("SELECTED".equalsIgnoreCase(appStatus)) { %>
                                    <div style="padding:12px; background:#ecfdf5; border:1px solid #a7f3d0; border-radius:8px; font-size:12.5px; color:#065f46; margin-bottom:4px;">
                                        <i class="fa-solid fa-circle-check" style="margin-right:4px;"></i>
                                        Candidate has been <strong>SELECTED</strong>.
                                    </div>
                                    <a href="company-offers.jsp?appId=<%= applicationId %>" class="btn-action-full btn-action-schedule">
                                        <i class="fa-solid fa-file-signature"></i> Go to Offer Management
                                    </a>
                                <% } else if ("REJECTED".equalsIgnoreCase(appStatus)) { %>
                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Reconsider <%= esc(studentName) %> and return to Pending?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="RECONSIDER">
                                        <button class="btn-action-full btn-action-shortlist" type="submit">
                                            <i class="fa-solid fa-rotate-left"></i> Reconsider Candidate
                                        </button>
                                    </form>
                                <% } %>
                            <% } else { %>
                                <!-- OFF-CAMPUS DIRECT ACTIONS -->
                                <% if ("PENDING".equalsIgnoreCase(appStatus)) { %>
                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Shortlist <%= esc(studentName) %> for this off-campus drive?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="APPROVE">
                                        <button class="btn-action-full btn-action-shortlist" type="submit">
                                            <i class="fa-solid fa-user-check"></i> Shortlist Candidate
                                        </button>
                                    </form>

                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Reject applicant <%= esc(studentName) %>?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="REJECT">
                                        <button class="btn-action-full btn-action-reject" type="submit">
                                            <i class="fa-solid fa-user-xmark"></i> Reject Candidate
                                        </button>
                                    </form>
                                <% } else if ("SHORTLISTED".equalsIgnoreCase(appStatus)) { %>
                                    <a href="company-interviews.jsp" class="btn-action-full btn-action-schedule">
                                        <i class="fa-solid fa-calendar-plus"></i> Schedule Interview
                                    </a>
                                    <form method="post" action="company-offers.jsp" onsubmit="return confirm('Select <%= esc(studentName) %> and proceed to create an official offer?');">
                                        <input type="hidden" name="csrf" value="<%= offerCsrf %>">
                                        <input type="hidden" name="action" value="markSelected">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <button class="btn-action-full btn-action-select" type="submit">
                                            <i class="fa-solid fa-award"></i> Mark Selected &amp; Issue Offer
                                        </button>
                                    </form>
                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Revoke shortlisting for <%= esc(studentName) %>?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="REVOKE">
                                        <button class="btn-action-full btn-action-revoke" type="submit">
                                            <i class="fa-solid fa-rotate-left"></i> Revoke Shortlist
                                        </button>
                                    </form>
                                <% } else if ("SELECTED".equalsIgnoreCase(appStatus)) { %>
                                    <div style="padding:12px; background:#ecfdf5; border:1px solid #a7f3d0; border-radius:8px; font-size:12.5px; color:#065f46; margin-bottom:4px;">
                                        <i class="fa-solid fa-circle-check" style="margin-right:4px;"></i>
                                        Candidate has been <strong>SELECTED</strong>.
                                    </div>
                                    <a href="company-offers.jsp?appId=<%= applicationId %>" class="btn-action-full btn-action-schedule">
                                        <i class="fa-solid fa-file-signature"></i> Go to Offer Management
                                    </a>
                                <% } else if ("REJECTED".equalsIgnoreCase(appStatus)) { %>
                                    <form method="post" action="company-applicants.jsp" onsubmit="return confirm('Reconsider <%= esc(studentName) %> and return to Pending?');">
                                        <input type="hidden" name="applicationId" value="<%= applicationId %>">
                                        <input type="hidden" name="action" value="RECONSIDER">
                                        <button class="btn-action-full btn-action-shortlist" type="submit">
                                            <i class="fa-solid fa-rotate-left"></i> Reconsider Candidate
                                        </button>
                                    </form>
                                <% } %>
                            <% } %>
                        </div>
                    </div>

                </div>

            </div>

        </main>
    </div>

</div>

</body>
</html>
