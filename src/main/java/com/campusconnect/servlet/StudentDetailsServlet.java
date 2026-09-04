package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.bean.Student;
import com.campusconnect.dao.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class StudentDetailsServlet extends HttpServlet
{

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException
    {

        int id =
        Integer.parseInt(req.getParameter("id"));

        StudentDAO dao =
        new StudentDAO();

        Student s =
        dao.getStudentById(id);

        req.setAttribute("student", s);

        req.getRequestDispatcher(
        "superadmin/studentDetails.jsp")
        .forward(req, res);

    }

}