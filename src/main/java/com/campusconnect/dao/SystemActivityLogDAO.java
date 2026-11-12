package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.SystemActivityLog;
import com.campusconnect.util.DBConnection;

public class SystemActivityLogDAO {

    public ArrayList<SystemActivityLog> getAllLogs() {

        ArrayList<SystemActivityLog> list =
                new ArrayList<SystemActivityLog>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String sql =
                    "SELECT LOG_ID, ACTIVITY_DATE, ACTIVITY " +
                    "FROM SYSTEM_ACTIVITY_LOG " +
                    "ORDER BY ACTIVITY_DATE DESC";

            ps = con.prepareStatement(sql);

            rs = ps.executeQuery();

            while(rs.next()) {

                SystemActivityLog log =
                        new SystemActivityLog();

                log.setLogId(rs.getInt("LOG_ID"));

                if(rs.getDate("ACTIVITY_DATE") != null) {
                    log.setActivityDate(
                            rs.getDate("ACTIVITY_DATE").toString());
                }
                else {
                    log.setActivityDate("");
                }

                log.setActivity(
                        rs.getString("ACTIVITY"));

                list.add(log);
            }

            System.out.println("Activity Log Count = " + list.size());

        }
        catch(Exception e) {

            e.printStackTrace();

        }
        finally {

            try {

                if(rs != null)
                    rs.close();

                if(ps != null)
                    ps.close();

                if(con != null)
                    con.close();

            }
            catch(Exception e) {

                e.printStackTrace();

            }

        }

        return list;
    }
}