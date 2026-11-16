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

     // CHECK MAINTENANCE MODE

     SystemSettingDAO settingDAO = new SystemSettingDAO();

     SystemSetting setting = settingDAO.getSystemSettings();

     if (setting != null &&
         "ON".equalsIgnoreCase(setting.getMaintenanceMode())) {

         res.sendRedirect(req.getContextPath() + "/collegeAdminLogin.jsp?error=maintenance");
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

                res.sendRedirect(req.getContextPath() + "/collegeAdminLogin.jsp?error=invalid");
            }

        } catch(Exception e) {

            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/collegeAdminLogin.jsp?error=exception");
        }
    }
}