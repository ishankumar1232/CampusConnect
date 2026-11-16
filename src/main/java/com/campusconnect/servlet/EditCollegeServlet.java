package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.bean.College;
import com.campusconnect.dao.CollegeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class EditCollegeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/superadmin/login.jsp");
            return;
        }

        String idStr = req.getParameter("collegeId");
        String collegeName = req.getParameter("collegeName");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String address = req.getParameter("address");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");

        if (idStr == null || idStr.trim().isEmpty() || collegeName == null || collegeName.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet?error=invalid_data");
            return;
        }

        try {
            int collegeId = Integer.parseInt(idStr.trim());
            College col = new College();
            col.setCollegeId(collegeId);
            col.setCollegeName(collegeName.trim());
            col.setCity(city != null ? city.trim() : "");
            col.setState(state != null ? state.trim() : "");
            col.setAddress(address != null ? address.trim() : "");
            col.setEmail(email != null ? email.trim() : "");
            col.setPhone(phone != null ? phone.trim() : "");
            col.setStatus(status != null && !status.trim().isEmpty() ? status.trim() : "Approved");

            CollegeDAO dao = new CollegeDAO();
            boolean success = dao.updateCollege(col);

            if (success) {
                res.sendRedirect(req.getContextPath() + "/CollegeDetailsServlet?id=" + collegeId + "&success=updated");
            } else {
                res.sendRedirect(req.getContextPath() + "/CollegeDetailsServlet?id=" + collegeId + "&error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet?error=exception");
        }
    }
}
