package com.campusconnect.servlet;

import java.io.IOException;
import java.util.ArrayList;

import com.campusconnect.bean.RecruitmentDrive;
import com.campusconnect.dao.RecruitmentDriveDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MonitorRecruitmentServlet extends HttpServlet {

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

        // ================= GET ALL RECRUITMENT DRIVES =================

        RecruitmentDriveDAO dao = new RecruitmentDriveDAO();

        ArrayList<RecruitmentDrive> list = dao.getAllDrives();

        // ================= TOTAL COUNTS =================

        int totalApplications = 0;
        int totalSelected = 0;
        int totalPlaced = 0;

        for (RecruitmentDrive drive : list) {

            totalApplications += drive.getApplications();

            totalSelected += drive.getSelectedStudents();

            totalPlaced += drive.getPlacedStudents();

        }

        // ================= SEND DATA TO JSP =================

        req.setAttribute("driveList", list);

        req.setAttribute("totalDrives", list.size());

        req.setAttribute("totalApplications", totalApplications);

        req.setAttribute("totalSelected", totalSelected);

        req.setAttribute("totalPlaced", totalPlaced);

        // ================= FORWARD TO JSP =================

        req.getRequestDispatcher("/superadmin/monitorRecruitment.jsp")
                .forward(req, res);

    }
}