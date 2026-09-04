package com.campusconnect.controller;

import com.campusconnect.bean.College;
import com.campusconnect.bean.CollegeAdmin;
import com.campusconnect.dao.CollegeDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CollegeController")
public class CollegeController extends HttpServlet {

    CollegeDAO dao = new CollegeDAO();

    //====================================
    // HANDLE GET REQUESTS
    //====================================
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("viewProfile".equals(action)) {                    // ✅ NEW - View Own College Profile
            viewProfile(req, resp);
        } else if ("list".equals(action) || action == null) {
            listColleges(req, resp);
        } else if ("edit".equals(action)) {
            editCollege(req, resp);
        } else if ("delete".equals(action)) {
            deleteCollege(req, resp);
        } else if ("showAdd".equals(action)) {
            req.getRequestDispatcher("/jsp/college/addCollege.jsp").forward(req, resp);
        }
    }

    //====================================
    // HANDLE POST REQUESTS
    //====================================
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("updateProfile".equals(action)) {                  // ✅ NEW - Update Own College Profile
            updateProfile(req, resp);
        } else if ("add".equals(action)) {
            addCollege(req, resp);
        } else if ("update".equals(action)) {
            updateCollege(req, resp);
        }
    }

    //====================================
    // 1. VIEW OWN COLLEGE PROFILE (NEW)
    //====================================
    private void viewProfile(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        if (admin != null && admin.getCollegeId() > 0) {
            College college = dao.getCollegeById(admin.getCollegeId());
            req.setAttribute("college", college);
            req.getRequestDispatcher("/jsp/college/viewCollegeProfile.jsp").forward(req, resp);
        } else {
            req.setAttribute("message", "College profile not found. Please contact administration.");
            req.getRequestDispatcher("/jsp/college/viewCollegeProfile.jsp").forward(req, resp);
        }
    }

    //====================================
    // 2. UPDATE OWN COLLEGE PROFILE (NEW)
    //====================================
    private void updateProfile(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        if (admin != null && admin.getCollegeId() > 0) {
            int collegeId = admin.getCollegeId();
            String collegeName = req.getParameter("collegeName");
            String address = req.getParameter("address");
            String city = req.getParameter("city");
            String state = req.getParameter("state");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            
            College college = dao.getCollegeById(collegeId);
            if (college != null) {
                college.setCollegeName(collegeName);
                college.setAddress(address);
                college.setCity(city);
                college.setState(state);
                college.setEmail(email);
                college.setPhone(phone);
                
                boolean result = dao.updateCollege(college);
                
                if (result) {
                    req.setAttribute("message", "Profile Updated Successfully!");
                    req.setAttribute("college", college);
                    req.getRequestDispatcher("/jsp/college/viewCollegeProfile.jsp").forward(req, resp);
                } else {
                    req.setAttribute("message", "Failed to update profile!");
                    req.setAttribute("college", college);
                    req.getRequestDispatcher("/jsp/college/viewCollegeProfile.jsp").forward(req, resp);
                }
            }
        } else {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
        }
    }

    //====================================
    // 3. LIST ALL COLLEGES
    //====================================
    private void listColleges(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<College> list = dao.getAllColleges();
        req.setAttribute("collegeList", list);
        req.getRequestDispatcher("/jsp/college/collegeList.jsp").forward(req, resp);
    }

    //====================================
    // 4. ADD COLLEGE
    //====================================
    private void addCollege(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String collegeName = req.getParameter("collegeName");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");

        College college = new College(collegeName, address, city, state, email, phone, status);

        boolean result = dao.addCollege(college);

        if (result) {
            resp.sendRedirect("CollegeController?action=list");
        } else {
            req.setAttribute("message", "Failed to add college!");
            req.getRequestDispatcher("/jsp/college/addCollege.jsp").forward(req, resp);
        }
    }

    //====================================
    // 5. EDIT COLLEGE (Show Form)
    //====================================
    private void editCollege(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        College college = dao.getCollegeById(collegeId);

        req.setAttribute("college", college);
        req.getRequestDispatcher("/jsp/college/editCollege.jsp").forward(req, resp);
    }

    //====================================
    // 6. UPDATE COLLEGE
    //====================================
    private void updateCollege(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        String collegeName = req.getParameter("collegeName");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");

        College college = new College(collegeName, address, city, state, email, phone, status);
        college.setCollegeId(collegeId);

        boolean result = dao.updateCollege(college);

        if (result) {
            resp.sendRedirect("CollegeController?action=list");
        } else {
            req.setAttribute("message", "Failed to update college!");
            req.getRequestDispatcher("/jsp/college/editCollege.jsp").forward(req, resp);
        }
    }

    //====================================
    // 7. DELETE COLLEGE
    //====================================
    private void deleteCollege(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int collegeId = Integer.parseInt(req.getParameter("collegeId"));

        boolean result = dao.deleteCollege(collegeId);

        if (result) {
            resp.sendRedirect("CollegeController?action=list");
        } else {
            req.setAttribute("message", "Failed to delete college!");
            listColleges(req, resp);
        }
    }
}