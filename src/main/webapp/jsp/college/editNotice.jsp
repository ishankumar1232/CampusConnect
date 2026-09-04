<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.Notice" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Notice - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            margin: 40px; 
            background: #f4f4f4; 
        }
        .container { 
            max-width: 600px; 
            margin: auto; 
            background: white; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        h2 { 
            text-align: center; 
            color: #2c3e50; 
        }
        .form-group { 
            margin-bottom: 15px; 
        }
        label { 
            display: block; 
            margin-bottom: 5px; 
            font-weight: bold; 
        }
        input, textarea, select { 
            width: 100%; 
            padding: 10px; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            box-sizing: border-box; 
        }
        textarea { 
            height: 100px; 
            resize: vertical;
        }
        button { 
            width: 100%; 
            padding: 12px; 
            background: #3498db; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px; 
        }
        button:hover { 
            background: #2980b9; 
        }
        .message { 
            color: red; 
            text-align: center; 
            margin-bottom: 15px; 
        }
        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 15px; 
            color: #3498db; 
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%-- Get Notice object from request attribute --%>
    <% Notice notice = (Notice) request.getAttribute("notice"); %>
    
    <div class="container">
        <h2>📢 Edit Notice</h2>

        <%-- Display Error Message if any --%>
        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <%-- Check if notice object exists --%>
        <% if(notice != null) { %>
            
            <form action="NoticeController" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="noticeId" value="<%= notice.getNoticeId() %>">

                <div class="form-group">
                    <label>College ID:</label>
                    <input type="number" name="collegeId" value="<%= notice.getCollegeId() %>" required>
                </div>

                <div class="form-group">
                    <label>Title:</label>
                    <input type="text" name="title" value="<%= notice.getTitle() %>" required>
                </div>

                <div class="form-group">
                    <label>Content:</label>
                    <textarea name="content" required><%= notice.getDescription() %></textarea>
                </div>

                <div class="form-group">
                    <label>Status:</label>
                    <select name="status" required>
                        <option value="Active" <%= "Active".equals(notice.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(notice.getStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>

                <button type="submit">Update Notice</button>
            </form>

        <% } else { %>
            <p style="text-align: center; color: red;">Notice not found!</p>
        <% } %>

        
<a href="${pageContext.request.contextPath}/NoticeController?action=list">← Back to Notice List</a>
    </div>
</body>
</html>