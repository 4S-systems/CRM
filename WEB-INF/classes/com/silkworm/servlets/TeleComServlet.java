package com.silkworm.servlets;

import com.maintenance.common.Tools;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.telecom.TeleComGateway;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.util.logging.Level;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.asteriskjava.manager.AuthenticationFailedException;
import org.asteriskjava.manager.TimeoutException;

public class TeleComServlet extends TrackerBaseServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(this.getClass());
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        operation = getOpCode((String) request.getParameter("op"));
        WebBusinessObject wbo;
        switch (operation) {
            case 1:
                out = response.getWriter();
                wbo = new WebBusinessObject();
//                TeleComGateway telecomMgr = TeleComGateway.getInstance();
//                 {
//                    try {
//                        telecomMgr.callNumber("SIP/walid", "phones", "200");
//                    } catch (AuthenticationFailedException ex) {
//                        java.util.logging.Logger.getLogger(TeleComServlet.class.getName()).log(Level.SEVERE, null, ex);
//                    } catch (TimeoutException ex) {
//                        java.util.logging.Logger.getLogger(TeleComServlet.class.getName()).log(Level.SEVERE, null, ex);
//                    }
//                }
                wbo.setAttribute("status", "ok");
                out.write(Tools.getJSONObjectAsString(wbo));
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

    @Override
    public String getServletInfo() {
        return "Manage Web Clients Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("testCall")) {
            return 1;
        }
        return 0;
    }

}
