package com.campusconnect.dao;

import com.campusconnect.bean.SuperAdmin;

public class LoginTest {

    public static void main(String[] args) {

        SuperAdminDAO dao = new SuperAdminDAO();
        
        //LOGIN  EMAIL AND PASSWORD 
        SuperAdmin admin = dao.login("superadmin@gmail.com ", "superadmin123");

        if(admin!=null) {

            System.out.println("Login Success");

            System.out.println(admin.getName());

            System.out.println(admin.getEmail());

        }

        else {

            System.out.println("Login Failed");

        }

    }

}