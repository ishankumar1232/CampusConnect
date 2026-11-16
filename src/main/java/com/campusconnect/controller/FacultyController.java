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

public class FacultyController extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        if(req.getParameter("action") != null) {
            doPost(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/facultyManagement.jsp");
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

            // ADD FACULTY
            if("add".equals(action)) {

                String name = req.getParameter("name");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String departmentId = req.getParameter("departmentId");

                // Check department belongs to this college
                String checkSql =
                    "SELECT DEPARTMENT_ID " +
                    "FROM DEPARTMENT " +
                    "WHERE DEPARTMENT_ID=? " +
                    "AND COLLEGE_ID=?";

                try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
                    psCheck.setInt(1, Integer.parseInt(departmentId));
                    psCheck.setInt(2, collegeId);

                    try (ResultSet rsCheck = psCheck.executeQuery()) {
                        if(!rsCheck.next()) {
                            res.getWriter().println(
                                "<h2>Invalid Department</h2>"
                            );
                            return;
                        }
                    }
                }

                // Generate Faculty ID
                String idSql =
                    "SELECT NVL(MAX(FACULTY_ID),0)+1 " +
                    "FROM FACULTY";

                int facultyId = 1;
                try (PreparedStatement psId = con.prepareStatement(idSql);
                     ResultSet rsId = psId.executeQuery()) {
                    if(rsId.next()) {
                        facultyId = rsId.getInt(1);
                    }
                }

                // Insert Faculty
                String insertSql =
                    "INSERT INTO FACULTY " +
                    "(FACULTY_ID, COLLEGE_ID, DEPARTMENT_ID, " +
                    "NAME, EMAIL, PHONE) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setInt(1, facultyId);
                    psInsert.setInt(2, collegeId);
                    psInsert.setInt(3, Integer.parseInt(departmentId));
                    psInsert.setString(4, name);
                    psInsert.setString(5, email);
                    psInsert.setString(6, phone);
                    psInsert.executeUpdate();
                }

            }

            // DELETE FACULTY
            else if("delete".equals(action)) {

                String facultyId = req.getParameter("facultyId");

                // Delete only from logged-in college
                String deleteSql =
                    "DELETE FROM FACULTY " +
                    "WHERE FACULTY_ID=? " +
                    "AND COLLEGE_ID=?";

                try (PreparedStatement psDelete = con.prepareStatement(deleteSql)) {
                    psDelete.setInt(1, Integer.parseInt(facultyId));
                    psDelete.setInt(2, collegeId);
                    psDelete.executeUpdate();
                }

            }

            res.sendRedirect(
                req.getContextPath() +
                "/facultyManagement.jsp"
            );

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " + e.getMessage() + "</h2>"
            );

        }
    }
}