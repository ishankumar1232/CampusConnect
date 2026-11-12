package com.campusconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.campusconnect.bean.Student;
import com.campusconnect.util.DBConnection;

public class StudentDAO {

    // ==========================================
    // GET ALL STUDENTS
    // ==========================================

    public ArrayList<Student> getAllStudents() {

        ArrayList<Student> list = new ArrayList<Student>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String sql =
                    "SELECT " +
                    "S.STUDENT_ID, " +
                    "S.COLLEGE_ID, " +
                    "C.COLLEGE_NAME, " +
                    "S.COURSE_ID, " +
                    "CR.COURSE_NAME, " +
                    "S.NAME, " +
                    "S.EMAIL, " +
                    "S.PHONE, " +
                    "S.GENDER, " +
                    "S.STATUS " +
                    "FROM STUDENT S " +
                    "LEFT JOIN COLLEGE C " +
                    "ON S.COLLEGE_ID=C.COLLEGE_ID " +
                    "LEFT JOIN COURSE CR " +
                    "ON S.COURSE_ID=CR.COURSE_ID " +
                    "ORDER BY S.STUDENT_ID";

            ps = con.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {

                Student s = new Student();

                s.setStudentId(rs.getInt("STUDENT_ID"));

                s.setCollegeId(rs.getInt("COLLEGE_ID"));

                s.setCollegeName(rs.getString("COLLEGE_NAME"));

                s.setCourseId(rs.getInt("COURSE_ID"));

                s.setCourseName(rs.getString("COURSE_NAME"));

                s.setName(rs.getString("NAME"));

                s.setEmail(rs.getString("EMAIL"));

                s.setPhone(rs.getString("PHONE"));

                s.setGender(rs.getString("GENDER"));

                s.setStatus(rs.getString("STATUS"));

                list.add(s);

            }

        }
        catch(Exception e){

            e.printStackTrace();

        }
        finally{

            try{

                if(rs!=null)
                    rs.close();

                if(ps!=null)
                    ps.close();

                if(con!=null)
                    con.close();

            }
            catch(Exception e){

                e.printStackTrace();

            }

        }

        return list;

    }

    // ==========================================
    // ACTIVATE STUDENT
    // ==========================================

    public boolean activateStudent(int id){

        boolean flag=false;

        try{

            Connection con=DBConnection.getConnection();

            String sql=
                    "UPDATE STUDENT SET STATUS='ACTIVE' WHERE STUDENT_ID=?";

            PreparedStatement ps=con.prepareStatement(sql);

            ps.setInt(1,id);

            int x=ps.executeUpdate();

            if(x>0){

                flag=true;

            }

            ps.close();

            con.close();

        }
        catch(Exception e){

            e.printStackTrace();

        }

        return flag;

    }

    // ==========================================
    // DEACTIVATE STUDENT
    // ==========================================

    public boolean deactivateStudent(int id){

        boolean flag=false;

        try{

            Connection con=DBConnection.getConnection();

            String sql=
                    "UPDATE STUDENT SET STATUS='INACTIVE' WHERE STUDENT_ID=?";

            PreparedStatement ps=con.prepareStatement(sql);

            ps.setInt(1,id);

            int x=ps.executeUpdate();

            if(x>0){

                flag=true;

            }

            ps.close();

            con.close();

        }
        catch(Exception e){

            e.printStackTrace();

        }

        return flag;

    }
 // ==========================================
 // GET STUDENT BY ID
 // ==========================================

 public Student getStudentById(int id) {

     Student s = null;

     Connection con = null;
     PreparedStatement ps = null;
     ResultSet rs = null;

     try {

         con = DBConnection.getConnection();

         String sql =
                 "SELECT " +
                 "S.STUDENT_ID, " +
                 "S.COLLEGE_ID, " +
                 "C.COLLEGE_NAME, " +
                 "S.COURSE_ID, " +
                 "CR.COURSE_NAME, " +
                 "S.NAME, " +
                 "S.EMAIL, " +
                 "S.PHONE, " +
                 "S.GENDER, " +
                 "S.STATUS " +
                 "FROM STUDENT S " +
                 "LEFT JOIN COLLEGE C " +
                 "ON S.COLLEGE_ID = C.COLLEGE_ID " +
                 "LEFT JOIN COURSE CR " +
                 "ON S.COURSE_ID = CR.COURSE_ID " +
                 "WHERE S.STUDENT_ID = ?";

         ps = con.prepareStatement(sql);

         ps.setInt(1, id);

         rs = ps.executeQuery();

         if (rs.next()) {

             s = new Student();

             s.setStudentId(rs.getInt("STUDENT_ID"));
             s.setCollegeId(rs.getInt("COLLEGE_ID"));
             s.setCollegeName(rs.getString("COLLEGE_NAME"));

             s.setCourseId(rs.getInt("COURSE_ID"));
             s.setCourseName(rs.getString("COURSE_NAME"));

             s.setName(rs.getString("NAME"));
             s.setEmail(rs.getString("EMAIL"));
             s.setPhone(rs.getString("PHONE"));
             s.setGender(rs.getString("GENDER"));
             s.setStatus(rs.getString("STATUS"));
         }

     } catch (Exception e) {

         e.printStackTrace();

     } finally {

         try {

             if (rs != null)
                 rs.close();

             if (ps != null)
                 ps.close();

             if (con != null)
                 con.close();

         } catch (Exception e) {

             e.printStackTrace();
         }
     }

     return s;
 }
}