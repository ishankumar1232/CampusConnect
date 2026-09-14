package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.StudentAcademic;

public class StudentAcademicServlet extends HttpServlet
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

            // ================= LOGIN CHECK =================

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


            StudentAcademic academic =
                new StudentAcademic();

            academic.setStudentId(studentId);


            // ================= DELETE =================

            if("delete".equals(action))
            {
                String id =
                    req.getParameter("academicId");

                int academicId =
                    Integer.parseInt(id);

                academic.setAcademicId(academicId);

                boolean x =
                    academic.DeleteMethod();

                if(x)
                {
                    res.sendRedirect(
                        "student_academic_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");
                    pw.println("<h2>Delete Failed</h2>");
                    pw.println(
                        "<a href='student_academic_view.jsp'>" +
                        "Back" +
                        "</a>"
                    );
                    pw.println("</body>");
                    pw.println("</html>");
                }

                return;
            }


            // ================= FORM DATA =================

            String academicId =
                req.getParameter("academicId");

            String qualification =
                req.getParameter("qualification");

            String year =
                req.getParameter("year");

            String percentage =
                req.getParameter("percentage");

            String cgpa =
                req.getParameter("cgpa");

            String backlogs =
                req.getParameter("backlogs");


            academic.setQualification(
                qualification
            );

            academic.setYear(
                Integer.parseInt(year)
            );

            academic.setPercentage(
                Double.parseDouble(percentage)
            );

            academic.setCgpa(
                Double.parseDouble(cgpa)
            );

            academic.setBacklogs(
                Integer.parseInt(backlogs)
            );


            // ================= UPDATE =================

            if(academicId != null &&
               !academicId.equals(""))
            {
                academic.setAcademicId(
                    Integer.parseInt(academicId)
                );

                boolean x =
                    academic.UpdateMethod();

                if(x)
                {
                    res.sendRedirect(
                        "student_academic_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");
                    pw.println(
                        "<h2>Academic Details Update Failed</h2>"
                    );
                    pw.println(
                        "<a href='student_academic_view.jsp'>" +
                        "Back" +
                        "</a>"
                    );
                    pw.println("</body>");
                    pw.println("</html>");
                }
            }


            // ================= ADD =================

            else
            {
                boolean x =
                    academic.InsertMethod();

                if(x)
                {
                    res.sendRedirect(
                        "student_academic_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");
                    pw.println(
                        "<h2>Academic Details Add Failed</h2>"
                    );
                    pw.println(
                        "<a href='student_academic.jsp'>" +
                        "Back" +
                        "</a>"
                    );
                    pw.println("</body>");
                    pw.println("</html>");
                }
            }
        }
        catch(Exception e)
        {
            pw.println("<html>");
            pw.println("<body>");

            pw.println("<h2>Error</h2>");

            pw.println(
                "<p>" + e.getMessage() + "</p>"
            );

            pw.println(
                "<a href='student_dashboard.jsp'>" +
                "Back to Dashboard" +
                "</a>"
            );

            pw.println("</body>");
            pw.println("</html>");
        }
    }
}