package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
 
import com.campusconnect.bean.StudentAcademic;

 
public class StudentAcademicServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String qualification = req.getParameter("qualification");
        String year = req.getParameter("year");
        String percentage = req.getParameter("percentage");
        String cgpa = req.getParameter("cgpa");
        String backlogs = req.getParameter("backlogs");


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


            StudentAcademic academic =
                new StudentAcademic();


            academic.setStudentId(studentId);

            academic.setQualification(qualification);

            academic.setYear(Integer.parseInt(year));

            academic.setPercentage(
                Double.parseDouble(percentage)
            );

            academic.setCgpa(
                Double.parseDouble(cgpa)
            );

            academic.setBacklogs(
                Integer.parseInt(backlogs)
            );


            boolean x = academic.InsertMethod();


            if(x)
            {
                pw.println("<html><body>");

                pw.println("<h2>Academic Details Added Successfully</h2>");

                pw.println("<br>");

                pw.println("<a href='student_dashboard.jsp'>");
                pw.println("Back to Dashboard");
                pw.println("</a>");

                pw.println("</body></html>");
            }
            else
            {
                pw.println("<html><body>");

                pw.println("<h2>Academic Details Failed</h2>");

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