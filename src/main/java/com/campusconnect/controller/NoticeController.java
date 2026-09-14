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

public class NoticeController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        Integer collegeId =
            (Integer) session.getAttribute("collegeId");

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


            // ADD NOTICE
            if("add".equals(action)) {

                String title =
                    req.getParameter("title");

                String content =
                    req.getParameter("content");


                // Generate Notice ID
                String idSql =
                    "SELECT NVL(MAX(NOTICE_ID),0)+1 " +
                    "FROM NOTICE";

                ps = con.prepareStatement(idSql);

                rs = ps.executeQuery();

                int noticeId = 1;

                if(rs.next()) {
                    noticeId = rs.getInt(1);
                }

                rs.close();
                ps.close();


                // Insert Notice
                String insertSql =
                    "INSERT INTO NOTICE " +
                    "(NOTICE_ID, COLLEGE_ID, TITLE, CONTENT, " +
                    "NOTICE_DATE, STATUS) " +
                    "VALUES (?, ?, ?, ?, SYSDATE, 'ACTIVE')";

                ps = con.prepareStatement(insertSql);

                ps.setInt(1, noticeId);
                ps.setInt(2, collegeId);
                ps.setString(3, title);
                ps.setString(4, content);

                ps.executeUpdate();

                ps.close();

            }


            // DELETE NOTICE
            else if("delete".equals(action)) {

                String noticeId =
                    req.getParameter("noticeId");


                // Delete only from logged-in college
                String deleteSql =
                    "DELETE FROM NOTICE " +
                    "WHERE NOTICE_ID=? " +
                    "AND COLLEGE_ID=?";

                ps = con.prepareStatement(deleteSql);

                ps.setInt(1, Integer.parseInt(noticeId));
                ps.setInt(2, collegeId);

                ps.executeUpdate();

                ps.close();

            }

            con.close();

            res.sendRedirect(
                req.getContextPath() +
                "/noticeManagement.jsp"
            );

        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " +
                e.getMessage() +
                "</h2>"
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