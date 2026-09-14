package com.campusconnect.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.campusconnect.bean.Admission;

public class AdmissionStatusController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String id = req.getParameter("admissionId");
        String status = req.getParameter("status");

        try {

            int admissionId = Integer.parseInt(id);

            Admission admission = new Admission();

            boolean x =
                admission.updateAdmissionStatus(admissionId, status);

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