<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String h(Object value) {
        if (value == null) return "";
        String s = String.valueOf(value);
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }
%>
<%
    Integer companyId = (Integer) session.getAttribute("companyId");
    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }
    String companyName = (String) session.getAttribute("companyName");
    String email = (String) session.getAttribute("email");
    if (companyName == null || companyName.trim().length() == 0) companyName = "Company";
    if (email == null) email = "";
    com.campusconnect.bean.Company company =
            new com.campusconnect.bean.Company();
    company.setCompanyId(companyId);

    String companyLogo = null;
    if (company.SelectMethod()) {
        companyLogo = company.getLogoUrl();
    }

    if (companyLogo != null) {
        companyLogo = companyLogo.trim();
    }

    boolean useNameBasedFallback =
            companyLogo == null || companyLogo.isEmpty();

    if (!useNameBasedFallback) {
        String normalizedLogoPath = companyLogo
                .replace('\\', '/')
                .toLowerCase(java.util.Locale.ROOT);
        useNameBasedFallback =
                normalizedLogoPath.equals("images/company/tcs-logo.png") ||
                normalizedLogoPath.endsWith("/images/company/tcs-logo.png");
    }

    if (useNameBasedFallback) {
        String companyLogoName = companyName.trim()
                .toLowerCase(java.util.Locale.ROOT);

        if (companyLogoName.contains("infosys")) {
            companyLogo = "images/company/infosys-logo.png";
        } else if (companyLogoName.contains("google")) {
            companyLogo = "images/company/google-logo.png";
        } else if (companyLogoName.contains("tcs") ||
                companyLogoName.contains("tata consultancy")) {
            companyLogo = "images/company/tcs-logo.png";
        } else {
            companyLogo = "images/company/tcs-logo.png";
        }
    }

    // Prefix application-relative paths with the current web context.
    // Leave absolute HTTP(S) and scheme-relative URLs unchanged.
    if (!companyLogo.matches("(?i)^(https?:)?//.*$")) {
        String contextPath = request.getContextPath();

        if (!companyLogo.equals(contextPath) &&
                !companyLogo.startsWith(contextPath + "/")) {
            if (companyLogo.startsWith("/")) {
                companyLogo = contextPath + companyLogo;
            } else {
                companyLogo = contextPath + "/" + companyLogo;
            }
        }
    }
    String companyInitial = companyName.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= h(companyName) %> Settings | CampusConnect</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="css/company-dashboard.css?v=10">
    <style>
        .settings-topbar{box-sizing:border-box;min-height:178px;padding:34px 4%;display:flex;align-items:center;justify-content:space-between;gap:28px;background:#fff;border-bottom:1px solid #e3eaf3}
        .settings-topbar h1{margin:0;color:#073665;font-size:44px;line-height:1.15;font-weight:700}
        .settings-topbar p{margin:9px 0 0;color:#7187a3;font-size:20px;line-height:1.45}
        .dashboard-link{display:inline-flex;align-items:center;gap:9px;padding:12px 17px;border:1px solid #d9e5f5;border-radius:9px;background:#f8fbff;color:#1769c2;text-decoration:none;font-size:16px;font-weight:600;white-space:nowrap;transition:background .2s,border-color .2s}
        .dashboard-link:hover{background:#edf5ff;border-color:#b9d3f4}
        .settings-body{box-sizing:border-box;width:100%;min-height:calc(100vh - 178px);padding:34px clamp(22px,2.1vw,40px) 52px;background:#f3f6fb}
        .settings-intro{display:flex;align-items:flex-end;justify-content:space-between;gap:18px;margin-bottom:22px;flex-wrap:wrap}.settings-intro h2{margin:0;color:#073665;font-size:29px}.settings-intro p{margin:7px 0 0;color:#7187a3;font-size:16px}
        .settings-layout{display:grid;grid-template-columns:minmax(0,1.15fr) minmax(340px,.85fr);gap:20px;align-items:start}
        .settings-column{display:grid;gap:20px}.settings-card{background:#fff;border:1px solid #e2eaf4;border-radius:15px;box-shadow:0 8px 24px rgba(28,55,90,.045);overflow:hidden}.settings-card-head{display:flex;align-items:flex-start;gap:14px;padding:22px 23px 18px;border-bottom:1px solid #eef2f7}.settings-card-icon{width:42px;height:42px;flex:0 0 42px;border-radius:12px;display:grid;place-items:center;background:#edf3ff;color:#2864d9;font-size:17px}.settings-card-icon.green{background:#e8f7ef;color:#16854e}.settings-card-icon.amber{background:#fff4df;color:#c98400}.settings-card-head h3{margin:1px 0 5px;color:#123c6b;font-size:18px}.settings-card-head p{margin:0;color:#8291a6;font-size:13px;line-height:1.5}
        .account-content{padding:22px 23px}.account-banner{display:flex;align-items:center;gap:15px;padding:17px;border-radius:12px;background:linear-gradient(110deg,#f0f6ff,#f7faff);margin-bottom:18px}.account-mark{width:68px;height:68px;flex:0 0 68px;display:grid;place-items:center;border-radius:15px;background:#fff;border:1px solid #e8eef6;overflow:hidden}.account-mark img{display:block;width:100%;height:100%;padding:8px;object-fit:contain}.account-avatar{width:54px;height:54px;display:grid;place-items:center;border-radius:16px;background:linear-gradient(135deg,#328af0,#2259ce);color:#fff;font-size:22px;font-weight:700;box-shadow:0 7px 15px rgba(43,108,210,.2)}.account-banner strong{display:block;color:#173e68;font-size:17px}.account-banner span{display:block;margin-top:4px;color:#73859f;font-size:13px}.account-fields{display:grid;grid-template-columns:1fr 1fr;gap:14px}.account-field{padding:13px 14px;border:1px solid #edf1f6;border-radius:10px}.account-field span{display:block;margin-bottom:6px;color:#8a97aa;font-size:11px;text-transform:uppercase;letter-spacing:.06em;font-weight:700}.account-field strong{display:block;color:#304967;font-size:14px;overflow-wrap:anywhere}
        .settings-actions{display:flex;align-items:center;justify-content:space-between;gap:15px;padding:17px 23px;border-top:1px solid #eef2f7}.settings-note{color:#8a97aa;font-size:12px;line-height:1.45}.primary-link,.secondary-link{display:inline-flex;align-items:center;justify-content:center;gap:8px;min-height:40px;padding:0 14px;border-radius:9px;text-decoration:none;font-size:13px;font-weight:700;white-space:nowrap}.primary-link{background:#2867d8;color:#fff;box-shadow:0 4px 10px rgba(40,103,216,.15)}.primary-link:hover{background:#1c56c0}.secondary-link{border:1px solid #dce6f3;background:#fff;color:#2867c9}.secondary-link:hover{background:#f5f9ff}
        .preference-list{padding:6px 23px}.preference-row{display:flex;align-items:center;justify-content:space-between;gap:18px;padding:17px 0;border-bottom:1px solid #eef2f7}.preference-row:last-child{border-bottom:0}.preference-copy strong{display:block;color:#304967;font-size:14px}.preference-copy span{display:block;margin-top:5px;color:#8492a6;font-size:12px;line-height:1.45}.toggle{position:relative;display:inline-block;width:44px;height:25px;flex:0 0 44px}.toggle input{position:absolute;opacity:0;width:1px;height:1px}.toggle-track{position:absolute;inset:0;border-radius:20px;background:#d8e0eb;cursor:pointer;transition:background .2s}.toggle-track:before{content:"";position:absolute;width:19px;height:19px;top:3px;left:3px;background:#fff;border-radius:50%;box-shadow:0 1px 4px rgba(22,40,62,.2);transition:transform .2s}.toggle input:checked+.toggle-track{background:#2870df}.toggle input:checked+.toggle-track:before{transform:translateX(19px)}.toggle input:focus-visible+.toggle-track{outline:3px solid rgba(40,112,223,.25);outline-offset:2px}
        .saved-indicator{display:inline-flex;align-items:center;gap:7px;color:#16854e;font-size:12px;font-weight:700;opacity:0;transition:opacity .2s}.saved-indicator.visible{opacity:1}.preferences-foot{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 23px;border-top:1px solid #eef2f7;background:#fbfcfe}.preferences-foot p{margin:0;color:#8a97aa;font-size:11px;line-height:1.5}
        .shortcut-list{padding:7px 20px}.shortcut{display:flex;align-items:center;gap:13px;padding:15px 4px;border-bottom:1px solid #eef2f7;text-decoration:none}.shortcut:last-child{border-bottom:0}.shortcut-icon{width:36px;height:36px;flex:0 0 36px;border-radius:10px;display:grid;place-items:center;background:#f1f5fb;color:#52718f}.shortcut-copy{flex:1;min-width:0}.shortcut-copy strong{display:block;color:#304967;font-size:13px}.shortcut-copy span{display:block;margin-top:4px;color:#8996a8;font-size:11px;line-height:1.4}.shortcut>i{color:#a0adbd;font-size:12px}.shortcut:hover .shortcut-icon{background:#edf4ff;color:#2867c9}.shortcut:hover .shortcut-copy strong{color:#2867c9}
        .security-callout{padding:18px 21px;border-radius:12px;background:#f7f9fc;border:1px solid #edf1f6;display:flex;gap:12px;align-items:flex-start}.security-callout>i{color:#7188a2;margin-top:2px}.security-callout strong{display:block;color:#304967;font-size:13px}.security-callout p{margin:5px 0 0;color:#8391a6;font-size:12px;line-height:1.5}.logout-link{color:#d14d53}
        @media(max-width:1000px){.settings-layout{grid-template-columns:1fr}}
        @media(max-width:700px){.settings-topbar{min-height:150px;padding:28px 22px;align-items:flex-start;flex-direction:column;justify-content:center;gap:14px}.settings-topbar h1{font-size:34px}.settings-topbar p{font-size:16px}.settings-body{padding:25px 16px 38px}.settings-intro h2{font-size:25px}.settings-card-head,.account-content{padding-left:17px;padding-right:17px}.settings-actions,.preferences-foot{padding-left:17px;padding-right:17px}.preference-list{padding-left:17px;padding-right:17px}.account-fields{grid-template-columns:1fr}.settings-actions{align-items:flex-start;flex-direction:column}}
    </style>
</head>
<body>
<div class="dashboard-wrapper">
    <aside class="sidebar">
        <div class="sidebar-logo"><div class="brand-name">Campus<span>Connect</span></div><div class="brand-subtitle">COMPANY PORTAL</div></div>
        <div class="sidebar-content">
            <div class="menu-section-title">OVERVIEW</div>
            <a href="company-dashboard.jsp" class="menu-item"><i class="fa-solid fa-house"></i><span>Dashboard</span></a>
            <a href="company-profile.jsp" class="menu-item"><i class="fa-solid fa-building"></i><span>Company Profile</span></a>
            <div class="menu-section-title">RECRUITMENT</div>
            <a href="recruitment-drive.jsp" class="menu-item"><i class="fa-solid fa-plus"></i><span>Create Drive</span></a>
            <a href="view-recruitment-drives.jsp" class="menu-item"><i class="fa-solid fa-briefcase"></i><span>Recruitment Drives</span></a>
            <a href="company-applicants.jsp" class="menu-item"><i class="fa-solid fa-users"></i><span>Applicants</span></a>
            <a href="company-shortlisted.jsp" class="menu-item"><i class="fa-solid fa-star"></i><span>Shortlisted Candidates</span></a>
            <a href="company-interviews.jsp" class="menu-item"><i class="fa-regular fa-square"></i><span>Interviews</span></a>
            <a href="company-offers.jsp" class="menu-item"><i class="fa-regular fa-gem"></i><span>Offers &amp; Selections</span></a>
            <div class="menu-section-title">ANALYTICS</div>
            <a href="company-reports.jsp" class="menu-item"><i class="fa-solid fa-chart-column"></i><span>Reports &amp; Analytics</span></a>
            <a href="company-analytics.jsp" class="menu-item"><i class="fa-solid fa-chart-line"></i><span>Analytics Insights</span></a>
        </div>
        <div class="sidebar-bottom">
            <a href="company-settings.jsp" class="menu-item active"><i class="fa-solid fa-gear"></i><span>Settings</span></a>
            <a href="CompanyLogoutServlet" class="menu-item logout"><i class="fa-solid fa-right-from-bracket"></i><span>Logout</span></a>
        </div>
    </aside>
    <main class="main-content">
        <header class="settings-topbar">
            <div><h1>Settings</h1><p>Manage your company account and portal preferences.</p></div>
            <a class="dashboard-link" href="company-dashboard.jsp"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
        </header>
        <div class="settings-body">
            <div class="settings-intro"><div><h2>Account settings</h2><p>Review your account information and personalize your portal experience.</p></div><span class="saved-indicator" id="savedIndicator"><i class="fa-solid fa-circle-check"></i> Preferences saved</span></div>
            <div class="settings-layout">
                <div class="settings-column">
                    <section class="settings-card">
                        <div class="settings-card-head"><div class="settings-card-icon"><i class="fa-solid fa-building"></i></div><div><h3>Company account</h3><p>Your signed-in company account details.</p></div></div>
                        <div class="account-content">
                            <div class="account-banner"><div class="account-mark"><% if (companyLogo != null) { %><img src="<%= h(companyLogo) %>" alt="<%= h(companyName) %> logo" onerror="this.style.display='none';this.nextElementSibling.style.display='grid';"><span class="account-avatar" style="display:none"><%= h(companyInitial) %></span><% } else { %><span class="account-avatar"><%= h(companyInitial) %></span><% } %></div><div><strong><%= h(companyName) %></strong><span>Company portal account</span></div></div>
                            <div class="account-fields"><div class="account-field"><span>Company name</span><strong><%= h(companyName) %></strong></div><div class="account-field"><span>Account email</span><strong><%= h(email) %></strong></div></div>
                        </div>
                        <div class="settings-actions"><span class="settings-note">Update company details and contact information from your profile.</span><a href="company-profile.jsp" class="primary-link"><i class="fa-solid fa-arrow-up-right-from-square"></i> Manage company profile</a></div>
                    </section>
                    <section class="settings-card">
                        <div class="settings-card-head"><div class="settings-card-icon green"><i class="fa-regular fa-bell"></i></div><div><h3>Portal preferences</h3><p>Choose which activity reminders you want to see in this browser.</p></div></div>
                        <div class="preference-list">
                            <div class="preference-row"><div class="preference-copy"><strong>Application activity updates</strong><span>Your preference for updates about applicant activity.</span></div><label class="toggle"><input type="checkbox" data-preference="applicationActivity" aria-label="Application activity updates preference"><span class="toggle-track"></span></label></div>
                            <div class="preference-row"><div class="preference-copy"><strong>Offer activity updates</strong><span>Your preference for updates about offer status changes.</span></div><label class="toggle"><input type="checkbox" data-preference="offerActivity" aria-label="Offer activity updates preference"><span class="toggle-track"></span></label></div>
                            <div class="preference-row"><div class="preference-copy"><strong>Weekly hiring summary</strong><span>Your preference for a weekly overview of recruitment activity.</span></div><label class="toggle"><input type="checkbox" data-preference="weeklySummary" aria-label="Weekly hiring summary preference"><span class="toggle-track"></span></label></div>
                        </div>
                        <div class="preferences-foot"><p>Preferences are saved in this browser. Notification or email delivery requires server-side integration.</p><button type="button" class="secondary-link" id="resetPreferences">Reset preferences</button></div>
                    </section>
                </div>
                <div class="settings-column">
                    <section class="settings-card">
                        <div class="settings-card-head"><div class="settings-card-icon amber"><i class="fa-solid fa-sliders"></i></div><div><h3>Quick settings</h3><p>Jump to the company portal area you want to manage.</p></div></div>
                        <div class="shortcut-list">
                            <a class="shortcut" href="company-profile.jsp"><span class="shortcut-icon"><i class="fa-solid fa-address-card"></i></span><span class="shortcut-copy"><strong>Company profile</strong><span>Company details and public-facing information</span></span><i class="fa-solid fa-chevron-right"></i></a>
                            <a class="shortcut" href="view-recruitment-drives.jsp"><span class="shortcut-icon"><i class="fa-solid fa-briefcase"></i></span><span class="shortcut-copy"><strong>Recruitment drives</strong><span>Review your posted roles and drive activity</span></span><i class="fa-solid fa-chevron-right"></i></a>
                            <a class="shortcut" href="company-offers.jsp"><span class="shortcut-icon"><i class="fa-regular fa-gem"></i></span><span class="shortcut-copy"><strong>Offers &amp; selections</strong><span>Manage candidate offers and responses</span></span><i class="fa-solid fa-chevron-right"></i></a>
                            <a class="shortcut" href="company-reports.jsp"><span class="shortcut-icon"><i class="fa-solid fa-chart-column"></i></span><span class="shortcut-copy"><strong>Reports &amp; analytics</strong><span>Export and review recruitment reports</span></span><i class="fa-solid fa-chevron-right"></i></a>
                        </div>
                    </section>
                    <section class="settings-card">
                        <div class="settings-card-head"><div class="settings-card-icon"><i class="fa-solid fa-shield-halved"></i></div><div><h3>Access &amp; security</h3><p>Information about your current portal session.</p></div></div>
                        <div class="account-content">
                            <div class="security-callout"><i class="fa-solid fa-lock"></i><div><strong>Signed in as <%= h(email.length() == 0 ? companyName : email) %></strong><p>Your company account is active in this browser. Use logout when you have finished working on a shared device.</p></div></div>
                        </div>
                        <div class="settings-actions"><span class="settings-note">End this company portal session.</span><a href="CompanyLogoutServlet" class="secondary-link logout-link"><i class="fa-solid fa-right-from-bracket"></i> Log out</a></div>
                    </section>
                </div>
            </div>
        </div>
    </main>
</div>
<script>
(function () {
    var storageKey = "campusconnect.companySettings.<%= companyId %>";
    var controls = document.querySelectorAll("[data-preference]");
    var indicator = document.getElementById("savedIndicator");
    var resetButton = document.getElementById("resetPreferences");
    var hideTimer;

    function readPreferences() {
        try { return JSON.parse(window.localStorage.getItem(storageKey) || "{}"); }
        catch (e) { return {}; }
    }
    function savePreferences() {
        var preferences = {};
        controls.forEach(function (control) { preferences[control.getAttribute("data-preference")] = control.checked; });
        try { window.localStorage.setItem(storageKey, JSON.stringify(preferences)); } catch (e) { }
        indicator.classList.add("visible");
        window.clearTimeout(hideTimer);
        hideTimer = window.setTimeout(function () { indicator.classList.remove("visible"); }, 2200);
    }
    var initial = readPreferences();
    controls.forEach(function (control) {
        var key = control.getAttribute("data-preference");
        control.checked = Object.prototype.hasOwnProperty.call(initial, key) ? initial[key] === true : true;
        control.addEventListener("change", savePreferences);
    });
    resetButton.addEventListener("click", function () {
        try { window.localStorage.removeItem(storageKey); } catch (e) { }
        controls.forEach(function (control) { control.checked = true; });
        savePreferences();
    });
}());
</script>
</body>
</html>
