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

@WebServlet("/CompanyLoginServlet")
public class CompanyLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get login details
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // DAO object
        CompanyDAO dao = new CompanyDAO();

        // Check company login
        Company c = dao.loginCompany(email, password);

        if (c != null) {

            // Create session
            HttpSession session = request.getSession();

            // Store company details
            session.setAttribute("companyId", c.getCompanyId());
            session.setAttribute("companyName", c.getCompanyName());
            session.setAttribute("email", c.getEmail());

            /*
             * =====================================================
             * COMPANY LOGO AND BANNER
             * =====================================================
             */

            String companyName = c.getCompanyName();

            String logoPath = "images/company/default-logo.png";
            String bannerPath = "images/company/default-banner.png";

            if (companyName != null) {

                String name = companyName.trim().toLowerCase();

                // TCS
                if (name.contains("tcs")
                        || name.contains("tata consultancy")) {

                    logoPath = "images/company/tcs-logo.png";
                    bannerPath = "images/company/tcs-banner.png";
                }

                // Infosys
                else if (name.contains("infosys")) {

                    logoPath = "images/company/infosys-logo.png";
                    bannerPath = "images/company/infosys-dashboard.png";
                }

                // Google
                else if (name.contains("google")) {

                    logoPath = "images/company/google-logo.png";
                    bannerPath = "images/company/google-dashboard.png";
                }
            }

            // Store image paths in session
            session.setAttribute("companyLogo", logoPath);
            session.setAttribute("companyBanner", bannerPath);

            /*
             * =====================================================
             * REDIRECT TO COMPANY DASHBOARD
             * =====================================================
             */

            response.sendRedirect("company-dashboard.jsp");

        } else {

            // Login failed
            response.sendRedirect("login-failure.jsp");
        }
    }
}