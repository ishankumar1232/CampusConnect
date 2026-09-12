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

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM COLLEGE"; 

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

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

        try {

            Connection con = DBConnection.getConnection();		//DATABSE CONNECTION

            String sql="UPDATE COLLEGE SET STATUS='APPROVED' WHERE COLLEGE_ID=?";

            PreparedStatement ps=con.prepareStatement(sql);

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

        try {

            Connection con=DBConnection.getConnection();

            String sql="UPDATE COLLEGE SET STATUS='REJECTED' WHERE COLLEGE_ID=?";

            PreparedStatement ps=con.prepareStatement(sql);

            ps.setInt(1,collegeId);

            if(ps.executeUpdate()>0)
                status=true;

        }
        catch(Exception e){

            e.printStackTrace();

        }

        return status;

    }

}