package com.campusconnect.servlet;

import java.io.IOException;
import java.util.ArrayList;

import com.campusconnect.bean.RecruitmentDrive;
import com.campusconnect.dao.RecruitmentDriveDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class MonitorRecruitmentServlet
extends HttpServlet
{

    public void doGet(HttpServletRequest req,
            HttpServletResponse res)
            throws IOException,ServletException
    {

        RecruitmentDriveDAO dao =
                new RecruitmentDriveDAO();

        ArrayList<RecruitmentDrive> list =
                dao.getAllDrives();

        req.setAttribute("driveList", list);

        req.getRequestDispatcher(
        "superadmin/monitorRecruitment.jsp")
        .forward(req,res);

    }

}