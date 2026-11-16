<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.campusconnect.bean.College" %>
<%@ page import="com.campusconnect.dao.CollegeDAO" %>
<%@ page import="com.campusconnect.dao.SystemSettingDAO" %>
<%@ page import="com.campusconnect.bean.SystemSetting" %>
<%
    // Check if college registration is globally enabled by Super Admin
    SystemSettingDAO settingDAO = new SystemSettingDAO();
    SystemSetting setting = settingDAO.getSystemSettings();
    boolean isRegDisabled = (setting != null && "OFF".equalsIgnoreCase(setting.getCollegeRegistration()));

    // Load approved colleges for dropdown
    CollegeDAO collegeDAO = new CollegeDAO();
    ArrayList<College> allColleges = collegeDAO.getAllColleges();
    ArrayList<College> approvedColleges = new ArrayList<>();
    if (allColleges != null) {
        for (College col : allColleges) {
            if ("APPROVED".equalsIgnoreCase(col.getStatus())) {
                approvedColleges.add(col);
            }
        }
    }

    String preSelectId = request.getParameter("collegeId");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>College Admin Registration | CampusConnect</title>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    min-height: 100vh;
    background:
        radial-gradient(circle at 8% 5%, rgba(37,99,235,0.09), transparent 28%),
        radial-gradient(circle at 92% 12%, rgba(14,165,233,0.08), transparent 26%),
        #f5f8fc;
    color: #26364f;
    display: flex;
    flex-direction: column;
}

/* ================= HEADER ================= */
.header {
    background: linear-gradient(135deg, #091b3d, #123c88, #1769e0);
    color: white;
    padding: 16px 7%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 6px 25px rgba(5,20,50,0.18);
}

.logo {
    font-size: 25px;
    font-weight: bold;
    letter-spacing: -0.5px;
}

.logo span {
    color: #a9d0ff;
}

.nav-actions a {
    color: white;
    text-decoration: none;
    border: 1px solid rgba(255,255,255,0.6);
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: bold;
    background: rgba(255,255,255,0.08);
    transition: 0.25s;
    margin-left: 10px;
}

.nav-actions a:hover {
    background: white;
    color: #123c88;
    transform: translateY(-1px);
}

/* ================= CONTAINER & CARD ================= */
.container {
    width: 580px;
    max-width: 92%;
    margin: 35px auto 50px auto;
    flex: 1;
}

.page-title {
    text-align: center;
    margin-bottom: 25px;
}

.page-title h1 {
    font-size: 28px;
    color: #091b3d;
    margin-bottom: 8px;
}

.page-title p {
    font-size: 14px;
    color: #556987;
    line-height: 1.5;
}

.card {
    background: white;
    border-radius: 14px;
    padding: 35px 32px;
    box-shadow: 0 10px 35px rgba(12,38,73,0.08);
    border: 1px solid #e2ecf8;
    position: relative;
    overflow: hidden;
}

.card::before {
    content: "";
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 4px;
    background: linear-gradient(90deg, #1769e0, #00b4d8);
}

/* ================= FORM STYLES ================= */
.form-group {
    margin-bottom: 20px;
}

.form-label {
    display: block;
    font-size: 13px;
    font-weight: bold;
    color: #1e293b;
    margin-bottom: 7px;
}

.form-label span.req {
    color: #dc2626;
    margin-left: 3px;
}

.form-control, .form-select {
    width: 100%;
    padding: 12px 14px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-size: 14px;
    color: #1e293b;
    background: #f8fafc;
    transition: all 0.2s;
    outline: none;
}

.form-control:focus, .form-select:focus {
    border-color: #2563eb;
    background: white;
    box-shadow: 0 0 0 3px rgba(37,99,235,0.15);
}

.form-hint {
    font-size: 12px;
    color: #64748b;
    margin-top: 5px;
    display: block;
}

.btn-submit {
    width: 100%;
    padding: 13px;
    background: linear-gradient(135deg, #1769e0, #1258c4);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    box-shadow: 0 6px 18px rgba(23,105,224,0.22);
    transition: 0.25s;
    margin-top: 10px;
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 22px rgba(23,105,224,0.28);
}

.btn-submit:disabled {
    background: #94a3b8;
    cursor: not-allowed;
    box-shadow: none;
    transform: none;
}

/* ================= ALERTS ================= */
.alert {
    padding: 13px 16px;
    border-radius: 8px;
    font-size: 13px;
    margin-bottom: 22px;
    line-height: 1.5;
}

.alert-danger {
    background: #fef2f2;
    border-left: 4px solid #ef4444;
    color: #991b1b;
}

.alert-warning {
    background: #fffbeb;
    border-left: 4px solid #f59e0b;
    color: #92400e;
}

.login-link {
    text-align: center;
    margin-top: 22px;
    font-size: 14px;
    color: #556987;
}

.login-link a {
    color: #1769e0;
    text-decoration: none;
    font-weight: bold;
}

.login-link a:hover {
    text-decoration: underline;
}

/* ================= FOOTER ================= */
.footer {
    background: #091b3d;
    color: #c9d8eb;
    text-align: center;
    padding: 20px;
    font-size: 13px;
    margin-top: auto;
}
</style>

<script>
function validateForm() {
    var form = document.forms["collegeAdminForm"];
    var collegeId = form["collegeId"].value;
    var name = form["name"].value.trim();
    var email = form["email"].value.trim();
    var password = form["password"].value;
    var cpassword = form["cpassword"].value;

    if (!collegeId || collegeId === "") {
        alert("Please select your affiliated college.");
        form["collegeId"].focus();
        return false;
    }

    if (name.length < 2) {
        alert("Please enter a valid administrator name.");
        form["name"].focus();
        return false;
    }

    var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        alert("Please enter a valid email address.");
        form["email"].focus();
        return false;
    }

    if (password.length < 4) {
        alert("Password must be at least 4 characters.");
        form["password"].focus();
        return false;
    }

    if (password !== cpassword) {
        alert("Passwords do not match. Please re-enter.");
        form["cpassword"].focus();
        return false;
    }

    return true;
}
</script>
</head>
<body>

<!-- Header -->
<div class="header">
    <div class="logo">
        Campus<span>Connect</span>
    </div>
    <div class="nav-actions">
        <a href="<%=request.getContextPath()%>/index.jsp">&larr; Home</a>
        <a href="<%=request.getContextPath()%>/collegeAdminLogin.jsp">Login</a>
    </div>
</div>

<div class="container">

    <div class="page-title">
        <h1>College Administrator Registration</h1>
        <p>Register your institutional administrator account to manage departments, courses, faculty, and student admissions.</p>
    </div>

    <div class="card">

        <% if (isRegDisabled) { %>
            <div class="alert alert-warning">
                <strong>Notice:</strong> College Administrator Registration is currently disabled by the Super Administrator. Please contact the platform office if you require an administrator account.
            </div>
        <% } %>

        <% if ("failed".equalsIgnoreCase(error)) { %>
            <div class="alert alert-danger">
                <strong>Registration Failed:</strong> An administrator with this email may already exist, or the selected college is invalid.
            </div>
        <% } else if ("disabled".equalsIgnoreCase(error)) { %>
            <div class="alert alert-danger">
                <strong>Access Restricted:</strong> College registration is temporarily closed.
            </div>
        <% } else if ("exception".equalsIgnoreCase(error)) { %>
            <div class="alert alert-danger">
                <strong>System Error:</strong> An error occurred while processing your registration. Please try again.
            </div>
        <% } %>

        <form name="collegeAdminForm"
              action="${pageContext.request.contextPath}/CollegeAdminController"
              method="post"
              onsubmit="return validateForm();">

            <!-- Affiliated College Selection Dropdown -->
            <div class="form-group">
                <label class="form-label" for="collegeId">
                    Affiliated College / Institution <span class="req">*</span>
                </label>
                <select name="collegeId" id="collegeId" class="form-select" <%=isRegDisabled ? "disabled" : ""%> required>
                    <option value="">-- Choose Your College Institution --</option>
                    <%
                    if (approvedColleges != null && !approvedColleges.isEmpty()) {
                        for (College col : approvedColleges) {
                            boolean isSelected = preSelectId != null && preSelectId.trim().equals(String.valueOf(col.getCollegeId()));
                    %>
                        <option value="<%=col.getCollegeId()%>" <%=isSelected ? "selected" : ""%>>
                            <%=col.getCollegeName()%> (<%=col.getCity() != null ? col.getCity() : ""%>, <%=col.getState() != null ? col.getState() : ""%>)
                        </option>
                    <%
                        }
                    }
                    %>
                </select>
                <span class="form-hint">Select the approved educational institution you are authorized to manage.</span>
                <div style="margin-top: 10px; padding: 10px 14px; background: #eff6ff; border: 1px dashed #3b82f6; border-radius: 8px; font-size: 13px; color: #1e40af;">
                    <strong>Don't see your college listed?</strong>
                    Is your institution new to CampusConnect?
                    <a href="${pageContext.request.contextPath}/college-registration.jsp" style="color: #1d4ed8; font-weight: bold; text-decoration: underline; margin-left: 4px;">
                        Register New College Institution &rarr;
                    </a>
                </div>
            </div>

            <!-- Admin Full Name -->
            <div class="form-group">
                <label class="form-label" for="name">
                    Administrator Full Name <span class="req">*</span>
                </label>
                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       placeholder="e.g. Dr. Rajesh Sharma"
                       <%=isRegDisabled ? "disabled" : ""%>
                       required>
            </div>

            <!-- Official Email -->
            <div class="form-group">
                <label class="form-label" for="email">
                    Official College Email Address <span class="req">*</span>
                </label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control"
                       placeholder="e.g. admin@aec.edu.in"
                       <%=isRegDisabled ? "disabled" : ""%>
                       required>
                <span class="form-hint">Used as your login username and for institutional notifications.</span>
            </div>

            <!-- Password -->
            <div class="form-group">
                <label class="form-label" for="password">
                    Account Password <span class="req">*</span>
                </label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Create a secure password"
                       <%=isRegDisabled ? "disabled" : ""%>
                       required>
            </div>

            <!-- Confirm Password -->
            <div class="form-group">
                <label class="form-label" for="cpassword">
                    Confirm Password <span class="req">*</span>
                </label>
                <input type="password"
                       id="cpassword"
                       name="cpassword"
                       class="form-control"
                       placeholder="Re-enter password to confirm"
                       <%=isRegDisabled ? "disabled" : ""%>
                       required>
            </div>

            <button type="submit" class="btn-submit" <%=isRegDisabled ? "disabled" : ""%>>
                Complete Administrator Registration
            </button>

        </form>

        <div class="login-link">
            Already have an administrative account?
            <a href="${pageContext.request.contextPath}/collegeAdminLogin.jsp">Login to Dashboard</a>
        </div>

    </div>

</div>

<!-- Footer -->
<div class="footer">
    &copy; CampusConnect Platform. Multi-College, Multi-Recruiter Campus Recruitment Management System.
</div>

</body>
</html>
