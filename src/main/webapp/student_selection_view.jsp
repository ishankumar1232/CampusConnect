<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
    HttpSession session1 = request.getSession(false);

    if (session1 == null || session1.getAttribute("studentId") == null) {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = (Integer) session1.getAttribute("studentId");

    String studentName = "Student";
    String profileImage = null;

    if (session1.getAttribute("studentName") != null) {
        studentName = session1.getAttribute("studentName").toString();
    }

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        try (
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );
            PreparedStatement ps = con.prepareStatement(
                "SELECT NAME, PROFILE_IMAGE FROM STUDENT WHERE STUDENT_ID = ?"
            )
        ) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbName = rs.getString("NAME");
                    if (dbName != null && !dbName.trim().isEmpty()) {
                        studentName = dbName;
                        session1.setAttribute("studentName", dbName);
                    }
                    profileImage = rs.getString("PROFILE_IMAGE");
                }
            }
        }
    } catch (Exception e) {
        application.log("Unable to load student info", e);
    }

    String firstLetter = "S";
    if (studentName != null && !studentName.trim().isEmpty()) {
        firstLetter = studentName.trim().substring(0, 1).toUpperCase();
    }

    String message = (String) session1.getAttribute("studentOfferMsg");
    session1.removeAttribute("studentOfferMsg");
    String errorMsg = (String) session1.getAttribute("studentOfferErr");
    session1.removeAttribute("studentOfferErr");

    String offerAction = request.getParameter("offerAction");
    String offerIdStr = request.getParameter("offerId");

    if ("POST".equalsIgnoreCase(request.getMethod()) && offerAction != null && offerIdStr != null) {
        try {
            int targetOfferId = Integer.parseInt(offerIdStr.trim());
            String targetStatus = "accept".equalsIgnoreCase(offerAction) ? "ACCEPTED" : "DECLINED";

            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "CAMPUSCONNECT", "campus123")) {
                con.setAutoCommit(false);
                String updateOffer = "UPDATE OFFER SET OFFER_STATUS = ? WHERE OFFER_ID = ? AND APPLICATION_ID IN (SELECT APPLICATION_ID FROM APPLICATION WHERE STUDENT_ID = ?)";
                try (PreparedStatement ps = con.prepareStatement(updateOffer)) {
                    ps.setString(1, targetStatus);
                    ps.setInt(2, targetOfferId);
                    ps.setInt(3, studentId);
                    int updated = ps.executeUpdate();
                    if (updated > 0) {
                        con.commit();
                        session1.setAttribute("studentOfferMsg", "Job offer successfully " + targetStatus.toLowerCase() + "!");
                    } else {
                        con.rollback();
                        session1.setAttribute("studentOfferErr", "Offer could not be updated or unauthorized.");
                    }
                }
            }
            response.sendRedirect("student_selection_view.jsp");
            return;
        } catch (Exception ex) {
            errorMsg = "Action failed: " + ex.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Selection Results | CampusConnect</title>

<!-- Google Fonts & FontAwesome Icons -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --bg-color: #f8fafc;
    --card-bg: #ffffff;
    --primary: #2563eb;
    --primary-light: #eff6ff;
    --text-main: #0f172a;
    --text-muted: #64748b;
    --border-color: #e2e8f0;
    --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
    --shadow-md: 0 10px 25px -5px rgba(0,0,0,0.05);
    --radius-lg: 16px;
    --radius-md: 12px;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Plus Jakarta Sans', sans-serif;
}

body {
    background-color: var(--bg-color);
    color: var(--text-main);
    display: flex;
    min-height: 100vh;
}

a {
    text-decoration: none;
    color: inherit;
}

/* TOP NAVIGATION */
.topbar {
    height: 76px;
    background: linear-gradient(110deg, #08142d, #142b52);
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 28px;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 20;
    box-shadow: 0 5px 20px rgba(8, 21, 47, .16);
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 23px;
    font-weight: 800;
    letter-spacing: -.6px;
}

.brand-mark {
    width: 40px;
    height: 40px;
    display: grid;
    place-items: center;
    background: linear-gradient(135deg, #327ff4, #62b5ff);
    border-radius: 12px;
    font-size: 22px;
    color: white;
}

.brand span {
    color: #79b7ff;
}

.top-right {
    display: flex;
    align-items: center;
    gap: 18px;
}

.student-info {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 14px;
    font-weight: 600;
}

.profile-link {
    display: block;
    width: 43px;
    height: 43px;
    border-radius: 50%;
    overflow: hidden;
    border: 2px solid #9ccaff;
    background: #244775;
    flex-shrink: 0;
}

.profile-photo {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.profile-initial {
    width: 100%;
    height: 100%;
    display: grid;
    place-items: center;
    color: white;
    font-size: 17px;
    font-weight: bold;
}

.logout {
    padding: 9px 16px;
    border: 1px solid rgba(255,255,255,0.3);
    border-radius: 9px;
    color: white;
    font-size: 13px;
    transition: .2s;
}

.logout:hover {
    background: var(--primary);
    border-color: var(--primary);
}

/* SIDEBAR */
.sidebar {
    position: fixed;
    left: 0;
    top: 76px;
    bottom: 0;
    width: 88px;
    background: linear-gradient(180deg, #0b1936, #112347);
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    padding: 20px 8px;
    z-index: 10;
    border-right: 1px solid rgba(255,255,255,0.05);
}

.side-link {
    width: 70px;
    min-height: 63px;
    border-radius: 12px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 6px;
    color: #b7c5dd;
    font-size: 10px;
    text-align: center;
    transition: .2s;
}

.side-icon {
    font-size: 20px;
    line-height: 1.2;
}

.side-link:hover,
.side-link.active {
    color: white;
    background: linear-gradient(135deg, #1764d9, #348cf7);
    box-shadow: 0 6px 18px rgba(35, 119, 239, .28);
}

/* MAIN CONTENT */
.main {
    margin-left: 88px;
    margin-top: 76px;
    padding: 32px 36px 40px;
    max-width: 1700px;
    width: calc(100% - 88px);
}

/* PAGE HEADER BAR */
.page-header-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    flex-wrap: wrap;
    gap: 16px;
}

.page-title h1 {
    font-size: 24px;
    font-weight: 750;
    color: var(--text-main);
}

.page-title p {
    font-size: 13px;
    color: var(--text-muted);
    margin-top: 4px;
}

.btn-primary {
    background: var(--primary);
    color: white;
    padding: 10px 18px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
    transition: .2s;
}

.btn-primary:hover {
    background: #1d4ed8;
    transform: translateY(-2px);
}

/* TABLE CARD CONTAINER */
.content-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    overflow: hidden;
    margin-bottom: 30px;
}

.table-responsive {
    width: 100%;
    overflow-x: auto;
}

.data-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 14px;
}

.data-table th {
    background: #f1f5f9;
    color: #334155;
    font-weight: 700;
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    white-space: nowrap;
}

.data-table td {
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    color: var(--text-main);
    white-space: nowrap;
}

.data-table tbody tr:hover {
    background: var(--primary-light);
}

.data-table tbody tr:last-child td {
    border-bottom: none;
}

/* BADGES */
.badge-result {
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    display: inline-block;
}
.badge-selected { background: #dcfce7; color: #166534; }
.badge-rejected { background: #fee2e2; color: #991b1b; }
.badge-pending { background: #fef3c7; color: #92400e; }

.badge-offer-pending { background: #fffbeb; color: #b45309; border: 1px solid #fde68a; font-weight:700; padding: 4px 10px; border-radius: 20px; font-size: 11.5px; display: inline-flex; align-items:center; gap: 4px; }
.badge-offer-accepted { background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; font-weight:700; padding: 4px 10px; border-radius: 20px; font-size: 11.5px; display: inline-flex; align-items:center; gap: 4px; }
.badge-offer-declined { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; font-weight:700; padding: 4px 10px; border-radius: 20px; font-size: 11.5px; display: inline-flex; align-items:center; gap: 4px; }
.badge-offer-withdrawn { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; font-weight:700; padding: 4px 10px; border-radius: 20px; font-size: 11.5px; display: inline-flex; align-items:center; gap: 4px; }

.btn-offer-accept { background: #10b981; color: white; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; transition: 0.15s; display: inline-flex; align-items: center; gap: 4px; }
.btn-offer-accept:hover { background: #059669; }
.btn-offer-decline { background: #ef4444; color: white; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; transition: 0.15s; display: inline-flex; align-items: center; gap: 4px; }
.btn-offer-decline:hover { background: #dc2626; }
.offer-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 8px 12px; font-size: 12.5px; line-height: 1.45; }

.empty-state {
    padding: 40px;
    text-align: center;
    color: var(--text-muted);
}

.empty-state i {
    font-size: 36px;
    margin-bottom: 12px;
    color: #cbd5e1;
}

/* FOOTER */
.footer {
    text-align: center;
    color: var(--text-muted);
    font-size: 12px;
    padding: 20px 10px;
    border-top: 1px solid var(--border-color);
    margin-top: 40px;
}

@media(max-width: 900px) {
    .main {
        margin-left: 70px;
        width: calc(100% - 70px);
        padding: 24px 20px;
    }
    .sidebar {
        width: 70px;
    }
    .side-link {
        width: 54px;
    }
}
</style>
</head>

<body>

<!-- TOP HEADER -->
<header class="topbar">
    <a href="student_dashboard.jsp" class="brand">
        <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
        <div>Campus<span>Connect</span></div>
    </a>

    <div class="top-right">
        <div class="student-info">
            <a href="student_profile.jsp" class="profile-link" title="Open My Profile">
                <% if (profileImage != null && !profileImage.trim().isEmpty()) { %>
                    <img class="profile-photo"
                         src="profile_images/<%= URLEncoder.encode(profileImage, StandardCharsets.UTF_8.name()) %>"
                         alt="Student Profile">
                <% } else { %>
                    <div class="profile-initial"><%= firstLetter %></div>
                <% } %>
            </a>
            <span class="student-name"><%= studentName %></span>
        </div>
        <a href="student_logout.jsp" class="logout">Logout</a>
    </div>
</header>

<!-- SIDEBAR -->
<aside class="sidebar">
    <a href="student_dashboard.jsp" class="side-link">
        <span class="side-icon"><i class="fa-solid fa-house"></i></span>
        <span>Home</span>
    </a>
    <a href="student_academic_view.jsp" class="side-link">
        <span class="side-icon"><i class="fa-solid fa-book-open"></i></span>
        <span>Academics</span>
    </a>
    <a href="student_drive_view.jsp" class="side-link active">
        <span class="side-icon"><i class="fa-solid fa-briefcase"></i></span>
        <span>Placements</span>
    </a>
    <a href="student_profile.jsp" class="side-link">
        <span class="side-icon"><i class="fa-solid fa-gear"></i></span>
        <span>Profile</span>
    </a>
</aside>

<!-- MAIN CONTENT -->
<main class="main">

    <div class="page-header-bar">
        <div class="page-title">
            <h1>My Selection Results <i class="fa-solid fa-award" style="font-size: 20px; color: var(--primary);"></i></h1>
            <p>Check your final recruitment selection outcomes and job offers</p>
        </div>
        <div style="display: flex; gap: 12px; flex-wrap: wrap;">
            <a href="student_application_view.jsp" class="btn-primary">
                <i class="fa-solid fa-paper-plane"></i> My Applications
            </a>
            <a href="student_dashboard.jsp" class="btn-primary" style="background: #475569; box-shadow: 0 4px 12px rgba(71, 85, 105, 0.2);">
                <i class="fa-solid fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <% if (message != null) { %>
        <div style="padding: 14px 18px; background: #ecfdf5; border: 1px solid #a7f3d0; border-radius: 10px; color: #065f46; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-solid fa-circle-check" style="font-size: 18px;"></i>
            <%= message %>
        </div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div style="padding: 14px 18px; background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px; color: #991b1b; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-solid fa-triangle-exclamation" style="font-size: 18px;"></i>
            <%= errorMsg %>
        </div>
    <% } %>

    <!-- TABLE CARD -->
    <div class="content-card">
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Company &amp; Job</th>
                        <th>Drive &amp; Date</th>
                        <th>Selection Outcome</th>
                        <th>Offer Package (CTC)</th>
                        <th>Offer Status &amp; Action</th>
                        <th>Offer Letter</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("oracle.jdbc.driver.OracleDriver");

                        con = DriverManager.getConnection(
                            "jdbc:oracle:thin:@localhost:1521:XE",
                            "CAMPUSCONNECT",
                            "campus123"
                        );

                        String sql =
                            "SELECT NVL(S.SELECTION_ID, 0) AS SELECTION_ID, " +
                            "A.APPLICATION_ID, " +
                            "C.COMPANY_NAME, " +
                            "R.JOB_TITLE, " +
                            "R.DRIVE_TYPE, " +
                            "NVL(S.RESULT, A.STATUS) AS RESULT, " +
                            "NVL(S.SELECTION_DATE, A.APPLIED_DATE) AS SELECTION_DATE, " +
                            "S.REMARKS, " +
                            "O.OFFER_ID, " +
                            "O.DESIGNATION, " +
                            "O.ANNUAL_CTC, " +
                            "O.JOINING_DATE, " +
                            "O.OFFER_STATUS, " +
                            "O.OFFER_LETTER " +
                            "FROM APPLICATION A " +
                            "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
                            "JOIN COMPANY C ON R.COMPANY_ID = C.COMPANY_ID " +
                            "LEFT JOIN SELECTION S ON S.APPLICATION_ID = A.APPLICATION_ID " +
                            "LEFT JOIN OFFER O ON O.APPLICATION_ID = A.APPLICATION_ID " +
                            "WHERE A.STUDENT_ID = ? " +
                            "AND (S.SELECTION_ID IS NOT NULL OR UPPER(NVL(A.STATUS,'PENDING')) IN ('SELECTED', 'HIRED') OR O.OFFER_ID IS NOT NULL) " +
                            "ORDER BY A.APPLICATION_ID DESC";

                        ps = con.prepareStatement(sql);
                        ps.setInt(1, studentId);
                        rs = ps.executeQuery();

                        boolean found = false;

                        while(rs.next()) {
                            found = true;
                            int appId = rs.getInt("APPLICATION_ID");
                            String companyNameStr = rs.getString("COMPANY_NAME");
                            String jobTitle = rs.getString("JOB_TITLE");
                            String driveType = rs.getString("DRIVE_TYPE");
                            String result = rs.getString("RESULT");
                            java.sql.Date selDate = rs.getDate("SELECTION_DATE");
                            String remarks = rs.getString("REMARKS");

                            int offerId = rs.getInt("OFFER_ID");
                            String designation = rs.getString("DESIGNATION");
                            java.math.BigDecimal ctc = rs.getBigDecimal("ANNUAL_CTC");
                            java.sql.Date joiningDate = rs.getDate("JOINING_DATE");
                            String offerStatus = rs.getString("OFFER_STATUS");
                            String offerLetter = rs.getString("OFFER_LETTER");

                            String resultClass = "badge-pending";
                            if ("SELECTED".equalsIgnoreCase(result) || "HIRED".equalsIgnoreCase(result) || "PASSED".equalsIgnoreCase(result)) {
                                resultClass = "badge-selected";
                            } else if ("REJECTED".equalsIgnoreCase(result) || "NOT SELECTED".equalsIgnoreCase(result)) {
                                resultClass = "badge-rejected";
                            }
                %>
                    <tr>
                        <td>
                            <div><strong><%= companyNameStr %></strong></div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                <%= jobTitle %> &bull; App #<%= appId %>
                            </div>
                        </td>
                        <td>
                            <div><span style="font-size: 11.5px; font-weight: 700; color: #475569; background: #f1f5f9; padding: 2px 7px; border-radius: 4px;"><%= driveType != null ? driveType : "Campus" %></span></div>
                            <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 4px;">
                                <%= selDate != null ? selDate : "-" %>
                            </div>
                        </td>
                        <td>
                            <span class="badge-result <%= resultClass %>">
                                <% if ("SELECTED".equalsIgnoreCase(result) || "HIRED".equalsIgnoreCase(result)) { %>
                                    <i class="fa-solid fa-circle-check"></i>
                                <% } %>
                                <%= result != null ? result : "PENDING" %>
                            </span>
                            <% if (remarks != null && !remarks.trim().isEmpty()) { %>
                                <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 4px; max-width: 180px; overflow-wrap: break-word;">
                                    <%= remarks %>
                                </div>
                            <% } %>
                        </td>
                        <td>
                            <% if (offerId > 0 && designation != null) { %>
                                <div style="font-weight: 700; color: #0f172a;"><%= designation %></div>
                                <div style="font-weight: 800; color: #16a34a; font-size: 13.5px; margin-top: 2px;">
                                    ₹ <%= ctc != null ? ctc.toString() : "-" %> <span style="font-size: 11px; font-weight: 500; color: var(--text-muted);">/ year</span>
                                </div>
                                <% if (joiningDate != null) { %>
                                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 3px;">
                                        Joining: <strong><%= joiningDate %></strong>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 12.5px; font-style: italic;">
                                    Offer in preparation
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <% if (offerId > 0 && offerStatus != null) { %>
                                <% if ("PENDING".equalsIgnoreCase(offerStatus)) { %>
                                    <div><span class="badge-offer-pending"><i class="fa-regular fa-clock"></i> Action Needed</span></div>
                                    <div style="margin-top: 8px; display: flex; gap: 6px;">
                                        <form method="post" onsubmit="return confirm('Accept official job offer from <%= companyNameStr %>?');" style="margin:0;">
                                            <input type="hidden" name="offerAction" value="accept">
                                            <input type="hidden" name="offerId" value="<%= offerId %>">
                                            <button type="submit" class="btn-offer-accept">
                                                <i class="fa-solid fa-check"></i> Accept
                                            </button>
                                        </form>
                                        <form method="post" onsubmit="return confirm('Decline this job offer?');" style="margin:0;">
                                            <input type="hidden" name="offerAction" value="decline">
                                            <input type="hidden" name="offerId" value="<%= offerId %>">
                                            <button type="submit" class="btn-offer-decline">
                                                <i class="fa-solid fa-xmark"></i> Decline
                                            </button>
                                        </form>
                                    </div>
                                <% } else if ("ACCEPTED".equalsIgnoreCase(offerStatus)) { %>
                                    <span class="badge-offer-accepted"><i class="fa-solid fa-check-double"></i> Offer Accepted</span>
                                <% } else if ("DECLINED".equalsIgnoreCase(offerStatus)) { %>
                                    <span class="badge-offer-declined"><i class="fa-solid fa-ban"></i> Offer Declined</span>
                                <% } else if ("WITHDRAWN".equalsIgnoreCase(offerStatus)) { %>
                                    <span class="badge-offer-withdrawn"><i class="fa-solid fa-rotate-left"></i> Offer Withdrawn</span>
                                <% } else { %>
                                    <span class="badge-offer-pending"><%= offerStatus %></span>
                                <% } %>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 12px;">&mdash;</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (offerLetter != null && !offerLetter.trim().isEmpty()) { 
                                String letterUrl = offerLetter.trim();
                                if (!letterUrl.startsWith("http://") && !letterUrl.startsWith("https://") && !letterUrl.startsWith("/")) {
                                    letterUrl = "https://" + letterUrl;
                                }
                            %>
                                <a href="<%= letterUrl %>" target="_blank" rel="noopener noreferrer" style="color: var(--primary); font-weight: 700; font-size: 12.5px; display: inline-flex; align-items: center; gap: 5px;">
                                    <i class="fa-solid fa-arrow-up-right-from-square"></i> View Doc
                                </a>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 12px;">&mdash;</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }

                        if(!found) {
                %>
                    <tr>
                        <td colspan="6" class="empty-state">
                            <i class="fa-regular fa-folder-open"></i><br>
                            No Selection Results or Offers Found at the moment.
                        </td>
                    </tr>
                <%
                        }
                    } catch(Exception e) {
                %>
                    <tr>
                        <td colspan="6" class="empty-state" style="color: #dc2626;">
                            <i class="fa-solid fa-triangle-exclamation"></i><br>
                            Error loading selection results: <%= e.getMessage() %>
                        </td>
                    </tr>
                <%
                    } finally {
                        try {
                            if(rs != null) rs.close();
                            if(ps != null) ps.close();
                            if(con != null) con.close();
                        } catch(Exception e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer">
        CampusConnect Student Portal &bull; Campus Recruitment Management System
    </footer>

</main>

</body>
</html>