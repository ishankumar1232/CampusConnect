package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.StudentApplication;


public class StudentApplicationServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req,
                       HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        try
        {
            HttpSession session =
                req.getSession(false);

            if(session == null ||
               session.getAttribute("studentId") == null)
            {
                res.sendRedirect("student_login.jsp");
                return;
            }


            int studentId =
                (Integer)session.getAttribute("studentId");


            String action =
                req.getParameter("action");


            // ================= WITHDRAW =================

            if("delete".equals(action))
            {
                int applicationId =
                    Integer.parseInt(
                        req.getParameter("applicationId")
                    );


                StudentApplication application =
                    new StudentApplication();

                application.setApplicationId(
                    applicationId
                );

                application.setStudentId(
                    studentId
                );


                boolean x =
                    application.DeleteMethod();


                if(x)
                {
                    res.sendRedirect(
                        "student_application_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html><body>");

                    pw.println(
                        "<h2>Application Withdraw Failed</h2>"
                    );

                    pw.println(
                        "<br><a href='student_application_view.jsp'>"
                    );

                    pw.println(
                        "Back to Applications"
                    );

                    pw.println("</a>");

                    pw.println("</body></html>");
                }

                return;
            }


            // ================= APPLY =================

            String driveIdText =
                req.getParameter("driveId");


            if(driveIdText == null ||
               driveIdText.trim().equals(""))
            {
                pw.println("<html><body>");

                pw.println(
                    "<h2>Drive ID is required</h2>"
                );

                pw.println("</body></html>");

                return;
            }


            int driveId =
                Integer.parseInt(driveIdText);


            StudentApplication application =
                new StudentApplication();


            application.setStudentId(
                studentId
            );

            application.setDriveId(
                driveId
            );


            boolean x =
                application.InsertMethod();


            if(x)
            {
                pw.println("<html><body>");

                pw.println(
                    "<h2>Application Submitted Successfully</h2>"
                );

                pw.println("<br>");

                pw.println(
                    "<a href='student_drive_view.jsp'>"
                );

                pw.println(
                    "Back to Placement Drives"
                );

                pw.println("</a>");

                pw.println("<br><br>");

                pw.println(
                    "<a href='student_application_view.jsp'>"
                );

                pw.println(
                    "View My Applications"
                );

                pw.println("</a>");

                pw.println("<br><br>");

                pw.println(
                    "<a href='student_dashboard.jsp'>"
                );

                pw.println(
                    "Back to Dashboard"
                );

                pw.println("</a>");

                pw.println("</body></html>");
            }
            else
            {
                pw.println("<html><body>");

                pw.println(
                    "<h2>Application Submission Failed</h2>"
                );

                pw.println("<br>");

                pw.println(
                    "<a href='student_drive_view.jsp'>"
                );

                pw.println(
                    "Back to Placement Drives"
                );

                pw.println("</a>");

                pw.println("</body></html>");
            }
        }
        catch(Exception e)
        {
            pw.println("<html><body>");

            pw.println("<h2>Error</h2>");

            pw.println(
                "<p>" + e.getMessage() + "</p>"
            );

            pw.println("</body></html>");
        }
    }
}