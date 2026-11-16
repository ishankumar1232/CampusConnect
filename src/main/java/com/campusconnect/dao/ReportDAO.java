package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import com.campusconnect.util.DBConnection;

public class ReportDAO
{

    public int getCount(String sql)
    {
        int count = 0;

        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return 0;
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery())
            {
                if (rs.next())
                {
                    count = rs.getInt(1);
                }
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

        return count;
    }

    public Map<String, Integer> getSystemReportCounts()
    {
        Map<String, Integer> map = new HashMap<>();

        String sql = "SELECT " +
            "(SELECT COUNT(*) FROM COLLEGE) AS total_colleges, " +
            "(SELECT COUNT(*) FROM COLLEGE WHERE UPPER(STATUS)='APPROVED') AS approved_colleges, " +
            "(SELECT COUNT(*) FROM COLLEGE WHERE UPPER(STATUS)='REJECTED') AS rejected_colleges, " +
            "(SELECT COUNT(*) FROM COMPANY) AS total_companies, " +
            "(SELECT COUNT(*) FROM COMPANY WHERE UPPER(STATUS)='APPROVED') AS approved_companies, " +
            "(SELECT COUNT(*) FROM COMPANY WHERE UPPER(STATUS)='REJECTED') AS rejected_companies, " +
            "(SELECT COUNT(*) FROM STUDENT) AS total_students, " +
            "(SELECT COUNT(*) FROM STUDENT WHERE UPPER(STATUS)='ACTIVE') AS active_students, " +
            "(SELECT COUNT(*) FROM STUDENT WHERE UPPER(STATUS)='INACTIVE') AS inactive_students, " +
            "(SELECT COUNT(*) FROM RECRUITMENT_DRIVE) AS total_drives, " +
            "(SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE UPPER(STATUS) IN ('ACTIVE', 'OPEN')) AS active_drives, " +
            "(SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE UPPER(STATUS)='CLOSED') AS closed_drives " +
            "FROM DUAL";

        try (Connection con = DBConnection.getConnection())
        {
            if (con == null) return map;
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery())
            {
                if (rs.next())
                {
                    map.put("collegeCount", rs.getInt("total_colleges"));
                    map.put("approvedCollege", rs.getInt("approved_colleges"));
                    map.put("rejectedCollege", rs.getInt("rejected_colleges"));
                    map.put("companyCount", rs.getInt("total_companies"));
                    map.put("approvedCompany", rs.getInt("approved_companies"));
                    map.put("rejectedCompany", rs.getInt("rejected_companies"));
                    map.put("studentCount", rs.getInt("total_students"));
                    map.put("activeStudent", rs.getInt("active_students"));
                    map.put("inactiveStudent", rs.getInt("inactive_students"));
                    map.put("driveCount", rs.getInt("total_drives"));
                    map.put("activeDrive", rs.getInt("active_drives"));
                    map.put("closedDrive", rs.getInt("closed_drives"));
                }
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

        return map;
    }

}
