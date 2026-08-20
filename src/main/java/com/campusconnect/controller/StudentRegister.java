package com.campusconnect.controller;

import java.io.*;
import java.sql.Date;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.campusconnect.bean.Student;

@WebServlet("/studentRegister")
public class StudentRegister extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String dob = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");
        String college = req.getParameter("college");
        String course = req.getParameter("course");

        try
        {
            Student s = new Student();

            s.setName(name);
            s.setEmail(email);
            s.setPassword(password);
            s.setPhone(phone);
            s.setDob(Date.valueOf(dob));
            s.setGender(gender);
            s.setAddress(address);

            s.setCollegeId(Integer.parseInt(college));
            s.setCourseId(Integer.parseInt(course));

            boolean x = s.InsertMethod();

            if(x)
            {
                pw.println("<html><body>");
                pw.println("<h2>Student Registration Successful</h2>");
                pw.println("</body></html>");
            }
            else
            {
                pw.println("<html><body>");
                pw.println("<h2>Student Registration Failed</h2>");
                pw.println("</body></html>");
            }
        }
        catch(Exception e)
        {
            pw.println("<html><body>");
            pw.println("<h2>Registration Error</h2>");
            pw.println("<p>" + e + "</p>");
            pw.println("</body></html>");
        }
    }
}