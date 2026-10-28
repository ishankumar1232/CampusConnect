<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"

    import="java.sql.*" import="java.text.*" import="java.util.*"

    import="jakarta.servlet.http.HttpServletResponse"

    import="com.campusconnect.util.DBConnection" %>

<%!

    private String esc(String v) {

        if (v == null) return "";

        return v.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

                .replace("\"", "&quot;").replace("'", "&#39;");

    }

    private int number(String value, int fallback) {

        try { return Integer.parseInt(value); } catch (Exception e) { return fallback; }

    }

    private Timestamp parseStart(String value) throws Exception {

        SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

        f.setLenient(false);

        f.setTimeZone(TimeZone.getDefault());

        return new Timestamp(f.parse(value).getTime());

    }

    private String safeMessage(Exception e) {

        return e instanceof IllegalArgumentException ? e.getMessage() : "The action could not be completed. Please refresh and try again.";

    }

%>

<%

    Integer companyId = (Integer) session.getAttribute("companyId");

    if (companyId == null) { response.sendRedirect("company-login.jsp"); return; }

    String companyName = (String) session.getAttribute("companyName");

    if (companyName == null || companyName.trim().length() == 0) companyName = "Company";



    String csrf = (String) session.getAttribute("interviewCsrf");

    if (csrf == null) { csrf = UUID.randomUUID().toString(); session.setAttribute("interviewCsrf", csrf); }

    String flash = (String) session.getAttribute("interviewFlash");

    session.removeAttribute("interviewFlash");

    String error = null;

    Connection con = null;



    if ("POST".equalsIgnoreCase(request.getMethod())) {

        request.setCharacterEncoding("UTF-8");

        String submittedCsrf = request.getParameter("csrf");

        String action = request.getParameter("action");

        if (submittedCsrf == null || !csrf.equals(submittedCsrf)) {

            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Session token expired. Refresh and try again."); return;

        }

        try {

            con = DBConnection.getConnection();

            con.setAutoCommit(false);

            if ("schedule".equals(action)) {

                int appId = number(request.getParameter("applicationId"), 0);

                int interviewerId = number(request.getParameter("interviewerId"), 0);

                int roundNo = number(request.getParameter("roundNo"), 1);

                int duration = number(request.getParameter("duration"), 45);

                String mode = request.getParameter("mode");

                String location = request.getParameter("venueOrLink");

                String roundName = request.getParameter("roundName");

                String remarks = request.getParameter("remarks");

                Timestamp start = parseStart(request.getParameter("interviewDate"));

                if (appId <= 0 || roundNo < 1 || roundNo > 99 || duration < 15 || duration > 480)

                    throw new IllegalArgumentException("Check the candidate, round, and duration values.");

                if (start.getTime() <= System.currentTimeMillis()) throw new IllegalArgumentException("Choose a future interview time.");

                if (!("ONLINE".equals(mode) || "ONSITE".equals(mode) || "PHONE".equals(mode))) throw new IllegalArgumentException("Choose a valid interview mode.");

                if (location == null) location = "";

                location = location.trim();

                if (location.length() > 300) throw new IllegalArgumentException("The meeting link or venue must be 300 characters or fewer.");

                if (("ONLINE".equals(mode) && !location.matches("(?i)^https?://.+")) ||

                    ("ONSITE".equals(mode) && location.length() == 0))

                    throw new IllegalArgumentException("Online interviews need an http(s) link; onsite interviews need a venue.");

                if (roundName != null && roundName.length() > 50) throw new IllegalArgumentException("Round name is too long.");

                if (remarks != null && remarks.length() > 500) throw new IllegalArgumentException("Remarks must be 500 characters or fewer.");



                // Lock the application row after verifying this company owns its drive.

                String lockSql = "SELECT A.APPLICATION_ID FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID " +

                    "WHERE A.APPLICATION_ID=? AND D.COMPANY_ID=? AND UPPER(A.COLLEGE_SHORTLIST_STATUS)='SHORTLISTED' " +

                    "AND UPPER(NVL(A.STATUS,'PENDING')) NOT IN ('REJECTED','SELECTED') FOR UPDATE OF A.STATUS";

                try (PreparedStatement p = con.prepareStatement(lockSql)) {

                    p.setInt(1, appId); p.setInt(2, companyId);

                    try (ResultSet r = p.executeQuery()) { if (!r.next()) throw new IllegalArgumentException("This candidate is not available to schedule."); }

                }

                if (interviewerId > 0) {

                    try (PreparedStatement p = con.prepareStatement("SELECT INTERVIEWER_ID FROM INTERVIEWER WHERE INTERVIEWER_ID=? AND COMPANY_ID=? AND IS_ACTIVE='Y' FOR UPDATE")) {

                        p.setInt(1, interviewerId); p.setInt(2, companyId);

                        try (ResultSet r = p.executeQuery()) { if (!r.next()) throw new IllegalArgumentException("Choose an active interviewer from your company."); }

                    }

                }

                try (PreparedStatement p = con.prepareStatement("SELECT COUNT(*) FROM INTERVIEW WHERE APPLICATION_ID=? AND STATUS='SCHEDULED'")) {

                    p.setInt(1, appId); try (ResultSet r = p.executeQuery()) { r.next(); if (r.getInt(1) > 0) throw new IllegalArgumentException("This candidate already has a scheduled interview."); }

                }

                if (interviewerId > 0) {

                    String overlap = "SELECT COUNT(*) FROM INTERVIEW WHERE INTERVIEWER_ID=? AND STATUS='SCHEDULED' " +

                        "AND INTERVIEW_DATE < ? AND INTERVIEW_DATE + (DURATION_MIN/1440) > ?";

                    try (PreparedStatement p = con.prepareStatement(overlap)) {

                        p.setInt(1, interviewerId); p.setTimestamp(2, new Timestamp(start.getTime() + duration * 60000L)); p.setTimestamp(3, start);

                        try (ResultSet r = p.executeQuery()) { r.next(); if (r.getInt(1) > 0) throw new IllegalArgumentException("That interviewer has an overlapping interview."); }

                    }

                }

                String appOverlap = "SELECT COUNT(*) FROM INTERVIEW I JOIN APPLICATION A ON A.APPLICATION_ID=I.APPLICATION_ID " +

                    "JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID WHERE A.STUDENT_ID=(SELECT STUDENT_ID FROM APPLICATION WHERE APPLICATION_ID=?) " +

                    "AND D.COMPANY_ID=? AND I.STATUS='SCHEDULED' AND I.INTERVIEW_DATE < ? AND I.INTERVIEW_DATE+(I.DURATION_MIN/1440) > ?";

                try (PreparedStatement p = con.prepareStatement(appOverlap)) {

                    p.setInt(1, appId); p.setInt(2, companyId); p.setTimestamp(3, new Timestamp(start.getTime() + duration * 60000L)); p.setTimestamp(4, start);

                    try (ResultSet r = p.executeQuery()) { r.next(); if (r.getInt(1) > 0) throw new IllegalArgumentException("This candidate already has an overlapping interview with your company."); }

                }

                int interviewId;

                try (Statement s = con.createStatement(); ResultSet r = s.executeQuery("SELECT INTERVIEW_SEQ.NEXTVAL FROM DUAL")) {

                    if (!r.next()) throw new SQLException("Could not allocate interview number."); interviewId = r.getInt(1);

                }

                String insert = "INSERT INTO INTERVIEW (INTERVIEW_ID,APPLICATION_ID,INTERVIEW_DATE,INTERVIEW_MODE,VENUE_OR_LINK,STATUS,REMARKS,ROUND_NO,ROUND_NAME,DURATION_MIN,INTERVIEWER_ID,RESULT,RESCHEDULE_COUNT,CREATED_AT) VALUES (?,?,?,?,?,'SCHEDULED',?,?,?,?,?,'PENDING',0,SYSDATE)";

                try (PreparedStatement p = con.prepareStatement(insert)) {

                    p.setInt(1, interviewId); p.setInt(2, appId); p.setTimestamp(3, start); p.setString(4, mode); p.setString(5, location);

                    p.setString(6, remarks); p.setInt(7, roundNo); p.setString(8, roundName); p.setInt(9, duration);

                    if (interviewerId > 0) p.setInt(10, interviewerId); else p.setNull(10, Types.NUMERIC);

                    p.executeUpdate();

                }

                try (PreparedStatement p = con.prepareStatement("INSERT INTO INTERVIEW_HISTORY (HISTORY_ID,INTERVIEW_ID,ACTION,NEW_VALUE,ACTION_BY,ACTION_AT) VALUES (INTERVIEW_HISTORY_SEQ.NEXTVAL,?,'SCHEDULED',?,?,SYSDATE)")) {

                    p.setInt(1, interviewId); p.setString(2, new SimpleDateFormat("yyyy-MM-dd HH:mm").format(start)); p.setString(3, companyName); p.executeUpdate();

                }

                con.commit(); flash = "Interview scheduled.";

            } else if ("meetingStatus".equals(action)) {

                int interviewId = number(request.getParameter("interviewId"), 0);

                String target = request.getParameter("target");

                if (!("COMPLETED".equals(target) || "NO_SHOW".equals(target) || "CANCELLED".equals(target))) throw new IllegalArgumentException("Choose a valid interview action.");

                String reason = request.getParameter("reason");

                if ("CANCELLED".equals(target) && (reason == null || reason.trim().length() == 0 || reason.length() > 300)) throw new IllegalArgumentException("Enter a cancellation reason (up to 300 characters).");

                String update = "UPDATE INTERVIEW I SET STATUS=?, CANCEL_REASON=?, UPDATED_AT=SYSDATE WHERE I.INTERVIEW_ID=? AND I.STATUS='SCHEDULED' " +

                    "AND ((?='CANCELLED') OR (I.INTERVIEW_DATE<=SYSDATE AND ? IN ('COMPLETED','NO_SHOW'))) " +

                    "AND EXISTS (SELECT 1 FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID WHERE A.APPLICATION_ID=I.APPLICATION_ID AND D.COMPANY_ID=?)";

                try (PreparedStatement p = con.prepareStatement(update)) {

                    p.setString(1,target); if("CANCELLED".equals(target)) p.setString(2,reason.trim()); else p.setNull(2,Types.VARCHAR);

                    p.setInt(3,interviewId); p.setString(4,target); p.setString(5,target); p.setInt(6,companyId);

                    if(p.executeUpdate()!=1) throw new IllegalArgumentException("Interview not found, already updated, or not yet started.");

                }

                try (PreparedStatement p = con.prepareStatement("INSERT INTO INTERVIEW_HISTORY (HISTORY_ID,INTERVIEW_ID,ACTION,NOTE,ACTION_BY,ACTION_AT) VALUES (INTERVIEW_HISTORY_SEQ.NEXTVAL,?,?,?,?,SYSDATE)")) {

                    p.setInt(1,interviewId); p.setString(2,target); p.setString(3,"CANCELLED".equals(target)?reason.trim():null); p.setString(4,companyName); p.executeUpdate();

                }

                con.commit(); flash = "Interview updated.";

            } else if ("feedback".equals(action)) {

                int interviewId=number(request.getParameter("interviewId"),0);

                int tech=number(request.getParameter("technical"),0), comm=number(request.getParameter("communication"),0);

                int prob=number(request.getParameter("problemSolving"),0), culture=number(request.getParameter("cultureFit"),0);

                String recommendation=request.getParameter("recommendation"), strengths=request.getParameter("strengths"), concerns=request.getParameter("concerns");

                if (tech<1||tech>5||comm<1||comm>5||prob<1||prob>5||culture<1||culture>5) throw new IllegalArgumentException("Each score must be from 1 to 5.");

                if (!("STRONG_YES".equals(recommendation)||"YES".equals(recommendation)||"NO".equals(recommendation)||"STRONG_NO".equals(recommendation))) throw new IllegalArgumentException("Choose a recommendation.");

                if (strengths != null && strengths.length()>1000 || concerns != null && concerns.length()>1000) throw new IllegalArgumentException("Feedback text is too long.");

                try (PreparedStatement p = con.prepareStatement("SELECT I.INTERVIEW_ID FROM INTERVIEW I JOIN APPLICATION A ON A.APPLICATION_ID=I.APPLICATION_ID JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID WHERE I.INTERVIEW_ID=? AND I.STATUS='COMPLETED' AND D.COMPANY_ID=? FOR UPDATE OF I.STATUS")) {

                    p.setInt(1, interviewId); p.setInt(2, companyId); try(ResultSet r=p.executeQuery()){if(!r.next()) throw new IllegalArgumentException("Only completed interviews can receive feedback.");}

                }

                try (PreparedStatement p = con.prepareStatement("INSERT INTO INTERVIEW_FEEDBACK (FEEDBACK_ID,INTERVIEW_ID,TECHNICAL_RATING,COMMUNICATION_RATING,PROBLEM_SOLVING_RATING,CULTURE_FIT_RATING,RECOMMENDATION,STRENGTHS,CONCERNS,SUBMITTED_AT) VALUES (INTERVIEW_FEEDBACK_SEQ.NEXTVAL,?,?,?,?,?,?,?,?,SYSDATE)")) {

                    p.setInt(1,interviewId); p.setInt(2,tech); p.setInt(3,comm); p.setInt(4,prob); p.setInt(5,culture); p.setString(6,recommendation); p.setString(7,strengths); p.setString(8,concerns); p.executeUpdate();

                }

                try (PreparedStatement p = con.prepareStatement("INSERT INTO INTERVIEW_HISTORY (HISTORY_ID,INTERVIEW_ID,ACTION,NEW_VALUE,ACTION_BY,ACTION_AT) VALUES (INTERVIEW_HISTORY_SEQ.NEXTVAL,?,'FEEDBACK',?,?,SYSDATE)")) {

                    p.setInt(1,interviewId); p.setString(2,recommendation); p.setString(3,companyName); p.executeUpdate();

                }

                con.commit(); flash = "Feedback saved.";





                            } else if ("decision".equals(action)) {

                int interviewId = number(request.getParameter("interviewId"),0);

                String result = request.getParameter("result");

                if (!("ADVANCE".equals(result)||"SELECTED".equals(result)||"REJECTED".equals(result)||"ON_HOLD".equals(result))) throw new IllegalArgumentException("Choose a valid decision.");

                String feedbackFlag = request.getParameter("withoutFeedback");

                String fsql = "SELECT COUNT(*) FROM INTERVIEW_FEEDBACK F JOIN INTERVIEW I ON I.INTERVIEW_ID=F.INTERVIEW_ID JOIN APPLICATION A ON A.APPLICATION_ID=I.APPLICATION_ID JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID WHERE I.INTERVIEW_ID=? AND D.COMPANY_ID=?";

                int feedbackCount; try(PreparedStatement p=con.prepareStatement(fsql)){p.setInt(1,interviewId);p.setInt(2,companyId);try(ResultSet r=p.executeQuery()){r.next();feedbackCount=r.getInt(1);}}

                if(feedbackCount==0 && !"Y".equals(feedbackFlag)) throw new IllegalArgumentException("Submit feedback first, or confirm the decision without feedback.");

                String decisionSql="UPDATE INTERVIEW I SET RESULT=?, UPDATED_AT=SYSDATE WHERE I.INTERVIEW_ID=? AND I.STATUS='COMPLETED' AND I.RESULT IN ('PENDING','ON_HOLD') AND EXISTS (SELECT 1 FROM APPLICATION A JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID WHERE A.APPLICATION_ID=I.APPLICATION_ID AND D.COMPANY_ID=?)";

                try(PreparedStatement p=con.prepareStatement(decisionSql)){p.setString(1,result);p.setInt(2,interviewId);p.setInt(3,companyId);if(p.executeUpdate()!=1)throw new IllegalArgumentException("This interview cannot be decided again.");}

                if("SELECTED".equals(result)||"REJECTED".equals(result)) {

                    String appUpdate="UPDATE APPLICATION A SET STATUS=? WHERE EXISTS (SELECT 1 FROM INTERVIEW I JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID WHERE I.INTERVIEW_ID=? AND I.APPLICATION_ID=A.APPLICATION_ID AND D.COMPANY_ID=?)";

                    try(PreparedStatement p=con.prepareStatement(appUpdate)){p.setString(1,result);p.setInt(2,interviewId);p.setInt(3,companyId);if(p.executeUpdate()!=1)throw new IllegalArgumentException("Candidate is no longer available.");}

                }

                try(PreparedStatement p=con.prepareStatement("INSERT INTO INTERVIEW_HISTORY (HISTORY_ID,INTERVIEW_ID,ACTION,NEW_VALUE,ACTION_BY,ACTION_AT) VALUES (INTERVIEW_HISTORY_SEQ.NEXTVAL,?,'DECISION',?,?,SYSDATE)")){p.setInt(1,interviewId);p.setString(2,result);p.setString(3,companyName);p.executeUpdate();}

                con.commit(); flash="Decision saved.";

            } else if ("addInterviewer".equals(action)) {

                String name=request.getParameter("name"), email=request.getParameter("email"), designation=request.getParameter("designation");

                if(name==null||name.trim().length()==0||name.trim().length()>100) throw new IllegalArgumentException("Enter an interviewer name (up to 100 characters).");

                if(email!=null&&email.trim().length()>150||designation!=null&&designation.trim().length()>100) throw new IllegalArgumentException("Check the email or designation length.");

                try(PreparedStatement p=con.prepareStatement("INSERT INTO INTERVIEWER (INTERVIEWER_ID,COMPANY_ID,NAME,EMAIL,DESIGNATION,IS_ACTIVE) VALUES (INTERVIEWER_SEQ.NEXTVAL,?,?,?,?, 'Y')")) {

                    p.setInt(1,companyId);p.setString(2,name.trim());p.setString(3,email==null?null:email.trim());p.setString(4,designation==null?null:designation.trim());p.executeUpdate();

                }

                con.commit(); flash="Interviewer added.";

            } else { throw new IllegalArgumentException("Unknown action."); }

        } catch (Exception ex) {

            if (con != null) try { con.rollback(); } catch (SQLException ignored) { }

            error = safeMessage(ex);

        } finally {

            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException ignored) { }

            con = null;

        }

    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && flash != null && error == null) {

        session.setAttribute("interviewFlash", flash);

        response.sendRedirect("company-interviews.jsp");

        return;

    }



    String activeTab = request.getParameter("tab");

    if (activeTab == null || !("upcoming".equals(activeTab)||"feedback".equals(activeTab)||"completed".equals(activeTab)||"all".equals(activeTab))) activeTab="upcoming";

    String query = request.getParameter("q"); if (query == null) query="";

    String stateFilter = "";

    if ("upcoming".equals(activeTab)) stateFilter=" AND I.STATUS='SCHEDULED' AND I.INTERVIEW_DATE>=SYSDATE";

    else if ("feedback".equals(activeTab)) stateFilter=" AND I.STATUS='COMPLETED' AND I.RESULT='PENDING' AND F.FEEDBACK_ID IS NULL";

    else if ("completed".equals(activeTab)) stateFilter=" AND I.STATUS='COMPLETED'";



    int todayCount=0, weekCount=0, feedbackPending=0, awaitingDecision=0, noShows=0, readyCount=0;

    int scheduledCount=0, selectedCount=0, rejectedHoldCount=0;

    List<Map<String,Object>> rows = new ArrayList<Map<String,Object>>();

    List<Map<String,Object>> ready = new ArrayList<Map<String,Object>>();

    List<Map<String,Object>> interviewers = new ArrayList<Map<String,Object>>();

    List<Map<String,Object>> agendaRows = new ArrayList<Map<String,Object>>();

    try {

        con = DBConnection.getConnection();

        String metrics="SELECT SUM(CASE WHEN I.STATUS='SCHEDULED' AND TRUNC(I.INTERVIEW_DATE)=TRUNC(SYSDATE) THEN 1 ELSE 0 END),"+

            "SUM(CASE WHEN I.STATUS='SCHEDULED' AND I.INTERVIEW_DATE>=SYSDATE AND I.INTERVIEW_DATE<SYSDATE+7 THEN 1 ELSE 0 END),"+

            "SUM(CASE WHEN I.STATUS='COMPLETED' AND F.FEEDBACK_ID IS NULL THEN 1 ELSE 0 END),"+

            "SUM(CASE WHEN I.STATUS='COMPLETED' AND I.RESULT IN ('PENDING','ON_HOLD') THEN 1 ELSE 0 END),"+

            "SUM(CASE WHEN I.STATUS='NO_SHOW' THEN 1 ELSE 0 END),SUM(CASE WHEN I.STATUS IN ('COMPLETED','NO_SHOW') THEN 1 ELSE 0 END),"+

            "COUNT(DISTINCT CASE WHEN I.STATUS='SCHEDULED' THEN A.APPLICATION_ID END),COUNT(DISTINCT CASE WHEN I.RESULT='SELECTED' THEN A.APPLICATION_ID END),COUNT(DISTINCT CASE WHEN I.RESULT IN ('REJECTED','ON_HOLD') THEN A.APPLICATION_ID END) FROM INTERVIEW I JOIN APPLICATION A ON A.APPLICATION_ID=I.APPLICATION_ID JOIN RECRUITMENT_DRIVE D ON D.DRIVE_ID=A.DRIVE_ID LEFT JOIN INTERVIEW_FEEDBACK F ON F.INTERVIEW_ID=I.INTERVIEW_ID WHERE D.COMPANY_ID=?";

        try(PreparedStatement p=con.prepareStatement(metrics)){p.setInt(1,companyId);try(ResultSet r=p.executeQuery()){if(r.next()){todayCount=r.getInt(1);weekCount=r.getInt(2);feedbackPending=r.getInt(3);awaitingDecision=r.getInt(4);noShows=r.getInt(5);int denominator=r.getInt(6);if(denominator>0)noShows=(int)Math.round(noShows*100.0/denominator);scheduledCount=r.getInt(7);selectedCount=r.getInt(8);rejectedHoldCount=r.getInt(9);}}}

        String latestInterview="I.APPLICATION_ID=A.APPLICATION_ID AND I.INTERVIEW_ID=(SELECT MAX(I2.INTERVIEW_ID) FROM INTERVIEW I2 WHERE I2.APPLICATION_ID=A.APPLICATION_ID AND I2.CREATED_AT=(SELECT MAX(I3.CREATED_AT) FROM INTERVIEW I3 WHERE I3.APPLICATION_ID=A.APPLICATION_ID))";

        String readySql="SELECT A.APPLICATION_ID,S.NAME,S.EMAIL,R.JOB_TITLE,R.DRIVE_ID,"+

            "NVL((SELECT CASE WHEN I.STATUS IN ('CANCELLED','NO_SHOW') THEN I.ROUND_NO ELSE I.ROUND_NO+1 END FROM INTERVIEW I WHERE "+latestInterview+"),1) NEXT_ROUND "+

            "FROM APPLICATION A JOIN STUDENT S ON S.STUDENT_ID=A.STUDENT_ID JOIN RECRUITMENT_DRIVE R ON R.DRIVE_ID=A.DRIVE_ID WHERE R.COMPANY_ID=? AND UPPER(A.COLLEGE_SHORTLIST_STATUS)='SHORTLISTED' AND UPPER(NVL(A.STATUS,'PENDING')) NOT IN ('REJECTED','SELECTED') "+

            "AND NOT EXISTS (SELECT 1 FROM INTERVIEW I WHERE I.APPLICATION_ID=A.APPLICATION_ID AND I.STATUS='SCHEDULED') "+

            "AND (NOT EXISTS (SELECT 1 FROM INTERVIEW I WHERE I.APPLICATION_ID=A.APPLICATION_ID) OR EXISTS (SELECT 1 FROM INTERVIEW I WHERE "+latestInterview+" AND (I.RESULT='ADVANCE' OR I.STATUS IN ('CANCELLED','NO_SHOW')))) ORDER BY A.APPLICATION_ID DESC";

        try(PreparedStatement p=con.prepareStatement(readySql)){p.setInt(1,companyId);try(ResultSet r=p.executeQuery()){while(r.next()){Map<String,Object> m=new HashMap<String,Object>();m.put("id",r.getInt(1));m.put("name",r.getString(2));m.put("email",r.getString(3));m.put("job",r.getString(4));m.put("drive",r.getInt(5));m.put("nextRound",r.getInt(6));ready.add(m);}}}

        readyCount=ready.size();

        try(PreparedStatement p=con.prepareStatement("SELECT INTERVIEWER_ID,NAME,DESIGNATION FROM INTERVIEWER WHERE COMPANY_ID=? AND IS_ACTIVE='Y' ORDER BY NAME")){p.setInt(1,companyId);try(ResultSet r=p.executeQuery()){while(r.next()){Map<String,Object> m=new HashMap<String,Object>();m.put("id",r.getInt(1));m.put("name",r.getString(2));m.put("title",r.getString(3));interviewers.add(m);}}}

        // Build the search predicate only when a term exists. Oracle JDBC can
        // fail to infer a datatype for a NULL bind used in "? IS NULL".
        String searchTerm = query.trim();
        String searchFilter = searchTerm.length() == 0 ? "" :
            " AND (UPPER(S.NAME) LIKE UPPER(?) OR UPPER(S.EMAIL) LIKE UPPER(?) OR UPPER(R.JOB_TITLE) LIKE UPPER(?))";
        String list="SELECT * FROM (SELECT Q.*,ROWNUM RN FROM (SELECT I.INTERVIEW_ID,I.APPLICATION_ID,S.NAME,S.EMAIL,R.JOB_TITLE,I.ROUND_NO,I.ROUND_NAME,I.INTERVIEW_DATE,I.DURATION_MIN,I.INTERVIEW_MODE,I.VENUE_OR_LINK,I.STATUS,I.RESULT,IV.NAME,F.FEEDBACK_ID FROM INTERVIEW I JOIN APPLICATION A ON A.APPLICATION_ID=I.APPLICATION_ID JOIN STUDENT S ON S.STUDENT_ID=A.STUDENT_ID JOIN RECRUITMENT_DRIVE R ON R.DRIVE_ID=A.DRIVE_ID LEFT JOIN INTERVIEWER IV ON IV.INTERVIEWER_ID=I.INTERVIEWER_ID LEFT JOIN INTERVIEW_FEEDBACK F ON F.INTERVIEW_ID=I.INTERVIEW_ID WHERE R.COMPANY_ID=?"+stateFilter+searchFilter+
            " ORDER BY I.INTERVIEW_DATE DESC NULLS LAST) Q WHERE ROWNUM<=50)";

        try(PreparedStatement p=con.prepareStatement(list)){
            p.setInt(1,companyId);
            if (searchTerm.length() > 0) {
                String q = "%" + searchTerm + "%";
                p.setString(2,q); p.setString(3,q); p.setString(4,q);
            }
            try(ResultSet r=p.executeQuery()){while(r.next()){Map<String,Object> m=new HashMap<String,Object>();m.put("id",r.getInt(1));m.put("app",r.getInt(2));m.put("name",r.getString(3));m.put("email",r.getString(4));m.put("job",r.getString(5));m.put("round",r.getInt(6));m.put("roundName",r.getString(7));m.put("date",r.getTimestamp(8));m.put("duration",r.getInt(9));m.put("mode",r.getString(10));m.put("place",r.getString(11));m.put("status",r.getString(12));m.put("result",r.getString(13));m.put("interviewer",r.getString(14));m.put("feedback",r.getObject(15)!=null);rows.add(m);}}
        }
        String agendaSql="SELECT * FROM (SELECT I.INTERVIEW_DATE,S.NAME,R.JOB_TITLE FROM INTERVIEW I JOIN APPLICATION A ON A.APPLICATION_ID=I.APPLICATION_ID JOIN STUDENT S ON S.STUDENT_ID=A.STUDENT_ID JOIN RECRUITMENT_DRIVE R ON R.DRIVE_ID=A.DRIVE_ID WHERE R.COMPANY_ID=? AND I.STATUS='SCHEDULED' AND I.INTERVIEW_DATE>=TRUNC(SYSDATE) AND I.INTERVIEW_DATE<TRUNC(SYSDATE)+1 ORDER BY I.INTERVIEW_DATE) WHERE ROWNUM<=10";

        try(PreparedStatement p=con.prepareStatement(agendaSql)){p.setInt(1,companyId);try(ResultSet r=p.executeQuery()){while(r.next()){Map<String,Object> m=new HashMap<String,Object>();m.put("date",r.getTimestamp(1));m.put("name",r.getString(2));m.put("job",r.getString(3));agendaRows.add(m);}}}

    } catch (Exception ex) {

        // Keep the friendly page message, but write the full failure to the
        // servlet container log so the exact Oracle/schema error is visible.
        application.log("[company-interviews.jsp] Failed to load interview information for companyId=" + companyId, ex);
        Throwable cause = ex;
        while (cause != null) {
            if (cause instanceof SQLException) {
                SQLException sqlEx = (SQLException) cause;
                int sqlIndex = 0;
                for (SQLException next = sqlEx; next != null; next = next.getNextException()) {
                    application.log("[company-interviews.jsp] SQL exception #" + (++sqlIndex)
                        + ": SQLState=" + next.getSQLState()
                        + ", errorCode=" + next.getErrorCode()
                        + ", message=" + next.getMessage());
                }
            }
            cause = cause.getCause();
        }
        if (error == null) error = "Interview information could not be loaded. Please refresh the page.";
    } finally {

        if (con != null) try { con.close(); } catch (SQLException ignored) { }

    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd MMM · hh:mm a");

%>





<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Interview Management | CampusConnect</title>

<link rel="preconnect" href="https://fonts.googleapis.com">

<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Manrope:wght@500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>

:root{--ink:#172b4d;--muted:#70819a;--line:#e4eaf2;--bg:#f5f7fb;--blue:#315ee8;--green:#16856b;--amber:#a56610;--red:#bc4650;--card:#fff;--shadow:0 10px 28px rgba(26,51,91,.055)}

*{box-sizing:border-box}

body{margin:0;background:var(--bg);color:var(--ink);font:14px 'DM Sans',Arial,sans-serif}

.shell{max-width:1500px;margin:auto;padding:30px 34px 60px}

.top{display:flex;align-items:center;justify-content:space-between;margin-bottom:26px}

.eyebrow{text-transform:uppercase;letter-spacing:.11em;font-size:10px;font-weight:700;color:#7a8ba4}

.title{font:800 27px Manrope,Arial;margin:5px 0 0}

.sub{color:var(--muted);margin-top:5px}

.actions{display:flex;gap:10px}

.btn{border:1px solid var(--line);border-radius:9px;padding:10px 15px;background:white;color:var(--ink);font-weight:700;cursor:pointer;text-decoration:none;font:600 13px 'DM Sans';transition:.15s}

.btn.primary{background:var(--blue);color:white;border-color:var(--blue);box-shadow:0 5px 12px #315ee833}

.btn:hover{transform:translateY(-1px);box-shadow:0 5px 15px #172b4d12}

.metrics{display:grid;grid-template-columns:repeat(5,1fr);gap:13px;margin-bottom:20px}

.metric,.panel,.pipeline{background:var(--card);border:1px solid var(--line);border-radius:13px;box-shadow:var(--shadow)}

.metric{padding:17px 19px}

.metric-label{font-size:12px;color:var(--muted);font-weight:600}

.metric-value{font:800 26px Manrope;margin-top:11px}

.metric-foot{font-size:11px;color:#8997a9;margin-top:4px}

.pipeline{display:flex;align-items:center;padding:17px 20px;margin-bottom:20px;gap:0}

.pipe{flex:1;display:flex;align-items:center;gap:9px;color:var(--muted);font-size:12px;font-weight:700}

.dot{width:9px;height:9px;border-radius:50%;background:#b5c0ce}

.pipe.ready .dot{background:#45aa87}.pipe.scheduled .dot{background:#4971ed}.pipe.wait .dot{background:#e7ad4e}.pipe.done .dot{background:#8d73d9}

.layout{display:grid;grid-template-columns:minmax(0,1fr) 320px;gap:18px;align-items:start}

.maincol,.side{display:grid;gap:18px;min-width:0}

.panel-head{padding:19px 21px;border-bottom:1px solid var(--line);display:flex;justify-content:space-between;align-items:center;gap:12px}

.panel-head h2{font:700 15px Manrope;margin:0}

.panel-body{padding:19px 21px}

.tabs{display:flex;gap:5px;padding:0 20px;border-bottom:1px solid var(--line);overflow:auto}

.tab{padding:15px 12px;border:0;border-bottom:2px solid transparent;background:transparent;color:var(--muted);text-decoration:none;white-space:nowrap;font-weight:700;font-size:12px}

.tab.active{color:var(--blue);border-bottom-color:var(--blue)}

.badge{display:inline-flex;align-items:center;justify-content:center;min-width:25px;padding:4px 8px;border-radius:20px;background:#edf2ff;color:var(--blue);font-size:11px;font-weight:700}

.search{display:flex;gap:8px;padding:15px 20px;border-bottom:1px solid var(--line)}

.search input{flex:1;min-width:0}

input,select,textarea{width:100%;padding:10px 11px;border:1px solid #dce4ef;border-radius:8px;background:#fff;color:var(--ink);font:13px 'DM Sans',Arial}

input:focus,select:focus,textarea:focus{outline:2px solid #d9e4ff;border-color:var(--blue)}

.table-wrap{overflow:auto}

table{width:100%;border-collapse:collapse;text-align:left}

th{background:#fafbfe;color:#71819a;font-size:10px;text-transform:uppercase;letter-spacing:.07em;padding:12px 14px;white-space:nowrap}

td{border-top:1px solid #edf1f6;padding:14px;vertical-align:middle;font-size:12px}

tbody tr:hover{background:#fafcff}

.person{font-weight:700;color:var(--ink)}

.small{font-size:11px;color:var(--muted);margin-top:4px;line-height:1.5}

.status{display:inline-block;padding:5px 8px;border-radius:20px;font-size:10px;font-weight:700;background:#edf2f8;color:#5c6c83;white-space:nowrap}

.status.SCHEDULED{background:#eaf0ff;color:#315ee8}.status.COMPLETED{background:#e4f7ef;color:#16856b}.status.CANCELLED,.status.REJECTED{background:#fff0f0;color:#bc4650}.status.NO_SHOW{background:#fff4df;color:#a56610}

.link{border:0;background:transparent;color:var(--blue);cursor:pointer;padding:5px 0;font:700 11px 'DM Sans'}

.inline-form{display:flex;gap:6px;align-items:center}

.inline-form select{min-width:105px;padding:7px;font-size:11px}

.inline-form button{padding:7px 9px;font-size:11px}

.empty{text-align:center;padding:35px 20px;color:var(--muted);font-size:12px}

.empty b{display:block;color:var(--ink);margin-bottom:7px}

.alert{border:1px solid #f0d9a9;background:#fff9eb;color:#895b13;border-radius:9px;padding:12px 14px;margin:15px 20px;font-size:12px}

.more{padding:12px 20px;border-top:1px solid var(--line);font-size:11px;color:var(--muted)}

.side-body{padding:17px 18px}

.ready-item{padding:13px 0;border-bottom:1px solid #edf1f6}

.ready-item:last-child{border-bottom:0}

.ready-item .btn{margin-top:9px;width:100%}

.agenda-row{display:flex;gap:12px;padding:11px 0;border-bottom:1px solid #edf1f6}

.agenda-row:last-child{border-bottom:0}

.time{min-width:66px;color:var(--blue);font-weight:700;font-size:11px}

.dialog{width:min(680px,calc(100% - 24px));max-height:90vh;overflow:auto;padding:0;border:1px solid var(--line);border-radius:15px;box-shadow:0 25px 80px #142c5033}

.dialog::backdrop{background:#142c5070;backdrop-filter:blur(3px)}

.dialog-head{display:flex;justify-content:space-between;align-items:center;gap:12px;padding:18px 22px;border-bottom:1px solid var(--line)}

.dialog-head h3{margin:0;font:700 17px Manrope}

.form{padding:20px 22px;display:grid;grid-template-columns:1fr 1fr;gap:14px}

.field{min-width:0}

.field.full{grid-column:1/-1}

.field label{display:block;font-size:11px;font-weight:700;color:#5f718a;margin-bottom:7px}

.field textarea{resize:vertical}

.form-foot{grid-column:1/-1;display:flex;justify-content:flex-end;gap:9px;padding-top:6px}

.muted{color:var(--muted);font-size:12px}

@media(max-width:1100px){.metrics{grid-template-columns:repeat(3,1fr)}.layout{grid-template-columns:minmax(0,1fr) 280px}}

@media(max-width:820px){.shell{padding:20px 14px 40px}.top{align-items:flex-start;gap:15px;flex-direction:column}.metrics{grid-template-columns:repeat(2,1fr)}.layout{grid-template-columns:1fr}.pipeline{flex-wrap:wrap;gap:15px}.pipe{flex:1 1 40%}}

@media(max-width:520px){.metrics{grid-template-columns:1fr 1fr;gap:8px}.metric{padding:13px}.metric-value{font-size:22px}.form{grid-template-columns:1fr;padding:16px}.field.full,.form-foot{grid-column:1}.actions{flex-wrap:wrap}}


        .sidebar {
            font-family: Arial, Helvetica, sans-serif;
            line-height: normal;
            width: 285px;
            min-width: 285px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: linear-gradient(180deg, #092f55 0%, #062847 100%);
            color: white;
            display: flex;
            flex-direction: column;
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar::-webkit-scrollbar { width: 4px; }
        .sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); }

        .sidebar-logo {
            padding: 30px 26px 25px;
            margin: 0 16px;
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }

        .brand-name {
            font-size: 25px;
            font-weight: 800;
            letter-spacing: -1px;
            color: #ffffff;
        }

        .brand-name span { color: #2e8bf0; }

        .brand-subtitle {
            margin-top: 8px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 1.2px;
            color: #4da2ff;
        }

        .sidebar-content {
            padding: 24px 16px;
            flex: 1;
        }

        .menu-section-title {
            margin: 0 10px 10px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #42a0f5;
        }

        .menu-section-title:not(:first-child) { margin-top: 22px; }

        .menu-item {
            min-height: 48px;
            padding: 0 15px;
            margin-bottom: 5px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            gap: 17px;
            font-size: 16px;
            font-weight: 600;
            color: #edf5ff;
            text-decoration: none;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .menu-item i {
            width: 22px;
            text-align: center;
            font-size: 18px;
            font-style: normal;
            color: #e9f3ff;
        }

        .menu-item:hover { background: rgba(49,139,238,0.22); }

        .menu-item.active {
            background: linear-gradient(90deg, #2683e9, #347fce);
            box-shadow: 0 5px 15px rgba(0,0,0,0.12);
        }

        .menu-item.active i { color: white; }

        .sidebar-bottom {
            padding: 10px 16px 25px;
            border-top: 1px solid rgba(255,255,255,0.15);
        }

        .sidebar-bottom .menu-item { margin-bottom: 3px; }
        .menu-item.logout, .menu-item.logout i { color: #ff7d7d; }

        .shell {
            width: calc(100% - 300px);
            max-width: none;
            margin: 0 0 0 300px;
        }

        @media (max-width: 900px) {
            .sidebar { width: 76px; min-width: 76px; }
            .sidebar-logo { padding: 23px 5px; margin: 0 8px; text-align: center; }
            .brand-name { font-size: 22px; letter-spacing: -1px; }
            .brand-name span, .brand-subtitle, .menu-section-title, .menu-item span { display: none; }
            .sidebar-content, .sidebar-bottom { padding-left: 10px; padding-right: 10px; }
            .menu-item { justify-content: center; padding: 0; min-height: 43px; }
            .menu-item i { font-size: 17px; }
            .shell { width: calc(100% - 76px); margin-left: 76px; }
        }


</style>

</head>

<body>

<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="brand-name">Campus<span>Connect</span></div>
        <div class="brand-subtitle">COMPANY PORTAL</div>
    </div>

    <nav class="sidebar-content">
        <div class="menu-section-title">OVERVIEW</div>

        <a href="company-dashboard.jsp" class="menu-item">
            <i class="fa-solid fa-house"></i><span>Dashboard</span>
        </a>

        <a href="company-profile.jsp" class="menu-item">
            <i class="fa-solid fa-building"></i><span>Company Profile</span>
        </a>

        <div class="menu-section-title">RECRUITMENT</div>

        <a href="recruitment-drive.jsp" class="menu-item">
            <i class="fa-solid fa-plus"></i><span>Create Drive</span>
        </a>

        <a href="view-recruitment-drives.jsp" class="menu-item">
            <i class="fa-solid fa-briefcase"></i><span>Recruitment Drives</span>
        </a>

        <a href="company-applicants.jsp" class="menu-item">
            <i class="fa-solid fa-users"></i><span>Applicants</span>
        </a>

        <a href="company-shortlisted.jsp" class="menu-item">
            <i class="fa-solid fa-star"></i><span>Shortlisted Candidates</span>
        </a>

        <a href="company-interviews.jsp" class="menu-item active" aria-current="page">
            <i class="fa-regular fa-square"></i><span>Interviews</span>
        </a>

        <a href="company-offers.jsp" class="menu-item">
            <i class="fa-regular fa-gem"></i><span>Offers &amp; Selections</span>
        </a>

        <div class="menu-section-title">ANALYTICS</div>

        <a href="company-reports.jsp" class="menu-item">
            <i class="fa-solid fa-chart-column"></i><span>Reports &amp; Analytics</span>
        </a>

        <a href="company-analytics.jsp" class="menu-item">
            <i class="fa-solid fa-chart-line"></i><span>Analytics Insights</span>
        </a>
    </nav>

    <div class="sidebar-bottom">
        <a href="company-settings.jsp" class="menu-item">
            <i class="fa-solid fa-gear"></i><span>Settings</span>
        </a>

        <a href="CompanyLogoutServlet" class="menu-item logout">
            <i class="fa-solid fa-right-from-bracket"></i><span>Logout</span>
        </a>
    </div>
</aside>

<main class="shell">

<header class="top">

    <div>

        <div class="eyebrow">CampusConnect · Company Portal</div>

        <h1 class="title">Interview Management</h1>

        <div class="sub">Schedule interviews, capture feedback and manage candidate decisions.</div>

    </div>

    <div class="actions">

        <button class="btn" type="button" onclick="document.getElementById('people').showModal()">Manage interviewers</button>

        <a class="btn" href="company-dashboard.jsp">Dashboard</a>

        <a class="btn primary" href="company-applicants.jsp">View applicants</a>

    </div>

</header>



<% if (flash != null) { %>

<div class="alert" style="border-color:#bde7d6;background:#edfbf5;color:#176d55"><%=esc(flash)%></div>

<% } %>

<% if (error != null) { %><div class="alert"><%=esc(error)%></div><% } %>



<section class="metrics">

    <div class="metric"><div class="metric-label">Today's interviews</div><div class="metric-value"><%=todayCount%></div><div class="metric-foot">Scheduled for today</div></div>

    <div class="metric"><div class="metric-label">Next 7 days</div><div class="metric-value"><%=weekCount%></div><div class="metric-foot">Upcoming interviews</div></div>

    <div class="metric"><div class="metric-label">Feedback pending</div><div class="metric-value"><%=feedbackPending%></div><div class="metric-foot">Completed interviews</div></div>

    <div class="metric"><div class="metric-label">Awaiting decision</div><div class="metric-value"><%=awaitingDecision%></div><div class="metric-foot">Feedback or decision required</div></div>

    <div class="metric"><div class="metric-label">No-show rate</div><div class="metric-value"><%=noShows%>%</div><div class="metric-foot">Completed / no-show records</div></div>

</section>



<section class="pipeline">

    <div class="pipe ready"><span class="dot"></span> Ready to schedule <b><%=readyCount%></b></div>

    <div class="pipe scheduled"><span class="dot"></span> Scheduled <b><%=scheduledCount%></b></div>

    <div class="pipe done"><span class="dot"></span> Selected <b><%=selectedCount%></b></div>

    <div class="pipe wait"><span class="dot"></span> Rejected / on hold <b><%=rejectedHoldCount%></b></div>

</section>



<div class="layout">

<div class="maincol">

<section class="panel">

    <div class="panel-head"><h2>Interview records</h2><span class="badge"><%=rows.size()%> shown</span></div>

    <nav class="tabs">

        <a class="tab <%= "upcoming".equals(activeTab) ? "active" : "" %>" href="company-interviews.jsp?tab=upcoming">Upcoming</a>

        <a class="tab <%= "feedback".equals(activeTab) ? "active" : "" %>" href="company-interviews.jsp?tab=feedback">Needs feedback</a>

        <a class="tab <%= "completed".equals(activeTab) ? "active" : "" %>" href="company-interviews.jsp?tab=completed">Completed</a>

        <a class="tab <%= "all".equals(activeTab) ? "active" : "" %>" href="company-interviews.jsp?tab=all">All interviews</a>

    </nav>

    <form class="search" method="get" action="company-interviews.jsp">

        <input type="hidden" name="tab" value="<%=esc(activeTab)%>">

        <input type="search" name="q" value="<%=esc(query)%>" placeholder="Search candidate, email or job title">

        <button class="btn" type="submit">Search</button>

    </form>

    <% if (rows.isEmpty()) { %>

        <div class="empty"><b>No interviews found</b>Schedule an interview from the candidates ready to schedule.</div>

    <% } else { %>

    <div class="table-wrap">

    <table>

        <thead><tr><th>Candidate</th><th>Round</th><th>Date / time</th><th>Mode</th><th>Interviewer</th><th>Status</th><th>Outcome</th><th>Actions</th></tr></thead>

        <tbody>

        <% for (Map<String,Object> row : rows) {

            String status = (String) row.get("status");

            Timestamp dt = (Timestamp) row.get("date"); %>

        <tr>

            <td><div class="person"><%=esc((String)row.get("name"))%></div><div class="small"><%=esc((String)row.get("email"))%></div><div class="small"><%=esc((String)row.get("job"))%></div></td>

            <td><b>Round <%=row.get("round")%></b><div class="small"><%=row.get("roundName")==null?"":esc((String)row.get("roundName"))%></div><div class="small"><%=row.get("duration")%> min</div></td>

            <td><%=dt==null?"Not scheduled":esc(dateFormat.format(dt))%><div class="small"><%=esc((String)row.get("mode"))%></div></td>

            <td><%=esc((String)row.get("place"))%></td>

            <td><%=row.get("interviewer")==null?"Unassigned":esc((String)row.get("interviewer"))%></td>

            <td><span class="status <%=esc(status)%>"><%=esc(status)%></span></td>

            <td><%=esc((String)row.get("result"))%></td>

            <td>

                <% if ("SCHEDULED".equals(status)) { %>

                <form method="post" class="inline-form">

                    <input type="hidden" name="csrf" value="<%=esc(csrf)%>"><input type="hidden" name="action" value="meetingStatus"><input type="hidden" name="interviewId" value="<%=row.get("id")%>">

                    <select name="target"><option value="COMPLETED">Complete</option><option value="NO_SHOW">No-show</option><option value="CANCELLED">Cancel</option></select>

                    <button class="btn" type="submit">Save</button>

                </form>

                <% } else if ("COMPLETED".equals(status) && !Boolean.TRUE.equals(row.get("feedback"))) { %>

                <button class="link" type="button" onclick="openFeedback(<%=row.get("id")%>)">Add feedback</button>

                <% } else if ("COMPLETED".equals(status) && ("PENDING".equals(row.get("result")) || "ON_HOLD".equals(row.get("result")))) { %>

                <button class="link" type="button" onclick="openDecision(<%=row.get("id")%>)">Record decision</button>

                <% } else { %><span class="small">—</span><% } %>

            </td>

        </tr>

        <% } %>

        </tbody>

    </table>

    </div>

    <div class="more">Showing up to 50 records. Use search to narrow the list.</div>

    <% } %>

</section>



<aside class="side">

<section class="panel">

    <div class="panel-head"><h2>Ready to schedule</h2><span class="badge"><%=readyCount%></span></div>

    <div class="side-body">

    <% if (ready.isEmpty()) { %>

        <div class="empty" style="padding:22px 8px"><b>No candidates ready</b>Candidates appear here when COLLEGE_SHORTLIST_STATUS is SHORTLISTED.</div>

    <% } else { for (Map<String,Object> candidate : ready) { %>

        <div class="ready-item">

            <div class="person"><%=esc((String)candidate.get("name"))%></div>

            <div class="small"><%=esc((String)candidate.get("job"))%> · Drive #<%=candidate.get("drive")%></div>

            <button type="button" class="btn" onclick="scheduleFor(<%=candidate.get("id")%>,<%=candidate.get("nextRound")%>)">+ Schedule · Round <%=candidate.get("nextRound")%></button>

        </div>

    <% } } %>

    </div>

</section>



<section class="panel">

    <div class="panel-head"><h2>Today's agenda</h2></div>

    <div class="side-body">

    <% int agenda = 0; for (Map<String,Object> row : agendaRows) {

        Timestamp dt = (Timestamp)row.get("date"); agenda++; %>

        <div class="agenda-row"><div class="time"><%=new SimpleDateFormat("hh:mm a").format(dt)%></div><div><div class="person"><%=esc((String)row.get("name"))%></div><div class="small"><%=esc((String)row.get("job"))%></div></div></div>

    <% } if (agenda == 0) { %><div class="empty" style="padding:18px 5px">No interviews scheduled today.</div><% } %>

    <% if (weekCount > 0 && rows.isEmpty()) { %><div class="alert">There are upcoming interviews. Open the Upcoming tab to view them.</div><% } %>

    </div>

</section>

</aside>

</div>

</div>

</main>



<dialog class="dialog" id="schedule">

<div class="dialog-head"><h3>Schedule an interview</h3><button class="btn" type="button" onclick="this.closest('dialog').close()">Close</button></div>

<form method="post" class="form">

    <input type="hidden" name="csrf" value="<%=esc(csrf)%>"><input type="hidden" name="action" value="schedule">

    <div class="field full"><label>College-shortlisted candidate</label>

        <select name="applicationId" id="candidateSelect" required onchange="setCandidateRound()"><option value="">Select candidate</option>

        <% for (Map<String,Object> c : ready) { %><option value="<%=c.get("id")%>" data-round="<%=c.get("nextRound")%>"><%=esc((String)c.get("name"))%> — <%=esc((String)c.get("job"))%></option><% } %>

        </select>

    </div>

    <div class="field"><label>Round number</label><input type="number" min="1" max="99" name="roundNo" value="1" required></div>

    <div class="field"><label>Round name</label><input name="roundName" maxlength="50" placeholder="Technical, HR…"></div>

    <div class="field"><label>Date and time</label><input type="datetime-local" name="interviewDate" required></div>

    <div class="field"><label>Duration</label><select name="duration"><option>30</option><option selected>45</option><option>60</option><option>90</option><option>120</option></select></div>

    <div class="field"><label>Mode</label><select name="mode" id="modeSelect" onchange="togglePlace()"><option value="ONLINE">Online</option><option value="ONSITE">Onsite</option><option value="PHONE">Phone</option></select></div>

    <div class="field"><label>Interviewer (optional)</label><select name="interviewerId"><option value="0">Unassigned</option><% for (Map<String,Object> iv : interviewers) { %><option value="<%=iv.get("id")%>"><%=esc((String)iv.get("name"))%><%=iv.get("title")==null ? "" : " · "+esc((String)iv.get("title"))%></option><% } %></select></div>

    <div class="field full"><label id="placeLabel">Meeting link (http or https)</label><input name="venueOrLink" id="placeInput" maxlength="300" placeholder="https://…"></div>

    <div class="field full"><label>Notes</label><textarea name="remarks" maxlength="500" rows="2" placeholder="Optional context for the interview team"></textarea></div>

    <div class="form-foot"><button class="btn" type="button" onclick="this.closest('dialog').close()">Back</button><button class="btn primary" type="submit">Schedule interview</button></div>

</form>

</dialog>



<dialog class="dialog" id="feedback">

<div class="dialog-head"><h3>Interview scorecard</h3><button class="btn" type="button" onclick="this.closest('dialog').close()">Close</button></div>

<form method="post" class="form">

    <input type="hidden" name="csrf" value="<%=esc(csrf)%>"><input type="hidden" name="action" value="feedback"><input type="hidden" name="interviewId" id="feedbackId">

    <% String[] scoreNames={"technical","communication","problemSolving","cultureFit"}; String[] scoreLabels={"Technical","Communication","Problem solving","Culture fit"}; for(int i=0;i<scoreNames.length;i++){ %>

    <div class="field"><label><%=scoreLabels[i]%> (1–5)</label><select name="<%=scoreNames[i]%>" required><option value="">Choose rating</option><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option></select></div>

    <% } %>

    <div class="field full"><label>Recommendation</label><select name="recommendation" required><option value="">Choose</option><option value="STRONG_YES">Strong yes</option><option value="YES">Yes</option><option value="NO">No</option><option value="STRONG_NO">Strong no</option></select></div>

    <div class="field full"><label>Strengths</label><textarea name="strengths" maxlength="1000" rows="2"></textarea></div>

    <div class="field full"><label>Areas to explore</label><textarea name="concerns" maxlength="1000" rows="2"></textarea></div>

    <div class="form-foot"><button class="btn primary" type="submit">Save scorecard</button></div>

</form>

</dialog>



<dialog class="dialog" id="decision">

<div class="dialog-head"><h3>Record a decision</h3><button class="btn" type="button" onclick="this.closest('dialog').close()">Close</button></div>

<form method="post" class="form">

    <input type="hidden" name="csrf" value="<%=esc(csrf)%>"><input type="hidden" name="action" value="decision"><input type="hidden" name="interviewId" id="decisionId">

    <div class="field full"><label>Outcome</label><select name="result" required><option value="ADVANCE">Advance to next round</option><option value="SELECTED">Select candidate</option><option value="REJECTED">Reject candidate</option><option value="ON_HOLD">Put on hold</option></select></div>

    <div class="field full"><label><input type="checkbox" name="withoutFeedback" value="Y" style="width:auto"> I confirm this decision without a submitted scorecard</label></div>

    <div class="form-foot"><button class="btn primary" type="submit">Save decision</button></div>

</form>

</dialog>



<dialog class="dialog" id="people">

<div class="dialog-head"><h3>Interviewers</h3><button class="btn" type="button" onclick="this.closest('dialog').close()">Close</button></div>

<div class="side-body">

<p class="muted">Active interviewers for <%=esc(companyName)%>:</p>

<% if(interviewers.isEmpty()){ %><div class="empty"><b>No interviewers yet</b>Add an interviewer to assign them and check schedule conflicts.</div>

<% }else{for(Map<String,Object> iv:interviewers){ %><div class="ready-item"><b><%=esc((String)iv.get("name"))%></b><div class="small"><%=iv.get("title")==null?"Interviewer":esc((String)iv.get("title"))%></div></div><% }} %>

<form method="post" class="form" style="padding:15px 0 0">

    <input type="hidden" name="csrf" value="<%=esc(csrf)%>"><input type="hidden" name="action" value="addInterviewer">

    <div class="field"><label>Name</label><input name="name" maxlength="100" required></div>

    <div class="field"><label>Designation</label><input name="designation" maxlength="100"></div>

    <div class="field full"><label>Email</label><input type="email" name="email" maxlength="150"></div>

    <div class="form-foot"><button class="btn primary" type="submit">Add interviewer</button></div>

</form>

</div>

</dialog>



<script>

function scheduleFor(id, round) {

    document.getElementById('candidateSelect').value = id;

    document.querySelector('[name="roundNo"]').value = round || 1;

    document.getElementById('schedule').showModal();

}

function setCandidateRound() {

    var s = document.getElementById('candidateSelect');

    var o = s.options[s.selectedIndex];

    document.querySelector('[name="roundNo"]').value = o.getAttribute('data-round') || 1;

}

function openFeedback(id) {

    document.getElementById('feedbackId').value = id;

    document.getElementById('feedback').showModal();

}

function openDecision(id) {

    document.getElementById('decisionId').value = id;

    document.getElementById('decision').showModal();

}

document.querySelectorAll('input[name="action"][value="meetingStatus"]').forEach(function(actionField) {

    actionField.form.addEventListener('submit', function(event) {

        var target = this.querySelector('[name="target"]').value;

        if (target === 'CANCELLED') {

            var reason = window.prompt('Enter a cancellation reason (required):');

            if (!reason || !reason.trim()) { event.preventDefault(); return; }

            var input = document.createElement('input');

            input.type = 'hidden'; input.name = 'reason'; input.value = reason.trim();

            this.appendChild(input);

        }

    });

});

function togglePlace() {

    var mode=document.getElementById('modeSelect').value;

    var label=document.getElementById('placeLabel');

    var input=document.getElementById('placeInput');

    label.textContent=mode==='ONLINE'?'Meeting link (http or https)':mode==='ONSITE'?'Venue':'Meeting link or phone details';

    input.placeholder=mode==='ONLINE'?'https://…':mode==='ONSITE'?'Building, room, campus…':'Optional';

    input.required=mode==='ONLINE'||mode==='ONSITE';

}

togglePlace();

</script>

</body>

</html>