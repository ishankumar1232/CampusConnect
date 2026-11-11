package com.campusconnect.servlet;

import java.io.IOException;
import java.net.URLEncoder;

import com.campusconnect.bean.SuperAdmin;
import com.campusconnect.dao.SuperAdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SuperAdminLoginServlet extends HttpServlet {

    public void doPost(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        SuperAdminDAO dao = new SuperAdminDAO();
        SuperAdmin admin = dao.login(email, password);

        if (admin != null) {

            // ================= LOGIN SUCCESS =================

            HttpSession session = req.getSession();
            session.setAttribute("admin", admin);

            res.sendRedirect(
                    req.getContextPath() + "/DashboardServlet");

        } else {

            // ================= LOGIN FAILED =================

            res.sendRedirect(
                    req.getContextPath()
                    + "/superadmin/login.jsp?error=invalid&email="
                    + URLEncoder.encode(email, "UTF-8"));

        }

    }

}