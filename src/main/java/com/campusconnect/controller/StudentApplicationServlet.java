package com.campusconnect.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.campusconnect.bean.StudentApplication;

public class StudentApplicationServlet extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException
    {
        res.sendRedirect("student_application_view.jsp");
    }

    @Override
    public void doPost(HttpServletRequest req,
                       HttpServletResponse res)
            throws IOException, ServletException
    {
        HttpSession session = req.getSession(false);

        if(session == null || session.getAttribute("studentId") == null)
        {
            res.sendRedirect("student_login.jsp");
            return;
        }

        try
        {
            int studentId = (Integer) session.getAttribute("studentId");
            String action = req.getParameter("action");

            // ================= WITHDRAW APPLICATION =================
            if("delete".equals(action))
            {
                String appIdParam = req.getParameter("applicationId");
                if (appIdParam != null && !appIdParam.trim().isEmpty())
                {
                    int applicationId = Integer.parseInt(appIdParam.trim());

                    StudentApplication application = new StudentApplication();
                    application.setApplicationId(applicationId);
                    application.setStudentId(studentId);

                    boolean success = application.DeleteMethod();
                    if(success)
                    {
                        session.setAttribute("applyMsg", "Application withdrawn successfully.");
                    }
                    else
                    {
                        session.setAttribute("applyError", "Unable to withdraw application. It may already be shortlisted or under active review.");
                    }
                }
                res.sendRedirect("student_application_view.jsp");
                return;
            }

            // ================= APPLY TO DRIVE =================
            String driveIdText = req.getParameter("driveId");

            if(driveIdText == null || driveIdText.trim().isEmpty())
            {
                session.setAttribute("applyError", "Placement drive ID is required to apply.");
                res.sendRedirect("student_drive_view.jsp");
                return;
            }

            int driveId = Integer.parseInt(driveIdText.trim());

            StudentApplication application = new StudentApplication();
            application.setStudentId(studentId);
            application.setDriveId(driveId);

            boolean inserted = application.InsertMethod();

            if(inserted)
            {
                session.setAttribute("applyMsg", "Application submitted successfully!");
                res.sendRedirect("student_apply_status.jsp?status=success&appId=" + application.getApplicationId() + "&driveId=" + driveId);
            }
            else
            {
                res.sendRedirect("student_apply_status.jsp?status=already_applied&driveId=" + driveId);
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            if(session != null)
            {
                session.setAttribute("applyError", "An unexpected error occurred: " + e.getMessage());
            }
            res.sendRedirect("student_apply_status.jsp?status=error");
        }
    }
}
