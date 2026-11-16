<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    Integer collegeId = (Integer) session.getAttribute("collegeId");

    if (collegeId == null) {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }

    String collegeName = (String) session.getAttribute("collegeName");
    if (collegeName == null || collegeName.trim().isEmpty()) {
        collegeName = "College Placement Cell";
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int totalCount = 0;
    int pendingCount = 0;
    int shortlistedCount = 0;
    int rejectedCount = 0;

    class AppRow {
        int appId;
        int studentId;
        String studentName;
        String companyName;
        String jobTitle;
        String driveType;
        Date appliedDate;
        String status;
        String collegeShortlistStatus;
    }

    java.util.List<AppRow> appList = new java.util.ArrayList<AppRow>();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        // Fetch ONLY On-Campus applications for this college
        // Off-Campus drives are direct drives shortlisted solely by companies
        String sql =
            "SELECT A.APPLICATION_ID, " +
            "A.STUDENT_ID, " +
            "S.NAME, " +
            "C.COMPANY_NAME, " +
            "R.JOB_TITLE, " +
            "R.DRIVE_TYPE, " +
            "A.APPLIED_DATE, " +
            "A.STATUS, " +
            "A.COLLEGE_SHORTLIST_STATUS " +
            "FROM APPLICATION A " +
            "JOIN STUDENT S ON A.STUDENT_ID = S.STUDENT_ID " +
            "JOIN RECRUITMENT_DRIVE R ON A.DRIVE_ID = R.DRIVE_ID " +
            "JOIN COMPANY C ON R.COMPANY_ID = C.COMPANY_ID " +
            "WHERE S.COLLEGE_ID = ? " +
            "AND (UPPER(R.DRIVE_TYPE) = 'ON CAMPUS' OR UPPER(R.DRIVE_TYPE) = 'CAMPUS' OR UPPER(R.DRIVE_TYPE) = 'ON-CAMPUS') " +
            "ORDER BY A.APPLICATION_ID DESC";

        ps = con.prepareStatement(sql);
        ps.setInt(1, collegeId);
        rs = ps.executeQuery();

        while (rs.next()) {
            AppRow row = new AppRow();
            row.appId = rs.getInt("APPLICATION_ID");
            row.studentId = rs.getInt("STUDENT_ID");
            row.studentName = rs.getString("NAME");
            row.companyName = rs.getString("COMPANY_NAME");
            row.jobTitle = rs.getString("JOB_TITLE");
            row.driveType = rs.getString("DRIVE_TYPE");
            row.appliedDate = rs.getDate("APPLIED_DATE");
            row.status = rs.getString("STATUS");
            row.collegeShortlistStatus = rs.getString("COLLEGE_SHORTLIST_STATUS");
            if (row.collegeShortlistStatus == null || row.collegeShortlistStatus.trim().isEmpty()) {
                row.collegeShortlistStatus = "PENDING";
            }

            appList.add(row);
            totalCount++;

            if ("SHORTLISTED".equalsIgnoreCase(row.collegeShortlistStatus)) {
                shortlistedCount++;
            } else if ("REJECTED".equalsIgnoreCase(row.collegeShortlistStatus)) {
                rejectedCount++;
            } else {
                pendingCount++;
            }
        }

    } catch (Exception e) {
        application.log("Error loading college applications", e);
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>On-Campus Application Management | CampusConnect</title>

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
            --warning: #d97706;
            --warning-light: #fef3c7;
            --danger: #dc2626;
            --danger-light: #fee2e2;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-md: 0 10px 25px -5px rgba(0,0,0,0.05);
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
            gap: 14px;
        }

        .college-pill {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 13px;
            color: #e2e8f0;
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

        /* CONTAINER */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 32px 24px 60px;
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

        /* HEADER BANNER */
        .page-header {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .page-header h1 {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .page-header p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 4px;
            max-width: 800px;
            line-height: 1.5;
        }

        /* SYSTEM EXPLANATION CARD */
        .info-card {
            background: #f0f7ff;
            border: 1px solid #bfdbfe;
            border-radius: var(--radius-md);
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
            font-size: 13px;
            color: #1e3a8a;
            line-height: 1.5;
        }

        .info-card i {
            font-size: 20px;
            color: var(--primary);
            margin-top: 2px;
            flex-shrink: 0;
        }

        .info-card strong {
            font-weight: 700;
        }

        /* STATS GRID */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 20px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: grid;
            place-items: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .stat-icon.blue { background: var(--primary-light); color: var(--primary); }
        .stat-icon.orange { background: var(--warning-light); color: var(--warning); }
        .stat-icon.green { background: var(--success-light); color: var(--success); }
        .stat-icon.red { background: var(--danger-light); color: var(--danger); }

        .stat-details .num {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-main);
            line-height: 1.2;
        }

        .stat-details .lbl {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            margin-top: 2px;
        }

        /* FILTER BAR */
        .filter-bar {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 16px 20px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 14px;
        }

        .search-box {
            position: relative;
            flex: 1;
            min-width: 260px;
            max-width: 420px;
        }

        .search-box i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 14px;
        }

        .search-box input {
            width: 100%;
            padding: 9px 16px 9px 38px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            font-size: 13px;
            outline: none;
            background: #f8fafc;
            transition: all 0.2s;
        }

        .search-box input:focus {
            border-color: var(--primary);
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .filter-select {
            padding: 9px 14px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            font-size: 13px;
            background: white;
            color: var(--text-main);
            outline: none;
            cursor: pointer;
        }

        /* TABLE CONTAINER */
        .table-card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 13px;
        }

        .data-table th {
            background: #f8fafc;
            color: #475569;
            font-weight: 700;
            padding: 14px 18px;
            border-bottom: 1px solid var(--border-color);
            white-space: nowrap;
        }

        .data-table td {
            padding: 14px 18px;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-main);
            white-space: nowrap;
            vertical-align: middle;
        }

        .data-table tbody tr:hover {
            background: #f8fafc;
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* BADGES */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }

        .badge-id {
            background: #f1f5f9;
            color: #334155;
            font-weight: 700;
        }

        .badge-oncampus {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-pending {
            background: var(--warning-light);
            color: var(--warning);
        }

        .badge-shortlisted {
            background: var(--success-light);
            color: var(--success);
        }

        .badge-rejected {
            background: var(--danger-light);
            color: var(--danger);
        }

        .badge-company-status {
            background: #f1f5f9;
            color: #0f172a;
            border: 1px solid #cbd5e1;
        }

        /* FORM ACTION */
        .action-form {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .action-select {
            padding: 6px 10px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            background: white;
            color: var(--text-main);
            outline: none;
            cursor: pointer;
            transition: all 0.15s;
        }

        .action-select:focus {
            border-color: var(--primary);
        }

        .btn-update {
            padding: 6px 14px;
            border: none;
            border-radius: 8px;
            background: var(--primary);
            color: white;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.15s;
        }

        .btn-update:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        /* EMPTY STATE */
        .empty-state {
            padding: 60px 24px;
            text-align: center;
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
            max-width: 460px;
            margin: 0 auto;
            line-height: 1.5;
        }
    </style>
</head>

<body>

    <!-- TOPBAR -->
    <header class="topbar">
        <a href="collegeAdminDashboard.jsp" class="brand">
            <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
            <div>Campus<span>Connect</span></div>
        </a>

        <div class="top-right">
            <div class="college-pill">
                <i class="fa-solid fa-building-columns"></i>
                <span><%= collegeName %></span>
            </div>
            <a href="collegeAdminDashboard.jsp" class="btn-nav-back">
                <i class="fa-solid fa-arrow-left"></i>
                <span>Dashboard</span>
            </a>
        </div>
    </header>

    <!-- MAIN CONTAINER -->
    <main class="container">

        <!-- BREADCRUMB -->
        <nav class="breadcrumb">
            <a href="collegeAdminDashboard.jsp"><i class="fa-solid fa-house"></i> Dashboard</a>
            <i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i>
            <span>On-Campus Application Management</span>
        </nav>

        <!-- PAGE HEADER -->
        <section class="page-header">
            <div>
                <h1>
                    <i class="fa-solid fa-clipboard-check" style="color: var(--primary);"></i>
                    On-Campus Drive Applications
                </h1>
                <p>
                    Review and shortlist student applicants from your college for institutional on-campus recruitment drives.
                </p>
            </div>
            <div>
                <span class="badge badge-oncampus" style="font-size: 12px; padding: 6px 14px;">
                    <i class="fa-solid fa-filter"></i> Filtered: On-Campus Drives Only
                </span>
            </div>
        </section>

        <!-- TWO SYSTEM ARCHITECTURE INFO CARD -->
        <div class="info-card">
            <i class="fa-solid fa-circle-info"></i>
            <div>
                <strong>Two-Tier Shortlisting Architecture:</strong><br>
                &bull; <strong>On-Campus Drives (Shown here):</strong> Sourced exclusively for your college. As the College Placement Cell, you review candidate eligibility and set <em>College Shortlist Status</em> to approve students before companies conduct interviews.<br>
                &bull; <strong>Off-Campus / Direct Drives:</strong> Sourced globally by corporate recruiters. Candidates apply directly and are reviewed/shortlisted directly by the company hiring team. They do not require college approval and are intentionally excluded from this portal.
            </div>
        </div>

        <!-- STATS -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fa-solid fa-folder-open"></i></div>
                <div class="stat-details">
                    <div class="num"><%= totalCount %></div>
                    <div class="lbl">Total On-Campus Apps</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange"><i class="fa-solid fa-clock"></i></div>
                <div class="stat-details">
                    <div class="num"><%= pendingCount %></div>
                    <div class="lbl">Pending College Review</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fa-solid fa-circle-check"></i></div>
                <div class="stat-details">
                    <div class="num"><%= shortlistedCount %></div>
                    <div class="lbl">Shortlisted by College</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon red"><i class="fa-solid fa-circle-xmark"></i></div>
                <div class="stat-details">
                    <div class="num"><%= rejectedCount %></div>
                    <div class="lbl">Rejected by College</div>
                </div>
            </div>
        </section>

        <!-- FILTER BAR -->
        <div class="filter-bar">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="searchInput" placeholder="Search by student, company, or job..." autocomplete="off">
            </div>

            <div style="display: flex; gap: 10px; align-items: center;">
                <label for="statusFilter" style="font-size: 13px; font-weight: 600; color: var(--text-muted);">Shortlist Status:</label>
                <select id="statusFilter" class="filter-select">
                    <option value="ALL">All Statuses</option>
                    <option value="PENDING">PENDING</option>
                    <option value="SHORTLISTED">SHORTLISTED</option>
                    <option value="REJECTED">REJECTED</option>
                </select>
            </div>
        </div>

        <!-- TABLE CARD -->
        <div class="table-card">
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>App ID</th>
                            <th>Student ID</th>
                            <th>Student Name</th>
                            <th>Company</th>
                            <th>Job Title</th>
                            <th>Drive Type</th>
                            <th>Applied Date</th>
                            <th>Company Status</th>
                            <th>College Shortlist</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody id="appTableBody">
                    <%
                        if (appList.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="10">
                                <div class="empty-state">
                                    <div class="empty-icon"><i class="fa-solid fa-inbox"></i></div>
                                    <h3>No On-Campus Applications Found</h3>
                                    <p>There are currently no student applications submitted for on-campus drives associated with your college.</p>
                                </div>
                            </td>
                        </tr>
                    <%
                        } else {
                            for (AppRow row : appList) {
                                String shortBadgeClass = "badge-pending";
                                if ("SHORTLISTED".equalsIgnoreCase(row.collegeShortlistStatus)) {
                                    shortBadgeClass = "badge-shortlisted";
                                } else if ("REJECTED".equalsIgnoreCase(row.collegeShortlistStatus)) {
                                    shortBadgeClass = "badge-rejected";
                                }
                    %>
                        <tr class="app-row"
                            data-search="<%= (row.appId + " " + row.studentName + " " + row.companyName + " " + row.jobTitle).toLowerCase() %>"
                            data-status="<%= row.collegeShortlistStatus.toUpperCase() %>">
                            
                            <td><span class="badge badge-id">#<%= row.appId %></span></td>
                            <td><strong><%= row.studentId %></strong></td>
                            <td>
                                <strong><%= row.studentName %></strong>
                            </td>
                            <td><strong><%= row.companyName %></strong></td>
                            <td><%= row.jobTitle %></td>
                            <td>
                                <span class="badge badge-oncampus">
                                    <i class="fa-solid fa-building-user"></i> <%= row.driveType %>
                                </span>
                            </td>
                            <td><%= row.appliedDate != null ? row.appliedDate.toString() : "-" %></td>
                            <td>
                                <span class="badge badge-company-status">
                                    <%= row.status %>
                                </span>
                            </td>
                            <td>
                                <span class="badge <%= shortBadgeClass %>">
                                    <%= row.collegeShortlistStatus %>
                                </span>
                            </td>
                            <td style="text-align: right;">
                                <form action="ApplicationShortlistController" method="post" class="action-form">
                                    <input type="hidden" name="applicationId" value="<%= row.appId %>">
                                    
                                    <select name="shortlistStatus" class="action-select">
                                        <option value="PENDING" <%= "PENDING".equalsIgnoreCase(row.collegeShortlistStatus) ? "selected" : "" %>>PENDING</option>
                                        <option value="SHORTLISTED" <%= "SHORTLISTED".equalsIgnoreCase(row.collegeShortlistStatus) ? "selected" : "" %>>SHORTLISTED</option>
                                        <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(row.collegeShortlistStatus) ? "selected" : "" %>>REJECTED</option>
                                    </select>

                                    <button type="submit" class="btn-update">
                                        <i class="fa-solid fa-check"></i> Update
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <script>
        var searchInput = document.getElementById('searchInput');
        var statusFilter = document.getElementById('statusFilter');

        function filterRows() {
            var search = searchInput.value.trim().toLowerCase();
            var status = statusFilter.value.toUpperCase();
            var rows = document.querySelectorAll('.app-row');

            rows.forEach(function(row) {
                var searchText = row.getAttribute('data-search') || '';
                var rowStatus = row.getAttribute('data-status') || '';

                var matchSearch = (search === '' || searchText.indexOf(search) !== -1);
                var matchStatus = (status === 'ALL' || rowStatus === status);

                if (matchSearch && matchStatus) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        searchInput.addEventListener('input', filterRows);
        statusFilter.addEventListener('change', filterRows);
    </script>

</body>
</html>
