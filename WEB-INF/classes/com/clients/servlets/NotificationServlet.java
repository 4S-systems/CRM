/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.clients.servlets;

import com.clients.db_access.ClientComplaintsSLAMgr;
import com.clients.db_access.SLANotificationMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.AutomationConfigurationMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.web.util.WebXmlUtil;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author walid
 */
public class NotificationServlet extends TrackerBaseServlet {

    private SLANotificationMgr sLANotificationMgr;
    private IssueByComplaintMgr issueByComplaintMgr;
    private ClientComplaintsSLAMgr clientComplaintsSLAMgr;
    private List<WebBusinessObject> notification;
    private String notificationId;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        this.sLANotificationMgr = SLANotificationMgr.getInstance();
        this.issueByComplaintMgr = IssueByComplaintMgr.getInstance();
        this.clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();

        switch (operation) {
            case 1:
                notification = sLANotificationMgr.getSLANotification(loggegUserId, (int) AutomationConfigurationMgr.getCurrentInstance().getSLARemainingTime());
                out = response.getWriter();
                out.write(Tools.getJSONArrayAsString(notification));
                break;

            case 2:
                notificationId = request.getParameter("notificationId");
                clientComplaintsSLAMgr.acceptSLA(notificationId);
                break;

            case 3:
                notificationId = request.getParameter("id");
                try {
                    Vector<WebBusinessObject> complaints = issueByComplaintMgr.getOnArbitraryKey(notificationId, "key4");
                    if (complaints != null && !complaints.isEmpty()) {
                        wbo = complaints.elementAt(0);
                        servedPage = "/IssueServlet?op=getCompl&issueId=" + wbo.getAttribute("issue_id") + "&compId=" + wbo.getAttribute("clientComId") + "&statusCode=" + wbo.getAttribute("statusCode") + "&receipId=" + wbo.getAttribute("receipId") + "&senderID=" + wbo.getAttribute("senderId") + "&clientType=" + wbo.getAttribute("age");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                break;
            case 4:
                servedPage = "/docs/sla/sla_complaint_history.jsp";
                LoggerMgr loggerMgr = LoggerMgr.getInstance();
                ArrayList<WebBusinessObject> logsList = new ArrayList<>();
                ArrayList<WebBusinessObject> tempList;
                String eventTime;
                try {
                    tempList = new ArrayList<>(loggerMgr.getOnArbitraryDoubleKeyOracleOrderBy("10", "key4", request.getParameter("id"), "key2", "key5"));
                    for (WebBusinessObject logWbo : tempList) {
                        eventTime = (String) logWbo.getAttribute("eventTime");
                        logWbo = new WebBusinessObject(WebXmlUtil.convertXmlToMap((String) logWbo.getAttribute("objectXml")));
                        logWbo.setAttribute("creationTime", eventTime);
                        logsList.add(logWbo);
                    }
                } catch (Exception ex) {
                    logsList = new ArrayList<>();
                    Logger.getLogger(NotificationServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("logsList", logsList);
                this.forward(servedPage, request, response);
                break;
        }
    }
// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("getSLANotificationAjax")) {
            return 1;
        }

        if (opName.equals("acceptSLANotification")) {
            return 2;
        }

        if (opName.equals("openSLANotification")) {
            return 3;
        }

        if (opName.equals("displaySLAHistory")) {
            return 4;
        }
        return 0;
    }
}
