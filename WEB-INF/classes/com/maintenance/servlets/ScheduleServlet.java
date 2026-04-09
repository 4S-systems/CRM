package com.maintenance.servlets;

// import com.MaintenanceDependency.db_access.RelatedScheduleDetailsMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ServiceManAreaMgr;
import com.docviewer.db_access.ImageMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.tracker.business_objects.WebIssue;

import java.io.*;
import java.util.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;

import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;
import com.maintenance.common.*;

import com.contractor.db_access.MaintainableMgr;
import com.quality_assurance.db_accesss.GenericApprovalStatusMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.pagination.Filter;
import com.silkworm.util.*;
import java.text.SimpleDateFormat;

public class ScheduleServlet extends TrackerBaseServlet {

    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    MaintainableMgr unit = MaintainableMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    IssueStatusMgr issueStuts = IssueStatusMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    PeriodicCalcultaions calculations = new PeriodicCalcultaions();
    ConfigureCategoryMgr configureCategoryMgr = ConfigureCategoryMgr.getInstance();
    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
    EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
    QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
    ConfigureMainTypeMgr eqpCatConfig = ConfigureMainTypeMgr.getInstance();
    ScheduleTasksMgr scheduleTMgr = ScheduleTasksMgr.getInstance();
    SequenceMgr sequenceMgr = SequenceMgr.getInstance();
    DriversHistoryMgr driversMgr = DriversHistoryMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    String unitId;
    String selectedS = "no";
    String selectedM = "no";
    String url = "";
    String[] quantityMainType = {"", ""};
    String[] priceMainType = {"", ""};
    String[] idMainType = {"", ""};
    String[] itemIdMainType = {"", ""};
    String[] itemCost = {"", ""};
    Vector scheduleList = new Vector();

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
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");

        TradeMgr tradeMgr = TradeMgr.getInstance();

        WebBusinessObject eqpWbo = null;
        WebBusinessObject driverWbo = new WebBusinessObject();
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        Vector eqpsVec = new Vector();
        String siteId = securityUser.getSiteId();
        String userId = securityUser.getUserId();
        Vector equipBySiteVec = new Vector();
        String authUser = securityUser.getSearchBy();
        WebBusinessObject equipBySiteWbo = new WebBusinessObject();
//        RelatedScheduleDetailsMgr relatedScheduleDetailsMgr = RelatedScheduleDetailsMgr.getInstance();

        try {
            ArrayList requestAsArray = ServletUtils.getRequestParams(request);
            ServletUtils.printRequest(requestAsArray);

            switch (operation) {
                case 112:
                    if (request.getParameter("source") == null) {
                        // sequence is input in new_Issue.jsp when sequence has value is already call updateSequence();
                        if (request.getParameter("sequence") == null) {
                            sequenceMgr.updateSequence();
                        }

                        //get equipments
                        /**
                         * ********** Single Version *************
                         */
                        eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        if (authUser.equals("all") || userId.equals("1")) {
                            equipBySiteVec = eqpsVec;
                        } else {
                            for (int i = 0; i < eqpsVec.size(); i++) {
                                equipBySiteWbo = (WebBusinessObject) eqpsVec.get(i);
                                if (equipBySiteWbo.getAttribute("site").equals(siteId)) {
                                    equipBySiteVec.add(equipBySiteWbo);
                                }
                            }
                        }
                        /**
                         * ********** End Single Version *************
                         */
                        if (equipBySiteVec != null && equipBySiteVec.size() > 0) {
                            eqpWbo = (WebBusinessObject) equipBySiteVec.elementAt(0);
                        }
                        request.setAttribute("source", "newIssue");
                    } else {
                        /**
                         * ********** Single Version *************
                         */
                        eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");

                        if (authUser.equals("all") || userId.equals("1")) {
                            equipBySiteVec = eqpsVec;
                        } else {
                            for (int i = 0; i < eqpsVec.size(); i++) {
                                equipBySiteWbo = (WebBusinessObject) eqpsVec.get(i);
                                if (equipBySiteWbo.getAttribute("site").equals(siteId)) {
                                    equipBySiteVec.add(equipBySiteWbo);
                                }
                            }
                        }
                        /**
                         * ********** End Single Version *************
                         */
                        //get selected equipment
                        eqpWbo = maintainableMgr.getOnSingleKey(request.getParameter("unitName"));
                        String page = (String) request.getParameter("source");
                        if (page.equalsIgnoreCase("viewImages")) {
                            sequenceMgr.updateSequence();
                            request.setAttribute("source", "viewImages");
                        } else {
                            request.setAttribute("source", "newIssue");
                        }
                    }

                    //Get Sequence before JO insertion
                    String JOSequenceStr = sequenceMgr.getSequence();

                    //get current equipment employee
                    if (eqpWbo != null) {
                        Vector driverVec = driversMgr.getOnArbitraryDoubleKeyOracle(eqpWbo.getAttribute("id").toString(), "key1", null, "key3");
                        if (driverVec.size() > 0 && driverVec != null) {
                            driverWbo = (WebBusinessObject) driverVec.elementAt(0);
                        }
                    }
                    servedPage = "/docs/issue/new_Issue.jsp";
//                    servedPage = "/docs/issue/new_Full_Issue.jsp";
                    request.setAttribute("JONo", JOSequenceStr);
                    request.setAttribute("equipments", equipBySiteVec);
                    request.setAttribute("currentEqp", eqpWbo);
                    request.setAttribute("currentEmp", driverWbo);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 1:
                    try {
                        servedPage = "/docs/schedule/schedule_list.jsp";
                        unitScheduleMgr.cashData();
//                    scheduleList = unitScheduleMgr.getCashedTable();
                        scheduleList = unitScheduleMgr.getScheduleConfig();

                        request.setAttribute("data", scheduleList);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }
                    break;

                case 2:
                    Vector machineItems = new Vector();
                    Vector itemsCats = new Vector();
                    Vector itemList = new Vector();
                    try {
                        servedPage = "/docs/schedule/schedule_config.jsp";

                        String unitScheduleId = request.getParameter("periodicMntnce");
                        WebBusinessObject myIssue = (WebBusinessObject) issueMgr.getOnArbitraryKey(unitScheduleId, "key3").get(0);
                        String issueId = myIssue.getAttribute("id").toString();
                        String issueTitle = myIssue.getAttribute("issueTitle").toString();
                        String groupShift = myIssue.getAttribute("faId").toString();
                        String projectname = myIssue.getAttribute("projectName").toString();
                        QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                        String shift = myIssue.getAttribute("shift").toString();
                        String estimatedTime = myIssue.getAttribute("estimatedduration").toString();
                        String description = (String) myIssue.getAttribute("issueDesc");

                        String deptId = myIssue.getAttribute("receivedby").toString();
                        DepartmentMgr departmentMg = DepartmentMgr.getInstance();
                        WebBusinessObject myDept = (WebBusinessObject) departmentMg.getOnSingleKey(deptId);
                        String deptName = myDept.getAttribute("departmentName").toString();

                        String workTrade = myIssue.getAttribute("workTrade").toString();
                        WebBusinessObject trade = (WebBusinessObject) tradeMgr.getOnSingleKey(workTrade);
                        String workTradeName = trade.getAttribute("tradeName").toString();

                        itemList = ListItems.getItemSchedule(unitScheduleId);
                        request.setAttribute("description", description);
                        request.setAttribute("estimatedTime", estimatedTime);
                        request.setAttribute("tradeVec", userTradesVec);
                        request.setAttribute("type", request.getParameter("type"));
                        request.setAttribute("data", itemList);
                        request.setAttribute("uID", unitScheduleId);
                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                        request.setAttribute("filter", filterName);
                        request.setAttribute("shift", shift);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("projectName", projectname);
                        request.setAttribute("department", deptName);
                        request.setAttribute("workTrade", workTradeName);
                        request.setAttribute("groupShift", groupShift);
                        System.out.println(unitScheduleId + "  rashad1 " + issueId + "  " + issueTitle);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }

                    break;

                case 3:

                    if (request.getParameter("back").equals("0")) {

                        System.out.println("rfrfrf");
                        String ScheduleUnitId = request.getParameter("scheduleUnitID");

                        scheduleMgr.cashData();
                        scheduleList = unitScheduleMgr.getScheduleConfig();

                        String[] quantity = request.getParameterValues("Hqun");
                        String[] price = request.getParameterValues("Hprice");

                        String[] itemID = request.getParameterValues("code");
                        String[] note = request.getParameterValues("Hnote");

                        try {
                            quantifiedMntenceMgr.deleteOnArbitraryKey(ScheduleUnitId, "key1");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                        if (quantity != null) {

                            issueMgr.updateConfigureValue(ScheduleUnitId);

                            for (int i = 0; i < quantity.length; i++) {
                                Hashtable hash;
                                if (!quantity[i].equals("") && !quantity[i].equals("0")) {
                                    hash = new Hashtable();
                                    hash.put("scheduleUnitID", ScheduleUnitId);
                                    hash.put("itemID", itemID[i]);
                                    hash.put("itemQuantity", quantity[i]);
                                    hash.put("itemPrice", price[i]);
                                    hash.put("totalCost", new String(new Float(new Float(quantity[i]).floatValue() * new Float(price[i]).floatValue()).toString()));
                                    hash.put("note", note[i]);
//                            hash.put("note","note");
                                    try {
                                        itemCatsMgr.saveObject(hash, request.getSession());
                                        issueMgr.updateConfigureValue(ScheduleUnitId);
                                        request.setAttribute("Status", "OK");
                                        System.out.println("hihiih");
                                    } catch (Exception ex) {
                                        System.out.println("General Exception:" + ex.getMessage());
                                    }
                                }
                            }

                            String[] TotaleCost = request.getParameterValues("totale");
                            if (TotaleCost.length == 0) {
                                TotaleCost = request.getParameterValues("tdPTotal");
                            }

                            String issueId = request.getParameter("issueId");

                            if (issueId == null) {
                                WebBusinessObject web;
                                try {
                                    web = (WebBusinessObject) issueMgr.getOnArbitraryKey(ScheduleUnitId, "key3").get(0);
                                    issueId = web.getAttribute("id").toString();
                                } catch (SQLException ex) {
                                    logger.error(ex.getMessage());
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                }

                            }
                            System.out.println("rashad55 " + issueId);

                            try {
                                issueMgr.updateTotalCost(new Float(TotaleCost[0]).floatValue(), issueId);

                                System.out.println("55522+ " + ScheduleUnitId);
                            } catch (NumberFormatException ex) {
                                logger.error(ex.getMessage());
                            } catch (NoUserInSessionException ex) {
                                logger.error(ex.getMessage());
                            }
                        } else {

                            try {
                                configureMainTypeMgr.changeConfigStatus(ScheduleUnitId);
                            } catch (SQLException ex) {
                                logger.error(ex.getMessage());
                            }
                        }
                    }
                    if (request.getParameter("type").equals("emg")) {
                        try {
                            servedPage = "/docs/schedule/schedule_list_Emg.jsp";
                            unitScheduleMgr.cashData();
//                    scheduleList = unitScheduleMgr.getCashedTable();
                            scheduleList = unitScheduleMgr.getListEmergency(session);
                            request.setAttribute("data", scheduleList);
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);

                        } catch (Exception e) {
                            System.out.println("General Exception " + e.getMessage());
                        }
                    } else {

                        try {
                            servedPage = "/docs/schedule/schedule_list_External.jsp";

                            unitScheduleMgr.cashData();
                            Vector externalSchedules = unitScheduleMgr.getOnArbitraryKey("2", "key2");
                            request.setAttribute("data", externalSchedules);
                            request.setAttribute("page", servedPage);

                            this.forwardToServedPage(request, response);
                            break;
                        } catch (Exception e) {
                            System.out.println("External Schedule Exception " + e.getMessage());
                        }
                    }

                    break;

                case 4:
                    Vector unitsCatsVec = new Vector();
                    Vector vecSchedule = new Vector();
                    WebBusinessObject uCatWbo = null;
                    String unitCatName = new String();

                    try {
                        unitsCatsVec = (Vector) unit.getOnArbitraryKey("0", "key3");

                        if (request.getParameter("unitCats").equalsIgnoreCase("non")) {
                            if (unitsCatsVec.size() > 0) {
                                uCatWbo = (WebBusinessObject) unitsCatsVec.elementAt(0);
                            }
                        } else {
                            uCatWbo = unit.getOnSingleKey(request.getParameter("unitCats").toString());
                        }

                        unitCatName = uCatWbo.getAttribute("unitName").toString();
                        vecSchedule = scheduleMgr.getOnArbitraryDoubleKey("1", "key3", uCatWbo.getAttribute("id").toString(), "key4");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    request.setAttribute("data", vecSchedule);
                    request.setAttribute("selectedUnitName", unitCatName);
                    request.setAttribute("tradeVec", userTradesVec);
                    servedPage = "/docs/schedule/new_schedule.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 5:
                    dateAndTime = new DateAndTimeControl();
                    int minutes = 0;
                    servedPage = "/docs/schedule/added_schedule.jsp";
                    WebBusinessObject schedule = new WebBusinessObject();
                    String scheduleID = "";
                    schedule = scheduleMgr.formScraping(request);
                    String day = (String) request.getParameter("day");
                    String hour = (String) request.getParameter("hour");
                    String minute = (String) request.getParameter("minute");

                    if (day != null && !day.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfDay(day);
                    }
                    if (hour != null && !hour.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfHour(hour);
                    }
                    if (minute != null && !minute.equals("")) {
                        minutes = minutes + new Integer(minute).intValue();
                    }

                    schedule.setAttribute("duration", "" + minutes);
                    WebBusinessObject partWbo = new WebBusinessObject();
                    WebBusinessObject taskWbo = new WebBusinessObject();
                    Hashtable taskPartsHt = new Hashtable();
                    Vector tasksData = new Vector();
                    String[] tasksCodes;
                    ItemsMgr itemsMgr = ItemsMgr.getInstance();
                    Vector tempParts = new Vector();
                    Vector composePartsVec = new Vector();
                    boolean Status = scheduleMgr.checkEquipTables(schedule.getAttribute("scheduleTitle").toString(), schedule.getAttribute("eqpCatID").toString());

                    if (Status == false) {
                        request.setAttribute("Check", "No");
                        this.forward("/ScheduleServlet?op=createSchedule", request, response);
                    } else {
                        request.setAttribute("Check", "Ok");

                        try {
                            Vector unitSchedulesVec = scheduleMgr.getOnArbitraryDoubleKey(schedule.getAttribute("scheduleTitle").toString(), "key1", schedule.getAttribute("eqpCatID").toString(), "key4");

                            if (unitSchedulesVec.size() > 0) {
                                request.setAttribute("Status", "No");
                            } else {
                                scheduleID = scheduleMgr.saveObject(schedule, session);
                                if (scheduleID != null) {
                                    request.setAttribute("Status", "Ok");
                                    tasksCodes = request.getParameterValues("id");
                                    //get task Data to back to Jsp
                                    TaskMgr taskMgr = TaskMgr.getInstance();
                                    if (tasksCodes != null) {
                                        for (int index = 0; index < tasksCodes.length; index++) {
                                            taskWbo = new WebBusinessObject();
                                            taskWbo = taskMgr.getOnSingleKey(tasksCodes[index]);
                                            tasksData.add(taskWbo);
                                        }

                                        ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                                        if (scheduleTasksMgr.saveObject(request, scheduleID)) {
                                            request.setAttribute("Status", "Ok");
                                        } else {
                                            request.setAttribute("Status", "No");
                                        }

                                        /**
                                         * ************Get Parts of Mntnc Item
                                         * and add it to
                                         * schedule*****************
                                         */
                                        ConfigTasksPartsMgr configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                        Vector taskParts = new Vector();
                                        WebBusinessObject taskPartWbo = new WebBusinessObject();
                                        Hashtable hashConfig;
                                        for (int i = 0; i < tasksCodes.length; i++) {
                                            taskParts = new Vector();
                                            composePartsVec = new Vector();
                                            taskParts = configTasksPartsMgr.getOnArbitraryKey(tasksCodes[i], "key1");

                                            for (int c = 0; c < taskParts.size(); c++) {
                                                taskPartWbo = new WebBusinessObject();
                                                taskPartWbo = (WebBusinessObject) taskParts.get(c);

                                                tempParts = new Vector();
                                                String itemCode = taskPartWbo.getAttribute("itemId").toString();
                                                itemCode = itemCode.substring(4, itemCode.length());
                                                tempParts = itemsMgr.getOnArbitraryKey(itemCode, "key3");
                                                if (tempParts.size() > 0) {
                                                    partWbo = (WebBusinessObject) tempParts.get(0);
                                                    composePartsVec.add(partWbo); //compose Vec of wbo of parts related to tasks
                                                }

                                                hashConfig = new Hashtable();
                                                hashConfig.put("scheduleId", scheduleID);
                                                hashConfig.put("itemID", taskPartWbo.getAttribute("itemId").toString());
                                                hashConfig.put("itemQuantity", taskPartWbo.getAttribute("itemQuantity").toString());
                                                hashConfig.put("itemPrice", taskPartWbo.getAttribute("itemPrice").toString());
                                                hashConfig.put("totalCost", taskPartWbo.getAttribute("totalCost").toString());
                                                hashConfig.put("note", taskPartWbo.getAttribute("note").toString());
                                                try {
                                                    configureMainTypeMgr.saveObject(hashConfig, session);
                                                    request.setAttribute("Status", "OK");
                                                } catch (Exception ex) {
                                                    System.out.println("General Exception:" + ex.getMessage());
                                                }
                                            }
                                            //set task with it's parts
                                            taskPartsHt.put(tasksCodes[i], composePartsVec);
                                        }
                                    }

                                    String eqpCatID = (String) schedule.getAttribute("eqpCatID");

                                    if (!eqpCatID.equals("") && eqpCatID != null) {
                                        String mode = (String) request.getSession().getAttribute("currentMode");

                                        // Activate Schedule Side Menu
                                        Tools.ActivateScheduleSideMenu(request, eqpCatID, scheduleID, "c", mode);
                                    }

                                } else {
                                    request.setAttribute("Status", "No");
                                }

                                schedule = scheduleMgr.getOnSingleKey(scheduleID);
                                request.setAttribute("schedule", schedule);
                                request.setAttribute("scheduleId", scheduleID);
                            }
                        } catch (SQLException SQLex) {
                            System.out.println("Schedule Servlet: save schedule sql " + SQLex.getMessage());
                        } catch (Exception ex) {
                            System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());
                        }
                    }

                    configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                    itemList = configureMainTypeMgr.getConfigItemBySchedule(scheduleID);
                    request.setAttribute("data", itemList);
                    request.setAttribute("source", request.getParameter("source"));
                    request.setAttribute("tasks", tasksData);
                    request.setAttribute("taskPartsHt", taskPartsHt);
                    ScheduleDocMgr scheduleDocMgr = ScheduleDocMgr.getInstance();
                    Vector docsList = scheduleDocMgr.getListOnLIKE("ListDoc", scheduleID);
                    request.setAttribute("docData", docsList);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 6:
                    servedPage = "/docs/schedule/schedule_units.jsp";

                    Vector unitsList = new Vector();
                    Vector schedulesList = new Vector();

                    unit.cashData();
                    unitsList = unit.getCashedTable();

                    scheduleMgr.cashData();
                    schedulesList = scheduleMgr.getUnEmgSchedule();

                    if (request.getParameter("schedules").toString().equalsIgnoreCase("null")) {
                        if (schedulesList.size() > 0) {
                            WebBusinessObject scheduleWbo = (WebBusinessObject) schedulesList.elementAt(0);
                            request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("periodicID").toString());
                        } else {
                            request.setAttribute("SelectedSchedule", "no");
                        }
                    } else {
                        request.setAttribute("SelectedSchedule", request.getParameter("schedules").toString());
                    }

                    request.setAttribute("data", unitsList);
                    request.setAttribute("schedules", schedulesList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 7:
                    servedPage = "/docs/schedule/schedule_units_report.jsp";
                    String jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();

                    issueMgr = IssueMgr.getInstance();

                    int frequency;
                    int frequencyType;
                    float totalCost = 0;

                    String scheduleId = request.getParameter("schedules");
                    String scheduleName = null;

                    Vector machineStatus = new Vector();
                    Vector eqpCatCongigVec = new Vector();
                    Vector scheduleUnit = null;
                    Vector issueDates = new Vector();

                    java.sql.Date beginDate = null;
                    java.sql.Date endDate = null;

                    WebBusinessObject saveSchedule = null;

                    try {
                        WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");

                        machineStatus.addElement(request.getParameter("unitName").toString());
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");

                        Vector eqpOpVec = eqpOpMgr.getOnArbitraryKey(request.getParameter("machines"), "key1");
                        WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVec.elementAt(0);
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

//                            beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("bDate")).getTime());
//                            endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("eDate")).getTime());
                        DateParser dateParser = new DateParser();
                        beginDate = dateParser.formatSqlDate(request.getParameter("bDate"), jsDateFormat);
                        endDate = dateParser.formatSqlDate(request.getParameter("eDate"), jsDateFormat);

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

                            if ((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("odometer") || new Integer(eqpOpWbo.getAttribute("average").toString()).intValue() == 0)) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
                            } else {

                                //Unit_Schedule and Issue
                                issueDates.removeAllElements();

                                if (frequencyType == 0) {
                                    frequency = frequency / new Integer(eqpOpWbo.getAttribute("average").toString()).intValue();
                                    frequencyType = 1;
                                }
                                int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                                if (issueDates.size() == 0) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Please review Task Frequency");
                                } else {
                                    if (issueDates.size() > 15) {
                                        machineStatus.addElement("Failed");
                                        machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                    } else {
                                        for (int j = 0; j < issueDates.size(); j++) {
                                            Calendar c = Calendar.getInstance();
                                            Calendar d = Calendar.getInstance();

                                            c = (Calendar) issueDates.elementAt(j);
                                            if (j < issueDates.size() - 1) {
                                                d = (Calendar) issueDates.elementAt(j + 1);
                                            }

                                            System.out.println("New Date is " + c.getTime().toString());
                                            System.out.println("New End Date is " + d.getTime().toString());

                                            //Saving Schedule_Units
                                            scheduleUnit = new Vector();
                                            scheduleUnit.addElement(request.getParameter("machines"));
                                            scheduleUnit.addElement(request.getParameter("unitName"));
                                            scheduleUnit.addElement(scheduleId);
                                            scheduleUnit.addElement(scheduleName);
                                            scheduleUnit.addElement(new java.sql.Date(c.getTimeInMillis()));
                                            if (j < issueDates.size() - 1) {
                                                scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            } else {
                                                scheduleUnit.addElement(endDate);
                                            }
                                            scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            unitScheduleMgr.saveScheduleUnits(scheduleUnit);

                                            WebBusinessObject wboIssue = new WebBusinessObject();
                                            wboIssue.setAttribute("site", request.getParameter("site").toString());
                                            wboIssue.setAttribute("machine", request.getParameter("unitName").toString());
                                            wboIssue.setAttribute("desc", request.getParameter("desc").toString());
                                            wboIssue.setAttribute("duration", scheduleWbo.getAttribute("duration").toString());
                                            wboIssue.setAttribute("maintenanceTitle", saveSchedule.getAttribute("maintenanceTitle").toString());
                                            wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                                            c.add(Calendar.DAY_OF_MONTH, noOfDays);
                                            wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                                            wboIssue.setAttribute("scheduleUnitID", unitScheduleMgr.getUinqueID());
                                            wboIssue.setAttribute("workTrade", scheduleWbo.getAttribute("workTrade").toString());
                                            wboIssue.setAttribute("eqpId", request.getParameter("machines").toString());

                                            String unitScheduleId = unitScheduleMgr.getUinqueID();
                                            try {
                                                Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");

                                                issueMgr.saveSchedule(wboIssue, request.getSession(), scTasks);
                                                issueMgr.updateConfigureValue(unitScheduleMgr.getUinqueID());
                                                //Update Total cost of issue
                                                issueMgr.updateTotalCost(unitScheduleMgr.getUinqueID(), totalCost);

                                                /**
                                                 * **************** Transfer
                                                 * Schedule Parts To Issues
                                                 * **********************
                                                 */
                                                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                                                Vector schParts = configureMainTypeMgr.getOnArbitraryKey(scheduleId, "key1");

                                                WebBusinessObject schPartWbo = new WebBusinessObject();
                                                String[] quantity = new String[schParts.size()];
                                                String[] price = new String[schParts.size()];
                                                String[] cost = new String[schParts.size()];
                                                String[] note = new String[schParts.size()];
                                                String[] ids = new String[schParts.size()];
                                                String[] attachedOn = new String[schParts.size()];
                                                String isDirectPrch = "";
                                                QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();
                                                for (int i = 0; i < schParts.size(); i++) {
                                                    schPartWbo = new WebBusinessObject();
                                                    schPartWbo = (WebBusinessObject) schParts.get(i);
                                                    quantity[i] = schPartWbo.getAttribute("itemQuantity").toString();
                                                    price[i] = schPartWbo.getAttribute("itemPrice").toString();
                                                    cost[i] = schPartWbo.getAttribute("totalCost").toString();
                                                    note[i] = schPartWbo.getAttribute("note").toString();
                                                    ids[i] = schPartWbo.getAttribute("itemId").toString();
                                                    isDirectPrch = "0";
                                                    attachedOn[i] = "2";
                                                }
                                                QntfMntncMgr.saveObject2(quantity, price, cost, note, ids, unitScheduleId, isDirectPrch, attachedOn, session);

                                                /**
                                                 * **************** End Of
                                                 * Transfer Schedule Parts
                                                 * **********************
                                                 */
                                            } catch (Exception ex) {
                                                logger.error(ex.getMessage());
                                            }
                                        }
                                        machineStatus.addElement("Success");
                                        machineStatus.addElement("Success");
                                    }
                                }
                            }
                        }
//                    }
                    } catch (Exception ex) {
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }

                    request.setAttribute("eqpCat", request.getParameter("equipmentCats").toString());
                    request.setAttribute("schedules", scheduleId);
                    request.setAttribute("machines", request.getParameter("machines").toString());
                    request.setAttribute("status", machineStatus);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 8:


                    /*
                    
                     *taps Div
                    
                     */
                    Vector items = new Vector();
                    try {
                        servedPage = "/docs/schedule/schedule_config_Emg.jsp";
                        // servedPage = "/docs/issue/Try.jsp";
                        String periodicScheduleId = request.getParameter("periodicMntnce");
                        String machineId = request.getParameter("machineId");

                        QuantifiedMntenceMgr quantifiedMntenceEmgMgr = QuantifiedMntenceMgr.getInstance();
                        Vector quantifiedItems = quantifiedMntenceEmgMgr.getOnArbitraryKey(periodicScheduleId, "key1");

                        if (quantifiedItems != null) {
                            for (int i = 0; i < quantifiedItems.size(); i++) {
                                WebBusinessObject wboTemp = (WebBusinessObject) quantifiedItems.elementAt(i);
                                items.add(wboTemp.getAttribute("itemId").toString());
                            }
                        }

//                    machineItems = itemCatsMgr.getOnArbitraryKey(machineId,"key1");
                        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                        maintenanceItemMgr.cashData();
                        machineItems = new Vector();
                        ArrayList arrMachineItems = maintenanceItemMgr.getCashedTableAsBusObjects();
                        for (int i = 0; i < arrMachineItems.size(); i++) {
                            machineItems.add(arrMachineItems.get(i));
                        }
//                    itemsCats = itemCatsMgr.getItemsCats(machineId);

                        itemsCats = new Vector();
                        CategoryMgr categoryMgr = CategoryMgr.getInstance();
                        categoryMgr.cashData();
                        ArrayList arrCats = categoryMgr.getCashedTableAsArrayList();
                        for (int i = 0; i < arrCats.size(); i++) {
                            itemsCats.add(arrCats.get(i));
                        }

                        request.setAttribute("items", items);
                        request.setAttribute("quantifiedItems", quantifiedItems);

                        request.setAttribute("scheduleID", periodicScheduleId);
                        request.setAttribute("machineItems", machineItems);
                        request.setAttribute("categories", itemsCats);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    } catch (SQLException sex) {
                        System.out.append("SQL Exception " + sex.getMessage());
                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }

                    break;
                case 9:
                    try {
                        servedPage = "/docs/schedule/schedule_list_Emg.jsp";
                        unitScheduleMgr.cashData();
//                    scheduleList = unitScheduleMgr.getCashedTable();
                        scheduleList = unitScheduleMgr.getListEmergency(session);
                        request.setAttribute("data", scheduleList);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }
                    break;

                case 10:
                    Vector unitSchedulesList = new Vector();
                    servedPage = "/docs/schedule/unit_schedule_list.jsp";

                    String unitID = request.getParameter("unitID");
                    try {
                        unitSchedulesList = unitScheduleMgr.getOnArbitraryKey(unitID, "key1");
                    } catch (SQLException sqlEx) {
                        System.out.println("Schedule Servlet -- get unit schedules list sql exception " + sqlEx.getMessage());
                    } catch (Exception ex) {
                        System.out.println("Schedule Servlet -- get unit schedules list exception " + ex.getMessage());
                    }

                    request.setAttribute("schedulesList", unitSchedulesList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 11:
//
                    itemList = new Vector();
                    try {
                        servedPage = "/docs/schedule/schedule_config_EmgView.jsp";

                        String unitScheduleId = request.getParameter("periodicMntnce");
                        WebBusinessObject myIssue = (WebBusinessObject) issueMgr.getOnArbitraryKey(unitScheduleId, "key3").get(0);
                        String issueId = myIssue.getAttribute("id").toString();
                        String issueTitle = myIssue.getAttribute("issueTitle").toString();
                        String projectname = myIssue.getAttribute("projectName").toString();

                        String workTrade = myIssue.getAttribute("workTrade").toString();
                        WebBusinessObject trade = (WebBusinessObject) tradeMgr.getOnSingleKey(workTrade);
                        String workTradeName = trade.getAttribute("tradeName").toString();

                        String deptId = myIssue.getAttribute("receivedby").toString();
                        String urgencyId = myIssue.getAttribute("urgencyId").toString();
                        String repairType = myIssue.getAttribute("repairtype").toString();
                        String shift = myIssue.getAttribute("shift").toString();
                        String estimatedTime = myIssue.getAttribute("estimatedduration").toString();
                        String description = (String) myIssue.getAttribute("issueDesc");

                        System.out.println("******************************************** " + shift);
                        System.out.println(workTrade + "***" + deptId + "****" + repairType + "****" + urgencyId);

                        DepartmentMgr departmentMg = DepartmentMgr.getInstance();
                        WebBusinessObject myDept = (WebBusinessObject) departmentMg.getOnSingleKey(deptId);
                        String deptName = myDept.getAttribute("departmentName").toString();

                        String groupShift = myIssue.getAttribute("faId").toString();
                        QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                        itemList = ListItems.getItemSchedule(unitScheduleId);
                        System.out.println("rama  " + request.getParameter("status"));
                        request.setAttribute("op", request.getParameter("status"));
                        request.setAttribute("type", request.getParameter("type"));
                        System.out.println("0000022  +" + request.getParameter("type"));
                        request.setAttribute("data", itemList);
                        request.setAttribute("uID", unitScheduleId);
                        request.setAttribute(IssueConstants.ISSUEID, issueId);
                        request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);
                        request.setAttribute("filter", filterName);
                        request.setAttribute("filterValue", filterValue);
                        request.setAttribute("projectName", projectname);
                        request.setAttribute("groupShift", groupShift);

                        request.setAttribute("description", description);
                        request.setAttribute("estimatedTime", estimatedTime);
                        request.setAttribute("shift", shift);
                        request.setAttribute("workTrade", workTradeName);
                        request.setAttribute("urgencyId", urgencyId);
                        request.setAttribute("department", deptName);
                        request.setAttribute("repairtype", repairType);

                        System.out.println(unitScheduleId + "  rashad1 " + issueId + "  " + issueTitle);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }

                    break;

                case 12:
                    Vector Items = new Vector();
//                  String status=null;
                    try {
                        servedPage = "/docs/schedule/schedule_config_View.jsp";
                        String periodicScheduleId = request.getParameter("periodicMntnce");
                        String machineId = request.getParameter("machineId");
                        String status = request.getParameter("status");
                        QuantifiedMntenceMgr quantifiedMntenceEmgMgr = QuantifiedMntenceMgr.getInstance();
                        Vector quantifiedItems = quantifiedMntenceEmgMgr.getOnArbitraryKey(periodicScheduleId, "key1");

                        if (quantifiedItems != null) {
                            for (int i = 0; i < quantifiedItems.size(); i++) {
                                WebBusinessObject wboTemp = (WebBusinessObject) quantifiedItems.elementAt(i);
                                Items.add(wboTemp.getAttribute("itemId").toString());
                            }
                        }

                        machineItems = itemCatsMgr.getOnArbitraryKey(machineId, "key1");
                        itemsCats = itemCatsMgr.getItemsCats(machineId);

                        request.setAttribute("items", Items);
                        request.setAttribute("quantifiedItems", quantifiedItems);

                        request.setAttribute("scheduleID", periodicScheduleId);
                        request.setAttribute("machineItems", machineItems);
                        request.setAttribute("categories", itemsCats);
                        request.setAttribute("status", status);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    } catch (SQLException sex) {
                        System.out.append("SQL Exception " + sex.getMessage());
                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }

                    break;

                case 13:
                    String allSchedules = request.getParameter("all");

                    if (allSchedules != null) {
                        try {
                            Vector shedulesVector = (Vector) unitScheduleMgr.getOnArbitraryKey(request.getParameter("scheduleID").toString(), "key2");
                            Vector machinesArray = new Vector();
                            WebBusinessObject schedulesWbo = null;

                            if (shedulesVector != null || shedulesVector.size() > 0) {
                                for (int i = 0; i < shedulesVector.size(); i++) {
                                    schedulesWbo = (WebBusinessObject) shedulesVector.elementAt(i);
                                    machinesArray.addElement(schedulesWbo.getAttribute("id").toString());
                                }
                            }

                            System.out.println("Vector size = " + machinesArray.size());

                            for (int j = 0; j < machinesArray.size(); j++) {
                                String scheduleUnitId = (String) machinesArray.elementAt(j);
                                scheduleMgr.cashData();
                                scheduleList = unitScheduleMgr.getScheduleConfig();

                                String[] q = request.getParameterValues("Quantity");
                                String[] p = request.getParameterValues("Price");
                                String[] ID = request.getParameterValues("ID");
                                String[] itemID = request.getParameterValues("itemID");

                                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                                try {
                                    quantifiedMntenceMgr.deleteOnArbitraryKey(scheduleUnitId, "key1");
                                } catch (SQLException ex) {
                                    logger.error(ex.getMessage());
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                }

                                IssueMgr isueMgr = IssueMgr.getInstance();
                                isueMgr.updateTotalCost(scheduleUnitId, new Float(request.getParameter("totalPrice")).floatValue());

                                if (q != null) {
                                    for (int i = 0; i < q.length; i++) {
                                        Hashtable hash;
                                        if (!q[i].equals("") && !q[i].equals("0")) {
                                            hash = new Hashtable();
                                            hash.put("scheduleUnitID", scheduleUnitId);
                                            hash.put("itemID", itemID[i]);
                                            hash.put("itemQuantity", q[i]);
                                            hash.put("itemPrice", p[i]);
                                            hash.put("totalCost", new String(new Float(new Float(q[i]).floatValue() * new Float(p[i]).floatValue()).toString()));
                                            hash.put("note", request.getParameter("note" + ID[i]));
//                                        hash.put("note","note");
                                            try {
                                                itemCatsMgr.saveObject(hash, request.getSession());
                                                isueMgr.updateConfigureValue(scheduleUnitId);
                                                request.setAttribute("Status", "OK");
                                            } catch (Exception ex) {
                                                System.out.println("General Exception:" + ex.getMessage());
                                            }
                                        }
                                    }
                                }
                            }
                        } catch (SQLException sqlEx) {
                            System.out.println("case 13 sql exception " + sqlEx.getMessage());
                        } catch (Exception ex) {
                            System.out.println("case 13 exception " + ex.getMessage());
                        }
                    } else {
                        String scheduleUnitId = (String) request.getParameter("scheduleUnitID");
                        scheduleMgr.cashData();
                        scheduleList = unitScheduleMgr.getScheduleConfig();

                        String[] q = request.getParameterValues("Quantity");
                        String[] p = request.getParameterValues("Price");
                        String[] ID = request.getParameterValues("ID");
                        String[] itemID = request.getParameterValues("itemID");

                        quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                        try {
                            quantifiedMntenceMgr.deleteOnArbitraryKey(scheduleUnitId, "key1");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                        IssueMgr isueMgr = IssueMgr.getInstance();
                        isueMgr.updateTotalCost(scheduleUnitId, new Float(request.getParameter("totalPrice")).floatValue());

                        if (q != null) {
                            for (int i = 0; i < q.length; i++) {
                                Hashtable hash;
                                if (!q[i].equals("") && !q[i].equals("0")) {
                                    hash = new Hashtable();
                                    hash.put("scheduleUnitID", scheduleUnitId);
                                    hash.put("itemID", itemID[i]);
                                    hash.put("itemQuantity", q[i]);
                                    hash.put("itemPrice", p[i]);
                                    hash.put("totalCost", new String(new Float(new Float(q[i]).floatValue() * new Float(p[i]).floatValue()).toString()));
                                    hash.put("note", request.getParameter("note" + ID[i]));
//                                hash.put("note","note");
                                    try {
                                        itemCatsMgr.saveObject(hash, request.getSession());
                                        isueMgr.updateConfigureValue(scheduleUnitId);
                                        request.setAttribute("Status", "OK");
                                    } catch (Exception ex) {
                                        System.out.println("General Exception:" + ex.getMessage());
                                    }
                                }
                            }
                        }
                    }

                    servedPage = "/docs/schedule/schedule_config_Emg.jsp";
                    request.setAttribute("data", scheduleList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 14:
                    servedPage = "/docs/schedule/list_schedule_units.jsp";

                    Vector schedulesUnitsVector = new Vector();

                    unitScheduleMgr.cashData();
                    schedulesUnitsVector = unitScheduleMgr.getSchedulesUnits();

                    request.setAttribute("schedulesUnits", schedulesUnitsVector);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 15:
                    Vector unitSchedVector = new Vector();
                    servedPage = "/docs/schedule/edit_unit_schedule.jsp";

                    try {
                        unitSchedVector = unitScheduleMgr.getOnArbitraryKey(request.getParameter("unitID"), "key1");
                    } catch (SQLException sqlEx) {
                        System.out.println("Schedule Servlet -- get unit schedules list sql exception " + sqlEx.getMessage());
                    } catch (Exception ex) {
                        System.out.println("Schedule Servlet -- get unit schedules list exception " + ex.getMessage());
                    }

                    request.setAttribute("unitName", request.getParameter("unitName"));
                    request.setAttribute("schedulesList", unitSchedVector);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 16:
                    servedPage = "/docs/schedule/BusinessRules.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 17:
                    servedPage = "/docs/schedule/bind_schedule_units.jsp";

                    Vector unitsCatsVector = new Vector();
                    Vector schedulesVector = new Vector();
                    Vector unitsVector = new Vector();

                    Vector scheduleUnitsVector = new Vector();
                    Vector nonScheduleUnitsVector = new Vector();
                    Vector configuredScheduleVector = new Vector();

                    Vector sSchedule = new Vector();

                    WebBusinessObject scheduleWbo;
                    WebBusinessObject machineWbo;

                    try {
                        //Variables Definitions.
                        WebBusinessObject unitCatWbo = null;

                        //Get All Equipment Cats.
                        unitsCatsVector = unit.getOnArbitraryKey("0", "key3");

                        if (request.getParameter("equipmentCats") == null) {
                            if (unitsCatsVector.size() > 0) {
                                //Select The first equipment Category in the list.
                                unitCatWbo = (WebBusinessObject) unitsCatsVector.elementAt(0);
                            }
                        } else {
                            //Select the one that came from the JSP.
                            unitCatWbo = unit.getOnSingleKey(request.getParameter("equipmentCats"));
                        }
                        request.setAttribute("SelectedEqpCat", unitCatWbo.getAttribute("unitName").toString());

                        //Select schedule for the equipment Category.
                        schedulesVector = scheduleMgr.getSchedulesByTrade(userTradesVec, new String(""), unitCatWbo.getAttribute("id").toString());

                        //Select equipments children for the equipment category.
                        unitsVector = unit.getOnArbitraryDoubleKey(unitCatWbo.getAttribute("id").toString(), "key1", "1", "key3");
                        for (int i = unitsVector.size() - 1; i >= 0; i--) {
                            WebBusinessObject wboTemp = (WebBusinessObject) unitsVector.get(i);
                            if (wboTemp.getAttribute("isDeleted").toString().equalsIgnoreCase("1")) {
                                unitsVector.remove(i);
                            }
                        }

                        if (schedulesVector.size() > 0) {
                            if (request.getParameter("scheduleID") == null) {
                                //Select the first schedule in the list
                                scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                            } else {
                                //Select the schedule that came from jsp.
                                scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                            }

                            //Create Selected Schedule Vector to refine UnitSchedules by it.
                            sSchedule.addElement(scheduleWbo);

                            //Get Schedule Configuration
                            configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                            //Get Scheduled Equipments and Non Scheduled Equipments
                            nonScheduleUnitsVector = (Vector) unitsVector.clone();
                            scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                            request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                        }

                        if ((request.getParameter("scheduleID") == null) || (request.getParameter("equipmentID") == null)) {
                            //Select First Equipment to display its data
                            if (nonScheduleUnitsVector.size() > 0) {
                                machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } else {
                            machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                            request.setAttribute("selectedMachDetails", machineWbo);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    request.setAttribute("equipmentCats", unitsCatsVector);
                    request.setAttribute("schedules", schedulesVector);
                    request.setAttribute("sheduledEqps", scheduleUnitsVector);
                    request.setAttribute("unschedulesEqps", nonScheduleUnitsVector);
                    request.setAttribute("noOfConfigure", new Integer(configuredScheduleVector.size()));
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 18:

                    Vector equipmentCatsVec = new Vector();
                    Vector schedulesVec = new Vector();
                    String equipmentCatID;
                    String equipmentCatName = "";
                    WebBusinessObject eqpCatWbo = null;

                    equipmentCatsVec = unit.getAllCategoryEqu();

                    try {
                        if (equipmentCatsVec.size() > 0) {
                            if (request.getParameter("equipmentCat").toString().equalsIgnoreCase("null")) {
                                eqpCatWbo = (WebBusinessObject) equipmentCatsVec.elementAt(0);
                                equipmentCatID = eqpCatWbo.getAttribute("id").toString();
                                equipmentCatName = eqpCatWbo.getAttribute("unitName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(equipmentCatID, "key4", "Cat", "key5");
                            } else {
                                equipmentCatID = request.getParameter("equipmentCat").toString();

                                WebBusinessObject unitWbo = unit.getOnSingleKey(equipmentCatID);
                                equipmentCatName = unitWbo.getAttribute("unitName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(equipmentCatID, "key4", "Cat", "key5");
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Schedule Listing Exception = " + ex.getMessage());
                    }
                    if (schedulesVec.isEmpty()) {
                        servedPage = "/docs/schedule/List_all.jsp";
                        Vector schedulE = null;
                        schedulE = scheduleMgr.getAllSchedule();
                        request.setAttribute("data", schedulE);
                    } else {
                        servedPage = "/docs/schedule/List_all_schedules.jsp";
                        request.setAttribute("equipmentsCatsData", equipmentCatsVec);
                        request.setAttribute("equipCatSchedules", schedulesVec);
                        request.setAttribute("equipCatName", equipmentCatName);
                        request.setAttribute("backTo", request.getQueryString());
                    }

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 19:
                    String periodicID = null;
                    itemList = new Vector();
                    ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                    servedPage = "/docs/schedule/view_schedule.jsp";
                    periodicID = request.getParameter("periodicID");
                    WebBusinessObject Approval = null;
                    GenericApprovalStatusMgr genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    Approval = genericApprovalStatusMgr.getOnSingleKey1(request.getParameter("periodicID"));
                    if (Approval != null) {
                        request.setAttribute("flag", "true");
                    } else {
                        request.setAttribute("flag", "false");
                    }

                    schedule = scheduleMgr.getOnSingleKey(periodicID);
                    String temp = schedule.getAttribute("scheduleType").toString();

                    request.setAttribute("type", temp);
                    itemList = itemsList.getConfigItemBySchedule(periodicID);
                    request.setAttribute("data", itemList);
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("scheduleId", periodicID);
                    request.setAttribute("source", request.getParameter("source"));

                    String urlBackToView = "op=ViewSchedule&source=" + request.getParameter("source") + "&periodicID=" + periodicID;

                    String source = (String) request.getParameter("source");

                    String mode = (String) request.getSession().getAttribute("currentMode");

                    if (source == null || source.equalsIgnoreCase("")) {
                        String schOn = schedule.getAttribute("scheduledOn").toString();
                        if (schOn.equalsIgnoreCase("Cat")) {
                            source = "cat";
                            request.setAttribute("equipmentCat", schedule.getAttribute("equipmentCatID").toString());
                            urlBackToView += "&equipmentCat=" + request.getAttribute("equipmentCat");

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, request.getAttribute("equipmentCat").toString(), periodicID, "c", mode);
                        } else if (schOn.equalsIgnoreCase("mainCat")) {
                            source = "maincat";
                            String mainCatId = schedule.getAttribute("mainCatTypeId").toString();
                            request.setAttribute("equipmentCat", mainCatId);
                            urlBackToView += "&mainCatId=" + mainCatId;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, mainCatId, periodicID, "mc", mode);
                        } else {
                            source = "eqp";
                            String eqpID = schedule.getAttribute("equipmentID").toString();
                            request.setAttribute("equipmentCat", eqpID);
                            urlBackToView += "&equipmentID=" + eqpID;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, eqpID, periodicID, "", mode);
                        }
                    } else {

                        if (source.equalsIgnoreCase("eqp")) {
                            String eqpID = request.getParameter("equipmentID");
                            request.setAttribute("equipmentCat", eqpID);
                            urlBackToView += "&equipmentID=" + eqpID;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, eqpID, periodicID, "", mode);

                        } else if (source.equalsIgnoreCase("maincat")) {
                            String mainCatId = request.getParameter("mainCatId");
                            request.setAttribute("equipmentCat", mainCatId);
                            urlBackToView += "&mainCatId=" + mainCatId;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, mainCatId, periodicID, "mc", mode);
                        } else {
                            request.setAttribute("equipmentCat", request.getParameter("equipmentCat"));
                            urlBackToView += "&equipmentCat=" + request.getParameter("equipmentCat");

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, request.getParameter("equipmentCat"), periodicID, "c", mode);
                        }
                    }

                    urlBackToView = urlBackToView.replaceAll("'", "");
                    session.setAttribute("urlBackToView", urlBackToView);

                    scheduleDocMgr = ScheduleDocMgr.getInstance();
                    docsList = scheduleDocMgr.getListOnLIKE("ListDoc", periodicID);
                    request.setAttribute("docData", docsList);
                    request.setAttribute("source", source);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 20:
                    periodicID = request.getParameter("periodicID");
                    schedule = scheduleMgr.getOnSingleKey(periodicID);
                    String euipType = request.getParameter("source");
                    String equipMainType = null;
                    if (euipType.equalsIgnoreCase("mainCat")) {
                        equipMainType = scheduleMgr.getMianType(schedule.getAttribute("mainCatTypeId").toString());
                        request.setAttribute("type", equipMainType);
                    } else if (euipType.equalsIgnoreCase("Cat")) {
                        equipMainType = scheduleMgr.getCatType(schedule.getAttribute("equipmentCatID").toString());
                        request.setAttribute("type", equipMainType);
                    } else {
                        equipMainType = scheduleMgr.geteqpType(schedule.getAttribute("equipmentID").toString());
                        request.setAttribute("type", equipMainType);
                    }

                    servedPage = "/docs/schedule/update_schedule.jsp";

                    request.setAttribute("schedule", schedule);
                    request.setAttribute("periodicID", periodicID);
                    request.setAttribute("tradeVec", userTradesVec);
                    request.setAttribute("source", request.getParameter("source"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 21:
                    servedPage = "/docs/schedule/update_schedule.jsp";
                    dateAndTime = new DateAndTimeControl();
                    minutes = 0;
                    String periodic = request.getParameter("periodicID");
                    source = request.getParameter("source");
                    WebBusinessObject schedulE = scheduleMgr.getOnSingleKey(periodic);
                    schedule = new WebBusinessObject();
                    day = (String) request.getParameter("day");
                    hour = (String) request.getParameter("hour");
                    minute = (String) request.getParameter("minute");

                    if (day != null && !day.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfDay(day);
                    }
                    if (hour != null && !hour.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfHour(hour);
                    }
                    if (minute != null && !minute.equals("")) {
                        minutes = minutes + new Integer(minute).intValue();
                    }
                    String euipTypE = request.getParameter("source");
                    String equipMainTypE = null;
                    if (euipTypE.equalsIgnoreCase("mainCat")) {
                        equipMainTypE = scheduleMgr.getMianType(schedulE.getAttribute("mainCatTypeId").toString());
                        request.setAttribute("type", equipMainTypE);
                    } else if (euipTypE.equalsIgnoreCase("Cat")) {
                        equipMainTypE = scheduleMgr.getCatType(schedulE.getAttribute("equipmentCatID").toString());
                        request.setAttribute("type", equipMainTypE);
                    } else {
                        equipMainTypE = scheduleMgr.geteqpType(schedulE.getAttribute("equipmentID").toString());
                        request.setAttribute("type", equipMainTypE);
                    }
                    schedule.setAttribute("schTitle", request.getParameter("scheduleTitle"));
                    schedule.setAttribute("equipCatID", request.getParameter("unitCats"));
                    schedule.setAttribute("frequency", request.getParameter("frequency"));
                    schedule.setAttribute("frequencyType", request.getParameter("frequencyType"));
                    schedule.setAttribute("frequencyReal", scheduleMgr.getFrequencyReal(request.getParameter("frequency"), request.getParameter("frequencyType")));
                    schedule.setAttribute("duration", minutes);
                    schedule.setAttribute("periodicID", request.getParameter("periodicID"));
                    if (request.getParameter("whichCloser").equals("ØºÙŠØ± Ù…Ù�Ø¹Ù„")) {
                        schedule.setAttribute("whichCloser", 0);
                    } else {
                        schedule.setAttribute("whichCloser", request.getParameter("whichCloser"));
                    }

                    schedule.setAttribute("tarde", request.getParameter("trade"));
                    if (request.getParameter("scheduleDesc") == null || request.getParameter("scheduleDesc").equalsIgnoreCase("")) {
                        schedule.setAttribute("scheduleDesc", "No Description");
                    } else {
                        schedule.setAttribute("scheduleDesc", request.getParameter("scheduleDesc"));
                    }
                    schedule.setAttribute("scheduleDesc", request.getParameter("scheduleDesc"));
                    try {
                        if (scheduleMgr.updateSchedule(schedule, source)) {
                            request.setAttribute("status", "Ok");
                        } else {
                            request.setAttribute("status", "No");
                        }
                    } catch (Exception ex) {
                        System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());
                    }

                    schedule = scheduleMgr.getOnSingleKey(request.getParameter("periodicID"));
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("periodicID", request.getParameter("periodicID"));
                    request.setAttribute("source", source);
                    request.setAttribute("tradeVec", userTradesVec);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 22:
                    servedPage = "/docs/schedule/List_all_schedules.jsp";

                    periodicID = request.getParameter("periodicID");
                    schedule = scheduleMgr.getOnSingleKey(periodicID);

                    Vector schedules = new Vector();
                    scheduleMgr.cashData();
                    schedules = scheduleMgr.getAllSchedule();

                    request.setAttribute("data", schedules);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 23:
                    periodicID = null;
                    itemList = new Vector();
                    itemsList = ConfigureMainTypeMgr.getInstance();
                    servedPage = "/docs/schedule/delete_schedule.jsp";
                    periodicID = request.getParameter("periodicID");

                    schedule = scheduleMgr.getOnSingleKey(periodicID);
                    temp = schedule.getAttribute("scheduleType").toString();

                    request.setAttribute("type", temp);
                    itemList = itemsList.getConfigItemBySchedule(periodicID);
                    request.setAttribute("data", itemList);
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("scheduleId", periodicID);
                    request.setAttribute("source", request.getParameter("source"));

                    urlBackToView = "op=ViewSchedule&source=" + request.getParameter("source") + "&periodicID=" + periodicID;

                    source = (String) request.getParameter("source");
                    mode = (String) request.getSession().getAttribute("currentMode");

                    if (source == null || source.equalsIgnoreCase("")) {
                        String schOn = schedule.getAttribute("scheduledOn").toString();
                        if (schOn.equalsIgnoreCase("Cat")) {
                            source = "cat";
                            request.setAttribute("equipmentCat", schedule.getAttribute("equipmentCatID").toString());
                            urlBackToView += "&equipmentCat=" + request.getParameter("equipmentCat");

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, request.getParameter("equipmentCat"), periodicID, "c", mode);
                        } else if (schOn.equalsIgnoreCase("mainCat")) {
                            source = "maincat";
                            String mainCatId = schedule.getAttribute("mainCatTypeId").toString();
                            request.setAttribute("equipmentCat", mainCatId);
                            urlBackToView += "&mainCatId=" + mainCatId;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, mainCatId, periodicID, "mc", mode);
                        } else {
                            source = "eqp";
                            String eqpID = schedule.getAttribute("equipmentID").toString();
                            request.setAttribute("equipmentCat", eqpID);
                            urlBackToView += "&equipmentID=" + eqpID;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, eqpID, periodicID, "", mode);
                        }
                    } else {

                        if (source.equalsIgnoreCase("eqp")) {
                            String eqpID = request.getParameter("equipmentID");
                            request.setAttribute("equipmentCat", eqpID);
                            urlBackToView += "&equipmentID=" + eqpID;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, eqpID, periodicID, "", mode);

                        } else if (source.equalsIgnoreCase("maincat")) {
                            String mainCatId = request.getParameter("mainCatId");
                            request.setAttribute("equipmentCat", mainCatId);
                            urlBackToView += "&mainCatId=" + mainCatId;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, mainCatId, periodicID, "mc", mode);
                        } else {
                            request.setAttribute("equipmentCat", request.getParameter("equipmentCat"));
                            urlBackToView += "&equipmentCat=" + request.getParameter("equipmentCat");

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, request.getParameter("equipmentCat"), periodicID, "c", mode);
                        }
                    }

                    urlBackToView = urlBackToView.replaceAll("'", "");
                    session.setAttribute("urlBackToView", urlBackToView);

                    scheduleDocMgr = ScheduleDocMgr.getInstance();
                    docsList = scheduleDocMgr.getListOnLIKE("ListDoc", periodicID);
                    request.setAttribute("docData", docsList);
                    request.setAttribute("source", source);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;
                case 24:
                    servedPage = "/docs/schedule/canot_del.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 25:
                    String MainTypeName = request.getParameter("MainType");
                    String mainTypeId = request.getParameter("typeId");
                    String categoryId = request.getParameter("categoryId");

                    servedPage = "/docs/schedule/new_schedule_MainType.jsp";

                    request.setAttribute("MainTypeName", MainTypeName);
                    request.setAttribute("mainTypeId", mainTypeId);
                    request.setAttribute("categoryId", categoryId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 26:

                    String unitCatsId = request.getParameter("unitCatsId");
                    MainTypeName = request.getParameter("MainTypeName");
                    mainTypeId = request.getParameter("equipCatID");
                    servedPage = "/docs/schedule/new_schedule_MainType.jsp";
                    schedule = new WebBusinessObject();

                    //schedule = scheduleMgr.formScraping(request);
                    try {
                        Vector unitSchedulesVec = scheduleMgr.getOnArbitraryDoubleKey(request.getParameter("scheduleTitle").toString(), "key1", request.getParameter("unitCatsId").toString(), "key2");

                        if (unitSchedulesVec.size() > 0) {
                            request.setAttribute("Status", "No");
                        } else {
                            if (scheduleMgr.saveMainTypeSchedule(request, session)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        }
                    } catch (SQLException SQLex) {
                        System.out.println("Schedule Servlet: save schedule sql " + SQLex.getMessage());
                    } catch (Exception ex) {
                        System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());
                    }

                    request.setAttribute("MainTypeName", MainTypeName);
                    request.setAttribute("mainTypeId", mainTypeId);
                    request.setAttribute("categoryId", unitCatsId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 27:
                    String statusConfig = request.getParameter("status");
                    Vector scheduleMainType = new Vector();
                    scheduleMainType = scheduleMgr.getScheduleMainType();
                    System.out.println("sa ----------------- ");
                    servedPage = "/docs/schedule/schedule_mainType_List.jsp";

                    request.setAttribute("status", statusConfig);
                    request.setAttribute("data", scheduleMainType);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 28:
                    String hourlyScheduleId = null;
                    WebBusinessObject scheduleWebo = new WebBusinessObject();
                    servedPage = "/docs/schedule/view_hourly_shcedule.jsp";
                    hourlyScheduleId = request.getParameter("scheduleId");
                    scheduleWebo = scheduleMgr.getOnSingleKey(hourlyScheduleId);
                    request.setAttribute("scheduleWebo", scheduleWebo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 29:
                    String scheduleTitle = request.getParameter("scheduleTitle");
                    hourlyScheduleId = request.getParameter("scheduleId");

                    servedPage = "/docs/schedule/delete_hourly_shcedule.jsp";

                    request.setAttribute("scheduleTitle", scheduleTitle);
                    request.setAttribute("hourlyScheduleId", hourlyScheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 30:
                    String status = request.getParameter("status");
                    scheduleMainType = scheduleMgr.getCashedTable();
                    scheduleMgr.deleteOnSingleKey(request.getParameter("hourlyScheduleId"));
                    scheduleMgr.cashData();
                    scheduleMainType = scheduleMgr.getScheduleMainType();
                    servedPage = "/docs/schedule/schedule_mainType_List.jsp";
                    request.setAttribute("status", status);
                    request.setAttribute("data", scheduleMainType);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 31:
                    scheduleWebo = new WebBusinessObject();
                    servedPage = "/docs/schedule/update_hourly_schedule.jsp";
                    hourlyScheduleId = request.getParameter("scheduleId");
                    scheduleWebo = scheduleMgr.getOnSingleKey(hourlyScheduleId);
                    request.setAttribute("scheduleWebo", scheduleWebo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 32:
                    servedPage = "/docs/schedule/update_hourly_schedule.jsp";

                    scheduleWebo = new WebBusinessObject();
                    scheduleWebo.setAttribute("scheduleTitle", request.getParameter("scheduleTitle"));
//                scheduleWebo.setAttribute("equipCatID", request.getParameter("unitCats"));
                    scheduleWebo.setAttribute("frequency", request.getParameter("frequency"));
//                scheduleWebo.setAttribute("frequencyType",request.getParameter("frequencyType"));
                    scheduleWebo.setAttribute("duration", request.getParameter("duration"));
                    scheduleWebo.setAttribute("periodicID", request.getParameter("periodicID"));
                    if (request.getParameter("scheduleDesc") == null || request.getParameter("scheduleDesc").equalsIgnoreCase("")) {
                        scheduleWebo.setAttribute("scheduleDesc", "No Description");
                    } else {
                        scheduleWebo.setAttribute("scheduleDesc", request.getParameter("scheduleDesc"));
                    }

                    try {

                        if (scheduleMgr.updateMainTypeSchedule(scheduleWebo)) {
                            request.setAttribute("status", "Ok");
                        } else {
                            request.setAttribute("status", "No");
                        }

                    } catch (Exception ex) {
                        System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());
                    }

                    schedule = scheduleMgr.getOnSingleKey(request.getParameter("periodicID"));
                    request.setAttribute("scheduleWebo", schedule);
                    request.setAttribute("periodicID", request.getParameter("periodicID"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 33:
                    status = request.getParameter("status");
                    scheduleTitle = request.getParameter("scheduleTitle");
                    scheduleId = request.getParameter("scheduleId");
                    categoryId = request.getParameter("categoryId");
                    mainTypeId = request.getParameter("mainTypeId");

                    status = request.getParameter("status");
                    machineItems = new Vector();
                    Vector category = new Vector();
                    items = new Vector();

                    servedPage = "/docs/schedule/schedule_mainType_config.jsp";

                    try {
//                    items = configureCategoryMgr.getOnArbitraryKey(categoryId,"key1");
                        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                        maintenanceItemMgr.cashData();
                        machineItems = new Vector();
                        ArrayList arrMachineItems = maintenanceItemMgr.getCashedTableAsBusObjects();
                        for (int i = 0; i < arrMachineItems.size(); i++) {
                            items.add(arrMachineItems.get(i));
                        }
                        for (int i = 0; i < items.size(); i++) {
                            WebBusinessObject wboConfig = (WebBusinessObject) items.elementAt(i);
                            if (category.contains(wboConfig.getAttribute("categoryName").toString()) == false) {
                                category.add(wboConfig.getAttribute("categoryName").toString());
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Get Machine Category Items Exception " + ex.getMessage());
                    }

                    request.setAttribute("scheduleTitle", scheduleTitle);
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("categoryId", categoryId);
                    request.setAttribute("mainTypeId", mainTypeId);

                    request.setAttribute("items", items);
                    request.setAttribute("categories", category);
                    request.setAttribute("status", status);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 34:
                    int x = 1000;
                    int y = 600;
                    int z = x / y;
                    String schType = request.getParameter("schType");
                    System.out.print("thee modddddd is" + z);
                    status = request.getParameter("status");
//                String ScheduleUnitId=request.getParameter("scheduleUnitID");

                    scheduleMgr.cashData();

                    quantityMainType = request.getParameterValues("Hqun");
                    priceMainType = request.getParameterValues("Hprice");
                    idMainType = request.getParameterValues("Hnote");
                    itemIdMainType = request.getParameterValues("Hcode");
                    itemCost = request.getParameterValues("Hcost");
                    String[] itemDes = request.getParameterValues("des");
                    String[] itemCat = request.getParameterValues("cat");
                    String E_Cat = request.getParameter("Cat_id");

                    if (quantityMainType != null) {
                        System.out.println(" ===================> " + itemDes.length);
                        int size = quantityMainType.length;
                        String[][] M_Cat_con = new String[size][5];
                        try {
                            configureMainTypeMgr.deleteOnArbitraryKey(request.getParameter("scheduleId"), "key1");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        for (int i = 0; i < size; i++) {
                            Hashtable hashConfig;

                            M_Cat_con[i][0] = "no";
                            if (!quantityMainType[i].equals("") && !quantityMainType[i].equals("0")) {

                                System.out.println(quantityMainType[i] + ", " + itemCost[i]);
                                hashConfig = new Hashtable();
                                hashConfig.put("scheduleId", request.getParameter("scheduleId"));
                                hashConfig.put("itemID", itemIdMainType[i]);
                                hashConfig.put("itemQuantity", quantityMainType[i]);
                                hashConfig.put("itemPrice", priceMainType[i]);
                                hashConfig.put("totalCost", itemCost[i]);
                                hashConfig.put("note", idMainType[i]);
                                System.out.println("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh " + itemIdMainType[i] + " " + itemCat[i] + " " + itemDes[i] + "  " + priceMainType[i]);

                                M_Cat_con[i][0] = E_Cat;
                                M_Cat_con[i][1] = itemIdMainType[i];
                                M_Cat_con[i][2] = itemCat[i];
                                M_Cat_con[i][3] = itemDes[i];
                                M_Cat_con[i][4] = priceMainType[i];

                                try {

                                    configureMainTypeMgr.saveObject(hashConfig, session);

//                                issueMgr.updateConfigureValue(ScheduleUnitId);
                                    request.setAttribute("Status", "OK");
                                } catch (Exception ex) {
                                    System.out.println("General Exception:" + ex.getMessage());
                                }
                            }
                        }
                        try {
                            new ConfigureCategoryMgr().saveObject(M_Cat_con, size);
                        } catch (Exception ex) {
                            System.out.println("General Exception:" + ex.getMessage());
                        }
                    }

                    if (request.getParameter("url") != null) {
                        request.setAttribute("url", request.getParameter("url"));
                    }

                    servedPage = "/docs/schedule/config_timely_schedule.jsp";
                    scheduleMgr = ScheduleMgr.getInstance();
                    scheduleWbo = new WebBusinessObject();
                    scheduleWbo = scheduleMgr.getOnSingleKey((String) request.getParameter("scheduleId"));
                    request.setAttribute("scheduleTitle", scheduleWbo.getAttribute("maintenanceTitle").toString());
                    request.setAttribute("scheduleId", request.getParameter("scheduleId").toString());
//                servedPage = "/docs/schedule/schedule_mainType_config.jsp";
                    request.setAttribute("schType", schType);
                    request.setAttribute("status", status);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 35:
                    schType = request.getParameter("schType");
                    servedPage = "/docs/schedule/config_timely_schedule.jsp";

                    scheduleTitle = request.getParameter("scheduleTitle");
                    scheduleId = request.getParameter("scheduleId");
                    String equipmentID = request.getParameter("equipmentID");
                    if (null != equipmentID) {
                        if ("listAllSchdual".equalsIgnoreCase(request.getParameter("scr"))) {
                            request.setAttribute("url", "op=ListAllSchedules&equipmentCat=" + request.getParameter("categoryId"));
                        }
                        categoryId = request.getParameter("categoryId");
                        request.setAttribute("categoryId", categoryId);
                    } else {

                        request.setAttribute("url", "op=ListAllEquipmentSchedules&equipmentID=" + (String) request.getParameter("equipmentID"));
                    }
                    if (request.getParameter("fromView") != null && session.getAttribute("urlBackToView") != null) {
                        request.setAttribute("url", session.getAttribute("urlBackToView"));
                    }
                    request.setAttribute("scheduleTitle", scheduleTitle);
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("schType", schType);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 36:
                    Vector configureItem = new Vector();
                    configureMainTypeMgr.cashData();
                    configureItem = configureMainTypeMgr.getConfigItemBySchedule(request.getParameter("scheduleId"));
                    System.out.println("sa ----------------- ");
                    servedPage = "/docs/schedule/configure_item_List.jsp";

                    request.setAttribute("data", configureItem);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 37:
                    servedPage = "/docs/schedule/add_list_form.jsp";

                    scheduleId = request.getParameter("scheduleId");

                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 38:
                    ScheduleItemMgr scheduleItemMgr = ScheduleItemMgr.getInstance();

                    scheduleId = request.getParameter("scheduleId");
                    try {
                        if (scheduleItemMgr.saveObject(request, scheduleId)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (SQLException ex) {
                        request.setAttribute("Status", "No");
                    }
                    servedPage = "/docs/schedule/add_list_form.jsp";

                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 39:
                    scheduleItemMgr = ScheduleItemMgr.getInstance();
                    servedPage = "/docs/schedule/edit_list_form.jsp";
                    scheduleId = request.getParameter("scheduleId");

                    Vector vecList = new Vector();
                    try {
                        vecList = scheduleItemMgr.getOnArbitraryKey(scheduleId, "key1");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    request.setAttribute("vecList", vecList);
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 40:
                    scheduleItemMgr = ScheduleItemMgr.getInstance();

                    scheduleId = request.getParameter("scheduleId");
                    try {
                        if (scheduleItemMgr.updateObject(request, scheduleId)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (SQLException ex) {
                        request.setAttribute("Status", "No");
                    }
                    vecList = new Vector();
                    try {
                        vecList = scheduleItemMgr.getOnArbitraryKey(scheduleId, "key1");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    request.setAttribute("vecList", vecList);
                    servedPage = "/docs/schedule/edit_list_form.jsp";

                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 41:
                    try {
                        servedPage = "/docs/schedule/schedule_list_External.jsp";

                        unitScheduleMgr.cashData();
                        Vector externalSchedules = unitScheduleMgr.getOnArbitraryKey("2", "key2");
                        request.setAttribute("data", externalSchedules);
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                        break;
                    } catch (Exception e) {
                        System.out.println("External Schedule Exception " + e.getMessage());
                    }
                    break;

                case 42:
                    servedPage = "/docs/schedule/add_tasks.jsp";

                    scheduleId = request.getParameter("scheduleId");

                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 43:
                    ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    servedPage = "/docs/schedule/add_tasks.jsp";
                    scheduleId = request.getParameter("scheduleId");
                    try {
                        if (scheduleTasksMgr.saveObject(request, scheduleId)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (SQLException ex) {
                        request.setAttribute("Status", "No");
                    }

                    scheduleId = request.getParameter("scheduleId");

                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 44:
                    scheduleId = request.getParameter("scheduleId");
                    servedPage = "/docs/schedule/tasks_list.jsp";
                    scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    scheduleTasksMgr.cashData();
                    try {
                        Vector tasks = scheduleTasksMgr.getOnArbitraryKey(scheduleId, "key1");
                        request.setAttribute("data", tasks);
                    } catch (Exception e) {
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("scheduleId", scheduleId);
                    this.forwardToServedPage(request, response);
                    break;

                case 45:
                    scheduleId = request.getParameter("scheduleId");
                    String taskID = request.getParameter("taskID");
                    servedPage = "/docs/schedule/view_task.jsp";
                    scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    scheduleTasksMgr.cashData();
                    WebBusinessObject task = scheduleTasksMgr.getOnSingleKey(taskID);
                    request.setAttribute("task", task);
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 46:
                    scheduleId = request.getParameter("scheduleId");
                    taskID = request.getParameter("taskID");
                    servedPage = "/docs/schedule/update_task.jsp";
                    scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    scheduleTasksMgr.cashData();
                    task = scheduleTasksMgr.getOnSingleKey(taskID);
                    request.setAttribute("task", task);
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 47:
                    scheduleId = request.getParameter("scheduleId");
                    taskID = request.getParameter("taskID");
                    servedPage = "/docs/schedule/update_task.jsp";
                    scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    scheduleTasksMgr.cashData();
                    task = new WebBusinessObject();
                    task.setAttribute("taskID", request.getParameter("taskID"));
                    task.setAttribute("codeTask", request.getParameter("codeTask"));
                    task.setAttribute("rank", request.getParameter("rank"));
                    task.setAttribute("descEn", request.getParameter("descEn"));
                    task.setAttribute("descAr", request.getParameter("descAr"));
                    if (scheduleTasksMgr.updateObject(task)) {
                        request.setAttribute("status", "Ok");
                    } else {
                        request.setAttribute("status", "No");
                    }
                    task = scheduleTasksMgr.getOnSingleKey(taskID);
                    request.setAttribute("task", task);
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 48:
                    String codeTask = request.getParameter("codeTask");
                    taskID = request.getParameter("taskID");
                    scheduleId = request.getParameter("scheduleId");

                    servedPage = "/docs/schedule/confirm_delTask.jsp";

                    request.setAttribute("codeTask", codeTask);
                    request.setAttribute("taskID", taskID);
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 49:
                    scheduleId = request.getParameter("scheduleId");
                    taskID = request.getParameter("taskID");
                    servedPage = "/docs/schedule/tasks_list.jsp";
                    scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    scheduleTasksMgr.cashData();
                    scheduleTasksMgr.deleteOnSingleKey(taskID);
                    try {
                        Vector tasks = scheduleTasksMgr.getOnArbitraryKey(scheduleId, "key1");
                        request.setAttribute("data", tasks);
                    } catch (Exception e) {
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("scheduleId", scheduleId);
                    this.forwardToServedPage(request, response);
                    break;

                case 50:
                    String responseString = scheduleMgr.getAllTimeScheduleNames();
                    if (responseString != null) {
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write(responseString);
                    } else {
                        // If key comes back as a null, return a question mark.
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write("?");
                    }
                    break;

                case 51:
                    servedPage = "/docs/schedule/List_Equipment_Schedules.jsp";

                    Vector eqpSchedules = new Vector();
                    Vector schedVec = new Vector();
                    eqpWbo = null;

                    source = request.getParameter("source");
                    String equipment = request.getParameter("equipment");
                    String equipmentName = null;

                    ArrayList equipmentsList = new ArrayList();

                    try {
                        if (source.equalsIgnoreCase("menu")) {
                            equipmentsList = unit.getMaintenanbleEquAsBusObjects();

                            if (equipmentsList.size() > 0) {
                                if (equipment.equalsIgnoreCase("first")) {
                                    eqpWbo = (WebBusinessObject) equipmentsList.get(0);
                                } else {
                                    eqpWbo = unit.getOnSingleKey(equipment);
                                }
                            }
                        } else {
                            eqpWbo = unit.getOnSingleKey(equipment);
                        }

                        schedVec = unitScheduleMgr.getEqpSchedules(eqpWbo.getAttribute("id").toString());

                        if (schedVec.size() > 0) {
                            for (int i = 0; i < schedVec.size(); i++) {
                                WebBusinessObject wbo = new WebBusinessObject();

                                WebBusinessObject schedWbo = scheduleMgr.getOnSingleKey(schedVec.elementAt(i).toString());

                                Vector eqpUnitScheduleDate = new Vector();
                                eqpUnitScheduleDate = unitScheduleMgr.getEqpUnitScheduleDates(eqpWbo.getAttribute("id").toString(), schedWbo.getAttribute("periodicID").toString());

                                if (eqpUnitScheduleDate.size() > 0) {
                                    WebBusinessObject eqpUnitWbo = (WebBusinessObject) eqpUnitScheduleDate.elementAt(0);

                                    if (eqpUnitWbo != null) {
                                        wbo.setAttribute("periodicId", schedWbo.getAttribute("periodicID").toString());
                                        wbo.setAttribute("maintenanceTitle", schedWbo.getAttribute("maintenanceTitle").toString());
                                        wbo.setAttribute("beginDate", eqpUnitWbo.getAttribute("beginDate").toString());
                                        wbo.setAttribute("endDate", eqpUnitWbo.getAttribute("endDate").toString());
                                        wbo.setAttribute("isConfigured", eqpUnitWbo.getAttribute("isConfigured").toString());
                                        wbo.setAttribute("trade", schedWbo.getAttribute("workTrade").toString());

                                        eqpSchedules.addElement(wbo);
                                    }
                                }
                            }
                        }

                        equipmentName = eqpWbo.getAttribute("unitName").toString();
                    } catch (Exception ex) {
                        System.out.println("Get Equipment Schedules General Exception " + ex.getMessage());
                    }

                    request.setAttribute("page", servedPage);
                    request.setAttribute("source", source);
                    request.setAttribute("equipment", equipment);
                    request.setAttribute("equipmentName", equipmentName);
                    request.setAttribute("eqpSchedules", eqpSchedules);
                    request.setAttribute("eqpsList", equipmentsList);
                    this.forwardToServedPage(request, response);
                    break;
                case 52:
                    status = null;
                    String delete = request.getParameter("delete");
                    if (delete.equals("1")) {
                        String unitSchId = request.getParameter("scheduleUnitID");

                        try {
                            quantifiedMntenceMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            WebBusinessObject w_ob = (WebBusinessObject) issueMgr.getOnArbitraryKey(unitSchId, "key3").get(0);
                            String issue_id = w_ob.getAttribute("id").toString();
                            issueStuts.deleteOnArbitraryKey(issue_id, "key2");
                            ImageMgr documentMgr = ImageMgr.getInstance();
                            documentMgr.deleteOnArbitraryKey(issue_id, "key3");
                            issueMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            if (unitScheduleMgr.deleteOnSingleKey(unitSchId)) {
                                status = "ok";
                            } else {
                                status = "fail";
                            }

                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                    }

                    if (request.getParameter("type").equals("emg")) {

                        try {
                            servedPage = "/docs/schedule/schedule_list_Emg.jsp";
                            unitScheduleMgr.cashData();
//                    scheduleList = unitScheduleMgr.getCashedTable();
                            scheduleList = unitScheduleMgr.getListEmergency(session);
                            request.setAttribute("data", scheduleList);
                            request.setAttribute("status", status);
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);

                        } catch (Exception e) {
                            System.out.println("General Exception " + e.getMessage());
                        }
                    } else {

                        try {
                            servedPage = "/docs/schedule/schedule_list_External.jsp";

                            unitScheduleMgr.cashData();
                            Vector externalSchedules = unitScheduleMgr.getOnArbitraryKey("2", "key2");
                            request.setAttribute("data", externalSchedules);
                            request.setAttribute("page", servedPage);

                            this.forwardToServedPage(request, response);
                            break;
                        } catch (Exception e) {
                            System.out.println("External Schedule Exception " + e.getMessage());
                        }

                    }
                    break;

                case 53:
                    servedPage = "/docs/schedule/extent_schedule_report.jsp";

                    eqpCatConfig = ConfigureMainTypeMgr.getInstance();
                    issueMgr = IssueMgr.getInstance();

                    totalCost = 0;

                    scheduleId = request.getParameter("schedules");
                    String eqID = request.getParameter("equipmentID");

                    Vector vecUnitSchedule = unitScheduleMgr.getLastUnitSchedule(scheduleId, eqID);
                    WebBusinessObject wboUnitSchedule = new WebBusinessObject();
                    if (vecUnitSchedule.size() > 0) {
                        wboUnitSchedule = (WebBusinessObject) vecUnitSchedule.get(0);
                    }
                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    issueDates = new Vector();

                    try {
                        scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");

                        machineStatus.addElement(request.getParameter("unitName").toString());
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");

                        Vector eqpOpVec = eqpOpMgr.getOnArbitraryKey(request.getParameter("machines"), "key1");
                        WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVec.elementAt(0);
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

                        String tempDate = (String) wboUnitSchedule.getAttribute("endDate");

//                            beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("bDate")).getTime());
//                            endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("eDate")).getTime());
                        DateParser dateParser = new DateParser();
                        beginDate = dateParser.formatSqlDate(request.getParameter("bDate"));
                        endDate = dateParser.formatSqlDate(request.getParameter("eDate"));

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

                            if ((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("odometer") || new Integer(eqpOpWbo.getAttribute("average").toString()).intValue() == 0)) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
                            } else {
                                issueDates.removeAllElements();

                                if (frequencyType == 0) {
                                    frequency = frequency / new Integer(eqpOpWbo.getAttribute("average").toString()).intValue();
                                    frequencyType = 1;
                                }
                                int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);

                                if (issueDates.size() == 0) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Please review Task Frequency");
                                } else {
                                    if (issueDates.size() > 15) {
                                        machineStatus.addElement("Failed");
                                        machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                    } else {
                                        for (int j = 0; j < issueDates.size(); j++) {
                                            Calendar c = Calendar.getInstance();
                                            Calendar d = Calendar.getInstance();

                                            c = (Calendar) issueDates.elementAt(j);
                                            if (j < issueDates.size() - 1) {
                                                d = (Calendar) issueDates.elementAt(j + 1);
                                            }

                                            System.out.println("New Date is " + c.getTime().toString());
                                            System.out.println("New End Date is " + d.getTime().toString());

                                            //Saving Schedule_Units
                                            scheduleUnit = new Vector();
                                            scheduleUnit.addElement(request.getParameter("machines"));
                                            scheduleUnit.addElement(request.getParameter("unitName"));
                                            scheduleUnit.addElement(scheduleId);
                                            scheduleUnit.addElement(scheduleName);
                                            scheduleUnit.addElement(new java.sql.Date(c.getTimeInMillis()));
                                            if (j < issueDates.size() - 1) {
                                                scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            } else {
                                                scheduleUnit.addElement(endDate);
                                            }
                                            scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            unitScheduleMgr.saveScheduleUnits(scheduleUnit);

                                            WebBusinessObject wboIssue = new WebBusinessObject();
                                            wboIssue.setAttribute("site", request.getParameter("site").toString());
                                            wboIssue.setAttribute("machine", request.getParameter("unitName").toString());
                                            wboIssue.setAttribute("desc", request.getParameter("desc").toString());
                                            wboIssue.setAttribute("duration", scheduleWbo.getAttribute("duration").toString());
                                            wboIssue.setAttribute("maintenanceTitle", saveSchedule.getAttribute("maintenanceTitle").toString());
                                            wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                                            c.add(Calendar.DAY_OF_MONTH, noOfDays);
                                            wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                                            wboIssue.setAttribute("scheduleUnitID", unitScheduleMgr.getUinqueID());
                                            wboIssue.setAttribute("workTrade", saveSchedule.getAttribute("workTrade").toString());
                                            wboIssue.setAttribute("eqpId", eqID);
                                            try {

                                                Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");

                                                issueMgr.saveSchedule(wboIssue, request.getSession(), scTasks);
                                                issueMgr.updateConfigureValue(unitScheduleMgr.getUinqueID());
                                                //Update Total cost of issue
                                                issueMgr.updateTotalCost(unitScheduleMgr.getUinqueID(), totalCost);
                                            } catch (Exception ex) {
                                                logger.error(ex.getMessage());
                                            }
                                        }
                                        machineStatus.addElement("Success");
                                        machineStatus.addElement("Success");
                                    }
                                }
                            }
                        }
//                    }
                    } catch (Exception ex) {
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }
                    request.setAttribute("status", machineStatus);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 54:
                    servedPage = "/docs/schedule/bind_single_unit.jsp";

                    Vector unitCatSchedulesVec = new Vector();
                    Vector equipmentsVec = new Vector();
                    Vector eqpUnitSchedules = new Vector();

                    WebBusinessObject equipWbo = null;
                    WebBusinessObject equipCatWbo = null;

                    try {
                        equipWbo = unit.getOnSingleKey(request.getParameter("equipmentID"));
                        equipCatWbo = unit.getOnSingleKey(equipWbo.getAttribute("parentId").toString());

                        /**
                         * ******* Get Equipment Schedules On Eqp ,Parent and
                         * on Main Category *********
                         */
                        String eqp_Id = request.getParameter("equipmentID").toString();
                        String eqpParentId = equipWbo.getAttribute("parentId").toString();
                        String eqpMainCatId = equipWbo.getAttribute("maintTypeId").toString();

                        unitCatSchedulesVec = scheduleMgr.getAllEqpSchsByTrade(userTradesVec, eqp_Id, eqpParentId, eqpMainCatId);

                        equipmentsVec.addElement(equipWbo);
                        eqpUnitSchedules = unitScheduleMgr.getEquipmentUnitSchedules(unitCatSchedulesVec, equipmentsVec);
                        String freqType = "";
                        if (eqpUnitSchedules.size() > 0) {
                            for (int i = 0; i < eqpUnitSchedules.size(); i++) {
                                WebBusinessObject wo = (WebBusinessObject) eqpUnitSchedules.elementAt(i);

                                for (int j = 0; j < unitCatSchedulesVec.size(); j++) {
                                    WebBusinessObject web = (WebBusinessObject) unitCatSchedulesVec.elementAt(j);
                                    //to remove K.M Schedules to prevent activation problems
                                    freqType = "";
                                    freqType = web.getAttribute("frequencyType").toString();
                                    if (!freqType.equalsIgnoreCase("5")) {
                                        if (web.getAttribute("periodicID").toString().equalsIgnoreCase(wo.getAttribute("periodicId").toString())) {
                                            unitCatSchedulesVec.remove(j);
                                            j--;
                                        }
                                    } else {
                                        unitCatSchedulesVec.remove(j);
                                        j--;
                                    }
                                }
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Get Bind Single Unit Task General Error = " + ex.getMessage());
                    }

                    request.setAttribute("equipmentCat", equipCatWbo);
                    request.setAttribute("equipment", equipWbo);
                    request.setAttribute("schedules", unitCatSchedulesVec);
                    request.setAttribute("unitSchedules", eqpUnitSchedules);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("eq_id", (String) request.getParameter("equipmentID"));
                    this.forwardToServedPage(request, response);
                    break;

                case 55:
                    servedPage = "/docs/schedule/extent_schedule_report.jsp";

                    eqpCatConfig = ConfigureMainTypeMgr.getInstance();
                    issueMgr = IssueMgr.getInstance();

                    totalCost = 0;

                    scheduleId = request.getParameter("scheduleID");
                    equipmentID = request.getParameter("equipmentID");

                    vecUnitSchedule = unitScheduleMgr.getLastUnitSchedule(scheduleId, equipmentID);
                    wboUnitSchedule = new WebBusinessObject();
                    if (vecUnitSchedule.size() > 0) {
                        wboUnitSchedule = (WebBusinessObject) vecUnitSchedule.get(0);
                    }
                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    issueDates = new Vector();

                    try {
                        scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");

                        machineStatus.addElement(request.getParameter("unitName").toString());
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");

                        Vector eqpOpVec = eqpOpMgr.getOnArbitraryKey(request.getParameter("machines"), "key1");
                        WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVec.elementAt(0);
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

//                    if(request.getParameter("exYear" + scheduleId).equalsIgnoreCase("Year") || request.getParameter("exMonth" + scheduleId).equalsIgnoreCase("Month") || request.getParameter("exDay" + scheduleId).equalsIgnoreCase("Date")){
//                        machineStatus.addElement("Failed");
//                        machineStatus.addElement("Please choose correct Dates");
//                    } else {
                        String tempDate = (String) wboUnitSchedule.getAttribute("endDate");
                        String sss = tempDate.substring(5, 7);
                        beginDate = new java.sql.Date(new Integer(tempDate.substring(0, 4)).intValue() - 1900, new Integer(tempDate.substring(5, 7)).intValue() - 1, new Integer(tempDate.substring(8)).intValue());
                        String index = (String) request.getParameter("index");
//                        endDate = new java.sql.Date(new Integer(request.getParameter("exYear" + scheduleId)).intValue()-1900, new Integer(request.getParameter("exMonth" + scheduleId)).intValue()-1, new Integer(request.getParameter("exDay" + scheduleId)).intValue());
//                            endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("exDate" + index)).getTime());

                        DateParser dateParser = new DateParser();
                        endDate = dateParser.formatSqlDate(request.getParameter("exDate" + index));

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

                            if ((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("odometer") || new Integer(eqpOpWbo.getAttribute("average").toString()).intValue() == 0)) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
                            } else {
                                issueDates.removeAllElements();

                                if (frequencyType == 0) {
                                    frequency = frequency / new Integer(eqpOpWbo.getAttribute("average").toString()).intValue();
                                    frequencyType = 1;
                                }
                                int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                                if (issueDates.size() > 15) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                } else {
                                    for (int j = 0; j < issueDates.size(); j++) {
                                        Calendar c = Calendar.getInstance();
                                        Calendar d = Calendar.getInstance();

                                        c = (Calendar) issueDates.elementAt(j);
                                        if (j < issueDates.size() - 1) {
                                            d = (Calendar) issueDates.elementAt(j + 1);
                                        }

                                        System.out.println("New Date is " + c.getTime().toString());
                                        System.out.println("New End Date is " + d.getTime().toString());

                                        //Saving Schedule_Units
                                        scheduleUnit = new Vector();
                                        scheduleUnit.addElement(request.getParameter("machines"));
                                        scheduleUnit.addElement(request.getParameter("unitName"));
                                        scheduleUnit.addElement(scheduleId);
                                        scheduleUnit.addElement(scheduleName);
                                        scheduleUnit.addElement(new java.sql.Date(c.getTimeInMillis()));
                                        if (j < issueDates.size() - 1) {
                                            scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                        } else {
                                            scheduleUnit.addElement(endDate);
                                        }
                                        scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                        unitScheduleMgr.saveScheduleUnits(scheduleUnit);

                                        WebBusinessObject wboIssue = new WebBusinessObject();
                                        wboIssue.setAttribute("site", request.getParameter("site").toString());
                                        wboIssue.setAttribute("machine", request.getParameter("unitName").toString());
                                        wboIssue.setAttribute("desc", request.getParameter("desc").toString());
                                        wboIssue.setAttribute("duration", scheduleWbo.getAttribute("duration").toString());
                                        wboIssue.setAttribute("maintenanceTitle", saveSchedule.getAttribute("maintenanceTitle").toString());
                                        wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                                        c.add(Calendar.DAY_OF_MONTH, noOfDays);
                                        wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                                        wboIssue.setAttribute("scheduleUnitID", unitScheduleMgr.getUinqueID());
                                        wboIssue.setAttribute("workTrade", saveSchedule.getAttribute("workTrade").toString());
                                        wboIssue.setAttribute("eqpId", equipmentID);

                                        String unitScheduleId = unitScheduleMgr.getUinqueID();
                                        try {
                                            Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");

                                            issueMgr.saveSchedule(wboIssue, request.getSession(), scTasks);
                                            issueMgr.updateConfigureValue(unitScheduleMgr.getUinqueID());
                                            //Update Total cost of issue
                                            issueMgr.updateTotalCost(unitScheduleMgr.getUinqueID(), totalCost);
                                            /**
                                             * **************** Transfer
                                             * Schedule Parts To Issues
                                             * **********************
                                             */
                                            configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                                            Vector schParts = configureMainTypeMgr.getOnArbitraryKey(scheduleId, "key1");

                                            WebBusinessObject schPartWbo = new WebBusinessObject();
                                            String[] quantity = new String[schParts.size()];
                                            String[] price = new String[schParts.size()];
                                            String[] cost = new String[schParts.size()];
                                            String[] note = new String[schParts.size()];
                                            String[] ids = new String[schParts.size()];
                                            String[] attachedOn = new String[schParts.size()];
                                            String isDirectPrch = "";
                                            QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();
                                            for (int i = 0; i < schParts.size(); i++) {
                                                schPartWbo = new WebBusinessObject();
                                                schPartWbo = (WebBusinessObject) schParts.get(i);
                                                quantity[i] = schPartWbo.getAttribute("itemQuantity").toString();
                                                price[i] = schPartWbo.getAttribute("itemPrice").toString();
                                                cost[i] = schPartWbo.getAttribute("totalCost").toString();
                                                note[i] = schPartWbo.getAttribute("note").toString();
                                                ids[i] = schPartWbo.getAttribute("itemId").toString();
                                                isDirectPrch = "0";
                                                attachedOn[i] = "2";
                                            }
                                            QntfMntncMgr.saveObject2(quantity, price, cost, note, ids, unitScheduleId, isDirectPrch, attachedOn, session);

                                            /**
                                             * **************** End Of Transfer
                                             * Schedule Parts
                                             * **********************
                                             */
                                        } catch (Exception ex) {
                                            System.out.print("Saving Extend Schedule Error " + ex.getMessage());
                                            logger.error(ex.getMessage());
                                        }
                                    }
                                    machineStatus.addElement("Success");
                                    machineStatus.addElement("Success");
                                }
                            }
                        }
//                    }
                    } catch (Exception ex) {
                        System.out.println("Extend Schedule Error " + ex.getMessage());
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }
                    request.setAttribute("status", machineStatus);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 56:
                    servedPage = "/docs/issue/external_order.jsp";
                    request.setAttribute("page", servedPage);
                    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
                    String issueId = request.getParameter("issueId");
                    Vector tasks = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
                    WebBusinessObject issue = issueMgr.getOnSingleKey(issueId);
                    if (tasks.size() > 0) {
                        request.setAttribute("tasks", true);
                    }
                    request.setAttribute("issueStatus", issue.getAttribute("currentStatus"));
                    this.forwardToServedPage(request, response);
                    break;

                case 57:
                    servedPage = "/docs/issue/add_workers.jsp";

                    issueTasksMgr = IssueTasksMgr.getInstance();
                    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
                    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
                    Vector vecIssueTasks = new Vector();
                    try {
                        vecIssueTasks = issueTasksMgr.getOnArbitraryKey(request.getParameter("issueId"), "key1");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

//                request.setAttribute("employeeType", "0");
                    request.setAttribute("arrWorkers", employeeMgr.getCashedTableAsBusObjects());
                    request.setAttribute("vecIssueTasks", vecIssueTasks);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 58:
                    Hashtable taskByEmpHash = new Hashtable();
                    PlannedTasksMgr plannedTasksMgr = PlannedTasksMgr.getInstance();
                    EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                    WebBusinessObject planTaskWbo = new WebBusinessObject();
                    Vector vecPlannedTasks = plannedTasksMgr.getPlannedTasksByIssue(request.getParameter("issueId"));
                    Vector vecTasksHours = new Vector();
                    for (int i = 0; i < vecPlannedTasks.size(); i++) {
                        planTaskWbo = (WebBusinessObject) vecPlannedTasks.get(i);
                        vecTasksHours = empTasksHoursMgr.getTasksHoursByTasks(planTaskWbo.getAttribute("taskId").toString(), planTaskWbo.getAttribute("issueID").toString());
                        taskByEmpHash.put(planTaskWbo.getAttribute("taskId").toString(), vecTasksHours);
                    }

                    // Vector vecTasksHours = empTasksHoursMgr.getTasksHoursByIssue(request.getParameter("issueId"));
                    servedPage = "/docs/issue/workers_report.jsp";
                    issueMgr = IssueMgr.getInstance();
                    WebBusinessObject wbo = issueMgr.getOnSingleKey(request.getParameter("issueId"));
                    request.setAttribute("wbo", wbo);
                    request.setAttribute("vecPlannedTasks", vecPlannedTasks);
                    request.setAttribute("taskByEmpHash", taskByEmpHash);
                    request.setAttribute("vecTasksHours", vecTasksHours);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 59:
                    servedPage = "/docs/issue/add_workers.jsp";
                    String[] arrTaskID = request.getParameterValues("taskID");
                    String[] arrWorker = request.getParameterValues("worker");
                    String[] arrActualHours = request.getParameterValues("actualHours");
                    issueTasksMgr = IssueTasksMgr.getInstance();
                    empBasicMgr = EmpBasicMgr.getInstance();

                    vecIssueTasks = new Vector();
                    try {
                        vecIssueTasks = issueTasksMgr.getOnArbitraryKey(request.getParameter("issueId"), "key1");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    request.setAttribute("arrWorkers", empBasicMgr.getCashedTableAsBusObjects());
                    request.setAttribute("vecIssueTasks", vecIssueTasks);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 66:
                    items = new Vector();

                    try {
                        servedPage = "/docs/schedule/schedule_config_Emg_Job.jsp";
                        String periodicScheduleId = request.getParameter("periodicMntnce");
                        String machineId = request.getParameter("machineId");

                        QuantifiedMntenceMgr quantifiedMntenceEmgMgr = QuantifiedMntenceMgr.getInstance();
                        Vector quantifiedItems = quantifiedMntenceEmgMgr.getOnArbitraryKey(periodicScheduleId, "key1");

                        if (quantifiedItems != null) {
                            for (int i = 0; i < quantifiedItems.size(); i++) {
                                WebBusinessObject wboTemp = (WebBusinessObject) quantifiedItems.elementAt(i);
                                items.add(wboTemp.getAttribute("itemId").toString());
                            }
                        }

//                    machineItems = itemCatsMgr.getOnArbitraryKey(machineId,"key1");
                        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                        maintenanceItemMgr.cashData();
                        machineItems = new Vector();
                        ArrayList arrMachineItems = maintenanceItemMgr.getCashedTableAsBusObjects();
                        for (int i = 0; i < arrMachineItems.size(); i++) {
                            machineItems.add(arrMachineItems.get(i));
                        }
//                    itemsCats = itemCatsMgr.getItemsCats(machineId);

                        itemsCats = new Vector();
                        CategoryMgr categoryMgr = CategoryMgr.getInstance();
                        categoryMgr.cashData();
                        ArrayList arrCats = categoryMgr.getCashedTableAsArrayList();
                        for (int i = 0; i < arrCats.size(); i++) {
                            itemsCats.add(arrCats.get(i));
                        }

                        request.setAttribute("items", items);
                        request.setAttribute("quantifiedItems", quantifiedItems);

                        request.setAttribute("scheduleID", periodicScheduleId);
                        request.setAttribute("machineItems", machineItems);
                        request.setAttribute("categories", itemsCats);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    } catch (SQLException sex) {
                        System.out.append("SQL Exception " + sex.getMessage());
                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }

                    break;

                case 67:
                    items = new Vector();

                    try {
                        servedPage = "/docs/schedule/schedule_config_Emg_JobTask.jsp";
                        String periodicScheduleId = request.getParameter("periodicMntnce");
                        String machineId = request.getParameter("machineId");

                        QuantifiedMntenceMgr quantifiedMntenceEmgMgr = QuantifiedMntenceMgr.getInstance();
                        Vector quantifiedItems = quantifiedMntenceEmgMgr.getOnArbitraryKey(periodicScheduleId, "key1");

                        if (quantifiedItems != null) {
                            for (int i = 0; i < quantifiedItems.size(); i++) {
                                WebBusinessObject wboTemp = (WebBusinessObject) quantifiedItems.elementAt(i);
                                items.add(wboTemp.getAttribute("itemId").toString());
                            }
                        }

//                    machineItems = itemCatsMgr.getOnArbitraryKey(machineId,"key1");
                        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                        maintenanceItemMgr.cashData();
                        machineItems = new Vector();
                        ArrayList arrMachineItems = maintenanceItemMgr.getCashedTableAsBusObjects();
                        for (int i = 0; i < arrMachineItems.size(); i++) {
                            machineItems.add(arrMachineItems.get(i));
                        }
//                    itemsCats = itemCatsMgr.getItemsCats(machineId);

                        itemsCats = new Vector();
                        CategoryMgr categoryMgr = CategoryMgr.getInstance();
                        categoryMgr.cashData();
                        ArrayList arrCats = categoryMgr.getCashedTableAsArrayList();
                        for (int i = 0; i < arrCats.size(); i++) {
                            itemsCats.add(arrCats.get(i));
                        }

                        request.setAttribute("items", items);
                        request.setAttribute("quantifiedItems", quantifiedItems);

                        request.setAttribute("scheduleID", periodicScheduleId);
                        request.setAttribute("machineItems", machineItems);
                        request.setAttribute("categories", itemsCats);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    } catch (SQLException sex) {
                        System.out.append("SQL Exception " + sex.getMessage());
                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }

                    break;

                case 68:
                    servedPage = "/docs/schedule/new_Equip_Schedule.jsp";
                    schType = "none";

                    eqpsVec = new Vector();
                    vecSchedule = new Vector();

                    WebBusinessObject unitWbo = null;
                    String unitName = new String();
                    String unitCatID = new String();

                    try {
                        session = request.getSession();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                        /**
                         * ********** Single Version *************
                         */
                        eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        /**
                         * ********** End Single Version *************
                         */
                        if (request.getParameter("unit").equalsIgnoreCase("non")) {
                            if (eqpsVec.size() > 0) {
                                unitWbo = (WebBusinessObject) eqpsVec.elementAt(0);
                            }
                        } else {
                            unitWbo = unit.getOnSingleKey(request.getParameter("unit").toString());
                        }

                        unitName = unitWbo.getAttribute("unitName").toString();
                        unitCatID = unitWbo.getAttribute("parentId").toString();

                        vecSchedule = scheduleMgr.getOnArbitraryDoubleKey("1", "key3", unitWbo.getAttribute("id").toString(), "key2");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    ArrayList eqpsArray = new ArrayList();
                    for (int i = 0; i < eqpsVec.size(); i++) {
                        eqpsArray.add(eqpsVec.get(i));
                    }
                    request.setAttribute("equipments", eqpsArray);
                    request.setAttribute("schType", schType);
                    request.setAttribute("data", vecSchedule);
                    request.setAttribute("selectedUnitName", unitName);
                    request.setAttribute("unitCatID", unitCatID);
                    request.setAttribute("tradeVec", userTradesVec);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 69:
                    dateAndTime = new DateAndTimeControl();
                    minutes = 0;
                    schType = request.getParameter("schType");
                    unitId = request.getParameter("unitId");
                    servedPage = "/docs/schedule/added_schedule.jsp";

                    schedule = new WebBusinessObject();
                    scheduleID = "";

                    partWbo = new WebBusinessObject();
                    taskWbo = new WebBusinessObject();
                    taskPartsHt = new Hashtable();
                    tasksData = new Vector();
                    itemsMgr = ItemsMgr.getInstance();
                    tempParts = new Vector();
                    composePartsVec = new Vector();

                    schedule = scheduleMgr.formEqpScheduleScraping(request);

                    day = (String) request.getParameter("day");
                    hour = (String) request.getParameter("hour");
                    minute = (String) request.getParameter("minute");

                    if (day != null && !day.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfDay(day);
                    }
                    if (hour != null && !hour.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfHour(hour);
                    }
                    if (minute != null && !minute.equals("")) {
                        minutes = minutes + new Integer(minute).intValue();
                    }
                    schedule.setAttribute("duration", "" + minutes);
                    WebBusinessObject schWbo = new WebBusinessObject();
                    maintainableMgr = MaintainableMgr.getInstance();

                    Vector unitSchedulesVec = new Vector();

                    try {
                        unitSchedulesVec = scheduleMgr.getOnArbitraryDoubleKey(schedule.getAttribute("scheduleTitle").toString(), "key1", schedule.getAttribute("eqpCatID").toString(), "key2");
                    } catch (SQLException SQLex) {
                        System.out.println("Schedule Servlet: save schedule sql " + SQLex.getMessage());
                    } catch (Exception ex) {
                        System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());
                    }

                    if (unitSchedulesVec.isEmpty()) {
                        try {
                            scheduleID = scheduleMgr.saveEquipSchedule(schedule, session);
                            if (scheduleID != null) {
                                schWbo = scheduleMgr.getOnSingleKey(scheduleID);

                                mode = (String) request.getSession().getAttribute("currentMode");
                                // Activate Schedule Side Menu
                                Tools.ActivateScheduleSideMenu(request, unitId, scheduleID, "", mode);

                                request.setAttribute("Status", "Ok");

                                tasksCodes = request.getParameterValues("id");
                                if (tasksCodes != null) {
                                    //get task Data to back to Jsp
                                    TaskMgr taskMgr = TaskMgr.getInstance();
                                    for (int index = 0; index < tasksCodes.length; index++) {
                                        taskWbo = new WebBusinessObject();
                                        taskWbo = taskMgr.getOnSingleKey(tasksCodes[index]);
                                        tasksData.add(taskWbo);
                                    }

                                    if (tasksCodes != null) {
                                        scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                                        if (scheduleTasksMgr.saveObject(request, scheduleID)) {
                                            request.setAttribute("Status", "Ok");
                                        } else {
                                            request.setAttribute("Status", "No");
                                        }

                                        /**
                                         * ************Get Parts of Maintenance
                                         * Item and add it to
                                         * schedule*****************
                                         */
                                        ConfigTasksPartsMgr configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                        Vector taskParts = new Vector();
                                        WebBusinessObject taskPartWbo = new WebBusinessObject();

                                        Hashtable hashConfig;
                                        for (int i = 0; i < tasksCodes.length; i++) {
                                            taskParts = new Vector();
                                            composePartsVec = new Vector();
                                            taskParts = configTasksPartsMgr.getOnArbitraryKey(tasksCodes[i], "key1");

                                            for (int c = 0; c < taskParts.size(); c++) {
                                                taskPartWbo = new WebBusinessObject();
                                                taskPartWbo = (WebBusinessObject) taskParts.get(c);

                                                tempParts = new Vector();
                                                WebBusinessObject item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());

                                                composePartsVec.add(item);

                                                hashConfig = new Hashtable();
                                                hashConfig.put("scheduleId", scheduleID);
                                                hashConfig.put("itemID", taskPartWbo.getAttribute("itemId").toString());
                                                hashConfig.put("itemQuantity", taskPartWbo.getAttribute("itemQuantity").toString());
                                                hashConfig.put("itemPrice", taskPartWbo.getAttribute("itemPrice").toString());
                                                hashConfig.put("totalCost", taskPartWbo.getAttribute("totalCost").toString());
                                                hashConfig.put("note", taskPartWbo.getAttribute("note").toString());
                                                try {
                                                    configureMainTypeMgr.saveObject(hashConfig, session);
                                                    request.setAttribute("Status", "OK");
                                                } catch (Exception ex) {
                                                    System.out.println("General Exception:" + ex.getMessage());
                                                }
                                            }
                                            //set task with it's parts
                                            taskPartsHt.put(tasksCodes[i], composePartsVec);
                                        }
                                    }
                                }
                                schedule = scheduleMgr.getOnSingleKey(scheduleID);
                                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                                itemList = configureMainTypeMgr.getConfigItemBySchedule(scheduleID);

                                scheduleDocMgr = ScheduleDocMgr.getInstance();
                                docsList = scheduleDocMgr.getListOnLIKE("ListDoc", scheduleID);

                                request.setAttribute("schType", schType);
                                request.setAttribute("tasks", tasksData);
                                request.setAttribute("taskPartsHt", taskPartsHt);
                                request.setAttribute("data", itemList);
                                request.setAttribute("schedule", schedule);
                                request.setAttribute("scheduleId", scheduleID);
                                request.setAttribute("source", request.getParameter("source"));
                                request.setAttribute("docData", docsList);
                                request.setAttribute("page", servedPage);
                                this.forwardToServedPage(request, response);
                            } else {
                                backToNewEquipmentSchedule(request, response);
                            }
                        } catch (SQLException SQLex) {
                            System.out.println("Schedule Servlet: save schedule sql " + SQLex.getMessage());
                            backToNewEquipmentSchedule(request, response);
                        } catch (Exception ex) {
                            System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());
                            backToNewEquipmentSchedule(request, response);
                        }
                    } else {
                        backToNewEquipmentSchedule(request, response);
                    }
                    break;

                case 70:
                    Vector equipments = new Vector();

                    scheduleMgr = ScheduleMgr.getInstance();
                    Vector vecTotals = scheduleMgr.getScheduleCountByCategories();
                    Hashtable hashtable = new Hashtable();

                    for (int i = 0; i < vecTotals.size(); i++) {
                        WebBusinessObject wboTemp = (WebBusinessObject) vecTotals.get(i);
                        try {
                            hashtable.put(wboTemp.getAttribute("equipmentCatID"), wboTemp.getAttribute("frequency"));
                        } catch (NullPointerException ex) {
                        }
                    }
                    MaintainableMgr maintenableUnit = MaintainableMgr.getInstance();
                    maintenableUnit.cashData();
                    equipments = maintenableUnit.getAllCategoryEqu();
                    servedPage = "/docs/schedule/schedule_by_category_list.jsp";

                    // get Equipments
                    Tools.setRequestByBrandsInfo(request, 20);

                    request.setAttribute("hashtable", hashtable);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 71:
                    equipments = new Vector();
                    vecTotals = new Vector();

                    scheduleMgr = ScheduleMgr.getInstance();
                    vecTotals = scheduleMgr.getScheduleCountByEquipment();
                    hashtable = new Hashtable();

                    for (int i = 0; i < vecTotals.size(); i++) {
                        WebBusinessObject wboTemp = (WebBusinessObject) vecTotals.get(i);
                        hashtable.put(wboTemp.getAttribute("equipmentID"), wboTemp.getAttribute("frequency"));
                    }
                    // get Equipments
                    Tools.setRequestByEquipmentsInfo(request, 20);

                    servedPage = "/docs/schedule/schedule_by_equipment_list.jsp";
                    request.setAttribute("hashtable", hashtable);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 72:
                    servedPage = "/docs/schedule/List_all_eqp_schedules.jsp";

                    equipmentsVec = new Vector();
                    schedulesVec = new Vector();

                    equipmentID = "";
                    equipmentCatName = "";

                    eqpWbo = null;

                    try {
                        schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(request.getParameter("equipmentID"), "key2", "Eqp", "key5");
                    } catch (Exception ex) {
                        System.out.println("Schedule Listing Exception =" + ex.getMessage());
                    }

                    request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                    request.setAttribute("unitName", Tools.getRealChar(request.getParameter("unitName")));
                    request.setAttribute("equipSchedules", schedulesVec);
                    request.setAttribute("backTo", request.getQueryString());
                    request.setAttribute("page", servedPage);
                    request.setAttribute("equipCatName", equipmentCatName);

                    this.forwardToServedPage(request, response);
                    break;
                case 73:
                    periodicID = request.getParameter("periodicID");

                    try {
                        scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                        quantifiedMntenceMgr.deleteOnArbitraryKey(periodicID, "key1");
                        scheduleTasksMgr.deleteOnArbitraryKey(periodicID, "key1");
                        configureMainTypeMgr.deleteOnArbitraryKey(periodicID, "key1");
                        scheduleMgr.deleteOnSingleKey(periodicID);
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    servedPage = "/docs/schedule/List_all_eqp_schedules.jsp";

                    equipmentsVec = new Vector();
                    schedulesVec = new Vector();

                    equipmentID = "";
                    equipmentCatName = "";

                    eqpWbo = null;

                    try {
                        schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(request.getParameter("equipmentID"), "key2", "Eqp", "key5");
                    } catch (Exception ex) {
                        System.out.println("Schedule Listing Exception = " + ex.getMessage());
                    }

                    request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                    request.setAttribute("equipSchedules", schedulesVec);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("equipCatName", equipmentCatName);

                    this.forwardToServedPage(request, response);
                    break;

                case 74:
                    schType = request.getParameter("schType");
                    String ID = request.getParameter("scheduleId");
                    scheduleMgr = ScheduleMgr.getInstance();
                    schWbo = new WebBusinessObject();
                    schWbo = scheduleMgr.getOnSingleKey(ID);
                    request.setAttribute("schWbo", schWbo);
                    servedPage = "/docs/schedule/Add_Maint_Item.jsp";
                    request.setAttribute("schType", schType);
                    request.setAttribute("schId", ID);
                    request.setAttribute("page", servedPage);
                    session.setAttribute("ToBakeTo", request.getParameter("ToBakeTo"));
                    if (request.getParameter("fromView") == null) {
                        session.removeAttribute("urlBackToView");
                    }
                    this.forwardToServedPage(request, response);
                    break;
                case 75:
                    schType = request.getParameter("schType");
                    if (schType == null || schType.equalsIgnoreCase("")) {
                        schType = "none";
                    }

                    String schID = request.getParameter("schId");
                    System.out.println("Addddddddddddd   " + schID);
                    status = "";
                    scheduleTasksMgr = ScheduleTasksMgr.getInstance();

                    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                    //get items stored in database
                    Vector storedItems = new Vector();
                    Vector taskParts = new Vector();
                    WebBusinessObject schTaskWbo = new WebBusinessObject();
                    WebBusinessObject taskPartWbo = new WebBusinessObject();
                    ConfigTasksPartsMgr configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                    Hashtable hashConfig = new Hashtable();
                    taskPartsHt = new Hashtable();

                    try {
                        /**
                         * *************Get sch tasks then get task parts then
                         * delete parts from schedule and delete tasks from
                         * shchedule***************
                         */
                        storedItems = scheduleTasksMgr.getOnArbitraryKey(schID, "key1");
                        if (storedItems != null) {

                            for (int i = 0; i < storedItems.size(); i++) {

                                schTaskWbo = new WebBusinessObject();
                                taskPartWbo = new WebBusinessObject();
                                taskParts = new Vector();

                                schTaskWbo = (WebBusinessObject) storedItems.get(i);
                                taskParts = configTasksPartsMgr.getOnArbitraryKey(schTaskWbo.getAttribute("codeTask").toString(), "key1");

                                //loop To Delete Parts from Schedule that are related to items
                                for (int c = 0; c < taskParts.size(); c++) {
                                    taskPartWbo = new WebBusinessObject();
                                    taskPartWbo = (WebBusinessObject) taskParts.get(c);
                                    String itemId = taskPartWbo.getAttribute("itemId").toString();
                                    configureMainTypeMgr.deleteOnArbitraryDoubleKey(schID, "key1", itemId, "key2");
                                }
                                /**
                                 * **************End Of Delete
                                 * Loop**********************
                                 */
                            }
                        }

                        /* Delete Old Tasks Then Add New Tasks with Their Parts*/
                        itemsMgr = ItemsMgr.getInstance();
                        scheduleTasksMgr.deleteOnArbitraryKey(schID, "key1");
                        if (scheduleTasksMgr.saveObject(request, schID)) {
                            request.setAttribute("status", "ok");
                        } else {
                            status = "fail";
                        }

                        /*Get Parts of Tasks Then Save it on Schedule*/
                        tasksCodes = request.getParameterValues("id");    //New tasks Ids
                        for (int i = 0; i < tasksCodes.length; i++) {
                            taskParts = new Vector();
                            composePartsVec = new Vector();
                            taskParts = configTasksPartsMgr.getOnArbitraryKey(tasksCodes[i], "key1");  //task Parts

                            for (int c = 0; c < taskParts.size(); c++) {
                                taskPartWbo = new WebBusinessObject();
                                taskPartWbo = (WebBusinessObject) taskParts.get(c);

                                tempParts = new Vector();
                                tempParts = itemsMgr.getOnArbitraryKey(taskPartWbo.getAttribute("itemId").toString(), "key3");
                                if (tempParts.size() > 0) {
                                    partWbo = (WebBusinessObject) tempParts.get(0);
                                    composePartsVec.add(partWbo); //compose Vec of wbo of parts related to tasks
                                }

                                hashConfig = new Hashtable();
                                hashConfig.put("scheduleId", schID);
                                hashConfig.put("itemID", taskPartWbo.getAttribute("itemId").toString());
                                hashConfig.put("itemQuantity", taskPartWbo.getAttribute("itemQuantity").toString());
                                hashConfig.put("itemPrice", taskPartWbo.getAttribute("itemPrice").toString());
                                hashConfig.put("totalCost", taskPartWbo.getAttribute("totalCost").toString());
                                hashConfig.put("note", taskPartWbo.getAttribute("note").toString());
                                try {
                                    configureMainTypeMgr.saveObject(hashConfig, session);
                                    request.setAttribute("Status", "OK");
                                } catch (Exception ex) {
                                    System.out.println("General Exception:" + ex.getMessage());
                                }
                            }
                            //set task with it's parts To Back To JSP in case need to display tasks and parts
                            taskPartsHt.put(tasksCodes[i], composePartsVec);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    servedPage = "/docs/schedule/Add_Maint_Item.jsp";
                    session.removeAttribute("ToBakeTo");
                    scheduleMgr = ScheduleMgr.getInstance();
                    schWbo = new WebBusinessObject();
                    schWbo = scheduleMgr.getOnSingleKey(schID);
                    request.setAttribute("schWbo", schWbo);
                    request.setAttribute("schType", schType);
                    request.setAttribute("schId", schID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 76:
                    schType = request.getParameter("schType");
                    schID = request.getParameter("schId");
                    System.out.println("Addddddddddddd   " + schID);
                    url = "";
                    if (((String) session.getAttribute("ToBakeTo")).equals("creatEq")) {
                        url = "ScheduleServlet?op=createEqpSchedule&unit=non";
                    } else if (((String) session.getAttribute("ToBakeTo")).equals("creatEqByKil")) {
                        url = "ScheduleServlet?op=createEqpScheduleByKel&unitCats=non";
                    } else if (((String) session.getAttribute("ToBakeTo")).equals("creatSch")) {
                        url = "ScheduleServlet?op=createSchedule&unitCats=non";
                    } else if (((String) session.getAttribute("ToBakeTo")).equals("saveSchedule")) {
                        url = "ScheduleServlet?op=DisplySavedSchedule&source=cat&scheduleId=" + schID;
                    } else if (((String) session.getAttribute("ToBakeTo")).equals("saveEqpSchedule")) {
                        url = "ScheduleServlet?op=DisplySavedSchedule&source=eqp&scheduleId=" + schID + "&schType=" + schType;
                    }
                    session.removeAttribute("ToBakeTo");
                    request.setAttribute("schType", schType);
                    if (!response.isCommitted()) {
                        response.sendRedirect(url);
                    }
                    break;

                case 77:
                    periodicID = null;
                    itemList = new Vector();
                    ConfigureMainTypeMgr itemsList1 = ConfigureMainTypeMgr.getInstance();
                    servedPage = "/docs/schedule/View_Config.jsp";
                    periodicID = request.getParameter("periodicID");
                    schWbo = new WebBusinessObject();
                    scheduleMgr = ScheduleMgr.getInstance();
                    schWbo = scheduleMgr.getOnSingleKey(periodicID);
                    request.setAttribute("schWbo", schWbo);
                    itemList = itemsList1.getConfigItemBySchedule(periodicID);
                    request.setAttribute("data", itemList);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 78:
                    String SID = request.getParameter("SID");
                    schWbo = new WebBusinessObject();
                    scheduleMgr = ScheduleMgr.getInstance();
                    schWbo = scheduleMgr.getOnSingleKey(SID);
                    request.setAttribute("schWbo", schWbo);
                    request.setAttribute("schId", SID);
                    servedPage = "/docs/schedule/view_labor.jsp";

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;
                case 79:
                    String Sname = request.getParameter("Sname");
                    int size = 0;
                    String res = "";
                    try {
                        Vector schedlus = scheduleMgr.getOnArbitraryKey(Sname, "key1");
                        size = schedlus.size();
                        response.setContentType("text/xml;charset=UTF-8");

                        unitWbo = null;
                        String frequencyTyp = "";
                        String type = "";
                        WebBusinessObject tradeWbo = null;
                        schedule = (WebBusinessObject) schedlus.get(0);
                        session.removeAttribute("scheduleOnSession");
                        tradeMgr = TradeMgr.getInstance();
                        MaintainableMgr unitMgr = MaintainableMgr.getInstance();
                        if (schedule != null) {
                            tradeWbo = tradeMgr.getOnSingleKey((String) schedule.getAttribute("workTrade"));
                            frequencyTyp = (String) schedule.getAttribute("frequencyType");
                            type = new String("");
                            if (frequencyTyp.equals("1")) {
                                type = new String("Day");
                            } else if (frequencyTyp.equals("2")) {
                                type = new String("Week");
                            } else if (frequencyTyp.equals("3")) {
                                type = new String("Month");
                            } else if (frequencyTyp.equals("4")) {
                                type = new String("Year");
                            } else {
                                type = new String("Hour");
                            }

                            if (schedule.getAttribute("scheduledOn").toString().equalsIgnoreCase("Cat")) {
                                unitWbo = (WebBusinessObject) unitMgr.getOnSingleKey(schedule.getAttribute("equipmentCatID").toString());

                            } else {
                                unitWbo = (WebBusinessObject) unitMgr.getOnSingleKey(schedule.getAttribute("equipmentID").toString());

                            }

                            String name = "";
                            if (schedule.getAttribute("scheduledOn").toString().equalsIgnoreCase("Cat")) {
                                name = "cat";
                            } else {
                                name = "eqp";
                            }

                            res += (String) schedule.getAttribute("maintenanceTitle") + "!=";
                            res += name + "!=";
                            res += (String) unitWbo.getAttribute("unitName") + "!=";
                            res += (String) schedule.getAttribute("frequency") + "!=";
                            res += type + "!=";
                            res += (String) schedule.getAttribute("duration") + "!=";
                            res += (String) tradeWbo.getAttribute("tradeName") + "!=";
                            res += (String) schedule.getAttribute("description");
                        }
                    } catch (Exception ex) {
                    }

                    response.setHeader("Cache-Control", "no-cache");

                    response.getWriter().write("" + size + "!=" + res);

                    break;

                case 80:

                    servedPage = "/docs/Search/searchSchdule.jsp";

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 81:
                    servedPage = "/docs/schedule/search_schedule.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 82:
                    servedPage = "/docs/schedule/Delete_report.jsp";

                    scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("scheduleID"));

                    request.setAttribute("source", request.getParameter("source"));
                    request.setAttribute("userTrades", userTradesVec);
                    request.setAttribute("scheduleWbo", scheduleWbo);
                    request.setAttribute("scheduleConfig", ScheduleMgr.sheduleConfig);
                    request.setAttribute("scheduleTasks", ScheduleMgr.scheduleTasks);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 83:
                    scheduleID = request.getParameter("scheduleID");
                    scheduleMgr = ScheduleMgr.getInstance();
                    if (scheduleID != null) {
                        WebBusinessObject wboSchedule = new WebBusinessObject();
                        wboSchedule = scheduleMgr.getOnSingleKey(scheduleID);

                        if (wboSchedule != null) {
                            configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                            itemList = configureMainTypeMgr.getConfigItemBySchedule(scheduleID);
                            request.setAttribute("data", itemList);
                            servedPage = "/docs/schedule/search_schedule_result.jsp";
                            request.setAttribute("schedule", wboSchedule);
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                        } else {
                            servedPage = "/docs/schedule/search_schedule.jsp";
                            request.setAttribute("page", servedPage);
                            request.setAttribute("message", "No Schedule with this ID was found");
                            this.forwardToServedPage(request, response);
                        }
                    } else {
                        servedPage = "/docs/schedule/search_schedule.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("message", "No Schedule with this ID was found");
                        this.forwardToServedPage(request, response);
                    }
                    break;

                case 84:
                    schType = request.getParameter("schType");
                    servedPage = "/docs/schedule/added_schedule.jsp";
                    scheduleID = request.getParameter("scheduleId");

                    schedule = scheduleMgr.getOnSingleKey(scheduleID);
                    configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                    itemList = configureMainTypeMgr.getConfigItemBySchedule(scheduleID);
                    request.setAttribute("data", itemList);
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("scheduleId", scheduleID);
                    request.setAttribute("source", request.getParameter("source"));

                    scheduleDocMgr = ScheduleDocMgr.getInstance();
                    docsList = scheduleDocMgr.getListOnLIKE("ListDoc", scheduleID);
                    request.setAttribute("docData", docsList);
                    request.setAttribute("schType", schType);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 85:
                    int month = 0;
                    int year = 0;
                    int minDate = 0;
                    int maxDate = 0;
                    UserMgr userMgr = UserMgr.getInstance();
                    Vector users = new Vector();
                    String clientId = (String) request.getParameter("clientId");
                    String clientCompId = (String) request.getParameter("clientCompId");
                    String areaId = (String) request.getParameter("area_id");
                    String tradeId = "7";
                    userId = (String) request.getParameter("userId");
                    WebBusinessObject clientWbo = new WebBusinessObject();
                    ClientMgr clientMgr = ClientMgr.getInstance();
                    clientWbo = clientMgr.getOnSingleKey(clientId);

//                    users = userMgr.getOnArbitraryKey("0", "key2");
                    ArrayList userList = new ArrayList();

                    ServiceManAreaMgr serviceManAreaMgr = ServiceManAreaMgr.getInstance();
                    users = serviceManAreaMgr.getSupervisorArea(areaId, tradeId);
                    if (users != null & !users.isEmpty()) {
                        for (int i = 0; i < users.size(); i++) {
                            wbo = new WebBusinessObject();
                            wbo = (WebBusinessObject) users.get(i);
                            WebBusinessObject wbo2 = new WebBusinessObject();
                            userId = (String) wbo.getAttribute("userId");
                            wbo2 = userMgr.getOnSingleKey(userId);
                            userList.add(wbo2);
                        }

                    }
//                    for (int i = 0; i < users.size(); i++) {
//                        userList.add(users.get(i));
//                    }
                    String[] monthsArray = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                    String period = null;

                    equipmentsList = new ArrayList();
                    ArrayList monthsList = new ArrayList();
                    ArrayList yearsList = new ArrayList();
                    eqpSchedules = new Vector();

                    WebBusinessObject equipmentWbo = null;
                    WebBusinessObject monthWbo = new WebBusinessObject();

                    Calendar monthCal = Calendar.getInstance();

                    //Initialize months array list
                    for (int i = 0; i < 12; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", monthsArray[i]);
                        monthsList.add(wbo);
                    }

                    for (int i = 2013; i <= 2020; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", new Integer(i).toString());
                        yearsList.add(wbo);

                    }

                    servedPage = "/docs/schedule/user_calendar.jsp";

                    // period = request.getParameter("peroid");
                    period = "currentMonth";
                    try {
                        //Get Equipments Vector
                        equipmentsList = unit.getMaintenanbleEquAsBusObjects();

                        if (period.equalsIgnoreCase("currentMonth")) {
                            //Get current month
                            month = monthCal.getTime().getMonth();

                            //Get first Equipment in the list
                            if (equipmentsList.size() > 0) {
                                equipmentWbo = (WebBusinessObject) equipmentsList.get(0);
                            } else {
                                request.setAttribute("equipment", equipmentWbo);
                            }

                            request.setAttribute("period", "currentMonth");
                        } else {
                            //Get Selected Month
                            month = new Integer(request.getParameter("month")).intValue();

                            //Get Selected Equipment
                            equipmentWbo = unit.getOnSingleKey(request.getParameter("equipment"));

                            request.setAttribute("period", "other");
                        }

                        //period calculations
                        year = monthCal.getTime().getYear();
                        minDate = monthCal.getActualMinimum(monthCal.DATE);
                        maxDate = monthCal.getActualMaximum(monthCal.DATE);

                        beginDate = new java.sql.Date(year, month, minDate);
                        endDate = new java.sql.Date(year, month, maxDate);

                        //Get Equipment Schedules
                        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
//                        eqpSchedules = appointmentMgr.getAppointmentsDates(equipmentWbo.getAttribute("id").toString(), beginDate, endDate);
//                        if (eqpSchedules.size() > 0) {
                        request.setAttribute("eqpSchedules", eqpSchedules);
//                        } else {
                        //    request.setAttribute("eqpSchedules", eqpSchedules);
                        //   }

                        //create month wbo
                        Vector interestedUnit = new Vector();
                        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();

                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        ArrayList units = new ArrayList();

                        if (interestedUnit != null & !interestedUnit.isEmpty()) {
                            for (int i = 0; i < interestedUnit.size(); i++) {
                                units.add(interestedUnit.get(i));
                            }
                        }
                        monthWbo.setAttribute("id", new Integer(month).toString());
                        monthWbo.setAttribute("name", monthsArray[month]);

                        request.setAttribute("units", units);
                        request.setAttribute("month", monthWbo);
                        request.setAttribute("users", userList);
                        request.setAttribute("monthsList", monthsList);
                        request.setAttribute("yearsList", yearsList);
                        request.setAttribute("equipment", equipmentWbo);
                        request.setAttribute("clientWbo", clientWbo);

                    } catch (Exception ex) {
                        System.out.println("Schedule Servlet -- get equipment schedule exception = " + ex.getMessage());
                    }

                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);

                    break;

                case 86:
                    schType = "kilometer";
                    servedPage = "/docs/schedule/new_Equip_Schedule_by_Kel.jsp";

                    eqpsVec = new Vector();
                    vecSchedule = new Vector();

                    unitWbo = null;
                    unitName = new String();
                    unitCatID = new String();
                    ArrayList unitsListArr = new ArrayList();
                    try {
                        /**
                         * ********** Single Version *************
                         */
                        String[] params = {"1", "0", "odometer"};
                        String[] keys = {"key3", "key5", "key9"};
                        eqpsVec = unit.getOnArbitraryNumberKey(3, params, keys);
                        /**
                         * ********** End Single Version *************
                         */
                        if (request.getParameter("unit").equalsIgnoreCase("non")) {
                            if (unitsListArr.size() > 0) {
                                unitWbo = (WebBusinessObject) unitsListArr.get(0);
                            }
                        } else {
                            unitWbo = unit.getOnSingleKey(request.getParameter("unit").toString());
                        }

                        unitName = unitWbo.getAttribute("unitName").toString();
                        unitCatID = unitWbo.getAttribute("parentId").toString();

                        vecSchedule = scheduleMgr.getOnArbitraryDoubleKey("5", "key6", unitWbo.getAttribute("id").toString(), "key2");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    eqpsArray = new ArrayList();
                    for (int i = 0; i < eqpsVec.size(); i++) {
                        eqpsArray.add(eqpsVec.get(i));
                    }
                    request.setAttribute("equipments", eqpsArray);
                    request.setAttribute("schType", schType);
                    request.setAttribute("unitsList", unitsListArr);
                    request.setAttribute("data", vecSchedule);
                    request.setAttribute("selectedUnitName", unitName);
                    request.setAttribute("unitCatID", unitCatID);
                    request.setAttribute("tradeVec", userTradesVec);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 87:
                    status = "";

                    try {
                        if (issueMgr.updateEmgOrder(request, session)) {
                            status = "ok";
                        } else {
                            status = "fail";
                        }
                        System.out.println("**************************" + status);
                    } catch (Exception e) {
                        System.out.println("" + e);

                    }

                    machineItems = new Vector();
                    itemsCats = new Vector();
                    itemList = new Vector();
                    try {
                        servedPage = "/docs/schedule/schedule_config.jsp";

                        String unitScheduleId = request.getParameter("scheduleUnitID");
                        QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                        itemList = ListItems.getItemSchedule(unitScheduleId);
                        request.setAttribute("tradeVec", userTradesVec);
                        request.setAttribute("type", request.getParameter("type"));

                        request.setAttribute("data", itemList);
                        request.setAttribute("uID", unitScheduleId);
                        request.setAttribute(IssueConstants.ISSUEID, request.getParameter("issueId"));
                        request.setAttribute(IssueConstants.ISSUETITLE, request.getParameter("issueTitle"));

                        request.setAttribute("filter", request.getParameter("filterName"));
                        request.setAttribute("filterValue", request.getParameter("filterValue"));
                        request.setAttribute("shift", request.getParameter("shift"));
                        request.setAttribute("estimatedTime", request.getParameter("duration"));
                        request.setAttribute("description", request.getParameter("issueDesc"));
                        request.setAttribute("status", status);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                    } catch (Exception e) {
                        System.out.println("General Exception " + e.getMessage());
                    }

                    request.setAttribute("status", status);

                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

//             case 88:
//                servedPage = "/docs/issue/add_workers.jsp";
//
//                 issueTasksMgr = IssueTasksMgr.getInstance();
//                 empBasicMgr = EmpBasicMgr.getInstance();
//                //EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
//                 vecIssueTasks = new Vector();
//                try {
//                    vecIssueTasks = issueTasksMgr.getOnArbitraryKey(request.getParameter("issueId"), "key1");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                request.setAttribute("employeeType", "1");
//                request.setAttribute("arrWorkers", empBasicMgr.getCashedTableAsBusObjects());
//                request.setAttribute("vecIssueTasks", vecIssueTasks);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
                case 89:
                    servedPage = "/docs/schedule/acivateScheduleEqHr.jsp";

                    equipWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    unit = MaintainableMgr.getInstance();
                    scheduleMgr = ScheduleMgr.getInstance();
                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                    WebBusinessObject locationWbo = new WebBusinessObject();

                    try {
                        equipWbo = unit.getOnSingleKey(request.getParameter("eqpId"));
                        schWbo = scheduleMgr.getOnSingleKey(request.getParameter("schId"));
                        locationWbo = projectMgr.getOnSingleKey(equipWbo.getAttribute("site").toString());
                        equipWbo.setAttribute("siteName", locationWbo.getAttribute("projectName").toString());

                    } catch (Exception ex) {
                        System.out.println("Get Bind Single Unit Task General Error = " + ex.getMessage());
                    }

                    request.setAttribute("eqpWbo", equipWbo);
                    request.setAttribute("schWbo", schWbo);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("eqpId", (String) request.getParameter("eqpId"));
                    this.forwardToServedPage(request, response);
                    break;

                case 90:
                    servedPage = "/docs/schedule/extent_schedule_report.jsp";

                    eqpCatConfig = ConfigureMainTypeMgr.getInstance();
                    issueMgr = IssueMgr.getInstance();
                    unit = MaintainableMgr.getInstance();
                    equipWbo = new WebBusinessObject();
                    totalCost = 0;

                    scheduleId = request.getParameter("schId");
                    eqID = request.getParameter("equipmentID");

                    equipWbo = unit.getOnSingleKey(eqID);
                    vecUnitSchedule = unitScheduleMgr.getLastUnitSchedule(scheduleId, eqID);
                    wboUnitSchedule = new WebBusinessObject();
                    if (vecUnitSchedule.size() > 0) {
                        wboUnitSchedule = (WebBusinessObject) vecUnitSchedule.get(0);
                    }
                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    issueDates = new Vector();

                    try {
                        scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");

                        machineStatus.addElement(request.getParameter("unitName").toString());
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");

                        Vector eqpOpVec = eqpOpMgr.getOnArbitraryKey(request.getParameter("machines"), "key1");
                        WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVec.elementAt(0);
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

                        String tempDate = (String) wboUnitSchedule.getAttribute("endDate");

//                            beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("bDate")).getTime());
//                            endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("eDate")).getTime());
                        DateParser dateParser = new DateParser();
                        beginDate = dateParser.formatSqlDate(request.getParameter("bDate"));
                        endDate = dateParser.formatSqlDate(request.getParameter("eDate"));

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

//                        if((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("By K.M") || new Integer(eqpOpWbo.getAttribute("average").toString()).intValue() == 0)){
//                            machineStatus.addElement("Failed");
//                            machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
//                        } else {
                            issueDates.removeAllElements();

                            if (frequencyType == 0) {
                                frequency = frequency / new Integer(eqpOpWbo.getAttribute("average").toString()).intValue();
                                frequencyType = 1;
                            } else if (frequencyType == 5) {
                                ParseSideMenu parseSideMenu = new ParseSideMenu();
                                int average = parseSideMenu.getAvrgWorkOfKmEqps();
                                frequency = frequency / average;
                            }
                            int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                            int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                            issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);

                            if (issueDates.size() == 0) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("Please review Task Frequency");
                            } else {
                                if (issueDates.size() > 15) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                } else {
                                    for (int j = 0; j < issueDates.size(); j++) {
                                        Calendar c = Calendar.getInstance();
                                        Calendar d = Calendar.getInstance();

                                        c = (Calendar) issueDates.elementAt(j);
                                        if (j < issueDates.size() - 1) {
                                            d = (Calendar) issueDates.elementAt(j + 1);
                                        }

                                        System.out.println("New Date is " + c.getTime().toString());
                                        System.out.println("New End Date is " + d.getTime().toString());

                                        //Saving Schedule_Units
                                        scheduleUnit = new Vector();
                                        scheduleUnit.addElement(request.getParameter("machines"));
                                        scheduleUnit.addElement(request.getParameter("unitName"));
                                        scheduleUnit.addElement(scheduleId);
                                        scheduleUnit.addElement(scheduleName);
                                        scheduleUnit.addElement(new java.sql.Date(c.getTimeInMillis()));
                                        if (j < issueDates.size() - 1) {
                                            scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                        } else {
                                            scheduleUnit.addElement(endDate);
                                        }
                                        scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                        unitScheduleMgr.saveScheduleUnits(scheduleUnit);

                                        WebBusinessObject wboIssue = new WebBusinessObject();
                                        wboIssue.setAttribute("site", request.getParameter("site").toString());
                                        wboIssue.setAttribute("machine", request.getParameter("unitName").toString());
                                        wboIssue.setAttribute("desc", request.getParameter("desc").toString());
                                        wboIssue.setAttribute("duration", scheduleWbo.getAttribute("duration").toString());
                                        wboIssue.setAttribute("maintenanceTitle", saveSchedule.getAttribute("maintenanceTitle").toString());
                                        wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                                        c.add(Calendar.DAY_OF_MONTH, noOfDays);
                                        wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                                        String unitScheduleId = unitScheduleMgr.getUinqueID();
                                        wboIssue.setAttribute("scheduleUnitID", unitScheduleId);
                                        wboIssue.setAttribute("workTrade", saveSchedule.getAttribute("workTrade").toString());
                                        wboIssue.setAttribute("eqpId", eqID);
                                        try {

                                            Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");

                                            issueMgr.saveSchedule(wboIssue, request.getSession(), scTasks);
                                            issueMgr.updateConfigureValue(unitScheduleMgr.getUinqueID());
                                            //Update Total cost of issue
                                            issueMgr.updateTotalCost(unitScheduleMgr.getUinqueID(), totalCost);

                                            /**
                                             * **************** Transfer
                                             * Schedule Parts To Issues
                                             * **********************
                                             */
                                            configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                                            Vector schParts = configureMainTypeMgr.getOnArbitraryKey(scheduleId, "key1");

                                            WebBusinessObject schPartWbo = new WebBusinessObject();
                                            String[] quantity = new String[schParts.size()];
                                            String[] price = new String[schParts.size()];
                                            String[] cost = new String[schParts.size()];
                                            String[] note = new String[schParts.size()];
                                            String[] id = new String[schParts.size()];
                                            String[] attachedOn = new String[schParts.size()];
                                            String isDirectPrch = "";
                                            QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();
                                            for (int i = 0; i < schParts.size(); i++) {
                                                schPartWbo = new WebBusinessObject();
                                                schPartWbo = (WebBusinessObject) schParts.get(i);
                                                quantity[i] = schPartWbo.getAttribute("itemQuantity").toString();
                                                price[i] = schPartWbo.getAttribute("itemPrice").toString();
                                                cost[i] = schPartWbo.getAttribute("totalCost").toString();
                                                note[i] = schPartWbo.getAttribute("note").toString();
                                                id[i] = schPartWbo.getAttribute("itemId").toString();
                                                isDirectPrch = "0";
                                                attachedOn[i] = "2";
                                            }
                                            QntfMntncMgr.saveObject2(quantity, price, cost, note, id, unitScheduleId, isDirectPrch, attachedOn, session);

                                            /**
                                             * **************** End Of Transfer
                                             * Schedule Parts
                                             * **********************
                                             */
                                        } catch (Exception ex) {
                                            logger.error(ex.getMessage());
                                        }
                                    }
                                    machineStatus.addElement("Success");
                                    machineStatus.addElement("Success");

                                    /**
                                     * **************Get Unit
                                     * Schedules*******************
                                     */
                                    WebBusinessObject composeWbo = new WebBusinessObject();
                                    Vector GenratedUnitSch = unitScheduleMgr.getBindedEqpsSchedules(eqID, scheduleId);
                                    if (GenratedUnitSch.size() > 0) {
                                        composeWbo = new WebBusinessObject();
                                        WebBusinessObject usFirstWbo = (WebBusinessObject) GenratedUnitSch.elementAt(0);
                                        WebBusinessObject usLastWbo = (WebBusinessObject) GenratedUnitSch.elementAt(GenratedUnitSch.size() - 1);

                                        composeWbo.setAttribute("id", usFirstWbo.getAttribute("id").toString());
                                        composeWbo.setAttribute("periodicId", usFirstWbo.getAttribute("periodicId").toString());
                                        composeWbo.setAttribute("maintenanceTitle", usFirstWbo.getAttribute("maintenanceTitle").toString());
                                        composeWbo.setAttribute("beginDate", usFirstWbo.getAttribute("beginDate").toString());
                                        composeWbo.setAttribute("endDate", usLastWbo.getAttribute("endDate").toString());
                                        composeWbo.setAttribute("isConfigured", usFirstWbo.getAttribute("isConfigured").toString());
                                        composeWbo.setAttribute("equipmentId", eqID);
                                        composeWbo.setAttribute("unitName", equipWbo.getAttribute("unitName").toString());
                                        composeWbo.setAttribute("desc", equipWbo.getAttribute("desc").toString());
                                        composeWbo.setAttribute("site", equipWbo.getAttribute("site").toString());

                                    }
                                    // Get Issues
                                    // servedPage = "/docs/issue/issue_listing.jsp";
                                    session = request.getSession(true);
                                    Vector issueList = new Vector();
                                    WebBusinessObject unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(composeWbo.getAttribute("id").toString());
                                    unitWbo = (WebBusinessObject) unit.getOnSingleKey(eqID);
                                    String unit_Name = unitWbo.getAttribute("unitName").toString();
                                    String title = unitScheduleWbo.getAttribute("maintenanceTitle").toString();

                                    IssueEquipmentMgr issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                                    //   if (null == filterValue) {
//                                        filterValue = new Long(dropdownDate.getDate(composeWbo.getAttribute("beginDate").toString()).getTime()).toString() + ":" + new Long(dropdownDate.getDate(composeWbo.getAttribute("endDate").toString()).getTime()).toString() + ">" + eqID + "<ALL";

                                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
                                    dateParser = new DateParser();

                                    filterValue = new Long(dateParser.getSqlTimeStampDate(composeWbo.getAttribute("beginDate").toString(), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(composeWbo.getAttribute("endDate").toString(), jsDateFormat).getTime()).toString() + ">" + eqID + "<ALL";

                                    //    }
                                    maintainableMgr = MaintainableMgr.getInstance();
                                    servedPage = "/docs/issue/schedule_issue_report.jsp";
                                    issueEquipmentMgr.setUser((WebBusinessObject) request.getSession().getAttribute("loggedUser"));
                                    issueList = issueEquipmentMgr.getIssuesInRangeByTitle("ListEqpByTitle", filterValue, title);
                                    ComplexIssueMgr complexIssueMgr = ComplexIssueMgr.getInstance();
                                    Vector checkIsCmplx = new Vector();
                                    for (int i = 0; i < issueList.size(); i++) {
                                        WebBusinessObject issueWbo = (WebBusinessObject) issueList.get(i);
                                        WebIssue webIssue = (WebIssue) issueWbo;
                                        if (!webIssue.getAttribute("issueTitle").toString().equalsIgnoreCase(title)) {
                                            issueList.remove(i);
                                        }
                                        try {
                                            checkIsCmplx = complexIssueMgr.getOnArbitraryKey(issueWbo.getAttribute("id").toString(), "key1");
                                            if (checkIsCmplx.size() > 0) {
                                                issueWbo.setAttribute("issueType", "cmplx");
                                            } else {
                                                issueWbo.setAttribute("issueType", "normal");
                                            }
                                            eqpWbo = maintainableMgr.getOnSingleKey(issueWbo.getAttribute("unitId").toString());
                                            issueWbo.setAttribute("unitName", eqpWbo.getAttribute("unitName").toString());
                                        } catch (Exception e) {
                                        }
                                    }

                                    request.getSession().setAttribute("beginDate", composeWbo.getAttribute("beginDate").toString());
                                    request.getSession().setAttribute("endDate", composeWbo.getAttribute("endDate").toString());
                                    request.getSession().setAttribute("planUnitId", eqID);
                                    request.getSession().setAttribute("planType", "future");

                                    request.setAttribute("filterName", "All");
                                    request.setAttribute("filterValue", filterValue);
                                    request.setAttribute("data", issueList);
                                    request.setAttribute("beginDate", composeWbo.getAttribute("beginDate").toString());
                                    request.setAttribute("endDate", composeWbo.getAttribute("endDate").toString());
                                    request.setAttribute("page", servedPage);
                                    request.setAttribute("status", "ALL");
                                    request.setAttribute("UnitName", unit_Name);
                                    request.setAttribute("Title", title);
                                    request.setAttribute("eqWbo", unitWbo);
                                    request.setAttribute("scheduleId", scheduleId);
                                    this.forwardToServedPage(request, response);
                                    break;

                                    /**
                                     * ****************End*****************
                                     */
                                }
                            }
//                        }
                        }
//                    }
                    } catch (Exception ex) {
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }
                    request.setAttribute("status", machineStatus);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 91:

                    String taskName = (String) request.getParameter("taskName");
                    String formName = (String) request.getParameter("formName");
                    String taskCode = (String) request.getParameter("taskCode");
                    String url = "ScheduleServlet?op=listTasks&formName=" + formName;
                    int count = 0;

                    TaskMgr taskMgr = TaskMgr.getInstance();
                    tasks = new Vector();

                    if (taskName != null && !taskName.equals("")) {
                        String[] codeName = taskName.split(",");
                        taskName = "";
                        for (int i = 0; i < codeName.length; i++) {
                            char tempCh = (char) new Integer(codeName[i]).intValue();
                            taskName += tempCh;
                        }
                    }

                    try {
                        if (taskName != null && !taskName.equals("")) {
                            tasks = taskMgr.getTasksBySubName(taskName, "name");
                        } else if (taskCode != null && !taskCode.equals("")) {
                            tasks = taskMgr.getTasksBySubName(taskCode, "code");
                        } else {
                            taskMgr.cashData();
                            tasks = taskMgr.getCashedTable();
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(TaskServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    String tempcount = request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    tradeMgr = TradeMgr.getInstance();

                    Vector subTasks = new Vector();
                    wbo = new WebBusinessObject();
                    WebBusinessObject wboTrade = new WebBusinessObject();
                    maintainableMgr = MaintainableMgr.getInstance();
                    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();

                    String job = "";
                    wbo = new WebBusinessObject();
                    String equipType = "";
                    int index = (count + 1) * 10;
                    String id = "";
                    if (tasks.size() < index) {
                        index = tasks.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) tasks.get(i);
                        wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("trade").toString());
                        if (wboTrade != null) {
                            job = wboTrade.getAttribute("tradeName").toString();
                            wbo.setAttribute("trade", job);
                            if (wbo.getAttribute("isMain").toString().equalsIgnoreCase("no")) {
                                String parentID = wbo.getAttribute("parentUnit").toString();
                                WebBusinessObject wboEquipType = maintainableMgr.getOnSingleKey(parentID);
                                equipType = wboEquipType.getAttribute("unitName").toString();
                            } else {
                                mainTypeId = wbo.getAttribute("mainTypeId").toString();
                                WebBusinessObject wboEquipType = mainCategoryTypeMgr.getOnSingleKey(mainTypeId);
                                equipType = wboEquipType.getAttribute("typeName").toString();
                            }
                            wbo.setAttribute("eqpName", equipType);
                            subTasks.add(wbo);
                        } else {
                            tasks.remove(i);
                            i--;
                        }
                    }

                    float noOfLinks = tasks.size() / 10f;
                    temp = "" + noOfLinks;
                    int intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    int links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    servedPage = "/docs/schedule/tasks_list_popup.jsp";

                    String temRows = request.getParameter("numRows");
                    if (temRows == null || temRows.equalsIgnoreCase("")) {
                        temRows = "" + 0;
                    }

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("taskName", taskName);
                    request.setAttribute("formName", formName);

                    request.setAttribute("numRows", temRows);

                    request.setAttribute("data", subTasks);
                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                    break;

                case 92:

                    ArrayList mainCatTypes = new ArrayList();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    tradeMgr = TradeMgr.getInstance();

                    mainCatTypes = mainCategoryTypeMgr.getCashedTableAsArrayList();

                    ArrayList tradeList = new ArrayList();
                    tradeMgr.cashData();
//                        Vector tradeVec = tradeMgr.getCashedTable();
                    if (userTradesVec.size() > 0) {
                        for (int i = 0; i < userTradesVec.size(); i++) {
                            tradeList.add(userTradesVec.elementAt(i));
                        }
                    }

                    request.setAttribute("data", mainCatTypes);
                    request.setAttribute("tradeList", tradeList);
                    request.setAttribute("Status", request.getParameter("Status"));
                    servedPage = "/docs/schedule/new_scheduleType.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 93:

                    dateAndTime = new DateAndTimeControl();
                    minutes = 0;

                    servedPage = "/docs/schedule/added_schedule.jsp";
                    configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                    schedule = new WebBusinessObject();
                    scheduleID = "";

                    schedule = new WebBusinessObject();
                    schedule = scheduleMgr.formMainCatSchScraping(request);

                    day = (String) request.getParameter("day");
                    hour = (String) request.getParameter("hour");
                    minute = (String) request.getParameter("minute");

                    if (day != null && !day.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfDay(day);
                    }
                    if (hour != null && !hour.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfHour(hour);
                    }
                    if (minute != null && !minute.equals("")) {
                        minutes = minutes + new Integer(minute).intValue();
                    }

                    schedule.setAttribute("duration", "" + minutes);
                    partWbo = new WebBusinessObject();
                    taskWbo = new WebBusinessObject();
                    taskPartsHt = new Hashtable();
                    tasksData = new Vector();
                    itemsMgr = ItemsMgr.getInstance();
                    tempParts = new Vector();
                    composePartsVec = new Vector();

                    Status = scheduleMgr.checkMainTypeTables(schedule.getAttribute("scheduleTitle").toString(), schedule.getAttribute("mainCatTypeId").toString());

                    unitSchedulesVec = new Vector();
                    if (Status == false) {
                        request.setAttribute("Check", "No");
                        this.forward("/ScheduleServlet?op=MainTypeSchForm", request, response);
                    } else {
                        request.setAttribute("Check", "Ok");
                        try {
                            unitSchedulesVec = scheduleMgr.getOnArbitraryDoubleKey(schedule.getAttribute("scheduleTitle").toString(), "key1", schedule.getAttribute("mainCatTypeId").toString(), "key7");

                            if (unitSchedulesVec.size() > 0) {
                                request.setAttribute("Status", "No");
                            } else {
                                scheduleID = scheduleMgr.saveMainTypeSchedule(schedule, session);
                                if (!scheduleID.equalsIgnoreCase("tradeFailure") && scheduleID != null) {
                                    request.setAttribute("Status", "Ok");
                                    tasksCodes = request.getParameterValues("id");
                                    //get task Data to back to Jsp
                                    taskMgr = TaskMgr.getInstance();
                                    if (tasksCodes != null) {
                                        for (int index1 = 0; index1 < tasksCodes.length; index1++) {
                                            taskWbo = new WebBusinessObject();
                                            taskWbo = taskMgr.getOnSingleKey(tasksCodes[index1]);
                                            tasksData.add(taskWbo);
                                        }
                                        scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                                        if (scheduleTasksMgr.saveObject(request, scheduleID)) {
                                            request.setAttribute("Status", "Ok");
                                        } else {
                                            request.setAttribute("Status", "No");
                                        }

                                        /**
                                         * ************Get Parts of Mntnc Item
                                         * and add it to
                                         * schedule*****************
                                         */
                                        configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                        taskParts = new Vector();
                                        taskPartWbo = new WebBusinessObject();
                                        for (int i = 0; i < tasksCodes.length; i++) {
                                            taskParts = new Vector();
                                            composePartsVec = new Vector();
                                            taskParts = configTasksPartsMgr.getOnArbitraryKey(tasksCodes[i], "key1");

                                            for (int c = 0; c < taskParts.size(); c++) {
                                                taskPartWbo = new WebBusinessObject();
                                                taskPartWbo = (WebBusinessObject) taskParts.get(c);

                                                tempParts = new Vector();
                                                String itemCode = taskPartWbo.getAttribute("itemId").toString();
                                                itemCode = itemCode.substring(4, itemCode.length());
                                                tempParts = itemsMgr.getOnArbitraryKey(itemCode, "key3");
                                                if (tempParts.size() > 0) {
                                                    partWbo = (WebBusinessObject) tempParts.get(0);
                                                    composePartsVec.add(partWbo); //compose Vec of wbo of parts related to tasks
                                                }

                                                hashConfig = new Hashtable();
                                                hashConfig.put("scheduleId", scheduleID);
                                                hashConfig.put("itemID", taskPartWbo.getAttribute("itemId").toString());
                                                hashConfig.put("itemQuantity", taskPartWbo.getAttribute("itemQuantity").toString());
                                                hashConfig.put("itemPrice", taskPartWbo.getAttribute("itemPrice").toString());
                                                hashConfig.put("totalCost", taskPartWbo.getAttribute("totalCost").toString());
                                                hashConfig.put("note", taskPartWbo.getAttribute("note").toString());
                                                try {
                                                    configureMainTypeMgr.saveObject(hashConfig, session);
                                                    request.setAttribute("Status", "OK");
                                                } catch (Exception ex) {
                                                    System.out.println("General Exception:" + ex.getMessage());
                                                }
                                            }
                                            //set task with it's parts
                                            taskPartsHt.put(tasksCodes[i], composePartsVec);
                                        }
                                    }

                                    String mainCatTypeId = (String) schedule.getAttribute("mainCatTypeId");
                                    schWbo = scheduleMgr.getOnSingleKey(scheduleID);

                                    if (!mainCatTypeId.equals("") && mainCatTypeId != null) {
                                        mode = (String) request.getSession().getAttribute("currentMode");
                                        // Activate Schedule Side Menu
                                        Tools.ActivateScheduleSideMenu(request, mainCatTypeId, scheduleID, "mc", mode);
                                    }

                                } else {
                                    request.setAttribute("Status", "No");
                                    if (scheduleID.equalsIgnoreCase("tradeFailure")) {
                                        request.setAttribute("Status", "tradeFailure");
                                    }

                                    this.forward("/ScheduleServlet?op=MainTypeSchForm&Status=tradeFailure", request, response);
                                }
                            }
                        } catch (SQLException SQLex) {
                            System.out.println("Schedule Servlet: save schedule sql " + SQLex.getMessage());

                            if (scheduleID.equalsIgnoreCase("tradeFailure")) {
                                request.setAttribute("Status", "tradeFailure");
                            }

                            this.forward("/ScheduleServlet?op=MainTypeSchForm", request, response);

                        } catch (Exception ex) {
                            System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());

                            if (scheduleID.equalsIgnoreCase("tradeFailure")) {
                                request.setAttribute("Status", "tradeFailure");
                            }

                            this.forward("/ScheduleServlet?op=MainTypeSchForm", request, response);
                        }
                        schedule = scheduleMgr.getOnSingleKey(scheduleID);
                        configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                        itemList = configureMainTypeMgr.getConfigItemBySchedule(scheduleID);
                        request.setAttribute("data", itemList);
                        request.setAttribute("schedule", schedule);
                        request.setAttribute("scheduleId", scheduleID);
                        request.setAttribute("source", request.getParameter("source"));
                        request.setAttribute("tasks", tasksData);
                        request.setAttribute("taskPartsHt", taskPartsHt);
                        scheduleDocMgr = ScheduleDocMgr.getInstance();
                        docsList = scheduleDocMgr.getListOnLIKE("ListDoc", scheduleID);
                        request.setAttribute("docData", docsList);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }

                    break;

                case 94:
                    servedPage = "/docs/schedule/bind_schedule_mainCatType.jsp";

                    Vector mainCatsTypeVec = new Vector();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    schedulesVector = new Vector();
                    unitsVector = new Vector();

                    scheduleUnitsVector = new Vector();
                    nonScheduleUnitsVector = new Vector();
                    configuredScheduleVector = new Vector();

                    sSchedule = new Vector();

                    try {
                        //Variables Definitions.
                        WebBusinessObject mainCatTypeWbo = null;

                        //Get All Equipment Cats.
                        mainCategoryTypeMgr.cashData();
                        mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();

                        if (request.getParameter("eqpMainCat") == null) {
                            if (mainCatsTypeVec.size() > 0) {
                                //Select The first equipment Category in the list.
                                mainCatTypeWbo = (WebBusinessObject) mainCatsTypeVec.elementAt(0);
                            }
                        } else {
                            //Select the one that came from the JSP.
                            mainCatTypeWbo = mainCategoryTypeMgr.getOnSingleKey(request.getParameter("eqpMainCat"));
                        }
                        request.setAttribute("SelectedEqpMainCat", mainCatTypeWbo.getAttribute("typeName").toString());

                        //Select schedule for the equipment Category.
                        schedulesVector = scheduleMgr.getMainCatsSchByTrade(userTradesVec, "", mainCatTypeWbo.getAttribute("id").toString());

                        //Select equipments children for the equipment category.
                        String[] values = new String[3];
                        String[] keyes = new String[3];

                        values[0] = "0";
                        values[1] = "1";
                        values[2] = mainCatTypeWbo.getAttribute("id").toString();
                        keyes[0] = "key5";
                        keyes[1] = "key3";
                        keyes[2] = "key10";

                        unitsVector = unit.getOnArbitraryNumberKey(3, values, keyes);

                        if (schedulesVector.size() > 0) {
                            if (request.getParameter("scheduleID") == null) {
                                //Select the first schedule in the list
                                scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                            } else {
                                //Select the schedule that came from jsp.
                                scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                            }

                            //Create Selected Schedule Vector to refine UnitSchedules by it.
                            sSchedule.addElement(scheduleWbo);

                            //Get Schedule Configuration
                            configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                            //Get Scheduled Equipments and Non Scheduled Equipments
                            nonScheduleUnitsVector = (Vector) unitsVector.clone();
                            scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                            request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                        }

                        if ((request.getParameter("scheduleID") == null) || (request.getParameter("equipmentID") == null)) {
                            //Select First Equipment to display its data
                            if (nonScheduleUnitsVector.size() > 0) {
                                machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } else {
                            machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                            request.setAttribute("selectedMachDetails", machineWbo);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    request.setAttribute("eqpMainCat", mainCatsTypeVec);
                    request.setAttribute("schedules", schedulesVector);
                    request.setAttribute("sheduledEqps", scheduleUnitsVector);
                    request.setAttribute("unschedulesEqps", nonScheduleUnitsVector);
                    request.setAttribute("noOfConfigure", new Integer(configuredScheduleVector.size()));
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 95:
                    servedPage = "/docs/schedule/schedule_units_report.jsp";
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();

                    issueMgr = IssueMgr.getInstance();

                    frequency = 0;
                    frequencyType = 0;
                    totalCost = 0;

                    scheduleId = request.getParameter("schedules");
                    scheduleName = null;

                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    scheduleUnit = null;
                    issueDates = new Vector();

                    beginDate = null;
                    endDate = null;

                    saveSchedule = null;

                    try {
                        scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");

                        machineStatus.addElement(request.getParameter("unitName").toString());
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");

                        Vector eqpOpVec = eqpOpMgr.getOnArbitraryKey(request.getParameter("machines"), "key1");
                        WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVec.elementAt(0);
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

                        DateParser dateParser = new DateParser();
                        beginDate = dateParser.formatSqlDate(request.getParameter("bDate"), jsDateFormat);
                        endDate = dateParser.formatSqlDate(request.getParameter("eDate"), jsDateFormat);

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

                            if ((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("odometer") || new Integer(eqpOpWbo.getAttribute("average").toString()).intValue() == 0)) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
                            } else {

                                //Unit_Schedule and Issue
                                issueDates.removeAllElements();

                                if (frequencyType == 0) {
                                    frequency = frequency / new Integer(eqpOpWbo.getAttribute("average").toString()).intValue();
                                    frequencyType = 1;
                                }
                                int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                                if (issueDates.size() == 0) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Please review Task Frequency");
                                } else {
                                    if (issueDates.size() > 15) {
                                        machineStatus.addElement("Failed");
                                        machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                    } else {
                                        for (int j = 0; j < issueDates.size(); j++) {
                                            Calendar c = Calendar.getInstance();
                                            Calendar d = Calendar.getInstance();

                                            c = (Calendar) issueDates.elementAt(j);
                                            if (j < issueDates.size() - 1) {
                                                d = (Calendar) issueDates.elementAt(j + 1);
                                            }

                                            System.out.println("New Date is " + c.getTime().toString());
                                            System.out.println("New End Date is " + d.getTime().toString());

                                            //Saving Schedule_Units
                                            scheduleUnit = new Vector();
                                            scheduleUnit.addElement(request.getParameter("machines"));
                                            scheduleUnit.addElement(request.getParameter("unitName"));
                                            scheduleUnit.addElement(scheduleId);
                                            scheduleUnit.addElement(scheduleName);
                                            scheduleUnit.addElement(new java.sql.Date(c.getTimeInMillis()));
                                            if (j < issueDates.size() - 1) {
                                                scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            } else {
                                                scheduleUnit.addElement(endDate);
                                            }
                                            scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            unitScheduleMgr.saveScheduleUnits(scheduleUnit);

                                            WebBusinessObject wboIssue = new WebBusinessObject();
                                            wboIssue.setAttribute("site", request.getParameter("site").toString());
                                            wboIssue.setAttribute("machine", request.getParameter("unitName").toString());
                                            wboIssue.setAttribute("desc", request.getParameter("desc").toString());
                                            wboIssue.setAttribute("duration", scheduleWbo.getAttribute("duration").toString());
                                            wboIssue.setAttribute("maintenanceTitle", saveSchedule.getAttribute("maintenanceTitle").toString());
                                            wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                                            c.add(Calendar.DAY_OF_MONTH, noOfDays);
                                            wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                                            wboIssue.setAttribute("scheduleUnitID", unitScheduleMgr.getUinqueID());
                                            wboIssue.setAttribute("workTrade", scheduleWbo.getAttribute("workTrade").toString());
                                            wboIssue.setAttribute("eqpId", request.getParameter("machines").toString());
                                            String unitScheduleId = unitScheduleMgr.getUinqueID();
                                            try {
                                                Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");

                                                issueMgr.saveSchedule(wboIssue, request.getSession(), scTasks);
                                                issueMgr.updateConfigureValue(unitScheduleMgr.getUinqueID());
                                                //Update Total cost of issue
                                                issueMgr.updateTotalCost(unitScheduleMgr.getUinqueID(), totalCost);

                                                /**
                                                 * **************** Transfer
                                                 * Schedule Parts To Issues
                                                 * **********************
                                                 */
                                                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                                                Vector schParts = configureMainTypeMgr.getOnArbitraryKey(scheduleId, "key1");

                                                WebBusinessObject schPartWbo = new WebBusinessObject();
                                                String[] quantity = new String[schParts.size()];
                                                String[] price = new String[schParts.size()];
                                                String[] cost = new String[schParts.size()];
                                                String[] note = new String[schParts.size()];
                                                String[] ids = new String[schParts.size()];
                                                String[] attachedOn = new String[schParts.size()];
                                                String isDirectPrch = "";
                                                QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();
                                                for (int i = 0; i < schParts.size(); i++) {
                                                    schPartWbo = new WebBusinessObject();
                                                    schPartWbo = (WebBusinessObject) schParts.get(i);
                                                    quantity[i] = schPartWbo.getAttribute("itemQuantity").toString();
                                                    price[i] = schPartWbo.getAttribute("itemPrice").toString();
                                                    cost[i] = schPartWbo.getAttribute("totalCost").toString();
                                                    note[i] = schPartWbo.getAttribute("note").toString();
                                                    ids[i] = schPartWbo.getAttribute("itemId").toString();
                                                    isDirectPrch = "0";
                                                    attachedOn[i] = "2";
                                                }
                                                QntfMntncMgr.saveObject2(quantity, price, cost, note, ids, unitScheduleId, isDirectPrch, attachedOn, session);

                                                /**
                                                 * **************** End Of
                                                 * Transfer Schedule Parts
                                                 * **********************
                                                 */
                                            } catch (Exception ex) {
                                                logger.error(ex.getMessage());
                                            }
                                        }
                                        machineStatus.addElement("Success");
                                        machineStatus.addElement("Success");
                                    }
                                }
                            }
                        }
//                    }
                    } catch (Exception ex) {
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }

                    request.setAttribute("eqpCat", request.getParameter("eqpMainCat").toString());
                    request.setAttribute("schedules", scheduleId);
                    request.setAttribute("machines", request.getParameter("machines").toString());
                    request.setAttribute("status", machineStatus);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 96:
                    equipments = new Vector();

                    scheduleMgr = ScheduleMgr.getInstance();
                    vecTotals = scheduleMgr.getScheduleCountByMainCat();
                    hashtable = new Hashtable();

                    for (int i = 0; i < vecTotals.size(); i++) {
                        WebBusinessObject wboTemp = (WebBusinessObject) vecTotals.get(i);
                        hashtable.put(wboTemp.getAttribute("mainCatTypeId"), wboTemp.getAttribute("frequency"));
                    }

                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainCategoryTypeMgr.cashData();
                    mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();

//                        maintenableUnit = MaintainableMgr.getInstance();
//                        maintenableUnit.cashData();
//                        equipments = maintenableUnit.getAllCategoryEqu();
                    servedPage = "/docs/schedule/schedule_by_maincat_list.jsp";

                    request.setAttribute("data", mainCatsTypeVec);
                    request.setAttribute("hashtable", hashtable);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 97:
                    servedPage = "/docs/schedule/List_MainCat_schs.jsp";

                    mainCatsTypeVec = new Vector();
                    schedulesVec = new Vector();
                    String mainCatName = "";
                    String mainCatId = "";
                    WebBusinessObject mainCatWbo = new WebBusinessObject();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();

                    mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();

                    try {
                        if (mainCatsTypeVec.size() > 0) {
                            if (request.getParameter("mainCatId").toString().equalsIgnoreCase("null")) {
                                mainCatWbo = (WebBusinessObject) mainCatsTypeVec.elementAt(0);
                                mainCatId = mainCatWbo.getAttribute("id").toString();
                                mainCatName = mainCatWbo.getAttribute("typeName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(mainCatId, "key7", "mainCat", "key5");
                            } else {
                                mainCatId = request.getParameter("mainCatId").toString();

                                mainCatWbo = mainCategoryTypeMgr.getOnSingleKey(mainCatId);
                                mainCatName = mainCatWbo.getAttribute("typeName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(mainCatId, "key7", "mainCat", "key5");
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Schedule Listing Exception = " + ex.getMessage());
                    }

                    request.setAttribute("mainCatId", mainCatId);
                    request.setAttribute("mainCatsTypeVec", mainCatsTypeVec);
                    request.setAttribute("mainCatSchList", schedulesVec);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("mainCatName", mainCatName);
                    request.setAttribute("backTo", request.getQueryString());
                    this.forwardToServedPage(request, response);
                    break;

                case 98:
                    servedPage = "/docs/schedule/assign_mainCat_sch_to_eqp.jsp";

                    MainCategoryTypeMgr mainCatTypeMgr = MainCategoryTypeMgr.getInstance();
                    maintainableMgr = MaintainableMgr.getInstance();

                    mainCatWbo = new WebBusinessObject();
                    WebBusinessObject parentWbo = new WebBusinessObject();
                    schWbo = new WebBusinessObject();
                    Vector mainCatEqps = new Vector();
                    scheduleUnitsVector = new Vector();
                    nonScheduleUnitsVector = new Vector();
                    configuredScheduleVector = new Vector();
                    sSchedule = new Vector();
                    mainCatId = "";
                    String catId = "";

                    scheduleMgr = ScheduleMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    locationWbo = new WebBusinessObject();

                    scheduleId = request.getParameter("periodicID");
                    schWbo = scheduleMgr.getOnSingleKey(scheduleId);
                    String scheduledOn = (String) schWbo.getAttribute("scheduledOn");

                    String keysIndex[] = new String[3];
                    keysIndex[0] = "key5";
                    keysIndex[1] = "key3";

                    String keysValues[] = new String[3];
                    keysValues[0] = "0";
                    keysValues[1] = "1";

                    if (scheduledOn.equalsIgnoreCase("mainCat")) {
                        mainCatId = (String) schWbo.getAttribute("mainCatTypeId");
                        mainCatWbo = mainCatTypeMgr.getOnSingleKey(mainCatId);
                        keysIndex[2] = "key10";
                        keysValues[2] = mainCatId;
                        request.setAttribute("mainCatWbo", mainCatWbo);
                    } else if (scheduledOn.equalsIgnoreCase("Cat")) {
                        catId = (String) schWbo.getAttribute("equipmentCatID");
                        parentWbo = maintainableMgr.getOnSingleKey(catId);
                        keysIndex[2] = "key1";
                        keysValues[2] = catId;
                        request.setAttribute("parentWbo", parentWbo);
                    }

                    mainCatEqps = maintainableMgr.getEquipByCheckUser(3, keysValues, keysIndex, session);

                    sSchedule.addElement(schWbo);

                    //Get Scheduled Equipments and Non Scheduled Equipments
                    nonScheduleUnitsVector = (Vector) mainCatEqps.clone();
                    scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                    //Get Schedule Configuration
                    configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) schWbo.getAttribute("periodicID"), "key1");

                    request.setAttribute("sheduledEqps", scheduleUnitsVector);
                    request.setAttribute("unschedulesEqps", nonScheduleUnitsVector);
                    request.setAttribute("noOfConfigure", new Integer(configuredScheduleVector.size()));

                    request.setAttribute("schWbo", schWbo);
                    request.setAttribute("mainCatEqps", mainCatEqps);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 99:
                    servedPage = "/docs/schedule/assign_MainCatSch_toEqp_result.jsp";
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();

                    issueMgr = IssueMgr.getInstance();

                    frequency = 0;
                    frequencyType = 0;
                    totalCost = 0;

                    scheduleId = request.getParameter("scheduleId");
                    scheduleName = null;

                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    scheduleUnit = null;
                    issueDates = new Vector();

                    beginDate = null;
                    endDate = null;

                    saveSchedule = null;

                    try {
                        scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");

                        machineStatus.addElement(request.getParameter("unitName").toString());
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");

                        Vector eqpOpVec = eqpOpMgr.getOnArbitraryKey(request.getParameter("machineId"), "key1");
                        WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVec.elementAt(0);
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machineId"));

                        DateParser dateParser = new DateParser();
                        beginDate = dateParser.formatSqlDate(request.getParameter("bDate"), jsDateFormat);
                        endDate = dateParser.formatSqlDate(request.getParameter("eDate"), jsDateFormat);

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

                            if ((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("odometer") || new Integer(eqpOpWbo.getAttribute("average").toString()).intValue() == 0)) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
                            } else {

                                //Unit_Schedule and Issue
                                issueDates.removeAllElements();

                                if (frequencyType == 0) {
                                    frequency = frequency / new Integer(eqpOpWbo.getAttribute("average").toString()).intValue();
                                    frequencyType = 1;
                                }
                                int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                                if (issueDates.size() == 0) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Please review Task Frequency");
                                } else {
                                    if (issueDates.size() > 15) {
                                        machineStatus.addElement("Failed");
                                        machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                    } else {
                                        for (int j = 0; j < issueDates.size(); j++) {
                                            Calendar c = Calendar.getInstance();
                                            Calendar d = Calendar.getInstance();

                                            c = (Calendar) issueDates.elementAt(j);
                                            if (j < issueDates.size() - 1) {
                                                d = (Calendar) issueDates.elementAt(j + 1);
                                            }

                                            System.out.println("New Date is " + c.getTime().toString());
                                            System.out.println("New End Date is " + d.getTime().toString());

                                            //Saving Schedule_Units
                                            scheduleUnit = new Vector();
                                            scheduleUnit.addElement(request.getParameter("machineId"));
                                            scheduleUnit.addElement(request.getParameter("unitName"));
                                            scheduleUnit.addElement(scheduleId);
                                            scheduleUnit.addElement(scheduleName);
                                            scheduleUnit.addElement(new java.sql.Date(c.getTimeInMillis()));
                                            if (j < issueDates.size() - 1) {
                                                scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            } else {
                                                scheduleUnit.addElement(endDate);
                                            }
                                            scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                            unitScheduleMgr.saveScheduleUnits(scheduleUnit);

                                            WebBusinessObject wboIssue = new WebBusinessObject();
                                            wboIssue.setAttribute("site", request.getParameter("site").toString());
                                            wboIssue.setAttribute("machine", request.getParameter("unitName").toString());
                                            wboIssue.setAttribute("desc", request.getParameter("desc").toString());
                                            wboIssue.setAttribute("duration", scheduleWbo.getAttribute("duration").toString());
                                            wboIssue.setAttribute("maintenanceTitle", saveSchedule.getAttribute("maintenanceTitle").toString());
                                            wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                                            c.add(Calendar.DAY_OF_MONTH, noOfDays);
                                            wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                                            wboIssue.setAttribute("scheduleUnitID", unitScheduleMgr.getUinqueID());
                                            wboIssue.setAttribute("workTrade", scheduleWbo.getAttribute("workTrade").toString());
                                            wboIssue.setAttribute("eqpId", request.getParameter("machineId").toString());

                                            String unitScheduleId = unitScheduleMgr.getUinqueID();
                                            try {
                                                Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");

                                                issueMgr.saveSchedule(wboIssue, request.getSession(), scTasks);
                                                issueMgr.updateConfigureValue(unitScheduleMgr.getUinqueID());
                                                //Update Total cost of issue
                                                issueMgr.updateTotalCost(unitScheduleMgr.getUinqueID(), totalCost);

                                                /**
                                                 * **************** Transfer
                                                 * Schedule Parts To Issues
                                                 * **********************
                                                 */
                                                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                                                Vector schParts = configureMainTypeMgr.getOnArbitraryKey(scheduleId, "key1");

                                                WebBusinessObject schPartWbo = new WebBusinessObject();
                                                String[] quantity = new String[schParts.size()];
                                                String[] price = new String[schParts.size()];
                                                String[] cost = new String[schParts.size()];
                                                String[] note = new String[schParts.size()];
                                                String[] ids = new String[schParts.size()];
                                                String[] attachedOn = new String[schParts.size()];
                                                String isDirectPrch = "";
                                                QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();
                                                for (int i = 0; i < schParts.size(); i++) {
                                                    schPartWbo = new WebBusinessObject();
                                                    schPartWbo = (WebBusinessObject) schParts.get(i);
                                                    quantity[i] = schPartWbo.getAttribute("itemQuantity").toString();
                                                    price[i] = schPartWbo.getAttribute("itemPrice").toString();
                                                    cost[i] = schPartWbo.getAttribute("totalCost").toString();
                                                    note[i] = schPartWbo.getAttribute("note").toString();
                                                    ids[i] = schPartWbo.getAttribute("itemId").toString();
                                                    isDirectPrch = "0";
                                                    attachedOn[i] = "2";
                                                }
                                                QntfMntncMgr.saveObject2(quantity, price, cost, note, ids, unitScheduleId, isDirectPrch, attachedOn, session);

                                                /**
                                                 * **************** End Of
                                                 * Transfer Schedule Parts
                                                 * **********************
                                                 */
                                            } catch (Exception ex) {
                                                logger.error(ex.getMessage());
                                            }
                                        }
                                        machineStatus.addElement("Success");
                                        machineStatus.addElement("Success");
                                    }
                                }
                            }
                        }
//                    }
                    } catch (Exception ex) {
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }

                    request.setAttribute("bDate", request.getParameter("bDate"));
                    request.setAttribute("eDate", request.getParameter("eDate"));

//                        request.setAttribute("mainCatId", request.getParameter("eqpMainCat").toString());
                    request.setAttribute("schId", scheduleId);
                    request.setAttribute("eqpId", request.getParameter("machineId").toString());
                    request.setAttribute("status", machineStatus);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 100:

                    Vector issueList = null;
                    IssueEquipmentMgr issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                    servedPage = "/docs/schedule/schedule_plan_result.jsp";

                    WebBusinessObject parameters = new WebBusinessObject();

                    String eqpId = (String) request.getParameter("eqpId");
                    String schId = (String) request.getParameter("schId");
                    String bDate = (String) request.getParameter("bDate");
                    String eDate = (String) request.getParameter("eDate");

                    parameters.setAttribute("eqpId", eqpId);
                    parameters.setAttribute("schId", schId);
                    parameters.setAttribute("beginDate", bDate);
                    parameters.setAttribute("endDate", eDate);

                    try {

                        issueList = issueEquipmentMgr.getIssueBySchAndEqp(parameters, session);

                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    WebBusinessObject eqWbo = maintainableMgr.getOnSingleKey(eqpId);

                    request.getSession().setAttribute("planUnitId", eqpId);
                    request.getSession().setAttribute("beginDate", request.getParameter("bDate").toString());
                    request.getSession().setAttribute("endDate", request.getParameter("eDate").toString());
                    request.getSession().setAttribute("planType", "future");

                    request.setAttribute("data", issueList);
                    request.setAttribute("scheduleId", schId);
                    request.setAttribute("unitId", eqpId);
                    request.setAttribute("beginDate", request.getParameter("bDate").toString());
                    request.setAttribute("endDate", request.getParameter("eDate").toString());
                    request.setAttribute("page", servedPage);
                    request.setAttribute("eqWbo", eqWbo);
                    this.forward(servedPage, request, response);
                    break;

                case 101:

                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();

//                        servedPage = "/docs/schedule/extent_schedule_report.jsp";
                    servedPage = "/docs/schedule/assign_MainCatSch_toEqp_result.jsp";

                    eqpCatConfig = ConfigureMainTypeMgr.getInstance();
                    issueMgr = IssueMgr.getInstance();

                    totalCost = 0;

                    scheduleId = request.getParameter("scheduleID");
                    equipmentID = request.getParameter("equipmentID");

                    vecUnitSchedule = unitScheduleMgr.getLastUnitSchedule(scheduleId, equipmentID);
                    wboUnitSchedule = new WebBusinessObject();
                    if (vecUnitSchedule.size() > 0) {
                        wboUnitSchedule = (WebBusinessObject) vecUnitSchedule.get(0);
                    }
                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    issueDates = new Vector();
                    String beginDateOfPlan = null;
                    eDate = null;

                    try {
                        scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");

                        machineStatus.addElement(request.getParameter("unitName").toString());
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");

                        Vector eqpOpVec = eqpOpMgr.getOnArbitraryKey(request.getParameter("machines"), "key1");
                        WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVec.elementAt(0);
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

                        String tempDate = (String) wboUnitSchedule.getAttribute("endDate");
                        beginDate = new java.sql.Date(new Integer(tempDate.substring(0, 4)).intValue() - 1900, new Integer(tempDate.substring(5, 7)).intValue() - 1, new Integer(tempDate.substring(8)).intValue());
                        String indexStr = (String) request.getParameter("index");

                        DateParser dateParser = new DateParser();

                        eDate = request.getParameter("exDate" + indexStr);
                        beginDateOfPlan = request.getParameter("exBDate" + indexStr);

                        endDate = dateParser.formatSqlDate(eDate, jsDateFormat);

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

                            if ((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("odometer") || new Integer(eqpOpWbo.getAttribute("average").toString()).intValue() == 0)) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
                            } else {
                                issueDates.removeAllElements();

                                if (frequencyType == 0) {
                                    frequency = frequency / new Integer(eqpOpWbo.getAttribute("average").toString()).intValue();
                                    frequencyType = 1;
                                }
                                int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                                if (issueDates.size() > 15) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                } else {
                                    for (int j = 0; j < issueDates.size(); j++) {
                                        Calendar c = Calendar.getInstance();
                                        Calendar d = Calendar.getInstance();

                                        c = (Calendar) issueDates.elementAt(j);
                                        if (j < issueDates.size() - 1) {
                                            d = (Calendar) issueDates.elementAt(j + 1);
                                        }

                                        System.out.println("New Date is " + c.getTime().toString());
                                        System.out.println("New End Date is " + d.getTime().toString());

                                        //Saving Schedule_Units
                                        scheduleUnit = new Vector();
                                        scheduleUnit.addElement(request.getParameter("machines"));
                                        scheduleUnit.addElement(request.getParameter("unitName"));
                                        scheduleUnit.addElement(scheduleId);
                                        scheduleUnit.addElement(scheduleName);
                                        scheduleUnit.addElement(new java.sql.Date(c.getTimeInMillis()));
                                        if (j < issueDates.size() - 1) {
                                            scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                        } else {
                                            scheduleUnit.addElement(endDate);
                                        }
                                        scheduleUnit.addElement(new java.sql.Date(d.getTimeInMillis()));
                                        unitScheduleMgr.saveScheduleUnits(scheduleUnit);

                                        WebBusinessObject wboIssue = new WebBusinessObject();
                                        wboIssue.setAttribute("site", request.getParameter("site").toString());
                                        wboIssue.setAttribute("machine", request.getParameter("unitName").toString());
                                        wboIssue.setAttribute("desc", request.getParameter("desc").toString());
                                        wboIssue.setAttribute("duration", scheduleWbo.getAttribute("duration").toString());
                                        wboIssue.setAttribute("maintenanceTitle", saveSchedule.getAttribute("maintenanceTitle").toString());
                                        wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                                        c.add(Calendar.DAY_OF_MONTH, noOfDays);
                                        wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                                        wboIssue.setAttribute("scheduleUnitID", unitScheduleMgr.getUinqueID());
                                        wboIssue.setAttribute("workTrade", saveSchedule.getAttribute("workTrade").toString());
                                        wboIssue.setAttribute("eqpId", equipmentID);

                                        try {
                                            Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");

                                            issueMgr.saveSchedule(wboIssue, request.getSession(), scTasks);
                                            issueMgr.updateConfigureValue(unitScheduleMgr.getUinqueID());
                                            //Update Total cost of issue
                                            issueMgr.updateTotalCost(unitScheduleMgr.getUinqueID(), totalCost);
                                        } catch (Exception ex) {
                                            System.out.print("Saving Extend Schedule Error " + ex.getMessage());
                                            logger.error(ex.getMessage());
                                        }
                                    }
                                    machineStatus.addElement("Success");
                                    machineStatus.addElement("Success");
                                }
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Extend Schedule Error " + ex.getMessage());
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }

//                        request.setAttribute("mainCatId", request.getParameter("eqpMainCat").toString());
                    request.setAttribute("schId", scheduleId);
                    request.setAttribute("eqpId", equipmentID);
                    request.setAttribute("bDate", beginDateOfPlan.replaceAll("-", "/"));
                    request.setAttribute("eDate", eDate);

                    request.setAttribute("status", machineStatus);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 102:

                    scheduleName = (String) request.getParameter("scheduleName");
                    formName = (String) request.getParameter("formName");
                    schedules = new Vector();
                    count = 0;
                    url = "ScheduleServlet?op=searchSchBySubNamePopup";
                    scheduleMgr = ScheduleMgr.getInstance();

                    if (scheduleName != null && !scheduleName.equals("")) {
                        String[] partsArr = scheduleName.split(",");
                        scheduleName = "";
                        for (int i = 0; i < partsArr.length; i++) {
                            char temp1 = (char) new Integer(partsArr[i]).intValue();
                            scheduleName += temp1;
                        }
                    }

                    try {
                        if (scheduleName != null && !scheduleName.equals("")) {

                            schedules = scheduleMgr.getSchBySubName(scheduleName);

                        } else {

                            scheduleMgr.cashData();
                            schedules = scheduleMgr.getCashedTable();

                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ScheduleServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    Vector subSchedules = new Vector();
                    wbo = new WebBusinessObject();
                    index = (count + 1) * 10;
                    id = "";

                    if (schedules.size() < index) {
                        index = schedules.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) schedules.get(i);
                        subSchedules.add(wbo);
                    }

                    noOfLinks = schedules.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    servedPage = "/docs/schedule/list_schedules.jsp";

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("scheduleName", scheduleName);
                    request.setAttribute("formName", formName);

                    request.setAttribute("data", subSchedules);
                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                    break;

                case 103:
                    periodicID = request.getParameter("periodicID");
                    scheduleMgr.deleteSchedule(periodicID);

                    servedPage = "/docs/schedule/List_all_eqp_schedules.jsp";

                    equipmentsVec = new Vector();
                    schedulesVec = new Vector();

                    equipmentID = "";
                    equipmentCatName = "";

                    eqpWbo = null;

                    try {
                        schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(request.getParameter("equipmentID"), "key2", "Eqp", "key5");
                    } catch (Exception ex) {
                        System.out.println("Schedule Listing Exception = " + ex.getMessage());
                    }

                    request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                    request.setAttribute("equipSchedules", schedulesVec);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("equipCatName", equipmentCatName);

                    this.forwardToServedPage(request, response);
                    break;

                case 106:

                    formName = request.getParameter("formName");
                    Vector Codes = new Vector();
                    ViewTableMgr view = ViewTableMgr.getInstance();
                    Codes = view.getMainTypesTables("mainCat");
                    url = "ScheduleServlet?op=SearchTables";

                    //mn awl hena elpaging
                    count = 0;
                    Vector subIssueList = new Vector();
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
                    index = (count + 1) * 10;
                    if (Codes.size() < index) {
                        index = Codes.size();
                    }

                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) Codes.get(i);
                        subIssueList.add(wbo);
                    }
                    noOfLinks = Codes.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    String lastFilter = "ScheduleServlet?op=SearchTables";
                    session.setAttribute("lastFilter", lastFilter);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("data", subIssueList);
                    request.setAttribute("formName", formName);
                    request.setAttribute("codes", Codes);
                    servedPage = "/docs/Adminstration/list_Tables.jsp";
                    this.forward(servedPage, request, response);
                    break;

                case 107:

                    formName = request.getParameter("formName");
                    Codes = new Vector();
                    view = ViewTableMgr.getInstance();
                    Codes = view.getEquipTables("Eqp");
                    url = "ScheduleServlet?op=SearchTablesEquip";

                    //mn awl hena elpaging
                    count = 0;
                    subIssueList = new Vector();
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
                    index = (count + 1) * 10;
                    if (Codes.size() < index) {
                        index = Codes.size();
                    }

                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) Codes.get(i);
                        subIssueList.add(wbo);
                    }
                    noOfLinks = Codes.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = "ScheduleServlet?op=SearchTablesEquip";
                    session.setAttribute("lastFilter", lastFilter);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("data", subIssueList);
                    request.setAttribute("formName", formName);
                    request.setAttribute("codes", Codes);
                    servedPage = "/docs/Adminstration/list_Tables_Equip.jsp";
                    this.forward(servedPage, request, response);
                    break;

                case 108:
                    formName = request.getParameter("formName");
                    String name = (String) request.getParameter("name");
                    if (name != null && !name.equals("")) {
                        String[] parts = name.split(",");
                        name = "";
                        for (int i = 0; i < parts.length; i++) {
                            char c = (char) new Integer(parts[i]).intValue();
                            name += c;
                        }
                    }
                    Codes = new Vector();
                    MaintainableMgr maint = maintainableMgr.getInstance();
                    Codes = maint.getAllParents(name);
                    url = "ScheduleServlet?op=SearchEquip";

                    //mn awl hena elpaging
                    count = 0;
                    subIssueList = new Vector();
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
                    index = (count + 1) * 10;
                    if (Codes.size() < index) {
                        index = Codes.size();
                    }

                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) Codes.get(i);
                        subIssueList.add(wbo);
                    }
                    noOfLinks = Codes.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = "ScheduleServlet?op=SearchEquip";
                    session.setAttribute("lastFilter", lastFilter);
                    request.setAttribute("name", name);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("data", subIssueList);
                    request.setAttribute("formName", formName);
                    request.setAttribute("codes", Codes);
                    servedPage = "/docs/Adminstration/list_Equip.jsp";
                    this.forward(servedPage, request, response);
                    break;

                case 109:

                    formName = request.getParameter("formName");
                    Codes = new Vector();
                    unitId = (String) request.getParameter("unitId");
                    scheduleMgr = ScheduleMgr.getInstance();
                    Codes = scheduleMgr.getAllReleatedTables(unitId);
                    url = "ScheduleServlet?op=SearchEquipTables";

                    //mn awl hena elpaging
                    count = 0;
                    subIssueList = new Vector();
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
                    index = (count + 1) * 10;
                    if (Codes.size() < index) {
                        index = Codes.size();
                    }

                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) Codes.get(i);
                        subIssueList.add(wbo);
                    }
                    noOfLinks = Codes.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = "ScheduleServlet?op=SearchEquipTables";
                    session.setAttribute("lastFilter", lastFilter);
                    request.setAttribute("TotalTables", "" + Codes.size());
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("data", subIssueList);
                    request.setAttribute("formName", formName);
                    request.setAttribute("codes", Codes);
                    servedPage = "/docs/Adminstration/list_Tablees_Equip.jsp";
                    this.forward(servedPage, request, response);
                    break;

                case 104:

                    periodicID = request.getParameter("periodicID");
                    scheduleMgr.deleteSchedule(periodicID);

                    servedPage = "/docs/schedule/List_MainCat_schs.jsp";

                    mainCatsTypeVec = new Vector();
                    schedulesVec = new Vector();
                    mainCatName = "";
                    mainCatId = "";
                    mainCatWbo = new WebBusinessObject();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();

                    mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();

                    try {
                        if (mainCatsTypeVec.size() > 0) {
                            if (request.getParameter("mainCatId").toString().equalsIgnoreCase("null")) {
                                mainCatWbo = (WebBusinessObject) mainCatsTypeVec.elementAt(0);
                                mainCatId = mainCatWbo.getAttribute("id").toString();
                                mainCatName = mainCatWbo.getAttribute("typeName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(mainCatId, "key7", "mainCat", "key5");
                            } else {
                                mainCatId = request.getParameter("mainCatId").toString();

                                mainCatWbo = mainCategoryTypeMgr.getOnSingleKey(mainCatId);
                                mainCatName = mainCatWbo.getAttribute("typeName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(mainCatId, "key7", "mainCat", "key5");
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Schedule Listing Exception = " + ex.getMessage());
                    }

                    request.setAttribute("mainCatId", mainCatId);
                    request.setAttribute("mainCatsTypeVec", mainCatsTypeVec);
                    request.setAttribute("mainCatSchList", schedulesVec);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("mainCatName", mainCatName);

                    this.forwardToServedPage(request, response);
                    break;

                case 105:
                    periodicID = request.getParameter("periodicID");
                    scheduleMgr.deleteSchedule(periodicID);

                    servedPage = "/docs/schedule/List_all_schedules.jsp";

                    equipmentCatsVec = new Vector();
                    schedulesVec = new Vector();
                    equipmentCatID = null;
                    equipmentCatName = "";
                    eqpCatWbo = null;

                    equipmentCatsVec = unit.getAllCategoryEqu();

                    try {
                        if (equipmentCatsVec.size() > 0) {
                            if (request.getParameter("equipmentCat").toString().equalsIgnoreCase("null")) {
                                eqpCatWbo = (WebBusinessObject) equipmentCatsVec.elementAt(0);
                                equipmentCatID = eqpCatWbo.getAttribute("id").toString();
                                equipmentCatName = eqpCatWbo.getAttribute("unitName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(equipmentCatID, "key4", "Cat", "key5");
                            } else {
                                equipmentCatID = request.getParameter("equipmentCat").toString();

                                unitWbo = unit.getOnSingleKey(equipmentCatID);
                                equipmentCatName = unitWbo.getAttribute("unitName").toString();

                                schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(equipmentCatID, "key4", "Cat", "key5");
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Schedule Listing Exception = " + ex.getMessage());
                    }

                    request.setAttribute("equipmentsCatsData", equipmentCatsVec);
                    request.setAttribute("equipCatSchedules", schedulesVec);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("equipCatName", equipmentCatName);

                    this.forwardToServedPage(request, response);
                    break;

                case 110:
                    scheduleId = request.getParameter("scheduleId");
                    scheduleName = request.getParameter("scheduleName");
                    String backTo = request.getParameter("backTo");

                    scheduleName = Tools.getRealChar(scheduleName);

                    servedPage = "/docs/schedule/confirm_delete_schedule.jsp";
                    request.setAttribute("scheduleId", scheduleId);
                    request.setAttribute("scheduleName", scheduleName);
                    request.setAttribute("issueNumber", unitScheduleMgr.getNumberIssues(scheduleId));
                    request.setAttribute("backTo", backTo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 111:
                    scheduleId = request.getParameter("scheduleId");
                    if (scheduleMgr.deleteExactlySchedule(scheduleId)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "no");
                    }

                    servedPage = "ScheduleServlet?op=confirmDeleteSchedule";
                    this.forward(servedPage, request, response);
                    break;

                case 113:
                    servedPage = "/docs/issue/edit_external_order.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 114:
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    WebBusinessObject mainTypeObject = mainCategoryTypeMgr.getOnSingleKey(request.getParameter("mainTypeId"));
                    String rateType = (String) mainTypeObject.getAttribute("basicCounter");
                    response.getWriter().write(rateType);
                    response.getWriter().flush();
                    response.getWriter().close();
                    break;

                case 115:
                    servedPage = "/docs/schedule/List_all.jsp";
                    schedules = new Vector();
                    schedules = scheduleMgr.getAllSchedule();
                    request.setAttribute("data", schedules);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 116:
                    servedPage = "/docs/schedule/new_Time_Equip_Schedule.jsp";
                    schType = "none";
                    userTradesVec = new Vector();
                    userTradesVec = (Vector) loggedUser.getAttribute("userTrade");

                    eqpsVec = new Vector();
                    vecSchedule = new Vector();

                    unitWbo = null;
                    unitName = new String();
                    unitCatID = new String();

                    try {
                        session = request.getSession();

                        eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        if (request.getParameter("unit").equalsIgnoreCase("non")) {
                            if (eqpsVec.size() > 0) {
                                unitWbo = (WebBusinessObject) eqpsVec.elementAt(0);
                            }
                        } else {
                            unitWbo = unit.getOnSingleKey(request.getParameter("unit").toString());
                        }

                        unitName = unitWbo.getAttribute("unitName").toString();
                        unitCatID = unitWbo.getAttribute("parentId").toString();

                        vecSchedule = scheduleMgr.getOnArbitraryDoubleKey("1", "key3", unitWbo.getAttribute("id").toString(), "key2");
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    eqpsArray = new ArrayList();
                    for (int i = 0; i < eqpsVec.size(); i++) {
                        eqpsArray.add(eqpsVec.get(i));
                    }
                    request.setAttribute("equipments", eqpsArray);
                    request.setAttribute("schType", schType);
                    request.setAttribute("data", vecSchedule);
                    request.setAttribute("selectedUnitName", unitName);
                    request.setAttribute("unitCatID", unitCatID);
                    request.setAttribute("tradeVec", userTradesVec);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 117:
                    dateAndTime = new DateAndTimeControl();
                    minutes = 0;
                    schType = request.getParameter("schType");
                    servedPage = "/docs/schedule/added_schedule.jsp";

                    schedule = new WebBusinessObject();
                    scheduleID = new String("");

                    partWbo = new WebBusinessObject();
                    taskWbo = new WebBusinessObject();
                    taskPartsHt = new Hashtable();
                    tasksData = new Vector();
                    itemsMgr = ItemsMgr.getInstance();
                    tempParts = new Vector();
                    composePartsVec = new Vector();

                    schedule = scheduleMgr.formTimeEqpScheduleScraping(request);
                    String measureUnit = "";
                    measureUnit = (String) request.getParameter("measureUnit");

                    day = (String) request.getParameter("day");
                    hour = (String) request.getParameter("hour");
                    minute = (String) request.getParameter("minute");

                    if (day != null && !day.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfDay(day);
                    }
                    if (hour != null && !hour.equals("")) {
                        minutes = minutes + dateAndTime.getMinuteOfHour(hour);
                    }
                    if (minute != null && !minute.equals("")) {
                        minutes = minutes + new Integer(minute).intValue();
                    }
//                        int durationValue=Integer.parseInt(request.getParameter("duration").toString());
//                        if(measureUnit!=null){
//                            if(measureUnit.equalsIgnoreCase("day")){
//                                durationValue*=24;
//                                schedule.setAttribute("duration",""+durationValue);
//                            }
//                        }
                    schedule.setAttribute("duration", "" + minutes);
                    schWbo = new WebBusinessObject();
                    WebBusinessObject schEqWbo = new WebBusinessObject();
                    maintainableMgr = MaintainableMgr.getInstance();

                    try {
                        unitSchedulesVec = scheduleMgr.getOnArbitraryDoubleKey(schedule.getAttribute("scheduleTitle").toString(), "key1", schedule.getAttribute("eqpCatID").toString(), "key2");

                        if (unitSchedulesVec.size() > 0) {
                            request.setAttribute("Status", "No");
                        } else {
                            String pageSource = "";
                            if (request.getParameter("pageSource") != null) {
                                if (request.getParameter("pageSource").equalsIgnoreCase("km")) {
                                    pageSource = "km";
                                } else {
                                    pageSource = "Hr";
                                }
                            }
                            scheduleID = scheduleMgr.saveEquipSchedule(schedule, session, pageSource);
                            if (scheduleID != null) {
                                String eqId = request.getParameter("unitId");
                                schWbo = scheduleMgr.getOnSingleKey(scheduleID);
                                schEqWbo = maintainableMgr.getOnSingleKey(eqId);
//                                    if(!schWbo.getAttribute("frequencyType").toString().equalsIgnoreCase("5")){

                                mode = (String) request.getSession().getAttribute("currentMode");
                                Tools.ActivateScheduleSideMenu(request, eqId, scheduleID, "", mode);

//                                    }
                                request.setAttribute("Status", "Ok");
                                tasksCodes = request.getParameterValues("id");

                                //get task Data to back to Jsp
                                taskMgr = TaskMgr.getInstance();
                                for (index = 0; index < tasksCodes.length; index++) {
                                    taskWbo = new WebBusinessObject();
                                    taskWbo = taskMgr.getOnSingleKey(tasksCodes[index]);
                                    tasksData.add(taskWbo);
                                }

                                if (tasksCodes != null) {
                                    scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                                    if (scheduleTasksMgr.saveObject(request, scheduleID)) {
                                        request.setAttribute("Status", "Ok");
                                    } else {
                                        request.setAttribute("Status", "No");
                                    }

                                    /**
                                     * ************Get Parts of Mntnc Item and
                                     * add it to schedule*****************
                                     */
                                    configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                    taskParts = new Vector();
                                    taskPartWbo = new WebBusinessObject();

                                    DistributedItemsMgr distItemsMgr = DistributedItemsMgr.getInstance();

                                    for (int i = 0; i < tasksCodes.length; i++) {
                                        taskParts = new Vector();
                                        composePartsVec = new Vector();
                                        taskParts = configTasksPartsMgr.getOnArbitraryKey(tasksCodes[i], "key1");

                                        for (int c = 0; c < taskParts.size(); c++) {
                                            taskPartWbo = new WebBusinessObject();
                                            taskPartWbo = (WebBusinessObject) taskParts.get(c);

                                            tempParts = new Vector();
                                            WebBusinessObject item = itemsMgr.getOnSingleKey(taskPartWbo.getAttribute("itemId").toString());

                                            composePartsVec.add(item);
//                                        tempParts=itemsMgr.getOnArbitraryKey(taskPartWbo.getAttribute("itemId").toString(),"key3");
//                                        if(tempParts.size()>0){
//                                            partWbo=(WebBusinessObject)tempParts.get(0);
//                                            composePartsVec.add(partWbo); //compose Vec of wbo of parts related to tasks
//                                        }
                                            configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                                            hashConfig = new Hashtable();
                                            hashConfig.put("scheduleId", scheduleID);
                                            hashConfig.put("itemID", taskPartWbo.getAttribute("itemId").toString());
                                            hashConfig.put("itemQuantity", taskPartWbo.getAttribute("itemQuantity").toString());
                                            hashConfig.put("itemPrice", taskPartWbo.getAttribute("itemPrice").toString());
                                            hashConfig.put("totalCost", taskPartWbo.getAttribute("totalCost").toString());
                                            hashConfig.put("note", taskPartWbo.getAttribute("note").toString());
                                            try {
                                                configureMainTypeMgr.saveObject(hashConfig, session);
                                                request.setAttribute("Status", "OK");
                                            } catch (Exception ex) {
                                                System.out.println("General Exception:" + ex.getMessage());
                                            }
                                        }
                                        //set task with it's parts
                                        taskPartsHt.put(tasksCodes[i], composePartsVec);
                                    }
                                }
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        }
                    } catch (SQLException SQLex) {
                        System.out.println("Schedule Servlet: save schedule sql " + SQLex.getMessage());
                    } catch (Exception ex) {
                        System.out.println("Get UnitCat Schedules Exception = " + ex.getMessage());
                    }

                    schedule = scheduleMgr.getOnSingleKey(scheduleID);
                    configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                    itemList = configureMainTypeMgr.getConfigItemBySchedule(scheduleID);

                    request.setAttribute("schType", schType);
                    request.setAttribute("tasks", tasksData);
                    request.setAttribute("taskPartsHt", taskPartsHt);
                    request.setAttribute("data", itemList);
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("scheduleId", scheduleID);
                    request.setAttribute("source", request.getParameter("source"));

//                urlBackToView="op=ViewSchedule&source="+request.getParameter("source")+"&periodicID="+scheduleID;
//                if(request.getParameter("source").equalsIgnoreCase("eqp")){
//                    String eqpID = request.getParameter("equipmentID");
//                    request.setAttribute("equipmentCat",eqpID);
//                    urlBackToView+="&equipmentID="+eqpID;
//                }else{
//                    request.setAttribute("equipmentCat",request.getParameter("equipmentCat"));
//                    urlBackToView+="&equipmentCat="+request.getParameter("equipmentCat");
//                }
//                urlBackToView= urlBackToView.replaceAll("'","");
//                session.setAttribute("urlBackToView",urlBackToView);
                    scheduleDocMgr = ScheduleDocMgr.getInstance();
                    docsList = scheduleDocMgr.getListOnLIKE("ListDoc", scheduleID);
                    request.setAttribute("docData", docsList);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

//                userTradesVec = new Vector();
//                userTradesVec = (Vector) user.getAttribute("userTrade");
//
//                eqpsVec = new Vector();
//                vecSchedule = new Vector();
//
//                unitWbo = new WebBusinessObject();
//                unitName = new String();
//                unitCatID = new String();
//
//                try {
//                    eqpsVec = (Vector) unit.getOnArbitraryKey("1","key3");
//
//                    if(request.getParameter("unit").equalsIgnoreCase("non")){
//                        if(eqpsVec.size() > 0 ){
//                            unitWbo = (WebBusinessObject) eqpsVec.elementAt(0);
//                        }
//                    } else {
//                        unitWbo = unit.getOnSingleKey(request.getParameter("unit").toString());
//                    }
//
//                    unitName = unitWbo.getAttribute("unitName").toString();
//                    unitCatID = unitWbo.getAttribute("parentId").toString();
//
//                    vecSchedule = scheduleMgr.getOnArbitraryDoubleKey("1", "key3",unitWbo.getAttribute("id").toString(), "key2");
//                } catch (SQLException ex) {
//                    ex.printStackTrace();
//                } catch (Exception ex) {
//                    ex.printStackTrace();
//                }
//
//                request.setAttribute("data", vecSchedule);
//                request.setAttribute("selectedUnitName", unitName);
//                request.setAttribute("unitCatID", unitCatID);
//                request.setAttribute("tradeVec", userTradesVec);
//                request.setAttribute("page",servedPage);
//
//                this.forwardToServedPage(request, response);
                    break;

                case 118:
                    schType = "kilometer";
                    servedPage = "/docs/schedule/new_KM_Equip_Schedule.jsp";
                    userTradesVec = new Vector();
                    userTradesVec = (Vector) loggedUser.getAttribute("userTrade");
                    eqpsVec = new Vector();
                    vecSchedule = new Vector();
                    unitWbo = null;
                    unitName = new String();
                    unitCatID = new String();
                    unitsListArr = new ArrayList();
                    try {
                        session = request.getSession();

                        String[] params = {"1", "0", "odometer"};
                        String[] keys = {"key3", "key5", "key9"};
                        eqpsVec = unit.getOnArbitraryNumberKey(3, params, keys);

                        if (request.getParameter("unit").equalsIgnoreCase("non")) {
                            if (unitsListArr.size() > 0) {
                                unitWbo = (WebBusinessObject) unitsListArr.get(0);
                            }
                        } else {
                            unitWbo = unit.getOnSingleKey(request.getParameter("unit").toString());
                        }

                        unitName = unitWbo.getAttribute("unitName").toString();
                        unitCatID = unitWbo.getAttribute("parentId").toString();

                        vecSchedule = scheduleMgr.getOnArbitraryDoubleKey("5", "key6", unitWbo.getAttribute("id").toString(), "key2");
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                    eqpsArray = new ArrayList();
                    for (int i = 0; i < eqpsVec.size(); i++) {
                        eqpsArray.add(eqpsVec.get(i));
                    }
                    request.setAttribute("equipments", eqpsArray);
                    request.setAttribute("schType", schType);
                    request.setAttribute("unitsList", unitsListArr);
                    request.setAttribute("data", vecSchedule);
                    request.setAttribute("selectedUnitName", unitName);
                    request.setAttribute("unitCatID", unitCatID);
                    request.setAttribute("tradeVec", userTradesVec);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
//                case 119:
//                    relatedScheduleDetailsMgr = RelatedScheduleDetailsMgr.getInstance();
//                    String[] schedulesD = request.getParameterValues("scheduleId");
//                    String[] schedulesI = request.getParameterValues("scheduleIndex");
//                    ArrayList<Integer> ignoreList = new ArrayList<Integer>();
//                    if (schedulesD != null) {
//                        for (int i = 0; i < schedulesD.length - 1; i++) {
//                            for (int k = i + 1; k < schedulesD.length; k++) {
//                                WebBusinessObject relationTemp = relatedScheduleDetailsMgr.getRelationSides(schedulesD[i], schedulesD[k], RelatedScheduleDetailsMgr.INCLUDE);
//                                if (relationTemp != null) {
//                                    String ignore = (String) relationTemp.getAttribute("relatedScheduleID");
//                                    for (int j = 0; j < schedulesD.length; j++) {
//                                        if (schedulesD[j].equals(ignore)) {
//                                            if (!ignoreList.contains(Integer.parseInt(schedulesI[j]))) {
//                                                ignoreList.add(Integer.parseInt(schedulesI[j]));
//                                            }
//                                            break;
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    response.setContentType("text/plain");
//                    PrintWriter printWriter = response.getWriter();
//                    printWriter.write(ignoreList.toString());
//                    printWriter.flush();
//                    printWriter.close();
//                    break;

                case 120:

                    servedPage = "/docs/schedule/schedules_list.jsp";
                    Filter filter = new Filter();
                    schedules = new Vector();
                    filter = Tools.getPaginationInfo(request, response);
                    scheduleMgr = ScheduleMgr.getInstance();
                    List<WebBusinessObject> scheduleLists = new ArrayList<WebBusinessObject>(0);

                    //grab scheduleList list
                    try {
                        scheduleLists = scheduleMgr.paginationEntity(filter);
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

                    /*scheduleName = (String) request.getParameter("scheduleName");
                     formName = (String) request.getParameter("formName");
                     schedules = new Vector();
                     count = 0;
                     url = "ScheduleServlet?op=searchSchBySubNamePopup";
                     scheduleMgr = ScheduleMgr.getInstance();
                    
                     if (scheduleName != null && !scheduleName.equals("")) {
                     String[] partsArr = scheduleName.split(",");
                     scheduleName = "";
                     for (int i = 0; i < partsArr.length; i++) {
                     char temp1 = (char) new Integer(partsArr[i]).intValue();
                     scheduleName += temp1;
                     }
                     }
                    
                     try {
                     if (scheduleName != null && !scheduleName.equals("")) {
                    
                     schedules = scheduleMgr.getSchBySubName(scheduleName);
                    
                     } else {
                    
                     scheduleMgr.cashData();
                     schedules = scheduleMgr.getCashedTable();
                    
                     }
                     } catch (Exception ex) {
                     Logger.getLogger(ScheduleServlet.class.getName()).log(Level.SEVERE, null, ex);
                     }
                     tempcount = (String) request.getParameter("count");
                     if (tempcount != null) {
                     count = Integer.parseInt(tempcount);
                     }
                    
                     subSchedules = new Vector();
                     wbo = new WebBusinessObject();
                     index = (count + 1) * 10;
                     id = "";
                    
                     if (schedules.size() < index) {
                     index = schedules.size();
                     }
                     for (int i = count * 10; i < index; i++) {
                     wbo = (WebBusinessObject) schedules.get(i);
                     subSchedules.add(wbo);
                     }
                    
                     noOfLinks = schedules.size() / 10f;
                     temp = "" + noOfLinks;
                     intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                     links = (int) noOfLinks;
                     if (intNo > 0) {
                     links++;
                     }
                     if (links == 1) {
                     links = 0;
                     }
                    
                     servedPage = "/docs/schedule/list_schedules.jsp";
                    
                     request.setAttribute("count", "" + count);
                     request.setAttribute("noOfLinks", "" + links);
                     request.setAttribute("fullUrl", url);
                     request.setAttribute("url", url);
                     request.setAttribute("scheduleName", scheduleName);
                     request.setAttribute("formName", formName);
                    
                     request.setAttribute("data", subSchedules);
                     request.setAttribute("page", servedPage);
                     */
                    this.forward(servedPage, request, response);
                    break;

                case 121:

                    servedPage = "/docs/schedule/schedules_list_by_date.jsp";
                    filter = new Filter();
                    schedules = new Vector();
                    filter = Tools.getPaginationInfoForEng(request, response);
                    scheduleMgr = ScheduleMgr.getInstance();
                    scheduleLists = new ArrayList<WebBusinessObject>(0);

                    //grab scheduleList list
                    try {
                        scheduleLists = scheduleMgr.paginationEntityByDate(filter, "yyyy-MM-dd HH24:mi:ss");
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
                case 122:

                    servedPage = "/docs/schedule/schedules_list_by_date_review.jsp";
                    filter = new Filter();
                    schedules = new Vector();
                    filter = Tools.getPaginationInfoForEng(request, response);
                    scheduleMgr = ScheduleMgr.getInstance();
                    scheduleLists = new ArrayList<WebBusinessObject>(0);

                    //grab scheduleList list
                    try {
                        scheduleLists = scheduleMgr.paginationEntityByDate(filter, "yyyy-MM-dd HH24:mi:ss");
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                    selectionType = request.getParameter("selectionType");

                    if (selectionType == null) {
                        selectionType = "single";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("data", scheduleLists);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 123:
                    servedPage = "/docs/Search/search_schedule_by_date_review.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 124:
                    periodicID = null;
                    itemList = new Vector();
                    itemsList = ConfigureMainTypeMgr.getInstance();
                    servedPage = "/docs/schedule/view_schedule_1.jsp";
                    periodicID = request.getParameter("periodicID");
                    Approval = null;
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    Approval = genericApprovalStatusMgr.getOnSingleKey1(request.getParameter("periodicID"));
                    if (Approval != null) {
                        request.setAttribute("flag", "true");
                    } else {
                        request.setAttribute("flag", "false");
                    }

                    schedule = scheduleMgr.getOnSingleKey(periodicID);
                    temp = schedule.getAttribute("scheduleType").toString();

                    request.setAttribute("type", temp);
                    itemList = itemsList.getConfigItemBySchedule(periodicID);
                    request.setAttribute("data", itemList);
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("scheduleId", periodicID);
                    request.setAttribute("source", request.getParameter("source"));

                    urlBackToView = "op=ViewSchedule&source=" + request.getParameter("source") + "&periodicID=" + periodicID;

                    source = (String) request.getParameter("source");

                    mode = (String) request.getSession().getAttribute("currentMode");

                    if (source == null || source.equalsIgnoreCase("")) {
                        String schOn = schedule.getAttribute("scheduledOn").toString();
                        if (schOn.equalsIgnoreCase("Cat")) {
                            source = "cat";
                            request.setAttribute("equipmentCat", schedule.getAttribute("equipmentCatID").toString());
                            urlBackToView += "&equipmentCat=" + request.getParameter("equipmentCat");

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, request.getParameter("equipmentCat"), periodicID, "c", mode);
                        } else if (schOn.equalsIgnoreCase("mainCat")) {
                            source = "maincat";
                            mainCatId = schedule.getAttribute("mainCatTypeId").toString();
                            request.setAttribute("equipmentCat", mainCatId);
                            urlBackToView += "&mainCatId=" + mainCatId;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, mainCatId, periodicID, "mc", mode);
                        } else {
                            source = "eqp";
                            String eqpID = schedule.getAttribute("equipmentID").toString();
                            request.setAttribute("equipmentCat", eqpID);
                            urlBackToView += "&equipmentID=" + eqpID;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, eqpID, periodicID, "", mode);
                        }
                    } else {

                        if (source.equalsIgnoreCase("eqp")) {
                            String eqpID = request.getParameter("equipmentID");
                            request.setAttribute("equipmentCat", eqpID);
                            urlBackToView += "&equipmentID=" + eqpID;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, eqpID, periodicID, "", mode);

                        } else if (source.equalsIgnoreCase("maincat")) {
                            mainCatId = request.getParameter("mainCatId");
                            request.setAttribute("equipmentCat", mainCatId);
                            urlBackToView += "&mainCatId=" + mainCatId;

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, mainCatId, periodicID, "mc", mode);
                        } else {
                            request.setAttribute("equipmentCat", request.getParameter("equipmentCat"));
                            urlBackToView += "&equipmentCat=" + request.getParameter("equipmentCat");

                            // Activate Schedule Side Menu
                            Tools.ActivateScheduleSideMenu(request, request.getParameter("equipmentCat"), periodicID, "c", mode);
                        }
                    }

                    urlBackToView = urlBackToView.replaceAll("'", "");
                    session.setAttribute("urlBackToView", urlBackToView);

                    scheduleDocMgr = ScheduleDocMgr.getInstance();
                    docsList = scheduleDocMgr.getListOnLIKE("ListDoc", periodicID);
                    request.setAttribute("docData", docsList);
                    request.setAttribute("source", source);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);

                    break;

                case 125:
                    servedPage = "/docs/schedule/schedules_before_date.jsp";
                    String[] scheduleIdArr = request.getParameterValues("scheduleCbx");
                    String beforeDateStr = request.getParameter("beforeDateStr");

                    if (scheduleMgr.deleteBatchExactlySchedule(scheduleIdArr)) {
                        request.setAttribute("status", "ok");

                    } else {
                        request.setAttribute("status", "no");

                    }

                    request.setAttribute("beforeDateStr", beforeDateStr);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 126:
                    servedPage = "/docs/schedule/request_items_by_schedule.jsp";

                    mainCatsTypeVec = new Vector();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    schedulesVector = new Vector();
                    unitsVector = new Vector();

                    scheduleUnitsVector = new Vector();
                    nonScheduleUnitsVector = new Vector();
                    configuredScheduleVector = new Vector();

                    sSchedule = new Vector();
                    String unitType = (String) request.getParameter("unitType");
                    MaintainableMgr parentMgr = MaintainableMgr.getInstance();
                    Vector modelVec = new Vector();

                    if (unitType == null || (unitType != null && !unitType.equals("") && unitType.equals("1"))) {
                        try {
                            //Variables Definitions.
                            WebBusinessObject mainCatTypeWbo = null;

                            //Get All Equipment Cats.
                            mainCategoryTypeMgr.cashData();
                            mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();
                            modelVec = parentMgr.getAllParentSortingById();

                            if (request.getParameter("eqpMainCat") == null || request.getParameter("eqpMainCat").toString().equals("")) {
                                if (mainCatsTypeVec.size() > 0) {
                                    //Select The first equipment Category in the list.
                                    mainCatTypeWbo = (WebBusinessObject) mainCatsTypeVec.elementAt(0);
                                }
                            } else {
                                //Select the one that came from the JSP.
                                mainCatTypeWbo = mainCategoryTypeMgr.getOnSingleKey(request.getParameter("eqpMainCat"));
                            }
                            request.setAttribute("SelectedEqpMainCat", mainCatTypeWbo.getAttribute("typeName").toString());

                            //Select schedule for the equipment Category.
                            schedulesVector = scheduleMgr.getMainCatsSchByTrade(userTradesVec, "", mainCatTypeWbo.getAttribute("id").toString());

                            //Select equipments children for the equipment category.
                            String[] values = new String[3];
                            String[] keyes = new String[3];

                            values[0] = "0";
                            values[1] = "1";
                            values[2] = mainCatTypeWbo.getAttribute("id").toString();
                            keyes[0] = "key5";
                            keyes[1] = "key3";
                            keyes[2] = "key10";

                            unitsVector = unit.getOnArbitraryNumberKey(3, values, keyes);

                            if (schedulesVector.size() > 0) {
                                if (request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals("")) {
                                    //Select the first schedule in the list
                                    scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                                } else {
                                    //Select the schedule that came from jsp.
                                    scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                                }

                                //Create Selected Schedule Vector to refine UnitSchedules by it.
                                sSchedule.addElement(scheduleWbo);

                                //Get Schedule Configuration
                                configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                                //Get Scheduled Equipments and Non Scheduled Equipments
                                nonScheduleUnitsVector = (Vector) unitsVector.clone();
                                scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                                request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                            }

                            if ((request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals(""))
                                    || (request.getParameter("equipmentID") == null || request.getParameter("equipmentID").toString().equals(""))) {
                                //Select First Equipment to display its data
                                if (nonScheduleUnitsVector.size() > 0) {
                                    machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                    request.setAttribute("selectedMachDetails", machineWbo);
                                }
                            } else {
                                machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    } else if (unitType != null && !unitType.equals("") && unitType.equals("2")) {
                        try {
                            //Variables Definitions.
                            WebBusinessObject modelWbo = null;

                            //Get All Equipment Cats.
                            //mainCategoryTypeMgr.cashData();
                            mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();
                            modelVec = parentMgr.getAllParentSortingById();

                            if (request.getParameter("eqpMainModel") == null || request.getParameter("eqpMainModel").toString().equals("")) {
                                if (modelVec.size() > 0) {
                                    //Select The first equipment Category in the list.
                                    modelWbo = (WebBusinessObject) modelVec.elementAt(0);
                                }
                            } else {
                                //Select the one that came from the JSP.
                                modelWbo = parentMgr.getOnSingleKey(request.getParameter("eqpMainModel"));
                            }
                            request.setAttribute("SelectedEqpMainCat", modelWbo.getAttribute("unitName").toString());

                            //Select schedule for the equipment Category.
                            schedulesVector = scheduleMgr.getModelSchByTrade(userTradesVec, "", modelWbo.getAttribute("id").toString());

                            //Select equipments children for the equipment category.
                            String[] values = new String[3];
                            String[] keyes = new String[3];

                            values[0] = "0";
                            values[1] = "1";
                            values[2] = modelWbo.getAttribute("id").toString();
                            keyes[0] = "key5";
                            keyes[1] = "key3";
                            keyes[2] = "key10";

                            unitsVector = unit.getOnArbitraryKey(modelWbo.getAttribute("id").toString(), "key1");

                            if (schedulesVector.size() > 0) {
                                String dd = (String) request.getParameter("schedules");
                                if (request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals("") || request.getParameter("schedules").toString().equals("no")) {
                                    //Select the first schedule in the list
                                    scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                                } else {
                                    //Select the schedule that came from jsp.
                                    scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                                }

                                //Create Selected Schedule Vector to refine UnitSchedules by it.
                                sSchedule.addElement(scheduleWbo);

                                //Get Schedule Configuration
                                configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                                //Get Scheduled Equipments and Non Scheduled Equipments
                                nonScheduleUnitsVector = (Vector) unitsVector.clone();
                                scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                                request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                            }

                            if ((request.getParameter("scheduleID") == null || request.getParameter("scheduleID").toString().equals(""))
                                    || (request.getParameter("equipmentID") == null || request.getParameter("equipmentID").toString().equals(""))) {
                                //Select First Equipment to display its data
                                if (nonScheduleUnitsVector.size() > 0) {
                                    machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                    request.setAttribute("selectedMachDetails", machineWbo);
                                }
                            } else {
                                machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    }

                    request.setAttribute("eqpMainCat", mainCatsTypeVec);
                    request.setAttribute("modelVec", modelVec);
                    request.setAttribute("unitType", unitType);
                    request.setAttribute("schedules", schedulesVector);
                    request.setAttribute("sheduledEqps", scheduleUnitsVector);
                    request.setAttribute("unschedulesEqps", nonScheduleUnitsVector);
                    request.setAttribute("noOfConfigure", new Integer(configuredScheduleVector.size()));
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 127:
                    servedPage = "/docs/schedule/request_items_by_schedule.jsp";

                    //////////////////////////////////////////////////////////////
                    mainCatsTypeVec = new Vector();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    schedulesVector = new Vector();
                    unitsVector = new Vector();

                    scheduleUnitsVector = new Vector();
                    nonScheduleUnitsVector = new Vector();
                    configuredScheduleVector = new Vector();

                    sSchedule = new Vector();
                    unitType = (String) request.getParameter("unitType");
                    parentMgr = MaintainableMgr.getInstance();
                    modelVec = new Vector();
                    bDate = (String) request.getParameter("bDate");
                    eDate = (String) request.getParameter("eDate");
                    request.setAttribute("bDate", bDate);
                    request.setAttribute("eDate", eDate);

                    if (unitType == null || (unitType != null && !unitType.equals("") && unitType.equals("1"))) {
                        try {
                            //Variables Definitions.
                            WebBusinessObject mainCatTypeWbo = null;

                            //Get All Equipment Cats.
                            mainCategoryTypeMgr.cashData();
                            mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();
                            modelVec = parentMgr.getAllParentSortingById();

                            if (request.getParameter("eqpMainCat") == null || request.getParameter("eqpMainCat").toString().equals("")) {
                                if (mainCatsTypeVec.size() > 0) {
                                    //Select The first equipment Category in the list.
                                    mainCatTypeWbo = (WebBusinessObject) mainCatsTypeVec.elementAt(0);
                                }
                            } else {
                                //Select the one that came from the JSP.
                                mainCatTypeWbo = mainCategoryTypeMgr.getOnSingleKey(request.getParameter("eqpMainCat"));
                            }
                            request.setAttribute("SelectedEqpMainCat", mainCatTypeWbo.getAttribute("typeName").toString());

                            //Select schedule for the equipment Category.
                            schedulesVector = scheduleMgr.getMainCatsSchByTrade(userTradesVec, "", mainCatTypeWbo.getAttribute("id").toString());

                            //Select equipments children for the equipment category.
                            String[] values = new String[3];
                            String[] keyes = new String[3];

                            values[0] = "0";
                            values[1] = "1";
                            values[2] = mainCatTypeWbo.getAttribute("id").toString();
                            keyes[0] = "key5";
                            keyes[1] = "key3";
                            keyes[2] = "key10";

                            unitsVector = unit.getOnArbitraryNumberKey(3, values, keyes);

                            if (schedulesVector.size() > 0) {
                                if (request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals("")) {
                                    //Select the first schedule in the list
                                    scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                                } else {
                                    //Select the schedule that came from jsp.
                                    scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                                }

                                //Create Selected Schedule Vector to refine UnitSchedules by it.
                                sSchedule.addElement(scheduleWbo);

                                //Get Schedule Configuration
                                configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                                //Get Scheduled Equipments and Non Scheduled Equipments
                                nonScheduleUnitsVector = (Vector) unitsVector.clone();
                                scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                                request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                            }

                            if ((request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals(""))
                                    || (request.getParameter("equipmentID") == null || request.getParameter("equipmentID").toString().equals(""))) {
                                //Select First Equipment to display its data
                                if (nonScheduleUnitsVector.size() > 0) {
                                    machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                    request.setAttribute("selectedMachDetails", machineWbo);
                                }
                            } else {
                                machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    } else if (unitType != null && !unitType.equals("") && unitType.equals("2")) {
                        try {
                            //Variables Definitions.
                            WebBusinessObject modelWbo = null;

                            //Get All Equipment Cats.
                            //mainCategoryTypeMgr.cashData();
                            mainCatsTypeVec = mainCategoryTypeMgr.getCashedTable();
                            modelVec = parentMgr.getAllParentSortingById();

                            if (request.getParameter("eqpMainModel") == null || request.getParameter("eqpMainModel").toString().equals("")) {
                                if (modelVec.size() > 0) {
                                    //Select The first equipment Category in the list.
                                    modelWbo = (WebBusinessObject) modelVec.elementAt(0);
                                }
                            } else {
                                //Select the one that came from the JSP.
                                modelWbo = parentMgr.getOnSingleKey(request.getParameter("eqpMainModel"));
                            }
                            request.setAttribute("SelectedEqpMainCat", modelWbo.getAttribute("unitName").toString());

                            //Select schedule for the equipment Category.
                            schedulesVector = scheduleMgr.getModelSchByTrade(userTradesVec, "", modelWbo.getAttribute("id").toString());

                            //Select equipments children for the equipment category.
                            String[] values = new String[3];
                            String[] keyes = new String[3];

                            values[0] = "0";
                            values[1] = "1";
                            values[2] = modelWbo.getAttribute("id").toString();
                            keyes[0] = "key5";
                            keyes[1] = "key3";
                            keyes[2] = "key10";

                            unitsVector = unit.getOnArbitraryKey(modelWbo.getAttribute("id").toString(), "key1");

                            if (schedulesVector.size() > 0) {
                                if (request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals("")) {
                                    //Select the first schedule in the list
                                    scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                                } else {
                                    //Select the schedule that came from jsp.
                                    scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                                }

                                //Create Selected Schedule Vector to refine UnitSchedules by it.
                                sSchedule.addElement(scheduleWbo);

                                //Get Schedule Configuration
                                configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                                //Get Scheduled Equipments and Non Scheduled Equipments
                                nonScheduleUnitsVector = (Vector) unitsVector.clone();
                                scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                                request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                            }

                            if ((request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals(""))
                                    || (request.getParameter("equipmentID") == null || request.getParameter("equipmentID").toString().equals(""))) {
                                //Select First Equipment to display its data
                                if (nonScheduleUnitsVector.size() > 0) {
                                    machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                    request.setAttribute("selectedMachDetails", machineWbo);
                                }
                            } else {
                                machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    }

                    request.setAttribute("eqpMainCat", mainCatsTypeVec);
                    request.setAttribute("modelVec", modelVec);
                    request.setAttribute("unitType", unitType);
                    request.setAttribute("schedules", schedulesVector);
                    request.setAttribute("sheduledEqps", scheduleUnitsVector);
                    request.setAttribute("unschedulesEqps", nonScheduleUnitsVector);
                    request.setAttribute("noOfConfigure", new Integer(configuredScheduleVector.size()));
                    request.setAttribute("page", servedPage);

                    //////////////////////////////////////////////////////////////
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();

                    issueMgr = IssueMgr.getInstance();

                    frequency = 0;
                    frequencyType = 0;
                    totalCost = 0;

                    scheduleId = request.getParameter("schedules");
                    scheduleName = null;

                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    scheduleUnit = null;
                    issueDates = new Vector();

                    beginDate = null;
                    endDate = null;
                    List dateIssueList = new ArrayList();
                    saveSchedule = null;
                    List itemQtyList = new ArrayList();

                    if (unitType != null && !unitType.equals("") && unitType.equals("1")) {
                        try {
                            scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                            scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");
                            machineStatus.addElement(scheduleName);

                            eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");
                            String unitId = (String) request.getParameter("machines");
                            eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

                            DateParser dateParser = new DateParser();
                            beginDate = dateParser.formatSqlDate(request.getParameter("bDate"), jsDateFormat);
                            endDate = dateParser.formatSqlDate(request.getParameter("eDate"), jsDateFormat);

                            if (endDate.before(beginDate) == true) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("End date must be grater than begin date");
                            } else {
                                saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                                frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                                frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();

                                if ((frequencyType == 0) && (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("odometer"))) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("This schedule will be activated dynamically by the system when this Equipment counter arrive to the value that you are inserted in the maintenance schedule");
                                } else {

                                    //Unit_Schedule and Issue
                                    issueDates.removeAllElements();
                                    int iAddDay = 0;
                                    if (frequencyType == 0) {
                                        frequency = frequency / 24;
                                        iAddDay = frequency;
                                        frequencyType = 1;
                                    }
                                    int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                    int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                    issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                                    if (issueDates.size() == 0) {
                                        machineStatus.addElement("Failed");
                                        machineStatus.addElement("Please review Task Frequency");
                                    } else {
                                        if (issueDates.size() > 15) {
                                            machineStatus.addElement("Failed");
                                            machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                        } else {
                                            Integer issueCount = issueDates.size() - 1;
                                            Integer unitCount = unitsVector.size();
                                            UtilDate utilDate = null;
                                            try {
                                                Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");
                                                WebBusinessObject itemTaskWbo = null;
                                                configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                                Item item = null;
                                                for (int m = 0; m < scTasks.size(); m++) {
                                                    taskWbo = new WebBusinessObject();
                                                    taskWbo = (WebBusinessObject) scTasks.get(m);
                                                    Vector itemV = configTasksPartsMgr.getOnArbitraryKey(taskWbo.getAttribute("codeTask").toString(), "key1");
                                                    for (int n = 0; n < itemV.size(); n++) {
                                                        item = new Item();
                                                        itemTaskWbo = (WebBusinessObject) itemV.get(n);
                                                        item.setId(itemTaskWbo.getAttribute("itemId").toString());
                                                        Double total = new Double(itemTaskWbo.getAttribute("itemQuantity").toString()).doubleValue()
                                                                * new Double(issueCount).intValue() * new Double(unitCount).intValue();
                                                        Double qtyIssue = new Double(itemTaskWbo.getAttribute("itemQuantity").toString()).doubleValue()
                                                                * new Double(unitCount).intValue();
                                                        item.setQty(total);
                                                        item.setQtyIssue(qtyIssue);
                                                        itemQtyList.add(item);
                                                    }
                                                }

                                                for (int j = 0; j < issueDates.size(); j++) {
                                                    utilDate = new UtilDate();
                                                    Calendar c = Calendar.getInstance();
                                                    Calendar d = Calendar.getInstance();

                                                    c = (Calendar) issueDates.elementAt(j);
                                                    if (j < issueDates.size() - 1) {
                                                        d = (Calendar) issueDates.elementAt(j + 1);
                                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                        String sBDate = sdf.format(c.getTime());
                                                        String sEDate = sdf.format(d.getTime());
                                                        utilDate.setbDate(sBDate);
                                                        utilDate.seteDate(sEDate);
                                                        dateIssueList.add(utilDate);
                                                    }
                                                }

                                                /**
                                                 * **************** Transfer
                                                 * Schedule Parts To Issues
                                                 * **********************
                                                 */
                                                configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                                                QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();
//
                                                /**
                                                 * **************** End Of
                                                 * Transfer Schedule Parts
                                                 * **********************
                                                 */
                                            } catch (Exception ex) {
                                                logger.error(ex.getMessage());
                                            }

                                        }
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                        }
                    } else if (unitType != null && !unitType.equals("") && unitType.equals("2")) {
                        try {
                            scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                            scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");
                            machineStatus.addElement(scheduleName);

                            eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");
                            String unitId = (String) request.getParameter("machines");
                            eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

                            DateParser dateParser = new DateParser();
                            beginDate = dateParser.formatSqlDate(request.getParameter("bDate"), jsDateFormat);
                            endDate = dateParser.formatSqlDate(request.getParameter("eDate"), jsDateFormat);

                            if (endDate.before(beginDate) == true) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("End date must be grater than begin date");
                            } else {
                                saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                                frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                                frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();
                                //Unit_Schedule and Issue
                                issueDates.removeAllElements();
                                int iAddDay = 0;
                                if (frequencyType == 0) {
                                    frequency = frequency / 24;
                                    iAddDay = frequency;
                                    frequencyType = 1;
                                }
                                int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                                int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                                issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                                if (issueDates.size() == 0) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Please review Task Frequency");
                                } else {
                                    if (issueDates.size() > 15) {
                                        machineStatus.addElement("Failed");
                                        machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                    } else {
                                        Integer issueCount = issueDates.size() - 1;
                                        Integer unitCount = unitsVector.size();
                                        UtilDate utilDate = null;
                                        try {
                                            Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");
                                            WebBusinessObject itemTaskWbo = null;
                                            configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                            Item item = null;
                                            for (int m = 0; m < scTasks.size(); m++) {
                                                taskWbo = new WebBusinessObject();
                                                taskWbo = (WebBusinessObject) scTasks.get(m);
                                                Vector itemV = configTasksPartsMgr.getOnArbitraryKey(taskWbo.getAttribute("codeTask").toString(), "key1");
                                                for (int n = 0; n < itemV.size(); n++) {
                                                    item = new Item();
                                                    itemTaskWbo = (WebBusinessObject) itemV.get(n);
                                                    item.setId(itemTaskWbo.getAttribute("itemId").toString());
                                                    Double total = new Double(itemTaskWbo.getAttribute("itemQuantity").toString()).doubleValue()
                                                            * new Double(issueCount).intValue() * new Double(unitCount).intValue();
                                                    Double qtyIssue = new Double(itemTaskWbo.getAttribute("itemQuantity").toString()).doubleValue()
                                                            * new Double(unitCount).intValue();
                                                    item.setQty(total);
                                                    item.setQtyIssue(qtyIssue);
                                                    itemQtyList.add(item);
                                                }
                                            }

                                            for (int j = 0; j < issueDates.size(); j++) {
                                                utilDate = new UtilDate();
                                                Calendar c = Calendar.getInstance();
                                                Calendar d = Calendar.getInstance();

                                                c = (Calendar) issueDates.elementAt(j);
                                                if (j < issueDates.size() - 1) {
                                                    d = (Calendar) issueDates.elementAt(j + 1);
                                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                    String sBDate = sdf.format(c.getTime());
                                                    String sEDate = sdf.format(d.getTime());
                                                    utilDate.setbDate(sBDate);
                                                    utilDate.seteDate(sEDate);
                                                    dateIssueList.add(utilDate);
                                                }

                                            }

                                            /**
                                             * **************** Transfer
                                             * Schedule Parts To Issues
                                             * **********************
                                             */
                                            configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                                            QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();

                                            /**
                                             * **************** End Of Transfer
                                             * Schedule Parts
                                             * **********************
                                             */
                                        } catch (Exception ex) {
                                            logger.error(ex.getMessage());
                                        }
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                        }
                    }

                    request.setAttribute("itemQtyList", itemQtyList);
                    request.setAttribute("dateIssueList", dateIssueList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 128:
                    servedPage = "/docs/schedule/request_items_by_model.jsp";

                    modelVec = new Vector();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    schedulesVector = new Vector();
                    unitsVector = new Vector();

                    scheduleUnitsVector = new Vector();
                    nonScheduleUnitsVector = new Vector();
                    configuredScheduleVector = new Vector();

                    sSchedule = new Vector();
                    parentMgr = MaintainableMgr.getInstance();
                    try {
                        //Variables Definitions.
                        WebBusinessObject modelWbo = null;

                        //Get All Equipment Cats.
                        //mainCategoryTypeMgr.cashData();
                        modelVec = parentMgr.getAllParentSortingById();

                        if (request.getParameter("eqpMainCat") == null || request.getParameter("eqpMainCat").toString().equals("")) {
                            if (modelVec.size() > 0) {
                                //Select The first equipment Category in the list.
                                modelWbo = (WebBusinessObject) modelVec.elementAt(0);
                            }
                        } else {
                            //Select the one that came from the JSP.
                            modelWbo = parentMgr.getOnSingleKey(request.getParameter("eqpMainCat"));
                        }
                        request.setAttribute("SelectedEqpMainCat", modelWbo.getAttribute("unitName").toString());

                        //Select schedule for the equipment Category.
                        schedulesVector = scheduleMgr.getModelSchByTrade(userTradesVec, "", modelWbo.getAttribute("id").toString());

                        //Select equipments children for the equipment category.
                        String[] values = new String[3];
                        String[] keyes = new String[3];

                        values[0] = "0";
                        values[1] = "1";
                        values[2] = modelWbo.getAttribute("id").toString();
                        keyes[0] = "key5";
                        keyes[1] = "key3";
                        keyes[2] = "key10";

                        unitsVector = unit.getOnArbitraryKey(modelWbo.getAttribute("id").toString(), "key1");

                        if (schedulesVector.size() > 0) {
                            if (request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals("")) {
                                //Select the first schedule in the list
                                scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                            } else {
                                //Select the schedule that came from jsp.
                                scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                            }

                            //Create Selected Schedule Vector to refine UnitSchedules by it.
                            sSchedule.addElement(scheduleWbo);

                            //Get Schedule Configuration
                            configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                            //Get Scheduled Equipments and Non Scheduled Equipments
                            nonScheduleUnitsVector = (Vector) unitsVector.clone();
                            scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                            request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                        }

                        if ((request.getParameter("schedules") == null || request.getParameter("schedules").toString().equals(""))
                                || (request.getParameter("equipmentID") == null || request.getParameter("eqpMainCat").toString().equals(""))) {
                            //Select First Equipment to display its data
                            if (nonScheduleUnitsVector.size() > 0) {
                                machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } else {
                            machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                            request.setAttribute("selectedMachDetails", machineWbo);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    request.setAttribute("eqpMainCat", modelVec);
                    request.setAttribute("schedules", schedulesVector);
                    request.setAttribute("sheduledEqps", scheduleUnitsVector);
                    request.setAttribute("unschedulesEqps", nonScheduleUnitsVector);
                    request.setAttribute("noOfConfigure", new Integer(configuredScheduleVector.size()));
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 129:
                    servedPage = "/docs/schedule/request_items_by_model.jsp";

                    //////////////////////////////////////////////////////////////
                    modelVec = new Vector();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    schedulesVector = new Vector();
                    unitsVector = new Vector();

                    scheduleUnitsVector = new Vector();
                    nonScheduleUnitsVector = new Vector();
                    configuredScheduleVector = new Vector();

                    sSchedule = new Vector();
                    bDate = (String) request.getParameter("bDate");
                    eDate = (String) request.getParameter("eDate");
                    request.setAttribute("bDate", bDate);
                    request.setAttribute("eDate", eDate);
                    parentMgr = MaintainableMgr.getInstance();
                    try {
                        //Variables Definitions.
                        WebBusinessObject modelWbo = null;

                        //Get All Equipment Cats.
                        //mainCategoryTypeMgr.cashData();
                        modelVec = parentMgr.getAllParentSortingById();

                        if (request.getParameter("eqpMainCat") == null) {
                            if (modelVec.size() > 0) {
                                //Select The first equipment Category in the list.
                                modelWbo = (WebBusinessObject) modelVec.elementAt(0);
                            }
                        } else {
                            //Select the one that came from the JSP.
                            modelWbo = parentMgr.getOnSingleKey(request.getParameter("eqpMainCat"));
                        }
                        request.setAttribute("SelectedEqpMainCat", modelWbo.getAttribute("unitName").toString());

                        //Select schedule for the equipment Category.
                        schedulesVector = scheduleMgr.getModelSchByTrade(userTradesVec, "", modelWbo.getAttribute("id").toString());

                        //Select equipments children for the equipment category.
                        String[] values = new String[3];
                        String[] keyes = new String[3];

                        values[0] = "0";
                        values[1] = "1";
                        values[2] = modelWbo.getAttribute("id").toString();
                        keyes[0] = "key5";
                        keyes[1] = "key3";
                        keyes[2] = "key10";

                        unitsVector = unit.getOnArbitraryKey(modelWbo.getAttribute("id").toString(), "key1");

                        if (schedulesVector.size() > 0) {
                            if (request.getParameter("scheduleID") == null) {
                                //Select the first schedule in the list
                                scheduleWbo = (WebBusinessObject) schedulesVector.elementAt(0);
                            } else {
                                //Select the schedule that came from jsp.
                                scheduleWbo = scheduleMgr.getOnSingleKey(request.getParameter("schedules"));
                            }

                            //Create Selected Schedule Vector to refine UnitSchedules by it.
                            sSchedule.addElement(scheduleWbo);

                            //Get Schedule Configuration
                            configuredScheduleVector = eqpCatConfig.getOnArbitraryKey((String) scheduleWbo.getAttribute("periodicID"), "key1");

                            //Get Scheduled Equipments and Non Scheduled Equipments
                            nonScheduleUnitsVector = (Vector) unitsVector.clone();
                            scheduleUnitsVector = unitScheduleMgr.getEquipmentUnitSchedules(sSchedule, nonScheduleUnitsVector);

                            request.setAttribute("SelectedSchedule", scheduleWbo.getAttribute("maintenanceTitle").toString());
                        }

                        if ((request.getParameter("scheduleID") == null) || (request.getParameter("equipmentID") == null)) {
                            //Select First Equipment to display its data
                            if (nonScheduleUnitsVector.size() > 0) {
                                machineWbo = (WebBusinessObject) nonScheduleUnitsVector.elementAt(0);
                                request.setAttribute("selectedMachDetails", machineWbo);
                            }
                        } else {
                            machineWbo = unit.getOnSingleKey(request.getParameter("machines"));
                            request.setAttribute("selectedMachDetails", machineWbo);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    request.setAttribute("eqpMainCat", modelVec);
                    request.setAttribute("schedules", schedulesVector);
                    request.setAttribute("sheduledEqps", scheduleUnitsVector);
                    request.setAttribute("unschedulesEqps", nonScheduleUnitsVector);
                    request.setAttribute("noOfConfigure", new Integer(configuredScheduleVector.size()));

                    //////////////////////////////////////////////////////////////
                    jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();

                    issueMgr = IssueMgr.getInstance();

                    frequency = 0;
                    frequencyType = 0;
                    totalCost = 0;

                    scheduleId = request.getParameter("schedules");
                    scheduleName = null;

                    machineStatus = new Vector();
                    eqpCatCongigVec = new Vector();
                    scheduleUnit = null;
                    issueDates = new Vector();

                    beginDate = null;
                    endDate = null;
                    dateIssueList = new ArrayList();
                    saveSchedule = null;
                    itemQtyList = new ArrayList();
                    try {
                        scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                        scheduleName = (String) scheduleWbo.getAttribute("maintenanceTitle");
                        machineStatus.addElement(scheduleName);

                        eqpCatCongigVec = eqpCatConfig.getOnArbitraryKey(scheduleId, "key1");
                        String unitId = (String) request.getParameter("machines");
                        eqpWbo = unit.getOnSingleKey(request.getParameter("machines"));

                        DateParser dateParser = new DateParser();
                        beginDate = dateParser.formatSqlDate(request.getParameter("bDate"), jsDateFormat);
                        endDate = dateParser.formatSqlDate(request.getParameter("eDate"), jsDateFormat);

                        if (endDate.before(beginDate) == true) {
                            machineStatus.addElement("Failed");
                            machineStatus.addElement("End date must be grater than begin date");
                        } else {
                            saveSchedule = scheduleMgr.getOnSingleKey(scheduleId);
                            frequency = new Integer(saveSchedule.getAttribute("frequency").toString()).intValue();
                            frequencyType = new Integer(saveSchedule.getAttribute("frequencyType").toString()).intValue();
                            //Unit_Schedule and Issue
                            issueDates.removeAllElements();
                            int iAddDay = 0;
                            if (frequencyType == 0) {
                                frequency = frequency / 24;
                                iAddDay = frequency;
                                frequencyType = 1;
                            }
                            int duration = (new Integer((String) saveSchedule.getAttribute("duration"))).intValue();
                            int noOfDays = duration / (8 * 60); // 8 is the number of work's hours
                            issueDates = calculations.CalculteInterval(beginDate, endDate, frequency, frequencyType);
                            if (issueDates.size() == 0) {
                                machineStatus.addElement("Failed");
                                machineStatus.addElement("Please review Task Frequency");
                            } else {
                                if (issueDates.size() > 15) {
                                    machineStatus.addElement("Failed");
                                    machineStatus.addElement("Your selected interval will generate '" + issueDates.size() + "', which is too many.");
                                } else {
                                    Integer issueCount = issueDates.size() - 1;
                                    Integer unitCount = unitsVector.size();
                                    UtilDate utilDate = null;
                                    try {
                                        Vector scTasks = scheduleTMgr.getOnArbitraryKey(scheduleId, "key1");
                                        WebBusinessObject itemTaskWbo = null;
                                        configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                        Item item = null;
                                        for (int m = 0; m < scTasks.size(); m++) {
                                            taskWbo = new WebBusinessObject();
                                            taskWbo = (WebBusinessObject) scTasks.get(m);
                                            Vector itemV = configTasksPartsMgr.getOnArbitraryKey(taskWbo.getAttribute("codeTask").toString(), "key1");
                                            for (int n = 0; n < itemV.size(); n++) {
                                                item = new Item();
                                                itemTaskWbo = (WebBusinessObject) itemV.get(n);
                                                item.setId(itemTaskWbo.getAttribute("itemId").toString());
                                                Double total = new Double(itemTaskWbo.getAttribute("itemQuantity").toString()).doubleValue()
                                                        * new Double(issueCount).intValue() * new Double(unitCount).intValue();
                                                Double qtyIssue = new Double(itemTaskWbo.getAttribute("itemQuantity").toString()).doubleValue()
                                                        * new Double(unitCount).intValue();
                                                item.setQty(total);
                                                item.setQtyIssue(qtyIssue);
                                                itemQtyList.add(item);
                                            }
                                        }

                                        for (int j = 0; j < issueDates.size(); j++) {
                                            utilDate = new UtilDate();
                                            Calendar c = Calendar.getInstance();
                                            Calendar d = Calendar.getInstance();

                                            c = (Calendar) issueDates.elementAt(j);
                                            if (j < issueDates.size() - 1) {
                                                d = (Calendar) issueDates.elementAt(j + 1);
                                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                String sBDate = sdf.format(c.getTime());
                                                String sEDate = sdf.format(d.getTime());
                                                utilDate.setbDate(sBDate);
                                                utilDate.seteDate(sEDate);
                                                dateIssueList.add(utilDate);
                                            }

                                        }

                                        /**
                                         * **************** Transfer Schedule
                                         * Parts To Issues
                                         * **********************
                                         */
                                        configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                                        QuantifiedMntenceMgr QntfMntncMgr = QuantifiedMntenceMgr.getInstance();

                                        /**
                                         * **************** End Of Transfer
                                         * Schedule Parts **********************
                                         */
                                    } catch (Exception ex) {
                                        logger.error(ex.getMessage());
                                    }
                                }
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("Saving Timley schedule Error " + ex.getStackTrace());
                    }

                    request.setAttribute("itemQtyList", itemQtyList);
                    request.setAttribute("dateIssueList", dateIssueList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 130:
                    month = 0;
                    year = 0;
                    minDate = 0;
                    maxDate = 0;
                    userMgr = UserMgr.getInstance();
                    users = new Vector();
                    clientId = (String) request.getParameter("clientId");
                    clientMgr = ClientMgr.getInstance();

                    clientCompId = (String) request.getParameter("clientCompId");
//                    clientCompId="1409390970054";
//                    clientId="1409401127728";
                    userId = (String) request.getParameter("userId");
                    clientWbo = new WebBusinessObject();
                    clientMgr = ClientMgr.getInstance();
                    if (clientId != null && !clientId.equals("") && !clientId.equals("null")) {
                        clientWbo = clientMgr.getOnSingleKey(clientId);
                    }
                    areaId = (String) request.getParameter("area_id");
                    tradeId = "7";
                    userList = new ArrayList();

                    serviceManAreaMgr = ServiceManAreaMgr.getInstance();
                    users = serviceManAreaMgr.getSupervisorArea(areaId, tradeId);
                    if (users != null & !users.isEmpty()) {
                        for (int i = 0; i < users.size(); i++) {
                            wbo = new WebBusinessObject();
                            wbo = (WebBusinessObject) users.get(i);
                            WebBusinessObject wbo2 = new WebBusinessObject();
                            String user_id = (String) wbo.getAttribute("userId");
                            wbo2 = userMgr.getOnSingleKey(user_id);
                            userList.add(wbo2);
                        }

                    }

                    String[] monthsArray1 = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                    period = null;
                    monthsList = new ArrayList();
                    yearsList = new ArrayList();
                    monthWbo = new WebBusinessObject();

                    monthCal = Calendar.getInstance();

                    //Initialize months array list
                    for (int i = 0; i < 12; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", monthsArray1[i]);
                        monthsList.add(wbo);
                    }

                    for (int i = 2013; i <= 2020; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", new Integer(i).toString());
                        yearsList.add(wbo);

                    }

                    servedPage = "/docs/schedule/user_calendar.jsp";

                    // period = request.getParameter("peroid");
                    period = "currentMonth";
                    try {
                        if (period.equalsIgnoreCase("currentMonth")) {
                            //Get current month
                            month = monthCal.getTime().getMonth();
                            request.setAttribute("period", "currentMonth");
                        } else {
                            //Get Selected Month
                            month = new Integer(request.getParameter("month")).intValue();
                            request.setAttribute("period", "other");
                        }

                        //period calculations
                        year = monthCal.getTime().getYear();
                        minDate = monthCal.getActualMinimum(monthCal.DATE);
                        maxDate = monthCal.getActualMaximum(monthCal.DATE);

                        beginDate = new java.sql.Date(year, month, minDate);
                        endDate = new java.sql.Date(year, month, maxDate);

                        //Get Equipment Schedules
                        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                        Vector listOfAppointments = new Vector();
                        listOfAppointments = appointmentMgr.getAppointmentsDates(userId, beginDate, endDate);
                        if (listOfAppointments.size() > 0) {
                            request.setAttribute("listOfAppointments", listOfAppointments);
                        } else {
                            request.setAttribute("listOfAppointments", listOfAppointments);
                        }
                        Vector interestedUnit = new Vector();
                        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();

                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        ArrayList units = new ArrayList();

                        if (interestedUnit != null & !interestedUnit.isEmpty()) {
                            for (int i = 0; i < interestedUnit.size(); i++) {
                                units.add(interestedUnit.get(i));
                            }
                        }
                        //create month wbo
                        monthWbo.setAttribute("id", new Integer(month).toString());
                        monthWbo.setAttribute("name", monthsArray1[month]);

                        request.setAttribute("month", monthWbo);
                        request.setAttribute("users", userList);
                        request.setAttribute("monthsList", monthsList);
                        request.setAttribute("yearsList", yearsList);
                        request.setAttribute("units", units);
                        if (clientWbo != null) {
                            request.setAttribute("clientWbo", clientWbo);
                        }
                        if (clientCompId != null && !clientCompId.equals("null")) {
                            request.setAttribute("clientCompId", clientCompId);
                        } else {
                            request.setAttribute("clientCompId", " ");
                        }
                        request.setAttribute("userId", userId);
                    } catch (Exception ex) {
                    }
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                case 131:
                    month = 0;
                    year = 0;
                    minDate = 0;
                    maxDate = 0;
                    userMgr = UserMgr.getInstance();
                    users = new Vector();
                    clientMgr = ClientMgr.getInstance();
                    clientCompId = (String) request.getParameter("clientCompId");
                    HttpSession s = request.getSession();
                    WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
                    userId = (String) waUser.getAttribute("userId");
                    clientWbo = new WebBusinessObject();
                    clientMgr = ClientMgr.getInstance();
                    areaId = (String) request.getParameter("area_id");
                    tradeId = "7";
                    userList = new ArrayList();
                    serviceManAreaMgr = ServiceManAreaMgr.getInstance();
                    users = serviceManAreaMgr.getSupervisorArea(areaId, tradeId);
                    if (users != null & !users.isEmpty()) {
                        for (int i = 0; i < users.size(); i++) {
                            wbo = new WebBusinessObject();
                            wbo = (WebBusinessObject) users.get(i);
                            WebBusinessObject wbo2 = new WebBusinessObject();
                            String user_id = (String) wbo.getAttribute("userId");
                            wbo2 = userMgr.getOnSingleKey(user_id);
                            userList.add(wbo2);
                        }
                    }
                    String[] monthsArray2 = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                    period = null;
                    equipmentsList = new ArrayList();
                    monthsList = new ArrayList();
                    yearsList = new ArrayList();
                    eqpSchedules = new Vector();
                    equipmentWbo = null;
                    monthWbo = new WebBusinessObject();
                    monthCal = Calendar.getInstance();
                    //Initialize months array list
                    for (int i = 0; i < 12; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", monthsArray2[i]);
                        monthsList.add(wbo);
                    }
                    for (int i = 2013; i <= 2020; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", new Integer(i).toString());
                        yearsList.add(wbo);

                    }
                    servedPage = "user_calendar.jsp";
                    // period = request.getParameter("peroid");
                    period = "currentMonth";
                    try {
                        if (period.equalsIgnoreCase("currentMonth")) {
                            //Get current month
                            month = monthCal.getTime().getMonth();
                            request.setAttribute("period", "currentMonth");
                        } else {
                            //Get Selected Month
                            month = new Integer(request.getParameter("month")).intValue();
                            request.setAttribute("period", "other");
                        }

                        //period calculations
                        year = monthCal.getTime().getYear();
                        minDate = monthCal.getActualMinimum(monthCal.DATE);
                        maxDate = monthCal.getActualMaximum(monthCal.DATE);

                        beginDate = new java.sql.Date(year, month, minDate);
                        endDate = new java.sql.Date(year, month, maxDate);

                        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                        Vector listOfAppointments = new Vector();
                        listOfAppointments = appointmentMgr.getAppointmentsDates(userId, beginDate, endDate);
                        if (eqpSchedules.size() > 0) {
                            request.setAttribute("listOfAppointments", listOfAppointments);
                        } else {
                            request.setAttribute("listOfAppointments", listOfAppointments);
                        }
                        Vector interestedUnit = new Vector();
                        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();

                        ArrayList units = new ArrayList();

                        if (interestedUnit != null & !interestedUnit.isEmpty()) {
                            for (int i = 0; i < interestedUnit.size(); i++) {
                                units.add(interestedUnit.get(i));
                            }
                        }
                        //create month wbo
                        monthWbo.setAttribute("id", new Integer(month).toString());
                        monthWbo.setAttribute("name", monthsArray2[month]);

                        request.setAttribute("month", monthWbo);
                        request.setAttribute("users", userList);
                        request.setAttribute("monthsList", monthsList);
                        request.setAttribute("yearsList", yearsList);
                        request.setAttribute("units", units);
                        if (clientWbo != null) {
                            request.setAttribute("clientWbo", clientWbo);
                        }
                        if (clientCompId != null && !clientCompId.equals("null")) {
                            request.setAttribute("clientCompId", clientCompId);
                        } else {
                            request.setAttribute("clientCompId", " ");
                        }
                        request.setAttribute("userId", userId);

                    } catch (Exception ex) {
                        System.out.println("Schedule Servlet -- get equipment schedule exception = " + ex.getMessage());
                    }

                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    this.forwardToServedPage(request, response);
                    break;
                case 132:

                    servedPage = "/calendar.jsp";

                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                    break;
                case 133:
                    month = 0;
                    year = 0;
                    minDate = 0;
                    maxDate = 0;
                    userMgr = UserMgr.getInstance();
                    users = new Vector();
                    clientId = (String) request.getParameter("clientId");
                    clientMgr = ClientMgr.getInstance();

                    clientCompId = (String) request.getParameter("clientCompId");
//                    clientCompId="1409390970054";
//                    clientId="1409401127728";
                    userId = (String) request.getParameter("userId");
                    clientWbo = new WebBusinessObject();
                    clientMgr = ClientMgr.getInstance();
                    if (clientId != null && !clientId.equals("") && !clientId.equals("null")) {
                        clientWbo = clientMgr.getOnSingleKey(clientId);
                    }
                    areaId = (String) request.getParameter("area_id");
                    tradeId = "7";
                    userList = new ArrayList();

                    serviceManAreaMgr = ServiceManAreaMgr.getInstance();
                    users = serviceManAreaMgr.getSupervisorArea(areaId, tradeId);
                    if (users != null & !users.isEmpty()) {
                        for (int i = 0; i < users.size(); i++) {
                            wbo = new WebBusinessObject();
                            wbo = (WebBusinessObject) users.get(i);
                            WebBusinessObject wbo2 = new WebBusinessObject();
                            String user_id = (String) wbo.getAttribute("userId");
                            wbo2 = userMgr.getOnSingleKey(user_id);
                            userList.add(wbo2);
                        }

                    }
                    String[] monthsArr = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

                    period = null;
                    monthsList = new ArrayList();
                    yearsList = new ArrayList();
                    monthWbo = new WebBusinessObject();

                    monthCal = Calendar.getInstance();

                    //Initialize months array list
                    for (int i = 0; i < 12; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", monthsArr[i]);
                        monthsList.add(wbo);
                    }

                    for (int i = 2013; i <= 2020; i++) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("id", new Integer(i).toString());
                        wbo.setAttribute("name", new Integer(i).toString());
                        yearsList.add(wbo);

                    }

                    servedPage = "/docs/schedule/calendar.jsp";

                    // period = request.getParameter("peroid");
                    period = "currentMonth";
                    try {
                        if (period.equalsIgnoreCase("currentMonth")) {
                            //Get current month
                            month = monthCal.getTime().getMonth();
                            request.setAttribute("period", "currentMonth");
                        } else {
                            //Get Selected Month
                            month = new Integer(request.getParameter("month")).intValue();
                            request.setAttribute("period", "other");
                        }

                        //period calculations
                        year = monthCal.getTime().getYear();
                        minDate = monthCal.getActualMinimum(monthCal.DATE);
                        maxDate = monthCal.getActualMaximum(monthCal.DATE);

                        beginDate = new java.sql.Date(year, month, minDate);
                        endDate = new java.sql.Date(year, month, maxDate);

                        //Get Equipment Schedules
                        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                        Vector listOfAppointments = new Vector();
                        listOfAppointments = appointmentMgr.getAppointmentsDates(userId, beginDate, endDate);
                        if (listOfAppointments.size() > 0) {
                            request.setAttribute("listOfAppointments", listOfAppointments);
                        } else {
                            request.setAttribute("listOfAppointments", listOfAppointments);
                        }
                        Vector interestedUnit = new Vector();
                        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();

                        interestedUnit = clientProductMgr.getInterestedUnit(clientId);
                        ArrayList units = new ArrayList();

                        if (interestedUnit != null & !interestedUnit.isEmpty()) {
                            for (int i = 0; i < interestedUnit.size(); i++) {
                                units.add(interestedUnit.get(i));
                            }
                        }
                        //create month wbo
                        monthWbo.setAttribute("id", new Integer(month).toString());
                        monthWbo.setAttribute("name", monthsArr[month]);

                        request.setAttribute("month", monthWbo);
                        request.setAttribute("users", userList);
                        request.setAttribute("monthsList", monthsList);
                        request.setAttribute("yearsList", yearsList);
                        request.setAttribute("units", units);
                        if (clientWbo != null) {
                            request.setAttribute("clientWbo", clientWbo);
                        }
                        if (clientCompId != null && !clientCompId.equals("null")) {
                            request.setAttribute("clientCompId", clientCompId);
                        } else {
                            request.setAttribute("clientCompId", " ");
                        }
                        request.setAttribute("userId", userId);
                    } catch (Exception ex) {
                    }
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                default:
                    System.out.println("No operation was matched");
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
        return "Search Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.indexOf("ScheduleList") == 0) {
            return 1;
        }

        if (opName.indexOf("configureSchedule") == 0) {
            return 2;
        }

        if (opName.indexOf("saveItemization") == 0) {
            return 3;
        }

        if (opName.equals("createSchedule")) {
            return 4;
        }

        if (opName.equals("saveSchedule")) {
            return 5;
        }

        if (opName.equals("ScheduleUnits")) {
            return 6;
        }

        if (opName.equals("SaveScheduleUnits")) {
            return 7;
        }
        if (opName.equals("configureEmg")) {
            return 8;
        }
        if (opName.equals("ListEmergency")) {
            return 9;
        }

        if (opName.equals("UnitDetails")) {
            return 10;
        }
        if (opName.equals("configureEmgView")) {
            return 11;
        }
        if (opName.equals("configureView")) {
            return 12;
        }

        if (opName.equals("saveFlase")) {
            return 13;
        }

        if (opName.equals("ListScheduleUnits")) {
            return 14;
        }

        if (opName.equals("EditUnitSchedules")) {
            return 15;
        }

        if (opName.equals("Rules")) {
            return 16;
        }
        if (opName.equals("BindScheduleUnits")) {
            return 17;
        }
        if (opName.equals("ListAllSchedules")) {
            return 18;
        }
        if (opName.equals("ViewSchedule")) {
            return 19;
        }
        if (opName.equals("GetUpdateSchedule")) {
            return 20;
        }
        if (opName.equals("UpdateSchedule")) {
            return 21;
        }
        if (opName.equals("ConfirmDeleteSchedule")) {
            return 22;
        }
        if (opName.equals("DeleteSchedule")) {
            return 23;
        }

        if (opName.equals("CanotDel")) {
            return 24;
        }

        if (opName.equals("GetScheduleMainType")) {
            return 25;
        }
        if (opName.equals("SaveMainTypeSchedule")) {
            return 26;
        }
        if (opName.equals("ListHourlySchedule")) {
            return 27;
        }
        if (opName.equals("ViewHourlySchedule")) {
            return 28;
        }
        if (opName.equals("confirmDeleteHourlySchedule")) {
            return 29;
        }
        if (opName.equals("DeleteHourlySchedule")) {
            return 30;
        }
        if (opName.equals("UpdateHourlySchedule")) {
            return 31;
        }
        if (opName.equals("UpdateMainTypeSchedule")) {
            return 32;
        }
        if (opName.equals("ConfigureHourlySchedule")) {
            return 33;
        }
        if (opName.equals("SaveconfigMainTypeHourly")) {
            return 34;
        }
        if (opName.equals("ConfigureTimelySchedule")) {
            return 35;
        }
        if (opName.equals("ViewConfigureHourlySchedule")) {
            return 36;
        }
        if (opName.equals("GetAddListForm")) {
            return 37;
        }
        if (opName.equals("SaveList")) {
            return 38;
        }
        if (opName.equals("GetUpdateListForm")) {
            return 39;
        }
        if (opName.equals("UpdateList")) {
            return 40;
        }

        if (opName.equals("ListExternal")) {
            return 41;
        }

        if (opName.equals("GetTasksForm")) {
            return 42;
        }

        if (opName.equals("SaveTasks")) {
            return 43;
        }

        if (opName.equals("ListTasks")) {
            return 44;
        }

        if (opName.equals("ViewTask")) {
            return 45;
        }

        if (opName.equals("GetUpdateTaskForm")) {
            return 46;
        }

        if (opName.equals("UpdateTask")) {
            return 47;
        }

        if (opName.equals("ConfirmTaskDelete")) {
            return 48;
        }

        if (opName.equals("DeleteTask")) {
            return 49;
        }

        if (opName.equals("TimeScheduleList")) {
            return 50;
        }

        if (opName.equals("ListEqpSchedules")) {
            return 51;
        }

        if (opName.equals("Deleteview")) {
            return 52;
        }

        if (opName.equals("SaveSingleScheduleUnits")) {
            return 53;
        }

        if (opName.equals("BindSingleSchedUnit")) {
            return 54;
        }

        if (opName.equals("ExtentSchedule")) {
            return 55;
        }

        if (opName.equals("ChangeToExternal")) {
            return 56;
        }

        if (opName.equals("AddWorkersForm")) {
            return 57;
        }

        if (opName.equals("WorkersReport")) {
            return 58;
        }

        if (opName.equals("SaveWorkers")) {
            return 59;
        }

        if (opName.equals("configureEmgImage")) {
            return 66;
        }

        if (opName.equals("configureEmgImageJobs")) {
            return 67;
        }

        if (opName.equals("createEqpSchedule")) {
            return 68;
        }

        if (opName.equals("saveEqpSchedule")) {
            return 69;
        }

        if (opName.equals("ListSchedulesByCategoris")) {
            return 70;
        }

        if (opName.equals("ListSchedulesByEquipment")) {
            return 71;
        }

        if (opName.equals("ListAllEquipmentSchedules")) {
            return 72;
        }
        if (opName.equals("DeleteEquipmentSchedule")) {
            return 73;
        }
        if (opName.equals("find")) {
            return 74;
        }
        if (opName.equals("BindMaintanbleItems")) {
            return 75;
        }
        if (opName.equals("CancelBindMaintanbleItems")) {
            return 76;
        }

        if (opName.equals("viewConfg")) {
            return 77;
        }
        if (opName.equals("viewLabor")) {
            return 78;
        }
        if (opName.equals("getSchduleByName")) {
            return 79;
        }
        if (opName.equals("searchSchedule")) {
            return 80;
        }

        if (opName.equals("SearchScheduleTabForm")) {
            return 81;
        }

        if (opName.equals("DeleteReport")) {
            return 82;
        }

        if (opName.equals("SearchScheduleTab")) {
            return 83;
        }

        if (opName.equals("DisplySavedSchedule")) {
            return 84;
        }

        if (opName.equals("GetEqpScheduleCalendar")) {
            return 85;
        }
        if (opName.equals("createEqpScheduleByKel")) {
            return 86;
        }
        if (opName.equals("updateEmgorder")) {
            return 87;
        }
        if (opName.equals("readWorkerbyHR")) {
            return 88;
        }
        if (opName.equals("activateScheduleEqHR")) {
            return 89;
        }
        if (opName.equals("saveActiveSchedule")) {
            return 90;
        }
        if (opName.equalsIgnoreCase("listTasks")) {
            return 91;
        }
        if (opName.equalsIgnoreCase("MainTypeSchForm")) {
            return 92;
        }
        if (opName.equalsIgnoreCase("saveMainTypeSch")) {
            return 93;
        }
        if (opName.equalsIgnoreCase("BindSchMainCatType")) {
            return 94;
        }
        if (opName.equalsIgnoreCase("SaveMainCatSchUnits")) {
            return 95;
        }
        if (opName.equalsIgnoreCase("ListSchByMainCat")) {
            return 96;
        }
        if (opName.equalsIgnoreCase("ListAllMainCatSch")) {
            return 97;
        }
        if (opName.equalsIgnoreCase("assignCatSchToEqp")) {
            return 98;
        }
        if (opName.equalsIgnoreCase("saveMainCatSchToEqp")) {
            return 99;
        }
        if (opName.equalsIgnoreCase("viewPlanPopup")) {
            return 100;
        }
        if (opName.equalsIgnoreCase("ExtEqpSchedule")) {
            return 101;
        }
        if (opName.equalsIgnoreCase("searchSchBySubNamePopup")) {
            return 120;
        }
        if (opName.equalsIgnoreCase("searchSchBySubNamePopup")) {
            return 102;
        }
        if (opName.equalsIgnoreCase("DeleteEquipmentSchedules")) {
            return 103;
        }
        if (opName.equalsIgnoreCase("DeleteMainCatSch")) {
            return 104;
        }
        if (opName.equalsIgnoreCase("DeleteSchedules")) {
            return 105;
        }
        if (opName.equalsIgnoreCase("SearchTables")) {
            return 106;
        }
        if (opName.equalsIgnoreCase("SearchTablesEquip")) {
            return 107;
        }
        if (opName.equalsIgnoreCase("SearchEquip")) {
            return 108;
        }
        if (opName.equalsIgnoreCase("SearchEquipTables")) {
            return 109;
        }
        if (opName.equalsIgnoreCase("confirmDeleteSchedule")) {
            return 110;
        }
        if (opName.equalsIgnoreCase("deleteSchedule")) {
            return 111;
        }
        if (opName.equalsIgnoreCase("newJobOrder")) {
            return 112;
        }
        if (opName.equalsIgnoreCase("EditChangeToExternal")) {
            return 113;
        }
        if (opName.equalsIgnoreCase("rateType")) {
            return 114;
        }
        if (opName.equalsIgnoreCase("ListAll")) {
            return 115;
        }
        if (opName.equalsIgnoreCase("newScheduleForTimeEqp")) {
            return 116;
        }
        if (opName.equalsIgnoreCase("saveTimeEqpSchedule")) {
            return 117;
        }
        if (opName.equalsIgnoreCase("newScheduleForKMEqp")) {
            return 118;
        }
        if (opName.equalsIgnoreCase("checkDependency")) {
            return 119;
        }
        if (opName.equalsIgnoreCase("searchSchByDate")) {
            return 121;
        }
        if (opName.equalsIgnoreCase("ViewSchByToReview")) {
            return 122;
        }
        if (opName.equalsIgnoreCase("searchSchByDateToReview")) {
            return 123;
        }
        if (opName.equalsIgnoreCase("ViewScheduleSingle")) {
            return 124;
        }
        if (opName.equalsIgnoreCase("deleteSchedulesBeforeDate")) {
            return 125;
        }

        if (opName.equalsIgnoreCase("RequestItemsByBasicTypeAndSchedule")) {
            return 126;
        }

        if (opName.equalsIgnoreCase("GetRequestItemsByBasicType")) {
            return 127;
        }

        if (opName.equalsIgnoreCase("RequestItemsByModelAndSchedule")) {
            return 128;
        }

        if (opName.equalsIgnoreCase("GetRequestItemsByModel")) {
            return 129;
        }
        if (opName.equalsIgnoreCase("getUserAppointment")) {
            return 130;
        }

        if (opName.equalsIgnoreCase("fieldTechnicianCalendar")) {
            return 131;
        }
        if (opName.equalsIgnoreCase("showUserCalendar")) {
            return 132;
        }
        if (opName.equalsIgnoreCase("showCalendar")) {
            return 133;
        }
        return 0;
    }

    private void backToNewEquipmentSchedule(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("Status", "No");
        servedPage = "/ScheduleServlet?op=createEqpSchedule&unit=" + unitId;
        this.forward(servedPage, request, response);
    }
}
