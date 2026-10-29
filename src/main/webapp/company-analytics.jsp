<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.util.ArrayList,java.util.LinkedHashMap,java.util.List,java.util.Locale,java.util.Map,com.campusconnect.util.DBConnection" %>
<%!
    private String h(Object value) {
        if (value == null) return "";
        String s = String.valueOf(value);
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }
    private String label(String value) {
        return value == null || value.trim().length() == 0 ? "(Not set)" : value;
    }
    private int percent(int value, int total) {
        if (total <= 0 || value <= 0) return 0;
        return Math.min(100, (int) Math.round((value * 100.0) / total));
    }
    private String donutChart(String title, Map<String, Integer> values) {
        String[] colors = {"#3478e5", "#11a891", "#f2ad35", "#8c68dc", "#e66d79", "#36a3d9", "#78b94c", "#ed8c3b"};
        int total = 0;
        for (Integer value : values.values()) total += value.intValue();
        StringBuilder html = new StringBuilder();
        html.append("<article class='donut-card'><h3>").append(h(title)).append("</h3>");
        if (total == 0) {
            boolean offerChart = "Offer status".equals(title);
            html.append("<div class='empty-chart'><span class='empty-chart-icon'><i class='")
                    .append(offerChart ? "fa-regular fa-gem" : "fa-solid fa-users")
                    .append("'></i></span><strong>").append(offerChart ? "No offers issued yet" : "No applications to analyze yet")
                    .append("</strong><p>").append(offerChart ? "Offer status insights will appear here after your first offer." : "Status distribution will appear here when applications arrive.")
                    .append("</p><a href='").append(offerChart ? "company-offers.jsp" : "company-applicants.jsp").append("'>")
                    .append(offerChart ? "Go to offers" : "View applicants").append(" <i class='fa-solid fa-arrow-right'></i></a></div></article>");
            return html.toString();
        }
        double circumference = 251.327;
        double offset = 0;
        int index = 0;
        html.append("<div class='donut-content'><div class='donut-visual'><svg viewBox='0 0 100 100' role='img' aria-label='").append(h(title)).append(" status chart'><g transform='rotate(-90 50 50)'><circle cx='50' cy='50' r='40' fill='none' stroke='#edf2f8' stroke-width='13'/>");
        for (Map.Entry<String, Integer> entry : values.entrySet()) {
            double arc = circumference * entry.getValue().intValue() / total;
            String color = colors[index % colors.length];
            html.append("<circle cx='50' cy='50' r='40' fill='none' stroke='").append(color)
                    .append("' stroke-width='13' stroke-dasharray='")
                    .append(String.format(Locale.US, "%.3f %.3f", arc, circumference - arc))
                    .append("' stroke-dashoffset='").append(String.format(Locale.US, "%.3f", -offset)).append("'/>");
            offset += arc;
            index++;
        }
        html.append("</g></svg><div class='donut-center'><strong>").append(total).append("</strong><span>Total</span></div></div><div class='donut-legend'>");
        index = 0;
        for (Map.Entry<String, Integer> entry : values.entrySet()) {
            String color = colors[index % colors.length];
            int count = entry.getValue().intValue();
            int share = (int) Math.round(count * 100.0 / total);
            html.append("<div class='legend-row'><span class='legend-label'><i style='background:").append(color)
                    .append("'></i><span>").append(h(entry.getKey())).append("</span></span><strong>")
                    .append(count).append(" <small>").append(share).append("%</small></strong></div>");
            index++;
        }
        html.append("</div></div></article>");
        return html.toString();
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

    int driveTotal = 0;
    int applicationTotal = 0;
    int offerTotal = 0;
    int noApplicationDrives = 0;
    int acceptedOffers = 0;
    boolean loadError = false;
    String errorMessage = "Analytics are temporarily unavailable. Please try again later.";
    List<Map<String, Object>> driveRows = new ArrayList<Map<String, Object>>();
    Map<String, Integer> applicationStatuses = new LinkedHashMap<String, Integer>();
    Map<String, Integer> collegeStatuses = new LinkedHashMap<String, Integer>();
    Map<String, Integer> offerStatuses = new LinkedHashMap<String, Integer>();
    try (Connection connection = DBConnection.getConnection()) {
        try (PreparedStatement ps = connection.prepareStatement("SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ?")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) driveTotal = rs.getInt(1); }
        }
        try (PreparedStatement ps = connection.prepareStatement("SELECT COUNT(*) FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID = A.DRIVE_ID WHERE D.COMPANY_ID = ?")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) applicationTotal = rs.getInt(1); }
        }
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT D.DRIVE_ID, D.JOB_TITLE, D.DRIVE_TYPE, D.STATUS, COUNT(A.APPLICATION_ID) AS APPLICATION_COUNT " +
                "FROM RECRUITMENT_DRIVE D LEFT JOIN APPLICATION A ON A.DRIVE_ID = D.DRIVE_ID " +
                "WHERE D.COMPANY_ID = ? GROUP BY D.DRIVE_ID, D.JOB_TITLE, D.DRIVE_TYPE, D.STATUS ORDER BY COUNT(A.APPLICATION_ID) DESC, D.DRIVE_ID DESC")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<String, Object>();
                    row.put("id", rs.getObject("DRIVE_ID"));
                    row.put("title", rs.getString("JOB_TITLE"));
                    row.put("type", rs.getString("DRIVE_TYPE"));
                    row.put("status", rs.getString("STATUS"));
                    row.put("applications", Integer.valueOf(rs.getInt("APPLICATION_COUNT")));
                    driveRows.add(row);
                    if (rs.getInt("APPLICATION_COUNT") == 0) noApplicationDrives++;
                }
            }
        }
        String[] queries = {
            "SELECT A.STATUS AS STATUS_VALUE, COUNT(*) AS STATUS_COUNT FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID = A.DRIVE_ID WHERE D.COMPANY_ID = ? GROUP BY A.STATUS ORDER BY A.STATUS",
            "SELECT A.COLLEGE_SHORTLIST_STATUS AS STATUS_VALUE, COUNT(*) AS STATUS_COUNT FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID = A.DRIVE_ID WHERE D.COMPANY_ID = ? GROUP BY A.COLLEGE_SHORTLIST_STATUS ORDER BY A.COLLEGE_SHORTLIST_STATUS",
            "SELECT O.OFFER_STATUS AS STATUS_VALUE, COUNT(*) AS STATUS_COUNT FROM OFFER O WHERE O.COMPANY_ID = ? GROUP BY O.OFFER_STATUS ORDER BY O.OFFER_STATUS"
        };
        Map<String, Integer>[] targets = new Map[] { applicationStatuses, collegeStatuses, offerStatuses };
        for (int q = 0; q < queries.length; q++) {
            try (PreparedStatement ps = connection.prepareStatement(queries[q])) {
                ps.setInt(1, companyId.intValue());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) targets[q].put(label(rs.getString("STATUS_VALUE")), Integer.valueOf(rs.getInt("STATUS_COUNT")));
                }
            }
        }
        for (Integer value : offerStatuses.values()) offerTotal += value.intValue();
        Integer acceptedCount = offerStatuses.get("ACCEPTED");
        if (acceptedCount != null) acceptedOffers = acceptedCount.intValue();
    } catch (Exception e) {
        loadError = true;
        driveRows.clear(); applicationStatuses.clear(); collegeStatuses.clear(); offerStatuses.clear();
        driveTotal = 0; applicationTotal = 0; offerTotal = 0; acceptedOffers = 0; noApplicationDrives = 0;
        application.log("Unable to load company analytics for companyId=" + companyId, e);
    }

    int averageApplications = driveTotal == 0 ? 0 : (int) Math.round(applicationTotal / (double) driveTotal);
    int topDriveApplications = driveRows.isEmpty() ? 0 : ((Integer) driveRows.get(0).get("applications")).intValue();
    String topDriveTitle = driveRows.isEmpty() ? "No drives yet" : String.valueOf(driveRows.get(0).get("title"));
    int acceptedPercent = percent(acceptedOffers, offerTotal);
    int maxDriveApplications = 0;
    for (Map<String, Object> drive : driveRows) {
        int count = ((Integer) drive.get("applications")).intValue();
        if (count > maxDriveApplications) maxDriveApplications = count;
    }
    int maxApplicationStatus = 0;
    for (Integer value : applicationStatuses.values()) if (value.intValue() > maxApplicationStatus) maxApplicationStatus = value.intValue();
    int maxCollegeStatus = 0;
    for (Integer value : collegeStatuses.values()) if (value.intValue() > maxCollegeStatus) maxCollegeStatus = value.intValue();
    int maxOfferStatus = 0;
    for (Integer value : offerStatuses.values()) if (value.intValue() > maxOfferStatus) maxOfferStatus = value.intValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= h(companyName) %> Analytics Insights | CampusConnect</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="css/company-dashboard.css?v=10">
    <style>
        .insights-topbar{box-sizing:border-box;min-height:178px;padding:34px 4%;display:flex;align-items:center;justify-content:space-between;gap:28px;background:#fff;border-bottom:1px solid #e3eaf3}
        .insights-topbar h1{margin:0;color:#073665;font-size:44px;line-height:1.15;font-weight:700}
        .insights-topbar p{margin:9px 0 0;color:#7187a3;font-size:20px;line-height:1.45}
        .dashboard-link{display:inline-flex;align-items:center;gap:9px;padding:12px 17px;border:1px solid #d9e5f5;border-radius:9px;background:#f8fbff;color:#1769c2;text-decoration:none;font-size:16px;font-weight:600;white-space:nowrap;transition:background .2s,border-color .2s}
        .dashboard-link:hover{background:#edf5ff;border-color:#b9d3f4}
        .insights-body{box-sizing:border-box;width:100%;padding:34px clamp(22px,2.1vw,40px) 52px;background:#f3f6fb;min-height:calc(100vh - 178px)}
        .insights-intro{display:flex;align-items:flex-end;justify-content:space-between;gap:18px;margin:0 0 22px;flex-wrap:wrap}
        .insights-intro h2{margin:0;color:#073665;font-size:29px}.insights-intro p{margin:7px 0 0;color:#7187a3;font-size:16px}
        .live-label{display:inline-flex;align-items:center;gap:8px;padding:8px 12px;border-radius:20px;background:#eaf7f0;color:#16824c;font-size:13px;font-weight:700}.live-label i{font-size:8px}
        .insight-cards{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin-bottom:22px}
        .insight-card,.insight-panel{background:#fff;border:1px solid #e2eaf4;border-radius:15px;box-shadow:0 8px 24px rgba(28,55,90,.045)}
        .insight-card{padding:20px;min-height:116px;display:flex;align-items:center;gap:15px;transition:transform .18s ease,box-shadow .18s ease}.insight-card:hover,.signal-card:hover,.donut-card:hover{transform:translateY(-2px);box-shadow:0 12px 28px rgba(28,55,90,.08)}.insight-card:nth-child(1){border-top:3px solid #3478e5}.insight-card:nth-child(2){border-top:3px solid #11a891}.insight-card:nth-child(3){border-top:3px solid #f2ad35}.insight-card:nth-child(4){border-top:3px solid #8c68dc}.insight-icon{width:48px;height:48px;flex:0 0 48px;border-radius:14px;display:grid;place-items:center;background:#edf3ff;color:#2864d9;font-size:19px}.insight-icon.teal{background:#e7f8f5;color:#079585}.insight-icon.amber{background:#fff4dd;color:#c98400}.insight-icon.purple{background:#f2edff;color:#7654d6}
        .insight-card strong{display:block;font-size:27px;line-height:1.1;color:#123c6b}.insight-card span{display:block;margin-top:6px;color:#7187a3;font-size:14px}.insight-card .truncate{max-width:210px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
        .insight-columns{display:grid;grid-template-columns:minmax(0,1.4fr) minmax(320px,.9fr);gap:20px;margin-bottom:20px}
        .insight-panel{padding:23px;min-width:0}.insight-panel h3{margin:0;color:#123c6b;font-size:20px;letter-spacing:-.015em}.panel-subtitle{margin:6px 0 19px;color:#8391a6;font-size:13px;line-height:1.5}
        .drive-insight{margin:0 0 19px;padding-bottom:17px;border-bottom:1px solid #eef2f7}.drive-insight:last-child{margin-bottom:0;padding-bottom:0;border-bottom:0}.drive-line{display:flex;justify-content:space-between;align-items:center;gap:14px;margin-bottom:9px;color:#354b67;font-size:14px}.drive-name{min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:600}.drive-count{flex:0 0 auto;font-weight:700;color:#123c6b}.drive-meta{display:flex;align-items:center;gap:9px;margin-top:8px;color:#8a97aa;font-size:12px}.bar-track{height:10px;border-radius:20px;background:#edf2f8;overflow:hidden}.bar-fill{height:100%;border-radius:20px;background:linear-gradient(90deg,#57a2f8,#2864d9);min-width:0;transition:width .5s ease}
        .status-block{margin-bottom:19px}.status-block:last-child{margin-bottom:0}.status-title{display:flex;justify-content:space-between;gap:12px;margin-bottom:8px;color:#354b67;font-size:14px}.status-title strong{color:#123c6b}.status-fill{height:8px;border-radius:20px;background:#16a897}.status-fill.college{background:#8d6ce0}.status-fill.offer{background:#efa92d}
        .donut-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px;margin-bottom:20px}.donut-card{padding:22px;background:#fff;border:1px solid #e2eaf4;border-radius:15px;box-shadow:0 8px 24px rgba(28,55,90,.045);min-width:0;min-height:230px;transition:transform .18s ease,box-shadow .18s ease}.donut-card h3{margin:0 0 17px;color:#123c6b;font-size:18px}.donut-content{display:flex;align-items:center;gap:18px}.donut-visual{position:relative;flex:0 0 130px;width:130px;height:130px}.donut-visual svg{width:100%;height:100%}.donut-center{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;pointer-events:none}.donut-center strong{font-size:25px;color:#123c6b;line-height:1.1}.donut-center span{font-size:11px;color:#8a97aa;margin-top:3px}.donut-legend{min-width:0;flex:1}.legend-row{display:flex;justify-content:space-between;align-items:center;gap:9px;padding:8px 0;border-bottom:1px solid #f0f3f7;color:#455770;font-size:12px}.legend-row:last-child{border-bottom:0}.legend-label{display:flex;align-items:center;gap:8px;min-width:0}.legend-label>span{overflow-wrap:anywhere}.legend-label i{width:9px;height:9px;flex:0 0 9px;border-radius:50%}.legend-row strong{white-space:nowrap;color:#173d68;font-size:12px}.legend-row small{color:#8a97aa;font-weight:500;margin-left:3px}.empty-chart{min-height:160px;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:12px}.empty-chart-icon{display:grid;place-items:center;width:44px;height:44px;margin-bottom:10px;border-radius:13px;background:#f1f5fb;color:#8194ae;font-size:18px}.empty-chart strong{color:#294764;font-size:14px}.empty-chart p{max-width:260px;margin:6px 0 12px;color:#8291a6;font-size:12px;line-height:1.5}.empty-chart a{display:inline-flex;align-items:center;gap:7px;color:#286acb;font-size:12px;font-weight:700;text-decoration:none}.empty-chart a:hover{text-decoration:underline}
        .snapshot-stat{display:flex;align-items:center;justify-content:space-between;gap:15px;padding:15px 0;border-bottom:1px solid #edf1f6;color:#52647c;font-size:14px}.snapshot-stat strong{color:#123c6b;font-size:20px}.snapshot-stat small{font-size:12px;color:#8a97aa;font-weight:500}.snapshot-note{display:flex;gap:9px;align-items:flex-start;margin-top:17px;padding:13px;border-radius:10px;background:#f4f8ff;color:#72839c;font-size:12px;line-height:1.5}.snapshot-note i{margin-top:2px;color:#4382db}
        .signal-list{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:20px}.signal-card{padding:18px;border:1px solid #e2eaf4;border-radius:13px;background:#fff;display:flex;gap:13px;align-items:flex-start;transition:transform .18s ease,box-shadow .18s ease}.signal-icon{width:37px;height:37px;flex:0 0 37px;display:grid;place-items:center;border-radius:11px;background:#eef4ff;color:#3473dd}.signal-icon.warn{background:#fff3df;color:#c98400}.signal-icon.good{background:#e8f7ef;color:#17834c}.signal-card h4{margin:0 0 5px;color:#123c6b;font-size:15px}.signal-card p{margin:0;color:#718198;font-size:13px;line-height:1.55}
        .insight-table-wrap{overflow-x:auto}.insight-table{width:100%;border-collapse:collapse;min-width:600px}.insight-table th,.insight-table td{text-align:left;padding:13px 12px;border-bottom:1px solid #edf1f6;font-size:14px}.insight-table th{background:#f7f9fc;color:#75849a;text-transform:uppercase;letter-spacing:.04em;font-size:12px}.insight-table td{color:#354b67}.insight-table tr:last-child td{border-bottom:0}.pill{display:inline-block;border-radius:20px;padding:5px 10px;background:#eef4ff;color:#2864c8;font-size:12px;font-weight:700}
        .empty-insight{padding:21px;border-radius:11px;background:#f7f9fc;text-align:center;color:#8190a5;font-size:14px}
        .load-alert{padding:14px 16px;margin-bottom:18px;border:1px solid #ffd4cd;border-radius:10px;background:#fff4f2;color:#8c3426}
        @media(max-width:1300px){.donut-grid{grid-template-columns:1fr}.donut-content{justify-content:flex-start}.donut-legend{max-width:450px}}
        @media(max-width:1150px){.insight-cards{grid-template-columns:repeat(2,minmax(0,1fr))}.insight-columns{grid-template-columns:1fr}.signal-list{grid-template-columns:1fr}}
        @media(max-width:700px){.insights-topbar{min-height:150px;padding:28px 22px;align-items:flex-start;flex-direction:column;justify-content:center;gap:14px}.insights-topbar h1{font-size:34px}.insights-topbar p{font-size:16px}.insights-body{padding:25px 16px 38px}.insight-cards{grid-template-columns:1fr}.insight-panel{padding:17px}.insights-intro h2{font-size:25px}.donut-content{align-items:flex-start;flex-direction:column}.donut-visual{align-self:center}}
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
            <a href="company-analytics.jsp" class="menu-item active"><i class="fa-solid fa-chart-line"></i><span>Analytics Insights</span></a>
        </div>
        <div class="sidebar-bottom">
            <a href="company-settings.jsp" class="menu-item"><i class="fa-solid fa-gear"></i><span>Settings</span></a>
            <a href="CompanyLogoutServlet" class="menu-item logout"><i class="fa-solid fa-right-from-bracket"></i><span>Logout</span></a>
        </div>
    </aside>
    <main class="main-content">
        <header class="insights-topbar">
            <div><h1>Analytics Insights</h1><p>Welcome, <%= h(companyName) %>. See patterns across your recruitment activity.</p></div>
            <a class="dashboard-link" href="company-dashboard.jsp"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
        </header>
        <div class="insights-body">
            <div class="insights-intro"><div><h2>Your hiring at a glance</h2><p>Insights update from your current drives, applications and offers.</p></div><span class="live-label"><i class="fa-solid fa-circle"></i> Live data</span></div>
            <% if (loadError) { %><div class="load-alert"><%= h(errorMessage) %></div><% } %>
            <section class="insight-cards">
                <div class="insight-card"><div class="insight-icon"><i class="fa-solid fa-briefcase"></i></div><div><strong><%= driveTotal %></strong><span>Recruitment drives</span></div></div>
                <div class="insight-card"><div class="insight-icon teal"><i class="fa-solid fa-users"></i></div><div><strong><%= applicationTotal %></strong><span>Applications received</span></div></div>
                <div class="insight-card"><div class="insight-icon amber"><i class="fa-solid fa-chart-simple"></i></div><div><strong><%= averageApplications %></strong><span>Avg. applications per drive</span></div></div>
                <div class="insight-card"><div class="insight-icon purple"><i class="fa-regular fa-gem"></i></div><div><strong><%= offerTotal %></strong><span>Offers issued</span></div></div>
            </section>

            <section class="signal-list">
                <article class="signal-card"><div class="signal-icon"><i class="fa-solid fa-arrow-trend-up"></i></div><div><h4>Most applications</h4><p><% if (driveRows.isEmpty()) { %>Create a drive to start seeing application trends.<% } else { %><%= h(topDriveTitle) %> has the most applications so far (<%= topDriveApplications %>).<% } %></p></div></article>
                <article class="signal-card"><div class="signal-icon warn"><i class="fa-regular fa-bell"></i></div><div><h4>Drives with no applications</h4><p><% if (driveTotal == 0) { %>No drives are available to compare yet.<% } else if (noApplicationDrives == 0) { %>Every drive has received at least one application.<% } else { %><%= noApplicationDrives %> of <%= driveTotal %> drives have not received applications yet.<% } %></p></div></article>
                <article class="signal-card"><div class="signal-icon good"><i class="fa-solid fa-circle-check"></i></div><div><h4>Offer acceptance</h4><p><% if (offerTotal == 0) { %>Offer acceptance insights will appear after offers are issued.<% } else { %><%= acceptedPercent %>% of offers are currently marked ACCEPTED (<%= acceptedOffers %> of <%= offerTotal %>).<% } %></p></div></article>
            </section>

            <section class="insight-columns">
                <article class="insight-panel"><h3>Applications by drive</h3><p class="panel-subtitle">Compare application volume across your drives. Bar lengths are scaled to your highest application count.</p>
                    <% if (driveRows.isEmpty()) { %><div class="empty-insight">No recruitment drives yet. Create a drive to begin tracking activity.</div><% } else { for (Map<String, Object> drive : driveRows) { int driveApplications = ((Integer) drive.get("applications")).intValue(); int barWidth = maxDriveApplications == 0 ? 0 : percent(driveApplications, maxDriveApplications); %>
                    <div class="drive-insight"><div class="drive-line"><span class="drive-name"><%= h(drive.get("title")) %></span><span class="drive-count"><%= driveApplications %></span></div><div class="bar-track"><div class="bar-fill" style="width:<%= barWidth %>%"></div></div><div class="drive-meta"><span><%= h(label((String) drive.get("type"))) %></span><span>•</span><span>Drive status: <%= h(label((String) drive.get("status"))) %></span></div></div>
                    <% } } %>
                </article>
                <article class="insight-panel"><h3>Hiring snapshot</h3><p class="panel-subtitle">A quick read on workload and offer outcomes across your company.</p>
                    <div class="snapshot-stat"><span>Applications per drive</span><strong><%= averageApplications %></strong></div>
                    <div class="snapshot-stat"><span>Drives without applications</span><strong><%= noApplicationDrives %> <small>of <%= driveTotal %></small></strong></div>
                    <div class="snapshot-stat"><span>Accepted offers</span><strong><%= acceptedOffers %> <small>of <%= offerTotal %></small></strong></div>
                    <div class="snapshot-note"><i class="fa-solid fa-circle-info"></i> Application status and college shortlist status are reported as separate measures below.</div>
                </article>
            </section>

            <section class="donut-grid">
                <%= donutChart("Company application status", applicationStatuses) %>
                <%= donutChart("College shortlist status", collegeStatuses) %>
                <%= donutChart("Offer status", offerStatuses) %>
            </section>

            <section class="insight-panel"><h3>Drive activity</h3><p class="panel-subtitle">A sortable overview of application activity for each drive.</p><div class="insight-table-wrap"><table class="insight-table"><thead><tr><th>Drive</th><th>Type</th><th>Drive status</th><th>Applications</th><th>Activity</th></tr></thead><tbody>
                <% if (driveRows.isEmpty()) { %><tr><td colspan="5"><div class="empty-insight">No drives to show.</div></td></tr><% } else { for (Map<String, Object> drive : driveRows) { int count = ((Integer) drive.get("applications")).intValue(); %>
                <tr><td><%= h(drive.get("title")) %></td><td><%= h(label((String) drive.get("type"))) %></td><td><%= h(label((String) drive.get("status"))) %></td><td><strong><%= count %></strong></td><td><span class="pill"><%= count == 0 ? "Awaiting applications" : "Receiving applications" %></span></td></tr>
                <% } } %>
            </tbody></table></div></section>
        </div>
    </main>
</div>
</body>
</html>
