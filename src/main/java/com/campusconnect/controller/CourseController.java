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

public class CourseController extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        if(req.getParameter("action") != null) {
            doPost(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/courseManagement.jsp");
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

            // ADD COURSE
            if("add".equals(action)) {

                String courseName =
                    req.getParameter("courseName");

                String departmentId =
                    req.getParameter("departmentId");

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

                // Generate Course ID
                String idSql =
                    "SELECT NVL(MAX(COURSE_ID),0)+1 " +
                    "FROM COURSE";

                int courseId = 1;
                try (PreparedStatement psId = con.prepareStatement(idSql);
                     ResultSet rsId = psId.executeQuery()) {
                    if(rsId.next()) {
                        courseId = rsId.getInt(1);
                    }
                }

                // Insert Course
                String insertSql =
                    "INSERT INTO COURSE " +
                    "(COURSE_ID, DEPARTMENT_ID, COURSE_NAME) " +
                    "VALUES (?, ?, ?)";

                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setInt(1, courseId);
                    psInsert.setInt(2, Integer.parseInt(departmentId));
                    psInsert.setString(3, courseName);
                    psInsert.executeUpdate();
                }

            }

            // DELETE COURSE
            else if("delete".equals(action)) {

                String courseId =
                    req.getParameter("courseId");

                // Delete only course of this college
                String deleteSql =
                    "DELETE FROM COURSE " +
                    "WHERE COURSE_ID=? " +
                    "AND DEPARTMENT_ID IN " +
                    "(SELECT DEPARTMENT_ID " +
                    "FROM DEPARTMENT " +
                    "WHERE COLLEGE_ID=?)";

                try (PreparedStatement psDelete = con.prepareStatement(deleteSql)) {
                    psDelete.setInt(1, Integer.parseInt(courseId));
                    psDelete.setInt(2, collegeId);
                    psDelete.executeUpdate();
                }

            }

            res.sendRedirect(
                req.getContextPath() +
                "/courseManagement.jsp"
            );

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " + e.getMessage() + "</h2>"
            );

        }
    }
}