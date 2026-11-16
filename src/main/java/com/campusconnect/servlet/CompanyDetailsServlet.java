package com.campusconnect.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.campusconnect.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CompanyDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ================= SESSION CHECK =================
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/superadmin/login.jsp");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/CompanyManagementServlet");
            return;
        }

        int companyId;
        try {
            companyId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/CompanyManagementServlet");
            return;
        }

        Map<String, String> company = new HashMap<>();
        ArrayList<Map<String, String>> driveList = new ArrayList<>();
        ArrayList<Map<String, String>> applicantList = new ArrayList<>();
        ArrayList<Map<String, String>> interviewList = new ArrayList<>();
        ArrayList<Map<String, String>> selectionList = new ArrayList<>();
        Map<String, Integer> counts = new HashMap<>();

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                res.sendRedirect(req.getContextPath() + "/CompanyManagementServlet");
                return;
            }

            // 1. Company Basic Details
            String compSql = "SELECT COMPANY_ID, COMPANY_NAME, EMAIL, PHONE, WEBSITE, ADDRESS, STATUS, LOGO, BANNER, DESCRIPTION FROM COMPANY WHERE COMPANY_ID = ?";
            try (PreparedStatement ps = con.prepareStatement(compSql)) {
                ps.setInt(1, companyId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        company.put("companyId", String.valueOf(rs.getInt("COMPANY_ID")));
                        company.put("companyName", rs.getString("COMPANY_NAME"));
                        company.put("email", rs.getString("EMAIL"));
                        company.put("phone", rs.getString("PHONE"));
                        company.put("website", rs.getString("WEBSITE"));
                        company.put("address", rs.getString("ADDRESS"));
                        company.put("status", rs.getString("STATUS"));
                        company.put("logo", rs.getString("LOGO"));
                        company.put("banner", rs.getString("BANNER"));
                        company.put("description", rs.getString("DESCRIPTION"));
                    } else {
                        res.sendRedirect(req.getContextPath() + "/CompanyManagementServlet");
                        return;
                    }
                }
            }

            // 2. Recruitment Drives
            String driveSql = "SELECT DRIVE_ID, JOB_TITLE, DRIVE_TYPE, SALARY, VACANCY, TO_CHAR(DEADLINE, 'YYYY-MM-DD') AS DEADLINE, STATUS FROM RECRUITMENT_DRIVE WHERE COMPANY_ID = ? ORDER BY DRIVE_ID DESC";
            int activeDrives = 0;
            try (PreparedStatement ps = con.prepareStatement(driveSql)) {
                ps.setInt(1, companyId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> d = new HashMap<>();
                        d.put("driveId", String.valueOf(rs.getInt("DRIVE_ID")));
                        d.put("jobTitle", rs.getString("JOB_TITLE"));
                        d.put("driveType", rs.getString("DRIVE_TYPE"));
                        d.put("salary", String.valueOf(rs.getInt("SALARY")));
                        d.put("vacancy", String.valueOf(rs.getInt("VACANCY")));
                        d.put("deadline", rs.getString("DEADLINE"));
                        String dStatus = rs.getString("STATUS");
                        d.put("status", dStatus);
                        if ("ACTIVE".equalsIgnoreCase(dStatus) || "OPEN".equalsIgnoreCase(dStatus)) {
                            activeDrives++;
                        }
                        driveList.add(d);
                    }
                }
            }

            // 3. Candidate Applications received by this company
            String appSql = "SELECT a.APPLICATION_ID, s.STUDENT_ID, s.NAME AS STUDENT_NAME, c.COLLEGE_NAME, d.JOB_TITLE, TO_CHAR(a.APPLIED_DATE, 'YYYY-MM-DD') AS APPLIED_DATE, a.STATUS " +
                            "FROM APPLICATION a " +
                            "JOIN RECRUITMENT_DRIVE d ON a.DRIVE_ID = d.DRIVE_ID " +
                            "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID " +
                            "LEFT JOIN COLLEGE c ON s.COLLEGE_ID = c.COLLEGE_ID " +
                            "WHERE d.COMPANY_ID = ? ORDER BY a.APPLICATION_ID DESC";
            try (PreparedStatement ps = con.prepareStatement(appSql)) {
                ps.setInt(1, companyId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> app = new HashMap<>();
                        app.put("applicationId", String.valueOf(rs.getInt("APPLICATION_ID")));
                        app.put("studentId", String.valueOf(rs.getInt("STUDENT_ID")));
                        app.put("studentName", rs.getString("STUDENT_NAME"));
                        app.put("collegeName", rs.getString("COLLEGE_NAME"));
                        app.put("jobTitle", rs.getString("JOB_TITLE"));
                        app.put("appliedDate", rs.getString("APPLIED_DATE"));
                        app.put("status", rs.getString("STATUS"));
                        applicantList.add(app);
                    }
                }
            }

            // 4. Interviews scheduled
            String intSql = "SELECT i.INTERVIEW_ID, s.NAME AS STUDENT_NAME, d.JOB_TITLE, i.ROUND_NAME, TO_CHAR(i.INTERVIEW_DATE, 'YYYY-MM-DD') AS INTERVIEW_DATE, i.INTERVIEW_MODE, i.RESULT, i.STATUS " +
                            "FROM INTERVIEW i " +
                            "JOIN APPLICATION a ON i.APPLICATION_ID = a.APPLICATION_ID " +
                            "JOIN RECRUITMENT_DRIVE d ON a.DRIVE_ID = d.DRIVE_ID " +
                            "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID " +
                            "WHERE d.COMPANY_ID = ? ORDER BY i.INTERVIEW_ID DESC";
            try (PreparedStatement ps = con.prepareStatement(intSql)) {
                ps.setInt(1, companyId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> iv = new HashMap<>();
                        iv.put("interviewId", String.valueOf(rs.getInt("INTERVIEW_ID")));
                        iv.put("studentName", rs.getString("STUDENT_NAME"));
                        iv.put("jobTitle", rs.getString("JOB_TITLE"));
                        iv.put("roundName", rs.getString("ROUND_NAME"));
                        iv.put("interviewDate", rs.getString("INTERVIEW_DATE"));
                        iv.put("mode", rs.getString("INTERVIEW_MODE"));
                        iv.put("result", rs.getString("RESULT"));
                        iv.put("status", rs.getString("STATUS"));
                        interviewList.add(iv);
                    }
                }
            }

            // 5. Selections & Offers generated
            String selSql = "SELECT s.NAME AS STUDENT_NAME, c.COLLEGE_NAME, d.JOB_TITLE, o.DESIGNATION, o.ANNUAL_CTC, TO_CHAR(o.OFFER_DATE, 'YYYY-MM-DD') AS OFFER_DATE, o.OFFER_STATUS " +
                            "FROM OFFER o " +
                            "JOIN APPLICATION a ON o.APPLICATION_ID = a.APPLICATION_ID " +
                            "JOIN RECRUITMENT_DRIVE d ON a.DRIVE_ID = d.DRIVE_ID " +
                            "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID " +
                            "LEFT JOIN COLLEGE c ON s.COLLEGE_ID = c.COLLEGE_ID " +
                            "WHERE o.COMPANY_ID = ? ORDER BY o.OFFER_ID DESC";
            try (PreparedStatement ps = con.prepareStatement(selSql)) {
                ps.setInt(1, companyId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> sel = new HashMap<>();
                        sel.put("studentName", rs.getString("STUDENT_NAME"));
                        sel.put("collegeName", rs.getString("COLLEGE_NAME"));
                        sel.put("jobTitle", rs.getString("JOB_TITLE"));
                        sel.put("designation", rs.getString("DESIGNATION"));
                        sel.put("ctc", String.valueOf(rs.getInt("ANNUAL_CTC")));
                        sel.put("offerDate", rs.getString("OFFER_DATE"));
                        sel.put("status", rs.getString("OFFER_STATUS"));
                        selectionList.add(sel);
                    }
                }
            }

            counts.put("totalDrives", driveList.size());
            counts.put("activeDrives", activeDrives);
            counts.put("totalApplicants", applicantList.size());
            counts.put("totalInterviews", interviewList.size());
            counts.put("totalSelections", selectionList.size());

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("company", company);
        req.setAttribute("driveList", driveList);
        req.setAttribute("applicantList", applicantList);
        req.setAttribute("interviewList", interviewList);
        req.setAttribute("selectionList", selectionList);
        req.setAttribute("counts", counts);

        req.getRequestDispatcher("/superadmin/companyDetails.jsp").forward(req, res);
    }
}
