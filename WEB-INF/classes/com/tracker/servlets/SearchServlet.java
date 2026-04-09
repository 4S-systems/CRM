/*
 * SearchServlet.java
 *
 * Created on March 3, 2004, 8:28 AM
 */
package com.tracker.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientComplaintsSLAMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.contractor.db_access.MaintainableMgr;
import com.crm.common.CRMConstants;
import com.crm.common.PDFTools;
import com.crm.servlets.CommentsServlet;
import com.docviewer.db_access.ImageMgr;
import com.financials.db_access.ExpenseItemMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.common.UserGroupConfigMgr;
import com.maintenance.db_access.ActualItemMgr;
import com.maintenance.db_access.ComplexIssueMgr;
import com.maintenance.db_access.ConfigureMainTypeMgr;
import com.maintenance.db_access.EmpTasksHoursMgr;
import com.maintenance.db_access.EmployeeView2Mgr;
import com.maintenance.db_access.EmployeeViewMgr;
import com.maintenance.db_access.FailureIssueMachineMgr;
import com.maintenance.db_access.IssueByComplaintAllCaseMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.IssueByComplaintUniqueMgr;
import com.maintenance.db_access.IssueEquipmentMgr;
import com.maintenance.db_access.LocalStoresItemsMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.MainReportMgr;
import com.maintenance.db_access.MaintenanceItemMgr;
import com.maintenance.db_access.PlannedTasksMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ResponsibiltyCompViewMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.SchedulesOnEquipmentByItemMgr;
import com.maintenance.db_access.SupplementMgr;
import com.maintenance.db_access.TaskMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.maintenance.db_access.UnitMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.maintenance.db_access.UnitStatusMgr;
import com.maintenance.db_access.UserCompanyProjectsMgr;
import com.maintenance.db_access.UserDistrictsMgr;
import com.planning.db_access.PlanMgr;
import com.planning.db_access.SeasonMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.tracker.business_objects.WebIssue;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.IssueMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.GroupMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.timeutil.*;
import com.silkworm.util.DateAndTimeControl;

import java.util.*;
import com.tracker.common.*;
import com.tracker.db_access.LocationTypeMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.RequestItemsDetailsMgr;
import com.unit.db_access.UnitTypeMgr;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONValue;

/**
 *
 * @author walid
 * @version
 */
public class SearchServlet extends TrackerBaseServlet {
    String op = null;
    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
    String filterName = null;
    WebIssue wIssue = new WebIssue();
    String filterValue = null;
    Vector issueList = new Vector();
    WebBusinessObject userObj = null;
    UnitMgr unitMgr = UnitMgr.getInstance();
    PlanMgr planMgr = PlanMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    int totalReading = 0;
    String scheduleRateId;
    Vector lastSchedules = new Vector();
    Vector projects = new Vector();
    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    SchedulesOnEquipmentByItemMgr schedulesOnEquipmentByItemMgr = SchedulesOnEquipmentByItemMgr.getInstance();

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(SearchServlet.class);

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
        ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
        ClientMgr clientMgr = ClientMgr.getInstance();
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ClientComplaintsSLAMgr clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();

        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        switch (operation) {
            case 1:
                Vector issueList = null;
                issueList = issueMgr.getAllIssues();

                servedPage = "/docs/issue/issue_listing.jsp";
                request.setAttribute("data", issueList);
                request.setAttribute("status", "All");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                op = request.getParameter("op");
                // --------------------
                servedPage = "/docs/Search/status_project.jsp";
                String context = op.substring(op.length() - 3);
                String nextTarget = "StatusProjectList" + context;
                request.setAttribute("op", nextTarget);
                request.setAttribute("ts", "SearchServlet");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            // ------------------------
            case 3:
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                String statusName = request.getParameter("statusName");
                String ts = request.getParameter("ts");
                HttpSession sess = request.getSession(true);
                sess.removeAttribute("case");
                sess.removeAttribute("unitName");
                sess.removeAttribute("title");
                sess.removeAttribute("EquipMentID");
                IssueEquipmentMgr issueEquipmentMgr = IssueEquipmentMgr.getInstance();

                String params = "&beginDate=" + request.getParameter("beginDate") + "&endDate=" + request.getParameter("endDate") + "&projectName=" + request.getParameter("projectName") + "&statusName=" + request.getParameter("statusName");

                loggedUser = (WebBusinessObject) sess.getAttribute("loggedUser");
                String jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                DateParser dateParser = new DateParser();
                if (null == filterValue) {
                    try {
                        filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("projectName") + "<" + request.getParameter("statusName");
                    } catch (Exception E) {
                        filterValue = request.getParameter("fromJob") + ":" + request.getParameter("toJob") + ">" + request.getParameter("statusName") + "<";
                        params = "&fromJob=" + request.getParameter("fromJob") + "&toJob=" + request.getParameter("toJob") + "&statusName=" + request.getParameter("statusName");
                    }
                    //filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("projectName")+ "<" +request.getParameter("statusName");
                }
                
                String equipmentID = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
                maintainableMgr = MaintainableMgr.getInstance();
                WebBusinessObject eqWbo = maintainableMgr.getOnSingleKey(equipmentID);
                try {
                    servedPage = "/docs/issue/issue_listing.jsp";
                    // servedPage = "/docs/issue/issue_report.jsp";
                    issueEquipmentMgr.setUser((WebBusinessObject) request.getSession().getAttribute("loggedUser"));
                    if (equipmentID.equalsIgnoreCase("ALL")) {
                        issueList = issueEquipmentMgr.getALLIssuesByTrade(request, request.getParameter("op"), filterValue, session);
                    } else if (equipmentID.equalsIgnoreCase("FromTo")) {
                        issueList = issueEquipmentMgr.getAllIssuesFromToJobOrder(request.getParameter("op"), filterValue, session);
                    } else {
                        issueList = issueEquipmentMgr.getIssuesInRangeByTrade(request.getParameter("op"), filterValue, session);
                    }

                    ComplexIssueMgr complexIssueMgr = ComplexIssueMgr.getInstance();
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
                        } catch (Exception e) {}
                        
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

//                    request.setAttribute("filterName", "All");
                    request.setAttribute("filterName", "StatusProjectListAll");

                    request.setAttribute("filterValue", filterValue);
//                    request.setAttribute("data", issueList);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
//                    request.setAttribute("fullUrl", url);
//                    request.setAttribute("url", url);
                    request.setAttribute("data", subIssueList);
                    request.setAttribute("ts", ts);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", statusName);
                    request.setAttribute("eqWbo", eqWbo);
                    request.setAttribute("ViewBack", "false");
                    this.forwardToServedPage(request, response);
                    break;
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }
                break;

            case 4:
                op = request.getParameter("op");
                // --------------------
                servedPage = "/docs/Search/workers.jsp";
                context = op.substring(op.length() - 3);
                nextTarget = "ListResult" + context;
                request.setAttribute("op", nextTarget);
                request.setAttribute("ts", "SearchServlet");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                String userId = null;
                String projectname = request.getParameter("projectName");
                if (!request.getParameter("filterValue").equalsIgnoreCase("")) {
                    userId = request.getParameter("filterValue");
                } else {
                    userId = request.getParameter("workerID");
                }

                //ts = request.getParameter("ts");
                if (null == userId) {
                    servedPage = "/docs/search/workers.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "");
                }

                try {
                    servedPage = "/docs/issue/worker_issue_list.jsp";
                    issueList = issueMgr.getProjectByWorker(userId, projectname, "key2");

                    request.setAttribute("data", issueList);
                    request.setAttribute("projectName", projectname);

                    //request.setAttribute("ts", ts);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;
                } //                catch(SQLException sqlEx) {
                //                }
                catch (Exception e) {
                    logger.error(e.getMessage());
                }
                break;

            case 6:
                WebBusinessObject issueStatus = null;
                String beginDate = null;
                String endDate = null;
                String issueId = request.getParameter("issueId");
                Vector issueStatusiList = issueStatusMgr.getAllIssueStatus(issueId);
                Vector issueDetail = new Vector();
                Vector forShipping = new Vector();
                long lTemp;
                long lHours;
                String sTemp = null;
                DateServices dsDate = new DateServices();
                WebBusinessObject wbo = issueMgr.getOnSingleKey(issueId);
                issueDetail.addElement(wbo);
                Enumeration stEnum = issueStatusiList.elements();
                projectname = request.getParameter("projectName");
                while (stEnum.hasMoreElements()) {
                    issueStatus = (WebBusinessObject) stEnum.nextElement();
                    String status = (String) issueStatus.getAttribute("statusName");
                    lHours = 0;
                    if (!status.equalsIgnoreCase("Finished")) {
                        beginDate = (String) issueStatus.getAttribute("beginDate");
                        endDate = (String) issueStatus.getAttribute("endDate");

                        lTemp = dsDate.convertMySQLDateToLong(endDate) - dsDate.convertMySQLDateToLong(beginDate);
                        lTemp = lTemp / (1000);
                        lHours = lTemp / (60 * 60);
                        if ((lTemp - (lHours * 60 * 60)) > 0) {
                            lHours++;
                        }
                    }

                    issueStatus.setAttribute("lapsedTime", sTemp.valueOf(lHours));
                    forShipping.add(issueStatus);
                }
                
                issueStatusiList = null;
                servedPage = "/docs/reports/status_report.jsp";
                request.setAttribute("data", forShipping);
                request.setAttribute("detail", issueDetail);
                request.setAttribute("projectName", projectname);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                String sType = null;
                sType = (String) request.getParameter("type");
                String inframe = request.getParameter("inframe");

                servedPage = "/docs/reports/projects.jsp";
                if (sType.equalsIgnoreCase("Statistics")) {
                    nextTarget = "ProjectStcs";
                    request.setAttribute("chart", request.getParameter("chart"));

                    request.setAttribute("op", nextTarget);
                } else if (sType.equalsIgnoreCase("Status")) {
                    nextTarget = "StatusReport";
                    request.setAttribute("op", nextTarget);
                } else if (sType.equalsIgnoreCase("risk")) {
                    nextTarget = "RiskReport";
                    request.setAttribute("op", nextTarget);
                }
                
                request.setAttribute("ts", "SearchServlet");
                request.setAttribute("page", servedPage);
                if (inframe == null) {
                    this.forwardToServedPage(request, response);
                } else if (inframe.equalsIgnoreCase("yes")) {
                    request.setAttribute("inframe", "yes");
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 8:
                servedPage = "/docs/reports/projects_statistics.jsp";
                inframe = request.getParameter("inframe");
                IssueMgr issueMgr = IssueMgr.getInstance();
                Vector project = new Vector();
                project = issueMgr.getStatisticsForProject(request.getParameter("projectName"));
                request.setAttribute("chart", request.getParameter("chart"));
                request.setAttribute("data", project);
                request.setAttribute("page", servedPage);
                if (request.getAttribute("chart").toString().equalsIgnoreCase("pie")) {
                    if (!project.isEmpty()) {
                        String jsonText = null;
                        List dataList = new ArrayList();
                        Map dataEntryMap = new HashMap();
                        WebBusinessObject projectWbo = null;
                        Double iTemp = 0.0;
                        int iTotal = 0;

                        // compute total
                        for (int i = 0; i < project.size(); i++) {
                            projectWbo = (WebBusinessObject) project.get(i);

                            iTemp = new Double((String) projectWbo.getAttribute("total"));
                            iTotal = iTotal + iTemp.intValue();
                        }

                        // populate series data map
                        for (int i = 0; i < project.size(); i++) {
                            dataEntryMap = new HashMap();
                            projectWbo = (WebBusinessObject) project.get(i);

                            iTemp = new Double((String) projectWbo.getAttribute("total"));

                            dataEntryMap.put("name", projectWbo.getAttribute("currentStatus"));
                            dataEntryMap.put("y", Math.round((iTemp.doubleValue() / iTotal) * 100));

                            dataList.add(dataEntryMap);
                        }

                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(dataList);

                        request.setAttribute("jsonText", jsonText);
                    }
                }

                if (inframe == null) {
                    this.forwardToServedPage(request, response);
                } else if (inframe.equalsIgnoreCase("yes")) {
                    request.setAttribute("inframe", "yes");
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;

            case 9:
                filterValue = request.getParameter("filterValue");
                if (null == filterValue || filterValue.equalsIgnoreCase("")) {
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ":" + new Long(dropdownDate.getDate(request.getParameter("endDate")).getTime()).toString() + ">" + request.getParameter("projectName");

                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                    dateParser = new DateParser();
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("projectName");
                    //filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("projectName");
                }
                
                servedPage = "/docs/reports/projects_status.jsp";
                Vector fValue = new Vector();
                fValue.add(0, filterValue);
                issueMgr = IssueMgr.getInstance();
                project = new Vector();
                project = issueMgr.getStatusForProject(filterValue);
                request.setAttribute("filterValue", fValue);
                request.setAttribute("projectName", filterValue);
                request.setAttribute("data", project);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 10:
                servedPage = "/docs/Search/search_title.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 11:
                servedPage = "/docs/Search/search_issue_list.jsp";
                String searchBy = null;
                if (!request.getParameter("filterValue").equalsIgnoreCase("")) {
                    searchBy = request.getParameter("filterValue");
                } else {
                    searchBy = request.getParameter("searchTitle");
                }

                issueMgr = IssueMgr.getInstance();
                if (null == searchBy || searchBy.equalsIgnoreCase("")) {
                    servedPage = "/docs/Search/search_title.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "");
                } else {
                    try {
                        issueList = issueMgr.getSearchByTitle(searchBy, session);

                        request.setAttribute("data", issueList);
                        request.setAttribute("page", servedPage);
                    } catch (Exception e) {
                        logger.error(e.getMessage());
                    }
                }
                
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                servedPage = "/docs/Search/search_note.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 13:
                servedPage = "/docs/Search/search_issue_note.jsp";
                searchBy = null;
                if (!request.getParameter("filterValue").equalsIgnoreCase("")) {
                    searchBy = request.getParameter("filterValue");
                } else {
                    searchBy = request.getParameter("searchTitle");
                }

                issueMgr = IssueMgr.getInstance();
                if (null == searchBy || searchBy.equalsIgnoreCase("")) {
                    servedPage = "/docs/Search/search_note.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "");
                } else {
                    try {
                        issueList = issueMgr.getSearchByNote(searchBy, session);

                        request.setAttribute("data", issueList);
                        request.setAttribute("page", servedPage);
                    } catch (Exception e) {
                        logger.error(e.getMessage());
                    }
                }
                
                this.forwardToServedPage(request, response);
                break;

            case 14:
//                String sType = null;
                sType = (String) request.getParameter("type");
                servedPage = "/docs/reports/projectsByWorker.jsp";
                if (sType.equalsIgnoreCase("ProjectByWorker")) {
                    nextTarget = "WorkerStatus";
                    request.setAttribute("op", nextTarget);
                }
                
                request.setAttribute("ts", "SearchServlet");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 15:
                filterValue = request.getParameter("filterValue");
                if (null == filterValue || filterValue.equalsIgnoreCase("")) {
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ":" + new Long(dropdownDate.getDate(request.getParameter("endDate")).getTime()).toString() + ">" + request.getParameter("projectName");
                    //filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("projectName");
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                    dateParser = new DateParser();
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("projectName");
                }
                
                String WorkerID = request.getParameter("workerID");

                servedPage = "/docs/reports/projects_worker_status.jsp";
                Vector newfValue = new Vector();
                newfValue.add(0, filterValue);
                issueMgr = IssueMgr.getInstance();
                project = new Vector();
                project = issueMgr.getStatusForProjectWorker(WorkerID, filterValue);

                request.setAttribute("WorkerID", WorkerID);

                request.setAttribute("filterValue", newfValue);
                request.setAttribute("projectName", filterValue);
                request.setAttribute("data", project);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 16:
                sType = (String) request.getParameter("type");
                servedPage = "/docs/reports/projectsHours.jsp";
                if (sType.equalsIgnoreCase("ProjectHours")) {
                    nextTarget = "WorkerProHours";
                    request.setAttribute("op", nextTarget);
                }
                
                request.setAttribute("ts", "SearchServlet");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 17:
                filterValue = request.getParameter("filterValue");
                if (null == filterValue || filterValue.equalsIgnoreCase("")) {
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ":" + new Long(dropdownDate.getDate(request.getParameter("endDate")).getTime()).toString() + ">" + request.getParameter("projectName");
                    //filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("projectName");
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                    dateParser = new DateParser();
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("projectName");
                }

                servedPage = "/docs/reports/projects_Total_Hours.jsp";

//                servedPage = "/docs/reports/projects_statistics.jsp";
                issueMgr = IssueMgr.getInstance();
                Vector newproject = new Vector();
                newproject = issueMgr.getHoursForProject(request.getParameter("projectName"), request);
                request.setAttribute("chart", request.getParameter("chart"));

                request.setAttribute("data", newproject);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 18:
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                String projectName = request.getParameter("projectName");
                ts = request.getParameter("ts");
                if (null == projectName) {
                    projectName = request.getParameter("filterValue");
                }

                try {
                    servedPage = "/docs/issue/issue_risk_list.jsp";
                    issueMgr = IssueMgr.getInstance();
                    issueList = issueMgr.getRiskForProject(projectName, filterValue);

//                    request.setAttribute("filterName", filterName);
//                    request.setAttribute("filterValue", filterValue);
                    request.setAttribute("filterValue", projectName);
                    request.setAttribute("projectName", projectName);
                    request.setAttribute("data", issueList);
                    request.setAttribute("ts", ts);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", "**");
                    this.forwardToServedPage(request, response);
                    break;
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }
                break;

            case 19:
//                ExcelCreator excelCreator = new ExcelCreator();
//                String[] header = {"Site Name", "Assign To", "Total"};
//                String[] attribute = {"projectName", "assignedToName", "total"};
//                String[] dataType = {"String", "String", "Number"};
//
//                issueMgr = IssueMgr.getInstance();
//                newproject = new Vector();
//                newproject = (Vector) request.getSession().getAttribute("data");
//
//                HSSFWorkbook workBook = excelCreator.createExcelFile(header, attribute, dataType, newproject, 2);
//
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\"" + request.getParameter("projectName") + "_Total_Hours.xls");
//                workBook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
//                break;
                
            case 20:
                op = request.getParameter("op");
                context = op.substring(op.length() - 3);
                nextTarget = "ListResult" + context;
                request.setAttribute("op", nextTarget);
                servedPage = "/docs/reports/projects_farea.jsp";
                request.setAttribute("ts", "SearchServlet");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 21:
                String funId = null;
                issueMgr = IssueMgr.getInstance();
                projectname = request.getParameter("projectName");
                funId = request.getParameter("maintenanceID");

                //ts = request.getParameter("ts");
                if (null == funId) {
                    servedPage = "/docs/search/workers.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "");
                }

                try {
                    servedPage = "/docs/issue/maintenance_issue_list.jsp";
                    issueList = issueMgr.getIssuePerProjectWithMaintenance(funId, projectname);

                    request.setAttribute("data", issueList);
                    request.setAttribute("projectName", projectname);
                    request.setAttribute("maintenanceName", funId);

                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }
                break;
                
            case 22:
//                WorkerID = request.getParameter("workerID");
//                project = new Vector();
//                project = (Vector) request.getSession().getAttribute("data");
//
//                excelCreator = new ExcelCreator();
//                String[] header2 = {"Schedule Title", "Maintenance", "Hours"};
//                String[] attribute2 = {"issueTitle", "faId", "actualFinishTime"};
//                String[] dataType2 = {"String", "String", "Number"};
//
//                workBook = excelCreator.createExcelFile(header2, attribute2, dataType2, project, 2);
//
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\"" + request.getParameter("projectName") + "_Worker_Hours.xls");
//                workBook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
                break;
                
            case 23:
//                project = new Vector();
//                project = (Vector) request.getSession().getAttribute("data");
//                int size = project.size() + 1;
//                for (int i = 0; i < project.size(); i++) {
//                    int j = i + 2;
//                    ((WebBusinessObject) project.get(i)).setAttribute("percent", "ROUND(B" + j + "/SUM(B2:B" + size + ") * 100,0)");
//                }
//
//                excelCreator = new ExcelCreator();
//                String[] header3 = {"Status", "Total", "Percent %"};
//                String[] attribute3 = {"currentStatus", "total", "percent"};
//                String[] dataType3 = {"String", "Number", "Formula"};
//
//                workBook = excelCreator.createExcelFile(header3, attribute3, dataType3, project, 0);
//
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\"" + request.getParameter("projectName") + "_Statistics.xls");
//                workBook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
                break;

            case 24:
//                project = new Vector();
//                project = (Vector) request.getSession().getAttribute("data");
//
//                excelCreator = new ExcelCreator();
//                String[] header4 = {"Schedule Title", "Expected Begain Date", "Expected End Date", "State"};
//                String[] attribute4 = {"issueTitle", "expectedBeginDate", "expectedEndDate", "currentStatus"};
//                String[] dataType4 = {"String", "String", "String", "String"};
//
//                workBook = excelCreator.createExcelFile(header4, attribute4, dataType4, project, 0);
//
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\"" + request.getParameter("projectName") + "_Status.xls");
//                workBook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
                break;
                
            case 25:
//                project = new Vector();
//                project = (Vector) request.getSession().getAttribute("data");
//
//                excelCreator = new ExcelCreator();
//                String[] header5 = {"Schedule Title", "Begain Date", "End Date", "Assigned To"};
//                String[] attribute5 = {"issueTitle", "expectedBeginDate", "expectedEndDate", "assignedToName"};
//                String[] dataType5 = {"String", "String", "String", "String"};
//
//                workBook = excelCreator.createExcelFile(header5, attribute5, dataType5, project, 0);
//
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\"" + request.getParameter("projectName") + "_Maintenance_" + request.getParameter("maintenanceName") + ".xls");
//                workBook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
                break;

            case 26:
                servedPage = "/docs/issue/search_job.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 27:
                servedPage = "/docs/Search/job_order_report.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 28:
                servedPage = "/docs/Search/job_order_result.jsp";
                issueMgr = IssueMgr.getInstance();
                issueMgr.executeMainReport(request);
                MainReportMgr mainReportMgr = MainReportMgr.getInstance();
                mainReportMgr.cashData();
                Vector vecResult = mainReportMgr.getCashedTable();
                request.setAttribute("page", servedPage);
                request.setAttribute("vecResult", vecResult);
                this.forwardToServedPage(request, response);
                break;

            case 29:
                servedPage = "/docs/Search/job_order_report_by_Equip.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 30:
                servedPage = "/docs/Search/job_order_result_by_Equip.jsp";
                String unitName = request.getParameter("unitName");
                issueMgr = IssueMgr.getInstance();
                issueMgr.executeMainReportByEquip(request);
                mainReportMgr = MainReportMgr.getInstance();
                mainReportMgr.cashData();
                vecResult = mainReportMgr.getCashedTable();
                request.setAttribute("unitName", unitName);
                request.setAttribute("page", servedPage);
                request.setAttribute("vecResult", vecResult);
                this.forwardToServedPage(request, response);
                break;

            case 31:
                servedPage = "/docs/Search/job_order_report_by_month.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 32:
                servedPage = "/docs/Search/job_order_result_by_month.jsp";
                issueMgr = IssueMgr.getInstance();
                issueMgr.executeMainReportByMonth(request);
                mainReportMgr = MainReportMgr.getInstance();
                mainReportMgr.cashData();
                vecResult = mainReportMgr.getCashedTable();
                request.setAttribute("page", servedPage);
                request.setAttribute("vecResult", vecResult);
                this.forwardToServedPage(request, response);
                break;

            case 33:
                servedPage = "/docs/Search/ratio_success.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 34:
                servedPage = "/docs/Search/ratio_success_result.jsp";
                issueMgr = IssueMgr.getInstance();
                issueMgr.executeRatioSuccess(request);
                mainReportMgr = MainReportMgr.getInstance();
                mainReportMgr.cashData();
                vecResult = mainReportMgr.getCashedTable();
                request.setAttribute("page", servedPage);
                request.setAttribute("vecResult", vecResult);
                this.forwardToServedPage(request, response);
                break;

            case 35:
                servedPage = "/docs/Search/job_order_report_by_Equip_by_month.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 36:
                servedPage = "/docs/Search/job_order_result_by_Equip_by_month.jsp";
                unitName = request.getParameter("unitName");
                issueMgr = IssueMgr.getInstance();
                issueMgr.executeMainReportByEquipByMonth(request);
                mainReportMgr = MainReportMgr.getInstance();
                mainReportMgr.cashData();
                vecResult = mainReportMgr.getCashedTable();
                request.setAttribute("unitName", unitName);
                request.setAttribute("page", servedPage);
                request.setAttribute("vecResult", vecResult);
                this.forwardToServedPage(request, response);
                break;

            case 37:
                servedPage = "/docs/Search/faliure_code_report.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 38:
                servedPage = "/docs/Search/faliure_code_report_result.jsp";
                issueMgr = IssueMgr.getInstance();
                Vector failureCodeVectors = new Vector();
                failureCodeVectors = issueMgr.getStatisticsForFailureCode(request);
                request.setAttribute("failureCodeVectors", failureCodeVectors);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 39:
                sess = request.getSession(true);
                sess.removeAttribute("case");
                sess.removeAttribute("unitName");
                sess.removeAttribute("title");

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                statusName = request.getParameter("statusName");
                String unit_Name = request.getParameter("unitName");
                String title = request.getParameter("title");
                ts = request.getParameter("ts");
                issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                if (null == filterValue) {
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ":" + new Long(dropdownDate.getDate(request.getParameter("endDate")).getTime()).toString() + ">" + request.getParameter("projectName") + "<" + request.getParameter("statusName");
                    //filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("projectName")+ "<" +request.getParameter("statusName");

                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                    dateParser = new DateParser();
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("projectName") + "<" + request.getParameter("statusName");
                }
                
                equipmentID = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
                maintainableMgr = MaintainableMgr.getInstance();
                try {
                    servedPage = "/docs/issue/issue_listing.jsp";
                    // servedPage = "/docs/issue/issue_report.jsp";
                    issueEquipmentMgr.setUser((WebBusinessObject) request.getSession().getAttribute("loggedUser"));
                    issueList = issueEquipmentMgr.getIssuesInRangeByTitle(request.getParameter("op"), filterValue, title);

                    request.setAttribute("filterName", "All");
                    request.setAttribute("filterValue", filterValue);
                    request.setAttribute("data", issueList);
                    request.setAttribute("ts", ts);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", statusName);
                    request.setAttribute("UnitName", unit_Name);
                    request.setAttribute("Title", title);
                    this.forwardToServedPage(request, response);
                    break;
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }
                break;

            case 40:
                servedPage = "/docs/Search/search_by_shift.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 41:
                servedPage = "/docs/Search/search_issue_byShift.jsp";
                String shiftByGroup = null;

                searchBy = null;
                if (!request.getParameter("filterValue").equalsIgnoreCase("")) {
                    searchBy = request.getParameter("filterValue");
                } else {
                    searchBy = request.getParameter("searchByShift");
                }

                issueMgr = IssueMgr.getInstance();
                try {
                    issueList = issueMgr.getSearchByShift(searchBy, session);

                    request.setAttribute("data", issueList);
                    request.setAttribute("shiftByGroup", shiftByGroup);
                    request.setAttribute("page", servedPage);
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }

                this.forwardToServedPage(request, response);
                break;

            case 42:
                servedPage = "/docs/Search/search_by_department.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 43:
                servedPage = "/docs/Search/search_issue_byDepartment.jsp";

                beginDate = (String) request.getParameter("beginDate");
                endDate = (String) request.getParameter("endDate");
                if (beginDate != null && !beginDate.equals("")) {
                    session.setAttribute("beginDatesql", beginDate);
                    session.setAttribute("endDatesql", endDate);
                } else {
                    beginDate = (String) session.getAttribute("beginDatesql");
                    endDate = (String) session.getAttribute("endDatesql");
                }
                
                searchBy = null;
                if (!request.getParameter("filterValue").equalsIgnoreCase("")) {
                    searchBy = request.getParameter("filterValue");
                } else {
                    searchBy = request.getParameter("receivedby");
                }

                issueMgr = IssueMgr.getInstance();
                try {
                    issueList = issueMgr.getSearchByDepartment(searchBy, session, beginDate, endDate);

                    request.setAttribute("data", issueList);

                    request.setAttribute("page", servedPage);
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }

                this.forwardToServedPage(request, response);
                break;

            case 44:
                servedPage = "/docs/Search/search_joborder.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 45:
                String issueID = request.getParameter("issueID");
                issueMgr = IssueMgr.getInstance();
                if (issueID != null) {
                    Vector vecIssues = new Vector();
                    try {
                        vecIssues = issueMgr.getOnArbitraryKey(issueID, "key4");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    if (vecIssues.size() > 0) {
                        wbo = (WebBusinessObject) vecIssues.get(0);
                        String FinishTime = (String) wbo.getAttribute("finishedTime");
                        if (FinishTime.equals("0")) {
                            FinishTime = "Has not been specified ";
                        }
                        
                        wbo.setAttribute("finishTime", FinishTime);
                        String createdBy = (String) wbo.getAttribute("userId");
                        wbo.setAttribute("createdByName", userMgr.getOnSingleKey(createdBy).getAttribute("userName"));
                        String AssignByName = (String) wbo.getAttribute("assignedByName");
                        wbo.setAttribute("assignedBy", AssignByName);
                        String scheduleType = (String) wbo.getAttribute("scheduleType");
                        wbo.setAttribute("scheduleType", scheduleType);
                        String businessIDbyDate = (String) wbo.getAttribute("businessIDbyDate");
                        wbo.setAttribute("businessIDbyDate", businessIDbyDate);
                        String actualBDate = (String) wbo.getAttribute("actualBeginDate");
                        if (actualBDate == null || actualBDate.equalsIgnoreCase("")) {
                            wbo.setAttribute("actualBeginDate", "notstarted");
                        } else {
                            wbo.setAttribute("actualBeginDate", actualBDate);
                        }
                        
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
                        TradeMgr tradeMgr = TradeMgr.getInstance();
                        String workTrade = (String) (tradeMgr.getOnSingleKey((String) wbo.getAttribute("workTrade"))).getAttribute("tradeName");
                        wbo.setAttribute("workTrade", workTrade);
                        //
                        issueId = wbo.getAttribute("id").toString();
                        String siteTime = issueMgr.getsitDate(wbo.getAttribute("id").toString());

                        String actualBeginDate = issueMgr.getActualBeginDate(wbo.getAttribute("id").toString());
                        wbo.setAttribute("siteEntryTime", siteTime);
                        String scheduleUnitID = (String) wbo.getAttribute("unitScheduleID");
                        QuantifiedMntenceMgr quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                        ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
                        Vector actualItems = new Vector();
                        try {
                            actualItems = actualItemMgr.getOnArbitraryKey(scheduleUnitID, "key1");
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
                        for (int i = 0; i < actualItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) actualItems.get(i);
                            String itemID = (String) temp.getAttribute("itemId");
                            WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
                            temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                            temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                        }
                        
                        Vector quantifiedItems = new Vector();
                        try {
                            quantifiedItems = quantifiedMgr.getOnArbitraryKey(scheduleUnitID, "key1");
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
                        LocalStoresItemsMgr localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                        for (int i = 0; i < quantifiedItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) quantifiedItems.get(i);
                            String itemID = (String) temp.getAttribute("itemId");
                            String is_Direct = (String) temp.getAttribute("isDirectPrch");
                            if (is_Direct.equals("0")) {
                                WebBusinessObject item = new WebBusinessObject();

                                item = maintenanceItemMgr.getOnSingleKey(itemID);
                                try {
                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                } catch (Exception e) {
                                    logger.error("Can't find store item : " + itemID + " ,For JO # " + issueID);
                                }
                            } else {
                                Vector loaclitems = new Vector();
                                try {
                                    loaclitems = localStoresItemsMgr.getOnArbitraryKey(itemID, "key1");
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                }
                                
                                for (int x = 0; x < loaclitems.size(); x++) {
                                    WebBusinessObject item = new WebBusinessObject();
                                    item = (WebBusinessObject) loaclitems.get(x);
                                    temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    temp.setAttribute("itemDscrptn", item.getAttribute("itemName"));
                                }
                            }
                        }

                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
                        ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                        Vector configureItems = new Vector();
                        try {
                            configureItems = configureMainTypeMgr.getOnArbitraryKey(((String) unitScheduleWbo.getAttribute("periodicId")), "key1");
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
                        for (int i = 0; i < configureItems.size(); i++) {
                            WebBusinessObject temp = (WebBusinessObject) configureItems.get(i);
                            String itemID = (String) temp.getAttribute("itemId");
                            WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
                            temp.setAttribute("itemCode", item.getAttribute("itemCode"));
                            temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                        }
                        
                        request.setAttribute("actualBeginDate", actualBeginDate);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("actualItems", actualItems);
                        request.setAttribute("quantifiedItems", quantifiedItems);
                        request.setAttribute("configureItems", configureItems);
                        //
                        PlannedTasksMgr plannedTasksMgr = PlannedTasksMgr.getInstance();
                        Vector vecPlannedTasks = plannedTasksMgr.getPlannedTasksByIssue((String) wbo.getAttribute("id"));
                        EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                        Vector vecTasksHours = empTasksHoursMgr.getTasksHoursByIssue((String) wbo.getAttribute("id"));

                        issueMgr = IssueMgr.getInstance();
                        request.setAttribute("vecPlannedTasks", vecPlannedTasks);
                        request.setAttribute("vecTasksHours", vecTasksHours);
                        //
                        ImageMgr imageMgr = ImageMgr.getInstance();
                        Vector docsList = imageMgr.getListOnLIKE("ListDoc", (String) wbo.getAttribute("id"));
                        request.setAttribute("data", docsList);
                        //
                        maintainableMgr = MaintainableMgr.getInstance();
                        WebBusinessObject webIssue = issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(webIssue.getAttribute("unitId").toString());
                        request.getSession().setAttribute("IssueWbo", webIssue);
                        request.getSession().setAttribute("equipmentWbo", wboTemp);
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
                        } catch (Exception e) {}

                        // Get Eq_ID from Unit Schedule to check if this Eq is attached or not
                /* check if the equipment id has record(s) in attach_eqps table and
                         the separation_date equl null. this mean this eq is attached.*/
                        Vector attachedEqps = new Vector();
                        Vector minorAttachedEqps = new Vector();
                        SupplementMgr supplementMgr = SupplementMgr.getInstance();
                        String Eq_ID = (String) webIssue.getAttribute("unitId");
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

                        servedPage = "/docs/Search/search_job_result.jsp";
                        request.setAttribute("equipmentID", webIssue.getAttribute("unitId").toString());
                        WebBusinessObject unitWbo = maintainableMgr.getOnSingleKey(webIssue.getAttribute("unitId").toString());
                        request.setAttribute("unitWbo", unitWbo);
                        request.setAttribute("wbo", wbo);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    } else {
                        servedPage = "/docs/Search/search_joborder.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("message", "No Job Order with this ID was found");
                        this.forwardToServedPage(request, response);
                    }
                } else {
                    servedPage = "/docs/Search/search_joborder.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "No Job Order with this ID was found");
                    this.forwardToServedPage(request, response);
                }
                break;

            case 46:
                servedPage = "/docs/Search/status_failure_machine.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 47:
                String parentId = null;
                String scheduleType = "schedule";
                servedPage = "/docs/equipment/Failure_Unit_List.jsp";
                FailureIssueMachineMgr failureIssueMachineMgr = FailureIssueMachineMgr.getInstance();
                Vector failureUnit = new Vector();
                failureUnit = failureIssueMachineMgr.getFailureUnit(request);
                parentId = request.getParameter("unitName").toString();
                request.setAttribute("parentId", parentId);
                request.setAttribute("scheduleType", scheduleType);
                request.setAttribute("data", failureUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 48:
                parentId = null;
                scheduleType = "Emergency";
                servedPage = "/docs/equipment/Failure_Unit_List.jsp";
                failureIssueMachineMgr = FailureIssueMachineMgr.getInstance();
                failureUnit = new Vector();
                failureUnit = failureIssueMachineMgr.getEMGFailureUnit(request);
                parentId = request.getParameter("unitName").toString();
                request.setAttribute("parentId", parentId);
                request.setAttribute("scheduleType", scheduleType);
                request.setAttribute("data", failureUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 49:
                StringBuffer returnxml = new StringBuffer();
                String ttemp;
                StringBuffer EqCode = new StringBuffer();
                String projectId = loggedUser.getAttribute("projectID").toString();
                try {
                    unitMgr.cashData();
                    Vector arrMachineItems = new Vector();
                    WebBusinessObject userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

                    if (userWbo.getAttribute("userType").toString().equalsIgnoreCase("single")) {
                        arrMachineItems = unitMgr.getEquipment();
                    } else {
                        arrMachineItems = unitMgr.getEquipment(projectId);
                    }
                    
                    int i = 0;
                    for (; i < arrMachineItems.size(); i++) {
                        wbo = (WebBusinessObject) arrMachineItems.get(i);

                        ttemp = wbo.getAttribute("id").toString() + "!=";
                        //  names.append(wbo.getAttribute("unitName").toString()+"!=");
                        EqCode.append(wbo.getAttribute("id").toString() + "!=");
                        returnxml.append(wbo.getAttribute("unitName").toString() + "!=");
                        
                        //if(wbo.getAttribute())
                    }
                    
                    EqCode.deleteCharAt(EqCode.length() - 1);
                    EqCode.deleteCharAt(EqCode.length() - 1);
                    returnxml.deleteCharAt(returnxml.length() - 1);
                    returnxml.deleteCharAt(returnxml.length() - 1);
                    returnxml.append("&#");
                    returnxml.append(EqCode);
                } catch (Exception ex) {
                    System.out.println("Get Machine task Exception " + ex.getMessage());
                }
                
                response.setContentType("text/xml;charset=UTF-8");
                System.err.println(returnxml.toString());
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(returnxml.toString());
                break;

            case 50:
                sess = request.getSession(true);
                sess.removeAttribute("case");

                WebBusinessObject unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(request.getParameter("unitScheduleId"));
                WebBusinessObject unitWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(request.getParameter("unitId"));

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                statusName = request.getParameter("statusName");
                unit_Name = unitWbo.getAttribute("unitName").toString();
                title = unitScheduleWbo.getAttribute("maintenanceTitle").toString();
                ts = request.getParameter("ts");
                issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                if (null == filterValue) {
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ":" + new Long(dropdownDate.getDate(request.getParameter("endDate")).getTime()).toString() + ">" + request.getParameter("projectName") + "<" + request.getParameter("statusName");
                    //filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("projectName")+ "<" +request.getParameter("statusName");

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                    dateParser = new DateParser();
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("projectName") + "<" + request.getParameter("statusName");
                }
                
                equipmentID = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
                maintainableMgr = MaintainableMgr.getInstance();
                eqWbo = new WebBusinessObject();
                eqWbo = maintainableMgr.getOnSingleKey(equipmentID);
                try {
                    // servedPage = "/docs/issue/issue_listing.jsp";
                    servedPage = "/docs/issue/issue_report.jsp";
                    issueEquipmentMgr.setUser((WebBusinessObject) request.getSession().getAttribute("loggedUser"));
                    issueList = issueEquipmentMgr.getIssuesInRangeByTitle(request.getParameter("op"), filterValue, title);
                    for (int i = 0; i < issueList.size(); i++) {
                        WebBusinessObject issueWbo = (WebBusinessObject) issueList.get(i);
                        WebIssue webIssue = (WebIssue) issueWbo;
                        if (!webIssue.getAttribute("issueTitle").toString().equalsIgnoreCase(title)) {
                            issueList.remove(i);
                        }
                    }

                    request.setAttribute("filterName", "All");
                    request.setAttribute("filterValue", filterValue);
                    request.setAttribute("data", issueList);
                    request.setAttribute("ts", ts);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", statusName);
                    request.setAttribute("UnitName", unit_Name);
                    request.setAttribute("Title", title);
                    request.setAttribute("eqWbo", eqWbo);
                    this.forwardToServedPage(request, response);
                    break;
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }
                break;

            /*            case 51:
             issueID = request.getParameter("issueID");
             returnXML = null;
             issueMgr = IssueMgr.getInstance();
             WebIssue wIssue = (WebIssue) issueMgr.getOnSingleKey(issueID);
             if (issueID != null) {
             Vector vecIssues = new Vector();
             try {
             vecIssues = issueMgr.getOnArbitraryKey(issueID, "key4");
             } catch (SQLException ex) {
             logger.error(ex.getMessage());
             } catch (Exception ex) {
             logger.error(ex.getMessage());
             }

             if (vecIssues.size() > 0) {
             wbo = (WebBusinessObject) vecIssues.get(0);
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
             TradeMgr tradeMgr = TradeMgr.getInstance();
             String workTrade = (String) (tradeMgr.getOnSingleKey((String) wbo.getAttribute("workTrade"))).getAttribute("tradeName");
             wbo.setAttribute("workTrade", workTrade);
             //
             String scheduleUnitID = (String) wbo.getAttribute("unitScheduleID");
             QuantifiedMntenceMgr quantifiedMgr = QuantifiedMntenceMgr.getInstance();
             MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
             ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
             Vector actualItems = new Vector();
             try {
             actualItems = actualItemMgr.getOnArbitraryKey(scheduleUnitID, "key1");
             } catch (SQLException ex) {
             logger.error(ex.getMessage());
             } catch (Exception ex) {
             logger.error(ex.getMessage());
             }
             for (int i = 0; i < actualItems.size(); i++) {
             WebBusinessObject temp = (WebBusinessObject) actualItems.get(i);
             String itemID = (String) temp.getAttribute("itemId");
             WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
             temp.setAttribute("itemCode", item.getAttribute("itemCode"));
             temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
             }
             Vector quantifiedItems = new Vector();
             try {
             quantifiedItems = quantifiedMgr.getOnArbitraryKey(scheduleUnitID, "key1");
             } catch (SQLException ex) {
             logger.error(ex.getMessage());
             } catch (Exception ex) {
             logger.error(ex.getMessage());
             }
             for (int i = 0; i < quantifiedItems.size(); i++) {
             WebBusinessObject temp = (WebBusinessObject) quantifiedItems.get(i);
             String itemID = (String) temp.getAttribute("itemId");
             WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
             temp.setAttribute("itemCode", item.getAttribute("itemCode"));
             temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
             }

             unitScheduleMgr = UnitScheduleMgr.getInstance();
             unitScheduleWbo = unitScheduleMgr.getOnSingleKey(scheduleUnitID);
             ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
             Vector configureItems = new Vector();
             try {
             configureItems = configureMainTypeMgr.getOnArbitraryKey(((String) unitScheduleWbo.getAttribute("periodicId")), "key1");
             } catch (SQLException ex) {
             logger.error(ex.getMessage());
             } catch (Exception ex) {
             logger.error(ex.getMessage());
             }
             for (int i = 0; i < configureItems.size(); i++) {
             WebBusinessObject temp = (WebBusinessObject) configureItems.get(i);
             String itemID = (String) temp.getAttribute("itemId");
             WebBusinessObject item = maintenanceItemMgr.getOnSingleKey(itemID);
             temp.setAttribute("itemCode", item.getAttribute("itemCode"));
             temp.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
             }
             request.setAttribute("issueId", wbo.getAttribute("id"));
             request.setAttribute("actualItems", actualItems);
             request.setAttribute("quantifiedItems", quantifiedItems);
             request.setAttribute("configureItems", configureItems);
             //
             PlannedTasksMgr plannedTasksMgr = PlannedTasksMgr.getInstance();
             Vector vecPlannedTasks = plannedTasksMgr.getPlannedTasksByIssue((String) wbo.getAttribute("id"));
             EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
             Vector vecTasksHours = empTasksHoursMgr.getTasksHoursByIssue((String) wbo.getAttribute("id"));

             issueMgr = IssueMgr.getInstance();
             request.setAttribute("vecPlannedTasks", vecPlannedTasks);
             request.setAttribute("vecTasksHours", vecTasksHours);
             //
             ImageMgr imageMgr = ImageMgr.getInstance();
             Vector docsList = imageMgr.getListOnLIKE("ListDoc", (String) wbo.getAttribute("id"));
             request.setAttribute("data", docsList);
             //
             servedPage = "/docs/Search/search_job_result.jsp";
             request.setAttribute("wbo", wbo);
             request.setAttribute("page", servedPage);
             this.forwardToServedPage(request, response);
             } else {
             servedPage = "/docs/Search/search_joborder.jsp";
             request.setAttribute("page", servedPage);
             request.setAttribute("message", "No Job Order with this ID was found");
             this.forwardToServedPage(request, response);
             }
             } else {
             servedPage = "/docs/Search/search_joborder.jsp";
             request.setAttribute("page", servedPage);
             request.setAttribute("message", "No Job Order with this ID was found");
             this.forwardToServedPage(request, response);
             }
             break;
             */
                
            case 52:
                servedPage = "/docs/Search/search_BeginDate.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 53:
                issueList = null;
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                statusName = request.getParameter("statusName");
                if (null == filterValue) {
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ">" + request.getParameter("searchType") + "<" + request.getParameter("statusName")+":"+request.getParameter("projectName");
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                    dateParser = new DateParser();
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("searchType") + "<" + request.getParameter("statusName") + ":" + request.getParameter("projectName");
                }

                issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                servedPage = "/docs/issue/issue_listing.jsp";
                try {
                    issueList = issueEquipmentMgr.getALLIssuesByOneDate(filterValue, session);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                ComplexIssueMgr complexIssueMgr = ComplexIssueMgr.getInstance();
                Vector checkIsCmplx = new Vector();
                Vector subIssueList = new Vector();
                WebBusinessObject issueWbo = new WebBusinessObject();
                for (int i = 0; i < issueList.size(); i++) {
                    issueWbo = (WebBusinessObject) issueList.get(i);
                    try {
                        checkIsCmplx = complexIssueMgr.getOnArbitraryKey(issueWbo.getAttribute("id").toString(), "key1");
                        if (checkIsCmplx.size() > 0) {
                            issueWbo.setAttribute("issueType", "cmplx");
                        } else {
                            issueWbo.setAttribute("issueType", "normal");
                        }
                    } catch (Exception e) {}
                }

                equipmentID = filterValue.substring(filterValue.indexOf("<") + 1, filterValue.length());
                maintainableMgr = MaintainableMgr.getInstance();
                eqWbo = maintainableMgr.getOnSingleKey(equipmentID);
                String searchType = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
                if (searchType.equalsIgnoreCase("begin")) {
                    request.setAttribute("filterName", "getByBeginDate");
                } else {
                    request.setAttribute("filterName", "getByEndDate");
                }
                
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("data", issueList);

                request.setAttribute("page", servedPage);
//                request.setAttribute("status", statusName);
                request.setAttribute("eqWbo", eqWbo);
                request.setAttribute("ViewBack", "false");
                this.forwardToServedPage(request, response);
                break;

            case 54:
                servedPage = "/docs/Search/search_EndDate.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 55:
                servedPage = "/docs/Search/search_plan_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 56:
                issueList = null;
                issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                servedPage = "/docs/issue/plan_issues_report.jsp";

                String unitId = (String) request.getParameter("unitId");
                try {
                    issueList = issueEquipmentMgr.getIssuesForPlan(request, session, "Schedule");
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                complexIssueMgr = ComplexIssueMgr.getInstance();
                checkIsCmplx = new Vector();
                subIssueList = new Vector();
                issueWbo = new WebBusinessObject();
                WebBusinessObject eqpWbo = new WebBusinessObject();
                maintainableMgr = MaintainableMgr.getInstance();
                for (int i = 0; i < issueList.size(); i++) {
                    issueWbo = (WebBusinessObject) issueList.get(i);
                    try {
                        checkIsCmplx = complexIssueMgr.getOnArbitraryKey(issueWbo.getAttribute("id").toString(), "key1");
                        if (checkIsCmplx.size() > 0) {
                            issueWbo.setAttribute("issueType", "cmplx");
                        } else {
                            issueWbo.setAttribute("issueType", "normal");
                        }
                        eqpWbo = maintainableMgr.getOnSingleKey(issueWbo.getAttribute("unitId").toString());
                        issueWbo.setAttribute("unitName", eqpWbo.getAttribute("unitName").toString());
                    } catch (Exception e) {}
                }

                maintainableMgr = MaintainableMgr.getInstance();
                eqWbo = maintainableMgr.getOnSingleKey(unitId);

                request.getSession().setAttribute("planUnitId", unitId);
                request.getSession().setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.getSession().setAttribute("endDate", request.getParameter("endDate").toString());
                request.getSession().setAttribute("planType", "future");

                String lastFilter = "SearchServlet?op=searchPlanResult&beginDate=" + request.getParameter("beginDate") + "&endDate=" + request.getParameter("endDate") + "&unitId=" + request.getParameter("unitId");
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

                request.setAttribute("data", issueList);
                request.setAttribute("unitId", unitId);
                request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.setAttribute("endDate", request.getParameter("endDate").toString());
                request.setAttribute("page", servedPage);
                request.setAttribute("eqWbo", eqWbo);
                this.forwardToServedPage(request, response);
                break;

            case 57:
                String causeDescription = request.getParameter("causeDescription");
                String actionTaken = request.getParameter("actionTaken");
                String preventionTaken = request.getParameter("preventionTaken");

                issueMgr = IssueMgr.getInstance();
                if (causeDescription == null) {
                    causeDescription = "UL";
                }
                
                if (actionTaken == null) {
                    actionTaken = "UL";
                }
                
                if (preventionTaken == null) {
                    preventionTaken = "UL";
                }

                String actual_finish_time = request.getParameter("actual_finish_time");
                issueId = request.getParameter("issueId");
                String direction = "forward";
                wbo = new WebBusinessObject();

                wbo.setAttribute("issueId", issueId);
                wbo.setAttribute("workerNote", "Canceled From Plan");
                wbo.setAttribute("causeDescription", causeDescription);
                wbo.setAttribute("actionTaken", actionTaken);
                wbo.setAttribute("preventionTaken", preventionTaken);
                if (null != actual_finish_time) {
                    wbo.setAttribute("actual_finish_time", actual_finish_time);
                } else {
                    wbo.setAttribute("actual_finish_time", "0");
                }

                wbo.setAttribute(AppConstants.DIRECTION, direction);
                try {
                    //AssignedIssueState assIssueMgr;
                    issueMgr.cancelJopOrder(wbo, session);
                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }

                //get issues
                issueList = null;
                issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                String planType = (String) request.getSession().getAttribute("planType");
                if (planType != null) {
                    if (planType.equalsIgnoreCase("late")) {
                        servedPage = "/docs/issue/late_issues_report.jsp";
                    } else {
                        servedPage = "/docs/issue/plan_issues_report.jsp";
                    }
                } else {
                    servedPage = "/docs/issue/plan_issues_report.jsp";
                }

                unitId = (String) request.getParameter("unitId");
                try {
                    issueList = issueEquipmentMgr.getIssuesForPlan(request, session, "Schedule");
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                complexIssueMgr = ComplexIssueMgr.getInstance();
                checkIsCmplx = new Vector();
                subIssueList = new Vector();
                issueWbo = new WebBusinessObject();
                eqpWbo = new WebBusinessObject();
                maintainableMgr = MaintainableMgr.getInstance();
                for (int i = 0; i < issueList.size(); i++) {
                    issueWbo = (WebBusinessObject) issueList.get(i);
                    try {
                        checkIsCmplx = complexIssueMgr.getOnArbitraryKey(issueWbo.getAttribute("id").toString(), "key1");
                        if (checkIsCmplx.size() > 0) {
                            issueWbo.setAttribute("issueType", "cmplx");
                        } else {
                            issueWbo.setAttribute("issueType", "normal");
                        }
                        eqpWbo = maintainableMgr.getOnSingleKey(issueWbo.getAttribute("unitId").toString());
                        issueWbo.setAttribute("unitName", eqpWbo.getAttribute("unitName").toString());
                    } catch (Exception e) {}
                }

                maintainableMgr = MaintainableMgr.getInstance();
                eqWbo = maintainableMgr.getOnSingleKey(unitId);

                request.setAttribute("data", issueList);
                request.setAttribute("unitId", unitId);
                request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.setAttribute("endDate", request.getParameter("endDate").toString());
                request.setAttribute("page", servedPage);
                request.setAttribute("eqWbo", eqWbo);
                this.forwardToServedPage(request, response);
                break;

            case 58:
                servedPage = "/docs/Search/search_lateJo_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 59:
                issueList = null;
                issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                servedPage = "/docs/issue/late_issues_report.jsp";

                unitId = (String) request.getParameter("unitId");
                try {
                    issueList = issueEquipmentMgr.getIssuesForPlan(request, session, "Schedule");
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                complexIssueMgr = ComplexIssueMgr.getInstance();
                checkIsCmplx = new Vector();
                subIssueList = new Vector();
                issueWbo = new WebBusinessObject();
                eqpWbo = new WebBusinessObject();
                maintainableMgr = MaintainableMgr.getInstance();
                for (int i = 0; i < issueList.size(); i++) {
                    issueWbo = (WebBusinessObject) issueList.get(i);
                    try {
                        checkIsCmplx = complexIssueMgr.getOnArbitraryKey(issueWbo.getAttribute("id").toString(), "key1");
                        if (checkIsCmplx.size() > 0) {
                            issueWbo.setAttribute("issueType", "cmplx");
                        } else {
                            issueWbo.setAttribute("issueType", "normal");
                        }
                        eqpWbo = maintainableMgr.getOnSingleKey(issueWbo.getAttribute("unitId").toString());
                        issueWbo.setAttribute("unitName", eqpWbo.getAttribute("unitName").toString());
                    } catch (Exception e) {}
                }

                maintainableMgr = MaintainableMgr.getInstance();
                eqWbo = maintainableMgr.getOnSingleKey(unitId);

                request.getSession().setAttribute("planUnitId", unitId);
                request.getSession().setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.getSession().setAttribute("endDate", request.getParameter("endDate").toString());
                request.getSession().setAttribute("planType", "late");

                request.setAttribute("data", issueList);
                request.setAttribute("unitId", unitId);
                request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.setAttribute("endDate", request.getParameter("endDate").toString());
                request.setAttribute("page", servedPage);
                request.setAttribute("eqWbo", eqWbo);
                this.forwardToServedPage(request, response);
                break;

            case 60:
                servedPage = "/docs/Search/search_schedule_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 61:
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                statusName = request.getParameter("statusName");
                ts = request.getParameter("ts");
                sess = request.getSession(true);
                sess.removeAttribute("case");
                sess.removeAttribute("unitName");
                sess.removeAttribute("title");
                sess.removeAttribute("EquipMentID");
                issueEquipmentMgr = IssueEquipmentMgr.getInstance();

                params = "&beginDate=" + request.getParameter("beginDate") + "&endDate=" + request.getParameter("endDate") + "&projectName=" + request.getParameter("projectName") + "&statusName=" + request.getParameter("statusName");

                loggedUser = (WebBusinessObject) sess.getAttribute("loggedUser");
                jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                dateParser = new DateParser();
                if (null == filterValue) {
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString() + ">" + request.getParameter("projectName") + "<" + request.getParameter("statusName");
                    //filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("projectName")+ "<" +request.getParameter("statusName");
                }
                
                equipmentID = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
                maintainableMgr = MaintainableMgr.getInstance();
                eqWbo = maintainableMgr.getOnSingleKey(equipmentID);
                try {
                    servedPage = "/docs/issue/issue_listing.jsp";
                    // servedPage = "/docs/issue/issue_report.jsp";
                    issueEquipmentMgr.setUser((WebBusinessObject) request.getSession().getAttribute("loggedUser"));
                    if (equipmentID.equalsIgnoreCase("ALL")) {
                        issueList = issueEquipmentMgr.getALLIssuesLaterClosed(request.getParameter("op"), filterValue, session);
                    } else {
                        issueList = issueEquipmentMgr.getIssuesInRangeByTrade(request.getParameter("op"), filterValue, session);
                    }

                    complexIssueMgr = ComplexIssueMgr.getInstance();
                    checkIsCmplx = new Vector();
                    subIssueList = new Vector();
                    wbo = new WebBusinessObject();
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
                        } catch (Exception e) {}
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
                    
                    lastFilter = "SearchServlet?op=getJobOrdersByLateClosed" + params;
                    session.setAttribute("lastFilter", lastFilter);

                    topMenu = new Hashtable();
                    tempVec = new Vector();
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

//                    request.setAttribute("filterName", "All");
                    request.setAttribute("filterName", "getJobOrdersByLateClosed");

                    request.setAttribute("filterValue", filterValue);
//                    request.setAttribute("data", issueList);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
//                    request.setAttribute("fullUrl", url);
//                    request.setAttribute("url", url);
                    request.setAttribute("data", subIssueList);
                    request.setAttribute("ts", ts);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", statusName);
                    request.setAttribute("eqWbo", eqWbo);
                    request.setAttribute("ViewBack", "false");
                    this.forwardToServedPage(request, response);
                    break;
                } catch (Exception e) {
                    logger.error(e.getMessage());
                }
                break;

            case 62:
                servedPage = "/docs/Search/search_schedules_by_equipment.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 63:
                Vector dataVec = null;
                dateParser = new DateParser();

                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");
                String bDate = request.getParameter("beginDate");
                String eDate = request.getParameter("endDate");
                if (unitId != null && !unitId.equals("")) {
                    unitWbo = maintainableMgr.getOnSingleKey(unitId);
                    java.sql.Date beginDateSQL = dateParser.formatSqlDate(bDate);
                    java.sql.Date endDateSQL = dateParser.formatSqlDate(eDate);

                    dataVec = scheduleMgr.getAllSchedulesForEquipment(unitWbo, beginDateSQL, endDateSQL);

                    servedPage = "/docs/schedule/schedules_by_unit_list.jsp";
                    request.setAttribute("unitName", unitName);
                    request.setAttribute("bDate", bDate);
                    request.setAttribute("eDate", eDate);
                    request.setAttribute("data", dataVec);
                } else {
                    servedPage = "/docs/Search/search_schedules_by_equipment.jsp";
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 64:
                servedPage = "/docs/Search/search_schedule_by_date.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 65:
                servedPage = "/docs/Search/job_order_report_by_Date.jsp";
                projectMgr = ProjectMgr.getInstance();
                //ArrayList allSites = projectMgr.getAllAsArrayList();
                ArrayList mainTypeList = mainCategoryTypeMgr.getAllAsArrayList();
                ArrayList tradeList = tradeMgr.getAllAsArrayList();

                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                request.setAttribute("mainTypeList", mainTypeList);
                request.setAttribute("tradeList", tradeList);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("allSites", projects);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 66:
                servedPage = "/docs/Adminstration/search_task_by_date.jsp";
                this.forward(servedPage, request, response);
                break;

            case 67:
                servedPage = "/docs/planning/search_plan.jsp";
                this.forward(servedPage, request, response);
                break;

            case 68:
                servedPage = "/docs/planning/plan_list_search.jsp";
                String formName = (String) request.getParameter("formName");
                String selectionType = request.getParameter("selectionType");
                com.silkworm.pagination.Filter filter = null;
                List<WebBusinessObject> planList = null;
                if (selectionType == null) {
                    selectionType = "single";
                }

                if (formName == null) {
                    formName = "";
                }

                filter = Tools.getPaginationInfo(request, response);
                try {
                    planList = planMgr.paginationEntity(filter);
                } catch (Exception e) {
                    System.out.println(e);
                }

                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("planList", planList);
                this.forward(servedPage, request, response);
                break;

            case 69:
                servedPage = "/docs/Search/search_schedules_before_date.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 70:
                servedPage = "/docs/schedule/schedules_before_date.jsp";
                String beforeDateStr = request.getParameter("beforeDate");
                Vector scheduleVec = scheduleMgr.getSchedulesByBeforeDate(beforeDateStr);

                request.setAttribute("beforeDateStr", beforeDateStr);
                request.setAttribute("scheduleVec", scheduleVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 71:
                servedPage = "/docs/reports/tasks_with_and_without_items.jsp";

                Vector allTask = new Vector();
                Vector allTask2 = new Vector();
                List dataList = new ArrayList();

                TaskMgr taskMgr = TaskMgr.getInstance();
                allTask = taskMgr.getTasksUnattachedToParts();
                allTask2 = taskMgr.getTasksAttachedToParts();
                HashMap dataEntryMap = new HashMap();
                dataEntryMap.put("name", "Tasks without spare parts");
                dataEntryMap.put("y", allTask.size());
                dataList.add(dataEntryMap);

                dataEntryMap = new HashMap();
                dataEntryMap.put("name", "Tasks with spare parts");
                dataEntryMap.put("y", allTask2.size());
                dataList.add(dataEntryMap);

                String jsonText = JSONValue.toJSONString(dataList);
                request.setAttribute("jsonText", jsonText);
                request.setAttribute("totalTasks", allTask.size() + allTask2.size());
                this.forward(servedPage, request, response);
                break;

            case 72:
                servedPage = "/docs/Search/search_spare_part_in_schedule.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 73:
                String sparePartCode = request.getParameter("sparePartCode");
                if (sparePartCode != null) {
                    scheduleVec = new Vector();
                    scheduleVec = schedulesOnEquipmentByItemMgr.getByItemCode(sparePartCode);
                    if (scheduleVec.size() > 0) {
                        servedPage = "/docs/Search/schedules_by_spare_part.jsp";
                        request.setAttribute("scheduleVec", scheduleVec);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    } else {
                        servedPage = "/docs/Search/search_spare_part_in_schedule.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("messageFlag", "yes");
                        this.forwardToServedPage(request, response);
                    }
                } else {
                    servedPage = "/docs/Search/search_spare_part_in_schedule.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("messageFlag", "yes");
                    this.forwardToServedPage(request, response);
                }
                break;

            case 74:
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                servedPage = "/docs/sales/search_for_client.jsp";
                
                String check = null;
                String status = " ";

                request.setAttribute("page", servedPage);
                request.setAttribute("check", check);
                request.setAttribute("status", status);
                this.forwardToServedPage(request, response);
                break;

            case 75:
//                servedPage = "/docs/Search/search_for_client.jsp";
                PrintWriter out = response.getWriter();
                searchBy = request.getParameter("searchBy");
                String searchByValue = null;
                Vector clientStatusVec = null;
                status = " ";
                check = "check";
                wbo = new WebBusinessObject();

                Vector clientsVec = new Vector();
                WebBusinessObject result = new WebBusinessObject();
                if (searchBy.equalsIgnoreCase("clientNo")) {
                    searchByValue = request.getParameter("clientNo");
                    request.setAttribute("clientNo", searchByValue);
                    try {
                        wbo = clientMgr.getClientByNoAndID(searchByValue.trim());
//                        wbo = clientMgr.getOnSingleKey("key2", searchByValue.trim());
                        if (wbo != null) {
                            result.setAttribute("clientNoStatus", "ok");
                            result.setAttribute("clientId", wbo.getAttribute("id"));
                            result.setAttribute("age", wbo.getAttribute("age"));
                        } else {
                            result.setAttribute("clientNoStatus", "no");
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    
                    out.write(Tools.getJSONObjectAsString(result));
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
                    servedPage = "/docs/Search/search_for_client.jsp";
                    searchByValue = request.getParameter("searchValue");
//                    request.setAttribute("clientName", searchByValue);
                    try {
                        ClientMgr cm = ClientMgr.getInstance();
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
                            clientsVec = cm.clientByNameForSales(searchByValue, (String) departmentWbo.getAttribute("projectID"));//cm.clientByName(searchByValue);
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
                }
                break;
                
            case 76:
                servedPage = "/docs/Search/search_for_call.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 77:
                servedPage = "/docs/Search/search_for_call.jsp";
                searchBy = request.getParameter("searchBy");
                String searchByval = null;
                if (searchBy.equalsIgnoreCase("callId")) {
                    searchByval = request.getParameter("callId");
                    request.setAttribute("callId", searchByval);
                    try {
                        WebBusinessObject wbo2 = new WebBusinessObject();
                        wbo2 = clientMgr.getClientByCall(searchByval);
                        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        Vector clientComp = new Vector();
                        Vector closed = new Vector();
                        clientComp = issueByComplaintMgr.getOnArbitraryKey(searchByval, "key6");
                        WebBusinessObject wbo3 = new WebBusinessObject();
                        for (int i = 0; i < clientComp.size(); i++) {
                            wbo3 = (WebBusinessObject) clientComp.get(i);
                            if (wbo3.getAttribute("statusCode").equals("7")) {
                                closed.add(wbo3);
                            }
                        }
                        
                        if (clientComp.size() > 0) {
                            if (closed.size() == clientComp.size()) {
                                request.setAttribute("allClosed", "true");
                            } else {
                                request.setAttribute("allClosed", "false");
                            }
                        }
                        
                        request.setAttribute("clientWbo", wbo2);
                        request.setAttribute("clientComp", clientComp);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 78:
                servedPage = "/docs/Search/search_for_users.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 79:
                servedPage = "/docs/Search/search_for_users.jsp";
                searchBy = request.getParameter("searchBy");
                String username = null;
                if (searchBy.equalsIgnoreCase("username")) {
                    username = request.getParameter("username");
                    request.setAttribute("username", username);
                    try {
                        Vector users = new Vector();
                        WebBusinessObject wbo2 = new WebBusinessObject();
                        users = userMgr.getUsers(username);

                        request.setAttribute("data", users);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 80:
                servedPage = "/docs/Search/general_report.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 81:
                servedPage = "/docs/Search/search_for_complaints.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 82:
                servedPage = "/docs/Search/search_for_complaints.jsp";
                HttpSession s = request.getSession();
                WebBusinessObject logged = new WebBusinessObject();
                logged = (WebBusinessObject) s.getAttribute("loggedUser");
                String user_id = (String) logged.getAttribute("userId");
                String beDate = request.getParameter("beginDate");
                String enDate = request.getParameter("endDate");
//                int day=Integer.parseInt(enDate.substring(8,10))+1;
//                 String endDATE=day+"/"+enDate.substring(5,7)+"/"+enDate.substring(0,4);
                String type = request.getParameter("type");
                String compStatus = request.getParameter("compStatus");
                String msgType = "";
                if (type.equalsIgnoreCase("1")) {
                    msgType = "الشكاوى";
                } else if (type.equalsIgnoreCase("2")) {
                    msgType = "الطلبات";
                } else if (type.equalsIgnoreCase("3")) {
                    msgType = "الإستعلامات";
                }
                
                String msgStatus = "";
                if (compStatus.equalsIgnoreCase("4")) {
                    msgStatus = "الواردة";
                } else if (compStatus.equalsIgnoreCase("7")) {
                    msgStatus = "المغلقة";
                } else if (compStatus.equalsIgnoreCase("3")) {
                    msgStatus = "المعلقة";
                }
                
                EmployeeViewMgr employeeViewMgr = new EmployeeViewMgr();
                Vector data = new Vector();
                try {
                    data = employeeViewMgr.getComplaints(user_id, beDate, enDate, type, compStatus);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }

                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                request.setAttribute("msgStatus", msgStatus);
                request.setAttribute("msgType", msgType);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                this.forwardToServedPage(request, response);
                break;
                
            case 83:
                servedPage = "/docs/Search/search_for_complaints2.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 84:
                servedPage = "/docs/Search/search_for_complaints2.jsp";
                HttpSession s_ = request.getSession();
                logged = new WebBusinessObject();
                logged = (WebBusinessObject) s_.getAttribute("loggedUser");
                String userID = (String) logged.getAttribute("userId");
                String be_date = request.getParameter("beginDate");
                String en_date = request.getParameter("endDate");

//                int day=Integer.parseInt(enDate.substring(8,10))+1;
//                 String endDATE=day+"/"+enDate.substring(5,7)+"/"+enDate.substring(0,4);
                String type_ = request.getParameter("type");
                String compStatus_ = request.getParameter("compStatus");
                String msg_type = "";
                if (type_.equalsIgnoreCase("1")) {
                    msg_type = "ِشكاوى";
                } else if (type_.equalsIgnoreCase("2")) {
                    msg_type = "طلبات";
                } else if (type_.equalsIgnoreCase("3")) {
                    msg_type = "إستعلامات";
                }
                
                String msg_status = "";
                if (compStatus_.equalsIgnoreCase("2")) {
                    msg_status = "للمساعدة";
                } else if (compStatus_.equalsIgnoreCase("3")) {
                    msg_status = "للعلم";
                }
                
                ResponsibiltyCompViewMgr responsibiltyCompViewMgr = ResponsibiltyCompViewMgr.getInstance();
                Vector data_ = new Vector();
                try {
                    data_ = responsibiltyCompViewMgr.getComplaints(userID, be_date, en_date, type_, compStatus_);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }

                request.setAttribute("data", data_);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", en_date);
                request.setAttribute("msgStatus", msg_status);
                request.setAttribute("msgType", msg_type);
                request.setAttribute("beginDate", be_date);
                this.forwardToServedPage(request, response);
                break;
                
            case 85:
                servedPage = "/docs/Search/search_for_unit.jsp";
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                Vector products = new Vector();
                Vector mainProducts = new Vector();
                try {
//                    projects1 = projectMgr.getMainProjectsByUser(securityUser.getUserId());
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
                
            case 86:
                servedPage = "/docs/Search/search_for_unit.jsp";
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                products = new Vector();
                mainProducts = new Vector();
                Vector paymentPlace = new Vector();
                try {
//                    projects1 = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                    request.setAttribute("page", servedPage);
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                    wbo = (WebBusinessObject) products.get(0);
                    mainProducts = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                    request.setAttribute("data", mainProducts);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                ProjectMgr pm = ProjectMgr.getInstance();
//                s = request.getSession();
//                logged = new WebBusinessObject();
//                logged = (WebBusinessObject) s.getAttribute("loggedUser");
//                user_id = (String) logged.getAttribute("userId");
                String unitDes = request.getParameter("unitDes");
                String unitCategory = request.getParameter("unitCategory");
                wbo = new WebBusinessObject();
                wbo = pm.getOnSingleKey(unitCategory);
//                String text = wbo.getAttribute("projectName") + " - " + unitDes;
                String text = unitDes;
                UnitStatusMgr unitStatusMgr = UnitStatusMgr.getInstance();
                data = new Vector();
                try {
                    data = unitStatusMgr.getUnit(text, unitCategory);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("unitCategoryId", unitCategory);
                request.setAttribute("dataUnit", data);
                request.setAttribute("paymentPlace", paymentPlace);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 87:
                servedPage = "/docs/Search/search_for_call_by_name.jsp";
                projectMgr = ProjectMgr.getInstance();
                Vector Departments = new Vector();
                Departments = projectMgr.getAllDepartments();
                request.setAttribute("Departments", Departments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 88:
                servedPage = "/docs/Search/search_for_call_by_name.jsp";
                String callName = request.getParameter("callName");
                String Department = request.getParameter("Departments");
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                Vector cmpByCustomer = new Vector();
                if (Department.equalsIgnoreCase("all")) {
                    try {
                        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        cmpByCustomer = issueByComplaintMgr.getComplaintsByCustomer(beginDate, endDate, callName);

                        request.setAttribute("clientComp", cmpByCustomer);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                } else {
                    try {
                        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        cmpByCustomer = issueByComplaintMgr.getComplaintsByCustomer(beginDate, endDate, Department, callName);

                        request.setAttribute("clientComp", cmpByCustomer);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                projectMgr = ProjectMgr.getInstance();
                Departments = new Vector();
                Departments = projectMgr.getAllDepartments();
                request.setAttribute("Departments", Departments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 89:
                servedPage = "/docs/Search/search_for_docs.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 90:
                servedPage = "/docs/Search/search_for_docs.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                type = request.getParameter("configItemType");

                UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
                data = new Vector();
                try {
                    if (type.equalsIgnoreCase("all")) {
                        data = unitDocMgr.getUnitDocs(beDate, enDate);
                    } else {
                        data = unitDocMgr.getUnitDocs(beDate, enDate, type);
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }

                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                request.setAttribute("configItemType", type);
                this.forwardToServedPage(request, response);
                
            case 91:
                servedPage = "/docs/Search/search_for_unit_qa.jsp";
                searchBy = request.getParameter("searchBy");
                String searchValue = request.getParameter("searchValue");
                searchByValue = null;
                clientStatusVec = null;
                status = " ";
                check = "check";
                Vector unitsVec = new Vector();
                projectMgr = ProjectMgr.getInstance();
                if (searchBy != null && searchValue != null) {
                    if (searchBy.equalsIgnoreCase("unitNo")) {
                        try {
                            request.setAttribute("searchValue", searchValue);
                            EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                            WebBusinessObject departmentWbo;
                            if (managerWbo != null) {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                            } else {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                            }
                            
                            if (departmentWbo != null) {
                                unitsVec = projectMgr.getUnitsFromProject("1",searchValue, (String) departmentWbo.getAttribute("projectID"), null, null, null,(String) loggedUser.getAttribute("userId"));
                            }

                            lastFilter = "SearchServlet?op=searchForUnitQA&searchBy=unitNo&searchValue=" + searchValue + " ";
                            session.setAttribute("lastFilter", lastFilter);

                            topMenu = new Hashtable();
                            tempVec = new Vector();
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
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex);
                        }
                    } else if (searchBy.equalsIgnoreCase("buildingCode")) {
                        request.setAttribute("searchValue", searchValue);
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        WebBusinessObject departmentWbo;
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }
                        
                        if (departmentWbo != null) {
                            unitsVec = projectMgr.getBuildingUnits("1",searchValue, (String) departmentWbo.getAttribute("projectID"), null);
                        }
                    }
                    request.setAttribute("unitsVec", unitsVec);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);
                    try {
                        paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                        request.setAttribute("paymentPlace", paymentPlace);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                
                request.setAttribute("bokersList",userMgr.getAllBrokers());
                request.setAttribute("searchBy", searchBy);
                request.setAttribute("searchValue", searchValue);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 92:
                servedPage = "/docs/Search/search_for_vendor.jsp";
                searchBy = request.getParameter("searchBy");
                searchByValue = request.getParameter("searchByValue");
                String clientNo = "",
                 clientName = "",
                 ageGroup = "100";
                status = " ";
                check = "check";
                Vector clientVector;
                UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                if (searchBy.equalsIgnoreCase("clientNo")) {
                    clientNo = searchByValue;
//                    request.setAttribute("searchBy", searchBy);
                } else if (searchBy.equalsIgnoreCase("clientName")) {
                    clientName = searchByValue;
                }
                
                request.setAttribute("searchBy", searchBy);
                clientMgr = ClientMgr.getInstance();
                clientVector = clientMgr.getClientByAgeGroupAndNoOrName(ageGroup, clientNo, clientName);
                request.setAttribute("vendorVec", clientVector);
                request.setAttribute("status", status);
                request.setAttribute("check", check);
                request.setAttribute("userDefaultProject", userCompanyProjectsMgr.getUserDefaultProject((String) userObj.getAttribute("userId")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 93:
                servedPage = "/docs/Search/search_for_call_center_closed.jsp";
                ArrayList<WebBusinessObject> departments = new ArrayList<>();
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("departments", departments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 94:
                servedPage = "/docs/Search/search_for_call_center_closed.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                dateParser = new DateParser();
                Date beg = dateParser.formatSqlDate(beDate);
                Date en = dateParser.formatSqlDate(enDate);
                java.sql.Date beginD = new java.sql.Date(beg.getTime());
                java.sql.Date endD = new java.sql.Date(en.getTime());
                data = new Vector();
                IssueByComplaintUniqueMgr issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                compStatus = request.getParameter("compStatus");
                String ticketStatus = request.getParameter("ticketStatus");
                if (compStatus == null || compStatus.equalsIgnoreCase("all")) {
                    compStatus = "";
                }
                
                if (ticketStatus == null || ticketStatus.equalsIgnoreCase("all")) {
                    ticketStatus = "";
                }
                departments = new ArrayList<>();
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("departments", departments);
                
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                String departmentID = "";
                WebBusinessObject departmentWbo;
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                
                if (departmentWbo != null) {
                    departmentID = (String) departmentWbo.getAttribute("projectID");
                }
                String selectedDepartmentID = request.getParameter("departmentID");
                
                try {
                    data = issueByComplaintUniqueMgr.getAllCaseBetweenDatesByStatus(beginD, endD, compStatus, ticketStatus, departmentID, null, selectedDepartmentID);
//                    if (compStatus != null && !compStatus.equalsIgnoreCase("all")) {
//                        data = issueByComplaintAllCaseMgr.getAllCaseBetweenDatesByStatus(beginD, endD, compStatus);
//                    } else {
//                        data = issueByComplaintAllCaseMgr.getAllCaseBetweenDates(beginD, endD);
//                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                request.setAttribute("compStatus", compStatus);
                request.setAttribute("ticketStatus", ticketStatus);
                request.setAttribute("departmentID", selectedDepartmentID);
                this.forwardToServedPage(request, response);
                break;

            case 95:
                servedPage = "/docs/Search/search_for_unit_menu.jsp";
                projectMgr = ProjectMgr.getInstance();
                try {
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

            case 96:
                servedPage = "/docs/Search/search_for_unit_menu.jsp";
                projectMgr = ProjectMgr.getInstance();
                paymentPlace = new Vector();
                try {
                    request.setAttribute("page", servedPage);
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                    wbo = (WebBusinessObject) products.get(0);
                    mainProducts = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                    request.setAttribute("data", mainProducts);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                unitDes = request.getParameter("unitDes");
                unitCategory = request.getParameter("unitCategory");
                text = unitDes;
                unitStatusMgr = UnitStatusMgr.getInstance();
                data = new Vector();
                try {
                    if (unitCategory != null && !unitCategory.equals("") && !unitCategory.equals("----")) {
                        data = unitStatusMgr.getUnit(text, unitCategory);
                    } else if (unitCategory != null && !unitCategory.equals("") && unitCategory.equals("----")) {
                        data = unitStatusMgr.getUnitWithoutParent(text);
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("unitCategoryId", unitCategory);
                request.setAttribute("dataUnit", data);
                request.setAttribute("paymentPlace", paymentPlace);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 97:
                servedPage = "/docs/Search/search_for_single_unit.jsp";
                projectMgr = ProjectMgr.getInstance();
                try {
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

            case 98:
                servedPage = "/docs/Search/search_for_single_unit.jsp";
                projectMgr = ProjectMgr.getInstance();
                paymentPlace = new Vector();
                try {
                    request.setAttribute("page", servedPage);
                    products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
                    wbo = (WebBusinessObject) products.get(0);
                    mainProducts = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2");
                    paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                    request.setAttribute("data", mainProducts);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                unitDes = request.getParameter("unitDes");
                unitCategory = request.getParameter("unitCategory");
                text = unitDes;
                unitStatusMgr = UnitStatusMgr.getInstance();
                data = new Vector();
                try {
                    data = unitStatusMgr.getUnit(text, unitCategory);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("unitCategoryId", unitCategory);
                request.setAttribute("dataUnit", data);
                request.setAttribute("paymentPlace", paymentPlace);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 99:
                servedPage = "/docs/Search/search_for_client.jsp";
                ClientMgr cm = ClientMgr.getInstance();
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
                        clientsVec = cm.clientByNameForSales("", (String) departmentWbo.getAttribute("projectID"));
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
                    
                    request.setAttribute("clientsVec", clientsVec);
                    request.setAttribute("clientWbo", wbo);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(SalesMarketingServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;

            case 100:
                servedPage = "/docs/Search/search_for_unit_qa.jsp";
                searchByValue = null;
                clientStatusVec = null;
                status = " ";
                check = "check";
                projectMgr = ProjectMgr.getInstance();

                request.setAttribute("searchValue", "");
                unitsVec = new Vector();
                try {
                    empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                  
                    
                    String unitStatus = request.getParameter("unitStatus");
                    if(request.getParameter("boker_id")!=null) // for brokers list only
                    {
                       unitsVec = projectMgr.getAllUnitsFromProjectByBoker((String) departmentWbo.getAttribute("projectID"), unitStatus,request.getParameter("boker_id"));

                    }
                    else if (departmentWbo != null) {
                        unitsVec = projectMgr.getAllUnitsFromProject((String) departmentWbo.getAttribute("projectID"), unitStatus);
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("unitsVec", unitsVec);
                request.setAttribute("status", status);
                request.setAttribute("check", check);
                try {
                    paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                    request.setAttribute("paymentPlace", paymentPlace);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                lastFilter = "SearchServlet?op=SearchForAllUnits";
                session.setAttribute("lastFilter", lastFilter);

                topMenu = new Hashtable();
                tempVec = new Vector();
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

                if(request.getParameter("excel") != null && request.getParameter("excel").equals("1")){
                    StringBuilder titleStr = new StringBuilder("Units By Project");
		    String headers[] = {"#", "Project Name", "Model", "Creation Time", "Unit Name", "Area", "Price", "Source", "Client Name", "Unit Status"};
                    String attributes[] = {"Number", "parentName", "modelName", "creationTime", "projectName", "area", "price", "fullName", "clientName", "statusNameStr"};
                    String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                    String[] headerStr = new String[1];
                    headerStr[0] = titleStr.toString();
                    HSSFWorkbook workBook = Tools.createExcelReport("Units By Project", headerStr, null, headers, attributes, dataTypes, new ArrayList(unitsVec));
                    Calendar c = Calendar.getInstance();
		    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    sdf.applyPattern("yyyy-MM-dd");
                    String filename = "Units By Project";
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
                }
                
                request.getSession().setAttribute("topMenu", topMenu);

                request.setAttribute("searchBy", "unitNo");
                request.setAttribute("untStsExlRprt", request.getParameter("unitStatus"));
                request.setAttribute("searchValue", "");
                request.setAttribute("page", servedPage);
                ArrayList<WebBusinessObject> brokersList=userMgr.getAllBrokers();
                request.setAttribute("bokersList",userMgr.getAllBrokers());
                this.forwardToServedPage(request, response);
                break;
                
            case 101:
                servedPage = "/docs/Search/search_for_client_by_unit.jsp";
                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> projectList = new ArrayList<WebBusinessObject>();
                try {
                    projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("clientLst", request.getAttribute("clientLst"));
                request.setAttribute("projectList", projectList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
//            case 102:
//                servedPage = "/docs/Search/search_client_for_call_center_int.jsp";
//                projectMgr = ProjectMgr.getInstance();
//                projectList = new ArrayList<WebBusinessObject>();
//                try {
//                    mainProject = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("PRODUCTS", "key3"));
//                    projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) mainProject.get(0).getAttribute("projectID"), "key2"));
//                } catch (SQLException ex) {
//                    logger.error(ex);
//                } catch (Exception ex) {
//                    logger.error(ex);
//                }
//                request.setAttribute("projectList", projectList);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                break;
                
            case 103:
                servedPage = "/docs/Search/search_for_documents.jsp";
                request.setAttribute("page", servedPage);
                userMgr = UserMgr.getInstance();
                clientMgr = ClientMgr.getInstance();
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                request.setAttribute("engineersList", userMgr.getAllEngineers());
                this.forwardToServedPage(request, response);
                break;

            case 104:
                servedPage = "/docs/Search/search_for_documents.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                dateParser = new DateParser();
                beg = dateParser.formatSqlDate(beDate);
                en = dateParser.formatSqlDate(enDate);
                beginD = new java.sql.Date(beg.getTime());
                endD = new java.sql.Date(en.getTime());
                ArrayList<WebBusinessObject> dataResult = new ArrayList<WebBusinessObject>();
                IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                String contractorID = request.getParameter("contractorID");
                String engineerID = request.getParameter("engineerID");
                if (contractorID == null || contractorID.equalsIgnoreCase("all")) {
                    contractorID = "";
                }
                
                if (engineerID == null || engineerID.equalsIgnoreCase("all")) {
                    engineerID = "";
                }
                
                try {
                    dataResult = issueByComplaintAllCaseMgr.getRequestsBetweenDates(beginD, endD, contractorID, engineerID, "5");
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                request.setAttribute("engineersList", userMgr.getAllEngineers());
                request.setAttribute("data", dataResult);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                request.setAttribute("contractorID", contractorID);
                request.setAttribute("engineerID", engineerID);
                this.forwardToServedPage(request, response);
                break;
                
            case 105:
                servedPage = "/docs/Search/search_for_client_With_ChoosenWidth.jsp";
                UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                request.setAttribute("groups", userGroupConfigMgr.getAllUserGroupConfig((String) persistentUser.getAttribute("userId")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 106:
                servedPage = "/docs/Search/search_for_client_With_ChoosenWidth.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                String reportType = request.getParameter("reportType");
                dateParser = new DateParser();
                beg = dateParser.formatSqlDate(beDate);
                en = dateParser.formatSqlDate(enDate);
                beginD = new java.sql.Date(beg.getTime());
                endD = new java.sql.Date(en.getTime());
                ArrayList<WebBusinessObject> reportData = new ArrayList<>();
                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                if (reportType == null || "withWish".equals(reportType)) {
                    reportData = new ArrayList<>(clientProductMgr.getClientsWithWidth(beginD, endD, "true".equals(request.getParameter("hasVisits")), request.getParameter("groupID")));
                    ArrayList<WebBusinessObject> ratioData = clientProductMgr.getClientProductWidthRatio(beginD, endD, "true".equals(request.getParameter("hasVisits")),
                            request.getParameter("groupID"));
                    String complaintCountStr = null;
                    int totalCount = 0;
                    WebBusinessObject widthRationWbo;
                    dataList = new ArrayList();

                    // populate series data map
                    for (int i = 0; i < ratioData.size(); i++) {
                        dataEntryMap = new HashMap();
                        widthRationWbo = (WebBusinessObject) ratioData.get(i);
                        complaintCountStr = (String) widthRationWbo.getAttribute("total");
                        totalCount += Integer.parseInt(complaintCountStr);
                        dataEntryMap.put("name", widthRationWbo.getAttribute("unitWidth"));
                        dataEntryMap.put("y", new Integer(complaintCountStr));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalCount", totalCount);
                    request.setAttribute("jsonText", jsonText);
                } else {
                    reportData = clientMgr.getClientsWithNoWish(beginD, endD, "true".equals(request.getParameter("hasVisits")),
                            request.getParameter("groupID"));
                }
                userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                request.setAttribute("groupID", request.getParameter("groupID"));
                request.setAttribute("groups", userGroupConfigMgr.getAllUserGroupConfig((String) persistentUser.getAttribute("userId")));
                request.setAttribute("data", reportData);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                request.setAttribute("hasVisits", request.getParameter("hasVisits"));
                request.setAttribute("reportType", reportType);
                this.forwardToServedPage(request, response);
                break;

            case 107:
                servedPage = "/docs/requests/search_for_requests.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                contractorID = request.getParameter("contractorID");
                if (contractorID == null || contractorID.equalsIgnoreCase("all")) {
                    contractorID = "";
                }
                
                if (beDate != null && enDate != null) {
                    try {
                        dateParser = new DateParser();
                        beg = dateParser.formatSqlDate(beDate);
                        en = dateParser.formatSqlDate(enDate);
                        beginD = new java.sql.Date(beg.getTime());
                        endD = new java.sql.Date(en.getTime());
                        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        List<WebBusinessObject> requests = issueByComplaintMgr.getComplaintsByCreatorDateComments(loggegUserId, beginD, endD, contractorID, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION);

                        request.setAttribute("data", requests);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                lastFilter = new StringBuilder("SearchServlet?op=getRequests&beginDate=").append(beDate).append("&endDate=").append(enDate).append("&contractorID=").append(contractorID).toString();
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
                request.setAttribute("contractorID", contractorID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 108:
                servedPage = "/docs/Search/search_for_new_client.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String senderID = request.getParameter("senderID");
                String currentOwnerID = request.getParameter("currentOwnerID");
                String description = request.getParameter("description") != null ? request.getParameter("description") : "";
                if (beginDate != null && endDate != null) {
                    issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                    try {
                        request.setAttribute("data", issueByComplaintUniqueMgr.getNewClientsBetweenDates(beginDate, endDate, description, senderID, currentOwnerID));
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    
                    request.setAttribute("beginDate", beginDate);
                    request.setAttribute("endDate", endDate);
                    request.setAttribute("description", description);
                    request.setAttribute("senderID", senderID);
                    request.setAttribute("currentOwnerID", currentOwnerID);
                }

                lastFilter = "SearchServlet?op=searchNewClients&beginDate=" + beginDate + "&endDate=" + endDate + "&description=" + description
                        + "&senderID=" + senderID + "&currentOwnerID=" + currentOwnerID;
                session.setAttribute("lastFilter", lastFilter);

                topMenu = new Hashtable();
                tempVec = new Vector();
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
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("usersList", new ArrayList<WebBusinessObject>(userMgr.getCashedTable()));
                request.setAttribute("meetings", projectMgr.getMeetingProjects());
                request.setAttribute("callResults", projectMgr.getCallResultsProjects());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 109:
                servedPage = "/docs/requests/search_for_requests.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                if (beDate != null && enDate != null) {
                    try {
                        dateParser = new DateParser();
                        beg = dateParser.formatSqlDate(beDate);
                        en = dateParser.formatSqlDate(enDate);
                        beginD = new java.sql.Date(beg.getTime());
                        endD = new java.sql.Date(en.getTime());
                        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        List<WebBusinessObject> requests = issueByComplaintMgr.getComplaintsByDateComments(beginD, endD, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION);

                        request.setAttribute("data", requests);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                
                request.setAttribute("display", "All");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 110:
                issueID = request.getParameter("issueID");
                String customerId = request.getParameter("customerID");
                String singleSelect = request.getParameter("singleSelect");
                servedPage = "/docs/requests/list_of_all_request.jsp";
                IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                List<WebBusinessObject> requests;
                if (singleSelect == null) {
                    requests = issueByComplaintMgr.getValidComplaintsByComments(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY, customerId);
                } else {
                    requests = issueByComplaintMgr.getClientRequestsByComments(customerId);
                }

                if (singleSelect != null) {
                    request.setAttribute("singleSelect", singleSelect);
                }
                request.setAttribute("issueID", issueID);
                request.setAttribute("page", servedPage);
                request.setAttribute("data", requests);
                this.forward(servedPage, request, response);
                break;
                
            case 111:
                String docCode = request.getParameter("docCode");
                String requestCode = request.getParameter("ids");
                String[] ids = requestCode.split(",");

                issueMgr = IssueMgr.getInstance();
                boolean saved = false;
                for (String id : ids) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("docCode", docCode);
                    wbo.setAttribute("requestCode", id);
                    saved = issueMgr.saveDocRequests(wbo, loggegUserId);
                }
                
                if (saved) {
                    response.getWriter().write("OK");
                } else {
                    response.getWriter().write("NO");
                }
                break;
                
            case 112:
                issueID = request.getParameter("issueID");
                servedPage = "/docs/requests/list_of_all_request.jsp";
                issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                requests = issueByComplaintMgr.getIssueComplaintsByComments(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY, issueID);
                request.setAttribute("data", requests);
                request.setAttribute("shownOnly", "true");
                request.setAttribute("page", servedPage);
                request.setAttribute("issueID", issueID);
                this.forward(servedPage, request, response);
                break;

            case 113:
                servedPage = "/docs/requests/search_for_all_requests.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                contractorID = request.getParameter("contractorID");
                engineerID = request.getParameter("engineerID");
                String itemID = request.getParameter("itemID");
                String projectID = request.getParameter("projectID");
                String requestType = request.getParameter("requestType");
                if (contractorID == null || contractorID.equalsIgnoreCase("all")) {
                    contractorID = "";
                }
                
                if (engineerID == null || engineerID.equalsIgnoreCase("all")) {
                    engineerID = "";
                }
                
                if (itemID == null || itemID.equalsIgnoreCase("all")) {
                    itemID = "";
                }
                
                if (projectID == null || projectID.equalsIgnoreCase("all")) {
                    projectID = "";
                }
                
                if (requestType == null) {
                    requestType = CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION;
                }
                
                if (beDate != null && enDate != null) {
                    try {
                        dateParser = new DateParser();
                        beg = dateParser.formatSqlDate(beDate);
                        en = dateParser.formatSqlDate(enDate);
                        beginD = new java.sql.Date(beg.getTime());
                        endD = new java.sql.Date(en.getTime());
                        issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        requests = issueByComplaintMgr.getAllComplaintsByDateComments(loggegUserId, beginD, endD, requestType, engineerID, 
                                contractorID, itemID, projectID);

                        request.setAttribute("data", requests);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                request.setAttribute("engineersList", userMgr.getAllEngineers());
                try {
                    request.setAttribute("itemsList", new ArrayList<>(projectMgr.getOnArbitraryKey("REQ-ITEM", "key4")));
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("itemsList", new ArrayList<WebBusinessObject>());
                    request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                }

                lastFilter = new StringBuilder("SearchServlet?op=getRequestsForAll&beginDate=").append(beDate).append("&endDate=").append(enDate)
                        .append("&engineerID=").append(engineerID).append("&contractorID=").append(contractorID).append("&itemID=").append(itemID)
                        .append("&projectID=").append(projectID).append("&requestType=").append(requestType).toString();
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
                request.setAttribute("contractorID", contractorID);
                request.setAttribute("engineerID", engineerID);
                request.setAttribute("itemID", itemID);
                request.setAttribute("projectID", projectID);
                request.setAttribute("requestType", requestType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 114:
                servedPage = "/docs/requests/search_for_requests_quality.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                if (beDate != null && enDate != null) {
                    try {
                        dateParser = new DateParser();
                        beg = dateParser.formatSqlDate(beDate);
                        en = dateParser.formatSqlDate(enDate);
                        beginD = new java.sql.Date(beg.getTime());
                        endD = new java.sql.Date(en.getTime());
                        issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        requests = issueByComplaintMgr.getComplaintsByCrruentOwnerDateComments(loggegUserId, beginD, endD, CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY);

                        request.setAttribute("data", requests);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                
                lastFilter = new StringBuilder("SearchServlet?op=getRequestsForAll&beginDate=").append(beDate).append("&endDate=").append(enDate).toString();
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
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 115:
                servedPage = "/docs/requests/search_within_comments.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                engineerID = request.getParameter("engineerID");
                String comment = request.getParameter("comment");
                if (engineerID == null || engineerID.equalsIgnoreCase("all")) {
                    engineerID = "";
                }
                
                if (beDate != null && enDate != null) {
                    try {
                        dateParser = new DateParser();
                        beg = dateParser.formatSqlDate(beDate);
                        en = dateParser.formatSqlDate(enDate);
                        beginD = new java.sql.Date(beg.getTime());
                        endD = new java.sql.Date(en.getTime());
                        issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        requests = issueByComplaintMgr.getComplaintsWithComments(engineerID, beginD, endD, comment);

                        request.setAttribute("data", requests);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    lastFilter = new StringBuilder("SearchServlet?op=searchWithinComments&beginDate=").append(beDate).append("&endDate=").append(enDate)
                            .append("&engineerID=").append(engineerID).append("&comment=").append(comment).toString();
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
                
                request.setAttribute("engineersList", userMgr.getAllEngineers());
                request.setAttribute("engineerID", engineerID);
                request.setAttribute("comment", comment);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 116:
                servedPage = "/docs/requests/search_for_all_requestsQ.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                contractorID = request.getParameter("contractorID");
                engineerID = request.getParameter("engineerID");
                itemID = request.getParameter("itemID");
                projectID = request.getParameter("projectID");
                String statusOfIssue = request.getParameter("statusOfIssue");
                if (contractorID == null || contractorID.equalsIgnoreCase("all")) {
                    contractorID = "";
                }
                
                if (engineerID == null || engineerID.equalsIgnoreCase("all")) {
                    engineerID = "";
                }
                
                if (itemID == null || itemID.equalsIgnoreCase("all")) {
                    itemID = "";
                }
                
                if (projectID == null || projectID.equalsIgnoreCase("all")) {
                    projectID = "";
                }
                
                if (statusOfIssue == null || statusOfIssue.equalsIgnoreCase("all")) {
                    statusOfIssue = "";
                }
                
                if (beDate != null && enDate != null) {
                    try {
                        dateParser = new DateParser();
                        beg = dateParser.formatSqlDate(beDate);
                        en = dateParser.formatSqlDate(enDate);
                        beginD = new java.sql.Date(beg.getTime());
                        endD = new java.sql.Date(en.getTime());
                        issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                        requests = issueByComplaintMgr.getAllComplaintsByDateLastCommenter(loggegUserId, beginD, endD,
                                CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY, engineerID, contractorID, itemID, projectID, statusOfIssue);

                        request.setAttribute("data", requests);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                request.setAttribute("engineersList", userMgr.getAllEngineers());
                try {
                    request.setAttribute("itemsList", new ArrayList<>(projectMgr.getOnArbitraryKey("REQ-ITEM", "key4")));
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("itemsList", new ArrayList<WebBusinessObject>());
                    request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                }

                lastFilter = new StringBuilder("SearchServlet?op=getRequestsForAll&beginDate=").append(beDate).append("&endDate=").append(enDate)
                        .append("&engineerID=").append(engineerID).append("&contractorID=").append(contractorID).append("&itemID=").append(itemID)
                        .append("&projectID=").append(projectID).append("&statusOfIssue=").append(statusOfIssue).toString();
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
                request.setAttribute("contractorID", contractorID);
                request.setAttribute("engineerID", engineerID);
                request.setAttribute("itemID", itemID);
                request.setAttribute("projectID", projectID);
                request.setAttribute("statusOfIssue", statusOfIssue);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 117:
                servedPage = "/docs/bus_admin/search_for_all_documents.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                projectID = request.getParameter("projectID");
                title = request.getParameter("title");
                if (projectID == null) {
                    projectID = "";
                }
                
                if (title == null) {
                    title = "";
                }
                
                if (beDate != null && enDate != null) {
                    try {
                        dateParser = new DateParser();
                        beg = dateParser.formatSqlDate(beDate);
                        en = dateParser.formatSqlDate(enDate);
                        beginD = new java.sql.Date(beg.getTime());
                        endD = new java.sql.Date(en.getTime());
                        unitDocMgr = UnitDocMgr.getInstance();
                        List<WebBusinessObject> documentsList = unitDocMgr.searchForDocuments(beginD, endD, projectID, title);

                        request.setAttribute("data", documentsList);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("projectsList", new ArrayList<WebBusinessObject>(projectMgr.getAllProjectsOrderedByName()));

                lastFilter = new StringBuilder("SearchServlet?op=searchForAllDocuments&beginDate=").append(beDate).append("&endDate=").append(enDate)
                        .append("&title=").append(title).append("&projectID=").append(projectID).toString();
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
                request.setAttribute("projectID", projectID);
                request.setAttribute("title", title);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 118:
                servedPage = "/docs/Search/search_for_new_client_branch.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                senderID = request.getParameter("senderID");
                String branchID = request.getParameter("branchID");
                if (beginDate != null && endDate != null) {
                    issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                    try {
                        request.setAttribute("data", issueByComplaintUniqueMgr.getNewClientsByBranchBetweenDates(beginDate, endDate, senderID, branchID));
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    
                    request.setAttribute("beginDate", beginDate);
                    request.setAttribute("endDate", endDate);
                    request.setAttribute("senderID", senderID);
                    request.setAttribute("branchID", branchID);
                }

                lastFilter = "SearchServlet?op=searchNewClientsByBranch&beginDate=" + beginDate + "&endDate=" + endDate + "&senderID=" + senderID
                        + "&branchID=" + branchID;
                session.setAttribute("lastFilter", lastFilter);

                topMenu = new Hashtable();
                tempVec = new Vector();
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
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("usersList", new ArrayList<WebBusinessObject>(userMgr.getCashedTable()));
                request.setAttribute("meetings", projectMgr.getMeetingProjects());
                request.setAttribute("callResults", projectMgr.getCallResultsProjects());
                try {
                    request.setAttribute("branchesList", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2")));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 119:
                servedPage = "/docs/Search/search_for_my_documents.jsp";
                request.setAttribute("page", servedPage);
                userMgr = UserMgr.getInstance();
                clientMgr = ClientMgr.getInstance();
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                this.forwardToServedPage(request, response);
                break;

            case 120:
                servedPage = "/docs/Search/search_for_my_documents.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                dateParser = new DateParser();
                beg = dateParser.formatSqlDate(beDate);
                en = dateParser.formatSqlDate(enDate);
                beginD = new java.sql.Date(beg.getTime());
                endD = new java.sql.Date(en.getTime());
                dataResult = new ArrayList<>();
                issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                contractorID = request.getParameter("contractorID");
                if (contractorID == null || contractorID.equalsIgnoreCase("all")) {
                    contractorID = "";
                }
                
                try {
                    dataResult = issueByComplaintAllCaseMgr.getRequestsBetweenDates(beginD, endD, contractorID, (String) loggedUser.getAttribute("userId"), "5");
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                request.setAttribute("data", dataResult);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                request.setAttribute("contractorID", contractorID);
                this.forwardToServedPage(request, response);
                break;

            case 121:
                servedPage = "/docs/Search/search_for_project_unit.jsp";

                ArrayList<WebBusinessObject> projectsLst = null;
                
                projectMgr = ProjectMgr.getInstance();
                try {
                    userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                    projectsLst = new ArrayList(userCompanyProjectsMgr.getAllProjectsByUserId((String) persistentUser.getAttribute("userId")));
                    if (projectsLst.isEmpty()) {
                        projectsLst = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4"));
                    }
                } catch (Exception ex) {
                    System.out.println("Get Projects List Exception = " + ex.getMessage());
                }
                
                 ArrayList<WebBusinessObject>AreaList=projectMgr.getUnitsArea();
                
                 request.setAttribute("AreaList",AreaList);
                if (projectsLst != null && !projectsLst.isEmpty()) {
                    ArrayList<WebBusinessObject> prjZone = new ArrayList<WebBusinessObject>();
                    for (int index = 0; index < projectsLst.size(); index++) {
                        prjZone = projectMgr.getPrjZone(projectsLst.get(index).getAttribute("projectID").toString());
                        if (prjZone != null && !prjZone.isEmpty()) {
                            projectsLst.get(index).setAttribute("prjZoneName", projectMgr.getPrjZoneName(prjZone.get(0).getAttribute("zoneID").toString()).get(0).getAttribute("zoneName"));
                        }
                    }
                }
                
                UnitTypeMgr unitTypeMgr = UnitTypeMgr.getInstance();
                WebBusinessObject locationWbo = LocationTypeMgr.getInstance().getOnSingleKey("key1", "RES-UNIT");
                try {
                    request.setAttribute("unitTypesList", new ArrayList<>(unitTypeMgr.getOnArbitraryKeyOracle((String) locationWbo.getAttribute("id"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("unitTypesList", new ArrayList<>());
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("projects", projectsLst);
                this.forwardToServedPage(request, response);
                break;

            case 122:
                servedPage = "/docs/Search/search_for_project_unit.jsp";

                String unitvalue = request.getParameter("searchValue");
                String[] projectsArr = (String[]) request.getParameterValues("projects");
                if(request.getParameter("excel") != null && request.getParameter("excel").equals("1")){
                projectsArr= (String[])request.getParameter("projects").split(",");
                }
                String unitStatus = request.getParameter("unitStatus");
                
                searchBy = request.getParameter("search");
                clientStatusVec = null;
                status = " ";
                check = "check";
                unitsVec = new Vector();
                projectMgr = ProjectMgr.getInstance();
                
                projectMgr = ProjectMgr.getInstance();
                projectsLst = new ArrayList<>();
                try {
                    userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                    projectsLst = new ArrayList(userCompanyProjectsMgr.getAllProjectsByUserId((String) persistentUser.getAttribute("userId")));
                    if (projectsLst.isEmpty()) {
                        projectsLst = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4"));
                    } else {
                        if (projectsArr == null || projectsArr.length == 0) {
                            projectsArr = new String[projectsLst.size()];
                            for (int i = 0; i < projectsLst.size(); i++) {
                                WebBusinessObject projectTemp = projectsLst.get(i);
                                projectsArr[i] = (String) projectTemp.getAttribute("projectID");
                            }
                        }
                    }
                } catch (Exception ex) {
                    System.out.println("Get Projects List Exception = " + ex.getMessage());
                }
                if (searchBy != null) {
                    empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                    if (searchBy.equalsIgnoreCase("unitNo")) {
                        try {
                            if (departmentWbo != null) {
                                
                                if (projectsArr != null && projectsArr.length > 0 && !projectsArr[0].isEmpty()) {
                                    unitsVec = projectMgr.getUnitsForProjects("1",unitvalue, (String) departmentWbo.getAttribute("projectID"), projectsArr, request.getParameter("unitTypeID"), request.getParameter("unitAreaID"), unitStatus);
                                } else {
                                    unitsVec = projectMgr.getUnitsFromProject("1",unitvalue, (String) departmentWbo.getAttribute("projectID"), request.getParameter("unitTypeID"), request.getParameter("unitAreaID"), unitStatus, (String) loggedUser.getAttribute("userId"));
                                }
                                request.setAttribute("projectsArr", projectsArr);
                            }
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex);
                        }
                    } else if (searchBy.equalsIgnoreCase("buildingCode")) {
                        if (departmentWbo != null) {
                            unitsVec = projectMgr.getBuildingUnits("1",unitvalue, (String) departmentWbo.getAttribute("projectID"), String.join("','", request.getParameterValues("projects")));
                        }
                    }
                    AreaList=projectMgr.getUnitsArea();
                
                    request.setAttribute("AreaList",AreaList);
                    request.setAttribute("unitsVec", unitsVec);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);
                    try {
                        paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                        request.setAttribute("paymentPlace", paymentPlace);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    lastFilter = "SearchServlet?op=getUnitByProject&search=" + searchBy + " ";
                    session.setAttribute("lastFilter", lastFilter);
                    topMenu = new Hashtable();
                    tempVec = new Vector();
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


                if (projectsLst != null && !projectsLst.isEmpty()) {
                    ArrayList<WebBusinessObject> prjZone = new ArrayList<>();
                    for (WebBusinessObject projectWbo : projectsLst) {
                        prjZone = projectMgr.getPrjZone(projectWbo.getAttribute("projectID").toString());
                        if (prjZone != null && !prjZone.isEmpty()) {
                            projectWbo.setAttribute("prjZoneName", projectMgr.getPrjZoneName(prjZone.get(0).getAttribute("zoneID").toString()).get(0).getAttribute("zoneName"));
                        }
                    }
                }
                
                unitTypeMgr = UnitTypeMgr.getInstance();
                locationWbo = LocationTypeMgr.getInstance().getOnSingleKey("key1", "RES-UNIT");
                try {
                    request.setAttribute("unitTypesList", new ArrayList<>(unitTypeMgr.getOnArbitraryKeyOracle((String) locationWbo.getAttribute("id"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("unitTypesList", new ArrayList<>());
                }

                request.setAttribute("unitAreaID", request.getParameter("unitAreaID"));
                request.setAttribute("untStsExlRprt", unitStatus);
                request.setAttribute("searchBy", searchBy);
                request.setAttribute("unitTypeID", request.getParameter("unitTypeID"));
                request.setAttribute("projects", projectsLst);
                if(request.getParameter("excel") != null && request.getParameter("excel").equals("1")){
                    StringBuilder titleStr = new StringBuilder("Units By Project");
		    String headers[] = {"#", "Project Name", "Model", "Creation Time", "Unit Name", "Area", "Price", "Source", "Client Name", "Unit Status"};
                    String attributes[] = {"Number", "parentName", "modelName", "creationTime", "projectName", "area", "price", "fullName", "clientName", "statusNameStr"};
                    String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                    String[] headerStr = new String[1];
                    headerStr[0] = titleStr.toString();
                    HSSFWorkbook workBook = Tools.createExcelReport("Units By Project", headerStr, null, headers, attributes, dataTypes, new ArrayList(unitsVec));
                    Calendar c = Calendar.getInstance();
                    java.util.Date fileDate = c.getTime();
		    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    sdf.applyPattern("yyyy-MM-dd");
                    String reportDate = sdf.format(fileDate);
                    String filename = "Units By Project";
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
                }
                
                Vector mainProductsBuilding = new Vector();
                try {
                    mainProductsBuilding = projectMgr.getJoinTableUnitType();
                } catch (Exception e) {
                    
                }
                
                request.setAttribute("dataBuilding", mainProductsBuilding);  ////////////
                ArrayList<WebBusinessObject> brokersList1=userMgr.getAllBrokers();
                request.setAttribute("bokersList",userMgr.getAllBrokers());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 123:
                servedPage = "/docs/Search/search_for_project_unit.jsp";
                projectsArr = (String[]) request.getParameterValues("projects");
                searchByValue = null;
                clientStatusVec = null;
                status = " ";
                check = "check";
                projectMgr = ProjectMgr.getInstance();

                request.setAttribute("searchValue", "");
                unitsVec = new Vector();
                try {
                    empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                    
                    if (departmentWbo != null) {
                        if (projectsArr.length > 0) {
                            unitsVec = projectMgr.getAllUnitsForProjects((String) departmentWbo.getAttribute("projectID"), projectsArr);
                        } else {
                            unitsVec = projectMgr.getAllUnitsFromProject((String) departmentWbo.getAttribute("projectID"), null);
                        }
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("unitsVec", unitsVec);
                request.setAttribute("status", status);
                request.setAttribute("check", check);
                try {
                    paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                    request.setAttribute("paymentPlace", paymentPlace);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                lastFilter = "SearchServlet?op=SearchForAllUnits";
                session.setAttribute("lastFilter", lastFilter);

                topMenu = new Hashtable();
                tempVec = new Vector();
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

                projectMgr = ProjectMgr.getInstance();
                projectsLst = null;
                try {
                    projectsLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                    if (projectsLst != null && !projectsLst.isEmpty()) {
                        ArrayList<WebBusinessObject> prjZone = new ArrayList<WebBusinessObject>();
                        for (int index = 0; index < projectsLst.size(); index++) {
                            prjZone = projectMgr.getPrjZone(projectsLst.get(index).getAttribute("projectID").toString());
                            if (prjZone != null && !prjZone.isEmpty()) {
                                projectsLst.get(index).setAttribute("prjZoneName", projectMgr.getPrjZoneName(prjZone.get(0).getAttribute("zoneID").toString()).get(0).getAttribute("zoneName"));
                            }
                        }
                    }
                    
                    request.setAttribute("projects", projectsLst);
                } catch (Exception ex) {
                    System.out.println("Get Projects List Exception = " + ex.getMessage());
                }

                request.getSession().setAttribute("topMenu", topMenu);

                request.setAttribute("searchBy", "unitNo");
                request.setAttribute("searchValue", "");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 124:
                servedPage = "/docs/Search/search_for_client_by_history.jsp";

                projectMgr = ProjectMgr.getInstance();
                projectList = new ArrayList<WebBusinessObject>();
                try {
                    projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("projectList", projectList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 125:
                issueID = request.getParameter("issueID");
                servedPage = "/docs/requests/list_of_all_extractionWorkItems.jsp";
                String[] checkTemp = request.getParameterValues("check");
                RequestItemsDetailsMgr requestItemsDetailsMgr = RequestItemsDetailsMgr.getInstance();
                if (checkTemp != null && checkTemp.length > 0) {
                    String[] quantityTemp = request.getParameterValues("quantity");
                    String[] idTemp = request.getParameterValues("id");
                    String[] priceTemp = request.getParameterValues("price");
                    String[] discountTemp = request.getParameterValues("discount");
                    String[] totalTemp = request.getParameterValues("total");
                    ArrayList<String> quantityArr = new ArrayList<>();
                    ArrayList<String> idArr = new ArrayList<>();
                    ArrayList<String> priceArr = new ArrayList<>();
                    ArrayList<String> discountArr = new ArrayList<>();
                    ArrayList<String> totalArr = new ArrayList<>();
                    for (String checkIndex : checkTemp) {
                        quantityArr.add(quantityTemp[Integer.parseInt(checkIndex)]);
                        idArr.add(idTemp[Integer.parseInt(checkIndex)]);
                        priceArr.add(priceTemp[Integer.parseInt(checkIndex)]);
                        discountArr.add(discountTemp[Integer.parseInt(checkIndex)]);
                        totalArr.add(totalTemp[Integer.parseInt(checkIndex)]);
                    }
                    
                    requestItemsDetailsMgr.updateRequestItems(idArr.toArray(), quantityArr.toArray(), priceArr.toArray(),
                            discountArr.toArray(), totalArr.toArray());
                }
                
                issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                requests = issueByComplaintMgr.getIssueComplaintsByComments(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY, issueID);
                for (int i = 0; i < requests.size(); i++) {
                    List<WebBusinessObject> requestedItems = requestItemsDetailsMgr.getByIssueId((String) requests.get(i).getAttribute("issue_id"));
                    List<WebBusinessObject> requestedItems2 = requestItemsDetailsMgr.getRequistItemsByIssueId((String) requests.get(i).getAttribute("issue_id"));
                    requests.get(i).setAttribute("requestedItems", requestedItems);
                    requests.get(i).setAttribute("requestedItems2", requestedItems2);
                    WebBusinessObject issue = IssueMgr.getInstance().getOnSingleKey((String) requests.get(i).getAttribute("issue_id"));
                    requests.get(i).setAttribute("issue", issue);
                }
                
                wbo = this.issueMgr.getOnSingleKey(issueID);
                if (wbo != null && wbo.getAttribute("clientId") != null) {
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey((String) wbo.getAttribute("clientId")));
                }
                
                request.setAttribute("businessID", request.getParameter("businessID"));
                request.setAttribute("businessIDbyDate", request.getParameter("businessIDbyDate"));
                request.setAttribute("showInvoice", request.getParameter("showInvoice"));
                request.setAttribute("data", requests);
                request.setAttribute("issueID", issueID);
                List allItems = projectMgr.getAllWorkItems();
                List units = ExpenseItemMgr.getInstance().getMeasurementUnits("unit");
                request.setAttribute("workItemsList", allItems);
                request.setAttribute("measuerUnits", units);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 126:
                servedPage = "/docs/Search/search_for_call_requests_life.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 127:
                servedPage = "/docs/Search/search_for_call_requests_life.jsp";

                issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();

                data = new Vector();

                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                dateParser = new DateParser();
                beg = dateParser.formatSqlDate(beDate);
                en = dateParser.formatSqlDate(enDate);
                beginD = new java.sql.Date(beg.getTime());
                endD = new java.sql.Date(en.getTime());

                ticketStatus = request.getParameter("ticketStatus");
                compStatus = request.getParameter("compStatus");
                if (compStatus == null || compStatus.equalsIgnoreCase("all")) {
                    compStatus = "";
                }
                
                if (ticketStatus == null || ticketStatus.equalsIgnoreCase("all")) {
                    ticketStatus = "";
                }

                empRelationMgr = EmpRelationMgr.getInstance();
                managerWbo = empRelationMgr.getOnSingleKey("key2", (String) persistentUser.getAttribute("userId"));
                departmentID = "";
                String departmentCode = "";
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) persistentUser.getAttribute("userId"));
                }
                
                if (departmentWbo != null) {
                    departmentID = (String) departmentWbo.getAttribute("projectID");
                    departmentCode = (String) departmentWbo.getAttribute("eqNO");
                }
                
                try {
                    data = issueByComplaintUniqueMgr.getAllCaseBetweenDatesForLifeReport(beginD, endD, compStatus, ticketStatus, departmentID, departmentCode);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                request.setAttribute("compStatus", compStatus);
                request.setAttribute("ticketStatus", ticketStatus);
                this.forwardToServedPage(request, response);
                break;

            case 128:
                servedPage = "/docs/Search/search_for_requests_life.jsp";
                if (request.getParameter("beginDate") != null) {
                    issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                    beDate = request.getParameter("beginDate");
                    enDate = request.getParameter("endDate");
                    dateParser = new DateParser();
                    beg = dateParser.formatSqlDate(beDate);
                    en = dateParser.formatSqlDate(enDate);
                    beginD = new java.sql.Date(beg.getTime());
                    endD = new java.sql.Date(en.getTime());
                    request.setAttribute("data", issueByComplaintUniqueMgr.getAllCaseBetweenDatesByDepCode(beginD, endD, "FINSH"));
                    request.setAttribute("endDate", enDate);
                    request.setAttribute("beginDate", beDate);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 129:
                issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                metaMgr = MetaDataMgr.getInstance();

                String flag, statusEndDate, slaDay, slaHour, slaValue;

                Calendar cal = Calendar.getInstance();

                data = new Vector();

                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                dateParser = new DateParser();
                beg = dateParser.formatSqlDate(beDate);
                en = dateParser.formatSqlDate(enDate);
                beginD = new java.sql.Date(beg.getTime());
                endD = new java.sql.Date(en.getTime());

                ticketStatus = request.getParameter("ticketStatus");
                compStatus = request.getParameter("compStatus");
                if (compStatus == null || compStatus.equalsIgnoreCase("all")) {
                    compStatus = "";
                }
                
                if (ticketStatus == null || ticketStatus.equalsIgnoreCase("all")) {
                    ticketStatus = "";
                }

                empRelationMgr = EmpRelationMgr.getInstance();
                managerWbo = empRelationMgr.getOnSingleKey("key2", (String) persistentUser.getAttribute("userId"));
                departmentID = "";
                departmentCode = "";
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) persistentUser.getAttribute("userId"));
                }
                
                if (departmentWbo != null) {
                    departmentID = (String) departmentWbo.getAttribute("projectID");
                    departmentCode = (String) departmentWbo.getAttribute("eqNO");
                }
                
                try {
                    data = issueByComplaintUniqueMgr.getAllCaseBetweenDatesForLifeReport(beginD, endD, compStatus, ticketStatus, departmentID, departmentCode);

                    if (data != null && data.size() > 0) {
                        for (int i = 0; i < data.size(); i++) {
                            wbo = (WebBusinessObject) data.get(i);

                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            WebBusinessObject clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());

                            //get client complaint - issue status
                            Vector<WebBusinessObject> complaintStatusVec = issueStatusMgr.getAllStatusForObject(clientCompWbo.getAttribute("id").toString());
                            WebBusinessObject firstStatus = new WebBusinessObject();
                            WebBusinessObject lastStatus = new WebBusinessObject();

                            firstStatus = (WebBusinessObject) complaintStatusVec.get(0);
                            String statusStartDate = firstStatus.getAttribute("beginDate").toString();

                            wbo.setAttribute("startDate", statusStartDate);
                            if (complaintStatusVec.size() > 1) {
                                lastStatus = (WebBusinessObject) complaintStatusVec.get(complaintStatusVec.size() - 1);

                                String statusType = lastStatus.getAttribute("statusName").toString();
                                if (statusType.equals("7")) {
                                    flag = "old";
                                    statusEndDate = lastStatus.getAttribute("beginDate").toString();
                                } else {
                                    flag = "today";
                                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    cal = Calendar.getInstance();
                                    statusEndDate = dateFormat.format(cal.getTime());
                                }
                            } else {
                                flag = "today";
                                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                cal = Calendar.getInstance();
                                statusEndDate = dateFormat.format(cal.getTime());
                            }

                            wbo.setAttribute("endDate", statusEndDate);
                            //get the diffrenence between end and start date
                            DateAndTimeControl dtControl = new DateAndTimeControl();
                            Vector duration = dtControl.calculateDateDiff(statusStartDate, statusEndDate);
                            WebBusinessObject slaWboTemp = clientComplaintsSLAMgr.getOnSingleKey((String) wbo.getAttribute("clientComId"));
                            if (slaWboTemp != null) {
                                slaValue = (String) slaWboTemp.getAttribute("executionPeriod");
                                String slaCreationTime = (String) slaWboTemp.getAttribute("creationTime");
                                Vector slaDuration = dtControl.calculateDateDiff(statusStartDate, slaCreationTime);
                                slaDay = slaDuration.get(0).toString();
                                slaHour = slaDuration.get(1).toString();
                            } else {
                                slaValue = "0";
                                slaDay = "--";
                                slaHour = "--";
                            }

                            wbo.setAttribute("slaValue", slaValue);
                            wbo.setAttribute("slaDay", slaDay);
                            wbo.setAttribute("slaHour", slaHour);
                            wbo.setAttribute("consDay", duration.get(0).toString());
                            wbo.setAttribute("consHour", duration.get(1).toString());
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }

                HashMap parameters = new HashMap();
                parameters.put("fromDate", beDate.toString());
                parameters.put("toDate", enDate.toString());

                Tools.createPdfReportQPMTime("ConsumedTimeQPM", parameters, data, getServletContext(), response, request, (String) metaMgr.getLogos().get("headReport3"));
                break;
                
            case 130:
                servedPage = "/docs/Search/search_for_my_complaints.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 131:
                servedPage = "/docs/Search/search_for_my_complaints.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                dateParser = new DateParser();
                beg = dateParser.formatSqlDate(beDate);
                en = dateParser.formatSqlDate(enDate);
                beginD = new java.sql.Date(beg.getTime());
                endD = new java.sql.Date(en.getTime());
                data = new Vector();
                issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                compStatus = request.getParameter("compStatus");
                ticketStatus = request.getParameter("ticketStatus");
                if (compStatus == null || compStatus.equalsIgnoreCase("all")) {
                    compStatus = "";
                }
                
                if (ticketStatus == null || ticketStatus.equalsIgnoreCase("all")) {
                    ticketStatus = "";
                }
                
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                empRelationMgr = EmpRelationMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                departmentID = "";
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                
                if (departmentWbo != null) {
                    departmentID = (String) departmentWbo.getAttribute("projectID");
                }
                
                try {
                    data = issueByComplaintUniqueMgr.getAllCaseBetweenDatesByStatus(beginD, endD, compStatus, ticketStatus,
                            departmentID, (String) persistentUser.getAttribute("userId"), null);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                request.setAttribute("compStatus", compStatus);
                request.setAttribute("ticketStatus", ticketStatus);
                this.forwardToServedPage(request, response);
                break;
                
            case 132:
                servedPage = "/docs/Search/search_for_my_activity.jsp";
                issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
                try {
                    request.setAttribute("statusTypes", issueByComplaintAllCaseMgr.getStatusTypes());
                } catch (NoSuchColumnException ex) {
                    request.setAttribute("statusTypes", new ArrayList<WebBusinessObject>());
                }
                
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                String typeExcel = request.getParameter("excel");
                if (beDate != null && enDate != null) {
                    dateParser = new DateParser();
                    beg = dateParser.formatSqlDate(beDate);
                    en = dateParser.formatSqlDate(enDate);
                    beginD = new java.sql.Date(beg.getTime());
                    endD = new java.sql.Date(en.getTime());
                    issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                    compStatus = request.getParameter("compStatus");
                    if (compStatus == null || compStatus.equalsIgnoreCase("all")) {
                        compStatus = "";
                    }
                    
                    dataList = issueByComplaintUniqueMgr.getMyActivityInPeriod(beginD, endD, compStatus, (String) persistentUser.getAttribute("userId"));
                    request.setAttribute("data", dataList);
                    request.setAttribute("endDate", enDate);
                    request.setAttribute("beginDate", beDate);
                    request.setAttribute("compStatus", compStatus);
                    
                if (typeExcel != null) {    
                StringBuilder titleStr = new StringBuilder("My Work");
                String headers[] = {"#", "Client Name", "Request", "Source", "Responsible", "Date"};
                String attributes[] = {"Number", "customerName", "compSubject", "createdByName", "CURRENT_OWNER","beginDate"};
                String dataTypes[] = {"", "String", "String", "String", "String", "String", "String"};
                String[] headerStr = new String[1];
                headerStr[0] = titleStr.toString();
                HSSFWorkbook workBook = Tools.createExcelReport("Units By Project", headerStr, null, headers, attributes, dataTypes, new ArrayList(dataList));
                Calendar c = Calendar.getInstance();
                java.util.Date fileDate = c.getTime();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
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
                }
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 133:
                servedPage = "/docs/sales/search_my_clients.jsp";
                check = null;
                status = " ";
                // start
                out = response.getWriter();
                searchBy = request.getParameter("searchBy");
                if (searchBy != null) {
                    ArrayList<WebBusinessObject> myClientsList = EmployeeView2Mgr.getInstance().getMyClients((String) loggedUser.getAttribute("userId"), null, null);
                    ArrayList<String> clientsIDs = new ArrayList<>();
                    for (WebBusinessObject clientTemp : myClientsList) {
                        clientsIDs.add((String) clientTemp.getAttribute("customerId"));
                    }
                    
                    searchByValue = null;
                    wbo = new WebBusinessObject();
                    clientMgr = ClientMgr.getInstance();
                    clientsVec = new Vector();
                    result = new WebBusinessObject();
                    if (searchBy.equalsIgnoreCase("clientNo")) {
                        searchByValue = request.getParameter("valueSearch");
                        request.setAttribute("clientNo", searchByValue);
                        try {
                            empRelationMgr = EmpRelationMgr.getInstance();
                            projectMgr = ProjectMgr.getInstance();
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                            departmentWbo = null;
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
                                
                                if (clientsVec != null && !clientsVec.isEmpty()) {
                                    wbo = null;
                                    ArrayList<WebBusinessObject> clients = new ArrayList<>(clientsVec);
                                    for (int i = clients.size() - 1; i >= 0; i--) {
                                        if (!clientsIDs.contains((String) clients.get(i).getAttribute("id"))) {
                                            clients.remove(i);
                                        }
                                    }
                                    
                                    request.setAttribute("data", clients);
                                } else {
                                    clientsVec = null;
                                    status = "error";
                                    wbo = null;
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
                        request.setAttribute("page", servedPage);
                        request.setAttribute("clientsVec", clientsVec);
                        this.forwardToServedPage(request, response);
                        break;
                    } else if (searchBy.equalsIgnoreCase("clientTel")) {
                        searchByValue = request.getParameter("valueSearch");
                        request.setAttribute("clientTel", searchByValue);
                        try {
                            wbo = clientMgr.getOnSingleKey("key3", searchByValue.trim());
                            if (wbo != null && clientsIDs.contains((String) wbo.getAttribute("id"))) {
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
                        searchByValue = request.getParameter("valueSearch");
                        request.setAttribute("clientMobile", searchByValue);
                        try {
                            wbo = clientMgr.getOnSingleKey("key4", searchByValue.trim());
                            if (wbo != null && clientsIDs.contains((String) wbo.getAttribute("id"))) {
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
                        searchByValue = request.getParameter("valueSearch");
                        try {
                            cm = ClientMgr.getInstance();
                            empRelationMgr = EmpRelationMgr.getInstance();
                            projectMgr = ProjectMgr.getInstance();
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                            departmentWbo = null;
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
                                ArrayList<WebBusinessObject> clients = new ArrayList<>(clientsVec);
                                for (int i = clients.size() - 1; i >= 0; i--) {
                                    if (!clientsIDs.contains((String) clients.get(i).getAttribute("id"))) {
                                        clients.remove(i);
                                    }
                                }
                                
                                request.setAttribute("data", clients);
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
                        searchByValue = request.getParameter("searchValue");
                        try {
                            cm = ClientMgr.getInstance();
                            empRelationMgr = EmpRelationMgr.getInstance();
                            projectMgr = ProjectMgr.getInstance();
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                            departmentWbo = null;
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
                                ArrayList<WebBusinessObject> clients = new ArrayList<>(clientsVec);
                                for (int i = clients.size() - 1; i >= 0; i--) {
                                    if (!clientsIDs.contains((String) clients.get(i).getAttribute("id"))) {
                                        clients.remove(i);
                                    }
                                }
                                
                                request.setAttribute("data", clients);
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
                    }
                }
                
                // end
                request.setAttribute("page", servedPage);
                request.setAttribute("check", check);
                request.setAttribute("status", status);
                this.forwardToServedPage(request, response);
                break;

            case 134:
                //servedPage = "/docs/Search/search_for_new_client.jsp";
                servedPage = "/docs/Search/search_for_new_client_grouped.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                senderID = request.getParameter("senderID");
                String groupID = request.getParameter("groupID");
                description = request.getParameter("description") != null ? request.getParameter("description") : "";
                reportType = request.getParameter("reportType");
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
                
                if (beginDate != null && endDate != null) {
                    String groupIDTemp;
                    issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                    try {
                        ArrayList<WebBusinessObject> resultList;
                        if (groupID != null && !groupID.isEmpty()) {
                            groupIDTemp = "'" + groupID + "'";
                        } else {
                            if (groups.isEmpty()) {
                                groupIDTemp = "";
                            } else {
                                StringBuilder groupStr = new StringBuilder();
                                for (WebBusinessObject tempWbo : groups) {
                                    groupStr.append("'").append(tempWbo.getAttribute("groupID")).append("',");
                                }
                                
                                groupIDTemp = groupStr.substring(0, groupStr.length() - 1);
                            }
                        }
                        
                        String dataJson = null;
                        if ("detail".equals(reportType)) {
                            resultList = issueByComplaintUniqueMgr.getNewClientsBetweenDatesGrouped(beginDate, endDate, description, senderID, groupIDTemp);
                            dataJson = Tools.getJSONArrayAsString(resultList);
                        } else {
                            resultList = issueByComplaintUniqueMgr.getNewClientsBetweenDatesGroupedCount(beginDate, endDate, description, senderID, groupIDTemp);
                            dataJson = Tools.getJSONArrayAsValuesString(resultList);
                        }
                        
                        request.setAttribute("data", dataJson);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    
                    request.setAttribute("beginDate", beginDate);
                    request.setAttribute("endDate", endDate);
                    request.setAttribute("description", description);
                    request.setAttribute("senderID", senderID);
                    request.setAttribute("groupID", groupID);
                    request.setAttribute("reportType", reportType);
                }

                lastFilter = "SearchServlet?op=searchNewClientsGroup&beginDate=" + beginDate + "&endDate=" + endDate + "&description=" + description
                        + "&senderID=" + senderID + "&groupID=" + groupID;
                session.setAttribute("lastFilter", lastFilter);

                topMenu = new Hashtable();
                tempVec = new Vector();
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
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("usersList", new ArrayList<WebBusinessObject>(userMgr.getCashedTable()));
                request.setAttribute("groupsList", groups);
                request.setAttribute("meetings", projectMgr.getMeetingProjects());
                request.setAttribute("callResults", projectMgr.getCallResultsProjects());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 135:
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                senderID = request.getParameter("senderID");
                groupID = request.getParameter("groupID");
                description = request.getParameter("description") != null ? request.getParameter("description") : "";
                reportType = request.getParameter("reportType");
                userGroupCongMgr = UserGroupConfigMgr.getInstance();
                groupMgr = GroupMgr.getInstance();
                groups = new ArrayList<>();
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
                
                if (beginDate != null && endDate != null) {
                    issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
                    try {
                        ArrayList<WebBusinessObject> resultList;
                        if (groupID != null && !groupID.isEmpty()) {
                            groupID = "'" + groupID + "'";
                        } else {
                            if (groups.isEmpty()) {
                                groupID = "";
                            } else {
                                StringBuilder groupStr = new StringBuilder();
                                for (WebBusinessObject tempWbo : groups) {
                                    groupStr.append("'").append(tempWbo.getAttribute("groupID")).append("',");
                                }
                                
                                groupID = groupStr.substring(0, groupStr.length() - 1);
                            }
                        }
                        
                        if ("detail".equals(reportType)) {
                            resultList = issueByComplaintUniqueMgr.getNewClientsBetweenDatesGrouped(beginDate, endDate, description, senderID, groupID);
                        } else {
                            resultList = issueByComplaintUniqueMgr.getNewClientsBetweenDatesGroupedCount(beginDate, endDate, description, senderID, groupID);
                        }
                        
                        String headers[];
                        String attributes[];
                        String dataTypes[];
                        if ("detail".equals(reportType)) {
                            headers = new String[4];
                            headers[0] = "#";
                            headers[1] = "Group Name";
                            headers[2] = "Client Name";
                            headers[3] = "Source";
                            attributes = new String[4];
                            attributes[0] = "Number";
                            attributes[1] = "groupName";
                            attributes[2] = "customerName";
                            attributes[3] = "createdByName";
                            dataTypes = new String[4];
                            dataTypes[0] = "";
                            dataTypes[1] = "String";
                            dataTypes[2] = "String";
                            dataTypes[3] = "String";
                        } else {
                            headers = new String[3];
                            headers[0] = "#";
                            headers[1] = "Group Name";
                            headers[2] = "Client No.";
                            attributes = new String[3];
                            attributes[0] = "Number";
                            attributes[1] = "groupName";
                            attributes[2] = "clientNo";
                            dataTypes = new String[3];
                            dataTypes[0] = "";
                            dataTypes[1] = "String";
                            dataTypes[2] = "String";
                        }

                        String[] headerStr = new String[1];
                        headerStr[0] = "Clients_Data";
                        HSSFWorkbook workBook = Tools.createExcelReport("Clients", headerStr, null, headers, attributes, dataTypes, resultList);

                        Calendar c = Calendar.getInstance();
                        Date fileDate = c.getTime();
                        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                        String reportDate = df.format(fileDate);
                        String filename = "Clients" + reportDate;

                        ServletOutputStream servletOutputStream = response.getOutputStream();
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        try {
                            workBook.write(bos);
                        } finally {
                            bos.close();
                        }
                        
                        byte[] bytes = bos.toByteArray();
                        //                bytes = bos.toByteArray();

                        response.setContentType("application/vnd.ms-excel");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                        response.setContentLength(bytes.length);
                        servletOutputStream.write(bytes, 0, bytes.length);
                        servletOutputStream.flush();
                        servletOutputStream.close();
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                break;
                
            case 136:
                servedPage = "/docs/Search/accurate_search_for_unit.jsp";
                ArrayList<WebBusinessObject> areaList = new ArrayList<>();
                String areaID = request.getParameter("areaID");
                projectList = new ArrayList<>();
                projectID = request.getParameter("projectID");
                String unitArea = request.getParameter("unitArea");
                description = request.getParameter("description");
                if (request.getParameter("search") != null) {
                    request.setAttribute("unitsList", projectMgr.accurateUnitSearch(areaID, projectID, unitArea, description));
                }
                
                try {
                    //areaList = new ArrayList<>(projectMgr.getOnArbitraryKey("garea", "key6"));
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    loggegUserId = (String) loggedUser.getAttribute("userId");
                    areaList = new ArrayList<>(UserDistrictsMgr.getInstance().getOnArbitraryKey(loggegUserId, "key1"));

                    if (areaList == null || areaList.size() == 0) {
                        areaList = new ArrayList<>(projectMgr.getOnArbitraryKey("garea", "key6"));
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                if (areaID != null) {
                    if (areaID.equals("all")) {
                        projectList = new ArrayList<>(projectMgr.getProjectsInRegion(""));
                        if (request.getParameter("search") == null) {
                            projectID = "";
                        }
                    } else {
                        projectList = new ArrayList<>(projectMgr.getProjectsInRegion(areaID));
                    }
                } else {
                    projectList = new ArrayList<>();
                }
                
                request.setAttribute("areaList", areaList);
                request.setAttribute("projectList", projectList);
                request.setAttribute("areaID", areaID);
                request.setAttribute("projectID", projectID);
                request.setAttribute("unitArea", unitArea);
                request.setAttribute("description", description);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 137:
                servedPage = "docs/Search/jobOrderSearch.jsp";
                String busNo = request.getParameter("busNo");
                if (busNo != null && !busNo.isEmpty()) {
                    servedPage = "ClientServlet?op=clientDetailsOrder";

                    issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                    ArrayList<WebBusinessObject> jobOrder = issueByComplaintMgr.srchJobOrderByBusId(busNo);

                    request.setAttribute("clientId", jobOrder.get(0).getAttribute("clientID"));
                    request.setAttribute("issueId", jobOrder.get(0).getAttribute("compID"));
                    this.forward("/ClientServlet?op=clientDetailsOrder", request, response);
                } else {
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 138:
                servedPage = "/docs/Search/search_for_Boker_unit.jsp";

                projectsLst = null;

                clientMgr = ClientMgr.getInstance();

                String fromDate = request.getParameter("fromDate");
                String toDate = request.getParameter("toDate");
                String clientID = request.getParameter("clientID");

                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                java.sql.Date toDateD = null;
                java.sql.Date fromDateD = null;
                if (fromDate != null) {
                    fromDateD = dateParser.formatSqlDate(fromDate, jsDateFormat);
                }

                if (toDate != null) {
                    toDateD = dateParser.formatSqlDate(toDate, jsDateFormat);
                }

                try {
                    projectsLst = new ArrayList<WebBusinessObject>(clientMgr.getClientsBrokerProjects(fromDateD, toDateD, clientID));
                } catch (Exception ex) {
                    System.out.println("Get Clients Boker Projects List Exception = " + ex.getMessage());
                }

                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("clientID", request.getParameter("clientID"));
                request.setAttribute("page", servedPage);
                request.setAttribute("projects", projectsLst);
                this.forwardToServedPage(request, response);
                break;
                
            case 139:
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                managerWbo = EmpRelationMgr.getInstance().getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                }
                
                PDFTools pdfTolls = new PDFTools();

                parameters = new HashMap();
                parameters.put("DEPARTMENT_ID", departmentWbo.getAttribute("projectID"));
                parameters.put("MAIN_PROJ_ID", request.getParameter("mainProjID"));

                pdfTolls.generatePdfReport("GroupingReport", parameters, getServletContext(), response);
                break;
                
            case 140:
                unitvalue = request.getParameter("searchValue");
                projectsArr = request.getParameter("projects").split(",");
                unitStatus = request.getParameter("unitStatus");

                searchBy = request.getParameter("searchBy");
                searchValue = request.getParameter("searchValue");
                searchByValue = null;
                clientStatusVec = null;
                status = " ";
                check = "check";
                unitsVec = new Vector();
                projectMgr = ProjectMgr.getInstance();
                if (searchBy != null || searchValue != null) {
                    if ((searchBy != null && searchBy.equalsIgnoreCase("unitNo")) || searchValue != null) {
                        try {
                            request.setAttribute("searchValue", searchValue);
                            empRelationMgr = EmpRelationMgr.getInstance();
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                            if (managerWbo != null) {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                            } else {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                            }
                            
                            if (departmentWbo != null) {
                                if (projectsArr != null && projectsArr.length > 0) {
                                    unitsVec = projectMgr.getUnitsForProjects("1",unitvalue, (String) departmentWbo.getAttribute("projectID"), projectsArr, request.getParameter("unitTypeID"), request.getParameter("unitAreaID"), unitStatus);
                                } else {
                                    unitsVec = projectMgr.getUnitsFromProject("1",unitvalue, (String) departmentWbo.getAttribute("projectID"), request.getParameter("unitTypeID"), request.getParameter("unitAreaID"), unitStatus,(String) loggedUser.getAttribute("userId"));
                                }
                            }

                            lastFilter = "SearchServlet?op=getUnitByProject&searchBy=unitNo&searchValue=" + searchValue + " ";
                            session.setAttribute("lastFilter", lastFilter);

                            topMenu = new Hashtable();
                            tempVec = new Vector();
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
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex);
                        }
                    } else if (searchBy != null && searchBy.equalsIgnoreCase("parentName")) {
                        try {
                            request.setAttribute("searchValue", searchValue);
                            empRelationMgr = EmpRelationMgr.getInstance();
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                            if (managerWbo != null) {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                            } else {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                            }
                            
                            if (projectsArr.length > 0) {
                                unitsVec = projectMgr.getUnitsWithParentNameForProjs(unitvalue, (String) departmentWbo.getAttribute("projectID"), projectsArr, request.getParameter("unitTypeID"), unitStatus);
                            } else {
                                unitsVec = projectMgr.getUnitsWithParentName(searchValue, (String) departmentWbo.getAttribute("projectID"), request.getParameter("unitTypeID"), unitStatus);
                            }
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex);
                        }
                    }
                    
                    request.setAttribute("unitsVec", unitsVec);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);
                    try {
                        paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                        request.setAttribute("paymentPlace", paymentPlace);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                projectMgr = ProjectMgr.getInstance();
                projectsLst = new ArrayList<>();
                try {
                    projectsLst = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    System.out.println("Get Projects List Exception = " + ex.getMessage());
                }

                if (projectsLst != null && !projectsLst.isEmpty()) {
                    ArrayList<WebBusinessObject> prjZone = new ArrayList<>();
                    for (WebBusinessObject projectWbo : projectsLst) {
                        prjZone = projectMgr.getPrjZone(projectWbo.getAttribute("projectID").toString());
                        if (prjZone != null && !prjZone.isEmpty()) {
                            projectWbo.setAttribute("prjZoneName", projectMgr.getPrjZoneName(prjZone.get(0).getAttribute("zoneID").toString()).get(0).getAttribute("zoneName"));
                        }
                    }
                }
                
                unitTypeMgr = UnitTypeMgr.getInstance();
                locationWbo = LocationTypeMgr.getInstance().getOnSingleKey("key1", "RES-UNIT");
                try {
                    request.setAttribute("unitTypesList", new ArrayList<>(unitTypeMgr.getOnArbitraryKeyOracle((String) locationWbo.getAttribute("id"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("unitTypesList", new ArrayList<>());
                }
                
                StringBuilder titleStr = new StringBuilder("Units By Project");
                String headers[] = {"#", "Project Name", "Model", "Creation Time", "Unit Name", "Area", "Price", "Source", "Client Name", "Unit Status"};
                String attributes[] = {"Number", "tradeName", "Number", "tradeName", "Number", "tradeName", "Number", "tradeName", "Number", "tradeName"};
                String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                String[] headerStr = new String[1];
                headerStr[0] = titleStr.toString();
                HSSFWorkbook workBook = Tools.createExcelReport("Units By Project", headerStr, null, headers, attributes, dataTypes, new ArrayList(unitsVec));
                Calendar c = Calendar.getInstance();
                java.util.Date fileDate = c.getTime();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
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
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 141:
                servedPage = "/docs/Search/viewProjectUnits.jsp";

                projectsArr = (String[]) request.getParameterValues("prjID");
                
                unitsVec = new Vector();
                projectMgr = ProjectMgr.getInstance();
                
                try {
                    if (projectsArr != null && projectsArr.length > 0 && !projectsArr[0].isEmpty()) {
                        unitsVec = projectMgr.getUnitsForSpecificProject(projectsArr);
                    } else {
                        unitsVec = projectMgr.getUnitsForSpecificProject(null);
                    }
                    request.setAttribute("totalPrice", unitsVec.stream().mapToLong(w -> (Long.valueOf(((WebBusinessObject) w).getAttribute("price").toString()))).sum() + "");
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                }//projectsArr[0]
                request.setAttribute("prjNM", projectMgr.getOnSingleKey(projectsArr[0]).getAttribute("projectName"));
                request.setAttribute("unitsVec", unitsVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break; 
                
            case 142:    
                servedPage = "/docs/Search/myClientsWithDesiredSpaces.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                dateParser = new DateParser();
                if(beDate != null && enDate != null){
                    beg = dateParser.formatSqlDate(beDate);
                    en = dateParser.formatSqlDate(enDate); 
                    beginD = new java.sql.Date(beg.getTime());
                    endD = new java.sql.Date(en.getTime());
                    
                    data = new Vector();
                    clientProductMgr = ClientProductMgr.getInstance();
                    data = clientProductMgr.getMyClientsWithWidth((String) loggedUser.getAttribute("userId"),beginD, endD);
                    ArrayList<WebBusinessObject> ratioData = clientProductMgr.getMyClientProductWidthRatio((String) loggedUser.getAttribute("userId"),beginD, endD);
                    String complaintCountStr = null;
                    int totalCount = 0;
                    WebBusinessObject widthRationWbo = new WebBusinessObject();
                    dataList = new ArrayList();

                    // populate series data map
                    for (int i = 0; i < ratioData.size(); i++) {
                        dataEntryMap = new HashMap();
                        widthRationWbo = (WebBusinessObject) ratioData.get(i);
                        complaintCountStr = (String) widthRationWbo.getAttribute("total");
                        totalCount += Integer.parseInt(complaintCountStr);
                        dataEntryMap.put("name", widthRationWbo.getAttribute("unitWidth"));
                        dataEntryMap.put("y", new Integer(complaintCountStr));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalCount", totalCount);
                    request.setAttribute("jsonText", jsonText);
                    request.setAttribute("data", data);
                }
                
                request.setAttribute("page", servedPage);
                request.setAttribute("endDate", enDate);
                request.setAttribute("beginDate", beDate);
                this.forwardToServedPage(request, response);
                break;  
                
            case 143:
                servedPage = "/docs/Search/myClientsViews.jsp";
                beDate = request.getParameter("fromDate");
                enDate = request.getParameter("toDate");
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (enDate == null) {
                        enDate = sdf.format(c.getTime());
                    }

                if (beDate == null) {
                    c.add(Calendar.MONTH, -1);
                    beDate = sdf.format(c.getTime());
                }
                if(beDate != null && enDate != null){
                    java.sql.Date date1 = dateParser.formatSqlDate(beDate, jsDateFormat);
                    java.sql.Date date2 = dateParser.formatSqlDate(enDate, jsDateFormat);
                    clientProductMgr = ClientProductMgr.getInstance();
                    ArrayList<WebBusinessObject> clntsViewsLst = new ArrayList<WebBusinessObject>();
                    clntsViewsLst = clientProductMgr.viewMyViewsUnits(session, date1, date2);
                    request.setAttribute("clntsViewsLst", clntsViewsLst);
                }
                request.setAttribute("beDate", beDate);
                request.setAttribute("enDate", enDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 144:
                servedPage = "/docs/Search/myVewsForEachClient.jsp";
                beDate = request.getParameter("fromDate");
                enDate = request.getParameter("toDate");
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (enDate == null) {
                        enDate = sdf.format(c.getTime());
                    }

                if (beDate == null) {
                    c.add(Calendar.MONTH, -1);
                    beDate = sdf.format(c.getTime());
                }
                if(beDate != null && enDate != null){
                    java.sql.Date date1 = dateParser.formatSqlDate(beDate, jsDateFormat);
                    java.sql.Date date2 = dateParser.formatSqlDate(enDate, jsDateFormat);
                    clientProductMgr = ClientProductMgr.getInstance();
                    ArrayList<WebBusinessObject> clntsViewsLst = new ArrayList<WebBusinessObject>();
                    clntsViewsLst = clientProductMgr.viewMyViewsUnits(session, date1, date2);
                    request.setAttribute("clntsViewsLst", clntsViewsLst);
                }
                request.setAttribute("beDate", beDate);
                request.setAttribute("enDate", enDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;   
                
            case 145:
                servedPage = "/docs/Search/clinetsViewsForEachUnit.jsp";
                beDate = request.getParameter("fromDate");
                enDate = request.getParameter("toDate");
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (enDate == null) {
                        enDate = sdf.format(c.getTime());
                    }

                if (beDate == null) {
                    c.add(Calendar.MONTH, -1);
                    beDate = sdf.format(c.getTime());
                }
                if(beDate != null && enDate != null){
                    java.sql.Date date1 = dateParser.formatSqlDate(beDate, jsDateFormat);
                    java.sql.Date date2 = dateParser.formatSqlDate(enDate, jsDateFormat);
                    clientProductMgr = ClientProductMgr.getInstance();
                    ArrayList<WebBusinessObject> clntsViewsLst = new ArrayList<WebBusinessObject>();
                    clntsViewsLst = clientProductMgr.viewClientsViewsUnits(date1, date2, "true".equals(request.getParameter("hasVisits")),
                            request.getParameter("minArea"), request.getParameter("maxArea"));
                    request.setAttribute("clntsViewsLst", clntsViewsLst);
                }
                request.setAttribute("beDate", beDate);
                request.setAttribute("enDate", enDate);
                request.setAttribute("hasVisits", request.getParameter("hasVisits"));
                request.setAttribute("minArea", request.getParameter("minArea"));
                request.setAttribute("maxArea", request.getParameter("maxArea"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;    
             
            case 146:
                servedPage = "/docs/Search/eachClientViews.jsp";
                beDate = request.getParameter("fromDate");
                enDate = request.getParameter("toDate");
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (enDate == null) {
                        enDate = sdf.format(c.getTime());
                    }

                if (beDate == null) {
                    c.add(Calendar.MONTH, -1);
                    beDate = sdf.format(c.getTime());
                }
                if(beDate != null && enDate != null){
                    java.sql.Date date1 = dateParser.formatSqlDate(beDate, jsDateFormat);
                    java.sql.Date date2 = dateParser.formatSqlDate(enDate, jsDateFormat);
                    clientProductMgr = ClientProductMgr.getInstance();
                    ArrayList<WebBusinessObject> clntsViewsLst = new ArrayList<WebBusinessObject>();
                    clntsViewsLst = clientProductMgr.viewClientsViewsUnits(date1, date2, "true".equals(request.getParameter("hasVisits")),
                            request.getParameter("minArea"), request.getParameter("maxArea"));
                    request.setAttribute("clntsViewsLst", clntsViewsLst);
                }
                request.setAttribute("beDate", beDate);
                request.setAttribute("enDate", enDate);
                request.setAttribute("hasVisits", request.getParameter("hasVisits"));
                request.setAttribute("minArea", request.getParameter("minArea"));
                request.setAttribute("maxArea", request.getParameter("maxArea"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break; 
            case 147:
                servedPage = "/docs/reports/unit_delivery.jsp";
                ArrayList<WebBusinessObject> unitsArr = new ArrayList<>();
                projectMgr = ProjectMgr.getInstance();
                if (request.getParameter("projectID") != null) {
                    empRelationMgr = EmpRelationMgr.getInstance();
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) persistentUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) persistentUser.getAttribute("userId"));
                    }
                    if (departmentWbo != null) {
                        unitsArr = projectMgr.getUnitDelivery((String) departmentWbo.getAttribute("projectID"), request.getParameter("projectID"));
                    }
                    request.setAttribute("unitsArr", unitsArr);
                    request.setAttribute("projectID", request.getParameter("projectID"));
                }
                projectMgr = ProjectMgr.getInstance();
                projectsLst = new ArrayList<>();
                try {
                    projectsLst = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (Exception ex) {
                    System.out.println("Get Projects List Exception = " + ex.getMessage());
                }
                request.setAttribute("projects", projectsLst);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            
            case 148:
                servedPage = "/docs/reports/search_for_unit_between_dates.jsp";
                beDate = request.getParameter("fromDate");
                enDate = request.getParameter("toDate");
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (enDate == null) {
                        enDate = sdf.format(c.getTime());
                    }

                if (beDate == null) {
                    c.add(Calendar.MONTH, -1);
                    beDate = sdf.format(c.getTime());
                }
                unitsVec = new Vector();
                if(beDate != null && enDate != null){
                    empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    if (departmentWbo != null) {
                        try {
                            unitsVec = projectMgr.getUnitsBetweenTwoDates(beDate, enDate,  (String) departmentWbo.getAttribute("projectID"), null, 
                                    request.getParameter("minArea"), request.getParameter("maxArea"));
                        } catch (NoUserInSessionException ex) {
                            java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                request.setAttribute("unitsVec", unitsVec);
                request.setAttribute("beDate", beDate);
                request.setAttribute("enDate", enDate);
                request.setAttribute("minArea", request.getParameter("minArea"));
                request.setAttribute("maxArea", request.getParameter("maxArea"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 149:
                beDate = request.getParameter("fromDate");
                enDate = request.getParameter("toDate");
                unitStatus = request.getParameter("unitStatus");
                unitsVec = new Vector();
                
                if(beDate != null && enDate != null){
                    empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    if (departmentWbo != null) {
                        try {
                            unitsVec = projectMgr.getUnitsBetweenTwoDates(beDate, enDate,  (String) departmentWbo.getAttribute("projectID"), unitStatus, null, null);
                        } catch (NoUserInSessionException ex) {
                            java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                titleStr = new StringBuilder("Units By Project");
                String headers1[] = {"#", "Project Name", "Model", "Creation Time", "Unit Name", "Area", "Price", "Source", "Client Name", "Unit Status"};
                String attributes1[] = {"Number", "parentName", "modelName", "creationTime", "projectName", "area", "price", "fullName", "clientName", "statusNameStr"};
                String dataTypes1[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                String[] headerStr1 = new String[1];
                headerStr1[0] = titleStr.toString();
                workBook = Tools.createExcelReport("Units By Project", headerStr1, null, headers1, attributes1, dataTypes1, new ArrayList(unitsVec));
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                sdf.applyPattern("yyyy-MM-dd");
                filename = "Units By Project";
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
            case 150:
                servedPage = "/docs/Search/my_clients_with_no_wish.jsp";
                beDate = request.getParameter("beginDate");
                enDate = request.getParameter("endDate");
                if (beDate != null && enDate != null) {
                    dateParser = new DateParser();
                    beg = dateParser.formatSqlDate(beDate);
                    en = dateParser.formatSqlDate(enDate);
                    beginD = new java.sql.Date(beg.getTime());
                    endD = new java.sql.Date(en.getTime());
                    reportData = clientMgr.getMyClientsWithNoWish(beginD, endD, "true".equals(request.getParameter("hasVisits")),
                            (String) persistentUser.getAttribute("userId"));
                    request.setAttribute("data", reportData);
                    request.setAttribute("endDate", enDate);
                    request.setAttribute("beginDate", beDate);
                    request.setAttribute("hasVisits", request.getParameter("hasVisits"));
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 151:
                servedPage="/docs/client/clientWithLegalDispute.jsp";
                ArrayList<WebBusinessObject> clientsList=clientMgr.getClientsWithLegalDispute();
                request.setAttribute("clientList", clientsList);
                 request.setAttribute("page", servedPage);
                 this.forwardToServedPage(request, response);
               
                break;
         case 152:
                     out = response.getWriter();
                    String  clientId=request.getParameter("clientID");
                       String status1=" ";
                     try{
                       status1= clientMgr.ReleaseClientLegalDispute(persistentUser,clientId,"UL");
                     }catch(Exception exq){
                         status1="none";
                     }
                     WebBusinessObject statusWbo=new WebBusinessObject();
                     statusWbo.setAttribute("status", status1);
                     out.write(Tools.getJSONObjectAsString(statusWbo));
                    break;
         case 153:
             servedPage = "/docs/Search/search_for_soldProject_unit.jsp";

                 projectsLst = null;
                
                projectMgr = ProjectMgr.getInstance();
                try {
                    userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                    projectsLst = new ArrayList(userCompanyProjectsMgr.getAllProjectsByUserId((String) persistentUser.getAttribute("userId")));
                    if (projectsLst.isEmpty()) {
                        projectsLst = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4"));
                    }
                } catch (Exception ex) {
                    System.out.println("Get Projects List Exception = " + ex.getMessage());
                }
                
                 AreaList=projectMgr.getUnitsArea();
                
                 request.setAttribute("AreaList",AreaList);
                if (projectsLst != null && !projectsLst.isEmpty()) {
                    ArrayList<WebBusinessObject> prjZone = new ArrayList<WebBusinessObject>();
                    for (int index = 0; index < projectsLst.size(); index++) {
                        prjZone = projectMgr.getPrjZone(projectsLst.get(index).getAttribute("projectID").toString());
                        if (prjZone != null && !prjZone.isEmpty()) {
                            projectsLst.get(index).setAttribute("prjZoneName", projectMgr.getPrjZoneName(prjZone.get(0).getAttribute("zoneID").toString()).get(0).getAttribute("zoneName"));
                        }
                    }
                }
                
                 unitTypeMgr = UnitTypeMgr.getInstance();
                 locationWbo = LocationTypeMgr.getInstance().getOnSingleKey("key1", "RES-UNIT");
                try {
                    request.setAttribute("unitTypesList", new ArrayList<>(unitTypeMgr.getOnArbitraryKeyOracle((String) locationWbo.getAttribute("id"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("unitTypesList", new ArrayList<>());
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("projects", projectsLst);
                this.forwardToServedPage(request, response);
                
             break;
         case 154:
              servedPage = "/docs/Search/search_for_soldProject_unit.jsp";

                 unitvalue = request.getParameter("searchValue");
                 projectsArr = (String[]) request.getParameterValues("projects");
                if(request.getParameter("excel") != null && request.getParameter("excel").equals("1")){
                projectsArr= (String[])request.getParameter("projects").split(",");
                }
                 unitStatus = "10";
                
                searchBy = request.getParameter("search");
                clientStatusVec = null;
                status = " ";
                check = "check";
                unitsVec = new Vector();
                projectMgr = ProjectMgr.getInstance();
                
                projectMgr = ProjectMgr.getInstance();
                projectsLst = new ArrayList<>();
                try {
                    userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                    projectsLst = new ArrayList(userCompanyProjectsMgr.getAllProjectsByUserId((String) persistentUser.getAttribute("userId")));
                    if (projectsLst.isEmpty()) {
                        projectsLst = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4"));
                    } else {
                        if (projectsArr == null || projectsArr.length == 0) {
                            projectsArr = new String[projectsLst.size()];
                            for (int i = 0; i < projectsLst.size(); i++) {
                                WebBusinessObject projectTemp = projectsLst.get(i);
                                projectsArr[i] = (String) projectTemp.getAttribute("projectID");
                            }
                        }
                    }
                } catch (Exception ex) {
                    System.out.println("Get Projects List Exception = " + ex.getMessage());
                }
                if (searchBy != null) {
                    empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }
                    if (searchBy.equalsIgnoreCase("unitNo")) {
                        try {
                            if (departmentWbo != null) {
                                
                                if (projectsArr != null && projectsArr.length > 0 && !projectsArr[0].isEmpty()) {
                                    unitsVec = projectMgr.getUnitsForProjects("2",unitvalue, (String) departmentWbo.getAttribute("projectID"), projectsArr, request.getParameter("unitTypeID"), request.getParameter("unitAreaID"), unitStatus);
                                } else {
                                    unitsVec = projectMgr.getUnitsFromProject("2",unitvalue, (String) departmentWbo.getAttribute("projectID"), request.getParameter("unitTypeID"), request.getParameter("unitAreaID"), unitStatus,(String) loggedUser.getAttribute("userId"));
                                }
                                request.setAttribute("projectsArr", projectsArr);
                            }
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex);
                        }
                    } else if (searchBy.equalsIgnoreCase("buildingCode")) {
                        if (departmentWbo != null) {
                            unitsVec = projectMgr.getBuildingUnits("2",unitvalue, (String) departmentWbo.getAttribute("projectID"), String.join("','", request.getParameterValues("projects")));
                        }
                    }
                    AreaList=projectMgr.getUnitsArea();
                
                    request.setAttribute("AreaList",AreaList);
                    request.setAttribute("unitsVec", unitsVec);
                    request.setAttribute("status", status);
                    request.setAttribute("check", check);
                    try {
                        paymentPlace = projectMgr.getOnArbitraryKey("1365240752318", "key2");
                        request.setAttribute("paymentPlace", paymentPlace);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    lastFilter = "SearchServlet?op=getSoldProjUnits&search=" + searchBy + " ";
                    session.setAttribute("lastFilter", lastFilter);
                    topMenu = new Hashtable();
                    tempVec = new Vector();
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


                if (projectsLst != null && !projectsLst.isEmpty()) {
                    ArrayList<WebBusinessObject> prjZone = new ArrayList<>();
                    for (WebBusinessObject projectWbo : projectsLst) {
                        prjZone = projectMgr.getPrjZone(projectWbo.getAttribute("projectID").toString());
                        if (prjZone != null && !prjZone.isEmpty()) {
                            projectWbo.setAttribute("prjZoneName", projectMgr.getPrjZoneName(prjZone.get(0).getAttribute("zoneID").toString()).get(0).getAttribute("zoneName"));
                        }
                    }
                }
                
                unitTypeMgr = UnitTypeMgr.getInstance();
                locationWbo = LocationTypeMgr.getInstance().getOnSingleKey("key1", "RES-UNIT");
                try {
                    request.setAttribute("unitTypesList", new ArrayList<>(unitTypeMgr.getOnArbitraryKeyOracle((String) locationWbo.getAttribute("id"), "key1")));
                } catch (Exception ex) {
                    request.setAttribute("unitTypesList", new ArrayList<>());
                }
                //clients count for know us from 
                ArrayList dataList2 = new ArrayList();
                SeasonMgr seasonMgr=SeasonMgr.getInstance();
                ArrayList<WebBusinessObject>  seasonLst=seasonMgr.getCashedTableAsArrayList();
                for(int i=0;i<seasonLst.size();i++){
                 wbo=new WebBusinessObject();
                 String seasonName=seasonLst.get(i).getAttribute("arabicName").toString();
                 int count=0;
                for(int j=0;j<unitsVec.size();j++){
                    Enumeration uE=unitsVec.elements();
                    wbo=(WebBusinessObject) unitsVec.get(j);
                    if(wbo.getAttribute("knowUsFrom").toString().equalsIgnoreCase(seasonName)){
                    count++; 
                    }
                }
                 HashMap dataEntryMap2 = new HashMap();  
                    dataEntryMap2.put("name",seasonName);
                    if(unitsVec.size()>0){
                    dataEntryMap2.put("y", (count*100)/unitsVec.size());
                    }else{
                    dataEntryMap2.put("y", count);}
                    dataEntryMap2.put("count", count);
                    dataList2.add(dataEntryMap2);
                   
                }
                String jsonText2 = JSONValue.toJSONString(dataList2);
                request.setAttribute("unitAreaID", request.getParameter("unitAreaID"));
                request.setAttribute("untStsExlRprt", unitStatus);
                request.setAttribute("jsonText2", jsonText2);
                request.setAttribute("dataList2", dataList2);
                request.setAttribute("searchBy", searchBy);
                request.setAttribute("unitTypeID", request.getParameter("unitTypeID"));
                request.setAttribute("projects", projectsLst);
                if(request.getParameter("excel") != null && request.getParameter("excel").equals("1")){
                     titleStr = new StringBuilder("Units By Project");
                     StringBuilder projStr=new StringBuilder("");
		    String headers2[] = {"#", "Project Name", "Model", "Creation Time", "Unit Name", "Area", "Price","Purchase Date", "Source", "Client Name", "Client Mobile ","Client Email","Know us from","Client Creation Time","Duration Before Purchase"};
                    String attributes2[] = {"Number", "parentName", "modelName", "creationTime", "projectName", "area", "price","purchaseTime", "fullName", "clientName", "mobile","EMAIL","knowUsFrom","clientCreTime","timeBefPurch"};
                    String dataTypes2[] = {"", "String", "String", "String", "String", "String", "String","String", "String", "String", "String", "String","String","String","String"};
                    String[] headerStr2 = new String[2];
                    String[] headerStr2Val = new String[2];
                    headerStr2[0] = titleStr.toString();
                    headerStr2[1] = "Selected Projects:";
                    headerStr2Val[0]="";
                    if(projectsArr!=null && projectsArr.length>0 && !projectsArr[0].isEmpty()){
                    for (String projectsArr1 : projectsArr) {
                        String projName = projectMgr.getByKeyColumnValue("key", projectsArr1, "key1");
                        projStr.append(projName+"--");
                    }
                    projStr.delete(projStr.length()-2, projStr.length());
                    headerStr2Val[1]=projStr.toString();
                    }else{
                        headerStr2Val[1]="all";
                    }
                    
                    HSSFWorkbook workBook2 = Tools.createExcelReport("Units By Project", headerStr2, headerStr2Val, headers2, attributes2, dataTypes2, new ArrayList(unitsVec));
                     c = Calendar.getInstance();
                     fileDate = c.getTime();
		     sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    sdf.applyPattern("yyyy-MM-dd");
                    String reportDate = sdf.format(fileDate);
                     filename = "Units By Project";
		    try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        try {
                            workBook2.write(bos);
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
                }
                 brokersList1=userMgr.getAllBrokers();
                request.setAttribute("bokersList",userMgr.getAllBrokers());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
               
             break;
         case 155:
               servedPage = "/docs/sales/search_my_clients2.jsp";
               check = null;
                status = " ";
                // start
               out = response.getWriter();
               searchBy = request.getParameter("searchBy");
               loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
               loggegUserId = (String) loggedUser.getAttribute("userId");
               
                if (searchBy != null) {
//                    ArrayList<WebBusinessObject> myClientsList = EmployeeView2Mgr.getInstance().getMyClients((String) loggedUser.getAttribute("userId"), null, null);
//                    ArrayList<String> clientsIDs = new ArrayList<>();
//                    for (WebBusinessObject clientTemp : myClientsList) {
//                        clientsIDs.add((String) clientTemp.getAttribute("customerId"));
//                    }
//                    
                    searchByValue = null;
                    wbo = new WebBusinessObject();
                    clientMgr = ClientMgr.getInstance();
                    EmployeeView2Mgr employeeView2Mgr=EmployeeView2Mgr.getInstance();
                    ArrayList<WebBusinessObject> clientsVec1 = new ArrayList();
                    result = new WebBusinessObject();
                    
                        searchByValue = request.getParameter("valueSearch");
                        request.setAttribute("clientNo", searchByValue);
                        try {
                            empRelationMgr = EmpRelationMgr.getInstance();
                            projectMgr = ProjectMgr.getInstance();
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                            managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                            departmentWbo = null;
                            if (managerWbo != null) {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                            } else {
                                departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                            }
                            
                            if (departmentWbo != null) {
                                clientsVec1 = employeeView2Mgr.getMyClntsRated(searchBy,searchByValue.trim(), (String) loggedUser.getAttribute("userId"));
                                if (!clientsVec1.isEmpty()) {
                                    result.setAttribute("clientNoStatus", "ok");
                                    } else {
                                        result.setAttribute("clientNoStatus", "no");
                                    }
                                }
                            } catch (Exception ex) {
                            logger.error(ex);
                        }
                        out.write(Tools.getJSONObjectAsString(result));
                        request.setAttribute("clientsVec", clientsVec1);
                        
                    
                }
                // end
                request.setAttribute("page", servedPage);
                request.setAttribute("check", check);
                request.setAttribute("status", status);
                this.forwardToServedPage(request, response);
           break;
         case 156:
             servedPage = "/docs/sales/search_for_client_byMob.jsp";
              departments = new ArrayList<WebBusinessObject>();
                UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                String selectedDepartment = request.getParameter("departmentID");
                String search = request.getParameter("search");
                searchBy = request.getParameter("searchBy");
                String clientMobile = request.getParameter("clientMobile");
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
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
                            selectedDepartment = "all";
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                clientsList=new ArrayList<WebBusinessObject>();
                if (clientMobile!=null){
                    clientMgr=ClientMgr.getInstance();
                    clientsList=clientMgr.getClientByMob(selectedDepartment, clientMobile,searchBy);
                }
                
             request.setAttribute("departmentID", selectedDepartment);
             request.setAttribute("clientMobile", clientMobile);
             request.setAttribute("clientsList", clientsList);
             request.setAttribute("departments", departments);
             request.setAttribute("searchBy", searchBy);
             request.setAttribute("page", servedPage);
             this.forwardToServedPage(request, response);
             break;
            default:
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Search Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase(AppConstants.LIST_ALL)) {
            return 1;
        } else if (opName.indexOf("ListByStatus") == 0) {
            return 2;
        } else if (opName.indexOf("StatusProjectList") == 0) {
            return 3;
        } else if (opName.indexOf("ListByWorkerAll") == 0) {
            return 4;
        } else if (opName.indexOf("ListResult") == 0) {
            return 5;
        } else if (opName.indexOf("ViewHistory") == 0) {
            return 6;
        } else if (opName.indexOf("Projects") == 0) {
            return 7;
        } else if (opName.indexOf("ProjectStcs") == 0) {
            return 8;
        } else if (opName.indexOf("StatusReport") == 0) {
            return 9;
        } else if (opName.indexOf("SearchFormTitle") == 0) {
            return 10;
        } else if (opName.indexOf("SearchTitle") == 0) {
            return 11;
        } else if (opName.indexOf("SearchFormNote") == 0) {
            return 12;
        } else if (opName.indexOf("SearchNote") == 0) {
            return 13;
        } else if (opName.indexOf("WorkerProject") == 0) {
            return 14;
        } else if (opName.indexOf("WorkerStatus") == 0) {
            return 15;
        } else if (opName.indexOf("ProjectHours") == 0) {
            return 16;
        } else if (opName.indexOf("WorkerProHours") == 0) {
            return 17;
        } else if (opName.indexOf("RiskReport") == 0) {
            return 18;
        } else if (opName.indexOf("HoursExcel") == 0) {
            return 19;
        } else if (opName.indexOf("MaintenanceProject") == 0) {
            return 20;
        } else if (opName.indexOf("MaintenanceListProject") == 0) {
            return 21;
        } else if (opName.indexOf("HoursWorkerExcel") == 0) {
            return 22;
        } else if (opName.indexOf("ExcelProjectStcs") == 0) {
            return 23;
        } else if (opName.indexOf("ExcelStatusReport") == 0) {
            return 24;
        } else if (opName.indexOf("ExcelMaintenanceListProject") == 0) {
            return 25;
        } else if (opName.equalsIgnoreCase("SearchJobOrder")) {
            return 26;
        } else if (opName.equalsIgnoreCase("JobOrderReport")) {
            return 27;
        } else if (opName.equalsIgnoreCase("JobOrderReportResult")) {
            return 28;
        } else if (opName.equalsIgnoreCase("JobOrderReportByEquip")) {
            return 29;
        } else if (opName.equalsIgnoreCase("JobOrderReportResultByEquip")) {
            return 30;
        } else if (opName.equalsIgnoreCase("JobOrderReportByMonth")) {
            return 31;
        } else if (opName.equalsIgnoreCase("JobOrderReportResultByMonth")) {
            return 32;
        } else if (opName.equalsIgnoreCase("RatioSuccess")) {
            return 33;
        } else if (opName.equalsIgnoreCase("RatioSuccessResult")) {
            return 34;
        } else if (opName.equalsIgnoreCase("JobOrderReportByEquipByMonth")) {
            return 35;
        } else if (opName.equalsIgnoreCase("JobOrderReportResultByEquipByMonth")) {
            return 36;
        } else if (opName.equalsIgnoreCase("FailureCodeChart")) {
            return 37;
        } else if (opName.equalsIgnoreCase("FailureCodeChartResult")) {
            return 38;
        } else if (opName.equalsIgnoreCase("StatusProjctListTitle")) {
            return 39;
        } else if (opName.equalsIgnoreCase("SearchByShiftWithGroup")) {
            return 40;
        } else if (opName.equalsIgnoreCase("SearchByShift")) {
            return 41;
        } else if (opName.equalsIgnoreCase("SearchByDepartment")) {
            return 42;
        } else if (opName.equalsIgnoreCase("SearchByResultDepartment")) {
            return 43;
        } else if (opName.equalsIgnoreCase("SearchJobOrderTabForm")) {
            return 44;
        } else if (opName.equalsIgnoreCase("SearchJobOrderTab")) {
            return 45;
        } else if (opName.equalsIgnoreCase("SearchFailureMachine")) {
            return 46;
        } else if (opName.equalsIgnoreCase("ResultFailureMachine")) {
            return 47;
        } else if (opName.equalsIgnoreCase("ResultEMGFailureMachine")) {
            return 48;
        } else if (opName.equalsIgnoreCase("listEq")) {
            return 49;
        } else if (opName.equalsIgnoreCase("ListEqpByTitle")) {
            return 50;
        } else if (opName.equalsIgnoreCase("SearchJobOrderTabtest")) {
            return 51;
        } else if (opName.equalsIgnoreCase("searchfromBeginDate")) {
            return 52;
        } else if (opName.equalsIgnoreCase("getByoneDate")) {
            return 53;
        } else if (opName.equalsIgnoreCase("searchfromEndDate")) {
            return 54;
        } else if (opName.equalsIgnoreCase("searchFromPlan")) {
            return 55;
        } else if (opName.equalsIgnoreCase("searchPlanResult")) {
            return 56;
        } else if (opName.equalsIgnoreCase("cancelPlannedIssue")) {
            return 57;
        } else if (opName.equalsIgnoreCase("ListLateJOForm")) {
            return 58;
        } else if (opName.equalsIgnoreCase("ListLateJO")) {
            return 59;
        } else if (opName.equalsIgnoreCase("searchFromSchedule")) {
            return 60;
        } else if (opName.indexOf("getJobOrdersByLateClosed") == 0) {
            return 61;
        } else if (opName.equalsIgnoreCase("searchSchedulesByEquipmentForm")) {
            return 62;
        } else if (opName.equalsIgnoreCase("searchSchedulesByEquipment")) {
            return 63;
        } else if (opName.equalsIgnoreCase("searchScheduleByDate")) {
            return 64;
        } else if (opName.equalsIgnoreCase("JobOrderReportByDate")) {
            return 65;
        } else if (opName.equalsIgnoreCase("searchTasksByDate")) {
            return 66;
        } else if (opName.equalsIgnoreCase("searchPlan")) {
            return 67;
        } else if (opName.equalsIgnoreCase("listPlans")) {
            return 68;
        } else if (opName.equalsIgnoreCase("getSearchSchedulesBeforeDateForm")) {
            return 69;
        } else if (opName.equalsIgnoreCase("searchSchedulesBeforeDate")) {
            return 70;
        } else if (opName.equalsIgnoreCase("tasksWithAndWithoutItems")) {
            return 71;
        } else if (opName.equalsIgnoreCase("getSearchSPInScheduleForm")) {
            return 72;
        } else if (opName.equalsIgnoreCase("searchSPInSchedule")) {
            return 73;
        } else if (opName.equalsIgnoreCase("getSearchForClientForm")) {
            return 74;
        } else if (opName.equalsIgnoreCase("searchForClient")) {
            return 75;
        } else if (opName.equalsIgnoreCase("getSearchForCallForm")) {
            return 76;
        } else if (opName.equalsIgnoreCase("searchForCall")) {
            return 77;
        } else if (opName.equalsIgnoreCase("getSearchForUsersForm")) {
            return 78;
        } else if (opName.equalsIgnoreCase("searchForUsers")) {
            return 79;
        } else if (opName.equalsIgnoreCase("getGeneralReportForm")) {
            return 80;
        } else if (opName.equalsIgnoreCase("getSearchForComplaintsForm")) {
            return 81;
        } else if (opName.equalsIgnoreCase("SearchForComplaints")) {
            return 82;
        } else if (opName.equalsIgnoreCase("getSearchForComplaintsForm2")) {
            return 83;
        } else if (opName.equalsIgnoreCase("SearchForComplaints2")) {
            return 84;
        } else if (opName.equalsIgnoreCase("getSearchForUnitsForm")) {
            return 85;
        } else if (opName.equalsIgnoreCase("SearchForUnits")) {
            return 86;
        } else if (opName.equalsIgnoreCase("getSearchForCallFormByName")) {
            return 87;
        } else if (opName.equalsIgnoreCase("SearchForCallFormByName")) {
            return 88;
        } else if (opName.equalsIgnoreCase("SearchForDocs")) {
            return 89;
        } else if (opName.equalsIgnoreCase("getDocs")) {
            return 90;
        } else if (opName.equalsIgnoreCase("searchForUnitQA")) {
            return 91;
        } else if (opName.equalsIgnoreCase("searchForVendor")) {
            return 92;
        } else if (opName.equalsIgnoreCase("getSearchForClosedCallCenter")) {
            return 93;
        } else if (opName.equalsIgnoreCase("searchForClosedCallCenter")) {
            return 94;
        } else if (opName.equalsIgnoreCase("getSearchForUnitsFormMenu")) {
            return 95;
        } else if (opName.equalsIgnoreCase("SearchForUnitsMenu")) {
            return 96;
        } else if (opName.equalsIgnoreCase("getSearchForSingleUnitsForm")) {
            return 97;
        } else if (opName.equalsIgnoreCase("SearchForSingleUnits")) {
            return 98;
        } else if (opName.equals("SearchForAllClients")) {
            return 99;
        } else if (opName.equals("SearchForAllUnits")) {
            return 100;
        } else if (opName.equals("getSearchClientsByUnit")) {
            return 101;
        }
//        if (opName.equals("getSearchForCallCenter")) {
//            return 102;
//        }
         else if (opName.equalsIgnoreCase("getSearchForDocuments")) {
            return 103;
        } else if (opName.equalsIgnoreCase("searchForDocuments")) {
            return 104;
        } else if (opName.equalsIgnoreCase("getClientsWithDesired")) {
            return 105;
        } else if (opName.equalsIgnoreCase("getClientsWithDesiredDetailed")) {
            return 106;
        } else if (opName.equalsIgnoreCase("getRequests")) {
            return 107;
        } else if (opName.equalsIgnoreCase("searchNewClients")) {
            return 108;
        } else if (opName.equalsIgnoreCase("getAllRequests")) {
            return 109;
        } else if (opName.equals("getAllValidRequests")) {
            return 110;
        } else if (opName.equals("saveDocRequests")) {
            return 111;
        } else if (opName.equals("getDocsRequests")) {
            return 112;
        } else if (opName.equalsIgnoreCase("getRequestsForAll")) {
            return 113;
        } else if (opName.equalsIgnoreCase("getRequestsQuality")) {
            return 114;
        } else if (opName.equalsIgnoreCase("searchWithinComments")) {
            return 115;
        } else if (opName.equalsIgnoreCase("getRequestsQForAll")) {
            return 116;
        } else if (opName.equalsIgnoreCase("searchForAllDocuments")) {
            return 117;
        } else if (opName.equalsIgnoreCase("searchNewClientsByBranch")) {
            return 118;
        } else if (opName.equalsIgnoreCase("getSearchForMyDocuments")) {
            return 119;
        } else if (opName.equalsIgnoreCase("searchForMyDocuments")) {
            return 120;
        } else if (opName.equalsIgnoreCase("searchForProjectUnits")) {
            return 121;
        } else if (opName.equalsIgnoreCase("getUnitByProject")) {
            return 122;
        } else if (opName.equalsIgnoreCase("SearchForAllUnitsForProjects")) {
            return 123;
        } else if (opName.equalsIgnoreCase("getSearchClientHistory")) {
            return 124;
        } else if (opName.equalsIgnoreCase("getExtractionWorkItems")) {
            return 125;
        } else if (opName.equalsIgnoreCase("getRequestLife")) {
            return 126;
        } else if (opName.equalsIgnoreCase("searctForRequestLife")) {
            return 127;
        } else if (opName.equalsIgnoreCase("getRequestProcessLife")) {
            return 128;
        } else if (opName.equalsIgnoreCase("searctForRequestLifePDF")) {
            return 129;
        } else if (opName.equalsIgnoreCase("getSearchForMyComplaints")) {
            return 130;
        } else if (opName.equalsIgnoreCase("searchForMyComplaints")) {
            return 131;
        } else if (opName.equalsIgnoreCase("searchForMyActivity")) {
            return 132;
        } else if (opName.equalsIgnoreCase("searchForMyClients")) {
            return 133;
        } else if (opName.equalsIgnoreCase("searchNewClientsGroup")) {
            return 134;
        } else if (opName.equalsIgnoreCase("exportNewClientsGroup")) {
            return 135;
        } else if (opName.equalsIgnoreCase("accSrchUnit")) {
            return 136;
        } else if (opName.equalsIgnoreCase("jobOrderSearch")) {
            return 137;
        } else if (opName.equalsIgnoreCase("BokerUnitsList")) {
            return 138;
        } else if (opName.equalsIgnoreCase("projectInformation")) {
            return 139;
        } else if (opName.equalsIgnoreCase("getUnitByProjectexportToExcel")) {
            return 140;
        }  else if (opName.equalsIgnoreCase("getUnitsForSpecificProject")) {
            return 141;
        } else if (opName.equalsIgnoreCase("myClientsWithDesiredSpaces")) {
            return 142;
        } else if (opName.equalsIgnoreCase("myClientsViews")) {
            return 143;
        } else if (opName.equalsIgnoreCase("myVewsForEachClient")) {
            return 144;
        } else if (opName.equalsIgnoreCase("clinetsViewsForEachUnit")) {
            return 145;
        } else if (opName.equalsIgnoreCase("eachClientViews")) {
            return 146;
        } else if (opName.equalsIgnoreCase("viewUnitDeliveryReport")) {
            return 147;
        } else if (opName.equalsIgnoreCase("searchForUnitBetween2Dates")) {
            return 148;
        } else if (opName.equalsIgnoreCase("searchForUnitBetween2DatesExcel")) {
            return 149;
        } else if (opName.equalsIgnoreCase("getMyClientsWithNoWish")) {
            return 150;
        }else if (opName.equalsIgnoreCase("getClientwithLegalDispute")) {
            return 151;
        }else if (opName.equalsIgnoreCase("ReleaseClientLegalDispute")) {
            return 152;
        
        }else if (opName.equalsIgnoreCase("searchForSoldProjUnits")) {
            return 153;
        
        }else if (opName.equalsIgnoreCase("getSoldProjUnits")) {
            return 154;
        }else if (opName.equalsIgnoreCase("searchForClients2")) {
            return 155;
        }else if (opName.equalsIgnoreCase("getSearchForClientByMob")) {
            return 156;
        }
        return 0;
    }
}