package com.campusconnect.controller;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import com.campusconnect.bean.CollegeAdmin;

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