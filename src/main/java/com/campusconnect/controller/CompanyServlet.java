package com.campusconnect.controller;

import java.io.IOException;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.dao.SystemSettingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.campusconnect.bean.Company;
import com.campusconnect.dao.CompanyDAO;

@WebServlet("/CompanyServlet")
public class CompanyServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
    	// ======================================
    	// CHECK COMPANY REGISTRATION STATUS
    	// ======================================

    	SystemSettingDAO settingDAO = new SystemSettingDAO();

    	SystemSetting setting = settingDAO.getSystemSettings();

    	if (setting != null &&
    	    "OFF".equalsIgnoreCase(setting.getCompanyRegistration())) {

    	    response.setContentType("text/html");

    	    response.getWriter().println("<html><body>");
    	    response.getWriter().println("<h2>Company Registration Disabled</h2>");
    	    response.getWriter().println("<p>Company Registration has been disabled by Super Admin.</p>");
    	    response.getWriter().println("<a href='index.jsp'>Back</a>");
    	    response.getWriter().println("</body></html>");

    	    return;
    	}
    	
        String companyName = request.getParameter("companyName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address");
        String website = request.getParameter("website");
        String status = request.getParameter("status");

        if(!password.equals(confirmPassword))
        {
            response.sendRedirect("company-failure.jsp");
            return;
        }

        Company c = new Company();

        c.setCompanyName(companyName);
        c.setEmail(email);
        c.setPhone(phone);
        c.setPassword(password);
        c.setAddress(address);
        c.setWebsite(website);
        c.setStatus(status);

        CompanyDAO dao = new CompanyDAO();

        boolean result = dao.insertCompany(c);

        if(result)
        {
            response.sendRedirect("company-success.jsp");
        }
        else
        {
            response.sendRedirect("company-failure.jsp");
        }
    }
}