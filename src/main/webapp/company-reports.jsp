<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.sql.SQLException,java.util.ArrayList,java.util.LinkedHashMap,java.util.List,java.util.Map,com.campusconnect.util.DBConnection" %>
<%!
    private String h(Object value) {
        if (value == null) return "";
        String s = String.valueOf(value);
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }

    private String csv(Object value) {
        String s = value == null ? "" : String.valueOf(value);
        return "\"" + s.replace("\"", "\"\"") + "\"";
    }

    private String displayStatus(String value) {
        if (value == null || value.trim().length() == 0) return "(Not set)";
        return value;
    }

    private String pdfText(String value) {
        StringBuilder safe = new StringBuilder();
        if (value != null) {
            for (int i = 0; i < value.length(); i++) {
                char c = value.charAt(i);
                safe.append(c >= 32 && c <= 126 ? c : '?');
            }
        }
        return safe.toString().replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)");
    }

    // Builds a dependency-free, ASCII-only PDF so it can be safely streamed by this JSP.
    private String makePdf(List<String> reportLines) {
        final int linesPerPage = 50;
        int pageCount = Math.max(1, (reportLines.size() + linesPerPage - 1) / linesPerPage);
        int objectCount = 3 + pageCount * 2;
        String[] objects = new String[objectCount + 1];
        StringBuilder kids = new StringBuilder();
        for (int page = 0; page < pageCount; page++) {
            int pageObject = 4 + page * 2;
            int streamObject = pageObject + 1;
            if (page > 0) kids.append(' ');
            kids.append(pageObject).append(" 0 R");

            StringBuilder stream = new StringBuilder("BT\n/F1 10 Tf\n50 790 Td\n14 TL\n");
            int from = page * linesPerPage;
            int to = Math.min(reportLines.size(), from + linesPerPage);
            for (int line = from; line < to; line++) {
                stream.append('(').append(pdfText(reportLines.get(line))).append(") Tj\nT*\n");
            }
            stream.append("ET\n");
            objects[pageObject] = "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 842] /Resources << /Font << /F1 3 0 R >> >> /Contents " + streamObject + " 0 R >>";
            objects[streamObject] = "<< /Length " + stream.length() + " >>\nstream\n" + stream + "endstream";
        }
        objects[1] = "<< /Type /Catalog /Pages 2 0 R >>";
        objects[2] = "<< /Type /Pages /Kids [" + kids + "] /Count " + pageCount + " >>";
        objects[3] = "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>";

        StringBuilder pdf = new StringBuilder("%PDF-1.4\n");
        int[] offsets = new int[objectCount + 1];
        for (int object = 1; object <= objectCount; object++) {
            offsets[object] = pdf.length();
            pdf.append(object).append(" 0 obj\n").append(objects[object]).append("\nendobj\n");
        }
        int xrefOffset = pdf.length();
        pdf.append("xref\n0 ").append(objectCount + 1).append("\n0000000000 65535 f \n");
        for (int object = 1; object <= objectCount; object++) {
            String offset = String.valueOf(offsets[object]);
            StringBuilder padded = new StringBuilder();
            for (int n = offset.length(); n < 10; n++) padded.append('0');
            pdf.append(padded).append(offset).append(" 00000 n \n");
        }
        pdf.append("trailer\n<< /Size ").append(objectCount + 1).append(" /Root 1 0 R >>\nstartxref\n").append(xrefOffset).append("\n%%EOF");
        return pdf.toString();
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
    String companyLogo = (String) session.getAttribute("companyLogo");
    String companyBanner = (String) session.getAttribute("companyBanner");
    if (companyName == null || companyName.trim().length() == 0) companyName = "Company";
    if (email == null) email = "";
    if (companyLogo == null || companyLogo.trim().length() == 0) companyLogo = "images/company/tcs-logo.png";
    if (companyBanner == null || companyBanner.trim().length() == 0) companyBanner = "images/company/tcs-banner.png";
    String companyInitial = companyName.substring(0, 1).toUpperCase();

    int totalDrives = 0;
    int totalApplications = 0;
    int totalOffers = 0;
    int acceptedOffers = 0;
    boolean reportError = false;
    String reportErrorMessage = "";
    List<Map<String, Object>> driveRows = new ArrayList<Map<String, Object>>();
    Map<String, Integer> applicationStatuses = new LinkedHashMap<String, Integer>();
    Map<String, Integer> collegeStatuses = new LinkedHashMap<String, Integer>();
    Map<String, Integer> offerStatuses = new LinkedHashMap<String, Integer>();

    try (Connection connection = DBConnection.getConnection()) {
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ?")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) totalDrives = rs.getInt(1); }
        }
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT COUNT(*) FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID = A.DRIVE_ID WHERE D.COMPANY_ID = ?")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) totalApplications = rs.getInt(1); }
        }
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT D.DRIVE_ID, D.JOB_TITLE, D.DRIVE_TYPE, D.STATUS, COUNT(A.APPLICATION_ID) AS APPLICATION_COUNT " +
                "FROM RECRUITMENT_DRIVE D LEFT JOIN APPLICATION A ON A.DRIVE_ID = D.DRIVE_ID " +
                "WHERE D.COMPANY_ID = ? GROUP BY D.DRIVE_ID, D.JOB_TITLE, D.DRIVE_TYPE, D.STATUS ORDER BY D.DRIVE_ID DESC")) {
            ps.setInt(1, companyId.intValue());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<String, Object>();
                    row.put("driveId", rs.getObject("DRIVE_ID"));
                    row.put("jobTitle", rs.getString("JOB_TITLE"));
                    row.put("driveType", rs.getString("DRIVE_TYPE"));
                    row.put("status", rs.getString("STATUS"));
                    row.put("applicationCount", Integer.valueOf(rs.getInt("APPLICATION_COUNT")));
                    driveRows.add(row);
                }
            }
        }
        String[] statusQueries = {
            "SELECT A.STATUS AS STATUS_VALUE, COUNT(*) AS STATUS_COUNT FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID = A.DRIVE_ID WHERE D.COMPANY_ID = ? GROUP BY A.STATUS ORDER BY A.STATUS",
            "SELECT A.COLLEGE_SHORTLIST_STATUS AS STATUS_VALUE, COUNT(*) AS STATUS_COUNT FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID = A.DRIVE_ID WHERE D.COMPANY_ID = ? GROUP BY A.COLLEGE_SHORTLIST_STATUS ORDER BY A.COLLEGE_SHORTLIST_STATUS",
            "SELECT O.OFFER_STATUS AS STATUS_VALUE, COUNT(*) AS STATUS_COUNT FROM OFFER O WHERE O.COMPANY_ID = ? GROUP BY O.OFFER_STATUS ORDER BY O.OFFER_STATUS"
        };
        List<Map<String, Integer>> summaries = new ArrayList<Map<String, Integer>>();
        for (int q = 0; q < statusQueries.length; q++) {
            Map<String, Integer> target = q == 0 ? applicationStatuses : (q == 1 ? collegeStatuses : offerStatuses);
            try (PreparedStatement ps = connection.prepareStatement(statusQueries[q])) {
                ps.setInt(1, companyId.intValue());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) target.put(displayStatus(rs.getString("STATUS_VALUE")), Integer.valueOf(rs.getInt("STATUS_COUNT")));
                }
            }
        }
        for (Integer count : offerStatuses.values()) totalOffers += count.intValue();
        Integer acceptedCount = offerStatuses.get("ACCEPTED");
        if (acceptedCount != null) acceptedOffers = acceptedCount.intValue();

        String exportFormat = request.getParameter("export");
        if ("pdf".equalsIgnoreCase(exportFormat)) {
            List<String> pdfLines = new ArrayList<String>();
            pdfLines.add(companyName + " - Recruitment Reports");
            pdfLines.add("Generated from CampusConnect company portal");
            pdfLines.add("");
            pdfLines.add("OVERVIEW");
            pdfLines.add("Total drives: " + totalDrives);
            pdfLines.add("Total applications: " + totalApplications);
            pdfLines.add("Total offers: " + totalOffers);
            pdfLines.add("Accepted offers: " + acceptedOffers);
            pdfLines.add("");
            pdfLines.add("DRIVE PERFORMANCE");
            for (Map<String, Object> row : driveRows) {
                pdfLines.add(String.valueOf(row.get("jobTitle")) + " | " + displayStatus((String) row.get("driveType")) +
                        " | Drive status: " + displayStatus((String) row.get("status")) +
                        " | Applications: " + row.get("applicationCount"));
            }
            pdfLines.add("");
            pdfLines.add("APPLICATION STATUS (company application status)");
            for (Map.Entry<String, Integer> entry : applicationStatuses.entrySet()) pdfLines.add(entry.getKey() + ": " + entry.getValue());
            pdfLines.add("");
            pdfLines.add("COLLEGE SHORTLIST STATUS");
            for (Map.Entry<String, Integer> entry : collegeStatuses.entrySet()) pdfLines.add(entry.getKey() + ": " + entry.getValue());
            pdfLines.add("");
            pdfLines.add("OFFER STATUS");
            for (Map.Entry<String, Integer> entry : offerStatuses.entrySet()) pdfLines.add(entry.getKey() + ": " + entry.getValue());

            response.reset();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=company-reports.pdf");
            response.setCharacterEncoding("US-ASCII");
            out.clear();
            out.print(makePdf(pdfLines));
            out.flush();
            return;
        }
        if ("csv".equalsIgnoreCase(exportFormat)) {
            response.reset();
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=company-reports.csv");
            out.clear();
            out.println("Report,Item,Status,Count");
            out.println("Overview,Total drives,," + totalDrives);
            out.println("Overview,Total applications,," + totalApplications);
            out.println("Overview,Total offers,," + totalOffers);
            out.println("Overview,Accepted offers,," + acceptedOffers);
            for (Map.Entry<String, Integer> entry : applicationStatuses.entrySet())
                out.println(csv("Application status") + ",," + csv(entry.getKey()) + "," + entry.getValue());
            for (Map.Entry<String, Integer> entry : collegeStatuses.entrySet())
                out.println(csv("College shortlist status") + ",," + csv(entry.getKey()) + "," + entry.getValue());
            for (Map.Entry<String, Integer> entry : offerStatuses.entrySet())
                out.println(csv("Offer status") + ",," + csv(entry.getKey()) + "," + entry.getValue());
            for (Map<String, Object> row : driveRows)
                out.println(csv("Drive") + "," + csv(row.get("jobTitle")) + "," + csv(row.get("status")) + "," + row.get("applicationCount"));
            return;
        }
    } catch (Exception e) {
        reportError = true;
        reportErrorMessage = "Reports are temporarily unavailable. Please try again later.";
        applicationStatuses.clear();
        collegeStatuses.clear();
        offerStatuses.clear();
        driveRows.clear();
        totalDrives = 0; totalApplications = 0; totalOffers = 0; acceptedOffers = 0;
        application.log("Unable to load company reports for companyId=" + companyId, e);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= h(companyName) %> Reports | CampusConnect</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="css/company-dashboard.css?v=10">
    <style>
        .report-heading{display:flex;justify-content:space-between;align-items:center;gap:18px;margin-bottom:22px;flex-wrap:wrap}
        .report-heading p{margin:7px 0 0;color:#68758a}
        .reports-topbar{box-sizing:border-box;min-height:178px;padding:34px 4%;display:flex;align-items:center;justify-content:space-between;gap:28px;background:#fff;border-bottom:1px solid #e3eaf3}
        .reports-topbar h1{margin:0;color:#073665;font-size:44px;line-height:1.15;font-weight:700}
        .reports-topbar p{margin:9px 0 0;color:#7187a3;font-size:20px;line-height:1.45}
        .reports-topbar .dashboard-link{display:inline-flex;align-items:center;gap:9px;padding:12px 17px;border:1px solid #d9e5f5;border-radius:9px;background:#f8fbff;color:#1769c2;text-decoration:none;font-size:16px;font-weight:600;white-space:nowrap;transition:background .2s,border-color .2s}
        .reports-topbar .dashboard-link:hover{background:#edf5ff;border-color:#b9d3f4}
        .report-export{display:inline-flex;align-items:center;gap:9px;padding:11px 16px;border-radius:9px;background:#2457d6;color:#fff;text-decoration:none;font-weight:600}
        .report-export:hover{background:#1946b8}
        .report-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin-bottom:24px}
        .report-card,.report-panel{background:#fff;border:1px solid #e8edf4;border-radius:14px;box-shadow:0 5px 18px rgba(23,43,77,.04)}
        .report-card{padding:20px;display:flex;align-items:center;gap:15px}
        .report-card-icon{width:46px;height:46px;border-radius:12px;display:grid;place-items:center;background:#edf3ff;color:#2457d6;font-size:19px}
        .report-card strong{display:block;font-size:25px;color:#172b4d}.report-card span{display:block;color:#68758a;margin-top:4px;font-size:13px}
        .report-panel{padding:22px;margin-bottom:22px}.report-panel h2{margin:0 0 5px;font-size:19px;color:#172b4d}.report-panel .panel-note{margin:0 0 17px;color:#758197;font-size:13px}
        .table-wrap{overflow-x:auto}.report-table{width:100%;border-collapse:collapse;min-width:600px}.report-table th,.report-table td{text-align:left;padding:13px 12px;border-bottom:1px solid #edf0f5;font-size:14px}.report-table th{color:#718096;font-size:12px;text-transform:uppercase;letter-spacing:.04em;background:#f8faff}.report-table td{color:#26364d}.report-table tr:last-child td{border-bottom:0}
        .status-list{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:12px}.status-row{display:flex;justify-content:space-between;gap:12px;padding:14px 15px;background:#f7f9fc;border-radius:10px;color:#435168}.status-row strong{color:#172b4d}.empty-state{padding:22px;text-align:center;color:#748197;background:#f8faff;border-radius:10px}
        .report-alert{padding:14px 16px;background:#fff4f2;border:1px solid #ffd5cd;border-radius:10px;color:#8c3426;margin-bottom:20px}
        @media(max-width:1000px){.report-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}@media(max-width:700px){.reports-topbar{min-height:150px;padding:28px 22px;align-items:flex-start;flex-direction:column;justify-content:center;gap:14px}.reports-topbar h1{font-size:34px}.reports-topbar p{font-size:16px}}@media(max-width:600px){.report-grid{grid-template-columns:1fr}.report-panel{padding:16px}}
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
            <a href="company-reports.jsp" class="menu-item active"><i class="fa-solid fa-chart-column"></i><span>Reports &amp; Analytics</span></a>
            <a href="company-analytics.jsp" class="menu-item"><i class="fa-solid fa-chart-line"></i><span>Analytics Insights</span></a>
        </div>
        <div class="sidebar-bottom">
            <a href="company-settings.jsp" class="menu-item"><i class="fa-solid fa-gear"></i><span>Settings</span></a>
            <a href="CompanyLogoutServlet" class="menu-item logout"><i class="fa-solid fa-right-from-bracket"></i><span>Logout</span></a>
        </div>
    </aside>
    <main class="main-content">
        <header class="reports-topbar">
            <div><h1>Reports &amp; Analytics</h1><p>Welcome, <%= h(companyName) %>. Review your recruitment activity and hiring outcomes.</p></div>
            <a class="dashboard-link" href="company-dashboard.jsp"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
        </header>
        <div class="page-body">
            <div class="report-heading"><div><h2>Recruitment reports</h2><p>Live totals and status breakdowns for your company’s recruitment activity.</p></div><div style="display:flex;gap:10px;flex-wrap:wrap"><a class="report-export" href="company-reports.jsp?export=csv"><i class="fa-solid fa-download"></i> Export CSV</a><a class="report-export" href="company-reports.jsp?export=pdf"><i class="fa-solid fa-file-pdf"></i> Download PDF</a></div></div>
            <% if (reportError) { %><div class="report-alert"><%= h(reportErrorMessage) %></div><% } %>
            <section class="report-grid">
                <div class="report-card"><div class="report-card-icon"><i class="fa-solid fa-briefcase"></i></div><div><strong><%= totalDrives %></strong><span>Total drives</span></div></div>
                <div class="report-card"><div class="report-card-icon"><i class="fa-solid fa-users"></i></div><div><strong><%= totalApplications %></strong><span>Total applications</span></div></div>
                <div class="report-card"><div class="report-card-icon"><i class="fa-regular fa-gem"></i></div><div><strong><%= totalOffers %></strong><span>Total offers</span></div></div>
                <div class="report-card"><div class="report-card-icon"><i class="fa-solid fa-circle-check"></i></div><div><strong><%= acceptedOffers %></strong><span>Accepted offers</span></div></div>
            </section>
            <section class="report-panel"><h2>Drive performance</h2><p class="panel-note">Application totals are grouped by each of your recruitment drives.</p><div class="table-wrap"><table class="report-table"><thead><tr><th>Drive</th><th>Type</th><th>Drive status</th><th>Applications</th></tr></thead><tbody>
                <% if (driveRows.isEmpty()) { %><tr><td colspan="4"><div class="empty-state">No recruitment drives found.</div></td></tr><% } else { for (Map<String, Object> row : driveRows) { %>
                <tr><td><%= h(row.get("jobTitle")) %></td><td><%= h(row.get("driveType")) %></td><td><%= h(displayStatus((String) row.get("status"))) %></td><td><%= h(row.get("applicationCount")) %></td></tr>
                <% } } %>
            </tbody></table></div></section>
            <section class="report-panel"><h2>Application status</h2><p class="panel-note">Company application status, grouped by the values currently stored in APPLICATION.STATUS.</p><div class="status-list">
                <% if (applicationStatuses.isEmpty()) { %><div class="empty-state">No application status data available.</div><% } else { for (Map.Entry<String, Integer> entry : applicationStatuses.entrySet()) { %><div class="status-row"><span><%= h(entry.getKey()) %></span><strong><%= entry.getValue() %></strong></div><% } } %>
            </div></section>
            <section class="report-panel"><h2>College shortlist status</h2><p class="panel-note">This is the college’s shortlist field, shown separately from the company application status above.</p><div class="status-list">
                <% if (collegeStatuses.isEmpty()) { %><div class="empty-state">No college shortlist status data available.</div><% } else { for (Map.Entry<String, Integer> entry : collegeStatuses.entrySet()) { %><div class="status-row"><span><%= h(entry.getKey()) %></span><strong><%= entry.getValue() %></strong></div><% } } %>
            </div></section>
            <section class="report-panel"><h2>Offer status</h2><p class="panel-note">Offer totals are grouped by OFFER.OFFER_STATUS. All stored values are included.</p><div class="status-list">
                <% if (offerStatuses.isEmpty()) { %><div class="empty-state">No offer status data available.</div><% } else { for (Map.Entry<String, Integer> entry : offerStatuses.entrySet()) { %><div class="status-row"><span><%= h(entry.getKey()) %></span><strong><%= entry.getValue() %></strong></div><% } } %>
            </div></section>
        </div>
    </main>
</div>
</body>
</html>
