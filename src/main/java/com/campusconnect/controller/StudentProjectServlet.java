package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.StudentProject;


public class StudentProjectServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req,
                       HttpServletResponse res)
                       throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        try
        {
            // ================= LOGIN CHECK =================

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


            StudentProject project =
                new StudentProject();

            project.setStudentId(studentId);


            // ================= DELETE =================

            if("delete".equals(action))
            {
                String id =
                    req.getParameter("projectId");

                int projectId =
                    Integer.parseInt(id);

                project.setProjectId(projectId);


                boolean x =
                    project.DeleteMethod();


                if(x)
                {
                    res.sendRedirect(
                        "student_project_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");

                    pw.println(
                        "<h2>Project Delete Failed</h2>"
                    );

                    pw.println(
                        "<br><a href='student_project_view.jsp'>" +
                        "Back" +
                        "</a>"
                    );

                    pw.println("</body>");
                    pw.println("</html>");
                }

                return;
            }


            // ================= FORM DATA =================

            String projectId =
                req.getParameter("projectId");

            String projectName =
                req.getParameter("projectName");

            String description =
                req.getParameter("description");

            String technologies =
                req.getParameter("technologies");

            String projectUrl =
                req.getParameter("projectUrl");


            project.setProjectName(
                projectName
            );

            project.setDescription(
                description
            );

            project.setTechnologies(
                technologies
            );

            project.setProjectUrl(
                projectUrl
            );


            // ================= UPDATE =================

            if(projectId != null &&
               !projectId.equals(""))
            {
                project.setProjectId(
                    Integer.parseInt(projectId)
                );


                boolean x =
                    project.UpdateMethod();


                if(x)
                {
                    res.sendRedirect(
                        "student_project_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");

                    pw.println(
                        "<h2>Project Update Failed</h2>"
                    );

                    pw.println(
                        "<br><a href='student_project_view.jsp'>" +
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
                    project.InsertMethod();


                if(x)
                {
                    res.sendRedirect(
                        "student_project_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");

                    pw.println(
                        "<h2>Project Addition Failed</h2>"
                    );

                    pw.println(
                        "<br><a href='student_project.jsp'>" +
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
                "<br><a href='student_dashboard.jsp'>" +
                "Back to Dashboard" +
                "</a>"
            );

            pw.println("</body>");
            pw.println("</html>");
        }
    }
}