/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sms.sender;

import com.clients.db_access.ClientMgr;
import static com.clients.db_access.ClientRatingMgr.clientRatingMgr;
import com.maintenance.common.Tools;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.servlets.SearchServlet;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/**
 *
 * @author walid
 */
public class SmsSenderServlet extends TrackerBaseServlet {

     String op = null;
     WebBusinessObject userObj = null;
     SmsSenderMgr smsSenderMgr;
     smsSender sender;
     ClientMgr clientMgr;
     public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(SmsSenderServlet.class);

    }

   
    public void destroy() {}
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");   
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        smsSenderMgr=SmsSenderMgr.getInstance();
        sender=smsSender.getInstance();
        clientMgr=ClientMgr.getInstance();
        switch (operation) {
            case 1:
                servedPage = "/docs/customization/smsService.jsp";
                if(request.getParameter("send")!=null)
                {
                smsSenderMgr.test();
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            case 2:
                out = response.getWriter();
                String msg=request.getParameter("msgText");
                String id=request.getParameter("mob");
                 WebBusinessObject clientWbo = clientMgr.getOnSingleKey("key", id);
              String mobile = clientWbo != null && clientWbo.getAttribute("mobile") != null && !clientWbo.getAttribute("mobile").equals("UL") ? (String) clientWbo.getAttribute("mobile") : "";

                WebBusinessObject wbo = new WebBusinessObject();
               if(smsSenderMgr.send(mobile, msg))
                  wbo.setAttribute("status", "ok");
               else
                     wbo.setAttribute("status", "no");
               out.write(Tools.getJSONObjectAsString(wbo));

                break;
                
           default:
                 break;
         }
                     

    }

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    
    protected int getOpCode(String opName)
    { 
        if (opName.equalsIgnoreCase("sendSmsService")) 
        {
            return 1;
        }else if (opName.equalsIgnoreCase("sendSmsforClient")) 
        {
            return 2;
        }
        
        
    return 0;
    }
    
    
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
