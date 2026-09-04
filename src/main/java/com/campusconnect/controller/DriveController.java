package com.campusconnect.controller;

import com.campusconnect.bean.CollegeAdmin;
import com.campusconnect.bean.Drive;
import com.campusconnect.dao.CompanyDAO;
import com.campusconnect.dao.DriveDAO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DriveController")
public class DriveController extends HttpServlet {
    DriveDAO dao = new DriveDAO();
    CompanyDAO compDao = new CompanyDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("list".equals(action) || action == null) {
            listDrives(req, resp);
        } else if ("showCreate".equals(action)) {
            HttpSession session = req.getSession();
            CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
            if (admin != null && admin.getCollegeId() > 0) {
                req.setAttribute("companyList", compDao.getAllCompanies());
                req.getRequestDispatcher("/jsp/college/company/createDrive.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("CollegeAdminController?action=showLogin");
            }
        } else if ("viewApplicants".equals(action)) {
            int driveId = Integer.parseInt(req.getParameter("driveId"));
            resp.sendRedirect("ApplicationController?action=list&driveId=" + driveId);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("create".equals(action)) {
            createDrive(req, resp);
        }
    }

    private void listDrives(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        if (admin != null && admin.getCollegeId() > 0) {
            List<Drive> drives = dao.getDrivesByCollege(admin.getCollegeId());
            req.setAttribute("driveList", drives);
            req.getRequestDispatcher("/jsp/college/company/driveList.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
        }
    }

    private void createDrive(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        if (admin == null || admin.getCollegeId() <= 0) {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
            return;
        }

        try {
            int companyId = Integer.parseInt(req.getParameter("companyId"));
            String title = req.getParameter("driveTitle");
            String pos = req.getParameter("position");
            int hires = Integer.parseInt(req.getParameter("noOfHires"));
            String criteria = req.getParameter("eligibilityCriteria");
            double pkg = Double.parseDouble(req.getParameter("packageCtc"));
            String regDeadStr = req.getParameter("registrationDeadline");
            String driveDateStr = req.getParameter("driveDate");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date deadline = sdf.parse(regDeadStr);
            Date date = sdf.parse(driveDateStr);

            Drive drive = new Drive(companyId, admin.getCollegeId(), title, pos, hires, criteria, pkg, deadline, date, "Upcoming", admin.getAdminId());
            
            if(dao.createDrive(drive)) {
                resp.sendRedirect("DriveController?action=list");
            } else {
                req.setAttribute("message", "Failed to create drive!");
                req.getRequestDispatcher("/jsp/college/company/createDrive.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "Error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/college/company/createDrive.jsp").forward(req, resp);
        }
    }
}