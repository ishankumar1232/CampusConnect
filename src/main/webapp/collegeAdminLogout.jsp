<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    HttpSession adminSession = request.getSession(false);

    if(adminSession != null)
    {
        adminSession.invalidate();
    }

    response.sendRedirect(
        request.getContextPath() +
        "/collegeAdminLogin.jsp"
    );
%>