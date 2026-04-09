package com.tracker.servlets;

import com.businessfw.hrs.db_access.EmployeeMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.clients.db_access.ClientCommunicationMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientComplaintsSLAMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.QualityPlanMgr;
import com.clients.db_access.ServiceManAreaMgr;
import com.clients.servlets.ClientServlet;
import java.io.*;
import java.util.*;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.maintenance.common.ParseSideMenu;
import com.contractor.db_access.MaintainableMgr;
import com.crm.common.ActionEvent;
import com.crm.common.CRMConstants;
import com.crm.common.ClientComplaintsActionEvent;
import com.crm.db_access.AlertMgr;
import com.crm.db_access.CommentsMgr;
import com.crm.db_access.IssueDependenceMgr;
import com.docviewer.db_access.ImageMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.db_access.*;
import com.maintenance.db_access.ItemCatsMgr;
import com.routing.servlets.ComplaintEmployeeServlet;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.*;
import com.silkworm.util.*;
import com.silkworm.common.*;
import com.silkworm.db_access.FileMgr;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.uploader.FileMeta;
import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.tracker.common.*;
import com.tracker.engine.IssueStatusFactory;
import com.tracker.engine.AssignedIssueState;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import com.maintenance.common.ClosureConfigMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import static com.silkworm.servlets.swBaseServlet.getClientIpAddr;
import java.text.ParseException;

@WebServlet("/uploadFiles")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15, // 15 MB)
        location = "/tmp")

public class IssueServlet extends TrackerBaseServlet {
    //Initialize Managers

    public enum IssueTitle {

        Emergency, NotEmergency, Both
    };
    // <editor-fold defaultstate="collapsed" desc="Your Fold Comment">
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    ConfigureMainTypeMgr configureTypeMgr = ConfigureMainTypeMgr.getInstance();
    QuantifiedMntenceMgr quantifiedMgr = QuantifiedMntenceMgr.getInstance();
    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
    TaskMgr taskMgr = TaskMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    SequenceMgr sequenceMgr = SequenceMgr.getInstance();
    DriversHistoryMgr driversMgr = DriversHistoryMgr.getInstance();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    IssueTasksComplaintMgr issueTasksComplaintMgr = IssueTasksComplaintMgr.getInstance();
    TaskExecutionMgr taskExecutionMgr = TaskExecutionMgr.getInstance();
    LaborComplaintsMgr lbMgr = LaborComplaintsMgr.getInstance();
    ComplaintTasksMgr compTasksMgr = ComplaintTasksMgr.getInstance();
    ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
    IssueMetaDataMgr issueMetaDataMgr = IssueMetaDataMgr.getInstance();
    ReconfigTaskMgr reconfigTaskMgr = ReconfigTaskMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    // </editor-fold>
    //Initialize System Valiables
    private AlertMgr alertMgr;
    AssignedIssueState ais = null;
    String issueState = null;
    String viewOrigin = null;
    String page = null;
    String issueId = null;
    String jobZise = null;
    String urgencyId = null;
    String UnitName = null;
    String ScheduleTitle = null;
    String UnitId = null;
    WebBusinessObject eqpWbo = null;
    WebBusinessObject driverWbo = null;
    WebIssue wIssue = new WebIssue();
    WebBusinessObject wboTemp = new WebBusinessObject();
    Vector eqpsVec = new Vector();
    Vector compTasksVec = null;
    ArrayList userClosureList = null;
    Hashtable tasksHT = new Hashtable();
    String userId;
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ClosureConfigMgr userClosureConfigMgr = ClosureConfigMgr.getInstance();
    private LoggerMgr loggerMgr = LoggerMgr.getInstance();
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/issue/new_Issue.jsp";
        alertMgr = AlertMgr.getInstance();
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String clientType = "";
        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();

        String clientId = "";
        ClientMgr clientMgr = ClientMgr.getInstance();
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        UserClientsMgr userClientsMgr = UserClientsMgr.getInstance();
        Vector DepComp = new Vector();

        WebBusinessObject wbo4 = new WebBusinessObject();

        Vector clientProduct = new Vector();
        Vector CompetentEmp = new Vector();
        WebIssue wIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);

        //Define page UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        //Get Session
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        ParseSideMenu parseSideMenu = new ParseSideMenu();

        try {
            if (request.getParameter("op") == null || request.getParameter("op").equalsIgnoreCase("no")) {
//                if(request.getParameter("source") == null){
//                    sequenceMgr.updateSequence();
//
//                    //get equipments
//
//                    //   eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
//                    String []params={"1","0",userObj.getAttribute("projectID").toString()};
//                    String []keys={"key3","key5","key11"};
//                    eqpsVec=maintainableMgr.getOnArbitraryNumberKey(3,params,keys);
//
//                    if(eqpsVec.size()> 0 && eqpsVec != null){
//                        eqpWbo = (WebBusinessObject) eqpsVec.elementAt(0);
//                    }
//                    request.setAttribute("source","newIssue");
//                } else {
//                    //get selected equipment
//                    eqpWbo = maintainableMgr.getOnSingleKey(request.getParameter("unitName"));
//                    String page=(String)request.getParameter("source");
//                    if(page.equalsIgnoreCase("viewImages")){
//                        sequenceMgr.updateSequence();
//                        request.setAttribute("source","viewImages");
//                    } else
//                        request.setAttribute("source","newIssue");
//                }
//
//                //Get Sequence before JO insertion
//                String JOSequenceStr = sequenceMgr.getSequence();
//
//                //get current equipment employee
//                if(eqpWbo != null){
//                    Vector driverVec = driversMgr.getOnArbitraryDoubleKeyOracle(eqpWbo.getAttribute("id").toString(),"key1",null,"key3");
//                    if(driverVec.size()> 0 && driverVec != null){
//                        driverWbo = (WebBusinessObject) driverVec.elementAt(0);
//                    }
//                }
//                servedPage = "/docs/issue/new_Issue.jsp";
//
//                request.setAttribute("JONo",JOSequenceStr);
//                request.setAttribute("equipments", eqpsVec);
//                request.setAttribute("currentEqp", eqpWbo);
//                request.setAttribute("currentEmp", driverWbo);
//
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
            } else {
                operation = getOpCode((String) request.getParameter("op"));
                ArrayList requestAsArray = ServletUtils.getRequestParams(request);
                ServletUtils.printRequest(requestAsArray);

                switch (operation) {
                    case 1:

                        String orderID = request.getParameter("orderID");
                        Vector issueFound = issueMgr.getOnArbitraryKey(orderID, "key4");
                        if (!issueFound.isEmpty()) {
                            servedPage = "ScheduleServlet?op=" + "no";
                            request.setAttribute("status", "duplicateOrderNumber");
                            this.forward(servedPage, request, response);
                        } else {
                            refineEmeregencyForm(request);

                            //get request data
                            UnitId = request.getParameter("unitId");

                            //get equipment site
                            WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(UnitId);
                            wIssue.setAttribute("project_name", wboTemp.getAttribute("site").toString());

                            //Save emergency Job order
                            if (issueMgr.saveEmgObject(request, wIssue, session)) {
                                WebBusinessObject webIssue = issueMgr.getOnSingleKey(issueMgr.getIssueID());

                                request.setAttribute("issueID", issueMgr.getIssueID());
                                request.setAttribute("businessID", webIssue.getAttribute("businessID").toString());
                                request.setAttribute("sID", issueMgr.getSID());
                                request.setAttribute("Status", "OK");

                                request.getSession().setAttribute("IssueWbo", webIssue);
                                request.getSession().setAttribute("equipmentWbo", wboTemp);
                                request.getSession().setAttribute("joType", "emg");
                                /**
                                 * *************************************************
                                 */
                                String scheduleUnitID = (String) webIssue.getAttribute("unitScheduleID");
                                /* Get Eq_ID from Unit Schedule to check if this Eq is attached or not
                                 check if the equipment id has record(s) in attach_eqps table and
                                 the separation_date equl null. this mean this eq is attached.*/
                                Vector attachedEqps = new Vector();
                                Vector minorAttachedEqps = new Vector();
                                SupplementMgr supplementMgr = SupplementMgr.getInstance();
                                WebBusinessObject unit_sch_wbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                                String Eq_ID = (String) unit_sch_wbo.getAttribute("unitId");
                                attachedEqps = supplementMgr.search(Eq_ID);
                                minorAttachedEqps = supplementMgr.searchAllowedEqps(Eq_ID);
                                String attachedEqFlag = "";
                                if (attachedEqps.size() > 0) {
                                    attachedEqFlag = "attached";
                                } else {
                                    if (minorAttachedEqps.size() > 0) {
                                        attachedEqFlag = "attached";
                                    } else {
                                        attachedEqFlag = "notatt";
                                    }

                                }
                                request.getSession().setAttribute("attFlag", attachedEqFlag);

                                /**
                                 * ****Create Dynamic content of Issue menu
                                 * ******
                                 */
                                Tools.createIssueSideMenu(attachedEqFlag, webIssue, request);
                            } else {
                                request.setAttribute("Status", "Failed");
                            }

                            servedPage = "/docs/issue/issue_emg_saving.jsp";
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                        }
                        break;

                    case 2:

                        Vector issuesList = null;

                        issuesList = issueMgr.getSearchOnStatus("Schedule");

                        servedPage = "/docs/issue/issue_listing.jsp";
                        request.setAttribute("data", issuesList);
                        request.setAttribute("status", "Schedule");
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 3:

                        // SQLTimeInterval sqlTimeInterval = new SQLTimeInterval(request,"FROM_ONLY");
                        // java.sql.Timestamp d = sqlTimeInterval.getFromDate();
                        break;

                    case 4:
                        String projectname = request.getParameter("projectName");
                        String issueTitle = request.getParameter("issueTitle");
                        String issueId = request.getParameter("issueId");

                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        if (request.getParameter("case") != null) {
                            request.setAttribute("case", request.getParameter("case"));
                            request.setAttribute("title", request.getParameter("title"));
                            request.setAttribute("unitName", request.getParameter("unitName"));

                        }
                        //    AssignedIssueState ais = IssueStatusFactory.getStateClass(IssueStatusFactory.UNASSIGNED);

                        servedPage = "/docs/issue/make_sure.jsp";
                        request.setAttribute("issueTitle", issueTitle);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("state", ais);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("projectName", projectname);
                        request.setAttribute("filterValue", filterValue);

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                        break;

                    case 5:

                        projectname = request.getParameter("projectName");
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        String destination = AppConstants.getFullLink(filterName, filterValue);
                        if (request.getParameter("case") != null) {
                            if (destination != null) {
                                destination = destination.replaceFirst("StatusProjectListAll", "StatusProjctListTitle");
                            } else {
                                destination = "/SearchServlet?op=StatusProjctListTitle&filterValue=" + filterValue;
                            }

                            String addToURL = "&title=" + request.getParameter("title") + "&unitName=" + (String) request.getParameter("unitName");
                            destination += addToURL;
                            destination = destination.replace(' ', '+');
                        }
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        try {

                            String delIssueId = request.getParameter("issueId");

                            //if(bookmarkMgr.deleteRefIntegKey(delIssueId)) {
//                            if(issueMgr.deleteOnSingleKey(delIssueId) && issueStatusMgr.deleteOnArbitraryKey(delIssueId, "key2")) {
                            issueStatusMgr.deleteOnArbitraryKey(delIssueId, "key2");
                            imageMgr.deleteOnArbitraryKey(delIssueId, "key3");
                            issueMgr.deleteOnSingleKey(delIssueId);

                            request.setAttribute("projectName", projectname);
                            this.forward(destination, request, response);

                        } catch (Exception ex) {

                            logger.error("Some Exception took place " + ex.getMessage());
                        }
                        break;

                    case 6:

                        issueState = request.getParameter("issueState");
                        issueId = request.getParameter("issueId");

                        ais = IssueStatusFactory.getStateClass(issueState);

                        viewOrigin = request.getParameter("viewOrigin");
                        ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
                        ais.setViewOrigin(viewOrigin);

                        request.setAttribute("state", ais);

                        wIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);

                        request.setAttribute("webIssue", wIssue);

                        servedPage = "/docs/issue/issue_detail.jsp";

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 7:
                        String issueID = request.getParameter("issueID");
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        wIssue = (WebIssue) issueMgr.getOnSingleKey(issueID);
                        request.setAttribute("webIssue", wIssue);
                        servedPage = "/docs/issue/update_Issue.jsp";
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 8:
                        if (issueMgr.updateObject(request, session)) {
                            request.setAttribute("Status", "OK");
                        } else {
                            request.setAttribute("Status", "Failed");
                        }

                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        servedPage = "/docs/issue/update_Issue.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 9:
                        Vector itemList = new Vector();

                        issueId = request.getParameter(IssueConstants.ISSUEID);
                        issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                        issueState = request.getParameter("issueStatus");

                        if (issueTitle.equalsIgnoreCase("External") || issueTitle.equalsIgnoreCase("Emergency") || ((!issueTitle.equalsIgnoreCase("Emergency") || !issueTitle.equalsIgnoreCase("External")) && (!issueState.equalsIgnoreCase("Schedule")))) {
                            itemList = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                        } else {
                            WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                            WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                            itemList = configureTypeMgr.getConfigItemBySchedule(scheduleWbo.getAttribute("periodicID").toString());
                        }

                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);

                        servedPage = "/docs/issue/printWindow.jsp";
                        request.setAttribute("data", itemList);
                        request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                        break;

                    case 10:

                        Vector itemsCats = new Vector();
                        Vector items = new Vector();
                        Vector machineItems = new Vector();
                        String machineId = request.getParameter("unitId");
                        String periodicScheduleId = request.getParameter("scheduleId");

                        itemsCats = itemCatsMgr.getItemsCategory();
                        machineItems = itemCatsMgr.getOnArbitraryKey(machineId, "key1");
                        issueId = request.getParameter("issueId");
                        issueTitle = request.getParameter("issueTitle");

                        UnitId = request.getParameter("unitId");
                        String ScheduleId = request.getParameter("scheduleId");
                        items = itemCatsMgr.getAllItems();
                        servedPage = "/docs/issue/QA_verify_All_Item.jsp";

                        request.setAttribute("issueId", issueId);
                        request.setAttribute("scheduleID", periodicScheduleId);
                        request.setAttribute("machineItems", machineItems);
                        request.setAttribute("data", items);
                        request.setAttribute("categories", itemsCats);
                        request.setAttribute("issueTitle", issueTitle);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 11:
                        String key = request.getParameter("key");
                        String returnXML = new String("");
                        if (key != null) {
                            Vector vecIssues = issueMgr.getOnArbitraryKey(key, "key4");

                            if (vecIssues.size() > 0) {
                                WebBusinessObject wbo = (WebBusinessObject) vecIssues.get(0);
                                String FinishTime = (String) wbo.getAttribute("finishedTime");
                                if (FinishTime.equals("0")) {
                                    FinishTime = "Has not been specified ";
                                }
                                wbo.setAttribute("finishTime", FinishTime);
                                String createdBy = (String) wbo.getAttribute("userId");
                                wbo.setAttribute("createdByName", userMgr.getOnSingleKey(createdBy).getAttribute("userName"));
                                String AssignByName = (String) wbo.getAttribute("assignedByName");
                                wbo.setAttribute("assignedBy", AssignByName);
                                String Receivedby = new String("Automatic Schedule");
                                if (!wbo.getAttribute("receivedby").equals("0")) {
                                    Receivedby = (String) issueMgr.getTechName(wbo.getAttribute("receivedby").toString());
                                }
                                wbo.setAttribute("receivedBy", Receivedby);
                                String FailureCode = (String) issueMgr.getFailureCode(wbo.getAttribute("failureCode").toString());
                                wbo.setAttribute("failureCode", FailureCode);
                                String UrgencyLevel = (String) issueMgr.getUrgencyLevel(wbo.getAttribute("urgencyId").toString());
                                wbo.setAttribute("urgencyLevel", UrgencyLevel);
                                String SiteName = (String) issueMgr.getSiteName(wbo.getAttribute("projectName").toString());
                                wbo.setAttribute("siteName", SiteName);
                                String workTrade = (String) TradeMgr.getInstance().getOnSingleKey((String) wbo.getAttribute("workTrade")).getAttribute("tradeName");
                                wbo.setAttribute("workTrade", workTrade);
                                returnXML = wbo.getObjectAsXML();
                            }
                            response.getWriter().write(returnXML);
                        } else {
                            response.setContentType("text/xml");
                            response.setHeader("Cache-Control", "no-cache");
                            response.getWriter().write("?");
                        }
                        break;

                    case 12:
                        issueId = request.getParameter("issueId");
                        servedPage = "/docs/issue/update_jobIssue_date.jsp";
                        if (request.getParameter("case") != null) {
                            session = request.getSession(true);
                            session.setAttribute("case", request.getParameter("case"));
                            session.setAttribute("title", request.getParameter("title"));
                            session.setAttribute("unitName", request.getParameter("unitName"));

                        }
                        String backTo = (String) request.getParameter("backTo");
                        if (backTo == null) {
                            backTo = "search";
                        }

                        request.setAttribute("backTo", backTo);
                        request.setAttribute("filterName", request.getParameter("filterName"));
                        request.setAttribute("filterValue", request.getParameter("filterValue"));
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 13:
                        issueId = request.getParameter("issueId");
                        refineForm(request);

                        if (issueMgr.updateJobDate(request)) {
                            request.setAttribute("Status", "OK");

                        } else {
                            request.setAttribute("Status", "Failed");
                        }

                        servedPage = "/docs/issue/update_jobIssue_date.jsp";

                        backTo = (String) request.getParameter("backTo");

                        request.setAttribute("backTo", backTo);
                        request.setAttribute("filterName", request.getParameter("filterName"));
                        request.setAttribute("filterValue", request.getParameter("filterValue"));
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 14:
                        urgencyId = urgencyMgr.getUrgencyId(request.getParameter("urgencyLevel").toString());
                        String failureCode = failureCodeMgr.getFailureId(request.getParameter("failureCode").toString());
                        String employeeId = employeeMgr.getEmployeeId(request.getParameter("Receivedby").toString());
                        issueId = request.getParameter("issueId");
                        String unitName = request.getParameter("issueTitle");
                        refineForm(request);

                        if (issueMgr.updateJobOrder(request, urgencyId, failureCode, employeeId, session)) {
                            request.setAttribute("Status", "OK");

                        } else {
                            request.setAttribute("Status", "Failed");
                        }

                        servedPage = "/docs/assigned_issue/edit_ok.jsp";

                        request.setAttribute("filterName", request.getParameter("filterName"));
                        request.setAttribute("filterValue", request.getParameter("filterValue"));
                        request.setAttribute("webIssue", request.getParameter("webIssue"));
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("mainTitle", unitName);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 15:
                        servedPage = "/docs/issue/new_external_order.jsp";
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;

                    case 16:
                        UnitId = null;
                        WebIssue webIssue = new WebIssue();

                        webIssue.setFAID((String) request.getParameter("FAName"));
                        webIssue.setIssueTitle((String) request.getParameter("issueTitle"));
                        webIssue.setIssueID((String) request.getParameter("typeName"));
                        webIssue.setUrgencyID((String) request.getParameter("urgencyName"));
                        webIssue.setIsRisk((String) request.getParameter("isRisk"));
                        webIssue.setIssueDesc((String) request.getParameter("issueDesc"));

                        urgencyId = urgencyMgr.getUrgencyId(request.getParameter("urgencyName"));
                        UnitName = request.getParameter("unitName");
                        ScheduleTitle = request.getParameter("maintenanceTitle");
                        UnitId = issueMgr.getUnitId(UnitName);
                        wboTemp = maintainableMgr.getOnSingleKey(UnitId);
                        webIssue.setAttribute("project_name", wboTemp.getAttribute("site").toString());

                        if (issueMgr.saveObject(request, webIssue, session, urgencyId)) {
                            ScheduleId = null;
                            String Id = null;

                            issueTitle = request.getParameter("issueTitle");
                            ScheduleId = issueMgr.getScheduleId(ScheduleTitle);
                            Id = issueMgr.getScheduleUnitID();

                            request.setAttribute("ScheduleUnitId", Id);
                            request.setAttribute("UnitId", UnitId);
                            request.setAttribute("Status", "OK");
                            request.setAttribute("issueTitle", issueTitle);
                        } else {
                            request.setAttribute("Status", "Failed");
                        }

                        servedPage = "/docs/issue/new_external_order.jsp";
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;

                    case 17:
                        Vector tasksVec = new Vector();
                        Vector executedTasksVec = new Vector();

                        unitScheduleMgr = UnitScheduleMgr.getInstance();

                        servedPage = "/docs/issue/add_tasks.jsp";

                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");

                        issueId = request.getParameter("issueId");

                        WebBusinessObject wboIssueTable = issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject webUnitSch = unitScheduleMgr.getOnSingleKey(wboIssueTable.getAttribute("unitScheduleID").toString());
                        String scheduleId = webUnitSch.getAttribute("periodicId").toString();
                        // save tasks for schedule to issue_task
                        issueTasksMgr.saveTasksForScheduleActive(issueId, scheduleId, userId);

                        //get executed and unexecuted Tasks
                        tasksHT = taskExecutionMgr.findExecutedTasks(issueId);
                        tasksVec = (Vector) tasksHT.get("unExecutedTasks");
                        executedTasksVec = (Vector) tasksHT.get("executedTasks");

                        request.setAttribute("issueTasks", tasksVec);
                        request.setAttribute("executedTasks", executedTasksVec);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 18:

                        IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
                        servedPage = "/docs/issue/add_tasks.jsp";
                        issueId = request.getParameter("issueId");

                        ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                        //get items stored in database
                        Vector storedItems = new Vector();
                        Vector taskParts = new Vector();
                        WebBusinessObject issueTaskWbo = new WebBusinessObject();
                        WebBusinessObject taskPartWbo = new WebBusinessObject();
                        ConfigTasksPartsMgr configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                        Hashtable hashConfig = new Hashtable();
                        Hashtable taskPartsHt = new Hashtable();

                        try {
                            //get executed and unexecuted Tasks
                            tasksHT = taskExecutionMgr.findExecutedTasks(issueId);
                            tasksVec = (Vector) tasksHT.get("unExecutedTasks");
                            executedTasksVec = (Vector) tasksHT.get("executedTasks");

                            /**
                             * **********************Start of remoev old parts
                             * and tasks***********************************
                             */
                            /**
                             * **Get Issue tasks then get task parts then
                             * delete parts on issue then delete tasks on
                             * issue***
                             */
                            QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                            String unitSchId = "";
                            issueMgr = IssueMgr.getInstance();
                            WebBusinessObject issueWbo = new WebBusinessObject();
                            if (tasksVec != null) {

                                for (int i = 0; i < tasksVec.size(); i++) {

                                    taskPartWbo = new WebBusinessObject();
                                    issueWbo = new WebBusinessObject();
                                    taskParts = new Vector();
                                    unitSchId = "";

                                    issueTaskWbo = (WebBusinessObject) tasksVec.get(i);
                                    issueWbo = issueMgr.getOnSingleKey(issueId);
                                    unitSchId = issueWbo.getAttribute("unitScheduleID").toString();
                                    taskParts = configTasksPartsMgr.getOnArbitraryKey(issueTaskWbo.getAttribute("codeTask").toString(), "key1");

                                    //loop To Delete Parts from issue parts Table (quantified_mntnc) that are related to Tasks
                                    for (int c = 0; c < taskParts.size(); c++) {
                                        taskPartWbo = new WebBusinessObject();
                                        taskPartWbo = (WebBusinessObject) taskParts.get(c);
                                        String itemId = taskPartWbo.getAttribute("itemId").toString();
                                        quantifiedMntenceMgr.deleteOnArbitraryDoubleKey(unitSchId, "key1", itemId, "key3");
                                    }
                                    /**
                                     * *****End Of Delete Loop***********
                                     */
                                }
                            }

                            /* Delete Old Tasks Then Add New Tasks with Their Parts*/
                            String taskId = "";
                            WebBusinessObject wbo = new WebBusinessObject();
                            if (tasksVec.size() > 0) {
                                for (int i = 0; i < tasksVec.size(); i++) {
                                    wbo = (WebBusinessObject) tasksVec.elementAt(i);
                                    taskId = wbo.getAttribute("taskID").toString();
                                    issueTasksMgr.deleteOnSingleKey(taskId);
                                }
                            }         // End of Delete tasks

                            /**
                             * **********************End of remoev old parts
                             * and tasks***********************************
                             */
                            /*Save new tasks*/
                            if (issueTasksMgr.saveObject(request, issueId)) {
                                request.setAttribute("Status", "Ok");
                                tasksHT = taskExecutionMgr.findExecutedTasks(issueId);
                                tasksVec = (Vector) tasksHT.get("unExecutedTasks");
                                executedTasksVec = (Vector) tasksHT.get("executedTasks");

                                /*Get parts per task then add it to JO*/
                                unitSchId = "";
                                issueWbo = issueMgr.getOnSingleKey(issueId);
                                unitSchId = issueWbo.getAttribute("unitScheduleID").toString();
                                taskParts = new Vector();
                                String[] tasksCodes = request.getParameterValues("id");    //New tasks Ids
                                if (tasksCodes != null) {
                                    for (int i = 0; i < tasksCodes.length; i++) {
                                        taskParts = new Vector();
                                        taskParts = configTasksPartsMgr.getOnArbitraryKey(tasksCodes[i], "key1");  //task Parts

                                        String[] price = new String[1];
                                        String[] cost = new String[1];
                                        String[] note = new String[1];
                                        String[] id = new String[1];
                                        String[] quantity = new String[1];

                                        String isDirectPrch = "0";   //from spares
                                        String[] attachedOn = new String[1];
                                        attachedOn[0] = "2";

                                        for (int c = 0; c < taskParts.size(); c++) {
                                            taskPartWbo = new WebBusinessObject();
                                            taskPartWbo = (WebBusinessObject) taskParts.get(c);

                                            quantity[0] = taskPartWbo.getAttribute("itemQuantity").toString();
                                            id[0] = taskPartWbo.getAttribute("itemId").toString();
                                            price[0] = taskPartWbo.getAttribute("itemPrice").toString();
                                            cost[0] = taskPartWbo.getAttribute("totalCost").toString();
                                            note[0] = taskPartWbo.getAttribute("note").toString();
                                            quantifiedMntenceMgr.saveObject2(quantity, price, cost, note, id, unitSchId, isDirectPrch, attachedOn, session);
                                            issueMgr.updateTotalCost(new Float(taskPartWbo.getAttribute("totalCost").toString()).floatValue(), issueId);

//                                        WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
//                                        if(wboIssue.getAttribute("issueTitle").toString().equals("Emergency")){
//                                            issueMgr.getUpdateCaseConfigEmg(unitSchId);
//                                        }
                                        }
                                    }
                                }

                                // delete reconfitask
                                reconfigTaskMgr.deleteOnArbitraryKey(issueId, "key1");
                            } else {
                                request.setAttribute("Status", "No");
                            }

                            request.setAttribute("issueTasks", tasksVec);
                            request.setAttribute("executedTasks", executedTasksVec);
                            request.setAttribute("issueId", issueId);
                            request.setAttribute("page", servedPage);
                        } catch (SQLException ex) {
                            request.setAttribute("Status", "No");
                        }
                        this.forwardToServedPage(request, response);
                        break;

                    case 19:
                        Vector taskvec = new Vector();
                        issueId = request.getParameter("issueId");
                        WebBusinessObject taskWbo = null;
                        WebBusinessObject Wbo = null;
                        servedPage = "/docs/issue/tasks_list.jsp";
                        issueTasksMgr = IssueTasksMgr.getInstance();

                        issueTasksMgr.cashData();
                        try {
                            Vector tasks = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
                            for (int i = 0; i < tasks.size(); i++) {
                                taskWbo = (WebBusinessObject) tasks.elementAt(i);
                                Wbo = taskMgr.getOnSingleKey((taskWbo.getAttribute("codeTask")).toString());
                                taskvec.add(Wbo);
                            }

                            request.setAttribute("data", taskvec);
                            request.setAttribute("issueid", issueId);
                        } catch (Exception e) {
                        }
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("issueId", issueId);
                        this.forwardToServedPage(request, response);
                        break;

                    case 20:
                        issueId = request.getParameter("issueId");
                        String taskID = request.getParameter("taskID");
                        servedPage = "/docs/issue/view_task.jsp";
                        issueTasksMgr = IssueTasksMgr.getInstance();
                        issueTasksMgr.cashData();
                        WebBusinessObject task = issueTasksMgr.getOnSingleKey(taskID);
                        request.setAttribute("task", task);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;

                    case 21:
                        issueId = request.getParameter("issueId");
                        taskID = request.getParameter("taskID");
                        servedPage = "/docs/issue/update_task.jsp";
                        issueTasksMgr = IssueTasksMgr.getInstance();
                        issueTasksMgr.cashData();
                        task = issueTasksMgr.getOnSingleKey(taskID);
                        request.setAttribute("task", task);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;

                    case 22:
                        issueId = request.getParameter("issueId");
                        taskID = request.getParameter("taskID");
                        servedPage = "/docs/issue/update_task.jsp";
                        issueTasksMgr = IssueTasksMgr.getInstance();
                        issueTasksMgr.cashData();
                        task = new WebBusinessObject();
                        task.setAttribute("taskID", request.getParameter("taskID"));
                        task.setAttribute("codeTask", request.getParameter("codeTask"));
                        task.setAttribute("descEn", request.getParameter("descEn"));
                        task.setAttribute("descAr", request.getParameter("descAr"));
                        if (issueTasksMgr.updateObject(task)) {
                            request.setAttribute("status", "Ok");
                        } else {
                            request.setAttribute("status", "No");
                        }
                        task = issueTasksMgr.getOnSingleKey(taskID);
                        request.setAttribute("task", task);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;

                    case 23:
                        String codeTask = request.getParameter("codeTask");
                        taskID = request.getParameter("taskID");
                        issueId = request.getParameter("issueId");

                        servedPage = "/docs/issue/confirm_delTask.jsp";

                        request.setAttribute("codeTask", codeTask);
                        request.setAttribute("taskID", taskID);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 24:
                        taskvec = new Vector();
                        issueId = request.getParameter("issueId");
                        taskID = request.getParameter("taskId");
                        servedPage = "/docs/issue/tasks_list.jsp";
                        issueTasksMgr = IssueTasksMgr.getInstance();
                        issueTasksMgr.cashData();
                        issueTasksMgr.deleteOnArbitraryKey(taskID, "key2");
                        try {
                            Vector tasks = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
                            for (int i = 0; i < tasks.size(); i++) {
                                taskWbo = (WebBusinessObject) tasks.elementAt(i);
                                Wbo = taskMgr.getOnSingleKey((taskWbo.getAttribute("codeTask")).toString());
                                taskvec.add(Wbo);
                            }
                            request.setAttribute("data", taskvec);
                        } catch (Exception e) {
                        }
                        request.setAttribute("page", servedPage);
                        request.setAttribute("issueId", issueId);
                        this.forwardToServedPage(request, response);
                        break;

                    case 25:
                        servedPage = "/docs/issue/view_spare_parts.jsp";
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        issueId = request.getParameter("issueId");
                        issueMgr = IssueMgr.getInstance();
                        Vector loaclitems = new Vector();
                        WebBusinessObject wbo = issueMgr.getOnSingleKey(issueId);
                        String scheduleUnitID = (String) wbo.getAttribute("unitScheduleID");

                        // Get Eq_ID from Unit Schedule to check if this Eq is attached or not
                /* check if the equipment id has record(s) in attach_eqps table and
                         the separation_date equl null. this mean this eq is attached.*/
                        Vector attachedEqps = new Vector();
                        Vector minorAttachedEqps = new Vector();
                        int attachFlag = 0;
                        SupplementMgr supplementMgr = SupplementMgr.getInstance();
                        WebBusinessObject unit_sch_wbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                        String Eq_ID = (String) unit_sch_wbo.getAttribute("unitId");
                        attachedEqps = supplementMgr.search(Eq_ID);
                        minorAttachedEqps = supplementMgr.searchAllowedEqps(Eq_ID);
                        if (attachedEqps.size() > 0) {
                            request.setAttribute("attachedEqFlag", "attached");
                        } else {
                            if (minorAttachedEqps.size() > 0) {
                                request.setAttribute("attachedEqFlag", "attached");
                            } else {
                                request.setAttribute("attachedEqFlag", "notAtt");
                            }
                        }

                        WebBusinessObject eq_data = maintainableMgr.getOnSingleKey(Eq_ID);
                        request.setAttribute("isStandalone", (String) eq_data.getAttribute("isStandalone"));

                        quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();

                        DistributedItemsMgr distItemsMgr = DistributedItemsMgr.getInstance();
                        ItemsMgr itemsMgr = ItemsMgr.getInstance();
                        WebBusinessObject item = new WebBusinessObject();

                        ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
                        Vector actualItems = actualItemMgr.getOnArbitraryKey(scheduleUnitID, "key1");
                        LocalStoresItemsMgr localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                        String[] itemCode = null;
//                        for (int i = 0; i < actualItems.size(); i++) {
//                            WebBusinessObject temp = (WebBusinessObject) actualItems.get(i);
//                            String itemID = (String) temp.getAttribute("itemId");
//                            String isDirectPrch=(String)temp.getAttribute("isDirectPrch");
//                            if(isDirectPrch!=null){
//                                if(isDirectPrch.equals("0")){
////                                    WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
////                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
////                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//                                    itemCode = itemID.split("-");
//                                        if(itemCode.length> 1) {
//                                     item = itemsMgr.getOnSingleKey(itemID);
//                                     temp.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));
//                                        } else {
//                                     item = itemsMgr.getOnObjectByKey(itemID);
//                                     temp.setAttribute("itemCode", item.getAttribute("itemCode"));
//                                        }
//
//                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//
//                                }else{
//                                     item = localStoresItemsMgr.getOnSingleKey(itemID);
//                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
//                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//                                }
//                            }else {
////                                WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
////                                temp.setAttribute("itemCode", item.getAttribute("itemCode"));
////                                temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//                                 itemCode = itemID.split("-");
//                                        if(itemCode.length> 1) {
//                                     item = itemsMgr.getOnSingleKey(itemID);
//                                     temp.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));
//                                        } else {
//                                     item = itemsMgr.getOnObjectByKey(itemID);
//                                     temp.setAttribute("itemCode", item.getAttribute("itemCode"));
//                                        }
//
//                                temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//
//                            }
//                        }
                        Vector quantifiedItems = quantifiedMgr.getOnArbitraryKey(scheduleUnitID, "key1");

                        for (int i = 0; i < quantifiedItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) quantifiedItems.get(i);
                            String itemID = (String) temp.getAttribute("itemId");
                            String is_Direct = (String) temp.getAttribute("isDirectPrch");
                            if (is_Direct.equals("0")) {
                                itemCode = itemID.split("-");
                                if (itemCode.length > 1) {
                                    item = itemsMgr.getOnSingleKey(itemID);
                                    try {
                                        temp.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));
                                        temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                    } catch (NullPointerException e) {
                                        temp.setAttribute("itemCode", itemID);
                                        temp.setAttribute("itemDscrptn", "---");
                                        logger.info("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                        logger.error("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                    }
                                } else {
                                    item = itemsMgr.getOnObjectByKey(itemID);
                                    try {
                                        temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                        temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                    } catch (NullPointerException e) {
                                        temp.setAttribute("itemCode", itemID);
                                        temp.setAttribute("itemDscrptn", "---");
                                        logger.info("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                        logger.error("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                    }
                                }
                            } else {
                                loaclitems = localStoresItemsMgr.getOnArbitraryKey(itemID, "key1");
                                try {
                                    for (int x = 0; x < loaclitems.size(); x++) {
                                        item = (WebBusinessObject) loaclitems.get(x);
                                        temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                        temp.setAttribute("itemDscrptn", item.getAttribute("itemName"));
                                    }
                                } catch (NullPointerException e) {
                                    temp.setAttribute("itemCode", itemID);
                                    temp.setAttribute("itemDscrptn", "---");
                                    logger.info("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                    logger.error("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                }

                            }
                        }

                        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                        WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                        configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                        Vector configureItems = configureMainTypeMgr.getOnArbitraryKey(((String) unitScheduleWbo.getAttribute("periodicId")), "key1");
                        for (int i = 0; i < configureItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) configureItems.get(i);
                            String itemID = (String) temp.getAttribute("itemId");
                            itemCode = itemID.split("-");
                            if (itemCode.length > 1) {
                                item = itemsMgr.getOnSingleKey(itemID);
                                try {
                                    temp.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                } catch (NullPointerException e) {
                                    temp.setAttribute("itemCode", itemID);
                                    temp.setAttribute("itemDscrptn", "---");
                                    logger.info("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                    logger.error("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                }
                            } else {
                                item = itemsMgr.getOnObjectByKey(itemID);
                                try {
                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                } catch (NullPointerException e) {
                                    temp.setAttribute("itemCode", itemID);
                                    temp.setAttribute("itemDscrptn", "---");
                                    logger.info("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                    logger.error("Can't find item Code By Item Form # :" + itemID + " in store Erp for JO : " + issueId);
                                }
                            }
                        }
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);

                        request.setAttribute("quantifiedItems", quantifiedItems);
                        request.setAttribute("configureItems", configureItems);
                        request.setAttribute("wbo", wbo);
                        request.setAttribute("page", servedPage);

                        if (request.getParameter("Tap") != null) {
                            request.setAttribute("Tap", "Yes");
                            this.forward(servedPage, request, response);
                        } else {
                            this.forwardToServedPage(request, response);
                        }
                        break;

                    case 26:
                        issueId = request.getParameter("issueId");
                        ChangeDateHistoryMgr changeDateHistoryMgr = ChangeDateHistoryMgr.getInstance();
                        Vector vecHistory = changeDateHistoryMgr.getOnArbitraryKey(issueId, "key2");
                        WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                        servedPage = "/docs/issue/change_date_history.jsp";
                        request.setAttribute("data", vecHistory);
                        request.setAttribute("issueWbo", issueWbo);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 27:
                        request.setAttribute("key", request.getParameter("key"));

                        servedPage = "/docs/issue/ShowJopTab.jsp";

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 28:
                        key = request.getParameter("key");

                        if (key != null) {
                            wbo = issueMgr.getOnSingleKey(key);

                            if (wbo != null) {
                                String FinishTime = (String) wbo.getAttribute("finishedTime");
                                if (FinishTime.equals("0")) {
                                    FinishTime = "Has not been specified ";
                                }

                                wbo.setAttribute("finishTime", FinishTime);
                                String createdBy = (String) wbo.getAttribute("userId");
                                wbo.setAttribute("createdByName", createdBy);
                                String AssignByName = (String) wbo.getAttribute("assignedByName");
                                wbo.setAttribute("assignedBy", AssignByName);
                                String Receivedby = (String) issueMgr.getTechName(wbo.getAttribute("receivedby").toString());
                                wbo.setAttribute("receivedBy", Receivedby);
                                String FailureCode = (String) issueMgr.getFailureCode(wbo.getAttribute("failureCode").toString());
                                wbo.setAttribute("failureCode", FailureCode);
                                String UrgencyLevel = (String) issueMgr.getUrgencyLevel(wbo.getAttribute("urgencyId").toString());
                                wbo.setAttribute("urgencyLevel", UrgencyLevel);
                                String SiteName = (String) issueMgr.getSiteName(wbo.getAttribute("projectName").toString());
                                wbo.setAttribute("siteName", SiteName);
                                request.setAttribute("jopWebo", wbo);

                            }

                        } else {
                            response.setContentType("text/xml");
                            response.setHeader("Cache-Control", "no-cache");
                            response.getWriter().write("?");
                        }
                        servedPage = "/docs/issue/showJopDetails.jsp";
                        this.forward(servedPage, request, response);
                        break;

                    case 29:
                        StringBuffer returned = new StringBuffer();

                        try {

//                    items = configureCategoryMgr.getOnArbitraryKey(categoryId,"key1");
                            issueMgr.cashData();

                            ArrayList issueItems = issueMgr.getCashedTableAsBusObjects();
                            int i = 0;
                            String ttemp;
                            for (; i < issueItems.size(); i++) {

                                wbo = (WebBusinessObject) issueItems.get(i);
                                ttemp = wbo.getAttribute("id").toString() + "!=";
                                returned.append(ttemp);
                            }
                            returned.deleteCharAt(returned.length() - 1);
                            returned.deleteCharAt(returned.length() - 1);

                        } catch (Exception ex) {
                            logger.error("Get Machine Category Items Exception " + ex.getMessage());
                        }
                        response.setContentType("text/xml;charset=UTF-8");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write(returned.toString());
                        break;

                    case 30:

                        String IssueId = request.getParameter("key");
                        servedPage = "/docs/issue/MaintenanceItems.jsp";
                        this.forward(servedPage, request, response);
                        break;
                    case 31:
                        //Define data
                        issueTasksMgr = IssueTasksMgr.getInstance();

                        //Get request data
                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                        issueMetaDataMgr = IssueMetaDataMgr.getInstance();
                        IssueId = request.getParameter("key");
                        if (IssueId == null) {
                            IssueId = request.getParameter("issueId");
                        }
                        wboIssueTable = issueMgr.getOnSingleKey(IssueId);
                        webUnitSch = unitScheduleMgr.getOnSingleKey(wboIssueTable.getAttribute("unitScheduleID").toString());
                        scheduleId = webUnitSch.getAttribute("periodicId").toString();

                        // save tasks for schedule to issue_task
                        issueTasksMgr.saveTasksForScheduleActive(IssueId, scheduleId, userId);

                        //First - get issue_tasks_complaints
                        Vector issueTasksComplaintsVec = issueTasksComplaintMgr.getOnArbitraryKey(IssueId, "key1");
                        ArrayList issueTasksCompAL = new ArrayList();

                        for (int i = 0; i < issueTasksComplaintsVec.size(); i++) {
                            WebBusinessObject compWbo = (WebBusinessObject) issueTasksComplaintsVec.elementAt(i);
                            issueTasksCompAL.add(compWbo.getAttribute("taskID").toString());
                        }

                        //Second - gett issue tasks
                        Vector issueTaksVec = issueTasksMgr.getOnArbitraryKey(IssueId, "key1");
                        ArrayList issueTasksArr = new ArrayList();
                        taskWbo = new WebBusinessObject();
                        for (int i = 0; i < issueTaksVec.size(); i++) {
                            //get task code
                            String taskCode = ((WebBusinessObject) issueTaksVec.get(i)).getAttribute("codeTask").toString();

                            //get task WebBusinessObject
                            taskWbo = taskMgr.getOnSingleKey(taskCode);

                            //Check if task code is exist on issue_tasks_complaints
                            if (issueTasksCompAL.contains(taskCode)) {
                                taskWbo.setAttribute("source", "complaint");
                            } else {
                                taskWbo.setAttribute("source", "job order");
                            }

                            //save taskWBO in AL
                            issueTasksArr.add(taskWbo);
                        }

                        servedPage = "/docs/issue/ReqiuredJopsToJopOrder.jsp";

                        request.setAttribute("issueTasks", issueTasksArr);
                        request.setAttribute("issueId", IssueId);

                        if (request.getParameter("issueTitle") == null) {
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                        } else {
                            request.setAttribute("projectName", request.getParameter("projcteName"));
                            request.setAttribute("mainTitle", request.getParameter("mainTitle"));
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                        }
                        break;
                    case 32:
                        IssueId = request.getParameter("key");
                        servedPage = "/docs/issue/Reqiured_Workers_To_JopOrder.jsp";
                        this.forward(servedPage, request, response);
                        break;

                    case 33:
                        IssueId = request.getParameter("key");
                        servedPage = "/docs/issue/ReqiuedInstructionToJopOrder.jsp";
                        this.forward(servedPage, request, response);
                        break;
                    case 34:
                        IssueId = request.getParameter("key");
                        servedPage = "/docs/schedule/new_task_by_Job.jsp";

                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;
                    case 35:
                        IssueId = request.getParameter("key");
                        servedPage = "/docs/schedule/Instructions.jsp";

                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;

                    case 36:
                        String remoteAccess = request.getSession().getId();
                        WebBusinessObject localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
                        String userHome = (String) loggedUser.getAttribute("userHome");
                        String userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                        MultipartRequest multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                        if (externalJobMgr.saveObject(multipartRequest, session)) {
                            request.setAttribute("Status", "OK");
                        } else {
                            request.setAttribute("Status", "Failed");
                        }

                        Calendar c = Calendar.getInstance();

                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        String projectID = request.getParameter("projectID");

                        String endDate = multipartRequest.getParameter("conversionDate");
                        String hour = new Integer(c.get(Calendar.HOUR_OF_DAY)).toString();
                        String min = new Integer(c.get(Calendar.MINUTE)).toString();
                        java.util.Date endD = null;
                        DateParser dateParser = new DateParser();

                        if (null != endDate) {
//                            String[] date = endDate.split("/");
//                            int year = Integer.parseInt(date[2]);
//                            int month = Integer.parseInt(date[0]);
//                            int day = Integer.parseInt(date[1]);
                            int h = Integer.parseInt(hour);
                            int m = Integer.parseInt(min);
//                            endD = new java.util.Date(year - 1900, month, day, h, m);

                            endD = dateParser.formatUtilDate(endDate, h, m);

                        }
                        destination = AppConstants.getFullLink(filterName, filterValue);

                        if (multipartRequest.getParameter("case") != null) {
                            destination = destination.replaceFirst("StatusProjectListAll", "StatusProjctListTitle");
                            String addToURL = "&title=" + multipartRequest.getParameter("title") + "&unitName=" + (String) multipartRequest.getParameter("unitName");
                            destination += addToURL;
                            destination = destination.replace(' ', '+');
                        }

                        issueTitle = multipartRequest.getParameter("issueTitle");
                        String assignNote = multipartRequest.getParameter("reason");
                        userId = new String("1");

                        wIssue = new WebIssue();
                        wIssue.setIssueID((String) multipartRequest.getParameter(IssueConstants.ISSUEID));
                        wIssue.setAssignedToID("1");
                        wIssue.setAssignedToName(userMgr.getUserByID(userId));
                        wIssue.setFinishedTime("0");
                        wIssue.setIssueTitle((String) multipartRequest.getParameter(IssueConstants.ISSUETITLE));
                        wIssue.setManagerNote((String) multipartRequest.getParameter("reason"));
                        wIssue.setAttribute("empID", "1204380497625");
                        wIssue.setAttribute("failurecode", "1");
                        String uid = new String("1");
                        issueId = multipartRequest.getParameter("issueId");
                        AssignedIssueMgr assIssueMgr = AssignedIssueMgr.getInstance();
                        try {
                            // q.deleteOnArbitraryKey(uid, "key1");
                            assIssueMgr.saveObject(wIssue, request.getSession(), assignNote, new java.sql.Timestamp(endD.getTime()));
                            if (request.getParameter("changeState") != null) {
                                WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
                                unitScheduleMgr = UnitScheduleMgr.getInstance();
                                WebBusinessObject wboUnitSchedule = unitScheduleMgr.getOnSingleKey((String) wboIssue.getAttribute("unitScheduleID"));
                                String equipmentID = (String) wboUnitSchedule.getAttribute("unitId");
                                EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                                WebBusinessObject wboState = equipmentStatusMgr.getLastStatus(equipmentID);
                                int currentStatus = 1;
                                if (wboState != null) {
                                    String stateID = (String) wboState.getAttribute("stateID");
                                    currentStatus = new Integer(stateID).intValue();
                                }
                                if (currentStatus == 1) {

                                    WebBusinessObject wboStatus = new WebBusinessObject();
                                    wboStatus.setAttribute("equipmentID", equipmentID);
                                    wboStatus.setAttribute("stateID", new String("2"));
                                    wboStatus.setAttribute("note", "Out of Line");
                                    wboStatus.setAttribute("beginDate", (c.get(Calendar.MONTH) + 1) + "/" + c.get(Calendar.DAY_OF_MONTH) + "/" + c.get(Calendar.YEAR));
                                    wboStatus.setAttribute("hour", new Integer(c.get(Calendar.HOUR_OF_DAY)).toString());
                                    equipmentStatusMgr.saveObject(wboStatus, request.getSession());
                                }
                            }
                            /////////////////

//                            QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
//                            String[] quantity = request.getParameterValues("qun");
//                            String[] price = request.getParameterValues("price");
//                            String[] cost = request.getParameterValues("cost");
//                            String[] note = request.getParameterValues("note");
//                            String[] id = request.getParameterValues("Hid");
//                            if (quantity != null) {
//                                quantifiedMntenceMgr.saveObject(quantity, price, cost, note, id, uid, request.getSession());
//                            }
                            ////////////////////
                        } catch (Exception ex) {
                            logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                        }
                        //Begin Save PDF

                        String userID = localPersistentUser.getAttribute("userId").toString();
                        itemList = new Vector();

                        QuantifiedMntenceMgr quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        itemList = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());

                        request.setAttribute("projectName", projectID);

                        servedPage = "/docs/issue/external_order.jsp";
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;

                    case 38:
                        servedPage = "/docs/issue/add_workers.jsp";
                        Hashtable taskByEmpHash = new Hashtable();
                        WebBusinessObject planTaskWbo = new WebBusinessObject();
                        PlannedTasksMgr plannedTasksMgr = PlannedTasksMgr.getInstance();
                        TaskExecutionMgr taskExecutionMgr = TaskExecutionMgr.getInstance();
                        EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                        Vector vecPlannedTasks = new Vector();
                        Vector vecTasksHours = new Vector();
                        if (taskExecutionMgr.saveObject(request)) {
                            request.setAttribute("Status", "OK");

                            /* To Back View Labours Form to see all workers add
                             on this job Order */
                            vecPlannedTasks = plannedTasksMgr.getPlannedTasksByIssue(request.getParameter("issueId"));

                            for (int i = 0; i < vecPlannedTasks.size(); i++) {
                                planTaskWbo = (WebBusinessObject) vecPlannedTasks.get(i);
                                vecTasksHours = empTasksHoursMgr.getTasksHoursByTasks(planTaskWbo.getAttribute("taskId").toString(), planTaskWbo.getAttribute("issueID").toString());
                                taskByEmpHash.put(planTaskWbo.getAttribute("taskId").toString(), vecTasksHours);
                            }
                            // Vector vecTasksHours = empTasksHoursMgr.getTasksHoursByIssue(request.getParameter("issueId"));
                            servedPage = "/docs/issue/workers_report.jsp";
                            issueMgr = IssueMgr.getInstance();
                            WebBusinessObject wboIssue = issueMgr.getOnSingleKey(request.getParameter("issueId"));
                            request.setAttribute("wbo", wboIssue);
                            request.setAttribute("vecPlannedTasks", vecPlannedTasks);
                            request.setAttribute("taskByEmpHash", taskByEmpHash);
                            request.setAttribute("vecTasksHours", vecTasksHours);
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                            /**
                             * ******* End ************
                             */
                        } else {
                            request.setAttribute("Status", "Failed");
                        }
                        issueTasksMgr = IssueTasksMgr.getInstance();
                        EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();

                        Vector vecIssueTasks = new Vector();
                        try {
                            vecIssueTasks = issueTasksMgr.getOnArbitraryKey(request.getParameter("issueId"), "key1");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        request.setAttribute("arrWorkers", employeeMgr.getCashedTableAsBusObjects());
                        request.setAttribute("vecIssueTasks", vecIssueTasks);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 39:
                        WebBusinessObject wboIssue;
                        WebBusinessObject wboIssueStatusNote;
                        IssueStatusMgr issueStatusMgr2 = IssueStatusMgr.getInstance();
                        CostResultIemMgr costResultIemMgr = CostResultIemMgr.getInstance();
                        ItemsWithAvgPriceMgr avgpriceMgr = ItemsWithAvgPriceMgr.getInstance();
                        Vector avgPrice = new Vector();
                        String unitSchedule = null;
                        Vector quantfItemList = new Vector();

                        itemsMgr = ItemsMgr.getInstance();
                        itemCode = null;
                        actualItemMgr = ActualItemMgr.getInstance();
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        itemList = new Vector();

                        issueId = request.getParameter(IssueConstants.ISSUEID);
                        issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                        issueState = request.getParameter("issueStatus");

                        // get unit schedule
                        wboIssue = issueMgr.getOnSingleKey(issueId);
                        if (wboIssue != null) {
                            unitSchedule = (String) wboIssue.getAttribute("unitScheduleID");
                        }

                        Vector issueItemVec = new Vector();
                        Vector<WebBusinessObject> resultItemVec = new Vector<WebBusinessObject>();
                        Vector<WebBusinessObject> costResult = new Vector<WebBusinessObject>();
                        TransStoreItemMgr transStoreItemMgr = TransStoreItemMgr.getInstance();
                        ResultStoreItemMgr resultStoreItemMgr = ResultStoreItemMgr.getInstance();

                        issueItemVec = transStoreItemMgr.getResponseTotalStoreItems(issueId, "91");
                        resultItemVec = resultStoreItemMgr.getResultTotalStoreItems(issueId, "91");
                        avgPrice = avgpriceMgr.getItemsWithAvgPrice(unitSchedule);

                        // get cost for items
                        double cost,
                         totalCost = 0;
                        for (WebBusinessObject wboItems : resultItemVec) {
                            cost = 0;
                            costResult = costResultIemMgr.getOnArbitraryDoubleKey(unitSchedule, "key1", (String) wboItems.getAttribute("itemId"), "key2");
                            for (WebBusinessObject wboResultCost : costResult) {
                                try {
                                    cost += Double.valueOf((String) wboResultCost.getAttribute("totalCost")).doubleValue();
                                } catch (NumberFormatException ex) {
                                }
                            }
                            totalCost += cost;
                            wboItems.setAttribute("cost", Tools.round(cost, 2, BigDecimal.ROUND_HALF_UP));
                        }

                        totalCost = Tools.round(totalCost, 2, BigDecimal.ROUND_HALF_UP);

                        request.setAttribute("totalCostItems", String.valueOf(totalCost));
                        request.setAttribute("issueItemVec", issueItemVec);
                        request.setAttribute("resultItem", resultItemVec);
                        request.setAttribute("avgPrice", avgPrice);
                        quantifiedMgr = QuantifiedMntenceMgr.getInstance();

                        if (issueTitle.equalsIgnoreCase("External") || issueTitle.equalsIgnoreCase("Emergency")) {

                            itemList = actualItemMgr.getActualItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
//                            request.setAttribute("data", itemList);
//                            if (itemList.size() == 0) {
                            itemList = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                            request.setAttribute("data", itemList);
//                            }
                        } else {

                            unitScheduleMgr = UnitScheduleMgr.getInstance();
                            unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                            WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());

//                            actualItemList = actualItemMgr.getActualItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
//
//                            if (actualItemList.size() != 0) {
//                                request.setAttribute("data", actualItemList);
//                            }
                            maintenanceItemMgr = MaintenanceItemMgr.getInstance();

                            localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                            quantfItemList = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());

                            for (int i = 0; i < quantfItemList.size(); i++) {
                                WebBusinessObject temp = (WebBusinessObject) quantfItemList.get(i);
                                String itemID = (String) temp.getAttribute("itemId");
                                String is_Direct = (String) temp.getAttribute("isDirectPrch");
                                itemCode = itemID.split("-");
                                if (is_Direct.equals("0")) {
                                    if (itemCode.length > 1) {
                                        item = itemsMgr.getOnSingleKey(itemID);
                                        temp.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));
                                    } else {
                                        item = itemsMgr.getOnObjectByKey(itemID);
                                        temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    }
                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                } else {
                                    loaclitems = localStoresItemsMgr.getOnArbitraryKey(itemID, "key1");
                                    for (int x = 0; x < loaclitems.size(); x++) {
                                        item = (WebBusinessObject) loaclitems.get(x);
                                        temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                        temp.setAttribute("itemDscrptn", item.getAttribute("itemName"));
                                    }
                                }
                            }

                            if (quantfItemList.size() <= 0) {
                                //get parts from configure maintenance table
                                quantfItemList = configureTypeMgr.getConfigItemBySchedule(scheduleWbo.getAttribute("periodicID").toString());
                            }
                            request.setAttribute("data", quantfItemList);
                        }
                        Vector complaints = new Vector();
                        LaborComplaintsMgr laborComplaintsMgr = LaborComplaintsMgr.getInstance();
                        complaints = laborComplaintsMgr.getOnArbitraryKey(issueId, "key1");

                        wbo = new WebBusinessObject();
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        wbo = issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject webIssueStatus = new WebBusinessObject();
                        webIssueStatus = issueStatusMgr.getIssueStatusFinish(issueId);

                        request.setAttribute("issueWbo", wbo);
                        request.setAttribute("webIssueStatus", webIssueStatus);
                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);

                        servedPage = "/docs/issue/printJobOrder.jsp";
                        request.setAttribute("filter", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("complaints", complaints);
//                        request.setAttribute("data", itemList);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("webIssue", wboIssue);
                        this.forward(servedPage, request, response);
                        break;

                    case 40:

                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        itemList = new Vector();

                        issueId = request.getParameter(IssueConstants.ISSUEID);
                        issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                        issueState = request.getParameter("issueStatus");
                        quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        if (issueTitle.equalsIgnoreCase("External") || issueTitle.equalsIgnoreCase("Emergency") || ((!issueTitle.equalsIgnoreCase("Emergency") || !issueTitle.equalsIgnoreCase("External")) && (!issueState.equalsIgnoreCase("Schedule")))) {
                            itemList = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                        } else {

                            unitScheduleMgr = UnitScheduleMgr.getInstance();
                            unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                            WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                            itemList = configureTypeMgr.getConfigItemBySchedule(scheduleWbo.getAttribute("periodicID").toString());
                        }

                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);

                        servedPage = "/docs/issue/printOrderStore.jsp";
                        request.setAttribute("filter", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("data", itemList);
                        request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                        break;

                    case 41:

                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        String equipmentID = request.getParameter("equipmentID");
                        String currentMode = request.getParameter("currentMode");
                        servedPage = "/docs/issue/emergency_By_Equip.jsp";

                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("currentMode", currentMode);
                        request.setAttribute("equipmentID", equipmentID);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 42:

                        wIssue = new WebIssue();
                        refineForm(request);
                        urgencyId = urgencyMgr.getUrgencyId(request.getParameter("urgencyName"));
                        UnitName = request.getParameter("unitName");
                        ScheduleTitle = request.getParameter("maintenanceTitle");
                        equipmentID = request.getParameter("equipmentID");
                        currentMode = request.getParameter("currentMode");
                        UnitId = null;
                        UnitId = issueMgr.getUnitId(UnitName);
                        wboTemp = maintainableMgr.getOnSingleKey(UnitId);
                        wIssue.setAttribute("project_name", wboTemp.getAttribute("site").toString());
                        if (issueMgr.saveObject(request, wIssue, session, urgencyId)) {

                            ScheduleId = null;

                            String Id = null;
                            issueTitle = request.getParameter("issueTitle");

                            ScheduleId = issueMgr.getScheduleId(ScheduleTitle);
                            Id = issueMgr.getScheduleUnitID();
                            request.setAttribute("issueID", issueMgr.getIssueID());
                            request.setAttribute("sID", issueMgr.getSID());
                            request.setAttribute("ScheduleUnitId", Id);
                            request.setAttribute("currentMode", currentMode);
                            request.setAttribute("equipmentID", equipmentID);
                            request.setAttribute("UnitId", UnitId);
                            request.setAttribute("Status", "OK");
                            request.setAttribute("issueTitle", issueTitle);

                        } else {
                            request.setAttribute("Status", "Failed");
                        }
                        servedPage = "/docs/issue/emergency_By_Equip.jsp";
                        //  request.setAttribute("UnitId",UnitId);
                        //   request.setAttribute("ScheduleId",ScheduleId);

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 43:
                        servedPage = "/docs/issue/new_Issue.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

//                    case 44:
//                        refineForm(request);
//                        urgencyId = urgencyMgr.getUrgencyId(request.getParameter("urgencyName"));
//                        UnitName = request.getParameter("unitName");
//                        ScheduleTitle = request.getParameter("maintenanceTitle");
//                        UnitId = "";
//                        UnitId = issueMgr.getUnitId(UnitName);
//                        wboTemp = maintainableMgr.getOnSingleKey(UnitId);
//                        wIssue = new WebIssue();
//                        wIssue.setAttribute("project_name", wboTemp.getAttribute("site").toString());
//                        if (issueMgr.saveObject(request, wIssue, session, urgencyId)) {
//
//                            ScheduleId = null;
//
//                            String Id = null;
//                            issueTitle = request.getParameter("issueTitle");
//
//                            ScheduleId = issueMgr.getScheduleId(ScheduleTitle);
//                            Id = issueMgr.getScheduleUnitID();
//                            issueId = issueMgr.getIssueID();
//
//                            wboIssue = new WebBusinessObject();
//                            wboIssue = issueMgr.getOnSingleKey(issueId);
//                            AttachedIssuesMgr attachedIssuesMgr = AttachedIssuesMgr.getInstance();
//                            attachedIssuesMgr.saveObject(request, Id);
//
//                            request.setAttribute("issueID", issueMgr.getIssueID());
//                            request.setAttribute("businessID", wboIssue.getAttribute("businessID").toString());
//                            request.setAttribute("sID", issueMgr.getSID());
//                            request.setAttribute("ScheduleUnitId", Id);
//                            request.setAttribute("UnitId", UnitId);
//                            request.setAttribute("Status", "OK");
//                            request.setAttribute("issueTitle", issueTitle);
//                            request.setAttribute("Attached", "Yes");
//
//                        } else {
//                            request.setAttribute("Status", "Failed");
//                        }
//
//                        servedPage = "/docs/issue/new_Issue.jsp";
//                        request.setAttribute("page", servedPage);
//                        this.forwardToServedPage(request, response);
//                        break;
                    case 45:
                        filterName = (String) request.getParameter("filterName");
                        filterValue = (String) request.getParameter("filterValue");
                        String isId = request.getParameter("issueId");
                        String maintTitle = request.getParameter("maintTitle");
                        String jobNo = request.getParameter("jobNo");

                        //get issue complaints and complaints tasks
                        compTasksVec = new Vector();
                        compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");

                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("maintTitle", maintTitle);
                        request.setAttribute("jobNo", jobNo);
                        request.setAttribute("issueId", isId);
                        request.setAttribute("comp", compTasksVec);

                        servedPage = "/docs/issue/comp_List.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                        break;

                    case 55:
                        filterName = (String) request.getParameter("filterName");
                        filterValue = (String) request.getParameter("filterValue");
                        isId = request.getParameter("issueId");
                        maintTitle = request.getParameter("maintTitle");
                        jobNo = request.getParameter("jobNo");

                        //get issue complaints and complaints tasks
                        compTasksVec = new Vector();
                        compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");

                        request.setAttribute("maintTitle", maintTitle);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("jobNo", jobNo);
                        request.setAttribute("issueId", isId);
                        request.setAttribute("comp", compTasksVec);

                        servedPage = "/docs/issue/combine_comp.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                        break;

                    case 56:
                        servedPage = "/docs/issue/attach_job_order.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 57:
                        Vector vecIssue = issueMgr.getOnArbitraryKey(request.getParameter("attachIssueID"), "key4");
                        if (vecIssue.size() > 0) {
                            wboTemp = (WebBusinessObject) vecIssue.get(0);
                            AttachedIssuesMgr attachedIssuesMgr = AttachedIssuesMgr.getInstance();
                            if (attachedIssuesMgr.getOnArbitraryKey((String) wboTemp.getAttribute("id"), "key1").size() == 0 && attachedIssuesMgr.getOnArbitraryKey((String) wboTemp.getAttribute("id"), "key2").size() == 0) {
                                if (attachedIssuesMgr.saveObject(request, (String) wboTemp.getAttribute("id"))) {
                                    request.setAttribute("status", "OK");
                                } else {
                                    request.setAttribute("status", "Failed");
                                }
                            } else {
                                request.setAttribute("status", "Failed");
                            }
                        } else {
                            request.setAttribute("status", "Failed");
                        }
                        servedPage = "/docs/issue/attach_job_order.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 58:
                        Vector issueVec = new Vector();
                        issueId = request.getParameter("issueId");

                        servedPage = "/docs/issue/status_jobOrder_date.jsp";
                        issueVec = issueMgr.getOnArbitraryKey(issueId, "key");

                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        request.setAttribute("data", issueVec);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("issueId", issueId);
                        this.forwardToServedPage(request, response);
                        break;

//                    case 59:
//                        refineEmeregencyForm(request);
//
//                        //get request data
//                        UnitId = request.getParameter("unitName");
//                        wIssue = new WebIssue();
//                        //get equipment site
//                        wboTemp = maintainableMgr.getOnSingleKey(UnitId);
//                        wIssue.setAttribute("project_name", wboTemp.getAttribute("site").toString());
//                        //Save emergency Job order
//                        if (issueMgr.saveJobOrderOfInspection(request, wIssue, session)) {
//
//                            // change status of inspection to close
//                            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
//                            String inspectionId = request.getParameter("inspectionId");
//                            InspectionMgr inspectionMgr = InspectionMgr.getInstance();
//                            inspectionMgr.updateInspectionAsClosedAgree(inspectionId, securityUser.getUserId());
//                            ///////////////////////
//
//                            webIssue = (WebIssue) issueMgr.getOnSingleKey(issueMgr.getIssueID());
//                            request.setAttribute("issueID", issueMgr.getIssueID());
//                            request.setAttribute("businessID", webIssue.getAttribute("businessID").toString());
//                            request.setAttribute("sID", issueMgr.getSID());
//                            request.setAttribute("Status", "OK");
//
//                            request.getSession().setAttribute("IssueWbo", webIssue);
//                            request.getSession().setAttribute("equipmentWbo", wboTemp);
//                            request.getSession().setAttribute("joType", "emg");
//                            /**
//                             * *************************************************
//                             */
//                            scheduleUnitID = (String) webIssue.getAttribute("unitScheduleID");
//                            /* Get Eq_ID from Unit Schedule to check if this Eq is attached or not
//                             check if the equipment id has record(s) in attach_eqps table and
//                             the separation_date equl null. this mean this eq is attached.*/
//                            attachedEqps = new Vector();
//                            minorAttachedEqps = new Vector();
//                            attachFlag = 0;
//                            supplementMgr = SupplementMgr.getInstance();
//                            unitScheduleMgr = UnitScheduleMgr.getInstance();
//                            unit_sch_wbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
//                            Eq_ID = (String) unit_sch_wbo.getAttribute("unitId");
//                            attachedEqps = supplementMgr.search(Eq_ID);
//                            minorAttachedEqps = supplementMgr.searchAllowedEqps(Eq_ID);
//                            String attachedEqFlag = "";
//                            if (attachedEqps.size() > 0) {
//                                attachedEqFlag = "attached";
//                            } else {
//                                if (minorAttachedEqps.size() > 0) {
//                                    attachedEqFlag = "attached";
//                                } else {
//                                    attachedEqFlag = "notatt";
//                                }
//
//                            }
//                            request.getSession().setAttribute("attFlag", attachedEqFlag);
//
//                            /**
//                             * ****Create Dynamic contenet of Issue menu ******
//                             */
//                            //open Jar File
//                            metaMgr.setMetaData("xfile.jar");
//
//                            Vector issueMenu = new Vector();
//                            String mode = (String) request.getSession().getAttribute("currentMode");
//                            issueMenu = parseSideMenu.parseSideMenu(mode, "issue_menu.xml", "n");
//
//                            metaMgr.closeDataSource();
//
//                            /* Add ids for links*/
//                            Vector linkVec = new Vector();
//                            String link = "";
//
//                            Hashtable style = new Hashtable();
//                            style = (Hashtable) issueMenu.get(0);
//                            String title = style.get("title").toString();
//                            title += "   " + webIssue.getAttribute("businessID").toString();
//                            style.remove("title");
//                            style.put("title", title);
//
//                            for (int i = 1; i < issueMenu.size() - 1; i++) {
//                                linkVec = new Vector();
//                                link = "";
//                                linkVec = (Vector) issueMenu.get(i);
//                                link = (String) linkVec.get(1);
//
//                                if (link.equalsIgnoreCase("AssignedIssueServlet?op=assign&state=SCHEDULE&viewOrigin=null&direction=forward&issueId=")) {
//                                    String IssueCurrentStatus = (String) wIssue.getAttribute("currentStatus");
//
//                                    if (IssueCurrentStatus != null) {
//                                        if (IssueCurrentStatus.equalsIgnoreCase("Schedule") || IssueCurrentStatus.equalsIgnoreCase("Rejected")) {
//                                            link += issueMgr.getIssueID() + "&attachedEqFlag=" + attachedEqFlag + "&equipmentID=" + UnitId;
//                                        } else {
//                                            issueMenu.remove(i);
//                                            i--;
//                                            continue;
//                                        }
//                                    } else {
//                                        link += issueMgr.getIssueID() + "&attachedEqFlag=" + attachedEqFlag + "&equipmentID=" + UnitId;
//                                    }
//
//                                } else {
//                                    link += issueMgr.getIssueID() + "&attachedEqFlag=" + attachedEqFlag + "&equipmentID=" + UnitId;
//                                }
//                                linkVec.remove(1);
//                                linkVec.add(link);
//                            }
//
//                            Hashtable topMenu = new Hashtable();
//                            Vector tempVec = new Vector();
//                            topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
//
//                            if (topMenu != null && topMenu.size() > 0) {
//
//                                /* 1- Get the current Side menu
//                                 * 2- Check Menu Type
//                                 * 3- insert menu object to top menu accordding to it's type
//                                 */
//                                Vector menuType = new Vector();
//                                Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
//
//                                if (currentSideMenu != null && currentSideMenu.size() > 0) {
//                                    linkVec = new Vector();
//
//                                    // the element # 1 in menu is to view the object
//                                    linkVec = (Vector) currentSideMenu.get(1);
//
//                                    // size-1 becouse the menu type is the last element in vector
//                                    menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);
//
//                                    if (menuType != null && menuType.size() > 0) {
//                                        topMenu.put((String) menuType.get(1), linkVec);
//                                    }
//
//                                }
//
//                                request.getSession().setAttribute("topMenu", topMenu);
//                            }
//
//                            request.getSession().setAttribute("sideMenuVec", issueMenu);
//                            /*End of Menu*/
//                            /**
//                             * *************************************************
//                             */
//                        } else {
//                            request.setAttribute("Status", "Failed");
//                        }
//
//                        servedPage = "/docs/issue/issue_emg_saving.jsp";
//
//                        request.setAttribute("page", servedPage);
//                        this.forwardToServedPage(request, response);
//                        break;
                    case 60:
                        servedPage = "/docs/issue/add_parts_warranty.jsp";
                        filterName = request.getParameter("filterName");
                        filterValue = request.getParameter("filterValue");
                        issueId = request.getParameter("issueId");
                        issueMgr = IssueMgr.getInstance();
                        loaclitems = new Vector();
                        wbo = issueMgr.getOnSingleKey(issueId);
                        scheduleUnitID = (String) wbo.getAttribute("unitScheduleID");
                        unitScheduleMgr = UnitScheduleMgr.getInstance();

                        attachedEqps = new Vector();
                        minorAttachedEqps = new Vector();
                        attachFlag = 0;
                        supplementMgr = SupplementMgr.getInstance();
                        unit_sch_wbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                        Eq_ID = (String) unit_sch_wbo.getAttribute("unitId");
                        attachedEqps = supplementMgr.search(Eq_ID);
                        minorAttachedEqps = supplementMgr.searchAllowedEqps(Eq_ID);
                        if (attachedEqps.size() > 0) {
                            request.setAttribute("attachedEqFlag", "attached");
                        } else {
                            if (minorAttachedEqps.size() > 0) {
                                request.setAttribute("attachedEqFlag", "attached");
                            } else {
                                request.setAttribute("attachedEqFlag", "notAtt");
                            }
                        }

                        eq_data = maintainableMgr.getOnSingleKey(Eq_ID);
                        request.setAttribute("isStandalone", (String) eq_data.getAttribute("isStandalone"));

                        quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        maintenanceItemMgr = MaintenanceItemMgr.getInstance();

                        distItemsMgr = DistributedItemsMgr.getInstance();
                        itemsMgr = ItemsMgr.getInstance();
                        item = new WebBusinessObject();

                        actualItemMgr = ActualItemMgr.getInstance();
                        actualItems = actualItemMgr.getOnArbitraryKey(scheduleUnitID, "key1");
                        localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                        itemCode = null;
                        quantifiedItems = quantifiedMgr.getOnArbitraryKey(scheduleUnitID, "key1");

                        for (int i = 0; i < quantifiedItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) quantifiedItems.get(i);
                            String itemID = (String) temp.getAttribute("itemId");
                            String is_Direct = (String) temp.getAttribute("isDirectPrch");
                            if (is_Direct.equals("0")) {
                                itemCode = itemID.split("-");
                                if (itemCode.length > 1) {
                                    item = itemsMgr.getOnSingleKey(itemID);
                                    temp.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                } else {
                                    item = itemsMgr.getOnObjectByKey(itemID);
                                    if (item != null) {
                                        temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    }
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                }
                            } else {
                                loaclitems = localStoresItemsMgr.getOnArbitraryKey(itemID, "key1");
                                for (int x = 0; x < loaclitems.size(); x++) {
                                    item = (WebBusinessObject) loaclitems.get(x);
                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemName"));
                                }
                            }
                        }

                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        unitScheduleWbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                        configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                        configureItems = configureMainTypeMgr.getOnArbitraryKey(((String) unitScheduleWbo.getAttribute("periodicId")), "key1");
                        for (int i = 0; i < configureItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) configureItems.get(i);
                            String itemID = (String) temp.getAttribute("itemId");
                            itemCode = itemID.split("-");
                            if (itemCode.length > 1) {
                                item = itemsMgr.getOnSingleKey(itemID);
                                temp.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));
                                temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                            } else {
                                item = itemsMgr.getOnObjectByKey(itemID);
                                if (item != null) {
                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                }
                                temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                            }
                        }
                        Hashtable<String, WebBusinessObject> warrantyInfo = new Hashtable<String, WebBusinessObject>();
                        WebBusinessObject temp = new WebBusinessObject();
                        WarrantyItemsMgr warrantyItemsMgr = WarrantyItemsMgr.getInstance();
                        for (int i = 0; i < quantifiedItems.size(); i++) {
                            temp = (WebBusinessObject) quantifiedItems.get(i);
                            Vector warrantyTemp = warrantyItemsMgr.getOnArbitraryKey(temp.getAttribute("id").toString(), "key1");
                            if (warrantyTemp.size() > 0) {
                                warrantyInfo.put((String) temp.getAttribute("id"), (WebBusinessObject) warrantyTemp.get(0));
                            }
                        }
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("warrantyInfo", warrantyInfo);
                        request.setAttribute("quantifiedItems", quantifiedItems);
                        request.setAttribute("configureItems", configureItems);
                        request.setAttribute("wbo", wbo);
                        request.setAttribute("page", servedPage);

                        if (request.getParameter("Tap") != null) {
                            request.setAttribute("Tap", "Yes");
                            this.forward(servedPage, request, response);
                        } else {
                            this.forwardToServedPage(request, response);
                        }
                        break;

                    case 61:
                        externalJobMgr = ExternalJobMgr.getInstance();
                        if (externalJobMgr.updateExternalChange(request)) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "fail");
                        }
                        servedPage = "/docs/issue/edit_external_order.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 62:
                        filterName = (String) request.getParameter("filterName");
                        filterValue = (String) request.getParameter("filterValue");
                        isId = request.getParameter("issueId");
                        maintTitle = request.getParameter("maintTitle");
                        jobNo = request.getParameter("jobNo");

                        //get issue complaints and complaints tasks
                        compTasksVec = new Vector();
                        compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");
                        request.setAttribute("maintTitle", maintTitle);
                        request.setAttribute("filterName", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("jobNo", jobNo);
                        request.setAttribute("issueId", isId);
                        request.setAttribute("comp", compTasksVec);
                        servedPage = "/docs/issue/combine_comp_item.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                        break;
                    case 63:
                        taskvec = new Vector();
                        issueId = request.getParameter("issueId");
                        taskID = request.getParameter("taskId");
                        String arr = request.getParameter("arr");
                        String total = request.getParameter("total");
                        servedPage = "/docs/issue/tasks_list.jsp";
                        issueTasksMgr = IssueTasksMgr.getInstance();
                        issueTasksMgr.cashData();
                        if (arr.equals(total)) {
                            issueTasksMgr.deleteOnArbitraryKey(taskID, "key2");
                        }
                        try {
                            Vector tasks = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
                            for (int i = 0; i < tasks.size(); i++) {
                                taskWbo = (WebBusinessObject) tasks.elementAt(i);
                                Wbo = taskMgr.getOnSingleKey((taskWbo.getAttribute("codeTask")).toString());
                                taskvec.add(Wbo);
                            }
                            request.setAttribute("data", taskvec);
                        } catch (Exception e) {
                        }
                        request.setAttribute("page", servedPage);
                        request.getSession().setAttribute("issueId", issueId);
                        request.setAttribute("issueId", issueId);
                        this.forwardToServedPage(request, response);
                        break;

                    case 64:
//                        taskvec = new Vector();
                        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
                        DepComp = new Vector();
                        servedPage = "/docs/call_center/Screen.jsp";
                        String page = "";
                        clientType = request.getParameter("clientType");

                        if (clientType.equals("100")) {
                            page = "/docs/call_center/companyOperations.jsp";
                        } else {

                            page = "/docs/call_center/clientProduct.jsp";
                        }
                        clientId = request.getParameter("clientId");
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);
                        boolean isCompany = false;
                        if (wbo != null) {
                            String age = (String) wbo.getAttribute("age");
                            if (age.equals("100")) {
                                page = "/docs/call_center/companyOperations.jsp";
                                isCompany = true;
                            } else {
                            }
                        }

                        Vector clientStatusVec = null;
                        ///////////////////////////////////////////////////////////////////////////////////////////////////
                        clientProduct = new Vector();

                        clientProductMgr = ClientProductMgr.getInstance();
                        try {
                            clientProduct = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
//                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo4 = new WebBusinessObject();
//                        wbo3 = clientMgr.getOnSingleKey(clientId);
                        Vector reservedUnit = new Vector();
                        Vector interestedUnit = new Vector();
                        Vector viewsUnit = new Vector();
                        
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        
                        viewsUnit = clientProductMgr.getViewsUnit(clientId);
                        
                        Vector products = new Vector();
                        Vector mainProducts = new Vector();
                        try {
                            products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                            wbo4 = (WebBusinessObject) products.get(0);
                            mainProducts = projectMgr.getOnArbitraryKey((String) wbo4.getAttribute("projectID"), "key2");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //////////////////Competent employee
                        userClientsMgr = UserClientsMgr.getInstance();

                        CompetentEmp = new Vector();

                        CompetentEmp = userClientsMgr.getCompetentEmp(clientId);
                        if (CompetentEmp != null) {
                            request.setAttribute("CompetentEmp", CompetentEmp);
                        } else {
                            request.setAttribute("CompetentEmp", null);
                        }

                        /////////////////////////////////////////////////////////////////////////////////////////////////////
//                        if (wbo != null) {
//                            try {
//
//                                ClientStatusMgr clientStatusMgr = ClientStatusMgr.getInstance();
//                                clientStatusVec = clientStatusMgr
//                                        .getOnArbitraryKey(
//                                        clientId, "key2");
//                            } catch (SQLException ex) {
//                                Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
//                            } catch (Exception ex) {
//                                Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
//                            }
//
//                            /**
//                             * ****Create Dynamic contenet of Issue menu ******
//                             */
//                            //open Jar File
//                            metaMgr.setMetaData("xfile.jar");
//                            Vector clientMenu = new Vector();
//                            String mode = (String) request.getSession().getAttribute("currentMode");
//
//                            if (!clientStatusVec.isEmpty()) {
//                                clientMenu = parseSideMenu.parseSideMenu(mode, "client_menu.xml", "");
//
//                            } else {
//                                clientMenu = parseSideMenu.parseSideMenu(mode, "new_client_menu.xml", "");
//
//                            }
//
//
//                            metaMgr.closeDataSource();
//
//                            /* Add ids for links*/
//                            Vector linkVec = new Vector();
//                            String link = "";
//                            String title = request.getParameter("title");
//                            Hashtable style = new Hashtable();
//                            style = (Hashtable) clientMenu.get(0);
//                            title = style.get("title").toString();
//                            title += "<br>" + wbo.getAttribute("name").toString();
//                            style.remove("title");
//                            style.put("title", title);
//
//                            for (int i = 1; i < clientMenu.size() - 1; i++) {
//                                linkVec = new Vector();
//                                link = "";
//                                linkVec = (Vector) clientMenu.get(i);
//                                link = (String) linkVec.get(1);
//
//                                link += clientId;
//
//                                linkVec.remove(1);
//                                linkVec.add(link);
//                            }
//
//                            request.getSession().setAttribute("sideMenuVec", clientMenu);
//
//
//                        }
                        DepComp = projectMgr.getAllCompDeaprtments("cmp");

                        //check logged user belong to customer service or not if belong enable service or not
                        WebBusinessObject webBusinessObject = new WebBusinessObject();
                        String customerServiceId = metaMgr.getCustomerServiceID();

                        String enableServic = null;
                        if (customerServiceId != null && !customerServiceId.isEmpty()) {
                            String[] customerServiceArr = customerServiceId.split(",");
                            if (customerServiceArr != null && customerServiceArr.length > 0) {
                                // to get user department
//                                UserMgr userMgr = UserMgr.getInstance();
                                WebBusinessObject managerWbo = userMgr.getManagerByEmployeeID(securityUser.getUserId());
                                String departmentID = "";
//                                ProjectMgr projectMgr = ProjectMgr.getInstance();
                                if (managerWbo != null) {
                                    departmentID = (String) managerWbo.getAttribute("fullName");
                                    ArrayList<WebBusinessObject> departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
                                    if (departmentList.size() > 0) {
                                        departmentID = (String) departmentList.get(0).getAttribute("projectID");
                                    }
                                } else {
                                    ArrayList<WebBusinessObject> departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(securityUser.getUserId(), "key5"));
                                    if (departmentList.size() > 0) {
                                        departmentID = (String) departmentList.get(0).getAttribute("projectID");
                                    }
                                }
                                if ((new ArrayList<String>(Arrays.asList(customerServiceArr))).contains(departmentID)) {
                                    enableServic = "enable";
                                }
                                //
                            }
                        }
//                        webBusinessObject = projectMgr.getOnSingleKey(customerServiceId);
//                        if (webBusinessObject != null) {
//                            String managerId = (String) webBusinessObject.getAttribute("optionOne");
//                            EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
//
//                            Vector<WebBusinessObject> employees = new Vector();
//                            employees = empRelationMgr.getOnArbitraryKey(managerId, "key1");
//                            String loggedUser = (String) waUser.getAttribute("userId");
//                            webBusinessObject = new WebBusinessObject();
//                            if (employees != null & !employees.isEmpty()) {
//                                for (WebBusinessObject wbo2 : employees) {
//                                    String user_id = (String) wbo2.getAttribute("empId");
//                                    if (user_id.equals(loggedUser) || managerId.equals(loggedUser)) {
//                                        enableServic = "enable";
//                                    }
//                                }
//                            }
//                        }

                        Vector<WebBusinessObject> vecTemp = projectMgr.getOnArbitraryDoubleKeyOracle("0", "key2", "cmplnt", "key6");
                        if (vecTemp.size() > 0) {
                            WebBusinessObject wboComplaint = (WebBusinessObject) vecTemp.get(0);
                            request.setAttribute("complaintsList", new ArrayList(projectMgr.getOnArbitraryKeyOracle("cmplnt", "key6")));
                        }

                        vecTemp = projectMgr.getOnArbitraryDoubleKeyOracle("0", "key2", "rqst", "key6");
                        if (vecTemp.size() > 0) {
                            WebBusinessObject wboRequest = (WebBusinessObject) vecTemp.get(0);
                            request.setAttribute("requestsList", new ArrayList(projectMgr.getOnArbitraryKeyOracle("rqst", "key6")));
                        }

                        vecTemp = projectMgr.getOnArbitraryDoubleKeyOracle("0", "key2", "nqry", "key6");
                        if (vecTemp.size() > 0) {
                            WebBusinessObject wboInquiry = (WebBusinessObject) vecTemp.get(0);
                            request.setAttribute("inquiriesList", new ArrayList(projectMgr.getOnArbitraryKeyOracle("nqry", "key6")));
                        }

                        vecTemp = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        ArrayList<WebBusinessObject> categories = new ArrayList<WebBusinessObject>();
                        if (vecTemp.size() > 0) {
                            for (WebBusinessObject wboProduct : vecTemp) {
                                WebBusinessObject wboTemp = new WebBusinessObject();
                                if (!"interested".equals(wboProduct.getAttribute("productId"))) {
                                    wboTemp.setAttribute("projectID", wboProduct.getAttribute("projectId"));
                                    wboTemp.setAttribute("projectName", wboProduct.getAttribute("productName"));
                                } else {
                                    wboTemp.setAttribute("projectID", wboProduct.getAttribute("productCategoryId"));
                                    wboTemp.setAttribute("projectName", wboProduct.getAttribute("productCategoryName"));
                                }
                                categories.add(wboTemp);
                            }
                        } else {
                            categories = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key6"));
                        }
                        //
                        try {
                            ArrayList<WebBusinessObject> paymentPlace = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("1365240752318", "key2"));
                            request.setAttribute("paymentPlace", paymentPlace);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //
                        request.setAttribute("categories", categories);
                        request.setAttribute("inquiryCategories", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("44", "key6")));

                        request.setAttribute("data", mainProducts);

                        request.setAttribute("products", interestedUnit);
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("viewsUnit", viewsUnit);
                        request.setAttribute("purcheUnits", new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle("purche", "key4", clientId, "key1")));
                        request.setAttribute("page", servedPage);
                        request.setAttribute("includePage", page);
                        request.setAttribute("client", wbo);
                        request.setAttribute("DepComp", DepComp);
                        request.setAttribute("enableServic", enableServic);
                        String pageType = request.getParameter("pageType");
                        if (pageType != null && pageType.equals("clientDetailes")) {
                            this.forward("/ClientServlet?op=clientDetails&clientId=" + clientId, request, response);
                        } else {
                            this.forwardToServedPage(request, response);
                        }
                        break;

                    case 65:

                        out = response.getWriter();
                        servedPage = "/docs/call_center/Screen.jsp";
                        clientId = request.getParameter("clientId");
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);

                        request.setAttribute("page", servedPage);
                        request.setAttribute("client", wbo);

                        String type = request.getParameter("type");
                        request.setAttribute("type", type);

//                        request.setAttribute("clientNO",  wbo.getAttribute("clientNO").toString());
                        String call_status = request.getParameter("call_status");
                        request.setAttribute("call_status", call_status);

                        String comments = request.getParameter("comments");
                        request.setAttribute("comments", comments);

                        String note = request.getParameter("note");
                        request.setAttribute("note", note);

                        issueMgr = IssueMgr.getInstance();
//                        ClientComplaintsMgr clientComplaintsMgr= ClientComplaintsMgr.getInstance();

//                        issueMgr.saveCallData(request,session);
                        request.setAttribute("issueId", request.getAttribute("issueId"));
                        request.getSession().setAttribute("issueId", (String) request.getAttribute("issueId"));
                        String issId = null;
                        issId = issueMgr.saveCallData(request, session, "issue");
                        if (issId != null && !issId.equals("")) {
                            wbo.setAttribute("status", "success");
                            issueWbo = issueMgr.getOnSingleKey(issId);
                            request.getSession().setAttribute("issueId", issId);
                            request.setAttribute("issueWbo", issueWbo);

                            wbo.setAttribute("businessID", (String) issueWbo.getAttribute("businessID"));
                            wbo.setAttribute("businessIDbyDate", (String) issueWbo.getAttribute("businessIDbyDate"));
                            wbo.setAttribute("issueId", issId);

                        } else {
                            wbo.setAttribute("status", "fail");

                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 66:
                        clientId = request.getParameter("clientID");
                        servedPage = "/docs/call_center/newCmp.jsp";
                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.getSession().setAttribute("clientID", clientId);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("DepComp", DepComp);
                        this.forwardToServedPage(request, response);
                        break;

                    case 67:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        String userId = request.getParameter("userId");
                        String claim_content = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        String subject = (String) request.getParameter("subject");
                        String ticketType = (String) request.getParameter("ticketType");
                        String orderUrgency = (String) request.getParameter("orderUrgency");
                        if (request.getSession().getAttribute("issueId") != null) {
                            request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                        } else {
                            request.setAttribute("issueId", "UL");
                        }
                        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey((String) request.getAttribute("issueId"));
                        if (issueWbo != null) {
                            ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                            StringBuilder subjectBuilder = new StringBuilder();
                            for (WebBusinessObject unitWbo : unitsList) {
                                subjectBuilder.append(" ").append(unitWbo.getAttribute("projectName")).append("\n");
                            }
                            if (subjectBuilder.length() > 0) {
                                subject += subjectBuilder.toString();
                            }
                        }
                        request.setAttribute("userId", userId);
                        request.setAttribute("comment", claim_content);
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("subject", subject);
                        request.setAttribute("ticketType", ticketType);
                        request.setAttribute("orderUrgency", orderUrgency);
                        request.setAttribute("category", request.getParameter("category"));
                        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        String clientCompId = clientComplaintsMgr.saveClientComplaint2(request, localPersistentUser);
                        if (clientCompId != null) {
                            wbo.setAttribute("status", "Ok");
                            wbo.setAttribute("clientCompId", clientCompId);

                        } else {
                            wbo.setAttribute("status", "No");

                        }
                        clientComplaintsMgr.updateClientComplaintsType();
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 68:
                        if (request.getParameter("del") != null && request.getParameter("del").equals("1")) {
                            String clientPrjID = request.getParameter("id");
                            String res = request.getParameter("res");
                            String issue = request.getParameter("issue");

                            WebBusinessObject clientProductWbo = clientProductMgr.getOnSingleKey(clientPrjID);
                            wbo = new WebBusinessObject();
                            WebBusinessObject loggerWbo = new WebBusinessObject();
                            LoggerMgr loggerMgr = LoggerMgr.getInstance();
                            if (clientProductMgr.deleteProduct(clientPrjID, res, issue)) {
                                securityUser = (SecurityUser) session.getAttribute("securityUser");
                                //For logging Client Insertion
                                loggerWbo = new WebBusinessObject();
                                loggerWbo.setAttribute("objectXml", clientProductWbo.getObjectAsXML());
                                loggerWbo.setAttribute("realObjectId", clientPrjID);
                                loggerWbo.setAttribute("userId", (String) loggedUser.getAttribute("userId"));
                                loggerWbo.setAttribute("objectName", clientPrjID);
                                loggerWbo.setAttribute("loggerMessage", "Delete Client Units");
                                loggerWbo.setAttribute("eventName", "Delete Client Units");
                                loggerWbo.setAttribute("objectTypeId", "8");
                                loggerWbo.setAttribute("eventTypeId", "8");
                                loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                                loggerMgr.saveObject(loggerWbo);
                                wbo.setAttribute("status", "Ok");
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                            out = response.getWriter();
                            out.write(Tools.getJSONObjectAsString(wbo));
                        }

                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        servedPage = "/docs/call_center/viewComp.jsp";

                        page = "";
                        clientType = request.getParameter("clientType");
                        if (clientType.equals("100")) {
                            page = "/docs/call_center/companyOperations.jsp";
                        } else {
                            page = "/docs/call_center/clientProduct.jsp";
                        }
                        DepComp = new Vector();
                        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        WebBusinessObject wboIssueCompl = new WebBusinessObject();

                        issueStatusMgr = IssueStatusMgr.getInstance();
                        HttpSession s = request.getSession();

                        Vector issueCompV = new Vector();
                        issueId = (String) request.getParameter("issueId");
                        String compId = (String) request.getParameter("compId");
                        String notes = "is acknowledge";
                        String statusCode = "";
                        String object_type = "client_complaint";

                        issueCompV = IssueByComplaintUniqueMgr.getInstance().getOnArbitraryKey(compId, "key4");

//                        EmployeeViewMgr employeeViewMgr=EmployeeViewMgr.getInstance();
//                        issueCompV = employeeViewMgr.getOnArbitraryKey(compId, "key4");
//                        issueCompV = issueByComplaintMgr.getOnArbitraryKey(issueId ,"key1");
//                        boolean isAknowledeg = false;

                        //message open or not 
//                        BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
//                        wbo = new WebBusinessObject();
//                        wbo = bookmarkMgr.getOnSingleKey("key1", compId);
//                        if (wbo != null) {
//                        } else {
//                            wbo = new WebBusinessObject();
//                            wbo.setAttribute("compId", compId);
//                            wbo.setAttribute("note", "open");
//                            bookmarkMgr.saveBookmark(wbo, session);
//                        }
//                        wbo = new WebBusinessObject();
                        // start employee open this ticket
                        userId = (String) localPersistentUser.getAttribute("userId");
                        WebBusinessObject userWbo = new WebBusinessObject();
                        userMgr = UserMgr.getInstance();
                        userWbo = userMgr.getOnSingleKey(userId);
//                        // change status to acknowledeg if status equal 4
//                        if (userWbo != null) {
//                            String isAdmin = (String) userWbo.getAttribute("userType");
//                            if (isAdmin.equals("0")) {
//                                for (int i = 0; i < issueCompV.size(); i++) {
//                                    wboIssueCompl = (WebBusinessObject) issueCompV.get(i);
//                                    if (wboIssueCompl != null) {
//                                        statusCode = (String) wboIssueCompl.getAttribute("statusCode");
//                                        if (!statusCode.equals("4")) {
//                                            isAknowledeg = true;
//                                        }
//                                    }
//                                }
//                                if (!isAknowledeg) {
//
//                                    wbo = new WebBusinessObject();
//
//                                    wbo.setAttribute("parentId", issueId);
//                                    wbo.setAttribute("businessObjectId", compId);
//                                    statusCode = "3";
//                                    wbo.setAttribute("statusCode", statusCode);
//                                    wbo.setAttribute("objectType", object_type);
//                                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
//                                    wbo.setAttribute("issueTitle", "UL");
//                                    wbo.setAttribute("statusNote", "UL");
//                                    wbo.setAttribute("cuseDescription", "UL");
//                                    wbo.setAttribute("actionTaken", "UL");
//                                    wbo.setAttribute("preventionTaken", "UL");
//
//                                    try {
//                                        issueStatusMgr = IssueStatusMgr.getInstance();
//                                        issueStatusMgr.changeStatus(wbo, localPersistentUser, ActionEvent.getClientComplaintsActionEvent());
//
//                                    } catch (SQLException ex) {
//                                        logger.error(ex);
//                                    }
//                                }
//                            }
//                        }
//                        //end
                        wboIssueCompl = (WebBusinessObject) issueCompV.get(0);
                        String senderId = request.getParameter("senderID");
                        String receipId = request.getParameter("receipId");
                        String optionOne = (String) wboIssueCompl.getAttribute("optionOne");

//                        String clientComId = (String) wboIssueCompl.getAttribute("clientComId");
                        DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
                        WebBusinessObject receipWbo = new WebBusinessObject();
                        receipWbo = distributionListMgr.getLastOwnerForComp(compId);
                        String receip_Id = "";
                        String receipName = "";
                        if (receipWbo != null) {
                            receip_Id = (String) receipWbo.getAttribute("receipId");
                        }
                        if (receip_Id != null) {
                            receipWbo = new WebBusinessObject();
                            receipWbo = userMgr.getOnSingleKey(receip_Id);

                            receipName = (String) receipWbo.getAttribute("fullName");
                        }

                        userMgr = UserMgr.getInstance();
                        WebBusinessObject statusWbo = new WebBusinessObject();
                        String managerName = "";
                        String managerId = "";
                        WebBusinessObject manager = projectMgr.getManagerByEmployee(receip_Id);
                        boolean isManager = projectMgr.isManager(userId);
                        if (manager != null) {
                            managerId = (String) manager.getAttribute("optionOne");
                            managerName = userMgr.getByKeyColumnValue(managerId, "key3");
                        } else if (isManager) {
                            managerId = userId;
                            managerName = userMgr.getByKeyColumnValue(userId, "key3");
                        }

                        statusCode = request.getParameter("statusCode");

                        WebBusinessObject senderWbo = new WebBusinessObject();

                        senderWbo = userMgr.getOnSingleKey(senderId);
                        String senderName = "";

                        String complaintId = (String) wboIssueCompl.getAttribute("departmentId");
                        String departmentId = (String) wboIssueCompl.getAttribute("departmentId");

                        clientId = (String) wboIssueCompl.getAttribute("customerId");

                        request.setAttribute("clientId", clientId);
                        ////////////////////////////case 64
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);
                        clientProduct = new Vector();

                        clientProductMgr = ClientProductMgr.getInstance();
                        try {
                            clientProduct = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
//                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo4 = new WebBusinessObject();
//                        wbo3 = clientMgr.getOnSingleKey(clientId);
                        reservedUnit = new Vector();
                        interestedUnit = new Vector();
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        viewsUnit = clientProductMgr.getViewsUnit(clientId);
                        products = new Vector();
                        mainProducts = new Vector();
                        try {
                            mainProducts = projectMgr.getOnArbitraryKey("44", "key4");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //////////////////Competent employee
                        userClientsMgr = UserClientsMgr.getInstance();

                        CompetentEmp = new Vector();

                        CompetentEmp = userClientsMgr.getOnArbitraryKey(clientId, "key2");
                        if (CompetentEmp != null) {
                            request.setAttribute("CompetentEmp", CompetentEmp);
                        } else {
                            request.setAttribute("CompetentEmp", null);
                        }
                        //////////////////////

                        WebBusinessObject wbo__ = new WebBusinessObject();
                        String mgrId = "";
                        EmpRelationMgr employeeMgr = EmpRelationMgr.getInstance();
                        wbo__ = projectMgr.getOnSingleKey(departmentId);
                        if (wbo__ != null) {
                            mgrId = (String) wbo__.getAttribute("optionOne");
                        }
                        Vector employee = employeeMgr.getOnArbitraryKey(mgrId, "key1");
                        List<WebBusinessObject> employees = new ArrayList<WebBusinessObject>();

                        if (employee.size() > 0) {

                            String userName = null;
                            wbo__ = new WebBusinessObject();
                            String projectName = null;
                            for (int q = 0; q < employee.size(); q++) {
                                wbo__ = new WebBusinessObject();
                                WebBusinessObject wbo2 = new WebBusinessObject();
                                wbo__ = (WebBusinessObject) employee.get(q);

                                userId = (String) wbo__.getAttribute("empId");
                                UserMgr userMgr = UserMgr.getInstance();

                                if (userId.length() > 0) {
                                    wbo__ = new WebBusinessObject();
                                    wbo__ = userMgr.getOnSingleKey(userId);
                                    if (wbo__ != null) {
                                        userName = (String) wbo__.getAttribute("userName");
                                        wbo2.setAttribute("userId", userId);
                                        wbo2.setAttribute("userName", userName);
                                        employees.add(wbo2);
                                    }
                                }

                            }
                        }

                        List listOfAllEmployees = userMgr.getUserList();
                        ////////////////////

                        //
                        try {
                            ArrayList<WebBusinessObject> paymentPlace = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("1365240752318", "key2"));
                            request.setAttribute("paymentPlace", paymentPlace);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //

                        // Get issue owner and manager
                        userId = (String) localPersistentUser.getAttribute("userId");
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        String issueOwnerID = (String) distributionListMgr.getLastOwnerForComp(compId).getAttribute("receipId");
                        WebBusinessObject empManagerWbo = issueOwnerID != null ? empRelationMgr.getOnSingleKey(issueOwnerID, "key2") : new WebBusinessObject();
                        String ownerManagerID = empManagerWbo != null ? (String) empManagerWbo.getAttribute("mgrId") : "";
                        if (ownerManagerID == null || ownerManagerID.isEmpty()) {
                            if (projectMgr.getOnArbitraryKeyOracle(userId, "key5").size() > 0) {
                                ownerManagerID = userId;
                            }
                        }
                        //

                        //For Close And Finish Actions
                        ArrayList<WebBusinessObject> actionsList = new ArrayList<WebBusinessObject>();
                        WebBusinessObject departmentInfo = projectMgr.getManagerByEmployee((String) localPersistentUser.getAttribute("userId"));
                        if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
                            managerId = (String) departmentInfo.getAttribute("optionOne");
                            departmentInfo = projectMgr.getOnSingleKey("key5", managerId);
                            departmentId = (String) departmentInfo.getAttribute("projectID");
                            actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
                        } else { // May be he is a manager
                            departmentInfo = projectMgr.getOnSingleKey("key5", (String) localPersistentUser.getAttribute("userId"));
                            if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
                                departmentId = (String) departmentInfo.getAttribute("projectID");
                                actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
                            }
                        }
                        request.setAttribute("actionsList", actionsList);
//                        ClosureConfigurationMgr closureConfigurationMgr = ClosureConfigurationMgr.getCurrentInstance();
//                        request.setAttribute("closureActionsList", closureConfigurationMgr.getClosureActionsList());
                        userClosureConfigMgr = ClosureConfigMgr.getInstance();
                        userClosureList = userClosureConfigMgr.getClosuresByUser(localPersistentUser.getAttribute("userId").toString());
                        request.setAttribute("closureActionsList", userClosureList);
                        //
                        departmentId = "";
                        ArrayList<WebBusinessObject> departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(userId, "key5"));
                        if (!departmentList.isEmpty()) {
                            departmentId = (String) departmentList.get(0).getAttribute("projectID");
                        }
                        List<WebBusinessObject> employeeList = userMgr.getEmployeeByDepartmentId(departmentId, null, null);
                        for (int i = employeeList.size() - 1; i >= 0; i--) {
                            if (employeeList.get(i).getAttribute("userId").equals(ownerManagerID)) {
                                employeeList.remove(i);
                            }
                        }
                        employeeList.addAll(userMgr.getAllUpperManagers());
//                        for (int i = employeeList.size() - 1; i >= 0; i--) {
//                            WebBusinessObject wboEmployee = employeeList.get(i);
//                            if (userId.equals(wboEmployee.getAttribute("userId"))) {
//                                employeeList.remove(i);
//                            }
//                        }

                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.setAttribute("data", mainProducts);

                        request.setAttribute("products", interestedUnit);
                        request.setAttribute("viewsUnit", viewsUnit);
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("includePage", page);
                        request.setAttribute("client", wbo);
                        request.setAttribute("DepComp", DepComp);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("compId", compId);
                        request.setAttribute("senderName", senderName);
                        request.setAttribute("receipID", receip_Id);
                        request.setAttribute("receipName", receipName);
                        request.setAttribute("managerId", managerId);
                        request.setAttribute("managerName", managerName);
                        request.setAttribute("statusCode", statusCode);
                        request.setAttribute("allEmployees", listOfAllEmployees);
                        request.setAttribute("userUnderManager", employeeList);
                        request.setAttribute("complaintId", complaintId);
                        request.setAttribute("employeesx", employees);
                        request.setAttribute("mgrId", mgrId);
                        request.setAttribute("purcheUnits", new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle("purche", "key4", clientId, "key1")));
                        request.setAttribute("isOwner", issueOwnerID != null && issueOwnerID.equals(userId));
                        request.setAttribute("isOwnerManager", ownerManagerID != null && ownerManagerID.equals(userId));
                        request.setAttribute("dependOnIssuesList", issueMgr.getAllIssuesDepOnIssue(issueId));

                        this.forwardToServedPage(request, response);

                        break;

                    case 69:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        userId = request.getParameter("userId");
                        claim_content = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        subject = (String) request.getParameter("subject");
                        orderUrgency = (String) request.getParameter("orderUrgency");
                        if (request.getSession().getAttribute("issueId") != null) {
                            request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                        } else {
                            request.setAttribute("issueId", "UL");
                        }
                        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey((String) request.getAttribute("issueId"));
                        if (issueWbo != null) {
                            ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                            StringBuilder subjectBuilder = new StringBuilder();
                            for (WebBusinessObject unitWbo : unitsList) {
                                subjectBuilder.append(" ").append(unitWbo.getAttribute("projectName")).append("\n");
                            }
                            if (subjectBuilder.length() > 0) {
                                subject += subjectBuilder.toString();
                            }
                        }
                        request.setAttribute("userId", userId);
                        request.setAttribute("comment", claim_content);
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("subject", subject);
                        request.setAttribute("orderUrgency", orderUrgency);
                        request.setAttribute("category", request.getParameter("category"));
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();

                        if (clientComplaintsMgr.saveClientOrder(request, localPersistentUser)) {
                            wbo.setAttribute("status", "Ok");
                            // Forward to manager of finance department if request is receipt report
                            if (subject.equalsIgnoreCase(CRMConstants.FINANCE_REQUEST_TITLE)) {
                                WebBusinessObject financeDepartmentWbo = projectMgr.getOnSingleKey(CRMConstants.DEPARTMENT_FINANCES_ID);
                                if (financeDepartmentWbo != null && financeDepartmentWbo.getAttribute("optionOne") != null) {
                                    manager = userMgr.getOnSingleKey((String) financeDepartmentWbo.getAttribute("optionOne"));
                                    if (manager != null) {
                                        clientComplaintsMgr.createNotificationComplaint((String) request.getAttribute("clientCompId"),
                                                loggegUserId, (String) manager.getAttribute("userId"), subject, subject);
                                    }
                                }
                            }

                        } else {
                            wbo.setAttribute("status", "No");

                        }
                        clientComplaintsMgr.updateClientComplaintsType();
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 70:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        userId = request.getParameter("userId");
                        claim_content = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        subject = (String) request.getParameter("subject");
                        ticketType = (String) request.getParameter("ticketType");
                        if (request.getSession().getAttribute("issueId") != null) {
                            request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                        } else {
                            request.setAttribute("issueId", "UL");
                        }
                        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey((String) request.getAttribute("issueId"));
                        if (issueWbo != null) {
                            ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                            StringBuilder subjectBuilder = new StringBuilder();
                            for (WebBusinessObject unitWbo : unitsList) {
                                subjectBuilder.append(" ").append(unitWbo.getAttribute("projectName")).append("\n");
                            }
                            if (subjectBuilder.length() > 0) {
                                subject += subjectBuilder.toString();
                            }
                        }
                        request.setAttribute("userId", userId);
                        request.setAttribute("comment", claim_content);
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("subject", subject);
                        request.setAttribute("ticketType", ticketType);
                        request.setAttribute("category", request.getParameter("category"));
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();

                        if (clientComplaintsMgr.saveClientQuery(request, localPersistentUser)) {
                            wbo.setAttribute("status", "Ok");

                        } else {
                            wbo.setAttribute("status", "No");

                        }
                        clientComplaintsMgr.updateClientComplaintsType();
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 71:

                        //                        servedPage = "/docs/call_center/recordCall.jsp";
                        clientId = (String) request.getParameter("clientId");

                        out = response.getWriter();

                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);

//                        request.setAttribute("page", servedPage);
                        request.setAttribute("client", wbo);

                        String type_ = request.getParameter("type");
                        request.setAttribute("type", type_);

//                        request.setAttribute("clientNO",  wbo.getAttribute("clientNO").toString());
                        String call_status_ = request.getParameter("call_status");
                        request.setAttribute("call_status", call_status_);
                        String entryDate_ = request.getParameter("entryDate");
                        request.setAttribute("entryDate", entryDate_);

                        String comments_ = request.getParameter("comments");
                        request.setAttribute("comments", comments_);

                        String note_ = request.getParameter("note");
                        request.setAttribute("note", note_);

                        issueMgr = IssueMgr.getInstance();
//                        ClientComplaintsMgr clientComplaintsMgr= ClientComplaintsMgr.getInstance();

                        // issueMgr.saveCallData(request,session);
                        request.setAttribute("issueId", request.getAttribute("issueId"));
                        request.getSession().setAttribute("issueId", (String) request.getAttribute("issueId"));
                        String issId_ = null;
                        issId_ = issueMgr.saveCallData(request, session, "issue");
                        wbo = new WebBusinessObject();
                        if (issId_ != null && !issId_.equals("")) {

                            wbo.setAttribute("result", "success");
                            issueWbo = issueMgr.getOnSingleKey(issId_);
                            wbo.setAttribute("issueId", issId_);
                            wbo.setAttribute("businessId", issueWbo.getAttribute("businessID"));
//                            wbo.setAttribute("Status", "ok");
                        } else {
                            wbo.setAttribute("result", "fail");

                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 73:
//                        DepComp = new Vector();
//                        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
//                        WebBusinessObject wboIssueCompl = new WebBusinessObject();
//                        Vector issueCompV = new Vector();
//                        String issuCompId = (String) request.getParameter("issueId");
//                        String clientCompId = (String) request.getParameter("compId");
//                        issueCompV = issueByComplaintMgr.getOnArbitraryKey(issuCompId, "key1");
//                        wboIssueCompl = (WebBusinessObject) issueCompV.get(0);
//
//
//
//                        String complaintId = (String) wboIssueCompl.getAttribute("departmentId");
                        clientId = (String) request.getParameter("clientId");
                        Vector products_ = new Vector();
                        ClientProductMgr clientProductMgr_ = ClientProductMgr.getInstance();
                        products_ = clientProductMgr_.getOnArbitraryKey(clientId, "key1");
                        servedPage = "/docs/call_center/clientOperation.jsp";

//                        Vector products = new Vector();
//                        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
//                        products = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);

//                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.setAttribute("products", products_);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("client", wbo);
                        request.setAttribute("clientId", clientId);
//                        request.setAttribute("DepComp", DepComp);
//                        request.setAttribute("issueId", issuCompId);
//                        request.setAttribute("compId", clientCompId);
//                        request.setAttribute("complaintId", complaintId);
                        this.forwardToServedPage(request, response);
                        break;
                    case 74:
                        servedPage = "/docs/call_center/clientProduct.jsp";
                        issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        WebBusinessObject clientByUnitId = new WebBusinessObject();
                        clientProduct = new Vector();
                        String unitId = (String) request.getParameter("proId");
                        clientProductMgr = ClientProductMgr.getInstance();

                        clientByUnitId = clientProductMgr.getOnSingleKey("key2", unitId);
                        clientId = (String) clientByUnitId.getAttribute("clientId");
//                        clientProduct = clientProductMgr.getOnArbitraryKey(clientId, "key1");

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);
                        reservedUnit = new Vector();
                        interestedUnit = new Vector();
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);

                        WebBusinessObject wbo2 = new WebBusinessObject();
                        products = new Vector();
                        mainProducts = new Vector();
                        try {
//                    projects1 = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                            request.setAttribute("page", servedPage);
                            products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                            wbo2 = (WebBusinessObject) products.get(0);
                            mainProducts = projectMgr.getOnArbitraryKey((String) wbo2.getAttribute("projectID"), "key2");
                            request.setAttribute("data", mainProducts);
                        } catch (Exception ex) {
                            Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        request.setAttribute("products", interestedUnit);
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("client", wbo);
                        this.forwardToServedPage(request, response);
                        break;
                    case 75:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        WebBusinessObject data = new WebBusinessObject();
                        userId = request.getParameter("userId");
                        empRelationMgr = EmpRelationMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = empRelationMgr.getOnSingleKey("key2", userId);
                        if (wbo != null) {
                            managerId = (String) wbo.getAttribute("mgrId");
                            claim_content = request.getParameter("comment");
                            clientId = (String) request.getParameter("clientId");
                            subject = (String) request.getParameter("subject");
                            ticketType = (String) request.getParameter("ticketType");
                            if (request.getSession().getAttribute("issueId") != null) {
                                request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                            } else {
                                request.setAttribute("issueId", "UL");
                            }
                            request.setAttribute("managerId", managerId);
                            request.setAttribute("comment", claim_content);
                            request.setAttribute("clientId", clientId);
                            request.setAttribute("subject", subject);
                            request.setAttribute("ticketType", ticketType);
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();

                            data = clientComplaintsMgr.saveClientComplaint3(request, localPersistentUser);
                            Thread.sleep(300);
                            if (data != null) {
                                issueId = (String) data.getAttribute("issueId");
                                compId = (String) data.getAttribute("compId");

                                ClientComplaintsMgr clientComplaintsMgr2 = ClientComplaintsMgr.getInstance();

                                wbo = (WebBusinessObject) clientComplaintsMgr2.getOnSingleKey(compId);
                                wbo.setAttribute("managerId", managerId);
                                wbo.setAttribute("clientCompId", compId);
                                wbo.setAttribute("employeeId", userId);
                                wbo.setAttribute("complaintComment", claim_content);
                                wbo.setAttribute("compSubject", subject);
                                String responsability = "1";

                                try {

                                    if (clientComplaintsMgr2.distibutionResponsibility3(userId, responsability, wbo, request, session)) {

                                        wbo.setAttribute("status", "Ok");
                                    }
                                } catch (NoUserInSessionException ex) {
                                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                } catch (SQLException ex) {
                                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }

                            } else {
                                wbo.setAttribute("status", "No");

                            }
                        } else {
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("status", "noManager");

                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 76:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        complaintId = request.getParameter("compId");
                        note = request.getParameter("note");

                        wbo.setAttribute("compId", complaintId);
                        wbo.setAttribute("note", note);
                        wbo.setAttribute("type", request.getParameter("type") != null ? request.getParameter("type") : "bookmark");

                        bookmarkMgr = BookmarkMgr.getInstance();
                        String bookmarkId = bookmarkMgr.saveBookmark(wbo, session);
                        if (bookmarkId != null) {

                            wbo.setAttribute("status", "ok");
                            wbo.setAttribute("bookmarkId", bookmarkId);

                        } else {
                            wbo.setAttribute("status", "no");

                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 77:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        bookmarkId = request.getParameter("bookmarkId");
                        bookmarkMgr = BookmarkMgr.getInstance();
                        if (bookmarkMgr.deleteBookmark(bookmarkId)) {

                            wbo.setAttribute("status", "ok");

                        } else {
                            wbo.setAttribute("status", "no");

                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 78:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
                        WebBusinessObject result = new WebBusinessObject();
                        out = response.getWriter();
                        String businessId = request.getParameter("businessId");
                        comments = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        subject = (String) request.getParameter("subject");
                        ticketType = (String) request.getParameter("ticketType");
                        issueId = (String) request.getSession().getAttribute("issueId");
                        notes = "this complaint answered by call center user " + securityUser.getFullName();

                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        String clientComplaintId = clientComplaintsMgr.createMailInBox((String) localPersistentUser.getAttribute("userId"), issueId, ticketType, businessId, comments, subject, notes, localPersistentUser);

                        if (clientComplaintId != null) {
                            notes = "this complaint finish by call center user " + securityUser.getFullName();
                            object_type = "client_complaint";
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("parentId", issueId);
                            wbo.setAttribute("businessObjectId", clientComplaintId);
                            wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
                            wbo.setAttribute("objectType", object_type);
                            wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                            wbo.setAttribute("notes", notes);
                            wbo.setAttribute("issueTitle", "UL");
                            wbo.setAttribute("statusNote", "UL");
                            wbo.setAttribute("cuseDescription", "UL");
                            wbo.setAttribute("actionTaken", "UL");
                            wbo.setAttribute("preventionTaken", "UL");

                            issueStatusMgr = IssueStatusMgr.getInstance();
                            if (issueStatusMgr.changeStatus(wbo, localPersistentUser, ClientComplaintsActionEvent.getClientComplaintsActionEvent())) {
                                result.setAttribute("status", "Ok");
                            } else {
                                result.setAttribute("status", "failStatus");
                            }
                        } else {
                            result.setAttribute("status", "No");
                        }

                        out.write(Tools.getJSONObjectAsString(result));
                        break;
                    case 79:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        BusinessEventMgr businessEventMgr = BusinessEventMgr.getInstance();
                        wbo = new WebBusinessObject();
                        if (businessEventMgr.redirectComplaint(request, session)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "error");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 80:
                        String departmentManagerId = request.getParameter("departmentId");
                        WebBusinessObject department = new WebBusinessObject();

                        WebBusinessObject da = new WebBusinessObject();
                        String responseText = "";
                        employees = new Vector();

                        employeeMgr = EmpRelationMgr.getInstance();
                        if (departmentManagerId.length() > 0) {
                            try {
                                employees = employeeMgr.getOnArbitraryKey(departmentManagerId, "key1");
                            } catch (SQLException ex) {
                                Logger.getLogger(IssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(IssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                            if (employees.size() > 0) {

                                wbo = new WebBusinessObject();
                                String projectName = null;
                                for (int i = 0; i < employees.size(); i++) {
                                    wbo = new WebBusinessObject();
                                    wbo = (WebBusinessObject) employees.get(i);

                                    userId = (String) wbo.getAttribute("empId");
                                    UserMgr userMgr = UserMgr.getInstance();
                                    String username = null;
                                    if (userId.length() > 0) {
                                        wbo = new WebBusinessObject();
                                        wbo = userMgr.getOnSingleKey(userId);
                                        if (wbo != null) {
                                            username = (String) wbo.getAttribute("userName");
                                        }
                                    }

                                    responseText += userId + "<subelement>" + username;
                                    if (i < employees.size() - 1) {
                                        responseText += "<element>";
                                    }
                                    da.setAttribute("responseText", responseText);
                                }
                            } else {

                                responseText = "empty";
                                da.setAttribute("responseText", responseText);
                            }

                        }

                        out = response.getWriter();
                        out.write(Tools.getJSONObjectAsString(da));
//                        out.write(responseText);
                        break;
                    case 81:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

//                        wbo = empRelationMgr.getOnSingleKey("key2", userId);
//                        if (wbo != null) {
                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        data = new WebBusinessObject();
                        userId = request.getParameter("userId");

//                        wbo = new WebBusinessObject();
//                        wbo = empRelationMgr.getOnSingleKey("key2", userId);
//                        if (wbo != null) {
                        managerId = request.getParameter("mgrId");
                        claim_content = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        subject = (String) request.getParameter("subject");
                        ticketType = (String) request.getParameter("ticketType");
                        orderUrgency = (String) request.getParameter("orderUrgency");
                        if (request.getSession().getAttribute("issueId") != null) {
                            request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                        } else {
                            request.setAttribute("issueId", "UL");
                        }
                        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey((String) request.getAttribute("issueId"));
                        if (issueWbo != null) {
                            ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                            StringBuilder subjectBuilder = new StringBuilder();
                            for (WebBusinessObject unitWbo : unitsList) {
                                subjectBuilder.append(" ").append(unitWbo.getAttribute("projectName")).append("\n");
                            }
                            if (subjectBuilder.length() > 0) {
                                subject += subjectBuilder.toString();
                            }
                        }
                        request.setAttribute("managerId", managerId);
                        request.setAttribute("comment", claim_content);
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("subject", subject);
                        request.setAttribute("ticketType", ticketType);
                        request.setAttribute("orderUrgency", orderUrgency);
                        request.setAttribute("category", request.getParameter("category"));
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();

                        data = clientComplaintsMgr.saveClientComplaint3(request, localPersistentUser);
                        clientComplaintsMgr.updateClientComplaintsType();
                        Thread.sleep(300);
                        if (data != null) {
                            issueId = (String) data.getAttribute("issueId");
                            compId = (String) data.getAttribute("compId");

                            ClientComplaintsMgr clientComplaintsMgr2 = ClientComplaintsMgr.getInstance();

                            wbo = (WebBusinessObject) clientComplaintsMgr2.getOnSingleKey(compId);
                            wbo.setAttribute("managerId", managerId);
                            wbo.setAttribute("clientCompId", compId);
                            wbo.setAttribute("employeeId", userId);
                            wbo.setAttribute("complaintComment", claim_content);
                            wbo.setAttribute("compSubject", subject);
                            String responsability = "1";

                            try {

                                if (clientComplaintsMgr2.distibutionResponsibility3(userId, responsability, wbo, request, session)) {

//                                    // Forward to manager of finance department if request is receipt reportsendOrderTOEmployee
//                                    if (subject.equalsIgnoreCase(CRMConstants.FINANCE_REQUEST_TITLE)) {
//                                        WebBusinessObject financeDepartmentWbo = projectMgr.getOnSingleKey(CRMConstants.DEPARTMENT_FINANCES_ID);
//                                        if (financeDepartmentWbo != null && financeDepartmentWbo.getAttribute("optionOne") != null) {
//                                            manager = userMgr.getOnSingleKey((String) financeDepartmentWbo.getAttribute("optionOne"));
//                                            if (manager != null) {
//                                                clientComplaintsMgr.createNotificationComplaint(compId, loggegUserId, (String) manager.getAttribute("userId"),
//                                                        CRMConstants.FINANCE_REQUEST_TITLE, CRMConstants.FINANCE_REQUEST_TITLE);
//                                            }
//                                        }
//                                    }
                                    wbo.setAttribute("status", "Ok");
                                }
                            } catch (NoUserInSessionException ex) {
                                Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (SQLException ex) {
                                Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                        } else {
                            wbo.setAttribute("status", "No");

                        }
//                        } else {
//                            wbo = new WebBusinessObject();
//                            wbo.setAttribute("status", "noManager");
//
//                        }
                        clientComplaintsMgr.updateClientComplaintsType();
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 82:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        complaintId = request.getParameter("compId");
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        wbo = issueStatusMgr.getClosedMsg(complaintId);
                        if (wbo != null) {
                            String closedMsg = (String) wbo.getAttribute("actionTaken");
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("message", closedMsg.trim());
                            wbo.setAttribute("status", "ok");

                        } else {
                            wbo.setAttribute("status", "no");

                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 83:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        complaintId = request.getParameter("compId");
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        wbo = issueStatusMgr.getFinishedMsg(complaintId);
                        if (wbo != null) {
                            String closedMsg = (String) wbo.getAttribute("actionTaken");
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("message", closedMsg.trim());
                            wbo.setAttribute("status", "ok");

                        } else {
                            wbo.setAttribute("status", "no");

                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 84:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        complaintId = request.getParameter("compId");
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        wbo = issueStatusMgr.getRejectdMsg(complaintId);
                        if (wbo != null) {
                            String closedMsg = (String) wbo.getAttribute("actionTaken");
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("message", closedMsg.trim());
                            wbo.setAttribute("status", "ok");

                        } else {
                            wbo.setAttribute("status", "no");

                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 85:
                        servedPage = "/docs/Search/close_call.jsp";
                        String callId = request.getParameter("callId");
                        issueMgr = IssueMgr.getInstance();
                        issueItemVec = issueMgr.getOnArbitraryKey(callId, "key5");
                        wboIssue = new WebBusinessObject();
                        wboIssue = (WebBusinessObject) issueItemVec.get(0);
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        Vector childs = issueStatusMgr.getClosedChilds(wboIssue.getAttribute("id").toString());
                        wbo = new WebBusinessObject();
                        DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
                        for (int i = 0; i < childs.size(); i++) {
                            wbo = (WebBusinessObject) childs.get(0);
                            String initialMax = wbo.getAttribute("endDate").toString();
                            java.util.Date initialMaxDate = df.parse(initialMax);
                            wbo2 = (WebBusinessObject) childs.get(i);
                            String end_date = (String) wbo2.getAttribute("endDate");
                            java.util.Date max = df.parse(end_date);
                            if (initialMaxDate.compareTo(max) > 0) {
                                max = initialMaxDate;
                            }
                            request.setAttribute("maxDate", max);
                        }
                    case 86:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        servedPage = "/docs/call_center/viewComp2.jsp";

                        page = "";
                        clientType = request.getParameter("clientType");
                        if (clientType.equals("100")) {
                            page = "/docs/call_center/companyOperations.jsp";
                        } else {
                            page = "/docs/call_center/clientProduct.jsp";
                        }
                        DepComp = new Vector();
                        IssueByComplaint2Mgr issueByComplaint2Mgr = IssueByComplaint2Mgr.getInstance();
                        wboIssueCompl = new WebBusinessObject();

                        issueStatusMgr = IssueStatusMgr.getInstance();
                        s = request.getSession();

                        issueCompV = new Vector();
                        issueId = (String) request.getParameter("issueId");
                        compId = (String) request.getParameter("compId");
                        notes = "is acknowledge";
                        statusCode = "";
                        object_type = "client_complaint";
                        issueCompV = IssueByComplaintUniqueMgr.getInstance().getOnArbitraryKey(issueId, "key1");
//                        isAknowledeg = false;
                        // start employee open this ticket

                        userId = (String) localPersistentUser.getAttribute("userId");
                        userWbo = new WebBusinessObject();
                        userMgr = UserMgr.getInstance();
                        userWbo = userMgr.getOnSingleKey(userId);
//                        // change status to acknowledeg if status equal 4
//                        if (userWbo != null) {
//                            String isAdmin = (String) userWbo.getAttribute("userType");
//                            if (isAdmin.equals("0")) {
//                                for (int i = 0; i < issueCompV.size(); i++) {
//                                    wboIssueCompl = (WebBusinessObject) issueCompV.get(i);
//                                    if (wboIssueCompl != null) {
//                                        statusCode = (String) wboIssueCompl.getAttribute("statusCode");
//                                        if (!statusCode.equals("4")) {
//                                            isAknowledeg = true;
//                                        }
//                                    }
//                                }
//                                if (!isAknowledeg) {
//
//                                    wbo = new WebBusinessObject();
//
//                                    wbo.setAttribute("parentId", issueId);
//                                    wbo.setAttribute("businessObjectId", compId);
//                                    statusCode = "3";
//                                    wbo.setAttribute("statusCode", statusCode);
//                                    wbo.setAttribute("objectType", object_type);
//                                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
//                                    wbo.setAttribute("issueTitle", "UL");
//                                    wbo.setAttribute("statusNote", "UL");
//                                    wbo.setAttribute("cuseDescription", "UL");
//                                    wbo.setAttribute("actionTaken", "UL");
//                                    wbo.setAttribute("preventionTaken", "UL");
//
//                                    try {
//                                        issueStatusMgr = IssueStatusMgr.getInstance();
//                                        issueStatusMgr.changeStatus(wbo, localPersistentUser, ActionEvent.getClientComplaintsActionEvent());
//
//                                    } catch (SQLException ex) {
//                                        logger.error(ex);
//                                    }
//                                }
//                            }
//                        }
//                        //end
                        wboIssueCompl = (WebBusinessObject) issueCompV.get(0);
                        senderId = request.getParameter("senderID");
                        receipId = request.getParameter("receipId");
                        optionOne = (String) wboIssueCompl.getAttribute("optionOne");
                        String entryDate = (String) wboIssueCompl.getAttribute("entryDate");
//                        String clientComId = (String) wboIssueCompl.getAttribute("clientComId");
                        distributionListMgr = DistributionListMgr.getInstance();
                        receipWbo = new WebBusinessObject();
                        receipWbo = distributionListMgr.getLastOwnerForComp(compId);
                        receip_Id = "";
                        receipName = "";
                        if (receipWbo != null) {
                            receip_Id = (String) receipWbo.getAttribute("receipId");
                        }
                        if (receip_Id != null) {
                            receipWbo = new WebBusinessObject();
                            receipWbo = userMgr.getOnSingleKey(receip_Id);

                            receipName = (String) receipWbo.getAttribute("fullName");
                        }

                        userMgr = UserMgr.getInstance();
                        managerName = "";
                        managerId = "";
                        manager = projectMgr.getManagerByEmployee(receip_Id);
                        isManager = projectMgr.isManager(userId);
                        if (manager != null) {
                            managerId = (String) manager.getAttribute("optionOne");
                            managerName = userMgr.getByKeyColumnValue(managerId, "key3");
                        } else if (isManager) {
                            managerId = userId;
                            managerName = userMgr.getByKeyColumnValue(userId, "key3");
                        }

                        statusCode = request.getParameter("statusCode");

                        userMgr = UserMgr.getInstance();

                        senderWbo = new WebBusinessObject();

                        statusWbo = new WebBusinessObject();
                        manager = new WebBusinessObject();
                        senderWbo = userMgr.getOnSingleKey(senderId);

                        if (optionOne != null) {
                            manager = userMgr.getOnSingleKey(optionOne);
                        }
                        senderName = "";
                        if (senderWbo != null) {
                            senderName = (String) senderWbo.getAttribute("fullName");
                        }

                        complaintId = (String) wboIssueCompl.getAttribute("departmentId");
                        departmentId = (String) wboIssueCompl.getAttribute("departmentId");

                        clientId = (String) wboIssueCompl.getAttribute("customerId");

                        request.setAttribute("clientId", clientId);
                        ////////////////////////////case 64
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);
                        clientProduct = new Vector();

                        clientProductMgr = ClientProductMgr.getInstance();
                        try {
                            clientProduct = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
//                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo4 = new WebBusinessObject();
//                        wbo3 = clientMgr.getOnSingleKey(clientId);
                        reservedUnit = new Vector();
                        interestedUnit = new Vector();
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        products = new Vector();
                        mainProducts = new Vector();
                        try {
                            mainProducts = projectMgr.getOnArbitraryKey("44", "key4");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //////////////////Competent employee
                        userClientsMgr = UserClientsMgr.getInstance();

                        CompetentEmp = new Vector();

                        CompetentEmp = userClientsMgr.getOnArbitraryKey(clientId, "key2");
                        if (CompetentEmp != null) {
                            request.setAttribute("CompetentEmp", CompetentEmp);
                        } else {
                            request.setAttribute("CompetentEmp", null);
                        }
                        //////////////////////
                        wbo__ = new WebBusinessObject();
                        mgrId = "";
                        employeeMgr = EmpRelationMgr.getInstance();
                        wbo__ = projectMgr.getOnSingleKey(departmentId);
                        if (wbo__ != null) {
                            mgrId = (String) wbo__.getAttribute("optionOne");
                        }
                        employee = employeeMgr.getOnArbitraryKey(mgrId, "key1");
                        employees = new ArrayList<WebBusinessObject>();

                        if (employee.size() > 0) {

                            String userName = null;
                            wbo__ = new WebBusinessObject();
                            String projectName = null;
                            for (int q = 0; q < employee.size(); q++) {
                                wbo__ = new WebBusinessObject();
                                wbo2 = new WebBusinessObject();
                                wbo__ = (WebBusinessObject) employee.get(q);

                                userId = (String) wbo__.getAttribute("empId");
                                UserMgr userMgr = UserMgr.getInstance();

                                if (userId.length() > 0) {
                                    wbo__ = new WebBusinessObject();
                                    wbo__ = userMgr.getOnSingleKey(userId);
                                    if (wbo__ != null) {
                                        userName = (String) wbo__.getAttribute("userName");
                                        wbo2.setAttribute("userId", userId);
                                        wbo2.setAttribute("userName", userName);
                                        employees.add(wbo2);
                                    }
                                }

                            }
                        }
                        listOfAllEmployees = userMgr.getUserList();

                        // Get issue owner and manager
                        userId = (String) localPersistentUser.getAttribute("userId");
                        empRelationMgr = EmpRelationMgr.getInstance();
                        issueOwnerID = (String) distributionListMgr.getLastOwnerForComp(compId).getAttribute("receipId");
                        empManagerWbo = issueOwnerID != null ? empRelationMgr.getOnSingleKey(issueOwnerID, "key2") : new WebBusinessObject();
                        ownerManagerID = empManagerWbo != null ? (String) empManagerWbo.getAttribute("mgrId") : "";
                        if (ownerManagerID == null || ownerManagerID.isEmpty()) {
                            if (projectMgr.getOnArbitraryKeyOracle(userId, "key5").size() > 0) {
                                ownerManagerID = userId;
                            }
                        }
                        //

                        //For Close And Finish Actions
                        actionsList = new ArrayList<WebBusinessObject>();
                        departmentInfo = projectMgr.getManagerByEmployee((String) localPersistentUser.getAttribute("userId"));
                        if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
                            managerId = (String) departmentInfo.getAttribute("optionOne");
                            departmentInfo = projectMgr.getOnSingleKey("key5", managerId);
                            departmentId = (String) departmentInfo.getAttribute("projectID");
                            actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
                        } else { // May be he is a manager
                            departmentInfo = projectMgr.getOnSingleKey("key5", (String) localPersistentUser.getAttribute("userId"));
                            if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
                                departmentId = (String) departmentInfo.getAttribute("projectID");
                                actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
                            }
                        }
                        request.setAttribute("actionsList", actionsList);
//                        closureConfigurationMgr = ClosureConfigurationMgr.getCurrentInstance();
//                        request.setAttribute("closureActionsList", closureConfigurationMgr.getClosureActionsList());
                        userClosureConfigMgr = ClosureConfigMgr.getInstance();
                        userClosureList = userClosureConfigMgr.getClosuresByUser(localPersistentUser.getAttribute("userId").toString());
                        request.setAttribute("closureActionsList", userClosureList);
                        //
                        departmentId = "";
                        departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(userId, "key5"));
                        if (!departmentList.isEmpty()) {
                            departmentId = (String) departmentList.get(0).getAttribute("projectID");
                        }
                        employeeList = userMgr.getEmployeeByDepartmentId(departmentId, null, null);
                        for (int i = employeeList.size() - 1; i >= 0; i--) {
                            if (employeeList.get(i).getAttribute("userId").equals(ownerManagerID)) {
                                employeeList.remove(i);
                            }
                        }
                        employeeList.addAll(userMgr.getAllUpperManagers());
//                        for (int i = employeeList.size() - 1; i >= 0; i--) {
//                            WebBusinessObject wboEmployee = employeeList.get(i);
//                            if (userId.equals(wboEmployee.getAttribute("userId"))) {
//                                employeeList.remove(i);
//                            }
//                        }

                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.setAttribute("data", mainProducts);

                        request.setAttribute("products", interestedUnit);
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("includePage", page);
                        request.setAttribute("client", wbo);
                        request.setAttribute("DepComp", DepComp);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("compId", compId);
                        request.setAttribute("senderName", senderName);
                        request.setAttribute("receipID", receip_Id);
                        request.setAttribute("receipName", receipName);
                        request.setAttribute("managerId", managerId);
                        request.setAttribute("managerName", managerName);
                        request.setAttribute("statusCode", statusCode);
                        request.setAttribute("employeesx", employees);
                        request.setAttribute("allEmployees", listOfAllEmployees);
                        request.setAttribute("userUnderManager", employeeList);
                        request.setAttribute("complaintId", complaintId);
                        request.setAttribute("mgrId", mgrId);
                        request.setAttribute("entryDate", entryDate);
                        request.setAttribute("purcheUnits", new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle("purche", "key4", clientId, "key1")));
                        request.setAttribute("isOwner", issueOwnerID != null && issueOwnerID.equals(userId));
                        request.setAttribute("isOwnerManager", ownerManagerID != null && ownerManagerID.equals(userId));
                        request.setAttribute("dependOnIssuesList", issueMgr.getAllIssuesDepOnIssue(issueId));
                        this.forwardToServedPage(request, response);

                        break;
                    case 87:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        result = new WebBusinessObject();
                        String selectedId = request.getParameter("selectedId");
                        String[] ids = selectedId.split(",");
                        note = request.getParameter("note");

                        bookmarkMgr = BookmarkMgr.getInstance();

                        for (int i = 0; i < ids.length; i++) {
                            complaintId = ids[i];

                            try {
                                wbo = new WebBusinessObject();
                                wbo = bookmarkMgr.getOnSingleKey("key1", complaintId);

                                if (wbo != null) {
                                    String id = (String) wbo.getAttribute("bookmarkId");
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("compId", complaintId);
                                    wbo.setAttribute("note", note);

                                    if (bookmarkMgr.updateBookmark(wbo)) {
                                        result.setAttribute("status", "ok");
                                        result.setAttribute("bookmarkId", id);
                                    } else {
                                        result.setAttribute("status", "error");
                                        break;
                                    }
                                } else {
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("compId", complaintId);
                                    wbo.setAttribute("note", note);
                                    bookmarkId = bookmarkMgr.saveBookmark(wbo, session);
                                    if (bookmarkId != null) {
                                        result.setAttribute("status", "ok");
                                        result.setAttribute("bookmarkId", bookmarkId);
                                    } else {
                                        result.setAttribute("status", "error");
                                        break;
                                    }
                                }
                            } catch (Exception ex) {
                                result.setAttribute("status", "error");
                                Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                break;
                            }

                        }

                        out.write(Tools.getJSONObjectAsString(result));
                        break;
                    case 88:
                        issueId = (String) request.getParameter("issueId");
                        Vector complaints_ = new Vector();
                        IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                        complaints_ = issueByComplaintAllCaseMgr.getAllCase(issueId);
                        servedPage = "/complaints.jsp";

                        request.setAttribute("complaints", complaints_);
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;
                    case 89:
                        issueId = (String) request.getParameter("issueId");
                        complaints_ = new Vector();
                        issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                        complaints_ = issueByComplaintAllCaseMgr.getAllCase(issueId);
                        int numOfOrders = 0;
                        if (complaints_ != null & !complaints_.isEmpty()) {
                            for (int i = 0; i < complaints_.size(); i++) {
                                numOfOrders++;
                            }
                        }
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("numOfOrders", numOfOrders);
                        out = response.getWriter();
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 90:
                        out = response.getWriter();
                        issueId = request.getParameter("issueId");
                        String callType = request.getParameter("callType");
                        issueMgr = IssueMgr.getInstance();
                        wbo = new WebBusinessObject();
                        if (callType != null) {
                            if (issueMgr.updateCallType(issueId, callType)) {

                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "no");

                            }
                        } else {
                            wbo.setAttribute("status", "noChoose");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 91:
                        if (!response.isCommitted()) {
                            response.sendRedirect("main.jsp");
                        }
                        break;

                    case 93:
                        out = response.getWriter();
                        issueId = request.getParameter("issueId");
                        String direction = request.getParameter("direction");
                        issueMgr = IssueMgr.getInstance();
                        wbo = new WebBusinessObject();
                        if (direction != null) {
                            if (issueMgr.updateCallDirection(issueId, direction)) {

                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "no");

                            }
                        } else {
                            wbo.setAttribute("status", "noChoose");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 94:

                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        businessEventMgr = BusinessEventMgr.getInstance();
                        wbo = new WebBusinessObject();
                        if (businessEventMgr.redirectComplaintToEmployee(request, session)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "error");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 95:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        String stat = (String) request.getSession().getAttribute("currentMode");
                        if (stat.equals("En")) {
                            servedPage = "/docs/call_center/viewComp3_en.jsp";
                        } else {
                            servedPage = "/docs/call_center/viewComp3.jsp";
                        }
                        page = "";
                        clientType = request.getParameter("clientType");

                        DepComp = new Vector();
                        issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                        wboIssueCompl = new WebBusinessObject();

                        issueStatusMgr = IssueStatusMgr.getInstance();
                        s = request.getSession();

                        issueCompV = new Vector();
                        issueId = (String) request.getParameter("issueId");
                        compId = (String) request.getParameter("compId");

                        notes = "is acknowledge";
                        statusCode = "";
                        object_type = "client_complaint";
                        issueCompV = IssueByComplaintUniqueMgr.getInstance().getOnArbitraryKey(compId, "key4");
//                        issueCompV = issueByComplaintMgr.getOnArbitraryKey(issueId ,"key1");
//                        isAknowledeg = false;

                        //message open or not 
//                        bookmarkMgr = BookmarkMgr.getInstance();
//                        wbo = new WebBusinessObject();
//                        wbo = bookmarkMgr.getOnSingleKey("key1", compId);
//                        if (wbo != null) {
//                        } else {
//                            wbo = new WebBusinessObject();
//                            wbo.setAttribute("compId", compId);
//                            wbo.setAttribute("note", "open");
//                            bookmarkMgr.saveBookmark(wbo, session);
//                        }
//                        wbo = new WebBusinessObject();
                        // start employee open this ticket
                        userId = (String) localPersistentUser.getAttribute("userId");
                        userWbo = new WebBusinessObject();
                        userMgr = UserMgr.getInstance();
                        userWbo = userMgr.getOnSingleKey(userId);
                        String currentOwnerId = (String) request.getParameter("currentOwnerId");
//                        if (userWbo != null) {
//                            String isAdmin = (String) userWbo.getAttribute("userType");
//                            if (isAdmin.equals("0")) {
//                                for (int i = 0; i < issueCompV.size(); i++) {
//                                    wboIssueCompl = (WebBusinessObject) issueCompV.get(i);
//                                    if (wboIssueCompl != null) {
//                                        statusCode = (String) wboIssueCompl.getAttribute("statusCode");
//                                        if (!statusCode.equals("4")) {
//                                            isAknowledeg = true;
//                                        }
//                                    }
//                                }
//
//                                if (currentOwnerId != null && currentOwnerId.equals(userId) && !isAknowledeg) {
//
//                                    wbo = new WebBusinessObject();
//
//                                    wbo.setAttribute("parentId", issueId);
//                                    wbo.setAttribute("businessObjectId", compId);
//                                    statusCode = "3";
//                                    wbo.setAttribute("statusCode", statusCode);
//                                    wbo.setAttribute("objectType", object_type);
//                                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
//                                    wbo.setAttribute("issueTitle", "UL");
//                                    wbo.setAttribute("statusNote", "UL");
//                                    wbo.setAttribute("cuseDescription", "UL");
//                                    wbo.setAttribute("actionTaken", "UL");
//                                    wbo.setAttribute("preventionTaken", "UL");
//
//                                    try {
//                                        issueStatusMgr = IssueStatusMgr.getInstance();
//                                        issueStatusMgr.changeStatus(wbo, localPersistentUser, ActionEvent.getClientComplaintsActionEvent());
//
//                                    } catch (SQLException ex) {
//                                        logger.error(ex);
//                                    }
//                                }
//                            }
//                        }
//                        //end
                        wboIssueCompl = (WebBusinessObject) issueCompV.get(0);
                        senderId = request.getParameter("senderID");
                        receipId = request.getParameter("receipId");
                        optionOne = (String) wboIssueCompl.getAttribute("optionOne");

//                        String clientComId = (String) wboIssueCompl.getAttribute("clientComId");
                        distributionListMgr = DistributionListMgr.getInstance();
                        receipWbo = new WebBusinessObject();
                        receipWbo = distributionListMgr.getLastOwnerForComp(compId);
                        receip_Id = "";
                        receipName = "";
                        if (receipWbo != null) {
                            receip_Id = (String) receipWbo.getAttribute("receipId");
                        }
                        if (receip_Id != null) {
                            receipWbo = new WebBusinessObject();
                            receipWbo = userMgr.getOnSingleKey(receip_Id);

                            receipName = (String) receipWbo.getAttribute("fullName");
                        }

                        userMgr = UserMgr.getInstance();
                        managerName = "";
                        managerId = "";
                        manager = projectMgr.getManagerByEmployee(receip_Id);
                        isManager = projectMgr.isManager(userId);
                        if (manager != null) {
                            managerId = (String) manager.getAttribute("optionOne");
                            managerName = userMgr.getByKeyColumnValue(managerId, "key3");
                        } else if (isManager) {
                            managerId = userId;
                            managerName = userMgr.getByKeyColumnValue(userId, "key3");
                        }
                        statusCode = request.getParameter("statusCode");

                        userMgr = UserMgr.getInstance();

                        senderWbo = new WebBusinessObject();

                        statusWbo = new WebBusinessObject();
                        senderWbo = userMgr.getOnSingleKey(senderId);
                        senderName = "";
                        if (senderWbo != null) {
                            senderName = (String) senderWbo.getAttribute("fullName");
                        }

                        complaintId = (String) wboIssueCompl.getAttribute("departmentId");
                        departmentId = (String) wboIssueCompl.getAttribute("departmentId");

                        clientId = (String) wboIssueCompl.getAttribute("customerId");

                        //Tools.createClientSideMenu(clientId, request);
                        request.setAttribute("clientId", clientId);
                        ////////////////////////////case 64
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);
                        if (wbo.getAttribute("age") != null && ((String) wbo.getAttribute("age")).equalsIgnoreCase("100")) {
                            page = "/docs/call_center/companyOperations.jsp";
                        } else {
                            page = "/docs/call_center/clientProduct.jsp";
                            if (stat.equals("En")) {
                                page = "/docs/call_center/clientProduct_en.jsp";
                            }
                        }
                        clientProduct = new Vector();

                        clientProductMgr = ClientProductMgr.getInstance();
                        try {
                            clientProduct = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
//                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo4 = new WebBusinessObject();
//                        wbo3 = clientMgr.getOnSingleKey(clientId);
                        reservedUnit = new Vector();
                        interestedUnit = new Vector();
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        products = new Vector();
                        mainProducts = new Vector();
                        try {
                            /*products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                             wbo4 = (WebBusinessObject) products.get(0);
                             mainProducts = projectMgr.getOnArbitraryKey((String) wbo4.getAttribute("projectID"), "key2");*/

                            mainProducts = projectMgr.getOnArbitraryKey("44", "key4");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //////////////////Competent employee
                        userClientsMgr = UserClientsMgr.getInstance();

                        CompetentEmp = new Vector();

                        CompetentEmp = userClientsMgr.getOnArbitraryKey(clientId, "key2");
                        if (CompetentEmp != null) {
                            request.setAttribute("CompetentEmp", CompetentEmp);
                        } else {
                            request.setAttribute("CompetentEmp", null);
                        }
                        //////////////////////

                        wbo__ = new WebBusinessObject();
                        mgrId = "";
                        employeeMgr = EmpRelationMgr.getInstance();
                        wbo__ = projectMgr.getOnSingleKey(departmentId);
                        if (wbo__ != null) {
                            mgrId = (String) wbo__.getAttribute("optionOne");
                        }
                        employee = employeeMgr.getOnArbitraryKey(mgrId, "key1");
                        employees = new ArrayList<WebBusinessObject>();

                        if (employee.size() > 0) {

                            String userName = null;
                            wbo__ = new WebBusinessObject();
                            String projectName = null;
                            for (int q = 0; q < employee.size(); q++) {
                                wbo__ = new WebBusinessObject();
                                wbo2 = new WebBusinessObject();
                                wbo__ = (WebBusinessObject) employee.get(q);

                                userId = (String) wbo__.getAttribute("empId");
                                UserMgr userMgr = UserMgr.getInstance();

                                if (userId.length() > 0) {
                                    wbo__ = new WebBusinessObject();
                                    wbo__ = userMgr.getOnSingleKey(userId);
                                    if (wbo__ != null) {
                                        userName = (String) wbo__.getAttribute("userName");
                                        wbo2.setAttribute("userId", userId);
                                        wbo2.setAttribute("userName", userName);
                                        employees.add(wbo2);
                                    }
                                }

                            }
                        }

                        listOfAllEmployees = userMgr.getUserList();
                        ////////////////////
                        //
                        try {
                            ArrayList<WebBusinessObject> paymentPlace = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("1365240752318", "key2"));
                            request.setAttribute("paymentPlace", paymentPlace);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //

                        // Get issue owner and manager
                        userId = (String) localPersistentUser.getAttribute("userId");
                        empRelationMgr = EmpRelationMgr.getInstance();
                        issueOwnerID = (String) distributionListMgr.getLastOwnerForComp(compId).getAttribute("receipId");
                        empManagerWbo = issueOwnerID != null ? empRelationMgr.getOnSingleKey(issueOwnerID, "key2") : new WebBusinessObject();
                        ownerManagerID = empManagerWbo != null ? (String) empManagerWbo.getAttribute("mgrId") : "";
                        if (ownerManagerID == null || ownerManagerID.isEmpty()) {
                            if (projectMgr.getOnArbitraryKeyOracle(userId, "key5").size() > 0) {
                                ownerManagerID = userId;
                            }
                        }
                        //
                        //For Close And Finish Actions
                        actionsList = new ArrayList<WebBusinessObject>();
                        departmentInfo = projectMgr.getManagerByEmployee((String) localPersistentUser.getAttribute("userId"));
                        if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
                            managerId = (String) departmentInfo.getAttribute("optionOne");
                            departmentInfo = projectMgr.getOnSingleKey("key5", managerId);
                            departmentId = (String) departmentInfo.getAttribute("projectID");
                            actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
                        } else { // May be he is a manager
                            departmentInfo = projectMgr.getOnSingleKey("key5", (String) localPersistentUser.getAttribute("userId"));
                            if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
                                departmentId = (String) departmentInfo.getAttribute("projectID");
                                actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
                            }
                        }
                        request.setAttribute("actionsList", actionsList);
                        //closureConfigurationMgr = ClosureConfigurationMgr.getCurrentInstance();
                        //request.setAttribute("closureActionsList", closureConfigurationMgr.getClosureActionsList());
                        userClosureConfigMgr = ClosureConfigMgr.getInstance();
                        userClosureList = userClosureConfigMgr.getClosuresByUser(localPersistentUser.getAttribute("userId").toString());
                        request.setAttribute("closureActionsList", userClosureList);
                        //
                        departmentId = "";
                        departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(userId, "key5"));
                        if (!departmentList.isEmpty()) {
                            departmentId = (String) departmentList.get(0).getAttribute("projectID");
                        }
                        employeeList = userMgr.getEmployeeByDepartmentId(departmentId, null, null);
                        for (int i = employeeList.size() - 1; i >= 0; i--) {
                            if (employeeList.get(i).getAttribute("userId").equals(ownerManagerID)) {
                                employeeList.remove(i);
                            }
                        }
                        employeeList.addAll(userMgr.getAllUpperManagers());
//                        for (int i = employeeList.size() - 1; i >= 0; i--) {
//                            WebBusinessObject wboEmployee = employeeList.get(i);
//                            if (userId.equals(wboEmployee.getAttribute("userId"))) {
//                                employeeList.remove(i);
//                            }
//                        }

                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.setAttribute("data", mainProducts);

                        request.setAttribute("products", interestedUnit);
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("includePage", page);
                        request.setAttribute("client", wbo);
                        request.setAttribute("DepComp", DepComp);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("compId", compId);
                        request.setAttribute("senderName", senderName);
                        request.setAttribute("receipID", receip_Id);
                        request.setAttribute("receipName", receipName);
                        request.setAttribute("managerId", managerId);
                        request.setAttribute("managerName", managerName);
                        request.setAttribute("statusCode", statusCode);
                        request.setAttribute("allEmployees", listOfAllEmployees);
                        request.setAttribute("userUnderManager", employeeList);
                        request.setAttribute("complaintId", complaintId);
                        request.setAttribute("employeesx", employees);
                        request.setAttribute("mgrId", mgrId);
                        request.setAttribute("purcheUnits", new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle("purche", "key4", clientId, "key1")));
                        request.setAttribute("isOwner", issueOwnerID != null && issueOwnerID.equals(userId));
                        request.setAttribute("isOwnerManager", ownerManagerID != null && ownerManagerID.equals(userId));
                        request.setAttribute("dependOnIssuesList", issueMgr.getAllIssuesDepOnIssue(issueId));

                        this.forwardToServedPage(request, response);

                        break;
                    case 96:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        wbo = new WebBusinessObject();
                        String user_id = "";
                        String area_id = request.getParameter("area_id");

                        String tradeId = "11";
                        ServiceManAreaMgr serviceManAreaMgr = ServiceManAreaMgr.getInstance();

                        Vector supervisorData = new Vector();
                        supervisorData = serviceManAreaMgr.getSupervisorArea(area_id, tradeId);
                        if (supervisorData != null & !supervisorData.isEmpty()) {

                            wbo = (WebBusinessObject) supervisorData.get(0);
                        }
                        if (wbo != null) {

                            user_id = (String) wbo.getAttribute("userId");
//                                }
//                            }

                            claim_content = request.getParameter("comment");
                            clientId = (String) request.getParameter("clientId");
                            subject = (String) request.getParameter("subject");
                            ticketType = (String) request.getParameter("ticketType");
                            if (request.getSession().getAttribute("issueId") != null) {
                                request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                            } else {
                                request.setAttribute("issueId", "UL");
                            }
                            request.setAttribute("userId", user_id);
                            request.setAttribute("comment", claim_content);
                            request.setAttribute("clientId", clientId);
                            request.setAttribute("subject", subject);
                            request.setAttribute("ticketType", ticketType);
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompId = clientComplaintsMgr.saveClientComplaint2(request, localPersistentUser);
                            if (clientCompId != null) {
                                wbo.setAttribute("status", "Ok");
                                wbo.setAttribute("clientCompId", clientCompId);
                                wbo.setAttribute("supervisorId", user_id);

                            } else {

                                wbo.setAttribute("status", "No");

                            }
                        } else {
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("status", "No");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 97:
                        servedPage = "/docs/call_center/viewSupervisorComp.jsp";
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                        page = "";
                        clientType = request.getParameter("clientType");
                        if (clientType.equals("100")) {
                            page = "/docs/call_center/companyOperations.jsp";
                        } else {
                            page = "/docs/call_center/clientProduct.jsp";
                        }
                        DepComp = new Vector();
                        issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        wboIssueCompl = new WebBusinessObject();

                        issueStatusMgr = IssueStatusMgr.getInstance();
                        s = request.getSession();

                        issueCompV = new Vector();
                        issueId = (String) request.getParameter("issueId");
                        compId = (String) request.getParameter("compId");
                        notes = "is acknowledge";
                        statusCode = "";
                        object_type = "client_complaint";

                        issueCompV = issueByComplaintMgr.getOnArbitraryKey(compId, "key4");
//                        EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
//                        issueCompV = employeeViewMgr.getOnArbitraryKey(compId, "key4");
//                        issueCompV = issueByComplaintMgr.getOnArbitraryKey(issueId ,"key1");
//                        isAknowledeg = false;

                        //message open or not 
//                        bookmarkMgr = BookmarkMgr.getInstance();
//                        wbo = new WebBusinessObject();
//                        wbo = bookmarkMgr.getOnSingleKey("key1", compId);
//                        if (wbo != null) {
//                        } else {
//                            wbo = new WebBusinessObject();
//                            wbo.setAttribute("compId", compId);
//                            wbo.setAttribute("note", "open");
//                            bookmarkMgr.saveBookmark(wbo, session);
//                        }
//                        wbo = new WebBusinessObject();
                        // start employee open this ticket
                        userId = (String) localPersistentUser.getAttribute("userId");
                        userWbo = new WebBusinessObject();
                        userMgr = UserMgr.getInstance();
                        userWbo = userMgr.getOnSingleKey(userId);
//                        // change status to acknowledeg if status equal 4
//
//                        if (userWbo != null) {
//
//                            serviceManAreaMgr = ServiceManAreaMgr.getInstance();
//                            supervisorData = serviceManAreaMgr.getUserArea(userId);
//                            WebBusinessObject webBusinessObject1 = new WebBusinessObject();
//                            if (supervisorData != null & !supervisorData.isEmpty()) {
//                                webBusinessObject1 = (WebBusinessObject) supervisorData.get(0);
//                                tradeId = (String) webBusinessObject1.getAttribute("rollId");
//                                if (tradeId.equals("7")) {
//                                    for (int i = 0; i < issueCompV.size(); i++) {
//                                        wboIssueCompl = (WebBusinessObject) issueCompV.get(i);
//                                        if (wboIssueCompl != null) {
//                                            statusCode = (String) wboIssueCompl.getAttribute("statusCode");
//                                            if (!statusCode.equals("4")) {
//                                                isAknowledeg = true;
//                                            }
//                                        }
//                                    }
//                                    if (!isAknowledeg) {
//
//                                        wbo = new WebBusinessObject();
//
//                                        wbo.setAttribute("parentId", issueId);
//                                        wbo.setAttribute("businessObjectId", compId);
//                                        statusCode = "3";
//                                        wbo.setAttribute("statusCode", statusCode);
//                                        wbo.setAttribute("objectType", object_type);
//                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
//                                        wbo.setAttribute("issueTitle", "UL");
//                                        wbo.setAttribute("statusNote", "UL");
//                                        wbo.setAttribute("cuseDescription", "UL");
//                                        wbo.setAttribute("actionTaken", "UL");
//                                        wbo.setAttribute("preventionTaken", "UL");
//
//                                        try {
//                                            issueStatusMgr = IssueStatusMgr.getInstance();
//                                            issueStatusMgr.changeStatus(wbo, localPersistentUser, ActionEvent.getClientComplaintsActionEvent());
//
//                                        } catch (SQLException ex) {
//                                            logger.error(ex);
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        //end
                        wboIssueCompl = (WebBusinessObject) issueCompV.get(0);
                        senderId = request.getParameter("senderID");
                        receipId = request.getParameter("receipId");
                        optionOne = (String) wboIssueCompl.getAttribute("optionOne");

//                        String clientComId = (String) wboIssueCompl.getAttribute("clientComId");
                        distributionListMgr = DistributionListMgr.getInstance();
                        receipWbo = new WebBusinessObject();
                        receipWbo = distributionListMgr.getLastOwnerForComp(compId);
                        receip_Id = "";
                        receipName = "";
                        if (receipWbo != null) {
                            receip_Id = (String) receipWbo.getAttribute("receipId");
                        }
                        if (receip_Id != null) {
                            receipWbo = new WebBusinessObject();
                            receipWbo = userMgr.getOnSingleKey(receip_Id);

                            receipName = (String) receipWbo.getAttribute("userName");
                        }
                        statusCode = request.getParameter("statusCode");

                        userMgr = UserMgr.getInstance();

                        senderWbo = new WebBusinessObject();

                        statusWbo = new WebBusinessObject();
                        manager = new WebBusinessObject();
                        senderWbo = userMgr.getOnSingleKey(senderId);

                        if (optionOne != null) {
                            manager = userMgr.getOnSingleKey(optionOne);
                        }
                        senderName = "";

                        managerName = "";
                        if (senderWbo != null) {
                            senderName = (String) senderWbo.getAttribute("userName");
                        }

                        if (manager != null) {
                            managerName = (String) manager.getAttribute("userName");
                        }

                        complaintId = (String) wboIssueCompl.getAttribute("departmentId");
                        departmentId = (String) wboIssueCompl.getAttribute("departmentId");

                        clientId = (String) wboIssueCompl.getAttribute("customerId");

                        request.setAttribute("clientId", clientId);
                        ////////////////////////////case 64
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);
                        clientProduct = new Vector();

                        clientProductMgr = ClientProductMgr.getInstance();
                        try {
                            clientProduct = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
//                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo4 = new WebBusinessObject();
//                        wbo3 = clientMgr.getOnSingleKey(clientId);
                        reservedUnit = new Vector();
                        interestedUnit = new Vector();
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        products = new Vector();
                        mainProducts = new Vector();
                        try {
                            products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                            wbo4 = (WebBusinessObject) products.get(0);
                            mainProducts = projectMgr.getOnArbitraryKey((String) wbo4.getAttribute("projectID"), "key2");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //////////////////Competent employee
                        userClientsMgr = UserClientsMgr.getInstance();

                        CompetentEmp = new Vector();

                        CompetentEmp = userClientsMgr.getOnArbitraryKey(clientId, "key2");
                        if (CompetentEmp != null) {
                            request.setAttribute("CompetentEmp", CompetentEmp);
                        } else {
                            request.setAttribute("CompetentEmp", null);
                        }
                        //////////////////////

                        wbo__ = new WebBusinessObject();
                        mgrId = "";
                        employeeMgr = EmpRelationMgr.getInstance();
                        wbo__ = projectMgr.getOnSingleKey(departmentId);
                        if (wbo__ != null) {
                            mgrId = (String) wbo__.getAttribute("optionOne");
                        }
                        employee = employeeMgr.getOnArbitraryKey(mgrId, "key1");
                        employees = new ArrayList<WebBusinessObject>();

                        if (employee.size() > 0) {

                            String userName = null;
                            wbo__ = new WebBusinessObject();
                            String projectName = null;
                            for (int q = 0; q < employee.size(); q++) {
                                wbo__ = new WebBusinessObject();
                                wbo2 = new WebBusinessObject();
                                wbo__ = (WebBusinessObject) employee.get(q);

                                userId = (String) wbo__.getAttribute("empId");
                                UserMgr userMgr = UserMgr.getInstance();

                                if (userId.length() > 0) {
                                    wbo__ = new WebBusinessObject();
                                    wbo__ = userMgr.getOnSingleKey(userId);
                                    if (wbo__ != null) {
                                        userName = (String) wbo__.getAttribute("userName");
                                        wbo2.setAttribute("userId", userId);
                                        wbo2.setAttribute("userName", userName);
                                        employees.add(wbo2);
                                    }
                                }

                            }
                        }
                        ////////////////////

                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.setAttribute("data", mainProducts);

                        request.setAttribute("products", interestedUnit);
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("includePage", page);
                        request.setAttribute("client", wbo);
                        request.setAttribute("DepComp", DepComp);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("compId", compId);
                        request.setAttribute("senderName", senderName);
                        request.setAttribute("receipID", receip_Id);
                        request.setAttribute("receipName", receipName);
                        request.setAttribute("managerName", managerName);
                        request.setAttribute("statusCode", statusCode);

                        request.setAttribute("complaintId", complaintId);
                        request.setAttribute("employeesx", employees);
                        request.setAttribute("mgrId", mgrId);
                        this.forwardToServedPage(request, response);

                        break;
                    case 98:
                        servedPage = "/docs/call_center/viewSupervisorComp2.jsp";
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                        page = "";
                        clientType = request.getParameter("clientType");
                        if (clientType.equals("100")) {
                            page = "/docs/call_center/companyOperations.jsp";
                        } else {
                            page = "/docs/call_center/clientProduct.jsp";
                        }
                        DepComp = new Vector();
                        issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        wboIssueCompl = new WebBusinessObject();

                        issueStatusMgr = IssueStatusMgr.getInstance();
                        s = request.getSession();

                        issueCompV = new Vector();
                        issueId = (String) request.getParameter("issueId");
                        compId = (String) request.getParameter("compId");
                        notes = "is acknowledge";
                        statusCode = "";
                        object_type = "client_complaint";

//                        issueCompV = issueByComplaintMgr.getOnArbitraryKey(compId, "key4");
                        EmployeeView2Mgr employeeView2Mgr = EmployeeView2Mgr.getInstance();
                        issueCompV = employeeView2Mgr.getOnArbitraryKey(compId, "key4");
//                        issueCompV = issueByComplaintMgr.getOnArbitraryKey(issueId ,"key1");
//                        isAknowledeg = false;

                        //message open or not 
//                        bookmarkMgr = BookmarkMgr.getInstance();
//                        wbo = new WebBusinessObject();
//                        wbo = bookmarkMgr.getOnSingleKey("key1", compId);
//                        if (wbo != null) {
//                        } else {
//                            wbo = new WebBusinessObject();
//                            wbo.setAttribute("compId", compId);
//                            wbo.setAttribute("note", "open");
//                            bookmarkMgr.saveBookmark(wbo, session);
//                        }
//                        wbo = new WebBusinessObject();
                        // start employee open this ticket
                        userId = (String) localPersistentUser.getAttribute("userId");
                        userWbo = new WebBusinessObject();
                        userMgr = UserMgr.getInstance();
                        userWbo = userMgr.getOnSingleKey(userId);
//                        // change status to acknowledeg if status equal 4
//
//                        if (userWbo != null) {
//
//                            serviceManAreaMgr = ServiceManAreaMgr.getInstance();
//                            supervisorData = serviceManAreaMgr.getUserArea(userId);
//                            WebBusinessObject webBusinessObject1 = new WebBusinessObject();
//                            if (supervisorData != null & !supervisorData.isEmpty()) {
//                                webBusinessObject1 = (WebBusinessObject) supervisorData.get(0);
//                                tradeId = (String) webBusinessObject1.getAttribute("rollId");
//                                if (tradeId.equals("7")) {
//                                    for (int i = 0; i < issueCompV.size(); i++) {
//                                        wboIssueCompl = (WebBusinessObject) issueCompV.get(i);
//                                        if (wboIssueCompl != null) {
//                                            statusCode = (String) wboIssueCompl.getAttribute("statusCode");
//                                            if (!statusCode.equals("4")) {
//                                                isAknowledeg = true;
//                                            }
//                                        }
//                                    }
//                                    if (!isAknowledeg) {
//
//                                        wbo = new WebBusinessObject();
//
//                                        wbo.setAttribute("parentId", issueId);
//                                        wbo.setAttribute("businessObjectId", compId);
//                                        statusCode = "3";
//                                        wbo.setAttribute("statusCode", statusCode);
//                                        wbo.setAttribute("objectType", object_type);
//                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
//                                        wbo.setAttribute("issueTitle", "UL");
//                                        wbo.setAttribute("statusNote", "UL");
//                                        wbo.setAttribute("cuseDescription", "UL");
//                                        wbo.setAttribute("actionTaken", "UL");
//                                        wbo.setAttribute("preventionTaken", "UL");
//
//                                        try {
//                                            issueStatusMgr = IssueStatusMgr.getInstance();
//                                            issueStatusMgr.changeStatus(wbo, localPersistentUser, ActionEvent.getClientComplaintsActionEvent());
//
//                                        } catch (SQLException ex) {
//                                            logger.error(ex);
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        //end
                        wboIssueCompl = (WebBusinessObject) issueCompV.get(0);
                        senderId = request.getParameter("senderID");
                        receipId = request.getParameter("receipId");
                        optionOne = (String) wboIssueCompl.getAttribute("optionOne");

//                        String clientComId = (String) wboIssueCompl.getAttribute("clientComId");
                        distributionListMgr = DistributionListMgr.getInstance();
                        receipWbo = new WebBusinessObject();
                        receipWbo = distributionListMgr.getLastOwnerForComp(compId);
                        receip_Id = "";
                        receipName = "";
                        if (receipWbo != null) {
                            receip_Id = (String) receipWbo.getAttribute("receipId");
                        }
                        if (receip_Id != null) {
                            receipWbo = new WebBusinessObject();
                            receipWbo = userMgr.getOnSingleKey(receip_Id);

                            receipName = (String) receipWbo.getAttribute("userName");
                        }
                        statusCode = request.getParameter("statusCode");

                        userMgr = UserMgr.getInstance();

                        senderWbo = new WebBusinessObject();

                        statusWbo = new WebBusinessObject();
                        manager = new WebBusinessObject();
                        senderWbo = userMgr.getOnSingleKey(senderId);

                        if (optionOne != null) {
                            manager = userMgr.getOnSingleKey(optionOne);
                        }
                        senderName = "";

                        managerName = "";
                        if (senderWbo != null) {
                            senderName = (String) senderWbo.getAttribute("userName");
                        }

                        if (manager != null) {
                            managerName = (String) manager.getAttribute("userName");
                        }

                        complaintId = (String) wboIssueCompl.getAttribute("departmentId");
                        departmentId = (String) wboIssueCompl.getAttribute("departmentId");

                        clientId = (String) wboIssueCompl.getAttribute("customerId");

                        request.setAttribute("clientId", clientId);
                        ////////////////////////////case 64
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientId);
                        clientProduct = new Vector();

                        clientProductMgr = ClientProductMgr.getInstance();
                        try {
                            clientProduct = clientProductMgr.getOnArbitraryKey(clientId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientId);
                        clientMgr = ClientMgr.getInstance();
//                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo4 = new WebBusinessObject();
//                        wbo3 = clientMgr.getOnSingleKey(clientId);
                        reservedUnit = new Vector();
                        interestedUnit = new Vector();
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        products = new Vector();
                        mainProducts = new Vector();
                        try {
                            products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                            wbo4 = (WebBusinessObject) products.get(0);
                            mainProducts = projectMgr.getOnArbitraryKey((String) wbo4.getAttribute("projectID"), "key2");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //////////////////Competent employee
                        userClientsMgr = UserClientsMgr.getInstance();

                        CompetentEmp = new Vector();

                        CompetentEmp = userClientsMgr.getOnArbitraryKey(clientId, "key2");
                        if (CompetentEmp != null) {
                            request.setAttribute("CompetentEmp", CompetentEmp);
                        } else {
                            request.setAttribute("CompetentEmp", null);
                        }
                        //////////////////////

                        wbo__ = new WebBusinessObject();
                        mgrId = "";
                        employeeMgr = EmpRelationMgr.getInstance();
                        wbo__ = projectMgr.getOnSingleKey(departmentId);
                        if (wbo__ != null) {
                            mgrId = (String) wbo__.getAttribute("optionOne");
                        }
                        employee = employeeMgr.getOnArbitraryKey(mgrId, "key1");
                        employees = new ArrayList<WebBusinessObject>();

                        if (employee.size() > 0) {

                            String userName = null;
                            wbo__ = new WebBusinessObject();
                            String projectName = null;
                            for (int q = 0; q < employee.size(); q++) {
                                wbo__ = new WebBusinessObject();
                                wbo2 = new WebBusinessObject();
                                wbo__ = (WebBusinessObject) employee.get(q);

                                userId = (String) wbo__.getAttribute("empId");
                                UserMgr userMgr = UserMgr.getInstance();

                                if (userId.length() > 0) {
                                    wbo__ = new WebBusinessObject();
                                    wbo__ = userMgr.getOnSingleKey(userId);
                                    if (wbo__ != null) {
                                        userName = (String) wbo__.getAttribute("userName");
                                        wbo2.setAttribute("userId", userId);
                                        wbo2.setAttribute("userName", userName);
                                        employees.add(wbo2);
                                    }
                                }

                            }
                        }
                        ////////////////////

                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.setAttribute("data", mainProducts);

                        request.setAttribute("products", interestedUnit);
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("includePage", page);
                        request.setAttribute("client", wbo);
                        request.setAttribute("DepComp", DepComp);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("compId", compId);
                        request.setAttribute("senderName", senderName);
                        request.setAttribute("receipID", receip_Id);
                        request.setAttribute("receipName", receipName);
                        request.setAttribute("managerName", managerName);
                        request.setAttribute("statusCode", statusCode);

                        request.setAttribute("complaintId", complaintId);
                        request.setAttribute("employeesx", employees);
                        request.setAttribute("mgrId", mgrId);
                        this.forwardToServedPage(request, response);

                        break;
                    case 99:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        session = request.getSession();
                        clientId = request.getParameter("clientId");
                        UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                        request.setAttribute("projectsList", new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryKey(loggegUserId, "key1")));
                        WebBusinessObject issue = new WebBusinessObject();

                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                        c = Calendar.getInstance();
                        issue.setAttribute("clientId", clientId);
                        issue.setAttribute("comments", request.getParameter("comments"));
                        issue.setAttribute("note", request.getParameter("note"));
                        issue.setAttribute("entryDate", "2014/05/22 12:00");
                        issue.setAttribute("deliveryDate", sdf.format(c.getTime()));
                        issue.setAttribute("type", "client_complaint");
                        issue.setAttribute("callType", request.getParameter("callType"));

                        issueId = issueMgr.saveIssueFromTypeExtracting(issue, localPersistentUser);
                        if (issueId != null) {
                            issue = issueMgr.getOnSingleKey(issueId);
                            WebBusinessObject client = ClientMgr.getInstance().getOnSingleKey(clientId);
                            TradeMgr tradeMgr = TradeMgr.getInstance();
                            WebBusinessObject tradeWbo = (WebBusinessObject) tradeMgr.getOnSingleKey((String) client.getAttribute("job"));
                            servedPage = "/docs/project_manager/new_extract.jsp";
                            request.setAttribute("clientId", clientId);
                            request.setAttribute("clientName", (String) client.getAttribute("name"));
                            request.setAttribute("clientActivity", (String) tradeWbo.getAttribute("tradeName"));
                            request.setAttribute("issueId", issueId);
                            request.setAttribute("status", "ok");
                            request.setAttribute("page", servedPage);
                            request.setAttribute("issue", issue);
                            request.setAttribute("issueSaved", "ok");
                            this.forwardToServedPage(request, response);
                        } else {
                            servedPage = "SearchServlet?op=searchForVendor&searchBy=";
                            request.setAttribute("status", "no");
                            request.setAttribute("issueSaved", "no");
                            this.forward(servedPage, request, response);
                        }
                        break;
                    case 100:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        List<FileMeta> files = com.silkworm.uploader.MultipartRequestHandler.uploadByJavaServletAPI(request);

                        //init vars
                        String projectManagerId,
                         techOfficeId,
                         techOfficeName;
                        WebBusinessObject projectTechOffice;
                        WebBusinessObject techOfficeUser;

                        //init Managers
                        UserCompanyProjectsMgr userCompProMgr = UserCompanyProjectsMgr.getInstance();
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        TradeMgr tradeMgr = TradeMgr.getInstance();

                        //get request parameters
                        projectID = request.getParameter("projectID");
                        clientId = request.getParameter("clientId");

                        //get id for techofficer trade and project user officer
                        WebBusinessObject empTradeWbo = tradeMgr.getTradeByName("techoffice");

                        //Get Client
                        WebBusinessObject client = ClientMgr.getInstance().getOnSingleKey(clientId);
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("clientName", (String) client.getAttribute("name"));
                        WebBusinessObject tradeWbo = (WebBusinessObject) tradeMgr.getOnSingleKey((String) client.getAttribute("job"));
                        request.setAttribute("clientActivity", (String) tradeWbo.getAttribute("tradeName"));

                        if (empTradeWbo != null) {
                            //get tech officer Emp for the project 
                            projectTechOffice = userCompProMgr.getEmpInProject(projectID, empTradeWbo.getAttribute("tradeId").toString());

                            if (null != projectTechOffice) {
                                techOfficeUser = userMgr.getOnSingleKey(projectTechOffice.getAttribute("userId").toString());
                                if (techOfficeUser != null) {
                                    try {
                                        // get sender and receiver user
                                        WebBusinessObject projectManagerUser = UserMgr.getInstance().getOnSingleKey("1400935249387");
                                        projectManagerId = (String) projectManagerUser.getAttribute("userId");

                                        techOfficeId = (String) techOfficeUser.getAttribute("userId");
                                        techOfficeName = (String) techOfficeUser.getAttribute("userName");

                                        userWbo = userMgr.getOnSingleKey((String) localPersistentUser.getAttribute("userId"));
                                        if (clientComplaintsMgr.clientComplaintExtractingOrder(request, userWbo, files, projectManagerId, techOfficeId, techOfficeName) != null) {
                                            // update issue row by extract number in column project name
                                            String contractNo = request.getParameter("contractNo");
                                            issueId = request.getParameter("issueId");
                                            if (issueMgr.getOnArbitraryDoubleKeyOracle(clientId, "key7", contractNo, "key6").isEmpty()) {
                                                String[] updatedKeys = new String[]{"key6"};
                                                String[] updatedValues = new String[]{contractNo};
                                                issueMgr.updateOnSingleKey(issueId, updatedKeys, updatedValues);

                                                request.setAttribute("status", "OK");
                                                request.setAttribute("fileAttached", "OK");
                                                request.setAttribute("techOfficeName", (String) techOfficeUser.getAttribute("fullName"));
                                                IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
                                                wbo = new WebBusinessObject();
                                                wbo.setAttribute("issueID", issueId);
                                                wbo.setAttribute("projectID", projectID);
                                                issueProjectMgr.saveObject(wbo);
                                                request.setAttribute("issueSaved", "ok");
                                            } else {
                                                request.setAttribute("status", "ContractNoExists");
                                            }
                                        } else {
                                            request.setAttribute("status", "Failed");
                                        }
                                    } catch (Exception ex) {
                                        logger.error(ex);
                                    }
                                } else {
                                    request.setAttribute("status", "Failed");
                                }
                            } else {
                                request.setAttribute("status", "NoTechOfficeForPtoject");
                            }
                        } else {
                            request.setAttribute("status", "Failed");
                        }

                        userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                        issueId = (String) request.getParameter("issueId");
                        issue = issueMgr.getOnSingleKey(issueId);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("issue", issue);
                        request.setAttribute("projectsList", new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryKey(loggegUserId, "key1")));
                        servedPage = "/docs/project_manager/new_extract.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 101:
                        issueId = (String) request.getParameter("issueId");
                        servedPage = "/docs/project_manager/new_order_request.jsp";
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("issue", issueMgr.getOnSingleKey(issueId));
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 102:
                        userHome = (String) loggedUser.getAttribute("userHome");
                        userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                        multipartRequest = null;
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        try {
                            multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                        } catch (IncorrectFileType ex) {
                            logger.error(ex);
                        } catch (IOException io) {
                            request.setAttribute("status", "Failed");
                            request.setAttribute("fileAttached", "no");
                        }
                        try {
                            // get sender and receiver user
                            senderId = projectMgr.getManagerOfProjectManagerDepartment();
                            String recipientId = projectMgr.getManagerOfQualityManagementDepartment();
                            businessId = multipartRequest.getParameter("businessId");
                            if (clientComplaintsMgr.sendFile(multipartRequest, session, senderId, recipientId, businessId)) {
                                request.setAttribute("status", "OK");
                                request.setAttribute("fileAttached", "OK");
                            } else {
                                request.setAttribute("status", "Failed");
                            }
                        } catch (Exception ex) {
                            logger.error(ex);
                        }
                        issueId = (String) request.getParameter("issueId");
                        issue = issueMgr.getOnSingleKey(issueId);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("issue", issue);
                        servedPage = "/docs/project_manager/new_order_request.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 103:
                        ClientComplaintsMgr complaintMgr = ClientComplaintsMgr.getInstance();
                        DistributionListMgr distributionMgr = DistributionListMgr.getInstance();
                        clientMgr = ClientMgr.getInstance();
                        WebBusinessObject complaint,
                         distribution;
                        servedPage = "IssueServlet?op=getCompl3&issueId=%s&compId=%s&statusCode=%s&receipId=%s&senderID=%s&clientType=%s&currentOwnerId=%s";
                        clientComplaintId = request.getParameter("clientComplaintId");
                        complaint = complaintMgr.getOnSingleKey(clientComplaintId);
                        distribution = distributionMgr.getDistributionListInfoByComplaintId(clientComplaintId);
                        issueId = (String) complaint.getAttribute("issueId");
                        statusCode = (String) complaint.getAttribute("currentStatus");
                        receipId = (String) distribution.getAttribute("receipId");
                        senderId = (String) distribution.getAttribute("senderId");
                        clientType = clientMgr.getAgeGroupByIssueId(issueId);
                        currentOwnerId = (String) complaint.getAttribute("currentOwnerId");
                        servedPage = String.format(servedPage, issueId, clientComplaintId, statusCode, receipId, senderId, clientType, currentOwnerId);
                        this.forward(servedPage, request, response);
                        break;

                    case 104:
                        clientComplaintId = request.getParameter("clientComplaintId");
                        String empIds = request.getParameter("empIds");
                        subject = request.getParameter("subject");
                        String comment = request.getParameter("comment");
                        out = response.getWriter();
                        String[] listOfIds;
                        listOfIds = empIds.split(",");
                        wbo = new WebBusinessObject();
                        String idError = "";
                        ClientComplaintsMgr complaintsMgr = ClientComplaintsMgr.getInstance();
                        distributionListMgr = DistributionListMgr.getInstance();
                        wbo = distributionListMgr.getOnSingleKey("key1", clientComplaintId);
                        String complaintTitle;
                        complaintTitle = (String) wbo.getAttribute("option1");
                        for (int i = 0; i < listOfIds.length; i++) {
                            if (complaintsMgr.createNotificationComplaint(clientComplaintId, loggegUserId, listOfIds[i], complaintTitle, comment)) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                idError += listOfIds[i];
                            }
                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 105:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        businessId = request.getParameter("businessId");
                        clientComplaintId = request.getParameter("clientComplaintId");
                        issueId = request.getParameter("issueId");
                        employeeId = request.getParameter("employeeId");
                        subject = request.getParameter("subject");
                        comment = request.getParameter("comment");
                        notes = "is acknowledge";
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        try {
                            complaintsMgr = ClientComplaintsMgr.getInstance();
                            if (complaintsMgr.redistributionCompliant(clientComplaintId, issueId, employeeId, businessId, comment, subject, notes, localPersistentUser)) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "error");
                            }
                        } catch (Exception ex) {
                            wbo.setAttribute("status", "error");
                        }

                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 106:
                        // (begin) issue depend on another one
                        String dependOnID = request.getParameter("dependOnID");
                        if (dependOnID != null) {
                            issue = issueMgr.getOnSingleKey((String) dependOnID);
                            if (issue != null) {
                                request.setAttribute("issueDependOnWbo", issue);
                                RequestItemsMgr requestItemsMgr = RequestItemsMgr.getInstance();
                                request.setAttribute("itemsDependOnList", new ArrayList<WebBusinessObject>(requestItemsMgr.getOnArbitraryKeyOracle(dependOnID, "key1")));
                                IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
                                ArrayList<WebBusinessObject> issueProject = new ArrayList<>(issueProjectMgr.getOnArbitraryKeyOracle(dependOnID, "key1"));
                                if (!issueProject.isEmpty()) {
                                    request.setAttribute("projectDepenedOnID", issueProject.get(0).getAttribute("projectID"));
                                    request.setAttribute("engineerDepenedOnID", issueProject.get(0).getAttribute("option1"));
                                }
                            }
                        }
                        // (end)
                        clientId = request.getParameter("clientId");
                        client = ClientMgr.getInstance().getOnSingleKey(clientId);
                        servedPage = "docs/requests/request_extradition.jsp";
                        userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                        request.setAttribute("page", servedPage);
                        request.setAttribute("projectsList", new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryKey(loggegUserId, "key1")));
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("client", client);
                        request.setAttribute("engineersList", userMgr.getAllEngineers());
                        this.forwardToServedPage(request, response);
                        break;

                    case 107:
                        securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
                        session = request.getSession();
                        clientId = request.getParameter("clientId");
                        projectID = request.getParameter("projectID");
                        client = ClientMgr.getInstance().getOnSingleKey(clientId);
                        String accepted = request.getParameter("accepted");
                        String unitNo = request.getParameter("unitNo");
//                        String modelNo = multipartRequest.getParameter("modelNo");
//                        String floorNo = multipartRequest.getParameter("floorNo");
                        String engineerID = request.getParameter("engineerID");
                        files = com.silkworm.uploader.MultipartRequestHandler.uploadByJavaServletAPI(request);

                        issue = new WebBusinessObject();
                        issue.setAttribute("clientId", clientId);
                        issue.setAttribute("comments", request.getParameter("comments"));
                        issue.setAttribute("note", request.getParameter("note"));
                        issue.setAttribute("entryDate", "2014/05/22 12:00");
                        issue.setAttribute("deliveryDate", request.getParameter("deliveryDate"));
                        issue.setAttribute("type", "comment_hierarchy");
                        issue.setAttribute("callType", request.getParameter("callType"));
                        issue.setAttribute("unitId", unitNo);
                        issue.setAttribute("title", "طلب تسليم");
                        remoteAccess = request.getSession().getId();
                        WebBusinessObject localPersisUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        issueId = issueMgr.saveIssueFromTypeExtracting(issue, localPersisUser);
                        if (issueId != null) {
                            issue = issueMgr.getOnSingleKey(issueId);
                            tradeMgr = TradeMgr.getInstance();
                            tradeWbo = (WebBusinessObject) tradeMgr.getOnSingleKey((String) client.getAttribute("job"));
                            request.setAttribute("clientId", clientId);
                            request.setAttribute("clientName", (String) client.getAttribute("name"));
                            request.setAttribute("clientActivity", (String) tradeWbo.getAttribute("tradeName"));
                            request.setAttribute("status", "ok");
                            request.setAttribute("issueId", issueId);
                            request.setAttribute("issue", issue);
                            request.setAttribute("clientActivity", (String) client.getAttribute("nationality"));

                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            businessId = (String) issue.getAttribute("businessID");
                            ticketType = CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION;
                            comment = request.getParameter("comments");
                            notes = request.getParameter("notes");
                            subject = "طلب تسليم";

                            // insert comment
                            CommentsMgr commentsMgr = CommentsMgr.getInstance();
                            String createdBy = (String) localPersisUser.getAttribute("userId");
                            String commentType = "10";
                            String objectType = CRMConstants.OBJECT_TYPE_ISSUE;
                            String option1 = request.getParameter("clientComplaintType");

                            wbo = new WebBusinessObject();
                            wbo.setAttribute("createdBy", createdBy);
                            wbo.setAttribute("objectId", issueId);
                            wbo.setAttribute("commentType", commentType);
                            wbo.setAttribute("comment", comment);
                            wbo.setAttribute("objectType", objectType);
                            wbo.setAttribute("option1", option1);

                            boolean commented = commentsMgr.saveComment(wbo);
                            clientComplaintId = clientComplaintsMgr.createMailInBox(createdBy, issueId, ticketType, businessId, comment, subject, notes, localPersisUser);
//                            alertMgr.saveObjectAddReviewComment(clientComplaintId, loggegUserId);
                            if ((clientComplaintId != null) && commented) {
                                // insert request items
                                RequestItemsMgr requestItemsMgr = RequestItemsMgr.getInstance();
                                String[] projectIds = request.getParameterValues("requestedItemId");
                                String[] quantities = request.getParameterValues("quantity");
                                String[] valids = request.getParameterValues("valid");
                                String[] notesItem = request.getParameterValues("requestedItemNote");
                                for (int i = 0; i < projectIds.length; i++) {
                                    requestItemsMgr.save(issueId, projectIds[i], quantities[i], valids[i], notesItem[i], createdBy, "UL", "UL", "UL", "UL", "UL", "UL");
                                }

                                // update issue row by extract number in column project name
                                String contractNo = "1";
                                String[] updatedKeys = new String[]{"key6"};
                                String[] updatedValues = new String[]{contractNo};
                                issueMgr.updateOnSingleKey(issueId, updatedKeys, updatedValues);

                                issueStatusMgr = IssueStatusMgr.getInstance();
                                String statusForIssue = CRMConstants.ISSUE_STATUS_REJECTED;
                                if ("yes".equalsIgnoreCase(accepted) || "yes_with_note".equalsIgnoreCase(accepted)) {
                                    if ("yes".equalsIgnoreCase(accepted)) {
                                        statusForIssue = CRMConstants.ISSUE_STATUS_ACCEPTED;
                                    } else if ("yes_with_note".equalsIgnoreCase(accepted)) {
                                        statusForIssue = CRMConstants.ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION;
                                    }
                                    try {
                                        wbo = new WebBusinessObject();
                                        wbo.setAttribute("parentId", issueId);
                                        wbo.setAttribute("businessObjectId", clientComplaintId);
                                        wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
                                        wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                                        wbo.setAttribute("notes", "Auto Finish Ticket");
                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                        wbo.setAttribute("issueTitle", "UL");
                                        wbo.setAttribute("statusNote", "Auto Finish Ticket");
                                        wbo.setAttribute("cuseDescription", "UL");
                                        wbo.setAttribute("actionTaken", "Auto Finish Ticket");
                                        wbo.setAttribute("preventionTaken", "UL");

                                        commented = commented && issueStatusMgr.changeStatus(wbo, localPersisUser, null);
                                        if (projectMgr.isManager(createdBy)) {
                                            wbo = new WebBusinessObject();
                                            wbo.setAttribute("parentId", issueId);
                                            wbo.setAttribute("businessObjectId", clientComplaintId);
                                            wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
                                            wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                                            wbo.setAttribute("notes", "Auto Close Ticket");
                                            wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                            wbo.setAttribute("issueTitle", "UL");
                                            wbo.setAttribute("statusNote", "Auto Close Ticket");
                                            wbo.setAttribute("cuseDescription", "UL");
                                            wbo.setAttribute("actionTaken", "Auto Close Ticket");
                                            wbo.setAttribute("preventionTaken", "UL");

                                            commented = commented && issueStatusMgr.changeStatus(wbo, localPersisUser, null);
                                            WebBusinessObject managerOfQualityManagement = UserMgr.getInstance().getOnSingleKey(projectMgr.getManagerOfQualityManagementDepartment());
                                            String qualityReqSubject = "طلب تسليم جودة";
                                            String qualityReqComment = "��� ����� ����";
                                            try {
                                                if (managerOfQualityManagement != null) {
                                                    clientComplaintsMgr.tellManager(managerOfQualityManagement, issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY, qualityReqSubject, qualityReqComment, localPersisUser);
                                                }
                                            } catch (NoUserInSessionException ex) {
                                                logger.error(ex);
                                            } catch (SQLException ex) {
                                                logger.error(ex);
                                            }
                                        }
                                        if (commented) {
                                            request.setAttribute("status", "OK");
                                        } else {
                                            request.setAttribute("status", "Failed");
                                        }
                                    } catch (SQLException ex) {
                                        logger.error(ex);
                                    }
                                } else {
                                    request.setAttribute("status", "OK");
                                }

                                // insert issue status
                                statusForIssue = CRMConstants.ISSUE_STATUS_NEW;
                                wbo = new WebBusinessObject();
                                wbo.setAttribute("parentId", "UL");
                                wbo.setAttribute("businessObjectId", issueId);
                                wbo.setAttribute("statusCode", statusForIssue);
                                wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_ISSUE);
                                wbo.setAttribute("notes", "طلب تسليم");
                                wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                wbo.setAttribute("issueTitle", "UL");
                                wbo.setAttribute("statusNote", "طلب تسليم");
                                wbo.setAttribute("cuseDescription", "UL");
                                wbo.setAttribute("actionTaken", "UL");
                                wbo.setAttribute("preventionTaken", "UL");
                                commented = commented && issueStatusMgr.changeStatus(wbo, localPersisUser, null);
                                commented = commented && issueMgr.updateCurrentStatus(issueId, statusForIssue);
                                if (commented) {
                                    if (CRMConstants.ISSUE_STATUS_REJECTED.equalsIgnoreCase(statusForIssue)) {
                                        alertMgr.saveObjectRejectTicket(clientComplaintId, createdBy);
                                    } else {
                                        alertMgr.saveObjectAcceptTicket(clientComplaintId, createdBy);
                                    }
                                    request.setAttribute("status", "OK");
                                } else {
                                    request.setAttribute("status", "Failed");
                                }
                            } else {
                                request.setAttribute("status", "Failed");
                            }
                            IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("issueID", issueId);
                            wbo.setAttribute("projectID", projectID);
                            wbo.setAttribute("engineerID", engineerID);
                            issueProjectMgr.saveObject(wbo);

                            complaintsMgr = ClientComplaintsMgr.getInstance();
//                            // To Notify Project Manager
//                            tradeMgr = TradeMgr.getInstance();
//                            ArrayList<WebBusinessObject> tradesList = new ArrayList<WebBusinessObject>(tradeMgr.getOnArbitraryKey("PM", "key2")); //Code for Project Manager PM
//                            if (!tradesList.isEmpty()) {
//                                String tradeID = (String) tradesList.get(0).getAttribute("tradeId");
//                                userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
//                                ArrayList<WebBusinessObject> userProjectsList = new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryDoubleKeyOracle(projectID, "key2", tradeID, "key4"));
//                                if (!userProjectsList.isEmpty()) {
//                                    managerId = (String) userProjectsList.get(0).getAttribute("userId");
//                                    if (managerId != null && !managerId.isEmpty()) {
//                                        complaintsMgr.createNotificationComplaint(clientComplaintId, loggegUserId, managerId, subject, "");
//                                    }
//                                }
//                            }
//
//                            // To Notify Top Manager
//                            if (metaMgr.getProjectsDepartmentID() != null) {
//                                WebBusinessObject projectWbo = projectMgr.getOnSingleKey(metaMgr.getProjectsDepartmentID());
//                                if (projectWbo != null && projectWbo.getAttribute("optionOne") != null) {
//                                    managerId = (String) projectWbo.getAttribute("optionOne");
//                                    if (managerId != null && !managerId.isEmpty()) {
//                                        complaintsMgr.createNotificationComplaint(clientComplaintId, createdBy, managerId, subject, "");
//                                    }
//                                }
//                            }
//
                            // To Notify All Users Whose Have TechOffice Role
                            UserCompanyProjectsMgr companyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                            List<String> userIds = companyProjectsMgr.getUserIdsByTrade(CRMConstants.TRADE_TECHOFFICE_ID);
                            for (String id : userIds) {
                                complaintsMgr.createNotificationComplaint(clientComplaintId, createdBy, id, subject, "");
                            }
//                            if (!tradesList.isEmpty()) {
//                                String tradeID = (String) tradesList.get(0).getAttribute("tradeId");
//                                userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
//                                ArrayList<WebBusinessObject> userProjectsList = new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryDoubleKeyOracle(projectID, "key2", tradeID, "key4"));
//                                if (!userProjectsList.isEmpty()) {
//                                    managerId = (String) userProjectsList.get(0).getAttribute("userId");
//                                    if (managerId != null && !managerId.isEmpty()) {
//                                        complaintsMgr.createNotificationComplaint(clientComplaintId, createdBy, managerId, subject, "");
//                                    }
//                                }
//                            }

                            // to save attched file
                            IssueDocumentMgr documentMgr = IssueDocumentMgr.getInstance();
                            if (!files.isEmpty()) {
                                String documentTitle = "طلب تسليم";
                                String documentType = files.get(0).getFileName();
                                documentType = documentType.replaceAll("\\.", "#");
                                documentType = documentType.substring(documentType.lastIndexOf("#") + 1);
                                WebBusinessObject fileDescriptor = FileMgr.getInstance().getObjectFromCash(documentType);
                                String metaType = (String) fileDescriptor.getAttribute("metaType");
                                String description = "طلب تسليم";
                                String loggegUserName = securityUser.getFullName();

                                documentMgr.saveDocument(documentTitle, issueId, CRMConstants.OBJECT_TYPE_ISSUE, description, new Timestamp(Calendar.getInstance().getTimeInMillis()), metaType, documentType, createdBy, (String) localPersisUser.getAttribute("userName"), "1401523812151", files.get(0));
//                                alertMgr.saveObjectAttachFile(clientComplaintId, createdBy);
                            }
                        } else {
                            servedPage = "SearchServlet?op=searchForVendor&searchBy=";
                            request.setAttribute("status", "no");
                            request.setAttribute("issueSaved", "no");
                            this.forward(servedPage, request, response);
                        }

                        // (begin) issue depend on another one
                        dependOnID = request.getParameter("dependOnID");
                        if (dependOnID != null) {
                            IssueDependenceMgr issueDependenceMgr = IssueDependenceMgr.getInstance();
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("issueID", issueId);
                            wbo.setAttribute("dependOnID", dependOnID);
                            wbo.setAttribute("createdBy", localPersisUser.getAttribute("userId"));
                            wbo.setAttribute("dependType", request.getParameter("dependType"));
                            issueDependenceMgr.saveObject(wbo);
                        }
                        // (end)
                        servedPage = "docs/requests/request_extradition.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("projectsList", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4")));
                        request.setAttribute("projectID", projectID);
                        request.setAttribute("issueSaved", "ok");
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("client", client);
                        request.setAttribute("engineersList", userMgr.getAllEngineers());
                        request.setAttribute("engineerID", engineerID);
                        this.forwardToServedPage(request, response);
                        break;

                    case 108:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        issueId = request.getParameter("issueId");
                        String showPopup = request.getParameter("showPopup");
                        clientComplaintId = request.getParameter("clientComplaintId");
                        issue = issueMgr.getOnSingleKey(issueId);
                        request.setAttribute("issue", issue);
                        request.setAttribute("clientComplaint", ClientComplaintsMgr.getInstance().getOnSingleKey(clientComplaintId));
                        request.setAttribute("comments", CommentsMgr.getInstance().getCommentsByObjectId(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION));
                        request.setAttribute("comments2", CommentsMgr.getInstance().getCommentsByObjectId(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY));
                        request.setAttribute("comments3", CommentsMgr.getInstance().getCommentsByObjectId(issueId, CRMConstants.COMMENT_TYPE_ID_PROJECT_MANAGER));
                        IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
                        WebBusinessObject issueProjectWbo = issueProjectMgr.getOnSingleKey("key1", issueId);
                        if (issueProjectWbo != null) {
                            request.setAttribute("projectWbo", projectMgr.getOnSingleKey((String) issueProjectWbo.getAttribute("projectID")));
                            request.setAttribute("projectID", (String) issueProjectWbo.getAttribute("projectID"));
                            request.setAttribute("engineerWbo", userMgr.getOnSingleKey((String) issueProjectWbo.getAttribute("option1")));
                        }
                        request.setAttribute("dependOnIssuesList", issueMgr.getAllIssuesDepOnIssue(issueId));
                        IssueDependenceMgr issueDependenceMgr = IssueDependenceMgr.getInstance();
                        temp = issueDependenceMgr.getOnSingleKey("key2", issueId);
                        if (temp != null) {
                            issue = issueMgr.getOnSingleKey((String) temp.getAttribute("dependOnID"));
                            issue.setAttribute("option1", temp.getAttribute("option1"));
                            request.setAttribute("dependWbo", issue);
                        }
                        if (showPopup != null && showPopup.equalsIgnoreCase("true")) {
                            request.setAttribute("clientComplaint", ClientComplaintsMgr.getInstance().getClientComplaintByIssueAndType(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION));
                            request.setAttribute("clientComplaintQ", ClientComplaintsMgr.getInstance().getClientComplaintByIssueAndType(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY));
                            WebBusinessObject depManagerWbo = projectMgr.getManagerByEmployee((String) issue.getAttribute("userId"));
                            if (depManagerWbo != null && depManagerWbo.getAttribute("optionOne") != null) {
                                request.setAttribute("managerWbo", userMgr.getOnSingleKey((String) depManagerWbo.getAttribute("optionOne")));
                            } else if (userMgr.getIsManager((String) localPersistentUser.getAttribute("userId")).equals("1")) {
                                request.setAttribute("managerWbo", userMgr.getOnSingleKey(loggegUserId));
                            }
                            request.setAttribute("source", userMgr.getOnSingleKey((String) issue.getAttribute("userId")));
                            servedPage = "docs/requests/request_stages_popup.jsp";
                            this.forward(servedPage, request, response);
                        } else {
                            servedPage = "docs/requests/request_stages.jsp";
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                        }
                        break;

                    case 109:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        issueId = request.getParameter("issueId");
                        clientComplaintId = request.getParameter("clientComplaintId");
                        accepted = request.getParameter("accepted");

                        issueStatusMgr = IssueStatusMgr.getInstance();
                        issueProjectMgr = IssueProjectMgr.getInstance();
                        issueProjectWbo = issueProjectMgr.getOnSingleKey("key1", issueId);
                        if (issueProjectWbo != null) {
                            request.setAttribute("projectWbo", projectMgr.getOnSingleKey((String) issueProjectWbo.getAttribute("projectID")));
                        }

                        // insert comment
                        CommentsMgr commentsMgr = CommentsMgr.getInstance();
                        String createdBy = (String) localPersistentUser.getAttribute("userId");
                        String commentType = "10";
                        comment = request.getParameter("comment");
                        String objectType = CRMConstants.OBJECT_TYPE_ISSUE;
                        String option1 = request.getParameter("clientComplaintType");

                        wbo = new WebBusinessObject();
                        wbo.setAttribute("createdBy", createdBy);
                        wbo.setAttribute("objectId", issueId);
                        wbo.setAttribute("commentType", commentType);
                        wbo.setAttribute("comment", comment);
                        wbo.setAttribute("objectType", objectType);
                        wbo.setAttribute("option1", option1);

                        boolean commented = commentsMgr.saveComment(wbo);
//                        alertMgr.saveObjectAddReviewComment(clientComplaintId, createdBy);
                        if (commented) {
                            String statusForIssue = CRMConstants.ISSUE_STATUS_REJECTED;
                            if ("yes".equalsIgnoreCase(accepted) || "yes_with_note".equalsIgnoreCase(accepted) || (request.getParameter("numberOfComments").equalsIgnoreCase("" + CRMConstants.ISSUE_NUMBER_OF_COMMENTS))) {
                                if ("yes".equalsIgnoreCase(accepted)) {
                                    statusForIssue = CRMConstants.ISSUE_STATUS_ACCEPTED;
                                } else if ("yes_with_note".equalsIgnoreCase(accepted)) {
                                    statusForIssue = CRMConstants.ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION;
                                }

                                try {

                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("parentId", issueId);
                                    wbo.setAttribute("businessObjectId", clientComplaintId);
                                    wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
                                    wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                                    wbo.setAttribute("notes", ("yes".equalsIgnoreCase(accepted)) ? request.getParameter("comment") : "Accepted with note");
                                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                    wbo.setAttribute("issueTitle", "UL");
                                    wbo.setAttribute("statusNote", ("yes".equalsIgnoreCase(accepted)) ? request.getParameter("comment") : "Accepted with note");
                                    wbo.setAttribute("cuseDescription", "UL");
                                    wbo.setAttribute("actionTaken", "Finish Ticket");
                                    wbo.setAttribute("preventionTaken", "UL");
                                    commented = commented && issueStatusMgr.changeStatus(wbo, localPersistentUser, null);

                                    if (projectMgr.isManager(createdBy)) {
                                        wbo = new WebBusinessObject();
                                        wbo.setAttribute("parentId", issueId);
                                        wbo.setAttribute("businessObjectId", clientComplaintId);
                                        wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
                                        wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                                        wbo.setAttribute("notes", "Auto Close Ticket");
                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                        wbo.setAttribute("issueTitle", "UL");
                                        wbo.setAttribute("statusNote", "Auto Close Ticket");
                                        wbo.setAttribute("cuseDescription", "UL");
                                        wbo.setAttribute("actionTaken", "Auto Close Ticket");
                                        wbo.setAttribute("preventionTaken", "UL");

                                        commented = commented && issueStatusMgr.changeStatus(wbo, localPersistentUser, null);
                                        WebBusinessObject managerOfQualityManagement = UserMgr.getInstance().getOnSingleKey(projectMgr.getManagerOfQualityManagementDepartment());
                                        String qualityReqSubject = "��� ����� ����";
                                        String qualityReqComment = "��� ����� ����";
                                        try {
                                            if (managerOfQualityManagement != null) {
                                                ClientComplaintsMgr.getInstance().tellManager(managerOfQualityManagement, issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY, qualityReqSubject, qualityReqComment, localPersistentUser);
                                            }
                                        } catch (NoUserInSessionException ex) {
                                            logger.error(ex);
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        }
                                    }
                                    if (commented) {
                                        request.setAttribute("status", "OK");
                                    } else {
                                        request.setAttribute("status", "Failed");
                                    }
                                } catch (SQLException ex) {
                                    logger.error(ex);
                                }
                            } else {
                                request.setAttribute("status", "OK");
                            }

                            // insert issue status
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("parentId", "UL");
                            wbo.setAttribute("businessObjectId", issueId);
                            wbo.setAttribute("statusCode", statusForIssue);
                            wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_ISSUE);
                            wbo.setAttribute("notes", request.getParameter("comment"));
                            wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                            wbo.setAttribute("issueTitle", "UL");
                            wbo.setAttribute("statusNote", request.getParameter("comment"));
                            wbo.setAttribute("cuseDescription", "UL");
                            wbo.setAttribute("actionTaken", "UL");
                            wbo.setAttribute("preventionTaken", "UL");
                            commented = commented && issueStatusMgr.changeStatus(wbo, localPersistentUser, null);
                            commented = commented && issueMgr.updateCurrentStatus(issueId, statusForIssue);
                            if (commented) {
                                if (CRMConstants.ISSUE_STATUS_REJECTED.equalsIgnoreCase(statusForIssue)) {
                                    alertMgr.saveObjectRejectTicket(clientComplaintId, createdBy);
                                } else {
                                    alertMgr.saveObjectAcceptTicket(clientComplaintId, createdBy);
                                }
                                request.setAttribute("status", "OK");
                            } else {
                                request.setAttribute("status", "Failed");
                            }
                        }
                        this.forward("/IssueServlet?op=requestComments&issueId=" + issueId + "&clientComplaintId=" + clientComplaintId, request, response);
                        break;

                    case 110:
                        issueId = request.getParameter("issueId");
                        wbo = issueMgr.getRequestExtraditionReport(issueId);
                        Vector issues = new Vector();
                        issues.add(wbo);
                        Map parameters = new HashMap();
                        Tools.createPdfReport("RequestExtraditionReport", parameters, issues, getServletConfig().getServletContext(), response, request);
                        break;

                    case 111:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
                        issueId = request.getParameter("issueId");
                        clientComplaintId = request.getParameter("clientComplaintId");
                        accepted = request.getParameter("accepted");
                        projectID = request.getParameter("projectID");
                        issueStatusMgr = IssueStatusMgr.getInstance();

                        commentsMgr = CommentsMgr.getInstance();
                        wbo = new WebBusinessObject();
                        createdBy = (String) localPersistentUser.getAttribute("userId");
                        commentType = "10";
                        comment = request.getParameter("comment");
                        objectType = CRMConstants.OBJECT_TYPE_ISSUE;
                        option1 = request.getParameter("clientComplaintType");

                        wbo.setAttribute("createdBy", createdBy);
                        wbo.setAttribute("objectId", issueId);
                        wbo.setAttribute("commentType", commentType);
                        wbo.setAttribute("comment", comment);
                        wbo.setAttribute("objectType", objectType);
                        /* persist Here */
                        commented = commentsMgr.saveComment(wbo);
                        if (commented) {
                            String statusForIssue = CRMConstants.ISSUE_STATUS_REJECTED;
                            if ("yes".equalsIgnoreCase(accepted) || "yes_with_note".equalsIgnoreCase(accepted) || (request.getParameter("numberOfComments").equalsIgnoreCase("" + CRMConstants.ISSUE_NUMBER_OF_COMMENTS))) {
                                if ("yes".equalsIgnoreCase(accepted)) {
                                    statusForIssue = CRMConstants.ISSUE_STATUS_ACCEPTED;
                                } else if ("yes_with_note".equalsIgnoreCase(accepted)) {
                                    statusForIssue = CRMConstants.ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION;
                                }

                                try {
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("parentId", issueId);
                                    wbo.setAttribute("businessObjectId", clientComplaintId);
                                    wbo.setAttribute("statusCode", "yes".equalsIgnoreCase(accepted) ? CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED : CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
                                    wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                                    wbo.setAttribute("notes", ("yes".equalsIgnoreCase(accepted)) ? request.getParameter("comment") : "Accepted with note");
                                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                    wbo.setAttribute("issueTitle", "UL");
                                    wbo.setAttribute("statusNote", ("yes".equalsIgnoreCase(accepted)) ? request.getParameter("comment") : "Accepted with note");
                                    wbo.setAttribute("cuseDescription", "UL");
                                    wbo.setAttribute("actionTaken", "Finish Ticket");
                                    wbo.setAttribute("preventionTaken", "UL");

                                    commented = commented && issueStatusMgr.changeStatus(wbo, localPersistentUser, ActionEvent.getClientComplaintsActionEvent());
                                    if (commented) {
                                        request.setAttribute("status", "OK");
                                    } else {
                                        request.setAttribute("status", "Failed");
                                    }
                                } catch (SQLException ex) {
                                    logger.error(ex);
                                }
                            } else {
                                request.setAttribute("status", "OK");
                            }

                            // insert issue status
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("parentId", "UL");
                            wbo.setAttribute("businessObjectId", issueId);
                            wbo.setAttribute("statusCode", statusForIssue);
                            wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_ISSUE);
                            wbo.setAttribute("notes", request.getParameter("comment"));
                            wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                            wbo.setAttribute("issueTitle", "UL");
                            wbo.setAttribute("statusNote", request.getParameter("comment"));
                            wbo.setAttribute("cuseDescription", "UL");
                            wbo.setAttribute("actionTaken", "UL");
                            wbo.setAttribute("preventionTaken", "UL");
                            commented = commented && issueStatusMgr.changeStatus(wbo, localPersistentUser, null);
                            commented = commented && issueMgr.updateCurrentStatus(issueId, statusForIssue);
                            alertMgr.saveObjectAddReviewComment(clientComplaintId, createdBy);
                            if (commented) {
                                if (CRMConstants.ISSUE_STATUS_REJECTED.equalsIgnoreCase(statusForIssue)) {
                                    alertMgr.saveObjectRejectTicket(issueId, loggegUserId);
                                } else {
                                    alertMgr.saveObjectAcceptTicket(issueId, loggegUserId);
                                }
                                request.setAttribute("status", "OK");
                            } else {
                                request.setAttribute("status", "Failed");
                            }

                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            // send to techoffice rule
                            if (CRMConstants.ISSUE_STATUS_ACCEPTED.equalsIgnoreCase(statusForIssue)) {
//                                // To Users Whose Have TechOffice Rule
//                                UserCompanyProjectsMgr companyProjectsMgr = UserCompanyProjectsMgr.getInstance();
//                                List<String> userIds = companyProjectsMgr.getUserIdsByTrade(CRMConstants.TRADE_TECHOFFICE_ID);
//                                issueId = request.getParameter("issueId");
//                                businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
//                                comments = request.getParameter("comment");
//                                ticketType = CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_SUCCESSFUL;
//                                notes = "����� ���� �� " + securityUser.getFullName();
//                                subject = notes;
//                                String lastClientComplaintOfTypeRequestExtradition = clientComplaintsMgr.getLastTicketTypeOnIssue(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION);
//                                // new to send to sender
//                                wbo = clientComplaintsMgr.getCurrentSenderAndResponsible(lastClientComplaintOfTypeRequestExtradition);
//                                if (wbo != null && wbo.getAttribute("senderId") != null) {
//                                    String lastSender = (String) wbo.getAttribute("senderId");
//                                    clientComplaintsMgr.createMailInBox(loggegUserId, lastSender, issueId, ticketType, businessId, comments, subject, notes);
//                                }
//                                //
//                                for (String id : userIds) {
//                                    clientComplaintsMgr.createMailInBox(loggegUserId, id, issueId, ticketType, businessId, comments, subject, notes);
//                                }
                            } else if (CRMConstants.ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION.equalsIgnoreCase(statusForIssue) || (CRMConstants.ISSUE_STATUS_REJECTED.equalsIgnoreCase(statusForIssue) && request.getParameter("numberOfComments").equalsIgnoreCase("" + CRMConstants.ISSUE_NUMBER_OF_COMMENTS))) {
                                // when this issue reject or accept with note
                                issueId = request.getParameter("issueId");
                                businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
                                comments = request.getParameter("comment");
                                ticketType = CRMConstants.CLIENT_COMPLAINT_TYPE_RE_REQUEST_EXTRADITION;
                                notes = "����� ����� ��  " + securityUser.getFullName() + " ���� ";
                                notes += (CRMConstants.ISSUE_STATUS_REJECTED.equalsIgnoreCase(statusForIssue)) ? "�����" : " ����� ��������";
                                subject = notes;

                                String lastClientComplaintOfTypeRequestExtradition = clientComplaintsMgr.getLastTicketTypeOnIssue(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION);
                                wbo = clientComplaintsMgr.getCurrentSenderAndResponsible(lastClientComplaintOfTypeRequestExtradition);
                                if (wbo != null && wbo.getAttribute("senderId") != null) {
                                    String lastSender = (String) wbo.getAttribute("senderId");
                                    clientComplaintsMgr.createMailInBox(loggegUserId, lastSender, issueId, ticketType, businessId, comments, subject, notes);
                                }

//                                // tell techoffice when issue is rejected
//                                // To Notify All Users Whose Have TechOffice Rule
//                                complaintsMgr = ClientComplaintsMgr.getInstance();
//                                UserCompanyProjectsMgr companyProjectsMgr = UserCompanyProjectsMgr.getInstance();
//                                List<String> userIds = companyProjectsMgr.getUserIdsByTrade(CRMConstants.TRADE_TECHOFFICE_ID);
//                                for (String id : userIds) {
//                                    complaintsMgr.createNotificationComplaint(clientComplaintId, loggegUserId, id, subject, "");
//                                }
//                                tradeMgr = TradeMgr.getInstance();
//                                ArrayList<WebBusinessObject> tradesList = new ArrayList<WebBusinessObject>(tradeMgr.getOnArbitraryKey("PM", "key2")); //Code for Project Manager PM
//                                if (!tradesList.isEmpty()) {
//                                    String tradeID = (String) tradesList.get(0).getAttribute("tradeId");
//                                    userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
//                                    ArrayList<WebBusinessObject> userProjectsList = new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryDoubleKeyOracle(projectID, "key2", tradeID, "key4"));
//                                    if (!userProjectsList.isEmpty()) {
//                                        managerId = (String) userProjectsList.get(0).getAttribute("userId");
//                                        if (managerId != null && !managerId.isEmpty()) {
//                                            complaintsMgr.createNotificationComplaint(clientComplaintId, loggegUserId, managerId, subject, "");
//                                        }
//                                    }
//                                }
                            }
                        } else {
                            request.setAttribute("status", "Failed");
                        }
                        this.forward("IssueServlet?op=requestComments&issueId=" + issueId + "&showPopup=true", request, response);
                        break;

                    case 112:
                        out = response.getWriter();
                        statusWbo = new WebBusinessObject();
                        statusWbo.setAttribute("status", "failed");
                        WebBusinessObject alertWbo = alertMgr.getOnSingleKey(request.getParameter("id"));
                        if (alertWbo != null) {
                            if (alertMgr.changeStatus(request.getParameter("id"), request.getParameter("status"),
                                    request.getParameter("note"), request.getParameter("actionCode"))) {
                                statusWbo.setAttribute("status", "Ok");
                                if (request.getParameter("status").equals(CRMConstants.NOTIFICATION_ACTION)) {
                                    commentsMgr = CommentsMgr.getInstance();
                                    commentsMgr.saveComment((String) alertWbo.getAttribute("businessObjId"), loggegUserId, "0", "2", request.getParameter("note"), "UL", "UL");
                                    alertMgr.saveObjectAddReviewComment((String) alertWbo.getAttribute("businessObjId"), loggegUserId);
                                }
                            }
                        }
                        out.write(Tools.getJSONObjectAsString(statusWbo));
                        break;

                    case 113:
                        out = response.getWriter();
                        alertMgr = AlertMgr.getInstance();
                        alertWbo = alertMgr.getOnSingleKey(request.getParameter("id"));
                        WebBusinessObject actionWbo = projectMgr.getOnSingleKey((String) alertWbo.getAttribute("option3"));
                        if (actionWbo != null) {
                            alertWbo.setAttribute("actionName", actionWbo.getAttribute("projectName"));
                        }
                        out.write(Tools.getJSONObjectAsString(alertWbo));
                        break;

                    case 114:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        issueId = request.getParameter("issueId");
                        clientComplaintId = request.getParameter("clientComplaintId");
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        String statusForIssue = CRMConstants.ISSUE_STATUS_REJECTED;
                        // insert issue status
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", "UL");
                        wbo.setAttribute("businessObjectId", issueId);
                        wbo.setAttribute("statusCode", statusForIssue);
                        wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_ISSUE);
                        wbo.setAttribute("notes", "Reject By Manager");
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "Reject By Manager");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        issueStatusMgr.changeStatus(wbo, localPersistentUser, ActionEvent.getClientComplaintsActionEvent());
                        issueMgr.updateCurrentStatus(issueId, statusForIssue);
                        alertMgr.saveObjectRejectTicket(clientComplaintId, loggegUserId);
                        alertMgr.saveObjectRejectTicket(clientComplaintId, (String) issueMgr.getOnSingleKey(issueId).getAttribute("userId"));
                        this.forward("IssueServlet?op=requestComments&issueId=" + issueId + "&showPopup=true", request, response);
                        break;

                    case 115:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        issueId = request.getParameter("issueId");
                        clientComplaintId = request.getParameter("clientComplaintQId");
                        commentsMgr = CommentsMgr.getInstance();
                        wbo = new WebBusinessObject();
                        createdBy = (String) localPersistentUser.getAttribute("userId");
                        commentType = "10";
                        comment = request.getParameter("comment");
                        objectType = CRMConstants.OBJECT_TYPE_ISSUE;
                        option1 = request.getParameter("clientComplaintType");

                        wbo.setAttribute("createdBy", createdBy);
                        wbo.setAttribute("objectId", issueId);
                        wbo.setAttribute("commentType", commentType);
                        wbo.setAttribute("comment", comment);
                        wbo.setAttribute("objectType", objectType);
                        wbo.setAttribute("option1", option1);

                        commentsMgr.saveComment(wbo);
                        alertMgr.saveObjectAddReplayComment(clientComplaintId, loggegUserId);
                        this.forward("IssueServlet?op=requestComments&showPopup=true", request, response);
                        break;

                    case 116:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        userId = request.getParameter("userId");
                        comment = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        ticketType = (String) request.getParameter("ticketType");
                        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                        if (request.getSession().getAttribute("issueId") != null) {
                            request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                        } else {
                            request.setAttribute("issueId", request.getParameter("issueId"));
                        }
                        request.setAttribute("userId", userId);
                        request.setAttribute("comment", comment);
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("ticketType", ticketType);
                        request.setAttribute("subject", request.getParameter("subject"));
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        isManager = projectMgr.isManager(userId);
                        String joborderDate = request.getParameter("joborderDate");
                        request.setAttribute("SLA", request.getParameter("SLA"));
                        request.setAttribute("CRC", request.getParameter("CRC"));
                        request.setAttribute("equClassID", request.getParameter("equClassID"));
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        AppointmentNotificationMgr appointmentNotificationMgr = AppointmentNotificationMgr.getInstance();
                        boolean maxVisit = appointmentNotificationMgr.getVisitsCountsForWorkerByDate(sdf.parse(joborderDate), userId) >= Integer.parseInt(metaMgr.getMaxVisitNo());
                        clientCompId = null;
                        if (isManager) {
                            clientCompId = clientComplaintsMgr.saveClientComplaint2(request, localPersistentUser);
                        }
                        /* if (maxVisit) {
                         wbo.setAttribute("status", "hasMaxVisit");
                         } else */
                        if (!isManager) {
                            wbo.setAttribute("status", "notManager");
                        } else if (clientCompId != null
                                && appointmentMgr.saveJoborder(request, session, clientCompId)) {
                            wbo.setAttribute("status", "ok");
                            wbo.setAttribute("clientCompId", clientCompId);
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                        clientComplaintsMgr.updateClientComplaintsType();
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 117:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        userId = request.getParameter("userId");
                        comment = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        ticketType = (String) request.getParameter("ticketType");
                        appointmentMgr = AppointmentMgr.getInstance();
                        if (request.getSession().getAttribute("issueId") != null) {
                            request.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                        } else {
                            request.setAttribute("issueId", "UL");
                        }
                        request.setAttribute("userId", userId);
                        request.setAttribute("comment", comment);
                        request.setAttribute("clientId", clientId);
                        request.setAttribute("ticketType", ticketType);
                        boolean hasManager = false;
                        joborderDate = request.getParameter("joborderDate");
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        appointmentNotificationMgr = AppointmentNotificationMgr.getInstance();
                        maxVisit = appointmentNotificationMgr.getVisitsCountsForWorkerByDate(sdf.parse(joborderDate), userId) >= Integer.parseInt(metaMgr.getMaxVisitNo());
                        managerId = "";
                        isManager = projectMgr.isManager(userId);
                        if (isManager) {
                            hasManager = true;
                            managerId = userId;
                        } else {
                            WebBusinessObject managerWbo = projectMgr.getManagerByEmployee(userId);
                            if (managerWbo != null) {
                                hasManager = true;
                                managerId = (String) managerWbo.getAttribute("optionOne");
                            }
                        }
                        data = null;
                        if (hasManager && !maxVisit) {
                            request.setAttribute("managerId", managerId);
                            request.setAttribute("comment", "Job Order");
                            request.setAttribute("clientId", clientId);
                            request.setAttribute("subject", "Job Order");
                            request.setAttribute("ticketType", ticketType);
                            request.setAttribute("orderUrgency", "Job Order");
                            request.setAttribute("category", request.getParameter("category"));
                            request.setAttribute("subject", request.getAttribute("subject"));
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();

                            data = clientComplaintsMgr.saveClientComplaint3(request, localPersistentUser);
                            Thread.sleep(300);
                            if (data != null) {
                                issueId = (String) data.getAttribute("issueId");
                                compId = (String) data.getAttribute("compId");

                                ClientComplaintsMgr clientComplaintsMgr2 = ClientComplaintsMgr.getInstance();

                                wbo = (WebBusinessObject) clientComplaintsMgr2.getOnSingleKey(compId);
                                wbo.setAttribute("managerId", managerId);
                                wbo.setAttribute("clientCompId", compId);
                                wbo.setAttribute("employeeId", userId);
                                wbo.setAttribute("complaintComment", "Job Order");
                                wbo.setAttribute("compSubject", "Job Order");
                                String responsability = "1";

                                try {

                                    if (clientComplaintsMgr2.distibutionResponsibility3(userId, responsability, wbo, request, session)) {

                                        wbo.setAttribute("status", "Ok");
                                    }
                                } catch (NoUserInSessionException ex) {
                                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                } catch (SQLException ex) {
                                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }

                            }
                        }
                        if (maxVisit) {
                            wbo.setAttribute("status", "hasMaxVisit");
                        } else if (!hasManager) {
                            wbo.setAttribute("status", "hasNoManager");
                        } else if (data != null
                                && appointmentMgr.saveJoborder(request, session, null)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        clientComplaintsMgr.updateClientComplaintsType();
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 118:
                        servedPage = "docs/client/contractor_list.jsp";
                        clientMgr = ClientMgr.getInstance();
                        request.setAttribute("contractorsList", new ArrayList<WebBusinessObject>(clientMgr.getClientByAgeGroupAndNoOrName("100", "", "")));
                        this.forward(servedPage, request, response);
                        break;
                    case 119:
                        departmentManagerId = request.getParameter("departmentId");
                        ArrayList<WebBusinessObject> departments = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(departmentManagerId, "key5"));
                        ArrayList<WebBusinessObject> list = new ArrayList<WebBusinessObject>();
                        if (!departments.isEmpty()) {
                            String departmentID = (String) departments.get(0).getAttribute("projectID");
                            type = request.getParameter("type");

                            if (departmentManagerId != null && !departmentManagerId.isEmpty()) {
                                ArrayList<WebBusinessObject> listTemp = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentID, "key2", type, "key4"));
                                if (listTemp.size() > 0) {
                                    WebBusinessObject wboComplaint = (WebBusinessObject) listTemp.get(0);
                                    list.addAll(projectMgr.getOnArbitraryKeyOracle((String) wboComplaint.getAttribute("projectID"), "key2"));
                                }
                            }
                        }
                        System.out.println("list --> " + list);
                        out = response.getWriter();
                        out.write(Tools.getJSONArrayAsString(list));
                        break;
                    case 120:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        ClientComplaintsSLAMgr clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();
                        WebBusinessObject slaWbo = clientComplaintsSLAMgr.getOnSingleKey(request.getParameter("clientComplaintID"));
                        if (slaWbo == null) {
                            slaWbo = new WebBusinessObject();
                            slaWbo.setAttribute("executionPeriod", request.getParameter("executionPeriod"));
                            slaWbo.setAttribute("clientComplaintID", request.getParameter("clientComplaintID"));
                            slaWbo.setAttribute("createdBy", localPersistentUser.getAttribute("userId"));
                            if (clientComplaintsSLAMgr.saveObject(slaWbo)) {
                                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                                complaint = clientComplaintsMgr.getOnSingleKey(request.getParameter("clientComplaintID"));
                                issue = issueMgr.getOnSingleKey((String) complaint.getAttribute("issueId"));
                                client = clientMgr.getOnSingleKey((String) issue.getAttribute("clientId"));
                                LoggerMgr loggerMgr = LoggerMgr.getInstance();
                                WebBusinessObject loggerWbo = new WebBusinessObject();
                                slaWbo = clientComplaintsSLAMgr.getOnSingleKey(request.getParameter("clientComplaintID"));
                                loggerWbo.setAttribute("objectXml", slaWbo.getObjectAsXML());
                                loggerWbo.setAttribute("realObjectId", request.getParameter("clientComplaintID"));
                                loggerWbo.setAttribute("userId", localPersistentUser.getAttribute("userId"));
                                loggerWbo.setAttribute("objectName", client.getAttribute("name"));
                                loggerWbo.setAttribute("loggerMessage", "Create Period");
                                loggerWbo.setAttribute("eventName", "Create New SLA");
                                loggerWbo.setAttribute("objectTypeId", "10");
                                loggerWbo.setAttribute("eventTypeId", "4");
                                loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                                loggerMgr.saveObject(loggerWbo);
                                wbo.setAttribute("status", "ok");
                                alertMgr.saveObject(request.getParameter("clientComplaintID"), CRMConstants.ALERT_TYPE_ID_CREATE_SLA,
                                        (String) localPersistentUser.getAttribute("userId"));
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        } else {
                            slaWbo.setAttribute("executionPeriod", request.getParameter("executionPeriod"));
                            slaWbo.setAttribute("clientComplaintID", request.getParameter("clientComplaintID"));
                            if (clientComplaintsSLAMgr.updateObject(slaWbo)) {
                                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                                complaint = clientComplaintsMgr.getOnSingleKey(request.getParameter("clientComplaintID"));
                                issue = issueMgr.getOnSingleKey((String) complaint.getAttribute("issueId"));
                                client = clientMgr.getOnSingleKey((String) issue.getAttribute("clientId"));
                                LoggerMgr loggerMgr = LoggerMgr.getInstance();
                                WebBusinessObject loggerWbo = new WebBusinessObject();
                                loggerWbo.setAttribute("objectXml", slaWbo.getObjectAsXML());
                                loggerWbo.setAttribute("realObjectId", request.getParameter("clientComplaintID"));
                                loggerWbo.setAttribute("userId", localPersistentUser.getAttribute("userId"));
                                loggerWbo.setAttribute("objectName", client.getAttribute("name"));
                                loggerWbo.setAttribute("loggerMessage", "Extend Period");
                                loggerWbo.setAttribute("eventName", "Extend");
                                loggerWbo.setAttribute("objectTypeId", "10");
                                loggerWbo.setAttribute("eventTypeId", "3");
                                loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                                loggerMgr.saveObject(loggerWbo);
                                wbo.setAttribute("status", "ok");
                                alertMgr.saveObject(request.getParameter("clientComplaintID"), CRMConstants.ALERT_TYPE_ID_UPDATE_SLA,
                                        (String) localPersistentUser.getAttribute("userId"));
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 121:
                        servedPage = "/docs/requests/Requset_Items_Detailes.jsp";
                        issueId = (String) request.getParameter("issueId");
                        request.setAttribute("IssueId", issueId);
                        this.forward(servedPage, request, response);
                        break;
                    case 122:
                        servedPage = "main.jsp";
                        issueId = request.getParameter("issueId");
                        clientComplaintId = request.getParameter("clientComplaintId");
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        distributionListMgr = DistributionListMgr.getInstance();
                        issueStatusMgr = IssueStatusMgr.getInstance();
                        if (issueId != null && clientComplaintId != null) {
                            if (clientComplaintsMgr.getOnArbitraryKeyOracle(issueId, "key1").size() == 1) {
                                issueMgr.deleteAllIssueData(issueId);
                                issueStatusMgr.deleteOnArbitraryKey(clientComplaintId, "key1");
                            } else {
                                distributionListMgr.deleteOnArbitraryKey(clientComplaintId, "key1");
                                clientComplaintsMgr.deleteOnSingleKey(clientComplaintId);
                                issueStatusMgr.deleteOnArbitraryKey(clientComplaintId, "key1");
                            }
                        }
                        this.forward(servedPage, request, response);
                        break;
                    case 123:
                        out = response.getWriter();
                        issueId = request.getParameter("issueId");
                        wbo = new WebBusinessObject();
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        try {
                            wbo.setAttribute("count", clientComplaintsMgr.getOnArbitraryKeyOracle(issueId, "key1").size());
                        } catch (Exception ex) {
                            Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                        }
                        out.print(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 124:
                        out = response.getWriter();
                        clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();
                        slaWbo = clientComplaintsSLAMgr.getOnSingleKey(request.getParameter("clientComplaintID"));
                        wbo = new WebBusinessObject();
                        try {
                            wbo.setAttribute("executionPeriod", slaWbo != null && slaWbo.getAttribute("executionPeriod") != null ? slaWbo.getAttribute("executionPeriod") : "0");
                        } catch (Exception ex) {
                            Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                        }
                        out.print(Tools.getJSONObjectAsString(wbo));
                        break;

                    case 125:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        commentsMgr = CommentsMgr.getInstance();

                        wbo = new WebBusinessObject();

                        createdBy = (String) localPersistentUser.getAttribute("userId");
                        commentType = "10";
                        objectType = CRMConstants.OBJECT_TYPE_ISSUE;

                        issueId = request.getParameter("issueId");
                        String status = request.getParameter("accepted");
                        comment = request.getParameter("comment");
                        String commentsNo = request.getParameter("numberOfComments");

                        wbo.setAttribute("createdBy", createdBy);
                        wbo.setAttribute("objectId", issueId);
                        wbo.setAttribute("commentType", commentType);
                        wbo.setAttribute("comment", comment);
                        wbo.setAttribute("objectType", objectType);

                        switch (status) {
                            case "yes":
                                wbo.setAttribute("status", CRMConstants.ISSUE_STATUS_ACCEPTED);
                                break;
                            case "yes_with_note":
                                wbo.setAttribute("status", CRMConstants.ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION);
                                break;
                            case "no":
                                wbo.setAttribute("status", CRMConstants.ISSUE_STATUS_REJECTED);
                                break;
                            case "totalyNo":
                                wbo.setAttribute("status", CRMConstants.ISSUE_STATUS_FINAL_REJECTION);
                                break;
                        }

                        commented = commentsMgr.saveCommentAndUpdateIssue(wbo, localPersistentUser);

                        if (commented) {
                            request.setAttribute("status", "OK");
                            if (status.equals("no")) {
                                alertMgr.saveObjectRejectTicket(issueId, createdBy);
                            }
                        } else {
                            request.setAttribute("status", "Failed");
                        }

                        this.forward("IssueServlet?op=requestComments&issueId=" + issueId + "&showPopup=true", request, response);
                        break;
                    case 126:
                        RequestItemsDetailsMgr reqestItemsDetailsMgr = RequestItemsDetailsMgr.getInstance();
                        String issueWorkItemsData = request.getParameter("issueWorkList").replace("\"", "");
                        String workItemsRow[] = issueWorkItemsData.split(",");
                        for (int i = 0; i < workItemsRow.length; i++) {
                            String rawData[] = workItemsRow[i].split(";");
                            String id = rawData[0];
                            String value = rawData[1];
                            String valid = rawData[2];
                            String commnt;
                            try {
                                commnt = rawData[3];
                            } catch (Exception e) {
                                commnt = "";
                            }
                            reqestItemsDetailsMgr.updateIssueWorkItems(id, value, valid, commnt, 1);
                        }
                        break;
                    case 127:
                        servedPage = "/docs/reports/under_followup.jsp";
                        request.setAttribute("issuesList", issueMgr.getUnderFollowup(CRMConstants.NOTES_REVISION_TITLE));
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 128:
                        reqestItemsDetailsMgr = RequestItemsDetailsMgr.getInstance();
                        issueWorkItemsData = request.getParameter("issueWorkList").replace("\"", "");
                        workItemsRow = issueWorkItemsData.split(",");
                        for (int i = 0; i < workItemsRow.length; i++) {
                            String rawData[] = workItemsRow[i].split(";");
                            String id = rawData[0];
                            String value = rawData[1];
                            String valid = rawData[2];
                            String commnt;
                            try {
                                commnt = rawData[3];
                            } catch (Exception e) {
                                commnt = "";
                            }
                            reqestItemsDetailsMgr.updateIssueWorkItems(id, value, valid, commnt, 2);
                        }
                        break;
                    case 129:
                        servedPage = "/docs/QualityAssurance/qulityAgendaWorkUpdateItemsPopUp.jsp";
                        issueId = request.getParameter("issueID");
                        issue = issueMgr.getOnSingleKey(issueId);
                        request.setAttribute("issue", issue);
                        request.setAttribute("issuesID", request.getParameter("issueID"));
                        request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                        break;
                    case 130:
                        issueId = (String) request.getParameter("issueId");
                        issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                        ArrayList<WebBusinessObject> dependOnIssues = issueMgr.getAllIssuesDepOnIssue(issueId);
                        complaints = new Vector();
                        for (WebBusinessObject dependOnWbo : dependOnIssues) {
                            complaints.addAll(issueByComplaintAllCaseMgr.getAllCase((String) dependOnWbo.getAttribute("id")));
                        }
                        servedPage = "/complaints.jsp";

                        request.setAttribute("complaints", complaints);
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;
                    case 131:
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        if (clientComplaintsMgr.updateBusinessCompID(request.getParameter("clientComplaintID"), request.getParameter("newCode"))) {
                            wbo.setAttribute("status", "ok");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 132:
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        if (issueMgr.updateIssueSourceID(request.getParameter("issueID"), request.getParameter("userID"))) {
                            wbo.setAttribute("status", "ok");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 133:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        userId = (String) localPersistentUser.getAttribute("userId");
                        claim_content = request.getParameter("comment");
                        clientId = (String) request.getParameter("clientId");
                        subject = (String) request.getParameter("subject");
                        ticketType = (String) request.getParameter("ticketType");
                        orderUrgency = (String) request.getParameter("orderUrgency");
                        if (request.getSession().getAttribute("issueId") != null) {
                            wbo.setAttribute("issueId", (String) request.getSession().getAttribute("issueId"));
                        } else {
                            wbo.setAttribute("issueId", "UL");
                        }
                        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey((String) wbo.getAttribute("issueId"));
                        if (issueWbo != null) {
                            ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                            StringBuilder subjectBuilder = new StringBuilder();
                            for (WebBusinessObject unitWbo : unitsList) {
                                subjectBuilder.append(" ").append(unitWbo.getAttribute("projectName")).append("\n");
                            }
                            if (subjectBuilder.length() > 0) {
                                subject += subjectBuilder.toString();
                            }
                        }
                        wbo.setAttribute("userId", userId);
                        wbo.setAttribute("userName", localPersistentUser.getAttribute("userName"));
                        wbo.setAttribute("comment", claim_content);
                        wbo.setAttribute("clientId", clientId);
                        wbo.setAttribute("subject", subject);
                        wbo.setAttribute("ticketType", ticketType);
                        wbo.setAttribute("orderUrgency", orderUrgency != null ? orderUrgency : "1");
                        wbo.setAttribute("category", request.getParameter("category"));
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();
                        clientCompId = clientComplaintsMgr.saveClientComplaintWithoutDistribute(wbo);
                        if (clientCompId != null) {
                            slaWbo = new WebBusinessObject();
                            slaWbo.setAttribute("executionPeriod", "0");
                            slaWbo.setAttribute("clientComplaintID", clientCompId);
                            slaWbo.setAttribute("createdBy", localPersistentUser.getAttribute("userId"));
                            slaWbo.setAttribute("option1", subject);
                            slaWbo.setAttribute("option2", claim_content);
                            clientComplaintsSLAMgr.saveObject(slaWbo);
                            wbo.setAttribute("status", "Ok");
                            wbo.setAttribute("clientCompId", clientCompId);
                        } else {
                            wbo.setAttribute("status", "No");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 134:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        String employeeID = request.getParameter("employeeID");
                        String[] clientComplaintIDs = request.getParameterValues("clientComplaintID");
                        if (employeeID != null) {
                            departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle(employeeID, "key5"));
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();
                            WebBusinessObject employeeWbo = userMgr.getOnSingleKey(employeeID);
                            WebBusinessObject clientComplaintsSLAWbo;
                            if (departmentList.isEmpty()) { // an employee
                                manager = userMgr.getManagerByEmployeeID(employeeID);
                                if (manager != null) {
                                    for (String clientComplaintID : clientComplaintIDs) {
                                        clientComplaintsSLAWbo = clientComplaintsSLAMgr.getOnSingleKey(clientComplaintID);
                                        if (clientComplaintsSLAWbo != null) {
                                            subject = (String) clientComplaintsSLAWbo.getAttribute("option1");
                                            comment = (String) clientComplaintsSLAWbo.getAttribute("option2");
                                        } else {
                                            subject = "UL";
                                            comment = "UL";
                                        }
                                        clientComplaintsMgr.distributeComplaint(clientComplaintID, (String) manager.getAttribute("userId"), (String) localPersistentUser.getAttribute("userId"), subject, comment);
                                        try {
                                            Thread.sleep(50);
                                        } catch (InterruptedException ex) {
                                            Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                                        }
                                        clientComplaintsMgr.distributeComplaint(clientComplaintID, employeeID, (String) manager.getAttribute("userId"), subject, comment);
                                        clientComplaintsMgr.changeCurrentOwner(clientComplaintID, employeeID, (String) employeeWbo.getAttribute("fullName"));
                                    }
                                }
                            } else { // a manager
                                for (String clientComplaintID : clientComplaintIDs) {
                                    clientComplaintsSLAWbo = clientComplaintsSLAMgr.getOnSingleKey(clientComplaintID);
                                    if (clientComplaintsSLAWbo != null) {
                                        subject = (String) clientComplaintsSLAWbo.getAttribute("option1");
                                        comment = (String) clientComplaintsSLAWbo.getAttribute("option2");
                                    } else {
                                        subject = "UL";
                                        comment = "UL";
                                    }
                                    clientComplaintsMgr.distributeComplaint(clientComplaintID, employeeID, (String) localPersistentUser.getAttribute("userId"), subject, comment);
                                    clientComplaintsMgr.changeCurrentOwner(clientComplaintID, employeeID, (String) employeeWbo.getAttribute("fullName"));
                                }
                            }
                        }
                        this.forward("main.jsp", request, response);
                        break;
                    case 135:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        servedPage = "/docs/project_manager/quality_inspection.jsp";
                        if (request.getParameter("requestTitle") != null) { // saving
                            issueId = issueMgr.saveCallData(request, session, "issue");
                            issue = issueMgr.getOnSingleKey(issueId);
                            sdf = new SimpleDateFormat("yyyy/MM/dd");
                            java.sql.Date requestDate = new java.sql.Date(sdf.parse(request.getParameter("requestDate")).getTime());
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompId = clientComplaintsMgr.createFutureMailInBox((String) localPersistentUser.getAttribute("userId"), CRMConstants.QUALITY_MANAGER_ID, issueId, "22", (String) issue.getAttribute("businessID"), request.getParameter("comments"), request.getParameter("requestTitle"), requestDate);
                            if (clientCompId != null) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "failed");
                            }
                        }
                        WebBusinessObject qualityInspectionWbo = projectMgr.getOnSingleKey("key3", "inspection");
                        if (qualityInspectionWbo != null) {
                            request.setAttribute("inspectionsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) qualityInspectionWbo.getAttribute("projectID"), "key2")));
                        } else {
                            request.setAttribute("inspectionsList", new ArrayList<WebBusinessObject>());
                        }
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 136:
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        servedPage = "/docs/project_manager/quality_plan.jsp";
                        if (request.getParameterValues("requestedTitle") != null) { // saving
                            QualityPlanMgr qualityPlanMgr = QualityPlanMgr.getInstance();
                            sdf = new SimpleDateFormat("yyyy/MM/dd");
                            request.setAttribute("status", "no");
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("frequencyRate", request.getParameter("frequencyRate"));
                            wbo.setAttribute("frequencyType", request.getParameter("frequencyType"));
                            wbo.setAttribute("requestedTitle", request.getParameter("requestedTitle"));
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
                            wbo.setAttribute("createdBy", localPersistentUser.getAttribute("userId"));
                            wbo.setAttribute("title", request.getParameter("planTitle"));
                            wbo.setAttribute("option2", "UL");
                            wbo.setAttribute("option3", "UL");
                            if (qualityPlanMgr.saveObject(wbo)) {
                                request.setAttribute("status", "ok");
                                request.setAttribute("planCode", qualityPlanMgr.getOnSingleKey((String) wbo.getAttribute("id")).getAttribute("option1"));
                            }
                        }
                        qualityInspectionWbo = projectMgr.getOnSingleKey("key3", "inspection");
                        if (qualityInspectionWbo != null) {
                            request.setAttribute("inspectionsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) qualityInspectionWbo.getAttribute("projectID"), "key2")));
                        } else {
                            request.setAttribute("inspectionsList", new ArrayList<WebBusinessObject>());
                        }
                        request.setAttribute("beginDate", request.getParameter("beginDate"));
                        request.setAttribute("endDate", request.getParameter("endDate"));
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 137:
                        ids = request.getParameter("ids").split(",");
                        String[] issueIDs = new String[ids.length];
                        String[] businessIDs = new String[ids.length];

                        if (request.getParameter("issueIDs") == null) {
                            for (int index = 0; index < ids.length; index++) {
                                clientMgr = ClientMgr.getInstance();
                                wbo = clientMgr.getIssueStatusID(ids[index]);
                                issueIDs[index] = wbo.getAttribute("issueStatusID").toString();
                                businessIDs[index] = wbo.getAttribute("bussinessID").toString();
                            }
                        } else {
                            issueIDs = request.getParameter("issueIDs").split(",");
                            businessIDs = request.getParameter("businessIDs").split(",");
                        }

                        employeeId = request.getParameter("employeeId");
                        subject = request.getParameter("subject");
                        comment = request.getParameter("comment");
                        notes = "����� �����";
                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        wbo = new WebBusinessObject();
                        for (int i = 0; i < ids.length; i++) {
                            businessId = businessIDs[i];
                            clientComplaintId = ids[i];
                            issueId = issueIDs[i];
                            out = response.getWriter();
                            try {
                                complaintsMgr = ClientComplaintsMgr.getInstance();
                                if (complaintsMgr.redistributionCompliant(clientComplaintId, issueId, employeeId, businessId, comment, subject, notes, localPersistentUser)) {
                                    wbo.setAttribute("status", "ok");
                                } else {
                                    wbo.setAttribute("status", "error");
                                }
                            } catch (Exception ex) {
                                wbo.setAttribute("status", "error");
                            }
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    case 138:
                        servedPage = "/docs/issue/addBusinessItems.jsp";

                        issueId = request.getParameter("issueId");

                        request.setAttribute("issueId", issueId);

                        if (request.getParameter("reqType") != null && request.getParameter("reqType").equals("jobOrder")) {
                            String[] bItmID = request.getParameter("requestedItemIdArr").split(",");
                            String[] hours = request.getParameter("hours").split(",");
                            String[] totalRate = request.getParameter("total").split(",");
                            String[] requestedItemNote = request.getParameter("requestedItemNote").split(",");

                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            loggegUserId = (String) loggedUser.getAttribute("userId");

                            for (int i = 0; i < bItmID.length; i++) {
                                issueMgr.addBusinessItm(issueId, bItmID[i], Integer.parseInt(hours[i]), Integer.parseInt(totalRate[i]), requestedItemNote[i], loggegUserId, "4");
                            }
                        } else if (request.getParameter("delItm") != null && request.getParameter("delItm").equals("delItm")) {
                            String itmID = request.getParameter("itmID");
                            issueMgr.deleteBusinessItm(itmID);
                        }

                        String comStatus = issueMgr.getComStatus(issueId);
                        request.setAttribute("comStatus", comStatus);

                        ArrayList<WebBusinessObject> busItmLst = issueMgr.getBusItmLst(issueId, "4");
                        request.setAttribute("busItmLst", busItmLst);

                        WebBusinessObject jobOrderWbo = new WebBusinessObject();
                        jobOrderWbo = issueMgr.jobOrderInfo(issueId);
                        request.setAttribute("jobOrderWbo", jobOrderWbo);

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                        break;

                    case 139:
                        servedPage = "/docs/issue/addMaintenanceItems.jsp";

                        issueId = request.getParameter("issueId");

                        request.setAttribute("issueId", issueId);

                        if (request.getParameter("reqType") != null && request.getParameter("reqType").equals("jobOrder")) {
                            String[] bItmID = request.getParameter("requestedItemIdArr").split(",");
                            String[] hours = request.getParameter("hours").split(",");
                            String[] totalRate = request.getParameter("total").split(",");
                            String[] requestedItemNote = request.getParameter("requestedItemNote").split(",");

                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            loggegUserId = (String) loggedUser.getAttribute("userId");

                            for (int i = 0; i < bItmID.length; i++) {
                                issueMgr.addBusinessItm(issueId, bItmID[i], Integer.parseInt(hours[i]), Integer.parseInt(totalRate[i]), requestedItemNote[i], loggegUserId, "5");
                            }
                        } else if (request.getParameter("delItm") != null && request.getParameter("delItm").equals("delItm")) {
                            String itmID = request.getParameter("itmID");
                            issueMgr.deleteBusinessItm(itmID);
                        }

                        comStatus = issueMgr.getComStatus(issueId);
                        request.setAttribute("comStatus", comStatus);

                        ArrayList<WebBusinessObject> MItmLst = issueMgr.getBusItmLst(issueId, "5");
                        request.setAttribute("MItmLst", MItmLst);

                        jobOrderWbo = new WebBusinessObject();
                        jobOrderWbo = issueMgr.jobOrderInfo(issueId);
                        request.setAttribute("jobOrderWbo", jobOrderWbo);

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                        break;

                    case 140:
                        servedPage = "/docs/issue/jobOrderInvoice.jsp";

                        issueId = request.getParameter("issueId");
                        String clientID = request.getParameter("clientID");

                        WebBusinessObject clientWbo = new WebBusinessObject();

                        if (clientID != null) {
                            clientWbo = clientMgr.getOnSingleKey(clientID);
                        }

                        busItmLst = new ArrayList<WebBusinessObject>();
                        MItmLst = new ArrayList<WebBusinessObject>();
                        ArrayList<WebBusinessObject> sprPrtLst = new ArrayList<WebBusinessObject>();
                        jobOrderWbo = new WebBusinessObject();

                        if (issueId != null) {
                            jobOrderWbo = issueMgr.jobOrderInfo(issueId);
                            busItmLst = issueMgr.getBusItmLst(issueId, "4");
                            MItmLst = issueMgr.getBusItmLst(issueId, "5");
                            sprPrtLst = issueMgr.getBusItmLst(issueId, "7");
                        }

                        Calendar cal = Calendar.getInstance();
                        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        String nowTime = sdf.format(cal.getTime());

                        request.setAttribute("clientWbo", clientWbo);
                        request.setAttribute("jobOrderWbo", jobOrderWbo);
                        request.setAttribute("busItmLst", busItmLst);
                        request.setAttribute("MItmLst", MItmLst);
                        request.setAttribute("sprPrtLst", sprPrtLst);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("nowTime", nowTime);

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 141:
                        if (request.getParameter("pO") != null && request.getParameter("pO").equals("1")) {
                            servedPage = "/docs/procurement/new_procurement.jsp";
                        } else if (request.getParameter("pO") != null && request.getParameter("pO").equals("2")) {
                            servedPage = "/docs/procurement/new_procurement.jsp";

                            String[] sprIDs = request.getParameterValues("sprID");

                            ArrayList<WebBusinessObject> sprLst = new ArrayList<WebBusinessObject>();
                            for (int index = 0; index < sprIDs.length; index++) {
                                sprLst.add(projectMgr.getOnSingleKey(sprIDs[index]));
                            }

                            request.setAttribute("sprLst", sprLst);
                        } else {
                            servedPage = "/docs/issue/addSpareParts.jsp";

                            String busID = request.getParameter("busID");
                            issueId = request.getParameter("issueId");

                            request.setAttribute("issueId", issueId);

                            if (request.getParameter("reqType") != null && request.getParameter("reqType").equals("jobOrder")) {
                                String[] bItmID = request.getParameter("requestedItemIdArr").split(",");
                                String[] amount = request.getParameter("amount").split(",");
                                String[] totalRate = request.getParameter("total").split(",");
                                String[] requestedItemNote = request.getParameter("requestedItemNote").split(",");
                                String[] realAmount = request.getParameter("realAmount").split(",");

                                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                                loggegUserId = (String) loggedUser.getAttribute("userId");

                                for (int i = 0; i < bItmID.length; i++) {
                                    issueMgr.addBusinessItm(issueId, bItmID[i], Integer.parseInt(amount[i]), Integer.parseInt(totalRate[i]), requestedItemNote[i], loggegUserId, "7");
                                    boolean flag = issueMgr.updateSpareAmnt(bItmID[i], Integer.toString((Integer.parseInt(realAmount[i]) - Integer.parseInt(amount[i]))));
                                }
                            } else if (request.getParameter("delItm") != null && request.getParameter("delItm").equals("delItm")) {
                                String itmID = request.getParameter("itmID");
                                issueMgr.deleteBusinessItm(itmID);
                            }

                            comStatus = issueMgr.getComStatus(issueId);
                            request.setAttribute("comStatus", comStatus);

                            sprPrtLst = issueMgr.getBusItmLst(issueId, "7");
                            request.setAttribute("sprPrtLst", sprPrtLst);

                            jobOrderWbo = new WebBusinessObject();
                            jobOrderWbo = issueMgr.jobOrderInfo(issueId);
                            request.setAttribute("jobOrderWbo", jobOrderWbo);
                            request.setAttribute("busID", busID);
                        }

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 142:
                        out = response.getWriter();
                        wbo = new WebBusinessObject();

                        if (request.getParameter("getIssueID") != null && request.getParameter("getIssueID").equals("getIssueID")) {
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            clientId = "1502277730347"; //(String) loggedUser.getAttribute("userId");

                            request.setAttribute("clientId", clientId);
                            clientMgr = ClientMgr.getInstance();
                            wbo = new WebBusinessObject();
                            wbo = clientMgr.getOnSingleKey(clientId);

                            request.setAttribute("page", servedPage);
                            request.setAttribute("client", wbo);

                            issueMgr = IssueMgr.getInstance();
                            request.setAttribute("issueId", request.getAttribute("issueId"));
                            request.getSession().setAttribute("issueId", (String) request.getAttribute("issueId"));
                            issId = null;
                            issId = issueMgr.generateComplaintNo(request, session, "issue");
                            if (issId != null && !issId.equals("")) {
                                wbo.setAttribute("status", "success");
                                issueWbo = issueMgr.getOnSingleKey(issId);
                                request.getSession().setAttribute("issueId", issId);
                                request.setAttribute("issueWbo", issueWbo);

                                wbo.setAttribute("businessID", (String) issueWbo.getAttribute("businessID"));
                                wbo.setAttribute("businessIDbyDate", (String) issueWbo.getAttribute("businessIDbyDate"));
                                wbo.setAttribute("issueId", issId);

                            } else {
                                wbo.setAttribute("status", "fail");

                            }

                            out.write(Tools.getJSONObjectAsString(wbo));
                        } else {
                            remoteAccess = request.getSession().getId();
                            localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);

                            //                        wbo = empRelationMgr.getOnSingleKey("key2", userId);
                            //                        if (wbo != null) {
                            data = new WebBusinessObject();
                            userId = request.getParameter("usrID");

                            //                        wbo = new WebBusinessObject();
                            //                        wbo = empRelationMgr.getOnSingleKey("key2", userId);
                            //                        if (wbo != null) {
                            // managerId = request.getParameter("mgrId");
                            claim_content = request.getParameter("comment");
                            clientId = (String) request.getParameter("clientId");
                            //subject = (String) request.getParameter("subject");
                            ticketType = (String) request.getParameter("ticketType");
                            orderUrgency = (String) request.getParameter("urgency");
                            issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey((String) request.getAttribute("issueID"));

                            /*if (issueWbo != null) {
                             ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                             StringBuilder subjectBuilder = new StringBuilder();
                             for (WebBusinessObject unitWbo : unitsList) {
                             subjectBuilder.append(" ").append(unitWbo.getAttribute("projectName")).append("\n");
                             }
                             if (subjectBuilder.length() > 0) {
                             subject += subjectBuilder.toString();
                             }
                             }*/
                            //request.setAttribute("managerId", managerId);
                            request.setAttribute("comment", claim_content);
                            request.setAttribute("clientId", clientId);
                            //request.setAttribute("subject", subject);
                            request.setAttribute("ticketType", ticketType);
                            request.setAttribute("orderUrgency", orderUrgency);
                            //request.setAttribute("category", request.getParameter("category"));
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();

                            data = clientComplaintsMgr.saveJobOrderComplaint(request, localPersistentUser);
                            Thread.sleep(300);
                            if (data != null) {
                                issueId = (String) data.getAttribute("issueID");
                                compId = (String) data.getAttribute("compId");

                                ClientComplaintsMgr clientComplaintsMgr2 = ClientComplaintsMgr.getInstance();

                                wbo = (WebBusinessObject) clientComplaintsMgr2.getOnSingleKey(compId);
                                // wbo.setAttribute("managerId", managerId);
                                wbo.setAttribute("clientCompId", compId);
                                wbo.setAttribute("employeeId", userId);
                                wbo.setAttribute("complaintComment", claim_content);
                                //wbo.setAttribute("compSubject", subject);
                                String responsability = "1";
                                wbo.setAttribute("status", "Ok");
                            } else {
                                wbo.setAttribute("status", "No");

                            }
                            //                        } else {
                            //                            wbo = new WebBusinessObject();
                            //                            wbo.setAttribute("status", "noManager");
                            //
                            //                        }
                            out.write(Tools.getJSONObjectAsString(wbo));
                        }
                        break;

                    case 143:

                        remoteAccess = request.getSession().getId();
                        localPersistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
                        servedPage = "/shoppingCart.jsp";

                        userId = (String) localPersistentUser.getAttribute("userId");
                        userWbo = new WebBusinessObject();
                        userMgr = UserMgr.getInstance();
                        userWbo = userMgr.getOnSingleKey(userId);
                        clientID = request.getParameter("clientID");
                        String ClientNm = clientMgr.getOnSingleKey(clientID).getAttribute("name").toString();
                        String ClientNo = clientMgr.getOnSingleKey(clientID).getAttribute("clientNO").toString();
                        request.setAttribute("clientId", clientID);
                        ////////////////////////////case 64
                        clientMgr = ClientMgr.getInstance();
                        wbo = new WebBusinessObject();
                        wbo = clientMgr.getOnSingleKey(clientID);
                        clientProduct = new Vector();

                        clientProductMgr = ClientProductMgr.getInstance();
                        try {
                            clientProduct = clientProductMgr.getOnArbitraryKey(clientID, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        clientProductMgr = ClientProductMgr.getInstance();
                        request.setAttribute("clientId", clientID);
                        clientMgr = ClientMgr.getInstance();
//                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo4 = new WebBusinessObject();
//                        wbo3 = clientMgr.getOnSingleKey(clientId);
                        //reservedUnit = new Vector();
                        interestedUnit = new Vector();
                        viewsUnit = new Vector();
                        ArrayList<WebBusinessObject> purcheUnits = new ArrayList<WebBusinessObject>();
                        ArrayList<WebBusinessObject> reservedUnit1 = new ArrayList<WebBusinessObject>();
                        clientProductMgr = ClientProductMgr.getInstance();
                        reservedUnit1 = new ArrayList<WebBusinessObject>(clientProductMgr.getReservedUnit(clientID));
                        interestedUnit = clientProductMgr.getInterestedUnit(clientID);
                        viewsUnit = clientProductMgr.getViewsUnit(clientID); 
                        purcheUnits = new ArrayList<WebBusinessObject>(clientProductMgr.getPurcheUnit(clientID));
                        products = new Vector();
                        mainProducts = new Vector();
                        Vector mainProductsBuilding = new Vector();
                        try {
                            mainProducts = projectMgr.getOnArbitraryDoubleKeyOracle("44", "key6", "66", "key9");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        try {
                            mainProductsBuilding = projectMgr.getJoinTableUnitType();
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        //
                        try {
                            ArrayList<WebBusinessObject> paymentPlace = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("1365240752318", "key2"));
                            request.setAttribute("paymentPlace", paymentPlace);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        //

                        //For Close And Finish Actions
//                        ClosureConfigurationMgr closureConfigurationMgr = ClosureConfigurationMgr.getCurrentInstance();
//                        request.setAttribute("closureActionsList", closureConfigurationMgr.getClosureActionsList());
                        userClosureConfigMgr = ClosureConfigMgr.getInstance();
                        userClosureList = userClosureConfigMgr.getClosuresByUser(localPersistentUser.getAttribute("userId").toString());
                        request.setAttribute("closureActionsList", userClosureList);
                        //
                        departmentId = "";
                        departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(userId, "key5"));
                        if (!departmentList.isEmpty()) {
                            departmentId = (String) departmentList.get(0).getAttribute("projectID");
                        }
                        employeeList = userMgr.getEmployeeByDepartmentId(departmentId, null, null);
//                        for (int i = employeeList.size() - 1; i >= 0; i--) {
//                            WebBusinessObject wboEmployee = employeeList.get(i);
//                            if (userId.equals(wboEmployee.getAttribute("userId"))) {
//                                employeeList.remove(i);
//                            }
//                        }

                        DepComp = projectMgr.getAllCompDeaprtments("cmp");
                        request.setAttribute("data", mainProducts);  ////////////
                        request.setAttribute("dataBuilding", mainProductsBuilding);  ////////////
                        request.setAttribute("ClientNm", ClientNm);
                        request.setAttribute("ClientNo", ClientNo);
                        
                        request.setAttribute("products", interestedUnit); //////////////
                        request.setAttribute("viewsUnit", viewsUnit);
                        request.setAttribute("reservedUnit", reservedUnit1);/////////
                        request.setAttribute("page", servedPage);
                        request.setAttribute("client", wbo);
                        request.setAttribute("DepComp", DepComp);
                        request.setAttribute("userUnderManager", employeeList);
                        request.setAttribute("purcheUnits", purcheUnits);///////////////

                        this.forwardToServedPage(request, response);

                        break;
			
		    case 144:
			loggegUserId = new String();
			servedPage = "/docs/reports/withdrawReport.jsp";
			
			//if(request.getParameter("my") != null && request.getParameter("my").equals("1")){
			    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
			    loggegUserId = (String) loggedUser.getAttribute("userId");
			//}
			
			try {
			    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
			} catch (Exception ex) {
			    request.setAttribute("requestTypes", new ArrayList<>());
			}

			
			try {
			    securityUser = (SecurityUser) session.getAttribute("securityUser");
			    request.setAttribute("distributionsList", userMgr.getUsersByGroup(securityUser.getDefaultNewClientDistribution()));
			} catch (Exception ex) {
			    logger.error(ex);
			    request.setAttribute("distributionsList", new ArrayList<>());
			}
			
			request.setAttribute("usersIDsList", persistentSessionMgr.getLoggedUsers());
			
			try {
			    request.setAttribute("salesEmployees", userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID));
			} catch (SQLException ex) {
			    logger.error(ex);
			    request.setAttribute("salesEmployees", new ArrayList<>());
			}
			
			request.setAttribute("status", request.getParameter("status"));
			
                        String beginDate = request.getParameter("beginDate");
                        endDate = request.getParameter("endDate");
                        cal = Calendar.getInstance();
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        if (endDate == null) {
                            endDate = sdf.format(cal.getTime());
                        }
                        if (beginDate == null) {
                            cal.add(Calendar.DATE, -7);
                            beginDate = sdf.format(cal.getTime());
                        }
                        String salesWith = request.getParameter("employeeId");
			request.setAttribute("withdrawLst", issueMgr.getWithdrawTl(salesWith));
			request.setAttribute("my", request.getParameter("my"));
			request.setAttribute("disStatus", request.getParameter("status"));
			
			request.setAttribute("beginDate", beginDate);
			request.setAttribute("endDate", endDate);
			request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
			break;

                    case 145:
                        servedPage = "/docs/reports/withdrawReport.jsp";
                        String[] clientsIDs = request.getParameterValues("customerId");
                        employeeID = request.getParameter("employeeId");
                        
                        if(clientsIDs != null && employeeID != null){
                            boolean delResult = issueMgr.deleteAllFutureAppointments(clientsIDs, employeeID);
                            if(delResult == true){
                                request.setAttribute("Dstatus", "true");
                            } else {
                                request.setAttribute("Dstatus", "false");
                            }
                        }
                        
                        try {
			    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
			} catch (Exception ex) {
			    request.setAttribute("requestTypes", new ArrayList<>());
			}
                        try {
			    securityUser = (SecurityUser) session.getAttribute("securityUser");
			    request.setAttribute("distributionsList", userMgr.getUsersByGroup(securityUser.getDefaultNewClientDistribution()));
			} catch (Exception ex) {
			    logger.error(ex);
			    request.setAttribute("distributionsList", new ArrayList<>());
			}
                        request.setAttribute("usersIDsList", persistentSessionMgr.getLoggedUsers());
			
			try {
			    request.setAttribute("salesEmployees", userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID));
			} catch (SQLException ex) {
			    logger.error(ex);
			    request.setAttribute("salesEmployees", new ArrayList<>());
			}
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                    case 146:
                     servedPage = "/docs/call_center/clientProduct.jsp";
                       EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
                       Vector<WebBusinessObject> issuesVector = new Vector();
                       // nowTime = sdf.format(cal.getTime());
                       userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                           String[] key1 = new String[3];
                           String[] value = new String[3];
                           key1[0] = "key3";
                           key1[1] = "key8";
                         value[0] = userWbo.getAttribute("userId").toString();
                        value[1] = "4";
                        value[2] = "3";
                        String resp = "1";
                        String timeFormat = "yyyy/MM/dd";
                         cal = Calendar.getInstance();
                          sdf = new SimpleDateFormat(timeFormat);
                            nowTime = sdf.format(cal.getTime());
                           String fromDateVal = nowTime;
                            String toDateVal = nowTime;
                          clientId=request.getParameter("clientID");
                            compId="";
                        issuesVector = employeeViewMgr.getComplaintsForClient(3, value, key1, "key7", resp,clientId);
                        for  (WebBusinessObject wbo1 : issuesVector) {
                             issueId= (String) wbo1.getAttribute("issue_id");
                             compId = (String) wbo1.getAttribute("clientComId");
                                request.setAttribute("issueId", issueId);
                            }
                                                
                        
                       
                    try {
                            ArrayList<WebBusinessObject> paymentPlace = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("1365240752318", "key2"));
                            request.setAttribute("paymentPlace", paymentPlace);
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                     mainProducts = new Vector();
                        try {
                            mainProducts = projectMgr.getOnArbitraryKey("44", "key4");
                        } catch (SQLException ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        wboIssueCompl = new WebBusinessObject();
                         issueCompV = new Vector();
                         
                        if(compId!=null){
                        issueCompV = IssueByComplaintUniqueMgr.getInstance().getOnArbitraryKey(compId, "key4");
                        
                        wboIssueCompl = (WebBusinessObject) issueCompV.get(0);
                        }
                        request.setAttribute("data", mainProducts);
                        interestedUnit = new Vector();
                      //  clientId = (String) wboIssueCompl.getAttribute("customerId");
                        clientProductMgr = ClientProductMgr.getInstance();  //////////
                        reservedUnit = clientProductMgr.getReservedUnit(clientId);/////////
                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);///////////
                        viewsUnit = clientProductMgr.getViewsUnit(clientId);
                        request.setAttribute("products", interestedUnit);
                         
                         request.setAttribute("viewsUnit", viewsUnit);                //////////////////
                        request.setAttribute("reservedUnit", reservedUnit);
                        request.setAttribute("purcheUnits", new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle("purche", "key4", clientId, "key1")));
                        userClientsMgr = UserClientsMgr.getInstance();

                        CompetentEmp = new Vector();

                        CompetentEmp = userClientsMgr.getOnArbitraryKey(clientId, "key2");
                        if (CompetentEmp != null) {
                            request.setAttribute("CompetentEmp", CompetentEmp);
                        } else {
                            request.setAttribute("CompetentEmp", null);
                        }
                        clientMgr = ClientMgr.getInstance();        ///////////
                        wbo = new WebBusinessObject();          ///////////
                        wbo = clientMgr.getOnSingleKey(clientId);/////////////////////
                       request.setAttribute("client", wbo);               /////////////////
                         request.setAttribute("page", servedPage);
                         this.forwardToServedPage(request, response);
                        break;
                case 147:
                        out = response.getWriter();
                        wbo = new WebBusinessObject();
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        if (clientComplaintsMgr.updateBusinessCompCmnt(request.getParameter("clientComplaintID"), request.getParameter("newCode"))) {
                            wbo.setAttribute("status", "ok");
                        }
                        out.write(Tools.getJSONObjectAsString(wbo));
                        break;
                    default:
                        this.forwardToServedPage(request, response);

                }
            }
        } catch (Exception sqlEx) {
            // forward to error page
            sqlEx.printStackTrace();
            System.out.println("Error Msg = " + sqlEx.getMessage());
            logger.error(sqlEx.getMessage());
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
    }

    private void refineForm(HttpServletRequest request) {
        wIssue.setFAID((String) request.getParameter("FAName"));
        wIssue.setIssueTitle((String) request.getParameter("issueTitle"));

        wIssue.setIssueID((String) request.getParameter("typeName"));
        wIssue.setUrgencyID((String) request.getParameter("urgencyName"));
        wIssue.setIsRisk((String) request.getParameter("isRisk"));
        wIssue.setIssueDesc((String) request.getParameter("issueDesc"));
    }

    private void refineEmeregencyForm(HttpServletRequest request) {
        wIssue.setFAID("A");
        wIssue.setIssueTitle("Emergency");
        wIssue.setUrgencyID((String) request.getParameter("urgencyName"));
        wIssue.setIssueDesc(request.getParameter("issueDesc").toString());
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
    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("create")) {
            return 1;
        }

        if (opName.equalsIgnoreCase(AppConstants.LIST_SCHEDULE)) {
            return 2;
        }

        if (opName.equals("ListTimeBound")) {
            return 3;
        }

        if (opName.equals("makesure")) {
            return 4;
        }

        if (opName.equals("delete")) {
            return 5;
        }

        if (opName.equals("viewdetails")) {
            return 6;
        }

        if (opName.equals("GetEditForm")) {
            return 7;
        }

        if (opName.equals("Update")) {
            return 8;
        }

        if (opName.equals("print")) {
            return 9;
        }

        if (opName.equals("configure")) {
            return 10;
        }

        if (opName.equals("GetXML")) {
            return 11;
        }

        if (opName.equals("ViewUpdateJobIssueDate")) {
            return 12;
        }

        if (opName.equals("UpdateJobIssueDate")) {
            return 13;
        }

        if (opName.equals("editJobOrder")) {
            return 14;
        }

        if (opName.equals("createExternal")) {
            return 15;
        }

        if (opName.equals("saveExternalOrder")) {
            return 16;
        }

        if (opName.equals("GetTasksForm")) {
            return 17;
        }

        if (opName.equals("SaveTasks")) {
            return 18;
        }

        if (opName.equals("ListTasks")) {
            return 19;
        }

        if (opName.equals("ViewTask")) {
            return 20;
        }

        if (opName.equals("GetUpdateTaskForm")) {
            return 21;
        }

        if (opName.equals("UpdateTask")) {
            return 22;
        }

        if (opName.equals("ConfirmTaskDelete")) {
            return 23;
        }

        if (opName.equals("DeleteTask")) {
            return 24;
        }

        if (opName.equals("ViewParts")) {
            return 25;
        }

        if (opName.equals("ChangeDateHistory")) {
            return 26;
        }

        if (opName.equals("showAllDetails")) {
            return 27;
        }

        if (opName.equals("tap1")) {
            return 28;
        }

        if (opName.equals("getAllIssueIds")) {
            return 29;
        }

        if (opName.equals("Maintenance_Items")) {
            return 30;
        }

        if (opName.equals("Re_Jops")) {
            return 31;
        }

        if (opName.equals("Workers")) {
            return 32;
        }

        if (opName.equals("Work_Instruction")) {
            return 33;
        }

        if (opName.equals("TaskTypeByJobs")) {
            return 34;
        }

        if (opName.equals("SaveExternalJob")) {
            return 36;
        }

        if (opName.equals("SaveWorkers")) {
            return 38;
        }

        if (opName.equals("printJobOrder")) {
            return 39;
        }

        if (opName.equals("printOrderStore")) {
            return 40;
        }

        if (opName.equals("EmgByEquip")) {
            return 41;
        }

        if (opName.equals("CreateEmgByEquip")) {
            return 42;
        }

        if (opName.equals("GetIssueForm")) {
            return 43;
        }

        if (opName.equals("createAttach")) {
            return 44;
        }

        if (opName.equals("viewComp")) {
            return 45;
        }

        if (opName.equals("compose")) {
            return 55;
        }

        if (opName.equals("AttachJobOrder")) {
            return 56;
        }

        if (opName.equals("SaveAttachJobOrder")) {
            return 57;
        }

        if (opName.equals("ShowStatusJobOrderDate")) {
            return 58;
        }

        if (opName.equals("saveEmIssueFromInspection")) {
            return 59;
        }

        if (opName.equals("addPartsWarranty")) {
            return 60;
        }

        if (opName.equals("SaveEditExternalJob")) {
            return 61;
        }
        if (opName.equals("itemComplainRelation")) {
            return 62;
        }
        // crm cases
        if (opName.equals("newComplaint")) {
            return 64;
        }

        if (opName.equals("insertNewCmpl")) {
            return 65;
        }
        if (opName.equals("insertCmpl")) {
            return 66;
        }
        if (opName.equals("saveCmpl")) {
            return 67;
        }

        if (opName.equals("getCompl")) {
            return 68;
        }
        if (opName.equals("saveOrder")) {
            return 69;
        }

        if (opName.equals("saveQuery")) {
            return 70;
        }
        if (opName.equals("recordCall")) {
            return 71;
        }

        if (opName.equals("insertNewCmplPopup")) {
            return 72;
        }
        if (opName.equals("clientOperation")) {
            return 73;
        }
        if (opName.equals("showProduct")) {
            return 74;
        }
        if (opName.equals("saveComp2")) {
            return 75;
        }
        if (opName.equals("saveBookmark")) {
            return 76;
        }
        if (opName.equals("deleteBookmark")) {
            return 77;
        }
        //save complaint and solved by logged user .complaint  distributed in call center manager and show in closed msg
        if (opName.equals("saveComp3")) {
            return 78;
        }
        if (opName.equals("redirectComplaint")) {
            return 79;
        }
        if (opName.equals("getDepartmentEmployees")) {
            return 80;
        }
        if (opName.equals("sendOrderTOEmployee")) {
            return 81;
        }

        if (opName.equals("showClosedMsg")) {
            return 82;
        }
        if (opName.equals("showFinishedMsg")) {
            return 83;
        }
        if (opName.equals("showRejectedMessage")) {
            return 84;
        }
        if (opName.equals("closeIssueStatus")) {
            return 85;
        }
        if (opName.equals("getCompl2")) {
            return 86;
        }
        if (opName.equals("multiBookmark")) {
            return 87;
        }
        if (opName.equals("getCompUnderIssue")) {
            return 88;
        }
        if (opName.equals("numOfOrders")) {
            return 89;
        }
        if (opName.equals("updateCallType")) {
            return 90;
        }
        if (opName.equals("homePage")) {
            return 91;
        }
        if (opName.equals("updateCallDirection")) {
            return 93;
        }
        if (opName.equals("redirectComplaintToEmployee")) {
            return 94;
        }
        if (opName.equals("getCompl3")) {
            return 95;
        }
        if (opName.equals("saveService")) {
            return 96;
        }
        if (opName.equals("getSupervisorComp")) {
            return 97;
        }
        if (opName.equals("getSupervisorComp2")) {
            return 98;
        }
        if (opName.equals("newExtractIssue")) {
            return 99;
        }
        if (opName.equals("completeNewExtractIssue")) {
            return 100;
        }
        if (opName.equals("getOrderRequestsForm")) {
            return 101;
        }
        if (opName.equals("saveOrderRequestsForm")) {
            return 102;
        }
        if (opName.equals("viewComplaint")) {
            return 103;
        }
        if (opName.equals("notificationComplaintToEmployee")) {
            return 104;
        }
        if (opName.equals("redistributionComplaintToEmployee")) {
            return 105;
        }
        if (opName.equals("openCommentHierariecy")) {
            return 106;
        }
        if (opName.equals("saveCommentHierarchy")) {
            return 107;
        }
        if (opName.equals("requestComments")) {
            return 108;
        }
        if (opName.equals("saveRequestComments")) {
            return 109;
        }
        if (opName.equals("getRequestExtraditionReport")) {
            return 110;
        }
        if (opName.equals("saveRequestCommentsForQaulity")) {
            return 111;
        }
        if (opName.equals("changeNotificationStatusAjax")) {
            return 112;
        }
        if (opName.equals("getActionByAjax")) {
            return 113;
        }
        if (opName.equals("rejectRequestByManager")) {
            return 114;
        }
        if (opName.equals("saveCommentReplayProjectManager")) {
            return 115;
        }
        if (opName.equals("saveJoborderManager")) {
            return 116;
        }
        if (opName.equals("saveJoborderWorker")) {
            return 117;
        }
        if (opName.equals("getUpdateContractorForm")) {
            return 118;
        }
        if (opName.equals("getComplaintsRequests")) {
            return 119;
        }
        if (opName.equals("updateExecutionPeriod")) {
            return 120;
        }

        if (opName.equals("getRequestItemsDetails")) {
            return 121;

        }
        if (opName.equals("deleteComplaint")) {
            return 122;
        }
        if (opName.equals("getRequestsCountAjax")) {
            return 123;
        }
        if (opName.equals("getExecutionPeriodAjax")) {
            return 124;
        }
        if (opName.equals("saveIssueCommentForQA")) {
            return 125;
        }
        if (opName.equals("updateDelivryWorkItems")) {
            return 126;
        }
        if (opName.equals("getUnderFollowup")) {
            return 127;
        }
        if (opName.equals("saveQuantityWorkItems")) {
            return 128;
        }
        if (opName.equals("qulityAgendaUpdateWorkItemsPopup")) {
            return 129;
        }
        if (opName.equals("getDepOnIssues")) {
            return 130;
        }
        if (opName.equals("updateCodeAjax")) {
            return 131;
        }
        if (opName.equals("updateIssueSourceIDAjax")) {
            return 132;
        }
        if (opName.equals("saveUnknownComplaint")) {
            return 133;
        }
        if (opName.equals("distributeComplaints")) {
            return 134;
        }
        if (opName.equals("createGeneralQuality")) {
            return 135;
        }
        if (opName.equals("createQualityPlan")) {
            return 136;
        }
        if (opName.equals("distributionToEmployee")) {
            return 137;
        }
        if (opName.equals("addBusinessItems")) {
            return 138;
        }
        if (opName.equals("addMaintenanceItems")) {
            return 139;
        }
        if (opName.equals("jobOrderInvoice")) {
            return 140;
        }
        if (opName.equals("addSpareParts")) {
            return 141;
        }
        if (opName.equals("jobOrderComplaint")) {
            return 142;
        }
        if (opName.equals("clientUnits")) {
            return 143;
        }
	if (opName.equals("withdrawReport")) {
            return 144;
        }
        if (opName.equals("deleteAllFutureAppointments")) {
            return 145;
        }
        if(opName.equals("ReserveFromClientMenu"))
        {
            return 146;
        } if (opName.equals("updateCommentByAjax")) {
            return 147;
        }
        return 0;
    }
}
