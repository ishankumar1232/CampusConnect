<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Available Colleges | CampusConnect</title>

<style>

/* =========================================================
   CAMPUSCONNECT VISUAL STYLE
   Based on the supplied CampusConnect index.jsp
========================================================= */

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

html{
    scroll-behavior:smooth;
}

body{
    min-height:100vh;
    overflow-x:hidden;
    background:#f5f8fc;
    color:#102846;
    font-family:Arial, Helvetica, sans-serif;
    -webkit-font-smoothing:antialiased;
}

a{
    text-decoration:none;
    color:inherit;
}

/* ================= NAVBAR ================= */

.navbar{
    width:100%;
    padding:18px 0;
    background:#061b34;
    box-shadow:0 10px 30px rgba(0,20,45,.16);
}

.nav-inner{
    width:min(1180px,92%);
    margin:auto;
    padding:9px 10px 9px 14px;

    display:flex;
    align-items:center;
    justify-content:space-between;

    border-radius:15px;

    background:rgba(5,24,45,.72);
    border:1px solid rgba(255,255,255,.12);

    box-shadow:
        0 12px 34px rgba(0,11,30,.16);
}

.brand{
    display:flex;
    align-items:center;
    gap:10px;
    color:#fff;
}

.brand-box{
    width:38px;
    height:38px;

    display:flex;
    align-items:center;
    justify-content:center;

    border-radius:10px;

    background:rgba(255,255,255,.13);
    border:1px solid rgba(255,255,255,.18);

    color:#fff;
    font-size:10px;
    font-weight:900;

    box-shadow:
        inset 0 1px 0 rgba(255,255,255,.22),
        0 8px 18px rgba(0,0,0,.12);
}

.brand-name{
    font-size:18px;
    font-weight:800;
    letter-spacing:-.5px;
}

.brand-name span{
    font-weight:400;
    opacity:.68;
}

.back-home{
    padding:10px 16px;

    color:#12365c;
    background:#fff;

    border-radius:9px;

    font-size:11px;
    font-weight:800;

    transition:.2s ease;
}

.back-home:hover{
    color:#0b3561;
    background:#eaf4ff;
    transform:translateY(-1px);
    box-shadow:0 9px 20px rgba(0,0,0,.17);
}

/* ================= HERO ================= */

.page-hero{
    position:relative;
    overflow:hidden;

    min-height:350px;

    display:flex;
    align-items:center;

    background:
        linear-gradient(
            90deg,
            rgba(3,18,38,.97) 0%,
            rgba(3,18,38,.90) 45%,
            rgba(3,18,38,.48) 75%,
            rgba(3,18,38,.15) 100%
        ),
        url("<%=request.getContextPath()%>/image/college-banner.png");

    background-size:cover;
    background-position:center;
}

.page-hero::after{
    content:"";

    position:absolute;
    width:430px;
    height:430px;

    right:-170px;
    top:-180px;

    border-radius:50%;

    border:70px solid rgba(100,175,255,.055);
}

.hero-content{
    width:min(1180px,92%);
    margin:auto;
    position:relative;
    z-index:2;
}

.eyebrow{
    display:inline-flex;
    align-items:center;
    gap:9px;

    padding:8px 13px;

    color:#d7eaff;
    background:rgba(255,255,255,.08);

    border:1px solid rgba(255,255,255,.17);
    border-radius:30px;

    font-size:9px;
    font-weight:900;
    letter-spacing:1.5px;

    box-shadow:0 7px 18px rgba(18,78,139,.08);
}

.eyebrow-dot{
    width:7px;
    height:7px;
    border-radius:50%;
    background:#62adff;

    box-shadow:
        0 0 0 5px rgba(98,173,255,.10),
        0 0 14px rgba(98,173,255,.70);
}

.page-hero h1{
    max-width:760px;
    margin-top:23px;

    color:#fff;

    font-size:clamp(43px,5vw,66px);
    line-height:.98;
    letter-spacing:-3px;
    font-weight:800;
}

.page-hero h1 span{
    color:#64adff;
}

.hero-description{
    max-width:600px;
    margin-top:20px;

    color:#c7d8e9;

    font-size:14px;
    line-height:1.8;
}

/* ================= MAIN ================= */

.main{
    padding:70px 0 95px;

    background:
        radial-gradient(
            circle at 90% 0%,
            rgba(40,125,235,.07),
            transparent 28%
        ),
        #f5f8fc;
}

.container{
    width:min(1180px,92%);
    margin:auto;
}

/* ================= TOP CONTROL CARD ================= */

.control-card{
    padding:28px;

    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:25px;

    background:#fff;

    border:1px solid #dce6ef;
    border-radius:20px;

    box-shadow:
        0 12px 35px rgba(20,55,90,.055);

    margin-bottom:30px;
}

.control-text h2{
    color:#102846;
    font-size:25px;
    letter-spacing:-1px;
    margin-bottom:8px;
}

.control-text p{
    color:#71849a;
    font-size:12px;
    line-height:1.7;
}

.status-button{
    flex-shrink:0;

    display:inline-flex;
    align-items:center;
    gap:10px;

    padding:13px 18px;

    color:#fff;
    background:#2479eb;

    border-radius:10px;

    font-size:11px;
    font-weight:800;

    box-shadow:
        0 10px 25px rgba(36,121,235,.22);

    transition:.22s ease;
}

.status-button:hover{
    background:#166bdc;
    transform:translateY(-2px);
}

/* ================= SEARCH ================= */

.search-panel{
    margin-bottom:30px;
}

.search-box{
    position:relative;
    max-width:700px;
}

.search-box input{
    width:100%;

    padding:16px 18px 16px 48px;

    border:1px solid #dce6ef;
    border-radius:12px;

    background:#fff;

    color:#263c55;
    font-size:13px;

    outline:none;

    box-shadow:
        0 8px 25px rgba(20,55,90,.04);

    transition:.2s ease;
}

.search-box input:focus{
    border-color:#2479eb;

    box-shadow:
        0 0 0 4px rgba(36,121,235,.10),
        0 10px 28px rgba(20,55,90,.07);
}

.search-icon{
    position:absolute;
    left:17px;
    top:50%;

    transform:translateY(-50%);

    color:#2479eb;
    font-size:16px;

    pointer-events:none;
}

/* ================= GRID ================= */

.college-grid{
    display:grid;
    grid-template-columns:repeat(2,minmax(0,1fr));
    gap:20px;
}

/* ================= COLLEGE CARD ================= */

.college-card{
    position:relative;

    overflow:hidden;

    min-width:0;

    background:#fff;

    border:1px solid #dce5ee;
    border-radius:21px;

    box-shadow:
        0 12px 35px rgba(20,55,90,.055);

    transition:.28s ease;
}

.college-card:hover{
    transform:translateY(-6px);

    border-color:#c9def2;

    box-shadow:
        0 24px 55px rgba(20,55,90,.11);
}

.college-card::before{
    content:"";

    position:absolute;
    z-index:8;

    top:0;
    right:22px;
    left:22px;

    height:3px;

    border-radius:0 0 4px 4px;

    background:#2479eb;

    opacity:0;

    transform:scaleX(.55);

    transition:.28s ease;
}

.college-card:hover::before{
    opacity:1;
    transform:scaleX(1);
}

/* ================= COLLEGE IMAGE ================= */

.college-image-box{
    position:relative;

    width:100%;
    height:235px;

    overflow:hidden;

    background:#dfeeff;
}

.college-image{
    width:100%;
    height:100%;

    display:block;

    object-fit:cover;

    transition:.45s ease;
}

.college-card:hover .college-image{
    transform:scale(1.045);
}

.college-image-box::after{
    content:"";

    position:absolute;
    inset:0;

    background:
        linear-gradient(
            180deg,
            rgba(0,0,0,.02),
            rgba(4,20,40,.40)
        );

    pointer-events:none;
}

/* ================= FLOATING LOGO ================= */

.floating-logo{
    position:absolute;
    z-index:6;

    left:20px;
    bottom:17px;

    width:78px;
    height:78px;

    padding:7px;

    display:flex;
    align-items:center;
    justify-content:center;

    background:#fff;

    border:1px solid rgba(255,255,255,.95);

    border-radius:18px;

    box-shadow:
        0 12px 30px rgba(0,0,0,.23);
}

.floating-logo img{
    width:100%;
    height:100%;

    display:block;

    object-fit:contain;

    border-radius:12px;

    background:#fff;
}

/* ================= CARD CONTENT ================= */

.card-content{
    padding:22px;
}

.card-role{
    display:flex;
    align-items:center;
    gap:8px;

    margin-bottom:9px;

    color:#2479eb;

    font-size:8px;
    font-weight:900;
    letter-spacing:1.5px;
}

.card-role::before{
    content:"";

    width:20px;
    height:2px;

    border-radius:5px;

    background:#2479eb;
}

.card-content h3{
    margin-bottom:14px;

    color:#102846;

    font-size:20px;
    line-height:1.25;

    letter-spacing:-.6px;
    font-weight:800;
}

.details{
    display:flex;
    flex-direction:column;
    gap:8px;

    padding-top:14px;

    border-top:1px solid #edf1f5;
}

.detail-row{
    display:flex;
    align-items:flex-start;
    gap:10px;

    color:#61788f;

    font-size:10.5px;
    line-height:1.45;
}

.detail-icon{
    width:27px;
    height:27px;

    flex-shrink:0;

    display:flex;
    align-items:center;
    justify-content:center;

    color:#2479eb;
    background:#edf5ff;

    border-radius:8px;

    font-size:11px;
    font-weight:900;
}

.detail-text{
    min-width:0;

    display:flex;
    flex-direction:column;
    gap:2px;
}

.detail-text strong{
    color:#304960;
    font-size:9px;
    font-weight:800;
}

.detail-text span{
    color:#7e91a3;
    font-size:9px;

    overflow-wrap:anywhere;
}

/* ================= VIEW BUTTON ================= */

.view-btn{
    width:100%;

    min-height:45px;

    margin-top:18px;

    display:flex;
    align-items:center;
    justify-content:space-between;

    padding:8px 9px 8px 15px;

    color:#fff;

    background:#2479eb;

    border-radius:10px;

    transition:.22s ease;
}

.view-btn span{
    font-size:11px;
    font-weight:800;
}

.view-btn b{
    width:28px;
    height:28px;

    display:flex;
    align-items:center;
    justify-content:center;

    border-radius:50%;

    background:rgba(255,255,255,.18);

    font-size:14px;
}

.view-btn:hover{
    background:#166bdc;
    transform:translateY(-2px);
}

/* ================= EMPTY / ERROR ================= */

.no-college{
    grid-column:1 / -1;

    padding:55px 25px;

    text-align:center;

    background:#fff;

    border:1px solid #dce6ef;
    border-radius:20px;

    box-shadow:
        0 12px 35px rgba(20,55,90,.055);
}

.no-college h3{
    color:#102846;
    margin-bottom:8px;
}

.no-college p{
    color:#71849a;
    font-size:13px;
}

/* ================= FOOTER ================= */

footer{
    padding:25px 0;

    color:#607b96;

    background:#061b34;

    text-align:center;

    font-size:9px;

    border-top:1px solid rgba(255,255,255,.07);
}

/* ================= RESPONSIVE ================= */

@media(max-width:900px){

    .college-grid{
        grid-template-columns:1fr;
    }

    .control-card{
        align-items:flex-start;
        flex-direction:column;
    }

    .status-button{
        width:100%;
        justify-content:center;
    }
}

@media(max-width:650px){

    .navbar{
        padding:12px 0;
    }

    .nav-inner{
        width:calc(100% - 28px);
    }

    .brand-name{
        font-size:16px;
    }

    .page-hero{
        min-height:420px;

        background:
            linear-gradient(
                rgba(3,18,39,.88),
                rgba(3,18,39,.96)
            ),
            url("<%=request.getContextPath()%>/image/college-banner.png");

        background-size:cover;
        background-position:center;
    }

    .hero-content{
        width:calc(100% - 32px);
    }

    .page-hero h1{
        font-size:43px;
        letter-spacing:-2.8px;
    }

    .hero-description{
        font-size:13px;
    }

    .main{
        padding:55px 0 70px;
    }

    .container{
        width:calc(100% - 32px);
    }

    .control-card{
        padding:23px 20px;
    }

    .control-text h2{
        font-size:22px;
    }

    .college-image-box{
        height:210px;
    }

    .floating-logo{
        width:70px;
        height:70px;
        left:16px;
        bottom:15px;
    }

    .card-content{
        padding:20px;
    }

}

@media(max-width:420px){

    .back-home{
        padding:9px 12px;
        font-size:10px;
    }

    .page-hero h1{
        font-size:37px;
    }

    .college-image-box{
        height:195px;
    }

}

</style>

<script>

function searchCollege()
{
    var input =
        document.getElementById("search").value.toLowerCase();

    var cards =
        document.getElementsByClassName("college-card");

    for(var i = 0; i < cards.length; i++)
    {
        var text =
            cards[i].innerText.toLowerCase();

        if(text.includes(input))
        {
            cards[i].style.display = "block";
        }
        else
        {
            cards[i].style.display = "none";
        }
    }
}

</script>

</head>

<body>

<!-- ================= NAVBAR ================= -->

<div class="navbar">

    <div class="nav-inner">

        <a href="index.jsp" class="brand">

            <div class="brand-box">
                CC
            </div>

            <div class="brand-name">
                CampusConnect
                <span> | Student</span>
            </div>

        </a>

        <a href="index.jsp" class="back-home">
            Back to Home
        </a>

    </div>

</div>


<!-- ================= HERO ================= -->

<section class="page-hero">

    <div class="hero-content">

        <div class="eyebrow">
            <span class="eyebrow-dot"></span>
            ADMISSIONS
        </div>

        <h1>
            Find Your
            <span>College.</span>
        </h1>

        <p class="hero-description">
            Explore approved colleges, compare available options,
            and begin your admission journey through CampusConnect.
        </p>

    </div>

</section>


<!-- ================= MAIN ================= -->

<main class="main">

<div class="container">


    <!-- CONTROL -->

    <div class="control-card">

        <div class="control-text">

            <h2>
                Available Colleges
            </h2>

            <p>
                Explore approved colleges and apply for admission.
                Already submitted a request? Check its current status.
            </p>

        </div>

        <a
            href="new_student_check_status.jsp"
            class="status-button">

            Already Applied? Check Status
            <span>→</span>

        </a>

    </div>


    <!-- SEARCH -->

    <div class="search-panel">

        <div class="search-box">

            <span class="search-icon">
                &#128269;
            </span>

            <input
                type="text"
                id="search"
                placeholder="Search college or city..."
                onkeyup="searchCollege()">

        </div>

    </div>


    <!-- COLLEGE GRID -->

    <div class="college-grid">

<%

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

        "SELECT COLLEGE_ID, " +
        "COLLEGE_NAME, " +
        "ADDRESS, " +
        "CITY, " +
        "STATE, " +
        "EMAIL, " +
        "PHONE, " +
        "LOGO_IMAGE, " +
        "COVER_IMAGE " +

        "FROM COLLEGE " +

        "WHERE STATUS='APPROVED' " +

        "ORDER BY COLLEGE_NAME";


    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();


    boolean found = false;


    while(rs.next())
    {

        found = true;


        int collegeId =
            rs.getInt("COLLEGE_ID");


        String collegeName =
            rs.getString("COLLEGE_NAME");


        String address =
            rs.getString("ADDRESS");


        String city =
            rs.getString("CITY");


        String state =
            rs.getString("STATE");


        String email =
            rs.getString("EMAIL");


        String phone =
            rs.getString("PHONE");


        String logoImage =
            rs.getString("LOGO_IMAGE");


        String coverImage =
            rs.getString("COVER_IMAGE");


        String logoPath;

        String coverPath;


        if(logoImage != null &&
           !logoImage.trim().equals(""))
        {

            logoPath =
                request.getContextPath()
                + "/college_images/"
                + logoImage;

        }
        else
        {

            logoPath =
                request.getContextPath()
                + "/images/college-logo.png";

        }


        if(coverImage != null &&
           !coverImage.trim().equals(""))
        {

            coverPath =
                request.getContextPath()
                + "/college_images/"
                + coverImage;

        }
        else
        {

            coverPath =
                request.getContextPath()
                + "/image/college-banner.png";

        }

%>

        <!-- COLLEGE CARD -->

        <div class="college-card">


            <!-- COVER IMAGE -->

            <div class="college-image-box">

                <img
                    src="<%= coverPath %>"
                    class="college-image"
                    alt="<%= collegeName %> Cover Image"

                    onerror="this.onerror=null;
                    this.src='<%=request.getContextPath()%>/image/college-banner.png';">


                <!-- FLOATING LOGO -->

                <div class="floating-logo">

                    <img
                        src="<%= logoPath %>"
                        alt="<%= collegeName %> Logo"

                        onerror="this.onerror=null;
                        this.src='<%=request.getContextPath()%>/images/college-logo.png';">

                </div>

            </div>


            <!-- CONTENT -->

            <div class="card-content">

                <div class="card-role">
                    APPROVED COLLEGE
                </div>

                <h3>
                    <%= collegeName %>
                </h3>


                <div class="details">


                    <div class="detail-row">

                        <div class="detail-icon">
                            &#128205;
                        </div>

                        <div class="detail-text">

                            <strong>
                                ADDRESS
                            </strong>

                            <span>
                                <%= address %>
                            </span>

                        </div>

                    </div>


                    <div class="detail-row">

                        <div class="detail-icon">
                            &#9679;
                        </div>

                        <div class="detail-text">

                            <strong>
                                LOCATION
                            </strong>

                            <span>
                                <%= city %>, <%= state %>
                            </span>

                        </div>

                    </div>


                    <div class="detail-row">

                        <div class="detail-icon">
                            &#9993;
                        </div>

                        <div class="detail-text">

                            <strong>
                                EMAIL
                            </strong>

                            <span>
                                <%= email %>
                            </span>

                        </div>

                    </div>


                    <div class="detail-row">

                        <div class="detail-icon">
                            &#9742;
                        </div>

                        <div class="detail-text">

                            <strong>
                                PHONE
                            </strong>

                            <span>
                                <%= phone %>
                            </span>

                        </div>

                    </div>


                </div>


                <!-- VIEW DETAILS -->

                <a
                    href="new_student_college_compare.jsp?collegeId=<%= collegeId %>"
                    class="view-btn">

                    <span>
                        View College Details
                    </span>

                    <b>
                        →
                    </b>

                </a>

            </div>

        </div>


<%

    }


    if(!found)
    {

%>

        <div class="no-college">

            <h3>
                No Approved Colleges Available
            </h3>

            <p>
                Currently there are no colleges available
                for admission.
            </p>

        </div>

<%

    }

}
catch(Exception e)
{

%>

        <div class="no-college">

            <h3>
                Unable to Load Colleges
            </h3>

            <p>
                <%= e.getMessage() %>
            </p>

        </div>

<%

}
finally
{

    try
    {
        if(rs != null)
            rs.close();
    }
    catch(Exception e)
    {
    }


    try
    {
        if(ps != null)
            ps.close();
    }
    catch(Exception e)
    {
    }


    try
    {
        if(con != null)
            con.close();
    }
    catch(Exception e)
    {
    }

}

%>

    </div>

</div>

</main>


<!-- ================= FOOTER ================= -->

<footer>

    © 2026 CampusConnect. All Rights Reserved.

</footer>


</body>
</html>
