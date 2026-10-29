<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Send the user back to the login form with a one-time error.
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.sendRedirect(response.encodeRedirectURL("company-login.jsp?error=invalid"));
%>
