package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

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


        try
        {
            Student s = new Student();

            s.setEmail(email);
            s.setPassword(password);


            boolean x = s.LoginMethod();


            if(x)
            {
                HttpSession session = req.getSession();

                session.setAttribute("studentId", s.getStudentId());

                res.sendRedirect("student_dashboard.jsp");
            }
            else
            {
                pw.println("<html><body>");
                pw.println("<h2>Invalid Email or Password</h2>");
                pw.println("</body></html>");
            }
            
        }
        catch(Exception e)
        {
            pw.println("<html><body>");

            pw.println("<h2>Login Error</h2>");

            pw.println("<p>" + e + "</p>");

            pw.println("</body></html>");
        }
    }
}