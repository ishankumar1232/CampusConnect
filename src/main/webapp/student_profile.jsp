<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
    HttpSession session1 = request.getSession(false);

    if (session1 == null || session1.getAttribute("studentId") == null) {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = Integer.parseInt(
        session1.getAttribute("studentId").toString()
    );

    String name = "";
    String email = "";
    String phone = "";
    String dob = "";
    String gender = "";
    String address = "";
    String collegeName = "";
    String courseName = "";
    String admissionDate = "";
    String status = "";
    String profileImage = "";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        try (
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );
            PreparedStatement ps = con.prepareStatement(
                "SELECT S.NAME, S.EMAIL, S.PHONE, S.DOB, " +
                "S.GENDER, S.ADDRESS, S.ADMISSION_DATE, S.STATUS, " +
                "S.PROFILE_IMAGE, C.COLLEGE_NAME, CR.COURSE_NAME " +
                "FROM STUDENT S " +
                "LEFT JOIN COLLEGE C ON S.COLLEGE_ID = C.COLLEGE_ID " +
                "LEFT JOIN COURSE CR ON S.COURSE_ID = CR.COURSE_ID " +
                "WHERE S.STUDENT_ID = ?"
            )
        ) {
            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    name = rs.getString("NAME");
                    email = rs.getString("EMAIL");
                    phone = rs.getString("PHONE");
                    dob = rs.getDate("DOB") == null
                        ? "" : rs.getDate("DOB").toString();
                    gender = rs.getString("GENDER");
                    address = rs.getString("ADDRESS");
                    collegeName = rs.getString("COLLEGE_NAME");
                    courseName = rs.getString("COURSE_NAME");
                    admissionDate = rs.getDate("ADMISSION_DATE") == null
                        ? "" : rs.getDate("ADMISSION_DATE").toString();
                    status = rs.getString("STATUS");
                    profileImage = rs.getString("PROFILE_IMAGE");

                    if (name != null && !name.trim().isEmpty()) {
                        session1.setAttribute("studentName", name);
                    }
                }
            }
        }
    } catch (Exception e) {
        application.log("Error loading student profile", e);
        out.println("<p class='server-error'>Unable to load profile information. Please check the server log.</p>");
    }

    if (name == null) name = "";
    if (email == null) email = "";
    if (phone == null) phone = "";
    if (gender == null) gender = "";
    if (address == null) address = "";
    if (collegeName == null) collegeName = "";
    if (courseName == null) courseName = "";
    if (status == null) status = "";
    if (profileImage == null) profileImage = "";

    String firstLetter = name.trim().isEmpty()
        ? "S" : name.trim().substring(0, 1).toUpperCase();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Profile | CampusConnect</title>

<style>
:root {
    --navy: #0b1835;
    --navy-light: #173361;
    --blue: #2878ef;
    --text: #172c4b;
    --muted: #7486a0;
    --border: #e2eaf5;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    color: var(--text);
    min-height: 100vh;
    background:
        radial-gradient(circle at 85% 5%, #dcecff, transparent 32%),
        linear-gradient(135deg, #f4f7ff, #eaf3fd);
}

a {
    text-decoration: none;
    color: inherit;
}

/* HEADER */
.topbar {
    height: 76px;
    background: linear-gradient(110deg, #08142d, #142b52);
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 5%;
    position: sticky;
    top: 0;
    z-index: 10;
    box-shadow: 0 5px 20px rgba(8,21,47,.16);
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 23px;
    font-weight: 800;
}

.brand-mark {
    width: 40px;
    height: 40px;
    display: grid;
    place-items: center;
    background: linear-gradient(135deg, #327ff4, #62b5ff);
    border-radius: 12px;
    font-size: 23px;
}

.brand span {
    color: #79b7ff;
}

.dashboard-link {
    padding: 10px 17px;
    border: 1px solid #4c6b9b;
    border-radius: 9px;
    color: white;
    font-size: 13px;
    transition: .2s;
}

.dashboard-link:hover {
    background: var(--blue);
}

/* PAGE */
.container {
    max-width: 1250px;
    margin: 35px auto;
    padding: 0 25px;
}

.page-heading {
    margin-bottom: 25px;
}

.page-heading .eyebrow {
    color: var(--blue);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 2px;
}

.page-heading h1 {
    margin: 8px 0;
    font-size: 31px;
    color: #153463;
}

.page-heading p {
    color: var(--muted);
    font-size: 14px;
}

/* MESSAGES */
.message {
    padding: 13px 16px;
    border-radius: 10px;
    margin-bottom: 20px;
    font-size: 14px;
}

.success {
    color: #17613c;
    background: #e1f7e9;
    border: 1px solid #bde8cd;
}

.error {
    color: #9e2939;
    background: #fff0f1;
    border: 1px solid #f3c8ce;
}

/* PROFILE HERO */
.profile-hero {
    display: flex;
    align-items: center;
    gap: 25px;
    padding: 28px;
    border-radius: 19px;
    color: white;
    background:
        radial-gradient(circle at 90% 140%, rgba(71,144,255,.25), transparent 38%),
        linear-gradient(110deg, #101b37, #173361 72%, #1c477f);
    box-shadow: 0 14px 30px rgba(18,43,86,.13);
    margin-bottom: 25px;
}

.photo-wrap {
    width: 112px;
    height: 112px;
    flex-shrink: 0;
    border: 3px solid #8fc2ff;
    border-radius: 50%;
    overflow: hidden;
    background: #244775;
}

.profile-photo {
    width: 100%;
    height: 100%;
    display: block;
    object-fit: cover;
}

.profile-initial {
    width: 100%;
    height: 100%;
    display: grid;
    place-items: center;
    color: white;
    font-size: 39px;
    font-weight: 800;
}

.profile-hero h2 {
    font-size: 27px;
    margin-bottom: 9px;
}

.profile-hero p {
    font-size: 13px;
    color: #d5e5ff;
    margin: 5px 0;
}

.student-id {
    display: inline-block;
    margin-top: 5px;
    padding: 5px 10px;
    border-radius: 7px;
    background: rgba(255,255,255,.12);
    color: #e4efff;
    font-size: 12px;
}

/* INFORMATION GRID */
.info-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 22px;
}

.panel {
    background: rgba(255,255,255,.88);
    border: 1px solid rgba(255,255,255,.95);
    border-radius: 16px;
    padding: 25px;
    box-shadow: 0 8px 25px rgba(36,67,112,.07);
}

.panel h2 {
    font-size: 20px;
    color: #173b70;
    padding-bottom: 15px;
    margin-bottom: 10px;
    border-bottom: 1px solid var(--border);
}

.detail {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 20px;
    padding: 14px 0;
    border-bottom: 1px solid #edf1f7;
}

.detail:last-child {
    border-bottom: none;
}

.label {
    font-weight: 650;
    color: #52637b;
    font-size: 13px;
    flex-shrink: 0;
}

.value {
    color: #172c4b;
    font-size: 13px;
    text-align: right;
    overflow-wrap: anywhere;
}

.status {
    display: inline-block;
    padding: 5px 11px;
    border-radius: 20px;
    background: #d9f4e2;
    color: #167444;
    font-size: 11px;
    font-weight: 800;
}

/* BUTTONS */
.actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 22px;
}

.btn {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    border: none;
    border-radius: 9px;
    padding: 12px 19px;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
    transition: .2s;
}

.btn-primary {
    background: linear-gradient(135deg, #1764d9, #348cf7);
    color: white;
    box-shadow: 0 5px 13px rgba(40,120,239,.18);
}

.btn-primary:hover {
    transform: translateY(-2px);
}

.btn-secondary {
    background: #edf3fb;
    color: #24456f;
}

.btn-secondary:hover {
    background: #dce9fb;
}

/* EDIT FORM */
.edit-panel {
    margin-top: 24px;
    display: none;
}

.edit-panel.active {
    display: block;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 18px;
}

.form-group {
    margin-bottom: 4px;
}

.form-group.full {
    grid-column: 1 / -1;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-size: 13px;
    font-weight: 700;
    color: #52637b;
}

.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 12px 13px;
    border: 1px solid #dbe4f0;
    border-radius: 9px;
    background: #fbfdff;
    color: #172c4b;
    font-family: inherit;
    font-size: 14px;
    outline: none;
    transition: border-color .2s, box-shadow .2s;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    border-color: #5a9bfa;
    box-shadow: 0 0 0 3px rgba(40,120,239,.1);
}

.form-group textarea {
    min-height: 95px;
    resize: vertical;
}

.form-group small {
    display: block;
    margin-top: 7px;
    color: var(--muted);
    font-size: 11px;
}

/* FOOTER */
.footer {
    padding: 30px 10px 15px;
    text-align: center;
    color: #8292aa;
    font-size: 11px;
}

/* RESPONSIVE */
@media(max-width: 800px) {
    .info-grid {
        grid-template-columns: 1fr;
    }

    .container {
        margin-top: 25px;
    }
}

@media(max-width: 520px) {
    .topbar {
        height: 65px;
        padding: 0 13px;
    }

    .brand {
        font-size: 17px;
        gap: 7px;
    }

    .brand-mark {
        width: 32px;
        height: 32px;
        font-size: 18px;
    }

    .dashboard-link {
        padding: 9px 11px;
        font-size: 11px;
    }

    .container {
        padding: 0 13px;
        margin-top: 23px;
    }

    .page-heading h1 {
        font-size: 26px;
    }

    .profile-hero {
        flex-direction: column;
        align-items: flex-start;
        padding: 22px;
        gap: 16px;
    }

    .photo-wrap {
        width: 94px;
        height: 94px;
    }

    .profile-hero h2 {
        font-size: 23px;
    }

    .panel {
        padding: 19px;
    }

    .panel h2 {
        font-size: 18px;
    }

    .detail {
        gap: 12px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .form-group.full {
        grid-column: auto;
    }

    .actions .btn {
        width: 100%;
    }
}
</style>

<script>
function showEdit() {
    document.getElementById("editForm").classList.add("active");
    document.getElementById("editButton").style.display = "none";

    document.getElementById("editForm").scrollIntoView({
        behavior: "smooth",
        block: "start"
    });
}

function hideEdit() {
    document.getElementById("editForm").classList.remove("active");
    document.getElementById("editButton").style.display = "inline-flex";
}

window.addEventListener("DOMContentLoaded", function () {
    const params = new URLSearchParams(window.location.search);

    if (params.get("edit") === "1") {
        showEdit();
    }
});
</script>
</head>

<body>

<header class="topbar">
    <a href="student_dashboard.jsp" class="brand">
        <div class="brand-mark">&#10022;</div>
        <div>Campus<span>Connect</span></div>
    </a>

    <a href="student_dashboard.jsp" class="dashboard-link">
        Dashboard
    </a>
</header>

<main class="container">

    <div class="page-heading">
        <div class="eyebrow">STUDENT ACCOUNT</div>
        <h1>My Profile</h1>
        <p>View and manage your personal information.</p>
    </div>

    <% if ("1".equals(success)) { %>
        <div class="message success">
            Profile updated successfully.
        </div>
    <% } %>

    <% if ("1".equals(error)) { %>
        <div class="message error">
            Unable to update profile. Please try again.
        </div>
    <% } else if ("2".equals(error)) { %>
        <div class="message error">
            Please select a valid JPG, JPEG or PNG image.
        </div>
    <% } else if ("3".equals(error)) { %>
        <div class="message error">
            Please enter a valid date of birth.
        </div>
    <% } %>

    <!-- PROFILE HERO -->
    <section class="profile-hero">

        <div class="photo-wrap">
            <% if (!profileImage.trim().isEmpty()) { %>
                <img
                    class="profile-photo"
                    src="<%= request.getContextPath() %>/profile_images/<%= URLEncoder.encode(profileImage, StandardCharsets.UTF_8.name()) %>"
                    alt="Student Profile Photo">
            <% } else { %>
                <div class="profile-initial"><%= firstLetter %></div>
            <% } %>
        </div>

        <div>
            <h2><%= name.isEmpty() ? "Student" : name %></h2>

            <p>
                <%= courseName.isEmpty() ? "Course not available" : courseName %>
            </p>

            <p>
                <%= collegeName.isEmpty() ? "College not available" : collegeName %>
            </p>

            <span class="student-id">
                Student ID: <%= studentId %>
            </span>

            <div class="actions">
                <button type="button" id="editButton"
                        class="btn btn-primary" onclick="showEdit()">
                    Edit Profile
                </button>
            </div>
        </div>

    </section>

    <!-- INFORMATION CARDS -->
    <section class="info-grid">

        <div class="panel">
            <h2>Personal Information</h2>

            <div class="detail">
                <span class="label">Name</span>
                <span class="value"><%= name.isEmpty() ? "Not provided" : name %></span>
            </div>

            <div class="detail">
                <span class="label">Email</span>
                <span class="value"><%= email.isEmpty() ? "Not provided" : email %></span>
            </div>

            <div class="detail">
                <span class="label">Phone</span>
                <span class="value"><%= phone.isEmpty() ? "Not provided" : phone %></span>
            </div>

            <div class="detail">
                <span class="label">Date of Birth</span>
                <span class="value"><%= dob.isEmpty() ? "Not provided" : dob %></span>
            </div>

            <div class="detail">
                <span class="label">Gender</span>
                <span class="value"><%= gender.isEmpty() ? "Not provided" : gender %></span>
            </div>

            <div class="detail">
                <span class="label">Address</span>
                <span class="value"><%= address.isEmpty() ? "Not provided" : address %></span>
            </div>
        </div>

        <div class="panel">
            <h2>Academic Information</h2>

            <div class="detail">
                <span class="label">College</span>
                <span class="value"><%= collegeName.isEmpty() ? "Not available" : collegeName %></span>
            </div>

            <div class="detail">
                <span class="label">Course</span>
                <span class="value"><%= courseName.isEmpty() ? "Not available" : courseName %></span>
            </div>

            <div class="detail">
                <span class="label">Admission Date</span>
                <span class="value"><%= admissionDate.isEmpty() ? "Not available" : admissionDate %></span>
            </div>

            <div class="detail">
                <span class="label">Student Status</span>
                <span class="value">
                    <span class="status"><%= status.isEmpty() ? "UNKNOWN" : status %></span>
                </span>
            </div>
        </div>

    </section>

    <!-- EDIT PROFILE FORM -->
    <section id="editForm" class="panel edit-panel">

        <h2>Edit Personal Information</h2>

        <form action="<%= request.getContextPath() %>/StudentProfileServlet"
              method="post"
              enctype="multipart/form-data">

            <div class="form-grid">

                <div class="form-group full">
                    <label for="profileImage">Profile Photo</label>
                    <input type="file"
                           id="profileImage"
                           name="profileImage"
                           accept=".jpg,.jpeg,.png">
                    <small>JPG, JPEG or PNG only. Follow the size limit enforced by your servlet.</small>
                </div>

                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text"
                           id="name"
                           name="name"
                           value="<%= name %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text"
                           id="phone"
                           name="phone"
                           value="<%= phone %>"
                           maxlength="10"
                           pattern="[0-9]{10}"
                           title="Enter a 10-digit phone number"
                           required>
                </div>

                <div class="form-group">
                    <label for="dob">Date of Birth</label>
                    <input type="date"
                           id="dob"
                           name="dob"
                           value="<%= dob %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" required>
                        <option value="">Select Gender</option>

                        <option value="Male"
                            <%= "Male".equals(gender) ? "selected" : "" %>>
                            Male
                        </option>

                        <option value="Female"
                            <%= "Female".equals(gender) ? "selected" : "" %>>
                            Female
                        </option>

                        <option value="Other"
                            <%= "Other".equals(gender) ? "selected" : "" %>>
                            Other
                        </option>
                    </select>
                </div>

                <div class="form-group full">
                    <label for="address">Address</label>
                    <textarea id="address"
                              name="address"
                              required><%= address %></textarea>
                </div>

            </div>

            <div class="actions">
                <button type="submit" class="btn btn-primary">
                    Save Changes
                </button>

                <button type="button"
                        class="btn btn-secondary"
                        onclick="hideEdit()">
                    Cancel
                </button>
            </div>

        </form>
    </section>

    <footer class="footer">
        CampusConnect Student Portal
        <br>
        Campus Recruitment Management System
    </footer>

</main>

</body>
</html>