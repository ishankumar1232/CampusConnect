package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.campusconnect.bean.StudentResume;

@WebServlet("/studentResume")
public class StudentResumeServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String resumeFile = req.getParameter("resumeFile");

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


            StudentResume resume =
                new StudentResume();

            resume.setStudentId(studentId);
            resume.setResumeFile(resumeFile);


            boolean x = resume.InsertMethod();


            if(x)
            {
                pw.println("<html><body>");

                pw.println("<h2>Resume Added Successfully</h2>");

                pw.println("<br>");

                pw.println("<a href='student_resume.jsp'>");
                pw.println("Add Resume Again");
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

                pw.println("<h2>Resume Addition Failed</h2>");

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