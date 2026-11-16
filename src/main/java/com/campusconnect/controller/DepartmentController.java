package com.campusconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.campusconnect.util.DBConnection;

public class DepartmentController extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        if(req.getParameter("action") != null) {
            doPost(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/departmentManagement.jsp");
        }
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        Integer collegeId = (Integer) session.getAttribute("collegeId");

        if(collegeId == null) {
            res.sendRedirect("collegeAdminLogin.jsp");
            return;
        }

        String action = req.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {

            // ADD DEPARTMENT
            if("add".equals(action)) {

                String departmentName =
                    req.getParameter("departmentName");

                // Generate Department ID
                String idSql =
                    "SELECT NVL(MAX(DEPARTMENT_ID),0)+1 " +
                    "FROM DEPARTMENT";

                int departmentId = 1;
                try (PreparedStatement ps = con.prepareStatement(idSql);
                     ResultSet rs = ps.executeQuery()) {
                    if(rs.next()) {
                        departmentId = rs.getInt(1);
                    }
                }

                // Insert Department
                String insertSql =
                    "INSERT INTO DEPARTMENT " +
                    "(DEPARTMENT_ID, COLLEGE_ID, DEPARTMENT_NAME) " +
                    "VALUES (?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setInt(1, departmentId);
                    ps.setInt(2, collegeId);
                    ps.setString(3, departmentName);
                    ps.executeUpdate();
                }

            }

            // DELETE DEPARTMENT
            else if("delete".equals(action)) {

                String departmentId =
                    req.getParameter("departmentId");

                // Delete only from logged-in college
                String deleteSql =
                    "DELETE FROM DEPARTMENT " +
                    "WHERE DEPARTMENT_ID=? " +
                    "AND COLLEGE_ID=?";

                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setInt(1, Integer.parseInt(departmentId));
                    ps.setInt(2, collegeId);
                    ps.executeUpdate();
                }

            }

            res.sendRedirect(
                req.getContextPath() +
                "/departmentManagement.jsp"
            );

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " + e.getMessage() + "</h2>"
            );

        }
    }
}