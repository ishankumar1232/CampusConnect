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

public class CollegeDetailsServlet extends HttpServlet {

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
            res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet");
            return;
        }

        int collegeId;
        try {
            collegeId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet");
            return;
        }

        Map<String, String> college = new HashMap<>();
        Map<String, String> adminUser = new HashMap<>();
        ArrayList<Map<String, String>> departmentList = new ArrayList<>();
        ArrayList<Map<String, String>> courseList = new ArrayList<>();
        ArrayList<Map<String, String>> facultyList = new ArrayList<>();
        ArrayList<Map<String, String>> studentList = new ArrayList<>();
        ArrayList<Map<String, String>> driveList = new ArrayList<>();
        Map<String, Integer> counts = new HashMap<>();

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet");
                return;
            }

            // 1. College Basic Details
            String collegeSql = "SELECT COLLEGE_ID, COLLEGE_NAME, ADDRESS, CITY, STATE, EMAIL, PHONE, STATUS, LOGO_IMAGE, COVER_IMAGE FROM COLLEGE WHERE COLLEGE_ID = ?";
            try (PreparedStatement ps = con.prepareStatement(collegeSql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        college.put("collegeId", String.valueOf(rs.getInt("COLLEGE_ID")));
                        college.put("collegeName", rs.getString("COLLEGE_NAME"));
                        college.put("address", rs.getString("ADDRESS"));
                        college.put("city", rs.getString("CITY"));
                        college.put("state", rs.getString("STATE"));
                        college.put("email", rs.getString("EMAIL"));
                        college.put("phone", rs.getString("PHONE"));
                        college.put("status", rs.getString("STATUS"));
                        college.put("logoImage", rs.getString("LOGO_IMAGE"));
                        college.put("coverImage", rs.getString("COVER_IMAGE"));
                    } else {
                        res.sendRedirect(req.getContextPath() + "/CollegeManagementServlet");
                        return;
                    }
                }
            }

            // 2. College Admin Account
            String adminSql = "SELECT ADMIN_ID, NAME, EMAIL FROM COLLEGE_ADMIN WHERE COLLEGE_ID = ?";
            try (PreparedStatement ps = con.prepareStatement(adminSql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        adminUser.put("adminId", String.valueOf(rs.getInt("ADMIN_ID")));
                        adminUser.put("name", rs.getString("NAME"));
                        adminUser.put("email", rs.getString("EMAIL"));
                    }
                }
            }

            // 3. Departments
            String deptSql = "SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENT WHERE COLLEGE_ID = ? ORDER BY DEPARTMENT_NAME";
            try (PreparedStatement ps = con.prepareStatement(deptSql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> d = new HashMap<>();
                        d.put("deptId", String.valueOf(rs.getInt("DEPARTMENT_ID")));
                        d.put("deptName", rs.getString("DEPARTMENT_NAME"));
                        departmentList.add(d);
                    }
                }
            }

            // 4. Courses
            String courseSql = "SELECT c.COURSE_ID, c.COURSE_NAME, d.DEPARTMENT_NAME FROM COURSE c JOIN DEPARTMENT d ON c.DEPARTMENT_ID = d.DEPARTMENT_ID WHERE d.COLLEGE_ID = ? ORDER BY c.COURSE_NAME";
            try (PreparedStatement ps = con.prepareStatement(courseSql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> cr = new HashMap<>();
                        cr.put("courseId", String.valueOf(rs.getInt("COURSE_ID")));
                        cr.put("courseName", rs.getString("COURSE_NAME"));
                        cr.put("departmentName", rs.getString("DEPARTMENT_NAME"));
                        courseList.add(cr);
                    }
                }
            }

            // 5. Faculty
            String facultySql = "SELECT f.FACULTY_ID, f.NAME, f.EMAIL, f.PHONE, d.DEPARTMENT_NAME FROM FACULTY f LEFT JOIN DEPARTMENT d ON f.DEPARTMENT_ID = d.DEPARTMENT_ID WHERE f.COLLEGE_ID = ? ORDER BY f.NAME";
            try (PreparedStatement ps = con.prepareStatement(facultySql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> f = new HashMap<>();
                        f.put("facultyId", String.valueOf(rs.getInt("FACULTY_ID")));
                        f.put("facultyName", rs.getString("NAME"));
                        f.put("designation", "Faculty Member");
                        f.put("email", rs.getString("EMAIL"));
                        f.put("phone", rs.getString("PHONE"));
                        f.put("departmentName", rs.getString("DEPARTMENT_NAME"));
                        facultyList.add(f);
                    }
                }
            }

            // 6. Enrolled Students
            String studentSql = "SELECT s.STUDENT_ID, s.NAME, s.EMAIL, s.PHONE, s.STATUS, cr.COURSE_NAME FROM STUDENT s LEFT JOIN COURSE cr ON s.COURSE_ID = cr.COURSE_ID WHERE s.COLLEGE_ID = ? ORDER BY s.NAME";
            try (PreparedStatement ps = con.prepareStatement(studentSql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> st = new HashMap<>();
                        st.put("studentId", String.valueOf(rs.getInt("STUDENT_ID")));
                        st.put("name", rs.getString("NAME"));
                        st.put("email", rs.getString("EMAIL"));
                        st.put("phone", rs.getString("PHONE"));
                        st.put("status", rs.getString("STATUS"));
                        st.put("courseName", rs.getString("COURSE_NAME"));
                        studentList.add(st);
                    }
                }
            }

            // 7. Campus Drives associated with this college
            String driveSql = "SELECT d.DRIVE_ID, comp.COMPANY_NAME, d.JOB_TITLE, d.SALARY, TO_CHAR(d.DEADLINE, 'YYYY-MM-DD') AS DEADLINE, d.STATUS FROM RECRUITMENT_DRIVE d JOIN COMPANY comp ON d.COMPANY_ID = comp.COMPANY_ID JOIN DRIVE_COLLEGE dc ON d.DRIVE_ID = dc.DRIVE_ID WHERE dc.COLLEGE_ID = ? ORDER BY d.DRIVE_ID DESC";
            try (PreparedStatement ps = con.prepareStatement(driveSql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> dr = new HashMap<>();
                        dr.put("driveId", String.valueOf(rs.getInt("DRIVE_ID")));
                        dr.put("companyName", rs.getString("COMPANY_NAME"));
                        dr.put("jobTitle", rs.getString("JOB_TITLE"));
                        dr.put("salary", String.valueOf(rs.getInt("SALARY")));
                        dr.put("deadline", rs.getString("DEADLINE"));
                        dr.put("status", rs.getString("STATUS"));
                        driveList.add(dr);
                    }
                }
            }

            // 8. Total Placed Students from this college
            String placedSql = "SELECT COUNT(*) FROM STUDENT s JOIN APPLICATION a ON s.STUDENT_ID = a.STUDENT_ID JOIN SELECTION sel ON a.APPLICATION_ID = sel.APPLICATION_ID WHERE s.COLLEGE_ID = ? AND UPPER(sel.RESULT) = 'SELECTED'";
            int placedCount = 0;
            try (PreparedStatement ps = con.prepareStatement(placedSql)) {
                ps.setInt(1, collegeId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) placedCount = rs.getInt(1);
                }
            }

            counts.put("totalDepartments", departmentList.size());
            counts.put("totalCourses", courseList.size());
            counts.put("totalFaculty", facultyList.size());
            counts.put("totalStudents", studentList.size());
            counts.put("totalDrives", driveList.size());
            counts.put("placedStudents", placedCount);

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("college", college);
        req.setAttribute("adminUser", adminUser);
        req.setAttribute("departmentList", departmentList);
        req.setAttribute("courseList", courseList);
        req.setAttribute("facultyList", facultyList);
        req.setAttribute("studentList", studentList);
        req.setAttribute("driveList", driveList);
        req.setAttribute("counts", counts);

        req.getRequestDispatcher("/superadmin/collegeDetails.jsp").forward(req, res);
    }
}
