package com.tracker.servlets;

import com.businessfw.hrs.db_access.EmployeeMgr;
import com.Erp.db_access.CostCentersMgr;
import com.SpareParts.db_access.SparePartsBean;
import com.SpareParts.db_access.TransactionMgr;
import com.SpareParts.db_access.UsedSparePartsMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.ParseSideMenu;
import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.Tools;
import com.tracker.business_objects.*;
import com.silkworm.common.*;
import com.tracker.db_access.*;
import com.silkworm.business_objects.*;
import com.tracker.common.*;
import com.tracker.engine.IssueStatusFactory;
import com.tracker.engine.AssignedIssueState;
import com.maintenance.db_access.*;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.servlets.*;
import com.silkworm.util.*;

import java.io.*;
import java.util.*;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.commons.beanutils.BeanComparator;
import org.apache.log4j.Logger;

public class AssignedIssueServlet extends swBaseServlet {

    WebIssue webIssue = new WebIssue();
    UserMgr userMgr = UserMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
    AssignedIssueMgr assignedIssueMgr = AssignedIssueMgr.getInstance();
    CrewEmployeeMgr crewEmployeeMgr = CrewEmployeeMgr.getInstance();
    QuantifiedMntenceMgr quantifiedMgr = QuantifiedMntenceMgr.getInstance();
    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
    TransStoreItemMgr transStoreItemMgr = TransStoreItemMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    WebBusinessObject loggerWbo = new WebBusinessObject();
    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
    String viewOrigin = null;
    UnitScheduleMgr usMgr = UnitScheduleMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    DriversHistoryMgr driverHistoryMgr = DriversHistoryMgr.getInstance();
    ComplaintTasksMgr compTasksMgr = ComplaintTasksMgr.getInstance();
    IssueTasksComplaintMgr issueTaskCompMgr = IssueTasksComplaintMgr.getInstance();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    LaborComplaintsMgr laborMgr = LaborComplaintsMgr.getInstance();
    ReconfigTaskMgr reconfigTaskMgr = ReconfigTaskMgr.getInstance();
    CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    ItemFormListMgr itemFormListMgr = ItemFormListMgr.getInstance();
    Vector<WebBusinessObject> tasks;
    String filterName = null;
    String filterValue = null;
    String mainTitle = null;
    String issueState = null;
    String userId;
    String issueId;
    String taskId;
    AssignedIssueState ais = null;
    SecurityUser securityUser;
    WebBusinessObject userObj = null;
    AssignedIssueState assignedIssueState = null;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(AssignedIssueServlet.class);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        securityUser = (SecurityUser) session.getAttribute("securityUser");
        userId = securityUser.getUserId();
        operation = getOpCode((String) request.getParameter("op"));
        Vector vecUserTrades = new Vector();
        vecUserTrades = (Vector) userObj.getAttribute("userTrade");
        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
        ServletUtils.printRequest(requestAsArray);

        switch (operation) {

            case 1:
                String projectname = request.getParameter("projectName");
                AssignedIssueState ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);

                issueId = request.getParameter(IssueConstants.ISSUEID);

                session.removeAttribute("CurrentJobOrder");
                session.setAttribute("CurrentJobOrder", issueId);

                WebBusinessObject myIssue = issueMgr.getOnSingleKey(issueId);

                String uID = (String) myIssue.getAttribute("unitScheduleID");
                String issueTitle = myIssue.getAttribute("issueTitle").toString();

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");

                Vector itemList = new Vector();
                String uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();

                String scheduleId;

                WebBusinessObject web = usMgr.getOnSingleKey(uID);

                scheduleId = web.getAttribute("periodicId").toString();

                if (scheduleId.equalsIgnoreCase("1") || scheduleId.equalsIgnoreCase("2")) {
                    QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                    itemList = ListItems.getItemSchedule(uSID);
                } else {
                    ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                    itemList = itemsList.getConfigItemBySchedule(scheduleId);
                }

                if (request.getParameter("case") != null) {
                    request.setAttribute("case", request.getParameter("case"));
                    request.setAttribute("title", request.getParameter("title"));
                    request.setAttribute("unitName", request.getParameter("unitName"));
                }
                request.setAttribute("planType", request.getParameter("planType"));
                servedPage = "/docs/issue/assign_issue.jsp";
                request.setAttribute("data", itemList);
                request.setAttribute("uID", uID);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                request.setAttribute(IssueConstants.STATE, ais);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                String projectID = request.getParameter("projectID");
                String endDate = request.getParameter("end");
                String hour = request.getParameter("h");
                String min = request.getParameter("m");
                java.util.Date endD = null;
                DateParser dateParser = new DateParser();

                if (null != endDate) {
                    int h = Integer.parseInt(hour);
                    int m = Integer.parseInt(min);
                    endD = dateParser.formatUtilDate(endDate, h, m);
                }

                String destination = "";
                String currentJobOrder = "";

                issueTitle = request.getParameter("issueTitle");
                String assignNote = request.getParameter("assignNote");
                scrapeForm(request);

                webIssue.setAttribute("empID", request.getParameter("empName"));
                webIssue.setAttribute("assignNote", assignNote);
                webIssue.setAttribute("bDate", new Timestamp(endD.getTime()));

                String uid = request.getParameter("uID");
                String[] TotaleCost = request.getParameterValues("totale");
                issueId = request.getParameter(IssueConstants.ISSUEID);

                // set update equipment info.
                String averageUnitId = request.getParameter("averageUnitId");
                String currentReading = request.getParameter("currentReading");
                String lastReading = request.getParameter("lastReading");
                String description = request.getParameter("description");
                String unitId = request.getParameter("unitId");
                String longLastDateReading = request.getParameter("longLastDateReading");
                String existRowInAvgUnit = request.getParameter("existRowInAvgUnit");
                scheduleId = request.getParameter("scheduleId");

                WebBusinessObject averageUnit = new WebBusinessObject();
                averageUnit.setAttribute("averageUnitId", averageUnitId);
                averageUnit.setAttribute("currentReading", currentReading);
                averageUnit.setAttribute("lastReading", lastReading);
                averageUnit.setAttribute("description", description);
                averageUnit.setAttribute("unitId", unitId);
                averageUnit.setAttribute("longLastDateReading", longLastDateReading);
                averageUnit.setAttribute("existRowInAvgUnit", existRowInAvgUnit);
                averageUnit.setAttribute("scheduleId", scheduleId);
                averageUnit.setAttribute("issueTitle", issueTitle);

                if (assignedIssueMgr.assignedIssueAndUpdateEquipment(webIssue, securityUser, averageUnit)) {
                    currentJobOrder = (String) session.getAttribute("CurrentJobOrder");

                    if (null != currentJobOrder) {
                        destination = "/AssignedIssueServlet?op=VIEWDETAILS&issueId=" + currentJobOrder + "&filterValue=" + filterValue + "&filterName=" + filterName + "&mainTitle=Emergency&backTo=all";
                    } else {
                        if (filterValue == null || filterValue.equals("null") || filterValue.equals("")) {
                            destination = "/main.jsp";
                        } else {
                            String searchType = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
                            if (searchType.equalsIgnoreCase("begin") || searchType.equalsIgnoreCase("end")) {
                                destination = "/SearchServlet?op=getByoneDate&filterValue=" + filterValue;
                            } else {
                                destination = AppConstants.getFullLink(filterName, filterValue);
                            }
                        }
                    }

                    try {
                        if (request.getParameter("changeState") != null) {
                            WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
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
                                Calendar c = Calendar.getInstance();
                                WebBusinessObject wboStatus = new WebBusinessObject();
                                wboStatus.setAttribute("equipmentID", equipmentID);
                                wboStatus.setAttribute("stateID", "2");
                                wboStatus.setAttribute("note", "Out of Line");
                                wboStatus.setAttribute("beginDate", (c.get(Calendar.MONTH) + 1) + "/" + c.get(Calendar.DAY_OF_MONTH) + "/" + c.get(Calendar.YEAR));
                                wboStatus.setAttribute("hour", new Integer(c.get(Calendar.HOUR_OF_DAY)).toString());
                                wboStatus.setAttribute("minute", new Integer(c.get(Calendar.MINUTE)).toString());
                                equipmentStatusMgr.saveObject(wboStatus, session);
                            }
                        }
                    } catch (Exception ex) {
                        logger.error("Saving Assigned Issue Exception NOW: " + ex.getMessage());
                    }

                    request.setAttribute("projectName", projectID);
                } else {
                    request.setAttribute("case", request.getParameter("case"));
                    request.setAttribute("title", request.getParameter("title"));
                    request.setAttribute("unitName", request.getParameter("unitName"));

                    destination = "/AssignedIssueServlet?op=internalAssign&issueId=" + issueId + "&filterName=" + filterName + "&filterValue=" + filterValue
                            + "&case=" + request.getParameter("case") + "&title=" + request.getParameter("title") + "&unitName=" + request.getParameter("unitName");

                    request.setAttribute("status", "no");
                }

                this.forward(destination, request, response);
                break;

            case 3:

                Vector assignedIssues = issueMgr.getIssueList("ASSIGNED", userObj);
                servedPage = "/docs/issue/issue_listing.jsp";
                request.setAttribute("data", assignedIssues);
                request.setAttribute("status", "Assigned");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            case 4:

                break;

            case 5:
                mainTitle = request.getParameter("mainTitle");
                projectname = request.getParameter("projectName");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                issueId = request.getParameter("issueId");
                // by walid
                session.removeAttribute("CurrentJobOrder");
                session.setAttribute("CurrentJobOrder", issueId);
                // end walid

                if (request.getParameter("case") != null) {
                    session = request.getSession(true);
                    session.setAttribute("case", request.getParameter("case"));
                    session.setAttribute("title", request.getParameter("title"));
                    session.setAttribute("unitName", request.getParameter("unitName"));
                }

                WebIssue wIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                String status = (String) wIssue.getAttribute("currentStatus");
                String sitDate = issueMgr.getsitDate(issueId);
                String actualBeginDate = issueMgr.getActualBeginDate(issueId);
                String unitScheduleID = (String) wIssue.getAttribute("unitScheduleID");
                WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(unitScheduleID);

                String scheduleUnitID = (String) wIssue.getAttribute("unitScheduleID");
                WebBusinessObject eqWbo = maintainableMgr.getOnSingleKey(wIssue.getAttribute("unitId").toString());

                request.getSession().setAttribute("IssueWbo", wIssue);
                request.getSession().setAttribute("equipmentWbo", eqWbo);

                //check if has complex issues it will complex jo
                ComplexIssueMgr complexIssueMgr = ComplexIssueMgr.getInstance();
                Vector temVec = new Vector();
                try {
                    temVec = complexIssueMgr.getOnArbitraryKey(issueId, "key1");
                    if (temVec.size() > 0) {
                        request.getSession().setAttribute("joType", "complex");
                    } else {
                        request.getSession().setAttribute("joType", "emg");
                    }
                } catch (Exception e) {
                }

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
                    wIssue.setAttribute("attachedEq", "attached");
                    request.getSession().setAttribute("attFlag", "attached");
                } else {
                    if (minorAttachedEqps.size() > 0) {
                        wIssue.setAttribute("attachedEq", "attached");
                        request.getSession().setAttribute("attFlag", "attached");
                    } else {
                        wIssue.setAttribute("attachedEq", "notatt");
                        request.getSession().setAttribute("attFlag", "notatt");
                    }

                }

                /**
                 * ****Create Dynamic contenet of Issue menu ******
                 */
                //open Jar File
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                metaMgr.setMetaData("xfile.jar");
                ParseSideMenu parseSideMenu = new ParseSideMenu();
                Vector issueMenu = new Vector();
                String mode = (String) request.getSession().getAttribute("currentMode");
                issueMenu = parseSideMenu.parseSideMenu(mode, "issue_menu.xml", "n");

                metaMgr.closeDataSource();
                ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
                boolean hide = false;
                WebBusinessObject tempWbo = externalJobMgr.getOnSingleKey("key2", (String) request.getParameter("issueId"));
                if (tempWbo != null) {
                    if (tempWbo.getAttribute("externalType").equals(ExternalJobMgr.TOTAL)) {
                        hide = true;
                    }
                }
                if (wIssue.getAttribute("currentStatus").equals("Finished")) {
                    hide = true;
                }

                /* Add ids for links*/
                Vector linkVec = new Vector();
                String link = "";

                Hashtable style = new Hashtable();
                style = (Hashtable) issueMenu.get(0);
                String title = style.get("title").toString();
                title += "   " + wIssue.getAttribute("businessID").toString();
                style.remove("title");
                style.put("title", title);

                for (int i = 1; i < issueMenu.size(); i++) {
                    linkVec = new Vector();
                    link = "";
                    linkVec = (Vector) issueMenu.get(i);
                    link = (String) linkVec.get(1);
                    if (link.equalsIgnoreCase("AssignedIssueServlet?op=assign&state=SCHEDULE&viewOrigin=null&direction=forward&issueId=")) {
                        String currentStatus = (String) wIssue.getAttribute("currentStatus");
                        if (currentStatus != null) {
                            if (currentStatus.equalsIgnoreCase("Schedule") || currentStatus.equalsIgnoreCase("Rejected")) {
                                link += wIssue.getAttribute("id").toString() + "&attachedEqFlag=" + wIssue.getAttribute("attachedEq").toString() + "&equipmentID=" + wIssue.getAttribute("unitId").toString();
                            } else {
                                issueMenu.remove(i);
                                i--;
                                continue;
                            }
                        } else {
                            link += wIssue.getAttribute("id").toString() + "&attachedEqFlag=" + wIssue.getAttribute("attachedEq").toString() + "&equipmentID=" + wIssue.getAttribute("unitId").toString();
                        }

                    } else {
                        link += wIssue.getAttribute("id").toString() + "&attachedEqFlag=" + wIssue.getAttribute("attachedEq").toString() + "&equipmentID=" + wIssue.getAttribute("unitId").toString() + "&issueTitle=" + wIssue.getAttribute("issueTitle").toString() + "&issueStatus=" + wIssue.getAttribute("currentStatus").toString();
                    }
                    if (hide && (i == 2 || i == 3 || i == 4 || i == 5 || i == 6)) {
                        link = "";
                    }
                    linkVec.remove(1);
                    linkVec.add(link);
                }

                request.getSession().setAttribute("sideMenuVec", issueMenu);
                /*End of Menu*/

//                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
//                MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
//                ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
//                Vector actualItems = new Vector();
//                try {
//                    actualItems = actualItemMgr.getOnArbitraryKey(scheduleUnitID, "key1");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                for(int i = 0; i < actualItems.size(); i++){
//                    WebBusinessObject temp = (WebBusinessObject) actualItems.get(i);
//                    String itemID = (String) temp.getAttribute("itemId");
//                    WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
//                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
//                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//                }
////                Vector quantifiedItems = new Vector();
//                try {
//                    quantifiedItems = quantifiedMgr.getOnArbitraryKey(scheduleUnitID, "key1");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                for(int i = 0; i < quantifiedItems.size(); i++){
//                    WebBusinessObject temp = (WebBusinessObject) quantifiedItems.get(i);
//                    String itemID = (String) temp.getAttribute("itemId");
//                    WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
//                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
//                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//                }
                unitScheduleMgr = UnitScheduleMgr.getInstance();
                unitScheduleWbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
//                ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
//                Vector configureItems = new Vector();
//                try {
//                    configureItems = configureMainTypeMgr.getOnArbitraryKey(((String) unitScheduleWbo.getAttribute("periodicId")), "key1");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                for(int i = 0; i < configureItems.size(); i++){
//                    WebBusinessObject temp = (WebBusinessObject) configureItems.get(i);
//                    String itemID = (String) temp.getAttribute("itemId");
//                    WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
//                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
//                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
//                }
                request.setAttribute("issueId", wIssue.getAttribute("id"));
//                request.setAttribute("actualItems" , actualItems);
//                request.setAttribute("quantifiedItems" , quantifiedItems);
//                request.setAttribute("configureItems" , configureItems);
//                request.setAttribute("wbo",wboIssue);

//                PlannedTasksMgr plannedTasksMgr = PlannedTasksMgr.getInstance();
//                Vector vecPlannedTasks = plannedTasksMgr.getPlannedTasksByIssue((String) wboIssue.getAttribute("id"));
//                EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
//                Vector vecTasksHours = empTasksHoursMgr.getTasksHoursByIssue((String) wboIssue.getAttribute("id"));
//                issueMgr = IssueMgr.getInstance();
//                request.setAttribute("vecPlannedTasks" , vecPlannedTasks);
//                request.setAttribute("vecTasksHours" , vecTasksHours);
//                imageMgr = ImageMgr.getInstance();
//                Vector docsList = imageMgr.getListOnLIKE("ListDoc", (String) wboIssue.getAttribute("id"));
//                request.setAttribute("data",docsList);
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
//                UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
//                Vector imageList = unitDocMgr.getImagesList(request.getParameter("equipmentID"));
//                Vector imagesPath = new Vector();
//                servedPage = "/docs/unit_doc_handling/view_tab.jsp";
//                request.setAttribute("page",servedPage);
//                for(int i = 0; i < imageList.size(); i++){
//                    String randome = UniqueIDGen.getNextID();
//                    int len = randome.length();
//                    String docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
//                    String randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
//                    String imageDirPath =   getServletContext().getRealPath("/images");
//                    String userHome = (String) loggedUser.getAttribute("userHome");
//                    String userImageDir =  imageDirPath + "/" + userHome;
//                    String userBackendHome = web_inf_path + "/usr/" + userHome + "/";
//
//                    String RIPath = userImageDir + "/" + randFileName;
//
//
//                    String absPath = "images/" + userHome + "/" + randFileName;
//
//                    File docImage = new File(RIPath);
//
//                    BufferedInputStream gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
//                    BufferedImage myImage = ImageIO.read(gifData);
//                    ImageIO.write(myImage,"jpeg",docImage);
//                    imagesPath.add(absPath);
//                }
//                request.setAttribute("equipID", unitScheduleWbo.getAttribute("unitId"));
//                request.setAttribute("imagePath", imagesPath);
                request.setAttribute("sitDate", sitDate);
                request.setAttribute("actualBeginDate", actualBeginDate);

                request.setAttribute("webIssue", wIssue);
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);

                request.setAttribute("mainTitle", mainTitle);
                request.setAttribute("equipmentID", unitScheduleWbo.getAttribute("unitId"));

                if (status.equalsIgnoreCase("Finished")) {
                    servedPage = "/docs/assigned_issue/newAssigned_issue_details.jsp";
                } else {
                    servedPage = "/docs/assigned_issue/assigned_issue_details.jsp";
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:

                projectname = request.getParameter("projectName");

                ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);

                issueId = request.getParameter(IssueConstants.ISSUEID);
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");

                //ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
                //ais.setViewOrigin(viewOrigin);
                servedPage = "/docs/issue/reassign_issue.jsp";

                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                request.setAttribute(IssueConstants.STATE, ais);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:

                projectname = request.getParameter("projectName");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                destination = AppConstants.getFullLink(filterName, filterValue);
                issueTitle = request.getParameter("issueTitle");
                WebIssue Issue = new WebIssue();
                //scrapeForm(request);
                userId = (String) request.getParameter(IssueConstants.ASSIGNEDTO);

                Issue.setIssueID((String) request.getParameter(IssueConstants.ISSUEID));
                Issue.setAssignedToID((String) request.getParameter(IssueConstants.ASSIGNEDTO));
                Issue.setAssignedToName(userMgr.getUserByID(userId));
                Issue.setFinishedTime((String) request.getParameter(IssueConstants.FINISHTIME));
                Issue.setIssueTitle((String) request.getParameter(IssueConstants.ISSUETITLE));
                Issue.setManagerNote((String) request.getParameter("assignNote"));

                Issue.setAttribute("techName", request.getParameter("techName"));
                try {
                    assignedIssueMgr.updateIssueState(Issue, session, "Reassigned");
                } catch (Exception ex) {
                    logger.error("Saving Reassigned Issue Exception: " + ex.getMessage());
                }
                request.setAttribute("projectName", projectname);
//                emailServlet = new EmailServlet();
//                emailServlet.doPost(request, response);
                this.forward(destination, request, response);
                break;

            case 8:
                mainTitle = request.getParameter("mainTitle");
                projectname = request.getParameter("projectName");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");

                issueId = request.getParameter("issueId");

                wIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);

                request.setAttribute("webIssue", wIssue);
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                request.setAttribute("mainTitle", mainTitle);

                servedPage = "/docs/assigned_issue/edit_job_order.jsp";

                request.setAttribute("issueId", issueId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:
                Vector itemListTemp = new Vector();
                projectname = request.getParameter("projectName");
                ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                transStoreItemMgr = TransStoreItemMgr.getInstance();
                issueId = request.getParameter(IssueConstants.ISSUEID);

                myIssue = issueMgr.getOnSingleKey(issueId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                String attachedEqFlag = (String) request.getParameter("attachedEqFlag");

                itemList = new Vector();
                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "0");
                web = usMgr.getOnSingleKey(uID);

                scheduleId = web.getAttribute("periodicId").toString();
                if (scheduleId.equalsIgnoreCase("1") || scheduleId.equalsIgnoreCase("2")) {
                    itemList = ListItems.getSpecialItemSchedule(uSID, "0");
                } else {
                    if (itemListTemp.isEmpty()) {
                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                        itemList = itemsList.getConfigItemBySchedule(scheduleId);
                    } else {
                        itemList = itemListTemp;
                    }
                }

                for (int i = 0; i < itemList.size(); i++) {
                    WebBusinessObject itemListWbo = (WebBusinessObject) itemList.get(i);
                    String[] keys = {"key1", "key2", "key3"};
                    String[] values = {"91", issueId, itemListWbo.getAttribute("itemId").toString()};
                    try {
                        Vector result = transStoreItemMgr.getOnArbitraryNumberKey(3, values, keys);
                        if (result.size() > 0) {
                            itemListWbo.setAttribute("canDelete", false);
                        } else {
                            itemListWbo.setAttribute("canDelete", true);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                // get all Store From Erp as ex.
                Tools.setRequestByStoreInfo(request);

                servedPage = "/docs/issue/schedule_config_parts.jsp";
                request.setAttribute("data", itemList);
                request.setAttribute("attachedEqFlag", attachedEqFlag);
                request.setAttribute("uID", uID);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                request.setAttribute(IssueConstants.STATE, ais);
                request.setAttribute("vecUserTrades", vecUserTrades);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                //// begin ////
                String page = request.getParameter("page").toString();
                WebBusinessObject wboIssue = new WebBusinessObject();
                projectname = request.getParameter("projectName");
                ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                issueId = request.getParameter(IssueConstants.ISSUEID);
                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                myIssue = issueMgr.getOnSingleKey(issueId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                itemListTemp = new Vector();
                itemList = new Vector();
                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                web = usMgr.getOnSingleKey(uID);
                scheduleId = web.getAttribute("periodicId").toString();
                ////  end ////

                wIssue = new WebIssue();
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                projectID = request.getParameter("projectID");
                destination = AppConstants.getFullLink("VIEWDETAILS", filterValue);
                issueTitle = request.getParameter("issueTitle");
                assignNote = request.getParameter("assignNote");
                scrapeForm(request);
                uid = request.getParameter("uID");

                TotaleCost = request.getParameterValues("total");
                issueId = request.getParameter(IssueConstants.ISSUEID);
                try {
                    if (page.equalsIgnoreCase("localspares")) {
                        quantifiedMgr.deleteOnArbitraryDoubleKey(uid, "key1", "1", "key2");
                    } else {
                        quantifiedMgr.deleteOnArbitraryDoubleKey(uid, "key1", "0", "key2");
                    }
                    issueMgr.updateTotalCost(new Float(TotaleCost[0]).floatValue(), issueId);

                    String[] quantity = request.getParameterValues("qun");
                    String[] costCode = request.getParameterValues("costCode");
                    String[] price = request.getParameterValues("price");
                    String[] cost = request.getParameterValues("cost");
                    String[] note = request.getParameterValues("note");
                    String[] id = request.getParameterValues("code");
                    String[] branchs = request.getParameterValues("branch");
                    String[] stores = request.getParameterValues("store");
                    String isDirectPrch = request.getParameter("isDirectPrch").toString();
                    String attOn = "2!";
                    List itemCodeSortList = new ArrayList();
                    SparePartsBean sparePartsBean;
                    BeanComparator beanComparatorByItemForm = new BeanComparator("itemForm");
                    String[] itemForm = new String[id.length];
                    String isMust = (String) request.getParameter("isMust");
                    TransactionMgr transactionMgr = TransactionMgr.getInstance();
                    for (int i = 0; i < id.length; i++) {
                        sparePartsBean = new SparePartsBean();
                        sparePartsBean.setId(id[i]);
                        itemForm = id[i].split("-");
                        sparePartsBean.setItemForm(itemForm[0]);
                        sparePartsBean.setPrice(new Double(price[i]));
                        sparePartsBean.setQty(new Double(quantity[i]));
                        sparePartsBean.setCost(new Double(cost[i]));
                        sparePartsBean.setCostCode(costCode[i]);
                        sparePartsBean.setBranch(branchs[i]);
                        sparePartsBean.setStore(stores[i]);
                        sparePartsBean.setNote(note[i]);
                        itemCodeSortList.add(sparePartsBean);
                    }
                    Collections.sort(itemCodeSortList, beanComparatorByItemForm);
                    request.setAttribute("trade", myIssue.getAttribute("workTrade").toString());
                    String saveStatus = "no";
                    if (attOn != null) {
                        attOn = attOn.substring(0, attOn.length() - 1);
                        String[] attachedOn = attOn.split("!");
                        if (quantifiedMgr.saveItemsObject(quantity, costCode, price, cost, note, id, branchs, stores, uid, isDirectPrch, attachedOn, session)) {
                            saveStatus = "yes";
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "no");
                        }
                    } else {
                        if (id != null) {
                            String[] attachedOn = new String[id.length];
                            for (int i = 0; i < id.length; i++) {
                                attachedOn[i] = "2";
                            }
                            if (quantifiedMgr.saveItemsObject(quantity, costCode, price, cost, note, id, branchs, stores, uid, isDirectPrch, attachedOn, session)) {
                                saveStatus = "yes";
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        }
                    }

                    ////////// Save Spare Parts Transaction for Maintenance and Store ////////
                    String saveRequest = (String) request.getParameter("saveRequest");
                    if (saveRequest != null && !saveRequest.equals("")) {

                        transactionMgr = TransactionMgr.getInstance();
                        Hashtable tableItem = new Hashtable();
                        List savingList = new ArrayList();
                        String[] arrItems = new String[itemCodeSortList.size()];
                        String[] itemForms = new String[itemCodeSortList.size()];
                        String[] costCenterCode = new String[itemCodeSortList.size()];
                        String[] branch = new String[itemCodeSortList.size()];
                        String[] store = new String[itemCodeSortList.size()];
                        String[] arrQty = new String[itemCodeSortList.size()];
                        for (int y = 0; y < itemCodeSortList.size(); y++) {
                            sparePartsBean = new SparePartsBean();
                            sparePartsBean = (SparePartsBean) itemCodeSortList.get(y);
                            arrItems[y] = sparePartsBean.getId();
                            itemForms[y] = sparePartsBean.getItemForm();
                            costCenterCode[y] = sparePartsBean.getCostCode();
                            branch[y] = sparePartsBean.getBranch();
                            store[y] = sparePartsBean.getStore();
                            arrQty[y] = sparePartsBean.getQty().toString();
                        }

                        String itemFormTemp = "";
                        String branchTemp = "";
                        String storeTemp = "";
                        String[] itemIds = new String[arrItems.length];
                        String[] qty = new String[arrItems.length];
                        String[] prices = new String[arrItems.length];
                        String[] notes = new String[arrItems.length];
                        String[] attached_On = new String[arrItems.length];
                        String[] efficient = new String[arrItems.length];
                        int count = 0;
                        UsedSparePartsMgr usedSparePartsMgr = UsedSparePartsMgr.getInstance();
                        for (int i = 0; i < arrItems.length; i++) {
                            count++;
                            tableItem = new Hashtable();
                            if (storeTemp != null && !storeTemp.equals("")) {
                                if (!itemFormTemp.equals(itemForms[i]) || !branchTemp.equals(branch[i]) || !storeTemp.equals(store[i])) {
                                    try {
                                        if (transactionMgr.saveMutiFormTrans(request, savingList, "91")) {
                                            if (transactionMgr.saveMutiFormTrans(request, savingList, "92")) {
                                                if (usedSparePartsMgr.saveItemsObject(qty, prices, costCenterCode, notes, itemIds, branch, store, uid, "0", attached_On, efficient, session)) {
                                                    request.setAttribute("status", "ok");
                                                }
                                            }
                                            savingList.clear();
                                            itemIds = new String[arrItems.length];
                                            qty = new String[arrItems.length];
                                            price = new String[arrItems.length];
                                            note = new String[arrItems.length];
                                            tableItem.put("itemId", arrItems[i]);
                                            tableItem.put("qnty", arrQty[i]);
                                            tableItem.put("isMust", isMust);
                                            tableItem.put("itemForm", itemForms[i]);
                                            tableItem.put("costCode", costCenterCode[i]);
                                            tableItem.put("branch", branch[i]);
                                            tableItem.put("store", store[i]);
                                            itemIds[i] = arrItems[i];
                                            String testQ = arrQty[i];
                                            qty[i] = arrQty[i];
                                            prices[i] = "0.0";
                                            notes[i] = "none";
                                            attached_On[i] = "2";
                                            efficient[i] = "0.0";
                                            itemFormTemp = itemForms[i];
                                            branchTemp = branch[i];
                                            storeTemp = store[i];
                                            savingList.add(tableItem);

                                        } else {
                                            request.setAttribute("status", "no");
                                        }
                                    } catch (SQLException ex) {
                                        logger.error(ex.getMessage());
                                    }
                                } else {
                                    tableItem.put("itemId", arrItems[i]);
                                    tableItem.put("qnty", arrQty[i]);
                                    tableItem.put("isMust", isMust);
                                    tableItem.put("itemForm", itemForms[i]);
                                    tableItem.put("costCode", costCenterCode[i]);
                                    tableItem.put("branch", branch[i]);
                                    tableItem.put("store", store[i]);
                                    itemIds[i] = arrItems[i];
                                    String testQ = arrQty[i];
                                    qty[i] = arrQty[i];
                                    prices[i] = "0.0";
                                    notes[i] = "none";
                                    attached_On[i] = "2";
                                    efficient[i] = "0.0";
                                    itemFormTemp = itemForms[i];
                                    branchTemp = branch[i];
                                    storeTemp = store[i];
                                    savingList.add(tableItem);
                                }
                            } else {
                                tableItem.put("itemId", arrItems[i]);
                                tableItem.put("qnty", arrQty[i]);
                                tableItem.put("isMust", isMust);
                                tableItem.put("itemForm", itemForms[i]);
                                tableItem.put("costCode", costCenterCode[i]);
                                tableItem.put("branch", branch[i]);
                                tableItem.put("store", store[i]);
                                itemIds[i] = arrItems[i];
                                String testQ = arrQty[i];
                                qty[i] = testQ;
                                prices[i] = "0.0";
                                notes[i] = "none";
                                attached_On[i] = "2";
                                efficient[i] = "0.0";
                                itemFormTemp = itemForms[i];
                                branchTemp = branch[i];
                                storeTemp = store[i];
                                savingList.add(tableItem);
                            }
                        }
                        if (count == arrItems.length) {
                            try {
                                if (transactionMgr.saveMutiFormTrans(request, savingList, "91")) {
                                    if (transactionMgr.saveMutiFormTrans(request, savingList, "92")) {
                                        if (usedSparePartsMgr.saveItemsObject(qty, prices, costCenterCode, notes, itemIds, branch, store, uid, "0", attached_On, efficient, session)) {
                                            request.setAttribute("status", "ok");
                                        }
                                    }
                                } else {
                                    request.setAttribute("status", "no");
                                }
                            } catch (SQLException ex) {
                                logger.error(ex);
                            }
                        }
                    }        //////////////// End Save  /////////////

                    // delete all reconfig task
                    if (request.getAttribute("status") != null && request.getAttribute("status").toString().equals("ok")) {
                        reconfigTaskMgr.deleteOnArbitraryKey(issueId, "key1");
                    }

                    wboIssue = issueMgr.getOnSingleKey(issueId);
                    if (wboIssue.getAttribute("issueTitle").toString().equals("Emergency")) {
                        issueMgr.getUpdateCaseConfigEmg(wboIssue.getAttribute("unitScheduleID").toString());
                    }
                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }

                ListItems = QuantifiedMntenceMgr.getInstance();
                if (page.equalsIgnoreCase("localspares")) {
                    servedPage = "/docs/issue/schedule_config_Local_parts.jsp";
                    itemListTemp = quantifiedMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(), "1");
                } else {
                    servedPage = "/docs/issue/schedule_config_parts.jsp";
                    itemListTemp = quantifiedMgr.getSpecialItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString(), "0");
                }

                if (scheduleId.equalsIgnoreCase("1") || scheduleId.equalsIgnoreCase("2")) {
                    ListItems = QuantifiedMntenceMgr.getInstance();
                    if (page.equalsIgnoreCase("localspares")) {
                        itemList = ListItems.getSpecialItemSchedule(uSID, "1");
                    } else {
                        itemList = ListItems.getSpecialItemSchedule(uSID, "0");
                    }
                } else {
                    if (page.equalsIgnoreCase("localspares")) {
                        itemList = itemListTemp;
                    } else {
                        if (itemListTemp.isEmpty()) {
                            ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                            itemList = itemsList.getConfigItemBySchedule(scheduleId);
                        } else {
                            itemList = itemListTemp;
                        }
                    }
                }

                for (int i = 0; i < itemList.size(); i++) {
                    WebBusinessObject itemListWbo = (WebBusinessObject) itemList.get(i);
                    String[] keys = {"key1", "key2", "key3"};
                    String[] values = {"91", issueId, itemListWbo.getAttribute("itemId").toString()};
                    try {
                        Vector result = transStoreItemMgr.getOnArbitraryNumberKey(3, values, keys);
                        if (result.size() > 0) {
                            itemListWbo.setAttribute("canDelete", false);
                        } else {
                            itemListWbo.setAttribute("canDelete", true);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                /// begin ///
                attachedEqps = new Vector();
                minorAttachedEqps = new Vector();
                attachFlag = 0;
                supplementMgr = SupplementMgr.getInstance();
                unitScheduleMgr = UnitScheduleMgr.getInstance();
                unit_sch_wbo = unitScheduleMgr.getOnSingleKey(uid);
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

                // get all Store From Erp as ex.
                Tools.setRequestByStoreInfo(request);

                request.setAttribute("data", itemList);
                request.setAttribute("uID", uID);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                /// end ////
                request.setAttribute("projectName", projectID);
                request.setAttribute("vecUserTrades", vecUserTrades);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 12:
                issueId = request.getParameter("issueId");

                wIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                request.setAttribute("issueId", wIssue.getAttribute("id"));
                request.setAttribute("wbo", wIssue);
                servedPage = "/docs/issue/issue_details_pop_up.jsp";

                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 13:
                servedPage = "/docs/issue/Add_labor_complint.jsp";

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                issueId = request.getParameter("issueId");

                try {
                    //get current equipment labor
                    WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                    unitScheduleWbo = usMgr.getOnSingleKey(issueWbo.getAttribute("unitScheduleID").toString());
                    Vector driversVec = driverHistoryMgr.getOnArbitraryDoubleKeyOracle(unitScheduleWbo.getAttribute("unitId").toString(), "key1", null, "key3");
                    WebBusinessObject driverWbo = (WebBusinessObject) driversVec.elementAt(0);

                    request.setAttribute("currentEmpWbo", driverWbo);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("issueId", issueId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 14:
                status = "failed";

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");

                try {
                    //get current equipment labor
                    WebBusinessObject issueWbo = issueMgr.getOnSingleKey(request.getParameter("issueId").toString());
                    unitScheduleWbo = usMgr.getOnSingleKey(issueWbo.getAttribute("unitScheduleID").toString());
//                    Vector driversVec = driverHistoryMgr.getOnArbitraryDoubleKeyOracle(unitScheduleWbo.getAttribute("unitId").toString(),"key1", null,"key3");
//                    WebBusinessObject driverWbo = (WebBusinessObject) driversVec.elementAt(0);
//
//                    request.setAttribute("currentEmpWbo", driverWbo);

                    //Delete All records then insert
                    String[] isRelated = request.getParameterValues("related");
                    String[] compIds = request.getParameterValues("compId");
                    String[] deletedIds = request.getParameterValues("deletedId");

                    if (deletedIds != null) {
                        for (int i = 0; i < deletedIds.length; i++) {
                            if (!deletedIds[i].equalsIgnoreCase("new")) {
                                laborMgr.deleteOnArbitraryKey(deletedIds[i], "key");
                            }
                        }
                    }

                    if (isRelated != null) {
                        for (int i = 0; i < isRelated.length; i++) {
                            if (isRelated[i].equalsIgnoreCase("no")) {
                                laborMgr.deleteOnArbitraryKey(compIds[i], "key");
                            }
                        }
                    }

                    //insert new records
                    String[] comp = request.getParameterValues("comp");
                    boolean flag = true;

                    for (int i = 0; i < isRelated.length; i++) {
                        if (!isRelated[i].equalsIgnoreCase("yes")) {
                            flag = false;
                        }
                    }
                    if (comp == null || flag == true) {
                        status = "ok";
                    } else {
                        if (laborMgr.saveObject(request)) {
                            status = "ok";
                        } else {
                            status = "failed";
                        }
                    }

                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                servedPage = "/docs/issue/Add_labor_complint.jsp";

                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("issueId", request.getParameter("issueId"));
                request.setAttribute("Status", status);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 15:
                Vector compTasksVec = new Vector();

                filterName = (String) request.getParameter("filterName");
                filterValue = (String) request.getParameter("filterValue");
                String isId = request.getParameter("issueId");
                String maintTitle = request.getParameter("maintTitle");
                String jobNo = request.getParameter("jobNo");
                status = "Fail";

                LaborComplaintsMgr lbMgr = LaborComplaintsMgr.getInstance();
                IssueTasksComplaintMgr issueCompliantsMgr = IssueTasksComplaintMgr.getInstance();

                try {
                    Vector issueComplaintsVec = issueCompliantsMgr.getOnArbitraryKey(isId, "key1");

                    if (issueComplaintsVec != null || issueComplaintsVec.size() <= 0) {
                        for (int i = 0; i < issueComplaintsVec.size(); i++) {
                            WebBusinessObject issueCompWbo = (WebBusinessObject) issueComplaintsVec.elementAt(i);

                            issueCompliantsMgr.deleteOnSingleKey(issueCompWbo.getAttribute("id").toString());
                            // issueTasksMgr.deleteOnArbitraryDoubleKey(isId,"key1", issueCompWbo.getAttribute("taskID").toString(), "key2");
                        }
                    }

                    String[] tasks = request.getParameterValues("taskId");
                    for (int i = 0; i < tasks.length; i++) {
                        if (!tasks[i].equalsIgnoreCase("---")) {
                            status = "fail";
                            break;
                        } else {
                            status = "ok";
                        }
                    }

                    if (!status.equalsIgnoreCase("ok")) {
                        if (lbMgr.newob(request, isId)) {
                            status = "ok";
                        }
                    }

                    //get issue_complaints
                    compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("status", status);
                request.setAttribute("maintTitle", maintTitle);
                request.setAttribute("jobNo", jobNo);
                request.setAttribute("issueId", isId);
                request.setAttribute("comp", compTasksVec);
                servedPage = "/docs/issue/combine_comp.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 16:
                issueId = request.getParameter("issueId");
                myIssue = issueMgr.getOnSingleKey(issueId);
                unitId = (String) myIssue.getAttribute("unitId");
                WebBusinessObject wboEquipment = maintainableMgr.getOnSingleKey(unitId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                actualBeginDate = issueMgr.getActualBeginDate(issueId);
                issueTitle = (String) myIssue.getAttribute("issueTitle");
                String projectName = "***";
                try {
                    projectName = projectMgr.getOnSingleKey(myIssue.getAttribute("projectName").toString()).getAttribute("projectName").toString();
                } catch (Exception ex) {
                }

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");

                web = usMgr.getOnSingleKey(uID);
                scheduleId = (String) web.getAttribute("periodicId");

                // save tasks for schedule to issue_task
                this.issueTasksMgr.saveTasksForScheduleActive(issueId, scheduleId, userId);

                // get Average unit record
                long LastReading = 0;
                long prvReading = 0;
                String readingNote = "",
                 dateReading = "";
                averageUnitId = "";
                existRowInAvgUnit = "no";
                longLastDateReading = "";
                Vector<WebBusinessObject> avergeUnitVec = new Vector<WebBusinessObject>();
                try {
                    avergeUnitVec = averageUnitMgr.getOnArbitraryKey(unitId, "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                if (avergeUnitVec != null && !avergeUnitVec.isEmpty()) {
                    WebBusinessObject wbo = avergeUnitVec.get(0);

                    existRowInAvgUnit = "yes";
                    averageUnitId = (String) wbo.getAttribute("id");
                    longLastDateReading = (String) wbo.getAttribute("entry_Time");
                    LastReading = Tools.convertLong((String) wbo.getAttribute("current_Reading"));
                    prvReading = Tools.convertLong((String) wbo.getAttribute("acual_Reading"));
                    dateReading = Tools.getDate(longLastDateReading);
                    readingNote = (String) wbo.getAttribute("description");
                }

                // if case not null
                if (request.getParameter("case") != null) {
                    request.setAttribute("case", request.getParameter("case"));
                    request.setAttribute("title", request.getParameter("title"));
                    request.setAttribute("unitName", request.getParameter("unitName"));

                }
                servedPage = "/docs/issue/internal_assign_issue.jsp";
                request.setAttribute("arrayCrewCodeList", crewMissionMgr.getCashedTableAsBusObjects());
                request.setAttribute("uID", uID);
                request.setAttribute("actualBeginDate", actualBeginDate);
                request.setAttribute("scheduleId", scheduleId);
                request.setAttribute("wboEquipment", wboEquipment);
                request.setAttribute("wboIssue", myIssue);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("projectName", projectName);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("averageUnitId", averageUnitId);
                request.setAttribute("longLastDateReading", longLastDateReading);
                request.setAttribute("lastReading", LastReading);
                request.setAttribute("prvReading", prvReading);
                request.setAttribute("readingNote", readingNote);
                request.setAttribute("dateReading", dateReading);
                request.setAttribute("existRowInAvgUnit", existRowInAvgUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 17:
                itemListTemp = new Vector();
                projectname = request.getParameter("projectName");
                ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                issueId = request.getParameter(IssueConstants.ISSUEID);

                myIssue = issueMgr.getOnSingleKey(issueId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");

                itemList = new Vector();
                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                ListItems = QuantifiedMntenceMgr.getInstance();
                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "1");

                web = usMgr.getOnSingleKey(uID);

                scheduleId = web.getAttribute("periodicId").toString();

                if (scheduleId.equalsIgnoreCase("1") || scheduleId.equalsIgnoreCase("2")) {
                    itemList = ListItems.getSpecialItemSchedule(uSID, "1");
                } else {
                    itemList = itemListTemp;
                }

                attachedEqps = new Vector();
                attachFlag = 0;
                supplementMgr = SupplementMgr.getInstance();
                unitScheduleMgr = UnitScheduleMgr.getInstance();
                unit_sch_wbo = unitScheduleMgr.getOnSingleKey(uID);
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

                servedPage = "/docs/issue/schedule_config_Local_parts.jsp";
                request.setAttribute("data", itemList);
                request.setAttribute("uID", uID);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                request.setAttribute(IssueConstants.STATE, ais);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 19:
                issueId = (String) request.getParameter("issueId");
                issueCompliantsMgr = IssueTasksComplaintMgr.getInstance();
                try {
                    Vector issueComplaintsVec = issueCompliantsMgr.getOnArbitraryKey(issueId, "key1");

                    if (issueComplaintsVec != null || issueComplaintsVec.size() <= 0) {
                        for (int i = 0; i < issueComplaintsVec.size(); i++) {
                            WebBusinessObject issueCompWbo = (WebBusinessObject) issueComplaintsVec.elementAt(i);

                            issueCompliantsMgr.deleteOnSingleKey(issueCompWbo.getAttribute("id").toString());
                        }
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                response.setContentType("text/xml;charset=UTF-8");
                response.setHeader("Cache-Control", "no-cache");
                issueId = (String) request.getSession().getAttribute("issueId");
                response.getWriter().write(issueId);

                break;
            case 20:
                issueId = request.getParameter(IssueConstants.ISSUEID);
                myIssue = issueMgr.getOnSingleKey(issueId);

                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                issueState = request.getParameter("issueState");

                //issueMgr.saveEmgObject(request, wboIssue, session)
                servedPage = "/docs/issue/edit_jobOrder.jsp";

                request.setAttribute("issueId", issueId);
                request.setAttribute("myIssue", myIssue);
                request.setAttribute("issueTitle", issueTitle);
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("issueState", issueState);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 21:
                dateAndTime = new DateAndTimeControl();
                int minutes = 0;
                issueId = request.getParameter(IssueConstants.ISSUEID);
                myIssue = issueMgr.getOnSingleKey(issueId);

                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                issueState = request.getParameter("issueState");
                String trade = request.getParameter("trade");
                String shift = request.getParameter("shift");
                String duration = request.getParameter("duration");
                String issueDesc = request.getParameter("issueDesc");
                String day = (String) request.getParameter("day");
                String hours = (String) request.getParameter("hour");
                String minute = (String) request.getParameter("minute");

                if (day != null && !day.equals("")) {
                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
                }
                if (hours != null && !hours.equals("")) {
                    minutes = minutes + dateAndTime.getMinuteOfHour(hours);
                }
                if (minute != null && !minute.equals("")) {
                    minutes = minutes + new Integer(minute).intValue();
                }
                myIssue.setAttribute("workTrade", trade);
                myIssue.setAttribute("shift", shift);
                myIssue.setAttribute("estimatedduration", minutes);

                myIssue.setAttribute("issueDesc", issueDesc);
                issueMgr.updateJobOrder(myIssue);
                //issueMgr.saveEmgObject(request, wboIssue, session)
                myIssue = issueMgr.getOnSingleKey(issueId);
                sitDate = issueMgr.getsitDate(issueId);

                scheduleUnitID = (String) myIssue.getAttribute("unitScheduleID");
                unitScheduleMgr = UnitScheduleMgr.getInstance();
                unitScheduleWbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                servedPage = "/docs/assigned_issue/assigned_issue_details.jsp";

                request.setAttribute("sitDate", sitDate);
                request.setAttribute("issueId", issueId);
                request.setAttribute("webIssue", myIssue);
                request.setAttribute("issueTitle", issueTitle);
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("issueState", issueState);

                request.setAttribute("actualBeginDate", issueMgr.getActualBeginDate(issueId));
                request.setAttribute("projectName", myIssue.getAttribute("projectName").toString());

                request.setAttribute("mainTitle", "Emergency&backTo=all");
                //mainTitle=Emergency&backTo=all
                request.setAttribute("equipmentID", unitScheduleWbo.getAttribute("unitId"));

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 22:
                issueId = request.getParameter("issueId");
                filterValue = request.getParameter("filterValue");
                filterName = request.getParameter("filterName");
                projectname = request.getParameter("projectName");
                mainTitle = request.getParameter("mainTitle");

                servedPage = "/docs/assigned_issue/confirm_delJobOrder.jsp";

                request.setAttribute("issueId", issueId);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("filterName", filterName);
                request.setAttribute("projectName", projectname);
                request.setAttribute("mainTitle", mainTitle);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 23:
                issueId = request.getParameter("issueId");
                filterValue = request.getParameter("filterValue");
                filterName = request.getParameter("filterName");
                projectname = request.getParameter("projectName");
                mainTitle = request.getParameter("mainTitle");
                issueMgr = IssueMgr.getInstance();
                WebBusinessObject objectXml = issueMgr.getOnSingleKey(issueId);

                HttpSession sess = request.getSession(true);
                sess.removeAttribute("case");
                sess.removeAttribute("unitName");
                sess.removeAttribute("title");
                sess.removeAttribute("EquipMentID");
                IssueEquipmentMgr issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                Vector issueList = null;
                String statusName = "All";
                String ts = "SearchServlet";

                loggedUser = (WebBusinessObject) sess.getAttribute("loggedUser");

                unitScheduleMgr = UnitScheduleMgr.getInstance();
                TransactionMgr transactionMgr = TransactionMgr.getInstance();
                TransactionDetailsMgr transactionDetailsMgr = TransactionDetailsMgr.getInstance();
                TransactionStatusMgr transactionStatusMgr = TransactionStatusMgr.getInstance();
                issueTasksMgr = IssueTasksMgr.getInstance();
                try {
                    String ScheduleUnitId = issueMgr.getScheduleUnitId(issueId);        //To delete Schedule Unit

                    if (ScheduleUnitId != null && !ScheduleUnitId.equalsIgnoreCase("")) {
                        //if(unitScheduleMgr.deleteOnSingleKey(ScheduleUnitId)) {
                        Vector transactionsVec = transactionMgr.getOnArbitraryKey(issueId, "key2");
                        if (transactionsVec != null && transactionsVec.size() > 0) {  //To delete Transactions
                            for (int i = 0; i < transactionsVec.size(); i++) {
                                WebBusinessObject transactionWbo = (WebBusinessObject) transactionsVec.get(i);
                                transactionMgr.deleteTransactionResult(transactionWbo.getAttribute("transactionNO").toString()); //To delete Transactions Result
                                transactionStatusMgr.deleteTransactionStatus(transactionWbo.getAttribute("transactionNO").toString()); //To delete Transactions Status

                                Vector transactionDetailsVec = transactionDetailsMgr.getOnArbitraryKey(transactionWbo.getAttribute("transactionNO").toString(), "key2");
                                if (transactionDetailsVec != null && transactionDetailsVec.size() > 0) { //To delete Transactions Details
                                    for (int j = 0; j < transactionDetailsVec.size(); j++) {
                                        WebBusinessObject transactionDetailsWbo = (WebBusinessObject) transactionDetailsVec.get(i);
                                        transactionDetailsMgr.deleteOnSingleKey(transactionDetailsWbo.getAttribute("id").toString());
                                    }
                                }
                                transactionMgr.deleteOnSingleKey(transactionWbo.getAttribute("id").toString());
                            }
                        }
                        unitScheduleMgr.deleteOnSingleKey(ScheduleUnitId);
                    }

                    WebBusinessObject issueTasksWbo = issueTasksMgr.getOnSingleKey1(issueId);
                    if (issueTasksWbo != null) {
                        issueTasksMgr.deleteOnSingleKey(issueTasksWbo.getAttribute("issueID").toString());
                    }
                    loggerWbo = new WebBusinessObject();
                    if (issueMgr.deleteOnSingleKey(issueId)) {
                        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", issueId);
                        loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", "Job Order");
                        loggerWbo.setAttribute("loggerMessage", "Job Order Deleted");
                        loggerWbo.setAttribute("eventName", "Delete");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "2");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        loggerMgr.saveObject(loggerWbo);
                    }

                    request.getSession().removeAttribute("sideMenuVec");

                    /*issueCompliantsMgr = IssueTasksComplaintMgr.getInstance();
                     //try {
                     Vector issueComplaintsVec = issueCompliantsMgr.getOnArbitraryKey(issueId,"key1");
                    
                     if(issueComplaintsVec != null || issueComplaintsVec.size() <= 0){
                     for(int i=0; i<issueComplaintsVec.size(); i++){
                     WebBusinessObject issueCompWbo = (WebBusinessObject) issueComplaintsVec.elementAt(i);
                    
                     issueCompliantsMgr.deleteOnSingleKey(issueCompWbo.getAttribute("id").toString());
                     }
                     } */
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("filterValue", filterValue);
                request.setAttribute("filterName", filterName);

                if (request.getParameter("filterValue").toString().equalsIgnoreCase("null")) {
                    servedPage = "/manager_agenda.jsp";
                } else {
                    //servedPage = "/docs/issue/issue_listing.jsp";
                    String equipmentID = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
                    eqWbo = maintainableMgr.getOnSingleKey(equipmentID);

                    String params = "&filterValue=" + filterValue + "&projectName=" + request.getParameter("projectName") + "&statusName=" + statusName;
                    try {
                        servedPage = "/docs/issue/issue_listing.jsp";
                        // servedPage = "/docs/issue/issue_report.jsp";
                        issueEquipmentMgr.setUser((WebBusinessObject) request.getSession().getAttribute("loggedUser"));
                        if (equipmentID.equalsIgnoreCase("ALL")) {
                            issueList = issueEquipmentMgr.getALLIssuesByTrade(request, request.getParameter("op"), filterValue, session);
                        } else {
                            issueList = issueEquipmentMgr.getIssuesInRangeByTrade(request.getParameter("op"), filterValue, session);
                        }

                        complexIssueMgr = ComplexIssueMgr.getInstance();
                        Vector checkIsCmplx = new Vector();
                        Vector subIssueList = new Vector();
                        WebBusinessObject wbo = new WebBusinessObject();
                        int count = 0;
                        String tempcount = (String) request.getParameter("count");
                        if (tempcount != null) {
                            count = Integer.parseInt(tempcount);
                        }

                        int index = (count + 1) * 10;
                        if (issueList.size() < index) {
                            index = issueList.size();
                        }
                        for (int i = count * 10; i < index; i++) {
                            wbo = (WebBusinessObject) issueList.get(i);
                            try {
                                checkIsCmplx = complexIssueMgr.getOnArbitraryKey(wbo.getAttribute("id").toString(), "key1");
                                if (checkIsCmplx.size() > 0) {
                                    wbo.setAttribute("issueType", "cmplx");
                                } else {
                                    wbo.setAttribute("issueType", "normal");
                                }
                            } catch (Exception e) {
                            }
                            subIssueList.add(wbo);
                        }

                        float noOfLinks = issueList.size() / 10f;
                        String temp = "" + noOfLinks;
                        int intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                        int links = (int) noOfLinks;
                        if (intNo > 0) {
                            links++;
                        }
                        if (links == 1) {
                            links = 0;
                        }

                        String lastFilter = "SearchServlet?op=StatusProjectList" + params;
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
                            topMenu.put("jobOrder", new Vector());
                            topMenu.put("task", new Vector());
                            topMenu.put("schedule", new Vector());
                            topMenu.put("equipment", new Vector());
                            tempVec = new Vector();
                            tempVec.add("lastFilter");
                            tempVec.add(lastFilter);
                            topMenu.put("lastFilter", tempVec);

                        }
                        request.getSession().setAttribute("topMenu", topMenu);

                        request.setAttribute("filterName", "StatusProjectListAll");

                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("count", "" + count);
                        request.setAttribute("noOfLinks", "" + links);
                        request.setAttribute("data", subIssueList);
                        request.setAttribute("ts", ts);
//                        request.setAttribute("page", servedPage);
                        request.setAttribute("status", statusName);
                        request.setAttribute("eqWbo", eqWbo);
                        request.setAttribute("ViewBack", "false");

                    } catch (SQLException sqlEx) {
                        logger.error(sqlEx.getMessage());
                    } catch (Exception e) {
                        logger.error(e.getMessage());
                    }
                }

                request.setAttribute("issueId", issueId);

                request.setAttribute("projectName", projectname);
                request.setAttribute("mainTitle", mainTitle);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 24:
                issueId = (String) request.getParameter("issueId");

                tasks = new Vector<WebBusinessObject>();
                try {
                    tasks = tasksByIssueMgr.getOnArbitraryKey(issueId, "key");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                for (WebBusinessObject task : tasks) {
                    taskId = (String) task.getAttribute("taskId");
                    task.setAttribute("reconfigTask", reconfigTaskMgr.getReconfigTaskByItemName(issueId, taskId));
                }

                servedPage = "/docs/issue/view_reconfig_items_by_tasks.jsp";

                request.setAttribute("issueId", issueId);
                request.setAttribute("tasks", tasks);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 25:
                itemListTemp = new Vector();
                projectname = request.getParameter("projectName");
                this.assignedIssueState = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
//                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                issueId = request.getParameter(IssueConstants.ISSUEID);

                myIssue = issueMgr.getOnSingleKey(issueId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                attachedEqFlag = (String) request.getParameter("attachedEqFlag");

                itemList = new Vector();
                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();

                UsedSparePartsMgr ListUsedItems = UsedSparePartsMgr.getInstance();
                itemListTemp = ListUsedItems.getUsedItemSchedule(uSID);
                itemList = itemListTemp;

                Vector<WebBusinessObject> configitemList = new Vector();
                // uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();

                ListItems = QuantifiedMntenceMgr.getInstance();
                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "0");
                web = usMgr.getOnSingleKey(uID);
                String eID;
                eID = web.getAttribute("periodicId").toString();
                if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
                    configitemList = ListItems.getSpecialItemSchedule(uSID, "0");
                } else {
                    if (itemListTemp.size() == 0) {
                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                        configitemList = itemsList.getConfigItemBySchedule(eID);
                    } else {
                        configitemList = itemListTemp;
                    }
                }
                int partSum = 0;
                for (int i = 0; i < configitemList.size(); i++) {
                    partSum += Integer.parseInt((String) configitemList.get(i).getAttribute("itemQuantity"));
                }
//                web=usMgr.getOnSingleKey(uID);
//
//                eID=web.getAttribute("periodicId").toString();
//                if(eID.equalsIgnoreCase("1")||eID.equalsIgnoreCase("2")){
//                    itemList=ListUsedItems.getSpecialItemSchedule(uSID,"0");
//                } else{
//                    if(itemListTemp.size()==0) {
//                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
//                        itemList = itemsList.getConfigItemBySchedule(eID);
//                    } else {
//                        itemList = itemListTemp;
//                    }
//                }

                // get all Store From Erp as ex.
                Tools.setRequestByStoreInfo(request);

                servedPage = "/docs/issue/schedule_config_used_parts.jsp";
                request.setAttribute("partsSum", partSum);
                request.setAttribute("data", itemList);
                request.setAttribute("configdata", configitemList);
                request.setAttribute("attachedEqFlag", attachedEqFlag);
                request.setAttribute("uID", uID);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                request.setAttribute(IssueConstants.STATE, this.assignedIssueState);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 26:
                //// begin ////
                transactionMgr = TransactionMgr.getInstance();
                page = request.getParameter("page").toString();
                wboIssue = new WebBusinessObject();
                projectname = request.getParameter("projectName");
                this.assignedIssueState = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                issueId = request.getParameter(IssueConstants.ISSUEID);
                UsedSparePartsMgr usedSparePartsMgr = UsedSparePartsMgr.getInstance();
                myIssue = issueMgr.getOnSingleKey(issueId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                itemListTemp = new Vector();
                itemList = new Vector();
                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();

                //String eID;
                web = usMgr.getOnSingleKey(uID);

                eID = web.getAttribute("periodicId").toString();

                WebIssue weebIssue = new WebIssue();
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                projectID = request.getParameter("projectID");
                destination = AppConstants.getFullLink("VIEWDETAILS", filterValue);
                issueTitle = request.getParameter("issueTitle");
                assignNote = request.getParameter("assignNote");
                scrapeForm(request);
                //webIssue.setAttribute("empID", request.getParameter("empName"));
                //webIssue.setAttribute("failurecode", request.getParameter("failurecode"));
                uid = request.getParameter("uID");

                TotaleCost = request.getParameterValues("totale");
                issueId = request.getParameter(IssueConstants.ISSUEID);
                try {
                    if (page.equalsIgnoreCase("localspares")) {
                        // this.usedSparePartsMgr.deleteOnArbitraryDoubleKey(uid, "key1","1","key2");
                    } else {
                        //  this.usedSparePartsMgr.deleteOnArbitraryDoubleKey(uid, "key1","0","key2");
                    }

                    //assignedIssueMgr.saveObject(webIssue, s,assignNote);
                    issueMgr.updateTotalCost(new Float(TotaleCost[0]).floatValue(), issueId);
                    request.setAttribute("TotaleCost", TotaleCost[0]);
                    //assignedIssueMgr.saveObjectCost(uid,TotaleCost[0]);

                    /////////////////
                    String[] quantity = request.getParameterValues("qun");
                    String[] price = request.getParameterValues("price");
                    String[] cost = request.getParameterValues("cost");
                    String[] note = request.getParameterValues("note");
                    String[] id = request.getParameterValues("code");
                    String[] branchs = request.getParameterValues("branch");
                    String[] stores = request.getParameterValues("store");
                    String[] efficient = request.getParameterValues("efficient");
                    String isDirectPrch = request.getParameter("isDirectPrch").toString();

//                    String attOn=(String)request.getParameter("attachedOn");
                    String attOn = "2!";
                    if (attOn != null) {
                        attOn = attOn.substring(0, attOn.length() - 1);
                        String[] attachedOn = attOn.split("!");
//                    String[] attachedOn=request.getParameterValues("checkattachEq");
                        if (usedSparePartsMgr.saveItemsObject(quantity, price, cost, note, id, branchs, stores, uid, isDirectPrch, attachedOn, efficient, session)) {
                            List savingList = new ArrayList();
                            Hashtable tableItem = new Hashtable();

                            for (int x = 0; x < quantity.length; x++) {
                                tableItem = new Hashtable();
                                // savingList.clear();
                                String[] item = id[x].split("-");
                                String itemCode = item[1];
                                String itemForm = item[0];

                                tableItem.put("itemId", id[x]);
                                tableItem.put("qnty", quantity[x]);
                                tableItem.put("itemForm", itemForm);
                                tableItem.put("branch", branchs[x]);
                                tableItem.put("store", stores[x]);
                                tableItem.put("isMust", "yes");
                                tableItem.put("costCode", "");

                                savingList.add(tableItem);
                            }
                            if (transactionMgr.saveMutiFormTrans(request, savingList, "92")) {
                                request.setAttribute("status", "ok");
                            }

                        } else {
                            request.setAttribute("status", "no");
                        }
                    } else {
                        if (id != null) {
                            String[] attachedOn = new String[id.length];
                            for (int i = 0; i < id.length; i++) {
                                attachedOn[i] = "2";
                            }
                            if (usedSparePartsMgr.saveItemsObject(quantity, price, cost, note, id, branchs, stores, uid, isDirectPrch, attachedOn, efficient, session)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        }
                    }
//                    wboIssue = issueMgr.getOnSingleKey(issueId);
//                    if(wboIssue.getAttribute("issueTitle").toString().equals("Emergency")){
//                        issueMgr.getUpdateCaseConfigEmg(wboIssue.getAttribute("unitScheduleID").toString());
//                    }
                    ////////////////////

                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }

                ListItems = QuantifiedMntenceMgr.getInstance();

                itemListTemp = usedSparePartsMgr.getUsedItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                itemList = itemListTemp;

//                if(eID.equalsIgnoreCase("1")||eID.equalsIgnoreCase("2")){
//
//                    ListItems=QuantifiedMntenceMgr.getInstance();
//                    if(page.equalsIgnoreCase("localspares")){
//                        itemList=ListItems.getSpecialItemSchedule(uSID,"1");
//                    }else{
//                        itemList=ListItems.getSpecialItemSchedule(uSID,"0");
//                    }
//                } else{
//                    if(page.equalsIgnoreCase("localspares")){
//                        itemList = itemListTemp;
//                    }else{
//                        if(itemListTemp.size()==0) {
//                            ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
//                            itemList = itemsList.getConfigItemBySchedule(eID);
//                        } else {
//                            itemList = itemListTemp;
//                        }
//                    }
//                }
                /// begin ///
                attachedEqps = new Vector();
                minorAttachedEqps = new Vector();
                attachFlag = 0;
                supplementMgr = SupplementMgr.getInstance();
                unitScheduleMgr = UnitScheduleMgr.getInstance();
                unit_sch_wbo = unitScheduleMgr.getOnSingleKey(uid);
                Eq_ID = (String) unit_sch_wbo.getAttribute("unitId");
                attachedEqps = supplementMgr.search(Eq_ID);
                minorAttachedEqps = supplementMgr.searchAllowedEqps(Eq_ID);
                String attache;
                if (attachedEqps.size() > 0) {
                    attache = "attached";
                    request.setAttribute("attachedEqFlag", "attached");
                } else {
                    if (minorAttachedEqps.size() > 0) {
                        attache = "attached";
                        request.setAttribute("attachedEqFlag", "attached");
                    } else {
                        attache = "notAtt";
                        request.setAttribute("attachedEqFlag", "notAtt");
                    }

                }

                // get all Store From Erp as ex.
                Tools.setRequestByStoreInfo(request);

                request.setAttribute("data", itemList);
                request.setAttribute("uID", uID);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                /// end ////
                request.setAttribute("projectName", projectID);
                this.forward("AssignedIssueServlet?op=configUsedParts&attachedEqFlag=" + attache, request, response);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 27:
                servedPage = "/docs/issue/cost_centers_list.jsp";
                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                Vector schedules = new Vector();
                //String[] sitesAll = request.getParameterValues("site");
                //String sites_all = request.getParameter("site");//Tools.concatenation(sitesAll, ",");
                filter = Tools.getPaginationInfo(request, response);

                List<FilterCondition> conditions = filter.getConditions();

                // add conditions
                String[] fieldNames = request.getParameterValues("fieldName");
                String[] fieldValues = request.getParameterValues("fieldValue");
                for (int i = 0; i < fieldNames.length; i++) {
                    if (fieldNames[i].equals("COSTNAME")) {

                        String field_value = new String("");
                        field_value = Tools.getRealChar((String) fieldValues[i]);
                        conditions.add(new FilterCondition("LATIN_NAME", field_value, Operations.LIKE));
                        filter.setConditions(conditions);
                        break;
                    } else if (fieldNames[i].equals("LATIN_NAME")) {

                        String field_value = new String("");
                        field_value = Tools.getRealChar((String) fieldValues[i]);
                        conditions.add(new FilterCondition("COSTNAME", field_value, Operations.LIKE));
                        filter.setConditions(conditions);
                        break;
                    }

                }
                CostCentersMgr costCentersMgr = CostCentersMgr.getInstance();
                List<WebBusinessObject> costCenters = new ArrayList<WebBusinessObject>(0);

                //grab scheduleList list
                try {
                    costCenters = costCentersMgr.paginationEntityByOR(filter, "");
                } catch (Exception e) {
                    System.out.println(e);
                }
                String selectionType = request.getParameter("selectionType");

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
                request.setAttribute("costCenters", costCenters);
                this.forward(servedPage, request, response);
                break;
            case 28:
                compTasksVec = new Vector();
                filterName = (String) request.getParameter("filterName");
                filterValue = (String) request.getParameter("filterValue");
                isId = request.getParameter("issueId");
                maintTitle = request.getParameter("maintTitle");
                jobNo = request.getParameter("jobNo");
                String arr = request.getParameter("arr");
                String total = request.getParameter("total");
                status = "Fail";

                lbMgr = LaborComplaintsMgr.getInstance();
                issueCompliantsMgr = IssueTasksComplaintMgr.getInstance();

                try {
                    Vector issueComplaintsVec = issueCompliantsMgr.getOnArbitraryKey(isId, "key1");
                    if (arr.equals(total)) {
                        if (issueComplaintsVec != null || issueComplaintsVec.size() <= 0) {
                            for (int i = 0; i < issueComplaintsVec.size(); i++) {
                                WebBusinessObject issueCompWbo = (WebBusinessObject) issueComplaintsVec.elementAt(i);

                                issueCompliantsMgr.deleteOnSingleKey(issueCompWbo.getAttribute("id").toString());
                                // issueTasksMgr.deleteOnArbitraryDoubleKey(isId,"key1", issueCompWbo.getAttribute("taskID").toString(), "key2");
                            }
                        }
                    }

                    String[] tasks = request.getParameterValues("taskId");
                    for (int i = 0; i < tasks.length; i++) {
                        if (!tasks[i].equalsIgnoreCase("---")) {
                            status = "fail";
                            break;
                        } else {
                            status = "ok";
                        }
                    }

                    if (!status.equalsIgnoreCase("ok")) {
                        if (lbMgr.newob(request, isId)) {
                            status = "ok";
                        }
                    }

                    //get issue_complaints
                    compTasksVec = compTasksMgr.getOnArbitraryKey(isId, "key");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("status", status);
                request.setAttribute("maintTitle", maintTitle);
                request.setAttribute("jobNo", jobNo);
                request.setAttribute("issueId", isId);
                request.setAttribute("comp", compTasksVec);
                servedPage = "/docs/issue/combine_comp.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 29:
                String updateId = (String) request.getParameter("updateId");

                if (updateId != null && !updateId.equals("")) {
                    QuantifiedMntenceMgr QuantMgr = QuantifiedMntenceMgr.getInstance();
                    String[] idList = updateId.split("-");
                    ConfigAlterTasksPartsMgr configAlterTasksPartsMgr = ConfigAlterTasksPartsMgr.getInstance();
                    WebBusinessObject taskByItemWbo = (WebBusinessObject) configAlterTasksPartsMgr.getOnSingleKey(idList[0]);
                    QuantMgr.updateAlterPart(taskByItemWbo, idList[1]);

                }
                itemListTemp = new Vector();
                projectname = request.getParameter("projectName");
                ais = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                transStoreItemMgr = TransStoreItemMgr.getInstance();
                issueId = request.getParameter(IssueConstants.ISSUEID);

                myIssue = issueMgr.getOnSingleKey(issueId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                attachedEqFlag = (String) request.getParameter("attachedEqFlag");

                itemList = new Vector();
                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                ListItems = QuantifiedMntenceMgr.getInstance();
                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "0");
                web = usMgr.getOnSingleKey(uID);

                scheduleId = web.getAttribute("periodicId").toString();
                if (scheduleId.equalsIgnoreCase("1") || scheduleId.equalsIgnoreCase("2")) {
                    itemList = ListItems.getSpecialItemSchedule(uSID, "0");
                } else {
                    if (itemListTemp.isEmpty()) {
                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                        itemList = itemsList.getConfigItemBySchedule(scheduleId);
                    } else {
                        itemList = itemListTemp;
                    }
                }

                for (int i = 0; i < itemList.size(); i++) {
                    WebBusinessObject itemListWbo = (WebBusinessObject) itemList.get(i);
                    String[] keys = {"key1", "key2", "key3"};
                    String[] values = {"91", issueId, itemListWbo.getAttribute("itemId").toString()};
                    try {
                        Vector result = transStoreItemMgr.getOnArbitraryNumberKey(3, values, keys);
                        if (result.size() > 0) {
                            itemListWbo.setAttribute("canDelete", false);
                        } else {
                            itemListWbo.setAttribute("canDelete", true);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                // get all Store From Erp as ex.
                Tools.setRequestByStoreInfo(request);

                servedPage = "/docs/issue/schedule_config_parts.jsp";
                request.setAttribute("data", itemList);
                request.setAttribute("attachedEqFlag", attachedEqFlag);
                request.setAttribute("uID", uID);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                request.setAttribute(IssueConstants.STATE, ais);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            default:
                this.forwardToServedPage(request, response);

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

    @Override
    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("assign")) {
            return 1;
        }
        if (opName.equalsIgnoreCase(OperationConstants.SAVE)) {
            return 2;
        }
        if (opName.equalsIgnoreCase(OperationConstants.LISTASSIGNED)) {
            return 3;
        }
        if (opName.equalsIgnoreCase(OperationConstants.STARTWORKING)) {
            return 4;
        }
        if (opName.equalsIgnoreCase(OperationConstants.VIEWDETAILS)) {
            return 5;
        }
        if (opName.equalsIgnoreCase("reassign")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("saveReassign")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("editJobOrder")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("excel")) {
            return 9;
        }
        if (opName.equalsIgnoreCase("configParts")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("saveconfigParts")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("ViewPopUpDetails")) {
            return 12;
        }
        if (opName.equals("AddLabourCompalint")) {
            return 13;
        }
        if (opName.equals("addcomp")) {
            return 14;
        }
        if (opName.equals("composeCmpl")) {
            return 15;
        }
        if (opName.equals("internalAssign")) {
            return 16;
        }
        if (opName.equals("addLocalSpareParts")) {
            return 17;
        }
        if (opName.equals("viewDetailsCmplx")) {
            return 18;
        }
        if (opName.equals("deleteTask")) {
            return 19;
        }
        if (opName.equals("updateJobOrder")) {
            return 20;
        }
        if (opName.equals("updateEdittingJobOrder")) {
            return 21;
        }
        if (opName.equalsIgnoreCase("confirmDelete")) {
            return 22;
        }
        if (opName.equalsIgnoreCase("deleteJobOrder")) {
            return 23;
        }
        if (opName.equalsIgnoreCase("viewReconfigTasks")) {
            return 24;
        }
        if (opName.equalsIgnoreCase("configUsedParts")) {
            return 25;
        }
        if (opName.equalsIgnoreCase("saveUsedParts")) {
            return 26;
        }
        if (opName.equalsIgnoreCase("listCostCenters")) {
            return 27;
        }
        if (opName.equalsIgnoreCase("combinComp")) {
            return 28;
        }
        if (opName.equalsIgnoreCase("updateAlterParts")) {
            return 29;
        }
        return 0;
    }

    private void scrapeForm(HttpServletRequest request) {
        userId = (String) request.getParameter(IssueConstants.ASSIGNEDTO);
        webIssue.setIssueID((String) request.getParameter("issueId"));
        webIssue.setAssignedToID((String) request.getParameter(IssueConstants.ASSIGNEDTO));
        webIssue.setAssignedToName(userMgr.getUserByID(userId));
        webIssue.setFinishedTime("0");
        webIssue.setIssueTitle((String) request.getParameter(IssueConstants.ISSUETITLE));
        webIssue.setManagerNote((String) request.getParameter("assignNote"));
    }
}
