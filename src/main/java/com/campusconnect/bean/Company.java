package com.campusconnect.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Company {

    private int companyId;
    private String companyName;
    private String email;
    private String phone;
    private String password;
    private String address;
    private String website;
    private String status;
	public int getCompanyId() {
		return companyId;
	}
	public void setCompanyId(int companyId) {
		this.companyId = companyId;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getWebsite() {
		return website;
	}
	public void setWebsite(String website) {
		this.website = website;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	
	public boolean SelectMethod()
	{
	    try
	    {
	        Class.forName("oracle.jdbc.driver.OracleDriver");

	        Connection con = DriverManager.getConnection(
	            "jdbc:oracle:thin:@localhost:1521:XE",
	            "CAMPUSCONNECT",
	            "campus123"
	        );

	        Statement stmt = con.createStatement();

	        String q1 = "SELECT * FROM COMPANY " +
	                    "WHERE COMPANY_ID = " + companyId;

	        ResultSet rs = stmt.executeQuery(q1);

	        if(rs.next())
	        {
	            companyName = rs.getString("COMPANY_NAME");
	            email = rs.getString("EMAIL");
	            phone = rs.getString("PHONE");
	            address = rs.getString("ADDRESS");
	            website = rs.getString("WEBSITE");
	            status = rs.getString("STATUS");

	            con.close();

	            return true;
	        }
	        else
	        {
	            con.close();

	            return false;
	        }
	    }
	    catch(Exception e)
	    {
	        return false;
	    }
	}
	
	public boolean UpdateMethod()
	{
	    try
	    {
	        Class.forName("oracle.jdbc.driver.OracleDriver");

	        Connection con = DriverManager.getConnection(
	            "jdbc:oracle:thin:@localhost:1521:XE",
	            "CAMPUSCONNECT",
	            "campus123"
	        );

	        Statement stmt = con.createStatement();

	        String q1 = "UPDATE COMPANY SET " +
	                    "COMPANY_NAME = '" + companyName + "', " +
	                    "PHONE = '" + phone + "', " +
	                    "ADDRESS = '" + address + "', " +
	                    "WEBSITE = '" + website + "' " +
	                    "WHERE COMPANY_ID = " + companyId;

	        int x = stmt.executeUpdate(q1);

	        con.close();

	        if(x > 0)
	        {
	            return true;
	        }
	        else
	        {
	            return false;
	        }
	    }
	    catch(Exception e)
	    {
	        return false;
	    }
	}
}
