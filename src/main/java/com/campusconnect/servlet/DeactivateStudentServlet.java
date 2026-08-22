package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeactivateStudentServlet extends HttpServlet
{

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException
    {

        int id = Integer.parseInt(req.getParameter("id"));

        StudentDAO dao = new StudentDAO();

        dao.deactivateStudent(id);

        res.sendRedirect(req.getContextPath()
                + "/StudentManagementServlet");

    }

}