package com.campusconnect.controller;

import java.io.*;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.campusconnect.bean.Student;

 
public class StudentRegister extends HttpServlet
{
    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        String admissionId = req.getParameter("admissionId");

        String password = req.getParameter("password");
        String dob = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");

        Connection con = null;

        try
        {
            if(admissionId == null ||
               admissionId.trim().equals(""))
            {
                pw.println("<h2>Invalid Admission ID</h2>");
                return;
            }


            if(password == null ||
               password.trim().equals(""))
            {
                pw.println("<h2>Password is required</h2>");
                return;
            }


            if(dob == null ||
               dob.trim().equals(""))
            {
                pw.println("<h2>Date of Birth is required</h2>");
                return;
            }


            Class.forName(
                "oracle.jdbc.driver.OracleDriver"
            );


            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123"
            );


            con.setAutoCommit(false);


            /*
             * Get admission details
             */

            String admissionSql =
                "SELECT COLLEGE_ID, " +
                "APPLICANT_COURSE_ID, " +
                "APPLICANT_NAME, " +
                "APPLICANT_EMAIL, " +
                "APPLICANT_PHONE " +
                "FROM ADMISSION " +
                "WHERE ADMISSION_ID=? " +
                "AND STATUS='CONFIRMED' " +
                "AND STUDENT_ID IS NULL";


            PreparedStatement admissionPs =
                con.prepareStatement(admissionSql);


            admissionPs.setInt(
                1,
                Integer.parseInt(admissionId)
            );


            ResultSet rs =
                admissionPs.executeQuery();


            if(!rs.next())
            {
                rs.close();
                admissionPs.close();

                con.rollback();

                pw.println("<html>");
                pw.println("<body>");

                pw.println(
                    "<h2>Registration Not Available</h2>"
                );

                pw.println(
                    "<p>Admission is not confirmed or "
                    + "registration is already completed.</p>"
                );

                pw.println(
                    "<br>"
                    + "<a href='new_student_check_status.jsp'>"
                    + "Track Admission"
                    + "</a>"
                );

                pw.println("</body>");
                pw.println("</html>");

                return;
            }


            int collegeId =
                rs.getInt("COLLEGE_ID");


            int courseId =
                rs.getInt("APPLICANT_COURSE_ID");


            String name =
                rs.getString("APPLICANT_NAME");


            String email =
                rs.getString("APPLICANT_EMAIL");


            String phone =
                rs.getString("APPLICANT_PHONE");


            rs.close();
            admissionPs.close();


            /*
             * CHECK EMAIL
             *
             * One email can have only one
             * student account.
             */

            String emailCheckSql =
                "SELECT STUDENT_ID " +
                "FROM STUDENT " +
                "WHERE LOWER(EMAIL)=LOWER(?)";


            PreparedStatement emailPs =
                con.prepareStatement(emailCheckSql);


            emailPs.setString(
                1,
                email
            );


            ResultSet emailRs =
                emailPs.executeQuery();


            if(emailRs.next())
            {
                int existingStudentId =
                    emailRs.getInt("STUDENT_ID");


                emailRs.close();
                emailPs.close();

                con.rollback();


                pw.println("<html>");
                pw.println("<head>");
                pw.println(
                    "<title>Registration Failed</title>"
                );
                pw.println("</head>");

                pw.println("<body>");


                pw.println(
                    "<h2>Registration Failed</h2>"
                );


                pw.println(
                    "<p>"
                    + "An account already exists with this Email ID."
                    + "</p>"
                );


                pw.println(
                    "<p>"
                    + "Please use the existing Student Login."
                    + "</p>"
                );


                pw.println(
                    "<br>"
                    + "<a href='student_login.jsp'>"
                    + "Go to Student Login"
                    + "</a>"
                );


                pw.println("</body>");
                pw.println("</html>");


                return;
            }


            emailRs.close();
            emailPs.close();


            /*
             * Create Student object
             */

            Student s = new Student();


            s.setCollegeId(collegeId);

            s.setCourseId(courseId);

            s.setName(name);

            s.setEmail(email);

            s.setPhone(phone);

            s.setPassword(password);

            s.setDob(
                Date.valueOf(dob)
            );

            s.setGender(gender);

            s.setAddress(address);


            /*
             * Insert Student
             */

            int studentId =
                s.InsertNewStudent(con);


            /*
             * Link Student with Admission
             */

            String updateSql =
                "UPDATE ADMISSION " +
                "SET STUDENT_ID=? " +
                "WHERE ADMISSION_ID=? " +
                "AND STUDENT_ID IS NULL";


            PreparedStatement updatePs =
                con.prepareStatement(updateSql);


            updatePs.setInt(
                1,
                studentId
            );


            updatePs.setInt(
                2,
                Integer.parseInt(admissionId)
            );


            int updated =
                updatePs.executeUpdate();


            updatePs.close();


            if(updated == 0)
            {
                con.rollback();

                pw.println(
                    "<h2>Registration Failed</h2>"
                );

                pw.println(
                    "<p>Admission registration could not be completed.</p>"
                );

                return;
            }


            /*
             * Commit
             */

            con.commit();


            /*
             * Success
             */

            pw.println("<html>");

            pw.println("<head>");

            pw.println(
                "<title>Registration Successful</title>"
            );

            pw.println("</head>");


            pw.println("<body>");


            pw.println(
                "<h2>Student Registration Successful</h2>"
            );


            pw.println(
                "<p>Your Student ID is: "
                + "<b>"
                + studentId
                + "</b></p>"
            );


            pw.println(
                "<p>Email: "
                + "<b>"
                + email
                + "</b></p>"
            );


            pw.println(
                "<br>"
            );


            pw.println(
                "<a href='student_login.jsp'>"
                + "Go to Student Login"
                + "</a>"
            );


            pw.println("</body>");

            pw.println("</html>");
        }
        catch(Exception e)
        {
            try
            {
                if(con != null)
                {
                    con.rollback();
                }
            }
            catch(Exception ex)
            {
            }


            pw.println("<html>");

            pw.println("<body>");


            pw.println(
                "<h2>Registration Error</h2>"
            );


            pw.println(
                "<p>"
                + e.getMessage()
                + "</p>"
            );


            pw.println("</body>");

            pw.println("</html>");
        }
        finally
        {
            try
            {
                if(con != null)
                {
                    con.close();
                }
            }
            catch(Exception e)
            {
            }
        }
    }
}