package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.CollegeDAO;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ApproveCollegeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        // ================= SESSION CHECK =================

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            response.sendRedirect(request.getContextPath()
                    + "/superadmin/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath()
                    + "/CollegeManagementServlet");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            CollegeDAO dao = new CollegeDAO();

            dao.approveCollege(id);

        } catch (NumberFormatException e) {
            // Invalid ID format, ignore and redirect
        }

        response.sendRedirect(request.getContextPath()
                + "/CollegeManagementServlet");

    }

}