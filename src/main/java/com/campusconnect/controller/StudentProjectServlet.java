package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.campusconnect.bean.StudentProject;

 
public class StudentProjectServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String projectName = req.getParameter("projectName");
        String description = req.getParameter("description");
        String technologies = req.getParameter("technologies");
        String projectUrl = req.getParameter("projectUrl");

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


            StudentProject project =
                new StudentProject();

            project.setStudentId(studentId);
            project.setProjectName(projectName);
            project.setDescription(description);
            project.setTechnologies(technologies);
            project.setProjectUrl(projectUrl);


            boolean x = project.InsertMethod();


            if(x)
            {
                pw.println("<html><body>");

                pw.println("<h2>Project Added Successfully</h2>");

                pw.println("<br>");

                pw.println("<a href='student_project.jsp'>");
                pw.println("Add Another Project");
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

                pw.println("<h2>Project Addition Failed</h2>");

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