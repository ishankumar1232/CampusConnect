package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.bean.Student;
import com.campusconnect.dao.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class StudentDetailsServlet extends HttpServlet {

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        // ================= SESSION CHECK =================

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            res.sendRedirect(req.getContextPath()
                    + "/superadmin/login.jsp");

            return;
        }

        // ================= GET STUDENT ID =================

        int id = Integer.parseInt(req.getParameter("id"));

        // ================= GET STUDENT DETAILS =================

        StudentDAO dao = new StudentDAO();

        Student s = dao.getStudentById(id);

        if (s == null) {

            res.sendRedirect(req.getContextPath()
                    + "/StudentManagementServlet");

            return;
        }

        req.setAttribute("student", s);

        // ================= FORWARD =================

        req.getRequestDispatcher("/superadmin/studentDetails.jsp")
                .forward(req, res);
    }
}