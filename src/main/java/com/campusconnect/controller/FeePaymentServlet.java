package com.campusconnect.controller;

import java.io.*;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.campusconnect.util.DBConnection;

public class FeePaymentServlet extends HttpServlet
{
    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        String admissionId = req.getParameter("admissionId");
        if(admissionId != null && !admissionId.trim().isEmpty()) {
            res.sendRedirect("fee_payment.jsp?admissionId=" + admissionId.trim());
        } else {
            res.sendRedirect("new_student_colleges.jsp");
        }
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter out = res.getWriter();

        String admissionId = req.getParameter("admissionId");
        String paymentMethod = req.getParameter("paymentMethod");
        String transactionId = req.getParameter("transactionId");

        Connection con = null;

        try
        {
            // Check Admission ID
            if(admissionId == null || admissionId.trim().equals(""))
            {
                out.println("<h2>Invalid Admission ID</h2>");
                return;
            }

            // Validate Payment Amount
            double amount = 50000.00;
            String amtParam = req.getParameter("amount");
            if(amtParam != null && !amtParam.trim().isEmpty()) {
                try {
                    double parsed = Double.parseDouble(amtParam.trim());
                    if(parsed <= 0) {
                        out.println("<h2>Invalid Payment Amount</h2>");
                        return;
                    }
                    amount = parsed;
                } catch(NumberFormatException e) {
                    out.println("<h2>Invalid Payment Amount</h2>");
                    return;
                }
            }

            // Database Connection
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Check Admission Status & Decided Fee
            String checkSql =
                "SELECT A.STATUS, NVL(A.ADMISSION_FEE, NVL(C.DEFAULT_ADMISSION_FEE, 50000)) AS DECIDED_FEE " +
                "FROM ADMISSION A " +
                "JOIN COLLEGE C ON A.COLLEGE_ID = C.COLLEGE_ID " +
                "WHERE A.ADMISSION_ID=?";

            PreparedStatement checkPs =
                con.prepareStatement(checkSql);

            checkPs.setInt(
                1,
                Integer.parseInt(admissionId)
            );

            ResultSet rs =
                checkPs.executeQuery();

            // Admission Not Found
            if(!rs.next())
            {
                rs.close();
                checkPs.close();

                con.rollback();

                out.println("<html>");
                out.println("<body>");

                out.println("<h2>Admission Not Found</h2>");

                out.println(
                    "<a href='new_student_colleges.jsp'>Back</a>"
                );

                out.println("</body>");
                out.println("</html>");

                return;
            }

            String admissionStatus =
                rs.getString("STATUS");
            double decidedFee = rs.getDouble("DECIDED_FEE");
            if(decidedFee > 0) {
                amount = decidedFee;
            }

            rs.close();
            checkPs.close();

            // Payment only for APPROVED admission
            if(!"APPROVED".equalsIgnoreCase(admissionStatus))
            {
                con.rollback();

                out.println("<html>");
                out.println("<body>");

                out.println("<h2>Payment Not Allowed</h2>");

                out.println(
                    "<p>Your admission status is: "
                    + admissionStatus
                    + "</p>"
                );

                out.println(
                    "<br><a href='admission_status.jsp?admissionId="
                    + admissionId
                    + "'>Back to Admission Status</a>"
                );

                out.println("</body>");
                out.println("</html>");

                return;
            }

            // Generate Transaction ID
            if(transactionId == null ||
               transactionId.trim().equals(""))
            {
                transactionId =
                    "TXN" + System.currentTimeMillis();
            }

            // Insert Payment
            String paymentSql =
                "INSERT INTO FEE_PAYMENT " +
                "(PAYMENT_ID, ADMISSION_ID, AMOUNT, " +
                "PAYMENT_DATE, PAYMENT_METHOD, " +
                "TRANSACTION_ID, PAYMENT_STATUS) " +
                "VALUES " +
                "(FEE_PAYMENT_SEQ.NEXTVAL, ?, ?, " +
                "SYSDATE, ?, ?, 'SUCCESS')";

            PreparedStatement paymentPs =
                con.prepareStatement(paymentSql);

            paymentPs.setInt(
                1,
                Integer.parseInt(admissionId)
            );

            paymentPs.setDouble(
                2,
                amount
            );

            paymentPs.setString(
                3,
                paymentMethod
            );

            paymentPs.setString(
                4,
                transactionId
            );

            paymentPs.executeUpdate();

            paymentPs.close();

            // Update Admission Status
            String updateSql =
                "UPDATE ADMISSION " +
                "SET STATUS='CONFIRMED' " +
                "WHERE ADMISSION_ID=?";

            PreparedStatement updatePs =
                con.prepareStatement(updateSql);

            updatePs.setInt(
                1,
                Integer.parseInt(admissionId)
            );

            updatePs.executeUpdate();

            updatePs.close();

            // Commit
            con.commit();

            /*
             * IMPORTANT
             *
             * Student account is NOT created here.
             *
             * Payment is successful.
             * Admission becomes CONFIRMED.
             *
             * Now open existing Student Registration page.
             */

            res.sendRedirect(
                "student_register.jsp?admissionId="
                + admissionId
            );

        }
        catch(Exception e)
        {
            // Rollback if any error occurs
            try
            {
                if(con != null)
                {
                    con.rollback();
                }
            }
            catch(Exception ex)
            {
            }

            out.println("<html>");

            out.println("<head>");

            out.println(
                "<title>Payment Error</title>"
            );

            out.println("</head>");

            out.println("<body>");

            out.println("<h2>Payment Error</h2>");

            out.println(
                "<p>" + e.getMessage() + "</p>"
            );

            out.println("<br>");

            out.println(
                "<a href='fee_payment.jsp?admissionId="
                + admissionId
                + "'>Try Again</a>"
            );

            out.println("</body>");

            out.println("</html>");
        }
        finally
        {
            try
            {
                if(con != null)
                {
                    con.close();
                }
            }
            catch(Exception e)
            {
            }
        }
    }
}