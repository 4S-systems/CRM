package com.externalReports.servlets;

import com.Erp.db_access.CostCentersMgr;
import com.SpareParts.db_access.TransactionMgr;
import com.SpareParts.db_access.UsedSparePartsMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ClientSeasonsMgr;
import com.clients.db_access.ClientViewMgr;
import com.clients.db_access.ReservationMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.tracker.db_access.IssueMgr;
import com.contractor.db_access.MaintainableMgr;
import com.crm.db_access.CommentsMgr;
import com.customization.common.CustomizeJOMgr;
import com.externalReports.db_access.ExternalJobReportMgr;
import com.externalReports.db_access.IssueByCostTasksMgr;
import com.maintenance.common.ConfigFileMgr;
import com.maintenance.common.ResultDataReportBean;
import com.maintenance.common.Templates;
import com.maintenance.common.Tools;
import com.maintenance.common.WboCollectionDataSource;
import com.maintenance.db_access.ActualItemMgr;
import com.maintenance.db_access.AllMaintenanceInfoMgr;
import com.maintenance.db_access.AverageUnitMgr;
import com.maintenance.db_access.BranchErpMgr;
import com.maintenance.db_access.ConfigTasksPartsMgr;
import com.maintenance.db_access.ConfigureMainTypeMgr;
import com.maintenance.db_access.EmpBasicMgr;
import com.maintenance.db_access.EmpTasksHoursMgr;
import com.maintenance.db_access.EquipByPlanMgr;
import com.maintenance.db_access.EquipmentsWithReadingMgr;
import com.maintenance.db_access.ExternalJobMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.IssueCounterReadingMgr;
import com.maintenance.db_access.ItemFormMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.ItemsWithAvgPriceItemDataMgr;
import com.maintenance.db_access.ItemsWithAvgPriceMgr;
import com.maintenance.db_access.LaborComplaintsMgr;
import com.maintenance.db_access.LocalStoresItemsMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.MaintenanceItemMgr;
import com.maintenance.db_access.ParentUnitMgr;
import com.maintenance.db_access.QuantifiedItemsMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ReadingByScheduleMgr;
import com.maintenance.db_access.ReadingRateUnitMgr;
import com.maintenance.db_access.RegionMgr;
import com.maintenance.db_access.ResultStoreItemMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.StoresErpMgr;
import com.maintenance.db_access.SupplierMgr;
import com.maintenance.db_access.TaskMgr;
import com.maintenance.db_access.TasksByIssueMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.TransStoreItemMgr;
import com.maintenance.db_access.TransactionDetailsMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.planning.db_access.PlanMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.international.BilingualDisplayTerms;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.business_objects.WebIssue;
import com.tracker.common.AppConstants;
import com.tracker.common.IssueConstants;
import com.tracker.db_access.IssueStatusMgr;
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
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;
import org.apache.commons.lang.time.DurationFormatUtils;
import com.maintenance.db_access.ScheduleTasksMgr;
import com.maintenance.servlets.ReportsServletThree;
import com.silkworm.common.UserMgr;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ClientCampaignMgr;
import java.awt.Color;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import net.sf.dynamicreports.jasper.builder.JasperReportBuilder;
import net.sf.dynamicreports.report.base.DRGroup;
import net.sf.dynamicreports.report.base.DRVariable;
import net.sf.dynamicreports.report.base.component.DRComponent;
import net.sf.dynamicreports.report.builder.VariableBuilder;
import net.sf.dynamicreports.report.builder.column.TextColumnBuilder;
import net.sf.dynamicreports.report.builder.component.HorizontalListBuilder;
import net.sf.dynamicreports.report.builder.group.ColumnGroupBuilder;
import net.sf.dynamicreports.report.builder.style.StyleBuilder;
import net.sf.dynamicreports.report.constant.Calculation;
import net.sf.dynamicreports.report.constant.GroupHeaderLayout;
import net.sf.dynamicreports.report.constant.PageOrientation;
import net.sf.dynamicreports.report.constant.PageType;
import net.sf.dynamicreports.report.constant.SplitType;
import net.sf.dynamicreports.report.definition.DRIGroup;
import net.sf.dynamicreports.report.exception.DRException;
import static net.sf.dynamicreports.report.builder.DynamicReports.*;
import net.sf.dynamicreports.report.constant.ComponentPositionType;
import net.sf.dynamicreports.report.constant.HorizontalAlignment;
import net.sf.dynamicreports.report.constant.VerticalAlignment;

public class PDFReportServlet extends TrackerBaseServlet {
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
    TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
    EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
    ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    ResultStoreItemMgr resultStoreItemMgr = ResultStoreItemMgr.getInstance();
    TransactionMgr transactionMgr = TransactionMgr.getInstance();
    QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
    TransStoreItemMgr transStoreItemMgr = TransStoreItemMgr.getInstance();
    TransactionDetailsMgr transactionDetailsMgr = TransactionDetailsMgr.getInstance();
    ItemFormMgr itemFormMgr = ItemFormMgr.getInstance();
    BranchErpMgr branchErpMgr = BranchErpMgr.getInstance();
    StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
    EquipByPlanMgr equipByPlanMgr = EquipByPlanMgr.getInstance();
    PlanMgr planMgr = PlanMgr.getInstance();
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
    CustomizeJOMgr customizeJOMgr = CustomizeJOMgr.getInstance();
    ConfigFileMgr configFileMgr = new ConfigFileMgr();
    ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();
    MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
    LocalStoresItemsMgr localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
    QuantifiedMntenceMgr quantifiedMgr = QuantifiedMntenceMgr.getInstance();
    ConfigureMainTypeMgr configureTypeMgr = ConfigureMainTypeMgr.getInstance();
    LaborComplaintsMgr laborComplaintsMgr = LaborComplaintsMgr.getInstance();
    ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
    ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
    ItemsWithAvgPriceMgr avgpriceMgr = ItemsWithAvgPriceMgr.getInstance();
    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
    ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
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
        String JOCanceledStatus, JOClosedStatus, JOFinishedStatus, JOOnholdStatus, JOAssignedStatus, JOOpendStatus;
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
            JOOpendStatus = BilingualDisplayTerms.JO_AR_OPEND_STATUS;

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
            JOOpendStatus = BilingualDisplayTerms.JO_EN_OPEND_STATUS;
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
                Vector projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(PDFReportsTreeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                allModel = maintainableMgr.getAllModelsAsArrayList();
                suppliers = supplierMgr.getAllSuppliers();
                request.setAttribute("page", servedPage);
                request.setAttribute("suppliers", suppliers);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("allModels", allModel);
                request.setAttribute("allSites", projects);
                if (single != null) {
                    request.setAttribute("imageshow", single);
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;

            case 2:
                SupplierMgr supplierMgr = SupplierMgr.getInstance();
                ExternalJobReportMgr externalJobReportMgr = ExternalJobReportMgr.getInstance();

                params = new HashMap();
                dataSet = new Vector();
                unitId = new String();
                //String[] Status = request.getParameter("status").split(",");
                String unit = request.getParameter("unitId");//Tools.concatenation(allModels, ",");
                String sup = request.getParameter("sup");
                String searchBy = request.getParameter("searchBy");
                String[] allSite = request.getParameterValues("site");
                String[] allModels = request.getParameterValues("model");

                String sDate = request.getParameter("beginDate");
                String eDate = request.getParameter("endDate");

                String modelAll = request.getParameter("modelAll");
                siteAll = request.getParameter("siteAll");
                String orderType = request.getParameter("orderType");
                String dateType = request.getParameter("dateType");
                String date_order = dateType + " " + orderType;
                String[] currentStatus = request.getParameterValues("currenStatus");

                wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", sDate);
                wboCritaria.setAttribute("endDate", eDate);

                wboCritaria.setAttribute("currentStatus", currentStatus);
                wboCritaria.setAttribute("date_order", date_order);
                wboCritaria.setAttribute("site", allSite);

                double totalCost = 0.0;
                String searchByType = "";

                if (searchBy.equalsIgnoreCase("unit")) {
                    searchByType = lang.equalsIgnoreCase("Ar") ? "\u0645\u0639\u062F\u0629" : "Equipment";
                    if (unit != null) {
                        //
                        unitName = request.getParameter("unitName");
                        unitId = request.getParameter("unitId");

                        if (unitName.equals("") || unitId.equals("All")) {
                            unitName = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A" : "All Equipments";
                            params.put("unit", unitName);
                        } else {
                            wbo = maintainableMgr.getOnSingleKey(unitId);
                            params.put("unit", wbo.getAttribute("unitName"));
                        }

                        wboCritaria.setAttribute("unitId", unitId);
                        try {
                            dataSet = externalJobReportMgr.getExternalJOBReportByEquip(wboCritaria);
                        } catch (SQLException ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        params.put("equipmentReport", "yes");
                    }
                } else {
                    Vector modelsVec = (Vector) maintainableMgr.getModelsNames(allModels);
                    searchByType = lang.equalsIgnoreCase("Ar") ? "\u0645\u0648\u062F\u064A\u0644/\u0645\u0627\u0631\u0643\u0629" : "Model";
                    if (allModels != null) {
                        wboCritaria.setAttribute("models", allModels);

                        try {
                            dataSet = externalJobReportMgr.getExternalJOBReportByModel(wboCritaria);
                        } catch (SQLException ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    if (modelAll.equals("yes")) {
                        unit = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0648\u062F\u064A\u0644\u0627\u062A/\u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A" : "All Models";
                    } else {
                        for (int i = 0; i < modelsVec.size(); i++) {
                            if (i == 0) {
                                unit = (String) modelsVec.get(i);
                            } else {
                                unit += " - " + (String) modelsVec.get(i);
                            }
                        }
                    }
                    params.put("unit", unit);
                }

                params.put("searchByType", searchByType);
                params.put("mainSite", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0648\u0642\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u0649" : "Main Site"));
                params.put("equipment", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0639\u062F\u0629" : "Equipment"));
                params.put("model", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0627\u0631\u0643\u062A\u0647\u0627" : "Model"));
                params.put("at", (lang.equalsIgnoreCase("Ar") ? "\u0641\u0649" : "at"));
                params.put("jobOrderCountPerEquipment", (lang.equalsIgnoreCase("Ar") ? "\u0639\u062F\u062F \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0644\u0644\u0645\u0639\u062F\u0629" : "Job Order Count Per Equipment"));
                params.put("totalCostPerEquipment", (lang.equalsIgnoreCase("Ar") ? "\u0625\u062C\u0645\u0627\u0644\u0649 \u0627\u0644\u062A\u0643\u0644\u0641\u0629 \u0644\u0644\u0645\u0639\u062F\u0629" : "Total Cost Per Equipment"));

                WebBusinessObject branchProject,
                 mainProject = new WebBusinessObject();
                EmpBasicMgr basicMgr = EmpBasicMgr.getInstance();
                CostCentersMgr costCentersMgr = CostCentersMgr.getInstance();
                if (dataSet.size() > 0) {
                    for (int i = 0; i < dataSet.size(); i++) {
                        branchProject = null;
                        mainProject = null;
                        wbo = (WebBusinessObject) dataSet.get(i);
                        issueId = (String) wbo.getAttribute("issue_id");

                        parentId = (String) wbo.getAttribute("parentId");
                        parentName = maintainableMgr.getUnitName(parentId);
                        WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unit_id"));
                        try {
                            if (!getMainInfo.getAttribute("empID").equals("")) {
                                String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                                wbo.setAttribute("empName", empName);
                            } else {
                                wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            }
                        } catch (Exception exc) {
                            wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }

                        try {
                            if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                                String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                                if (costName.equals("***")) {
                                    wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                                } else {
                                    wbo.setAttribute("costName", costName);
                                }
                            } else {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            }
                        } catch (Exception exc) {
                            wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                        String siteName = projectMgr.getSiteNameById((String) wbo.getAttribute("site_id"));
                        branchProject = projectMgr.getOnSingleKey((String) wbo.getAttribute("site_id"));
                        if (!branchProject.getAttribute("mainProjId").equals("0")) {
                            mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                            wbo.setAttribute("mainSite", (String) mainProject.getAttribute("projectName"));
                        }
                        laborCost = Double.parseDouble((String) wbo.getAttribute("labor_cost"));
                        totalCost += laborCost;
                        //wbo.setAttribute("labor_cost", (String)wbo.getAttribute("labor_cost"));
                        try {
                            wbo.setAttribute("parentName", parentName);
                            wbo.setAttribute("siteName", siteName);
                        } catch (Exception e) {
                            wbo.setAttribute("parentName", "");
                            wbo.setAttribute("siteName", "");
                            System.out.println();
                        }
                    }
                }
                params.put("totalCost", totalCost);

                String siteStrArr = "";
                Vector siteVec = (Vector) projectMgr.getProjectsName(allSite);
                if (siteAll.equals("yes")) {
                    siteStrArr = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639" : "All Sites";
                } else {
                    for (int i = 0; i < siteVec.size(); i++) {
                        if (i == 0) {
                            siteStrArr = (String) siteVec.get(i);
                        } else {
                            siteStrArr += " - " + (String) siteVec.get(i);
                        }
                    }
                }

                params.put("location", siteStrArr);
                if (!sup.equals("All")) {
                    wbo = supplierMgr.getOnSingleKey(sup);
                    params.put("sup", wbo.getAttribute("name"));
                } else {
                    params.put("sup", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0648\u0631\u062F\u064A\u0646" : "All Suppliers"));
                }
                params.put("Sdate", sDate);
                params.put("Edate", eDate);
                params.put("fromSide", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E" : "From Date"));
                params.put("toSide", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E" : "To Date"));

                /*String PDFsite = "All";
                 String[] Status = request.getParameter("status").split(",");
                 String unit = request.getParameter("unit");
                 String sup = request.getParameter("sup");
                 String site = request.getParameter("site");
                 String sDate = request.getParameter("beginDate");
                 String eDate = request.getParameter("endDate");
                 unitName = request.getParameter("unitName");
                 if (unitName.equals("") || unit.equals("All")) {
                 unitName = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
                 params.put("unit", unitName);
                 } else {
                 wbo = maintainableMgr.getOnSingleKey(unit);
                 params.put("unit", wbo.getAttribute("unitName"));
                 }
                 if (!site.equals("All")) {
                 String[] temp = new String[1];
                 temp[0] = site;
                 Vector siteTemp = projectMgr.getProjectsName(temp);
                 PDFsite = (String) siteTemp.get(0);
                 params.put("location", PDFsite);
                 } else {
                 params.put("location", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
                 }
                 if (!sup.equals("All")) {
                 wbo = supplierMgr.getOnSingleKey(sup);
                 params.put("sup", wbo.getAttribute("name"));
                 } else {
                 params.put("sup", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0631\u062F\u064A\u0646");
                 }
                 params.put("Sdate", sDate);
                 params.put("Edate", eDate);
                 try {
                 dataSet = externalJobReportMgr.genReport(unit, "key1", sup, "key2", site, "key3", Status, "key4", sDate, eDate);
                 } catch (Exception ex) {
                 Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                 }*/
                reportName = lang.equalsIgnoreCase("Ar") ? "ExternalReport01" : "ExternalReport01_En";
                Tools.createPdfReport(reportName, params, dataSet, getServletContext(), response, request);
                break;

            case 3:
                servedPage = "/docs/costing_report/costing_sample_report_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");
                issueTitle = request.getParameter("issueTitle");
                orderBy = request.getParameter("orderBy");

                params = new HashMap();
                params.put("bDate", beginDate);
                params.put("eDate", endDate);

                if (unitId.equals("")) {
                    String Name = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
                    params.put("unitName", Name);
                } else {
                    params.put("unitName", unitName);
                }

                if (issueTitle.equals("notEmergency")) {
                    String type = "\u0635\u064A\u0627\u0646\u0629 \u062F\u0648\u0631\u064A\u0629";
                    params.put("type", type);
                } else if (issueTitle.equals("Emergency")) {
                    String type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629";
                    params.put("type", type);
                } else {
                    String type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629 \u0648 \u062F\u0648\u0631\u064A\u0629";
                    params.put("type", type);
                }

                if (orderBy.equals("asc")) {
                    String order = "\u062A\u0635\u0627\u0639\u062F\u064A\u0627";
                    params.put("order", order);
                } else {
                    String order = "\u062A\u0646\u0627\u0632\u0644\u064A\u0627";
                    params.put("order", order);
                }

                wbo = new WebBusinessObject();
                wbo.setAttribute("beginDate", beginDate);
                wbo.setAttribute("endDate", endDate);
                wbo.setAttribute("issueTitle", issueTitle);
                wbo.setAttribute("orderBy", orderBy);

                if (unitId != null && !unitId.equals("")) {
                    wbo.setAttribute("unitId", unitId);
                }

                dataSet = issueByCostTasksMgr.getSampleReport(wbo);
                Tools.createPdfReport("CostReport", params, dataSet, getServletContext(), response, request);
                break;

            case 5:
                projectMgr = ProjectMgr.getInstance();
                params = new HashMap();
                siteAll = request.getParameter("siteAll");
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String sites = request.getParameter("sites");
                String ids = request.getParameter("ids").trim();
                String type = request.getParameter("type").trim();
                String[] arrIds = ids.split(" ");

                String[] arrTypeOfRate = type.split(" ");

                params.put("beginDate", beginDate);
                params.put("endDate", endDate);

                String typeOfRateStr = new String();
                Vector typeOfRateVec = getTypeOfRate(arrTypeOfRate);

                for (int i = 0; i < typeOfRateVec.size(); i++) {
                    if (i == 0) {
                        typeOfRateStr = (String) typeOfRateVec.get(i);
                    } else {
                        typeOfRateStr += " - " + (String) typeOfRateVec.get(i);
                    }
                }

                params.put("typeOfRateStr", typeOfRateStr);

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

                params.put("siteValue", siteValueStr);

                arrIds = ids.split(" ");

                arrTypeOfRate = type.split(" ");
                Vector equipmentsWithReading;

                String equipValueStr = new String();
                Vector equipValueVec;

                if (ids != null && !ids.equals("")) {
                    equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsWithReadingByIds(arrIds, arrTypeOfRate, beginDate, endDate);
//                    request.setAttribute("equipments", maintainableMgr.getUnitsName(arrIds));
                    equipValueVec = maintainableMgr.getUnitsName(arrIds);
                    for (int i = 0; i < equipValueVec.size(); i++) {
                        if (i == 0) {
                            equipValueStr = (String) equipValueVec.get(i);
                        } else if (i == equipValueVec.size() - 1) {
                            equipValueStr += " " + (String) equipValueVec.get(i);
                        } else {
                            equipValueStr += " - " + (String) equipValueVec.get(i);
                        }
                    }
                } else {
                    equipmentsWithReading = equipmentsWithReadingMgr.getEquipmentsWithReadingBySites(sites, arrTypeOfRate, beginDate, endDate);
                    equipValueStr = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
                }

                params.put("equipValueStr", equipValueStr);

                Vector objects = new Vector();
                Iterator it = equipmentsWithReading.iterator();
                String tempStr = new String();
                long timeByMilleSecond;
                Date dateOfLastReading;
                String strDateOfLastReading;
                int lastReading,
                 prevReading,
                 diffReading = 0,
                 temp;
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
                        temp = lastReading;
                        lastReading = prevReading;
                        prevReading = temp;
                    }

                    diffReading = lastReading - prevReading;
                    wbo.setAttribute("diffReading", Integer.toString(diffReading));

                    timeByMilleSecond = Long.valueOf((String) wbo.getAttribute("entryTime")).longValue();
                    dateOfLastReading = new Date(timeByMilleSecond);
                    strDateOfLastReading = dateOfLastReading.getDate() + "/" + (dateOfLastReading.getMonth() + 1) + "/" + (dateOfLastReading.getYear() + 1900);
                    wbo.setAttribute("dateOfLastReading", strDateOfLastReading);

                    objects.add(wbo);
                }

                // create and open PDF report in browser
                Tools.createPdfReport("equipmentsWithReadingsReport", params, objects, getServletContext(), response, request);
                break;

            case 6:
                reportName = "";
                params = new HashMap();
                projectMgr = ProjectMgr.getInstance();
                double totalJOCost = 0.0;
                double grandTotalJOCost = 0.0;

                long maintenanceDurationL = 0;
                long totalMaintenanceDurationL = 0;
                Vector allTempItems = new Vector();
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

                allMaintenanceInfo = new Vector();
                ItemsWithAvgPriceItemDataMgr itemsWithAvgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
                tasksByIssueMgr = TasksByIssueMgr.getInstance();
                String issueTitlee = request.getParameter("issueTitle");
                params.put("C1", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E" : "From Date"));
                params.put("C2", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E" : "To Date"));

                if (issueTitlee.equals("notEmergency")) {
                    issueTitleEnum = IssueTitle.NotEmergency;
                    params.put("title", (lang.equalsIgnoreCase("Ar") ? "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629" : "Average Cost for Classified Job Orders"));
                } else if (issueTitlee.equals("Emergency")) {
                    issueTitleEnum = IssueTitle.Emergency;
                    params.put("title", (lang.equalsIgnoreCase("Ar") ? "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629" : "Average Cost for Regular Job Orders"));
                } else {
                    issueTitleEnum = IssueTitle.Both;
                    params.put("title", (lang.equalsIgnoreCase("Ar") ? "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0648 \u0627\u0644\u0639\u0627\u062F\u064A\u0629" : "Average Cost for Regular & Classified Job Orders"));
                }

                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");
                taskId = request.getParameter("taskId");
                taskName = request.getParameter("taskName");
                itemId = request.getParameter("partId");
                itemName = request.getParameter("partName");
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                trade = request.getParameterValues("trade");
                tradeAll = request.getParameter("tradeAll");
                brandAll = request.getParameter("brandAll");
                siteAll = request.getParameter("siteAll");
                laborDetail = request.getParameter("laborDetail");
                if (laborDetail == null) {
                    laborDetail = "off";
                }
                mainTypeAll = request.getParameter("mainTypeAll");

                site_ = request.getParameterValues("site");
                mainType = request.getParameterValues("mainType");
                brand = request.getParameterValues("brand");

                orderType = request.getParameter("orderType");
                dateType = request.getParameter("dateType");
                date_order = dateType + " " + orderType;

                // set wbo To pass to Method to search
                wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", beginDate);
                wboCritaria.setAttribute("endDate", endDate);
                wboCritaria.setAttribute("trade", trade);
                wboCritaria.setAttribute("date_order", date_order);

                if (taskId != null && !taskId.equals("")) {
                    wboCritaria.setAttribute("taskId", taskId);
                }
                if (itemId != null && !itemId.equals("")) {
                    wboCritaria.setAttribute("itemId", itemId);
                }

                if (unitId != null && !unitId.equals("")) {
                    wboCritaria.setAttribute("unitId", unitId);

                    wboCritaria.setAttribute("site", site_);
                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria, issueTitleEnum);

                    params.put("unitNamesStr", unitName);
                    params.put("EQUIPMENT_TYPE", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment"));

                } else if (brand != null) {
                    wboCritaria.setAttribute("site", site_);
                    wboCritaria.setAttribute("brand", brand);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteBrand(wboCritaria, issueTitleEnum);

                    if (!brandAll.equals("yes")) {
                        String s = "";
                        Vector tempVec = parentUnitMgr.getParensName(brand);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();
                        }
                        if (tempVec.size() > 1) {
                            s += " , ...";
                        }
                        params.put("unitNamesStr", s);
                    } else {
                        params.put("unitNamesStr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A" : "All Models"));
                    }
                    params.put("EQUIPMENT_TYPE", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0627\u0631\u0643\u0629" : "Model"));
                } else {
                    wboCritaria.setAttribute("site", site_);
                    wboCritaria.setAttribute("mainType", mainType);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria, issueTitleEnum);

                    if (!mainTypeAll.equals("yes")) {
                        String s = "";
                        Vector tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();
                        }
                        if (tempVec.size() > 1) {
                            s += " , ...";
                        }
                        params.put("unitNamesStr", s);
                    } else {
                        params.put("unitNamesStr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629" : "All Main Types"));
                    }
                    params.put("EQUIPMENT_TYPE", (lang.equalsIgnoreCase("Ar") ? "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u0649" : "Main Type"));
                }

                actualEndDate = null;
                branchProject = new WebBusinessObject();
                mainProject = new WebBusinessObject();
                //ConfigFileMgr configFileMgr = new ConfigFileMgr();
                if (laborDetail.equals("on")) {
                    allMaintenanceInfoCopy = new Vector();
                    totalItemsCost = 0.0;
                    laborCost = 0;
                    grandTotalJOCost = 0;

                    basicMgr = EmpBasicMgr.getInstance();
                    costCentersMgr = CostCentersMgr.getInstance();

                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {

                        branchProject = null;
                        mainProject = null;

                        totalJOCost = 0.0;
                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                        issueId = (String) wbo.getAttribute("issueId");
                        WebBusinessObject issueWbo = new WebBusinessObject();
                        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);
                        allItems = new Vector();
                        allTempItems = new Vector();
                        allTask = new Vector();

                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
                        allTask = tasksByIssueMgr.getTask(issueId);

                        WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unitId"));
                        try {
                            if (!getMainInfo.getAttribute("empID").equals("")) {
                                String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                                wbo.setAttribute("empName", empName);
                            } else {
                                wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            }
                        } catch (Exception exc) {
                            wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                        try {
                            if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                                String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                                if (costName.equals("***")) {
                                    wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                                } else {
                                    wbo.setAttribute("costName", costName);
                                }
                            } else {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            }
                        } catch (Exception exc) {
                            wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }

                        branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site").toString());
                        if (!branchProject.getAttribute("mainProjId").equals("0")) {
                            mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                            wbo.setAttribute("mainSite", (String) mainProject.getAttribute("projectName"));
                        }

                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);

                        issueStatus = (String) wbo.getAttribute("currentStatus");

                        String issueStatusLabel = "";
                        try {
                            if (issueStatus.equals("Assigned")) {
                                issueStatusLabel = JOAssignedStatus;
                                tempStatus = " - " + JOOpenStatus;
                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));

                                maintenanceDurationL = new Date().getTime() - actualBeginDate.getTime();
                                totalMaintenanceDurationL += maintenanceDurationL;
                                maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);
                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");

                            } else if (issueStatus.equals("Canceled")) {
                                issueStatusLabel = JOCanceledStatus;
                                tempStatus = " - " + JOCancelStatus;
                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                                maintenanceDurationL = currentStatusSinceDate.getTime() - actualEndDate.getTime();
                                totalMaintenanceDurationL += maintenanceDurationL;
                                maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);
                                JODate = currentStatusSince;

                            } else {
                                issueStatusLabel = JOFinishedStatus;
                                tempStatusBegin = " - " + JOOpenStatus;
                                tempStatusEnd = " - " + JOCloseStatus;
                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));

                                maintenanceDurationL = actualEndDate.getTime() - actualBeginDate.getTime();
                                totalMaintenanceDurationL += maintenanceDurationL;
                                maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);
                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");

                            }

                        } catch (NullPointerException ex) {
                            maintenanceDuration = lang.equalsIgnoreCase("Ar") ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : "Unavailable";
                            JODate = lang.equalsIgnoreCase("Ar") ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : "Unavailable";
                        }

                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                            typeOfSchedule = JOEmrgencyStatus;// configFileMgr.getJobOrderType("Emergency");
                        } else {
                            temp1 = (String) wbo.getAttribute("issueTitle");
                            typeOfSchedule = (lang.equalsIgnoreCase("Ar") ? "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " : "Based on table ") + temp1;
                        }

                        wbo.setAttribute("issueStatus", issueStatusLabel/*configFileMgr.getJobOrderTypeByCurrentLanguage(issueStatus)*/);
                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                        wbo.setAttribute("currentStatusSince", currentStatusSince);

                        wbo.setAttribute("maintenanceDuration", maintenanceDuration);
                        wbo.setAttribute("maintenanceDurationL", maintenanceDurationL);

                        allLabor = new Vector();
                        try {
                            allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                        totalItemsCost = 0.0;
                        Double unitPrice = 0.0;
                        for (int j = 0; j < allItems.size(); j++) {
                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
                            try {
                                itemName = tempItem.getAttribute("itemDesc").toString();
                                unitPrice = itemsWithAvgPriceMgr.getUnitPriceByTransAndBanch(tempItem.getAttribute("itemId").toString(), issueWbo);
                            } catch (Exception e) {
                                itemName = "Item Name Not Supported";
                                unitPrice = 0.0;
                            }
                            tempItem.setAttribute("itemDesc", itemName);
                            tempItem.setAttribute("price", unitPrice);
                            try {
                                if (tempItem.getAttribute("total") != null && !tempItem.getAttribute("total").equals("")) {
                                    totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
                                } else {
                                    totalItemsCost += 0.0;
                                }
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

                } else {
                    totalItemsCost = 0.0;
                    laborCost = 0;
                    int index = 0;
                    allMaintenanceInfoCopy = new Vector();
                    basicMgr = EmpBasicMgr.getInstance();
                    costCentersMgr = CostCentersMgr.getInstance();
                    for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                        branchProject = null;
                        mainProject = null;
                        totalJOCost = 0;
                        wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                        issueId = (String) wbo.getAttribute("issueId");
                        WebBusinessObject issueWbo = new WebBusinessObject();
                        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);
                        allItems = new Vector();
                        allTempItems = new Vector();
                        allTask = new Vector();

                        // allItems = itemsWithAvgPriceItemDataMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
                        allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
                        allTask = tasksByIssueMgr.getTask(issueId);

                        WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unitId"));
                        try {
                            if (!getMainInfo.getAttribute("empID").equals("")) {
                                String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                                wbo.setAttribute("empName", empName);
                            } else {
                                wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            }
                        } catch (Exception exc) {
                            wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }

                        try {
                            if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                                String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                                if (costName.equals("***")) {
                                    wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                                } else {
                                    wbo.setAttribute("costName", costName);
                                }
                            } else {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            }
                        } catch (Exception exc) {
                            wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }

                        laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);
                        branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site").toString());
                        if (!branchProject.getAttribute("mainProjId").equals("0")) {
                            mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                            wbo.setAttribute("mainSite", (String) mainProject.getAttribute("projectName"));
                        }
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

                                maintenanceDurationL = new Date().getTime() - actualBeginDate.getTime();
                                totalMaintenanceDurationL += maintenanceDurationL;
                                maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);
                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate");

                            } else if (issueStatus.equals("Canceled")) {
                                issueStatusLabel = JOCanceledStatus;
                                tempStatus = " - " + JOCancelStatus;
                                currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                                maintenanceDurationL = currentStatusSinceDate.getTime() - actualEndDate.getTime();
                                totalMaintenanceDurationL += maintenanceDurationL;
                                maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);
                                JODate = currentStatusSince;

                            } else {
                                issueStatusLabel = JOFinishedStatus;
                                tempStatusBegin = " - " + JOOpenStatus;
                                tempStatusEnd = " - " + JOCloseStatus;
                                currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;

                                actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));

                                maintenanceDurationL = actualEndDate.getTime() - actualBeginDate.getTime();
                                totalMaintenanceDurationL += maintenanceDurationL;
                                maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);
                                JODate = "O " + (String) wbo.getAttribute("ActualBeginDate")
                                        + "\nC " + (String) wbo.getAttribute("ActualEndDate");

                            }
                        } catch (NullPointerException ex) {
                            maintenanceDuration = lang.equalsIgnoreCase("Ar") ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : "Unavailable";
                            JODate = lang.equalsIgnoreCase("Ar") ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : "Unavailable";
                        }

                        if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                            typeOfSchedule = JOEmrgencyStatus; //configFileMgr.getJobOrderType("Emergency");
                        } else {
                            temp1 = (String) wbo.getAttribute("issueTitle");
                            typeOfSchedule = (lang.equalsIgnoreCase("Ar") ? "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " : "Based on table ") + temp1;
                        }

                        wbo.setAttribute("issueStatus", issueStatusLabel/*configFileMgr.getJobOrderTypeByCurrentLanguage(issueStatus)*/);
                        wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                        wbo.setAttribute("currentStatusSince", currentStatusSince);
                        wbo.setAttribute("maintenanceDuration", maintenanceDuration);
                        wbo.setAttribute("maintenanceDurationL", maintenanceDurationL);
                        wbo.setAttribute("JODate", JODate);

                        totalItemsCost = 0;
                        Double unitPrice = 0.0;
                        for (int j = 0; j < allItems.size(); j++) {
                            WebBusinessObject tempItem = (WebBusinessObject) allItems.get(j);
                            try {
                                itemName = tempItem.getAttribute("itemDesc").toString();
                                unitPrice = itemsWithAvgPriceMgr.getUnitPriceByTransAndBanch(tempItem.getAttribute("itemId").toString(), issueWbo);
                            } catch (Exception e) {
                                itemName = "Item Name Not Supported";
                                unitPrice = 0.0;
                            }
                            tempItem.setAttribute("itemDesc", itemName);
                            tempItem.setAttribute("price", unitPrice);
                            try {
                                if (tempItem.getAttribute("total") != null && !tempItem.getAttribute("total").equals("")) {
                                    totalItemsCost += Double.parseDouble((String) tempItem.getAttribute("total"));
                                } else {
                                    totalItemsCost += 0.0;
                                }
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

                    reportName = lang.equalsIgnoreCase("Ar") ? "SJOAvgCost" : "SJOAvgCost_En";
                }

                request.setAttribute("unitName", unitName);
                request.setAttribute("taskName", taskName);
                request.setAttribute("itemName", itemName);

                request.setAttribute("tradeAll", tradeAll);
                request.setAttribute("mainTypeAll", mainTypeAll);
                request.setAttribute("siteAll", siteAll);

                params.put("beginDate", beginDate);
                params.put("endDate", endDate);
                params.put("grandTotalJOCost", grandTotalJOCost);
                params.put("totalMaintenanceDurationL", totalMaintenanceDurationL);

                if (!siteAll.equals("yes")) {
                    String s = projectMgr.getProjectsName(site_).get(0).toString();
                    if (projectMgr.getProjectsName(site_).size() > 1) {
                        s += " , ...";
                    }
                    params.put("siteStrArr", s);
                } else {
                    params.put("siteStrArr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639" : "All Sites"));
                }

                if (!tradeAll.equals("yes")) {
                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
                } else {
                    params.put("tradeStr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629" : "All Maintenance Types"));
                }

                Tools.createPdfReport(reportName, params, allMaintenanceInfoCopy, getServletContext(), response, request);
                break;

            case 7:
                from = request.getParameter("from");
                to = request.getParameter("to");
                allMaintenanceInfo = new Vector();
                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
                itemsWithAvgPriceMgr = ItemsWithAvgPriceMgr.getInstance();
                tasksByIssueMgr = TasksByIssueMgr.getInstance();
                //configFileMgr = new ConfigFileMgr();
                actualBeginDate = null;
                actualEndDate = null;
                currentStatusSince = "";

                totalJOCost = 0.0;
                grandTotalJOCost = 0.0;

                params = new HashMap();
                params.put("title", (lang.equalsIgnoreCase("Ar") ? "\u062A\u0643\u0644\u0641\u0629 \u0645\u062A\u0648\u0633\u0637\u0629 \u0644\u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644" : "Average Cost of Job Orders"));
                params.put("C1", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0646 \u0631\u0642\u0645" : "From"));
                params.put("C2", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0649 \u0631\u0642\u0645" : "To"));
                params.put("beginDate", from);
                params.put("endDate", to);
                params.put("tradeStr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629" : "All Maintenance Types"));
                params.put("unitNamesStr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629" : "All Main Types"));
                params.put("siteStrArr", (lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639" : "All Sites"));
                params.put("EQUIPMENT_TYPE", (lang.equalsIgnoreCase("Ar") ? "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u064A" : "Main Type"));
                params.put("maintNumReport", "yes");

                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByMaintNum(from, to);
                branchProject = new WebBusinessObject();
                mainProject = new WebBusinessObject();
                basicMgr = EmpBasicMgr.getInstance();
                costCentersMgr = CostCentersMgr.getInstance();

                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    branchProject = null;
                    mainProject = null;
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    allItems = new Vector();
                    allTask = new Vector();

                    laborCost = empTasksHoursMgr.getTolalCostLabor(issueId);

                    allItems = itemsWithAvgPriceMgr.getItemsWithAvgPrice((String) wbo.getAttribute("unitSchedualeId"));
                    allTask = tasksByIssueMgr.getTask(issueId);

                    WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unitId"));
                    try {
                        if (!getMainInfo.getAttribute("empID").equals("")) {
                            String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                            wbo.setAttribute("empName", empName);

                        } else {
                            wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));

                    }

                    try {
                        if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                            String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                            if (costName.equals("***")) {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            } else {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            }
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));

                    }

                    totalItemsCost = 0;
                    branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site").toString());
                    if (!branchProject.getAttribute("mainProjId").equals("0")) {
                        mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                        wbo.setAttribute("mainSite", (String) mainProject.getAttribute("projectName"));
                    }
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
                        JODate = lang.equalsIgnoreCase("Ar") ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : "None";
                    }

                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                        typeOfSchedule = JOEmrgencyStatus; //configFileMgr.getJobOrderType("Emergency");
                    } else {
                        temp1 = (String) wbo.getAttribute("issueTitle");
                        typeOfSchedule = (lang.equalsIgnoreCase("Ar") ? "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " : "Based on table ") + temp1;
                    }

                    /*if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                     typeOfSchedule = configFileMgr.getJobOrderType("Emergency");
                     } else {
                     temp1 = (String) wbo.getAttribute("issueTitle");
                     typeOfSchedule = "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644 " + temp1;
                     }*/
                    wbo.setAttribute("issueStatus", issueStatusLabel/*configFileMgr.getJobOrderTypeByCurrentLanguage(issueStatus)*/);
                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                    wbo.setAttribute("currentStatusSince", currentStatusSince);
                    wbo.setAttribute("laborCost", laborCost);
                    wbo.setAttribute("totalItemCost", totalItemsCost);
                    wbo.setAttribute("items", allItems);
                    wbo.setAttribute("tasks", allTask);
                    wbo.setAttribute("parentName", parentName);
                    wbo.setAttribute("maintenanceDuration", Tools.formatDuration(maintenanceDuration));
                    wbo.setAttribute("JODate", JODate);
                    wbo.setAttribute("totalJOCost", totalItemsCost + laborCost);

                    grandTotalJOCost += (totalItemsCost + laborCost);

                }

                params.put("grandTotalJOCost", grandTotalJOCost);
                Tools.createPdfReport((lang.equalsIgnoreCase("Ar") ? "SJOAvgCost" : "SJOAvgCost_En"), params, allMaintenanceInfo, getServletContext(), response, request);
                break;

            case 8:
                from = request.getParameter("from");
                to = request.getParameter("to");
                allMaintenanceInfo = new Vector();
                allMaintenanceInfo = allMaintenanceInfoMgr.getDetailsMaintenanceByMaintNum(from, to);

                currentStatusSinceDate = null;
                actualBeginDate = null;
                actualEndDate = null;

                //configFileMgr = new ConfigFileMgr();
                branchProject = new WebBusinessObject();
                mainProject = new WebBusinessObject();
                basicMgr = EmpBasicMgr.getInstance();
                costCentersMgr = CostCentersMgr.getInstance();
                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    branchProject = null;
                    mainProject = null;
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

                    WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unitId"));

                    try {
                        if (!getMainInfo.getAttribute("empID").equals("")) {
                            String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                            wbo.setAttribute("empName", empName);

                        } else {
                            wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("empName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                    }
                    try {
                        if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                            String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                            if (costName.equals("***")) {
                                wbo.setAttribute("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                            } else {
                                wbo.setAttribute("costName", costName);
                            }
                        } else {
                            wbo.setAttribute("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                    }
                    try {
                        if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                            String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                            if (costName.equals("***")) {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            } else {
                                wbo.setAttribute("costName", costName);
                            }
                        } else {
                            wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));

                        }

                    } catch (Exception exc) {
                        wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                    }

                    branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site").toString());
                    if (!branchProject.getAttribute("mainProjId").equals("0")) {
                        mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                        wbo.setAttribute("mainSite", (String) mainProject.getAttribute("projectName"));
                    }
                    wbo.setAttribute("parentName", parentName);

                    issueStatus = (String) wbo.getAttribute("currentStatus");
                    String issueStatusLabel = "";
                    if (issueStatus.equals("Assigned")) {
                        issueStatusLabel = JOAssignedStatus;
                        tempStatus = " - " + JOOpenStatus;
                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));

                        maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);

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
                        typeOfSchedule = (lang.equalsIgnoreCase("Ar") ? "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644" : "Based on Table") + temp1;
                    }

                    wbo.setAttribute("issueStatus", issueStatusLabel/*configFileMgr.getJobOrderTypeByCurrentLanguage(issueStatus)*/);
                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                    wbo.setAttribute("currentStatusSince", currentStatusSince);
                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);

                }

                params = new HashMap();
                params.put("REPORT_TYPE", "fromTo");
                params.put("FROM", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E" : "From Date"));
                params.put("TO", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E" : "To Date"));
                params.put("beginDate", from);
                params.put("endDate", to);

                params.put("equipment", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0639\u062F\u0629" : "Equipment"));
                params.put("model", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0627\u0631\u0643\u062A\u0647\u0627" : "Model"));
                params.put("at", (lang.equalsIgnoreCase("Ar") ? "\u0641\u0649" : "at"));
                params.put("mainSiteStr", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0648\u0642\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u0649" : "Main Site"));

                // create and open PDF report in browser
                ServletContext context = getServletConfig().getServletContext();
                reportName = lang.equalsIgnoreCase("Ar") ? "DetailedMaintenance" : "DetailedMaintenance_En";
                Tools.createPdfReport(reportName, params, allMaintenanceInfo, context, response, request);
                break;

            case 9:
                servedPage = "/docs/costing_report/costing_avgCost_report_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");
                issueTitle = request.getParameter("issueTitle");
                orderBy = request.getParameter("orderBy");

                params = new HashMap();
                params.put("bDate", beginDate);
                params.put("eDate", endDate);

                if (unitId.equals("")) {
                    String Name = "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A";
                    params.put("unitName", Name);
                } else {
                    params.put("unitName", unitName);
                }

                if (issueTitle.equals("notEmergency")) {
                    type = "\u0635\u064A\u0627\u0646\u0629 \u062F\u0648\u0631\u064A\u0629";
                    params.put("type", type);
                } else if (issueTitle.equals("Emergency")) {
                    type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629";
                    params.put("type", type);
                } else {
                    type = "\u0635\u064A\u0627\u0646\u0629 \u0637\u0627\u0631\u0626\u0629 \u0648 \u062F\u0648\u0631\u064A\u0629";
                    params.put("type", type);
                }

                if (orderBy.equals("asc")) {
                    String order = "\u062A\u0635\u0627\u0639\u062F\u064A\u0627";
                    params.put("order", order);
                } else {
                    String order = "\u062A\u0646\u0627\u0632\u0644\u064A\u0627";
                    params.put("order", order);
                }
                dataSet = new Vector();

                wbo = new WebBusinessObject();
                wbo.setAttribute("beginDate", beginDate);
                wbo.setAttribute("endDate", endDate);
                wbo.setAttribute("issueTitle", issueTitle);
                wbo.setAttribute("orderBy", orderBy);

                if (unitId != null && !unitId.equals("")) {
                    wbo.setAttribute("unitId", unitId);
                }

                dataSet = issueByCostTasksMgr.getSampleFullReport(wbo);
                Tools.createPdfReport("CostReport", params, dataSet, getServletContext(), response, request);
                break;

            case 11:
                projectMgr = ProjectMgr.getInstance();
                params = new HashMap();
                allMaintenanceInfo = new Vector();
                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
                tasksByIssueMgr = TasksByIssueMgr.getInstance();
                issueTitle = request.getParameter("issueTitle");
                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");

                if (issueTitle != null && issueTitle.equals("Emergency")) {
                    issueTitleEnum = IssueTitle.Emergency;
                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
                } else {
                    issueTitleEnum = IssueTitle.NotEmergency;
                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0645\u062C\u062F\u0648\u0644\u0629 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
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

                trade = request.getParameterValues("trade");
                site_ = request.getParameterValues("site");
                mainType = request.getParameterValues("mainType");

                orderType = request.getParameter("orderType");
                dateType = request.getParameter("dateType");
                date_order = dateType + " " + orderType;

                // set wbo To pass to Method to search
                wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", beginDate);
                wboCritaria.setAttribute("endDate", endDate);
                wboCritaria.setAttribute("trade", trade);
                wboCritaria.setAttribute("date_order", date_order);
                wboCritaria.setAttribute("site", site_);

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

                    wboCritaria.setAttribute("mainType", mainType);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria, issueTitleEnum);
                }

                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    allLabor = new Vector();
                    allTask = new Vector();

                    try {
                        allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    allTask = tasksByIssueMgr.getTask(issueId);

                    wbo.setAttribute("allLabor", allLabor);
                    wbo.setAttribute("tasks", allTask);

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);

                    wbo.setAttribute("parentName", parentName);
                }

                request.setAttribute("unitName", unitName);
                request.setAttribute("taskName", taskName);
                request.setAttribute("itemName", itemName);

                request.setAttribute("tradeAll", tradeAll);
                request.setAttribute("mainTypeAll", mainTypeAll);
                request.setAttribute("siteAll", siteAll);
                params.put("beginDate", beginDate);
                params.put("endDate", endDate);
                if (!siteAll.equals("yes")) {
                    String s = projectMgr.getProjectsName(site_).get(0).toString();
                    if (projectMgr.getProjectsName(site_).size() > 1) {
                        s += " , ...";
                    }
                    params.put("siteStrArr", s);
                } else {
                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
                }
                if (!mainTypeAll.equals("yes")) {
                    String s = "";

                    if (mainType != null) {
                        s = mainCategoryTypeMgr.getMainTypeName(mainType).get(0).toString();
                        if (mainCategoryTypeMgr.getMainTypeName(mainType).size() > 1) {
                            s += " , ...";
                        }
                    } else {
                        s = maintainableMgr.getUnitName(unitId);
                    }
                    params.put("unitNamesStr", s);
                } else {
                    params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
                }
                if (!tradeAll.equals("yes")) {
                    params.put("tradeStr", tradeMgr.getTradesByIds(trade).get(0).toString());
                } else {
                    params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
                }

                Tools.createPdfReport("CostingJobOrdersWithLabor", params, allMaintenanceInfo, getServletContext(), response, request);
                break;

            case 12:
                from = request.getParameter("from");
                to = request.getParameter("to");

                params = new HashMap();
                allMaintenanceInfo = new Vector();
                allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
                tasksByIssueMgr = TasksByIssueMgr.getInstance();

                params.put("C1", "\u0645\u0646 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
                params.put("C2", "\u0627\u0644\u0649 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629");
                params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
                params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
                params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
                params.put("beginDate", from);
                params.put("endDate", to);
                params.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");

                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByMaintNum(from, to);

                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    allLabor = new Vector();
                    allTask = new Vector();

                    try {
                        allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    allTask = tasksByIssueMgr.getTask(issueId);

                    wbo.setAttribute("allLabor", allLabor);
                    wbo.setAttribute("tasks", allTask);

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);

                    wbo.setAttribute("parentName", parentName);
                }

                Tools.createPdfReport("CostingJobOrdersWithLabor", params, allMaintenanceInfo, getServletContext(), response, request);
                break;

            case 13:
                ArrayList allTrade = new ArrayList();
                Vector brandsVec = new Vector();
                ArrayList allMainType = new ArrayList();
                ArrayList brands = new ArrayList();
                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                maintainableMgr = MaintainableMgr.getInstance();
                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                    brandsVec = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                wbo = new WebBusinessObject();
                for (int i = 0; i < brandsVec.size(); i++) {
                    wbo = (WebBusinessObject) brandsVec.get(i);
                    //if(!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0"))
                    brands.add(wbo);
                }
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();
                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", projects);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("brands", brands);
                servedPage = "/docs/costing_report/maintenance_operations_analysis_report_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 14:
                wbo = new WebBusinessObject();
                params = new HashMap();
                status = request.getParameterValues("issueStatus");
                site_ = request.getParameterValues("site");
                trade = request.getParameterValues("trade");
                String reportType = request.getParameter("reportType");
                mainTypeAll = request.getParameter("mainTypeAll");
                siteAll = request.getParameter("siteAll");
                brandAll = request.getParameter("brandAll");
                tradeAll = request.getParameter("tradeAll");
                try {
                    mainType = request.getParameterValues("mainType");
                    wbo.setAttribute("mainTaypeValues", mainType);
                    if (!mainTypeAll.equals("yes")) {
                        String s = mainCategoryTypeMgr.getMainTypeName(mainType).get(0).toString();
                        if (mainCategoryTypeMgr.getMainTypeName(mainType).size() > 1) {
                            s += " , ...";
                        }
                        params.put("mainType", s);
                    } else {
                        params.put("mainType", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
                    }
                } catch (NullPointerException ex) {
                    params.put("mainType", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
                }
                if (!siteAll.equals("yes")) {
                    String s = projectMgr.getProjectsName(site_).get(0).toString();
                    if (projectMgr.getProjectsName(site_).size() > 1) {
                        s += " , ...";
                    }
                    params.put("sites", s);
                } else {
                    params.put("sites", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
                }
                try {
                    unitId = request.getParameter("unitId");
                    unitName = request.getParameter("unitName");
                    wbo.setAttribute("unitId", unitId);
                    params.put("unitName", Tools.getRealChar(unitName));
                } catch (NullPointerException ex) {
                    params.put("unitName", "\u0643\u0644 \u0627\u0644\u0645\u0639\u062F\u0627\u062A");
                }
                try {
                    brand = request.getParameterValues("brand");
                    wbo.setAttribute("brand", brand);
                    if (!brandAll.equals("yes")) {
                        String s = maintainableMgr.getBrandName(brand).get(0).toString();
                        if (maintainableMgr.getBrandName(brand).size() > 1) {
                            s += " , ...";
                        }
                        params.put("brand", s);
                    }
                } catch (NullPointerException ex) {
                    params.put("brand", "\u0643\u0644 \u0627\u0644\u0645\u0631\u0643\u0627\u062A");
                }
                if (!tradeAll.equals("yes")) {
                    params.put("trade", tradeMgr.getTradesByIds(trade).get(0).toString());
                } else {
                    params.put("trade", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
                }
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                wbo.setAttribute("issueTitle", request.getParameter("issueTitle"));
                wbo.setAttribute("issueStatus", status);
                wbo.setAttribute("sitesValues", site_);
                wbo.setAttribute("tradeValues", trade);
                wbo.setAttribute("beginDate", beginDate);
                wbo.setAttribute("endDate", endDate);
                params.put("status", Tools.arrayToString(status, " - "));
                if (request.getParameter("issueTitle").equalsIgnoreCase("both")) {
                    params.put("issueTitle", "\u062F\u0648\u0631\u064A\u0629 \u0648\u0637\u0627\u0631\u0626\u0629");
                } else if (request.getParameter("issueTitle").equalsIgnoreCase("Emergency")) {
                    params.put("issueTitle", "\u0637\u0627\u0631\u0626\u0629");
                } else {
                    params.put("issueTitle", "\u062F\u0648\u0631\u064A\u0629");
                }
                Vector allAnalysisInfo = new Vector();
                if (reportType.equals("Totaly")) {
                    allAnalysisInfo = taskMgr.maintenanceOperationAnalysisTotaly(wbo);
                    reportType = "maintenanceOperationsAnalysisReportTotaly";
                } else if (reportType.equals("Detailed")) {
                    allAnalysisInfo = taskMgr.maintenanceOperationAnalysisDetailed(wbo);
                    reportType = "maintenanceOperationsAnalysisReportDetailed";
                } else {
                    allAnalysisInfo = taskMgr.maintenanceOperationAnalysisAnalyised(wbo);
                    reportType = "maintenanceOperationsAnalysisReportAnalyised";
                }
                params.put("beginDate", beginDate);
                params.put("endDate", endDate);
                Tools.createPdfReport(reportType, params, allAnalysisInfo, getServletContext(), response, request);
                break;

            case 15:
                reportType = request.getParameter("reportType");
                String reportData = request.getParameter("reportData");
                String[] departmentValues;
                String[] productionLines;
                Vector data = new Vector();
                wbo = new WebBusinessObject();
                HashMap reportParams = new HashMap();

                unitName = request.getParameter("unitName");
                brandAll = request.getParameter("brandAll");
                mainTypeAll = request.getParameter("mainTypeAll");
                siteAll = request.getParameter("siteAll");
                site_ = request.getParameterValues("site");

                if (!siteAll.equals("yes")) {
                    String s = projectMgr.getProjectsName(site_).get(0).toString();
                    if (projectMgr.getProjectsName(site_).size() > 1) {
                        s += " , ...";
                    }
                    reportParams.put("siteStrArr", s);
                } else {
                    reportParams.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
                }

                wbo.setAttribute("site", site_);
                wbo.setAttribute("beginDate", request.getParameter("beginDate"));
                wbo.setAttribute("endDate", request.getParameter("endDate"));
                reportParams.put("bDate", request.getParameter("beginDate"));
                reportParams.put("eDate", request.getParameter("endDate"));
                wbo.setAttribute("reportType", reportType);
                try {
                    if (reportData == null) {
                        if (reportType.equals("mainTypeRadio")) {
                            mainType = request.getParameterValues("mainType");
                            wbo.setAttribute("mainType", mainType);
                            reportParams.put("type", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0646\u0648\u0639" : "Type"));

                            if (!mainTypeAll.equals("yes")) {
                                String s = "";
                                Vector tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
                                if (tempVec != null && !tempVec.isEmpty()) {
                                    s = tempVec.get(0).toString();
                                }
                                if (tempVec.size() > 1) {
                                    s += " , ...";
                                }
                                reportParams.put("unitNamesStr", s);
                            } else {
                                reportParams.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
                            }

                        } else if (reportType.equals("brandRadio")) {
                            brand = request.getParameterValues("brand");
                            wbo.setAttribute("brand", brand);
                            reportParams.put("type", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0627\u0631\u0643\u0629" : "Model"));

                            if (!brandAll.equals("yes")) {
                                String s = "";
                                Vector tempVec = parentUnitMgr.getParensName(brand);
                                if (tempVec != null && !tempVec.isEmpty()) {
                                    s = tempVec.get(0).toString();
                                }
                                if (tempVec.size() > 1) {
                                    s += " , ...";
                                }
                                reportParams.put("unitNamesStr", s);
                            } else {
                                reportParams.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A");
                            }

                        } else if (reportType.equals("unit")) {
                            unitId = request.getParameter("unitId");
                            basicMgr = EmpBasicMgr.getInstance();
                            costCentersMgr = CostCentersMgr.getInstance();
                            WebBusinessObject getEqpInfo = maintainableMgr.getOnSingleKey(unitId);
                            WebBusinessObject getSiteInfo = projectMgr.getOnSingleKey((String) getEqpInfo.getAttribute("site"));
                            WebBusinessObject getMainSiteInfo = new WebBusinessObject();
                            if (!getSiteInfo.getAttribute("mainProjId").equals("0")) {
                                getMainSiteInfo = projectMgr.getOnSingleKey((String) getSiteInfo.getAttribute("mainProjId"));
                                reportParams.put("mainSite", getMainSiteInfo.getAttribute("projectName"));
                                reportParams.put("branchSite", getSiteInfo.getAttribute("projectName"));
                            }

                            try {
                                if (!getEqpInfo.getAttribute("empID").equals("") && !getEqpInfo.getAttribute("empID").equals("0")) {
                                    String empName = basicMgr.getEmployeeName((String) getEqpInfo.getAttribute("empID"));
                                    reportParams.put("empName", empName);

                                } else {
                                    reportParams.put("empName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                                }
                            } catch (Exception exc) {
                                reportParams.put("empName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                            }
                            try {
                                if (!getEqpInfo.getAttribute("productionLine").equals("") && !getEqpInfo.getAttribute("productionLine").equals("0")) {
                                    String costName = costCentersMgr.getCostCenterNameByCode((String) getEqpInfo.getAttribute("productionLine"), "Ar");
                                    if (costName.equals("***")) {
                                        reportParams.put("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                                    } else {
                                        reportParams.put("costName", costName);
                                    }
                                } else {
                                    reportParams.put("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                                }
                            } catch (Exception exc) {
                                reportParams.put("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                            }

                            if (getEqpInfo.getAttribute("site").equals("0")) {
                                wbo.setAttribute("unitId", unitId);
                            }
                            reportParams.put("type", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment"));
                            reportParams.put("unitNamesStr", unitName);

                        }
                        data = allMaintenanceInfoMgr.getCostingReports(wbo);
                        Tools.createPdfReport("mainTypesAVGCostReport", reportParams, data, getServletContext(), response, request);

                    } else {

                        String sub = request.getParameter("with");
                        if (reportType.equals("mainTypeRadio")) {
                            mainType = request.getParameterValues("mainType");
                            wbo.setAttribute("mainType", mainType);
                            reportParams.put("type", (lang.equalsIgnoreCase("Ar") ? "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u064A" : "Main Type"));

                            if (!mainTypeAll.equals("yes")) {
                                String s = "";
                                Vector tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
                                if (tempVec != null && !tempVec.isEmpty()) {
                                    s = tempVec.get(0).toString();
                                }
                                if (tempVec.size() > 1) {
                                    s += " , ...";
                                }
                                reportParams.put("unitNamesStr", s);
                            } else {
                                reportParams.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
                            }

                        } else if (reportType.equals("brandRadio")) {
                            brand = request.getParameterValues("brand");
                            wbo.setAttribute("brand", brand);
                            reportParams.put("type", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0627\u0631\u0643\u0629" : "Model"));

                            if (!brandAll.equals("yes")) {
                                String s = "";
                                Vector tempVec = parentUnitMgr.getParensName(brand);
                                if (tempVec != null && !tempVec.isEmpty()) {
                                    s = tempVec.get(0).toString();
                                }
                                if (tempVec.size() > 1) {
                                    s += " , ...";
                                }
                                reportParams.put("unitNamesStr", s);
                            } else {
                                reportParams.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A");
                            }

                        } else if (reportType.equals("unit")) {
                            unitId = request.getParameter("unitId");
                            wbo.setAttribute("unitId", unitId);
                            reportParams.put("type", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment"));
                            reportParams.put("unitNamesStr", unitName);
                        }

                        if (sub.equals("units")) {
                            reportParams.put("subName", (lang.equalsIgnoreCase("Ar") ? "\u0623\u0633\u0645 \u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment Name"));
                        } else if (sub.equals("brands")) {
                            reportParams.put("subName", (lang.equalsIgnoreCase("Ar") ? "\u0623\u0633\u0645 \u0627\u0644\u0645\u0627\u0631\u0643\u0629" : "Model Name"));
                        } else if (sub.equals("mainTypes")) {
                            reportParams.put("subName", (lang.equalsIgnoreCase("Ar") ? "\u0623\u0633\u0645 \u0627\u0644\u0646\u0648\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A" : "Main Type Name"));
                        } else if (sub.equals("departments")) {
                            reportParams.put("subName", (lang.equalsIgnoreCase("Ar") ? "\u0623\u0633\u0645 \u0627\u0644\u0642\u0633\u0645" : "Department Name"));
                        }
                        wbo.setAttribute("sub", sub);
                        data = allMaintenanceInfoMgr.getCostingReportsGroup(wbo);
                        Tools.createPdfReport("mainTypesAVGCostReportGroups", reportParams, data, getServletContext(), response, request);
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;

            case 16:

                java.sql.Connection conn = null;
                try {
                    conn = AllMaintenanceInfoMgr.getInstance().getReportConn();
                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                reportParams = new HashMap();
                reportParams.put("bDate", request.getParameter("beginDate"));
                reportParams.put("eDate", request.getParameter("endDate"));
                reportParams.put("unitName", request.getParameter("unitName"));
                reportParams.put("unit_id", request.getParameter("unitId"));

                Tools.createPdfReport("Spare", reportParams, getServletContext(), response, request, conn);
                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
            case 17:

                params = new HashMap();

                Vector dataSource = null;
                Vector itemListTemp = new Vector();
                issueId = request.getParameter(IssueConstants.ISSUEID);
                WebBusinessObject myIssue = issueMgr.getOnSingleKey(issueId);
                String uID = (String) myIssue.getAttribute("unitScheduleID");
                WebBusinessObject unitWbo = usMgr.getOnSingleKey(myIssue.getAttribute("unitScheduleID").toString());

                String eqpName = (String) unitWbo.getAttribute("unitName");
                String issueNo = (String) myIssue.getAttribute("businessID");

                params.put("unitName", eqpName);
                params.put("issueNo", issueNo);

                Vector itemList = new Vector();
                String uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();
                QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "0");
                WebBusinessObject web = usMgr.getOnSingleKey(uID);

                String eID = web.getAttribute("periodicId").toString();

                if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
                    itemList = ListItems.getSpecialItemSchedule(uSID, "0");

                } else {

                    if (itemListTemp.size() == 0) {
                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                        itemList = itemsList.getConfigItemBySchedule(eID);

                    } else {
                        itemList = itemListTemp;

                    }
                }

                if (!itemList.isEmpty()) {
                    AppConstants appCons = new AppConstants();
                    String[] itemAtt = appCons.getItemScheduleAttributes();
                    String attName = null;
                    String attValue = null;
                    Enumeration e = itemList.elements();
                    WebBusinessObject itemWbo = new WebBusinessObject();
                    dataSource = new Vector();
                    WebBusinessObject aWbo = null;
                    totalCost = 0.0;
                    int totalUsedSpareParts = 0;
                    while (e.hasMoreElements()) {
                        totalUsedSpareParts++;
                        wbo = (WebBusinessObject) e.nextElement();
                        attName = itemAtt[0];
                        attValue = (String) wbo.getAttribute(attName);
                        String[] itemcodeList = attValue.split("-");

                        if (itemcodeList.length > 1) {
                            itemWbo = (WebBusinessObject) itemsMgr.getOnSingleKey(attValue);
                        } else {
                            itemWbo = itemsMgr.getOnObjectByKey(attValue);

                        }

                        if (itemWbo != null) {
                            aWbo = new WebBusinessObject();

                            if (itemcodeList.length > 1) {
                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCodeByItemForm"));

                            } else {
                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCode"));

                            }

                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
                            aWbo.setAttribute("totalCost", (String) wbo.getAttribute("totalCost"));
                            aWbo.setAttribute("itemPrice", (String) wbo.getAttribute("itemPrice"));
                            totalCost += Double.parseDouble((String) wbo.getAttribute("totalCost"));
                            attName = itemAtt[1];
                            attValue = (String) wbo.getAttribute(attName);
                            aWbo.setAttribute("itemQuantity", attValue);

                            attName = itemAtt[4];
                            attValue = (String) wbo.getAttribute(attName);
                            aWbo.setAttribute("note", attValue);

                            String costCenterName, costNameField;
                            String cMode = (String) request.getSession().getAttribute("currentMode");
                            String stat = cMode;
                            if (stat.equals("En")) {
                                costNameField = "LATIN_NAME";
                            } else {
                                costNameField = "COSTNAME";
                            }
                            attValue = (String) wbo.getAttribute("attachedOn");
                            if (!attValue.equals("2")) {
                                CostCentersMgr costCenterMgr = CostCentersMgr.getInstance();
                                Vector costCentersVec = null;
                                try {
                                    costCentersVec = costCenterMgr.getOnArbitraryKey(attValue, "key");
                                } catch (SQLException ex) {
                                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                                } catch (Exception ex) {
                                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }
                                WebBusinessObject costCenterWbo = (WebBusinessObject) costCentersVec.elementAt(0);
                                costCenterName = costCenterWbo.getAttribute(costNameField).toString();
                            } else {
                                costCenterName = "Not Found";
                            }
                            aWbo.setAttribute("costCenter", costCenterName);
                            dataSource.add(aWbo);
                        }
                    }
                    params.put("totalCost", Double.parseDouble(decimalFormat.format(totalCost)));
                    params.put("totalUsedSpareParts", totalUsedSpareParts);
                }

                Tools.createPdfReport("SpareParts", params, dataSource, getServletContext(), response, request);
                break;

            case 18:

                params = new HashMap();

                itemListTemp = new Vector();
                String projectname = request.getParameter("projectName");
                this.assignedIssueState = IssueStatusFactory.getStateClass(IssueStatusFactory.SCHEDULE);
//                quantifiedMgr = QuantifiedMntenceMgr.getInstance();
                issueId = request.getParameter(IssueConstants.ISSUEID);

                myIssue = issueMgr.getOnSingleKey(issueId);

                uID = (String) myIssue.getAttribute("unitScheduleID");
                String issue_title = request.getParameter(IssueConstants.ISSUETITLE);

                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                String attachedEqFlag = (String) request.getParameter("attachedEqFlag");

                params = new HashMap();

                itemListTemp = new Vector();
                issueId = request.getParameter(IssueConstants.ISSUEID);
                myIssue = issueMgr.getOnSingleKey(issueId);
                uID = (String) myIssue.getAttribute("unitScheduleID");
                unitWbo = usMgr.getOnSingleKey(myIssue.getAttribute("unitScheduleID").toString());

                eqpName = (String) unitWbo.getAttribute("unitName");
                issueNo = (String) myIssue.getAttribute("businessID");

                params.put("unitName", eqpName);
                params.put("issueNo", issueNo);

                itemList = new Vector();
                uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();

                UsedSparePartsMgr ListUsedItems = UsedSparePartsMgr.getInstance();
                itemListTemp = ListUsedItems.getUsedItemSchedule(uSID);
                itemList = itemListTemp;

                Vector<WebBusinessObject> configitemList = new Vector();
                // uSID = issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString();

                web = usMgr.getOnSingleKey(uID);
                eID = new String();
                eID = web.getAttribute("periodicId").toString();
                /*if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
                 configitemList = ListItems.getSpecialItemSchedule(uSID, "0");
                 } else {
                 if (itemListTemp.size() == 0) {
                 ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                 configitemList = itemsList.getConfigItemBySchedule(eID);
                 } else {
                 configitemList = itemListTemp;
                 }
                 }

                 if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
                 itemList = ListItems.getSpecialItemSchedule(uSID, "0");

                 } else {

                 if (itemListTemp.size() == 0) {
                 ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                 itemList = itemsList.getConfigItemBySchedule(eID);

                 } else {
                 itemList = itemListTemp;

                 }
                 }*/
                dataSource = new Vector();
                if (!itemList.isEmpty()) {
                    AppConstants appCons = new AppConstants();
                    String[] itemAtt = appCons.getItemScheduleAttributes();
                    String attName = null;
                    String attValue = null;
                    Enumeration e = itemList.elements();
                    WebBusinessObject itemWbo = new WebBusinessObject();
                    WebBusinessObject aWbo = null;
                    int totalUsedSpareParts = 0;
                    totalCost = 0.0;
                    params.put("usedSparePartsReport", "yes");

                    while (e.hasMoreElements()) {
                        totalUsedSpareParts++;
                        wbo = (WebBusinessObject) e.nextElement();
                        attName = itemAtt[0];
                        attValue = (String) wbo.getAttribute(attName);
                        String[] itemcodeList = attValue.split("-");

                        if (itemcodeList.length > 1) {
                            itemWbo = (WebBusinessObject) itemsMgr.getOnSingleKey(attValue);
                        } else {
                            itemWbo = itemsMgr.getOnObjectByKey(attValue);

                        }

                        if (itemWbo != null) {
                            aWbo = new WebBusinessObject();

                            if (itemcodeList.length > 1) {
                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCodeByItemForm"));

                            } else {
                                aWbo.setAttribute("itemCode", (String) itemWbo.getAttribute("itemCode"));

                            }

                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
                            aWbo.setAttribute("itemName", (String) itemWbo.getAttribute("itemDscrptn"));
                            aWbo.setAttribute("totalCost", (String) wbo.getAttribute("totalCost"));
                            aWbo.setAttribute("itemPrice", (String) wbo.getAttribute("itemPrice"));
                            totalCost += Double.parseDouble((String) wbo.getAttribute("totalCost"));
                            attName = itemAtt[1];
                            attValue = (String) wbo.getAttribute(attName);
                            aWbo.setAttribute("itemQuantity", attValue);

                            attName = itemAtt[4];
                            attValue = (String) wbo.getAttribute(attName);
                            aWbo.setAttribute("note", attValue);

                            dataSource.add(aWbo);
                        }
                    }
                    params.put("totalUsedSpareParts", totalUsedSpareParts);
                    params.put("totalCost", Double.parseDouble(decimalFormat.format(totalCost)));
                }

                Tools.createPdfReport("SpareParts", params, dataSource, getServletContext(), response, request);
                break;

            case 19:
                externalJobReportMgr = ExternalJobReportMgr.getInstance();
                from = request.getParameter("from");
                to = request.getParameter("to");
                totalCost = 0.0;
                dataSet = new Vector();
                params = new HashMap();

                dataSet = externalJobReportMgr.getExternalJOBReportByMaintNum(from, to);

                branchProject = new WebBusinessObject();
                mainProject = new WebBusinessObject();

                basicMgr = EmpBasicMgr.getInstance();
                costCentersMgr = CostCentersMgr.getInstance();

                for (int i = 0; i < dataSet.size(); i++) {

                    branchProject = null;
                    mainProject = null;

                    wbo = (WebBusinessObject) dataSet.get(i);
                    issueId = (String) wbo.getAttribute("issueId");

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);

                    WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unit_id"));
                    try {
                        if (!getMainInfo.getAttribute("empID").equals("")) {
                            String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                            wbo.setAttribute("empName", empName);

                        } else {
                            wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                    }

                    try {
                        if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                            String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                            if (costName.equals("***")) {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            } else {
                                wbo.setAttribute("costName", costName);
                            }
                        } else {
                            wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                    }

                    String siteName = projectMgr.getSiteNameById((String) wbo.getAttribute("site_id"));
                    branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site_id").toString());
                    if (!branchProject.getAttribute("mainProjId").equals("0")) {
                        mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                        wbo.setAttribute("mainSite", (String) mainProject.getAttribute("projectName"));
                    }

                    laborCost = Double.parseDouble((String) wbo.getAttribute("labor_cost"));
                    totalCost += laborCost;
                    //wbo.setAttribute("labor_cost", (String)wbo.getAttribute("labor_cost"));

                    try {
                        wbo.setAttribute("parentName", parentName);
                        wbo.setAttribute("siteName", siteName);

                    } catch (Exception e) {
                        wbo.setAttribute("parentName", "");
                        wbo.setAttribute("siteName", "");
                        System.out.println();

                    }
                }

                params.put("totalCost", totalCost);
                params.put("fromToMaintNumReport", "yes");
                params.put("fromSide", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0646 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629" : "From Maintenance No."));
                params.put("toSide", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0649 \u0631\u0642\u0645 \u0635\u064A\u0627\u0646\u0629" : "To Maintenance No."));
                params.put("fromMaintNum", from);
                params.put("toMaintNum", to);

                params.put("mainSite", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0648\u0642\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u0649" : "Main Site"));
                params.put("equipment", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0639\u062F\u0629" : "Equipment"));
                params.put("model", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0627\u0631\u0643\u062A\u0647\u0627" : "Model"));
                params.put("at", (lang.equalsIgnoreCase("Ar") ? "\u0641\u0649" : "at"));
                params.put("jobOrderCountPerEquipment", (lang.equalsIgnoreCase("Ar") ? "\u0639\u062F\u062F \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0644\u0644\u0645\u0639\u062F\u0629" : "Job Order Count Per Equipment"));
                params.put("totalCostPerEquipment", (lang.equalsIgnoreCase("Ar") ? "\u0625\u062C\u0645\u0627\u0644\u0649 \u0627\u0644\u062A\u0643\u0644\u0641\u0629 \u0644\u0644\u0645\u0639\u062F\u0629" : "Total Cost Per Equipment"));

                // create and open PDF report in browser
                reportName = lang.equalsIgnoreCase("Ar") ? "ExternalReport01" : "ExternalReport01_En";
                Tools.createPdfReport(reportName, params, dataSet, getServletContext(), response, request);
                break;

            case 20:
                Vector tempVec = null;
                dataSource = new Vector();
                params = new HashMap();
                Vector schedulesVec = null;
                Vector EqpsVec = null;
                String scheduleId = null;
                String unitId = null;
                WebBusinessObject scheduleWbo = null;
                unitWbo = null;
                WebBusinessObject dataSourceWbo = null;
                String brandId = request.getParameter("brandId");
                String brandName = request.getParameter("brandName");
                String dueBeginDate = request.getParameter("dueBeginDate");

                try {

                    // get ALL schedules on this brand/model/category
                    // whether they are activated or not
                    schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(brandId, "key4", "Cat", "key5");

                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                for (int i = 0; i < schedulesVec.size(); i++) {
                    scheduleWbo = (WebBusinessObject) schedulesVec.get(i);
                    scheduleId = (String) scheduleWbo.getAttribute("periodicID");

                    // get equipments scheduled on this schedule which is
                    // activated after the given date
                    EqpsVec = usMgr.getEqpsByDueAfterDateSchedule(scheduleId, dueBeginDate);

                    if (EqpsVec != null && !EqpsVec.isEmpty()) {

                        for (int j = 0; j < EqpsVec.size(); j++) {
                            dataSourceWbo = (WebBusinessObject) EqpsVec.get(j);

                            /* set data source wbo with schedule info */
                            dataSourceWbo.setAttribute("frequencyType",
                                    Tools.getFrequencyType((String) scheduleWbo.getAttribute("frequencyType"),
                                            "Ar"));
                            dataSourceWbo.setAttribute("frequency", (String) scheduleWbo.getAttribute("frequency"));
                            /* -set data source wbo with schedule info */

                            unitId = (String) dataSourceWbo.getAttribute("unitId");
                            unitWbo = maintainableMgr.getOnSingleKey(unitId);

                            // set data source wbo with unit info
                            dataSourceWbo.setAttribute("unitCode", (String) unitWbo.getAttribute("unitNo"));

                        }

                        dataSource.addAll(EqpsVec);
                    }
                }

                params.put("brandName", brandName);
                params.put("dueBeginDate", dueBeginDate);

                // create and open PDF report in browser
                Tools.createPdfReport("EqpsByDueAfterDateBrandSchedules", params, dataSource, getServletContext(), response, request);
                break;

            case 21:
                conn = null;
                String typee = request.getParameter("type");
                String reportName = "";
                if (typee.equals("eqp")) {
                    reportName = "ApprovalGroup";
                } else if (typee.equals("item")) {
                    reportName = "ItemApprovalGroup";
                }

                try {
                    conn = AllMaintenanceInfoMgr.getInstance().getReportConn();
                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                reportParams = new HashMap();
                Tools.createPdfReport(reportName, reportParams, getServletContext(), response, request, conn);
                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                break;
            case 22:
                Vector allMaintenanceInfo;
                String issueId,
                 parentId,
                 parentName;
                Vector allItems,
                 allTask,
                 tempv1,
                 tempv2;

                Map parameters = new HashMap();

                unitId = request.getParameter("unitId");
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
                searchBy = request.getParameter("searchBy");
                orderType = request.getParameter("orderType");
                dateType = request.getParameter("dateType");
                maintenanceDurationL = 0;
                totalMaintenanceDurationL = 0;
                String[] trade = request.getParameterValues("trade");
                currentStatus = request.getParameterValues("currenStatus");
                String[] site = request.getParameterValues("site");
                String[] mainType = request.getParameterValues("mainType");
                String[] brand = request.getParameterValues("brand");
                String issueTitle = request.getParameter("issueTitle");
                String issue_Title = request.getParameter("issueTitle");

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
                siteStrArr = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639" : "All Sites";
                String tradeStr = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629" : "All Maintenance Types";

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
                    parameters.put("unitName", (String) wbo.getAttribute("unitName"));
                    branchProject = new WebBusinessObject();
                    String projectId = (String) wbo.getAttribute("site");
                    wbo = projectMgr.getOnSingleKey(projectId);
                    if (!wbo.getAttribute("mainProjId").equals("0")) {
                        branchProject = projectMgr.getOnSingleKey((String) wbo.getAttribute("mainProjId"));
                        parameters.put("mainSite", (String) branchProject.getAttribute("projectName"));
                    }

                    parameters.put("siteName", (String) wbo.getAttribute("projectName"));
                    parameters.put("parentName", maintainableMgr.getUnitName(parentId));
                    parameters.put("equipmentReport", "yes");

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByEquip(wboCritaria);

                    unitNameLbl = lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment";
                    unitNamesStr = unitName;

                } else if (searchBy != null && searchBy.equals("brand")) {
                    wboCritaria.setAttribute("site", site);
                    wboCritaria.setAttribute("brand", brand);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByBrand(wboCritaria);

                    if (!brandAll.equals("yes")) {
                        String s = "";
                        tempVec = parentUnitMgr.getParensName(brand);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();
                        }
                        if (tempVec.size() > 1) {
                            s += " , ...";
                        }
                        unitNamesStr = s;
                    } else {
                        unitNamesStr = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A" : "All Models";
                    }
                    unitNameLbl = lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0627\u0631\u0643\u0629" : "Model";

                } else {
                    wboCritaria.setAttribute("site", site);
                    wboCritaria.setAttribute("mainType", mainType);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceBySiteType(wboCritaria);

                    if (!mainTypeAll.equals("yes")) {
                        String s = "";
                        tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();
                        }
                        if (tempVec.size() > 1) {
                            s += " , ...";
                        }
                        unitNamesStr = s;
                    } else {
                        unitNamesStr = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629" : "All Main Types";
                    }
                    unitNameLbl = lang.equalsIgnoreCase("Ar") ? "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u0649" : "Main Type";
                }

                temp1 = "";
                typeOfSchedule = "";
                issueStatus = "";
                tempStatus = "";
                maintenanceDuration = "";
                tempStatusBegin = "";
                tempStatusEnd = "";
                currentStatusSince = "";

                currentStatusSinceDate = null;
                actualBeginDate = null;
                actualEndDate = null;

                //ConfigFileMgr configFileMgr = new ConfigFileMgr();
                basicMgr = EmpBasicMgr.getInstance();
                costCentersMgr = CostCentersMgr.getInstance();
                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    branchProject = null;
                    mainProject = null;
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

                    WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unitId"));
                    try {
                        if (!getMainInfo.getAttribute("empID").equals("")) {
                            String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                            wbo.setAttribute("empName", empName);
                        } else {
                            wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("empName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));

                    }

                    try {
                        if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                            String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                            if (costName.equals("***")) {
                                wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                            } else {
                                wbo.setAttribute("costName", costName);
                            }
                        } else {
                            wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("costName", (lang.equalsIgnoreCase("Ar") ? "\u0644\u0627 \u064A\u0648\u062C\u062F" : "None"));
                    }

                    wbo.setAttribute("parentName", parentName);

                    branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site").toString());
                    if (!branchProject.getAttribute("mainProjId").equals("0")) {
                        mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                        wbo.setAttribute("mainSite", (String) mainProject.getAttribute("projectName"));
                    }
                    issueStatus = (String) wbo.getAttribute("currentStatus");

                    String issueStatusLabel = "";
                    if (issueStatus.equals("Assigned")) {
                        issueStatusLabel = JOAssignedStatus;
                        tempStatus = " - " + JOOpenStatus;
                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatus;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));

                        if (actualBeginDate != null) {
                            maintenanceDurationL = new Date().getTime() - actualBeginDate.getTime();
                            totalMaintenanceDurationL += maintenanceDurationL;
                            maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL,
                                    true, true);
                        }

                    } else if (issueStatus.equals("Canceled")) {
                        issueStatusLabel = JOCanceledStatus;
                        tempStatus = " - " + JOCancelStatus;
                        currentStatusSince = ((String) wbo.getAttribute("currentStatusSince")) + tempStatus;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                        currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                        maintenanceDurationL = currentStatusSinceDate.getTime() - actualEndDate.getTime();
                        totalMaintenanceDurationL += maintenanceDurationL;
                        maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);

                    } else {
                        issueStatusLabel = JOFinishedStatus;
                        tempStatusBegin = " - " + JOOpenStatus;
                        tempStatusEnd = " - " + JOCloseStatus;
                        currentStatusSince = ((String) wbo.getAttribute("ActualBeginDate")) + tempStatusBegin + "\n" + ((String) wbo.getAttribute("ActualEndDate")) + tempStatusEnd;

                        actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                        actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));

                        try {
                            maintenanceDurationL = actualEndDate.getTime() - actualBeginDate.getTime();
                            totalMaintenanceDurationL += maintenanceDurationL;
                            maintenanceDuration = DurationFormatUtils.formatDurationWords(maintenanceDurationL, true, true);

                        } catch (NullPointerException nPEx) {
                            maintenanceDurationL = 0;
                            maintenanceDuration = "0";

                        }
                    }

                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                        typeOfSchedule = JOEmrgencyStatus;//configFileMgr.getJobOrderType("Emergency");
                    } else {
                        temp1 = (String) wbo.getAttribute("issueTitle");
                        typeOfSchedule = (lang.equalsIgnoreCase("Ar") ? "\u0628\u0646\u0627\u0621\u0639\u0644\u0649 \u062C\u062F\u0648\u0644" : "Based on Table") + temp1;
                    }

                    wbo.setAttribute("issueStatus", issueStatusLabel/*configFileMgr.getJobOrderTypeByCurrentLanguage(issueStatus)*/);
                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                    wbo.setAttribute("currentStatusSince", currentStatusSince);
                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
                    wbo.setAttribute("maintenanceDurationL", maintenanceDurationL);

                }

                if (!siteAll.equals("yes")) {
                    siteVec = (Vector) projectMgr.getProjectsName(site);
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

                parameters.put("beginDate", beginDate);
                parameters.put("endDate", endDate);
                parameters.put("unitNameLbl", unitNameLbl);
                parameters.put("unitNamesStr", unitNamesStr);
                parameters.put("siteStrArr", siteStrArr);
                parameters.put("tradeStr", tradeStr);
                parameters.put("taskName", taskName);
                parameters.put("REPORT_TYPE", "else");
                parameters.put("FROM", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E" : "From Date"));
                parameters.put("TO", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E" : "To Date"));
                parameters.put("totalMaintenanceDurationL", totalMaintenanceDurationL);
                parameters.put("equipment", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0639\u062F\u0629" : "Equipment"));
                parameters.put("model", (lang.equalsIgnoreCase("Ar") ? "\u0645\u0627\u0631\u0643\u062A\u0647\u0627" : "Model"));
                parameters.put("at", (lang.equalsIgnoreCase("Ar") ? "\u0641\u0649" : "at"));
                parameters.put("mainSiteStr", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0648\u0642\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u0649" : "Main Site"));

                // create and open PDF report in browser
                context = getServletConfig().getServletContext();
                reportName = lang.equalsIgnoreCase("Ar") ? "DetailedMaintenance" : "DetailedMaintenance_En";
                Tools.createPdfReport(reportName, parameters, allMaintenanceInfo, context, response, request);

                break;

            case 23:
                Enumeration e = null;
                scheduleWbo = null;
                dataSource = new Vector();
                parameters = new HashMap();

                int totalSubtract = 0,
                 countResult = 0;

                Vector issueItemVec = null,
                 checkResponseVec = null,
                 resultItemVec = null,
                 costCentersVec = null;

                WebBusinessObject issueWbo = null,
                 siteWbo = null,
                 unitScheduleWbo = null,
                 transDetailWbo = null,
                 costCenterWbo = null,
                 wboItem = null,
                 dataWbo = null,
                 itemFormByItemWbo = null,
                 branchByItemWbo = null,
                 storeByItemWbo = null,
                 resultItemWbo = null;

                String costCenterId = null,
                 costCenterName = null,
                 costNameField = null,
                 totalSubtractStr = "0";

                issueId = request.getParameter(IssueConstants.ISSUEID);

                issueWbo = issueMgr.getOnSingleKey(issueId);

                /* prepare report header */
                parameters.put("issueNo", issueWbo.getAttribute("businessID") + "/" + issueWbo.getAttribute("businessIDbyDate"));

                siteWbo = projectMgr.getOnSingleKey((String) issueWbo.getAttribute("projectName"));
                parameters.put("issueSite", (String) siteWbo.getAttribute("projectName"));

                if (((String) issueWbo.getAttribute("currentStatus")).equals("Schedule")) {
                    parameters.put("issueActualBeginDate", "\u0644\u0645 \u064A\u0628\u062F\u0623 \u0628\u0639\u062F");

                } else {
                    parameters.put("issueActualBeginDate", (String) issueWbo.getAttribute("ActualBeginDate"));

                }

                unitScheduleWbo = usMgr.getOnSingleKey((String) issueWbo.getAttribute("unitScheduleID"));
                parameters.put("issueUnit", (String) unitScheduleWbo.getAttribute("unitName"));
                /* -prepare report header */

                if (lang.equalsIgnoreCase("Ar")) {
                    costNameField = "COSTNAME";

                } else {
                    costNameField = "LATIN_NAME";

                }

                issueItemVec = transStoreItemMgr.getResponseTotalStoreItems(issueId, "91");
                resultItemVec = resultStoreItemMgr.getResultTotalStoreItems(issueId, "91");

                e = issueItemVec.elements();

                while (e.hasMoreElements()) {
                    dataWbo = new WebBusinessObject();
                    transDetailWbo = new WebBusinessObject();
                    countResult++;
                    wbo = (WebBusinessObject) e.nextElement();
                    itemId = wbo.getAttribute("itemID").toString();

                    String[] itemCode = itemId.split("-");
                    wboItem = new WebBusinessObject();
                    transDetailWbo = (WebBusinessObject) transactionDetailsMgr.getOnSingleKey(wbo.getAttribute("detailId").toString());

                    costCenterId = (String) transDetailWbo.getAttribute("cost_center_id");

                    if (!costCenterId.equals("2")) {
                        CostCentersMgr costCenterMgr = CostCentersMgr.getInstance();

                        try {
                            costCentersVec = costCenterMgr.getOnArbitraryKey(costCenterId, "key");
                        } catch (SQLException ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        costCenterWbo = (WebBusinessObject) costCentersVec.elementAt(0);
                        costCenterName = costCenterWbo.getAttribute(costNameField).toString();

                    } else {
                        costCenterName = "Not Found";

                    }

                    if (itemCode.length > 1) {
                        wboItem = itemsMgr.getOnSingleKey(itemId);
                        dataWbo.setAttribute("itemNo", (String) wboItem.getAttribute("itemCodeByItemForm"));

                    } else {
                        wboItem = itemsMgr.getOnObjectByKey(itemId);
                        dataWbo.setAttribute("itemNo", (String) wboItem.getAttribute("itemCode"));

                    }

                    dataWbo.setAttribute("itemName", (String) wboItem.getAttribute("itemDscrptn"));
                    dataWbo.setAttribute("itemTotalQty", (String) wbo.getAttribute("total"));
                    dataWbo.setAttribute("costCenterName", costCenterName);

                    itemFormByItemWbo = itemFormMgr.getOnSingleKey((String) transDetailWbo.getAttribute("itemForm"));
                    dataWbo.setAttribute("itemGroup", transDetailWbo.getAttribute("itemForm") + "\n"
                            + itemFormByItemWbo.getAttribute("formDesc"));

                    branchByItemWbo = branchErpMgr.getOnSingleKey((String) transDetailWbo.getAttribute("branch"));
                    dataWbo.setAttribute("storeBranch", transDetailWbo.getAttribute("branch") + "\n"
                            + branchByItemWbo.getAttribute("Description"));

                    storeByItemWbo = storesErpMgr.getOnSingleKey((String) transDetailWbo.getAttribute("store"));
                    dataWbo.setAttribute("itemStore", transDetailWbo.getAttribute("store") + "\n"
                            + storeByItemWbo.getAttribute("nameAr"));

                    if (resultItemVec != null && resultItemVec.size() > 0) {
                        totalSubtract = 0;
                        for (int x = 0; x < resultItemVec.size(); x++) {
                            resultItemWbo = (WebBusinessObject) resultItemVec.get(x);

                            if (resultItemWbo.getAttribute("itemID").equals(itemId)) {
                                totalSubtractStr = resultItemWbo.getAttribute("total").toString();
                                totalSubtract++;

                            }

                        }

                        if (totalSubtract > 0) {
                            dataWbo.setAttribute("totalSubtract", totalSubtractStr);

                        } else {
                            dataWbo.setAttribute("totalSubtract", Integer.toString(totalSubtract));

                        }

                    } else {
                        dataWbo.setAttribute("totalSubtract", Integer.toString(totalSubtract));

                    }

                    // add result Wbo to data source
                    dataSource.add(dataWbo);

                }

                Tools.createPdfReport("RequestedItemsFromStore", parameters, dataSource, getServletContext(), response, request);

                break;

            case 24:
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String currentStatu = request.getParameter("currenStatus");//currentStatusValues.split(" ");

                String[] sites_ = request.getParameterValues("site");
                String[] tradeArr = request.getParameterValues("trade");
                String[] mainTypeArr = request.getParameterValues("mainType");
                unitId = request.getParameter("unitId");

                // set wbo To pass to Method to search
                wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", beginDate);
                wboCritaria.setAttribute("endDate", endDate);
                wboCritaria.setAttribute("currentStatus", currentStatu);
                wboCritaria.setAttribute("sites", sites_);
                wboCritaria.setAttribute("tradeArr", tradeArr);
                wboCritaria.setAttribute("mainTypeArr", (mainTypeArr != null)
                        ? mainTypeArr : new String[0]);
                wboCritaria.setAttribute("unitId", unitId);

                allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByDate(wboCritaria);
                actualBeginDate = null;
                actualEndDate = null;
                String mainTypeId = null;
                //configFileMgr = new ConfigFileMgr();
                branchProject = new WebBusinessObject();
                mainProject = new WebBusinessObject();
                basicMgr = EmpBasicMgr.getInstance();
                costCentersMgr = CostCentersMgr.getInstance();
                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    branchProject = null;
                    mainProject = null;
                    wbo = null;
                    issueStatus = "";
                    maintenanceDuration = "";
                    currentStatusSince = "";

                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    WebIssue webIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                    String scheduleType = webIssue.getAttribute("scheduleType").toString();
                    String importer = "";
                    try {
                        if (scheduleType.equalsIgnoreCase("External")) {
                            ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
                            supplierMgr = SupplierMgr.getInstance();
                            Vector vecExternal = externalJobMgr.getOnArbitraryKey((String) webIssue.getAttribute("id"), "key2");
                            if (vecExternal.size() > 0) {
                                WebBusinessObject wboExternal = (WebBusinessObject) vecExternal.get(0);
                                WebBusinessObject wboSupplier = supplierMgr.getOnSingleKey((String) wboExternal.getAttribute("supplierID"));
                                importer = wboSupplier.getAttribute("name").toString();
                                wbo.setAttribute("scheduleType", scheduleType);
                                wbo.setAttribute("importer", importer);
                            }
                        } else {
                            wbo.setAttribute("scheduleType", "---");
                            wbo.setAttribute("importer", "---");
                        }
                    } catch (Exception ex) {
                    }
                    //logger.info("JO Number : " + i + " - ID : "+ issueId);
                    mainTypeId = (String) wbo.getAttribute("main_type_id");
                    //wbo.printSelf();

                    WebBusinessObject getMainInfo = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unitId"));
                    try {
                        if (!getMainInfo.getAttribute("empID").equals("")) {
                            String empName = basicMgr.getEmployeeName((String) getMainInfo.getAttribute("empID"));
                            wbo.setAttribute("empName", empName);

                        } else {
                            wbo.setAttribute("empName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("empName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                    }
                    try {
                        if (!getMainInfo.getAttribute("productionLine").equals("") && !getMainInfo.getAttribute("productionLine").equals("0")) {
                            String costName = costCentersMgr.getCostCenterNameByCode((String) getMainInfo.getAttribute("productionLine"), "Ar");
                            if (costName.equals("***")) {
                                wbo.setAttribute("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                            } else {
                                wbo.setAttribute("costName", costName);
                            }
                        } else {
                            wbo.setAttribute("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                        }
                    } catch (Exception exc) {
                        wbo.setAttribute("costName", "\u0644\u0627 \u064A\u0648\u062C\u062F");
                    }

                    branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site").toString());
                    if (!branchProject.getAttribute("mainProjId").equals("0")) {
                        mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                        wbo.setAttribute("siteName", (String) mainProject.getAttribute("eqNO") + "_" + (String) branchProject.getAttribute("projectName"));
                    }
                    String MainType = null;
                    try {
                        MainType = mainCategoryTypeMgr.getMainTypeNameById(mainTypeId);
                    } catch (NullPointerException nPEx) {
                        MainType = "not found";
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, nPEx.getMessage(), nPEx);

                    }

                    /*allItems = new Vector();
                     allTask = new Vector();

                     allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));
                     allTask = tasksByIssueMgr.getTask(issueId);

                     wbo.setAttribute("items", allItems);
                     wbo.setAttribute("tasks", allTask);*/
                    //wbo.setAttribute("size", allMaintenanceInfo.size());
                    wbo.getAttribute("unitName");

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);

                    wbo.setAttribute("parentName", MainType);

                    issueStatus = (String) wbo.getAttribute("currentStatus");
                    String issueStatusLabel = "";

                    if ((String) wbo.getAttribute("ActualBeginDate") != null && (String) wbo.getAttribute("ActualEndDate") != null) {
                        try {
                            if (issueStatus.equals("Assigned")) {
                                try {
                                    tempStatus = "  " + JOOpenStatus;

                                    currentStatusSince = (Tools.stringToStringDateonly((String) wbo.getAttribute("ActualBeginDate"))) + tempStatus;

                                    actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                    String BeginDate = Tools.stringToStringDateonly((String) wbo.getAttribute("ActualBeginDate"));

                                    maintenanceDuration = DurationFormatUtils.formatDurationWords(new Date().getTime() - actualBeginDate.getTime(), true, true);
                                } catch (Exception nPEx) {
                                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, nPEx.getMessage(), nPEx);
                                }
                                issueStatusLabel = JOAssignedStatus;
                            } else if (issueStatus.equals("Canceled")) {
                                try {
                                    tempStatus = " " + JOCancelStatus;

                                    currentStatusSince = (Tools.stringToStringDateonly((String) wbo.getAttribute("currentStatusSince"))) + tempStatus;

                                    actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                    currentStatusSinceDate = Tools.stringToDate((String) wbo.getAttribute("currentStatusSince"));

                                    String BeginDate = Tools.stringToStringDateonly((String) wbo.getAttribute("ActualBeginDate"));

                                    maintenanceDuration = DurationFormatUtils.formatDurationWords(currentStatusSinceDate.getTime() - actualEndDate.getTime(), true, true);
                                } catch (Exception nPEx) {
                                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, nPEx.getMessage(), nPEx);
                                }
                                issueStatusLabel = JOCanceledStatus;
                            } else {
                                try {
                                    tempStatusBegin = " " + JOOpenStatus;
                                    tempStatusEnd = "  " + JOCloseStatus;

                                    currentStatusSince = (Tools.stringToStringDateonly((String) wbo.getAttribute("ActualBeginDate"))) + tempStatusBegin + "\n" + (Tools.stringToStringDateonly((String) wbo.getAttribute("ActualEndDate"))) + tempStatusEnd;

                                    String BeginDate = Tools.stringToStringDateonly((String) wbo.getAttribute("ActualBeginDate"));

                                    actualBeginDate = Tools.stringToDate((String) wbo.getAttribute("ActualBeginDate"));
                                    actualEndDate = Tools.stringToDate((String) wbo.getAttribute("ActualEndDate"));
                                    issueStatusLabel = JOFinishedStatus;
                                } catch (Exception nPEx) {
                                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, nPEx.getMessage(), nPEx);
                                }

                                try {
                                    maintenanceDuration = DurationFormatUtils.formatDurationWords(actualEndDate.getTime() - actualBeginDate.getTime(), true, true);
                                } catch (NullPointerException nPEx) {
                                    maintenanceDuration = "0";
                                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, nPEx.getMessage(), nPEx);
                                }
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, ex.getMessage(), ex);
                        }
                    } else {

                        issueStatusLabel = JOOpendStatus;
                        try {
                            currentStatusSince = Tools.stringToStringDateonly((String) wbo.getAttribute("ActualBeginDate")) + "\n" + JOOpenStatus;
                            maintenanceDuration = "0";
                        } catch (Exception nPEx) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, nPEx.getMessage(), nPEx);
                        }
                    }

                    if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                        typeOfSchedule = JOEmrgencyStatus;
                    } else {
                        temp1 = (String) wbo.getAttribute("issueTitle");
                        typeOfSchedule = temp1;
                    }

                    wbo.setAttribute("issueStatus", issueStatusLabel);
                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                    wbo.setAttribute("currentStatusSince", currentStatusSince);
                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);

                }

                unitNameLbl = "";

                parameters = new HashMap();
                parameters.put("beginDate", beginDate);
                parameters.put("endDate", endDate);
                parameters.put("size", allMaintenanceInfo.size());
                parameters.put("size2", allMaintenanceInfo.size());
                if (unitNameLbl != null && !unitNameLbl.equals("")) {
                    parameters.put("unitNameLbl", unitNameLbl);
                }

                // create and open PDF report in browser
                context = getServletConfig().getServletContext();
                Tools.createPdfReport("jobOrderByIntervalDate", parameters, allMaintenanceInfo, context, response, request);
                break;

            case 25:
                parameters = new HashMap();

                taskId = request.getParameter("taskId");
                taskName = request.getParameter("taskName");
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                siteAll = request.getParameter("siteAll");
                brandAll = request.getParameter("brandAll");
                orderType = request.getParameter("orderType");
                dateType = request.getParameter("dateType");

                searchBy = request.getParameter("searchBy");

                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");

                currentStatus = request.getParameterValues("currenStatus");
                site = request.getParameterValues("site");

                brand = request.getParameterValues("brand");
                issueTitle = request.getParameter("issueTitle");

                // set wbo To pass to Method to search
                wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", beginDate);
                wboCritaria.setAttribute("endDate", endDate);

                wboCritaria.setAttribute("issueTitle", issueTitle);
                wboCritaria.setAttribute("currentStatus", currentStatus);
                wboCritaria.setAttribute("dateOrder", dateType + " " + orderType);

                // for lable in jasper report
                unitNameLbl = "";
                unitNamesStr = "";
                siteStrArr = "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639";
                tradeStr = "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629";

                if (taskId != null && !taskId.equals("")) {
                    wboCritaria.setAttribute("taskId", taskId);
                }

                wboCritaria.setAttribute("site", site);

                allMaintenanceInfo = new Vector();
                if (searchBy.equalsIgnoreCase("unit")) {
                    wboCritaria.setAttribute("unitId", unitId);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByTaskAndEqp(wboCritaria);

                    parameters.put("unitNamesStr", unitName);
                    parameters.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0639\u062F\u0629");

                } else if (searchBy.equalsIgnoreCase("model")) {
                    wboCritaria.setAttribute("brand", brand);

                    allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByTaskAndModel(wboCritaria);

                    if (!brandAll.equals("yes")) {
                        String s = "";
                        tempVec = parentUnitMgr.getParensName(brand);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();
                        }
                        if (tempVec.size() > 1) {
                            s += " , ...";
                        }
                        parameters.put("unitNamesStr", s);
                    } else {
                        parameters.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A");
                    }
                    parameters.put("EQUIPMENT_TYPE", "\u0627\u0644\u0645\u0627\u0631\u0643\u0629");
                }

                //wboCritaria.setAttribute("brand", brand);
                //allMaintenanceInfo = allMaintenanceInfoMgr.getAllMaintenanceByTask(wboCritaria);

                /*if (!brandAll.equals("yes")) {
                 String s = "";
                 tempVec = parentUnitMgr.getParensName(brand);
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
                 */
                temp1 = "";
                typeOfSchedule = "";
                issueStatus = "";
                tempStatus = "";
                maintenanceDuration = "";
                tempStatusBegin = "";
                tempStatusEnd = "";
                currentStatusSince = "";

                currentStatusSinceDate = null;
                actualBeginDate = null;
                actualEndDate = null;
                AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
                String unitScheduleId = new String();
                String unitScheduleName = new String();
                Vector eqpReading = new Vector();
                String typeOfRate = null;
                int year,
                 mon,
                 day;
                String lastReadingDate = null,
                 stringID = null,
                 test = null;
                Date d = null;
                long id;
                Long l;
                long sl;
                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");

                    //get schedule name  for equipment
                    unitScheduleId = (String) wbo.getAttribute("unitSchedualeId");
                    try {
                        unitScheduleName = unitScheduleMgr.getSchNameBySubId(unitScheduleId);
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    //get type of rate Houre/KM
                    typeOfRate = wbo.getAttribute("typeOfRate").toString();

                    if (typeOfRate.equalsIgnoreCase("odometer")) {
                        typeOfRate = "KM";
                    } else if (typeOfRate.equalsIgnoreCase("fixed")) {
                        typeOfRate = "HR";
                    }

                    wbo.setAttribute("typeOfRate", typeOfRate);
                    eqpReading = averageUnitMgr.getEquipmentReading(wbo.getAttribute("unitId").toString());

                    lastReadingDate = ((WebBusinessObject) eqpReading.get(0)).getAttribute("entry_Time").toString();
                    d = Calendar.getInstance().getTime();
                    id = d.getTime();

                    stringID = new Long(id).toString();
                    test = new String(lastReadingDate);
                    l = new Long(test);
                    sl = l.longValue();

                    d.setTime(sl);
                    year = d.getYear() + 1900;
                    mon = d.getMonth() + 1;
                    day = d.getDate();
                    lastReadingDate = year + "-" + mon + "-" + day;

                    wbo.setAttribute("unitScheduleName", unitScheduleName);
                    wbo.setAttribute("lastReadingDate", lastReadingDate);
                    wbo.setAttribute("currentReading", ((WebBusinessObject) eqpReading.get(0)).getAttribute("current_Reading").toString());
                    wbo.setAttribute("previousReading", ((WebBusinessObject) eqpReading.get(0)).getAttribute("acual_Reading").toString());
                    allItems = new Vector();
                    allTask = new Vector();

                    allItems = quantifiedItemsMgr.getItems((String) wbo.getAttribute("unitSchedualeId"));

                    String task_name = null;
                    try {
                        task_name = taskMgr.getTaskNameById(wbo.getAttribute("taskId").toString());
                    } catch (Exception ex) {
                        task_name = taskName;
                    }

                    wbo.setAttribute("items", allItems);
                    wbo.setAttribute("task_name", task_name);
                    wbo.getAttribute("unitName");

                    parentId = (String) wbo.getAttribute("parentId");
                    parentName = maintainableMgr.getUnitName(parentId);

                    wbo.setAttribute("parentName", parentName);

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
                    wbo.setAttribute("JODate", JODate);
                    wbo.setAttribute("issueStatus", issueStatusLabel);
                    wbo.setAttribute("typeOfSchedule", typeOfSchedule);
                    wbo.setAttribute("currentStatusSince", currentStatusSince);
                    wbo.setAttribute("maintenanceDuration", maintenanceDuration);
                }

                if (!siteAll.equals("yes")) {
                    siteVec = (Vector) projectMgr.getProjectsName(site);
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
                parameters.put("ReportSize", allMaintenanceInfo.size());
                parameters.put("beginDate", beginDate);
                parameters.put("endDate", endDate);
                parameters.put("unitNameLbl", unitNameLbl);
                parameters.put("unitNamesStr", unitNamesStr);
                parameters.put("siteStrArr", siteStrArr);
                parameters.put("tradeStr", tradeStr);
                parameters.put("taskName", taskName);
                parameters.put("REPORT_TYPE", "else");
                parameters.put("FROM", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
                parameters.put("TO", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");

                // create and open PDF report in browser
                context = getServletConfig().getServletContext();

                Tools.createPdfReport("followUpReportMaintenanceItems", parameters, allMaintenanceInfo, context, response, request);
                break;

            case 26:
                parameters = new HashMap();
                WebBusinessObject planWbo = null;
                String planId = request.getParameter("planId");

                planWbo = planMgr.getOnSingleKey(planId);

                if (planWbo != null) {
                    parameters.put("planName", (String) planWbo.getAttribute("planName"));
                    parameters.put("planCode", (String) planWbo.getAttribute("planCode"));

                }

                dataSource = equipByPlanMgr.getEquipsByPlan(planId);

                // create and open PDF report in browser
                Tools.createPdfReport("EquipsByPlan", parameters, dataSource, getServletConfig().getServletContext(), response, request);
                break;

            case 27:
                parameters = new HashMap();
                dataSource = new Vector();
                itemList = null;
                Calendar calendar = Calendar.getInstance();

                supplierMgr = SupplierMgr.getInstance();
                quantifiedMgr = QuantifiedMntenceMgr.getInstance();

                issueId = request.getParameter(IssueConstants.ISSUEID);
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                DateAndTimeControl dateAndTime = new DateAndTimeControl();

                String[] itemCode = null;

                double totalCostItems = 0.0,
                 laborCost = 0.0,
                 totalCostLabors = 0.0,
                 jobOrderCosting = 0.0;

                String businessId,
                 projectName,
                 groupbyShift,
                 shift,
                 reading,
                 actualTakenTime,
                 cause,
                 equipType,
                 costStr,
                 totalCostStr,
                 totalCostLaborStr,
                 action,
                 caseStatus;

                WebBusinessObject tradeWbo,
                 tempWbo,
                 empWbo,
                 item,
                 webIssueStatus;

                Vector itemVec = new Vector(),
                 empList = null,
                 tasksList = null,
                 complaints = null,
                 loaclitems = null,
                 quantfItemList = null;

                WebIssue webIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                unitScheduleWbo = usMgr.getOnSingleKey(webIssue.getAttribute("unitScheduleID").toString());
                tradeWbo = tradeMgr.getOnSingleKey(webIssue.getAttribute("workTrade").toString());

                try {
                    empList = empTasksHoursMgr.getOnArbitraryKey(issueId, "key1");
                    tasksList = tasksByIssueMgr.getOnArbitraryKey(issueId, "key");

                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                // get Job order number
                JODate = "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
                businessId = (String) webIssue.getAttribute("businessID");
                // -get Job order number

                // get project name
                siteWbo = projectMgr.getOnSingleKey(webIssue.getAttribute("projectName").toString());
                projectName = (String) siteWbo.getAttribute("projectName");
                mainProject = new WebBusinessObject();
                if (!siteWbo.getAttribute("mainProjId").equals("0")) {
                    mainProject = projectMgr.getOnSingleKey((String) siteWbo.getAttribute("mainProjId"));
                    parameters.put("mainSite", (String) mainProject.getAttribute("projectName"));
                }
                // -get project name

                // get begin date, end date, actual taken time
                if (webIssue.getAttribute("currentStatus").toString().equals("Schedule")) {
                    beginDate = configFileMgr.getWorkingNotStartYet();
                    endDate = configFileMgr.getWorkingNotStartYet();
                    actualTakenTime = configFileMgr.getNotEndYet();

                } else {
                    beginDate = issueMgr.getCreateTimeAssigned(issueId);
                    if (webIssue.getAttribute("actualEndDate") != null) {
                        endDate = (String) webIssue.getAttribute("actualEndDate");
                        String exeHours = webIssue.getAttribute("actualFinishTime").toString();
                        Double execHr = 0.0;
                        int execIntHr = 0;
                        execHr = new Double(exeHours).doubleValue();
                        if (execHr < 1) {
                            execHr = 1.0;
                        }
                        execIntHr = execHr.intValue();
                        actualTakenTime = dateAndTime.getDaysHourMinuteHex(execIntHr);
                    } else {
                        endDate = configFileMgr.getNotEndYet();
                        actualTakenTime = configFileMgr.getNotEndYet();
                    }
                }
                // -get begin date, end date, actual taken time

                // get type of schedule & cause
                cause = (String) webIssue.getAttribute("issueDesc");
                if (webIssue.getAttribute("issueTitle").toString().equals("Emergency")) {
                    typeOfSchedule = configFileMgr.getJobOrderType("Emergency");
                } else {
                    cause = " \u0628\u0646\u0627\u0621 \u0639\u0644\u0649 \u062C\u062F\u0648\u0644" + (String) webIssue.getAttribute("issueTitle");
                    typeOfSchedule = configFileMgr.getJobOrderType("Planned");
                }

                if (!webIssue.getAttribute("scheduleType").toString().equals("NONE")) {
                    typeOfSchedule = "(\u062E\u0627\u0631\u062C\u0649)" + typeOfSchedule;

                }

                if (!(cause == null || cause.equalsIgnoreCase("UL") || cause.equalsIgnoreCase("null") || cause.equals("No Description"))) {
                    parameters.put("cause", cause);
                }
                // -get type of schedule & cause

                // get shift
                groupbyShift = (String) webIssue.getAttribute("faId");
                shift = groupbyShift.substring(2);

                if (!customizeJOMgr.getCustomization("Shift").display()) {
                    shift = "-----";
                }
                // -get shift

                // get status
                if (webIssue.getAttribute("currentStatus").toString().equals("Finished")) {
                    caseStatus = configFileMgr.getMaintenanceFinish();
                } else {
                    caseStatus = configFileMgr.getMaintenanceNotEnd();
                }
                // -get status

                // get reading
                reading = readingRateUnitMgr.getReadingCounter((String) webIssue.getAttribute("id"));
                equipType = maintainableMgr.getUnitType((String) webIssue.getAttribute("unitId"));

                if (equipType.equalsIgnoreCase("fixed")) {
                    unit = "\u0633\u0627\u0639\u0629";

                } else {
                    unit = "\u0643\u064A\u0644\u0648\u0645\u062A\u0631";

                }
                // -get reading

                // get itemsList
                if (issueTitle.equalsIgnoreCase("External") || issueTitle.equalsIgnoreCase("Emergency")) {
//                    itemList = actualItemMgr.getActualItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                    itemList = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());

                } else {

                    unitScheduleMgr = UnitScheduleMgr.getInstance();
                    unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                    scheduleWbo = scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());

                    maintenanceItemMgr = MaintenanceItemMgr.getInstance();

                    localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                    quantfItemList = quantifiedMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());

                    for (int i = 0; i < quantfItemList.size(); i++) {
                        tempWbo = (WebBusinessObject) quantfItemList.get(i);
                        String itemID = (String) tempWbo.getAttribute("itemId");
                        String is_Direct = (String) tempWbo.getAttribute("isDirectPrch");
                        itemCode = itemID.split("-");

                        if (is_Direct.equals("0")) {
                            if (itemCode.length > 1) {
                                item = itemsMgr.getOnSingleKey(itemID);
                                tempWbo.setAttribute("itemCode", item.getAttribute("itemCodeByItemForm"));

                            } else {
                                item = itemsMgr.getOnObjectByKey(itemID);
                                tempWbo.setAttribute("itemCode", item.getAttribute("itemCode"));

                            }

                            tempWbo.setAttribute("itemCode", item.getAttribute("itemCode"));
                            tempWbo.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));

                        } else {

                            try {
                                loaclitems = localStoresItemsMgr.getOnArbitraryKey(itemID, "key1");

                            } catch (SQLException ex) {
                                Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);

                            } catch (Exception ex) {
                                Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                            for (int x = 0; x < loaclitems.size(); x++) {
                                item = (WebBusinessObject) loaclitems.get(x);
                                tempWbo.setAttribute("itemCode", item.getAttribute("itemCode"));
                                tempWbo.setAttribute("itemDscrptn", item.getAttribute("itemName"));
                            }
                        }
                    }

                    if (quantfItemList.size() <= 0) {
                        quantfItemList = configureTypeMgr.getConfigItemBySchedule(scheduleWbo.getAttribute("periodicID").toString());

                    }

                    itemList = quantfItemList;
                }
                // -get itemsList

                if (itemList.size() > 0) {
                    Enumeration items = itemList.elements();
                    issueWbo = null;
                    WebBusinessObject tempItemWbo = null;
                    WebBusinessObject itemWbo = null;
                    WebBusinessObject wbo2 = null;
                    itemName = null;
                    int index2 = 0;

                    String unitSchedule = (String) webIssue.getAttribute("unitScheduleID");
                    Vector avgPrice = avgpriceMgr.getItemsWithAvgPrice(unitSchedule);

                    costNameField = (lang.equalsIgnoreCase("Ar")) ? "COSTNAME" : "LATIN_NAME";

                    while (items.hasMoreElements()) {
                        itemWbo = new WebBusinessObject();
                        issueWbo = (WebBusinessObject) items.nextElement();
                        itemCode = issueWbo.getAttribute("itemId").toString().split("-");

                        tempItemWbo = new WebBusinessObject();
                        tempItemWbo.setAttribute("itemCode", (String) issueWbo.getAttribute("itemId"));

                        if (itemCode.length > 1) {
                            itemWbo = itemsMgr.getOnSingleKey(issueWbo.getAttribute("itemId").toString());

                        } else {
                            itemWbo = itemsMgr.getOnObjectByKey(issueWbo.getAttribute("itemId").toString());

                        }

                        try {
                            itemName = (String) itemWbo.getAttribute("itemDscrptn");

                        } catch (Exception ex) {
                            itemName = "\u0642\u0637\u0639\u0629 \u0627\u0644\u063A\u064A\u0627\u0631 \u063A\u064A\u0631 \u0645\u0648\u062C\u0648\u062F\u0629 \u0628\u0627\u0644\u0645\u062E\u0627\u0632\u0646";

                        }

                        tempItemWbo.setAttribute("itemName", itemName);
                        tempItemWbo.setAttribute("itemQuantity", (String) issueWbo.getAttribute("itemQuantity"));

                        costCenterName = null;
                        String attValue = (String) issueWbo.getAttribute("attachedOn");

                        if (!attValue.equals("2")) {
                            CostCentersMgr costCenterMgr = CostCentersMgr.getInstance();
                            costCenterWbo = new WebBusinessObject();
                            costCentersVec = new Vector();

                            try {
                                costCentersVec = costCenterMgr.getOnArbitraryKey(attValue, "key");
                                costCenterWbo = (WebBusinessObject) costCentersVec.elementAt(0);

                            } catch (Exception exc) {
                                costCenterName = "\u0644\u0627 \u064A\u0648\u062C\u062F";

                            }

                            try {
                                costCenterName = costCenterWbo.getAttribute(costNameField).toString();

                            } catch (Exception ex) {
                                costCenterName = "\u0644\u0627 \u064A\u0648\u062C\u062F";

                            }

                        } else {
                            costCenterName = "\u0644\u0627 \u064A\u0648\u062C\u062F";

                        }

                        tempItemWbo.setAttribute("costCenterName", costCenterName);

                        try {
                            wbo2 = (WebBusinessObject) avgPrice.get(index2);
                            if (wbo2.getAttribute("total") != null) {
                                costStr = (String) wbo2.getAttribute("total");

                            } else {
                                costStr = "0";

                            }

                        } catch (Exception ex) {
                            costStr = "0";
                        }
                        totalCostItems += Double.valueOf(costStr);

                        index2++;
                        String price = "0";

                        try {
                            price = (String) wbo2.getAttribute("price");

                            if (price == null) {
                                price = "0";
                            }

                        } catch (Exception ex) {
                            price = "0";
                        }
                        double price_ = Tools.round(Double.parseDouble(price), 2, BigDecimal.ROUND_HALF_UP);
                        double costStr_ = Tools.round(Double.parseDouble(costStr), 2, BigDecimal.ROUND_HALF_UP);
                        tempItemWbo.setAttribute("cost", Tools.getCurrency(price));
                        tempItemWbo.setAttribute("totalCost", Tools.getCurrency(costStr));

                        itemVec.add(tempItemWbo);

                    }

                    totalCostStr = Tools.getCurrency(Double.toString(totalCostItems));

                    parameters.put("itemTotalCost", totalCostStr);
                }

                // get labor total cost
                if (tasksList.size() != 0 && empList.size() > 0) {

                    Enumeration employees = empList.elements();
                    while (employees.hasMoreElements()) {

                        laborCost = 0.0;
                        empWbo = (WebBusinessObject) employees.nextElement();

                        try {
                            laborCost = Double.valueOf((String) empWbo.getAttribute("totalCost")).doubleValue();
                        } catch (Exception ex) {
                        }
                        totalCostLabors += laborCost;

                    }

                    totalCostLaborStr = Tools.getCurrency(Double.toString(totalCostLabors));
                    parameters.put("laborTotalCost", totalCostLaborStr);
                }
                // -get labor total cost

                // get complaints
                try {
                    complaints = laborComplaintsMgr.getOnArbitraryKey(issueId, "key1");

                } catch (SQLException ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);

                } catch (Exception ex) {
                    Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);

                }
                // -get complaints

                // get taken action
                webIssueStatus = issueStatusMgr.getIssueStatusFinish(issueId);
                action = null;

                if (webIssueStatus != null) {
                    action = (String) webIssueStatus.getAttribute("actionTaken");
                }

                if (!(action == null || action.equalsIgnoreCase("UL") || action.equalsIgnoreCase("null"))) {
                    parameters.put("takenAction", action);
                }
                // -get taken action

                if (webIssue.getAttribute("scheduleType").equals("External")) {

                    Long iID = new Long(webIssue.getAttribute("id").toString());
                    calendar = Calendar.getInstance();

                    calendar.setTimeInMillis(iID.longValue());
                    Vector vecExternal = null;

                    try {
                        vecExternal = externalJobMgr.getOnArbitraryKey((String) webIssue.getAttribute("id"), "key2");
                    } catch (SQLException ex) {
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    if (vecExternal.size() > 0) {
                        WebBusinessObject wboExternal = (WebBusinessObject) vecExternal.get(0);
                        WebBusinessObject wboSupplier = supplierMgr.getOnSingleKey((String) wboExternal.getAttribute("supplierID"));

                        parameters.put("supplierName", (String) wboSupplier.getAttribute("name"));
                        parameters.put("conversionDate", (String) wboExternal.getAttribute("conversionDate"));
                        parameters.put("laborCost", (String) wboExternal.getAttribute("laborCost"));

                        if (((String) wboExternal.getAttribute("externalType")).equals(ExternalJobMgr.PART)) {
                            parameters.put("externalType", "\u062C\u0632\u0626\u0649");

                        } else {
                            parameters.put("externalType", "\u0643\u0644\u0649");

                        }

                        parameters.put("conversionReason", (String) wboExternal.getAttribute("reason"));

                    }

                }

                if (reading != null) {
                    parameters.put("reading", reading + " " + unit);

                }

                unitWbo = maintainableMgr.getOnSingleKey(
                        (String) unitScheduleWbo.getAttribute("unitId"));

                parameters.put("JODate", JODate);
                parameters.put("businessId", businessId);
                parameters.put("projectName", projectName);
                parameters.put("beginDate", beginDate);
                parameters.put("shift", shift);
                parameters.put("endDate", endDate);
                parameters.put("typeOfSchedule", typeOfSchedule);
                parameters.put("actualTakenTime", actualTakenTime);
                parameters.put("unitName", (String) unitScheduleWbo.getAttribute("unitName"));
                parameters.put("unitNo", (String) unitWbo.getAttribute("unitNo"));
                parameters.put("status", caseStatus);
                parameters.put("tradeName", (String) tradeWbo.getAttribute("tradeName"));

                parameters.put("tasksList", tasksList);
                parameters.put("itemList", itemVec);
                parameters.put("empList", empList);
                parameters.put("complaints", complaints);
                parameters.put("techInspt", request.getParameter("statusNote"));
                jobOrderCosting = totalCostItems + totalCostLabors;
                parameters.put("JOTotalCost", Tools.getCurrency(Double.toString(jobOrderCosting)));

                String repName = "JobOrder";
                if (lang.equals("En")) {
                    repName = "JobOrderEn";
                }
                Tools.createPdfReport(repName, parameters, dataSource, getServletConfig().getServletContext(), response, request);

                break;

            case 28:

                parameters = new HashMap();
                dataSource = new Vector();
                allItems = new Vector();
                allTask = new Vector();

                taskMgr = TaskMgr.getInstance();
                allTask = taskMgr.getTasksUnattachedToParts();
                parameters.put("lang", lang);

                Tools.createPdfReport("tasksWithoutItems", parameters, allTask, getServletConfig().getServletContext(), response, request);
                break;

            case 29:

                parameters = new HashMap();
                dataSource = new Vector();
                allItems = new Vector();
                allTask = new Vector();
                taskId = null;
                WebBusinessObject itemWbo = new WebBusinessObject();
                WebBusinessObject itemWbo2 = new WebBusinessObject();
                itemsMgr = ItemsMgr.getInstance();
                itemId = null;
                String itemDesc = null;
                ConfigTasksPartsMgr configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();

                taskMgr = TaskMgr.getInstance();
                allTask = taskMgr.getTasksAttachedToParts();
                parameters.put("lang", lang);

                for (int i = 0; i < allTask.size(); i++) {
                    wbo = (WebBusinessObject) allTask.get(i);
                    taskId = (String) wbo.getAttribute("id");
                    try {
                        allItems = configTasksPartsMgr.getOnArbitraryKey(taskId, "key1");
                    } catch (SQLException ex) {
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    for (int j = 0; j < allItems.size(); j++) {
                        itemWbo = (WebBusinessObject) allItems.get(j);
                        try {
                            itemWbo2 = (WebBusinessObject) (itemsMgr.getOnArbitraryKey(itemWbo.getAttribute("itemId").toString(), "key6").get(0));

                            itemWbo.setAttribute("itemDesc", itemWbo2.getAttribute("itemDscrptn").toString());
                        } catch (SQLException ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                            itemWbo.setAttribute("itemDesc", "---");
                        } catch (Exception ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                            itemWbo.setAttribute("itemDesc", "---");
                        }

                    }

                    wbo.setAttribute("items", allItems);
                }
                reportName = "tasksHaveItemsAr";
                if (lang.equals("En")) {
                    reportName = "tasksHaveItemsEn";
                }
                Tools.createPdfReport(reportName, parameters, allTask, getServletConfig().getServletContext(), response, request);
                break;

            case 30:
                parameters = new HashMap();
                WebBusinessObject taskWbo = null,
                 scheduleTasksWbo = null;
                schedulesVec = null;
                Vector allSchedulesVec = new Vector(),
                 scheduleTasksVec = null;
                searchBy = request.getParameter("searchBy");
                String frequencyTypeCode = null,
                 frequencyType = null,
                 withItems = request.getParameter("withItems");

                unitName = null;
                unitWbo = null;

                // handling labels in report
                unitNameLbl = "";
                unitNamesStr = "";

                if (searchBy != null && searchBy.equalsIgnoreCase("brand")) {

                    brand = request.getParameterValues("brand");
                    brandAll = request.getParameter("brandAll");

                    for (int i = 0; i < brand.length; i++) {
                        try {
                            brandId = brand[i];
                            unitWbo = maintainableMgr.getOnSingleKey(brandId);

                            schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(brandId, "key4", "Cat", "key5");

                            for (int j = 0; j < schedulesVec.size(); j++) {
                                scheduleWbo = (WebBusinessObject) schedulesVec.get(j);

                                /* prepare and set frequency description for schedule */
                                frequencyTypeCode = (String) scheduleWbo.getAttribute("frequencyType");

                                if (frequencyTypeCode.equals("1")) {
                                    frequencyType = new String("Day");

                                } else if (frequencyTypeCode.equals("2")) {
                                    frequencyType = new String("Week");

                                } else if (frequencyTypeCode.equals("3")) {
                                    frequencyType = new String("Month");

                                } else if (frequencyTypeCode.equals("4")) {
                                    frequencyType = new String("Year");

                                } else if (frequencyTypeCode.equals("5")) {
                                    frequencyType = new String("kilometer");

                                } else {
                                    frequencyType = new String("Hour");

                                }

                                scheduleWbo.setAttribute("frequencyDesc",
                                        (String) scheduleWbo.getAttribute("frequency")
                                        + " " + frequencyType);
                                /* -prepare and set frequency description for schedule */

 /* prepare and set task list for schedule if needed */
                                if (withItems != null && withItems.equalsIgnoreCase("on")) {
                                    scheduleId = (String) scheduleWbo.getAttribute("periodicID");
                                    scheduleTasksVec = scheduleTasksMgr.getOnArbitraryKey(scheduleId, "key1");

                                    for (int k = 0; k < scheduleTasksVec.size(); k++) {
                                        scheduleTasksWbo = (WebBusinessObject) scheduleTasksVec.get(k);
                                        taskWbo = taskMgr.getOnSingleKey((String) scheduleTasksWbo.
                                                getAttribute("codeTask"));

                                        scheduleTasksWbo.setAttribute("taskName",
                                                (String) taskWbo.getAttribute("name"));

                                    }

                                    scheduleWbo.setAttribute("taskVec", scheduleTasksVec);
                                }
                                /* -prepare and set task list for schedule if needed */

                                // set brand Id & name in schedule Wbo for grouping
                                scheduleWbo.setAttribute("equipId", brandId);
                                scheduleWbo.setAttribute("equipName",
                                        (String) unitWbo.getAttribute("unitName"));

                            }

                        } catch (SQLException ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        allSchedulesVec.addAll(schedulesVec);

                    }

                    if (!brandAll.equals("yes")) {
                        String s = "";
                        tempVec = parentUnitMgr.getParensName(brand);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();

                            if (tempVec.size() > 1) {
                                s += " , ...";
                            }
                        }

                        unitNamesStr = s;

                    } else {
                        unitNamesStr = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0645\u0627\u0631\u0643\u0627\u062A" : "All Models";
                    }

                    unitNameLbl = lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0627\u0631\u0643\u0629" : "Model";

                } else if (searchBy != null && searchBy.equalsIgnoreCase("mainType")) {

                    mainType = request.getParameterValues("mainType");
                    mainTypeAll = request.getParameter("mainTypeAll");

                    for (int i = 0; i < mainType.length; i++) {
                        try {
                            mainTypeId = mainType[i];
                            unitWbo = mainCategoryTypeMgr.getOnSingleKey(mainTypeId);

                            schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(mainTypeId, "key7", "mainCat", "key5");

                            for (int j = 0; j < schedulesVec.size(); j++) {
                                scheduleWbo = (WebBusinessObject) schedulesVec.get(j);

                                /* prepare and set frequency description for schedule */
                                frequencyTypeCode = (String) scheduleWbo.getAttribute("frequencyType");

                                if (frequencyTypeCode.equals("1")) {
                                    frequencyType = new String("Day");

                                } else if (frequencyTypeCode.equals("2")) {
                                    frequencyType = new String("Week");

                                } else if (frequencyTypeCode.equals("3")) {
                                    frequencyType = new String("Month");

                                } else if (frequencyTypeCode.equals("4")) {
                                    frequencyType = new String("Year");

                                } else if (frequencyTypeCode.equals("5")) {
                                    frequencyType = new String("kilometer");

                                } else {
                                    frequencyType = new String("Hour");

                                }

                                scheduleWbo.setAttribute("frequencyDesc",
                                        (String) scheduleWbo.getAttribute("frequency")
                                        + " " + frequencyType);
                                /* -prepare and set frequency description for schedule */

 /* prepare and set task list for schedule if needed */
                                if (withItems != null && withItems.equalsIgnoreCase("on")) {
                                    scheduleId = (String) scheduleWbo.getAttribute("periodicID");
                                    scheduleTasksVec = scheduleTasksMgr.getOnArbitraryKey(scheduleId, "key1");

                                    for (int k = 0; k < scheduleTasksVec.size(); k++) {
                                        scheduleTasksWbo = (WebBusinessObject) scheduleTasksVec.get(k);
                                        taskWbo = taskMgr.getOnSingleKey((String) scheduleTasksWbo.
                                                getAttribute("codeTask"));

                                        scheduleTasksWbo.setAttribute("taskName",
                                                (String) taskWbo.getAttribute("name"));

                                    }

                                    scheduleWbo.setAttribute("taskVec", scheduleTasksVec);
                                }
                                /* -prepare and set task list for schedule if needed */

                                // set main type Id & name in schedule Wbo for grouping
                                scheduleWbo.setAttribute("equipId", mainTypeId);
                                scheduleWbo.setAttribute("equipName",
                                        (String) unitWbo.getAttribute("typeName"));

                            }

                        } catch (SQLException ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        allSchedulesVec.addAll(schedulesVec);

                    }

                    if (!mainTypeAll.equals("yes")) {
                        String s = "";
                        tempVec = mainCategoryTypeMgr.getMainTypeName(mainType);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString();

                            if (tempVec.size() > 1) {
                                s += " , ...";
                            }
                        }

                        unitNamesStr = s;

                    } else {
                        unitNamesStr = lang.equalsIgnoreCase("Ar") ? "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629" : "All Main Types";
                    }

                    unitNameLbl = lang.equalsIgnoreCase("Ar") ? "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u0649" : "Main Type";
                } else {

                    unitId = request.getParameter("unitId");

                    try {
                        unitWbo = maintainableMgr.getOnSingleKey(unitId);
                        schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(unitId, "key2", "Eqp", "key5");

                        for (int j = 0; j < schedulesVec.size(); j++) {
                            scheduleWbo = (WebBusinessObject) schedulesVec.get(j);

                            /* prepare and set frequency description for schedule */
                            frequencyTypeCode = (String) scheduleWbo.getAttribute("frequencyType");

                            if (frequencyTypeCode.equals("1")) {
                                frequencyType = new String("Day");

                            } else if (frequencyTypeCode.equals("2")) {
                                frequencyType = new String("Week");

                            } else if (frequencyTypeCode.equals("3")) {
                                frequencyType = new String("Month");

                            } else if (frequencyTypeCode.equals("4")) {
                                frequencyType = new String("Year");

                            } else if (frequencyTypeCode.equals("5")) {
                                frequencyType = new String("kilometer");

                            } else {
                                frequencyType = new String("Hour");

                            }

                            scheduleWbo.setAttribute("frequencyDesc",
                                    (String) scheduleWbo.getAttribute("frequency")
                                    + " " + frequencyType);
                            /* -prepare and set frequency description for schedule */

 /* prepare and set task list for schedule if needed */
                            if (withItems != null && withItems.equalsIgnoreCase("on")) {
                                scheduleId = (String) scheduleWbo.getAttribute("periodicID");
                                scheduleTasksVec = scheduleTasksMgr.getOnArbitraryKey(scheduleId, "key1");

                                for (int k = 0; k < scheduleTasksVec.size(); k++) {
                                    scheduleTasksWbo = (WebBusinessObject) scheduleTasksVec.get(k);
                                    taskWbo = taskMgr.getOnSingleKey((String) scheduleTasksWbo.
                                            getAttribute("codeTask"));

                                    scheduleTasksWbo.setAttribute("taskName",
                                            (String) taskWbo.getAttribute("name"));

                                }

                                scheduleWbo.setAttribute("taskVec", scheduleTasksVec);
                            }
                            /* -prepare and set task list for schedule if needed */

                            // set brand Id & name in schedule Wbo for grouping
                            scheduleWbo.setAttribute("equipId", unitId);
                            scheduleWbo.setAttribute("equipName",
                                    (String) unitWbo.getAttribute("unitName"));

                        }

                    } catch (SQLException ex) {
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    allSchedulesVec.addAll(schedulesVec);

                    unitNamesStr = (String) unitWbo.getAttribute("unitName");
                    unitNameLbl = lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment";

                }

                parameters.put("unitNameLbl", unitNameLbl);
                parameters.put("unitNamesStr", unitNamesStr);

                // create and open PDF report in browser
                context = getServletConfig().getServletContext();
                reportName = (withItems != null && withItems.equalsIgnoreCase("on")) ? "schedulesByEquipment" : "schedulesByEquipmentWithoutTasks";
                Tools.createPdfReport(reportName, parameters, allSchedulesVec, context, response, request);

                break;

            case 31:

                parameters = new HashMap();
                dataSource = new Vector();

                String scheduleCase,
                 executionCase,
                 onHoldCase,
                 issueID,
                 ScheduleUnitId,
                 MaintenanceTitle;

                scheduleCase = "\u0644\u0645 \u064A\u0628\u062F\u0623 \u0628\u0639\u062F";
                executionCase = "\u062A\u062D\u062A \u0627\u0644\u062A\u0646\u0641\u064A\u0630";
                onHoldCase = "\u062A\u062D\u062A \u0627\u0644\u0625\u0631\u062C\u0627\u0621";

                Vector weeklyIssuesByEmgVec = null,
                 weeklyIssuesBySchVec = null;

                Calendar weekCalendar = Calendar.getInstance();
                Calendar beginWeekCalendar = Calendar.getInstance();
                Calendar endWeekCalendar = Calendar.getInstance();

                int dayOfWeekValue = weekCalendar.getTime().getDay();

                beginWeekCalendar = (Calendar) weekCalendar.clone();
                endWeekCalendar = (Calendar) weekCalendar.clone();
                beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
                endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

                weeklyIssuesByEmgVec = issueMgr.getIssuesListInRangeByEmg(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()), session);
                weeklyIssuesBySchVec = issueMgr.getIssuesListInRangeBySch(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()), session);

                weeklyIssuesByEmgVec.addAll(weeklyIssuesBySchVec);

                for (Object obj : weeklyIssuesByEmgVec) {
                    webIssue = (WebIssue) obj;
                    wbo = new WebBusinessObject();

                    unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(webIssue.getAttribute("unitScheduleID").toString());

                    issueID = (String) webIssue.getAttribute("id");
                    String sBID = webIssue.getAttribute("businessID").toString();
                    String sBIDByDate = webIssue.getAttribute("businessIDbyDate").toString();
                    ScheduleUnitId = issueMgr.getScheduleUnitId(issueID);
                    MaintenanceTitle = issueMgr.getMaintenanceTitle(ScheduleUnitId);

                    if (!webIssue.getAttribute("currentStatus").toString().equals("Finished")
                            && !webIssue.getAttribute("currentStatus").toString().equals("Canceled")
                            && !webIssue.getAttribute("currentStatus").toString().equals("Removed")) {

                        wbo.setAttribute("issueNoByDate", sBID + " / " + sBIDByDate);
                        wbo.setAttribute("maintenanceTitle", MaintenanceTitle);
                        wbo.setAttribute("unitName",
                                unitScheduleWbo.getAttribute("unitName").toString());

                        if (webIssue.getAttribute("currentStatus").toString().equals("Schedule")) {
                            wbo.setAttribute("status", scheduleCase);

                        } else if (webIssue.getAttribute("currentStatus").toString().equals("Assigned")) {
                            wbo.setAttribute("status", executionCase);

                        } else if (webIssue.getAttribute("currentStatus").toString().equals("Onhold")) {
                            wbo.setAttribute("status", onHoldCase);

                        }

                        wbo.setAttribute("expectedBeginDate",
                                webIssue.getAttribute("expectedBeginDate"));

                        wbo.setAttribute("expectedEndDate",
                                webIssue.getAttribute("expectedEndDate"));

                        dataSource.add(wbo);

                    }
                }

                Tools.createPdfReport("weeklyJobOrders", parameters, dataSource, getServletConfig().getServletContext(), response, request);
                break;

            case 32:
                String mainCatId = (String) request.getParameter("mainCatId");
                scheduleId = (String) request.getParameter("scheduleId");
                String siteId = (String) request.getParameter("siteId");
                String sUnitId = (String) request.getParameter("unitId");
                ReadingByScheduleMgr readingByScheduleMgr = ReadingByScheduleMgr.getInstance();
                List dataList = new ArrayList();
                Vector siteV = new Vector();
                siteWbo = new WebBusinessObject();
                parameters = new HashMap();
                Double countJob = 0.0;
                int maintenanceDue = 0;

                if (mainCatId != null && !mainCatId.equals("all")) {
                    parameters.put("mainCatName", mainCategoryTypeMgr.
                            getMainTypeNameById(mainCatId));

                } else if (mainCatId.equals("all")) {
                    parameters.put("mainCatName", "\u0627\u0644\u0643\u0644");

                }

                if (scheduleId != null && !scheduleId.equals("")) {
                    scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                    parameters.put("scheduleName", (String) scheduleWbo.
                            getAttribute("maintenanceTitle"));

                } else {
                    parameters.put("scheduleName", "\u0627\u0644\u0643\u0644");

                }

                if (sUnitId != null && !sUnitId.equals("")) {
                    unitWbo = maintainableMgr.getOnSingleKey(sUnitId);
                    parameters.put("unitName", (String) unitWbo.
                            getAttribute("unitName"));

                } else {
                    parameters.put("unitName", "\u0627\u0644\u0643\u0644");

                }

                if (siteId != null && !siteId.equals("")) {
                    ProjectMgr siteMgr = ProjectMgr.getInstance();
                    siteWbo = (WebBusinessObject) siteMgr.getOnSingleKey(siteId);
                    if (siteWbo.getAttribute("mainProjId").toString().equals("0")) {
                        try {
                            siteV = siteMgr.getOnArbitraryKey(siteWbo.getAttribute("projectID").toString(), "key2");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    parameters.put("siteName", (String) siteWbo.getAttribute("projectName"));

                } else {
                    parameters.put("siteName", "\u0627\u0644\u0643\u0644");

                }

                ResultDataReportBean resultDataReportBean;
                AverageUnitMgr avgUnitMgr = AverageUnitMgr.getInstance();
                WebBusinessObject wboAvgUnit = new WebBusinessObject();
                ScheduleMgr schMgr = ScheduleMgr.getInstance();
                List viewList = new ArrayList();
                WebBusinessObject wboSch;
                if (siteV.size() > 0) {
                    siteV.add(siteWbo);
                    for (int y = 0; y < siteV.size(); y++) {
                        WebBusinessObject siteObj = new WebBusinessObject();
                        siteObj = (WebBusinessObject) siteV.get(y);
                        siteId = siteObj.getAttribute("projectID").toString();
                        dataList = readingByScheduleMgr.getScheduleWorkByMainType(mainCatId, siteId, sUnitId, scheduleId);
                        for (int i = 0; i < dataList.size(); i++) {
                            try {
                                ResultDataReportBean results = new ResultDataReportBean();
                                resultDataReportBean = new ResultDataReportBean();
                                wboSch = new WebBusinessObject();
                                resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                                Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                                MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                                WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                                resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                                wboAvgUnit = (WebBusinessObject) avgUnitV.get(0);
                                int currReading = new Integer(wboAvgUnit.getAttribute("current_Reading").toString());
                                int prvReading = new Integer(wboAvgUnit.getAttribute("acual_Reading").toString());
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                                calendar = Calendar.getInstance();
                                java.util.Date resultdate = new Date(new Long(sEntryDate));
                                calendar.setTime(resultdate);
                                String sEntryTime = sdf.format(calendar.getTime());
                                java.util.Date entDate = sdf.parse(sEntryTime);
                                resultDataReportBean.setCurrentReadingDate(entDate);

                                String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                                calendar = Calendar.getInstance();
                                java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                                calendar.setTime(resultPrvdate);
                                String sPrvTime = sdf.format(calendar.getTime());
                                java.util.Date prvDate = sdf.parse(sPrvTime);
                                resultDataReportBean.setPrvReadingDate(prvDate);

                                // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                                resultDataReportBean.setLastReadingMachine(currReading);
                                resultDataReportBean.setCurrReading(currReading);
                                resultDataReportBean.setPrvReading(prvReading);
                                // resultDataReportBean.setReadingTravel(distTravel);
                                IssueMgr issueMgr = IssueMgr.getInstance();
                                Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(), "key4");
                                WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
                                java.util.Date issueDate = sdf.parse(wboIssue.getAttribute("creationTime").toString());
                                SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
                                sDate = fDate.format(issueDate);
                                resultDataReportBean.setJobOrderDate(sDate);
                                IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
                                String sIssueId = wboIssue.getAttribute("id").toString();
                                WebBusinessObject wboIssCountRead = null;
                                int counterReading = 0;

                                try {
                                    wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
                                    counterReading = new Integer(wboIssCountRead.getAttribute("counterReading").toString()).intValue();
                                } catch (NullPointerException ex) {
                                    counterReading = 0;
                                }
                                unitScheduleMgr = UnitScheduleMgr.getInstance();
                                unitScheduleWbo = new WebBusinessObject();
                                unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
                                ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                                scheduleWbo = new WebBusinessObject();
                                scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                                resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
                                resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());

                                resultDataReportBean.setReadingJobOrder(counterReading);
                                resultDataReportBean.setDiffReading(currReading - counterReading);
                                results = resultDataReportBean;
                                //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
                                //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
                                //                        resultDataReportBean.setSchFrec(shKMm);

                                // compute maintenance due
                                if (results.getWhichCloser() != 0.0) {
                                    countJob = new Double((results.getCurrReading() - results.getReadingJobOrder())).doubleValue() / new Double(results.getWhichCloser()).doubleValue();

                                    if (countJob < 1.0 && (countJob > 0.85 || countJob == 0.85)) {
                                        maintenanceDue = 1;

                                    } else if (countJob == 1 || countJob > 1) {
                                        maintenanceDue = (int) (countJob).intValue();

                                    } else if (countJob == 0.0 || countJob < 0.85) {
                                        maintenanceDue = 0;

                                    }

                                    results.setMaintenanceDue(maintenanceDue);

                                }

                                viewList.add(results);

                            } catch (SQLException ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }

                } else {
                    dataList = readingByScheduleMgr.getScheduleWorkByMainType(mainCatId, siteId, sUnitId, scheduleId);

                    for (int i = 0; i < dataList.size(); i++) {
                        try {
                            ResultDataReportBean results = new ResultDataReportBean();
                            resultDataReportBean = new ResultDataReportBean();
                            wboSch = new WebBusinessObject();
                            resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                            Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                            MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                            WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                            resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                            wboAvgUnit = (WebBusinessObject) avgUnitV.get(0);
                            int currReading = new Integer(wboAvgUnit.getAttribute("current_Reading").toString());
                            int prvReading = new Integer(wboAvgUnit.getAttribute("acual_Reading").toString());
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                            calendar = Calendar.getInstance();
                            java.util.Date resultdate = new Date(new Long(sEntryDate));
                            calendar.setTime(resultdate);
                            String sEntryTime = sdf.format(calendar.getTime());
                            java.util.Date entDate = sdf.parse(sEntryTime);
                            resultDataReportBean.setCurrentReadingDate(entDate);

                            String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                            calendar = Calendar.getInstance();
                            java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                            calendar.setTime(resultPrvdate);
                            String sPrvTime = sdf.format(calendar.getTime());
                            java.util.Date prvDate = sdf.parse(sPrvTime);
                            resultDataReportBean.setPrvReadingDate(prvDate);

                            // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                            resultDataReportBean.setLastReadingMachine(currReading);
                            resultDataReportBean.setCurrReading(currReading);
                            resultDataReportBean.setPrvReading(prvReading);
                            // resultDataReportBean.setReadingTravel(distTravel);
                            IssueMgr issueMgr = IssueMgr.getInstance();
                            Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(), "key4");
                            WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
                            java.util.Date issueDate = sdf.parse(wboIssue.getAttribute("creationTime").toString());
                            SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
                            sDate = fDate.format(issueDate);
                            resultDataReportBean.setJobOrderDate(sDate);
                            IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
                            String sIssueId = wboIssue.getAttribute("id").toString();
                            WebBusinessObject wboIssCountRead = null;
                            int counterReading = 0;
                            try {
                                wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
                                counterReading = new Integer(wboIssCountRead.getAttribute("counterReading").toString()).intValue();
                            } catch (NullPointerException ex) {
                                counterReading = 0;
                            }
                            unitScheduleMgr = UnitScheduleMgr.getInstance();
                            unitScheduleWbo = new WebBusinessObject();
                            unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
                            ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                            scheduleWbo = new WebBusinessObject();
                            scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                            resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
                            resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());

                            resultDataReportBean.setReadingJobOrder(counterReading);
                            resultDataReportBean.setDiffReading(currReading - counterReading);
                            results = resultDataReportBean;
                            //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
                            //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
                            //                        resultDataReportBean.setSchFrec(shKMm);

                            // compute maintenance due
                            if (results.getWhichCloser() != 0.0) {
                                countJob = new Double((results.getCurrReading() - results.getReadingJobOrder())).doubleValue() / new Double(results.getWhichCloser()).doubleValue();

                                if (countJob < 1.0 && (countJob > 0.85 || countJob == 0.85)) {
                                    maintenanceDue = 1;

                                } else if (countJob == 1 || countJob > 1) {
                                    maintenanceDue = (int) (countJob).intValue();

                                } else if (countJob == 0.0 || countJob < 0.85) {
                                    maintenanceDue = 0;

                                }

                                results.setMaintenanceDue(maintenanceDue);

                            }

                            viewList.add(results);

                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                String stat = (String) request.getSession().getAttribute("currentMode");
                if (stat.equals("En")) {
                    Tools.createPdfBeanReport("equipmentReadingsEnglish", parameters, viewList, getServletContext(), response, request);
                } else {
                    Tools.createPdfBeanReport("equipmentReadings", parameters, viewList, getServletContext(), response, request);
                }
                break;

            case 33:
                String groupBy = request.getParameter("groupBy");
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                ArrayList clientComplaintList = issueByComplaintMgr.getClientComplaintList(groupBy, lang, beginDate, endDate);
                request.setAttribute("clientComplaintList", clientComplaintList);
                this.createClientComplaintsPdfReport(request, response);
                break;

            case 34:
                parameters = new HashMap();

                ClientMgr clientMgr = ClientMgr.getInstance();
                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                ReservationMgr reservationMgr = ReservationMgr.getInstance();
                AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                CommentsMgr commentsMgr = CommentsMgr.getInstance();
                CampaignMgr campaignMgr = CampaignMgr.getInstance();
                ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                ClientComplaintsMgr.getInstance().updateClientComplaintsType();

                Vector clientData = new Vector();
                Vector soldUnits = new Vector();
                Vector reservedUnit = new Vector();
                Vector products = new Vector();
                Vector appointments = new Vector();
                Vector directFollows = new Vector();
                Vector comments = new Vector();
                Vector seasons = new Vector();
                complaints = new Vector();

                String clientId = request.getParameter("clientId");
                String objectType = request.getParameter("objectType");

                wbo = new WebBusinessObject();
                wbo = clientMgr.getOnSingleKey(clientId);

                if (wbo.getAttribute("clientSsn") == null || wbo.getAttribute("clientSsn").equals("")) {
                    wbo.setAttribute("clientSsn", "لا يوجد");
                }

                if (wbo.getAttribute("address") == null || wbo.getAttribute("address").equals("")) {
                    wbo.setAttribute("address", "لا يوجد");
                }

                if (wbo.getAttribute("gender") == null || wbo.getAttribute("gender").equals("")) {
                    wbo.setAttribute("gender", "لا يوجد");
                }

                if (wbo.getAttribute("birthDate") == null || wbo.getAttribute("birthDate").equals("")) {
                    wbo.setAttribute("birthDate", "لا يوجد");
                } else {
                    wbo.setAttribute("birthDate", wbo.getAttribute("birthDate").toString().substring(0, 10));
                }

                if (wbo.getAttribute("matiralStatus") == null || wbo.getAttribute("matiralStatus").equals("")) {
                    wbo.setAttribute("matiralStatus", "لا يوجد");
                }

                if (wbo.getAttribute("partner") == null || wbo.getAttribute("partner").equals("") || wbo.getAttribute("partner").equals(" ")) {
                    wbo.setAttribute("partner", "لا يوجد");
                }

                //Get Client Job
                if (wbo.getAttribute("job") != null && !wbo.getAttribute("job").equals("")) {
                    String jobCode = (String) wbo.getAttribute("job");

                    WebBusinessObject wbo5 = tradeMgr.getOnSingleKey("key2", jobCode);
                    if (wbo5 != null) {
                        wbo.setAttribute("jobName", wbo5.getAttribute("tradeName"));
                    } else {
                        wbo.setAttribute("jobName", "لم يتم الإختيار");
                    }
                }

                if (wbo.getAttribute("option1") == null || wbo.getAttribute("option1").equals("") || wbo.getAttribute("option1").equals(" ")) {
                    wbo.setAttribute("option1", "لا يوجد");
                } else {
                    if (wbo.getAttribute("option1").equals("1")) {
                        wbo.setAttribute("option1", "لا");
                    } else {
                        wbo.setAttribute("option1", "نعم");
                    }
                }

                if (wbo.getAttribute("phone") == null || wbo.getAttribute("phone").equals("") || wbo.getAttribute("phone").equals(" ")) {
                    wbo.setAttribute("phone", "لا يوجد");
                }

                if (wbo.getAttribute("mobile") == null || wbo.getAttribute("mobile").equals("") || wbo.getAttribute("mobile").equals(" ")) {
                    wbo.setAttribute("mobile", "لا يوجد");
                }

                if (wbo.getAttribute("age") == null || wbo.getAttribute("age").equals("") || wbo.getAttribute("age").equals(" ")) {
                    wbo.setAttribute("age", "لا يوجد");
                }

                if (wbo.getAttribute("email") == null || wbo.getAttribute("email").equals("")) {
                    wbo.setAttribute("email", "لا يوجد");
                }

                if (wbo.getAttribute("option3") == null || wbo.getAttribute("option3").equals("")) {
                    wbo.setAttribute("option3", "لا يوجد");
                }

                if (wbo.getAttribute("option2") == null || wbo.getAttribute("option2").equals("") || wbo.getAttribute("option2").equals(" ")) {
                    wbo.setAttribute("option2", "لا يوجد");
                } else {
                    if (wbo.getAttribute("option2").equals("1")) {
                        wbo.setAttribute("option2", "لا");
                    } else {
                        wbo.setAttribute("option2", "نعم");
                    }
                }

                if (wbo.getAttribute("description") == null || wbo.getAttribute("description").equals("")) {
                    wbo.setAttribute("description", "لا يوجد");
                }

                try {
                    WebBusinessObject emptyWbo;

                    soldUnits = clientProductMgr.getOnArbitraryDoubleKeyOracle(clientId, "key1", "purche", "key4");
                    if (soldUnits.size() == 0) {
                        emptyWbo = new WebBusinessObject();
                        emptyWbo.setAttribute("productName", "لايوجد");
                        emptyWbo.setAttribute("productCategoryName", "لايوجد");
                        emptyWbo.setAttribute("creationTime", "لايوجد");

                        soldUnits.add(emptyWbo);
                    } else {
                        for (int i = 0; i < soldUnits.size(); i++) {
                            WebBusinessObject soldWbo = (WebBusinessObject) soldUnits.get(i);
                            String userName = UserMgr.getInstance().getFullName(soldWbo.getAttribute("createdBy").toString());
                            soldWbo.setAttribute("creationTime", soldWbo.getAttribute("creationTime").toString().substring(0, 10));
                            soldWbo.setAttribute("createdByName", userName);
                        }
                    }

                    reservedUnit = reservationMgr.getOnArbitraryKeyOracle(clientId, "key1");
                    if (reservedUnit.size() == 0) {
                        emptyWbo = new WebBusinessObject();
                        emptyWbo.setAttribute("projectName", "لايوجد");
                        emptyWbo.setAttribute("productName", "لايوجد");
                        emptyWbo.setAttribute("paymentSystem", "لايوجد");
                        emptyWbo.setAttribute("period", "لايوجد");
                        emptyWbo.setAttribute("reservationDate", "لايوجد");
                        emptyWbo.setAttribute("creationTime", "لايوجد");
                        emptyWbo.setAttribute("createdByName", "لايوجد");

                        reservedUnit.add(emptyWbo);
                        wbo.setAttribute("reservations", reservedUnit);

                    } else {
                        Vector reservations = new Vector();

                        for (int i = 0; i < reservedUnit.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) reservedUnit.get(i);
                            tempWbo = projectMgr.getOnSingleKey((String) wbo.getAttribute("projectId"));
                            WebBusinessObject tempWbo2 = projectMgr.getOnSingleKey((String) wbo.getAttribute("projectCategoryId"));

                            wbo.setAttribute("projectName", tempWbo.getAttribute("projectName"));
                            wbo.setAttribute("productName", tempWbo2.getAttribute("projectName"));
                            wbo.setAttribute("reservationDate", wbo.getAttribute("reservationDate").toString().substring(0, 10));
                            wbo.setAttribute("creationTime", wbo.getAttribute("creationTime").toString().substring(0, 10));

                            String userName = UserMgr.getInstance().getFullName(wbo.getAttribute("createdBy").toString());
                            wbo.setAttribute("createdByName", userName);

                            reservations.add(wbo);
                        }
                        wbo.setAttribute("reservations", reservations);
                    }

                    products = clientProductMgr.getOnArbitraryDoubleKeyOracle(clientId, "key1", "interested", "key4");
                    if (products.size() == 0) {
                        emptyWbo = new WebBusinessObject();
                        emptyWbo.setAttribute("productCategoryName", "لايوجد");
                        emptyWbo.setAttribute("productName", "لايوجد");
                        emptyWbo.setAttribute("period", "لايوجد");
                        emptyWbo.setAttribute("paymentSystem", "لايوجد");
                        emptyWbo.setAttribute("note", "لايوجد");
                        emptyWbo.setAttribute("creationTime", "لايوجد");
                        emptyWbo.setAttribute("createdByName", "لايوجد");

                        products.add(emptyWbo);
                    } else {
                        for (int i = 0; i < products.size(); i++) {
                            WebBusinessObject productWbo = (WebBusinessObject) products.get(i);
                            String userName = UserMgr.getInstance().getFullName(productWbo.getAttribute("createdBy").toString());
                            productWbo.setAttribute("creationTime", productWbo.getAttribute("creationTime").toString().substring(0, 10));
                            productWbo.setAttribute("createdByName", userName);
                        }
                    }

                    appointments = appointmentMgr.getAppointmentSorted(clientId);
                    if (appointments.size() == 0) {
                        emptyWbo = new WebBusinessObject();
                        emptyWbo.setAttribute("title", "لايوجد");
                        emptyWbo.setAttribute("appointmentDate", "لايوجد");
                        emptyWbo.setAttribute("comment", "لايوجد");

                        appointments.add(emptyWbo);
                        wbo.setAttribute("appointments", appointments);
                    } else {
                        Vector appointmentsVec = new Vector();

                        for (int i = 0; i < appointments.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) appointments.get(i);

                            wbo.setAttribute("appointmentDate", wbo.getAttribute("appointmentDate").toString().substring(0, 10));

                            appointmentsVec.add(wbo);
                        }

                        wbo.setAttribute("appointments", appointmentsVec);
                    }

                    directFollows = appointmentMgr.getAppointmentsByClientID(clientId);
                    if (directFollows.size() == 0) {
                        emptyWbo = new WebBusinessObject();
                        emptyWbo.setAttribute("userName", "لايوجد");
                        emptyWbo.setAttribute("appointmentDate", "لايوجد");
                        emptyWbo.setAttribute("comment", "لايوجد");
                        emptyWbo.setAttribute("newAppointmentDate", "لايوجد");
                        emptyWbo.setAttribute("note", "لايوجد");
                        emptyWbo.setAttribute("currentStatus", "لايوجد");
                        emptyWbo.setAttribute("currentStatusName", "لايوجد");

                        directFollows.add(emptyWbo);
                        wbo.setAttribute("directFollows", directFollows);
                    } else {
                        Vector directFollowsVec = new Vector();

                        for (int i = 0; i < directFollows.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) directFollows.get(i);

                            wbo.setAttribute("appointmentDate", wbo.getAttribute("appointmentDate").toString().substring(0, 10));
                            wbo.setAttribute("newAppointmentDate", wbo.getAttribute("newAppointmentDate").toString().substring(0, 10));

                            directFollowsVec.add(wbo);
                        }

                        wbo.setAttribute("directFollows", directFollowsVec);
                    }

                    comments = commentsMgr.getCommentsByClientID(clientId);
                    if (comments.size() == 0) {
                        emptyWbo = new WebBusinessObject();
                        emptyWbo.setAttribute("userName", "لايوجد");
                        emptyWbo.setAttribute("commentDate", "لايوجد");
                        emptyWbo.setAttribute("comment", "لايوجد");

                        comments.add(emptyWbo);
                        wbo.setAttribute("comments", comments);
                    } else {
                        Vector commentsVec = new Vector();

                        for (int i = 0; i < comments.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) comments.get(i);

                            wbo.setAttribute("commentDate", wbo.getAttribute("commentDate").toString().substring(0, 10));

                            commentsVec.add(wbo);
                        }

                        wbo.setAttribute("comments", commentsVec);
                    }

                    seasons = clientCampaignMgr.getOnArbitraryKey(clientId, "key2");
                    if (seasons.size() == 0) {
                        emptyWbo = new WebBusinessObject();
                        emptyWbo.setAttribute("campaignTitle", "لايوجد");
                        emptyWbo.setAttribute("reference", "لايوجد");
                        emptyWbo.setAttribute("creationTime", "لايوجد");
                        emptyWbo.setAttribute("createdByName", "لايوجد");

                        seasons.add(emptyWbo);
                        wbo.setAttribute("seasons", seasons);
                    } else {
                        Vector season = new Vector();

                        for (int i = 0; i < seasons.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) seasons.get(i);
                            tempWbo = campaignMgr.getOnSingleKey((String) wbo.getAttribute("campaignId"));

                            wbo.setAttribute("campaignTitle", tempWbo.getAttribute("campaignTitle"));
                            wbo.setAttribute("creationTime", tempWbo.getAttribute("creationTime").toString().substring(0, 10));

                            String userName = UserMgr.getInstance().getFullName(tempWbo.getAttribute("createdBy").toString());
                            wbo.setAttribute("createdByName", userName);

                            season.add(wbo);
                        }
                        wbo.setAttribute("seasons", season);
                    }

                    complaints = issueByComplaintMgr.preparer(issueByComplaintMgr.getOnArbitraryKey(clientId, "key2"));
                    wbo.setAttribute("complaints", complaints);

                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                wbo.setAttribute("soldUnits", soldUnits);
                wbo.setAttribute("products", products);
                clientData.add(wbo);
                if (objectType != null && objectType.equalsIgnoreCase("client")) {
                    Tools.createPdfReport("clientHistory", parameters, clientData, getServletConfig().getServletContext(), response, request);
                } else {
                    Tools.createPdfReport("companyDataSheet", parameters, clientData, getServletConfig().getServletContext(), response, request);
                }

                break;
            case 35:
                servedPage = "/docs/Adminstration/print_form.jsp";
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
        if (opName.equals("resultCostByAvgJO")) {
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

        if (opName.equalsIgnoreCase("EquipmentApprovalGrouping")) {
            return 21;
        }
        if (opName.equals("resulSearchMaintenanceDetails")) {
            return 22;
        }
        if (opName.equals("resultRequestedItemsFromStore")) {
            return 23;
        }
        if (opName.equals("jobOrderByIntervalDate")) {
            return 24;
        }
        if (opName.equals("followUpReportMaintenanceItemsResult")) {
            return 25;
        }
        if (opName.equals("viewPlan")) {
            return 26;
        }
        if (opName.equals("printJobOrder")) {
            return 27;

        }
        if (opName.equals("tasksWithoutItems")) {
            return 28;

        }
        if (opName.equals("tasksWithItems")) {
            return 29;

        }
        if (opName.equals("searchSchedules")) {
            return 30;
        }
        if (opName.equals("printWeeklyJobOrders")) {
            return 31;

        }
        if (opName.equals("equipmentReadings")) {
            return 32;

        }
        if (opName.equals("getClientComplaintList")) {
            return 33;

        }
        if (opName.equals("clientDataSheet")) {
            return 34;
        }
        if (opName.equalsIgnoreCase("getPrintForm")) {
            return 35;
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

    private void createClientComplaintsPdfReport(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String groupBy = request.getParameter("groupBy");
        ArrayList clientComplaintList = (ArrayList) request.getAttribute("clientComplaintList");

        // get Logo
        Hashtable logos = (Hashtable) request.getSession().getAttribute("logos");
        String logoName = (String) logos.get("headReport3");

        String logoPath = getServletContext().getRealPath(Tools.getFileSeparator() + "images" + Tools.getFileSeparator() + logoName);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"UserIncidentsByCriteria.pdf\"");

        JasperReportBuilder report = new JasperReportBuilder();

        StyleBuilder summaryTitleStyle = stl
                .style(Templates.bold12CenteredStyle)
                .setFontName("Arial")
                .setFontSize(14)
                .setBackgroundColor(new Color(0xe0e0ff));

        StyleBuilder columnTitleStyle = stl
                .style()
                .setHorizontalAlignment(HorizontalAlignment.CENTER)
                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                .setFontName("Arial")
                .setBold(Boolean.TRUE)
                .setBackgroundColor(Color.LIGHT_GRAY)
                .setBorder(stl.pen1Point());

        StyleBuilder groupHeaderStyle = stl
                .style()
                .setFontName("Arial")
                .setFontSize(14)
                .setBold(Boolean.TRUE)
                .setAlignment(HorizontalAlignment.RIGHT, VerticalAlignment.MIDDLE);

        HorizontalListBuilder groupHeader = null;

        // adding report columns       
        TextColumnBuilder<String> departmentNameColumn = col.column("\u0627\u0644\u0625\u062F\u0627\u0631\u0629", "departmentName", type.stringType())
                .setHorizontalAlignment(HorizontalAlignment.CENTER);
        TextColumnBuilder<String> senderNameColumn = col.column("\u0627\u0644\u0645\u0631\u0633\u0644", "senderName", type.stringType())
                .setHorizontalAlignment(HorizontalAlignment.CENTER);
        TextColumnBuilder<String> complaintColumn = col.column("\u0627\u0644\u0634\u0643\u0648\u0649", "comments", type.stringType())
                .setHorizontalAlignment(HorizontalAlignment.CENTER);
        TextColumnBuilder<String> complaintAgeColumn = col.column("\u0639\u0645\u0631 \u0627\u0644\u0634\u0643\u0648\u0649", "complaintAge", type.stringType())
                .setHorizontalAlignment(HorizontalAlignment.CENTER);
        TextColumnBuilder<String> clientNameColumn = col.column("\u0627\u0644\u0639\u0645\u064A\u0644", "customerName", type.stringType())
                .setHorizontalAlignment(HorizontalAlignment.CENTER);
        TextColumnBuilder<String> statusNameColumn = col.column("\u062D\u0627\u0644\u0629 \u0627\u0644\u0634\u0643\u0648\u0649", "statusArName", type.stringType())
                .setHorizontalAlignment(HorizontalAlignment.CENTER);
        TextColumnBuilder<String> entryDateColumn = col.column("\u0648\u0642\u062A \u0627\u0644\u0625\u0631\u0633\u0627\u0644", "entryDate", type.stringType())
                .setHorizontalAlignment(HorizontalAlignment.CENTER);

        // setting font to enable rendering of arabic characters in columns
        departmentNameColumn
                .setStyle(stl.style().setVerticalAlignment(VerticalAlignment.MIDDLE).setFontName("Arial"))
                .setHeight(20);
        senderNameColumn
                .setStyle(stl.style().setVerticalAlignment(VerticalAlignment.MIDDLE).setFontName("Arial"))
                .setHeight(20);
        complaintColumn
                .setStyle(stl.style().setVerticalAlignment(VerticalAlignment.MIDDLE).setFontName("Arial"))
                .setHeight(20);
        complaintAgeColumn
                .setStyle(stl.style().setVerticalAlignment(VerticalAlignment.MIDDLE).setFontName("Arial"))
                .setHeight(20);
        clientNameColumn
                .setStyle(stl.style().setVerticalAlignment(VerticalAlignment.MIDDLE).setFontName("Arial"))
                .setHeight(20);
        statusNameColumn
                .setStyle(stl.style().setVerticalAlignment(VerticalAlignment.MIDDLE).setFontName("Arial"))
                .setHeight(20);
        entryDateColumn
                .setStyle(stl.style().setVerticalAlignment(VerticalAlignment.MIDDLE).setFontName("Arial"))
                .setHeight(20);

        // setting font to enable rendering of arabic characters in column titles
        departmentNameColumn.setTitleStyle(columnTitleStyle)
                .setTitleHeight(20);
        senderNameColumn.setTitleStyle(columnTitleStyle)
                .setTitleHeight(20);
        complaintColumn.setTitleStyle(columnTitleStyle)
                .setTitleHeight(20);
        complaintAgeColumn.setTitleStyle(columnTitleStyle)
                .setTitleHeight(20);
        clientNameColumn.setTitleStyle(columnTitleStyle)
                .setTitleHeight(20);
        statusNameColumn.setTitleStyle(columnTitleStyle)
                .setTitleHeight(20);
        entryDateColumn.setTitleStyle(columnTitleStyle)
                .setTitleHeight(20);

        //add report columns
        report.addColumn(clientNameColumn);
        report.addColumn(senderNameColumn);
        report.addColumn(complaintAgeColumn);
        report.addColumn(entryDateColumn);
        report.addColumn(statusNameColumn);
        report.addColumn(complaintColumn);
        report.addColumn(departmentNameColumn);

        try {

            report
                    .setShowColumnTitle(Boolean.FALSE)
                    .setTemplate(Templates.reportTemplate)
                    .setPageFormat(PageType.A4, PageOrientation.LANDSCAPE)
                    .setColumnTitleStyle(Templates.columnTitleStyle)
                    .title(cmp.horizontalList()
                            .setGap(88)
                            .add(
                                    cmp.hListCell(cmp.image(logoPath).setFixedDimension(134, 54)),
                                    cmp.hListCell(cmp.verticalList(
                                            cmp.horizontalList(
                                                    cmp.text("\u0627\u0644\u062A\u0642\u0631\u064A\u0631 \u0627\u0644\u0639\u0627\u0645").setFixedHeight(25).setFixedWidth(400).setStyle(summaryTitleStyle)))))
                            .newRow()
                            .newRow()
                            .add(cmp.verticalGap(20)))
                    .pageFooter(Templates.footerComponent)
                    .setDataSource(new WboCollectionDataSource(clientComplaintList));

            // preparing groups for group header titles
            ColumnGroupBuilder departmentNameGroup = grp.group(departmentNameColumn)
                    .setHeaderLayout(GroupHeaderLayout.EMPTY)
                    .setPadding(0)
                    .showColumnHeaderAndFooter();
            ColumnGroupBuilder senderNameGroup = grp.group(senderNameColumn)
                    .setHeaderLayout(GroupHeaderLayout.EMPTY)
                    .setPadding(0)
                    .showColumnHeaderAndFooter();
            ColumnGroupBuilder clientNameGroup = grp.group(clientNameColumn)
                    .setHeaderLayout(GroupHeaderLayout.EMPTY)
                    .setPadding(0)
                    .showColumnHeaderAndFooter();

            if (groupBy.equals("department")) {
                report.addGroup(departmentNameGroup);

                groupHeader = cmp.horizontalList();
                groupHeader.add(cmp.text(departmentNameGroup.getGroup().getValueField().getValueExpression()).setStyle(groupHeaderStyle).setFixedWidth(770).setHorizontalAlignment(HorizontalAlignment.RIGHT));
                groupHeader.add(cmp.text("\u0627\u0644\u0625\u062F\u0627\u0631\u0629:").setStyle(groupHeaderStyle).setFixedWidth(50).setHorizontalAlignment(HorizontalAlignment.RIGHT));
                groupHeader.setFixedHeight(25);
                departmentNameGroup.header(groupHeader);

            } else if (groupBy.equals("sender")) {
                report.addGroup(senderNameGroup);

                groupHeader = cmp.horizontalList();
                groupHeader.add(cmp.text(senderNameGroup.getGroup().getValueField().getValueExpression()).setStyle(groupHeaderStyle).setFixedWidth(770));
                groupHeader.add(cmp.text("\u0627\u0644\u0645\u0631\u0633\u0644:").setStyle(groupHeaderStyle).setFixedWidth(50));
                groupHeader.setFixedHeight(25);
                senderNameGroup.header(groupHeader);

            } else if (groupBy.equals("client")) {
                report.addGroup(clientNameGroup);

                groupHeader = cmp.horizontalList();
                groupHeader.add(cmp.text(clientNameGroup.getGroup().getValueField().getValueExpression()).setStyle(groupHeaderStyle).setFixedWidth(770).setHorizontalAlignment(HorizontalAlignment.RIGHT));
                groupHeader.add(cmp.text("\u0627\u0644\u0639\u0645\u064A\u0644:").setStyle(groupHeaderStyle).setFixedWidth(50).setHorizontalAlignment(HorizontalAlignment.RIGHT));
                groupHeader.setFixedHeight(25);
                clientNameGroup.header(groupHeader);

            }

            report.toPdf(response.getOutputStream());

        } catch (DRException e) {
            e.printStackTrace();
        }

    }
}
