package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AddCollegeAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/superadmin/login.jsp");
            return;
        }

        String collegeIdStr = req.getParameter("collegeId");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (collegeIdStr == null || name == null || email == null || password == null ||
            collegeIdStr.trim().isEmpty() || name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/UserManagementServlet?error=missing_fields");
            return;
        }

        try {
            int collegeId = Integer.parseInt(collegeIdStr.trim());
            UserDAO dao = new UserDAO();
            int adminId = dao.createCollegeAdmin(collegeId, name.trim(), email.trim(), password.trim());

            if (adminId > 0) {
                res.sendRedirect(req.getContextPath() + "/UserManagementServlet?success=admin_created");
            } else {
                res.sendRedirect(req.getContextPath() + "/UserManagementServlet?error=admin_create_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/UserManagementServlet?error=exception");
        }
    }
}
