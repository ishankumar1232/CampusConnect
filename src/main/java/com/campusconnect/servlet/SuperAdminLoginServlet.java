 package com.campusconnect.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import com.campusconnect.bean.SuperAdmin;
import com.campusconnect.dao.SuperAdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SuperAdminLoginServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        SuperAdminDAO dao = new SuperAdminDAO();
        SuperAdmin admin = dao.login(email, password);

        if (admin != null) {

            HttpSession session = req.getSession();
            session.setAttribute("admin", admin);

            res.sendRedirect(req.getContextPath() + "/DashboardServlet");
        } else {
            out.println("<h2>Invalid Email or Password</h2>");
        }
    }
}