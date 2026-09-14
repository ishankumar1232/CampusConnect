package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.StudentSkill;


public class StudentSkillServlet extends HttpServlet
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


            StudentSkill skill =
                new StudentSkill();

            skill.setStudentId(studentId);


            // ================= DELETE =================

            if("delete".equals(action))
            {
                String id =
                    req.getParameter("skillId");

                int skillId =
                    Integer.parseInt(id);

                skill.setSkillId(skillId);


                boolean x =
                    skill.DeleteMethod();


                if(x)
                {
                    res.sendRedirect(
                        "student_skill_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");

                    pw.println(
                        "<h2>Skill Delete Failed</h2>"
                    );

                    pw.println(
                        "<br><a href='student_skill_view.jsp'>" +
                        "Back" +
                        "</a>"
                    );

                    pw.println("</body>");
                    pw.println("</html>");
                }

                return;
            }


            // ================= FORM DATA =================

            String skillId =
                req.getParameter("skillId");

            String skillName =
                req.getParameter("skillName");


            skill.setSkillName(skillName);


            // ================= UPDATE =================

            if(skillId != null &&
               !skillId.equals(""))
            {
                skill.setSkillId(
                    Integer.parseInt(skillId)
                );


                boolean x =
                    skill.UpdateMethod();


                if(x)
                {
                    res.sendRedirect(
                        "student_skill_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");

                    pw.println(
                        "<h2>Skill Update Failed</h2>"
                    );

                    pw.println(
                        "<br><a href='student_skill_view.jsp'>" +
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
                    skill.InsertMethod();


                if(x)
                {
                    res.sendRedirect(
                        "student_skill_view.jsp"
                    );
                }
                else
                {
                    pw.println("<html>");
                    pw.println("<body>");

                    pw.println(
                        "<h2>Skill Addition Failed</h2>"
                    );

                    pw.println(
                        "<br><a href='student_skill.jsp'>" +
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