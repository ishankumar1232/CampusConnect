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

public class DriveDetailsServlet extends HttpServlet {

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
            res.sendRedirect(req.getContextPath() + "/MonitorRecruitmentServlet");
            return;
        }

        int driveId;
        try {
            driveId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/MonitorRecruitmentServlet");
            return;
        }

        Map<String, String> drive = new HashMap<>();
        ArrayList<Map<String, String>> collegeList = new ArrayList<>();
        ArrayList<Map<String, String>> applicantList = new ArrayList<>();
        ArrayList<Map<String, String>> interviewList = new ArrayList<>();
        ArrayList<Map<String, String>> selectionList = new ArrayList<>();
        Map<String, Integer> counts = new HashMap<>();

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                res.sendRedirect(req.getContextPath() + "/MonitorRecruitmentServlet");
                return;
            }

            // 1. Drive Details
            String driveSql = "SELECT d.DRIVE_ID, d.COMPANY_ID, comp.COMPANY_NAME, d.JOB_TITLE, d.DRIVE_TYPE, d.SALARY, d.VACANCY, " +
                              "d.ELIGIBILITY_CGPA, d.REQUIRED_BRANCH, d.REQUIRED_SKILLS, TO_CHAR(d.DEADLINE, 'YYYY-MM-DD') AS DEADLINE, d.STATUS, d.DESCRIPTION " +
                              "FROM RECRUITMENT_DRIVE d JOIN COMPANY comp ON d.COMPANY_ID = comp.COMPANY_ID WHERE d.DRIVE_ID = ?";
            try (PreparedStatement ps = con.prepareStatement(driveSql)) {
                ps.setInt(1, driveId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        drive.put("driveId", String.valueOf(rs.getInt("DRIVE_ID")));
                        drive.put("companyId", String.valueOf(rs.getInt("COMPANY_ID")));
                        drive.put("companyName", rs.getString("COMPANY_NAME"));
                        drive.put("jobTitle", rs.getString("JOB_TITLE"));
                        drive.put("driveType", rs.getString("DRIVE_TYPE"));
                        drive.put("salary", String.valueOf(rs.getInt("SALARY")));
                        drive.put("vacancy", String.valueOf(rs.getInt("VACANCY")));
                        drive.put("cgpa", String.valueOf(rs.getDouble("ELIGIBILITY_CGPA")));
                        drive.put("branch", rs.getString("REQUIRED_BRANCH"));
                        drive.put("skills", rs.getString("REQUIRED_SKILLS"));
                        drive.put("deadline", rs.getString("DEADLINE"));
                        drive.put("status", rs.getString("STATUS"));
                        drive.put("description", rs.getString("DESCRIPTION"));
                    } else {
                        res.sendRedirect(req.getContextPath() + "/MonitorRecruitmentServlet");
                        return;
                    }
                }
            }

            // 2. Participating Colleges
            String colSql = "SELECT c.COLLEGE_ID, c.COLLEGE_NAME, c.CITY, c.STATE FROM DRIVE_COLLEGE dc JOIN COLLEGE c ON dc.COLLEGE_ID = c.COLLEGE_ID WHERE dc.DRIVE_ID = ? ORDER BY c.COLLEGE_NAME";
            try (PreparedStatement ps = con.prepareStatement(colSql)) {
                ps.setInt(1, driveId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> c = new HashMap<>();
                        c.put("collegeId", String.valueOf(rs.getInt("COLLEGE_ID")));
                        c.put("collegeName", rs.getString("COLLEGE_NAME"));
                        c.put("city", rs.getString("CITY"));
                        c.put("state", rs.getString("STATE"));
                        collegeList.add(c);
                    }
                }
            }

            // 3. Registered Candidates / Applications
            String appSql = "SELECT a.APPLICATION_ID, s.STUDENT_ID, s.NAME AS STUDENT_NAME, c.COLLEGE_NAME, TO_CHAR(a.APPLIED_DATE, 'YYYY-MM-DD') AS APPLIED_DATE, a.STATUS " +
                            "FROM APPLICATION a " +
                            "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID " +
                            "LEFT JOIN COLLEGE c ON s.COLLEGE_ID = c.COLLEGE_ID " +
                            "WHERE a.DRIVE_ID = ? ORDER BY a.APPLICATION_ID DESC";
            try (PreparedStatement ps = con.prepareStatement(appSql)) {
                ps.setInt(1, driveId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> a = new HashMap<>();
                        a.put("applicationId", String.valueOf(rs.getInt("APPLICATION_ID")));
                        a.put("studentId", String.valueOf(rs.getInt("STUDENT_ID")));
                        a.put("studentName", rs.getString("STUDENT_NAME"));
                        a.put("collegeName", rs.getString("COLLEGE_NAME"));
                        a.put("appliedDate", rs.getString("APPLIED_DATE"));
                        a.put("status", rs.getString("STATUS"));
                        applicantList.add(a);
                    }
                }
            }

            // 4. Interviews
            String intSql = "SELECT i.INTERVIEW_ID, s.NAME AS STUDENT_NAME, i.ROUND_NAME, TO_CHAR(i.INTERVIEW_DATE, 'YYYY-MM-DD') AS INTERVIEW_DATE, i.INTERVIEW_MODE, i.RESULT, i.STATUS " +
                            "FROM INTERVIEW i " +
                            "JOIN APPLICATION a ON i.APPLICATION_ID = a.APPLICATION_ID " +
                            "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID " +
                            "WHERE a.DRIVE_ID = ? ORDER BY i.INTERVIEW_ID DESC";
            try (PreparedStatement ps = con.prepareStatement(intSql)) {
                ps.setInt(1, driveId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> iv = new HashMap<>();
                        iv.put("interviewId", String.valueOf(rs.getInt("INTERVIEW_ID")));
                        iv.put("studentName", rs.getString("STUDENT_NAME"));
                        iv.put("roundName", rs.getString("ROUND_NAME"));
                        iv.put("interviewDate", rs.getString("INTERVIEW_DATE"));
                        iv.put("mode", rs.getString("INTERVIEW_MODE"));
                        iv.put("result", rs.getString("RESULT"));
                        iv.put("status", rs.getString("STATUS"));
                        interviewList.add(iv);
                    }
                }
            }

            // 5. Selected Candidates
            String selSql = "SELECT s.NAME AS STUDENT_NAME, c.COLLEGE_NAME, sel.RESULT, TO_CHAR(sel.SELECTION_DATE, 'YYYY-MM-DD') AS SELECTION_DATE " +
                            "FROM SELECTION sel " +
                            "JOIN APPLICATION a ON sel.APPLICATION_ID = a.APPLICATION_ID " +
                            "JOIN STUDENT s ON a.STUDENT_ID = s.STUDENT_ID " +
                            "LEFT JOIN COLLEGE c ON s.COLLEGE_ID = c.COLLEGE_ID " +
                            "WHERE a.DRIVE_ID = ? ORDER BY sel.SELECTION_ID DESC";
            try (PreparedStatement ps = con.prepareStatement(selSql)) {
                ps.setInt(1, driveId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> s = new HashMap<>();
                        s.put("studentName", rs.getString("STUDENT_NAME"));
                        s.put("collegeName", rs.getString("COLLEGE_NAME"));
                        s.put("result", rs.getString("RESULT"));
                        s.put("selectionDate", rs.getString("SELECTION_DATE"));
                        selectionList.add(s);
                    }
                }
            }

            counts.put("totalApplicants", applicantList.size());
            counts.put("totalColleges", collegeList.size());
            counts.put("totalInterviews", interviewList.size());
            counts.put("totalSelections", selectionList.size());

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("drive", drive);
        req.setAttribute("collegeList", collegeList);
        req.setAttribute("applicantList", applicantList);
        req.setAttribute("interviewList", interviewList);
        req.setAttribute("selectionList", selectionList);
        req.setAttribute("counts", counts);

        req.getRequestDispatcher("/superadmin/driveDetails.jsp").forward(req, res);
    }
}
