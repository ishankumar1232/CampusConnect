<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.CollegeAdmin" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>College Admin Dashboard - CampusConnect</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            background: #f4f4f4; 
        }
        .header { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
            color: white; 
            padding: 30px 20px; 
            text-align: center; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header h1 {
            margin: 0;
            font-size: 32px;
            font-weight: 600;
        }
        .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 16px;
        }
        .container { 
            max-width: 1200px; 
            margin: 40px auto; 
            padding: 20px; 
        }
        .menu-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
            gap: 25px; 
        }
        .menu-card { 
            background: white; 
            padding: 35px 25px; 
            border-radius: 12px; 
            text-align: center; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.08); 
            transition: all 0.3s ease;
            border: 1px solid #e0e0e0;
        }
        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .menu-card .icon {
            font-size: 50px;
            margin-bottom: 15px;
            display: block;
        }
        .menu-card h3 { 
            color: #2c3e50; 
            margin-bottom: 20px; 
            font-size: 20px;
            font-weight: 600;
        }
        .menu-card button { 
            padding: 12px 30px; 
            background: linear-gradient(135deg, #3498db, #2980b9); 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(52, 152, 219, 0.3);
        }
        .menu-card button:hover { 
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.4);
            transform: scale(1.05);
        }
        .logout { 
            display: block; 
            text-align: center; 
            margin-top: 50px; 
            padding: 20px;
            border-top: 1px solid #e0e0e0;
        }
        .logout a { 
            color: #e74c3c; 
            text-decoration: none; 
            font-weight: 600;
            font-size: 16px;
            padding: 10px 25px;
            border: 2px solid #e74c3c;
            border-radius: 6px;
            transition: all 0.3s ease;
            display: inline-block;
        }
        .logout a:hover {
            background: #e74c3c;
            color: white;
            box-shadow: 0 4px 10px rgba(231, 76, 60, 0.3);
        }
        .welcome-info {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            text-align: center;
        }
        .welcome-info h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .welcome-info p {
            color: #777;
            font-size: 14px;
        }
        /* Responsive Design */
        @media (max-width: 768px) {
            .menu-grid {
                grid-template-columns: 1fr;
            }
            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <% 
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin"); 
        String adminName = (admin != null) ? admin.getName() : "Admin";
        String collegeName = (admin != null) ? admin.getCollegeName() : "College";
    %>
    
    <div class="header">
        <h1>🏫 College Admin Dashboard</h1>
        <p>Welcome, <%= adminName %> | <%= collegeName %></p>
    </div>

    <div class="container">
        <!-- Welcome Info -->
        <div class="welcome-info">
            <h2>Hello, <%= adminName %>!</h2>
            <p>Manage your college operations from here.</p>
        </div>

             <div class="menu-grid">
            <!-- College Profile -->
            <div class="menu-card">
                <span class="icon">🏛️</span>
                <h3>College Profile</h3>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/CollegeController?action=viewProfile'">View/Edit Profile</button>
            </div>

            <!-- Students -->
            <div class="menu-card">
                <span class="icon">👨🎓</span>
                <h3>Students</h3>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/StudentController?action=list'">Manage Students</button>
            </div>

            <!-- Departments -->
            <div class="menu-card">
                <span class="icon">📚</span>
                <h3>Departments</h3>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/DepartmentController?action=list'">View Departments</button>
            </div>

            <!-- Courses -->
            <div class="menu-card">
                <span class="icon">📖</span>
                <h3>Courses</h3>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/CourseController?action=list'">View Courses</button>
            </div>

            <!-- Faculty -->
            <div class="menu-card">
                <span class="icon">👨🏫</span>
                <h3>Faculty</h3>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/FacultyController?action=list'">View Faculty</button>
            </div>

            <!-- Companies (FIXED) -->
            <div class="menu-card">
                <span class="icon">🏢</span>
                <h3>Companies</h3>
                 <button onclick="window.location.href='${pageContext.request.contextPath}/CompanyController?action=list'">Manage</button>
</div>
            <!-- Campus Drives -->
            <div class="menu-card">
                <span class="icon">🎯</span>
                <h3>Campus Drives</h3>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/DriveController?action=list'">Manage Drives</button>
            </div>

            <!-- Notices -->
            <div class="menu-card">
                <span class="icon">📢</span>
                <h3>Notices</h3>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/NoticeController?action=list'">View Notices</button>
            </div>
            <!-- Reports & Statistics -->
<div class="menu-card">
    <span class="icon">📊</span>
    <h3>Reports</h3>
    <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/ReportController?action=dashboard'">View Stats</button>
</div>
        </div>

        <div class="logout">
            <a href="${pageContext.request.contextPath}/CollegeAdminController?action=logout">🚪 Logout</a>
        </div>
    </div>
</body>
</html>