package com.campusconnect.controller;

import java.io.File;
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
import jakarta.servlet.http.Part;

public class CollegeProfileController extends HttpServlet
{
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException
    {
        HttpSession session = req.getSession(false);

        if(session == null || session.getAttribute("collegeId") == null)
        {
            res.sendRedirect("collegeAdminLogin.jsp");
            return;
        }

        int collegeId = (Integer) session.getAttribute("collegeId");

        String collegeName = req.getParameter("collegeName");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );

            con.setAutoCommit(false);

            // Get old image names
            String oldSql =
                "SELECT LOGO_IMAGE, COVER_IMAGE " +
                "FROM COLLEGE WHERE COLLEGE_ID=?";

            ps = con.prepareStatement(oldSql);
            ps.setInt(1, collegeId);

            rs = ps.executeQuery();

            String logoImage = "";
            String coverImage = "";

            if(rs.next())
            {
                logoImage = rs.getString("LOGO_IMAGE");
                coverImage = rs.getString("COVER_IMAGE");
            }

            rs.close();
            ps.close();


            // Create folder
            String uploadPath =
                getServletContext().getRealPath("/")
                + File.separator
                + "college_images";

            File uploadDir = new File(uploadPath);

            if(!uploadDir.exists())
            {
                uploadDir.mkdirs();
            }


            // Logo upload
            Part logoPart = req.getPart("logo");

            if(logoPart != null && logoPart.getSize() > 0)
            {
                String fileName = logoPart.getSubmittedFileName();

                String extension = ".jpg";

                if(fileName != null && fileName.lastIndexOf(".") >= 0)
                {
                    extension =
                        fileName.substring(
                            fileName.lastIndexOf(".")
                        ).toLowerCase();
                }

                logoImage =
                    "college_" + collegeId + "_logo" + extension;

                File logoFile =
                    new File(uploadDir, logoImage);

                logoPart.write(logoFile.getAbsolutePath());
            }


            // Cover upload
            Part coverPart = req.getPart("cover");

            if(coverPart != null && coverPart.getSize() > 0)
            {
                String fileName = coverPart.getSubmittedFileName();

                String extension = ".jpg";

                if(fileName != null && fileName.lastIndexOf(".") >= 0)
                {
                    extension =
                        fileName.substring(
                            fileName.lastIndexOf(".")
                        ).toLowerCase();
                }

                coverImage =
                    "college_" + collegeId + "_cover" + extension;

                File coverFile =
                    new File(uploadDir, coverImage);

                coverPart.write(coverFile.getAbsolutePath());
            }


            // Update database
            String updateSql =
                "UPDATE COLLEGE SET " +
                "COLLEGE_NAME=?, " +
                "ADDRESS=?, " +
                "CITY=?, " +
                "STATE=?, " +
                "EMAIL=?, " +
                "PHONE=?, " +
                "LOGO_IMAGE=?, " +
                "COVER_IMAGE=? " +
                "WHERE COLLEGE_ID=?";

            ps = con.prepareStatement(updateSql);

            ps.setString(1, collegeName);
            ps.setString(2, address);
            ps.setString(3, city);
            ps.setString(4, state);
            ps.setString(5, email);
            ps.setString(6, phone);
            ps.setString(7, logoImage);
            ps.setString(8, coverImage);
            ps.setInt(9, collegeId);

            ps.executeUpdate();

            con.commit();

            res.sendRedirect("collegeProfile.jsp?success=1");
        }
        catch(Exception e)
        {
            try
            {
                if(con != null)
                    con.rollback();
            }
            catch(Exception ex)
            {
            }

            res.setContentType("text/html");

            res.getWriter().println("<html>");
            res.getWriter().println("<body>");

            res.getWriter().println("<h2>College Profile Error</h2>");

            res.getWriter().println(
                "<p>" + e.getMessage() + "</p>"
            );

            res.getWriter().println(
                "<a href='collegeProfile.jsp'>Back</a>"
            );

            res.getWriter().println("</body>");
            res.getWriter().println("</html>");
        }
        finally
        {
            try
            {
                if(rs != null)
                    rs.close();

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();
            }
            catch(Exception e)
            {
            }
        }
    }
}