<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#1769d2">
    <title>Registration Complete | CampusConnect</title>
    <style>
        :root {
            color-scheme: light;
            --navy: #113b63;
            --blue: #1769d2;
            --blue-dark: #1256b0;
            --muted: #667f99;
            --border: #e1eaf3;
        }

        * { box-sizing: border-box; }

        body {
            min-height: 100vh;
            margin: 0;
            display: grid;
            place-items: center;
            padding: 32px 18px;
            background:
                radial-gradient(circle at 12% 18%, rgba(61, 143, 239, .12), transparent 28%),
                radial-gradient(circle at 88% 82%, rgba(31, 111, 209, .10), transparent 30%),
                #f3f7fc;
            color: var(--navy);
            font-family: Arial, Helvetica, sans-serif;
        }

        .page-shell { width: min(100%, 650px); }

        .brand {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            margin-bottom: 22px;
            color: #153e67;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: -.5px;
        }

        .brand-mark {
            display: grid;
            width: 34px;
            height: 34px;
            place-items: center;
            border-radius: 10px;
            background: var(--blue);
            color: #fff;
            font-size: 17px;
        }

        .brand span span { color: var(--blue); }

        .success-card {
            overflow: hidden;
            border: 1px solid rgba(216, 228, 241, .9);
            border-radius: 24px;
            background: #fff;
            box-shadow: 0 24px 70px rgba(26, 66, 109, .12);
        }

        .success-top {
            padding: 42px 44px 34px;
            background: linear-gradient(120deg, #155da9, #1978df);
            color: #fff;
            text-align: center;
        }

        .success-icon {
            display: grid;
            width: 76px;
            height: 76px;
            margin: 0 auto 19px;
            place-items: center;
            border: 1px solid rgba(255, 255, 255, .45);
            border-radius: 50%;
            background: rgba(255, 255, 255, .15);
            box-shadow: inset 0 0 0 7px rgba(255, 255, 255, .06);
        }

        .success-icon svg { width: 34px; height: 34px; }

        .eyebrow {
            margin: 0 0 9px;
            color: #c9e2ff;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.7px;
            text-transform: uppercase;
        }

        h1 {
            margin: 0;
            font-size: clamp(26px, 5vw, 34px);
            letter-spacing: -.7px;
        }

        .success-top p {
            max-width: 430px;
            margin: 12px auto 0;
            color: #e5f1ff;
            font-size: 15px;
            line-height: 1.6;
        }

        .success-content { padding: 30px 44px 38px; }

        .next-step {
            display: flex;
            align-items: flex-start;
            gap: 13px;
            padding: 16px;
            border: 1px solid #e4edf6;
            border-radius: 14px;
            background: #f8fbff;
        }

        .next-step-icon {
            display: grid;
            width: 36px;
            height: 36px;
            flex: 0 0 36px;
            place-items: center;
            border-radius: 10px;
            background: #e8f2ff;
            color: var(--blue);
            font-weight: 800;
        }

        .next-step strong { display: block; margin: 1px 0 4px; font-size: 14px; }
        .next-step p { margin: 0; color: var(--muted); font-size: 13px; line-height: 1.5; }

        .actions { display: flex; flex-direction: column; gap: 11px; margin-top: 24px; }

        .button {
            display: flex;
            min-height: 48px;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 12px 18px;
            border: 1px solid transparent;
            border-radius: 11px;
            font-size: 14px;
            font-weight: 700;
            text-align: center;
            text-decoration: none;
            transition: background .18s ease, transform .18s ease, box-shadow .18s ease;
        }

        .button:hover { transform: translateY(-1px); }
        .button-primary { background: var(--blue); color: #fff; box-shadow: 0 7px 15px rgba(23, 105, 210, .2); }
        .button-primary:hover { background: var(--blue-dark); }
        .button-secondary { border-color: var(--border); background: #fff; color: #45627f; }
        .button-secondary:hover { background: #f7faff; }

        .secure-note {
            margin: 20px 0 0;
            color: #8a9bae;
            font-size: 11px;
            line-height: 1.5;
            text-align: center;
        }

        @media (max-width: 520px) {
            .success-card { border-radius: 19px; }
            .success-top { padding: 34px 22px 28px; }
            .success-content { padding: 23px 20px 27px; }
            .success-icon { width: 66px; height: 66px; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { scroll-behavior: auto !important; transition-duration: .01ms !important; }
        }
    </style>
</head>
<body>
    <main class="page-shell">
        <div class="brand" aria-label="CampusConnect">
            <span class="brand-mark" aria-hidden="true">C</span>
            <span>Campus<span>Connect</span></span>
        </div>

        <section class="success-card" aria-labelledby="successTitle">
            <div class="success-top">
                <div class="success-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M5 12.5L9.2 16.5L19 7" stroke="white" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <p class="eyebrow">Registration complete</p>
                <h1 id="successTitle">Your company is registered</h1>
                <p>Your CampusConnect company account has been created successfully.</p>
            </div>

            <div class="success-content">
                <div class="next-step">
                    <span class="next-step-icon" aria-hidden="true">1</span>
                    <div>
                        <strong>Continue to your company portal</strong>
                        <p>Sign in with the email address and password you used during registration.</p>
                    </div>
                </div>

                <div class="actions">
                    <a class="button button-primary" href="company-login.jsp">
                        Go to Company Sign In <span aria-hidden="true">&rarr;</span>
                    </a>
                    <a class="button button-secondary" href="index.jsp">Return to CampusConnect Home</a>
                </div>

                <p class="secure-note">Your account details are ready. Sign in to complete your company profile and manage recruitment drives.</p>
            </div>
        </section>
    </main>
</body>
</html>
