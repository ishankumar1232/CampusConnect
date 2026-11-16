<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.campusconnect.bean.SuperAdmin"%>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    Map<String, String> company = (Map<String, String>) request.getAttribute("company");
    ArrayList<Map<String, String>> driveList = (ArrayList<Map<String, String>>) request.getAttribute("driveList");
    ArrayList<Map<String, String>> applicantList = (ArrayList<Map<String, String>>) request.getAttribute("applicantList");
    ArrayList<Map<String, String>> interviewList = (ArrayList<Map<String, String>>) request.getAttribute("interviewList");
    ArrayList<Map<String, String>> selectionList = (ArrayList<Map<String, String>>) request.getAttribute("selectionList");
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");

    if (company == null) {
        response.sendRedirect(request.getContextPath() + "/CompanyManagementServlet");
        return;
    }

    String rawStatus = company.get("status") != null ? company.get("status").trim() : "Pending";
    String badgeClass = "badge-pending";
    if ("Approved".equalsIgnoreCase(rawStatus)) badgeClass = "badge-approved";
    else if ("Rejected".equalsIgnoreCase(rawStatus)) badgeClass = "badge-rejected";

    int driveCount = counts != null ? counts.getOrDefault("driveCount", 0) : 0;
    int applicantCount = counts != null ? counts.getOrDefault("applicantCount", 0) : 0;
    int interviewCount = counts != null ? counts.getOrDefault("interviewCount", 0) : 0;
    int selectionCount = counts != null ? counts.getOrDefault("selectionCount", 0) : 0;

    request.setAttribute("activeNav", "companies");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=company.get("companyName")%> - Recruiter Profile | CampusConnect</title>

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
            <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 6px;">
                <a href="${pageContext.request.contextPath}/CompanyManagementServlet" style="color: #2563eb; font-weight: 600;">
                    <i class="fa-solid fa-arrow-left" style="margin-right: 4px;"></i>Back to Companies
                </a>
                <span> / Corporate Profile</span>
            </div>
            <h1><%=company.get("companyName")%></h1>
            <p>Recruiter Partner ID #<%=company.get("companyId")%> &bull; <%=company.get("email")%></p>
        </div>
        <div class="page-actions">
            <% if (!"Approved".equalsIgnoreCase(rawStatus)) { %>
                <a href="${pageContext.request.contextPath}/ApproveCompanyServlet?id=<%=company.get("companyId")%>"
                   class="btn btn-success"
                   onclick="return confirm('Verify <%=company.get("companyName")%> for hiring drives?');">
                    <i class="fa-solid fa-check"></i>
                    <span>Verify & Approve Recruiter</span>
                </a>
            <% } %>
            <% if (!"Rejected".equalsIgnoreCase(rawStatus)) { %>
                <a href="${pageContext.request.contextPath}/RejectCompanyServlet?id=<%=company.get("companyId")%>"
                   class="btn btn-danger"
                   onclick="return confirm('Suspend / Reject <%=company.get("companyName")%>?');">
                    <i class="fa-solid fa-xmark"></i>
                    <span>Suspend Account</span>
                </a>
            <% } %>
        </div>
    </div>

    <!-- Summary KPI Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Recruiter Status</span>
                    <div style="margin-top: 8px;">
                        <span class="badge <%=badgeClass%>" style="font-size: 14px; padding: 6px 14px;"><%=rawStatus%></span>
                    </div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-shield-halved"></i></div>
            </div>
            <div class="kpi-subtext">Hiring authorization state</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Drives Created</span>
                    <div class="kpi-value"><%=driveCount%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-bullhorn"></i></div>
            </div>
            <div class="kpi-subtext">Campus & Direct campaigns</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Applications</span>
                    <div class="kpi-value"><%=applicantCount%></div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-file-signature"></i></div>
            </div>
            <div class="kpi-subtext">Candidate submissions</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Interviews Scheduled</span>
                    <div class="kpi-value"><%=interviewCount%></div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-calendar-check"></i></div>
            </div>
            <div class="kpi-subtext">Candidate interview slots</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Selections / Offers</span>
                    <div class="kpi-value"><%=selectionCount%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-award"></i></div>
            </div>
            <div class="kpi-subtext">Hires confirmed on platform</div>
        </div>
    </div>

    <!-- Tabbed Navigation -->
    <div class="tab-nav">
        <button type="button" class="tab-btn active" onclick="switchCompanyTab('overview', this)">
            <i class="fa-solid fa-circle-info"></i>
            <span>Overview & Contact</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchCompanyTab('drives', this)">
            <i class="fa-solid fa-bullhorn"></i>
            <span>Recruitment Drives (<%=driveCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchCompanyTab('applicants', this)">
            <i class="fa-solid fa-users"></i>
            <span>Applicant Pool (<%=applicantCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchCompanyTab('selections', this)">
            <i class="fa-solid fa-award"></i>
            <span>Confirmed Hires (<%=selectionCount%>)</span>
        </button>
    </div>

    <!-- TAB 1: OVERVIEW -->
    <div class="tab-pane active" id="pane-comp-overview">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-building" style="color: #2563eb;"></i>
                    <span>Company Background & Office Coordinates</span>
                </div>
            </div>
            <div class="content-card-body">
                <div style="display: flex; flex-direction: column; gap: 18px;">
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Company Description</span>
                        <div style="font-size: 14px; line-height: 1.6; margin-top: 4px; color: var(--text-main);">
                            <%=company.get("description") != null && !company.get("description").isEmpty() ? company.get("description") : "No corporate profile description provided."%>
                        </div>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 18px; padding-top: 14px; border-top: 1px solid var(--border-color);">
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Official Contact Email</span>
                            <div style="font-size: 14px; font-weight: 600; margin-top: 4px;">
                                <a href="mailto:<%=company.get("email")%>" style="color: #2563eb;"><%=company.get("email")%></a>
                            </div>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Contact Phone</span>
                            <div style="font-size: 14px; font-weight: 600; margin-top: 4px;"><%=company.get("phone") != null && !company.get("phone").isEmpty() ? company.get("phone") : "N/A"%></div>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Corporate Website</span>
                            <div style="font-size: 14px; font-weight: 600; margin-top: 4px;">
                                <% if (company.get("website") != null && !company.get("website").isEmpty()) { %>
                                    <a href="<%=company.get("website").startsWith("http") ? company.get("website") : "https://" + company.get("website")%>" target="_blank" style="color: #2563eb;">
                                        <i class="fa-solid fa-arrow-up-right-from-square" style="font-size: 11px; margin-right: 4px;"></i>
                                        <%=company.get("website")%>
                                    </a>
                                <% } else { %>
                                    N/A
                                <% } %>
                            </div>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Corporate Headquarters / Address</span>
                            <div style="font-size: 14px; font-weight: 600; margin-top: 4px;"><%=company.get("address") != null && !company.get("address").isEmpty() ? company.get("address") : "N/A"%></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- TAB 2: DRIVES -->
    <div class="tab-pane" id="pane-comp-drives">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-bullhorn" style="color: #2563eb;"></i>
                    <span>Recruitment Drives Campaign History</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Drive ID</th>
                            <th>Job Title</th>
                            <th>Drive Type</th>
                            <th>Package / Salary</th>
                            <th>Vacancies</th>
                            <th>Eligibility (CGPA)</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (driveList != null && !driveList.isEmpty()) {
                            for (Map<String, String> drv : driveList) {
                        %>
                        <tr>
                            <td><strong>#<%=drv.get("driveId")%></strong></td>
                            <td><strong style="color: #1e293b;"><%=drv.get("jobTitle")%></strong></td>
                            <td><span class="badge badge-campus"><%=drv.get("driveType")%></span></td>
                            <td>₹<%=drv.get("salary")%> LPA</td>
                            <td><%=drv.get("vacancy")%></td>
                            <td><%=drv.get("cgpa")%> CGPA</td>
                            <td><span class="badge badge-approved"><%=drv.get("status")%></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/DriveDetailsServlet?id=<%=drv.get("driveId")%>"
                                   class="btn btn-outline btn-sm">Drive Dossier</a>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No recruitment drives created by this company yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 3: APPLICANTS -->
    <div class="tab-pane" id="pane-comp-applicants">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-users" style="color: #2563eb;"></i>
                    <span>Registered Student Applicants</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>App ID</th>
                            <th>Drive</th>
                            <th>Candidate Name</th>
                            <th>College</th>
                            <th>Email</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (applicantList != null && !applicantList.isEmpty()) {
                            for (Map<String, String> app : applicantList) {
                        %>
                        <tr>
                            <td><strong>#<%=app.get("applicationId")%></strong></td>
                            <td><%=app.get("jobTitle")%></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/StudentDetailsServlet?id=<%=app.get("studentId")%>"
                                   style="font-weight: 700; color: #2563eb;">
                                    <%=app.get("studentName")%>
                                </a>
                            </td>
                            <td><%=app.get("collegeName") != null ? app.get("collegeName") : "N/A"%></td>
                            <td><%=app.get("email")%></td>
                            <td><%=app.get("appliedDate") != null ? app.get("appliedDate") : "Recent"%></td>
                            <td><span class="badge badge-primary"><%=app.get("status")%></span></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No student applications received yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 4: SELECTIONS -->
    <div class="tab-pane" id="pane-comp-selections">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-award" style="color: #10b981;"></i>
                    <span>Confirmed Hires & Placements</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Selection ID</th>
                            <th>Candidate Name</th>
                            <th>Role / Job</th>
                            <th>College</th>
                            <th>Email</th>
                            <th>Selection Date</th>
                            <th>Result</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (selectionList != null && !selectionList.isEmpty()) {
                            for (Map<String, String> sel : selectionList) {
                        %>
                        <tr>
                            <td><strong>#<%=sel.get("selectionId")%></strong></td>
                            <td><strong><%=sel.get("studentName")%></strong></td>
                            <td><%=sel.get("jobTitle")%></td>
                            <td><%=sel.get("collegeName") != null ? sel.get("collegeName") : "N/A"%></td>
                            <td><%=sel.get("email")%></td>
                            <td><%=sel.get("selectionDate") != null ? sel.get("selectionDate") : "Confirmed"%></td>
                            <td><span class="badge badge-approved"><%=sel.get("result")%></span></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No finalized selections recorded yet for this company.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</main>

<footer class="footer">
    &copy; CampusConnect Platform. Super Administrator Control Center.
</footer>

<script>
function switchCompanyTab(tabId, btn) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    const target = document.getElementById('pane-comp-' + tabId);
    if (target) target.classList.add('active');
}
</script>

</body>
</html>
