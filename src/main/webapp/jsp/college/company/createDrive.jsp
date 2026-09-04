<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.campusconnect.bean.Company" %>
<!DOCTYPE html>
<html>
<head><title>Create Drive</title></head>
<body style="font-family: Arial; padding: 40px;">
    <h2>🎯 Create New Campus Drive</h2>
    <form action="${pageContext.request.contextPath}/DriveController" method="post">
        <input type="hidden" name="action" value="create">
        
        <label>Company:</label>
        <select name="companyId" required style="width: 100%; padding: 10px; margin-bottom: 10px;">
            <option value="">Select Company</option>
            <% 
            List<Company> comps = (List<Company>) request.getAttribute("companyList");
            if(comps != null) {
                for(Company c : comps) { 
                    out.println("<option value='" + c.getCompanyId() + "'>" + c.getCompanyName() + "</option>");
                }
            }
            %>
        </select>

        <div style="margin-bottom: 10px;"><input type="text" name="driveTitle" placeholder="Drive Title" style="width:100%; padding:10px;" required></div>
        <div style="margin-bottom: 10px;"><input type="text" name="position" placeholder="Position" style="width:100%; padding:10px;" required></div>
        <div style="margin-bottom: 10px;"><input type="number" name="noOfHires" placeholder="No. of Hires" style="width:100%; padding:10px;" required></div>
        <div style="margin-bottom: 10px;"><textarea name="eligibilityCriteria" placeholder="Eligibility Criteria" style="width:100%; padding:10px;" required></textarea></div>
        <div style="margin-bottom: 10px;"><input type="number" step="0.01" name="packageCtc" placeholder="Package (LPA)" style="width:100%; padding:10px;" required></div>
        <div style="margin-bottom: 10px;"><label>Registration Deadline:</label><input type="date" name="registrationDeadline" required style="width:100%; padding:10px;"></div>
        <div style="margin-bottom: 10px;"><label>Drive Date:</label><input type="date" name="driveDate" required style="width:100%; padding:10px;"></div>

        <button type="submit" style="padding: 10px 20px; background: #27ae60; color: white; border:none; cursor:pointer;">Create Drive</button>
        <a href="${pageContext.request.contextPath}/DriveController?action=list" style="margin-left: 10px;">Cancel</a>
    </form>
</body>
</html>