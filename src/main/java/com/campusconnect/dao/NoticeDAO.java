package com.campusconnect.dao;

import com.campusconnect.bean.Notice;
import com.campusconnect.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoticeDAO {
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 1. ADD NOTICE
    public boolean addNotice(Notice notice) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            // Using SYSDATE for dates to avoid Java date parsing errors
            String sql = "INSERT INTO NOTICE VALUES " +
                         "(notice_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, SYSDATE, ?, ?, SYSDATE, SYSDATE)";
            ps = con.prepareStatement(sql);
            
            ps.setInt(1, notice.getCollegeId());
            ps.setInt(2, notice.getAdminId());
            ps.setString(3, notice.getTitle());
            ps.setString(4, notice.getDescription());
            ps.setString(5, notice.getNoticeType());
            ps.setString(6, notice.getAttachmentPath());
            ps.setString(7, notice.getExpiryDate());
            ps.setString(8, notice.getStatus());

            int rows = ps.executeUpdate();
            if(rows > 0) status = true;
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    // 2. GET ALL NOTICES
    public List<Notice> getAllNotices() {
        List<Notice> list = new ArrayList<>();
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM NOTICE";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                Notice n = new Notice();
                n.setNoticeId(rs.getInt("NOTICE_ID"));
                n.setCollegeId(rs.getInt("COLLEGE_ID"));
                n.setAdminId(rs.getInt("ADMIN_ID"));
                n.setTitle(rs.getString("TITLE"));
                n.setDescription(rs.getString("DESCRIPTION")); // CHANGED from CONTENT
                n.setNoticeType(rs.getString("NOTICE_TYPE"));
                n.setAttachmentPath(rs.getString("ATTACHMENT_PATH"));
                n.setPostedDate(rs.getString("POSTED_DATE"));
                n.setExpiryDate(rs.getString("EXPIRY_DATE"));
                n.setStatus(rs.getString("STATUS"));
                list.add(n);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. GET NOTICE BY ID
    public Notice getNoticeById(int noticeId) {
        Notice notice = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM NOTICE WHERE NOTICE_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, noticeId);
            rs = ps.executeQuery();

            if(rs.next()) {
                notice = new Notice();
                notice.setNoticeId(rs.getInt("NOTICE_ID"));
                notice.setCollegeId(rs.getInt("COLLEGE_ID"));
                notice.setAdminId(rs.getInt("ADMIN_ID"));
                notice.setTitle(rs.getString("TITLE"));
                notice.setDescription(rs.getString("DESCRIPTION")); // CHANGED from CONTENT
                notice.setNoticeType(rs.getString("NOTICE_TYPE"));
                notice.setAttachmentPath(rs.getString("ATTACHMENT_PATH"));
                notice.setPostedDate(rs.getString("POSTED_DATE"));
                notice.setExpiryDate(rs.getString("EXPIRY_DATE"));
                notice.setStatus(rs.getString("STATUS"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return notice;
    }

    // 4. UPDATE NOTICE
    public boolean updateNotice(Notice notice) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE NOTICE SET COLLEGE_ID=?, ADMIN_ID=?, TITLE=?, DESCRIPTION=?, " +
                         "NOTICE_TYPE=?, ATTACHMENT_PATH=?, EXPIRY_DATE=?, STATUS=?, UPDATED_DATE=SYSDATE " +
                         "WHERE NOTICE_ID=?";
            ps = con.prepareStatement(sql);
            
            ps.setInt(1, notice.getCollegeId());
            ps.setInt(2, notice.getAdminId());
            ps.setString(3, notice.getTitle());
            ps.setString(4, notice.getDescription());
            ps.setString(5, notice.getNoticeType());
            ps.setString(6, notice.getAttachmentPath());
            ps.setString(7, notice.getExpiryDate());
            ps.setString(8, notice.getStatus());
            ps.setInt(9, notice.getNoticeId());

            int rows = ps.executeUpdate();
            if(rows > 0) status = true;
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    // 5. DELETE NOTICE
    public boolean deleteNotice(int noticeId) {
        boolean status = false;
        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM NOTICE WHERE NOTICE_ID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, noticeId);
            int rows = ps.executeUpdate();
            if(rows > 0) status = true;
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
}