<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String msg = request.getParameter("msg");
    if (msg == null || msg.trim().isEmpty()) {
        msg = "Unable to complete company registration at this time.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Failed | CampusConnect</title>

    <!-- Google Fonts & FontAwesome Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
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

        .brand-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
            text-decoration: none;
            transition: transform 0.2s ease;
        }

        .brand-header:hover { transform: translateY(-2px); }

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

        .brand-text span { color: #2563eb; }

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
            from { opacity: 0; transform: translateY(12px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .top-accent-bar {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #ef4444, #f97316);
        }

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

        .failure-title {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-main);
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
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover { background: #e2e8f0; color: #0f172a; }

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
        }

        .btn-home:hover { color: var(--primary); }

        .page-footer {
            margin-top: 28px;
            font-size: 12px;
            color: var(--text-muted);
            text-align: center;
        }
    </style>
</head>

<body>

    <a href="index.jsp" class="brand-header">
        <div class="brand-mark"><i class="fa-solid fa-graduation-cap"></i></div>
        <div class="brand-text">Campus<span>Connect</span></div>
    </a>

    <div class="failure-card">
        <div class="top-accent-bar"></div>

        <div class="icon-wrapper">
            <i class="fa-solid fa-building-circle-xmark"></i>
        </div>

        <h1 class="failure-title">Company Registration Failed</h1>

        <div class="failure-msg-badge">
            <i class="fa-solid fa-circle-xmark"></i>
            <%= msg %>
        </div>

        <p class="failure-desc">
            We were unable to process your employer registration. This usually happens if the corporate email or company name is already registered, or required fields were incomplete.
        </p>

        <div class="action-stack">
            <a href="company-registration.jsp" class="btn btn-primary">
                <i class="fa-solid fa-arrow-rotate-left"></i>
                Try Again
            </a>

            <a href="company-login.jsp" class="btn btn-secondary">
                <i class="fa-solid fa-right-to-bracket"></i>
                Already Registered? Sign In
            </a>
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
