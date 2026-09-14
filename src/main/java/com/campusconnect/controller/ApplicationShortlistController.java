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

public class ApplicationShortlistController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        Integer collegeId = (Integer) session.getAttribute("collegeId");

        if(collegeId == null) {
            res.sendRedirect("collegeAdminLogin.jsp");
            return;
        }

        String applicationId = req.getParameter("applicationId");
        String shortlistStatus = req.getParameter("shortlistStatus");

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

            // Check that application belongs to this college
            String checkSql =
                "SELECT A.APPLICATION_ID " +
                "FROM APPLICATION A " +
                "JOIN STUDENT S " +
                "ON A.STUDENT_ID = S.STUDENT_ID " +
                "WHERE A.APPLICATION_ID = ? " +
                "AND S.COLLEGE_ID = ?";

            ps = con.prepareStatement(checkSql);

            ps.setInt(1, Integer.parseInt(applicationId));
            ps.setInt(2, collegeId);

            rs = ps.executeQuery();

            if(rs.next()) {

                rs.close();
                ps.close();

                // Update shortlist status
                String updateSql =
                    "UPDATE APPLICATION " +
                    "SET COLLEGE_SHORTLIST_STATUS = ? " +
                    "WHERE APPLICATION_ID = ?";

                ps = con.prepareStatement(updateSql);

                ps.setString(1, shortlistStatus);
                ps.setInt(2, Integer.parseInt(applicationId));

                ps.executeUpdate();

                ps.close();

                res.sendRedirect(
                    req.getContextPath() +
                    "/applicationManagement.jsp"
                );

            } else {

                res.getWriter().println(
                    "<h2>Application not found</h2>"
                );
            }

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " + e.getMessage() + "</h2>"
            );

        } finally {

            if(rs != null) {
                try {
                    rs.close();
                } catch(Exception e) {}
            }

            if(ps != null) {
                try {
                    ps.close();
                } catch(Exception e) {}
            }

            if(con != null) {
                try {
                    con.close();
                } catch(Exception e) {}
            }
        }
    }
}