<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"

      content="width=device-width, initial-scale=1.0">

<title>CampusConnect | One Campus. Everything Connected.</title>



<script>

if ("scrollRestoration" in history) {

    history.scrollRestoration = "manual";

}

window.addEventListener("load", function () {

    setTimeout(function () {

        window.scrollTo(0, 0);

    }, 80);

});

</script>



<style>

/* =========================================================

   RESET

========================================================= */

*{

    margin:0;

    padding:0;

    box-sizing:border-box;

}

html{

    scroll-behavior:smooth;

    scroll-padding-top:30px;

}

body{

    overflow-x:hidden;

    background:#f5f8fc;

    color:#102846;

    font-family:

        Arial,

        Helvetica,

        sans-serif;

}

a{

    text-decoration:none;

    color:inherit;

}

.container{

    width:min(1180px,92%);

    margin:auto;

}



/* =========================================================

   NAVBAR

========================================================= */

.navbar{

    position:absolute;

    top:0;

    left:0;

    width:100%;

    z-index:100;

    padding:18px 0;

}

.nav-inner{

    width:min(1180px,92%);

    margin:auto;

    padding:9px 10px 9px 14px;

    display:flex;

    align-items:center;

    justify-content:space-between;

    border-radius:15px;

    background:rgba(5,24,45,.42);

    border:1px solid rgba(255,255,255,.18);

    backdrop-filter:blur(18px);

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

    font-size:10px;

    font-weight:900;

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

.nav-links{

    display:flex;

    align-items:center;

    gap:27px;

}

.nav-links a{

    color:#fff;

    font-size:11px;

    font-weight:700;

    opacity:.82;

    transition:.2s;

}

.nav-links a:hover{

    opacity:1;

}

.nav-button{

    padding:10px 16px;

    color:#12365c !important;

    background:#fff;

    border-radius:9px;

    opacity:1 !important;

}



/* =========================================================

   HERO

========================================================= */

.hero{

    position:relative;

    min-height:700px;

    display:flex;

    align-items:center;

    overflow:hidden;

    background:

        linear-gradient(

            90deg,

            rgba(3,18,38,.97) 0%,

            rgba(3,18,38,.89) 35%,

            rgba(3,18,38,.48) 70%,

            rgba(3,18,38,.10) 100%

        ),

        url("<%=request.getContextPath()%>/image/college-banner.png");

    background-size:cover;

    background-position:center;

}

.hero-content{

    width:min(1180px,92%);

    margin:auto;

    padding-top:30px;

    position:relative;

    z-index:2;

}

.hero-tag{

    display:inline-flex;

    align-items:center;

    gap:8px;

    padding:8px 13px;

    color:#d7eaff;

    background:rgba(255,255,255,.08);

    border:1px solid rgba(255,255,255,.17);

    border-radius:30px;

    font-size:9px;

    font-weight:900;

    letter-spacing:1.5px;

}

.hero-dot{

    width:7px;

    height:7px;

    border-radius:50%;

    background:#62adff;

}

.hero h1{

    max-width:800px;

    margin-top:27px;

    color:#fff;

    font-size:clamp(55px,6vw,80px);

    line-height:.98;

    letter-spacing:-4px;

    font-weight:800;

}

.hero h1 span{

    color:#64adff;

}

.hero-text{

    max-width:620px;

    margin-top:25px;

    color:#c7d8e9;

    font-size:15px;

    line-height:1.8;

}

.hero-buttons{

    display:flex;

    gap:12px;

    margin-top:32px;

}

.primary-button,

.secondary-button{

    display:inline-flex;

    align-items:center;

    justify-content:center;

    padding:14px 21px;

    border-radius:9px;

    font-size:13px;

    font-weight:800;

    transition:.25s;

}

.primary-button{

    color:#fff;

    background:#2479eb;

    box-shadow:

        0 12px 30px rgba(30,110,225,.25);

}

.primary-button:hover{

    background:#1268d9;

    transform:translateY(-2px);

}

.secondary-button{

    color:#fff;

    background:rgba(255,255,255,.08);

    border:1px solid rgba(255,255,255,.25);

}

.secondary-button:hover{

    background:rgba(255,255,255,.15);

    transform:translateY(-2px);

}

.hero-info{

    position:absolute;

    bottom:25px;

    left:50%;

    transform:translateX(-50%);

    width:min(1180px,92%);

    display:flex;

    align-items:center;

    gap:18px;

}

.hero-info span{

    color:rgba(255,255,255,.70);

    font-size:9px;

    font-weight:900;

    letter-spacing:1.5px;

    white-space:nowrap;

}

.hero-info-line{

    flex:1;

    height:1px;

    background:rgba(255,255,255,.18);

}



/* =========================================================

   PORTALS

========================================================= */

.portals{

    padding:105px 0 120px;

    background:

        radial-gradient(

            circle at 90% 0%,

            rgba(40,125,235,.07),

            transparent 27%

        ),

        #f5f8fc;

}

.portal-header{

    display:grid;

    grid-template-columns:1.1fr .75fr;

    align-items:end;

    gap:80px;

    margin-bottom:45px;

}

.portal-eyebrow{

    display:inline-flex;

    align-items:center;

    gap:8px;

    margin-bottom:15px;

    padding:8px 13px;

    color:#176fe0;

    background:#e9f2ff;

    border-radius:30px;

    font-size:9px;

    font-weight:900;

    letter-spacing:1.5px;

}

.portal-eyebrow::before{

    content:"";

    width:6px;

    height:6px;

    border-radius:50%;

    background:#2479eb;

}

.portal-header h2{

    max-width:700px;

    color:#102846;

    font-size:clamp(43px,4.8vw,64px);

    line-height:.98;

    letter-spacing:-3.7px;

    font-weight:800;

}

.portal-header h2 span{

    color:#2479eb;

}

.portal-header-text{

    max-width:430px;

    color:#6d8198;

    font-size:13px;

    line-height:1.85;

    padding-left:20px;

    border-left:3px solid #2479eb;

}



/* =========================================================

   PORTAL GRID

========================================================= */

.portal-grid{

    display:grid;

    grid-template-columns:

        repeat(4,1fr);

    gap:18px;

}



/* =========================================================

   PORTAL CARD

========================================================= */

.portal-card{

    --accent:#2479eb;

    --soft:#edf5ff;

    --border:#d6e8ff;

    position:relative;

    display:flex;

    flex-direction:column;

    overflow:hidden;

    min-width:0;

    background:#fff;

    border:1px solid #dce5ee;

    border-radius:21px;

    box-shadow:

        0 12px 35px rgba(20,55,90,.055);

    transition:.28s;

}

.portal-card:hover{

    transform:translateY(-6px);

    border-color:var(--border);

    box-shadow:

        0 24px 55px rgba(20,55,90,.11);

}

.student{

    --accent:#2479eb;

    --soft:#edf5ff;

    --border:#d4e6ff;

}

.college{

    --accent:#159b6b;

    --soft:#ebf9f3;

    --border:#ccecdf;

}

.company{

    --accent:#5754d9;

    --soft:#f0efff;

    --border:#dedcff;

}

.superadmin{

    --accent:#e86b16;

    --soft:#fff1e7;

    --border:#ffdcc5;

}



/* =========================================================

   PORTAL IMAGE

========================================================= */

.portal-photo{

    height:185px;

    position:relative;

    flex-shrink:0;

    background-size:cover;

    background-position:center;

    overflow:hidden;

}

.student-photo{

    background-image:

        url("<%=request.getContextPath()%>/image/student.png");

}

.college-photo{

    background-image:

        url("<%=request.getContextPath()%>/image/college.png");

}

.company-photo{

    background-image:

        url("<%=request.getContextPath()%>/image/company.png");

}

.superadmin-photo{

    background-image:

        url("<%=request.getContextPath()%>/image/superadmin.png");

}

.photo-overlay{

    position:absolute;

    inset:0;

    background:

        linear-gradient(

            180deg,

            rgba(0,0,0,.02),

            rgba(4,20,40,.30)

        );

}

.photo-label{

    position:absolute;

    left:17px;

    bottom:16px;

    display:flex;

    align-items:center;

    gap:8px;

    color:#fff;

    font-size:9px;

    font-weight:900;

    letter-spacing:1px;

    text-shadow:

        0 2px 8px rgba(0,0,0,.45);

}

.photo-label-dot{

    width:8px;

    height:8px;

    border-radius:50%;

    background:var(--accent);

    box-shadow:

        0 0 0 4px rgba(255,255,255,.20);

}



/* =========================================================

   PORTAL BODY

========================================================= */

.portal-body{

    display:flex;

    flex-direction:column;

    flex:1;

    padding:22px 21px 20px;

}

.portal-role{

    display:flex;

    align-items:center;

    gap:8px;

    margin-bottom:10px;

    color:var(--accent);

    font-size:8px;

    font-weight:900;

    letter-spacing:1.5px;

}

.portal-role::before{

    content:"";

    width:20px;

    height:2px;

    border-radius:5px;

    background:var(--accent);

}

.portal-body h3{

    margin-bottom:10px;

    color:#102846;

    font-size:19px;

    line-height:1.2;

    letter-spacing:-.6px;

}

.portal-description{

    color:#6c8097;

    font-size:11px;

    line-height:1.7;

}



/* =========================================================

   FEATURE LIST

========================================================= */

.feature-list{

    display:flex;

    flex-direction:column;

    gap:7px;

    margin-top:18px;

    padding-top:15px;

    border-top:1px solid #edf1f5;

}

.feature-item{

    display:flex;

    align-items:flex-start;

    gap:8px;

    color:#61788f;

    font-size:9.5px;

    line-height:1.4;

}

.feature-check{

    width:16px;

    height:16px;

    flex-shrink:0;

    display:flex;

    align-items:center;

    justify-content:center;

    color:var(--accent);

    background:var(--soft);

    border-radius:50%;

    font-size:9px;

    font-weight:900;

}



/* =========================================================

   STUDENT OPTIONS

========================================================= */

.student-title{

    margin-top:20px;

    margin-bottom:8px;

    color:#8798a9;

    font-size:8px;

    font-weight:900;

    letter-spacing:1.3px;

}

.student-options{

    display:flex;

    flex-direction:column;

    gap:8px;

}

.student-option{

    min-height:47px;

    display:flex;

    align-items:center;

    gap:9px;

    padding:8px 9px;

    border:1px solid #dfe7ef;

    border-radius:10px;

    background:#fff;

    transition:.22s;

}

.student-option:hover{

    transform:translateX(2px);

    border-color:#c4d9ee;

    background:#f9fbfe;

}

.student-option.primary-option{

    color:#fff;

    background:#2479eb;

    border-color:#2479eb;

    box-shadow:

        0 8px 20px rgba(36,121,235,.17);

}

.student-option.primary-option:hover{

    background:#166bdc;

    border-color:#166bdc;

}

.option-icon{

    width:29px;

    height:29px;

    flex-shrink:0;

    display:flex;

    align-items:center;

    justify-content:center;

    border-radius:8px;

    color:#2479eb;

    background:#eaf3ff;

    font-size:12px;

    font-weight:900;

}

.primary-option .option-icon{

    color:#fff;

    background:rgba(255,255,255,.18);

}

.option-text{

    flex:1;

    min-width:0;

    display:flex;

    flex-direction:column;

    gap:2px;

}

.option-text strong{

    color:#183654;

    font-size:10px;

    font-weight:800;

}

.option-text small{

    color:#8596a8;

    font-size:8px;

}

.primary-option .option-text strong{

    color:#fff;

}

.primary-option .option-text small{

    color:#d8e9fb;

}

.option-arrow{

    color:#2479eb;

    font-size:13px;

    font-weight:900;

}

.primary-option .option-arrow{

    color:#fff;

}



/* =========================================================

   PORTAL BOTTOM

========================================================= */

.portal-bottom{

    margin-top:auto;

    padding-top:20px;

}

.info-box{

    display:flex;

    align-items:center;

    gap:10px;

    min-height:49px;

    margin-bottom:9px;

    padding:8px 10px;

    background:var(--soft);

    border:1px solid var(--border);

    border-radius:10px;

}

.info-icon{

    width:29px;

    height:29px;

    flex-shrink:0;

    display:flex;

    align-items:center;

    justify-content:center;

    color:#fff;

    background:var(--accent);

    border-radius:8px;

    font-size:12px;

    font-weight:900;

}

.info-text{

    display:flex;

    flex-direction:column;

    gap:2px;

}

.info-text strong{

    color:#304960;

    font-size:9px;

    font-weight:800;

}

.info-text small{

    color:#7e91a3;

    font-size:7.5px;

}

.login-button{

    width:100%;

    min-height:45px;

    display:flex;

    align-items:center;

    justify-content:space-between;

    padding:8px 9px 8px 14px;

    color:#fff;

    background:var(--accent);

    border-radius:9px;

    transition:.22s;

}

.login-button span{

    font-size:10px;

    font-weight:800;

}

.login-button b{

    width:27px;

    height:27px;

    display:flex;

    align-items:center;

    justify-content:center;

    border-radius:50%;

    background:rgba(255,255,255,.18);

    font-size:13px;

}

.login-button:hover{

    filter:brightness(.94);

    transform:translateY(-2px);

}



/* =========================================================
   STUDENT JOURNEY - FINAL IMAGE BASED DESIGN
========================================================= */
.student-journey{
    position:relative;
    min-height:914px;
    overflow:hidden;
    color:#fff;
    background:#031b38;
    isolation:isolate;
}

/* YOUR EXISTING STUDENT JOURNEY BACKGROUND */
.student-journey .journey-bg{
    position:absolute;
    inset:0;
    background-image:url("<%=request.getContextPath()%>/image/student-journey-bg.png");
    /* Keep the complete background visible - do not zoom/crop the student image */
    background-size:100% 100%;
    background-position:center center;
    background-repeat:no-repeat;
    z-index:-3;
}

/* The image already contains the dark blue right side,
   so DO NOT put a heavy overlay over it. */
.student-journey .journey-overlay{
    position:absolute;
    inset:0;
    background:transparent;
    z-index:-2;
    pointer-events:none;
}

.student-journey .journey-container{
    width:min(1500px,87%);
    min-height:914px;
    margin:auto;
    position:relative;
    padding:58px 0 65px;
    display:grid;
    grid-template-columns:700px minmax(0,1fr);
    column-gap:130px;
}

/* LEFT */
.student-journey .journey-left{
    padding-top:2px;
    position:relative;
    z-index:5;
}

.student-journey .journey-label{
    display:flex;
    align-items:center;
    gap:15px;
    margin-bottom:23px;
}

.student-journey .journey-label span{
    font-size:16px;
    font-weight:800;
    letter-spacing:3px;
    color:#63b0ff;
}

.student-journey .label-line{
    width:86px;
    height:1px;
    background:rgba(99,176,255,.70);
}

.student-journey .journey-left h2{
    margin:0;
    max-width:690px;
    font-size:clamp(55px,4.4vw,78px);
    line-height:.94;
    letter-spacing:-4px;
    font-weight:800;
    color:#fff;
}

.student-journey .journey-left h2 span{
    color:#2998ff;
    text-shadow:0 0 30px rgba(41,152,255,.20);
}

.student-journey .journey-description{
    max-width:570px;
    margin:27px 0 27px;
    font-size:18px;
    line-height:1.62;
    color:#c5d7ea;
}

.student-journey .journey-btn{
    display:inline-flex;
    align-items:center;
    gap:13px;
    padding:16px 31px;
    border-radius:13px;
    text-decoration:none;
    color:#fff;
    background:linear-gradient(135deg,#208fff,#0876e9);
    font-size:17px;
    font-weight:800;
    box-shadow:0 14px 32px rgba(0,105,225,.28);
    transition:.25s ease;
}

.student-journey .journey-btn span{
    font-size:22px;
}

.student-journey .journey-btn:hover{
    transform:translateY(-3px);
    box-shadow:0 18px 38px rgba(0,105,225,.40);
}

/* RIGHT TIMELINE */
.student-journey .journey-right{
    position:relative;
    z-index:5;
    display:flex;
    flex-direction:column;
    gap:13px;
    padding-top:0;
}

.student-journey .journey-right::before{
    content:"";
    position:absolute;
    left:25px;
    top:27px;
    bottom:28px;
    width:1px;
    background:repeating-linear-gradient(
        to bottom,
        rgba(91,174,255,.95) 0,
        rgba(91,174,255,.95) 7px,
        transparent 7px,
        transparent 14px
    );
}

.student-journey .journey-step{
    position:relative;
    display:grid;
    grid-template-columns:52px minmax(0,1fr);
    gap:20px;
    align-items:center;
    z-index:2;
}

.student-journey .step-number{
    width:52px;
    height:52px;
    flex-shrink:0;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#fff;
    background:linear-gradient(145deg,#218fff,#0873df);
    border:1px solid rgba(98,185,255,.90);
    box-shadow:0 0 24px rgba(20,132,255,.30);
    font-size:14px;
    font-weight:800;
    z-index:4;
}

.student-journey .journey-step:nth-child(3) .step-number{
    background:linear-gradient(145deg,#178c91,#086f78);
    border-color:rgba(40,220,208,.60);
}

.student-journey .journey-step:nth-child(6) .step-number{
    background:linear-gradient(145deg,#5b4fd1,#4937aa);
}

.student-journey .step-card{
    min-height:113px;
    width:100%;
    padding:18px 18px 18px 22px;
    display:flex;
    align-items:center;
    gap:20px;
    border-radius:20px;
    background:linear-gradient(
        135deg,
        rgba(12,55,96,.72),
        rgba(5,35,69,.72)
    );
    border:1px solid rgba(80,158,231,.28);
    backdrop-filter:blur(9px);
    -webkit-backdrop-filter:blur(9px);
    box-shadow:
        inset 0 1px 0 rgba(255,255,255,.045),
        0 12px 30px rgba(0,0,0,.10);
    transition:.25s ease;
}

.student-journey .step-card:hover{
    transform:translateX(5px);
    border-color:rgba(82,174,255,.60);
    background:linear-gradient(
        135deg,
        rgba(19,70,117,.82),
        rgba(6,40,76,.80)
    );
}

.student-journey .step-icon{
    width:62px;
    height:62px;
    flex-shrink:0;
    border-radius:18px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:27px;
    background:linear-gradient(
        145deg,
        rgba(39,126,237,.46),
        rgba(24,73,141,.65)
    );
    border:1px solid rgba(80,164,255,.18);
}

.student-journey .approval-icon{
    color:#43e7df;
    background:linear-gradient(
        145deg,
        rgba(10,180,177,.18),
        rgba(10,100,130,.25)
    );
    border-color:rgba(15,224,217,.40);
}

.student-journey .recruitment-icon{
    background:linear-gradient(
        145deg,
        rgba(118,78,255,.55),
        rgba(68,48,145,.62)
    );
}

.student-journey .step-content{
    flex:1;
    min-width:0;
}

.student-journey .step-content h3{
    margin:0 0 7px;
    color:#fff;
    font-size:19px;
    line-height:1.2;
    font-weight:800;
}

.student-journey .step-content p{
    margin:0;
    max-width:430px;
    color:#b7c9de;
    font-size:14px;
    line-height:1.45;
}

.student-journey .step-arrow{
    width:46px;
    height:46px;
    flex-shrink:0;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#fff;
    background:rgba(33,98,162,.55);
    font-size:22px;
    transition:.25s ease;
}

.student-journey .step-card:hover .step-arrow{
    background:#147fe8;
    transform:translateX(3px);
}

/* BOTTOM STATS */
.student-journey .journey-stats{
    position:absolute;
    left:0;
    bottom:64px;
    width:710px;
    height:105px;
    padding:14px 24px;
    display:flex;
    align-items:center;
    background:linear-gradient(
        135deg,
        rgba(4,37,70,.94),
        rgba(4,29,58,.92)
    );
    border:1px solid rgba(67,143,220,.30);
    border-radius:20px;
    box-shadow:0 18px 45px rgba(0,0,0,.25);
    backdrop-filter:blur(12px);
    -webkit-backdrop-filter:blur(12px);
    z-index:8;
}

.student-journey .journey-stat{
    flex:1;
    display:flex;
    align-items:center;
    gap:17px;
}

.student-journey .stat-icon{
    width:61px;
    height:61px;
    flex-shrink:0;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:25px;
    background:linear-gradient(145deg,#147fe7,#164b9b);
}

.student-journey .students-icon{
    background:linear-gradient(145deg,#20c7bd,#087f92);
}

.student-journey .recruitment-stat-icon{
    background:linear-gradient(145deg,#7653e9,#4830a2);
}

.student-journey .journey-stat strong{
    display:block;
    color:#fff;
    font-size:22px;
    line-height:1.1;
}

.student-journey .journey-stat span{
    display:block;
    margin-top:7px;
    color:#b8c9dd;
    font-size:14px;
}

.student-journey .stat-divider{
    width:1px;
    height:52px;
    margin:0 20px;
    background:rgba(112,169,220,.22);
}

/* RESPONSIVE */
@media(max-width:1450px){
    .student-journey .journey-container{
        width:90%;
        grid-template-columns:minmax(560px,.95fr) minmax(560px,1fr);
        column-gap:65px;
    }
}

@media(max-width:1150px){
    .student-journey{
        min-height:auto;
    }

    .student-journey .journey-container{
        width:90%;
        min-height:auto;
        grid-template-columns:1fr;
        row-gap:45px;
        padding:70px 0 180px;
    }

    .student-journey .journey-left{
        max-width:700px;
    }

    .student-journey .journey-right{
        max-width:850px;
    }

    .student-journey .journey-stats{
        width:min(710px,90%);
        bottom:40px;
    }
}

@media(max-width:700px){
    .student-journey .journey-container{
        width:90%;
        padding:55px 0 40px;
    }

    .student-journey .journey-left h2{
        font-size:47px;
        letter-spacing:-2px;
    }

    .student-journey .journey-description{
        font-size:16px;
    }

    .student-journey .journey-right::before{
        display:none;
    }

    .student-journey .journey-step{
        grid-template-columns:1fr;
        gap:0;
    }

    .student-journey .step-number{
        display:none;
    }

    .student-journey .step-card{
        padding:18px;
        min-height:auto;
    }

    .student-journey .step-icon{
        width:50px;
        height:50px;
        border-radius:14px;
        font-size:22px;
    }

    .student-journey .step-content h3{
        font-size:16px;
    }

    .student-journey .step-content p{
        font-size:13px;
    }

    .student-journey .step-arrow{
        width:38px;
        height:38px;
        font-size:18px;
    }

    .student-journey .journey-stats{
        position:relative;
        left:auto;
        bottom:auto;
        width:100%;
        height:auto;
        margin-top:25px;
        padding:20px;
        flex-direction:column;
        align-items:stretch;
        gap:20px;
    }

    .student-journey .journey-stat{
        width:100%;
    }

    .student-journey .stat-divider{
        width:100%;
        height:1px;
        margin:0;
    }
}

/* =========================================================

   FEATURES

========================================================= */

.features{

    padding:110px 0;

    background:#f5f8fc;

}

.features-heading{

    max-width:700px;

    margin-bottom:48px;

}

.features-heading h2{

    color:#102846;

    font-size:clamp(43px,4.5vw,62px);

    line-height:.98;

    letter-spacing:-3.5px;

    font-weight:800;

    margin-bottom:18px;

}

.features-heading p{

    max-width:570px;

    color:#71849a;

    font-size:13px;

    line-height:1.8;

}

.feature-grid{

    display:grid;

    grid-template-columns:

        repeat(3,1fr);

    gap:17px;

}

.feature-card{

    padding:28px;

    min-height:205px;

    background:#fff;

    border:1px solid #dce6ef;

    border-radius:18px;

    box-shadow:

        0 10px 30px rgba(20,55,90,.045);

    transition:.25s;

}

.feature-card:hover{

    transform:translateY(-5px);

    border-color:#c9def2;

    box-shadow:

        0 20px 45px rgba(20,55,90,.09);

}

.feature-top{

    display:flex;

    align-items:center;

    justify-content:space-between;

    margin-bottom:25px;

}

.feature-label{

    color:#2479eb;

    font-size:8px;

    font-weight:900;

    letter-spacing:1.5px;

}

.feature-arrow{

    color:#9bb0c4;

    font-size:18px;

}

.feature-card h3{

    margin-bottom:12px;

    color:#173452;

    font-size:20px;

    letter-spacing:-.7px;

}

.feature-card p{

    color:#71849a;

    font-size:11px;

    line-height:1.75;

}



/* =========================================================

   ABOUT

========================================================= */

.about{

    padding:0 0 110px;

    background:#f5f8fc;

}

.about-box{

    display:grid;

    grid-template-columns:1fr 1fr;

    min-height:470px;

    overflow:hidden;

    border-radius:24px;

    background:#fff;

    border:1px solid #dce6ef;

    box-shadow:

        0 20px 55px rgba(20,55,90,.07);

}

.about-image{

    min-height:470px;

    background:

        linear-gradient(

            90deg,

            rgba(5,27,52,.12),

            rgba(5,27,52,.35)

        ),

        url("<%=request.getContextPath()%>/image/college-banner.png");

    background-size:cover;

    background-position:center;

}

.about-content{

    display:flex;

    flex-direction:column;

    justify-content:center;

    padding:55px;

}

.about-content h2{

    max-width:480px;

    margin-bottom:20px;

    color:#102846;

    font-size:clamp(38px,4vw,54px);

    line-height:1;

    letter-spacing:-3px;

    font-weight:800;

}

.about-content p{

    max-width:500px;

    color:#71849a;

    font-size:12px;

    line-height:1.85;

}

.about-button{

    margin-top:25px;

}



/* =========================================================

   CTA

========================================================= */

.cta{

    padding:0 0 110px;

    background:#f5f8fc;

}

.cta-box{

    position:relative;

    overflow:hidden;

    padding:70px;

    border-radius:25px;

    color:#fff;

    background:

        linear-gradient(

            110deg,

            #082344,

            #0b315c 60%,

            #12518e

        );

    box-shadow:

        0 25px 60px rgba(11,45,82,.18);

}

.cta-box::after{

    content:"";

    position:absolute;

    width:400px;

    height:400px;

    right:-180px;

    top:-210px;

    border-radius:50%;

    border:80px solid rgba(100,175,255,.06);

}

.cta-content{

    position:relative;

    z-index:2;

}

.cta-content h2{

    max-width:700px;

    margin-bottom:20px;

    color:#fff;

    font-size:clamp(42px,5vw,64px);

    line-height:.98;

    letter-spacing:-3.5px;

    font-weight:800;

}

.cta-content p{

    max-width:560px;

    color:#b8cde1;

    font-size:13px;

    line-height:1.8;

}

.cta-buttons{

    display:flex;

    gap:12px;

    margin-top:28px;

}

.primary-button.white{

    color:#12365c;

    background:#fff;

    box-shadow:none;

}

.primary-button.white:hover{

    background:#edf5ff;

}

.cta .secondary-button{

    color:#fff;

    border-color:rgba(255,255,255,.25);

}



/* =========================================================

   FOOTER

========================================================= */

footer{

    padding:65px 0 25px;

    color:#fff;

    background:#061b34;

}

.footer-grid{

    display:grid;

    grid-template-columns:

        1.5fr

        .7fr

        .7fr

        .7fr;

    gap:50px;

    padding-bottom:45px;

    border-bottom:

        1px solid rgba(255,255,255,.09);

}

.footer-description{

    max-width:330px;

    margin-top:20px;

    color:#7f98b1;

    font-size:11px;

    line-height:1.8;

}

.footer-title{

    margin-bottom:17px;

    color:#6caeff;

    font-size:8px;

    font-weight:900;

    letter-spacing:1.6px;

}

.footer-links{

    display:flex;

    flex-direction:column;

    gap:10px;

}

.footer-links a{

    color:#9db2c7;

    font-size:10px;

    transition:.2s;

}

.footer-links a:hover{

    color:#fff;

    transform:translateX(2px);

}

.footer-bottom{

    display:flex;

    align-items:center;

    justify-content:space-between;

    gap:20px;

    padding-top:22px;

    color:#607b96;

    font-size:8px;

    letter-spacing:.3px;

}



/* =========================================================

   RESPONSIVE

========================================================= */

@media(max-width:1100px){

    .portal-grid{

        grid-template-columns:

            repeat(2,1fr);

    }

    .feature-grid{

        grid-template-columns:

            repeat(2,1fr);

    }

}



@media(max-width:850px){

    .nav-links a:not(.nav-button){

        display:none;

    }

    .hero{

        min-height:650px;

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

        text-align:center;

    }

    .hero-tag{

        margin:auto;

    }

    .hero h1{

        margin-left:auto;

        margin-right:auto;

        font-size:52px;

    }

    .hero-text{

        margin-left:auto;

        margin-right:auto;

    }

    .hero-buttons{

        justify-content:center;

    }

    .hero-info{

        display:none;

    }

    .portal-header{

        grid-template-columns:1fr;

        gap:25px;

    }

    .portal-header-text{

        max-width:600px;

    }

    .about-box{

        grid-template-columns:1fr;

    }

    .about-image{

        min-height:320px;

    }

    .footer-grid{

        grid-template-columns:

            repeat(2,1fr);

    }

}



@media(max-width:600px){

    .navbar{

        padding:12px 0;

    }

    .nav-inner{

        padding:8px 8px 8px 10px;

    }

    .brand-name{

        font-size:16px;

    }

    .hero{

        min-height:650px;

    }

    .hero h1{

        font-size:43px;

        letter-spacing:-2.8px;

    }

    .hero-text{

        font-size:13px;

    }

    .hero-buttons{

        flex-direction:column;

        align-items:stretch;

    }

    .primary-button,

    .secondary-button{

        width:100%;

    }

    .portals{

        padding:80px 0 90px;

    }

    .portal-header h2{

        font-size:42px;

        letter-spacing:-2.5px;

    }

    .portal-grid{

        grid-template-columns:1fr;

    }

    .portal-photo{

        height:210px;

    }

    .features{

        padding:80px 0;

    }

    .features-heading h2{

        font-size:42px;

        letter-spacing:-2.5px;

    }

    .feature-grid{

        grid-template-columns:1fr;

    }

    .about-content{

        padding:40px 27px;

    }

    .about-content h2{

        font-size:37px;

    }

    .cta{

        padding-bottom:80px;

    }

    .cta-box{

        padding:45px 27px;

    }

    .cta-content h2{

        font-size:43px;

        letter-spacing:-2.5px;

    }

    .cta-buttons{

        flex-direction:column;

    }

    .footer-grid{

        grid-template-columns:1fr;

        gap:32px;

    }

    .footer-bottom{

        flex-direction:column;

        align-items:flex-start;

    }

}

/* =========================================================
   VISUAL POLISH - CONTENT AND IMAGE REFERENCES UNCHANGED
========================================================= */

body{
    -webkit-font-smoothing:antialiased;
    text-rendering:optimizeLegibility;
}

a:focus-visible{
    outline:3px solid rgba(104,183,255,.92);
    outline-offset:4px;
    border-radius:6px;
}

.nav-inner{
    box-shadow:0 12px 34px rgba(0,11,30,.16);
}

.brand-box{
    box-shadow:inset 0 1px 0 rgba(255,255,255,.22), 0 8px 18px rgba(0,0,0,.12);
}

.nav-links a:not(.nav-button){
    position:relative;
    padding:5px 0;
}

.nav-links a:not(.nav-button)::after{
    content:"";
    position:absolute;
    right:0;
    bottom:0;
    left:0;
    height:2px;
    border-radius:2px;
    background:#7fc0ff;
    transform:scaleX(0);
    transform-origin:right;
    transition:transform .22s ease;
}

.nav-links a:not(.nav-button):hover::after,
.nav-links a:not(.nav-button):focus-visible::after{
    transform:scaleX(1);
    transform-origin:left;
}

.nav-button,
.primary-button,
.secondary-button,
.login-button,
.student-journey .journey-btn{
    will-change:transform;
}

.nav-button:hover{
    color:#0b3561 !important;
    background:#eaf4ff;
    transform:translateY(-1px);
    box-shadow:0 9px 20px rgba(0,0,0,.17);
}

.hero-tag,
.portal-eyebrow{
    box-shadow:0 7px 18px rgba(18,78,139,.08);
}

.hero-dot{
    box-shadow:0 0 0 5px rgba(98,173,255,.10), 0 0 14px rgba(98,173,255,.70);
}

.portal-card:focus-within,
.feature-card:focus-within{
    transform:translateY(-4px);
    border-color:#b9d9f7;
    box-shadow:0 20px 45px rgba(20,55,90,.10);
}

.portal-card::before{
    content:"";
    position:absolute;
    z-index:2;
    top:0;
    right:22px;
    left:22px;
    height:3px;
    border-radius:0 0 4px 4px;
    background:var(--accent);
    opacity:0;
    transform:scaleX(.55);
    transition:opacity .28s ease, transform .28s ease;
}

.portal-card:hover::before,
.portal-card:focus-within::before{
    opacity:1;
    transform:scaleX(1);
}

.student-option:focus-within,
.login-button:focus-visible{
    box-shadow:0 0 0 3px rgba(36,121,235,.18);
}

.feature-card{
    overflow:hidden;
}

.feature-card::after{
    content:"";
    display:block;
    width:34px;
    height:3px;
    margin-top:24px;
    border-radius:3px;
    background:#2479eb;
    opacity:.8;
    transition:width .25s ease;
}

.feature-card:hover::after,
.feature-card:focus-within::after{
    width:58px;
}

.about-box,
.cta-box{
    box-shadow:0 24px 60px rgba(20,55,90,.10);
}

.about-image{
    position:relative;
}

.about-image::after{
    content:"";
    position:absolute;
    inset:0;
    border:1px solid rgba(255,255,255,.14);
    pointer-events:none;
}

.cta-box{
    border:1px solid rgba(116,184,255,.18);
}

.cta-box::before{
    content:"";
    position:absolute;
    width:260px;
    height:260px;
    right:16%;
    bottom:-210px;
    border-radius:50%;
    background:radial-gradient(circle,rgba(89,169,255,.20),transparent 68%);
    pointer-events:none;
}

.student-journey .journey-btn:focus-visible,
.student-journey .step-card:focus-within{
    outline:3px solid rgba(109,188,255,.78);
    outline-offset:4px;
}

.student-journey .journey-stats{
    box-shadow:inset 0 1px 0 rgba(255,255,255,.06), 0 18px 45px rgba(0,0,0,.25);
}

.student-journey .journey-stat strong{
    letter-spacing:-.4px;
}

@media(max-width:850px){
    .nav-links a:not(.nav-button)::after{
        display:none;
    }
}

@media(max-width:600px){
    .container,
    .nav-inner,
    .hero-content{
        width:min(100% - 32px,1180px);
    }

    .portal-card:hover,
    .feature-card:hover,
    .portal-card:focus-within,
    .feature-card:focus-within{
        transform:none;
    }

    .student-journey .step-card:hover{
        transform:none;
    }
}

@media(prefers-reduced-motion:reduce){
    *,
    *::before,
    *::after{
        scroll-behavior:auto !important;
        transition-duration:.01ms !important;
        animation-duration:.01ms !important;
        animation-iteration-count:1 !important;
    }
}

</style>

</head>



<body>



<!-- =========================================================

     NAVBAR

========================================================= -->

<nav class="navbar">

    <div class="nav-inner">



        <a href="index.jsp"

           class="brand">

            <div class="brand-box">

                CC

            </div>

            <div class="brand-name">

                Campus<span>Connect</span>

            </div>

        </a>



        <div class="nav-links">

            <a href="#portals">

                Portals

            </a>

            <a href="#journey">

                Journey

            </a>

            <a href="#features">

                Features

            </a>

            <a href="#about">

                About

            </a>

            <a href="#portals"

               class="nav-button">

                Get Started

            </a>

        </div>

    </div>

</nav>





<!-- =========================================================

     HERO

========================================================= -->

<section class="hero">



    <div class="hero-content">



        <div class="hero-tag">

            <span class="hero-dot"></span>

            MULTI-COLLEGE DIGITAL CAMPUS

        </div>



        <h1>

            One campus.

            <br>

            <span>

                Everything connected.

            </span>

        </h1>



        <p class="hero-text">

            CampusConnect brings students, colleges and companies

            together through one centralized platform for admissions,

            academic management and campus recruitment.

        </p>



        <div class="hero-buttons">



            <a href="new_student_colleges.jsp"

               class="primary-button">

                Explore Colleges &rarr;

            </a>



            <a href="student_login.jsp"

               class="secondary-button">

                Student Login

            </a>



        </div>



    </div>



    <div class="hero-info">

        <span>

            STUDENTS

        </span>

        <div class="hero-info-line"></div>

        <span>

            COLLEGES

        </span>

        <div class="hero-info-line"></div>

        <span>

            COMPANIES

        </span>

        <div class="hero-info-line"></div>

        <span>

            ONE PLATFORM

        </span>

    </div>



</section>





<!-- =========================================================

     PORTALS

========================================================= -->

<section class="portals"

         id="portals">



    <div class="container">



        <div class="portal-header">



            <div>

                <div class="portal-eyebrow">

                    CAMPUSCONNECT PORTALS

                </div>



                <h2>

                    One platform.

                    <br>

                    <span>

                        Four dedicated experiences.

                    </span>

                </h2>

            </div>



            <p class="portal-header-text">

                Choose the workspace that matches your role.

                Students, colleges, companies and administrators

                each have their own dedicated portal.

            </p>



        </div>





        <div class="portal-grid">



            <!-- =================================================

                 STUDENT

            ================================================== -->

            <article class="portal-card student">



                <div class="portal-photo student-photo">

                    <div class="photo-overlay"></div>

                    <div class="photo-label">

                        <span class="photo-label-dot"></span>

                        STUDENTS

                    </div>

                </div>



                <div class="portal-body">



                    <div class="portal-role">

                        STUDENT EXPERIENCE

                    </div>



                    <h3>

                        Student Portal

                    </h3>



                    <p class="portal-description">

                        Explore colleges, apply for admission,

                        manage your academic profile, build your

                        resume and discover recruitment opportunities.

                    </p>



                    <div class="feature-list">



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Explore colleges &amp; courses

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Apply for admission

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Manage academic profile

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Build resume &amp; projects

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Discover recruitment opportunities

                        </div>



                    </div>



                    <div class="student-title">

                        CHOOSE YOUR STUDENT ACCOUNT

                    </div>



                    <div class="student-options">



                        <a href="student_login.jsp"

                           class="student-option primary-option">

                            <div class="option-icon">

                                &rarr;

                            </div>

                            <div class="option-text">

                                <strong>

                                    Existing Student

                                </strong>

                                <small>

                                    Login to your account

                                </small>

                            </div>

                            <span class="option-arrow">

                                &rarr;

                            </span>

                        </a>



                        <a href="new_student_colleges.jsp"

                           class="student-option">

                            <div class="option-icon">

                                +

                            </div>

                            <div class="option-text">

                                <strong>

                                    New Student

                                </strong>

                                <small>

                                    Explore colleges &amp; apply

                                </small>

                            </div>

                            <span class="option-arrow">

                                &rarr;

                            </span>

                        </a>



                    </div>



                </div>



            </article>





            <!-- =================================================

                 COLLEGE

            ================================================== -->

            <article class="portal-card college">



                <div class="portal-photo college-photo">

                    <div class="photo-overlay"></div>

                    <div class="photo-label">

                        <span class="photo-label-dot"></span>

                        COLLEGES

                    </div>

                </div>



                <div class="portal-body">



                    <div class="portal-role">

                        COLLEGE EXPERIENCE

                    </div>



                    <h3>

                        College Administration

                    </h3>



                    <p class="portal-description">

                        Manage your institution from one centralized

                        workspace with tools for students, academics,

                        admissions and recruitment.

                    </p>



                    <div class="feature-list">



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Manage students &amp; faculty

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Manage departments &amp; courses

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Handle admissions

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Manage recruitment activities

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Notices &amp; college information

                        </div>



                    </div>



                    <div class="portal-bottom">



                        <div class="info-box">

                            <div class="info-icon">

                                +

                            </div>

                            <div class="info-text">

                                <strong>

                                    Manage your institution

                                </strong>

                                <small>

                                    Complete college workspace

                                </small>

                            </div>

                        </div>



                        <a href="collegeAdminLogin.jsp"

                           class="login-button">

                            <span>

                                College Admin Login

                            </span>

                            <b>

                                &rarr;

                            </b>

                        </a>



                    </div>



                </div>



            </article>





            <!-- =================================================

                 COMPANY

            ================================================== -->

            <article class="portal-card company">



                <div class="portal-photo company-photo">

                    <div class="photo-overlay"></div>

                    <div class="photo-label">

                        <span class="photo-label-dot"></span>

                        COMPANIES

                    </div>

                </div>



                <div class="portal-body">



                    <div class="portal-role">

                        RECRUITMENT EXPERIENCE

                    </div>



                    <h3>

                        Company Portal

                    </h3>



                    <p class="portal-description">

                        Connect with eligible students,

                        create recruitment drives, review

                        applications and manage the hiring workflow.

                    </p>



                    <div class="feature-list">



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Create recruitment drives

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Define eligibility criteria

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Review applications

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Manage interviews

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Complete selection workflow

                        </div>



                    </div>



                    <div class="portal-bottom">



                        <div class="info-box">

                            <div class="info-icon">

                                &rarr;

                            </div>

                            <div class="info-text">

                                <strong>

                                    Recruit campus talent

                                </strong>

                                <small>

                                    Connect with eligible students

                                </small>

                            </div>

                        </div>



                        <a href="<%=request.getContextPath()%>/company-login.jsp"

                           class="login-button">

                            <span>

                                Company Login

                            </span>

                            <b>

                                &rarr;

                            </b>

                        </a>



                    </div>



                </div>



            </article>





            <!-- =================================================

                 SUPER ADMIN

            ================================================== -->

            <article class="portal-card superadmin">



                <div class="portal-photo superadmin-photo">

                    <div class="photo-overlay"></div>

                    <div class="photo-label">

                        <span class="photo-label-dot"></span>

                        ADMINISTRATION

                    </div>

                </div>



                <div class="portal-body">



                    <div class="portal-role">

                        CENTRAL PLATFORM

                    </div>



                    <h3>

                        Super Admin

                    </h3>



                    <p class="portal-description">

                        Manage the centralized CampusConnect

                        platform and the multi-college environment

                        from one administrative workspace.

                    </p>



                    <div class="feature-list">



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Manage multiple colleges

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Monitor students &amp; companies

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Oversee platform activities

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Access system-wide information

                        </div>



                        <div class="feature-item">

                            <span class="feature-check">

                                &#10003;

                            </span>

                            Maintain platform configuration

                        </div>



                    </div>



                    <div class="portal-bottom">



                        <div class="info-box">

                            <div class="info-icon">

                                &#9881;

                            </div>

                            <div class="info-text">

                                <strong>

                                    Manage the platform

                                </strong>

                                <small>

                                    Centralized system administration

                                </small>

                            </div>

                        </div>



                        <a href="<%=request.getContextPath()%>/superadmin/login.jsp"

                           class="login-button">

                            <span>

                                Super Admin Login

                            </span>

                            <b>

                                &rarr;

                            </b>

                        </a>



                    </div>



                </div>



            </article>



        </div>



    </div>



</section>





<!-- =========================================================
     STUDENT JOURNEY - NEW DESIGN
========================================================= -->
<section class="student-journey" id="journey">

    <div class="journey-bg"></div>
    <div class="journey-overlay"></div>

    <div class="journey-container">

        <div class="journey-left">

            <div class="journey-label">
                <span>STUDENT JOURNEY</span>
                <div class="label-line"></div>
            </div>

            <h2>
                From admission<br>
                to <span>opportunity.</span>
            </h2>

            <p class="journey-description">
                CampusConnect connects the major stages of a student's
                campus journey through one structured workflow.
            </p>

            <a href="new_student_colleges.jsp" class="journey-btn">
                Begin your journey
                <span>&rarr;</span>
            </a>

        </div>

        <div class="journey-right">

            <div class="journey-step">
                <div class="step-number">01</div>
                <div class="step-card">
                    <div class="step-icon">&#127979;</div>
                    <div class="step-content">
                        <h3>Explore Colleges</h3>
                        <p>Browse approved colleges and explore available courses.</p>
                    </div>
                    <div class="step-arrow">&rarr;</div>
                </div>
            </div>

            <div class="journey-step">
                <div class="step-number">02</div>
                <div class="step-card">
                    <div class="step-icon">&#128196;</div>
                    <div class="step-content">
                        <h3>Submit Admission Request</h3>
                        <p>Select your course and submit the required admission information.</p>
                    </div>
                    <div class="step-arrow">&rarr;</div>
                </div>
            </div>

            <div class="journey-step">
                <div class="step-number">03</div>
                <div class="step-card">
                    <div class="step-icon approval-icon">&#10003;</div>
                    <div class="step-content">
                        <h3>College Approval</h3>
                        <p>College administration reviews the admission request.</p>
                    </div>
                    <div class="step-arrow">&rarr;</div>
                </div>
            </div>

            <div class="journey-step">
                <div class="step-number">04</div>
                <div class="step-card">
                    <div class="step-icon">&#128179;</div>
                    <div class="step-content">
                        <h3>Fee Payment</h3>
                        <p>Complete the admission fee payment after approval.</p>
                    </div>
                    <div class="step-arrow">&rarr;</div>
                </div>
            </div>

            <div class="journey-step">
                <div class="step-number">05</div>
                <div class="step-card">
                    <div class="step-icon">&#128100;</div>
                    <div class="step-content">
                        <h3>Student Registration</h3>
                        <p>Complete registration and access your CampusConnect account.</p>
                    </div>
                    <div class="step-arrow">&rarr;</div>
                </div>
            </div>

            <div class="journey-step">
                <div class="step-number">06</div>
                <div class="step-card">
                    <div class="step-icon recruitment-icon">&#128188;</div>
                    <div class="step-content">
                        <h3>Campus Recruitment</h3>
                        <p>Apply for eligible recruitment drives and track your journey.</p>
                    </div>
                    <div class="step-arrow">&rarr;</div>
                </div>
            </div>

        </div>

        <div class="journey-stats">

            <div class="journey-stat">
                <div class="stat-icon">&#127891;</div>
                <div>
                    <strong>10+</strong>
                    <span>Colleges</span>
                </div>
            </div>

            <div class="stat-divider"></div>

            <div class="journey-stat">
                <div class="stat-icon students-icon">&#128101;</div>
                <div>
                    <strong>50K+</strong>
                    <span>Students</span>
                </div>
            </div>

            <div class="stat-divider"></div>

            <div class="journey-stat">
                <div class="stat-icon recruitment-stat-icon">&#128188;</div>
                <div>
                    <strong>500+</strong>
                    <span>Recruitment Drives</span>
                </div>
            </div>

        </div>

    </div>
</section>

<!-- =========================================================

     FEATURES

========================================================= -->

<section class="features"

         id="features">



    <div class="container">



        <div class="features-heading">



            <div class="portal-eyebrow">

                PLATFORM CAPABILITIES

            </div>



            <h2>

                Everything your campus needs.

            </h2>



            <p>

                CampusConnect brings admissions, student management,

                college administration and campus recruitment together

                inside one centralized environment.

            </p>



        </div>





        <div class="feature-grid">



            <div class="feature-card">

                <div class="feature-top">

                    <span class="feature-label">

                        STUDENTS

                    </span>

                    <span class="feature-arrow">

                        &rarr;

                    </span>

                </div>

                <h3>

                    Student Management

                </h3>

                <p>

                    Manage profiles, academics, skills, projects,

                    resumes, applications and placement information.

                </p>

            </div>





            <div class="feature-card">

                <div class="feature-top">

                    <span class="feature-label">

                        ADMISSION

                    </span>

                    <span class="feature-arrow">

                        &rarr;

                    </span>

                </div>

                <h3>

                    Centralized Admissions

                </h3>

                <p>

                    Connect college discovery, admission requests,

                    approval, fee payment and registration.

                </p>

            </div>





            <div class="feature-card">

                <div class="feature-top">

                    <span class="feature-label">

                        COLLEGES

                    </span>

                    <span class="feature-arrow">

                        &rarr;

                    </span>

                </div>

                <h3>

                    College Administration

                </h3>

                <p>

                    Manage departments, courses, faculty, students,

                    notices and recruitment activities.

                </p>

            </div>





            <div class="feature-card">

                <div class="feature-top">

                    <span class="feature-label">

                        RECRUITMENT

                    </span>

                    <span class="feature-arrow">

                        &rarr;

                    </span>

                </div>

                <h3>

                    Recruitment Drives

                </h3>

                <p>

                    Connect companies with eligible students

                    and organize campus recruitment activities.

                </p>

            </div>





            <div class="feature-card">

                <div class="feature-top">

                    <span class="feature-label">

                        INTERVIEWS

                    </span>

                    <span class="feature-arrow">

                        &rarr;

                    </span>

                </div>

                <h3>

                    Interview Management

                </h3>

                <p>

                    Track interview schedules, applications

                    and recruitment progress.

                </p>

            </div>





            <div class="feature-card">

                <div class="feature-top">

                    <span class="feature-label">

                        CENTRALIZED

                    </span>

                    <span class="feature-arrow">

                        &rarr;

                    </span>

                </div>

                <h3>

                    Multi-College System

                </h3>

                <p>

                    Provide one connected environment for

                    multiple colleges, students and companies.

                </p>

            </div>



        </div>



    </div>



</section>





<!-- =========================================================

     ABOUT

========================================================= -->

<section class="about"

         id="about">



    <div class="container">



        <div class="about-box">



            <div class="about-image">

            </div>



            <div class="about-content">



                <div class="portal-eyebrow">

                    ABOUT CAMPUSCONNECT

                </div>



                <h2>

                    Where campus meets opportunity.

                </h2>



                <p>

                    CampusConnect is a multi-college centralized

                    recruitment and management system designed

                    to simplify the interaction between students,

                    colleges and companies.

                </p>



                <p style="margin-top:13px;">

                    The platform brings admissions, academic

                    management and campus recruitment together

                    inside one organized digital environment.

                </p>



                <div class="about-button">

                    <a href="#portals"

                       class="primary-button">

                        Explore Platform &rarr;

                    </a>

                </div>



            </div>



        </div>



    </div>



</section>





<!-- =========================================================

     CTA

========================================================= -->

<section class="cta">



    <div class="container">



        <div class="cta-box">



            <div class="cta-content">



                <h2>

                    Your campus.

                    <br>

                    One connected platform.

                </h2>



                <p>

                    Explore colleges, access your student portal

                    or connect with the CampusConnect ecosystem.

                </p>



                <div class="cta-buttons">



                    <a href="new_student_colleges.jsp"

                       class="primary-button white">

                        Explore Colleges &rarr;

                    </a>



                    <a href="student_login.jsp"

                       class="secondary-button">

                        Student Login

                    </a>



                </div>



            </div>



        </div>



    </div>



</section>





<!-- =========================================================

     FOOTER

========================================================= -->

<footer>



    <div class="container">



        <div class="footer-grid">



            <div>



                <a href="index.jsp"

                   class="brand">

                    <div class="brand-box">

                        CC

                    </div>

                    <div class="brand-name">

                        Campus<span>Connect</span>

                    </div>

                </a>



                <p class="footer-description">

                    Multi-College Centralized Recruitment and

                    Management System connecting students,

                    colleges and companies.

                </p>



            </div>





            <div>

                <div class="footer-title">

                    STUDENT

                </div>

                <div class="footer-links">

                    <a href="new_student_colleges.jsp">

                        Explore Colleges

                    </a>

                    <a href="student_login.jsp">

                        Student Login

                    </a>

                </div>

            </div>





            <div>

                <div class="footer-title">

                    ADMINISTRATION

                </div>

                <div class="footer-links">

                    <a href="collegeAdminLogin.jsp">

                        College Admin

                    </a>

                    <a href="<%=request.getContextPath()%>/superadmin/login.jsp">

                        Super Admin

                    </a>

                </div>

            </div>





            <div>

                <div class="footer-title">

                    RECRUITMENT

                </div>

                <div class="footer-links">

                    <a href="<%=request.getContextPath()%>/company-login.jsp">

                        Company Portal

                    </a>

                    <a href="#journey">

                        Student Journey

                    </a>

                </div>

            </div>



        </div>





        <div class="footer-bottom">

            <span>

                &copy; 2026 CampusConnect. All rights reserved.

            </span>

            <span>

                Multi-College Recruitment &amp; Management System

            </span>

        </div>



    </div>



</footer>



</body>

</html>
