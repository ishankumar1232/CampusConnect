package com.campusconnect.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.campusconnect.bean.Student;

@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024,
	    maxFileSize = 10 * 1024 * 1024,
	    maxRequestSize = 15 * 1024 * 1024
	)
public class StudentProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        System.out.println("PROFILE SERVLET STARTED");

        HttpSession session = req.getSession(false);

        if(session == null || session.getAttribute("studentId") == null) {
            res.sendRedirect(req.getContextPath() + "/student_login.jsp");
            return;
        }

        try {

            int studentId = (Integer) session.getAttribute("studentId");

            System.out.println("STUDENT ID = " + studentId);

            // Read multipart form fields
            String name = getPartValue(req, "name");
            String phone = getPartValue(req, "phone");
            String dob = getPartValue(req, "dob");
            String gender = getPartValue(req, "gender");
            String address = getPartValue(req, "address");

            System.out.println("NAME = " + name);
            System.out.println("PHONE = " + phone);
            System.out.println("DOB = " + dob);
            System.out.println("GENDER = " + gender);
            System.out.println("ADDRESS = " + address);

            // Check DOB
            if(dob == null || dob.trim().equals("")) {

                System.out.println("DOB IS EMPTY");

                res.sendRedirect(
                    req.getContextPath() +
                    "/student_profile.jsp?error=3"
                );
                return;
            }

            // Convert DOB
            Date dateOfBirth;

            try {

                String[] parts = dob.trim().split("-");

                if(parts.length != 3) {
                    throw new Exception();
                }

                int year = Integer.parseInt(parts[0]);
                int month = Integer.parseInt(parts[1]);
                int day = Integer.parseInt(parts[2]);

                dateOfBirth = Date.valueOf(
                    year + "-" +
                    String.format("%02d", month) + "-" +
                    String.format("%02d", day)
                );

            } catch(Exception e) {

                res.sendRedirect(
                    req.getContextPath() +
                    "/student_profile.jsp?error=3"
                );
                return;
            }

            // Create Student object
            Student student = new Student();

            student.setStudentId(studentId);
            student.setName(name);
            student.setPhone(phone);
            student.setDob(dateOfBirth);
            student.setGender(gender);
            student.setAddress(address);

            // Update profile details
            boolean profileUpdated = student.updateProfile();

            System.out.println(
                "PROFILE UPDATED = " + profileUpdated
            );

            // Get image
            Part imagePart = req.getPart("profileImage");

            if(imagePart != null && imagePart.getSize() > 0) {

                System.out.println("IMAGE PART RECEIVED");
                System.out.println(
                    "IMAGE SIZE = " + imagePart.getSize()
                );

                String fileName = imagePart.getSubmittedFileName();

                if(fileName == null || fileName.trim().equals("")) {

                    res.sendRedirect(
                        req.getContextPath() +
                        "/student_profile.jsp?error=2"
                    );
                    return;
                }

                String lowerName = fileName.toLowerCase();

                // Check extension
                if(!lowerName.endsWith(".jpg") &&
                   !lowerName.endsWith(".jpeg") &&
                   !lowerName.endsWith(".png")) {

                    res.sendRedirect(
                        req.getContextPath() +
                        "/student_profile.jsp?error=2"
                    );
                    return;
                }

                String extension;

                if(lowerName.endsWith(".png")) {
                    extension = ".png";
                }
                else if(lowerName.endsWith(".jpeg")) {
                    extension = ".jpeg";
                }
                else {
                    extension = ".jpg";
                }

                // New image name
                String newFileName =
                    "student_" + studentId + extension;

                // Create profile_images folder
                String uploadPath =
                    getServletContext().getRealPath("/")
                    + "profile_images";

                File uploadDir = new File(uploadPath);

                if(!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                System.out.println(
                    "UPLOAD DIRECTORY = " + uploadPath
                );

                // Delete old images
                String[] oldExtensions = {
                    ".jpg",
                    ".jpeg",
                    ".png"
                };

                for(String ext : oldExtensions) {

                    File oldFile =
                        new File(
                            uploadDir,
                            "student_" + studentId + ext
                        );

                    if(oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                // Save new image
                Path imagePath =
                    Paths.get(uploadPath, newFileName);

                try(InputStream input =
                        imagePart.getInputStream()) {

                    Files.copy(
                        input,
                        imagePath,
                        StandardCopyOption.REPLACE_EXISTING
                    );
                }

                System.out.println(
                    "IMAGE SAVED SUCCESSFULLY"
                );

                // Save image name in database
                student.setProfileImage(newFileName);

                boolean imageUpdated =
                    student.updateProfileImage();

                System.out.println(
                    "IMAGE DATABASE UPDATED = "
                    + imageUpdated
                );
            }

            // Final result
            if(profileUpdated) {

                res.sendRedirect(
                    req.getContextPath() +
                    "/student_profile.jsp?success=1"
                );

            } else {

                res.sendRedirect(
                    req.getContextPath() +
                    "/student_profile.jsp?error=1"
                );
            }

        } catch(Exception e) {

            e.printStackTrace();

            res.sendRedirect(
                req.getContextPath() +
                "/student_profile.jsp?error=1"
            );
        }
    }

    // Read values from multipart form
    private String getPartValue(
            HttpServletRequest req,
            String name)
            throws IOException, ServletException {

        Part part = req.getPart(name);

        if(part == null) {
            return "";
        }

        try(InputStream input = part.getInputStream()) {

            return new String(
                input.readAllBytes(),
                StandardCharsets.UTF_8
            ).trim();
        }
    }
}