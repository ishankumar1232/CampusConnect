 package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.CollegeDAO;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RejectCollegeServlet extends HttpServlet{

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException{

        int id=Integer.parseInt(request.getParameter("id"));

        CollegeDAO dao=new CollegeDAO();

        dao.rejectCollege(id);

        response.sendRedirect("CollegeManagementServlet");

    }

}