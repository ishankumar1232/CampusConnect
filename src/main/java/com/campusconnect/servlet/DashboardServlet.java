 package com.campusconnect.servlet;

import java.io.IOException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DashboardServlet extends HttpServlet{

	public void doGet(HttpServletRequest req,
			HttpServletResponse res)
			throws IOException
	{

		res.sendRedirect("superadmin/dashboard.jsp");

	}

}