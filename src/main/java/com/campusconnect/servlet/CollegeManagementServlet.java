package com.campusconnect.servlet;

import java.io.IOException;
import java.util.ArrayList;

import com.campusconnect.bean.College;
import com.campusconnect.dao.CollegeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CollegeManagementServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        CollegeDAO dao = new CollegeDAO();

        ArrayList<College> list = dao.getAllColleges();

        request.setAttribute("collegeList", list);

        request.getRequestDispatcher("/superadmin/collegeManagement.jsp")
               .forward(request, response);

    }

}