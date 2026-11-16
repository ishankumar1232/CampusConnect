package com.campusconnect.servlet;

import java.io.IOException;
import java.util.ArrayList;

import com.campusconnect.bean.Student;
import com.campusconnect.dao.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class StudentManagementServlet extends HttpServlet {

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

        StudentDAO dao = new StudentDAO();

        ArrayList<Student> list = dao.getAllStudents();

        req.setAttribute("studentList", list);

        req.getRequestDispatcher("superadmin/studentManagement.jsp")
                .forward(req, res);

    }

}