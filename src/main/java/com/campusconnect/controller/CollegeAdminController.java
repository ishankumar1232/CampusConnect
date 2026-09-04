package com.campusconnect.controller;

import com.campusconnect.bean.CollegeAdmin;
import com.campusconnect.dao.CollegeAdminDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CollegeAdminController")
public class CollegeAdminController extends HttpServlet {

    CollegeAdminDAO dao = new CollegeAdminDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("showRegister".equals(action)) {
            req.getRequestDispatcher("/jsp/admin/register.jsp").forward(req, resp);
        } else if ("showLogin".equals(action) || action == null) {
            req.getRequestDispatcher("/jsp/admin/adminLogin.jsp").forward(req, resp);
        } else if ("logout".equals(action)) {
            HttpSession session = req.getSession();
            session.invalidate();
            resp.sendRedirect("CollegeAdminController?action=showLogin");
        } else if ("dashboard".equals(action)) {
            req.getRequestDispatcher("/jsp/admin/adminDashboard.jsp").forward(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("register".equals(action)) {
            registerAdmin(req, resp);
        } else if ("login".equals(action)) {
            adminLogin(req, resp);
        }
    }

    private void registerAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        String collegeName = req.getParameter("collegeName");  // ✅ ADDED THIS

        CollegeAdmin admin = new CollegeAdmin(collegeId, name, email, password, collegeName);  // ✅ UPDATED
        boolean result = dao.addAdmin(admin);

        if (result) {
            req.setAttribute("message", "Registration Successful! Please Login.");
            req.getRequestDispatcher("/jsp/admin/adminLogin.jsp").forward(req, resp);
        } else {
            req.setAttribute("message", "Registration Failed! Email may already exist.");
            req.getRequestDispatcher("/jsp/admin/register.jsp").forward(req, resp);
        }
    }

    private void adminLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        CollegeAdmin admin = dao.adminLogin(email, password);

        if (admin != null) {
            HttpSession session = req.getSession();
            session.setAttribute("admin", admin);
            resp.sendRedirect("CollegeAdminController?action=dashboard");
        } else {
            req.setAttribute("message", "Invalid Email or Password!");
            req.getRequestDispatcher("/jsp/admin/adminLogin.jsp").forward(req, resp);
        }
    }
}