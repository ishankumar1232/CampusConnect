package com.campusconnect.servlet;

import java.io.IOException;
import java.util.ArrayList;

import com.campusconnect.bean.Company;
import com.campusconnect.dao.CompanyDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class CompanyManagementServlet extends HttpServlet {

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws ServletException, IOException {

        CompanyDAO dao = new CompanyDAO();

        ArrayList<Company> list = dao.getAllCompanies();

        req.setAttribute("companyList", list);

        RequestDispatcher rd =
                req.getRequestDispatcher("superadmin/companyManagement.jsp");

        rd.forward(req, res);
    }
}