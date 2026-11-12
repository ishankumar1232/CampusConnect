
package com.campusconnect.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.campusconnect.util.DBConnection;

@WebServlet("/CompanyUpdateServlet")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 11 * 1024 * 1024
)

public class CompanyUpdateServlet extends HttpServlet {

    private static final String UPLOAD_FOLDER = "images/company/";

    // ==========================================
    // SAVE UPLOADED IMAGE
    // ==========================================

    private String saveImage(Part part, String uploadPath)
            throws IOException, ServletException {

        if (part == null || part.getSize() == 0) {
            return null;
        }

        if (part.getSize() > 5 * 1024 * 1024) {
            throw new ServletException("Image size must not exceed 5 MB.");
        }

        String contentType = part.getContentType();

        if (contentType == null ||
            !(contentType.equals("image/png") ||
              contentType.equals("image/jpeg") ||
              contentType.equals("image/webp"))) {

            throw new ServletException(
                "Only PNG, JPG, JPEG and WEBP images are allowed."
            );
        }

        String originalName = part.getSubmittedFileName();

        if (originalName == null || originalName.trim().isEmpty()) {
            throw new ServletException("Invalid image file.");
        }

        String extension = "";

        int dot = originalName.lastIndexOf(".");

        if (dot >= 0) {
            extension = originalName.substring(dot).toLowerCase();
        }

        if (!(extension.equals(".png") ||
              extension.equals(".jpg") ||
              extension.equals(".jpeg") ||
              extension.equals(".webp"))) {

            throw new ServletException("Invalid image extension.");
        }

        File directory = new File(uploadPath);

        if (!directory.exists() && !directory.mkdirs()) {
            throw new IOException("Unable to create company image folder.");
        }

        // Generate a unique filename
        String fileName = UUID.randomUUID().toString() + extension;

        Path destination = Paths.get(uploadPath, fileName);

        try (InputStream input = part.getInputStream()) {

            Files.copy(
                input,
                destination,
                StandardCopyOption.REPLACE_EXISTING
            );

        }

        return UPLOAD_FOLDER + fileName;
    }


    // ==========================================
    // SEND JSON RESPONSE
    // ==========================================

    private void sendJson(
            HttpServletResponse response,
            int status,
            String message,
            boolean success) throws IOException {

        response.setStatus(status);

        String safeMessage = message.replace("\\", "\\\\")
                                    .replace("\"", "\\\"");

        response.getWriter().print(
            "{\"success\":" + success +
            ",\"message\":\"" + safeMessage + "\"}"
        );
    }


    // ==========================================
    // COMPANY PROFILE UPDATE
    // ==========================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        HttpSession session = request.getSession(false);

        // Check login session
        if (session == null ||
            !(session.getAttribute("companyId") instanceof Number)) {

            sendJson(
                response,
                401,
                "Please sign in again.",
                false
            );

            return;
        }

        int companyId =
            ((Number) session.getAttribute("companyId")).intValue();

        // Get form details
        String companyName = request.getParameter("companyName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String website = request.getParameter("website");

        companyName = companyName == null ? "" : companyName.trim();

        if (companyName.isEmpty()) {

            sendJson(
                response,
                400,
                "Please enter a valid company name.",
                false
            );

            return;
        }

        if (phone != null && "null".equalsIgnoreCase(phone.trim())) {
            phone = "";
        }

        if (address != null && "null".equalsIgnoreCase(address.trim())) {
            address = "";
        }

        if (website != null && "null".equalsIgnoreCase(website.trim())) {
            website = "";
        }

        String logoPath = null;
        String bannerPath = null;

        try {

            // Get uploaded image files
            Part logoPart = request.getPart("logoFile");
            Part bannerPart = request.getPart("bannerFile");

            // Get actual web application folder
            String uploadPath = getServletContext().getRealPath(
                "/" + UPLOAD_FOLDER
            );

            if (uploadPath == null) {
                throw new IOException(
                    "Unable to locate the company image folder."
                );
            }

            // Save logo and banner if selected
            logoPath = saveImage(logoPart, uploadPath);
            bannerPath = saveImage(bannerPart, uploadPath);


            // Update Oracle database
            String sql =
                "UPDATE COMPANY SET " +
                "COMPANY_NAME = ?, " +
                "PHONE = ?, " +
                "ADDRESS = ?, " +
                "WEBSITE = ?, " +
                "LOGO = NVL(?, LOGO), " +
                "BANNER = NVL(?, BANNER) " +
                "WHERE COMPANY_ID = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, companyName);
                ps.setString(2, phone);
                ps.setString(3, address);
                ps.setString(4, website);
                ps.setString(5, logoPath);
                ps.setString(6, bannerPath);
                ps.setInt(7, companyId);

                int updated = ps.executeUpdate();

                if (updated > 0) {

                    // Update session values
                    session.setAttribute("companyName", companyName);

                    if (logoPath != null) {
                        session.setAttribute("companyLogo", logoPath);
                    }

                    if (bannerPath != null) {
                        session.setAttribute("companyBanner", bannerPath);
                    }

                    sendJson(
                        response,
                        200,
                        "Company profile updated successfully.",
                        true
                    );

                } else {

                    sendJson(
                        response,
                        400,
                        "Unable to update company profile.",
                        false
                    );
                }
            }

        } catch (Exception e) {

        	getServletContext().log("Company profile update failed.", e);

            sendJson(
                response,
                500,
                "An error occurred while updating the profile. Check the server console.",
                false
            );
        }
    }
}
