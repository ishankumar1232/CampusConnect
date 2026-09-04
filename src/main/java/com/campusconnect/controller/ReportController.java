package com.campusconnect.controller;

import com.campusconnect.bean.CollegeAdmin;
import com.campusconnect.bean.Student;
import com.campusconnect.bean.Drive;
import com.campusconnect.bean.Application;
import com.campusconnect.dao.*;
import java.io.IOException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReportController")
public class ReportController extends HttpServlet {
    
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        
        if ("dashboard".equals(action) || action == null) {
            showReports(req, resp);
        } else if ("placementReport".equals(action)) {
            placementReport(req, resp);
        } else if ("driveReport".equals(action)) {
            driveReport(req, resp);
        }
    }
    
    private void showReports(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        // ✅ FIX: Check if admin is null FIRST
        if (admin == null) {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
            return;
        }
        
        // ✅ FIX: Check if collegeId is valid
        int collegeId = admin.getCollegeId();
        if (collegeId <= 0) {
            resp.sendRedirect("CollegeAdminController?action=dashboard");
            return;
        }
        
        try {
            // Initialize DAOs
            StudentDAO studentDao = new StudentDAO();
            DriveDAO driveDao = new DriveDAO();
            CompanyDAO companyDao = new CompanyDAO();
            ApplicationDAO appDao = new ApplicationDAO();
            
            // Get statistics
            Map<String, Object> stats = new HashMap<>();
            
            // Total Students in this college
            List<Student> allStudents = studentDao.getAllStudents();
            int totalStudents = 0;
            if (allStudents != null) {
                for (Student s : allStudents) {
                    if (s.getCollegeId() == collegeId) {
                        totalStudents++;
                    }
                }
            }
            stats.put("totalStudents", totalStudents);
            
            // Total Drives for this college
            List<Drive> allDrives = driveDao.getDrivesByCollege(collegeId);
            if (allDrives == null) {
                allDrives = new ArrayList<>();
            }
            stats.put("totalDrives", allDrives.size());
            
            // Count drives by status
            int upcomingDrives = 0, ongoingDrives = 0, completedDrives = 0;
            for (Drive d : allDrives) {
                if (d.getStatus() != null) {
                    if ("Upcoming".equals(d.getStatus())) upcomingDrives++;
                    else if ("Ongoing".equals(d.getStatus())) ongoingDrives++;
                    else if ("Completed".equals(d.getStatus())) completedDrives++;
                }
            }
            stats.put("upcomingDrives", upcomingDrives);
            stats.put("ongoingDrives", ongoingDrives);
            stats.put("completedDrives", completedDrives);
            
            // Total Companies
            List companies = companyDao.getAllCompanies();
            stats.put("totalCompanies", companies != null ? companies.size() : 0);
            
            // Total Applications & Placements
            int totalApplications = 0;
            int totalSelected = 0;
            int totalShortlisted = 0;
            
            for (Drive d : allDrives) {
                List<Application> apps = appDao.getApplicationsByDrive(d.getDriveId());
                if (apps != null) {
                    totalApplications += apps.size();
                    
                    for (Application app : apps) {
                        if (app.getStatus() != null) {
                            if ("Selected".equals(app.getStatus())) totalSelected++;
                            else if ("Shortlisted".equals(app.getStatus())) totalShortlisted++;
                        }
                    }
                }
            }
            
            stats.put("totalApplications", totalApplications);
            stats.put("totalSelected", totalSelected);
            stats.put("totalShortlisted", totalShortlisted);
            
            // Calculate placement percentage
            double placementPercentage = 0;
            if (totalStudents > 0) {
                placementPercentage = (totalSelected * 100.0) / totalStudents;
            }
            stats.put("placementPercentage", String.format("%.2f", placementPercentage));
            
            // ✅ FIX: Set attributes BEFORE forwarding
            req.setAttribute("stats", stats);
            req.setAttribute("driveList", allDrives);
            
            // Forward to JSP
            req.getRequestDispatcher("/jsp/admin/reports.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            // ✅ FIX: Handle errors gracefully
            req.setAttribute("errorMessage", "Error loading reports: " + e.getMessage());
            req.getRequestDispatcher("/jsp/admin/reports.jsp").forward(req, resp);
        }
    }
    
    private void placementReport(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        if (admin == null || admin.getCollegeId() <= 0) {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
            return;
        }
        
        try {
            ApplicationDAO appDao = new ApplicationDAO();
            DriveDAO driveDao = new DriveDAO();
            List<Drive> drives = driveDao.getDrivesByCollege(admin.getCollegeId());
            
            List<Application> selectedStudents = new ArrayList<>();
            if (drives != null) {
                for (Drive d : drives) {
                    List<Application> apps = appDao.getApplicationsByDrive(d.getDriveId());
                    if (apps != null) {
                        for (Application app : apps) {
                            if ("Selected".equals(app.getStatus())) {
                                selectedStudents.add(app);
                            }
                        }
                    }
                }
            }
            
            req.setAttribute("selectedList", selectedStudents);
            req.getRequestDispatcher("/jsp/admin/placementReport.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("ReportController?action=dashboard");
        }
    }
    
    private void driveReport(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        if (admin == null || admin.getCollegeId() <= 0) {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
            return;
        }
        
        try {
            DriveDAO driveDao = new DriveDAO();
            List<Drive> drives = driveDao.getDrivesByCollege(admin.getCollegeId());
            
            req.setAttribute("driveList", drives != null ? drives : new ArrayList<>());
            req.getRequestDispatcher("/jsp/admin/driveReport.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("ReportController?action=dashboard");
        }
    }
}