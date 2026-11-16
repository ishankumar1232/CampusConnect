package com.campusconnect.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.campusconnect.bean.Admission;

public class AdmissionStatusController extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        if(req.getParameter("admissionId") != null && req.getParameter("status") != null) {
            doPost(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/admissionManagement.jsp");
        }
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String id = req.getParameter("admissionId");
        String status = req.getParameter("status");
        String feeParam = req.getParameter("admissionFee");

        try {

            int admissionId = Integer.parseInt(id);
            double admissionFee = 50000.0;
            if (feeParam != null && !feeParam.trim().isEmpty()) {
                try {
                    admissionFee = Double.parseDouble(feeParam.trim());
                } catch (NumberFormatException nfe) {
                    admissionFee = 50000.0;
                }
            }

            Admission admission = new Admission();

            boolean x =
                admission.updateAdmissionStatus(admissionId, status, admissionFee);

            if(x) {

                res.sendRedirect(
                    req.getContextPath() +
                    "/admissionManagement.jsp"
                );

            } else {

                res.getWriter().println(
                    "<h2>Failed to update admission</h2>"
                );
            }

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " + e.getMessage() + "</h2>"
            );
        }
    }
}