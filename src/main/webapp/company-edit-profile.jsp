
<%@ page import="java.sql.*" %>
<%@ page import="com.campusconnect.util.DBConnection" %>

<%!
    public String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    public String imagePath(String path, String contextPath) {
        if (path == null || path.trim().isEmpty()) {
            return "";
        }

        path = path.trim().replace("\\", "/");

        if (path.startsWith("http://") || path.startsWith("https://")) {
            return path;
        }

        while (path.startsWith("/")) {
            path = path.substring(1);
        }

        if (!path.startsWith("images/")) {
            path = "images/company/" + path;
        }

        return contextPath + "/" + path;
    }
%>

<%
    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String companyName = "";
    String email = "";
    String phone = "";
    String address = "";
    String website = "";
    String status = "";
    String logo = "";
    String banner = "";

    String sql = "SELECT COMPANY_NAME, EMAIL, PHONE, ADDRESS, WEBSITE, " +
                 "STATUS, LOGO, BANNER FROM COMPANY WHERE COMPANY_ID = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, companyId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                companyName = rs.getString("COMPANY_NAME");
                email = rs.getString("EMAIL");
                phone = rs.getString("PHONE");
                address = rs.getString("ADDRESS");
                website = rs.getString("WEBSITE");
                status = rs.getString("STATUS");
                logo = rs.getString("LOGO");
                banner = rs.getString("BANNER");
            } else {
                response.sendRedirect("company-login.jsp");
                return;
            }
        }

    } catch (Exception e) {
        application.log("Unable to load company profile.", e);
        throw new ServletException("Unable to load company profile.", e);
    }

    String contextPath = request.getContextPath();

    String logoUrl = imagePath(logo, contextPath);
    String bannerUrl = imagePath(banner, contextPath);

    String initial = companyName != null && !companyName.isEmpty()
                     ? companyName.substring(0, 1).toUpperCase()
                     : "C";
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit Company Profile - CampusConnect</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f4f7fb;
            color: #0f355b;
        }

        .top-header {
            background: white;
            padding: 28px 60px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            margin: 0;
            font-size: 34px;
            font-weight: 700;
            color: #0b355d;
        }

        .page-subtitle {
            margin-top: 6px;
            font-size: 16px;
            color: #7185a0;
        }

        .back-link {
            text-decoration: none;
            color: #0878e8;
            font-size: 16px;
            font-weight: 600;
        }

        .main-container {
            max-width: 1050px;
            margin: 40px auto;
            padding: 0 25px;
        }

        .company-header {
            background: linear-gradient(110deg, #155b96, #087bea);
            border-radius: 20px;
            padding: 30px 35px;
            display: flex;
            align-items: center;
            gap: 22px;
            color: white;
            box-shadow: 0 12px 30px rgba(20, 91, 150, 0.18);
            margin-bottom: 28px;
        }

        .company-logo-box {
            width: 90px;
            height: 90px;
            background: white;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            flex-shrink: 0;
        }

        .company-logo-box img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .company-initial {
            font-size: 38px;
            font-weight: 700;
            color: #087bea;
        }

        .company-name {
            margin: 0;
            font-size: 28px;
            color: white;
        }

        .company-email {
            margin-top: 5px;
            color: rgba(255,255,255,0.9);
            font-size: 15px;
        }

        .form-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            box-shadow: 0 8px 25px rgba(15, 53, 91, 0.06);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .form-header {
            padding: 30px 35px;
            border-bottom: 1px solid #e8edf3;
        }

        .form-title {
            margin: 0;
            font-size: 24px;
            color: #0b355d;
        }

        .form-description {
            margin: 7px 0 0;
            color: #7185a0;
            font-size: 15px;
        }

        .form-body {
            padding: 35px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 26px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        label {
            font-size: 15px;
            font-weight: 600;
            color: #24496f;
        }

        input,
        textarea {
            width: 100%;
            padding: 14px 15px;
            border: 1px solid #cfd9e5;
            border-radius: 9px;
            font-family: inherit;
            font-size: 15px;
            color: #163d65;
            background: white;
            outline: none;
        }

        input:focus,
        textarea:focus {
            border-color: #087bea;
            box-shadow: 0 0 0 3px rgba(8,123,234,0.10);
        }

        input[readonly] {
            background: #f1f5f9;
            color: #7185a0;
            cursor: not-allowed;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .status-box {
            padding: 14px 15px;
            border-radius: 9px;
            border: 1px solid #bfe7d0;
            background: #ecfaf2;
            color: #087a49;
            font-weight: 700;
        }

        .upload-box {
            border: 1px dashed #9bb8d5;
            border-radius: 12px;
            padding: 18px;
            background: #f8fbff;
        }

        .image-preview {
            width: 150px;
            height: 110px;
            border-radius: 10px;
            border: 1px solid #dce5ef;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            margin-bottom: 15px;
            color: #7185a0;
        }

        .image-preview img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .banner-preview {
            width: 100%;
            height: 150px;
        }

        .banner-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .help-text {
            color: #7185a0;
            font-size: 13px;
            line-height: 1.5;
        }

        .button-area {
            margin-top: 32px;
            padding-top: 25px;
            border-top: 1px solid #e8edf3;
            display: flex;
            gap: 12px;
        }

        .button {
            display: inline-block;
            padding: 13px 25px;
            border-radius: 9px;
            font-family: inherit;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            border: none;
        }

        .save-button {
            background: #087bea;
            color: white;
        }

        .save-button:hover {
            background: #0568ca;
        }

        .reset-button,
        .cancel-button {
            background: white;
            color: #24496f;
            border: 1px solid #cfd9e5;
        }

        .status-message {
            display: none;
            padding: 14px;
            margin-bottom: 20px;
            border-radius: 9px;
            font-weight: 600;
        }

        .status-message.success {
            display: block;
            background: #ecfaf2;
            color: #087a49;
        }

        .status-message.error {
            display: block;
            background: #fff0f0;
            color: #c62828;
        }

        @media (max-width: 750px) {
            .top-header {
                padding: 25px;
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: auto;
            }

            .form-body {
                padding: 25px;
            }
        }

        @media (max-width: 500px) {
            .button-area {
                flex-direction: column;
            }

            .button {
                text-align: center;
                width: 100%;
            }
        }
    </style>
</head>


<body>

<header class="top-header">

    <div>
        <h1 class="page-title">Edit Company Profile</h1>
        <div class="page-subtitle">
            Update your company information and branding
        </div>
    </div>

    <a href="company-profile.jsp" class="back-link">
        Back to Profile
    </a>

</header>

<div class="main-container">

    <!-- COMPANY HEADER -->

    <div class="company-header">

        <div class="company-logo-box">

            <% if (!logoUrl.isEmpty()) { %>

                <img src="<%= escapeHtml(logoUrl) %>"
                     alt="Company Logo"
                     onerror="this.style.display='none';">

            <% } else { %>

                <span class="company-initial">
                    <%= escapeHtml(initial) %>
                </span>

            <% } %>

        </div>

        <div>
            <h2 class="company-name">
                <%= escapeHtml(companyName) %>
            </h2>

            <div class="company-email">
                <%= escapeHtml(email) %>
            </div>
        </div>

    </div>


    <!-- EDIT FORM -->

    <div class="form-card">

        <div class="form-header">

            <h2 class="form-title">Company Information</h2>

            <p class="form-description">
                Update your company details, logo and banner.
            </p>

        </div>

        <div class="form-body">

            <div id="statusMessage" class="status-message"></div>

            <form id="companyEditForm"
                  method="post"
                  action="<%= contextPath %>/CompanyUpdateServlet"
                  enctype="multipart/form-data">

                <div class="form-grid">

                    <!-- COMPANY ID -->

                    <div class="form-group">

                        <label>Company ID</label>

                        <input type="text"
                               value="<%= companyId %>"
                               readonly>

                    </div>


                    <!-- COMPANY NAME -->

                    <div class="form-group">

                        <label>Company Name *</label>

                        <input type="text"
                               name="companyName"
                               value="<%= escapeHtml(companyName) %>"
                               required
                               maxlength="100">

                    </div>


                    <!-- EMAIL -->

                    <div class="form-group">

                        <label>Email Address</label>

                        <input type="email"
                               value="<%= escapeHtml(email) %>"
                               readonly>

                    </div>


                    <!-- PHONE -->

                    <div class="form-group">

                        <label>Phone Number</label>

                        <input type="text"
                               name="phone"
                               value="<%= escapeHtml(phone) %>"
                               maxlength="20">

                    </div>


                    <!-- ADDRESS -->

                    <div class="form-group full-width">

                        <label>Company Address</label>

                        <textarea name="address"
                                  maxlength="200"><%= escapeHtml(address) %></textarea>

                    </div>


                    <!-- WEBSITE -->

                    <div class="form-group">

                        <label>Official Website</label>

                        <input type="text"
                               name="website"
                               value="<%= escapeHtml(website) %>"
                               maxlength="200">

                    </div>


                    <!-- STATUS -->

                    <div class="form-group">

                        <label>Account Status</label>

                        <div class="status-box">
                            <%= escapeHtml(status) %>
                        </div>

                    </div>


                    <!-- LOGO UPLOAD -->

                    <div class="form-group full-width">

                        <label>Company Logo</label>

                        <div class="upload-box">

                            <div class="image-preview" id="logoPreview">

                                <% if (!logoUrl.isEmpty()) { %>

                                    <img src="<%= escapeHtml(logoUrl) %>"
                                         alt="Current Logo">

                                <% } else { %>

                                    Current Logo

                                <% } %>

                            </div>

                            <input type="file"
                                   id="logoFile"
                                   name="logoFile"
                                   accept=".png,.jpg,.jpeg,.webp,image/png,image/jpeg,image/webp">

                            <p class="help-text">
                                Select a new logo to replace the current one.
                                Allowed: PNG, JPG, JPEG, WEBP. Maximum 5 MB.
                                Leave empty to keep the existing logo.
                            </p>

                        </div>

                    </div>


                    <!-- BANNER UPLOAD -->

                    <div class="form-group full-width">

                        <label>Company Banner</label>

                        <div class="upload-box">

                            <div class="image-preview banner-preview"
                                 id="bannerPreview">

                                <% if (!bannerUrl.isEmpty()) { %>

                                    <img src="<%= escapeHtml(bannerUrl) %>"
                                         alt="Current Banner">

                                <% } else { %>

                                    Current Banner

                                <% } %>

                            </div>

                            <input type="file"
                                   id="bannerFile"
                                   name="bannerFile"
                                   accept=".png,.jpg,.jpeg,.webp,image/png,image/jpeg,image/webp">

                            <p class="help-text">
                                Select a new banner to replace the current one.
                                Allowed: PNG, JPG, JPEG, WEBP. Maximum 5 MB.
                                Leave empty to keep the existing banner.
                            </p>

                        </div>

                    </div>

                </div>


                <!-- BUTTONS -->

                <div class="button-area">

                    <button type="submit"
                            class="button save-button"
                            id="saveButton">

                        Save Changes

                    </button>

                    <button type="reset"
                            class="button reset-button">

                        Reset

                    </button>

                    <a href="company-profile.jsp"
                       class="button cancel-button">

                        Cancel

                    </a>

                </div>

            </form>

        </div>

    </div>

</div>


<script>

    const form = document.getElementById("companyEditForm");
    const statusMessage = document.getElementById("statusMessage");
    const saveButton = document.getElementById("saveButton");

    // Logo preview

    document.getElementById("logoFile").addEventListener("change", function() {

        const file = this.files[0];

        if (!file) return;

        if (!file.type.startsWith("image/")) {
            alert("Please select a valid image.");
            this.value = "";
            return;
        }

        document.getElementById("logoPreview").innerHTML =
            '<img src="' + URL.createObjectURL(file) + '" alt="Logo Preview">';

    });


    // Banner preview

    document.getElementById("bannerFile").addEventListener("change", function() {

        const file = this.files[0];

        if (!file) return;

        if (!file.type.startsWith("image/")) {
            alert("Please select a valid image.");
            this.value = "";
            return;
        }

        document.getElementById("bannerPreview").innerHTML =
            '<img src="' + URL.createObjectURL(file) + '" alt="Banner Preview">';

    });


    // Form submission

    form.addEventListener("submit", async function(event) {

        event.preventDefault();

        statusMessage.className = "status-message";
        statusMessage.textContent = "";

        saveButton.disabled = true;
        saveButton.textContent = "Updating...";

        try {

            const response = await fetch(form.action, {
                method: "POST",
                body: new FormData(form),
                headers: {
                    "Accept": "application/json"
                }
            });

            const result = await response.json();

            statusMessage.textContent = result.message;

            if (response.ok && result.success) {

                statusMessage.className = "status-message success";

                saveButton.textContent = "Updated";

                setTimeout(function() {
                    window.location.href = "company-profile.jsp";
                }, 1200);

            } else {

                statusMessage.className = "status-message error";

                saveButton.disabled = false;
                saveButton.textContent = "Save Changes";
            }

        } catch (error) {

            statusMessage.textContent =
                "Could not connect to the server. Please try again.";

            statusMessage.className = "status-message error";

            saveButton.disabled = false;
            saveButton.textContent = "Save Changes";
        }

    });

</script>

</body>
</html>
