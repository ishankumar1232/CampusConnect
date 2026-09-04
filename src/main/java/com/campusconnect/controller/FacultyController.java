package com.campusconnect.controller;

import com.campusconnect.bean.Faculty;
import com.campusconnect.dao.FacultyDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/FacultyController")
public class FacultyController extends HttpServlet {

    FacultyDAO dao = new FacultyDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action) || action == null) {
            listFaculty(req, resp);
        } else if ("edit".equals(action)) {
            editFaculty(req, resp);
        } else if ("delete".equals(action)) {
            deleteFaculty(req, resp);
        } else if ("showAdd".equals(action)) {
            req.getRequestDispatcher("jsp/college/addFaculty.jsp").forward(req, resp);
        	//req.getRequestDispatcher("/college/addFaculty.jsp").forward(req, resp);

        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addFaculty(req, resp);
        } else if ("update".equals(action)) {
            updateFaculty(req, resp);
        }
    }

    private void listFaculty(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Faculty> list = dao.getAllFaculty();
        req.setAttribute("facultyList", list);
        req.getRequestDispatcher("jsp/college/facultyList.jsp").forward(req, resp);
       // req.getRequestDispatcher("/college/facultyList.jsp").forward(req, resp);

    }

    private void addFaculty(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        Faculty faculty = new Faculty(collegeId, departmentId, name, email, phone);
        boolean result = dao.addFaculty(faculty);

        if (result) {
            resp.sendRedirect("FacultyController?action=list");
        } else {
            req.setAttribute("message", "Failed to add faculty!");
           req.getRequestDispatcher("jsp/college/addFaculty.jsp").forward(req, resp);
            //req.getRequestDispatcher("/college/addFaculty.jsp").forward(req, resp);

        }
    }

    private void editFaculty(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int facultyId = Integer.parseInt(req.getParameter("facultyId"));
        Faculty faculty = dao.getFacultyById(facultyId);
        req.setAttribute("faculty", faculty);
        req.getRequestDispatcher("jsp/college/editFaculty.jsp").forward(req, resp);
       // req.getRequestDispatcher("/college/editFaculty.jsp").forward(req, resp);

    }

    private void updateFaculty(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int facultyId = Integer.parseInt(req.getParameter("facultyId"));
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        Faculty faculty = new Faculty(collegeId, departmentId, name, email, phone);
        faculty.setFacultyId(facultyId);

        boolean result = dao.updateFaculty(faculty);

        if (result) {
            resp.sendRedirect("FacultyController?action=list");
        } else {
            req.setAttribute("message", "Failed to update faculty!");
            req.getRequestDispatcher("jsp/college/editFaculty.jsp").forward(req, resp);
            //req.getRequestDispatcher("/college/editFaculty.jsp").forward(req, resp);

        }
    }

    private void deleteFaculty(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int facultyId = Integer.parseInt(req.getParameter("facultyId"));
        boolean result = dao.deleteFaculty(facultyId);

        if (result) {
            resp.sendRedirect("FacultyController?action=list");
        } else {
            req.setAttribute("message", "Failed to delete faculty!");
            listFaculty(req, resp);
        }
    }
}