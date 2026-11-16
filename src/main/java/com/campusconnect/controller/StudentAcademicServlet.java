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

        HttpSession session = null;
        try
        {
            session = req.getSession(false);

            // ================= LOGIN CHECK =================

            if(session == null || session.getAttribute("studentId") == null)
            {
                res.sendRedirect("student_login.jsp");
                return;
            }

            int studentId = (Integer)session.getAttribute("studentId");
            String action = req.getParameter("action");

            StudentAcademic academic = new StudentAcademic();
            academic.setStudentId(studentId);

            // ================= DELETE =================

            if("delete".equals(action))
            {
                String id = req.getParameter("academicId");
                int academicId = Integer.parseInt(id);
                academic.setAcademicId(academicId);

                boolean x = academic.DeleteMethod();

                if(x)
                {
                    session.setAttribute("academicMsg", "Academic record deleted successfully.");
                    res.sendRedirect("student_academic_view.jsp");
                }
                else
                {
                    session.setAttribute("academicError", "Unable to delete academic record.");
                    res.sendRedirect("student_academic_view.jsp");
                }

                return;
            }

            // ================= FORM DATA =================

            String academicId = req.getParameter("academicId");
            String qualification = req.getParameter("qualification");
            String year = req.getParameter("year");
            String percentage = req.getParameter("percentage");
            String cgpa = req.getParameter("cgpa");
            String backlogs = req.getParameter("backlogs");

            if (qualification != null) qualification = qualification.trim();
            if (backlogs == null || backlogs.trim().isEmpty()) backlogs = "0";

            academic.setQualification(qualification);
            academic.setYear(Integer.parseInt(year.trim()));
            academic.setPercentage(Double.parseDouble(percentage.trim()));
            academic.setCgpa(Double.parseDouble(cgpa.trim()));
            academic.setBacklogs(Integer.parseInt(backlogs.trim()));

            // ================= UPDATE =================

            if(academicId != null && !academicId.trim().equals(""))
            {
                academic.setAcademicId(Integer.parseInt(academicId.trim()));
                boolean x = academic.UpdateMethod();

                if(x)
                {
                    session.setAttribute("academicMsg", "Academic details updated successfully!");
                    res.sendRedirect("student_academic_view.jsp");
                }
                else
                {
                    session.setAttribute("academicError", "Academic details update failed. Please try again.");
                    res.sendRedirect("student_academic.jsp?editId=" + academicId);
                }
            }

            // ================= ADD =================

            else
            {
                boolean x = academic.InsertMethod();

                if(x)
                {
                    session.setAttribute("academicMsg", "Academic details added successfully!");
                    res.sendRedirect("student_academic_view.jsp");
                }
                else
                {
                    session.setAttribute("academicError", "Failed to add academic record. Please try again.");
                    res.sendRedirect("student_academic.jsp");
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("academicError", "An unexpected error occurred: " + e.getMessage());
            }
            res.sendRedirect("student_academic_view.jsp");
        }
    }
}