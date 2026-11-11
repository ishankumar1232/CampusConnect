package com.campusconnect.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.campusconnect.bean.Company;
import com.campusconnect.dao.CompanyDAO;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.dao.SystemSettingDAO;

@WebServlet("/CompanyLoginServlet")
public class CompanyLoginServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
    	// ======================================
    	// CHECK MAINTENANCE MODE
    	// ======================================

    	SystemSettingDAO settingDAO = new SystemSettingDAO();

    	SystemSetting setting = settingDAO.getSystemSettings();

    	if (setting != null &&
    	    "ON".equalsIgnoreCase(setting.getMaintenanceMode())) {

    	    response.setContentType("text/html");

    	    response.getWriter().println("<html>");
    	    response.getWriter().println("<body>");
    	    response.getWriter().println("<h2>System Under Maintenance</h2>");
    	    response.getWriter().println("<p>Company Login is temporarily unavailable.</p>");
    	    response.getWriter().println("</body>");
    	    response.getWriter().println("</html>");

    	    return;
    	}
    	
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        CompanyDAO dao = new CompanyDAO();

        Company c = dao.loginCompany(email, password);

        if(c != null)
        {
            HttpSession session = request.getSession();

            session.setAttribute("companyId", c.getCompanyId());
            session.setAttribute("companyName", c.getCompanyName());
            session.setAttribute("email", c.getEmail());

            response.sendRedirect("company-dashboard.jsp");
        }
        else
        {
            response.sendRedirect("login-failure.jsp");
        }
    }
}