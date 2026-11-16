<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
    // Status can come from request attribute (forward) or query parameter (redirect)
    String status = (String) request.getAttribute("status");
    if (status == null || status.trim().isEmpty()) {
        status = request.getParameter("status");
    }
    if (status == null || status.trim().isEmpty()) {
        status = "success";
    }

    String message = (String) request.getAttribute("message");
    if (message == null || message.trim().isEmpty()) {
        message = request.getParameter("message");
    }

    // Student ID
    Object sIdObj = request.getAttribute("studentId");
    int studentId = 0;
    if (sIdObj != null) {
        try {
            studentId = Integer.parseInt(sIdObj.toString());
        } catch (Exception ignore) {}
    } else if (request.getParameter("studentId") != null) {
        try {
            studentId = Integer.parseInt(request.getParameter("studentId").trim());
        } catch (Exception ignore) {}
    }

    // Student details
    String name = (String) request.getAttribute("name");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    String collegeName = (String) request.getAttribute("collegeName");
    String courseName = (String) request.getAttribute("courseName");
    String admissionId = (String) request.getAttribute("admissionId");

    if (name == null) name = request.getParameter("name");
    if (email == null) email = request.getParameter("email");
    if (phone == null) phone = request.getParameter("phone");
    if (collegeName == null) collegeName = request.getParameter("collegeName");
    if (courseName == null) courseName = request.getParameter("courseName");
    if (admissionId == null) admissionId = request.getParameter("admissionId");

    // If studentId > 0 and details are missing, query from DB
    if (studentId > 0 && (name == null || email == null || collegeName == null)) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (
                Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "CAMPUSCONNECT",
                    "campus123"
                );
                PreparedStatement ps = con.prepareStatement(
                    "SELECT S.NAME, S.EMAIL, S.PHONE, C.COLLEGE_NAME, CR.COURSE_NAME, A.ADMISSION_ID " +
                    "FROM STUDENT S " +
                    "LEFT JOIN COLLEGE C ON S.COLLEGE_ID = C.COLLEGE_ID " +
                    "LEFT JOIN COURSE CR ON S.COURSE_ID = CR.COURSE_ID " +
                    "LEFT JOIN ADMISSION A ON S.STUDENT_ID = A.STUDENT_ID " +
                    "WHERE S.STUDENT_ID = ?"
                )
            ) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        if (name == null) name = rs.getString("NAME");
                        if (email == null) email = rs.getString("EMAIL");
                        if (phone == null) phone = rs.getString("PHONE");
                        if (collegeName == null) collegeName = rs.getString("COLLEGE_NAME");
                        if (courseName == null) courseName = rs.getString("COURSE_NAME");
                        if (admissionId == null && rs.getObject("ADMISSION_ID") != null) {
                            admissionId = String.valueOf(rs.getInt("ADMISSION_ID"));
                        }
                    }
                }
            }
        } catch (Exception e) {
            application.log("Error reading student details in status page", e);
        }
    }

    if (name == null || name.trim().isEmpty()) name = "Student";
    if (collegeName == null || collegeName.trim().isEmpty()) collegeName = "CampusConnect Affiliated College";
    if (courseName == null || courseName.trim().isEmpty()) courseName = "Undergraduate / Postgraduate";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Registration Status | CampusConnect</title>

<!-- Fonts & Icons -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --bg-color: #f4f7fb;
    --card-bg: #ffffff;
    --primary: #1769e0;
    --primary-dark: #0f4eb3;
    --primary-light: #eef5ff;
    --success: #16a34a;
    --success-bg: #ecfdf5;
    --success-border: #a7f3d0;
    --warning: #d97706;
    --warning-bg: #fffbeb;
    --warning-border: #fde68a;
    --danger: #dc2626;
    --danger-bg: #fef2f2;
    --danger-border: #fecaca;
    --text-main: #183b5b;
    --text-muted: #64748b;
    --border-color: #e2e8f0;
    --shadow-md: 0 12px 35px -8px rgba(15, 45, 90, 0.10);
    --radius-lg: 18px;
    --radius-md: 12px;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Plus Jakarta Sans', Arial, sans-serif;
}

body {
    background-color: var(--bg-color);
    color: var(--text-main);
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

a {
    text-decoration: none;
    color: inherit;
}

/* HEADER */
.header {
    background: linear-gradient(135deg, #091b3d, #123c88, #1769e0);
    color: white;
    padding: 18px 7%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 6px 25px rgba(9, 27, 61, 0.2);
    position: sticky;
    top: 0;
    z-index: 100;
}

.logo {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 25px;
    font-weight: 800;
    letter-spacing: -0.5px;
}

.logo-badge {
    width: 38px;
    height: 38px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.18);
    display: grid;
    place-items: center;
    font-size: 20px;
}

.logo span {
    color: #a9d0ff;
}

.header-links {
    display: flex;
    align-items: center;
    gap: 12px;
}

.nav-btn {
    color: white;
    padding: 9px 18px;
    border-radius: 8px;
    font-size: 13.5px;
    font-weight: 600;
    border: 1px solid rgba(255,255,255,0.4);
    background: rgba(255,255,255,0.06);
    transition: 0.2s;
    display: inline-flex;
    align-items: center;
    gap: 7px;
}

.nav-btn:hover {
    background: white;
    color: #123c88;
    transform: translateY(-1px);
}

.nav-btn.primary {
    background: white;
    color: #123c88;
    border-color: white;
    box-shadow: 0 4px 14px rgba(0,0,0,0.12);
}

.nav-btn.primary:hover {
    background: #eaf3ff;
}

/* MAIN CONTAINER */
.container {
    width: 90%;
    max-width: 860px;
    margin: 45px auto 60px;
    flex: 1;
}

/* STATUS CARD */
.status-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-md);
    overflow: hidden;
    animation: fadeIn 0.35s ease-out;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(16px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* HERO SECTION */
.status-hero {
    padding: 45px 36px 36px;
    text-align: center;
    border-bottom: 1px solid var(--border-color);
    position: relative;
}

.status-hero.success {
    background: radial-gradient(circle at 50% 0%, #ecfdf5 0%, #ffffff 80%);
}

.status-hero.warning {
    background: radial-gradient(circle at 50% 0%, #fffbeb 0%, #ffffff 80%);
}

.status-hero.danger {
    background: radial-gradient(circle at 50% 0%, #fef2f2 0%, #ffffff 80%);
}

.hero-icon-ring {
    width: 86px;
    height: 86px;
    border-radius: 50%;
    margin: 0 auto 20px;
    display: grid;
    place-items: center;
    font-size: 42px;
    box-shadow: 0 10px 25px -4px rgba(0,0,0,0.08);
}

.status-hero.success .hero-icon-ring {
    background: #dcfce7;
    color: var(--success);
    border: 3px solid #86efac;
}

.status-hero.warning .hero-icon-ring {
    background: #fef3c7;
    color: var(--warning);
    border: 3px solid #fcd34d;
}

.status-hero.danger .hero-icon-ring {
    background: #fee2e2;
    color: var(--danger);
    border: 3px solid #fca5a5;
}

.hero-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 5px 14px;
    border-radius: 20px;
    font-size: 11.5px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    margin-bottom: 12px;
}

.status-hero.success .hero-tag {
    background: #dcfce7;
    color: #15803d;
}

.status-hero.warning .hero-tag {
    background: #fef3c7;
    color: #b45309;
}

.status-hero.danger .hero-tag {
    background: #fee2e2;
    color: #b91c1c;
}

.hero-title {
    font-size: 32px;
    font-weight: 800;
    letter-spacing: -0.6px;
    color: var(--text-main);
    margin-bottom: 10px;
}

.hero-subtitle {
    font-size: 15px;
    color: var(--text-muted);
    max-width: 600px;
    margin: 0 auto;
    line-height: 1.6;
}

/* CARD BODY */
.status-body {
    padding: 34px 38px;
}

/* STUDENT ID CALLOUT */
.student-id-banner {
    background: linear-gradient(135deg, #eff6ff, #f3f8fe);
    border: 2px dashed #93c5fd;
    border-radius: var(--radius-md);
    padding: 22px 28px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    margin-bottom: 28px;
}

.id-left {
    display: flex;
    align-items: center;
    gap: 16px;
}

.id-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    background: var(--primary);
    color: white;
    display: grid;
    place-items: center;
    font-size: 22px;
    flex-shrink: 0;
}

.id-meta label {
    font-size: 12px;
    font-weight: 700;
    color: #475569;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    display: block;
}

.id-meta .id-value {
    font-size: 28px;
    font-weight: 800;
    color: #1e40af;
    letter-spacing: -0.5px;
}

.copy-btn {
    background: white;
    border: 1px solid #bfdbfe;
    color: var(--primary);
    font-size: 13px;
    font-weight: 700;
    padding: 10px 18px;
    border-radius: 9px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 7px;
    transition: 0.2s;
}

.copy-btn:hover {
    background: var(--primary);
    color: white;
}

/* DOSSIER GRID */
.dossier-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
    background: #f8fafc;
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 20px;
    margin-bottom: 28px;
}

.dossier-item {
    display: flex;
    flex-direction: column;
    gap: 3px;
}

.dossier-label {
    font-size: 11px;
    font-weight: 700;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.dossier-value {
    font-size: 14.5px;
    font-weight: 700;
    color: var(--text-main);
    word-break: break-word;
}

/* ONBOARDING TIMELINE */
.roadmap-box {
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 22px;
    background: #ffffff;
    margin-bottom: 30px;
}

.roadmap-title {
    font-size: 14px;
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 18px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.roadmap-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 12px;
}

.roadmap-step {
    background: #f8fafc;
    border: 1px solid #edf2f7;
    border-radius: 10px;
    padding: 14px;
    text-align: center;
}

.roadmap-step.active {
    background: #eff6ff;
    border-color: #bfdbfe;
}

.step-num {
    width: 26px;
    height: 26px;
    border-radius: 50%;
    margin: 0 auto 8px;
    display: grid;
    place-items: center;
    font-size: 11px;
    font-weight: 800;
    background: #e2e8f0;
    color: #475569;
}

.roadmap-step.active .step-num {
    background: var(--primary);
    color: white;
}

.step-heading {
    font-size: 12px;
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 3px;
}

.step-desc {
    font-size: 11px;
    color: var(--text-muted);
    line-height: 1.35;
}

/* ACTIONS */
.status-actions {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 14px;
    flex-wrap: wrap;
}

.btn {
    padding: 14px 26px;
    border-radius: 10px;
    font-size: 14.5px;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: 0.2s;
    cursor: pointer;
    border: none;
}

.btn-primary {
    background: linear-gradient(135deg, #1769e0, #0f4eb3);
    color: white;
    box-shadow: 0 4px 16px rgba(23, 105, 224, 0.28);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(23, 105, 224, 0.38);
}

.btn-secondary {
    background: #f1f5f9;
    color: #334155;
    border: 1px solid var(--border-color);
}

.btn-secondary:hover {
    background: #e2e8f0;
    color: var(--text-main);
}

/* FOOTER */
.footer {
    text-align: center;
    color: var(--text-muted);
    font-size: 12.5px;
    padding: 24px 10px;
    margin-top: 20px;
}

@media(max-width: 700px) {
    .container {
        width: 94%;
        margin-top: 24px;
    }
    .status-hero {
        padding: 32px 20px 24px;
    }
    .status-body {
        padding: 22px 18px;
    }
    .hero-title {
        font-size: 24px;
    }
    .dossier-grid {
        grid-template-columns: 1fr;
    }
    .student-id-banner {
        flex-direction: column;
        align-items: flex-start;
        gap: 14px;
    }
    .copy-btn {
        width: 100%;
        justify-content: center;
    }
    .roadmap-grid {
        grid-template-columns: 1fr;
    }
    .status-actions {
        flex-direction: column;
    }
    .btn {
        width: 100%;
        justify-content: center;
    }
}
</style>
</head>

<body>

<!-- HEADER -->
<header class="header">
    <a href="index.jsp" class="logo">
        <div class="logo-badge"><i class="fa-solid fa-graduation-cap"></i></div>
        <div>Campus<span>Connect</span></div>
    </a>

    <div class="header-links">
        <a href="student_login.jsp" class="nav-btn primary">
            <i class="fa-solid fa-right-to-bracket"></i> Student Login
        </a>
        <a href="index.jsp" class="nav-btn">
            <i class="fa-solid fa-house"></i> Home
        </a>
    </div>
</header>

<!-- MAIN CONTAINER -->
<div class="container">

    <div class="status-card">

        <% if ("success".equalsIgnoreCase(status)) { %>
            <!-- ==============================================
                 SUCCESS STATE: REGISTRATION COMPLETED
            ============================================== -->
            <div class="status-hero success">
                <div class="hero-icon-ring">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <div class="hero-tag">
                    <i class="fa-solid fa-shield-halved"></i> Verified Registration
                </div>
                <h1 class="hero-title">Registration Completed!</h1>
                <p class="hero-subtitle">
                    Welcome to CampusConnect, <strong><%= name %></strong>! Your student account is now fully active and linked with your verified college admission.
                </p>
            </div>

            <div class="status-body">

                <!-- STUDENT ID HIGHLIGHT -->
                <div class="student-id-banner">
                    <div class="id-left">
                        <div class="id-icon">
                            <i class="fa-solid fa-id-card"></i>
                        </div>
                        <div class="id-meta">
                            <label>Your Official Student ID</label>
                            <div class="id-value" id="studentIdValue">
                                #<%= studentId > 0 ? studentId : "STU-" + System.currentTimeMillis() % 10000 %>
                            </div>
                        </div>
                    </div>
                    <button class="copy-btn" onclick="copyStudentId()">
                        <i class="fa-regular fa-copy"></i> Copy Student ID
                    </button>
                </div>

                <!-- STUDENT DOSSIER SUMMARY -->
                <div class="dossier-grid">
                    <div class="dossier-item">
                        <span class="dossier-label">Full Name</span>
                        <div class="dossier-value"><%= name %></div>
                    </div>

                    <div class="dossier-item">
                        <span class="dossier-label">Login Email</span>
                        <div class="dossier-value" style="color: var(--primary);"><%= email != null ? email : "N/A" %></div>
                    </div>

                    <div class="dossier-item">
                        <span class="dossier-label">College</span>
                        <div class="dossier-value"><%= collegeName %></div>
                    </div>

                    <div class="dossier-item">
                        <span class="dossier-label">Course</span>
                        <div class="dossier-value"><%= courseName %></div>
                    </div>

                    <% if (phone != null && !phone.trim().isEmpty()) { %>
                    <div class="dossier-item">
                        <span class="dossier-label">Contact Phone</span>
                        <div class="dossier-value"><%= phone %></div>
                    </div>
                    <% } %>

                    <% if (admissionId != null && !admissionId.trim().isEmpty()) { %>
                    <div class="dossier-item">
                        <span class="dossier-label">Admission ID</span>
                        <div class="dossier-value">#<%= admissionId %></div>
                    </div>
                    <% } %>

                    <div class="dossier-item">
                        <span class="dossier-label">Account Status</span>
                        <div class="dossier-value" style="color: var(--success);">
                            <i class="fa-solid fa-circle-dot" style="font-size: 11px;"></i> Active & Ready
                        </div>
                    </div>

                    <div class="dossier-item">
                        <span class="dossier-label">Registration Date</span>
                        <div class="dossier-value"><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %></div>
                    </div>
                </div>

                <!-- 4-STEP ONBOARDING ROADMAP -->
                <div class="roadmap-box">
                    <div class="roadmap-title">
                        <i class="fa-solid fa-compass" style="color: var(--primary);"></i>
                        What you can do next in your Student Portal:
                    </div>
                    <div class="roadmap-grid">
                        <div class="roadmap-step active">
                            <div class="step-num">1</div>
                            <div class="step-heading">Sign In</div>
                            <div class="step-desc">Login with your Email & Password</div>
                        </div>
                        <div class="roadmap-step">
                            <div class="step-num">2</div>
                            <div class="step-heading">Academics</div>
                            <div class="step-desc">Add marks, CGPA & 10th/12th scores</div>
                        </div>
                        <div class="roadmap-step">
                            <div class="step-num">3</div>
                            <div class="step-heading">Upload CV</div>
                            <div class="step-desc">Attach your latest resume & skills</div>
                        </div>
                        <div class="roadmap-step">
                            <div class="step-num">4</div>
                            <div class="step-heading">Apply Drives</div>
                            <div class="step-desc">Browse jobs & land top offers</div>
                        </div>
                    </div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="status-actions">
                    <a href="student_login.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-right-to-bracket"></i> Proceed to Student Login
                    </a>
                    <a href="index.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-house"></i> Home Page
                    </a>
                </div>

            </div>

        <% } else if ("already_exists".equalsIgnoreCase(status) || "already_registered".equalsIgnoreCase(status)) { %>
            <!-- ==============================================
                 ALREADY REGISTERED STATE
            ============================================== -->
            <div class="status-hero warning">
                <div class="hero-icon-ring">
                    <i class="fa-solid fa-user-check"></i>
                </div>
                <div class="hero-tag">
                    <i class="fa-solid fa-info-circle"></i> Existing Account
                </div>
                <h1 class="hero-title">Account Already Exists</h1>
                <p class="hero-subtitle">
                    An active student account is already registered with this Email ID
                    <% if (email != null && !email.trim().isEmpty()) { %>
                        (<strong><%= email %></strong>)
                    <% } %>
                    or admission record. You can sign in directly using your credentials.
                </p>
            </div>

            <div class="status-body">
                <div class="roadmap-box">
                    <div class="roadmap-title">
                        <i class="fa-solid fa-lightbulb" style="color: var(--warning);"></i>
                        How to access your account:
                    </div>
                    <p style="font-size: 13.5px; color: var(--text-muted); line-height: 1.6; margin-bottom: 14px;">
                        Since your registration is already complete, you do not need to register again. Simply click below to proceed to the student login page. If you forgot your password, contact your college placement cell.
                    </p>
                </div>

                <div class="status-actions">
                    <a href="student_login.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-right-to-bracket"></i> Go to Student Login
                    </a>
                    <a href="new_student_check_status.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-magnifying-glass"></i> Track Admission Status
                    </a>
                    <a href="index.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-house"></i> Home
                    </a>
                </div>
            </div>

        <% } else { %>
            <!-- ==============================================
                 NOTICE / ERROR STATE
            ============================================== -->
            <div class="status-hero danger">
                <div class="hero-icon-ring">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div class="hero-tag">
                    <i class="fa-solid fa-circle-exclamation"></i> Action Required
                </div>
                <h1 class="hero-title">Registration Notice</h1>
                <p class="hero-subtitle">
                    <%= (message != null && !message.trim().isEmpty())
                        ? message
                        : "Your admission must be approved and fee payment confirmed before student registration can be completed." %>
                </p>
            </div>

            <div class="status-body">
                <div class="roadmap-box">
                    <div class="roadmap-title">
                        <i class="fa-solid fa-circle-info" style="color: var(--danger);"></i>
                        Admission Workflow Checklist:
                    </div>
                    <ul style="font-size: 13.5px; color: var(--text-muted); line-height: 1.8; margin-left: 20px;">
                        <li>Step 1: Submit Admission Request to your chosen College.</li>
                        <li>Step 2: Wait for College Admin approval and fee determination.</li>
                        <li>Step 3: Pay the admission fee online to confirm your admission.</li>
                        <li>Step 4: Complete your Student Registration.</li>
                    </ul>
                </div>

                <div class="status-actions">
                    <a href="new_student_check_status.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-magnifying-glass"></i> Check Admission Status
                    </a>
                    <a href="student_login.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-right-to-bracket"></i> Student Login
                    </a>
                    <a href="new_student_colleges.jsp" class="btn btn-secondary">
                        <i class="fa-solid fa-building-columns"></i> Browse Colleges
                    </a>
                </div>
            </div>

        <% } %>

    </div>

</div>

<!-- FOOTER -->
<footer class="footer">
    CampusConnect | Campus Recruitment & Academic Management System
</footer>

<script>
function copyStudentId() {
    const el = document.getElementById('studentIdValue');
    if (!el) return;
    const text = el.innerText.replace('#', '').trim();
    navigator.clipboard.writeText(text).then(() => {
        alert('Student ID ' + text + ' copied to clipboard!');
    }).catch(() => {
        alert('Student ID: ' + text);
    });
}
</script>

</body>
</html>
