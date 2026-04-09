package com.tracker.servlets;

import com.clients.db_access.ClientMgr;
import com.clients.servlets.ClientServlet;
import com.docviewer.servlets.ImageHandlerServlet;
import com.maintenance.common.Tools;
import com.maintenance.db_access.DistributionListMgr;
import com.maintenance.db_access.IssueDocumentMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import com.silkworm.common.*;
import com.tracker.db_access.ProjectMgr;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

public class SalesMarketingServlet extends ImageHandlerServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        reqOp = request.getParameter("op");
        int op = getOpCode(reqOp);
        switch (op) {
            case 1:
                PrintWriter out = response.getWriter();
                String searchBy = request.getParameter("searchBy");
                String searchByValue = null;
                String status = " ";
                String check = "check";
                WebBusinessObject wbo = new WebBusinessObject();
                ClientMgr clientMgr = ClientMgr.getInstance();

                Vector clientsVec = new Vector();
                WebBusinessObject result = new WebBusinessObject();
               /* if (searchBy.equalsIgnoreCase("clientId")) {
                    searchByValue = request.getParameter("searchValue");
                    request.setAttribute("clientId", searchByValue);
                    String clientId = request.getParameter("clientId");
                    ArrayList<WebBusinessObject> clientLst = new ArrayList<>();
                    try {
                        clientsVec = clientMgr.getClientsById(searchByValue.trim());
                        if (clientsVec != null) {
                            result.setAttribute("clientNoStatus", "ok");
                         } else {result.setAttribute("clientNoStatus", "no");
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    out.write(Tools.getJSONObjectAsString(result));
                    servedPage = "/docs/sales/search_for_client.jsp";
                     request.setAttribute("page", servedPage);
                     request.setAttribute("clientsVec", clientsVec);
                    this.forwardToServedPage(request, response);
                    break;
                } else */if (searchBy.equalsIgnoreCase("clientNo")) {
                    searchByValue = request.getParameter("searchValue");
                    request.setAttribute("clientNo", searchByValue);

                     String clientNo = request.getParameter("clientNo");
                 ArrayList<WebBusinessObject> clientLst = new ArrayList<>();
                
                    try {
//                        wbo = clientMgr.getOnSingleKey("key2", searchByValue.trim());
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        WebBusinessObject departmentWbo = null;
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }
                        if (departmentWbo != null) {
                            clientsVec = clientMgr.getClientsByNo(searchByValue.trim(), (String) departmentWbo.getAttribute("projectID"));
                            if (!clientsVec.isEmpty()) {
                                result.setAttribute("clientNoStatus", "ok");
                            } else if (clientsVec.isEmpty()) {
                                clientsVec = clientMgr.getClientByComVec(searchByValue.trim(), (String) departmentWbo.getAttribute("projectID"));
                                if (!clientsVec.isEmpty()) {
                                    result.setAttribute("clientNoStatus", "ok");
                                } else {
                                    result.setAttribute("clientNoStatus", "no");
                                }
                            }
                        } else {
                            clientsVec = new Vector();
                        }
                        if (clientsVec != null && !clientsVec.isEmpty()) {
                            wbo = null;
                        } else {
                            clientsVec = null;
                            status = "errorNo";
                            wbo = null;
                        }
                        request.setAttribute("status", status);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    out.write(Tools.getJSONObjectAsString(result));
                    servedPage = "/docs/sales/search_for_client.jsp";
                     request.setAttribute("page", servedPage);
                     request.setAttribute("clientsVec", clientsVec);
                    this.forwardToServedPage(request, response);
                    break;
                } else if (searchBy.equalsIgnoreCase("clientTel")) {
                    searchByValue = request.getParameter("clientTel");
                    request.setAttribute("clientTel", searchByValue);

                    try {
                        wbo = clientMgr.getOnSingleKey("key3", searchByValue.trim());
                        if (wbo != null) {
                            result.setAttribute("clientTelStatus", "ok");
                            result.setAttribute("clientId", wbo.getAttribute("id"));
                            result.setAttribute("age", wbo.getAttribute("age"));
                        } else {

                            result.setAttribute("clientTelStatus", "no");
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    out.write(Tools.getJSONObjectAsString(result));
                    break;
                } else if (searchBy.equalsIgnoreCase("clientMobile")) {
                    searchByValue = request.getParameter("clientMobile");
                    request.setAttribute("clientMobile", searchByValue);

                    try {
                        wbo = clientMgr.getOnSingleKey("key4", searchByValue.trim());
                        if (wbo != null) {
                            result.setAttribute("clientMobileStatus", "ok");
                            result.setAttribute("clientId", wbo.getAttribute("id"));
                            result.setAttribute("age", wbo.getAttribute("age"));
                        } else {

                            result.setAttribute("clientMobileStatus", "no");
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    out.write(Tools.getJSONObjectAsString(result));
                    break;
                } else if (searchBy.equalsIgnoreCase("clientName")) {
                    servedPage = "/docs/sales/search_for_client.jsp";
                    searchByValue = request.getParameter("searchValue");

                    String lastFilter = "SalesMarketingServlet?op=searchForClient&searchBy=clientName&searchValue=" + searchByValue;
                    session.setAttribute("lastFilter", lastFilter);

                    Hashtable topMenu = new Hashtable();
                    Vector tempVec = new Vector();
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

                    try {

                        ClientMgr cm = ClientMgr.getInstance();
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        WebBusinessObject departmentWbo;
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }
                        if (departmentWbo != null) {
                            clientsVec = cm.clientByNameForSales(searchByValue, (String) departmentWbo.getAttribute("projectID"));
                        } else {
                            clientsVec = new Vector();
                        }
                        if (clientsVec != null && !clientsVec.isEmpty()) {
                            wbo = null;
                        } else {
                            clientsVec = null;
                            status = "error";
                            wbo = null;
                        }

                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    
                  
                    request.setAttribute("clientsVec", clientsVec);
                    request.setAttribute("clientWbo", wbo);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                } else if (searchBy.equalsIgnoreCase("description")) {
                    servedPage = "/docs/sales/search_for_client.jsp";
                    searchByValue = request.getParameter("searchValue");
                    try {
                        ClientMgr cm = ClientMgr.getInstance();
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        WebBusinessObject departmentWbo;
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }
                        if (departmentWbo != null) {
                            clientsVec = cm.clientByDescForSales(searchByValue, (String) departmentWbo.getAttribute("projectID"));
                        } else {
                            clientsVec = new Vector();
                        }
                        if (clientsVec != null && !clientsVec.isEmpty()) {
                            wbo = null;
                        } else {
                            clientsVec = null;
                            status = "error";
                            wbo = null;
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("clientsVec", clientsVec);
                    request.setAttribute("description", searchByValue);
                    request.setAttribute("clientWbo", wbo);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }else if (searchBy.equalsIgnoreCase("email")) {
                    servedPage = "/docs/sales/search_for_client.jsp";
                    searchByValue = request.getParameter("searchValue");
                    try {
                        ClientMgr cm = ClientMgr.getInstance();
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        WebBusinessObject departmentWbo;
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }
                        if (departmentWbo != null) {
                            clientsVec = cm.clientByEmailForSales(searchByValue, (String) departmentWbo.getAttribute("projectID"));
                        } else {
                            clientsVec = new Vector();
                        }
                        if (clientsVec != null && !clientsVec.isEmpty()) {
                            wbo = null;
                        } else {
                            clientsVec = clientMgr.getClientByOtherEmails(searchByValue, (String) departmentWbo.getAttribute("projectID"));
                            if(clientsVec.isEmpty())
                            status = "error";
                            wbo = null;
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("clientsVec", clientsVec);
                    request.setAttribute("email", searchByValue);
                    request.setAttribute("clientWbo", wbo);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }

                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                break;
            case 5:
                break;
            case 6:
                servedPage = "/docs/sales/search_for_client.jsp";
                ClientMgr cm = ClientMgr.getInstance();
                DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();

                try {
                    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    WebBusinessObject departmentWbo;
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                    if (departmentWbo != null) {
                        clientsVec = cm.clientByNameForSales("", (String) departmentWbo.getAttribute("projectID"));

                        String ownerUser;
                        for (Object object : clientsVec) {
                            wbo = (WebBusinessObject) object;
                            ownerUser = distributionListMgr.getLastResponsibleEmployee((String) wbo.getAttribute("id"));
                            if (ownerUser != null) {
                                wbo.setAttribute("ownerUser", ownerUser);
                            }
                        }
                    } else {
                        clientsVec = new Vector();
                    }
                    status = " ";
                    check = "check";
                    if (clientsVec != null && !clientsVec.isEmpty()) {
                        wbo = null;
                    } else {
                        clientsVec = null;
                        status = "error";
                        wbo = null;
                    }

                    String lastFilter = "SalesMarketingServlet?op=SearchForAllClients";
                    session.setAttribute("lastFilter", lastFilter);

                    Hashtable topMenu = new Hashtable();
                    Vector tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
//                        topMenu.put("jobOrder", new Vector());
//                        topMenu.put("maintItem", new Vector());
//                        topMenu.put("schedule", new Vector());
//                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    request.setAttribute("clientsVec", clientsVec);
                    request.setAttribute("clientWbo", wbo);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                } catch (SQLException ex) {
                    Logger.getLogger(SalesMarketingServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
                case 7:
                out = response.getWriter();
                boolean saved=false;
                wbo=new WebBusinessObject();
                WebBusinessObject wbo2=new WebBusinessObject();
                ProjectMgr projectMgr=ProjectMgr.getInstance();
                Vector<WebBusinessObject> mainProj=new Vector<WebBusinessObject>();
                try {
                    mainProj=projectMgr.getOnArbitraryDoubleKey(request.getParameter("type"), "key6", "0", "key2");
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                wbo2.setAttribute("project_name",request.getParameter("newName"));
                if (request.getParameter("type").equals("rqst")){
                String orderROW = ProjectMgr.getInstance().getLastReq();
                wbo2.setAttribute("eqNO",orderROW);
                } else if (request.getParameter("type").equals("cmplnt")){
                String claimROW = ProjectMgr.getInstance().getLastReq2();
                wbo2.setAttribute("eqNO",claimROW);
                } else if (request.getParameter("type").equals("cmplnt")){
                String queryROW = ProjectMgr.getInstance().getLastReq3();
                wbo2.setAttribute("eqNO",queryROW);
                }
                wbo2.setAttribute("project_desc",request.getParameter("newDesc"));
                wbo2.setAttribute("location_type",request.getParameter("type"));
                wbo2.setAttribute("futile","0");
                wbo2.setAttribute("isMngmntStn","0");
                wbo2.setAttribute("isTrnsprtStn","0");
                wbo2.setAttribute("mainProjectId",mainProj.get(0).getAttribute("projectID"));
                
                projectMgr=ProjectMgr.getInstance();
                try {
                    saved=projectMgr.saveObject2(wbo2,session);
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if(saved){
                    wbo.setAttribute("status", "ok");
                }else{
                    wbo.setAttribute("status", "no");
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                case 8:
                out = response.getWriter();
                wbo=new WebBusinessObject();
                int deleted=0;
                String documentID=request.getParameter("documentID");
                String issueId=request.getParameter("issueId");
                String objectType=request.getParameter("objectType");
                String docTitle=request.getParameter("docTitle");
                String docType=request.getParameter("docType");
                IssueDocumentMgr issueDocumentMgr=IssueDocumentMgr.getInstance();
                
                    try {
                        deleted=issueDocumentMgr.deleteIssueDoc(documentID);
                    } catch (Exception ex) {
                        Logger.getLogger(SalesMarketingServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                wbo.setAttribute("status", deleted>0 ?"ok":"failed");
                out.write(Tools.getJSONObjectAsString(wbo));
                out.flush();
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
        if (operation.equalsIgnoreCase("searchForClient")) {
            return 1;
        }
        if (operation.equalsIgnoreCase("sendByAjax")) {
            return 2;
        }
        if (operation.equalsIgnoreCase("attachFile")) {
            return 3;
        }
        if (operation.equalsIgnoreCase("showAttachedFiles")) {
            return 4;
        }
        if (operation.equalsIgnoreCase("viewDocument")) {
            return 5;
        }
        if (operation.equalsIgnoreCase("SearchForAllClients")) {
            return 6;
        }
        if (operation.equalsIgnoreCase("saveNewRequests")) {
            return 7;
        }
        if (operation.equalsIgnoreCase("removeUploadedFile")) {
            return 8;
        }
        return 0;
    }

    @Override
    public String getServletInfo() {
        return "Sales & Marketing Servlet";
    }
}
