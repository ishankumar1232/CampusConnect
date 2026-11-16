package com.campusconnect.controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.CollegeAdmin;

import com.campusconnect.dao.SystemSettingDAO;
import com.campusconnect.bean.SystemSetting;

public class CollegeAdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/collegeAdminRegister.jsp");
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String college = req.getParameter("collegeId");

        try {

            // CHECK COLLEGE REGISTRATION STATUS

            SystemSettingDAO settingDAO = new SystemSettingDAO();

            SystemSetting setting = settingDAO.getSystemSettings();

            if (setting != null &&
                "OFF".equalsIgnoreCase(setting.getCollegeRegistration())) {

                res.sendRedirect(req.getContextPath() + "/collegeAdminRegister.jsp?error=disabled");
                return;
            }

            if (college == null || college.trim().isEmpty()) {
                res.sendRedirect(req.getContextPath() + "/collegeAdminRegister.jsp?error=failed");
                return;
            }

            CollegeAdmin admin = new CollegeAdmin();

            admin.setName(name);
            admin.setEmail(email);
            admin.setPassword(password);
            admin.setCollegeId(Integer.parseInt(college.trim()));

            boolean x = admin.InsertMethod();

            if(x) {
                res.sendRedirect(req.getContextPath() + "/collegeAdminLogin.jsp?success=registered");
            }
            else {
                res.sendRedirect(req.getContextPath() + "/collegeAdminRegister.jsp?error=failed");
            }

        }
        catch(Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/collegeAdminRegister.jsp?error=exception");
        }
    }
}