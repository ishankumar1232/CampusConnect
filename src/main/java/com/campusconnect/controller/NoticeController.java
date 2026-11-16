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

public class NoticeController extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        if(req.getParameter("action") != null) {
            doPost(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/noticeManagement.jsp");
        }
    }

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

        try (Connection con = DBConnection.getConnection()) {

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

                int noticeId = 1;
                try (PreparedStatement psId = con.prepareStatement(idSql);
                     ResultSet rsId = psId.executeQuery()) {
                    if(rsId.next()) {
                        noticeId = rsId.getInt(1);
                    }
                }

                // Insert Notice
                String insertSql =
                    "INSERT INTO NOTICE " +
                    "(NOTICE_ID, COLLEGE_ID, TITLE, CONTENT, " +
                    "NOTICE_DATE, STATUS) " +
                    "VALUES (?, ?, ?, ?, SYSDATE, 'ACTIVE')";

                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setInt(1, noticeId);
                    psInsert.setInt(2, collegeId);
                    psInsert.setString(3, title);
                    psInsert.setString(4, content);
                    psInsert.executeUpdate();
                }

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

                try (PreparedStatement psDelete = con.prepareStatement(deleteSql)) {
                    psDelete.setInt(1, Integer.parseInt(noticeId));
                    psDelete.setInt(2, collegeId);
                    psDelete.executeUpdate();
                }

            }

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

        }
    }
}