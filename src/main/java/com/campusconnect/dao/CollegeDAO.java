package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.College;
import com.campusconnect.util.DBConnection;

public class CollegeDAO {

    public ArrayList<College> getAllColleges() {

        ArrayList<College> list = new ArrayList<>();
        String sql = "SELECT * FROM COLLEGE"; 

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while(rs.next()) {

                College c = new College();

                c.setCollegeId(rs.getInt("COLLEGE_ID"));
                c.setCollegeName(rs.getString("COLLEGE_NAME"));
                c.setAddress(rs.getString("ADDRESS"));
                c.setCity(rs.getString("CITY"));
                c.setState(rs.getString("STATE"));
                c.setEmail(rs.getString("EMAIL"));
                c.setPhone(rs.getString("PHONE"));
                c.setStatus(rs.getString("STATUS"));

                list.add(c);

            }

        }
        catch(Exception e) {

            e.printStackTrace();

        }

        return list;

    }
    
    //APPROVE COLLEGE METHOD
    public boolean approveCollege(int collegeId) {

        boolean status = false;
        String sql="UPDATE COLLEGE SET STATUS='APPROVED' WHERE COLLEGE_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1,collegeId);

            if(ps.executeUpdate()>0)
                status=true;

        }
        catch(Exception e){

            e.printStackTrace();

        }

        return status;

    }
    
    //REJECT COLLEGE METHOD
    public boolean rejectCollege(int collegeId) {

        boolean status=false;
        String sql="UPDATE COLLEGE SET STATUS='REJECTED' WHERE COLLEGE_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1,collegeId);

            if(ps.executeUpdate()>0)
                status=true;

        }
        catch(Exception e){

            e.printStackTrace();

        }

        return status;

    }

    // REGISTER NEW COLLEGE (WITH INITIAL ADMIN ACCOUNT)
    public int registerCollege(College college, String adminName, String adminEmail, String adminPassword) {

        String nextColSql = "SELECT NVL(MAX(COLLEGE_ID),0)+1 FROM COLLEGE";
        String insColSql = "INSERT INTO COLLEGE (COLLEGE_ID, COLLEGE_NAME, ADDRESS, CITY, STATE, EMAIL, PHONE, STATUS) VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending')";
        String nextAdmSql = "SELECT NVL(MAX(ADMIN_ID),0)+1 FROM COLLEGE_ADMIN";
        String insAdmSql = "INSERT INTO COLLEGE_ADMIN (ADMIN_ID, COLLEGE_ID, NAME, EMAIL, PASSWORD) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) return -1;
            con.setAutoCommit(false);
            try {
                int collegeId = 1;
                try (java.sql.Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery(nextColSql)) {
                    if (rs.next()) collegeId = rs.getInt(1);
                }

                try (PreparedStatement ps = con.prepareStatement(insColSql)) {
                    ps.setInt(1, collegeId);
                    ps.setString(2, college.getCollegeName());
                    ps.setString(3, college.getAddress());
                    ps.setString(4, college.getCity());
                    ps.setString(5, college.getState());
                    ps.setString(6, college.getEmail());
                    ps.setString(7, college.getPhone());
                    ps.executeUpdate();
                }

                if (adminEmail != null && !adminEmail.trim().isEmpty()) {
                    int adminId = 1;
                    try (java.sql.Statement st = con.createStatement();
                         ResultSet rs = st.executeQuery(nextAdmSql)) {
                        if (rs.next()) adminId = rs.getInt(1);
                    }

                    try (PreparedStatement psAdm = con.prepareStatement(insAdmSql)) {
                        psAdm.setInt(1, adminId);
                        psAdm.setInt(2, collegeId);
                        psAdm.setString(3, adminName);
                        psAdm.setString(4, adminEmail);
                        psAdm.setString(5, adminPassword);
                        psAdm.executeUpdate();
                    }
                }

                con.commit();
                return collegeId;
            } catch (Exception ex) {
                con.rollback();
                ex.printStackTrace();
                return -1;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // GET COLLEGE BY ID
    public College getCollegeById(int collegeId) {
        College col = null;
        String sql = "SELECT COLLEGE_ID, COLLEGE_NAME, ADDRESS, CITY, STATE, EMAIL, PHONE, STATUS, LOGO_IMAGE, COVER_IMAGE FROM COLLEGE WHERE COLLEGE_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    col = new College();
                    col.setCollegeId(rs.getInt("COLLEGE_ID"));
                    col.setCollegeName(rs.getString("COLLEGE_NAME"));
                    col.setAddress(rs.getString("ADDRESS"));
                    col.setCity(rs.getString("CITY"));
                    col.setState(rs.getString("STATE"));
                    col.setEmail(rs.getString("EMAIL"));
                    col.setPhone(rs.getString("PHONE"));
                    col.setStatus(rs.getString("STATUS"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return col;
    }

    // ADD COLLEGE (DIRECT SUPER ADMIN CREATION)
    public int addCollege(College col) {
        int newId = -1;
        String seqSql = "SELECT NVL(MAX(COLLEGE_ID), 0) + 1 FROM COLLEGE";
        String insSql = "INSERT INTO COLLEGE (COLLEGE_ID, COLLEGE_NAME, ADDRESS, CITY, STATE, EMAIL, PHONE, STATUS) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement psSeq = con.prepareStatement(seqSql);
             ResultSet rs = psSeq.executeQuery()) {
            if (rs.next()) {
                newId = rs.getInt(1);
            }
            try (PreparedStatement ps = con.prepareStatement(insSql)) {
                ps.setInt(1, newId);
                ps.setString(2, col.getCollegeName());
                ps.setString(3, col.getAddress() != null ? col.getAddress() : "");
                ps.setString(4, col.getCity() != null ? col.getCity() : "");
                ps.setString(5, col.getState() != null ? col.getState() : "");
                ps.setString(6, col.getEmail() != null ? col.getEmail() : "");
                ps.setString(7, col.getPhone() != null ? col.getPhone() : "");
                ps.setString(8, col.getStatus() != null && !col.getStatus().trim().isEmpty() ? col.getStatus() : "Approved");
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
        return newId;
    }

    // UPDATE COLLEGE
    public boolean updateCollege(College col) {
        boolean updated = false;
        String sql = "UPDATE COLLEGE SET COLLEGE_NAME = ?, ADDRESS = ?, CITY = ?, STATE = ?, EMAIL = ?, PHONE = ?, STATUS = ? WHERE COLLEGE_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, col.getCollegeName());
            ps.setString(2, col.getAddress() != null ? col.getAddress() : "");
            ps.setString(3, col.getCity() != null ? col.getCity() : "");
            ps.setString(4, col.getState() != null ? col.getState() : "");
            ps.setString(5, col.getEmail() != null ? col.getEmail() : "");
            ps.setString(6, col.getPhone() != null ? col.getPhone() : "");
            ps.setString(7, col.getStatus() != null ? col.getStatus() : "Approved");
            ps.setInt(8, col.getCollegeId());
            updated = (ps.executeUpdate() > 0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return updated;
    }

}