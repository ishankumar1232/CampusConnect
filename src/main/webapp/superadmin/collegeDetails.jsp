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

    Map<String, String> college = (Map<String, String>) request.getAttribute("college");
    Map<String, String> adminUser = (Map<String, String>) request.getAttribute("adminUser");
    ArrayList<Map<String, String>> departmentList = (ArrayList<Map<String, String>>) request.getAttribute("departmentList");
    ArrayList<Map<String, String>> courseList = (ArrayList<Map<String, String>>) request.getAttribute("courseList");
    ArrayList<Map<String, String>> facultyList = (ArrayList<Map<String, String>>) request.getAttribute("facultyList");
    ArrayList<Map<String, String>> studentList = (ArrayList<Map<String, String>>) request.getAttribute("studentList");
    ArrayList<Map<String, String>> driveList = (ArrayList<Map<String, String>>) request.getAttribute("driveList");
    Map<String, Integer> counts = (Map<String, Integer>) request.getAttribute("counts");

    if (college == null) {
        response.sendRedirect(request.getContextPath() + "/CollegeManagementServlet");
        return;
    }

    String rawStatus = college.get("status") != null ? college.get("status").trim() : "Pending";
    String badgeClass = "badge-pending";
    if ("Approved".equalsIgnoreCase(rawStatus)) badgeClass = "badge-approved";
    else if ("Rejected".equalsIgnoreCase(rawStatus)) badgeClass = "badge-rejected";

    int deptCount = counts != null ? counts.getOrDefault("deptCount", 0) : 0;
    int courseCount = counts != null ? counts.getOrDefault("courseCount", 0) : 0;
    int facultyCount = counts != null ? counts.getOrDefault("facultyCount", 0) : 0;
    int studentCount = counts != null ? counts.getOrDefault("studentCount", 0) : 0;
    int driveCount = counts != null ? counts.getOrDefault("driveCount", 0) : 0;

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    request.setAttribute("activeNav", "colleges");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=college.get("collegeName")%> - Overview | CampusConnect</title>

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

    <!-- Page Header & Breadcrumbs -->
    <div class="page-toolbar">
        <div class="page-title-block">
            <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 6px;">
                <a href="${pageContext.request.contextPath}/CollegeManagementServlet" style="color: #2563eb; font-weight: 600;">
                    <i class="fa-solid fa-arrow-left" style="margin-right: 4px;"></i>Back to Colleges
                </a>
                <span> / Institutional Dossier</span>
            </div>
            <h1><%=college.get("collegeName")%></h1>
            <p>Institutional ID #<%=college.get("collegeId")%> &bull; <%=college.get("city")%>, <%=college.get("state")%></p>
        </div>
        <div class="page-actions">
            <button type="button" class="btn btn-outline" onclick="openEditModal()">
                <i class="fa-solid fa-pen-to-square"></i>
                <span>Edit Institution</span>
            </button>
            <% if (!"Approved".equalsIgnoreCase(rawStatus)) { %>
                <a href="${pageContext.request.contextPath}/ApproveCollegeServlet?id=<%=college.get("collegeId")%>"
                   class="btn btn-success"
                   onclick="return confirm('Approve <%=college.get("collegeName")%>?');">
                    <i class="fa-solid fa-check"></i>
                    <span>Approve Institution</span>
                </a>
            <% } %>
            <% if (!"Rejected".equalsIgnoreCase(rawStatus)) { %>
                <a href="${pageContext.request.contextPath}/RejectCollegeServlet?id=<%=college.get("collegeId")%>"
                   class="btn btn-danger"
                   onclick="return confirm('Reject <%=college.get("collegeName")%>?');">
                    <i class="fa-solid fa-xmark"></i>
                    <span>Reject</span>
                </a>
            <% } %>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <% if ("updated".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>College institution profile updated successfully.</span>
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>Operation failed. Please verify submitted details.</span>
        </div>
    <% } %>

    <!-- Summary KPI Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Current Status</span>
                    <div style="margin-top: 8px;">
                        <span class="badge <%=badgeClass%>" style="font-size: 14px; padding: 6px 14px;"><%=rawStatus%></span>
                    </div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-shield-halved"></i></div>
            </div>
            <div class="kpi-subtext">Platform clearance status</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Departments</span>
                    <div class="kpi-value"><%=deptCount%></div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-sitemap"></i></div>
            </div>
            <div class="kpi-subtext">Active academic departments</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Courses</span>
                    <div class="kpi-value"><%=courseCount%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-book-open"></i></div>
            </div>
            <div class="kpi-subtext">Degree programs offered</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Faculty Members</span>
                    <div class="kpi-value"><%=facultyCount%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-chalkboard-user"></i></div>
            </div>
            <div class="kpi-subtext">Teaching faculty staff</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Enrolled Students</span>
                    <div class="kpi-value"><%=studentCount%></div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-user-graduate"></i></div>
            </div>
            <div class="kpi-subtext">Registered candidates</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Placement Drives</span>
                    <div class="kpi-value"><%=driveCount%></div>
                </div>
                <div class="kpi-icon red"><i class="fa-solid fa-bullhorn"></i></div>
            </div>
            <div class="kpi-subtext">Campus recruitment drives</div>
        </div>
    </div>

    <!-- Tabbed Navigation Structure -->
    <div class="tab-nav">
        <button type="button" class="tab-btn active" onclick="switchTab('overview', this)">
            <i class="fa-solid fa-circle-info"></i>
            <span>Overview & Administrator</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchTab('academic', this)">
            <i class="fa-solid fa-sitemap"></i>
            <span>Departments & Courses (<%=courseCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchTab('faculty', this)">
            <i class="fa-solid fa-chalkboard-user"></i>
            <span>Faculty (<%=facultyCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchTab('students', this)">
            <i class="fa-solid fa-user-graduate"></i>
            <span>Students (<%=studentCount%>)</span>
        </button>
        <button type="button" class="tab-btn" onclick="switchTab('drives', this)">
            <i class="fa-solid fa-bullhorn"></i>
            <span>Placement Drives (<%=driveCount%>)</span>
        </button>
    </div>

    <!-- TAB 1: OVERVIEW & ADMINISTRATOR -->
    <div class="tab-pane active" id="pane-overview">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(360px, 1fr)); gap: 24px; margin-bottom: 24px;">
            <!-- College Profile Card -->
            <div class="content-card">
                <div class="content-card-header">
                    <div class="content-card-title">
                        <i class="fa-solid fa-building-columns" style="color: #2563eb;"></i>
                        <span>Institutional Contact & Profile</span>
                    </div>
                </div>
                <div class="content-card-body">
                    <div style="display: flex; flex-direction: column; gap: 14px;">
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Campus Address</span>
                            <div style="font-size: 14px; font-weight: 600; margin-top: 2px;">
                                <%=college.get("address") != null && !college.get("address").isEmpty() ? college.get("address") : "Not specified"%>
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                            <div>
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">City</span>
                                <div style="font-size: 14px; font-weight: 600; margin-top: 2px;"><%=college.get("city")%></div>
                            </div>
                            <div>
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">State</span>
                                <div style="font-size: 14px; font-weight: 600; margin-top: 2px;"><%=college.get("state")%></div>
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                            <div>
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Email Address</span>
                                <div style="font-size: 14px; font-weight: 600; margin-top: 2px;">
                                    <a href="mailto:<%=college.get("email")%>" style="color: #2563eb;"><%=college.get("email") != null ? college.get("email") : "N/A"%></a>
                                </div>
                            </div>
                            <div>
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Contact Phone</span>
                                <div style="font-size: 14px; font-weight: 600; margin-top: 2px;"><%=college.get("phone") != null && !college.get("phone").isEmpty() ? college.get("phone") : "N/A"%></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- College Administrator Card -->
            <div class="content-card">
                <div class="content-card-header">
                    <div class="content-card-title">
                        <i class="fa-solid fa-user-shield" style="color: #10b981;"></i>
                        <span>Primary College Administrator</span>
                    </div>
                </div>
                <div class="content-card-body">
                    <% if (adminUser != null && !adminUser.isEmpty() && adminUser.get("adminId") != null) { %>
                        <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 20px;">
                            <div class="profile-avatar" style="width: 50px; height: 50px; font-size: 18px;">
                                <%=adminUser.get("name") != null && adminUser.get("name").length() > 0 ? adminUser.get("name").substring(0, 1).toUpperCase() : "A"%>
                            </div>
                            <div>
                                <h3 style="font-size: 16px; font-weight: 750;"><%=adminUser.get("name")%></h3>
                                <p style="font-size: 13px; color: var(--text-muted);">Admin ID #<%=adminUser.get("adminId")%></p>
                            </div>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div>
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Login Email (Username)</span>
                                <div style="font-size: 14px; font-weight: 600; margin-top: 2px;">
                                    <a href="mailto:<%=adminUser.get("email")%>" style="color: #2563eb;"><%=adminUser.get("email")%></a>
                                </div>
                            </div>
                            <div>
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Access Privileges</span>
                                <div style="margin-top: 4px;">
                                    <span class="badge badge-approved">College Administrator Role</span>
                                </div>
                            </div>
                        </div>
                    <% } else { %>
                        <div style="text-align: center; padding: 25px 10px; color: var(--text-muted);">
                            <i class="fa-solid fa-user-xmark" style="font-size: 32px; color: #94a3b8; margin-bottom: 10px; display: block;"></i>
                            <h4 style="font-size: 15px; font-weight: 700; color: #334155; margin-bottom: 4px;">No Assigned Administrator</h4>
                            <p style="font-size: 13px;">This institution does not have a designated College Admin user account yet.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- TAB 2: DEPARTMENTS & COURSES -->
    <div class="tab-pane" id="pane-academic">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-graduation-cap" style="color: #2563eb;"></i>
                    <span>Academic Departments & Degree Courses</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Course ID</th>
                            <th>Course / Degree Name</th>
                            <th>Department</th>
                            <th>Duration</th>
                            <th>Seat Capacity</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (courseList != null && !courseList.isEmpty()) {
                            for (Map<String, String> crs : courseList) {
                        %>
                        <tr>
                            <td><strong>#<%=crs.get("courseId")%></strong></td>
                            <td><strong style="color: #1e293b;"><%=crs.get("courseName")%></strong></td>
                            <td><%=crs.get("deptName") != null ? crs.get("deptName") : "General"%></td>
                            <td><%=crs.get("duration") != null ? crs.get("duration") : "4 Years"%></td>
                            <td><%=crs.get("seats") != null ? crs.get("seats") : "60"%></td>
                            <td><span class="badge badge-approved">Active Program</span></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No academic courses mapped to this college yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 3: FACULTY MEMBERS -->
    <div class="tab-pane" id="pane-faculty">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-chalkboard-user" style="color: #2563eb;"></i>
                    <span>Teaching Faculty Directory</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Faculty ID</th>
                            <th>Instructor Name</th>
                            <th>Department</th>
                            <th>Contact Email</th>
                            <th>Phone</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (facultyList != null && !facultyList.isEmpty()) {
                            for (Map<String, String> fac : facultyList) {
                        %>
                        <tr>
                            <td><strong>#<%=fac.get("facultyId")%></strong></td>
                            <td><strong><%=fac.get("facultyName")%></strong></td>
                            <td><%=fac.get("departmentName") != null ? fac.get("departmentName") : "N/A"%></td>
                            <td><%=fac.get("email") != null ? fac.get("email") : "N/A"%></td>
                            <td><%=fac.get("phone") != null ? fac.get("phone") : "N/A"%></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No faculty members listed for this college.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 4: ENROLLED STUDENTS -->
    <div class="tab-pane" id="pane-students">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-user-graduate" style="color: #2563eb;"></i>
                    <span>Enrolled Candidate Roster</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Student ID</th>
                            <th>Candidate Name</th>
                            <th>Course Program</th>
                            <th>Contact Email</th>
                            <th>Phone</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (studentList != null && !studentList.isEmpty()) {
                            for (Map<String, String> stu : studentList) {
                        %>
                        <tr>
                            <td><strong>#<%=stu.get("studentId")%></strong></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/StudentDetailsServlet?id=<%=stu.get("studentId")%>"
                                   style="font-weight: 700; color: #2563eb;">
                                    <%=stu.get("name")%>
                                </a>
                            </td>
                            <td><%=stu.get("courseName") != null ? stu.get("courseName") : "N/A"%></td>
                            <td><%=stu.get("email")%></td>
                            <td><%=stu.get("phone") != null ? stu.get("phone") : "N/A"%></td>
                            <td><span class="badge badge-approved"><%=stu.get("status") != null ? stu.get("status") : "ACTIVE"%></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/StudentDetailsServlet?id=<%=stu.get("studentId")%>"
                                   class="btn btn-outline btn-sm">View Profile</a>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No students currently admitted in this institution.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 5: PLACEMENT DRIVES -->
    <div class="tab-pane" id="pane-drives">
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <i class="fa-solid fa-bullhorn" style="color: #2563eb;"></i>
                    <span>Participating Campus Recruitment Drives</span>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Drive ID</th>
                            <th>Company</th>
                            <th>Role / Title</th>
                            <th>Drive Type</th>
                            <th>Package / CTC</th>
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
                            <td><strong><%=drv.get("companyName")%></strong></td>
                            <td><%=drv.get("jobTitle")%></td>
                            <td><span class="badge badge-campus"><%=drv.get("driveType")%></span></td>
                            <td>₹<%=drv.get("salary")%> LPA</td>
                            <td><span class="badge badge-approved"><%=drv.get("status")%></span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/DriveDetailsServlet?id=<%=drv.get("driveId")%>"
                                   class="btn btn-outline btn-sm">Drive Details</a>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No recruitment drives associated with this college yet.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</main>

<!-- Edit College Modal Dialog -->
<div class="modal-backdrop" id="editCollegeModal">
    <div class="modal-card">
        <div class="modal-header">
            <h3><i class="fa-solid fa-pen-to-square" style="color: #2563eb; margin-right: 8px;"></i>Edit College Profile</h3>
            <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/EditCollegeServlet" method="post">
            <input type="hidden" name="collegeId" value="<%=college.get("collegeId")%>">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" for="editColName">Institution Name <span class="req">*</span></label>
                    <input type="text" id="editColName" name="collegeName" class="form-control" value="<%=college.get("collegeName")%>" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="editColCity">City <span class="req">*</span></label>
                        <input type="text" id="editColCity" name="city" class="form-control" value="<%=college.get("city")%>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="editColState">State <span class="req">*</span></label>
                        <input type="text" id="editColState" name="state" class="form-control" value="<%=college.get("state")%>" required>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="editColAddress">Campus Address</label>
                    <input type="text" id="editColAddress" name="address" class="form-control" value="<%=college.get("address") != null ? college.get("address") : ""%>">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="editColEmail">Official Email</label>
                        <input type="email" id="editColEmail" name="email" class="form-control" value="<%=college.get("email") != null ? college.get("email") : ""%>">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="editColPhone">Contact Phone</label>
                        <input type="text" id="editColPhone" name="phone" class="form-control" value="<%=college.get("phone") != null ? college.get("phone") : ""%>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="editColStatus">Status</label>
                    <select id="editColStatus" name="status" class="form-select-full">
                        <option value="Approved" <%="Approved".equalsIgnoreCase(rawStatus) ? "selected" : ""%>>Approved</option>
                        <option value="Pending" <%="Pending".equalsIgnoreCase(rawStatus) ? "selected" : ""%>>Pending</option>
                        <option value="Rejected" <%="Rejected".equalsIgnoreCase(rawStatus) ? "selected" : ""%>>Rejected</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeEditModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-save"></i>
                    <span>Save Changes</span>
                </button>
            </div>
        </form>
    </div>
</div>

<footer class="footer">
    &copy; CampusConnect Platform. Super Administrator Control Center.
</footer>

<script>
function switchTab(tabId, btn) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    const target = document.getElementById('pane-' + tabId);
    if (target) target.classList.add('active');
}

function openEditModal() {
    document.getElementById('editCollegeModal').classList.add('active');
}
function closeEditModal() {
    document.getElementById('editCollegeModal').classList.remove('active');
}
</script>

</body>
</html>
