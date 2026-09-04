package com.campusconnect.dao;

import com.campusconnect.bean.College;
import com.campusconnect.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CollegeDAO {

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;


    // ====================================
    // 1. ADD COLLEGE
    // ====================================

    public boolean addCollege(College college) {

        boolean status = false;

        try {

            con = DBConnection.getConnection();

            String sql = "INSERT INTO COLLEGE VALUES"
                       + "(college_seq.NEXTVAL,?,?,?,?,?,?,?)";

            ps = con.prepareStatement(sql);

            ps.setString(1, college.getCollegeName());
            ps.setString(2, college.getAddress());
            ps.setString(3, college.getCity());
            ps.setString(4, college.getState());
            ps.setString(5, college.getEmail());
            ps.setString(6, college.getPhone());
            ps.setString(7, college.getStatus());

            int rows = ps.executeUpdate();

            if (rows > 0) {

                status = true;
                System.out.println("College Added Successfully!");

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return status;
    }


    // ====================================
    // 2. GET ALL COLLEGES
    // ====================================

    public List<College> getAllColleges() {

        List<College> list = new ArrayList<>();

        try {

            con = DBConnection.getConnection();

            String sql = "SELECT * FROM COLLEGE";

            ps = con.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {

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

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return list;
    }


    // ====================================
    // 3. GET COLLEGE BY ID
    // ====================================

    public College getCollegeById(int collegeId) {

        College college = null;

        try {

            con = DBConnection.getConnection();

            String sql = "SELECT * FROM COLLEGE "
                       + "WHERE COLLEGE_ID=?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, collegeId);

            rs = ps.executeQuery();

            if (rs.next()) {

                college = new College();

                college.setCollegeId(rs.getInt("COLLEGE_ID"));
                college.setCollegeName(rs.getString("COLLEGE_NAME"));
                college.setAddress(rs.getString("ADDRESS"));
                college.setCity(rs.getString("CITY"));
                college.setState(rs.getString("STATE"));
                college.setEmail(rs.getString("EMAIL"));
                college.setPhone(rs.getString("PHONE"));
                college.setStatus(rs.getString("STATUS"));
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return college;
    }


    // ====================================
    // 4. UPDATE COLLEGE
    // ====================================

    public boolean updateCollege(College college) {

        boolean status = false;

        try {

            con = DBConnection.getConnection();

            String sql = "UPDATE COLLEGE SET "
                       + "COLLEGE_NAME=?, "
                       + "ADDRESS=?, "
                       + "CITY=?, "
                       + "STATE=?, "
                       + "EMAIL=?, "
                       + "PHONE=?, "
                       + "STATUS=? "
                       + "WHERE COLLEGE_ID=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, college.getCollegeName());
            ps.setString(2, college.getAddress());
            ps.setString(3, college.getCity());
            ps.setString(4, college.getState());
            ps.setString(5, college.getEmail());
            ps.setString(6, college.getPhone());
            ps.setString(7, college.getStatus());
            ps.setInt(8, college.getCollegeId());

            int rows = ps.executeUpdate();

            if (rows > 0) {

                status = true;
                System.out.println("College Updated Successfully!");

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return status;
    }


    // ====================================
    // 5. DELETE COLLEGE
    // ====================================

    public boolean deleteCollege(int collegeId) {

        boolean status = false;

        try {

            con = DBConnection.getConnection();

            String sql = "DELETE FROM COLLEGE "
                       + "WHERE COLLEGE_ID=?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, collegeId);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                status = true;
                System.out.println("College Deleted Successfully!");

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return status;
    }


    // ====================================
    // 6. APPROVE COLLEGE
    // ====================================

    public boolean approveCollege(int collegeId) {

        boolean status = false;

        try {

            con = DBConnection.getConnection();

            String sql =
                "UPDATE COLLEGE SET STATUS='APPROVED' "
              + "WHERE COLLEGE_ID=?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, collegeId);

            if (ps.executeUpdate() > 0) {

                status = true;

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return status;
    }


    // ====================================
    // 7. REJECT COLLEGE
    // ====================================

    public boolean rejectCollege(int collegeId) {

        boolean status = false;

        try {

            con = DBConnection.getConnection();

            String sql =
                "UPDATE COLLEGE SET STATUS='REJECTED' "
              + "WHERE COLLEGE_ID=?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, collegeId);

            if (ps.executeUpdate() > 0) {

                status = true;

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return status;
    }

}