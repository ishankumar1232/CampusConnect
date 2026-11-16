# CampusConnect
### Centralized Multi-College Campus Placement & Recruitment Management System

---

## 📌 Project Overview
**CampusConnect** is a comprehensive, centralized web-based placement management platform designed to streamline and automate the campus recruitment and admission ecosystem across multiple colleges. 

The system bridges four primary stakeholders:
1. **Students** looking for campus placement opportunities and admission.
2. **College Administrators** managing departments, student verification, and on-campus drive coordination.
3. **Recruiting Companies** posting drives, screening applications, shortlisting candidates, scheduling interviews, and rolling out offers.
4. **Super Administrators** overseeing college/company approvals, platform analytics, system maintenance, and user management.

---

## 🏛️ System Architecture

The project strictly follows the standard **Model-View-Controller (MVC)** design pattern along with a dedicated **Data Access Object (DAO)** layer:

```
CampusConnect (MVC Architecture)
│
├── Model (com.campusconnect.bean)
│   ├── Student, College, Company, SuperAdmin
│   ├── RecruitmentDrive, StudentApplication, Admission
│   └── StudentAcademic, StudentSkill, StudentProject, StudentResume
│
├── Controller (com.campusconnect.controller & com.campusconnect.servlet)
│   ├── Authentication Servlets (Student, College, Company, Admin)
│   ├── Drive & Application Processing Controllers
│   └── Interview & Selection Management Controllers
│
├── DAO Layer (com.campusconnect.dao)
│   ├── Secure JDBC queries using PreparedStatement (SQL Injection prevention)
│   └── Database connectivity via DBConnection utility
│
└── View (src/main/webapp/)
    ├── Dynamic JSP Pages (.jsp)
    ├── Responsive Modern CSS (css/)
    └── Static Images & Branding Assets (images/ & image/)
```

---

## 🚀 Key Modules & Features

### 🎓 1. Student Portal
- **Registration & Authentication:** Secure session-based registration and login.
- **Academic & Skill Profile:** Manage semester-wise marks, CGPA, technical skills, projects, and resume uploads.
- **Placement Drives:** Browse active campus recruitment drives, view eligibility criteria, and apply with a single click.
- **Application Tracking:** Real-time visibility into application status (`APPLIED`, `SHORTLISTED`, `SCHEDULED`, `SELECTED`, `REJECTED`).
- **Interview & Offer Management:** Check interview dates, meeting links/venues, and view official job offers.

### 🏢 2. Company Portal
- **Drive Management:** Create and publish recruitment drives specifying job title, salary package, eligibility criteria, and deadlines.
- **Applicant Screening:** Filter applicants by college, CGPA, graduation year, and skill sets.
- **Shortlisting & Interviews:** Shortlist suitable candidates and schedule interview rounds (Round name, Date/Time, Mode: Online/Offline, Meeting link).
- **Offer Letters:** Issue final selection offers directly to qualified candidates.
- **Branding & Analytics:** Dynamic corporate dashboard with monogram fallback and recruitment reports.

### 🏫 3. College Administration
- **College Profile & Course Setup:** Manage departments, faculty members, courses, and admission fees.
- **Student Admissions:** Review pending admission applications and verify documents.
- **Placement Monitoring:** Track which students from the college are shortlisted or selected by recruiting companies.

### 🛡️ 4. Super Administrator
- **Verification & Approvals:** Verify and approve/reject newly registered colleges and companies before they can access the portal.
- **System Settings:** Global toggle for Maintenance Mode, system configurations, and security policies.
- **Reports & Audits:** Platform-wide analytics showing total colleges, registered companies, applied students, and successful selections.

---

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| **Language** | Java (JDK 17 / 21) |
| **Platform** | Jakarta EE (Servlet 6.0, JSP 3.1) |
| **Web Server** | Apache Tomcat 10.1 |
| **Database** | Oracle Database (XE / 10g / 11g / 19c) |
| **Database Driver** | Oracle JDBC Thin Driver (`ojdbc14.jar` / Type-4) |
| **Frontend** | HTML5, CSS3, JavaScript (Responsive UI) |
| **Development Environment** | Eclipse IDE for Enterprise Java and Web Developers |
| **Version Control** | Git & GitHub |

---

## 🗄️ Database Configuration

Database connection settings are centralized in `src/main/resources/db.properties` and loaded by `com.campusconnect.util.DBConnection`:

```properties
db.url=jdbc:oracle:thin:@localhost:1521:XE
db.user=CAMPUSCONNECT
db.password=campus123
```

All SQL statements utilize `PreparedStatement` with parameterized placeholders (`?`) to ensure high performance and complete protection against SQL Injection vulnerabilities.

---

## ⚙️ How to Setup and Run

### Prerequisites
- **Eclipse IDE** (Enterprise Java and Web Developers edition)
- **Apache Tomcat 10.1** (or compatible Jakarta EE 10 servlet container)
- **Oracle Database XE** running on `localhost:1521`
- **JDK 17** or higher installed and configured in Eclipse

### Step-by-Step Execution:
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/ishankumar1232/CampusConnect.git
   ```

2. **Import into Eclipse:**
   - Open Eclipse IDE.
   - Go to `File` ➔ `Import...` ➔ `General` ➔ `Existing Projects into Workspace`.
   - Select the cloned `CampusConnect` directory and click **Finish**.

3. **Configure Tomcat Server:**
   - Open the **Servers** tab in Eclipse.
   - Right-click ➔ `New` ➔ `Server` ➔ Select `Apache Tomcat v10.1`.
   - Point to your local Tomcat installation directory.
   - Add `CampusConnect` into the configured resources.

4. **Run the Application:**
   - Right-click on the project in Project Explorer.
   - Select **Run As** ➔ **Run on Server**.
   - Open your browser and navigate to:
     ```
     http://localhost:8086/CampusConnect/
     ```
     *(or port `8080` depending on your Tomcat configuration)*

---

## 🔒 Security & Best Practices
- **Session Validation:** Mandatory session checks on all protected JSP pages to prevent unauthorized direct URL tampering.
- **SQL Injection Prevention:** 100% parameterized JDBC PreparedStatement queries across all DAOs.
- **Input Sanitization:** HTML escaping mechanisms on dynamic views to prevent Cross-Site Scripting (XSS).
- **Maintenance Guard:** Centralized application lock-down when maintenance mode is toggled by Super Admin.

---

## 📄 License
This project is developed for educational, academic, and campus placement management purposes.
