package com.campusconnect.controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.CollegeAdmin;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.dao.SystemSettingDAO;

public class CollegeAdminLogin extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter pw = res.getWriter();

     // ======================================
     // CHECK MAINTENANCE MODE
     // ======================================

     SystemSettingDAO settingDAO = new SystemSettingDAO();

     SystemSetting setting = settingDAO.getSystemSettings();

     if (setting != null &&
         "ON".equalsIgnoreCase(setting.getMaintenanceMode())) {

         pw.println("<html>");
         pw.println("<body>");

         pw.println("<h2>System Under Maintenance</h2>");

         pw.println("<p>");
         pw.println("College Admin Login is temporarily unavailable.");
         pw.println("</p>");

         pw.println("</body>");
         pw.println("</html>");

         return;
     }
        
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {

            CollegeAdmin admin = new CollegeAdmin();

            admin.setEmail(email);
            admin.setPassword(password);

            boolean x = admin.LoginMethod();

            if(x) {

                HttpSession session = req.getSession();

                session.setAttribute("adminId", admin.getAdminId());
                session.setAttribute("collegeId", admin.getCollegeId());
                session.setAttribute("adminName", admin.getName());

                res.sendRedirect(
                    req.getContextPath() + "/collegeAdminDashboard.jsp"
                );

            } else {

                pw.println("<html>");
                pw.println("<body>");

                pw.println("<h2>Invalid Email or Password</h2>");

                pw.println("<a href='" +
                    req.getContextPath() +
                    "/collegeAdminLogin.jsp'>Try Again</a>");

                pw.println("</body>");
                pw.println("</html>");
            }

        } catch(Exception e) {

            pw.println("<html>");
            pw.println("<body>");

            pw.println("<h2>Login Error</h2>");
            pw.println("<p>" + e + "</p>");

            pw.println("</body>");
            pw.println("</html>");
        }
    }
}