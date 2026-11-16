<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.Student"%>
<%@ page import="com.campusconnect.bean.SuperAdmin"%>
<%@ page import="com.campusconnect.dao.StudentDAO"%>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    ArrayList<Student> list = (ArrayList<Student>) request.getAttribute("studentList");
    if (list == null) {
        StudentDAO dao = new StudentDAO();
        list = dao.getAllStudents();
    }

    int totalStudents = 0;
    int activeStudents = 0;
    int inactiveStudents = 0;

    if (list != null) {
        totalStudents = list.size();
        for (Student s : list) {
            if ("ACTIVE".equalsIgnoreCase(s.getStatus())) {
                activeStudents++;
            } else {
                inactiveStudents++;
            }
        }
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    request.setAttribute("activeNav", "students");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Directory | CampusConnect</title>

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
            <h1>Platform Students Directory</h1>
            <p>Comprehensive roster of candidates enrolled across all affiliated college institutions.</p>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <% if ("activated".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>Student account activated successfully.</span>
        </div>
    <% } else if ("deactivated".equalsIgnoreCase(success)) { %>
        <div class="alert alert-warning">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span>Student account deactivated successfully.</span>
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>Operation could not be completed. Please check server logs.</span>
        </div>
    <% } %>

    <!-- KPI Metric Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Total Candidates</span>
                    <div class="kpi-value"><%=totalStudents%></div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-user-graduate"></i></div>
            </div>
            <div class="kpi-subtext">Students registered across colleges</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Active Accounts</span>
                    <div class="kpi-value" style="color: #16a34a;"><%=activeStudents%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-user-check"></i></div>
            </div>
            <div class="kpi-subtext">Eligible for drives & applications</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Inactive Accounts</span>
                    <div class="kpi-value" style="color: #dc2626;"><%=inactiveStudents%></div>
                </div>
                <div class="kpi-icon red"><i class="fa-solid fa-user-slash"></i></div>
            </div>
            <div class="kpi-subtext">Suspended or unverified profiles</div>
        </div>
    </div>

    <!-- Content Card with Live Search & Filter -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">
                <i class="fa-solid fa-users" style="color: #2563eb;"></i>
                <span>Enrolled Candidates Directory (<span id="visibleStuCount"><%=totalStudents%></span>)</span>
            </div>
            <div class="filter-bar">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="stuSearch" placeholder="Search by name, email, phone, college..." onkeyup="filterStudentTable()">
                </div>
                <select id="stuStatusFilter" class="filter-select" onchange="filterStudentTable()">
                    <option value="">All Statuses</option>
                    <option value="ACTIVE">Active Only</option>
                    <option value="INACTIVE">Inactive Only</option>
                </select>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table" id="studentTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student Name</th>
                        <th>College ID</th>
                        <th>Email Address</th>
                        <th>Phone</th>
                        <th>Gender</th>
                        <th>Status</th>
                        <th style="text-align: right;">Administrative Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (list != null && !list.isEmpty()) {
                        for (Student s : list) {
                            String rawStatus = s.getStatus() != null ? s.getStatus().trim() : "ACTIVE";
                            String badgeClass = "ACTIVE".equalsIgnoreCase(rawStatus) ? "badge-approved" : "badge-rejected";
                            String initial = s.getName() != null && s.getName().length() > 0 ? s.getName().substring(0, 1).toUpperCase() : "S";
                    %>
                    <tr data-status="<%=rawStatus.toUpperCase()%>">
                        <td><strong>#<%=s.getStudentId()%></strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/StudentDetailsServlet?id=<%=s.getStudentId()%>"
                               style="display: flex; align-items: center; gap: 10px; color: #2563eb; font-weight: 700;">
                                <div class="profile-avatar" style="width: 32px; height: 32px; font-size: 13px; flex-shrink: 0;">
                                    <%=initial%>
                                </div>
                                <span><%=s.getName()%></span>
                            </a>
                        </td>
                        <td>
                            <span class="badge badge-neutral">College #<%=s.getCollegeId()%></span>
                        </td>
                        <td>
                            <a href="mailto:<%=s.getEmail()%>" style="color: #64748b; font-size: 13px;">
                                <i class="fa-regular fa-envelope" style="margin-right: 4px;"></i>
                                <%=s.getEmail()%>
                            </a>
                        </td>
                        <td><%=s.getPhone() != null && !s.getPhone().isEmpty() ? s.getPhone() : "N/A"%></td>
                        <td><%=s.getGender() != null ? s.getGender() : "N/A"%></td>
                        <td>
                            <span class="badge <%=badgeClass%>"><%=rawStatus%></span>
                        </td>
                        <td style="text-align: right;">
                            <div style="display: inline-flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/StudentDetailsServlet?id=<%=s.getStudentId()%>"
                                   class="btn btn-outline btn-sm" title="View Full Academic Dossier">
                                    <i class="fa-solid fa-eye"></i>
                                    <span>Profile</span>
                                </a>
                                <% if (!"ACTIVE".equalsIgnoreCase(rawStatus)) { %>
                                    <a href="${pageContext.request.contextPath}/ActivateStudentServlet?id=<%=s.getStudentId()%>"
                                       class="btn btn-success btn-sm"
                                       title="Activate Student"
                                       onclick="return confirm('Activate <%=s.getName()%>?');">
                                        <i class="fa-solid fa-check"></i>
                                        <span>Activate</span>
                                    </a>
                                <% } else { %>
                                    <a href="${pageContext.request.contextPath}/DeactivateStudentServlet?id=<%=s.getStudentId()%>"
                                       class="btn btn-danger btn-sm"
                                       title="Deactivate Student"
                                       onclick="return confirm('Deactivate <%=s.getName()%>?');">
                                        <i class="fa-solid fa-ban"></i>
                                        <span>Deactivate</span>
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
                        <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 40px;">
                            <i class="fa-solid fa-user-graduate" style="font-size: 28px; margin-bottom: 10px; display: block;"></i>
                            No students currently registered across any institutions.
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
function filterStudentTable() {
    const search = document.getElementById('stuSearch').value.toLowerCase();
    const status = document.getElementById('stuStatusFilter').value.toUpperCase();
    const rows = document.querySelectorAll('#studentTable tbody tr');
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

    const countElem = document.getElementById('visibleStuCount');
    if (countElem) countElem.innerText = visible;
}
</script>

</body>
</html>
