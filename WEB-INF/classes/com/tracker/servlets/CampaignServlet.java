package com.tracker.servlets;

import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.fin.db_access.ChannelsExpenseMgr;
import com.clients.db_access.ClientRatingMgr;
import com.crm.common.CRMConstants;
import com.crm.servlets.CalendarServlet;
import com.docviewer.servlets.ImageHandlerServlet;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.db_access.DistributionListMgr;
import com.planning.db_access.RecordSeasonMgr;
import com.planning.db_access.SeasonMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import com.silkworm.common.*;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.pagination.Filter;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.CampaignProjectMgr;
import com.tracker.db_access.ClientCampaignMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class CampaignServlet extends ImageHandlerServlet {
    private CampaignMgr campaignMgr;
    private ClientCampaignMgr clientCampMgr;
    private String reqOp = null;
    private List<WebBusinessObject> clients;
    private WebBusinessObject campaign;
    private String campaignId;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        campaignMgr = CampaignMgr.getInstance();
        clientCampMgr = ClientCampaignMgr.getInstance();
    }

    @Override
    public void destroy() {}

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");
            super.processRequest(request, response);
        } catch (IllegalStateException ise) {}
        
        HttpSession session = request.getSession();
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        reqOp = request.getParameter("op");
        int op = getOpCode(reqOp);
        switch (op) {
            case 1:
                servedPage = "/docs/campaign/new_campaign.jsp";
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                try {
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key4")));
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                WebBusinessObject campaignWbo = new WebBusinessObject();
                campaignWbo.setAttribute("campaignTitle", request.getParameter("campaignTitle"));
                campaignWbo.setAttribute("fromDate", request.getParameter("fromDate"));
                campaignWbo.setAttribute("toDate", request.getParameter("toDate"));
                campaignWbo.setAttribute("cost", request.getParameter("cost"));
                campaignWbo.setAttribute("objective", request.getParameter("objective"));
                campaignWbo.setAttribute("toolID", "UL");
                campaignWbo.setAttribute("parentID", "0");
                campaignWbo.setAttribute("campaignType", "compound");
                campaignWbo.setAttribute("currentStatus", "16");
                campaignWbo.setAttribute("direction", request.getParameter("direction"));
                CampaignProjectMgr campaignProjectMgr = CampaignProjectMgr.getInstance();
                if (campaignMgr.saveObject(campaignWbo, (WebBusinessObject) session.getAttribute("loggedUser")) && campaignProjectMgr.saveProjectsByCampaign((String) campaignWbo.getAttribute("id"), request.getParameterValues("projects"), session)) {
                    request.setAttribute("status", "Ok");
                } else {
                    request.setAttribute("status", "faild");
                }
                
                RecordSeasonMgr recordSeasonMgr = RecordSeasonMgr.getInstance();
                try {
                    request.setAttribute("toolsList", new ArrayList<WebBusinessObject>(recordSeasonMgr.getOnArbitraryKeyOracle("0", "key1")));
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("campaignProjectsList", campaignProjectMgr.getProjectByCampaignList((String) campaignWbo.getAttribute("id")));
                servedPage = "/docs/campaign/new_campaign.jsp";
                request.setAttribute("campaignWbo", campaignWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                PrintWriter out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
                securityUser.setDefaultCampaign(request.getParameter("campaignId"));
                campaignWbo = campaignMgr.getOnSingleKey(request.getParameter("campaignId"));
                campaignWbo.setAttribute("status", "ok");
                session.setAttribute("securityUser", securityUser);
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;
                
            case 4:
                out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                if (securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
                    campaignWbo.setAttribute("status", "ok");
                } else {
                    campaignWbo.setAttribute("status", "no");
                }
                
                session.setAttribute("securityUser", securityUser);
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;
                
            case 5:
                out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                campaignWbo.setAttribute("campaignTitle", request.getParameter("campaignTitle"));
                campaignWbo.setAttribute("fromDate", request.getParameter("fromDate"));
                campaignWbo.setAttribute("toDate", request.getParameter("toDate"));
                campaignWbo.setAttribute("cost", request.getParameter("cost"));
                campaignWbo.setAttribute("objective", request.getParameter("objective"));
                campaignWbo.setAttribute("toolID", request.getParameter("toolID"));
                campaignWbo.setAttribute("parentID", request.getParameter("parentID"));
                campaignWbo.setAttribute("campaignType", "subcampaign");
                campaignWbo.setAttribute("currentStatus", "UL");
                campaignWbo.setAttribute("direction", request.getParameter("direction"));
                if (campaignMgr.saveObject(campaignWbo, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                    campaignWbo.setAttribute("status", "Ok");
                } else {
                    campaignWbo.setAttribute("status", "faild");
                }
                
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                WebBusinessObject toolWbo = recordSeasonMgr.getOnSingleKey(request.getParameter("toolID"));
                if (toolWbo != null) {
                    campaignWbo.setAttribute("toolName", toolWbo.getAttribute("arabicName"));
                }
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;
                
            case 6:
                out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                campaignMgr = CampaignMgr.getInstance();
                try {
                    if (campaignMgr.deleteSubCampaign(request.getParameter("campaignID"))) { //                            && campaignProjectMgr.deleteOnArbitraryKey(request.getParameter("campaignID"), "key1") > 0
                        campaignWbo.setAttribute("status", "Ok");
                    } else {
                        campaignWbo.setAttribute("fdelete_Statusstatus", "faild");
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    campaignWbo.setAttribute("fdelete_Statusstatus", "faild");
                }
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;

            case 7:
                servedPage = "/docs/campaign/campaigns_list.jsp";
                campaignMgr = CampaignMgr.getInstance();
                Calendar c = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String toDateStr = request.getAttribute("toDate") != null ? request.getParameter("toDate") : sdf.format(c.getTime());
                c.add(Calendar.MONTH, -1);
                String fromDateStr = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(c.getTime());
                String mainOnly = request.getParameter("fromDate") != null ? request.getParameter("mainOnly") : "1";
                try {
                    ArrayList<WebBusinessObject> campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(fromDateStr, toDateStr, request.getParameter("statusID"),
                            (String) persistentUser.getAttribute("userId"), request.getParameter("departmentID"), "1".equals(mainOnly)));
                    for (WebBusinessObject tempWbo : campaignsList) {
                        if ("UL".equals(tempWbo.getAttribute("currentStatus"))) {
                            tempWbo.setAttribute("currentStatus", "15"); // for sub campaigns set its status to planned
                        }
                        tempWbo.setAttribute("currentStatusName", campaignMgr.getCampaignStatusName((String) tempWbo.getAttribute("currentStatus"), "en"));
                    }
                    
                    request.setAttribute("campaignsList", campaignsList);

                    // to add the all campaignTool List HashMap
                    HashMap<String, ArrayList> campaignToolsList = new HashMap<String, ArrayList>();
                    HashMap<String, Integer> campaignClientsList = new HashMap<String, Integer>();
                    ArrayList tools;
                    recordSeasonMgr = RecordSeasonMgr.getInstance();
                    for (int i = campaignsList.size() - 1; i >= 0; i--) {
                        campaign = campaignsList.get(i);
                        campaignId = (String) campaign.getAttribute("id");
                        tools = recordSeasonMgr.getToolsForCampaign(campaignId);
                        clients = clientCampMgr.getClientsByCampaignList(campaignId, null, null);
                        campaignToolsList.put(campaignId, tools);
                        campaignClientsList.put(campaignId, clients.size());
                    }
                    
                    request.setAttribute("campaignToolsList", campaignToolsList);
                    request.setAttribute("campaignClientsList", campaignClientsList);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                ArrayList<WebBusinessObject> departments = new ArrayList<>();
                UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) persistentUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }
                } catch (Exception ex) {
                }
                
                request.setAttribute("statusesList", campaignMgr.getCampaignStatuses());
                request.setAttribute("statusID", request.getParameter("statusID"));
                request.setAttribute("departmentID", request.getParameter("departmentID"));
                request.setAttribute("departments", departments);
                request.setAttribute("toDate", toDateStr);
                request.setAttribute("fromDate", fromDateStr);
                request.setAttribute("mainOnly", mainOnly);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                out = response.getWriter();

                WebBusinessObject statusWbo = new WebBusinessObject();
                statusWbo.setAttribute("status", "faild");
                campaignMgr = CampaignMgr.getInstance();
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                campaignWbo = campaignMgr.getOnSingleKey(request.getParameter("id"));
                if (campaignWbo != null) {
                    try {
                        Date fromDate = sdf.parse((String) campaignWbo.getAttribute("fromDate"));
                        Date toDate = sdf.parse((String) campaignWbo.getAttribute("toDate"));
                        String newStatusCode = request.getParameter("newStatus");
                        String cause_notes = request.getParameter("notes");
                        if (!newStatusCode.equalsIgnoreCase("16") || (newStatusCode.equalsIgnoreCase("16") && fromDate.compareTo(c.getTime()) <= 0 
                                && toDate.compareTo(c.getTime()) >= 0)) {
                            statusWbo.setAttribute("statusCode", newStatusCode);
                            statusWbo.setAttribute("date", sdf.format(c.getTime()));
                            statusWbo.setAttribute("businessObjectId", request.getParameter("id"));
                            statusWbo.setAttribute("statusNote", cause_notes);
                            statusWbo.setAttribute("objectType", "campaign");
                            statusWbo.setAttribute("parentId", "UL");
                            statusWbo.setAttribute("issueTitle", "UL");
                            statusWbo.setAttribute("cuseDescription", "UL");
                            statusWbo.setAttribute("actionTaken", "UL");
                            statusWbo.setAttribute("preventionTaken", "UL");
                            IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                            try {
                                if (issueStatusMgr.changeStatus(statusWbo, persistentUser, null)
                                        && campaignMgr.updateCampaignStatus(request.getParameter("id"), newStatusCode)) {
                                    statusWbo.setAttribute("status", "Ok");
                                    statusWbo.setAttribute("currentStatusName",
                                            campaignMgr.getCampaignStatusName((String) statusWbo.getAttribute("statusCode"), "en"));
                                }
                            } catch (SQLException ex) {
                                Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (NoSuchColumnException ex) {
                                Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        } else {
                            statusWbo.setAttribute("status", "date out of range");
                        }
                    } catch (ParseException ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out.write(Tools.getJSONObjectAsString(statusWbo));
                break;
                
            case 9:
                servedPage = "/docs/campaign/show_campaign_list.jsp";
                ArrayList<WebBusinessObject> campaignsList = new ArrayList<WebBusinessObject>();
                try {
                    String clientId = request.getParameter("clientId");
                    request.setAttribute("clientId", clientId);
                    if (clientId != null && !clientId.isEmpty()) {
                        campaignMgr = CampaignMgr.getInstance();
                        campaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getCashedTable());
                        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                        ArrayList<String> clientCampaignIDsList = clientCampaignMgr.getCampaignIDsByClientList(clientId);
                        ArrayList<WebBusinessObject> clientCampaignsList = clientCampaignMgr.getCampaignsByClientList(clientId);
                        HashMap<String, ArrayList> campaignToolsList = new HashMap<String, ArrayList>();
                        recordSeasonMgr = RecordSeasonMgr.getInstance();
                        for (int i = campaignsList.size() - 1; i >= 0; i--) {
                            WebBusinessObject campaignTemp = campaignsList.get(i);
                            String currentStatus = (String) campaignTemp.getAttribute("currentStatus");
                            if (!currentStatus.equalsIgnoreCase("20") && !currentStatus.equalsIgnoreCase("16")) {
                                campaignsList.remove(campaignTemp);
                            } else if (!currentStatus.equalsIgnoreCase("20")) {
                                campaignToolsList.put((String) campaignTemp.getAttribute("id"), recordSeasonMgr.getToolsForCampaign((String) campaignTemp.getAttribute("id")));
                            }
                        }
                        
                        request.setAttribute("clientCampaignIDsList", clientCampaignIDsList);
                        request.setAttribute("clientCampaignsList", clientCampaignsList);
                        request.setAttribute("campaignToolsList", campaignToolsList);
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("campaignsList", campaignsList);
                this.forward(servedPage, request, response);
                break;
                
            case 10:
                servedPage = "/docs/campaign/view_campaign.jsp";
                campaignMgr = CampaignMgr.getInstance();
                campaignProjectMgr = CampaignProjectMgr.getInstance();
                campaignWbo = campaignMgr.getOnSingleKey(request.getParameter("id"));
         
                
                ArrayList<String> selectedProjectIDs = new ArrayList<String>();
                ArrayList<WebBusinessObject> campaignProjectsList = campaignProjectMgr.getProjectByCampaignList(request.getParameter("id"));
                for (WebBusinessObject wboProject : campaignProjectsList) {
                    selectedProjectIDs.add((String) wboProject.getAttribute("projectID"));
                }
                request.setAttribute("campaignProjectsList", campaignProjectsList);
                request.setAttribute("selectedProjectIDs", selectedProjectIDs);
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> subCampaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle(request.getParameter("id"), "key3"));
                    for (WebBusinessObject subCampaign : subCampaignsList) {
                        toolWbo = recordSeasonMgr.getOnSingleKey((String) subCampaign.getAttribute("toolID"));
                        subCampaign.setAttribute("toolName", toolWbo != null && toolWbo.getAttribute("arabicName") != null ? toolWbo.getAttribute("arabicName") : "");
                        if ("UL".equals(subCampaign.getAttribute("currentStatus"))) {
                            subCampaign.setAttribute("currentStatus", "15"); // for sub campaigns set its status to planned
                        }
                        subCampaign.setAttribute("currentStatusName", campaignMgr.getCampaignStatusName((String) subCampaign.getAttribute("currentStatus"), "en"));
                    }
                    request.setAttribute("subCampaignsList", subCampaignsList);
                    request.setAttribute("toolsList", new ArrayList<WebBusinessObject>(recordSeasonMgr.getOnArbitraryKeyOracle("0", "key1")));
                    projectMgr = ProjectMgr.getInstance();
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key4")));
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                Map<String, String> campaingClientsTotal = new HashMap<>();
                ArrayList<WebBusinessObject> campaignClientsCounts = campaignMgr.getClientsCountPerCampaign(request.getParameter("startDate"), request.getParameter("endDate"), "grpCamp", null);
                for(WebBusinessObject campaignCountWbo : campaignClientsCounts) {
                    campaingClientsTotal.put((String) campaignCountWbo.getAttribute("campaignID"), (String) campaignCountWbo.getAttribute("clientCount"));
                }
                
                ArrayList<WebBusinessObject> chldCmpnActvLst = campaignMgr.getSyncCmpnActvtyLst(null, request.getParameter("id"));
                
                request.setAttribute("campaingClientsTotal", campaingClientsTotal);
                request.setAttribute("campaignWbo", campaignWbo);
                request.setAttribute("chldCmpnActvLst", chldCmpnActvLst);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 11:
                out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                campaignMgr = CampaignMgr.getInstance();
                String updateType = request.getParameter("editType");
                String updateValue = "";
                if (updateType.equalsIgnoreCase("projects")) {
                    try {
                        updateValue = request.getParameter("projects");
                        campaignProjectMgr = CampaignProjectMgr.getInstance();
                        campaignProjectMgr.deleteOnArbitraryKey(request.getParameter("campaignID"), "key1");
                        if (campaignProjectMgr.saveProjectsByCampaign(request.getParameter("campaignID"),
                                updateValue.replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\"", "").split(","), session)) {
                            campaignWbo.setAttribute("status", "Ok");
                        } else {
                            campaignWbo.setAttribute("status", "faild");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    if (updateType.equalsIgnoreCase("fromDate")) {
                        updateValue = request.getParameter("fromDate");
                    } else if (updateType.equalsIgnoreCase("toDate")) {
                        updateValue = request.getParameter("toDate");
                    } else if (updateType.equalsIgnoreCase("cost")) {
                        updateValue = request.getParameter("cost");
                    } else if (updateType.equalsIgnoreCase("objective")) {
                        updateValue = request.getParameter("objective");
                    } else if (updateType.equalsIgnoreCase("direction")) {
                        updateValue = request.getParameter("direction");
                    } else if (updateType.equalsIgnoreCase("title")) {
                        updateValue = request.getParameter("title");
                    }
                    
                    if (campaignMgr.updateCampaign(request.getParameter("campaignID"), updateType, updateValue)) {
                        campaignWbo.setAttribute("status", "Ok");
                    } else {
                        campaignWbo.setAttribute("status", "faild");
                    }
                }
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;

            case 12:
                servedPage = "/docs/campaign/campaigns_load.jsp";
                projectMgr = ProjectMgr.getInstance();
                try {
                    request.setAttribute("campaigns", campaignMgr.getUserDepartmentsCampaigns((String) persistentUser.getAttribute("userId")));
                } catch (Exception e) {}
                
                try {
                    if (request.getParameter("campaignID") == null || request.getParameter("campaignID").isEmpty()) {
                        request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                    } else {
                        request.setAttribute("projectsList", CampaignProjectMgr.getInstance().getProjectByCampaignList(request.getParameter("campaignID")));
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                    request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 13:
                servedPage = "/docs/campaign/campaigns_load.jsp";
                if (request.getParameterValues("clientID") != null && "true".equals(request.getParameter("delete"))) {
                    StringBuilder clientIDs = new StringBuilder();
                    for (String tempID : request.getParameterValues("clientID")) {
                        clientIDs.append("'").append(tempID).append("',");
                    }
                    
                    try {
                        clientCampMgr.deleteClientsCampaign(clientIDs.substring(0, clientIDs.length() - 1), request.getParameter("campaignId"));
                    } catch (SQLException ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                
                clientCampMgr.cashData();
                clients = clientCampMgr.getClientsByCampaignList(request.getParameter("campaignId"), request.getParameter("startDate"), request.getParameter("endDate"));
                WebBusinessObject userWbo;
                UserMgr userMgr = UserMgr.getInstance();
                DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
                for (WebBusinessObject clientWbo : clients) {
                    userWbo = userMgr.getOnSingleKey((String) clientWbo.getAttribute("createdBy"));
                    String createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                    clientWbo.setAttribute("createdBy", createdBy);
                    String responsibleId = distributionListMgr.getLastResponsibleEmployee((String) clientWbo.getAttribute("clientID"));
                    if (responsibleId != null) {
                        clientWbo.setAttribute("ownerUser", userMgr.getOnSingleKey(responsibleId).getAttribute("fullName"));
                    }
                }
                
                request.setAttribute("clients", clients);
                request.setAttribute("campaigns", campaignMgr.getUserDepartmentsCampaigns((String) persistentUser.getAttribute("userId")));
                request.setAttribute("id", request.getParameter("campaignId"));
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 14:
                out = response.getWriter();
                userMgr = UserMgr.getInstance();
                JSONArray jsonArr = new JSONArray();
                try {
                    ArrayList<WebBusinessObject> usersList = userMgr.getUsersLike(request.getParameter("name"));
                    for (WebBusinessObject userTempWbo : usersList) {
                        JSONObject json = new JSONObject();
                        json.put("label", userTempWbo.getAttribute("fullName"));
                        json.put("value", userTempWbo.getAttribute("fullName"));
                        json.put("userID", userTempWbo.getAttribute("userId"));
                        jsonArr.add(json);
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.print(jsonArr);
                break;
                
            case 15:
                servedPage = "/docs/campaign/employee_list.jsp";
                List<WebBusinessObject> employeeList = new ArrayList<WebBusinessObject>(0);
                Filter filter = new Filter();

                userMgr = UserMgr.getInstance();
                ArrayList<FilterCondition> conditions = new ArrayList<FilterCondition>();
                String fieldValue = request.getParameter("fieldValue");

                filter = Tools.getPaginationInfo(request, response);
                conditions.addAll(filter.getConditions());
                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("us.FULL_NAME", fieldValue, Operations.LIKE));
                }
                
                try {
                    employeeList = userMgr.paginationEntity(filter);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }

                filter.setConditions(conditions);
                request.setAttribute("data", employeeList);
                request.setAttribute("filter", filter);
                this.forward(servedPage, request, response);
                break;

            case 16:
                servedPage = "/docs/campaign/campaigns_list.jsp";
                campaignProjectMgr = CampaignProjectMgr.getInstance();
                try {
                    campaignProjectMgr.deleteOnArbitraryKey(request.getParameter("id"), "key1");
                    clientCampMgr.deleteOnArbitraryKey(request.getParameter("id"), "key1");
                    campaignMgr.deleteOnArbitraryKey(request.getParameter("id"), "key3");
                    campaignMgr.deleteOnSingleKey(request.getParameter("id"));
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                campaignMgr = CampaignMgr.getInstance();
                try {
                    campaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("0", "key3"));
                    for (WebBusinessObject tempWbo : campaignsList) {
                        tempWbo.setAttribute("currentStatusName",
                                campaignMgr.getCampaignStatusName((String) tempWbo.getAttribute("currentStatus"), "en"));
                    }
                    
                    request.setAttribute("campaignsList", campaignsList);

                    // to add the all campaignTool List HashMap
                    HashMap<String, ArrayList> campaignToolsList = new HashMap<String, ArrayList>();
                    HashMap<String, Integer> campaignClientsList = new HashMap<String, Integer>();
                    ArrayList tools;
                    recordSeasonMgr = RecordSeasonMgr.getInstance();
                    for (int i = campaignsList.size() - 1; i >= 0; i--) {
                        campaign = campaignsList.get(i);
                        campaignId = (String) campaign.getAttribute("id");
                        tools = recordSeasonMgr.getToolsForCampaign(campaignId);
                        clients = clientCampMgr.getClientsByCampaignList(campaignId, null, null);
                        campaignToolsList.put(campaignId, tools);
                        campaignClientsList.put(campaignId, clients.size());
                    }
                    
                    request.setAttribute("campaignToolsList", campaignToolsList);
                    request.setAttribute("campaignClientsList", campaignClientsList);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 17:
                ArrayList<WebBusinessObject> projectsList;
                campaignProjectMgr = CampaignProjectMgr.getInstance();
                projectsList = campaignProjectMgr.getProjectByCampaignList(request.getParameter("campaignID"));
                out = response.getWriter();
                out.write(Tools.getJSONArrayAsString(projectsList));
                break;

            case 18:
                campaignWbo = new WebBusinessObject();
                campaignWbo.setAttribute("mainCampaignTtile", request.getParameter("mainCampaignTtile"));
                campaignWbo.setAttribute("fromDate", request.getParameter("fromDate"));
                campaignWbo.setAttribute("toDate", request.getParameter("toDate"));
                campaignWbo.setAttribute("cost", request.getParameter("cost"));
                campaignWbo.setAttribute("objective", request.getParameter("objective"));
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                ArrayList<WebBusinessObject> tools = new ArrayList<WebBusinessObject>();
                try {
                    tools = new ArrayList<WebBusinessObject>(recordSeasonMgr.getOnArbitraryKeyOracle("0", "key1"));
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                campaignWbo.setAttribute("parentID", request.getParameter("parentID"));
                campaignWbo.setAttribute("campaignType", "subcampaign");
                campaignWbo.setAttribute("currentStatus", "UL");
                campaignWbo.setAttribute("direction", request.getParameter("direction"));
                if (campaignMgr.saveObjects(campaignWbo, tools, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                    campaignWbo.setAttribute("status", "Ok");
                } else {
                    campaignWbo.setAttribute("status", "faild");
                }
                
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                toolWbo = recordSeasonMgr.getOnSingleKey(request.getParameter("toolID"));
                if (toolWbo != null) {
                    campaignWbo.setAttribute("toolName", toolWbo.getAttribute("arabicName"));
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                //this.forward("/CampaignServlet?op=viewCampaign&id=" + request.getParameter("parentID"), request, response);
                break;

            case 19:
                servedPage = "/docs/campaign/campaign_statistic_total.jsp";

                Calendar cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                request.setAttribute("toDate", sdf.format(cal.getTime()));
                cal.add(Calendar.MONTH, -1);
                request.setAttribute("fromDate", sdf.format(cal.getTime()));

                campaignMgr = CampaignMgr.getInstance();
                ArrayList<WebBusinessObject> allcampaignsList = new ArrayList<WebBusinessObject>();
                try {
                    allcampaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("compound", "key6"));
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("allcampaignsList", allcampaignsList);
                
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                Vector seaVector = new Vector();
                seaVector = recordSeasonMgr.getCashedTable();
                request.setAttribute("seaVector", seaVector);
                
                projectMgr = ProjectMgr.getInstance();
                try {
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key4")));
                } catch (Exception ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                String campID = request.getParameter("campLstID");
                String toolID = request.getParameter("toolLstID");
                String prjID = request.getParameter("prjLstID");

                request.setAttribute("campID", campID);
                request.setAttribute("toolID", toolID);
                request.setAttribute("prjID", prjID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 20:
                String jspType = request.getParameter("jspType");
                if(jspType != null && jspType.equals("details")){
                    servedPage = "/docs/campaign/campaign_statistic.jsp";
                } else if(jspType != null && jspType.equals("total")){
                    servedPage = "/docs/campaign/campaign_statistic_total.jsp";
                }

                campID = request.getParameter("campLstID");
                toolID = request.getParameter("toolLstID");
                prjID = request.getParameter("prjLstID");
                
                ArrayList<WebBusinessObject> campaignPrjList = new ArrayList<WebBusinessObject> ();
                ArrayList<WebBusinessObject> campaignToolList = new ArrayList<WebBusinessObject> ();
                String json = new String();
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                if(request.getParameter("PrjToolFlag") != null && request.getParameter("PrjToolFlag").equals("prj")){
                    campaignPrjList = new ArrayList<WebBusinessObject> ();
                    if(campID != null && !campID.equals("")){
                        campaignPrjList = campaignMgr.getCampaignPrj(campID);
                    } else {
                        try {
                            campaignPrjList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key4"));
                        } catch (Exception ex) {
                            Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    
                    json = new String();
                    json = Tools.getJSONArrayAsString(campaignPrjList);
                    out = response.getWriter();
                    out.write(json);
                } else if(request.getParameter("PrjToolFlag") != null && request.getParameter("PrjToolFlag").equals("tool")){
                    campaignToolList = new ArrayList<WebBusinessObject> ();
                    if(campID != null && !campID.equals("")){
                        campaignToolList = campaignMgr.getCampaignTool(campID);
                    } else {
                        campaignToolList = new ArrayList<WebBusinessObject>(recordSeasonMgr.getCashedTable());
                    }
                    
                    json = new String();
                    json = Tools.getJSONArrayAsString(campaignToolList);
                    out = response.getWriter();
                    out.write(json);
                } else {
                    try {
                        ArrayList<WebBusinessObject> campaignList = CampaignMgr.getInstance().getCampaignStat(request.getParameter("beginDate"), request.getParameter("endDate"), campID, toolID, prjID);

                        request.setAttribute("campID", campID);
                        request.setAttribute("toolID", toolID);
                        request.setAttribute("prjID", prjID);
                        request.setAttribute("campaignList", campaignList);
                        request.setAttribute("fromDate", request.getParameter("beginDate"));
                        request.setAttribute("toDate", request.getParameter("endDate"));
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    campaignMgr = CampaignMgr.getInstance();
                    allcampaignsList = new ArrayList<WebBusinessObject>();
                    try {
                        allcampaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("compound", "key6"));
                    } catch (Exception ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("allcampaignsList", allcampaignsList);

                    seaVector = new Vector();
                    seaVector = recordSeasonMgr.getCashedTable();
                    request.setAttribute("seaVector", seaVector);
                    try {
                        request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key4")));
                    } catch (Exception ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("jspType", jspType);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 21:
                out = response.getWriter();
                campaignsList = campaignMgr.getChannelCampaigns(request.getParameter("channelID"));
                out.write(Tools.getJSONArrayAsString(campaignsList));
                break;

            case 22:
                out = response.getWriter();
                WebBusinessObject wbo = new WebBusinessObject();
                WebBusinessObject data = new WebBusinessObject();
                String campaignName = request.getParameter("campaignName");
                wbo = campaignMgr.getOnSingleKey("key5", campaignName);
                if (wbo != null) {
                    data.setAttribute("campaignName", wbo.getAttribute("campaignTitle"));
                    data.setAttribute("id", wbo.getAttribute("id"));
                    data.setAttribute("status", "Ok");
                } else {
                    data.setAttribute("status", "No");
                }

                out.write(Tools.getJSONObjectAsString(data));
                break;
            case 23:
                servedPage = "/docs/campaign/customer_referral_report.jsp";
                if (request.getParameter("startDate") != null) {
                    clients = clientCampMgr.getClientsByCampaignList(CRMConstants.CUSTOMER_REFERRAL_CAMPAIGN_ID,
                            request.getParameter("startDate"), request.getParameter("endDate"));
                } else {
                    clients = new ArrayList<>();
                }
                userMgr = UserMgr.getInstance();
                distributionListMgr = DistributionListMgr.getInstance();
                for (WebBusinessObject clientWbo : clients) {
                    userWbo = userMgr.getOnSingleKey((String) clientWbo.getAttribute("createdBy"));
                    String createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                    clientWbo.setAttribute("createdBy", createdBy);
                    String responsibleId = distributionListMgr.getLastResponsibleEmployee((String) clientWbo.getAttribute("clientID"));
                    if (responsibleId != null) {
                        clientWbo.setAttribute("ownerUser", userMgr.getOnSingleKey(responsibleId).getAttribute("fullName"));
                    }
                }
                
                request.setAttribute("clients", clients);
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 24:
                servedPage = "/docs/reports/channel_expenses_report.jsp";
                java.sql.Date fromDate = null;
                java.sql.Date toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    request.setAttribute("expensesList", SeasonMgr.getInstance().getChannlesExpenses(fromDate, toDate));
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                } else {
                    c = Calendar.getInstance();
                    sdf.applyPattern("yyyy-MM-dd");
                    request.setAttribute("toDate", sdf.format(c.getTime()));
                    c.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(c.getTime()));
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            
            case 25:
                out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                campID = request.getParameter("campID");
                ArrayList<WebBusinessObject> subCamps = new ArrayList<WebBusinessObject>();
                {
                    try {
                        subCamps = campaignMgr.getOnArbitraryKey2(campID, "key3");
                    } catch (Exception ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                if(subCamps != null && subCamps.size() != 0 && !subCamps.isEmpty()){
                    campaignWbo.setAttribute("status", "cannot");
                } else {
                    boolean is_deleted = campaignMgr.deleteCampaign(campID);
                    if(is_deleted == true){
                        campaignWbo.setAttribute("status", "Ok");
                    } else {
                        campaignWbo.setAttribute("status", "faild");
                    }
                }
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;
            case 26:
                   servedPage = "/docs/campaign/campaign_expense_list.jsp";
                campaignMgr = CampaignMgr.getInstance();
                 c = Calendar.getInstance();
                 sdf = new SimpleDateFormat("yyyy-MM-dd");
                 toDateStr = request.getAttribute("toDate") != null ? request.getParameter("toDate") : sdf.format(c.getTime());
                c.add(Calendar.MONTH, -1);
                 ArrayList<Integer> sumEXA=new ArrayList<>();
                ChannelsExpenseMgr channelsExpenseMgr =ChannelsExpenseMgr .getInstance();
                 ArrayList<LiteWebBusinessObject> data5=new ArrayList<LiteWebBusinessObject>();
                     Integer SumEx=0;
                     fromDateStr = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(c.getTime());
                      try {
                        campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(fromDateStr, toDateStr, request.getParameter("statusID"),
                        (String) persistentUser.getAttribute("userId"), request.getParameter("departmentID"), false));
                        int s=0;
                        for (WebBusinessObject tempWbo : campaignsList) 
                        {
                            SumEx=0;
                            data5 =channelsExpenseMgr.getChannelExpenses((String)tempWbo.getAttribute("id"));

                          if(data5!=null){
                           for(LiteWebBusinessObject wbo5: data5)
                           {
                               if (wbo5.getAttribute("option2") !=null)
                               SumEx += Integer.valueOf((String) wbo5.getAttribute("option2") );
                               else SumEx+=0;
                           }
                          }
                           sumEXA.add(SumEx);
                           if ("UL".equals(tempWbo.getAttribute("currentStatus"))) {
                               tempWbo.setAttribute("currentStatus", "15"); // for sub campaigns set its status to planned
                           }
                           tempWbo.setAttribute("currentStatusName", campaignMgr.getCampaignStatusName((String) tempWbo.getAttribute("currentStatus"), "en"));
                      }
                    
                    request.setAttribute("campaignsList", campaignsList);

                    // to add the all campaignTool List HashMap
                    HashMap<String, ArrayList> campaignToolsList = new HashMap<String, ArrayList>();
                    HashMap<String, Integer> campaignClientsList = new HashMap<String, Integer>();
                     
                    recordSeasonMgr = RecordSeasonMgr.getInstance();
                    for (int i = campaignsList.size() - 1; i >= 0; i--) {
                        campaign = campaignsList.get(i);
                        campaignId = (String) campaign.getAttribute("id");
                        tools = recordSeasonMgr.getToolsForCampaign(campaignId);
                        clients = clientCampMgr.getClientsByCampaignList(campaignId, null, null);
                        campaignToolsList.put(campaignId, tools);
                        campaignClientsList.put(campaignId, clients.size());
                    }
                    
                    request.setAttribute("campaignToolsList", campaignToolsList);
                    request.setAttribute("campaignClientsList", campaignClientsList);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                departments = new ArrayList<>();
                 userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) persistentUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }
                } catch (Exception ex) {
                }
                
                request.setAttribute("statusesList", campaignMgr.getCampaignStatuses());
                request.setAttribute("statusID", request.getParameter("statusID"));
                request.setAttribute("departmentID", request.getParameter("departmentID"));
                request.setAttribute("departments", departments);
                request.setAttribute("toDate", toDateStr);
                request.setAttribute("fromDate", fromDateStr);
                request.setAttribute("sumEXA", sumEXA);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 27:
                out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                campaignMgr = CampaignMgr.getInstance();
               
                
                    try {
                        String campaignId=request.getParameter("campaignID");
                        String[] key={"key2"};
                        String[] updatedtoolID={request.getParameter("toolID")};
                        
                        if (campaignMgr.updateOnSingleKey(campaignId,key,updatedtoolID)) {
                        campaignWbo.setAttribute("status", "Ok");
                    } else {
                        campaignWbo.setAttribute("status", "faild");
                    }
                        
                    } catch (Exception ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
      
                    
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;
                
            case 28:
                out = response.getWriter();
                campaignWbo = new WebBusinessObject();
                campaignMgr = CampaignMgr.getInstance();
               
                
                    try {
                        String campaignId=request.getParameter("campaignID");
                        String[] key={"key4"};
                        
                        String[] activeStatus={request.getParameter("active")};
                        
                        if (campaignMgr.updateOnSingleKey(campaignId,key,activeStatus)) {
                        campaignWbo.setAttribute("status", "Ok");
                    } else {
                        campaignWbo.setAttribute("status", "faild");
                    }
                        
                    } catch (Exception ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
      
                    
                out.write(Tools.getJSONObjectAsString(campaignWbo));
                break;
              case 29:
                servedPage = "/docs/client/subCampRates.jsp";

                ArrayList graphResultList = new ArrayList();
                ArrayList<String> RatesList = new ArrayList();

                projectMgr = ProjectMgr.getInstance();

                try {

                    ArrayList<WebBusinessObject> RatesWBOList = ProjectMgr.getInstance().getOnArbitraryKey2("CL-RATE", "key4");
                    if (RatesWBOList != null && RatesWBOList.size() > 0) {
                        for (WebBusinessObject rateWbo : RatesWBOList) {
                            RatesList.add(rateWbo.getAttribute("projectName").toString());
                        }
                    }

                    ArrayList<WebBusinessObject> campsRatesResult = ClientRatingMgr.getInstance().geCampsRates(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("campaignID"), RatesList);

                    if (campsRatesResult != null && campsRatesResult.size() > 0) {
                        for (WebBusinessObject resultwbo : campsRatesResult) {
                            Map<String, Object> graphDataMap = new HashMap<String, Object>();

                            ArrayList campDataList = new ArrayList();
                            for (String campName : RatesList) {
                                campDataList.add(resultwbo.getAttribute(campName.toString().replaceAll("\\s", "")));
                            }

                            graphDataMap.put("name", resultwbo.getAttribute("CAMPAIGN_TITLE"));
                            graphDataMap.put("data", campDataList);

                            graphResultList.add(graphDataMap);
                        }

                        String ratingCategories = JSONValue.toJSONString(RatesList);
                        String resultsJson = JSONValue.toJSONString(graphResultList);

                        request.setAttribute("ratingCategories", ratingCategories);
                        request.setAttribute("resultsJson", resultsJson);
                        request.setAttribute("graphResult", campsRatesResult);
                        request.setAttribute("RatesList", RatesList);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
               
            default:
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
    public int getOpCode(String operation) {
        if (operation.equalsIgnoreCase("getCampaignForm")) {
            return 1;
        } else if (operation.equalsIgnoreCase("saveCampaign")) {
            return 2;
        } else if (operation.equalsIgnoreCase("changeDefaultCampaign")) {
            return 3;
        } else if (operation.equalsIgnoreCase("defaultCampaignSelected")) {
            return 4;
        } else if (operation.equalsIgnoreCase("saveSubCampaignByAjax")) {
            return 5;
        } else if (operation.equalsIgnoreCase("deleteSubCampaignByAjax")) {
            return 6;
        } else if (operation.equalsIgnoreCase("listCampaigns")) {
            return 7;
        } else if (operation.equalsIgnoreCase("changeCampaignStatusByAjax")) {
            return 8;
        } else if (operation.equalsIgnoreCase("showCampaigns")) {
            return 9;
        } else if (operation.equalsIgnoreCase("viewCampaign")) {
            return 10;
        } else if (operation.equalsIgnoreCase("editCampaignByAjax")) {
            return 11;
        } else if (operation.equalsIgnoreCase("getCampaignLoad")) {
            return 12;
        } else if (operation.equalsIgnoreCase("listCampaignClients")) {
            return 13;
        } else if (operation.equalsIgnoreCase("searchEmployeeAjax")) {
            return 14;
        } else if (operation.equalsIgnoreCase("getSearchForEmployee")) {
            return 15;
        } else if (operation.equalsIgnoreCase("deleteCampaign")) {
            return 16;
        } else if (operation.equalsIgnoreCase("getProjectsAjax")) {
            return 17;
        } else if (operation.equalsIgnoreCase("saveSubCampaignsByAjax")) {
            return 18;
        } else if (operation.equalsIgnoreCase("getCampaignStat")) {
            return 19;
        } else if (operation.equalsIgnoreCase("viewCampaignStat")) {
            return 20;
        } else if (operation.equalsIgnoreCase("getCampaignSuggest")) {
            return 21;
        } else if (operation.equalsIgnoreCase("getCampaignName")) {
            return 22;
        } else if (operation.equalsIgnoreCase("getCustomerReferral")) {
            return 23;
        } else if (operation.equalsIgnoreCase("getChannelsExpenses")) {
            return 24;
        } else if (operation.equalsIgnoreCase("deleteMainCampaign")) {
            return 25;
        } else if (operation.equalsIgnoreCase("expenselistCampaigns")) {
            return 26;
        } else if (operation.equalsIgnoreCase("editCampaignTool")) {
            return 27;
        } else if (operation.equalsIgnoreCase("changeSubCampaignStatus")) {
            return 28;
        } else if(operation.equalsIgnoreCase("getSubCampaignClientsRating")){
            return 29;
        }
        return 0;
    }

    @Override
    public String getServletInfo() {
        return "Campaign Servlet";
    }
}