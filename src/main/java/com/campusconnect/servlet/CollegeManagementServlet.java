package com.campusconnect.servlet;

import java.io.IOException;
import java.util.ArrayList;

import com.campusconnect.bean.College;
import com.campusconnect.dao.CollegeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CollegeManagementServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ================= SESSION CHECK =================

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            response.sendRedirect(request.getContextPath()
                    + "/superadmin/login.jsp");
            return;
        }

        CollegeDAO dao = new CollegeDAO();

        ArrayList<College> list = dao.getAllColleges();

        request.setAttribute("collegeList", list);

        request.getRequestDispatcher("/superadmin/collegeManagement.jsp")
               .forward(request, response);

    }

}