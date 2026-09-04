package com.campusconnect.controller;

import com.campusconnect.bean.Course;
import com.campusconnect.dao.CourseDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CourseController")
public class CourseController extends HttpServlet {

    CourseDAO dao = new CourseDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action) || action == null) {
            listCourses(req, resp);
        } else if ("edit".equals(action)) {
            editCourse(req, resp);
        } else if ("delete".equals(action)) {
            deleteCourse(req, resp);
        } else if ("showAdd".equals(action)) {
           req.getRequestDispatcher("jsp/college/addCourse.jsp").forward(req, resp);
        	//req.getRequestDispatcher("/college/addCourse.jsp").forward(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addCourse(req, resp);
        } else if ("update".equals(action)) {
            updateCourse(req, resp);
        }
    }

    private void listCourses(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Course> list = dao.getAllCourses();
        req.setAttribute("courseList", list);
        req.getRequestDispatcher("jsp/college/courseList.jsp").forward(req, resp);
       // req.getRequestDispatcher("/college/courseList.jsp").forward(req, resp);
    }

    private void addCourse(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        String courseName = req.getParameter("courseName");

        Course course = new Course(departmentId, courseName);
        boolean result = dao.addCourse(course);

        if (result) {
            resp.sendRedirect("CourseController?action=list");
        } else {
            req.setAttribute("message", "Failed to add course!");
           // req.getRequestDispatcher("jsp/college/addCourse.jsp").forward(req, resp);
            req.getRequestDispatcher("/college/addCollege.jsp").forward(req, resp);
        }
    }

    private void editCourse(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        Course course = dao.getCourseById(courseId);
        req.setAttribute("course", course);
       // req.getRequestDispatcher("jsp/college/editCourse.jsp").forward(req, resp);
        req.getRequestDispatcher("/college/editCourse.jsp").forward(req, resp);
    }

    private void updateCourse(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        String courseName = req.getParameter("courseName");

        Course course = new Course(departmentId, courseName);
        course.setCourseId(courseId);

        boolean result = dao.updateCourse(course);

        if (result) {
            resp.sendRedirect("CourseController?action=list");
        } else {
            req.setAttribute("message", "Failed to update course!");
            //req.getRequestDispatcher("jsp/college/editCourse.jsp").forward(req, resp);
            req.getRequestDispatcher("/college/editCourse.jsp").forward(req, resp);

        }
    }

    private void deleteCourse(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        boolean result = dao.deleteCourse(courseId);

        if (result) {
            resp.sendRedirect("CourseController?action=list");
        } else {
            req.setAttribute("message", "Failed to delete course!");
            listCourses(req, resp);
        }
    }
}