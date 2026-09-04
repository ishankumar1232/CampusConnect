package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.campusconnect.util.DBConnection;

public class ReportDAO
{
    public int getCount(String sql)
    {
        int count = 0;

        try
        {
            Connection con =
                DBConnection.getConnection();

            PreparedStatement ps =
                con.prepareStatement(sql);

            ResultSet rs =
                ps.executeQuery();

            if(rs.next())
            {
                count = rs.getInt(1);
            }

            rs.close();
            ps.close();
            con.close();
        }

        catch(Exception e)
        {
            e.printStackTrace();
        }

        return count;
    }
}