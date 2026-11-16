package com.campusconnect.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.campusconnect.bean.Student;
import com.campusconnect.dao.StudentDAO;
import com.campusconnect.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class StudentDetailsServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException, ServletException {

        // ================= SESSION CHECK =================
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/superadmin/login.jsp");
            return;
        }

        // ================= GET STUDENT ID =================
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/StudentManagementServlet");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/StudentManagementServlet");
            return;
        }

        // ================= GET STUDENT DETAILS =================
        StudentDAO dao = new StudentDAO();
        Student s = dao.getStudentById(id);

        if (s == null) {
            res.sendRedirect(req.getContextPath() + "/StudentManagementServlet");
            return;
        }

        req.setAttribute("student", s);

        // ================= FETCH ACADEMIC, SKILLS, PROJECTS, RESUME, APPLICATIONS, OFFERS =================
        ArrayList<Map<String, String>> academicList = new ArrayList<>();
        ArrayList<String> skillList = new ArrayList<>();
        ArrayList<Map<String, String>> projectList = new ArrayList<>();
        Map<String, String> resume = new HashMap<>();
        ArrayList<Map<String, String>> applicationList = new ArrayList<>();
        ArrayList<Map<String, String>> offerList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            if (con != null) {
                // 1. Academic records
                String acadSql = "SELECT QUALIFICATION, YEAR, PERCENTAGE, CGPA, BACKLOGS FROM STUDENT_ACADEMIC WHERE STUDENT_ID = ? ORDER BY ACADEMIC_ID";
                try (PreparedStatement ps = con.prepareStatement(acadSql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> acad = new HashMap<>();
                            acad.put("qualification", rs.getString("QUALIFICATION"));
                            acad.put("year", String.valueOf(rs.getInt("YEAR")));
                            acad.put("percentage", String.valueOf(rs.getDouble("PERCENTAGE")));
                            acad.put("cgpa", String.valueOf(rs.getDouble("CGPA")));
                            acad.put("backlogs", String.valueOf(rs.getInt("BACKLOGS")));
                            academicList.add(acad);
                        }
                    }
                }

                // 2. Technical Skills
                String skillSql = "SELECT SKILL_NAME FROM STUDENT_SKILL WHERE STUDENT_ID = ? ORDER BY SKILL_NAME";
                try (PreparedStatement ps = con.prepareStatement(skillSql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            skillList.add(rs.getString("SKILL_NAME"));
                        }
                    }
                }

                // 3. Projects
                String projSql = "SELECT PROJECT_NAME, DESCRIPTION, TECHNOLOGIES, PROJECT_URL FROM STUDENT_PROJECT WHERE STUDENT_ID = ? ORDER BY PROJECT_ID DESC";
                try (PreparedStatement ps = con.prepareStatement(projSql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> pr = new HashMap<>();
                            pr.put("name", rs.getString("PROJECT_NAME"));
                            pr.put("description", rs.getString("DESCRIPTION"));
                            pr.put("technologies", rs.getString("TECHNOLOGIES"));
                            pr.put("url", rs.getString("PROJECT_URL"));
                            projectList.add(pr);
                        }
                    }
                }

                // 4. Resume
                String resSql = "SELECT RESUME_ID, FILE_NAME, FILE_PATH FROM RESUME WHERE STUDENT_ID = ? ORDER BY RESUME_ID DESC";
                try (PreparedStatement ps = con.prepareStatement(resSql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            resume.put("resumeId", String.valueOf(rs.getInt("RESUME_ID")));
                            resume.put("fileName", rs.getString("FILE_NAME"));
                            resume.put("filePath", rs.getString("FILE_PATH"));
                        }
                    }
                }

                // 5. Applied Drives
                String appSql = "SELECT a.APPLICATION_ID, d.JOB_TITLE, c.COMPANY_NAME, d.SALARY, TO_CHAR(a.APPLIED_DATE, 'YYYY-MM-DD') AS APPLIED_DATE, a.STATUS " +
                                "FROM APPLICATION a " +
                                "JOIN RECRUITMENT_DRIVE d ON a.DRIVE_ID = d.DRIVE_ID " +
                                "JOIN COMPANY c ON d.COMPANY_ID = c.COMPANY_ID " +
                                "WHERE a.STUDENT_ID = ? ORDER BY a.APPLICATION_ID DESC";
                try (PreparedStatement ps = con.prepareStatement(appSql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> ap = new HashMap<>();
                            ap.put("applicationId", String.valueOf(rs.getInt("APPLICATION_ID")));
                            ap.put("jobTitle", rs.getString("JOB_TITLE"));
                            ap.put("companyName", rs.getString("COMPANY_NAME"));
                            ap.put("salary", String.valueOf(rs.getInt("SALARY")));
                            ap.put("appliedDate", rs.getString("APPLIED_DATE"));
                            ap.put("status", rs.getString("STATUS"));
                            applicationList.add(ap);
                        }
                    }
                }

                // 6. Placements & Offers
                String offSql = "SELECT c.COMPANY_NAME, o.DESIGNATION, o.ANNUAL_CTC, TO_CHAR(o.OFFER_DATE, 'YYYY-MM-DD') AS OFFER_DATE, o.OFFER_STATUS " +
                                "FROM OFFER o " +
                                "JOIN APPLICATION a ON o.APPLICATION_ID = a.APPLICATION_ID " +
                                "JOIN COMPANY c ON o.COMPANY_ID = c.COMPANY_ID " +
                                "WHERE a.STUDENT_ID = ? ORDER BY o.OFFER_ID DESC";
                try (PreparedStatement ps = con.prepareStatement(offSql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> off = new HashMap<>();
                            off.put("companyName", rs.getString("COMPANY_NAME"));
                            off.put("designation", rs.getString("DESIGNATION"));
                            off.put("ctc", String.valueOf(rs.getInt("ANNUAL_CTC")));
                            off.put("offerDate", rs.getString("OFFER_DATE"));
                            off.put("status", rs.getString("OFFER_STATUS"));
                            offerList.add(off);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("academicList", academicList);
        req.setAttribute("skillList", skillList);
        req.setAttribute("projectList", projectList);
        req.setAttribute("resume", resume);
        req.setAttribute("applicationList", applicationList);
        req.setAttribute("offerList", offerList);

        // ================= FORWARD =================
        req.getRequestDispatcher("/superadmin/studentDetails.jsp")
                .forward(req, res);
    }
}
