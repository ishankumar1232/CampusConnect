<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession session1 = request.getSession(false);

    if(session1 != null)
    {
        session1.invalidate();
    }

    response.sendRedirect("student_login.jsp");
%>