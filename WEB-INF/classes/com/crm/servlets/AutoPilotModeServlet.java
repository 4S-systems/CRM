/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.crm.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.crm.common.AutoPilotFeature;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author haytham
 */
public class AutoPilotModeServlet extends TrackerBaseServlet {

    private AutoPilotFeature feature;
    private String[] customerIds;
    private String[] employeeId;
    private String mode;

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
        HttpSession session = request.getSession();
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        
        feature = new AutoPilotFeature();
        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                String fromURL = request.getParameter("fromURL");
                customerIds = request.getParameterValues("customerId");
                mode = request.getParameter("mode");
                employeeId = null;
                if ("manual".equalsIgnoreCase(mode)) {
                    employeeId = request.getParameterValues("employeeId");
                }

                if (customerIds != null) {
                    for (int i = 0; i < customerIds.length; i++) {
                        String customerId = customerIds[i];
                        feature.autoPilot(customerId, employeeId[i % employeeId.length], session, persistentUser,
                                request.getParameter("loggedOnly") != null && "true".equals(request.getParameter("loggedOnly")),
                                request.getParameter("requestType") != null ? request.getParameter("requestType") : null);
                    }
                }
                
                ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                clientComplaintsMgr.updateClientComplaintsType();
                
                request.setAttribute("redirect", "true");
                request.setAttribute("status", "saved");
                this.forward("/ClientServlet?op=" + fromURL, request, response);
                break;
		
	    case 2:
                customerIds = request.getParameterValues("customerId");
                mode = request.getParameter("mode");
                employeeId = null;
                if ("manual".equalsIgnoreCase(mode)) {
                    employeeId = request.getParameterValues("employeeId");
                }

                if (customerIds != null) {
                    for (int i = 0; i < customerIds.length; i++) {
                        String customerId = customerIds[i];
                        feature.autoPilot(customerId, employeeId[i % employeeId.length], session, persistentUser,
                                request.getParameter("loggedOnly") != null && "true".equals(request.getParameter("loggedOnly")),
                                request.getParameter("requestType") != null ? request.getParameter("requestType") : null);
			
			issueMgr.deleteWithdraw(customerIds[i]);
                    }
                }
		
                request.setAttribute("redirect", "true");
                request.setAttribute("status", "saved");
                this.forward("/IssueServlet?op=withdrawReport", request, response);
                break;
                
            case 3:
                customerIds = request.getParameterValues("customerId");
                mode = request.getParameter("mode");
                employeeId = null;
                if ("manual".equalsIgnoreCase(mode)) {
                    employeeId = request.getParameterValues("employeeId");
                }

                if (customerIds != null) {
                    for (int i = 0; i < customerIds.length; i++) {
                        String customerId = customerIds[i];
                        feature.autoPilot(customerId, employeeId[i % employeeId.length], session, persistentUser,
                                request.getParameter("loggedOnly") != null && "true".equals(request.getParameter("loggedOnly")),
                                request.getParameter("requestType") != null ? request.getParameter("requestType") : null);
			
			issueMgr.deleteWithdraw(customerIds[i]);
                    }
                }
		
                request.setAttribute("redirect", "true");
                request.setAttribute("status", "saved");
                this.forward("/ReportsServletThree?op=employeesWithdraws", request, response);
                break;    

            default:
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Group Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("distributeLeadCustomers")) {
            return 1;
        }
	
	if (opName.equalsIgnoreCase("distributeWithdrawCustomers")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("distributeWithdrawemployeesClients")) {
            return 3;
        }

        return 0;
    }
}
