package com.tracker.servlets;

import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import com.silkworm.common.*;
import com.tracker.db_access.IncentiveMgr;
import com.tracker.db_access.ClientIncentiveMgr;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

public class IncentiveServlet extends TrackerBaseServlet {

    private String reqOp = null;
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            super.processRequest(request, response);
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

        } catch (IllegalStateException ise) {

        }
        reqOp = request.getParameter("op");
        int op = getOpCode(reqOp);
        switch (op) {
            case 1:
                servedPage = "/docs/incentive/new_incentive.jsp";
                System.out.println("new_incentive");
                ArrayList<WebBusinessObject> incentivesList = new ArrayList<WebBusinessObject>();
                String clientId = request.getParameter("clientId");
                request.setAttribute("clientId", clientId);
                if (clientId != null && !clientId.isEmpty()) {
                    try {
                        IncentiveMgr incentiveMgr = IncentiveMgr.getInstance();
                        incentivesList = new ArrayList<WebBusinessObject>(incentiveMgr.getOnArbitraryKeyOracle("1", "key3"));
                    } catch (Exception ex) {
                        Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("incentivesList", incentivesList);
                this.forward(servedPage, request, response);
                break;
            case 2:
                servedPage = "/docs/incentive/client_incentives.jsp";
                if (request.getParameter("firstTime") == null) {
                    try {
                        IncentiveMgr incentiveMgr = IncentiveMgr.getInstance();
                        incentivesList = new ArrayList<WebBusinessObject>(incentiveMgr.getOnArbitraryKeyOracle("1", "key3"));
                        String[] incentiveTitles = new String[incentivesList.size()];
                        int i = 0;
                        for (WebBusinessObject incentiveWbo : incentivesList) {
                            if (incentiveWbo.getAttribute("incentiveTitle") != null) {
                                incentiveTitles[i] = (String) incentiveWbo.getAttribute("incentiveTitle");
                            } else {
                                incentiveTitles[i] = "";
                            }
                            i++;
                        }
                        ArrayList<WebBusinessObject> clientIncentives = incentiveMgr.getClientIncentives(incentiveTitles, request.getParameter("startDate"), request.getParameter("endDate"));
                        request.setAttribute("clientIncentives", clientIncentives);
                        request.setAttribute("incentiveTitles", incentiveTitles);
                    } catch (Exception ex) {
                        Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                break;
            case 4:
                servedPage = "/docs/incentive/show_incentive_list.jsp";
                System.out.println("show_incentive_list.jsp");
                clientId = request.getParameter("clientId");
                request.setAttribute("clientId", clientId);
                if (clientId != null && !clientId.isEmpty()) {
                    try {
                        ClientIncentiveMgr clientIncentiveMgr = ClientIncentiveMgr.getInstance();
                        ArrayList<WebBusinessObject> clientIncentivesList = clientIncentiveMgr.getIncentivesByClientList(clientId);
                        request.setAttribute("clientIncentivesList", clientIncentivesList);
                    } catch (Exception ex) {
                        Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                this.forward(servedPage, request, response);
                break;
            default:
                System.out.println("No operation was matched");
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public int getOpCode(String operation) {
        if (operation.equalsIgnoreCase("getIncentiveForm")) {
            return 1;
        }
        if (operation.equalsIgnoreCase("viewClientIncentives")) {
            return 2;
        }
        if (operation.equalsIgnoreCase("listIncentives")) {
            return 3;
        }
        if (operation.equalsIgnoreCase("showIncentives")) {
            return 4;
        }
        return 0;
    }

    @Override
    public String getServletInfo() {
        return "Incentive Servlet";
    }
}
