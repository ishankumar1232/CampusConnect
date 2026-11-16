package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.ReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SystemReportsServlet extends HttpServlet {

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        // ================= SESSION CHECK =================

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            res.sendRedirect(req.getContextPath()
                    + "/superadmin/login.jsp");
            return;
        }

        ReportDAO dao = new ReportDAO();
        java.util.Map<String, Integer> counts = dao.getSystemReportCounts();

        // Total Colleges
        req.setAttribute("collegeCount", counts.getOrDefault("collegeCount", 0));

        // Approved Colleges
        req.setAttribute("approvedCollege", counts.getOrDefault("approvedCollege", 0));

        // Rejected Colleges
        req.setAttribute("rejectedCollege", counts.getOrDefault("rejectedCollege", 0));

        // Total Companies
        req.setAttribute("companyCount", counts.getOrDefault("companyCount", 0));

        // Approved Companies
        req.setAttribute("approvedCompany", counts.getOrDefault("approvedCompany", 0));

        // Rejected Companies
        req.setAttribute("rejectedCompany", counts.getOrDefault("rejectedCompany", 0));

        // Total Students
        req.setAttribute("studentCount", counts.getOrDefault("studentCount", 0));

        // Active Students
        req.setAttribute("activeStudent", counts.getOrDefault("activeStudent", 0));

        // Inactive Students
        req.setAttribute("inactiveStudent", counts.getOrDefault("inactiveStudent", 0));

        // Total Drives
        req.setAttribute("driveCount", counts.getOrDefault("driveCount", 0));

        // Active Drives
        req.setAttribute("activeDrive", counts.getOrDefault("activeDrive", 0));

        // Closed Drives
        req.setAttribute("closedDrive", counts.getOrDefault("closedDrive", 0));

        // Applications & Placed Students (from DashboardDAO)
        com.campusconnect.dao.DashboardDAO ddao = new com.campusconnect.dao.DashboardDAO();
        com.campusconnect.bean.DashboardBean dbean = ddao.getDashboardData();
        req.setAttribute("placedCount", dbean != null ? dbean.getPlacedStudents() : 0);
        req.setAttribute("applicationCount", dbean != null ? dbean.getTotalApplications() : 0);

        req.getRequestDispatcher("/superadmin/systemReports.jsp")
                .forward(req, res);

    }

}