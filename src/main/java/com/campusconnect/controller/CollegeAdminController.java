package com.campusconnect.controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.CollegeAdmin;

import com.campusconnect.dao.SystemSettingDAO;
import com.campusconnect.bean.SystemSetting;

public class CollegeAdminController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String college = req.getParameter("collegeId");

        try {
        	
        	// ======================================
        	// CHECK COLLEGE REGISTRATION STATUS
        	// ======================================

        	SystemSettingDAO settingDAO = new SystemSettingDAO();

        	SystemSetting setting = settingDAO.getSystemSettings();

        	if (setting != null &&
        	    "OFF".equalsIgnoreCase(setting.getCollegeRegistration())) {

        	    pw.println("<html>");
        	    pw.println("<body>");

        	    pw.println("<h2>College Registration Disabled</h2>");

        	    pw.println("<p>");
        	    pw.println("College Registration has been disabled by Super Admin.");
        	    pw.println("</p>");

        	    pw.println("<a href='index.jsp'>Back</a>");

        	    pw.println("</body>");
        	    pw.println("</html>");

        	    return;
        	}

            CollegeAdmin admin = new CollegeAdmin();

            admin.setName(name);
            admin.setEmail(email);
            admin.setPassword(password);
            admin.setCollegeId(Integer.parseInt(college));

            boolean x = admin.InsertMethod();

            if(x) {

                pw.println("<html><body>");
                pw.println("<h2>College Admin Registration Successful</h2>");
                pw.println("<a href='collegeAdminLogin.jsp'>Login</a>");
                pw.println("</body></html>");

            }
            else {

                pw.println("<html><body>");
                pw.println("<h2>College Admin Registration Failed</h2>");
                pw.println("</body></html>");

            }

        }
        catch(Exception e) {

            pw.println("<html><body>");
            pw.println("<h2>Registration Error</h2>");
            pw.println("<p>" + e + "</p>");
            pw.println("</body></html>");

        }
    }
}