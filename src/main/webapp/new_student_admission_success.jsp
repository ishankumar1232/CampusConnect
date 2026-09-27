<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    Object admissionIdObj = request.getAttribute("admissionId");
    Object nameObj = request.getAttribute("name");
    Object emailObj = request.getAttribute("email");

    String admissionId =
        admissionIdObj != null ? admissionIdObj.toString() : "";

    String name =
        nameObj != null ? nameObj.toString() : "";

    String email =
        emailObj != null ? emailObj.toString() : "";
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Admission Request Submitted</title>

<style>

*{
    box-sizing:border-box;
}

body{
    margin:0;
    font-family:Arial,sans-serif;
    background:#f4f7fb;
}

.header{
    background:linear-gradient(135deg,#123c88,#1769e0);
    color:white;
    text-align:center;
    padding:25px;
}

.header h1{
    margin:0;
}

.container{
    width:650px;
    max-width:94%;
    margin:50px auto;
}

.card{
    background:white;
    padding:35px;
    border-radius:15px;
    box-shadow:0 8px 25px rgba(30,60,100,0.10);
    text-align:center;
}

.success-icon{
    width:70px;
    height:70px;
    line-height:70px;
    margin:0 auto 20px;
    border-radius:50%;
    background:#e6f7ed;
    color:#21854b;
    font-size:38px;
    font-weight:bold;
}

h2{
    color:#173c76;
}

.message{
    color:#667085;
    line-height:1.6;
}

.request-box{
    background:#f7faff;
    border:1px solid #dfe8f5;
    border-radius:10px;
    padding:20px;
    margin:25px 0;
    text-align:left;
}

.row{
    display:flex;
    justify-content:space-between;
    padding:12px 5px;
    border-bottom:1px solid #e7edf5;
}

.row:last-child{
    border-bottom:none;
}

.label{
    color:#8995a7;
}

.value{
    font-weight:bold;
    color:#173c76;
}

.request-id{
    color:#1769e0;
    font-size:20px;
}

.buttons{
    display:flex;
    gap:12px;
    justify-content:center;
    flex-wrap:wrap;
}

.btn{
    display:inline-block;
    padding:12px 20px;
    border-radius:7px;
    text-decoration:none;
    font-weight:bold;
}

.primary{
    background:#1769e0;
    color:white;
}

.secondary{
    background:#eef3f9;
    color:#173c76;
}

.note{
    margin-top:20px;
    padding:15px;
    background:#fff9e8;
    color:#806000;
    border-radius:8px;
    text-align:left;
    font-size:14px;
}

</style>

</head>

<body>


<div class="header">

    <h1>CampusConnect</h1>

    <p>Admission Request</p>

</div>


<div class="container">

<div class="card">


    <div class="success-icon">
        ✓
    </div>


    <h2>
        Admission Request Submitted
    </h2>


    <p class="message">

        Your admission request has been successfully
        submitted and is currently waiting for
        College Admin approval.

    </p>


    <div class="request-box">


        <div class="row">

            <span class="label">
                Request ID
            </span>

            <span class="value request-id">
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
                Status
            </span>

            <span class="value">
                PENDING
            </span>

        </div>


    </div>


    <div class="note">

        <b>Important:</b>

        Please remember your
        <b>Request ID</b> and
        <b>Email ID</b>.

        You can use them later to check your
        admission status. You do not need to
        submit the admission request again.

    </div>


    <br>


    <div class="buttons">

        <a href="admission_status.jsp?admissionId=<%= admissionId %>"
           class="btn primary">

            View Status

        </a>


        <a href="new_student_check_status.jsp"
           class="btn secondary">

            Track Later

        </a>

    </div>


</div>

</div>

</body>

</html>