package com.campusconnect.servlet;

import java.io.IOException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LogoutServlet extends HttpServlet
{

	public void doGet(HttpServletRequest req,
			HttpServletResponse res)
			throws IOException
	{

		req.getSession().invalidate();

		res.sendRedirect("superadmin/login.jsp");

	}

}