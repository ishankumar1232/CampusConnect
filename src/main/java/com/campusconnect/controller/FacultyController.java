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

public class FacultyController extends HttpServlet {

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


                // Generate Faculty ID
                String idSql =
                    "SELECT NVL(MAX(FACULTY_ID),0)+1 " +
                    "FROM FACULTY";

                ps = con.prepareStatement(idSql);

                rs = ps.executeQuery();

                int facultyId = 1;

                if(rs.next()) {
                    facultyId = rs.getInt(1);
                }

                rs.close();
                ps.close();


                // Insert Faculty
                String insertSql =
                    "INSERT INTO FACULTY " +
                    "(FACULTY_ID, COLLEGE_ID, DEPARTMENT_ID, " +
                    "NAME, EMAIL, PHONE) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

                ps = con.prepareStatement(insertSql);

                ps.setInt(1, facultyId);
                ps.setInt(2, collegeId);
                ps.setInt(3, Integer.parseInt(departmentId));
                ps.setString(4, name);
                ps.setString(5, email);
                ps.setString(6, phone);

                ps.executeUpdate();

                ps.close();

            }


            // DELETE FACULTY
            else if("delete".equals(action)) {

                String facultyId = req.getParameter("facultyId");


                // Delete only from logged-in college
                String deleteSql =
                    "DELETE FROM FACULTY " +
                    "WHERE FACULTY_ID=? " +
                    "AND COLLEGE_ID=?";

                ps = con.prepareStatement(deleteSql);

                ps.setInt(1, Integer.parseInt(facultyId));
                ps.setInt(2, collegeId);

                ps.executeUpdate();

                ps.close();

            }

            con.close();

            res.sendRedirect(
                req.getContextPath() +
                "/facultyManagement.jsp"
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