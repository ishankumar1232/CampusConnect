<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.College" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Profile - CampusConnect</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            background: linear-gradient(135deg, #f4f4f4, #e0e0e0);
            min-height: 100vh;
            padding: 20px;
        }
        .container { 
            max-width: 700px; 
            margin: 40px auto; 
            background: white; 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 8px 30px rgba(0,0,0,0.12); 
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        h2 { 
            text-align: center; 
            color: #2c3e50; 
            font-size: 28px;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #777;
            font-size: 14px;
        }
        .form-group { 
            margin-bottom: 20px; 
        }
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #2c3e50;
            font-size: 14px;
        }
        .value { 
            padding: 12px 15px; 
            background: #f8f9fa; 
            border-radius: 6px; 
            font-size: 15px;
            color: #2c3e50;
            border: 1px solid #e0e0e0;
        }
        .edit-section {
            display: none;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #3498db;
        }
        input { 
            width: 100%; 
            padding: 12px 15px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            box-sizing: border-box; 
            font-size: 14px;
            transition: all 0.3s ease;
        }
        input:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.2);
        }
        input[readonly] {
            background: #f5f5f5;
            cursor: not-allowed;
            color: #777;
        }
        .btn {
            width: 100%; 
            padding: 14px; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 15px; 
            font-weight: 600;
            margin-top: 15px;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, #1c6ea4);
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.4);
            transform: translateY(-2px);
        }
        .btn-warning {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
            box-shadow: 0 4px 10px rgba(243, 156, 18, 0.3);
        }
        .btn-warning:hover {
            background: linear-gradient(135deg, #e67e22, #d35400);
            box-shadow: 0 6px 15px rgba(243, 156, 18, 0.4);
            transform: translateY(-2px);
        }
        .btn-success {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
            box-shadow: 0 4px 10px rgba(39, 174, 96, 0.3);
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #229954, #1e8449);
            box-shadow: 0 6px 15px rgba(39, 174, 96, 0.4);
            transform: translateY(-2px);
        }
        .btn-danger {
            background: #e0e0e0;
            color: #777;
            border: 1px solid #ccc;
        }
        .btn-danger:hover {
            background: #d0d0d0;
        }
        .message { 
            text-align: center; 
            margin-bottom: 20px; 
            padding: 15px;
            border-radius: 6px;
            font-weight: 500;
        }
        .message-success {
            color: #27ae60; 
            background: #eafaf1;
            border: 1px solid #27ae60;
        }
        .message-error {
            color: #e74c3c; 
            background: #fdeaea;
            border: 1px solid #e74c3c;
        }
        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 25px; 
            color: #3498db; 
            text-decoration: none;
            font-weight: 600;
            padding: 10px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        .back-link:hover {
            text-decoration: none;
            background: #f0f8ff;
            color: #2980b9;
        }
        .info-box {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            padding: 20px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 14px;
            color: #856404;
            border-left: 4px solid #f39c12;
        }
        .info-box strong {
            display: block;
            margin-bottom: 5px;
        }
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        .button-group .btn {
            flex: 1;
            margin-top: 0;
        }
        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 25px;
                margin: 20px auto;
            }
            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <% College college = (College) request.getAttribute("college"); %>
    
    <div class="container">
        <div class="header">
            <h2>️ College Profile</h2>
            <p class="subtitle">View and edit your college information</p>
        </div>

        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message message-success"><%= msg %></div>
        <% } %>

        <div class="info-box">
            <strong>ℹ️ Information:</strong>
            You can view and edit your college profile details. Changes will be updated immediately.
        </div>

        <% if(college != null) { %>
            
            <!-- View Mode -->
            <div id="viewMode">
                <div class="form-group">
                    <label>College ID:</label>
                    <div class="value"><%= college.getCollegeId() %></div>
                </div>

                <div class="form-group">
                    <label>College Name:</label>
                    <div class="value"><%= college.getCollegeName() %></div>
                </div>

                <div class="form-group">
                    <label>Address:</label>
                    <div class="value"><%= college.getAddress() %></div>
                </div>

                <div class="form-group">
                    <label>City:</label>
                    <div class="value"><%= college.getCity() %></div>
                </div>

                <div class="form-group">
                    <label>State:</label>
                    <div class="value"><%= college.getState() %></div>
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <div class="value"><%= college.getEmail() %></div>
                </div>

                <div class="form-group">
                    <label>Phone:</label>
                    <div class="value"><%= college.getPhone() %></div>
                </div>

                <div class="form-group">
                    <label>Status:</label>
                    <div class="value">
                        <% if("Active".equals(college.getStatus())) { %>
                            <span style="color: #27ae60; font-weight: bold;">✓ Active</span>
                        <% } else { %>
                            <span style="color: #e74c3c; font-weight: bold;">✗ Inactive</span>
                        <% } %>
                    </div>
                </div>

                <button type="button" class="btn btn-warning" onclick="toggleEdit()">️ Edit Profile</button>
            </div>

            <!-- Edit Mode -->
            <div id="editMode" class="edit-section">
                <h3 style="color: #3498db; margin-bottom: 20px; text-align: center;">Edit College Information</h3>
                
                <form action="${pageContext.request.contextPath}/CollegeController" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <input type="hidden" name="collegeId" value="<%= college.getCollegeId() %>">

                    <div class="form-group">
                        <label>College ID:</label>
                        <input type="text" value="<%= college.getCollegeId() %>" readonly>
                    </div>

                    <div class="form-group">
                        <label>College Name:</label>
                        <input type="text" name="collegeName" value="<%= college.getCollegeName() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Address:</label>
                        <input type="text" name="address" value="<%= college.getAddress() %>" required>
                    </div>

                    <div class="form-group">
                        <label>City:</label>
                        <input type="text" name="city" value="<%= college.getCity() %>" required>
                    </div>

                    <div class="form-group">
                        <label>State:</label>
                        <input type="text" name="state" value="<%= college.getState() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="email" value="<%= college.getEmail() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Phone:</label>
                        <input type="text" name="phone" value="<%= college.getPhone() %>" required>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-success">💾 Save Changes</button>
                        <button type="button" class="btn btn-danger" onclick="toggleEdit()">❌ Cancel</button>
                    </div>
                </form>
            </div>

        <% } else { %>
            <div class="message message-error">
                <strong>️ College Profile Not Found!</strong><br>
                Your college profile is not available in the system. Please contact the Super Administrator.
            </div>
        <% } %>

        <a href="${pageContext.request.contextPath}/CollegeAdminController?action=dashboard" class="back-link">← Back to Dashboard</a>
    </div>

    <script>
        function toggleEdit() {
            var viewMode = document.getElementById('viewMode');
            var editMode = document.getElementById('editMode');
            
            if (viewMode.style.display === 'none') {
                viewMode.style.display = 'block';
                editMode.style.display = 'none';
            } else {
                viewMode.style.display = 'none';
                editMode.style.display = 'block';
            }
        }
    </script>
</body>
</html>