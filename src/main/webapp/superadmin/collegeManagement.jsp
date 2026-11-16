<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.campusconnect.bean.College" %>
<%@ page import="com.campusconnect.bean.SuperAdmin" %>
<%@ page import="com.campusconnect.dao.CollegeDAO" %>

<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    ArrayList<College> list = (ArrayList<College>) request.getAttribute("collegeList");
    if (list == null) {
        CollegeDAO dao = new CollegeDAO();
        list = dao.getAllColleges();
    }

    int totalColleges = 0;
    int approvedCount = 0;
    int pendingCount = 0;
    int rejectedCount = 0;

    if (list != null) {
        totalColleges = list.size();
        for (College c : list) {
            String st = c.getStatus() != null ? c.getStatus().toUpperCase() : "";
            if ("APPROVED".equals(st)) approvedCount++;
            else if ("PENDING".equals(st)) pendingCount++;
            else if ("REJECTED".equals(st)) rejectedCount++;
        }
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    request.setAttribute("activeNav", "colleges");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>College Management | CampusConnect</title>

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
            <h1>Educational Institutions & Colleges</h1>
            <p>Verify institutional registrations, manage academic affiliations, and oversee campus placement drives.</p>
        </div>
        <div class="page-actions">
            <button type="button" class="btn btn-primary" onclick="openAddModal()">
                <i class="fa-solid fa-plus"></i>
                <span>Add College Institution</span>
            </button>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <% if ("added".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>College institution and administrative credentials successfully registered.</span>
        </div>
    <% } else if ("approved".equalsIgnoreCase(success)) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>College institution has been approved and activated for student admissions and placement drives.</span>
        </div>
    <% } else if ("rejected".equalsIgnoreCase(success)) { %>
        <div class="alert alert-warning">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span>College institution status updated to Rejected.</span>
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>Action could not be completed. Please verify form data or database connection.</span>
        </div>
    <% } %>

    <!-- KPI Metric Cards -->
    <div class="stats-grid">
        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Total Colleges</span>
                    <div class="kpi-value"><%=totalColleges%></div>
                </div>
                <div class="kpi-icon blue"><i class="fa-solid fa-building-columns"></i></div>
            </div>
            <div class="kpi-subtext">Registered across the platform</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Approved Colleges</span>
                    <div class="kpi-value" style="color: #16a34a;"><%=approvedCount%></div>
                </div>
                <div class="kpi-icon green"><i class="fa-solid fa-check-double"></i></div>
            </div>
            <div class="kpi-subtext">Active for drives & admissions</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Pending Approvals</span>
                    <div class="kpi-value" style="color: #d97706;"><%=pendingCount%></div>
                </div>
                <div class="kpi-icon orange"><i class="fa-solid fa-hourglass-half"></i></div>
            </div>
            <div class="kpi-subtext">Awaiting administrative verification</div>
        </div>

        <div class="kpi-card">
            <div class="kpi-header">
                <div>
                    <span class="kpi-title">Rejected Institutions</span>
                    <div class="kpi-value" style="color: #dc2626;"><%=rejectedCount%></div>
                </div>
                <div class="kpi-icon red"><i class="fa-solid fa-ban"></i></div>
            </div>
            <div class="kpi-subtext">Application declined or suspended</div>
        </div>
    </div>

    <!-- Content Card with Live Search & Filter -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">
                <i class="fa-solid fa-list" style="color: #2563eb;"></i>
                <span>Registered Institutions Directory (<span id="visibleCount"><%=totalColleges%></span>)</span>
            </div>
            <div class="filter-bar">
                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="searchInput" placeholder="Search by name, city, state..." onkeyup="filterTable()">
                </div>
                <select id="statusFilter" class="filter-select" onchange="filterTable()">
                    <option value="">All Statuses</option>
                    <option value="APPROVED">Approved Only</option>
                    <option value="PENDING">Pending Only</option>
                    <option value="REJECTED">Rejected Only</option>
                </select>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table" id="collegeTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Institution Name</th>
                        <th>Location</th>
                        <th>Contact Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th style="text-align: right;">Administrative Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if (list != null && !list.isEmpty()) {
                        for (College c : list) {
                            String rawStatus = c.getStatus() != null ? c.getStatus().trim() : "Pending";
                            String badgeClass = "badge-pending";
                            if ("Approved".equalsIgnoreCase(rawStatus)) badgeClass = "badge-approved";
                            else if ("Rejected".equalsIgnoreCase(rawStatus)) badgeClass = "badge-rejected";
                    %>
                    <tr data-status="<%=rawStatus.toUpperCase()%>">
                        <td><strong>#<%=c.getCollegeId()%></strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/CollegeDetailsServlet?id=<%=c.getCollegeId()%>"
                               style="font-weight: 700; color: #2563eb; display: flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-building-columns" style="font-size: 13px; color: #64748b;"></i>
                                <span><%=c.getCollegeName()%></span>
                            </a>
                        </td>
                        <td>
                            <%=c.getCity() != null ? c.getCity() : ""%><%= (c.getState() != null && !c.getState().isEmpty()) ? ", " + c.getState() : "" %>
                        </td>
                        <td>
                            <a href="mailto:<%=c.getEmail()%>" style="color: #64748b; font-size: 13px;">
                                <i class="fa-regular fa-envelope" style="margin-right: 4px;"></i>
                                <%=c.getEmail() != null ? c.getEmail() : "N/A"%>
                            </a>
                        </td>
                        <td><%=c.getPhone() != null && !c.getPhone().isEmpty() ? c.getPhone() : "N/A"%></td>
                        <td>
                            <span class="badge <%=badgeClass%>"><%=rawStatus%></span>
                        </td>
                        <td style="text-align: right;">
                            <div style="display: inline-flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/CollegeDetailsServlet?id=<%=c.getCollegeId()%>"
                                   class="btn btn-outline btn-sm" title="View Full Details & Management">
                                    <i class="fa-solid fa-eye"></i>
                                    <span>Details</span>
                                </a>
                                <% if (!"Approved".equalsIgnoreCase(rawStatus)) { %>
                                    <a href="${pageContext.request.contextPath}/ApproveCollegeServlet?id=<%=c.getCollegeId()%>"
                                       class="btn btn-success btn-sm"
                                       title="Approve College"
                                       onclick="return confirm('Approve <%=c.getCollegeName()%> for the platform?');">
                                        <i class="fa-solid fa-check"></i>
                                        <span>Approve</span>
                                    </a>
                                <% } %>
                                <% if (!"Rejected".equalsIgnoreCase(rawStatus)) { %>
                                    <a href="${pageContext.request.contextPath}/RejectCollegeServlet?id=<%=c.getCollegeId()%>"
                                       class="btn btn-danger btn-sm"
                                       title="Reject College"
                                       onclick="return confirm('Reject <%=c.getCollegeName()%>?');">
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
                            <i class="fa-solid fa-building-columns" style="font-size: 28px; margin-bottom: 10px; display: block;"></i>
                            No college institutions currently registered on the platform.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</main>

<!-- Add College Institution Modal Dialog -->
<div class="modal-backdrop" id="addCollegeModal">
    <div class="modal-card">
        <div class="modal-header">
            <h3><i class="fa-solid fa-building-columns" style="color: #2563eb; margin-right: 8px;"></i>Add College Institution</h3>
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
                    <label class="form-label" for="colAddress">Campus Address</label>
                    <input type="text" id="colAddress" name="address" class="form-control" placeholder="Campus Street, Area">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="colEmail">Official Email</label>
                        <input type="email" id="colEmail" name="email" class="form-control" placeholder="contact@college.edu">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="colPhone">Contact Phone</label>
                        <input type="text" id="colPhone" name="phone" class="form-control" placeholder="e.g. 0341-2252108">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="colStatus">Initial Status</label>
                    <select id="colStatus" name="status" class="form-select-full">
                        <option value="Approved" selected>Approved (Active Immediately)</option>
                        <option value="Pending">Pending Verification</option>
                    </select>
                </div>

                <div style="margin-top: 20px; padding-top: 15px; border-top: 1px dashed var(--border-color);">
                    <h4 style="font-size: 14px; font-weight: 750; margin-bottom: 12px; color: #1e3a8a;">
                        <i class="fa-solid fa-user-shield" style="margin-right: 6px;"></i>Primary Administrator Credentials (Optional)
                    </h4>
                    <div class="form-group">
                        <label class="form-label" for="adminName">Administrator Name</label>
                        <input type="text" id="adminName" name="adminName" class="form-control" placeholder="e.g. Dr. Rajesh Sharma">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="adminEmail">Admin Login Email</label>
                            <input type="email" id="adminEmail" name="adminEmail" class="form-control" placeholder="admin@college.edu">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="adminPassword">Admin Password</label>
                            <input type="password" id="adminPassword" name="adminPassword" class="form-control" placeholder="Security password">
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeAddModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-check"></i>
                    <span>Register Institution</span>
                </button>
            </div>
        </form>
    </div>
</div>

<footer class="footer">
    &copy; CampusConnect Platform. Super Administrator Control Center.
</footer>

<script>
function openAddModal() {
    document.getElementById('addCollegeModal').classList.add('active');
}
function closeAddModal() {
    document.getElementById('addCollegeModal').classList.remove('active');
}

function filterTable() {
    const search = document.getElementById('searchInput').value.toLowerCase();
    const status = document.getElementById('statusFilter').value.toUpperCase();
    const rows = document.querySelectorAll('#collegeTable tbody tr');
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

    const countElem = document.getElementById('visibleCount');
    if (countElem) countElem.innerText = visible;
}
</script>

</body>
</html>
