package com.maintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.db_access.ActionTakenMgr;
import com.maintenance.db_access.AverageUnitMgr;
import com.maintenance.db_access.ReadingRateUnitMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.TaskTypeMgr;
import com.maintenance.db_access.UnitScheduleHistoryMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.tracker.db_access.IssueMgr;
import com.tracker.servlets.TrackerBaseServlet;

import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;
import com.SpareParts.db_access.*;
import com.maintenance.db_access.ConfigureMainTypeMgr;
import com.maintenance.db_access.IssueCounterReadingMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ScheduleTasksMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.persistence.relational.StringValue;

public class HoursWorkingEquipmentServlet extends TrackerBaseServlet {

    TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
    WebBusinessObject taskType;
    int totalReading = 0;
    int acualReading =0;
    int tempTotalReading = 0;
    String scheduleRateId;
    Vector lastSchedules = new Vector();

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
        WebBusinessObject Average = new WebBusinessObject();
        WebBusinessObject schedule = new WebBusinessObject();
        WebBusinessObject siteWbo = new WebBusinessObject();
        WebBusinessObject unitWbo = new WebBusinessObject();
        WebBusinessObject averageUpdate = new WebBusinessObject();
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        UnitScheduleHistoryMgr unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
        ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
        AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
        ActionTakenMgr actionTakenMgr = ActionTakenMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();

        switch (operation) {
            case 1:
                Vector frequncy = new Vector();
                Vector total = new Vector();
                String siteName = null;
                int frequncyRate = 0;
                int result = 0;

                String eqId = (String) request.getParameter("equipmentID");
                String backTo = (String) request.getParameter("backTo");

                Vector eqpsVec = new Vector();
                try {
                    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
                    String userId = securityUser.getUserId();
                    String searchBy = securityUser.getSearchBy();
                    String siteId = securityUser.getSiteId();

                    if ((userId.equals("1")) || (searchBy.equals("all"))) {
                        eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    } else {
                        eqpsVec = maintainableMgr.getEquipBySiteId(siteId);
                    }

                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                ArrayList eqpsArray = new ArrayList();
                for (int i = 0; i < eqpsVec.size(); i++) {
                    unitWbo = (WebBusinessObject) eqpsVec.get(i);
                    if (unitWbo.getAttribute("rateType").equals("By Hour")) {
                        eqpsArray.add(eqpsVec.get(i));
                    }
                }
                if (backTo != null) {
                    if (backTo.equalsIgnoreCase("viewEquipment")) {
                        request.setAttribute("equipmentId", eqId);
                        request.setAttribute("backTo", "viewEq");
                    } else {
                        if (null != request.getParameter("unitId")) {
                            unitWbo = maintainableMgr.getOnSingleKey(request.getParameter("unitId"));
                            if (unitWbo != null) {
                                request.setAttribute("unitWbo", unitWbo);
                                request.setAttribute("unitId", request.getParameter("unitId").toString());
                            }
                        } else {
                            request.setAttribute("viewDefualt", "ok");
                        }
                    }
                } else {
                    if (null != request.getParameter("unitId")) {
                        unitWbo = maintainableMgr.getOnSingleKey(request.getParameter("unitId"));
                        if (unitWbo != null) {
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unitId", request.getParameter("unitId").toString());
                        }
                    } else {
                        request.setAttribute("viewDefualt", "ok");
                    }
                }

                String equipUnit = (String) unitWbo.getAttribute("id");

                // create Dynamic Menu In Left Side
                String tempUnitId = eqId;
                if (tempUnitId == null) {
                    tempUnitId = request.getParameter("unitId");
                }

                Vector allSchedule = new Vector();
                if (request.getAttribute("viewDefualt") == null) {
                    lastSchedules = getScheduleIdsDeserv(equipUnit, "1", session);

                    try {
                        unitWbo = maintainableMgr.getOnSingleKey(tempUnitId);
                        allSchedule = scheduleMgr.getAllScheduleForEquipmentAndMainTypeEquip(unitWbo);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }

                request.setAttribute("allSchedule", allSchedule);
                request.setAttribute("displayForm", "enable");
                request.setAttribute("equipments", eqpsArray);
                request.setAttribute("lastScheduls", lastSchedules);
                servedPage = "/docs/schedule/edit_average_unit.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                WebBusinessObject wboActionTaken;
                unitWbo = new WebBusinessObject();
                totalReading = 0;
                scheduleRateId = null;
                String resultTempString = "0";
                maintainableMgr = MaintainableMgr.getInstance();
                lastSchedules = new Vector();
                Average = new WebBusinessObject();
                wboActionTaken = new WebBusinessObject();
                String checkUpdate = null;
                equipUnit = request.getParameter("unitId");
                boolean isViewSchedule = false;

//                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
//                    servedPage = "/docs/schedule/edit_average_kel_unit.jsp";
//                } else {
//                    unitWbo = maintainableMgr.getOnSingleKey(equipUnit);
//                    servedPage = "/docs/schedule/edit_average_unit.jsp";
//                }
                servedPage = "/docs/schedule/edit_average_whichCloser_unit.jsp";
                Average.setAttribute("current_Reading", request.getParameter("current_Reading"));
               // Average.setAttribute("total", request.getParameter("total"));
                Average.setAttribute("description", request.getParameter("description"));
                String entryTime = new String();
                entryTime = request.getParameter("datepi");
                Date date = new Date();
                Long longDate = null;
                if(entryTime == null || entryTime.equals("")){
                    longDate = date.getTime();
                } else {
                    date = new Date(entryTime);
                    longDate = date.getTime();
                }
                Average.setAttribute("date", longDate.toString());
                Average.setAttribute("unit", request.getParameter("unitId"));
                checkUpdate = averageUnitMgr.getTrueUpdate(request.getParameter("unitId"));

                long now = timenow();

                if (checkUpdate != null) {
                    averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
                    String prevDate = (String) averageUpdate.getAttribute("entry_Time");
                    if (averageUnitMgr.updateAverage(Average, averageUpdate, prevDate, now)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } else {
                    try {
                        if (averageUnitMgr.saveObject(Average, session, now)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (NoUserInSessionException noUser) {
                        logger.error("Place Servlet: save place " + noUser);
                    }
                }
                //// BEGIN  ///
                try {
                    total = averageUnitMgr.getOnArbitraryKey(equipUnit, "key1");
                    for (int i = 0; i < total.size(); i++) {
                        Average = (WebBusinessObject) total.elementAt(i);
                    }
                    if (Average.getAttribute("current_Reading") != null) {
                        Integer iTemp = new Integer(Average.getAttribute("current_Reading").toString());
                        totalReading = iTemp.intValue();
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                ////////// Add Auto Creation job order Code Flag //////
                     ServletContext context = getServletContext();
                     String autoCreate = context.getInitParameter("autoCreateJobOrder");
                //////////////////////////////////////////////////////
                try {
                    unitWbo = maintainableMgr.getOnSingleKey(equipUnit);
                    Vector schedules = scheduleMgr.getAllScheduleByTimeOnEquipmentByDirectAndInDirect(equipUnit, (String) unitWbo.getAttribute("parentId"), (String) unitWbo.getAttribute("maintTypeId"));
                    for (int i = 0; i < schedules.size(); i++) {
                        try {
                            schedule = (WebBusinessObject) schedules.elementAt(i);
                            if (schedule.getAttribute("whichCloser") != null) {
                                Integer rateTemp = new Integer(schedule.getAttribute("whichCloser").toString());
                                frequncyRate = rateTemp.intValue();
                                IssueCounterReadingMgr issueCounterByUnitMgr = IssueCounterReadingMgr.getInstance();
                                Vector issueCountUnitV = new Vector();
                                String[] keys = new String[2];
                                String[] values = new String[2];
                                values[0] = schedule.getAttribute("periodicID").toString();
                                values[1] = unitWbo.getAttribute("id").toString();
                                keys[0] = "key1";
                                keys[1] = "key2";
                                issueCountUnitV = issueCounterByUnitMgr.getOnArbitraryNumberKeyOrdered(2,values, keys,"key");
                                WebBusinessObject issueCountReadWbo = null;
                                tempTotalReading=0;
                                
                                if (issueCountUnitV.size() > 0) {
                                        issueCountReadWbo = new WebBusinessObject();
                                        issueCountReadWbo = (WebBusinessObject) issueCountUnitV.get(issueCountUnitV.size()-1);
                                        tempTotalReading = new Integer(issueCountReadWbo.getAttribute("counterReading").toString());
                                }
                                
                                //result = totalReading / frequncyRate;
                                int tempResult =0;
                                int rateJob=0;
                                if(tempTotalReading>0 ){
                                    tempResult = tempTotalReading / frequncyRate;
                                    result = totalReading / frequncyRate;
                                }else{
                                    result = totalReading / frequncyRate;
                                }

                                ////////// Check and Update error rate for counter job order//////
//                                Vector unitScheduleHistoryV = new Vector();
//                                boolean addSchedule=false;
//                                if(autoCreate != null && !autoCreate.equals("") && autoCreate.equals("1")){
//                                    values[0] = unitWbo.getAttribute("id").toString();
//                                    values[1] = schedule.getAttribute("periodicID").toString();
//                                    keys[0] = "key1";
//                                    keys[1] = "key2";
//                                    unitScheduleHistoryV = unitScheduleHistoryMgr.getOnArbitraryNumberKeyOrdered(2,values, keys,"key");
//                                  
//                                }
                                //

                                // set wboActionTaken to save Action Taken Table
                                wboActionTaken.setAttribute("readingCounter", String.valueOf(totalReading));
                                wboActionTaken.setAttribute("unitId", (String) Average.getAttribute("unitName"));
                                wboActionTaken.setAttribute("scheduleId", (String) schedule.getAttribute("periodicID"));
                                wboActionTaken.setAttribute("rateNo", String.valueOf(result));

                                siteWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipUnit);
                                siteName = siteWbo.getAttribute("site").toString();

                                if (result > 0) {
                                    if (unitScheduleHistoryMgr.checkScheduleExist(equipUnit, schedule.getAttribute("periodicID").toString())) {
                                        unitScheduleHistoryMgr.updateScheduleExist(equipUnit, schedule.getAttribute("periodicID").toString(), result);
                                        scheduleRateId = unitScheduleHistoryMgr.getScheduleRateId(equipUnit, schedule.getAttribute("periodicID").toString());
                                        if(autoCreate != null && !autoCreate.equals("") && autoCreate.equals("1")){
                                            if(result>tempResult){
                                                lastSchedules.add(scheduleRateId);
                                            }
                                        }else{
                                            if (isViewSchedule = unitScheduleHistoryMgr.ViewSchedule(equipUnit, schedule.getAttribute("periodicID").toString())) {
                                            lastSchedules.add(scheduleRateId);
                                            }
                                        }

                                    } else {
                                        String saveStatus = unitScheduleHistoryMgr.saveInHistoryUnitSchedule(schedule, Average, session, result);
                                        if (!saveStatus.equalsIgnoreCase("saveFail")) {
                                            if(autoCreate != null && !autoCreate.equals("") && autoCreate.equals("1")){
                                            if(result>tempResult){
                                                lastSchedules.add(scheduleRateId);
                                            }
                                        }else{
                                            if (isViewSchedule = unitScheduleHistoryMgr.ViewSchedule(equipUnit, schedule.getAttribute("periodicID").toString())) {
                                                lastSchedules.add(saveStatus);
                                            }
                                            }
                                        }
                                    }
                                    // save Defualt Row in Action Taken Table action type become 'NO ACTION'
                                    if (scheduleRateId != null && isViewSchedule) { // becouse var scheduleRateId is null no insert in Unit_Schedule_History and no update occure
                                        // set wboActionTaken to save Action Taken Table
                                        wboActionTaken.setAttribute("historyId", scheduleRateId);
                                        actionTakenMgr.saveActionTaken(wboActionTaken, session);
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                /// End  ///
                String backToform = (String) request.getParameter("backTo");
                if (backToform != null) {
                    request.setAttribute("backTo", (String) request.getParameter("backTo"));
                    request.setAttribute("equipmentId", (String) request.getParameter("unitId"));
                } else {
                    if (null != request.getParameter("unitId")) {
                        unitWbo = maintainableMgr.getOnSingleKey(request.getParameter("unitId"));
                        if (unitWbo != null) {
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unitId", request.getParameter("unitId").toString());
                        }
                    }
                }

                ////////// Add Auto Creation job order Code  //////
               

                if(autoCreate != null && !autoCreate.equals("") && autoCreate.equals("1")){
                    if(lastSchedules.size()>0){
                        if(lastSchedules.size()>10){
                            request.setAttribute("overFlow", "yes");
                            request.setAttribute("lastScheduls", lastSchedules);
                        }else{
                            request.setAttribute("unitId", equipUnit);
                            siteWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipUnit);
                            siteName = siteWbo.getAttribute("site").toString();
                            request.setAttribute("siteName", siteName);
                            String sMSG = getAutoCreateJobOrder(request, response,lastSchedules);
                            request.setAttribute("overFlow", "no");
                        }
                   }
                }else{
                    request.setAttribute("lastScheduls", lastSchedules);
                }

                /////////    End Code ////////////////////////////
                
                request.setAttribute("displayForm", "disaple");
                request.setAttribute("equipUnit", equipUnit);
                
                request.setAttribute("scheduleNo", resultTempString);
                // to Determin Im go to after update hours or not
                request.setAttribute("actionTaken", "ok");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                Vector listIdsOfJobOrder = new Vector();
                Vector listOfJobOrder = new Vector();
                String unitScheduleId = null;
                String schedulefalag = null;
                String unitName;
                String actionTaken = request.getParameter("actionTaken");
                WebBusinessObject unitScheduleRecord = new WebBusinessObject();

                unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
                WebBusinessObject unitScheduleHistoryWbo = new WebBusinessObject();
                String scheduleId = null;
                String lastFilter;

                schedule = new WebBusinessObject();
                WebBusinessObject issue = null;
                equipUnit = request.getParameter("unitId");
                siteName = request.getParameter("siteName");
                String[] schIdsArr = request.getParameterValues("scheduleId");
                for (int j = 0; j < schIdsArr.length; j++) {
                    issue = new WebBusinessObject();
                    unitScheduleId = schIdsArr[j];
                    unitScheduleHistoryWbo = unitScheduleHistoryMgr.getOnSingleKey(unitScheduleId);
                    try {
                        scheduleId = issueMgr.saveInUnitSchedule(unitScheduleHistoryWbo);
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    }

                    if (!scheduleId.equalsIgnoreCase("saveFail")) {
                        unitScheduleRecord = unitScheduleHistoryMgr.getOnSingleKey(unitScheduleId);
                        schedule = scheduleMgr.getOnSingleKey(unitScheduleRecord.getAttribute("periodicId").toString());
                        issue.setAttribute("maintenanceTitle", unitScheduleRecord.getAttribute("maintenanceTitle").toString());
                        issue.setAttribute("workTrade", schedule.getAttribute("workTrade").toString());
                        issue.setAttribute("duration", schedule.getAttribute("duration").toString());
                        issue.setAttribute("id", unitScheduleRecord.getAttribute("id").toString());

                        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                        String newUnitScheduleId = scheduleId;
                        try {
                            String issueId = issueMgr.saveKilSchedule2(issue, equipUnit, session, siteName, newUnitScheduleId);
                            ScheduleTasksMgr scheduleTMgr = ScheduleTasksMgr.getInstance();

                            Vector scTasks = new Vector();
                            String schId = unitScheduleHistoryWbo.getAttribute("periodicId").toString();
                            try {
                                scTasks = scheduleTMgr.getOnArbitraryKey(schId, "key1");
                                StringValue issue_Id = new StringValue(issueId);
                                issueMgr.saveIssueTasks(issue_Id, scTasks);

                                /****************** Transfer Schedule Parts To Issues ***********************/
                                ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                                Vector schParts = configureMainTypeMgr.getOnArbitraryKey(schId, "key1");

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
                                QntfMntncMgr.saveObject2(quantity, price, cost, note, ids, newUnitScheduleId, isDirectPrch, attachedOn, session);

                            } catch (SQLException ex) {
                                Logger.getLogger(HoursWorkingEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(HoursWorkingEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                            if (!issueId.equalsIgnoreCase("saveFail")) {
                                // add this issueId to list of Issue
                                listIdsOfJobOrder.add(issueId);
                                schedulefalag = "scheduled";
                                // to Update Action Taken by Issue
                                if (actionTaken.equalsIgnoreCase("ok")) {
                                    WebBusinessObject wbo = new WebBusinessObject();
                                    wbo.setAttribute("readingCounter", request.getParameter("totalCount"));
                                    wbo.setAttribute("historyId", unitScheduleId);
                                    wbo.setAttribute("issueId", issueId);

                                    actionTakenMgr.updateActionTakenAsIssue(wbo);
                                    // to Determin Im go to after update hours or not
                                    request.setAttribute("actionTaken", "ok");
                                }
                                // update job order job order rate in unit schedule history
                                unitScheduleHistoryMgr.updateJobOrderRate(unitScheduleId);

                                // update Reading Rate Unit by Issue
                                WebBusinessObject wboReadingRateUnit = new WebBusinessObject();
                                wboReadingRateUnit.setAttribute("issueId", issueId);
                                wboReadingRateUnit.setAttribute("unitId", equipUnit);
                                wboReadingRateUnit.setAttribute("readingCounter", request.getParameter("totalCount"));
                                readingRateUnitMgr.updateReadingRateUnitAsIssue(wboReadingRateUnit);
                            } else {
                                schedulefalag = "notscheduled";
                            }
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex.getMessage());
                            schedulefalag = "notscheduled";
                        }
                    } else {
                        schedulefalag = "notscheduled";
                    }
                }

                // craete top Menu
                unitName = maintainableMgr.getUnitName(equipUnit);
                if (actionTaken.equalsIgnoreCase("ok")) {
                    lastFilter = "HoursWorkingEquipmentServlet?op=getLastIssuesByAction" + "&tableName=ActionTaken" + "&unitId=" + equipUnit + "&readingCounter=" + request.getParameter("totalCount") + "&unitName=" + unitName;
                } else {
                    String maxIssueId = (String) listIdsOfJobOrder.get(listIdsOfJobOrder.size() - 1);
                    String minIssueId = (String) listIdsOfJobOrder.get(0);
                    lastFilter = "HoursWorkingEquipmentServlet?op=getLastIssuesByAction" + "&tableName=Issue" + "&maxIssueId=" + maxIssueId + "&minIssueId=" + minIssueId + "&unitName=" + unitName;
                }
                createTopMenu(request, lastFilter, session);

                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
                    servedPage = "/docs/schedule/edit_schedule_kil_unit.jsp";
                } else {
                    servedPage = "/docs/schedule/edit_schedule_hr_unit.jsp";
                }

                // get all Issue that Inserted Now In Issue
                listOfJobOrder = issueMgr.getAllIssueByIds(listIdsOfJobOrder);

                request.setAttribute("schedulefalag", schedulefalag);
                request.setAttribute("listIssues", listOfJobOrder);
                request.setAttribute("unitId", equipUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                wboActionTaken = new WebBusinessObject();
                unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
                unitScheduleHistoryWbo = new WebBusinessObject();
                actionTaken = request.getParameter("actionTaken");
                scheduleId = null;
                schedulefalag = null;
                schedule = new WebBusinessObject();
                siteName = request.getParameter("siteName");
                equipUnit = request.getParameter("unitId");
                String[] checkCanceledSchedule = request.getParameterValues("cancelscheduleId");
                String[] cancelReasons = request.getParameterValues("reason");
                String tempreason = "";

                for (int i = 0; i < checkCanceledSchedule.length; i++) {
                    scheduleId = checkCanceledSchedule[i];
                    unitScheduleHistoryWbo = unitScheduleHistoryMgr.getOnSingleKey(scheduleId);
                    try {
                        tempreason = cancelReasons[i];
                        if (tempreason == null || tempreason.equalsIgnoreCase("")) {
                            tempreason = "No Notes";
                        }

                        if (actionTaken.equalsIgnoreCase("ok")) {
                            // to Update Action Taken by Cancel
                            wboActionTaken = new WebBusinessObject();
                            wboActionTaken.setAttribute("readingCounter", request.getParameter("totalCount"));
                            wboActionTaken.setAttribute("historyId", scheduleId);
                            wboActionTaken.setAttribute("cancelReason", tempreason);
                            actionTakenMgr.updateActionTakenAsCancel(wboActionTaken);

                            // to Determin Im go to after update hours or not
                            request.setAttribute("actionTaken", "ok");
                        }
                        // update job order job order rate in unit schedule history
                        if (unitScheduleHistoryMgr.updateCancelRate(scheduleId)) {
                            request.setAttribute("cancelStatus", "ok");
                        } else {
                            request.setAttribute("cancelStatus", "fail");
                        }
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }
                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
                    servedPage = "/docs/schedule/edit_schedule_kil_unit.jsp";
                } else {
                    servedPage = "/docs/schedule/edit_schedule_hr_unit.jsp";
                }

                request.setAttribute("totalCount", request.getParameter("totalCount"));
                request.setAttribute("beginScheduleDate", request.getParameter("beginScheduleDate"));

                request.setAttribute("unitId", equipUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                lastSchedules = new Vector();
                MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
                String userId = securityUser.getUserId();
                String searchBy = securityUser.getSearchBy();
                String siteId = securityUser.getSiteId();
                resultTempString = "0";
                eqId = (String) request.getParameter("equipmentID");
                backTo = (String) request.getParameter("backto");
                String unitId = request.getParameter("unitId");
                unitWbo = new WebBusinessObject();
                if (backTo != null) {
                    if (backTo.equalsIgnoreCase("viewEquipment")) {
                        request.setAttribute("equipmentId", eqId);
                        request.setAttribute("backTo", "viewEq");
                    } else {
                        if (null != unitId) {
                            unitWbo = maintainableMgr.getOnSingleKey(unitId);
                            if (unitWbo != null) {
                                request.setAttribute("unitWbo", unitWbo);
                                request.setAttribute("unitId", unitId);
                            }
                        } else {
                            request.setAttribute("viewDefualt", "ok");
                        }
                    }
                } else {
                    if (null != unitId) {
                        unitWbo = maintainableMgr.getOnSingleKey(unitId);
                        if (unitWbo != null) {
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unitId", unitId);
                        }
                    } else {
                        request.setAttribute("viewDefualt", "ok");
                    }
                }
                eqpsVec = new Vector();
                try {
                    eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                eqpsArray = new ArrayList();
                for (int i = 0; i < eqpsVec.size(); i++) {
                    unitWbo = (WebBusinessObject) eqpsVec.get(i);
                    if (unitWbo.getAttribute("rateType").equals("odometer")) {
                        eqpsArray.add(eqpsVec.get(i));
                    }
                }
                if (unitId != null) {
                    request.setAttribute("unitRate", mainCategoryTypeMgr.getOnSingleKey(unitWbo.getAttribute("maintTypeId").toString()).getAttribute("basicCounter"));
                }

                tempUnitId = eqId;
                if (tempUnitId == null) {
                    tempUnitId = unitId;
                }
                totalReading = 0;
                scheduleRateId = null;
                ////////// Add Auto Creation job order Code  //////
                context = getServletContext();
                autoCreate = context.getInitParameter("autoCreateJobOrder");

                if(autoCreate != null && !autoCreate.equals("") && autoCreate.equals("0")){
                lastSchedules = getScheduleIdsDeservCloser(tempUnitId, session);
                }

                // create Dynamic Menu In Left Side
//                if(tempUnitId != null)
//                    createSideMenuForEquipment(request, tempUnitId);
                allSchedule = new Vector();
                if (request.getAttribute("viewDefualt") == null) {
                    try {
                        unitWbo = maintainableMgr.getOnSingleKey(tempUnitId);
                        allSchedule = scheduleMgr.getAllScheduleForEquipmentAndMainTypeEquip(unitWbo);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }

                

                request.setAttribute("allSchedule", allSchedule);
                request.setAttribute("lastScheduls", lastSchedules);
                request.setAttribute("equipments", eqpsArray);
                request.setAttribute("displayForm", "enable");
                servedPage = "/docs/schedule/edit_average_whichCloser_unit.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 6:
                unitId = request.getParameter("unitId");
                String readingCounter = request.getParameter("readingCounter");
                String maxIssueId = request.getParameter("maxIssueId");
                String minIssueId = request.getParameter("minIssueId");
                String tableName = request.getParameter("tableName");
                unitName = request.getParameter("unitName");
                Vector listIssues = new Vector();

                if (tableName.equalsIgnoreCase("ActionTaken")) {
                    Vector issueIds = actionTakenMgr.getLastIssueByAction(unitId, readingCounter);
                    listIssues = issueMgr.getAllIssueByIds(issueIds);
                } else {
                    listIssues = issueMgr.getIssueByMinMaxId(minIssueId, maxIssueId);
                }

                request.setAttribute("listIssues", listIssues);
                request.setAttribute("unitName", unitName);
                servedPage = "/docs/schedule/view_last_issue_by_action.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                servedPage = "/docs/Search/operating_report.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                unitId = request.getParameter("unitId");
                unitName = request.getParameter("unitName");
                String beginDate = request.getParameter("beginDate");
                String endDate = request.getParameter("endDate");
                Vector allReading = readingRateUnitMgr.getHistoryReadingCounter(unitId, beginDate, endDate);

                String typeRate = maintainableMgr.getUnitType(unitId);

                request.setAttribute("unitName", unitName);
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("allReading", allReading);
                request.setAttribute("typeRate", typeRate);
                servedPage = "/docs/reports/view_operating_report.jsp";
                this.forward(servedPage, request, response);
                break;

            case 10:
                servedPage = "/docs/new_report/equipments_list.jsp";
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                siteId = securityUser.getSiteId();
                userId = securityUser.getUserId();
                searchBy = securityUser.getSearchBy();
                String typeOfRate = request.getParameter("typeOfRate");
                String reloadOp = request.getParameter("reloadOp");

                unitName = (String) request.getParameter("unitName");
                String formName = (String) request.getParameter("formName");
                String ok = request.getParameter("ok");
//                if(ok!=null && ok.trim().equalsIgnoreCase("ok"))
//                {
//                    request.setAttribute("okStatus","ok");
//                }
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
                String url = "HoursWorkingEquipmentServlet?op=listEquipmentBySite&typeOfRate=" + typeOfRate;
                try {
                    if (unitName != null && !unitName.equals("")) {
                        if ((userId.equals("1")) || (searchBy.equals("all"))) {
                            categoryTemp = maintainableMgr.getEquipBySubName(unitName);
                        } else {
                            categoryTemp = maintainableMgr.getEquipBySubNameAndSiteId(siteId, unitName);
                        }
                    } else {
                        if ((userId.equals("1")) || (searchBy.equals("all"))) {
                            categoryTemp = maintainableMgr.getOnArbitraryDoubleKeyOracle("1", "key3", "0", "key5");
                        } else {
                            categoryTemp = maintainableMgr.getEquipBySiteId(siteId);
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                eqpsArray = new ArrayList();
                if (!typeOfRate.equals("all")) {
                    for (int i = 0; i < categoryTemp.size(); i++) {
                        unitWbo = (WebBusinessObject) categoryTemp.get(i);
                        if (unitWbo.getAttribute("rateType").equals(typeOfRate)) {
                            eqpsArray.add(categoryTemp.get(i));
                        }
                    }
                } else {
                    for (int i = 0; i < categoryTemp.size(); i++) {
                        unitWbo = (WebBusinessObject) categoryTemp.get(i);
                        eqpsArray.add(categoryTemp.get(i));
                    }
                }
                String tempcount = request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                Vector category = new Vector();

                int index = (count + 1) * 10;
                WebBusinessObject wbo;
                if (eqpsArray.size() < index) {
                    index = eqpsArray.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) eqpsArray.get(i);
                    category.add(wbo);
                }

                float noOfLinks = eqpsArray.size() / 10f;
                String temp = "" + noOfLinks;
                int intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                int links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }
                // to reload current parant
                if (reloadOp != null) {
                    String reloadUrl = "HoursWorkingEquipmentServlet?op=" + reloadOp;
                    request.setAttribute("reload", "ok");
                    request.setAttribute("reloadUrl", reloadUrl);
                    url += "&reloadOp=" + reloadOp;
                }
                session.removeAttribute("CategoryID");

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);
                request.setAttribute("data", category);
                this.forward(servedPage, request, response);
                break;

            case 11:
                servedPage = "ReportsServletThree?op=searchEquipmentsNotUpdated";
                request.setAttribute("source", "getUpdateReadingsOfEquipmentsForm");
                this.forward(servedPage, request, response);
                break;

            case 12:
                Average = new WebBusinessObject();
                checkUpdate = null;
                Vector vec = new Vector();

                servedPage = "ReportsServletThree?op=resultSearchEquipmentsNotUpdated";
                String[] newReadings = request.getParameterValues("newReading");
                String[] unitNumbers = request.getParameterValues("updateReading");
                if (unitNumbers != null) {
                    int updatedEquips = 0;
                    for (int i = 0; i < unitNumbers.length; i++) {
                        try {
                            vec = averageUnitMgr.getOnArbitraryKey(unitNumbers[i], "key1");
                            averageUpdate = (WebBusinessObject) vec.get(0);
                        } catch (SQLException ex) {
                            Logger.getLogger(HoursWorkingEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(HoursWorkingEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        Average.setAttribute("current_Reading", newReadings[i]);
                        Average.setAttribute("description", (String) averageUpdate.getAttribute("description"));
                        Average.setAttribute("unit", unitNumbers[i]);

                        now = timenow();

                        String prevDate = (String) averageUpdate.getAttribute("entry_Time");
                        if (averageUnitMgr.updateAverage(Average, averageUpdate, prevDate, now)) {
                            updatedEquips++;
                        }

                    }
                    if (updatedEquips > 0) {
                        request.setAttribute("status", "Ok");
                        request.setAttribute("updatedEquips", updatedEquips);
                    } else {
                        request.setAttribute("status", "No");
                    }
                }
                this.forward(servedPage, request, response);
                break;

            case 13:

                servedPage = "/docs/Adminstration/set_foundation_specification_for_external_transactions.jsp";
                ERPStorTrnsMgr erpStorTrnsMgr = ERPStorTrnsMgr.getInstance();
                Vector ERPTransactions = erpStorTrnsMgr.getAllTransactionsFromERP();
                SpecsOutTrnsMgr specsOutTrnsMgr = SpecsOutTrnsMgr.getInstance();

                Vector specsWboVec = specsOutTrnsMgr.getCashedTable();
                String update = "no";

                if (specsWboVec != null && specsWboVec.size() > 0) {
                    update = "yes";
                    String requestType, fromSide, toSide, fromCode, toCode;

                    for (int i = 0; i < specsWboVec.size(); i++) {
                        wbo = (WebBusinessObject) specsWboVec.get(i);

                        fromSide = (String) wbo.getAttribute("fromSide");

                        if (fromSide.equals("store")) {
                            wbo.setAttribute("fromCode", "");

                        } else {

                            fromCode = fromSide.substring(2);
                            fromSide = "department";

                            wbo.setAttribute("fromSide", fromSide);
                            wbo.setAttribute("fromCode", fromCode);

                        }

                        toSide = (String) wbo.getAttribute("toSide");

                        if (toSide.equals("store")) {
                            wbo.setAttribute("toCode", "");

                        } else {

                            toCode = toSide.substring(2);
                            toSide = "department";

                            wbo.setAttribute("toSide", toSide);
                            wbo.setAttribute("toCode", toCode);
                        }

                        requestType = (String) wbo.getAttribute("requestType");
                        if (requestType.equals("sub")) {
                            request.setAttribute("dismissWbo", wbo);
                        } else {
                            request.setAttribute("returnWbo", wbo);
                        }

                    }

                }

                request.setAttribute("update", update);
                request.setAttribute("ERPTransactions", new ArrayList(ERPTransactions));
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;

            case 14:

//                servedPage = "/docs/Adminstration/set_foundation_specification_for_external_transactions.jsp";

                servedPage = "HoursWorkingEquipmentServlet?op=getFoundationSpecificationForExternalTransactionsForm";
                erpStorTrnsMgr = ERPStorTrnsMgr.getInstance();
                ERPTransactions = erpStorTrnsMgr.getAllTransactionsFromERP();
                specsOutTrnsMgr = SpecsOutTrnsMgr.getInstance();

                update = request.getParameter("update");

                WebBusinessObject dismissWbo = new WebBusinessObject();
                WebBusinessObject returnWbo = new WebBusinessObject();

                String dismissTrnsCode = request.getParameter("dismissTrnsCode");
                String returnTrnsCode = request.getParameter("returnTrnsCode");

                String dismissFromSide = request.getParameter("dismiss_from_side");
                String dismissToSide = request.getParameter("dismiss_to_side");

                String returnFromSide = request.getParameter("return_from_side");
                String returnToSide = request.getParameter("return_to_side");

                String dismissFromCode = request.getParameter("dismiss_from_code");
                String dismissToCode = request.getParameter("dismiss_to_code");

                String returnFromCode = request.getParameter("return_from_code");
                String returnToCode = request.getParameter("return_to_code");

                /* prepare dismiss WBO */
                if (update.equals("yes")) {
                    dismissWbo.setAttribute("id", request.getParameter("dismissId"));
                }

                dismissWbo.setAttribute("trnsCode", dismissTrnsCode);
                dismissWbo.setAttribute("requestType", "sub");

                if (dismissFromSide.equals("store")) {
                    dismissWbo.setAttribute("fromSide", "store");
                } else {
                    dismissWbo.setAttribute("fromSide", "6-" + dismissFromCode);
                }

                if (dismissToSide.equals("store")) {
                    dismissWbo.setAttribute("toSide", "store");
                } else {
                    dismissWbo.setAttribute("toSide", "6-" + dismissToCode);
                }

                /* - */

                /* prepare return WBO */
                if (update.equals("yes")) {
                    returnWbo.setAttribute("id", request.getParameter("returnId"));
                }

                returnWbo.setAttribute("trnsCode", returnTrnsCode);
                returnWbo.setAttribute("requestType", "ret");

                if (returnFromSide.equals("store")) {
                    returnWbo.setAttribute("fromSide", "store");
                } else {
                    returnWbo.setAttribute("fromSide", "6-" + returnFromCode);
                }

                if (returnToSide.equals("store")) {
                    returnWbo.setAttribute("toSide", "store");
                } else {
                    returnWbo.setAttribute("toSide", "6-" + returnToCode);
                }

                /* - */
                Vector wboVec = new Vector();
                wboVec.add(dismissWbo);
                wboVec.add(returnWbo);
                try {

//                    if (specsOutTrnsMgr.saveObject(dismissWbo, session) &&
//                            specsOutTrnsMgr.saveObject(returnWbo, session)) {
//                        request.setAttribute("status", "ok");
//                    } else {
//                        request.setAttribute("status", "no");
//                    }

                    if (specsOutTrnsMgr.saveObject(wboVec, update, session)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "no");
                    }

                } catch (SQLException ex) {
                    Logger.getLogger(HoursWorkingEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

//                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 15:
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                userId = securityUser.getUserId();
                searchBy = securityUser.getSearchBy();
                siteId = securityUser.getSiteId();
                resultTempString = "0";
                eqId = (String) request.getParameter("equipmentID");
                backTo = (String) request.getParameter("backto");
                unitId = request.getParameter("unitId");
                unitWbo = new WebBusinessObject();
                if (backTo != null) {
                    if (backTo.equalsIgnoreCase("viewEquipment")) {
                        request.setAttribute("equipmentId", eqId);
                        request.setAttribute("backTo", "viewEq");
                    } else {
                        if (null != unitId) {
                            unitWbo = maintainableMgr.getOnSingleKey(unitId);
                            if (unitWbo != null) {
                                request.setAttribute("unitWbo", unitWbo);
                                request.setAttribute("unitId", unitId);
                            }
                        } else {
                            request.setAttribute("viewDefualt", "ok");
                        }
                    }
                } else {
                    if (null != unitId) {
                        unitWbo = maintainableMgr.getOnSingleKey(unitId);
                        if (unitWbo != null) {
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unitId", unitId);
                        }
                    } else {
                        request.setAttribute("viewDefualt", "ok");
                    }
                }
                eqpsVec = new Vector();
                try {
                    eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                eqpsArray = new ArrayList();
                for (int i = 0; i < eqpsVec.size(); i++) {
                    unitWbo = (WebBusinessObject) eqpsVec.get(i);
                    if (unitWbo.getAttribute("rateType").equals("odometer")) {
                        eqpsArray.add(eqpsVec.get(i));
                    }
                }

                tempUnitId = eqId;
                if (tempUnitId == null) {
                    tempUnitId = unitId;
                }
                totalReading = 0;
                scheduleRateId = null;
                lastSchedules = getScheduleIdsDeserv(tempUnitId, "2", session);

                // create Dynamic Menu In Left Side
//                if(tempUnitId != null)
//                    createSideMenuForEquipment(request, tempUnitId);
                allSchedule = new Vector();
                if (request.getAttribute("viewDefualt") == null) {
                    try {
                        unitWbo = maintainableMgr.getOnSingleKey(tempUnitId);
                        allSchedule = scheduleMgr.getAllScheduleForEquipmentAndMainTypeEquip(unitWbo);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }

                request.setAttribute("allSchedule", allSchedule);
                request.setAttribute("lastScheduls", lastSchedules);
                request.setAttribute("equipments", eqpsArray);
                request.setAttribute("displayForm", "enable");
                servedPage = "/docs/schedule/edit_average_kel_unit.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 16:
                unitWbo = new WebBusinessObject();
                totalReading = 0;
                scheduleRateId = null;
                resultTempString = "0";
                maintainableMgr = MaintainableMgr.getInstance();
                lastSchedules = new Vector();
                Average = new WebBusinessObject();
                wboActionTaken = new WebBusinessObject();
                checkUpdate = null;
                equipUnit = request.getParameter("unitId");

                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
                    servedPage = "/docs/schedule/edit_average_kel_unit.jsp";
                } else {
                    unitWbo = maintainableMgr.getOnSingleKey(equipUnit);
                    servedPage = "/docs/schedule/edit_average_unit.jsp";
                }

                Average.setAttribute("current_Reading", request.getParameter("current_Reading"));
                Average.setAttribute("description", request.getParameter("description"));
                Average.setAttribute("unit", request.getParameter("unitId"));

                entryTime = new String();
                entryTime = request.getParameter("datepi");
                date = new Date();
                if(entryTime == null || entryTime.equals("")){
                    longDate = date.getTime();
                } else {
                    date = new Date(entryTime);
                    longDate = date.getTime();
                }
                Average.setAttribute("date", longDate.toString());
                checkUpdate = averageUnitMgr.getTrueUpdate(request.getParameter("unitId"));

                now = timenow();

                if (checkUpdate != null) {
                    averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
                    String prevDate = (String) averageUpdate.getAttribute("entry_Time");
                    if (averageUnitMgr.updateAverage(Average, averageUpdate, prevDate, now)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } else {
                    try {
                        if (averageUnitMgr.saveObject(Average, session, now)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (NoUserInSessionException noUser) {
                        logger.error("Place Servlet: save place " + noUser);
                    }
                }

                //// BEGIN  ///

                try {
                    total = averageUnitMgr.getOnArbitraryKey(equipUnit, "key1");
                    for (int i = 0; i < total.size(); i++) {
                        Average = (WebBusinessObject) total.elementAt(i);
                    }

                    if (Average.getAttribute("current_Reading") != null) {
                        Integer iTemp = new Integer(Average.getAttribute("current_Reading").toString());
                        totalReading = iTemp.intValue();
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                try {
                    if (request.getParameter("formCat").equalsIgnoreCase("km")) {
                        frequncy = scheduleMgr.getOnArbitraryDoubleKey(equipUnit, "key2", "5", "key6");
                    } else {
                        frequncy = scheduleMgr.getAllScheduleByTimeOnEquipmentByDirectAndInDirect(equipUnit, (String) unitWbo.getAttribute("parentId"), (String) unitWbo.getAttribute("maintTypeId"));
                    }

                    for (int i = 0; i < frequncy.size(); i++) {
                        schedule = (WebBusinessObject) frequncy.elementAt(i);
                        if (schedule.getAttribute("frequencyReal") != null) {
                            Integer rateTemp = new Integer(schedule.getAttribute("frequencyReal").toString());
                            frequncyRate = rateTemp.intValue();

                            result = totalReading / frequncyRate;

                            // set wboActionTaken to save Action Taken Table
                            wboActionTaken.setAttribute("readingCounter", String.valueOf(totalReading));
                            wboActionTaken.setAttribute("unitId", (String) Average.getAttribute("unitName"));
                            wboActionTaken.setAttribute("scheduleId", (String) schedule.getAttribute("periodicID"));
                            wboActionTaken.setAttribute("rateNo", String.valueOf(result));

                            siteWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipUnit);
                            siteName = siteWbo.getAttribute("site").toString();

                            if (result > 0) {
                                if (unitScheduleHistoryMgr.checkScheduleExist(equipUnit, schedule.getAttribute("periodicID").toString())) {

                                    unitScheduleHistoryMgr.updateScheduleExist(equipUnit, schedule.getAttribute("periodicID").toString(), result);
                                    scheduleRateId = unitScheduleHistoryMgr.getScheduleRateId(equipUnit, schedule.getAttribute("periodicID").toString());
                                    isViewSchedule = unitScheduleHistoryMgr.ViewSchedule(equipUnit, schedule.getAttribute("periodicID").toString());
                                    if (isViewSchedule) {
                                        lastSchedules.add(scheduleRateId);
                                    }
                                } else {
                                    scheduleRateId = unitScheduleHistoryMgr.saveInHistoryUnitSchedule(schedule, Average, session, result);
                                    isViewSchedule = unitScheduleHistoryMgr.ViewSchedule(equipUnit, schedule.getAttribute("periodicID").toString());
                                    if (!scheduleRateId.equalsIgnoreCase("saveFail")) {
                                        if (isViewSchedule) {
                                            lastSchedules.add(scheduleRateId);
                                        }
                                    }
                                }
                                // save Defualt Row in Action Taken Table action type become 'NO ACTION'
                                if (scheduleRateId != null && isViewSchedule) { // becouse var scheduleRateId is null no insert in Unit_Schedule_History and no update occure
                                    // set wboActionTaken to save Action Taken Table
                                    wboActionTaken.setAttribute("historyId", scheduleRateId);
                                    actionTakenMgr.saveActionTaken(wboActionTaken, session);
                                }
                            }
                        }
                    }

                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                /// End  ///
                backToform = (String) request.getParameter("backTo");
                if (backToform != null) {
                    request.setAttribute("backTo", (String) request.getParameter("backTo"));
                    request.setAttribute("equipmentId", (String) request.getParameter("unitId"));
                } else {
                    if (null != request.getParameter("unitId")) {
                        unitWbo = maintainableMgr.getOnSingleKey(request.getParameter("unitId"));
                        if (unitWbo != null) {
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unitId", request.getParameter("unitId").toString());
                        }
                    }
                }

                request.setAttribute("displayForm", "disaple");
                request.setAttribute("equipUnit", equipUnit);
                request.setAttribute("lastScheduls", lastSchedules);
                request.setAttribute("scheduleNo", resultTempString);
                // to Determin Im go to after update hours or not
                request.setAttribute("actionTaken", "ok");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
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
        return "Hours Working Equipment Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("getUpdateHoursEquipmentForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("saveCloserAverageUnit")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("executeSchedule")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("cancelSchedule")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("getUpdateWhichCloserEquipmentForm")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("getLastIssuesByAction")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("getOperatingForm")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("listOperatingReport")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("listEquipmentBySite")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("getUpdateReadingsOfEquipmentsForm")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("updateReadingsOfEquipments")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("getFoundationSpecificationForExternalTransactionsForm")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("saveFoundationSpecificationForExternalTransactionsForm")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("getUpdateKiloEquipmentForm")) {
            return 15;
        }
        if (opName.equalsIgnoreCase("saveAverageUnit")) {
            return 16;
        }
        return 0;
    }

    private long timenow() {

        Date d = Calendar.getInstance().getTime();

        long nowTime = d.getTime();

        return nowTime;
    }

    private void createTopMenu(HttpServletRequest request, String lastFilter, HttpSession session) {
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
    }

    private Vector<String> getScheduleIdsDeservCloser(String unitId, HttpSession session) {

        Vector<String> lastSchedules = new Vector<String>();
        Vector<WebBusinessObject> total;
        Vector<WebBusinessObject> schedules;
        AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
        ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        UnitScheduleHistoryMgr unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
        WebBusinessObject average = new WebBusinessObject();
        WebBusinessObject schedule = new WebBusinessObject();
        int frequncyRate, result;

        try {
            total = averageUnitMgr.getOnArbitraryKey(unitId, "key1");
            for (int i = 0; i < total.size(); i++) {
                average = (WebBusinessObject) total.elementAt(i);
            }
            if (average.getAttribute("current_Reading") != null) {
                Integer iTemp = new Integer(average.getAttribute("current_Reading").toString());
                totalReading = iTemp.intValue();
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        try {
            WebBusinessObject unitWbo = maintainableMgr.getOnSingleKey(unitId);
            schedules = scheduleMgr.getAllScheduleByTimeOnEquipmentByDirectAndInDirect(unitId, (String) unitWbo.getAttribute("parentId"), (String) unitWbo.getAttribute("maintTypeId"));
            for (int i = 0; i < schedules.size(); i++) {
                try {
                    schedule = (WebBusinessObject) schedules.elementAt(i);
                    if (schedule.getAttribute("whichCloser") != null) {
                        Integer rateTemp = new Integer(schedule.getAttribute("whichCloser").toString());
                        frequncyRate = rateTemp.intValue();

                        result = totalReading / frequncyRate;

                        if (result > 0) {
                            if (unitScheduleHistoryMgr.checkScheduleExist(unitId, schedule.getAttribute("periodicID").toString())) {
                                unitScheduleHistoryMgr.updateScheduleExist(unitId, schedule.getAttribute("periodicID").toString(), result);
                                scheduleRateId = unitScheduleHistoryMgr.getScheduleRateId(unitId, schedule.getAttribute("periodicID").toString());
                                if (unitScheduleHistoryMgr.ViewSchedule(unitId, schedule.getAttribute("periodicID").toString())) {
                                    lastSchedules.add(scheduleRateId);
                                }
                            } else {
                                String saveStatus = unitScheduleHistoryMgr.saveInHistoryUnitSchedule(schedule, average, session, result);
                                if (!saveStatus.equalsIgnoreCase("saveFail")) {
                                    if (unitScheduleHistoryMgr.ViewSchedule(unitId, schedule.getAttribute("periodicID").toString())) {
                                        lastSchedules.add(saveStatus);
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
            }

        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return lastSchedules;
    }

    private Vector<String> getScheduleIdsDeserv(String unitId, String scheduleType, HttpSession session) {

        Vector<String> lastSchedules = new Vector<String>();
        Vector<WebBusinessObject> total;
        Vector<WebBusinessObject> schedules;
        AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
        ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        UnitScheduleHistoryMgr unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
        WebBusinessObject average = new WebBusinessObject();
        WebBusinessObject schedule = new WebBusinessObject();
        int frequncyRate, result;

        try {
            total = averageUnitMgr.getOnArbitraryKey(unitId, "key1");
            for (int i = 0; i < total.size(); i++) {
                average = (WebBusinessObject) total.elementAt(i);
            }
            if (average.getAttribute("current_Reading") != null) {
                Integer iTemp = new Integer(average.getAttribute("current_Reading").toString());
                totalReading = iTemp.intValue();
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        try {
            // if this equipment want to get all schedule by time
            if ("1".equals(scheduleType)) {
                WebBusinessObject unitWbo = maintainableMgr.getOnSingleKey(unitId);
                schedules = scheduleMgr.getAllScheduleByTimeOnEquipmentByDirectAndInDirect(unitId, (String) unitWbo.getAttribute("parentId"), (String) unitWbo.getAttribute("maintTypeId"));
            } else {
                schedules = scheduleMgr.getOnArbitraryDoubleKey(unitId, "key2", scheduleType, "key3");
            }

            for (int i = 0; i < schedules.size(); i++) {

                schedule = (WebBusinessObject) schedules.elementAt(i);
                if (schedule.getAttribute("frequencyReal") != null) {
                    Integer rateTemp = new Integer(schedule.getAttribute("frequencyReal").toString());
                    frequncyRate = rateTemp.intValue();

                    result = totalReading / frequncyRate;

                    if (result > 0) {
                        if (unitScheduleHistoryMgr.checkScheduleExist(unitId, schedule.getAttribute("periodicID").toString())) {
                            unitScheduleHistoryMgr.updateScheduleExist(unitId, schedule.getAttribute("periodicID").toString(), result);
                            scheduleRateId = unitScheduleHistoryMgr.getScheduleRateId(unitId, schedule.getAttribute("periodicID").toString());
                            if (unitScheduleHistoryMgr.ViewSchedule(unitId, schedule.getAttribute("periodicID").toString())) {
                                lastSchedules.add(scheduleRateId);
                            }
                        } else {

                            String saveStatus = unitScheduleHistoryMgr.saveInHistoryUnitSchedule(schedule, average, session, result);
                            if (!saveStatus.equalsIgnoreCase("saveFail")) {
                                if (unitScheduleHistoryMgr.ViewSchedule(unitId, schedule.getAttribute("periodicID").toString())) {
                                    lastSchedules.add(saveStatus);
                                }
                            }
                        }
                    }
                }

            }

        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return lastSchedules;
    }

    public String getAutoCreateJobOrder(HttpServletRequest request, HttpServletResponse response,Vector unitScheduleIdV){
                HttpSession session = request.getSession();
                IssueMgr issueMgr = IssueMgr.getInstance();
                ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                ActionTakenMgr actionTakenMgr =  ActionTakenMgr.getInstance();
                ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();
                MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                Vector listIdsOfJobOrder = new Vector();
                Vector listOfJobOrder = new Vector();
                String unitScheduleId = null;
                String schedulefalag = null;
                String unitName;
                String actionTaken = request.getParameter("actionTaken");
                WebBusinessObject unitScheduleRecord = new WebBusinessObject();

                UnitScheduleHistoryMgr unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
                WebBusinessObject unitScheduleHistoryWbo = new WebBusinessObject();
                String scheduleId = null;
                String lastFilter;

                WebBusinessObject schedule = new WebBusinessObject();
                WebBusinessObject issue = null;
                String equipUnit = request.getParameter("unitId");
                String siteName = (String)request.getAttribute("siteName");
//                String[] schIdsArr = request.getParameterValues("scheduleId");

                for (int j = 0; j <unitScheduleIdV.size(); j++) {
                    issue = new WebBusinessObject();
                     unitScheduleId = (String) lastSchedules.get(j);
                     unitScheduleHistoryWbo = unitScheduleHistoryMgr.getOnSingleKey(unitScheduleId);
                    try {
                        scheduleId = issueMgr.saveInUnitSchedule(unitScheduleHistoryWbo);
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    }

                    if (!scheduleId.equalsIgnoreCase("saveFail")) {
                        unitScheduleRecord = unitScheduleHistoryMgr.getOnSingleKey(unitScheduleId);
                        schedule = scheduleMgr.getOnSingleKey(unitScheduleRecord.getAttribute("periodicId").toString());
                        issue.setAttribute("maintenanceTitle", unitScheduleRecord.getAttribute("maintenanceTitle").toString());
                        issue.setAttribute("workTrade", schedule.getAttribute("workTrade").toString());
                        issue.setAttribute("duration", schedule.getAttribute("duration").toString());
                        issue.setAttribute("id", unitScheduleRecord.getAttribute("id").toString());

                        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                        String newUnitScheduleId = scheduleId;
                        try {
                            String issueId = issueMgr.saveKilSchedule2(issue, equipUnit, session, siteName, newUnitScheduleId);
                            ScheduleTasksMgr scheduleTMgr = ScheduleTasksMgr.getInstance();

                            Vector scTasks = new Vector();
                            String schId = unitScheduleHistoryWbo.getAttribute("periodicId").toString();
                            try {
                                scTasks = scheduleTMgr.getOnArbitraryKey(schId, "key1");
                                StringValue issue_Id = new StringValue(issueId);
                                issueMgr.saveIssueTasks(issue_Id, scTasks);

                                /****************** Transfer Schedule Parts To Issues ***********************/
                                ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();

                                Vector schParts = configureMainTypeMgr.getOnArbitraryKey(schId, "key1");

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
                                QntfMntncMgr.saveObject2(quantity, price, cost, note, ids, newUnitScheduleId, isDirectPrch, attachedOn, session);

                            } catch (SQLException ex) {
                                Logger.getLogger(HoursWorkingEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(HoursWorkingEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                            if (!issueId.equalsIgnoreCase("saveFail")) {
                                // add this issueId to list of Issue
                                listIdsOfJobOrder.add(issueId);
                                schedulefalag = "scheduled";
                                // to Update Action Taken by Issue
                                if (actionTaken.equalsIgnoreCase("ok")) {
                                    WebBusinessObject wbo = new WebBusinessObject();
                                    wbo.setAttribute("readingCounter", request.getParameter("totalCount"));
                                    wbo.setAttribute("historyId", unitScheduleId);
                                    wbo.setAttribute("issueId", issueId);

                                    actionTakenMgr.updateActionTakenAsIssue(wbo);
                                    // to Determin Im go to after update hours or not
                                    request.setAttribute("actionTaken", "ok");
                                }
                                // update job order job order rate in unit schedule history
                                unitScheduleHistoryMgr.updateJobOrderRate(unitScheduleId);

                                // update Reading Rate Unit by Issue
                                WebBusinessObject wboReadingRateUnit = new WebBusinessObject();
                                wboReadingRateUnit.setAttribute("issueId", issueId);
                                wboReadingRateUnit.setAttribute("unitId", equipUnit);
                                wboReadingRateUnit.setAttribute("readingCounter", request.getParameter("totalCount"));
                                readingRateUnitMgr.updateReadingRateUnitAsIssue(wboReadingRateUnit);
                            } else {
                                schedulefalag = "notscheduled";
                            }
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex.getMessage());
                            schedulefalag = "notscheduled";
                        }
                    } else {
                        schedulefalag = "notscheduled";
                    }
                }

                // craete top Menu
                unitName = maintainableMgr.getUnitName(equipUnit);
                if (actionTaken.equalsIgnoreCase("ok")) {
                    lastFilter = "HoursWorkingEquipmentServlet?op=getLastIssuesByAction" + "&tableName=ActionTaken" + "&unitId=" + equipUnit + "&readingCounter=" + request.getParameter("totalCount") + "&unitName=" + unitName;
                } else {
                    String maxIssueId = (String) listIdsOfJobOrder.get(listIdsOfJobOrder.size() - 1);
                    String minIssueId = (String) listIdsOfJobOrder.get(0);
                    lastFilter = "HoursWorkingEquipmentServlet?op=getLastIssuesByAction" + "&tableName=Issue" + "&maxIssueId=" + maxIssueId + "&minIssueId=" + minIssueId + "&unitName=" + unitName;
                }
                createTopMenu(request, lastFilter, session);

                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
                    servedPage = "/docs/schedule/edit_schedule_kil_unit.jsp";
                } else {
                    servedPage = "/docs/schedule/edit_schedule_hr_unit.jsp";
                }

                // get all Issue that Inserted Now In Issue
                listOfJobOrder = issueMgr.getAllIssueByIds(listIdsOfJobOrder);

                request.setAttribute("schedulefalag", schedulefalag);
                request.setAttribute("listIssues", listOfJobOrder);
                request.setAttribute("unitId", equipUnit);

                return "doneSave";
    }
}
