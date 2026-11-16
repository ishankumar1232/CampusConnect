package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.bean.College;
import com.campusconnect.bean.SystemSetting;
import com.campusconnect.dao.CollegeDAO;
import com.campusconnect.dao.SystemSettingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterCollegeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/college-registration.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ================= SYSTEM SETTINGS CHECK =================
        SystemSettingDAO settingDAO = new SystemSettingDAO();
        SystemSetting setting = settingDAO.getSystemSettings();
        if (setting != null && "OFF".equalsIgnoreCase(setting.getCollegeRegistration())) {
            res.sendRedirect(req.getContextPath() + "/college-registration.jsp?error=disabled");
            return;
        }

        String collegeName = req.getParameter("collegeName");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String collegeEmail = req.getParameter("collegeEmail");
        String phone = req.getParameter("phone");

        String adminName = req.getParameter("adminName");
        String adminEmail = req.getParameter("adminEmail");
        String password = req.getParameter("password");

        if (collegeName == null || collegeName.trim().isEmpty() ||
            adminEmail == null || adminEmail.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/college-registration.jsp?error=missing_fields");
            return;
        }

        College college = new College();
        college.setCollegeName(collegeName.trim());
        college.setAddress(address != null ? address.trim() : "");
        college.setCity(city != null ? city.trim() : "");
        college.setState(state != null ? state.trim() : "");
        college.setEmail(collegeEmail != null ? collegeEmail.trim() : adminEmail.trim());
        college.setPhone(phone != null ? phone.trim() : "");
        college.setStatus("Pending");

        CollegeDAO dao = new CollegeDAO();
        int newCollegeId = dao.registerCollege(college, adminName != null ? adminName.trim() : "College Administrator", adminEmail.trim(), password);

        if (newCollegeId > 0) {
            res.sendRedirect(req.getContextPath() + "/collegeAdminLogin.jsp?success=pending_approval");
        } else {
            res.sendRedirect(req.getContextPath() + "/college-registration.jsp?error=failed");
        }
    }
}
