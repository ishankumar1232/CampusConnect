<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.campusconnect.bean.User"%>
<%@ page import="com.campusconnect.bean.SuperAdmin"%>
<%@ page import="com.campusconnect.dao.UserDAO"%>
<%@ page import="com.campusconnect.dao.CollegeDAO"%>
<%@ page import="com.campusconnect.bean.College"%>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    ArrayList<User> list = (ArrayList<User>) request.getAttribute("userList");
    if (list == null) {
        UserDAO dao = new UserDAO();
        list = dao.getAllUsers();
    }

    int totalUsers = 0;
    int superAdminCount = 0;
    int collegeAdminCount = 0;
    int companyCount = 0;
    int studentCount = 0;

    if (list != null) {
        totalUsers = list.size();
        for (User u : list) {
            String role = u.getRole() != null ? u.getRole().toUpperCase() : "";
            if (role.contains("SUPER")) superAdminCount++;
            else if (role.contains("COLLEGE")) collegeAdminCount++;
            else if (role.contains("COMPANY")) companyCount++;
            else if (role.contains("STUDENT")) studentCount++;
        }
    }

    // Load colleges for the Assign Admin modal
    CollegeDAO cdao = new CollegeDAO();
    ArrayList<College> allColleges = cdao.getAllColleges();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    request.setAttribute("activeNav", "users");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Platform User Accounts | CampusConnect</title>

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
            <h1>Platform Identity & User Management</h1>
            <p>Administer security access, roles, and administrative credentials across all platform portals.</p>
        </div>
        <div class="page-actions">
            <button type="button" class="btn btn-primary" onclick="openAdminModal()">
                <i class="fa-solid fa-user-plus"></i>
                <span>Assign College Admin</span>
            </button>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <% if ("activated".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>User account privileges restored and activated successfully.</span>
        </div>
    <% } else if ("deactivated".equalsIgnoreCase(success)) { %>
        <div class="alert alert-warning">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span>User account has been deactivated / suspended.</span>
        </div>
    <% } else if ("admin_created".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>College Administrator successfully assigned and activated.</span>
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
                    <span class="kpi-title">Total Accounts</span>
                    <div class="kpi-value"><%=totalUsers%></div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-users-gear"></i></div>
            </div>
            <div class="kpi-subtext">Registered across all roles</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">College Admins</span>
                    <div class="kpi-value" style="color: #2563eb;"><%=collegeAdminCount%></div>
                </div>
                <div class="kpi-icon purple"><i class="fa-solid fa-user-tie"></i></div>
            </div>
            <div class="kpi-subtext">Institutional administrators</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Recruiter Accounts</span>
                    <div class="kpi-value" style="color: #7c3aed;"><%=companyCount%></div>
                </div>
                <div class="kpi-icon teal"><i class="fa-solid fa-building"></i></div>
            </div>
            <div class="kpi-subtext">Corporate talent coordinators</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Student Accounts</span>
                    <div class="kpi-value" style="color: #10b981;"><%=studentCount%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-user-graduate"></i></div>
            </div>
            <div class="kpi-subtext">Student portal candidate logins</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Super Admins</span>
                    <div class="kpi-value" style="color: #dc2626;"><%=superAdminCount%></div>
                </div>
                <div class="kpi-icon red"><i class="fa-solid fa-shield-halved"></i></div>
            </div>
            <div class="kpi-subtext">Full system governance</div>
        </div>
    </div>

    <!-- Content Card with Live Search & Filter -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">
                <i class="fa-solid fa-users" style="color: #2563eb;"></i>
                <span>Platform User Accounts (<span id="visibleUserCount"><%=totalUsers%></span>)</span>
            </div>
            <div class="filter-bar">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="userSearch" placeholder="Search by name, email, role..." onkeyup="filterUserTable()">
                </div>
                <select id="roleFilter" class="filter-select" onchange="filterUserTable()">
                    <option value="">All Roles</option>
                    <option value="SUPER_ADMIN">Super Admin Only</option>
                    <option value="COLLEGE_ADMIN">College Admin Only</option>
                    <option value="COMPANY">Recruiters Only</option>
                    <option value="STUDENT">Students Only</option>
                </select>
                <select id="userStatusFilter" class="filter-select" onchange="filterUserTable()">
                    <option value="">All Statuses</option>
                    <option value="ACTIVE">Active / Approved</option>
                    <option value="INACTIVE">Inactive / Rejected</option>
                </select>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table" id="userTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User Name</th>
                        <th>Login Email</th>
                        <th>Portal Role</th>
                        <th>Affiliation / Entity ID</th>
                        <th>Status</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (list != null && !list.isEmpty()) {
                        for (User u : list) {
                            String role = u.getRole() != null ? u.getRole().toUpperCase() : "STUDENT";
                            String roleBadge = "badge-neutral";
                            if (role.contains("SUPER")) roleBadge = "badge-rejected";
                            else if (role.contains("COLLEGE")) roleBadge = "badge-primary";
                            else if (role.contains("COMPANY")) roleBadge = "badge-purple";
                            else if (role.contains("STUDENT")) roleBadge = "badge-approved";

                            String rawStatus = u.getStatus() != null ? u.getStatus().trim() : "ACTIVE";
                            boolean isActive = "ACTIVE".equalsIgnoreCase(rawStatus) || "Approved".equalsIgnoreCase(rawStatus);
                            String statusBadge = isActive ? "badge-approved" : "badge-rejected";
                    %>
                    <tr data-role="<%=role%>" data-status="<%=isActive ? "ACTIVE" : "INACTIVE"%>">
                        <td><strong>#<%=u.getUserId()%></strong></td>
                        <td>
                            <strong style="color: #1e293b;"><%=u.getName()%></strong>
                        </td>
                        <td>
                            <a href="mailto:<%=u.getEmail()%>" style="color: #64748b; font-size: 13px;">
                                <i class="fa-regular fa-envelope" style="margin-right: 4px;"></i>
                                <%=u.getEmail()%>
                            </a>
                        </td>
                        <td><span class="badge <%=roleBadge%>"><%=role%></span></td>
                        <td>
                            <% if (u.getEntityId() > 0) { %>
                                <span class="badge badge-neutral">Entity #<%=u.getEntityId()%></span>
                            <% } else { %>
                                <span style="color: var(--text-muted);">Root</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="badge <%=statusBadge%>"><%=rawStatus%></span>
                        </td>
                        <td style="text-align: right;">
                            <% if (!"SUPER_ADMIN".equalsIgnoreCase(role)) { %>
                                <div style="display: inline-flex; gap: 6px;">
                                    <% if (!isActive) { %>
                                        <a href="${pageContext.request.contextPath}/ActivateUserServlet?id=<%=u.getUserId()%>&role=<%=role%>"
                                           class="btn btn-success btn-sm"
                                           title="Activate User"
                                           onclick="return confirm('Activate <%=u.getName()%>?');">
                                            <i class="fa-solid fa-check"></i>
                                            <span>Activate</span>
                                        </a>
                                    <% } else { %>
                                        <a href="${pageContext.request.contextPath}/DeactivateUserServlet?id=<%=u.getUserId()%>&role=<%=role%>"
                                           class="btn btn-danger btn-sm"
                                           title="Deactivate User"
                                           onclick="return confirm('Deactivate <%=u.getName()%>?');">
                                            <i class="fa-solid fa-ban"></i>
                                            <span>Deactivate</span>
                                        </a>
                                    <% } %>
                                </div>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 12px; font-weight: 600;">System Protected</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 40px;">
                            <i class="fa-solid fa-users-gear" style="font-size: 28px; margin-bottom: 10px; display: block;"></i>
                            No users found in platform directory.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</main>

<!-- Assign College Admin Modal Dialog -->
<div class="modal-backdrop" id="addAdminModal">
    <div class="modal-card">
        <div class="modal-header">
            <h3><i class="fa-solid fa-user-shield" style="color: #2563eb; margin-right: 8px;"></i>Assign College Administrator</h3>
            <button type="button" class="modal-close" onclick="closeAdminModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/AddCollegeAdminServlet" method="post">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" for="targetCollege">Target College Institution <span class="req">*</span></label>
                    <select id="targetCollege" name="collegeId" class="form-select-full" required>
                        <option value="">-- Choose College Institution --</option>
                        <%
                        if (allColleges != null) {
                            for (College col : allColleges) {
                        %>
                            <option value="<%=col.getCollegeId()%>">
                                <%=col.getCollegeName()%> (<%=col.getCity()%>) - #<%=col.getCollegeId()%>
                            </option>
                        <%
                            }
                        }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="admName">Administrator Full Name <span class="req">*</span></label>
                    <input type="text" id="admName" name="name" class="form-control" placeholder="e.g. Dr. Rajesh Sharma" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="admEmail">Login Email Address <span class="req">*</span></label>
                    <input type="email" id="admEmail" name="email" class="form-control" placeholder="admin@college.edu" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="admPass">Initial Password <span class="req">*</span></label>
                    <input type="password" id="admPass" name="password" class="form-control" placeholder="Create temporary password" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeAdminModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-check"></i>
                    <span>Create Administrator</span>
                </button>
            </div>
        </form>
    </div>
</div>

<footer class="footer">
    &copy; CampusConnect Platform. Super Administrator Control Center.
</footer>

<script>
function openAdminModal() {
    document.getElementById('addAdminModal').classList.add('active');
}
function closeAdminModal() {
    document.getElementById('addAdminModal').classList.remove('active');
}

function filterUserTable() {
    const search = document.getElementById('userSearch').value.toLowerCase();
    const role = document.getElementById('roleFilter').value.toUpperCase();
    const status = document.getElementById('userStatusFilter').value.toUpperCase();
    const rows = document.querySelectorAll('#userTable tbody tr');
    let visible = 0;

    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const rowRole = row.getAttribute('data-role') || '';
        const rowStatus = row.getAttribute('data-status') || '';

        const matchesSearch = text.includes(search);
        const matchesRole = !role || rowRole.includes(role);
        const matchesStatus = !status || rowStatus === status;

        if (matchesSearch && matchesRole && matchesStatus) {
            row.style.display = '';
            visible++;
        } else {
            row.style.display = 'none';
        }
    });

    const countElem = document.getElementById('visibleUserCount');
    if (countElem) countElem.innerText = visible;
}
</script>

</body>
</html>
