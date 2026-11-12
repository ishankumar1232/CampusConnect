package com.campusconnect.bean;

public class DashboardBean {

    // ============================================
    // DASHBOARD CARDS
    // ============================================

    private int totalColleges;
    private int totalCompanies;
    private int totalStudents;
    private int placedStudents;
    private int activeDrives;
    private int pendingApprovals;

    // ============================================
    // COLLEGE STATUS
    // ============================================

    private int approvedColleges;
    private int pendingColleges;
    private int rejectedColleges;

    // ============================================
    // COMPANY STATUS
    // ============================================

    private int approvedCompanies;
    private int pendingCompanies;
    private int rejectedCompanies;

    // ============================================
    // RECRUITMENT STATUS
    // ============================================

    private int openDrives;
    private int activeDriveCount;
    private int completedDrives;

    // ============================================
    // APPLICATIONS / SELECTIONS / PLACEMENTS
    // ============================================

    private int totalApplications;
    private int totalSelections;
    private int totalPlacements;

    // ============================================
    // SYSTEM NOTIFICATIONS
    // ============================================

    private int pendingCollegeApprovals;
    private int pendingCompanyApprovals;
    private int activeRecruitmentDrives;
    private int registeredCompanies;
    private int registeredStudents;

    // ============================================
    // COLLEGE WISE PLACEMENT CHART
    // ============================================

    private String[] collegeNames;
    private int[] collegePlacementCounts;

    // ============================================
    // MONTHLY RECRUITMENT TREND
    // ============================================

    private String[] months;
    private int[] monthlyRecruitmentCounts;

    // ============================================
    // DASHBOARD CARDS
    // ============================================

    public int getTotalColleges() {
        return totalColleges;
    }

    public void setTotalColleges(int totalColleges) {
        this.totalColleges = totalColleges;
    }

    public int getTotalCompanies() {
        return totalCompanies;
    }

    public void setTotalCompanies(int totalCompanies) {
        this.totalCompanies = totalCompanies;
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getPlacedStudents() {
        return placedStudents;
    }

    public void setPlacedStudents(int placedStudents) {
        this.placedStudents = placedStudents;
    }

    public int getActiveDrives() {
        return activeDrives;
    }

    public void setActiveDrives(int activeDrives) {
        this.activeDrives = activeDrives;
    }

    public int getPendingApprovals() {
        return pendingApprovals;
    }

    public void setPendingApprovals(int pendingApprovals) {
        this.pendingApprovals = pendingApprovals;
    }

    // ============================================
    // COLLEGE STATUS
    // ============================================

    public int getApprovedColleges() {
        return approvedColleges;
    }

    public void setApprovedColleges(int approvedColleges) {
        this.approvedColleges = approvedColleges;
    }

    public int getPendingColleges() {
        return pendingColleges;
    }

    public void setPendingColleges(int pendingColleges) {
        this.pendingColleges = pendingColleges;
    }

    public int getRejectedColleges() {
        return rejectedColleges;
    }

    public void setRejectedColleges(int rejectedColleges) {
        this.rejectedColleges = rejectedColleges;
    }

    // ============================================
    // COMPANY STATUS
    // ============================================

    public int getApprovedCompanies() {
        return approvedCompanies;
    }

    public void setApprovedCompanies(int approvedCompanies) {
        this.approvedCompanies = approvedCompanies;
    }

    public int getPendingCompanies() {
        return pendingCompanies;
    }

    public void setPendingCompanies(int pendingCompanies) {
        this.pendingCompanies = pendingCompanies;
    }

    public int getRejectedCompanies() {
        return rejectedCompanies;
    }

    public void setRejectedCompanies(int rejectedCompanies) {
        this.rejectedCompanies = rejectedCompanies;
    }
    
    // ============================================
    // RECRUITMENT STATUS
    // ============================================

    public int getOpenDrives() {
        return openDrives;
    }

    public void setOpenDrives(int openDrives) {
        this.openDrives = openDrives;
    }

    public int getActiveDriveCount() {
        return activeDriveCount;
    }

    public void setActiveDriveCount(int activeDriveCount) {
        this.activeDriveCount = activeDriveCount;
    }

    public int getCompletedDrives() {
        return completedDrives;
    }

    public void setCompletedDrives(int completedDrives) {
        this.completedDrives = completedDrives;
    }

    // ============================================
    // SYSTEM NOTIFICATIONS
    // ============================================

    public int getPendingCollegeApprovals() {
        return pendingCollegeApprovals;
    }

    public void setPendingCollegeApprovals(int pendingCollegeApprovals) {
        this.pendingCollegeApprovals = pendingCollegeApprovals;
    }

    public int getPendingCompanyApprovals() {
        return pendingCompanyApprovals;
    }

    public void setPendingCompanyApprovals(int pendingCompanyApprovals) {
        this.pendingCompanyApprovals = pendingCompanyApprovals;
    }

    public int getActiveRecruitmentDrives() {
        return activeRecruitmentDrives;
    }

    public void setActiveRecruitmentDrives(int activeRecruitmentDrives) {
        this.activeRecruitmentDrives = activeRecruitmentDrives;
    }

    public int getRegisteredCompanies() {
        return registeredCompanies;
    }

    public void setRegisteredCompanies(int registeredCompanies) {
        this.registeredCompanies = registeredCompanies;
    }

    public int getRegisteredStudents() {
        return registeredStudents;
    }

    public void setRegisteredStudents(int registeredStudents) {
        this.registeredStudents = registeredStudents;
    }

    // ============================================
    // APPLICATIONS / SELECTIONS / PLACEMENTS
    // ============================================

    public int getTotalApplications() {
        return totalApplications;
    }

    public void setTotalApplications(int totalApplications) {
        this.totalApplications = totalApplications;
    }

    public int getTotalSelections() {
        return totalSelections;
    }

    public void setTotalSelections(int totalSelections) {
        this.totalSelections = totalSelections;
    }

    public int getTotalPlacements() {
        return totalPlacements;
    }

    public void setTotalPlacements(int totalPlacements) {
        this.totalPlacements = totalPlacements;
    }

    // ============================================
    // COLLEGE WISE PLACEMENT CHART
    // ============================================

    public String[] getCollegeNames() {
        return collegeNames;
    }

    public void setCollegeNames(String[] collegeNames) {
        this.collegeNames = collegeNames;
    }

    public int[] getCollegePlacementCounts() {
        return collegePlacementCounts;
    }

    public void setCollegePlacementCounts(int[] collegePlacementCounts) {
        this.collegePlacementCounts = collegePlacementCounts;
    }

    // ============================================
    // MONTHLY RECRUITMENT TREND
    // ============================================

    public String[] getMonths() {
        return months;
    }

    public void setMonths(String[] months) {
        this.months = months;
    }

    public int[] getMonthlyRecruitmentCounts() {
        return monthlyRecruitmentCounts;
    }

    public void setMonthlyRecruitmentCounts(int[] monthlyRecruitmentCounts) {
        this.monthlyRecruitmentCounts = monthlyRecruitmentCounts;
    }

}