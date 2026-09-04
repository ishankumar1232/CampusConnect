package com.campusconnect.controller;

import com.campusconnect.bean.Company;
import com.campusconnect.dao.CompanyDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CompanyController")
public class CompanyController extends HttpServlet {

    CompanyDAO dao = new CompanyDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action) || action == null) {
            listCompanies(req, resp);
        } else if ("edit".equals(action)) {
            editCompany(req, resp);
        } else if ("delete".equals(action)) {
            deleteCompany(req, resp);
        } else if ("showAdd".equals(action)) {
            req.getRequestDispatcher("/jsp/college/company/company.jsp").forward(req, resp);
        } else if ("add".equals(action)) {
            req.getRequestDispatcher("/jsp/college/company/company.jsp").forward(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addCompany(req, resp);
        } else if ("update".equals(action)) {
            updateCompany(req, resp);
        }
    }

    private void listCompanies(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Company> list = dao.getAllCompanies();
        req.setAttribute("companyList", list);
        req.getRequestDispatcher("/jsp/college/company/companyList.jsp").forward(req, resp);
    }

    private void addCompany(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String companyName = req.getParameter("companyName");
        String industry = req.getParameter("industry");
        String website = req.getParameter("website");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String description = req.getParameter("description");
        String contactPerson = req.getParameter("contactPerson");
        String status = req.getParameter("status");

        Company company = new Company();
        company.setCompanyName(companyName);
        company.setIndustry(industry);
        company.setWebsite(website);
        company.setEmail(email);
        company.setPhone(phone);
        company.setAddress(address);
        company.setDescription(description);
        company.setContactPerson(contactPerson);
        company.setStatus(status);

        boolean result = dao.addCompany(company);

        if (result) {
            resp.sendRedirect("CompanyController?action=list");
        } else {
            req.setAttribute("message", "Failed to add company!");
            req.getRequestDispatcher("/jsp/college/company/company.jsp").forward(req, resp);
        }
    }

    private void editCompany(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int companyId = Integer.parseInt(req.getParameter("companyId"));
        Company company = dao.getCompanyById(companyId);

        req.setAttribute("company", company);
        req.getRequestDispatcher("/jsp/college/company/company.jsp").forward(req, resp);
    }

    private void updateCompany(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int companyId = Integer.parseInt(req.getParameter("companyId"));
        String companyName = req.getParameter("companyName");
        String industry = req.getParameter("industry");
        String website = req.getParameter("website");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String description = req.getParameter("description");
        String contactPerson = req.getParameter("contactPerson");
        String status = req.getParameter("status");

        Company company = new Company();
        company.setCompanyId(companyId);
        company.setCompanyName(companyName);
        company.setIndustry(industry);
        company.setWebsite(website);
        company.setEmail(email);
        company.setPhone(phone);
        company.setAddress(address);
        company.setDescription(description);
        company.setContactPerson(contactPerson);
        company.setStatus(status);

        boolean result = dao.updateCompany(company);

        if (result) {
            resp.sendRedirect("CompanyController?action=list");
        } else {
            req.setAttribute("message", "Failed to update company!");
            req.setAttribute("company", company);
            req.getRequestDispatcher("/jsp/college/company/company.jsp").forward(req, resp);
        }
    }

    private void deleteCompany(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int companyId = Integer.parseInt(req.getParameter("companyId"));

        boolean result = dao.deleteCompany(companyId);

        if (result) {
            resp.sendRedirect("CompanyController?action=list");
        } else {
            req.setAttribute("message", "Failed to delete company!");
            listCompanies(req, resp);
        }
    }
}