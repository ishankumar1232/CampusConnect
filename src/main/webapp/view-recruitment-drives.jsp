<%@ page import="java.sql.ResultSet" %>

<%@ page import="com.campusconnect.bean.RecruitmentDrive" %>



<%

    response.setCharacterEncoding("UTF-8");



    Integer companyId = (Integer) session.getAttribute("companyId");

    String companyName = (String) session.getAttribute("companyName");

    String email = (String) session.getAttribute("email");



    if (companyId == null) {

        response.sendRedirect("company-login.jsp");

        return;

    }



    if (companyName == null) {

        companyName = "Company";

    }



    String driveUpdateMessage = (String) session.getAttribute("driveUpdateMessage");
    if (driveUpdateMessage != null) {
        session.removeAttribute("driveUpdateMessage");
        driveUpdateMessage = driveUpdateMessage
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
    if (email == null) {

        email = "";

    }



    String logoPath = null;

    com.campusconnect.bean.Company company =
            new com.campusconnect.bean.Company();
    company.setCompanyId(companyId);

    if (company.SelectMethod()) {
        logoPath = company.getLogoUrl();
    }

    if (logoPath != null) {
        logoPath = logoPath.trim();
    }

    boolean useNameBasedFallback =
            logoPath == null || logoPath.isEmpty();

    if (!useNameBasedFallback) {
        String normalizedLogoPath = logoPath
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
            logoPath = "images/company/infosys-logo.png";
        } else if (companyLogoName.contains("google")) {
            logoPath = "images/company/google-logo.png";
        } else if (companyLogoName.contains("tcs") ||
                companyLogoName.contains("tata consultancy")) {
            logoPath = "images/company/tcs-logo.png";
        } else {
            logoPath = "images/company/tcs-logo.png";
        }
    }

    // Prefix application-relative paths with the current web context.
    // Leave absolute HTTP(S) and scheme-relative URLs unchanged.
    if (!logoPath.matches("(?i)^(https?:)?//.*$")) {
        String contextPath = request.getContextPath();

        if (!logoPath.equals(contextPath) &&
                !logoPath.startsWith(contextPath + "/")) {
            if (logoPath.startsWith("/")) {
                logoPath = contextPath + logoPath;
            } else {
                logoPath = contextPath + "/" + logoPath;
            }
        }
    }

    String logoUrl = logoPath + (logoPath.contains("?") ? "&" : "?") + "v=2";
    String defaultLogoUrl = request.getContextPath() + "/images/company/tcs-logo.png";
    RecruitmentDrive r = new RecruitmentDrive();

    r.setCompanyId(companyId);



    ResultSet rs = r.SelectMethod();

%>



<!DOCTYPE html>

<html>



<head>



    <meta charset="UTF-8">



    <title>Recruitment Drives</title>



        <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>



        * {

            box-sizing: border-box;

        }



        body {

            margin: 0;

            font-family: Arial, Helvetica, sans-serif;

            background: #f4f8fc;

            color: #123f68;

        }



        /* ================= HEADER ================= */



        .top-header {

            background: #ffffff;

            padding: 38px 4%;

            border-bottom: 1px solid #dce5ee;



            display: flex;

            justify-content: space-between;

            align-items: center;

        }



        .header-title h1 {

            margin: 0;

            font-size: 38px;

            color: #104875;

        }



        .header-title p {

            margin-top: 10px;

            margin-bottom: 0;



            color: #6785a5;

            font-size: 18px;

        }



        .dashboard-link {

            color: #087cf5;

            text-decoration: none;



            font-size: 18px;

            font-weight: bold;

        }



        .dashboard-link:hover {

            text-decoration: underline;

        }



        /* ================= MAIN ================= */



        .container {

            width: 84%;

            margin: 45px auto;

        }



        /* ================= COMPANY BANNER ================= */



        .company-banner {



            background: linear-gradient(
                110deg,
                #1769a5,
                #087ff0
            );



            border-radius: 24px;



            padding: 34px 48px;



            display: flex;

            align-items: center;

            justify-content: space-between;



            color: white;



            box-shadow: 0 12px 30px rgba(0, 100, 200, 0.15);

        }



        .company-left {



            display: flex;

            align-items: center;



            gap: 28px;

        }



        .company-logo {



            width: 116px;

            height: 116px;



            background: white;



            border-radius: 20px;



            display: flex;

            align-items: center;

            justify-content: center;



            overflow: hidden;

        }



        .company-logo img {



            max-width: 90px;

            max-height: 90px;



            object-fit: contain;

        }



        .company-logo-text {



            font-size: 32px;

            font-weight: bold;



            color: #087cf5;

        }



        .company-info h2 {



            margin: 0;



            font-size: 34px;



            color: white;

        }



        .company-info p {



            margin-top: 8px;

            margin-bottom: 0;



            font-size: 18px;



            color: #e9f4ff;

        }



        .account-status {



            border: 1px solid rgba(255,255,255,0.7);



            border-radius: 30px;



            padding: 13px 25px;



            font-size: 16px;



            font-weight: bold;

        }



        /* ================= MAIN CARD ================= */



        .main-card {



            margin-top: 35px;



            background: white;



            border-radius: 24px;



            border: 1px solid #dce7f1;



            overflow: hidden;



            box-shadow: 0 5px 18px rgba(20, 80, 130, 0.06);

        }



        .card-header {



            padding: 32px 38px;



            border-bottom: 1px solid #e2eaf2;

        }



        .card-header h2 {



            margin: 0;



            font-size: 30px;



            color: #104875;

        }



        .card-header p {



            margin-top: 8px;

            margin-bottom: 0;



            color: #6d88a5;



            font-size: 17px;

        }



        /* ================= DRIVE CARD ================= */



        .drive-card {



            margin: 0;



            border-bottom: 1px solid #e1e9f1;

        }



        .drive-card:last-child {



            border-bottom: none;

        }



        .drive-top {



            padding: 30px 36px;



            display: flex;



            align-items: center;



            justify-content: space-between;

        }



        .drive-title-section {



            display: flex;



            align-items: center;



            gap: 20px;

        }



        .drive-icon {



            width: 58px;

            height: 58px;



            border-radius: 15px;



            background: #edf6ff;



            display: flex;



            align-items: center;

            justify-content: center;



            color: #087cf5;



            font-size: 25px;



            font-weight: bold;

        }



        .drive-title h3 {



            margin: 0;



            font-size: 27px;



            color: #0d4777;

        }



        .drive-meta {



            margin-top: 7px;



            color: #6985a2;



            font-size: 16px;

        }



        /* ================= STATUS ================= */



        .status-active {



            background: #e7f8ef;



            color: #07884e;



            border: 1px solid #bdebd2;



            padding: 10px 18px;



            border-radius: 25px;



            font-size: 15px;



            font-weight: bold;

        }



        .status-closed {



            background: #fff0f0;



            color: #d93025;



            border: 1px solid #f3c5c5;



            padding: 10px 18px;



            border-radius: 25px;



            font-size: 15px;



            font-weight: bold;

        }



        /* ================= DESCRIPTION ================= */



        .description-section {



            padding: 0 36px 28px 36px;

        }



        .description-section h4 {



            margin: 0 0 12px 0;



            color: #0d4777;



            font-size: 18px;

        }



        .description-section p {



            margin: 0;



            color: #6684a2;



            font-size: 16px;



            line-height: 1.6;

        }



        /* ================= DETAILS ================= */



        .details-grid {



            padding: 0 36px 28px 36px;



            display: grid;



            grid-template-columns: repeat(4, 1fr);



            gap: 18px;

        }



        .detail-box {



            background: #fbfdff;



            border: 1px solid #dce8f3;



            border-radius: 14px;



            padding: 20px;

        }



        .detail-label {



            color: #6d88a5;



            font-size: 15px;



            margin-bottom: 8px;

        }



        .detail-value {



            color: #073e6c;



            font-size: 18px;



            font-weight: bold;



            word-break: break-word;

        }



        /* ================= SKILLS ================= */



        .skills-section {



            padding: 0 36px 28px 36px;

        }



        .skills-section h4 {



            margin: 0 0 10px 0;



            color: #0d4777;



            font-size: 18px;

        }



        .skills-section p {



            margin: 0;



            color: #6684a2;



            font-size: 16px;

        }



        /* ================= DEADLINE ================= */



        .deadline-section {



            padding: 0 36px 30px 36px;

        }



        .deadline-section h4 {



            margin: 0 0 10px 0;



            color: #0d4777;



            font-size: 18px;

        }



        .deadline-section p {



            margin: 0;



            color: #6684a2;



            font-size: 16px;

        }



        /* ================= ACTIONS ================= */



        .actions {



            padding: 22px 36px;



            border-top: 1px solid #e1e9f1;



            display: flex;



            gap: 12px;



            flex-wrap: wrap;

        }



        .action-btn {



            display: inline-block;



            padding: 11px 20px;



            border-radius: 9px;



            text-decoration: none;



            font-size: 15px;



            font-weight: bold;



            transition: 0.2s;

        }



        /* EDIT */



        .edit-btn {



            color: #087cf5;



            background: #edf6ff;



            border: 1px solid #c5e1fb;

        }



        .edit-btn:hover {



            background: #dcefff;

        }



        /* CLOSE */



        .close-btn {



            color: #d93025;



            background: #fff2f2;



            border: 1px solid #f1c8c8;

        }



        .close-btn:hover {



            background: #ffe3e3;

        }



        /* SELECT COLLEGES */



        .college-btn {



            color: #087c49;



            background: #eaf9f1;



            border: 1px solid #bfe9d2;

        }



        .college-btn:hover {



            background: #d9f5e6;

        }



        /* ================= CLOSED DRIVE INFO ================= */



        .closed-info {



            padding: 11px 20px;



            border-radius: 9px;



            background: #fff7e8;



            border: 1px solid #f4d59a;



            color: #a56800;



            font-size: 14px;



            font-weight: bold;

        }



        /* ================= BOTTOM ================= */



        .bottom-actions {



            margin-top: 28px;



            display: flex;



            justify-content: space-between;



            align-items: center;

        }



        .create-btn {



            display: inline-block;



            background: #087ff0;



            color: white;



            padding: 14px 24px;



            border-radius: 10px;



            text-decoration: none;



            font-size: 16px;



            font-weight: bold;



            box-shadow: 0 7px 18px rgba(0, 120, 240, 0.2);

        }



        .create-btn:hover {



            background: #066ed2;

        }



        .bottom-dashboard {



            color: #087cf5;



            text-decoration: none;



            font-size: 16px;



            font-weight: bold;

        }



        .bottom-dashboard:hover {



            text-decoration: underline;

        }



        /* ================= NO DATA ================= */



        .no-data {



            padding: 60px;



            text-align: center;



            color: #6d88a5;



            font-size: 18px;

        }



        /* ================= RESPONSIVE ================= */



        @media(max-width: 1000px) {



            .container {



                width: 94%;

            }



            .details-grid {



                grid-template-columns: repeat(2, 1fr);

            }



            .company-banner {



                padding: 25px;

            }

        }



        @media(max-width: 700px) {



            .top-header {



                padding: 25px;

            }



            .top-header,

            .company-banner,

            .drive-top,

            .bottom-actions {



                flex-direction: column;



                align-items: flex-start;



                gap: 20px;

            }



            .details-grid {



                grid-template-columns: 1fr;

            }



            .container {



                width: 94%;

            }



            .actions {



                flex-wrap: wrap;

            }

        }





        /* =========================================================
           COMPANY PORTAL SIDEBAR - ADDED ONLY
           ========================================================= */

        .cc-sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 285px;
            min-width: 285px;
            height: 100vh;
            background: linear-gradient(180deg, #092f55 0%, #062847 100%);
            color: #ffffff;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        .cc-sidebar::-webkit-scrollbar { width: 4px; }
        .cc-sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.20); }

        .cc-brand {
            padding: 30px 26px 25px;
            margin: 0 16px;
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }

        .cc-brand-name {
            font-size: 25px;
            line-height: normal;
            font-weight: 800;
            letter-spacing: -1px;
            color: #ffffff;
        }

        .cc-brand-name span { color: #2e8bf0; }

        .cc-brand-subtitle {
            margin-top: 8px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 1.2px;
            color: #4da2ff;
        }

        .cc-menu {
            flex: 1;
            padding: 24px 16px;
        }

        .cc-section-title {
            margin: 0 11px 10px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #42a0f5;
        }

        .cc-section-title:not(:first-child) { margin-top: 22px; }

        .cc-menu-item {
            min-height: 48px;
            padding: 0 15px;
            margin-bottom: 5px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            gap: 17px;
            color: #edf5ff;
            text-decoration: none;
            font-size: 16px;
            font-weight: 600;
        }

        .cc-menu-item:hover { background: rgba(49,139,238,0.22); }

        .cc-menu-item.active {
            background: linear-gradient(
                90deg,
                #2683e9,
                #347fce
            );
            box-shadow: 0 5px 15px rgba(0,0,0,0.12);
        }

        .cc-icon {
            width: 22px;
            min-width: 22px;
            text-align: center;
            font-size: 18px;
            color: #e9f3ff;
        }

        .cc-bottom {
            padding: 10px 16px 25px;
            border-top: 1px solid rgba(255,255,255,0.15);
        }

        .cc-logout { color: #ff7d7d; }
        .cc-logout .cc-icon { color: #ff7d7d; }

        .cc-page {
            margin-left: 285px;
            min-height: 100vh;
        }

        @media (max-width: 900px) {
            .cc-sidebar { width: 220px; }
            .cc-page { margin-left: 220px; }
        }

        @media (max-width: 700px) {
            .cc-sidebar {
                position: relative;
                width: 100%;
                height: auto;
            }
            .cc-page { margin-left: 0; }
        }

    
        /* Centered update confirmation popup */
        .drive-message-overlay {
            position: fixed;
            inset: 0;
            z-index: 10000;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: rgba(9, 47, 85, 0.48);
        }

        .drive-message-overlay.is-visible { display: flex; }

        .drive-message-box {
            width: min(100%, 430px);
            padding: 30px;
            border: 1px solid #dce7f1;
            border-radius: 16px;
            background: #ffffff;
            box-shadow: 0 18px 45px rgba(9, 47, 85, 0.25);
            color: #104875;
            text-align: center;
        }

        .drive-message-box p {
            margin: 0 0 22px;
            font-size: 17px;
            line-height: 1.5;
        }

        .drive-message-box button {
            min-width: 110px;
            padding: 12px 24px;
            border: 0;
            border-radius: 9px;
            background: #087cf5;
            color: #ffffff;
            font: inherit;
            font-weight: bold;
            cursor: pointer;
        }

        .drive-message-box button:hover { background: #066ed2; }

        /* Centered confirmation before closing a recruitment drive */
        .close-confirm-overlay {
            position: fixed;
            inset: 0;
            z-index: 10001;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: rgba(9, 28, 48, 0.58);
        }

        .close-confirm-overlay.is-visible { display: flex; }

        .close-confirm-box {
            width: min(100%, 460px);
            padding: 30px;
            border: 1px solid #dce7f1;
            border-radius: 18px;
            background: #ffffff;
            box-shadow: 0 22px 60px rgba(4, 30, 56, 0.28);
            color: #123f68;
            text-align: center;
            animation: confirmPopupIn 160ms ease-out;
        }

        .close-confirm-icon {
            display: grid;
            place-items: center;
            width: 56px;
            height: 56px;
            margin: 0 auto 16px;
            border-radius: 50%;
            background: #fff2e8;
            color: #d45b16;
            font-size: 25px;
        }

        .close-confirm-box h2 {
            margin: 0 0 10px;
            color: #104875;
            font-size: 23px;
        }

        .close-confirm-box p {
            margin: 0;
            color: #66809a;
            font-size: 16px;
            line-height: 1.55;
        }

        .close-confirm-actions {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 26px;
        }

        .close-confirm-actions button {
            min-width: 112px;
            padding: 12px 20px;
            border: 1px solid transparent;
            border-radius: 9px;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
            transition: background 150ms ease, transform 150ms ease;
        }

        .close-confirm-actions button:hover { transform: translateY(-1px); }

        .close-confirm-cancel {
            border-color: #cbd9e6 !important;
            background: #ffffff;
            color: #315c80;
        }

        .close-confirm-cancel:hover { background: #f3f7fb; }

        .close-confirm-accept {
            background: #d93025;
            color: #ffffff;
        }

        .close-confirm-accept:hover { background: #b9231a; }

        @keyframes confirmPopupIn {
            from { opacity: 0; transform: translateY(8px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        @media (max-width: 480px) {
            .close-confirm-box { padding: 25px 20px; }
            .close-confirm-actions { flex-direction: column-reverse; }
            .close-confirm-actions button { width: 100%; }
        }
        /* Compact, responsive recruitment drive list */
        .top-header { padding: 24px 4%; }
        .header-title h1 { font-size: 32px; }
        .header-title p { margin-top: 6px; font-size: 15px; }
        .container { width: 94%; max-width: 1360px; margin: 26px auto; }
        .company-banner { padding: 20px 30px; border-radius: 20px; }
        .company-left { gap: 20px; }
        .company-logo { width: 82px; height: 82px; border-radius: 16px; }
        .company-logo img { max-width: 66px; max-height: 66px; }
        .company-info h2 { font-size: 27px; }
        .company-info p { margin-top: 5px; font-size: 15px; }
        .account-status { padding: 10px 18px; font-size: 13px; }
        .main-card { margin-top: 22px; border-radius: 20px; }
        .card-header { padding: 23px 30px; }
        .card-header h2 { font-size: 25px; }
        .card-header p { margin-top: 5px; font-size: 14px; }
        .drive-card {
            margin: 16px 20px;
            overflow: hidden;
            border: 1px solid #dfe8f2;
            border-radius: 16px;
            background: #ffffff;
            box-shadow: 0 5px 16px rgba(20, 52, 86, 0.055);
            transition: border-color .18s ease, box-shadow .18s ease, transform .18s ease;
        }
        .drive-card:hover {
            border-color: #c6d9ec;
            box-shadow: 0 10px 24px rgba(20, 52, 86, 0.09);
            transform: translateY(-1px);
        }
        .drive-top { padding: 20px 30px 12px; }
        .drive-title-section { gap: 15px; }
        .drive-icon { width: 48px; height: 48px; border-radius: 13px; font-size: 21px; }
        .drive-title h3 { font-size: 22px; }
        .drive-meta { margin-top: 4px; font-size: 13px; }
        .status-active, .status-closed { padding: 7px 13px; font-size: 12px; }
        .details-grid { grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 10px; padding: 0 30px 14px; }
        .detail-box { padding: 12px 14px; border-radius: 11px; }
        .detail-label { margin-bottom: 5px; font-size: 12px; }
        .detail-value { font-size: 16px; }
        .drive-more { margin: 0 30px 14px; overflow: hidden; border: 1px solid #e0e9f2; border-radius: 12px; background: #fbfdff; }
        .drive-more > summary { display: flex; align-items: center; gap: 12px; padding: 12px 15px; color: #174d79; cursor: pointer; list-style: none; }
        .drive-more > summary::-webkit-details-marker { display: none; }
        .drive-more-icon { display: grid; place-items: center; width: 28px; height: 28px; flex: 0 0 28px; border-radius: 8px; background: #eaf3ff; color: #087cf5; font-size: 20px; font-weight: 500; }
        .drive-more-copy { display: flex; flex: 1; flex-direction: column; gap: 2px; }
        .drive-more-copy strong { font-size: 13px; }
        .drive-more-copy small { color: #7b8fa4; font-size: 11px; }
        .drive-more-toggle { display: inline-flex; align-items: center; color: #087cf5; font-size: 12px; font-weight: 700; white-space: nowrap; }
        .drive-more-chevron { display: inline-block; width: 8px; height: 8px; margin: -4px 0 0 7px; border-right: 2px solid currentColor; border-bottom: 2px solid currentColor; transform: rotate(45deg); transition: transform .18s ease, margin .18s ease; }
        .drive-more[open] .drive-more-icon { transform: rotate(45deg); }
        .drive-more[open] .drive-more-chevron { margin-top: 4px; transform: rotate(225deg); }
        .drive-icon .fa-briefcase { font-size: 18px; }
        .drive-more-content { padding: 0 15px 12px; border-top: 1px solid #e8eef5; }
        .drive-more-content .description-section,
        .drive-more-content .skills-section,
        .drive-more-content .deadline-section { padding: 13px 2px 0; }
        .drive-more-content .description-section h4,
        .drive-more-content .skills-section h4,
        .drive-more-content .deadline-section h4 { margin: 0 0 5px; font-size: 14px; }
        .drive-more-content .description-section p,
        .drive-more-content .skills-section p,
        .drive-more-content .deadline-section p { font-size: 13px; line-height: 1.5; }
        .actions { padding: 13px 30px; gap: 9px; }
        .action-btn { padding: 9px 15px; font-size: 13px; }
        .closed-info { padding: 9px 15px; font-size: 12px; }
        .bottom-actions { margin: 20px 0 30px; }
        .create-btn { padding: 11px 18px; font-size: 14px; }
        .bottom-dashboard { font-size: 14px; }

        @media (max-width: 1000px) {
            .details-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }

        @media (max-width: 700px) {
            .top-header { padding: 20px 5%; }
            .top-header { align-items: flex-start; gap: 10px; }
            .top-header .dashboard-link { font-size: 14px; }
            .container { width: 94%; margin: 18px auto; }
            .company-banner { align-items: flex-start; flex-direction: row; gap: 14px; padding: 17px; }
            .company-logo { width: 60px; height: 60px; }
            .company-logo img { max-width: 50px; max-height: 50px; }
            .company-info h2 { font-size: 21px; }
            .company-info p { font-size: 12px; }
            .account-status { margin-left: auto; padding: 7px 10px; font-size: 10px; white-space: nowrap; }
            .card-header { padding: 18px 18px; }
            .card-header h2 { font-size: 21px; }
            .drive-card { margin: 12px; border-radius: 14px; }
            .drive-top { align-items: flex-start; gap: 12px; padding: 17px 18px 12px; }
            .drive-title-section { gap: 11px; }
            .drive-icon { width: 42px; height: 42px; flex: 0 0 42px; font-size: 18px; }
            .drive-title h3 { font-size: 18px; }
            .drive-meta { font-size: 11px; line-height: 1.5; }
            .details-grid { gap: 8px; padding: 0 18px 12px; }
            .detail-box { padding: 10px; }
            .detail-label { font-size: 11px; }
            .detail-value { font-size: 14px; }
            .drive-more { margin: 0 18px 12px; }
            .drive-more > summary { padding: 10px; }
            .drive-more-copy small { font-size: 10px; }
            .drive-more-toggle { font-size: 11px; }
            .actions { padding: 12px 18px; }
            .action-btn { padding: 8px 11px; font-size: 12px; }
            .bottom-actions { align-items: flex-start; flex-direction: column; gap: 12px; }
        }

        @media (max-width: 420px) {
            .company-banner { flex-wrap: wrap; }
            .account-status { margin-left: 71px; }
            .drive-card { margin: 10px; }
            .drive-more-toggle { font-size: 10px; }
            .drive-more-copy small { display: none; }
        }

    </style>



</head>





<body>


    <!-- =====================================================
         COMPANY PORTAL SIDEBAR - ADDED ONLY
         ===================================================== -->
    <aside class="cc-sidebar">

        <div class="cc-brand">
            <div class="cc-brand-name">Campus<span>Connect</span></div>
            <div class="cc-brand-subtitle">COMPANY PORTAL</div>
        </div>

        <div class="cc-menu">

            <div class="cc-section-title">OVERVIEW</div>

            <a href="company-dashboard.jsp" class="cc-menu-item">
                <i class="fa-solid fa-house cc-icon"></i>
                <span>Dashboard</span>
            </a>

            <a href="company-profile.jsp" class="cc-menu-item">
                <i class="fa-solid fa-building cc-icon"></i>
                <span>Company Profile</span>
            </a>

            <div class="cc-section-title">RECRUITMENT</div>

            <a href="recruitment-drive.jsp" class="cc-menu-item">
                <i class="fa-solid fa-plus cc-icon"></i>
                <span>Create Drive</span>
            </a>

            <a href="view-recruitment-drives.jsp" class="cc-menu-item active">
                <i class="fa-solid fa-briefcase cc-icon"></i>
                <span>Recruitment Drives</span>
            </a>

            <a href="company-applicants.jsp" class="cc-menu-item">
                <i class="fa-solid fa-users cc-icon"></i>
                <span>Applicants</span>
            </a>

            <a href="company-shortlisted.jsp" class="cc-menu-item">
                <i class="fa-solid fa-star cc-icon"></i>
                <span>Shortlisted Candidates</span>
            </a>

            <a href="company-interviews.jsp" class="cc-menu-item">
                <i class="fa-regular fa-square cc-icon"></i>
                <span>Interviews</span>
            </a>

            <a href="company-offers.jsp" class="cc-menu-item">
                <i class="fa-regular fa-gem cc-icon"></i>
                <span>Offers &amp; Selections</span>
            </a>

            <div class="cc-section-title">ANALYTICS</div>

            <a href="company-reports.jsp" class="cc-menu-item">
                <i class="fa-solid fa-chart-column cc-icon"></i>
                <span>Reports &amp; Analytics</span>
            </a>

            <a href="company-analytics.jsp" class="cc-menu-item">
                <i class="fa-solid fa-chart-line cc-icon"></i>
                <span>Analytics Insights</span>
            </a>
        </div>

        <div class="cc-bottom">
            <a href="company-settings.jsp" class="cc-menu-item">
                <i class="fa-solid fa-gear cc-icon"></i>
                <span>Settings</span>
            </a>
            <a href="CompanyLogoutServlet" class="cc-menu-item cc-logout">
                <i class="fa-solid fa-right-from-bracket cc-icon"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <div class="cc-page">






<!-- ================= HEADER ================= -->



<div class="top-header">



    <div class="header-title">



        <h1>

            Recruitment Drives

        </h1>



        <p>

            Manage and track your company's recruitment opportunities.

        </p>



    </div>





    <a

        href="company-dashboard.jsp"

        class="dashboard-link">



        Back to Dashboard



    </a>



</div>







<div class="container">





    <!-- ================= COMPANY BANNER ================= -->



    <div class="company-banner">





        <div class="company-left">





            <div class="company-logo">

                <img
                    src="<%= logoUrl %>"
                    alt="<%= companyName %> Logo"
                    onerror="this.onerror=null;this.src='<%= defaultLogoUrl %>';"
                >

            </div>





            <div class="company-info">



                <h2>



                    <%= companyName %>



                </h2>



                <p>



                    <%= email %>



                </p>



            </div>





        </div>





        <div class="account-status">



            ACTIVE ACCOUNT



        </div>





    </div>







    <!-- ================= MAIN CARD ================= -->



    <div class="main-card">





        <div class="card-header">



            <h2>

                My Recruitment Drives

            </h2>



            <p>

                View, edit and manage all recruitment drives created by your company.

            </p>



        </div>







<%



    boolean found = false;



    while (rs != null && rs.next()) {



        found = true;





        int currentDriveId =

                rs.getInt("DRIVE_ID");



        String driveType =

                rs.getString("DRIVE_TYPE");



        String jobTitle =

                rs.getString("JOB_TITLE");



        String description =

                rs.getString("DESCRIPTION");



        int vacancy =

                rs.getInt("VACANCY");



        double eligibilityCgpa =

                rs.getDouble("ELIGIBILITY_CGPA");



        String requiredBranch =

                rs.getString("REQUIRED_BRANCH");



        String requiredSkills =

                rs.getString("REQUIRED_SKILLS");



        double salary =

                rs.getDouble("SALARY");



        java.sql.Date deadline =

                rs.getDate("DEADLINE");



        String status =

                rs.getString("STATUS");



%>





        <!-- ================= DRIVE CARD ================= -->



        <div class="drive-card">





            <!-- DRIVE TOP -->



            <div class="drive-top">





                <div class="drive-title-section">





                    <div class="drive-icon" aria-hidden="true">
                        <i class="fa-solid fa-briefcase"></i>
                    </div>





                    <div class="drive-title">



                        <h3>



                            <%= jobTitle %>



                        </h3>





                        <div class="drive-meta">



                            <%= companyName %>



                            &nbsp; &#8226; &nbsp;



                            <%= driveType %>



                            &nbsp; &#8226; &nbsp;



                            Drive ID #<%= currentDriveId %>



                        </div>



                    </div>





                </div>







                <!-- STATUS -->



                <%



                    if ("ACTIVE".equalsIgnoreCase(status)) {



                %>



                    <div class="status-active">



                        ACTIVE



                    </div>



                <%



                    } else {



                %>



                    <div class="status-closed">



                        CLOSED



                    </div>



                <%



                    }



                %>





            </div>







                        <!-- Key information stays visible; long text details are expandable. --><div class="details-grid">





                <div class="detail-box">



                    <div class="detail-label">



                        Number of Vacancies



                    </div>



                    <div class="detail-value">



                        <%= vacancy %>



                    </div>



                </div>







                <div class="detail-box">



                    <div class="detail-label">



                        Minimum Eligibility CGPA



                    </div>



                    <div class="detail-value">



                        <%= eligibilityCgpa %>



                    </div>



                </div>







                <div class="detail-box">



                    <div class="detail-label">



                        Required Branch



                    </div>



                    <div class="detail-value">



                        <%= requiredBranch %>



                    </div>



                </div>







                <div class="detail-box">



                    <div class="detail-label">



                        Salary / CTC



                    </div>



                    <div class="detail-value">



                        &#8377;



                        <%= String.format("%.0f", salary) %>



                    </div>



                </div>





            </div>







                        <details class="drive-more">
                <summary>
                    <span class="drive-more-icon" aria-hidden="true">+</span>
                    <span class="drive-more-copy"><strong>Full drive details</strong><small>Description, required skills and application deadline</small></span>
                    <span class="drive-more-toggle">Show details <span class="drive-more-chevron" aria-hidden="true"></span></span>
                </summary>
                <div class="drive-more-content"><div class="description-section">



                <h4>



                    Job Description



                </h4>



                <p>



                    <%= description %>



                </p>



            </div>







            <div class="skills-section">



                <h4>



                    Required Skills



                </h4>



                <p>



                    <%= requiredSkills %>



                </p>



            </div>







            <div class="deadline-section">



                <h4>



                    Application Deadline



                </h4>



                <p>



                    <%= deadline %>



                </p>



            </div>







                            </div>
            </details>
<!-- ================= ACTION BUTTONS ================= -->



            <div class="actions">





                <!-- EDIT



                     Available for both ACTIVE and CLOSED



                \-->



                <a



                    href="edit-recruitment-drive.jsp?driveId=<%= currentDriveId %>"



                    class="action-btn edit-btn">



                    Edit



                </a>







                <%



                    /*

                     * CLOSE DRIVE

                     *

                     * Only ACTIVE drives can be closed.

                     */



                    if ("ACTIVE".equalsIgnoreCase(status)) {



                %>





                    <button
                        type="button"
                        class="action-btn close-btn"
                        data-close-url="close-recruitment-drive.jsp?driveId=<%= currentDriveId %>">
                        Close Drive
                    </button>





                <%



                    }



                %>







                <%



                    /*

                     * SELECT COLLEGES

                     *

                     * IMPORTANT:

                     *

                     * It will appear ONLY when:

                     *

                     * 1. Drive is ACTIVE

                     * 2. Drive Type is On Campus

                     */



                    if (



                        "ACTIVE".equalsIgnoreCase(status)



                        &&



                        "On Campus".equalsIgnoreCase(driveType)



                    ) {



                %>





                    <a



                        href="select-drive-colleges.jsp?driveId=<%= currentDriveId %>"



                        class="action-btn college-btn">



                        Select Colleges



                    </a>





                <%



                    }



                %>







                <%



                    /*

                     * CLOSED DRIVE INFORMATION

                     *

                     * Displayed instead of Select Colleges

                     */



                    if ("CLOSED".equalsIgnoreCase(status)) {



                %>





                    <div class="closed-info">



                        Drive Closed



                    </div>





                <%



                    }



                %>





            </div>





        </div>





<%



    }





    if (!found) {



%>





        <div class="no-data">



            No Recruitment Drives Found.



        </div>





<%



    }





    if (rs != null) {



        try {



            rs.close();



        } catch (Exception e) {



            // Ignore close exception



        }



    }



%>





    </div>







    <!-- ================= BOTTOM ACTIONS ================= -->



    <div class="bottom-actions">





        <a



            href="recruitment-drive.jsp"



            class="create-btn">



            + Create New Recruitment Drive



        </a>





        <a



            href="company-dashboard.jsp"



            class="bottom-dashboard">



            Back to Dashboard



        </a>





    </div>





</div>





    </div>


<div id="closeConfirmOverlay" class="close-confirm-overlay"
     aria-hidden="true">
    <div class="close-confirm-box" role="alertdialog" aria-modal="true"
         aria-labelledby="closeConfirmTitle" aria-describedby="closeConfirmText">
        <div class="close-confirm-icon" aria-hidden="true">!</div>
        <h2 id="closeConfirmTitle">Close recruitment drive?</h2>
        <p id="closeConfirmText">Are you sure you want to close this recruitment drive? Students will no longer be able to apply.</p>
        <div class="close-confirm-actions">
            <button id="closeConfirmCancel" class="close-confirm-cancel" type="button">Cancel</button>
            <button id="closeConfirmAccept" class="close-confirm-accept" type="button">Yes, close drive</button>
        </div>
    </div>
</div>

<script>
    (function () {
        var overlay = document.getElementById("closeConfirmOverlay");
        var cancelButton = document.getElementById("closeConfirmCancel");
        var acceptButton = document.getElementById("closeConfirmAccept");
        var pendingUrl = null;
        var lastTrigger = null;

        function closeDialog() {
            overlay.classList.remove("is-visible");
            overlay.setAttribute("aria-hidden", "true");
            pendingUrl = null;
            if (lastTrigger) lastTrigger.focus();
        }

        document.querySelectorAll(".close-btn[data-close-url]").forEach(function (button) {
            button.addEventListener("click", function () {
                pendingUrl = button.getAttribute("data-close-url");
                lastTrigger = button;
                overlay.classList.add("is-visible");
                overlay.setAttribute("aria-hidden", "false");
                cancelButton.focus();
            });
        });

        cancelButton.addEventListener("click", closeDialog);

        acceptButton.addEventListener("click", function () {
            if (pendingUrl) window.location.href = pendingUrl;
        });

        overlay.addEventListener("click", function (event) {
            if (event.target === overlay) closeDialog();
        });

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" && overlay.classList.contains("is-visible")) {
                closeDialog();
            }
        });
    })();
</script>

<% if (driveUpdateMessage != null && !driveUpdateMessage.trim().isEmpty()) { %>
<div id="driveMessageOverlay" class="drive-message-overlay is-visible"
     role="presentation">
    <div class="drive-message-box" role="alertdialog" aria-modal="true"
         aria-labelledby="driveMessageText">
        <p id="driveMessageText"><%= driveUpdateMessage %></p>
        <button id="driveMessageOk" type="button">OK</button>
    </div>
</div>
<script>
    (function () {
        var overlay = document.getElementById("driveMessageOverlay");
        var button = document.getElementById("driveMessageOk");
        button.focus();
        button.addEventListener("click", function () {
            overlay.classList.remove("is-visible");
            overlay.setAttribute("aria-hidden", "true");
        });
    })();
</script>
<% } %>
</body>



</html>
