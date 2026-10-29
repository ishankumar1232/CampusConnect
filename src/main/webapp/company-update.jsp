<%@ page import="com.campusconnect.bean.Company" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");

    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) {
        response.setStatus(401);
        out.print("{\"success\":false,\"message\":\"Please sign in again.\"}");
        return;
    }

    String companyName = request.getParameter("companyName");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String website = request.getParameter("website");

    companyName = companyName == null ? "" : companyName.trim();
    if (companyName.isEmpty() || "null".equalsIgnoreCase(companyName)) {
        response.setStatus(400);
        out.print("{\"success\":false,\"message\":\"Please enter a valid company name.\"}");
        return;
    }

    if (phone != null && "null".equalsIgnoreCase(phone.trim())) phone = "";
    if (address != null && "null".equalsIgnoreCase(address.trim())) address = "";
    if (website != null && "null".equalsIgnoreCase(website.trim())) website = "";

    try {
        Company company = new Company();
        company.setCompanyId(companyId);
        company.setCompanyName(companyName);
        company.setPhone(phone);
        company.setAddress(address);
        company.setWebsite(website);

        boolean updated = company.UpdateMethod();

        if (updated) {
            session.setAttribute("companyName", companyName);
            out.print("{\"success\":true,\"message\":\"Company profile updated successfully.\"}");
        } else {
            response.setStatus(400);
            out.print("{\"success\":false,\"message\":\"Unable to update company profile. Please try again.\"}");
        }
    } catch (Exception e) {
        application.log("Company profile update failed.", e);
        response.setStatus(500);
        out.print("{\"success\":false,\"message\":\"An error occurred while updating the profile.\"}");
    }
%>
