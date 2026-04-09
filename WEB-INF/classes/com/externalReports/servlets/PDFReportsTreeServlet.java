/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.externalReports.servlets;

import com.SpareParts.db_access.UsedSparePartsMgr;
import com.tracker.db_access.IssueMgr;
import com.contractor.db_access.MaintainableMgr;
import com.externalReports.db_access.ExternalJobReportMgr;
import com.externalReports.db_access.IssueByCostTasksMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.AllMaintenanceInfoMgr;
import com.maintenance.db_access.ComplaintTasksMgr;
import com.maintenance.db_access.ConfigureMainTypeMgr;
import com.maintenance.db_access.EmpTasksHoursMgr;
import com.maintenance.db_access.EquipmentsWithReadingMgr;
import com.maintenance.db_access.IssueTasksMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.ItemsWithAvgPriceItemDataMgr;
import com.maintenance.db_access.ItemsWithAvgPriceMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.ParentUnitMgr;
import com.maintenance.db_access.QuantifiedItemsMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.SupplierMgr;
import com.maintenance.db_access.TaskMgr;
import com.maintenance.db_access.TasksByIssueMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.maintenance.servlets.ReportsServlet;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.international.BilingualDisplayTerms;
import com.tracker.common.AppConstants;
import com.tracker.common.IssueConstants;
import com.tracker.db_access.ProjectMgr;
import com.tracker.engine.AssignedIssueState;
import com.tracker.engine.IssueStatusFactory;
import com.tracker.servlets.IssueServlet.IssueTitle;
import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import org.apache.commons.lang.time.DurationFormatUtils;
import org.json.simple.JSONValue;

/**
 *
 * @author khaled abdo
 */
public class PDFReportsTreeServlet extends TrackerBaseServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    //Define Local variables
    ProjectMgr projectMgr = ProjectMgr.getInstance();
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
    ComplaintTasksMgr compTasksMgr = ComplaintTasksMgr.getInstance();
    TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
    EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
    ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    Map params = new HashMap();
    Vector allMaintenanceInfo = new Vector();
    Vector allMaintenanceInfoCopy = new Vector();
    Vector allItems = new Vector();
    Vector allTask = new Vector();
    Vector allLabor = new Vector();
    WebBusinessObject wboCritaria = new WebBusinessObject();
    WebBusinessObject wbo = new WebBusinessObject();
    IssueMgr issueMgr = IssueMgr.getInstance();
    UnitScheduleMgr usMgr = UnitScheduleMgr.getInstance();
    ItemsMgr itemsMgr = ItemsMgr.getInstance();
    IssueTitle issueTitleEnum;
    AssignedIssueState assignedIssueState = null;
    double totalItemsCost = 0;
    double laborCost;
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
    DecimalFormat decimalFormat = new DecimalFormat("#.##");

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
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        securityUser = (SecurityUser) session.getAttribute("securityUser");
        Vector dataSet = new Vector();
        ArrayList allModel;

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


        switch (operation) {
            case 1:
                ArrayList suppliers = new ArrayList();
                String single = request.getParameter("single");
                if (single != null) {
                    servedPage = "/docs/plan_reports/External_report_1.jsp";
                } else {
                    servedPage = "/docs/plan_reports/External_report.jsp";
                }
                projectMgr = ProjectMgr.getInstance();
                ArrayList allSites = projectMgr.getAllAsArrayList();
                allModel = maintainableMgr.getAllModelsAsArrayList();
                suppliers = supplierMgr.getAllSuppliers();
                request.setAttribute("page", servedPage);
                request.setAttribute("suppliers", suppliers);
                request.setAttribute("allModels", allModel);
                request.setAttribute("allSites", allSites);
                if (single != null) {
                    request.setAttribute("imageshow", single);
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;

//            case 2:
//                SupplierMgr supplierMgr = SupplierMgr.getInstance();
//                ExternalJobReportMgr externalJobReportMgr = ExternalJobReportMgr.getInstance();
//
//                params = new HashMap();
//                dataSet = new Vector();
//                unitId = new String();
//                //String[] Status = request.getParameter("status").split(",");
//                String unit = request.getParameter("unitId");//Tools.concatenation(allModels, ",");
//                String sup = request.getParameter("sup");
//                String searchBy = request.getParameter("searchBy");
//                String[] allSite = request.getParameterValues("site");
//                String[] allModels = request.getParameterValues("model");
//
//                String sDate = request.getParameter("beginDate");
//                String eDate = request.getParameter("endDate");
//
//                String modelAll = request.getParameter("modelAll");
//                siteAll = request.getParameter("siteAll");
//                String orderType = request.getParameter("orderType");
//                String dateType = request.getParameter("dateType");
//                String date_order = dateType + " " + orderType;
//                String[] currentStatus = request.getParameterValues("currenStatus");
//
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", sDate);
//                wboCritaria.setAttribute("endDate", eDate);
//
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("date_order", date_order);
//                wboCritaria.setAttribute("site", allSite);
//
//                double totalCost = 0.0;
//                String searchByType = "";
//                if (searchBy.equalsIgnoreCase("unit")) {
//                    searchByType = "\u0645\u0639\u062F\u0629";
//                    if (unit != null) {
//                        //
//                        unitName = request.getParameter("unitName");
//                        unitId = request.getParameter("unitId");
//
//                        if (unitName.equals("") || unitId.equals("All")) {
//                            unitName = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
//                            params.put("unit", unitName);
//                        } else {
//                            wbo = maintainableMgr.getOnSingleKey(unitId);
//                            params.put("unit", wbo.getAttribute("unitName"));
//                        }
//
//                        wboCritaria.setAttribute("unitId", unitId);
//                        try {
//                            dataSet = externalJobReportMgr.getExternalJOBReportByEquip(wboCritaria);
//                        } catch (SQLException ex) {
//                            Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                        } catch (Exception ex) {
//                            Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                        }
//
//                        params.put("equipmentReport", "yes");
//                    }
//                } else {
//                    Vector modelsVec = (Vector) maintainableMgr.getModelsNames(allModels);
//                    searchByType = "\u0645\u0648\u062F\u064A\u0644/\u0645\u0627\u0631\u0643\u0629";
//                    if (allModels != null) {
//                        wboCritaria.setAttribute("models", allModels);
//
//                        try {
//                            dataSet = externalJobReportMgr.getExternalJOBReportByModel(wboCritaria);
//                        } catch (SQLException ex) {
//                            Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                        } catch (Exception ex) {
//                            Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                        }
//                    }
//
//                    if (modelAll.equals("yes")) {
//                        unit = "\u0643\u0644 \u0627\u0644\u0645\u0648\u062F\u064A\u0644\u0627\u062A/\u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A";
//                    } else {
//                        for (int i = 0; i < modelsVec.size(); i++) {
//                            if (i == 0) {
//                                unit = (String) modelsVec.get(i);
//                            } else {
//                                unit += " - " + (String) modelsVec.get(i);
//                            }
//                        }
//                    }
//                    params.put("unit", unit);
//                }
//
//                params.put("searchByType", searchByType);
//                if (dataSet.size() > 0) {
//                    for (int i = 0; i < dataSet.size(); i++) {
//                        wbo = (WebBusinessObject) dataSet.get(i);
//                        issueId = (String) wbo.getAttribute("issue_id");
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//                        String siteName = projectMgr.getSiteNameById((String) wbo.getAttribute("site_id"));
//                        laborCost = Double.parseDouble((String) wbo.getAttribute("labor_cost"));
//                        totalCost += laborCost;
//                        //wbo.setAttribute("labor_cost", (String)wbo.getAttribute("labor_cost"));
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                            wbo.setAttribute("siteName", siteName);
//                        } catch (Exception e) {
//                            wbo.setAttribute("parentName", "");
//                            wbo.setAttribute("siteName", "");
//                            System.out.println();
//                        }
//                    }
//                }
//                params.put("totalCost", totalCost);
//
//                String siteStrArr = "";
//                Vector siteVec = (Vector) projectMgr.getProjectsName(allSite);
//                if (siteAll.equals("yes")) {
//                    siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                } else {
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                    }
//                }
//
//                params.put("location", siteStrArr);
//                if (!sup.equals("All")) {
//                    wbo = supplierMgr.getOnSingleKey(sup);
//                    params.put("sup", wbo.getAttribute("name"));
//                } else {
//                    params.put("sup", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0631\u062F\u064A\u0646");
//                }
//                params.put("Sdate", sDate);
//                params.put("Edate", eDate);
//                params.put("fromSide", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("toSide", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                /*String PDFsite = "All";
//                String[] Status = request.getParameter("status").split(",");
//                String unit = request.getParameter("unit");
//                String sup = request.getParameter("sup");
//                String site = request.getParameter("site");
//                String sDate = request.getParameter("beginDate");
//                String eDate = request.getParameter("endDate");
//                unitName = request.getParameter("unitName");
//                if (unitName.equals("") || unit.equals("All")) {
//                unitName = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
//                params.put("unit", unitName);
//                } else {
//                wbo = maintainableMgr.getOnSingleKey(unit);
//                params.put("unit", wbo.getAttribute("unitName"));
//                }
//                if (!site.equals("All")) {
//                String[] temp = new String[1];
//                temp[0] = site;
//                Vector siteTemp = projectMgr.getProjectsName(temp);
//                PDFsite = (String) siteTemp.get(0);
//                params.put("location", PDFsite);
//                } else {
//                params.put("location", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//                if (!sup.equals("All")) {
//                wbo = supplierMgr.getOnSingleKey(sup);
//                params.put("sup", wbo.getAttribute("name"));
//                } else {
//                params.put("sup", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0631\u062F\u064A\u0646");
//                }
//                params.put("Sdate", sDate);
//                params.put("Edate", eDate);
//                try {
//                dataSet = externalJobReportMgr.genReport(unit, "key1", sup, "key2", site, "key3", Status, "key4", sDate, eDate);
//                } catch (Exception ex) {
//                Logger.getLogger(PDFReportUpdateServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }*/
//                Tools.createPdfReport("ExternalReport01", params, dataSet, getServletContext(), response, request);
//                break;
//
//            case 3:
//                servedPage = "/docs/costing_report/costing_sample_report_form.jsp";
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 4:
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                unitId = request.getParameter("unitId");
//                unitName = request.getParameter("unitName");
//                issueTitle = request.getParameter("issueTitle");
//                orderBy = request.getParameter("orderBy");
//
//                params = new HashMap();
//                params.put("bDate", beginDate);
//                params.put("eDate", endDate);
//
//                if (unitId.equals("")) {
//                    String Name = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
//                    params.put("unitName", Name);
//                } else {
//                    params.put("unitName", unitName);
//                }
//
//                if (issueTitle.equals("notEmergency")) {
//                    String type = "\u0635\u064A\u0627\u0646\u0629 \u062F\u0648\u0631\u064A\u0629";
//                    params.put("type", type);
//                } else if (issueTitle.equals("Emergency")) {
//                    String type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629";
//                    params.put("type", type);
//                } else {
//                    String type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629 \u0648 \u062F\u0648\u0631\u064A\u0629";
//                    params.put("type", type);
//                }
//
//                if (orderBy.equals("asc")) {
//                    String order = "\u062A\u0635\u0627\u0639\u062F\u064A\u0627";
//                    params.put("order", order);
//                } else {
//                    String order = "\u062A\u0646\u0627\u0632\u0644\u064A\u0627";
//                    params.put("order", order);
//                }
//
//                wbo = new WebBusinessObject();
//                wbo.setAttribute("beginDate", beginDate);
//                wbo.setAttribute("endDate", endDate);
//                wbo.setAttribute("issueTitle", issueTitle);
//                wbo.setAttribute("orderBy", orderBy);
//
//                if (unitId != null && !unitId.equals("")) {
//                    wbo.setAttribute("unitId", unitId);
//                }
//
//                dataSet = issueByCostTasksMgr.getSampleReport(wbo);
//                Tools.createPdfReport("CostReport", params, dataSet, getServletContext(), response, request);
//                break;
//
//            case 5:
//                projectMgr = ProjectMgr.getInstance();
//                params = new HashMap();
//                siteAll = request.getParameter("siteAll");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                String sites = request.getParameter("sites");
//                String ids = request.getParameter("ids").trim();
//                String type = request.getParameter("type").trim();
//                String[] arrIds = ids.split(" ");
//                String[] arrSites = sites.trim().split(" ");
//                String[] arrTypeOfRate = type.split(" ");
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//
//                String typeOfRateStr = new String();
//                Vector typeOfRateVec = getTypeOfRate(arrTypeOfRate);
//
//                for (int i = 0; i < typeOfRateVec.size(); i++) {
//                    if (i == 0) {
//                        typeOfRateStr = (String) typeOfRateVec.get(i);
//                    } else {
//                        typeOfRateStr += " - " + (String) typeOfRateVec.get(i);
//                    }
//                }
//
//                params.put("typeOfRateStr", typeOfRateStr);
//
//                String siteValueStr = new String();
//                if (siteAll.equals("yes")) {
//                    siteValueStr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                } else {
//                    Vector siteValueVec = projectMgr.getProjectsName(arrSites);
//                    for (int i = 0; i < siteValueVec.size(); i++) {
//                        if (i == 0) {
//                            siteValueStr = (String) siteValueVec.get(i);
//                        } else {
//                            siteValueStr += " - " + (String) siteValueVec.get(i);
//                        }
//                    }
//                }
//
//                params.put("siteValue", siteValueStr);
//
//                arrIds = ids.split(" ");
//                arrSites = sites.split(" ");
//                arrTypeOfRate = type.split(" ");
//                Vector equipmentsWithReading;
//
//                String equipValueStr = new String();
//                Vector equipValueVec;
//
//                if (ids != null && !ids.equals("")) {
//                    equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsWithReadingByIds(arrIds, arrTypeOfRate, beginDate, endDate);
////                    request.setAttribute("equipments", maintainableMgr.getUnitsName(arrIds));
//                    equipValueVec = maintainableMgr.getUnitsName(arrIds);
//                    for (int i = 0; i < equipValueVec.size(); i++) {
//                        if (i == 0) {
//                            equipValueStr = (String) equipValueVec.get(i);
//                        } else if (i == equipValueVec.size() - 1) {
//                            equipValueStr += " " + (String) equipValueVec.get(i);
//                        } else {
//                            equipValueStr += " - " + (String) equipValueVec.get(i);
//                        }
//                    }
//                } else {
//                    equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsWithReadingBySites(arrSites, arrTypeOfRate, beginDate, endDate);
//                    equipValueStr = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
//                }
//
//                params.put("equipValueStr", equipValueStr);
//
//                Vector objects = new Vector();
//                Iterator it = equipmentsWithReading.iterator();
//                String tempStr = new String();
//                long timeByMilleSecond;
//                Date dateOfLastReading;
//                String strDateOfLastReading;
//                int lastReading,
//                 prevReading,
//                 diffReading = 0,
//                 temp;
//                while (it.hasNext()) {
//                    wbo = (WebBusinessObject) it.next();
//                    tempStr = (String) wbo.getAttribute("typeOfRate");
//                    if (tempStr.equals("fixed")) {
//                        wbo.setAttribute("typeOfRate", "\u0633\u0627\u0639\u0629");
//                    } else {
//                        wbo.setAttribute("typeOfRate", "\u0643\u064A\u0644\u0648\u0645\u062A\u0631");
//                    }
//                    lastReading = Integer.valueOf((String) wbo.getAttribute("lastReading")).intValue();
//                    prevReading = Integer.valueOf((String) wbo.getAttribute("previousReading")).intValue();
//
//                    if (lastReading < prevReading) {
//                        temp = lastReading;
//                        lastReading = prevReading;
//                        prevReading = temp;
//                    }
//
//                    diffReading = lastReading - prevReading;
//                    wbo.setAttribute("diffReading", Integer.toString(diffReading));
//
//                    timeByMilleSecond = Long.valueOf((String) wbo.getAttribute("entryTime")).longValue();
//                    dateOfLastReading = new Date(timeByMilleSecond);
//                    strDateOfLastReading = dateOfLastReading.getDate() + "/" + (dateOfLastReading.getMonth() + 1) + "/" + (dateOfLastReading.getYear() + 1900);
//                    wbo.setAttribute("dateOfLastReading", strDateOfLastReading);
//
//                    objects.add(wbo);
//                }
//
//                // create and open PDF report in browser
//                Tools.createPdfReport("equipmentsWithReadingsReport", params, objects, getServletContext(), response, request);
//                break;
//
//            case 6:
//                reportName = "";
//                params = new HashMap();
//                projectMgr = ProjectMgr.getInstance();
//                double totalJOCost = 0.0;
//                double grandTotalJOCost = 0.0;
//
//                String temp1 = "",
//                 typeOfSchedule = "",
//                 issueStatus = "",
//                 tempStatus,
//                 maintenanceDuration = "",
//                 JODate = "",
//                 tempStatusBegin = "",
//                 tempStatusEnd = "",
//                 currentStatusSince = "";
//
//                Date currentStatusSinceDate = null,
//                 actualBeginDate = null,
//                 actualEndDate = null;
//
//                allMaintenanceInfo = new Vector();
//                ItemsWithAvgPriceItemDataMgr itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                String issueTitlee = request.getParameter("issueTitle");
//                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                if (issueTitlee.equals("notEmergency")) {
//                    issueTitleEnum = IssueTitle.NotEmergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629");
//                } else if (issueTitlee.equals("Emergency")) {
//                    issueTitleEnum = IssueTitle.Emergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                } else {
//                    issueTitleEnum = IssueTitle.Both;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0648 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                }
//
//                unitId = request.getParameter("unitId");
//                unitName = request.getParameter("unitName");
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                trade = request.getParameterValues("trade");
//                tradeAll = request.getParameter("tradeAll");
//                siteAll = request.getParameter("siteAll");
//                String siteTypeSelection = request.getParameter("siteTypeSelection");
//                laborDetail = request.getParameter("laborDetail");
//                if (laborDetail == null) {
//                    laborDetail = "off";
//                }
//
//                if (siteTypeSelection.equals("defSite")) {
//                    String siteId = (String) request.getParameter("siteId");
//                    site_ = new String[1];
//                    site_[0] = siteId;
//                } else {
//                    site_ = request.getParameterValues("site");
//                }
//
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//                date_order = dateType + " " + orderType;
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("date_order", date_order);
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                if (unitId != null && !unitId.equals("")) {
//                    wboCritaria.setAttribute("unitId", unitId);
//
//                    wboCritaria.setAttribute("site", site_);
//                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria, issueTitleEnum);
//
//                    params.put("unitNamesStr", unitName);
//                    params.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0639\u062F\u0629");
//
//
//                }
//                actualEndDate = null;
//                //ConfigFileMgr configFileMgr = new ConfigFileMgr();
//                if (laborDetail.equals("on")) {
//                    allMaintenanceInfoCopy = new Vector();
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    grandTotalJOCost = 0;
//
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//
//                        totalJOCost = 0.0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//
//                        allLabor = new Vector();
//                        try {
//                            allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                        } catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//
//                        totalItemsCost = 0.0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception E) {
//                            System.out.println("no parent type");
//                        }
//                        wbo.setAttribute("labors", allLabor);
//
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCostWithLaborsDetails";
//
//
//                } else {
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    int index = 0;
//                    allMaintenanceInfoCopy = new Vector();
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                        totalJOCost = 0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//                        wbo.setAttribute("JODate", JODate);
//
//                        totalItemsCost = 0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
//                        wbo.setAttribute("totalItemCost", totalItemsCost);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception e) {
//                            System.out.println();
//                        }
//
//                        wbo.setAttribute("laborCost", laborCost);
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCost";
//                }
//
//                request.setAttribute("unitName", unitName);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("itemName", itemName);
//
//                request.setAttribute("tradeAll", tradeAll);
//                request.setAttribute("mainTypeAll", mainTypeAll);
//                request.setAttribute("siteAll", siteAll);
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("grandTotalJOCost", grandTotalJOCost);
//
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
//                } else {
//                    params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                }
//
//                Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);
//                break;
//
//
//            case 7:
//                from = request.getParameter("from");
//                to = request.getParameter("to");
//                allMaintenanceInfo = new Vector();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                itemsWithAvgPriceMgr = ItemsWithAvgPriceMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                actualBeginDate = null;
//                actualEndDate = null;
//                currentStatusSince = "";
//
//                totalJOCost = 0.0;
//                grandTotalJOCost = 0.0;
//
//                params = new HashMap();
//                params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644");
//                params.put("C1", "\u0645\u0646 \u0631\u0642\u0645");
//                params.put("C2", "\u0627\u0644\u0649 \u0631\u0642\u0645");
//                params.put("beginDate", from);
//                params.put("endDate", to);
//                params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
//                params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                params.put("EQUIPMENT_TYPE", "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u064A");
//                params.put("maintNumReport", "yes");
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByMaintNum(from, to);
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                    allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    totalItemsCost = 0;
//                    for (int j = 0; j < allItems.size(); j++) {
//                        WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                        try {
//                            itemName = tempItem.getAttribute("itemDesc").toString();
//                        } catch (Exception e) {
//                            itemName = "Item Name Not Supported";
//                        }
//                        tempItem.setAttribute("itemDesc", itemName);
//                        try {
//                            totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                        } catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//                    }
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    try {
//                        if (issueStatus.equals("Assigned")) {
//                            issueStatusLabel = JOAssignedStatus;
//                            tempStatus = " - " + JOOpenStatus;
//                            currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                            actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                            JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                        } else if (issueStatus.equals("Canceled")) {
//                            issueStatusLabel = JOCanceledStatus;
//                            tempStatus = " - " + JOCancelStatus;
//                            currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                            actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                            currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                            JODate = currentStatusSince;
//
//                        } else {
//                            issueStatusLabel = JOFinishedStatus;
//                            tempStatusBegin = " - " + JOOpenStatus;
//                            tempStatusEnd = " - " + JOCloseStatus;
//                            currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                            actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                            actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                            JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                    + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                        }
//                    } catch (NullPointerException ex) {
//                        maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("laborCost", laborCost);
//                    wbo.setAttribute("totalItemCost", totalItemsCost);
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.setAttribute("parentName", parentName);
//                    wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//                    wbo.setAttribute("JODate", JODate);
//                    wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
//
//                    grandTotalJOCost += (totalItemsCost + laborCost);
//
//                }
//
//                params.put("grandTotalJOCost", grandTotalJOCost);
//                Tools.createPdfReport("SJOAvgCost", params, allMaintenanceInfo, getServletContext(), response, request);
//                break;
//
//            case 8:
//                from = request.getParameter("from");
//                to = request.getParameter("to");
//                allMaintenanceInfo = new Vector();
//                allMaintenanceInfo = allMaintenanceInfoMgr.getDetailsMaintenanceByMaintNum(from, to);
//
//
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//
//                }
//
//                params = new HashMap();
//                params.put("REPORT_TYPE", "fromTo");
//                params.put("FROM", "\u0645\u0646 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
//                params.put("TO", "\u0627\u0644\u0649 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
//                params.put("beginDate", from);
//                params.put("endDate", to);
//                // create and open PDF report in browser
//                ServletContext context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//                break;
//
//            case 9:
//                servedPage = "/docs/costing_report/costing_avgCost_report_form.jsp";
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 10:
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                unitId = request.getParameter("unitId");
//                unitName = request.getParameter("unitName");
//                issueTitle = request.getParameter("issueTitle");
//                orderBy = request.getParameter("orderBy");
//
//                params = new HashMap();
//                params.put("bDate", beginDate);
//                params.put("eDate", endDate);
//
//                if (unitId.equals("")) {
//                    String Name = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
//                    params.put("unitName", Name);
//                } else {
//                    params.put("unitName", unitName);
//                }
//
//                if (issueTitle.equals("notEmergency")) {
//                    type = "\u0635\u064A\u0627\u0646\u0629 \u062F\u0648\u0631\u064A\u0629";
//                    params.put("type", type);
//                } else if (issueTitle.equals("Emergency")) {
//                    type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629";
//                    params.put("type", type);
//                } else {
//                    type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629 \u0648 \u062F\u0648\u0631\u064A\u0629";
//                    params.put("type", type);
//                }
//
//                if (orderBy.equals("asc")) {
//                    String order = "\u062A\u0635\u0627\u0639\u062F\u064A\u0627";
//                    params.put("order", order);
//                } else {
//                    String order = "\u062A\u0646\u0627\u0632\u0644\u064A\u0627";
//                    params.put("order", order);
//                }
//                dataSet = new Vector();
//
//                wbo = new WebBusinessObject();
//                wbo.setAttribute("beginDate", beginDate);
//                wbo.setAttribute("endDate", endDate);
//                wbo.setAttribute("issueTitle", issueTitle);
//                wbo.setAttribute("orderBy", orderBy);
//
//                if (unitId != null && !unitId.equals("")) {
//                    wbo.setAttribute("unitId", unitId);
//                }
//
//                dataSet = issueByCostTasksMgr.getSampleFullReport(wbo);
//                Tools.createPdfReport("CostReport", params, dataSet, getServletContext(), response, request);
//                break;
//
//            case 11:
//                projectMgr = ProjectMgr.getInstance();
//                params = new HashMap();
//                allMaintenanceInfo = new Vector();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                issueTitle = request.getParameter("issueTitle");
//                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                if (issueTitle != null && issueTitle.equals("Emergency")) {
//                    issueTitleEnum = IssueTitle.Emergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
//                } else {
//                    issueTitleEnum = IssueTitle.NotEmergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
//                }
//
//                unitId = request.getParameter("unitId");
//                unitName = request.getParameter("unitName");
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                siteAll = request.getParameter("siteAll");
//                tradeAll = request.getParameter("tradeAll");
//                mainTypeAll = request.getParameter("mainTypeAll");
//
//                trade = request.getParameterValues("trade");
//                site_ = request.getParameterValues("site");
//                mainType = request.getParameterValues("mainType");
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                wboCritaria.setAttribute("trade", trade);
//
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                if (unitId != null && !unitId.equals("")) {
//                    wboCritaria.setAttribute("unitId", unitId);
//
//                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria, issueTitleEnum);
//                } else {
//                    wboCritaria.setAttribute("site", site_);
//                    wboCritaria.setAttribute("mainType", mainType);
//
//                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria, issueTitleEnum);
//                }
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allLabor = new Vector();
//                    allTask = new Vector();
//
//                    try {
//                        allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                    }
//
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("allLabor", allLabor);
//                    wbo.setAttribute("tasks", allTask);
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//                }
//
//                request.setAttribute("unitName", unitName);
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("itemName", itemName);
//
//                request.setAttribute("tradeAll", tradeAll);
//                request.setAttribute("mainTypeAll", mainTypeAll);
//                request.setAttribute("siteAll", siteAll);
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//                if (!mainTypeAll.equals("yes")) {
//                    String s = mainCategoryTypeMgr.getMainTypeName(mainType).get(0).toString();
//                    if (mainCategoryTypeMgr.getMainTypeName(mainType).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("unitNamesStr", s);
//                } else {
//                    params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
//                }
//                if (!tradeAll.equals("yes")) {
//                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
//                } else {
//                    params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                }
//
//                Tools.createPdfReport("CostingJobOrdersWithLabor", params, allMaintenanceInfo, getServletContext(), response, request);
//                break;
//
//            case 12:
//                from = request.getParameter("from");
//                to = request.getParameter("to");
//
//                params = new HashMap();
//                allMaintenanceInfo = new Vector();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//
//                params.put("C1", "\u0645\u0646 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
//                params.put("C2", "\u0627\u0644\u0649 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
//                params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
//                params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                params.put("beginDate", from);
//                params.put("endDate", to);
//                params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByMaintNum(from, to);
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allLabor = new Vector();
//                    allTask = new Vector();
//
//                    try {
//                        allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                    }
//
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("allLabor", allLabor);
//                    wbo.setAttribute("tasks", allTask);
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//                }
//
//                Tools.createPdfReport("CostingJobOrdersWithLabor", params, allMaintenanceInfo, getServletContext(), response, request);
//                break;
//
//            case 13:
//                ArrayList allTrade = new ArrayList();
//                Vector brandsVec = new Vector();
//                ArrayList allMainType = new ArrayList();
//                ArrayList brands = new ArrayList();
//                allTrade = tradeMgr.getAllAsArrayList();
//                userProjectsMgr = UserProjectsMgr.getInstance();
//                maintainableMgr = MaintainableMgr.getInstance();
//                Vector projects = new Vector();
//                try {
//                    projects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
//                    brandsVec = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//                ArrayList locationsList = new ArrayList();
//                for (int i = 0; i < projects.size(); i++) {
//                    locationsList.add(projects.get(i));
//                }
//                wbo = new WebBusinessObject();
//                for (int i = 0; i < brandsVec.size(); i++) {
//                    wbo = (WebBusinessObject) brandsVec.get(i);
//                    //if(!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0"))
//                    brands.add(wbo);
//                }
//                request.setAttribute("defaultLocationName", securityUser.getSiteName());
//                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
//                request.setAttribute("allTrade", allTrade);
//                request.setAttribute("allSites", locationsList);
//                request.setAttribute("allMainType", allMainType);
//                request.setAttribute("brands", brands);
//                servedPage = "/docs/costing_report/maintenance_operations_analysis_report_form.jsp";
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//
//            case 14:
//                wbo = new WebBusinessObject();
//                params = new HashMap();
//                status = request.getParameterValues("issueStatus");
//                site_ = request.getParameterValues("site");
//                trade = request.getParameterValues("trade");
//                String reportType = request.getParameter("reportType");
//                mainTypeAll = request.getParameter("mainTypeAll");
//                siteAll = request.getParameter("siteAll");
//                brandAll = request.getParameter("brandAll");
//                tradeAll = request.getParameter("tradeAll");
//                try {
//                    mainType = request.getParameterValues("mainType");
//                    wbo.setAttribute("mainTaypeValues", mainType);
//                    if (!mainTypeAll.equals("yes")) {
//                        String s = mainCategoryTypeMgr.getMainTypeName(mainType).get(0).toString();
//                        if (mainCategoryTypeMgr.getMainTypeName(mainType).size() > 1) {
//                            s += " , ...";
//                        }
//                        params.put("mainType", s);
//                    } else {
//                        params.put("mainType", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
//                    }
//                } catch (NullPointerException ex) {
//                    params.put("mainType", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
//                }
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("sites", s);
//                } else {
//                    params.put("sites", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//                try {
//                    unitId = request.getParameter("unitId");
//                    unitName = request.getParameter("unitName");
//                    wbo.setAttribute("unitId", unitId);
//                    params.put("unitName", Tools.getRealChar(unitName));
//                } catch (NullPointerException ex) {
//                    params.put("unitName", "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A");
//                }
//                try {
//                    brand = request.getParameterValues("brand");
//                    wbo.setAttribute("brand", brand);
//                    if (!brandAll.equals("yes")) {
//                        String s = maintainableMgr.getBrandName(brand).get(0).toString();
//                        if (maintainableMgr.getBrandName(brand).size() > 1) {
//                            s += " , ...";
//                        }
//                        params.put("brand", s);
//                    }
//                } catch (NullPointerException ex) {
//                    params.put("brand", "\u0643\u0644 \u0627\u0644\u0645\u0631\u0643\u0627\u062A");
//                }
//                if (!tradeAll.equals("yes")) {
//                    params.put("trade", tradeMgr.getTradesByIds(trade).get(0).toString());
//                } else {
//                    params.put("trade", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                }
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                wbo.setAttribute("issueTitle", request.getParameter("issueTitle"));
//                wbo.setAttribute("issueStatus", status);
//                wbo.setAttribute("sitesValues", site_);
//                wbo.setAttribute("tradeValues", trade);
//                wbo.setAttribute("beginDate", beginDate);
//                wbo.setAttribute("endDate", endDate);
//                params.put("status", Tools.arrayToString(status, " - "));
//                if (request.getParameter("issueTitle").equalsIgnoreCase("both")) {
//                    params.put("issueTitle", "\u062F\u0648\u0631\u064A\u0629 \u0648\u0637\u0627\u0631\u0626\u0629");
//                } else if (request.getParameter("issueTitle").equalsIgnoreCase("Emergency")) {
//                    params.put("issueTitle", "\u0637\u0627\u0631\u0626\u0629");
//                } else {
//                    params.put("issueTitle", "\u062F\u0648\u0631\u064A\u0629");
//                }
//                Vector allAnalysisInfo = new Vector();
//                if (reportType.equals("Totaly")) {
//                    allAnalysisInfo = taskMgr.maintenanceOperationAnalysisTotaly(wbo);
//                    reportType = "maintenanceOperationsAnalysisReportTotaly";
//                } else if (reportType.equals("Detailed")) {
//                    allAnalysisInfo = taskMgr.maintenanceOperationAnalysisDetailed(wbo);
//                    reportType = "maintenanceOperationsAnalysisReportDetailed";
//                } else {
//                    allAnalysisInfo = taskMgr.maintenanceOperationAnalysisAnalyised(wbo);
//                    reportType = "maintenanceOperationsAnalysisReportAnalyised";
//                }
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                Tools.createPdfReport(reportType, params, allAnalysisInfo, getServletContext(), response, request);
//                break;
//
//            case 15:
//                reportType = request.getParameter("reportType");
//                String reportData = request.getParameter("reportData");
//                String[] departmentValues;
//                String[] productionLines;
//                Vector data = new Vector();
//                wbo = new WebBusinessObject();
//                HashMap reportParams = new HashMap();
//                wbo.setAttribute("beginDate", request.getParameter("beginDate"));
//                wbo.setAttribute("endDate", request.getParameter("endDate"));
//                reportParams.put("bDate", request.getParameter("beginDate"));
//                reportParams.put("eDate", request.getParameter("endDate"));
//                wbo.setAttribute("reportType", reportType);
//                try {
//                    if (reportData == null) {
//                        if (reportType.equals("mainTypeRadio")) {
//                            mainType = request.getParameterValues("mainType");
//                            wbo.setAttribute("mainType", mainType);
//                            reportParams.put("type", "\u0627\u0644\u0646\u0648\u0639");
//                        } else if (reportType.equals("brandRadio")) {
//                            brand = request.getParameterValues("brand");
//                            wbo.setAttribute("brand", brand);
//                            reportParams.put("type", "\u0627\u0644\u0645\u0627\u0631\u0643\u0629");
//                        } else if (reportType.equals("unit")) {
//                            unitId = request.getParameter("unitId");
//                            wbo.setAttribute("unitId", unitId);
//                            reportParams.put("type", "\u0627\u0644\u0645\u0639\u062F\u0629");
//                        }
//                        data = allMaintenanceInfoMgr.getCostingReports(wbo);
//                        Tools.createPdfReport("mainTypesAVGCostReport", reportParams, data, getServletContext(), response, request);
//
//                    } else {
//
//                        String sub = request.getParameter("with");
//                        if (reportType.equals("mainTypeRadio")) {
//                            mainType = request.getParameterValues("mainType");
//                            wbo.setAttribute("mainType", mainType);
//                            reportParams.put("type", "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u064A");
//                        } else if (reportType.equals("brandRadio")) {
//                            brand = request.getParameterValues("brand");
//                            wbo.setAttribute("brand", brand);
//                            reportParams.put("type", "\u0645\u0627\u0631\u0643\u0629");
//                        }
//
//                        if (sub.equals("units")) {
//                            reportParams.put("subName", "\u0623\u0633\u0645 \u0627\u0644\u0645\u0639\u062F\u0629");
//                        } else if (sub.equals("brands")) {
//                            reportParams.put("subName", "\u0623\u0633\u0645 \u0627\u0644\u0645\u0627\u0631\u0643\u0629");
//                        } else if (sub.equals("mainTypes")) {
//                            reportParams.put("subName", "\u0623\u0633\u0645 \u0627\u0644\u0646\u0648\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A");
//                        } else if (sub.equals("departments")) {
//                            reportParams.put("subName", "\u0623\u0633\u0645 \u0627\u0644\u0642\u0633\u0645");
//                        }
//                        wbo.setAttribute("sub", sub);
//                        data = allMaintenanceInfoMgr.getCostingReportsGroup(wbo);
//                        Tools.createPdfReport("mainTypesAVGCostReportGroups", reportParams, data, getServletContext(), response, request);
//                    }
//                } catch (SQLException ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                break;
//
//            case 16:
//
//                java.sql.Connection conn = null;
//                try {
//                    conn = AllMaintenanceInfoMgr.getInstance().getReportConn();
//                } catch (SQLException ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                reportParams = new HashMap();
//                reportParams.put("bDate", request.getParameter("beginDate"));
//                reportParams.put("eDate", request.getParameter("endDate"));
//                reportParams.put("unitName", request.getParameter("unitName"));
//                reportParams.put("unit_id", request.getParameter("unitId"));
//
//                Tools.createPdfReport("Spare", reportParams, getServletContext(), response, request, conn);
//                try {
//                    conn.close();
//                } catch (SQLException ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                break;
//            case 17:
//
//                params = new HashMap();
//
//                Vector dataSource = null;
//                Vector itemListTemp = new Vector();
//                issueId = request.getParameter(IssueConstants.ISSUEID);
//                WebBusinessObject myIssue = issueMgr.getOnSingleKey(issueId);
//                String uID = (String) myIssue.getAttribute("unitScheduleID");
//                WebBusinessObject unitWbo = usMgr.getOnSingleKey(myIssue.getAttribute("unitScheduleID").toString());
//
//                String eqpName = (String) unitWbo.getAttribute("unitName");
//                String issueNo = (String) myIssue.getAttribute("businessID");
//
//                params.put("unitName", eqpName);
//                params.put("issueNo", issueNo);
//
//                Vector itemList = new Vector();
//                String uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
//                QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
//                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "0");
//                WebBusinessObject web = usMgr.getOnSingleKey(uID);
//
//                String eID = web.getAttribute("periodicId").toString();
//
//                if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
//                    itemList = ListItems.getSpecialItemSchedule(uSID, "0");
//
//                } else {
//
//                    if (itemListTemp.size() == 0) {
//                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
//                        itemList = itemsList.getConfigItemBySchedule(eID);
//
//                    } else {
//                        itemList = itemListTemp;
//
//                    }
//                }
//
//                if (!itemList.isEmpty()) {
//                    AppConstants appCons = new AppConstants();
//                    String[] itemAtt = appCons.getItemScheduleAttributes();
//                    String attName = null;
//                    String attValue = null;
//                    Enumeration e = itemList.elements();
//                    WebBusinessObject itemWbo = new WebBusinessObject();
//                    dataSource = new Vector();
//                    WebBusinessObject aWbo = null;
//                    totalCost = 0.0;
//                    int totalUsedSpareParts = 0;
//                    while (e.hasMoreElements()) {
//                        totalUsedSpareParts++;
//                        wbo = (WebBusinessObject) e.nextElement();
//                        attName = itemAtt[0];
//                        attValue = (String) wbo.getAttribute(attName);
//                        String[] itemcodeList = attValue.split("-");
//
//                        if (itemcodeList.length > 1) {
//                            itemWbo = (WebBusinessObject) itemsMgr.getOnSingleKey(attValue);
//                        } else {
//                            itemWbo = itemsMgr.getOnObjectByKey(attValue);
//
//                        }
//
//                        if (itemWbo != null) {
//                            aWbo = new WebBusinessObject();
//
//                            if (itemcodeList.length > 1) {
//                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCodeByItemForm"));
//
//                            } else {
//                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCode"));
//
//                            }
//
//                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
//                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
//                            aWbo.setAttribute("totalCost", (String) wbo.getAttribute("totalCost"));
//                            aWbo.setAttribute("itemPrice", (String) wbo.getAttribute("itemPrice"));
//                            totalCost += Double.parseDouble((String) wbo.getAttribute("totalCost"));
//                            attName = itemAtt[1];
//                            attValue = (String) wbo.getAttribute(attName);
//                            aWbo.setAttribute("itemQuantity", attValue);
//
//                            attName = itemAtt[4];
//                            attValue = (String) wbo.getAttribute(attName);
//                            aWbo.setAttribute("note", attValue);
//
//                            dataSource.add(aWbo);
//                        }
//                    }
//                    params.put("totalCost", Double.parseDouble(decimalFormat.format(totalCost)));
//                    params.put("totalUsedSpareParts", totalUsedSpareParts);
//                }
//
//                Tools.createPdfReport("SpareParts", params, dataSource, getServletContext(), response, request);
//                break;
//
//            case 18:
//
//                params = new HashMap();
//
//                itemListTemp = new Vector();
//                String projectname = request.getParameter("projectName");
//                this.assignedIssueState = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
////                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
//                issueId = request.getParameter(IssueConstants.ISSUEID);
//
//                myIssue = issueMgr.getOnSingleKey(issueId);
//
//                uID = (String) myIssue.getAttribute("unitScheduleID");
//                String issue_title = request.getParameter(IssueConstants.ISSUETITLE);
//
//
//                filterName = request.getParameter("filterName");
//                filterValue = request.getParameter("filterValue");
//                String attachedEqFlag = (String) request.getParameter("attachedEqFlag");
//
//                params = new HashMap();
//
//                itemListTemp = new Vector();
//                issueId = request.getParameter(IssueConstants.ISSUEID);
//                myIssue = issueMgr.getOnSingleKey(issueId);
//                uID = (String) myIssue.getAttribute("unitScheduleID");
//                unitWbo = usMgr.getOnSingleKey(myIssue.getAttribute("unitScheduleID").toString());
//
//                eqpName = (String) unitWbo.getAttribute("unitName");
//                issueNo = (String) myIssue.getAttribute("businessID");
//
//                params.put("unitName", eqpName);
//                params.put("issueNo", issueNo);
//
//                itemList = new Vector();
//                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
//
//                UsedSparePartsMgr ListUsedItems = UsedSparePartsMgr.getInstance();
//                itemListTemp = ListUsedItems.getUsedItemSchedule(uSID);
//                itemList = itemListTemp;
//
//                Vector<WebBusinessObject> configitemList = new Vector();
//                // uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
//
//                web = usMgr.getOnSingleKey(uID);
//                eID = new String();
//                eID = web.getAttribute("periodicId").toString();
//                /*if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
//                configitemList = ListItems.getSpecialItemSchedule(uSID, "0");
//                } else {
//                if (itemListTemp.size() == 0) {
//                ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
//                configitemList = itemsList.getConfigItemBySchedule(eID);
//                } else {
//                configitemList = itemListTemp;
//                }
//                }
//                
//                if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
//                itemList = ListItems.getSpecialItemSchedule(uSID, "0");
//                
//                } else {
//                
//                if (itemListTemp.size() == 0) {
//                ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
//                itemList = itemsList.getConfigItemBySchedule(eID);
//                
//                } else {
//                itemList = itemListTemp;
//                
//                }
//                }*/
//                dataSource = new Vector();
//                if (!itemList.isEmpty()) {
//                    AppConstants appCons = new AppConstants();
//                    String[] itemAtt = appCons.getItemScheduleAttributes();
//                    String attName = null;
//                    String attValue = null;
//                    Enumeration e = itemList.elements();
//                    WebBusinessObject itemWbo = new WebBusinessObject();
//                    WebBusinessObject aWbo = null;
//                    int totalUsedSpareParts = 0;
//                    totalCost = 0.0;
//                    params.put("usedSparePartsReport", "yes");
//
//                    while (e.hasMoreElements()) {
//                        totalUsedSpareParts++;
//                        wbo = (WebBusinessObject) e.nextElement();
//                        attName = itemAtt[0];
//                        attValue = (String) wbo.getAttribute(attName);
//                        String[] itemcodeList = attValue.split("-");
//
//                        if (itemcodeList.length > 1) {
//                            itemWbo = (WebBusinessObject) itemsMgr.getOnSingleKey(attValue);
//                        } else {
//                            itemWbo = itemsMgr.getOnObjectByKey(attValue);
//
//                        }
//
//                        if (itemWbo != null) {
//                            aWbo = new WebBusinessObject();
//
//                            if (itemcodeList.length > 1) {
//                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCodeByItemForm"));
//
//                            } else {
//                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCode"));
//
//                            }
//
//                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
//                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
//                            aWbo.setAttribute("totalCost", (String) wbo.getAttribute("totalCost"));
//                            aWbo.setAttribute("itemPrice", (String) wbo.getAttribute("itemPrice"));
//                            totalCost += Double.parseDouble((String) wbo.getAttribute("totalCost"));
//                            attName = itemAtt[1];
//                            attValue = (String) wbo.getAttribute(attName);
//                            aWbo.setAttribute("itemQuantity", attValue);
//
//                            attName = itemAtt[4];
//                            attValue = (String) wbo.getAttribute(attName);
//                            aWbo.setAttribute("note", attValue);
//
//                            dataSource.add(aWbo);
//                        }
//                    }
//                    params.put("totalUsedSpareParts", totalUsedSpareParts);
//                    params.put("totalCost", Double.parseDouble(decimalFormat.format(totalCost)));
//                }
//
//                Tools.createPdfReport("SpareParts", params, dataSource, getServletContext(), response, request);
//                break;
//
//
//            case 19:
//                externalJobReportMgr = ExternalJobReportMgr.getInstance();
//                from = request.getParameter("from");
//                to = request.getParameter("to");
//                totalCost = 0.0;
//                dataSet = new Vector();
//                params = new HashMap();
//
//                dataSet = externalJobReportMgr.getExternalJOBReportByMaintNum(from, to);
//
//                for (int i = 0; i < dataSet.size(); i++) {
//                    wbo = (WebBusinessObject) dataSet.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//                    String siteName = projectMgr.getSiteNameById((String) wbo.getAttribute("site_id"));
//                    laborCost = Double.parseDouble((String) wbo.getAttribute("labor_cost"));
//                    totalCost += laborCost;
//                    //wbo.setAttribute("labor_cost", (String)wbo.getAttribute("labor_cost"));
//
//                    try {
//                        wbo.setAttribute("parentName", parentName);
//                        wbo.setAttribute("siteName", siteName);
//
//                    } catch (Exception e) {
//                        wbo.setAttribute("parentName", "");
//                        wbo.setAttribute("siteName", "");
//                        System.out.println();
//
//                    }
//                }
//
//                params.put("totalCost", totalCost);
//                params.put("fromToMaintNumReport", "yes");
//                params.put("fromSide", "\u0645\u0646 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
//                params.put("toSide", "\u0627\u0644\u0649 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
//                params.put("fromMaintNum", from);
//                params.put("toMaintNum", to);
//
//                // create and open PDF report in browser
//                Tools.createPdfReport("ExternalReport01", params, dataSet, getServletContext(), response, request);
//                break;
//
//            case 20:
//                Vector tempVec = null;
//                dataSource = new Vector();
//                params = new HashMap();
//                Vector schedulesVec = null;
//                Vector EqpsVec = null;
//                String scheduleId = null;
//                String unitId = null;
//                WebBusinessObject scheduleWbo = null;
//                unitWbo = null;
//                WebBusinessObject dataSourceWbo = null;
//                String brandId = request.getParameter("brandId");
//                String brandName = request.getParameter("brandName");
//                String dueBeginDate = request.getParameter("dueBeginDate");
//
//                try {
//
//                    // get ALL schedules on this brand/model/category
//                    // whether they are activated or not
//                    schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(brandId, "key4", "Cat", "key5");
//
//                } catch (SQLException ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (Exception ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                for (int i = 0; i < schedulesVec.size(); i++) {
//                    scheduleWbo = (WebBusinessObject) schedulesVec.get(i);
//                    scheduleId = (String) scheduleWbo.getAttribute("periodicID");
//
//                    // get equipments scheduled on this schedule which is
//                    // activated after the given date
//                    EqpsVec = usMgr.getEqpsByDueAfterDateSchedule(scheduleId, dueBeginDate);
//
//                    if (EqpsVec != null && !EqpsVec.isEmpty()) {
//
//                        for (int j = 0; j < EqpsVec.size(); j++) {
//                            dataSourceWbo = (WebBusinessObject) EqpsVec.get(j);
//
//                            /* set data source wbo with schedule info */
//                            dataSourceWbo.setAttribute("frequencyType",
//                                    Tools.getFrequencyType((String) scheduleWbo.getAttribute("frequencyType"),
//                                    "Ar"));
//                            dataSourceWbo.setAttribute("frequency", (String) scheduleWbo.getAttribute("frequency"));
//                            /* -set data source wbo with schedule info */
//
//                            unitId = (String) dataSourceWbo.getAttribute("unitId");
//                            unitWbo = maintainableMgr.getOnSingleKey(unitId);
//
//                            // set data source wbo with unit info
//                            dataSourceWbo.setAttribute("unitCode", (String) unitWbo.getAttribute("unitNo"));
//
//                        }
//
//
//                        dataSource.addAll(EqpsVec);
//                    }
//                }
//
//                params.put("brandName", brandName);
//                params.put("dueBeginDate", dueBeginDate);
//
//                // create and open PDF report in browser
//                Tools.createPdfReport("EqpsByDueAfterDateBrandSchedules", params, dataSource, getServletContext(), response, request);
//                break;
//
//            case 21:
//                conn = null;
//                try {
//                    conn = AllMaintenanceInfoMgr.getInstance().getReportConn();
//                } catch (SQLException ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                reportParams = new HashMap();
//                Tools.createPdfReport("Approval", reportParams, getServletContext(), response, request, conn);
//                try {
//                    conn.close();
//                } catch (SQLException ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                break;
//            case 23:
//                reportName = "";
//                params = new HashMap();
//                projectMgr = ProjectMgr.getInstance();
//                totalJOCost = 0.0;
//                grandTotalJOCost = 0.0;
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                JODate = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                allMaintenanceInfo = new Vector();
//                itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                issueTitlee = request.getParameter("issueTitle");
//                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                if (issueTitlee.equals("notEmergency")) {
//                    issueTitleEnum = IssueTitle.NotEmergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629");
//                } else if (issueTitlee.equals("Emergency")) {
//                    issueTitleEnum = IssueTitle.Emergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                } else {
//                    issueTitleEnum = IssueTitle.Both;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0648 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                }
//
//
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                trade = request.getParameterValues("trade");
//                tradeAll = request.getParameter("tradeAll");
//                brandAll = request.getParameter("brandAll");
//                siteAll = request.getParameter("siteAll");
//                laborDetail = request.getParameter("laborDetail");
//                if (laborDetail == null) {
//                    laborDetail = "off";
//                }
//
//                site_ = request.getParameterValues("site");
//                brand = request.getParameterValues("brand");
//
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//                date_order = dateType + " " + orderType;
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("date_order", date_order);
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//
//                wboCritaria.setAttribute("site", site_);
//                wboCritaria.setAttribute("brand", brand);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteBrand(wboCritaria, issueTitleEnum);
//
//                if (!brandAll.equals("yes")) {
//                    String s = "";
//                    tempVec = parentUnitMgr.getParensName(brand);
//                    if (tempVec != null && !tempVec.isEmpty()) {
//                        s = tempVec.get(0).toString();
//                    }
//                    if (tempVec.size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("unitNamesStr", s);
//                } else {
//                    params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A");
//                }
//                params.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0627\u0631\u0643\u0629");
//
//
//                actualEndDate = null;
//                if (laborDetail.equals("on")) {
//                    allMaintenanceInfoCopy = new Vector();
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    grandTotalJOCost = 0;
//
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//
//                        totalJOCost = 0.0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//
//                        allLabor = new Vector();
//                        try {
//                            allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                        } catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//
//                        totalItemsCost = 0.0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception E) {
//                            System.out.println("no parent type");
//                        }
//                        wbo.setAttribute("labors", allLabor);
//
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCostWithLaborsDetails";
//
//
//                } else {
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    int index = 0;
//                    allMaintenanceInfoCopy = new Vector();
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                        totalJOCost = 0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//                        wbo.setAttribute("JODate", JODate);
//
//                        totalItemsCost = 0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
//                        wbo.setAttribute("totalItemCost", totalItemsCost);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception e) {
//                            System.out.println();
//                        }
//
//                        wbo.setAttribute("laborCost", laborCost);
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCost";
//                }
//
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("itemName", itemName);
//
//                request.setAttribute("tradeAll", tradeAll);
//                request.setAttribute("siteAll", siteAll);
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("grandTotalJOCost", grandTotalJOCost);
//
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
//                } else {
//                    params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                }
//
//                Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);
//                break;
//
//            case 24:
//                reportName = "";
//                params = new HashMap();
//                projectMgr = ProjectMgr.getInstance();
//                totalJOCost = 0.0;
//                grandTotalJOCost = 0.0;
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                JODate = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                allMaintenanceInfo = new Vector();
//                itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                issueTitlee = request.getParameter("issueTitle");
//                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                if (issueTitlee.equals("notEmergency")) {
//                    issueTitleEnum = IssueTitle.NotEmergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629");
//                } else if (issueTitlee.equals("Emergency")) {
//                    issueTitleEnum = IssueTitle.Emergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                } else {
//                    issueTitleEnum = IssueTitle.Both;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0648 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                }
//
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                trade = request.getParameterValues("trade");
//                tradeAll = request.getParameter("tradeAll");
//                siteAll = request.getParameter("siteAll");
//                laborDetail = request.getParameter("laborDetail");
//                if (laborDetail == null) {
//                    laborDetail = "off";
//                }
//                mainTypeAll = request.getParameter("mainTypeAll");
//
//                site_ = request.getParameterValues("site");
//                mainType = request.getParameterValues("mainType");
//
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//                date_order = dateType + " " + orderType;
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("date_order", date_order);
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//
//                wboCritaria.setAttribute("site", site_);
//                wboCritaria.setAttribute("mainType", mainType);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria, issueTitleEnum);
//
//                if (!mainTypeAll.equals("yes")) {
//                    String s = "";
//                    tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
//                    if (tempVec != null && !tempVec.isEmpty()) {
//                        s = tempVec.get(0).toString();
//                    }
//                    if (tempVec.size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("unitNamesStr", s);
//                } else {
//                    params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
//                }
//                params.put("EQUIPMENT_TYPE", "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u0649");
//
//
//                actualEndDate = null;
//                if (laborDetail.equals("on")) {
//                    allMaintenanceInfoCopy = new Vector();
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    grandTotalJOCost = 0;
//
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//
//                        totalJOCost = 0.0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//
//                        allLabor = new Vector();
//                        try {
//                            allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                        } catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//
//                        totalItemsCost = 0.0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception E) {
//                            System.out.println("no parent type");
//                        }
//                        wbo.setAttribute("labors", allLabor);
//
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCostWithLaborsDetails";
//
//
//                } else {
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    int index = 0;
//                    allMaintenanceInfoCopy = new Vector();
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                        totalJOCost = 0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//                        wbo.setAttribute("JODate", JODate);
//
//                        totalItemsCost = 0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
//                        wbo.setAttribute("totalItemCost", totalItemsCost);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception e) {
//                            System.out.println();
//                        }
//
//                        wbo.setAttribute("laborCost", laborCost);
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCost";
//                }
//
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("itemName", itemName);
//
//                request.setAttribute("tradeAll", tradeAll);
//                request.setAttribute("siteAll", siteAll);
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("grandTotalJOCost", grandTotalJOCost);
//
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
//                } else {
//                    params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                }
//
//                Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);
//                break;
//
//            case 25:
//                unitId = request.getParameter("unitId");
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//
//                currentStatus = request.getParameterValues("currenStatus");
//                String[] site = request.getParameterValues("site");
//                issueTitle = request.getParameter("issueTitle");
//
//                // set wbo To pass to Method to search
//                WebBusinessObject wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("issueTitle", issueTitle);
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);
//
//                // for lable in jasper report
//                String unitNameLbl = "";
//                String unitNamesStr = "";
//                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                wboCritaria.setAttribute("unitId", unitId);
//
//                wbo = maintainableMgr.getOnSingleKey(unitId);
//                parentId = (String) wbo.getAttribute("parentId");
//                params.put("unitName", (String) wbo.getAttribute("unitName"));
//
//                String projectId = (String) wbo.getAttribute("site");
//                wbo = projectMgr.getOnSingleKey(projectId);
//                params.put("siteName", (String) wbo.getAttribute("projectName"));
//
//                params.put("parentName", maintainableMgr.getUnitName(parentId));
//                params.put("equipmentReport", "yes");
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria);
//
//                unitNameLbl = "\u0627\u0644\u0645\u0639\u062F\u0629";
//                unitNamesStr = unitName;
//
//                maintenanceDuration = null;
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        if (actualBeginDate != null) {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                        }
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//                }
//
//                if (!siteAll.equals("yes")) {
//                    siteVec = (Vector) projectMgr.getProjectsName(site);
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                        if (siteVec.size() > 0) {
//                            siteStrArr += " ...";
//                            break;
//                        }
//                    }
//                }
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("unitNameLbl", unitNameLbl);
//                params.put("unitNamesStr", unitNamesStr);
//                params.put("siteStrArr", siteStrArr);
//                params.put("taskName", taskName);
//                params.put("REPORT_TYPE", "else");
//                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                // create and open PDF report in browser
//                context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//
//                break;
//            case 26:
//                Vector allMaintenanceInfo;
//                String issueId,
//                 parentId,
//                 parentName;
//                Vector allItems,
//                 allTask,
//                 tempv1,
//                 tempv2;
//
//                Map params = new HashMap();
//
//                unitId = request.getParameter("unitId");
//                String unitName = request.getParameter("unitName");
//                String taskId = request.getParameter("taskId");
//                String taskName = request.getParameter("taskName");
//                String itemId = request.getParameter("partId");
//                String itemName = request.getParameter("partName");
//                String beginDate = request.getParameter("beginDate");
//                String endDate = request.getParameter("endDate");
//                String siteAll = request.getParameter("siteAll");
//                String tradeAll = request.getParameter("tradeAll");
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//
//                String[] trade = request.getParameterValues("trade");
//                currentStatus = request.getParameterValues("currenStatus");
//                site = request.getParameterValues("site");
//                String issueTitle = request.getParameter("issueTitle");
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("issueTitle", issueTitle);
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);
//
//                // for lable in jasper report
//                unitNameLbl = "";
//                unitNamesStr = "";
//                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                String tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";
//
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                wboCritaria.setAttribute("unitId", unitId);
//
//                wbo = maintainableMgr.getOnSingleKey(unitId);
//                parentId = (String) wbo.getAttribute("parentId");
//                params.put("unitName", (String) wbo.getAttribute("unitName"));
//
//                projectId = (String) wbo.getAttribute("site");
//                wbo = projectMgr.getOnSingleKey(projectId);
//                params.put("siteName", (String) wbo.getAttribute("projectName"));
//
//                params.put("parentName", maintainableMgr.getUnitName(parentId));
//                params.put("equipmentReport", "yes");
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria);
//
//                unitNameLbl = "\u0627\u0644\u0645\u0639\u062F\u0629";
//                unitNamesStr = unitName;
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        if (actualBeginDate != null) {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                        }
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//                }
//
//                if (!siteAll.equals("yes")) {
//                    siteVec = (Vector) projectMgr.getProjectsName(site);
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                        if (siteVec.size() > 0) {
//                            siteStrArr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    Vector tradeVec = tradeMgr.getTradesByIds(trade);
//                    for (int i = 0; i < tradeVec.size(); i++) {
//                        if (i == 0) {
//                            tradeStr = (String) tradeVec.get(i);
//                        } else {
//                            tradeStr += " - " + (String) tradeVec.get(i);
//                        }
//                        if (tradeVec.size() > 0) {
//                            tradeStr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("unitNameLbl", unitNameLbl);
//                params.put("unitNamesStr", unitNamesStr);
//                params.put("siteStrArr", siteStrArr);
//                params.put("tradeStr", tradeStr);
//                params.put("taskName", taskName);
//                params.put("REPORT_TYPE", "else");
//                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                // create and open PDF report in browser
//                context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//
//                break;
//            case 27:
//
//                params = new HashMap();
//
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                siteAll = request.getParameter("siteAll");
//                tradeAll = request.getParameter("tradeAll");
//                String brandAll = request.getParameter("brandAll");
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//
//                trade = request.getParameterValues("trade");
//                currentStatus = request.getParameterValues("currenStatus");
//                site = request.getParameterValues("site");
//
//                String[] brand = request.getParameterValues("brand");
//                issueTitle = request.getParameter("issueTitle");
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("issueTitle", issueTitle);
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);
//
//                // for lable in jasper report
//                unitNameLbl = "";
//                unitNamesStr = "";
//                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";
//
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                wboCritaria.setAttribute("site", site);
//                wboCritaria.setAttribute("brand", brand);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByBrand(wboCritaria);
//
//                if (!brandAll.equals("yes")) {
//                    String s = "";
//                    tempVec = parentUnitMgr.getParensName(brand);
//                    if (tempVec != null && !tempVec.isEmpty()) {
//                        s = tempVec.get(0).toString();
//                    }
//                    if (tempVec.size() > 1) {
//                        s += " , ...";
//                    }
//                    unitNamesStr = s;
//                } else {
//                    unitNamesStr = "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A";
//                }
//                unitNameLbl = "\u0627\u0644\u0645\u0627\u0631\u0643\u0629";
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        if (actualBeginDate != null) {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                        }
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//                }
//
//                if (!siteAll.equals("yes")) {
//                    siteVec = (Vector) projectMgr.getProjectsName(site);
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                        if (siteVec.size() > 0) {
//                            siteStrArr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    Vector tradeVec = tradeMgr.getTradesByIds(trade);
//                    for (int i = 0; i < tradeVec.size(); i++) {
//                        if (i == 0) {
//                            tradeStr = (String) tradeVec.get(i);
//                        } else {
//                            tradeStr += " - " + (String) tradeVec.get(i);
//                        }
//                        if (tradeVec.size() > 0) {
//                            tradeStr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("unitNameLbl", unitNameLbl);
//                params.put("unitNamesStr", unitNamesStr);
//                params.put("siteStrArr", siteStrArr);
//                params.put("tradeStr", tradeStr);
//                params.put("taskName", taskName);
//                params.put("REPORT_TYPE", "else");
//                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                // create and open PDF report in browser
//                context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//
//                break;
//            case 28:
//
//                params = new HashMap();
//
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                siteAll = request.getParameter("siteAll");
//                tradeAll = request.getParameter("tradeAll");
//                String mainTypeAll = request.getParameter("mainTypeAll");
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//
//                trade = request.getParameterValues("trade");
//                currentStatus = request.getParameterValues("currenStatus");
//                site = request.getParameterValues("site");
//                mainType = request.getParameterValues("mainType");
//                issueTitle = request.getParameter("issueTitle");
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("issueTitle", issueTitle);
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);
//
//                // for lable in jasper report
//                unitNameLbl = "";
//                unitNamesStr = "";
//                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";
//
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//
//                wboCritaria.setAttribute("site", site);
//                wboCritaria.setAttribute("mainType", mainType);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria);
//
//                if (!mainTypeAll.equals("yes")) {
//                    String s = "";
//                    tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
//                    if (tempVec != null && !tempVec.isEmpty()) {
//                        s = tempVec.get(0).toString();
//                    }
//                    if (tempVec.size() > 1) {
//                        s += " , ...";
//                    }
//                    unitNamesStr = s;
//                } else {
//                    unitNamesStr = "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629";
//                }
//                unitNameLbl = "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u0649";
//
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        if (actualBeginDate != null) {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                        }
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//                }
//
//                if (!siteAll.equals("yes")) {
//                    siteVec = (Vector) projectMgr.getProjectsName(site);
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                        if (siteVec.size() > 0) {
//                            siteStrArr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    Vector tradeVec = tradeMgr.getTradesByIds(trade);
//                    for (int i = 0; i < tradeVec.size(); i++) {
//                        if (i == 0) {
//                            tradeStr = (String) tradeVec.get(i);
//                        } else {
//                            tradeStr += " - " + (String) tradeVec.get(i);
//                        }
//                        if (tradeVec.size() > 0) {
//                            tradeStr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("unitNameLbl", unitNameLbl);
//                params.put("unitNamesStr", unitNamesStr);
//                params.put("siteStrArr", siteStrArr);
//                params.put("tradeStr", tradeStr);
//                params.put("taskName", taskName);
//                params.put("REPORT_TYPE", "else");
//                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                // create and open PDF report in browser
//                context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//
//                break;
//
//            case 29:
//
//                params = new HashMap();
//
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                siteAll = request.getParameter("siteAll");
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//
//                currentStatus = request.getParameterValues("currenStatus");
//                site = request.getParameterValues("site");
//
//                issueTitle = request.getParameter("issueTitle");
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                wboCritaria.setAttribute("issueTitle", issueTitle);
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);
//
//                // for lable in jasper report
//                unitNameLbl = "";
//                unitNamesStr = "";
//                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";
//
//                wboCritaria.setAttribute("site", site);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySites(wboCritaria);
//
//                unitNameLbl = "\u0627\u0644\u0645\u0639\u062F\u0629";
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        if (actualBeginDate != null) {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                        }
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//                }
//
//                if (!siteAll.equals("yes")) {
//                    siteVec = (Vector) projectMgr.getProjectsName(site);
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                        if (siteVec.size() > 0) {
//                            siteStrArr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("unitNameLbl", unitNameLbl);
//                params.put("unitNamesStr", unitNamesStr);
//                params.put("siteStrArr", siteStrArr);
//                params.put("tradeStr", tradeStr);
//                params.put("REPORT_TYPE", "else");
//                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//                params.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0639\u062F\u0629");
//                params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A");
//                // create and open PDF report in browser
//                context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//                break;
//
//            case 30:
//                reportName = "";
//                params = new HashMap();
//                projectMgr = ProjectMgr.getInstance();
//                totalJOCost = 0.0;
//                grandTotalJOCost = 0.0;
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                JODate = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                allMaintenanceInfo = new Vector();
//                itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                issueTitlee = request.getParameter("issueTitle");
//                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                if (issueTitlee.equals("notEmergency")) {
//                    issueTitleEnum = IssueTitle.NotEmergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629");
//                } else if (issueTitlee.equals("Emergency")) {
//                    issueTitleEnum = IssueTitle.Emergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                } else {
//                    issueTitleEnum = IssueTitle.Both;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0648 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                }
//
//
////                taskId = request.getParameter("taskId");
////                taskName = request.getParameter("taskName");
////                itemId = request.getParameter("partId");
////                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
////                trade = request.getParameterValues("trade");
////                tradeAll = request.getParameter("tradeAll");
//                siteAll = request.getParameter("siteAll");
//                laborDetail = request.getParameter("laborDetail");
//                if (laborDetail == null) {
//                    laborDetail = "off";
//                }
//
//                site_ = request.getParameterValues("site");
//
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//                date_order = dateType + " " + orderType;
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                //wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("date_order", date_order);
//
//                /*if (taskId != null && !taskId.equals("")) {
//                wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                wboCritaria.setAttribute("itemId", itemId);
//                }*/
//
//                wboCritaria.setAttribute("site", site_);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySites(wboCritaria, issueTitleEnum);
//
//                params.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0639\u062F\u0629");
//
//
//                actualEndDate = null;
//                if (laborDetail.equals("on")) {
//                    allMaintenanceInfoCopy = new Vector();
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    grandTotalJOCost = 0;
//
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//
//                        totalJOCost = 0.0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//
//                        allLabor = new Vector();
//                        try {
//                            allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                        } catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//
//                        totalItemsCost = 0.0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception E) {
//                            System.out.println("no parent type");
//                        }
//                        wbo.setAttribute("labors", allLabor);
//
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCostWithLaborsDetails";
//
//
//                } else {
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    int index = 0;
//                    allMaintenanceInfoCopy = new Vector();
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                        totalJOCost = 0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//                        wbo.setAttribute("JODate", JODate);
//
//                        totalItemsCost = 0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
//                        wbo.setAttribute("totalItemCost", totalItemsCost);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception e) {
//                            System.out.println();
//                        }
//
//                        wbo.setAttribute("laborCost", laborCost);
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCost";
//                }
//
//                /*request.setAttribute("taskName", taskName);
//                request.setAttribute("itemName", itemName);
//                
//                request.setAttribute("tradeAll", tradeAll);*/
//                request.setAttribute("siteAll", siteAll);
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("grandTotalJOCost", grandTotalJOCost);
//
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//
////                if (!tradeAll.equals("yes")) {
////                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
////                } else {
//                params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
////                }
//                params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A");
//                Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);
//                break;
//            case 31:
//
//                params = new HashMap();
//
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                siteAll = request.getParameter("siteAll");
//                tradeAll = request.getParameter("tradeAll");
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//
//                trade = request.getParameterValues("trade");
//                currentStatus = request.getParameterValues("currenStatus");
//                site = request.getParameterValues("site");
//
//                issueTitle = request.getParameter("issueTitle");
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("issueTitle", issueTitle);
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);
//
//                // for lable in jasper report
//                unitNameLbl = "";
//                unitNamesStr = "";
//                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";
//
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                wboCritaria.setAttribute("site", site);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySites(wboCritaria);
//
//                unitNameLbl = "\u0627\u0644\u0645\u0627\u0631\u0643\u0629";
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        if (actualBeginDate != null) {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                        }
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//                }
//
//                if (!siteAll.equals("yes")) {
//                    siteVec = (Vector) projectMgr.getProjectsName(site);
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                        if (siteVec.size() > 0) {
//                            siteStrArr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    Vector tradeVec = tradeMgr.getTradesByIds(trade);
//                    for (int i = 0; i < tradeVec.size(); i++) {
//                        if (i == 0) {
//                            tradeStr = (String) tradeVec.get(i);
//                        } else {
//                            tradeStr += " - " + (String) tradeVec.get(i);
//                        }
//                        if (tradeVec.size() > 0) {
//                            tradeStr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("unitNameLbl", unitNameLbl);
//                params.put("unitNamesStr", unitNamesStr);
//                params.put("siteStrArr", siteStrArr);
//                params.put("tradeStr", tradeStr);
//                params.put("taskName", taskName);
//                params.put("REPORT_TYPE", "else");
//                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                // create and open PDF report in browser
//                context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//                break;
//
//            case 32:
//                reportName = "";
//                params = new HashMap();
//                projectMgr = ProjectMgr.getInstance();
//                totalJOCost = 0.0;
//                grandTotalJOCost = 0.0;
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                JODate = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                allMaintenanceInfo = new Vector();
//                itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                issueTitlee = request.getParameter("issueTitle");
//                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                if (issueTitlee.equals("notEmergency")) {
//                    issueTitleEnum = IssueTitle.NotEmergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629");
//                } else if (issueTitlee.equals("Emergency")) {
//                    issueTitleEnum = IssueTitle.Emergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                } else {
//                    issueTitleEnum = IssueTitle.Both;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0648 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                }
//
//
//                taskId = request.getParameter("taskId");
//                taskName = request.getParameter("taskName");
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                trade = request.getParameterValues("trade");
//                tradeAll = request.getParameter("tradeAll");
//                siteAll = request.getParameter("siteAll");
//                laborDetail = request.getParameter("laborDetail");
//                if (laborDetail == null) {
//                    laborDetail = "off";
//                }
//
//                site_ = request.getParameterValues("site");
//
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//                date_order = dateType + " " + orderType;
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("date_order", date_order);
//
//                if (taskId != null && !taskId.equals("")) {
//                    wboCritaria.setAttribute("taskId", taskId);
//                }
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                wboCritaria.setAttribute("site", site_);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySites(wboCritaria, issueTitleEnum);
//
//                params.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0627\u0631\u0643\u0629");
//
//
//                actualEndDate = null;
//                if (laborDetail.equals("on")) {
//                    allMaintenanceInfoCopy = new Vector();
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    grandTotalJOCost = 0;
//
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//
//                        totalJOCost = 0.0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//
//                        allLabor = new Vector();
//                        try {
//                            allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                        } catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//
//                        totalItemsCost = 0.0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception E) {
//                            System.out.println("no parent type");
//                        }
//                        wbo.setAttribute("labors", allLabor);
//
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCostWithLaborsDetails";
//
//
//                } else {
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    int index = 0;
//                    allMaintenanceInfoCopy = new Vector();
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                        totalJOCost = 0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//                        wbo.setAttribute("JODate", JODate);
//
//                        totalItemsCost = 0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
//                        wbo.setAttribute("totalItemCost", totalItemsCost);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception e) {
//                            System.out.println();
//                        }
//
//                        wbo.setAttribute("laborCost", laborCost);
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCost";
//                }
//
//                request.setAttribute("taskName", taskName);
//                request.setAttribute("itemName", itemName);
//
//                request.setAttribute("tradeAll", tradeAll);
//                request.setAttribute("siteAll", siteAll);
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("grandTotalJOCost", grandTotalJOCost);
//
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//
//                if (!tradeAll.equals("yes")) {
//                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
//                } else {
//                    params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
//                }
//
//                Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);
//                break;
//            case 33:
//
//                params = new HashMap();
//
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                siteAll = request.getParameter("siteAll");
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//
//                trade = request.getParameterValues("trade");
//                currentStatus = request.getParameterValues("currenStatus");
//                site = request.getParameterValues("site");
//
//                issueTitle = request.getParameter("issueTitle");
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//
//                wboCritaria.setAttribute("trade", trade);
//                wboCritaria.setAttribute("issueTitle", issueTitle);
//                wboCritaria.setAttribute("currentStatus", currentStatus);
//                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);
//
//                // for lable in jasper report
//                unitNameLbl = "";
//                unitNamesStr = "";
//                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
//                tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";
//
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                wboCritaria.setAttribute("site", site);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySites(wboCritaria);
//
//                unitNameLbl = "\u0627\u0644\u0645\u0627\u0631\u0643\u0629";
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                    issueId = (String) wbo.getAttribute("issueId");
//                    allItems = new Vector();
//                    allTask = new Vector();
//
//                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
//                    allTask = tasksByIssueMgr.getTask(issueId);
//
//                    wbo.setAttribute("items", allItems);
//                    wbo.setAttribute("tasks", allTask);
//                    wbo.getAttribute("unitName");
//
//                    parentId = (String) wbo.getAttribute("parentId");
//                    parentName = maintainableMgr.getUnitName(parentId);
//
//                    wbo.setAttribute("parentName", parentName);
//
//                    issueStatus = (String) wbo.getAttribute("currentStatus");
//                    String issueStatusLabel = "";
//
//                    if (issueStatus.equals("Assigned")) {
//                        issueStatusLabel = JOAssignedStatus;
//                        tempStatus = " - " + JOOpenStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                        if (actualBeginDate != null) {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//
//                        }
//
//                    } else if (issueStatus.equals("Canceled")) {
//                        issueStatusLabel = JOCanceledStatus;
//                        tempStatus = " - " + JOCancelStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                        maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//
//                    } else {
//                        issueStatusLabel = JOFinishedStatus;
//                        tempStatusBegin = " - " + JOOpenStatus;
//                        tempStatusEnd = " - " + JOCloseStatus;
//                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                        try {
//                            maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                        } catch (NullPointerException nPEx) {
//                            maintenanceDuration = "0";
//                        }
//                    }
//
//                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                        typeOfSchedule = JOEmrgencyStatus;
//                    } else {
//                        temp1 = (String) wbo.getAttribute("issueTitle");
//                        typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                    }
//
//                    wbo.setAttribute("issueStatus", issueStatusLabel);
//                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                    wbo.setAttribute("currentStatusSince", currentStatusSince);
//                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
//                }
//
//                if (!siteAll.equals("yes")) {
//                    siteVec = (Vector) projectMgr.getProjectsName(site);
//                    for (int i = 0; i < siteVec.size(); i++) {
//                        if (i == 0) {
//                            siteStrArr = (String) siteVec.get(i);
//                        } else {
//                            siteStrArr += " - " + (String) siteVec.get(i);
//                        }
//                        if (siteVec.size() > 0) {
//                            siteStrArr += " ...";
//                            break;
//                        }
//                    }
//                }
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("unitNameLbl", unitNameLbl);
//                params.put("unitNamesStr", unitNamesStr);
//                params.put("siteStrArr", siteStrArr);
//                params.put("tradeStr", tradeStr);
//                params.put("REPORT_TYPE", "else");
//                params.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                // create and open PDF report in browser
//                context = getServletConfig().getServletContext();
//                Tools.createPdfReport("DetailedMaintenance", params, allMaintenanceInfo, context, response, request);
//                break;
//
//            case 34:
//                reportName = "";
//                params = new HashMap();
//                projectMgr = ProjectMgr.getInstance();
//                totalJOCost = 0.0;
//                grandTotalJOCost = 0.0;
//
//                temp1 = "";
//                typeOfSchedule = "";
//                issueStatus = "";
//                tempStatus = "";
//                maintenanceDuration = "";
//                JODate = "";
//                tempStatusBegin = "";
//                tempStatusEnd = "";
//                currentStatusSince = "";
//
//                currentStatusSinceDate = null;
//                actualBeginDate = null;
//                actualEndDate = null;
//
//                allMaintenanceInfo = new Vector();
//                itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
//                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
//                tasksByIssueMgr = TasksByIssueMgr.getInstance();
//                issueTitlee = request.getParameter("issueTitle");
//                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
//                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");
//
//                if (issueTitlee.equals("notEmergency")) {
//                    issueTitleEnum = IssueTitle.NotEmergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629");
//                } else if (issueTitlee.equals("Emergency")) {
//                    issueTitleEnum = IssueTitle.Emergency;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                } else {
//                    issueTitleEnum = IssueTitle.Both;
//                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0648 \u0627\u0644\u0639\u0627\u062F\u064A\u0629");
//                }
//
//
//                itemId = request.getParameter("partId");
//                itemName = request.getParameter("partName");
//                beginDate = request.getParameter("beginDate");
//                endDate = request.getParameter("endDate");
//                siteAll = request.getParameter("siteAll");
//                laborDetail = request.getParameter("laborDetail");
//                if (laborDetail == null) {
//                    laborDetail = "off";
//                }
//
//                site_ = request.getParameterValues("site");
//
//                orderType = request.getParameter("orderType");
//                dateType = request.getParameter("dateType");
//                date_order = dateType + " " + orderType;
//
//                // set wbo To pass to Method to search
//                wboCritaria = new WebBusinessObject();
//                wboCritaria.setAttribute("beginDate", beginDate);
//                wboCritaria.setAttribute("endDate", endDate);
//                wboCritaria.setAttribute("date_order", date_order);
//
//                if (itemId != null && !itemId.equals("")) {
//                    wboCritaria.setAttribute("itemId", itemId);
//                }
//
//                wboCritaria.setAttribute("site", site_);
//
//                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByTasks(wboCritaria, issueTitleEnum);
//
//                params.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0627\u0631\u0643\u0629");
//
//
//                actualEndDate = null;
//                if (laborDetail.equals("on")) {
//                    allMaintenanceInfoCopy = new Vector();
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    grandTotalJOCost = 0;
//
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//
//                        totalJOCost = 0.0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//
//                        allLabor = new Vector();
//                        try {
//                            allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
//                        } catch (Exception ex) {
//                            logger.error(ex.getMessage());
//                        }
//
//                        totalItemsCost = 0.0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception E) {
//                            System.out.println("no parent type");
//                        }
//                        wbo.setAttribute("labors", allLabor);
//
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCostWithLaborsDetails";
//
//
//                } else {
//                    totalItemsCost = 0.0;
//                    laborCost = 0;
//                    int index = 0;
//                    allMaintenanceInfoCopy = new Vector();
//                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
//                        totalJOCost = 0;
//                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
//                        issueId = (String) wbo.getAttribute("issueId");
//                        allItems = new Vector();
//                        allTask = new Vector();
//
//                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
//                        allTask = tasksByIssueMgr.getTask(issueId);
//
//                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
//
//                        parentId = (String) wbo.getAttribute("parentId");
//                        parentName = maintainableMgr.getUnitName(parentId);
//
//                        issueStatus = (String) wbo.getAttribute("currentStatus");
//                        String issueStatusLabel = "";
//
//                        try {
//                            if (issueStatus.equals("Assigned")) {
//                                issueStatusLabel = JOAssignedStatus;
//                                tempStatus = " - " + JOOpenStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");
//
//                            } else if (issueStatus.equals("Canceled")) {
//                                issueStatusLabel = JOCanceledStatus;
//                                tempStatus = " - " + JOCancelStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
//                                JODate = currentStatusSince;
//
//                            } else {
//                                issueStatusLabel = JOFinishedStatus;
//                                tempStatusBegin = " - " + JOOpenStatus;
//                                tempStatusEnd = " - " + JOCloseStatus;
//                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;
//
//                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
//                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
//
//
//                                maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
//                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
//                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");
//
//                            }
//                        } catch (NullPointerException ex) {
//                            maintenanceDuration = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                            JODate = "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D";
//                        }
//
//                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
//                            typeOfSchedule = JOEmrgencyStatus;
//                        } else {
//                            temp1 = (String) wbo.getAttribute("issueTitle");
//                            typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
//                        }
//
//                        wbo.setAttribute("issueStatus", issueStatusLabel);
//                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
//                        wbo.setAttribute("currentStatusSince", currentStatusSince);
//                        wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
//                        wbo.setAttribute("JODate", JODate);
//
//                        totalItemsCost = 0;
//                        for (int j = 0; j < allItems.size(); j++) {
//                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
//                            try {
//                                itemName = tempItem.getAttribute("itemDesc").toString();
//                            } catch (Exception e) {
//                                itemName = "Item Name Not Supported";
//                            }
//                            tempItem.setAttribute("itemDesc", itemName);
//                            try {
//                                totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
//                            } catch (Exception ex) {
//                                logger.error(ex.getMessage());
//                            }
//
//                        }
//
//                        grandTotalJOCost += (totalItemsCost + laborCost);
//
//                        wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);
//                        wbo.setAttribute("totalItemCost", totalItemsCost);
//                        wbo.setAttribute("items", allItems);
//                        wbo.setAttribute("tasks", allTask);
//
//                        try {
//                            wbo.setAttribute("parentName", parentName);
//                        } catch (Exception e) {
//                            System.out.println();
//                        }
//
//                        wbo.setAttribute("laborCost", laborCost);
//                        totalJOCost = totalItemsCost + laborCost;
//
//                        if (totalJOCost != 0.0) {
//                            allMaintenanceInfoCopy.add(wbo);
//                        }
//
//                    }
//
//                    reportName = "SJOAvgCost";
//                }
//
//                request.setAttribute("itemName", itemName);
//
//                request.setAttribute("siteAll", siteAll);
//
//                params.put("beginDate", beginDate);
//                params.put("endDate", endDate);
//                params.put("grandTotalJOCost", grandTotalJOCost);
//
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//                Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);
//                break;
//
//            case 38:
//               java.sql.Connection   conn1 = null;
//               String report = "";
//               maintainableMgr = MaintainableMgr.getInstance();
//               String isId = request.getParameter("issueId");
//               String jobNo = request.getParameter("jobNo");
//               reportParams = new HashMap();             
//               issueMgr = IssueMgr.getInstance();
//               WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(isId);
//                
//                
//              reportParams.put("issue_id", isId);
//              reportParams.put("unit_name", issueWbo.getAttribute("issueType").toString());
//              reportParams.put("job_no", jobNo);
//              report="problemAnalysis";               
//                
//                try {
//                    conn1 = AllMaintenanceInfoMgr.getInstance().getReportConn();
//                } catch (SQLException ex) {
//                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                 Tools.createPdfReport(report, reportParams, getServletContext(), response, request, conn1);
//               
//                try {
//                    conn1.close();
//                } catch (SQLException ex) {
//                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//               break;
//
//
//            case 37:
//                servedPage = "/docs/reports/maintenance_items_number.jsp";
//                WebBusinessObject taskWbo = null;
//                Vector taskVec = new Vector();
//                String jsonText = null;
//                List categoryList = null;
//                List dataList = null;
//                taskName = null;
//                int count = 0;
//      
//                beginDate = (String) request.getParameter("beginDate");
//                endDate = (String) request.getParameter("endDate");
//                
//                try {
//                    taskVec = taskMgr.getAllItemsByDate(beginDate, endDate);
//
//                } catch (Exception ex) {
//                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//
//                if(!taskVec.isEmpty()) {
//                    categoryList = new ArrayList();
//                    dataList = new ArrayList();
//
//                    for(int i = 0; i < taskVec.size(); i++) {
//                        taskWbo = (WebBusinessObject) taskVec.get(i);
//
//                        taskName = (String) taskWbo.getAttribute("name");
//                        count = issueTasksMgr.CountMaintenanceItems((String) taskWbo.getAttribute("id"));
//
//                        categoryList.add(taskName);
//                        dataList.add(count);
//
//                    }
//
//                    // convert lists to JSON string
//                    request.setAttribute("categories", JSONValue.toJSONString(categoryList));
//                    request.setAttribute("data", JSONValue.toJSONString(dataList));
//                    request.setAttribute("dataSize", dataList.size() + "");
//
//                }
//
//                this.forward(servedPage, request, response);
//
//                break;
//
//            case 39:
//                params = new HashMap();
//                WebBusinessObject wbo = null,
//                                  lastIssueWbo = null,
//                                  penultimateIssueWbo = null;
//
//                scheduleId = null;
//                Vector schedulesByEquipVec = null;
//                
//                dataSet = new Vector();
//                scheduleId = request.getParameter("scheduleId");
//                String scheduleName = request.getParameter("scheduleName");
//                unitId = request.getParameter("unitId");
//                unitName = request.getParameter("unitName");
//                String toDate = request.getParameter("toDate");
//                site_ = request.getParameterValues("site");
//                siteAll = request.getParameter("siteAll");
//
//                unitWbo = maintainableMgr.getOnSingleKey(unitId);
//                String counterType = mainCategoryTypeMgr.getTypeOfMainTypeNameById(
//                        (String) unitWbo.getAttribute("maintTypeId"));
//                params.put("counterType", counterType);
//                
//                params.put("scheduleName", scheduleName);
//                params.put("unitName", unitName);
//                
//                if (!siteAll.equals("yes")) {
//                    String s = projectMgr.getProjectsName(site_).get(0).toString();
//                    if (projectMgr.getProjectsName(site_).size() > 1) {
//                        s += " , ...";
//                    }
//                    params.put("siteStrArr", s);
//                } else {
//                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
//                }
//
//                if(scheduleId == null || scheduleId.equals("")) {
//                    schedulesByEquipVec = scheduleMgr.getScheduledSchedulesByEquip(unitId);
//
//                } else {
//                    schedulesByEquipVec = scheduleMgr.getScheduledSchedulesByEquipAndSchedule(unitId, scheduleId);
//                    
//                }
//
//                for(int i = 0; i < schedulesByEquipVec.size(); i++) {
//                    
//                    scheduleId = (String) schedulesByEquipVec.get(i);
//
//                    lastIssueWbo = issueMgr.getLastIssueBySchedule(unitId, scheduleId, Tools.arrayToString(site_, ","), toDate);
//                    penultimateIssueWbo = issueMgr.getPenultimateIssueBySchedule(unitId, scheduleId, Tools.arrayToString(site_, ","), toDate);
//
//                    if(lastIssueWbo != null && penultimateIssueWbo != null) {
//                        wbo = new WebBusinessObject();
//                        wbo.setAttribute("unitName", unitName);
//                        wbo.setAttribute("siteName", (String) lastIssueWbo.getAttribute("projectName"));
//                        wbo.setAttribute("scheduleName", (String) lastIssueWbo.getAttribute("scheduleTitle"));
//                        wbo.setAttribute("JONumber", (String) lastIssueWbo.getAttribute("JONumber"));
//                        wbo.setAttribute("JODate", (String) lastIssueWbo.getAttribute("JODate"));
//                        wbo.setAttribute("lastIssueCounter", (String) lastIssueWbo.getAttribute("counterReading"));
//                        wbo.setAttribute("penultimateIssueCounter", (String) penultimateIssueWbo.getAttribute("counterReading"));
//
//                        dataSet.add(wbo);
//                    }
//                    
//                }
//
//                Tools.createPdfReport("deviationsInEquipmentsReadings", params, dataSet, getServletContext(), response, request);
//                break;
//                
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
        if (opName.equals("getExternalReports")) {
            return 1;
        }
        if (opName.equals("ExternalReport")) {
            return 2;
        }
        if (opName.equals("getSampleCostingReports")) {
            return 3;
        }
        if (opName.equals("SampleCostingReports")) {
            return 4;
        }
        if (opName.equals("equipmentsWithReadingsReport")) {
            return 5;
        }
        if (opName.equals("resultCostByAvgJOForEqp")) {
            return 6;
        }
        if (opName.equals("resultCostByAvgJOMaintNum")) {
            return 7;
        }
        if (opName.equals("resultSearchMaintenanceDetailsFromTo")) {
            return 8;
        }
        if (opName.equals("avgCostingFullReport")) {
            return 9;
        }
        if (opName.equals("avgCostingFullReportResult")) {
            return 10;
        }
        if (opName.equals("costingJobOrdersWithLabor")) {
            return 11;
        }
        if (opName.equals("costingJobOrdersWithLaborByMaintNum")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("jobOperationAnalysis")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("resultMaintenanceOpAnalysis")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("resultCostingReport")) {
            return 15;
        }
        if (opName.equalsIgnoreCase("sparePartsReport")) {
            return 16;
        }

        if (opName.equalsIgnoreCase("printEquipmentParts")) {
            return 17;
        }
        if (opName.equalsIgnoreCase("printUsedSpareParts")) {
            return 18;
        }
        if (opName.equalsIgnoreCase("ExternalReportFromTo")) {
            return 19;
        }
        if (opName.equalsIgnoreCase("EqpsByDueAfterDateBrandSchedules")) {
            return 20;
        }
        if (opName.equalsIgnoreCase("EquipmentApproval")) {
            return 21;
        }
        if (opName.equalsIgnoreCase("EquipmentApprovalGrouping")) {
            return 22;
        }


        if (opName.equals("resultCostByAvgJOForModel")) {
            return 23;
        }
        if (opName.equals("resultCostByAvgJOForMainType")) {
            return 24;
        }
        if (opName.equals("resultCostByAvgJOForEqp")) {
            return 25;
        }
        if (opName.equals("resulReportMaintDetailsByEqp")) {
            return 26;
        }
        if (opName.equals("resulReportMaintDetailsByModel")) {
            return 27;
        }
        if (opName.equals("resulReportMaintDetailsByMainType")) {
            return 28;
        }
        if (opName.equals("resulReportMaintDetailsBySites")) {
            return 29;
        }
        if (opName.equals("resultCostByAvgJOBySites")) {
            return 30;
        }
        if (opName.equals("resulReportMaintDetailsBySpareParts")) {
            return 31;
        }
        if (opName.equals("resultCostByAvgJOBySpareParts")) {
            return 32;
        }
        if (opName.equals("resulReportMaintDetailsBySpareParts")) {
            return 33;
        }
        if (opName.equals("resultCostByAvgJOBySpareParts")) {
            return 34;
        }
        if (opName.equals("resulReportMaintDetailsByTasks")) {
            return 35;
        }
        if (opName.equals("resultCostByAvgJOByTasks")) {
            return 36;
        }

        if (opName.equals("itemComplainReport")) {
            return 38;
        }

        if (opName.equals("tasksByDate")) {
            return 37;
        }

        if (opName.equals("deviationsInEquipmentsReadings")) {
            return 39;
        }

        return 0;
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
