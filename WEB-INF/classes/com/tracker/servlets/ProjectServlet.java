package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import com.silkworm.logger.db_access.LoggerMgr;
import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.Item_Type.db_access.ItemTypeMgr;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.AndroidDevicesMgr;
import com.android.db_access.AndroidLocationsMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.clients.db_access.ClientCommunicationMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientLocationMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ReservationMgr;
import com.clients.servlets.ClientServlet;
import com.crm.common.CRMConstants;
import com.crm.common.CalendarUtils;
import com.docviewer.db_access.DocTypeMgr;
import com.financials.db_access.ExpenseItemMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueByComplaintAllCaseMgr;
import com.maintenance.db_access.ProjectsByGroupMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.maintenance.db_access.UserCompanyProjectsMgr;
import com.out_ofstore_parts.db_access.OutOfStorePartsMgr;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.unit.db_access.ApartmentRuleMgr;
import com.unit.db_access.UnitPriceMgr;
import java.awt.image.BufferedImage;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import javax.imageio.ImageIO;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.crm.common.PDFTools;
import com.maintenance.common.UserGroupConfigMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UserCompaniesMgr;
import com.planning.db_access.SeasonMgr;
import com.planning.db_access.StandardPaymentPlanMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.unit.db_access.UnitTypeMgr;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONValue;

public class ProjectServlet extends TrackerBaseServlet {
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();

    Vector projects;
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ProjectAccountingMgr projectAccMgr = ProjectAccountingMgr.getInstance();
    UnitPriceMgr unitPriceMgr = UnitPriceMgr.getInstance();
    ExpenseItemMgr expenseItemMgr = ExpenseItemMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    WebBusinessObject loggerWbo = new WebBusinessObject();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject project = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;
    String projectId = null;
    ItemTypeMgr itemtypeMgr = ItemTypeMgr.getInstance();
    OutOfStorePartsMgr outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
    int size = 1;
    List locationTypesList = null;
    LocationTypeMgr locationTypeMgr = null;
    JSONArray JsonList = null;
    JSONObject jsonMenu = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_project.jsp";
        logger = Logger.getLogger(ProjectServlet.class);
    }

    /**
     * Destroys the servlet.
     */
    public void destroy() {}

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        String lang = (String) session.getAttribute("currentMode");
        //out = response.getWriter();

        // issueMgr.setUser(userObj);
        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                String issueId = request.getParameter(IssueConstants.ISSUEID);
                String issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                projectMgr = ProjectMgr.getInstance();
                ArrayList allSites = projectMgr.getAllNotFutileProjects();

                locationTypesList = new ArrayList<WebBusinessObject>();
                locationTypeMgr = LocationTypeMgr.getInstance();
                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                request.setAttribute("locationTypesList", locationTypesList);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allSites", allSites);
                servedPage = "/docs/Adminstration/new_project.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                String pName = request.getParameter(ProjectConstants.PROJECT_NAME);
                String eqNO = request.getParameter(ProjectConstants.EQ_NO);
                String pDescription = request.getParameter(ProjectConstants.PROJECT_DESC);
                String from = request.getParameter("fromERP");

                String mainProjectId = null;
                try {
                    if (from != null && from.equalsIgnoreCase("fromERP")) {
                        mainProjectId = request.getParameter("siteErp");
                    } else {
                        mainProjectId = request.getParameter("site");
                    }
                } catch (NullPointerException npe) {
                    mainProjectId = request.getParameter("site");
                }

                WebBusinessObject project = new WebBusinessObject();

                project.setAttribute(ProjectConstants.PROJECT_NAME, pName);
                project.setAttribute(ProjectConstants.EQ_NO, eqNO);
                project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
                try {
                    project.setAttribute("mainProjectId", mainProjectId);
                } catch (Exception ex) {
                    project.setAttribute("mainProjectId", "0");
                }

                servedPage = "/docs/Adminstration/new_project.jsp";
                try {
                    if (!projectMgr.getDoubleName(request.getParameter("project_name"))) {
                        if (projectMgr.saveObject(project, session)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                projectMgr = ProjectMgr.getInstance();
                allSites = projectMgr.getAllAsArrayList();

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allSites", allSites);
                //request.setAttribute("data", issuesList);
                //request.setAttribute("status", "Unassigned");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                try {
                    Vector projects = projectMgr.getJoinTable();

                    servedPage = "/docs/Adminstration/project_list.jsp";

                    request.setAttribute("data", projects);
                    request.setAttribute("page", servedPage);
                } catch (Exception e) {}
                
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String projectName = request.getParameter("projectName");

                projectId = request.getParameter("projectId");

                servedPage = "/docs/Adminstration/confirm_delproject.jsp";
                try {
                    if (projectName == null || projectName.equals("")) {
                        projectName = ((WebBusinessObject) projectMgr.getOnSingleKey(projectId)).getAttribute("projectName").toString();
                    }
                } catch (Exception e) {
                    projectName = ((WebBusinessObject) projectMgr.getOnSingleKey(projectId)).getAttribute("projectName").toString();
                }

                request.setAttribute("projectName", projectName);
                request.setAttribute("projectId", projectId);
                try {
                    if (request.getParameter("type").equals("tree")) {
                        request.setAttribute("type", "tree");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    request.setAttribute("page", servedPage);
                    request.setAttribute("type", "");
                    this.forwardToServedPage(request, response);
                }
                break;

            case 5:
                projectId = request.getParameter("projectId");
                locationTypeMgr = LocationTypeMgr.getInstance();
                project = projectMgr.getOnSingleKey(projectId);
                WebBusinessObject wbo1 = projectMgr.getOnSingleKey(project.getAttribute("mainProjId").toString());
                if (wbo1 != null) {
                    request.setAttribute("mainProject", wbo1.getAttribute("projectName").toString());
                }
                
                request.setAttribute("project", project);
                Vector loc_types = new Vector();
                String loc_type = (String) project.getAttribute("location_type");
                try {
                    loc_types = locationTypeMgr.getOnArbitraryKey(loc_type, "key1");
                    for (int i = 0; i < loc_types.size(); i++) {
                        WebBusinessObject locWbo = (WebBusinessObject) loc_types.get(i);
                        servedPage = locWbo.getAttribute("jspPage").toString();
                        //"/docs/Adminstration/view_project.jsp";
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }

                try {
                    if (request.getParameter("type").equals("tree")) {
                        request.setAttribute("type", "tree");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 6:
                projectId = request.getParameter("projectId");
                project = projectMgr.getOnSingleKey(projectId);
                WebBusinessObject defaultProjectWbo = null;

                Vector mainProjectVec = null;

                /* custom setting for sub project */
                mainProjectId = (String) project.getAttribute("mainProjId");
                defaultProjectWbo = projectMgr.getOnSingleKey(mainProjectId);
                if (!mainProjectId.equals("0")) {
                    mainProjectVec = projectMgr.getAllMainProjects();
                    request.setAttribute("defaultLocationName", (String) defaultProjectWbo.getAttribute("projectName"));
                    request.setAttribute("mainProjectVec", mainProjectVec);
                    request.setAttribute("isSubProject", "yes");
                } else {
                    request.setAttribute("isSubProject", "no");
                }
                /* -custom setting for sub project */

                servedPage = "/docs/Adminstration/update_project.jsp";

                request.setAttribute("project", project);
                locationTypeMgr = LocationTypeMgr.getInstance();
                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                request.setAttribute("locationTypesList", locationTypesList);
                try {
                    if (request.getParameter("type").equals("tree")) {
                        request.setAttribute("type", "tree");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 7:
                String key = request.getParameter("projectID").toString();
                String OldProjectName = request.getParameter("OldProjectName");
                String ProjectName = request.getParameter("projectName");
                servedPage = "/docs/Adminstration/update_project.jsp";

                String isMngmntStn = request.getParameter("isMngmntStn");
                String isTrnsprtStn = request.getParameter("isTrnsprtStn");
                try {
                    scrapeForm(request, "update");

                    project = new WebBusinessObject();
                    project.setAttribute("projectName", request.getParameter("projectName"));
                    project.setAttribute("projectDesc", request.getParameter("projectDesc"));
                    project.setAttribute("eqNO", request.getParameter("eqNO"));
                    project.setAttribute("projectID", request.getParameter("projectID"));
                    project.setAttribute("futile", request.getParameter("futile"));
                    project.setAttribute("location_type", request.getParameter("location_type"));
                    project.setAttribute("isMngmntStn", (isMngmntStn != null && isMngmntStn.equals("on")) ? "1" : "0");
                    project.setAttribute("isTrnsprtStn", (isTrnsprtStn != null && isTrnsprtStn.equals("on")) ? "1" : "0");

                    // is a sub project
//                    if (isSubProject.equalsIgnoreCase("yes")) {
//                        mainProjectId = request.getParameter("mainProjectId");
//                        project.setAttribute("mainProjectId",
//                                mainProjectId);
//                        defaultProjectWbo = projectMgr.getOnSingleKey(mainProjectId);
//                        request.setAttribute("defaultLocationName",
//                                (String) defaultProjectWbo.getAttribute("projectName"));
//
//                    }
                    // do update
                    locationTypesList = new ArrayList<WebBusinessObject>();
                    locationTypeMgr = LocationTypeMgr.getInstance();
                    locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                    request.setAttribute("locationTypesList", locationTypesList);
                    WebBusinessObject wbo = new WebBusinessObject();
                    try {
                        if (!projectMgr.getDoubleNameforUpdate(key, request.getParameter("projectName"))) {
                            if (projectMgr.updateProject(project)) {
//                                WebBusinessObject wbo = new WebBusinessObject();
                                request.setAttribute("Status", "Ok");
                                wbo.setAttribute("Status", "Ok");

//                                out = response.getWriter();
//                                out.write(Tools.getJSONObjectAsString(wbo));
                            } else {
                                request.setAttribute("Status", "No");
                                wbo.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                            wbo.setAttribute("Status", "No");
                            wbo.setAttribute("name", "Duplicate Name");
                        }
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    projectMgr.UpdateOldProjectNameforIssue(ProjectName, OldProjectName);
                    projectMgr.UpdateOldProjectNameforUnit(ProjectName, OldProjectName);
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(wbo));
                    // fetch the group again
                    break;
                } catch (Exception Ex) {
                    shipBack(Ex.getMessage(), request, response);
                    break;
                }
                
            case 8:
                try {
                    IssueMgr issueMgr = IssueMgr.getInstance();
                    loggerWbo = new WebBusinessObject();
                    Integer iTemp = new Integer(issueMgr.hasData("PROJECT_NAME", request.getParameter("projectName")));
                    projectId = request.getParameter("projectId");
                    if (iTemp.intValue() > 0) {
                        servedPage = "/docs/Adminstration/cant_delete.jsp";
                        request.setAttribute("servlet", "ProjectServlet");
                        request.setAttribute("list", "ListProjects");
                        request.setAttribute("type", "Project");
                        request.setAttribute("name", request.getParameter("projectName"));
                        request.setAttribute("no", iTemp.toString());
                    } else {
                        WebBusinessObject objectXml = projectMgr.getOnSingleKey(projectId);
                        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
                        //if (projectMgr.deleteOnSingleKey(projectId)) {
                        boolean deleteProject = false;
                        if (projectMgr.deleteProjectTree(projectId)) {
                            request.setAttribute("status", "ok");
                            loggerWbo.setAttribute("realObjectId", projectId);
                            loggerWbo.setAttribute("userId", userObj.getAttribute("userId"));
                            loggerWbo.setAttribute("objectName", "Branch");
                            loggerWbo.setAttribute("loggerMessage", "Branch Deleted");
                            loggerWbo.setAttribute("eventName", "Delete");
                            loggerWbo.setAttribute("objectTypeId", "3");
                            loggerWbo.setAttribute("eventTypeId", "2");
                            loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                            try {
                                loggerMgr.saveObject(loggerWbo);
                            } catch (SQLException ex) {
                                logger.error(ex);
                            }
                        } else {
                            request.setAttribute("status", "fail");
                        }

                        projectMgr.cashData();
                        projects = projectMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/project_list.jsp";

                        request.setAttribute("data", projects);
                    }

                    try {
                        if (request.getParameter("type").equals("tree")) {
                            servedPage = "/docs/projects/confirm_delproject_result.jsp";
                            this.forward(servedPage, request, response);
                        }
                    } catch (Exception ex) {
                        request.setAttribute("page", servedPage);
                        request.setAttribute("type", "");
                        this.forwardToServedPage(request, response);
                    }
                } catch (NoUserInSessionException ne) {}
                break;
                
            case 9:
                servedPage = "/docs/Adminstration/new_project1.jsp";

                locationTypesList = new ArrayList<WebBusinessObject>();
                locationTypeMgr = LocationTypeMgr.getInstance();
                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                request.setAttribute("locationTypesList", locationTypesList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 10:
                pName = request.getParameter(ProjectConstants.PROJECT_NAME);
                eqNO = request.getParameter(ProjectConstants.EQ_NO);
                pDescription = request.getParameter(ProjectConstants.PROJECT_DESC);
                isMngmntStn = request.getParameter(ProjectConstants.IS_MNGMNT_STN);
                isTrnsprtStn = request.getParameter(ProjectConstants.IS_TRNSPRT_STN);

                isMngmntStn = (isMngmntStn != null) ? "1" : "0";
                isTrnsprtStn = (isTrnsprtStn != null) ? "1" : "0";

                project = new WebBusinessObject();

                String backTo = request.getParameter("backTo");
                mainProjectId = request.getParameter("mainProjectId");
                servedPage = "/docs/Adminstration/new_project.jsp";
                project.setAttribute(ProjectConstants.PROJECT_NAME, pName);
                project.setAttribute(ProjectConstants.EQ_NO, eqNO);
                project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, isMngmntStn);
                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, isTrnsprtStn);
                if (mainProjectId == null) {
                    project.setAttribute("mainProjectId", "0");
                } else {
                    project.setAttribute("mainProjectId", mainProjectId);
                }
                
                project.setAttribute("futile", request.getParameter("futile"));
                project.setAttribute("location_type", request.getParameter("location_type"));
                WebBusinessObject mainProjectWbo = null;
                if (mainProjectId != null) {
                    mainProjectWbo = projectMgr.getOnSingleKey(mainProjectId);
                }
                
                try {
                    project.setAttribute("option2", mainProjectWbo != null ? (Integer.parseInt((String) mainProjectWbo.getAttribute("optionTwo")) + 1) + "" : "1"); // Rank
                } catch (Exception ex) {
                    project.setAttribute("option2", "1"); // Rank
                }
                
                try {
                    project.setAttribute("option3", mainProjectWbo != null ? "1".equals(project.getAttribute("optionTwo")) ? mainProjectWbo.getAttribute("projectID") : mainProjectWbo.getAttribute("optionThree") + "-" + mainProjectWbo.getAttribute("projectID") : "0"); // Parents IDs
                } catch (Exception ex) {
                    project.setAttribute("option3", "0"); // Parents IDs
                }

                try {
                    if (!projectMgr.getDoubleName(pName, "key1")) {
                        if (projectMgr.saveObject(project, session)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                projectMgr = ProjectMgr.getInstance();
                allSites = projectMgr.getAllNotFutileProjects();
                locationTypesList = new ArrayList<WebBusinessObject>();
                locationTypeMgr = LocationTypeMgr.getInstance();
                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                request.setAttribute("allSites", allSites);
                request.setAttribute("locationTypesList", locationTypesList);
                try {
                    if (backTo.equals("projTree")) {
                        //servedPage = "ProjectServlet?op=showTree";
                        this.forward("ProjectServlet?op=showTree", request, response);
                        break;
                    } else {
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    }
                } catch (Exception ex) {
                    if (mainProjectId == null) {
                        mainProjectId = "0";
                    }
                }

            case 11:
                servedPage = "docs/projects/projects_tree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 12:
                servedPage = "docs/projects/dynamicTree_Projects.jsp";
                //define general vars
                String icon = new String();

                //define the json 
                JSONObject main = new JSONObject();
                JSONObject menu = new JSONObject();
                JSONArray menuItems = new JSONArray();

                this.jsonMenu = new JSONObject();
                this.JsonList = new JSONArray();

                //Define menu JSON Reader
                JSONParser parser = new JSONParser();
                try {
                    String path = getServletContext().getRealPath("/json");
                    System.out.println("Web Inf path = " + path);
                    FileReader fileReader = new FileReader(getServletContext().getRealPath("/json") + "/contextMenu.json");
                    this.jsonMenu = (JSONObject) parser.parse(fileReader);
                } catch (Exception ex) {
                    System.out.println("Parsing Error : " + ex.getMessage());
                    logger.error(ex.getMessage());
                }

                String mainNodeID = request.getParameter("mainNodeID");
                WebBusinessObject mainNodeWbo;
                String groupId = (String) userObj.getAttribute("groupID");
                ProjectsByGroupMgr projectsByGroupMgr = ProjectsByGroupMgr.getInstance();
                ArrayList<String> projectByGroupList = projectsByGroupMgr.getProjectByGroupList(groupId);
                if (mainNodeID == null || mainNodeID.isEmpty()) {
                    //Add main object to json
                    menu = (JSONObject) this.jsonMenu.get("general");
                    icon = (String) menu.get("icon");
                    menuItems = (JSONArray) menu.get("menuItem");

                    main.put("id", "0");
                    main.put("projectID", "0");
                    main.put("parentid", "-1");
                    main.put("text", "المؤسسة");
                    main.put("icon", icon);
                    main.put("type", "general");
                    main.put("contextMenu", menuItems);
                    JsonList.add(main);
                    WebBusinessObject projWbo;
                    ArrayList<WebBusinessObject> mainProjects = new ArrayList<WebBusinessObject>();
                    for (int x = 0; x < projectByGroupList.size(); x++) {
                        projWbo = projectMgr.getOnSingleKey(projectByGroupList.get(x));
                        if (projWbo != null) {
                            mainProjects.add(projWbo);
                        }
                    }
                    
                    try {
                        if (mainProjects.size() > 0) {
                            for (int i = 0; i < mainProjects.size(); i++) {
                                projectMgr = ProjectMgr.getInstance();
                                WebBusinessObject projectWbo = mainProjects.get(i);

                                //get type context menu and icon
                                if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("cmp")) {
                                    menu = (JSONObject) this.jsonMenu.get("dep");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("G1")) {
                                    menu = (JSONObject) this.jsonMenu.get("region");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("LOC")) {
                                    menu = (JSONObject) this.jsonMenu.get("branch");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("PRODUCTS")) {
                                    menu = (JSONObject) this.jsonMenu.get("project");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("ACCNTS")) {
                                    menu = (JSONObject) this.jsonMenu.get("ACCNTS");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("CSTCNTR")) {
                                    menu = (JSONObject) this.jsonMenu.get("cstcntr");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("bnk")) {
                                    menu = (JSONObject) this.jsonMenu.get("bnk");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("FTT")) {
                                    menu = (JSONObject) this.jsonMenu.get("FTT");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("FTSIDE")) {
                                    menu = (JSONObject) this.jsonMenu.get("FTSIDE");
                                } else if (projectWbo.getAttribute("eqNO") != null && projectWbo.getAttribute("eqNO").equals("FTRANS-PURP")) {
                                    menu = (JSONObject) this.jsonMenu.get("FTRANS-PURP");
                                } else if (projectWbo.getAttribute("futile") != null && projectWbo.getAttribute("futile").equals("1")) {
                                    menu = (JSONObject) this.jsonMenu.get("site");
                                } else {
                                    menu = (JSONObject) this.jsonMenu.get("subsite");
                                }

                                icon = (String) menu.get("icon");
                                menuItems = (JSONArray) menu.get("menuItem");

                                //Add the project in JsonArray
                                int currentID = this.JsonList.size();
                                JSONObject mainProject = new JSONObject();
                                mainProject.put("id", Integer.toString(this.JsonList.size()));
                                mainProject.put("projectID", projectWbo.getAttribute("projectID"));
                                mainProject.put("parentid", "0");
                                mainProject.put("text", projectWbo.getAttribute("projectName"));
                                mainProject.put("icon", icon);
                                mainProject.put("type", projectWbo.getAttribute("location_type"));
                                mainProject.put("contextMenu", menuItems);
                                this.JsonList.add(mainProject);

                                getChilds((String) projectWbo.getAttribute("projectID"), currentID);
                            }
                        }
                    } catch (Exception exc) {
                        System.out.println(exc.getMessage());
                    }
                } else {
                    mainNodeWbo = projectMgr.getOnSingleKey(mainNodeID);
                    //get type context menu and icon
                    if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("cmp")) {
                        menu = (JSONObject) this.jsonMenu.get("dep");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("G1")) {
                        menu = (JSONObject) this.jsonMenu.get("region");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("LOC")) {
                        menu = (JSONObject) this.jsonMenu.get("branch");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("PRODUCTS")) {
                        menu = (JSONObject) this.jsonMenu.get("project");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("ACCNTS")) {
                        menu = (JSONObject) this.jsonMenu.get("ACCNTS");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("CSTCNTR")) {
                        menu = (JSONObject) this.jsonMenu.get("cstcntr");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("bnk")) {
                        menu = (JSONObject) this.jsonMenu.get("bnk");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("FTT")) {
                        menu = (JSONObject) this.jsonMenu.get("FTT");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("FTSIDE")) {
                        menu = (JSONObject) this.jsonMenu.get("FTSIDE");
                    } else if (mainNodeWbo.getAttribute("eqNO") != null && mainNodeWbo.getAttribute("eqNO").equals("FTRANS-PURP")) {
                        menu = (JSONObject) this.jsonMenu.get("FTRANS-PURP");
                    } else if (mainNodeWbo.getAttribute("futile") != null && mainNodeWbo.getAttribute("futile").equals("1")) {
                        menu = (JSONObject) this.jsonMenu.get("site");
                    } else {
                        menu = (JSONObject) this.jsonMenu.get("subsite");
                    }
                    
                    icon = (String) menu.get("icon");
                    menuItems = (JSONArray) menu.get("menuItem");

                    //Add the project in JsonArray
                    int currentID = this.JsonList.size();
                    JSONObject mainProject = new JSONObject();
                    mainProject.put("id", "0");
                    mainProject.put("projectID", mainNodeWbo.getAttribute("projectID"));
                    mainProject.put("parentid", "-1");
                    mainProject.put("text", mainNodeWbo.getAttribute("projectName"));
                    mainProject.put("icon", icon);
                    mainProject.put("type", mainNodeWbo.getAttribute("location_type"));
                    mainProject.put("contextMenu", menuItems);
                    this.JsonList.add(mainProject);
                    getChilds((String) mainNodeWbo.getAttribute("projectID"), currentID);
                }
                
                ArrayList<WebBusinessObject> allMainNodes = new ArrayList<>();
                try {
                    allMainNodes.addAll(projectMgr.getOnArbitraryKeyOracle("0", "key2"));
                    WebBusinessObject wbo;
                    for (int i = allMainNodes.size() - 1; i >= 0; i--) {
                        wbo = allMainNodes.get(i);
                        if (!projectByGroupList.contains((String) wbo.getAttribute("projectID"))) {
                            allMainNodes.remove(i);
                        }
                    }
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                request.setAttribute("allMainNodes", allMainNodes);
                request.setAttribute("mainNodeID", mainNodeID);

                request.setAttribute("jsonArray", this.JsonList);
                this.forward(servedPage, request, response);
                break;

            case 13:
                servedPage = "/docs/projects/new_project.jsp";
                mainProjectId = request.getParameter("mainProjectId");//get  main Project  id from url
                projectMgr = projectMgr.getInstance();

                String mainProjName = "Main Project";
                String mainProjectLocationCode = "";
                String mainProjectLocation = "";
                WebBusinessObject parentWbo = (WebBusinessObject) projectMgr.getOnSingleKey(mainProjectId);
                try {
                    mainProjName = (String) parentWbo.getAttribute("projectName");
                    mainProjectLocationCode = (String) parentWbo.getAttribute("location_type");
                    if (mainProjectId == null) {
                        mainProjectId = "0";
                    }
                } catch (Exception e) {
                    mainProjectId = "0";
                    mainProjName = "Main Project";
                }
                
                locationTypesList = new ArrayList<WebBusinessObject>();
                locationTypeMgr = LocationTypeMgr.getInstance();
                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                for (int i = 0; i < locationTypesList.size(); i++) {
                    if (mainProjectLocationCode.equals(((WebBusinessObject) locationTypesList.get(i)).getAttribute("typeCode"))) {
                        mainProjectLocation = ((String) ((WebBusinessObject) locationTypesList.get(i)).getAttribute("arDesc"));
                        i = locationTypesList.size();
                    }
                }
                
                request.setAttribute("locationTypesList", locationTypesList);
                request.setAttribute("mainProjectId", mainProjectId);
                request.setAttribute("mainProjName", mainProjName);
                request.setAttribute("defaultLocationName", mainProjectLocation);
                if (parentWbo != null) {
                    request.setAttribute("futile", parentWbo.getAttribute("futile").toString());
                } else {
                    request.setAttribute("futile", "1");
                }
                
                this.forward(servedPage, request, response);
                break;
                
            case 14:
                servedPage = "/docs/projects/map_project_view.jsp";
                projectMgr = ProjectMgr.getInstance();
                String projectID = (String) request.getParameter("projectID");
                WebBusinessObject tempWbo = new WebBusinessObject();
                tempWbo = projectMgr.getOnSingleKey(projectID);
                request.setAttribute("equipmentcordinate", tempWbo.getAttribute("coordinate"));
                this.forward(servedPage, request, response);
                break;
                
            case 15:
                servedPage = "/docs/projects/map_project_insert.jsp";
                projectId = (String) request.getParameter("projectId");
                String coordinate = (String) request.getParameter("coordinate");
                if (!(coordinate == null || coordinate.equals(""))) {
                    projectMgr.updateProjectMapData(coordinate, projectId);
                }
                
                tempWbo = projectMgr.getOnSingleKey(projectId);
                request.setAttribute("projectCordinate", tempWbo.getAttribute("coordinate"));
                request.setAttribute("projectId", projectId);

                this.forward(servedPage, request, response);
                break;

            case 16:
                servedPage = "/docs/projects/new_location_type.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 17:
                servedPage = "/docs/projects/new_location_type.jsp";
                locationTypeMgr = LocationTypeMgr.getInstance();
                try {
                    if (!locationTypeMgr.getDoubleName("keyname", request.getParameter("arDesc"))
                            && !locationTypeMgr.getDoubleName("keyname1", request.getParameter("enDesc"))) {
                        if (locationTypeMgr.saveObject(request)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 18:
                locationTypeMgr = LocationTypeMgr.getInstance();
                if (request.getParameterValues("displayInTree") != null) {
                    String[] ids = request.getParameterValues("displayInTree");
                    String temp = "";
                    for (String id : ids) {
                        temp += "'" + id + "',";
                    }
                    
                    temp = temp.substring(0, temp.length() - 1);
                    locationTypeMgr.updateDisplayInTree(temp);
                }
                
                Vector locationType = locationTypeMgr.getCashedTable();
                servedPage = "/docs/projects/location_type_list.jsp";

                request.setAttribute("data", locationType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 19:
                servedPage = "/docs/projects/view_location_type.jsp";
                String id = request.getParameter("id");

                WebBusinessObject location_type = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                location_type = locationTypeMgr.getOnSingleKey(id);
                request.setAttribute("location_type", location_type);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 20:
                id = request.getParameter("id");
                location_type = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                location_type = locationTypeMgr.getOnSingleKey(id);

                servedPage = "/docs/projects/update_location_type.jsp";

                request.setAttribute("location_type", location_type);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 21:
                servedPage = "/docs/projects/update_location_type.jsp";
                locationTypeMgr = LocationTypeMgr.getInstance();
                try {
                    if (!locationTypeMgr.getDoubleName("keyname", request.getParameter("arDesc"))
                            && !locationTypeMgr.getDoubleName("keyname1", request.getParameter("enDesc"))) {
                        if (locationTypeMgr.update(request)) {
                            request.setAttribute("status", "Ok");
                        } else {
                            request.setAttribute("status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }

                location_type = locationTypeMgr.getOnSingleKey(request.getParameter("id"));
                request.setAttribute("location_type", location_type);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 22:
                servedPage = "/docs/projects/confirm_dellocation_type.jsp";
                String typeName = "arDesc";
                if (lang.equalsIgnoreCase("En")) {
                    typeName = "enDesc";
                }
                
                id = request.getParameter("id");
                location_type = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                String typeNameValue = request.getParameter(typeName);
                try {
                    if (typeNameValue == null || typeNameValue.equals("")) {
                        typeNameValue = ((WebBusinessObject) locationTypeMgr.getOnSingleKey(id)).getAttribute(typeName).toString();
                    }
                } catch (Exception e) {
                    typeNameValue = ((WebBusinessObject) locationTypeMgr.getOnSingleKey(id)).getAttribute(typeName).toString();
                }

                request.setAttribute("typeNameValue", typeNameValue);
                request.setAttribute("id", id);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 23:
                id = request.getParameter("id");
                Vector location_types = new Vector();
                locationTypeMgr = LocationTypeMgr.getInstance();
                if (locationTypeMgr.deleteOnSingleKey(id)) {
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "fail");
                }

                location_types = locationTypeMgr.getCashedTable();
                servedPage = "/docs/projects/location_type_list.jsp";
                request.setAttribute("data", location_types);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 24:
                servedPage = "/docs/projects/site_tree.jsp";
                projectMgr = ProjectMgr.getInstance();
                ArrayList getallLocation = (ArrayList) projectMgr.getAllParents();
                ArrayList<WebBusinessObject> list = new ArrayList<WebBusinessObject>();
                WebBusinessObject pwbo;
                int parent;
                String itemNo = request.getParameter("itemNo");
                for (int i = 0; i < getallLocation.size(); i++) {
                    parent = 0;
                    size++;
                    pwbo = ((WebBusinessObject) getallLocation.get(i));
                    String nameParent = pwbo.getAttribute("mainProjId").toString();
                    System.out.println("getProjName" + nameParent);
                    pwbo.setAttribute("size", size);
                    pwbo.setAttribute("parent", parent);
                    list.add(pwbo);
                    //d.add(<%=size%>,0,'<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectName")%>',"javascript:sendInfo('<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectName")%>','<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectID")%>');",'parent','<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectID")%>');
                    parent = size;
                    id = ((WebBusinessObject) getallLocation.get(i)).getAttribute("projectID").toString();
                    try {
                        getTree(id, list, parent);
                    } catch (Exception exc) {
                        System.out.println(exc.getMessage());
                    }
                }

                request.setAttribute("itemNo", itemNo);
                request.setAttribute("list", list);
                this.forward(servedPage, request, response);
                break;

            case 25:
                projectId = request.getParameter("projectId");
                String randome = null;
                int len = 0;
                String docID = null;
                String randFileName = null;
                String RIPath = null;
                String userImageDir = null;
                String absPath = null;
                String userHome = null;
                File docImage = null;
                BufferedInputStream gifData = null;
                BufferedImage myImage = null;
                String imageDirPath = null;
                Vector docsList = null;
                UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();

                Vector imageList = new Vector();
                Vector imagesPath = new Vector();
                if (projectId.equals("0")) {
                    servedPage = "/docs/Adminstration/view_image.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("treeName", "yes");
                    this.forward(servedPage, request, response);
                } else {
                    project = projectMgr.getOnSingleKey(projectId);
                    defaultProjectWbo = null;

                    mainProjectVec = null;

                    /* custom setting for sub project */
                    mainProjectId = (String) project.getAttribute("mainProjId");
                    defaultProjectWbo = projectMgr.getOnSingleKey(mainProjectId);

                    docsList = unitDocMgr.getListOnLIKE("ListDoc", projectId);
                    request.setAttribute("data", docsList);
                    imageList = unitDocMgr.getImagesList(projectId);
                    imagesPath = new Vector();
                    servedPage = "/docs/Adminstration/view_image.jsp";

                    imageDirPath = getServletContext().getRealPath("/images");
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userImageDir = imageDirPath + "/" + userHome;
                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }

                    if (!mainProjectId.equals("0")) {
                        mainProjectVec = projectMgr.getAllMainProjects();
                        request.setAttribute("defaultLocationName", (String) defaultProjectWbo.getAttribute("projectName"));
                        request.setAttribute("mainProjectVec", mainProjectVec);
                        request.setAttribute("isSubProject", "yes");
                    } else {
                        request.setAttribute("isSubProject", "no");
                    }
                    /* -custom setting for sub project */

                    request.setAttribute("project", project);
                    locationTypeMgr = LocationTypeMgr.getInstance();
                    locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                    request.setAttribute("locationTypesList", locationTypesList);
                    request.setAttribute("treeName", "no");
                    try {
                        if (request.getParameter("type").equals("tree")) {
                            request.setAttribute("type", "tree");
                            request.setAttribute("imagePath", imagesPath);
                            this.forward(servedPage, request, response);
                        }
                    } catch (Exception ex) {
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }
                }
                break;

            case 26:
                servedPage = "/docs/projects/new_housing_unit.jsp";
//                mainProjectId = request.getParameter("mainProjectId");//get  main Project  id from url
                projectMgr = projectMgr.getInstance();
                List parents = new ArrayList<WebBusinessObject>();
                Vector res = new Vector();
                WebBusinessObject wbo = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                wbo = locationTypeMgr.getOnSingleKey("1366113574912");
                request.setAttribute("location_type_code", wbo.getAttribute("arDesc"));
                wbo = new WebBusinessObject();
                res = projectMgr.getAllProjects("1364287917750");
                for (int i = 0; i < res.size(); i++) {
                    wbo = (WebBusinessObject) res.get(i);
                    parents.add(wbo);
                }
                
                request.setAttribute("locationTypesList", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 27:
                servedPage = "/docs/projects/new_housing_unit.jsp";
                eqNO = request.getParameter("eqNO");
                String modelId = request.getParameter("models");
                wbo = new WebBusinessObject();
                wbo = projectMgr.getOnSingleKey(modelId);

                pDescription = request.getParameter("project_desc");
                eqNO = eqNO + " - " + "ع." + pDescription + " - " + "م." + request.getParameter("location_type") + " - " + "د." + request.getParameter("futile") + " - " + "ش." + request.getParameter("last") + " - " + wbo.getAttribute("projectName");
                isMngmntStn = request.getParameter("isMngmntStn");
//                isTrnsprtStn = request.getParameter("isTrnsprtStn");
                project = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                wbo = locationTypeMgr.getOnSingleKey("1366113574912");
                request.setAttribute("location_type_code", wbo.getAttribute("arDesc"));
                project.setAttribute("location_type", wbo.getAttribute("typeCode"));
                wbo = new WebBusinessObject();
                mainProjectId = request.getParameter("mainProduct");
                project.setAttribute(ProjectConstants.PROJECT_NAME, eqNO);
                project.setAttribute(ProjectConstants.EQ_NO, modelId); // awl 4 fields rkm l 3emara wkda 
                project.setAttribute(ProjectConstants.PROJECT_DESC, ""); // kemet l 7adeka
                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "0");
                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "0");
                project.setAttribute("mainProjectId", mainProjectId);
                project.setAttribute("futile", "0");

                project.setAttribute("coordinate", request.getParameter("coordinate")); //mesa7et l we7da
                project.setAttribute("option_one", isMngmntStn); // el msa7a l kolia
                project.setAttribute("option_three", request.getParameter("option_three")); //mesa7et l 7adeka
                project.setAttribute("option_two", ""); // 3a2d l 7adeeka
                try {
//                    if (!projectMgr.getDoubleName(pName, "key1")
//                            && !projectMgr.getDoubleName(eqNO, "key3")) {
                    if (projectMgr.saveObject(project, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
//                    } else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                    request.setAttribute("Status", "No");
                }
                
                projectMgr = ProjectMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>();
                res = new Vector();
                res = projectMgr.getAllProjects("1364287917750");
                for (int i = 0; i < res.size(); i++) {
                    wbo = (WebBusinessObject) res.get(i);
                    parents.add(wbo);
                }
                
                request.setAttribute("locationTypesList", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 28:
                String code = request.getParameter("code");
                ArrayList getCode = new ArrayList();
//                Vector models = new Vector();
                WebBusinessObject Wbo = null;
                Wbo = projectMgr.getOnSingleKey(code);
                getCode.add(Wbo);
//                try {
//                    models = projectMgr.getOnArbitraryKey(code, "key2");
//                } catch (SQLException ex) {
//                    logger.error(ex);
//                } catch (Exception ex) {
//                    logger.error(ex);
//                }
                servedPage = "/docs/projects/Ajax_Code.jsp";
                request.setAttribute("code", getCode);
//                request.setAttribute("models", models);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;
                
            case 29:
                servedPage = "/docs/projects/products_checkbox_list.jsp";
                projectMgr = ProjectMgr.getInstance();
                Vector products;
                Vector mainProducts = new Vector();
                try {
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                    wbo = (WebBusinessObject) products.get(0);
                    mainProducts = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    request.setAttribute("mainProducts", mainProducts);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                try {
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    List<WebBusinessObject> employees;
                    if (securityUser.isCanRunCampaignMode()) {
                        employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
                    } else {
                        employees = userMgr.getUsersByProjectAndGroup(securityUser.getSiteId(), CRMConstants.SALES_MARKTING_GROUP_ID);
                    }
                    request.setAttribute("employees", employees);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("departmentMgrId", loggegUserId);
                request.setAttribute("departmentMgrName", userMgr.getByKeyColumnValue(loggegUserId, "key3"));
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 30:
                ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                String userId = (String) loggedUser.getAttribute("userId");
                String clientId = request.getParameter("clientId");
                String productId = request.getParameter("productId");
                String productCategoryId = request.getParameter("productCategoryId");
                String productName = request.getParameter("productName");
                String productCategoryName = request.getParameter("productCategoryName");
                String budget = request.getParameter("budget");
                String period = request.getParameter("period");
                String paymentSystem = request.getParameter("paymentSystem");
                String notes = request.getParameter("notes");
                String employeeId = request.getParameter("employeeId");
                String entryDate = request.getParameter("entryDate");
                issueId = (String) request.getParameter("issueId");

                wbo = new WebBusinessObject();
                wbo.setAttribute("productId", productId);
                wbo.setAttribute("issueId", issueId);
                wbo.setAttribute("productCategoryId", productCategoryId);
                wbo.setAttribute("productName", productName);
                wbo.setAttribute("productCategoryName", productCategoryName);
                wbo.setAttribute("budget", budget);
                wbo.setAttribute("period", period);
                wbo.setAttribute("paymentSystem", paymentSystem);
                wbo.setAttribute("notes", notes);
                if (entryDate != null) {
                    wbo.setAttribute("entryDate", entryDate);
                } else {
                    wbo.setAttribute("entryDate", "");
                }

                String comment = "عميل جديد";
                String subject = "عميل جديد";
                if (request.getSession().getAttribute("issueId") != null) {
                    request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                } else {
                    issueId = request.getParameter("issueId");
                    if (issueId != null) {
                        request.setAttribute("issueId", issueId);
                    }
                }

                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                WebBusinessObject data = new WebBusinessObject();
                try {
                    if (clientProductMgr.saveImplicitClientQuery(clientId, userId, wbo)) {
                        synchronized (clientComplaintsMgr) {
                            String message = clientComplaintsMgr.createMailInBox(employeeId, issueId, "2", null, comment, subject, notes, loggedUser);
                            if (message != null) {
                                data.setAttribute("status", "yes");
                                data.setAttribute("message", "Client Product Saved and, " + message);
                            } else {
                                data.setAttribute("status", "no");
                                data.setAttribute("message", "Client product saved fail");
                            }
                        }
                    } else {
                        data.setAttribute("status", "no");
                        data.setAttribute("message", "Client product saved fail");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }

                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(data));
                break;

            case 31:
                servedPage = "/docs/projects/new_model.jsp";
//                mainProjectId = request.getParameter("mainProjectId");//get  main Project  id from url
                projectMgr = projectMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>();
                res = new Vector();
                res = projectMgr.getAllProjects("1364287917750");
                locationTypeMgr = LocationTypeMgr.getInstance();
                wbo = locationTypeMgr.getOnSingleKey("1366007938423");
                request.setAttribute("location_type", wbo.getAttribute("arDesc"));
                wbo = new WebBusinessObject();
                for (int i = 0; i < res.size(); i++) {
                    wbo = (WebBusinessObject) res.get(i);
                    parents.add(wbo);
                }
                
                request.setAttribute("locationTypesList", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 32:
                servedPage = "/docs/projects/new_model.jsp";
                //model
                eqNO = request.getParameter("eqNO");
                //desc
                pDescription = request.getParameter("project_desc");

                project = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                wbo = locationTypeMgr.getOnSingleKey("1366007938423");
                request.setAttribute("location_type", wbo.getAttribute("arDesc"));
                project.setAttribute("location_type", wbo.getAttribute("typeCode"));
                wbo = new WebBusinessObject();

                mainProjectId = request.getParameter("mainProjectId");
                project.setAttribute(ProjectConstants.PROJECT_NAME, eqNO);
                project.setAttribute(ProjectConstants.EQ_NO, eqNO); // model
                project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "0");
                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "0");
                project.setAttribute("mainProjectId", mainProjectId);
                project.setAttribute("futile", "0");

                project.setAttribute("coordinate", "0");
                project.setAttribute("option_one", request.getParameter("option_one")); // available units
                project.setAttribute("option_two", request.getParameter("option_two")); // all units
                project.setAttribute("option_three", "NON");
                try {
//                    if (!projectMgr.getDoubleName(pName, "key1")
//                            && !projectMgr.getDoubleName(eqNO, "key3")) {
                    if (projectMgr.saveObject(project, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
//                    } else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                    request.setAttribute("Status", "No");
                }
                
                projectMgr = ProjectMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>();
                res = new Vector();
                res = projectMgr.getAllProjects("1364287917750");
                for (int i = 0; i < res.size(); i++) {
                    wbo = (WebBusinessObject) res.get(i);
                    parents.add(wbo);
                }
                
                request.setAttribute("locationTypesList", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 33:
                servedPage = "/docs/projects/view_model.jsp";
                projectId = request.getParameter("projectId");
                projectMgr = ProjectMgr.getInstance();
                project = projectMgr.getOnSingleKey(projectId);
                request.setAttribute("project", project);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 34:
                servedPage = "/docs/projects/view_unit.jsp";
                projectId = request.getParameter("projectId");
                projectMgr = ProjectMgr.getInstance();
                project = projectMgr.getOnSingleKey(projectId);
                wbo = projectMgr.getOnSingleKey(project.getAttribute("mainProjId").toString());
                request.setAttribute("mainProject", wbo.getAttribute("projectName").toString());
                request.setAttribute("project", project);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 35:
                Vector subProjectVec = new Vector();
                String mainProductId = request.getParameter("mainProductId");
                try {
                    subProjectVec = projectMgr.getOnArbitraryKey(mainProductId, "key2");
                } catch (Exception ex) {
                    logger.error(ex);
                }

                String responseText = "";
                for (int i = 0; i < subProjectVec.size(); i++) {
                    wbo = (WebBusinessObject) subProjectVec.get(i);
                    productId = (String) wbo.getAttribute("projectID");
                    productName = (String) wbo.getAttribute("projectName");

                    responseText += productId + "<subelement>" + productName;
                    if (i < subProjectVec.size() - 1) {
                        responseText += "<element>";
                    }
                }
                
                out = response.getWriter();
                out.write(responseText);
                break;
                
            case 36:
                servedPage = "docs/projects/products_tree.jsp";
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                products = new Vector();
                mainProducts = new Vector();
                try {
//                    projects1 = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                    request.setAttribute("page", servedPage);
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                    wbo = (WebBusinessObject) products.get(0);
                    mainProducts = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    request.setAttribute("data", mainProducts);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 37:
                servedPage = "docs/projects/products_tree.jsp";
                WebBusinessObject productDetails = new WebBusinessObject();
                mainProducts = new Vector();
//                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                String Id = request.getParameter("ID");

//                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
//                mainCatTypes = mainCategoryTypeMgr.getCashedTableAsArrayList();
                productDetails = projectMgr.getOnSingleKey(Id);

//                String Name = mainCategoryTypeMgr.getMainType(Id);
                mainProducts = projectMgr.getSubProjectItems(Id);
//                request.setAttribute("data", mainCatTypes);
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                products = new Vector();
                Vector mainProducts1 = new Vector();
                try {
//                    projects1 = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                    request.setAttribute("page", servedPage);
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                    wbo = (WebBusinessObject) products.get(0);
                    mainProducts1 = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    request.setAttribute("data", mainProducts1);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("mainName", productDetails.getAttribute("projectName"));
                request.setAttribute("brands", mainProducts);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
                
            case 38:
                out = response.getWriter();
                productId = request.getParameter("mainProductId");
                Vector models = new Vector();
                try {
                    models = projectMgr.getModels(productId);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                responseText = "";
                for (int i = 0; i < models.size(); i++) {
                    wbo = (WebBusinessObject) models.get(i);
                    productId = (String) wbo.getAttribute("projectID");
                    productName = (String) wbo.getAttribute("projectName");

                    responseText += productId + "<subelement>" + productName;
                    if (i < models.size() - 1) {
                        responseText += "<element>";
                    }
                }
                
                out.write(responseText);
                break;
                
            case 39:
                servedPage = "/docs/Search/search_for_unit.jsp";
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                try {
                    id = projectMgr.saveAvailableUnit(request, session);
                    if (id != null) {
                        WebBusinessObject resWbo = saveReservation(request, session);
                        if (resWbo != null) {
                            wbo.setAttribute("id", id);
                            wbo.setAttribute("resID", resWbo.getAttribute("reservationID"));
                            wbo.setAttribute("issueStatusID", resWbo.getAttribute("issueStatusID"));
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    
                    wbo.setAttribute("projectName", projectMgr.getOnSingleKey(request.getParameter("unitCategoryId")).getAttribute("projectName"));
                    if (request.getParameter("changeStatus") != null && request.getParameter("changeStatus").equalsIgnoreCase("true")) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        String newStatusCode = "11";
                        wbo.setAttribute("statusCode", newStatusCode);
                        wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                        wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
                        wbo.setAttribute("statusNote", "Customer Status");
                        wbo.setAttribute("objectType", "client");
                        wbo.setAttribute("parentId", "UL");
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                        ClientMgr clientMgr = ClientMgr.getInstance();
                        wbo.setAttribute("status", "no");
                        if (issueStatusMgr.changeStatus(wbo, persistentUser, null)
                                && clientMgr.updateClientStatus(request.getParameter("clientId"), newStatusCode, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                            wbo.setAttribute("status", "ok");
                        }
                        
                        String statusCode = "8";
                        issueId = request.getParameter("issueId");
                        String clientComplaintId = request.getParameter("clientComplaintId");
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        WebBusinessObject manager = UserMgr.getInstance().getOnSingleKey(CRMConstants.FINANCIAL_MANAGER_ID);
                        WebBusinessObject complaint = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                        if ((complaint != null) && (manager != null)) {
                            clientComplaintsMgr.tellManager(manager, issueId, statusCode, "Reservation", "Reservation", persistentUser);
                        }
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 40:
                projectId = request.getParameter("projectId");
                wbo = projectMgr.getOnSingleKey(projectId);
                id = (String) wbo.getAttribute("eqNO");

                project = projectMgr.getOnSingleKey(id);
                defaultProjectWbo = null;

                mainProjectVec = null;
                docsList = null;
                /* custom setting for sub project */
                mainProjectId = (String) project.getAttribute("mainProjId");
                defaultProjectWbo = projectMgr.getOnSingleKey(mainProjectId);

                unitDocMgr = UnitDocMgr.getInstance();
                docsList = unitDocMgr.getListOnLIKE("ListDoc", id);
                request.setAttribute("data", docsList);
                imageList = unitDocMgr.getImagesList(id);
                imagesPath = new Vector();
                servedPage = "/docs/Adminstration/productImages.jsp";
                randome = null;
                len = 0;
                docID = null;
                randFileName = null;
                RIPath = null;
                userImageDir = null;
                absPath = null;
                userHome = null;
                docImage = null;
                gifData = null;
                myImage = null;
                imageDirPath = null;
                imageDirPath = getServletContext().getRealPath("/images");
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                userHome = (String) loggedUser.getAttribute("userHome");
                userImageDir = imageDirPath + "/" + userHome;
                for (int i = 0; i < imageList.size(); i++) {
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                    randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                    RIPath = userImageDir + "/" + randFileName;

                    absPath = "images/" + userHome + "/" + randFileName;

                    docImage = new File(RIPath);

                    gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                    myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage, "jpeg", docImage);
                    imagesPath.add(absPath);
                }

                if (!mainProjectId.equals("0")) {
                    mainProjectVec = projectMgr.getAllMainProjects();
                    request.setAttribute("defaultLocationName", (String) defaultProjectWbo.getAttribute("projectName"));
                    request.setAttribute("mainProjectVec", mainProjectVec);
                    request.setAttribute("isSubProject", "yes");
                } else {
                    request.setAttribute("isSubProject", "no");
                }
                /* -custom setting for sub project */

                request.setAttribute("project", project);
                locationTypeMgr = LocationTypeMgr.getInstance();
                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                request.setAttribute("locationTypesList", locationTypesList);
//                try {
//                    if (request.getParameter("type").equals("tree")) {

                request.setAttribute("type", "tree");
                request.setAttribute("imagePath", imagesPath);
                this.forward(servedPage, request, response);
//                    }
//                } catch (Exception ex) {
//
//                    request.setAttribute("page", servedPage);
//                    this.forwardToServedPage(request, response);
//                }
                break;
                
            case 41:
                projectMgr = ProjectMgr.getInstance();
                userId = (String) userObj.getAttribute("userId");
                clientId = request.getParameter("clientId");
                productId = request.getParameter("productId");
                productCategoryId = request.getParameter("productCategoryId");
                budget = request.getParameter("budget");
                period = request.getParameter("period");
                paymentSystem = request.getParameter("paymentSystem");
                notes = request.getParameter("notes");
                request.setAttribute("productId", productId);
                request.setAttribute("productCategoryId", productCategoryId);
                //Real Estate
                String mainBuilding = request.getParameter("mainBuilding");
                String typeUnit = request.getParameter("typeUnit");
                String budgetType = request.getParameter("budget");
                String priceWish = request.getParameter("priceWish");
                String perCentWish = request.getParameter("perCentWish");
                String amountWish = request.getParameter("amountWish");
                String unitNotesReceiot = request.getParameter("notes");
                String paymentSystemInterested = request.getParameter("paymentSystemInterested");
                String sourceClient = request.getParameter("sourceClient");
                String sourceClientName = request.getParameter("sourceClientName");
                wbo = new WebBusinessObject();
                productName = "";
                productCategoryName = "";
                //136411129087 products id
                if (productId.equals("1364111290870")) {
                    productName = "\u062A\u0635\u0646\u064A\u0641 \u0639\u0627\u0645";
                } else {
                    wbo = projectMgr.getOnSingleKey(productId);
                    if (wbo != null) {
                        productName = (String) wbo.getAttribute("projectName");
                    }
                }
                
                wbo = new WebBusinessObject();
                wbo = projectMgr.getOnSingleKey(productCategoryId);
                if (wbo != null) {
                    productCategoryName = (String) wbo.getAttribute("projectName");
                }
                
                request.setAttribute("productName", productName);
                request.setAttribute("productCategoryName", productCategoryName);
                request.setAttribute("budget", budget);
                request.setAttribute("period", period);
                request.setAttribute("paymentSystem", paymentSystem);
                request.setAttribute("notes", notes);
                request.setAttribute("clientId", clientId);
                request.setAttribute("mainBuilding", mainBuilding);
                request.setAttribute("typeUnit", typeUnit);
                request.setAttribute("budgetType", budgetType);
                request.setAttribute("priceWish", priceWish);
                request.setAttribute("perCentWish", perCentWish);
                request.setAttribute("amountWish", amountWish);
                request.setAttribute("unitNotesReceiot", unitNotesReceiot);
                request.setAttribute("paymentSystemInterested", paymentSystemInterested);
                request.setAttribute("sourceClient", sourceClient);
                request.setAttribute("sourceClientName", sourceClientName);

                data = new WebBusinessObject();
                WebBusinessObject result = new WebBusinessObject();
                clientProductMgr = ClientProductMgr.getInstance();
                String operation = request.getParameter("operation");
                if (operation.equals("update")) {
                    request.setAttribute("id", request.getParameter("id"));
                    try {
                        data = clientProductMgr.updateInterestedProduct(request, session);
                        if (data != null) {
                            result.setAttribute("status", "ok");
                            result.setAttribute("id", data.getAttribute("id"));
                            result.setAttribute("productName", data.getAttribute("productName"));
                            result.setAttribute("productCategoryName", data.getAttribute("productCategoryName"));
                            result.setAttribute("budget", data.getAttribute("budget"));
                            result.setAttribute("period", data.getAttribute("period"));
                            result.setAttribute("paymentSystem", data.getAttribute("paymentSystem"));
                            result.setAttribute("creationTime", data.getAttribute("creationTime"));
                            String note = (String) data.getAttribute("note");
                            String x = "";
                            if (note.length() > 17) {
                                x = note.substring(0, 16);
                            } else {
                                x = note;
                            }
                            
                            result.setAttribute("note", x);
                        } else {
                            result.setAttribute("status", "no");
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex);
                        result.setAttribute("status", "no");
                    } catch (SQLException ex) {
                        logger.error(ex);
                        result.setAttribute("status", "no");
                    }
                } else {
                    try {
                        data = clientProductMgr.saveInterestedProduct(request, session);
                        if (data != null) {
                            result.setAttribute("status", "ok");
                            result.setAttribute("id", data.getAttribute("id"));
                            result.setAttribute("productName", data.getAttribute("productName"));
                            result.setAttribute("productCategoryName", data.getAttribute("productCategoryName"));
                            result.setAttribute("budget", data.getAttribute("budget"));
                            result.setAttribute("period", data.getAttribute("period"));
                            result.setAttribute("productCategoryId", data.getAttribute("productCategoryId"));
                            result.setAttribute("paymentSystem", data.getAttribute("paymentSystem"));
                            result.setAttribute("creationTime", data.getAttribute("creationTime"));
                            String note = (String) data.getAttribute("note");
                            String x = "";
                            if (note.length() > 17) {
                                x = note.substring(0, 16);
                            } else {
                                x = note;
                            }
                            
                            result.setAttribute("note", x);
                        } else {
                            result.setAttribute("status", "no");
                        }
                        String codeWish = (String) result.getAttribute("id");
                        WebBusinessObject clientInfo = new WebBusinessObject();
                        clientInfo = ClientMgr.getInstance().getOnSingleKey(clientId);
                        String projectDatabase = null;
                        wbo = projectMgr.getOnSingleKey(productId);
                        if (wbo != null) {
                        projectDatabase = (String) wbo.getAttribute("optionThree");
                        }
                    WebBusinessObject dataRealEstate = new WebBusinessObject();
                    String ReservCard_CodeClient = projectMgr.ReservCard_CodeClient(projectDatabase);
                    clientInfo = new WebBusinessObject();
                    WebBusinessObject clientAotherPhone = new WebBusinessObject();
                    clientInfo = ClientMgr.getInstance().getOnSingleKey(clientId);
                    Vector<WebBusinessObject> clientAotherPhones = ClientCommunicationMgr.getInstance().getOnArbitraryDoubleKey(clientId , "key2", "phone", "key3");
                    if (!clientAotherPhones.isEmpty()) {
                        clientAotherPhone = clientAotherPhones.get(0);
                    } else {
                        clientAotherPhone = null;
                    }
                    dataRealEstate = new WebBusinessObject();
                    ArrayList<WebBusinessObject> getClientCheck = ClientMgr.getInstance().getClientCheck(clientInfo, projectDatabase);
                    String getClientChecks = "";
                    for (WebBusinessObject webBusinessObject : getClientCheck) {
                        getClientChecks = webBusinessObject.getAttribute("CLIENT_CODE").toString();
                    }
                    if (getClientChecks == null || getClientChecks.equals("")){
                    dataRealEstate = clientProductMgr.saveInterestedProductRealEstat(ReservCard_CodeClient,clientInfo, projectDatabase,clientAotherPhone);
                    } else {
                    ReservCard_CodeClient = getClientChecks;     
                    }               
                    //dataRealEstate = clientProductMgr.saveInterestedProductRealEstat(ReservCard_CodeClient,clientInfo, projectDatabase,clientAotherPhone);
                    String QUESTIONNAIRE_CODE = projectMgr.QUESTIONNAIRE_CODE(projectDatabase);
                    WebBusinessObject dataUpdate = new WebBusinessObject();
                    dataUpdate = clientProductMgr.updateInterestedProduct(codeWish, QUESTIONNAIRE_CODE);
                    WebBusinessObject dataRealEstateQuestion = new WebBusinessObject();
                    dataRealEstateQuestion = clientProductMgr.saveInterestedProductRealEstatQuestion(request,ReservCard_CodeClient, projectDatabase,QUESTIONNAIRE_CODE);
                    
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex);
                        result.setAttribute("status", "no");
                    } catch (SQLException ex) {
                        logger.error(ex);
                        result.setAttribute("status", "no");
                    } catch (Exception ex) {
                java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(result));
                break;

            case 42:
                id = request.getParameter("id");
                result = new WebBusinessObject();
                clientProductMgr = ClientProductMgr.getInstance();
                WebBusinessObject clientProductWbo = clientProductMgr.getOnSingleKey(id);
                try {
                    if (clientProductMgr.deleteProduct(id, null, null)) {
                        securityUser = (SecurityUser) session.getAttribute("securityUser");
                        //For logging Client Insertion
                        loggerWbo = new WebBusinessObject();
                        loggerWbo.setAttribute("objectXml", clientProductWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", id);
                        loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", id);
                        loggerWbo.setAttribute("loggerMessage", "Delete Client Units");
                        loggerWbo.setAttribute("eventName", "Delete Client Units");
                        loggerWbo.setAttribute("objectTypeId", "8");
                        loggerWbo.setAttribute("eventTypeId", "8");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        loggerMgr.saveObject(loggerWbo);

                        result.setAttribute("status", "ok");
                        if (clientProductWbo != null && clientProductWbo.getAttribute("productId") != null && ((String) clientProductWbo.getAttribute("productId")).equals("purche")) {
                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("statusCode", "8");
                            wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                            wbo.setAttribute("businessObjectId", (String) clientProductWbo.getAttribute("projectId"));
                            wbo.setAttribute("statusNote", "");
                            wbo.setAttribute("objectType", "Housing_Units");
                            wbo.setAttribute("parentId", "UL");
                            wbo.setAttribute("issueTitle", "UL");
                            wbo.setAttribute("cuseDescription", "UL");
                            wbo.setAttribute("actionTaken", "UL");
                            wbo.setAttribute("preventionTaken", "UL");
                            IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                            if (issueStatusMgr.changeStatus(wbo, persistentUser, null)) {
                                result.setAttribute("status", "ok");
                            }
                        }
                    } else {
                        result.setAttribute("status", "no");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(result));
                break;
                
            case 43:
                out = response.getWriter();
                String managerId = request.getParameter("managerId");
                String departmentId = request.getParameter("departmentId");
                wbo = new WebBusinessObject();
                wbo.setAttribute("managerId", managerId);
                wbo.setAttribute("departmentId", departmentId);

                data = new WebBusinessObject();
                result = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> tempArr = new ArrayList<>();
                try {
                    tempArr = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle(managerId, "key5"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                try {
                    if (tempArr.isEmpty()) {
                        if (projectMgr.updateDepartmentManager(wbo)) {
                            userMgr = UserMgr.getInstance();
                            wbo = new WebBusinessObject();
                            wbo = userMgr.getOnSingleKey(managerId);
                            if (wbo != null) {
                                result.setAttribute("managerName", (String) wbo.getAttribute("userName"));
                                result.setAttribute("status", "ok");
                            }
                        } else {
                            result.setAttribute("status", "no");
                        }
                    } else {
                        result.setAttribute("status", "exist");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                }
                
                out.write(Tools.getJSONObjectAsString(result));
                break;

            case 44:
                projectId = request.getParameter("projectId");
                project = projectMgr.getOnSingleKey(projectId);
                defaultProjectWbo = null;
                mainProjectVec = null;
                /* custom setting for sub project */
                mainProjectId = (String) project.getAttribute("mainProjId");
                defaultProjectWbo = projectMgr.getOnSingleKey(mainProjectId);
                request.setAttribute("mainProjectId", mainProjectId);
                String mainProjectName = null;
                if (defaultProjectWbo != null && !defaultProjectWbo.equals("")) {
                    mainProjectName = (String) defaultProjectWbo.getAttribute("projectName");
                    request.setAttribute("mainProjectName", mainProjectName);
                }

                if (!mainProjectId.equals("0")) {
                    mainProjectVec = projectMgr.getAllMainProjects();
                    request.setAttribute("mainProjectVec", mainProjectVec);
                    request.setAttribute("isSubProject", "yes");
                } else {
                    request.setAttribute("isSubProject", "no");
                }

                /* -custom setting for sub project */
                servedPage = "/docs/Adminstration/update_parent_of_project.jsp";
                request.setAttribute("project", project);
                locationTypeMgr = LocationTypeMgr.getInstance();
                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
                request.setAttribute("locationTypesList", locationTypesList);
                try {
                    if (request.getParameter("type").equals("tree")) {
                        request.setAttribute("type", "tree");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 45:
                servedPage = "/docs/Search/All_Locations_By_update.jsp";
                projectMgr = ProjectMgr.getInstance();
                getallLocation = (ArrayList) projectMgr.getAllParents();
                list = new ArrayList<WebBusinessObject>();
                pwbo = new WebBusinessObject();
                parent = 0;
                for (int i = 0; i < getallLocation.size(); i++) {
                    parent = 0;
                    size++;
                    pwbo = ((WebBusinessObject) getallLocation.get(i));
                    pwbo.setAttribute("size", size);
                    pwbo.setAttribute("parent", parent);
                    list.add(pwbo);
                    //d.add(<%=size%>,0,'<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectName")%>',"javascript:sendInfo('<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectName")%>','<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectID")%>');",'parent','<%=((WebBusinessObject)getallLocation.get(i)).getAttribute("projectID")%>');
                    parent = size;
                    id = ((WebBusinessObject) getallLocation.get(i)).getAttribute("projectID").toString();
                    try {
                        getTree(id, list, parent);
                    } catch (Exception exc) {
                        System.out.println(exc.getMessage());
                    }
                }
                
                request.setAttribute("list", list);
                this.forward(servedPage, request, response);
                break;

            case 46:
                projectId = request.getParameter("projectID").toString();
                String alterMainProjectId = request.getParameter("alterMainProjectId");
                servedPage = "/docs/Adminstration/update_project.jsp";
                try {
                    project = new WebBusinessObject();
                    project.setAttribute("mainProjectId", alterMainProjectId);
                    project.setAttribute("projectID", projectId);
                    try {
                        if (projectMgr.updateParentOfProject(project)) {
                            request.setAttribute("Status", "Ok");
                            shipBack("ok", request, response);
                        } else {
                            request.setAttribute("Status", "No");
                            shipBack("No", request, response);
                        }
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    // fetch the group again
                    break;
                } catch (Exception Ex) {
                    shipBack(Ex.getMessage(), request, response);
                    break;
                }
                
            case 47:
                servedPage = "/docs/Adminstration/dep_doc_prev.jsp";
                projectMgr = ProjectMgr.getInstance();
                Vector departments = new Vector();
                try {
                    departments = projectMgr.getOnArbitraryKeyOracle("div", "key6");
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                String docTypeID = request.getParameter("docTypeID");
                DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
                docTypeMgr.cashData();
                ArrayList docTypes = new ArrayList(docTypeMgr.getCashedTable());
                if (docTypeID == null && docTypes.size() > 0) {
                    docTypeID = ((String) ((WebBusinessObject) docTypes.get(0)).getAttribute("typeID"));
                }
                
                DepDocPrevMgr depDocPrevMgr = DepDocPrevMgr.getInstance();
                ArrayList<String> selectedDeps = depDocPrevMgr.getDepartmentIDs(docTypeID);
                ArrayList<String> selectedLastVersion = depDocPrevMgr.getLastVersionIDs(docTypeID);
                WebBusinessObject selectedDocType = docTypeMgr.getOnSingleKey(docTypeID);
                request.setAttribute("departments", departments);
                request.setAttribute("docTypeID", docTypeID);
                request.setAttribute("selectedDocType", selectedDocType);
                request.setAttribute("docTypes", docTypes);
                request.setAttribute("selectedDeps", selectedDeps);
                request.setAttribute("selectedLastVersion", selectedLastVersion);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 48:
                servedPage = "/docs/Adminstration/dep_doc_prev.jsp";
                docTypeID = request.getParameter("docTypeID");
                String[] departmentIDs = request.getParameterValues("departmentID");
                ArrayList<String> lastVersionIDs = new ArrayList<String>();
                if (request.getParameterValues("lastVersion") != null) {
                    lastVersionIDs = new ArrayList<String>(Arrays.asList(request.getParameterValues("lastVersion")));
                }

                Vector userStores = new Vector();
                WebBusinessObject userStoreWBO;
                if (departmentIDs != null) {
                    for (String departmentID : departmentIDs) {
                        userStoreWBO = new WebBusinessObject();
                        userStoreWBO.setAttribute("projectID", departmentID);
                        if (lastVersionIDs.contains(departmentID)) {
                            userStoreWBO.setAttribute("lastVersion", "1");
                        } else {
                            userStoreWBO.setAttribute("lastVersion", "0");
                        }
                        
                        userStores.add(userStoreWBO);
                    }
                }
                
                depDocPrevMgr = DepDocPrevMgr.getInstance();
                if (depDocPrevMgr.saveDocTypeDeps(docTypeID, userStores, session)) {
                    request.setAttribute("Status", "ok");
                } else {
                    request.setAttribute("Status", "no");
                }
                
                projectMgr = ProjectMgr.getInstance();
                departments = projectMgr.getAllDepartments();
                docTypeMgr = DocTypeMgr.getInstance();
                docTypeMgr.cashData();
                docTypes = new ArrayList(docTypeMgr.getCashedTable());
                depDocPrevMgr = DepDocPrevMgr.getInstance();
                selectedDeps = depDocPrevMgr.getDepartmentIDs(docTypeID);
                selectedLastVersion = depDocPrevMgr.getLastVersionIDs(docTypeID);
                selectedDocType = docTypeMgr.getOnSingleKey(docTypeID);
                request.setAttribute("departments", departments);
                request.setAttribute("docTypeID", docTypeID);
                request.setAttribute("selectedDocType", selectedDocType);
                request.setAttribute("docTypes", docTypes);
                request.setAttribute("selectedDeps", selectedDeps);
                request.setAttribute("selectedLastVersion", selectedLastVersion);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 49:
                out = response.getWriter();
                UserAreaMgr userAreaMgr = UserAreaMgr.getInstance();
                WebBusinessObject userAreaWbo = new WebBusinessObject();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (userAreaMgr.deleteOnArbitraryKey(request.getParameter("userID"), "key1") >= 0
                            && userAreaMgr.saveUserArea(request.getParameter("userID"), request.getParameter("areaID"),
                                    request.getParameter("roleID"), new java.sql.Date(sdf.parse(request.getParameter("beginDate")).getTime()), session)) {
                        userAreaWbo.setAttribute("status", "Ok");
                    } else {
                        userAreaWbo.setAttribute("status", "faild");
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                    userAreaWbo.setAttribute("status", "faild");
                }
                
                out.write(Tools.getJSONObjectAsString(userAreaWbo));
                break;
                
            case 50:
                out = response.getWriter();
                userAreaMgr = UserAreaMgr.getInstance();
                userAreaWbo = userAreaMgr.getLastUserArea(request.getParameter("userID"));
                if (userAreaWbo.getAttribute("areaId") != null) {
                    WebBusinessObject projectWbo = projectMgr.getOnSingleKey((String) userAreaWbo.getAttribute("areaId"));
                    userAreaWbo.setAttribute("areaName", projectWbo.getAttribute("projectName"));
                }
                
                if (userAreaWbo.getAttribute("beginDate") != null) {
                    userAreaWbo.setAttribute("beginDateString", ((String) userAreaWbo.getAttribute("beginDate")).split(" ")[0]);
                }
                
                userAreaWbo.setAttribute("status", "Ok");
                out.write(Tools.getJSONObjectAsString(userAreaWbo));
                break;
                
            case 51:
                servedPage = "/docs/projects/new_building.jsp";
                projectMgr = ProjectMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>();
                locationTypeMgr = LocationTypeMgr.getInstance();
                wbo = locationTypeMgr.getOnSingleKey("1432442667723");
                request.setAttribute("location_type_code", wbo.getAttribute("arDesc"));
                res = projectMgr.getAllProjects("1364111290870");
                for (int i = 0; i < res.size(); i++) {
                    wbo = (WebBusinessObject) res.get(i);
                    parents.add(wbo);
                }
                
                request.setAttribute("locationTypesList", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 52:
                servedPage = "/docs/Adminstration/viewUnits.jsp";
                modelId = request.getParameter("models");

                eqNO = request.getParameter("unitProject");
                eqNO += "-" + request.getParameter("unitModel");
                eqNO += "-B." + request.getParameter("unitNo");
                try {
                    Vector tempVec = projectMgr.getOnArbitraryKeyOracle(eqNO, "key1");
                    if (tempVec.size() > 0) {
                        servedPage = "/docs/projects/new_building.jsp";
                        projectMgr = projectMgr.getInstance();
                        parents = new ArrayList<WebBusinessObject>();
                        locationTypeMgr = LocationTypeMgr.getInstance();
                        wbo = locationTypeMgr.getOnSingleKey("1432442667723");
                        request.setAttribute("location_type_code", wbo.getAttribute("arDesc"));
                        res = projectMgr.getAllProjects("1364111290870");
                        for (int i = 0; i < res.size(); i++) {
                            wbo = (WebBusinessObject) res.get(i);
                            parents.add(wbo);
                        }
                        
                        request.setAttribute("alreadyExist", "ok");
                        request.setAttribute("locationTypesList", parents);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                project = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                wbo = locationTypeMgr.getOnSingleKey("1432442667723");
                request.setAttribute("location_type_code", wbo.getAttribute("arDesc"));
                project.setAttribute("location_type", wbo.getAttribute("typeCode"));
                mainProjectId = request.getParameter("mainProduct");
                project.setAttribute(ProjectConstants.PROJECT_NAME, eqNO);
                project.setAttribute(ProjectConstants.EQ_NO, modelId); // awl 4 fields rkm l 3emara wkda 
                project.setAttribute(ProjectConstants.PROJECT_DESC, request.getParameter("option_one") + "F" + "*" + request.getParameter("option_two") + "A"); // kemet l 7adeka
                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "0");
                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "0");
                project.setAttribute("mainProjectId", mainProjectId);
                project.setAttribute("futile", "0");

                project.setAttribute("coordinate", "UL"); //mesa7et l we7da
                project.setAttribute("option_one", request.getParameter("option_one")); // el msa7a l kolia
                project.setAttribute("option_three", "UL"); //mesa7et l 7adeka
                project.setAttribute("option_two", request.getParameter("option_two")); // 3a2d l 7adeeka

                String objId = null;
                try {
                    objId = projectMgr.saveBuilding(project, session);
                    if (objId != null && !objId.equals("")) {
                        WebBusinessObject buildingPriceAreaWbo = new WebBusinessObject();
                        buildingPriceAreaWbo.setAttribute("unitID", objId);
                        if (request.getParameter("garage") != null) {
                            try {
                                int garageNo = Integer.parseInt(request.getParameter("garage"));
                                buildingPriceAreaWbo.setAttribute("minPrice", garageNo + "");
                                request.setAttribute("garage", garageNo + "");
                            } catch (NumberFormatException ne) {
                                buildingPriceAreaWbo.setAttribute("minPrice", "0");
                            }
                        } else {
                            buildingPriceAreaWbo.setAttribute("minPrice", "0");
                        }
                        
                        buildingPriceAreaWbo.setAttribute("maxPrice", request.getParameter("totalArea")); // Total Area
                        buildingPriceAreaWbo.setAttribute("option1", request.getParameter("netArea")); // Net Area
                        if (request.getParameter("elevator") != null) {
                            buildingPriceAreaWbo.setAttribute("option2", "1");
                        } else {
                            buildingPriceAreaWbo.setAttribute("option2", "0");
                        }
                        
                        if (request.getParameter("garden") != null) {
                            buildingPriceAreaWbo.setAttribute("option3", "1");
                        } else {
                            buildingPriceAreaWbo.setAttribute("option3", "0");
                        }
                        
                        UnitPriceMgr.getInstance().saveObject(buildingPriceAreaWbo, loggedUser);
                        request.setAttribute("Status", "Ok");
                        request.setAttribute("projId", session.getAttribute("projId"));
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                    request.setAttribute("Status", "No");
                }
                
                projectMgr = ProjectMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>();
                res = projectMgr.getAllProjects("1364287917750");
                for (int i = 0; i < res.size(); i++) {
                    wbo = (WebBusinessObject) res.get(i);
                    parents.add(wbo);
                }
                
                request.setAttribute("locationTypesList", parents);
                WebBusinessObject proWbo = (WebBusinessObject) projectMgr.getOnSingleKey(objId);
                request.setAttribute("project", proWbo);
                request.setAttribute("rows", request.getParameter("option_one"));
                request.setAttribute("flats", request.getParameter("option_two"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 53:
                servedPage = "/docs/Adminstration/viewUnits.jsp";
                modelId = request.getParameter("modelId");
                parentWbo = projectMgr.getOnSingleKey(modelId);
                project = new WebBusinessObject();
                locationTypeMgr = LocationTypeMgr.getInstance();
                wbo = locationTypeMgr.getOnSingleKey("1432442667723");
                request.setAttribute("location_type_code", wbo.getAttribute("arDesc"));
                project.setAttribute("location_type", "RES-UNIT");
                project.setAttribute(ProjectConstants.EQ_NO, "UL"); // awl 4 fields rkm l 3emara wkda 
                project.setAttribute(ProjectConstants.PROJECT_DESC, ""); // kemet l 7adeka
                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "0");
                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "0");
                project.setAttribute("mainProjectId", modelId);
                project.setAttribute("futile", "0");
                project.setAttribute("coordinate", parentWbo.getAttribute("mainProjId")); // Project ID
                project.setAttribute("option_one", ""); // el msa7a l kolia
//                project.setAttribute("option_three", request.getParameter("option_three")); //mesa7et l 7adeka
                project.setAttribute("option_two", ""); // 3a2d l 7adeeka                
                String rows = (String) parentWbo.getAttribute("optionOne");
                String flats = (String) parentWbo.getAttribute("optionTwo");
                String status = "";
                for (int x = 0; x < new Integer(rows); x++) {
                    int z = 0;
                    if (x == 0) {
                        z = (x);
                    } else {
                        z = 100 * (x);
                    }
//                    Integer z = 100 * (x + 1);
                    for (int y = 0; y < new Integer(flats); y++) {
                        Integer fNum = z + y + 1;
                        if (x == 0) {
                            eqNO = parentWbo.getAttribute("projectName").toString() + " - A.00" + fNum;
                        } else {
                            eqNO = parentWbo.getAttribute("projectName").toString() + " - A." + fNum;
                        }
                        
                        project.setAttribute(ProjectConstants.PROJECT_NAME, eqNO);
                        project.setAttribute("option_three", fNum.toString());
                        try {
                            if (projectMgr.saveAppartment(project, session)) {
                                request.setAttribute("status", "ok");
                                //request.setAttribute("projId", session.getAttribute("projId"));
                                request.setAttribute("dataSaved", "Ok");
                                status = "ok";
                            } else {
                                request.setAttribute("status", "no");
                                status = "no";
                            }
                        } catch (NoUserInSessionException ex) {
                            request.setAttribute("status", "no");
                            status = "no";
                        }
                    }
                }
                
                if (request.getParameter("garage") != null) {
                    try {
                        int garageNo = Integer.parseInt(request.getParameter("garage"));
                        if (garageNo > 0) {
                            project = new WebBusinessObject();
                            project.setAttribute("location_type", "GRG-UNIT"); // Garage
                            project.setAttribute(ProjectConstants.EQ_NO, "UL");
                            project.setAttribute(ProjectConstants.PROJECT_DESC, "");
                            project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "0");
                            project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "0");
                            project.setAttribute("mainProjectId", modelId);
                            project.setAttribute("futile", "0");
                            project.setAttribute("coordinate", parentWbo.getAttribute("mainProjId")); // Project ID
                            project.setAttribute("option_one", "");
                            project.setAttribute("option_two", "");
                            for (int i = 1; i <= garageNo; i++) {
                                eqNO = parentWbo.getAttribute("projectName").toString() + " - G." + i;
                                project.setAttribute(ProjectConstants.PROJECT_NAME, eqNO);
                                project.setAttribute("option_three", "UL");
                                try {
                                    if (projectMgr.saveAppartment(project, session)) { // Garage
                                        request.setAttribute("status", "ok");
                                        request.setAttribute("dataSaved", "Ok");
                                        status = "ok";
                                    } else {
                                        request.setAttribute("status", "no");
                                        status = "no";
                                    }
                                } catch (NoUserInSessionException ex) {
                                    request.setAttribute("status", "no");
                                    status = "no";
                                }
                            }
                        }
                    } catch (NumberFormatException ne) {}
                }
                
                projectMgr = ProjectMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>();
                res = projectMgr.getAllProjects("1364287917750");
                for (int i = 0; i < res.size(); i++) {
                    wbo = (WebBusinessObject) res.get(i);
                    parents.add(wbo);
                }

                request.setAttribute("rows", rows);
                request.setAttribute("flats", flats);
                request.setAttribute("project", parentWbo);
                request.setAttribute("projectId", modelId);
                request.setAttribute("status", status);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 54:
                servedPage = "/docs/projects/viewUnit.jsp";
                String unitId = request.getParameter("unitId");
                String numberOfUnits = request.getParameter("numberOfUsers");
                String index_ = request.getParameter("index");
                project = projectMgr.getOnSingleKey(unitId);
                Tools.createUnitSideMenu(unitId, project.getAttribute("mainProjId").toString(), index_, numberOfUnits, request);
                request.setAttribute("unit", project);
                request.setAttribute("index", index_);
                request.setAttribute("numberOfUnits", numberOfUnits);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 55:
                projectId = request.getParameter("projectId");
                project = projectMgr.getOnSingleKey(projectId);
                typeName = (String) request.getParameter("type");
                rows = (String) project.getAttribute("optionOne");
                flats = (String) project.getAttribute("optionTwo");
                servedPage = "/docs/Adminstration/viewUnits.jsp";
                request.setAttribute("project", project);
                request.setAttribute("rows", rows);
                request.setAttribute("flats", flats);
                request.setAttribute("page", servedPage);
                Vector projV = new Vector();
                try {
                    projV = projectMgr.getOnArbitraryKey(projectId, "key2");
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                if (projV.size() > 0) {
                    request.setAttribute("status", "ok");
                }
                
                if (typeName != null && typeName.equals("tree")) {
                    this.forward(servedPage, request, response);
                    break;
                } else {
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 56:
                try {
                    Vector buildings = projectMgr.getOnArbitraryKeyOracle("CMPLX-UNIT", "key6");

                    servedPage = "/docs/Adminstration/buildings_list.jsp";

                    request.setAttribute("data", buildings);
                    request.setAttribute("page", servedPage);
                } catch (Exception e) {}
                
                this.forwardToServedPage(request, response);
                break;
                
            case 57:
                String buildingName = request.getParameter("buildingName");
                String buildingId = request.getParameter("buildingId");
                servedPage = "/docs/Adminstration/confirm_del_building.jsp";
                try {
                    if (buildingName == null || buildingName.equals("")) {
                        buildingName = ((WebBusinessObject) projectMgr.getOnSingleKey(buildingId)).getAttribute("projectName").toString();
                    }
                } catch (Exception e) {
                    buildingName = ((WebBusinessObject) projectMgr.getOnSingleKey(buildingId)).getAttribute("projectName").toString();
                }

                request.setAttribute("buildingName", buildingName);
                request.setAttribute("buildingId", buildingId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 58:
                buildingId = request.getParameter("buildingId");
                if (projectMgr.deleteBuilding(buildingId)) {
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "fail");
                }
                
                try {
                    Vector buildings = projectMgr.getOnArbitraryDoubleKeyOracle("RES-UNIT", "key6", "1", "key8");
                    request.setAttribute("data", buildings);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                servedPage = "/docs/Adminstration/buildings_list.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 59:
                servedPage = "/docs/projects/show_units_list.jsp";
                buildingId = request.getParameter("buildingId");
                request.setAttribute("buildingId", buildingId);
                request.setAttribute("buildingWbo", projectMgr.getOnSingleKey(buildingId));
                if (buildingId != null && !buildingId.isEmpty()) {
                    try {
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
                            ArrayList<WebBusinessObject> unitsList = projectMgr.getUnitsStatusByParent(buildingId, (String) departmentWbo.getAttribute("projectID"));
                            request.setAttribute("unitsList", unitsList);
                        }
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                
                this.forward(servedPage, request, response);
                break;
                
            case 60:
                servedPage = "/docs/projects/units_list.jsp";
                buildingId = request.getParameter("buildingId");
                request.setAttribute("buildingId", buildingId);
                if (buildingId != null && !buildingId.isEmpty()) {
                    try {
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
                            ArrayList<WebBusinessObject> unitsList = projectMgr.getUnitsStatusByParent(buildingId, (String) departmentWbo.getAttribute("projectID"));
                            request.setAttribute("unitsList", unitsList);
                        }
                        
                        WebBusinessObject buildingWbo = projectMgr.getOnSingleKey(buildingId);
                        ArrayList<WebBusinessObject> modelsList = new ArrayList<WebBusinessObject>();
                        if (buildingWbo != null && buildingWbo.getAttribute("mainProjId") != null) {
//                            modelsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle((String) buildingWbo.getAttribute("mainProjId"), "key2", "UNIT-MODEL", "key4"));
                            modelsList = projectMgr.getAllUnitsUnderProject(buildingId);
                            modelsList.addAll(projectMgr.getOnArbitraryDoubleKeyOracle((String) buildingWbo.getAttribute("mainProjId"), "key2", "RES-MODEL", "key4"));
                        }
                        
                        request.setAttribute("modelsList", modelsList);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 61:
                servedPage = "/docs/projects/units_list.jsp";
                buildingId = request.getParameter("buildingId");
                modelId = request.getParameter("modelID");
                if (modelId != null && !modelId.isEmpty()) {
                    String[] unitIDs = request.getParameterValues("unitID");
                    if (unitIDs != null && unitIDs.length > 0) {
                        boolean save = false;
                        for (String unitIdTemp : unitIDs) {
                            try {
                                if (projectMgr.updateUnitModel(modelId, unitIdTemp)) {
                                    save = true;
                                }
                            } catch (NoUserInSessionException ex) {
                                save = false;
                            }
                        }
                        
                        request.setAttribute("status", save ? "ok" : "failed");
                    } else {
                        request.removeAttribute("status");
                    }
                }
                
                request.setAttribute("buildingId", buildingId);
                if (buildingId != null && !buildingId.isEmpty()) {
                    try {
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
                            ArrayList<WebBusinessObject> unitsList = projectMgr.getUnitsStatusByParent(buildingId, (String) departmentWbo.getAttribute("projectID"));
                            request.setAttribute("unitsList", unitsList);
                        }
                        
                        WebBusinessObject buildingWbo = projectMgr.getOnSingleKey(buildingId);
                        ArrayList<WebBusinessObject> modelsList = new ArrayList<WebBusinessObject>();
                        if (buildingWbo != null && buildingWbo.getAttribute("mainProjId") != null) {
//                            modelsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle((String) buildingWbo.getAttribute("mainProjId"), "key2", "UNIT-MODEL", "key4"));
                            modelsList = projectMgr.getAllUnitsUnderProject(buildingId);
                            modelsList.addAll(projectMgr.getOnArbitraryDoubleKeyOracle((String) buildingWbo.getAttribute("mainProjId"), "key2", "RES-MODEL", "key4"));
                        }
                        
                        request.setAttribute("modelsList", modelsList);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 62:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                try {
                    if (projectMgr.deleteOnSingleKey(request.getParameter("unitId"))) {
                        wbo.setAttribute("status", "Ok");
                    } else {
                        wbo.setAttribute("status", "faild");
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    wbo.setAttribute("status", "faild");
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 63:
                servedPage = "/docs/projects/search_unit_list.jsp";
                projectMgr = ProjectMgr.getInstance();
                List<WebBusinessObject> unitsList = new ArrayList<WebBusinessObject>();
                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();

                userMgr = UserMgr.getInstance();
                ArrayList<FilterCondition> conditions = new ArrayList<FilterCondition>();
                itemNo = request.getParameter("itemNo");
                String fieldName = request.getParameter("fieldName");
                String fieldValue = request.getParameter("fieldValue");

                filter = Tools.getPaginationInfo(request, response);
                conditions.addAll(filter.getConditions());
                conditions.add(new FilterCondition("I.STATUS_NAME", "8", Operations.EQUAL));
                conditions.add(new FilterCondition("I.END_DATE", null, Operations.IS_NULL));
                conditions.add(new FilterCondition("LOCATION_TYPE", "RES-UNIT", Operations.EQUAL));
                conditions.add(new FilterCondition("PROJECTFLAG", "0", Operations.EQUAL));
                // For apartment rules
                EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                WebBusinessObject departmentWbo;
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                //
                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition(fieldName, fieldValue, Operations.LIKE));
                }
                
                filter.setConditions(conditions);
                try {
                    if (departmentWbo != null) {
                        ApartmentRuleMgr apartmentRuleMgr = ApartmentRuleMgr.getInstance();
                        ArrayList<WebBusinessObject> rulesList = new ArrayList<WebBusinessObject>(
                                apartmentRuleMgr.getOnArbitraryDoubleKeyOracle((String) departmentWbo.getAttribute("projectID"), "key2", "8", "key3"));
                        if (rulesList.size() > 0) {
                            unitsList = projectMgr.paginationEntity(filter, " INNER JOIN ISSUE_STATUS I ON PROJECT_ID = I.BUSINESS_OBJ_ID ");
                        }
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }

                filter.setConditions(conditions);
                request.setAttribute("data", unitsList);
                request.setAttribute("filter", filter);
                request.setAttribute("itemNo", itemNo);
                this.forward(servedPage, request, response);
                break;
                
            case 64:
                wbo = new WebBusinessObject();
                WebBusinessObject statusWbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                try {
                    sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    String newStatusCode = "11";
                    wbo.setAttribute("statusCode", newStatusCode);
                    wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                    wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
                    wbo.setAttribute("statusNote", "Customer Status");
                    wbo.setAttribute("objectType", "client");
                    wbo.setAttribute("parentId", "UL");
                    wbo.setAttribute("issueTitle", "UL");
                    wbo.setAttribute("cuseDescription", "UL");
                    wbo.setAttribute("actionTaken", "UL");
                    wbo.setAttribute("preventionTaken", "UL");
                    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                    ClientMgr clientMgr = ClientMgr.getInstance();
                    if (projectMgr.saveSellUnit(request, session) && issueStatusMgr.changeStatus(wbo, persistentUser, null)
                            && clientMgr.updateClientStatus(request.getParameter("clientId"), newStatusCode, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                        statusWbo.setAttribute("status", "ok");
                    } else {
                        statusWbo.setAttribute("status", "no");
                    }
                    wbo.setAttribute("projectName", projectMgr.getOnSingleKey(request.getParameter("unitCategoryId")).getAttribute("projectName"));
                    wbo.setAttribute("id", request.getAttribute("clientProjectID"));
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(statusWbo));
                break;
                
            case 65:
                productId = (String) request.getParameter("productId");
                session.setAttribute("product", productId);
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "ok");
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 66:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                String updateType = request.getParameter("editType");
                String updateValue = "";
                if (updateType.equalsIgnoreCase("name")) {
                    updateValue = request.getParameter("projectName");
                }
                if (updateType.equalsIgnoreCase("unitlevel")) {
                    updateValue = request.getParameter("unitLevel");
                }
                
                if (projectMgr.updateProject(request.getParameter("projectID"), updateType, updateValue)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "faild");
                }
                
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 67:
                String projectId = request.getParameter("projectId");
                wbo = new WebBusinessObject();
                String clientComplaint = request.getParameter("clientComplaintIds");
                String[] clientComplaints = clientComplaint.split(",");
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                boolean saved = clientComplaintsMgr.addClientComplaintProject(projectId, clientComplaints, session);
                if (saved) {
                    wbo.setAttribute("status", "ok");
                } else {
                    wbo.setAttribute("status", "failed");
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 68:
                servedPage = "/docs/Adminstration/dep_task_prev.jsp";
                projectMgr = ProjectMgr.getInstance();
                DepTaskPrevMgr depTaskPrevMgr = DepTaskPrevMgr.getInstance();
                ArrayList<WebBusinessObject> departmentsList = new ArrayList<WebBusinessObject>();
                try {
                    departmentsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("div", "key4"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();

                String departmentID = request.getParameter("departmentID");
                ArrayList ticketTypes = null;
        {
            try {
                ticketTypes = issueByComplaintAllCaseMgr.getTicketTypes();
            } catch (NoSuchColumnException ex) {
                java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
                
                if (departmentID == null && ticketTypes != null && ticketTypes.size() > 0) {
                    departmentID = ((String) ((WebBusinessObject) ticketTypes.get(0)).getAttribute("type_id"));
                }

                ArrayList<String> selectedTypes = depTaskPrevMgr.getTaskTypeIDs(departmentID);

                request.setAttribute("departments", departmentsList);
                request.setAttribute("tickets", ticketTypes);
                request.setAttribute("page", servedPage);
                request.setAttribute("departmentID", departmentID);
                request.setAttribute("selectedTypes", selectedTypes);

                this.forwardToServedPage(request, response);
                break;

            case 69:
                servedPage = "/docs/Adminstration/dep_task_prev.jsp";
                departmentID = request.getParameter("departmentID");
                String[] taskTypeIDs = request.getParameterValues("taskTypeID");
                ArrayList<String> selectedTaskTypeIDs = new ArrayList<String>();
                if (taskTypeIDs != null) {
                    selectedTaskTypeIDs.addAll(Arrays.asList(taskTypeIDs));
                }
                
                depTaskPrevMgr = DepTaskPrevMgr.getInstance();
                if (depTaskPrevMgr.saveDepartmentTaskTypes(departmentID, selectedTaskTypeIDs, session)) {
                    request.setAttribute("Status", "ok");
                } else {
                    request.setAttribute("Status", "no");
                }
                
                projectMgr = ProjectMgr.getInstance();
                issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                departmentsList = new ArrayList<WebBusinessObject>();
                try {
                    departmentsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("div", "key4"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                ticketTypes = new ArrayList();
        {
            try {
                ticketTypes = issueByComplaintAllCaseMgr.getTicketTypes();
            } catch (NoSuchColumnException ex) {
                java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

                selectedTypes = depTaskPrevMgr.getTaskTypeIDs(departmentID);

                request.setAttribute("departments", departmentsList);
                request.setAttribute("departmentID", departmentID);
                request.setAttribute("tickets", ticketTypes);
                request.setAttribute("selectedTypes", selectedTypes);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;

            case 70:
                servedPage = "/docs/Adminstration/ShowFolders.jsp";
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                ArrayList<WebBusinessObject> arrayOfProjects = projectMgr.getProjectWithUserCreated(securityUser.getUserId());
                request.setAttribute("page", servedPage);
                request.setAttribute("mFolders", arrayOfProjects);
                this.forwardToServedPage(request, response);
                break;

            case 71:
                servedPage = "/docs/Adminstration/mFolderProjects.jsp";
                String folderID = request.getParameter("folderID");
//                issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                ArrayList<WebBusinessObject> arrayOfClientComplaint = projectMgr.getDocumentInFolder(folderID);
//                ArrayList<WebBusinessObject> arrayOfClientComplaint =  issueByComplaintAllCaseMgr.getAllCaseByClientComplaintCode(folderID);
                request.setAttribute("clientComplaints", arrayOfClientComplaint);
                this.forward(servedPage, request, response);
                break;

            case 72:
                pName = request.getParameter("projectName");
                eqNO = request.getParameter("projectName");
                pDescription = request.getParameter("projectName");
                isMngmntStn = request.getParameter(null);
                isTrnsprtStn = request.getParameter(null);

                isMngmntStn = (isMngmntStn != null) ? "1" : "0";
                isTrnsprtStn = (isTrnsprtStn != null) ? "1" : "0";

                project = new WebBusinessObject();

                mainProjectId = request.getParameter("mainProjectId");
                project.setAttribute(ProjectConstants.PROJECT_NAME, pName);
                project.setAttribute(ProjectConstants.EQ_NO, eqNO);
                project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, isMngmntStn);
                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, isTrnsprtStn);
                wbo = projectMgr.getOnSingleKey(request.getParameter("mainProjectId"));
                if (wbo != null) {
                    WebBusinessObject parentProjectWbo = projectMgr.getOnSingleKey((String) wbo.getAttribute("mainProjId"));
                    if (parentProjectWbo != null) {
                        project.setAttribute("optionOne", parentProjectWbo.getAttribute("projectName"));
                    }
                }
                
                if (mainProjectId == null) {
                    project.setAttribute("mainProjectId", "0");
                } else {
                    project.setAttribute("mainProjectId", mainProjectId);
                }
                
                project.setAttribute("futile", "0");
                project.setAttribute("location_type", "UNIT-MODEL");
                try {
                    if (!projectMgr.getDoubleName(pName, "key1") && !projectMgr.getDoubleName(eqNO, "key3")) {
                        if (projectMgr.saveObject(project, session)) {
                            response.getWriter().write("Ok");
//                            request.setAttribute("Status", "Ok");
                        } else {
                            response.getWriter().write("No");
//                            request.setAttribute("Status", "No");
                        }
                    } else {
                        response.getWriter().write("NO-Dublicate");
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                break;
                
            case 73:
                servedPage = "/docs/Search/search_for_unit.jsp";
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                try {
                    if (projectMgr.saveOnholdUnit(request, session) && saveReservation(request, session) != null) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    
                    wbo.setAttribute("projectName", projectMgr.getOnSingleKey(request.getParameter("unitCategoryId")).getAttribute("projectName"));
                    if (request.getParameter("changeStatus") != null && request.getParameter("changeStatus").equalsIgnoreCase("true")) {
                        sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        String newStatusCode = "11";
                        wbo.setAttribute("statusCode", newStatusCode);
                        wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                        wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
                        wbo.setAttribute("statusNote", "Customer Status");
                        wbo.setAttribute("objectType", "client");
                        wbo.setAttribute("parentId", "UL");
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                        ClientMgr clientMgr = ClientMgr.getInstance();
                        wbo.setAttribute("status", "no");
                        if (issueStatusMgr.changeStatus(wbo, persistentUser, null)
                                && clientMgr.updateClientStatus(request.getParameter("clientId"), newStatusCode, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                            wbo.setAttribute("status", "ok");
                        }
                        
                        String statusCode = "8";
                        issueId = request.getParameter("issueId");
                        String clientComplaintId = request.getParameter("clientComplaintId");
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        WebBusinessObject manager = UserMgr.getInstance().getOnSingleKey(CRMConstants.FINANCIAL_MANAGER_ID);
                        WebBusinessObject complaint = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                        if ((complaint != null) && (manager != null)) {
                            clientComplaintsMgr.tellManager(manager, issueId, statusCode, "Reservation", "Reservation", persistentUser);
                        }
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 74:
                servedPage = "/docs/projects/search_unit_list.jsp";
                projectMgr = ProjectMgr.getInstance();
                unitsList = new ArrayList<WebBusinessObject>();
                filter = new com.silkworm.pagination.Filter();
                userMgr = UserMgr.getInstance();
                conditions = new ArrayList<FilterCondition>();
                itemNo = request.getParameter("itemNo");
                fieldName = request.getParameter("fieldName");
                fieldValue = request.getParameter("fieldValue");
                filter = Tools.getPaginationInfo(request, response);
                conditions.addAll(filter.getConditions());
                conditions.add(new FilterCondition("I.STATUS_NAME", "9", Operations.NOT_EQUAL));
                conditions.add(new FilterCondition("I.STATUS_NAME", "10", Operations.NOT_EQUAL));
                conditions.add(new FilterCondition("I.END_DATE", null, Operations.IS_NULL));
                conditions.add(new FilterCondition("LOCATION_TYPE", "RES-UNIT", Operations.EQUAL));
                conditions.add(new FilterCondition("PROJECTFLAG", "0", Operations.EQUAL));
                // For apartment rules
                empRelationMgr = EmpRelationMgr.getInstance();
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                
                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition(fieldName, fieldValue, Operations.LIKE));
                }
                
                filter.setConditions(conditions);
                try {
                    if (departmentWbo != null) {
                        ApartmentRuleMgr apartmentRuleMgr = ApartmentRuleMgr.getInstance();
                        ArrayList<WebBusinessObject> rulesList = new ArrayList<WebBusinessObject>(
                                apartmentRuleMgr.getOnArbitraryDoubleKeyOracle((String) departmentWbo.getAttribute("projectID"), "key2", "8", "key3"));
                        if (rulesList.size() > 0) {
                            unitsList = projectMgr.paginationEntity(filter, " INNER JOIN ISSUE_STATUS I ON PROJECT_ID = I.BUSINESS_OBJ_ID ");
                        }
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                
                filter.setConditions(conditions);
                request.setAttribute("data", unitsList);
                request.setAttribute("filter", filter);
                request.setAttribute("itemNo", itemNo);
                request.setAttribute("forOnhold", "true");
                this.forward(servedPage, request, response);
                break;
                
            case 75:
                ArrayList<WebBusinessObject> projectList = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> neightborhoodList = new ArrayList<WebBusinessObject>();
                try {
                    WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    UserCompaniesMgr userCompanyMgr = UserCompaniesMgr.getInstance();
                    WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", waUser.getAttribute("userId").toString());
                    if (userCompanyWbo != null) {
                        products = projectMgr.getOnArbitraryKey(userCompanyWbo.getAttribute("companyID").toString(), "key2");
                        wbo = new WebBusinessObject();
                        wbo = (WebBusinessObject) products.get(0);
                        projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) wbo.getAttribute("mainProjId"), "key2")));
                    } else {
                        projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("44", "key6")));
//                        products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
//                        WebBusinessObject wbo = (WebBusinessObject) products.get(0);
//                        mainProducts = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    }
                    
                    //projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("44", "key6")));
                    WebBusinessObject projectAcc = null;
                    for (int i = 0; i < projectList.size(); i++) {
                        projectAcc = projectAccMgr.getProjectAccount(projectList.get(i).getAttribute("projectID") + "");
                        if (projectAcc.countAttribute() == 0) {
                            projectAcc.setAttribute("maxInstalments", "0");
                            projectAcc.setAttribute("projectId", projectList.get(i).getAttribute("projectID") + "");
                            projectAcc.setAttribute("OPTION_1", "Nill");
                            projectAcc.setAttribute("OPTION_2", "Nill");
                            projectAcc.setAttribute("OPTION_3", "Nill");
                            if (projectAccMgr.saveObject(projectAcc, session)) {
                                projectAcc = (WebBusinessObject) projectAccMgr.getOnArbitraryKey(projectList.get(i).getAttribute("projectID") + "", "key2").get(0);
                            }
                        }
                        
                        projectList.get(i).setAttribute("projectAcc", projectAcc);
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                servedPage = "/docs/Adminstration/project_engineer_list.jsp";

                neightborhoodList = new ArrayList<WebBusinessObject>();
                try {
                    neightborhoodList = projectMgr.getOnArbitraryKey2("garea", "key6");
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                StandardPaymentPlanMgr standardPaymentPlanMgr = StandardPaymentPlanMgr.getInstance();
                ArrayList<WebBusinessObject> sPayPlanLst = standardPaymentPlanMgr.getStandaredPayPlans(null, null);
                Map<String, String> projectPrices = unitPriceMgr.getProjectsTotalPrice();
                request.setAttribute("projectPrices", projectPrices);
                request.setAttribute("totalSum", projectPrices.values().stream().mapToDouble(t -> (Double.valueOf(t))).sum() + "");

                request.setAttribute("sPayPlanLst", sPayPlanLst);

                request.setAttribute("data", projectList);
                request.setAttribute("neightborhoodList", neightborhoodList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 76:
                servedPage = "/docs/Adminstration/manage_project_engineer.jsp";
                UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                try {
                    request.setAttribute("projectEngineersList", userCompanyProjectsMgr.getAllEngineersInProject(request.getParameter("projectID")));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("projectID", request.getParameter("projectID"));
                this.forward(servedPage, request, response);
                break;
                
            case 77:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                String[] userIDsList = request.getParameterValues("id");
                if (userIDsList != null) {
                    for (String idUserProject : userIDsList) {
                        try {
                            if (userCompanyProjectsMgr.deleteOnSingleKey(idUserProject)) {
                                wbo.setAttribute("status", "Ok");
                            } else {
                                wbo.setAttribute("status", "faild");
                            }
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 78:
                servedPage = "/docs/calendar/visit_appointment_calendar.jsp";
                Calendar c = Calendar.getInstance();
                java.util.Date beginDate = c.getTime();
                c.add(Calendar.MONTH, 1);
                c.add(Calendar.DATE, -1);
                CalendarUtils utils = CalendarUtils.getInstance();
                List<CalendarUtils.Day> days = utils.getDaysShort(beginDate, c.getTime());
                AppointmentNotificationMgr notificationMgr = AppointmentNotificationMgr.getInstance();
                List<WebBusinessObject> appList = notificationMgr.getVisitCountsByDate(beginDate, c.getTime(), null);
                String userName;
                Map<String, WebBusinessObject> appointmentDay;
                Map<String, Map<String, WebBusinessObject>> appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                int appointmentDayValue;
                for (WebBusinessObject appointment : appList) {
                    userId = (String) appointment.getAttribute("userId");
                    userName = (String) appointment.getAttribute("userName");
                    appointmentDay = appointmentInfo.get(userId + "@@" + userName);
                    if (appointmentDay == null) {
                        appointmentDay = new HashMap();
                        appointmentInfo.put(userId + "@@" + userName, appointmentDay);
                    }

                    try {
                        appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                        appointmentDay.put(appointmentDayValue + "", appointment);
                    } catch (NumberFormatException ex) {
                        logger.error(ex);
                    }
                }
                
                userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                clientId = request.getParameter("clientID");
                clientProductMgr = ClientProductMgr.getInstance();
                projectID = "";
                try {
                    ArrayList<WebBusinessObject> purcheUnits = new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle("purche", "key4", clientId, "key1"));
                    ArrayList<WebBusinessObject> reservedUnit = new ArrayList<>(clientProductMgr.getReservedUnit(clientId));
                    for (WebBusinessObject unitWbo : purcheUnits) {
                        tempWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("projectId"));
                        if (tempWbo != null && tempWbo.getAttribute("coordinate") != null && !"UL".equals(tempWbo.getAttribute("coordinate"))) {
                            projectID = (String) tempWbo.getAttribute("coordinate");
                        } else if (unitWbo.getAttribute("productCategoryId") != null) {
                            projectID = (String) unitWbo.getAttribute("productCategoryId");
                            break;
                        }
                    }
                    
                    if (projectID == null || projectID.isEmpty()) {
                        for (WebBusinessObject unitWbo : reservedUnit) {
                            tempWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("projectId"));
                            if (tempWbo != null && tempWbo.getAttribute("coordinate") != null && !"UL".equals(tempWbo.getAttribute("coordinate"))) {
                                projectID = (String) tempWbo.getAttribute("coordinate");
                            } else if (unitWbo.getAttribute("productCategoryId") != null) {
                                projectID = (String) unitWbo.getAttribute("productCategoryId");
                                break;
                            }
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    ArrayList<WebBusinessObject> usersInProjectList = new ArrayList<>(userCompanyProjectsMgr.getOnArbitraryDoubleKeyOracle(
                            projectID, "key2", CRMConstants.TRADE_FIELD_TECHNICIAN_ID, "key4"));
                    for (WebBusinessObject userWbo : usersInProjectList) {
                        userId = (String) userWbo.getAttribute("userId");
                        tempWbo = userMgr.getOnSingleKey(userId);
                        userName = (String) tempWbo.getAttribute("fullName");
                        appointmentDay = appointmentInfo.get(userId + "@@" + userName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(userId + "@@" + userName, appointmentDay);
                        }
                        
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("roleType", "technician");
                        appointmentDay.put("userRole", wbo);
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                clientProductMgr = ClientProductMgr.getInstance();
                try {
                    request.setAttribute("unitsList", new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("clientID"), "key1", "purche", "key4")));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("page", servedPage);
                request.setAttribute("projectID", projectID);
                request.setAttribute("days", days);
                request.setAttribute("data", appointmentInfo);
                this.forward(servedPage, request, response);
                break;
                
            case 79:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                wbo.setAttribute("status", "faild");
                try {
                    if (projectMgr.updateUnitModel(request.getParameter("modelID"), request.getParameter("projectID"))) {
                        wbo.setAttribute("status", "Ok");
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 80:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                unitPriceMgr = UnitPriceMgr.getInstance();

                wbo = unitPriceMgr.getOnSingleKey("key1", request.getParameter("unitId"));
                WebBusinessObject unitWbo = projectMgr.getOnSingleKey(request.getParameter("unitId"));
                if (unitWbo != null) {
                    WebBusinessObject modelWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("eqNO"));
                    WebBusinessObject floorWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("optionThree"));
                    if (modelWbo != null) {
                        wbo.setAttribute("modelName", modelWbo.getAttribute("projectName"));
                    }
                    if (floorWbo != null) {
                        wbo.setAttribute("floorName", floorWbo.getAttribute("projectName"));
                    }
                }

//                if(wbo == null){
//                    jsonStr = "no";
//                } else {
//                    jsonStr = wbo.getAttribute("option1").toString();
//                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 81:
                servedPage = "/docs/Adminstration/WorkList.jsp";
                request.setAttribute("page", servedPage);
                if (request.getParameterValues("workItemcheck") != null) {
                    String workItemsIndex[] = request.getParameterValues("workItemcheckIndex");
                    String workItemsID[] = request.getParameterValues("workItemcheck");
                    String workItemsUnit[] = request.getParameterValues("unit");
                    String workItemsValue[] = request.getParameterValues("value");
                    String equipTypesValue[] = request.getParameterValues("equipClass"); //Kareem
                    String minValues[] = request.getParameterValues("minValue");
                    String maxValues[] = request.getParameterValues("maxValue");
                    projectMgr.updateWorkItems(workItemsID, workItemsUnit, workItemsValue, workItemsIndex, equipTypesValue, null,
                            minValues, maxValues);
                }
                
                List allItems = projectMgr.getAllWorkItems();
                List units = expenseItemMgr.getMeasurementUnits("time");
                Vector equipClass = projectMgr.getAllEquipClass(); //Kareem
                request.setAttribute("workItemsList", allItems);
                request.setAttribute("measuerUnits", units);
                request.setAttribute("equipClass", new ArrayList<>(equipClass));//Kareem
                this.forwardToServedPage(request, response);
                break;
                
            case 83:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                if (request.getParameter("issueID") != null) {
                    if (issueMgr.deleteDocRequests(request.getParameter("issueID"))) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "faild");
                    }
                } else {
                    wbo.setAttribute("status", "faild");
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 84:
                wbo = new WebBusinessObject();

                projectMgr = ProjectMgr.getInstance();
                try {
                    if (projectMgr.deleteSellUnit(request.getParameter("garageID"), session)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                wbo.setAttribute("status", "ok");
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 85:
                PDFTools pdfTolls = new PDFTools();

                HashMap parameters = new HashMap();

                parameters.put("ID", request.getParameter("issueID"));

                pdfTolls.generatePdfReport("PercrutmentReport", parameters, getServletContext(), response);
                break;

            case 86:
                servedPage = "/docs/UnitFinance/new_account.jsp";

                String creationType = request.getParameter("creationType");
                projectId = request.getParameter("projectId");
                project = projectMgr.getOnSingleKey(projectId);

                String projectIdChain = project.getAttribute("optionThree").toString();
                String projectRank = project.getAttribute("optionTwo").toString();
                String projectType = project.getAttribute("location_type").toString();

                defaultProjectWbo = null;
                mainProjectVec = null;

                request.setAttribute("projectId", projectId);
                request.setAttribute("projectIdChain", projectIdChain);
                request.setAttribute("projectRank", projectRank);
                request.setAttribute("projectType", projectType);
                request.setAttribute("project", project);
                request.setAttribute("creationType", creationType);
                try {
                    if (request.getParameter("type").equals("tree")) {
                        request.setAttribute("type", "tree");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 87:
                projectMgr = ProjectMgr.getInstance();

                String accountName = request.getParameter("accountName");
                String finalDestination = request.getParameter("finalDestination");
                String accountType = request.getParameter("accountType");
                String costCenter = request.getParameter("costCenter");
                String accountCurency = request.getParameter("accountCurency");
                String deliveryDate = request.getParameter("deliveryDate");
                String debit = request.getParameter("debit");
                String creditor = request.getParameter("creditor");
                String accountCode=request.getParameter("accountCode");
                creationType = request.getParameter("creationType");
                projectIdChain = request.getParameter("projectIdChain");
                projectRank = request.getParameter("projectRank");
                projectType = request.getParameter("projectType");
                projectId = request.getParameter("projectId");
                

                WebBusinessObject accountWBO = new WebBusinessObject();
                accountWBO.setAttribute("accountName", accountName);
                accountWBO.setAttribute("finalDestination", finalDestination);
                accountWBO.setAttribute("accountType", accountType);
                accountWBO.setAttribute("costCenter", costCenter);
                accountWBO.setAttribute("accountCurency", accountCurency);
                accountWBO.setAttribute("projectIdChain", projectIdChain);
                accountWBO.setAttribute("projectRank", projectRank);
                accountWBO.setAttribute("projectType", projectType);
                accountWBO.setAttribute("projectId", projectId);
                accountWBO.setAttribute("creationType", creationType);
                accountWBO.setAttribute("deliveryDate", deliveryDate);
                accountWBO.setAttribute("debit", debit);
                accountWBO.setAttribute("creditor", creditor);
                accountWBO.setAttribute("accountCode", accountCode);

                
                accountWBO.setAttribute("eqNO", request.getParameter("eqNO"));
                try {
                    if (projectMgr.saveAccount(accountWBO, session)) {
                        System.out.println("ok");
                    } else {
                        System.out.println("no");
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                servedPage = "docs/projects/projects_tree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 88:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                try {
                    sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    wbo.setAttribute("statusCode", CRMConstants.CLIENT_STATUS_CUSTOMER);
                    wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                    wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
                    wbo.setAttribute("statusNote", "Customer Status");
                    wbo.setAttribute("objectType", "client");
                    wbo.setAttribute("parentId", "UL");
                    wbo.setAttribute("issueTitle", "UL");
                    wbo.setAttribute("cuseDescription", "UL");
                    wbo.setAttribute("actionTaken", "UL");
                    wbo.setAttribute("preventionTaken", "UL");
                    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                    if (projectMgr.saveRentUnit(request, session) && issueStatusMgr.changeStatus(wbo, persistentUser, null)) {
                        wbo.setAttribute("statusCode", CRMConstants.UNIT_STATUS_RENT);
                        wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                        wbo.setAttribute("businessObjectId", request.getParameter("unitId"));
                        wbo.setAttribute("statusNote", "Rent");
                        wbo.setAttribute("objectType", "Housing_Units");
                        wbo.setAttribute("parentId", "UL");
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        if (issueStatusMgr.changeStatus(wbo, persistentUser, null)) {
                            wbo.setAttribute("status", "ok");
                        }
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    
                    wbo.setAttribute("projectName", projectMgr.getOnSingleKey(request.getParameter("unitCategoryId")).getAttribute("projectName"));
                    wbo.setAttribute("id", request.getAttribute("clientProjectID"));
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 89:
                servedPage = "/docs/UnitFinance/new_costCenter.jsp";

                projectId = request.getParameter("projectId");
                project = projectMgr.getOnSingleKey(projectId);

                projectIdChain = project.getAttribute("optionThree").toString();
                projectRank = project.getAttribute("optionTwo").toString();
                projectType = project.getAttribute("location_type").toString();

                defaultProjectWbo = null;
                mainProjectVec = null;

                request.setAttribute("projectId", projectId);
                request.setAttribute("projectIdChain", projectIdChain);
                request.setAttribute("projectRank", projectRank);
                request.setAttribute("projectType", projectType);
                request.setAttribute("project", project);
                try {
                    if (request.getParameter("type").equals("tree")) {
                        request.setAttribute("type", "tree");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 90:
                projectMgr = ProjectMgr.getInstance();
                accountName = request.getParameter("accountName");
                finalDestination = request.getParameter("finalDestination");
                accountType = request.getParameter("accountType");
                costCenter = request.getParameter("costCenter");
                accountCurency = request.getParameter("accountCurency");
                deliveryDate = request.getParameter("deliveryDate");
                debit = request.getParameter("debit");
                creditor = request.getParameter("creditor");
                projectIdChain = request.getParameter("projectIdChain");
                projectRank = request.getParameter("projectRank");
                projectType = request.getParameter("projectType");
                projectId = request.getParameter("projectId");

                accountWBO = new WebBusinessObject();
                accountWBO.setAttribute("accountName", accountName);
                accountWBO.setAttribute("finalDestination", finalDestination);
                accountWBO.setAttribute("accountType", accountType);
                accountWBO.setAttribute("costCenter", costCenter);
                accountWBO.setAttribute("accountCurency", accountCurency);
                accountWBO.setAttribute("projectIdChain", projectIdChain);
                accountWBO.setAttribute("projectRank", projectRank);
                accountWBO.setAttribute("projectType", projectType);
                accountWBO.setAttribute("projectId", projectId);
                accountWBO.setAttribute("deliveryDate", deliveryDate);
                accountWBO.setAttribute("debit", debit);
                accountWBO.setAttribute("creditor", creditor);
                try {
                    if (projectMgr.saveCostCenter(accountWBO, session)) {
                        System.out.println("ok");
                    } else {
                        System.out.println("no");
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                servedPage = "docs/projects/projects_tree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 91:
                pdfTolls = new PDFTools();

                parameters = new HashMap();

                pdfTolls.generatePdfReport("CrossTabReport", parameters, getServletContext(), response);
                break;
                
            case 92: //Kareem

                UserCompanyProjectsMgr userCompanyProjectsMgr2 = UserCompanyProjectsMgr.getInstance();
                ArrayList<WebBusinessObject> projectList1 = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> projectsList2 = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> intervalsList = new ArrayList<WebBusinessObject>();
                TradeMgr tradeMgr = TradeMgr.getInstance();
                Vector tradeVector = new Vector();
                String tradeId, intervalId;
                if (request.getParameter("tradeId") != null && !request.getParameter("tradeId").equals("")) {
                    tradeId = (String) request.getParameter("tradeId");
                } else {
                    tradeId = "%";
                }
                
                if (request.getParameter("projectID") != null && !request.getParameter("projectID").equals("")) {
                    projectId = (String) request.getParameter("projectID");
                } else {
                    projectId = "%";
                }
                
                if (request.getParameter("intervalId") != null && !request.getParameter("intervalId").equals("")) {
                    intervalId = (String) request.getParameter("intervalId");
                } else {
                    intervalId = "";
                }
                
                try {
                    //projectList1.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("44", "key6")));
                    //projectList1.addAll(new ArrayList<WebBusinessObject>(userCompanyProjectsMgr2.getAllUsersWithProjects("44",projectId,tradeId)));//("44")));//projectMgr.getOnArbitraryKeyOracle("44", "key6").toString())));
                    projectList1.addAll(new ArrayList<WebBusinessObject>(userCompanyProjectsMgr2.getAllUsersWithProjects("44", projectId, tradeId, intervalId)));//("44")));//projectMgr.getOnArbitraryKeyOracle("44", "key6").toString())));
                    WebBusinessObject wbo4 = (WebBusinessObject) (new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("PRODUCTS", "key3"))).get(0);
                    projectsList2 = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) wbo4.getAttribute("projectID"), "key2"));
                    tradeVector = tradeMgr.getTradeByType("0");
                    intervalsList = new ArrayList<WebBusinessObject>(userCompanyProjectsMgr2.getAllIntervals());
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                servedPage = "/docs/Financials/list_sales_targets.jsp";

                request.setAttribute("data", projectList1);
                request.setAttribute("projectsList", projectsList2);
                request.setAttribute("tradeVector", tradeVector);
                request.setAttribute("intervals", intervalsList);
                //request.setAttribute("RolrsList", tradeVector);
                if (tradeId.equals("%")) {
                    tradeId = "1";
                }
                
                request.setAttribute("tradeId", tradeId);
                if (projectId.equals("%")) {
                    projectId = "1";
                }
                
                request.setAttribute("projectIds", projectId);
                if (intervalId.equals("")) {
                    intervalId = "1";
                }
                
                request.setAttribute("intervalId", intervalId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            //Kareem End
            case 93:
                servedPage = "/docs/Adminstration/edite_project_account.jsp";

                ProjectEntityMgr projectEntityMgr = ProjectEntityMgr.getInstance();
                ArrayList<WebBusinessObject> entityLst = new ArrayList<WebBusinessObject>();
                try {
                    entityLst = projectEntityMgr.getEntityLst(request.getParameter("projectAccId"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("entityLst", entityLst);

                request.setAttribute("projectAccId", request.getParameter("projectAccId"));
                request.setAttribute("projectName", request.getParameter("projectName"));
                request.setAttribute("projectWbo", projectMgr.getOnSingleKey(request.getParameter("projectID")));
                request.setAttribute("addEntity", request.getParameter("addEntity"));
                this.forward(servedPage, request, response);
                break;
                
            case 94:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                String projectAccId = request.getParameter("projectAccId") + "";
                int maxInstaments = Integer.parseInt(request.getParameter("maxInstaments") + "");
                int mPrice = 0;
                try {
                    mPrice = Integer.parseInt(request.getParameter("mPrice"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                String garageNum = request.getParameter("garageNum");
                String lockerNum = request.getParameter("lockerNum");
                
                if (request.getParameter("projectID") != null && request.getParameter("projectDesc") != null) {
                    WebBusinessObject projectWbo = projectMgr.getOnSingleKey(request.getParameter("projectID"));
                    projectWbo.setAttribute("projectDesc", request.getParameter("projectDesc"));
                    try {
                        projectMgr.updateProject(projectWbo);
                        wbo.setAttribute("status", "ok");
                    } catch (NoUserInSessionException ex) {
                        java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                if (projectAccMgr.updateprojectAccount(projectAccId, maxInstaments, mPrice, garageNum, lockerNum) == true) {
                    wbo = projectAccMgr.getOnSingleKey(projectAccId);
                    // save project price history begin
                    WebBusinessObject historyWbo = new WebBusinessObject();
                    historyWbo.setAttribute("projectID", wbo.getAttribute("projectId"));
                    historyWbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                    historyWbo.setAttribute("unitNum", wbo.getAttribute("maxInstalments"));
                    historyWbo.setAttribute("meterPrice", wbo.getAttribute("meterPrice"));
                    historyWbo.setAttribute("garageNum", wbo.getAttribute("garageNumber"));
                    historyWbo.setAttribute("lockerNum", wbo.getAttribute("lockerNumber"));
                    historyWbo.setAttribute("option1", "UL");
                    historyWbo.setAttribute("option2", "UL");
                    historyWbo.setAttribute("option3", "UL");
                    historyWbo.setAttribute("option4", "UL");
                    historyWbo.setAttribute("option5", "UL");
                    historyWbo.setAttribute("option6", "UL");
                    ProjectPriceHistoryMgr.getInstance().saveObject(historyWbo);
                    // end
                    wbo.setAttribute("status", "ok");
                } else {
                    wbo.setAttribute("status", "faile");
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 95: //Kareem
                out = response.getWriter();
                wbo = new WebBusinessObject();
                //UnitPriceMgr unitPriceMgr = UnitPriceMgr.getInstance();
                UserCompanyProjectsMgr userComProjMgr = UserCompanyProjectsMgr.getInstance();
                WebBusinessObject saletargetWbo = new WebBusinessObject();
                saletargetWbo.setAttribute("ID", request.getParameter("IDs"));
                //saletargetWbo.setAttribute("minPrice", "0");
                if (request.getParameter("Interval_Id") != null && !request.getParameter("Interval_Id").isEmpty()) {
                    saletargetWbo.setAttribute("Interval_Id", request.getParameter("Interval_Id"));
                } else {
                    saletargetWbo.setAttribute("Interval_Id", "0");
                }
                
                if (request.getParameter("targetValue") != null && !request.getParameter("targetValue").isEmpty()) {
                    saletargetWbo.setAttribute("targetValue", request.getParameter("targetValue"));
                } else {
                    saletargetWbo.setAttribute("targetValue", "0");
                }
                
                if (userComProjMgr.saveSalesTarget(saletargetWbo, loggedUser)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "faild");
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;//Kareem End
                
            case 96:
                projectList = new ArrayList<WebBusinessObject>();
                neightborhoodList = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> projectZone = new ArrayList<WebBusinessObject>();
                try {
                    neightborhoodList = projectMgr.getOnArbitraryKey2("garea", "key6");
                    WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    UserCompaniesMgr userCompanyMgr = UserCompaniesMgr.getInstance();
                    WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", waUser.getAttribute("userId").toString());
                    if (userCompanyWbo != null) {
                        products = projectMgr.getOnArbitraryKey(userCompanyWbo.getAttribute("companyID").toString(), "key2");
                        wbo = new WebBusinessObject();
                        wbo = (WebBusinessObject) products.get(0);
                        projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) wbo.getAttribute("mainProjId"), "key2")));
                    } else {
                        projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("44", "key6")));
//                        products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
//                        WebBusinessObject wbo = (WebBusinessObject) products.get(0);
//                        mainProducts = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    }
                    
                    //projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("44", "key6")));
                    WebBusinessObject projectAcc = null;
                    for (int i = 0; i < projectList.size(); i++) {
                        projectAcc = projectAccMgr.getProjectAccount(projectList.get(i).getAttribute("projectID") + "");
                        if (projectAcc.countAttribute() == 0) {
                            projectAcc.setAttribute("maxInstalments", "0");
                            projectAcc.setAttribute("projectId", projectList.get(i).getAttribute("projectID") + "");
                            projectAcc.setAttribute("OPTION_1", "Nill");
                            projectAcc.setAttribute("OPTION_2", "Nill");
                            projectAcc.setAttribute("OPTION_3", "Nill");
                            if (projectAccMgr.saveObject(projectAcc, session)) {
                                projectAcc = (WebBusinessObject) projectAccMgr.getOnArbitraryKey(projectList.get(i).getAttribute("projectID") + "", "key2").get(0);
                            }
                        }
                        
                        projectList.get(i).setAttribute("projectAcc", projectAcc);
                        projectZone = projectMgr.getPrjZone(projectList.get(i).getAttribute("projectID").toString());
                        if (projectZone != null && !projectZone.isEmpty()) {
                            projectList.get(i).setAttribute("projectZone", projectZone.get(0).getAttribute("zoneID"));
                            projectList.get(i).setAttribute("prjZoneName", projectMgr.getPrjZoneName(projectZone.get(0).getAttribute("zoneID").toString()).get(0).getAttribute("zoneName"));
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                servedPage = "/docs/Adminstration/attach_projects.jsp";

                request.setAttribute("data", projectList);
                request.setAttribute("neightborhoodList", neightborhoodList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 97:
                ArrayList<WebBusinessObject> areaLst = new ArrayList<>();
                projectMgr = ProjectMgr.getInstance();
                String areaID = null;
                projectList = new ArrayList();
                try {
                    areaLst = new ArrayList<>(projectMgr.getOnArbitraryKey("55", "key6"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (areaID == null && !areaLst.isEmpty()) {
                    areaID = (String) areaLst.get(0).getAttribute("projectID");
                }

                try {
                    projectList = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                String savePrj = request.getParameter("save");
                if (savePrj != null && !savePrj.isEmpty()) {
                    String[] prjIDLst = request.getParameterValues("prjID");
                    boolean save = false;
                    if (savePrj.equals("trueRegion")) {
                        areaID = request.getParameter("areaID");
                        if (prjIDLst != null && prjIDLst.length > 0) {
                            save = false;
                            for (String prjID : prjIDLst) {
                                try {
                                    WebBusinessObject usr = (WebBusinessObject) session.getAttribute("loggedUser");
                                    if (projectMgr.addPrjArea(areaID, prjID, usr.getAttribute("userId").toString())) {
                                        save = true;
                                    }
                                } catch (NoUserInSessionException ex) {
                                    save = false;
                                }
                            }
                        }
                    } else if (savePrj.equals("truePaySys")) {
                        String paySysID = request.getParameter("paySysID");
                        if (prjIDLst != null && prjIDLst.length > 0) {
                            save = false;
                            for (String prjID : prjIDLst) {
                                try {
                                    WebBusinessObject usr = (WebBusinessObject) session.getAttribute("loggedUser");
                                    if (projectMgr.addPrjPaySys(paySysID, prjID, usr.getAttribute("userId").toString())) {
                                        save = true;
                                    }
                                } catch (NoUserInSessionException ex) {
                                    save = false;
                                }
                            }
                        }
                    }
                    
                    request.setAttribute("status", save ? "ok" : "failed");
                }

                request.setAttribute("areaLst", areaLst);
                request.setAttribute("areaID", areaID);
                request.setAttribute("projectList", projectList);
                if (request.getParameter("page") != null && request.getParameter("page").equals("prjEngLst")) {
                    this.forward("/ProjectServlet?op=getProjectList", request, response);
                } else {
                    servedPage = "/docs/projects/projectNBHood.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 98:
                out = response.getWriter();
                project = new WebBusinessObject();
                sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                project.setAttribute("businessObjectId", request.getParameter("projectID"));
                project.setAttribute("objectType", CRMConstants.OBJECT_TYPE_PROJECT);
                project.setAttribute("statusCode", request.getParameter("newStatus"));
                project.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                project.setAttribute("parentId", "UL");
                project.setAttribute("issueTitle", "UL");
                project.setAttribute("statusNote", "UL");
                project.setAttribute("cuseDescription", "UL");
                project.setAttribute("actionTaken", "UL");
                project.setAttribute("preventionTaken", "UL");
                try {
                    if (issueStatusMgr.changeStatus(project, persistentUser, null)
                            && projectMgr.updateProjectStatus(request.getParameter("projectID"), request.getParameter("newStatus"))) {
                        project.setAttribute("status", "Ok");
                    } else {
                        project.setAttribute("status", "faild");
                    }
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                out.write(Tools.getJSONObjectAsString(project));
                break;
                
            // MOVED To UnitServlet
//            case 64:
//                servedPage = "/docs/units/new_ResidentialModel.jsp";
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//            case 65:
//              
//                pName = request.getParameter(ProjectConstants.PROJECT_NAME);
//                eqNO = request.getParameter(ProjectConstants.EQ_NO);
//                pDescription = request.getParameter(ProjectConstants.PROJECT_DESC);
//                isMngmntStn = request.getParameter(ProjectConstants.IS_MNGMNT_STN);
//                isTrnsprtStn = request.getParameter(ProjectConstants.IS_TRNSPRT_STN);
//
//                isMngmntStn = (isMngmntStn != null) ? "1" : "0";
//                isTrnsprtStn = (isTrnsprtStn != null) ? "1" : "0";
//
//                project = new WebBusinessObject();
//
////                String backTo = request.getParameter("backTo");
//                mainProjectId = request.getParameter("mainProjectId");
//                servedPage = "/docs/units/new_ResidentialModel.jsp";
//                project.setAttribute(ProjectConstants.PROJECT_NAME, pName);
//                project.setAttribute(ProjectConstants.EQ_NO, eqNO);
//                project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
//                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, isMngmntStn);
//                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, isTrnsprtStn);
//                if (mainProjectId == null) {
//                    project.setAttribute("mainProjectId", "0");
//                } else {
//                    project.setAttribute("mainProjectId", mainProjectId);
//                }
//                project.setAttribute("futile", request.getParameter("futile"));
//                project.setAttribute("location_type", request.getParameter("location_type"));
//
//                try {
//                    if (!projectMgr.getDoubleName(pName, "key1")&& !projectMgr.getDoubleName(eqNO, "key3")) {
//                        if (projectMgr.saveObject(project, session)) {
//                            request.setAttribute("Status", "Ok");
//                        } else {
//                            request.setAttribute("Status", "No");
//                        }
//
//                    } else {
//                        request.setAttribute("Status", "No");
//                        request.setAttribute("name", "Duplicate Name");
//                    }
//                } catch (NoUserInSessionException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                projectMgr = ProjectMgr.getInstance();
//                allSites = projectMgr.getAllNotFutileProjects();
//                locationTypesList = new ArrayList<WebBusinessObject>();
//                locationTypeMgr = LocationTypeMgr.getInstance();
//                locationTypesList = locationTypeMgr.getCashedTableAsBusObjects();
//                request.setAttribute("allSites", allSites);
//                request.setAttribute("locationTypesList", locationTypesList);
//                try {
//                    if (backTo.equals("projTree")) {
//                        //servedPage = "ProjectServlet?op=showTree";
//                        this.forward("ProjectServlet?op=showTree", request, response);
//                        break;
//                    } else {
//                        request.setAttribute("page", servedPage);
//                        this.forwardToServedPage(request, response);
//                        break;
//                    }
//                } catch (Exception ex) {
//
//                    if (mainProjectId == null) {
//                        mainProjectId = "0";
//                    }
//                }
//                break;
                
            case 99:
                out = response.getWriter();

                WebBusinessObject entityWbo = new WebBusinessObject();

                String processType = request.getParameter("processType");
                projectAccId = request.getParameter("projectAccId");
                String entityType = request.getParameter("entityType");
                String entityPrice = request.getParameter("entityPrice");
                String entityArea = request.getParameter("entityArea");

                projectEntityMgr = ProjectEntityMgr.getInstance();

                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                String entityID = new String();
                if (processType != null) {
                    if (processType.equals("add")) {
                        entityID = projectEntityMgr.addEntity(projectAccId, entityType, entityPrice, entityArea, (String) loggedUser.getAttribute("userId"));
                        if (!entityID.equals("")) {
                            entityWbo = projectEntityMgr.getOnSingleKey(entityID);
                            entityWbo.setAttribute("status", "ok");
                        } else {
                            entityWbo.setAttribute("status", "faile");
                        }
                    } else if (processType.equals("update")) {
                        if (projectEntityMgr.updateEntity(projectAccId, entityPrice, entityArea) == true) {
                            entityWbo = projectEntityMgr.getOnSingleKey(projectAccId);
                            entityWbo.setAttribute("status", "ok");
                        } else {
                            entityWbo.setAttribute("status", "faile");
                        }
                    } else if (processType.equals("delete")) {
                        if (projectEntityMgr.deleteEntity(projectAccId) == true) {
                            entityWbo.setAttribute("status", "ok");
                        } else {
                            entityWbo.setAttribute("status", "faile");
                        }
                    }
                }

                out.write(Tools.getJSONObjectAsString(entityWbo));
                break;
                
            case 100:
                servedPage = "docs/Adminstration/projectDetailes.jsp";

                String prjID = request.getParameter("prjID");

                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> NBIDLst = projectMgr.getPrjRegions(prjID);
                ArrayList<WebBusinessObject> regionsInfoLst = projectMgr.getRegionsInfo(NBIDLst);

                request.setAttribute("regionsInfoLst", regionsInfoLst);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
                
            case 101:
                ArrayList<WebBusinessObject> zoneLst = new ArrayList<>();
                projectMgr = ProjectMgr.getInstance();
                areaID = null;
                projectList = new ArrayList();
                try {
                    zoneLst = new ArrayList<>(projectMgr.getOnArbitraryKey("55", "key6"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (areaID == null && !zoneLst.isEmpty()) {
                    areaID = (String) zoneLst.get(0).getAttribute("projectID");
                }

                try {
                    projectList = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                savePrj = request.getParameter("save");
                if (savePrj != null && !savePrj.isEmpty()) {
                    String[] prjIDLst = request.getParameterValues("prjID");
                    boolean save = false;
                    if (savePrj.equals("true")) {
                        areaID = request.getParameter("zoneID");
                        if (prjIDLst != null && prjIDLst.length > 0) {
                            save = false;
                            for (String prjIDStr : prjIDLst) {
                                try {
                                    WebBusinessObject usr = (WebBusinessObject) session.getAttribute("loggedUser");
                                    if (projectMgr.addPrjZone(areaID, prjIDStr, usr.getAttribute("userId").toString())) {
                                        save = true;
                                    }
                                } catch (NoUserInSessionException ex) {
                                    save = false;
                                }
                            }
                        }
                    }
                    
                    request.setAttribute("status", save ? "ok" : "failed");
                }

                request.setAttribute("areaLst", zoneLst);
                request.setAttribute("areaID", areaID);
                request.setAttribute("projectList", projectList);
                this.forward("/ProjectServlet?op=attatchProjects", request, response);
                break;

            case 102:
                servedPage = "docs/calendar/visit_app_calendar.jsp";
                c = Calendar.getInstance();
                beginDate = c.getTime();
                c.add(Calendar.MONTH, 1);
                c.add(Calendar.DATE, -1);
                utils = CalendarUtils.getInstance();
                days = utils.getDaysShort(beginDate, c.getTime());
                notificationMgr = AppointmentNotificationMgr.getInstance();
                appList = notificationMgr.getVisitCountsByDate(beginDate, c.getTime(), null);
                appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                for (WebBusinessObject appointment : appList) {
                    userId = (String) appointment.getAttribute("userId");
                    userName = (String) appointment.getAttribute("userName");
                    appointmentDay = appointmentInfo.get(userId + "@@" + userName);
                    if (appointmentDay == null) {
                        appointmentDay = new HashMap();
                        appointmentInfo.put(userId + "@@" + userName, appointmentDay);
                    }

                    try {
                        appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                        appointmentDay.put(appointmentDayValue + "", appointment);
                    } catch (NumberFormatException ex) {
                        logger.error(ex);
                    }
                }
                
                userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                clientId = request.getParameter("clientID");
                clientProductMgr = ClientProductMgr.getInstance();
                projectID = "";

                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> projectLst = projectMgr.getAllProjectForClient(clientId);
                request.setAttribute("projectLst", projectLst);
                try {
                    ArrayList<WebBusinessObject> usersInProjectList = new ArrayList<WebBusinessObject>();
                    for (int i = 0; i < projectLst.size(); i++) {
                        WebBusinessObject prjWbo = projectLst.get(i);
                        usersInProjectList.addAll(new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryDoubleKeyOracle(
                                prjWbo.getAttribute("projectID").toString(), "key2", CRMConstants.TRADE_FIELD_TECHNICIAN_ID, "key4")));
                    }
                    
                    for (WebBusinessObject userWbo : usersInProjectList) {
                        userId = (String) userWbo.getAttribute("userId");
                        tempWbo = userMgr.getOnSingleKey(userId);
                        userName = (String) tempWbo.getAttribute("fullName");
                        appointmentDay = appointmentInfo.get(userId + "@@" + userName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(userId + "@@" + userName, appointmentDay);
                        }
                        
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("roleType", "technician");
                        appointmentDay.put("userRole", wbo);
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                clientProductMgr = ClientProductMgr.getInstance();
                try {
                    request.setAttribute("unitsList", new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("clientID"), "key1", "purche", "key4")));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                ArrayList<WebBusinessObject> equClass = new ArrayList<WebBusinessObject>();
                try {
                    equClass = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("EQP_CLASS", "key6"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("projectID", projectID);
                request.setAttribute("equClass", equClass);
                request.setAttribute("days", days);
                request.setAttribute("data", appointmentInfo);
                this.forward(servedPage, request, response);
                break;

            case 103:
                if (request.getParameter("projectId") != null) {
                    //define the json 
                    main = new JSONObject();
                    menu = new JSONObject();
                    menuItems = new JSONArray();

                    this.jsonMenu = new JSONObject();
                    this.JsonList = new JSONArray();

                    //Define menu JSON Reader
                    parser = new JSONParser();
                    try {
                        FileReader fileReader = new FileReader(getServletContext().getRealPath("/json") + "/apartmentprojectMenu.json");
                        this.jsonMenu = (JSONObject) parser.parse(fileReader);
                    } catch (Exception ex) {
                        System.out.println("Parsing Error : " + ex.getMessage());
                        logger.error(ex.getMessage());
                    }

                    if (request.getParameter("getCamp") != null && request.getParameter("getCamp").equals("1")) {
                        ArrayList<WebBusinessObject> campaigLst = new ArrayList<WebBusinessObject>();
                        CampaignMgr campaignMgr = new CampaignMgr();
                        campaignMgr = CampaignMgr.getInstance();
                        String projectParentID = request.getParameter("projectId");

                        campaigLst = campaignMgr.getProjectCampaign(projectParentID);

                        //String campsResultJson = JSONValue.toJSONString(campaigLst);
                        out = response.getWriter();
                        out.write(Tools.getJSONArrayAsString(campaigLst));
                    } else {
                        projectLst = new ArrayList<WebBusinessObject>();
                        String projectParentID = request.getParameter("projectId");
                        try {
                            projectLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey(projectParentID, "key2"));
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        WebBusinessObject treeNodeWBO = new WebBusinessObject();
                        JSONObject contextMenu = new JSONObject();
                        JSONArray menuElements = new JSONArray();

                        int currentID = 0;
                        if (projectLst.size() > 0) {
                            for (int i = 0; i < projectLst.size(); i++) {
                                currentID = this.JsonList.size();
                                JSONObject josnObj = new JSONObject();
                                treeNodeWBO = (WebBusinessObject) projectLst.get(i);

                                contextMenu = (JSONObject) this.jsonMenu.get((String) treeNodeWBO.getAttribute("eqNO"));
                                icon = (String) contextMenu.get("icon");
                                menuElements = (JSONArray) contextMenu.get("menuItem");

                                projectName = new String();
                                if (treeNodeWBO.getAttribute("eqNO").toString().equals("Neigbourhood")) {
                                    projectName = (String) treeNodeWBO.getAttribute("projectName");
                                }

                                josnObj.put("id", new Integer(currentID).toString());
                                josnObj.put("projectID", (String) treeNodeWBO.getAttribute("projectID"));
                                josnObj.put("parentid", projectParentID);
                                josnObj.put("text", projectName);
                                josnObj.put("icon", icon);
                                josnObj.put("type", (String) treeNodeWBO.getAttribute("eqNO"));
                                josnObj.put("contextMenu", menuElements);
                                this.JsonList.add(josnObj);

                                //zonePrjLst = projectMgr.getZonePrj(zoneID);
                                getZonePrj((String) treeNodeWBO.getAttribute("projectID"), currentID);
                            }
                        }
                        
                        out = response.getWriter();
                        out.write(JsonList.toJSONString());
                    }
                } else {
                    servedPage = "/docs/UnitFinance/projectsTree.jsp";

                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 104://Kareem
                servedPage = "/docs/Adminstration/MaintenanceList.jsp";
                request.setAttribute("page", servedPage);
                if (request.getParameterValues("workItemcheck") != null) {
                    String workItemsIndex[] = request.getParameterValues("workItemcheckIndex");
                    String workItemsID[] = request.getParameterValues("workItemcheck");
                    String workItemsUnit[] = request.getParameterValues("unit");
                    String workItemsValue[] = request.getParameterValues("value");
                    String equipTypesValue[] = request.getParameterValues("equipClass");
                    projectMgr.updateWorkItems(workItemsID, workItemsUnit, workItemsValue, workItemsIndex, equipTypesValue, null, null, null);
                }
                
                List allItems1 = projectMgr.getAllMaintenanceItems();
                List units1 = expenseItemMgr.getMeasurementUnits("unit");
                Vector equipClass1 = projectMgr.getAllEquipClass();
                request.setAttribute("workItemsList", allItems1);
                request.setAttribute("measuerUnits", units1);
                request.setAttribute("equipClass", equipClass1);
                this.forwardToServedPage(request, response);
                break;  //Kareem end

            case 105:
                servedPage = "/docs/Adminstration/sparePartsList.jsp";
                request.setAttribute("page", servedPage);
                if (request.getParameterValues("sprPrtcheck") != null) {
                    String sprPrtcheckIndex[] = request.getParameterValues("sprPrtcheckIndex");
                    String sprPrtcheckID[] = request.getParameterValues("sprPrtcheck");
                    String sprPrtcheckValue[] = request.getParameterValues("value");
                    String sprPrtcheckQuantity[] = request.getParameterValues("quantity");
                    projectMgr.updateWorkItems(sprPrtcheckID, null, sprPrtcheckValue, sprPrtcheckIndex, null, sprPrtcheckQuantity, null, null);
                }

                ArrayList<WebBusinessObject> sprPrtLst = new ArrayList<WebBusinessObject>();
                try {
                    sprPrtLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("spare_part", "key4"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("sprPrtLst", sprPrtLst);
                this.forwardToServedPage(request, response);
                break;

            case 106:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                updateType = request.getParameter("editType");
                updateValue = "";
                if (updateType.equalsIgnoreCase("desc")) {
                    updateValue = request.getParameter("projectDesc");
                }
                
                if (projectMgr.updateProject(request.getParameter("projectID"), updateType, updateValue)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "faild");
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 107:
                out = response.getWriter();
                try {
                    wbo = projectAccMgr.getProjectAccount(request.getParameter("projectID") != null ? request.getParameter("projectID") : "");
                    if (wbo == null) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("status", "fail");
                    } else {
                        wbo.setAttribute("status", "ok");
                    }
                } catch (UnsupportedConversionException ex) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "fail");
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 108:
                servedPage = "/docs/units/new_unit_type.jsp";
                locationTypeMgr = LocationTypeMgr.getInstance();
                UnitTypeMgr unitTypeMgr = UnitTypeMgr.getInstance();
                if (request.getParameter("save") != null) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("locationTypeID", request.getParameter("type"));
                    wbo.setAttribute("typeName", request.getParameter("name"));
                    wbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                    wbo.setAttribute("option1", "UL");
                    wbo.setAttribute("option2", "UL");
                    wbo.setAttribute("option3", "UL");
                    wbo.setAttribute("option4", "UL");
                    wbo.setAttribute("option5", "UL");
                    wbo.setAttribute("option6", "UL");
                    if (unitTypeMgr.saveObject(wbo)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }
                }
                
                request.setAttribute("locationTypesList", locationTypeMgr.getCashedTableAsBusObjects());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 109:
                servedPage = "/docs/units/unit_types_list.jsp";
                unitTypeMgr = UnitTypeMgr.getInstance();
                request.setAttribute("data", unitTypeMgr.getCashedTableAsArrayList());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 110:
                servedPage = "/docs/units/view_unit_type.jsp";
                unitTypeMgr = UnitTypeMgr.getInstance();
                locationTypeMgr = LocationTypeMgr.getInstance();
                WebBusinessObject unitTypeWbo = unitTypeMgr.getOnSingleKey(request.getParameter("id"));
                wbo = locationTypeMgr.getOnSingleKey((String) unitTypeWbo.getAttribute("locationTypeID"));
                if (wbo != null) {
                    unitTypeWbo.setAttribute("locationTypeName", wbo.getAttribute("arDesc"));
                }
                
                request.setAttribute("unitTypeWbo", unitTypeWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 111:
                servedPage = "/docs/units/update_unit_type.jsp";
                id = request.getParameter("id");
                locationTypeMgr = LocationTypeMgr.getInstance();
                unitTypeMgr = UnitTypeMgr.getInstance();
                if (request.getParameter("update") != null) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", id);
                    wbo.setAttribute("locationTypeID", request.getParameter("type"));
                    wbo.setAttribute("typeName", request.getParameter("name"));
                    wbo.setAttribute("option1", "UL");
                    wbo.setAttribute("option2", "UL");
                    wbo.setAttribute("option3", "UL");
                    wbo.setAttribute("option4", "UL");
                    wbo.setAttribute("option5", "UL");
                    wbo.setAttribute("option6", "UL");
                    if (unitTypeMgr.updateObject(wbo)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }
                }
                
                unitTypeWbo = unitTypeMgr.getOnSingleKey(request.getParameter("id"));
                request.setAttribute("locationTypesList", locationTypeMgr.getCashedTableAsBusObjects());
                request.setAttribute("unitTypeWbo", unitTypeWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 112:
                id = request.getParameter("id");
                unitTypeMgr = UnitTypeMgr.getInstance();
                if (request.getParameter("delete") != null) {
                    servedPage = "/docs/units/unit_types_list.jsp";
                    if (unitTypeMgr.deleteOnSingleKey(id)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }
                    request.setAttribute("data", unitTypeMgr.getCashedTableAsArrayList());
                } else {
                    servedPage = "/docs/units/confirm_del_unit_type.jsp";
                    request.setAttribute("unitTypeWbo", unitTypeMgr.getOnSingleKey(id));
                    request.setAttribute("id", id);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 113:
                out = response.getWriter();
                wbo = projectMgr.getOnSingleKey(request.getParameter("projectID") != null ? request.getParameter("projectID") : "");
                if (wbo == null) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "fail");
                } else {
                    wbo.setAttribute("status", "ok");
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 114:
                servedPage = "/docs/android/attachWithAndroid.jsp";
                AndroidDevicesMgr androidDevicesMgr = AndroidDevicesMgr.getInstance();
		if(request.getParameter("s") != null && request.getParameter("s").equals("1")){
		    if(androidDevicesMgr.attachDeviceToVehicle(request.getParameter("vID"), request.getParameter("dID"))){
			request.setAttribute("save", "1");
		    } else{
			request.setAttribute("save", "0");
		    } 
		}
                
                request.setAttribute("usersList", userMgr.getCashedTableUserAsArrayList());
                request.setAttribute("userDevicesList", androidDevicesMgr.getMsuOrWrkrDevice("wrkr"));
		request.setAttribute("devicesList", androidDevicesMgr.getAvailableDevices());
		request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
		break;
                
            case 115:
		servedPage = "/docs/android/wrkrOrMsuLocation.jsp";
		String vID = (String) request.getParameter("vID");
		wbo = new WebBusinessObject();
                wbo = userMgr.getOnSingleKey(vID);
                request.setAttribute("vName", wbo.getAttribute("fullName"));
		ArrayList<LiteWebBusinessObject> LocationsVector = new ArrayList<>(AndroidLocationsMgr.getInstance().getAllCordinatesByTime(vID));
		request.setAttribute("LocationsVector", LocationsVector);
		this.forward(servedPage, request, response);
		break;
                
            case 116:
                projectList = new ArrayList<WebBusinessObject>();

                WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
                UserCompaniesMgr userCompanyMgr = UserCompaniesMgr.getInstance();
                WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", waUser.getAttribute("userId").toString());
                try {
                    if (userCompanyWbo != null) {
                        products = projectMgr.getOnArbitraryKey(userCompanyWbo.getAttribute("companyID").toString(), "key2");
                        wbo = new WebBusinessObject();
                        wbo = (WebBusinessObject) products.get(0);
                        projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) wbo.getAttribute("mainProjId"), "key2")));
                    } else {
                        projectList.addAll(new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("44", "key6")));
                    }
                    
                    WebBusinessObject projectAcc = null;
                    for (int i = 0; i < projectList.size(); i++) {
                        projectAcc = projectAccMgr.getProjectAccount(projectList.get(i).getAttribute("projectID") + "");
                        if (projectAcc.countAttribute() == 0) {
                            projectAcc.setAttribute("maxInstalments", "0");
                            projectAcc.setAttribute("projectId", projectList.get(i).getAttribute("projectID") + "");
                            projectAcc.setAttribute("OPTION_1", "Nill");
                            projectAcc.setAttribute("OPTION_2", "Nill");
                            projectAcc.setAttribute("OPTION_3", "Nill");
                            projectAcc.setAttribute("meterPrice", "0");
                            projectAcc.setAttribute("garageNumber", "0");
                            projectAcc.setAttribute("lockerNumber", "0");
                            if (projectAccMgr.saveObject(projectAcc, session)) {
                                projectAcc = (WebBusinessObject) projectAccMgr.getOnArbitraryKey(projectList.get(i).getAttribute("projectID") + "", "key2").get(0);
                            }
                        }
                        
                        projectList.get(i).setAttribute("maxInstalments", projectAcc.getAttribute("maxInstalments") != null ? projectAcc.getAttribute("maxInstalments") : "0");
                        projectList.get(i).setAttribute("meterPrice", projectAcc.getAttribute("meterPrice") != null ? projectAcc.getAttribute("meterPrice") : "0");
                        projectList.get(i).setAttribute("garageNumber", projectAcc.getAttribute("garageNumber") != null ? projectAcc.getAttribute("garageNumber") : "0");
                        projectList.get(i).setAttribute("lockerNumber", projectAcc.getAttribute("lockerNumber") != null ? projectAcc.getAttribute("lockerNumber") : "0");
                    }
                    
                    for(int i=0; i< projectList.size(); i++){
                       wbo = projectList.get(i);
                       if(wbo.getAttribute("integratedId") != null && wbo.getAttribute("integratedId").equals("66")){
                           projectList.get(i).setAttribute("status", "Active");
                       } else {
                           projectList.get(i).setAttribute("status", "InActive");
                       }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                StringBuilder title = new StringBuilder("Projects List");
                String headers[] = {"#", "Project Name", "# Of Units", "Meter Price", "# Of Garages", "# Of Lockers", "Status"};
                String attributes[] = {"Number", "projectName", "maxInstalments", "meterPrice", "garageNumber", "lockerNumber", "status"};
                String dataTypes[] = {"", "String", "String", "String", "String", "String", "String"};
                String[] headerStr = new String[1];
                headerStr[0] = title.toString();
                HSSFWorkbook workBook = Tools.createExcelReport("ProjectsList", headerStr, null, headers, attributes, dataTypes, projectList);
                c = Calendar.getInstance();
                java.util.Date fileDate = c.getTime();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                sdf.applyPattern("yyyy-MM-dd");
                String reportDate = sdf.format(fileDate);
                String filename = "ProjectsList" + reportDate;
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
                
            case 117:
                out = response.getWriter();
                projectAccId = request.getParameter("projectAccId");
                wbo = new WebBusinessObject();
                try {
                    ArrayList<WebBusinessObject> unitsLst = projectMgr.getOnArbitraryKey2(projectAccId, "key2");
                    if(unitsLst != null && unitsLst.size() > 0){
                        wbo.setAttribute("status", "yes");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 118:
                projectAccId = request.getParameter("projectAccId");
                wbo = new WebBusinessObject();
                boolean deleteResult = projectMgr.deleteProjectTree(projectAccId);
                if(deleteResult == true){
                    wbo.setAttribute("status", "ok");
                } else {
                    wbo.setAttribute("status", "no");
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 119:
                out = response.getWriter();
                clientProductMgr = ClientProductMgr.getInstance();
                String clntID = request.getParameter("clntID");
                ArrayList<WebBusinessObject> clntUntLst = new ArrayList<WebBusinessObject>(clientProductMgr.getPurcheUnit(clntID));
                
                out.write(Tools.getJSONArrayAsString(clntUntLst));
                break;
                
            case 120:
                servedPage = "/docs/Financials/AllUnits.jsp";
                filter = new com.silkworm.pagination.Filter();
                filter = Tools.getPaginationInfo(request, response);
                conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());
                
                fieldName = request.getParameter("fieldName");
                fieldValue = request.getParameter("fieldValue");
                    
                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                   ArrayList<WebBusinessObject> unitsLst = new ArrayList<WebBusinessObject>();
                    {
                        try {
                            //unitsLst =new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKey("RES-UNIT", "key6",fieldValue , "key1"));
                            unitsLst =new ArrayList<WebBusinessObject>(projectMgr.getSoldUnitsLstFiltered(fieldValue));
                            request.setAttribute("unitsLst", unitsLst);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } 

                } else {
                
                    ArrayList<WebBusinessObject> unitsLst = new ArrayList<WebBusinessObject>();
                    {
                        try {
                            unitsLst = new ArrayList<WebBusinessObject>(projectMgr.getSoldUnitsLst());
                            request.setAttribute("unitsLst", unitsLst);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                request.setAttribute("fieldValue", fieldValue);
                request.setAttribute("filter", filter);
                this.forward(servedPage, request, response);
                break;
                
            case 121:
                out = response.getWriter();
                String meterPrice = "1";
                try {
                    wbo = projectAccMgr.getProjectAccount(request.getParameter("projectID"));
                    if (wbo != null && wbo.getAttribute("meterPrice") != null) {
                        meterPrice = (String) wbo.getAttribute("meterPrice");
                    }
                } catch (UnsupportedConversionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                wbo = new WebBusinessObject();
                wbo.setAttribute("meterPrice", meterPrice);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 122:
                servedPage = "/docs/Financials/AllClients.jsp";
                filter = new com.silkworm.pagination.Filter();
                filter = Tools.getPaginationInfo(request, response);
                conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());
                ClientMgr clientMgr = ClientMgr.getInstance();
                
                fieldName = request.getParameter("fieldName");
                fieldValue = request.getParameter("fieldValue");
                    
                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                   ArrayList<WebBusinessObject> clientsLst = new ArrayList<WebBusinessObject>();
                    {
                        try {
                            //clientsLst =new ArrayList<WebBusinessObject>(clientMgr.getOnArbitraryKey(fieldValue , "key5"));
                            clientsLst =new ArrayList<WebBusinessObject>(clientMgr.getAllCustomersFiltered(fieldValue));
                            request.setAttribute("clientsLst", clientsLst);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } 

                } else {
                
                    ArrayList<WebBusinessObject> clientsLst = new ArrayList<WebBusinessObject>();
                    {
                        try {
                            clientsLst = new ArrayList<WebBusinessObject>(clientMgr.getAllCustomers());
                            //clientsLst = new ArrayList<WebBusinessObject>(clientMgr.getCashedTable());
                            request.setAttribute("clientsLst", clientsLst);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                request.setAttribute("fieldValue", fieldValue);
                request.setAttribute("filter", filter);
                this.forward(servedPage, request, response);
                break; 
                
            case 123:
                servedPage = "/docs/client/clients_classification_per_comChann.jsp";
                ArrayList graphResultList = new ArrayList();
                ArrayList<String> rateNameList = new ArrayList();
                if (request.getParameter("fromDate") != null && request.getParameter("toDate") != null) {
                    try {
                        request.setAttribute("fromDate", request.getParameter("fromDate"));
                        request.setAttribute("toDate", request.getParameter("toDate"));
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        if (request.getParameter("rateID") == null || request.getParameter("rateID").isEmpty()) {
                            ArrayList<WebBusinessObject> ratesList = ProjectMgr.getInstance().getOnArbitraryKey2("CL-RATE", "key4");
                            if (ratesList != null && ratesList.size() > 0) {
                                for (WebBusinessObject TypeTagWbo : ratesList) {
                                    rateNameList.add((String) TypeTagWbo.getAttribute("projectName"));
                                }
                            }
                        } else {
                            rateNameList.addAll(Arrays.asList(request.getParameterValues("rateID")));
                            request.setAttribute("rateID", Tools.arrayToString(request.getParameterValues("rateID"), ","));
                        }
                        ArrayList<WebBusinessObject> resultList = SeasonMgr.getInstance().getCommunicationsClassificationsStat(new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime()),
                                new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime()), rateNameList,
                                request.getParameter("groupID"));
                        if (resultList != null && resultList.size() > 0) {
                            for (WebBusinessObject channelwbo : resultList) {
                                Map<String, Object> graphDataMap = new HashMap<>();
                                ArrayList userDataList = new ArrayList();
                                for (int i = 0; i < rateNameList.size(); i++) {
                                    userDataList.add(channelwbo.getAttribute("rate" + i));
                                }
                                graphDataMap.put("name", channelwbo.getAttribute("channelName"));
                                graphDataMap.put("data", userDataList);
                                graphResultList.add(graphDataMap);
                            }
                            String ratingCategories = JSONValue.toJSONString(rateNameList);
                            String resultsJson = JSONValue.toJSONString(graphResultList);
                            request.setAttribute("ratingCategories", ratingCategories);
                            request.setAttribute("resultsJson", resultsJson);
                            request.setAttribute("graphResult", resultList);
                            request.setAttribute("rateNameList", rateNameList);
                        }
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    Calendar cal = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    request.setAttribute("toDate", sdf.format(cal.getTime()));
                    cal.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(cal.getTime()));
                }
                try {
                    request.setAttribute("rates", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4")));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                request.setAttribute("groupID", request.getParameter("groupID"));        
                request.setAttribute("groups", userGroupConfigMgr.getAllUserGroupConfig((String) persistentUser.getAttribute("userId")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 124:
                servedPage = "/docs/client/appOfClientClassOfComChan.jsp";
                String fromDate = request.getParameter("fromDate");
                String toDate = request.getParameter("toDate");
                String sCallTyp = request.getParameter("sCallTyp");
                String sRate = request.getParameter("sRate");
                String sChannel = request.getParameter("sChannel");
                String groupID = request.getParameter("groupID");
                
                ArrayList<WebBusinessObject> rates = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> comChannels = new ArrayList<WebBusinessObject>();
                if(fromDate != null && toDate != null && sCallTyp != null){
                    clientMgr = ClientMgr.getInstance();
                    ArrayList<WebBusinessObject> appointmentsLst = new ArrayList<WebBusinessObject>();
                    appointmentsLst = clientMgr.getappOfClientClassOfComChan(fromDate, toDate, sCallTyp, sRate, sChannel, groupID);
                    request.setAttribute("appointmentsLst", appointmentsLst);
                }
                SeasonMgr seasonMgr = SeasonMgr.getInstance();
                {
                    try {
                        rates = projectMgr.getOnArbitraryKey2("CL-RATE", "key4");
                        comChannels = seasonMgr.getCashedTableAsArrayList();
                        request.setAttribute("rates", rates);
                        request.setAttribute("comChannels", comChannels);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                List<WebBusinessObject> groups = userGroupConfigMgr.getAllUserGroupConfig((String) loggedUser.getAttribute("userId"));
                
                request.setAttribute("groupID", groupID);        
                request.setAttribute("groups", groups);        
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("sCallTyp", sCallTyp);
                request.setAttribute("sRate", sRate);
                request.setAttribute("sChannel", sChannel);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 125:
                rateNameList = new ArrayList();
                if (request.getParameter("fromDate") != null && request.getParameter("toDate") != null) {
                    try {
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        if (request.getParameter("rateID") == null || request.getParameter("rateID").isEmpty()) {
                            ArrayList<WebBusinessObject> ratesList = ProjectMgr.getInstance().getOnArbitraryKey2("CL-RATE", "key4");
                            if (ratesList != null && ratesList.size() > 0) {
                                for (WebBusinessObject TypeTagWbo : ratesList) {
                                    rateNameList.add((String) TypeTagWbo.getAttribute("projectName"));
                                }
                            }
                        } else {
                            rateNameList.addAll(Arrays.asList(request.getParameterValues("rateID")));
                        }
                        ArrayList<WebBusinessObject> resultList = SeasonMgr.getInstance().getCommunicationsClassificationsStat(new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime()),
                                new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime()), rateNameList,
                                request.getParameter("groupID"));
                        if (resultList != null && resultList.size() > 0) {
                            String headersExc[] = new String[rateNameList.size() + 2];
                            String attributesExc[] = new String[rateNameList.size() + 2];
                            String dataTypesExc[] = new String[rateNameList.size() + 2];
                            headersExc[0] = "#";
                            attributesExc[0] = "Number";
                            dataTypesExc[0] = "";
                            headersExc[1] = "Channel Name";
                            attributesExc[1] = "channelName";
                            dataTypesExc[1] = "String";
                            for (int i = 0; i < rateNameList.size(); i++) {
                                headersExc[i + 2] = rateNameList.get(i);
                                attributesExc[i + 2] = "rate" + i;
                                dataTypesExc[i + 2] = "String";
                            }
                            headerStr = new String[1];
                            headerStr[0] = "Channels Statistics";
                            workBook = Tools.createExcelReport("Channels Statistics", headerStr, null, headersExc, attributesExc, dataTypesExc, resultList);
                            c = Calendar.getInstance();
                            fileDate = c.getTime();
                            sdf = new SimpleDateFormat("dd-MM-yyyy");
                            reportDate = sdf.format(fileDate);
                            filename = "ChannelsStatistics" + reportDate;
                            ServletOutputStream servletOutputStream = response.getOutputStream();
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
                            servletOutputStream.close();
                        }
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                break;
            case 126:
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                sCallTyp = request.getParameter("sCallTyp");
                sRate = request.getParameter("sRate");
                sChannel = request.getParameter("sChannel");
                groupID = request.getParameter("groupID");
                if (fromDate != null && toDate != null && sCallTyp != null) {
                    try {
                        clientMgr = ClientMgr.getInstance();
                        ArrayList<WebBusinessObject> appointmentsLst = clientMgr.getappOfClientClassOfComChan(fromDate, toDate, sCallTyp, sRate, sChannel, groupID);
                        request.setAttribute("appointmentsLst", appointmentsLst);
                        if (appointmentsLst != null && !appointmentsLst.isEmpty()) {
                            String headersExc[] = {"#", "Client Name", "Mobile", "Inter. Phone", "E-mail", "Rate", "Communication Channels"};
                            String attributesExc[] = {"Number", "name", "mobile", "interPhone", "email", "rateNm", "comChannel"};
                            String dataTypesExc[] = {"", "String", "String", "String", "String", "String", "String"};
                            headerStr = new String[1];
                            headerStr[0] = "Channels Appointments";
                            workBook = Tools.createExcelReport("Channels Appointments", headerStr, null, headersExc, attributesExc, dataTypesExc, appointmentsLst);
                            c = Calendar.getInstance();
                            fileDate = c.getTime();
                            SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                            reportDate = df.format(fileDate);
                            filename = "ChannelsAppointments" + reportDate;
                            ServletOutputStream servletOutputStream = response.getOutputStream();
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
                            servletOutputStream.close();
                        }
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                break;
            case 127:
                servedPage = "/docs/projects/view_edit_history.jsp";
                ProjectPriceHistoryMgr projectPriceHistoryMgr = ProjectPriceHistoryMgr.getInstance();
                try {
                    request.setAttribute("historyList", new ArrayList<>(projectPriceHistoryMgr.getOnArbitraryKeyOracle(request.getParameter("projectID"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("historyList", new ArrayList<>());
                }
                request.setAttribute("projectName", request.getParameter("projectName"));
                this.forward(servedPage, request, response);
                break;
                
            case 128:
               servedPage = "/docs/client/appOfClientClass.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                String callStatus = request.getParameter("callStatus");
                sRate = request.getParameter("sRate");
                sChannel = request.getParameter("sChannel");
                groupID = request.getParameter("groupID");
                
                rates = new ArrayList<WebBusinessObject>();
                comChannels = new ArrayList<WebBusinessObject>();
                if(fromDate != null && toDate != null && callStatus != null){
                    clientMgr = ClientMgr.getInstance();
                    ArrayList<WebBusinessObject> appointmentsLst = new ArrayList<WebBusinessObject>();
                    appointmentsLst = clientMgr.getappOfClientClass(fromDate, toDate, callStatus, sRate, sChannel, groupID);
                    request.setAttribute("appointmentsLst", appointmentsLst);
                }
                seasonMgr = SeasonMgr.getInstance();
                {
                    try {
                        rates = projectMgr.getOnArbitraryKey2("CL-RATE", "key4");
                        comChannels = seasonMgr.getCashedTableAsArrayList();
                        request.setAttribute("rates", rates);
                        request.setAttribute("comChannels", comChannels);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                groups = userGroupConfigMgr.getAllUserGroupConfig((String) loggedUser.getAttribute("userId"));
                
                request.setAttribute("groupID", groupID);        
                request.setAttribute("groups", groups);        
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("callStatus", callStatus);
                request.setAttribute("sRate", sRate);
                request.setAttribute("sChannel", sChannel);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 129:
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                callStatus = request.getParameter("callStatus");
                sRate = request.getParameter("sRate");
                sChannel = request.getParameter("sChannel");
                groupID = request.getParameter("groupID");
                if (fromDate != null && toDate != null && callStatus != null) {
                    try {
                        clientMgr = ClientMgr.getInstance();
                        ArrayList<WebBusinessObject> appointmentsLst = clientMgr.getappOfClientClass(fromDate, toDate, callStatus, sRate, sChannel, groupID);
                        request.setAttribute("appointmentsLst", appointmentsLst);
                        if (appointmentsLst != null && !appointmentsLst.isEmpty()) {
                            String headersExc[] = {"#", "Client Name", "Mobile", "Inter. Phone", "E-mail", "Rate", "Communication Channels"};
                            String attributesExc[] = {"Number", "name", "mobile", "interPhone", "email", "rateNm", "comChannel"};
                            String dataTypesExc[] = {"", "String", "String", "String", "String", "String", "String"};
                            headerStr = new String[1];
                            headerStr[0] = "Classified Clients Appointments";
                            workBook = Tools.createExcelReport("Classified Clients Appointments", headerStr, null, headersExc, attributesExc, dataTypesExc, appointmentsLst);
                            c = Calendar.getInstance();
                            fileDate = c.getTime();
                            SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                            reportDate = df.format(fileDate);
                            filename = "ClassifiedClientsApps" + reportDate;
                            ServletOutputStream servletOutputStream = response.getOutputStream();
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
                            servletOutputStream.close();
                        }
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                break;    
            case 130:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectID = request.getParameter("projectID");
                int garageNo = Integer.parseInt(request.getParameter("garageNo"));
                int startNo = 1;
                ArrayList<WebBusinessObject> garagesList;
                try {
                    garagesList = new ArrayList<>(projectMgr.getOnArbitraryDoubleKeyOracle(projectID, "key2", "GRG-UNIT", "key4"));
                } catch (Exception ex) {
                    garagesList = new ArrayList<>();
                }
                if (garagesList.size() >= garageNo) {
                    wbo.setAttribute("status", "alreadyGenerated");
                } else {
                    try {
                        startNo = garagesList.size() + 1;
                        parentWbo = projectMgr.getOnSingleKey(projectID);
                        if (garageNo > 0) {
                            project = new WebBusinessObject();
                            project.setAttribute("location_type", "GRG-UNIT");
                            project.setAttribute(ProjectConstants.EQ_NO, "UL");
                            project.setAttribute(ProjectConstants.PROJECT_DESC, "");
                            project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "0");
                            project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "0");
                            project.setAttribute("mainProjectId", request.getParameter("projectID"));
                            project.setAttribute("futile", "0");
                            project.setAttribute("coordinate", "");
                            project.setAttribute("option_one", "");
                            project.setAttribute("option_two", "");
                            project.setAttribute("option_three", "UL");
                            for (int i = startNo; i <= garageNo; i++) {
                                project.setAttribute(ProjectConstants.PROJECT_NAME, parentWbo.getAttribute("projectName") + " - G." + i);
                                try {
                                    if (projectMgr.saveAppartment(project, session)) { // Garage
                                        wbo.setAttribute("status", "ok");
                                    } else {
                                        wbo.setAttribute("status", "no");
                                    }
                                } catch (NoUserInSessionException ex) {
                                    wbo.setAttribute("status", "no");
                                }
                            }
                        }
                    } catch (NumberFormatException ne) {
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 131:
                servedPage = "/docs/Adminstration/new_unit_project.jsp";
                if (request.getParameter(ProjectConstants.PROJECT_NAME) != null) { // save
                    project = new WebBusinessObject();
                    project.setAttribute(ProjectConstants.PROJECT_NAME, request.getParameter(ProjectConstants.PROJECT_NAME));
                    project.setAttribute(ProjectConstants.EQ_NO, request.getParameter(ProjectConstants.EQ_NO));
                    project.setAttribute("mainProjectId", request.getParameter("mainProjectId"));
                    project.setAttribute(ProjectConstants.PROJECT_DESC, request.getParameter(ProjectConstants.PROJECT_DESC));
                    project.setAttribute(ProjectConstants.LOCATION_TYPE, request.getParameter(ProjectConstants.LOCATION_TYPE));
                    project.setAttribute(ProjectConstants.FUTILE, request.getParameter(ProjectConstants.FUTILE));
                    project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "1");
                    project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "1");
                    try {
                        if (!projectMgr.getDoubleName(request.getParameter("project_name"))) {
                            if (projectMgr.saveObject(project, session)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;   
            case 132:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "fail");
                try {
                    if (projectMgr.getOnArbitraryKeyOracle(request.getParameter("projectID"), "key2").isEmpty()) {
                        project = projectMgr.getOnSingleKey(request.getParameter("projectID"));
                        project.setAttribute("projectName", request.getParameter("projectName"));
                        wbo.setAttribute("status", projectMgr.updateProject(project) ? "ok" : "fail");
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 133:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectID = request.getParameter("projectID");
                String buildingNo = request.getParameter("buildingNo");
                garageNo = Integer.parseInt(request.getParameter("garageNo"));
                try {
                    parentWbo = projectMgr.getOnSingleKey(projectID);
                    if (garageNo > 0) {
                        project = new WebBusinessObject();
                        project.setAttribute("location_type", "GRG-UNIT");
                        project.setAttribute(ProjectConstants.EQ_NO, "UL");
                        project.setAttribute(ProjectConstants.PROJECT_DESC, "");
                        project.setAttribute(ProjectConstants.IS_MNGMNT_STN, "0");
                        project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "0");
                        project.setAttribute("mainProjectId", request.getParameter("projectID"));
                        project.setAttribute("futile", "0");
                        project.setAttribute("coordinate", "");
                        project.setAttribute("option_one", "");
                        project.setAttribute("option_two", "");
                        project.setAttribute("option_three", "UL");
                        for (int i = 1; i <= garageNo; i++) {
                            project.setAttribute(ProjectConstants.PROJECT_NAME, "G " + buildingNo + (i < 10 ? "0" : "") + i);
                            try {
                                if (projectMgr.saveAppartment(project, session)) { // Garage
                                    wbo.setAttribute("status", "ok");
                                } else {
                                    wbo.setAttribute("status", "no");
                                }
                            } catch (NoUserInSessionException ex) {
                                wbo.setAttribute("status", "no");
                            }
                        }
                    }
                } catch (NumberFormatException ne) {
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 134:
                servedPage = "/docs/units/stages_list.jsp";
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("unitsList", projectMgr.getAllStages(request.getParameter("projectID")));
                userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                try {
                    request.setAttribute("projectsList", new ArrayList<>(userCompanyProjectsMgr.getOnArbitraryKey(
                            (String) persistentUser.getAttribute("userId"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("projectsList", new ArrayList<>());
                }
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 135:
                servedPage = "/docs/Adminstration/new_work_item.jsp";
                request.setAttribute("equipClass", new ArrayList<>(projectMgr.getAllEquipClass()));
                request.setAttribute("measuerUnits", expenseItemMgr.getMeasurementUnits("time"));
                this.forward(servedPage, request, response);
                break;
            case 136:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "fail");
                WebBusinessObject projectWbo = new WebBusinessObject();
                try {
                    projectWbo.setAttribute("project_name", request.getParameter("itemName"));
                    projectWbo.setAttribute("project_desc", request.getParameter("itemName"));
                    projectWbo.setAttribute("eqNO", request.getParameter("itemCode"));
                    projectWbo.setAttribute("location_type", request.getParameter("locationType"));
                    projectWbo.setAttribute("mainProjectId", request.getParameter("mainProjectID"));
                    projectWbo.setAttribute("futile", "0");
                    projectWbo.setAttribute("isMngmntStn", request.getParameter("minPrice"));
                    projectWbo.setAttribute("integratedId", request.getParameter("maxPrice"));
                    projectWbo.setAttribute("isTrnsprtStn", "0");
                    projectWbo.setAttribute("option2", request.getParameter("unitID"));
                    projectWbo.setAttribute("option3", request.getParameter("defaultValue"));
                    if (projectMgr.saveObject(projectWbo, session)) {
                        wbo.setAttribute("status", "ok");
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 137:
                servedPage = "/docs/Adminstration/new_model.jsp";
                this.forward(servedPage, request, response);
                break;
            case 138:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "fail");
                projectWbo = new WebBusinessObject();
                try {
                    projectWbo.setAttribute("project_name", request.getParameter("modelName"));
                    projectWbo.setAttribute("project_desc", request.getParameter("modelName"));
                    projectWbo.setAttribute("eqNO", request.getParameter("modelCode"));
                    projectWbo.setAttribute("location_type", request.getParameter("locationType"));
                    projectWbo.setAttribute("mainProjectId", request.getParameter("mainProjectID"));
                    projectWbo.setAttribute("futile", "0");
                    projectWbo.setAttribute("isMngmntStn", "0");
                    projectWbo.setAttribute("integratedId", "0");
                    projectWbo.setAttribute("isTrnsprtStn", "0");
                    if (projectMgr.saveObject(projectWbo, session)) {
                        wbo.setAttribute("status", "ok");
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 139:
                servedPage = "/docs/Adminstration/new_level.jsp";
                this.forward(servedPage, request, response);
                break;
            case 140:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "fail");
                projectWbo = new WebBusinessObject();
                try {
                    projectWbo.setAttribute("project_name", request.getParameter("levelName"));
                    projectWbo.setAttribute("project_desc", request.getParameter("levelName"));
                    projectWbo.setAttribute("eqNO", request.getParameter("levelCode"));
                    projectWbo.setAttribute("location_type", request.getParameter("locationType"));
                    projectWbo.setAttribute("mainProjectId", request.getParameter("mainProjectID"));
                    projectWbo.setAttribute("futile", "0");
                    projectWbo.setAttribute("isMngmntStn", "0");
                    projectWbo.setAttribute("integratedId", "0");
                    projectWbo.setAttribute("isTrnsprtStn", "0");
                    if (projectMgr.saveObject(projectWbo, session)) {
                        wbo.setAttribute("status", "ok");
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
                case 141:
                servedPage = "/docs/Search/search_for_unit.jsp";
                wbo = new WebBusinessObject();
                boolean savedRe=false;
                projectMgr = ProjectMgr.getInstance();
                productId = request.getParameter("unitId");
                clientId = request.getParameter("clientId");
                String budgetMony = request.getParameter("budget");
                String installment = request.getParameter("brokerID");
                clientProductMgr = ClientProductMgr.getInstance();
                try {
                    id = projectMgr.saveFastAvailableUnit(request, session);
                    if (id != null) {
                        WebBusinessObject resWbo = saveFastReservation(request, session);
                    if(metaDataMgr.getRealEstateWeb().toString().equals("0")){
                        WebBusinessObject clientInfo = new WebBusinessObject();
                        clientInfo = ClientMgr.getInstance().getOnSingleKey(clientId);
                        String projectDatabase = null;
                        wbo = projectMgr.getOnSingleKey(productId);
                        if (wbo != null) {
                        projectDatabase = (String) wbo.getAttribute("optionThree");
                        }
                        //WebBusinessObject dataRealEstate = new WebBusinessObject();
                        //dataRealEstate = clientProductMgr.saveInterestedProductRealEstat(clientInfo, projectDatabase);
                        ArrayList<WebBusinessObject> inforationProj = new ArrayList<WebBusinessObject>();
                        inforationProj = projectMgr.getInforationProj((String) wbo.getAttribute("projectName"),projectDatabase);
                        WebBusinessObject singleWebBusinessObject = inforationProj.get(0);
                        WebBusinessObject wboRe = new WebBusinessObject();
                        wboRe.setAttribute("clientId", request.getParameter("clientId"));
                        wboRe.setAttribute("STAGE_CODE", singleWebBusinessObject.getAttribute("STAGE_CODE"));
                        wboRe.setAttribute("SECTION_CODE", singleWebBusinessObject.getAttribute("SECTION_CODE"));
                        wboRe.setAttribute("SUBSTAGE_CODE", singleWebBusinessObject.getAttribute("SUBSTAGE_CODE"));
                        wboRe.setAttribute("SAMPLE_CODE", singleWebBusinessObject.getAttribute("SAMPLE_CODE"));
                        wboRe.setAttribute("BUILDING_CODE", singleWebBusinessObject.getAttribute("BUILDING_CODE"));
                        wboRe.setAttribute("BUILDING_TYPE", singleWebBusinessObject.getAttribute("BUILDING_TYPE"));
                        wboRe.setAttribute("UNIT_CODE", singleWebBusinessObject.getAttribute("UNIT_CODE"));
                        wboRe.setAttribute("installment", request.getParameter("brokerID"));
                        wboRe.setAttribute("budget", request.getParameter("budget"));
                        wboRe.setAttribute("unitNotes", request.getParameter("unitNotes"));
                        wboRe.setAttribute("paymentSystem", request.getParameter("paymentSystem"));
                        wboRe.setAttribute("sourceID", clientInfo.getAttribute("option3"));
                        wboRe.setAttribute("unitId", request.getParameter("unitId"));
                        wboRe.setAttribute("clientNORe", (String) clientInfo.getAttribute("clientNO"));
                        wboRe.setAttribute("mainBuilding", request.getParameter("mainBuilding"));
                        wboRe.setAttribute("projectDatabase", projectDatabase);
                        wboRe.setAttribute("UNIT_TOTAL_PRICE", singleWebBusinessObject.getAttribute("UNIT_TOTAL_PRICE"));
                        wboRe.setAttribute("UNIT_BUILDINGS_AREA", singleWebBusinessObject.getAttribute("UNIT_BUILDINGS_AREA"));
                        try {
                           savedRe=projectMgr.saveObject3(wboRe,session);
                        } catch (NoUserInSessionException ex) {
                            java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                        
                        if (resWbo != null) {
                            wbo.setAttribute("id", id);
                            wbo.setAttribute("resID", resWbo.getAttribute("reservationID"));
                            wbo.setAttribute("issueStatusID", resWbo.getAttribute("issueStatusID"));
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    
                    wbo.setAttribute("projectName", projectMgr.getOnSingleKey(request.getParameter("unitCategoryId")).getAttribute("projectName"));
                    if (request.getParameter("changeStatus") != null && request.getParameter("changeStatus").equalsIgnoreCase("true")) {
                        sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        String newStatusCode = "11";
                        wbo.setAttribute("statusCode", newStatusCode);
                        wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                        wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
                        wbo.setAttribute("statusNote", "Customer Status");
                        wbo.setAttribute("objectType", "client");
                        wbo.setAttribute("parentId", "UL");
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        clientMgr = ClientMgr.getInstance();
                        wbo.setAttribute("status", "no");
                        if (issueStatusMgr.changeStatus(wbo, persistentUser, null)
                                && clientMgr.updateClientStatus(request.getParameter("clientId"), newStatusCode, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                            wbo.setAttribute("status", "ok");
                        }
                        
                        String statusCode = "8";
                        issueId = request.getParameter("issueId");
                        String clientComplaintId = request.getParameter("clientComplaintId");
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        WebBusinessObject manager = UserMgr.getInstance().getOnSingleKey(CRMConstants.FINANCIAL_MANAGER_ID);
                        WebBusinessObject complaint = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                        if ((complaint != null) && (manager != null)) {
                            clientComplaintsMgr.tellManager(manager, issueId, statusCode, "Reservation", "Reservation", persistentUser);
                        }
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                case 142:
                servedPage ="/docs/projects/map_client_insert.jsp";
                String type=(String) request.getParameter("type");
                String clientID=(String) request.getParameter("clientID");
                coordinate = (String) request.getParameter("coordinate");
                String locName = (String) request.getParameter("locName");
                ClientLocationMgr clientLocationMgr=ClientLocationMgr.getInstance();
                Wbo=new WebBusinessObject();   
                if (type!=null && coordinate != null) {
                    if(type.equalsIgnoreCase("add") && !coordinate.isEmpty())
                        clientLocationMgr.saveObject(request);
                }
                request.setAttribute("type", type);
                request.setAttribute("coordinate", coordinate);
                request.setAttribute("clientID", clientID);
                this.forward(servedPage, request, response);
                break;
                case 143:
                out = response.getWriter();
                clientId = request.getParameter("clientId");
                String newStatusCode = request.getParameter("newStatusCode");
                String status1 = " ";
                try {
                    status1 = ClientMgr.getInstance().updateClientStatusNew( clientId, newStatusCode);
                } catch (Exception exq) {
                    status1 = "none";
                }
                
                if (status1.equals("ok")) {

                    status1 = "ok";
                } else {
                    status1 = "fail";
                }
                statusWbo = new WebBusinessObject();
                statusWbo.setAttribute("status", status1);
                out.write(Tools.getJSONObjectAsString(statusWbo));
                break;
                    
                case 144:
                    String sourceClientId = request.getParameter("sourceClientId");

                    Vector<WebBusinessObject> mainCatsTypesBuildingBroker = new Vector<>();

                    try {
                        // Assuming ProjectMgr.getInstance().getmainEoiName returns Vector<WebBusinessObject>
                        mainCatsTypesBuildingBroker = ProjectMgr.getInstance().getmainEoiName(sourceClientId);
                    } catch (Exception ex) {
                        status1 = "error"; // Handle exceptions or errors
                    }

                    // Prepare JSON response
                    JSONObject jsonResponse = new JSONObject();
                    JSONArray mainCatsTypesBuildingBrokerArray = new JSONArray();

                    for (WebBusinessObject obj : mainCatsTypesBuildingBroker) {
                        JSONObject objJson = new JSONObject();
                        objJson.put("name", obj.getAttribute("NAME_VALUE")); // Adjust this according to your WebBusinessObject structure
                        mainCatsTypesBuildingBrokerArray.add(objJson);
                    }

                    jsonResponse.put("mainCatsTypesBuildingBroker", mainCatsTypesBuildingBrokerArray);

                    // Set response type and write JSON response
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    PrintWriter out = response.getWriter();
                    out.print(jsonResponse.toString());
                    out.flush();
    
                    break;
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Project Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase(OperationConstants.GET_PROJECT_FORM)) {
            return 1;
        } else if (opName.equalsIgnoreCase(OperationConstants.CREATE)) {
            return 2;
        } else if (opName.equalsIgnoreCase("ListProjects")) {
            return 3;
        } else if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        } else if (opName.equalsIgnoreCase("ViewProject")) {
            return 5;
        } else if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        } else if (opName.equalsIgnoreCase("UpdateProject")) {
            return 7;
        } else if (opName.equalsIgnoreCase("Delete")) {
            return 8;
        } else if (opName.equalsIgnoreCase("NewLocation")) {
            return 9;
        } else if (opName.equalsIgnoreCase("SaveNewLocation")) {
            return 10;
        } else if (opName.equalsIgnoreCase("showTree")) {
            return 11;
        } else if (opName.equalsIgnoreCase("showProjectsTree")) {
            return 12;
        } else if (opName.equalsIgnoreCase("addProject")) {
            return 13;
        } else if (opName.equals("viewProjectMap")) {
            return 14;
        } else if (opName.equals("insertProjectMap")) {
            return 15;
        } else if (opName.equals("newLocationType")) {
            return 16;
        } else if (opName.equals("saveLocationType")) {
            return 17;
        } else if (opName.equals("listLocationType")) {
            return 18;
        } else if (opName.equals("viewLocationType")) {
            return 19;
        } else if (opName.equals("getUpdateLocationType")) {
            return 20;
        } else if (opName.equals("updateLocationType")) {
            return 21;
        } else if (opName.equals("confirmDeleteLocationType")) {
            return 22;
        } else if (opName.equals("deleteLocationType")) {
            return 23;
        } else if (opName.equals("getSiteTreeInPopup")) {
            return 24;
        } else if (opName.equals("GetAttachedImage")) {
            return 25;
        } else if (opName.equals("newHousingUnit")) {
            return 26;
        } else if (opName.equals("saveHousingUnit")) {
            return 27;
        } else if (opName.equals("ajaxGetCode")) {
            return 28;
        } else if (opName.equals("getProduct")) {
            return 29;
        } else if (opName.equals("saveClientProduct")) {
            return 30;
        } else if (opName.equals("newModel")) {
            return 31;
        } else if (opName.equals("saveModel")) {
            return 32;
        } else if (opName.equals("viewModel")) {
            return 33;
        } else if (opName.equals("viewUnit")) {
            return 34;
        } else if (opName.equals("getSubProject")) {
            return 35;
        } else if (opName.equals("ListProducts")) {
            return 36;
        } else if (opName.equals("ProductItemsTree")) {
            return 37;
        } else if (opName.equals("getModels")) {
            return 38;
        } else if (opName.equals("saveAvailableUnits")) {
            return 39;
        } else if (opName.equals("showImage")) {
            return 40;
        } else if (opName.equals("saveInterestedProduct")) {
            return 41;
        } else if (opName.equals("removeInterestedProduct")) {
            return 42;
        } else if (opName.equals("updateDepartmentManager")) {
            return 43;
        } else if (opName.equals("updateParentOfProject")) {
            return 44;
        } else if (opName.equals("getAllProject")) {
            return 45;
        } else if (opName.equals("UpdateParenetProject")) {
            return 46;
        } else if (opName.equals("DepartmentDocuments")) {
            return 47;
        } else if (opName.equals("SaveDocTypeDeps")) {
            return 48;
        } else if (opName.equals("saveUserAreaByAjax")) {
            return 49;
        } else if (opName.equals("getUserAreaByAjax")) {
            return 50;
        } else if (opName.equals("newBuilding")) {
            return 51;
        } else if (opName.equals("saveBuildingByFlats")) {
            return 52;
        } else if (opName.equals("generateFlats")) {
            return 53;
        } else if (opName.equals("showUnitSideMenu")) {
            return 54;
        } else if (opName.equals("getViewUnits")) {
            return 55;
        } else if (opName.equals("listBuildings")) {
            return 56;
        } else if (opName.equals("ConfirmDeleteBuilding")) {
            return 57;
        } else if (opName.equals("DeleteBuilding")) {
            return 58;
        } else if (opName.equals("showUnits")) {
            return 59;
        } else if (opName.equals("getUnitsModelsForm")) {
            return 60;
        } else if (opName.equals("saveUnitsModels")) {
            return 61;
        } else if (opName.equals("deleteUnitByAjax")) {
            return 62;
        } else if (opName.equals("getAllAvailableUnits")) {
            return 63;
        } else if (opName.equals("saveSellUnits")) {
            return 64;
        } else if (opName.equals("saveProductsToSession")) {
            return 65;
        } else if (opName.equals("editProjectByAjax")) {
            return 66;
        } else if (opName.equals("addClientComplaintIntoProject")) {
            return 67;
        } else if (opName.equals("DepartmentTasks")) {
            return 68;
        } else if (opName.equals("saveDepartmentTasks")) {
            return 69;
        } else if (opName.equals("listMyFolders")) {
            return 70;
        } else if (opName.equals("mFolderList")) {
            return 71;
        } else if (opName.equals("saveModelUnderBuilding")) {
            return 72;
        } else if (opName.equals("saveOnholdUnits")) {
            return 73;
        } else if (opName.equals("getAllAvailableOnholdUnits")) {
            return 74;
        } else if (opName.equals("getProjectList")) {
            return 75;
        } else if (opName.equals("manageProjectEngineers")) {
            return 76;
        } else if (opName.equals("removeEngineerFromProjectByAjax")) {
            return 77;
        } else if (opName.equals("listAllWorkerInArea")) {
            return 78;
        } else if (opName.equals("saveLinkUnitWithModelByAjax")) {
            return 79;
        } else if (opName.equals("getUnitPrice")) {
            return 80;
        } else if (opName.equals("GetWorkItemsList")) {
            return 81;
        } else if (opName.equals("updateWorkItems")) {
            return 82;
        } else if (opName.equals("deleteRequestDoc")) {
            return 83;
        } else if (opName.equals("deleteSellUnits")) {
            return 84;
        } else if (opName.equals("getProcPDF")) {
            return 85;
        } else if (opName.equalsIgnoreCase("getNewAccountForm")) {
            return 86;
        } else if (opName.equalsIgnoreCase("saveNewAccount")) {
            return 87;
        } else if (opName.equals("saveRentUnits")) {
            return 88;
        } else if (opName.equals("getNewCostCenterForm")) {
            return 89;
        } else if (opName.equals("saveNewCostCenter")) {
            return 90;
        } else if (opName.equals("getClientsRatesPDF")) {
            return 91;
        } else 
        //Kareem
        if (opName.equals("listSalesTragets")) {
            return 92;
        }//Kareem End
         else if (opName.equals("editeProjectAccount")) {
            return 93;
        } else if (opName.equals("updateProjectAccPopup")) {
            return 94;
        } else if (opName.equals("editSalesTargetByAjax")) { //Kareem
            return 95;
        } else if (opName.equals("attatchProjects")) { //Kareem
            return 96;
        } else if (opName.equalsIgnoreCase("addProjectNBPaySys")) {
            return 97;
        } else if (opName.equalsIgnoreCase("changeProjectStatusByAjax")) {
            return 98;
        }

        // MOVED To UnitServlet
//        if (opName.equals("newResidentialModel")) {
//            return 64;
//        }
//        if(opName.equals("saveResidentialModel")){
//            return 65 ;
//        }
         else if (opName.equalsIgnoreCase("updateProjectEntity")) {
            return 99;
        } else if (opName.equalsIgnoreCase("viewProjectDetailes")) {
            return 100;
        } else if (opName.equalsIgnoreCase("addProjectZone")) {
            return 101;
        } else if (opName.equalsIgnoreCase("getClientOwnedProject")) {
            return 102;
        } else if (opName.equalsIgnoreCase("apartmentProjectTree")) {
            return 103;
        } else if (opName.equalsIgnoreCase("GetMaintenanceItemsList")) { //Kareem
            return 104;
        } else if (opName.equalsIgnoreCase("getSparePartsList")) {
            return 105;
        } else if (opName.equalsIgnoreCase("editProjectDescByAjax")) {
            return 106;
        } else if (opName.equalsIgnoreCase("getProjectAccountingByID")) {
            return 107;
        } else if (opName.equalsIgnoreCase("getUnitTypeForm")) {
            return 108;
        } else if (opName.equalsIgnoreCase("listUnitTypes")) {
            return 109;
        } else if (opName.equalsIgnoreCase("viewUnitType")) {
            return 110;
        } else if (opName.equalsIgnoreCase("getUpdateUnitType")) {
            return 111;
        } else if (opName.equalsIgnoreCase("confirmDeleteUnitType")) {
            return 112;
        } else if (opName.equalsIgnoreCase("getParentIDAjax")) {
            return 113;
        } else if (opName.equalsIgnoreCase("linkUserAndroidDevice")) {
            return 114;
        } else if (opName.equalsIgnoreCase("getMSUWrkrLocation")) {
            return 115;
        } else if (opName.equalsIgnoreCase("exportProjectsToExcel")) {
            return 116;
        } else if (opName.equalsIgnoreCase("checkUnitsAvailability")) {
            return 117;
        } else if (opName.equalsIgnoreCase("deleteProject")) {
            return 118;
        } else if (opName.equalsIgnoreCase("getClientUnits")) {
            return 119;
        } else if (opName.equalsIgnoreCase("getAllUnitsData")) {
            return 120;
        } else if (opName.equalsIgnoreCase("getProjectMeterPriceAjax")) {
            return 121;
        } else if (opName.equalsIgnoreCase("getAllClients")) {
            return 122;
        } else if (opName.equalsIgnoreCase("getClientClassOfComChan")) {
            return 123;
        } else if (opName.equalsIgnoreCase("appOfClientClassOfComChan")) {
            return 124;
        } else if (opName.equalsIgnoreCase("getClientClassOfComChanExcel")) {
            return 125;
        } else if (opName.equalsIgnoreCase("appOfClientClassOfComChanExcel")) {
            return 126;
        } else if (opName.equalsIgnoreCase("getPriceEditHistory")) {
            return 127;
        } else if (opName.equalsIgnoreCase("appOfClientClass")) {
            return 128;
        } else if (opName.equalsIgnoreCase("appOfClientClassExcel")) {
            return 129;
        } else if (opName.equalsIgnoreCase("generateGaragesAjax")) {
            return 130;
        } else if (opName.equalsIgnoreCase("newUnitProject")) {
            return 131;
        } else if (opName.equalsIgnoreCase("editProjectNameByAjax")) {
            return 132;
        } else if (opName.equalsIgnoreCase("generateBuildingGaragesAjax")) {
            return 133;
        } else if (opName.equalsIgnoreCase("getProjectsStages")) {
            return 134;
        } else if (opName.equalsIgnoreCase("getWorkItemForm")) {
            return 135;
        } else if (opName.equalsIgnoreCase("saveWorkItemAjax")) {
            return 136;
        } else if (opName.equalsIgnoreCase("getModelForm")) {
            return 137;
        } else if (opName.equalsIgnoreCase("saveModelAjax")) {
            return 138;
        } else if (opName.equalsIgnoreCase("getLevelForm")) {
            return 139;
        } else if (opName.equalsIgnoreCase("saveLevelAjax")) {
            return 140;
        } else if (opName.equals("saveFastAvailableUnits")) {
            return 141;
        } else if (opName.equalsIgnoreCase("insertClientLocation")) {
            return 142;
        } else if (opName.equalsIgnoreCase("clientStatusNew")) {
            return 143;
        } else if (opName.equalsIgnoreCase("getEoiName")) {
            return 144;
        }
        
        return 0;
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {
        String projectID = request.getParameter("projectID");
        String eqNO = request.getParameter("eqNO");
        String projectDesc = request.getParameter("projectDesc");
        if (projectID == null || projectDesc.equals("") || eqNO.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (projectID.equals("") || projectDesc.equals("") || eqNO.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingProject = projectMgr.getOnSingleKey(projectID);
            if (existingProject != null) {
                throw new EntryExistsException();
            }
        }
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        project = projectMgr.getOnSingleKey(request.getParameter("projectID"));
        request.setAttribute("project", project);
        request.setAttribute("status", message);
        try {
            if (request.getParameter("type").equals("tree")) {
                //servedPage = "/docs/projects/confirm_delproject_result.jsp";
                request.setAttribute("type", "tree");
                this.forward(servedPage, request, response);
            }
        } catch (Exception ex) {
            request.setAttribute("page", servedPage);
            request.setAttribute("type", "");
            this.forwardToServedPage(request, response);
        }
    }

    public void getTree(String id, List<WebBusinessObject> list, int parent) {
        Vector childNode = new Vector();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject childWbo = new WebBusinessObject();
        Vector childIdAndParent = new Vector();
        try {
            childNode = projectMgr.getAllProjects(id);
            if (childNode.size() > 0) {
                System.out.println("have child Sites");
                for (int j = 0; j < childNode.size(); j++) {
                    size++;
                    childWbo = (WebBusinessObject) childNode.get(j);
                    childWbo.setAttribute("size", size);
                    childWbo.setAttribute("parent", parent);
                    list.add(childWbo);
                    childIdAndParent.add(j, childWbo);
                }
                
                for (int j = 0; j < childIdAndParent.size(); j++) {
                    getTree(((WebBusinessObject) childIdAndParent.get(j)).getAttribute("projectID").toString(), list, Integer.parseInt(((WebBusinessObject) childIdAndParent.get(j)).getAttribute("size").toString()));
                }
            } else {
                System.out.println("Not Have Sites");
            }
        } catch (Exception exc) {
            System.out.println(exc.getMessage());
        }
    }

    private WebBusinessObject saveReservation(HttpServletRequest request, HttpSession s) {
        try {
            WebBusinessObject reservationWbo = new WebBusinessObject();
            WebBusinessObject userWbo = (WebBusinessObject) s.getAttribute("loggedUser");
            reservationWbo.setAttribute("clientID", request.getParameter("clientId"));
            reservationWbo.setAttribute("projectID", request.getParameter("unitId"));
            reservationWbo.setAttribute("userId", userWbo.getAttribute("userId"));
            reservationWbo.setAttribute("projectCategoryId", request.getParameter("unitCategoryId"));
            //reservationWbo.setAttribute("budget", request.getParameter("budget"));
            reservationWbo.setAttribute("budget", "000");
            reservationWbo.setAttribute("period", request.getParameter("period"));
            reservationWbo.setAttribute("paymentType", request.getParameter("paymentSystem"));
            reservationWbo.setAttribute("comments", request.getParameter("comments") != null ? request.getParameter("comments") : "UL");

            //reservationWbo.setAttribute("floorNumber", request.getParameter("floorNumber")!= null ? request.getParameter("floorNumber") : "UL");
            reservationWbo.setAttribute("modelNo", request.getParameter("modelNo") != null ? request.getParameter("modelNo") : "UL");
            reservationWbo.setAttribute("receiptNo", request.getParameter("receiptNo") != null ? request.getParameter("receiptNo") : "UL");

            reservationWbo.setAttribute("reservationDate", request.getParameter("reservationDate") != null ? request.getParameter("reservationDate") : "UL");
            if (request.getParameter("floorNumber") == null) {
                if ( request.getParameter("brokerID") != null) {
                    reservationWbo.setAttribute("floorNumber", request.getParameter("brokerID"));
                } else {
                    reservationWbo.setAttribute("floorNumber", "UL");
                }
            } else {
                reservationWbo.setAttribute("floorNumber", request.getParameter("floorNumber"));
            }

            reservationWbo.setAttribute("unitValueText", request.getParameter("unitValueText") != null ? request.getParameter("unitValueText") : "UL");
            reservationWbo.setAttribute("beforeDiscountText", request.getParameter("beforeDiscountText") != null ? request.getParameter("beforeDiscountText") : "UL");
            reservationWbo.setAttribute("reservationValueText", request.getParameter("reservationValueText") != null ? request.getParameter("reservationValueText") : "UL");
            reservationWbo.setAttribute("contractValueText", request.getParameter("contractValueText") != null ? request.getParameter("contractValueText") : "UL");

            ReservationMgr reservationMgr = ReservationMgr.getInstance();
            return reservationMgr.saveObjectRes(reservationWbo);
        } catch (SQLException ex) {
            return null;
        }
    }
    
    private WebBusinessObject saveFastReservation(HttpServletRequest request, HttpSession s) {
        try {
            WebBusinessObject reservationWbo = new WebBusinessObject();
            WebBusinessObject userWbo = (WebBusinessObject) s.getAttribute("loggedUser");
            reservationWbo.setAttribute("clientID", request.getParameter("clientId"));
            reservationWbo.setAttribute("projectID", request.getParameter("unitId"));
            reservationWbo.setAttribute("userId", userWbo.getAttribute("userId"));
            reservationWbo.setAttribute("projectCategoryId", request.getParameter("unitCategoryId"));
            reservationWbo.setAttribute("budget", request.getParameter("budget"));
            reservationWbo.setAttribute("period", request.getParameter("period"));
            reservationWbo.setAttribute("paymentType", request.getParameter("paymentSystem"));
            reservationWbo.setAttribute("comments", "Fast");

            //reservationWbo.setAttribute("floorNumber", request.getParameter("floorNumber")!= null ? request.getParameter("floorNumber") : "UL");
            reservationWbo.setAttribute("modelNo", request.getParameter("modelNo") != null ? request.getParameter("modelNo") : "UL");
            reservationWbo.setAttribute("receiptNo", request.getParameter("receiptNo") != null ? request.getParameter("receiptNo") : "UL");

            reservationWbo.setAttribute("reservationDate", request.getParameter("reservationDate") != null ? request.getParameter("reservationDate") : "UL");
            if (request.getParameter("floorNumber") == null) {
                if ( request.getParameter("brokerID") != null) {
                    reservationWbo.setAttribute("floorNumber", request.getParameter("brokerID"));
                } else {
                    reservationWbo.setAttribute("floorNumber", "UL");
                }
            } else {
                reservationWbo.setAttribute("floorNumber", request.getParameter("floorNumber"));
            }

            reservationWbo.setAttribute("unitValueText", request.getParameter("unitValueText") != null ? request.getParameter("unitValueText") : "UL");
            reservationWbo.setAttribute("beforeDiscountText", request.getParameter("beforeDiscountText") != null ? request.getParameter("beforeDiscountText") : "UL");
            reservationWbo.setAttribute("reservationValueText", request.getParameter("reservationValueText") != null ? request.getParameter("reservationValueText") : "UL");
            reservationWbo.setAttribute("contractValueText", request.getParameter("contractValueText") != null ? request.getParameter("contractValueText") : "UL");

            ReservationMgr reservationMgr = ReservationMgr.getInstance();
            return reservationMgr.saveObjectRes(reservationWbo);
        } catch (SQLException ex) {
            return null;
        }
    }

    private void getChilds(String projectParentID, int parentID) {
        String icon = "";
        Vector childVec = new Vector();
        WebBusinessObject treeNodeWBO = new WebBusinessObject();

        JSONObject contextMenu = new JSONObject();
        JSONArray menuElements = new JSONArray();

        childVec = projectMgr.getAllProjects(projectParentID);
        if (childVec.size() > 0) {
            for (int i = 0; i < childVec.size(); i++) {
                int currentID = this.JsonList.size();
                JSONObject josnObj = new JSONObject();
                treeNodeWBO = (WebBusinessObject) childVec.get(i);
                //get icon and Context Menu
                if (treeNodeWBO.getAttribute("futile") != null && treeNodeWBO.getAttribute("futile").equals("1") && treeNodeWBO.getAttribute("eqNO").toString().equals("ACCNTS") && treeNodeWBO.getAttribute("location_type").toString().equals("VG")) {
                    contextMenu = (JSONObject) this.jsonMenu.get("ACCNTS");
                } else if (treeNodeWBO.getAttribute("futile") != null && treeNodeWBO.getAttribute("futile").equals("1") && treeNodeWBO.getAttribute("eqNO").toString().equals("ACCNTS") && treeNodeWBO.getAttribute("location_type").toString().equals("ACCTM")) {
                    contextMenu = (JSONObject) this.jsonMenu.get("ACCTM");
                } else if (treeNodeWBO.getAttribute("futile") != null && treeNodeWBO.getAttribute("futile").equals("0") && treeNodeWBO.getAttribute("eqNO").toString().equals("ACCNTS") && treeNodeWBO.getAttribute("location_type").toString().equals("ACCTB")) {
                    contextMenu = (JSONObject) this.jsonMenu.get("ACCTB");
                } else if ("44".equals(treeNodeWBO.getAttribute("location_type"))) {
                    contextMenu = (JSONObject) this.jsonMenu.get("project-node");
                } else if (treeNodeWBO.getAttribute("futile") != null && treeNodeWBO.getAttribute("futile").equals("1")) {
                    contextMenu = (JSONObject) this.jsonMenu.get("site");
                } else {
                    contextMenu = (JSONObject) this.jsonMenu.get("subsite");
                }
                
                icon = (String) contextMenu.get("icon");
                menuElements = (JSONArray) contextMenu.get("menuItem");

                josnObj.put("id", new Integer(currentID).toString());
                josnObj.put("projectID", (String) treeNodeWBO.getAttribute("projectID"));
                josnObj.put("parentid", parentID);
                josnObj.put("text", (String) treeNodeWBO.getAttribute("projectName"));
                josnObj.put("icon", icon);
                josnObj.put("type", (String) treeNodeWBO.getAttribute("location_type"));
                josnObj.put("contextMenu", menuElements);
                this.JsonList.add(josnObj);

                getChilds((String) treeNodeWBO.getAttribute("projectID"), currentID);
            }
        }
    }

    private void getZonePrj(String projectParentID, int parentID) {
        String icon = "";
        ArrayList<WebBusinessObject> zonePrj = new ArrayList<WebBusinessObject>();
        WebBusinessObject treeNodeWBO = new WebBusinessObject();

        JSONObject contextMenu = new JSONObject();
        JSONArray menuElements = new JSONArray();

        zonePrj = projectMgr.getZonePrj(projectParentID);
        if (zonePrj.size() > 0) {
            for (int i = 0; i < zonePrj.size(); i++) {
                int currentID = this.JsonList.size();
                JSONObject josnObj = new JSONObject();
                treeNodeWBO = (WebBusinessObject) zonePrj.get(i);
                //get icon and Context Menu
                if (treeNodeWBO.getAttribute("location_type") != null && treeNodeWBO.getAttribute("location_type").equals("44")) {
                    contextMenu = (JSONObject) this.jsonMenu.get("44");
                }

                icon = (String) contextMenu.get("icon");
                menuElements = (JSONArray) contextMenu.get("menuItem");

                josnObj.put("id", new Integer(currentID).toString());
                josnObj.put("projectID", (String) treeNodeWBO.getAttribute("prjID"));
                josnObj.put("parentid", parentID);
                josnObj.put("text", (String) treeNodeWBO.getAttribute("prjName"));
                josnObj.put("icon", icon);
                josnObj.put("type", (String) treeNodeWBO.getAttribute("location_type"));
                josnObj.put("contextMenu", menuElements);
                this.JsonList.add(josnObj);

                getZonePrj((String) treeNodeWBO.getAttribute("prjID"), currentID);
            }
        }
    }
}