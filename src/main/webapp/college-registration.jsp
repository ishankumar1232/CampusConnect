<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.dao.SystemSettingDAO" %>
<%@ page import="com.campusconnect.bean.SystemSetting" %>
<%
    SystemSettingDAO settingDAO = new SystemSettingDAO();
    SystemSetting setting = settingDAO.getSystemSettings();
    boolean isRegDisabled = (setting != null && "OFF".equalsIgnoreCase(setting.getCollegeRegistration()));
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register New College Institution | CampusConnect</title>
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
    width: 680px;
    max-width: 94%;
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

.section-heading {
    font-size: 16px;
    font-weight: bold;
    color: #091b3d;
    padding-bottom: 8px;
    margin-top: 15px;
    margin-bottom: 18px;
    border-bottom: 2px solid #eef2f7;
    display: flex;
    align-items: center;
    gap: 8px;
}

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}

.form-group {
    margin-bottom: 18px;
}

.form-group.full {
    grid-column: 1 / -1;
}

.form-label {
    display: block;
    font-size: 13px;
    font-weight: bold;
    color: #1e293b;
    margin-bottom: 6px;
}

.form-label span.req {
    color: #dc2626;
    margin-left: 3px;
}

.form-control {
    width: 100%;
    padding: 11px 14px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-size: 14px;
    color: #1e293b;
    background: #f8fafc;
    transition: all 0.2s;
    outline: none;
}

.form-control:focus {
    border-color: #2563eb;
    background: white;
    box-shadow: 0 0 0 3px rgba(37,99,235,0.15);
}

.form-hint {
    font-size: 11.5px;
    color: #64748b;
    margin-top: 4px;
    display: block;
}

.btn-submit {
    width: 100%;
    padding: 14px;
    background: linear-gradient(135deg, #1769e0, #1258c4);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    box-shadow: 0 6px 18px rgba(23,105,224,0.22);
    transition: 0.25s;
    margin-top: 15px;
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 22px rgba(23,105,224,0.28);
}

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

.info-note {
    background: #f0f7ff;
    border-left: 4px solid #2563eb;
    padding: 12px 16px;
    border-radius: 6px;
    font-size: 13px;
    color: #1e3a8a;
    margin-bottom: 20px;
    line-height: 1.5;
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
function validateCollegeForm() {
    var form = document.forms["newCollegeForm"];
    var collegeName = form["collegeName"].value.trim();
    var city = form["city"].value.trim();
    var state = form["state"].value.trim();
    var adminName = form["adminName"].value.trim();
    var adminEmail = form["adminEmail"].value.trim();
    var password = form["password"].value;
    var cpassword = form["cpassword"].value;

    if (collegeName.length < 3) {
        alert("Please enter a valid institution name.");
        form["collegeName"].focus();
        return false;
    }

    if (city.length < 2) {
        alert("Please enter the city where the college is located.");
        form["city"].focus();
        return false;
    }

    if (state.length < 2) {
        alert("Please enter the state.");
        form["state"].focus();
        return false;
    }

    var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(adminEmail)) {
        alert("Please enter a valid administrator email address.");
        form["adminEmail"].focus();
        return false;
    }

    if (password.length < 4) {
        alert("Password must be at least 4 characters.");
        form["password"].focus();
        return false;
    }

    if (password !== cpassword) {
        alert("Passwords do not match. Please verify your confirm password.");
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
        <h1>Register New College Institution</h1>
        <p>Onboard your educational institution to connect with verified recruiters, host recruitment drives, and empower your students.</p>
    </div>

    <div class="card">

        <div class="info-note">
            <strong>Institutional Approval Process:</strong> Once submitted, your registration request will be reviewed by the Super Administrator. Once approved, your college will become active on the platform and you can log in to your College Dashboard.
        </div>

        <% if (isRegDisabled) { %>
            <div class="alert alert-warning">
                <strong>Notice:</strong> Institutional College Registration is currently closed by the Super Administrator.
            </div>
        <% } %>

        <% if ("failed".equalsIgnoreCase(error)) { %>
            <div class="alert alert-danger">
                <strong>Registration Failed:</strong> An institution or administrator with this email may already be registered.
            </div>
        <% } else if ("missing_fields".equalsIgnoreCase(error)) { %>
            <div class="alert alert-danger">
                <strong>Missing Fields:</strong> Please ensure all mandatory fields are provided.
            </div>
        <% } else if ("disabled".equalsIgnoreCase(error)) { %>
            <div class="alert alert-danger">
                <strong>Closed:</strong> Institutional onboarding is currently disabled by Super Admin.
            </div>
        <% } %>

        <form name="newCollegeForm"
              action="${pageContext.request.contextPath}/RegisterCollegeServlet"
              method="post"
              onsubmit="return validateCollegeForm();">

            <!-- Section 1: College Institutional Info -->
            <div class="section-heading">
                1. College / Institutional Profile
            </div>

            <div class="form-group">
                <label class="form-label" for="collegeName">
                    College / University Full Name <span class="req">*</span>
                </label>
                <input type="text"
                       id="collegeName"
                       name="collegeName"
                       class="form-control"
                       placeholder="e.g. Asansol Engineering College"
                       <%=isRegDisabled ? "disabled" : ""%>
                       required>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label" for="city">
                        City <span class="req">*</span>
                    </label>
                    <input type="text"
                           id="city"
                           name="city"
                           class="form-control"
                           placeholder="e.g. Asansol"
                           <%=isRegDisabled ? "disabled" : ""%>
                           required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="state">
                        State <span class="req">*</span>
                    </label>
                    <input type="text"
                           id="state"
                           name="state"
                           class="form-control"
                           placeholder="e.g. West Bengal"
                           <%=isRegDisabled ? "disabled" : ""%>
                           required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="address">
                    Campus Address
                </label>
                <input type="text"
                       id="address"
                       name="address"
                       class="form-control"
                       placeholder="e.g. Vivekananda Sarani, Kanyapur"
                       <%=isRegDisabled ? "disabled" : ""%>>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label" for="collegeEmail">
                        College Official Email
                    </label>
                    <input type="email"
                           id="collegeEmail"
                           name="collegeEmail"
                           class="form-control"
                           placeholder="e.g. contact@aecwb.edu.in"
                           <%=isRegDisabled ? "disabled" : ""%>>
                </div>
                <div class="form-group">
                    <label class="form-label" for="phone">
                        Contact Phone / Landline
                    </label>
                    <input type="text"
                           id="phone"
                           name="phone"
                           class="form-control"
                           placeholder="e.g. 0341-2252108"
                           <%=isRegDisabled ? "disabled" : ""%>>
                </div>
            </div>

            <!-- Section 2: Administrator Account -->
            <div class="section-heading" style="margin-top:25px;">
                2. Principal / Administrator Login Account
            </div>

            <div class="form-group">
                <label class="form-label" for="adminName">
                    Administrator Full Name <span class="req">*</span>
                </label>
                <input type="text"
                       id="adminName"
                       name="adminName"
                       class="form-control"
                       placeholder="e.g. Dr. P. K. Banerjee"
                       <%=isRegDisabled ? "disabled" : ""%>
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="adminEmail">
                    Administrator Official Email (Username) <span class="req">*</span>
                </label>
                <input type="email"
                       id="adminEmail"
                       name="adminEmail"
                       class="form-control"
                       placeholder="e.g. principal@aecwb.edu.in"
                       <%=isRegDisabled ? "disabled" : ""%>
                       required>
                <span class="form-hint">This email will be used to log in to your College Dashboard.</span>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label" for="password">
                        Password <span class="req">*</span>
                    </label>
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="Create password"
                           <%=isRegDisabled ? "disabled" : ""%>
                           required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="cpassword">
                        Confirm Password <span class="req">*</span>
                    </label>
                    <input type="password"
                           id="cpassword"
                           name="cpassword"
                           class="form-control"
                           placeholder="Confirm password"
                           <%=isRegDisabled ? "disabled" : ""%>
                           required>
                </div>
            </div>

            <button type="submit" class="btn-submit" <%=isRegDisabled ? "disabled" : ""%>>
                Submit College for Platform Approval
            </button>

        </form>

        <div class="login-link">
            Already registered?
            <a href="${pageContext.request.contextPath}/collegeAdminLogin.jsp">Login here</a>
            &nbsp;|&nbsp;
            Affiliated with an existing college?
            <a href="${pageContext.request.contextPath}/collegeAdminRegister.jsp">Join existing college</a>
        </div>

    </div>

</div>

<!-- Footer -->
<div class="footer">
    &copy; CampusConnect Platform. Multi-College, Multi-Recruiter Campus Recruitment Management System.
</div>

</body>
</html>
