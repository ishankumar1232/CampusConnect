<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.campusconnect.bean.SuperAdmin" %>
<%@ page import="com.campusconnect.bean.DashboardBean" %>
<%@ page import="com.campusconnect.bean.SystemActivityLog" %>
<%@ page import="com.campusconnect.dao.DashboardDAO" %>
<%@ page import="com.campusconnect.dao.SystemActivityLogDAO" %>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    DashboardBean dashboard = (DashboardBean) request.getAttribute("dashboard");
    if (dashboard == null) {
        DashboardDAO ddao = new DashboardDAO();
        dashboard = ddao.getDashboardData();
    }

    ArrayList<SystemActivityLog> activityList = (ArrayList<SystemActivityLog>) request.getAttribute("activityList");
    if (activityList == null) {
        SystemActivityLogDAO ldao = new SystemActivityLogDAO();
        activityList = ldao.getAllLogs();
    }

    String adminName = (admin.getName() != null && !admin.getName().trim().isEmpty()) ? admin.getName() : "Administrator";
    String todayStr = new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date());

    int hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
    String timeGreeting = (hour < 12) ? "Good morning" : (hour < 17) ? "Good afternoon" : "Good evening";

    int placementRate = (dashboard.getTotalStudents() > 0) ? (dashboard.getPlacedStudents() * 100 / dashboard.getTotalStudents()) : 0;
    request.setAttribute("activeNav", "dashboard");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Super Admin Dashboard | CampusConnect</title>

<!-- Google Fonts & FontAwesome -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/superadmin-dashboard.css">

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
.charts-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(420px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.chart-card {
    background: white;
    border: 1px solid var(--border-color);
    border-radius: var(--radius-lg);
    padding: 24px;
    box-shadow: var(--shadow-sm);
}

.chart-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.chart-card-title {
    font-size: 16px;
    font-weight: 750;
    color: var(--text-main);
    display: flex;
    align-items: center;
    gap: 8px;
}

.chart-wrapper {
    position: relative;
    height: 280px;
    width: 100%;
}

.progress-track {
    height: 6px;
    background: #e2e8f0;
    border-radius: 9999px;
    overflow: hidden;
    margin-top: 8px;
}

.progress-fill {
    height: 100%;
    background: linear-gradient(90deg, #10b981, #059669);
    border-radius: 9999px;
    transition: width 0.6s ease;
}

.card.highlighted {
    box-shadow: 0 0 0 3px #3b82f6 !important;
    transform: translateY(-4px);
}

.card.dimmed {
    opacity: 0.35;
}
</style>
</head>
<body>

<!-- Top Navigation & Sidebar Include -->
<%@ include file="superAdminNav.jsp" %>

<!-- Main Workspace -->
<main class="main">

    <!-- Utility Action Row -->
    <div class="utility-row">
        <a class="utility-btn" href="${pageContext.request.contextPath}/SystemReportsServlet" title="Analytics &amp; Reports">
            <i class="fa-solid fa-chart-line"></i>
        </a>
        <a class="utility-btn" href="${pageContext.request.contextPath}/SystemSettingsServlet" title="System Settings">
            <i class="fa-solid fa-gear"></i>
        </a>
    </div>

    <!-- Welcome Hero Banner with Time-based Greeting & Live Telemetry -->
    <section class="welcome">
        <div class="welcome-content">
            <div class="welcome-label">SUPER ADMIN CONTROL CENTER</div>
            <h1><%= timeGreeting %>, <%= adminName %>!</h1>
            <p>Your centralized hub for multi-college recruitment governance, institution management, and placement telemetry.</p>
        </div>
        <div class="welcome-badges">
            <div class="welcome-stat-pill">
                <i class="fa-solid fa-shield-halved" style="color: #93c5fd;"></i> Super Administrator Session
            </div>
            <div class="welcome-stat-pill">
                <i class="fa-solid fa-circle-check" style="color: #86efac;"></i> System Online (Oracle 10g XE)
            </div>
            <div class="welcome-stat-pill">
                <i class="fa-solid fa-calendar-day" style="color: #fde047;"></i> <%= todayStr %>
            </div>
        </div>
    </section>

    <!-- User-Friendly Quick Actions Bar -->
    <div class="quick-actions-bar">
        <span class="quick-actions-title">
            <i class="fa-solid fa-bolt" style="color: #f59e0b;"></i> Quick Actions:
        </span>
        <button type="button" class="quick-action-pill primary" onclick="openAddModal()">
            <i class="fa-solid fa-plus"></i> + Onboard College
        </button>
        <a href="${pageContext.request.contextPath}/CompanyManagementServlet" class="quick-action-pill purple">
            <i class="fa-solid fa-building-circle-check"></i> Verify Recruiters (<%=dashboard.getApprovedCompanies()%> Verified)
        </a>
        <a href="${pageContext.request.contextPath}/MonitorRecruitmentServlet" class="quick-action-pill orange">
            <i class="fa-solid fa-bullhorn"></i> Active Drives (<%=dashboard.getActiveDrives()%>)
        </a>
        <a href="${pageContext.request.contextPath}/SystemReportsServlet" class="quick-action-pill green">
            <i class="fa-solid fa-file-pdf"></i> Export Analytics (PDF)
        </a>
        <a href="${pageContext.request.contextPath}/SystemSettingsServlet" class="quick-action-pill primary">
            <i class="fa-solid fa-sliders"></i> Feature Toggles
        </a>
    </div>

    <!-- SECTION 1: KEY PLATFORM METRICS -->
    <div class="section-header">
        <div>
            <h2><i class="fa-solid fa-chart-simple" style="color: #2563eb;"></i> Key Platform Performance</h2>
            <p>Live aggregated counts across institutions, candidates, and recruiters</p>
        </div>
        <a href="${pageContext.request.contextPath}/SystemReportsServlet" class="section-link">
            Full Analytics Dossier &rarr;
        </a>
    </div>

    <section class="metrics-grid">
        <!-- 1. Total Colleges -->
        <div class="stat-card blue">
            <div class="stat-card-top">
                <span class="stat-card-title">Total Colleges</span>
                <div class="stat-card-icon"><i class="fa-solid fa-building-columns"></i></div>
            </div>
            <div class="stat-card-value"><%=dashboard.getTotalColleges()%></div>
            <div class="stat-card-sub">
                <span style="color: #16a34a;"><%=dashboard.getApprovedColleges()%> Approved</span>
                <span>&bull;</span>
                <span style="color: #f59e0b;"><%=dashboard.getPendingColleges()%> Pending</span>
                <span class="card-hover-arrow" style="margin-left: auto;">Manage &rarr;</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/CollegeManagementServlet" title="View Colleges"></a>
        </div>

        <!-- 2. Recruiting Partners -->
        <div class="stat-card purple">
            <div class="stat-card-top">
                <span class="stat-card-title">Recruiting Partners</span>
                <div class="stat-card-icon"><i class="fa-solid fa-building"></i></div>
            </div>
            <div class="stat-card-value"><%=dashboard.getTotalCompanies()%></div>
            <div class="stat-card-sub">
                <span style="color: #16a34a;"><%=dashboard.getApprovedCompanies()%> Verified</span>
                <span>&bull;</span>
                <span style="color: #f59e0b;"><%=dashboard.getPendingCompanies()%> Pending</span>
                <span class="card-hover-arrow" style="margin-left: auto;">Review &rarr;</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/CompanyManagementServlet" title="View Companies"></a>
        </div>

        <!-- 3. Enrolled Students -->
        <div class="stat-card teal">
            <div class="stat-card-top">
                <span class="stat-card-title">Enrolled Students</span>
                <div class="stat-card-icon"><i class="fa-solid fa-user-graduate"></i></div>
            </div>
            <div class="stat-card-value"><%=dashboard.getTotalStudents()%></div>
            <div class="stat-card-sub">
                <span style="color: #0d9488;"><%=dashboard.getTotalStudents()%> Candidate Profiles</span>
                <span class="card-hover-arrow" style="margin-left: auto;">Students &rarr;</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/StudentManagementServlet" title="View Students"></a>
        </div>

        <!-- 4. Placed Candidates -->
        <div class="stat-card green">
            <div class="stat-card-top">
                <span class="stat-card-title">Placed Students</span>
                <div class="stat-card-icon"><i class="fa-solid fa-award"></i></div>
            </div>
            <div class="stat-card-value"><%=dashboard.getPlacedStudents()%></div>
            <div class="stat-card-sub">
                <span style="color: #16a34a;"><%=placementRate%>% Placement Success Rate</span>
                <span class="card-hover-arrow" style="margin-left: auto;">Funnel &rarr;</span>
            </div>
            <div class="progress-track" title="<%=placementRate%>% Placement Rate">
                <div class="progress-fill" style="width: <%=placementRate%>%;"></div>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/SystemReportsServlet" title="View Reports"></a>
        </div>

        <!-- 5. Active Drives -->
        <div class="stat-card orange">
            <div class="stat-card-top">
                <span class="stat-card-title">Active Drives</span>
                <div class="stat-card-icon"><i class="fa-solid fa-bullhorn"></i></div>
            </div>
            <div class="stat-card-value"><%=dashboard.getActiveDrives()%></div>
            <div class="stat-card-sub">
                <span style="color: #ea580c;"><%=dashboard.getActiveDrives()%> Active &bull; <%=dashboard.getCompletedDrives()%> Closed</span>
                <span class="card-hover-arrow" style="margin-left: auto;">Drives &rarr;</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/MonitorRecruitmentServlet" title="View Drives"></a>
        </div>

        <!-- 6. Pending Approvals -->
        <div class="stat-card red">
            <div class="stat-card-top">
                <span class="stat-card-title">Pending Approvals</span>
                <div class="stat-card-icon"><i class="fa-solid fa-clock"></i></div>
            </div>
            <div class="stat-card-value" style="color: <%=dashboard.getPendingApprovals() > 0 ? "#dc2626" : "inherit"%>;">
                <%=dashboard.getPendingApprovals()%>
            </div>
            <div class="stat-card-sub">
                <span><%=dashboard.getPendingApprovals() > 0 ? "Requires Immediate Action" : "All Accounts Verified"%></span>
                <span class="card-hover-arrow" style="margin-left: auto;">Audit &rarr;</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/CollegeManagementServlet" title="Pending Approvals"></a>
        </div>
    </section>

    <!-- SECTION 2: INSTITUTIONAL & CORPORATE GOVERNANCE -->
    <div class="section-header">
        <div>
            <h2><i class="fa-solid fa-landmark" style="color: #3b82f6;"></i> Institutional &amp; Corporate Governance</h2>
            <p>Direct control over partner colleges, academic programs, and verified employer accounts</p>
        </div>
    </div>

    <section class="dashboard-grid">
        <article class="card" data-keywords="manage colleges institutions departments courses approvals">
            <div class="card-icon"><i class="fa-solid fa-building-columns"></i></div>
            <h3>Manage Colleges</h3>
            <p>Review affiliated colleges, departments, course catalogs, and admission requests.</p>
            <div class="card-meta">
                <span><strong><%=dashboard.getTotalColleges()%></strong> Total Institutions</span>
                <span class="badge-tag">Directory</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/CollegeManagementServlet"></a>
        </article>

        <article class="card" data-keywords="onboard new college register institution create primary admin">
            <div class="card-icon"><i class="fa-solid fa-plus"></i></div>
            <h3>Onboard New College</h3>
            <p>Directly provision and register a new academic institution with primary administrative credentials.</p>
            <div class="card-meta">
                <span>Instant Provisioning</span>
                <span class="badge-tag">Setup</span>
            </div>
            <a class="card-link" href="javascript:void(0)" onclick="openAddModal()"></a>
        </article>

        <article class="card purple" data-keywords="corporate recruiters companies employers verify hiring partners">
            <div class="card-icon"><i class="fa-solid fa-building"></i></div>
            <h3>Corporate Recruiters</h3>
            <p>Review hiring partner registrations, verify corporate profiles, and audit employer credentials.</p>
            <div class="card-meta">
                <span><strong><%=dashboard.getTotalCompanies()%></strong> Total Partners</span>
                <span class="badge-tag">Recruiters</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/CompanyManagementServlet"></a>
        </article>

        <article class="card purple" data-keywords="college administrators staff accounts assign credentials permissions">
            <div class="card-icon"><i class="fa-solid fa-users-gear"></i></div>
            <h3>College Administrators</h3>
            <p>Oversee and manage dedicated administrative staff accounts for each registered institution.</p>
            <div class="card-meta">
                <span>Access Control</span>
                <span class="badge-tag">Admins</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/UserManagementServlet"></a>
        </article>
    </section>

    <!-- SECTION 3: RECRUITMENT DRIVES & TALENT PIPELINE -->
    <div class="section-header">
        <div>
            <h2><i class="fa-solid fa-graduation-cap" style="color: #10b981;"></i> Recruitment Drives &amp; Placement Engine</h2>
            <p>Monitor student candidates, active placement drives, rounds progression, and confirmed selections</p>
        </div>
    </div>

    <section class="dashboard-grid">
        <article class="card green" data-keywords="student directory candidates resumes academics profiles">
            <div class="card-icon"><i class="fa-solid fa-user-graduate"></i></div>
            <h3>Student Directory</h3>
            <p>Access complete candidate records, academic profiles, resumes, and platform access states.</p>
            <div class="card-meta">
                <span><strong><%=dashboard.getTotalStudents()%></strong> Candidates</span>
                <span class="badge-tag">Talent Pool</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/StudentManagementServlet"></a>
        </article>

        <article class="card orange" data-keywords="recruitment drives campus direct jobs interviews hiring">
            <div class="card-icon"><i class="fa-solid fa-bullhorn"></i></div>
            <h3>Recruitment Drives</h3>
            <p>Supervise on-campus and direct recruitment drives, candidate applicants, and interview slots.</p>
            <div class="card-meta">
                <span><strong><%=dashboard.getActiveDrives()%></strong> Live Drives</span>
                <span class="badge-tag">Hiring</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/MonitorRecruitmentServlet"></a>
        </article>

        <article class="card green" data-keywords="selections offers placed students ctc salary packages results">
            <div class="card-icon"><i class="fa-solid fa-award"></i></div>
            <h3>Selections &amp; Offers</h3>
            <p>Track finalized student placements, salary package distributions, and selection conversions.</p>
            <div class="card-meta">
                <span><strong><%=dashboard.getPlacedStudents()%></strong> Confirmed Offers</span>
                <span class="badge-tag">Offers</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/SystemReportsServlet"></a>
        </article>

        <article class="card red" data-keywords="platform governance system settings feature toggles maintenance registration">
            <div class="card-icon"><i class="fa-solid fa-sliders"></i></div>
            <h3>Platform Governance</h3>
            <p>Control system-wide registration gates, module availability, and emergency maintenance controls.</p>
            <div class="card-meta">
                <span>System Policy</span>
                <span class="badge-tag">Controls</span>
            </div>
            <a class="card-link" href="${pageContext.request.contextPath}/SystemSettingsServlet"></a>
        </article>
    </section>

    <!-- SECTION 4: VISUAL ANALYTICS & AUDIT TELEMETRY -->
    <div class="section-header">
        <div>
            <h2><i class="fa-solid fa-chart-pie" style="color: #6366f1;"></i> Visual Intelligence &amp; Activity Telemetry</h2>
            <p>Real-time institutional breakdown, recruitment funnel metrics, and administrative audit logs</p>
        </div>
    </div>

    <!-- Charts Section -->
    <div class="charts-grid">
        <div class="chart-card">
            <div class="chart-card-header">
                <div class="chart-card-title">
                    <i class="fa-solid fa-chart-pie" style="color: #2563eb;"></i>
                    <span>Institutions &amp; Recruiters Status</span>
                </div>
                <span class="badge badge-primary">Database Sync</span>
            </div>
            <div class="chart-wrapper">
                <canvas id="institutionChart"></canvas>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-card-header">
                <div class="chart-card-title">
                    <i class="fa-solid fa-chart-column" style="color: #10b981;"></i>
                    <span>Recruitment Drive Funnel</span>
                </div>
                <span class="badge badge-approved">Live Pipeline</span>
            </div>
            <div class="chart-wrapper">
                <canvas id="funnelChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Recent Platform Activity Table with Search & Filter -->
    <div class="content-card">
        <div class="card-header">
            <div>
                <h3 class="card-title"><i class="fa-solid fa-list-check" style="color: #2563eb; margin-right: 8px;"></i>Platform Activity &amp; Audit Logs</h3>
                <p class="card-subtitle">Real-time system telemetry and administrator event trail.</p>
            </div>
            <div class="activity-filter-box">
                <input type="text"
                       id="activitySearchInput"
                       class="activity-filter-input"
                       placeholder="Filter audit events..."
                       onkeyup="filterActivityTable(this.value)">
                <button type="button" class="btn btn-sm btn-outline" onclick="window.print()">
                    <i class="fa-solid fa-print"></i> Print
                </button>
            </div>
        </div>
        <div class="table-container">
            <table class="data-table" id="activityTable">
                <thead>
                    <tr>
                        <th style="width: 100px;">Log ID</th>
                        <th style="width: 200px;">Timestamp</th>
                        <th>Activity &amp; Audit Event</th>
                        <th style="width: 120px;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (activityList != null && !activityList.isEmpty()) {
                        for (SystemActivityLog log : activityList) {
                    %>
                    <tr>
                        <td><strong>#<%=log.getLogId()%></strong></td>
                        <td><%=log.getActivityDate() != null ? log.getActivityDate() : "N/A"%></td>
                        <td><%=log.getActivity() != null ? log.getActivity() : "System Event"%></td>
                        <td><span class="badge badge-success">Recorded</span></td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 30px;">
                            <i class="fa-solid fa-inbox" style="font-size: 24px; margin-bottom: 8px; display: block;"></i>
                            No recorded system events found in activity log.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Footer placed cleanly INSIDE main -->
    <footer class="footer">
        CampusConnect Platform &bull; Super Administrator Central Control Center &bull; All rights reserved.
    </footer>

</main>

<!-- Quick Add College Modal directly on Dashboard -->
<div class="modal-backdrop" id="addCollegeModal" style="display: none;">
    <div class="modal-card">
        <div class="modal-header">
            <h3><i class="fa-solid fa-building-columns" style="color: #2563eb; margin-right: 8px;"></i>Quick Onboard College Institution</h3>
            <button type="button" class="modal-close" onclick="closeAddModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/AddCollegeServlet" method="post">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" for="colName">Institution Name <span class="req">*</span></label>
                    <input type="text" id="colName" name="collegeName" class="form-control" placeholder="e.g. Asansol Engineering College" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="colCity">City <span class="req">*</span></label>
                        <input type="text" id="colCity" name="city" class="form-control" placeholder="e.g. Asansol" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="colState">State <span class="req">*</span></label>
                        <input type="text" id="colState" name="state" class="form-control" placeholder="e.g. West Bengal" required>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="colAddress">Address</label>
                    <input type="text" id="colAddress" name="address" class="form-control" placeholder="Campus Street, District">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="colEmail">Official College Email <span class="req">*</span></label>
                        <input type="email" id="colEmail" name="email" class="form-control" placeholder="info@aec.edu.in" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="colPhone">Contact Phone</label>
                        <input type="text" id="colPhone" name="phone" class="form-control" placeholder="+91 9876543210">
                    </div>
                </div>

                <div style="margin-top: 16px; padding-top: 14px; border-top: 1px dashed #cbd5e1;">
                    <h4 style="font-size: 14px; font-weight: 700; color: #0f172a; margin-bottom: 8px;">
                        <i class="fa-solid fa-user-shield" style="color: #2563eb; margin-right: 6px;"></i>Initial College Administrator Account
                    </h4>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="adminName">Admin Full Name <span class="req">*</span></label>
                            <input type="text" id="adminName" name="adminName" class="form-control" placeholder="Dr. S. Mukherjee" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="adminEmail">Admin Login Email <span class="req">*</span></label>
                            <input type="email" id="adminEmail" name="adminEmail" class="form-control" placeholder="admin@aec.edu.in" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="adminPassword">Admin Password <span class="req">*</span></label>
                        <input type="password" id="adminPassword" name="adminPassword" class="form-control" placeholder="Secure password" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeAddModal()">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-check"></i> Onboard College</button>
            </div>
        </form>
    </div>
</div>

<script>
// Modal Controls
function openAddModal() {
    document.getElementById('addCollegeModal').style.display = 'flex';
}
function closeAddModal() {
    document.getElementById('addCollegeModal').style.display = 'none';
}

// Global Nav & Dashboard Live Filter
function handleGlobalSearch(term) {
    term = term.toLowerCase().trim();
    const cards = document.querySelectorAll('.dashboard-grid .card');
    cards.forEach(card => {
        const keywords = (card.getAttribute('data-keywords') || '') + ' ' + card.innerText.toLowerCase();
        if (!term || keywords.includes(term)) {
            card.classList.remove('dimmed');
            if (term) card.classList.add('highlighted');
            else card.classList.remove('highlighted');
        } else {
            card.classList.add('dimmed');
            card.classList.remove('highlighted');
        }
    });
}

// Filter Audit Activity Table
function filterActivityTable(term) {
    term = term.toLowerCase().trim();
    const rows = document.querySelectorAll('#activityTable tbody tr');
    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        row.style.display = (!term || text.includes(term)) ? '' : 'none';
    });
}

// Keyboard shortcuts for Super Admin
document.addEventListener('keydown', function(e) {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        const search = document.getElementById('globalNavSearch');
        if (search) search.focus();
    }
    if (e.key === 'Escape') {
        closeAddModal();
    }
});

// Chart 1: Institutional & Corporate Status
const ctx1 = document.getElementById('institutionChart').getContext('2d');
new Chart(ctx1, {
    type: 'doughnut',
    data: {
        labels: ['Approved Colleges', 'Pending Colleges', 'Verified Companies', 'Pending Companies'],
        datasets: [{
            data: [
                <%=dashboard.getApprovedColleges()%>,
                <%=dashboard.getPendingColleges()%>,
                <%=dashboard.getApprovedCompanies()%>,
                <%=dashboard.getPendingCompanies()%>
            ],
            backgroundColor: ['#2563eb', '#f59e0b', '#10b981', '#f97316'],
            borderWidth: 2,
            borderColor: '#ffffff'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { position: 'bottom', labels: { font: { family: 'Plus Jakarta Sans', size: 12 } } }
        }
    }
});

// Chart 2: Recruitment Drive Funnel
const ctx2 = document.getElementById('funnelChart').getContext('2d');
new Chart(ctx2, {
    type: 'bar',
    data: {
        labels: ['Active Drives', 'Applications', 'Selected / Offers', 'Placed Students'],
        datasets: [{
            label: 'Candidate Volume',
            data: [
                <%=dashboard.getActiveDrives()%>,
                <%=dashboard.getTotalApplications()%>,
                <%=dashboard.getTotalSelections()%>,
                <%=dashboard.getPlacedStudents()%>
            ],
            backgroundColor: ['#3b82f6', '#8b5cf6', '#10b981', '#059669'],
            borderRadius: 8
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
            y: { beginAtZero: true, grid: { color: '#f1f5f9' } },
            x: { grid: { display: false } }
        },
        plugins: {
            legend: { display: false }
        }
    }
});
</script>

</body>
</html>
