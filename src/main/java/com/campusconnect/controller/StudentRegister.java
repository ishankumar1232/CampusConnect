package com.campusconnect.controller;

import java.io.*;
import java.sql.*;
import java.net.URLEncoder;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import com.campusconnect.bean.Student;
import com.campusconnect.dao.SystemSettingDAO;
import com.campusconnect.bean.SystemSetting;
import com.campusconnect.util.DBConnection;

public class StudentRegister extends HttpServlet
{
    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        res.sendRedirect(req.getContextPath() + "/student_register_status.jsp");
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException
    {
        String admissionId = req.getParameter("admissionId");
        String email = req.getParameter("email");

        // 1. Check if email already registered
        if (email != null && !email.trim().isEmpty()) {
            try (Connection checkCon = DBConnection.getConnection();
                 PreparedStatement checkPs = checkCon.prepareStatement("SELECT 1 FROM STUDENT WHERE LOWER(EMAIL) = LOWER(?)")) {
                checkPs.setString(1, email.trim());
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next()) {
                        req.setAttribute("status", "already_exists");
                        req.setAttribute("email", email.trim());
                        req.setAttribute("message", "An active student account already exists with this Email ID.");
                        req.getRequestDispatcher("student_register_status.jsp").forward(req, res);
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String password = req.getParameter("password");
        String dob = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");

        // 2. Check System Settings
        try (Connection settingCon = DBConnection.getConnection();
             PreparedStatement psSetting = settingCon.prepareStatement("SELECT STUDENT_REGISTRATION FROM SYSTEM_SETTINGS WHERE SETTING_ID=1");
             ResultSet rsSetting = psSetting.executeQuery()) {

            if (rsSetting.next() && "OFF".equalsIgnoreCase(rsSetting.getString("STUDENT_REGISTRATION"))) {
                req.setAttribute("status", "disabled");
                req.setAttribute("message", "Student Registration is currently disabled by Super Admin.");
                req.getRequestDispatcher("student_register_status.jsp").forward(req, res);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. Validate Inputs
        if (admissionId == null || admissionId.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            dob == null || dob.trim().isEmpty()) {

            req.setAttribute("status", "invalid");
            req.setAttribute("message", "Please fill in all mandatory fields (Password, Date of Birth, Address).");
            req.getRequestDispatcher("student_register_status.jsp").forward(req, res);
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 4. Retrieve Admission details
            String admissionSql =
                "SELECT A.COLLEGE_ID, " +
                "A.APPLICANT_COURSE_ID, " +
                "A.APPLICANT_NAME, " +
                "A.APPLICANT_EMAIL, " +
                "A.APPLICANT_PHONE, " +
                "C.COLLEGE_NAME, " +
                "CR.COURSE_NAME " +
                "FROM ADMISSION A " +
                "LEFT JOIN COLLEGE C ON A.COLLEGE_ID = C.COLLEGE_ID " +
                "LEFT JOIN COURSE CR ON A.APPLICANT_COURSE_ID = CR.COURSE_ID " +
                "WHERE A.ADMISSION_ID=? " +
                "AND A.STATUS='CONFIRMED' " +
                "AND A.STUDENT_ID IS NULL";

            PreparedStatement admissionPs = con.prepareStatement(admissionSql);
            admissionPs.setInt(1, Integer.parseInt(admissionId.trim()));

            ResultSet rs = admissionPs.executeQuery();

            if (!rs.next()) {
                rs.close();
                admissionPs.close();
                con.rollback();

                req.setAttribute("status", "not_available");
                req.setAttribute("admissionId", admissionId);
                req.setAttribute("message", "Admission is not confirmed or registration is already completed.");
                req.getRequestDispatcher("student_register_status.jsp").forward(req, res);
                return;
            }

            int collegeId = rs.getInt("COLLEGE_ID");
            int courseId = rs.getInt("APPLICANT_COURSE_ID");
            String name = rs.getString("APPLICANT_NAME");
            email = rs.getString("APPLICANT_EMAIL");
            String phone = rs.getString("APPLICANT_PHONE");
            String collegeName = rs.getString("COLLEGE_NAME");
            String courseName = rs.getString("COURSE_NAME");

            rs.close();
            admissionPs.close();

            // 5. Secondary check for email collision
            String emailCheckSql = "SELECT STUDENT_ID FROM STUDENT WHERE LOWER(EMAIL)=LOWER(?)";
            PreparedStatement emailPs = con.prepareStatement(emailCheckSql);
            emailPs.setString(1, email);
            ResultSet emailRs = emailPs.executeQuery();

            if (emailRs.next()) {
                emailRs.close();
                emailPs.close();
                con.rollback();

                req.setAttribute("status", "already_exists");
                req.setAttribute("email", email);
                req.setAttribute("message", "An account already exists with this Email ID (" + email + ").");
                req.getRequestDispatcher("student_register_status.jsp").forward(req, res);
                return;
            }
            emailRs.close();
            emailPs.close();

            // 6. Create Student Record
            Student s = new Student();
            s.setCollegeId(collegeId);
            s.setCourseId(courseId);
            s.setName(name);
            s.setEmail(email);
            s.setPhone(phone);
            s.setPassword(password);
            s.setDob(Date.valueOf(dob));
            s.setGender(gender != null ? gender : "Male");
            s.setAddress(address != null ? address : "");

            int studentId = s.InsertNewStudent(con);

            // 7. Link Admission to Student
            String updateSql =
                "UPDATE ADMISSION " +
                "SET STUDENT_ID=? " +
                "WHERE ADMISSION_ID=? " +
                "AND STUDENT_ID IS NULL";

            PreparedStatement updatePs = con.prepareStatement(updateSql);
            updatePs.setInt(1, studentId);
            updatePs.setInt(2, Integer.parseInt(admissionId.trim()));

            int updated = updatePs.executeUpdate();
            updatePs.close();

            if (updated == 0) {
                con.rollback();
                req.setAttribute("status", "error");
                req.setAttribute("message", "Admission registration could not be completed.");
                req.getRequestDispatcher("student_register_status.jsp").forward(req, res);
                return;
            }

            // Commit transaction
            con.commit();

            // 8. Forward to Registration Success Page
            req.setAttribute("status", "success");
            req.setAttribute("studentId", studentId);
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.setAttribute("collegeName", collegeName);
            req.setAttribute("courseName", courseName);
            req.setAttribute("admissionId", admissionId);

            req.getRequestDispatcher("student_register_status.jsp").forward(req, res);

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ignore) {}

            e.printStackTrace();
            req.setAttribute("status", "error");
            req.setAttribute("message", "Registration Error: " + (e.getMessage() != null ? e.getMessage() : e.toString()));
            req.getRequestDispatcher("student_register_status.jsp").forward(req, res);
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception ignore) {}
        }
    }
}
