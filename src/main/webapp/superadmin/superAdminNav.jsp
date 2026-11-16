<%@ page import="com.campusconnect.bean.SuperAdmin" %>
<%
    SuperAdmin navAdmin = (SuperAdmin) session.getAttribute("admin");
    if (navAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    String navAdminName = (navAdmin.getName() != null && !navAdmin.getName().trim().isEmpty()) ? navAdmin.getName() : "Super Administrator";
    String navAdminEmail = (navAdmin.getEmail() != null) ? navAdmin.getEmail() : "admin@campusconnect.com";
    String navInitial = "A";
    if (navAdminName.length() > 0) {
        navInitial = navAdminName.substring(0, 1).toUpperCase();
    }

    String currentNav = (String) request.getAttribute("activeNav");
    if (currentNav == null || currentNav.trim().isEmpty()) {
        currentNav = "";
    }
%>

<!-- Top Navigation matching Student Module -->
<header class="topbar">
    <a href="${pageContext.request.contextPath}/DashboardServlet" class="brand">
        <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
        <div>Campus<span>Connect</span></div>
        <span class="brand-role-pill">Super Admin</span>
    </a>

    <!-- User-Friendly Quick Search Bar in Topbar -->
    <div class="top-search">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text"
               id="globalNavSearch"
               placeholder="Quick search modules &amp; features..."
               autocomplete="off"
               onkeyup="if (typeof handleGlobalSearch === 'function') handleGlobalSearch(this.value)">
    </div>

    <div class="top-right">
        <div class="student-info">
            <div class="profile-link" title="Super Administrator Profile">
                <div class="profile-initial"><%=navInitial%></div>
            </div>
            <div style="display: flex; flex-direction: column;">
                <span class="student-name"><%=navAdminName%></span>
                <span style="font-size: 11px; color: #9ccaff; font-weight: 500;"><%=navAdminEmail%></span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout" title="Sign out of Super Admin session">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </a>
    </div>
</header>

<!-- Fixed Left Sidebar matching Student Module -->
<aside class="sidebar">
    <a href="${pageContext.request.contextPath}/DashboardServlet"
       class="side-link <%="dashboard".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Dashboard Overview">
        <span class="side-icon"><i class="fa-solid fa-chart-pie"></i></span>
        <span>Dashboard</span>
    </a>

    <a href="${pageContext.request.contextPath}/CollegeManagementServlet"
       class="side-link <%="colleges".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Manage Colleges & Institutions">
        <span class="side-icon"><i class="fa-solid fa-building-columns"></i></span>
        <span>Colleges</span>
    </a>

    <a href="${pageContext.request.contextPath}/CompanyManagementServlet"
       class="side-link <%="companies".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Manage Recruiting Companies">
        <span class="side-icon"><i class="fa-solid fa-building"></i></span>
        <span>Companies</span>
    </a>

    <a href="${pageContext.request.contextPath}/StudentManagementServlet"
       class="side-link <%="students".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Platform Students Directory">
        <span class="side-icon"><i class="fa-solid fa-user-graduate"></i></span>
        <span>Students</span>
    </a>

    <a href="${pageContext.request.contextPath}/MonitorRecruitmentServlet"
       class="side-link <%="drives".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Monitor Campus & Direct Drives">
        <span class="side-icon"><i class="fa-solid fa-bullhorn"></i></span>
        <span>Drives</span>
    </a>

    <a href="${pageContext.request.contextPath}/UserManagementServlet"
       class="side-link <%="users".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Platform User & Admin Accounts">
        <span class="side-icon"><i class="fa-solid fa-users-gear"></i></span>
        <span>Users</span>
    </a>

    <a href="${pageContext.request.contextPath}/SystemReportsServlet"
       class="side-link <%="reports".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Analytics & Platform Reports">
        <span class="side-icon"><i class="fa-solid fa-chart-line"></i></span>
        <span>Reports</span>
    </a>

    <a href="${pageContext.request.contextPath}/SystemSettingsServlet"
       class="side-link <%="settings".equalsIgnoreCase(currentNav) ? "active" : ""%>"
       title="Global System Settings">
        <span class="side-icon"><i class="fa-solid fa-sliders"></i></span>
        <span>Settings</span>
    </a>
</aside>
