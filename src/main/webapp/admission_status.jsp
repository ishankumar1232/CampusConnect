<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>


<%

    String admissionId =
        request.getParameter("admissionId");

    String email =
        request.getParameter("email");


    String status = "";

    String studentName = "";

    String collegeName = "";

    String courseName = "";

    String admissionDate = "";

    boolean found = false;


    // Payment details

    String paymentStatus = "";

    String paymentAmount = "";

    String paymentDate = "";

    String paymentMethod = "";

    String transactionId = "";


    if(admissionId != null &&
       !admissionId.trim().equals(""))
    {

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


            /*
             * Get admission details
             *
             * If email is provided,
             * verify Admission ID + Email.
             */

            String sql =
                "SELECT A.ADMISSION_ID, " +
                "A.APPLICANT_NAME, " +
                "A.ADMISSION_DATE, " +
                "A.STATUS, " +
                "C.COLLEGE_NAME, " +
                "CO.COURSE_NAME " +
                "FROM ADMISSION A " +
                "JOIN COLLEGE C " +
                "ON A.COLLEGE_ID = C.COLLEGE_ID " +
                "JOIN COURSE CO " +
                "ON A.APPLICANT_COURSE_ID = CO.COURSE_ID " +
                "WHERE A.ADMISSION_ID=?";


            if(email != null &&
               !email.trim().equals(""))
            {

                sql =
                    "SELECT A.ADMISSION_ID, " +
                    "A.APPLICANT_NAME, " +
                    "A.ADMISSION_DATE, " +
                    "A.STATUS, " +
                    "C.COLLEGE_NAME, " +
                    "CO.COURSE_NAME " +
                    "FROM ADMISSION A " +
                    "JOIN COLLEGE C " +
                    "ON A.COLLEGE_ID = C.COLLEGE_ID " +
                    "JOIN COURSE CO " +
                    "ON A.APPLICANT_COURSE_ID = CO.COURSE_ID " +
                    "WHERE A.ADMISSION_ID=? " +
                    "AND LOWER(A.APPLICANT_EMAIL)=LOWER(?)";

            }


            ps = con.prepareStatement(sql);


            ps.setInt(
                1,
                Integer.parseInt(admissionId)
            );


            if(email != null &&
               !email.trim().equals(""))
            {
                ps.setString(
                    2,
                    email.trim()
                );
            }


            rs = ps.executeQuery();


            if(rs.next())
            {

                found = true;


                studentName =
                    rs.getString("APPLICANT_NAME");


                collegeName =
                    rs.getString("COLLEGE_NAME");


                courseName =
                    rs.getString("COURSE_NAME");


                status =
                    rs.getString("STATUS");


                if(rs.getDate("ADMISSION_DATE") != null)
                {

                    admissionDate =
                        rs.getDate("ADMISSION_DATE").toString();

                }


            }


            rs.close();

            ps.close();


            /*
             * Get payment details
             *
             * Only if payment exists.
             */

            if(found)
            {

                String paymentSql =
                    "SELECT AMOUNT, " +
                    "PAYMENT_DATE, " +
                    "PAYMENT_METHOD, " +
                    "TRANSACTION_ID, " +
                    "PAYMENT_STATUS " +
                    "FROM FEE_PAYMENT " +
                    "WHERE ADMISSION_ID=? " +
                    "ORDER BY PAYMENT_ID DESC";


                PreparedStatement paymentPs =
                    con.prepareStatement(paymentSql);


                paymentPs.setInt(
                    1,
                    Integer.parseInt(admissionId)
                );


                ResultSet paymentRs =
                    paymentPs.executeQuery();


                if(paymentRs.next())
                {

                    paymentAmount =
                        String.valueOf(
                            paymentRs.getDouble("AMOUNT")
                        );


                    if(paymentRs.getDate("PAYMENT_DATE") != null)
                    {

                        paymentDate =
                            paymentRs.getDate(
                                "PAYMENT_DATE"
                            ).toString();

                    }


                    paymentMethod =
                        paymentRs.getString(
                            "PAYMENT_METHOD"
                        );


                    transactionId =
                        paymentRs.getString(
                            "TRANSACTION_ID"
                        );


                    paymentStatus =
                        paymentRs.getString(
                            "PAYMENT_STATUS"
                        );

                }


                paymentRs.close();

                paymentPs.close();

            }

        }
        catch(Exception e)
        {

            out.println(
                "<p>Error: "
                + e.getMessage()
                + "</p>"
            );

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

    }

%>


<!DOCTYPE html>

<html lang="en">


<head>

<meta charset="UTF-8">


<meta name="viewport"
      content="width=device-width, initial-scale=1.0">


<title>
    Track Admission | CampusConnect
</title>


<style>


*{

    margin:0;

    padding:0;

    box-sizing:border-box;

    font-family:Arial,sans-serif;

}


body{

    background:#f4f7fb;

    color:#26364f;

}


/* HEADER */

.header{

    background:
    linear-gradient(
        135deg,
        #123c88,
        #1769e0
    );

    color:white;

    padding:20px 7%;

    display:flex;

    justify-content:space-between;

    align-items:center;

}


.logo{

    font-size:27px;

    font-weight:bold;

}


.logo span{

    color:#a9d0ff;

}


.home-btn{

    color:white;

    text-decoration:none;

    border:1px solid rgba(255,255,255,0.7);

    padding:9px 16px;

    border-radius:7px;

    font-size:14px;

}


.home-btn:hover{

    background:rgba(255,255,255,0.15);

}


/* MAIN */

.container{

    width:90%;

    max-width:850px;

    margin:55px auto;

}


/* TITLE */

.title{

    text-align:center;

    margin-bottom:30px;

}


.title h1{

    color:#173c76;

    font-size:34px;

    margin-bottom:10px;

}


.title p{

    color:#718096;

    font-size:15px;

}


/* SEARCH CARD */

.search-card{

    background:white;

    padding:28px;

    border-radius:15px;

    border:1px solid #e2e8f0;

    box-shadow:
        0 7px 25px
        rgba(30,60,100,0.08);

    margin-bottom:25px;

}


.search-card h2{

    color:#173c76;

    font-size:20px;

    margin-bottom:17px;

}


.search-form{

    display:flex;

    gap:12px;

}


.search-form input{

    flex:1;

    padding:13px;

    border:1px solid #d6dfeb;

    border-radius:8px;

    outline:none;

    font-size:14px;

}


.search-form input:focus{

    border-color:#1769e0;

    box-shadow:
        0 0 0 3px
        rgba(23,105,224,0.10);

}


.search-form button{

    padding:13px 23px;

    border:none;

    border-radius:8px;

    background:#1769e0;

    color:white;

    font-weight:bold;

    cursor:pointer;

}


.search-form button:hover{

    background:#0d54bd;

}


/* RESULT */

.result-card{

    background:white;

    border-radius:16px;

    border:1px solid #e2e8f0;

    box-shadow:
        0 8px 25px
        rgba(30,60,100,0.08);

    padding:30px;

}


/* RESULT HEADER */

.result-header{

    display:flex;

    justify-content:space-between;

    align-items:center;

    margin-bottom:22px;

}


.result-header h2{

    color:#173c76;

    font-size:21px;

}


/* STATUS */

.status{

    padding:7px 15px;

    border-radius:20px;

    font-size:12px;

    font-weight:bold;

}


.pending{

    background:#fff5d6;

    color:#a36b00;

}


.approved{

    background:#e6f7ed;

    color:#21854b;

}


.rejected{

    background:#fdeaea;

    color:#c62828;

}


.confirmed{

    background:#e6f7ed;

    color:#21854b;

}


/* DETAILS */

.details{

    background:#f7faff;

    border:1px solid #e2e9f3;

    border-radius:12px;

    padding:20px;

}


.row{

    display:flex;

    justify-content:space-between;

    gap:20px;

    padding:13px 5px;

    border-bottom:1px solid #e7edf5;

}


.row:last-child{

    border-bottom:none;

}


.label{

    color:#8995a7;

    font-size:13px;

}


.value{

    color:#344b68;

    font-size:14px;

    font-weight:bold;

    text-align:right;

}


/* MESSAGE */

.message{

    margin-top:22px;

    padding:15px;

    border-radius:9px;

    font-size:13px;

    line-height:1.5;

}


.pending-message{

    background:#fff9e8;

    color:#806000;

    border-left:4px solid #e4ad22;

}


.approved-message{

    background:#edf9f2;

    color:#216d42;

    border-left:4px solid #2da65b;

}


.rejected-message{

    background:#fff0f0;

    color:#a62828;

    border-left:4px solid #d94343;

}


/* BUTTON */

.pay-btn{

    display:inline-block;

    margin-top:20px;

    padding:13px 24px;

    background:#1769e0;

    color:white;

    text-decoration:none;

    border-radius:8px;

    font-size:14px;

    font-weight:bold;

}


.pay-btn:hover{

    background:#0d54bd;

}


/* PAYMENT */

.payment-box{

    margin-top:25px;

    background:#f7faff;

    border:1px solid #dce7f5;

    border-radius:12px;

    padding:22px;

}


.payment-box h3{

    color:#173c76;

    margin-bottom:15px;

    font-size:18px;

}


.payment-success{

    background:#e8f8ee;

    color:#18743e;

    padding:10px 14px;

    border-radius:7px;

    display:inline-block;

    font-weight:bold;

    font-size:13px;

    margin-bottom:15px;

}


/* NOT FOUND */

.not-found{

    background:#fff0f0;

    color:#a62828;

    border-left:4px solid #d94343;

    padding:15px;

    border-radius:8px;

    margin-top:20px;

    font-size:14px;

}


/* FOOTER */

.footer{

    margin-top:70px;

    background:#123c88;

    color:#dceaff;

    text-align:center;

    padding:20px;

    font-size:13px;

}


/* RESPONSIVE */

@media(max-width:650px)

{

    .search-form{

        flex-direction:column;

    }


    .result-header{

        flex-direction:column;

        align-items:flex-start;

        gap:12px;

    }


    .row{

        flex-direction:column;

        gap:5px;

    }


    .value{

        text-align:left;

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


    <!-- TITLE -->

    <div class="title">

        <h1>
            Track Your Admission
        </h1>

        <p>
            Check the current status of your admission request.
        </p>

    </div>



    <!-- SEARCH -->

    <div class="search-card">


        <h2>
            Enter Your Admission Details
        </h2>


        <form method="get"
              action="admission_status.jsp"
              class="search-form">


            <input type="text"
                   name="admissionId"
                   placeholder="Admission ID"
                   value="<%= admissionId != null ? admissionId : "" %>"
                   required>


            <input type="email"
                   name="email"
                   placeholder="Email ID"
                   value="<%= email != null ? email : "" %>"
                   required>


            <button type="submit">

                Check Status

            </button>


        </form>


    </div>



<%

    if(admissionId != null &&
       !admissionId.trim().equals(""))
    {

        if(found)
        {

%>


    <!-- RESULT -->

    <div class="result-card">


        <div class="result-header">


            <h2>
                Admission Details
            </h2>


<%

            if("PENDING".equalsIgnoreCase(status))
            {

%>

                <span class="status pending">
                    PENDING
                </span>

<%

            }

            else if("APPROVED".equalsIgnoreCase(status))
            {

%>

                <span class="status approved">
                    APPROVED
                </span>

<%

            }

            else if("REJECTED".equalsIgnoreCase(status))
            {

%>

                <span class="status rejected">
                    REJECTED
                </span>

<%

            }

            else if("CONFIRMED".equalsIgnoreCase(status))
            {

%>

                <span class="status confirmed">
                    CONFIRMED
                </span>

<%

            }

            else
            {

%>

                <span class="status">
                    <%= status %>
                </span>

<%

            }

%>


        </div>



        <!-- ADMISSION DETAILS -->

        <div class="details">


            <div class="row">

                <span class="label">
                    Admission ID
                </span>

                <span class="value">
                    <%= admissionId %>
                </span>

            </div>


            <div class="row">

                <span class="label">
                    Student Name
                </span>

                <span class="value">
                    <%= studentName %>
                </span>

            </div>


            <div class="row">

                <span class="label">
                    College
                </span>

                <span class="value">
                    <%= collegeName %>
                </span>

            </div>


            <div class="row">

                <span class="label">
                    Course
                </span>

                <span class="value">
                    <%= courseName %>
                </span>

            </div>


            <div class="row">

                <span class="label">
                    Admission Date
                </span>

                <span class="value">
                    <%= admissionDate %>
                </span>

            </div>


            <div class="row">

                <span class="label">
                    Current Status
                </span>

                <span class="value">
                    <%= status %>
                </span>

            </div>


        </div>



<%

        /* PENDING */

        if("PENDING".equalsIgnoreCase(status))
        {

%>


        <div class="message pending-message">

            <b>
                Admission request is under review.
            </b>

            <br>

            The college has not approved your request yet.

            <br>

            Please wait for the College Admin to review
            your application.

            <br><br>

            You do not need to submit the admission
            request again.

        </div>


<%

        }


        /* APPROVED */

        else if("APPROVED".equalsIgnoreCase(status))
        {

%>


        <div class="message approved-message">

            <b>
                Congratulations! Your admission has been approved.
            </b>

            <br>

            You can now complete your admission by
            paying the required admission fee.

        </div>


        <a href="fee_payment.jsp?admissionId=<%=admissionId%>"
           class="pay-btn">

            Pay Admission Fee

        </a>


<%

        }


        /* REJECTED */

        else if("REJECTED".equalsIgnoreCase(status))
        {

%>


        <div class="message rejected-message">

            <b>
                Admission request rejected.
            </b>

            <br>

            Your admission request was not approved
            by the college.

            <br><br>

            Please contact the college for more information.

        </div>


<%

        }


        /* CONFIRMED */

        else if("CONFIRMED".equalsIgnoreCase(status))
        {

%>


        <div class="message approved-message">

            <b>
                Admission Confirmed.
            </b>

            <br>

            Your admission fee has been successfully paid
            and your admission is confirmed.

        </div>



<%

            /*
             * Payment details
             */

            if(paymentStatus != null &&
               !paymentStatus.trim().equals(""))
            {

%>


        <div class="payment-box">


            <h3>
                Payment Details
            </h3>


            <div class="payment-success">

                Payment Status:
                <%= paymentStatus %>

            </div>


            <div class="details">


                <div class="row">

                    <span class="label">
                        Amount Paid
                    </span>

                    <span class="value">
                        ₹ <%= paymentAmount %>
                    </span>

                </div>


                <div class="row">

                    <span class="label">
                        Payment Date
                    </span>

                    <span class="value">
                        <%= paymentDate %>
                    </span>

                </div>


                <div class="row">

                    <span class="label">
                        Payment Method
                    </span>

                    <span class="value">
                        <%= paymentMethod %>
                    </span>

                </div>


                <div class="row">

                    <span class="label">
                        Transaction ID
                    </span>

                    <span class="value">
                        <%= transactionId %>
                    </span>

                </div>


            </div>


        </div>


<%

            }

%>


        <!-- REGISTRATION -->

        <a href="student_register.jsp?admissionId=<%=admissionId%>"
           class="pay-btn">

            Complete Student Registration

        </a>


<%

        }

%>


    </div>


<%

        }

        else
        {

%>


    <div class="not-found">

        No admission request found for the
        given Admission ID and Email.

        <br><br>

        Please check your details and try again.

    </div>


<%

        }

    }

%>


</div>



<!-- FOOTER -->

<div class="footer">

    CampusConnect |
    Campus Recruitment Management System

</div>


</body>

</html>