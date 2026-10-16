<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>

<%

    Integer collegeId =
        (Integer) session.getAttribute("collegeId");


    if(collegeId == null)
    {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }


    String collegeName = "";
    String address = "";
    String city = "";
    String state = "";
    String email = "";
    String phone = "";
    String status = "";

    String logoImage = "";
    String coverImage = "";


    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;


    try
    {

        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );


        con = DriverManager.getConnection(

            "jdbc:oracle:thin:@localhost:1521:XE",

            "CAMPUSCONNECT",

            "campus123"

        );


        String sql =

            "SELECT COLLEGE_NAME, ADDRESS, CITY, STATE, " +
            "EMAIL, PHONE, STATUS, LOGO_IMAGE, COVER_IMAGE " +
            "FROM COLLEGE " +
            "WHERE COLLEGE_ID=?";


        ps = con.prepareStatement(sql);

        ps.setInt(1, collegeId);

        rs = ps.executeQuery();


        if(rs.next())
        {

            collegeName =
                rs.getString("COLLEGE_NAME");

            address =
                rs.getString("ADDRESS");

            city =
                rs.getString("CITY");

            state =
                rs.getString("STATE");

            email =
                rs.getString("EMAIL");

            phone =
                rs.getString("PHONE");

            status =
                rs.getString("STATUS");

            logoImage =
                rs.getString("LOGO_IMAGE");

            coverImage =
                rs.getString("COVER_IMAGE");

        }

    }
    catch(Exception e)
    {

        out.println(
            "<h3>Error: " +
            e.getMessage() +
            "</h3>"
        );

    }
    finally
    {

        if(rs != null)
        {
            try
            {
                rs.close();
            }
            catch(Exception e)
            {
            }
        }


        if(ps != null)
        {
            try
            {
                ps.close();
            }
            catch(Exception e)
            {
            }
        }


        if(con != null)
        {
            try
            {
                con.close();
            }
            catch(Exception e)
            {
            }
        }

    }

%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>College Profile</title>


<style>

/* =====================================================
   BASIC
===================================================== */

* {

    margin: 0;

    padding: 0;

    box-sizing: border-box;

}


body {

    font-family: Arial, sans-serif;

    background: #f4f7fb;

    color: #173b5c;

}


/* =====================================================
   HEADER
===================================================== */

.header {

    background: linear-gradient(
        135deg,
        #07385e,
        #0d5b8f
    );

    color: white;

    padding: 22px 35px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    box-shadow:
        0 3px 12px rgba(0,0,0,0.12);

}


.header-left {

    display: flex;

    align-items: center;

    gap: 15px;

}


.header-icon {

    width: 50px;

    height: 50px;

    border-radius: 12px;

    background:
        rgba(255,255,255,0.15);

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 26px;

}


.header-title {

    font-size: 29px;

    font-weight: bold;

}


.header-subtitle {

    margin-top: 5px;

    color: #c8ddeb;

    font-size: 13px;

}


/* =====================================================
   CONTAINER
===================================================== */

.container {

    width: 92%;

    max-width: 1250px;

    margin: 25px auto 50px;

}


/* =====================================================
   BACK
===================================================== */

.back {

    margin-bottom: 18px;

}


.back a {

    display: inline-flex;

    align-items: center;

    gap: 7px;

    padding: 9px 14px;

    border-radius: 8px;

    color: #1685ed;

    text-decoration: none;

    font-size: 15px;

    font-weight: bold;

}


.back a:hover {

    background: #e7f3fc;

}


/* =====================================================
   COLLEGE COVER
===================================================== */

.college-cover {

    position: relative;

    width: 100%;

    height: 285px;

    border-radius: 17px;

    overflow: hidden;

    background: #0a3c61;

    box-shadow:
        0 6px 22px rgba(0,0,0,0.12);

}


.college-cover img.cover {

    width: 100%;

    height: 100%;

    object-fit: cover;

}


.cover-overlay {

    position: absolute;

    inset: 0;

    background:
        linear-gradient(
            90deg,
            rgba(3,35,60,0.96),
            rgba(5,59,91,0.65),
            rgba(5,59,91,0.08)
        );

}


/* =====================================================
   COVER CONTENT
===================================================== */

.cover-content {

    position: absolute;

    left: 42px;

    bottom: 35px;

    display: flex;

    align-items: center;

    gap: 23px;

    color: white;

}


.college-logo {

    width: 130px;

    height: 130px;

    border-radius: 50%;

    object-fit: cover;

    background: white;

    border: 5px solid white;

    padding: 5px;

    box-shadow:
        0 4px 15px rgba(0,0,0,0.25);

}


.college-logo-fallback {

    width: 130px;

    height: 130px;

    border-radius: 50%;

    background: white;

    border: 5px solid white;

    display: flex;

    align-items: center;

    justify-content: center;

    color: #1685ed;

    font-size: 27px;

    font-weight: bold;

    box-shadow:
        0 4px 15px rgba(0,0,0,0.25);

}


.cover-name {

    font-size: 31px;

    font-weight: bold;

    margin-bottom: 10px;

}


.cover-location {

    font-size: 15px;

    color: #d8e9f4;

}


.cover-status {

    display: inline-block;

    margin-top: 12px;

    padding: 7px 14px;

    border-radius: 20px;

    background: #d9f7e5;

    color: #177744;

    font-size: 12px;

    font-weight: bold;

}


/* =====================================================
   MAIN GRID
===================================================== */

.main-grid {

    display: grid;

    grid-template-columns:
        340px 1fr;

    gap: 22px;

    margin-top: 22px;

}


/* =====================================================
   CARD
===================================================== */

.card {

    background: white;

    border-radius: 16px;

    padding: 24px;

    border: 1px solid #e2ebf2;

    box-shadow:
        0 5px 18px rgba(0,0,0,0.07);

}


.card-title {

    display: flex;

    align-items: center;

    gap: 10px;

    color: #183f60;

    font-size: 20px;

    font-weight: bold;

    margin-bottom: 20px;

}


.card-icon {

    width: 38px;

    height: 38px;

    border-radius: 9px;

    background: #e8f4ff;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 20px;

}


/* =====================================================
   IMAGE PREVIEW
===================================================== */

.preview-title {

    color: #607689;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 10px;

}


.logo-preview {

    width: 155px;

    height: 155px;

    border-radius: 50%;

    object-fit: cover;

    border: 5px solid #e8f2f8;

    background: white;

    padding: 5px;

    display: block;

    margin: 0 auto 25px;

}


.cover-preview {

    width: 100%;

    height: 130px;

    object-fit: cover;

    border-radius: 10px;

    border: 1px solid #dce6ed;

}


.preview-block {

    text-align: center;

    margin-bottom: 24px;

}


.info-box {

    padding: 14px;

    background: #eff8ff;

    border-left: 4px solid #1685ed;

    border-radius: 8px;

    color: #5b7080;

    font-size: 12px;

    line-height: 1.6;

}


/* =====================================================
   FORM
===================================================== */

.form-grid {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 17px;

}


.form-group {

    display: flex;

    flex-direction: column;

}


.form-group.full {

    grid-column: 1 / -1;

}


label {

    color: #3d566b;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 7px;

}


input {

    width: 100%;

    padding: 12px 13px;

    border: 1px solid #d1dce5;

    border-radius: 8px;

    outline: none;

    font-size: 14px;

    color: #253e52;

    background: white;

}


input:focus {

    border-color: #1685ed;

    box-shadow:
        0 0 0 3px rgba(22,133,237,0.10);

}


input[type="file"] {

    padding: 9px;

    background: #f8fafc;

}


.file-note {

    margin-top: 5px;

    color: #8998a5;

    font-size: 11px;

}


/* =====================================================
   BUTTON
===================================================== */

.button-area {

    margin-top: 25px;

    display: flex;

    justify-content: flex-end;

}


.update-btn {

    border: none;

    padding: 13px 25px;

    border-radius: 8px;

    background:
        linear-gradient(
            135deg,
            #1689ef,
            #0873cf
        );

    color: white;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    box-shadow:
        0 4px 12px rgba(22,137,239,0.22);

}


.update-btn:hover {

    background: #086dbd;

}


/* =====================================================
   STATUS CARD
===================================================== */

.status-box {

    margin-top: 22px;

    background: white;

    border-radius: 14px;

    padding: 17px 20px;

    border: 1px solid #e2ebf2;

    box-shadow:
        0 4px 15px rgba(0,0,0,0.06);

    display: flex;

    align-items: center;

    justify-content: space-between;

}


.status-left {

    display: flex;

    align-items: center;

    gap: 10px;

}


.status-icon {

    width: 35px;

    height: 35px;

    border-radius: 50%;

    background: #e4f8eb;

    display: flex;

    align-items: center;

    justify-content: center;

    color: #168044;

}


.status-label {

    color: #65798a;

    font-size: 13px;

}


.status-value {

    color: #168044;

    font-weight: bold;

    font-size: 13px;

}


/* =====================================================
   RESPONSIVE
===================================================== */

@media(max-width: 950px)
{

    .main-grid {

        grid-template-columns: 1fr;

    }

}


@media(max-width: 650px)
{

    .header {

        padding: 18px;

    }


    .header-title {

        font-size: 22px;

    }


    .container {

        width: 94%;

    }


    .college-cover {

        height: 330px;

    }


    .cover-content {

        left: 20px;

        bottom: 25px;

        gap: 15px;

    }


    .college-logo,
    .college-logo-fallback {

        width: 95px;

        height: 95px;

    }


    .cover-name {

        font-size: 21px;

    }


    .form-grid {

        grid-template-columns: 1fr;

    }


    .form-group.full {

        grid-column: auto;

    }


    .status-box {

        align-items: flex-start;

        gap: 10px;

        flex-direction: column;

    }

}

</style>

</head>


<body>


<!-- =====================================================
     HEADER
===================================================== -->

<div class="header">


    <div class="header-left">


        <div class="header-icon">
            🏫
        </div>


        <div>

            <div class="header-title">
                College Profile
            </div>

            <div class="header-subtitle">
                Manage your college information and branding
            </div>

        </div>


    </div>


</div>



<!-- =====================================================
     CONTAINER
===================================================== -->

<div class="container">


    <!-- BACK -->

    <div class="back">

        <a href="collegeAdminDashboard.jsp">

            ← Back to Dashboard

        </a>

    </div>



    <!-- =================================================
         COVER
    ================================================== -->

    <div class="college-cover">


        <%

            if(coverImage != null &&
               !coverImage.trim().equals(""))

            {

        %>


            <img
                src="college_images/<%=coverImage%>"
                class="cover"
                alt="College Cover"
            >


        <%

            }

            else

            {

        %>


            <img
                src="images/college-banner.jpg"
                class="cover"
                alt="College Cover"
            >


        <%

            }

        %>


        <div class="cover-overlay"></div>


        <div class="cover-content">


            <%

                if(logoImage != null &&
                   !logoImage.trim().equals(""))

                {

            %>


                <img
                    src="college_images/<%=logoImage%>"
                    class="college-logo"
                    alt="College Logo"
                >


            <%

                }

                else

                {

            %>


                <div class="college-logo-fallback">

                    CC

                </div>


            <%

                }

            %>


            <div>


                <div class="cover-name">

                    <%=collegeName%>

                </div>


                <div class="cover-location">

                    📍 <%=city%>, <%=state%>

                </div>


                <%

                    if(status != null &&
                       status.equalsIgnoreCase("APPROVED"))

                    {

                %>


                    <div class="cover-status">

                        ✓ APPROVED

                    </div>


                <%

                    }

                    else

                    {

                %>


                    <div
                        class="cover-status"
                        style="
                            background:#fff4d8;
                            color:#9a6900;
                        "
                    >

                        <%=status%>

                    </div>


                <%

                    }

                %>


            </div>


        </div>


    </div>



    <!-- =================================================
         MAIN GRID
    ================================================== -->

    <div class="main-grid">


        <!-- =================================================
             BRANDING CARD
        ================================================== -->

        <div class="card">


            <div class="card-title">

                <div class="card-icon">
                    🎨
                </div>

                College Branding

            </div>



            <!-- LOGO PREVIEW -->

            <div class="preview-block">


                <div class="preview-title">

                    College Logo

                </div>


                <%

                    if(logoImage != null &&
                       !logoImage.trim().equals(""))

                    {

                %>


                    <img
                        src="college_images/<%=logoImage%>"
                        class="logo-preview"
                        alt="College Logo"
                    >


                <%

                    }

                    else

                    {

                %>


                    <img
                        src="images/college-logo.png"
                        class="logo-preview"
                        alt="College Logo"
                    >


                <%

                    }

                %>


            </div>



            <!-- COVER PREVIEW -->

            <div class="preview-block">


                <div class="preview-title">

                    College Banner

                </div>


                <%

                    if(coverImage != null &&
                       !coverImage.trim().equals(""))

                    {

                %>


                    <img
                        src="college_images/<%=coverImage%>"
                        class="cover-preview"
                        alt="College Banner"
                    >


                <%

                    }

                    else

                    {

                %>


                    <img
                        src="images/college-banner.jpg"
                        class="cover-preview"
                        alt="College Banner"
                    >


                <%

                    }

                %>


            </div>



            <div class="info-box">

                <strong>
                    Image Guidelines
                </strong>

                <br>

                Use a clear college logo and a good quality
                campus/banner image.

            </div>


        </div>



        <!-- =================================================
             PROFILE FORM
        ================================================== -->

        <div class="card">


            <div class="card-title">

                <div class="card-icon">
                    📝
                </div>

                Manage College Information

            </div>



            <form
                action="CollegeProfileController"
                method="post"
                enctype="multipart/form-data"
            >


                <div class="form-grid">


                    <!-- LOGO -->

                    <div class="form-group">

                        <label>
                            🖼️ College Logo
                        </label>


                        <input
                            type="file"
                            name="logo"
                            accept="image/*"
                        >


                        <div class="file-note">

                            JPG, PNG or JPEG

                        </div>

                    </div>



                    <!-- COVER -->

                    <div class="form-group">

                        <label>
                            🌄 College Banner
                        </label>


                        <input
                            type="file"
                            name="cover"
                            accept="image/*"
                        >


                        <div class="file-note">

                            JPG, PNG or JPEG

                        </div>

                    </div>



                    <!-- COLLEGE NAME -->

                    <div class="form-group full">

                        <label>
                            🏫 College Name
                        </label>


                        <input
                            type="text"
                            name="collegeName"
                            value="<%=collegeName%>"
                            required
                        >

                    </div>



                    <!-- ADDRESS -->

                    <div class="form-group full">

                        <label>
                            📍 Address
                        </label>


                        <input
                            type="text"
                            name="address"
                            value="<%=address%>"
                            required
                        >

                    </div>



                    <!-- CITY -->

                    <div class="form-group">

                        <label>
                            🏙️ City
                        </label>


                        <input
                            type="text"
                            name="city"
                            value="<%=city%>"
                            required
                        >

                    </div>



                    <!-- STATE -->

                    <div class="form-group">

                        <label>
                            🗺️ State
                        </label>


                        <input
                            type="text"
                            name="state"
                            value="<%=state%>"
                            required
                        >

                    </div>



                    <!-- EMAIL -->

                    <div class="form-group">

                        <label>
                            📧 Email
                        </label>


                        <input
                            type="email"
                            name="email"
                            value="<%=email%>"
                            required
                        >

                    </div>



                    <!-- PHONE -->

                    <div class="form-group">

                        <label>
                            📞 Phone
                        </label>


                        <input
                            type="text"
                            name="phone"
                            value="<%=phone%>"
                            required
                        >

                    </div>


                </div>



                <div class="button-area">

                    <button
                        type="submit"
                        class="update-btn"
                    >

                        💾 Update Profile

                    </button>

                </div>


            </form>


        </div>


    </div>



    <!-- =================================================
         STATUS
    ================================================== -->

    <div class="status-box">


        <div class="status-left">


            <div class="status-icon">
                ✓
            </div>


            <div>

                <div class="status-label">
                    Current College Status
                </div>

                <div class="status-value">
                    <%=status%>
                </div>

            </div>


        </div>


        <div>

            College ID:
            <strong>
                <%=collegeId%>
            </strong>

        </div>


    </div>


</div>


</body>

</html>