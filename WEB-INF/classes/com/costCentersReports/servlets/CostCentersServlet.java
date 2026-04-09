/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.costCentersReports.servlets;

import com.Erp.db_access.CostCentersMgr;
//import com.contractor.db_access.IssueMgr;
import com.contractor.db_access.MaintainableMgr;
import com.externalReports.db_access.ExternalJobReportMgr;
import com.externalReports.db_access.IssueByCostTasksMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.AllMaintenanceInfoMgr;
import com.maintenance.db_access.EmpTasksHoursMgr;
import com.maintenance.db_access.EquipmentsWithReadingMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.ItemsWithAvgPriceItemDataMgr;
import com.maintenance.db_access.ItemsWithAvgPriceMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.ParentUnitMgr;
import com.maintenance.db_access.QuantifiedItemsMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.SupplierMgr;
import com.maintenance.db_access.TaskMgr;
import com.maintenance.db_access.TasksByIssueMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.international.BilingualDisplayTerms;
import com.tracker.db_access.ProjectMgr;
import com.tracker.engine.AssignedIssueState;
import com.tracker.servlets.IssueServlet.IssueTitle;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.time.DurationFormatUtils;

/**
 *
 * @author khaled abdo
 */
public class CostCentersServlet extends TrackerBaseServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    ProjectMgr projectMgr = null;
    QuantifiedItemsMgr quantifiedItemsMgr = QuantifiedItemsMgr.getInstance();
    SupplierMgr supplierMgr = SupplierMgr.getInstance();
    ExternalJobReportMgr externalJobReportMgr = ExternalJobReportMgr.getInstance();
    IssueByCostTasksMgr issueByCostTasksMgr = IssueByCostTasksMgr.getInstance();
    EquipmentsWithReadingMgr equipmentsWithReadingMgr = EquipmentsWithReadingMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    ItemsWithAvgPriceMgr itemsWithAvgPriceMgr = ItemsWithAvgPriceMgr.getInstance();
    UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
    AllMaintenanceInfoMgr allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
    TaskMgr taskMgr = TaskMgr.getInstance();
    SecurityUser securityUser = new SecurityUser();
    TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
    EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
    ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    Map params = new HashMap();
    Vector allMaintenanceInfo = new Vector();
    Vector allMaintenanceInfoCopy = new Vector();
    Vector allItems = new Vector();
    Vector allTask = new Vector();
    Vector allLabor = new Vector();
    WebBusinessObject wboCritaria = new WebBusinessObject();
    WebBusinessObject wbo = new WebBusinessObject();
//    IssueMgr issueMgr = IssueMgr.getInstance();
    UnitScheduleMgr usMgr = UnitScheduleMgr.getInstance();
    ItemsMgr itemsMgr = ItemsMgr.getInstance();
    CostCentersMgr costCentersMgr = null;
    IssueTitle issueTitlenum;
    AssignedIssueState assignedIssueState = null;
    double totalItemsCost = 0;
    double laborCost;
    String[] costCode;
    String unitId;
    String unitName;
    String taskId;
    String taskName;
    String itemId;
    String itemName;
    String beginDate;
    String endDate;
    String siteAll;
    String tradeAll;
    String mainTypeAll;
    String issueId;
    String parentId;
    String parentName;
    String joTitle;
    String tradeValues;
    String issueTitle;
    String orderBy;
    String sitesValues;
    String mainTaypeValues;
    String brandValues;
    String from;
    String to;
    String laborDetail;
    String reportName;
    String brandAll;
    String searchBy;
    String[] trade;
    String[] site_;
    String[] mainType;
    String[] status;
    String[] brand;
    double totalJOCost = 0.0;
    double grandTotalJOCost = 0.0;
    String temp1 = "",
            typeOfSchedule = "",
            issueStatus = "",
            tempStatus,
            maintenanceDuration = "",
            JODate = "",
            tempStatusBegin = "",
            tempStatusEnd = "",
            currentStatusSince = "";
    Date currentStatusSinceDate = null,
            actualBeginDate = null,
            actualEndDate = null;
    String orderType = "", dateType = "", date_order = "";
    Vector tempVec = null;
    ItemsWithAvgPriceItemDataMgr itemsWithAvgPriceItemDataMgr = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        PrintWriter out = response.getWriter();
        ArrayList allSites = null;

        String lang = (String) request.getSession().getAttribute("currentMode");
        String JOOpenStatus, JOCloseStatus, JOCancelStatus;
        String JOEmrgencyStatus;
        String JOCanceledStatus, JOClosedStatus, JOFinishedStatus, JOOnholdStatus, JOAssignedStatus;
        if (lang.equalsIgnoreCase("Ar")) {
            JOOpenStatus = BilingualDisplayTerms.JO_AR_OPEN_STATUS;
            JOCloseStatus = BilingualDisplayTerms.JO_AR_CLOSE_STATUS;
            JOCancelStatus = BilingualDisplayTerms.JO_AR_CANCEL_STATUS;

            JOEmrgencyStatus = BilingualDisplayTerms.JO_AR_EMERGENCY_STATUS;
            JOCanceledStatus = BilingualDisplayTerms.JO_AR_CANCELED_STATUS;
            JOClosedStatus = BilingualDisplayTerms.JO_AR_CLOSED_STATUS;
            JOFinishedStatus = BilingualDisplayTerms.JO_AR_FINISHED_STATUS;
            JOOnholdStatus = BilingualDisplayTerms.JO_AR_ONHOLD_STATUS;
            JOAssignedStatus = BilingualDisplayTerms.JO_AR_ASSIGNED_STATUS;

        } else {
            JOOpenStatus = BilingualDisplayTerms.JO_EN_OPEN_STATUS;
            JOCloseStatus = BilingualDisplayTerms.JO_EN_CLOSE_STATUS;
            JOCancelStatus = BilingualDisplayTerms.JO_EN_CANCEL_STATUS;

            JOEmrgencyStatus = BilingualDisplayTerms.JO_EN_EMERGENCY_STATUS;
            JOCanceledStatus = BilingualDisplayTerms.JO_EN_CANCELED_STATUS;
            JOClosedStatus = BilingualDisplayTerms.JO_EN_CLOSED_STATUS;
            JOFinishedStatus = BilingualDisplayTerms.JO_EN_FINISHED_STATUS;
            JOOnholdStatus = BilingualDisplayTerms.JO_EN_ONHOLD_STATUS;
            JOAssignedStatus = BilingualDisplayTerms.JO_EN_ASSIGNED_STATUS;
        }

        try {
            switch (operation) {
                case 1:
                    servedPage = "/docs/cost_centers_reports/search_maint_on_cost_centers.jsp";
                    projectMgr = ProjectMgr.getInstance();
                    allSites = projectMgr.getAllAsArrayList();

                    request.setAttribute("defaultLocationName", securityUser.getSiteName());
                    request.setAttribute("allSites", allSites);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 2:
                    reportName = "";
                    params = new HashMap();
                    projectMgr = ProjectMgr.getInstance();
                    totalJOCost = 0.0;
                    grandTotalJOCost = 0.0;

                    temp1 = "";
                    typeOfSchedule = "";
                    issueStatus = "";
                    tempStatus = "";
                    maintenanceDuration = "";
                    JODate = "";
                    tempStatusBegin = "";
                    tempStatusEnd = "";
                    currentStatusSince = "";

                    currentStatusSinceDate = null;
                    actualBeginDate = null;
                    actualEndDate = null;

                    allMaintenanceInfo = new Vector();
                    itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
                    allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
                    tasksByIssueMgr = TasksByIssueMgr.getInstance();
                    issueTitle = request.getParameter("issueTitle");
                    params.put("C1", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E" : "From Date"));
                    params.put("C2", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E" : "To Date"));

                    /*if (issueTitle.equals("notEmergency")) {
                    issueTitlenum = IssueTitle.NotEmergency;
                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629");
                    } else if (issueTitle.equals("Emergency")) {
                    issueTitlenum = IssueTitle.Emergency;
                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
                    } else {
                    issueTitlenum = IssueTitle.Both;*/
                    params.put("title", (lang.equalsIgnoreCase("Ar") ? "\u062A\u0642\u0631\u064A\u0631 \u0627\u0644\u0635\u064A\u0627\u0646\u0629 \u0639\u0644\u064A \u0645\u0631\u0627\u0643\u0632 \u0627\u0644\u062A\u0643\u0644\u0641\u0629" : "Maintenance Report On Cost Centers"));
                    //}

                    beginDate = request.getParameter("beginDate");
                    endDate = request.getParameter("endDate");
                    siteAll = request.getParameter("siteAll");
                    laborDetail = request.getParameter("laborDetail");
                    if (laborDetail == null) {
                        laborDetail = "off";
                    }

                    costCode = request.getParameterValues("costCode");
                    site_ = request.getParameterValues("site");

                    orderType = request.getParameter("orderType");
                    dateType = request.getParameter("dateType");
                    date_order = dateType + " " + orderType;

                    // set wbo To pass to Method to search
                    wboCritaria = new WebBusinessObject();
                    wboCritaria.setAttribute("costCode", costCode);
                    wboCritaria.setAttribute("beginDate", beginDate);
                    wboCritaria.setAttribute("endDate", endDate);
                    wboCritaria.setAttribute("date_order", date_order);

                    wboCritaria.setAttribute("site", site_);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintInfoOnCostCenters(wboCritaria, issueTitlenum);

                    actualEndDate = null;
                    /*if (laborDetail.equals("on")) {
                    allMaintenanceInfoCopy = new Vector();
                    totalItemsCost = 0.0;
                    laborCost = 0;
                    grandTotalJOCost = 0;

                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {

                    totalJOCost = 0.0;
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    allItems = new Vector();
                    allTask = new Vector();

                    allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
                    allTask = tasksByIssueMgr.getTask(issueId);


                    laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);

                    issueStatus = (String) wbo.getAttribute("currentStatus");
                    String issueStatusLabel = "";
                    try {
                    if (issueStatus.equals("Assigned")) {
                    issueStatusLabel = JOAssignedStatus;
                    tempStatus = " - " + JOOpenStatus;
                    currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;

                    actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));

                    maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
                    JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");

                    } else if (issueStatus.equals("Canceled")) {
                    issueStatusLabel = JOCanceledStatus;
                    tempStatus = " - " + JOCancelStatus;
                    currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;

                    actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                    currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                    maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
                    JODate = currentStatusSince;

                    } else {
                    issueStatusLabel = JOFinishedStatus;
                    tempStatusBegin = " - " + JOOpenStatus;
                    tempStatusEnd = " - " + JOCloseStatus;
                    currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;

                    actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                    actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));

                    maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
                    JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
                    + "\nC " + (String) wbo.getAttribute("ActualEndDate");

                    }

                    } catch (NullPointerException ex) {
                    maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
                    JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
                    }

                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                    typeOfSchedule = JOEmrgencyStatus;
                    } else {
                    temp1 = (String) wbo.getAttribute("issueTitle");
                    typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
                    }

                    costCentersMgr = CostCentersMgr.getInstance();
                    String costCenterCode = wbo.getAttribute("costCenterCode").toString();
                    String costCenterName = costCentersMgr.getCostCenterNameByCode(costCenterCode, lang);
                    wbo.setAttribute("costCenterName", costCenterName);

                    wbo.setAttribute("issueStatus", issueStatusLabel);
                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                    wbo.setAttribute("currentStatusSince", currentStatusSince);

                    wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));

                    allLabor = new Vector();
                    try {
                    allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
                    } catch (Exception ex) {
                    logger.error(ex.getMessage());
                    }

                    totalItemsCost = 0.0;
                    for (int j = 0; j < allItems.size(); j++) {
                    WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
                    try {
                    itemName = tempItem.getAttribute("itemDesc").toString();
                    } catch (Exception e) {
                    itemName = "Item Name Not Supported";
                    }
                    tempItem.setAttribute("itemDesc", itemName);
                    try {
                    totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
                    } catch (Exception ex) {
                    logger.error(ex.getMessage());
                    }

                    }

                    grandTotalJOCost += (totalItemsCost + laborCost);

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);
                    wbo.setAttribute("items", allItems);
                    wbo.setAttribute("tasks", allTask);
                    try {
                    wbo.setAttribute("parentName", parentName);
                    } catch (Exception E) {
                    System.out.println("no parent type");
                    }
                    wbo.setAttribute("labors", allLabor);

                    totalJOCost = totalItemsCost + laborCost;

                    if (totalJOCost != 0.0) {
                    allMaintenanceInfoCopy.add(wbo);
                    }

                    }

                    reportName = "SJOAvgCostWithLaborsDetails";


                    } else {*/
                    totalItemsCost = 0.0;
                    laborCost = 0;
                    int index = 0;
                    allMaintenanceInfoCopy = new Vector();
                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                        totalJOCost = 0;
                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                        issueId = (String) wbo.getAttribute("issueId");
                        allItems = new Vector();
                        allTask = new Vector();


                        costCentersMgr = CostCentersMgr.getInstance();
                        String costCenterCode = null;
                        String costCenterName = null;
                        try {
                            costCenterCode = wbo.getAttribute("costCenterCode").toString();
                            if (!costCenterCode.equalsIgnoreCase("2")) {
                                costCenterName = costCentersMgr.getCostCenterNameByCode(costCenterCode, lang);
                            } else {
                                costCenterName = "not Supported yet";
                            }
                        } catch (Exception e) {
                            costCenterName = "not Supported yet";
                        }

                        wbo.setAttribute("costCenterName", costCenterName);


                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPriceByCostCenter((String) wbo.getAttribute("unitSchedualeId"), costCenterCode);
                        allTask = tasksByIssueMgr.getTask(issueId);

                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);

                        parentId = (String) wbo.getAttribute("parentId");
                        parentName = maintainableMgr.getUnitName(parentId);

                        issueStatus = (String) wbo.getAttribute("currentStatus");
                        String issueStatusLabel = "";


                        try {
                            if (issueStatus.equals("Assigned")) {
                                issueStatusLabel = JOAssignedStatus;
                                tempStatus = " - " + JOOpenStatus;
                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));

                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");

                            } else if (issueStatus.equals("Canceled")) {
                                issueStatusLabel = JOCanceledStatus;
                                tempStatus = " - " + JOCancelStatus;
                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
                                JODate = currentStatusSince;

                            } else {
                                issueStatusLabel = JOFinishedStatus;
                                tempStatusBegin = " - " + JOOpenStatus;
                                tempStatusEnd = " - " + JOCloseStatus;
                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));


                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");

                            }
                        } catch (NullPointerException ex) {
                            maintenanceDuration = lang.equalsIgnoreCase("Ar") ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : "Unavailable";
                            JODate = lang.equalsIgnoreCase("Ar") ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : "Unavailable";
                        }

                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                            typeOfSchedule = JOEmrgencyStatus;
                        } else {
                            temp1 = (String) wbo.getAttribute("issueTitle");
                            typeOfSchedule = (lang.equalsIgnoreCase("Ar") ? "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " : "Based on table ") + temp1;
                        }

                        wbo.setAttribute("issueStatus", issueStatusLabel);
                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                        wbo.setAttribute("currentStatusSince", currentStatusSince);
                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
                        wbo.setAttribute("JODate", JODate);

                        totalItemsCost = 0;
                        for (int j = 0; j < allItems.size(); j++) {
                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
                            try {
                                itemName = tempItem.getAttribute("itemDesc").toString();
                            } catch (Exception e) {
                                itemName = "Item Name Not Supported";
                            }
                            tempItem.setAttribute("itemDesc", itemName);
                            try {
                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
                            } catch (Exception ex) {
                                logger.error(ex.getMessage());
                            }

                        }

                        grandTotalJOCost += (totalItemsCost + laborCost);

                        wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
                        wbo.setAttribute("totalItemCost", totalItemsCost);
                        wbo.setAttribute("items", allItems);
                        wbo.setAttribute("tasks", allTask);

                        try {
                            wbo.setAttribute("parentName", parentName);
                        } catch (Exception e) {
                            System.out.println();
                        }

                        wbo.setAttribute("laborCost", laborCost);
                        totalJOCost = totalItemsCost + laborCost;

                        if (totalJOCost != 0.0) {
                            allMaintenanceInfoCopy.add(wbo);
                        }

                    }

                    reportName = lang.equalsIgnoreCase("Ar") ? "MaintReportOnCostCenters" : "MaintReportOnCostCenters_En";
                    //}

                    request.setAttribute("taskName", taskName);
                    request.setAttribute("itemName", itemName);

                    request.setAttribute("siteAll", siteAll);

                    params.put("beginDate", beginDate);
                    params.put("endDate", endDate);
                    params.put("grandTotalJOCost", grandTotalJOCost);

                    params.put("equipment", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0639\u062F\u0629" : "Equipment"));
                    params.put("model", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0627\u0631\u0643\u062A\u0647\u0627" : "Model"));
                    params.put("at", (lang.equalsIgnoreCase("Ar") ? "\u0641\u0649" : "at"));
                    params.put("mainSiteStr", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0648\u0642\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u0649" : "Main Site"));

                    if (!siteAll.equals("yes")) {
                        String s = projectMgr.getProjectsName(site_).get(0).toString();
                        if (projectMgr.getProjectsName(site_).size() > 1) {
                            s += " , ...";
                        }
                        params.put("siteStrArr", s);
                    } else {
                        params.put("siteStrArr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639" : "All Sites"));
                    }


                    if (costCode[0].equals("allCostCenters")) {                        
                        params.put("costCenterName", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0645\u0631\u0627\u0643\u0632 \u0627\u0644\u062A\u0643\u0644\u0641\u0629" : "All cost centers"));
                    } else {
                        String costCenterName = "";
                        try {
                            if (!costCode[0].equalsIgnoreCase("2")) {
                                costCenterName = costCentersMgr.getCostCenterNameByCode(costCode[0], lang);
                            } else {
                                costCenterName = "not Supported yet";
                            }
                        } catch (Exception e) {
                            costCenterName = "not Supported yet";
                        }
                        params.put("costCenterName", costCenterName);
                    }

                    response.reset();
                    response.resetBuffer(); //This may not required but I feel good to have this.
                    Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);

                    break;
                default:
                    System.out.println("No operation was matched");
            }
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    @Override
    protected int getOpCode(String opName) {

        if (opName.equals("searchMaintOnCostCenters")) {
            return 1;
        } else if (opName.equals("resultMaintOnCostCenters")) {
            return 2;
        }
        return 0;
    }
}
