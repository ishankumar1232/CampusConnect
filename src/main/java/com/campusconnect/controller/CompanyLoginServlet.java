
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

public class CompanyLoginServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
    	// CHECK MAINTENANCE MODE

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

        // DAO object
        CompanyDAO dao = new CompanyDAO();

        // Check company login
        Company c = dao.loginCompany(email, password);

        if (c != null) {

            // Check if Company is approved
            if (!"Approved".equalsIgnoreCase(c.getStatus()) && !"ACTIVE".equalsIgnoreCase(c.getStatus())) {
                response.sendRedirect("company-login.jsp?error=not_approved");
                return;
            }

            // Create session
            HttpSession session = request.getSession();

            // Store company details
            session.setAttribute("companyId", c.getCompanyId());
            session.setAttribute("companyName", c.getCompanyName());
            session.setAttribute("email", c.getEmail());

            // Get logo and banner paths from database
            String logoPath = c.getLogoUrl();
            String bannerPath = c.getBannerUrl();

            String cName = c.getCompanyName() != null ? c.getCompanyName().toLowerCase() : "";

            // Use name-matched images for demo accounts, or empty if new registered company
            if (logoPath == null || logoPath.trim().isEmpty() ||
                (logoPath.contains("tcs-logo.png") && !cName.contains("tcs") && !cName.contains("tata consultancy")) ||
                logoPath.contains("default-logo.png")) {
                if (cName.contains("infosys")) {
                    logoPath = "images/company/infosys-logo.png";
                } else if (cName.contains("google")) {
                    logoPath = "images/company/google-logo.png";
                } else if (cName.contains("meta")) {
                    logoPath = "images/company/meta-logo.png";
                } else if (cName.contains("tcs") || cName.contains("tata consultancy")) {
                    logoPath = "images/company/tcs-logo.png";
                } else {
                    logoPath = "";
                }
            }

            if (bannerPath == null || bannerPath.trim().isEmpty() ||
                (bannerPath.contains("tcs-banner.png") && !cName.contains("tcs") && !cName.contains("tata consultancy")) ||
                bannerPath.contains("default-banner.png")) {
                if (cName.contains("infosys")) {
                    bannerPath = "images/company/infosys-dashboard.png";
                } else if (cName.contains("google")) {
                    bannerPath = "images/company/google-dashboard.png";
                } else if (cName.contains("meta")) {
                    bannerPath = "images/company/meta-banner.png";
                } else if (cName.contains("tcs") || cName.contains("tata consultancy")) {
                    bannerPath = "images/company/tcs-banner.png";
                } else {
                    bannerPath = "";
                }
            }

            // Store image paths in session
            session.setAttribute("companyLogo", logoPath);
            session.setAttribute("companyBanner", bannerPath);

            // Redirect to company dashboard
            response.sendRedirect("company-dashboard.jsp");

        } else {

            // Login failed
            response.sendRedirect("login-failure.jsp");
        }
    }
}
