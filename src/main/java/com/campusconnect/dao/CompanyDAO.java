package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;

import com.campusconnect.bean.Company;
import com.campusconnect.util.DBConnection;

public class CompanyDAO
{
    public boolean insertCompany(Company c)
    {
        try
        {
            Connection con = DBConnection.getConnection();

            Statement stmt = con.createStatement();

            String q1 = "INSERT INTO COMPANY " +
                        "(COMPANY_ID, COMPANY_NAME, EMAIL, PHONE, PASSWORD, ADDRESS, WEBSITE, STATUS) " +
                        "VALUES (COMPANY_SEQ.NEXTVAL, '" +
                        c.getCompanyName() + "', '" +
                        c.getEmail() + "', '" +
                        c.getPhone() + "', '" +
                        c.getPassword() + "', '" +
                        c.getAddress() + "', '" +
                        c.getWebsite() + "', '" +
                        c.getStatus() + "')";

            int x = stmt.executeUpdate(q1);

            con.close();

            if(x > 0)
                return true;
            else
                return false;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }


    public Company loginCompany(String email, String password)
    {
        Company c = null;

        try
        {
            Connection con = DBConnection.getConnection();

            Statement stmt = con.createStatement();

            String q1 = "SELECT * FROM COMPANY " +
                        "WHERE EMAIL = '" + email + "' " +
                        "AND PASSWORD = '" + password + "'";

            ResultSet rs = stmt.executeQuery(q1);

            if(rs.next())
            {
                c = new Company();

                c.setCompanyId(rs.getInt("COMPANY_ID"));
                c.setCompanyName(rs.getString("COMPANY_NAME"));
                c.setEmail(rs.getString("EMAIL"));
                c.setPhone(rs.getString("PHONE"));
                c.setPassword(rs.getString("PASSWORD"));
                c.setAddress(rs.getString("ADDRESS"));
                c.setWebsite(rs.getString("WEBSITE"));
                c.setStatus(rs.getString("STATUS"));
            }

            con.close();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return c;
    }
}