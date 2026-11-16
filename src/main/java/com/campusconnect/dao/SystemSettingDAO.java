package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.campusconnect.bean.SystemSetting;
import com.campusconnect.util.DBConnection;

public class SystemSettingDAO {

    private static volatile SystemSetting cachedSetting = null;
    private static volatile long lastCacheTime = 0;
    private static final long CACHE_TTL_MS = 5000; // 5 seconds cache

    // GET SETTINGS

    public SystemSetting getSystemSettings() {

        long now = System.currentTimeMillis();
        SystemSetting current = cachedSetting;
        if (current != null && (now - lastCacheTime < CACHE_TTL_MS)) {
            return current;
        }

        SystemSetting setting = new SystemSetting();
        String sql = "SELECT * FROM SYSTEM_SETTINGS WHERE SETTING_ID=1";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return current != null ? current : setting;
            }
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    setting.setSettingId(rs.getInt("SETTING_ID"));
                    String sReg = rs.getString("STUDENT_REGISTRATION");
                    setting.setStudentRegistration(sReg != null ? sReg : "ON");
                    String colReg = rs.getString("COLLEGE_REGISTRATION");
                    setting.setCollegeRegistration(colReg != null ? colReg : "ON");
                    String compReg = rs.getString("COMPANY_REGISTRATION");
                    setting.setCompanyRegistration(compReg != null ? compReg : "ON");
                    String admReq = rs.getString("ADMISSION_REQUEST");
                    setting.setAdmissionRequest(admReq != null ? admReq : "ON");
                    String recDrv = rs.getString("RECRUITMENT_DRIVE");
                    setting.setRecruitmentDrive(recDrv != null ? recDrv : "ON");
                    String maint = rs.getString("MAINTENANCE_MODE");
                    setting.setMaintenanceMode(maint != null ? maint : "OFF");

                    cachedSetting = setting;
                    lastCacheTime = now;
                } else {
                    // No row exists in SYSTEM_SETTINGS; initialize default row 1
                    String initSql = "INSERT INTO SYSTEM_SETTINGS (SETTING_ID, STUDENT_REGISTRATION, COLLEGE_REGISTRATION, COMPANY_REGISTRATION, ADMISSION_REQUEST, RECRUITMENT_DRIVE, MAINTENANCE_MODE) VALUES (1, 'ON', 'ON', 'ON', 'ON', 'ON', 'OFF')";
                    try (PreparedStatement psInit = con.prepareStatement(initSql)) {
                        psInit.executeUpdate();
                    } catch (Exception ex) {
                        // ignore if concurrent insert
                    }
                    cachedSetting = setting;
                    lastCacheTime = now;
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
            if (current != null) return current;
        }

        return setting;

    }

    // UPDATE SETTINGS

    public boolean updateSystemSettings(SystemSetting setting) {

        boolean status = false;
        String sql =
                "UPDATE SYSTEM_SETTINGS SET "
              + "STUDENT_REGISTRATION=?, "
              + "COLLEGE_REGISTRATION=?, "
              + "COMPANY_REGISTRATION=?, "
              + "ADMISSION_REQUEST=?, "
              + "RECRUITMENT_DRIVE=?, "
              + "MAINTENANCE_MODE=? "
              + "WHERE SETTING_ID=?";

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) return false;
            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, setting.getStudentRegistration());
                ps.setString(2, setting.getCollegeRegistration());
                ps.setString(3, setting.getCompanyRegistration());
                ps.setString(4, setting.getAdmissionRequest());
                ps.setString(5, setting.getRecruitmentDrive());
                ps.setString(6, setting.getMaintenanceMode());
                ps.setInt(7, setting.getSettingId());

                int rows = ps.executeUpdate();

                if (rows == 0) {
                    String insertSql = "INSERT INTO SYSTEM_SETTINGS (SETTING_ID, STUDENT_REGISTRATION, COLLEGE_REGISTRATION, COMPANY_REGISTRATION, ADMISSION_REQUEST, RECRUITMENT_DRIVE, MAINTENANCE_MODE) VALUES (1, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement psIns = con.prepareStatement(insertSql)) {
                        psIns.setString(1, setting.getStudentRegistration());
                        psIns.setString(2, setting.getCollegeRegistration());
                        psIns.setString(3, setting.getCompanyRegistration());
                        psIns.setString(4, setting.getAdmissionRequest());
                        psIns.setString(5, setting.getRecruitmentDrive());
                        psIns.setString(6, setting.getMaintenanceMode());
                        if (psIns.executeUpdate() > 0) {
                            rows = 1;
                        }
                    }
                }

                if (rows > 0) {
                    status = true;
                    // Invalidate cache immediately on update
                    cachedSetting = null;
                    lastCacheTime = 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;

    }

}
