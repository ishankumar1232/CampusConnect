package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.ReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SystemReportsServlet extends HttpServlet
{

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException
    {

        ReportDAO dao = new ReportDAO();

        // Total Colleges
        req.setAttribute("collegeCount",
                dao.getCount("SELECT COUNT(*) FROM COLLEGE"));

        // Approved Colleges
        req.setAttribute("approvedCollege",
                dao.getCount("SELECT COUNT(*) FROM COLLEGE WHERE STATUS='APPROVED'"));

        // Rejected Colleges
        req.setAttribute("rejectedCollege",
                dao.getCount("SELECT COUNT(*) FROM COLLEGE WHERE STATUS='REJECTED'"));

        // Total Companies
        req.setAttribute("companyCount",
                dao.getCount("SELECT COUNT(*) FROM COMPANY"));

        // Approved Companies
        req.setAttribute("approvedCompany",
                dao.getCount("SELECT COUNT(*) FROM COMPANY WHERE STATUS='Approved'"));

        // Rejected Companies
        req.setAttribute("rejectedCompany",
                dao.getCount("SELECT COUNT(*) FROM COMPANY WHERE STATUS='Rejected'"));

        // Total Students
        req.setAttribute("studentCount",
                dao.getCount("SELECT COUNT(*) FROM STUDENT"));

        // Active Students
        req.setAttribute("activeStudent",
                dao.getCount("SELECT COUNT(*) FROM STUDENT WHERE STATUS='ACTIVE'"));

        // Inactive Students
        req.setAttribute("inactiveStudent",
                dao.getCount("SELECT COUNT(*) FROM STUDENT WHERE STATUS='INACTIVE'"));

        // Total Drives
        req.setAttribute("driveCount",
                dao.getCount("SELECT COUNT(*) FROM RECRUITMENT_DRIVE"));

        // Active Drives
        req.setAttribute("activeDrive",
                dao.getCount("SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='ACTIVE'"));

        // Closed Drives
        req.setAttribute("closedDrive",
                dao.getCount("SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='CLOSED'"));

        req.getRequestDispatcher("superadmin/systemReports.jsp")
                .forward(req, res);

    }

}