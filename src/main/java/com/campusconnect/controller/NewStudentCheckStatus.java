package com.campusconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class NewStudentCheckStatus extends HttpServlet
{
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException
    {
        String admissionId = req.getParameter("admissionId");
        String email = req.getParameter("email");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try
        {
            if(admissionId == null || admissionId.trim().equals("")
                    || email == null || email.trim().equals(""))
            {
                res.setContentType("text/html");

                res.getWriter().println(
                    "<h2>Please enter Admission ID and Email</h2>"
                );

                res.getWriter().println(
                    "<a href='new_student_check_status.jsp'>Go Back</a>"
                );

                return;
            }

            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            String sql =
                "SELECT ADMISSION_ID " +
                "FROM ADMISSION " +
                "WHERE ADMISSION_ID=? " +
                "AND LOWER(APPLICANT_EMAIL)=LOWER(?)";

            ps = con.prepareStatement(sql);

            ps.setInt(1, Integer.parseInt(admissionId));
            ps.setString(2, email.trim());

            rs = ps.executeQuery();

            if(rs.next())
            {
                String encodedEmail =
                    java.net.URLEncoder.encode(email.trim(), "UTF-8");

                res.sendRedirect(
                    "admission_status.jsp?admissionId="
                    + admissionId
                    + "&email="
                    + encodedEmail
                );
            }
            else
            {
                res.setContentType("text/html");

                res.getWriter().println(
                    "<html>"
                );

                res.getWriter().println(
                    "<head><title>Admission Not Found</title></head>"
                );

                res.getWriter().println(
                    "<body style='font-family:Arial;text-align:center;margin-top:100px;'>"
                );

                res.getWriter().println(
                    "<h2>Admission Request Not Found</h2>"
                );

                res.getWriter().println(
                    "<p>Please check your Admission ID and Email.</p>"
                );

                res.getWriter().println(
                    "<br>"
                );

                res.getWriter().println(
                    "<a href='new_student_check_status.jsp'>Try Again</a>"
                );

                res.getWriter().println(
                    "</body></html>"
                );
            }
        }
        catch(NumberFormatException e)
        {
            res.setContentType("text/html");

            res.getWriter().println(
                "<h2>Invalid Admission ID</h2>"
            );

            res.getWriter().println(
                "<a href='new_student_check_status.jsp'>Try Again</a>"
            );
        }
        catch(Exception e)
        {
            res.setContentType("text/html");

            res.getWriter().println("<h2>Error</h2>");
            res.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
        finally
        {
            try
            {
                if(rs != null)
                    rs.close();

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();
            }
            catch(Exception e)
            {
            }
        }
    }
}