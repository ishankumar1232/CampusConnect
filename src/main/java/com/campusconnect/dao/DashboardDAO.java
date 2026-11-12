package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.DashboardBean;
import com.campusconnect.util.DBConnection;

public class DashboardDAO {

    public DashboardBean getDashboardData() {

        DashboardBean bean = new DashboardBean();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String sql;

            // ============================================
            // DASHBOARD CARDS
            // ============================================

            // Total Colleges
            sql = "SELECT COUNT(*) FROM COLLEGE";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setTotalColleges(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // ============================================
            // Total Companies
            // ============================================

            sql = "SELECT COUNT(*) FROM COMPANY";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setTotalCompanies(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // ============================================
            // Total Students
            // ============================================

            sql = "SELECT COUNT(*) FROM STUDENT";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setTotalStudents(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // ============================================
            // Placed Students
            // (Fixed)
            // ============================================

            sql =
                "SELECT COUNT(*) " +
                "FROM SELECTION " +
                "WHERE UPPER(RESULT)='SELECTED'";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setPlacedStudents(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // ============================================
            // Active Drives
            // ============================================

            sql =
                "SELECT COUNT(*) " +
                "FROM RECRUITMENT_DRIVE " +
                "WHERE STATUS='ACTIVE'";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setActiveDrives(rs.getInt(1));
            }

            rs.close();
            ps.close();
            // ============================================
            // Pending Approvals
            // ============================================

            sql =
                "SELECT " +
                "(SELECT COUNT(*) FROM COLLEGE WHERE STATUS='PENDING')" +
                "+" +
                "(SELECT COUNT(*) FROM COMPANY WHERE STATUS='PENDING')" +
                " FROM DUAL";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setPendingApprovals(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // ============================================
            // COLLEGE STATUS
            // ============================================

            sql = "SELECT COUNT(*) FROM COLLEGE WHERE STATUS='APPROVED'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setApprovedColleges(rs.getInt(1));
            }

            rs.close();
            ps.close();

            sql = "SELECT COUNT(*) FROM COLLEGE WHERE STATUS='PENDING'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setPendingColleges(rs.getInt(1));
            }

            rs.close();
            ps.close();

            sql = "SELECT COUNT(*) FROM COLLEGE WHERE STATUS='REJECTED'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setRejectedColleges(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // ============================================
            // COMPANY STATUS
            // ============================================

            sql = "SELECT COUNT(*) FROM COMPANY WHERE UPPER(STATUS)='APPROVED'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setApprovedCompanies(rs.getInt(1));
            }

            rs.close();
            ps.close();

            sql = "SELECT COUNT(*) FROM COMPANY WHERE UPPER(STATUS)='PENDING'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setPendingCompanies(rs.getInt(1));
            }

            rs.close();
            ps.close();

            sql = "SELECT COUNT(*) FROM COMPANY WHERE UPPER(STATUS)='REJECTED'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setRejectedCompanies(rs.getInt(1));
            }

            rs.close();
            ps.close();
            // =====================================================
            // RECRUITMENT STATUS
            // =====================================================

            sql = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='OPEN'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setOpenDrives(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='ACTIVE'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setActiveDriveCount(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='COMPLETED'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setCompletedDrives(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // =====================================================
            // APPLICATION / SELECTION / PLACEMENT
            // =====================================================

            sql = "SELECT COUNT(*) FROM APPLICATION";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setTotalApplications(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql = "SELECT COUNT(*) FROM SELECTION";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setTotalSelections(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql =
            "SELECT COUNT(*) " +
            "FROM SELECTION " +
            "WHERE UPPER(RESULT)='SELECTED'";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                bean.setTotalPlacements(rs.getInt(1));
            }

            rs.close();
            ps.close();
            // =====================================================
            // SYSTEM NOTIFICATIONS
            // =====================================================

            sql = "SELECT COUNT(*) FROM COLLEGE WHERE STATUS='PENDING'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if(rs.next())
            {
                bean.setPendingCollegeApprovals(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql = "SELECT COUNT(*) FROM COMPANY WHERE STATUS='PENDING'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if(rs.next())
            {
                bean.setPendingCompanyApprovals(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql = "SELECT COUNT(*) FROM RECRUITMENT_DRIVE WHERE STATUS='ACTIVE'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if(rs.next())
            {
                bean.setActiveRecruitmentDrives(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql = "SELECT COUNT(*) FROM COMPANY";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if(rs.next())
            {
                bean.setRegisteredCompanies(rs.getInt(1));
            }

            rs.close();
            ps.close();

            // --------------------------------------------

            sql = "SELECT COUNT(*) FROM STUDENT";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if(rs.next())
            {
                bean.setRegisteredStudents(rs.getInt(1));
            }

            rs.close();
            ps.close();
         // =====================================================
         // COLLEGE WISE PLACEMENT CHART
         // =====================================================
          
         sql =
         "SELECT C.COLLEGE_NAME, COUNT(*) TOTAL " +
         "FROM COLLEGE C " +
         "JOIN STUDENT S ON C.COLLEGE_ID = S.COLLEGE_ID " +
         "JOIN APPLICATION A ON S.STUDENT_ID = A.STUDENT_ID " +
         "JOIN SELECTION SE ON A.APPLICATION_ID = SE.APPLICATION_ID " +
         "WHERE UPPER(SE.RESULT)='SELECTED' " +
         "GROUP BY C.COLLEGE_NAME " +
         "ORDER BY TOTAL DESC";
         
        

         ps = con.prepareStatement(sql);
         rs = ps.executeQuery();
         
         

         ArrayList<String> colleges = new ArrayList<String>();
         ArrayList<Integer> counts = new ArrayList<Integer>();

         while(rs.next())
         {
             String college = rs.getString("COLLEGE_NAME");
             int total = rs.getInt("TOTAL");

             System.out.println(college + " = " + total);

             colleges.add(college);
             counts.add(total);
         }

         bean.setCollegeNames(colleges.toArray(new String[colleges.size()]));

         int arr[] = new int[counts.size()];

         for(int i=0;i<counts.size();i++)
         {
             arr[i]=counts.get(i);
         }

         bean.setCollegePlacementCounts(arr);

         rs.close();
         ps.close();
         // =====================================================
         // MONTHLY RECRUITMENT TREND
         // =====================================================

         sql =
         "SELECT TO_CHAR(DEADLINE,'MON') MONTH_NAME, COUNT(*) TOTAL " +
         "FROM RECRUITMENT_DRIVE " +
         "GROUP BY TO_CHAR(DEADLINE,'MON'), TO_CHAR(DEADLINE,'MM') " +
         "ORDER BY TO_CHAR(DEADLINE,'MM')";

         ps = con.prepareStatement(sql);
         rs = ps.executeQuery();

         ArrayList<String> months = new ArrayList<String>();
         ArrayList<Integer> totals = new ArrayList<Integer>();

         while(rs.next())
         {
             months.add(rs.getString("MONTH_NAME"));
             totals.add(rs.getInt("TOTAL"));
         }

         bean.setMonths(months.toArray(new String[months.size()]));

         int monthArr[] = new int[totals.size()];

         for(int i=0;i<totals.size();i++)
         {
             monthArr[i] = totals.get(i);
         }

         bean.setMonthlyRecruitmentCounts(monthArr);

         rs.close();
         ps.close();
        }
        catch(Exception e)
        {
            System.out.println("DashboardDAO Error :");
            e.printStackTrace();
        }
        finally
        {
            try
            {
                if(rs != null)
                {
                    rs.close();
                }

                if(ps != null)
                {
                    ps.close();
                }

                if(con != null)
                {
                    con.close();
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
        }

        return bean;

    }
    
    

}