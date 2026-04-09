package com.clients.servlets;

import com.businessfw.oms.db_access.ClientSurveyMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.clients.db_access.CallingPlanDetailsMgr;
import com.clients.db_access.CallingPlanMgr;
import com.clients.db_access.ClientContractsMgr;
import com.clients.db_access.ClientCommunicationMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.CustomerGradesMgr;
import com.maintenance.common.DateParser;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ClientRatingMgr;
import com.clients.db_access.ClientRuleMgr;
import com.clients.db_access.ClientSeasonsMgr;
import com.clients.db_access.RateActionMgr;
import com.clients.db_access.ReservationMgr;
import com.clients.db_access.TradeTypeMgr;
import com.crm.common.ActionEvent;
import com.crm.common.AutoPilotFeature;
import com.crm.common.CRMConstants;
import com.crm.db_access.ChannelsMgr;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.RegionMgr;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.crm.db_access.CommentsMgr;
import com.crm.servlets.CalendarServlet;
import com.crm.servlets.CommentsServlet;
import com.email_processing.EmailMgr;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.common.UserGroupConfigMgr;
import com.maintenance.db_access.DistributionListMgr;
import com.maintenance.db_access.EmployeeView2Mgr;
import com.maintenance.db_access.EquipmentStatusMgr;
import com.maintenance.db_access.IssueByComplaintUniqueMgr;
import com.planning.db_access.RecordSeasonMgr;
import com.planning.db_access.SeasonMgr;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.GroupMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserClientsMgr;
import com.silkworm.common.UserGroupMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UniqueIDGen;
import static com.silkworm.servlets.swBaseServlet.getClientIpAddr;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ClientCampaignMgr;
import com.tracker.db_access.ClientIncentiveMgr;
import com.tracker.db_access.ClientStatusMgr;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.ProjectServlet;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONValue;

import com.maintenance.db_access.UserCompaniesMgr;
import com.silkworm.business_objects.WebAppUser;
import com.silkworm.email.EmailUtility;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import com.tracker.db_access.CampaignProjectMgr;
import com.tracker.db_access.LocationTypeMgr;
import com.tracker.servlets.SearchServlet;
import java.text.DecimalFormat;
import java.util.Collection;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ClientServlet extends TrackerBaseServlet {

    private ClientMgr clientMgr;
    private String title;
    private LoggerMgr loggerMgr = LoggerMgr.getInstance();
    private AppointmentMgr appointmentMgr;
    private ClientComplaintsMgr clientComplaintsMgr;
    WebBusinessObject loggerWbo;

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        response.setContentType("text/html;charset=UTF-8");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        EmployeeView2Mgr employeeView2Mgr = EmployeeView2Mgr.getInstance();
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        UserClientsMgr userClientsMgr = UserClientsMgr.getInstance();
        clientMgr = ClientMgr.getInstance();
        userMgr = UserMgr.getInstance();
        appointmentMgr = AppointmentMgr.getInstance();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        TradeMgr tradeMgr = TradeMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ClientContractsMgr clientContractsMgr = ClientContractsMgr.getInstance();
        IssueByComplaintUniqueMgr issueComplaints = IssueByComplaintUniqueMgr.getInstance();
        SeasonMgr seasonMgr = SeasonMgr.getInstance();

        Vector seasons = new Vector();
        Vector appointments = new Vector();
        Vector comments = new Vector();
        Vector complaints = new Vector();
        List<WebBusinessObject> clients;

        String clientName = "";

        switch (operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_client.jsp";
                
                Vector<WebBusinessObject> mainRegion = new Vector<WebBusinessObject>();
                try {
                    mainRegion = projectMgr.getOnArbitraryKey("garea", "key6");

                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("mainRegion", mainRegion);
                RegionMgr regionMgr = RegionMgr.getInstance();
                Vector regions = new Vector();
                regions = regionMgr.getCashedTable();
                Vector jobs = new Vector();
                Vector products;
                Vector mainProducts = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
                UserCompaniesMgr userCompanyMgr = UserCompaniesMgr.getInstance();
                WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", waUser.getAttribute("userId").toString());
                
              try {
                    mainProducts = projectMgr.getOnArbitraryDoubleKeyOracle("44", "key6", "66", "key9"); // 66 for active projects only
                    for (int i = 0; i < mainProducts.size(); i++) {
                        WebBusinessObject projectWbo = (WebBusinessObject) mainProducts.get(i);
                        ArrayList<WebBusinessObject> areas = projectMgr.getAreasForProject(projectWbo.getAttribute("projectID").toString());
                        String arreaArrayName = projectWbo.getAttribute("projectID").toString();
                        request.setAttribute(arreaArrayName, areas);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
               // }
                campaignMgr = CampaignMgr.getInstance();
                ArrayList<WebBusinessObject> campaignsList;
               
                try {
    List<WebBusinessObject> getCampaigns = clientMgr.getCampaigns();
    request.setAttribute("campaignsList", getCampaigns);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
    List<WebBusinessObject> brokerList = clientMgr.getBroker();
    request.setAttribute("brokerList", brokerList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
    List<WebBusinessObject> sourceList = clientMgr.getSource();
    request.setAttribute("sourceList", sourceList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                Vector tradeTypeV = new Vector();
                TradeTypeMgr tradeTypeMgr = TradeTypeMgr.getInstance();
                tradeTypeV = tradeTypeMgr.getCashedTable();
                List<WebBusinessObject> employees = new ArrayList<WebBusinessObject>();
                try {
                    if (securityUser.isCanRunCampaignMode()) {
                        employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
                    } else {
                        employees = userMgr.getUsersByProjectAndGroup(securityUser.getSiteId(), CRMConstants.SALES_MARKTING_GROUP_ID);
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                try {
                    request.setAttribute("seasonsList", new ArrayList<>(seasonMgr.getOnArbitraryKeyOracle("1", "key2")));
                } catch (Exception ex) {
                    request.setAttribute("seasonsList", new ArrayList<>());
                }
                request.setAttribute("employees", employees);
                request.setAttribute("departmentMgrId", loggegUserId);
                request.setAttribute("departmentMgrName", userMgr.getByKeyColumnValue(loggegUserId, "key3"));
                request.setAttribute("mainProducts", mainProducts);
                request.setAttribute("tradeTypeV", tradeTypeV);
                request.setAttribute("page", servedPage);
                request.setAttribute("jobs", jobs);
                request.setAttribute("regions", regions);
                request.setAttribute("Status", request.getAttribute("Status"));
                this.forwardToServedPage(request, response);
                break;
            case 2:
                boolean gotoNewClientPage = false;
                servedPage = "/docs/customer/distribute_client.jsp";
                String searchByValue = request.getParameter("searchByValue");
                if (searchByValue != null) {
                    request.setAttribute("data", issueMgr.getClearErrorTasksByBusiness(searchByValue));
                }
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                try {
                    request.setAttribute("employees", userMgr.getUsersByGroupAndBranch(securityUser.getDistributionGroup(), securityUser.getBranchesAsArray()));
                } catch (SQLException ex) {
                    request.setAttribute("employees", new ArrayList<>());
                }
                try {
                    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }
                tradeMgr = TradeMgr.getInstance();
                String clientId = null;
                clientName = request.getParameter("clientName");
                String[] campaignIds = request.getParameterValues("campaignsselect");
                tradeMgr = TradeMgr.getInstance();
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                WebBusinessObject clientWbo = new WebBusinessObject();
                String job = request.getParameter("job");
                WebBusinessObject wbo = tradeMgr.getOnSingleKey(job);
                String jobTitle;
                if (wbo != null) {
                    jobTitle = (String) wbo.getAttribute("tradeName");
                } else {
                    jobTitle = "";
                }
                request.setAttribute("jobTitle", jobTitle);
                String region = request.getParameter("addreg");String phoneCount = request.getParameter("phoneCount");
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("regionTitle", region);
                request.setAttribute("phoneCount", phoneCount);
                String mobile = request.getParameter("clientMobile");
                String email = request.getParameter("email");
                //String sourcClient = request.getParameter("sourceClient");
                try {
                    try {
                        if (clientMgr.saveClientData(request, session, persistentUser)) {
                            clientId = (String) request.getAttribute("clientId");
                            securityUser = (SecurityUser) session.getAttribute("securityUser");
                            loggerWbo = new WebBusinessObject();
                            loggerWbo.setAttribute("objectXml", clientWbo.getObjectAsXML());
                            loggerWbo.setAttribute("realObjectId", clientId);
                            loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                            loggerWbo.setAttribute("objectName", clientName);
                            loggerWbo.setAttribute("loggerMessage", "Client Inserted");
                            loggerWbo.setAttribute("eventName", "Insert");
                            loggerWbo.setAttribute("objectTypeId", "1");
                            loggerWbo.setAttribute("eventTypeId", "4");
                            loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                            loggerMgr.saveObject(loggerWbo);
                            if (clientId != null && campaignIds != null) {
                                ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                                String[] emptyArray = {};
                                clientCampaignMgr.saveCampaignsByClient(clientId, campaignIds, emptyArray, emptyArray, emptyArray, session, true);
                                clientCampaignMgr.saveSourceByClient(clientId, request.getParameter("sourceClient"));
                            }
                            AutoPilotFeature feature = new AutoPilotFeature();
                            if (securityUser.isCanRunAutoPilotMode()) {
                                feature.autoPilot(clientId, request, persistentUser);
                                gotoNewClientPage = true;
                            } else if ("1".equals(securityUser.getPersonalDistribution())) {
                                servedPage = "/docs/customer/distribute_client.jsp";
                                WebBusinessObject requestTypeWbo = projectMgr.getOnSingleKey(securityUser.getPersonalDistributionType());
                                String requestType = requestTypeWbo != null ? (String) requestTypeWbo.getAttribute("projectName") : "عميل جديد";
                                issueMgr = IssueMgr.getInstance();
                                String issueId = null;
                                boolean savedComplete = false;
                                try {
                                    if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                                        String callStatus = "";
                                        String callType = "";
                                        switch (securityUser.getCallcenterMode()) {
                                            case "2":
                                                callStatus = "incoming";
                                                callType = "call";
                                                break;
                                            case "3":
                                                callStatus = "out_call";
                                                callType = "call";
                                                break;
                                            case "4":
                                                callStatus = "incoming";
                                                callType = "meeting";
                                                break;
                                            case "5":
                                                callStatus = "out_call";
                                                callType = "meeting";
                                                break;
                                            case "6":
                                                callStatus = "incoming";
                                                callType = "internet";
                                                break;
                                            default:
                                                break;
                                        }
                                        issueId = issueMgr.saveCallDataAuto(clientId, callType, callStatus, session, "issue", persistentUser);
                                        if (issueId != null && !issueId.equals("")) {
                                            WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                                            request.setAttribute("issueId", issueId);
                                            request.setAttribute("businessId", issueWbo.getAttribute("businessID"));
                                        }
                                    }
                                } catch (NoUserInSessionException | SQLException ex) {
                                    logger.error(ex);
                                }
                                if (!securityUser.getDefaultNewClientDistribution().equals("-1") && issueId != null) {
                                    try {
                                        savedComplete = clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"),
                                                issueId, "2", null, requestType, requestType, requestType, persistentUser) != null;
                                    } catch (NoUserInSessionException | SQLException ex) {
                                        logger.error(ex);
                                    }
                                }
                                clientComplaintsMgr.updateClientComplaintsType();
                                request.setAttribute("employeeId", (String) persistentUser.getAttribute("userId"));
                                request.setAttribute("employeeName", userMgr.getByKeyColumnValue((String) persistentUser.getAttribute("userId"), "key3"));
                                request.setAttribute("clientId", clientId);
                                request.setAttribute("clientName", clientName);
                                request.setAttribute("status", (savedComplete) ? "ok" : "no");
                                request.setAttribute("redirect", "true");
                                request.setAttribute("page", servedPage);
                                this.forwardToServedPage(request, response);
                                break;
                            } else {
                                try {
                                    feature.saveProduct(clientId, request);
                                } catch (Exception ex) {
                                    logger.error(ex);
                                }
                            }
                            if (gotoNewClientPage) {
                                request.setAttribute("autoPilotMessage", "ok");
                                this.forward("/ClientServlet?op=GetClientForm", request, response);
                            } else {
                                employees = new ArrayList<WebBusinessObject>();
                                try {
                                    if (securityUser.getDefaultNewClientDistribution() != null && !securityUser.getDefaultNewClientDistribution().isEmpty()) {
                                        employees = userMgr.getUsersByGroup(securityUser.getDefaultNewClientDistribution());
                                    } else if (securityUser.getDistributionGroup() != null && !securityUser.getDistributionGroup().isEmpty()) {
                                        employees = userMgr.getUsersByGroup(securityUser.getDistributionGroup());
                                    }
                                } catch (SQLException ex) {
                                    logger.error(ex);
                                }
                                clientId = (String) request.getAttribute("clientId");
                                request.setAttribute("employees", employees);
                                request.setAttribute("clientId", clientId);
                                request.setAttribute("clientName", clientName);
                                request.setAttribute("page", servedPage);
                                this.forwardToServedPage(request, response);
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            this.forward("/ClientServlet?op=GetClientForm", request, response);

                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }
                } catch (NoUserInSessionException noUser) {
                }
                break;
            case 3:
                projectMgr = ProjectMgr.getInstance();
                tradeMgr = TradeMgr.getInstance();
                String clientStatus = request.getParameter("clientStatus");
                String clientProject = request.getParameter("clientProject");
                String clientArea = request.getParameter("clientArea");
                String clientJob = request.getParameter("clientJob");
                if (clientStatus == null) {
                    clientStatus = "12";
                }
                EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                WebBusinessObject departmentWbo;
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                if (departmentWbo != null) {
                    clients = clientMgr.getAllClientsWithMark(clientStatus, clientProject, clientArea, clientJob, (String) departmentWbo.getAttribute("projectID"), session, null, null, false, null, "", null);
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }
                servedPage = "/docs/Adminstration/client_list.jsp";
                request.setAttribute("page", servedPage);
                String data2 = Tools.getJSONArrayAsString2(clients);
                request.setAttribute("data", clients);
                request.setAttribute("data2", data2);
                try {
                    request.setAttribute("clientStatusList", clientMgr.getClientStatusList());
                    ArrayList<WebBusinessObject> areaList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("rgns", "key6"));
                    for (int i = areaList.size() - 1; i >= 0; i--) {
                        if (((String) areaList.get(i).getAttribute("mainProjId")).equalsIgnoreCase("0")) {
                            areaList.remove(areaList.get(i));
                        }
                    }
                    request.setAttribute("areaList", areaList);
                    ArrayList<WebBusinessObject> mainProject;
                    ArrayList<WebBusinessObject> projectList = new ArrayList<WebBusinessObject>();
                    try {
                        mainProject = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("PRODUCTS", "key3"));
                        projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) mainProject.get(0).getAttribute("projectID"), "key2"));
                    } catch (SQLException ex) {
                        logger.error(ex);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("projectList", projectList);
                    request.setAttribute("jobList", new ArrayList<WebBusinessObject>(tradeMgr.getOnArbitraryKeyOracle("1", "key3")));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                String lastFilter = "ClientServlet?op=ListClients";
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
                request.setAttribute("selectedStatus", clientStatus);
                request.setAttribute("selectedProject", clientProject);
                request.setAttribute("selectedArea", clientArea);
                request.setAttribute("selectedJob", clientJob);
                this.forwardToServedPage(request, response);
                break;
            case 4:
                servedPage = "/docs/call_center/clientProduct.jsp";
                projectMgr = ProjectMgr.getInstance();
                IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                clientId = (String) request.getParameter("clientID");
                clientProductMgr = ClientProductMgr.getInstance();
                request.setAttribute("clientId", clientId);
                clientMgr = ClientMgr.getInstance();
                wbo = new WebBusinessObject();
                WebBusinessObject wbo2 = new WebBusinessObject();
                wbo = clientMgr.getOnSingleKey(clientId);
                Vector reservedUnit = new Vector();
                Vector interestedUnit = new Vector();
                reservedUnit = clientProductMgr.getReservedUnit(clientId);
                interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                metaMgr.setMetaData("xfile.jar");
                Vector clientMenu = new Vector();
                String mode = (String) request.getSession().getAttribute("currentMode");
                clientMenu = parseSideMenu.parseSideMenu(mode, "new_client_menu.xml", "");
                metaMgr.closeDataSource();
                Vector linkVec = new Vector();
                String link = "";
                Hashtable style = new Hashtable();
                style = (Hashtable) clientMenu.get(0);
                title = style.get("title").toString();
                title += "<br>" + wbo.getAttribute("name").toString();
                style.remove("title");
                style.put("title", title);
                for (int i = 1; i < clientMenu.size() - 1; i++) {
                    linkVec = new Vector();
                    link = "";
                    linkVec = (Vector) clientMenu.get(i);
                    link = (String) linkVec.get(1);
                    link += wbo.getAttribute("id").toString();
                    linkVec.remove(1);
                    linkVec.add(link);
                }
                request.getSession().setAttribute("sideMenuVec", clientMenu);
                products = new Vector();
                mainProducts = new Vector();
                try {
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                    wbo2 = (WebBusinessObject) products.get(0);
                    mainProducts = projectMgr.getOnArbitraryKey((String) wbo2.getAttribute("projectID"), "key2");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("data", mainProducts);
                request.setAttribute("products", interestedUnit);
                request.setAttribute("reservedUnit", reservedUnit);
                request.setAttribute("page", servedPage);
                request.setAttribute("client", wbo);
                this.forwardToServedPage(request, response);
                break;
            case 5:
                servedPage = "/docs/Adminstration/update_client.jsp";
                clientId = request.getParameter("clientID");
                clientMgr = ClientMgr.getInstance();
                clientWbo = clientMgr.getOnSingleKey(clientId);
                request.setAttribute("clientWbo", clientWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 6:
                servedPage = "/docs/Adminstration/update_client.jsp";
                clientId = request.getParameter("clientID");
                clientMgr = ClientMgr.getInstance();
                try {
                    if (clientMgr.updateClient(request)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                }
                clientWbo = new WebBusinessObject();
                clientWbo = clientMgr.getOnSingleKey(clientId);
                request.setAttribute("clientWbo", clientWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                clientMgr = ClientMgr.getInstance();
                clientId = request.getParameter("clientID");
                String fromPage = request.getParameter("fromPage");
                clientWbo = new WebBusinessObject();
                clientWbo = (WebBusinessObject) clientMgr.getOnSingleKey(clientId);
                clientName = request.getParameter("clientName");
                String clientNo = request.getParameter("clientNo");
                servedPage = "/docs/Adminstration/confirm_delete_client.jsp";
                request.setAttribute("clientWbo", clientWbo);
                request.setAttribute("clientId", clientId);
                request.setAttribute("fromPage", fromPage);
                request.setAttribute("clientName", clientName);
                request.setAttribute("clientNo", clientNo);
                request.setAttribute("canDelete", /*clientMgr.canDelete(clientId)*/ true);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 8:
                clientId = request.getParameter("clientId");
                fromPage = request.getParameter("fromPage");
                clientWbo = new WebBusinessObject();
                clientWbo = (WebBusinessObject) clientMgr.getOnSingleKey(clientId);
                clientName = request.getParameter("clientName");
                clientNo = request.getParameter("clientNo");
                servedPage = "/docs/Adminstration/confirm_delete_client.jsp";
                request.setAttribute("clientWbo", clientWbo);
                request.setAttribute("clientId", clientId);
                request.setAttribute("fromPage", fromPage);
                request.setAttribute("clientName", clientName);
                request.setAttribute("clientNo", clientNo);
                request.setAttribute("canDelete", true);
                request.setAttribute("page", servedPage);
                WebBusinessObject loggerWbo = new WebBusinessObject();
                fillLoggerWbo(request, loggerWbo);
                String clientCode = (String) request.getParameter("code");
                String connectByRealEstate = metaMgr.getConnectByRealEstate();
                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                try {
                    clientProductMgr = ClientProductMgr.getInstance();
                    if (clientProductMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("clientId"), "key1", "purche", "key4").isEmpty()
                            && clientProductMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("clientId"), "key1", "reserved", "key4").isEmpty()) {
                        if (clientCode != null && !clientCode.equals("")) {
                            if (connectByRealEstate != null && !connectByRealEstate.equals("")
                                    && connectByRealEstate.equals("1")) {
                                if (clientMgr.deleteClientInRealEstate(request)) {
                                    clientMgr.deleteAllClientData(request.getParameter("clientId"));
                                    loggerMgr.saveObject(loggerWbo);
                                    request.setAttribute("status", "ok");
                                    servedPage = "/docs/Adminstration/client_list.jsp";
                                    deleteProductsAndIssuesForClient(clientId, persistentUser);
                                    issueStatusMgr.deleteOnArbitraryKey(request.getParameter("clientId"), "key1");
                                } else {
                                    request.setAttribute("status", "error");
                                }
                            } else {
                                if (clientMgr.deleteAllClientData(request.getParameter("clientId"))) {
                                    loggerMgr.saveObject(loggerWbo);
                                    request.setAttribute("status", "ok");
                                    servedPage = "/docs/Adminstration/client_list.jsp";
                                    deleteProductsAndIssuesForClient(clientId, persistentUser);
                                    issueStatusMgr.deleteOnArbitraryKey(request.getParameter("clientId"), "key1");
                                } else {
                                    request.setAttribute("status", "error");
                                }
                            }
                        } else {
                            if (clientMgr.deleteAllClientData(request.getParameter("clientId"))) {
                                loggerMgr.saveObject(loggerWbo);
                                request.setAttribute("status", "ok");
                                deleteProductsAndIssuesForClient(clientId, persistentUser);
                                issueStatusMgr.deleteOnArbitraryKey(request.getParameter("clientId"), "key1");
                            } else {
                                request.setAttribute("status", "error");
                            }
                        }
                    } else {
                        request.setAttribute("status", "error");
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                this.forwardToServedPage(request, response);
                break;
            case 9:
                request.getSession().removeAttribute("sideMenuVec");
                request.getSession().removeAttribute("activeClientID");
                servedPage = "/administrator.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 10:
                servedPage = "/docs/Adminstration/new_client2.jsp";
                tradeMgr = TradeMgr.getInstance();
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                         } catch (Exception ex) {
                    logger.error(ex);
                }
                regions = new Vector();
                regionMgr = RegionMgr.getInstance();
                regions = regionMgr.getCashedTable();
                request.setAttribute("page", servedPage);
                request.setAttribute("jobs", jobs);
                request.setAttribute("regions", regions);
                this.forwardToServedPage(request, response);
                break;
            case 11:
                servedPage = "/docs/Adminstration/new_client2.jsp";
                clientId = null;
                clientName = request.getParameter("clientName");
                clientWbo = new WebBusinessObject();
                tradeMgr = TradeMgr.getInstance();
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                region = request.getParameter("region");
                request.setAttribute("regionTitle", region);
                try {
                    String saveInRealState = request.getParameter("saveInRealState");
                    if (saveInRealState.equalsIgnoreCase("false")) {
                        try {
                            if (clientMgr.saveClientData(request, session, persistentUser)) {
                                clientNo = (String) request.getAttribute("code");
                                searchByValue = null;
                                Vector clientVec = null,
                                        clientStatusVec = null;
                                metaMgr = MetaDataMgr.getInstance();
                                parseSideMenu = new ParseSideMenu();
                                ClientStatusMgr clientStatusMgr = ClientStatusMgr.getInstance();
                                searchByValue = clientNo;
                                try {
                                    clientVec = clientMgr.getOnArbitraryKey(searchByValue.trim(), "key2");
                                } catch (Exception ex) {
                                    logger.error(ex);
                                }
                                if (!clientVec.isEmpty()) {
                                    clientWbo = (WebBusinessObject) clientVec.get(0);
                                    request.setAttribute("clientWbo", clientWbo);
                                    try {
                                        clientStatusVec = clientStatusMgr.getOnArbitraryKey(
                                                (String) clientWbo.getAttribute("id"), "key2");
                                    } catch (SQLException ex) {
                                        logger.error(ex);
                                    } catch (Exception ex) {
                                        logger.error(ex);
                                    }
                                    metaMgr.setMetaData("xfile.jar");
                                    clientMenu = new Vector();
                                    mode = (String) request.getSession().getAttribute("currentMode");
                                    if (!clientStatusVec.isEmpty()) {
                                        clientMenu = parseSideMenu.parseSideMenu(mode, "client_menu.xml", "");
                                    } else {
                                        clientMenu = parseSideMenu.parseSideMenu(mode, "new_client_menu.xml", "");
                                    }
                                    metaMgr.closeDataSource();
                                    linkVec = new Vector();
                                    link = "";
                                    style = new Hashtable();
                                    style = (Hashtable) clientMenu.get(0);
                                    title = style.get("title").toString();
                                    title += "<br>" + clientWbo.getAttribute("name").toString();
                                    style.remove("title");
                                    style.put("title", title);
                                    for (int i = 1; i < clientMenu.size() - 1; i++) {
                                        linkVec = new Vector();
                                        link = "";
                                        linkVec = (Vector) clientMenu.get(i);
                                        link = (String) linkVec.get(1);
                                        link += clientWbo.getAttribute("id").toString();
                                        linkVec.remove(1);
                                        linkVec.add(link);
                                    }
                                    request.getSession().setAttribute("sideMenuVec", clientMenu);
                                }
                                request.setAttribute("page", servedPage);
                                request.setAttribute("jobs", jobs);
                                clientId = (String) request.getAttribute("clientId");
                                clientWbo = clientMgr.getOnSingleKey(clientId);
                                request.setAttribute("clientWbo", clientWbo);
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                                request.setAttribute("jobs", jobs);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex);
                        }
                    }
                    if (saveInRealState.equalsIgnoreCase("true")) {
                        try {
                            if (checkExternalConn()) {
                                if (clientMgr.saveClientRealState2(request, session, persistentUser)) {
                                    clientNo = (String) request.getAttribute("code");
                                    searchByValue = null;
                                    Vector clientVec = null,
                                            clientStatusVec = null;
                                    metaMgr = MetaDataMgr.getInstance();
                                    parseSideMenu = new ParseSideMenu();
                                    ClientStatusMgr clientStatusMgr = ClientStatusMgr.getInstance();
                                    searchByValue = clientNo;
                                    try {
                                        clientVec = clientMgr.getOnArbitraryKey(searchByValue.trim(), "key2");
                                    } catch (Exception ex) {
                                        logger.error(ex);
                                    }
                                    if (!clientVec.isEmpty()) {
                                        clientWbo = (WebBusinessObject) clientVec.get(0);
                                        request.setAttribute("clientWbo", clientWbo);
                                        try {
                                            clientStatusVec = clientStatusMgr.getOnArbitraryKey(
                                                    (String) clientWbo.getAttribute("id"), "key2");
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        } catch (Exception ex) {
                                            logger.error(ex);
                                        }
                                        metaMgr.setMetaData("xfile.jar");
                                        clientMenu = new Vector();
                                        mode = (String) request.getSession().getAttribute("currentMode");

                                        if (!clientStatusVec.isEmpty()) {
                                            clientMenu = parseSideMenu.parseSideMenu(mode, "client_menu.xml", "");
                                        } else {
                                            clientMenu = parseSideMenu.parseSideMenu(mode, "new_client_menu.xml", "");
                                        }
                                        metaMgr.closeDataSource();
                                        linkVec = new Vector();
                                        link = "";
                                        style = new Hashtable();
                                        style = (Hashtable) clientMenu.get(0);
                                        title = style.get("title").toString();
                                        title += "<br>" + clientWbo.getAttribute("name").toString();
                                        style.remove("title");
                                        style.put("title", title);
                                        for (int i = 1; i < clientMenu.size() - 1; i++) {
                                            linkVec = new Vector();
                                            link = "";
                                            linkVec = (Vector) clientMenu.get(i);
                                            link = (String) linkVec.get(1);
                                            link += clientWbo.getAttribute("id").toString();
                                            linkVec.remove(1);
                                            linkVec.add(link);
                                        }
                                        request.getSession().setAttribute("sideMenuVec", clientMenu);
                                    }
                                    request.setAttribute("page", servedPage);
                                    request.setAttribute("jobs", jobs);
                                    clientId = (String) request.getAttribute("clientId");
                                    clientWbo = clientMgr.getOnSingleKey(clientId);
                                    request.setAttribute("clientWbo", clientWbo);
                                    request.setAttribute("Status", "Ok");
                                } else {
                                    request.setAttribute("errorExtConn", "1");
                                    clientWbo = new WebBusinessObject();
                                    clientWbo.setAttribute("name", clientName);
                                    clientWbo.setAttribute("partner", request.getParameter("partner"));
                                    clientWbo.setAttribute("gender", request.getParameter("gender"));
                                    clientWbo.setAttribute("clientSsn", request.getParameter("clientSsn"));
                                    clientWbo.setAttribute("clientNO", " ");
                                    clientWbo.setAttribute("matiralStatus", request.getParameter("matiralStatus"));
                                    clientWbo.setAttribute("clientMobile", request.getParameter("clientMobile"));
                                    clientWbo.setAttribute("phone", request.getParameter("phone"));
                                    clientWbo.setAttribute("clientSalary", request.getParameter("clientSalary"));
                                    clientWbo.setAttribute("address", request.getParameter("address"));
                                    clientWbo.setAttribute("email", request.getParameter("email"));
                                    request.setAttribute("clientWbo", clientWbo);
                                    request.setAttribute("Status", "error");
                                    request.setAttribute("jobs", jobs);
                                }
                            } else {
                                request.setAttribute("errorExtConn", "1");
                                request.setAttribute("clientWbo", null);
                                request.setAttribute("jobs", jobs);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex);
                        }
                    }
                } catch (NoUserInSessionException noUser) {
                }
                securityUser.getDefaultCampaign();
                if (clientId != null && securityUser != null && securityUser.getDefaultCampaign() != null) {
                    ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                    String[] campaignIDs = {securityUser.getDefaultCampaign()};
                    String[] emptyArray = {};
                    clientCampaignMgr.saveCampaignsByClient(clientId, campaignIDs, emptyArray, emptyArray, emptyArray, session, true);
                }
                clientMgr.cashData();
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 12:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                WebBusinessObject data = new WebBusinessObject();
                String clientNumber = request.getParameter("clientNumber");
                wbo = clientMgr.getOnSingleKey("key2", clientNumber);
                if (wbo == null) {
                    wbo = clientMgr.getClientByMobile(clientNumber);
                }
                if (wbo != null) {
                    data.setAttribute("status", "Ok");
                    data.setAttribute("clientName", wbo.getAttribute("name"));
                    data.setAttribute("email", wbo.getAttribute("email") != null ? wbo.getAttribute("email") : "");
                    data.setAttribute("mobile", wbo.getAttribute("mobile") != null ? wbo.getAttribute("mobile") : "");
                    data.setAttribute("clientId", wbo.getAttribute("id"));
                } else {
                    data.setAttribute("status", "No");
                }
                out.write(Tools.getJSONObjectAsString(data));
                break;
            case 13:
                servedPage = "/docs/Adminstration/call_date.jsp";
                IssueMgr issueMgr = IssueMgr.getInstance();
                clientId = request.getParameter("clientID");
                Vector clientVec = new Vector();
                issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                try {
                    clientVec = issueMgr.getCallDate(clientId);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                request.setAttribute("clientVec", clientVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 14:
                servedPage = "/docs/Adminstration/new_job.jsp";
                tradeTypeV = new Vector();
                tradeTypeMgr = TradeTypeMgr.getInstance();
                tradeTypeV = tradeTypeMgr.getCashedTable();
                request.setAttribute("tradeTypeV", tradeTypeV);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 15:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                String arName = request.getParameter("jobNameAr");
                String enName = request.getParameter("jobNameEn");
                String jobCode = request.getParameter("code");
                String ttradeTypeId = request.getParameter("ttradeTypeId");
                wbo.setAttribute("arName", arName);
                if (enName != null && !enName.equals("")) {
                    wbo.setAttribute("enName", enName);
                } else {
                    wbo.setAttribute("enName", arName);
                }
                wbo.setAttribute("ttradeTypeId", ttradeTypeId);
                String code = UniqueIDGen.getNextID();
                wbo.setAttribute("code", jobCode);
                try {
                    tradeMgr = TradeMgr.getInstance();
                    String status = tradeMgr.saveObjectForClient(wbo, session);
                    if (status.equals("ok")) {
                        wbo.setAttribute("Status", "Ok");
                        wbo.setAttribute("code", code);
                        wbo.setAttribute("name", arName);
                    } else {
                        if (status.equals("ORA-00001: unique constraint (PCRM.TRADE_NAME_UNIQUE) violated")) {
                            wbo.setAttribute("Status", "duplicate");
                        } else {
                            wbo.setAttribute("Status", status);
                        }
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 16:
                servedPage = "/docs/call_center/emails.jsp";
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                request.setAttribute("email", loggedUser.getAttribute("email"));
                request.setAttribute("status", "");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 17:
                servedPage = "/docs/call_center/sms.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 18:
                servedPage = "docs/call_center/attach_grades_to_customer.jsp";
                request.setAttribute("clientId", request.getParameter("clientId"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 19:
                servedPage = "/docs/call_center/customer_list.jsp";
                clientMgr = ClientMgr.getInstance();
                String fieldValue = request.getParameter("fieldValue");
                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                String selectionType = request.getParameter("selectionType");
                List conditions = new ArrayList<FilterCondition>();
                filter = Tools.getPaginationInfo(request, response);
                conditions.addAll(filter.getConditions());
                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("NAME", fieldValue, Operations.LIKE));
                }
                filter.setConditions(conditions);
                List<WebBusinessObject> carList = new ArrayList<WebBusinessObject>(0);
                // grab carList list
                try {
                    carList = clientMgr.paginationEntity(filter, "");
                } catch (Exception e) {
                }
                if (selectionType == null) {
                    selectionType = "single";
                }
                String formName = (String) request.getParameter("formName");
                if (formName == null) {
                    formName = "";
                }
                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("carList", carList);
                this.forward(servedPage, request, response);
                break;
            case 20:
                wbo = new WebBusinessObject();
                clientId = request.getParameter("clientId");
                String fromDate = request.getParameter("fromDate");
                String degreeId = request.getParameter("degreeId");
                DateParser dateParser = new DateParser();
                wbo.setAttribute("clientId", clientId);
                wbo.setAttribute("degreeId", degreeId);
                wbo.setAttribute("fromDate", dateParser.formatSqlDate(fromDate));
                CustomerGradesMgr customerGradesMgr = CustomerGradesMgr.getInstance();
                if (customerGradesMgr.updateEqpEmp(wbo)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "No");
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 21:
                servedPage = "docs/call_center/attach_employees_to_client.jsp";
                tradeMgr = TradeMgr.getInstance();
                Vector employeeType = new Vector();
                data = new WebBusinessObject();
                data = tradeMgr.getOnSingleKey("5");
                if (data != null) {
                    employeeType.add(data);
                }
                data = new WebBusinessObject();
                data = tradeMgr.getOnSingleKey("6");
                if (data != null) {
                    employeeType.add(data);
                }
                data = new WebBusinessObject();
                data = tradeMgr.getOnSingleKey("9");
                if (data != null) {
                    employeeType.add(data);
                }
                request.setAttribute("empType", employeeType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 22:
                servedPage = "/docs/call_center/client_list.jsp";
                fieldValue = request.getParameter("fieldValue");
                filter = new com.silkworm.pagination.Filter();
                selectionType = request.getParameter("selectionType");
                conditions = new ArrayList<FilterCondition>();
                filter = Tools.getPaginationInfo(request, response);
                conditions.addAll(filter.getConditions());
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("NAME", fieldValue, Operations.LIKE));

                }
                filter.setConditions(conditions);
                carList = new ArrayList<WebBusinessObject>(0);
                try {
                    carList = clientMgr.paginationEntity(filter, "");
                } catch (Exception e) {
                }
                if (selectionType == null) {
                    selectionType = "single";
                }
                formName = (String) request.getParameter("formName");
                if (formName == null) {
                    formName = "";
                }
                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("clientsList", carList);
                this.forward(servedPage, request, response);
                break;
            case 23:
                wbo = new WebBusinessObject();
                dateParser = new DateParser();
                String empName = null;
                WebBusinessObject empWbo = null;
                loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                clientId = request.getParameter("clientId");
                fromDate = request.getParameter("fromDate");
                String empType = request.getParameter("empType");
                String empId = request.getParameter("empId");
                String tradeId = request.getParameter("tradeId");
                wbo.setAttribute("clientId", clientId);
                wbo.setAttribute("userId", empId);
                wbo.setAttribute("tradeId", tradeId);
                wbo.setAttribute("fromDate", dateParser.formatSqlDate(fromDate));
                wbo.setAttribute("relationType", empType);
                wbo.setAttribute("createdBy", loggedUser.getAttribute("userId"));
                if (userClientsMgr.updateEqpEmp(wbo)) {
                    wbo = new WebBusinessObject();
                    empWbo = userMgr.getOnSingleKey(empId);
                    empName = (String) empWbo.getAttribute("userName");
                    wbo.setAttribute("status", "Ok");
                    wbo.setAttribute("empName", empName);
                } else {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "No");
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 24:
                clientId = request.getParameter("clientId");
                String typeStr = null;
                String[] typeStrArr = {"Deliver", "Accounting", "Support"};
                Vector clientsVector = (Vector) userClientsMgr.getUnitEmployees(clientId);
                tempVec = new Vector();
                WebBusinessObject tempWbo = null;
                wbo = null;
                Calendar cal = Calendar.getInstance();
                String jDateFormat = "yyyy/MM/dd";
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowDate = sdf.format(cal.getTime());
                boolean empTypeFound = false;
                for (int i = 0; i < 3; i++) {
                    tempWbo = new WebBusinessObject();
                    empTypeFound = false;
                    for (int j = 0; j < clientsVector.size(); j++) {
                        wbo = (WebBusinessObject) clientsVector.get(j);
                        typeStr = (String) wbo.getAttribute("empType");
                        if (typeStr.equalsIgnoreCase(typeStrArr[i])) {
                            empTypeFound = true;
                            wbo = (WebBusinessObject) clientsVector.get(j);
                            break;
                        }
                    }
                    if (empTypeFound) {
                        tempWbo.setAttribute("userName", (String) wbo.getAttribute("userName"));
                        tempWbo.setAttribute("fromDate", (String) wbo.getAttribute("fromDate"));
                    } else {
                        tempWbo.setAttribute("userName", "---");
                        tempWbo.setAttribute("fromDate", nowDate);
                    }
                    tempVec.add(tempWbo);
                }

                Vector x = new Vector();
                out.write(Tools.getJSONArrayAsString(tempVec));
                break;
            case 25:
                servedPage = "/docs/call_center/iPad.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 26:
                String count = request.getParameter("count");
                request.setAttribute("count", count);
                try {
                    if (clientMgr.updateCounter(request)) {
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                break;
            case 27:
                wbo = new WebBusinessObject();
                try {
                    count = clientMgr.getCounter();
                    wbo.setAttribute("count", count);
                    wbo.setAttribute("status", "ok");
                } catch (SQLException | NoSuchColumnException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 28:
                wbo = new WebBusinessObject();
                try {
                    if (request.getParameter("type").equals("0")) {
                        boolean isFound = false;
                        wbo2 = new WebBusinessObject();
                        String clientCompId = request.getParameter("clientCompId");
                        WebBusinessObject appWbo = new WebBusinessObject();
                        appWbo = appointmentMgr.getOnSingleKey("key2", clientCompId);
                        if (appWbo != null) {
                            isFound = true;
                        }
                        wbo2 = (WebBusinessObject) clientComplaintsMgr.getOnSingleKey(clientCompId);
                        wbo2.setAttribute("clientCompId", request.getParameter("clientCompId"));
                        wbo2.setAttribute("employeeId", request.getParameter("userId"));
                        wbo2.setAttribute("notes", request.getParameter("title"));
                        wbo2.setAttribute("responsiblity", "1");
                        wbo2.setAttribute("complaintComment", request.getParameter("title"));
                        wbo2.setAttribute("compSubject", request.getParameter("title"));
                        wbo2.setAttribute("supervisorId", request.getParameter("supervisorId"));
                        if (!isFound) {
                            if (appointmentMgr.saveAppointment2(request, (String) persistentUser.getAttribute("userId")) && clientComplaintsMgr.saveForwardComplaintSuperVisor(wbo2, request, session)) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        } else {
                            wbo.setAttribute("status", "found");
                        }
                    } else if (request.getParameter("type").equals("2")) {
                        if (appointmentMgr.testSaveAppointment(request.getParameter("appID")).equals("24")) {
                            if (appointmentMgr.saveAppointment(request, (String) persistentUser.getAttribute("userId"))) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } else {
                        if (appointmentMgr.saveAppointment(request, (String) persistentUser.getAttribute("userId"))) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 29:
                wbo = new WebBusinessObject();
                CommentsMgr commentsMgr = CommentsMgr.getInstance();
                try {
                    if (commentsMgr.saveComment(request, persistentUser)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 31:
                servedPage = "/manager_agenda_emg.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 32: //showAppointment
                servedPage = "/show_appointment.jsp";
                clientId = (String) request.getParameter("clientId");
                appointments = new Vector();
                try {
                    appointments = appointmentMgr.getAppointments(clientId, "key1");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("appointments", appointments);
                this.forward(servedPage, request, response);
                break;
            case 33:
                String appointmentId = request.getParameter("appointmentId");
                wbo = new WebBusinessObject();
                try {
                    if (appointmentMgr.deteleAppointment(appointmentId)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 34: //updateAppointment
                wbo = new WebBusinessObject();
                try {
                    if (appointmentMgr.updateAppointment(request, session)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 35:
                String commentId = request.getParameter("commentId");
                commentsMgr = CommentsMgr.getInstance();
                wbo = new WebBusinessObject();
                WebBusinessObject commentWbo = commentsMgr.getOnSingleKey(commentId);
                try {
                    loggerWbo = new WebBusinessObject();
                    loggerWbo.setAttribute("objectXml", commentWbo.getObjectAsXML());
                    loggerWbo.setAttribute("realObjectId", commentId);
                    loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                    loggerWbo.setAttribute("objectName", commentWbo.getAttribute("comment"));
                    loggerWbo.setAttribute("loggerMessage", "Comment Deleted");
                    loggerWbo.setAttribute("eventName", "Delete");
                    loggerWbo.setAttribute("objectTypeId", "7");
                    loggerWbo.setAttribute("eventTypeId", "1");
                    loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                    if (commentsMgr.deteleComment(commentId)) {
                        loggerMgr.saveObject(loggerWbo);
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 36:
                commentsMgr = CommentsMgr.getInstance();
                wbo = new WebBusinessObject();
                String comment = (String) request.getParameter("comment");
                try {
                    commentId = request.getParameter("commentId");
                    commentWbo = commentsMgr.getOnSingleKey(commentId);
                    loggerWbo = new WebBusinessObject();
                    loggerWbo.setAttribute("objectXml", commentWbo.getObjectAsXML());
                    loggerWbo.setAttribute("realObjectId", commentId);
                    loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                    loggerWbo.setAttribute("objectName", commentWbo.getAttribute("comment"));
                    loggerWbo.setAttribute("loggerMessage", "Comment Updated");
                    loggerWbo.setAttribute("eventName", "Update");
                    loggerWbo.setAttribute("objectTypeId", "7");
                    loggerWbo.setAttribute("eventTypeId", "3");
                    loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                    if (commentsMgr.updateComment(request, persistentUser)) {
                        loggerMgr.saveObject(loggerWbo);
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("comment", comment);
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 37:
                servedPage = "/manager_agenda_closed.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 38:
                servedPage = "/show_campaign.jsp";
                clientId = (String) request.getParameter("clientId");
                ClientSeasonsMgr clientSeasonsMgr = ClientSeasonsMgr.getInstance();
                Vector campaigns = new Vector();
                try {
                    campaigns = clientSeasonsMgr.getOnArbitraryKey(clientId, "key1");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("campaigns", campaigns);
                this.forward(servedPage, request, response);
                break;
            case 39:
                clientSeasonsMgr = ClientSeasonsMgr.getInstance();
                wbo = new WebBusinessObject();
                try {
                    if (clientSeasonsMgr.updateCampaign(request, session)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 40:
                String campaignId = request.getParameter("campaignId");
                clientSeasonsMgr = ClientSeasonsMgr.getInstance();
                wbo = new WebBusinessObject();
                try {
                    if (clientSeasonsMgr.deteleCampaign(campaignId)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 41:
                wbo = new WebBusinessObject();
                clientId = request.getParameter("clientId");
                fromDate = request.getParameter("fromDate");
                degreeId = request.getParameter("degreeId");
                wbo.setAttribute("clientId", clientId);
                wbo.setAttribute("degreeId", degreeId);
                wbo.setAttribute("fromDate", "SYSDATE");
                customerGradesMgr = CustomerGradesMgr.getInstance();
                if (customerGradesMgr.updateCustomerGrade(wbo)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "No");
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 42:
                servedPage = "/docs/call_center/client_report.jsp";
                jobs = new Vector();
                tradeMgr = TradeMgr.getInstance();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("jobs", jobs);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 43:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                arName = request.getParameter("regionNameAr");
                code = UniqueIDGen.getNextID();
                wbo.setAttribute("code", code);
                wbo.setAttribute("arName", arName);
                try {
                    regionMgr = RegionMgr.getInstance();
                    if (regionMgr.saveObjectForClient(wbo, session)) {
                        wbo.setAttribute("Status", "Ok");
                        wbo.setAttribute("code", code);
                        wbo.setAttribute("name", arName);
                    } else {
                        wbo.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 44:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                clientMgr = ClientMgr.getInstance();
                String jobName = "";
                try {
                    if (clientMgr.updateClient(request)) {
                        jobCode = (String) request.getParameter("clientJob");
                        WebBusinessObject wbo5 = new WebBusinessObject();
                        tradeMgr = TradeMgr.getInstance();
                        wbo5 = tradeMgr.getOnSingleKey(jobCode);
                        if (wbo5 != null) {
                            jobName = (String) wbo5.getAttribute("tradeName");
                        } else {
                            jobName = "";
                        }
                        //For logging Update
                        clientWbo = clientMgr.getOnSingleKey(request.getParameter("clientID"));
                        loggerWbo = new WebBusinessObject();
                        loggerWbo.setAttribute("objectXml", clientWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", request.getParameter("clientID"));
                        loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", request.getParameter("name"));
                        loggerWbo.setAttribute("loggerMessage", "Client Updated");
                        loggerWbo.setAttribute("eventName", "Update");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "3");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        loggerMgr.saveObject(loggerWbo);
                        wbo.setAttribute("Status", "Ok");
                        wbo.setAttribute("job", jobName);
                    } else {
                        wbo.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 45:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                data = new WebBusinessObject();
                clientName = request.getParameter("clientName");
                clientMgr = ClientMgr.getInstance();
                wbo = clientMgr.getOnSingleKey("key5", clientName);
                if (wbo != null) {
                    data.setAttribute("clientName", wbo.getAttribute("name"));
                    data.setAttribute("id", wbo.getAttribute("id"));
                    data.setAttribute("status", "Ok");
                } else {
                    data.setAttribute("status", "No");
                }
                out.write(Tools.getJSONObjectAsString(data));
                break;
            case 46:
                servedPage = "/docs/Adminstration/new_company.jsp";
                tradeMgr = TradeMgr.getInstance();
                regionMgr = RegionMgr.getInstance();
                regions = new Vector();
                regions = regionMgr.getCashedTable();
                products = new Vector();
                mainProducts = new Vector();
                Vector tradeV = new Vector();
                tradeMgr = TradeMgr.getInstance();
                try {
                    tradeV = tradeMgr.getTradeByType("2");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                try {
                    mainProducts = projectMgr.getOnArbitraryDoubleKeyOracle("44", "key6", "66", "key9"); // 66 for active projects only
                    for (int i = 0; i < mainProducts.size(); i++) {
                        WebBusinessObject projectWbo = (WebBusinessObject) mainProducts.get(i);
                        ArrayList<WebBusinessObject> areas = projectMgr.getAreasForProject(projectWbo.getAttribute("projectID").toString());
                        String arreaArrayName = projectWbo.getAttribute("projectID").toString();
                        request.setAttribute(arreaArrayName, areas);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                try {
                    request.setAttribute("seasonsList", new ArrayList<>(seasonMgr.getOnArbitraryKeyOracle("1", "key2")));
                } catch (Exception ex) {
                    request.setAttribute("seasonsList", new ArrayList<>());
                }
                request.setAttribute("tradeList", new ArrayList<>(tradeV));
                request.setAttribute("page", servedPage);
                request.setAttribute("jobs", jobs);
                request.setAttribute("regions", regions);
                request.setAttribute("departmentMgrId", loggegUserId);
                request.setAttribute("departmentMgrName", userMgr.getByKeyColumnValue(loggegUserId, "key3"));
                request.setAttribute("mainProducts", mainProducts);
                this.forwardToServedPage(request, response);
                break;

            case 47:
                servedPage = "/docs/customer/distribute_client.jsp";
                tradeMgr = TradeMgr.getInstance();
                clientId = null;
                clientName = request.getParameter("clientName");
                tradeMgr = TradeMgr.getInstance();
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                clientWbo = new WebBusinessObject();
                job = request.getParameter("job");
                wbo = new WebBusinessObject();
                wbo = tradeMgr.getOnSingleKey("key2", job);
                if (wbo != null) {
                    jobTitle = (String) wbo.getAttribute("tradeName");
                } else {
                    jobTitle = "";
                }
                request.setAttribute("jobTitle", jobTitle);
                region = request.getParameter("region");
                request.setAttribute("regionTitle", region);
                try {
                    String saveInRealState = request.getParameter("saveInRealState");
                    if (saveInRealState.equalsIgnoreCase("false")) {
                        try {
                            if (clientMgr.saveCompany(request, session, persistentUser)) {
                                clientVec = new Vector();
                                clientNo = (String) request.getAttribute("code");
                                searchByValue = null;
                                Vector clientStatusVec = null;
                                metaMgr = MetaDataMgr.getInstance();
                                parseSideMenu = new ParseSideMenu();
                                ClientStatusMgr clientStatusMgr = ClientStatusMgr.getInstance();
                                searchByValue = clientNo;
                                try {
                                    clientVec = clientMgr.getOnArbitraryKey(searchByValue.trim(), "key2");
                                } catch (Exception ex) {
                                    logger.error(ex);
                                }
                                if (!clientVec.isEmpty()) {
                                    clientWbo = (WebBusinessObject) clientVec.get(0);
                                    try {
                                        clientStatusVec = clientStatusMgr.getOnArbitraryKey(
                                                (String) clientWbo.getAttribute("id"), "key2");
                                    } catch (SQLException ex) {
                                        logger.error(ex);
                                    } catch (Exception ex) {
                                        logger.error(ex);
                                    }
                                    metaMgr.setMetaData("xfile.jar");
                                    clientMenu = new Vector();
                                    mode = (String) request.getSession().getAttribute("currentMode");
                                    if (!clientStatusVec.isEmpty()) {
                                        clientMenu = parseSideMenu.parseSideMenu(mode, "client_menu.xml", "");
                                    } else {
                                        clientMenu = parseSideMenu.parseSideMenu(mode, "new_client_menu.xml", "");
                                    }
                                    metaMgr.closeDataSource();
                                    linkVec = new Vector();
                                    link = "";
                                    style = new Hashtable();
                                    style = (Hashtable) clientMenu.get(0);
                                    title = style.get("title").toString();
                                    title += "<br>" + clientWbo.getAttribute("name").toString();
                                    style.remove("title");
                                    style.put("title", title);
                                    for (int i = 1; i < clientMenu.size() - 1; i++) {
                                        linkVec = new Vector();
                                        link = "";
                                        linkVec = (Vector) clientMenu.get(i);
                                        link = (String) linkVec.get(1);
                                        link += clientWbo.getAttribute("id").toString();
                                        linkVec.remove(1);
                                        linkVec.add(link);
                                    }
                                    request.getSession().setAttribute("sideMenuVec", clientMenu);
                                }

                                clientId = (String) request.getAttribute("clientId");
                                clientWbo = clientMgr.getOnSingleKey(clientId);
                                request.setAttribute("jobs", jobs);
                                request.setAttribute("Status", "Ok");
// try auto pilot
                                campaignIds = request.getParameterValues("campaigns");
                                gotoNewClientPage = false;
                                AutoPilotFeature feature = new AutoPilotFeature();
                                if (securityUser.isCanRunAutoPilotMode()) {
                                    feature.autoPilot(clientId, request, persistentUser);
                                    gotoNewClientPage = true;
                                } else {
                                    try {
                                        feature.saveProduct(clientId, request);
                                    } catch (Exception ex) {
                                        logger.error(ex);
                                    }
                                }
                                if (clientId != null && campaignIds != null) {
                                    ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                                    String[] emptyArray = {};
                                    clientCampaignMgr.saveCampaignsByClient(clientId, campaignIds, emptyArray, emptyArray, emptyArray, session, true);
                                }
                                if (gotoNewClientPage) {
                                    request.setAttribute("autoPilotMessage", "ok");
                                    this.forward("/ClientServlet?op=GetCompanyForm", request, response);
                                } else {
                                    request.setAttribute("clientWbo", clientWbo);
                                    employees = new ArrayList<WebBusinessObject>();
                                    try {
                                        if (securityUser.getDistributionGroup() != null && !securityUser.getDistributionGroup().isEmpty()) {
                                            employees = userMgr.getUsersByGroup(securityUser.getDistributionGroup());
                                        }
                                    } catch (SQLException ex) {
                                        logger.error(ex);
                                    }
                                    try {
                                        request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                                    } catch (Exception ex) {
                                        request.setAttribute("requestTypes", new ArrayList<>());
                                    }
                                    clientId = (String) request.getAttribute("clientId");
                                    request.setAttribute("employees", employees);
                                    request.setAttribute("clientId", clientId);
                                    request.setAttribute("clientName", clientName);
                                    request.setAttribute("page", servedPage);
                                    this.forwardToServedPage(request, response);
                                    break;
                                }
                            } else {
                                request.setAttribute("Status", "No");
                                request.setAttribute("jobs", jobs);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex);
                        }
                    }
                    if (saveInRealState.equalsIgnoreCase("true")) {
                        try {
                            if (checkExternalConn()) {
                                if (clientMgr.saveCompanyRealState(request, session, persistentUser)) {
                                    clientNo = (String) request.getAttribute("code");
                                    searchByValue = null;
                                    Vector clientStatusVec = null;
                                    clientVec = new Vector();
                                    metaMgr = MetaDataMgr.getInstance();
                                    parseSideMenu = new ParseSideMenu();
                                    ClientStatusMgr clientStatusMgr = ClientStatusMgr.getInstance();
                                    searchByValue = clientNo;
                                    try {
                                        clientVec = clientMgr.getOnArbitraryKey(searchByValue.trim(), "key2");
                                    } catch (Exception ex) {
                                        logger.error(ex);
                                    }
                                    if (!clientVec.isEmpty()) {
                                        clientWbo = (WebBusinessObject) clientVec.get(0);
                                        try {
                                            clientStatusVec = clientStatusMgr.getOnArbitraryKey(
                                                    (String) clientWbo.getAttribute("id"), "key2");
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        } catch (Exception ex) {
                                            logger.error(ex);
                                        }
                                        metaMgr.setMetaData("xfile.jar");
                                        clientMenu = new Vector();
                                        mode = (String) request.getSession().getAttribute("currentMode");

                                        if (!clientStatusVec.isEmpty()) {
                                            clientMenu = parseSideMenu.parseSideMenu(mode, "client_menu.xml", "");
                                        } else {
                                            clientMenu = parseSideMenu.parseSideMenu(mode, "new_client_menu.xml", "");
                                        }
                                        metaMgr.closeDataSource();
                                        linkVec = new Vector();
                                        link = "";
                                        style = new Hashtable();
                                        style = (Hashtable) clientMenu.get(0);
                                        title = style.get("title").toString();
                                        title += "<br>" + clientWbo.getAttribute("name").toString();
                                        style.remove("title");
                                        style.put("title", title);
                                        for (int i = 1; i < clientMenu.size() - 1; i++) {
                                            linkVec = new Vector();
                                            link = "";
                                            linkVec = (Vector) clientMenu.get(i);
                                            link = (String) linkVec.get(1);
                                            link += clientWbo.getAttribute("id").toString();
                                            linkVec.remove(1);
                                            linkVec.add(link);
                                        }
                                        request.getSession().setAttribute("sideMenuVec", clientMenu);
                                    }
                                    clientId = (String) request.getAttribute("clientId");
                                    clientWbo = clientMgr.getOnSingleKey(clientId);
                                    request.setAttribute("jobs", jobs);
                                    request.setAttribute("Status", "Ok");
// try auto pilot
                                    campaignIds = request.getParameterValues("campaigns");
                                    gotoNewClientPage = false;
                                    AutoPilotFeature feature = new AutoPilotFeature();
                                    if (securityUser.isCanRunAutoPilotMode()) {
                                        feature.autoPilot(clientId, request, persistentUser);
                                        gotoNewClientPage = true;
                                    } else {
                                        try {
                                            feature.saveProduct(clientId, request);
                                        } catch (Exception ex) {
                                            logger.error(ex);
                                        }
                                    }
                                    if (clientId != null && campaignIds != null) {
                                        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                                        String[] emptyArray = {};
                                        clientCampaignMgr.saveCampaignsByClient(clientId, campaignIds, emptyArray, emptyArray, emptyArray, session, true);
                                    }
                                    if (gotoNewClientPage) {
                                        request.setAttribute("autoPilotMessage", "ok");
                                        this.forward("/ClientServlet?op=GetCompanyForm", request, response);
                                    } else {
                                        request.setAttribute("clientWbo", clientWbo);
                                        employees = new ArrayList<WebBusinessObject>();
                                        try {
                                            if (securityUser.getDistributionGroup() != null && !securityUser.getDistributionGroup().isEmpty()) {
                                                employees = userMgr.getUsersByGroup(securityUser.getDistributionGroup());
                                            }
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        }
                                        clientId = (String) request.getAttribute("clientId");
                                        request.setAttribute("employees", employees);
                                        request.setAttribute("clientId", clientId);
                                        request.setAttribute("clientName", clientName);
                                        request.setAttribute("page", servedPage);
                                        this.forwardToServedPage(request, response);
                                    }
                                } else {
                                    clientWbo = new WebBusinessObject();
                                    clientWbo.setAttribute("name", clientName);
                                    clientWbo.setAttribute("partner", request.getParameter("partner"));
                                    clientWbo.setAttribute("gender", request.getParameter("gender"));
                                    clientWbo.setAttribute("clientSsn", request.getParameter("clientSsn"));
                                    clientWbo.setAttribute("clientNO", " ");
                                    clientWbo.setAttribute("matiralStatus", request.getParameter("matiralStatus"));
                                    clientWbo.setAttribute("clientMobile", request.getParameter("clientMobile"));
                                    clientWbo.setAttribute("phone", request.getParameter("phone"));
                                    clientWbo.setAttribute("clientSalary", request.getParameter("clientSalary"));
                                    clientWbo.setAttribute("address", request.getParameter("address"));
                                    clientWbo.setAttribute("email", request.getParameter("email"));
                                    request.setAttribute("clientWbo", clientWbo);
                                    request.setAttribute("Status", "error");
                                    request.setAttribute("jobs", jobs);
                                }
                            } else {
                                request.setAttribute("errorExtConn", "1");
                                request.setAttribute("clientWbo", null);
                                request.setAttribute("jobs", jobs);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex);
                        }
                    }
                } catch (NoUserInSessionException noUser) {
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 48:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                clientMgr = ClientMgr.getInstance();
                jobName = "";
                try {
                    if (clientMgr.updateCompany(request)) {
                        wbo.setAttribute("Status", "Ok");
                    } else {
                        wbo.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 49:
                String userId = (String) request.getParameter("userId");
                String date = (String) request.getParameter("date");
                String pageType = (String) request.getParameter("pageType");
                if (pageType.equals("1")) {
                    servedPage = "/show_appointment2.jsp";
                } else {
                    servedPage = "/show_appointment3.jsp";
                }
                appointments = new Vector();
                appointments = appointmentMgr.getAppointmentsDates(userId, date);
                request.setAttribute("page", servedPage);
                request.setAttribute("appointments", appointments);
                this.forward(servedPage, request, response);
                break;
            case 50:
                userId = (String) request.getParameter("userId");
                date = (String) request.getParameter("date");
                appointments = new Vector();
                String number = "0";
                number = appointmentMgr.getCountAppointmentsDates(userId, date);
                wbo = new WebBusinessObject();
                wbo.setAttribute("number", number);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 51:
                servedPage = "/supervisor_agenda_emg.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 52:
                clientId = (String) request.getParameter("clientId");
                servedPage = "/show_client_information.jsp";
                clientWbo = clientMgr.getOnSingleKey(clientId);
                request.setAttribute("page", servedPage);
                request.setAttribute("clientWbo", clientWbo);
                this.forward(servedPage, request, response);
                break;
            case 53:
                out = response.getWriter();
                data = new WebBusinessObject();
                clientName = request.getParameter("clientName");
                clientMgr = ClientMgr.getInstance();
                wbo = clientMgr.getOnSingleKey("key5", clientName);
                if (wbo != null) {
                    data.setAttribute("status", "Ok");
                    data.setAttribute("clientName", wbo.getAttribute("name"));
                    data.setAttribute("clientId", wbo.getAttribute("id"));
                } else {
                    data.setAttribute("status", "No");
                }
                out.write(Tools.getJSONObjectAsString(data));
                break;
            case 54:
                servedPage = "/docs/Adminstration/new_contractor.jsp";
                tradeMgr = TradeMgr.getInstance();
                regionMgr = RegionMgr.getInstance();
                regions = new Vector();
                regions = regionMgr.getCashedTable();
                tradeV = new Vector();
                tradeMgr = TradeMgr.getInstance();
                try {
                    tradeV = tradeMgr.getTradeByType("2");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("jobs", jobs);
                request.setAttribute("regions", regions);
                request.setAttribute("tradeList", new ArrayList<>(tradeV));
                this.forwardToServedPage(request, response);
                break;
            case 55:
                servedPage = "/docs/Adminstration/new_contractor.jsp";
                tradeMgr = TradeMgr.getInstance();
                clientId = null;
                clientName = request.getParameter("clientName");
                regionMgr = RegionMgr.getInstance();
                regions = regionMgr.getCashedTable();
                jobs = new Vector();
                tradeV = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                    tradeV = tradeMgr.getTradeByType("2");
                } catch (SQLException ex) {
                } catch (Exception ex) {
                }
                clientWbo = new WebBusinessObject();
                jobTitle = "";
                request.setAttribute("jobTitle", jobTitle);
                region = request.getParameter("region");
                request.setAttribute("regionTitle", region);
                try {
                    String saveInRealState = request.getParameter("saveInRealState");
                    if (saveInRealState.equalsIgnoreCase("false")) {
                        try {
                            if (clientMgr.saveCompany(request, session, persistentUser)) {
                                clientVec = new Vector();
                                clientNo = (String) request.getAttribute("code");
                                searchByValue = null;
                                metaMgr = MetaDataMgr.getInstance();
                                parseSideMenu = new ParseSideMenu();
                                searchByValue = clientNo;
                                try {
                                    clientVec = clientMgr.getOnArbitraryKey(searchByValue.trim(), "key2");
                                } catch (Exception ex) {
                                }
                                clientId = (String) request.getAttribute("clientId");
                                clientWbo = clientMgr.getOnSingleKey(clientId);
                                request.setAttribute("clientWbo", clientWbo);
                                request.setAttribute("jobs", jobs);
                                request.setAttribute("Status", "Ok");
                            }
                        } catch (SQLException ex) {
                        }
                    }
                } catch (NoUserInSessionException noUser) {
                }
                request.setAttribute("regions", regions);
                request.setAttribute("page", servedPage);
                request.setAttribute("tradeList", new ArrayList<>(tradeV));
                this.forwardToServedPage(request, response);
                break;
            case 56:
                servedPage = "/docs/Adminstration/Jobs_List.jsp";
                tradeMgr = TradeMgr.getInstance();
                Vector <WebBusinessObject> tradeVector = new Vector();
                String tradeTypeId = null;
                if (request.getParameter("ex") != null && request.getParameter("ex").equals("1")) {
                    if (request.getParameter("tradeTypeId") != null && !request.getParameter("tradeTypeId").equals("")) {
                        tradeTypeId = (String) request.getParameter("tradeTypeId");
                    } else {
                        tradeTypeId = "1";
                    }
                    ArrayList<WebBusinessObject> tradeLst = new ArrayList<WebBusinessObject>();
                    try {
                        tradeLst = new ArrayList<WebBusinessObject>(tradeMgr.getTradeByType(tradeTypeId));
                        
                    } catch (Exception e) {
                    }
                    StringBuilder title = new StringBuilder("Tradesjobs");
                    String headers[] = {"#", "Trade Name"};
                    String attributes[] = {"Number", "tradeName"};
                    String dataTypes[] = {"", "String"};
                    String[] headerStr = new String[1];
                    headerStr[0] = title.toString();
                    HSSFWorkbook workBook = Tools.createExcelReport("TradesJobs", headerStr, null, headers, attributes, dataTypes, tradeLst);
                    Calendar c = Calendar.getInstance();
                    java.util.Date fileDate = c.getTime();
                    sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    sdf.applyPattern("yyyy-MM-dd");
                    String filename = "TradesJobs";
                    try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        try {
                            workBook.write(bos);
                        } finally {
                            bos.close();
                        }
                        byte[] bytes = bos.toByteArray();
                        response.setContentType("application/vnd.ms-excel");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                        response.setContentLength(bytes.length);
                        servletOutputStream.write(bytes, 0, bytes.length);
                        servletOutputStream.flush();
                    }
                } else {
                    if (request.getParameter("tradeTypeId") != null && !request.getParameter("tradeTypeId").equals("")) {
                        tradeTypeId = (String) request.getParameter("tradeTypeId");
                    } else {
                        tradeTypeId = "1";
                    }

                    try {
                        tradeVector = tradeMgr.getTradeByType(tradeTypeId);
                       
                    } catch (Exception e) {
                    }
                    ArrayList dataList = new ArrayList();
                    for(WebBusinessObject tradeJson : tradeVector){
                    HashMap dataEntryMap = new HashMap();  
                    dataEntryMap.put("name",tradeJson.getAttribute("tradeName"));
                    dataEntryMap.put("y", Integer.parseInt(tradeJson.getAttribute("clientCount").toString()));
                    dataList.add(dataEntryMap);
                    
                    }
                    String jsonText = JSONValue.toJSONString(dataList);
                    tradeTypeMgr = TradeTypeMgr.getInstance();
                    tradeTypeV = tradeTypeMgr.getCashedTable();
                    request.setAttribute("tradeTypeV", tradeTypeV);
                    request.setAttribute("tradeVector", tradeVector);
                    request.setAttribute("tradeTypeId", tradeTypeId);
                    
                    request.setAttribute("jsonText", jsonText);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
            case 57:
                tradeId = request.getParameter("tradeId");
                WebBusinessObject wboTrade = new WebBusinessObject();
                tradeMgr = TradeMgr.getInstance();
                wboTrade = tradeMgr.getOnSingleKey(tradeId);
                servedPage = "/docs/Adminstration/Confirm_Delete_Trade_Type.jsp";
                request.setAttribute("wboTrade", wboTrade);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 58:
                tradeId = request.getParameter("seasonTypeId");
                tradeMgr = TradeMgr.getInstance();
                tradeMgr.deleteOnSingleKey(tradeId);
                this.forward("ClientServlet?op=listJob", request, response);
                break;
            case 60:
                tradeTypeId = request.getParameter("tradeId");
                WebBusinessObject wboTypeTrade = new WebBusinessObject();
                tradeMgr = TradeMgr.getInstance();
                wboTypeTrade = tradeMgr.getOnSingleKey(tradeTypeId);
                servedPage = "/docs/Adminstration/View_Job_Type.jsp";
                request.setAttribute("wboTypeTrade", wboTypeTrade);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 61:
                tradeTypeId = request.getParameter("tradeId");
                wboTypeTrade = new WebBusinessObject();
                tradeMgr = TradeMgr.getInstance();
                wboTypeTrade = tradeMgr.getOnSingleKey(tradeTypeId);
                servedPage = "/docs/Adminstration/Update_Trade_Type.jsp";
                request.setAttribute("wboTypeTrade", wboTypeTrade);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 62:
                if (tradeMgr.updateTrade(request)) {
                    request.setAttribute("Status", "OK");
                } else {
                    request.setAttribute("Status", "NO");
                }
                wboTypeTrade = new WebBusinessObject();
                tradeMgr = TradeMgr.getInstance();
                tradeTypeId = request.getParameter("tradeId");
                wboTypeTrade = tradeMgr.getOnSingleKey(tradeTypeId);
                servedPage = "/docs/Adminstration/Update_Trade_Type.jsp";
                request.setAttribute("wboTypeTrade", wboTypeTrade);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 63:
                servedPage = "/add_channel_comment.jsp";
                String clientComplaintId = request.getParameter("clientComplaintId");
                ChannelsMgr channelsMgr = ChannelsMgr.getInstance();
                Vector channels = new Vector();
                try {
                    channels = channelsMgr.getOnArbitraryKey(loggegUserId, "key1");
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("channels", channels);
                request.setAttribute("clientComplaintId", clientComplaintId);
                this.forward(servedPage, request, response);
                break;
            case 64:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                int oldStatus = Integer.parseInt(request.getParameter("oldStatus"));
                String newStatusCode = "";
                switch (oldStatus) {
                    case 12:
                        newStatusCode = "13";
                        break;
                    case 13:
                        newStatusCode = "14";
                        break;
                    case 14:
                        newStatusCode = "11";
                        break;
                    case 11:
                        newStatusCode = "12";
                }
                wbo.setAttribute("statusCode", newStatusCode);
                wbo.setAttribute("date", request.getParameter("statusDate"));
                wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
                wbo.setAttribute("statusNote", request.getParameter("comment"));
                wbo.setAttribute("objectType", "client");
                wbo.setAttribute("parentId", "UL");
                wbo.setAttribute("issueTitle", "UL");
                wbo.setAttribute("cuseDescription", "UL");
                wbo.setAttribute("actionTaken", "UL");
                wbo.setAttribute("preventionTaken", "UL");
                issueStatusMgr = IssueStatusMgr.getInstance();
                wbo.setAttribute("status", "no");
                try {
                    if (issueStatusMgr.changeStatus(wbo, persistentUser, null)
                            && clientMgr.updateClientStatus(request.getParameter("clientId"), newStatusCode, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                        wbo.setAttribute("status", "Ok");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 65:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                clientId = request.getParameter("clientId");
                String[] campaignIDsList = request.getParameterValues("campaignId");
                String[] referencesList = {};
                String[] referenceIDsList = {};
                String[] referenceTypesList = {};
                if (campaignIDsList != null) {
                    referencesList = new String[campaignIDsList.length];
                    referenceIDsList = new String[campaignIDsList.length];
                    referenceTypesList = new String[campaignIDsList.length];
                    int i = 0;
                    for (String id : campaignIDsList) {
                        if (request.getParameter("reference" + id) != null) {
                            referencesList[i] = request.getParameter("reference" + id);
                        } else {
                            referencesList[i] = "";
                        }
                        if (request.getParameter("businessObjType" + id) != null) {
                            referenceTypesList[i] = request.getParameter("businessObjType" + id);
                        } else {
                            referenceTypesList[i] = "";
                        }
                        if (request.getParameter("businessObjID" + id) != null) {
                            referenceIDsList[i] = request.getParameter("businessObjID" + id);
                        } else if (referenceTypesList[i].equalsIgnoreCase("Employee")
                                && request.getParameter("employeeID") != null) {
                            referenceIDsList[i] = request.getParameter("employeeID");
                        } else {
                            referenceIDsList[i] = "";
                        }
                        i++;
                    }
                }
                ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                if (clientCampaignMgr.saveCampaignsByClient(clientId, campaignIDsList, referencesList,
                        referenceIDsList, referenceTypesList, session, true)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "faild");
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 66:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                clientId = request.getParameter("clientId");
                String[] incentiveIDsList = request.getParameterValues("incentiveId");
                String[] incentiveDatesList = {};
                if (incentiveIDsList != null) {
                    incentiveDatesList = new String[incentiveIDsList.length];
                    int i = 0;
                    for (String id : incentiveIDsList) {
                        if (request.getParameter("incentiveDate" + id) != null) {
                            incentiveDatesList[i] = request.getParameter("incentiveDate" + id);
                        } else {
                            incentiveDatesList[i] = "";
                        }
                        i++;
                    }
                }
                ClientIncentiveMgr clientIncentiveMgr = ClientIncentiveMgr.getInstance();
                if (clientIncentiveMgr.saveIncentivesByClient(clientId, incentiveIDsList, incentiveDatesList, session)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "faild");
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 67:
                out = response.getWriter();
                clientNumber = request.getParameter("clientNumber");
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "No");
                empRelationMgr = EmpRelationMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                if (departmentWbo != null) {
                    wbo = clientMgr.getOnSingleKey("key2", clientNumber);
                    if (wbo != null) {
                        wbo.setAttribute("status", "Ok");
                    } else {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("status", "No");
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 68:
                out = response.getWriter();
                String phone = request.getParameter("phone");
                wbo = clientMgr.getOnSingleKey("key3", phone);
                if (wbo != null) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    if (wbo == null) {
                        wbo = new WebBusinessObject();
                    }
                    wbo.setAttribute("status", "No");
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 69:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                String tempID = clientMgr.checkClientPhoneExist(request.getParameter("mobile"));
                wbo.setAttribute("id", tempID != null ? tempID : "");
                wbo.setAttribute("status", tempID != null ? "Ok" : "No");
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 70:
                servedPage = "/docs/Adminstration/unhandled_client_list.jsp";
                if (request.getParameter("beginDate") != null || request.getParameter("endDate") != null || request.getParameter("createdBy") != null
                        || request.getParameter("campaignID") != null || request.getParameter("description") != null) {
                    clients = clientMgr.getUnHandledClients(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("createdBy"),
                            request.getParameter("campaignID"), request.getParameter("description"), request.getParameter("clientType"), request.getParameter("phoneNo"),
                            request.getParameter("projectID"), null, request.getParameter("preDepartmentID"),
                            (String) persistentUser.getAttribute("userId"));
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }
                userMgr = UserMgr.getInstance();
                UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
                request.setAttribute("usersList", userMgr.getAllActiveUsers());
                List<WebBusinessObject> distributionsList = new ArrayList<WebBusinessObject>();
                employees = new ArrayList<WebBusinessObject>();
                try {
                    distributionsList = userMgr.getUsersByGroup(securityUser.getDefaultNewClientDistribution());
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                try {
                    employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                campaignMgr = CampaignMgr.getInstance();
                try {
                    campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                    request.setAttribute("campaignsList", campaignsList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }
                // for top menu
                StringBuilder url = new StringBuilder("ClientServlet?op=unHandledClients&beginDate=");
                url.append(request.getParameter("beginDate") != null ? request.getParameter("beginDate") : "")
                        .append("&endDate=").append(request.getParameter("endDate") != null ? request.getParameter("endDate") : "")
                        .append("&createdBy=").append(request.getParameter("createdBy") != null ? request.getParameter("createdBy") : "")
                        .append("&campaignID=").append(request.getParameter("campaignID") != null ? request.getParameter("campaignID") : "")
                        .append("&description=").append(request.getParameter("description") != null ? request.getParameter("description") : "")
                        .append("&clientType=").append(request.getParameter("clientType") != null ? request.getParameter("clientType") : "")
                        .append("&phoneNo=").append(request.getParameter("phoneNo") != null ? request.getParameter("phoneNo") : "")
                        .append("&projectID=").append(request.getParameter("projectID") != null ? request.getParameter("projectID") : "")
                        .append("&preDepartmentID=").append(request.getParameter("preDepartmentID") != null ? request.getParameter("preDepartmentID") : "");
                String lastFilter2 = url.toString();
                session.setAttribute("lastFilter", lastFilter2);
                Hashtable topMenu2 = (Hashtable) request.getSession().getAttribute("topMenu");
                Vector tempVec2;
                if (topMenu2 != null && topMenu2.size() > 0) {
                    tempVec2 = new Vector();
                    tempVec2.add("lastFilter");
                    tempVec2.add(lastFilter2);
                    topMenu2.put("lastFilter", tempVec2);
                } else {
                    topMenu2 = new Hashtable();
                    tempVec2 = new Vector();
                    tempVec2.add("lastFilter");
                    tempVec2.add(lastFilter2);
                    topMenu2.put("lastFilter", tempVec2);
                }
                request.getSession().setAttribute("topMenu", topMenu2);
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
                ArrayList<WebBusinessObject> departments = new ArrayList<WebBusinessObject>();
                UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }
                } catch (Exception ex) {
                }
                request.setAttribute("usersIDsList", persistentSessionMgr.getLoggedUsers());
                request.setAttribute("distributionsList", distributionsList);
                request.setAttribute("salesEmployees", employees);
                request.setAttribute("departments", departments);
                request.setAttribute("page", servedPage);
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("description", request.getParameter("description"));
                request.setAttribute("createdBy", request.getParameter("createdBy"));
                request.setAttribute("campaignID", request.getParameter("campaignID"));
                request.setAttribute("clientType", request.getParameter("clientType"));
                request.setAttribute("phoneNo", request.getParameter("phoneNo"));
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("preDepartmentID", request.getParameter("preDepartmentID"));
                request.setAttribute("clients", clients);
                this.forwardToServedPage(request, response);
                break;
            case 71:
                servedPage = "/docs/Search/search_for_client_by_unit.jsp";
                String num = request.getParameter("num").trim();
                String projectID = request.getParameter("projectID");
                String searchType = request.getParameter("searchType");
                projectMgr = ProjectMgr.getInstance();
                List<WebBusinessObject> meetings = projectMgr.getMeetingProjects();
                List<WebBusinessObject> callResults = projectMgr.getCallResultsProjects();
                try {
                    ArrayList<WebBusinessObject> arrayApp = new ArrayList<>(projectMgr.getOnArbitraryKey("meeting", "key3"));
                    ArrayList<WebBusinessObject> dataArray = new ArrayList<>();
                    if (arrayApp.size() > 0) {
                        WebBusinessObject wboComplaint = (WebBusinessObject) arrayApp.get(0);
                        dataArray = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) wboComplaint.getAttribute("projectID"), "key2"));
                    }
                    managerWbo = userMgr.getManagerByEmployeeID(securityUser.getUserId());
                    String departmentID = "";
                    if (managerWbo != null) {
                        departmentID = (String) managerWbo.getAttribute("fullName");
                        ArrayList<WebBusinessObject> departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
                        if (departmentList.size() > 0) {
                            departmentID = (String) departmentList.get(0).getAttribute("projectID");
                        }
                    }
                    request.setAttribute("dataArray", dataArray);
                    request.setAttribute("departmentID", departmentID);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("meetings", meetings);
                request.setAttribute("callResults", callResults);
                projectMgr = ProjectMgr.getInstance();
                String projectName = "";
                if (projectID != null && !projectID.isEmpty()) {
                    projectName = (String) projectMgr.getOnSingleKey(projectID).getAttribute("projectName");
                }
                clientWbo = null;
                ArrayList<WebBusinessObject> clientLst = new ArrayList<WebBusinessObject>();
                try {
                    empRelationMgr = EmpRelationMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                    if (departmentWbo != null) {
                        userCompanyMgr = UserCompaniesMgr.getInstance();
                        userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", loggedUser.getAttribute("userId").toString());
                        if (userCompanyWbo != null) {
                            clientLst = clientMgr.getClientByNoAndCompany(num, projectName, searchType, (String) departmentWbo.getAttribute("projectID"), userCompanyWbo.getAttribute("companyID").toString());
                            setClientDetails(clientWbo, request);
                        } else {
                            clientLst = clientMgr.getClientLstByNo(num, projectName, searchType, (String) departmentWbo.getAttribute("projectID"));
                            setClientDetails(clientWbo, request);
                        }
                        ArrayList<WebBusinessObject> clientComLst = clientMgr.getClientByCom(num, projectName, searchType, (String) departmentWbo.getAttribute("projectID"));
                        for (int i = 0; i < clientComLst.size(); i++) {
                            clientLst.add(clientComLst.get(i));
                        }
                        setClientDetails(clientWbo, request);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                clientCampaignMgr = ClientCampaignMgr.getInstance();
                campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                ArrayList<WebBusinessObject> clientCampaignsList = new ArrayList<>();
                ArrayList<String> clientCampaignsIDs = clientCampaignMgr.getCampaignIDsByClientList(clientWbo != null ? (String) clientWbo.getAttribute("id") : "");
                for (int i = campaignsList.size() - 1; i >= 0; i--) {
                    if (clientCampaignsIDs.contains((String) campaignsList.get(i).getAttribute("id"))) {
                        clientCampaignsList.add(campaignsList.get(i));
                        campaignsList.remove(i);
                    }
                }
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("clientCampaignsList", clientCampaignsList);
                request.setAttribute("clientLst", clientLst);
                this.forward("SearchServlet?op=getSearchClientsByUnit", request, response);
                break;
            case 72:
                servedPage = "/docs/Adminstration/client_update.jsp";
                mainRegion = new Vector<WebBusinessObject>();
                try {
                    mainRegion = projectMgr.getOnArbitraryKey("garea", "key6");
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("mainRegion", mainRegion);
                tradeMgr = TradeMgr.getInstance();
                clientId = request.getParameter("clientId");
                try {
                    request.setAttribute("jobs", new ArrayList<WebBusinessObject>(tradeMgr.getOnArbitraryKey("1", "key3")));
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey(clientId));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    request.setAttribute("seasonsList", new ArrayList<>(seasonMgr.getOnArbitraryKeyOracle("1", "key2")));
                } catch (Exception ex) {
                    request.setAttribute("seasonsList", new ArrayList<>());
                }
                this.forward(servedPage, request, response);
                break;
            case 73:
                tradeMgr = TradeMgr.getInstance();
                String clientID = request.getParameter("clientId");
                waUser = (WebBusinessObject) session.getAttribute("loggedUser");
                userCompanyMgr = UserCompaniesMgr.getInstance();
                userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", waUser.getAttribute("userId").toString());
                try {
                    clientWbo = clientMgr.getOnSingleKey(clientID);
                    clientWbo.setAttribute("name", request.getParameter("clientName"));
                    clientWbo.setAttribute("address", request.getParameter("address"));
                    clientWbo.setAttribute("gender", request.getParameter("gender"));
                    clientWbo.setAttribute("phone", request.getParameter("phone"));
                    clientWbo.setAttribute("matiralStatus", request.getParameter("matiralStatus"));
                    clientWbo.setAttribute("mobile", request.getParameter("mobile"));
                    clientWbo.setAttribute("option3", request.getParameter("dialedNumber"));
                    clientWbo.setAttribute("email", request.getParameter("email"));
                    clientWbo.setAttribute("clientSsn", request.getParameter("clientSsn"));
                    clientWbo.setAttribute("partner", request.getParameter("partner"));
                    clientWbo.setAttribute("job", request.getParameter("job"));
                    clientWbo.setAttribute("workOut", "0");
                    if (userCompanyWbo != null) {
                        clientWbo.setAttribute("kindred", userCompanyWbo.getAttribute("companyID").toString());
                    } else {
                        clientWbo.setAttribute("kindred", "0");
                    }
                    clientWbo.setAttribute("region", request.getParameter("newregion") != null ? request.getParameter("newregion") : " ");
                    clientWbo.setAttribute("birthDate", request.getParameter("birthDate"));
                    request.setAttribute("jobs", new ArrayList<WebBusinessObject>(tradeMgr.getOnArbitraryKey("1", "key3")));
                    clientWbo.setAttribute("description", request.getParameter("description"));
                    clientWbo.setAttribute("branch", request.getParameter("clientBranch"));
                    clientWbo.setAttribute("interPhone", request.getParameter("interPhone"));
                    if (clientMgr.updateClient(clientWbo)) {
                        loggerWbo = new WebBusinessObject();
                        loggerWbo.setAttribute("objectXml", clientWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", clientID);
                        loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", request.getParameter("clientName"));
                        loggerWbo.setAttribute("loggerMessage", "Client Updated");
                        loggerWbo.setAttribute("eventName", "Update");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "3");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        loggerMgr.saveObject(loggerWbo);
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }
                    request.setAttribute("clientWbo", clientWbo);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    request.setAttribute("seasonsList", new ArrayList<>(seasonMgr.getOnArbitraryKeyOracle("1", "key2")));
                } catch (Exception ex) {
                    request.setAttribute("seasonsList", new ArrayList<>());
                }
                mainRegion = new Vector<WebBusinessObject>();
                try {
                    mainRegion = projectMgr.getOnArbitraryKey("garea", "key6");
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("mainRegion", mainRegion);
                servedPage = "/docs/Adminstration/client_update.jsp";
                this.forward(servedPage, request, response);
                break;
            case 74:
                if (request.getParameter("up") != null && ((request.getParameter("up")).toString()).equals("1")) {
                    email = request.getParameter("nwEmail");
                    clientID = request.getParameter("nwClntEmail");
                    if (clientMgr.upEmail(email, clientID)) {
                        request.setAttribute("up", "1");
                    } else {
                        request.setAttribute("up", "0");
                    }
                }
                String forPopup = request.getParameter("forPopup");
                tradeMgr = TradeMgr.getInstance();
                clientStatus = request.getParameter("clientStatus");
                clientProject = request.getParameter("clientProject");
                clientArea = request.getParameter("clientArea");
                clientJob = request.getParameter("clientJob");
                String fromDateS = request.getParameter("fromDate");
                String toDateS = request.getParameter("toDate");
                String interCode = request.getParameter("interCode");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                dateParser = new DateParser();
                String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                if (clientStatus == null) {
                    clientStatus = "12";
                }
                empRelationMgr = EmpRelationMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                String clientClass = request.getParameter("mainClientRate");
                clients = new ArrayList<WebBusinessObject>();
                if (request.getParameter("searchType") != null && request.getParameter("searchType").equals("birthday")) {
                    clients = clientMgr.GetClientsBirthDays(clientStatus, clientProject, clientArea, clientJob, null);
                    request.setAttribute("searchType", request.getParameter("searchType"));
                }else if (request.getParameter("searchType") != null && request.getParameter("searchType").equals("email")) {
                    clients = clientMgr.GetClientsByEmail(clientStatus, clientProject, clientArea, clientJob, null);
                    request.setAttribute("searchType", request.getParameter("searchType"));
                } else if (fromDateS != null && toDateS != null) {
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    if (departmentWbo != null) {
                        clients = clientMgr.getAllClientsComments( clientJob, fromDateD, toDateD);
                    } else {
                        clients = new ArrayList<WebBusinessObject>();
                    }
                }
                servedPage = "/docs/Adminstration/client_list_detailed.jsp";
                request.setAttribute("page", servedPage);
                data2 = Tools.getJSONArrayAsString2(clients);
                request.setAttribute("data", clients);
                request.setAttribute("mainClientRate", request.getParameter("mainClientRate"));
                request.setAttribute("data2", data2);
                try {
                    request.setAttribute("clientStatusList", clientMgr.getClientStatusList());
                    ArrayList<WebBusinessObject> areaList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("rgns", "key6"));
                    for (int i = areaList.size() - 1; i >= 0; i--) {
                        if (((String) areaList.get(i).getAttribute("mainProjId")).equalsIgnoreCase("0")) {
                            areaList.remove(areaList.get(i));
                        }
                    }
                    request.setAttribute("areaList", areaList);
                    ArrayList<WebBusinessObject> projectList = new ArrayList<WebBusinessObject>();
                    try {
                        projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4"));
                    } catch (SQLException ex) {
                        logger.error(ex);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("projectList", projectList);
                    request.setAttribute("jobList", new ArrayList<WebBusinessObject>(CampaignMgr.getInstance().getAllCampaignList()));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                UserGroupConfigMgr userGroupCongMgr = UserGroupConfigMgr.getInstance();
                GroupMgr groupMgr = GroupMgr.getInstance();
                ArrayList<WebBusinessObject> groups = new ArrayList<>();
                try {
                    ArrayList<WebBusinessObject> userGroups = new ArrayList<>(userGroupCongMgr.getOnArbitraryKey(loggedUser.getAttribute("userId").toString(), "key2"));
                    if (userGroups.size() > 0 && userGroups != null) {
                        for (WebBusinessObject userGroupsWbo : userGroups) {
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groups.add(groupWbo);
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                lastFilter = (new StringBuilder("ClientServlet?op=getClientsWithDetails&clientStatus=").append(clientStatus)
                        .append("&clientProject=").append(clientProject).append("&clientArea=").append(clientArea)
                        .append("&clientJob=").append(clientJob)).toString();
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
                request.setAttribute("groupsList", groups);
                request.setAttribute("groupID", request.getParameterValues("groupID") != null ? Tools.concatenation(request.getParameterValues("groupID"), ",") : "");
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("selectedStatus", clientStatus);
                request.setAttribute("selectedProject", clientProject);
                request.setAttribute("selectedArea", clientArea);
                request.setAttribute("selectedJob", clientJob);
                request.setAttribute("reportType", "detailed");
                request.setAttribute("interCode", interCode);
                String mainClientRate = request.getParameter("mainClientRate");
                ArrayList<WebBusinessObject> ratesList = new ArrayList<WebBusinessObject>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                    request.setAttribute("ratesList", ratesList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("ratesList", new ArrayList<WebBusinessObject>());
                }
                request.setAttribute("ratesList", ratesList);
                if (forPopup == null) {
                    this.forwardToServedPage(request, response);
                } else {
                    request.setAttribute("forPopup", "true");
                    this.forward(servedPage, request, response);
                }
                break;
            case 75:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                String oldClientID = request.getParameter("oldClientID");
                try {
                    if (clientMgr.saveClientData5(request, session, persistentUser,oldClientID)) {
                        clientWbo = clientMgr.getOnSingleKey("key2", (String) request.getAttribute("clientNo"));
                        AutoPilotFeature autoPilotFeature = new AutoPilotFeature();
                        autoPilotFeature.autoPilot((String) clientWbo.getAttribute("id"), (String) persistentUser.getAttribute("userId"),
                                session, persistentUser, false, "Recommended");
                        WebBusinessObject oldClientWbo = clientMgr.getOnSingleKey(oldClientID);
                        //For logging Client Insertion
                        loggerWbo = new WebBusinessObject();
                        loggerWbo.setAttribute("objectXml", clientWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", (String) clientWbo.getAttribute("id"));
                        loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", (String) clientWbo.getAttribute("name"));
                        loggerWbo.setAttribute("loggerMessage", "Client Inserted");
                        loggerWbo.setAttribute("eventName", "Insert");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "4");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        loggerMgr.saveObject(loggerWbo);
                        //Save Interested Product from Old Client
                        projectMgr = ProjectMgr.getInstance();
                        WebBusinessObject projectWbo = projectMgr.getProjectForClient((String) oldClientWbo.getAttribute("id"));
                        if (projectWbo != null) {
                            request.setAttribute("productId", projectWbo.getAttribute("projectID"));
                            request.setAttribute("productCategoryId", projectWbo.getAttribute("mainProjId"));
                            String productCategoryName = "";
                            wbo = projectMgr.getOnSingleKey((String) projectWbo.getAttribute("mainProjId"));
                            if (wbo != null) {
                                productCategoryName = (String) wbo.getAttribute("projectName");
                            } else {
                                wbo = new WebBusinessObject();
                            }
                            request.setAttribute("productName", projectWbo.getAttribute("name"));
                            request.setAttribute("productCategoryName", productCategoryName);
                            request.setAttribute("budget", "UL");
                            request.setAttribute("period", "سنه");
                            request.setAttribute("paymentSystem", "فورى");
                            request.setAttribute("notes", "UL");
                            request.setAttribute("clientId", (String) clientWbo.getAttribute("id"));
                            clientProductMgr = ClientProductMgr.getInstance();
                            clientProductMgr.saveInterestedProduct(request, session);
                        }
                        //
                        wbo.setAttribute("status", "No");
                        clientCampaignMgr = ClientCampaignMgr.getInstance();
                        campaignMgr = CampaignMgr.getInstance();
                        campaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("Customer Referal", "key5"));
                        if (campaignsList.size() > 0) {
                            String[] campaignIDs = {((String) campaignsList.get(0).getAttribute("id"))};
                            String[] campaignReferences = {(String) oldClientWbo.getAttribute("name")};
                            String[] businessObjIDs = {oldClientID};
                            String[] businessObjTypes = {"Customer"};
                            if (clientCampaignMgr.saveCampaignsByClient((String) clientWbo.getAttribute("id"), campaignIDs, campaignReferences,
                                    businessObjIDs, businessObjTypes, session, true)) {
                                wbo.setAttribute("status", "Ok");
                            } else {
                                wbo.setAttribute("status", "No");
                            }
                        }
                    } else {
                        wbo.setAttribute("status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (SQLException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 76:
                out = response.getWriter();
                clientWbo = new WebBusinessObject();
                num = request.getParameter("num");
                projectID = "";//request.getParameter("projectID");
                projectMgr = ProjectMgr.getInstance();
                projectName = "";
                if (projectID != null && !projectID.isEmpty()) {
                    projectName = (String) projectMgr.getOnSingleKey(projectID).getAttribute("projectName");
                }
                try {
                    empRelationMgr = EmpRelationMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                    if (departmentWbo != null) {
                        clientWbo = clientMgr.getClientByNo(num, projectName, "searchByPhone", (String) departmentWbo.getAttribute("projectID"));
                    }
                    if (clientWbo != null && clientWbo.getAttribute("id") != null) {
                        clientWbo.setAttribute("status", "ok");
                        clientWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                    } else {
                        if (clientWbo == null) {
                            clientWbo = new WebBusinessObject();
                        }
                        clientWbo.setAttribute("status", "fail");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(clientWbo));
                break;
            case 77:
                servedPage = "/docs/Adminstration/ContractorsList.jsp";
                ArrayList<WebBusinessObject> arrayOfContractors = clientMgr.getListOfContractors();
                request.setAttribute("contractors", arrayOfContractors);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 78:
                servedPage = "/docs/customer/distribute_client.jsp";
                clientId = request.getParameter("clientId");
                clientName = request.getParameter("clientName");
                String employeeId = request.getParameter("employeeId");
                String requestType = request.getParameter("requestType");
                issueMgr = IssueMgr.getInstance();
                String issueId = null;
                String subject,
                 notes;
                if (requestType.equals("")) {
                    comment = "عميل جديد";
                    subject = "عميل جديد";
                    notes = "عميل جديد";
                } else if (requestType == null) {
                    comment = "عميل جديد";
                    subject = "عميل جديد";
                    notes = "عميل جديد";
                } else {
                    comment = new String(requestType);
                    subject = new String(requestType);
                    notes = new String(requestType);
                }
                boolean savedComplete = false;
                //Begin Automatically generate Record Number
                clientWbo = clientMgr.getOnSingleKey(clientId);
                try {
                    if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                        String callStatus = null;
                        String callType = null;
                        if (securityUser.getCallcenterMode().equals("2")) {
                            callStatus = "incoming";
                            callType = "call";
                        } else if (securityUser.getCallcenterMode().equals("3")) {
                            callStatus = "out_call";
                            callType = "call";
                        } else if (securityUser.getCallcenterMode().equals("4")) {
                            callStatus = "incoming";
                            callType = "meeting";
                        } else if (securityUser.getCallcenterMode().equals("5")) {
                            callStatus = "out_call";
                            callType = "meeting";
                        } else if (securityUser.getCallcenterMode().equals("6")) {
                            callStatus = "incoming";
                            callType = "internet";
                        }
                        issueId = issueMgr.saveCallDataAuto((String) clientWbo.getAttribute("id"), callType, callStatus, session, "issue", persistentUser);
                        if (issueId != null && !issueId.equals("")) {
                            savedComplete = true;
                            WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                            request.setAttribute("issueId", issueId);
                            request.setAttribute("businessId", issueWbo.getAttribute("businessID"));
                        }
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    savedComplete = false;
                    logger.error(ex);
                }
                if (!securityUser.getDefaultNewClientDistribution().equals("-1") && issueId != null) {
                    try {
                        savedComplete &= (clientComplaintsMgr.createMailInBox(employeeId, issueId, "2", null, comment, subject, notes, persistentUser) != null);
                    } catch (NoUserInSessionException | SQLException ex) {
                        savedComplete = false;
                        logger.error(ex);
                    }
                }
                employees = new ArrayList<WebBusinessObject>();
                try {
                    if (securityUser.isCanRunCampaignMode()) {
                        employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
                    } else {
                        employees = userMgr.getUsersByProjectAndGroup(securityUser.getSiteId(), CRMConstants.SALES_MARKTING_GROUP_ID);
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                clientId = (String) clientWbo.getAttribute("id");
                clientComplaintsMgr.updateClientComplaintsType();
                request.setAttribute("employees", employees);
                request.setAttribute("employeeId", employeeId);
                request.setAttribute("employeeName", userMgr.getByKeyColumnValue(employeeId, "key3"));
                request.setAttribute("clientId", clientId);
                request.setAttribute("clientName", clientName);
                request.setAttribute("status", (savedComplete) ? "ok" : "no");
                request.setAttribute("redirect", "true");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 79:
                servedPage = "/docs/Adminstration/client_communications.jsp";
                clientId = request.getParameter("clientId");
                ClientCommunicationMgr clientCommunicationMgr = ClientCommunicationMgr.getInstance();
                try {
                    request.setAttribute("emailsList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle(clientId, "key2", "email", "key3")));
                    request.setAttribute("phonesList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle(clientId, "key2", "phone", "key3")));
                    request.setAttribute("datesList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle(clientId, "key2", "date", "key3")));
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey(clientId));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                this.forward(servedPage, request, response);
                break;
            case 80:
                WebBusinessObject communicationWbo = new WebBusinessObject();
                clientCommunicationMgr = ClientCommunicationMgr.getInstance();
                clientId = request.getParameter("clientId");
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                String PhoneNum = request.getParameter("value");
                boolean exist = false;
                if (clientId != null && !clientId.equals("")) {
                    communicationWbo.setAttribute("clientId", clientId);
                    communicationWbo.setAttribute("communicationValue", request.getParameter("value"));
                    communicationWbo.setAttribute("communicationType", request.getParameter("type"));
                    communicationWbo.setAttribute("option1", request.getParameter("name") != null ? request.getParameter("name") : "");
                    String CommType = (String) request.getParameter("type");
                    if (CommType.equals("phone")) {
                        exist = IsExistNumforClient(loggedUser, request.getParameter("value"));
                    } else if (CommType.equals("email")) {
                        exist = IsExistEmailforClient(loggedUser, request.getParameter("value"));
                    }
                    if (exist) {
                        request.setAttribute("status1", "exist");
                        request.setAttribute("type1", request.getParameter("type"));

                    } else {

                        if (clientCommunicationMgr.saveObject(communicationWbo, loggedUser)) {
                            communicationWbo.setAttribute("status", "ok");
                        } else {
                            communicationWbo.setAttribute("status", "fail");
                        }
                    }
                } else {
                    communicationWbo.setAttribute("status", "fail");
                }

                try {

                    request.setAttribute("emailsList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle(clientId, "key2", "email", "key3")));
                    request.setAttribute("phonesList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle(clientId, "key2", "phone", "key3")));
                    request.setAttribute("datesList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle(clientId, "key2", "date", "key3")));
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey(clientId));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                servedPage = "/docs/Adminstration/client_communications.jsp";
                this.forward(servedPage, request, response);
                break;
            case 81:
                out = response.getWriter();
                communicationWbo = new WebBusinessObject();
                String id = request.getParameter("id");
                if (id != null && !id.equals("")) {
                    clientCommunicationMgr = ClientCommunicationMgr.getInstance();
                    if (clientCommunicationMgr.deleteOnSingleKey(id)) {
                        communicationWbo.setAttribute("status", "ok");
                    } else {
                        communicationWbo.setAttribute("status", "fail");
                    }
                } else {
                    communicationWbo.setAttribute("status", "fail");
                }
                out.write(Tools.getJSONObjectAsString(communicationWbo));
                break;
            case 82:
                servedPage = "/docs/Adminstration/unhandled_client_list.jsp";
                if (request.getParameter("beginDate") != null || request.getParameter("endDate") != null || request.getParameter("createdBy") != null
                        || request.getParameter("campaignID") != null || request.getParameter("description") != null) {
                    clients = clientMgr.getUnHandledClients(request.getParameter("beginDate"),
                            request.getParameter("endDate"), request.getParameter("createdBy"), request.getParameter("campaignID"),
                            request.getParameter("description"), null, null, null, null, null, null);
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }
                userMgr = UserMgr.getInstance();
                userGroupMgr = UserGroupMgr.getInstance();
                request.setAttribute("usersList", new ArrayList<WebBusinessObject>(userMgr.getCashedTable()));
                distributionsList = new ArrayList<WebBusinessObject>();
                try {
                    distributionsList = new ArrayList<WebBusinessObject>(userGroupMgr.getOnArbitraryKeyOracle(securityUser.getDefaultNewClientDistribution(), "key"));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                campaignMgr = CampaignMgr.getInstance();
                try {
                    campaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
                    campaignsList.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
                    request.setAttribute("campaignsList", campaignsList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("distributionsList", distributionsList);
                request.setAttribute("page", servedPage);
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("description", request.getParameter("description"));
                request.setAttribute("createdBy", request.getParameter("createdBy"));
                request.setAttribute("campaignID", request.getParameter("campaignID"));
                request.setAttribute("clients", clients);
                this.forwardToServedPage(request, response);
                break;
            case 83:
                servedPage = "/docs/Adminstration/list_distributed_clients.jsp";
                employeeView2Mgr = EmployeeView2Mgr.getInstance();
                ArrayList<WebBusinessObject> clientsList;
                if (request.getParameter("beginDate") != null || request.getParameter("endDate") != null || request.getParameter("sourceID") != null) {
                    clientsList = employeeView2Mgr.getDistributedClients((String) request.getParameter("sourceID"), request.getParameter("beginDate"), request.getParameter("endDate")); // for all user use empty string
                } else {
                    clientsList = new ArrayList<WebBusinessObject>();
                }
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("sourceID", request.getParameter("sourceID"));
                request.setAttribute("usersList", new ArrayList<>(userMgr.getCashedTable()));
                request.setAttribute("clientsList", clientsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 84:
                clientId = new String();
                servedPage = "/docs/Adminstration/client_details.jsp";
//                if (request.getParameter("clientComplaintID") != null) { // change status of client complaint
//                    wbo = new WebBusinessObject();
//                    wbo.setAttribute("parentId", request.getParameter("issueID"));
//                    wbo.setAttribute("businessObjectId", request.getParameter("clientComplaintID"));
//                    wbo.setAttribute("statusCode", "3");
//                    wbo.setAttribute("objectType", "client_complaint");
//                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
//                    wbo.setAttribute("issueTitle", "UL");
//                    wbo.setAttribute("statusNote", "UL");
//                    wbo.setAttribute("cuseDescription", "UL");
//                    wbo.setAttribute("actionTaken", "UL");
//                    wbo.setAttribute("preventionTaken", "UL");
//                    try {
//                        issueStatusMgr = IssueStatusMgr.getInstance();
//                        issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent());
//                    } catch (SQLException ex) {
//                        logger.error(ex);
//                    }
//                }
                try {
                    clientId = request.getParameter("clientId");
                    if (clientId == null) {
                        clientId = (String) request.getAttribute("clientId");
                    }
                    ArrayList<WebBusinessObject> intersLst = new ArrayList<WebBusinessObject>();
                    clientProductMgr = ClientProductMgr.getInstance();
                    intersLst = new ArrayList<WebBusinessObject>(clientProductMgr.getClientInterests(clientId));
                    clientWbo = clientMgr.getOnSingleKey(clientId);
                    setClientDetails(clientWbo, request);
                    request.setAttribute("intersLst", intersLst);
                    request.setAttribute("showHeader", "true");
                    request.setAttribute("clientSeasonWbo", seasonMgr.getOnSingleKey((String) clientWbo.getAttribute("option3")));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                projectMgr = ProjectMgr.getInstance();
                meetings = projectMgr.getMeetingProjects();
                callResults = projectMgr.getCallResultsProjects();
                try {
                    ArrayList<WebBusinessObject> arrayApp = new ArrayList<>(projectMgr.getOnArbitraryKey("meeting", "key3"));
                    ArrayList<WebBusinessObject> dataArray = new ArrayList<>();
                    if (arrayApp.size() > 0) {
                        WebBusinessObject wboComplaint = (WebBusinessObject) arrayApp.get(0);
                        dataArray = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) wboComplaint.getAttribute("projectID"), "key2"));
                    }
                    managerWbo = userMgr.getManagerByEmployeeID(securityUser.getUserId());
                    String departmentID = "";
                    if (managerWbo != null) {
                        departmentID = (String) managerWbo.getAttribute("fullName");
                        ArrayList<WebBusinessObject> departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
                        if (departmentList.size() > 0) {
                            departmentID = (String) departmentList.get(0).getAttribute("projectID");
                        }
                    }
                    request.setAttribute("dataArray", dataArray);
                    request.setAttribute("departmentID", departmentID);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                WebBusinessObject clientRateWbo = ClientRatingMgr.getInstance().getOnSingleKey("key1", request.getParameter("clientId"));
                request.setAttribute("rateWbo", clientRateWbo != null ? projectMgr.getOnSingleKey((String) clientRateWbo.getAttribute("rateID")) : null);
                request.setAttribute("meetings", meetings);
                request.setAttribute("callResults", callResults);
                clientCampaignMgr = ClientCampaignMgr.getInstance();
                campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                clientCampaignsIDs = clientCampaignMgr.getCampaignIDsByClientList(request.getParameter("clientId"));
                clientCampaignsList = new ArrayList<>();
                for (int i = campaignsList.size() - 1; i >= 0; i--) {
                    if (clientCampaignsIDs.contains((String) campaignsList.get(i).getAttribute("id"))) {
                        ArrayList<WebBusinessObject> clntCmpLst = new ArrayList<WebBusinessObject>();
                        try {
                            clntCmpLst = clientCampaignMgr.getCampaignWboByClientList(clientId, campaignsList.get(i).getAttribute("id").toString());
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (!clntCmpLst.isEmpty()) {
                            campaignsList.get(i).setAttribute("clntCmpCreationTime", clntCmpLst.get(0).getAttribute("creationTime"));
                            campaignsList.get(i).setAttribute("createdByName", clntCmpLst.get(0).getAttribute("createdByName"));
                            campaignsList.get(i).setAttribute("clntCmpID", clntCmpLst.get(0).getAttribute("clntCmpID"));
                        }
                        clientCampaignsList.add(campaignsList.get(i));
                        campaignsList.remove(i);
                    }
                }
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("clientCampaignsList", clientCampaignsList);
                ArrayList callResLst = new ArrayList<>();
                try {
                    callResLst = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("call-result", "key4"));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("callResLst", callResLst);
                String issueID = request.getParameter("issueID");
                request.setAttribute("issueID", issueID);
                String button = request.getParameter("button");
                request.setAttribute("button", button);
                try {
                    request.setAttribute("questionsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOrdered("SUR", "key4", "key")));
                } catch (Exception ex) {
                    request.setAttribute("questionsList", new ArrayList<>());
                }
                try {
                    request.setAttribute("clientSurveyList", new ArrayList<>(ClientSurveyMgr.getInstance().getOnArbitraryKeyOrdered(request.getParameter("clientId"), "key1", "key2")));
                } catch (Exception ex) {
                    request.setAttribute("clientSurveyList", new ArrayList<>());
                }
                request.setAttribute("usersList", userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId")));
                request.setAttribute("lockWbo", clientMgr.getClientUserLocked(request.getParameter("clientId")));
                if (request.getParameter("showHeader") == null) {
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } else {
                    this.forward(servedPage, request, response);
                }
                break;
            case 85:
                servedPage = "/docs/Adminstration/update_contractor.jsp";
                String contractorId = request.getParameter("clientID");
                if (contractorId != null) {
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey(contractorId));
                }
                tradeMgr = TradeMgr.getInstance();
                regionMgr = RegionMgr.getInstance();
                regions = regionMgr.getCashedTable();
                tradeV = new Vector();
                tradeMgr = TradeMgr.getInstance();
                try {
                    tradeV = tradeMgr.getTradeByType("2");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("jobs", jobs);
                request.setAttribute("regions", regions);
                request.setAttribute("tradeV", tradeV);
                this.forwardToServedPage(request, response);
                break;
            case 86:
                servedPage = "/docs/Adminstration/update_contractor.jsp";
                contractorId = request.getParameter("clientID");
                try {
                    if (clientMgr.updateCompany(request)) {
                        request.setAttribute("Status", "ok");
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (contractorId != null) {
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey(contractorId));
                }
                tradeMgr = TradeMgr.getInstance();
                regionMgr = RegionMgr.getInstance();
                regions = regionMgr.getCashedTable();
                tradeV = new Vector();
                tradeMgr = TradeMgr.getInstance();
                try {
                    tradeV = tradeMgr.getTradeByType("2");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                jobs = new Vector();
                try {
                    jobs = tradeMgr.getOnArbitraryKey("1", "key3");
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("jobs", jobs);
                request.setAttribute("regions", regions);
                request.setAttribute("tradeV", tradeV);
                this.forwardToServedPage(request, response);
                break;
            case 87:
                clientMgr = ClientMgr.getInstance();
                clientId = request.getParameter("clientID");
                clientWbo = (WebBusinessObject) clientMgr.getOnSingleKey(clientId);
                clientName = request.getParameter("clientName");
                clientNo = request.getParameter("clientNo");
                servedPage = "/docs/Adminstration/confirm_delete_contractor.jsp";
                request.setAttribute("clientWbo", clientWbo);
                request.setAttribute("clientId", clientId);
                request.setAttribute("clientName", clientName);
                request.setAttribute("clientNo", clientNo);
                request.setAttribute("canDelete", /*clientMgr.canDelete(clientId)*/ true);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 89:
                servedPage = "/docs/Adminstration/clients_rules.jsp";
                String[] statusTitles = new String[2];
                statusTitles[0] = "11"; // For Customer
                statusTitles[1] = "99"; // For None Customer (Lead, Opportunity, Contact)
                projectMgr = ProjectMgr.getInstance();
                ClientRuleMgr clientRuleMgr = ClientRuleMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> departmentsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("div", "key6"));
                    if (request.getParameter("toSave") != null) {
                        clientRuleMgr.deleteAllRules();
                        for (String statusTitle : statusTitles) {
                            for (WebBusinessObject department : departmentsList) {
                                if (request.getParameter(statusTitle + "_" + ((String) department.getAttribute("projectID"))) != null) {
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("departmentID", department.getAttribute("projectID"));
                                    wbo.setAttribute("clientStatus", statusTitle);
                                    if (clientRuleMgr.saveObject(wbo, loggedUser)) {
                                        request.setAttribute("status", "ok");
                                    } else {
                                        request.setAttribute("status", "fail");
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception ex) {
                }
                try {
                    ArrayList<WebBusinessObject> clientsRules = clientRuleMgr.getClientsRules(statusTitles);
                    request.setAttribute("clientsRules", clientsRules);
                    request.setAttribute("statusTitles", statusTitles);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 90:
                wbo = new WebBusinessObject();
                try {
                    if (appointmentMgr.saveFollowUpAppointment(request, session, (String) persistentUser.getAttribute("userId"))) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                    wbo.setAttribute("status", "no");
                }
                WebBusinessObject clientRateMain = projectMgr.getOnSingleKey("key3", "CR");
                ratesList = new ArrayList<>();
                if (clientRateMain != null) {
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) clientRateMain.getAttribute("projectID"), "key2"));
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 91:
                servedPage = "/docs/Adminstration/list_non_followers_clients.jsp";
                String period = request.getParameter("period") != null ? request.getParameter("period") : "30";
                String currentOwnerID = request.getParameter("currentOwnerID") != null ? request.getParameter("currentOwnerID") : "";
                String rateID = request.getParameter("rateID");
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                ArrayList<WebBusinessObject> prvType = securityUser.getComplaintMenuBtn();
                ArrayList<String> privilegesList = new ArrayList<>();
                for (WebBusinessObject wboTemp : prvType) {
                    if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                        privilegesList.add((String) wboTemp.getAttribute("prevCode"));
                    }
                }
                ArrayList<WebBusinessObject> usersArrList = new ArrayList<>();
                if (!privilegesList.contains("ALL_USERS")) {
                    if (currentOwnerID.isEmpty()) {
                        currentOwnerID = (String) persistentUser.getAttribute("userId");
                    }
                    usersArrList.add(userMgr.getOnSingleKey((String) persistentUser.getAttribute("userId")));
                    usersArrList.addAll(userMgr.getEmployeesByManager((String) persistentUser.getAttribute("userId")));
                } else {
                    usersArrList.addAll(userMgr.getUsersInMyReportDepartments((String) persistentUser.getAttribute("userId")));
                }
                clientRateMain = projectMgr.getOnSingleKey("key3", "CR");
                ratesList = new ArrayList<>();
                if (clientRateMain != null) {
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) clientRateMain.getAttribute("projectID"), "key2"));
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                if (currentOwnerID.isEmpty() && !usersArrList.isEmpty()) {
                    currentOwnerID = (String) usersArrList.get(0).getAttribute("userId");
                }
                if ((rateID == null || rateID.isEmpty()) && !ratesList.isEmpty()) {
                    rateID = (String) ratesList.get(0).getAttribute("projectID");
                }
                clientsList = clientMgr.getNonFollowersClients(period, currentOwnerID, rateID);
                request.setAttribute("clientsList", clientsList);
                request.setAttribute("ratesList", ratesList);
                request.setAttribute("usersList", usersArrList);
                request.setAttribute("currentOwnerID", currentOwnerID);
                request.setAttribute("rateID", rateID);
                request.setAttribute("period", period);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 92:
                out = response.getWriter();
                clientId = request.getParameter("clientId");
                wbo = new WebBusinessObject();
                appointmentMgr = AppointmentMgr.getInstance();
                try {
                    ArrayList appointmentsList = new ArrayList(appointmentMgr.getOnArbitraryKeyOracle(clientId, "key1"));
                    wbo.setAttribute("count", appointmentsList.size());
                } catch (Exception ex) {
                    Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                }
                out.print(Tools.getJSONObjectAsString(wbo));
                break;
            case 93:
                servedPage = "/docs/client/my_unhandled_client_list.jsp";
                if (request.getParameter("beginDate") != null || request.getParameter("endDate") != null
                        || request.getParameter("description") != null || request.getParameter("clientTyp") != null) {
                    clients = clientMgr.getUnHandledClients(request.getParameter("beginDate"),
                            request.getParameter("endDate"), (String) loggedUser.getAttribute("userId"), null, request.getParameter("description"), null, request.getParameter("phoneNo"), null, request.getParameter("clientTyp"), null, null);
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }
                userMgr = UserMgr.getInstance();
                request.setAttribute("usersList", new ArrayList<WebBusinessObject>(userMgr.getCashedTable()));
                distributionsList = new ArrayList<WebBusinessObject>();
                try {
                    distributionsList = userMgr.getUsersByGroup(securityUser.getDefaultNewClientDistribution());
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                employees = new ArrayList<WebBusinessObject>();
                try {
                    if (securityUser.getDistributionGroup() != null && !securityUser.getDistributionGroup().isEmpty()) {
                        employees = userMgr.getUsersByGroup(securityUser.getDistributionGroup());
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                try {
                    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }
                request.setAttribute("usersIDsList", persistentSessionMgr.getLoggedUsers());
                request.setAttribute("distributionsList", distributionsList);
                request.setAttribute("salesEmployees", employees);
                request.setAttribute("page", servedPage);
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("description", request.getParameter("description"));
                request.setAttribute("phoneNo", request.getParameter("phoneNo"));
                request.setAttribute("clientTyp", request.getParameter("clientTyp"));
                request.setAttribute("clients", clients);
                this.forwardToServedPage(request, response);
                break;
            case 94:
                servedPage = "/docs/Adminstration/list_distributed_clients.jsp";
                employeeView2Mgr = EmployeeView2Mgr.getInstance();
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                clientsList = employeeView2Mgr.getDistributedClients((String) loggedUser.getAttribute("userId"), request.getParameter("beginDate"), request.getParameter("endDate"));
                UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                ArrayList<WebBusinessObject> userGroupsLst = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> usersLst = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> allUsersLst = new ArrayList<WebBusinessObject>();
                try {
                    userGroupsLst = new ArrayList<WebBusinessObject>(UserDepartmentConfigMgr.getInstance().getOnArbitraryDoubleKey((String) loggedUser.getAttribute("userId"), "key2","1", "key3"));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                for (int i = 0; i < userGroupsLst.size(); i++) {
                    try {
                        usersLst = new ArrayList<WebBusinessObject>(userMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key"));
                        for (int j = 0; j < usersLst.size(); j++) {
                            allUsersLst.add(usersLst.get(j));
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
                }
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("searchType", "myClient");
                request.setAttribute("clientsList", clientsList);
                request.setAttribute("usersList", allUsersLst);
                request.setAttribute("sourceID", (String) request.getParameter("sourceID"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 95:
                servedPage = "/docs/campaign/show_campaign_list.jsp";
                clientCampaignsList = new ArrayList<WebBusinessObject>();
                try {
                    clientId = request.getParameter("clientId");
                    request.setAttribute("clientId", clientId);
                    if (clientId != null && !clientId.isEmpty()) {
                        campaignMgr = CampaignMgr.getInstance();
                        clientCampaignMgr = ClientCampaignMgr.getInstance();
                        clientCampaignsList = clientCampaignMgr.getCampaignsByClientList(clientId);
                        HashMap<String, ArrayList> campaignToolsList = new HashMap<String, ArrayList>();
                        RecordSeasonMgr recordSeasonMgr = RecordSeasonMgr.getInstance();
                        for (int i = clientCampaignsList.size() - 1; i >= 0; i--) {
                            WebBusinessObject campaignTemp = clientCampaignsList.get(i);
                            campaignToolsList.put((String) campaignTemp.getAttribute("id"), recordSeasonMgr.getToolsForCampaign((String) campaignTemp.getAttribute("id")));
                        }
                        request.setAttribute("clientCampaignsList", clientCampaignsList);
                        request.setAttribute("campaignToolsList", campaignToolsList);
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("campaignsList", clientCampaignsList);
                this.forward(servedPage, request, response);
                break;
            case 96:
                servedPage = "/docs/Adminstration/client_details.jsp";
                phone = request.getParameter("phone");//clientMgr.getLastClientPhone();
                clientWbo = null;
                if (!phone.isEmpty()) {
                    try {
                        empRelationMgr = EmpRelationMgr.getInstance();
                        projectMgr = ProjectMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }
                        if (departmentWbo != null) {
                            clientWbo = clientMgr.getClientByNo(phone, "", "searchByPhone", (String) departmentWbo.getAttribute("projectID"));
                            setClientDetails(clientWbo, request);
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("showHeader", "true");
                projectMgr = ProjectMgr.getInstance();
                meetings = projectMgr.getMeetingProjects();
                callResults = projectMgr.getCallResultsProjects();
                request.setAttribute("meetings", meetings);
                request.setAttribute("callResults", callResults);
                try {
                    ArrayList<WebBusinessObject> arrayApp = new ArrayList<>(projectMgr.getOnArbitraryKey("meeting", "key3"));
                    ArrayList<WebBusinessObject> dataArray = new ArrayList<>();
                    if (arrayApp.size() > 0) {
                        WebBusinessObject wboComplaint = (WebBusinessObject) arrayApp.get(0);
                        dataArray = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) wboComplaint.getAttribute("projectID"), "key2"));
                    }
                    managerWbo = userMgr.getManagerByEmployeeID(securityUser.getUserId());
                    String departmentID = "";
                    if (managerWbo != null) {
                        departmentID = (String) managerWbo.getAttribute("fullName");
                        ArrayList<WebBusinessObject> departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
                        if (departmentList.size() > 0) {
                            departmentID = (String) departmentList.get(0).getAttribute("projectID");
                        }
                    }
                    request.setAttribute("dataArray", dataArray);
                    request.setAttribute("departmentID", departmentID);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                clientCampaignMgr = ClientCampaignMgr.getInstance();
                campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                clientCampaignsList = new ArrayList<>();
                clientCampaignsIDs = clientCampaignMgr.getCampaignIDsByClientList(clientWbo != null ? (String) clientWbo.getAttribute("id") : "");
                for (int i = campaignsList.size() - 1; i >= 0; i--) {
                    if (clientCampaignsIDs.contains((String) campaignsList.get(i).getAttribute("id"))) {
                        clientCampaignsList.add(campaignsList.get(i));
                        campaignsList.remove(i);
                    }
                }
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("clientCampaignsList", clientCampaignsList);
                this.forward(servedPage, request, response);
                break;
            case 97:
                servedPage = "/docs/Search/search_for_client_by_project.jsp";
                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> projectsList = new ArrayList<WebBusinessObject>();
                try {
                    projectsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (SQLException ex) {
                    Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("projectsList", projectsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 98:
                servedPage = "/docs/Search/search_for_client_by_project.jsp";
                String rlct = request.getParameter("rlct");
                if (rlct != null && rlct.equals("1")) {
                    String prjID = request.getParameter("projectID");
                    String prjNm = request.getParameter("prjNm");
                    String[] clntIDs = request.getParameterValues("clntIDs");
                    String prvsPrj = request.getParameter("prvsPrj");
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    clientProductMgr = ClientProductMgr.getInstance();
                    clientProductMgr.updateClientSProject(prjID, prjNm, loggedUser.getAttribute("userId").toString(), clntIDs, prvsPrj);
                }
                String beginDate = request.getParameter("beginDate");
                String endDate = request.getParameter("endDate");
                dateParser = new DateParser();
                Date bDate = new java.sql.Date(dateParser.formatSqlDate(beginDate).getTime());
                Date eDate = new java.sql.Date(dateParser.formatSqlDate(endDate).getTime());
                double tempPercent;
                DecimalFormat df = new DecimalFormat("#");
                int totalClientsCount = 0;
                ArrayList dataList1 = new ArrayList();
                String jsonText = null;
                ArrayList<WebBusinessObject> result = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> Ccount = new ArrayList<WebBusinessObject>();
                String Tcount = new String();
                if (request.getParameter("projectID") != null && !request.getParameter("projectID").isEmpty() && !request.getParameter("projectID").equals("all")) {
                    result = clientMgr.getClientsByProject(request.getParameter("projectID"), bDate, eDate, "true".equals(request.getParameter("hasVisits")));
                } else if (request.getParameter("projectID") != null && !request.getParameter("projectID").isEmpty() && request.getParameter("projectID").equals("all")) {
                    result = clientMgr.getClientsByAllProject(bDate, eDate, "true".equals(request.getParameter("hasVisits")));
                    Ccount = clientMgr.getClientsCountByAllProjects(bDate, eDate, "true".equals(request.getParameter("hasVisits")));
                    Tcount = clientMgr.getTotalClientsCount(bDate, eDate, "true".equals(request.getParameter("hasVisits")));
                    if (!Ccount.isEmpty()) {
                        // populate series data map
                        for (WebBusinessObject clientCountWbo : Ccount) {
                            tempPercent = Double.valueOf(clientCountWbo.getAttribute("clientsCount") + "") * 100 / Double.valueOf(Tcount);
                            clientCountWbo.setAttribute("percent", df.format(tempPercent));
                            HashMap dataEntryMap = new HashMap();
                            dataEntryMap.put("name", clientCountWbo.getAttribute("projectName"));
                            dataEntryMap.put("y", tempPercent);
                            dataList1.add(dataEntryMap);
                        }
                        jsonText = JSONValue.toJSONString(dataList1);
                        request.setAttribute("jsonText", jsonText);
                        request.setAttribute("Ccount", Ccount);
                    }
                }
                projectMgr = ProjectMgr.getInstance();
                projectsList = new ArrayList<WebBusinessObject>();
                try {
                    projectsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (SQLException ex) {
                    Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("projectsList", projectsList);
                request.setAttribute("data", result);
                request.setAttribute("page", servedPage);
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("hasVisits", request.getParameter("hasVisits"));
                request.setAttribute("smry", request.getParameter("smry"));
                this.forwardToServedPage(request, response);
                break;
            case 99:
                servedPage = "/docs/client/clients_per_employee.jsp";
                if (request.getParameter("groupID") != null) {
                    fromDate = request.getParameter("fromDate");
                    String toDate = request.getParameter("toDate");
                    interCode = request.getParameter("interCode");
                    String sourceID = request.getParameter("sourceID");
                    dateParser = new DateParser();
                    bDate = new java.sql.Date(dateParser.formatSqlDate(fromDate).getTime());
                    eDate = new java.sql.Date(dateParser.formatSqlDate(toDate).getTime());
                    issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                    int totalReservation, totalConfirmed;
                    Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();
                    Map<String, WebBusinessObject> employeeResult = new HashMap<>();
                    try {
                        List<WebBusinessObject> usersList = userMgr.getUsersByGroup(request.getParameter("groupID"));
                        for (WebBusinessObject userWbo : usersList) {
                            totalReservation = 0;
                            totalConfirmed = 0;
                            ArrayList<WebBusinessObject> issuesList = issueByComplaintMgr.getComplaintsPerEmployee((String) userWbo.getAttribute("userId"), bDate, eDate, interCode, sourceID);
                            for (WebBusinessObject issueWbo : issuesList) {
                                if (issueWbo.getAttribute("totalConfirmed") != null && !issueWbo.getAttribute("totalConfirmed").equals("0")) {
                                    totalConfirmed++;
                                } else if (issueWbo.getAttribute("totalReservation") != null && !issueWbo.getAttribute("totalReservation").equals("0")) {
                                    totalReservation++;
                                }
                            }
                            userWbo.setAttribute("totalReservation", totalReservation);
                            userWbo.setAttribute("totalConfirmed", totalConfirmed);
                            employeeResult.put((String) userWbo.getAttribute("userId"), userWbo);
                            dataResult.put((String) userWbo.getAttribute("userId"), issuesList);
                        }
                        request.setAttribute("employeeResult", employeeResult);
                        request.setAttribute("dataResult", dataResult);
                    } catch (SQLException ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("fromDate", fromDate);
                    request.setAttribute("toDate", toDate);
                    request.setAttribute("interCode", interCode);
                    request.setAttribute("groupID", request.getParameter("groupID"));
                    request.setAttribute("sourceID", request.getParameter("sourceID"));
                    request.setAttribute("reportType", request.getParameter("reportType"));
                }
                //get logged user groups
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                userGroupCongMgr = UserGroupConfigMgr.getInstance();
                groupMgr = GroupMgr.getInstance();
                ArrayList<WebBusinessObject> groupsList = new ArrayList<WebBusinessObject>();
                try {
                    Vector userGroups = userGroupCongMgr.getOnArbitraryKey(loggedUser.getAttribute("userId").toString(), "key2");
                    if (userGroups.size() > 0 && userGroups != null) {
                        for (int i = 0; i < userGroups.size(); i++) {
                            WebBusinessObject userGroupsWbo = (WebBusinessObject) userGroups.get(i);
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groupsList.add(groupWbo);
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("usersList", new ArrayList<>(userMgr.getCashedTable()));
                request.setAttribute("groupsList", groupsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 100:
                servedPage = "/docs/client/list_closed_clients.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                try {
                    java.sql.Date fromDateD = new java.sql.Date(sdf.parse(fromDateS).getTime());
                    java.sql.Date toDateD = new java.sql.Date(sdf.parse(toDateS).getTime());
                    clientsList = clientMgr.getClosedClients(fromDateD, toDateD);
                } catch (ParseException ex) {
                    clientsList = new ArrayList<>();
                }
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("clientsList", clientsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 101:
                servedPage = "/docs/Search/search_for_client_history.jsp";
                clientMgr = ClientMgr.getInstance();
                clientCampaignMgr = ClientCampaignMgr.getInstance();
                clientProductMgr = ClientProductMgr.getInstance();
                appointmentMgr = AppointmentMgr.getInstance();
                commentsMgr = CommentsMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                issueComplaints = IssueByComplaintUniqueMgr.getInstance();
                ReservationMgr reservationMgr = ReservationMgr.getInstance();
                seasons = new Vector();
                products = new Vector();
                reservedUnit = new Vector();
                Vector soldUnits = new Vector();
                Vector directFollows = new Vector();
                appointments = new Vector();
                comments = new Vector();
                complaints = new Vector();
                clientWbo = null;
                String departmentID;
                num = request.getParameter("num");
                projectID = request.getParameter("projectID");
                searchType = request.getParameter("searchType");
                try {
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    projectName = "";
                    if (projectID != null && !projectID.isEmpty()) {
                        projectName = (String) projectMgr.getOnSingleKey(projectID).getAttribute("projectName");
                    }
                    empRelationMgr = EmpRelationMgr.getInstance();
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                    if (departmentWbo != null) {
                        departmentID = (String) departmentWbo.getAttribute("projectID");
                        clientWbo = clientMgr.getClientByNo(num, projectName, searchType, departmentID);
                        if (clientWbo != null) {
                            products = clientProductMgr.getOnArbitraryDoubleKeyOracle((String) clientWbo.getAttribute("id"), "key1", "interested", "key4");
                            reservedUnit = reservationMgr.getOnArbitraryKeyOracle((String) clientWbo.getAttribute("id"), "key1");
                            soldUnits = clientProductMgr.getOnArbitraryDoubleKeyOracle((String) clientWbo.getAttribute("id"), "key1", "purche", "key4");
                            appointments = appointmentMgr.getOnArbitraryDoubleKeyOracle(clientWbo.getAttribute("id").toString(), "key1", "23", "key5");
                            directFollows = appointmentMgr.getOnArbitraryDoubleKeyOracle(clientWbo.getAttribute("id").toString(), "key1", "29", "key5");
                            comments = commentsMgr.getCommentsByClientID(clientWbo.getAttribute("id").toString());
                            seasons = clientCampaignMgr.getOnArbitraryKey(clientWbo.getAttribute("id").toString(), "key2");
                            complaints = issueComplaints.getAllCaseForClient(clientWbo.getAttribute("id").toString(), departmentID);//issueByComplaintMgr.preparer(issueByComplaintMgr.getOnArbitraryKey(clientWbo.getAttribute("id").toString(), "key2"));
                            ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
                            clientRateWbo = clientRatingMgr.getOnSingleKey("key1", (String) clientWbo.getAttribute("id"));
                            if (clientRateWbo != null) {
                                request.setAttribute("rateWbo", projectMgr.getOnSingleKey((String) clientRateWbo.getAttribute("rateID")));
                                request.setAttribute("rateUserWbo", userMgr.getOnSingleKey((String) clientRateWbo.getAttribute("createdBy")));
                                request.setAttribute("clientRateWbo", clientRateWbo);
                            }
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("client", clientWbo);
                request.setAttribute("products", products);
                request.setAttribute("reservedUnit", reservedUnit);
                request.setAttribute("soldUnits", soldUnits);
                request.setAttribute("appointments", appointments);
                request.setAttribute("directFollows", directFollows);
                request.setAttribute("comments", comments);
                request.setAttribute("seasons", seasons);
                request.setAttribute("complaints", complaints);
                this.forward(servedPage, request, response);
                break;
            case 102:
                out = response.getWriter();
                wbo = getUnitsListAjax(request);
                out.print(Tools.getJSONObjectAsString(wbo));
                break;
            case 103:
                servedPage = "/docs/contracts/clients_contracts.jsp";
                clientContractsMgr = ClientContractsMgr.getInstance();
                Vector clientsContracts = clientContractsMgr.selectAllClientsContracts();
                request.setAttribute("data", clientsContracts);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 104:
                servedPage = "/docs/client/campaign_clients_list.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String campaignID = request.getParameter("campaignID");
                campaignMgr = CampaignMgr.getInstance();
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("campaignWbo", campaignMgr.getOnSingleKey(campaignID));
                request.setAttribute("campaignID", campaignID);
                request.setAttribute("data", clientMgr.getCampaignClients(campaignID, beginDate, endDate));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 105:
                servedPage = "/docs/client/client_history.jsp";
                request.setAttribute("num", request.getParameter("num"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 106:
                servedPage = "/docs/customer/distribute_client.jsp";
                request.setAttribute("employeeId", request.getParameter("employeeId"));
                request.setAttribute("employeeName", request.getParameter("employeeName"));
                request.setAttribute("clientId", request.getParameter("clientId"));
                request.setAttribute("clientName", request.getParameter("clientName"));
                request.setAttribute("status", request.getParameter("status"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 107:
                UserMgr userMgr = UserMgr.getInstance();
                issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                int totalReservation,
                 totalConfirmed;
                Vector<WebBusinessObject> reportData = new Vector();
                Vector<WebBusinessObject> reportDetails = new Vector();
                if (request.getParameter("groupID") != null) {
                    //get between dates
                    fromDate = request.getParameter("fromDate");
                    String toDate = request.getParameter("toDate");
                    dateParser = new DateParser();
                    bDate = new java.sql.Date(dateParser.formatSqlDate(fromDate).getTime());
                    eDate = new java.sql.Date(dateParser.formatSqlDate(toDate).getTime());
                    String reportType = request.getParameter("reportType");
                    try {
                        List<WebBusinessObject> usersList = userMgr.getUsersByGroup(request.getParameter("groupID"));
                        for (WebBusinessObject userWbo : usersList) {
                            Vector<WebBusinessObject> employeeVec = new Vector();
                            totalReservation = 0;
                            totalConfirmed = 0;
                            ArrayList<WebBusinessObject> issuesList = issueByComplaintMgr.getComplaintsPerEmployee((String) userWbo.getAttribute("userId"), bDate, eDate, null, null);
                            for (WebBusinessObject issueWbo : issuesList) {
                                if (issueWbo.getAttribute("totalConfirmed") != null && !issueWbo.getAttribute("totalConfirmed").equals("0")) {
                                    totalConfirmed++;
                                } else if (issueWbo.getAttribute("totalReservation") != null && !issueWbo.getAttribute("totalReservation").equals("0")) {
                                    totalReservation++;
                                }
                            }
                            userWbo.setAttribute("totalReservation", new Integer(totalReservation));
                            userWbo.setAttribute("totalConfirmed", new Integer(totalConfirmed));
                            userWbo.setAttribute("totalClients", new Integer(issuesList.size()));
                            if (reportType.equals("detail")) {
                                //prepare detailed report data
                                employeeVec.add(userWbo);
                                WebBusinessObject tempDetails = new WebBusinessObject();
                                tempDetails.setAttribute("employee", employeeVec);
                                tempDetails.setAttribute("client", issuesList);
                                reportDetails.add(tempDetails);
                            } else {
                                reportData.add(userWbo);
                            }
                        }
                    } catch (SQLException ex) {
                    }
                    HashMap parameters = new HashMap();
                    parameters.put("fromDate", bDate.toString());
                    parameters.put("toDate", eDate.toString());
                    String logo = "logo" + "-" + metaDataMgr.getCompanyName() + ".png";
                    if (reportType.equals("detail")) {
                        Tools.createPdfReportFromComapny("EmployeeDetailedProductivity", parameters, reportDetails, getServletContext(), response, request, logo);
                    } else {
                        Tools.createPdfReportFromComapny("EmployeeProductivity", parameters, reportData, getServletContext(), response, request, logo);
                    }
                }
                break;
            case 108:
                out = response.getWriter();
                wbo = getClientInterPhone(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 109:
                servedPage = "/docs/Search/search_for_client_with_no_comments.jsp";
                IssueByComplaintUniqueMgr issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : sdf.format(cal.getTime());
                cal.add(Calendar.MONTH, -1);
                beginDate = request.getParameter("beginDate") != null ? request.getParameter("beginDate") : sdf.format(cal.getTime());
                dateParser = new DateParser();
                bDate = new java.sql.Date(dateParser.formatSqlDate(beginDate).getTime());
                eDate = new java.sql.Date(dateParser.formatSqlDate(endDate).getTime());
                departmentID = request.getParameter("departmentID");
                try {
                    request.setAttribute("data", issueByComplaintUniqueMgr.getClientsWithNoComments(bDate, eDate,
                            departmentID, (String) persistentUser.getAttribute("userId")));
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    ArrayList<WebBusinessObject> departmentsList = new ArrayList<>();
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departmentsList.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }
                    request.setAttribute("departmentsList", departmentsList);
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    userMgr = UserMgr.getInstance();
                    request.setAttribute("employees", userMgr.getEmployeesByManager((String) persistentUser.getAttribute("userId")));
                } catch (Exception ex) {
                }
                try {
                    request.setAttribute("typesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("typesList", new ArrayList<>());
                }
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("meetings", projectMgr.getMeetingProjects());
                request.setAttribute("callResults", projectMgr.getCallResultsProjects());
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("departmentID", departmentID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 110:
                out = response.getWriter();
                wbo = deleteComplaintStatusAjax(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 111:
                servedPage = "/docs/client/calling_plan.jsp";
                if (request.getParameterValues("clientID") != null) { // saving
                    CallingPlanMgr callingPlanMgr = CallingPlanMgr.getInstance();
                    CallingPlanDetailsMgr callingPlanDetailsMgr = CallingPlanDetailsMgr.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    request.setAttribute("status", "no");
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("frequencyRate", request.getParameter("frequencyRate"));
                    wbo.setAttribute("frequencyType", request.getParameter("frequencyType"));
                    wbo.setAttribute("scheduleStatus", "44"); // Planned
                    try {
                        wbo.setAttribute("fromDate", new Timestamp(sdf.parse(request.getParameter("beginDate")).getTime()));
                    } catch (ParseException ex) {
                        wbo.setAttribute("fromDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
                    }
                    sdf.applyPattern("yyyy/MM/dd HH:mm:ss");
                    try {
                        wbo.setAttribute("toDate", new Timestamp(sdf.parse(request.getParameter("endDate") + " 23:59:59").getTime()));
                    } catch (ParseException ex) {
                        wbo.setAttribute("toDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
                    }
                    wbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                    wbo.setAttribute("option1", request.getParameter("planTitle"));
                    wbo.setAttribute("option3", "UL");
                    if (callingPlanMgr.saveObject(wbo)) {
                        String[] clientIDs = request.getParameterValues("clientID");
                        for (String tempClientID : clientIDs) {
                            tempWbo = new WebBusinessObject();
                            tempWbo.setAttribute("callingPlanID", wbo.getAttribute("id"));
                            tempWbo.setAttribute("clientID", tempClientID);
                            tempWbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                            tempWbo.setAttribute("option1", "UL");
                            tempWbo.setAttribute("option2", "UL");
                            tempWbo.setAttribute("option3", "UL");
                            if (callingPlanDetailsMgr.saveObject(tempWbo)) {
                                request.setAttribute("status", "ok");
                            }
                        }
                        request.setAttribute("planCode", callingPlanMgr.getOnSingleKey((String) wbo.getAttribute("id")).getAttribute("option2"));
                    }
                }
                clientsList = clientMgr.getActiveClientByOwner((String) loggedUser.getAttribute("userId"));
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("clientsList", clientsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 112:
                servedPage = "/docs/campaign/client_campaigns.jsp";
                CallingPlanMgr callingPlanMgr = CallingPlanMgr.getInstance();
                try {
                    request.setAttribute("campaignsList", callingPlanMgr.getClientCampaigns(request.getParameter("clientID")));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                this.forward(servedPage, request, response);
                break;
            case 113:
                servedPage = "/docs/client/calling_plan_list.jsp";
                callingPlanMgr = CallingPlanMgr.getInstance();
                // for top menu
                lastFilter = "ClientServlet?op=listCallingPlans";
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
                // end top menu
                request.setAttribute("callingPlansList", new ArrayList<>(callingPlanMgr.getCashedTable()));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 114:
                issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                metaDataMgr = MetaDataMgr.getInstance();
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : sdf.format(cal.getTime());
                cal.add(Calendar.MONTH, -1);
                beginDate = request.getParameter("beginDate") != null ? request.getParameter("beginDate") : sdf.format(cal.getTime());
                dateParser = new DateParser();
                bDate = new java.sql.Date(dateParser.formatSqlDate(beginDate).getTime());
                eDate = new java.sql.Date(dateParser.formatSqlDate(endDate).getTime());
                ArrayList<WebBusinessObject> empClients = null;
                try {
                    empClients = issueByComplaintUniqueMgr.getClientsWithNoCommentsDetailes(bDate, eDate);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                HashMap parameters = new HashMap();
                parameters.put("CompanyName", (String) metaDataMgr.getLogos().get("ReportTitle"));
                parameters.put("logo", (String) metaDataMgr.getLogos().get("headReport3"));
                Tools.createPdfReportUncomntClient("EmpUnComDetailedReport", parameters, empClients, getServletContext(), response, request, (String) metaDataMgr.getLogos().get("headReport3"));
                break;
            case 115:
                issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                metaDataMgr = MetaDataMgr.getInstance();
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : sdf.format(cal.getTime());
                cal.add(Calendar.MONTH, -1);
                beginDate = request.getParameter("beginDate") != null ? request.getParameter("beginDate") : sdf.format(cal.getTime());
                dateParser = new DateParser();
                bDate = new java.sql.Date(dateParser.formatSqlDate(beginDate).getTime());
                eDate = new java.sql.Date(dateParser.formatSqlDate(endDate).getTime());
                empClients = null;
                try {
                    empClients = issueByComplaintUniqueMgr.getEmpClientsWithNoComments(bDate, eDate);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                parameters = new HashMap();
                parameters.put("CompanyName", (String) metaDataMgr.getLogos().get("ReportTitle"));
                parameters.put("logo", (String) metaDataMgr.getLogos().get("headReport3"));
                parameters.put("empClients", empClients);
                Tools.createPdfReportUncomntClient("EmpUnCommentedClientsReport", parameters, empClients, getServletContext(), response, request, (String) metaDataMgr.getLogos().get("headReport3"));
                break;
            case 116:
                servedPage = "/docs/client/client_rating.jsp";
                request.setAttribute("clientsList", clientMgr.getNonCustomersByOwner((String) loggedUser.getAttribute("userId")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 117:
                out = response.getWriter();
                wbo = updateClientStatus(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 118:
                servedPage = "/docs/client/my_calling_plan_list.jsp";
                callingPlanMgr = CallingPlanMgr.getInstance();
                try {
                    request.setAttribute("callingPlansList", new ArrayList<>(callingPlanMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("callingPlansList", new ArrayList<>());
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 119:
                servedPage = "/docs/client/campaign_agent_clients_list.jsp";
                request.setAttribute("data", clientMgr.getEmployeeClientsWithCampaign(request.getParameter("employeeID"),
                        request.getParameter("campaignID"), request.getParameter("beginDate"), request.getParameter("endDate")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 120:
                out = response.getWriter();
                wbo = changeClientRate(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 121:
                servedPage = "/docs/client/client_class.jsp";
                fromDate = request.getParameter("fromDate");
                String toDate = request.getParameter("toDate");
                mainClientRate = request.getParameter("mainClientRate");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (toDate == null) {
                    Calendar c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -1);
                    fromDate = sdf.format(c.getTime());
                }
                ratesList = new ArrayList<>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    clientsList = clientMgr.getCustomersClassification((String) loggedUser.getAttribute("userId"),
                            new Timestamp(sdf.parse(fromDate).getTime()), new Timestamp(sdf.parse(toDate).getTime()), mainClientRate,
                            null, null, request.getParameter("type"), request.getParameter("campaignID"));
                    for (WebBusinessObject clientTempWbo : clientsList) {
                        clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
                    }
                    request.setAttribute("clientsList", clientsList);
                } catch (ParseException ex) {
                    request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
                }
                try {
                    request.setAttribute("typesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("typesList", new ArrayList<>());
                }
                campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("ratesList", ratesList);
                request.setAttribute("type", request.getParameter("type"));
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("mainClientRate", mainClientRate);
                request.setAttribute("campaignID", request.getParameter("campaignID"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 122:
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                mainClientRate = request.getParameter("mainClientRate");
                campaignID=request.getParameter("campaignID");
                String campaignName="All";
                if (!campaignID.isEmpty()){
                 campaignMgr=CampaignMgr.getInstance();
                WebBusinessObject camWbo=campaignMgr.getOnSingleKey("key", campaignID);
                campaignName=camWbo.getAttribute("campaignTitle").toString();
                }
                String hashTag = request.getParameter("hashTag");
                projectID = request.getParameter("projectID");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (toDate == null) {
                    Calendar c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate = sdf.format(c.getTime()); 
                    c.add(Calendar.DATE, -14);
                    fromDate = sdf.format(c.getTime());
                }
                try {
                    clientsList = clientMgr.getCustomersClassification((String) loggedUser.getAttribute("userId"),
                            new Timestamp(sdf.parse(fromDate).getTime()), new Timestamp(sdf.parse(toDate).getTime()), mainClientRate, null, null, request.getParameter("type"), campaignID);
                    for (WebBusinessObject clientTempWbo : clientsList) {
                        clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
                    }
                    String headers[] = {"#", "Client No.", "Client Name", "Creation Time", "Class", "Mobile", "Know Us From"};
                    String attributes[] = {"Number", "clientNO", "name", "creationTime", "classTitle", "mobile", "seasonName"};
                    String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                    
                    String [] headerValueStr={"",fromDate,toDate,campaignName};
                    String headerStr[] = {"Clients_Classification","From Date :","To Date:","Campaign :"};
                    
                    HSSFWorkbook workBook = Tools.createExcelReport("Clients Classification", headerStr, headerValueStr, headers, attributes, dataTypes, clientsList);
                    Calendar c = Calendar.getInstance();
                    java.util.Date fileDate = c.getTime();
                    sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    sdf.applyPattern("yyyy-MM-dd");
                    String reportDate = sdf.format(fileDate);
                    String filename = "ClientsClassification" + reportDate;
                    try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        try {
                            workBook.write(bos);
                        } finally {
                            bos.close();
                        }
                        byte[] bytes = bos.toByteArray();
                        response.setContentType("application/vnd.ms-excel");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                        response.setContentLength(bytes.length);
                        servletOutputStream.write(bytes, 0, bytes.length);
                        servletOutputStream.flush();
                    }
                } catch (ParseException ex) {
                    request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
                }
                break;
            case 123:
                servedPage = "/docs/client/Repeated Clients.jsp";
                clientMgr = ClientMgr.getInstance();
                String phoneVal = request.getParameter("phoneVal");
                String telJson = null;
                if (request.getParameter("phn") != null && request.getParameter("phn").equals("1")) {
                    if (phoneVal != null) {
                        if (phoneVal.equals("mobileNum")) {
                            try {
                                ArrayList<ArrayList<String>> telephoneList = new ArrayList<>();
                                telephoneList = clientMgr.getRepeatedTelphone("mobileNum");
                                telJson = JSONValue.toJSONString(telephoneList);
                            } catch (Exception ex) {
                                logger.error(ex);
                            }
                        } else if (phoneVal.equals("UL")) {
                            try {
                                ArrayList<ArrayList<String>> telephoneList = new ArrayList<>();
                                telephoneList = clientMgr.getRepeatedTelphone("UL");
                                telJson = JSONValue.toJSONString(telephoneList);
                            } catch (Exception ex) {
                                logger.error(ex);
                            }
                        }
                    } else {
                        try {
                            ArrayList<ArrayList<String>> telephoneList = new ArrayList<>();
                            telephoneList = clientMgr.getRepeatedTelphone("mobileNum");
                            telJson = JSONValue.toJSONString(telephoneList);
                        } catch (Exception ex) {
                            logger.error(ex);
                        }
                    }
                } else if (request.getParameter("phn") != null && request.getParameter("phn").equals("0")) {
                    try {
                        ArrayList<ArrayList<String>> nameList = new ArrayList<>();
                        nameList = clientMgr.getRepeatedName();
                        telJson = JSONValue.toJSONString(nameList);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                request.setAttribute("telJson", telJson);
                request.setAttribute("phn", request.getParameter("phn"));
                request.setAttribute("phoneVal", phoneVal);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 124:
                servedPage = "/docs/client/Repeated_Clients_update.jsp";
                clientMgr = ClientMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> telephoneList = new ArrayList<>();
                    telephoneList = clientMgr.getRepeatedClientTelphoneWBO();
                    telJson = Tools.getJSONArrayAsString(telephoneList);
                    request.setAttribute("telJson", telJson);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 125:
                clientMgr = ClientMgr.getInstance();
                String mobileNo = request.getParameter("mobile");
                phone = request.getParameter("phone");
                String interPhone = request.getParameter("interPhone");
                clientNo = request.getParameter("clientNo");
                clientMgr.updateClientMobile(clientNo, mobileNo, phone, interPhone);
                break;
            case 126:
                out = response.getWriter();
                wbo = saveSeason(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 127:
                servedPage = "/docs/client/InterClients.jsp";
                clientMgr = ClientMgr.getInstance();
                ArrayList countyClients = clientMgr.getCountryClients();
                request.setAttribute("countyClients", countyClients);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 128:
                servedPage = "/docs/client/InterClients.jsp";
                clientMgr = ClientMgr.getInstance();
                interCode = request.getParameter("interCode");
                countyClients = new ArrayList();
                countyClients = clientMgr.getCountryClients();
                ArrayList interClients = clientMgr.getInterClients(interCode);
                request.setAttribute("countyClients", countyClients);
                request.setAttribute("data", interClients);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 129:
                servedPage = "/docs/client/InterClientsNoCommApp.jsp";
                clientMgr = ClientMgr.getInstance();
                countyClients = new ArrayList();
                countyClients = clientMgr.getCountryClients();
                request.setAttribute("countyClients", countyClients);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 130:
                servedPage = "/docs/client/InterClientsNoCommApp.jsp";
                clientMgr = ClientMgr.getInstance();
                issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                interCode = request.getParameter("interCode");
                countyClients = new ArrayList();
                countyClients = clientMgr.getCountryClients();
                try {
                    request.setAttribute("data", issueByComplaintUniqueMgr.getClientsWithNoCommentsInter(interCode));
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("countyClients", countyClients);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 131:
                wbo = redirectClientComplaint(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 132:
                servedPage = "docs/client/MailBox.jsp";
                request.setAttribute("page", servedPage);
                EmailMgr emailmgr = EmailMgr.getInstance();
                String clientemail = request.getParameter("clientemail");
                String clientname = request.getParameter("clientname");
                try {
                    List<WebBusinessObject> clientemails = emailmgr.getClientMailBox(clientemail, clientname);
                    request.setAttribute("clientemails", clientemails);
                } catch (SQLException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward(servedPage, request, response);
                break;

            case 133:
                out = response.getWriter();
                JSONObject resultJson = distributedClientsForPagination(request);
                out.print(resultJson);
                break;
            case 134:
                clientMgr = ClientMgr.getInstance();
                issueStatusMgr = IssueStatusMgr.getInstance();
                clientWbo = new WebBusinessObject();
                clientId = request.getParameter("clientID");
                try {
                    loggerWbo = new WebBusinessObject();
                    request.setAttribute("clientId", clientId);
                    fillLoggerWbo(request, loggerWbo);
                    loggerMgr.saveObject(loggerWbo);
                    request.setAttribute("status", "ok");
                    clientMgr.deleteAllClientData(request.getParameter("clientID"));
                    deleteProductsAndIssuesForClient(clientId, persistentUser);
                    issueStatusMgr.deleteOnArbitraryKey(request.getParameter("clientID"), "key1");
                } catch (SQLException ex) {
                    logger.error("Error in Client Deletion : " + ex.getMessage());
                } catch (Exception ex) {
                    logger.error("Error in Client Deletion : " + ex.getMessage());
                }
                request.setAttribute("phn", request.getParameter("phn"));
                request.setAttribute("page", servedPage);
                this.forward("/ClientServlet?op=repeatedClientsByTelephone", request, response);
                break;
            case 135:
                servedPage = "/docs/client/view_client_popup.jsp";
                try {
                    clientWbo = clientMgr.getOnSingleKey(request.getParameter("clientID"));
                    setClientDetails(clientWbo, request);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                this.forward(servedPage, request, response);
                break;
            case 136:
                wbo = redirectClientComplaint2(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 137:
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                campaignID = request.getParameter("campaignID");
                clientsList = clientMgr.getCampaignClients(campaignID, beginDate, endDate);
                for (WebBusinessObject clientTempWbo : clientsList) {
                    interPhone = (String) clientTempWbo.getAttribute("interPhone");
                    if (interPhone == null || interPhone == "" || interPhone == " ") {
                        interPhone = " ";
                    }
                    clientTempWbo.setAttribute("interPhone", interPhone);
                }

                String headers[] = {"#", "Client Name", "Phone", "Mobile", "International Number", "Created By", "Request Date"};
                String attributes[] = {"Number", "name", "phone", "mobile", "interPhone", "createdByName", "creationTime"};
                String dataTypes[] = {"", "String", "String", "String", "String", "String", "String"};
                String[] headerStr = new String[1];
                headerStr[0] = "clients_campaign";
                HSSFWorkbook workBook = Tools.createExcelReport("Clients Campaign", headerStr, null, headers, attributes, dataTypes, clientsList);
                Calendar c = Calendar.getInstance();
                java.util.Date fileDate = c.getTime();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                sdf.applyPattern("yyyy-MM-dd");
                String reportDate = sdf.format(fileDate);
                String filename = "Clients Campaign" + reportDate;
                try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }

                    byte[] bytes = bos.toByteArray();
                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                }
                break;

            case 138:
                servedPage = "/docs/client/search_client_campaign_popup.jsp";
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    c = Calendar.getInstance();
                    Timestamp toTime = new Timestamp(request.getParameter("toDate") != null && !request.getParameter("toDate").isEmpty() ? sdf.parse(request.getParameter("toDate")).getTime() : c.getTimeInMillis());
                    c.add(Calendar.MONTH, -1);
                    Timestamp fromTime = new Timestamp(request.getParameter("fromDate") != null && !request.getParameter("fromDate").isEmpty() ? sdf.parse(request.getParameter("fromDate")).getTime() : c.getTimeInMillis());
                    request.setAttribute("clientsList", clientMgr.getClientsNotInCampaign(fromTime, toTime, request.getParameter("campaignID")));
                    request.setAttribute("fromDate", sdf.format(new Date(fromTime.getTime())));
                    request.setAttribute("toDate", sdf.format(new Date(toTime.getTime())));
                } catch (ParseException ex) {
                }

                this.forward(servedPage, request, response);
                break;

            case 139:
                wbo = saveClientsToCampaign(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 140:
                wbo = moveClientsToCampaign(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 141:
                wbo = saveClientCampaign(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 142:
                servedPage = "/docs/client/campaign_clients_ratings.jsp";
                ArrayList<WebBusinessObject> dataList = null;
                String jsonString = null;

                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                campaignID = request.getParameter("campaignID");
                try {
                    dataList = ClientRatingMgr.getInstance().getCampaignClientsRates(campaignID, beginDate, endDate);
                    jsonString = Tools.getJSONArrayAsString(dataList);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("campaignID", campaignID);
                request.setAttribute("data", dataList);
                request.setAttribute("jsonData", jsonString);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 143:
                servedPage = "/docs/client/my_client_complaints.jsp";
                issueID = request.getParameter("issueID");
                request.setAttribute("issueID", issueID);
                issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                clientID = request.getParameter("clientID");
                try {
                    request.setAttribute("complaintsList", new ArrayList<>(issueByComplaintUniqueMgr.getOnArbitraryKeyOracle(clientID, "key2")));
                } catch (Exception ex) {
                    request.setAttribute("complaintsList", new ArrayList<>());
                }
                request.setAttribute("clientId", clientID);
                this.forward(servedPage, request, response);
                break;

            case 144:
                servedPage = "docs/Adminstration/customizeClients.jsp";
                if (request.getParameter("beginDate") != null || request.getParameter("endDate") != null || request.getParameter("createdBy") != null
                        || request.getParameter("campaignID") != null || request.getParameter("description") != null || request.getParameter("projectID") != null) {
                    clients = clientMgr.getUnHandledClients(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("createdBy"),
                            request.getParameter("campaignID"), request.getParameter("description"), request.getParameter("clientType"), null, request.getParameter("projectID"), null, null, null);
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }
                userMgr = UserMgr.getInstance();
                userGroupMgr = UserGroupMgr.getInstance();
                request.setAttribute("usersList", userMgr.getAllActiveUsers());
                distributionsList = new ArrayList<WebBusinessObject>();
                employees = new ArrayList<WebBusinessObject>();
                try {
                    distributionsList = userMgr.getUsersByGroup(securityUser.getDefaultNewClientDistribution());
                } catch (Exception ex) {
                    logger.error(ex);
                }
                try {
                    employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                campaignMgr = CampaignMgr.getInstance();
                try {
                    campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                    request.setAttribute("campaignsList", campaignsList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                String save = request.getParameter("save");
                if (save != null) {
                    if (save.equals("true")) {
                        String[] clientIDLst = request.getParameterValues("customerId");
                        String[] usr = request.getParameterValues("usrID");
                        String[] usr2 = new String[usr.length - 1];
                        int j = 0;
                        if (usr.length > 2) {
                            for (int usrCnt = 0; usrCnt < usr.length; usrCnt++) {
                                if (!usr[usrCnt].contains(",")) {
                                    usr2[j] = usr[usrCnt];
                                    j++;
                                }
                            }
                        } else {
                            usr2[0] = "";
                        }

                        if (clientIDLst != null && clientIDLst.length > 0) {
                            for (int i = 0; i < clientIDLst.length; i++) {
                                try {
                                    if (usr2[0].equals("")) {
                                        WebBusinessObject createdBy = (WebBusinessObject) session.getAttribute("loggedUser");
                                        clientMgr.saveUsrLock(clientIDLst[i], usr[i % usr.length], createdBy.getAttribute("userId").toString());
                                    } else {
                                        WebBusinessObject createdBy = (WebBusinessObject) session.getAttribute("loggedUser");
                                        clientMgr.saveUsrLock(clientIDLst[i], usr2[i % usr2.length], createdBy.getAttribute("userId").toString());
                                    }

                                    request.setAttribute("redirect", "true");
                                    request.setAttribute("status", "saved");
                                } catch (Exception ex) {
                                    request.setAttribute("redirect", "false");
                                    request.setAttribute("status", "notSave");
                                }}}}}
                            

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

                request.setAttribute("usersIDsList", persistentSessionMgr.getLoggedUsers());
                request.setAttribute("distributionsList", distributionsList);
                request.setAttribute("salesEmployees", employees);
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("description", request.getParameter("description"));
                request.setAttribute("createdBy", request.getParameter("createdBy"));
                request.setAttribute("campaignID", request.getParameter("campaignID"));
                request.setAttribute("clientType", request.getParameter("clientType"));
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("clients", clients);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 145:
                servedPage = "docs/Adminstration/specialDistribute.jsp";
                WebBusinessObject loggedUsr = (WebBusinessObject) session.getAttribute("loggedUser");
                if (request.getParameter("beginDate") != null || request.getParameter("endDate") != null || request.getParameter("createdBy") != null
                        || request.getParameter("campaignID") != null || request.getParameter("description") != null) {
                    clients = clientMgr.getMyUnHandledClients(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("createdBy"),
                            request.getParameter("campaignID"), request.getParameter("description"), request.getParameter("clientType"),
                            loggedUsr.getAttribute("userId").toString(), null, null, request.getParameter("phoneNo"),
                            request.getParameter("projectID"));
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }

                userMgr = UserMgr.getInstance();
                userGroupMgr = UserGroupMgr.getInstance();
                request.setAttribute("usersList", userMgr.getAllActiveUsers());
                distributionsList = new ArrayList<WebBusinessObject>();
                employees = new ArrayList<WebBusinessObject>();
                try {
                    distributionsList = userMgr.getEmployeesByManager(loggedUsr.getAttribute("userId").toString());
                } catch (Exception ex) {
                    logger.error(ex);
                }

                try {
                    employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
                } catch (SQLException ex) {
                    logger.error(ex);
                }

                campaignMgr = CampaignMgr.getInstance();
                try {
                    campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                    request.setAttribute("campaignsList", campaignsList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }

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

                request.setAttribute("usersIDsList", persistentSessionMgr.getLoggedUsers());
                request.setAttribute("distributionsList", distributionsList);
                request.setAttribute("salesEmployees", employees);
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("description", request.getParameter("description"));
                request.setAttribute("createdBy", request.getParameter("createdBy"));
                request.setAttribute("campaignID", request.getParameter("campaignID"));
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("clientType", request.getParameter("clientType"));
                request.setAttribute("phoneNo", request.getParameter("phoneNo"));
                request.setAttribute("clients", clients);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 146:
                //String empID = request.getParameter("empID");
                String operation = request.getParameter("operation");
                String lBeginDate = request.getParameter("sBeginDate");
                String lEndDate = request.getParameter("sEndDate");
                String usrID = new String();
                if (lBeginDate != null || lEndDate != null) {
                    clients = clientMgr.getMyUnHandledClients(null, null, null, null, null, null, null, lBeginDate, lEndDate, null, null);
                } else {
                    clients = clientMgr.getMyUnHandledClients(null, null, null, null, null, null, null, null, null, null, null);
                }

                if (operation != null) {
                    if (operation.equals("delete")) {
                        usrID = request.getParameter("usrID");
                        String[] lckID = request.getParameterValues("empCustomerId");
                        try {
                            for (int i = 0; i < lckID.length; i++) {
                                clientMgr.removeLock(lckID[i]);
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    this.forward("ClientServlet?op=customizeClient", request, response);
                } else {
                    //request.setAttribute("empID", empID);
                    servedPage = "docs/Adminstration/user_client_lock.jsp";
                    request.setAttribute("beginDate", lBeginDate);
                    request.setAttribute("endDate", lEndDate);
                    request.setAttribute("empClients", clients);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 147:
                clientID = request.getParameter("clientID");
                clientNo = request.getParameter("clientNo");
                button = request.getParameter("button");
                clientWbo = clientMgr.getOnSingleKey(clientID);
                request.getSession().setAttribute("activeClientID", clientID);
                try {
                    setClientDetails(clientWbo, request);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                Tools.createClientSideMenu(clientID, clientWbo, request);
                this.forward("/ClientServlet?op=clientDetails&clientId=" + clientID + "&button=" + button, request, response);
                break;

            case 148:
                servedPage = "/docs/client/existing_clients_log.jsp";
                clients = new ArrayList<WebBusinessObject>();
                if (request.getParameter("startDate") != null) {
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        clients = clientMgr.getExistingClientsLog(new java.sql.Date(sdf.parse(request.getParameter("startDate")).getTime()),
                                new java.sql.Date(sdf.parse(request.getParameter("endDate")).getTime()), null);
                    } catch (ParseException ex) {
                        clients = new ArrayList<>();
                    }
                }

                request.setAttribute("clients", clients);
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 149:
                servedPage = "/docs/client/clients_appntms_per_employee.jsp";
                projectMgr = ProjectMgr.getInstance();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();

                ArrayList<WebBusinessObject> userDepartments;
                departments = new ArrayList<>();

                String selectedDepartment = request.getParameter("departmentID");

                try {
                    userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }

                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                        }
                    }
                    request.setAttribute("departments", departments);
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }

                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                request.setAttribute("toDate", sdf.format(cal.getTime()));
                cal.add(Calendar.MONTH, -1);
                request.setAttribute("fromDate", sdf.format(cal.getTime()));
                request.setAttribute("departmentID", selectedDepartment);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 150:
                servedPage = "/docs/client/clients_appntms_per_employee.jsp";

                ArrayList graphResultList = new ArrayList();
                ArrayList<String> TypesTagNameList = new ArrayList();
                departments = new ArrayList<>();

                clientComplaintsMgr.updateClientComplaintsType();
                projectMgr = ProjectMgr.getInstance();
                issueByComplaintMgr = IssueByComplaintMgr.getInstance();

                selectedDepartment = request.getParameter("departmentID");

                try {
                    //ArrayList<WebBusinessObject> resultList = issueByComplaintMgr.getEmpClientsAppntms(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("distType"));
                    ArrayList<WebBusinessObject> TypesTagList = ProjectMgr.getInstance().getOnArbitraryKey2("RQ-TYPE", "key4");
                    if (TypesTagList != null && TypesTagList.size() > 0) {
                        for (WebBusinessObject TypeTagWbo : TypesTagList) {
                            TypesTagNameList.add(TypeTagWbo.getAttribute("projectName").toString());
                        }

                        ArrayList<WebBusinessObject> deptResultList = issueByComplaintMgr.getDeptEmpsTagType(request.getParameter("beginDate"), request.getParameter("endDate"), selectedDepartment, TypesTagNameList);

                        if (deptResultList != null && deptResultList.size() > 0) {
                            for (WebBusinessObject deptUserwbo : deptResultList) {
                                Map<String, Object> graphDataMap = new HashMap<String, Object>();

                                ArrayList userDataList = new ArrayList();
                                for (String TypeTagName : TypesTagNameList) {
                                    userDataList.add(deptUserwbo.getAttribute(TypeTagName.toString().replaceAll("\\s", "")));
                                }

                                graphDataMap.put("name", deptUserwbo.getAttribute("userName"));
                                graphDataMap.put("data", userDataList);

                                graphResultList.add(graphDataMap);
                            }

                            String ratingCategories = JSONValue.toJSONString(TypesTagNameList);
                            String resultsJson = JSONValue.toJSONString(graphResultList);

                            request.setAttribute("ratingCategories", ratingCategories);
                            request.setAttribute("resultsJson", resultsJson);
                            request.setAttribute("graphResult", deptResultList);
                            request.setAttribute("TypesTagNameList", TypesTagNameList);
                        }
                    }

                    userDepartments = new ArrayList<>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }

                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                        }
                    }

                    try {
                        request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                    } catch (Exception ex) {
                        request.setAttribute("requestTypes", new ArrayList<>());
                    }

                    request.setAttribute("departments", departments);
                    request.setAttribute("fromDate", request.getParameter("beginDate"));
                    request.setAttribute("toDate", request.getParameter("endDate"));
                    //request.setAttribute("data", resultList);
                    request.setAttribute("departmentID", selectedDepartment);
                    if (!request.getParameter("userID").equals("")) {
                        ArrayList<WebBusinessObject> EmpDetails = IssueByComplaintMgr.getInstance().getEmpClientsAppntms(request.getParameter("beginDate"), request.getParameter("endDate"), selectedDepartment, request.getParameter("userID"));
                        request.setAttribute("EmpDetails", EmpDetails);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 151:
                servedPage = "/docs/client/emp_clients_appnts.jsp";

                try {
                    ArrayList<ArrayList<String>> empClientsDetails = new ArrayList<>();

                    empClientsDetails = IssueByComplaintMgr.getInstance().getEmpClientsData(request.getParameter("userID"), request.getParameter("departmentID"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("distType"));
                    String jsonData = JSONValue.toJSONString(empClientsDetails);

                    request.setAttribute("jsonData", jsonData);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("userName", request.getParameter("userName"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 152:
                servedPage = "/docs/client/Emp_TagTypes.jsp";
                try {
                    ArrayList<WebBusinessObject> resultList = new ArrayList<WebBusinessObject>();
                    ArrayList graphList = new ArrayList();
                    HashMap dataEntryMap;

                    resultList = IssueByComplaintMgr.getInstance().getEmpTagType(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("userID"), request.getParameter("depratmentID"));

                    if (!resultList.isEmpty()) {
                        wbo = (WebBusinessObject) resultList.get(0);
                        // populate series data map
                        dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Inbound");
                        dataEntryMap.put("y", Integer.parseInt(wbo.getAttribute("Inbound").toString()));

                        graphList.add(dataEntryMap);

                        dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Visit");
                        dataEntryMap.put("y", Integer.parseInt(wbo.getAttribute("Visit").toString()));

                        graphList.add(dataEntryMap);

                        dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Outbound");
                        dataEntryMap.put("y", Integer.parseInt(wbo.getAttribute("Outbound").toString()));

                        graphList.add(dataEntryMap);

                        dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Recycle_Data");
                        dataEntryMap.put("y", Integer.parseInt(wbo.getAttribute("Recycle_Data").toString()));

                        graphList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    String jsonTagTypeText = JSONValue.toJSONString(graphList);

                    request.setAttribute("resultList", resultList);
                    request.setAttribute("jsonTagTypeText", jsonTagTypeText);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("userName", request.getParameter("userName"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 153:
                out = response.getWriter();
                wbo = getClientFirstCommentAppointment(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 154:
                withdrawFromDetails(request, persistentUser);
                this.forward("/main.jsp", request, response);
                break;

            case 155:
                servedPage = "/docs/client/channels_distribution_report.jsp";

                Integer channelTotal = 0;
                Integer campsTotal = 0;

                if (request.getParameter("fromDate") != null) {
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    try {
                        java.sql.Date fromD = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                        java.sql.Date toD = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                        request.setAttribute("wbo", clientMgr.getClientKnownUsTotal(fromD, toD));
                        ArrayList<String> resultList = new ArrayList<>();
                        ArrayList categories = new ArrayList();
                        ArrayList<WebBusinessObject> channelsList = clientMgr.getClientKnownUsStatistics(fromD, toD);
                        for (WebBusinessObject channelWbo : channelsList) {
                            if (channelWbo.getAttribute("englishName") != null) {
                                categories.add(channelWbo.getAttribute("englishName"));
                                channelTotal += new Integer((String) channelWbo.getAttribute("total"));
                                resultList.add((String) channelWbo.getAttribute("total"));
                            }
                        }
                        Map<String, Object> graphDataMap = new HashMap<>();
                        graphDataMap.put("name", "Channels of Distribution");
                        graphDataMap.put("data", "[" + Tools.arrayToString(resultList.toArray(new String[resultList.size()]), ",") + "]");
                        ArrayList tempList = new ArrayList<>();
                        tempList.add(graphDataMap);
                        String resultsJson = JSONValue.toJSONString(tempList);
                        request.setAttribute("categories", JSONValue.toJSONString(categories));
                        request.setAttribute("channelTotal", channelTotal.toString());
                        request.setAttribute("resultsJson", resultsJson);

                        sdf.applyPattern("yyyy-MM-dd");
                        ArrayList<WebBusinessObject> campaignClientsCounts = campaignMgr.getClientsCountPerCampaign(sdf.format(fromD), sdf.format(toD), "grpTool", null);
                        ArrayList<ArrayList<String>> campsResult = new ArrayList<>();
                        campsResult = campaignMgr.getClientsCountPerCampaignList(sdf.format(fromD), sdf.format(toD));
                        String campsResultJson = JSONValue.toJSONString(campsResult);
                        request.setAttribute("campsResultJson", campsResultJson);
                        // populate series data map
                        resultList.clear();
                        categories.clear();
                        for (WebBusinessObject clientCountWbo : campaignClientsCounts) {
                            if (!((String) clientCountWbo.getAttribute("campaignTitle")).contains("Recycle")) {
                                categories.add(clientCountWbo.getAttribute("campaignTitle"));
                                campsTotal += new Integer((String) clientCountWbo.getAttribute("clientCount"));
                                resultList.add((String) clientCountWbo.getAttribute("clientCount"));
                            }
                        }

                        graphDataMap = new HashMap<>();
                        graphDataMap.put("name", "Campaigns");
                        graphDataMap.put("data", "[" + Tools.arrayToString(resultList.toArray(new String[resultList.size()]), ",") + "]");
                        tempList.clear();
                        tempList.add(graphDataMap);
                        resultsJson = JSONValue.toJSONString(tempList);
                        request.setAttribute("categoriesCampaign", JSONValue.toJSONString(categories));
                        request.setAttribute("resultsCampaignJson", resultsJson);
                        request.setAttribute("channelsList", channelsList);
                        request.setAttribute("campaignClientsCounts", campaignClientsCounts);
                        request.setAttribute("campsTotal", campsTotal.toString());
                    } catch (ParseException ex) {
                    }
                }
                request.setAttribute("fromDate", request.getParameter("fromDate"));
                request.setAttribute("toDate", request.getParameter("toDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 156:
                servedPage = "docs/client/clients_select_list.jsp";
                try {
                    clientsList = new ArrayList<>(clientMgr.getCashedTable());
                } catch (Exception ex) {
                    clientsList = new ArrayList<>();
                }
                request.setAttribute("clientsList", clientsList);
                this.forward(servedPage, request, response);
                break;

            case 157:
                servedPage = "/docs/Appointments/Emp_Distribution_Calls.jsp";
                try {
                    ArrayList<WebBusinessObject> empCalls = IssueByComplaintMgr.getInstance().getEmpCallsByDist(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("userID"), request.getParameter("TypeTag"));
                    if (!empCalls.isEmpty()) {
                        jsonText = null;
                        ArrayList resultList = new ArrayList();

                        WebBusinessObject statWbo = empCalls.get(0);

                        Map dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Answered");
                        dataEntryMap.put("y", statWbo.getAttribute("ANSWERED"));
                        resultList.add(dataEntryMap);

                        dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Not_Answered");
                        dataEntryMap.put("y", statWbo.getAttribute("NOT_ANSWERED"));
                        resultList.add(dataEntryMap);

                        dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Planed_Calls");
                        dataEntryMap.put("y", statWbo.getAttribute("PLANED_CALLS"));
                        resultList.add(dataEntryMap);

                        jsonText = JSONValue.toJSONString(resultList);

                        request.setAttribute("data", empCalls);
                        request.setAttribute("jsonText", jsonText);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.setAttribute("endDate", request.getParameter("endDate").toString());
                request.setAttribute("userID", request.getParameter("userID").toString());
                request.setAttribute("userName", request.getParameter("userName").toString());
                request.setAttribute("TypeTag", request.getParameter("TypeTag").toString());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 158:
                servedPage = "/docs/Appointments/Emp_Dist_Calls_Details.jsp";

                sdf = new SimpleDateFormat();
                try {
                    java.sql.Date fromD = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    java.sql.Date toD = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    request.setAttribute("wbo", clientMgr.getClientKnownUsTotal(fromD, toD));
                    ArrayList<String> resultList = new ArrayList<>();
                    ArrayList categories = new ArrayList();
                    ArrayList<WebBusinessObject> channelsList = clientMgr.getClientKnownUsStatistics(fromD, toD);
                    channelTotal = 0;
                    for (WebBusinessObject channelWbo : channelsList) {
                        if (channelWbo.getAttribute("englishName") != null) {
                            categories.add(channelWbo.getAttribute("englishName"));
                            channelTotal += new Integer((String) channelWbo.getAttribute("total"));
                            resultList.add((String) channelWbo.getAttribute("total"));
                        }
                    }
                    Map<String, Object> graphDataMap = new HashMap<>();
                    graphDataMap.put("name", "Channels of Distribution");
                    graphDataMap.put("data", "[" + Tools.arrayToString(resultList.toArray(new String[resultList.size()]), ",") + "]");
                    ArrayList tempList = new ArrayList<>();
                    tempList.add(graphDataMap);
                    String resultsJson = JSONValue.toJSONString(tempList);
                    request.setAttribute("categories", JSONValue.toJSONString(categories));
                    request.setAttribute("channelTotal", channelTotal.toString());
                    request.setAttribute("resultsJson", resultsJson);

                    sdf.applyPattern("yyyy-MM-dd");
                    ArrayList<WebBusinessObject> campaignClientsCounts = campaignMgr.getClientsCountPerCampaign(sdf.format(fromD), sdf.format(toD), "grpTool", null);
                    ArrayList<ArrayList<String>> campsResult = new ArrayList<>();
                    campsResult = campaignMgr.getClientsCountPerCampaignList(sdf.format(fromD), sdf.format(toD));
                    String campsResultJson = JSONValue.toJSONString(campsResult);
                    request.setAttribute("campsResultJson", campsResultJson);
                    // populate series data map
                    resultList.clear();
                    categories.clear();
                    campsTotal = 0;
                    for (WebBusinessObject clientCountWbo : campaignClientsCounts) {
                        if (!((String) clientCountWbo.getAttribute("campaignTitle")).contains("Recycle")) {
                            categories.add(clientCountWbo.getAttribute("campaignTitle"));
                            campsTotal += new Integer((String) clientCountWbo.getAttribute("clientCount"));
                            resultList.add((String) clientCountWbo.getAttribute("clientCount"));
                        }
                    }

                    graphDataMap = new HashMap<>();
                    graphDataMap.put("name", "Campaigns");
                    graphDataMap.put("data", "[" + Tools.arrayToString(resultList.toArray(new String[resultList.size()]), ",") + "]");
                    tempList.clear();
                    tempList.add(graphDataMap);
                    resultsJson = JSONValue.toJSONString(tempList);
                    request.setAttribute("categoriesCampaign", JSONValue.toJSONString(categories));
                    request.setAttribute("resultsCampaignJson", resultsJson);
                    request.setAttribute("channelsList", channelsList);
                    jsonText = Tools.getJSONArrayAsString(channelsList);
                    request.setAttribute("jsonText", jsonText);
                    request.setAttribute("campaignClientsCounts", campaignClientsCounts);
                    request.setAttribute("campsTotal", campsTotal.toString());
                } catch (ParseException ex) {

                }
                request.setAttribute("fromDate", request.getParameter("fromDate"));
                request.setAttribute("toDate", request.getParameter("toDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 159:
                servedPage = "/docs/Appointments/Emp_Distribution_Meeting.jsp";
                try {
                    ArrayList<WebBusinessObject> empCalls = IssueByComplaintMgr.getInstance().getEmpMeetingByDist(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("userID"), request.getParameter("TypeTag"));
                    if (!empCalls.isEmpty()) {
                        jsonText = null;
                        ArrayList resultList = new ArrayList();

                        WebBusinessObject statWbo = empCalls.get(0);

                        Map dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Sccuess");
                        dataEntryMap.put("y", statWbo.getAttribute("Sccuess"));
                        resultList.add(dataEntryMap);

                        dataEntryMap = new HashMap();
                        dataEntryMap.put("name", "Fail");
                        dataEntryMap.put("y", statWbo.getAttribute("Fail"));
                        resultList.add(dataEntryMap);

                        jsonText = JSONValue.toJSONString(resultList);

                        request.setAttribute("data", empCalls);
                        request.setAttribute("jsonText", jsonText);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.setAttribute("endDate", request.getParameter("endDate").toString());
                request.setAttribute("userID", request.getParameter("userID").toString());
                request.setAttribute("userName", request.getParameter("userName").toString());
                request.setAttribute("TypeTag", request.getParameter("TypeTag").toString());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 160:
                servedPage = "/docs/Appointments/Emp_Dist_Meeting_Details.jsp";
                try {
                    ArrayList<WebBusinessObject> empCalls = IssueByComplaintMgr.getInstance().getEmpMeetingByDistDetail(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("userID"), request.getParameter("TypeTag"), request.getParameter("CurrentStatus"));

                    request.setAttribute("data", empCalls);
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.setAttribute("endDate", request.getParameter("endDate").toString());
                request.setAttribute("userName", request.getParameter("userName").toString());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 161:
                clientID = request.getParameter("clientID");
                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> projectLst = projectMgr.getAllProjectForClient(clientID);
                request.setAttribute("clientID", clientID);
                request.setAttribute("projectLst", projectLst);
                servedPage = "docs/general_complaint/general_complaint_client_prj.jsp";
                this.forwardToServedPage(request, response);
                break;

            case 162:
                servedPage = "docs/client/clients_select_list.jsp";
                try {
                    clientsList = new ArrayList<>(clientMgr.getOwnerClients());
                } catch (Exception ex) {
                    clientsList = new ArrayList<>();
                }

                request.setAttribute("clientsList", clientsList);
                this.forward(servedPage, request, response);
                break;

            case 163:
                String json = owendProjectUnit(request);
                out = response.getWriter();
                out.write(json);
                break;

            case 164:
                servedPage = "/docs/client/customer_service_general_report.jsp";
                graphResultList = new ArrayList();
                TypesTagNameList = new ArrayList();
                departments = new ArrayList<>();
                selectedDepartment = request.getParameter("departmentID");
                try {
                    if (selectedDepartment != null) { // search
                        String[] ticketTypeIDs = new String[3];
                        ticketTypeIDs[0] = CRMConstants.CLIENT_COMPLAINT_TYPE_COMPLAINT;
                        ticketTypeIDs[1] = CRMConstants.CLIENT_COMPLAINT_TYPE_QUERY;
                        ticketTypeIDs[2] = CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_REQUEST;
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        ArrayList<WebBusinessObject> resultList = clientComplaintsMgr.getCustomerServiceReport(new java.sql.Date(sdf.parse(request.getParameter("beginDate")).getTime()),
                                new java.sql.Date(sdf.parse(request.getParameter("endDate")).getTime()), selectedDepartment, ticketTypeIDs);
                        String[] titles = new String[ticketTypeIDs.length];
                        if (resultList != null && resultList.size() > 0) {
                            Map<String, String> ticketTypeMap = LocationTypeMgr.getInstance().getLocationTypesMap(ticketTypeIDs);
                            for (WebBusinessObject deptUserwbo : resultList) {
                                Map<String, Object> graphDataMap = new HashMap<>();

                                ArrayList userDataList = new ArrayList();
                                for (int i = 0; i < ticketTypeIDs.length; i++) {
                                    String ticketTypeID = ticketTypeIDs[i];
                                    userDataList.add(deptUserwbo.getAttribute("total" + ticketTypeID));
                                    titles[i] = ticketTypeMap.get(ticketTypeID);
                                }

                                graphDataMap.put("name", deptUserwbo.getAttribute("userName"));
                                graphDataMap.put("data", userDataList);
                                graphResultList.add(graphDataMap);
                            }

                            String ratingCategories = "['" + Tools.arrayToString(titles, "','") + "']";
                            String resultsJson = JSONValue.toJSONString(graphResultList);
                            request.setAttribute("ratingCategories", ratingCategories);
                            request.setAttribute("resultsJson", resultsJson);
                            request.setAttribute("graphResult", resultList);
                            request.setAttribute("ticketTypeIDs", ticketTypeIDs);
                            request.setAttribute("ticketTypeMap", ticketTypeMap);
                        }
                        request.setAttribute("fromDate", request.getParameter("beginDate"));
                        request.setAttribute("toDate", request.getParameter("endDate"));
                    } else {
                        cal = Calendar.getInstance();
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        request.setAttribute("toDate", sdf.format(cal.getTime()));
                        cal.add(Calendar.MONTH, -1);
                        request.setAttribute("fromDate", sdf.format(cal.getTime()));
                    }

                    userDepartments = new ArrayList<>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }

                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                        }
                    }

                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("departments", departments);
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 165:
                servedPage = "/docs/client/user_created_complaints.jsp";
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                try {
                    request.setAttribute("complaintsList", clientComplaintsMgr.getRequestsByUserInPeriod(new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime()),
                            new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime()), request.getParameter("userID"),
                            request.getParameter("type")));
                } catch (Exception ex) {
                    request.setAttribute("complaintsList", new ArrayList<>());
                }

                this.forward(servedPage, request, response);
                break;

            case 166:
                wbo = redirectClients(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 167:
                servedPage = "/docs/client/distribution_requests_report.jsp";
                graphResultList = new ArrayList();
                TypesTagNameList = new ArrayList();
                departments = new ArrayList<>();
                selectedDepartment = request.getParameter("departmentID");
                try {
                    if (selectedDepartment != null) { // search
                        String[] ticketTypeIDs = new String[4];
                        ticketTypeIDs[0] = CRMConstants.CLIENT_COMPLAINT_TYPE_COMPLAINT;
                        ticketTypeIDs[1] = CRMConstants.CLIENT_COMPLAINT_TYPE_QUERY;
                        ticketTypeIDs[2] = CRMConstants.CLIENT_COMPLAINT_TYPE_JOB_ORDER;
                        ticketTypeIDs[3] = CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_REQUEST;
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        ArrayList<WebBusinessObject> resultList = clientComplaintsMgr.getDistributionRequestsReport(new java.sql.Date(sdf.parse(request.getParameter("beginDate")).getTime()),
                                new java.sql.Date(sdf.parse(request.getParameter("endDate")).getTime()), selectedDepartment, ticketTypeIDs);
                        String[] titles = new String[ticketTypeIDs.length];
                        if (resultList != null && resultList.size() > 0) {
                            Map<String, String> ticketTypeMap = LocationTypeMgr.getInstance().getLocationTypesMap(ticketTypeIDs);
                            for (WebBusinessObject deptUserwbo : resultList) {
                                Map<String, Object> graphDataMap = new HashMap<>();

                                ArrayList userDataList = new ArrayList();
                                for (int i = 0; i < ticketTypeIDs.length; i++) {
                                    String ticketTypeID = ticketTypeIDs[i];
                                    userDataList.add(deptUserwbo.getAttribute("total" + ticketTypeID));
                                    titles[i] = ticketTypeMap.get(ticketTypeID);
                                }

                                graphDataMap.put("name", deptUserwbo.getAttribute("userName"));
                                graphDataMap.put("data", userDataList);
                                graphResultList.add(graphDataMap);
                            }
                            String ratingCategories = "['" + Tools.arrayToString(titles, "','") + "']";
                            String resultsJson = JSONValue.toJSONString(graphResultList);
                            request.setAttribute("ratingCategories", ratingCategories);
                            request.setAttribute("resultsJson", resultsJson);
                            request.setAttribute("graphResult", resultList);
                            request.setAttribute("ticketTypeIDs", ticketTypeIDs);
                            request.setAttribute("ticketTypeMap", ticketTypeMap);
                        }
                        request.setAttribute("fromDate", request.getParameter("beginDate"));
                        request.setAttribute("toDate", request.getParameter("endDate"));
                    } else {
                        cal = Calendar.getInstance();
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        request.setAttribute("toDate", sdf.format(cal.getTime()));
                        cal.add(Calendar.MONTH, -1);
                        request.setAttribute("fromDate", sdf.format(cal.getTime()));
                    }

                    userDepartments = new ArrayList<>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }

                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                        }
                    }
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("departments", departments);
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 168:
                servedPage = "/docs/client/user_owner_complaints.jsp";
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                try {
                    request.setAttribute("complaintsList", clientComplaintsMgr.getRequestsByOwnerInPeriod(new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime()),
                            new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime()), request.getParameter("userID"),
                            request.getParameter("type")));
                } catch (Exception ex) {
                    request.setAttribute("complaintsList", new ArrayList<>());
                }

                this.forward(servedPage, request, response);
                break;

            case 169:
                servedPage = "/docs/client/client_details_Order.jsp";
                clientId = request.getParameter("clientId");

                if (clientId == null) {
                    clientId = (String) request.getAttribute("clientId");
                }

                clientWbo = clientMgr.getOnSingleKey(request.getParameter("clientId"));

                issueId = request.getParameter("issueId");

                WebBusinessObject jobOrderWbo = new WebBusinessObject();
                issueMgr = IssueMgr.getInstance();
                jobOrderWbo = issueMgr.jobOrderInfo(issueId);

                ArrayList<WebBusinessObject> busItmLst = issueMgr.getBusItmLst(issueId, "4");
                ArrayList<WebBusinessObject> MItmLst = issueMgr.getBusItmLst(issueId, "5");
                ArrayList<WebBusinessObject> sprPrtLst = issueMgr.getBusItmLst(issueId, "7");

                projectMgr = ProjectMgr.getInstance();
                WebBusinessObject eqpInfoWbo = projectMgr.getorderdetals(issueId);

                request.setAttribute("issueId", issueId);
                request.setAttribute("clientWbo", clientWbo);
                request.setAttribute("jobOrderWbo", jobOrderWbo);
                request.setAttribute("busItmLst", busItmLst);
                request.setAttribute("MItmLst", MItmLst);
                request.setAttribute("sprPrtLst", sprPrtLst);
                request.setAttribute("eqpInfoWbo", eqpInfoWbo);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;

            case 170:
                servedPage = "/docs/client/new_request_form.jsp";
                try {
                    ArrayList<WebBusinessObject> departmentsList = new ArrayList<>(projectMgr.getOnArbitraryKey("div", "key6"));
                    ArrayList<WebBusinessObject> complaintsList = new ArrayList(projectMgr.getOnArbitraryKeyOracle("cmplnt", "key6"));
                    ArrayList<WebBusinessObject> requests = new ArrayList(projectMgr.getOnArbitraryKeyOracle("rqst", "key6"));
                    ArrayList<WebBusinessObject> categories = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key6"));
                    ArrayList<WebBusinessObject> inquiries = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("nqry", "key6"));
                    if (complaintsList == null) {
                        complaintsList = new ArrayList();
                    } else {
                        for (int i = complaintsList.size() - 1; i >= 0; i--) {
                            tempWbo = complaintsList.get(i);
                            if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                                complaintsList.remove(tempWbo);
                                break;
                            }
                        }
                    }

                    if (requests == null) {
                        requests = new ArrayList();
                    } else {
                        for (int i = requests.size() - 1; i >= 0; i--) {
                            tempWbo = requests.get(i);
                            if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                                requests.remove(tempWbo);
                                break;
                            }
                        }
                    }

                    if (inquiries == null) {
                        inquiries = new ArrayList();
                    } else {
                        for (int i = inquiries.size() - 1; i >= 0; i--) {
                            tempWbo = inquiries.get(i);
                            if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                                inquiries.remove(tempWbo);
                                break;
                            }
                        }
                    }

                    request.setAttribute("departmentsList", departmentsList);
                    request.setAttribute("complaints", complaintsList);
                    request.setAttribute("requests", requests);
                    request.setAttribute("categories", categories);
                    request.setAttribute("inquiries", inquiries);
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey(request.getParameter("clientID")));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 171:
                issueMgr = IssueMgr.getInstance();
                List<WebBusinessObject> issuesList = issueMgr.getClearErrorTasksByBusiness(request.getParameter("businessNo"));
                if (issuesList.isEmpty()) {
                    this.forward("SearchServlet?op=getSearchClientsByUnit", request, response);
                } else {
                    wbo = issuesList.get(0);
                    this.forward("ClientServlet?op=clientDetails&issueID=" + wbo.getAttribute("id") + "&clientId=" + wbo.getAttribute("clientId"),
                            request, response);
                }
                break;

            case 172:
                servedPage = "/docs/client/campaign_clients_sold_report.jsp";
                reservationMgr = ReservationMgr.getInstance();
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                campaignID = request.getParameter("campaignID");
                campaignMgr = CampaignMgr.getInstance();
                request.setAttribute("data", clientMgr.getCampaignSolidClients(campaignID, beginDate, endDate));
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("campaignWbo", campaignMgr.getOnSingleKey(campaignID));
                request.setAttribute("campaignID", campaignID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 173:
                wbo = new WebBusinessObject();
                clientMgr = ClientMgr.getInstance();

                servedPage = "/docs/client/new_boker_client.jsp";

                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("ownerID", request.getParameter("ownerID"));
                request.setAttribute("unitName", request.getParameter("unitName"));
                request.setAttribute("page", servedPage);
                 {
                    try {
                        wbo = clientMgr.selectOwnerInfo(request);
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (SQLException ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (UnsupportedTypeException ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                request.setAttribute("wbo", wbo);
                this.forwardToServedPage(request, response);
                break;

            case 174:
                out = response.getWriter();
                wbo = saveClientBoker(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 175:
                out = response.getWriter();
                wbo = updateClientBoker(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 176:
                out = response.getWriter();
                wbo = addToCart(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 178:
                if (request.getParameter("ppu") != null && ((request.getParameter("ppu")).toString()).equals("1")) {
                    if (request.getParameter("up") != null && ((request.getParameter("up")).toString()).equals("1")) {
                        email = request.getParameter("nwEmail");
                        clientID = request.getParameter("nwClntEmail");
                        if (clientMgr.upEmail(email, clientID)) {
                            request.setAttribute("up", "1");
                        } else {
                            request.setAttribute("up", "0");
                        }
                    }

                    servedPage = "/docs/call_center/lstClntMails.jsp";

                    fromDate = request.getParameter("fromDate");
                    toDate = request.getParameter("toDate");
                    mainClientRate = request.getParameter("mainClientRate");
                    String mainClientPrj = request.getParameter("mainClientPrj");

                    sdf = new SimpleDateFormat("yyyy-MM-dd");

                    if (toDate == null) {
                        c = Calendar.getInstance();
                        sdf = new SimpleDateFormat("yyyy-MM-dd");
                        toDate = sdf.format(c.getTime());
                        c.add(Calendar.DATE, -14);
                        fromDate = sdf.format(c.getTime());
                    }

                    ratesList = new ArrayList<>();
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                        request.setAttribute("ratesList", ratesList);
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        request.setAttribute("ratesList", new ArrayList<WebBusinessObject>());
                    }

                    try {
                        clientsList = clientMgr.getCustomersClassification((String) loggedUser.getAttribute("userId"), new Timestamp(sdf.parse(fromDate).getTime()), new Timestamp(sdf.parse(toDate).getTime()), mainClientRate, mainClientPrj, null, null, null);
                        for (WebBusinessObject clientTempWbo : clientsList) {
                            clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
                        }
                        request.setAttribute("clientsList", clientsList);
                    } catch (ParseException ex) {
                        request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
                    }

                    projectMgr = ProjectMgr.getInstance();
                    projectsList = new ArrayList<WebBusinessObject>();
                    try {
                        projectsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4"));
                    } catch (SQLException ex) {
                        Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("fromDate", fromDate);
                    request.setAttribute("toDate", toDate);
                    request.setAttribute("mainClientRate", mainClientRate);

                    request.setAttribute("projectsList", projectsList);
                    request.setAttribute("mainClientPrj", mainClientPrj);

                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                } else {
                    servedPage = "/docs/call_center/salesMails.jsp";

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    request.setAttribute("email", loggedUser.getAttribute("email"));

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 177:
                if (request.getParameter("ppu") != null && ((request.getParameter("ppu")).toString()).equals("1")) {
                    servedPage = "/docs/call_center/clientBirtMonthLst.jsp";

                    ArrayList<WebBusinessObject> emails = clientMgr.GetClientsBirthDays(null, null, null, null, null);

                    request.setAttribute("emails", emails);
                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                } else {
                    servedPage = "/docs/call_center/special_emails.jsp";

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    request.setAttribute("email", loggedUser.getAttribute("email"));

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 179:
                out = response.getWriter();
                wbo = getClientByMobileAjax(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 180:
                String[] clientsIds = request.getParameterValues("customerId");
                try {
                    clientMgr.deleteClients(clientsIds);
                } catch (SQLException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward("ClientServlet?op=unHandledClients", request, response);
                break;

            case 181:
                servedPage = "docs/reports/frstLstApp.jsp";

                String frmDtVl = request.getParameter("frmDt");
                String tdtVl = request.getParameter("tDt");
                String employeeID = request.getParameter("employeeID");
                java.util.Date frmDate = new java.util.Date();
                java.util.Date tDate = new java.util.Date();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (frmDtVl != null) {
                        frmDate = new java.sql.Date(sdf.parse(frmDtVl).getTime());
                    }

                    if (tdtVl != null) {
                        tDate = new java.sql.Date(sdf.parse(tdtVl).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                userMgr = UserMgr.getInstance();
                request.setAttribute("employees", userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId")));
                departments = new ArrayList<WebBusinessObject>();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                selectedDepartment = request.getParameter("departmentID");
                try {
                    userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                        ArrayList list = new ArrayList<>();
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                ArrayList<WebBusinessObject> employeeList = new ArrayList<WebBusinessObject>();
                if (selectedDepartment != null && selectedDepartment.equals("")) {
                    for (WebBusinessObject departmentWbo1 : departments) {
                        if (departmentWbo1 != null) {
                            employeeList.addAll(userMgr.getEmployeeByDepartmentId((String) departmentWbo1.getAttribute("projectID"), null, null));
                        }
                    }
                } else {
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                }
                // clientMgr.frstLstApp(frmDate, tDate);
                ArrayList<WebBusinessObject> clntLst = clientMgr.frstLstApp1(frmDate, tDate, (String) persistentUser.getAttribute("userId"), selectedDepartment, employeeID);

                request.setAttribute("frmDtVl", frmDtVl);
                request.setAttribute("tdtVl", tdtVl);
                request.setAttribute("clntLst", clntLst);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("employeeID", request.getParameter("employeeID"));
                request.setAttribute("departments", departments);
                request.setAttribute("departmentID", selectedDepartment);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 182:
                servedPage = "/docs/client/inter_local_clients.jsp";

                clientMgr = ClientMgr.getInstance();

                ArrayList<WebBusinessObject> interLocalClients = clientMgr.getInterLocalClients();
                ArrayList dataList2 = new ArrayList();
                if (!interLocalClients.isEmpty()) {

                    totalClientsCount = 0;

                    for (WebBusinessObject clientCountWbo : interLocalClients) {
                        totalClientsCount += Integer.parseInt(clientCountWbo.getAttribute("Total_Clients").toString());

                    }

                    for (WebBusinessObject clientCountWbo : interLocalClients) {
                        HashMap dataEntryMap = new HashMap();

                        dataEntryMap.put("name", clientCountWbo.getAttribute("clientTyp"));
                        dataEntryMap.put("y", Integer.parseInt(clientCountWbo.getAttribute("Total_Clients").toString()) * 100 / totalClientsCount);

                        dataList2.add(dataEntryMap);

                    }
                }

                String jsonCallResultText = JSONValue.toJSONString(dataList2);
                request.setAttribute("jsonCallResultText", jsonCallResultText);
                request.setAttribute("interLocalClientsLst", interLocalClients);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 183:
                servedPage = "docs/client/closedRatedClients.jsp";
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                String toDateStr = request.getParameter("toDate") != null ? request.getParameter("toDate") : sdf.format(c.getTime());

                String duration = request.getParameter("duration");
                if (duration != null && !duration.isEmpty()) {
                    switch (duration) {
                        case "oneDay":
                            c.add(Calendar.DAY_OF_MONTH, -1);
                            break;
                        case "oneWeek":
                            c.add(Calendar.WEEK_OF_MONTH, -1);
                            break;
                        case "twoWeeks":
                            c.add(Calendar.WEEK_OF_MONTH, -2);
                            break;
                        case "threeWeeks":
                            c.add(Calendar.WEEK_OF_MONTH, -3);
                            break;
                        case "fourWeeks":
                            c.add(Calendar.WEEK_OF_MONTH, -4);
                            break;
                        case "twoMonth":
                            c.add(Calendar.MONTH, -2);
                            break;
                        case "year":
                            c.add(Calendar.YEAR, -1);
                            break;
                    }
                } else {
                    c.add(Calendar.MONTH, -1);
                }
                String fromDateStr = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(c.getTime());

                ArrayList<WebBusinessObject> clsdRtClntLst = clientMgr.getClosedRatedClients(fromDateStr, toDateStr);
                request.setAttribute("clsdRtClntLst", clsdRtClntLst);
                request.setAttribute("duration", duration);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 184:
                servedPage = "/docs/client/client_class_with_project.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                mainClientRate = request.getParameter("mainClientRate");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                projectID = request.getParameter("projectID");
                hashTag = request.getParameter("hashTag");
                if (toDate == null) {
                    c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -14);
                    fromDate = sdf.format(c.getTime());
                }

                ratesList = new ArrayList<>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    clientsList = clientMgr.getCustomersClassification((String) loggedUser.getAttribute("userId"),
                            new Timestamp(sdf.parse(fromDate).getTime()), new Timestamp(sdf.parse(toDate).getTime()), mainClientRate, projectID, hashTag, null, null);
                    for (WebBusinessObject clientTempWbo : clientsList) {
                        clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
                    }

                    request.setAttribute("clientsList", clientsList);
                } catch (ParseException ex) {
                    request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
                }

                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> projectList = new ArrayList<WebBusinessObject>();
                try {
                    projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("projectList", projectList);
                request.setAttribute("projectID", projectID);
                request.setAttribute("hashTag", hashTag);

                request.setAttribute("ratesList", ratesList);
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("mainClientRate", mainClientRate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 185:
                servedPage = "/docs/client/classifiedClientsLastComments.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                mainClientRate = request.getParameter("mainClientRate");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                projectID = request.getParameter("projectID");
                hashTag = request.getParameter("hashTag");
                if (toDate == null) {
                    c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -14);
                    fromDate = sdf.format(c.getTime());
                }

                ratesList = new ArrayList<>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    clientsList = clientMgr.getClassifiedClientsLastComments((String) loggedUser.getAttribute("userId"),
                            new Timestamp(sdf.parse(fromDate).getTime()), new Timestamp(sdf.parse(toDate).getTime()), mainClientRate, projectID, hashTag);
                    for (WebBusinessObject clientTempWbo : clientsList) {
                        clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
                    }

                    request.setAttribute("clientsList", clientsList);
                } catch (ParseException ex) {
                    request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
                }

                projectMgr = ProjectMgr.getInstance();
                projectList = new ArrayList<WebBusinessObject>();
                try {
                    projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("projectList", projectList);
                request.setAttribute("projectID", projectID);
                request.setAttribute("hashTag", hashTag);

                request.setAttribute("ratesList", ratesList);
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("mainClientRate", mainClientRate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 186:
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                mainClientRate = request.getParameter("mainClientRate");
                hashTag = request.getParameter("hashTag");
                projectID = request.getParameter("projectID");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (toDate == null) {
                    c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -14);
                    fromDate = sdf.format(c.getTime());
                }

                try {
                    clientsList = clientMgr.getClassifiedClientsLastComments((String) loggedUser.getAttribute("userId"),
                            new Timestamp(sdf.parse(fromDate).getTime()), new Timestamp(sdf.parse(toDate).getTime()), mainClientRate, projectID, hashTag);
                    for (WebBusinessObject clientTempWbo : clientsList) {
                        clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
                    }

                    String[] headerss = {"#", "Client No.", "Client Name", "Creation Time", "Class", "Mobile", "Know Us From", " Last Comment Date ", " Last Comment "};
                    String[] attributess = {"Number", "clientNO", "name", "creationTime", "classTitle", "mobile", "seasonName", "comDate", "lstCom"};
                    String[] dataTypess = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                    headerStr = new String[1];
                    headerStr[0] = "Classified Clients Last Comments";
                    workBook = Tools.createExcelReport("Classified Clients Last Comments", headerStr, null, headerss, attributess, dataTypess, clientsList);
                    c = Calendar.getInstance();
                    fileDate = c.getTime();
                    sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    sdf.applyPattern("yyyy-MM-dd");
                    reportDate = sdf.format(fileDate);
                    filename = "ClassifiedClientsLastComments" + reportDate;
                    try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        try {
                            workBook.write(bos);
                        } finally {
                            bos.close();
                        }

                        byte[] bytes = bos.toByteArray();
                        response.setContentType("application/vnd.ms-excel");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                        response.setContentLength(bytes.length);
                        servletOutputStream.write(bytes, 0, bytes.length);
                        servletOutputStream.flush();
                    }
                } catch (ParseException ex) {
                    request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
                }
                break;

            case 187:
                wbo = removeClientCampaign(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 188:
                wbo = saveExtraInfo(request);
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 189:
                servedPage = "/docs/client/communicationChannelsComparison.jsp";

                String[] chnls = request.getParameterValues("chnlsSelect");
                String yr = request.getParameter("yrSelect");
                String mnth = request.getParameter("mnthSelect");

                seasonMgr = SeasonMgr.getInstance();
                ArrayList<WebBusinessObject> cmntChnlCmprLst = seasonMgr.communicationChannelsComparison(chnls, yr, mnth);
                ArrayList<WebBusinessObject> chnlLst = new ArrayList<WebBusinessObject>(seasonMgr.getCashedTable());

                request.setAttribute("cmntChnlCmprLst", cmntChnlCmprLst);
                request.setAttribute("chnlLst", chnlLst);
                request.setAttribute("chnls", chnls);
                request.setAttribute("yr", yr);
                request.setAttribute("mnth", mnth);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 190:
                servedPage = "/docs/client/channelDistribution.jsp";

                channelTotal = 0;

                if (request.getParameter("fromDate") != null) {
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    try {
                        java.sql.Date fromD = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                        java.sql.Date toD = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                        request.setAttribute("wbo", clientMgr.getClientKnownUsTotal(fromD, toD));
                        ArrayList<String> resultList = new ArrayList<>();
                        ArrayList categories = new ArrayList();
                        ArrayList<WebBusinessObject> channelsList = clientMgr.getClientKnownUsStatistics(fromD, toD);
                        for (WebBusinessObject channelWbo : channelsList) {
                            if (channelWbo.getAttribute("englishName") != null) {
                                categories.add(channelWbo.getAttribute("englishName"));
                                channelTotal += new Integer((String) channelWbo.getAttribute("total"));
                                resultList.add((String) channelWbo.getAttribute("total"));
                            }
                        }
                        Map<String, Object> graphDataMap = new HashMap<>();
                        graphDataMap.put("name", "Channels of Distribution");
                        graphDataMap.put("data", "[" + Tools.arrayToString(resultList.toArray(new String[resultList.size()]), ",") + "]");
                        ArrayList tempList = new ArrayList<>();
                        tempList.add(graphDataMap);
                        String resultsJson = JSONValue.toJSONString(tempList);
                        request.setAttribute("categories", JSONValue.toJSONString(categories));
                        request.setAttribute("channelTotal", channelTotal.toString());
                        request.setAttribute("resultsJson", resultsJson);

                        sdf.applyPattern("yyyy-MM-dd");

                        // populate series data map
                        resultList.clear();
                        categories.clear();

                        graphDataMap = new HashMap<>();
                        graphDataMap.put("name", "Campaigns");
                        graphDataMap.put("data", "[" + Tools.arrayToString(resultList.toArray(new String[resultList.size()]), ",") + "]");
                        tempList.clear();
                        tempList.add(graphDataMap);
                        resultsJson = JSONValue.toJSONString(tempList);
                        request.setAttribute("categoriesCampaign", JSONValue.toJSONString(categories));
                        request.setAttribute("resultsCampaignJson", resultsJson);
                        request.setAttribute("channelsList", channelsList);
                        jsonText = Tools.getJSONArrayAsString(channelsList);
                        request.setAttribute("jsonText", jsonText);
                    } catch (ParseException ex) {
                    }
                }
                request.setAttribute("fromDate", request.getParameter("fromDate"));
                request.setAttribute("toDate", request.getParameter("toDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 191:
                out = response.getWriter();
                wbo = showReferralCustomerAjax(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 192:
                servedPage = "/docs/client/clients_invalid_mobile.jsp";
                request.setAttribute("clientsList", clientMgr.getClientsWithInvalidMobile());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 193:
                out = response.getWriter();
                wbo = informUserAjax(request);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 194:
                frmDtVl = request.getParameter("frmDt");
                tdtVl = request.getParameter("tDt");

                frmDate = new java.util.Date();
                tDate = new java.util.Date();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (frmDtVl != null) {
                        frmDate = new java.sql.Date(sdf.parse(frmDtVl).getTime());
                    }

                    if (tdtVl != null) {
                        tDate = new java.sql.Date(sdf.parse(tdtVl).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                clntLst = clientMgr.frstLstApp(frmDate, tDate);

                String nwHeaders[] = {"#", "Client Name", "First Call Date", "Last Call Date", "Last Call By", "Campaign", "Classification", "Know Us From", "Last Call Comment"};
                String nwAttributes[] = {"Number", "clntNm", "frstDt", "lstDt", "fullNm", "campaign", "rate", "englishNm", "lstCmnt"};
                String nwDataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String"};
                headerStr = new String[1];
                headerStr[0] = "Clients_First_And_Last_Call";
                workBook = Tools.createExcelReport("Clients First And Last Call", headerStr, null, nwHeaders, nwAttributes, nwDataTypes, clntLst);
                c = Calendar.getInstance();
                fileDate = c.getTime();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                sdf.applyPattern("yyyy-MM-dd");
                reportDate = sdf.format(fileDate);
                filename = "Clients First And Last Call" + reportDate;
                try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }

                    byte[] bytes = bos.toByteArray();
                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                }
                break;

            case 195:
                servedPage = "/docs/reports/get_customized_clients.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String employee = request.getParameter("employee");
                String groupId = request.getParameter("groupId");

                channelTotal = 0;
                userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                groupMgr = GroupMgr.getInstance();
                groupsList = new ArrayList<>();
                ArrayList<WebBusinessObject> userGroups = new ArrayList<WebBusinessObject>();

                 {
                    try {
                        userGroups = userGroupConfigMgr.getOnArbitraryKey2(loggedUser.getAttribute("userId").toString(), "key2");
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                if (!userGroups.isEmpty()) {
                    for (WebBusinessObject userGroupsWbo : userGroups) {
                        WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                        groupsList.add(groupWbo);
                    }
                }
                request.setAttribute("groupsList", groupsList);
                request.setAttribute("groupId", request.getParameter("groupId"));

                if (beginDate != null && endDate != null) {
                    ArrayList<WebBusinessObject> customizedClients = new ArrayList<WebBusinessObject>();
                    ArrayList<WebBusinessObject> customizedClientsChart = new ArrayList<WebBusinessObject>();
                    customizedClients = clientMgr.getCustomizedClients(beginDate, endDate, employee, groupId);
                    if (employee != null) {
                        customizedClientsChart = clientMgr.getCustomizedClientsChart(beginDate, endDate, employee, groupId);
                        jsonText = Tools.getJSONArrayAsString(customizedClientsChart);
                        request.setAttribute("jsonText", jsonText);
                    }
                    request.setAttribute("customizedClients", customizedClients);
                }
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("YYYY/MM/dd");

                if (endDate == null) {
                    endDate = sdf.format(cal.getTime());
                }

                cal.add(Calendar.DAY_OF_WEEK, -1);
                if (beginDate == null) {
                    beginDate = sdf.format(cal.getTime());
                }
                request.setAttribute("employee", employee);
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 196:
                clientsList = clientMgr.getClientByNameOrCode(request.getParameter("value"));
                servedPage = "/docs/client/clients_popup.jsp";
                request.setAttribute("clientsList", clientsList);
                this.forward(servedPage, request, response);
                break;
            case 197:
                servedPage = "/docs/client/campaignsCamparison.jsp";

                chnls = request.getParameterValues("chnlsSelect");
                yr = request.getParameter("yrSelect");
                mnth = request.getParameter("mnthSelect");
                cmntChnlCmprLst = new ArrayList<WebBusinessObject>();
                campaignMgr = CampaignMgr.getInstance();
                if (yr != null) {
                    try {
                        cmntChnlCmprLst = campaignMgr.campaignsComparison(chnls, yr, mnth);
                    } catch (SQLException ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                chnlLst = new ArrayList<WebBusinessObject>(campaignMgr.getCashedTable());
                request.setAttribute("cmntChnlCmprLst", cmntChnlCmprLst);
                request.setAttribute("chnlLst", chnlLst);
                request.setAttribute("chnls", chnls);
                request.setAttribute("yr", yr);
                request.setAttribute("mnth", mnth);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 198:
                WebBusinessObject mailStatus = new WebBusinessObject();
                out = response.getWriter();
                String clientMail = request.getParameter("email");
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                boolean existMail = IsExistEmailforClient(loggedUser, clientMail);
                if (existMail == true) {
                    mailStatus.setAttribute("exist", "true");
                } else {
                    mailStatus.setAttribute("exist", "false");
                }
                out.write(Tools.getJSONObjectAsString(mailStatus));
                break;
            case 199:
                servedPage = "/docs/client/clients_extra_phones.jsp";
                clientMgr = ClientMgr.getInstance();
                request.setAttribute("clientsList", clientMgr.getClientsWithExtraPhones());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 200:
                servedPage = "/docs/client/classifiedClientLastCallComments.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                mainClientRate = request.getParameter("mainClientRate");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                projectID = request.getParameter("projectID");
                hashTag = request.getParameter("hashTag");
                if (toDate == null) {
                    c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -14);
                    fromDate = sdf.format(c.getTime());
                }

                ratesList = new ArrayList<>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    clientsList = clientMgr.getClassifiedClientsLastCallComments((String) loggedUser.getAttribute("userId"),
                            new Timestamp(sdf.parse(fromDate).getTime()), new Timestamp(sdf.parse(toDate).getTime()), mainClientRate, projectID, hashTag);
                    for (WebBusinessObject clientTempWbo : clientsList) {
                        clientTempWbo.setAttribute("creationTime", ((String) clientTempWbo.getAttribute("creationTime")).substring(0, 16));
                    }

                    request.setAttribute("clientsList", clientsList);
                } catch (ParseException ex) {
                    request.setAttribute("clientsList", new ArrayList<WebBusinessObject>());
                }

                projectMgr = ProjectMgr.getInstance();
                projectList = new ArrayList<WebBusinessObject>();
                try {
                    projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("projectList", projectList);
                request.setAttribute("projectID", projectID);
                request.setAttribute("hashTag", hashTag);

                request.setAttribute("ratesList", ratesList);
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("mainClientRate", mainClientRate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 201:
                servedPage = "/docs/client/campaign_clients_non_sold_report.jsp";
                reservationMgr = ReservationMgr.getInstance();
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                campaignID = request.getParameter("campaignID");
                campaignMgr = CampaignMgr.getInstance();
                request.setAttribute("data", clientMgr.getCampaignNonSoldClients(campaignID, beginDate, endDate));
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("campaignWbo", campaignMgr.getOnSingleKey(campaignID));
                request.setAttribute("campaignID", campaignID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 202:
                clientProductMgr = ClientProductMgr.getInstance();
                wbo = clientProductMgr.getReserveSellUser(request.getParameter("unitID"), request.getParameter("type"));
                out = response.getWriter();
                if (wbo != null) {
                    wbo.setAttribute("status", "ok");
                } else {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "fail");
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 203:
                out = response.getWriter();
                clientId = request.getParameter("clientID");
                String disputeReason = request.getParameter("reason");
                String status1 = " ";
                issueId = request.getParameter("issueId");
                issueMgr = IssueMgr.getInstance();
                try {
                    status1 = clientMgr.confirmClientLegalDispute(persistentUser, clientId, disputeReason);
                } catch (Exception exq) {
                    status1 = "none";
                }
                if (issueId == null || issueId.isEmpty()) {
                    issueId = issueMgr.getLastIssueForClient(clientId);
                }
                if (status1.equals("ok")) {

                    if (issueId != null && !issueId.isEmpty()) {
                        try {
                            //For logging Withdraw Client
                            WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                            ClientMgr clientMgr = ClientMgr.getInstance();
                            if (issueWbo != null) {
                                clientID = (String) issueWbo.getAttribute("clientId");
                                if (clientID == null || clientID.isEmpty()) {
                                    clientID = (String) request.getParameter("clientId");
                                }
                                clientWbo = clientMgr.getOnSingleKey(clientID);
                            } else {
                                clientWbo = null;
                                clientID = null;
                            }
                            loggerWbo = new WebBusinessObject();
                            WebBusinessObject clientComplaintWbo = ClientComplaintsMgr.getInstance().getClientComplaintByIssueAndType(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER);
                            loggerWbo.setAttribute("objectXml", clientComplaintWbo != null ? clientComplaintWbo.getObjectAsXML() : issueWbo.getObjectAsXML());
                            loggerWbo.setAttribute("realObjectId", clientID == null ? "---" : clientID);
                            loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                            loggerWbo.setAttribute("objectName", clientWbo != null ? clientWbo.getAttribute("clientNO") : "---");
                            loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                            loggerWbo.setAttribute("eventName", "Withdraw");
                            loggerWbo.setAttribute("objectTypeId", "1");
                            loggerWbo.setAttribute("eventTypeId", "5");
                            loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                            String callStatus = (String) issueWbo.getAttribute("issueType");
                            String callType = (String) issueWbo.getAttribute("callType");
                            securityUser = (SecurityUser) session.getAttribute("securityUser");
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            comment = request.getParameter("requestType");
                            ArrayList<WebBusinessObject> distributionList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(issueId));
                            if (issueMgr.addWithdrawInfo((String) persistentUser.getAttribute("userId"), distributionList, clientWbo, loggerWbo)
                                    && issueMgr.deleteAllIssueData(issueId) && AppointmentMgr.getInstance().deleteAllFutureAppointments(clientID)) {
                                request.setAttribute("status", "ok");
                                status1 = "ok";
                                if (request.getParameter("employeeID") != null) {
                                    try {
                                        if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                                            issueId = issueMgr.saveCallDataAuto(clientID, callType, callStatus, session, "issue", persistentUser);
                                        }
                                    } catch (NoUserInSessionException | SQLException ex) {
                                        logger.error(ex);
                                    }
                                    try {
                                        if (issueId != null) {
                                            clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"),
                                                    request.getParameter("employeeID"), issueId, "2", null,
                                                    comment, comment, comment);
                                        }
                                    } catch (SQLException ex) {
                                        logger.error(ex);
                                    }
                                }
                            } else {
                                request.setAttribute("status", "fail");
                            }
                        } catch (SQLException ex) {
                            logger.error(ex);
                            request.setAttribute("status", "fail");
                        }
                    }
                }
                WebBusinessObject statusWbo = new WebBusinessObject();
                statusWbo.setAttribute("status", status1);
                out.write(Tools.getJSONObjectAsString(statusWbo));
                break;
            case 204:
                wbo = new WebBusinessObject();
                try {
                    if (request.getParameter("appointmentID") != null) { // when updating appointment
                        WebBusinessObject appointment = appointmentMgr.getOnSingleKey(request.getParameter("appointmentID"));
                        if (appointmentMgr.caredAppointment(request.getParameter("appointmentID"))) {
                            appointmentMgr.updateAppointmentComment(request.getParameter("appointmentID"), "Canceled",
                                    (String) appointment.getAttribute("appointmentPlace"), "0");
                        }
                    }
                    sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                    if (appointmentMgr.saveAppointment(request.getParameter("userID"), request.getParameter("clientID"),
                            "FOLLOW UP", sdf.parse(request.getParameter("meetingDate")), "meeting", "meeting",
                            request.getParameter("appointmentPlace"), null, null, request.getParameter("comment"),
                            CRMConstants.APPOINTMENT_STATUS_OPEN, securityUser.getDefaultCampaign(), null, "Public",
                            0, null, null, "UL", (String) persistentUser.getAttribute("userId"))) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (NoUserInSessionException | SQLException | ParseException ex) {
                    logger.error(ex);
                    wbo.setAttribute("status", "no");
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 205:
                wbo = new WebBusinessObject();
                try {
                    if (request.getParameter("appointmentID") != null) { // when updating appointment
                        WebBusinessObject appointment = appointmentMgr.getOnSingleKey(request.getParameter("appointmentID"));
                        if (appointmentMgr.caredAppointment(request.getParameter("appointmentID"))) {
                            appointmentMgr.updateAppointmentComment(request.getParameter("appointmentID"), "Canceled for " + request.getParameter("comment"),
                                    (String) appointment.getAttribute("appointmentPlace"), "0");
                            wbo.setAttribute("status", "ok");
                        }
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                    wbo.setAttribute("status", "no");
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 206:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                arName = request.getParameter("regionNameAr");
                code = UniqueIDGen.getNextID();
                wbo.setAttribute("ID", code);
                wbo.setAttribute("code", code);
                wbo.setAttribute("name", arName);
                try {
                    regionMgr = RegionMgr.getInstance();
                    if (regionMgr.saveObject(wbo, session)) {
                        wbo.setAttribute("Status", "Ok");
                        wbo.setAttribute("ID", code);
                        wbo.setAttribute("name", arName);
                    } else {
                        wbo.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 207:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                arName = request.getParameter("activityNameAr");
                code = UniqueIDGen.getNextID();
                wbo.setAttribute("arName", arName);
                wbo.setAttribute("code", arName);
                wbo.setAttribute("secondID", code);

                wbo.setAttribute("enName", arName);
                wbo.setAttribute("ttradeTypeId", "2");
                try {
                    tradeMgr = TradeMgr.getInstance();
                    String idActivity = tradeMgr.saveObjectForClient(wbo, session);
                    if (idActivity.equals("ok")) {
                        wbo.setAttribute("Status", "Ok");
                        wbo.setAttribute("code", code);
                        wbo.setAttribute("name", arName);
                    } else {
                        wbo.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            default:       
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
        return "Short description";
    }// </editor-fold>

    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("GetClientForm")) {
            return 1;
        } else if (opName.equals("SaveClient")) {
            return 2;
        } else if (opName.equals("ListClients")) {
            return 3;
        } else if (opName.equals("ViewClient")) {
            return 4;
        } else if (opName.equals("GetUpdateForm")) {
            return 5;
        } else if (opName.equals("UpdateClient")) {
            return 6;
        } else if (opName.equals("ConfirmDeleteClient")) {
            return 7;
        } else if (opName.equals("Delete")) {
            return 8;
        } else if (opName.equalsIgnoreCase("closeClientSideMenu")) {
            return 9;
        } else if (opName.equals("GetClientForm2")) {
            return 10;
        } else if (opName.equals("SaveClient2")) {
            return 11;
        } else if (opName.equals("getClientNumber")) {
            return 12;
        } else if (opName.equals("callDate")) {
            return 13;
        } else if (opName.equals("GetJobForm")) {
            return 14;
        } else if (opName.equals("saveJob")) {
            return 15;
        } else if (opName.equals("email")) {
            return 16;
        } else if (opName.equals("sms")) {
            return 17;
        } else if (opName.equals("attachGradesToCustomer")) {
            return 18;
        } else if (opName.equals("getCustomers")) {
            return 19;
        } else if (opName.equals("updateCustomerGrade")) {
            return 20;
        } else if (opName.equals("attachEmployeesToCLient")) {
            return 21;
        } else if (opName.equals("getClients")) {
            return 22;
        } else if (opName.equals("updateEqpEmp")) {
            return 23;
        } else if (opName.equals("getClientEmployees")) {
            return 24;
        } else if (opName.equals("iPad")) {
            return 25;
        } else if (opName.equals("updateCounter")) {
            return 26;
        } else if (opName.equals("getCounter")) {
            return 27;
        } else if (opName.equals("saveAppointment")) {
            return 28;
        } else if (opName.equals("saveComment")) {
            return 29;
        } else if (opName.equals("show")) {
            return 31;
        } else if (opName.equals("showAppointment")) {
            return 32;
        } else if (opName.equals("removeAppointment")) {
            return 33;
        } else if (opName.equals("updateAppointment")) {
            return 34;
        } else if (opName.equals("removeComment")) {
            return 35;
        } else if (opName.equals("updateComment")) {
            return 36;
        } else if (opName.equals("show2")) {
            return 37;
        } else if (opName.equals("showCampaigns")) {
            return 38;
        } else if (opName.equals("updateCampaign")) {
            return 39;
        } else if (opName.equals("removeCampaign")) {
            return 40;
        } else if (opName.equals("updateCustomerGrade2")) {
            return 41;
        } else if (opName.equals("customerReport")) {
            return 42;
        } else if (opName.equals("saveRegion")) {
            return 43;
        } else if (opName.equals("UpdateClientAjax")) {
            return 44;
        } else if (opName.equals("getClientName")) {
            return 45;
        } else if (opName.equals("GetCompanyForm")) {
            return 46;
        } else if (opName.equals("saveCompany")) {
            return 47;
        } else if (opName.equals("UpdateCompanyAjax")) {
            return 48;
        } else if (opName.equals("userAppo")) {
            return 49;
        } else if (opName.equals("userAppoNumber")) {
            return 50;
        } else if (opName.equals("show3")) {
            return 51;
        } else if (opName.equals("showClientInformation")) {
            return 52;
        } else if (opName.equals("checkClientName")) {
            return 53;
        } else if (opName.equals("GetContractorForm")) {
            return 54;
        } else if (opName.equals("saveContractor")) {
            return 55;
        } else if (opName.equals("ViewJobs")) {
            return 56;
        } else if (opName.equals("confirmDeleteJob")) {
            return 57;
        } else if (opName.equals("deleteJob")) {
            return 58;
        } else if (opName.equals("listJob")) {
            return 56;
        } else if (opName.equals("ViewThisJob")) {
            return 60;
        } else if (opName.equals("UpdateTradeType")) {
            return 61;
        } else if (opName.equals("UpdateThisJob")) {
            return 62;
        } else if (opName.equals("addCommentChannel")) {
            return 63;
        } else if (opName.equals("changeClientStatus")) {
            return 64;
        } else if (opName.equals("saveClientCampaignsByAjax")) {
            return 65;
        } else if (opName.equals("saveClientIncentivesByAjax")) {
            return 66;
        } else if (opName.equals("getClientNameByNo")) {
            return 67;
        } else if (opName.equals("getClientPhone")) {
            return 68;
        } else if (opName.equals("getClientMobile")) {
            return 69;
        } else if (opName.equals("unHandledClients")) {
            return 70;
        } else if (opName.equals("getClientByNum")) {
            return 71;
        } else if (opName.equals("getUpdateClientForm")) {
            return 72;
        } else if (opName.equals("UpdateClientData")) {
            return 73;
        } else if (opName.equals("getClientsWithDetails")) {
            return 74;
        } else if (opName.equals("SaveClientByAjax")) {
            return 75;
        } else if (opName.equals("getClientByNumAjax")) {
            return 76;
        } else if (opName.equals("getContractorsList")) {
            return 77;
        } else if (opName.equals("distributeNewClient")) {
            return 78;
        } else if (opName.equals("viewClientCommunications")) {
            return 79;
        } else if (opName.equals("addClientCommunication")) {
            return 80;
        } else if (opName.equals("deleteClientCommunication")) {
            return 81;
        } else if (opName.equals("saveManualDistribution")) {
            return 82;
        } else if (opName.equals("distributedClients")) {
            return 83;
        } else if (opName.equals("clientDetails")) {
            return 84;
        } else if (opName.equals("getUpdateContractorForm")) {
            return 85;
        } else if (opName.equals("updateContractor")) {
            return 86;
        } else if (opName.equals("confirmDeleteContractor")) {
            return 87;
        } else if (opName.equals("deleteContractor")) {
            return 88;
        } else if (opName.equals("updateClientsRules")) {
            return 89;
        } else if (opName.equals("saveFollowUpAppointment")) {
            return 90;
        } else if (opName.equals("nonFollowers")) {
            return 91;
        } else if (opName.equals("appointmentsCountAjax")) {
            return 92;
        } else if (opName.equals("myUnhandledClients")) {
            return 93;
        } else if (opName.equals("myDistributedClients")) {
            return 94;
        } else if (opName.equals("showClientCampaigns")) {
            return 95;
        } else if (opName.equals("getLastClientCall")) {
            return 96;
        } else if (opName.equals("getClientsByProjectForm")) {
            return 97;
        } else if (opName.equals("getClientsByProject")) {
            return 98;
        } else if (opName.equals("getClientsPerEmployee")) {
            return 99;
        } else if (opName.equals("getClosedClients")) {
            return 100;
        } else if (opName.equalsIgnoreCase("getClientHistory")) {
            return 101;
        } else if (opName.equalsIgnoreCase("getUnitsListAjax")) {
            return 102;
        } else if (opName.equalsIgnoreCase("getClientsContracts")) {
            return 103;
        } else if (opName.equalsIgnoreCase("getCampaignClients")) {
            return 104;
        } else if (opName.equalsIgnoreCase("showClientHistory")) {
            return 105;
        } else if (opName.equalsIgnoreCase("distributeDone")) {
            return 106;
        } else if (opName.equals("employeeWorkPDF")) {
            return 107;
        } else if (opName.equals("getClientInterPhone")) {
            return 108;
        } else if (opName.equalsIgnoreCase("listClientsWithNoComments")) {
            return 109;
        } else if (opName.equalsIgnoreCase("deleteComplaintStatusAjax")) {
            return 110;
        } else if (opName.equalsIgnoreCase("generateCallingPlan")) {
            return 111;
        } else if (opName.equalsIgnoreCase("getClientCampaigns")) {
            return 112;
        } else if (opName.equalsIgnoreCase("listCallingPlans")) {
            return 113;
        } else if (opName.equalsIgnoreCase("getUnCommentClientsDetailesPDF")) {
            return 114;
        } else if (opName.equalsIgnoreCase("getUnCommentClientsBriefPDF")) {
            return 115;
        } else if (opName.equalsIgnoreCase("getClientRating")) {
            return 116;
        } else if (opName.equalsIgnoreCase("updateClientStatus")) {
            return 117;
        } else if (opName.equalsIgnoreCase("myCallingPlans")) {
            return 118;
        } else if (opName.equalsIgnoreCase("getEmployeeClientsWithCampaign")) {
            return 119;
        } else if (opName.equalsIgnoreCase("changeClientRate")) {
            return 120;
        } else if (opName.equalsIgnoreCase("getClientClass")) {
            return 121;
        } else if (opName.equalsIgnoreCase("getClientClassExcel")) {
            return 122;
        } else if (opName.equalsIgnoreCase("repeatedClientsByTelephone")) {
            return 123;
        } else if (opName.equalsIgnoreCase("updateClientsByTelephone")) {
            return 124;
        } else if (opName.equalsIgnoreCase("updateClientMobile")) {
            return 125;
        } else if (opName.equals("saveSeason")) {
            return 126;
        } else if (opName.equals("InternationalClients")) {
            return 127;
        } else if (opName.equals("getInternationalClients")) {
            return 128;
        } else if (opName.equals("InterClientsNoCommApp")) {
            return 129;
        } else if (opName.equals("getInterClientsNoCommApp")) {
            return 130;
        } else if (opName.equals("redirectClientComplaint")) {
            return 131;
        } else if (opName.equals("getmailbox")) {
            return 132;
        } else if (opName.equals("distributedClientsForPagination")) {
            return 133;
        } else if (opName.equals("DeleteRepeatedClient")) {
            return 134;
        } else if (opName.equals("viewClientPopup")) {
            return 135;
        } else if (opName.equals("redirectClientComplaint2")) {
            return 136;
        } else if (opName.equals("getCampaignClientsExcel")) {
            return 137;
        } else if (opName.equals("getClientsForCampaign")) {
            return 138;
        } else if (opName.equals("saveClientsToCampaign")) {
            return 139;
        } else if (opName.equals("moveClientsToCampaign")) {
            return 140;
        } else if (opName.equals("saveClientCampaign")) {
            return 141;
        } else if (opName.equals("getCampaignClientsRating")) {
            return 142;
        } else if (opName.equals("getMyClientComplaints")) {
            return 143;
        } else if (opName.equals("customizeClient")) {
            return 144;
        } else if (opName.equals("specialDistribute")) {
            return 145;
        } else if (opName.equals("lockClientByUsrID")) {
            return 146;
        } else if (opName.equals("ViewClientMenu")) {
            return 147;
        } else if (opName.equals("reenteredClients")) {
            return 148;
        } else if (opName.equals("getClientsAppntmsPerEmployee")) {
            return 149;
        } else if (opName.equals("ViewClientsAppntmsPerEmployee")) {
            return 150;
        } else if (opName.equals("ViewEmpClientAppntmnts")) {
            return 151;
        } else if (opName.equals("getEmpTagTypes")) {
            return 152;
        } else if (opName.equals("getClientFirstCommentAppointment")) {
            return 153;
        } else if (opName.equals("withdrawFromDetails")) {
            return 154;
        } else if (opName.equals("channelsDistribution")) {
            return 155;
        } else if (opName.equals("listClientsPopup")) {
            return 156;
        } else if (opName.equals("getEmpDistCalls")) {
            return 157;
        } else if (opName.equals("getEmpDistCallsDetails")) {
            return 158;
        } else if (opName.equals("getEmpDistMeeting")) {
            return 159;
        } else if (opName.equals("getEmpDistMeetingDetails")) {
            return 160;
        } else if (opName.equals("getClientProject")) {
            return 161;
        } else if (opName.equals("listClientsOwnerPopup")) {
            return 162;
        } else if (opName.equalsIgnoreCase("owendPrjUnit")) {
            return 163;
        } else if (opName.equals("getCustomerServiceReport")) {
            return 164;
        } else if (opName.equals("getRequestsByUserInPeriod")) {
            return 165;
        } else if (opName.equals("redirectClients")) {
            return 166;
        } else if (opName.equals("getDistributionRequestsReport")) {
            return 167;
        } else if (opName.equals("getRequestsByOwnerInPeriod")) {
            return 168;
        } else if (opName.equals("clientDetailsOrder")) {
            return 169;
        } else if (opName.equals("getNewRequest")) {
            return 170;
        } else if (opName.equals("getClientByBusinessNo")) {
            return 171;
        } else if (opName.equals("getCampaignSoldClients")) {
            return 172;
        } else if (opName.equals("newBokerClient")) {
            return 173;
        } else if (opName.equals("saveClientBoker")) {
            return 174;
        } else if (opName.equals("updateClientBoker")) {
            return 175;
        } else if (opName.equals("addToCart")) {
            return 176;
        } else if (opName.equals("SpecialEmails")) {
            return 177;
        } else if (opName.equals("salesMail")) {
            return 178;
        } else if (opName.equals("getClientByyMobileAjax")) {
            return 179;
        } else if (opName.equals("deleteClients")) {
            return 180;
        } else if (opName.equals("frstLstApp")) {
            return 181;
        } else if (opName.equals("interLocalClients")) {
            return 182;
        } else if (opName.equals("getClosedRatedClients")) {
            return 183;
        } else if (opName.equals("getClientClassWithProject")) {
            return 184;
        } else if (opName.equals("getClassifiedClientsLastComments")) {
            return 185;
        } else if (opName.equals("getClassifiedClientsLastCommentsExcel")) {
            return 186;
        } else if (opName.equals("removeClientCampaign")) {
            return 187;
        } else if (opName.equals("saveExtraInfo")) {
            return 188;
        } else if (opName.equals("communicationChannelsComparison")) {
            return 189;
        } else if (opName.equals("channelsDistributionAnalysis")) {
            return 190;
        } else if (opName.equals("showReferralCustomerAjax")) {
            return 191;
        } else if (opName.equals("getClientsWithInvalidMobile")) {
            return 192;
        } else if (opName.equals("informUserAjax")) {
            return 193;
        } else if (opName.equals("frstLstAppExcel")) {
            return 194;
        } else if (opName.equals("getAllCustomizedClnts")) {
            return 195;
        } else if (opName.equals("getClientsPopup")) {
            return 196;
        } else if (opName.equals("campaignsComparison")) {
            return 197;
        } else if (opName.equals("getClientMail")) {
            return 198;
        } else if (opName.equals("getClientsWithExtraPhones")) {
            return 199;
        } else if (opName.equals("getClassifiedClientsLastCallComments")) {
            return 200;
        } else if (opName.equals("getCampaignNonSoldClients")) {
            return 201;
        } else if (opName.equals("getReserveSellUserAjax")) {
            return 202;
        } else if (opName.equals("confirmClientLegalDispute")) {
            return 203;
        } else if (opName.equals("saveUserAppointment")) {
            return 204;
        } else if (opName.equals("cancelAppointment")) {
            return 205;
        }else if (opName.equals("saveRegionN")) {
            return 206;
        }else if (opName.equals("saveNewActivity")) {
            return 207;
        }
        return 0;
    }

    private WebBusinessObject getUnitsListAjax(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        String clientId = request.getParameter("clientId");
        wbo = new WebBusinessObject();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        try {
            ArrayList<WebBusinessObject> unitsList = new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle(clientId,
                    "key1", "purche", "key4"));
            StringBuilder unitsCodes = new StringBuilder();
            for (WebBusinessObject unitWbo : unitsList) {
                unitsCodes.append((String) unitWbo.getAttribute("productName")).append(",");
            }

            if (unitsCodes.length() > 0) {
                unitsCodes.setLength(unitsCodes.length() - 1);
            }
            wbo.setAttribute("unitsCodes", unitsCodes.toString());
        } catch (Exception ex) {
            Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
        }
        return wbo;
    }

    private WebBusinessObject getClientInterPhone(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        String interPhone = request.getParameter("interPhone");
        wbo = clientMgr.getOnSingleKey("key10", interPhone);
        if (wbo != null) {
            wbo.setAttribute("status", "Ok");
        } else {
            if (wbo == null) {
                wbo = new WebBusinessObject();
            }
            wbo.setAttribute("status", "No");
        }
        return wbo;
    }

    private WebBusinessObject deleteComplaintStatusAjax(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
        wbo.setAttribute("status", "no");
        if (issueStatusMgr.deleteOnSingleKey(request.getParameter("statusID"))) {
            wbo.setAttribute("status", "Ok");
        }
        return wbo;
    }

    private WebBusinessObject updateClientStatus(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        String newStatusCode = request.getParameter("newStatusCode");
        wbo.setAttribute("statusCode", newStatusCode);
        wbo.setAttribute("date", request.getParameter("statusDate"));
        wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
        wbo.setAttribute("statusNote", request.getParameter("comment"));
        wbo.setAttribute("objectType", "client");
        wbo.setAttribute("parentId", "UL");
        wbo.setAttribute("issueTitle", "UL");
        wbo.setAttribute("cuseDescription", "UL");
        wbo.setAttribute("actionTaken", "UL");
        wbo.setAttribute("preventionTaken", "UL");
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
        wbo.setAttribute("status", "no");
        try {
            if (issueStatusMgr.changeStatus(wbo, persistentUser, null)
                    && clientMgr.updateClientStatus(request.getParameter("clientId"), newStatusCode, (WebBusinessObject) request.getSession().getAttribute("loggedUser"))) {
                wbo.setAttribute("status", "Ok");
            }
        } catch (SQLException ex) {
            logger.error(ex);
        }
        return wbo;
    }

    private WebBusinessObject changeClientRate(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        String clientID = request.getParameter("clientID");
        String rateIDName = request.getParameter("rateID");
        String rateID = ProjectMgr.getInstance().getByKeyColumnValue("key1", rateIDName, "key");
        ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        try {
            clientRatingMgr.deleteOnArbitraryKey(clientID, "key1");
        } catch (Exception ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        wbo = new WebBusinessObject();
        wbo.setAttribute("clientID", clientID);
        wbo.setAttribute("rateID", rateID);
        wbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
        wbo.setAttribute("option1", "UL");
        wbo.setAttribute("option2", "UL");
        wbo.setAttribute("option3", "UL");
        if (clientRatingMgr.saveObject(wbo)) {
            wbo.setAttribute("status", "ok");
        } else {
            wbo.setAttribute("status", "fail");
        }
        return wbo;
    }

    private WebBusinessObject saveSeason(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        if (SeasonMgr.getInstance().saveSeason(request, request.getSession())) {
            wbo.setAttribute("status", "ok");
            wbo.setAttribute("code", request.getParameter("code"));
            wbo.setAttribute("name", request.getParameter("arabic_name"));
        } else {
            wbo.setAttribute("status", "fail");
        }
        return wbo;
    }

    private WebBusinessObject redirectClientComplaint(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject activeComplaintWbo = clientComplaintsMgr.getActiveClientComplaint(request.getParameter("clientID"));
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        appointmentMgr = AppointmentMgr.getInstance();
        issueMgr = IssueMgr.getInstance();
        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
        ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
        String employeeId = request.getParameter("employeeId");
        String ticketType = request.getParameter("ticketType");
        String clientID = request.getParameter("clientID");
        String comment = request.getParameter("comment");
        String subject = request.getParameter("subject");
        String notes = request.getParameter("notes");
        String issueId, clientComplaintId;
        if (activeComplaintWbo != null) {
            issueId = (String) activeComplaintWbo.getAttribute("issueID");
            clientComplaintId = (String) activeComplaintWbo.getAttribute("clientComplaintID");
        } else {
            WebBusinessObject wboTemp = new WebBusinessObject();
            wboTemp.setAttribute("notes", ticketType);
            wboTemp.setAttribute("userId", persistentUser.getAttribute("userId"));
            wboTemp.setAttribute("clientId", clientID);
            wboTemp.setAttribute("entryDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
            try {
                issueId = issueMgr.saveAutoData(wboTemp);
            } catch (NoUserInSessionException | SQLException ex) {
                issueId = null;
            }
            clientComplaintId = null;
        }
        String businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
        try {
            if (issueId != null) {
                String newClientComplaintId = clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"),
                        employeeId, issueId, ticketType, businessId, comment, subject, notes);
                if (newClientComplaintId != null) {
                    boolean done;
                    if (clientComplaintId != null) {
                        WebBusinessObject issueStatusWbo = new WebBusinessObject();
                        issueStatusWbo.setAttribute("parentId", issueId);
                        issueStatusWbo.setAttribute("businessObjectId", clientComplaintId);
                        issueStatusWbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
                        issueStatusWbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                        issueStatusWbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        issueStatusWbo.setAttribute("issueTitle", "UL");
                        issueStatusWbo.setAttribute("statusNote", notes);
                        issueStatusWbo.setAttribute("cuseDescription", "UL");
                        issueStatusWbo.setAttribute("actionTaken", "UL");
                        issueStatusWbo.setAttribute("preventionTaken", "UL");
                        done = issueStatusMgr.changeStatus(issueStatusWbo, persistentUser, ActionEvent.getClientComplaintsActionEvent());
                    } else {
                        done = true;
                    }
                    if (done) {
                        if ("1".equals(MetaDataMgr.getInstance().getDeleteClassification())) {
                            try {
                                clientRatingMgr.deleteOnArbitraryKey(clientID, "key1");
                            } catch (Exception ex) {
                                Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } else {
                    wbo.setAttribute("status", "no");
                }
            } else {
                wbo.setAttribute("status", "no-issue");
            }
        } catch (SQLException ex) {
            wbo.setAttribute("status", "no");
        }
        return wbo;
    }

    //
    private boolean IsExistNumforClient(WebBusinessObject loggedUser, String searchByValue) {
        ArrayList<WebBusinessObject> clientLst = new ArrayList<>();
        Vector clientsVec = new Vector();

        try {
//                        wbo = clientMgr.getOnSingleKey("key2", searchByValue.trim());
            EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
            ProjectMgr projectMgr = ProjectMgr.getInstance();
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
                    return true;
                } else if (clientsVec.isEmpty()) {
                    clientsVec = clientMgr.getClientByComVec(searchByValue.trim(), (String) departmentWbo.getAttribute("projectID"));
                    if (!clientsVec.isEmpty()) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        } catch (Exception ex) {
            logger.error(ex);
        }

        return false;
    }

    private boolean IsExistEmailforClient(WebBusinessObject loggedUser, String searchByValue) {
        ArrayList<WebBusinessObject> clientLst = new ArrayList<>();
        Vector clientsVec = new Vector();

        try {
//                        wbo = clientMgr.getOnSingleKey("key2", searchByValue.trim());
            EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
            WebBusinessObject departmentWbo = null;
            if (managerWbo != null) {
                departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
            } else {
                departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
            }
            if (departmentWbo != null) {
                clientsVec = clientMgr.getClientsByEmail(searchByValue.trim(), (String) departmentWbo.getAttribute("projectID"));
                if (!clientsVec.isEmpty()) {
                    return true;
                } else if (clientsVec.isEmpty()) {
                    clientsVec = clientMgr.getClientByComMail(searchByValue.trim(), (String) departmentWbo.getAttribute("projectID"));
                    if (!clientsVec.isEmpty()) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        } catch (Exception ex) {
            logger.error(ex);
        }

        return false;
    }

    private JSONObject distributedClientsForPagination(HttpServletRequest request) {
        JSONObject resultJson = new JSONObject();
        EmployeeView2Mgr employeeView2Mgr = EmployeeView2Mgr.getInstance();
        String sStart = request.getParameter("start");
        String sAmount = request.getParameter("length");
        String sdir = request.getParameter("order[0][dir]");
        String sColumn = request.getParameter("order[0][column]");
        Map<String, String> columnsMap = new HashMap<>();
        columnsMap.put("0", "CUSTOMER_NAME");
        columnsMap.put("1", "CLIENT_PHONE");
        columnsMap.put("2", "CLIENT_MOBILE");
        columnsMap.put("3", "FULL_NAME");
        columnsMap.put("4", "ENTRY_DATE");
        HashMap<String, Object> dataMap = employeeView2Mgr.getDistributedClientsForPagination("", request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("sourceID"),
                request.getParameter("search[value]"), sStart != null ? sStart : "0", sAmount != null ? sAmount : "10",
                sColumn != null && columnsMap.containsKey(sColumn) ? columnsMap.get(sColumn) : columnsMap.get("0"),
                sdir != null ? sdir : "asc");
        JSONArray array = new JSONArray();
        if (dataMap != null && dataMap.containsKey("resultList")) {
            ArrayList<WebBusinessObject> resultList = (ArrayList<WebBusinessObject>) dataMap.get("resultList");
            for (WebBusinessObject tempoWbo : resultList) {
                JSONArray tempArr = new JSONArray();
                tempArr.add(tempoWbo.getAttribute("customerName") + "--" + tempoWbo.getAttribute("customerId"));
                tempArr.add("UL".equals(tempoWbo.getAttribute("clientPhone")) ? "" : (String) tempoWbo.getAttribute("clientPhone"));
                tempArr.add("UL".equals(tempoWbo.getAttribute("clientMobile")) ? "" : (String) tempoWbo.getAttribute("clientMobile"));
                tempArr.add((String) tempoWbo.getAttribute("fullName"));
                tempArr.add(tempoWbo.getAttribute("entryDate") != null ? ((String) tempoWbo.getAttribute("entryDate")).substring(0, 16) : "");
                array.add(tempArr);
            }
            resultJson.put("iTotalRecords", Integer.parseInt((String) dataMap.get("total")));
            resultJson.put("iTotalDisplayRecords", Integer.parseInt((String) dataMap.get("totalAfterFilter")));
            resultJson.put("aaData", array);
        }
        return resultJson;
    }

    private WebBusinessObject redirectClientComplaint2(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject activeComplaintWbo = clientComplaintsMgr.getActiveClientComplaint(request.getParameter("clientID"));
        if (activeComplaintWbo != null) {
            issueMgr = IssueMgr.getInstance();
            String issueId = (String) activeComplaintWbo.getAttribute("issueID");
            String clientComplaintId = (String) activeComplaintWbo.getAttribute("clientComplaintID");
            String employeeId = request.getParameter("employeeId");
            String ticketType = request.getParameter("ticketType");
            String businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
            String comment = request.getParameter("comment");
            String subject = request.getParameter("subject");
            String notes = request.getParameter("notes");
            String remoteAccess = request.getSession().getId();
            WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
            try {
                if (issueId != null && clientComplaintId != null) {
                    String newClientComplaintId = clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"), employeeId, issueId, ticketType, businessId, comment, subject, notes);
                    if (newClientComplaintId != null) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } else {
                    wbo.setAttribute("status", "no-issue");
                }
            } catch (SQLException ex) {
                wbo.setAttribute("status", "no");
            }
        } else {
            wbo = new WebBusinessObject();
            wbo.setAttribute("status", "fail");
        }
        return wbo;
    }

    private WebBusinessObject saveClientsToCampaign(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        String campaignID = request.getParameter("campaignID");
        String[] clientIDs = request.getParameter("clientIDs").split(",");
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
        if (clientCampaignMgr.linkClientsToCampaign(clientIDs, campaignID, (String) persistentUser.getAttribute("userId"))) {
            wbo.setAttribute("status", "ok");
        } else {
            wbo.setAttribute("status", "fail");
        }
        return wbo;
    }

    private WebBusinessObject moveClientsToCampaign(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        String campaignID = request.getParameter("newCampaignID");
        String[] clientIDs = request.getParameter("clientIDs").split(",");
        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
        if (clientCampaignMgr.updateClientsCampaign(clientIDs, campaignID, request.getParameter("oldCampaignID"))) {
            wbo.setAttribute("status", "ok");
        } else {
            wbo.setAttribute("status", "fail");
        }
        return wbo;
    }

    private WebBusinessObject saveClientCampaign(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        String clientID = request.getParameter("clientID");
        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
        String[] emptyArray = {};
        if (clientCampaignMgr.saveCampaignsByClient(clientID, request.getParameterValues("campaignID"), emptyArray, emptyArray,
                emptyArray, request.getSession(), false)) {
            wbo.setAttribute("status", "ok");
        } else {
            wbo.setAttribute("status", "fail");
        }
        return wbo;
    }

    private WebBusinessObject getClientFirstCommentAppointment(HttpServletRequest request) {
        WebBusinessObject wbo = clientMgr.getClientFirstCommentAppointment(request.getParameter("clientID"), request.getParameter("type"));
        if (wbo != null) {
            wbo.setAttribute("status", "Ok");
        } else {
            if (wbo == null) {
                wbo = new WebBusinessObject();
            }
            wbo.setAttribute("status", "No");
        }
        return wbo;
    }

    private String owendProjectUnit(HttpServletRequest request) {
        String json = new String();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        if (request.getParameter("equ") != null && request.getParameter("equ").equals("yes")) {
            ArrayList<WebBusinessObject> equInfo = new ArrayList<>();
            try {
                equInfo = projectMgr.getEquipmentInfo(request.getParameter("unitID"));
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            json = Tools.getJSONArrayAsString(equInfo);
        } else {
            ArrayList<WebBusinessObject> unitLst = new ArrayList<>();
            String prjID = null;
            ArrayList projectList = new ArrayList<>();
            String prjIDRes = request.getParameter("prjIDRes");
            try {
                unitLst = new ArrayList<>(projectMgr.getOnArbitraryKey(prjIDRes, "key2"));
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (prjID == null && !unitLst.isEmpty()) {
                prjID = "";
            }
            request.setAttribute("clientId", request.getParameter("clientId"));
            request.setAttribute("unitLst", unitLst);
            request.setAttribute("prjID", prjID);
            request.setAttribute("projectList", projectList);
            json = Tools.getJSONArrayAsString(unitLst);
        }
        return json;
    }

    private WebBusinessObject redirectClients(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        wbo.setAttribute("status", "fail");
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        if (request.getParameter("clientID") != null) {
            String[] clientIDs = request.getParameter("clientID").split(",");
            String subjects = request.getParameter("subject");
            String comment = request.getParameter("comment");
            String notes = request.getParameter("notes");
            String issueId, clientComplaintId;
            for (String clientID : clientIDs) {
                String subject = subjects;
                WebBusinessObject activeComplaintWbo = clientComplaintsMgr.getActiveClientComplaint(clientID);
                AppointmentNotificationMgr appointmentNotificationMgr = AppointmentNotificationMgr.getInstance();
                appointmentMgr = AppointmentMgr.getInstance();
                issueMgr = IssueMgr.getInstance();
                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
                String employeeId = request.getParameter("employeeId");
                String ticketType = request.getParameter("ticketType");
                if (activeComplaintWbo != null) {
                    issueId = (String) activeComplaintWbo.getAttribute("issueID");
                    clientComplaintId = (String) activeComplaintWbo.getAttribute("clientComplaintID");
                    List<WebBusinessObject> appNotificationIDLst = appointmentNotificationMgr.getFutureAppointments(clientID);
                    if (appNotificationIDLst != null) {
                        for (WebBusinessObject appNotificationIDWbo : appNotificationIDLst) {
                            try {
                                appointmentMgr.deteleAppointment((String) appNotificationIDWbo.getAttribute("id"));
                            } catch (SQLException ex) {
                                Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                } else {
                    WebBusinessObject wboTemp = new WebBusinessObject();
                    wboTemp.setAttribute("notes", ticketType);
                    wboTemp.setAttribute("userId", persistentUser.getAttribute("userId"));
                    wboTemp.setAttribute("clientId", clientID);
                    wboTemp.setAttribute("entryDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
                    try {
                        issueId = issueMgr.saveAutoData(wboTemp);
                    } catch (NoUserInSessionException | SQLException ex) {
                        issueId = null;
                    }
                    clientComplaintId = null;
                }
                String businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
                try {
                    if (issueId != null) {
                        String newClientComplaintId = clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"),
                                employeeId, issueId, ticketType, businessId, comment, subject, notes);
                        if (newClientComplaintId != null) {
                            boolean done;
                            if (clientComplaintId != null) {
                                WebBusinessObject issueStatusWbo = new WebBusinessObject();
                                issueStatusWbo.setAttribute("parentId", issueId);
                                issueStatusWbo.setAttribute("businessObjectId", clientComplaintId);
                                issueStatusWbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
                                issueStatusWbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                                issueStatusWbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                issueStatusWbo.setAttribute("issueTitle", "UL");
                                issueStatusWbo.setAttribute("statusNote", notes);
                                issueStatusWbo.setAttribute("cuseDescription", "UL");
                                issueStatusWbo.setAttribute("actionTaken", "UL");
                                issueStatusWbo.setAttribute("preventionTaken", "UL");
                                done = issueStatusMgr.changeStatus(issueStatusWbo, persistentUser, ActionEvent.getClientComplaintsActionEvent());
                            } else {
                                done = true;
                            }
                            if (done) {
                                if ("1".equals(MetaDataMgr.getInstance().getDeleteClassification())) {
                                    try {
                                        clientRatingMgr.deleteOnArbitraryKey(clientID, "key1");
                                    } catch (Exception ex) {
                                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                                    }
                                }
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } else {
                        wbo.setAttribute("status", "no-issue");
                    }
                } catch (SQLException ex) {
                    wbo.setAttribute("status", "no");
                }
            }
        }
        return wbo;
    }

    private WebBusinessObject saveClientBoker(HttpServletRequest request) {
        WebBusinessObject wboTemp = new WebBusinessObject();
        String projectId = request.getParameter("projectId");
        String ClientName = request.getParameter("ClientName");
        String ClientTel = request.getParameter("ClientTel");
        wboTemp.setAttribute("projectId", projectId);
        wboTemp.setAttribute("ClientName", ClientName);
        wboTemp.setAttribute("ClientTel", ClientTel);
        try {
            clientMgr = ClientMgr.getInstance();
            String saveStatus = clientMgr.saveClient(wboTemp);
            //that logic WOW
            if (saveStatus.equals("ok")) {
                wboTemp.setAttribute("Status", "Ok");
            } else {
                wboTemp.setAttribute("Status", saveStatus);
            }
        } catch (NoUserInSessionException ex) {
            logger.error(ex);
        } catch (InterruptedException ex) {
            logger.error(ex);
        }
        return wboTemp;
    }

    private WebBusinessObject updateClientBoker(HttpServletRequest request) {
        WebBusinessObject wboTemp = new WebBusinessObject();
        String ProjectId = request.getParameter("projectId");
        String ownerId = request.getParameter("ownerId");
        String ownerName = request.getParameter("ClientName");
        String ownerTel = request.getParameter("ClientTel");
        wboTemp.setAttribute("ownerName", ownerName);
        wboTemp.setAttribute("ownerTel", ownerTel);
        wboTemp.setAttribute("ownerId", ownerId);
        wboTemp.setAttribute("projectId", ProjectId);
        try {
            clientMgr = ClientMgr.getInstance();
            String flag = "false";
            try {
                flag = clientMgr.UpdateClient(wboTemp);
            } catch (NoUserInSessionException ex) {
                Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            wboTemp.setAttribute("Status", flag);
        } catch (Exception ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return wboTemp;
    }

    private WebBusinessObject addToCart(HttpServletRequest request) {
        WebBusinessObject wboTemp = new WebBusinessObject();
        String clientID = request.getParameter("clientID");
        String projectID = request.getParameter("projectID");
        String productCategoryID = request.getParameter("productCategoryID");
        String productCategoryName = request.getParameter("productCategoryName");
        String userId = request.getParameter("userId");
        String projectName = request.getParameter("projectName");
        wboTemp.setAttribute("clientID", clientID);
        wboTemp.setAttribute("projectID", projectID);
        wboTemp.setAttribute("productCategoryID", productCategoryID);
        wboTemp.setAttribute("productCategoryName", productCategoryName);
        wboTemp.setAttribute("userId", userId);
        wboTemp.setAttribute("projectName", projectName);
        try {
            clientMgr = ClientMgr.getInstance();
            String flag = "false";
            try {
                flag = clientMgr.addToCart(wboTemp);
            } catch (NoUserInSessionException ex) {
                Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            wboTemp.setAttribute("Status", flag);
        } catch (SQLException ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return wboTemp;
    }

    private WebBusinessObject getClientByMobileAjax(HttpServletRequest request) {
        WebBusinessObject wboTemp = clientMgr.getClientByMobile(request.getParameter("clientMobile"));
        if (wboTemp == null) {
            wboTemp = new WebBusinessObject();
            wboTemp.setAttribute("status", "fail");
        } else {
            wboTemp.setAttribute("status", "ok");
        }
        return wboTemp;
    }

    private WebBusinessObject removeClientCampaign(HttpServletRequest request) {
        WebBusinessObject wboTemp = new WebBusinessObject();
        String[] clntCmpIDs = request.getParameter("clntCmpIDs").split(",");
        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
        try {
            if (clientCampaignMgr.removeClientCampaign(clntCmpIDs)) {
                wboTemp.setAttribute("status", "ok");
            } else {
                wboTemp.setAttribute("status", "fail");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return wboTemp;
    }

    private WebBusinessObject saveExtraInfo(HttpServletRequest request) {
        WebBusinessObject wboTemp = new WebBusinessObject();
        wboTemp.setAttribute("clientId", request.getParameter("clientId"));
        wboTemp.setAttribute("clntAge", request.getParameter("clntAge"));
        wboTemp.setAttribute("noOfKids", request.getParameter("noOfKids"));
        wboTemp.setAttribute("school", request.getParameter("school"));
        wboTemp.setAttribute("relg", request.getParameter("relg"));
        wboTemp.setAttribute("fSport", request.getParameter("fSport"));
        wboTemp.setAttribute("fMusic", request.getParameter("fMusic"));
        wboTemp.setAttribute("ClubMem", request.getParameter("ClubMem"));
        wboTemp.setAttribute("generalDesc", request.getParameter("generalDesc"));
        wboTemp.setAttribute("marriageD", request.getParameter("marriageD"));
        WebBusinessObject ajaxWbo = new WebBusinessObject();
        Boolean clntResult;
        try {
            clntResult = clientMgr.addClientInfo(wboTemp, request.getSession());

            if (clntResult == true) {
                ajaxWbo.setAttribute("status", "ok");
            } else {
                ajaxWbo.setAttribute("status", "no");
            }
        } catch (NoUserInSessionException ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return ajaxWbo;
    }

    private WebBusinessObject showReferralCustomerAjax(HttpServletRequest request) {
        WebBusinessObject wboTemp = new WebBusinessObject();
        wboTemp.setAttribute("status", "none");
        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
        try {
            ArrayList<WebBusinessObject> clientCampaignsList = new ArrayList<>(clientCampaignMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("clientID"),
                    "key2", "Customer", "key4"));
            if (!clientCampaignsList.isEmpty()) {
                WebBusinessObject clientWbo = clientMgr.getOnSingleKey((String) clientCampaignsList.get(0).getAttribute("businessObjID"));
                if (clientWbo != null) {
                    wboTemp.setAttribute("clientID", clientWbo.getAttribute("id"));
                    wboTemp.setAttribute("clientName", clientWbo.getAttribute("name"));
                    wboTemp.setAttribute("status", "ok");
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return wboTemp;
    }

    private WebBusinessObject informUserAjax(HttpServletRequest request) {
        WebBusinessObject wboTemp = new WebBusinessObject();
        CommentsMgr commentsMgr = CommentsMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        try {
            String remoteAccess = request.getSession().getId();
            WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
            if (commentsMgr.saveComment(request, persistentUser)) {
                MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                WebBusinessObject clientWbo = clientMgr.getOnSingleKey(request.getParameter("clientId"));
                if (clientWbo != null) {
                    WebBusinessObject userWbo = userMgr.getOnSingleKey(request.getParameter("userID"));
                    WebBusinessObject commentUserWbo = userMgr.getOnSingleKey((String) persistentUser.getAttribute("userId"));
                    if ("1".equals(metaDataMgr.getSendMail())
                            && userWbo != null && userWbo.getAttribute("email") != null
                            && commentUserWbo != null && commentUserWbo.getAttribute("fullName") != null) {
                        String toEmail = (String) userWbo.getAttribute("email");
                        String subject = "تم أضافة تعليق للعميل " + clientWbo.getAttribute("clientNO") + " - " + clientWbo.getAttribute("name")
                                + " بواسطة " + commentUserWbo.getAttribute("fullName");
                        String content = request.getParameter("comment");
                        try {
                            EmailUtility.sendMessage(toEmail, subject, content);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                wboTemp.setAttribute("status", "ok");
            } else {
                wboTemp.setAttribute("status", "no");
            }
        } catch (NoUserInSessionException | SQLException ex) {
            logger.error(ex);
        }
        return wboTemp;
    }

    private void fillLoggerWbo(HttpServletRequest request, WebBusinessObject loggerWbo) {
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        WebBusinessObject objectXml = new WebBusinessObject();
        String clientID = new String();
        if (request.getParameter("clientId") != null) {
            clientID = request.getParameter("clientId");
        } else {
            clientID = request.getAttribute("clientId").toString();
        }

        objectXml = clientMgr.getOnSingleKey(clientID);
        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
        loggerWbo.setAttribute("realObjectId", clientID);
        loggerWbo.setAttribute("userId", securityUser.getUserId());
        loggerWbo.setAttribute("objectName", request.getParameter("clientName") != null ? request.getParameter("clientName") : objectXml.getAttribute("mobile").toString());
        loggerWbo.setAttribute("loggerMessage", "Client Deleted");
        loggerWbo.setAttribute("eventName", "Delete");
        loggerWbo.setAttribute("objectTypeId", "1");
        loggerWbo.setAttribute("eventTypeId", "1");
        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
    }

    private boolean checkExternalConn() {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String userName = metaDataMgr.getRealEstateName();
        String password = metaDataMgr.getRealEstatePassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {
            try {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
            } catch (Exception se) {
                logger.error("database error " + se.getMessage());
            } finally {
                if (conn != null) {
                    try {
                        conn.commit();
                        conn.close();
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }
                    return true;
                } else {
                    return false;
                }
            }
        } else {
            return true;
        }
    }

    private void deleteProductsAndIssuesForClient(String clientID, WebBusinessObject persistentUser) {
        try {
            ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
            ArrayList<WebBusinessObject> clientProducts = new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryKeyOracle(clientID, "key1"));
            for (WebBusinessObject clientProduct : clientProducts) {
                if (clientProductMgr.deleteProduct((String) clientProduct.getAttribute("id"), null, null)) {
                    if (clientProduct.getAttribute("productId") != null && (((String) clientProduct.getAttribute("productId")).equals("purche")
                            || ((String) clientProduct.getAttribute("productId")).equals("reserved"))) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        WebBusinessObject wbo = new WebBusinessObject();
                        wbo.setAttribute("statusCode", "8");
                        wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                        wbo.setAttribute("businessObjectId", (String) clientProduct.getAttribute("projectId"));
                        wbo.setAttribute("statusNote", "");
                        wbo.setAttribute("objectType", "Housing_Units");
                        wbo.setAttribute("parentId", "UL");
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                        issueStatusMgr.changeStatus(wbo, persistentUser, null);;
                    }
                }
            }

            ArrayList<WebBusinessObject> clientIssues = new ArrayList<WebBusinessObject>(issueMgr.getOnArbitraryKeyOracle(clientID, "key7"));
            for (WebBusinessObject issueWbo : clientIssues) {
                issueMgr.deleteAllIssueData((String) issueWbo.getAttribute("id"));
            }
        } catch (Exception ex) {
            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void setClientDetails(WebBusinessObject clientWbo, HttpServletRequest request) throws Exception {
        DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
        userMgr = UserMgr.getInstance();
        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
        if (clientWbo != null && clientWbo.getAttribute("id") != null) {
            ClientCommunicationMgr clientCommunicationMgr = ClientCommunicationMgr.getInstance();
            request.setAttribute("clientsRecommendedList", new ArrayList<WebBusinessObject>(clientCampaignMgr.getOnArbitraryKeyOracle((String) clientWbo.getAttribute("id"), "key3")));
            ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
            request.setAttribute("reservedUnitsNo", (new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) clientWbo.getAttribute("id"), "key1", "reserved", "key4"))).size());
            request.setAttribute("emailsList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle((String) clientWbo.getAttribute("id"), "key2", "email", "key3")));
            request.setAttribute("phonesList", new ArrayList<WebBusinessObject>(clientCommunicationMgr.getOnArbitraryDoubleKeyOracle((String) clientWbo.getAttribute("id"), "key2", "phone", "key3")));
            request.setAttribute("clientWbo", clientWbo);

            String responsibleId = distributionListMgr.getLastResponsibleEmployee((String) clientWbo.getAttribute("id"));
            if (responsibleId != null) {
                request.setAttribute("ownerUserWbo", userMgr.getOnSingleKey(responsibleId));
            }

            ArrayList<WebBusinessObject> list = new ArrayList<WebBusinessObject>(loggerMgr.getOnArbitraryDoubleKeyOracleOrderBy("3", "key1", (String) clientWbo.getAttribute("id"), "key2", "key3"));
            if (list.size() > 0) {
                request.setAttribute("loggerWbo", list.get(list.size() - 1));
            }
        }
    }

    private void withdrawFromDetails(HttpServletRequest request, WebBusinessObject persistentUser) {
        IssueMgr issueMgr = IssueMgr.getInstance();
        String[] clientComplaintIDs = request.getParameterValues("clientComplaintID");
        if (clientComplaintIDs != null) {
            try {
                //For logging Withdraw Client
                WebBusinessObject issueWbo, clientWbo, loggerWbo;
                String clientID, issueID;
                for (String clientComplaintID : clientComplaintIDs) {
                    WebBusinessObject complaintWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintID);
                    loggerWbo = new WebBusinessObject();
                    clientID = null;
                    if (complaintWbo != null) {
                        issueID = (String) complaintWbo.getAttribute("issueId");
                        issueWbo = issueMgr.getOnSingleKey(issueID);
                        if (issueWbo != null) {
                            clientID = (String) issueWbo.getAttribute("clientId");
                            if (clientID == null || clientID.isEmpty()) {
                                clientID = (String) request.getParameter("clientId");
                            }
                            clientWbo = clientMgr.getOnSingleKey(clientID);
                        } else {
                            clientWbo = null;
                        }
                        loggerWbo.setAttribute("objectXml", complaintWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", clientID == null ? "---" : clientID);
                        loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", clientWbo != null ? clientWbo.getAttribute("clientNO") : "---");
                        loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                        loggerWbo.setAttribute("eventName", "Withdraw");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "5");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        ArrayList<WebBusinessObject> distList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(issueID));
                        if (issueMgr.addWithdrawInfo((String) persistentUser.getAttribute("userId"), distList, clientWbo, loggerWbo)
                                && issueMgr.deleteAllIssueData(issueID)) {
                            appointmentMgr.deleteAllFutureAppointments(clientID);
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "fail");
                        }
                    }
                }
            } catch (SQLException ex) {
                logger.error(ex);
                request.setAttribute("status", "fail");
            } catch (Exception ex) {
                Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
