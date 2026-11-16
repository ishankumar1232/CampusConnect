package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ActivateStudentServlet extends HttpServlet {

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        // Session Check
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            res.sendRedirect(req.getContextPath()
                    + "/superadmin/login.jsp");
            return;
        }

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {

            res.sendRedirect(req.getContextPath()
                    + "/StudentManagementServlet");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            StudentDAO dao = new StudentDAO();

            dao.activateStudent(id);

        } catch (NumberFormatException e) {
            // Invalid ID format, ignore
        }

        res.sendRedirect(req.getContextPath()
                + "/StudentManagementServlet");
    }
}