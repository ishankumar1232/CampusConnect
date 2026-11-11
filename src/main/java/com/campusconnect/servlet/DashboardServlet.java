package com.campusconnect.servlet;

import java.io.IOException;
import java.util.ArrayList;

import com.campusconnect.bean.DashboardBean;
import com.campusconnect.bean.SystemActivityLog;
import com.campusconnect.dao.DashboardDAO;
import com.campusconnect.dao.SystemActivityLogDAO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        // ===========================================
        // SESSION CHECK
        // ===========================================

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            res.sendRedirect(req.getContextPath()
                    + "/superadmin/login.jsp");
            return;
        }

        // ===========================================
        // LOAD DASHBOARD DATA
        // ===========================================

        DashboardDAO dashboardDAO = new DashboardDAO();

        DashboardBean dashboard =
                dashboardDAO.getDashboardData();

        req.setAttribute("dashboard", dashboard);

        // ===========================================
        // LOAD ACTIVITY LOG
        // ===========================================

        SystemActivityLogDAO logDAO =
                new SystemActivityLogDAO();

        ArrayList<SystemActivityLog> activityList =
                logDAO.getAllLogs();

        req.setAttribute("activityList", activityList);

        // ===========================================
        // OPEN DASHBOARD
        // ===========================================

        RequestDispatcher rd =
                req.getRequestDispatcher("/superadmin/dashboard.jsp");

        rd.forward(req, res);
    }
    
    
}