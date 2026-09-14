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

public class SelectionController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        Integer collegeId = (Integer) session.getAttribute("collegeId");

        if(collegeId == null) {
            res.sendRedirect("collegeAdminLogin.jsp");
            return;
        }

        String applicationId = req.getParameter("applicationId");
        String result = req.getParameter("result");
        String remarks = req.getParameter("remarks");

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

            // Check application belongs to this college
            String checkSql =
                "SELECT A.APPLICATION_ID " +
                "FROM APPLICATION A " +
                "JOIN STUDENT S " +
                "ON A.STUDENT_ID = S.STUDENT_ID " +
                "JOIN INTERVIEW I " +
                "ON A.APPLICATION_ID = I.APPLICATION_ID " +
                "WHERE A.APPLICATION_ID = ? " +
                "AND S.COLLEGE_ID = ? " +
                "AND I.STATUS = 'COMPLETED'";

            ps = con.prepareStatement(checkSql);

            ps.setInt(1, Integer.parseInt(applicationId));
            ps.setInt(2, collegeId);

            rs = ps.executeQuery();

            if(!rs.next()) {

                res.getWriter().println(
                    "<h2>Invalid application</h2>"
                );

                return;
            }

            rs.close();
            ps.close();


            // Check if selection already exists
            String checkSelection =
                "SELECT SELECTION_ID " +
                "FROM SELECTION " +
                "WHERE APPLICATION_ID = ?";

            ps = con.prepareStatement(checkSelection);

            ps.setInt(1, Integer.parseInt(applicationId));

            rs = ps.executeQuery();

            if(rs.next()) {

                int selectionId = rs.getInt("SELECTION_ID");

                rs.close();
                ps.close();

                // Update existing selection
                String updateSql =
                    "UPDATE SELECTION " +
                    "SET RESULT = ?, " +
                    "REMARKS = ?, " +
                    "SELECTION_DATE = SYSDATE " +
                    "WHERE SELECTION_ID = ?";

                ps = con.prepareStatement(updateSql);

                ps.setString(1, result);
                ps.setString(2, remarks);
                ps.setInt(3, selectionId);

                ps.executeUpdate();

            } else {

                rs.close();
                ps.close();

                // Generate new Selection ID
                String idSql =
                    "SELECT NVL(MAX(SELECTION_ID),0)+1 " +
                    "FROM SELECTION";

                ps = con.prepareStatement(idSql);

                rs = ps.executeQuery();

                int selectionId = 1;

                if(rs.next()) {
                    selectionId = rs.getInt(1);
                }

                rs.close();
                ps.close();


                // Insert selection
                String insertSql =
                    "INSERT INTO SELECTION " +
                    "(SELECTION_ID, APPLICATION_ID, RESULT, " +
                    "SELECTION_DATE, REMARKS) " +
                    "VALUES (?, ?, ?, SYSDATE, ?)";

                ps = con.prepareStatement(insertSql);

                ps.setInt(1, selectionId);
                ps.setInt(2, Integer.parseInt(applicationId));
                ps.setString(3, result);
                ps.setString(4, remarks);

                ps.executeUpdate();

            }

            ps.close();

            res.sendRedirect(
                req.getContextPath() +
                "/selectionManagement.jsp"
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