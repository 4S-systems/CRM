package com.maintenance.servlets;

import com.businessfw.hrs.db_access.EmployeeMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ServiceManAreaMgr;
import com.maintenance.common.DateParser;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;

import com.maintenance.db_access.*;
import com.contractor.db_access.MaintainableMgr;
import com.crm.common.CRMConstants;
import com.crm.db_access.CommentsMgr;
import com.crm.db_access.EmployeesLoadsGroupSummaryMgr;
import com.crm.db_access.EmployeesLoadsMgr;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.common.UserGroupConfigMgr;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.GroupMgr;
import com.tracker.common.AppConstants;
import com.tracker.db_access.*;
import java.io.*;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.international.BilingualDisplayTerms;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.project_doc.SelfDocMgr;
import com.tracker.servlets.IssueServlet.IssueTitle;
import java.text.ParseException;
import java.util.ArrayList;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONValue;

public class ReportsServlet extends TrackerBaseServlet {
    //Define Local variables

    LocalStoresItemsMgr localStoresItemsMgr = LocalStoresItemsMgr.getInstance();

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
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        FixedAssetsMachineMgr fixedAssetsMachineMgr = FixedAssetsMachineMgr.getInstance();
        UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
        TempDayMgr tempDayMgr = TempDayMgr.getInstance();
        MonthlyJobOrderMgr monthlyJobOrderMgr = MonthlyJobOrderMgr.getInstance();
        ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();
        ScheduleByJobOrderMgr scheduleByJobOrderMgr = ScheduleByJobOrderMgr.getInstance();
        ScheduleByItemMgr scheduleByItemMgr = ScheduleByItemMgr.getInstance();
        TempTotalItemMgr tempTotalItemMgr = TempTotalItemMgr.getInstance();
        ScheduleByEmpTitleMgr scheduleByEmpTitleMgr = ScheduleByEmpTitleMgr.getInstance();
        TempTotalEmpTitleMgr tempTotalEmpTitleMgr = TempTotalEmpTitleMgr.getInstance();
        ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
        SecurityUser securityUser = new SecurityUser();
        securityUser = (SecurityUser) session.getAttribute("securityUser");
        MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        TradeMgr tradeMgr = TradeMgr.getInstance();
        DistributedItemsMgr distItemsMgr = DistributedItemsMgr.getInstance();
        EmployeesLoadsMgr loadsMgr = EmployeesLoadsMgr.getInstance();
        EmployeesLoadsGroupSummaryMgr loadsGroupSummaryMgr = EmployeesLoadsGroupSummaryMgr.getInstance();
        ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
        TaskMgr taskMgr = TaskMgr.getInstance();
        IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
        MainCategoryTypeMgr mainTypeMgr = MainCategoryTypeMgr.getInstance();

        String[] arrOfMonth = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

        String lang = (String) request.getSession().getAttribute("currentMode");
        String JOOpenStatus, JOCloseStatus, JOCancelStatus;
        String JOEmrgencyStatus, JONotEmrgencyStatus, JOAllStatus;
        String JOCanceledStatus, JOClosedStatus, JOFinishedStatus, JOOnholdStatus, JOAssignedStatus, JOOpendStatus, EqpTypeTrucks, EqpTypeTrailers, acceptLabel, noAcceptLabel;
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

            EqpTypeTrucks = "ط£ع©ط¢آ±ط£ع©ط¢آ£ط£ع©ط¢آ³";
            EqpTypeTrailers = "ط£â„¢أ¢â‚¬آ¦ط£â„¢أ¢â‚¬â€چط£ع©ط¢آ­ط£â„¢أ¢â‚¬ع‘";

            acceptLabel = "\u0645\u0648\u0627\u0641\u0642";
            noAcceptLabel = "\u063A\u064A\u0631\u0645\u0648\u0627\u0641\u0642";

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

            EqpTypeTrucks = "Truck";
            EqpTypeTrailers = "Trailer";

            acceptLabel = "Yes";
            noAcceptLabel = "No";
        }
        switch (operation) {

            case 0:
                servedPage = "/docs/new_report/main_report_form.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", "1");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 1:
                servedPage = "/docs/new_report/main_report_form.jsp";
                String tabNo = (String) request.getSession().getAttribute("tabId");
                if (tabNo != null && !tabNo.equals("")) {
                    request.getSession().setAttribute("tabId", tabNo);
                } else {
                    request.getSession().setAttribute("tabId", "1");
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:

                String BeginDate = request.getParameter("beginDate");
                String EndDate = request.getParameter("endDate");
                String displayDate = request.getParameter("displayDate");
                EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                Vector outOfWorkingEqps = maintainableMgr.getEqpsOutOfWorkingTime(BeginDate, EndDate);
                WebBusinessObject eqWbo = new WebBusinessObject();
                String eqID = "";
                WebBusinessObject eqStatusWbo = new WebBusinessObject();
                for (int i = 0; i < outOfWorkingEqps.size(); i++) {
                    eqWbo = new WebBusinessObject();
                    eqWbo = (WebBusinessObject) outOfWorkingEqps.get(i);
                    eqID = eqWbo.getAttribute("id").toString();
                    eqStatusWbo = equipmentStatusMgr.getLastStatus(eqID);
                    eqWbo.setAttribute("beginStatusDate", eqStatusWbo.getAttribute("beginDate").toString());
                    eqWbo.setAttribute("statusNote", eqStatusWbo.getAttribute("note").toString());
                }
                if (displayDate != null && displayDate.equalsIgnoreCase("Equal")) {
                    request.setAttribute("DisplayDate", "Equal");
                    request.setAttribute("Date", BeginDate);
                } else if (displayDate != null && displayDate.equalsIgnoreCase("Not Equal")) {
                    request.setAttribute("DisplayDate", "Not Equal");
                    request.setAttribute("beginDate", BeginDate);
                    request.setAttribute("endDate", EndDate);
                }
                request.setAttribute("outOfWorkingEqps", outOfWorkingEqps);
                servedPage = "/docs/new_report/out_of_Work_equipment_report.jsp";
                this.forward(servedPage, request, response);
                break;
            case 3:
                WebBusinessObject wbo = new WebBusinessObject();
                Vector resultList = new Vector();
                Vector resultByEmpList = new Vector();
                Vector getEqId = new Vector();
                Vector resultVec = new Vector();
                WebBusinessObject tempWboForId = new WebBusinessObject();
                String unitId = request.getParameter("unitId");
                String partId = request.getParameter("partId");
                String empId = request.getParameter("empId");
                String issueId = null;

                wbo = new WebBusinessObject();
                String bDate = request.getParameter("beginDate");
                String eDate = request.getParameter("endDate");
                String[] bDateArr = new String[3];
                String[] eDateArr = new String[3];
//                bDateArr=bDate.split("/");
//                eDateArr=eDate.split("/");
//                int bYear=Integer.parseInt(bDateArr[2]);
//                int bMonth=Integer.parseInt(bDateArr[0]);
//                int bDay=Integer.parseInt(bDateArr[1]);
//                
//                int eYear=Integer.parseInt(eDateArr[2]);
//                int eMonth=Integer.parseInt(eDateArr[0]);
//                int eDay=Integer.parseInt(eDateArr[1]);
//                
//                eYear=Integer.parseInt(eDateArr[2]);
//                eMonth=Integer.parseInt(eDateArr[0]);
//                eDay=Integer.parseInt(eDateArr[1]);

//                java.sql.Date beginDate=new java.sql.Date(bYear-1900,bMonth-1,bDay);
//                java.sql.Date endDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);
                DateParser dateParser = new DateParser();
                java.sql.Date beginDate = dateParser.formatSqlDate(bDate);
                java.sql.Date endDate = dateParser.formatSqlDate(eDate);

                QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                EquipByIssueMgr equipByIssue = EquipByIssueMgr.getInstance();
                EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                if (unitId != null && !unitId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndEquipByEMG(beginDate, endDate, unitId);
                } else {
                    resultVec = equipByIssue.getEqTasksInRangeByEMG(beginDate, endDate);
                }
                if (partId != null && !partId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        try {
                            issueParts = quantifiedMntenceMgr.getOnArbitraryKey(wbo.getAttribute("unitScheduleID").toString(), "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueParts.size() > 0) {
                            for (int x = 0; x < issueParts.size(); x++) {
                                WebBusinessObject sparPartWbo = new WebBusinessObject();
                                WebBusinessObject sparPartsByTasksWbo = new WebBusinessObject();
                                sparPartsByTasksWbo = (WebBusinessObject) issueParts.get(x);
                                if (sparPartsByTasksWbo.getAttribute("isDirectPrch").toString().equals("0")) {
                                    if (partId.equals(sparPartsByTasksWbo.getAttribute("itemId").toString())) {
                                        resultList.add(wbo);
                                    }

                                }

                            }
                        }
                    }

                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                if (empId != null && !empId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);

                        issueId = wbo.getAttribute("issueId").toString();
                        Vector empList = new Vector();
                        try {
                            empList = empTasksHoursMgr.getOnArbitraryKey(issueId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        WebBusinessObject empWbo = new WebBusinessObject();
                        if (empList.size() > 0) {
                            for (int m = 0; m < empList.size(); m++) {
                                empWbo = new WebBusinessObject();
                                empWbo = (WebBusinessObject) empList.get(m);
                                if (empId.equals(empWbo.getAttribute("empId").toString())) {
                                    resultByEmpList.add(wbo);
                                }
                            }
                        }
                    }
                    resultVec.removeAllElements();
                    resultVec = resultByEmpList;
                }

                request.setAttribute("resultVec", resultVec);
                servedPage = "/docs/new_report/eqJO_By_Emg_Report.jsp";

                request.setAttribute("unitId", unitId);
                request.setAttribute("empId", empId);
                request.setAttribute("partId", partId);
                request.setAttribute("bDate", bDate);
                request.setAttribute("eDate", eDate);

                this.forward(servedPage, request, response);

                break;

            case 4:

                String unitName = (String) request.getParameter("unitName");
                String formName = (String) request.getParameter("formName");
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
                String url = "ReportsServlet?op=listEquipment";
                maintainableMgr = MaintainableMgr.getInstance();
                try {
                    if (unitName != null && !unitName.equals("")) {
                        categoryTemp = maintainableMgr.getEquipBySubName(unitName);
                    } else {
                        categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                String tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                Vector category = new Vector();

                int index = (count + 1) * 10;
                String id = "";
                Vector checkattched = new Vector();
                SupplementMgr supplementMgr = SupplementMgr.getInstance();
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
                servedPage = "/docs/new_report/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);

                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;
            case 5:
                EmployeeMgr empBasicMgr = EmployeeMgr.getInstance();
                empBasicMgr.cashData();
                maintainableMgr = MaintainableMgr.getInstance();
                ArrayList allEquipments = new ArrayList();
                Vector eqps = new Vector();
                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                        allEquipments.add(wbo);
                    }
                }

                servedPage = "/docs/new_report/select_eqJO_report.jsp";
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                request.setAttribute("schedule", request.getParameter("schedule").toString());
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 6:
                resultList = new Vector();
                resultByEmpList = new Vector();
                getEqId = new Vector();
                resultVec = new Vector();
                tempWboForId = new WebBusinessObject();
                unitId = request.getParameter("unitId");
                partId = request.getParameter("partId");
                empId = request.getParameter("empId");
                issueId = null;

                wbo = new WebBusinessObject();
                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");
//                bDateArr=new String [3];
//                eDateArr=new String [3];
//                bDateArr=bDate.split("/");
//                eDateArr=eDate.split("/");
//                bYear=Integer.parseInt(bDateArr[2]);
//                bMonth=Integer.parseInt(bDateArr[0]);
//                bDay=Integer.parseInt(bDateArr[1]);
//                
//                eYear=Integer.parseInt(eDateArr[2]);
//                eMonth=Integer.parseInt(eDateArr[0]);
//                eDay=Integer.parseInt(eDateArr[1]);
//                
//                eYear=Integer.parseInt(eDateArr[2]);
//                eMonth=Integer.parseInt(eDateArr[0]);
//                eDay=Integer.parseInt(eDateArr[1]);
//                
//                beginDate=new java.sql.Date(bYear-1900,bMonth-1,bDay);
//                endDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);

                dateParser = new DateParser();
                beginDate = dateParser.formatSqlDate(bDate);
                endDate = dateParser.formatSqlDate(eDate);

                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                equipByIssue = EquipByIssueMgr.getInstance();
                empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                if (unitId != null && !unitId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndEquip(beginDate, endDate, unitId);
                } else {
                    resultVec = equipByIssue.getEqTasksInRange(beginDate, endDate);
                }
                if (partId != null && !partId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        try {
                            issueParts = quantifiedMntenceMgr.getOnArbitraryKey(wbo.getAttribute("unitScheduleID").toString(), "key1");
                            if (issueParts.size() == 0) {
                                issueParts = configureMainTypeMgr.getOnArbitraryKey(wbo.getAttribute("scheduleId").toString(), "key1");
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueParts.size() > 0) {
                            for (int x = 0; x < issueParts.size(); x++) {
                                WebBusinessObject sparPartWbo = new WebBusinessObject();
                                WebBusinessObject sparPartsByTasksWbo = new WebBusinessObject();
                                sparPartsByTasksWbo = (WebBusinessObject) issueParts.get(x);
                                if (sparPartsByTasksWbo.getAttribute("isDirectPrch").toString().equals("0")) {
                                    if (partId.equals(sparPartsByTasksWbo.getAttribute("itemId").toString())) {
                                        resultList.add(wbo);
                                    }

                                }

                            }
                        }
                    }

                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                if (empId != null && !empId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);

                        issueId = wbo.getAttribute("issueId").toString();
                        Vector empList = new Vector();
                        try {
                            empList = empTasksHoursMgr.getOnArbitraryKey(issueId, "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        WebBusinessObject empWbo = new WebBusinessObject();
                        if (empList.size() > 0) {
                            for (int m = 0; m < empList.size(); m++) {
                                empWbo = new WebBusinessObject();
                                empWbo = (WebBusinessObject) empList.get(m);
                                if (empId.equals(empWbo.getAttribute("empId").toString())) {
                                    resultByEmpList.add(wbo);
                                }
                            }
                        }
                    }
                    resultVec.removeAllElements();
                    resultVec = resultByEmpList;
                }

                request.setAttribute("resultVec", resultVec);
                servedPage = "/docs/new_report/eqJO_Report.jsp";

                request.setAttribute("unitId", unitId);
                request.setAttribute("empId", empId);
                request.setAttribute("partId", partId);
                request.setAttribute("bDate", bDate);
                request.setAttribute("eDate", eDate);

                this.forward(servedPage, request, response);

                break;
            case 7:
                Vector activeStoreVec = new Vector();
                Vector itemList = new Vector();
                ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
                ItemFormListMgr itemFormMgr = ItemFormListMgr.getInstance();
                activeStoreVec = new Vector();
                activeStoreVec = activeStoreMgr.getActiveStore(session);
                WebBusinessObject activeStoreWbo = new WebBusinessObject();
                activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
                WebBusinessObject itemFormCodeWbo = new WebBusinessObject();
                Vector itemFormListVec = new Vector();
                try {
                    itemFormListVec = (Vector) itemFormMgr.getOnArbitraryKeyOrdered(activeStoreWbo.getAttribute("storeCode").toString(), "key1", "key");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                itemFormCodeWbo = (WebBusinessObject) itemFormListVec.get(0);
                String itemFormCode = (String) itemFormCodeWbo.getAttribute("codeForm");
                ItemsMgr itemsMgr = ItemsMgr.getInstance();
                String itemForm = (String) request.getParameter("itemForm");
                String sparePart = (String) request.getParameter("sparePart");
                String partIdByForm = (String) request.getParameter("partIdByForm");

                formName = (String) request.getParameter("formName");
                if (sparePart != null && !sparePart.equals("")) {
                    String[] parts = sparePart.split(",");
                    sparePart = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        sparePart += c;
                    }
                }

                Vector items = new Vector();
                count = 0;
                url = "ReportsServlet?op=listItems";
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 50;
                itemsMgr = ItemsMgr.getInstance();
                activeStoreVec = activeStoreMgr.getActiveStore(session);
                if (activeStoreVec.size() > 0) {
                    if (partIdByForm != null && !partIdByForm.equals("")) {
                        String[] item_Form = partIdByForm.split("-");
                        items = itemsMgr.getSparePartByNameAndItemForm(sparePart, item_Form[0], session);
                        itemForm = item_Form[0];
                    } else {
                        if (itemForm != null && !itemForm.equals("")) {
                            if (sparePart != null && !sparePart.equals("")) {
                                items = itemsMgr.getSparePartByNameAndItemForm(sparePart, itemForm, session);
                            } else {
                                items = itemsMgr.getSparePartByNameAndItemForm("", itemForm, session);
                            }
                        } else {
                            if (sparePart != null && !sparePart.equals("")) {
                                items = itemsMgr.getSparePartByNameAndItemForm(sparePart, itemFormCode, session);
                            } else {
                                items = itemsMgr.getSparePartByNameAndItemForm("", itemFormCode, session);
                            }
                        }
                    }
                    itemList = new Vector();

                    if (items.size() < index) {
                        index = items.size();
                    }
                    for (int i = count * 50; i < index; i++) {
                        wbo = (WebBusinessObject) items.get(i);
                        itemList.add(wbo);
                    }

                    noOfLinks = items.size() / 50f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }
                    request.setAttribute("data", itemList);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("setupStore", "1");
                } else {
                    request.setAttribute("setupStore", "0");
                }
                servedPage = "/docs/new_report/items_list.jsp";

                request.setAttribute("sparePart", sparePart);
                request.setAttribute("count", "" + count);

                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("itemForm", itemForm);

                request.setAttribute("formName", formName);

                // request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 8:
                String empName = (String) request.getParameter("empName");
                formName = (String) request.getParameter("formName");
                if (empName != null && !empName.equals("")) {
                    String[] parts = empName.split(",");
                    empName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        empName += c;
                    }
                }
                EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
                Vector Employees = new Vector();
                count = 0;
                url = "ReportsServlet?op=listEmployee";
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 20;
                employeeMgr.cashData();
                if (empName != null && !empName.equals("")) {
                    Employees = employeeMgr.getEmployeeBySubName(empName);
                } else {
                    Employees = employeeMgr.getEmployeeBySubName("");
                }

                Vector empList = new Vector();

                if (Employees.size() < index) {
                    index = Employees.size();
                }
                for (int i = count * 20; i < index; i++) {
                    wbo = (WebBusinessObject) Employees.get(i);
                    empList.add(wbo);
                }

                noOfLinks = Employees.size() / 20f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                servedPage = "/docs/new_report/employees_list.jsp";

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("data", empList);
                request.setAttribute("empName", empName);
                request.setAttribute("formName", formName);
                //request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 9:

                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();
                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                        allEquipments.add(wbo);
                    }
                }

                servedPage = "/docs/new_report/future_eqJO_report.jsp";
                request.setAttribute("currentMode", "Ar");

                request.setAttribute("schedule", request.getParameter("schedule").toString());
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:

                servedPage = "/docs/new_report/task_list.jsp";

                String fieldName = request.getParameter("fieldName");
                String fieldValue = request.getParameter("fieldValue");

                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();

                filter = Tools.getPaginationInfo(request, response);

                ArrayList<FilterCondition> conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());

                // add conditions
                conditions.add(new FilterCondition("ID", "", Operations.IS_NOT_NULL));
                filter.setConditions(conditions);

                taskMgr = TaskMgr.getInstance();
                List<WebBusinessObject> searchList = new ArrayList<WebBusinessObject>(0);

                //grab scheduleList list
                try {
                    searchList = taskMgr.paginationEntity(filter);
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
                request.setAttribute("searchList", searchList);
                request.setAttribute("fieldName", fieldName);
                request.setAttribute("fieldValue", Tools.getRealChar(fieldValue));
                this.forward(servedPage, request, response);
                break;
            case 101:
                String taskName = request.getParameter("taskName");
                formName = request.getParameter("formName");
                if (taskName != null && !taskName.equals("")) {
                    String[] parts = taskName.split(",");
                    taskName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        taskName += c;
                    }
                }
                taskMgr = TaskMgr.getInstance();
                Vector Tasks = new Vector();
                count = 0;
                url = "ReportsServlet?op=listTasks";
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 20;
                taskMgr.cashData();
                if (taskName != null && !taskName.equals("")) {
                    Tasks = taskMgr.getTasksBySubName(taskName);
                } else {
                    Tasks = taskMgr.getTasksBySubName("");
                }

                Vector taskList = new Vector();

                if (Tasks.size() < index) {
                    index = Tasks.size();
                }
                for (int i = count * 20; i < index; i++) {
                    wbo = (WebBusinessObject) Tasks.get(i);
                    taskList.add(wbo);
                }

                noOfLinks = Tasks.size() / 20f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                servedPage = "/docs/new_report/tasks_list.jsp";

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("data", taskList);
                request.setAttribute("formName", formName);
                request.setAttribute("taskName", taskName);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 11:
                ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                resultList = new Vector();

                resultList = new Vector();

                resultByEmpList = new Vector();
                getEqId = new Vector();
                resultVec = new Vector();
                tempWboForId = new WebBusinessObject();
                unitId = request.getParameter("unitId");
                partId = request.getParameter("partId");
                String taskId = request.getParameter("taskId");
                issueId = null;

                wbo = new WebBusinessObject();
                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");
//                bDateArr=new String [3];
//                eDateArr=new String [3];
//                bDateArr=bDate.split("/");
//                eDateArr=eDate.split("/");
//                bYear=Integer.parseInt(bDateArr[2]);
//                bMonth=Integer.parseInt(bDateArr[0]);
//                bDay=Integer.parseInt(bDateArr[1]);
//                
//                eYear=Integer.parseInt(eDateArr[2]);
//                eMonth=Integer.parseInt(eDateArr[0]);
//                eDay=Integer.parseInt(eDateArr[1]);
//                
//                eYear=Integer.parseInt(eDateArr[2]);
//                eMonth=Integer.parseInt(eDateArr[0]);
//                eDay=Integer.parseInt(eDateArr[1]);
//                
//                beginDate=new java.sql.Date(bYear-1900,bMonth-1,bDay);
//                endDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);

                dateParser = new DateParser();
                beginDate = dateParser.formatSqlDate(bDate);
                endDate = dateParser.formatSqlDate(eDate);

                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
                FutureEquipByIssueMgr futureEquipByIssueMgr = FutureEquipByIssueMgr.getInstance();
                empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                if (unitId != null && !unitId.equals("")) {
                    resultVec = futureEquipByIssueMgr.getFtureTasksInRangeAndEquip(beginDate, endDate, unitId);
                } else {
                    resultVec = futureEquipByIssueMgr.getFutureTasksInRange(beginDate, endDate);
                }

                if (taskId != null && !taskId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        issueId = wbo.getAttribute("issueId").toString();
                        Vector issueItems = new Vector();
                        try {
                            issueItems = (Vector) issueTasksMgr.getOnArbitraryKey(issueId, "key1");
                            if (issueItems.size() == 0) {
                                issueItems = (Vector) scheduleTasksMgr.getOnArbitraryKey(wbo.getAttribute("scheduleId").toString(), "key1");
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueItems.size() > 0) {
                            for (int x = 0; x < issueItems.size(); x++) {
                                WebBusinessObject itemWbo = new WebBusinessObject();
                                itemWbo = (WebBusinessObject) issueItems.get(x);
                                if (taskId.equals(itemWbo.getAttribute("codeTask").toString())) {
                                    resultList.add(wbo);
                                }
                            }
                        }
                    }
                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                if (partId != null && !partId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        try {
                            issueParts = configureMainTypeMgr.getOnArbitraryKey(wbo.getAttribute("scheduleId").toString(), "key1");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueParts.size() > 0) {
                            for (int x = 0; x < issueParts.size(); x++) {
                                WebBusinessObject sparPartWbo = new WebBusinessObject();
                                WebBusinessObject sparPartsByTasksWbo = new WebBusinessObject();
                                sparPartsByTasksWbo = (WebBusinessObject) issueParts.get(x);
                                // if(sparPartsByTasksWbo.getAttribute("isDirectPrch").toString().equals("0")){
                                if (partId.equals(sparPartsByTasksWbo.getAttribute("itemId").toString())) {
                                    resultList.add(wbo);
                                }

                                // }
                            }
                        }
                    }

                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                request.setAttribute("resultVec", resultVec);
                servedPage = "/docs/new_report/future_eqJO_List.jsp";

                request.setAttribute("unitId", unitId);
                request.setAttribute("taskId", taskId);
                request.setAttribute("partId", partId);
                request.setAttribute("bDate", bDate);
                request.setAttribute("eDate", eDate);

                this.forward(servedPage, request, response);
                break;

            case 12:
                break;
            case 13:
                servedPage = "/docs/new_report/search_items.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 14:
                String itemName = (String) request.getParameter("itemName");
                String itemNumber = (String) request.getParameter("itemNumber");
                Vector vecItems = new Vector();
                activeStoreMgr = ActiveStoreMgr.getInstance();
                activeStoreVec = new Vector();
                activeStoreVec = activeStoreMgr.getActiveStore(session);
                activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
                String storeCode = activeStoreWbo.getAttribute("storeCode").toString();
                itemsMgr = ItemsMgr.getInstance();

                count = 0;
                url = "ReportsServlet?op=resultSearchItems";
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 50;

                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                servedPage = "/docs/new_report/search_items_list.jsp";

                String storeId = "";
                WebBusinessObject userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

                storeId = userWbo.getAttribute("storeId").toString();

                if (storeId.equalsIgnoreCase("nostore")) {

                    if (itemName != null && !itemName.equals("")) {

                        vecItems = itemsMgr.getSparePartByNameAndStore(itemName, storeCode);

                    } else if (itemNumber != null && !itemNumber.equals("")) {

                        vecItems = itemsMgr.getSparePartByCodeAndStore(itemNumber, storeCode);

                    } else {
                        try {
                            vecItems = itemsMgr.getOnArbitraryKey(storeCode, "key5");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                } else {

                    if (itemName != null && !itemName.equals("")) {

                        vecItems = itemsMgr.getSparePartByNameAndStore(itemName, storeCode);

                    } else if (itemNumber != null && !itemNumber.equals("")) {

                        vecItems = itemsMgr.getSparePartByCodeAndStore(itemNumber, storeCode);

                    } else {
                        try {
                            vecItems = itemsMgr.getOnArbitraryKey(storeCode, "key5");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }

                itemList = new Vector();

                if (vecItems.size() < index) {
                    index = vecItems.size();
                }
                for (int i = count * 50; i < index; i++) {
                    wbo = (WebBusinessObject) vecItems.get(i);
                    itemList.add(wbo);
                }

                noOfLinks = vecItems.size() / 50f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                request.setAttribute("itemName", itemName);
                request.setAttribute("itemNumber", itemNumber);
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("data", itemList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 15:
                String single = request.getParameter("single");
                String result = request.getParameter("result");
                if (result.equals("list")) {
                    servedPage = "/docs/new_report/jobOrders_week.jsp";
                } else if (result.equals("graph")) {
                    if (single != null) {
                        servedPage = "/docs/new_report/jobOrders_category_graph_1.jsp";
                    } else {
                        servedPage = "/docs/new_report/jobOrders_category_graph.jsp";
                    }

                }
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                IssueMgr issueMgr = IssueMgr.getInstance();

                Vector issuesVectors = new Vector();
                Vector maintainableUnitTypeVectors = new Vector();

                String type = request.getParameter("type");
                String bgningDate = request.getParameter("beginDate");
                String eningDate = request.getParameter("endDate");
                String[] bgningDateArr = new String[3];
                String[] eningDateArr = new String[3];
                bgningDateArr = bgningDate.split("-");
                eningDateArr = eningDate.split("-");
                int bgningYear = Integer.parseInt(bgningDateArr[0]);
                int bgningMonth = Integer.parseInt(bgningDateArr[1]);
                int bgningDay = Integer.parseInt(bgningDateArr[2]);

                int eningYear = Integer.parseInt(eningDateArr[0]);
                int eningMonth = Integer.parseInt(eningDateArr[1]);
                int eningDay = Integer.parseInt(eningDateArr[2]);

                eningYear = Integer.parseInt(eningDateArr[0]);
                eningMonth = Integer.parseInt(eningDateArr[1]);
                eningDay = Integer.parseInt(eningDateArr[2]);

                java.sql.Date beginingDates = new java.sql.Date(bgningYear - 1900, bgningMonth - 1, bgningDay);
                java.sql.Date endingDates = new java.sql.Date(eningYear - 1900, eningMonth - 1, eningDay);

                issuesVectors = issueMgr.getIssuesListInRange(beginingDates, endingDates);

                if (type.equals("category")) {
                    maintainableUnitTypeVectors = mainCategoryTypeMgr.getCashedTable();
                } else if (type.equals("equipment")) {
                    maintainableUnitTypeVectors = parentUnitMgr.getCashedTable();
                }
                request.setAttribute("issuesVectors", issuesVectors);
                request.setAttribute("maintainableUnitTypeVectors", maintainableUnitTypeVectors);
                request.setAttribute("type", type);
                request.setAttribute("beginInterval", beginingDates);
                request.setAttribute("endInterval", endingDates);

                request.setAttribute("beginDate", bgningDate);
                request.setAttribute("endDate", eningDate);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                if (single != null) {
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;
            case 16:
                servedPage = "/docs/new_report/jobOrders_type_week_main.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 17:
                single = request.getParameter("single");
                if (single != null) {
                    servedPage = "/docs/new_report/jobOrders_type_week_main_1.jsp";
                } else {
                    servedPage = "/docs/new_report/jobOrders_type_week_main.jsp";
                }

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                if (single != null) {
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;
            case 18:
                servedPage = "/docs/new_report/jobOrder_perWeek_main.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 19:
                servedPage = "/docs/new_report/jobOrder_per_week.jsp";
                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");
//                bDateArr = new String[3];
//                eDateArr = new String[3];
//                bDateArr = bDate.split("/");
//                eDateArr = eDate.split("/");
//                bYear = Integer.parseInt(bDateArr[2]);
//                bMonth = Integer.parseInt(bDateArr[0]);
//                bDay = Integer.parseInt(bDateArr[1]);
//                
//                eYear = Integer.parseInt(eDateArr[2]);
//                eMonth = Integer.parseInt(eDateArr[0]);
//                eDay = Integer.parseInt(eDateArr[1]);
//                
//                eYear = Integer.parseInt(eDateArr[2]);
//                eMonth = Integer.parseInt(eDateArr[0]);
//                eDay = Integer.parseInt(eDateArr[1]);
//                
//                beginDate = new java.sql.Date(bYear - 1900, bMonth - 1, bDay);
//                endDate = new java.sql.Date(eYear - 1900, eMonth - 1, eDay);

                dateParser = new DateParser();
                beginDate = dateParser.formatSqlDate(bDate);
                endDate = dateParser.formatSqlDate(eDate);

                Vector tempResult = new Vector();
                issueMgr = IssueMgr.getInstance();
                issueMgr.executeMainReport(request);
                MainReportMgr mainReportMgr = MainReportMgr.getInstance();
                mainReportMgr.cashData();
                Vector vecResult = mainReportMgr.getCashedTable();
                for (int i = 0; i < vecResult.size(); i++) {
                    WebBusinessObject wboTemp = (WebBusinessObject) vecResult.get(i);
                    if (!wboTemp.getAttribute("total").equals("0")) {
                        tempResult.add(wboTemp);
                    }
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("vecResult", tempResult);
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                this.forwardToServedPage(request, response);
                break;

            case 20:
                servedPage = "/docs/new_report/search_plan_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 21:
                Vector issueList = null;
                IssueEquipmentMgr issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                servedPage = "/docs/new_report/plan_issues_report.jsp";

                unitId = (String) request.getParameter("unitId");
                try {
                    issueList = issueEquipmentMgr.getIssuesForPlan(request, session);
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
                    } catch (Exception e) {
                    }
                }

                maintainableMgr = MaintainableMgr.getInstance();
                eqWbo = maintainableMgr.getOnSingleKey(unitId);

                request.getSession().setAttribute("planUnitId", unitId);
                request.getSession().setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.getSession().setAttribute("endDate", request.getParameter("endDate").toString());

                request.setAttribute("data", issueList);
                request.setAttribute("unitId", unitId);
                request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                request.setAttribute("endDate", request.getParameter("endDate").toString());
                request.setAttribute("page", servedPage);
                request.setAttribute("eqWbo", eqWbo);
                this.forwardToServedPage(request, response);
                break;
            case 22:
                eqID = (String) request.getParameter("unitId");
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
                servedPage = "/docs/new_report/plan_issues_report.jsp";

                unitId = (String) request.getParameter("unitId");
                try {
                    issueList = issueEquipmentMgr.getIssuesForPlan(request, session);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                complexIssueMgr = ComplexIssueMgr.getInstance();
                checkIsCmplx = new Vector();
                subIssueList = new Vector();
                issueWbo = new WebBusinessObject();

                for (int i = 0; i < issueList.size(); i++) {
                    issueWbo = (WebBusinessObject) issueList.get(i);
                    try {
                        checkIsCmplx = complexIssueMgr.getOnArbitraryKey(issueWbo.getAttribute("id").toString(), "key1");
                        if (checkIsCmplx.size() > 0) {
                            issueWbo.setAttribute("issueType", "cmplx");
                        } else {
                            issueWbo.setAttribute("issueType", "normal");
                        }
                    } catch (Exception e) {
                    }
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

            case 23:
                empBasicMgr = EmployeeMgr.getInstance();
                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();
                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                        allEquipments.add(wbo);
                    }
                }

                servedPage = "/docs/new_report/select_eqJO_Emg_report.jsp";
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                request.setAttribute("schedule", request.getParameter("schedule").toString());
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 24:

                MaintainableMgr equipTypeMgr = MaintainableMgr.getInstance();
                Vector categories = new Vector();
                try {
                    categories = equipTypeMgr.getOnArbitraryKey("0", "key1");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                servedPage = "/docs/new_report/equipType_Report.jsp";
                request.setAttribute("data", categories);
                this.forward(servedPage, request, response);

                break;

            case 25:

                //ArrayList allEquipments=new ArrayList();
                ArrayList mainCategories = new ArrayList();
                Vector data = null;
                mainCategories = mainTypeMgr.getCashedTableAsBusObjects();
                data = mainTypeMgr.getCashedTable();
                wbo = new WebBusinessObject();

                servedPage = "/docs/new_report/select_eq_report.jsp";
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data1", mainCategories);
                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 26:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                maintainableMgr = MaintainableMgr.getInstance();
                String parentId = null;
                Vector equipmetWboVec = null;
                Vector basicTypeVec = new Vector();
                Vector EqpVec = new Vector();
                Hashtable eqpByParentId = new Hashtable();
                Hashtable brandByBasicTypeId = new Hashtable();
                WebBusinessObject basicTypeWbo = new WebBusinessObject();
                Vector brandByBasicTypeVec = new Vector();
                String mainTypeId = (String) request.getParameter("mainTypeId");
                Vector finalEqpsVec = new Vector();
                Vector allMainCats = new Vector();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                String basictypeId = null;
                String options[] = null;
                options = (String[]) request.getParameterValues("equipmentData");

                if (mainTypeId.equalsIgnoreCase("all")) {
                    String query = "select ";
                    if (options == null || options.length <= 0) {
                        query += "UNIT_NAME ,UNIT_NO, PARENT_ID, MAIN_TYPE_ID  ";
                    } else {
                        query += "UNIT_NAME ,UNIT_NO, PARENT_ID, MAIN_TYPE_ID, ";
                        for (int i = 0; i < options.length; i++) {
                            query += options[i] + ",";
                        }
                        query = query.trim().substring(0, query.length() - 1);
                    }

                    query += " FROM maintainable_unit WHERE IS_DELETED = '0' and PARENT_ID != '0' order by PARENT_ID";

                    equipmetWboVec = maintainableMgr.getEquipmentRecordAll(query);
                    request.setAttribute("data", equipmetWboVec);
                    basicTypeVec = mainTypeMgr.getAllBasictypeBySorting();
                    for (int i = 0; i < basicTypeVec.size(); i++) {
                        basicTypeWbo = (WebBusinessObject) basicTypeVec.get(i);
                        basictypeId = basicTypeWbo.getAttribute("id").toString();
                        brandByBasicTypeVec = maintainableMgr.getBrandByBasictype(basictypeId);
                        for (int x = 0; x < brandByBasicTypeVec.size(); x++) {
                            WebBusinessObject parentEqpWbo = (WebBusinessObject) brandByBasicTypeVec.get(x);
                            parentId = parentEqpWbo.getAttribute("id").toString();
                            try {
                                EqpVec = maintainableMgr.getEqpbyParentSorting(parentEqpWbo.getAttribute("id").toString());
                                allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
                                //finalEqpsVec = checkIsAgroupEq(EqpVec, allMainCats);
                            } catch (SQLException ex) {
                                ex.printStackTrace();
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }

                            eqpByParentId.put(parentId, EqpVec);
                        }
                        brandByBasicTypeId.put(basictypeId, brandByBasicTypeVec);
                    }
                    // equipmetWboVec = maintainableMgr.getAllEquipmentByAllMainType();
                    servedPage = "/docs/new_report/equipment_Report_All.jsp";
                    request.setAttribute("brandByBasicTypeId", brandByBasicTypeId);
                    request.setAttribute("eqpByParentId", eqpByParentId);
                    request.setAttribute("basicTypeVec", basicTypeVec);
                } else {

                    String query = "select ";
                    if (options == null || options.length <= 0) {
                        query += "UNIT_NAME ,UNIT_NO, PARENT_ID, MAIN_TYPE_ID  ";
                    } else {
                        query += "UNIT_NAME ,UNIT_NO, PARENT_ID, MAIN_TYPE_ID, ";
                        for (int j = 0; j < options.length; j++) {
                            query += options[j] + ",";
                        }
                        query = query.trim().substring(0, query.length() - 1);
                    }

                    query += " FROM maintainable_unit WHERE main_type_id='" + mainTypeId;
                    query += "' order by PARENT_ID";

                    equipmetWboVec = maintainableMgr.getEquipmentRecordAll(query);
                    request.setAttribute("data", equipmetWboVec);
                    try {
                        basicTypeVec = mainTypeMgr.getOnArbitraryKey(mainTypeId, "key");
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < basicTypeVec.size(); i++) {
                        basicTypeWbo = (WebBusinessObject) basicTypeVec.get(i);
                        basictypeId = basicTypeWbo.getAttribute("id").toString();
                        brandByBasicTypeVec = maintainableMgr.getBrandByBasictype(basictypeId);
                        for (int x = 0; x < brandByBasicTypeVec.size(); x++) {
                            WebBusinessObject parentEqpWbo = (WebBusinessObject) brandByBasicTypeVec.get(x);
                            parentId = parentEqpWbo.getAttribute("id").toString();
                            try {
                                EqpVec = maintainableMgr.getEqpbyParentSorting(parentEqpWbo.getAttribute("id").toString());
                                allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");

                            } catch (SQLException ex) {
                                ex.printStackTrace();
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }

                            eqpByParentId.put(parentId, EqpVec);
                        }
                        brandByBasicTypeId.put(basictypeId, brandByBasicTypeVec);

                        // finalEqpsVec = checkIsAgroupEq(EqpVec, allMainCats);
                    }
                    // equipmetWboVec = maintainableMgr.getAllEquipmentByAllMainType();
                    servedPage = "/docs/new_report/equipment_Report_All.jsp";
                    request.setAttribute("basicTypeWbo", mainTypeMgr.getOnSingleKey(mainTypeId));
                    request.setAttribute("brandByBasicTypeId", brandByBasicTypeId);
                    request.setAttribute("eqpByParentId", eqpByParentId);
                    request.setAttribute("basicTypeVec", basicTypeVec);
                }

                try {
                    allMainCats = mainTypeMgr.getOnArbitraryKey("1", "key2");
                    //finalEqpsVec =checkIsAgroupEq(equipmetWboVec, allMainCats);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                request.setAttribute("allMainCats", allMainCats);
                request.setAttribute("mainTypeId", mainTypeId);
                request.setAttribute("items", options);

                this.forward(servedPage, request, response);

                break;
            case 27:
                projectMgr = ProjectMgr.getInstance();
                //ArrayList allEquipments=new ArrayList();
                ArrayList sites = new ArrayList();
                sites = projectMgr.getCashedTableAsBusObjects();
                wbo = new WebBusinessObject();

                servedPage = "/docs/new_report/select_eq_by_site_report.jsp";
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", sites);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 28:
                java.sql.Connection conn = null;
                String report = "";
                maintainableMgr = MaintainableMgr.getInstance();
                Vector site = new Vector();
                String siteId = (String) request.getParameter("siteId");
                HashMap reportParams = new HashMap();
                if (siteId.equalsIgnoreCase("all")) {
                    report = "EquipmentsAllSites";
                    //site = maintainableMgr.getEqpByAllSites();
                } else {
                    reportParams.put("site", siteId);
                    report = "EquipmentsBySite";
                    //site = maintainableMgr.getEqpBySiteId(siteId);
                }

                try {
                    conn = AllMaintenanceInfoMgr.getInstance().getReportConn();
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                Tools.createPdfReport(report, reportParams, getServletContext(), response, request, conn);

                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

//                projectMgr = ProjectMgr.getInstance();
//                mainTypeMgr = MainCategoryTypeMgr.getInstance();
//                maintainableMgr = MaintainableMgr.getInstance();
//                equipmetWboVec = null;
//                Hashtable equipBySiteId = new Hashtable();
//                Vector sitesVec = new Vector();
//                String siteId = (String) request.getParameter("siteId");
//                WebBusinessObject siteWbo = new WebBusinessObject();
//
//                options = (String[]) request.getParameterValues("equipmentData");
//
//                if (siteId.equalsIgnoreCase("all")) {
//                    sitesVec = projectMgr.getSitesBySort();
//
//                    for (int x = 0; x < sitesVec.size(); x++) {
//                        siteWbo = (WebBusinessObject) sitesVec.get(x);
//                        siteId = (String) siteWbo.getAttribute("projectID");
//
//                        equipmetWboVec = maintainableMgr.getEqpBySitesSorting(siteId);
//
//                        equipBySiteId.put(siteId, equipmetWboVec);
//                    }
//                    servedPage = "/docs/new_report/equipment_Report_All_by_site.jsp";
//                    request.setAttribute("sitesVec", sitesVec);
//                    request.setAttribute("equipBySiteId", equipBySiteId);
//
//                    //equipmetWboVec = maintainableMgr.getAllEquipmentByAllMainType();
//
//                } else {
//
//                    try {
//                        sitesVec = projectMgr.getOnArbitraryKey(siteId, "key");
//                        for (int x = 0; x < sitesVec.size(); x++) {
//                            siteWbo = (WebBusinessObject) sitesVec.get(x);
//                            siteId = (String) siteWbo.getAttribute("projectID");
//
//                            equipmetWboVec = maintainableMgr.getEqpBySitesSorting(siteId);
//
//                            equipBySiteId.put(siteId, equipmetWboVec);
//                        }
//                        servedPage = "/docs/new_report/equipment_Report_All_by_site.jsp";
//                        request.setAttribute("sitesVec", sitesVec);
//                        request.setAttribute("equipBySiteId", equipBySiteId);
//
//                    } catch (SQLException ex) {
//                        ex.printStackTrace();
//                    } catch (Exception ex) {
//                        ex.printStackTrace();
//                    }
//
//
//                    // WebBusinessObject projectWbo = (WebBusinessObject) projectMgr.getOnSingleKey(siteId);
//                    //equipmetWboVec = maintainableMgr.getAllEquipmentByProjectId(siteId);
//
//
//                    // request.setAttribute("projectWbo", projectWbo);
//                }
//                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
//                finalEqpsVec = new Vector();
//                allMainCats = new Vector();
//                try {
//                    allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
//                    finalEqpsVec = checkIsAgroupEq(equipmetWboVec, allMainCats);
//                } catch (SQLException ex) {
//                    ex.printStackTrace();
//                } catch (Exception ex) {
//                    ex.printStackTrace();
//                }
//
//                request.setAttribute("siteId", siteId);
//                request.setAttribute("items", options);
//                request.setAttribute("data", finalEqpsVec);
//                this.forward(servedPage, request, response);
                break;

            case 29:
                String tabId = (String) request.getParameter("tabId");
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId", tabId);
                response.setContentType("text/xml;charset=UTF-8");
                response.setHeader("Cache-Control", "no-cache");
                tabNo = (String) request.getSession().getAttribute("tabId");
                out = response.getWriter();
                out.write(tabNo);

                break;
            case 30:

                single = request.getParameter("single");
                int month = 0;
                String[] monthsArray = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                ArrayList monthsList = new ArrayList();
                WebBusinessObject monthWbo = new WebBusinessObject();
                Calendar monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", monthsArray[i]);
                    monthsList.add(wbo);
                }
                if (single != null) {
                    servedPage = "/docs/new_report/jobOrders_by_monthOfYear_1.jsp";
                } else {
                    servedPage = "/docs/new_report/jobOrders_by_monthOfYear.jsp";
                }
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", monthsArray[month]);
                request.setAttribute("month", monthWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                if (single != null) {
                    request.setAttribute("imageshow", single);
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;
            case 31:
                result = request.getParameter("result");
                String monthOfYear = request.getParameter("month");
                String year = request.getParameter("yearNo");
                type = request.getParameter("type");
                single = request.getParameter("single");
                String[] current = year.split("-");
                String yearSelect = current[0];
                String yearflag = current[1];
                String endDay = null;
                int getYear;
                int yearNo = new Integer(yearSelect.toString()).intValue();
                int monthNo = new Integer(monthOfYear.toString()).intValue();
                int beginDayNo = 1;
                int endDayNo;
                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }

                if (yearflag.equals("0")) {
                    getYear = monthCal.getTime().getYear();
                } else {
                    getYear = monthCal.getTime().getYear() - 1;
                }
                endDayNo = new Integer(endDay.toString()).intValue();
                beginDate = new java.sql.Date(getYear, monthNo, beginDayNo);
                endDate = new java.sql.Date(getYear, monthNo, endDayNo);
                if (result.equals("list")) {
                    servedPage = "/docs/new_report/jobOrder_per_ByMonth.jsp";
                } else if (result.equals("graph")) {
                    if (single != null) {
                        servedPage = "/docs/new_report/jobOrders_category_graph_ByMonth_1.jsp";
                    } else {
                        servedPage = "/docs/new_report/jobOrders_category_graph_ByMonth.jsp";
                    }
                }
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                issueMgr = IssueMgr.getInstance();
                parentUnitMgr = ParentUnitMgr.getInstance();

                issuesVectors = new Vector();
                maintainableUnitTypeVectors = new Vector();

                issuesVectors = issueMgr.getIssuesListInRange(beginDate, endDate);
                if (type.equals("category")) {
                    maintainableUnitTypeVectors = mainCategoryTypeMgr.getCashedTable();
                } else if (type.equals("equipment")) {
                    maintainableUnitTypeVectors = parentUnitMgr.getCashedTable();
                }
                request.setAttribute("issuesVectors", issuesVectors);
                request.setAttribute("maintainableUnitTypeVectors", maintainableUnitTypeVectors);
                request.setAttribute("type", type);
                request.setAttribute("beginInterval", beginDate);
                request.setAttribute("endInterval", endDate);
                request.setAttribute("beginDate", beginDate.toString());
                request.setAttribute("endDate", endDate.toString());
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                if (single != null) {
                    request.setAttribute("imageshow", single);
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;

            case 32:
                servedPage = "/docs/new_report/main_report_form.jsp";
                tabNo = (String) request.getSession().getAttribute("tabId");
                if (tabNo != null && !tabNo.equals("")) {
                    request.getSession().setAttribute("tabId", tabNo);
                } else {
                    request.getSession().setAttribute("tabId", "1");
                }
                String mode = request.getParameter("key").toString();

                if (!mode.equals("aa")) {
                    if (mode.equals("En") || mode.equals("Ar")) {

                        request.getSession().setAttribute("currentMode", mode);
                    }
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 33:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                mainCategories = new ArrayList();
                mainCategories = mainTypeMgr.getCashedTableAsBusObjects();
                wbo = new WebBusinessObject();

                servedPage = "/docs/new_report/items_Report_By_MainType.jsp";
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", mainCategories);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 34:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                taskMgr = TaskMgr.getInstance();
                Vector itemWboVec = new Vector();
                Hashtable tasksByBasicType = new Hashtable();
                String basicTypeId = null;
                mainTypeId = (String) request.getParameter("mainTypeId");

                options = null;
                options = (String[]) request.getParameterValues("itemData");

                if (mainTypeId.equalsIgnoreCase("all")) {

                    basicTypeVec = mainTypeMgr.getAllBasictypeBySorting();
                    for (int x = 0; x < basicTypeVec.size(); x++) {
                        basicTypeWbo = (WebBusinessObject) basicTypeVec.get(x);
                        basicTypeId = basicTypeWbo.getAttribute("id").toString();

                        itemWboVec = taskMgr.getTasksByBasicTypeSorting(basicTypeId);

                        tasksByBasicType.put(basicTypeId, itemWboVec);
                    }
                    servedPage = "/docs/new_report/item_Result_By_MainType.jsp";
                    request.setAttribute("basicTypeVec", basicTypeVec);
                    request.setAttribute("tasksByBasicType", tasksByBasicType);
                } else {
                    try {
                        WebBusinessObject taskWbo = (WebBusinessObject) mainTypeMgr.getOnSingleKey(mainTypeId);
                        basicTypeVec = mainTypeMgr.getOnArbitraryKey(mainTypeId, "key");
                        for (int x = 0; x < basicTypeVec.size(); x++) {
                            basicTypeWbo = (WebBusinessObject) basicTypeVec.get(x);
                            basicTypeId = basicTypeWbo.getAttribute("id").toString();

                            itemWboVec = taskMgr.getTasksByBasicTypeSorting(basicTypeId);

                            tasksByBasicType.put(basicTypeId, itemWboVec);
                        }
                        servedPage = "/docs/new_report/item_Result_By_MainType.jsp";
                        request.setAttribute("basicTypeVec", basicTypeVec);
                        request.setAttribute("tasksByBasicType", tasksByBasicType);
                        request.setAttribute("catWbo", taskWbo);

                        // itemWboVec = taskMgr.getOnArbitraryDoubleKey(mainTypeId, "key3", "yes", "key4");
                    } catch (SQLException ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                }

                request.setAttribute("items", options);
                //request.setAttribute("data", itemWboVec);
                this.forward(servedPage, request, response);

                break;

            case 35:
                String unitCode = request.getParameter("unitCode");
                String searchType = request.getParameter("searchType");
                unitName = (String) request.getParameter("unitName");
                formName = (String) request.getParameter("formName");
                FixedAssetsDataMgr fixedAssetsDataMgr = FixedAssetsDataMgr.getInstance();
                WebBusinessObject fixedAssetsDataWbo = new WebBusinessObject();
                if (searchType.equalsIgnoreCase("byName")) {

                    if (unitName != null && !unitName.equals("")) {
                        String[] parts = unitName.split(",");
                        unitName = "";
                        for (int i = 0; i < parts.length; i++) {
                            char c = (char) new Integer(parts[i]).intValue();
                            unitName += c;
                        }
                    }
                }
                categoryTemp = new Vector();
                count = 0;
                url = "ReportsServlet?op=listFixedAssetEquip";
                maintainableMgr = MaintainableMgr.getInstance();
                maintainableMgr.executeProcedureMachine("txt");
                fixedAssetsMachineMgr.cashData();
                try {
                    if (searchType.equalsIgnoreCase("byName")) {
                        if (unitName != null && !unitName.equals("")) {
                            categoryTemp = fixedAssetsDataMgr.getFixedAssetEqpBySubName(unitName);
                        } else {
                            categoryTemp = fixedAssetsMachineMgr.getCashedTable();
                        }

                    } else if (searchType.equalsIgnoreCase("byCode")) {
                        if (unitCode != null && !unitCode.equals("")) {
                            categoryTemp = fixedAssetsDataMgr.getFixedAssetEqpByCode(unitCode);
                        } else {
                            categoryTemp = fixedAssetsMachineMgr.getCashedTable();
                        }
                    } else {
                        categoryTemp = fixedAssetsMachineMgr.getCashedTable();
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                category = new Vector();
                EmpBasicMgr basicMgr = EmpBasicMgr.getInstance();
                index = (count + 1) * 10;
                id = "";
                checkattched = new Vector();
                supplementMgr = SupplementMgr.getInstance();
                if (categoryTemp.size() < index) {
                    index = categoryTemp.size();
                }
                projectMgr = ProjectMgr.getInstance();
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) categoryTemp.get(i);
                    fixedAssetsDataWbo = fixedAssetsDataMgr.getOnSingleKey(wbo.getAttribute("machineNo").toString());
                    if (fixedAssetsDataWbo.getAttribute("groupNo") == null) {
                        System.out.println("11111111111111111111");
                    }
                    String getMachineName = wbo.getAttribute("machineName").toString();
                    if (getMachineName.contains("\"")) {
                        getMachineName = getMachineName.replace("\"", "");
                        wbo.setAttribute("machineName", getMachineName);

                    }
                    wbo.setAttribute("groupNo", fixedAssetsDataWbo.getAttribute("groupNo"));
                    wbo.setAttribute("groupDesc", fixedAssetsDataWbo.getAttribute("groupDesc"));
                    wbo.setAttribute("subGroupNo", fixedAssetsDataWbo.getAttribute("subGroupNo"));
                    wbo.setAttribute("subGroupDesc", fixedAssetsDataWbo.getAttribute("subGroupDesc"));
                    wbo.setAttribute("costCode", (fixedAssetsDataWbo.getAttribute("costCode").equals("NON")) ? "1" : fixedAssetsDataWbo.getAttribute("costCode"));
                    if (!fixedAssetsDataWbo.getAttribute("locationId").equals("NON")) {
                        String projectName = projectMgr.getSiteNameById((String) fixedAssetsDataWbo.getAttribute("locationId"));
                        if (!projectName.equals("")) {
                            wbo.setAttribute("locationName", projectName);
                            wbo.setAttribute("locationId", fixedAssetsDataWbo.getAttribute("locationId"));
                        } else {
                            wbo.setAttribute("locationName", "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D");
                            wbo.setAttribute("locationId", "");
                        }
                    } else {
                        wbo.setAttribute("locationName", "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D");
                        wbo.setAttribute("locationId", "");
                    }
                    if (!fixedAssetsDataWbo.getAttribute("empCode").equals("NON")) {

                        String emNa = basicMgr.getEmployeeName(fixedAssetsDataWbo.getAttribute("empCode").toString());
                        if (emNa != null) {
                            wbo.setAttribute("empNa", emNa);
                            wbo.setAttribute("empCode", fixedAssetsDataWbo.getAttribute("empCode").toString());
                        } else {
                            wbo.setAttribute("empNa", "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D");
                            wbo.setAttribute("empCode", "");
                        }
                    } else {
                        wbo.setAttribute("empNa", "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D");
                        wbo.setAttribute("empCode", "");
                    }
                    wbo.setAttribute("costName", (fixedAssetsDataWbo.getAttribute("costName").equals("NON")) ? "\u063A\u064A\u0631 \u0645\u062A\u0627\u062D" : fixedAssetsDataWbo.getAttribute("costName"));
                    category.add(wbo);

                }
                noOfLinks = categoryTemp.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                session.removeAttribute("CategoryID");
                servedPage = "/docs/new_report/fixedAsset_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("searchType", searchType);
                request.setAttribute("unitCode", unitCode);
                request.setAttribute("formName", formName);

                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 36:
                single = request.getParameter("single");
                month = 0;
                int years = 1900;
                int yearNow = 0;
                String[] monthsArr = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                monthsList = new ArrayList();
                ArrayList yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                WebBusinessObject yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", monthsArr[i]);
                    monthsList.add(wbo);
                }
                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();

                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    allEquipments.add(wbo);
                }
                if (single != null) {
                    servedPage = "/docs/new_report/monthly_Equip_Report_form_1.jsp";
                } else {
                    servedPage = "/docs/new_report/monthly_Equip_Report_form.jsp";
                }

                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", monthsArr[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                if (single != null) {
                    this.forward(servedPage, request, response);
                } else {
                    this.forwardToServedPage(request, response);
                }
                break;

            case 37:

                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                parentId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                Vector machinList = new Vector();
                Vector machinUnderJobList = new Vector();
                Vector daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                Vector unitJobs = new Vector();
                Hashtable scheduleJobs = new Hashtable();
                WebBusinessObject scheduleWbo = new WebBusinessObject();
                WebBusinessObject categoryWbo = new WebBusinessObject();
                Vector equipByCategory = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                DateFormat dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                java.sql.Date beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                java.sql.Date endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
                tempDayMgr.executeDateOfMonth(beginMonth, endMonth);
                daysOfMonth = tempDayMgr.getAllDayOfMonth();
                categoryWbo = maintainableMgr.getOnSingleKey(parentId);
                equipByCategory = maintainableMgr.getAllEquipment(parentId);
                try {

                    machinList = monthlyJobOrderMgr.getOnArbitraryKeyOrdered(parentId, "key2", "key3");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                for (int i = 0; i < machinList.size(); i++) {
                    WebBusinessObject equipJobWbo = (WebBusinessObject) machinList.get(i);
                    unitId = equipJobWbo.getAttribute("unitId").toString();
                    unitName = equipJobWbo.getAttribute("unitName").toString();
                    try {
                        unitJobs = monthlyJobOrderMgr.getOnArbitraryKeyOracle(unitId, "key3");
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                    scheduleJobs.put(unitId, unitJobs);
                }

                servedPage = "/docs/new_report/schedule_monthlyJobs_forMachine.jsp";

                request.setAttribute("categoryId", parentId);
                request.setAttribute("monthOfYear", monthOfYear);
                request.setAttribute("year", year);

                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);
                request.setAttribute("scheduleJobs", scheduleJobs);
                request.setAttribute("daysOfMonth", daysOfMonth);
                request.setAttribute("machinList", machinList);
                request.setAttribute("equipByCategory", equipByCategory);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 38:
                month = 0;
                years = 1900;
                yearNow = 0;
                ArrayList proLine = new ArrayList();
                String[] monthsName = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", monthsName[i]);
                    monthsList.add(wbo);
                }
                proLine = productionLineMgr.getCashedTableAsBusObjects();

                servedPage = "/docs/new_report/monthly_Equip_Report_ByProLine_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", monthsName[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", proLine);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 39:

                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                String proLineId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                Vector equipByProLine = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
                tempDayMgr.executeDateOfMonth(beginMonth, endMonth);
                daysOfMonth = tempDayMgr.getAllDayOfMonth();
                categoryWbo = productionLineMgr.getOnSingleKey(proLineId);

                try {
                    equipByProLine = maintainableMgr.getOnArbitraryDoubleKeyOracle(proLineId, "key7", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                try {
                    machinList = monthlyJobOrderMgr.getOnArbitraryKeyOrdered(proLineId, "key5", "key3");

                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                for (int i = 0; i < machinList.size(); i++) {
                    WebBusinessObject equipJobWbo = (WebBusinessObject) machinList.get(i);
                    unitId = equipJobWbo.getAttribute("unitId").toString();
                    unitName = equipJobWbo.getAttribute("unitName").toString();
                    try {
                        unitJobs = monthlyJobOrderMgr.getOnArbitraryKeyOracle(unitId, "key3");
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                    scheduleJobs.put(unitId, unitJobs);
                }

                servedPage = "/docs/new_report/schedule_monthlyJobs_byProLine_forMachine.jsp";

                request.setAttribute("categoryId", proLineId);
                request.setAttribute("monthOfYear", monthOfYear);
                request.setAttribute("year", year);

                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);
                request.setAttribute("scheduleJobs", scheduleJobs);
                request.setAttribute("daysOfMonth", daysOfMonth);
                request.setAttribute("machinList", machinList);
                request.setAttribute("equipByProLine", equipByProLine);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 40:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                month = 0;
                years = 1900;
                yearNow = 0;
                ArrayList basicType = new ArrayList();
                String[] nameOfMonth = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", nameOfMonth[i]);
                    monthsList.add(wbo);
                }
                basicType = mainTypeMgr.getCashedTableAsBusObjects();

                servedPage = "/docs/new_report/monthly_Equip_Report_BybasicType_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", nameOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", basicType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 41:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                basicTypeId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                Vector equipByBasicType = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
                tempDayMgr.executeDateOfMonth(beginMonth, endMonth);
                daysOfMonth = tempDayMgr.getAllDayOfMonth();
                categoryWbo = mainTypeMgr.getOnSingleKey(basicTypeId);

                try {

                    equipByBasicType = maintainableMgr.getOnArbitraryDoubleKeyOracle(basicTypeId, "key10", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                try {
                    machinList = monthlyJobOrderMgr.getOnArbitraryKeyOrdered(basicTypeId, "key6", "key3");

                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                for (int i = 0; i < machinList.size(); i++) {
                    WebBusinessObject equipJobWbo = (WebBusinessObject) machinList.get(i);
                    unitId = equipJobWbo.getAttribute("unitId").toString();
                    unitName = equipJobWbo.getAttribute("unitName").toString();
                    try {
                        unitJobs = monthlyJobOrderMgr.getOnArbitraryKeyOracle(unitId, "key3");
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                    scheduleJobs.put(unitId, unitJobs);
                }

                servedPage = "/docs/new_report/schedule_monthlyJobs_byBasictype_forMachine.jsp";

                request.setAttribute("categoryId", basicTypeId);
                request.setAttribute("year", year);
                request.setAttribute("monthOfYear", monthOfYear);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);
                request.setAttribute("scheduleJobs", scheduleJobs);
                request.setAttribute("daysOfMonth", daysOfMonth);
                request.setAttribute("machinList", machinList);
                request.setAttribute("equipByBasicType", equipByBasicType);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 42:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                month = 0;
                years = 1900;
                yearNow = 0;
//                 String[] arrOfMonth = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

                basicType = new ArrayList();
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", arrOfMonth[i]);
                    monthsList.add(wbo);
                }
                basicType = mainTypeMgr.getCashedTableAsBusObjects();

                servedPage = "/docs/new_report/monthly_sprPart_Report_BybasicType_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", arrOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", basicType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 43:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                basicTypeId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                Vector totalVec = new Vector();
                String scheduleId = null;
                WebBusinessObject totalItemWbo = new WebBusinessObject();
                WebBusinessObject schWbo = new WebBusinessObject();
                WebBusinessObject itemWbo = new WebBusinessObject();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth();
                categoryWbo = mainTypeMgr.getOnSingleKey(basicTypeId);
                Vector scheduleVec = new Vector();
                Vector schItemVec = new Vector();

                if (!scheduleByItemMgr.checkcompiledViewScheduleByItem()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {
                    schItemVec = scheduleByItemMgr.getAllScheduleItem();

                    scheduleVec = scheduleByJobOrderMgr.getScheduleByBasicTypeInRange(basicTypeId, beginMonth, endMonth);

                    try {
                        tempTotalItemMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schItemVec.size(); x++) {
                            itemWbo = (WebBusinessObject) schItemVec.get(x);
                            if (itemWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalItemWbo.setAttribute("itemId", itemWbo.getAttribute("itemId"));
                                totalItemWbo.setAttribute("itemName", itemWbo.getAttribute("itemName"));
                                totalItemWbo.setAttribute("total", itemWbo.getAttribute("qnty"));
                                totalItemWbo.setAttribute("totalCost", itemWbo.getAttribute("totalCost"));
                                try {
                                    tempTotalItemMgr.saveObject(totalItemWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalItemMgr.getTotalItem();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/sparePart_monthlyJobs_byBasictype_forMachine.jsp";

                request.setAttribute("categoryId", basicTypeId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 44:
                month = 0;
                years = 1900;
                yearNow = 0;
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", arrOfMonth[i]);
                    monthsList.add(wbo);
                }
                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();

                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    allEquipments.add(wbo);
                }

                servedPage = "/docs/new_report/monthly_sprPart_Report_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", arrOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 45:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                parentId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth(); 
                categoryWbo = maintainableMgr.getOnSingleKey(parentId);
                scheduleVec = new Vector();
                schItemVec = new Vector();

                if (!scheduleByItemMgr.checkcompiledViewScheduleByItem()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {

                    schItemVec = scheduleByItemMgr.getAllScheduleItem();
                    totalVec = new Vector();
                    scheduleId = null;
                    totalItemWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    itemWbo = new WebBusinessObject();
                    scheduleVec = scheduleByJobOrderMgr.getScheduleByTypeInRange(parentId, beginMonth, endMonth);

                    try {
                        tempTotalItemMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schItemVec.size(); x++) {
                            itemWbo = (WebBusinessObject) schItemVec.get(x);
                            if (itemWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalItemWbo.setAttribute("itemId", itemWbo.getAttribute("itemId"));
                                totalItemWbo.setAttribute("itemName", itemWbo.getAttribute("itemName"));
                                totalItemWbo.setAttribute("total", itemWbo.getAttribute("qnty"));
                                totalItemWbo.setAttribute("totalCost", itemWbo.getAttribute("totalCost"));
                                try {
                                    tempTotalItemMgr.saveObject(totalItemWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalItemMgr.getTotalItem();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/sparePart_monthlyJobs_byType_forMachine.jsp";

                request.setAttribute("categoryId", parentId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 46:
                month = 0;
                years = 1900;
                yearNow = 0;
                proLine = new ArrayList();
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", arrOfMonth[i]);
                    monthsList.add(wbo);
                }
                proLine = productionLineMgr.getCashedTableAsBusObjects();

                servedPage = "/docs/new_report/monthly_sprPart_Report_ByProLine_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", arrOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", proLine);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 47:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                proLineId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth(); 
                categoryWbo = productionLineMgr.getOnSingleKey(proLineId);
                scheduleVec = new Vector();
                schItemVec = new Vector();

                if (!scheduleByItemMgr.checkcompiledViewScheduleByItem()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {

                    schItemVec = scheduleByItemMgr.getAllScheduleItem();
                    totalVec = new Vector();
                    scheduleId = null;
                    totalItemWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    itemWbo = new WebBusinessObject();
                    scheduleVec = scheduleByJobOrderMgr.getScheduleByProLineInRange(proLineId, beginMonth, endMonth);

                    try {
                        tempTotalItemMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schItemVec.size(); x++) {
                            itemWbo = (WebBusinessObject) schItemVec.get(x);
                            if (itemWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalItemWbo.setAttribute("itemId", itemWbo.getAttribute("itemId"));
                                totalItemWbo.setAttribute("itemName", itemWbo.getAttribute("itemName"));
                                totalItemWbo.setAttribute("total", itemWbo.getAttribute("qnty"));
                                totalItemWbo.setAttribute("totalCost", itemWbo.getAttribute("totalCost"));
                                try {
                                    tempTotalItemMgr.saveObject(totalItemWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalItemMgr.getTotalItem();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/sparePart_monthlyJobs_byProLine_forMachine.jsp";

                request.setAttribute("categoryId", proLineId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 48:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                month = 0;
                years = 1900;
                yearNow = 0;
//                 String[] arrOfMonth = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

                basicType = new ArrayList();
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", arrOfMonth[i]);
                    monthsList.add(wbo);
                }
                basicType = mainTypeMgr.getCashedTableAsBusObjects();

                servedPage = "/docs/new_report/monthly_labor_Report_BybasicType_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", arrOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", basicType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 49:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                basicTypeId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                Vector schTitleVec = new Vector();

                WebBusinessObject totalTaskWbo = new WebBusinessObject();
                schWbo = new WebBusinessObject();
                WebBusinessObject taskWbo = new WebBusinessObject();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth();
                categoryWbo = mainTypeMgr.getOnSingleKey(basicTypeId);
                scheduleVec = new Vector();
                Vector schTaskVec = new Vector();

                if (!scheduleByEmpTitleMgr.checkcompiledViewScheduleByempTitle()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {

                    schTitleVec = scheduleByEmpTitleMgr.getAllScheduleEmpTitle();
                    totalVec = new Vector();
                    scheduleId = null;

                    scheduleVec = scheduleByJobOrderMgr.getScheduleByBasicTypeInRange(basicTypeId, beginMonth, endMonth);

                    try {
                        tempTotalEmpTitleMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schTitleVec.size(); x++) {
                            taskWbo = (WebBusinessObject) schTitleVec.get(x);
                            if (taskWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalTaskWbo.setAttribute("empTitle", taskWbo.getAttribute("empTitle"));
                                totalTaskWbo.setAttribute("empTitleName", taskWbo.getAttribute("empTitleName"));
                                totalTaskWbo.setAttribute("totalHrs", taskWbo.getAttribute("execHrs"));
                                try {
                                    tempTotalEmpTitleMgr.saveObject(totalTaskWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalEmpTitleMgr.getTotalTitle();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/labor_monthlyJobs_byBasictype_forMachine.jsp";

                request.setAttribute("categoryId", basicTypeId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 50:
                month = 0;
                years = 1900;
                yearNow = 0;
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", arrOfMonth[i]);
                    monthsList.add(wbo);
                }
                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();

                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    allEquipments.add(wbo);
                }

                servedPage = "/docs/new_report/monthly_labor_Report_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", arrOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 51:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                parentId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth();
                categoryWbo = maintainableMgr.getOnSingleKey(parentId);
                scheduleVec = new Vector();
                schTaskVec = new Vector();

                if (!scheduleByEmpTitleMgr.checkcompiledViewScheduleByempTitle()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {

                    schTitleVec = scheduleByEmpTitleMgr.getAllScheduleEmpTitle();
                    totalVec = new Vector();
                    scheduleId = null;
                    totalTaskWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    taskWbo = new WebBusinessObject();
                    scheduleVec = scheduleByJobOrderMgr.getScheduleByTypeInRange(parentId, beginMonth, endMonth);

                    try {
                        tempTotalEmpTitleMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schTitleVec.size(); x++) {
                            taskWbo = (WebBusinessObject) schTitleVec.get(x);
                            if (taskWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalTaskWbo.setAttribute("empTitle", taskWbo.getAttribute("empTitle"));
                                totalTaskWbo.setAttribute("empTitleName", taskWbo.getAttribute("empTitleName"));
                                totalTaskWbo.setAttribute("totalHrs", taskWbo.getAttribute("execHrs"));
                                try {
                                    tempTotalEmpTitleMgr.saveObject(totalTaskWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalEmpTitleMgr.getTotalTitle();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/labor_monthlyJobs_forMachine.jsp";

                request.setAttribute("categoryId", parentId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 52:
                month = 0;
                years = 1900;
                yearNow = 0;
                proLine = new ArrayList();
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", arrOfMonth[i]);
                    monthsList.add(wbo);
                }
                proLine = productionLineMgr.getCashedTableAsBusObjects();

                servedPage = "/docs/new_report/monthly_labor_Report_ByProLine_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", arrOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", proLine);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 53:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                proLineId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth();
                categoryWbo = productionLineMgr.getOnSingleKey(proLineId);
                scheduleVec = new Vector();
                schTaskVec = new Vector();

                if (!scheduleByEmpTitleMgr.checkcompiledViewScheduleByempTitle()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {

                    schTitleVec = scheduleByEmpTitleMgr.getAllScheduleEmpTitle();
                    totalVec = new Vector();
                    scheduleId = null;
                    totalTaskWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    taskWbo = new WebBusinessObject();
                    scheduleVec = scheduleByJobOrderMgr.getScheduleByProLineInRange(proLineId, beginMonth, endMonth);

                    try {
                        tempTotalEmpTitleMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schTitleVec.size(); x++) {
                            taskWbo = (WebBusinessObject) schTitleVec.get(x);
                            if (taskWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalTaskWbo.setAttribute("empTitle", taskWbo.getAttribute("empTitle"));
                                totalTaskWbo.setAttribute("empTitleName", taskWbo.getAttribute("empTitleName"));
                                totalTaskWbo.setAttribute("totalHrs", taskWbo.getAttribute("execHrs"));
                                try {
                                    tempTotalEmpTitleMgr.saveObject(totalTaskWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalEmpTitleMgr.getTotalTitle();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/labor_monthlyJobs_byProLine_forMachine.jsp";

                request.setAttribute("categoryId", proLineId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 54:
                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();

                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                        allEquipments.add(wbo);
                    }
                }

                servedPage = "/docs/new_report/select_eqMaint_table.jsp";
                request.setAttribute("EqReadReport", request.getParameter("EqReadReport").toString());
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 55:
                maintainableMgr = MaintainableMgr.getInstance();
                equipmetWboVec = null;
                String get = (String) request.getParameter("get");
                WebBusinessObject eqpWbo = new WebBusinessObject();
                Vector equips = new Vector();
                Hashtable eqpHistoryList = new Hashtable();
                equipmentStatusMgr = EquipmentStatusMgr.getInstance();

                unitId = (String) request.getParameter("equipmentId");
                eqID = "";

                if (unitId != null && !unitId.equals("")) {
                    String[] parts = unitId.split(",");
                    unitName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        eqID += c;
                    }
                }

                Vector vecStatus = new Vector();
                if (get.equalsIgnoreCase("eq")) {

                    System.out.print("Equip ID" + eqID);
                    if (!eqID.equalsIgnoreCase("") || eqID != null) {

                        try {
                            getEqId = maintainableMgr.getOnArbitraryKey(eqID, "key4");
                            tempWboForId = (WebBusinessObject) getEqId.get(0);
                            eqID = tempWboForId.getAttribute("id").toString();
                            System.out.print("Equip ID" + eqID);
                            vecStatus = equipmentStatusMgr.getStatusHistory(eqID);
                            eqpHistoryList.put(eqID, vecStatus);
                            request.setAttribute("equipmentID", eqID);
                        } catch (SQLException ex) {
                            servedPage = "/docs/new_report/select_eqMaint_table.jsp";
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                            servedPage = "/docs/new_report/select_eqMaint_table.jsp";
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                        }
                    }

                } else {
                    try {
                        equips = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        for (int i = 0; i < equips.size(); i++) {
                            eqpWbo = (WebBusinessObject) equips.get(i);
                            eqID = eqpWbo.getAttribute("id").toString();
                            vecStatus = equipmentStatusMgr.getStatusHistory(eqID);
                            eqpHistoryList.put(eqID, vecStatus);
                            request.setAttribute("equipmentID", "All");
                        }

                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                servedPage = "/docs/new_report/equipment_status_history.jsp";

                request.setAttribute("eqpHistoryList", eqpHistoryList);
                request.setAttribute("data", vecStatus);

                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 56:

                Vector parentEqpVec = new Vector();
                EqpVec = new Vector();
                allMainCats = new Vector();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                eqpByParentId = new Hashtable();
                parentId = null;
                maintainableMgr = MaintainableMgr.getInstance();
                equipmetWboVec = null;
                eqID = (String) request.getParameter("equipmentId");
                options = (String[]) request.getParameterValues("equipmentData");
                if (eqID.equalsIgnoreCase("all")) {
                    String query = "select * from (select ";
                    if (options == null || options.length <= 0) {
                        query += "ID,UNIT_NAME ,UNIT_NO, PARENT_ID, MAIN_TYPE_ID  ";
                    } else {
                        query += "ID,UNIT_NAME ,UNIT_NO, PARENT_ID, MAIN_TYPE_ID, ";
                        for (int i = 0; i < options.length; i++) {
                            query += options[i] + ",";
                        }
                        query = query.trim().substring(0, query.length() - 1);
                    }

                    query += " FROM maintainable_unit WHERE IS_DELETED = '0' and PARENT_ID != '0' order by PARENT_ID)";

                    equipmetWboVec = maintainableMgr.getEquipmentRecordAll(query);

                    parentEqpVec = maintainableMgr.getParentBySort();

                    for (int x = 0; x < parentEqpVec.size(); x++) {
                        WebBusinessObject parentEqpWbo = (WebBusinessObject) parentEqpVec.get(x);
                        parentId = parentEqpWbo.getAttribute("id").toString();
                        try {
                            EqpVec = maintainableMgr.getEqpbyParentSorting(parentEqpWbo.getAttribute("id").toString());
                            allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
                            finalEqpsVec = checkIsAgroupEq(EqpVec, allMainCats);
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }

                        eqpByParentId.put(parentId, EqpVec);
                    }

                    servedPage = "/docs/new_report/equipment_Report_All_by_Cat.jsp";
                    request.setAttribute("parentEqpVec", parentEqpVec);
                    request.setAttribute("eqpByParentId", eqpByParentId);
                    request.setAttribute("allBrands", "allBrands");
                    //request.setAttribute("EqpVec", equipmetWboVec);
                } else {
                    WebBusinessObject equipWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(eqID);

                    String query = "select ";
                    if (options == null || options.length <= 0) {
                        query += "ID,UNIT_NAME ,UNIT_NO,PARENT_ID, MAIN_TYPE_ID";
                    } else {
                        query += "ID,UNIT_NAME ,UNIT_NO,PARENT_ID, MAIN_TYPE_ID,";
                        for (int i = 0; i < options.length; i++) {
                            query += options[i] + ",";
                        }
                        query = query.trim().substring(0, query.length() - 1);
                    }

                    query += " FROM maintainable_unit WHERE PARENT_ID = " + eqID + " and IS_DELETED = '0' order by UNIT_NAME ";
                    equipmetWboVec = maintainableMgr.getEquipmentRecordAll(query);
                    try {

                        parentEqpVec = maintainableMgr.getOnArbitraryKey(eqID, "key");
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    for (int x = 0; x < parentEqpVec.size(); x++) {
                        WebBusinessObject parentEqpWbo = (WebBusinessObject) parentEqpVec.get(x);
                        parentId = parentEqpWbo.getAttribute("id").toString();
                        try {
                            EqpVec = maintainableMgr.getEqpbyParentSorting(parentEqpWbo.getAttribute("id").toString());
                            allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
                            finalEqpsVec = checkIsAgroupEq(EqpVec, allMainCats);
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                        eqpByParentId.put(parentId, EqpVec);
                    }

                    servedPage = "/docs/new_report/equipment_Report_All_by_Cat.jsp";
                    request.setAttribute("parentEqpVec", parentEqpVec);
                    request.setAttribute("oneCategoury", "oneCategoury");
                    request.setAttribute("eqpByParentId", eqpByParentId);
                    // request.setAttribute("EqpVec", equipmetWboVec);
                }

                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                request.setAttribute("EqpVec", equipmetWboVec);
//                try {
//                    allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
//                    finalEqpsVec = checkIsAgroupEq(equipmetWboVec, allMainCats);
//                    request.setAttribute("data", finalEqpsVec);
//                    
//                } catch (SQLException ex) {
//                    ex.printStackTrace();
//                } catch (Exception ex) {
//                    ex.printStackTrace();
//                }

                request.setAttribute("items", options);

                this.forward(servedPage, request, response);

                break;

            case 57:
                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();

                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    //if(!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0"))
                    allEquipments.add(wbo);
                }

                servedPage = "/docs/new_report/select_eq_report_ByAll_Brand.jsp";
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 58:

                parentEqpVec = new Vector();
                EqpVec = new Vector();
                allMainCats = new Vector();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                eqpByParentId = new Hashtable();
                parentId = null;
                maintainableMgr = MaintainableMgr.getInstance();
                equipmetWboVec = null;

                parentEqpVec = maintainableMgr.getParentBySort();

                for (int x = 0; x < parentEqpVec.size(); x++) {
                    WebBusinessObject parentEqpWbo = (WebBusinessObject) parentEqpVec.get(x);
                    parentId = parentEqpWbo.getAttribute("id").toString();
                    try {
                        EqpVec = maintainableMgr.getEqpbyParentSorting(parentEqpWbo.getAttribute("id").toString());
                        allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
                        finalEqpsVec = checkIsAgroupEq(EqpVec, allMainCats);
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                    eqpByParentId.put(parentId, EqpVec);
                }

                servedPage = "/docs/new_report/summary_eqp_by_brands.jsp";
                request.setAttribute("parentEqpVec", parentEqpVec);
                request.setAttribute("eqpByParentId", eqpByParentId);
                request.setAttribute("allBrands", "allBrands");

                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();

                try {
                    allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
                    finalEqpsVec = checkIsAgroupEq(equipmetWboVec, allMainCats);
                    request.setAttribute("data", finalEqpsVec);
                    request.setAttribute("EqpVec", equipmetWboVec);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                this.forward(servedPage, request, response);

                break;

            case 59:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                maintainableMgr = MaintainableMgr.getInstance();
                equipmetWboVec = null;
                basicTypeVec = new Vector();
                EqpVec = new Vector();
                eqpByParentId = new Hashtable();
                brandByBasicTypeId = new Hashtable();
                basicTypeWbo = new WebBusinessObject();
                brandByBasicTypeVec = new Vector();
                parentId = null;
                mainTypeId = (String) request.getParameter("mainTypeId");
                finalEqpsVec = new Vector();
                allMainCats = new Vector();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                basictypeId = null;

                basicTypeVec = mainTypeMgr.getAllBasictypeBySorting();
                for (int i = 0; i < basicTypeVec.size(); i++) {
                    basicTypeWbo = (WebBusinessObject) basicTypeVec.get(i);
                    basictypeId = basicTypeWbo.getAttribute("id").toString();
                    brandByBasicTypeVec = maintainableMgr.getBrandByBasictype(basictypeId);
                    for (int x = 0; x < brandByBasicTypeVec.size(); x++) {
                        WebBusinessObject parentEqpWbo = (WebBusinessObject) brandByBasicTypeVec.get(x);
                        parentId = parentEqpWbo.getAttribute("id").toString();
                        try {
                            EqpVec = maintainableMgr.getEqpbyParentSorting(parentEqpWbo.getAttribute("id").toString());
                            allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
                            finalEqpsVec = checkIsAgroupEq(EqpVec, allMainCats);
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }

                        eqpByParentId.put(parentId, EqpVec);
                    }
                    brandByBasicTypeId.put(basictypeId, brandByBasicTypeVec);
                }
                servedPage = "/docs/new_report/summary_eqp_by_basicType.jsp";
                request.setAttribute("brandByBasicTypeId", brandByBasicTypeId);
                request.setAttribute("eqpByParentId", eqpByParentId);
                request.setAttribute("basicTypeVec", basicTypeVec);

                try {
                    allMainCats = mainTypeMgr.getOnArbitraryKey("1", "key2");
                    // finalEqpsVec =checkIsAgroupEq(equipmetWboVec,allMainCats);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                request.setAttribute("mainTypeId", mainTypeId);
                request.setAttribute("data", finalEqpsVec);
                this.forward(servedPage, request, response);

                break;

            case 60:
                maintainableMgr = MaintainableMgr.getInstance();
                itemWboVec = new Vector();
                String categoryId = (String) request.getParameter("categoryId");
                taskMgr = TaskMgr.getInstance();
                Hashtable tasksByBrands = new Hashtable();

                options = (String[]) request.getParameterValues("itemData");

                if (categoryId.equalsIgnoreCase("all")) {
                    String query = "select ";
                    if (options == null || options.length <= 0) {
                        query += "TASK_NAME, PARENT_UNIT ";
                    } else {
                        query += "TASK_NAME , PARENT_UNIT, ";
                        for (int i = 0; i < options.length; i++) {
                            query += options[i] + ",";
                        }
                    }

                    query = query.trim().substring(0, query.length() - 1);
                    query += " FROM TASKS where IS_MAIN = 'no' order by PARENT_UNIT ";

                    parentEqpVec = maintainableMgr.getParentBySort();

                    itemWboVec = taskMgr.getItemRecordAll(query);
                    itemWbo = null;
                    WebBusinessObject unitWbo = null;
                    WebBusinessObject mainTypeWbo = null;
                    maintainableMgr = MaintainableMgr.getInstance();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();

                    //get first element in parent category
                    for (int x = 0; x < parentEqpVec.size(); x++) {
                        WebBusinessObject parentEqpWbo = (WebBusinessObject) parentEqpVec.get(x);
                        parentId = parentEqpWbo.getAttribute("id").toString();

                        itemWboVec = taskMgr.getTasksbyParentSorting(parentId);

                        if (itemWboVec != null && itemWboVec.size() > 0) {
                            WebBusinessObject firstItemWbo = (WebBusinessObject) itemWboVec.elementAt(0);
                            WebBusinessObject firstUnitWbo = maintainableMgr.getOnSingleKey(firstItemWbo.getAttribute("parentUnit").toString());
                            String flagName = firstUnitWbo.getAttribute("unitName").toString();
                            boolean firstTime = true;
                            for (int i = 0; i < itemWboVec.size(); i++) {
                                itemWbo = new WebBusinessObject();
                                unitWbo = new WebBusinessObject();

                                itemWbo = (WebBusinessObject) itemWboVec.get(i);

                                unitWbo = maintainableMgr.getOnSingleKey(itemWbo.getAttribute("parentUnit").toString());

                                if (unitWbo != null) {
                                    mainTypeWbo = new WebBusinessObject();
                                    mainTypeWbo = mainCategoryTypeMgr.getOnSingleKey(unitWbo.getAttribute("maintTypeId").toString());
                                    if (mainTypeWbo.getAttribute("isAgroupEq").toString().equals("0")) {
                                        if (flagName.equalsIgnoreCase(unitWbo.getAttribute("unitName").toString())) {
                                            if (firstTime == true) {
                                                firstTime = false;
                                                itemWbo.setAttribute("unitName", unitWbo.getAttribute("unitName").toString());
                                            } else {
                                                itemWbo.setAttribute("unitName", " ");
                                            }
                                        } else {
                                            flagName = unitWbo.getAttribute("unitName").toString();
                                            firstTime = false;
                                            itemWbo.setAttribute("unitName", unitWbo.getAttribute("unitName").toString());
                                        }
                                    } else {
                                        itemWboVec.remove(i);
                                        i--;
                                    }
                                } else {
                                    itemWboVec.remove(i);
                                    i--;
                                }
                            }

                            tasksByBrands.put(parentId, itemWboVec);
                        }
                    }

                    servedPage = "/docs/new_report/item_Report_all.jsp";
                    request.setAttribute("parentEqpVec", parentEqpVec);
                    request.setAttribute("tasksByBrands", tasksByBrands);
                    request.setAttribute("allBrands", "allBrands");

                } else {
                    WebBusinessObject catWbo = new WebBusinessObject();
                    catWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(categoryId);
                    try {
                        parentEqpVec = maintainableMgr.getOnArbitraryKey(categoryId, "key");

                        itemWboVec = taskMgr.getTasksbyParentSorting(categoryId);
                        tasksByBrands.put(categoryId, itemWboVec);
                        servedPage = "/docs/new_report/item_Report_all.jsp";
                        request.setAttribute("parentEqpVec", parentEqpVec);
                        request.setAttribute("tasksByBrands", tasksByBrands);
                        request.setAttribute("catWbo", catWbo);
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                    String query = "select ";
                    if (options == null || options.length <= 0) {
                        query += "TASK_NAME ";
                    } else {
                        query += "TASK_NAME , ";
                        for (int i = 0; i < options.length; i++) {
                            query += options[i] + ",";
                        }
                    }

                    query = query.trim().substring(0, query.length() - 1);
                    query += " FROM TASKS WHERE PARENT_UNIT = ? order by TASK_NAME ";

                    itemWboVec = taskMgr.getItemRecord(query, categoryId);

                }

                request.setAttribute("items", options);
                // request.setAttribute("data", itemWboVec);
                this.forward(servedPage, request, response);

                break;

            case 61:
                maintainableMgr = MaintainableMgr.getInstance();
                Vector equipments = new Vector();
                String productLineId = (String) request.getParameter("productLineId");
                productionLineMgr = ProductionLineMgr.getInstance();
                //WebBusinessObject pLineWbo = (WebBusinessObject) productionLineMgr.getOnSingleKey(productLineId);
                Hashtable equipByProLineId = new Hashtable();
                WebBusinessObject pLineWbo = new WebBusinessObject();
                Vector productioLineVec = new Vector();
                options = null;
                options = (String[]) request.getParameterValues("equipmentData");

                if (productLineId.equalsIgnoreCase("all")) {
                    productioLineVec = productionLineMgr.getProductLineBySort();

                    for (int x = 0; x < productioLineVec.size(); x++) {
                        pLineWbo = (WebBusinessObject) productioLineVec.get(x);
                        productLineId = (String) pLineWbo.getAttribute("id");

                        equipmetWboVec = maintainableMgr.getEqpByProLineSorting(productLineId);

                        equipByProLineId.put(productLineId, equipmetWboVec);
                    }
                    servedPage = "/docs/new_report/pLine_Eqps_Report.jsp";
                    request.setAttribute("productioLineVec", productioLineVec);
                    request.setAttribute("equipByProLineId", equipByProLineId);

                    //equipmetWboVec = maintainableMgr.getAllEquipmentByAllMainType();
                } else {

                    try {
                        productioLineVec = productionLineMgr.getOnArbitraryKey(productLineId, "key");
                        for (int x = 0; x < productioLineVec.size(); x++) {
                            pLineWbo = (WebBusinessObject) productioLineVec.get(x);
                            productLineId = (String) pLineWbo.getAttribute("id");

                            equipmetWboVec = maintainableMgr.getEqpByProLineSorting(productLineId);

                            equipByProLineId.put(productLineId, equipmetWboVec);
                        }
                        servedPage = "/docs/new_report/pLine_Eqps_Report.jsp";
                        request.setAttribute("productioLineVec", productioLineVec);
                        request.setAttribute("equipByProLineId", equipByProLineId);

                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                }

                request.setAttribute("pLineWbo", pLineWbo);
                request.setAttribute("items", options);
                this.forward(servedPage, request, response);
                break;
            case 62:
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                month = 0;
                years = 1900;
                yearNow = 0;
                basicType = new ArrayList();

                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", arrOfMonth[i]);
                    monthsList.add(wbo);
                }

                servedPage = "/docs/new_report/monthly_Equipment_Report_form.jsp";
                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", arrOfMonth[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 63:
                maintainableMgr = MaintainableMgr.getInstance();
                equipmetWboVec = null;
                eqpWbo = new WebBusinessObject();
                equips = new Vector();
                eqpHistoryList = new Hashtable();
                equipmentStatusMgr = EquipmentStatusMgr.getInstance();

                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                parentId = request.getParameter("categoryId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByCategory = new Vector();

                // unitJobs = new Vector();
                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
                tempDayMgr.executeDateOfMonth(beginMonth, endMonth);
                daysOfMonth = tempDayMgr.getAllDayOfMonth();
                categoryWbo = maintainableMgr.getOnSingleKey(parentId);
                equipByCategory = maintainableMgr.getAllEquipment(parentId);

                vecStatus = new Vector();

                eqID = (String) request.getParameter("equipmentId");
                if (!eqID.equalsIgnoreCase("") || eqID != null) {

                    try {
                        getEqId = maintainableMgr.getOnArbitraryKey(eqID, "key4");
                        tempWboForId = (WebBusinessObject) getEqId.get(0);
                        eqID = tempWboForId.getAttribute("id").toString();
                        unitJobs = monthlyJobOrderMgr.getOnArbitraryKeyOracle(eqID, "key3");
                        scheduleJobs.put(eqID, unitJobs);
                        request.setAttribute("categoryWbo", tempWboForId);
                        request.setAttribute("unitId", eqID);
                    } catch (SQLException ex) {
                        servedPage = "/docs/new_report/monthly_Equipment_Report_form.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                        servedPage = "/docs/new_report/monthly_Equipment_Report_form.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    }
                }

                servedPage = "/docs/new_report/schedule_monthlyJobs_forEquipment.jsp";

                request.setAttribute("scheduleJobs", scheduleJobs);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);
                request.setAttribute("monthOfYear", monthOfYear);
                request.setAttribute("year", year);
                request.setAttribute("daysOfMonth", daysOfMonth);

                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 64:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                unitId = request.getParameter("unitId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth(); 
                categoryWbo = maintainableMgr.getOnSingleKey(unitId);
                scheduleVec = new Vector();
                schItemVec = new Vector();

                if (!scheduleByItemMgr.checkcompiledViewScheduleByItem()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {

                    schItemVec = scheduleByItemMgr.getAllScheduleItem();
                    totalVec = new Vector();
                    scheduleId = null;
                    totalItemWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    itemWbo = new WebBusinessObject();
                    scheduleVec = scheduleByJobOrderMgr.getScheduleByEquipmentInRange(unitId, beginMonth, endMonth);

                    try {
                        tempTotalItemMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schItemVec.size(); x++) {
                            itemWbo = (WebBusinessObject) schItemVec.get(x);
                            if (itemWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalItemWbo.setAttribute("itemId", itemWbo.getAttribute("itemId"));
                                totalItemWbo.setAttribute("itemName", itemWbo.getAttribute("itemName"));
                                totalItemWbo.setAttribute("total", itemWbo.getAttribute("qnty"));
                                totalItemWbo.setAttribute("totalCost", itemWbo.getAttribute("totalCost"));
                                try {
                                    tempTotalItemMgr.saveObject(totalItemWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalItemMgr.getTotalItem();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/sparePart_monthlyJobs_byType_forEquipment.jsp";

                request.setAttribute("unitId", unitId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 65:
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                unitId = request.getParameter("unitId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByBasicType = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth();
                categoryWbo = maintainableMgr.getOnSingleKey(unitId);
                scheduleVec = new Vector();
                schTaskVec = new Vector();

                if (!scheduleByEmpTitleMgr.checkcompiledViewScheduleByempTitle()) {
                    request.setAttribute("ErrorView", "ErrorView");
                } else {

                    schTitleVec = scheduleByEmpTitleMgr.getAllScheduleEmpTitle();
                    totalVec = new Vector();
                    scheduleId = null;
                    totalTaskWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    taskWbo = new WebBusinessObject();
                    scheduleVec = scheduleByJobOrderMgr.getScheduleByEquipmentInRange(unitId, beginMonth, endMonth);

                    try {
                        tempTotalEmpTitleMgr.deleteTemp();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    for (int i = 0; i < scheduleVec.size(); i++) {
                        schWbo = (WebBusinessObject) scheduleVec.get(i);
                        scheduleId = (String) schWbo.getAttribute("scheduleId");
                        for (int x = 0; x < schTitleVec.size(); x++) {
                            taskWbo = (WebBusinessObject) schTitleVec.get(x);
                            if (taskWbo.getAttribute("scheduleId").equals(schWbo.getAttribute("scheduleId"))) {
                                totalTaskWbo.setAttribute("empTitle", taskWbo.getAttribute("empTitle"));
                                totalTaskWbo.setAttribute("empTitleName", taskWbo.getAttribute("empTitleName"));
                                totalTaskWbo.setAttribute("totalHrs", taskWbo.getAttribute("execHrs"));
                                try {
                                    tempTotalEmpTitleMgr.saveObject(totalTaskWbo);
                                } catch (SQLException ex) {
                                    ex.printStackTrace();
                                }
                            }

                        }

                    }

                    totalVec = tempTotalEmpTitleMgr.getTotalTitle();
                    request.setAttribute("totalVec", totalVec);
                }
                servedPage = "/docs/new_report/labor_monthlyJobs_forEquipment.jsp";

                request.setAttribute("unitId", unitId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 68:
                resultList = new Vector();
                resultByEmpList = new Vector();
                getEqId = new Vector();
                resultVec = new Vector();
                tempWboForId = new WebBusinessObject();
                unitId = request.getParameter("unitId");
                partId = request.getParameter("partId");
                empId = request.getParameter("empId");
                String catId = (String) request.getParameter("catId");
                issueId = null;
                Vector equipVec = new Vector();

                String typeOfCat = (String) request.getParameter("typeOfCat");
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                String catName = null;

                try {
                    if (typeOfCat != null && typeOfCat.equals("category")) {
                        equipVec = maintainableMgr.getOnArbitraryDoubleKey(catId, "key10", "0", "key5");
                        catName = mainCategoryTypeMgr.getOnSingleKey(catId).getAttribute("typeName").toString();
                    } else if (typeOfCat != null && typeOfCat.equals("equipment")) {
                        equipVec = maintainableMgr.getOnArbitraryDoubleKey(catId, "key1", "0", "key5");
                        catName = maintainableMgr.getOnSingleKey(catId).getAttribute("unitName").toString();
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                wbo = new WebBusinessObject();
                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");
                bDateArr = new String[3];
                eDateArr = new String[3];
                bDateArr = bDate.split("-");
                eDateArr = eDate.split("-");
                int bYear = Integer.parseInt(bDateArr[0]);
                int bMonth = Integer.parseInt(bDateArr[1]);
                int bDay = Integer.parseInt(bDateArr[2]);

                int eYear = Integer.parseInt(eDateArr[0]);
                int eMonth = Integer.parseInt(eDateArr[1]);
                int eDay = Integer.parseInt(eDateArr[2]);

//                eYear=Integer.parseInt(eDateArr[0]);
//                eMonth=Integer.parseInt(eDateArr[2]);
//                eDay=Integer.parseInt(eDateArr[1]);
                beginDate = new java.sql.Date(bYear - 1900, bMonth - 1, bDay);
                endDate = new java.sql.Date(eYear - 1900, eMonth - 1, eDay);

                dateParser = new DateParser();
//                beginDate=dateParser.formatSqlDate(bDate);
//                endDate=dateParser.formatSqlDate(eDate);

                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                equipByIssue = EquipByIssueMgr.getInstance();
                empTasksHoursMgr = EmpTasksHoursMgr.getInstance();

                resultVec = equipByIssue.getAllEqTasksInRange(beginDate, endDate);

                Vector newResutVec = new Vector();
                for (int i = 0; i < equipVec.size(); i++) {
                    WebBusinessObject unitWbo = (WebBusinessObject) equipVec.get(i);
                    unitId = (String) unitWbo.getAttribute("id");
                    for (int x = 0; x < resultVec.size(); x++) {
                        WebBusinessObject resultWbo = (WebBusinessObject) resultVec.get(x);

                        if (unitId.equals(resultWbo.getAttribute("unitId"))) {
                            newResutVec.add(resultWbo);

                        }
                    }
                }

                request.setAttribute("resultVec", newResutVec);
                servedPage = "/docs/new_report/weekly_issue_report.jsp";

                request.setAttribute("unitId", unitId);
                request.setAttribute("typeOfCat", typeOfCat);
                request.setAttribute("catName", catName);
                request.setAttribute("empId", empId);
                request.setAttribute("partId", partId);
                request.setAttribute("bDate", bDate);
                request.setAttribute("eDate", eDate);

                this.forward(servedPage, request, response);

                break;

            case 69:
                resultList = new Vector();
                resultByEmpList = new Vector();
                getEqId = new Vector();
                resultVec = new Vector();
                tempWboForId = new WebBusinessObject();
                unitId = request.getParameter("unitId");
                partId = request.getParameter("partId");
                empId = request.getParameter("empId");
                catId = (String) request.getParameter("catId");
                issueId = null;
                equipVec = new Vector();

                typeOfCat = (String) request.getParameter("typeOfCat");
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                catName = null;

                try {
                    if (typeOfCat != null && typeOfCat.equals("category")) {
                        equipVec = maintainableMgr.getOnArbitraryDoubleKey(catId, "key10", "0", "key5");
                        catName = mainCategoryTypeMgr.getOnSingleKey(catId).getAttribute("typeName").toString();
                    } else if (typeOfCat != null && typeOfCat.equals("equipment")) {
                        equipVec = maintainableMgr.getOnArbitraryDoubleKey(catId, "key1", "0", "key5");
                        catName = maintainableMgr.getOnSingleKey(catId).getAttribute("unitName").toString();
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                wbo = new WebBusinessObject();
                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");
                bDateArr = new String[3];
                eDateArr = new String[3];
                bDateArr = bDate.split("-");
                eDateArr = eDate.split("-");
                bYear = Integer.parseInt(bDateArr[0]);
                bMonth = Integer.parseInt(bDateArr[1]);
                bDay = Integer.parseInt(bDateArr[2]);

                eYear = Integer.parseInt(eDateArr[0]);
                eMonth = Integer.parseInt(eDateArr[1]);
                eDay = Integer.parseInt(eDateArr[2]);

//                eYear=Integer.parseInt(eDateArr[0]);
//                eMonth=Integer.parseInt(eDateArr[2]);
//                eDay=Integer.parseInt(eDateArr[1]);
                beginDate = new java.sql.Date(bYear - 1900, bMonth - 1, bDay);
                endDate = new java.sql.Date(eYear - 1900, eMonth - 1, eDay);

                dateParser = new DateParser();
//                beginDate=dateParser.formatSqlDate(bDate);
//                endDate=dateParser.formatSqlDate(eDate);

                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                equipByIssue = EquipByIssueMgr.getInstance();
                empTasksHoursMgr = EmpTasksHoursMgr.getInstance();

                resultVec = equipByIssue.getAllEqTasksInRange(beginDate, endDate);
                newResutVec = new Vector();
                for (int i = 0; i < equipVec.size(); i++) {
                    WebBusinessObject unitWbo = (WebBusinessObject) equipVec.get(i);
                    unitId = (String) unitWbo.getAttribute("id");
                    for (int x = 0; x < resultVec.size(); x++) {
                        WebBusinessObject resultWbo = (WebBusinessObject) resultVec.get(x);

                        if (unitId.equals(resultWbo.getAttribute("unitId"))) {
                            newResutVec.add(resultWbo);

                        }
                    }
                }

                request.setAttribute("resultVec", newResutVec);
                servedPage = "/docs/new_report/monthly_issue_report.jsp";

                request.setAttribute("unitId", unitId);
                request.setAttribute("typeOfCat", typeOfCat);
                request.setAttribute("catName", catName);
                request.setAttribute("empId", empId);
                request.setAttribute("partId", partId);
                request.setAttribute("bDate", bDate);
                request.setAttribute("eDate", eDate);

                this.forward(servedPage, request, response);

                break;

            case 66:

                servedPage = "/docs/new_report/show_canceled_JOrders.jsp";

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 67:
                WebBusinessObject wbo1 = new WebBusinessObject();
                Vector resultsVector = new Vector();
                wbo = new WebBusinessObject();
                DateParser dateParser2 = new DateParser();

                String begDate = request.getParameter("beginDate");
                String edDate = request.getParameter("endDate");

                CanceledJobOrdersMgr cancelJobOrdr = CanceledJobOrdersMgr.getInstance();

                java.sql.Date startDate = dateParser2.formatSqlDate(begDate);
                java.sql.Date finishedDate = dateParser2.formatSqlDate(edDate);

                resultsVector = cancelJobOrdr.getCanceledJOrdersInRange(startDate, finishedDate);

                String servePage = "/docs/new_report/display_canceled_JOrders_result.jsp";

                request.setAttribute("page", servePage);

                request.setAttribute("bDate", begDate);

                request.setAttribute("eDate", edDate);

                request.setAttribute("resultVec", resultsVector);

                this.forward(servePage, request, response);

                break;

            case 70:
                Vector itemFormBySelectVec = new Vector();
                Vector itemFormByBasicVec = new Vector();
                Vector storesErpByBasicVec = new Vector();
                Vector branchErpByBasicVec = new Vector();
                storeCode = request.getParameter("storeCode");
                ItemFormListMgr itemFormBySelectMgr = ItemFormListMgr.getInstance();
                ItemFormMgr itemFormBasicMgr = ItemFormMgr.getInstance();
                StoresErpMgr storesErpBasicMgr = StoresErpMgr.getInstance();
                BranchErpMgr branchErpBasicMgr = BranchErpMgr.getInstance();

                itemFormBySelectVec = (Vector) itemFormBySelectMgr.getSelectedItemForm();
                itemFormByBasicVec = (Vector) itemFormBasicMgr.getAllBasicItemForm();
                storesErpByBasicVec = (Vector) storesErpBasicMgr.getAllBasicStoresErp();
                branchErpByBasicVec = (Vector) branchErpBasicMgr.getAllBasicBranchErp();

                servedPage = "/docs/new_report/add_item_form.jsp";

                request.setAttribute("storeCode", storeCode);
                request.setAttribute("itemFormBySelectVec", itemFormBySelectVec);
                request.setAttribute("itemFormByBasicVec", itemFormByBasicVec);
                request.setAttribute("storesErpByBasicVec", storesErpByBasicVec);
                request.setAttribute("branchErpByBasicVec", branchErpByBasicVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 71:
                AvgUnitMgr avgUnitMgr = AvgUnitMgr.getInstance();
                equipments = new Vector();
                MaintainableMgr maintenableUnit = MaintainableMgr.getInstance();
                maintenableUnit.cashData();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                Vector mainCategoriesVector = new Vector();
                Hashtable catEquipments = new Hashtable();
                maintainableMgr = MaintainableMgr.getInstance();
                WebBusinessObject mainCatWbo = new WebBusinessObject();
                String mainCatId = "";
                String totall = "";
                try {
                    //main categories without equipments that work as Eqps
                    mainCategoriesVector = mainCategoryTypeMgr.getOnArbitraryKey("0", "key2");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                for (int i = 0; i < mainCategoriesVector.size(); i++) {
                    mainCatWbo = new WebBusinessObject();
                    mainCatId = "";
                    mainCatWbo = (WebBusinessObject) mainCategoriesVector.get(i);
                    mainCatId = mainCatWbo.getAttribute("id").toString();
                    totall = avgUnitMgr.getTotalAvgEquipmentByMainCat(mainCatId);
                    // totall=maintainableMgr.getTotalEquipmentByMainCat(mainCatId);
                    catEquipments.put(mainCatId, totall);
                }

                servedPage = "/docs/new_report/reading_Reports_Acc2BasicTypes.jsp";

                request.setAttribute("catEqps", catEquipments);
                request.setAttribute("mainCatVec", mainCategoriesVector);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 72:

                String maintTypeId = (String) request.getParameter("mainCatId");
                maintTypeId = maintTypeId.trim();
                String isDeleted = "0";
                MaintainableMgr maintainMgr = MaintainableMgr.getInstance();
                Vector allEquips = new Vector();
                WebBusinessObject tempWBO = new WebBusinessObject();
                Vector averageUnit = new Vector();
                AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
                WebBusinessObject avergWbo = new WebBusinessObject();
                Vector averageVec = new Vector();
                MainCategoryTypeMgr mainCatTypeMgr = MainCategoryTypeMgr.getInstance();
                WebBusinessObject temprorayWBO = new WebBusinessObject();

                temprorayWBO = mainCatTypeMgr.getOnSingleKey(maintTypeId);

                try {
                    allEquips = maintainMgr.getAllEqpsForMainCat(maintTypeId);

                    for (int i = 0; i < allEquips.size(); i++) {
                        tempWBO = (WebBusinessObject) allEquips.get(i);
                        String equipmentID = tempWBO.getAttribute("id").toString();
                        averageUnit = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");

                        Enumeration e = averageUnit.elements();
                        while (e.hasMoreElements()) {

                            avergWbo = (WebBusinessObject) e.nextElement();
                            if (!avergWbo.getAttribute("acual_Reading").equals("0")) {
                                averageVec.add(avergWbo);
                            }

                        }
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                servedPage = "/docs/new_report/Eqps_Reports_List.jsp";

                request.setAttribute("averageVec", averageVec);
                request.setAttribute("temprorayWBO", temprorayWBO);
                this.forward(servedPage, request, response);

                break;

            case 73:
                equipments = new Vector();
                maintenableUnit = MaintainableMgr.getInstance();
                maintenableUnit.cashData();
//                categoryMgr.cashData();
                WebBusinessObject userWb0 = (WebBusinessObject) session.getAttribute("loggedUser");
                equipments = maintenableUnit.getAllCategoryEqu();
//                    equipments = maintenableUnit.getAllCategoryEquBySite(userWb0.getAttribute("projectID").toString());
                servedPage = "/docs/new_report/maintainable_Total_By_Category.jsp";

                request.setAttribute("data", equipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 74:

                maintTypeId = (String) request.getParameter("mainCatId");
                maintTypeId = maintTypeId.trim();
                isDeleted = "0";
                maintainMgr = MaintainableMgr.getInstance();
                allEquips = new Vector();
                tempWBO = new WebBusinessObject();
                averageUnit = new Vector();
                averageUnitMgr = AverageUnitMgr.getInstance();
                avergWbo = new WebBusinessObject();
                averageVec = new Vector();
                mainCatTypeMgr = MainCategoryTypeMgr.getInstance();
                temprorayWBO = new WebBusinessObject();

                temprorayWBO = maintainMgr.getOnSingleKey(maintTypeId);

                try {
                    allEquips = maintainMgr.getEqpbyParentSorting(maintTypeId);

                    for (int i = 0; i < allEquips.size(); i++) {
                        tempWBO = (WebBusinessObject) allEquips.get(i);
                        String equipmentID = tempWBO.getAttribute("id").toString();
                        averageUnit = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");

                        Enumeration e = averageUnit.elements();
                        while (e.hasMoreElements()) {

                            avergWbo = (WebBusinessObject) e.nextElement();
                            if (!avergWbo.getAttribute("acual_Reading").equals("0")) {
                                averageVec.add(avergWbo);
                            }

                        }
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                servedPage = "/docs/new_report/Eqps_Avg_List_By_Parent.jsp";

                request.setAttribute("averageVec", averageVec);
                request.setAttribute("temprorayWBO", temprorayWBO);
                this.forward(servedPage, request, response);

                break;

            case 75:
                itemFormBySelectMgr = ItemFormListMgr.getInstance();
                itemFormBasicMgr = ItemFormMgr.getInstance();
                storesErpBasicMgr = StoresErpMgr.getInstance();
                branchErpBasicMgr = BranchErpMgr.getInstance();
                Vector itemFormByStoreCode = new Vector();
                String[] itemsForm = request.getParameterValues("itemForm");
                itemFormCode = null;
                String codeForm[] = null;
                String branchCode = null;
                String remainStoreCode = null;
                storeCode = request.getParameter("stores");
                try {
                    itemFormByStoreCode = itemFormBySelectMgr.getOnArbitraryKey(storeCode, "key1");
                    if (itemFormByStoreCode.size() > 0) {
                        itemFormBySelectMgr.getDeleteItemForm(storeCode);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (request.getParameter("stores") != null) {
                    branchCode = storeCode.substring(0, 2);
                    remainStoreCode = storeCode.substring(2);
                }

                if (request.getParameterValues("itemForm") != null) {
                    for (int i = 0; i < itemsForm.length; i++) {
                        try {
                            itemFormCode = itemsForm[i];
                            codeForm = itemFormCode.split("-");

                            if (itemFormBySelectMgr.saveItemForm(codeForm[0], codeForm[1], branchCode, remainStoreCode, storeCode)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } catch (NoUserInSessionException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }

                itemFormBySelectVec = (Vector) itemFormBySelectMgr.getSelectedItemForm();
                itemFormByBasicVec = (Vector) itemFormBasicMgr.getAllBasicItemForm();
                storesErpByBasicVec = (Vector) storesErpBasicMgr.getAllBasicStoresErp();
                branchErpByBasicVec = (Vector) branchErpBasicMgr.getAllBasicBranchErp();
                servedPage = "/docs/new_report/add_item_form.jsp";
                request.setAttribute("itemFormBySelectVec", itemFormBySelectVec);
                request.setAttribute("itemFormByBasicVec", itemFormByBasicVec);
                request.setAttribute("storesErpByBasicVec", storesErpByBasicVec);
                request.setAttribute("branchErpByBasicVec", branchErpByBasicVec);
                request.setAttribute("storeCode", storeCode);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            /**
             * case 76: storesErpByBasicVec = new Vector(); branchErpByBasicVec
             * = new Vector(); Vector selectedStoresVec = new Vector(); Vector
             * firstBranchStoresVec = new Vector(); WebBusinessObject
             * storesErpBasicWbo = new WebBusinessObject(); WebBusinessObject
             * branchErpBasicWbo = new WebBusinessObject(); branchCode =
             * request.getParameter("branchCode");
             *
             * storesErpBasicMgr = StoresErpMgr.getInstance(); branchErpBasicMgr
             * = BranchErpMgr.getInstance();
             *
             * storesErpByBasicVec = (Vector)
             * storesErpBasicMgr.getAllBasicStoresErp(); branchErpByBasicVec =
             * (Vector) branchErpBasicMgr.getAllBasicBranchErp(); if (branchCode
             * != null) { for (int i = 0; i < storesErpByBasicVec.size(); i++) {
             * storesErpBasicWbo = (WebBusinessObject)
             * storesErpByBasicVec.get(i); storeCode = (String)
             * storesErpBasicWbo.getAttribute("code"); String subBranchCode =
             * storeCode.substring(0, 2); if
             * (subBranchCode.equalsIgnoreCase(branchCode)) {
             * selectedStoresVec.add(storesErpBasicWbo); } } } else { for (int i
             * = 0; i < storesErpByBasicVec.size(); i++) { storesErpBasicWbo =
             * (WebBusinessObject) storesErpByBasicVec.get(i); storeCode =
             * (String) storesErpBasicWbo.getAttribute("code"); String
             * subBranchCode = storeCode.substring(0, 2); branchErpBasicWbo =
             * (WebBusinessObject) branchErpByBasicVec.get(0); if
             * (subBranchCode.equalsIgnoreCase(branchErpBasicWbo.getAttribute("code").toString()))
             * { firstBranchStoresVec.add(storesErpBasicWbo); } } } servedPage =
             * "/docs/new_report/choose_activate_store.jsp";
             *
             * request.setAttribute("storesErpByBasicVec", storesErpByBasicVec);
             * request.setAttribute("branchErpByBasicVec", branchErpByBasicVec);
             * request.setAttribute("selectedStoresVec", selectedStoresVec);
             * request.setAttribute("firstBranchStoresVec",
             * firstBranchStoresVec); request.setAttribute("branchCode",
             * branchCode); request.setAttribute("page", servedPage);
             * this.forwardToServedPage(request, response); break;
             *
             */
            case 77:

                activeStoreMgr = ActiveStoreMgr.getInstance();
                storesErpBasicMgr = StoresErpMgr.getInstance();
                branchErpBasicMgr = BranchErpMgr.getInstance();

                WebBusinessObject storesErpBasicWbo = new WebBusinessObject();

                Vector activeBranchStoreVec = new Vector();
                storesErpByBasicVec = (Vector) storesErpBasicMgr.getAllBasicStoresErp();
                branchErpByBasicVec = (Vector) branchErpBasicMgr.getAllBasicBranchErp();
                Vector selectedStoresVec = new Vector();
                Vector firstBranchStoresVec = new Vector();

                branchCode = request.getParameter("branchCode");
                storeCode = request.getParameter("storeCode");

                if (request.getParameter("branchCode") != null) {
                    for (int i = 0; i < storesErpByBasicVec.size(); i++) {
                        storesErpBasicWbo = (WebBusinessObject) storesErpByBasicVec.get(i);
                        storeCode = (String) storesErpBasicWbo.getAttribute("code");
                        String subBranchCode = storeCode.substring(0, 2);
                        if (subBranchCode.equalsIgnoreCase(branchCode)) {
                            selectedStoresVec.add(storesErpBasicWbo);
                        }
                    }
                } else {
                    for (int i = 0; i < storesErpByBasicVec.size(); i++) {
                        storesErpBasicWbo = (WebBusinessObject) storesErpByBasicVec.get(i);
                        storeCode = (String) storesErpBasicWbo.getAttribute("code");
                        String subBranchCode = storeCode.substring(0, 2);
                        WebBusinessObject branchErpBasicWbo = (WebBusinessObject) branchErpByBasicVec.get(0);
                        if (subBranchCode.equalsIgnoreCase(branchErpBasicWbo.getAttribute("code").toString())) {
                            firstBranchStoresVec.add(storesErpBasicWbo);
                        }
                    }
                }

                try {
//                    activeBranchStoreVec = activeStoreMgr.getOnArbitraryKey(branchCode,"key");
//                    if(activeBranchStoreVec.size()>0) {
//                        activeStoreMgr.getDeleteActiveStore();
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    activeStoreMgr.deleteOnArbitraryKey(securityUser.getUserId(), "key2");
//                    }
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (request.getParameter("storeCode") != null) {
                    try {
                        if (activeStoreMgr.saveActiveStore(branchCode, request.getParameter("storeCode").toString(), session)) {
                            request.setAttribute("Status", "Ok");
                            request.getSession().setAttribute("branchCode", branchCode);
                            request.getSession().setAttribute("storeCode", request.getParameter("storeCode").toString());
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                servedPage = "/docs/new_report/choose_activate_store.jsp";

                request.setAttribute("storesErpByBasicVec", storesErpByBasicVec);
                request.setAttribute("branchErpByBasicVec", branchErpByBasicVec);
                request.setAttribute("selectedStoresVec", selectedStoresVec);
                request.setAttribute("firstBranchStoresVec", firstBranchStoresVec);
                request.setAttribute("branchCode", branchCode);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 78:
                itemName = (String) request.getParameter("itemName");
                itemNumber = (String) request.getParameter("itemNumber");
                vecItems = new Vector();
                storeCode = (String) request.getParameter("storeCode").toString();
                itemsMgr = ItemsMgr.getInstance();
                itemForm = (String) request.getParameter("itemForm");
                count = 0;
                url = "ReportsServlet?op=sparePartByStore";
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 50;

                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                servedPage = "/docs/new_report/items_list_by_store.jsp";

                distItemsMgr = DistributedItemsMgr.getInstance();
                storeId = "";
                userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

                try {

                    vecItems = itemsMgr.getOnArbitraryDoubleKey(itemForm, "key4", storeCode, "key5");

                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                itemList = new Vector();

                if (vecItems.size() < index) {
                    index = vecItems.size();
                }
                for (int i = count * 50; i < index; i++) {
                    wbo = (WebBusinessObject) vecItems.get(i);
                    itemList.add(wbo);
                }

                noOfLinks = vecItems.size() / 50f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                request.setAttribute("itemName", itemName);
                request.setAttribute("itemNumber", itemNumber);
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("storeCode", storeCode);
                request.setAttribute("itemForm", itemForm);
                request.setAttribute("data", itemList);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 79:

                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();
                ArrayList brands = new ArrayList();
                ArrayList trade = new ArrayList();
                Vector brandsVec = new Vector();
                wbo = new WebBusinessObject();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                mainCategories = new ArrayList();
                mainCategories = mainTypeMgr.getCashedTableAsBusObjects();
                projectMgr = ProjectMgr.getInstance();
                userProjectsMgr = UserProjectsMgr.getInstance();

                Vector projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                tradeMgr = TradeMgr.getInstance();
                trade = tradeMgr.getCashedTableAsBusObjects();
                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    brandsVec = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                        allEquipments.add(wbo);
                    }
                }
                for (int i = 0; i < brandsVec.size(); i++) {
                    wbo = (WebBusinessObject) brandsVec.get(i);
                    //if(!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0"))
                    brands.add(wbo);
                }

                servedPage = "/docs/new_report/costingSchedule_eqJO_report.jsp";
                request.setAttribute("currentMode", "Ar");

                request.setAttribute("schedule", "yes");
                request.setAttribute("mainCategories", mainCategories);
                request.setAttribute("brands", brands);
                request.setAttribute("trade", trade);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("allSites", projects);
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 80:

                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();
                brands = new ArrayList();
                trade = new ArrayList();
                brandsVec = new Vector();
                wbo = new WebBusinessObject();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();
                mainCategories = new ArrayList();
                mainCategories = mainTypeMgr.getCashedTableAsBusObjects();
                projectMgr = ProjectMgr.getInstance();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                tradeMgr = TradeMgr.getInstance();
                trade = tradeMgr.getCashedTableAsBusObjects();
                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    brandsVec = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                        allEquipments.add(wbo);
                    }
                }
                for (int i = 0; i < brandsVec.size(); i++) {
                    wbo = (WebBusinessObject) brandsVec.get(i);
                    //if(!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0"))
                    brands.add(wbo);
                }

                servedPage = "/docs/new_report/costingNormal_eqJO_report.jsp";
                request.setAttribute("currentMode", "Ar");

                request.setAttribute("schedule", "yes");
                request.setAttribute("mainCategories", mainCategories);
                request.setAttribute("brands", brands);
                request.setAttribute("allSites", projects);
                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("trade", trade);
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 81:
                scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                equipByIssue = EquipByIssueMgr.getInstance();
                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                maintainableMgr = MaintainableMgr.getInstance();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                resultList = new Vector();
                resultByEmpList = new Vector();
                getEqId = new Vector();
                resultVec = new Vector();
                tempWboForId = new WebBusinessObject();
                String branchIdTemp = null;
                String branchId = null;

                String[] sitesId = (String[]) request.getParameterValues("sites");
                String[] branchesId = null;
                for (int x = 0; x < sitesId.length; x++) {
                    branchIdTemp = sitesId[x];
                    branchesId = branchIdTemp.split(",");
                }

                String brandId = request.getParameter("brandId");
                mainTypeId = request.getParameter("mainTypeId");
                unitId = request.getParameter("unitId");
                partId = request.getParameter("partId");
                taskId = request.getParameter("taskId");
                String tradeId = request.getParameter("trade");
                issueId = null;

                wbo = new WebBusinessObject();
                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");

                dateParser = new DateParser();
                beginDate = dateParser.formatSqlDate(bDate);
                endDate = dateParser.formatSqlDate(eDate);

                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                issueTasksMgr = IssueTasksMgr.getInstance();
                futureEquipByIssueMgr = FutureEquipByIssueMgr.getInstance();
                empTasksHoursMgr = EmpTasksHoursMgr.getInstance();

                if (mainTypeId != null && !mainTypeId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndMainType(beginDate, endDate, mainTypeId);
                    request.setAttribute("mainTypeId", mainTypeId);
                } else if (brandId != null && !brandId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndBrand(beginDate, endDate, brandId);
                    request.setAttribute("brandId", brandId);
                } else if (unitId != null && !unitId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndEquip(beginDate, endDate, unitId);
                    request.setAttribute("unitId", unitId);
                } else {
                    resultVec = equipByIssue.getAllEqTasksInRange(beginDate, endDate);

                }

                if (taskId != null && !taskId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        issueId = wbo.getAttribute("issueId").toString();
                        Vector issueItems = new Vector();
                        try {
                            issueItems = (Vector) issueTasksMgr.getOnArbitraryKey(issueId, "key1");
//                            if(issueItems.size()==0 ){
//                                issueItems = (Vector) scheduleTasksMgr.getOnArbitraryKey(wbo.getAttribute("scheduleId").toString(),"key1");
//                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueItems.size() > 0) {
                            for (int x = 0; x < issueItems.size(); x++) {
                                itemWbo = new WebBusinessObject();
                                itemWbo = (WebBusinessObject) issueItems.get(x);
                                if (taskId.equals(itemWbo.getAttribute("codeTask").toString())) {
                                    resultList.add(wbo);
                                }
                            }
                        }
                    }
                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                if (partId != null && !partId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        try {
                            issueParts = quantifiedMntenceMgr.getOnArbitraryKey(wbo.getAttribute("unitScheduleID").toString(), "key1");
//                            if(issueParts.size() ==0){
//                            issueParts = configureMainTypeMgr.getOnArbitraryKey(wbo.getAttribute("scheduleId").toString(), "key1");
//                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueParts.size() > 0) {
                            for (int x = 0; x < issueParts.size(); x++) {
                                WebBusinessObject sparPartWbo = new WebBusinessObject();
                                WebBusinessObject sparPartsByTasksWbo = new WebBusinessObject();
                                sparPartsByTasksWbo = (WebBusinessObject) issueParts.get(x);
                                if (sparPartsByTasksWbo.getAttribute("isDirectPrch").toString().equals("0")) {
                                    if (partId.equals(sparPartsByTasksWbo.getAttribute("itemId").toString())) {
                                        resultList.add(wbo);
                                    }

                                }

                            }
                        }
                    }

                    resultVec.removeAllElements();
                    resultVec = resultList;
                }
                resultList.clear();
                if (branchIdTemp != null && !branchIdTemp.equals("")) {
                    for (int z = 0; z < branchesId.length; z++) {
                        branchId = branchesId[z];
                        for (int i = 0; i < resultVec.size(); i++) {
                            wbo = (WebBusinessObject) resultVec.get(i);
                            if (branchId.equals(wbo.getAttribute("siteId"))) {
                                resultList.add(wbo);
                            }

                        }
                    }
                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                if (tradeId != null && !tradeId.equals("") && !tradeId.equals("all")) {

                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        if (tradeId.equals(wbo.getAttribute("tradeId"))) {
                            resultList.add(wbo);
                        }

                    }

                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                request.setAttribute("resultVec", resultVec);
                servedPage = "/docs/new_report/costingSchedule_eqJO_ViewReport.jsp";

                request.setAttribute("taskId", taskId);
                request.setAttribute("partId", partId);
                request.setAttribute("tradeId", tradeId);
                request.setAttribute("bDate", bDate);
                request.setAttribute("eDate", eDate);

                this.forward(servedPage, request, response);
                break;

            case 82:
                scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                equipByIssue = EquipByIssueMgr.getInstance();
                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                maintainableMgr = MaintainableMgr.getInstance();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                resultList = new Vector();
                resultByEmpList = new Vector();
                getEqId = new Vector();
                resultVec = new Vector();
                tempWboForId = new WebBusinessObject();
                branchIdTemp = null;
                branchId = null;

                sitesId = (String[]) request.getParameterValues("sites");
                branchesId = null;
                for (int x = 0; x < sitesId.length; x++) {
                    branchIdTemp = sitesId[x];
                    branchesId = branchIdTemp.split(",");
                }

                brandId = request.getParameter("brandId");
                mainTypeId = request.getParameter("mainTypeId");
                unitId = request.getParameter("unitId");
                partId = request.getParameter("partId");
                taskId = request.getParameter("taskId");
                tradeId = request.getParameter("trade");
                issueId = null;

                wbo = new WebBusinessObject();
                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");

                dateParser = new DateParser();
                beginDate = dateParser.formatSqlDate(bDate);
                endDate = dateParser.formatSqlDate(eDate);

                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                issueTasksMgr = IssueTasksMgr.getInstance();
                futureEquipByIssueMgr = FutureEquipByIssueMgr.getInstance();
                empTasksHoursMgr = EmpTasksHoursMgr.getInstance();

                if (mainTypeId != null && !mainTypeId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndMainTypeByEMG(beginDate, endDate, mainTypeId);
                    request.setAttribute("mainTypeId", mainTypeId);
                } else if (brandId != null && !brandId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndBrandByEMG(beginDate, endDate, brandId);
                    request.setAttribute("brandId", brandId);
                } else if (unitId != null && !unitId.equals("")) {
                    resultVec = equipByIssue.getEqTasksInRangeAndEquipByEMG(beginDate, endDate, unitId);
                    request.setAttribute("unitId", unitId);
                } else {
                    resultVec = equipByIssue.getEqTasksInRangeByEMG(beginDate, endDate);
                }

                if (taskId != null && !taskId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        issueId = wbo.getAttribute("issueId").toString();
                        Vector issueItems = new Vector();
                        try {
                            issueItems = (Vector) issueTasksMgr.getOnArbitraryKey(issueId, "key1");
//                            if(issueItems.size()==0 ){
//                                issueItems = (Vector) scheduleTasksMgr.getOnArbitraryKey(wbo.getAttribute("scheduleId").toString(),"key1");
//                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueItems.size() > 0) {
                            for (int x = 0; x < issueItems.size(); x++) {
                                itemWbo = new WebBusinessObject();
                                itemWbo = (WebBusinessObject) issueItems.get(x);
                                if (taskId.equals(itemWbo.getAttribute("codeTask").toString())) {
                                    resultList.add(wbo);
                                }
                            }
                        }
                    }
                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                if (partId != null && !partId.equals("")) {
                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        Vector issueParts = new Vector();
                        try {
                            issueParts = quantifiedMntenceMgr.getOnArbitraryKey(wbo.getAttribute("unitScheduleID").toString(), "key1");
//                            if(issueParts.size() ==0){
//                            issueParts = configureMainTypeMgr.getOnArbitraryKey(wbo.getAttribute("scheduleId").toString(), "key1");
//                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        if (issueParts.size() > 0) {
                            for (int x = 0; x < issueParts.size(); x++) {
                                WebBusinessObject sparPartWbo = new WebBusinessObject();
                                WebBusinessObject sparPartsByTasksWbo = new WebBusinessObject();
                                sparPartsByTasksWbo = (WebBusinessObject) issueParts.get(x);
                                if (sparPartsByTasksWbo.getAttribute("isDirectPrch").toString().equals("0")) {
                                    if (partId.equals(sparPartsByTasksWbo.getAttribute("itemId").toString())) {
                                        resultList.add(wbo);
                                    }

                                }

                            }
                        }
                    }

                    resultVec.removeAllElements();
                    resultVec = resultList;
                }
                resultList.clear();
                if (branchIdTemp != null && !branchIdTemp.equals("")) {
                    for (int z = 0; z < branchesId.length; z++) {
                        branchId = branchesId[z];
                        for (int i = 0; i < resultVec.size(); i++) {
                            wbo = (WebBusinessObject) resultVec.get(i);
                            if (branchId.equals(wbo.getAttribute("siteId"))) {
                                resultList.add(wbo);
                            }

                        }
                    }
                    resultVec.removeAllElements();
                    resultVec = resultList;
                }
                resultList.clear();
                if (tradeId != null && !tradeId.equals("") && !tradeId.equals("all")) {

                    for (int i = 0; i < resultVec.size(); i++) {
                        wbo = (WebBusinessObject) resultVec.get(i);
                        if (tradeId.equals(wbo.getAttribute("tradeId"))) {
                            resultList.add(wbo);
                        }

                    }

                    resultVec.removeAllElements();
                    resultVec = resultList;
                }

                request.setAttribute("resultVec", resultVec);
                servedPage = "/docs/new_report/costingNormal_eqJO_ViewReport.jsp";

                request.setAttribute("taskId", taskId);
                request.setAttribute("partId", partId);
                request.setAttribute("tradeId", tradeId);
                request.setAttribute("bDate", bDate);
                request.setAttribute("eDate", eDate);

                this.forward(servedPage, request, response);
                break;

            case 83:
                storesErpByBasicVec = new Vector();
                branchErpByBasicVec = new Vector();
                selectedStoresVec = new Vector();
                activeStoreMgr = ActiveStoreMgr.getInstance();
                BranchErpMgr branchErpMgr = BranchErpMgr.getInstance();
                firstBranchStoresVec = new Vector();
                storesErpBasicWbo = new WebBusinessObject();
                WebBusinessObject branchErpBasicWbo = new WebBusinessObject();
                activeStoreVec = activeStoreMgr.getActiveStore(session);
                activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
                branchCode = branchErpMgr.getOnSingleKey(activeStoreWbo.getAttribute("branchCode").toString()).getAttribute("code").toString();

                storesErpBasicMgr = StoresErpMgr.getInstance();
                branchErpBasicMgr = BranchErpMgr.getInstance();

                storesErpByBasicVec = (Vector) storesErpBasicMgr.getAllBasicStoresErp();
                branchErpByBasicVec = (Vector) branchErpBasicMgr.getAllBasicBranchErp();
                if (branchCode != null) {
                    for (int i = 0; i < storesErpByBasicVec.size(); i++) {
                        storesErpBasicWbo = (WebBusinessObject) storesErpByBasicVec.get(i);
                        storeCode = (String) storesErpBasicWbo.getAttribute("code");
                        String subBranchCode = storeCode.substring(0, 2);
                        if (subBranchCode.equalsIgnoreCase(branchCode)) {
                            selectedStoresVec.add(storesErpBasicWbo);
                        }
                    }
                } else {
                    for (int i = 0; i < storesErpByBasicVec.size(); i++) {
                        storesErpBasicWbo = (WebBusinessObject) storesErpByBasicVec.get(i);
                        storeCode = (String) storesErpBasicWbo.getAttribute("code");
                        String subBranchCode = storeCode.substring(0, 2);
                        branchErpBasicWbo = (WebBusinessObject) branchErpByBasicVec.get(0);
                        if (subBranchCode.equalsIgnoreCase(branchErpBasicWbo.getAttribute("code").toString())) {
                            firstBranchStoresVec.add(storesErpBasicWbo);
                        }
                    }
                }
                servedPage = "/docs/new_report/change_activate_store.jsp";

                request.setAttribute("storesErpByBasicVec", storesErpByBasicVec);
                request.setAttribute("branchErpByBasicVec", branchErpByBasicVec);
                request.setAttribute("selectedStoresVec", selectedStoresVec);
                request.setAttribute("firstBranchStoresVec", firstBranchStoresVec);
                request.setAttribute("branchCode", branchCode);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 84:

                activeStoreMgr = ActiveStoreMgr.getInstance();
                storesErpBasicMgr = StoresErpMgr.getInstance();
                branchErpBasicMgr = BranchErpMgr.getInstance();

                storesErpBasicWbo = new WebBusinessObject();

                activeBranchStoreVec = new Vector();
                storesErpByBasicVec = (Vector) storesErpBasicMgr.getAllBasicStoresErp();
                branchErpByBasicVec = (Vector) branchErpBasicMgr.getAllBasicBranchErp();
                selectedStoresVec = new Vector();
                firstBranchStoresVec = new Vector();

                branchCode = request.getParameter("branchCode");
                storeCode = request.getParameter("storeCode");

                if (request.getParameter("branchCode") != null) {
                    for (int i = 0; i < storesErpByBasicVec.size(); i++) {
                        storesErpBasicWbo = (WebBusinessObject) storesErpByBasicVec.get(i);
                        storeCode = (String) storesErpBasicWbo.getAttribute("code");
                        String subBranchCode = storeCode.substring(0, 2);
                        if (subBranchCode.equalsIgnoreCase(branchCode)) {
                            selectedStoresVec.add(storesErpBasicWbo);
                        }
                    }
                } else {
                    for (int i = 0; i < storesErpByBasicVec.size(); i++) {
                        storesErpBasicWbo = (WebBusinessObject) storesErpByBasicVec.get(i);
                        storeCode = (String) storesErpBasicWbo.getAttribute("code");
                        String subBranchCode = storeCode.substring(0, 2);
                        branchErpBasicWbo = (WebBusinessObject) branchErpByBasicVec.get(0);
                        if (subBranchCode.equalsIgnoreCase(branchErpBasicWbo.getAttribute("code").toString())) {
                            firstBranchStoresVec.add(storesErpBasicWbo);
                        }
                    }
                }

                try {
//                    activeBranchStoreVec = activeStoreMgr.getOnArbitraryKey(branchCode,"key");
//                    if(activeBranchStoreVec.size()>0) {
//                        activeStoreMgr.getDeleteActiveStore();
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    activeStoreMgr.deleteOnArbitraryKey(securityUser.getUserId(), "key2");
//                    }
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (request.getParameter("storeCode") != null) {
                    try {
                        if (activeStoreMgr.saveActiveStore(branchCode, request.getParameter("storeCode").toString(), session)) {
                            request.setAttribute("Status", "Ok");
                            request.getSession().setAttribute("branchCode", branchCode);
                            request.getSession().setAttribute("storeCode", request.getParameter("storeCode").toString());
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                servedPage = "/docs/new_report/change_activate_store.jsp";

                request.setAttribute("storesErpByBasicVec", storesErpByBasicVec);
                request.setAttribute("branchErpByBasicVec", branchErpByBasicVec);
                request.setAttribute("selectedStoresVec", selectedStoresVec);
                request.setAttribute("firstBranchStoresVec", firstBranchStoresVec);
                request.setAttribute("branchCode", branchCode);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 85:

                ////////////////
                activeStoreVec = new Vector();
                itemList = new Vector();
                activeStoreMgr = ActiveStoreMgr.getInstance();
                itemFormMgr = ItemFormListMgr.getInstance();
                activeStoreVec = new Vector();
                activeStoreVec = activeStoreMgr.getActiveStore(session);
                activeStoreWbo = new WebBusinessObject();
                activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
                itemFormCodeWbo = new WebBusinessObject();
                itemFormListVec = new Vector();
                links = 0;
                noOfLinks = 0;
                temp = null;
                intNo = 0;
                try {
                    itemFormListVec = (Vector) itemFormMgr.getOnArbitraryKeyOrdered(activeStoreWbo.getAttribute("storeCode").toString(), "key1", "key");
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                itemFormCodeWbo = (WebBusinessObject) itemFormListVec.get(0);
                itemFormCode = (String) itemFormCodeWbo.getAttribute("codeForm");
                itemsMgr = ItemsMgr.getInstance();
                itemForm = (String) request.getParameter("itemForm");
                sparePart = (String) request.getParameter("partCode");
                partIdByForm = (String) request.getParameter("partIdByForm");

                formName = (String) request.getParameter("formName");
                if (sparePart != null && !sparePart.equals("")) {
                    String[] parts = sparePart.split(",");
                    sparePart = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        sparePart += c;
                    }
                }

                items = new Vector();
                count = 0;
                url = "ReportsServlet?op=sparePartsList&formName=" + formName;
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 50;
                itemsMgr = ItemsMgr.getInstance();
                activeStoreVec = activeStoreMgr.getActiveStore(session);
                if (activeStoreVec.size() > 0) {
                    if (partIdByForm != null && !partIdByForm.equals("")) {
                        String[] item_Form = partIdByForm.split("-");
                        items = itemsMgr.getSparePartByFinalCodeAndItemForm(sparePart, item_Form[0], session);
                        itemForm = item_Form[0];
                    } else {
                        if (itemForm != null && !itemForm.equals("")) {
                            if (sparePart != null && !sparePart.equals("")) {
                                items = itemsMgr.getSparePartByFinalCodeAndItemForm(sparePart, itemForm, session);
                            } else {
                                items = itemsMgr.getSparePartByFinalCodeAndItemForm("", itemForm, session);
                            }
                        } else {
                            if (sparePart != null && !sparePart.equals("")) {
                                items = itemsMgr.getSparePartByFinalCodeAndItemForm(sparePart, itemFormCode, session);
                            } else {
                                items = itemsMgr.getSparePartByFinalCodeAndItemForm("", itemFormCode, session);
                            }
                        }
                    }
                    itemList = new Vector();

                    if (items.size() < index) {
                        index = items.size();
                    }
                    for (int i = count * 50; i < index; i++) {
                        wbo = (WebBusinessObject) items.get(i);
                        itemList.add(wbo);
                    }

                    noOfLinks = items.size() / 50f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }
                    request.setAttribute("data", itemList);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("setupStore", "1");
                } else {
                    request.setAttribute("setupStore", "0");
                }

                //////////////
                servedPage = "/docs/issue/parts_list.jsp";

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("partName", sparePart);
                request.setAttribute("formName", formName);

                request.setAttribute("numRows", request.getParameter("numRows"));

                request.setAttribute("data", itemList);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 86:
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                siteId = securityUser.getSiteId();
                String userId = securityUser.getUserId();
                String searchBy = securityUser.getSearchBy();

                unitName = (String) request.getParameter("unitName");
                formName = (String) request.getParameter("formName");
                String ok = request.getParameter("ok");
                if (ok != null && ok.equalsIgnoreCase("ok")) {
                    request.setAttribute("Shoow", "ok");
                }
                if (unitName != null && !unitName.equals("")) {
                    String[] parts = unitName.split(",");
                    unitName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        unitName += c;
                    }
                }
                categoryTemp = new Vector();
                count = 0;
                url = "ReportsServlet?op=listEquipmentBySite";
                maintainableMgr = MaintainableMgr.getInstance();
                try {
                    if (unitName != null && !unitName.equals("") && !unitName.equals("null")) {
                        categoryTemp = maintainableMgr.getEquipBySubNameOrCode(unitName, securityUser.getBranchesAsArray(), "name");
                    } else {
                        categoryTemp = maintainableMgr.getEquipmentsByBranches(securityUser.getBranchesAsArray());
                    }
//                    if(unitName != null && !unitName.equals("")){
//                        if((userId.equals("1")) || (searchBy.equals("all"))){
//                            categoryTemp = maintainableMgr.getEquipBySubName(unitName);
//                        }else
//                            categoryTemp = maintainableMgr.getEquipBySubNameAndSiteId(siteId, unitName);
//                    }else {
//                        if((userId.equals("1")) || (searchBy.equals("all"))){
//                            categoryTemp = maintainableMgr.getOnArbitraryDoubleKeyOracle("1", "key3", "0", "key5");
//                        }else
//                            categoryTemp = maintainableMgr.getEquipBySiteId(siteId);
//                    }
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                category = new Vector();

                index = (count + 1) * 10;
                id = "";
                checkattched = new Vector();
                supplementMgr = SupplementMgr.getInstance();
                if (categoryTemp.size() < index) {
                    index = categoryTemp.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) categoryTemp.get(i);

                    category.add(wbo);

                }

                noOfLinks = categoryTemp.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                // to reload the parant
                String reload = request.getParameter("reload");
                if (reload == null) {
                    reload = "";
                }
                if (reload.equals("ok")) {
                    String reloadUrl = request.getParameter("reloadUrl");
                    request.setAttribute("reload", "ok");
                    request.setAttribute("reloadUrl", reloadUrl);
                    url = "ReportsServlet?op=listEquipmentBySite&reload=" + reload + "&reloadUrl=" + reloadUrl;
                }

                session.removeAttribute("CategoryID");
                servedPage = "/docs/new_report/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);
                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 87:
                servedPage = "/docs/Search/search_maintenace_details.jsp";
                ArrayList allTrade = tradeMgr.getAllAsArrayList();
                ArrayList allSites = projectMgr.getAllAsArrayList();
                ArrayList allMainType = mainCategoryTypeMgr.getAllAsArrayList();

                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", allSites);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 88:
                unitName = request.getParameter("unitName");
                formName = request.getParameter("formName");
                String strSites = request.getParameter("sites");
                strSites = strSites.trim();
                String mainType = request.getParameter("type");

                String[] listSites = strSites.split(" ");

                if (unitName != null && !unitName.equals("")) {
                    String[] parts = unitName.split(",");
                    unitName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        unitName += c;
                    }
                }

                categoryTemp = new Vector();
                count = 0;
                url = "ReportsServlet?op=selectEquipment&sites=" + strSites + "&type=" + mainType;
                maintainableMgr = MaintainableMgr.getInstance();
                try {
                    if (unitName != null && !unitName.equals("")) {
                    } else {
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                category = new Vector();

                index = (count + 1) * 10;
                if (categoryTemp.size() < index) {
                    index = categoryTemp.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) categoryTemp.get(i);

                    category.add(wbo);

                }

                noOfLinks = categoryTemp.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                session.removeAttribute("CategoryID");
                servedPage = "/docs/new_report/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);

                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 89:
                servedPage = "/docs/new_report/search_Equip_Out_Of_Order_By_date.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 90:
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                siteId = securityUser.getSiteId();
                userId = securityUser.getUserId();
                searchBy = securityUser.getSearchBy();

                unitName = request.getParameter("unitName");
                formName = request.getParameter("formName");
                String typeOfRate = request.getParameter("typeOfRate");
                ok = request.getParameter("ok");
                if (ok != null && ok.equalsIgnoreCase("ok")) {
                    request.setAttribute("Shoow", "ok");
                }
                if (unitName != null && !unitName.equals("")) {
                    String[] parts = unitName.split(",");
                    unitName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        unitName += c;
                    }
                }
                categoryTemp = new Vector();
                count = 0;
                url = "ReportsServlet?op=listEquipmentBySiteByTypeOfRate";
                maintainableMgr = MaintainableMgr.getInstance();
                try {
                    if (unitName != null && !unitName.equals("")) {
                        if ((userId.equals("1")) || (searchBy.equals("all"))) {
                            categoryTemp = maintainableMgr.getEquipByTypeOfRateBySubName(unitName, typeOfRate);
                        } else {
                            categoryTemp = maintainableMgr.getEquipByTypeOfRateBySubNameAndSite(siteId, unitName, typeOfRate);
                        }
                    } else {
                        if ((userId.equals("1")) || (searchBy.equals("all"))) {
                            categoryTemp = maintainableMgr.getEquipByTypeOfRate(typeOfRate);
                        } else {
                            categoryTemp = maintainableMgr.getEquipByTypeOfRateBySiteId(siteId, typeOfRate);
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                category = new Vector();

                index = (count + 1) * 10;
                id = "";
                checkattched = new Vector();
                supplementMgr = SupplementMgr.getInstance();
                if (categoryTemp.size() < index) {
                    index = categoryTemp.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) categoryTemp.get(i);

                    category.add(wbo);

                }

                noOfLinks = categoryTemp.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                // to reload the parant
                reload = request.getParameter("reload");
                if (reload == null) {
                    reload = "";
                }
                if (reload.equals("ok")) {
                    String reloadUrl = request.getParameter("reloadUrl");
                    request.setAttribute("reload", "ok");
                    request.setAttribute("reloadUrl", reloadUrl);
                    url = "ReportsServlet?op=listEquipmentBySite&reload=" + reload + "&reloadUrl=" + reloadUrl;
                }

                session.removeAttribute("CategoryID");
                servedPage = "/docs/new_report/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("typeOfRate", typeOfRate);
                request.setAttribute("formName", formName);
                request.setAttribute("ok", ok);
                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 91:
                servedPage = "docs/new_report/form_details.jsp";
                SelfDocMgr selfDocMgr = SelfDocMgr.getInstance();
                Vector<WebBusinessObject> formsWbo = new Vector<WebBusinessObject>();
                String formCode = request.getParameter("formCode");
                formsWbo = selfDocMgr.getFormsList(formCode);
                request.setAttribute("formsWbo", formsWbo);
                this.forward(servedPage, request, response);
                break;
            case 92:
                scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                scheduleByItemMgr = ScheduleByItemMgr.getInstance();
                mainTypeMgr = MainCategoryTypeMgr.getInstance();

                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                parentId = request.getParameter("categoryId");

                scheduleId = null;

                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                daysOfMonth = new Vector();

                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                WebBusinessObject dataWbo = null;
                WebBusinessObject scheduleByJOWbo = null;

                Vector dataVec = new Vector();
                Vector JOByTypeAndScheduleInRangeVec = null;
                Vector scheduleTasksVec = null;
                Vector scheduleByJOVec = null;

                monthCal = Calendar.getInstance();

                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
//                tempDayMgr.executeDateOfMonth(beginMonth,endMonth);
//                daysOfMonth =  tempDayMgr.getAllDayOfMonth();
                categoryWbo = maintainableMgr.getOnSingleKey(parentId);

                scheduleByJOVec = scheduleByJobOrderMgr.getScheduleByJOByTypeInRange(parentId, beginMonth, endMonth);

                for (int i = 0; i < scheduleByJOVec.size(); i++) {
                    dataWbo = new WebBusinessObject();

                    scheduleByJOWbo = (WebBusinessObject) scheduleByJOVec.get(i);
                    scheduleId = (String) scheduleByJOWbo.getAttribute("scheduleId");

                    // for computing # job orders
                    JOByTypeAndScheduleInRangeVec = scheduleByJobOrderMgr.getJOByTypeAndScheduleInRange(parentId, scheduleId, beginMonth, endMonth);

                    scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);

                    try {
                        scheduleTasksVec = scheduleTasksMgr.getOnArbitraryKey(scheduleId, "key1");

                    } catch (SQLException ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);

                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);

                    }

                    dataWbo.setAttribute("scheduleTitle", (String) scheduleWbo.getAttribute("maintenanceTitle"));
                    dataWbo.setAttribute("scheduleMaintItems", scheduleTasksVec);
                    dataWbo.setAttribute("totalJOByScheduleCount", JOByTypeAndScheduleInRangeVec.size());

                    dataVec.add(dataWbo);
                }

                servedPage = "/docs/new_report/maintenance_items_on_schedule_in_range.jsp";

                request.setAttribute("data", dataVec);
                request.setAttribute("categoryId", parentId);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);

                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 93:
                servedPage = "/docs/new_report/schedules_tasks_rln_by_model_from.jsp";

                this.forward(servedPage, request, response);
                break;

            case 94:
                servedPage = "/docs/new_report/schedules_tasks_rln_by_model_report.jsp";

                String modelId = request.getParameter("elementIdValue");
                taskId = request.getParameter("taskId");
                SchedulesTasksRlnModelMgr rlnModelMgr = SchedulesTasksRlnModelMgr.getInstance();

                List<WebBusinessObject> listWbo = new ArrayList<WebBusinessObject>();
                listWbo = rlnModelMgr.selectAllByModelId(modelId);

                //scheduleMgr = ScheduleMgr.getInstance();
                //Vector listWbo1 = scheduleMgr.getAllScheduleByModel(elementIdValue);
                /*for(int i=0;i<listWbo1.size(); i++){
                 wbo = new WebBusinessObject();
                 wbo = (WebBusinessObject)listWbo1.get(i);
                 }*/
                String countRows = rlnModelMgr.selectScheduleCountByModelId(modelId);
                /*
                 ***************************************************************************
                 * select * from schedules_tasks_rln_model where UNIT_NO = '1246953809691' *
                 *------------------------------------------------------------------------**
                 *  select COUNT(distinct scheduleId) from schedules_tasks_rln_model      **
                 where UNIT_NO = '1246953809691'                                        *
                 * *************************************************************************
                 *
                 */
                request.setAttribute("listWbo", listWbo);
                request.setAttribute("countRows", countRows);
                this.forward(servedPage, request, response);
                break;

            case 95:
                servedPage = "/docs/new_report/schedules_tasks_rln_by_model_task_from.jsp";

                //request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 96:
                servedPage = "/docs/new_report/schedules_tasks_rln_by_model_task_report.jsp";

                modelId = request.getParameter("elementIdValue");
                taskId = request.getParameter("taskId");
                rlnModelMgr = SchedulesTasksRlnModelMgr.getInstance();
                //List<WebBusinessObject> listWbo = new ArrayList<WebBusinessObject>();
                //listWbo = rlnModelMgr.selectAllByModelId(elementIdValue);

                listWbo = new ArrayList<WebBusinessObject>();
                listWbo = rlnModelMgr.selectAllByModelAndTask(modelId, taskId);

                //scheduleMgr = ScheduleMgr.getInstance();
                //Vector listWbo1 = scheduleMgr.getAllScheduleByModel(elementIdValue);
                /*for(int i=0;i<listWbo1.size(); i++){
                 wbo = new WebBusinessObject();
                 wbo = (WebBusinessObject)listWbo1.get(i);
                 }*/
                countRows = rlnModelMgr.selectScheduleCountByModelId(modelId);
                /*
                 ***************************************************************************
                 * select * from schedules_tasks_rln_model where UNIT_NO = '1246953809691' *
                 *------------------------------------------------------------------------**
                 *  select COUNT(distinct scheduleId) from schedules_tasks_rln_model      **
                 where UNIT_NO = '1246953809691'                                        *
                 * *************************************************************************
                 *
                 */
                request.setAttribute("listWbo", listWbo);
                request.setAttribute("countRows", countRows);
                this.forward(servedPage, request, response);
                break;

            case 97:
                String goToViewEquipment = null;
                try {
                    goToViewEquipment = request.getParameter("goToViewEquipment");
                } catch (Exception e) {
                    goToViewEquipment = null;
                }
                servedPage = "/docs/new_search/equipment_list_without_site.jsp";
                filter = new com.silkworm.pagination.Filter();

                filter = Tools.getPaginationInfo(request, response);

                conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());
                // add conditions
                conditions.add(new FilterCondition("IS_MAINTAINABLE", "0", Operations.EQUAL));

                conditions.add(new FilterCondition("IS_DELETED", "0", Operations.EQUAL));

                filter.setConditions(conditions);
                maintainableMgr = MaintainableMgr.getInstance();
                List<WebBusinessObject> elementslist = new ArrayList<WebBusinessObject>(0);

                //grab scheduleList list
                try {
                    elementslist = maintainableMgr.paginationEntity(filter);
                } catch (Exception e) {
                    System.out.println(e);
                }
                selectionType = request.getParameter("selectionType");

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
                request.setAttribute("elementslist", elementslist);
                this.forward(servedPage, request, response);
                break;
            case 98:
                servedPage = "/docs/new_report/inspection_order.jsp";

                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();
                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();

                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", projects);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 99:
                empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                LaborComplaintsMgr laborComplaintsMgr = LaborComplaintsMgr.getInstance();
                String[] trade_;
                String[] models;
                String[] site_;
                String[] mainType_;
                String[] brand_;
                IssueTitle issueTitleEnum;
                projectMgr = ProjectMgr.getInstance();
                HashMap params = new HashMap();
                Vector allMaintenanceInfo = new Vector();
                AllMaintenanceInfoMgr allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
                TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
                String issueTitle;
                issueTitle = request.getParameter("issueTitle");
                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");

                if (issueTitle != null && issueTitle.equals("Emergency")) {
                    issueTitleEnum = IssueTitle.Emergency;
                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
                } else {
                    issueTitleEnum = IssueTitle.NotEmergency;
                    params.put("title", "\u062A\u0642\u0631\u064A\u0631 \u0645\u0637\u0627\u0628\u0642\u0629 \u0627\u0644\u0634\u0643\u0627\u0648\u0649 \u0628\u0627\u0644\u0641\u062D\u0635");
                }

                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");

                String beginDate1 = request.getParameter("beginDate");
                String endDate1 = request.getParameter("endDate");
                String siteAll = request.getParameter("siteAll");
                String tradeAll = request.getParameter("tradeAll");
                String mainTypeAll = request.getParameter("mainTypeAll");
                String modelAll = request.getParameter("modelAll");

                trade_ = request.getParameterValues("trade");
                site_ = request.getParameterValues("site");
                mainType_ = request.getParameterValues("mainType");
                models = request.getParameterValues("model");
                String orderType = request.getParameter("orderType");
                String dateType = request.getParameter("dateType");
                String date_order = dateType + " " + orderType;

                // set wbo To pass to Method to search
                WebBusinessObject wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("beginDate", beginDate1);
                wboCritaria.setAttribute("endDate", endDate1);
                wboCritaria.setAttribute("trade", trade_);
                wboCritaria.setAttribute("date_order", date_order);
                wboCritaria.setAttribute("site", site_);

                if (unitId != null && !(unitId.equals(""))) {
                    wboCritaria.setAttribute("unitId", unitId);
                    params.put("type", (lang.equalsIgnoreCase("Ar")) ? "\u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment");
                    params.put("value", unitName);
                    allMaintenanceInfo = allMaintenanceInfoMgr.getInspectionOrderData(wboCritaria, issueTitleEnum);

                } else if (models != null) {
                    wboCritaria.setAttribute("models", models);
                    params.put("type", (lang.equalsIgnoreCase("Ar")) ? "\u0645\u0627\u0631\u0643\u0629" : "Model");
                    Vector tempVec;
                    if (!modelAll.equals("yes") && models != null) {
                        String s = "";
                        tempVec = parentUnitMgr.getParensName(models);
                        if (tempVec != null && !tempVec.isEmpty()) {
                            s = tempVec.get(0).toString() + ",.....";
                        }
                        params.put("value", s);
                    } else {
                        params.put("value", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
                    }
                    allMaintenanceInfo = allMaintenanceInfoMgr.getInspectionOrderData(wboCritaria, issueTitleEnum);

                } else {

                    wboCritaria.setAttribute("mainType", mainType_);
                    params.put("type", (lang.equalsIgnoreCase("Ar")) ? "\u0646\u0648\u0639 \u0627\u0644\u0623\u0633\u0627\u0633\u0649" : "Main Type");
                    if (!mainTypeAll.equals("yes") && mainType_ != null) {
                        String s = mainCategoryTypeMgr.getMainTypeName(mainType_).get(0).toString();
                        if (mainCategoryTypeMgr.getMainTypeName(mainType_).size() > 1) {
                            s += " , ...";
                        }
                        params.put("value", s);
                    } else {
                        params.put("value", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
                    }
                    allMaintenanceInfo = allMaintenanceInfoMgr.getInspectionOrderData(wboCritaria, issueTitleEnum);
                }
                WebBusinessObject branchProject,
                 mainProject = new WebBusinessObject();
                for (int i = 0; i < allMaintenanceInfo.size(); i++) {
                    branchProject = null;
                    mainProject = null;
                    wbo = (WebBusinessObject) allMaintenanceInfo.get(i);
                    issueId = (String) wbo.getAttribute("issueId");
                    Vector allLabor = new Vector();
                    Vector allTask = new Vector();
                    Vector allComps = new Vector();
                    Vector allComps2 = new Vector();
                    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                    branchProject = projectMgr.getOnSingleKey(wbo.getAttribute("site").toString());
                    if (!branchProject.getAttribute("mainProjId").equals("0")) {
                        mainProject = projectMgr.getOnSingleKey((String) branchProject.getAttribute("mainProjId"));
                        wbo.setAttribute("siteName", "\u0627\u0644\u0645\u0648\u0642\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u0649 : " + (String) mainProject.getAttribute("projectName") + "\n\u0627\u0644\u0645\u0648\u0642\u0639 \u0627\u0644\u0641\u0631\u0639\u0649 : " + (String) branchProject.getAttribute("projectName"));
                    }
                    try {
                        allLabor = empTasksHoursMgr.getOnArbitraryKeyOracle(issueId, "key1");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    allTask = tasksByIssueMgr.getTask(issueId);
                    try {
                        allComps2 = issueStatusMgr.getOnArbitraryKey(issueId, "key2");
                        allComps.add(allComps2.get(1));

                    } catch (SQLException ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    wbo.setAttribute("allLabor", allLabor);
                    wbo.setAttribute("tasks", allTask);
                    wbo.setAttribute("comps", allComps);

                    parentId = (String) wbo.getAttribute("parentId");
                    String parentName = maintainableMgr.getUnitName(parentId);

                    wbo.setAttribute("parentName", parentName);
                }

                request.setAttribute("unitName", unitName);
                request.setAttribute("tradeAll", tradeAll);
                request.setAttribute("mainTypeAll", mainTypeAll);
                request.setAttribute("siteAll", siteAll);
                params.put("beginDate", beginDate1);
                params.put("endDate", endDate1);
                params.put("Sites", (lang.equalsIgnoreCase("Ar")) ? "\u0627\u0644\u0645\u0648\u0627\u0642\u0639 " : "Sites");
                params.put("Tasks", (lang.equalsIgnoreCase("Ar")) ? "\u0628\u0646\u0648\u062F \u0627\u0644\u0635\u064A\u0627\u0646\u0629" : "Tasks");
                if (!siteAll.equals("yes")) {
                    String s = projectMgr.getProjectsName(site_).get(0).toString();
                    if (projectMgr.getProjectsName(site_).size() > 1) {
                        s += " , ...";
                    }
                    params.put("siteStrArr", s);
                } else {
                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
                }

                if (!tradeAll.equals("yes")) {
                    params.put("tradeStr", tradeMgr.getTradesByIds(trade_).get(0).toString());
                } else {
                    params.put("tradeStr", "\u0643\u0644 \u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0635\u064A\u0627\u0646\u0629");
                }
                Tools.createPdfReport("JobOrdersWithInspection", params, allMaintenanceInfo, getServletContext(), response, request);
                break;
            case 100:
                servedPage = "/docs/new_report/sparepartsReport.jsp";

                allTrade = tradeMgr.getAllAsArrayList();
                userProjectsMgr = UserProjectsMgr.getInstance();

                projects = new Vector();
                try {
                    projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                }
                ArrayList parents = maintainableMgr.getAllParentsOrderByName();

                request.setAttribute("defaultLocationName", securityUser.getSiteName());
                allMainType = mainCategoryTypeMgr.getAllAsArrayList();

                request.setAttribute("allTrade", allTrade);
                request.setAttribute("allSites", projects);
                request.setAttribute("allMainType", allMainType);
                request.setAttribute("parents", parents);
                request.setAttribute("defaultSite", securityUser.getSiteId());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 102:

                projectMgr = ProjectMgr.getInstance();
                params = new HashMap();
                Vector allSparepartInfo = new Vector();
                TransInfoItemMgr transInfoItemMgr = TransInfoItemMgr.getInstance();
                tasksByIssueMgr = TasksByIssueMgr.getInstance();

                issueTitle = request.getParameter("issueTitle");
                params.put("C1", "\u0645\u0646 \u062A\u0627\u0631\u064A\u062E");
                params.put("C2", "\u0627\u0644\u0649 \u062A\u0627\u0631\u064A\u062E");

                if (issueTitle != null && issueTitle.equals("Emergency")) {
                    issueTitleEnum = IssueTitle.Emergency;
                    params.put("title", "\u062A\u0643\u0644\u0641\u0629 \u0623\u0648\u0627\u0645\u0631 \u0627\u0644\u0634\u063A\u0644 \u0627\u0644\u0639\u0627\u062F\u064A\u0629 \u0628\u0640\u0640 \u0627\u0644\u0639\u0645\u0627\u0644\u0629");
                } else {
                    issueTitleEnum = IssueTitle.NotEmergency;
                    params.put("title", "\u0642\u0637\u0639 \u0627\u0644\u063A\u064A\u0627\u0631 \u0627\u0644\u0645\u0646\u0635\u0631\u0641\u0629 \u0645\u0646 \u0627\u0644\u0645\u062E\u0627\u0632\u0646");
                }

                String itemId = request.getParameter("partId");
                String itemName1 = request.getParameter("sparePart");
                beginDate1 = request.getParameter("beginDate");
                endDate1 = request.getParameter("endDate");

                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");

                String brandAll = request.getParameter("brandAll");
                siteAll = request.getParameter("siteAll");

                mainTypeAll = request.getParameter("mainTypeAll");

                brand_ = request.getParameterValues("brand");
                site_ = request.getParameterValues("site");
                mainType_ = request.getParameterValues("mainType");
                wboCritaria = new WebBusinessObject();
                wboCritaria.setAttribute("site", site_);

                if (brand_ == null) {
                    brand_ = new String[1];
                    brand_[0] = "brand";
                }
                wboCritaria.setAttribute("brand", brand_);
                if (mainType_ == null) {
                    mainType_ = new String[1];
                    mainType_[0] = "mainType";

                }
                wboCritaria.setAttribute("mainType", mainType_);

                if (unitId == null || unitId.equals("")) {
                    wboCritaria.setAttribute("unitId", "unitId");

                } else {
                    wboCritaria.setAttribute("unitId", unitId);

                }
                allSparepartInfo = transInfoItemMgr.getAllInfoBySparePart(itemId, beginDate1, endDate1, wboCritaria);

                Vector tempVec = null;
                String unitNamesStr = "";
                parentUnitMgr = ParentUnitMgr.getInstance();
                searchBy = request.getParameter("selectEquip").toString();
                if (searchBy.equalsIgnoreCase("unit")) {
                    params.put("EQUIPMENT_TYPE", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0639\u062F\u0629" : "Equipment"));
                    unitNamesStr = unitName;
                    params.put("searchByEquipment", "ok");
                } else if (searchBy.equalsIgnoreCase("brand")) {

                    if (!brandAll.equals("yes")) {
                        String s = "";
                        tempVec = parentUnitMgr.getParensName(brand_);
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
                    params.put("EQUIPMENT_TYPE", (lang.equalsIgnoreCase("Ar") ? "\u0627\u0644\u0645\u0627\u0631\u0643\u0629" : "Model"));
                } else if (searchBy.equalsIgnoreCase("maintype")) {
                    if (!mainTypeAll.equals("yes")) {
                        String s = "";
                        tempVec = mainCategoryTypeMgr.getMainTypeName(mainType_);
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
                    params.put("EQUIPMENT_TYPE", (lang.equalsIgnoreCase("Ar") ? "\u0646\u0648\u0639 \u0631\u0626\u064A\u0633\u0649" : "Main Type"));
                }
                if (!siteAll.equals("yes")) {
                    String s = projectMgr.getProjectsName(site_).get(0).toString();
                    if (projectMgr.getProjectsName(site_).size() > 1) {
                        s += " , ...";
                    }
                    params.put("siteStrArr", s);
                } else {
                    params.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
                }

                WebBusinessObject partsWbo = new WebBusinessObject();
                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                issueMgr = IssueMgr.getInstance();
                String scheduleID = "";
                if (allSparepartInfo.size() > 0) {
                    for (int j = 0; j < allSparepartInfo.size(); j++) {
                        partsWbo = (WebBusinessObject) allSparepartInfo.get(j);
                        scheduleID = issueMgr.getOnSingleKey(partsWbo.getAttribute("jobOrderID").toString()).getAttribute("unitScheduleID").toString();
                        try {
                            partsWbo.setAttribute("price", ((WebBusinessObject) quantifiedMntenceMgr.getOnArbitraryDoubleKey(scheduleID, "key1", partsWbo.getAttribute("itemCode").toString(), "key3").get(0)).getAttribute("itemPrice").toString());
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                } else {
                    params.put("noData", "ط¸â€ڑط·آ·ط·آ¹ط·آ© ط·آ§ط¸â€‍ط·ط›ط¸ظ¹ط·آ§ط·آ± ط¸â€‍ط·آ§ ط·ع¾ط¸ث†ط·آ¬ط·آ¯ ط·آ¹ط¸â€‍ط¸ظ¹ ط·آ£ط¸â€¦ط·آ± ط·آ´ط·ط›ط¸â€‍ ");
                }

                params.put("unitNamesStr", unitNamesStr);
                params.put("beginDate", beginDate1);
                params.put("endDate", endDate1);
                params.put("itemId", itemId);
                params.put("itemName", itemName1);

                Tools.createPdfReport("JobOrdersWithSpareParts", params, allSparepartInfo, getServletContext(), response, request);
                break;
            case 103:
                servedPage = "/docs/Adminstration/spareparts_list.jsp";
                filter = new com.silkworm.pagination.Filter();
                Vector schedules = new Vector();
                QuantifiedItemsDescMgr quantifiedItemsDescMgr = QuantifiedItemsDescMgr.getInstance();

                filter = Tools.getPaginationInfo(request, response);

                //IS_MAINTAINABLE='1' and IS_DELETED ='0'

                /*conditions = new ArrayList<FilterCondition>();
                 conditions.addAll(filter.getConditions());*/
                // add conditions
                List<WebBusinessObject> scheduleLists = new ArrayList<WebBusinessObject>(0);

                //grab scheduleList list
                try {
                    scheduleLists = quantifiedItemsDescMgr.paginationEntity(filter);
                } catch (Exception e) {
                    System.out.println(e);
                }
                selectionType = request.getParameter("selectionType");

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

            case 105:

                String query = "select TASK_NAME, PARENT_UNIT FROM TASKS where IS_MAIN = 'no' order by PARENT_UNIT ";

                int totalItemsCount = 0;
                parentEqpVec = maintainableMgr.getParentBySort();
                tasksByBrands = new Hashtable();
                itemWboVec = taskMgr.getItemRecordAll(query);
                Vector itemsNoByBrandVec = new Vector();
                Map map = null;
                itemWbo = null;
                WebBusinessObject unitWbo = null;
                WebBusinessObject mainTypeWbo = null;
                maintainableMgr = MaintainableMgr.getInstance();
                mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();

                //get first element in parent category
                for (int x = 0; x < parentEqpVec.size(); x++) {
                    WebBusinessObject parentEqpWbo = (WebBusinessObject) parentEqpVec.get(x);
                    parentId = parentEqpWbo.getAttribute("id").toString();

                    itemWboVec = taskMgr.getTasksbyParentSorting(parentId);

                    if (itemWboVec != null && itemWboVec.size() > 0) {
                        WebBusinessObject firstItemWbo = (WebBusinessObject) itemWboVec.elementAt(0);
                        WebBusinessObject firstUnitWbo = maintainableMgr.getOnSingleKey(firstItemWbo.getAttribute("parentUnit").toString());
                        String flagName = firstUnitWbo.getAttribute("unitName").toString();
                        boolean firstTime = true;
                        for (int i = 0; i < itemWboVec.size(); i++) {
                            itemWbo = new WebBusinessObject();
                            unitWbo = new WebBusinessObject();

                            itemWbo = (WebBusinessObject) itemWboVec.get(i);

                            unitWbo = maintainableMgr.getOnSingleKey(itemWbo.getAttribute("parentUnit").toString());

                            if (unitWbo != null) {
                                mainTypeWbo = new WebBusinessObject();
                                mainTypeWbo = mainCategoryTypeMgr.getOnSingleKey(unitWbo.getAttribute("maintTypeId").toString());
                                if (mainTypeWbo.getAttribute("isAgroupEq").toString().equals("0")) {
                                    if (flagName.equalsIgnoreCase(unitWbo.getAttribute("unitName").toString())) {
                                        if (firstTime == true) {
                                            firstTime = false;
                                            itemWbo.setAttribute("unitName", unitWbo.getAttribute("unitName").toString());
                                        } else {
                                            itemWbo.setAttribute("unitName", " ");
                                        }
                                    } else {
                                        flagName = unitWbo.getAttribute("unitName").toString();
                                        firstTime = false;
                                        itemWbo.setAttribute("unitName", unitWbo.getAttribute("unitName").toString());
                                    }
                                } else {
                                    itemWboVec.remove(i);
                                    i--;
                                }
                            } else {
                                itemWboVec.remove(i);
                                i--;
                            }
                        }

                        tasksByBrands.put(parentId, itemWboVec);

                    }

                    // for summary
                    map = new HashMap();
                    map.put((String) parentEqpWbo.getAttribute("unitName"),
                            itemWboVec.size());
                    itemsNoByBrandVec.add(map);
                    totalItemsCount += itemWboVec.size();
                }

                servedPage = "/docs/new_report/items_by_brand_report_summary.jsp";
                request.setAttribute("itemsNoByBrandVec", itemsNoByBrandVec);
                request.setAttribute("totalItemsCount", totalItemsCount);

                this.forward(servedPage, request, response);

                break;

            case 106:

                Vector itemsNoByMainTypeVec = new Vector();
                basicTypeVec = mainTypeMgr.getAllBasictypeBySorting();
                totalItemsCount = 0;

                for (int x = 0; x < basicTypeVec.size(); x++) {
                    basicTypeWbo = (WebBusinessObject) basicTypeVec.get(x);
                    basicTypeId = basicTypeWbo.getAttribute("id").toString();

                    itemWboVec = taskMgr.getTasksByBasicTypeSorting(basicTypeId);

                    // for summary
                    map = new HashMap();
                    map.put((String) basicTypeWbo.getAttribute("typeName"),
                            itemWboVec.size());
                    itemsNoByMainTypeVec.add(map);
                    totalItemsCount += itemWboVec.size();

                }

                servedPage = "/docs/new_report/items_by_main_type_report_summary.jsp";
                request.setAttribute("itemsNoByMainTypeVec", itemsNoByMainTypeVec);
                request.setAttribute("totalItemsCount", totalItemsCount);

                this.forward(servedPage, request, response);

                break;

            case 107:
//                securityUser=(SecurityUser)session.getAttribute("securityUser");
//                siteId = securityUser.getSiteId();
//                String userId = securityUser.getUserId();
//                String searchBy = securityUser.getSearchBy();
                String typeRate = request.getParameter("typeRate");
                unitName = request.getParameter("unitName");
                formName = request.getParameter("formName");
                if (unitName != null && !unitName.equals("")) {
                    String[] parts = unitName.split(",");
                    unitName = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        unitName += c;
                    }
                }
                categoryTemp = new Vector();
                if (typeRate.equalsIgnoreCase("all")) {
                    if (unitName.equals("")) {
                        categoryTemp = maintainableMgr.getAllMaintainableUnits("");
                    } else {
                        categoryTemp = maintainableMgr.getAllMaintainableUnits(unitName);
                    }

                } else {
                    if (unitName.equals("")) {
                        categoryTemp = maintainableMgr.getUnitByType("", typeRate);
                    } else {
                        categoryTemp = maintainableMgr.getUnitByType(unitName, typeRate);
                    }
                }
                count = 0;
                url = "ReportsServlet?op=listEquipmentsByTypeRate&typeRate=" + typeRate;
                maintainableMgr = MaintainableMgr.getInstance();

                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                category = new Vector();

                index = (count + 1) * 10;
                id = "";
                checkattched = new Vector();
                supplementMgr = SupplementMgr.getInstance();
                if (categoryTemp.size() < index) {
                    index = categoryTemp.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) categoryTemp.get(i);

                    category.add(wbo);

                }

                noOfLinks = categoryTemp.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                // to reload the parant
                reload = request.getParameter("reload");
                if (reload == null) {
                    reload = "";
                }
                if (reload.equals("ok")) {
                    String reloadUrl = request.getParameter("reloadUrl");
                    request.setAttribute("reload", "ok");
                    request.setAttribute("reloadUrl", reloadUrl);
                    url = "ReportsServlet?op=listEquipmentsByTypeRate&reload=" + reload + "&reloadUrl=" + reloadUrl + "&typeRate=" + typeRate;
                }

                session.removeAttribute("CategoryID");
                servedPage = "/docs/new_report/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);
                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 108:
                servedPage = "/docs/new_report/complaints.jsp";

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 109:

                bDate = request.getParameter("beginDate");
                eDate = request.getParameter("endDate");
                IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                data = new Vector();
                data = issueByComplaintMgr.getComplaintsByDepartment(bDate, eDate, lang);
                params = new HashMap();

                Tools.createPdfReport("complaintsDepartment", params, data, getServletContext(), response, request);
                break;

            case 110:
                servedPage = "/docs/new_report/client.jsp";

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 111:
                ClientMgr clientMgr = ClientMgr.getInstance();
                Vector customer = new Vector();
                String date = request.getParameter("beginDate");
                date = "22/08/2013";

                SimpleDateFormat fromUser = new SimpleDateFormat("DD/MM/YYYY");
                SimpleDateFormat myFormat = new SimpleDateFormat("DD-MM-YYYY");

                String reformattedStr = "";
                try {

                    reformattedStr = myFormat.format(fromUser.parse(date));
                } catch (ParseException e) {
                    e.printStackTrace();
                }

                customer = clientMgr.getClientReportByDate(reformattedStr);
                params = new HashMap();
                ServletContext context = getServletConfig().getServletContext();
                context = getServletConfig().getServletContext();
                request.setAttribute("pdfName", "clientReportByDate");
                Tools.createPdfReport("customer", params, customer, context, response, request);
                break;

            case 112:
                clientMgr = ClientMgr.getInstance();
                customer = new Vector();
                String age = (String) request.getParameter("age");
                customer = clientMgr.getClientReportByAgeGroup(age);
                params = new HashMap();
                params.put("details", "\u0627\u0644\u0641\u0626\u0629 \u0627\u0644\u0639\u0645\u0631\u064A\u0629");
                params.put("info", "( " + age + " )");
                context = getServletConfig().getServletContext();
                request.setAttribute("pdfName", "clientReportByAgeGroup");

                Tools.createPdfReport("customer", params, customer, context, response, request);
                break;
            case 113:
                clientMgr = ClientMgr.getInstance();
                customer = new Vector();
                String job = (String) request.getParameter("job");
                if (job.equalsIgnoreCase("all")) {
                    try {
                        customer = clientMgr.selectAllClient();
                        job = "";

                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    customer = clientMgr.getClientReportByJob(job);
                }
                params = new HashMap();
                params.put("details", "\u0627\u0644\u0645\u0647\u0646\u0629");
                context = getServletConfig().getServletContext();
                params.put("info", "( " + job + " )");
                request.setAttribute("pdfName", "clientReportByJob");
                Tools.createPdfReport("customer", params, customer, context, response, request);
                break;
            case 114:

                month = 0;
                years = 1900;
                yearNow = 0;
                String[] monthsArr_ = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                monthsList = new ArrayList();
                yearsList = new ArrayList();
                monthWbo = new WebBusinessObject();
                yearWbo = new WebBusinessObject();
                monthCal = Calendar.getInstance();
                month = monthCal.getTime().getMonth();
                yearNow = monthCal.getTime().getYear() + 1900;

                for (int i = 1900; i < 2100; i++) {
                    years = years + 1;
                    WebBusinessObject wboY = new WebBusinessObject();
                    wboY.setAttribute("id", new Integer(years).toString());
                    wboY.setAttribute("name", new Integer(years).toString());
                    yearsList.add(wboY);
                }

                for (int i = 0; i < 12; i++) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", monthsArr_[i]);
                    monthsList.add(wbo);
                }
                maintainableMgr = MaintainableMgr.getInstance();
                allEquipments = new ArrayList();
                eqps = new Vector();

                try {
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                wbo = new WebBusinessObject();

                for (int i = 0; i < eqps.size(); i++) {
                    wbo = (WebBusinessObject) eqps.get(i);
                    allEquipments.add(wbo);
                }

                servedPage = "/monthly_employee_calendar.jsp";

                monthWbo.setAttribute("id", new Integer(month).toString());
                monthWbo.setAttribute("name", monthsArr_[month]);
                yearWbo.setAttribute("id", yearNow);
                yearWbo.setAttribute("name", yearNow);
                request.setAttribute("month", monthWbo);
                request.setAttribute("year", yearWbo);
                request.setAttribute("monthsList", monthsList);
                request.setAttribute("yearsList", yearsList);
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("data", allEquipments);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;
            case 115:

                monthOfYear = request.getParameter("month");
                year = request.getParameter("yearNo");
                String regionId = request.getParameter("regionId");
                String clientId = request.getParameter("clientId");
                String supervisor = request.getParameter("superId");
                String clientCompId = request.getParameter("clientCompId");
                endDay = null;
                yearNo = new Integer(year.toString()).intValue();
                monthNo = new Integer(monthOfYear.toString()).intValue();
                beginDayNo = 1;
                machinList = new Vector();
                machinUnderJobList = new Vector();
                daysOfMonth = new Vector();
                allEquipments = new ArrayList();
                unitJobs = new Vector();
                scheduleJobs = new Hashtable();
                scheduleWbo = new WebBusinessObject();
                categoryWbo = new WebBusinessObject();
                equipByCategory = new Vector();

                monthCal = Calendar.getInstance();
                if (monthOfYear.equals("0") || monthOfYear.equals("2") || monthOfYear.equals("4") || monthOfYear.equals("6") || monthOfYear.equals("7") || monthOfYear.equals("9") || monthOfYear.equals("11")) {
                    endDay = "31";
                } else if (monthOfYear.equals("1")) {
                    if (yearNo % 4 == 0) {
                        endDay = "28";
                    } else {
                        endDay = "29";
                    }
                } else {
                    endDay = "30";
                }
                monthCal.getTime().setYear(yearNo);
                monthCal.set(yearNo, monthNo, beginDayNo);
                getYear = monthCal.getTime().getYear();
                dateFormat = new SimpleDateFormat("d/M/yyyy");
                endDayNo = new Integer(endDay.toString()).intValue();
                beginMonth = new java.sql.Date(getYear, monthNo, beginDayNo);
                endMonth = new java.sql.Date(getYear, monthNo, endDayNo);
                tempDayMgr.executeDateOfMonth(beginMonth, endMonth);
                daysOfMonth = tempDayMgr.getAllDayOfMonth();
//                categoryWbo = maintainableMgr.getOnSingleKey(regionId);
//                equipByCategory = maintainableMgr.getAllEquipment(regionId);
                ServiceManAreaMgr serviceManAreaMgr = ServiceManAreaMgr.getInstance();
                Vector<WebBusinessObject> usersListTemp = new Vector();
                Vector<WebBusinessObject> usersList = new Vector();
                UserMgr userMgr = UserMgr.getInstance();
                try {
                    usersListTemp = serviceManAreaMgr.getOnArbitraryKey(regionId, "key1");
                    if (usersListTemp != null & !usersListTemp.isEmpty()) {
                        for (int i = 0; i < usersListTemp.size(); i++) {
                            wbo = new WebBusinessObject();
                            wbo = (WebBusinessObject) usersListTemp.get(i);
                            String user_id = (String) wbo.getAttribute("userId");
                            userWbo = new WebBusinessObject();
                            userWbo = userMgr.getOnSingleKey(user_id);
                            usersList.add(userWbo);
                        }

                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

//                for (int i = 0; i < machinList.size(); i++) {
//                    WebBusinessObject equipJobWbo = (WebBusinessObject) machinList.get(i);
//                    unitId = equipJobWbo.getAttribute("unitId").toString();
//                    unitName = equipJobWbo.getAttribute("unitName").toString();
//                    try {
//                        unitJobs = monthlyJobOrderMgr.getOnArbitraryKeyOracle(unitId, "key3");
//                    } catch (SQLException ex) {
//                        ex.printStackTrace();
//                    } catch (Exception ex) {
//                        ex.printStackTrace();
//                    }
//                    
//                    scheduleJobs.put(unitId, unitJobs);
//                }
                servedPage = "/docs/dispatcher/employee_calendar_by_region.jsp";

                Vector interestedUnit = new Vector();
                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();

                interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                ArrayList units = new ArrayList();

                if (interestedUnit != null & !interestedUnit.isEmpty()) {
                    for (int i = 0; i < interestedUnit.size(); i++) {
                        units.add(interestedUnit.get(i));
                    }
                }
                request.setAttribute("regionId", regionId);
                request.setAttribute("monthOfYear", monthOfYear);
                request.setAttribute("year", year);
                request.setAttribute("units", units);
                request.setAttribute("categoryWbo", categoryWbo);
                request.setAttribute("beginMonth", beginMonth);
                request.setAttribute("endMonth", endMonth);
                request.setAttribute("scheduleJobs", scheduleJobs);
                request.setAttribute("daysOfMonth", daysOfMonth);
                request.setAttribute("machinList", usersList);
                request.setAttribute("equipByCategory", " ");
                request.setAttribute("currentMode", "Ar");
                request.setAttribute("page", servedPage);
                request.setAttribute("clientId", clientId);
                request.setAttribute("supervisor", supervisor);
                request.setAttribute("clientCompId", clientCompId);

                this.forwardToServedPage(request, response);

            case 116:
                servedPage = "/docs/reports/client_report.jsp";
                Vector clientsVec = ClientMgr.getInstance().getClientsOnly();
                request.setAttribute("clientsVec", clientsVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 117:
                clientId = request.getParameter("clientId");
                issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                Vector issueData = new Vector();
                try {
                    if (clientId.equalsIgnoreCase("all")) {
                        clientsVec = ClientMgr.getInstance().getClientsOnly();
                        for (Object client : clientsVec) {
                            clientId = ((WebBusinessObject) client).getAttribute("id").toString();
                            issueData.addAll(issueByComplaintMgr.getComplaintsByClientId(clientId));
                        }
                    } else {
                        issueData = issueByComplaintMgr.getComplaintsByClientId(clientId);
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }

                params = new HashMap();
                Tools.createPdfReport("callsByClient", params, issueData, getServletContext(), response, request);
                break;
            case 129:
                clientMgr = ClientMgr.getInstance();
                String clientStatus = request.getParameter("clientStatus");
                String clientProject = request.getParameter("clientProject");
                String clientArea = request.getParameter("clientArea");
                String clientJob = request.getParameter("clientJob");
                
                String fromDateS = request.getParameter("fromDate");
                String toDateS = request.getParameter("toDate");
                String groupID = request.getParameter("groupID");
                String interCode = request.getParameter("interCode");
                String mainClientRate = request.getParameter("mainClientRate");
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.DATE, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                dateParser = new DateParser();
                String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);

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
                String clientClass = request.getParameter("mainClientRate");
                ArrayList<WebBusinessObject> clients = new ArrayList<WebBusinessObject>();
                if (request.getParameter("searchType") != null && request.getParameter("searchType").equals("birthday")) {
                    clients = clientMgr.GetClientsBirthDays(clientStatus, clientProject, clientArea, clientJob, null);
                    request.setAttribute("searchType", request.getParameter("searchType"));
                }else if (request.getParameter("searchType") != null && request.getParameter("searchType").equals("email")) {
                    clients = clientMgr.GetClientsByEmail(clientStatus, clientProject, clientArea, clientJob, null);
                    request.setAttribute("searchType", request.getParameter("searchType"));
                } else if (fromDateS != null && toDateS != null) {
                     fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                     toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    if (departmentWbo != null) {
                        clients = clientMgr.getAllClientsComments( clientJob, fromDateD, toDateD);
                    } else {
                        clients = new ArrayList<WebBusinessObject>();
                    }
                }

                String headers[] = {"#", "Client No", "Client Name", "Mobile", "Address", "Client SSN", "Responsible", "Broker", "Introduced us through", "Status", "DESCRIPTION"};
                String attributes[] = {"Number", "client_no", "name", "mobile", "address", "clientssn", "full_name", "campaign_title", "englishname", "case_en", "description"};
                String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String"};

                String[] headerStr = new String[1];
                headerStr[0] = "Clients_Data";
                HSSFWorkbook workBook = Tools.createExcelReport("Clients", headerStr, null, headers, attributes, dataTypes, clients);

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
                System.out.println(bytes.length);
//                bytes = bos.toByteArray();

                response.setContentType("application/vnd.ms-excel");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                response.setContentLength(bytes.length);
                servletOutputStream.write(bytes, 0, bytes.length);
                servletOutputStream.flush();
                servletOutputStream.close();

                break;
            case 118:
                try {
                    Tools.createClientComplaintWithCommentsPdfReport(response, request, false);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                break;

            case 119:
                servedPage = "/docs/reports/employees_load.jsp";
                try {
                    List departments = projectMgr.getOnArbitraryKey("div", "key6");
                    request.setAttribute("departments", departments);
                } catch (Exception e) {

                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 120:
                try {
                    List<WebBusinessObject> loads = loadsMgr.getOnArbitraryKey(request.getParameter("departmentId"), "key2");
                    Iterator<WebBusinessObject> it = loads.iterator();
                    WebBusinessObject temp_ = null;
                    while (it.hasNext()) {
                        WebBusinessObject temp_1 = it.next();
                        if (temp_ == null || !temp_.getAttribute("currentOwnerFullName").equals(temp_1.getAttribute("currentOwnerFullName"))) {
                            temp_ = temp_1;
                            temp_.setAttribute(temp_1.getAttribute("statusCode"), temp_1.getAttribute("noTicket"));
                        } else {
                            temp_.setAttribute(temp_1.getAttribute("statusCode"), temp_1.getAttribute("noTicket"));
                            it.remove();
                        }
                    }
                    request.setAttribute("loads", loads);
                } catch (Exception e) {

                }
                this.forward("/ReportsServlet?op=getEmployeeLoad", request, response);
                break;
            case 121:
                servedPage = "/docs/reports/employees_loadStatus.jsp";
                try {
                    List departments = projectMgr.getOnArbitraryKey("div", "key6");
                    request.setAttribute("departments", departments);
                } catch (Exception e) {

                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 122:
                String departmentId = request.getParameter("departmentId");
                String statusId = request.getParameter("statusId");

                if (departmentId == null || departmentId.isEmpty() || statusId == null || statusId.isEmpty()) {
                    this.forward("/ReportsServlet?op=getEmployeeLoadByStatus", request, response);
                    break;
                }
                try {
                    List<WebBusinessObject> loads_ = IssueStatusMgr.getInstance().getEmployeesLoadByStatus(departmentId, statusId);
                    request.setAttribute("loads", loads_);
                } catch (Exception ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward("/ReportsServlet?op=getEmployeeLoadByStatus", request, response);
                break;
            case 123:
                GroupMgr groupMgr = GroupMgr.getInstance();
                servedPage = "/docs/reports/employees_loadDynamic.jsp";
                try {
                    //List departments = projectMgr.getOnArbitraryKey("div", "key6");
                    //List groups = groupMgr.getCashedTable();
                    ArrayList<WebBusinessObject> userDepartments;
                    ArrayList<WebBusinessObject> departments = new ArrayList<>();
                    String selectedDepartment = request.getParameter("departmentID");
                    UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
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
                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                    List<WebBusinessObject> groups = userGroupConfigMgr.getAllUserGroupConfig((String) loggedUser.getAttribute("userId"));
                    
                    request.setAttribute("departments", departments);
                    request.setAttribute("groups", groups);
                } catch (Exception e) {

                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 124:
                searchBy = request.getParameter("searchBy");
                id = request.getParameter("id");
                try {
                    if (id != null && !id.isEmpty()) {
                        List<WebBusinessObject> loads;
                        if (searchBy != null && searchBy.equalsIgnoreCase("byGroup")) {
                            loads = loadsMgr.getEmployeesLoadDynamicReportByGroup(id);
                        } else {
                            loads = loadsMgr.getEmployeesLoadDynamicReport(id);
                        }
                        if (!loads.isEmpty()) {
                            ArrayList dataList = new ArrayList();
                            Map dataEntryMap;
                            // populate series data map
                            for (WebBusinessObject clientCountWbo : loads) {
                                dataEntryMap = new HashMap();
                                dataEntryMap.put("name", clientCountWbo.getAttribute("currentOwnerFullName"));
                                dataEntryMap.put("y", Integer.parseInt((String) clientCountWbo.getAttribute("noTicket")));
                                dataList.add(dataEntryMap);
                            }
                            // convert map to JSON string
                            request.setAttribute("jsonText", JSONValue.toJSONString(dataList));
                        }
                        request.setAttribute("loads", loads);
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }

                this.forward("/ReportsServlet?op=getEmployeeLoadDynamic", request, response);
                break;

            case 125:
                servedPage = "/docs/reports/not_achnowledge_requests.jsp";
                String since = request.getParameter("since");
                if (since == null) {
                    since = "24";
                }
                try {
                    issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                    Vector complaints = issueByComplaintMgr.getPreparedNotAcknowledgeComplaintsBySince(since);
                    request.setAttribute("complaints", complaints);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 126:
                since = request.getParameter("since");
                Tools.notAcknowledgeReport(since, response);
                break;

            case 127:
                servedPage = "/loads_report.jsp";
                userMgr = UserMgr.getInstance();
                List<WebBusinessObject> loads = new ArrayList<WebBusinessObject>();
                try {
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    List<WebBusinessObject> employees;
                    if (securityUser.isCanRunCampaignMode()) {
                        employees = userMgr.getUsersByGroup(CRMConstants.SALES_MARKTING_GROUP_ID);
                    } else {
                        employees = userMgr.getUsersByProjectAndGroup(securityUser.getSiteId(), CRMConstants.SALES_MARKTING_GROUP_ID);
                    }
                    WebBusinessObject employee;
                    String[] employeeIds = new String[employees.size()];
                    for (int i = 0; i < employees.size(); i++) {
                        employee = employees.get(i);
                        employeeIds[i] = (String) employee.getAttribute("userId");
                    }
                    loads = loadsMgr.employeesLoads(employeeIds);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("loads", loads);
                this.forward(servedPage, request, response);
                break;
            case 128:
                params = new HashMap();
                try {
                    Tools.createPdfReport("ManagerReport", params, getServletContext(), response, request, UserMgr.getInstance().getDataSource().getConnection());
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;

            case 130:
                params = new HashMap();
                try {
                    Tools.createPdfReport("EmployeeWithoutManagerReport", params, getServletContext(), response, request, UserMgr.getInstance().getDataSource().getConnection());
                } catch (SQLException ex) {
                    Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
            case 131:
                groupMgr = GroupMgr.getInstance();
                servedPage = "/docs/reports/employees_productions.jsp";
//                try {
////                    List departments = projectMgr.getOnArbitraryKey("div", "key6");
//                    List groups = groupMgr.getCashedTable();
////                    request.setAttribute("departments", departments);
//                    request.setAttribute("groups", groups);
//                } catch (Exception e) {
//
//                }
                
                //get logged user groups
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                UserGroupConfigMgr userGroupCongMgr = UserGroupConfigMgr.getInstance();

                Vector userGroupsVec = new Vector();
                try {
                    Vector userGroups = userGroupCongMgr.getOnArbitraryKey(loggedUser.getAttribute("userId").toString(), "key2");
                    if (userGroups.size() > 0 && userGroups != null) {
                        for (int i = 0; i < userGroups.size(); i++) {
                            WebBusinessObject userGroupsWbo = (WebBusinessObject) userGroups.get(i);
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            userGroupsVec.add(groupWbo);
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }
                
                request.setAttribute("groups", userGroupsVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 132:
                List<WebBusinessObject> productions = new ArrayList<WebBusinessObject>();
                id = request.getParameter("id");
                String[] arrBdate = null;
                bDate = (String) request.getParameter("beginDate");
                request.setAttribute("bDate", bDate);
                arrBdate = bDate.split("/");
                bDate = arrBdate[2] + "-" + arrBdate[1] + "-" + arrBdate[0];
                eDate = (String) request.getParameter("endDate");
                request.setAttribute("eDate", eDate);
                arrBdate = eDate.split("/");
                eDate = arrBdate[2] + "-" + arrBdate[1] + "-" + arrBdate[0];
                clientMgr = ClientMgr.getInstance();
                if (id != null && !id.isEmpty()) {
                    try {
                        productions = clientMgr.getEmployeeProductions(id, bDate, eDate);
                    } catch (Exception ex) {
                        Logger.getLogger(ReportsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("loads", productions);
                }

                this.forward("/ReportsServlet?op=employeeProductions", request, response);
                break;
                
            case 133:
                groupMgr = GroupMgr.getInstance();
                servedPage = "/docs/reports/comments_productions.jsp";
                try {
                    List groups = groupMgr.getCashedTable();
                    request.setAttribute("groups", groups);
                } catch (Exception e) { }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 134:
                groupMgr = GroupMgr.getInstance();
                servedPage = "/docs/reports/followup_productions.jsp";
                try {
                    List groups = groupMgr.getCashedTable();
                    request.setAttribute("groups", groups);
                } catch (Exception e) {

                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 135:
                productions = new ArrayList<WebBusinessObject>();
                id = request.getParameter("id");
                arrBdate = null;
                bDate = (String) request.getParameter("beginDate");
                request.setAttribute("bDate", bDate);
                arrBdate = bDate.split("/");
                bDate = arrBdate[2] + "-" + arrBdate[1] + "-" + arrBdate[0];
                eDate = (String) request.getParameter("endDate");
                request.setAttribute("eDate", eDate);
                arrBdate = eDate.split("/");
                eDate = arrBdate[2] + "-" + arrBdate[1] + "-" + arrBdate[0];
                CommentsMgr commentsMgr = CommentsMgr.getInstance();
                if (id != null && !id.isEmpty()) {
                    try {
                        productions = commentsMgr.getCommentsProductions(id, bDate, eDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("loads", productions);
                }

                this.forward("/ReportsServlet?op=commentsProductions", request, response);
                break;
                
            case 136:
                productions = new ArrayList<WebBusinessObject>();
                id = request.getParameter("id");
                arrBdate = null;
                bDate = (String) request.getParameter("beginDate");
                request.setAttribute("bDate", bDate);
                arrBdate = bDate.split("/");
                bDate = arrBdate[2] + "-" + arrBdate[1] + "-" + arrBdate[0];
                eDate = (String) request.getParameter("endDate");
                request.setAttribute("eDate", eDate);
                arrBdate = eDate.split("/");
                eDate = arrBdate[2] + "-" + arrBdate[1] + "-" + arrBdate[0];
                AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                if (id != null && !id.isEmpty()) {
                    try {
                        productions = appointmentMgr.getAppointmentFollowUpProductions(id, bDate, eDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("loads", productions);
                }

                this.forward("/ReportsServlet?op=followupProductions", request, response);
                break;
                
            default:
                System.out.println("No operation was matched");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public String getServletInfo() {
        return "Local Stores Items Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equals("startReport")) {
            return 0;
        }
        if (opName.equals("mainPage")) {
            return 1;
        }
        if (opName.equals("equipmentOutOfWorkReport")) {
            return 2;
        }
        if (opName.equals("getEqJOPReportByEmg")) {
            return 3;
        }
        if (opName.equals("listEquipment")) {
            return 4;
        }
        if (opName.equals("getEqJOReportForm")) {
            return 5;
        }
        if (opName.equals("getEqJOPReport")) {
            return 6;
        }
        if (opName.equals("listItems")) {
            return 7;
        }
        if (opName.equals("listEmployee")) {
            return 8;
        }
        if (opName.equals("getFutureEqJOReportForm")) {

            return 9;
        }
        if (opName.equals("listTasks")) {
            return 10;
        }
        if (opName.equals("getFutureEqJOPReport")) {
            return 11;
        }
        if (opName.equals("searchItems")) {
            return 13;
        }
        if (opName.equals("resultSearchItems")) {
            return 14;
        }
        if (opName.equals("getJodOrdersInAweek")) {
            return 15;
        }
        if (opName.equals("backToMainJobOrdersPage")) {
            return 16;
        }
        if (opName.equals("jobOrderTypeMain")) {
            return 17;
        }
        if (opName.equals("jobOrderPerWeekMain")) {
            return 18;
        }
        if (opName.equals("jobOrderPerWeek")) {
            return 19;
        }
        if (opName.equals("backToMain")) {
            return 18;
        }
        if (opName.equalsIgnoreCase("searchFromPlan")) {
            return 20;
        }
        if (opName.equalsIgnoreCase("searchPlanResult")) {
            return 21;
        }
        if (opName.equals("backToSearchPage")) {
            return 20;
        }
        if (opName.equalsIgnoreCase("cancelPlannedIssue")) {
            return 22;
        }

        if (opName.equals("getEqJOReportByEmgForm")) {
            return 23;
        }
        if (opName.equals("getEquipmentTypeReport")) {
            return 24;
        }
        if (opName.equals("selectEqReportByMainType")) {
            return 25;
        }
        if (opName.equals("getDataEqReportByMainType")) {
            return 26;
        }
        if (opName.equals("selectEqReportBySite")) {
            return 27;
        }
        if (opName.equals("getDataEqReportBySite")) {
            return 28;
        }
        if (opName.equals("setValueSession")) {
            return 29;
        }
        if (opName.equals("getJobOrderbyMonthOfYearForm")) {
            return 30;
        }
        if (opName.equals("getJobOrderbyMonthOfYearResult")) {
            return 31;
        }
        if (opName.equals("getReloadPageByLang")) {
            return 32;
        }
        if (opName.equals("getEquipmentByMainTypeForm")) {
            return 33;
        }
        if (opName.equals("getEquipmentByMainTypeResult")) {
            return 34;
        }
        if (opName.equals("listFixedAssetEquip")) {
            return 35;
        }
        if (opName.equals("getMonthlyEquipRepForm")) {
            return 36;
        }
        if (opName.equals("getMonthlyJobEquipReport")) {
            return 37;
        }
        if (opName.equals("getMonthlyEquipRepByProLineForm")) {
            return 38;
        }
        if (opName.equals("getMonthlyJobEquipByProLineReport")) {
            return 39;
        }
        if (opName.equals("getMonthlyEquipRepByMainTypeForm")) {
            return 40;
        }
        if (opName.equals("getMonthlyJobEquipByMainTypeReport")) {
            return 41;
        }
        if (opName.equals("getMonthlySprPartRepByBasicTypeForm")) {
            return 42;
        }
        if (opName.equals("getMonthlySprPartByMainTypeReport")) {
            return 43;
        }
        if (opName.equals("getMonthlySprPartRepByTypeForm")) {
            return 44;
        }
        if (opName.equals("getMonthlySprPartByTypeReport")) {
            return 45;
        }
        if (opName.equals("getMonthlySprPartRepByProLineForm")) {
            return 46;
        }
        if (opName.equals("getMonthlySprPartByProLineReport")) {
            return 47;
        }
        if (opName.equals("getMonthlyLaborRepByBasicTypeForm")) {
            return 48;
        }
        if (opName.equals("getMonthlyLaborByMainTypeReport")) {
            return 49;
        }
        if (opName.equals("getMonthlyLaborRepByTypeForm")) {
            return 50;
        }
        if (opName.equals("getMonthlyLaborByTypeReport")) {
            return 51;
        }
        if (opName.equals("getMonthlyLaborRepByProLineForm")) {
            return 52;
        }
        if (opName.equals("getMonthlyLaborByProLineReport")) {
            return 53;
        }
        if (opName.equals("getEqTableReportForm")) {
            return 54;
        }
        if (opName.equals("eqReadingReport")) {
            return 55;
        }
        if (opName.equals("getEqReport")) {
            return 56;
        }
        if (opName.equals("selectEqReportByAllBrand")) {
            return 57;
        }
        if (opName.equals("getSummaryEqpbyBrandsReport")) {
            return 58;
        }
        if (opName.equals("getSummaryEqpbyBasicTypeReport")) {
            return 59;
        }
        if (opName.equals("itemReportdata")) {
            return 60;
        }
        if (opName.equals("ProductionLineEqpsReport")) {
            return 61;
        }
        if (opName.equals("getMonthlyJobForEquipRepForm")) {
            return 62;
        }
        if (opName.equals("getMonthlyJobByEquipReport")) {
            return 63;
        }
        if (opName.equals("getMonthlySprPartByEquipReport")) {
            return 64;
        }
        if (opName.equals("getMonthlyLaborByEquipReport")) {
            return 65;

        }
        if (opName.equals("getWeeklyJobsByCatReport")) {
            return 68;
        }
        if (opName.equals("getMonthlyJobsByCatReport")) {
            return 69;
        }
        if (opName.equals("getCanceledJobOrders")) {
            return 66;
        }
        if (opName.equals("getCanceledJobOrderByDate")) {
            return 67;
        }
        if (opName.equals("addCodeForm")) {
            return 70;
        }

        if (opName.equals("getReadingReportsAccordingToBasicTypes")) {
            return 71;
        }

        if (opName.equals("viewMainCatEqps")) {
            return 72;
        }
        if (opName.equals("getReadingReportsAccordingToBrand")) {
            return 73;
        }
        if (opName.equals("viewAvgEqpsByBrand")) {
            return 74;
        }
        if (opName.equals("saveItemForm")) {
            return 75;
        }
        if (opName.equals("chooseActivateStore")) {
            return 76;
        }
        if (opName.equals("saveActiveStore")) {
            return 77;
        }
        if (opName.equals("sparePartByStore")) {
            return 78;
        }
        if (opName.equals("costScheduleJobOrder")) {
            return 79;
        }
        if (opName.equals("costNormalJobOrder")) {
            return 80;
        }
        if (opName.equals("getCostScheduleJobOrderReport")) {
            return 81;
        }
        if (opName.equals("getCostNormalJobOrderReport")) {
            return 82;
        }
        if (opName.equals("changeActiveStore")) {
            return 83;
        }
        if (opName.equals("saveChangeActiveStore")) {
            return 84;
        }
        if (opName.equals("sparePartsList")) {
            return 85;
        }
        if (opName.equals("listEquipmentBySite")) {
            return 86;
        }
        if (opName.equals("searchMaintenanceDetails")) {
            return 87;
        }
        if (opName.equals("selectEquipment")) {
            return 88;
        }
        if (opName.equals("searchEquipOutOfOrder")) {
            return 89;
        }
        if (opName.equals("listEquipmentBySiteByTypeOfRate")) {
            return 90;
        }
        if (opName.equalsIgnoreCase("getFormDetails")) {
            return 91;
        }
        if (opName.equalsIgnoreCase("getMonthlyMaintenanceItemsByTypeReport")) {
            return 92;
        }
        if (opName.equalsIgnoreCase("schTasksRLNByModelForm")) {
            return 93;
        }
        if (opName.equalsIgnoreCase("schTasksRLNByModelReport")) {
            return 94;
        }
        if (opName.equalsIgnoreCase("schTasksRLNByModelTaskForm")) {
            return 95;
        }
        if (opName.equalsIgnoreCase("schTasksRLNByModelTaskReport")) {
            return 96;
        }
        if (opName.equalsIgnoreCase("listEquipmentsWithoutSite")) {
            return 97;
        }
        if (opName.equalsIgnoreCase("getInspectionJobOrder")) {
            return 98;
        }
        if (opName.equalsIgnoreCase("InspectionReport")) {
            return 99;
        }
        if (opName.equalsIgnoreCase("searchBySparePart")) {
            return 100;
        }
        if (opName.equalsIgnoreCase("showSparePartReport")) {
            return 102;
        }
        if (opName.equalsIgnoreCase("ListSparePartss")) {
            return 103;
        }
        if (opName.equalsIgnoreCase("itemBalanceREport")) {
            return 104;
        }
        if (opName.equalsIgnoreCase("getItemsByBrandReportSummary")) {
            return 105;
        }
        if (opName.equalsIgnoreCase("getItemsByMainTypeReportSummary")) {
            return 106;
        }
        if (opName.equalsIgnoreCase("complaintsGroup")) {
            return 108;
        }
        if (opName.equalsIgnoreCase("printComplaints")) {
            return 109;
        }
        if (opName.equalsIgnoreCase("clientReport")) {
            return 110;
        }
        if (opName.equalsIgnoreCase("customer2")) {
            return 111;
        }
        if (opName.equalsIgnoreCase("clientAgeGroupReport")) {
            return 112;
        }
        if (opName.equalsIgnoreCase("getClientsReportByJob")) {
            return 113;
        }
        if (opName.equalsIgnoreCase("getMonthlyEmployeeCalendar")) {
            return 114;
        }
        if (opName.equalsIgnoreCase("employeesCalendar")) {
            return 115;
        }
        if (opName.equalsIgnoreCase("getclientReport")) {
            return 116;
        }
        if (opName.equalsIgnoreCase("exportClientReport")) {
            return 117;
        }
        if (opName.equalsIgnoreCase("clientComplaintWithComments")) {
            return 118;
        }
        if (opName.equalsIgnoreCase("getEmployeeLoad")) {
            return 119;
        }
        if (opName.equalsIgnoreCase("employeesLoadReport")) {
            return 120;
        }
        if (opName.equalsIgnoreCase("getEmployeeLoadByStatus")) {
            return 121;
        }
        if (opName.equalsIgnoreCase("employeesLoadStatusReport")) {
            return 122;
        }
        if (opName.equalsIgnoreCase("getEmployeeLoadDynamic")) {
            return 123;
        }
        if (opName.equalsIgnoreCase("employeesLoadDynamicReport")) {
            return 124;
        }
        if (opName.equalsIgnoreCase("getEscalationReport")) {
            return 125;
        }
        if (opName.equalsIgnoreCase("printEscalationReport")) {
            return 126;
        }
        if (opName.equalsIgnoreCase("employeesLoads")) {
            return 127;
        }
        if (opName.equalsIgnoreCase("managersWithEmployee")) {
            return 128;
        }
        if (opName.equalsIgnoreCase("exportClientsToExcel")) {
            return 129;
        }
        if (opName.equalsIgnoreCase("employeeWithoutManagers")) {
            return 130;
        }
        if (opName.equalsIgnoreCase("employeeProductions")) {
            return 131;
        }
        if (opName.equalsIgnoreCase("getEmployeeProductions")) {
            return 132;
        }
        if (opName.equalsIgnoreCase("commentsProductions")) {
            return 133;
        }
        if (opName.equalsIgnoreCase("followupProductions")) {
            return 134;
        }
        if (opName.equalsIgnoreCase("getCommentsProductions")) {
            return 135;
        }
        if (opName.equalsIgnoreCase("getFollowupProductions")) {
            return 136;
        }
        return 0;
    }

    public Vector checkIsAgroupEq(Vector eqps, Vector mainParents) {
        WebBusinessObject eqWbo = null;
        WebBusinessObject parentWbo = null;
        String parentId = "";
        for (int i = 0; i < eqps.size(); i++) {
            eqWbo = new WebBusinessObject();
            parentId = "";
            eqWbo = (WebBusinessObject) eqps.get(i);
            parentId = eqWbo.getAttribute("maintTypeId").toString();
            for (int c = 0; c < mainParents.size(); c++) {
                parentWbo = new WebBusinessObject();
                parentWbo = (WebBusinessObject) mainParents.get(c);
                if (parentWbo.getAttribute("id").toString().equalsIgnoreCase(parentId)) {
                    if (parentWbo.getAttribute("isAgroupEq").toString().equals("1")) {
                        eqps.remove(i);
                        i--;
                    }
                    break;
                }
            }
        }
        return eqps;
    }

    public Vector mergerVectors(Vector largeVector, Vector smallVector) {
        for (int i = 0; i < smallVector.size(); i++) {
            largeVector.add((WebBusinessObject) smallVector.get(i));
        }
        return largeVector;
    }
}
