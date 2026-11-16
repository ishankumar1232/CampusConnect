<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%

    Integer collegeId =
        (Integer) session.getAttribute("collegeId");

    String adminName =
        (String) session.getAttribute("adminName");

    if(collegeId == null)
    {
        response.sendRedirect("collegeAdminLogin.jsp");
        return;
    }

    double defaultFee = 50000.0;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (Connection conDef = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE",
                "CAMPUSCONNECT",
                "campus123");
             PreparedStatement psDef = conDef.prepareStatement(
                "SELECT NVL(DEFAULT_ADMISSION_FEE, 50000) FROM COLLEGE WHERE COLLEGE_ID=?")) {
            psDef.setInt(1, collegeId);
            try (ResultSet rsDef = psDef.executeQuery()) {
                if (rsDef.next()) {
                    defaultFee = rsDef.getDouble(1);
                }
            }
        }
    } catch (Exception e) {
        // Fallback default
    }

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Admission Management</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>

/* ==============================
   BASIC
============================== */

* {
    box-sizing: border-box;
}

body {

    margin: 0;

    font-family: Arial, sans-serif;

    background: #f4f7fb;

    color: #183b5b;

}

/* ==============================
   HEADER
============================== */

.header {

    background: linear-gradient(
        135deg,
        #07385e,
        #0d5b8f
    );

    color: white;

    padding: 22px 35px;

    display: flex;

    align-items: center;

    gap: 15px;

    box-shadow:
        0 3px 12px rgba(0,0,0,0.12);

}

.header-icon {

    width: 52px;

    height: 52px;

    border-radius: 13px;

    background: rgba(255,255,255,0.15);

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 28px;

}

.header h1 {

    margin: 0;

    font-size: 29px;

}

.header p {

    margin: 5px 0 0;

    font-size: 13px;

    color: #c9deec;

}

/* ==============================
   CONTAINER
============================== */

.container {

    width: 94%;

    max-width: 1450px;

    margin: 25px auto 50px;

}

/* ==============================
   BACK
============================== */

.back {

    margin-bottom: 20px;

}

.back a {

    text-decoration: none;

    color: #1685ed;

    font-size: 15px;

    font-weight: bold;

    padding: 9px 14px;

    border-radius: 8px;

    display: inline-block;

}

.back a:hover {

    background: #e8f4fc;

}

/* ==============================
   PAGE TITLE
============================== */

.page-title {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 20px;

}

.page-title h2 {

    margin: 0;

    color: #183f60;

    font-size: 25px;

}

.page-title p {

    margin: 7px 0 0;

    color: #718493;

    font-size: 13px;

}

/* ==============================
   TABLE CARD
============================== */

.table-card {

    background: white;

    border-radius: 16px;

    border: 1px solid #e1eaf1;

    box-shadow:
        0 5px 18px rgba(0,0,0,0.07);

    overflow: hidden;

}

/* ==============================
   TABLE TOP
============================== */

.table-header {

    padding: 20px 23px;

    border-bottom: 1px solid #e8eef3;

    display: flex;

    justify-content: space-between;

    align-items: center;

}

.table-header h3 {

    margin: 0;

    color: #183f60;

    font-size: 18px;

}

.college-id {

    color: #718493;

    font-size: 12px;

}

/* ==============================
   TABLE
============================== */

.table-wrapper {

    width: 100%;

    overflow-x: auto;

}

table {

    width: 100%;

    min-width: 1050px;

    border-collapse: collapse;

}

th {

    background: #0d78b5;

    color: white;

    padding: 15px 12px;

    font-size: 13px;

    text-align: center;

    white-space: nowrap;

}

td {

    padding: 15px 12px;

    border-bottom: 1px solid #edf1f4;

    text-align: center;

    font-size: 13px;

    color: #43596a;

}

tbody tr:hover {

    background: #f7fbfe;

}

tbody tr:last-child td {

    border-bottom: none;

}

/* ==============================
   ADMISSION ID
============================== */

.admission-id {

    color: #1685ed;

    font-weight: bold;

}

/* ==============================
   NAME
============================== */

.applicant-name {

    color: #294b63;

    font-weight: bold;

}

/* ==============================
   EMAIL
============================== */

.email {

    color: #61788a;

}

/* ==============================
   STATUS
============================== */

.status {

    display: inline-block;

    padding: 6px 12px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;

}

.pending {

    background: #fff1d8;

    color: #c87500;

}

/* ==============================
   ACTION
============================== */

.action {

    white-space: nowrap;

}

.action form {

    display: inline;

}

.approve-btn {

    border: none;

    background: #18a957;

    color: white;

    padding: 8px 13px;

    border-radius: 6px;

    font-size: 12px;

    font-weight: bold;

    cursor: pointer;

    margin-right: 5px;

}

.approve-btn:hover {

    background: #128a45;

}

.reject-btn {

    border: none;

    background: #e84c4c;

    color: white;

    padding: 8px 13px;

    border-radius: 6px;

    font-size: 12px;

    font-weight: bold;

    cursor: pointer;

}

.reject-btn:hover {

    background: #c93737;

}

/* ==============================
   EMPTY
============================== */

.empty {

    padding: 65px 20px;

    text-align: center;

}

.empty-icon {

    width: 65px;

    height: 65px;

    margin: auto;

    border-radius: 50%;

    background: #eaf5ff;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 30px;

}

.empty h3 {

    margin: 15px 0 7px;

    color: #34546b;

}

.empty p {

    margin: 0;

    color: #8494a0;

    font-size: 13px;

}

/* ==============================
   NOTE
============================== */

.note {

    margin-top: 18px;

    padding: 14px 17px;

    background: #eff8ff;

    border-left: 4px solid #1685ed;

    border-radius: 8px;

    color: #627787;

    font-size: 12px;

    line-height: 1.6;

}

/* ==============================
   MOBILE
============================== */

@media(max-width: 700px)
{

    .header {

        padding: 18px;

    }

    .header h1 {

        font-size: 22px;

    }

    .container {

        width: 94%;

    }

    .page-title {

        display: block;

    }

}

</style>

</head>

<body>

<!-- ==============================
     HEADER
============================== -->

<div class="header">

    <div class="header-icon">

        🎓

    </div>

    <div>

        <h1>
            Admission Management
        </h1>

        <p>
            Review and manage student admission requests
        </p>

    </div>

</div>

<!-- ==============================
     MAIN CONTAINER
============================== -->

<div class="container">

    <!-- BACK -->

    <div class="back">

        <a href="collegeAdminDashboard.jsp">

            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard

        </a>

    </div>

    <!-- PAGE TITLE -->

    <div class="page-title">

        <div>

            <h2>
                📋 Pending Admission Requests
            </h2>

            <p>
                Review applications submitted to your college.
            </p>

        </div>

    </div>

    <!-- ==============================
         TABLE CARD
    ============================== -->

    <div class="table-card">

        <div class="table-header">

            <h3>
                🎓 Admission Applications
            </h3>

            <div style="display:flex; align-items:center; gap:15px; flex-wrap:wrap;">

                <div style="background:#eaf5ff; border:1px solid #bcdbf7; color:#0e5a9b; padding:6px 14px; border-radius:8px; font-size:13px; font-weight:600;">
                    College Default Fee: <strong>₹<%=String.format("%,.0f", defaultFee)%></strong>
                    <a href="collegeProfile.jsp" style="margin-left:8px; color:#1685ed; text-decoration:underline; font-size:12px;">Edit in Profile</a>
                </div>

                <div class="college-id">

                    College ID:
                    <strong>
                        <%=collegeId%>
                    </strong>

                </div>

            </div>

        </div>

        <div class="table-wrapper">

        <%

            try
            {

                Class.forName(
                    "oracle.jdbc.driver.OracleDriver"
                );

                Connection con =
                    DriverManager.getConnection(

                        "jdbc:oracle:thin:@localhost:1521:XE",

                        "CAMPUSCONNECT",

                        "campus123"

                    );

                String sql =

                    "SELECT A.ADMISSION_ID, " +
                    "A.APPLICANT_NAME, " +
                    "A.APPLICANT_EMAIL, " +
                    "A.APPLICANT_PHONE, " +
                    "A.APPLICANT_COURSE_ID, " +
                    "A.ADMISSION_DATE, " +
                    "A.STATUS, " +
                    "NVL(A.ADMISSION_FEE, NVL(C.DEFAULT_ADMISSION_FEE, 50000)) AS DECIDED_FEE, " +
                    "CO.COURSE_NAME " +

                    "FROM ADMISSION A " +
                    "JOIN COLLEGE C ON A.COLLEGE_ID = C.COLLEGE_ID " +
                    "LEFT JOIN COURSE CO ON A.APPLICANT_COURSE_ID = CO.COURSE_ID " +

                    "WHERE A.COLLEGE_ID=? " +
                    "AND A.STATUS='PENDING' " +

                    "ORDER BY A.ADMISSION_ID";

                PreparedStatement ps =
                    con.prepareStatement(sql);

                ps.setInt(
                    1,
                    collegeId.intValue()
                );

                ResultSet rs =
                    ps.executeQuery();

                boolean found = false;

        %>

        <table>

            <tr>

                <th>
                    Admission ID
                </th>

                <th>
                    👤 Applicant Name
                </th>

                <th>
                    📧 Contact Info
                </th>

                <th>
                    📚 Course
                </th>

                <th>
                    📅 Date
                </th>

                <th>
                    Status
                </th>

                <th>
                    💰 Decided Fee (₹)
                </th>

                <th>
                    ⚙ Action
                </th>

            </tr>

        <%

                while(rs.next())
                {

                    found = true;

        %>

            <tr>

                <!-- ADMISSION ID -->

                <td>

                    <span class="admission-id">

                        #<%=rs.getInt("ADMISSION_ID")%>

                    </span>

                </td>

                <!-- NAME -->

                <td>

                    <span class="applicant-name">

                        <%=rs.getString("APPLICANT_NAME")%>

                    </span>

                </td>

                <!-- CONTACT -->

                <td>

                    <span class="email">

                        <%=rs.getString("APPLICANT_EMAIL")%>

                    </span>

                    <div style="font-size:12px; color:#718493; margin-top:3px;">
                        📞 <%=rs.getString("APPLICANT_PHONE")%>
                    </div>

                </td>

                <!-- COURSE -->

                <td>

                    <span style="display:inline-block; background:#eaf3fc; color:#1258c4; padding:5px 10px; border-radius:6px; font-weight:bold; font-size:12px;">
                        📚 <%= (rs.getString("COURSE_NAME") != null ? rs.getString("COURSE_NAME") : "Course #" + rs.getInt("APPLICANT_COURSE_ID")) %>
                    </span>

                </td>

                <!-- DATE -->

                <td>

                    <%=rs.getDate("ADMISSION_DATE")%>

                </td>

                <!-- STATUS -->

                <td>

                    <span class="status pending">

                        ⏳ <%=rs.getString("STATUS")%>

                    </span>

                </td>

                <!-- DECIDED FEE -->

                <td>

                    <div style="display:inline-flex; align-items:center; background:#f0f6ff; border:1px solid #c3daf5; border-radius:8px; padding:3px 8px;">

                        <span style="font-weight:bold; color:#1769e0; margin-right:4px;">
                            ₹
                        </span>

                        <input
                            type="number"
                            name="admissionFee"
                            form="approveForm_<%=rs.getInt("ADMISSION_ID")%>"
                            value="<%=String.format("%.0f", rs.getDouble("DECIDED_FEE"))%>"
                            min="0"
                            step="500"
                            style="width:95px; padding:6px 4px; border:none; background:transparent; font-weight:bold; color:#183f60; font-size:13px; outline:none;"
                            title="College decides this admission fee"
                            required
                        >

                    </div>

                </td>

                <!-- ACTION -->

                <td class="action">

                    <!-- APPROVE -->

                    <form
                        id="approveForm_<%=rs.getInt("ADMISSION_ID")%>"
                        action="AdmissionStatusController"
                        method="post"
                        style="display:inline;"
                    >

                        <input
                            type="hidden"
                            name="admissionId"
                            value="<%=rs.getInt("ADMISSION_ID")%>"
                        >

                        <input
                            type="hidden"
                            name="status"
                            value="APPROVED"
                        >

                        <button
                            type="submit"
                            class="approve-btn"
                            title="Approve with decided fee"
                        >

                            ✓ Approve

                        </button>

                    </form>

                    <!-- REJECT -->

                    <form
                        action="AdmissionStatusController"
                        method="post"
                        style="display:inline;"
                    >

                        <input
                            type="hidden"
                            name="admissionId"
                            value="<%=rs.getInt("ADMISSION_ID")%>"
                        >

                        <input
                            type="hidden"
                            name="status"
                            value="REJECTED"
                        >

                        <button
                            type="submit"
                            class="reject-btn"
                            onclick="return confirm('Are you sure you want to reject this admission request?');"
                        >

                            ✕ Reject

                        </button>

                    </form>

                </td>

            </tr>

        <%

                }

                if(!found)
                {

        %>

            <tr>

                <td colspan="8">

                    <div class="empty">

                        <div class="empty-icon">

                            📭

                        </div>

                        <h3>

                            No Pending Admissions

                        </h3>

                        <p>

                            There are currently no admission
                            requests waiting for approval.

                        </p>

                    </div>

                </td>

            </tr>

        <%

                }

                rs.close();

                ps.close();

                con.close();

            }
            catch(Exception e)
            {

        %>

            <tr>

                <td colspan="8">

                    <div class="empty">

                        <div class="empty-icon">

                            ⚠️

                        </div>

                        <h3>

                            Unable to Load Admissions

                        </h3>

                        <p>

                            Error:
                            <%=e.getMessage()%>

                        </p>

                    </div>

                </td>

            </tr>

        <%

            }

        %>

        </table>

        </div>

    </div>

    <!-- NOTE -->

    <div class="note">

        💡 <strong>Tip:</strong>

        Review the applicant details before approving
        or rejecting an admission request.

    </div>

</div>

</body>

</html>