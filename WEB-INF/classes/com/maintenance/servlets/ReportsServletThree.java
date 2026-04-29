package com.maintenance.servlets;

import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.fin.db_access.ChannelsExpenseMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.businessfw.hrs.servlets.EmployeeServlet;
import com.businessfw.oms.db_access.ClientSurveyMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ClientRatingMgr;
import com.clients.db_access.ReservationMgr;
import com.clients.servlets.ClientServlet;
import com.silkworm.business_objects.WebBusinessObject;
import com.maintenance.db_access.*;
import com.contractor.db_access.MaintainableMgr;
import com.crm.common.CRMConstants;
import com.crm.common.PDFTools;
import com.crm.db_access.CommentsMgr;
import com.crm.db_access.EmployeesLoadsMgr;
import com.crm.servlets.CommentsServlet;
import com.email_processing.EmailMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.common.UserCampaignConfigMgr;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.common.UserGroupConfigMgr;
import com.planning.db_access.SeasonMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.common.GroupMgr;
import com.silkworm.common.LoginHistoryMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserGroupMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.international.BilingualDisplayTerms;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.project_doc.SelfDocMgr;
//import com.tracker.business_objects.ExcelCreator;
import com.tracker.db_access.*;
import com.tracker.servlets.IssueServlet.IssueTitle;
import java.io.*;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.sql.Connection;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.ArrayList;
import org.apache.commons.lang.time.DurationFormatUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONValue;

public class ReportsServletThree extends TrackerBaseServlet {

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
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
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
        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
        EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
        WebBusinessObject wbo;
        //     ExcelCreator excelCreator;
        HSSFWorkbook workbook;

        ArrayList allTrade;
        ArrayList allSites;
        ArrayList allMainType;
        ArrayList parents;
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);

        String lang = (String) request.getSession().getAttribute("currentMode");
        String JOOpenStatus, JOCloseStatus, JOCancelStatus;
        String JOEmrgencyStatus;
        String JOCanceledStatus, JOClosedStatus, JOFinishedStatus, JOOnholdStatus, JOAssignedStatus;
        if (lang.equalsIgnoreCase("Ar")) {
            JOOpenStatus = BilingualDisplayTerms.JO_EN_OPEN_STATUS;
            JOCloseStatus = BilingualDisplayTerms.JO_EN_CLOSE_STATUS;
            JOCancelStatus = BilingualDisplayTerms.JO_EN_CANCEL_STATUS;

            JOEmrgencyStatus = BilingualDisplayTerms.JO_EN_EMERGENCY_STATUS;
            JOCanceledStatus = BilingualDisplayTerms.JO_EN_CANCELED_STATUS;
            JOClosedStatus = BilingualDisplayTerms.JO_EN_CLOSED_STATUS;
            JOFinishedStatus = BilingualDisplayTerms.JO_EN_FINISHED_STATUS;
            JOOnholdStatus = BilingualDisplayTerms.JO_AR_ONHOLD_STATUS;
            JOAssignedStatus = BilingualDisplayTerms.JO_AR_ASSIGNED_STATUS;

        } else {
            JOOpenStatus = BilingualDisplayTerms.JO_EN_OPEN_STATUS;
            JOCloseStatus = BilingualDisplayTerms.JO_EN_CLOSE_STATUS;
            JOCancelStatus = BilingualDisplayTerms.JO_EN_CANCEL_STATUS;

            JOEmrgencyStatus = BilingualDisplayTerms.JO_AR_EMERGENCY_STATUS;
            JOCanceledStatus = BilingualDisplayTerms.JO_AR_CANCELED_STATUS;
            JOClosedStatus = BilingualDisplayTerms.JO_AR_CLOSED_STATUS;
            JOFinishedStatus = BilingualDisplayTerms.JO_AR_FINISHED_STATUS;
            JOOnholdStatus = BilingualDisplayTerms.JO_EN_ONHOLD_STATUS;
            JOAssignedStatus = BilingualDisplayTerms.JO_EN_ASSIGNED_STATUS;
        }

        switch (operation) {
            case 1:
                servedPage = "/docs/new_search/search_maintenance_details.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                Vector projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();

                request.setAttribute("allTrade", allTrade);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("allSites", projects);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
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
               
                //ConfigFileMgr configFileMgr = new ConfigFileMgr();
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

                    String issueStatusLabel = "";
                    if (issueStatus.equals("Assigned")) {
                        issueStatusLabel = JOAssignedStatus;
                        tempStatus = " - " + JOOpenStatus;
                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));

                        if (actualBeginDate != null) {
                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);

                        }

                    } else if (issueStatus.equals("Canceled")) {
                        issueStatusLabel = JOCanceledStatus;
                        tempStatus = " - " + JOCancelStatus;
                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);

                    } else {
                        issueStatusLabel = JOFinishedStatus;
                        tempStatusBegin = " - " + JOOpenStatus;
                        tempStatusEnd = " - " + JOCloseStatus;
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
                        typeOfSchedule = JOEmrgencyStatus;//configFileMgr.getJobOrderType("Emergency");
                    } else {
                        temp1 = (String) wbo.getAttribute("issueTitle");
                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
                    }

                    wbo.setAttribute("issueStatus", issueStatusLabel/*configFileMgr.getJobOrderTypeByCurrentLanguage(issueStatus)*/);
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
                String url = "ReportsServletThree?op=selectEquipment";
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
                servedPage = "/docs/new_search/equipments_list.jsp";
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
                url = "ReportsServletThree?op=selectItems";
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

                servedPage = "/docs/new_search/items_list2.jsp";

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
                servedPage = "/docs/new_search/search_equipments_with_reading.jsp";
                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("page", servedPage);
                request.setAttribute("allSites", projects);
                this.forwardToServedPage(request, response);
                break;

            case 6:
                servedPage = "/docs/new_search/select_multi_equipment.jsp";
                formName = request.getParameter("formName");
                String sites = request.getParameter("sites");
                String ids = request.getParameter("idsValues").trim();
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
                    sites = projectMgr.getMainProjectsStrByUser(
                            securityUser.getUserId());

                }

                Vector equip = new Vector();
                if (ids != null && !ids.equals("")) {
                    equip = maintainableMgr.getEquipBySiteAndTypeRateAndId(arrIds, sites, arrTypeOfRate);
                } else {
                    equip = maintainableMgr.getEquipBySitesAndTypeRate(sites, arrTypeOfRate);
                }

                count = 0;
                url = "ReportsServletThree?op=selectEquipments";
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

                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 7:
                servedPage = "/docs/new_search/result_equipments_with_reading.jsp";
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
                servedPage = "/docs/new_search/search_equipments_not_updated.jsp";
                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                ArrayList allBrand = parentUnitMgr.getCashedTableAsBusObjects();

                request.setAttribute("source", (String) request.getAttribute("source"));
                request.setAttribute("allSites", projects);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
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
                arrSites = sites.trim().split(",");

                if (source != null && source.equalsIgnoreCase("getUpdateReadingsOfEquipmentsForm")) { // updating readings of equipments
                    searchBy = request.getParameter("radioMain");
                    if (searchBy == null) {
                        searchBy = request.getParameter("searchBy");
                    }

                    if (searchBy.equals("2")) { // selected equipments was selected
                        arrIds = ids.trim().split(" ");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(sites, interval, arrTypeOfRate, arrIds, null, null);

                        request.setAttribute("filterType", "equip");
                        request.setAttribute("filterValue", maintainableMgr.getUnitsName(arrIds));
                    } else if (searchBy.equals("1")) { // brand was selected
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(sites, interval, arrTypeOfRate, null, null, strBrand.trim());

                        request.setAttribute("filterType", "brand");
                        request.setAttribute("filterValue", parentUnitMgr.getParensName(strBrand.trim().split(" ")));
                    } else { // main type was selected
                        String[] arrMainType = type.split(" ");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(sites, interval, arrTypeOfRate, null, arrMainType, null);

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
                    url = "ReportsServletThree?op=resultSearchEquipmentsNotUpdated";
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

                    servedPage = "/docs/new_search/update_readings_of_equipments.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } else { // create PDF report

                    Map result = new HashMap();
                    String filterValueStr = new String();
                    Vector filterValueVec = new Vector();

                    if (ids != null && !ids.equals("null")) {
                        arrIds = ids.trim().split(" ");
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(sites, interval, arrTypeOfRate, arrIds, null, null);
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
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(sites, interval, arrTypeOfRate, null, null, strBrand.trim());

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
                        equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsNotUpdated(sites, interval, arrTypeOfRate, null, arrMainType, null);

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

                    String empName = null;
                    maintainableMgr = MaintainableMgr.getInstance();
                    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
                    WebBusinessObject empInfo = new WebBusinessObject();
                    WebBusinessObject unitInfo = new WebBusinessObject();
                    WebBusinessObject siteInfo = new WebBusinessObject();
                    projectMgr = ProjectMgr.getInstance();
                    while (it.hasNext()) {
                        wbo = (WebBusinessObject) it.next();
                        unitInfo = maintainableMgr.getOnSingleKey(wbo.getAttribute("unitId").toString());
                        siteInfo = projectMgr.getOnSingleKey(unitInfo.getAttribute("site").toString());
                        try {
                            empInfo = empBasicMgr.getOnSingleKey(unitInfo.getAttribute("empID").toString());
                            if (lang.equalsIgnoreCase("Ar")) {
                                empName = empInfo.getAttribute("nameAr").toString();
                            } else {

                                empName = empInfo.getAttribute("nameEn").toString();
                            }
                        } catch (Exception e) {
                            if (lang.equalsIgnoreCase("Ar")) {
                                empName = "ظ„ط§ظٹظˆط¬ط¯";
                            } else {

                                empName = "Not found";
                            }
                        }
                        wbo.setAttribute("empName", empName);
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
                        if (siteInfo.getAttribute("mainProjId").equals("0")) {
                            wbo.setAttribute("site", siteInfo.getAttribute("projectName"));
                        } else {
                            Vector getMainSite = new Vector();
                            try {

                                getMainSite = projectMgr.getOnArbitraryKey(siteInfo.getAttribute("mainProjId").toString(), "key");
                                String mainSite = "";
                                if (lang.equalsIgnoreCase("Ar")) {
                                    mainSite = "\u0627\u0644\u0631\u0626\u064A\u0633\u0649 :" + ((WebBusinessObject) getMainSite.get(0)).getAttribute("projectName") + "\n" + " \u0627\u0644\u0641\u0631\u0639\u0649 :" + siteInfo.getAttribute("projectName");
                                } else {
                                    mainSite = "Main Site :" + ((WebBusinessObject) getMainSite.get(0)).getAttribute("projectName") + "\n Branch :" + siteInfo.getAttribute("projectName");
                                }
                                wbo.setAttribute("site", mainSite);

                            } catch (SQLException ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                        objects.add(wbo);
                    }

                    String siteValueStr = new String();
                    if (siteAll.equals("yes")) {
                        siteValueStr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
                    } else {
                        Vector siteValueVec = projectMgr.getProjectsName(sites);
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
                servedPage = "/docs/new_search/main_report_cost_form.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", "0");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                servedPage = "/docs/new_search/main_report_cost_form.jsp";
                if (request.getSession().getAttribute("tabId") == null) {
                    request.getSession().setAttribute("tabId", "0");
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 12:
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                String single = request.getParameter("single");

                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();
                if (single != null) {
                    servedPage = "/docs/new_search/search_avg_cost_jo_1.jsp";
                } else {
                    servedPage = "/docs/new_search/search_avg_cost_jo.jsp";
                }
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", projects);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
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

            case 13:
                joTitle = request.getParameter("joTitle");
                IssueTitle issueTitleEnum;

                if (joTitle.equals("normal")) {
                    servedPage = "/docs/new_search/resualt_avg_cost_normal_jo.jsp";
                    issueTitleEnum = IssueTitle.Emergency;
                } else {
                    servedPage = "/docs/new_search/resualt_avg_cost_schedule_jo.jsp";
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
                servedPage = "/docs/new_search/search_equipments_by_schedule.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 15:
//                String pageName = request.getParameter("pageName");
//
//                if (pageName == null) {
//                    servedPage = "/docs/new_search/result_equipments_by_schedule_grouping.jsp";
//                } else {
//                    servedPage = "/docs/new_search/" + pageName + ".jsp";
//                }
//                ids = request.getParameter("ids").trim();
//                arrIds = ids.split(" ");
//
//                Vector allSchedules;
//                Vector allEquipments;
//
//                //get Equipments
//                if (ids != null && !ids.equals("")) {
//                    allEquipments = maintainableMgr.getEquipmentsByIds(arrIds);
//                } else {
//                    try {
//                        allEquipments = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                        allEquipments = new Vector();
//                    }
//                }
//
//                WebBusinessObject wboEquipments;
//                for (int i = 0; i < allEquipments.size(); i++) {
//                    wboEquipments = (WebBusinessObject) allEquipments.get(i);
//                    unitId = (String) wboEquipments.getAttribute("id");
//
//                    try {
//                        allSchedules = allScheduleByHistoryMgr.getOnArbitraryKey(unitId, "key1");
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                        allSchedules = new Vector();
//                    }
//
//                    wboEquipments.setAttribute("allSchedules", allSchedules);
//                }
//
//                request.setAttribute("ids", ids);
//                request.setAttribute("data", allEquipments);
//                this.forward(servedPage, request, response);
                break;

            case 16:
                session.removeAttribute("data");
                session.removeAttribute("headers");
                session.removeAttribute("attributeType");
                session.removeAttribute("attribute");
                response.getWriter().write("ok");
                break;

            case 17:
//                excelCreator = new ExcelCreator();
//                String filename = request.getParameter("filename");
//                Vector data = (Vector) session.getAttribute("data");
//                String[] headers = (String[]) session.getAttribute("headers");
//                String[] attributeType = (String[]) session.getAttribute("attributeType");
//                String[] attribute = (String[]) session.getAttribute("attribute");
//
//                workbook = excelCreator.createExcelFile(headers, attribute, attributeType, data, 0);
//                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename);
//                workbook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
                break;

            case 18:
//                excelCreator = new ExcelCreator(true);
//                WebBusinessObject wboEquipment;
//                filename = request.getParameter("filename");
//                data = (Vector) session.getAttribute("data");
//                headers = (String[]) session.getAttribute("headers");
//                attributeType = (String[]) session.getAttribute("attributeType");
//                attribute = (String[]) session.getAttribute("attribute");
//
//                workbook = new HSSFWorkbook();
//                String beforHeader;
//
//                for (int i = 0; i < data.size(); i++) {
//                    wboEquipment = (WebBusinessObject) data.get(i);
//                    allSchedules = (Vector) wboEquipment.getAttribute("allSchedules");
//
//                    beforHeader = (String) wboEquipment.getAttribute("beforHeader");
//
//                    if (allSchedules != null && allSchedules.size() > 0) {
//                        workbook = excelCreator.createExcelFileByMultiTable(beforHeader, headers, attribute, attributeType, allSchedules, null);
//                    } else {
//                        workbook = excelCreator.createExcelFileByMultiTable(beforHeader, headers, attribute, attributeType, allSchedules, "Not Found Schedule");
//                    }
//                }
//
//                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename);
//                workbook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
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
                servedPage = "/docs/new_search/cost_reports_from_stores.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", "0");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 23:
                servedPage = "/docs/new_search/search_jo_with_labor.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();

                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", projects);
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
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                if (single != null) {
                    servedPage = "/docs/new_search/MainTypesCostReportForm_1.jsp";
                } else {
                    servedPage = "/docs/new_search/MainTypesCostReportForm.jsp";
                }
//                ArrayList departments = departmentMgr.getCashedTableAsBusObjects();
//                ArrayList productionLines = productionLineMgr.getCashedTableAsBusObjects();
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allSites", projects);
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
                servedPage = "/docs/new_search/search_Deserve_Schedules.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 28:
//                interval = Integer.parseInt(request.getParameter("deserveBefore"));
//                data = new Vector();
//                if (request.getParameter("interval").equals("before")) {
//                    data = unitScheduleMgr.getSchedulesBeforeOrAfterDate(request.getParameter("unitId"), request.getParameter("scheduleId"), interval, 0);
//                } else {
//                    data = unitScheduleMgr.getSchedulesBeforeOrAfterDate(request.getParameter("unitId"), request.getParameter("scheduleId"), 0, interval);
//                }
//                WebBusinessObject tempWbo;
//                for (int i = 0; i < data.size(); i++) {
//                    tempWbo = (WebBusinessObject) data.get(i);
//                    tempWbo.setAttribute("currentReading", averageUnitMgr.getOnSingleKey1((String) tempWbo.getAttribute("unitId")).getAttribute("current_Reading"));
//                    tempWbo.setAttribute("IssueCode", issueMgr.getOnSingleKey("key3", (String) unitScheduleMgr.getUnitScheduleForScheduleDeserve((String) tempWbo.getAttribute("unitId"), (String) tempWbo.getAttribute("periodicId"), (String) tempWbo.getAttribute("beginDate")).getAttribute("id")).getAttribute("businessID"));
//                }
//                servedPage = "/docs/reports/result_schedules_beforeOrAfter.jsp";
//                request.setAttribute("data", data);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
                break;
            case 29:
                parents = maintainableMgr.getAllParentsOrderByName();
                servedPage = "/docs/new_search/SparePArtsByEquip.jsp";
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 30:
                servedPage = "docs/new_search/form_details.jsp";
                SelfDocMgr selfDocMgr = SelfDocMgr.getInstance();
                Vector<WebBusinessObject> formsWbo = new Vector<WebBusinessObject>();
                String formCode = request.getParameter("formCode");
                formsWbo = selfDocMgr.getFormsList(formCode);
                request.setAttribute("formsWbo", formsWbo);
                this.forward(servedPage, request, response);
                break;
            case 31:
                String goToViewEquipment = null;
                try {
                    goToViewEquipment = request.getParameter("goToViewEquipment");
                } catch (Exception e) {
                    goToViewEquipment = null;
                }
                if (goToViewEquipment == null) {
                    servedPage = "/docs/new_search/equipment_list.jsp";
                } else {
                    servedPage = "/docs/new_search/equipment_list_search.jsp";
                }
                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                Vector schedules = new Vector();
                //String[] sitesAll = request.getParameterValues("site");
                String sites_all = request.getParameter("site");//Tools.concatenation(sitesAll, ",");

                filter = Tools.getPaginationInfoBySites(request, response, sites_all);
                //IS_MAINTAINABLE='1' and IS_DELETED ='0'
                List<FilterCondition> conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());
                // add conditions
                conditions.add(new FilterCondition("IS_MAINTAINABLE", "1", Operations.EQUAL));

                conditions.add(new FilterCondition("IS_DELETED", "0", Operations.EQUAL));

                filter.setConditions(conditions);
                maintainableMgr = MaintainableMgr.getInstance();
                List<WebBusinessObject> scheduleLists = new ArrayList<WebBusinessObject>(0);

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

                formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }

                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("scheduleList", scheduleLists);
                this.forward(servedPage, request, response);
                break;

            case 32:
                servedPage = "/docs/new_search/search_brand_schedules.jsp";
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
            case 36:
                servedPage = "/docs/new_search/spare_parts_list.jsp";
                com.silkworm.pagination.Filter filters = new com.silkworm.pagination.Filter();
                schedules = new Vector();
                //String[] sitesAll = request.getParameterValues("site");
                //String sites_all = request.getParameter("site");//Tools.concatenation(sitesAll, ",");
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

            case 37:
                servedPage = "/docs/reports/equipment_status_report_form.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 38:

                servedPage = "/docs/reports/equipment_status_report.jsp";
                WebBusinessObject unitWbo = null;
                WebBusinessObject eqpStatusWbo = null;
                Vector eqpStatusVec = null;
                String jsonText = null;
                List dataList = new ArrayList();
                List dataEntryList = null;
                String beginDateStr = null;
                String statusId = null;
                Date bDate = null;

                DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");

                unitId = request.getParameter("unitId");

                unitWbo = maintainableMgr.getOnSingleKey(unitId);
                eqpStatusVec = equipmentStatusMgr.getEquipStatusHistory(unitId);

                // populate series data map
                for (int i = 0; i < eqpStatusVec.size(); i++) {
                    dataEntryList = new ArrayList();
                    eqpStatusWbo = (WebBusinessObject) eqpStatusVec.get(i);

                    beginDateStr = (String) eqpStatusWbo.getAttribute("beginDate");

                    try {
                        bDate = dateFormatter.parse(beginDateStr);
                    } catch (ParseException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).
                                log(Level.SEVERE, null, ex);
                    }

                    statusId = (String) eqpStatusWbo.getAttribute("stateID");

                    dataEntryList.add(bDate.getTime());
                    dataEntryList.add(
                            // invert status IDs for charting purposes
                            (statusId.equals("1")) ? 2 : 1);

                    dataList.add(dataEntryList);
                }

                // convert data list to JSON string
                jsonText = JSONValue.toJSONString(dataList);

                request.setAttribute("unitName", unitWbo.getAttribute("unitName"));
                request.setAttribute("jsonText", jsonText);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);

                break;

            case 39:
                servedPage = "/docs/reports/department_complaints_distribution_rates.jsp";
                Vector complaintCountsVec = issueByComplaintMgr.getComplaintCountPerDepartment();

                if (!complaintCountsVec.isEmpty()) {

                    jsonText = null;
                    dataList = new ArrayList();
                    Map dataEntryMap = new HashMap();
                    WebBusinessObject complaintCountWbo = null;
                    String complaintCountStr = null;
                    int totalComplaintsCount = 0;

                    // populate series data map
                    for (int i = 0; i < complaintCountsVec.size(); i++) {
                        dataEntryMap = new HashMap();
                        complaintCountWbo = (WebBusinessObject) complaintCountsVec.get(i);

                        complaintCountStr = (String) complaintCountWbo.getAttribute("complaintCount");
                        totalComplaintsCount += Integer.parseInt(complaintCountStr);

                        dataEntryMap.put("name", complaintCountWbo.getAttribute("departmentName"));
                        dataEntryMap.put("y", new Integer(complaintCountStr));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalComplaintsCount", totalComplaintsCount);
                    request.setAttribute("complaintCountsVec", complaintCountsVec);
                    request.setAttribute("jsonText", jsonText);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 40:
                servedPage = "docs/reports/followUpReportMaintenanceItems.jsp";
                allTrade = tradeMgr.getAllAsArrayList();
                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                parents = maintainableMgr.getAllParentsOrderByName();

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", projects);
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 41:
                servedPage = "docs/new_report/tasks_tree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 42:
                servedPage = "docs/new_report/items_tree.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 43:

                projects = new Vector();

                try {
                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");

                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                ArrayList locationsList = new ArrayList();
                for (int i = 0; i < projects.size(); i++) {
                    locationsList.add(projects.get(i));
                }

                servedPage = "/docs/new_search/deviations_in_equipments_readings.jsp";

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("allSites", locationsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 45:
                servedPage = "/docs/reports/equipment_failure_report_form.jsp";
                this.forward(servedPage, request, response);
                break;

            case 46:

                servedPage = "/docs/reports/equipment_failure_report.jsp";
                // populate series data map
                unitWbo = null;
                eqpStatusWbo = null;
                eqpStatusVec = null;
                jsonText = null;
                dataList = new ArrayList();
                dataEntryList = null;
                beginDateStr = null;
                String endDateString = null;
                statusId = null;
                bDate = null;
                Date eDate = null;

                dateFormatter = new SimpleDateFormat("yyyy-MM-dd");

                unitId = request.getParameter("unitId");//"1247051452457";

                unitWbo = maintainableMgr.getOnSingleKey(unitId);
                eqpStatusVec = equipmentStatusMgr.getEquipStatusHistory(unitId);

                Map dataEntryMap = new HashMap();
                int totalComplaintsCount = 0;

                double totalWork = 0;
                double totalFaiuler = 0;
                // populate series data map
                for (int i = 0; i < eqpStatusVec.size(); i++) {

                    eqpStatusWbo = (WebBusinessObject) eqpStatusVec.get(i);

                    beginDateStr = (String) eqpStatusWbo.getAttribute("beginDate");
                    endDateString = (String) eqpStatusWbo.getAttribute("endDate");
                    if (endDateString == null) {
                        Date date = new Date();
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd");
                        endDateString = sdf.format(date).toString();
                    }
                    try {
                        bDate = dateFormatter.parse(beginDateStr);
                        eDate = dateFormatter.parse(endDateString);
                    } catch (ParseException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).
                                log(Level.SEVERE, null, ex);
                    }

                    statusId = (String) eqpStatusWbo.getAttribute("stateID");
                    //totalComplaintsCount += Integer.parseInt(complaintCountStr);
                    if (statusId.equals("1")) {
                        totalWork += Math.abs(Double.parseDouble((eDate.getTime() - bDate.getTime()) + ""));
                    } else {
                        totalFaiuler += Math.abs(Double.parseDouble((eDate.getTime() - bDate.getTime()) + ""));
                    }

                }
                dataEntryMap = new HashMap();
                dataEntryMap.put("name", "Work");
                dataEntryMap.put("y", totalWork);
                dataList.add(dataEntryMap);

                dataEntryMap = new HashMap();
                dataEntryMap.put("name", "Out of Work");
                dataEntryMap.put("y", totalFaiuler);
                dataList.add(dataEntryMap);

                // convert data list to JSON string
                jsonText = JSONValue.toJSONString(dataList);

                request.setAttribute("unitName", unitWbo.getAttribute("unitName"));
                request.setAttribute("jsonText", jsonText);
                request.setAttribute("totalComplaintsCount", totalComplaintsCount);
                this.forward(servedPage, request, response);

                break;

            case 47:
                servedPage = "/docs/new_search/search_schedules.jsp";

                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                parents = maintainableMgr.getAllParentsOrderByName();

                request.setAttribute("allMainType", allMainType);
                request.setAttribute("parents", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 48:
                servedPage = "/docs/reports/call_ratio.jsp";
                Vector CallCountsVec = new Vector();

                try {
                    CallCountsVec = issueMgr.getCallCountPerDepartment(request.getParameter("userID"));
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (!CallCountsVec.isEmpty()) {

                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    WebBusinessObject complaintCountWbo = null;
                    String callCountStr = null;
                    int totalCallsCount = 0;

                    // populate series data map
                    for (int i = 0; i < CallCountsVec.size(); i++) {
                        dataEntryMap = new HashMap();
                        complaintCountWbo = (WebBusinessObject) CallCountsVec.get(i);

                        callCountStr = (String) complaintCountWbo.getAttribute("callCount");
                        totalCallsCount += Integer.parseInt(callCountStr);

                        dataEntryMap.put("name", complaintCountWbo.getAttribute("callType"));
                        dataEntryMap.put("y", new Integer(callCountStr));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalComplaintsCount", totalCallsCount);
                    request.setAttribute("complaintCountsVec", CallCountsVec);
                    request.setAttribute("jsonText", jsonText);
                }
                request.setAttribute("usersList", userMgr.getUserList());
                request.setAttribute("userID", request.getParameter("userID") != null ? request.getParameter("userID") : "");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 49:
                servedPage = "/docs/reports/choose_department.jsp";
                Vector department;
                try {
                    department = projectMgr.getOnArbitraryKeyOracle("div", "key6");
                } catch (Exception ex) {
                    department = new Vector();
                }
                request.setAttribute("allMainType", department);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 50:
                servedPage = "/docs/reports/request_ratio.jsp";
                Vector requestCountsVec = new Vector();
                String projectName = request.getParameter("pName");
                try {
                    requestCountsVec = issueMgr.getRequestCountPerDepartment(projectName);

                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (!requestCountsVec.isEmpty()) {

                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    WebBusinessObject complaintCountWbo = null;
                    String callCountStr = null;
                    int totalCallsCount = 0;

                    // populate series data map
                    for (int i = 0; i < requestCountsVec.size(); i++) {
                        dataEntryMap = new HashMap();
                        complaintCountWbo = (WebBusinessObject) requestCountsVec.get(i);

                        callCountStr = (String) complaintCountWbo.getAttribute("request_count");
                        totalCallsCount += Integer.parseInt(callCountStr);

                        dataEntryMap.put("name", complaintCountWbo.getAttribute("type_name"));
                        dataEntryMap.put("y", new Integer(callCountStr));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalComplaintsCount", totalCallsCount);
                    request.setAttribute("complaintCountsVec", requestCountsVec);
                    request.setAttribute("jsonText", jsonText);
                }
                request.setAttribute("projectName", projectName);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 51:
                servedPage = "/docs/reports/products_ratio_per_region.jsp";
                Vector productCountsVec = new Vector();
                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                try {
                    productCountsVec = clientProductMgr.getProductsRatioPerRegion();
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (!productCountsVec.isEmpty()) {

                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    WebBusinessObject complaintCountWbo = null;
                    String callCountStr = null;
                    int totalCallsCount = 0;

                    // populate series data map
                    for (int i = 0; i < productCountsVec.size(); i++) {
                        dataEntryMap = new HashMap();
                        complaintCountWbo = (WebBusinessObject) productCountsVec.get(i);

                        callCountStr = (String) complaintCountWbo.getAttribute("productCount");
                        totalCallsCount += Integer.parseInt(callCountStr);

                        dataEntryMap.put("name", complaintCountWbo.getAttribute("region"));
                        dataEntryMap.put("y", new Integer(callCountStr));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalProductsCount", totalCallsCount);
                    request.setAttribute("jsonText", jsonText);
                }

                request.setAttribute("productCountsVec", productCountsVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 52:
                servedPage = "/docs/reports/products_ratio.jsp";
                productCountsVec = new Vector();
                clientProductMgr = ClientProductMgr.getInstance();
                try {
                    productCountsVec = clientProductMgr.getProductsRatio(request.getParameter("startDate"), request.getParameter("endDate"));
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (!productCountsVec.isEmpty()) {

                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    WebBusinessObject complaintCountWbo = null;
                    String callCountStr = null;
                    int totalCallsCount = 0;

                    // populate series data map
                    for (int i = 0; i < productCountsVec.size(); i++) {
                        dataEntryMap = new HashMap();
                        complaintCountWbo = (WebBusinessObject) productCountsVec.get(i);

                        callCountStr = (String) complaintCountWbo.getAttribute("productCount");
                        totalCallsCount += Integer.parseInt(callCountStr);

                        dataEntryMap.put("name", complaintCountWbo.getAttribute("productName"));
                        dataEntryMap.put("y", new Integer(callCountStr));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalProductsCount", totalCallsCount);
                    request.setAttribute("productCountsVec", productCountsVec);
                    request.setAttribute("jsonText", jsonText);
                }

                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 53:
                servedPage = "/docs/reports/campaign_clients_rates.jsp";
                CampaignMgr campaignMgr = CampaignMgr.getInstance();

                String campaignType = request.getParameter("campaignType");
                ArrayList<WebBusinessObject> campaignClientsCounts = new ArrayList<WebBusinessObject>();
                dataList = new ArrayList();
                int totalClientsCount = 0;
                String startDateS = request.getParameter("startDate");
                String endDateS = request.getParameter("endDate");
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (endDateS == null) {
                    endDateS = sdf.format(cal.getTime());
                }
                if (startDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    startDateS = sdf.format(cal.getTime());
                }

                DecimalFormat df = new DecimalFormat("#");
                double tempPercent;
                UserCampaignConfigMgr userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
                if (campaignType != null) {
                    switch (campaignType) {
                        case "activeCampaign":
                            campaignClientsCounts = campaignMgr.getClientsCountPerActiveCampaign(startDateS, endDateS,
                                    userCampaignConfigMgr.getAllUserCampaignIDs((String) persistentUser.getAttribute("userId")));
                            break;
                        case "allCampaign":
                            campaignClientsCounts = campaignMgr.getClientsCountPerCampaign(startDateS, endDateS, "grpCamp",
                                    userCampaignConfigMgr.getAllUserCampaignIDs((String) persistentUser.getAttribute("userId")));
                            break;
                        case "mainCampaign":
                            campaignClientsCounts = campaignMgr.getClientsCountPerMainCampaign(startDateS, endDateS,
                                    userCampaignConfigMgr.getAllUserCampaignIDs((String) persistentUser.getAttribute("userId")));
                            break;
                        default:
                            break;
                    }
                    if (!campaignClientsCounts.isEmpty()) {
                        // populate series data map
                        for (WebBusinessObject clientCountWbo : campaignClientsCounts) {
                            tempPercent = Double.valueOf(clientCountWbo.getAttribute("soldCount") + "") / Double.valueOf(clientCountWbo.getAttribute("clientCount") + "") * 100.0;
                            clientCountWbo.setAttribute("percent", df.format(tempPercent));
                            dataEntryMap = new HashMap();
                            totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));

                            dataEntryMap.put("name", clientCountWbo.getAttribute("campaignTitle"));
                            dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));

                            dataList.add(dataEntryMap);
                        }
                    }
                } else {
                    campaignClientsCounts = campaignMgr.getClientsCountPerCampaign(startDateS, endDateS, "grpCamp",
                            userCampaignConfigMgr.getAllUserCampaignIDs((String) persistentUser.getAttribute("userId")));
                    if (!campaignClientsCounts.isEmpty()) {
                        // populate series data map
                        for (WebBusinessObject clientCountWbo : campaignClientsCounts) {
                            tempPercent = Double.valueOf(clientCountWbo.getAttribute("soldCount") + "") / Double.valueOf(clientCountWbo.getAttribute("clientCount") + "") * 100.0;
                            clientCountWbo.setAttribute("percent", df.format(tempPercent));
                            dataEntryMap = new HashMap();
                            totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));

                            dataEntryMap.put("name", clientCountWbo.getAttribute("campaignTitle"));
                            dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));

                            dataList.add(dataEntryMap);
                        }
                    }
                }

                if ("true".equals(request.getParameter("excel"))) {
                    StringBuilder title = new StringBuilder("Campaign Effectiveness");
                    if (!request.getParameter("startDate").isEmpty()) {
                        title.append(" From : ").append(request.getParameter("startDate"));
                    }
                    if (!request.getParameter("endDate").isEmpty()) {
                        title.append(" To : ").append(request.getParameter("endDate"));
                    }
                    String headers[] = {"#", "Campaign Name", "Clients Count", "Sold Count", "Campaign Effectiveness %"};
                    String attributes[] = {"Number", "campaignTitle", "clientCount", "soldCount", "percent"};
                    String dataTypes[] = {"", "String", "String", "String", "String"};
                    String[] headerStr = new String[1];
                    headerStr[0] = title.toString();
                    HSSFWorkbook workBook = Tools.createExcelReport("Campaign Effectiveness", headerStr, null, headers, attributes, dataTypes, campaignClientsCounts);
                    Calendar c = Calendar.getInstance();
                    Date fileDate = c.getTime();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    String reportDate = sdf.format(fileDate);
                    String filename = "CampaignEffectiveness" + reportDate;
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
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    campaignMgr = CampaignMgr.getInstance();
                    ArrayList<WebBusinessObject> campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(null, null, request.getParameter("statusID"),
                            (String) persistentUser.getAttribute("userId"), null, false));
                    ArrayList<String> campaignIDsList = new ArrayList<>();
                    for (WebBusinessObject campaignWbo : campaignsList) {
                        campaignIDsList.add((String) campaignWbo.getAttribute("id"));
                    }
                    request.setAttribute("campaignIDsList", campaignIDsList);

                    request.setAttribute("totalClientsCount", totalClientsCount);
                    request.setAttribute("campaignClientsCounts", campaignClientsCounts);
                    request.setAttribute("jsonText", jsonText);

                    request.setAttribute("campaignType", campaignType);
                    request.setAttribute("startDate", startDateS);
                    request.setAttribute("endDate", endDateS);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
            case 54:
                servedPage = "/docs/reports/complaints_distribution_project.jsp";
                DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
                ArrayList<WebBusinessObject> complaintsDistributionCounts = distributionListMgr.getComplaintsPerProject(request.getParameter("projectID"), request.getParameter("ticketType"), request.getParameter("startDate"), request.getParameter("endDate"));

                if (!complaintsDistributionCounts.isEmpty()) {
                    dataList = new ArrayList();
                    totalComplaintsCount = 0;

                    // populate series data map
                    for (WebBusinessObject clientCountWbo : complaintsDistributionCounts) {
                        dataEntryMap = new HashMap();
                        totalComplaintsCount += Integer.parseInt((String) clientCountWbo.getAttribute("complaintCount"));

                        dataEntryMap.put("name", clientCountWbo.getAttribute("complaint"));
                        dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("complaintCount")));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalComplaintsCount", totalComplaintsCount);
                    request.setAttribute("complaintsDistributionCounts", complaintsDistributionCounts);
                    request.setAttribute("jsonText", jsonText);
                }
                ArrayList<WebBusinessObject> projectPerformanceCounts = distributionListMgr.getProjectPerformance(request.getParameter("projectID"), request.getParameter("ticketType"), request.getParameter("startDate"), request.getParameter("endDate"));
                if (!projectPerformanceCounts.isEmpty()) {
                    dataList = new ArrayList();
                    totalComplaintsCount = 0;

                    // populate series data map
                    for (WebBusinessObject clientCountWbo : projectPerformanceCounts) {
                        dataEntryMap = new HashMap();
                        totalComplaintsCount += Integer.parseInt((String) clientCountWbo.getAttribute("complaintCount"));
                        if (clientCountWbo.getAttribute("urgency") != null && ((String) clientCountWbo.getAttribute("urgency")).equalsIgnoreCase("1")) {
                            dataEntryMap.put("name", "Normal");
                        } else {
                            dataEntryMap.put("name", "Urgent");
                        }
                        dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("complaintCount")));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalPerformanceCount", totalComplaintsCount);
                    request.setAttribute("projectPerformanceCounts", projectPerformanceCounts);
                    request.setAttribute("jsonPerformanceText", jsonText);
                }
                ArrayList<WebBusinessObject> projectsList = new ArrayList<WebBusinessObject>();
                try {
                    projectsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                // to get user department
                WebBusinessObject managerWbo = userMgr.getManagerByEmployeeID(securityUser.getUserId());
                String departmentID = "";
                ArrayList<WebBusinessObject> ticketTypes = new ArrayList<>();
                try {
                    if (managerWbo != null) {
                        departmentID = (String) managerWbo.getAttribute("fullName");
                        ArrayList<WebBusinessObject> departmentList;
                        departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
                        if (departmentList.size() > 0) {
                            departmentID = (String) departmentList.get(0).getAttribute("projectID");
                        }
                    } else {
                        ArrayList<WebBusinessObject> departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle(securityUser.getUserId(), "key5"));
                        if (departmentList.size() > 0) {
                            departmentID = (String) departmentList.get(0).getAttribute("projectID");
                        }
                    }
                    ticketTypes = IssueByComplaintAllCaseMgr.getInstance().getStatusTypesByDepart(departmentID);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("ticketTypes", ticketTypes);
                request.setAttribute("projectsList", projectsList);
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("ticketType", request.getParameter("ticketType"));
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 55:
                servedPage = "/docs/reports/project_performance.jsp";
                distributionListMgr = DistributionListMgr.getInstance();
                projectPerformanceCounts = distributionListMgr.getProjectPerformance(request.getParameter("projectID"), request.getParameter("ticketType"), request.getParameter("startDate"), request.getParameter("endDate"));

                if (!projectPerformanceCounts.isEmpty()) {
                    dataList = new ArrayList();
                    totalComplaintsCount = 0;

                    // populate series data map
                    for (WebBusinessObject clientCountWbo : projectPerformanceCounts) {
                        dataEntryMap = new HashMap();
                        totalComplaintsCount += Integer.parseInt((String) clientCountWbo.getAttribute("complaintCount"));
                        if (clientCountWbo.getAttribute("urgency") != null && ((String) clientCountWbo.getAttribute("urgency")).equalsIgnoreCase("1")) {
                            dataEntryMap.put("name", "Normal");
                        } else {
                            dataEntryMap.put("name", "Urgent");
                        }
                        dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("complaintCount")));

                        dataList.add(dataEntryMap);
                    }

                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalComplaintsCount", totalComplaintsCount);
                    request.setAttribute("projectPerformanceCounts", projectPerformanceCounts);
                    request.setAttribute("jsonText", jsonText);
                }
                projectsList = new ArrayList<WebBusinessObject>();
                try {
                    projectsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("projectsList", projectsList);
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("ticketType", request.getParameter("ticketType"));
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 56:
                servedPage = "/docs/reports/appointment_user_statistics.jsp";
                AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                ArrayList<WebBusinessObject> userAppointmentsCounts = appointmentMgr.getAppointmentsCountPerUser(request.getParameter("startDate"), request.getParameter("endDate"));
                if (!userAppointmentsCounts.isEmpty()) {
                    dataList = new ArrayList();
                    int totalAppointmentsCount = 0;
                    // populate series data map
                    for (WebBusinessObject appointmentCountWbo : userAppointmentsCounts) {
                        dataEntryMap = new HashMap();
                        totalAppointmentsCount += Integer.parseInt((String) appointmentCountWbo.getAttribute("appointmentsCount"));
                        dataEntryMap.put("name", appointmentCountWbo.getAttribute("userName"));
                        dataEntryMap.put("y", Integer.parseInt((String) appointmentCountWbo.getAttribute("appointmentsCount")));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalAppointmentsCount", totalAppointmentsCount);
                    request.setAttribute("userAppointmentsCounts", userAppointmentsCounts);
                    request.setAttribute("jsonText", jsonText);
                }
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 57:
                GroupMgr groupMgr = GroupMgr.getInstance();
                ClientMgr clientMgr = ClientMgr.getInstance();
                String groupID = request.getParameter("groupId");
                String currentYear = request.getParameter("year");
                String currentQuarter = request.getParameter("quarter");
                ArrayList<String> years = new ArrayList<String>();
                Calendar c = Calendar.getInstance();
                for (int year = 1990; year <= c.get(Calendar.YEAR); year++) {
                    years.add(year + "");
                }
                servedPage = "/docs/reports/productivity_by_group.jsp";
                if (groupID != null && currentQuarter != null) {
                    String startDate = "01/01/" + currentYear;
                    if (currentQuarter.equals("2")) {
                        startDate = "01/04/" + currentYear;
                    } else if (currentQuarter.equals("3")) {
                        startDate = "01/07/" + currentYear;
                    } else if (currentQuarter.equals("4")) {
                        startDate = "01/10/" + currentYear;
                    }
                    request.setAttribute("productivityList", clientMgr.getProductivityByGroup(groupID, startDate));
                }

                //get logged user groups
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                UserGroupConfigMgr userGroupCongMgr = UserGroupConfigMgr.getInstance();

                Vector groups = new Vector();
                try {
                    Vector userGroups = userGroupCongMgr.getOnArbitraryKey(loggedUser.getAttribute("userId").toString(), "key2");
                    if (userGroups.size() > 0 && userGroups != null) {
                        for (int i = 0; i < userGroups.size(); i++) {
                            WebBusinessObject userGroupsWbo = (WebBusinessObject) userGroups.get(i);
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groups.add(groupWbo);
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("groups", groups);
                request.setAttribute("years", years);
                request.setAttribute("year", currentYear);
                request.setAttribute("quarter", currentQuarter);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 58:
                clientMgr = ClientMgr.getInstance();
                String userId = request.getParameter("userId");
                currentYear = request.getParameter("year");
                currentQuarter = request.getParameter("quarter");
                years = new ArrayList<String>();
                c = Calendar.getInstance();
                for (int year = 1990; year <= c.get(Calendar.YEAR); year++) {
                    years.add(year + "");
                }
                servedPage = "/docs/reports/productivity_by_user.jsp";
                if (userId != null && currentQuarter != null) {
                    String startDate = "01/01/" + currentYear;
                    if (currentQuarter.equals("2")) {
                        startDate = "01/04/" + currentYear;
                    } else if (currentQuarter.equals("3")) {
                        startDate = "01/07/" + currentYear;
                    } else if (currentQuarter.equals("4")) {
                        startDate = "01/10/" + currentYear;
                    }
                    request.setAttribute("productivityList", clientMgr.getProductivityByUser(userId, startDate));
                }
                request.setAttribute("users", userMgr.getCashedTable());
                request.setAttribute("years", years);
                request.setAttribute("year", currentYear);
                request.setAttribute("quarter", currentQuarter);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 59:
                clientMgr = ClientMgr.getInstance();
                userId = request.getParameter("userId");
                currentYear = request.getParameter("year");
                currentQuarter = request.getParameter("quarter");
                years = new ArrayList<String>();
                c = Calendar.getInstance();
                for (int year = 1990; year <= c.get(Calendar.YEAR); year++) {
                    years.add(year + "");
                }
                servedPage = "/docs/reports/appointments_by_user.jsp";
                if (userId != null && currentQuarter != null) {
                    String startDate = "01/01/" + currentYear;
                    if (currentQuarter.equals("2")) {
                        startDate = "01/04/" + currentYear;
                    } else if (currentQuarter.equals("3")) {
                        startDate = "01/07/" + currentYear;
                    } else if (currentQuarter.equals("4")) {
                        startDate = "01/10/" + currentYear;
                    }
                    request.setAttribute("appointmentsList", clientMgr.getAppointmentsByUser(userId, startDate));
                }
                request.setAttribute("users", userMgr.getCashedTable());
                request.setAttribute("years", years);
                request.setAttribute("year", currentYear);
                request.setAttribute("quarter", currentQuarter);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 60:
                CommentsMgr commentsMgr = CommentsMgr.getInstance();
                userId = request.getParameter("userId");
                currentYear = request.getParameter("year");
                currentQuarter = request.getParameter("quarter");
                years = new ArrayList<String>();
                c = Calendar.getInstance();
                for (int year = 1990; year <= c.get(Calendar.YEAR); year++) {
                    years.add(year + "");
                }
                servedPage = "/docs/reports/comments_by_user.jsp";
                if (userId != null && currentQuarter != null) {
                    String startDate = "01/01/" + currentYear;
                    if (currentQuarter.equals("2")) {
                        startDate = "01/04/" + currentYear;
                    } else if (currentQuarter.equals("3")) {
                        startDate = "01/07/" + currentYear;
                    } else if (currentQuarter.equals("4")) {
                        startDate = "01/10/" + currentYear;
                    }
                    request.setAttribute("commentsList", commentsMgr.getCommentssByUser(userId, startDate));
                }
                request.setAttribute("users", userMgr.getCashedTable());
                request.setAttribute("years", years);
                request.setAttribute("year", currentYear);
                request.setAttribute("quarter", currentQuarter);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 61:
                servedPage = "/docs/reports/response_speed_report.jsp";
                ArrayList<WebBusinessObject> clients;
                clientMgr = ClientMgr.getInstance();
                String fromDateS = request.getParameter("fromDate");
                String toDateS = request.getParameter("toDate");
                departmentID = request.getParameter("departmentID");
                String campaignID = request.getParameter("campaignID");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    clients = clientMgr.getAverageResponseSpeed(fromDateD, toDateD, departmentID, campaignID);
                } else {
                    clients = new ArrayList<>();
                }
                UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();

                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    ArrayList<WebBusinessObject> departmentsList = new ArrayList<>();
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departmentsList.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }
                    request.setAttribute("departmentsList", departmentsList);
                } catch (Exception ex) {
                    request.setAttribute("departmentsList", new ArrayList<>());
                }
                try {
                    request.setAttribute("requestTypesList", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypesList", new ArrayList<>());
                }
                campaignMgr = CampaignMgr.getInstance();
                ArrayList<WebBusinessObject> campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(null, null, request.getParameter("statusID"),
                        (String) persistentUser.getAttribute("userId"), null, false));
                request.setAttribute("campaignsList", campaignsList);

                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("departmentID", departmentID);
                request.setAttribute("campaignID", campaignID);
                request.setAttribute("clients", clients);
                this.forwardToServedPage(request, response);
                break;
            case 62:
                servedPage = "/docs/reports/work_items_recurring_curve.jsp";
                String beDate = request.getParameter("beginDate");
                String enDate = request.getParameter("endDate");
                String contractorID = request.getParameter("contractorID");
                String engineerID = request.getParameter("engineerID");
                String projectID = request.getParameter("projectID");
                if (contractorID == null || contractorID.equalsIgnoreCase("all")) {
                    contractorID = "";
                }
                if (engineerID == null || engineerID.equalsIgnoreCase("all")) {
                    engineerID = "";
                }
                if (projectID == null || projectID.equalsIgnoreCase("all")) {
                    projectID = "";
                }
                if (beDate != null && enDate != null) {
                    DateParser dateParser = new DateParser();
                    java.sql.Date bSqlDate = dateParser.formatSqlDate(beDate);
                    java.sql.Date eSqlDate = dateParser.formatSqlDate(enDate);
                    RequestItemsMgr requestItemsMgr = RequestItemsMgr.getInstance();
                    ArrayList<WebBusinessObject> data = requestItemsMgr.getWorkItemsRecurringCurve(bSqlDate, eSqlDate, engineerID, contractorID, projectID);
                    StringBuilder categoryStr = new StringBuilder();
                    StringBuilder dataStr = new StringBuilder();
                    categoryStr.append("[");
                    dataStr.append("[");
                    for (WebBusinessObject wboTemp : data) {
                        if (categoryStr.length() > 1) {
                            categoryStr.append(",");
                            dataStr.append(",");
                        }
                        categoryStr.append("'").append(wboTemp.getAttribute("itemName")).append("'");
                        dataStr.append(wboTemp.getAttribute("total"));
                    }
                    categoryStr.append("]");
                    dataStr.append("]");
                    request.setAttribute("data", data);
                    request.setAttribute("categoryStr", categoryStr.toString());
                    request.setAttribute("dataStr", dataStr.toString());
                    request.setAttribute("endDate", enDate);
                    request.setAttribute("beginDate", beDate);
                }
                projectMgr = ProjectMgr.getInstance();
                clientMgr = ClientMgr.getInstance();
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                request.setAttribute("engineersList", userMgr.getAllEngineers());
                try {
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                }
                request.setAttribute("contractorID", contractorID);
                request.setAttribute("engineerID", engineerID);
                request.setAttribute("projectID", projectID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 63:
                servedPage = "/docs/reports/sales_chart.jsp";
                ReservationMgr reservationMgr = ReservationMgr.getInstance();
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
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                ArrayList<WebBusinessObject> employeesSalesAmountList = reservationMgr.getSalesTotalAmount(fromDate, toDate);
                ArrayList<WebBusinessObject> employeesSalesCountList = reservationMgr.getSalesTotalCount(fromDate, toDate);

                if (!employeesSalesAmountList.isEmpty()) {
                    dataList = new ArrayList();
                    String totalStr;
                    long totalCount = 0;

                    // populate series data map for amount
                    for (WebBusinessObject employeeSalesWbo : employeesSalesAmountList) {
                        dataEntryMap = new HashMap();
                        totalStr = (String) employeeSalesWbo.getAttribute("totalValue");
                        try {
                            totalCount += Long.parseLong(totalStr);
                        } catch (Exception ex) {
                        }
                        dataEntryMap.put("name", employeeSalesWbo.getAttribute("employeeName"));
                        try {
                            dataEntryMap.put("y", new Integer(totalStr));
                        } catch (Exception ex) {
                            dataEntryMap.put("y", 0);
                        }
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalAmountCount", totalCount);
                    request.setAttribute("employeesSalesAmountList", employeesSalesAmountList);
                    request.setAttribute("jsonAmountText", jsonText);
                }

                if (!employeesSalesCountList.isEmpty()) {
                    dataList = new ArrayList();
                    String totalStr;
                    long totalCount = 0;

                    // populate series data map for amount
                    for (WebBusinessObject employeeSalesWbo : employeesSalesCountList) {
                        dataEntryMap = new HashMap();
                        totalStr = (String) employeeSalesWbo.getAttribute("totalNo");
                        totalCount += Long.parseLong(totalStr);
                        dataEntryMap.put("name", employeeSalesWbo.getAttribute("employeeName"));
                        dataEntryMap.put("y", new Integer(totalStr));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalCount", totalCount);
                    request.setAttribute("employeesSalesCountList", employeesSalesCountList);
                    request.setAttribute("jsonCountText", jsonText);
                }

                request.setAttribute("fromDate", request.getParameter("fromDate"));
                request.setAttribute("toDate", request.getParameter("toDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 64:
                servedPage = "/docs/reports/campaign_agent_clients_rate.jsp";
                campaignMgr = CampaignMgr.getInstance();
                List<WebBusinessObject> employees = new ArrayList<>();
                employees = userMgr.getUsersInMyReportDepartments((String) loggedUser.getAttribute("userId"));
                String employeeID = request.getParameter("employeeID");
                if (employeeID == null) {
                    if (!employees.isEmpty()) {
                        employeeID = (String) employees.get(0).getAttribute("userId");
                    } else {
                        employeeID = "";
                    }
                }
                campaignClientsCounts = campaignMgr.getAgentClientsCountPerCampaign(employeeID,
                        request.getParameter("startDate"), request.getParameter("endDate"));
                if (!campaignClientsCounts.isEmpty()) {
                    dataList = new ArrayList();
                    totalClientsCount = 0;
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : campaignClientsCounts) {
                        dataEntryMap = new HashMap();
                        totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                        dataEntryMap.put("name", clientCountWbo.getAttribute("campaignTitle"));
                        dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalClientsCount", totalClientsCount);
                    request.setAttribute("campaignClientsCounts", campaignClientsCounts);
                    request.setAttribute("jsonText", jsonText);
                }
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("employeeID", request.getParameter("employeeID"));
                request.setAttribute("employees", employees);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 65:
                servedPage = "/docs/reports/clients_rates.jsp";

                ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
                clientMgr = ClientMgr.getInstance();

                ArrayList<WebBusinessObject> clientsCounts = clientRatingMgr.getClientsCountRate((String) loggedUser.getAttribute("userId"));
                ArrayList<WebBusinessObject> clientsTotal = new ArrayList<>(clientMgr.getCustomersClassification((String) loggedUser.getAttribute("userId"), null, null, null, null, null, null, null));

                WebBusinessObject clientWbo = new WebBusinessObject();

                dataList = new ArrayList();
                totalClientsCount = 0;
                if (!clientsCounts.isEmpty()) {
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : clientsCounts) {
                        dataEntryMap = new HashMap();
                        totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));

                        dataEntryMap.put("name", clientCountWbo.getAttribute("rateName"));
                        dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));

                        dataList.add(dataEntryMap);
                    }
                }
                clientWbo.setAttribute("clientCount", (clientsTotal.size() - totalClientsCount) + "");
                clientWbo.setAttribute("rateID", "1");
                clientWbo.setAttribute("rateName", "UnRated Clients");
                clientsCounts.add(clientWbo);
                dataEntryMap = new HashMap();
                totalClientsCount += Integer.parseInt((String) clientWbo.getAttribute("clientCount"));
                dataEntryMap.put("name", clientWbo.getAttribute("rateName"));
                dataEntryMap.put("y", Integer.parseInt((String) clientWbo.getAttribute("clientCount")));
                dataList.add(dataEntryMap);

                // convert map to JSON string
                jsonText = JSONValue.toJSONString(dataList);

                request.setAttribute("totalClientsCount", totalClientsCount);
                request.setAttribute("clientsRatesCounts", clientsCounts);
                request.setAttribute("jsonText", jsonText);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 66:
                servedPage = "/docs/reports/clients_Employee_rates.jsp";

                clientRatingMgr = ClientRatingMgr.getInstance();
                clientMgr = ClientMgr.getInstance();
                userMgr = UserMgr.getInstance();

                clientsTotal = new ArrayList<>();
                clientsCounts = new ArrayList<>();
                ArrayList<WebBusinessObject> usersList = new ArrayList<>();

                try {
                    usersList = userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId"));
                    WebBusinessObject userWbo = new WebBusinessObject();
                    userWbo.setAttribute("userId", "All");
                    userWbo.setAttribute("fullName", "All");
                    usersList.add(userWbo);

                } catch (Exception ex) {
                    System.out.println("SQL Exception on Getting user type = " + ex.getMessage());
                }

                if (request.getParameter("userID").equals("All")) {
                    clientsCounts = clientRatingMgr.getAllClientsCountRate();
                    clientsTotal = clientMgr.getAllCustomersClassification();
                } else {
                    clientsCounts = clientRatingMgr.getClientsCountRate((String) request.getParameter("userID"));
                    clientsTotal = clientMgr.getCustomersClassification((String) request.getParameter("userID"), null, null, null, null, null, null, null);
                }

                dataList = new ArrayList();
                totalClientsCount = 0;

                // populate series data map
                for (WebBusinessObject clientCountWbo : clientsCounts) {
                    dataEntryMap = new HashMap();
                    totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));

                    dataEntryMap.put("name", clientCountWbo.getAttribute("rateName"));
                    dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));

                    dataList.add(dataEntryMap);
                }
                clientWbo = new WebBusinessObject();
                clientWbo.setAttribute("clientCount", (clientsTotal.size() - totalClientsCount) + "");
                clientWbo.setAttribute("rateID", "1");
                clientWbo.setAttribute("rateName", "UnRated Clients");
                clientsCounts.add(clientWbo);
                dataEntryMap = new HashMap();
                totalClientsCount += Integer.parseInt((String) clientWbo.getAttribute("clientCount"));
                dataEntryMap.put("name", clientWbo.getAttribute("rateName"));
                dataEntryMap.put("y", Integer.parseInt((String) clientWbo.getAttribute("clientCount")));
                dataList.add(dataEntryMap);

                // convert map to JSON string
                jsonText = JSONValue.toJSONString(dataList);

                request.setAttribute("totalClientsCount", totalClientsCount);
                request.setAttribute("clientsRatesCounts", clientsCounts);
                request.setAttribute("usersList", clientsCounts);
                request.setAttribute("EmployeeList", usersList);
                request.setAttribute("userId", (String) request.getParameter("userID"));
                request.setAttribute("jsonText", jsonText);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 67:
                servedPage = "/docs/client/client_class_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                c = Calendar.getInstance();
                String toDateStr = request.getAttribute("toDate") != null ? request.getParameter("toDate") : sdf.format(c.getTime());
                c.add(Calendar.MONTH, -1);
                String fromDateStr = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(c.getTime());
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    String[] campaignIDs = request.getParameterValues("campaignID");
                    String projectIDs = request.getParameter("projectID");
                    String[] rateIDs = request.getParameterValues("rateID");
                    employeeID = request.getParameter("employeeID");
                    String clntTyp = request.getParameter("clsUncls");
                    departmentID = request.getParameter("departmentID");
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    ArrayList<WebBusinessObject> clientsList = new ArrayList<WebBusinessObject>();

                    if (clntTyp != null && clntTyp.equals("cls")) {
                        clientsList = clientRatingMgr.getClientRateInterval(fromDate, toDate,
                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null,
                                projectIDs,
                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
                        String clientCreationTime, ratingTime;
                        for (WebBusinessObject clientTempWbo : clientsList) {
                            clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                            clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                            clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                            String fAppTime = (String) clientTempWbo.getAttribute("mct");
                            ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                            ratingTime = ratingTime.substring(0, 16);
                            fAppTime = fAppTime.substring(0, 16);
                            clientTempWbo.setAttribute("creationTime", ratingTime);
                            clientTempWbo.setAttribute("mct", fAppTime);
                            try {
                                clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                            } catch (ParseException ex) {
                                clientTempWbo.setAttribute("diffDays", "---");
                            }
                        }

                        clientsCounts = clientRatingMgr.getClientRateCountInterval(fromDate, toDate,
                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null,
                                projectIDs,
                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
                        dataList = new ArrayList();
                        totalClientsCount = 0;
                        // populate series data map
                        for (WebBusinessObject clientCountWbo : clientsCounts) {
                            if (clientCountWbo.getAttribute("clientCount") != null) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                                dataEntryMap.put("name", clientCountWbo.getAttribute("rateName"));
                                dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));
                                dataList.add(dataEntryMap);
                            }
                        }
                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(dataList);
                        request.setAttribute("jsonText", jsonText);
                        request.setAttribute("dataList", clientsCounts);

                        request.setAttribute("campaignID", campaignIDs != null ? Tools.arrayToString(campaignIDs, ",") : null);
                        request.setAttribute("projectID", projectIDs);
                        request.setAttribute("rateID", rateIDs != null ? Tools.arrayToString(rateIDs, ",") : null);

                    } else if (clntTyp != null && clntTyp.equals("uncls")) {
                        departmentID = request.getParameter("departmentID");
                        clientMgr = ClientMgr.getInstance();
                        clientsList = clientMgr.selectUnratedCl(fromDate, toDate,
                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null, employeeID,
                                projectIDs,
                                request.getParameter("type"), departmentID);

                        wbo = clientMgr.selectUnratedRatedCountCl(fromDate, toDate,
                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null, employeeID,
                                projectIDs,
                                request.getParameter("type"), departmentID);
                        dataList = new ArrayList();
                        totalClientsCount = 0;
                        // populate series data map
                        if (wbo != null) {
                            if (wbo.getAttribute("totalRated") != null) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt((String) wbo.getAttribute("totalRated"));
                                dataEntryMap.put("name", " Rated Clients ");
                                dataEntryMap.put("y", Integer.parseInt((String) wbo.getAttribute("totalRated")));
                                dataList.add(dataEntryMap);
                            }
                            if (wbo.getAttribute("totalUnrated") != null) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt((String) wbo.getAttribute("totalUnrated"));
                                dataEntryMap.put("name", " Unrated Clients ");
                                dataEntryMap.put("y", Integer.parseInt((String) wbo.getAttribute("totalUnrated")));
                                dataList.add(dataEntryMap);
                            }
                        }
                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(dataList);
                        request.setAttribute("res", jsonText);
                        request.setAttribute("campaignID", campaignIDs != null ? Tools.arrayToString(campaignIDs, ",") : null);
                        request.setAttribute("projectID", projectIDs);
                        request.setAttribute("rateID", rateIDs != null ? Tools.arrayToString(rateIDs, ",") : null);
                    } else if (clntTyp != null && clntTyp.equals("all")) {
                        clientsList = clientRatingMgr.getClientRateIntervalAll(fromDate, toDate,
                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null,
                                projectIDs,
                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
                        String clientCreationTime, ratingTime;
                        for (WebBusinessObject clientTempWbo : clientsList) {
                            clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                            clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                            clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                            String fAppTime = (String) clientTempWbo.getAttribute("mct");
                            if(clientTempWbo.getAttribute("creationTime").equals("---")){
                            ratingTime = "";
                            } else {
                            ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                            ratingTime = ratingTime.substring(0, 16);
                            }
                            fAppTime = fAppTime.substring(0, 16);
                            clientTempWbo.setAttribute("creationTime", ratingTime);
                            clientTempWbo.setAttribute("mct", fAppTime);
                            try {
                                clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                            } catch (ParseException ex) {
                                clientTempWbo.setAttribute("diffDays", "---");
                            }
                        }

                        clientsCounts = clientRatingMgr.getClientRateCountInterval(fromDate, toDate,
                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null,
                                projectIDs,
                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
                        dataList = new ArrayList();
                        totalClientsCount = 0;
                        // populate series data map
                        for (WebBusinessObject clientCountWbo : clientsCounts) {
                            if (clientCountWbo.getAttribute("clientCount") != null) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                                dataEntryMap.put("name", clientCountWbo.getAttribute("rateName"));
                                dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));
                                dataList.add(dataEntryMap);
                            }
                        }
                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(dataList);
                        request.setAttribute("jsonText", jsonText);
                        request.setAttribute("dataList", clientsCounts);

                        request.setAttribute("campaignID", campaignIDs != null ? Tools.arrayToString(campaignIDs, ",") : null);
                        request.setAttribute("projectID", projectIDs);
                        request.setAttribute("rateID", rateIDs != null ? Tools.arrayToString(rateIDs, ",") : null);

                    }
                    request.setAttribute("clientsList", clientsList);
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                    request.setAttribute("employeeID", request.getParameter("employeeID"));
                    request.setAttribute("type", request.getParameter("type"));
                    request.setAttribute("clsUncls", request.getParameter("clsUncls"));
                } else {
                    c = Calendar.getInstance();
                    sdf.applyPattern("yyyy-MM-dd");
                    request.setAttribute("toDate", sdf.format(c.getTime()));
                    c.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(c.getTime()));
                }
                campaignMgr = CampaignMgr.getInstance();
                //   ArrayList<WebBusinessObject> campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(null, null, request.getParameter("statusID"),
                        (String) persistentUser.getAttribute("userId"), null, false));
                request.setAttribute("campaignsList", campaignsList);
                ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));

                    request.setAttribute("employees", userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId")));
                } catch (Exception ex) {
                }

                try {
                    request.setAttribute("typesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("typesList", new ArrayList<>());
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

                request.setAttribute("ratesList", ratesList);

                ArrayList<WebBusinessObject> departments = new ArrayList<WebBusinessObject>();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                String selectedDepartment = request.getParameter("departmentID");
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "ظ„ط§ ظٹظˆط¬ط¯");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                        ArrayList list = new ArrayList<>();
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "all";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                List<WebBusinessObject> employeeList = new ArrayList<WebBusinessObject>();
                if (selectedDepartment != null && selectedDepartment.equals("all")) {
                    for (WebBusinessObject departmentWbo : departments) {
                        if (departmentWbo != null) {
                            employeeList.addAll(userMgr.getEmployeeByDepartmentId((String) departmentWbo.getAttribute("projectID"), null, null));
                        }
                    }
                } else {
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                }

//                try {
//                    request.setAttribute("campaignsList", new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("0", "key3")));
//                } catch (Exception ex) {
//                    request.setAttribute("campaignsList", new ArrayList<>());
//                }
                request.setAttribute("dateType", request.getParameter("dateType"));
                request.setAttribute("departmentID", selectedDepartment);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("departments", departments);
                request.setAttribute("smry", request.getParameter("smry"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 68:
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    String campaignIDs = request.getParameter("campaignID") != null ? request.getParameter("campaignID").replaceAll(",", "','") : null;
                    String rateIDs = request.getParameter("rateID") != null ? request.getParameter("rateID").replaceAll(",", "','") : null;
                    employeeID = request.getParameter("employeeID");
                    projectID = request.getParameter("projectID");
                    clientRatingMgr = ClientRatingMgr.getInstance();

                    String clntTyp = request.getParameter("clsUncls");
                    HSSFWorkbook workBook = new HSSFWorkbook();
                    c = Calendar.getInstance();
                    Date fileDate = c.getTime();
                    sdf.applyPattern("yyyy-MM-dd");
                    String reportDate = sdf.format(fileDate);
                    String filename = new String();

                    campaignMgr = CampaignMgr.getInstance();
                    WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(campaignIDs);

                    projectMgr = ProjectMgr.getInstance();
                    WebBusinessObject projectWbo = projectMgr.getOnSingleKey(projectID);

                    WebBusinessObject rateWbo = projectMgr.getOnSingleKey(rateIDs);

                    dateType = request.getParameter("dateType");
                    departmentID = request.getParameter("departmentID");

                    userMgr = UserMgr.getInstance();
                    WebBusinessObject usrWbo = userMgr.getOnSingleKey(employeeID);

                    String rprtType = request.getParameter("rprtType");

                    String[] headerStr = new String[8];
                    String[] headerValuesStr = new String[8];
                    headerStr[0] = rprtType != null && rprtType.equals("0") ? " Classified Clients Summary " : clntTyp != null && clntTyp.equals("cls") ? " Classified Clients " : " Unclassified Clients ";
                    headerValuesStr[0] = " ";

                    headerStr[1] = " ";
                    headerValuesStr[1] = " ";

                    headerStr[2] = dateType != null && dateType.equalsIgnoreCase("rating") ? fromDate != null ? " Client Rating Date From: " : " " : dateType != null && dateType.equalsIgnoreCase("registration") ? fromDate != null ? " Client Rating Date From: " : " " : "";
                    headerValuesStr[2] = fromDate != null ? fromDate.toString() : " ";

                    headerStr[3] = dateType != null && dateType.equalsIgnoreCase("rating") ? toDate != null ? " Client Rating Date To: " : " " : dateType != null && dateType.equalsIgnoreCase("registration") ? toDate != null ? " Client Rating Date To: " : " " : "";
                    headerValuesStr[3] = toDate != null ? toDate.toString() : " ";

                    headerStr[4] = campaignWbo != null ? " Campaign: " : " ";
                    headerValuesStr[4] = campaignWbo != null ? campaignWbo.getAttribute("campaignTitle").toString() : " ";

                    headerStr[5] = projectWbo != null ? " Project: " : " ";
                    headerValuesStr[5] = projectWbo != null ? projectWbo.getAttribute("projectName").toString() : " ";

                    headerStr[6] = rateWbo != null ? " Classification: " : "";
                    headerValuesStr[6] = rateWbo != null ? rateWbo.getAttribute("projectName").toString() : " ";

                    headerStr[7] = usrWbo != null ? " Employee: " : " ";
                    headerValuesStr[7] = usrWbo != null ? usrWbo.getAttribute("fullName").toString() : " ";

                    if (rprtType != null && rprtType.equals("0")) {
                        if (clntTyp != null && clntTyp.equals("cls")) {
                            ArrayList<WebBusinessObject> clientsList = clientRatingMgr.getClientRateInterval(fromDate, toDate,
                                    campaignIDs != null ? "'" + campaignIDs + "'" : null, projectID,
                                    rateIDs != null ? "'" + rateIDs + "'" : null, employeeID,
                                    request.getParameter("type"), dateType, departmentID);
                            String clientCreationTime, ratingTime;

                            for (WebBusinessObject clientTempWbo : clientsList) {
                                clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                                clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                                clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                                String fAppTime = (String) clientTempWbo.getAttribute("mct");
                                ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                                ratingTime = ratingTime.substring(0, 16);
                                fAppTime = fAppTime.substring(0, 16);
                                clientTempWbo.setAttribute("creationTime", ratingTime);
                                try {
                                    clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                                } catch (ParseException ex) {
                                    clientTempWbo.setAttribute("diffDays", "---");
                                }
                            }
                            String headers[] = {"#", "Client Name", "Mobile", "Creation Time", "Classification Time", "Difference Day(s)", "Classified By", "Classification", "Source", "Know Us" ,"Comment" };
                            String attributes[] = {"Number", "clientName", "mobile", "clientCreationTime", "creationTime", "diffDays", "ratedBy", "rateName", "englishname", "campaign_title", "COMMENT"};
                            String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String"};

                            workBook = Tools.createExcelReport(" Classified Clients ", headerStr, headerValuesStr, headers, attributes, dataTypes, clientsList);
                            filename = "ClassifiedClients" + reportDate;
                        } else if (clntTyp != null && clntTyp.equals("uncls")) {

                            clientMgr = ClientMgr.getInstance();
                            ArrayList<WebBusinessObject> clientsList = clientMgr.selectUnratedCl(fromDate, toDate,
                                    campaignIDs != null ? "'" + campaignIDs + "'" : null, employeeID, projectID, request.getParameter("type"), departmentID);

                            String headers[] = {"#", "Client Name", "Mobile", "Creation Time", "Sender Name", "Sales Name"};
                            String attributes[] = {"Number", "clientName", "mobile", "clientCreationTime","sender_name","full_name"};
                            String dataTypes[] = {"", "String", "String", "String", "String", "String"};
                            workBook = Tools.createExcelReport("Unclassified Clients", headerStr, headerValuesStr, headers, attributes, dataTypes, clientsList);
                            filename = "UnclassifiedClients" + reportDate;
                        } else if (clntTyp != null && clntTyp.equals("all") || clntTyp.equals("")) {
                            ArrayList<WebBusinessObject> clientsList = clientRatingMgr.getClientRateIntervalAll(fromDate, toDate,
                                    campaignIDs != null ? "'" + campaignIDs + "'" : null, projectID,
                                    rateIDs != null ? "'" + rateIDs + "'" : null, employeeID,
                                    request.getParameter("type"), dateType, departmentID);
                            String clientCreationTime, ratingTime;

                            for (WebBusinessObject clientTempWbo : clientsList) {
                                clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                                clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                                clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                                String fAppTime = (String) clientTempWbo.getAttribute("mct");
                                ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                                if(ratingTime.equals("---")){
                                    ratingTime = "---";
                                } else {
                                    ratingTime = ratingTime.substring(0, 16);
                                }
                                
                                fAppTime = fAppTime.substring(0, 16);
                                clientTempWbo.setAttribute("creationTime", ratingTime);
                                try {
                                    clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                                } catch (ParseException ex) {
                                    clientTempWbo.setAttribute("diffDays", "---");
                                }
                            }
                            String headers[] = {"#", "Client Name", "Mobile", "Creation Time", "Classification Time", "Difference Day(s)", "Classified By", "Classification", "Source", "Know Us" ,"Comment" };
                            String attributes[] = {"Number", "clientName", "mobile", "clientCreationTime", "creationTime", "diffDays", "ratedBy", "rateName", "englishname", "campaign_title", "COMMENT"};
                            String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String"};

                            workBook = Tools.createExcelReport(" Classified Clients ", headerStr, headerValuesStr, headers, attributes, dataTypes, clientsList);
                            filename = "ClassifiedClients" + reportDate;
                        }
                    } else if (rprtType != null && rprtType.equals("1")) {
                        clientsCounts = clientRatingMgr.getClientRateCountInterval(fromDate, toDate,
                                campaignIDs != null ? "'" + campaignIDs + "'" : null, projectID,
                                rateIDs != null ? "'" + rateIDs + "'" : null, employeeID,
                                request.getParameter("type"), dateType, departmentID);

                        String headers[] = {"#", "Classification", "Total"};
                        String attributes[] = {"Number", "rateName", "clientCount"};
                        String dataTypes[] = {"", "String", "String"};
                        workBook = Tools.createExcelReport("Classified Clients Summary", headerStr, headerValuesStr, headers, attributes, dataTypes, clientsCounts);
                        filename = "ClassifiedClientsSummary" + reportDate;
                    } 

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
                break;

            case 69:
                servedPage = "/docs/reports/clients_Employee_rates_bar.jsp";

                String fromDate1 = request.getParameter("fromDate");
                String toDate1 = request.getParameter("toDate");

                sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (toDate1 == null) {
                    c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate1 = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -14);
                    fromDate1 = sdf.format(c.getTime());
                }

                projectMgr = ProjectMgr.getInstance();

                ArrayList<WebBusinessObject> projectList = new ArrayList<>();
                usersList = new ArrayList<>();
                ArrayList resultList = new ArrayList();
                EmployeesLoadsMgr loadsMgr = EmployeesLoadsMgr.getInstance();
                ArrayList projectNames;
                ArrayList userClientsProjects;

                try {
                    projectList = projectMgr.getSubProjectsById("1484491028701");
                    projectNames = new ArrayList();
                    if (projectList != null && projectList.size() > 0) {
                        for (int i = 0; i < projectList.size(); i++) {
                            WebBusinessObject projectWbo = projectList.get(i);
                            projectNames.add(projectWbo.getAttribute("projectName").toString());
                        }
                    }
                    departments = new ArrayList<>();
                    ArrayList<WebBusinessObject> userDepartments;
                    selectedDepartment = request.getParameter("departmentID");
                    userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    try {
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "ظ„ط§ ظٹظˆط¬ط¯");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    userId = (String) loggedUser.getAttribute("userId");
                    UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                    List<WebBusinessObject> usrGroups = userGroupConfigMgr.getAllUserGroupConfig(userId);

                    searchBy = request.getParameter("searchBy");
                    String id = request.getParameter("groupID");
                    if (id != null && !id.isEmpty()) {
                        ArrayList<WebBusinessObject> loads;
                        if (searchBy != null && searchBy.equalsIgnoreCase("byGroup")) {
                            usersList = new ArrayList<>(userMgr.getUsersByGroup2(id));

                        } else {
                            usersList = userMgr.getEmployeeByDepartmentId(id, null, null);
                        }

                        //String selectedGrpID = request.getParameter("groupID");
                        //usersList = new ArrayList<>(userMgr.getUsersByGroup(selectedGrpID));
                        for (WebBusinessObject userWbo : usersList) {
                            userClientsProjects = new ArrayList();
                            userClientsProjects = projectMgr.getEmpClientsRates(userWbo.getAttribute("userId").toString(), fromDate1, toDate1);

                            Map<String, Object> dataMap = new HashMap<String, Object>();
                            dataMap.put("name", userWbo.getAttribute("fullName"));
                            dataMap.put("data", userClientsProjects);

                            resultList.add(dataMap);
                        }
                        request.setAttribute("id", id);
                        request.setAttribute("searchBy", searchBy);
                    }

                    String ratingCategories = JSONValue.toJSONString(projectNames);
                    String resultsJson = JSONValue.toJSONString(resultList);

                    request.setAttribute("usrGroups", usrGroups);
                    request.setAttribute("departments", departments);
                    request.setAttribute("projectNames", projectNames);
                    request.setAttribute("ratingCategories", ratingCategories);
                    request.setAttribute("resultsJson", resultsJson);
                    request.setAttribute("fromDate", fromDate1);
                    request.setAttribute("toDate", toDate1);

                } catch (Exception ex) {
                    System.out.println("SQL Exception on Getting user type = " + ex.getMessage());
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 70:
                servedPage = "/docs/client/client_campaigns_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                clientMgr = ClientMgr.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    request.setAttribute("clientsList", clientMgr.getClientsCampaigns(new Timestamp(fromDate.getTime()), new Timestamp(toDate.getTime()),
                    request.getParameter("campaignID"), request.getParameter("extraCampaign"), request.getParameter("projectID")));
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                    request.setAttribute("campaignID", request.getParameter("campaignID"));
                    request.setAttribute("extraCampaign", request.getParameter("extraCampaign"));
                } else {
                    c = Calendar.getInstance();
                    sdf.applyPattern("yyyy-MM-dd");
                    request.setAttribute("toDate", sdf.format(c.getTime()));
                    c.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(c.getTime()));
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

                departments = new ArrayList<WebBusinessObject>();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                selectedDepartment = request.getParameter("departmentID");
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "ظ„ط§ ظٹظˆط¬ط¯");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                        ArrayList list = new ArrayList<>();
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "all";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                employeeList = new ArrayList<WebBusinessObject>();
                if (selectedDepartment != null && selectedDepartment.equals("all")) {
                    for (WebBusinessObject departmentWbo : departments) {
                        if (departmentWbo != null) {
                            employeeList.addAll(userMgr.getEmployeeByDepartmentId((String) departmentWbo.getAttribute("projectID"), null, null));
                        }
                    }
                } else {
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                }
                campaignMgr = CampaignMgr.getInstance();
                campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(null, null, request.getParameter("statusID"),
                        (String) persistentUser.getAttribute("userId"), request.getParameter("departmentID"), false));
                request.setAttribute("departments", departments);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("departmentID", selectedDepartment);
                //  campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 71:
                servedPage = "/docs/client/success_appointments_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                AppointmentNotificationMgr appointmentNotificationMgr = AppointmentNotificationMgr.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    campaignID = request.getParameterValues("campaignID") != null ? Tools.arrayToString(request.getParameterValues("campaignID"), "','") : "";
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    ArrayList<WebBusinessObject> campaignClientTotalList = appointmentNotificationMgr.getSuccessAppointmentsCampaignStat(new Timestamp(fromDate.getTime()),
                            new Timestamp(toDate.getTime()), campaignID);
                    request.setAttribute("campaignClientTotalList", campaignClientTotalList);
                    request.setAttribute("appointmentsList", appointmentNotificationMgr.getSuccessAppointmentsByDate(new Timestamp(fromDate.getTime()),
                            new Timestamp(toDate.getTime()), null, campaignID));
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                    request.setAttribute("campaignID", campaignID);
                } else {
                    c = Calendar.getInstance();
                    sdf.applyPattern("yyyy-MM-dd");
                    request.setAttribute("toDate", sdf.format(c.getTime()));
                    c.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(c.getTime()));
                }
                campaignMgr = CampaignMgr.getInstance();
                request.setAttribute("campaignsList", new ArrayList<>(campaignMgr.getCashedTable()));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 72:
                servedPage = "/docs/client/repeated_campaigns_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                clientMgr = ClientMgr.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    request.setAttribute("campaignsList", ClientCampaignMgr.getInstance().getRepeatedCampaigns(new Timestamp(fromDate.getTime()), new Timestamp(toDate.getTime())));
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
            case 73:
                servedPage = "/docs/reports/campaign_users_ratio.jsp";
                type = request.getParameter("type");
                campaignID = request.getParameter("campaignID");
                clientMgr = ClientMgr.getInstance();
                usersList = new ArrayList<>();
                if (null != type) {
                    switch (type) {
                        case "source":
                            usersList = clientMgr.getClientSourceCampaignCount(campaignID, request.getParameter("startDate"), request.getParameter("endDate"));
                            break;
                        case "responsible":
                            usersList = clientMgr.getClientResponsibleCampaignCount(campaignID, request.getParameter("startDate"), request.getParameter("endDate"));
                            break;
                    }
                    // populate series data map
                    int totalUsersCount = 0;
                    dataList = new ArrayList();
                    if (usersList != null) {
                        for (WebBusinessObject userCountWbo : usersList) {
                            dataEntryMap = new HashMap();
                            totalUsersCount += Integer.parseInt((String) userCountWbo.getAttribute("total"));
                            dataEntryMap.put("name", userCountWbo.getAttribute("name"));
                            dataEntryMap.put("y", Integer.parseInt((String) userCountWbo.getAttribute("total")));
                            dataList.add(dataEntryMap);
                        }
                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(dataList);

                        request.setAttribute("totalUsersCount", totalUsersCount);
                        request.setAttribute("usersList", usersList);
                        request.setAttribute("jsonText", jsonText);
                    }
                }
                campaignMgr = CampaignMgr.getInstance();
                request.setAttribute("campaignWbo", campaignMgr.getOnSingleKey(campaignID));
                request.setAttribute("type", type);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 74:
                servedPage = "/docs/reports/productivity_client_report.jsp";
                groupID = request.getParameter("groupID");
                clientMgr = ClientMgr.getInstance();
                groupMgr = GroupMgr.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                try {
                    fromDate = new java.sql.Date(sdf.parse(fromDateS).getTime());
                    toDate = new java.sql.Date(sdf.parse(toDateS).getTime());
                    request.setAttribute("clientsList", clientMgr.getClientListForProductivity(groupID, fromDate, toDate));
                } catch (ParseException ex) {
                    request.setAttribute("clientsList", new ArrayList<>());
                }
                request.setAttribute("groupWbo", groupMgr.getOnSingleKey(groupID));
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 75:
                servedPage = "/docs/reports/projects_sales.jsp";
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                try {
                    fromDate = fromDateS != null && !fromDateS.isEmpty() ? new java.sql.Date(sdf.parse(fromDateS).getTime()) : null;
                    toDate = toDateS != null && !toDateS.isEmpty() ? new java.sql.Date(sdf.parse(toDateS).getTime()) : null;
                    request.setAttribute("projectsList", projectMgr.getProjectsSales(fromDate, toDate));
                } catch (ParseException ex) {
                    request.setAttribute("projectsList", new ArrayList<>());
                }
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 76:
                servedPage = "/docs/reports/client_email_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                clientMgr = ClientMgr.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    request.setAttribute("clientsList", EmailMgr.getInstance().getEmailsInPeriod(fromDate, toDate, request.getParameter("type")));
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                    request.setAttribute("type", request.getParameter("type"));
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
            case 77:
                servedPage = "/docs/reports/areas_sales.jsp";
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                try {
                    fromDate = fromDateS != null && !fromDateS.isEmpty() ? new java.sql.Date(sdf.parse(fromDateS).getTime()) : null;
                    toDate = toDateS != null && !toDateS.isEmpty() ? new java.sql.Date(sdf.parse(toDateS).getTime()) : null;
                    request.setAttribute("projectsList", projectMgr.getAreasSales(fromDate, toDate));
                } catch (ParseException ex) {
                    request.setAttribute("projectsList", new ArrayList<>());
                }
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 78:
                servedPage = "/docs/reports/login_group_report.jsp";
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                groupID = request.getParameter("groupID");
                if (groupID != null) { // search
                    try {
                        LoginHistoryMgr loginHistoryMgr = LoginHistoryMgr.getInstance();
                        fromDate = new java.sql.Date(sdf.parse(fromDateS).getTime());
                        toDate = new java.sql.Date(sdf.parse(toDateS).getTime());
                        request.setAttribute("data", loginHistoryMgr.getGroupAttendanceInPeriod(fromDate, toDate, groupID));
                    } catch (ParseException ex) {
                        request.setAttribute("projectsList", new ArrayList<>());
                    }
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("groupID", groupID);
                }
                try {
                    userGroupCongMgr = UserGroupConfigMgr.getInstance();
                    groupMgr = GroupMgr.getInstance();
                    ArrayList<WebBusinessObject> groupsList = new ArrayList<>();
                    ArrayList<WebBusinessObject> userGroups = new ArrayList<>(userGroupCongMgr.getOnArbitraryKey(loggedUser.getAttribute("userId").toString(), "key2"));
                    if (!userGroups.isEmpty()) {
                        for (WebBusinessObject userGroupsWbo : userGroups) {
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groupsList.add(groupWbo);
                        }
                    }
                    request.setAttribute("groups", groupsList);
                } catch (Exception e) {
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 79:
                if (request.getParameter("getGrpEmp") == null) {
                    servedPage = "/docs/reports/consolidated_activities_report.jsp";
                    commentsMgr = CommentsMgr.getInstance();
                    fromDateS = request.getParameter("fromDate");
                    cal = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if (fromDateS == null) {
                        fromDateS = sdf.format(cal.getTime());
                    }
                    if (fromDateS != null && request.getParameter("createdBy") != null) {
                        DateParser dateParser = new DateParser();
                        String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                        java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                        wbo = userMgr.getConsolidatedActivities(request.getParameter("createdBy"), fromDateD);
                    } else {
                        wbo = new WebBusinessObject();
                    }

                    userGroupCongMgr = UserGroupConfigMgr.getInstance();
                    groupMgr = GroupMgr.getInstance();
                    ArrayList<WebBusinessObject> groupsList = new ArrayList<>();
                    ArrayList<WebBusinessObject> userGroups = new ArrayList<WebBusinessObject>();
                    try {
                        userGroups = new ArrayList<>(userGroupCongMgr.getOnArbitraryKey(loggedUser.getAttribute("userId").toString(), "key2"));
                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    if (!userGroups.isEmpty()) {
                        for (WebBusinessObject userGroupsWbo : userGroups) {
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groupsList.add(groupWbo);
                        }
                    }
                    request.setAttribute("groupsList", groupsList);
                    request.setAttribute("groupId", request.getParameter("groupId"));

                    if (request.getParameter("createdBy") != null) {
                        managerWbo = userMgr.getManagerByEmployeeID(request.getParameter("createdBy"));
                        departmentID = "";
                        try {
                            if (managerWbo != null) {
                                departmentID = (String) managerWbo.getAttribute("fullName");
                                ArrayList<WebBusinessObject> departmentList;
                                departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
                                if (departmentList.size() > 0) {
                                    departmentID = (String) departmentList.get(0).getAttribute("projectID");
                                }
                            } else {
                                ArrayList<WebBusinessObject> departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle(securityUser.getUserId(), "key5"));
                                if (departmentList.size() > 0) {
                                    departmentID = (String) departmentList.get(0).getAttribute("projectID");
                                }
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        request.setAttribute("departmentID", departmentID);
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("createdBy", request.getParameter("createdBy"));
                    request.setAttribute("dataWbo", wbo);
                    this.forwardToServedPage(request, response);
                } else if (request.getParameter("getGrpEmp") != null && request.getParameter("getGrpEmp").equals("1")) {
                    usersList = new ArrayList<WebBusinessObject>();
                    try {
                        usersList = new ArrayList<WebBusinessObject>(userMgr.getUsersByGroup((String) request.getParameter("grpId")));
                    } catch (SQLException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(usersList));
                }
                break;
            case 80:
                servedPage = "/docs/reports/my_consolidated_activities_report.jsp";
                commentsMgr = CommentsMgr.getInstance();
                fromDateS = request.getParameter("fromDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (fromDateS == null) {
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    wbo = userMgr.getConsolidatedActivities((String) persistentUser.getAttribute("userId"), fromDateD);
                } else {
                    wbo = null;
                }
                managerWbo = userMgr.getManagerByEmployeeID((String) persistentUser.getAttribute("userId"));
                departmentID = "";
                try {
                    if (managerWbo != null) {
                        departmentID = (String) managerWbo.getAttribute("fullName");
                        ArrayList<WebBusinessObject> departmentList;
                        departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
                        if (departmentList.size() > 0) {
                            departmentID = (String) departmentList.get(0).getAttribute("projectID");
                        }
                    } else {
                        ArrayList<WebBusinessObject> departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle(securityUser.getUserId(), "key5"));
                        if (departmentList.size() > 0) {
                            departmentID = (String) departmentList.get(0).getAttribute("projectID");
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("departmentID", departmentID);
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("createdBy", (String) persistentUser.getAttribute("userId"));
                request.setAttribute("dataWbo", wbo);
                this.forwardToServedPage(request, response);
                break;
            case 81:
                servedPage = "/docs/reports/login_user_details_report.jsp";
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                groupID = request.getParameter("groupID");
                String userID = request.getParameter("userID");
                try {
                    LoginHistoryMgr loginHistoryMgr = LoginHistoryMgr.getInstance();
                    fromDate = new java.sql.Date(sdf.parse(fromDateS).getTime());
                    toDate = new java.sql.Date(sdf.parse(toDateS).getTime());
                    request.setAttribute("data", loginHistoryMgr.getUserAttendanceInPeriod(fromDate, toDate, userID));
                } catch (ParseException ex) {
                    request.setAttribute("projectsList", new ArrayList<>());
                }
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("groupID", groupID);
                request.setAttribute("userID", userID);
                request.setAttribute("userWbo", userMgr.getOnSingleKey(userID));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 82:
                servedPage = "/docs/client/attened_client_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                if (fromDate != null && toDate != null) {
                    campaignID = request.getParameter("campaignID");
                    employeeID = request.getParameter("employeeID");

                    ArrayList<WebBusinessObject> clientsList = ClientMgr.getInstance().selectAttendedClients(fromDate, toDate, campaignID, employeeID);

                    request.setAttribute("clientsList", clientsList);
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                    request.setAttribute("employeeID", request.getParameter("employeeID"));
                } else {
                    c = Calendar.getInstance();
                    sdf.applyPattern("yyyy-MM-dd");
                    request.setAttribute("toDate", sdf.format(c.getTime()));
                    c.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(c.getTime()));
                }

                campaignsList = new ArrayList<>(CampaignMgr.getInstance().getCashedTable());
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("employees", userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId")));

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 83:
                PDFTools pdfTolls = new PDFTools();

                StringBuilder whereClause = new StringBuilder();
                whereClause.append("TRUNC(CL.CREATION_TIME) BETWEEN to_date('" + request.getParameter("fromDate") + "','yyyy-mm-dd') AND to_date('" + request.getParameter("toDate") + "','yyyy-mm-dd') and AP.OPTION9 = 'attended' and AP.OPTION2 = 'meeting'");
                if (request.getParameter("campaignID") != null && !request.getParameter("campaignID").equals("")) {
                    whereClause.append(" AND CL.SYS_ID IN (SELECT CC.CLIENT_ID FROM CLIENT_CAMPAIGN CC WHERE CC.CAMPAIGN_ID IN (").append(request.getParameter("campaignID")).append("))");
                }
                if (request.getParameter("employeeID") != null && !request.getParameter("employeeID").equals("")) {
                    whereClause.append(" AND CL.SYS_ID IN (SELECT ISS.URGENCY_ID FROM ISSUE ISS WHERE ISS.ID IN (SELECT CC.ISSUE_ID FROM CLIENT_COMPLAINTS CC WHERE CC.CURRENT_OWNER_ID IN ('").append(request.getParameter("employeeID")).append("' )))");
                }

                HashMap parameters = new HashMap();
                parameters.put("whereClause", whereClause);

                pdfTolls.generatePdfReport("AttendedClients", parameters, getServletContext(), response);
                break;

            case 84:
                servedPage = "/docs/client/client_comCahnnel_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                departments = new ArrayList<>();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                selectedDepartment = request.getParameter("departmentID");
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "ظ„ط§ ظٹظˆط¬ط¯");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                clientMgr = ClientMgr.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    ArrayList<WebBusinessObject> clientsList = new ArrayList<>();
                    Map<String, Long> channelsCount = new HashMap<>();
                    String channelTitle;
                    if ("inbound".equals(request.getParameter("clientType"))) { // inbound
                        clientsList = clientMgr.getClientsOfCommChannels(new Timestamp(fromDate.getTime()), new Timestamp(toDate.getTime()), request.getParameter("channelID"), selectedDepartment);
                        request.setAttribute("clientsList", clientsList);
                    } else { // outbound --> useless branching
                        clientsList = clientMgr.getClientsWithCampaginChannel(fromDate, toDate, request.getParameter("channelID"));
                        request.setAttribute("clientsList", clientsList);
                    }
                    for (WebBusinessObject tempWbo : clientsList) {
                        channelTitle = (String) tempWbo.getAttribute("comChannel");
                        if (channelTitle == null) {
                            channelTitle = "none";
                        }
                        if (channelsCount.containsKey(channelTitle)) {
                            channelsCount.put(channelTitle, channelsCount.get(channelTitle) + 1);
                        } else {
                            channelsCount.put(channelTitle, 1L);
                        }
                    }
                    request.setAttribute("channelsCount", channelsCount);
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                    request.setAttribute("clientType", request.getParameter("clientType"));
                    request.setAttribute("channelID", request.getParameter("channelID"));
                } else {
                    c = Calendar.getInstance();
                    sdf.applyPattern("yyyy-MM-dd");
                    request.setAttribute("toDate", sdf.format(c.getTime()));
                    c.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(c.getTime()));
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

                campaignMgr = CampaignMgr.getInstance();
                campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("channelsList", SeasonMgr.getInstance().getCashedTableAsArrayList());
                request.setAttribute("departmentID", selectedDepartment);
                request.setAttribute("departments", departments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 85:
                servedPage = "/docs/reports/campaigns_rates_bar.jsp";
                String deSelectAll = request.getParameter("deSelectAll");
                campaignMgr = CampaignMgr.getInstance();

                String[] campaigns = request.getParameterValues("campaignsselect");

                fromDate1 = request.getParameter("fromDate");
                toDate1 = request.getParameter("toDate");
                String CfromDate1 = request.getParameter("CfromDate");

                sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (toDate1 == null) {
                    c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate1 = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -14);
                    fromDate1 = sdf.format(c.getTime());
                }
                if (CfromDate1 == null) {
                    c = Calendar.getInstance();
                    c.add(Calendar.DATE, -14);
                    sdf = new SimpleDateFormat("yyyy-MM-dd");
                    CfromDate1 = sdf.format(c.getTime());
                }

                projectNames = new ArrayList();
                try {
                    projectList = projectMgr.getSubProjectsById("1484491028701");
                    if (projectList != null && projectList.size() > 0) {
                        for (int i = 0; i < projectList.size(); i++) {
                            WebBusinessObject projectWbo = projectList.get(i);
                            projectNames.add(projectWbo.getAttribute("projectName").toString());
                        }
                    }

                    //campaignsList = new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
                    //campaignsList.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
                    CampaignMgr campMgr = CampaignMgr.getInstance();
                    campMgr.cashData();
                    campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(CfromDate1, null, null, (String) persistentUser.getAttribute("userId"),
                            null, false));
                    request.setAttribute("campaignsList", campaignsList);
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                //String viewD = request.getParameter("viewD");
                String viewD = "on";
                projectMgr = ProjectMgr.getInstance();

                projectList = new ArrayList<>();
                usersList = new ArrayList<>();
                resultList = new ArrayList();
                loadsMgr = EmployeesLoadsMgr.getInstance();
                // if(deSelectAll!=null &&!deSelectAll.equals("")&&deSelectAll.equals("0")){
                if (viewD != null && viewD.equals("on")) {
                    try {
                        clientRatingMgr = ClientRatingMgr.getInstance();
                        DateFormat format = new SimpleDateFormat("yyyy-mm-dd");
                        Date fdate = format.parse(fromDate1);
                        java.sql.Date fdate1 = new java.sql.Date(fdate.getTime());

                        Date tdate = format.parse(toDate1);
                        java.sql.Date tdate1 = new java.sql.Date(tdate.getTime());
                        ArrayList<WebBusinessObject> result = new ArrayList<WebBusinessObject>();
                        if (deSelectAll != null && !deSelectAll.equals("") && deSelectAll.equals("0")) {
                            result = clientRatingMgr.getClientCampaignRateInterval(fromDate1, toDate1, campaigns);

                            for (WebBusinessObject clientTempWbo : result) {
                                String clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                                clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                                clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                                String fAppTime = (String) clientTempWbo.getAttribute("mct");
                                String ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                                ratingTime = ratingTime.substring(0, 16);
                                fAppTime = fAppTime.substring(0, 16);
                                clientTempWbo.setAttribute("creationTime", ratingTime);
                                clientTempWbo.setAttribute("mct", fAppTime);
                                try {
                                    clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                                } catch (ParseException ex) {
                                    clientTempWbo.setAttribute("diffDays", "---");
                                }
                            }
                        }
                        request.setAttribute("result", result);
                    } catch (ParseException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                    }

                } else {
                    try {
                        if (campaigns != null && campaigns.length != 0) {
                            for (String campId : campaigns) {
                                projectMgr = ProjectMgr.getInstance();
                                WebBusinessObject campWbo = campaignMgr.getOnSingleKey(campId);
                                userClientsProjects = new ArrayList();
                                userClientsProjects = ClientRatingMgr.getInstance().getCampaignClientsRates1(campId, fromDate1, toDate1);
                                //userClientsProjects = projectMgr.getEmpClientsRates(userWbo.getAttribute("userId").toString());

                                Map<String, Object> dataMap = new HashMap<String, Object>();
                                dataMap.put("name", campWbo.getAttribute("campaignTitle"));
                                dataMap.put("data", userClientsProjects);

                                resultList.add(dataMap);
                            }
                        }

                        String ratingCategories = JSONValue.toJSONString(projectNames);
                        String resultsJson = JSONValue.toJSONString(resultList);

                        request.setAttribute("resultsJson", resultsJson);
                        request.setAttribute("projectNames", projectNames);
                        request.setAttribute("ratingCategories", ratingCategories);

                    } catch (Exception ex) {
                        System.out.println("SQL Exception on Getting user type = " + ex.getMessage());
                    }

                }
//                }

                request.setAttribute("campaigns", campaigns);
                request.setAttribute("viewD", viewD);
                request.setAttribute("fromDate", fromDate1);
                request.setAttribute("CfromDate", CfromDate1);
                request.setAttribute("toDate", toDate1);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 86:
                clientRatingMgr = ClientRatingMgr.getInstance();
                fromDate1 = request.getParameter("fromDate");
                toDate1 = request.getParameter("toDate");
                campaigns = request.getParameter("campaignID").split(",");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                String campaignsStr = request.getParameter("campaignID");

                if (campaignsStr.equalsIgnoreCase("null")) {
                    campaigns = null;
                }

                ArrayList<WebBusinessObject> result = new ArrayList<WebBusinessObject>();
                result = clientRatingMgr.getClientCampaignRateInterval(fromDate1, toDate1, campaigns);

                for (WebBusinessObject clientTempWbo : result) {
                    String clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                    clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                    clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                    String fAppTime = (String) clientTempWbo.getAttribute("mct");
                    String ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                    ratingTime = ratingTime.substring(0, 16);
                    fAppTime = fAppTime.substring(0, 16);
                    clientTempWbo.setAttribute("creationTime", ratingTime);
                    clientTempWbo.setAttribute("mct", fAppTime);
                    try {
                        clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                    } catch (ParseException ex) {
                        clientTempWbo.setAttribute("diffDays", "---");
                    }
                }

                String headers[] = {"#", "Campaign", "Client Name", "Mobile", "Creation Time", "Classification Time", "Difference Day(s)", "Classified By", "Classification"};
                String attributes[] = {"Number", "campaignTit", "clientName", "mobile", "clientCreationTime", "creationTime", "diffDays", "ratedBy", "rateName"};
                String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String"};
                HSSFWorkbook workBook = new HSSFWorkbook();
                c = Calendar.getInstance();
                Date fileDate = c.getTime();
                sdf.applyPattern("yyyy-MM-dd");
                String reportDate = sdf.format(fileDate);
                String[] headerStr = new String[1];
                headerStr[0] = "Campaigns_comparison";
                workBook = Tools.createExcelReport("Campaigns comparison", headerStr, null, headers, attributes, dataTypes, result);
                String filename = "CampaignsComparison" + reportDate;

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

            case 87:
                campaigns = request.getParameter("campaignID") != null ? request.getParameter("campaignID").split(",") : request.getParameterValues("campaignsselect") != null ? request.getParameterValues("campaignsselect") : null;

                campaignMgr = CampaignMgr.getInstance();
                ArrayList<WebBusinessObject> syncRtClntCmpnLst = new ArrayList<WebBusinessObject>();
                if (request.getParameter("cmpnActvClntCmpn") != null && request.getParameter("cmpnActvClntCmpn").equalsIgnoreCase("1")) {
                    syncRtClntCmpnLst = campaignMgr.getSyncCmpnActvtyLst(campaigns, null);
                } else {
                    syncRtClntCmpnLst = campaignMgr.getSyncClntCmpnLst(campaigns);
                }
                servedPage = "/docs/campaign/synchronizeClientCampaings.jsp";
                if (request.getParameter("crbr") == null || !request.getParameter("crbr").equalsIgnoreCase("1")) {
                    campaignsList = new ArrayList<>();
                    try {
                        campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                    } catch (Exception e) {
                    }
                    request.setAttribute("campaignsList", campaignsList);
                }

                request.setAttribute("campaigns", campaigns);
                request.setAttribute("syncRtClntCmpnLst", syncRtClntCmpnLst);
                request.setAttribute("crbr", request.getParameter("crbr"));
                request.setAttribute("cmpnActvClntCmpn", request.getParameter("cmpnActvClntCmpn"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            case 88:
                servedPage = "/docs/reports/first_last_report.jsp";
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                if (fromDateS != null) { // search
                    try {
                        LoginHistoryMgr loginHistoryMgr = LoginHistoryMgr.getInstance();
                        fromDate = new java.sql.Date(sdf.parse(fromDateS).getTime());
                        toDate = new java.sql.Date(sdf.parse(toDateS).getTime());
                        request.setAttribute("data", loginHistoryMgr.getFirstLastLogin(fromDate, toDate));
                    } catch (ParseException ex) {
                        request.setAttribute("projectsList", new ArrayList<>());
                    }
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 89:
                campaignMgr = CampaignMgr.getInstance();
                CfromDate1 = request.getParameter("CfromDate");
                CampaignMgr campMgr = CampaignMgr.getInstance();
                campMgr.cashData();
                campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(CfromDate1, null, null, null, null, false));
                out = response.getWriter();
                out.write(Tools.getJSONArrayAsString(campaignsList));
                break;

            case 90:
                servedPage = "/docs/reports/all_employees_requests.jsp";
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                String Utype = request.getParameter("typ");
                String reqTyp = request.getParameter("reqTyp");
                String reqStatus = request.getParameter("statusReq");
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                String empID = request.getParameter("empID") != null && !request.getParameter("empID").equalsIgnoreCase("null") ? request.getParameter("empID") : (String) loggedUser.getAttribute("userId");
                EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
                ArrayList<WebBusinessObject> reqTypLst = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> reqStutsLst = new ArrayList<WebBusinessObject>();
                ArrayList<LiteWebBusinessObject> MyEmpList = new ArrayList<LiteWebBusinessObject>();
                WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
                 {
                    try {
                        reqTypLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("ERQ", "key4"));
                        MyEmpList = employeeMgr.getMyEmployeeList((String) waUser.getAttribute("userId"));

                    } catch (Exception ex) {
                        Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                reqStutsLst = employeeMgr.AllEmployeeReqStatus();
                request.setAttribute("reqStutsLst", reqStutsLst);

                int flag = 0;
                if (Utype != null && Utype.equalsIgnoreCase("1")) {
                    if (fromDateS != null && toDateS != null) {
                        String EmpID = request.getParameter("selectedEMP");
                        ArrayList<LiteWebBusinessObject> reqList = employeeMgr.getAllMyEmployeesRequests(fromDateS, toDateS, session, reqTyp, EmpID, reqStatus);
                        request.setAttribute("reqList", reqList);
                        request.setAttribute("EmpID", EmpID);
                        request.setAttribute("reqStatus", reqStatus);
                        request.setAttribute("typ", "manager");
                        flag = 1;
                    }
                    if (flag == 0) {
                        request.setAttribute("typ", "manager");
                    }
                } else if (Utype != null && Utype.equalsIgnoreCase("2")) {
                    if (fromDateS != null && toDateS != null) {
                        ArrayList<LiteWebBusinessObject> reqList = employeeMgr.getAllMyRequests(fromDateS, toDateS, session, reqTyp, reqStatus, empID);
                        request.setAttribute("reqList", reqList);
                        request.setAttribute("reqStatus", reqStatus);
                        request.setAttribute("typ", "employee");
                        flag = 1;
                    }
                    if (flag == 0) {
                        request.setAttribute("typ", "employee");
                    }
                } else if (Utype != null && Utype.equalsIgnoreCase("3")) {
                    if (fromDateS != null && toDateS != null) {
                        employeeMgr = EmployeeMgr.getInstance();
                        ArrayList<LiteWebBusinessObject> reqList = employeeMgr.getAllEmployeesRequests(fromDateS, toDateS, session, reqTyp);
                        request.setAttribute("reqList", reqList);
                        request.setAttribute("typ", "admin");
                        flag = 1;
                    }
                    if (flag == 0) {
                        request.setAttribute("typ", "admin");
                    }
                }
                request.setAttribute("empID", empID);
                request.setAttribute("MyEmpList", MyEmpList);
                request.setAttribute("reqTypLst", reqTypLst);
                request.setAttribute("reqTyp", reqTyp);
                request.setAttribute("Utype", Utype);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 91:
                boolean statusResult = false;
                employeeMgr = EmployeeMgr.getInstance();
                String rowId = request.getParameter("rowId");
                String boId = request.getParameter("boId");
                String empId = request.getParameter("empId");
                String reqAmount = request.getParameter("reqAmount");
                String comment = request.getParameter("comment");
                String typ = request.getParameter("typ");
                wbo = new WebBusinessObject();
                if (typ != null && typ.equalsIgnoreCase("accept")) {
                    try {
                        statusResult = employeeMgr.acceptEmpRequest(session, rowId, boId, empId, reqAmount, comment);
                        if (statusResult) {
                            wbo.setAttribute("status", "OK");
                        } else {
                            wbo.setAttribute("status", "NO");
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else if (typ != null && typ.equalsIgnoreCase("reject")) {
                    try {
                        statusResult = employeeMgr.rejectEmpRequest(session, rowId, boId, comment);
                        if (statusResult) {
                            wbo.setAttribute("status", "OK");
                        } else {
                            wbo.setAttribute("status", "NO");
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else if (typ != null && typ.equalsIgnoreCase("cancel")) {
                    try {
                        statusResult = employeeMgr.cancelEmpRequest(session, rowId, boId, comment);
                        if (statusResult) {
                            wbo.setAttribute("status", "OK");
                        } else {
                            wbo.setAttribute("status", "NO");
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 92:
                servedPage = "/docs/reports/ClientsWithdraws.jsp";
                String mobNo = request.getParameter("mobNo");
                clientMgr = ClientMgr.getInstance();

                if (mobNo != null && !mobNo.isEmpty()) {
                    ArrayList<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
                    data = clientMgr.getClientsWithdraws(mobNo, session);
                    request.setAttribute("clientsLst", data);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 93:
                String loggegUserId = new String();
                servedPage = "/docs/reports/employeesWithdraws.jsp";
                String createdBy = request.getParameter("createdBy");
                source = request.getParameter("source");

                if (request.getParameter("my") != null && request.getParameter("my").equals("1")) {
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    loggegUserId = (String) loggedUser.getAttribute("userId");
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

                request.setAttribute("status", request.getParameter("status"));

                request.setAttribute("withdrawLst", issueMgr.getEmployeesClientsWithdraw(loggegUserId, request.getParameter("beginDate"), request.getParameter("endDate"), createdBy, source));
                request.setAttribute("my", request.getParameter("my"));
                request.setAttribute("disStatus", request.getParameter("status"));

                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                 {
                    try {
                        ArrayList<WebBusinessObject> users = (ArrayList<WebBusinessObject>) userMgr.getAllUsers();
                        request.setAttribute("users", users);
                    } catch (SQLException ex) {
                        Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("createdBy", createdBy);
                request.setAttribute("source", source);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;

            case 94:
                servedPage = "/docs/reports/clientsProfileReport.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");

                if (beginDate != null && endDate != null) {
                    clientMgr = ClientMgr.getInstance();
                    ArrayList<WebBusinessObject> clientsLst = new ArrayList<WebBusinessObject>();
                    clientsLst = clientMgr.getClientsProfile(beginDate, endDate);
                    request.setAttribute("clientsLst", clientsLst);
                }
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 95:
                servedPage = "/docs/reports/sales_total_chart.jsp";
                clientProductMgr = ClientProductMgr.getInstance();
                if (request.getParameter("year") != null) {
                    ArrayList<String> salesTotalList = clientProductMgr.getSalesTotalByYear(request.getParameter("year"));
                    if (!salesTotalList.isEmpty()) {
                        long totalAmountCount = 0;
                        for (String total : salesTotalList) {
                            totalAmountCount += Long.valueOf(total);
                        }
                        dataList = new ArrayList();
                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(salesTotalList);
                        request.setAttribute("totalAmountCount", totalAmountCount);
                        request.setAttribute("jsonText", jsonText);
                    }
                    request.setAttribute("salesTotalList", salesTotalList);
                    request.setAttribute("year", request.getParameter("year"));
                } else {
                    request.setAttribute("salesTotalList", new ArrayList<>());
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 96:
                clientRatingMgr = ClientRatingMgr.getInstance();
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                result = new ArrayList<WebBusinessObject>();

                if (beginDate != null && endDate != null) {
                    clientMgr = ClientMgr.getInstance();

                    result = clientMgr.getClientsProfile(beginDate, endDate);
                }

                String Cheaders[] = {"#", "Name", "Gender", "Age", "Mobile", "Marital Status", "# Of Kids", "School", "Religion", "Profession", "Address", "Project", "Unit", "Price", "Area", "Description"};
                String Cattributes[] = {"Number", "name", "gender", "age", "mobile", "matiralStatus", "noOfKids", "school", "religion", "job", "region", "project", "unit", "price", "area", "generalDesc"};
                String CdataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                HSSFWorkbook CworkBook = new HSSFWorkbook();
                c = Calendar.getInstance();
                Date CfileDate = c.getTime();
                sdf.applyPattern("yyyy-MM-dd");
                String CreportDate = sdf.format(CfileDate);
                String[] CheaderStr = new String[1];
                CheaderStr[0] = "Clients_Profiles";
                workBook = Tools.createExcelReport("Clients Profiles", CheaderStr, null, Cheaders, Cattributes, CdataTypes, result);
                String Cfilename = "ClientsProfiles" + CreportDate;

                try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }
                    byte[] bytes = bos.toByteArray();
                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + Cfilename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                }
                break;
            case 97:
                servedPage = "/docs/client/my_success_appointments_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                appointmentNotificationMgr = AppointmentNotificationMgr.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    request.setAttribute("appointmentsList", appointmentNotificationMgr.getSuccessAppointmentsByDate(new Timestamp(fromDate.getTime()), new Timestamp(toDate.getTime()),
                            (String) persistentUser.getAttribute("userId"), null));
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
            case 98:
                servedPage = "/docs/client/client_survey_report.jsp";
                request.setAttribute("clientSurveyList", ClientSurveyMgr.getInstance().getClientSurvey());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 99:
                servedPage = "/docs/reports/client_job_rates.jsp";
                clientMgr = ClientMgr.getInstance();
                ArrayList<WebBusinessObject> clientCountList = clientMgr.getJobStatistics(false);
                if (!clientCountList.isEmpty()) {
                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    int totalLeadsCount = 0;
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : clientCountList) {
                        dataEntryMap = new HashMap();
                        totalLeadsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                        dataEntryMap.put("name", clientCountWbo.getAttribute("jobName"));
                        dataEntryMap.put("y", new Integer((String) clientCountWbo.getAttribute("clientCount")));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalLeadsCount", totalLeadsCount);
                    request.setAttribute("leadsCountList", clientCountList);
                    request.setAttribute("leadsJsonText", jsonText);
                }
                clientCountList = clientMgr.getJobStatistics(true);
                if (!clientCountList.isEmpty()) {
                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    int totalCustomersCount = 0;
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : clientCountList) {
                        dataEntryMap = new HashMap();
                        totalCustomersCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                        dataEntryMap.put("name", clientCountWbo.getAttribute("jobName"));
                        dataEntryMap.put("y", new Integer((String) clientCountWbo.getAttribute("clientCount")));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalCustomersCount", totalCustomersCount);
                    request.setAttribute("customersCountList", clientCountList);
                    request.setAttribute("customersJsonText", jsonText);
                }
                Map<String, String> tradesMap = new HashMap<>();
                WebBusinessObject tradeWbo;
                for (Object tradeObj : tradeMgr.getAllAsArrayList()) {
                    tradeWbo = (WebBusinessObject) tradeObj;
                    tradesMap.put((String) tradeWbo.getAttribute("enName"), (String) tradeWbo.getAttribute("tradeId"));
                }
                request.setAttribute("tradesMap", tradesMap);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 100:
                servedPage = "/docs/reports/client_region_rates.jsp";
                clientMgr = ClientMgr.getInstance();
                clientCountList = clientMgr.getRegionStatistics(false);
                if (!clientCountList.isEmpty()) {
                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    int totalLeadsCount = 0;
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : clientCountList) {
                        dataEntryMap = new HashMap();
                        totalLeadsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                        dataEntryMap.put("name", clientCountWbo.getAttribute("regionName"));
                        dataEntryMap.put("y", new Integer((String) clientCountWbo.getAttribute("clientCount")));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalLeadsCount", totalLeadsCount);
                    request.setAttribute("leadsCountList", clientCountList);
                    request.setAttribute("leadsJsonText", jsonText);
                }
                clientCountList = clientMgr.getRegionStatistics(true);
                if (!clientCountList.isEmpty()) {
                    jsonText = null;
                    dataList = new ArrayList();
                    dataEntryMap = new HashMap();
                    int totalCustomersCount = 0;
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : clientCountList) {
                        dataEntryMap = new HashMap();
                        totalCustomersCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                        dataEntryMap.put("name", clientCountWbo.getAttribute("regionName"));
                        dataEntryMap.put("y", new Integer((String) clientCountWbo.getAttribute("clientCount")));
                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    jsonText = JSONValue.toJSONString(dataList);
                    request.setAttribute("totalCustomersCount", totalCustomersCount);
                    request.setAttribute("customersCountList", clientCountList);
                    request.setAttribute("customersJsonText", jsonText);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 101:
                servedPage = "/docs/reports/com_chan_clients_analysis.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    String[] channelID = request.getParameterValues("channelID");
                    String projectIDs = request.getParameter("projectID");
                    String[] rateIDs = request.getParameterValues("rateID");
                    employeeID = request.getParameter("employeeID");
                    String clntTyp = request.getParameter("clsUncls");
                    departmentID = request.getParameter("departmentID");
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    ArrayList<WebBusinessObject> clientsList = new ArrayList<WebBusinessObject>();

                    if (clntTyp != null && clntTyp.equals("cls")) {
                        clientsList = clientRatingMgr.getClientRateIntervalForCommChannels(fromDate, toDate,
                                channelID != null ? "'" + Tools.arrayToString(channelID, "','") + "'" : null,
                                projectIDs,
                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
                        String clientCreationTime, ratingTime;
                        for (WebBusinessObject clientTempWbo : clientsList) {
                            clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                            clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                            clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                            String fAppTime = (String) clientTempWbo.getAttribute("mct");
                            ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                            ratingTime = ratingTime.substring(0, 16);
                            fAppTime = fAppTime.substring(0, 16);
                            clientTempWbo.setAttribute("creationTime", ratingTime);
                            clientTempWbo.setAttribute("mct", fAppTime);
                            try {
                                clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                            } catch (ParseException ex) {
                                clientTempWbo.setAttribute("diffDays", "---");
                            }
                        }

                        clientsCounts = clientRatingMgr.getClientRateCountIntervalForComChannels(fromDate, toDate,
                                channelID != null ? "'" + Tools.arrayToString(channelID, "','") + "'" : null,
                                projectIDs,
                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
                        dataList = new ArrayList();
                        totalClientsCount = 0;
                        // populate series data map
                        for (WebBusinessObject clientCountWbo : clientsCounts) {
                            if (clientCountWbo.getAttribute("clientCount") != null) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                                dataEntryMap.put("name", clientCountWbo.getAttribute("channelName"));
                                dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));
                                dataList.add(dataEntryMap);
                            }
                        }
                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(dataList);
                        request.setAttribute("jsonText", jsonText);
                        request.setAttribute("dataList", clientsCounts);

                        request.setAttribute("channelID", channelID != null ? Tools.arrayToString(channelID, ",") : null);
                        request.setAttribute("projectID", projectIDs);
                        request.setAttribute("rateID", rateIDs != null ? Tools.arrayToString(rateIDs, ",") : null);

                    } else if (clntTyp != null && clntTyp.equals("uncls")) {
                        departmentID = request.getParameter("departmentID");
                        clientMgr = ClientMgr.getInstance();
                        clientsList = clientMgr.selectUnratedClForComChannels(fromDate, toDate,
                                channelID != null ? "'" + Tools.arrayToString(channelID, "','") + "'" : null, employeeID,
                                projectIDs,
                                request.getParameter("type"), departmentID);

                        clientsCounts = clientMgr.selectUnratedRatedCountClForComChan(fromDate, toDate,
                                channelID != null ? "'" + Tools.arrayToString(channelID, "','") + "'" : null, employeeID,
                                projectIDs,
                                request.getParameter("type"), departmentID);
                        dataList = new ArrayList();
                        totalClientsCount = 0;
                        // populate series data map
                        for (WebBusinessObject clientCountWbo : clientsCounts) {
                            if (clientCountWbo.getAttribute("clientCount") != null) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                                dataEntryMap.put("name", clientCountWbo.getAttribute("channelName"));
                                dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));
                                dataList.add(dataEntryMap);
                            }
                        }
                        // convert map to JSON string
                        jsonText = JSONValue.toJSONString(dataList);
                        request.setAttribute("res", jsonText);
                        request.setAttribute("channelID", channelID != null ? Tools.arrayToString(channelID, ",") : null);
                        request.setAttribute("projectID", projectIDs);
                        request.setAttribute("rateID", rateIDs != null ? Tools.arrayToString(rateIDs, ",") : null);
                    }
                    request.setAttribute("clientsList", clientsList);
                    request.setAttribute("fromDate", request.getParameter("fromDate"));
                    request.setAttribute("toDate", request.getParameter("toDate"));
                    request.setAttribute("employeeID", request.getParameter("employeeID"));
                    request.setAttribute("type", request.getParameter("type"));
                    request.setAttribute("clsUncls", request.getParameter("clsUncls"));
                } else {
                    c = Calendar.getInstance();
                    sdf.applyPattern("yyyy-MM-dd");
                    request.setAttribute("toDate", sdf.format(c.getTime()));
                    c.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(c.getTime()));
                }
                //SeasonMgr.getInstance().getCashedTableAsArrayList()
                SeasonMgr seasonMgr = SeasonMgr.getInstance();
                ArrayList<WebBusinessObject> channelsList = new ArrayList<WebBusinessObject>(seasonMgr.getCashedTable());
                request.setAttribute("channelsList", channelsList);

                campaignMgr = CampaignMgr.getInstance();
                campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                request.setAttribute("campaignsList", campaignsList);
                ratesList = new ArrayList<>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));

                    request.setAttribute("employees", userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId")));
                } catch (Exception ex) {
                }

                try {
                    request.setAttribute("typesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("typesList", new ArrayList<>());
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

                request.setAttribute("ratesList", ratesList);

                departments = new ArrayList<WebBusinessObject>();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                selectedDepartment = request.getParameter("departmentID");
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "ظ„ط§ ظٹظˆط¬ط¯");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                        ArrayList list = new ArrayList<>();
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "all";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                employeeList = new ArrayList<WebBusinessObject>();
                if (selectedDepartment != null && selectedDepartment.equals("all")) {
                    for (WebBusinessObject departmentWbo : departments) {
                        if (departmentWbo != null) {
                            employeeList.addAll(userMgr.getEmployeeByDepartmentId((String) departmentWbo.getAttribute("projectID"), null, null));
                        }
                    }
                } else {
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                }

//                try {
//                    request.setAttribute("campaignsList", new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("0", "key3")));
//                } catch (Exception ex) {
//                    request.setAttribute("campaignsList", new ArrayList<>());
//                }
                request.setAttribute("dateType", request.getParameter("dateType"));
                request.setAttribute("departmentID", selectedDepartment);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("departments", departments);
                request.setAttribute("smry", request.getParameter("smry"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 102:
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                if (fromDate != null && toDate != null) {
                    String channelID = request.getParameter("channelID") != null ? request.getParameter("channelID").replaceAll(",", "','") : null;
                    String rateIDs = request.getParameter("rateID") != null ? request.getParameter("rateID").replaceAll(",", "','") : null;
                    employeeID = request.getParameter("employeeID");
                    projectID = request.getParameter("projectID");
                    clientRatingMgr = ClientRatingMgr.getInstance();

                    String clntTyp = request.getParameter("clsUncls");
                    workBook = new HSSFWorkbook();
                    c = Calendar.getInstance();
                    fileDate = c.getTime();
                    sdf.applyPattern("yyyy-MM-dd");
                    reportDate = sdf.format(fileDate);
                    filename = new String();

                    /*campaignMgr = CampaignMgr.getInstance();
                    WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(campaignIDs);*/
                    seasonMgr = SeasonMgr.getInstance();
                    WebBusinessObject channelWbo = seasonMgr.getOnSingleKey(channelID);

                    projectMgr = ProjectMgr.getInstance();
                    WebBusinessObject projectWbo = projectMgr.getOnSingleKey(projectID);

                    WebBusinessObject rateWbo = projectMgr.getOnSingleKey(rateIDs);

                    dateType = request.getParameter("dateType");
                    departmentID = request.getParameter("departmentID");

                    userMgr = UserMgr.getInstance();
                    WebBusinessObject usrWbo = userMgr.getOnSingleKey(employeeID);

                    String rprtType = request.getParameter("rprtType");

                    String[] headerStr1 = new String[8];
                    String[] headerValuesStr = new String[8];
                    headerStr1[0] = rprtType != null && rprtType.equals("0") ? "Classified Clients Summary " : clntTyp != null && clntTyp.equals("cls") ? " Classified Clients " : " Unclassified Clients ";
                    headerValuesStr[0] = " ";

                    headerStr1[1] = " ";
                    headerValuesStr[1] = " ";

                    headerStr1[2] = dateType != null && dateType.equalsIgnoreCase("rating") ? fromDate != null ? " Client Rating Date From: " : " " : dateType != null && dateType.equalsIgnoreCase("registration") ? fromDate != null ? " Client Rating Date From: " : " " : "";
                    headerValuesStr[2] = fromDate != null ? fromDate.toString() : " ";

                    headerStr1[3] = dateType != null && dateType.equalsIgnoreCase("rating") ? toDate != null ? " Client Rating Date To: " : " " : dateType != null && dateType.equalsIgnoreCase("registration") ? toDate != null ? " Client Rating Date To: " : " " : "";
                    headerValuesStr[3] = toDate != null ? toDate.toString() : " ";

                    headerStr1[4] = channelWbo != null ? " Communication Channel: " : " ";
                    headerValuesStr[4] = channelWbo != null ? channelWbo.getAttribute("englishName").toString() : " ";

                    headerStr1[5] = projectWbo != null ? " Project: " : " ";
                    headerValuesStr[5] = projectWbo != null ? projectWbo.getAttribute("projectName").toString() : " ";

                    headerStr1[6] = rateWbo != null ? " Classification: " : "";
                    headerValuesStr[6] = rateWbo != null ? rateWbo.getAttribute("projectName").toString() : " ";

                    headerStr1[7] = usrWbo != null ? " Employee: " : " ";
                    headerValuesStr[7] = usrWbo != null ? usrWbo.getAttribute("fullName").toString() : " ";

                    if (rprtType != null && rprtType.equals("0")) {
                        if (clntTyp != null && clntTyp.equals("cls")) {
                            ArrayList<WebBusinessObject> clientsList = clientRatingMgr.getClientRateIntervalForCommChannels(fromDate, toDate,
                                    channelID != null ? "'" + channelID + "'" : null, projectID,
                                    rateIDs != null ? "'" + rateIDs + "'" : null, employeeID,
                                    request.getParameter("type"), dateType, departmentID);
                            String clientCreationTime, ratingTime;

                            for (WebBusinessObject clientTempWbo : clientsList) {
                                clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
                                clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
                                clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
                                String fAppTime = (String) clientTempWbo.getAttribute("mct");
                                ratingTime = (String) clientTempWbo.getAttribute("creationTime");
                                ratingTime = ratingTime.substring(0, 16);
                                fAppTime = fAppTime.substring(0, 16);
                                clientTempWbo.setAttribute("creationTime", ratingTime);
                                try {
                                    clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
                                } catch (ParseException ex) {
                                    clientTempWbo.setAttribute("diffDays", "---");
                                }
                            }
                            String headers1[] = {"#", "Client Name", "Mobile", "Creation Time", "Classification Time", "Difference Day(s)", "Classified By", "Classification", "Known us from"};
                            String attributes1[] = {"Number", "clientName", "mobile", "clientCreationTime", "creationTime", "diffDays", "ratedBy", "rateName", "knownUsFrom"};
                            String dataTypes1[] = {"", "String", "String", "String", "String", "String", "String", "String", "String"};

                            workBook = Tools.createExcelReport(" Classified Clients ", headerStr1, headerValuesStr, headers1, attributes1, dataTypes1, clientsList);
                            filename = "ClassifiedClients" + reportDate;
                        } else if (clntTyp != null && clntTyp.equals("uncls")) {

                            clientMgr = ClientMgr.getInstance();
                            ArrayList<WebBusinessObject> clientsList = clientMgr.selectUnratedClForComChannels(fromDate, toDate,
                                    channelID != null ? "'" + channelID + "'" : null, employeeID, projectID, request.getParameter("type"), departmentID);

                            String headers1[] = {"#", "Client Name", "Mobile", "Inter No.", "Creation Time", "Known us from"};
                            String attributes1[] = {"Number", "clientName", "mobile", "interPhone", "clientCreationTime", "knownUsFrom"};
                            String dataTypes1[] = {"", "String", "String", "String", "String", "String"};
                            workBook = Tools.createExcelReport("Unclassified Clients", headerStr1, headerValuesStr, headers1, attributes1, dataTypes1, clientsList);
                            filename = "UnclassifiedClients" + reportDate;
                        }
                    } else if (rprtType != null && rprtType.equals("1")) {
                        clientsCounts = clientRatingMgr.getClientRateCountIntervalForComChannels(fromDate, toDate,
                                channelID != null ? "'" + channelID + "'" : null, projectID,
                                rateIDs != null ? "'" + rateIDs + "'" : null, employeeID,
                                request.getParameter("type"), dateType, departmentID);

                        String headers1[] = {"#", "Channel", "Total"};
                        String attributes1[] = {"Number", "channelName", "clientCount"};
                        String dataTypes1[] = {"", "String", "String"};
                        workBook = Tools.createExcelReport("Classified Clients Summary", headerStr1, headerValuesStr, headers1, attributes1, dataTypes1, clientsCounts);
                        filename = "ChannelClientsSummary" + reportDate;
                    }

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
                break;
            case 103:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "fail");
                clientRatingMgr = ClientRatingMgr.getInstance();
                try {
                    ratesList = new ArrayList<>(clientRatingMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("clientID"), "key1", request.getParameter("rateID"), "key2"));
                    if (!ratesList.isEmpty()) {
                        wbo.setAttribute("date", ((String) ratesList.get(0).getAttribute("creationTime")).substring(0, 19));
                        wbo.setAttribute("status", "ok");
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 104:
                servedPage = "/docs/reports/projects_campaigns_report.jsp";
                campaignMgr = CampaignMgr.getInstance();
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }
                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                ArrayList<WebBusinessObject> projectsCampaignsList = campaignMgr.getPorjectsCampaigns(fromDate, toDate);
                Map<String, ArrayList<String>> campaignProjectsMap = new HashMap<>();
                projectsCampaignsList.stream().forEach(projectCampaignWbo -> {
                    ArrayList<String> tempList = (campaignProjectsMap.containsKey((String) projectCampaignWbo.getAttribute("id")) ? campaignProjectsMap.get((String) projectCampaignWbo.getAttribute("id"))
                            : campaignProjectsMap.put((String) projectCampaignWbo.getAttribute("id"), (new ArrayList<>())));
                    campaignProjectsMap.get((String) projectCampaignWbo.getAttribute("id")).add((String) projectCampaignWbo.getAttribute("projectID"));
                });
                projectsList = new ArrayList<>();
                try {
                    projectsList = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key6"));
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("projectsCampaignsList", projectsCampaignsList);
                request.setAttribute("campaignProjectsMap", campaignProjectsMap);
                request.setAttribute("projectsList", projectsList);
                request.setAttribute("fromDate", request.getParameter("fromDate"));
                request.setAttribute("toDate", request.getParameter("toDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 105:
                servedPage = "/docs/reports/campaign_target_ratio.jsp";
                campaignMgr = CampaignMgr.getInstance();

                String campaignType1 = request.getParameter("campaignType");
                ArrayList<WebBusinessObject> campaignClientsCounts1 = new ArrayList<WebBusinessObject>();
                dataList = new ArrayList();
                int totalClientsCount1 = 0;

                DecimalFormat df1 = new DecimalFormat("#.#");
                double tempPercent1;
                campaignClientsCounts1 = campaignMgr.getTargetedClientsCountPerCampaign(request.getParameter("startDate"), request.getParameter("endDate"), "grpCamp");
                if (!campaignClientsCounts1.isEmpty()) {
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : campaignClientsCounts1) {
                        tempPercent = Double.valueOf(clientCountWbo.getAttribute("clientCount") + "") / Double.valueOf(clientCountWbo.getAttribute("soldCount") + "") * 100.0;
                        if (Double.isNaN(tempPercent)) {
                            clientCountWbo.setAttribute("percent", "0");
                        } else {
                            clientCountWbo.setAttribute("percent", df1.format(tempPercent));
                        }
                        dataEntryMap = new HashMap();
                        totalClientsCount1 += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));

                        dataEntryMap.put("name", clientCountWbo.getAttribute("campaignTitle"));
                        dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));

                        dataList.add(dataEntryMap);
                    }
                }

                // convert map to JSON string
                jsonText = JSONValue.toJSONString(dataList);

                request.setAttribute("totalClientsCount", totalClientsCount1);
                request.setAttribute("campaignClientsCounts", campaignClientsCounts1);
                request.setAttribute("jsonText", jsonText);

                request.setAttribute("campaignType", campaignType1);
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 106:
                servedPage = "/docs/reports/campaign_lastDays_ratio.jsp";
                campaignMgr = CampaignMgr.getInstance();

                String campaignType2 = request.getParameter("campaignType");
                ArrayList<WebBusinessObject> campaignClientsCounts2 = new ArrayList<WebBusinessObject>();
                dataList = new ArrayList();

                DecimalFormat df2 = new DecimalFormat("#");
                double tempPercent2;
                int totalRemainingDays = 0;
                int totalLastDays = 0;
                campaignMgr.getCampaignLastDaysRatio(request.getParameter("startDate"), request.getParameter("endDate"), "grpCamp");
                campaignClientsCounts2 = campaignMgr.getCampaignLastDaysRatio(request.getParameter("startDate"), request.getParameter("endDate"), "grpCamp");
                if (!campaignClientsCounts2.isEmpty()) {
                    // populate series data map
                    for (WebBusinessObject clientCountWbo : campaignClientsCounts2) {
                        dataEntryMap = new HashMap();
                        if (clientCountWbo.getAttribute("REMAINING_DAYS").equals("---")) {
                            dataEntryMap.put("name", clientCountWbo.getAttribute("campaignTitle"));
                            dataEntryMap.put("y", 0);
                            totalRemainingDays += 0;
                        } else {
                            dataEntryMap.put("name", clientCountWbo.getAttribute("campaignTitle"));
                            dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("REMAINING_DAYS")));
                            if (Integer.parseInt((String) clientCountWbo.getAttribute("REMAINING_DAYS")) >= 0) {
                                totalRemainingDays += Integer.valueOf(clientCountWbo.getAttribute("REMAINING_DAYS") + "");
                            } else {
                                totalRemainingDays += 0;
                            }
                        }
                        if (clientCountWbo.getAttribute("last_days").equals("---")) {

                            totalLastDays += 0;
                        } else {

                            totalLastDays += Integer.valueOf(clientCountWbo.getAttribute("last_days") + "");
                        }

                        //  totalClientsCount2 += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
                        dataList.add(dataEntryMap);
                    }
                }

                // convert map to JSON string
                jsonText = JSONValue.toJSONString(dataList);

                request.setAttribute("totalClientsCount", totalRemainingDays);
                request.setAttribute("totalLastDays", totalLastDays);
                request.setAttribute("campaignClientsCounts", campaignClientsCounts2);
                request.setAttribute("jsonText", jsonText);

                request.setAttribute("campaignType", campaignType2);
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            case 107:
                servedPage = "/docs/reports/campaign_days_details.jsp";
                String RDays = request.getParameter("REMAINING_DAYS");
                String lDays = request.getParameter("last_days");
                String tDays = request.getParameter("TOTALL_DAY");
                String targetCount = request.getParameter("target_count");
                String clientCount = request.getParameter("clientCount");
                String campaignID1 = request.getParameter("campaignID");
                String campaignTitle = request.getParameter("campaignTitle");
                CampaignMgr campMgr1 = CampaignMgr.getInstance();
                WebBusinessObject wb1 = campMgr1.getOnSingleKey("key", campaignID1);
                String TotalCost = (String) wb1.getAttribute("cost");
                int TotalCost1 = Integer.parseInt(TotalCost);
                int missed = Integer.parseInt(targetCount) - Integer.parseInt(clientCount);
                HashMap dataEntryMap1 = new HashMap();
                HashMap dataEntryMap2 = new HashMap();
                dataList = new ArrayList();
                if (Integer.parseInt(RDays) < 0) {
                    dataEntryMap1.put("name", "Remaining Days");
                    dataEntryMap1.put("y", 0);
                    dataList.add(dataEntryMap1);
                    dataEntryMap2.put("name", "elapsed Days");
                    dataEntryMap2.put("y", Integer.parseInt(tDays));
                    dataList.add(dataEntryMap2);
                } else {

                    dataEntryMap2.put("name", "elapsed Days");
                    dataEntryMap2.put("y", Integer.parseInt(lDays));
                    dataList.add(dataEntryMap2);
                    dataEntryMap1.put("name", "Remaining Days");
                    dataEntryMap1.put("y", Integer.parseInt(RDays));
                    dataList.add(dataEntryMap1);
                }

                jsonText = JSONValue.toJSONString(dataList);
                //      

                String jsonText2;
                HashMap dataEntryMap3 = new HashMap();
                HashMap dataEntryMap4 = new HashMap();
                ArrayList dataList1 = new ArrayList();
                dataEntryMap3.put("name", "Registered Clients");
                dataEntryMap3.put("y", Integer.parseInt(clientCount));
                dataList1.add(dataEntryMap3);
                dataEntryMap4.put("name", "missed Clients");
                if (missed <= 0) {
                    dataEntryMap4.put("y", 0);
                } else {
                    dataEntryMap4.put("y", missed);
                }

                dataList1.add(dataEntryMap4);
                jsonText2 = JSONValue.toJSONString(dataList1);

                ChannelsExpenseMgr channelsExpenseMgr = ChannelsExpenseMgr.getInstance();
                ArrayList<LiteWebBusinessObject> data = channelsExpenseMgr.getChannelExpenses(campaignID1);
                int SumEx = 0;
                for (LiteWebBusinessObject wbo5 : data) {
                    SumEx += Integer.valueOf((String) wbo5.getAttribute("option2"));

                }
                String jsonText3;
                HashMap dataEntryMap5 = new HashMap();
                HashMap dataEntryMap6 = new HashMap();
                ArrayList dataList3 = new ArrayList();
                dataEntryMap5.put("name", "Estimated cost");
                if (TotalCost1 <= 0) {
                    dataEntryMap5.put("y", 0);
                } else {
                    dataEntryMap5.put("y", TotalCost1);
                }

                dataEntryMap6.put("name", "Spending");
                dataEntryMap6.put("y", SumEx);

                dataList3.add(dataEntryMap5);
                dataList3.add(dataEntryMap6);
                jsonText3 = JSONValue.toJSONString(dataList3);

                request.setAttribute("jsonText", jsonText);
                request.setAttribute("jsonText1", jsonText2);
                request.setAttribute("jsonText3", jsonText3);
                request.setAttribute("RDays", RDays);
                request.setAttribute("lDays", lDays);
                request.setAttribute("tDays", tDays);
                request.setAttribute("targetCount", targetCount);
                request.setAttribute("clientCount", clientCount);
                request.setAttribute("campaignID1", campaignID1);
                request.setAttribute("campaignTitle", campaignTitle);
                request.setAttribute("TotalCost", TotalCost1);
                request.setAttribute("SumEx", SumEx);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
            case 108:
                servedPage = "/docs/client/client_inter_local_report.jsp";
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                clientMgr = ClientMgr.getInstance();
                fromDateStr = request.getParameter("fromDate");
                toDateStr = request.getParameter("toDate");
                if (fromDateStr != null) {
                    try {
                        clients = clientMgr.getUserClientsInterLocal(request.getParameter("currentOwnerID"), sdf.parse(fromDateStr),
                                sdf.parse(toDateStr), request.getParameter("clientType"));
                    } catch (ParseException ex) {
                        clients = new ArrayList<>();
                    }
                    request.setAttribute("data", clients);
                    request.setAttribute("currentOwnerID", request.getParameter("currentOwnerID"));
                    request.setAttribute("clientType", request.getParameter("clientType"));
                    request.setAttribute("groupID", request.getParameter("groupID"));
                } else {
                    toDateStr = sdf.format(cal.getTime());
                    cal.add(Calendar.MONTH, -1);
                    fromDateStr = sdf.format(cal.getTime());
                }
                request.setAttribute("fromDate", fromDateStr);
                request.setAttribute("toDate", toDateStr);
                request.setAttribute("groups", UserGroupConfigMgr.getInstance().getAllUserGroupConfig((String) persistentUser.getAttribute("userId")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 109:
                servedPage = "/docs/client/my_client_inter_local_report.jsp";
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                clientMgr = ClientMgr.getInstance();
                fromDateStr = request.getParameter("fromDate");
                toDateStr = request.getParameter("toDate");
                if (fromDateStr != null) {
                    try {
                        clients = clientMgr.getUserClientsInterLocal((String) persistentUser.getAttribute("userId"), sdf.parse(fromDateStr),
                                sdf.parse(toDateStr), request.getParameter("clientType"));
                    } catch (ParseException ex) {
                        clients = new ArrayList<>();
                    }
                    request.setAttribute("data", clients);
                    request.setAttribute("clientType", request.getParameter("clientType"));
                } else {
                    toDateStr = sdf.format(cal.getTime());
                    cal.add(Calendar.MONTH, -1);
                    fromDateStr = sdf.format(cal.getTime());
                }
                request.setAttribute("fromDate", fromDateStr);
                request.setAttribute("toDate", toDateStr);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 110:
                servedPage = "/docs/client/average_customer_purchase_time.jsp";
                clientMgr = ClientMgr.getInstance();
                if (request.getParameter("campaignID") != null) {
                    clientRatingMgr = ClientRatingMgr.getInstance();
                    request.setAttribute("clientsList", clientMgr.getAverageCustomerPurchaseTime(request.getParameter("campaignID")));
                    request.setAttribute("campaignID", request.getParameter("campaignID"));
                }
                campaignMgr = CampaignMgr.getInstance();
                campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(null, null, request.getParameter("statusID"),
                        (String) persistentUser.getAttribute("userId"), request.getParameter("departmentID"), false));
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 111:
                servedPage = "/docs/client/rating_history_report.jsp";
                clientRatingMgr = ClientRatingMgr.getInstance();
                request.setAttribute("ratesList", request.getParameter("clientID") != null
                        ? clientRatingMgr.getClientRateingHistory(request.getParameter("clientID")) : new ArrayList<>());
                request.setAttribute("clientID", request.getParameter("clientID"));
                request.setAttribute("clientName", request.getParameter("clientName"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 112:
                servedPage = "/docs/reports/employee_call_statistics.jsp";
                commentsMgr = CommentsMgr.getInstance();
                fromDateS = request.getParameter("fromDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (fromDateS == null) {
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && request.getParameter("createdBy") != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    appointmentMgr = AppointmentMgr.getInstance();
                    wbo = appointmentMgr.getEmployeeCallStatistics(request.getParameter("createdBy"), fromDateD);
                    if (wbo != null && wbo.countAttribute() > 0) {
                        ArrayList<String> tagNameList = new ArrayList<>();
                        ArrayList graphResultList = new ArrayList();
                        Map<String, Object> graphDataMap = new HashMap<>();
                        ArrayList statisticsList = new ArrayList();
                        statisticsList.add(wbo.getAttribute("total12"));
                        statisticsList.add(wbo.getAttribute("total15"));
                        statisticsList.add(wbo.getAttribute("total18"));
                        statisticsList.add(wbo.getAttribute("total21"));
                        graphDataMap.put("name", "'No. of Calls'");
                        graphDataMap.put("data", statisticsList);
                        graphResultList.add(graphDataMap);
                        String ratingCategories = JSONValue.toJSONString(tagNameList);
                        String resultsJson = JSONValue.toJSONString(graphResultList);
                        request.setAttribute("ratingCategories", ratingCategories);
                        request.setAttribute("jsonText", resultsJson);
                    }
                } else {
                    wbo = new WebBusinessObject();
                }
                userGroupCongMgr = UserGroupConfigMgr.getInstance();
                groupMgr = GroupMgr.getInstance();
                ArrayList<WebBusinessObject> groupsList = new ArrayList<>();
                ArrayList<WebBusinessObject> userGroups = new ArrayList<>();
                try {
                    userGroups = new ArrayList<>(userGroupCongMgr.getOnArbitraryKey(loggedUser.getAttribute("userId").toString(), "key2"));
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (!userGroups.isEmpty()) {
                    for (WebBusinessObject userGroupsWbo : userGroups) {
                        WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                        groupsList.add(groupWbo);
                    }
                }
                request.setAttribute("groupsList", groupsList);
                request.setAttribute("groupId", request.getParameter("groupId"));
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("createdBy", request.getParameter("createdBy"));
                request.setAttribute("dataWbo", wbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 113:
                servedPage = "/docs/reports/comments_on_employee_report.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                c = Calendar.getInstance();
                toDateStr = request.getAttribute("toDate") != null ? request.getParameter("toDate") : sdf.format(c.getTime());
                c.add(Calendar.DATE, -7);
                fromDateStr = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(c.getTime());
                try {
                    fromDate = new java.sql.Date(sdf.parse(fromDateStr).getTime());
                    toDate = new java.sql.Date(sdf.parse(toDateStr).getTime());
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (request.getParameter("employeeID") != null) {
                    commentsMgr = CommentsMgr.getInstance();
                    request.setAttribute("data", commentsMgr.getCommentsOnEmployee(fromDate, toDate, request.getParameter("employeeID"),
                            request.getParameter("commentType")));
                    request.setAttribute("employeeID", request.getParameter("employeeID"));
                    request.setAttribute("commentType", request.getParameter("commentType"));
                }
                departments = new ArrayList<>();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                selectedDepartment = request.getParameter("departmentID");
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "ظ„ط§ ظٹظˆط¬ط¯");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "all";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                employeeList = new ArrayList<>();
                if (selectedDepartment != null && selectedDepartment.equals("all")) {
                    for (WebBusinessObject departmentWbo : departments) {
                        if (departmentWbo != null) {
                            employeeList.addAll(userMgr.getEmployeeByDepartmentId((String) departmentWbo.getAttribute("projectID"), null, null));
                        }
                    }
                } else {
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                }
                request.setAttribute("fromDate", fromDateStr);
                request.setAttribute("toDate", toDateStr);
                request.setAttribute("departmentID", selectedDepartment);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("departments", departments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 114:
                servedPage = "/docs/reports/campaign_clients_details.jsp";
                fromDate = null;
                toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                c = Calendar.getInstance();
                toDateStr = request.getAttribute("endDate") != null ? request.getParameter("endDate") : sdf.format(c.getTime());
                c.add(Calendar.DATE, -7);
                fromDateStr = request.getParameter("startDate") != null ? request.getParameter("startDate") : sdf.format(c.getTime());
                try {
                    fromDate = new java.sql.Date(sdf.parse(fromDateStr).getTime());
                    toDate = new java.sql.Date(sdf.parse(toDateStr).getTime());
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                Set<String> ratesNames = new HashSet<>();
                ArrayList graphResultList = new ArrayList();
                ArrayList<String> graphRatesNames = new ArrayList();

                campaignMgr = CampaignMgr.getInstance();
                Map<String, Map<String, String>> graphResult = CampaignMgr.getInstance().getCampaignClientsDetails(request.getParameter("campaignID"), fromDate, toDate, ratesNames);

                if (request.getParameter("campaignID") != null) {
                    for (String rate : ratesNames) {
                        graphRatesNames.add(rate);
                    }

                    Set<String> campDataList = graphResult.keySet();

                    for (String campTitle : campDataList) {
                        Map<String, Object> graphDataMap = new HashMap<String, Object>();

                        Map<String, String> campResult = graphResult.get(campTitle);
                        graphDataMap.put("name", campTitle);

                        ArrayList tempData = new ArrayList();
                        for (String rate : ratesNames) {
                            if (campResult.containsKey(rate)) {
                                tempData.add(new Integer(campResult.get(rate)));
                            } else {
                                tempData.add(0);
                            }
                        }

                        graphDataMap.put("data", tempData);
                        graphResultList.add(graphDataMap);
                    }

                    String ratingCategories = JSONValue.toJSONString(graphRatesNames);
                    String resultsJson = JSONValue.toJSONString(graphResultList);

                    request.setAttribute("data", graphResult);
                    request.setAttribute("ratingCategories", ratingCategories);
                    request.setAttribute("resultsJson", resultsJson);
                }
                ratesNames.add("Not Rated");

                request.setAttribute("campaignWbo", campaignMgr.getOnSingleKey(request.getParameter("campaignID")));
                request.setAttribute("ratesNames", ratesNames);
                request.setAttribute("startDate", fromDateStr);
                request.setAttribute("endDate", toDateStr);
                request.setAttribute("campaignID", request.getParameter("campaignID"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 115:
                servedPage = "/docs/client/trade_clients_list.jsp";
                String tradeID = request.getParameter("tradeID");
                tradeMgr = TradeMgr.getInstance();
                clientMgr = ClientMgr.getInstance();
                request.setAttribute("tradeWbo", tradeMgr.getOnSingleKey(tradeID));
                request.setAttribute("data", clientMgr.getTradeClients(tradeID, request.getParameter("isCustomer").equalsIgnoreCase("true")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 116:
                servedPage = "/docs/campaign/Campaign_Stat.jsp";

                campaignMgr = CampaignMgr.getInstance();

                //Dates
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");

                request.setAttribute("toDate", sdf.format(c.getTime()));
                c.add(Calendar.MONTH, -1);
                request.setAttribute("fromDate", sdf.format(c.getTime()));

                //Campaigns
                try {
                    request.setAttribute("campaignsList", new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("0", "key3")));
                } catch (Exception ex) {
                    request.setAttribute("campaignsList", new ArrayList<>());
                }

                //Rates
                try {
                    request.setAttribute("ratesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("ratesList", new ArrayList<>());
                }

                String rateID = request.getParameter("rateID");
                String[] campaignIDs = request.getParameterValues("campaignID");
                fromDateStr = request.getParameter("fromDate");
                toDateStr = request.getParameter("toDate");

                String jsonResultText = null;
                ArrayList jasonResult = new ArrayList();
                ArrayList<String> WeeksList = new ArrayList<>();
                ArrayList<WebBusinessObject> campsDgrdtionList = new ArrayList<>();

                if (rateID != null && campaignIDs != null) {
                    WeeksList = ClientRatingMgr.getInstance().getWeeksList(campaignIDs, rateID, fromDateStr, toDateStr);
                    if (WeeksList.size() > 0 && WeeksList != null) {
                        campsDgrdtionList = ClientRatingMgr.getInstance().geCampDegradation(campaignIDs, rateID, fromDateStr, toDateStr, WeeksList);

                        for (int i = 0; i < campsDgrdtionList.size(); i++) {
                            HashMap campsDegMap = new HashMap();

                            WebBusinessObject campWbo = (WebBusinessObject) campsDgrdtionList.get(i);

                            ArrayList<Integer> campDragResult = new ArrayList<>();
                            for (String camResult : WeeksList) {
                                campDragResult.add(new Integer(campWbo.getAttribute(camResult).toString()));
                            }

                            campsDegMap.put("name", campWbo.getAttribute("CAMPAIGN_TITLE"));
                            campsDegMap.put("data", campDragResult);

                            jasonResult.add(campsDegMap);
                        }

                        jsonResultText = JSONValue.toJSONString(jasonResult);
                    }

                    if (WeeksList.size() > 0) {
                        request.setAttribute("rangeString", "Range: " + WeeksList.get(0) + " to " + WeeksList.get(WeeksList.size() - 1));
                        request.setAttribute("startingPoint", WeeksList.get(0));
                    }

                    request.setAttribute("campsDgrdtionList", campsDgrdtionList);
                    request.setAttribute("WeeksList", WeeksList);
                    request.setAttribute("jsonResultText", jsonResultText);
                    request.setAttribute("jsonWeeksList", JSONValue.toJSONString(WeeksList));

                    request.setAttribute("fromDate", fromDateStr);
                    request.setAttribute("toDate", toDateStr);
                    request.setAttribute("rateID", rateID);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

//                servedPage = "/docs/client/client_class_report.jsp";
//                fromDate = null;
//                toDate = null;
//                sdf = new SimpleDateFormat("yyyy-MM-dd");
//                c = Calendar.getInstance();
//                String toDateStr = request.getAttribute("toDate") != null ? request.getParameter("toDate") : sdf.format(c.getTime());
//                c.add(Calendar.MONTH, -1);
//                String fromDateStr = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(c.getTime());
//                try {
//                    if (request.getParameter("fromDate") != null) {
//                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
//                    }
//                    if (request.getParameter("toDate") != null) {
//                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
//                    }
//                } catch (ParseException ex) {
//                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//                if (fromDate != null && toDate != null) {
//                    String[] campaignIDs = request.getParameterValues("campaignID");
//                    String projectIDs = request.getParameter("projectID");
//                    String[] rateIDs = request.getParameterValues("rateID");
//                    employeeID = request.getParameter("employeeID");
//                    String clntTyp = request.getParameter("clsUncls");
//                    departmentID = request.getParameter("departmentID");
//                    clientRatingMgr = ClientRatingMgr.getInstance();
//                    ArrayList<WebBusinessObject> clientsList = new ArrayList<WebBusinessObject>();
//
//                    if (clntTyp != null && clntTyp.equals("cls")) {
//                        clientsList = clientRatingMgr.getClientRateInterval(fromDate, toDate,
//                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null,
//                                projectIDs,
//                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
//                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
//                        String clientCreationTime, ratingTime;
//                        for (WebBusinessObject clientTempWbo : clientsList) {
//                            clientCreationTime = (String) clientTempWbo.getAttribute("clientCreationTime");
//                            clientCreationTime = clientCreationTime.length() > 16 ? clientCreationTime.substring(0, 16) : clientCreationTime;
//                            clientTempWbo.setAttribute("clientCreationTime", clientCreationTime);
//                            String fAppTime = (String) clientTempWbo.getAttribute("mct");
//                            ratingTime = (String) clientTempWbo.getAttribute("creationTime");
//                            ratingTime = ratingTime.substring(0, 16);
//                            fAppTime = fAppTime.substring(0, 16);
//                            clientTempWbo.setAttribute("creationTime", ratingTime);
//                            clientTempWbo.setAttribute("mct", fAppTime);
//                            try {
//                                clientTempWbo.setAttribute("diffDays", ((sdf.parse(fAppTime).getTime() - sdf.parse(clientCreationTime).getTime()) / (1000 * 60 * 60 * 24)) + "");
//                            } catch (ParseException ex) {
//                                clientTempWbo.setAttribute("diffDays", "---");
//                            }
//                        }
//
//                        clientsCounts = clientRatingMgr.getClientRateCountInterval(fromDate, toDate,
//                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null,
//                                projectIDs,
//                                rateIDs != null ? "'" + Tools.arrayToString(rateIDs, "','") + "'" : null, employeeID,
//                                request.getParameter("type"), request.getParameter("dateType"), departmentID);
//                        dataList = new ArrayList();
//                        totalClientsCount = 0;
//                        // populate series data map
//                        for (WebBusinessObject clientCountWbo : clientsCounts) {
//                            if (clientCountWbo.getAttribute("clientCount") != null) {
//                                dataEntryMap = new HashMap();
//                                totalClientsCount += Integer.parseInt((String) clientCountWbo.getAttribute("clientCount"));
//                                dataEntryMap.put("name", clientCountWbo.getAttribute("rateName"));
//                                dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("clientCount")));
//                                dataList.add(dataEntryMap);
//                            }
//                        }
//                        // convert map to JSON string
//                        jsonText = JSONValue.toJSONString(dataList);
//                        request.setAttribute("jsonText", jsonText);
//                        request.setAttribute("dataList", clientsCounts);
//
//                        request.setAttribute("campaignID", campaignIDs != null ? Tools.arrayToString(campaignIDs, ",") : null);
//                        request.setAttribute("projectID", projectIDs);
//                        request.setAttribute("rateID", rateIDs != null ? Tools.arrayToString(rateIDs, ",") : null);
//
//                    } else if (clntTyp != null && clntTyp.equals("uncls")) {
//                        departmentID = request.getParameter("departmentID");
//                        clientMgr = ClientMgr.getInstance();
//                        clientsList = clientMgr.selectUnratedCl(fromDate, toDate,
//                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null, employeeID,
//                                projectIDs,
//                                request.getParameter("type"), departmentID);
//
//                        wbo = clientMgr.selectUnratedRatedCountCl(fromDate, toDate,
//                                campaignIDs != null ? "'" + Tools.arrayToString(campaignIDs, "','") + "'" : null, employeeID,
//                                projectIDs,
//                                request.getParameter("type"), departmentID);
//                        dataList = new ArrayList();
//                        totalClientsCount = 0;
//                        // populate series data map
//                        if (wbo != null) {
//                            if (wbo.getAttribute("totalRated") != null) {
//                                dataEntryMap = new HashMap();
//                                totalClientsCount += Integer.parseInt((String) wbo.getAttribute("totalRated"));
//                                dataEntryMap.put("name", " Rated Clients ");
//                                dataEntryMap.put("y", Integer.parseInt((String) wbo.getAttribute("totalRated")));
//                                dataList.add(dataEntryMap);
//                            }
//                            if (wbo.getAttribute("totalUnrated") != null) {
//                                dataEntryMap = new HashMap();
//                                totalClientsCount += Integer.parseInt((String) wbo.getAttribute("totalUnrated"));
//                                dataEntryMap.put("name", " Unrated Clients ");
//                                dataEntryMap.put("y", Integer.parseInt((String) wbo.getAttribute("totalUnrated")));
//                                dataList.add(dataEntryMap);
//                            }
//                        }
//                        // convert map to JSON string
//                        jsonText = JSONValue.toJSONString(dataList);
//                        request.setAttribute("res", jsonText);
//                        request.setAttribute("campaignID", campaignIDs != null ? Tools.arrayToString(campaignIDs, ",") : null);
//                        request.setAttribute("projectID", projectIDs);
//                        request.setAttribute("rateID", rateIDs != null ? Tools.arrayToString(rateIDs, ",") : null);
//                    }
//                    request.setAttribute("clientsList", clientsList);
//                    request.setAttribute("fromDate", request.getParameter("fromDate"));
//                    request.setAttribute("toDate", request.getParameter("toDate"));
//                    request.setAttribute("employeeID", request.getParameter("employeeID"));
//                    request.setAttribute("type", request.getParameter("type"));
//                    request.setAttribute("clsUncls", request.getParameter("clsUncls"));
//                } else {
//                    c = Calendar.getInstance();
//                    sdf.applyPattern("yyyy-MM-dd");
//                    request.setAttribute("toDate", sdf.format(c.getTime()));
//                    c.add(Calendar.MONTH, -1);
//                    request.setAttribute("fromDate", sdf.format(c.getTime()));
//                }
//                campaignMgr = CampaignMgr.getInstance();
//                //   ArrayList<WebBusinessObject> campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
//                campaignsList = new ArrayList<>(campaignMgr.getAllCampaign(null, null, request.getParameter("statusID"),
//                        (String) persistentUser.getAttribute("userId"), null, false));
//                request.setAttribute("campaignsList", campaignsList);
//                ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
//                try {
//                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
//
//                    request.setAttribute("employees", userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId")));
//                } catch (Exception ex) {
//                }
//
//                try {
//                    request.setAttribute("typesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RQ-TYPE", "key4")));
//                } catch (Exception ex) {
//                    request.setAttribute("typesList", new ArrayList<>());
//                }
//
//                try {
//                    if (request.getParameter("campaignID") == null || request.getParameter("campaignID").isEmpty()) {
//                        request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
//                    } else {
//                        request.setAttribute("projectsList", CampaignProjectMgr.getInstance().getProjectByCampaignList(request.getParameter("campaignID")));
//                    }
//                } catch (Exception ex) {
//                    logger.error(ex);
//                    request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
//                }
//
//                request.setAttribute("ratesList", ratesList);
//
//                ArrayList<WebBusinessObject> departments = new ArrayList<WebBusinessObject>();
//                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
//                projectMgr = ProjectMgr.getInstance();
//                String selectedDepartment = request.getParameter("departmentID");
//                try {
//                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
//                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
//                        if (projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
//                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
//                        }
//                    }
//                    if (departments.isEmpty()) {
//                        WebBusinessObject wboTemp = new WebBusinessObject();
//                        wboTemp.setAttribute("projectName", "ظ„ط§ ظٹظˆط¬ط¯");
//                        wboTemp.setAttribute("projectID", "none");
//                        departments.add(wboTemp);
//                        ArrayList list = new ArrayList<>();
//                    } else {
//                        if (selectedDepartment == null) {
//                            selectedDepartment = "all";
//                        }
//                    }
//                } catch (Exception ex) {
//                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                List<WebBusinessObject> employeeList = new ArrayList<WebBusinessObject>();
//                if (selectedDepartment != null && selectedDepartment.equals("all")) {
//                    for (WebBusinessObject departmentWbo : departments) {
//                        if (departmentWbo != null) {
//                            employeeList.addAll(userMgr.getEmployeeByDepartmentId((String) departmentWbo.getAttribute("projectID"), null, null));
//                        }
//                    }
//                } else {
//                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
//                }
//
////                try {
////                    request.setAttribute("campaignsList", new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("0", "key3")));
////                } catch (Exception ex) {
////                    request.setAttribute("campaignsList", new ArrayList<>());
////                }
//                request.setAttribute("dateType", request.getParameter("dateType"));
//                request.setAttribute("departmentID", selectedDepartment);
//                request.setAttribute("employeeList", employeeList);
//                request.setAttribute("departments", departments);
//                request.setAttribute("smry", request.getParameter("smry"));
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
                break;
            case 117:
                servedPage = "/docs/reports/loginInDayReport.jsp";
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                fromDateS = request.getParameter("fromDate");
                departmentID = request.getParameter("department");
                userID = request.getParameter("userID");                
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    ArrayList<WebBusinessObject> departmentsList = new ArrayList<>();
                    ArrayList<WebBusinessObject> usersLst = new ArrayList<>();
                    HashSet<String> usersLst2 = new HashSet<>();                    
                    ArrayList<WebBusinessObject> usersLst3 = new ArrayList<>();                    
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        String departID=userDepartmentWbo.getAttribute("department_id").toString();
                        departmentsList.add(projectMgr.getOnSingleKey(departID));
                        usersLst.addAll(new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle(departID, "key1")));                        
                    }
                    userMgr=UserMgr.getInstance();
                    usersLst.removeIf(wbo4->(userMgr.getOnSingleKey("key",wbo4.getAttribute("user_id").toString())==null));
                    usersLst.forEach(wbo3->usersLst2.add(userMgr.getOnSingleKey("key",wbo3.getAttribute("user_id").toString()).getAttribute("userId").toString()));
                    usersLst2.forEach(str->usersLst3.add(userMgr.getOnSingleKey("key",str)));
                    request.setAttribute("usersLst", usersLst3);
                    request.setAttribute("departmentsList", departmentsList);
                    request.setAttribute("userDepartments", userDepartments);
                } catch (Exception ex) {
                    request.setAttribute("departmentsList", new ArrayList<>());
                }
                if (fromDateS != null && departmentID!=null && userID!=null) { // search
                    try {
                        LoginHistoryMgr loginHistoryMgr = LoginHistoryMgr.getInstance();
                        fromDate = new java.sql.Date(sdf.parse(fromDateS).getTime());
                        if(departmentID.equalsIgnoreCase("all"))
                        request.setAttribute("data", loginHistoryMgr.getLoginInDay(loggedUser.getAttribute("userId").toString(),fromDate,departmentID,userID));
                        else
                        request.setAttribute("data", loginHistoryMgr.getLoginInDay(loggedUser.getAttribute("userId").toString(),fromDate,departmentID,userID));
                    } catch (ParseException ex) {
                        request.setAttribute("projectsList", new ArrayList<>());
                    }
                    request.setAttribute("fromDate", fromDateS);
                }
                request.setAttribute("userID", userID);
                request.setAttribute("department", departmentID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 118:
                servedPage = "/docs/campaign/Campaign_Rates_Stat.jsp";

                campaignMgr = CampaignMgr.getInstance();

                //Dates
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");

                request.setAttribute("toDate", sdf.format(c.getTime()));
                c.add(Calendar.MONTH, -1);
                request.setAttribute("fromDate", sdf.format(c.getTime()));

                //Campaigns
                try {
                    request.setAttribute("campaignsList", new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("0", "key3")));
                } catch (Exception ex) {
                    request.setAttribute("campaignsList", new ArrayList<>());
                }

                //Rates
                try {
                    request.setAttribute("ratesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("ratesList", new ArrayList<>());
                }

                String[] rateIDs = request.getParameterValues("rateID");
                campaignID = request.getParameter("campaignID");
                fromDateStr = request.getParameter("fromDate");
                toDateStr = request.getParameter("toDate");

                jsonResultText = null;
                String clientJsonResultText = null;
                jasonResult = new ArrayList();
                ArrayList clientJasonResult = new ArrayList();
                WeeksList = new ArrayList<>();
                ArrayList<WebBusinessObject> campsRatesDgrdtionList = new ArrayList<>();
                ArrayList<WebBusinessObject> clntCampDgrdtionList = new ArrayList<>();

                if (rateIDs != null && campaignID != null) {
                    WebBusinessObject campInfoWbo = campaignMgr.getCampaignInfo(campaignID, fromDateStr, toDateStr);
                    String campaignLastUse = ClientRatingMgr.getInstance().geCampaignLastUse(campaignID, fromDateStr, toDateStr);
                    WeeksList = ClientRatingMgr.getInstance().getRatesWeeksList(rateIDs, campaignID, fromDateStr, toDateStr);
                    if (WeeksList.size() > 0 && WeeksList != null) {

                        campsRatesDgrdtionList = ClientRatingMgr.getInstance().geCampRatesDegradation(rateIDs, campaignID, fromDateStr, toDateStr, WeeksList);
                        clntCampDgrdtionList = ClientRatingMgr.getInstance().geClientCampDegradation(campaignID, fromDateStr, toDateStr, WeeksList);

                        for (int i = 0; i < campsRatesDgrdtionList.size(); i++) {
                            HashMap campsDegMap = new HashMap();

                            WebBusinessObject campWbo = (WebBusinessObject) campsRatesDgrdtionList.get(i);

                            ArrayList<Integer> campDragResult = new ArrayList<>();
                            for (String camResult : WeeksList) {
                                campDragResult.add(new Integer(campWbo.getAttribute(camResult).toString()));
                            }

                            campsDegMap.put("name", campWbo.getAttribute("Rate_Name"));
                            campsDegMap.put("data", campDragResult);

                            jasonResult.add(campsDegMap);
                        }

                        for (int i = 0; i < clntCampDgrdtionList.size(); i++) {
                            HashMap clientCampDegMap = new HashMap();

                            WebBusinessObject campWbo = (WebBusinessObject) clntCampDgrdtionList.get(i);

                            ArrayList<Integer> clientCampDragResult = new ArrayList<>();
                            for (String clientCampResult : WeeksList) {
                                clientCampDragResult.add(new Integer(campWbo.getAttribute(clientCampResult).toString()));
                            }

                            clientCampDegMap.put("name", "Number of Clients");
                            clientCampDegMap.put("data", clientCampDragResult);

                            clientJasonResult.add(clientCampDegMap);
                        }

                        jsonResultText = JSONValue.toJSONString(jasonResult);
                        clientJsonResultText = JSONValue.toJSONString(clientJasonResult);
                    }

                    if (WeeksList.size() > 0) {
                        request.setAttribute("rangeString", "Range: " + WeeksList.get(0) + " to " + WeeksList.get(WeeksList.size() - 1));
                        request.setAttribute("startingPoint", WeeksList.get(0));
                    }

                    request.setAttribute("campsRatingDgrdtionList", campsRatesDgrdtionList);
                    request.setAttribute("clntCampDgrdtionList", clntCampDgrdtionList);
                    
                    request.setAttribute("jsonResultText", jsonResultText);
                    request.setAttribute("clientJsonResultText", clientJsonResultText);
                    
                    request.setAttribute("WeeksList", WeeksList);
                    request.setAttribute("jsonWeeksList", JSONValue.toJSONString(WeeksList));
                    

                    request.setAttribute("fromDate", fromDateStr);
                    request.setAttribute("toDate", toDateStr);
                    request.setAttribute("campaignID", campaignID);
                    request.setAttribute("campInfoWbo", campInfoWbo);
                    request.setAttribute("campaignLastUse", campaignLastUse); 
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 119:
                servedPage="/docs/campaign/client_campaign_details.jsp";
                clientRatingMgr=ClientRatingMgr.getInstance();
                campaignID=request.getParameter("campaignID");
                rateID=request.getParameter("rateIDs");
                 String startDate=request.getParameter("startDate");
                  endDate=request.getParameter("endDate");
                  String weekno=request.getParameter("weekno");
                
                  ArrayList<WebBusinessObject> clientsDet =clientRatingMgr.getCampClientDetails(campaignID, rateID, startDate, endDate, weekno);
                 request.setAttribute("campaignID", campaignID);
                 request.setAttribute("rateID", rateID);
                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("weekno", weekno);
                request.setAttribute("clientsDet", clientsDet);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 120:
                clientMgr = ClientMgr.getInstance();
                type=request.getParameter("type");
                clientCountList = clientMgr.getJobStatistics(type.equalsIgnoreCase("customer"));
                workBook = new HSSFWorkbook();
                c = Calendar.getInstance();
                fileDate = c.getTime();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                sdf.applyPattern("yyyy-MM-dd");
                reportDate = sdf.format(fileDate);
                filename = new String();
                String[] headerStr1 = new String[1];
                headerStr1[0]="Clients Job Statistics";
                String[] headerValuesStr = new String[1];
                
                String headers1[] = {"#", "Job Name", "Client Count"};
                String attributes1[] = {"Number", "jobName", "clientCount"};
                String dataTypes1[] = {"", "String", "String"};
                workBook = Tools.createExcelReport("Clients Job Statistics", headerStr1, headerValuesStr, headers1, attributes1, dataTypes1, clientCountList);
                filename = "ClientsJobStatistics" + reportDate;
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
            case 121:
                out = response.getWriter();
                 userId=request.getParameter("userID");
                String day=request.getParameter("day");
                sdf=new SimpleDateFormat("yyyy/MM/dd");
                fromDate=null;
                toDate=null;
                try {
                    fromDate = new java.sql.Date(sdf.parse(day).getTime());
                    c = Calendar.getInstance();
                    c.setTime(sdf.parse(day));
                    c.add(Calendar.DATE, 1); 
                    toDate=new java.sql.Date(c.getTimeInMillis());
                } catch (ParseException ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                LoginHistoryMgr loginHistoryMgr=LoginHistoryMgr.getInstance();
                 wbo=new WebBusinessObject();
                        
                wbo.setAttribute("data", loginHistoryMgr.getUserAttendanceInPeriod(fromDate, toDate, userId));
                out.write(Tools.getJSONArrayAsString(loginHistoryMgr.getUserAttendanceInPeriod(fromDate, fromDate, userId)));
                break;
            case 122:
                out = response.getWriter();
                String departID=request.getParameter("departID");
                userMgr=UserMgr.getInstance();
                ArrayList<WebBusinessObject> usersDepartment = new ArrayList<>();
                ArrayList<WebBusinessObject> users = new ArrayList<>();
                try {
                     usersDepartment = userMgr.getEmployeeByDepartmentId(departID, null, null);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONArrayAsString(usersDepartment));
                break;
                case 123:
                    String reportName;
                    String reportType = request.getParameter("reportType");
                    String fast = request.getParameter("fast");
                    if(fast == null) {
                    reportName = request.getParameter("reportName");
                    } else {
                    reportName = request.getParameter("fast");
                    }

                    params = new HashMap();
                    
                    if(reportName.equals("operation_order_basic")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String truckOp = request.getParameter("truck");
                    String trailerOp = request.getParameter("trailer");
                    String mantru = request.getParameter("mantru");
                    String mantra = request.getParameter("mantra");
                    String statusOp = request.getParameter("typeID");
                    String clientOp = request.getParameter("clientID");
                    String supervisorOp = request.getParameter("supervisorID");
                    String driverOp = request.getParameter("driverID");
                    String loadedOp = request.getParameter("loadingType");
                    String workOp = request.getParameter("workingType");
                    String requestOp = request.getParameter("shipp");
                    String trip = request.getParameter("trip");
                    String sanadOP = request.getParameter("sanad");

                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", truckOp);
                    params.put("trailer", trailerOp);
                    params.put("brand_car", mantru);
                    params.put("brand_trailer", mantra);
                    params.put("main", statusOp);
                    params.put("client", clientOp);
                    params.put("supervisor", supervisorOp);
                    params.put("driver", driverOp);
                    params.put("loaded", loadedOp);
                    params.put("work", workOp);
                    params.put("request", requestOp);
                    params.put("trip", trip);
                    params.put("sanad", sanadOP);
                    } else if(reportName.equals("operation_order_details")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String truckOp = request.getParameter("truck");
                    String orderNoOp = request.getParameter("orderno");

                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", truckOp);
                    params.put("trip", orderNoOp);
                    } else if(reportName.equals("Final_Attachment")) {
                        if(request.getParameter("purpose").equals("1")){
                            reportName = "Final_Attachment";
                            String mainTypeTr = request.getParameter("mainTypeTr");
                            String brandTr = request.getParameter("brandTr");
                            String carTr = request.getParameter("carTr");

                            params.put("mainTypeTr", mainTypeTr);
                            params.put("brandTr", brandTr);
                            params.put("carTr", carTr);
                        } else if(request.getParameter("purpose").equals("2")){
                            reportName = "Final_Attachment_Tr";
                            String mainTypeTl = request.getParameter("mainTypeTl");
                            String brandTl = request.getParameter("brandTl");
                            String carTl = request.getParameter("carTl");

                            params.put("mainTypeTl", mainTypeTl);
                            params.put("brandTl", brandTl);
                            params.put("carTl", carTl);
                        }
                    String mainTypeTr = request.getParameter("mainTypeTr");
                    //String mainTypeTl = request.getParameter("mainTypeTl");
                    String brandTr = request.getParameter("brandTr");
                    //String brandTl = request.getParameter("brandTl");
                    String carTr = request.getParameter("carTr");
                    //String carTl = request.getParameter("carTl");

                    params.put("mainTypeTr", mainTypeTr);
                    //params.put("mainTypeTl", mainTypeTl);
                    params.put("brandTr", brandTr);
                    //params.put("brandTl", brandTl);
                    params.put("carTr", carTr);
                    //params.put("carTl", carTl);
                    } else if(reportName.equals("calculate_driver")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String truckOp = request.getParameter("truck");
                    String trailerOp = request.getParameter("trailer");
                    String statusOp = request.getParameter("typeID");
                    String clientOp = request.getParameter("clientID");
                    String supervisorOp = request.getParameter("supervisorID");
                    String driverOp = request.getParameter("driverID");
                    String loadedOp = request.getParameter("loadingType");
                    String workOp = request.getParameter("workingType");
                    String requestOp = request.getParameter("shipp");
                    String trip = request.getParameter("trip");
                    String sanadOP = request.getParameter("sanad");

                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", truckOp);
                    params.put("trailer", trailerOp);
                    params.put("main", statusOp);
                    params.put("client", clientOp);
                    params.put("supervisor", supervisorOp);
                    params.put("driver", driverOp);
                    params.put("loaded", loadedOp);
                    params.put("work", workOp);
                    params.put("request", requestOp);
                    params.put("trip", trip);
                    params.put("sanad", sanadOP);
                    }else if(reportName.equals("contract")) {
                    String contractCode = request.getParameter("code");
                    String contractName = request.getParameter("client");
                    String contractEmp = request.getParameter("emp");
                    String contractStatus = request.getParameter("status");
                    String contractType = request.getParameter("type");
                    String contractPayment = request.getParameter("payment");

                    params.put("contractCode", contractCode);
                    params.put("contractName", contractName);
                    params.put("contractEmp", contractEmp);
                    params.put("contractStatus", contractStatus);
                    params.put("contractType", contractType);
                    params.put("contractPayment", contractPayment);
                    }else if(reportName.equals("stopCar")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String contractCode = request.getParameter("code");
                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", contractCode);
                    } else if(reportName.equals("maintTotalCar")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String contractCode = request.getParameter("code");
                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", contractCode);
                    } else if(reportName.equals("readingTotalCar")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String contractCode = request.getParameter("code");
                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", contractCode);
                    } else if(reportName.equals("supExtr")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String contractCode = request.getParameter("code");
                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", contractCode);
                    } else if(reportName.equals("readSuperVisorCar")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String contractCode = request.getParameter("code");
                    String contractCode2 = request.getParameter("nameSuper");
                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", contractCode);
                    params.put("nameSuper", contractCode2);
                    } else if(reportName.equals("op_invoice_pay")) {
                     reportType = request.getParameter("reportTypeOp");   
                        
                    String fromDateOp = request.getParameter("fromDate");
                    String toDateOp = request.getParameter("toDate");
                    String code = request.getParameter("drvrIDS");
                    String clientCode = request.getParameter("clientID");
                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("code", code);
                    params.put("clientCodeId", clientCode);
                    } else if(reportName.equals("carStatusStop")) {
                    reportType = request.getParameter("reportTypeOp");   
                        
                    String code = request.getParameter("drvrIDS");
                    String clientCode = request.getParameter("clientID");
                    String statusCar = request.getParameter("reportType");
                    
                    params.put("code", code);
                    params.put("clientCodeId", clientCode);
                    if(statusCar.equals("90")){
                    params.put("StartDate", "90");
                    params.put("EndDate", "80");
                    } else if(statusCar.equals("14")){
                    params.put("StartDate", "14");
                    params.put("EndDate", "1");
                    } else if(statusCar.equals("0")){
                    params.put("StartDate", "0");
                    }                  
                    } else if(reportName.equals("readingOP")) {
                    String fromDateOp = request.getParameter("fromDateOp");
                    String toDateOp = request.getParameter("toDateOp");
                    String contractCode = request.getParameter("code");
                    params.put("StartDate", fromDateOp);
                    params.put("EndDate", toDateOp);
                    params.put("car", contractCode);
                    } else if(reportName.equals("Attach_Batery")){
                        if(request.getParameter("attached").equals("1")){
                        reportName = "Attach_Batery_attach";
                        } else if(request.getParameter("attached").equals("2")){
                            reportName = "Attach_Batery_spare";
                        }
                    String fromDateTire = request.getParameter("fromDate");
                    String toDateTire = request.getParameter("toDate");
                    String tirecode = request.getParameter("tirecode");
                    String tirename = request.getParameter("tirename");
                    String maintype = request.getParameter("maintype");
                    String MANUFACTORY = request.getParameter("MANUFACTORY");

                    params.put("fromDate", fromDateTire);
                    params.put("toDate", toDateTire);
                    params.put("tireCode", tirecode);
                    params.put("tireName", tirename);
                    params.put("mainType", maintype);
                    params.put("brand", MANUFACTORY);
                    }/* else {
                    String fromDateTire = request.getParameter("fromDate");
                    String toDateTire = request.getParameter("toDate");
                    String tirecode = request.getParameter("tirecode");
                    String tirename = request.getParameter("tirename");
                    String maintype = request.getParameter("maintype");
                    String MANUFACTORY = request.getParameter("MANUFACTORY");

                    params.put("fromDate", fromDateTire);
                    params.put("toDate", toDateTire);
                    params.put("tireCode", tirecode);
                    params.put("tireName", tirename);
                    params.put("mainType", maintype);
                    params.put("brand", MANUFACTORY);
                    }*/
                    // create and open PDF report in browser
                    context = getServletConfig().getServletContext();
                    Tools tool = new Tools();
                    issueMgr = IssueMgr.getInstance();
                    Connection conn = null;
                    conn = issueMgr.getConnection();
                    tool.showReport(reportName, params, conn, context, response, request, reportType);
                    try {
                        conn.close();
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(Tools.class.getName()).log(Level.SEVERE, null, ex);
                    }
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
        if (opName.equals("searchMaintenanceDetails")) {
            return 1;

        } else if (opName.equals("resulSearchMaintenanceDetails")) {
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

        } else if (opName.equals("getCostByAvgJO")) {
            return 12;

        } else if (opName.equals("resultCostByAvgJO")) {
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

        } else if (opName.equals("ListEquipments")) {
            return 31;

        } else if (opName.equals("getBrandSchedules")) {
            return 32;

        }

        if (opName.equalsIgnoreCase("Statistics")) {
            return 33;

        }
        if (opName.equalsIgnoreCase("Planning")) {
            return 34;

        }
        if (opName.equalsIgnoreCase("JobOrder")) {
            return 35;

        }
        if (opName.equalsIgnoreCase("listSpareParts")) {
            return 36;

        }
        if (opName.equalsIgnoreCase("equipmentStatusForm")) {
            return 37;

        }
        if (opName.equalsIgnoreCase("equipmentStatusReport")) {
            return 38;

        }
        if (opName.equalsIgnoreCase("depComplaintsDistRatesReport")) {
            return 39;

        }
        if (opName.equalsIgnoreCase("followUpReportMaintenanceItems")) {
            return 40;

        }
        if (opName.equalsIgnoreCase("tasksTree")) {
            return 41;

        }
        if (opName.equalsIgnoreCase("sparePartsTree")) {
            return 42;

        }
        if (opName.equalsIgnoreCase("getDeviationsInEquipmentsReadingsForm")) {
            return 43;

        } else if (opName.equalsIgnoreCase("equipmentFailureForm")) {
            return 45;
        } else if (opName.equalsIgnoreCase("equipmentFaiulerReport")) {
            return 46;
        }

        if (opName.equalsIgnoreCase("getSearchSchedulesForm")) {
            return 47;

        }
        if (opName.equalsIgnoreCase("callRatio")) {
            return 48;

        }
        if (opName.equalsIgnoreCase("requestRatio")) {
            return 49;

        }
        if (opName.equalsIgnoreCase("requestRatioReport")) {
            return 50;

        }
        if (opName.equalsIgnoreCase("productPerRegionRatio")) {
            return 51;
        }
        if (opName.equalsIgnoreCase("productsRatio")) {
            return 52;
        }
        if (opName.equalsIgnoreCase("campaignClientsReport")) {
            return 53;
        }
        if (opName.equalsIgnoreCase("complaintsProjectReport")) {
            return 54;
        }
        if (opName.equalsIgnoreCase("performanceProjectReport")) {
            return 55;
        }
        if (opName.equalsIgnoreCase("appointmentsStatisticsPerUser")) {
            return 56;
        }
        if (opName.equalsIgnoreCase("getProductivityByGroup")) {
            return 57;
        }
        if (opName.equalsIgnoreCase("getProductivityByUser")) {
            return 58;
        }
        if (opName.equalsIgnoreCase("getAppointmentsByUserReport")) {
            return 59;
        }
        if (opName.equalsIgnoreCase("getCommentsByUserReport")) {
            return 60;
        }
        if (opName.equalsIgnoreCase("getAverageResponseSpeed")) {
            return 61;
        }
        if (opName.equalsIgnoreCase("getWorkItemsRecurringCurve")) {
            return 62;
        }
        if (opName.equalsIgnoreCase("getSalesChartReport")) {
            return 63;
        }
        if (opName.equalsIgnoreCase("campaignAgentClientsReport")) {
            return 64;
        }
        if (opName.equalsIgnoreCase("clientRateReport")) {
            return 65;
        }
        if (opName.equalsIgnoreCase("clientEmployeeRateReport")) {
            return 66;
        }
        if (opName.equalsIgnoreCase("clientClassificationReport")) {
            return 67;
        }
        if (opName.equalsIgnoreCase("clientClassificationExcel")) {
            return 68;
        }
        if (opName.equalsIgnoreCase("clientEmployeeBarChartReport")) {
            return 69;
        }
        if (opName.equalsIgnoreCase("clientCampaignsReport")) {
            return 70;
        }
        if (opName.equalsIgnoreCase("successAppointmentsReport")) {
            return 71;
        }
        if (opName.equalsIgnoreCase("campaignsRepeatedReport")) {
            return 72;
        }
        if (opName.equalsIgnoreCase("campaignUsersRatioReport")) {
            return 73;
        }
        if (opName.equalsIgnoreCase("getProductivityClientsReport")) {
            return 74;
        }
        if (opName.equalsIgnoreCase("getProjectsSalesReport")) {
            return 75;
        }
        if (opName.equalsIgnoreCase("getClientsEmailsReport")) {
            return 76;
        }
        if (opName.equalsIgnoreCase("getAreasSalesReport")) {
            return 77;
        }
        if (opName.equals("attendanceStatisticsReport")) {
            return 78;
        }
        if (opName.equals("consolidatedActivitiesReport")) {
            return 79;
        }
        if (opName.equals("myConsolidatedActivitiesReport")) {
            return 80;
        }
        if (opName.equals("attendanceDetailsReport")) {
            return 81;
        }
        if (opName.equals("attendedClientsReport")) {
            return 82;
        }
        if (opName.equals("attendedClientsReportPDF")) {
            return 83;
        }
        if (opName.equals("clientComChannelReport")) {
            return 84;
        }
        if (opName.equals("CampaignsBarChartReport")) {
            return 85;
        }
        if (opName.equals("CampaignsComparisionExcelReport")) {
            return 86;
        }
        if (opName.equals("synchronizeCampaignClients")) {
            return 87;
        }
        if (opName.equals("getFirstLastLoginReport")) {
            return 88;
        }
        if (opName.equals("getCampaignsByBeginingDate")) {
            return 89;
        }
        if (opName.equals("getAllEmployeesRequestsReport")) {
            return 90;
        }
        if (opName.equals("changeEmployeeRequestStatus")) {
            return 91;
        }
        if (opName.equals("ClientsWithdraws")) {
            return 92;
        }
        if (opName.equals("employeesWithdraws")) {
            return 93;
        }
        if (opName.equals("clientsProfileReport")) {
            return 94;
        }

        if (opName.equalsIgnoreCase("viewSalesTotalByYear")) {
            return 95;
        }

        if (opName.equalsIgnoreCase("exportClientsToExcel")) {
            return 96;
        }

        if (opName.equalsIgnoreCase("mySuccessAppointmentsReport")) {
            return 97;
        }

        if (opName.equalsIgnoreCase("viewClientSurveyReport")) {
            return 98;
        }

        if (opName.equalsIgnoreCase("getClientJobStatistics")) {
            return 99;
        }

        if (opName.equalsIgnoreCase("getClientRegionStatistics")) {
            return 100;
        }

        if (opName.equalsIgnoreCase("communicationChannelsClientsAnalysis")) {
            return 101;
        }

        if (opName.equalsIgnoreCase("clientClassificationExcelComChannels")) {
            return 102;
        }
        if (opName.equalsIgnoreCase("getRateDateAjax")) {
            return 103;
        }
        if (opName.equalsIgnoreCase("getProjectsCampaignsReport")) {
            return 104;
        }
        if (opName.equalsIgnoreCase("campaignOpjactiveRatioReport")) {
            return 105;
        }
        if (opName.equalsIgnoreCase("campaignlastDaysRatioReport")) {
            return 106;
        }
        if (opName.equalsIgnoreCase("CampaignDaysDetails")) {
            return 107;
        }
        if (opName.equalsIgnoreCase("getUserClientsInterLocal")) {
            return 108;
        }
        if (opName.equalsIgnoreCase("getMyUserClientsInterLocal")) {
            return 109;
        }
        if (opName.equalsIgnoreCase("getAverageCustomerPurchaseTime")) {
            return 110;
        }
        if (opName.equalsIgnoreCase("getClientRateingHistory")) {
            return 111;
        }
        if (opName.equals("getEmployeeCallStatistics")) {
            return 112;
        }
        if (opName.equals("getCommentsOnEmployee")) {
            return 113;
        }
        if (opName.equals("getCampaignClientDetails")) {
            return 114;
        }
        if (opName.equals("getTradeClients")) {
            return 115;
        }
        if (opName.equals("getCampaignStat")) {
            return 116;
        }
        if (opName.equals("getLoginInDay")) {
            return 117;
        }
        if (opName.equals("getStatByCampaignRates")) {
            return 118;
        }
        if (opName.equals("getCampClientDetails")) {
            return 119;
        }
        if (opName.equals("getClientJobStatisticsExcel")) {
            return 120;
        }
        if (opName.equals("getEntriesByDay")) {
            return 121;
        }
        if (opName.equals("getUsersByDepart")) {
            return 122;
        }
        if (opName.equalsIgnoreCase("exportReport")) {
            return 123;
        }
        return 0;

    }

    public Vector mergerVectors(Vector largeVector, Vector smallVector) {
        for (int i = 0; i
                < smallVector.size(); i++) {
            largeVector.add((WebBusinessObject) smallVector.get(i));

        }
        return largeVector;

    }

    public Vector getTypeOfRate(String[] arrTypeOfRate) {
        Vector vecTypeOfRate = new Vector();

        for (int i = 0; i
                < arrTypeOfRate.length; i++) {
            if (arrTypeOfRate[i].equals("fixed")) {
                vecTypeOfRate.add("Hour");

            } else {
                vecTypeOfRate.add("Kilo Meter");

            }
        }

        return vecTypeOfRate;

    }
}
