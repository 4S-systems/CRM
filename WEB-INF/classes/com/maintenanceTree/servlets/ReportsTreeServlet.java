/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.maintenanceTree.servlets;

import com.silkworm.business_objects.WebBusinessObject;
import com.maintenance.db_access.*;
import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.Tools;
import com.silkworm.common.SecurityUser;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
//import com.tracker.business_objects.ExcelCreator;
import com.tracker.db_access.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.*;
import java.util.ArrayList;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

/**
 *
 * @author khaled abdo
 */
public class ReportsTreeServlet extends TrackerBaseServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    String joTitle;

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
        MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        TradeMgr tradeMgr = TradeMgr.getInstance();
        UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        AllMaintenanceInfoMgr allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
        QuantifiedItemsDescMgr quantifiedItemsDescMgr = QuantifiedItemsDescMgr.getInstance();
        EquipmentsWithReadingMgr equipmentsWithReadingMgr = EquipmentsWithReadingMgr.getInstance();
        TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
        QuantifiedItemsMgr quantifiedItemsMgr = QuantifiedItemsMgr.getInstance();
        ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
        ItemsWithAvgPriceMgr itemsWithAvgPriceMgr = ItemsWithAvgPriceMgr.getInstance();
        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
        AllScheduleByHistoryMgr allScheduleByHistoryMgr = AllScheduleByHistoryMgr.getInstance();
        DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
        ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();
        AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject wbo;
        //ExcelCreator excelCreator;
        HSSFWorkbook workbook;

        ArrayList allTrade;
        ArrayList allSites;
        ArrayList allMainType;
        ArrayList parents;

        switch (operation) {
            case 1:
                servedPage = "/docs/reports_tree_docs/search_maint_details_by_eqp.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                allSites = projectMgr.getAllAsArrayList();

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", allSites);
                this.forward(servedPage, request, response);
                break;
            case 2:
                servedPage = "/docs/reports_tree_docs/search_maint_details_by_model.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                allSites = projectMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();

                 request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", allSites);
                request.setAttribute("parents", parents);
                this.forward(servedPage, request, response);
                break;
            case 3:
                servedPage = "/docs/reports_tree_docs/search_maint_details_by_mainType.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                allSites = projectMgr.getAllAsArrayList();
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();

                 request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", allSites);
                request.setAttribute("allMainType", allMainType);
                this.forward(servedPage, request, response);
                break;
            case 4:
                servedPage = "/docs/reports_tree_docs/search_maint_details_by_jo.jsp";
                this.forward(servedPage, request, response);
                break;
            case 5:
                servedPage = "/docs/reports_tree_docs/search_maint_details_by_sites.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                allSites = projectMgr.getAllAsArrayList();

                 request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", allSites);
                this.forward(servedPage, request, response);
                break;
            case 6:
                servedPage = "/docs/reports_tree_docs/search_maint_details_by_spare_parts.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                allSites = projectMgr.getAllAsArrayList();

                 request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", allSites);
                this.forward(servedPage, request, response);
                break;
            case 7:
                servedPage = "/docs/reports_tree_docs/search_maint_details_by_tasks.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                allSites = projectMgr.getAllAsArrayList();

                 request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", allSites);
                this.forward(servedPage, request, response);
                break;
            /*case 2:
                Vector allMaintenanceInfo;
                String issueId,
                 parentId,
                 parentName;
                Vector allItems,
                 allTask,
                 tempv1,
                 tempv2;

                Map params = new HashMap();

                String unitId = request.getParameter("unitId");
                String unitName = request.getParameter("unitName");
                String taskId = request.getParameter("taskId");
                String taskName = request.getParameter("taskName");
                String itemId = request.getParameter("partId");
                String itemName = request.getParameter("partName");
                String beginDate = request.getParameter("beginDate");
                String endDate = request.getParameter("endDate");
                String siteAll = request.getParameter("siteAll");
                String tradeAll = request.getParameter("tradeAll");
                String mainTypeAll = request.getParameter("mainTypeAll");
                String brandAll = request.getParameter("brandAll");
                String searchBy = request.getParameter("searchBy");
                String orderType = request.getParameter("orderType");
                String dateType = request.getParameter("dateType");

                String[] trade = request.getParameterValues("trade");
                String[] currentStatus = request.getParameterValues("currenStatus");
                String[] site = request.getParameterValues("site");
                String[] mainType = request.getParameterValues("mainType");
                String[] brand = request.getParameterValues("brand");
                String[] issueTitle = request.getParameterValues("issueTitle");

                // set wbo To pass to Method to search
                WebBusinessObject wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", beginDate);
                wboCritaria.setAttribute("endDate", endDate);

                wboCritaria.setAttribute("trade", trade);
                wboCritaria.setAttribute("issueTitle", issueTitle);
                wboCritaria.setAttribute("currentStatus", currentStatus);
                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);

                // for lable in jasper report
                String unitNameLbl = "";
                String unitNamesStr = "";
                String siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
                String tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";


                if (taskId != null && !taskId.equals("")) {
                    wboCritaria.setAttribute("taskId", taskId);
                }
                if (itemId != null && !itemId.equals("")) {
                    wboCritaria.setAttribute("itemId", itemId);
                }

                if (searchBy != null && searchBy.equals("unit")) {
                    wboCritaria.setAttribute("unitId", unitId);

                    wbo = maintainableMgr.getOnSingleKey(unitId);
                    parentId = (String) wbo.getAttribute("parentId");
                    params.put("unitName", (String) wbo.getAttribute("unitName"));

                    String projectId = (String) wbo.getAttribute("site");
                    wbo = projectMgr.getOnSingleKey(projectId);
                    params.put("siteName", (String) wbo.getAttribute("projectName"));

                    params.put("parentName", maintainableMgr.getUnitName(parentId));
                    params.put("equipmentReport", "yes");

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria);

                    unitNameLbl = "\u0627\u0644\u0645\u0639\u062F\u0629";
                    unitNamesStr = unitName;

                } else if (searchBy != null && searchBy.equals("brand")) {
                    wboCritaria.setAttribute("site", site);
                    wboCritaria.setAttribute("brand", brand);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByBrand(wboCritaria);

                    if (!brandAll.equals("yes")) {
                        String s = "";
                        Vector tempVec = parentUnitMgr.getParensName(brand);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();
                        }
                        if (tempVec.size() > 1) {
                            s += " , ...";
                        }
                        unitNamesStr = s;
                    } else {
                        unitNamesStr = "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A";
                    }
                    unitNameLbl = "\u0627\u0644\u0645\u0627\u0631\u0643\u0629";

                } else {
                    wboCritaria.setAttribute("site", site);
                    wboCritaria.setAttribute("mainType", mainType);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria);

                    if (!mainTypeAll.equals("yes")) {
                        String s = "";
                        Vector tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();
                        }
                        if (tempVec.size() > 1) {
                            s += " , ...";
                        }
                        unitNamesStr = s;
                    } else {
                        unitNamesStr = "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629";
                    }
                    unitNameLbl = "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u0649";

                }

                String temp1,
                 typeOfSchedule = "",
                 issueStatus = "",
                 tempStatus,
                 maintenanceDuration = "",
                 tempStatusBegin = "",
                 tempStatusEnd = "",
                 currentStatusSince = "";

                Date currentStatusSinceDate = null,
                 actualBeginDate = null,
                 actualEndDate = null;

                ConfigFileMgr configFileMgr = new ConfigFileMgr();

                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    allItems = new Vector();
                    allTask = new Vector();

                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
                    allTask = tasksByIssueMgr.getTask(issueId);

                    wbo.setAttribute("items", allItems);
                    wbo.setAttribute("tasks", allTask);
                    wbo.getAttribute("unitName");

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);

                    wbo.setAttribute("parentName", parentName);

                    issueStatus = (String) wbo.getAttribute("currentStatus");

                    if (issueStatus.equals("Assigned")) {
                        tempStatus = " - " + configFileMgr.getJobOrderTypeByCurrentLanguage("Open");
                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));

                        if (actualBeginDate != null) {
                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);

                        }

                    } else if (issueStatus.equals("Canceled")) {
                        tempStatus = " - " + configFileMgr.getJobOrderTypeByCurrentLanguage("Cancel");
                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);

                    } else {
                        tempStatusBegin = " - " + configFileMgr.getJobOrderTypeByCurrentLanguage("Open");
                        tempStatusEnd = " - " + configFileMgr.getJobOrderTypeByCurrentLanguage("Close");
                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));

                        try {
                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
                        } catch (NullPointerException nPEx) {
                            maintenanceDuration = "0";
                        }
                    }

                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                        typeOfSchedule = configFileMgr.getJobOrderType("Emergency");
                    } else {
                        temp1 = (String) wbo.getAttribute("issueTitle");
                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
                    }

                    wbo.setAttribute("issueStatus", configFileMgr.getJobOrderTypeByCurrentLanguage(issueStatus));
                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                    wbo.setAttribute("currentStatusSince", currentStatusSince);
                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
                }

                if (!siteAll.equals("yes")) {
                    Vector siteVec = (Vector) projectMgr.getProjectsName(site);
                    for (int i = 0; i < siteVec.size(); i++) {
                        if (i == 0) {
                            siteStrArr = (String) siteVec.get(i);
                        } else {
                            siteStrArr += " - " + (String) siteVec.get(i);
                        }
                        if (siteVec.size() > 0) {
                            siteStrArr += " ...";
                            break;
                        }
                    }
                }

                if (!tradeAll.equals("yes")) {
                    Vector tradeVec = tradeMgr.getTradesByIds(trade);
                    for (int i = 0; i < tradeVec.size(); i++) {
                        if (i == 0) {
                            tradeStr = (String) tradeVec.get(i);
                        } else {
                            tradeStr += " - " + (String) tradeVec.get(i);
                        }
                        if (tradeVec.size() > 0) {
                            tradeStr += " ...";
                            break;
                        }
                    }
                }

                params.put("beginDate", beginDate);
                params.put("endDate", endDate);
                params.put("unitNameLbl", unitNameLbl);
                params.put("unitNamesStr", unitNamesStr);
                params.put("siteStrArr", siteStrArr);
                params.put("tradeStr", tradeStr);
                params.put("taskName", taskName);
                params.put("REPORT_TYPE", "else");
                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");

                // create and open PDF report in browser
                ServletContext context = getServletConfig().getServletContext();
                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);

                break;

            case 3:
                unitName = request.getParameter("unitName");
                String formName = request.getParameter("formName");
                String strSites = request.getParameter("sites");
                strSites = strSites.trim();

                String[] listSites = strSites.split(" ");

                if (unitName != null && !unitName.equals("")) {
                    String[] parts = unitName.split(",");
                    unitName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        unitName += c;
                    }
                }

                Vector categoryTemp = new Vector();
                int count = 0;
                String url = "ReportsTreeServlet?op=selectEquipment";
                maintainableMgr = MaintainableMgr.getInstance();

                if (unitName != null && !unitName.equals("")) {
                    for (int i = 0; i < listSites.length; i++) {
                        categoryTemp = mergerVectors(categoryTemp, maintainableMgr.getEquipBySubNameAndSiteId(listSites[i], unitName));
                    }
                } else {
                    for (int i = 0; i < listSites.length; i++) {
                        categoryTemp = mergerVectors(categoryTemp, maintainableMgr.getEquipBySiteId(listSites[i]));
                    }
                }

                String tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                Vector category = new Vector();

                int index = (count + 1) * 10;
                if (categoryTemp.size() < index) {
                    index = categoryTemp.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) categoryTemp.get(i);

                    category.add(wbo);

                }

                float noOfLinks = categoryTemp.size() / 10f;
                String temp = "" + noOfLinks;
                int intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                int links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                session.removeAttribute("CategoryID");
                servedPage = "/docs/reports_tree_docs/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);
                request.setAttribute("sites", strSites);
                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;
            case 4:
                String sparePart = request.getParameter("sparePart");
                formName = request.getParameter("formName");
                if (sparePart != null && !sparePart.equals("")) {
                    String[] parts = sparePart.split(",");
                    sparePart = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        sparePart += c;
                    }
                }
                TaskMgr taskMgr = TaskMgr.getInstance();
                Vector items = new Vector();
                count = 0;
                url = "ReportsTreeServlet?op=selectItems";
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 20;
                taskMgr.cashData();
                if (sparePart != null && !sparePart.equals("")) {
                    items = quantifiedItemsDescMgr.getQuantifiedItemsBySubName(sparePart);
                } else {
                    items = quantifiedItemsDescMgr.getAllQuantifiedItems();
                }

                Vector itemList = new Vector();

                if (items.size() < index) {
                    index = items.size();
                }
                for (int i = count * 20; i < index; i++) {
                    wbo = (WebBusinessObject) items.get(i);
                    itemList.add(wbo);
                }

                noOfLinks = items.size() / 20f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                servedPage = "/docs/reports_tree_docs/items_list2.jsp";

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("data", itemList);
                request.setAttribute("formName", formName);
                request.setAttribute("sparePart", sparePart);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 5:
                servedPage = "/docs/reports_tree_docs/search_equipments_with_reading.jsp";
                allSites = projectMgr.getAllAsArrayList();

                request.setAttribute("page", servedPage);
                request.setAttribute("allSites", allSites);
                this.forwardToServedPage(request, response);
                break;

            case 6:
                servedPage = "/docs/reports_tree_docs/select_multi_equipment.jsp";
                formName = request.getParameter("formName");
                String sites = request.getParameter("sites");
                String ids = request.getParameter("ids").trim();
                String type = request.getParameter("type");

                String[] arrIds = ids.split(" ");
                String[] arrSites;
                String[] arrTypeOfRate;

                if (type == null) {
                    arrTypeOfRate = new String[2];
                    arrTypeOfRate[0] = "fixed";
                    arrTypeOfRate[1] = "odometer";
                } else {
                    type = type.trim();
                    arrTypeOfRate = type.split(" ");
                }

                if (sites == null) {
                    sites = projectMgr.getAllSites().trim();

                } else {
                    sites = sites.trim();
                }

                arrSites = sites.split(" ");

                Vector equip = new Vector();

                if (ids != null && !ids.equals("")) {
                    equip = maintainableMgr.getEquipBySiteAndTypeRateAndId(arrIds, arrSites, arrTypeOfRate);
                } else {
                    equip = maintainableMgr.getEquipBySitesAndTypeRate(arrSites, arrTypeOfRate);
                }

                count = 0;
                url = "ReportsTreeServlet?op=selectEquipments";
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                Vector subEquipList = new Vector();

                index = (count + 1) * 50;

                if (equip.size() < index) {
                    index = equip.size();
                }
                for (int i = count * 50; i < index; i++) {
                    wbo = (WebBusinessObject) equip.get(i);
                    subEquipList.add(wbo);
                }

                noOfLinks = equip.size() / 50f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("data", subEquipList);
                request.setAttribute("formName", formName);
                request.setAttribute("sites", sites);
                request.setAttribute("type", type);
                request.setAttribute("ids", ids);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 7:
                servedPage = "/docs/reports_tree_docs/result_equipments_with_reading.jsp";
                siteAll = request.getParameter("siteAll");
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                sites = request.getParameter("sites").trim();
                ids = request.getParameter("ids").trim();
                type = request.getParameter("type").trim();
                arrIds = ids.split(" ");
                arrSites = sites.split(" ");
                arrTypeOfRate = type.split(" ");
                Vector equipmentsWithReading;

                if (ids != null && !ids.equals("")) {
                    equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsWithReadingByIds(arrIds, arrTypeOfRate, beginDate, endDate);
                    request.setAttribute("equipments", maintainableMgr.getUnitsName(arrIds));
                } else {
                    equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsWithReadingBySites(arrSites, arrTypeOfRate, beginDate, endDate);
                    request.setAttribute("allEquipments", "all");
                }

                request.setAttribute("siteAll", siteAll);
                request.setAttribute("typeOfRate", getTypeOfRate(arrTypeOfRate));
                request.setAttribute("sites", projectMgr.getProjectsName(arrSites));
                request.setAttribute("data", equipmentsWithReading);
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                this.forward(servedPage, request, response);
                break;

            case 8:
                servedPage = "/docs/reports_tree_docs/search_equipments_not_updated.jsp";
                allSites = projectMgr.getAllAsArrayList();
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                ArrayList allBrand = parentUnitMgr.getCashedTableAsBusObjects();

                request.setAttribute("source", (String) request.getAttribute("source"));
                request.setAttribute("allSites", allSites);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("allBrand", allBrand);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 9:

                String source = request.getParameter("source");
                sites = request.getParameter("sites");
                String strInterval = request.getParameter("interval");
                String typeOfRateValues = request.getParameter("typeOfRateValues").trim();
                type = request.getParameter("type");
                String strBrand = request.getParameter("brand");
                ids = request.getParameter("ids");

                siteAll = request.getParameter("siteAll");
                String mainFilter = request.getParameter("mainFilter");


                int interval = Integer.valueOf(strInterval).intValue();
                arrTypeOfRate = typeOfRateValues.split(" ");
                arrSites = sites.trim().split(" ");

                if (source != null && source.equalsIgnoreCase("getUpdateReadingsOfEquipmentsForm")) { // updating readings of equipments
                    searchBy = request.getParameter("radioMain");
                    if (searchBy == null) {
                        searchBy = request.getParameter("searchBy");
                    }

                    if (searchBy.equals("2")) { // selected equipments was selected
                        arrIds = ids.trim().split(" ");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(arrSites, interval, arrTypeOfRate, arrIds, null, null);

                        request.setAttribute("filterType", "equip");
                        request.setAttribute("filterValue", maintainableMgr.getUnitsName(arrIds));
                    } else if (searchBy.equals("1")) { // brand was selected
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(arrSites, interval, arrTypeOfRate, null, null, strBrand.trim());

                        request.setAttribute("filterType", "brand");
                        request.setAttribute("filterValue", parentUnitMgr.getParensName(strBrand.trim().split(" ")));
                    } else { // main type was selected
                        String[] arrMainType = type.split(" ");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(arrSites, interval, arrTypeOfRate, null, arrMainType, null);

                        request.setAttribute("filterType", "mainType");
                        request.setAttribute("filterValue", mainCategoryTypeMgr.getMainTypeName(arrMainType));
                    }

                    request.setAttribute("typeOfRate", getTypeOfRate(arrTypeOfRate));
                    request.setAttribute("mainFilter", mainFilter);
                    request.setAttribute("siteAll", siteAll);
                    request.setAttribute("siteValue", projectMgr.getProjectsName(arrSites));
                    request.setAttribute("interval", interval);
                    request.setAttribute("data", equipmentsWithReading);
                    request.setAttribute("searchBy", searchBy);

                    count = 0;
                    url = "ReportsTreeServlet?op=resultSearchEquipmentsNotUpdated";
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    category = new Vector();

                    index = (count + 1) * 20;
                    if (equipmentsWithReading.size() < index) {
                        index = equipmentsWithReading.size();
                    }
                    for (int i = count * 20; i < index; i++) {
                        wbo = (WebBusinessObject) equipmentsWithReading.get(i);
                        category.add(wbo);
                    }

                    noOfLinks = equipmentsWithReading.size() / 20f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("data", category);

                    request.setAttribute("source", source);
                    request.setAttribute("sites", sites);
                    request.setAttribute("typeOfRateValues", typeOfRateValues);
                    request.setAttribute("type", type);
                    request.setAttribute("brand", strBrand);
                    request.setAttribute("ids", ids);
                    request.setAttribute("mainFilter", mainFilter);

                    servedPage = "/docs/reports_tree_docs/update_readings_of_equipments.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } else { // create PDF report

                    Map result = new HashMap();
                    String filterValueStr = new String();
                    Vector filterValueVec = new Vector();

                    if (ids != null && !ids.equals("null")) {
                        arrIds = ids.trim().split(" ");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(arrSites, interval, arrTypeOfRate, arrIds, null, null);
                        result.put("filterType", "\u0645\u0639\u062F\u0627\u062A");

                        filterValueStr = new String();
                        if (mainFilter.equals("yes")) {
                            filterValueStr = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
                        } else {
                            filterValueVec = maintainableMgr.getUnitsName(arrIds);
                            for (int i = 0; i < filterValueVec.size(); i++) {
                                if (i == 0) {
                                    filterValueStr = (String) filterValueVec.get(i);
                                } else if (i == filterValueVec.size() - 1) {
                                    filterValueStr += " " + (String) filterValueVec.get(i);
                                } else {
                                    filterValueStr += " - " + (String) filterValueVec.get(i);
                                }
                            }
                        }
                    } else if (strBrand != null && !strBrand.equals("null")) {

                        result.put("filterType", "\u0645\u0627\u0631\u0643\u0627\u062A");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(arrSites, interval, arrTypeOfRate, null, null, strBrand.trim());

                        filterValueStr = new String();
                        if (mainFilter.equals("yes")) {
                            filterValueStr = "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A";
                        } else {
                            filterValueVec = parentUnitMgr.getParensName(strBrand.trim().split(" "));
                            for (int i = 0; i < filterValueVec.size(); i++) {
                                if (i == 0) {
                                    filterValueStr = (String) filterValueVec.get(i);
                                } else if (i == filterValueVec.size() - 1) {
                                    filterValueStr += " " + (String) filterValueVec.get(i);
                                } else {
                                    filterValueStr += " - " + (String) filterValueVec.get(i);
                                }
                            }

                        }

                    } else {
                        String[] arrMainType = type.split(" ");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(arrSites, interval, arrTypeOfRate, null, arrMainType, null);

                        result.put("filterType", "\u0646\u0648\u0639 \u0623\u0633\u0627\u0633\u0649");

                        filterValueStr = new String();
                        if (mainFilter.equals("yes")) {
                            filterValueStr = "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0623\u0633\u0627\u0633\u064A\u0629";
                        } else {
                            filterValueVec = mainCategoryTypeMgr.getMainTypeName(arrMainType);
                            for (int i = 0; i < filterValueVec.size(); i++) {
                                if (i == 0) {
                                    filterValueStr = (String) filterValueVec.get(i);
                                } else if (i == filterValueVec.size() - 1) {
                                    filterValueStr += " " + (String) filterValueVec.get(i);
                                } else {
                                    filterValueStr += " - " + (String) filterValueVec.get(i);
                                }
                            }

                        }
                    }

                    Vector objects = new Vector();
                    Iterator it = equipmentsWithReading.iterator();
                    String tempStr = new String();
                    long timeByMilleSecond;
                    Date dateOfLastReading;
                    String strDateOfLastReading;
                    int lastReading, prevReading, diffReading = 0, tempVal;
                    while (it.hasNext()) {
                        wbo = (WebBusinessObject) it.next();
                        tempStr = (String) wbo.getAttribute("typeOfRate");
                        if (tempStr.equals("fixed")) {
                            wbo.setAttribute("typeOfRate", "\u0633\u0627\u0639\u0629");
                        } else {
                            wbo.setAttribute("typeOfRate", "\u0643\u064A\u0644\u0648\u0645\u062A\u0631");
                        }
                        lastReading = Integer.valueOf((String) wbo.getAttribute("lastReading")).intValue();
                        prevReading = Integer.valueOf((String) wbo.getAttribute("previousReading")).intValue();

                        if (lastReading < prevReading) {
                            tempVal = lastReading;
                            lastReading = prevReading;
                            prevReading = tempVal;
                        }

                        diffReading = lastReading - prevReading;
                        wbo.setAttribute("diffReading", Integer.toString(diffReading));

                        timeByMilleSecond = Long.valueOf((String) wbo.getAttribute("entryTime")).longValue();
                        dateOfLastReading = new Date(timeByMilleSecond);
                        strDateOfLastReading = dateOfLastReading.getDate() + "/" + (dateOfLastReading.getMonth() + 1) + "/" + (dateOfLastReading.getYear() + 1900);
                        wbo.setAttribute("dateOfLastReading", strDateOfLastReading);

                        objects.add(wbo);
                    }

                    String siteValueStr = new String();
                    if (siteAll.equals("yes")) {
                        siteValueStr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
                    } else {
                        Vector siteValueVec = projectMgr.getProjectsName(arrSites);
                        for (int i = 0; i < siteValueVec.size(); i++) {
                            if (i == 0) {
                                siteValueStr = (String) siteValueVec.get(i);
                            } else {
                                siteValueStr += " - " + (String) siteValueVec.get(i);
                            }
                        }
                    }

                    String typeOfRateStr = new String();
                    Vector typeOfRateVec = getTypeOfRate(arrTypeOfRate);

                    for (int i = 0; i < typeOfRateVec.size(); i++) {
                        if (i == 0) {
                            typeOfRateStr = (String) typeOfRateVec.get(i);
                        } else {
                            typeOfRateStr += " - " + (String) typeOfRateVec.get(i);
                        }
                    }

                    result.put("interval", interval);
                    result.put("typeOfRateStr", typeOfRateStr);
                    result.put("siteValue", siteValueStr);
                    result.put("filterValue", filterValueStr);
                    result.put("noOfEquipments", equipmentsWithReading.size());

                    // create and open PDF report in browser
                    context = getServletConfig().getServletContext();
                    Tools.createPdfReport("EquipmentsNotUpdated", result, objects, context, response, request);
                }

                break;

            case 10:
                servedPage = "/docs/reports_tree_docs/main_report_cost_form.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", "0");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                servedPage = "/docs/reports_tree_docs/main_report_cost_form.jsp";
                if (request.getSession().getAttribute("tabId") == null) {
                    request.getSession().setAttribute("tabId", "0");
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
*/
            case 12:
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                Vector projects = new Vector();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                ArrayList locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_by_eqp.jsp";
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
/*
            case 13:
                joTitle = request.getParameter("joTitle");
                IssueTitle issueTitleEnum;

                if (joTitle.equals("normal")) {
                    servedPage = "/docs/reports_tree_docs/resualt_avg_cost_normal_jo.jsp";
                    issueTitleEnum = IssueTitle.Emergency;
                } else {
                    servedPage = "/docs/reports_tree_docs/resualt_avg_cost_schedule_jo.jsp";
                    issueTitleEnum = IssueTitle.NotEmergency;
                }

                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");
                taskId = request.getParameter("taskId");
                taskName = request.getParameter("taskName");
                itemId = request.getParameter("partId");
                itemName = request.getParameter("partName");
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                siteAll = request.getParameter("siteAll");
                tradeAll = request.getParameter("tradeAll");
                mainTypeAll = request.getParameter("mainTypeAll");

                String tradeValues = request.getParameter("tradeValues").trim();
                String sitesValues = request.getParameter("sitesValues").trim();
                String mainTaypeValues = request.getParameter("mainTaypeValues").trim();

                trade = tradeValues.split(" ");
                site = sitesValues.split(" ");
                mainType = mainTaypeValues.split(" ");

                // set wbo To pass to Method to search
                wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", beginDate);
                wboCritaria.setAttribute("endDate", endDate);
                wboCritaria.setAttribute("trade", trade);


                if (taskId != null && !taskId.equals("")) {
                    wboCritaria.setAttribute("taskId", taskId);
                }
                if (itemId != null && !itemId.equals("")) {
                    wboCritaria.setAttribute("itemId", itemId);
                }

                if (unitId != null && !unitId.equals("")) {
                    wboCritaria.setAttribute("unitId", unitId);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria, issueTitleEnum);
                } else {
                    wboCritaria.setAttribute("site", site);
                    wboCritaria.setAttribute("mainType", mainType);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria, issueTitleEnum);
                }

                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    allItems = new Vector();
                    allTask = new Vector();

                    allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
                    allTask = tasksByIssueMgr.getTask(issueId);

                    wbo.setAttribute("items", allItems);
                    wbo.setAttribute("tasks", allTask);

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);

                    wbo.setAttribute("parentName", parentName);


                }

                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);

                request.setAttribute("unitName", unitName);
                request.setAttribute("taskName", taskName);
                request.setAttribute("itemName", itemName);

                request.setAttribute("tradeAll", tradeAll);
                request.setAttribute("mainTypeAll", mainTypeAll);
                request.setAttribute("siteAll", siteAll);

                if (!siteAll.equals("yes")) {
                    request.setAttribute("site", projectMgr.getProjectsName(site));
                }
                if (!mainTypeAll.equals("yes")) {
                    request.setAttribute("mainType", mainCategoryTypeMgr.getMainTypeName(mainType));
                }
                if (!tradeAll.equals("yes")) {
                    request.setAttribute("trade", tradeMgr.getTradesByIds(trade).get(0));
                }

                request.setAttribute("data", allMaintenanceInfo);
                this.forward(servedPage, request, response);
                break;

            case 14:
                servedPage = "/docs/reports_tree_docs/search_equipments_by_schedule.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 15:
                String pageName = request.getParameter("pageName");

                if (pageName == null) {
                    servedPage = "/docs/reports_tree_docs/result_equipments_by_schedule_grouping.jsp";
                } else {
                    servedPage = "/docs/reports_tree_docs/" + pageName + ".jsp";
                }
                ids = request.getParameter("ids").trim();
                arrIds = ids.split(" ");

                Vector allSchedules;
                Vector allEquipments;

                //get Equipments
                if (ids != null && !ids.equals("")) {
                    allEquipments = maintainableMgr.getEquipmentsByIds(arrIds);
                } else {
                    try {
                        allEquipments = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                        allEquipments = new Vector();
                    }
                }

                WebBusinessObject wboEquipments;
                for (int i = 0; i < allEquipments.size(); i++) {
                    wboEquipments = (WebBusinessObject) allEquipments.get(i);
                    unitId = (String) wboEquipments.getAttribute("id");

                    try {
                        allSchedules = allScheduleByHistoryMgr.getOnArbitraryKey(unitId, "key1");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                        allSchedules = new Vector();
                    }

                    wboEquipments.setAttribute("allSchedules", allSchedules);
                }

                request.setAttribute("ids", ids);
                request.setAttribute("data", allEquipments);
                this.forward(servedPage, request, response);
                break;

            case 16:
                session.removeAttribute("data");
                session.removeAttribute("headers");
                session.removeAttribute("attributeType");
                session.removeAttribute("attribute");
                response.getWriter().write("ok");
                break;

            case 17:
                excelCreator = new ExcelCreator();
                String filename = request.getParameter("filename");
                Vector data = (Vector) session.getAttribute("data");
                String[] headers = (String[]) session.getAttribute("headers");
                String[] attributeType = (String[]) session.getAttribute("attributeType");
                String[] attribute = (String[]) session.getAttribute("attribute");

                workbook = excelCreator.createExcelFile(headers, attribute, attributeType, data, 0);
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename);
                workbook.write(response.getOutputStream());

                response.getOutputStream().flush();
                response.getOutputStream().close();
                break;

            case 18:
                excelCreator = new ExcelCreator(true);
                WebBusinessObject wboEquipment;
                filename = request.getParameter("filename");
                data = (Vector) session.getAttribute("data");
                headers = (String[]) session.getAttribute("headers");
                attributeType = (String[]) session.getAttribute("attributeType");
                attribute = (String[]) session.getAttribute("attribute");

                workbook = new HSSFWorkbook();
                String beforHeader;

                for (int i = 0; i < data.size(); i++) {
                    wboEquipment = (WebBusinessObject) data.get(i);
                    allSchedules = (Vector) wboEquipment.getAttribute("allSchedules");

                    beforHeader = (String) wboEquipment.getAttribute("beforHeader");

                    if (allSchedules != null && allSchedules.size() > 0) {
                        workbook = excelCreator.createExcelFileByMultiTable(beforHeader, headers, attribute, attributeType, allSchedules, null);
                    } else {
                        workbook = excelCreator.createExcelFileByMultiTable(beforHeader, headers, attribute, attributeType, allSchedules, "Not Found Schedule");
                    }
                }

                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename);
                workbook.write(response.getOutputStream());

                response.getOutputStream().flush();
                response.getOutputStream().close();
                break;

            case 20:
                servedPage = "/docs/new_report/other_reports_form.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", "0");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 21:
                servedPage = "/docs/new_report/other_reports_form.jsp";
                if (request.getSession().getAttribute("tabId") == null) {
                    request.getSession().setAttribute("tabId", "0");
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 22:
                servedPage = "/docs/reports_tree_docs/cost_reports_from_stores.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", "0");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 23:
                servedPage = "/docs/reports_tree_docs/search_jo_with_labor.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();

                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allMainType", allMainType);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 24:

                servedPage = "/docs/new_report/brands_by_main_type.jsp";

                ArrayList mainTypes = new ArrayList();
                mainTypes = mainCategoryTypeMgr.getCashedTableAsBusObjects();

                request.setAttribute("mainTypes", mainTypes);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 25:
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();
                single = request.getParameter("single");
                 projects = new Vector();
               try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                 locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                if (single != null) {
                    servedPage = "/docs/reports_tree_docs/MainTypesCostReportForm_1.jsp";
                } else {
                    servedPage = "/docs/reports_tree_docs/MainTypesCostReportForm.jsp";
                }
//                ArrayList departments = departmentMgr.getCashedTableAsBusObjects();
//                ArrayList productionLines = productionLineMgr.getCashedTableAsBusObjects();
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                if (single != null) {
                    request.setAttribute("imageshow", single);
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }


                break;

            case 26:
                servedPage = "/docs/new_report/operation_reports_form.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", "0");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 27:
                servedPage = "/docs/reports_tree_docs/search_Deserve_Schedules.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 28:
                interval = Integer.parseInt(request.getParameter("deserveBefore"));
                data = new Vector();
                if (request.getParameter("interval").equals("before")) {
                    data = unitScheduleMgr.getSchedulesBeforeOrAfterDate(request.getParameter("unitId"), request.getParameter("scheduleId"), interval, 0);
                } else {
                    data = unitScheduleMgr.getSchedulesBeforeOrAfterDate(request.getParameter("unitId"), request.getParameter("scheduleId"), 0, interval);
                }
                WebBusinessObject tempWbo;
                for (int i = 0; i < data.size(); i++) {
                    tempWbo = (WebBusinessObject) data.get(i);
                    tempWbo.setAttribute("currentReading", averageUnitMgr.getOnSingleKey1((String) tempWbo.getAttribute("unitId")).getAttribute("current_Reading"));
                    tempWbo.setAttribute("IssueCode", issueMgr.getOnSingleKey("key3", (String) unitScheduleMgr.getUnitScheduleForScheduleDeserve((String) tempWbo.getAttribute("unitId"), (String) tempWbo.getAttribute("periodicId"), (String) tempWbo.getAttribute("beginDate")).getAttribute("id")).getAttribute("businessID"));
                }
                servedPage = "/docs/reports/result_schedules_beforeOrAfter.jsp";
                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 29:
                parents = maintainableMgr.getAllParentsOrderByName();
                servedPage = "/docs/reports_tree_docs/SparePArtsByEquip.jsp";
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 30:
                servedPage = "docs/reports_tree_docs/form_details.jsp";
                SelfDocMgr selfDocMgr = SelfDocMgr.getInstance();
                Vector<WebBusinessObject> formsWbo = new Vector<WebBusinessObject>();
                String formCode = request.getParameter("formCode");
                formsWbo = selfDocMgr.getFormsList(formCode);
                request.setAttribute("formsWbo", formsWbo);
                this.forward(servedPage, request, response);
                break;*/
            case 31:
                servedPage = "/docs/reports_tree_docs/equipment_list.jsp";
                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                Vector schedules = new Vector();
                filter = Tools.getPaginationInfo(request, response);
                maintainableMgr = MaintainableMgr.getInstance();
                List<WebBusinessObject> scheduleLists = new ArrayList<WebBusinessObject>(0);

                List<FilterCondition> conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());
                // add conditions
                conditions.add(new FilterCondition("IS_MAINTAINABLE", "1", Operations.EQUAL));

                conditions.add(new FilterCondition("IS_DELETED", "0", Operations.EQUAL));

                filter.setConditions(conditions);
                //grab scheduleList list
                try {
                    scheduleLists = maintainableMgr.paginationEntity(filter);
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
                request.setAttribute("scheduleList", scheduleLists);
                this.forward(servedPage, request, response);
                break;

            /*case 32:
                servedPage = "/docs/reports_tree_docs/search_brand_schedules.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 33:
                servedPage = "docs/new_report/statisticstree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 34:
                servedPage = "docs/new_report/planningtree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 35:
                servedPage = "docs/new_report/jobordertree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
*/
            case 36:
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_by_model.jsp";
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 37:
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();
                
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_by_mainType.jsp";
                
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 38:
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_by_jo.jsp";
                this.forward(servedPage, request, response);
                break;
            case 39:
                servedPage = "/docs/reports_tree_docs/spare_parts_list.jsp";
                com.silkworm.pagination.Filter filters = new com.silkworm.pagination.Filter();
                schedules = new Vector();
                
                filters = Tools.getPaginationInfo(request, response);
                quantifiedItemsDescMgr = QuantifiedItemsDescMgr.getInstance();
                List<WebBusinessObject> itemLists = new ArrayList<WebBusinessObject>(0);

                //grab itemList list
                try {
                    itemLists = quantifiedItemsDescMgr.paginationEntity(filters);
                } catch (Exception e) {
                    System.out.println(e);
                }
                selectionType = request.getParameter("selectionType");

                if (selectionType == null) {
                    selectionType = "single";
                }
                request.setAttribute("data", itemLists);
                request.setAttribute("filter", filters);
                this.forward(servedPage, request, response);
                break;
           case 40:
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_for_labor_by_eqp.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", locationsList);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 41:
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_for_labor_by_model.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                parents = maintainableMgr.getAllParentsOrderByName();
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", locationsList);
                request.setAttribute("parents", parents);
                this.forward(servedPage, request, response);
                break;
            case 42:
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_for_labor_by_mainType.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allMainType", allMainType);
                this.forward(servedPage, request, response);
                break;
            case 43:
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                allTrade = tradeMgr.getAllAsArrayList();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_by_sites.jsp";
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allTrade", allTrade);
                this.forward(servedPage, request, response);
                break;
            case 44:
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                allTrade = tradeMgr.getAllAsArrayList();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_by_spare_parts.jsp";
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allTrade", allTrade);
                this.forward(servedPage, request, response);
                break;
            case 45:
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                allTrade = tradeMgr.getAllAsArrayList();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                servedPage = "/docs/reports_tree_docs/search_avg_cost_jo_by_tasks.jsp";
                request.setAttribute("allSites", locationsList);
                request.setAttribute("allTrade", allTrade);
                this.forward(servedPage, request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Local Stores Items Servlet";
    }

    @Override
    protected int getOpCode(String opName) {

        if (opName.equals("searchMaintDetailsForEqp")) {
            return 1;
        } else if (opName.equals("searchMaintDetailsForModel")) {
            return 2;
        } else if (opName.equals("searchMaintDetailsForMainType")) {
            return 3;
        } else if (opName.equals("searchMaintDetailsForJO")) {
            return 4;
        } else if (opName.equals("searchMaintDetailsBySites")) {
            return 5;
        } else if (opName.equals("searchMaintDetailsBySpareParts")) {
            return 6;
        } else if (opName.equals("searchMaintDetailsByTasks")) {
            return 7;
        /*} else if (opName.equals("resulSearchMaintenanceDetails")) {
            return 2;
        } else if (opName.equals("selectEquipment")) {
            return 3;
        } else if (opName.equals("selectItems")) {
            return 4;
        } else if (opName.equals("searchEquipmentsWithReading")) {
            return 5;
        } else if (opName.equals("selectEquipments")) {
            return 6;
        } else if (opName.equals("resultSearchEquipmentsWithReading")) {
            return 7;
        } else if (opName.equals("searchEquipmentsNotUpdated")) {
            return 8;
        } else if (opName.equals("resultSearchEquipmentsNotUpdated")) {
            return 9;
        } else if (opName.equals("AvgCostReports")) {
            return 10;
        } else if (opName.equals("costReportForm")) {
            return 11;
        */} else if (opName.equals("getCostByAvgJOForEqp")) {
            return 12;
        /*} else if (opName.equals("resultCostByAvgJO")) {
            return 13;
        } else if (opName.equals("searchEquipmentsBySchedule")) {
            return 14;
        } else if (opName.equals("resultEquipmentsBySchedule")) {
            return 15;
        } else if (opName.equals("clearSession")) {
            return 16;
        } else if (opName.equals("extractReadingToExcel")) {
            return 17;
        } else if (opName.equals("extractToExcelMultiTable")) {
            return 18;
        } else if (opName.equals("otherReports")) {
            return 20;
        } else if (opName.equals("otherReportsForm")) {
            return 21;
        } else if (opName.equals("costReportsFromStores")) {
            return 22;
        } else if (opName.equals("costJobOrderWithLabor")) {
            return 23;
        } else if (opName.equals("getBrandsByMainType")) {
            return 24;
        } else if (opName.equals("maintenanceTypesCost")) {
            return 25;
        } else if (opName.equals("operationReports")) {
            return 26;
        } else if (opName.equals("getScheduleDeserve")) {
            return 27;
        } else if (opName.equals("resaultScheduleBeforeOrAfterTime")) {
            return 28;
        } else if (opName.equals("SparePartsByEquipment")) {
            return 29;
        } else if (opName.equals("getFormDetails")) {
            return 30;
        */} else if (opName.equals("ListEquipments")) {
            return 31;
        /*} else if (opName.equals("getBrandSchedules")) {
            return 32;
        } else if (opName.equalsIgnoreCase("Statistics")) {
            return 33;
        } else if (opName.equalsIgnoreCase("Planning")) {
            return 34;
        } else if (opName.equalsIgnoreCase("JobOrder")) {
            return 35;
        */} else if (opName.equals("getCostByAvgJOForModel")) {
            return 36;
        } else if (opName.equals("getCostByAvgJOForMainType")) {
            return 37;
        } else if (opName.equals("getCostByAvgJOForJO")) {
            return 38;
        } else if (opName.equalsIgnoreCase("listSpareParts")) {
            return 39;
        } else if (opName.equalsIgnoreCase("getCostByAvgJOForLaborByEqp")) {
            return 40;
        } else if (opName.equalsIgnoreCase("getCostByAvgJOForLaborByModel")) {
            return 41;
        } else if (opName.equalsIgnoreCase("getCostByAvgJOForLaborByMainType")) {
            return 42;
        } else if (opName.equals("getCostByAvgJOBySites")) {
            return 43;
        } else if (opName.equals("getCostByAvgJOBySpareParts")) {
            return 44;
        } else if (opName.equals("getCostByAvgJOByTasks")) {
            return 45;
        }
        return 0;
    }

    public Vector mergerVectors(Vector largeVector, Vector smallVector) {
        for (int i = 0; i < smallVector.size(); i++) {
            largeVector.add((WebBusinessObject) smallVector.get(i));
        }
        return largeVector;
    }

    public Vector getTypeOfRate(String[] arrTypeOfRate) {
        Vector vecTypeOfRate = new Vector();

        for (int i = 0; i < arrTypeOfRate.length; i++) {
            if (arrTypeOfRate[i].equals("fixed")) {
                vecTypeOfRate.add("Hour");
            } else {
                vecTypeOfRate.add("Kilo Meter");
            }
        }

        return vecTypeOfRate;
    }
}
