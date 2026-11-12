
package com.campusconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.campusconnect.util.DBConnection;

public class ApplicationShortlistController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession(false);

        if (session == null) {
            res.sendRedirect(req.getContextPath() +
                    "/collegeAdminLogin.jsp");
            return;
        }

        Integer collegeId =
                (Integer) session.getAttribute("collegeId");

        if (collegeId == null) {
            res.sendRedirect(req.getContextPath() +
                    "/collegeAdminLogin.jsp");
            return;
        }

        String applicationId = req.getParameter("applicationId");
        String shortlistStatus = req.getParameter("shortlistStatus");

        if (applicationId == null || shortlistStatus == null) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Missing application details.");
            return;
        }

        String checkSql =
                "SELECT A.APPLICATION_ID " +
                "FROM APPLICATION A " +
                "JOIN STUDENT S ON A.STUDENT_ID = S.STUDENT_ID " +
                "WHERE A.APPLICATION_ID = ? AND S.COLLEGE_ID = ?";

        String updateSql =
                "UPDATE APPLICATION " +
                "SET COLLEGE_SHORTLIST_STATUS = ? " +
                "WHERE APPLICATION_ID = ?";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new ServletException(
                        "Unable to connect to database.");
            }

            boolean applicationFound;

            try (PreparedStatement ps =
                    con.prepareStatement(checkSql)) {

                ps.setInt(1, Integer.parseInt(applicationId));
                ps.setInt(2, collegeId);

                try (ResultSet rs = ps.executeQuery()) {
                    applicationFound = rs.next();
                }
            }

            if (!applicationFound) {
                res.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Application not found for this college.");
                return;
            }

            try (PreparedStatement ps =
                    con.prepareStatement(updateSql)) {

                ps.setString(1, shortlistStatus);
                ps.setInt(2, Integer.parseInt(applicationId));

                int updated = ps.executeUpdate();

                if (updated > 0) {
                    res.sendRedirect(req.getContextPath() +
                            "/applicationManagement.jsp");
                } else {
                    res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Unable to update application.");
                }
            }

        } catch (NumberFormatException e) {

            res.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid application ID.");

        } catch (Exception e) {

            e.printStackTrace();

            if (!res.isCommitted()) {
                res.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "An error occurred while updating application."
                );
            }
        }
    }
}
