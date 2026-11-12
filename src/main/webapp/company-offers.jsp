
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.sql.*" import="java.text.*" import="java.util.*"
    import="jakarta.servlet.http.HttpServletResponse"
    import="com.campusconnect.util.DBConnection" %>

<%!
    private String esc(String v) {
        if (v == null) return "";
        return v.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private int number(String v) {
        try { return Integer.parseInt(v); }
        catch (Exception e) { return 0; }
    }

    private java.sql.Date parseDate(String value) throws Exception {
        if (value == null || value.trim().isEmpty()) return null;
        SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
        f.setLenient(false);
        return new java.sql.Date(f.parse(value).getTime());
    }

    private String dateText(java.util.Date value) {
        return value == null ? "—" :
            new SimpleDateFormat("dd-MM-yyyy").format(value);
    }
%>

<%
    Integer companyId = (Integer) session.getAttribute("companyId");
    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String companyName = (String) session.getAttribute("companyName");
    if (companyName == null || companyName.trim().isEmpty())
        companyName = "Company";

    String csrf = (String) session.getAttribute("offerCsrf");
    if (csrf == null) {
        csrf = UUID.randomUUID().toString();
        session.setAttribute("offerCsrf", csrf);
    }

    String flash = (String) session.getAttribute("offerFlash");
    session.removeAttribute("offerFlash");

    String error = null;
    Connection con = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");

        if (request.getParameter("csrf") == null ||
            !csrf.equals(request.getParameter("csrf"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Session token expired. Refresh and try again.");
            return;
        }

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String action = request.getParameter("action");

            if ("create".equals(action)) {
                int appId = number(request.getParameter("applicationId"));
                String designation = request.getParameter("designation");
                String ctcText = request.getParameter("annualCtc");
                String letter = request.getParameter("offerLetter");
                String remarks = request.getParameter("remarks");
                java.sql.Date joiningDate =
                    parseDate(request.getParameter("joiningDate"));

                if (designation == null) designation = "";
                designation = designation.trim();

                if (appId <= 0 || designation.isEmpty()
                        || designation.length() > 100) {
                    throw new IllegalArgumentException(
                        "Choose a selected candidate and enter a designation of up to 100 characters.");
                }

                java.math.BigDecimal ctc;
                try {
                    ctc = new java.math.BigDecimal(ctcText);
                } catch (Exception ex) {
                    throw new IllegalArgumentException("Enter a valid annual CTC.");
                }

                if (ctc.signum() <= 0 || ctc.precision() > 12 || ctc.scale() > 2) {
                    throw new IllegalArgumentException(
                        "Annual CTC must be positive and fit up to 10 digits and 2 decimals.");
                }

                if (letter != null && letter.trim().length() > 500)
                    throw new IllegalArgumentException(
                        "Offer letter link or reference must be 500 characters or fewer.");

                if (remarks != null && remarks.trim().length() > 500)
                    throw new IllegalArgumentException(
                        "Remarks must be 500 characters or fewer.");

                String eligible =
                    "SELECT A.APPLICATION_ID FROM APPLICATION A " +
                    "JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID " +
                    "WHERE A.APPLICATION_ID=? AND D.COMPANY_ID=? " +
                    "AND UPPER(NVL(A.STATUS,'PENDING'))='SELECTED' " +
                    "FOR UPDATE OF A.STATUS";

                try (PreparedStatement p = con.prepareStatement(eligible)) {
                    p.setInt(1, appId);
                    p.setInt(2, companyId);

                    try (ResultSet r = p.executeQuery()) {
                        if (!r.next())
                            throw new IllegalArgumentException(
                                "Only a selected candidate belonging to your company can receive an offer.");
                    }
                }

                try (PreparedStatement p = con.prepareStatement(
                    "SELECT OFFER_ID FROM OFFER WHERE APPLICATION_ID=?")) {
                    p.setInt(1, appId);
                    try (ResultSet r = p.executeQuery()) {
                        if (r.next())
                            throw new IllegalArgumentException(
                                "An offer already exists for this candidate.");
                    }
                }

                int offerId;
                try (Statement s = con.createStatement();
                     ResultSet r = s.executeQuery(
                         "SELECT OFFER_SEQ.NEXTVAL FROM DUAL")) {
                    if (!r.next())
                        throw new SQLException("Could not allocate offer number.");
                    offerId = r.getInt(1);
                }

                String insert =
                    "INSERT INTO OFFER (OFFER_ID,APPLICATION_ID,COMPANY_ID," +
                    "OFFER_DATE,DESIGNATION,ANNUAL_CTC,JOINING_DATE," +
                    "OFFER_STATUS,OFFER_LETTER,REMARKS,CREATED_AT) " +
                    "VALUES (?,?,?,SYSDATE,?,?,?,'PENDING',?,?,SYSDATE)";

                try (PreparedStatement p = con.prepareStatement(insert)) {
                    p.setInt(1, offerId);
                    p.setInt(2, appId);
                    p.setInt(3, companyId);
                    p.setString(4, designation);
                    p.setBigDecimal(5, ctc);

                    if (joiningDate == null)
                        p.setNull(6, Types.DATE);
                    else
                        p.setDate(6, joiningDate);

                    p.setString(7,
                        letter == null || letter.trim().isEmpty()
                            ? null : letter.trim());
                    p.setString(8,
                        remarks == null || remarks.trim().isEmpty()
                            ? null : remarks.trim());

                    if (p.executeUpdate() != 1)
                        throw new SQLException("Offer was not created.");
                }

                con.commit();
                session.setAttribute("offerFlash",
                    "Offer created and marked pending.");
                response.sendRedirect("company-offers.jsp");
                return;

            } else if ("withdraw".equals(action)) {
                int offerId = number(request.getParameter("offerId"));

                if (offerId <= 0)
                    throw new IllegalArgumentException("Choose a valid offer.");

                try (PreparedStatement p = con.prepareStatement(
                    "UPDATE OFFER SET OFFER_STATUS='WITHDRAWN' " +
                    "WHERE OFFER_ID=? AND COMPANY_ID=? AND OFFER_STATUS='PENDING'")) {

                    p.setInt(1, offerId);
                    p.setInt(2, companyId);

                    if (p.executeUpdate() != 1)
                        throw new IllegalArgumentException(
                            "Only your pending offers can be withdrawn.");
                }

                con.commit();
                session.setAttribute("offerFlash", "Pending offer withdrawn.");
                response.sendRedirect("company-offers.jsp");
                return;

            } else {
                throw new IllegalArgumentException("Choose a valid offer action.");
            }

        } catch (IllegalArgumentException ex) {
            if (con != null) try { con.rollback(); }
            catch (SQLException ignored) { }
            error = ex.getMessage();

        } catch (Exception ex) {
            if (con != null) try { con.rollback(); }
            catch (SQLException ignored) { }
            error = "The offer action could not be completed. Please refresh and try again.";
            application.log("Company offer action failed", ex);

        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ignored) { }
            }
            con = null;
        }
    }

    List<Map<String,Object>> selected =
        new ArrayList<Map<String,Object>>();
    List<Map<String,Object>> offers =
        new ArrayList<Map<String,Object>>();

    int pendingCount = 0, acceptedCount = 0,
        declinedCount = 0, withdrawnCount = 0;

    try {
        con = DBConnection.getConnection();

        String selectedSql =
            "SELECT A.APPLICATION_ID,S.NAME,S.EMAIL,R.JOB_TITLE " +
            "FROM APPLICATION A " +
            "JOIN STUDENT S ON S.STUDENT_ID=A.STUDENT_ID " +
            "JOIN RECRUITMENT_DRIVE R ON R.DRIVE_ID=A.DRIVE_ID " +
            "WHERE R.COMPANY_ID=? " +
            "AND UPPER(NVL(A.STATUS,'PENDING'))='SELECTED' " +
            "AND NOT EXISTS (SELECT 1 FROM OFFER O " +
            "WHERE O.APPLICATION_ID=A.APPLICATION_ID) " +
            "ORDER BY A.APPLICATION_ID DESC";

        try (PreparedStatement p = con.prepareStatement(selectedSql)) {
            p.setInt(1, companyId);

            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Map<String,Object> m = new HashMap<String,Object>();
                    m.put("id", r.getInt("APPLICATION_ID"));
                    m.put("name", r.getString("NAME"));
                    m.put("email", r.getString("EMAIL"));
                    m.put("job", r.getString("JOB_TITLE"));
                    selected.add(m);
                }
            }
        }

        String offersSql =
            "SELECT O.OFFER_ID,O.APPLICATION_ID,O.OFFER_DATE," +
            "O.DESIGNATION,O.ANNUAL_CTC,O.JOINING_DATE,O.OFFER_STATUS," +
            "O.OFFER_LETTER,O.REMARKS,S.NAME,S.EMAIL,R.JOB_TITLE " +
            "FROM OFFER O " +
            "JOIN APPLICATION A ON A.APPLICATION_ID=O.APPLICATION_ID " +
            "JOIN STUDENT S ON S.STUDENT_ID=A.STUDENT_ID " +
            "JOIN RECRUITMENT_DRIVE R ON R.DRIVE_ID=A.DRIVE_ID " +
            "WHERE O.COMPANY_ID=? AND R.COMPANY_ID=? " +
            "ORDER BY O.OFFER_ID DESC";

        try (PreparedStatement p = con.prepareStatement(offersSql)) {
            p.setInt(1, companyId);
            p.setInt(2, companyId);

            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Map<String,Object> m = new HashMap<String,Object>();

                    m.put("id", r.getInt("OFFER_ID"));
                    m.put("appId", r.getInt("APPLICATION_ID"));
                    m.put("offerDate", r.getDate("OFFER_DATE"));
                    m.put("joiningDate", r.getDate("JOINING_DATE"));
                    m.put("designation", r.getString("DESIGNATION"));
                    m.put("ctc", r.getBigDecimal("ANNUAL_CTC"));
                    m.put("status", r.getString("OFFER_STATUS"));
                    m.put("letter", r.getString("OFFER_LETTER"));
                    m.put("remarks", r.getString("REMARKS"));
                    m.put("name", r.getString("NAME"));
                    m.put("email", r.getString("EMAIL"));
                    m.put("job", r.getString("JOB_TITLE"));
                    offers.add(m);

                    String st = r.getString("OFFER_STATUS");
                    if ("PENDING".equalsIgnoreCase(st)) pendingCount++;
                    else if ("ACCEPTED".equalsIgnoreCase(st)) acceptedCount++;
                    else if ("DECLINED".equalsIgnoreCase(st)) declinedCount++;
                    else if ("WITHDRAWN".equalsIgnoreCase(st)) withdrawnCount++;
                }
            }
        }

    } catch (Exception ex) {
        if (error == null)
            error = "Offer information could not be loaded. Please refresh the page.";
        application.log("Company offer list failed", ex);

    } finally {
        if (con != null) try { con.close(); }
        catch (SQLException ignored) { }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Offer Management | CampusConnect</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>
*{box-sizing:border-box}
html,body{margin:0;padding:0;min-height:100%;font-family:Arial,Helvetica,sans-serif;background:#f4f7fb;color:#082f55}
body{overflow-x:hidden}
.sidebar{width:285px;min-width:285px;height:100vh;position:fixed;left:0;top:0;background:linear-gradient(180deg,#092f55 0%,#062847 100%);color:#fff;display:flex;flex-direction:column;z-index:1000;overflow-y:auto}
.sidebar::-webkit-scrollbar{width:4px}.sidebar::-webkit-scrollbar-thumb{background:rgba(255,255,255,.2)}
.sidebar-logo{padding:30px 26px 25px;margin:0 16px;border-bottom:1px solid rgba(255,255,255,.15)}
.brand-name{font-size:25px;font-weight:800;letter-spacing:-1px;color:#fff}.brand-name span{color:#2e8bf0}
.brand-subtitle{margin-top:8px;font-size:13px;font-weight:700;letter-spacing:1.2px;color:#4da2ff}
.sidebar-content{padding:24px 16px;flex:1}
.menu-section-title{margin:0 10px 10px;font-size:12px;font-weight:800;letter-spacing:1px;color:#42a0f5}
.menu-section-title:not(:first-child){margin-top:22px}
.menu-item{min-height:48px;padding:0 15px;margin-bottom:5px;border-radius:9px;display:flex;align-items:center;gap:17px;font-size:16px;font-weight:600;color:#edf5ff;text-decoration:none;transition:background .2s ease,transform .2s ease}
.menu-item i{width:22px;text-align:center;font-size:18px;color:#e9f3ff}.menu-item:hover{background:rgba(49,139,238,.22)}
.menu-item.active{background:linear-gradient(90deg,#2683e9,#347fce);box-shadow:0 5px 15px rgba(0,0,0,.12)}.menu-item.active i{color:#fff}
.sidebar-bottom{padding:10px 16px 25px;border-top:1px solid rgba(255,255,255,.15)}.sidebar-bottom .menu-item{margin-bottom:3px}.menu-item.logout,.menu-item.logout i{color:#ff7d7d}
.page{margin-left:300px;min-height:100vh}
.top-header{min-height:143px;background:#fff;border-bottom:1px solid #dfe6ef;padding:35px 42px;display:flex;align-items:center;justify-content:space-between;gap:22px}
.header-left h1{margin:0;font-size:36px;color:#082f55}.header-left p{margin:7px 0 0;font-size:17px;color:#6d88a5}
.dashboard-link{color:#0878ed;text-decoration:none;font-size:16px;font-weight:700;white-space:nowrap}.dashboard-link:hover{text-decoration:underline}
.content{padding:38px 36px 50px}.page-heading{margin-bottom:25px}.page-heading h2{margin:0;font-size:30px;color:#082f55}.page-heading p{margin:7px 0 0;color:#6d88a5;font-size:16px}
.alert{display:flex;align-items:center;gap:11px;margin:0 0 22px;padding:14px 17px;border:1px solid #f3d99b;border-radius:10px;background:#fff9e9;color:#9a6700;font-weight:600}.alert.success{border-color:#b7ebcd;background:#edfbf3;color:#067647}
.metrics{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin:0 0 25px}
.metric{display:flex;align-items:center;gap:14px;min-height:96px;padding:18px 20px;background:#fff;border:1px solid #e0e7ef;border-radius:13px;box-shadow:0 6px 18px rgba(12,55,90,.045)}
.metric-icon{width:46px;height:46px;flex:0 0 46px;display:flex;align-items:center;justify-content:center;border-radius:12px;background:#eaf3ff;color:#176fe5;font-size:18px}
.metric-icon.pending{background:#fff5dc;color:#b77900}.metric-icon.accepted{background:#e7f8ef;color:#079455}.metric-icon.declined{background:#ffe8e8;color:#d14343}
.metric-value{display:block;color:#082f55;font-size:24px;line-height:1.1;font-weight:800}.metric-label{display:block;margin-top:5px;color:#7188a3;font-size:13px}
.layout{display:grid;grid-template-columns:minmax(0,1fr) 350px;gap:18px;align-items:start}
.panel{min-width:0;background:#fff;border:1px solid #e0e7ef;border-radius:16px;overflow:hidden;box-shadow:0 8px 25px rgba(12,55,90,.06)}
.panel-head{display:flex;justify-content:space-between;align-items:center;gap:12px;padding:23px 25px;border-bottom:1px solid #e4eaf1}.panel h2{font-size:21px;margin:0;color:#082f55}
.badge{padding:5px 9px;border-radius:20px;background:#eaf3ff;color:#176fe5;font-weight:700;font-size:12px;white-space:nowrap}
.table-wrap{overflow:auto}table{border-collapse:collapse;width:100%;min-width:790px}th,td{text-align:left;padding:13px 10px;border-bottom:1px solid #edf1f5;vertical-align:top}th{color:#7188a3;font-size:11px;text-transform:uppercase;letter-spacing:.45px;background:#fafcff}
.person{font-weight:700}.small{color:#7188a3;font-size:12px;margin-top:4px;line-height:1.45;overflow-wrap:anywhere}
.status{display:inline-block;padding:5px 9px;border-radius:20px;background:#fff5dc;color:#996400;font-size:11px;font-weight:800;white-space:nowrap}.status.accepted{background:#e7f8ef;color:#087443}.status.declined,.status.withdrawn{background:#ffe8e8;color:#b42318}
.empty{padding:30px 18px;text-align:center;color:#7188a3;line-height:1.7}.empty i{display:block;font-size:27px;margin-bottom:12px;color:#7c96b2}.empty b{display:block;color:#082f55;margin-bottom:7px}
.form{display:grid;gap:13px;padding:22px 24px}.field label{display:block;font-size:12px;color:#42627f;font-weight:700;margin-bottom:7px}.field input,.field select,.field textarea{width:100%;padding:11px;border:1px solid #d5dfeb;border-radius:8px;font:14px Arial,Helvetica,sans-serif;color:#082f55;background:#fff}.field input:focus,.field select:focus,.field textarea:focus{outline:2px solid #d9e7ff;border-color:#287fda}.field textarea{resize:vertical}.field.full{grid-column:1/-1}
.form-foot{display:flex;justify-content:flex-end;margin-top:5px}.field-help{font-size:12px;color:#7188a3;line-height:1.55}
.btn{display:inline-flex;align-items:center;justify-content:center;gap:7px;padding:11px 15px;border:1px solid #d5dfeb;border-radius:9px;background:#fff;color:#174a78;text-decoration:none;font-weight:700;cursor:pointer;font-family:inherit}.btn.primary{background:#287fda;border-color:#287fda;color:#fff}.actions{display:flex;gap:10px;flex-wrap:wrap}
.actions-cell form{display:inline}.link{color:#b42318;background:none;border:0;text-decoration:underline;cursor:pointer;font-weight:700;padding:5px;font-family:inherit}
@media(max-width:1100px){.sidebar{width:270px;min-width:270px}.page{margin-left:270px}.metrics{grid-template-columns:repeat(2,minmax(0,1fr))}.layout{grid-template-columns:minmax(0,1fr)}}
@media(max-width:900px){.sidebar{width:220px;min-width:220px}.page{margin-left:220px}.top-header{padding:30px}.content{padding:30px 24px}}
@media(max-width:700px){.sidebar{position:relative;width:100%;min-width:100%;height:auto}.sidebar-logo{padding:20px 22px 16px}.sidebar-content{padding:15px}.menu-item{display:inline-flex;margin:3px;padding:0 12px}.menu-section-title:not(:first-child){margin-top:15px}.sidebar-bottom{padding:10px 15px 15px}.page{margin-left:0}.top-header{flex-direction:column;align-items:flex-start;gap:15px}.metrics{grid-template-columns:1fr 1fr;gap:10px}.metric{min-height:82px;padding:12px;gap:10px}.metric-icon{width:38px;height:38px;flex-basis:38px}.metric-value{font-size:20px}}
@media(max-width:480px){.top-header{padding:24px 20px}.header-left h1{font-size:30px}.header-left p{font-size:15px}.content{padding:25px 14px 35px}.metric{padding:10px;gap:8px}.metric-icon{width:34px;height:34px;flex-basis:34px;font-size:15px}.metric-label{font-size:11px}.layout{gap:14px}.panel-head{padding:18px 16px}.panel h2{font-size:18px}.form{padding:18px 16px}}
</style>
</head>

<body>
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="brand-name">Campus<span>Connect</span></div>
        <div class="brand-subtitle">COMPANY PORTAL</div>
    </div>
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
        <a href="company-offers.jsp" class="menu-item active"><i class="fa-regular fa-gem"></i><span>Offers &amp; Selections</span></a>
        <div class="menu-section-title">ANALYTICS</div>
        <a href="company-reports.jsp" class="menu-item"><i class="fa-solid fa-chart-column"></i><span>Reports &amp; Analytics</span></a>
        <a href="company-analytics.jsp" class="menu-item"><i class="fa-solid fa-chart-line"></i><span>Analytics Insights</span></a>
    </div>
    <div class="sidebar-bottom">
        <a href="company-settings.jsp" class="menu-item"><i class="fa-solid fa-gear"></i><span>Settings</span></a>
        <a href="CompanyLogoutServlet" class="menu-item logout"><i class="fa-solid fa-right-from-bracket"></i><span>Logout</span></a>
    </div>
</aside>

<div class="page">
<header class="top-header">
    <div class="header-left">
        <h1>Offer Management</h1>
        <p>Welcome, <%=esc(companyName)%>. Create offers for selected candidates and track their responses.</p>
    </div>
    <a class="dashboard-link" href="view-recruitment-drives.jsp">View Recruitment Drives</a>
</header>
<main class="content">
    <div class="page-heading">
        <h2>Offers &amp; Selections</h2>
        <p>Manage offers for selected candidates and follow their responses.</p>
    </div>

<% if (flash != null) { %>
<div class="alert success"><i class="fa-solid fa-circle-check"></i><%=esc(flash)%></div>
<% } %>
<% if (error != null) { %>
<div class="alert"><i class="fa-solid fa-triangle-exclamation"></i><%=esc(error)%></div>
<% } %>

<section class="metrics">
    <div class="metric"><div class="metric-icon"><i class="fa-solid fa-file-signature"></i></div><div><span class="metric-value"><%=offers.size()%></span><span class="metric-label">Total Offers</span></div></div>
    <div class="metric"><div class="metric-icon pending"><i class="fa-regular fa-clock"></i></div><div><span class="metric-value"><%=pendingCount%></span><span class="metric-label">Pending</span></div></div>
    <div class="metric"><div class="metric-icon accepted"><i class="fa-solid fa-circle-check"></i></div><div><span class="metric-value"><%=acceptedCount%></span><span class="metric-label">Accepted</span></div></div>
    <div class="metric"><div class="metric-icon declined"><i class="fa-solid fa-circle-xmark"></i></div><div><span class="metric-value"><%=declinedCount + withdrawnCount%></span><span class="metric-label">Declined / Withdrawn</span></div></div>
</section>

<div class="layout">
<section class="panel">
    <div class="panel-head">
        <h2><i class="fa-solid fa-file-lines"></i> Issued Offers</h2>
        <span class="badge"><%=offers.size()%> tracked</span>
    </div>

    <% if (offers.isEmpty()) { %>
        <div class="empty">
            <i class="fa-regular fa-folder-open"></i>
            <b>No offers have been created yet.</b>
            Select an eligible candidate to issue the first offer.
        </div>
    <% } else { %>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Candidate</th>
                    <th>Offer</th>
                    <th>Compensation</th>
                    <th>Dates</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String,Object> o : offers) {
                String status = (String)o.get("status");
                String statusClass = status == null ? "" : status.toLowerCase(Locale.ROOT);
            %>
                <tr>
                    <td>
                        <div class="person"><%=esc((String)o.get("name"))%></div>
                        <div class="small"><%=esc((String)o.get("email"))%></div>
                        <div class="small"><%=esc((String)o.get("job"))%></div>
                        <div class="small">Application #<%=o.get("appId")%></div>
                    </td>
                    <td>
                        <b><%=esc((String)o.get("designation"))%></b>
                        <div class="small">Created <%=dateText((java.sql.Date)o.get("offerDate"))%></div>
                        <% if (o.get("letter") != null) { %>
                            <div class="small">Reference: <%=esc((String)o.get("letter"))%></div>
                        <% } %>
                        <% if (o.get("remarks") != null) { %>
                            <div class="small">Remarks: <%=esc((String)o.get("remarks"))%></div>
                        <% } %>
                    </td>
                    <td><b>₹ <%=o.get("ctc")%></b><div class="small">per year</div></td>
                    <td>Joining: <%=dateText((java.sql.Date)o.get("joiningDate"))%></td>
                    <td><span class="status <%=esc(statusClass)%>"><%=esc(status)%></span></td>
                    <td class="actions-cell">
                    <% if ("PENDING".equalsIgnoreCase(status)) { %>
                        <form method="post" onsubmit="return confirm('Withdraw this pending offer?')">
                            <input type="hidden" name="csrf" value="<%=esc(csrf)%>">
                            <input type="hidden" name="action" value="withdraw">
                            <input type="hidden" name="offerId" value="<%=o.get("id")%>">
                            <button class="link" type="submit">Withdraw</button>
                        </form>
                    <% } else { %>
                        <span class="small">—</span>
                    <% } %>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</section>

<aside class="panel">
    <div class="panel-head">
        <h2><i class="fa-solid fa-circle-plus"></i> Create Offer</h2>
    </div>

    <% if (selected.isEmpty()) { %>
        <div class="empty">
            <i class="fa-solid fa-user-check"></i>
            <b>No eligible candidates.</b>
            A candidate must have the company-side application status
            <strong>SELECTED</strong> before an offer can be created.
        </div>
    <% } else { %>
    <form class="form" method="post">
        <input type="hidden" name="csrf" value="<%=esc(csrf)%>">
        <input type="hidden" name="action" value="create">

        <div class="field full">
            <label for="applicationId">Selected Candidate *</label>
            <select id="applicationId" name="applicationId" required>
                <option value="">Choose a candidate</option>
                <% for (Map<String,Object> c : selected) { %>
                    <option value="<%=c.get("id")%>">
                        <%=esc((String)c.get("name"))%> — <%=esc((String)c.get("job"))%>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="field full">
            <label for="designation">Offer Designation *</label>
            <input id="designation" name="designation" maxlength="100" required>
        </div>

        <div class="field full">
            <label for="annualCtc">Annual CTC (₹) *</label>
            <input id="annualCtc" name="annualCtc" type="number"
                   min="0.01" step="0.01" required>
        </div>

        <div class="field full">
            <label for="joiningDate">Joining Date (optional)</label>
            <input id="joiningDate" name="joiningDate" type="date">
        </div>

        <div class="field full">
            <label for="offerLetter">Offer Letter Link / Reference</label>
            <input id="offerLetter" name="offerLetter" maxlength="500">
        </div>

        <div class="field full">
            <label for="remarks">Remarks</label>
            <textarea id="remarks" name="remarks" maxlength="500" rows="3"></textarea>
        </div>

        <div class="field-help">
            New offers start as PENDING. Candidate response statuses are displayed in the tracker.
        </div>

        <div class="form-foot">
            <button class="btn primary" type="submit">
                <i class="fa-solid fa-paper-plane"></i> Create Offer
            </button>
        </div>
    </form>
    <% } %>
</aside>
</div>
</main>
</div>
</body>
</html>
