<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.RecruitmentDrive"%>
<%@ page import="com.campusconnect.bean.SuperAdmin"%>
<%@ page import="com.campusconnect.dao.RecruitmentDriveDAO"%>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    ArrayList<RecruitmentDrive> list = (ArrayList<RecruitmentDrive>) request.getAttribute("driveList");
    if (list == null) {
        RecruitmentDriveDAO dao = new RecruitmentDriveDAO();
        list = dao.getAllDrives();
    }

    int totalDrives = 0;
    int campusDrives = 0;
    int directDrives = 0;
    int activeDrives = 0;
    int closedDrives = 0;
    int totalApplications = 0;
    int totalSelected = 0;

    if (list != null) {
        totalDrives = list.size();
        for (RecruitmentDrive d : list) {
            String type = d.getDriveType() != null ? d.getDriveType().toUpperCase() : "";
            if (type.contains("CAMPUS")) campusDrives++;
            else directDrives++;

            String st = d.getStatus() != null ? d.getStatus().toUpperCase() : "";
            if ("ACTIVE".equals(st)) activeDrives++;
            else closedDrives++;

            totalApplications += d.getApplicationCount();
            totalSelected += d.getSelectedCount();
        }
    }

    request.setAttribute("activeNav", "drives");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Recruitment Drives Telemetry | CampusConnect</title>

<!-- Google Fonts & FontAwesome -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/superadmin-dashboard.css">
</head>
<body>

<!-- Navigation Include -->
<%@ include file="superAdminNav.jsp" %>

<!-- Main Content -->
<main class="main">

    <!-- Page Toolbar -->
    <div class="page-toolbar">
        <div class="page-title-block">
            <h1>Platform Recruitment Drives Telemetry</h1>
            <p>Monitor multi-college campus recruitment drives, direct corporate hiring campaigns, and candidate pipelines.</p>
        </div>
    </div>

    <!-- KPI Metric Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Total Drives</span>
                    <div class="kpi-value"><%=totalDrives%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-bullhorn"></i></div>
            </div>
            <div class="kpi-subtext">Hiring campaigns initiated</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Campus Drives</span>
                    <div class="kpi-value" style="color: #2563eb;"><%=campusDrives%></div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-building-columns"></i></div>
            </div>
            <div class="kpi-subtext">Multi-college targeted drives</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Direct Drives</span>
                    <div class="kpi-value" style="color: #7c3aed;"><%=directDrives%></div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-globe"></i></div>
            </div>
            <div class="kpi-subtext">Open application hiring</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Applications Received</span>
                    <div class="kpi-value"><%=totalApplications%></div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-file-signature"></i></div>
            </div>
            <div class="kpi-subtext">Submissions across all colleges</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Selected / Offers</span>
                    <div class="kpi-value" style="color: #16a34a;"><%=totalSelected%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-award"></i></div>
            </div>
            <div class="kpi-subtext">Confirmed student selections</div>
        </div>
    </div>

    <!-- Content Card with Live Search & Filter -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">
                <i class="fa-solid fa-bullhorn" style="color: #2563eb;"></i>
                <span>All Recruitment Drives (<span id="visibleDriveCount"><%=totalDrives%></span>)</span>
            </div>
            <div class="filter-bar">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="driveSearch" placeholder="Search by role, company, branch..." onkeyup="filterDriveTable()">
                </div>
                <select id="driveTypeFilter" class="filter-select" onchange="filterDriveTable()">
                    <option value="">All Drive Types</option>
                    <option value="CAMPUS">Campus Drives Only</option>
                    <option value="DIRECT">Direct Drives Only</option>
                </select>
                <select id="driveStatusFilter" class="filter-select" onchange="filterDriveTable()">
                    <option value="">All Statuses</option>
                    <option value="ACTIVE">Active Only</option>
                    <option value="CLOSED">Closed Only</option>
                </select>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table" id="driveTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Job Title & Company</th>
                        <th>Type</th>
                        <th>Package (CTC)</th>
                        <th>Eligibility</th>
                        <th>Vacancies</th>
                        <th>Applications</th>
                        <th>Selections</th>
                        <th>Status</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (list != null && !list.isEmpty()) {
                        for (RecruitmentDrive d : list) {
                            String rawType = d.getDriveType() != null ? d.getDriveType() : "Campus Drive";
                            String typeBadge = rawType.toUpperCase().contains("CAMPUS") ? "badge-campus" : "badge-direct";
                            String rawStatus = d.getStatus() != null ? d.getStatus() : "ACTIVE";
                            String statusBadge = "ACTIVE".equalsIgnoreCase(rawStatus) ? "badge-approved" : "badge-rejected";
                    %>
                    <tr data-type="<%=rawType.toUpperCase()%>" data-status="<%=rawStatus.toUpperCase()%>">
                        <td><strong>#<%=d.getDriveId()%></strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/DriveDetailsServlet?id=<%=d.getDriveId()%>"
                               style="font-weight: 700; color: #2563eb; display: block;">
                                <%=d.getJobTitle()%>
                            </a>
                            <span style="font-size: 12px; color: var(--text-muted); display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                <i class="fa-regular fa-building"></i>
                                <%=d.getCompanyName()%>
                            </span>
                        </td>
                        <td><span class="badge <%=typeBadge%>"><%=rawType%></span></td>
                        <td><strong>₹<%=d.getSalary()%> LPA</strong></td>
                        <td>
                            <span style="font-size: 13px; color: #334155;">&ge; <%=d.getEligibilityCgpa()%> CGPA</span>
                        </td>
                        <td><%=d.getVacancy()%> Seats</td>
                        <td>
                            <span class="badge badge-primary"><%=d.getApplicationCount()%> applied</span>
                        </td>
                        <td>
                            <span class="badge badge-approved"><%=d.getSelectedCount()%> hired</span>
                        </td>
                        <td><span class="badge <%=statusBadge%>"><%=rawStatus%></span></td>
                        <td style="text-align: right;">
                            <a href="${pageContext.request.contextPath}/DriveDetailsServlet?id=<%=d.getDriveId()%>"
                               class="btn btn-outline btn-sm" title="View Full Drive Details & Participating Colleges">
                                <i class="fa-solid fa-eye"></i>
                                <span>Drive Dossier</span>
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="10" style="text-align: center; color: var(--text-muted); padding: 40px;">
                            <i class="fa-solid fa-bullhorn" style="font-size: 28px; margin-bottom: 10px; display: block;"></i>
                            No recruitment drives currently posted on the platform.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</main>

<footer class="footer">
    &copy; CampusConnect Platform. Super Administrator Control Center.
</footer>

<script>
function filterDriveTable() {
    const search = document.getElementById('driveSearch').value.toLowerCase();
    const type = document.getElementById('driveTypeFilter').value.toUpperCase();
    const status = document.getElementById('driveStatusFilter').value.toUpperCase();
    const rows = document.querySelectorAll('#driveTable tbody tr');
    let visible = 0;

    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const rowType = row.getAttribute('data-type') || '';
        const rowStatus = row.getAttribute('data-status') || '';

        const matchesSearch = text.includes(search);
        const matchesType = !type || rowType.includes(type);
        const matchesStatus = !status || rowStatus === status;

        if (matchesSearch && matchesType && matchesStatus) {
            row.style.display = '';
            visible++;
        } else {
            row.style.display = 'none';
        }
    });

    const countElem = document.getElementById('visibleDriveCount');
    if (countElem) countElem.innerText = visible;
}
</script>

</body>
</html>
