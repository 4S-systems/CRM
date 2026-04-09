package com.maintenance.servlets;

import com.maintenance.db_access.EqpMoveHistoryMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.Vector;

public class EqpMoveHistoryServlet extends TrackerBaseServlet {

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        EqpMoveHistoryMgr eqpMoveHistoryMgr = EqpMoveHistoryMgr.getInstance();
        WebBusinessObject paramsWbo = new WebBusinessObject();
        switch (operation) {
            case 1:
                servedPage = "/docs/equipment/move_equipment.jsp";
                request.setAttribute("page", servedPage);
                WebBusinessObject temp = new WebBusinessObject();
                temp = projectMgr.getOnSingleKey(request.getParameter("location"));
                request.setAttribute("location", temp.getAttribute("projectName"));
                request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                request.setAttribute("projects", projectMgr.getAllAsArrayList());
                this.forwardToServedPage(request, response);
                break;

            case 2:
                boolean result = false;
                paramsWbo = new WebBusinessObject();
                paramsWbo.setAttribute("equipmentID", request.getParameter("equipmentID"));
                paramsWbo.setAttribute("location", request.getParameter("location"));
                paramsWbo.setAttribute("beginDate", request.getParameter("beginDate"));
                paramsWbo.setAttribute("reason", request.getParameter("reason"));
                try {
                    result = eqpMoveHistoryMgr.saveObject(paramsWbo);
                } catch (SQLException ex) {
                    Logger.getLogger(EqpMoveHistoryServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (result == false) {
                    request.setAttribute("status", "error");
                } else {
                    request.setAttribute("status", "done");
                }
                this.forward("EqpMoveHistoryServlet?op=MoveForm", request, response);
                break;

            case 3:
                servedPage = "/docs/equipment/view_history.jsp";
                request.setAttribute("page", servedPage);
                request.setAttribute("unitName", request.getParameter("unitName"));
                request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                Vector tempHistory = new Vector();
                Vector history = new Vector();
                try {
                    tempHistory = eqpMoveHistoryMgr.getOnArbitraryKeyOrdered(request.getParameter("equipmentID"), "key1", "order2");
                } catch (SQLException ex) {
                    Logger.getLogger(EqpMoveHistoryServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(EqpMoveHistoryServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                temp = new WebBusinessObject();
                WebBusinessObject location = new WebBusinessObject();
                for (int i = 0; i < tempHistory.size(); i++) {
                    temp = (WebBusinessObject) tempHistory.get(i);
                    location = projectMgr.getOnSingleKey(temp.getAttribute("locationId").toString());
                    temp.setAttribute("location", location.getAttribute("projectName"));
                    history.add(temp);
                }
                request.setAttribute("history", history);
                this.forwardToServedPage(request, response);
                break;
            default:
                logger.info("No operation was matched");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public String getServletInfo() {
        return "EqpMoveHistory Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("MoveForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("SaveMove")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("viewHistory")) {
            return 3;
        }
        return 0;
    }
}
