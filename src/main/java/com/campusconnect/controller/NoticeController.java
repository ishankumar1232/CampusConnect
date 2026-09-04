package com.campusconnect.controller;

import com.campusconnect.bean.Notice;
import com.campusconnect.dao.NoticeDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/NoticeController")
public class NoticeController extends HttpServlet {

    NoticeDAO dao = new NoticeDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action) || action == null) {
            listNotices(req, resp);
        } else if ("edit".equals(action)) {
            editNotice(req, resp);
        } else if ("delete".equals(action)) {
            deleteNotice(req, resp);
        } else if ("showAdd".equals(action)) {
           req.getRequestDispatcher("jsp/college/addNotice.jsp").forward(req, resp);
        	//req.getRequestDispatcher("/college/addNotice.jsp").forward(req, resp);

        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addNotice(req, resp);
        } else if ("update".equals(action)) {
            updateNotice(req, resp);
        }
    }

    private void listNotices(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Notice> list = dao.getAllNotices();
        req.setAttribute("noticeList", list);
       req.getRequestDispatcher("jsp/college/noticeList.jsp").forward(req, resp);
        //req.getRequestDispatcher("/college/noticeList.jsp").forward(req, resp);

    }

    private void addNotice(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        int adminId = Integer.parseInt(req.getParameter("adminId"));
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String noticeType = req.getParameter("noticeType");
        String attachmentPath = req.getParameter("attachmentPath");
        String expiryDate = req.getParameter("expiryDate");
        String status = req.getParameter("status");

        // ✅ NO CONSTRUCTOR - Use setters instead
        Notice notice = new Notice();
        notice.setCollegeId(collegeId);
        notice.setAdminId(adminId);
        notice.setTitle(title);
        notice.setDescription(description);
        notice.setNoticeType(noticeType);
        notice.setAttachmentPath(attachmentPath);
        notice.setExpiryDate(expiryDate);
        notice.setStatus(status);

        boolean result = dao.addNotice(notice);

        if (result) {
            resp.sendRedirect("NoticeController?action=list");
        } else {
            req.setAttribute("message", "Failed to add notice!");
           // req.getRequestDispatcher("jsp/college/addNotice.jsp").forward(req, resp);
            req.getRequestDispatcher("/college/addNotice.jsp").forward(req, resp);

        }
    }

    private void editNotice(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int noticeId = Integer.parseInt(req.getParameter("noticeId"));
        Notice notice = dao.getNoticeById(noticeId);
        req.setAttribute("notice", notice);
        //req.getRequestDispatcher("jsp/college/editNotice.jsp").forward(req, resp);
        req.getRequestDispatcher("/college/editNotice.jsp").forward(req, resp);

    }

    private void updateNotice(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        int noticeId = Integer.parseInt(req.getParameter("noticeId"));
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        int adminId = Integer.parseInt(req.getParameter("adminId"));
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String noticeType = req.getParameter("noticeType");
        String attachmentPath = req.getParameter("attachmentPath");
        String expiryDate = req.getParameter("expiryDate");
        String status = req.getParameter("status");

        // ✅ NO CONSTRUCTOR - Use setters instead
        Notice notice = new Notice();
        notice.setNoticeId(noticeId);
        notice.setCollegeId(collegeId);
        notice.setAdminId(adminId);
        notice.setTitle(title);
        notice.setDescription(description);
        notice.setNoticeType(noticeType);
        notice.setAttachmentPath(attachmentPath);
        notice.setExpiryDate(expiryDate);
        notice.setStatus(status);

        boolean result = dao.updateNotice(notice);

        if (result) {
            resp.sendRedirect("NoticeController?action=list");
        } else {
            req.setAttribute("message", "Failed to update notice!");
           // req.getRequestDispatcher("jsp/college/editNotice.jsp").forward(req, resp);
            req.getRequestDispatcher("/college/editNotice.jsp").forward(req, resp);

        }
    }

    private void deleteNotice(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int noticeId = Integer.parseInt(req.getParameter("noticeId"));
        boolean result = dao.deleteNotice(noticeId);

        if (result) {
            resp.sendRedirect("NoticeController?action=list");
        } else {
            req.setAttribute("message", "Failed to delete notice!");
            listNotices(req, resp);
        }
    }
}