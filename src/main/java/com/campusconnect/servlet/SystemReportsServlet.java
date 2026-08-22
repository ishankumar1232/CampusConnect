package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.ReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class SystemReportsServlet
extends HttpServlet
{

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException,ServletException
    {

        ReportDAO dao=new ReportDAO();

        req.setAttribute("collegeCount",
        dao.getCount("SELECT COUNT(*) FROM COLLEGE"));

        req.setAttribute("companyCount",
        dao.getCount("SELECT COUNT(*) FROM COMPANY"));

        req.setAttribute("approvedCompany",
        dao.getCount(
        "SELECT COUNT(*) FROM COMPANY WHERE STATUS='Approved'"));

        req.setAttribute("rejectedCompany",
        dao.getCount(
        "SELECT COUNT(*) FROM COMPANY WHERE STATUS='Rejected'"));

        req.setAttribute("studentCount",
        dao.getCount("SELECT COUNT(*) FROM STUDENT"));

        req.setAttribute("activeStudent",
        dao.getCount(
        "SELECT COUNT(*) FROM STUDENT WHERE STATUS='ACTIVE'"));

        req.setAttribute("inactiveStudent",
        dao.getCount(
        "SELECT COUNT(*) FROM STUDENT WHERE STATUS='INACTIVE'"));

        req.setAttribute("driveCount",
        dao.getCount(
        "SELECT COUNT(*) FROM RECRUITMENT_DRIVE"));

        req.setAttribute("activeDrive",
        dao.getCount(
        "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='ACTIVE'"));

        req.setAttribute("closedDrive",
        dao.getCount(
        "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='CLOSED'"));

        req.getRequestDispatcher(
        "superadmin/systemReports.jsp")
        .forward(req,res);

    }

}