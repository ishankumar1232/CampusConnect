<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = request.getParameter("role");
    if (role == null || role.trim().isEmpty()) {
        role = "Company";
    }

    String backUrl = "company-login.jsp";
    String registerUrl = "company-registration.jsp";
    String titleText = "Company Login Failed";

    if ("student".equalsIgnoreCase(role)) {
        backUrl = "student_login.jsp";
        registerUrl = "student_register.jsp";
        titleText = "Student Login Failed";
    } else if ("college".equalsIgnoreCase(role)) {
        backUrl = "collegeAdminLogin.jsp";
        registerUrl = "collegeAdminRegister.jsp";
        titleText = "College Login Failed";
    } else if ("admin".equalsIgnoreCase(role) || "superadmin".equalsIgnoreCase(role)) {
        backUrl = "superAdminLogin.jsp";
        registerUrl = null;
        titleText = "Super Admin Login Failed";
    }

    String errorMessage = request.getParameter("msg");
    if (errorMessage == null || errorMessage.trim().isEmpty()) {
        errorMessage = "Invalid Email ID or Password.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= titleText %> | CampusConnect</title>

    <!-- Google Fonts & FontAwesome Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --primary-light: #eff6ff;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --radius-lg: 20px;
            --radius-md: 12px;
            --shadow-card: 0 20px 40px -15px rgba(15, 23, 42, 0.12), 0 0 1px 1px rgba(15, 23, 42, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg-color);
            background-image: 
                radial-gradient(at 10% 20%, rgba(37, 99, 235, 0.06) 0px, transparent 50%),
                radial-gradient(at 90% 80%, rgba(220, 38, 38, 0.05) 0px, transparent 50%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 24px 16px;
            color: var(--text-main);
        }

        /* BRAND */
        .brand-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
            text-decoration: none;
            transition: transform 0.2s ease;
        }

        .brand-header:hover {
            transform: translateY(-2px);
        }

        .brand-mark {
            width: 44px;
            height: 44px;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, #2563eb, #3b82f6);
            border-radius: 12px;
            font-size: 22px;
            color: white;
            box-shadow: 0 8px 16px rgba(37, 99, 235, 0.25);
        }

        .brand-text {
            font-size: 24px;
            font-weight: 800;
            color: #0b1936;
            letter-spacing: -0.6px;
        }

        .brand-text span {
            color: #2563eb;
        }

        /* FAILURE CARD */
        .failure-card {
            background: var(--card-bg);
            width: 100%;
            max-width: 520px;
            border-radius: var(--radius-lg);
            padding: 40px 36px;
            box-shadow: var(--shadow-card);
            border: 1px solid var(--border-color);
            text-align: center;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.35s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(12px) scale(0.98);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .top-accent-bar {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #ef4444, #f97316);
        }

        /* ICON */
        .icon-wrapper {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--danger-bg);
            border: 2px solid var(--danger-border);
            display: grid;
            place-items: center;
            margin: 0 auto 22px;
            color: var(--danger);
            font-size: 34px;
            box-shadow: 0 10px 25px -8px rgba(220, 38, 38, 0.35);
        }

        /* TYPOGRAPHY */
        .failure-title {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-main);
            letter-spacing: -0.4px;
            margin-bottom: 8px;
        }

        .failure-msg-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--danger-bg);
            color: var(--danger);
            border: 1px solid var(--danger-border);
            padding: 7px 16px;
            border-radius: 20px;
            font-size: 13.5px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .failure-desc {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.55;
            margin-bottom: 24px;
        }

        /* TROUBLESHOOTING BOX */
        .troubleshoot-box {
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            text-align: left;
            margin-bottom: 28px;
        }

        .troubleshoot-head {
            font-size: 12.5px;
            font-weight: 700;
            color: #334155;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .troubleshoot-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .troubleshoot-list li {
            font-size: 13px;
            color: #475569;
            display: flex;
            align-items: flex-start;
            gap: 9px;
            line-height: 1.4;
        }

        .troubleshoot-list li i {
            color: #2563eb;
            font-size: 13px;
            margin-top: 2px;
            flex-shrink: 0;
        }

        /* ACTIONS */
        .action-stack {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .btn {
            width: 100%;
            padding: 13px 20px;
            border-radius: var(--radius-md);
            font-size: 14.5px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
            transition: all 0.2s ease;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
        }

        .btn-primary:hover {
            background: var(--primary-hover);
            transform: translateY(-1.5px);
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.4);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        .btn-home {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            text-decoration: none;
            margin-top: 18px;
            transition: color 0.15s ease;
        }

        .btn-home:hover {
            color: var(--primary);
        }

        /* FOOTER */
        .page-footer {
            margin-top: 28px;
            font-size: 12px;
            color: var(--text-muted);
            text-align: center;
        }

        /* RESPONSIVE */
        @media (max-width: 540px) {
            .failure-card {
                padding: 30px 22px;
            }
            .failure-title {
                font-size: 21px;
            }
            .icon-wrapper {
                width: 68px;
                height: 68px;
                font-size: 28px;
            }
        }
    </style>
</head>

<body>

    <!-- BRAND LOGO -->
    <a href="index.jsp" class="brand-header">
        <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
        <div class="brand-text">Campus<span>Connect</span></div>
    </a>

    <!-- MAIN CARD -->
    <div class="failure-card">
        <div class="top-accent-bar"></div>

        <!-- ERROR ICON -->
        <div class="icon-wrapper">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>

        <!-- HEADINGS -->
        <h1 class="failure-title"><%= titleText %></h1>

        <div class="failure-msg-badge">
            <i class="fa-solid fa-circle-xmark"></i>
            <%= errorMessage %>
        </div>

        <p class="failure-desc">
            We could not authenticate your account. The email address or password entered does not match our verified records.
        </p>

        <!-- TROUBLESHOOTING TIPS -->
        <div class="troubleshoot-box">
            <div class="troubleshoot-head">
                <i class="fa-solid fa-lightbulb" style="color: #f59e0b;"></i>
                Recommended Checks
            </div>
            <ul class="troubleshoot-list">
                <li>
                    <i class="fa-solid fa-chevron-right"></i>
                    <span>Verify your corporate email address for typos or spelling errors.</span>
                </li>
                <li>
                    <i class="fa-solid fa-chevron-right"></i>
                    <span>Check that <strong>Caps Lock</strong> is disabled when entering your password.</span>
                </li>
                <li>
                    <i class="fa-solid fa-chevron-right"></i>
                    <span>If you just registered, your account may still be awaiting <strong>Super Admin approval</strong>.</span>
                </li>
            </ul>
        </div>

        <!-- ACTIONS -->
        <div class="action-stack">
            <a href="<%= backUrl %>" class="btn btn-primary">
                <i class="fa-solid fa-arrow-rotate-left"></i>
                Try Again
            </a>

            <% if (registerUrl != null) { %>
                <a href="<%= registerUrl %>" class="btn btn-secondary">
                    <i class="fa-solid fa-building-circle-check"></i>
                    Register New Company Account
                </a>
            <% } %>
        </div>

        <a href="index.jsp" class="btn-home">
            <i class="fa-solid fa-house"></i>
            Back to CampusConnect Home
        </a>
    </div>

    <footer class="page-footer">
        CampusConnect &bull; Secure Authentication &amp; Recruitment Management System
    </footer>

</body>
</html>
