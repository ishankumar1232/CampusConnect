package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeactivateUserServlet extends HttpServlet
{

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException
    {

        int id= Integer.parseInt(request.getParameter("id"));

        UserDAO dao=new UserDAO();

        dao.deactivateUser(id);

        response.sendRedirect(
        request.getContextPath()
        +"/UserManagementServlet");

    }

}