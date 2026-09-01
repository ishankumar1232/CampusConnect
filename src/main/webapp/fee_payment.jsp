<%@ page import="java.sql.*" %>

<%
    String admissionId = request.getParameter("admissionId");

    if(admissionId == null || admissionId.trim().equals(""))
    {
        response.sendRedirect("new_student_colleges.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String studentName = "";
    String email = "";
    String phone = "";
    String collegeName = "";
    String courseName = "";
    String status = "";
    String admissionDate = "";

    double amount = 0;

    try
    {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        con = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );

        String sql =
            "SELECT A.ADMISSION_ID, " +
            "A.APPLICANT_NAME, " +
            "A.APPLICANT_EMAIL, " +
            "A.APPLICANT_PHONE, " +
            "A.ADMISSION_DATE, " +
            "A.STATUS, " +
            "C.COLLEGE_NAME, " +
            "CO.COURSE_NAME " +
            "FROM ADMISSION A " +
            "JOIN COLLEGE C ON A.COLLEGE_ID = C.COLLEGE_ID " +
            "JOIN COURSE CO ON A.APPLICANT_COURSE_ID = CO.COURSE_ID " +
            "WHERE A.ADMISSION_ID = ? " +
            "AND A.STATUS = 'APPROVED'";

        ps = con.prepareStatement(sql);

        ps.setInt(1, Integer.parseInt(admissionId));

        rs = ps.executeQuery();

        if(rs.next())
        {
            studentName = rs.getString("APPLICANT_NAME");
            email = rs.getString("APPLICANT_EMAIL");
            phone = rs.getString("APPLICANT_PHONE");
            collegeName = rs.getString("COLLEGE_NAME");
            courseName = rs.getString("COURSE_NAME");
            status = rs.getString("STATUS");

            if(rs.getDate("ADMISSION_DATE") != null)
            {
                admissionDate = rs.getDate("ADMISSION_DATE").toString();
            }

            /*
             * Temporary admission fee.
             * Later you can keep this amount in a database table.
             */
            amount = 50000;
        }
        else
        {
            response.sendRedirect("new_student_colleges.jsp");
            return;
        }
    }
    catch(Exception e)
    {
        out.println("Error: " + e);
    }
    finally
    {
        try
        {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        }
        catch(Exception e)
        {
        }
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Fee Payment | CampusConnect</title>


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
    background: linear-gradient(135deg, #123c88, #1769e0);

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

.back-btn {
    color: white;

    text-decoration: none;

    border: 1px solid rgba(255,255,255,0.7);

    padding: 10px 17px;

    border-radius: 7px;

    font-size: 14px;
}

.back-btn:hover {
    background: rgba(255,255,255,0.15);
}


/* MAIN */

.container {
    width: 90%;

    max-width: 1000px;

    margin: 45px auto;
}


/* TITLE */

.page-title {
    text-align: center;

    margin-bottom: 30px;
}

.page-title h1 {
    color: #173c76;

    font-size: 36px;

    margin-bottom: 10px;
}

.page-title p {
    color: #718096;

    font-size: 15px;
}


/* MAIN GRID */

.payment-grid {
    display: grid;

    grid-template-columns: 1fr 1fr;

    gap: 25px;

    align-items: start;
}


/* CARD */

.card {
    background: white;

    border: 1px solid #e2e8f0;

    border-radius: 16px;

    padding: 28px;

    box-shadow:
        0 8px 25px rgba(30,60,100,0.08);
}

.card h2 {
    color: #173c76;

    font-size: 21px;

    margin-bottom: 22px;
}


/* STUDENT DETAILS */

.detail-row {
    display: flex;

    justify-content: space-between;

    gap: 15px;

    padding: 13px 0;

    border-bottom: 1px solid #edf0f5;
}

.detail-row:last-child {
    border-bottom: none;
}

.label {
    color: #8995a7;

    font-size: 13px;
}

.value {
    color: #344b68;

    font-size: 14px;

    font-weight: bold;

    text-align: right;

    word-break: break-word;
}


/* STATUS */

.status {
    display: inline-block;

    background: #e8f8ee;

    color: #21854b;

    padding: 6px 13px;

    border-radius: 20px;

    font-size: 12px;

    font-weight: bold;
}


/* AMOUNT */

.amount-box {
    background: #f0f6ff;

    border: 1px solid #d9e8ff;

    border-radius: 12px;

    padding: 20px;

    text-align: center;

    margin-bottom: 25px;
}

.amount-label {
    display: block;

    color: #718096;

    font-size: 13px;

    margin-bottom: 8px;
}

.amount {
    color: #173c76;

    font-size: 32px;

    font-weight: bold;
}


/* PAYMENT METHOD */

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;

    color: #344b68;

    font-size: 13px;

    font-weight: bold;

    margin-bottom: 8px;
}

.required {
    color: #e53935;
}

.form-group select,
.form-group input {
    width: 100%;

    padding: 13px;

    border: 1px solid #d6dfeb;

    border-radius: 8px;

    outline: none;

    background: #fbfdff;

    color: #344b68;

    font-size: 14px;
}

.form-group select:focus,
.form-group input:focus {
    border-color: #1769e0;

    box-shadow:
        0 0 0 3px rgba(23,105,224,0.10);
}


/* TRANSACTION */

.transaction-info {
    color: #718096;

    background: #f8fafc;

    border-radius: 8px;

    padding: 12px;

    font-size: 12px;

    line-height: 1.5;

    margin-bottom: 20px;
}


/* PAY BUTTON */

.pay-btn {
    width: 100%;

    border: none;

    background: #1769e0;

    color: white;

    padding: 14px;

    border-radius: 8px;

    font-size: 15px;

    font-weight: bold;

    cursor: pointer;
}

.pay-btn:hover {
    background: #0d54bd;
}


/* NOTE */

.note {
    margin-top: 25px;

    background: #f0f6ff;

    border-left: 4px solid #1769e0;

    padding: 14px;

    border-radius: 6px;

    color: #536984;

    font-size: 13px;

    line-height: 1.5;
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


/* RESPONSIVE */

@media(max-width: 750px)
{
    .payment-grid {
        grid-template-columns: 1fr;
    }

    .page-title h1 {
        font-size: 30px;
    }
}

</style>


<script>

function validatePayment()
{
    var method =
        document.forms["paymentForm"]["paymentMethod"].value;

    if(method == "")
    {
        alert("Please select a payment method");

        return false;
    }

    return true;
}

</script>

</head>


<body>


<!-- HEADER -->

<div class="header">

    <div class="logo">

        Campus<span>Connect</span>

    </div>


    <a href="index.jsp"
       class="back-btn">

        Back to Home

    </a>

</div>



<!-- MAIN -->

<div class="container">


    <!-- TITLE -->

    <div class="page-title">

        <h1>
            Admission Fee Payment
        </h1>

        <p>
            Complete your admission fee payment to confirm your admission.
        </p>

    </div>



    <div class="payment-grid">


        <!-- =========================
             ADMISSION DETAILS
        ========================= -->

        <div class="card">

            <h2>
                Admission Details
            </h2>


            <div class="detail-row">

                <span class="label">
                    Admission ID
                </span>

                <span class="value">
                    <%=admissionId%>
                </span>

            </div>


            <div class="detail-row">

                <span class="label">
                    Student Name
                </span>

                <span class="value">
                    <%=studentName%>
                </span>

            </div>


            <div class="detail-row">

                <span class="label">
                    Email
                </span>

                <span class="value">
                    <%=email%>
                </span>

            </div>


            <div class="detail-row">

                <span class="label">
                    Phone
                </span>

                <span class="value">
                    <%=phone%>
                </span>

            </div>


            <div class="detail-row">

                <span class="label">
                    College
                </span>

                <span class="value">
                    <%=collegeName%>
                </span>

            </div>


            <div class="detail-row">

                <span class="label">
                    Course
                </span>

                <span class="value">
                    <%=courseName%>
                </span>

            </div>


            <div class="detail-row">

                <span class="label">
                    Admission Date
                </span>

                <span class="value">
                    <%=admissionDate%>
                </span>

            </div>


            <div class="detail-row">

                <span class="label">
                    Admission Status
                </span>

                <span class="status">
                    <%=status%>
                </span>

            </div>


        </div>



        <!-- =========================
             PAYMENT
        ========================= -->

        <div class="card">

            <h2>
                Make Payment
            </h2>


            <div class="amount-box">

                <span class="amount-label">
                    Admission Fee
                </span>

                <span class="amount">
                    ₹ <%=String.format("%.2f", amount)%>
                </span>

            </div>


            <form name="paymentForm"

                  method="post"

                  action="FeePaymentServlet"

                  onsubmit="return validatePayment();">


                <!-- ADMISSION ID -->

                <input type="hidden"

                       name="admissionId"

                       value="<%=admissionId%>">


                <!-- AMOUNT -->

                <input type="hidden"

                       name="amount"

                       value="<%=amount%>">



                <!-- PAYMENT METHOD -->

                <div class="form-group">

                    <label>

                        Payment Method

                        <span class="required">*</span>

                    </label>


                    <select name="paymentMethod"
                            required>

                        <option value="">
                            Select Payment Method
                        </option>

                        <option value="UPI">
                            UPI
                        </option>

                        <option value="CARD">
                            Debit / Credit Card
                        </option>

                        <option value="NET BANKING">
                            Net Banking
                        </option>

                    </select>

                </div>



                <!-- TRANSACTION ID -->

                <div class="form-group">

                    <label>
                        Transaction ID
                    </label>


                    <input type="text"

                           name="transactionId"

                           placeholder="Enter transaction ID"

                           maxlength="100">

                </div>



                <div class="transaction-info">

                    Please enter the transaction/reference ID
                    received after completing your payment.

                </div>



                <!-- PAY -->

                <button type="submit"
                        class="pay-btn">

                    Pay ₹ <%=String.format("%.2f", amount)%>

                </button>


            </form>


            <!-- NOTE -->

            <div class="note">

                <b>Note:</b>

                Payment is available only after your admission
                request has been approved by the college.

            </div>


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