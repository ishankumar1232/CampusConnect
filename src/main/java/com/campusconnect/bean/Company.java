
package com.campusconnect.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import com.campusconnect.util.DBConnection;

public class Company {

    private int companyId;
    private String companyName;
    private String email;
    private String phone;
    private String password;
    private String address;
    private String website;
    private String status;
    private String logoUrl;
    private String bannerUrl;
    private String description;

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

	public String getLogoUrl() {
		return logoUrl;
	}
	public void setLogoUrl(String logoUrl) {
		this.logoUrl = logoUrl;
	}
	public String getLogo() {
		return logoUrl;
	}
	public void setLogo(String logo) {
		this.logoUrl = logo;
	}

	public String getBannerUrl() {
		return bannerUrl;
	}
	public void setBannerUrl(String bannerUrl) {
		this.bannerUrl = bannerUrl;
	}
	public String getBanner() {
		return bannerUrl;
	}
	public void setBanner(String banner) {
		this.bannerUrl = banner;
	}

	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}

	public boolean SelectMethod()
	{
	    try (Connection con = DBConnection.getConnection())
	    {
	        if (con == null) return false;

	        String q1 = "SELECT * FROM COMPANY WHERE COMPANY_ID = ?";
	        try (PreparedStatement ps = con.prepareStatement(q1))
	        {
	            ps.setInt(1, companyId);
	            try (ResultSet rs = ps.executeQuery())
	            {
	                if(rs.next())
	                {
	                    companyName = rs.getString("COMPANY_NAME");
	                    email = rs.getString("EMAIL");
	                    phone = rs.getString("PHONE");
	                    address = rs.getString("ADDRESS");
	                    website = rs.getString("WEBSITE");
	                    status = rs.getString("STATUS");
	                    logoUrl = rs.getString("LOGO");
	                    bannerUrl = rs.getString("BANNER");
	                    description = rs.getString("DESCRIPTION");
	                    return true;
	                }
	                else
	                {
	                    return false;
	                }
	            }
	        }
	    }
	    catch(Exception e)
	    {
	        e.printStackTrace();
	        return false;
	    }
	}

	public boolean UpdateMethod()
	{
	    try (Connection con = DBConnection.getConnection())
	    {
	        if (con == null) return false;

	        String q1 = "UPDATE COMPANY SET " +
	                    "COMPANY_NAME = ?, " +
	                    "PHONE = ?, " +
	                    "ADDRESS = ?, " +
	                    "WEBSITE = ?, " +
	                    "DESCRIPTION = ? " +
	                    "WHERE COMPANY_ID = ?";

	        try (PreparedStatement ps = con.prepareStatement(q1))
	        {
	            ps.setString(1, companyName);
	            ps.setString(2, phone);
	            ps.setString(3, address);
	            ps.setString(4, website);
	            ps.setString(5, description);
	            ps.setInt(6, companyId);

	            int x = ps.executeUpdate();
	            return x > 0;
	        }
	    }
	    catch(Exception e)
	    {
	        e.printStackTrace();
	        return false;
	    }
	}
}
