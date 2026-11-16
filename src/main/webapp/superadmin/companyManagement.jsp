<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.campusconnect.bean.Company" %>
<%@ page import="com.campusconnect.bean.SuperAdmin" %>
<%@ page import="com.campusconnect.dao.CompanyDAO" %>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    ArrayList<Company> list = (ArrayList<Company>) request.getAttribute("companyList");
    if (list == null) {
        CompanyDAO dao = new CompanyDAO();
        list = dao.getAllCompanies();
    }

    int totalCompanies = 0;
    int approvedCount = 0;
    int pendingCount = 0;
    int rejectedCount = 0;

    if (list != null) {
        totalCompanies = list.size();
        for (Company c : list) {
            String st = c.getStatus() != null ? c.getStatus().toUpperCase() : "";
            if ("APPROVED".equals(st)) approvedCount++;
            else if ("PENDING".equals(st)) pendingCount++;
            else if ("REJECTED".equals(st)) rejectedCount++;
        }
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    request.setAttribute("activeNav", "companies");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Recruiting Companies | CampusConnect</title>

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
            <h1>Corporate Recruiters & Companies</h1>
            <p>Verify corporate onboarding requests, monitor hiring partners, and audit recruitment opportunities.</p>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <% if ("approved".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>Recruiting company account verified and approved. Company can now schedule campus placement drives.</span>
        </div>
    <% } else if ("rejected".equalsIgnoreCase(success)) { %>
        <div class="alert alert-warning">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span>Company account has been rejected or suspended.</span>
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>Action could not be completed. Please verify database connection.</span>
        </div>
    <% } %>

    <!-- KPI Metric Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Total Recruiters</span>
                    <div class="kpi-value"><%=totalCompanies%></div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-building"></i></div>
            </div>
            <div class="kpi-subtext">Hiring organizations registered</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Verified & Active</span>
                    <div class="kpi-value" style="color: #16a34a;"><%=approvedCount%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-shield-check"></i></div>
            </div>
            <div class="kpi-subtext">Authorized to post drives & hire</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Pending Verification</span>
                    <div class="kpi-value" style="color: #d97706;"><%=pendingCount%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-hourglass-half"></i></div>
            </div>
            <div class="kpi-subtext">Awaiting administrative approval</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Rejected Accounts</span>
                    <div class="kpi-value" style="color: #dc2626;"><%=rejectedCount%></div>
                </div>
                <div class="kpi-icon red"><i class="fa-solid fa-ban"></i></div>
            </div>
            <div class="kpi-subtext">Declined or deactivated partners</div>
        </div>
    </div>

    <!-- Content Card with Live Search & Filter -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">
                <i class="fa-solid fa-building" style="color: #2563eb;"></i>
                <span>Corporate Partners Directory (<span id="visibleCompCount"><%=totalCompanies%></span>)</span>
            </div>
            <div class="filter-bar">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="compSearch" placeholder="Search by name, email, website..." onkeyup="filterCompanyTable()">
                </div>
                <select id="compStatusFilter" class="filter-select" onchange="filterCompanyTable()">
                    <option value="">All Statuses</option>
                    <option value="APPROVED">Verified Only</option>
                    <option value="PENDING">Pending Only</option>
                    <option value="REJECTED">Rejected Only</option>
                </select>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table" id="companyTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Company Name</th>
                        <th>Contact Email</th>
                        <th>Phone</th>
                        <th>Website</th>
                        <th>Status</th>
                        <th style="text-align: right;">Administrative Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (list != null && !list.isEmpty()) {
                        for (Company c : list) {
                            String rawStatus = c.getStatus() != null ? c.getStatus().trim() : "Pending";
                            String badgeClass = "badge-pending";
                            if ("Approved".equalsIgnoreCase(rawStatus)) badgeClass = "badge-approved";
                            else if ("Rejected".equalsIgnoreCase(rawStatus)) badgeClass = "badge-rejected";
                    %>
                    <tr data-status="<%=rawStatus.toUpperCase()%>">
                        <td><strong>#<%=c.getCompanyId()%></strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/CompanyDetailsServlet?id=<%=c.getCompanyId()%>"
                               style="font-weight: 700; color: #2563eb; display: flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-building" style="font-size: 13px; color: #64748b;"></i>
                                <span><%=c.getCompanyName()%></span>
                            </a>
                        </td>
                        <td>
                            <a href="mailto:<%=c.getEmail()%>" style="color: #64748b; font-size: 13px;">
                                <i class="fa-regular fa-envelope" style="margin-right: 4px;"></i>
                                <%=c.getEmail() != null ? c.getEmail() : "N/A"%>
                            </a>
                        </td>
                        <td><%=c.getPhone() != null && !c.getPhone().isEmpty() ? c.getPhone() : "N/A"%></td>
                        <td>
                            <% if (c.getWebsite() != null && !c.getWebsite().trim().isEmpty()) { %>
                                <a href="<%=c.getWebsite().startsWith("http") ? c.getWebsite() : "https://" + c.getWebsite()%>" target="_blank" style="color: #2563eb; font-size: 13px;">
                                    <i class="fa-solid fa-arrow-up-right-from-square" style="font-size: 11px; margin-right: 4px;"></i>
                                    Visit
                                </a>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 13px;">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="badge <%=badgeClass%>"><%=rawStatus%></span>
                        </td>
                        <td style="text-align: right;">
                            <div style="display: inline-flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/CompanyDetailsServlet?id=<%=c.getCompanyId()%>"
                                   class="btn btn-outline btn-sm" title="View Full Profile & Drives">
                                    <i class="fa-solid fa-eye"></i>
                                    <span>Details</span>
                                </a>
                                <% if (!"Approved".equalsIgnoreCase(rawStatus)) { %>
                                    <a href="${pageContext.request.contextPath}/ApproveCompanyServlet?id=<%=c.getCompanyId()%>"
                                       class="btn btn-success btn-sm"
                                       title="Approve Company"
                                       onclick="return confirm('Approve <%=c.getCompanyName()%> for recruitment?');">
                                        <i class="fa-solid fa-check"></i>
                                        <span>Verify</span>
                                    </a>
                                <% } %>
                                <% if (!"Rejected".equalsIgnoreCase(rawStatus)) { %>
                                    <a href="${pageContext.request.contextPath}/RejectCompanyServlet?id=<%=c.getCompanyId()%>"
                                       class="btn btn-danger btn-sm"
                                       title="Reject Company"
                                       onclick="return confirm('Reject / suspend <%=c.getCompanyName()%>?');">
                                        <i class="fa-solid fa-xmark"></i>
                                        <span>Reject</span>
                                    </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 40px;">
                            <i class="fa-solid fa-building" style="font-size: 28px; margin-bottom: 10px; display: block;"></i>
                            No recruiting companies currently registered on the platform.
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
function filterCompanyTable() {
    const search = document.getElementById('compSearch').value.toLowerCase();
    const status = document.getElementById('compStatusFilter').value.toUpperCase();
    const rows = document.querySelectorAll('#companyTable tbody tr');
    let visible = 0;

    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const rowStatus = row.getAttribute('data-status') || '';
        const matchesSearch = text.includes(search);
        const matchesStatus = !status || rowStatus === status;

        if (matchesSearch && matchesStatus) {
            row.style.display = '';
            visible++;
        } else {
            row.style.display = 'none';
        }
    });

    const countElem = document.getElementById('visibleCompCount');
    if (countElem) countElem.innerText = visible;
}
</script>

</body>
</html>
