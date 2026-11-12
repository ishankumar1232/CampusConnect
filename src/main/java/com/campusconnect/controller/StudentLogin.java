package com.campusconnect.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.campusconnect.bean.Student;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.dao.SystemSettingDAO; 

public class StudentLogin extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();
     // ======================================
     // CHECK MAINTENANCE MODE
     // ======================================

     SystemSettingDAO settingDAO = new SystemSettingDAO();

     SystemSetting setting = settingDAO.getSystemSettings();

     if (setting != null &&
         "ON".equalsIgnoreCase(setting.getMaintenanceMode())) {

         pw.println("<html>");
         pw.println("<body>");

         pw.println("<h2>System Under Maintenance</h2>");

         pw.println("<p>");
         pw.println("Student Login is temporarily unavailable.");
         pw.println("</p>");

         pw.println("</body>");
         pw.println("</html>");

         return;
     }
        

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Student s = new Student();

            s.setEmail(email);
            s.setPassword(password);

            boolean valid = s.LoginMethod();

            if (valid) {

                HttpSession session = req.getSession();

                session.setAttribute("studentId", s.getStudentId());
                session.setAttribute("studentName", s.getName());
                session.setAttribute("collegeId", s.getCollegeId());

                res.sendRedirect(
                    req.getContextPath() + "/student_dashboard.jsp"
                );

            } else {

                res.sendRedirect(
                    req.getContextPath()
                    + "/student_login.jsp?error=invalid"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            res.sendRedirect(
                req.getContextPath()
                + "/student_login.jsp?error=server"
            );
        }
    }
}