package com.campusconnect.controller;

import com.campusconnect.bean.Department;
import com.campusconnect.dao.DepartmentDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DepartmentController")
public class DepartmentController extends HttpServlet {

    DepartmentDAO dao = new DepartmentDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action) || action == null) {
            listDepartments(req, resp);
        } else if ("edit".equals(action)) {
            editDepartment(req, resp);
        } else if ("delete".equals(action)) {
            deleteDepartment(req, resp);
        } else if ("showAdd".equals(action)) {
            req.getRequestDispatcher("jsp/college/addDepartment.jsp").forward(req, resp);
        	//req.getRequestDispatcher("/college/addDepartment.jsp").forward(req, resp);

        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addDepartment(req, resp);
        } else if ("update".equals(action)) {
            updateDepartment(req, resp);
        }
    }

    private void listDepartments(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Department> list = dao.getAllDepartments();
        req.setAttribute("departmentList", list);
        req.getRequestDispatcher("jsp/college/departmentList.jsp").forward(req, resp);
        //req.getRequestDispatcher("/college/departmentList.jsp").forward(req, resp);

    }

    private void addDepartment(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        String departmentName = req.getParameter("departmentName");

        Department dept = new Department(collegeId, departmentName);
        boolean result = dao.addDepartment(dept);

        if (result) {
            resp.sendRedirect("DepartmentController?action=list");
        } else {
            req.setAttribute("message", "Failed to add department!");
            req.getRequestDispatcher("jsp/college/addDepartment.jsp").forward(req, resp);
            //req.getRequestDispatcher("/college/addDepartment.jsp").forward(req, resp);

        }
    }

    private void editDepartment(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        Department dept = dao.getDepartmentById(departmentId);
        req.setAttribute("department", dept);
        req.getRequestDispatcher("jsp/college/editDepartment.jsp").forward(req, resp);
        //req.getRequestDispatcher("/college/editDepartment.jsp").forward(req, resp);

    }

    private void updateDepartment(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        String departmentName = req.getParameter("departmentName");

        Department dept = new Department(collegeId, departmentName);
        dept.setDepartmentId(departmentId);

        boolean result = dao.updateDepartment(dept);

        if (result) {
            resp.sendRedirect("DepartmentController?action=list");
        } else {
            req.setAttribute("message", "Failed to update department!");
            req.getRequestDispatcher("jsp/college/editDepartment.jsp").forward(req, resp);
            //`req.getRequestDispatcher("/college/editDepartment.jsp").forward(req, resp);

        }
    }

    private void deleteDepartment(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        boolean result = dao.deleteDepartment(departmentId);

        if (result) {
            resp.sendRedirect("DepartmentController?action=list");
        } else {
            req.setAttribute("message", "Failed to delete department!");
            listDepartments(req, resp);
        }
    }
}