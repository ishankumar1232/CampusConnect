package com.campusconnect.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.campusconnect.util.DBConnection;


 
public class FeePaymentServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String admissionId = req.getParameter("admissionId");
        String amount = req.getParameter("amount");
        String paymentMethod = req.getParameter("paymentMethod");
        String transactionId = req.getParameter("transactionId");

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;

        ResultSet rs = null;

        try
        {
            /* =========================
               CHECK INPUT
               ========================= */

            if(admissionId == null ||
               admissionId.trim().equals(""))
            {
                pw.println("<h2>Invalid Admission ID</h2>");
                return;
            }

            if(amount == null ||
               amount.trim().equals(""))
            {
                pw.println("<h2>Invalid Payment Amount</h2>");
                return;
            }

            if(paymentMethod == null ||
               paymentMethod.trim().equals(""))
            {
                pw.println("<h2>Please select Payment Method</h2>");
                return;
            }


            /* =========================
               DATABASE CONNECTION
               ========================= */

            con = DBConnection.getConnection();

            /*
             * We are doing multiple database
             * operations, so transaction is used.
             */

            con.setAutoCommit(false);


            /* =========================
               STEP 1
               CHECK ADMISSION
               ========================= */

            String checkSql =
                "SELECT STATUS " +
                "FROM ADMISSION " +
                "WHERE ADMISSION_ID = ?";

            ps = con.prepareStatement(checkSql);

            ps.setInt(
                1,
                Integer.parseInt(admissionId)
            );

            rs = ps.executeQuery();


            if(!rs.next())
            {
                pw.println("<html>");
                pw.println("<body>");

                pw.println("<h2>Admission Not Found</h2>");

                pw.println(
                    "<p>Invalid Admission ID.</p>"
                );

                pw.println("</body>");
                pw.println("</html>");

                return;
            }


            String status =
                rs.getString("STATUS");


            rs.close();
            rs = null;

            ps.close();
            ps = null;


            /* =========================
               STEP 2
               CHECK APPROVAL
               ========================= */

            if(!"APPROVED".equalsIgnoreCase(status))
            {
                pw.println("<html>");
                pw.println("<body>");

                pw.println(
                    "<h2>Payment Not Available</h2>"
                );

                pw.println(
                    "<p>Your admission has not been approved yet.</p>"
                );

                pw.println(
                    "<p>Current Status: " +
                    status +
                    "</p>"
                );

                pw.println(
                    "<br>"
                );

                pw.println(
                    "<a href='index.jsp'>Back to Home</a>"
                );

                pw.println("</body>");
                pw.println("</html>");

                return;
            }


            /* =========================
               STEP 3
               TRANSACTION ID
               ========================= */

            if(transactionId == null ||
               transactionId.trim().equals(""))
            {
                transactionId =
                    "CC" +
                    System.currentTimeMillis();
            }


            /* =========================
               STEP 4
               INSERT PAYMENT
               ========================= */

            String insertSql =
                "INSERT INTO FEE_PAYMENT " +
                "(PAYMENT_ID, " +
                "ADMISSION_ID, " +
                "AMOUNT, " +
                "PAYMENT_DATE, " +
                "PAYMENT_METHOD, " +
                "TRANSACTION_ID, " +
                "PAYMENT_STATUS) " +

                "VALUES " +

                "(FEE_PAYMENT_SEQ.NEXTVAL, " +
                "?, ?, SYSDATE, ?, ?, 'SUCCESS')";


            ps2 =
                con.prepareStatement(insertSql);


            ps2.setInt(
                1,
                Integer.parseInt(admissionId)
            );


            ps2.setDouble(
                2,
                Double.parseDouble(amount)
            );


            ps2.setString(
                3,
                paymentMethod
            );


            ps2.setString(
                4,
                transactionId
            );


            int paymentResult =
                ps2.executeUpdate();


            /* =========================
               STEP 5
               UPDATE ADMISSION
               ========================= */

            if(paymentResult > 0)
            {
                String updateSql =
                    "UPDATE ADMISSION " +
                    "SET STATUS = 'CONFIRMED' " +
                    "WHERE ADMISSION_ID = ?";


                ps3 =
                    con.prepareStatement(updateSql);


                ps3.setInt(
                    1,
                    Integer.parseInt(admissionId)
                );


                int updateResult =
                    ps3.executeUpdate();


                if(updateResult > 0)
                {
                    /* =========================
                       STEP 6
                       COMMIT
                       ========================= */

                    con.commit();


                    /* =========================
                       STEP 7
                       SUCCESS PAGE
                       ========================= */

                    pw.println(
                        "<!DOCTYPE html>"
                    );

                    pw.println(
                        "<html lang='en'>"
                    );


                    pw.println("<head>");

                    pw.println(
                        "<meta charset='UTF-8'>"
                    );


                    pw.println(
                        "<meta name='viewport' " +
                        "content='width=device-width, " +
                        "initial-scale=1.0'>"
                    );


                    pw.println(
                        "<title>" +
                        "Payment Successful | CampusConnect" +
                        "</title>"
                    );


                    /* =========================
                       CSS
                       ========================= */

                    pw.println("<style>");

                    pw.println(
                        "*{" +
                        "margin:0;" +
                        "padding:0;" +
                        "box-sizing:border-box;" +
                        "font-family:Arial,sans-serif;" +
                        "}"
                    );


                    pw.println(
                        "body{" +
                        "background:#f3f7fc;" +
                        "color:#243b5a;" +
                        "}"
                    );


                    /* HEADER */

                    pw.println(
                        ".header{" +
                        "background:linear-gradient(" +
                        "135deg,#123c88,#1769e0);" +
                        "padding:20px 7%;" +
                        "color:white;" +
                        "}"
                    );


                    pw.println(
                        ".logo{" +
                        "font-size:27px;" +
                        "font-weight:bold;" +
                        "}"
                    );


                    pw.println(
                        ".logo span{" +
                        "color:#a9d0ff;" +
                        "}"
                    );


                    /* CONTAINER */

                    pw.println(
                        ".container{" +
                        "width:90%;" +
                        "max-width:750px;" +
                        "margin:60px auto;" +
                        "}"
                    );


                    /* CARD */

                    pw.println(
                        ".card{" +
                        "background:white;" +
                        "border-radius:18px;" +
                        "padding:45px;" +
                        "text-align:center;" +
                        "box-shadow:" +
                        "0 10px 35px " +
                        "rgba(30,60,100,0.10);" +
                        "}"
                    );


                    /* ICON */

                    pw.println(
                        ".success-icon{" +
                        "width:85px;" +
                        "height:85px;" +
                        "margin:0 auto 20px;" +
                        "border-radius:50%;" +
                        "background:#e6f7ed;" +
                        "color:#219653;" +
                        "font-size:50px;" +
                        "display:flex;" +
                        "align-items:center;" +
                        "justify-content:center;" +
                        "}"
                    );


                    pw.println(
                        "h1{" +
                        "color:#173c76;" +
                        "font-size:30px;" +
                        "margin-bottom:12px;" +
                        "}"
                    );


                    pw.println(
                        ".message{" +
                        "color:#718096;" +
                        "font-size:15px;" +
                        "line-height:1.6;" +
                        "margin-bottom:28px;" +
                        "}"
                    );


                    /* DETAILS */

                    pw.println(
                        ".details{" +
                        "background:#f7faff;" +
                        "border:1px solid #e2e9f3;" +
                        "border-radius:12px;" +
                        "padding:20px;" +
                        "text-align:left;" +
                        "margin-bottom:28px;" +
                        "}"
                    );


                    pw.println(
                        ".row{" +
                        "display:flex;" +
                        "justify-content:space-between;" +
                        "gap:20px;" +
                        "padding:13px 5px;" +
                        "border-bottom:1px solid #e7edf5;" +
                        "}"
                    );


                    pw.println(
                        ".row:last-child{" +
                        "border-bottom:none;" +
                        "}"
                    );


                    pw.println(
                        ".label{" +
                        "color:#8995a7;" +
                        "font-size:13px;" +
                        "}"
                    );


                    pw.println(
                        ".value{" +
                        "color:#344b68;" +
                        "font-size:14px;" +
                        "font-weight:bold;" +
                        "text-align:right;" +
                        "word-break:break-word;" +
                        "}"
                    );


                    /* STATUS */

                    pw.println(
                        ".status{" +
                        "display:inline-block;" +
                        "background:#e6f7ed;" +
                        "color:#21854b;" +
                        "padding:7px 15px;" +
                        "border-radius:20px;" +
                        "font-size:12px;" +
                        "font-weight:bold;" +
                        "}"
                    );


                    /* BUTTON */

                    pw.println(
                        ".btn{" +
                        "display:inline-block;" +
                        "background:#1769e0;" +
                        "color:white;" +
                        "text-decoration:none;" +
                        "padding:13px 26px;" +
                        "border-radius:8px;" +
                        "font-size:14px;" +
                        "font-weight:bold;" +
                        "}"
                    );


                    pw.println(
                        ".btn:hover{" +
                        "background:#0d54bd;" +
                        "}"
                    );


                    /* FOOTER */

                    pw.println(
                        ".footer{" +
                        "margin-top:60px;" +
                        "background:#123c88;" +
                        "color:#dceaff;" +
                        "text-align:center;" +
                        "padding:20px;" +
                        "font-size:13px;" +
                        "}"
                    );


                    pw.println("</style>");

                    pw.println("</head>");


                    pw.println("<body>");


                    /* HEADER */

                    pw.println(
                        "<div class='header'>"
                    );


                    pw.println(
                        "<div class='logo'>" +
                        "Campus<span>Connect</span>" +
                        "</div>"
                    );


                    pw.println("</div>");


                    /* MAIN */

                    pw.println(
                        "<div class='container'>"
                    );


                    pw.println(
                        "<div class='card'>"
                    );


                    /* SUCCESS ICON */

                    pw.println(
                        "<div class='success-icon'>" +
                        "&#10003;" +
                        "</div>"
                    );


                    pw.println(
                        "<h1>" +
                        "Payment Successful" +
                        "</h1>"
                    );


                    pw.println(
                        "<p class='message'>" +
                        "Your admission fee has been successfully " +
                        "received. Your admission is now confirmed." +
                        "</p>"
                    );


                    /* DETAILS */

                    pw.println(
                        "<div class='details'>"
                    );


                    /* ADMISSION ID */

                    pw.println(
                        "<div class='row'>"
                    );


                    pw.println(
                        "<span class='label'>" +
                        "Admission ID" +
                        "</span>"
                    );


                    pw.println(
                        "<span class='value'>" +
                        admissionId +
                        "</span>"
                    );


                    pw.println("</div>");


                    /* AMOUNT */

                    pw.println(
                        "<div class='row'>"
                    );


                    pw.println(
                        "<span class='label'>" +
                        "Amount Paid" +
                        "</span>"
                    );


                    pw.println(
                        "<span class='value'>" +
                        "&#8377; " +
                        String.format(
                            "%.2f",
                            Double.parseDouble(amount)
                        ) +
                        "</span>"
                    );


                    pw.println("</div>");


                    /* PAYMENT METHOD */

                    pw.println(
                        "<div class='row'>"
                    );


                    pw.println(
                        "<span class='label'>" +
                        "Payment Method" +
                        "</span>"
                    );


                    pw.println(
                        "<span class='value'>" +
                        paymentMethod +
                        "</span>"
                    );


                    pw.println("</div>");


                    /* TRANSACTION ID */

                    pw.println(
                        "<div class='row'>"
                    );


                    pw.println(
                        "<span class='label'>" +
                        "Transaction ID" +
                        "</span>"
                    );


                    pw.println(
                        "<span class='value'>" +
                        transactionId +
                        "</span>"
                    );


                    pw.println("</div>");


                    /* PAYMENT STATUS */

                    pw.println(
                        "<div class='row'>"
                    );


                    pw.println(
                        "<span class='label'>" +
                        "Payment Status" +
                        "</span>"
                    );


                    pw.println(
                        "<span class='status'>" +
                        "SUCCESS" +
                        "</span>"
                    );


                    pw.println("</div>");


                    /* ADMISSION STATUS */

                    pw.println(
                        "<div class='row'>"
                    );


                    pw.println(
                        "<span class='label'>" +
                        "Admission Status" +
                        "</span>"
                    );


                    pw.println(
                        "<span class='status'>" +
                        "CONFIRMED" +
                        "</span>"
                    );


                    pw.println("</div>");


                    pw.println("</div>");


                    /* HOME BUTTON */

                    pw.println(
                        "<a href='index.jsp' " +
                        "class='btn'>" +
                        "Back to Home" +
                        "</a>"
                    );


                    pw.println("</div>");

                    pw.println("</div>");


                    /* FOOTER */

                    pw.println(
                        "<div class='footer'>" +
                        "CampusConnect | " +
                        "Campus Recruitment Management System" +
                        "</div>"
                    );


                    pw.println("</body>");

                    pw.println("</html>");
                }
                else
                {
                    con.rollback();

                    pw.println(
                        "<h2>Admission Confirmation Failed</h2>"
                    );
                }
            }
            else
            {
                con.rollback();

                pw.println(
                    "<h2>Payment Failed</h2>"
                );
            }
        }
        catch(Exception e)
        {
            try
            {
                if(con != null)
                    con.rollback();
            }
            catch(Exception ex)
            {
            }


            pw.println("<html>");
            pw.println("<body>");

            pw.println(
                "<h2>Payment Error</h2>"
            );

            pw.println(
                "<p>" +
                e.getMessage() +
                "</p>"
            );

            pw.println(
                "<br>"
            );

            pw.println(
                "<a href='index.jsp'>" +
                "Back to Home" +
                "</a>"
            );

            pw.println("</body>");
            pw.println("</html>");
        }
        finally
        {
            try
            {
                if(rs != null)
                    rs.close();

                if(ps != null)
                    ps.close();

                if(ps2 != null)
                    ps2.close();

                if(ps3 != null)
                    ps3.close();

                if(con != null)
                    con.close();
            }
            catch(Exception e)
            {
            }
        }
    }
}