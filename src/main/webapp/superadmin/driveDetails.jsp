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

    Map<String, String> drive = (Map<String, String>) request.getAttribute("drive");
    ArrayList<Map<String, String>> collegeList = (ArrayList<Map<String, String>>) request.getAttribute("collegeList");
    ArrayList<Map<String, String>> applicantList = (ArrayList<Map<String, String>>) request.getAttribute("applicantList");
    ArrayList<Map<String, String>> interviewList = (ArrayList<Map<String, String>>) request.getAttribute("interviewList");
    ArrayList<Map<String, String>> selectionList = (ArrayList<Map<String, String>>) request.getAttribute("selectionList");
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");

    if (drive == null) {
        response.sendRedirect(request.getContextPath() + "/MonitorRecruitmentServlet");
        return;
    }

    String rawType = drive.get("driveType") != null ? drive.get("driveType") : "Campus Drive";
    String typeBadge = rawType.toUpperCase().contains("CAMPUS") ? "badge-campus" : "badge-direct";
    String rawStatus = drive.get("status") != null ? drive.get("status") : "ACTIVE";
    String statusBadge = "ACTIVE".equalsIgnoreCase(rawStatus) ? "badge-approved" : "badge-rejected";

    int collegeCount = collegeList != null ? collegeList.size() : 0;
    int applicantCount = applicantList != null ? applicantList.size() : 0;
    int interviewCount = interviewList != null ? interviewList.size() : 0;
    int selectionCount = selectionList != null ? selectionList.size() : 0;

    request.setAttribute("activeNav", "drives");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=drive.get("jobTitle")%> - Drive Dossier | CampusConnect</title>

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
                <a href="${pageContext.request.contextPath}/MonitorRecruitmentServlet" style="color: #2563eb; font-weight: 600;">
                    <i class="fa-solid fa-arrow-left" style="margin-right: 4px;"></i>Back to Drives
                </a>
                <span> / Recruitment Drive Dossier</span>
            </div>
            <h1><%=drive.get("jobTitle")%></h1>
            <p>
                <i class="fa-regular fa-building" style="margin-right: 4px;"></i><%=drive.get("companyName")%>
                &bull; Drive ID #<%=drive.get("driveId")%>
                &bull; <span class="badge <%=typeBadge%>"><%=rawType%></span>
            </p>
        </div>
        <div class="page-actions">
            <span class="badge <%=statusBadge%>" style="font-size: 14px; padding: 8px 16px;">Status: <%=rawStatus%></span>
        </div>
    </div>

    <!-- Summary KPI Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Salary Package (CTC)</span>
                    <div class="kpi-value" style="color: #2563eb;">₹<%=drive.get("salary")%> LPA</div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-indian-rupee-sign"></i></div>
            </div>
            <div class="kpi-subtext">Offered compensation</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Open Vacancies</span>
                    <div class="kpi-value"><%=drive.get("vacancy")%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-user-plus"></i></div>
            </div>
            <div class="kpi-subtext">Open positions to be hired</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Participating Colleges</span>
                    <div class="kpi-value"><%=collegeCount%></div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-building-columns"></i></div>
            </div>
            <div class="kpi-subtext">Campuses invited / targeted</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Applications</span>
                    <div class="kpi-value"><%=applicantCount%></div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-file-signature"></i></div>
            </div>
            <div class="kpi-subtext">Candidate submissions</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Selections / Offers</span>
                    <div class="kpi-value" style="color: #16a34a;"><%=selectionCount%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-award"></i></div>
            </div>
            <div class="kpi-subtext">Hired candidates</div>
        </div>
    </div>

    <!-- Tabbed Navigation -->
    <div class="tab-nav">
        <button type="button" class="tab-btn active" onclick="switchDriveTab('details', this)">
            <i class="fa-solid fa-circle-info"></i>
            <span>Role Description & Criteria</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchDriveTab('colleges', this)">
            <i class="fa-solid fa-building-columns"></i>
            <span>Targeted Colleges (<%=collegeCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchDriveTab('applicants', this)">
            <i class="fa-solid fa-users"></i>
            <span>Applicants (<%=applicantCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchDriveTab('selections', this)">
            <i class="fa-solid fa-award"></i>
            <span>Hired Candidates (<%=selectionCount%>)</span>
        </button>
    </div>

    <!-- TAB 1: DETAILS -->
    <div class="tab-pane active" id="pane-drv-details">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-briefcase" style="color: #2563eb;"></i>
                    <span>Position Specifications & Eligibility Gates</span>
                </div>
            </div>
            <div class="content-card-body">
                <div style="display: flex; flex-direction: column; gap: 18px;">
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Job & Role Description</span>
                        <div style="font-size: 14px; line-height: 1.6; margin-top: 4px; color: #1e293b;">
                            <%=drive.get("description") != null && !drive.get("description").isEmpty() ? drive.get("description") : "No detailed job description provided."%>
                        </div>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 18px; padding-top: 14px; border-top: 1px solid var(--border-color);">
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Minimum Academic CGPA</span>
                            <div style="font-size: 15px; font-weight: 700; color: #0f172a; margin-top: 4px;">
                                &ge; <%=drive.get("cgpa")%> CGPA
                            </div>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Eligible Branches</span>
                            <div style="font-size: 15px; font-weight: 600; color: #0f172a; margin-top: 4px;">
                                <%=drive.get("branch") != null && !drive.get("branch").isEmpty() ? drive.get("branch") : "All Engineering / Technology Branches"%>
                            </div>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Required Technical Skills</span>
                            <div style="font-size: 15px; font-weight: 600; color: #0f172a; margin-top: 4px;">
                                <%=drive.get("skills") != null && !drive.get("skills").isEmpty() ? drive.get("skills") : "Not specified"%>
                            </div>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Application Deadline</span>
                            <div style="font-size: 15px; font-weight: 600; color: #dc2626; margin-top: 4px;">
                                <i class="fa-regular fa-clock" style="margin-right: 4px;"></i>
                                <%=drive.get("deadline") != null ? drive.get("deadline") : "Open"%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- TAB 2: COLLEGES -->
    <div class="tab-pane" id="pane-drv-colleges">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-building-columns" style="color: #2563eb;"></i>
                    <span>Colleges Targeted for this Campus Drive</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>College ID</th>
                            <th>Institution Name</th>
                            <th>City</th>
                            <th>State</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (collegeList != null && !collegeList.isEmpty()) {
                            for (Map<String, String> col : collegeList) {
                        %>
                        <tr>
                            <td><strong>#<%=col.get("collegeId")%></strong></td>
                            <td><strong><%=col.get("collegeName")%></strong></td>
                            <td><%=col.get("city")%></td>
                            <td><%=col.get("state")%></td>
                            <td><span class="badge badge-approved"><%=col.get("status")%></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/CollegeDetailsServlet?id=<%=col.get("collegeId")%>"
                                   class="btn btn-outline btn-sm">College Dossier</a>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                Open to all platform institutions or Direct Drive.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 3: APPLICANTS -->
    <div class="tab-pane" id="pane-drv-applicants">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-users" style="color: #2563eb;"></i>
                    <span>Candidate Applications Pool</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>App ID</th>
                            <th>Candidate Name</th>
                            <th>College</th>
                            <th>Contact Email</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (applicantList != null && !applicantList.isEmpty()) {
                            for (Map<String, String> ap : applicantList) {
                        %>
                        <tr>
                            <td><strong>#<%=ap.get("applicationId")%></strong></td>
                            <td><strong><%=ap.get("studentName")%></strong></td>
                            <td><%=ap.get("collegeName") != null ? ap.get("collegeName") : "N/A"%></td>
                            <td><%=ap.get("email")%></td>
                            <td><%=ap.get("appliedDate") != null ? ap.get("appliedDate") : "Recent"%></td>
                            <td><span class="badge badge-primary"><%=ap.get("status")%></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/StudentDetailsServlet?id=<%=ap.get("studentId")%>"
                                   class="btn btn-outline btn-sm">Student Profile</a>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No student applications received for this drive yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 4: SELECTIONS -->
    <div class="tab-pane" id="pane-drv-selections">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-award" style="color: #10b981;"></i>
                    <span>Selected / Hired Candidates</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Selection ID</th>
                            <th>Student Name</th>
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
                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No selection offers confirmed for this drive yet.
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
function switchDriveTab(tabId, btn) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    const target = document.getElementById('pane-drv-' + tabId);
    if (target) target.classList.add('active');
}
</script>

</body>
</html>
