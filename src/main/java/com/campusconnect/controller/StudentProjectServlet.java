package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.StudentProject;

public class StudentProjectServlet extends HttpServlet
{
    public void doGet(HttpServletRequest req,
                      HttpServletResponse res)
                      throws IOException, ServletException
    {
        doPost(req, res);
    }

    public void doPost(HttpServletRequest req,
                       HttpServletResponse res)
                       throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        HttpSession session = null;
        try
        {
            // ================= LOGIN CHECK =================

            session = req.getSession(false);

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

                boolean x = project.DeleteMethod();

                if(x)
                {
                    session.setAttribute("projectMsg", "Project deleted successfully.");
                    res.sendRedirect("student_project_view.jsp");
                }
                else
                {
                    session.setAttribute("projectError", "Unable to delete project.");
                    res.sendRedirect("student_project_view.jsp");
                }

                return;
            }

            // ================= FORM DATA =================

            String projectId = req.getParameter("projectId");
            String projectName = req.getParameter("projectName");
            String description = req.getParameter("description");
            String technologies = req.getParameter("technologies");
            String projectUrl = req.getParameter("projectUrl");

            project.setProjectName(projectName);
            project.setDescription(description);
            project.setTechnologies(technologies);
            project.setProjectUrl(projectUrl);

            // ================= UPDATE =================

            if(projectId != null && !projectId.trim().equals(""))
            {
                project.setProjectId(Integer.parseInt(projectId.trim()));
                boolean x = project.UpdateMethod();

                if(x)
                {
                    session.setAttribute("projectMsg", "Project updated successfully!");
                    res.sendRedirect("student_project_view.jsp");
                }
                else
                {
                    session.setAttribute("projectError", "Project update failed. Please try again.");
                    res.sendRedirect("student_project.jsp?editId=" + projectId);
                }
            }

            // ================= ADD =================

            else
            {
                boolean x = project.InsertMethod();

                if(x)
                {
                    session.setAttribute("projectMsg", "Project added successfully to your portfolio!");
                    res.sendRedirect("student_project_view.jsp");
                }
                else
                {
                    session.setAttribute("projectError", "Failed to add project. Please try again.");
                    res.sendRedirect("student_project.jsp");
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("projectError", "An unexpected error occurred: " + e.getMessage());
            }
            res.sendRedirect("student_project_view.jsp");
        }
    }
}