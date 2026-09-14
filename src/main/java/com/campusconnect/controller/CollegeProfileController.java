package com.campusconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CollegeProfileController extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        HttpSession session = req.getSession();

        Integer collegeId =
            (Integer) session.getAttribute("collegeId");

        if(collegeId == null) {

            res.sendRedirect("collegeAdminLogin.jsp");
            return;
        }

        String collegeName =
            req.getParameter("collegeName");

        String address =
            req.getParameter("address");

        String city =
            req.getParameter("city");

        String state =
            req.getParameter("state");

        String email =
            req.getParameter("email");

        String phone =
            req.getParameter("phone");


        Connection con = null;
        PreparedStatement ps = null;

        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );


            String sql =
                "UPDATE COLLEGE SET " +
                "COLLEGE_NAME=?, " +
                "ADDRESS=?, " +
                "CITY=?, " +
                "STATE=?, " +
                "EMAIL=?, " +
                "PHONE=? " +
                "WHERE COLLEGE_ID=?";


            ps = con.prepareStatement(sql);

            ps.setString(1, collegeName);
            ps.setString(2, address);
            ps.setString(3, city);
            ps.setString(4, state);
            ps.setString(5, email);
            ps.setString(6, phone);
            ps.setInt(7, collegeId);

            int result = ps.executeUpdate();


            if(result > 0) {

                res.sendRedirect(
                    req.getContextPath() +
                    "/collegeProfile.jsp"
                );

            } else {

                res.getWriter().println(
                    "<h2>Profile Update Failed</h2>"
                );
            }


        } catch(Exception e) {

            res.getWriter().println(
                "<h2>Error: " +
                e.getMessage() +
                "</h2>"
            );

        } finally {

            if(ps != null) {
                try {
                    ps.close();
                } catch(Exception e) {}
            }

            if(con != null) {
                try {
                    con.close();
                } catch(Exception e) {}
            }
        }
    }
}