package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.util.DBConnection;

public class SystemSettingDAO {

    Connection con = DBConnection.getConnection();

    PreparedStatement ps;

    ResultSet rs;

    // ==========================
    // GET SETTINGS
    // ==========================

    public SystemSetting getSystemSettings() {

        SystemSetting setting = new SystemSetting();

        try {

            String sql = "SELECT * FROM SYSTEM_SETTINGS WHERE SETTING_ID=1";

            ps = con.prepareStatement(sql);

            rs = ps.executeQuery();

            if (rs.next()) {

                setting.setSettingId(rs.getInt("SETTING_ID"));
                setting.setStudentRegistration(rs.getString("STUDENT_REGISTRATION"));
                setting.setCollegeRegistration(rs.getString("COLLEGE_REGISTRATION"));
                setting.setCompanyRegistration(rs.getString("COMPANY_REGISTRATION"));
                setting.setAdmissionRequest(rs.getString("ADMISSION_REQUEST"));
                setting.setRecruitmentDrive(rs.getString("RECRUITMENT_DRIVE"));
                setting.setMaintenanceMode(rs.getString("MAINTENANCE_MODE"));

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return setting;

    }

    // ==========================
    // UPDATE SETTINGS
    // ==========================

    public boolean updateSystemSettings(SystemSetting setting) {

        boolean status = false;

        try {

            String sql =
                    "UPDATE SYSTEM_SETTINGS SET "
                  + "STUDENT_REGISTRATION=?, "
                  + "COLLEGE_REGISTRATION=?, "
                  + "COMPANY_REGISTRATION=?, "
                  + "ADMISSION_REQUEST=?, "
                  + "RECRUITMENT_DRIVE=?, "
                  + "MAINTENANCE_MODE=? "
                  + "WHERE SETTING_ID=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, setting.getStudentRegistration());
            ps.setString(2, setting.getCollegeRegistration());
            ps.setString(3, setting.getCompanyRegistration());
            ps.setString(4, setting.getAdmissionRequest());
            ps.setString(5, setting.getRecruitmentDrive());
            ps.setString(6, setting.getMaintenanceMode());
            ps.setInt(7, setting.getSettingId());

            int i = ps.executeUpdate();

            if (i > 0) {
                status = true;
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return status;

    }

}