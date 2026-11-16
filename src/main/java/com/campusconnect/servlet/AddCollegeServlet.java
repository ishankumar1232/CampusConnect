package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.bean.College;
import com.campusconnect.dao.CollegeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AddCollegeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/superadmin/login.jsp");
            return;
        }

        String collegeName = req.getParameter("collegeName");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String address = req.getParameter("address");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");

        String adminName = req.getParameter("adminName");
        String adminEmail = req.getParameter("adminEmail");
        String adminPassword = req.getParameter("adminPassword");

        if (collegeName == null || collegeName.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet?error=missing_name");
            return;
        }

        College college = new College();
        college.setCollegeName(collegeName.trim());
        college.setCity(city != null ? city.trim() : "");
        college.setState(state != null ? state.trim() : "");
        college.setAddress(address != null ? address.trim() : "");
        college.setEmail(email != null ? email.trim() : "");
        college.setPhone(phone != null ? phone.trim() : "");
        college.setStatus(status != null && !status.trim().isEmpty() ? status.trim() : "Approved");

        CollegeDAO dao = new CollegeDAO();

        int result;
        if (adminEmail != null && !adminEmail.trim().isEmpty() && adminPassword != null && !adminPassword.trim().isEmpty()) {
            result = dao.registerCollege(college, adminName != null ? adminName.trim() : "College Administrator", adminEmail.trim(), adminPassword.trim());
        } else {
            result = dao.addCollege(college);
        }

        if (result > 0) {
            res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet?success=added");
        } else {
            res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet?error=failed");
        }
    }
}
