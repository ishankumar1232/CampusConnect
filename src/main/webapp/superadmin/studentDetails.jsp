<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.campusconnect.bean.Student" %>
<%@ page import="com.campusconnect.bean.SuperAdmin" %>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    Student s = (Student) request.getAttribute("student");
    if (s == null) {
        response.sendRedirect(request.getContextPath() + "/StudentManagementServlet");
        return;
    }

    ArrayList<Map<String, String>> academicList = (ArrayList<Map<String, String>>) request.getAttribute("academicList");
    ArrayList<String> skillList = (ArrayList<String>) request.getAttribute("skillList");
    ArrayList<Map<String, String>> projectList = (ArrayList<Map<String, String>>) request.getAttribute("projectList");
    Map<String, String> resume = (Map<String, String>) request.getAttribute("resume");
    ArrayList<Map<String, String>> applicationList = (ArrayList<Map<String, String>>) request.getAttribute("applicationList");
    ArrayList<Map<String, String>> offerList = (ArrayList<Map<String, String>>) request.getAttribute("offerList");

    String rawStatus = s.getStatus() != null ? s.getStatus().trim() : "ACTIVE";
    String badgeClass = "ACTIVE".equalsIgnoreCase(rawStatus) ? "badge-approved" : "badge-rejected";
    String initial = s.getName() != null && s.getName().length() > 0 ? s.getName().substring(0, 1).toUpperCase() : "S";

    int appCount = applicationList != null ? applicationList.size() : 0;
    int offerCount = offerList != null ? offerList.size() : 0;
    int skillCount = skillList != null ? skillList.size() : 0;
    int projCount = projectList != null ? projectList.size() : 0;

    request.setAttribute("activeNav", "students");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=s.getName()%> - Student Dossier | CampusConnect</title>

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
                <a href="${pageContext.request.contextPath}/StudentManagementServlet" style="color: #2563eb; font-weight: 600;">
                    <i class="fa-solid fa-arrow-left" style="margin-right: 4px;"></i>Back to Students
                </a>
                <span> / Student Dossier</span>
            </div>
            <h1><%=s.getName()%></h1>
            <p>Candidate ID #<%=s.getStudentId()%> &bull; College Affiliation ID #<%=s.getCollegeId()%></p>
        </div>
        <div class="page-actions">
            <% if (!"ACTIVE".equalsIgnoreCase(rawStatus)) { %>
                <a href="${pageContext.request.contextPath}/ActivateStudentServlet?id=<%=s.getStudentId()%>"
                   class="btn btn-success"
                   onclick="return confirm('Activate candidate <%=s.getName()%>?');">
                    <i class="fa-solid fa-check"></i>
                    <span>Activate Account</span>
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/DeactivateStudentServlet?id=<%=s.getStudentId()%>"
                   class="btn btn-danger"
                   onclick="return confirm('Deactivate candidate <%=s.getName()%>?');">
                    <i class="fa-solid fa-ban"></i>
                    <span>Deactivate Account</span>
                </a>
            <% } %>
        </div>
    </div>

    <!-- Summary KPI Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Candidate Status</span>
                    <div style="margin-top: 8px;">
                        <span class="badge <%=badgeClass%>" style="font-size: 14px; padding: 6px 14px;"><%=rawStatus%></span>
                    </div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-user-graduate"></i></div>
            </div>
            <div class="kpi-subtext">Eligibility for placement drives</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Drive Applications</span>
                    <div class="kpi-value"><%=appCount%></div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-file-signature"></i></div>
            </div>
            <div class="kpi-subtext">Placement applications submitted</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Placement Offers</span>
                    <div class="kpi-value" style="color: #16a34a;"><%=offerCount%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-award"></i></div>
            </div>
            <div class="kpi-subtext">Confirmed hiring selections</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Technical Skills</span>
                    <div class="kpi-value"><%=skillCount%></div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-code"></i></div>
            </div>
            <div class="kpi-subtext">Verified competencies</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Projects Built</span>
                    <div class="kpi-value"><%=projCount%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-diagram-project"></i></div>
            </div>
            <div class="kpi-subtext">Portfolio projects showcase</div>
        </div>
    </div>

    <!-- Tabbed Navigation -->
    <div class="tab-nav">
        <button type="button" class="tab-btn active" onclick="switchStuTab('profile', this)">
            <i class="fa-solid fa-id-card"></i>
            <span>Personal & College Profile</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchStuTab('academic', this)">
            <i class="fa-solid fa-graduation-cap"></i>
            <span>Academic Performance</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchStuTab('skills', this)">
            <i class="fa-solid fa-code"></i>
            <span>Skills & Projects (<%=skillCount + projCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchStuTab('applications', this)">
            <i class="fa-solid fa-file-signature"></i>
            <span>Applications (<%=appCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchStuTab('offers', this)">
            <i class="fa-solid fa-award"></i>
            <span>Offers & Selections (<%=offerCount%>)</span>
        </button>
    </div>

    <!-- TAB 1: PERSONAL & COLLEGE PROFILE -->
    <div class="tab-pane active" id="pane-stu-profile">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-user" style="color: #2563eb;"></i>
                    <span>Candidate Demographics & Institutional Enrollment</span>
                </div>
            </div>
            <div class="content-card-body">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px;">
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Full Name</span>
                        <div style="font-size: 15px; font-weight: 700; color: #0f172a; margin-top: 4px;"><%=s.getName()%></div>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Official Email Address</span>
                        <div style="font-size: 15px; font-weight: 600; margin-top: 4px;">
                            <a href="mailto:<%=s.getEmail()%>" style="color: #2563eb;"><%=s.getEmail()%></a>
                        </div>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Contact Phone</span>
                        <div style="font-size: 15px; font-weight: 600; margin-top: 4px;"><%=s.getPhone() != null ? s.getPhone() : "N/A"%></div>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Gender</span>
                        <div style="font-size: 15px; font-weight: 600; margin-top: 4px;"><%=s.getGender() != null ? s.getGender() : "N/A"%></div>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Date of Birth</span>
                        <div style="font-size: 15px; font-weight: 600; margin-top: 4px;"><%=s.getDob() != null ? s.getDob().toString() : "N/A"%></div>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">College ID</span>
                        <div style="font-size: 15px; font-weight: 600; margin-top: 4px;">
                            <a href="${pageContext.request.contextPath}/CollegeDetailsServlet?id=<%=s.getCollegeId()%>" style="color: #2563eb;">
                                College #<%=s.getCollegeId()%> &rarr;
                            </a>
                        </div>
                    </div>
                    <div style="grid-column: 1 / -1;">
                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Residential Address</span>
                        <div style="font-size: 14px; font-weight: 600; margin-top: 4px;"><%=s.getAddress() != null && !s.getAddress().isEmpty() ? s.getAddress() : "N/A"%></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- TAB 2: ACADEMIC PERFORMANCE -->
    <div class="tab-pane" id="pane-stu-academic">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-graduation-cap" style="color: #2563eb;"></i>
                    <span>Educational Milestones & CGPA Metrics</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Degree / Qualification</th>
                            <th>Completion Year</th>
                            <th>Percentage / Score</th>
                            <th>CGPA</th>
                            <th>Active Backlogs</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (academicList != null && !academicList.isEmpty()) {
                            for (Map<String, String> ac : academicList) {
                        %>
                        <tr>
                            <td><strong><%=ac.get("qualification")%></strong></td>
                            <td><%=ac.get("year")%></td>
                            <td><%=ac.get("percentage")%>%</td>
                            <td><strong style="color: #2563eb;"><%=ac.get("cgpa")%></strong></td>
                            <td>
                                <%
                                String bkl = ac.get("backlogs");
                                if ("0".equals(bkl)) {
                                %>
                                    <span class="badge badge-approved">0 (Clear)</span>
                                <% } else { %>
                                    <span class="badge badge-rejected"><%=bkl%> Backlogs</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No academic performance records entered for this candidate yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 3: SKILLS & PROJECTS -->
    <div class="tab-pane" id="pane-stu-skills">
        <div style="display: flex; flex-direction: column; gap: 24px;">
            <!-- Skills Card -->
            <div class="content-card">
                <div class="content-card-header">
                    <div class="content-card-title">
                        <i class="fa-solid fa-code" style="color: #2563eb;"></i>
                        <span>Technical Competencies & Skills</span>
                    </div>
                </div>
                <div class="content-card-body">
                    <% if (skillList != null && !skillList.isEmpty()) { %>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                            <% for (String sk : skillList) { %>
                                <span class="badge badge-primary" style="font-size: 13px; padding: 8px 14px;">
                                    <i class="fa-solid fa-check" style="font-size: 11px; margin-right: 4px;"></i>
                                    <%=sk%>
                                </span>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p style="color: var(--text-muted);">No technical skills listed by student.</p>
                    <% } %>
                </div>
            </div>

            <!-- Projects Card -->
            <div class="content-card">
                <div class="content-card-header">
                    <div class="content-card-title">
                        <i class="fa-solid fa-diagram-project" style="color: #2563eb;"></i>
                        <span>Portfolio Projects</span>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Project Name</th>
                                <th>Description</th>
                                <th>Technologies Used</th>
                                <th>Repository / Demo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if (projectList != null && !projectList.isEmpty()) {
                                for (Map<String, String> pr : projectList) {
                            %>
                            <tr>
                                <td><strong><%=pr.get("name")%></strong></td>
                                <td style="max-width: 320px; white-space: normal;"><%=pr.get("description")%></td>
                                <td><span class="badge badge-purple"><%=pr.get("technologies")%></span></td>
                                <td>
                                    <% if (pr.get("url") != null && !pr.get("url").isEmpty()) { %>
                                        <a href="<%=pr.get("url")%>" target="_blank" style="color: #2563eb; font-weight: 600;">
                                            <i class="fa-solid fa-arrow-up-right-from-square" style="font-size: 11px;"></i> Link
                                        </a>
                                    <% } else { %>
                                        <span style="color: var(--text-muted);">N/A</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                    No showcase projects listed by candidate.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- TAB 4: APPLICATIONS -->
    <div class="tab-pane" id="pane-stu-applications">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-file-signature" style="color: #2563eb;"></i>
                    <span>Campus Placement Drive Applications</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>App ID</th>
                            <th>Job Role</th>
                            <th>Company Name</th>
                            <th>Package</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (applicationList != null && !applicationList.isEmpty()) {
                            for (Map<String, String> ap : applicationList) {
                        %>
                        <tr>
                            <td><strong>#<%=ap.get("applicationId")%></strong></td>
                            <td><strong style="color: #1e293b;"><%=ap.get("jobTitle")%></strong></td>
                            <td><%=ap.get("companyName")%></td>
                            <td>₹<%=ap.get("salary")%> LPA</td>
                            <td><%=ap.get("appliedDate")%></td>
                            <td><span class="badge badge-primary"><%=ap.get("status")%></span></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No applications submitted for any placement drives yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 5: OFFERS & SELECTIONS -->
    <div class="tab-pane" id="pane-stu-offers">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-award" style="color: #10b981;"></i>
                    <span>Confirmed Placement Selections & Offers</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Selection ID</th>
                            <th>Job Title</th>
                            <th>Company Name</th>
                            <th>Package</th>
                            <th>Selection Date</th>
                            <th>Outcome</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (offerList != null && !offerList.isEmpty()) {
                            for (Map<String, String> of : offerList) {
                        %>
                        <tr>
                            <td><strong>#<%=of.get("selectionId")%></strong></td>
                            <td><strong style="color: #1e293b;"><%=of.get("jobTitle")%></strong></td>
                            <td><%=of.get("companyName")%></td>
                            <td>₹<%=of.get("salary")%> LPA</td>
                            <td><%=of.get("selectionDate") != null ? of.get("selectionDate") : "Confirmed"%></td>
                            <td><span class="badge badge-approved"><%=of.get("result")%></span></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No recruitment offers confirmed for this student yet.
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
function switchStuTab(tabId, btn) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    const target = document.getElementById('pane-stu-' + tabId);
    if (target) target.classList.add('active');
}
</script>

</body>
</html>
