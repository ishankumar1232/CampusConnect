package com.campusconnect.bean;

public class SystemActivityLog {

    private int logId;
    private String activityDate;
    private String activity;

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public String getActivityDate() {
        return activityDate;
    }

    public void setActivityDate(String activityDate) {
        this.activityDate = activityDate;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

}