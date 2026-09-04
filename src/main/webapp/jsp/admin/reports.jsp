<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List, java.util.HashMap, java.util.ArrayList, com.campusconnect.bean.Drive" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports & Statistics - CampusConnect</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f4f4; }
        .header { background: linear-gradient(135deg, #2c3e50, #3498db); color: white; padding: 30px; text-align: center; }
        .header h1 { margin-bottom: 10px; }
        .container { max-width: 1400px; margin: 40px auto; padding: 20px; }
        
        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card h3 { color: #777; font-size: 14px; margin-bottom: 10px; text-transform: uppercase; }
        .stat-card .number { font-size: 48px; font-weight: bold; margin-bottom: 5px; }
        .stat-card.students .number { color: #27ae60; }
        .stat-card.drives .number { color: #f39c12; }
        .stat-card.companies .number { color: #9b59b6; }
        .stat-card.applications .number { color: #3498db; }
        .stat-card.selected .number { color: #e74c3c; }
        .stat-card.percentage .number { color: #27ae60; font-size: 36px; }
        
        /* Drive Status Cards */
        .drive-status { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px; }
        .status-card { background: white; padding: 20px; border-radius: 8px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .status-card.upcoming { border-left: 5px solid #3498db; }
        .status-card.ongoing { border-left: 5px solid #f39c12; }
        .status-card.completed { border-left: 5px solid #27ae60; }
        
        /* Quick Actions */
        .quick-actions { text-align: center; margin-bottom: 40px; }
        .quick-actions a { display: inline-block; padding: 12px 30px; margin: 0 10px; background: #3498db; color: white; text-decoration: none; border-radius: 6px; font-weight: 600; }
        .quick-actions a:hover { background: #2980b9; }
        
        /* Drive Table */
        .table-container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .table-container h2 { color: #2c3e50; margin-bottom: 20px; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        tr:hover { background: #f5f5f5; }
        .status-upcoming { color: #3498db; font-weight: bold; }
        .status-ongoing { color: #f39c12; font-weight: bold; }
        .status-completed { color: #27ae60; font-weight: bold; }
        
        .back-link { display: block; text-align: center; margin-top: 30px; color: #3498db; text-decoration: none; font-weight: 600; }
        .back-link:hover { text-decoration: underline; }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📊 Reports & Statistics</h1>
        <p>College Placement Overview</p>
    </div>

    <div class="container">
        <%-- ✅ FIX: Get stats with null check --%>
        <% 
            Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
            
            // If stats is null, create default values
            if (stats == null) {
                stats = new HashMap<>();
                stats.put("totalStudents", 0);
                stats.put("totalDrives", 0);
                stats.put("totalCompanies", 0);
                stats.put("totalApplications", 0);
                stats.put("totalSelected", 0);
                stats.put("totalShortlisted", 0);
                stats.put("upcomingDrives", 0);
                stats.put("ongoingDrives", 0);
                stats.put("completedDrives", 0);
                stats.put("placementPercentage", "0.00");
            }
        %>

        <%-- Check for error message --%>
        <% String errorMessage = (String) request.getAttribute("errorMessage");
           if (errorMessage != null) { %>
            <div class="error-message">
                <strong>️ Error:</strong> <%= errorMessage %>
            </div>
        <% } %>

        <!-- Main Statistics -->
        <div class="stats-grid">
            <div class="stat-card students">
                <h3>Total Students</h3>
                <div class="number">
                    <%= stats.get("totalStudents") != null ? stats.get("totalStudents") : "0" %>
                </div>
            </div>

            <div class="stat-card drives">
                <h3>Total Drives</h3>
                <div class="number">
                    <%= stats.get("totalDrives") != null ? stats.get("totalDrives") : "0" %>
                </div>
            </div>

            <div class="stat-card companies">
                <h3>Total Companies</h3>
                <div class="number">
                    <%= stats.get("totalCompanies") != null ? stats.get("totalCompanies") : "0" %>
                </div>
            </div>

            <div class="stat-card applications">
                <h3>Total Applications</h3>
                <div class="number">
                    <%= stats.get("totalApplications") != null ? stats.get("totalApplications") : "0" %>
                </div>
            </div>

            <div class="stat-card selected">
                <h3>Total Selected</h3>
                <div class="number">
                    <%= stats.get("totalSelected") != null ? stats.get("totalSelected") : "0" %>
                </div>
            </div>

            <div class="stat-card percentage">
                <h3>Placement %</h3>
                <div class="number">
                    <%= stats.get("placementPercentage") != null ? stats.get("placementPercentage") : "0.00" %>%
                </div>
            </div>
        </div>

        <!-- Drive Status Breakdown -->
        <div class="drive-status">
            <div class="status-card upcoming">
                <h3>🔵 Upcoming Drives</h3>
                <div style="font-size: 36px; font-weight: bold; color: #3498db; margin-top: 10px;">
                    <%= stats.get("upcomingDrives") != null ? stats.get("upcomingDrives") : "0" %>
                </div>
            </div>

            <div class="status-card ongoing">
                <h3>🟠 Ongoing Drives</h3>
                <div style="font-size: 36px; font-weight: bold; color: #f39c12; margin-top: 10px;">
                    <%= stats.get("ongoingDrives") != null ? stats.get("ongoingDrives") : "0" %>
                </div>
            </div>

            <div class="status-card completed">
                <h3>✅ Completed Drives</h3>
                <div style="font-size: 36px; font-weight: bold; color: #27ae60; margin-top: 10px;">
                    <%= stats.get("completedDrives") != null ? stats.get("completedDrives") : "0" %>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/ReportController?action=placementReport">📋 View Placement Report</a>
            <a href="${pageContext.request.contextPath}/ReportController?action=driveReport">📅 View Drive Report</a>
        </div>

        <!-- Recent Drives Table -->
        <div class="table-container">
            <h2>🎯 Recent Campus Drives</h2>
            
            <%-- ✅ FIX: Get driveList with null check --%>
            <% 
                List<Drive> drives = (List<Drive>) request.getAttribute("driveList");
                if (drives == null) {
                    drives = new ArrayList<>();  // ✅ Now ArrayList is imported
                }
            %>
            
            <% if(drives.isEmpty()) { %>
                <p style="text-align: center; color: #777; padding: 20px;">No drives available.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Company</th>
                            <th>Position</th>
                            <th>Drive Date</th>
                            <th>Package</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MMM-yyyy");
                        for(Drive d : drives) { 
                            String statusClass = "status-upcoming";
                            if(d.getStatus() != null) {
                                if("Ongoing".equals(d.getStatus())) statusClass = "status-ongoing";
                                if("Completed".equals(d.getStatus())) statusClass = "status-completed";
                            }
                        %>
                        <tr>
                            <td><strong><%= d.getCompanyName() != null ? d.getCompanyName() : "Unknown" %></strong></td>
                            <td><%= d.getPosition() != null ? d.getPosition() : "-" %></td>
                            <td><%= d.getDriveDate() != null ? sdf.format(d.getDriveDate()) : "-" %></td>
                            <td>₹<%= d.getPackageCtc() %> LPA</td>
                            <td><span class="<%= statusClass %>"><%= d.getStatus() != null ? d.getStatus() : "Unknown" %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <a href="${pageContext.request.contextPath}/CollegeAdminController?action=dashboard" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>