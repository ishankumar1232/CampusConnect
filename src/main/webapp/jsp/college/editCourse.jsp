<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.campusconnect.bean.Course" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Course - CampusConnect</title>
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
        input { 
            width: 100%; 
            padding: 10px; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            box-sizing: border-box; 
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
    <%-- Get Course object from request attribute --%>
    <% Course course = (Course) request.getAttribute("course"); %>
    
    <div class="container">
        <h2>📖 Edit Course</h2>

        <%-- Display Error Message if any --%>
        <% String msg = (String) request.getAttribute("message");
           if(msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <%-- Check if course object exists --%>
        <% if(course != null) { %>
            
            <form action="CourseController" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">

                <div class="form-group">
                    <label>Department ID:</label>
                    <input type="number" name="departmentId" value="<%= course.getDepartmentId() %>" required>
                </div>

                <div class="form-group">
                    <label>Course Name:</label>
                    <input type="text" name="courseName" value="<%= course.getCourseName() %>" required>
                </div>

                <button type="submit">Update Course</button>
            </form>

        <% } else { %>
            <p style="text-align: center; color: red;">Course not found!</p>
        <% } %>

<a href="${pageContext.request.contextPath}/CourseController?action=list">← Back to Course List</a>    </div>
</body>
</html>