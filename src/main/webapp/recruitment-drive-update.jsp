<%@ page import="com.campusconnect.bean.RecruitmentDrive" %>
<%
    request.setCharacterEncoding("UTF-8");

    Integer companyId = (Integer) session.getAttribute("companyId");
    if (companyId == null) {
        response.sendRedirect("company-login.jsp");
        return;
    }

    String driveId = request.getParameter("driveId");
    String driveType = request.getParameter("driveType");
    String jobTitle = request.getParameter("jobTitle");
    String description = request.getParameter("description");
    String vacancy = request.getParameter("vacancy");
    String eligibilityCgpa = request.getParameter("eligibilityCgpa");
    String requiredBranch = request.getParameter("requiredBranch");
    String requiredSkills = request.getParameter("requiredSkills");
    String salary = request.getParameter("salary");
    String deadline = request.getParameter("deadline");
    String status = request.getParameter("status");

    boolean hasMissingValue = driveId == null || driveType == null ||
            jobTitle == null || description == null || vacancy == null ||
            eligibilityCgpa == null || requiredBranch == null ||
            requiredSkills == null || salary == null || deadline == null ||
            status == null;

    if (hasMissingValue) {
        session.setAttribute("driveUpdateMessage",
                "Some required details were missing. The drive was not updated.");
        response.sendRedirect("view-recruitment-drives.jsp");
        return;
    }

    try {
        RecruitmentDrive drive = new RecruitmentDrive();
        drive.setDriveId(Integer.parseInt(driveId.trim()));
        drive.setCompanyId(companyId);
        drive.setDriveType(driveType.trim());
        drive.setJobTitle(jobTitle.trim());
        drive.setDescription(description.trim());
        drive.setVacancy(Integer.parseInt(vacancy.trim()));
        drive.setEligibilityCgpa(Double.parseDouble(eligibilityCgpa.trim()));
        drive.setRequiredBranch(requiredBranch.trim());
        drive.setRequiredSkills(requiredSkills.trim());
        drive.setSalary(Double.parseDouble(salary.trim()));
        drive.setDeadline(deadline.trim());
        drive.setStatus(status.trim());

        boolean updated = drive.UpdateMethod();

        if (updated) {
            session.setAttribute("driveUpdateMessage",
                    "Recruitment drive updated successfully.");
        } else {
            session.setAttribute("driveUpdateMessage",
                    "Recruitment drive could not be updated. Please try again.");
        }
    } catch (Exception e) {
        application.log("Recruitment drive update failed.", e);
        session.setAttribute("driveUpdateMessage",
                "The update could not be completed. Check the details and try again.");
    }

    response.sendRedirect("view-recruitment-drives.jsp");
    return;
%>