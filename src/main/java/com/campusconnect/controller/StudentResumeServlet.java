package com.campusconnect.controller;

import java.io.*;
import java.nio.file.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;

import com.campusconnect.bean.StudentResume;


@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 15 * 1024 * 1024
)

public class StudentResumeServlet extends HttpServlet
{
    public void doPost(HttpServletRequest req,
                       HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        try
        {
            HttpSession session =
                req.getSession(false);

            if(session == null ||
               session.getAttribute("studentId") == null)
            {
                res.sendRedirect("student_login.jsp");
                return;
            }

            int studentId =
                (Integer)session.getAttribute("studentId");


            String action =
                req.getParameter("action");


            // ================= DELETE =================

            if("delete".equals(action))
            {
                int resumeId =
                    Integer.parseInt(
                        req.getParameter("resumeId")
                    );

                String oldFile =
                    req.getParameter("resumeFile");


                StudentResume resume =
                    new StudentResume();

                resume.setResumeId(resumeId);
                resume.setStudentId(studentId);


                boolean result =
                    resume.DeleteMethod();


                if(result)
                {
                    // Delete physical file

                    if(oldFile != null &&
                       !oldFile.trim().equals(""))
                    {
                        String folder =
                            getServletContext()
                            .getRealPath("/")
                            + "resume_files";

                        File file =
                            new File(folder, oldFile);

                        if(file.exists())
                        {
                            file.delete();
                        }
                    }

                    res.sendRedirect(
                        "student_resume_view.jsp"
                    );
                }
                else
                {
                    pw.println(
                        "<h2>Resume Delete Failed</h2>"
                    );
                }

                return;
            }


            // ================= FILE =================

            Part filePart =
                req.getPart("resumeFile");


            String resumeId =
                req.getParameter("resumeId");


            if(filePart == null ||
               filePart.getSize() == 0)
            {
                pw.println(
                    "<h2>Please select a resume file.</h2>"
                );

                return;
            }


            String originalName =
                Paths.get(
                    filePart.getSubmittedFileName()
                ).getFileName().toString();


            String extension = "";

            int dot =
                originalName.lastIndexOf(".");

            if(dot >= 0)
            {
                extension =
                    originalName.substring(dot)
                    .toLowerCase();
            }


            // Only PDF / DOC / DOCX

            if(!extension.equals(".pdf") &&
               !extension.equals(".doc") &&
               !extension.equals(".docx"))
            {
                pw.println(
                    "<h2>Only PDF, DOC and DOCX files are allowed.</h2>"
                );

                return;
            }


            // Unique file name

            String fileName =
                "student_" +
                studentId +
                "_" +
                System.currentTimeMillis() +
                extension;


            // Folder

            String folder =
                getServletContext()
                .getRealPath("/")
                + "resume_files";


            File uploadFolder =
                new File(folder);


            if(!uploadFolder.exists())
            {
                uploadFolder.mkdirs();
            }


            String filePath =
                folder + File.separator + fileName;


            // Save actual file

            filePart.write(filePath);


            StudentResume resume =
                new StudentResume();

            resume.setStudentId(studentId);
            resume.setResumeFile(fileName);


            boolean result;


            // ================= UPDATE =================

            if(resumeId != null &&
               !resumeId.trim().equals(""))
            {
                resume.setResumeId(
                    Integer.parseInt(resumeId)
                );

                result =
                    resume.UpdateMethod();


                if(result)
                {
                    res.sendRedirect(
                        "student_resume_view.jsp"
                    );
                }
                else
                {
                    pw.println(
                        "<h2>Resume Update Failed</h2>"
                    );
                }
            }


            // ================= ADD =================

            else
            {
                result =
                    resume.InsertMethod();


                if(result)
                {
                    res.sendRedirect(
                        "student_resume_view.jsp"
                    );
                }
                else
                {
                    pw.println(
                        "<h2>Resume Upload Failed</h2>"
                    );
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();

            pw.println("<h2>Error</h2>");

            pw.println(
                "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}