<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

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

    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = null;
    PreparedStatement psDrive = null;
    PreparedStatement psAssigned = null;
    PreparedStatement psColleges = null;
    ResultSet rsDrive = null;
    ResultSet rsAssigned = null;
    ResultSet rsColleges = null;

    String driveType = "";
    String jobTitle = "";
    Set<Integer> assignedCollegeIds = new HashSet<Integer>();

    class CollegeItem {
        int id;
        String name;
        String city;
        String state;
        boolean assigned;
    }

    List<CollegeItem> collegeList = new ArrayList<CollegeItem>();

    try {
        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        // 1. Verify drive belongs to logged-in company
        String driveQuery =
            "SELECT DRIVE_ID, DRIVE_TYPE, JOB_TITLE " +
            "FROM RECRUITMENT_DRIVE " +
            "WHERE DRIVE_ID = ? AND COMPANY_ID = ?";

        psDrive = con.prepareStatement(driveQuery);
        psDrive.setInt(1, driveId);
        psDrive.setInt(2, companyId);
        rsDrive = psDrive.executeQuery();

        if (!rsDrive.next()) {
            response.sendRedirect("view-recruitment-drives.jsp");
            return;
        }

        driveType = rsDrive.getString("DRIVE_TYPE");
        jobTitle = rsDrive.getString("JOB_TITLE");

        if (driveType == null || (!driveType.trim().equalsIgnoreCase("On Campus") &&
                                  !driveType.trim().equalsIgnoreCase("Campus") &&
                                  !driveType.trim().equalsIgnoreCase("On-Campus"))) {
            con.close();
            response.sendRedirect("view-recruitment-drives.jsp");
            return;
        }

        // 2. Fetch assigned colleges
        String assignedQuery = "SELECT COLLEGE_ID FROM DRIVE_COLLEGE WHERE DRIVE_ID = ?";
        psAssigned = con.prepareStatement(assignedQuery);
        psAssigned.setInt(1, driveId);
        rsAssigned = psAssigned.executeQuery();
        while (rsAssigned.next()) {
            assignedCollegeIds.add(rsAssigned.getInt("COLLEGE_ID"));
        }

        // 3. Fetch active/approved colleges
        String collegeQuery =
            "SELECT COLLEGE_ID, COLLEGE_NAME, CITY, STATE " +
            "FROM COLLEGE " +
            "WHERE UPPER(STATUS) IN ('ACTIVE', 'APPROVED') " +
            "ORDER BY COLLEGE_ID";

        psColleges = con.prepareStatement(collegeQuery);
        rsColleges = psColleges.executeQuery();

        while (rsColleges.next()) {
            CollegeItem c = new CollegeItem();
            c.id = rsColleges.getInt("COLLEGE_ID");
            c.name = rsColleges.getString("COLLEGE_NAME");
            c.city = rsColleges.getString("CITY");
            c.state = rsColleges.getString("STATE");
            c.assigned = assignedCollegeIds.contains(c.id);
            collegeList.add(c);
        }

    } catch (Exception e) {
        application.log("Error loading colleges for drive: " + driveId, e);
    } finally {
        if (rsDrive != null) try { rsDrive.close(); } catch (Exception ignore) {}
        if (rsAssigned != null) try { rsAssigned.close(); } catch (Exception ignore) {}
        if (rsColleges != null) try { rsColleges.close(); } catch (Exception ignore) {}
        if (psDrive != null) try { psDrive.close(); } catch (Exception ignore) {}
        if (psAssigned != null) try { psAssigned.close(); } catch (Exception ignore) {}
        if (psColleges != null) try { psColleges.close(); } catch (Exception ignore) {}
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Participating Colleges | Drive #<%= driveId %> | CampusConnect</title>

    <!-- Google Fonts & FontAwesome -->
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
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
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

        /* TOPBAR */
        .topbar {
            height: 72px;
            background: linear-gradient(110deg, #08142d, #142b52);
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: sticky;
            top: 0;
            z-index: 100;
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
            letter-spacing: -0.5px;
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

        .top-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .company-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 13px;
            color: #e2e8f0;
        }

        .company-pill i {
            color: #60a5fa;
        }

        .btn-nav-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-nav-back:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-1px);
        }

        /* MAIN CONTAINER */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 24px 100px;
            width: 100%;
            flex: 1;
        }

        /* BREADCRUMB */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 20px;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* HERO DRIVE BANNER */
        .drive-banner {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);
            color: white;
            padding: 28px 32px;
            border-radius: var(--radius-lg);
            margin-bottom: 28px;
            box-shadow: var(--shadow-md);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .banner-info h1 {
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .banner-info p {
            font-size: 14px;
            color: #bfdbfe;
            margin-top: 6px;
            max-width: 650px;
            line-height: 1.5;
        }

        .banner-badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }

        .badge-drive-id {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            backdrop-filter: blur(4px);
        }

        .badge-drive-type {
            background: #10b981;
            color: white;
        }

        /* CONTROLS CARD */
        .controls-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .search-box {
            position: relative;
            flex: 1;
            min-width: 260px;
            max-width: 480px;
        }

        .search-box i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 15px;
        }

        .search-box input {
            width: 100%;
            padding: 11px 16px 11px 40px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            font-size: 14px;
            outline: none;
            background: #f8fafc;
            color: var(--text-main);
            transition: all 0.2s;
        }

        .search-box input:focus {
            border-color: var(--primary);
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .quick-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-quick {
            padding: 8px 14px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background: white;
            font-size: 13px;
            font-weight: 600;
            color: #334155;
            cursor: pointer;
            transition: all 0.15s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-quick:hover {
            background: var(--primary-light);
            color: var(--primary);
            border-color: #bfdbfe;
        }

        .stats-counter {
            font-size: 13px;
            font-weight: 700;
            color: #475569;
            background: #f1f5f9;
            padding: 8px 14px;
            border-radius: 8px;
        }

        .stats-counter span {
            color: var(--primary);
        }

        /* COLLEGES GRID */
        .colleges-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 18px;
            margin-bottom: 30px;
        }

        /* COLLEGE CARD */
        .college-card {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 20px;
            box-shadow: var(--shadow-sm);
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
            display: flex;
            align-items: flex-start;
            gap: 16px;
            user-select: none;
        }

        .college-card:hover {
            transform: translateY(-2px);
            border-color: #93c5fd;
            box-shadow: 0 8px 20px -4px rgba(37, 99, 235, 0.1);
        }

        .college-card.selected {
            border-color: var(--primary);
            background: #f0f7ff;
            box-shadow: 0 4px 16px rgba(37, 99, 235, 0.12);
        }

        /* CUSTOM CHECKBOX */
        .checkbox-wrapper {
            padding-top: 2px;
        }

        .checkbox-custom {
            width: 22px;
            height: 22px;
            border: 2px solid #cbd5e1;
            border-radius: 6px;
            display: grid;
            place-items: center;
            background: white;
            transition: all 0.2s;
            color: transparent;
            font-size: 12px;
        }

        .college-card.selected .checkbox-custom {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        .college-card input[type="checkbox"] {
            display: none;
        }

        /* COLLEGE CONTENT */
        .college-content {
            flex: 1;
            min-width: 0;
        }

        .college-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            margin-bottom: 6px;
        }

        .college-name {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-main);
            line-height: 1.35;
        }

        .college-location {
            font-size: 13px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 4px;
        }

        .college-location i {
            color: #94a3b8;
            font-size: 12px;
        }

        .college-tags {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 12px;
            flex-wrap: wrap;
        }

        .tag-assigned {
            background: var(--success-light);
            color: var(--success);
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .tag-approved {
            background: #f1f5f9;
            color: #475569;
            font-size: 11px;
            font-weight: 600;
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        /* EMPTY STATE */
        .empty-state {
            background: white;
            border: 2px dashed #cbd5e1;
            border-radius: var(--radius-lg);
            padding: 48px 24px;
            text-align: center;
            grid-column: 1 / -1;
        }

        .empty-icon {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: #f1f5f9;
            color: #94a3b8;
            display: grid;
            place-items: center;
            font-size: 28px;
            margin: 0 auto 16px;
        }

        .empty-state h3 {
            font-size: 17px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 6px;
        }

        .empty-state p {
            font-size: 13px;
            color: var(--text-muted);
            max-width: 440px;
            margin: 0 auto;
        }

        /* BOTTOM STICKY ACTION BAR */
        .action-bar {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-top: 1px solid var(--border-color);
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 90;
            box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.05);
        }

        .action-bar-inner {
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .action-info {
            font-size: 14px;
            color: var(--text-muted);
        }

        .action-info strong {
            color: var(--text-main);
            font-weight: 700;
        }

        .action-buttons {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-cancel {
            padding: 11px 20px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            background: white;
            color: #334155;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-cancel:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        .btn-submit {
            padding: 11px 26px;
            border-radius: 10px;
            border: none;
            background: var(--primary);
            color: white;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-submit:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.4);
        }

        @media (max-width: 768px) {
            .topbar {
                padding: 0 16px;
            }
            .container {
                padding: 20px 16px 120px;
            }
            .colleges-grid {
                grid-template-columns: 1fr;
            }
            .drive-banner {
                padding: 20px;
            }
            .action-bar-inner {
                flex-direction: column;
                align-items: stretch;
            }
            .action-buttons {
                justify-content: stretch;
            }
            .btn-cancel, .btn-submit {
                flex: 1;
                justify-content: center;
            }
        }
    </style>
</head>

<body>

    <!-- TOPBAR -->
    <header class="topbar">
        <a href="view-recruitment-drives.jsp" class="brand">
            <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
            <div>Campus<span>Connect</span></div>
        </a>

        <div class="top-right">
            <div class="company-pill">
                <i class="fa-solid fa-building"></i>
                <span><%= companyName %></span>
            </div>
            <a href="view-recruitment-drives.jsp" class="btn-nav-back">
                <i class="fa-solid fa-arrow-left"></i>
                <span>Recruitment Drives</span>
            </a>
        </div>
    </header>

    <!-- MAIN CONTAINER -->
    <main class="container">

        <!-- BREADCRUMB -->
        <nav class="breadcrumb">
            <a href="view-recruitment-drives.jsp"><i class="fa-solid fa-briefcase"></i> Recruitment Drives</a>
            <i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i>
            <span>Select Target Colleges</span>
            <i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i>
            <span>Drive #<%= driveId %></span>
        </nav>

        <!-- DRIVE HERO BANNER -->
        <section class="drive-banner">
            <div class="banner-info">
                <h1>
                    <i class="fa-solid fa-building-columns"></i>
                    Target Colleges for On-Campus Drive
                </h1>
                <p>
                    Select participating colleges where students will be eligible to view, track, and apply for this recruitment drive.
                </p>
            </div>
            <div class="banner-badges">
                <span class="badge badge-drive-id">
                    <i class="fa-solid fa-hashtag"></i> Drive <%= driveId %>
                </span>
                <span class="badge badge-drive-type">
                    <i class="fa-solid fa-network-wired"></i> <%= driveType %>
                </span>
                <span class="badge" style="background: white; color: #1e3a8a;">
                    <i class="fa-solid fa-user-tie"></i> <%= jobTitle %>
                </span>
            </div>
        </section>

        <!-- FORM -->
        <form id="collegeForm" method="post" action="save-drive-colleges.jsp">
            <input type="hidden" name="driveId" value="<%= driveId %>">

            <!-- CONTROLS & SEARCH -->
            <div class="controls-card">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="searchInput" placeholder="Search college by name, city, or state..." autocomplete="off">
                </div>

                <div class="quick-actions">
                    <button type="button" class="btn-quick" id="btnSelectAll">
                        <i class="fa-solid fa-check-double"></i> Select All
                    </button>
                    <button type="button" class="btn-quick" id="btnDeselectAll">
                        <i class="fa-solid fa-xmark"></i> Clear All
                    </button>
                    <div class="stats-counter">
                        Selected: <span id="selectedCount">0</span> / <%= collegeList.size() %>
                    </div>
                </div>
            </div>

            <!-- COLLEGES LIST -->
            <div class="colleges-grid" id="collegesGrid">
                <%
                    if (collegeList.isEmpty()) {
                %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fa-solid fa-school-circle-exclamation"></i>
                        </div>
                        <h3>No Approved Colleges Found</h3>
                        <p>There are currently no active or approved institutions registered on the platform. Please check back once colleges are onboarded and approved by Super Admin.</p>
                    </div>
                <%
                    } else {
                        for (CollegeItem col : collegeList) {
                            String locationStr = (col.city != null ? col.city : "") +
                                                 ((col.city != null && col.state != null) ? ", " : "") +
                                                 (col.state != null ? col.state : "");
                %>
                    <div class="college-card <%= col.assigned ? "selected" : "" %>"
                         data-name="<%= col.name != null ? col.name.toLowerCase() : "" %>"
                         data-location="<%= locationStr.toLowerCase() %>"
                         onclick="toggleCard(this)">
                        
                        <div class="checkbox-wrapper">
                            <input type="checkbox"
                                   name="collegeId"
                                   value="<%= col.id %>"
                                   <%= col.assigned ? "checked" : "" %>
                                   id="chk_<%= col.id %>">
                            <div class="checkbox-custom">
                                <i class="fa-solid fa-check"></i>
                            </div>
                        </div>

                        <div class="college-content">
                            <div class="college-header">
                                <span class="college-name"><%= col.name %></span>
                            </div>

                            <div class="college-location">
                                <i class="fa-solid fa-location-dot"></i>
                                <span><%= locationStr.isEmpty() ? "Location not specified" : locationStr %></span>
                            </div>

                            <div class="college-tags">
                                <span class="tag-approved">
                                    <i class="fa-solid fa-circle-check" style="color: #2563eb;"></i> Approved Institution
                                </span>
                                <% if (col.assigned) { %>
                                    <span class="tag-assigned" id="badge_<%= col.id %>">
                                        <i class="fa-solid fa-check"></i> Currently Assigned
                                    </span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <%
                        }
                    }
                %>
            </div>

            <!-- STICKY ACTION BAR -->
            <div class="action-bar">
                <div class="action-bar-inner">
                    <div class="action-info">
                        Ready to update? You have selected <strong id="actionCount">0</strong> college(s) for this drive.
                    </div>
                    <div class="action-buttons">
                        <a href="view-recruitment-drives.jsp" class="btn-cancel">
                            <i class="fa-solid fa-arrow-left"></i> Cancel
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-floppy-disk"></i> Save Selected Colleges
                        </button>
                    </div>
                </div>
            </div>

        </form>

    </main>

    <script>
        function updateCounters() {
            var checkboxes = document.querySelectorAll('input[name="collegeId"]');
            var selected = 0;
            checkboxes.forEach(function(chk) {
                if (chk.checked) selected++;
            });
            document.getElementById('selectedCount').textContent = selected;
            document.getElementById('actionCount').textContent = selected;
        }

        function toggleCard(card) {
            var chk = card.querySelector('input[type="checkbox"]');
            chk.checked = !chk.checked;
            if (chk.checked) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
            updateCounters();
        }

        // Prevent double toggling when clicking directly on checkbox
        document.querySelectorAll('input[name="collegeId"]').forEach(function(chk) {
            chk.addEventListener('click', function(e) {
                e.stopPropagation();
                var card = this.closest('.college-card');
                if (this.checked) {
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
                updateCounters();
            });
        });

        // Search Filter
        document.getElementById('searchInput').addEventListener('input', function() {
            var filter = this.value.trim().toLowerCase();
            var cards = document.querySelectorAll('.college-card');
            cards.forEach(function(card) {
                var name = card.getAttribute('data-name') || '';
                var loc = card.getAttribute('data-location') || '';
                if (name.indexOf(filter) !== -1 || loc.indexOf(filter) !== -1) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        });

        // Select All Visible
        document.getElementById('btnSelectAll').addEventListener('click', function() {
            var cards = document.querySelectorAll('.college-card');
            cards.forEach(function(card) {
                if (card.style.display !== 'none') {
                    var chk = card.querySelector('input[type="checkbox"]');
                    chk.checked = true;
                    card.classList.add('selected');
                }
            });
            updateCounters();
        });

        // Clear All
        document.getElementById('btnDeselectAll').addEventListener('click', function() {
            var cards = document.querySelectorAll('.college-card');
            cards.forEach(function(card) {
                var chk = card.querySelector('input[type="checkbox"]');
                chk.checked = false;
                card.classList.remove('selected');
            });
            updateCounters();
        });

        // Form validation
        document.getElementById('collegeForm').addEventListener('submit', function(e) {
            var checkboxes = document.querySelectorAll('input[name="collegeId"]:checked');
            if (checkboxes.length === 0) {
                e.preventDefault();
                alert('Please select at least one college for this On-Campus recruitment drive.');
            }
        });

        // Initial count
        updateCounters();
    </script>

</body>
</html>
