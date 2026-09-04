package com.campusconnect.dao;

import java.sql.*;
import java.util.ArrayList;

import com.campusconnect.bean.RecruitmentDrive;
import com.campusconnect.util.DBConnection;

public class RecruitmentDriveDAO
{

    public ArrayList<RecruitmentDrive> getAllDrives()
    {

        ArrayList<RecruitmentDrive> list = new ArrayList<>();

        try
        {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM RECRUITMENT_DRIVE";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next())
            {

                RecruitmentDrive d =
                        new RecruitmentDrive();

                d.setDriveId(rs.getInt("DRIVE_ID"));
                d.setCompanyId(rs.getInt("COMPANY_ID"));
                d.setDriveType(rs.getString("DRIVE_TYPE"));
                d.setJobTitle(rs.getString("JOB_TITLE"));
                d.setDescription(rs.getString("DESCRIPTION"));
                d.setVacancy(rs.getInt("VACANCY"));
                d.setEligibilityCgpa(rs.getDouble("ELIGIBILITY_CGPA"));
                d.setRequiredBranch(rs.getString("REQUIRED_BRANCH"));
                d.setRequiredSkills(rs.getString("REQUIRED_SKILLS"));
                d.setSalary(rs.getDouble("SALARY"));
                d.setDeadline(rs.getString("DEADLINE"));
                d.setStatus(rs.getString("STATUS"));

                list.add(d);

            }

            rs.close();
            ps.close();
            con.close();

        }

        catch(Exception e)
        {
            e.printStackTrace();
        }

        return list;

    }

}