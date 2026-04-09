/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.silkworm.servlets;

import com.maintenance.common.Tools;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MessagesMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author walid
 */
public class SessionsServlet extends TrackerBaseServlet {

    /**
     * Initializes the servlet.
     */

    /**
     *
     * @param config
     * @throws ServletException
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    /**
     * Destroys the servlet.
     */
    @Override
    public void destroy() {

    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject wbo;
        switch (operation) {
                
            case 1:
                request.setAttribute("sessions", sessionRegistery.getSessions());
                request.setAttribute("page", "/docs/sessions/current_session.jsp");
                forwardToServedPage(request, response);
                break;
                
            case 2:
                PrintWriter writer = response.getWriter();
                wbo = new WebBusinessObject();
                String sessionId = request.getParameter("sessionId");
                if (sessionRegistery.closeSession(sessionId, true)) {
                    wbo.setAttribute("status", "ok");
                } else {
                    wbo.setAttribute("status", "no");
                }
                writer.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 3:
                session.invalidate();
                this.goToIndex(request, response);
                break;
                
            case 4:
                request.setAttribute("sessions", sessionRegistery.getSessions());
                request.setAttribute("page", "/docs/websocket/notification_sender.jsp");
                forwardToServedPage(request, response);
                break;
            case 5:
                persistentSessionMgr.cashData();
                if (request.getParameter("terminate") != null) {
                    String[] userIDs = request.getParameterValues("userID");
                    if(userIDs != null) {
                        for(String userID : userIDs) {
                            try {
                                persistentSessionMgr.deleteOnArbitraryKey(userID, "key1");
                            } catch (Exception ex) {
                                Logger.getLogger(SessionsServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                }
                request.setAttribute("usersList", persistentSessionMgr.getUsersWithDepartment());
                request.setAttribute("page", "/docs/sessions/list_users.jsp");
                forwardToServedPage(request, response);
                break;
            case 6:
                request.setAttribute("messagesList", MessagesMgr.getInstance().getCashedTableAsArrayList());
                request.setAttribute("page", "/docs/sessions/messages_list.jsp");
                forwardToServedPage(request, response);
                break;
            case 7:
                if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                    request.setAttribute("wbo", MessagesMgr.getInstance().getOnSingleKey(request.getParameter("id")));
                }
                forward("/docs/sessions/new_system_message.jsp", request, response);
                break;
            case 8:
                wbo = new WebBusinessObject();
                wbo.setAttribute("message", request.getParameter("message"));
                wbo.setAttribute("onDate", request.getParameter("onDate"));
                wbo.setAttribute("frequency", request.getParameter("frequency"));
                wbo.setAttribute("period", request.getParameter("period"));
                wbo.setAttribute("status", request.getParameter("status"));
                wbo.setAttribute("option1", request.getParameter("title"));
                wbo.setAttribute("option2", request.getParameter("messageType"));
                wbo.setAttribute("option3", "UL");
                wbo.setAttribute("option4", "UL");
                wbo.setAttribute("option5", "UL");
                wbo.setAttribute("option6", "UL");
                if (MessagesMgr.getInstance().saveObject(wbo)) {
                    wbo.setAttribute("status", "ok");
                    session.getServletContext().setAttribute("messagesList", MessagesMgr.getInstance().getAllActiveMessages());
                } else {
                    wbo.setAttribute("status", "fail");
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 9:
                wbo = new WebBusinessObject();
                wbo.setAttribute("id", request.getParameter("id"));
                wbo.setAttribute("message", request.getParameter("message"));
                wbo.setAttribute("onDate", request.getParameter("onDate"));
                wbo.setAttribute("frequency", request.getParameter("frequency"));
                wbo.setAttribute("period", request.getParameter("period"));
                wbo.setAttribute("status", request.getParameter("status"));
                wbo.setAttribute("option1", request.getParameter("title"));
                wbo.setAttribute("option2", request.getParameter("messageType"));
                wbo.setAttribute("option3", "UL");
                wbo.setAttribute("option4", "UL");
                wbo.setAttribute("option5", "UL");
                wbo.setAttribute("option6", "UL");
                if (MessagesMgr.getInstance().updateObject(wbo)) {
                    wbo.setAttribute("status", "ok");
                    session.getServletContext().setAttribute("messagesList", MessagesMgr.getInstance().getAllActiveMessages());
                } else {
                    wbo.setAttribute("status", "fail");
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 10:
                wbo = new WebBusinessObject();
                if (MessagesMgr.getInstance().deleteOnSingleKey(request.getParameter("id"))) {
                    wbo.setAttribute("status", "ok");
                    session.getServletContext().setAttribute("messagesList", MessagesMgr.getInstance().getAllActiveMessages());
                } else {
                    wbo.setAttribute("status", "fail");
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                    
            default:
                break;
        }

    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
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
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return 
     */
    @Override
    public String getServletInfo() {
        return "Sessions Servlet";
    }

    @Override
    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("currentSessions")) {
            return 1;
        }
        
        if (opName.equalsIgnoreCase("closeSession")) {
            return 2;
        }
        
        if (opName.equalsIgnoreCase("logout")) {
            return 3;
        }
        
        if (opName.equalsIgnoreCase("sendNotification")) {
            return 4;
        }
        
        if (opName.equalsIgnoreCase("listUsers")) {
            return 5;
        }
        
        if (opName.equalsIgnoreCase("listSystemMessages")) {
            return 6;
        }
        
        if (opName.equalsIgnoreCase("getNewMessage")) {
            return 7;
        }
        
        if (opName.equalsIgnoreCase("saveNewMessage")) {
            return 8;
        }
        
        if (opName.equalsIgnoreCase("updateMessage")) {
            return 9;
        }
        
        if (opName.equalsIgnoreCase("deleteMessage")) {
            return 10;
        }

        return 0;
    }
}
