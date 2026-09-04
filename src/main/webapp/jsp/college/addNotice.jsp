<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Notice - CampusConnect</title>
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
        }
        button { 
            width: 100%; 
            padding: 12px; 
            background: #27ae60; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px; 
        }
        button:hover { 
            background: #219a52; 
        }
        .message { 
            color: red; 
            text-align: center; 
            margin-bottom: 15px; 
            padding: 10px;
            background: #fdeaea;
            border-radius: 4px;
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
    <div class="container">
        <h2>📢 Add New Notice</h2>

        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <!-- ✅ FIXED FORM ACTION -->
        <form action="${pageContext.request.contextPath}/NoticeController" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label>College ID:</label>
                <input type="number" name="collegeId" required>
            </div>

            <div class="form-group">
                <label>Admin ID:</label>
                <input type="number" name="adminId" required>
            </div>

            <div class="form-group">
                <label>Title:</label>
                <input type="text" name="title" required>
            </div>

            <div class="form-group">
                <label>Description:</label>
                <textarea name="description" required></textarea>
            </div>

            <div class="form-group">
                <label>Notice Type:</label>
                <select name="noticeType" required>
                    <option value="Recruitment">Recruitment</option>
                    <option value="Exam">Exam</option>
                    <option value="Holiday">Holiday</option>
                    <option value="General">General</option>
                </select>
            </div>

            <div class="form-group">
                <label>Attachment Path (Optional):</label>
                <input type="text" name="attachmentPath">
            </div>

            <div class="form-group">
                <label>Expiry Date:</label>
                <input type="date" name="expiryDate">
            </div>

            <div class="form-group">
                <label>Status:</label>
                <select name="status" required>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <button type="submit">Add Notice</button>
        </form>

        <!-- ✅ ADDED BACK LINK -->
        <a href="${pageContext.request.contextPath}/NoticeController?action=list" class="back-link">← Back to Notice List</a>
    </div>
</body>
</html>