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
import jakarta.servlet.http.HttpSession;

public class InterviewController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        Integer collegeId = (Integer) session.getAttribute("collegeId");

        if(collegeId == null) {
            res.sendRedirect("collegeAdminLogin.jsp");
            return;
        }

        String applicationId = req.getParameter("applicationId");
        String interviewDate = req.getParameter("interviewDate");
        String interviewMode = req.getParameter("interviewMode");
        String venueOrLink = req.getParameter("venueOrLink");
        String status = req.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            // Check application belongs to this college
            String checkSql =
                "SELECT A.APPLICATION_ID " +
                "FROM APPLICATION A " +
                "JOIN STUDENT S " +
                "ON A.STUDENT_ID = S.STUDENT_ID " +
                "WHERE A.APPLICATION_ID = ? " +
                "AND S.COLLEGE_ID = ? " +
                "AND A.COLLEGE_SHORTLIST_STATUS = 'SHORTLISTED'";

            ps = con.prepareStatement(checkSql);

            ps.setInt(1, Integer.parseInt(applicationId));
            ps.setInt(2, collegeId);

            rs = ps.executeQuery();

            if(!rs.next()) {

                res.getWriter().println(
                    "<h2>Invalid application</h2>"
                );

                return;
            }

            rs.close();
            ps.close();


            // Check whether interview already exists
            String checkInterview =
                "SELECT INTERVIEW_ID " +
                "FROM INTERVIEW " +
                "WHERE APPLICATION_ID = ?";

            ps = con.prepareStatement(checkInterview);

            ps.setInt(1, Integer.parseInt(applicationId));

            rs = ps.executeQuery();

            if(rs.next()) {

                int interviewId = rs.getInt("INTERVIEW_ID");

                rs.close();
                ps.close();

                // Update existing interview
                String updateSql =
                    "UPDATE INTERVIEW " +
                    "SET INTERVIEW_DATE = TO_DATE(?, 'YYYY-MM-DD'), " +
                    "INTERVIEW_MODE = ?, " +
                    "VENUE_OR_LINK = ?, " +
                    "STATUS = ? " +
                    "WHERE INTERVIEW_ID = ?";

                ps = con.prepareStatement(updateSql);

                ps.setString(1, interviewDate);
                ps.setString(2, interviewMode);
                ps.setString(3, venueOrLink);
                ps.setString(4, status);
                ps.setInt(5, interviewId);

                ps.executeUpdate();

            } else {

                rs.close();
                ps.close();

                // Generate new Interview ID
                String idSql =
                    "SELECT NVL(MAX(INTERVIEW_ID),0)+1 " +
                    "FROM INTERVIEW";

                ps = con.prepareStatement(idSql);

                rs = ps.executeQuery();

                int interviewId = 1;

                if(rs.next()) {
                    interviewId = rs.getInt(1);
                }

                rs.close();
                ps.close();


                // Insert interview
                String insertSql =
                    "INSERT INTO INTERVIEW " +
                    "(INTERVIEW_ID, APPLICATION_ID, " +
                    "INTERVIEW_DATE, INTERVIEW_MODE, " +
                    "VENUE_OR_LINK, STATUS) " +
                    "VALUES (?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)";

                ps = con.prepareStatement(insertSql);

                ps.setInt(1, interviewId);
                ps.setInt(2, Integer.parseInt(applicationId));
                ps.setString(3, interviewDate);
                ps.setString(4, interviewMode);
                ps.setString(5, venueOrLink);
                ps.setString(6, status);

                ps.executeUpdate();

            }

            ps.close();

            res.sendRedirect(
                req.getContextPath() +
                "/interviewManagement.jsp"
            );

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " + e.getMessage() + "</h2>"
            );

        } finally {

            if(rs != null) {
                try { rs.close(); } catch(Exception e) {}
            }

            if(ps != null) {
                try { ps.close(); } catch(Exception e) {}
            }

            if(con != null) {
                try { con.close(); } catch(Exception e) {}
            }

        }
    }
}