package com.campusconnect.controller;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
 
import com.campusconnect.bean.Admission;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.dao.SystemSettingDAO;
 
public class NewStudentAdmissionRequest
        extends HttpServlet
{
    public void doPost(
        HttpServletRequest req,
        HttpServletResponse res)
        throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw =
            res.getWriter();
        
     // ======================================
     // CHECK ADMISSION REQUEST STATUS
     // ======================================

     SystemSettingDAO settingDAO = new SystemSettingDAO();

     SystemSetting setting = settingDAO.getSystemSettings();

     if (setting != null &&
         "OFF".equalsIgnoreCase(setting.getAdmissionRequest())) {

         pw.println("<html>");
         pw.println("<body>");

         pw.println("<h2>Admission Request Disabled</h2>");

         pw.println("<p>");
         pw.println("Admission Request has been disabled by Super Admin.");
         pw.println("</p>");

         pw.println("<a href='index.jsp'>Back</a>");

         pw.println("</body>");
         pw.println("</html>");

         return;
     }

        String collegeId =
            req.getParameter("collegeId");

        String name =
            req.getParameter("name");

        String email =
            req.getParameter("email");

        String phone =
            req.getParameter("phone");

        String courseId =
            req.getParameter("courseId");


        try
        {
            Admission a =
                new Admission();


            a.setCollegeId(
                Integer.parseInt(collegeId)
            );

            a.setApplicantName(name);

            a.setApplicantEmail(email);

            a.setApplicantPhone(phone);

            a.setApplicantCourseId(
                Integer.parseInt(courseId)
            );


            boolean x =
                a.InsertMethod();


            if(x)
            {
                int admissionId =
                    a.getAdmissionId();


                /*
                 * Send generated Admission ID
                 * to success page
                 */

                req.setAttribute(
                    "admissionId",
                    admissionId
                );

                req.setAttribute(
                    "name",
                    name
                );

                req.setAttribute(
                    "email",
                    email
                );

                req.setAttribute(
                    "collegeId",
                    collegeId
                );


                RequestDispatcher rd =
                    req.getRequestDispatcher(
                        "new_student_admission_success.jsp"
                    );

                rd.forward(req, res);
            }
            else
            {
                pw.println(
                    "<html><body>"
                );

                pw.println(
                    "<h2>" +
                    "Admission Request Failed" +
                    "</h2>"
                );

                pw.println(
                    "</body></html>"
                );
            }
        }
        catch(Exception e)
        {
            pw.println(
                "<html><body>"
            );

            pw.println(
                "<h2>Admission Request Error</h2>"
            );

            pw.println(
                "<p>" + e + "</p>"
            );

            pw.println(
                "</body></html>"
            );
        }
    }
}