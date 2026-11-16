package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ActivateUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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
                    + "/UserManagementServlet");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            String role = request.getParameter("role");

            UserDAO dao = new UserDAO();
            if (role != null && !role.trim().isEmpty()) {
                dao.activateUser(id, role.trim());
            } else {
                dao.activateUser(id);
            }

        } catch (NumberFormatException e) {
            // Invalid ID format, ignore
        }

        response.sendRedirect(request.getContextPath()
                + "/UserManagementServlet");

    }

}