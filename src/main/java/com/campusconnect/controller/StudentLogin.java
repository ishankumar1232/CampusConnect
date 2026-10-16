package com.campusconnect.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.campusconnect.bean.Student;

public class StudentLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws IOException, ServletException {

        req.setCharacterEncoding("UTF-8");

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