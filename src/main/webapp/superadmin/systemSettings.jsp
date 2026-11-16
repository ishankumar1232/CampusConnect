<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.SuperAdmin" %>
<%@ page import="com.campusconnect.bean.SystemSetting" %>
<%
    SuperAdmin admin = (SuperAdmin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
        return;
    }

    SystemSetting setting = (SystemSetting) request.getAttribute("setting");
    if (setting == null) {
        com.campusconnect.dao.SystemSettingDAO dao = new com.campusconnect.dao.SystemSettingDAO();
        setting = dao.getSystemSettings();
        if (setting == null) {
            setting = new SystemSetting();
        }
    }

    boolean isStudentReg = "ON".equalsIgnoreCase(setting.getStudentRegistration());
    boolean isCollegeReg = "ON".equalsIgnoreCase(setting.getCollegeRegistration());
    boolean isCompanyReg = "ON".equalsIgnoreCase(setting.getCompanyRegistration());
    boolean isAdmReq = "ON".equalsIgnoreCase(setting.getAdmissionRequest());
    boolean isRecDrv = "ON".equalsIgnoreCase(setting.getRecruitmentDrive());
    boolean isMaint = "ON".equalsIgnoreCase(setting.getMaintenanceMode());

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings | CampusConnect</title>
    <!-- Google Fonts & FontAwesome -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/superadmin-dashboard.css">
    <style>
        .settings-grid-compact {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .setting-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 18px 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            transition: all 0.2s ease;
        }
        .setting-card:hover {
            border-color: #cbd5e1;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.04);
        }
        .setting-card.danger {
            background: #fffcfc;
            border-color: #fecaca;
        }
        .setting-card.danger:hover {
            border-color: #fca5a5;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.08);
        }
        .setting-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .setting-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: grid;
            place-items: center;
            font-size: 17px;
            flex-shrink: 0;
            background: #eff6ff;
            color: #2563eb;
        }
        .setting-card.danger .setting-icon {
            background: #fef2f2;
            color: #dc2626;
        }
        .setting-titles h4 {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            margin: 0 0 2px 0;
        }
        .setting-titles p {
            font-size: 13px;
            color: #64748b;
            margin: 0;
        }
        .setting-card.danger .setting-titles p {
            color: #b91c1c;
        }
        .setting-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .status-label {
            font-size: 12px;
            font-weight: 700;
            min-width: 32px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-label.on {
            color: #10b981;
        }
        .status-label.off {
            color: #94a3b8;
        }
        .status-label.danger-on {
            color: #ef4444;
        }
        /* Modern Switch Slider */
        .switch {
            position: relative;
            display: inline-block;
            width: 52px;
            height: 28px;
            flex-shrink: 0;
        }
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #cbd5e1;
            transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 34px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 50%;
            box-shadow: 0 2px 4px rgba(0,0,0,0.15);
        }
        input:checked + .slider {
            background-color: #10b981;
        }
        input:checked + .slider:before {
            transform: translateX(24px);
        }
        .danger-switch input:checked + .slider {
            background-color: #ef4444;
        }
    </style>
</head>
<body>
    <% request.setAttribute("activeNav", "settings"); %>
    <%@ include file="superAdminNav.jsp" %>

    <main class="main">
        <!-- Clean, Minimalist Header -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; flex-wrap: wrap; gap: 12px;">
            <div>
                <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; margin-bottom: 4px;">System Settings</h1>
                <p style="font-size: 14px; color: #64748b; margin: 0;">Configure platform access and module feature toggles.</p>
            </div>
            <div>
                <span class="badge <%=isMaint ? "badge-danger" : "badge-success"%>" style="padding: 6px 14px; font-size: 12px;">
                    <i class="fa-solid <%=isMaint ? "fa-triangle-exclamation" : "fa-shield-halved"%>"></i>
                    <%=isMaint ? "Maintenance Mode Active" : "All Systems Operational"%>
                </span>
            </div>
        </div>

        <% if (msg != null && "updated".equalsIgnoreCase(msg)) { %>
            <div class="alert alert-success" style="margin-bottom: 20px;">
                <i class="fa-solid fa-circle-check"></i>
                Settings saved successfully!
            </div>
        <% } %>

        <form action="<%=request.getContextPath()%>/SystemSettingsServlet" method="post">
            <div class="settings-grid-compact">
                <!-- 1. Student Registration -->
                <div class="setting-card">
                    <div class="setting-left">
                        <div class="setting-icon">
                            <i class="fa-solid fa-user-graduate"></i>
                        </div>
                        <div class="setting-titles">
                            <h4>Student Registration</h4>
                            <p>Allow new student account signups</p>
                        </div>
                    </div>
                    <div class="setting-right">
                        <span id="lblStudent" class="status-label <%=isStudentReg ? "on" : "off"%>">
                            <%=isStudentReg ? "ON" : "OFF"%>
                        </span>
                        <label class="switch">
                            <input type="checkbox" <%=isStudentReg ? "checked" : ""%> onchange="toggleSetting('Student', this, 'hiddenStudent')">
                            <span class="slider"></span>
                        </label>
                        <input type="hidden" name="studentRegistration" id="hiddenStudent" value="<%=isStudentReg ? "ON" : "OFF"%>">
                    </div>
                </div>

                <!-- 2. College Registration -->
                <div class="setting-card">
                    <div class="setting-left">
                        <div class="setting-icon" style="background:#eef2ff; color:#4f46e5;">
                            <i class="fa-solid fa-building-columns"></i>
                        </div>
                        <div class="setting-titles">
                            <h4>College Registration</h4>
                            <p>Allow new college onboarding</p>
                        </div>
                    </div>
                    <div class="setting-right">
                        <span id="lblCollege" class="status-label <%=isCollegeReg ? "on" : "off"%>">
                            <%=isCollegeReg ? "ON" : "OFF"%>
                        </span>
                        <label class="switch">
                            <input type="checkbox" <%=isCollegeReg ? "checked" : ""%> onchange="toggleSetting('College', this, 'hiddenCollege')">
                            <span class="slider"></span>
                        </label>
                        <input type="hidden" name="collegeRegistration" id="hiddenCollege" value="<%=isCollegeReg ? "ON" : "OFF"%>">
                    </div>
                </div>

                <!-- 3. Company Registration -->
                <div class="setting-card">
                    <div class="setting-left">
                        <div class="setting-icon" style="background:#ecfdf5; color:#059669;">
                            <i class="fa-solid fa-building"></i>
                        </div>
                        <div class="setting-titles">
                            <h4>Company Registration</h4>
                            <p>Allow new recruiter signups</p>
                        </div>
                    </div>
                    <div class="setting-right">
                        <span id="lblCompany" class="status-label <%=isCompanyReg ? "on" : "off"%>">
                            <%=isCompanyReg ? "ON" : "OFF"%>
                        </span>
                        <label class="switch">
                            <input type="checkbox" <%=isCompanyReg ? "checked" : ""%> onchange="toggleSetting('Company', this, 'hiddenCompany')">
                            <span class="slider"></span>
                        </label>
                        <input type="hidden" name="companyRegistration" id="hiddenCompany" value="<%=isCompanyReg ? "ON" : "OFF"%>">
                    </div>
                </div>

                <!-- 4. Admission Requests -->
                <div class="setting-card">
                    <div class="setting-left">
                        <div class="setting-icon" style="background:#fff7ed; color:#ea580c;">
                            <i class="fa-solid fa-file-signature"></i>
                        </div>
                        <div class="setting-titles">
                            <h4>Admission Requests</h4>
                            <p>Allow student admission applications</p>
                        </div>
                    </div>
                    <div class="setting-right">
                        <span id="lblAdm" class="status-label <%=isAdmReq ? "on" : "off"%>">
                            <%=isAdmReq ? "ON" : "OFF"%>
                        </span>
                        <label class="switch">
                            <input type="checkbox" <%=isAdmReq ? "checked" : ""%> onchange="toggleSetting('Adm', this, 'hiddenAdm')">
                            <span class="slider"></span>
                        </label>
                        <input type="hidden" name="admissionRequest" id="hiddenAdm" value="<%=isAdmReq ? "ON" : "OFF"%>">
                    </div>
                </div>

                <!-- 5. Recruitment Drives -->
                <div class="setting-card">
                    <div class="setting-left">
                        <div class="setting-icon" style="background:#faf5ff; color:#9333ea;">
                            <i class="fa-solid fa-bullhorn"></i>
                        </div>
                        <div class="setting-titles">
                            <h4>Recruitment Drives</h4>
                            <p>Allow job postings and applications</p>
                        </div>
                    </div>
                    <div class="setting-right">
                        <span id="lblDrive" class="status-label <%=isRecDrv ? "on" : "off"%>">
                            <%=isRecDrv ? "ON" : "OFF"%>
                        </span>
                        <label class="switch">
                            <input type="checkbox" <%=isRecDrv ? "checked" : ""%> onchange="toggleSetting('Drive', this, 'hiddenDrive')">
                            <span class="slider"></span>
                        </label>
                        <input type="hidden" name="recruitmentDrive" id="hiddenDrive" value="<%=isRecDrv ? "ON" : "OFF"%>">
                    </div>
                </div>

                <!-- 6. Maintenance Mode -->
                <div class="setting-card danger">
                    <div class="setting-left">
                        <div class="setting-icon">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>
                        <div class="setting-titles">
                            <h4 style="color: #991b1b;">Maintenance Mode</h4>
                            <p>Lock platform for non-admin users</p>
                        </div>
                    </div>
                    <div class="setting-right">
                        <span id="lblMaint" class="status-label <%=isMaint ? "danger-on" : "off"%>">
                            <%=isMaint ? "ON" : "OFF"%>
                        </span>
                        <label class="switch danger-switch">
                            <input type="checkbox" <%=isMaint ? "checked" : ""%> onchange="toggleSetting('Maint', this, 'hiddenMaint', true)">
                            <span class="slider"></span>
                        </label>
                        <input type="hidden" name="maintenanceMode" id="hiddenMaint" value="<%=isMaint ? "ON" : "OFF"%>">
                    </div>
                </div>
            </div>

            <!-- Clean Bottom Action Bar -->
            <div style="display: flex; justify-content: flex-end; gap: 12px; padding-top: 18px; border-top: 1px solid #e2e8f0;">
                <a href="<%=request.getContextPath()%>/SystemSettingsServlet" class="btn btn-outline">
                    <i class="fa-solid fa-rotate-left"></i> Reset
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk"></i> Save Settings
                </button>
            </div>
        </form>

        <footer class="footer">
            CampusConnect Platform &bull; Super Administrator Central Control Center &bull; All rights reserved.
        </footer>
    </main>

    <script>
    function toggleSetting(key, checkbox, hiddenId, isDanger) {
        var hiddenInput = document.getElementById(hiddenId);
        var label = document.getElementById('lbl' + key);
        if (checkbox.checked) {
            hiddenInput.value = 'ON';
            label.innerText = 'ON';
            label.className = isDanger ? 'status-label danger-on' : 'status-label on';
        } else {
            hiddenInput.value = 'OFF';
            label.innerText = 'OFF';
            label.className = 'status-label off';
        }
    }
    </script>
</body>
</html>
