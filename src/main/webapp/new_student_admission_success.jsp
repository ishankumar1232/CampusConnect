<%
    Object idObj = request.getAttribute("admissionId");
    Object nameObj = request.getAttribute("name");
    Object emailObj = request.getAttribute("email");
    Object collegeIdObj = request.getAttribute("collegeId");

    String admissionId =
        idObj != null ? idObj.toString() : "";

    String name =
        nameObj != null ? nameObj.toString() : "";

    String email =
        emailObj != null ? emailObj.toString() : "";

    String collegeId =
        collegeIdObj != null ? collegeIdObj.toString() : "";
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Admission Submitted | CampusConnect
</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    background: #f4f7fb;
    color: #26364f;
}


/* HEADER */

.header {
    background: linear-gradient(
        135deg,
        #123c88,
        #1769e0
    );

    color: white;

    padding: 20px 7%;

    display: flex;

    justify-content: space-between;

    align-items: center;
}

.logo {
    font-size: 27px;
    font-weight: bold;
}

.logo span {
    color: #a9d0ff;
}

.home-btn {
    color: white;

    text-decoration: none;

    border: 1px solid rgba(255,255,255,0.7);

    padding: 10px 17px;

    border-radius: 7px;

    font-size: 14px;
}

.home-btn:hover {
    background: rgba(255,255,255,0.15);
}


/* MAIN */

.container {
    width: 90%;

    max-width: 850px;

    margin: 55px auto;
}


/* SUCCESS CARD */

.success-card {
    background: white;

    border-radius: 18px;

    border: 1px solid #e2e8f0;

    box-shadow:
        0 10px 30px rgba(30,60,100,0.10);

    padding: 45px 45px;

    text-align: center;
}


/* SUCCESS ICON */

.success-icon {
    width: 85px;
    height: 85px;

    margin: 0 auto 25px;

    border-radius: 50%;

    background: #e5f8ed;

    color: #20a05a;

    font-size: 55px;

    font-weight: bold;

    display: flex;

    align-items: center;

    justify-content: center;
}


/* TITLE */

.success-card h1 {
    color: #173c76;

    font-size: 34px;

    margin-bottom: 12px;
}

.subtitle {
    color: #718096;

    font-size: 15px;

    margin-bottom: 32px;
}


/* DETAILS */

.details {
    text-align: left;

    background: #f7faff;

    border: 1px solid #e2e9f3;

    border-radius: 12px;

    padding: 10px 25px;

    margin-bottom: 25px;
}

.row {
    display: flex;

    justify-content: space-between;

    align-items: center;

    padding: 17px 5px;

    border-bottom: 1px solid #e2e9f3;
}

.row:last-child {
    border-bottom: none;
}

.label {
    color: #8995a7;

    font-size: 14px;
}

.value {
    color: #344b68;

    font-size: 15px;

    font-weight: bold;

    text-align: right;
}


/* STATUS */

.status {
    display: inline-block;

    padding: 7px 16px;

    border-radius: 20px;

    background: #fff3d4;

    color: #a36b00;

    font-size: 12px;

    font-weight: bold;
}


/* NEXT STEP */

.next-box {
    text-align: left;

    background: #f0f6ff;

    border-left: 4px solid #1769e0;

    padding: 17px;

    border-radius: 7px;

    color: #536984;

    font-size: 13px;

    line-height: 1.6;

    margin-bottom: 25px;
}

.next-box b {
    color: #173c76;

    font-size: 15px;
}


/* BUTTONS */

.buttons {
    display: flex;

    gap: 14px;

    justify-content: center;
}

.track-btn {
    flex: 1;

    max-width: 300px;

    padding: 14px 20px;

    border-radius: 8px;

    background: #1769e0;

    color: white;

    text-decoration: none;

    font-size: 14px;

    font-weight: bold;
}

.track-btn:hover {
    background: #0d54bd;
}

.colleges-btn {
    flex: 1;

    max-width: 300px;

    padding: 14px 20px;

    border-radius: 8px;

    border: 1px solid #1769e0;

    background: white;

    color: #1769e0;

    text-decoration: none;

    font-size: 14px;

    font-weight: bold;
}

.colleges-btn:hover {
    background: #f0f6ff;
}


/* FOOTER */

.footer {
    margin-top: 60px;

    background: #123c88;

    color: #dceaff;

    text-align: center;

    padding: 20px;

    font-size: 13px;
}


/* MOBILE */

@media(max-width:650px)
{
    .success-card {
        padding: 30px 20px;
    }

    .success-card h1 {
        font-size: 27px;
    }

    .row {
        flex-direction: column;

        align-items: flex-start;

        gap: 6px;
    }

    .value {
        text-align: left;
    }

    .buttons {
        flex-direction: column;
    }

    .track-btn,
    .colleges-btn {
        max-width: 100%;
        width: 100%;
    }
}

</style>

</head>


<body>


<!-- HEADER -->

<div class="header">

    <div class="logo">

        Campus<span>Connect</span>

    </div>


    <a href="index.jsp"
       class="home-btn">

        Home

    </a>

</div>


<!-- MAIN -->

<div class="container">


    <div class="success-card">


        <!-- SUCCESS ICON -->

        <div class="success-icon">

            ✓

        </div>


        <!-- TITLE -->

        <h1>

            Admission Request Submitted Successfully

        </h1>


        <p class="subtitle">

            Your admission request has been successfully
            submitted to the selected college.

        </p>


        <!-- DETAILS -->

        <div class="details">


            <div class="row">

                <span class="label">

                    Request ID

                </span>

                <span class="value">

                    <%= admissionId %>

                </span>

            </div>


            <div class="row">

                <span class="label">

                    Applicant Name

                </span>

                <span class="value">

                    <%= name %>

                </span>

            </div>


            <div class="row">

                <span class="label">

                    Email

                </span>

                <span class="value">

                    <%= email %>

                </span>

            </div>


            <div class="row">

                <span class="label">

                    College ID

                </span>

                <span class="value">

                    <%= collegeId %>

                </span>

            </div>


            <div class="row">

                <span class="label">

                    Application Status

                </span>

                <span class="value">

                    <span class="status">

                        PENDING

                    </span>

                </span>

            </div>


        </div>


        <!-- NEXT STEP -->

        <div class="next-box">

            <b>What happens next?</b>

            <br>

            Your request will be reviewed by the college
            administrator. After approval, you can check
            your admission status and pay the admission fee.

        </div>


        <!-- BUTTONS -->

        <div class="buttons">


            <a href="admission_status.jsp?admissionId=<%= admissionId %>"
               class="track-btn">

                Track Admission Status

            </a>


            <a href="new_student_colleges.jsp"
               class="colleges-btn">

                View Available Colleges

            </a>


        </div>


    </div>


</div>


<!-- FOOTER -->

<div class="footer">

    CampusConnect |
    Campus Recruitment Management System

</div>


</body>

</html>