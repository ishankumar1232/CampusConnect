package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.RecruitmentDrive;
import com.campusconnect.util.DBConnection;

public class RecruitmentDriveDAO {

    // ================= GET ALL RECRUITMENT DRIVES =================

	public ArrayList<RecruitmentDrive> getAllDrives() {

	    ArrayList<RecruitmentDrive> list = new ArrayList<>();

	    Connection con = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {

	        con = DBConnection.getConnection();

	        String sql =
	        		"SELECT " +
	        		"RD.DRIVE_ID, " +
	        		"C.COMPANY_NAME, " +
	        		"RD.DRIVE_TYPE, " +
	        		"RD.JOB_TITLE, " +
	        		"RD.DESCRIPTION, " +
	        		"RD.VACANCY, " +
	        		"RD.ELIGIBILITY_CGPA, " +
	        		"RD.REQUIRED_BRANCH, " +
	        		"RD.REQUIRED_SKILLS, " +
	        		"RD.SALARY, " +
	        		"RD.DEADLINE, " +
	        		"RD.STATUS, " +

	        		"COUNT(DISTINCT A.APPLICATION_ID) APPLICATIONS, " +
	        		"COUNT(DISTINCT CASE WHEN UPPER(S.RESULT)='SELECTED' THEN S.SELECTION_ID END) SELECTED_STUDENTS, " +
	        		"COUNT(DISTINCT CASE WHEN UPPER(S.RESULT)='SELECTED' THEN S.SELECTION_ID END) PLACED_STUDENTS " +

	        		"FROM RECRUITMENT_DRIVE RD " +

	        		"JOIN COMPANY C " +
	        		"ON RD.COMPANY_ID=C.COMPANY_ID " +

	        		"LEFT JOIN APPLICATION A " +
	        		"ON RD.DRIVE_ID=A.DRIVE_ID " +

	        		"LEFT JOIN SELECTION S " +
	        		"ON A.APPLICATION_ID=S.APPLICATION_ID " +

	        		"GROUP BY " +
	        		"RD.DRIVE_ID," +
	        		"C.COMPANY_NAME," +
	        		"RD.DRIVE_TYPE," +
	        		"RD.JOB_TITLE," +
	        		"RD.DESCRIPTION," +
	        		"RD.VACANCY," +
	        		"RD.ELIGIBILITY_CGPA," +
	        		"RD.REQUIRED_BRANCH," +
	        		"RD.REQUIRED_SKILLS," +
	        		"RD.SALARY," +
	        		"RD.DEADLINE," +
	        		"RD.STATUS " +

	        		"ORDER BY RD.DRIVE_ID";
	        
	        ps = con.prepareStatement(sql);

	        rs = ps.executeQuery();
	        
	        while (rs.next()) {

	            RecruitmentDrive drive = new RecruitmentDrive();

	            drive.setDriveId(rs.getInt("DRIVE_ID"));
	            drive.setCompanyName(rs.getString("COMPANY_NAME"));
	            drive.setDriveType(rs.getString("DRIVE_TYPE"));
	            drive.setJobTitle(rs.getString("JOB_TITLE"));
	            drive.setDescription(rs.getString("DESCRIPTION"));
	            drive.setVacancy(rs.getInt("VACANCY"));
	            drive.setEligibilityCgpa(rs.getDouble("ELIGIBILITY_CGPA"));
	            drive.setRequiredBranch(rs.getString("REQUIRED_BRANCH"));
	            drive.setRequiredSkills(rs.getString("REQUIRED_SKILLS"));
	            drive.setSalary(rs.getDouble("SALARY"));

	            if (rs.getDate("DEADLINE") != null) {
	                drive.setDeadline(rs.getDate("DEADLINE").toString());
	            } else {
	                drive.setDeadline("");
	            }

	            drive.setStatus(rs.getString("STATUS"));

	            // ===========================
	            // MONITORING COUNTS
	            // ===========================

	            drive.setApplications(rs.getInt("APPLICATIONS"));

	            drive.setSelectedStudents(
	                    rs.getInt("SELECTED_STUDENTS"));

	            drive.setPlacedStudents(
	                    rs.getInt("PLACED_STUDENTS"));

	            list.add(drive);
	        }
	        

	    } catch (Exception e) {

	        e.printStackTrace();

	    } finally {

	        try {

	            if (rs != null)
	                rs.close();

	            if (ps != null)
	                ps.close();

	            if (con != null)
	                con.close();

	        } catch (Exception e) {

	            e.printStackTrace();
	        }
	    }

	    return list;
	}
}