/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tracker.servlets;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.RequestItemsMgr;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author crm32
 */
public class RequestItemServlet extends TrackerBaseServlet {

    private RequestItemsMgr requestItemsMgr;
    private ProjectMgr projectMgr;
    private String ids;
    private String id;
    private String projectId;
    private String quantity;
    private String valid;
    private String note;

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
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        WebBusinessObject wbo;
        String issueId;

        requestItemsMgr = RequestItemsMgr.getInstance();
        projectMgr = ProjectMgr.getInstance();

        try {
            switch (operation) {
                case 1:
                    servedPage = "docs/requests/items.jsp";
                    ids = Tools.concatenation(request.getParameter("ids").split(","), ",");
                    List<WebBusinessObject> items = projectMgr.getRequestsItems(ids);

                    request.setAttribute("items", items);
                    this.forward(servedPage, request, response);
                    break;

                case 2:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    issueId = request.getParameter("issueId");
                    projectId = request.getParameter("projectId");
                    quantity = request.getParameter("quantity");
                    valid = request.getParameter("valid");
                    note = request.getParameter("note");
                    if ((id = requestItemsMgr.save(issueId, projectId, quantity, valid, note, loggegUserId, "UL", "UL", "UL", "UL", "UL", "UL")) != null) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", id);
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 3:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    id = request.getParameter("id");
                    quantity = request.getParameter("quantity");
                    valid = request.getParameter("valid");
                    note = request.getParameter("note");
                    if (requestItemsMgr.update(id, quantity, valid, note)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 4:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    id = request.getParameter("id");
                    if (requestItemsMgr.delete(id)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 5:
                    servedPage = "docs/requests/repeated_items_report.jsp";
                    String beDate = request.getParameter("beginDate");
                    String enDate = request.getParameter("endDate");
                    Hashtable topMenu = new Hashtable();
                    Vector tempVec = new Vector();
                    String lastFilter = new StringBuilder("RequestItemServlet?op=getRepeatedUnitItems&beginDate=").append(beDate).append("&endDate=").append(enDate).toString();
                    if (beDate != null && enDate != null) {
                        try {
                            DateParser dateParser = new DateParser();
                            Date beg = dateParser.formatSqlDate(beDate);
                            Date en = dateParser.formatSqlDate(enDate);
                            Date beginD = new java.sql.Date(beg.getTime());
                            Date endD = new java.sql.Date(en.getTime());
                            items = requestItemsMgr.getRepeatedUnitItems(beginD, endD);
                            request.setAttribute("data", items);
                            request.setAttribute("endDate", enDate);
                            request.setAttribute("beginDate", beDate);
                        } catch (Exception ex) {
                            logger.error(ex);
                        }

                        session.setAttribute("lastFilter", lastFilter);

                        topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                        if (topMenu != null && topMenu.size() > 0) {
                            tempVec = new Vector();
                            tempVec.add("lastFilter");
                            tempVec.add(lastFilter);
                            topMenu.put("lastFilter", tempVec);
                        } else {
                            topMenu = new Hashtable();
                            tempVec = new Vector();
                            tempVec.add("lastFilter");
                            tempVec.add(lastFilter);
                            topMenu.put("lastFilter", tempVec);
                        }
                        request.getSession().setAttribute("topMenu", topMenu);
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    servedPage = "docs/requests/repeated_item_issues.jsp";
                    ArrayList<WebBusinessObject> issues = requestItemsMgr.getRepeatedItemIssues(request.getParameter("itemID"), request.getParameter("unitName"));
                    request.setAttribute("issues", issues);
                    this.forward(servedPage, request, response);
                    break;
                case 7:
                    servedPage = "docs/requests/unit_items_report.jsp";
                    beDate = request.getParameter("beginDate");
                    enDate = request.getParameter("endDate");
                    if (beDate != null && enDate != null) {
                        try {
                            DateParser dateParser = new DateParser();
                            Date beg = dateParser.formatSqlDate(beDate);
                            Date en = dateParser.formatSqlDate(enDate);
                            Date beginD = new java.sql.Date(beg.getTime());
                            Date endD = new java.sql.Date(en.getTime());
                            Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();
                            Map<String, WebBusinessObject> unitResult = new HashMap<>();
                            ArrayList<WebBusinessObject> unitsList = requestItemsMgr.getRequestItemsUnit(beginD, endD);
                            for (WebBusinessObject unitWbo : unitsList) {
                                dataResult.put((String) unitWbo.getAttribute("unitName"), requestItemsMgr.getItemsByUnit(beginD, endD, (String) unitWbo.getAttribute("unitName")));
                                unitResult.put((String) unitWbo.getAttribute("unitName"), unitWbo);
                            }
                            request.setAttribute("dataResult", dataResult);
                            request.setAttribute("unitResult", unitResult);
                            request.setAttribute("endDate", enDate);
                            request.setAttribute("beginDate", beDate);
                        } catch (Exception ex) {
                            logger.error(ex);
                        }
                        topMenu = new Hashtable();
                        tempVec = new Vector();
                        lastFilter = new StringBuilder("RequestItemServlet?op=getRequestItemsUnit&beginDate=").append(beDate).append("&endDate=").append(enDate).toString();
                        session.setAttribute("lastFilter", lastFilter);

                        topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                        if (topMenu != null && topMenu.size() > 0) {
                            tempVec = new Vector();
                            tempVec.add("lastFilter");
                            tempVec.add(lastFilter);
                            topMenu.put("lastFilter", tempVec);
                        } else {
                            topMenu = new Hashtable();
                            tempVec = new Vector();
                            tempVec.add("lastFilter");
                            tempVec.add(lastFilter);
                            topMenu.put("lastFilter", tempVec);
                        }
                        request.getSession().setAttribute("topMenu", topMenu);
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 8:
                    servedPage = "docs/requests/items.jsp";
                    String locType = request.getParameter("locType");
                    
                    items = projectMgr.getBusinessItems(locType);
                    
                    request.setAttribute("items", items);
                    this.forward(servedPage, request, response);
                    break;
                default:
                    System.out.println("No operation was matched");
            }

        } catch (NumberFormatException ex) {
            System.out.println("Error Msg = " + ex.getMessage());
            logger.error(ex.getMessage());
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
        return "Search Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("listRequestItems")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("saveRequestItem")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("updateRequestItem")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("deleteRequestItem")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("getRepeatedUnitItems")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("getRepeatedItemIssues")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("getRequestItemsUnit")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("listBusinessItems")) {
            return 8;
        }
        return 0;
    }
}
