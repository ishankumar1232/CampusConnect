<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.SuperAdmin" %>
<%@ page import="com.campusconnect.dao.ReportDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    Integer collegeCount = (Integer) request.getAttribute("collegeCount");
    Integer approvedCollege = (Integer) request.getAttribute("approvedCollege");
    Integer rejectedCollege = (Integer) request.getAttribute("rejectedCollege");

    Integer companyCount = (Integer) request.getAttribute("companyCount");
    Integer approvedCompany = (Integer) request.getAttribute("approvedCompany");
    Integer rejectedCompany = (Integer) request.getAttribute("rejectedCompany");

    Integer studentCount = (Integer) request.getAttribute("studentCount");
    Integer activeStudent = (Integer) request.getAttribute("activeStudent");
    Integer inactiveStudent = (Integer) request.getAttribute("inactiveStudent");

    Integer driveCount = (Integer) request.getAttribute("driveCount");
    Integer applicationCount = (Integer) request.getAttribute("applicationCount");
    Integer placedCount = (Integer) request.getAttribute("placedCount");

    // Self-healing fetch if accessed directly without servlet
    if (collegeCount == null) {
        ReportDAO rdao = new ReportDAO();
        java.util.Map<String, Integer> counts = rdao.getSystemReportCounts();
        collegeCount = counts.getOrDefault("collegeCount", 0);
        approvedCollege = counts.getOrDefault("approvedCollege", 0);
        rejectedCollege = counts.getOrDefault("rejectedCollege", 0);
        companyCount = counts.getOrDefault("companyCount", 0);
        approvedCompany = counts.getOrDefault("approvedCompany", 0);
        rejectedCompany = counts.getOrDefault("rejectedCompany", 0);
        studentCount = counts.getOrDefault("studentCount", 0);
        activeStudent = counts.getOrDefault("activeStudent", 0);
        inactiveStudent = counts.getOrDefault("inactiveStudent", 0);
        driveCount = counts.getOrDefault("driveCount", 0);
        applicationCount = counts.getOrDefault("applicationCount", 0);
        placedCount = counts.getOrDefault("placedCount", 0);
    }

    if (collegeCount == null) collegeCount = 0;
    if (approvedCollege == null) approvedCollege = 0;
    if (rejectedCollege == null) rejectedCollege = 0;
    if (companyCount == null) companyCount = 0;
    if (approvedCompany == null) approvedCompany = 0;
    if (rejectedCompany == null) rejectedCompany = 0;
    if (studentCount == null) studentCount = 0;
    if (activeStudent == null) activeStudent = 0;
    if (inactiveStudent == null) inactiveStudent = 0;
    if (driveCount == null) driveCount = 0;
    if (applicationCount == null) applicationCount = 0;
    if (placedCount == null) placedCount = 0;

    int pendingColleges = Math.max(0, collegeCount - (approvedCollege + rejectedCollege));
    int pendingCompanies = Math.max(0, companyCount - (approvedCompany + rejectedCompany));

    double placementRate = (studentCount > 0 && placedCount != null) ? ((double) placedCount / studentCount * 100.0) : 0.0;
    String placementRateFormatted = String.format("%.1f", placementRate);

    String reportDate = new SimpleDateFormat("dd MMMM yyyy, hh:mm a").format(new Date());
    request.setAttribute("activeNav", "reports");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Platform Analytics & Reports | CampusConnect</title>

<!-- Google Fonts & FontAwesome -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/superadmin-dashboard.css">

<style>
@media print {
    .topbar, .sidebar, .page-actions, .footer, .btn {
        display: none !important;
    }
    .main {
        margin: 0 !important;
        padding: 0 !important;
        width: 100% !important;
    }
    .content-card {
        box-shadow: none !important;
        border: 1px solid #000 !important;
        page-break-inside: avoid;
    }
}
</style>
</head>
<body>

<!-- Navigation Include -->
<%@ include file="superAdminNav.jsp" %>

<!-- Main Content -->
<main class="main">

    <!-- Page Toolbar -->
    <div class="page-toolbar">
        <div class="page-title-block">
            <h1>Comprehensive Platform Analytics Report</h1>
            <p>Audited database metrics as of <%=reportDate%> &bull; CampusConnect Central Telemetry</p>
        </div>
        <div class="page-actions">
            <button type="button" class="btn btn-primary" onclick="window.print()">
                <i class="fa-solid fa-print"></i>
                <span>Print / Export PDF</span>
            </button>
        </div>
    </div>

    <!-- KPI Summary Grid -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Colleges</span>
                    <div class="kpi-value"><%=collegeCount%></div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-building-columns"></i></div>
            </div>
            <div class="kpi-subtext">Approved: <%=approvedCollege%> &bull; Pending: <%=pendingColleges%></div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Recruiters</span>
                    <div class="kpi-value"><%=companyCount%></div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-building"></i></div>
            </div>
            <div class="kpi-subtext">Verified: <%=approvedCompany%> &bull; Pending: <%=pendingCompanies%></div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Students</span>
                    <div class="kpi-value"><%=studentCount%></div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-user-graduate"></i></div>
            </div>
            <div class="kpi-subtext">Active: <%=activeStudent%> &bull; Inactive: <%=inactiveStudent%></div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Placement Rate</span>
                    <div class="kpi-value" style="color: #16a34a;"><%=placementRateFormatted%>%</div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-chart-line"></i></div>
            </div>
            <div class="kpi-subtext"><%=placedCount%> Students Placed</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Total Drives</span>
                    <div class="kpi-value"><%=driveCount%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-bullhorn"></i></div>
            </div>
            <div class="kpi-subtext">Applications: <%=applicationCount%></div>
        </div>
    </div>

    <!-- Section 1: Institutional & Corporate Distribution Report -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(420px, 1fr)); gap: 24px; margin-bottom: 24px;">
        <!-- College Metrics -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-building-columns" style="color: #2563eb;"></i>
                    <span>Colleges & Educational Institutions Breakdown</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Institutional Metric Category</th>
                            <th style="text-align: right;">Count</th>
                            <th style="text-align: right;">Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><i class="fa-solid fa-check" style="color: #16a34a; margin-right: 6px;"></i>Approved & Active Colleges</td>
                            <td style="text-align: right;"><strong><%=approvedCollege%></strong></td>
                            <td style="text-align: right;"><span class="badge badge-approved"><%=collegeCount > 0 ? Math.round((double)approvedCollege/collegeCount*100) : 0%>%</span></td>
                        </tr>
                        <tr>
                            <td><i class="fa-solid fa-hourglass-half" style="color: #d97706; margin-right: 6px;"></i>Pending Institutional Approvals</td>
                            <td style="text-align: right;"><strong><%=pendingColleges%></strong></td>
                            <td style="text-align: right;"><span class="badge badge-pending"><%=collegeCount > 0 ? Math.round((double)pendingColleges/collegeCount*100) : 0%>%</span></td>
                        </tr>
                        <tr>
                            <td><i class="fa-solid fa-ban" style="color: #dc2626; margin-right: 6px;"></i>Rejected / Suspended Colleges</td>
                            <td style="text-align: right;"><strong><%=rejectedCollege%></strong></td>
                            <td style="text-align: right;"><span class="badge badge-rejected"><%=collegeCount > 0 ? Math.round((double)rejectedCollege/collegeCount*100) : 0%>%</span></td>
                        </tr>
                        <tr style="background: #f8fafc; font-weight: 700;">
                            <td>Total Registered Institutions</td>
                            <td style="text-align: right;"><%=collegeCount%></td>
                            <td style="text-align: right;">100%</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Recruiter Metrics -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-building" style="color: #7c3aed;"></i>
                    <span>Recruiting Partners & Corporate Status</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Corporate Metric Category</th>
                            <th style="text-align: right;">Count</th>
                            <th style="text-align: right;">Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><i class="fa-solid fa-check-double" style="color: #16a34a; margin-right: 6px;"></i>Verified & Active Recruiters</td>
                            <td style="text-align: right;"><strong><%=approvedCompany%></strong></td>
                            <td style="text-align: right;"><span class="badge badge-approved"><%=companyCount > 0 ? Math.round((double)approvedCompany/companyCount*100) : 0%>%</span></td>
                        </tr>
                        <tr>
                            <td><i class="fa-solid fa-hourglass-half" style="color: #d97706; margin-right: 6px;"></i>Pending Recruiter Verifications</td>
                            <td style="text-align: right;"><strong><%=pendingCompanies%></strong></td>
                            <td style="text-align: right;"><span class="badge badge-pending"><%=companyCount > 0 ? Math.round((double)pendingCompanies/companyCount*100) : 0%>%</span></td>
                        </tr>
                        <tr>
                            <td><i class="fa-solid fa-ban" style="color: #dc2626; margin-right: 6px;"></i>Rejected Recruiter Accounts</td>
                            <td style="text-align: right;"><strong><%=rejectedCompany%></strong></td>
                            <td style="text-align: right;"><span class="badge badge-rejected"><%=companyCount > 0 ? Math.round((double)rejectedCompany/companyCount*100) : 0%>%</span></td>
                        </tr>
                        <tr style="background: #f8fafc; font-weight: 700;">
                            <td>Total Hiring Organizations</td>
                            <td style="text-align: right;"><%=companyCount%></td>
                            <td style="text-align: right;">100%</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Section 2: Student Enrollment & Placement Statistics -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">
                <i class="fa-solid fa-award" style="color: #10b981;"></i>
                <span>Candidate Pipeline & Placement Conversion Telemetry</span>
            </div>
        </div>
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Recruitment Funnel Stage</th>
                        <th>Audited Volume</th>
                        <th>Conversion Rate</th>
                        <th>Administrative Assessment</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Total Enrolled Students</strong></td>
                        <td><%=studentCount%> candidates</td>
                        <td>Baseline (100%)</td>
                        <td><span class="badge badge-primary">Platform Talent Pool</span></td>
                    </tr>
                    <tr>
                        <td><strong>Active Student Logins</strong></td>
                        <td><%=activeStudent%> accounts</td>
                        <td><%=studentCount > 0 ? Math.round((double)activeStudent/studentCount*100) : 0%>% of pool</td>
                        <td><span class="badge badge-approved">Eligible for Drives</span></td>
                    </tr>
                    <tr>
                        <td><strong>Recruitment Drives Conducted</strong></td>
                        <td><%=driveCount%> drives</td>
                        <td>N/A</td>
                        <td><span class="badge badge-campus">Campus & Direct</span></td>
                    </tr>
                    <tr>
                        <td><strong>Applications Processed</strong></td>
                        <td><%=applicationCount%> applications</td>
                        <td><%=studentCount > 0 ? String.format("%.1f", (double)applicationCount/studentCount) : "0"%> apps/student</td>
                        <td><span class="badge badge-primary">Candidate Engagement</span></td>
                    </tr>
                    <tr style="background: #f0fdf4;">
                        <td><strong style="color: #166534;">Placed Candidates (Confirmed Offers)</strong></td>
                        <td><strong style="color: #166534; font-size: 16px;"><%=placedCount%> students</strong></td>
                        <td><strong style="color: #166534;"><%=placementRateFormatted%>% Success Rate</strong></td>
                        <td><span class="badge badge-approved">Confirmed Selections</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</main>

<footer class="footer">
    &copy; CampusConnect Platform. Super Administrator Control Center.
</footer>

</body>
</html>
