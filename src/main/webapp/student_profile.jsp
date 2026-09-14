<%@ page import="java.sql.*" %>

<%
    HttpSession session1 = request.getSession(false);

    if(session1 == null || session1.getAttribute("studentId") == null)
    {
        response.sendRedirect("student_login.jsp");
        return;
    }

    int studentId = (Integer)session1.getAttribute("studentId");

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

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        Connection con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String q =
            "SELECT S.NAME, S.EMAIL, S.PHONE, S.DOB, " +
            "S.GENDER, S.ADDRESS, S.ADMISSION_DATE, S.STATUS, " +
            "S.PROFILE_IMAGE, " +
            "C.COLLEGE_NAME, CR.COURSE_NAME " +
            "FROM STUDENT S " +
            "LEFT JOIN COLLEGE C " +
            "ON S.COLLEGE_ID=C.COLLEGE_ID " +
            "LEFT JOIN COURSE CR " +
            "ON S.COURSE_ID=CR.COURSE_ID " +
            "WHERE S.STUDENT_ID=?";

        PreparedStatement ps = con.prepareStatement(q);

        ps.setInt(1, studentId);

        ResultSet rs = ps.executeQuery();

        if(rs.next())
        {
            name = rs.getString("NAME");
            email = rs.getString("EMAIL");
            phone = rs.getString("PHONE");

            if(rs.getDate("DOB") != null)
            {
                dob = rs.getDate("DOB").toString();
            }

            gender = rs.getString("GENDER");
            address = rs.getString("ADDRESS");

            collegeName = rs.getString("COLLEGE_NAME");
            courseName = rs.getString("COURSE_NAME");

            if(rs.getDate("ADMISSION_DATE") != null)
            {
                admissionDate =
                    rs.getDate("ADMISSION_DATE").toString();
            }

            status = rs.getString("STATUS");

            profileImage =
                rs.getString("PROFILE_IMAGE");
        }

        rs.close();
        ps.close();
        con.close();
    }
    catch(Exception e)
    {
        out.println("<h3>Error: " + e + "</h3>");
    }
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Profile</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f4f7fb;
    color: #333;
}

/* Header */

.header {
    background: #123c88;
    color: white;
    padding: 20px 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.logo {
    font-size: 25px;
    font-weight: bold;
}

.logo span {
    color: #55aaff;
}

.header a {
    color: white;
    text-decoration: none;
    font-weight: bold;
}

/* Container */

.container {
    max-width: 1100px;
    margin: 35px auto;
    padding: 0 20px;
}

/* Page Title */

.page-title {
    margin-bottom: 25px;
}

.page-title h1 {
    color: #123c88;
    margin-bottom: 8px;
}

.page-title p {
    color: #777;
}

/* Profile Top */

.profile-top {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 10px #ddd;
    display: flex;
    align-items: center;
    gap: 20px;
    margin-bottom: 25px;
}

/* Profile Photo */

.profile-photo {
    width: 100px;
    height: 100px;
    flex-shrink: 0;
}

.profile-photo img {
    width: 100px;
    height: 100px;
    object-fit: cover;
    border-radius: 50%;
    border: 4px solid #1769e0;
}

.profile-circle {
    width: 100px;
    height: 100px;
    background: #1769e0;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 35px;
    font-weight: bold;
}

/* Profile Information */

.profile-info h2 {
    margin: 0;
    color: #123c88;
}

.profile-info p {
    margin: 7px 0;
    color: #666;
}

/* Cards */

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 25px;
}

.card {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 10px #ddd;
}

.card h2 {
    color: #123c88;
    margin-top: 0;
    border-bottom: 1px solid #ddd;
    padding-bottom: 12px;
}

/* Details */

.detail {
    display: flex;
    justify-content: space-between;
    gap: 20px;
    padding: 13px 0;
    border-bottom: 1px solid #eee;
}

.detail:last-child {
    border-bottom: none;
}

.label {
    font-weight: bold;
    color: #555;
}

.value {
    color: #333;
    text-align: right;
    word-break: break-word;
}

/* Edit Button */

.edit-button {
    margin-top: 20px;
    padding: 12px 20px;
    background: #1769e0;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 15px;
}

.edit-button:hover {
    background: #1258bd;
}

/* Edit Form */

.edit-form {
    display: none;
    margin-top: 25px;
}

.edit-form.active {
    display: block;
}

.form-group {
    margin-bottom: 18px;
}

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 7px;
}

.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 11px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    border-color: #1769e0;
    outline: none;
}

.form-group textarea {
    height: 90px;
    resize: vertical;
}

.form-group small {
    display: block;
    margin-top: 6px;
    color: #777;
}

/* Save Button */

.save-button {
    padding: 12px 22px;
    background: #27ae60;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 15px;
}

.save-button:hover {
    background: #219150;
}

/* Cancel Button */

.cancel-button {
    padding: 12px 22px;
    background: #777;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    margin-left: 8px;
    font-size: 15px;
}

.cancel-button:hover {
    background: #666;
}

/* Status */

.status {
    display: inline-block;
    padding: 5px 12px;
    background: #d4edda;
    color: #155724;
    border-radius: 15px;
    font-size: 13px;
    font-weight: bold;
}

/* Messages */

.success {
    background: #d4edda;
    color: #155724;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 20px;
}

.error {
    background: #f8d7da;
    color: #721c24;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 20px;
}

/* Back Button */

.back {
    display: inline-block;
    margin-top: 25px;
    color: #1769e0;
    text-decoration: none;
    font-weight: bold;
}

.back:hover {
    text-decoration: underline;
}

/* Responsive */

@media(max-width: 750px)
{
    .grid {
        grid-template-columns: 1fr;
    }

    .profile-top {
        flex-direction: column;
        text-align: center;
    }

    .header {
        padding: 18px 20px;
    }

    .container {
        margin-top: 20px;
    }

    .detail {
        flex-direction: column;
        gap: 5px;
    }

    .value {
        text-align: left;
    }
}

</style>

<script>

function showEdit()
{
    document.getElementById("editForm")
            .classList.add("active");

    document.getElementById("editButton")
            .style.display = "none";
}

function hideEdit()
{
    document.getElementById("editForm")
            .classList.remove("active");

    document.getElementById("editButton")
            .style.display = "inline-block";
}

</script>

</head>

<body>

<!-- Header -->

<div class="header">

    <div class="logo">
        Campus<span>Connect</span>
    </div>

    <a href="student_dashboard.jsp">
        Dashboard
    </a>

</div>


<!-- Main Container -->

<div class="container">


    <!-- Page Title -->

    <div class="page-title">

        <h1>My Profile &#128100;</h1>

        <p>
            View and manage your personal information
        </p>

    </div>


    <!-- Messages -->

<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    if("1".equals(success))
    {
%>

    <div class="success">
        Profile updated successfully.
    </div>

<%
    }

    if("1".equals(error))
    {
%>

    <div class="error">
        Unable to update profile. Please try again.
    </div>

<%
    }

    if("2".equals(error))
    {
%>

    <div class="error">
        Please select a JPG, JPEG or PNG image.
    </div>

<%
    }

    if("3".equals(error))
    {
%>

    <div class="error">
        Please enter a valid date of birth.
    </div>

<%
    }
%>


    <!-- Profile Header -->

    <div class="profile-top">

        <div class="profile-photo">

<%
            if(profileImage != null &&
               !profileImage.equals(""))
            {
%>

            <img src="profile_images/<%=profileImage%>"
                 alt="Profile Photo">

<%
            }
            else
            {
%>

            <div class="profile-circle">

                <%=name.length() > 0
                    ? name.substring(0,1).toUpperCase()
                    : "S"%>

            </div>

<%
            }
%>

        </div>


        <div class="profile-info">

            <h2>
                <%=name%>
            </h2>

            <p>
                Student ID:
                <strong><%=studentId%></strong>
            </p>

            <p>
                <%=courseName%>
            </p>

        </div>

    </div>


    <!-- Information Cards -->

    <div class="grid">


        <!-- Personal Information -->

        <div class="card">

            <h2>Personal Information</h2>


            <div class="detail">

                <span class="label">
                    Name
                </span>

                <span class="value">
                    <%=name%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Email
                </span>

                <span class="value">
                    <%=email%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Phone
                </span>

                <span class="value">
                    <%=phone%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Date of Birth
                </span>

                <span class="value">
                    <%=dob%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Gender
                </span>

                <span class="value">
                    <%=gender%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Address
                </span>

                <span class="value">
                    <%=address%>
                </span>

            </div>


            <button id="editButton"
                    class="edit-button"
                    onclick="showEdit()">

                Edit Profile

            </button>

        </div>


        <!-- Academic Information -->

        <div class="card">

            <h2>Academic Information</h2>


            <div class="detail">

                <span class="label">
                    College
                </span>

                <span class="value">
                    <%=collegeName%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Course
                </span>

                <span class="value">
                    <%=courseName%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Admission Date
                </span>

                <span class="value">
                    <%=admissionDate%>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Student Status
                </span>

                <span class="value">

                    <span class="status">
                        <%=status%>
                    </span>

                </span>

            </div>

        </div>

    </div>


    <!-- Edit Profile Form -->

    <div id="editForm"
         class="card edit-form">

        <h2>Edit Personal Information</h2>


        <form action="StudentProfileServlet"
              method="post"
              enctype="multipart/form-data">


            <!-- Profile Photo -->

            <div class="form-group">

                <label>
                    Profile Photo &#128100;
                </label>

                <input type="file"
                       name="profileImage"
                       accept=".jpg,.jpeg,.png">

                <small>
                    JPG, JPEG or PNG only. Maximum size 5 MB.
                </small>

            </div>


            <!-- Name -->

            <div class="form-group">

                <label>
                    Name
                </label>

                <input type="text"
                       name="name"
                       value="<%=name%>"
                       required>

            </div>


            <!-- Phone -->

            <div class="form-group">

                <label>
                    Phone
                </label>

                <input type="text"
                       name="phone"
                       value="<%=phone%>"
                       maxlength="10"
                       pattern="[0-9]{10}"
                       required>

            </div>


            <!-- Date of Birth -->

            <div class="form-group">

                <label>
                    Date of Birth
                </label>

                <input type="date"
                       name="dob"
                       value="<%=dob%>"
                       required>

            </div>


            <!-- Gender -->

            <div class="form-group">

                <label>
                    Gender
                </label>

                <select name="gender" required>

                    <option value="">
                        Select Gender
                    </option>

                    <option value="Male"
                        <%= "Male".equals(gender)
                            ? "selected" : "" %>>
                        Male
                    </option>

                    <option value="Female"
                        <%= "Female".equals(gender)
                            ? "selected" : "" %>>
                        Female
                    </option>

                    <option value="Other"
                        <%= "Other".equals(gender)
                            ? "selected" : "" %>>
                        Other
                    </option>

                </select>

            </div>


            <!-- Address -->

            <div class="form-group">

                <label>
                    Address
                </label>

                <textarea name="address"
                          required><%=address%></textarea>

            </div>


            <!-- Buttons -->

            <button type="submit"
                    class="save-button">

                Save Changes

            </button>


            <button type="button"
                    class="cancel-button"
                    onclick="hideEdit()">

                Cancel

            </button>

        </form>

    </div>


    <!-- Back -->

    <a href="student_dashboard.jsp"
       class="back">

        Back to Dashboard

    </a>

</div>

</body>

</html>