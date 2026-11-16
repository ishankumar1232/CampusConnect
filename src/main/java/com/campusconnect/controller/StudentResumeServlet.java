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
    public void doGet(HttpServletRequest req,
                      HttpServletResponse res)
            throws IOException, ServletException
    {
        doPost(req, res);
    }

    public void doPost(HttpServletRequest req,
                       HttpServletResponse res)
            throws IOException, ServletException
    {
        res.setContentType("text/html");

        PrintWriter pw = res.getWriter();

        HttpSession session = null;
        try
        {
            session = req.getSession(false);

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
                    // Delete physical file safely
                    if(oldFile != null && !oldFile.trim().equals(""))
                    {
                        String safeName = Paths.get(oldFile.trim()).getFileName().toString();
                        String realPath = getServletContext().getRealPath("/");
                        String folder;
                        if (realPath != null && (realPath.endsWith("/") || realPath.endsWith("\\"))) {
                            folder = realPath + "resume_files";
                        } else if (realPath != null) {
                            folder = realPath + File.separator + "resume_files";
                        } else {
                            folder = new File(System.getProperty("user.dir"), "resume_files").getAbsolutePath();
                        }

                        File file = new File(folder, safeName);
                        if(file.exists() && file.isFile())
                        {
                            file.delete();
                        }
                    }

                    session.setAttribute("resumeMsg", "Resume deleted successfully.");
                    res.sendRedirect("student_resume_view.jsp");
                }
                else
                {
                    session.setAttribute("resumeError", "Unable to delete resume record.");
                    res.sendRedirect("student_resume_view.jsp");
                }

                return;
            }

            // ================= FILE =================

            Part filePart = req.getPart("resumeFile");
            String resumeId = req.getParameter("resumeId");

            if(filePart == null || filePart.getSize() == 0)
            {
                session.setAttribute("resumeError", "Please select a resume file to upload.");
                res.sendRedirect("student_resume.jsp");
                return;
            }

            String originalName =
                Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String extension = "";
            int dot = originalName.lastIndexOf(".");
            if(dot >= 0)
            {
                extension = originalName.substring(dot).toLowerCase();
            }

            // Only PDF / DOC / DOCX
            if(!extension.equals(".pdf") && !extension.equals(".doc") && !extension.equals(".docx"))
            {
                session.setAttribute("resumeError", "Only PDF, DOC, and DOCX files are allowed.");
                res.sendRedirect("student_resume.jsp");
                return;
            }

            // Unique file name
            String fileName = "student_" + studentId + "_" + System.currentTimeMillis() + extension;

            // Target Folder
            String realPath = getServletContext().getRealPath("/");
            String folder;
            if (realPath != null && (realPath.endsWith("/") || realPath.endsWith("\\"))) {
                folder = realPath + "resume_files";
            } else if (realPath != null) {
                folder = realPath + File.separator + "resume_files";
            } else {
                folder = new File(System.getProperty("user.dir"), "resume_files").getAbsolutePath();
            }

            File uploadFolder = new File(folder);
            if(!uploadFolder.exists())
            {
                uploadFolder.mkdirs();
            }

            String filePath = folder + File.separator + fileName;
            filePart.write(filePath);

            StudentResume resume = new StudentResume();
            resume.setStudentId(studentId);
            resume.setResumeFile(fileName);

            boolean result;

            // ================= UPDATE =================
            if(resumeId != null && !resumeId.trim().equals(""))
            {
                resume.setResumeId(Integer.parseInt(resumeId));
                result = resume.UpdateMethod();

                if(result)
                {
                    session.setAttribute("resumeMsg", "Resume updated and replaced successfully!");
                    res.sendRedirect("student_resume_view.jsp");
                }
                else
                {
                    session.setAttribute("resumeError", "Resume update failed. Please try again.");
                    res.sendRedirect("student_resume.jsp?editId=" + resumeId);
                }
            }

            // ================= ADD =================
            else
            {
                result = resume.InsertMethod();

                if(result)
                {
                    session.setAttribute("resumeMsg", "Resume uploaded successfully!");
                    res.sendRedirect("student_resume_view.jsp");
                }
                else
                {
                    session.setAttribute("resumeError", "Resume upload failed. Please try again.");
                    res.sendRedirect("student_resume.jsp");
                }
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("resumeError", "An unexpected error occurred: " + e.getMessage());
            }
            res.sendRedirect("student_resume.jsp");
        }
    }
}