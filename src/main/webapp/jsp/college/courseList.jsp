<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.campusconnect.bean.Course" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course List - CampusConnect</title>
    <style>
        body { 
            font-family: Arial; 
            margin: 40px; 
            background: #f4f4f4; 
        }
        .container { 
            max-width: 1000px; 
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
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
        }
        th, td { 
            padding: 12px; 
            text-align: left; 
            border-bottom: 1px solid #ddd; 
        }
        th { 
            background: #3498db; 
            color: white; 
        }
        tr:hover { 
            background: #f5f5f5; 
        }
        .btn { 
            padding: 8px 15px; 
            text-decoration: none; 
            border-radius: 4px; 
            margin-right: 5px; 
            font-size: 14px;
            display: inline-block;
        }
        .btn-edit { 
            background: #f39c12; 
            color: white; 
        }
        .btn-delete { 
            background: #e74c3c; 
            color: white; 
        }
        .btn-add { 
            background: #27ae60; 
            color: white; 
            display: inline-block; 
            margin-bottom: 15px; 
            text-decoration: none;
        }
        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 20px; 
            color: #3498db;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📖 Course List</h2>

        <a href="${pageContext.request.contextPath}/CourseController?action=showAdd" class="btn btn-add">+ Add New Course</a>

        <% List<Course> courseList = (List<Course>) request.getAttribute("courseList");
        
           if(courseList == null || courseList.isEmpty()) { 
        %>
            <p style="text-align: center; color: #777; padding: 20px;">No courses found. Add your first course!</p>
        <% 
           } else { 
        %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Department ID</th>
                        <th>Course Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Course course : courseList) { %>
                        <tr>
                            <td><%= course.getCourseId() %></td>
                            <td><%= course.getDepartmentId() %></td>
                            <td><%= course.getCourseName() %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/CourseController?action=edit&courseId=<%= course.getCourseId() %>" 
                                   class="btn btn-edit">Edit</a>
                                <a href="${pageContext.request.contextPath}/CourseController?action=delete&courseId=<%= course.getCourseId() %>" 
                                   class="btn btn-delete" 
                                   onclick="return confirm('Are you sure you want to delete this course?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="${pageContext.request.contextPath}/CollegeAdminController?action=dashboard" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>