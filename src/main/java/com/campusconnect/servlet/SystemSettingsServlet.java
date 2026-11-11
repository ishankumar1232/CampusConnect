package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.dao.SystemSettingDAO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SystemSettingsServlet extends HttpServlet {

    // ==========================
    // LOAD SETTINGS PAGE
    // ==========================

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        // ==========================
        // SESSION CHECK
        // ==========================

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            res.sendRedirect(req.getContextPath()
                    + "/superadmin/login.jsp");

            return;

        }

        // ==========================
        // LOAD SETTINGS
        // ==========================

        SystemSettingDAO dao = new SystemSettingDAO();

        SystemSetting setting =
                dao.getSystemSettings();

        req.setAttribute("setting", setting);

        RequestDispatcher rd =
                req.getRequestDispatcher("/superadmin/systemSettings.jsp");

        rd.forward(req, res);

    }

    // ==========================
    // SAVE SETTINGS
    // ==========================

    public void doPost(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        SystemSetting setting =
                new SystemSetting();

        setting.setSettingId(1);

        setting.setStudentRegistration(
                req.getParameter("studentRegistration"));

        setting.setCollegeRegistration(
                req.getParameter("collegeRegistration"));

        setting.setCompanyRegistration(
                req.getParameter("companyRegistration"));

        setting.setAdmissionRequest(
                req.getParameter("admissionRequest"));

        setting.setRecruitmentDrive(
                req.getParameter("recruitmentDrive"));

        setting.setMaintenanceMode(
                req.getParameter("maintenanceMode"));

        SystemSettingDAO dao =
                new SystemSettingDAO();

        dao.updateSystemSettings(setting);

        res.sendRedirect(req.getContextPath()
                + "/SystemSettingsServlet");

    }

}