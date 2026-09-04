<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.Company" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Management - CampusConnect</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f4f4f4; 
            min-height: 100vh;
        }
        .container { 
            max-width: 800px; 
            margin: 40px auto; 
            padding: 20px; 
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        h2 { 
            color: #2c3e50; 
            font-size: 28px;
            margin-bottom: 10px;
        }
        .form-card { 
            background: white; 
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
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
        input, select, textarea { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            font-size: 14px;
            transition: all 0.3s ease;
        }
        input:focus, select:focus, textarea:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.2);
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-right: 10px;
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
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        .btn-back {
            background: transparent;
            color: #3498db;
            text-decoration: none;
            padding: 12px 20px;
            display: inline-block;
            border-radius: 6px;
            margin-top: 15px;
        }
        .btn-back:hover {
            background: #f0f8ff;
        }
        .message {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        .message-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2 id="pageTitle">🏢 Add New Company</h2>
        </div>

        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message message-error"><%= msg %></div>
        <% } %>

        <div class="form-card">
            <!-- Edit Mode Form -->
            <div id="editForm" class="<%= request.getParameter("companyId") != null ? "" : "hidden" %>">
                <form action="${pageContext.request.contextPath}/CompanyController" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="companyId" value="<%= request.getParameter("companyId") != null ? request.getParameter("companyId") : "" %>">

                    <div class="form-group">
                        <label>Company Name:</label>
                        <input type="text" name="companyName" 
                               value="<%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getCompanyName() : "" %>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label>Industry:</label>
                        <input type="text" name="industry" 
                               value="<%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getIndustry() : "" %>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label>Website:</label>
                        <input type="url" name="website" 
                               value="<%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getWebsite() : "" %>">
                    </div>

                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="email" 
                               value="<%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getEmail() : "" %>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label>Phone:</label>
                        <input type="text" name="phone" 
                               value="<%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getPhone() : "" %>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label>Address:</label>
                        <textarea name="address"><%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getAddress() : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label>Description:</label>
                        <textarea name="description"><%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getDescription() : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label>Contact Person:</label>
                        <input type="text" name="contactPerson" 
                               value="<%= request.getAttribute("company") != null ? ((Company)request.getAttribute("company")).getContactPerson() : "" %>">
                    </div>

                    <div class="form-group">
                        <label>Status:</label>
                        <select name="status" required>
                            <option value="Active" <%= request.getAttribute("company") != null && "Active".equals(((Company)request.getAttribute("company")).getStatus()) ? "selected" : "" %>>Active</option>
                            <option value="Inactive" <%= request.getAttribute("company") != null && "Inactive".equals(((Company)request.getAttribute("company")).getStatus()) ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>

                    <div style="margin-top: 25px;">
                        <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                        <a href="${pageContext.request.contextPath}/CompanyController?action=list" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>

            <!-- Add Mode Form -->
            <div id="addForm" class="<%= request.getParameter("companyId") == null ? "" : "hidden" %>">
                <form action="${pageContext.request.contextPath}/CompanyController" method="post">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label>Company Name:</label>
                        <input type="text" name="companyName" required>
                    </div>

                    <div class="form-group">
                        <label>Industry:</label>
                        <input type="text" name="industry" required>
                    </div>

                    <div class="form-group">
                        <label>Website:</label>
                        <input type="url" name="website">
                    </div>

                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label>Phone:</label>
                        <input type="text" name="phone" required>
                    </div>

                    <div class="form-group">
                        <label>Address:</label>
                        <textarea name="address"></textarea>
                    </div>

                    <div class="form-group">
                        <label>Description:</label>
                        <textarea name="description"></textarea>
                    </div>

                    <div class="form-group">
                        <label>Contact Person:</label>
                        <input type="text" name="contactPerson">
                    </div>

                    <div class="form-group">
                        <label>Status:</label>
                        <select name="status" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>

                    <div style="margin-top: 25px;">
                        <button type="submit" class="btn btn-primary">➕ Add Company</button>
                        <a href="${pageContext.request.contextPath}/CompanyController?action=list" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/CompanyController?action=list" class="btn-back">← Back to Company List</a>
        </div>
    </div>

    <script>
        // Auto-hide success messages after 5 seconds
        window.onload = function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                setTimeout(function() {
                    msg.style.display = 'none';
                }, 5000);
            });
        };
    </script>
</body>
</html>