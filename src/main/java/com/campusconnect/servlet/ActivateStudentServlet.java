package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class ActivateStudentServlet extends HttpServlet {

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        int id = Integer.parseInt(req.getParameter("id"));

        StudentDAO dao = new StudentDAO();

        dao.activateStudent(id);

        res.sendRedirect(req.getContextPath()
                + "/StudentManagementServlet");
    }
}