package com.campusconnect.controller;

import com.campusconnect.bean.Application;
import com.campusconnect.dao.ApplicationDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ApplicationController")
public class ApplicationController extends HttpServlet {
    ApplicationDAO dao = new ApplicationDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("list".equals(action)) {
            listApplications(req, resp);
        } else if ("shortlist".equals(action)) {
            updateStatus(req, resp, "Shortlisted");
        } else if ("select".equals(action)) {
            updateStatus(req, resp, "Selected");
        } else if ("reject".equals(action)) {
            updateStatus(req, resp, "Rejected");
        }
    }

    private void listApplications(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int driveId = Integer.parseInt(req.getParameter("driveId"));
        List<Application> apps = dao.getApplicationsByDrive(driveId);
        req.setAttribute("appList", apps);
        req.setAttribute("driveId", driveId);
        req.getRequestDispatcher("/jsp/company/viewApplications.jsp").forward(req, resp);
    }

    private void updateStatus(HttpServletRequest req, HttpServletResponse resp, String newStatus) throws ServletException, IOException {
        int appId = Integer.parseInt(req.getParameter("appId"));
        dao.updateApplicationStatus(appId, newStatus);
        resp.sendRedirect("ApplicationController?action=list&driveId=" + req.getParameter("driveId"));
    }
}