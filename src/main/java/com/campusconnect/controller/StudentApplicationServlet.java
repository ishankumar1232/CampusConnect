package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.campusconnect.bean.StudentApplication;

 
public class StudentApplicationServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String driveIdText = req.getParameter("driveId");

        try
        {
            HttpSession session = req.getSession(false);

            if(session == null ||
               session.getAttribute("studentId") == null)
            {
                res.sendRedirect("student_login.jsp");
                return;
            }

            int studentId =
                (Integer)session.getAttribute("studentId");

            int driveId =
                Integer.parseInt(driveIdText);


            StudentApplication application =
                new StudentApplication();

            application.setStudentId(studentId);
            application.setDriveId(driveId);


            boolean x = application.InsertMethod();


            if(x)
            {
                pw.println("<html><body>");

                pw.println("<h2>Application Submitted Successfully</h2>");

                pw.println("<br>");

                pw.println("<a href='student_drive_view.jsp'>");
                pw.println("Back to Placement Drives");
                pw.println("</a>");

                pw.println("<br><br>");

                pw.println("<a href='student_dashboard.jsp'>");
                pw.println("Back to Dashboard");
                pw.println("</a>");

                pw.println("</body></html>");
            }
            else
            {
                pw.println("<html><body>");

                pw.println("<h2>Application Submission Failed</h2>");

                pw.println("</body></html>");
            }
        }
        catch(Exception e)
        {
            pw.println("<html><body>");

            pw.println("<h2>Error</h2>");

            pw.println("<p>" + e + "</p>");

            pw.println("</body></html>");
        }
    }
}