package com.campusconnect.controller;

import com.campusconnect.bean.CollegeAdmin;
import com.campusconnect.bean.Student;
import com.campusconnect.bean.Drive;
import com.campusconnect.bean.Application;
import com.campusconnect.dao.StudentDAO;
import com.campusconnect.dao.DriveDAO;
import com.campusconnect.dao.ApplicationDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/StudentController")
public class StudentController extends HttpServlet {

    StudentDAO dao = new StudentDAO();

    //====================================
    // HANDLE GET REQUESTS
    //====================================
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // === STUDENT PORTAL ACTIONS ===
        if ("showLogin".equals(action)) {
            req.getRequestDispatcher("/jsp/student/studentLogin.jsp").forward(req, resp);
        } else if ("showRegister".equals(action)) {
            req.getRequestDispatcher("/jsp/student/studentRegister.jsp").forward(req, resp);
        } else if ("dashboard".equals(action)) {
            studentDashboard(req, resp);
        } else if ("apply".equals(action)) {
            applyForDrive(req, resp);
        } else if ("viewStatus".equals(action)) {
            viewApplicationStatus(req, resp);
        } else if ("logout".equals(action)) {
            studentLogout(req, resp);
        } 
        
        // === ADMIN ACTIONS (Manage Students) ===
        else if ("list".equals(action) || action == null) {
            listStudents(req, resp);
        } else if ("edit".equals(action)) {
            editStudent(req, resp);
        } else if ("delete".equals(action)) {
            deleteStudent(req, resp);
        } else if ("showAdd".equals(action)) {
            req.getRequestDispatcher("/jsp/college/addStudent.jsp").forward(req, resp);
        }
    }

    //====================================
    // HANDLE POST REQUESTS
    //====================================
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // === STUDENT PORTAL ACTIONS ===
        if ("login".equals(action)) {
            studentLogin(req, resp);
        } else if ("register".equals(action)) {
            studentRegister(req, resp);
        } 
        
        // === ADMIN ACTIONS ===
        else if ("add".equals(action)) {
            addStudent(req, resp);
        } else if ("update".equals(action)) {
            updateStudent(req, resp);
        }
    }

    //====================================
    // STUDENT PORTAL: LOGIN
    //====================================
    private void studentLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        List<Student> allStudents = dao.getAllStudents();
        Student student = null;
        
        for (Student s : allStudents) {
            if (s.getEmail().equals(email) && s.getPassword().equals(password) && "Active".equals(s.getStatus())) {
                student = s;
                break;
            }
        }

        if (student != null) {
            HttpSession session = req.getSession();
            session.setAttribute("student", student);
            resp.sendRedirect("StudentController?action=dashboard");
        } else {
            req.setAttribute("message", "Invalid Email or Password!");
            req.getRequestDispatcher("/jsp/student/studentLogin.jsp").forward(req, resp);
        }
    }

    //====================================
    // STUDENT PORTAL: REGISTER
    //====================================
    private void studentRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        int collegeId = Integer.parseInt(req.getParameter("collegeId"));
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        int year = Integer.parseInt(req.getParameter("year"));
        double cgpa = Double.parseDouble(req.getParameter("cgpa"));

        // Check if email already exists
        List<Student> allStudents = dao.getAllStudents();
        for (Student s : allStudents) {
            if (s.getEmail().equals(email)) {
                req.setAttribute("message", "Email already registered!");
                req.getRequestDispatcher("/jsp/student/studentRegister.jsp").forward(req, resp);
                return;
            }
        }

        Student student = new Student(name, email, password, phone, collegeId, departmentId, courseId, year, cgpa, "Active");
        boolean result = dao.addStudent(student);

        if (result) {
            req.setAttribute("message", "Registration Successful! Please Login.");
            req.getRequestDispatcher("/jsp/student/studentLogin.jsp").forward(req, resp);
        } else {
            req.setAttribute("message", "Registration Failed!");
            req.getRequestDispatcher("/jsp/student/studentRegister.jsp").forward(req, resp);
        }
    }

    //====================================
    // STUDENT PORTAL: DASHBOARD
    //====================================
    private void studentDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Student student = (Student) session.getAttribute("student");

        if (student != null) {
            DriveDAO driveDao = new DriveDAO();
            List<Drive> drives = driveDao.getDrivesByCollege(student.getCollegeId());
            req.setAttribute("driveList", drives);
            req.getRequestDispatcher("/jsp/student/studentDashboard.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("StudentController?action=showLogin");
        }
    }

    //====================================
    // STUDENT PORTAL: APPLY FOR DRIVE
    //====================================
    private void applyForDrive(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Student student = (Student) session.getAttribute("student");
        
        if (student != null) {
            int driveId = Integer.parseInt(req.getParameter("driveId"));
            
            ApplicationDAO appDao = new ApplicationDAO();
            Application app = new Application();
            app.setStudentId(student.getStudentId());
            app.setDriveId(driveId);
            app.setStatus("Applied");
            
            boolean result = appDao.addApplication(app);
            
            if (result) {
                resp.sendRedirect("StudentController?action=dashboard");
            } else {
                req.setAttribute("message", "Failed to apply!");
                studentDashboard(req, resp);
            }
        } else {
            resp.sendRedirect("StudentController?action=showLogin");
        }
    }

    //====================================
    // STUDENT PORTAL: VIEW APPLICATION STATUS
    //====================================
    private void viewApplicationStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Student student = (Student) session.getAttribute("student");
        
        if (student != null) {
            ApplicationDAO appDao = new ApplicationDAO();
            List<Application> applications = appDao.getApplicationsByStudent(student.getStudentId());
            req.setAttribute("appList", applications);
            req.getRequestDispatcher("/jsp/student/applicationStatus.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("StudentController?action=showLogin");
        }
    }

    //====================================
    // STUDENT PORTAL: LOGOUT
    //====================================
    private void studentLogout(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        session.invalidate();
        resp.sendRedirect("StudentController?action=showLogin");
    }

    //====================================
    // ADMIN: LIST STUDENTS
    //====================================
    private void listStudents(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        if (admin != null && admin.getCollegeId() > 0) {
            List<Student> allStudents = dao.getAllStudents();
            List<Student> filteredStudents = new ArrayList<>();
            
            for (Student student : allStudents) {
                if (student.getCollegeId() == admin.getCollegeId()) {
                    filteredStudents.add(student);
                }
            }
            
            req.setAttribute("studentList", filteredStudents);
            req.getRequestDispatcher("/jsp/college/studentList.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
        }
    }

    //====================================
    // ADMIN: ADD STUDENT
    //====================================
    private void addStudent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        CollegeAdmin admin = (CollegeAdmin) session.getAttribute("admin");
        
        if (admin != null && admin.getCollegeId() > 0) {
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String phone = req.getParameter("phone");
            int departmentId = Integer.parseInt(req.getParameter("departmentId"));
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            int year = Integer.parseInt(req.getParameter("year"));
            double cgpa = Double.parseDouble(req.getParameter("cgpa"));
            String status = req.getParameter("status");

            Student student = new Student(name, email, password, phone, 
                                        admin.getCollegeId(), departmentId, courseId, year, cgpa, status);

            boolean result = dao.addStudent(student);

            if (result) {
                resp.sendRedirect("StudentController?action=list");
            } else {
                req.setAttribute("message", "Failed to add student!");
                req.getRequestDispatcher("/jsp/college/addStudent.jsp").forward(req, resp);
            }
        } else {
            resp.sendRedirect("CollegeAdminController?action=showLogin");
        }
    }

    //====================================
    // ADMIN: EDIT STUDENT
    //====================================
    private void editStudent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int studentId = Integer.parseInt(req.getParameter("studentId"));
        Student student = dao.getStudentById(studentId);

        req.setAttribute("student", student);
        req.getRequestDispatcher("/jsp/college/editStudent.jsp").forward(req, resp);
    }

    //====================================
    // ADMIN: UPDATE STUDENT
    //====================================
    private void updateStudent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int studentId = Integer.parseInt(req.getParameter("studentId"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        int departmentId = Integer.parseInt(req.getParameter("departmentId"));
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        int year = Integer.parseInt(req.getParameter("year"));
        double cgpa = Double.parseDouble(req.getParameter("cgpa"));
        String status = req.getParameter("status");

        Student student = new Student(name, email, "", phone, 0, departmentId, courseId, year, cgpa, status);
        student.setStudentId(studentId);

        boolean result = dao.updateStudent(student);

        if (result) {
            resp.sendRedirect("StudentController?action=list");
        } else {
            req.setAttribute("message", "Failed to update student!");
            req.getRequestDispatcher("/jsp/college/editStudent.jsp").forward(req, resp);
        }
    }

    //====================================
    // ADMIN: DELETE STUDENT
    //====================================
    private void deleteStudent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int studentId = Integer.parseInt(req.getParameter("studentId"));

        boolean result = dao.deleteStudent(studentId);

        if (result) {
            resp.sendRedirect("StudentController?action=list");
        } else {
            req.setAttribute("message", "Failed to delete student!");
            listStudents(req, resp);
        }
    }
}