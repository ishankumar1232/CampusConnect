package com.campusconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CourseController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        Integer collegeId = (Integer) session.getAttribute("collegeId");

        if(collegeId == null) {
            res.sendRedirect("collegeAdminLogin.jsp");
            return;
        }

        String action = req.getParameter("action");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );


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

                ps = con.prepareStatement(checkSql);

                ps.setInt(1, Integer.parseInt(departmentId));
                ps.setInt(2, collegeId);

                rs = ps.executeQuery();

                if(!rs.next()) {

                    res.getWriter().println(
                        "<h2>Invalid Department</h2>"
                    );

                    return;
                }

                rs.close();
                ps.close();


                // Generate Course ID
                String idSql =
                    "SELECT NVL(MAX(COURSE_ID),0)+1 " +
                    "FROM COURSE";

                ps = con.prepareStatement(idSql);

                rs = ps.executeQuery();

                int courseId = 1;

                if(rs.next()) {
                    courseId = rs.getInt(1);
                }

                rs.close();
                ps.close();


                // Insert Course
                String insertSql =
                    "INSERT INTO COURSE " +
                    "(COURSE_ID, DEPARTMENT_ID, COURSE_NAME) " +
                    "VALUES (?, ?, ?)";

                ps = con.prepareStatement(insertSql);

                ps.setInt(1, courseId);
                ps.setInt(2, Integer.parseInt(departmentId));
                ps.setString(3, courseName);

                ps.executeUpdate();

                ps.close();

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

                ps = con.prepareStatement(deleteSql);

                ps.setInt(1, Integer.parseInt(courseId));
                ps.setInt(2, collegeId);

                ps.executeUpdate();

                ps.close();

            }

            con.close();

            res.sendRedirect(
                req.getContextPath() +
                "/courseManagement.jsp"
            );

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " + e.getMessage() + "</h2>"
            );

        } finally {

            if(rs != null) {
                try { rs.close(); } catch(Exception e) {}
            }

            if(ps != null) {
                try { ps.close(); } catch(Exception e) {}
            }

            if(con != null) {
                try { con.close(); } catch(Exception e) {}
            }

        }
    }
}