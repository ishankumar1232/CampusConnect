package com.campusconnect.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

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

    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }

    public String getBannerUrl() { return bannerUrl; }
    public void setBannerUrl(String bannerUrl) { this.bannerUrl = bannerUrl; }

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:XE",
            "CAMPUSCONNECT",
            "campus123"
        );
    }

    public boolean SelectMethod() {
        String sql = "SELECT COMPANY_NAME, EMAIL, PHONE, ADDRESS, " +
                     "WEBSITE, STATUS, LOGO_URL, BANNER_URL " +
                     "FROM COMPANY WHERE COMPANY_ID = ?";

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, companyId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                companyName = rs.getString("COMPANY_NAME");
                email = rs.getString("EMAIL");
                phone = rs.getString("PHONE");

                address = rs.getString("ADDRESS");
                website = rs.getString("WEBSITE");
                status = rs.getString("STATUS");
                logoUrl = rs.getString("LOGO_URL");
                bannerUrl = rs.getString("BANNER_URL");
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean UpdateMethod() {
        if (companyName == null) {
            return false;
        }

        String cleanName = companyName.trim();
        if (cleanName.isEmpty() || "null".equalsIgnoreCase(cleanName)) {
            return false;
        }

        String sql = "UPDATE COMPANY SET COMPANY_NAME = ?, PHONE = ?, " +
                     "ADDRESS = ?, WEBSITE = ? WHERE COMPANY_ID = ?";

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, cleanName);
            setOptionalString(stmt, 2, phone);
            setOptionalString(stmt, 3, address);
            setOptionalString(stmt, 4, website);
            stmt.setInt(5, companyId);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void setOptionalString(PreparedStatement stmt, int index,
                                  String value) throws SQLException {
        if (value == null || value.trim().isEmpty() ||
            "null".equalsIgnoreCase(value.trim())) {
            stmt.setNull(index, Types.VARCHAR);
        } else {
            stmt.setString(index, value.trim());
        }
    }
}