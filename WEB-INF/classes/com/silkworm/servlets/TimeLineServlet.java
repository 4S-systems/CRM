/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.servlets;

import com.clients.db_access.ClientComplaintsTimeLineMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author walid
 */
public class TimeLineServlet extends TrackerBaseServlet {

    private ClientComplaintsTimeLineMgr timeLineMgr;
    private List<WebBusinessObject> data;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        
        timeLineMgr = ClientComplaintsTimeLineMgr.getInstance();

        switch (operation) {
            case 1:
                servedPage = "/docs/timeline/age_requests_from_finish.jsp";
                
                data = timeLineMgr.getClinetComplaintsTimeLineFromFinish();

                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:
                servedPage = "/docs/timeline/time_age_by_department.jsp";
                IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                if (request.getParameter("type") != null) {
                    try {
                        data = issueByComplaintMgr.getTimeAgeByDepartmentSince(request.getParameter("since"),
                                request.getParameter("departmentID"), request.getParameter("type"));
                        request.setAttribute("data", data);
                    } catch (Exception ex) {
                        Logger.getLogger(TimeLineServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("type", request.getParameter("type"));
                    request.setAttribute("since", request.getParameter("since"));
                    request.setAttribute("departmentID", request.getParameter("departmentID"));
                }
                try {
                    request.setAttribute("departmentsList", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("div", "key6")));
                } catch (Exception ex) {
                    Logger.getLogger(TimeLineServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            default:
                System.out.println("No operation was matched");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "TimeLineServlet Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("ageRequestsFromFinish")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("getTimeAgeByDepartment")) {
            return 2;
        }
        return 0;
    }
}
