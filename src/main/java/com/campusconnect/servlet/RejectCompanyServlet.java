package com.campusconnect.servlet;

import java.io.IOException;

import com.campusconnect.dao.CompanyDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RejectCompanyServlet extends HttpServlet
{

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException
    {

        int id =
        Integer.parseInt(req.getParameter("id"));

        CompanyDAO dao = new CompanyDAO();

        dao.rejectCompany(id);

        res.sendRedirect(
        req.getContextPath()
        + "/CompanyManagementServlet");

    }

}