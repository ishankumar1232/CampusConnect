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

public class DepartmentController extends HttpServlet {

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


            // ADD DEPARTMENT
            if("add".equals(action)) {

                String departmentName =
                    req.getParameter("departmentName");


                // Generate Department ID
                String idSql =
                    "SELECT NVL(MAX(DEPARTMENT_ID),0)+1 " +
                    "FROM DEPARTMENT";

                ps = con.prepareStatement(idSql);

                rs = ps.executeQuery();

                int departmentId = 1;

                if(rs.next()) {
                    departmentId = rs.getInt(1);
                }

                rs.close();
                ps.close();


                // Insert Department
                String insertSql =
                    "INSERT INTO DEPARTMENT " +
                    "(DEPARTMENT_ID, COLLEGE_ID, DEPARTMENT_NAME) " +
                    "VALUES (?, ?, ?)";

                ps = con.prepareStatement(insertSql);

                ps.setInt(1, departmentId);
                ps.setInt(2, collegeId);
                ps.setString(3, departmentName);

                ps.executeUpdate();

                ps.close();

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

                ps = con.prepareStatement(deleteSql);

                ps.setInt(1, Integer.parseInt(departmentId));
                ps.setInt(2, collegeId);

                ps.executeUpdate();

                ps.close();

            }

            con.close();

            res.sendRedirect(
                req.getContextPath() +
                "/departmentManagement.jsp"
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