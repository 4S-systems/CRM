package com.maintenance.servlets;

import java.io.*;
import java.net.*;
import java.util.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.timeutil.*;
import com.silkworm.jsptags.*;
import com.silkworm.Exceptions.*;

import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;
import com.maintenance.common.*;

import com.contractor.db_access.MaintainableMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.*;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
//import com.maintenance.db_access.ItemMgr;
public class AverageUnitServlet extends TrackerBaseServlet {
    
    private static AverageUnitServlet averageUnitServlet = new AverageUnitServlet();
    MaintainableMgr unit = MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
    EquipOperationMgr equipOperationMgr = EquipOperationMgr.getInstance();
    ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();
    JobOrderByRateMgr jobOrderByRateMgr = JobOrderByRateMgr.getInstance();
    String op = null;
    String filterName = null;
    String filterValue = null;
    String categoryId = null;
    String parentId = null;
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;
    String prevAverage = null;
    String prevDate;
    long now;
    String nowDate;
    int month, oldMonth;
    int day, oldDay;
    int year, oldYear;
    int sizenow, sizeOld;
    String enteryDate;
    String oldDate;
    long counter;
    long divCounter;
    
    public AverageUnitServlet() {
    }
    
    public static AverageUnitServlet getInstance() {
        return averageUnitServlet;
    }
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    public void destroy() {
        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        
        switch (operation) {
            case 1:
                WebBusinessObject Average = new WebBusinessObject();
                WebBusinessObject schedule = new WebBusinessObject();
                WebBusinessObject siteWbo = new WebBusinessObject();
                Vector frequncy = new Vector();
                Vector total = new Vector();
                Vector site = new Vector();
                String categoryId = null;
                String siteName = null;
                int frequncyRate = 0;
                int result = 0;
                int numberSchedule = 0;
                String totalSchedule;
                String guid = null;
                
                String eqId=(String)request.getParameter("equipmentID");
                String backTo=(String)request.getParameter("backTo");
                MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
                WebBusinessObject unitWbo=new WebBusinessObject();
                
                Vector eqpsVec=new Vector();
                try {
                    session = request.getSession();
                    WebBusinessObject userObj = (WebBusinessObject) session.getAttribute("loggedUser");
//                    String []params={"1","0",userObj.getAttribute("projectID").toString()};
//                    String []keys={"key3","key5","key11"};
//                    eqpsVec=maintainableMgr.getOnArbitraryNumberKey(3,params,keys);
                    
                    SecurityUser securityUser =(SecurityUser) session.getAttribute("securityUser");
                    String userId = securityUser.getUserId();
                    String searchBy = securityUser.getSearchBy();
                    String siteId = securityUser.getSiteId();

                    if((userId.equals("1")) || (searchBy.equals("all"))){
                        eqpsVec=maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
                    }else{
                        eqpsVec = maintainableMgr.getEquipBySiteId(siteId);
                    }
                    
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                ArrayList eqpsArray=new ArrayList();
                for(int i=0;i<eqpsVec.size();i++){
                    unitWbo = (WebBusinessObject) eqpsVec.get(i);
                    if(unitWbo.getAttribute("rateType").equals("By Hour")){
                    eqpsArray.add(eqpsVec.get(i));
                    }
                }
                if(backTo!=null) {
                    if(backTo.equalsIgnoreCase("viewEquipment")){
                        request.setAttribute("equipmentId", eqId);
                        request.setAttribute("backTo", "viewEq");
                    }else {
                        if (null!=request.getParameter("unitId")) {
                            unitWbo=maintainableMgr.getOnSingleKey(request.getParameter("unitId"));
                            if(unitWbo!=null){
                                request.setAttribute("unitWbo", unitWbo);
                                request.setAttribute("unitId", request.getParameter("unitId").toString());
                            }
                        }else{
                            request.setAttribute("viewDefualt", "ok");
                        }
                    }
                }else {
                    if (null!=request.getParameter("unitId")){
                        unitWbo=maintainableMgr.getOnSingleKey(request.getParameter("unitId"));
                        if(unitWbo!=null){
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unitId", request.getParameter("unitId").toString());
                        }
                    }else{
                        request.setAttribute("viewDefualt", "ok");
                    }
                }

                String equipUnit = (String) unitWbo.getAttribute("id");
                int resultTemp = 0;
                int totalRate = 0;
                String scheduleRateId = null;
                String resultTempString = "0";
                UnitScheduleHistoryMgr unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
                Vector lastSchedules=new Vector();
                //// BEGIN  ///

                try {
                    total = averageUnitMgr.getOnArbitraryKey(equipUnit, "key1");
                    for (int i = 0; i < total.size(); i++) {
                        Average = (WebBusinessObject) total.elementAt(i);
                    }
                    if (Average.getAttribute("current_Reading") != null) {
                        Integer iTemp = new Integer(Average.getAttribute("current_Reading").toString());
                        totalRate = iTemp.intValue();
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                try {
                    frequncy = scheduleMgr.getOnArbitraryDoubleKey(equipUnit, "key2", "0", "key6");

                    for (int i = 0; i < frequncy.size(); i++) {
                        schedule = (WebBusinessObject) frequncy.elementAt(i);
                        // if(scheduleMgr.getConfigSchedule(schedule.getAttribute("periodicID").toString())){
                        if (schedule.getAttribute("frequency") != null) {
                            Integer rateTemp = new Integer(schedule.getAttribute("frequency").toString());
                            frequncyRate = rateTemp.intValue();

                            EqpEventLogMgr eqpEventLogMgr=EqpEventLogMgr.getInstance();
                            int lastActionReading=eqpEventLogMgr.getLastActionReading(equipUnit);

                            int diffActionReading=totalRate-lastActionReading;
                            result= diffActionReading / frequncyRate;

//                            result = totalRate / frequncyRate;
                            //resultTemp=resultTemp+result;
                            totalSchedule = issueMgr.getNumberSchedule(schedule.getAttribute("periodicID").toString());


                            siteWbo = (WebBusinessObject) unit.getOnSingleKey(equipUnit);
                            siteName = siteWbo.getAttribute("site").toString();
                            Integer totalTemp = new Integer(totalSchedule);
                            numberSchedule = totalTemp.intValue();
                            if (result > 0) {
//                                if (result > numberSchedule) {
                                    resultTemp = resultTemp + result;
                                    resultTemp = resultTemp - numberSchedule;
                                    resultTempString = new Integer(resultTemp).toString();
                                    request.setAttribute("scheduleAlert", "done");

                                    if (unitScheduleHistoryMgr.checkScheduleExist(equipUnit,schedule.getAttribute("periodicID").toString())){

                                        unitScheduleHistoryMgr.updateScheduleExist(equipUnit,schedule.getAttribute("periodicID").toString(),result);
                                        scheduleRateId = unitScheduleHistoryMgr.getScheduleRateId(equipUnit,schedule.getAttribute("periodicID").toString());
                                        if(unitScheduleHistoryMgr.ViewSchedule(equipUnit,schedule.getAttribute("periodicID").toString()))
                                            lastSchedules.add(scheduleRateId);
                                    } else {
                                        String saveStatus=unitScheduleHistoryMgr.saveInHistoryUnitSchedule(schedule,Average,session,result);
                                        if(!saveStatus.equalsIgnoreCase("saveFail"))
                                            if(unitScheduleHistoryMgr.ViewSchedule(equipUnit,schedule.getAttribute("periodicID").toString()))
                                                lastSchedules.add(saveStatus);
                                    }
//                                }

                            }
                        }
                    }

                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                /// End  ///
                
                request.setAttribute("displayForm","enable");
                request.setAttribute("equipments",eqpsArray);
                request.setAttribute("lastScheduls",lastSchedules);
                servedPage = "/docs/schedule/edit_average_unit.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                resultTemp = 0;
                totalRate = 0;
                scheduleRateId = null;
                resultTempString = "0";
                maintainableMgr=MaintainableMgr.getInstance();
                unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
                lastSchedules=new Vector();
                Average = new WebBusinessObject();
                String checkUpdate = null;
                String unitScheduleId = null;
                equipUnit = request.getParameter("unitId");
                categoryId = unit.getParentId(equipUnit);
                
                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
                    servedPage = "/docs/schedule/edit_average_kel_unit.jsp";
                } else {
                    servedPage = "/docs/schedule/edit_average_unit.jsp";
                }
                
                Average = new WebBusinessObject();
                WebBusinessObject unit_schedule=new WebBusinessObject();
                WebBusinessObject averageUpdate = new WebBusinessObject();
                unit_schedule.setAttribute("unitId",request.getParameter("unitId").toString());
                
                Average.setAttribute("current_Reading", request.getParameter("current_Reading").toString());
                Average.setAttribute("description", request.getParameter("description").toString());
                Average.setAttribute("unit", request.getParameter("unitId").toString());
                checkUpdate = averageUnitMgr.getTrueUpdate(request.getParameter("unitId").toString());
                
                now = timenow();
                
                if (checkUpdate != null) {
                    averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
                    prevDate = (String) averageUpdate.getAttribute("entry_Time");
                    if (averageUnitMgr.updateAverage(Average, averageUpdate, prevDate, now)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
//                        request.setAttribute("less", "The current average less than oldest average");
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
                        totalRate = iTemp.intValue();
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                try {
                    if (request.getParameter("formCat").equalsIgnoreCase("km"))
                        frequncy = scheduleMgr.getOnArbitraryDoubleKey(equipUnit, "key2", "5", "key6");
                    else
                        frequncy = scheduleMgr.getOnArbitraryDoubleKey(equipUnit, "key2", "0", "key6");
                    
                    for (int i = 0; i < frequncy.size(); i++) {
                        schedule = (WebBusinessObject) frequncy.elementAt(i);
                        // if(scheduleMgr.getConfigSchedule(schedule.getAttribute("periodicID").toString())){
                        if (schedule.getAttribute("frequency") != null) {
                            Integer rateTemp = new Integer(schedule.getAttribute("frequency").toString());
                            frequncyRate = rateTemp.intValue();
                            
                            EqpEventLogMgr eqpEventLogMgr=EqpEventLogMgr.getInstance();
                            int lastActionReading=eqpEventLogMgr.getLastActionReading(equipUnit);
                            
                            int diffActionReading=totalRate-lastActionReading;
                            result= diffActionReading / frequncyRate;
                            
//                            result = totalRate / frequncyRate;
                            //resultTemp=resultTemp+result;
                            totalSchedule = issueMgr.getNumberSchedule(schedule.getAttribute("periodicID").toString());
                            
                            
                            siteWbo = (WebBusinessObject) unit.getOnSingleKey(equipUnit);
                            siteName = siteWbo.getAttribute("site").toString();
                            Integer totalTemp = new Integer(totalSchedule);
                            numberSchedule = totalTemp.intValue();
                            if (result > 0) {
//                                if (result > numberSchedule) {
                                    resultTemp = resultTemp + result;
                                    resultTemp = resultTemp - numberSchedule;
                                    resultTempString = new Integer(resultTemp).toString();
                                    request.setAttribute("scheduleAlert", "done");
                                    
                                    if (unitScheduleHistoryMgr.checkScheduleExist(equipUnit,schedule.getAttribute("periodicID").toString())){
                                        
                                        unitScheduleHistoryMgr.updateScheduleExist(equipUnit,schedule.getAttribute("periodicID").toString(),result);
                                        scheduleRateId = unitScheduleHistoryMgr.getScheduleRateId(equipUnit,schedule.getAttribute("periodicID").toString());
                                        if(unitScheduleHistoryMgr.ViewSchedule(equipUnit,schedule.getAttribute("periodicID").toString()))
                                            lastSchedules.add(scheduleRateId);
                                    } else {
                                        String saveStatus=unitScheduleHistoryMgr.saveInHistoryUnitSchedule(schedule,Average,session,result);
                                        if(!saveStatus.equalsIgnoreCase("saveFail"))
                                            if(unitScheduleHistoryMgr.ViewSchedule(equipUnit,schedule.getAttribute("periodicID").toString()))
                                                lastSchedules.add(saveStatus);
                                    }
//                                }
                                
                            }
                        }
                    }
                    
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                /// End  ///
                String backToform=(String)request.getParameter("backTo");
                if(backToform!=null){
                    request.setAttribute("backTo",(String)request.getParameter("backTo"));
                    request.setAttribute("equipmentId",(String)request.getParameter("unitId"));
                }else{
                    if (null!=request.getParameter("unitId")){
                        unitWbo=maintainableMgr.getOnSingleKey(request.getParameter("unitId"));
                        if(unitWbo!=null){
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unitId", request.getParameter("unitId").toString());
                        }
                    }
                }
                
                request.setAttribute("displayForm","disaple");
                request.setAttribute("lastScheduls",lastSchedules);
                request.setAttribute("scheduleNo", resultTempString);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 3:
                Vector averageUnit = new Vector();
                averageUnitMgr.cashData();
                averageUnit = averageUnitMgr.getAllItems();
                
                servedPage = "/docs/schedule/Average_Unit_List.jsp";
                
                request.setAttribute("data", averageUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                
                resultTemp = 0;
                totalRate = 0;
                resultTempString = "0";
                eqId=(String)request.getParameter("equipmentID");
                backTo=(String)request.getParameter("backto");
                maintainableMgr=MaintainableMgr.getInstance();
                unitWbo=new WebBusinessObject();
                if(backTo!=null) {
                    if(backTo.equalsIgnoreCase("viewEquipment")){
                        request.setAttribute("equipmentId", eqId);
//                        request.setAttribute("unit", eqId);
                        request.setAttribute("backTo", "viewEq");
                    }else {
                        if (null!=request.getParameter("unit")) {
                            unitWbo=maintainableMgr.getOnSingleKey(request.getParameter("unit"));
                            if(unitWbo!=null){
                                request.setAttribute("unitWbo", unitWbo);
                                request.setAttribute("unit", request.getParameter("unit").toString());
                            }
                        }
                    }
                }else {
                    if (null!=request.getParameter("unit")) {
                        unitWbo=maintainableMgr.getOnSingleKey(request.getParameter("unit"));
                        if(unitWbo!=null){
                            request.setAttribute("unitWbo", unitWbo);
                            request.setAttribute("unit", request.getParameter("unit").toString());
                        }
                    }
                }
                frequncy=new Vector();
                Average = new WebBusinessObject();
                servedPage = "/docs/schedule/edit_average_kel_unit.jsp";
                
                try {
                    total = averageUnitMgr.getOnArbitraryKey(request.getParameter("unit").toString(), "key1");
                    for (int i = 0; i < total.size(); i++) {
                        Average = (WebBusinessObject) total.elementAt(i);
                    }
                    if (Average.getAttribute("acual_Reading") != null) {
                        Integer iTemp = new Integer(Average.getAttribute("acual_Reading").toString());
                        totalRate = iTemp.intValue();
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                //////////////
                
//                try {
//                    frequncy = scheduleMgr.getOnArbitraryDoubleKey(request.getParameter("unit").toString(), "key2", "5", "key6");
//                    for (int i = 0; i < frequncy.size(); i++) {
//                        schedule = (WebBusinessObject) frequncy.elementAt(i);
//                        // if(scheduleMgr.getConfigSchedule(schedule.getAttribute("periodicID").toString())){
//                        if (schedule.getAttribute("frequency") != null) {
//                            Integer rateTemp = new Integer(schedule.getAttribute("frequency").toString());
//                            frequncyRate = rateTemp.intValue();
//                            result = totalRate / frequncyRate;
//                            //resultTemp=resultTemp+result;
//                            totalSchedule = issueMgr.getNumberSchedule(schedule.getAttribute("periodicID").toString());
//
//
//                            siteWbo = (WebBusinessObject) unit.getOnSingleKey(request.getParameter("unit").toString());
//                            siteName = siteWbo.getAttribute("site").toString();
//                            Integer totalTemp = new Integer(totalSchedule);
//                            numberSchedule = totalTemp.intValue();
//                            if (result > 0) {
//                                if (result > numberSchedule) {
//                                    resultTemp = resultTemp + result;
//                                    resultTemp = resultTemp - numberSchedule;
//                                    resultTempString = new Integer(resultTemp).toString();
////                                try {
////                                    issueMgr.saveHourlySchedule(schedule,Average,session,siteName);
////                                } catch (NoUserInSessionException ex) {
//
////                                }
////                        for(int x = 0; x < itemConfig.size(); x++){
////
////                        unitScheduleId = issueMgr.valueIssueId();
////                        configure = (WebBusinessObject) itemConfig.elementAt(x);
////                        issueMgr.saveQuantifiedItem(configure,unitScheduleId);
////                        }
//                                }
//
//                            }
//                        }
//                        // }
//                    }
//
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
                
                eqpsVec=new Vector();
                try {
                    session = request.getSession();
                    WebBusinessObject userObj = (WebBusinessObject) session.getAttribute("loggedUser");
//                    String []params={"1","0",userObj.getAttribute("projectID").toString()};
//                    String []keys={"key3","key5","key11"};
//                    eqpsVec=maintainableMgr.getOnArbitraryNumberKey(3,params,keys);
                    eqpsVec=maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                eqpsArray=new ArrayList();
                for(int i=0;i<eqpsVec.size();i++){
                    unitWbo = (WebBusinessObject) eqpsVec.get(i);
                    if(unitWbo.getAttribute("rateType").equals("odometer")){
                    eqpsArray.add(eqpsVec.get(i));
                    }
                }
                
                request.setAttribute("equipments",eqpsArray);
                
                request.setAttribute("displayForm","enable");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                ///
                
                totalRate = 0;
                Average = new WebBusinessObject();
                checkUpdate = null;
                unitScheduleId = null;
                
//                equipUnit = request.getParameter("unit");
//                categoryId = unit.getParentId(equipUnit);
                
//                servedPage = "/docs/schedule/edit_average_unit.jsp";
                Average = new WebBusinessObject();
                Vector machineRate = new Vector();
                WebBusinessObject machineData = new WebBusinessObject();
//                WebBusinessObject averageUpdate = new WebBusinessObject();
                
                machineRate = equipOperationMgr.getAllContinuousEquip();
                for (int i = 0; i < machineRate.size(); i++) {
                    machineData = (WebBusinessObject) machineRate.elementAt(i);
                    
                    if (averageUnitMgr.checkEquipStatus((String) machineData.getAttribute("equipment_id"))) {
                        
                        Average.setAttribute("current_Reading", machineData.getAttribute("average").toString());
                        Average.setAttribute("description", "UL");
                        Average.setAttribute("unit", machineData.getAttribute("equipment_id").toString());
                        checkUpdate = averageUnitMgr.getTrueUpdate(machineData.getAttribute("equipment_id").toString());
                        parentId = unit.getParentId(machineData.getAttribute("equipment_id").toString());
                        
                        now = timenow();
//                nowDate = runTime();
//                month = month(nowDate.substring(4,7));
//                day= new Integer(nowDate.substring(8,10).toString()).intValue();
//                year= new Integer(nowDate.substring(25,29).toString()).intValue();
//                sizenow = day+month+year;
                        try {
                            if (averageUnitMgr.checkDateUnit(machineData.getAttribute("equipment_id").toString())) {
                                enteryDate = averageUnitMgr.prevDate(machineData.getAttribute("equipment_id").toString());
//                            oldDate =prevTime(enteryDate);
//                            oldMonth = month(oldDate.substring(4,7));
//                            oldDay= new Integer(oldDate.substring(8,10).toString()).intValue();
//                            oldYear= new Integer(oldDate.substring(25,29).toString()).intValue();
//                            sizeOld = oldDay+oldMonth+oldYear;
                                divCounter = now - Long.parseLong(enteryDate.trim());
                                counter = (((divCounter / 1000) / 60) / 60) / 24;
                                
                                
                            }
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
//                if (counter!=0){
                        if (checkUpdate != null && counter != 0) {
                            averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
                            prevDate = (String) averageUpdate.getAttribute("entry_Time");
                            
                            if (averageUnitMgr.updateAverageConten(Average, averageUpdate, prevDate, now, counter)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            try {
                                if (!averageUnitMgr.checkUnit(machineData.getAttribute("equipment_id").toString())) {
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
                            } catch (Exception ex) {
                                logger.error(ex.getMessage());
                            }
                        }
                        
//        }
                        
                        //// BEGIN  ///
                        
                        try {
                            total = averageUnitMgr.getOnArbitraryKey(machineData.getAttribute("equipment_id").toString(), "key1");
                            for (int x = 0; x < total.size(); x++) {
                                Average = (WebBusinessObject) total.elementAt(x);
                            }
                            if (Average.getAttribute("acual_Reading") != null) {
                                Integer iTemp = new Integer(Average.getAttribute("acual_Reading").toString());
                                totalRate = iTemp.intValue();
                            }
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
                        
                        
                        
                        try {
                            frequncy = scheduleMgr.getOnArbitraryDoubleKey(machineData.getAttribute("equipment_id").toString(), "key2", "0", "key6");
                            for (int y = 0; y < frequncy.size(); y++) {
                                schedule = (WebBusinessObject) frequncy.elementAt(y);
                                // if(scheduleMgr.getConfigSchedule(schedule.getAttribute("periodicID").toString())){
                                if (schedule.getAttribute("frequency") != null) {
                                    Integer rateTemp = new Integer(schedule.getAttribute("frequency").toString());
                                    frequncyRate = rateTemp.intValue();
                                    result = totalRate / frequncyRate;
                                    totalSchedule = issueMgr.getNumberSchedule(schedule.getAttribute("periodicID").toString());
                                    siteWbo = (WebBusinessObject) unit.getOnSingleKey(machineData.getAttribute("equipment_id").toString());
                                    siteName = siteWbo.getAttribute("site").toString();
                                    
                                    Integer totalTemp = new Integer(totalSchedule);
                                    numberSchedule = totalTemp.intValue();
                                    if (result > 0) {
                                        if (result > numberSchedule) {
                                            try {
                                                issueMgr.saveHourlySchedule(schedule, Average, session, siteName);
                                            } catch (NoUserInSessionException ex) {
                                                logger.error(ex.getMessage());
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                //}
                            }
                            
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
                    }
                }
                /// End  ///
                
                
                
                request.setAttribute("page", "manager_agenda.jsp");
                this.forwardToServedPage(request, response);
                break;
                ///
                
            case 6:
                averageUnit = new Vector();
                averageUnitMgr.cashData();
                averageUnit = averageUnitMgr.getAllItems();
                
                servedPage = "/docs/schedule/Average_Unit_List_KL.jsp";
                
                request.setAttribute("data", averageUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 7:
//                Average = new WebBusinessObject();
//                schedule = new WebBusinessObject();
//                siteWbo = new WebBusinessObject();
//
//                frequncy = new Vector();
//
//
//                total = new Vector();
//                site = new Vector();
//                categoryId = null;
//                siteName = null;
//                frequncyRate = 0;
//                ;
//
//                result = 0;
//                numberSchedule = 0;
//
//                guid = null;
//                String equipmentID = request.getParameter("equipmentID").toString();
//                String currentMode = request.getParameter("currentMode").toString();
//                servedPage = "/docs/equipment/update_average_unit.jsp";
//
//                request.setAttribute("equipmentID", equipmentID);
//                request.setAttribute("currentMode", currentMode);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                
//                totalRate = 0;
//                resultTemp = 0;
//
//                Average = new WebBusinessObject();
//                checkUpdate = null;
//                unitScheduleId = null;
//                equipUnit = request.getParameter("unit");
//                categoryId = unit.getParentId(equipUnit);
//                currentMode = request.getParameter("currentMode");
//                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
//                    servedPage = "/docs/equipment/update_average_kel_unit.jsp";
//                } else {
//                    servedPage = "/docs/equipment/update_average_unit.jsp";
//                }
//                //servedPage = "/docs/schedule/edit_average_unit.jsp";
//                Average = new WebBusinessObject();
//                averageUpdate = new WebBusinessObject();
//
//                Average.setAttribute("current_Reading", request.getParameter("current_Reading").toString());
//                Average.setAttribute("description", request.getParameter("description").toString());
//                Average.setAttribute("unit", request.getParameter("unit").toString());
//                checkUpdate = averageUnitMgr.getTrueUpdate(request.getParameter("unit").toString());
//
//                now = timenow();
//
//                if (checkUpdate != null) {
//                    averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
////                    prevAverage = (String) averageUpdate.getAttribute("acual_Reading");
//                    prevDate = (String) averageUpdate.getAttribute("entry_Time");
//
//                    if (averageUnitMgr.updateAverage(Average, averageUpdate, prevDate, now)) {
//                        request.setAttribute("Status", "Ok");
//                    } else {
//                        request.setAttribute("Status", "No");
////                        request.setAttribute("less", "The current average less than oldest average");
//                    }
//                } else {
//                    try {
//                        if (averageUnitMgr.saveObject(Average, session, now)) {
//                            request.setAttribute("Status", "Ok");
//                        } else {
//                            request.setAttribute("Status", "No");
//                        }
//
//                    } catch (NoUserInSessionException noUser) {
//                        logger.error("Place Servlet: save place " + noUser);
//                    }
//                }
//                request.setAttribute("equipmentID", equipUnit);
//                request.setAttribute("currentMode", currentMode);
//                //// BEGIN  ///
//
//                try {
//                    total = averageUnitMgr.getOnArbitraryKey(equipUnit, "key1");
//                    for (int i = 0; i < total.size(); i++) {
//                        Average = (WebBusinessObject) total.elementAt(i);
//                    }
//                    if (Average.getAttribute("acual_Reading") != null) {
//                        Integer iTemp = new Integer(Average.getAttribute("acual_Reading").toString());
//                        totalRate = iTemp.intValue();
//                    }
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//                //////////////
//
//                try {
//                    frequncy = scheduleMgr.getOnArbitraryDoubleKey(equipUnit, "key2", "5", "key6");
//                    for (int i = 0; i < frequncy.size(); i++) {
//                        schedule = (WebBusinessObject) frequncy.elementAt(i);
//                        // if(scheduleMgr.getConfigSchedule(schedule.getAttribute("periodicID").toString())){
//                        if (schedule.getAttribute("frequency") != null) {
//                            Integer rateTemp = new Integer(schedule.getAttribute("frequency").toString());
//                            frequncyRate = rateTemp.intValue();
//                            result = totalRate / frequncyRate;
//                            //resultTemp=resultTemp+result;
//                            totalSchedule = issueMgr.getNumberSchedule(schedule.getAttribute("periodicID").toString());
//
//
//                            siteWbo = (WebBusinessObject) unit.getOnSingleKey(equipUnit);
//                            siteName = siteWbo.getAttribute("site").toString();
//                            Integer totalTemp = new Integer(totalSchedule);
//                            numberSchedule = totalTemp.intValue();
//                            if (result > 0) {
//                                if (result > numberSchedule) {
//                                    resultTemp = resultTemp + result;
//                                    resultTemp = resultTemp - numberSchedule;
//                                    resultTempString = new Integer(resultTemp).toString();
//                                    request.setAttribute("scheduleAlert", "done");
////                                try {
////                                    issueMgr.saveHourlySchedule(schedule,Average,session,siteName);
////                                } catch (NoUserInSessionException ex) {
//
////                                }
////                        for(int x = 0; x < itemConfig.size(); x++){
////
////                        unitScheduleId = issueMgr.valueIssueId();
////                        configure = (WebBusinessObject) itemConfig.elementAt(x);
////                        issueMgr.saveQuantifiedItem(configure,unitScheduleId);
////                        }
//                                }
//
//                            }
//                        }
//                        // }
//                    }
//
//                } catch (Exception ex) {
//                    logger.error(ex.getMessage());
//                }
//
//
//
//
//                /// End  ///
//
//
//
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
                
            case 9:
//                equipmentID = request.getParameter("equipmentID").toString();
//                currentMode = request.getParameter("currentMode").toString();
//                servedPage = "/docs/equipment/update_average_kel_unit.jsp";
//
//                request.setAttribute("equipmentID", equipmentID);
//                request.setAttribute("currentMode", currentMode);
//
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 10:
                averageUnit = new Vector();
                Vector allAverageUnit = new Vector();
                averageUnitMgr.cashData();
                String currentMode = request.getParameter("currentMode").toString();
                String equipmentID = request.getParameter("equipmentID").toString();
                
                try {
                    averageUnit = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                    allAverageUnit = readingRateUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                servedPage = "/docs/equipment/Average_equipment_List.jsp";
                
                request.setAttribute("currentMode", currentMode);
                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("data", averageUnit);
                request.setAttribute("alldata", allAverageUnit);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 11:
                averageUnit = new Vector();
                allAverageUnit = new Vector();
                averageUnitMgr.cashData();
                currentMode = request.getParameter("currentMode").toString();
                equipmentID = request.getParameter("equipmentID").toString();
                
                try {
                    averageUnit = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                    allAverageUnit = readingRateUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                servedPage = "/docs/equipment/Average_equipment_List_KL.jsp";
                
                request.setAttribute("currentMode", currentMode);
                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("data", averageUnit);
                request.setAttribute("alldata", allAverageUnit);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                
                
                totalRate = 0;
                Average = new WebBusinessObject();
                checkUpdate = null;
                unitScheduleId = null;
                
                Average = new WebBusinessObject();
                machineRate = new Vector();
                machineData = new WebBusinessObject();
                
                
                machineRate = equipOperationMgr.getAllContinuousEquip();
                for (int i = 0; i < machineRate.size(); i++) {
                    machineData = (WebBusinessObject) machineRate.elementAt(i);
                    
                    if (averageUnitMgr.checkEquipStatus((String) machineData.getAttribute("equipment_id"))) {
                        
                        Average.setAttribute("current_Reading", machineData.getAttribute("average").toString());
                        Average.setAttribute("description", "UL");
                        Average.setAttribute("unit", machineData.getAttribute("equipment_id").toString());
                        checkUpdate = averageUnitMgr.getTrueUpdate(machineData.getAttribute("equipment_id").toString());
                        parentId = unit.getParentId(machineData.getAttribute("equipment_id").toString());
                        
                        now = timenow();
                        
                        try {
                            if (averageUnitMgr.checkDateUnit(machineData.getAttribute("equipment_id").toString())) {
                                enteryDate = averageUnitMgr.prevDate(machineData.getAttribute("equipment_id").toString());
                                divCounter = now - Long.parseLong(enteryDate.trim());
                                counter = (((divCounter / 1000) / 60) / 60) / 24;
                                
                                
                            }
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        
//                if (counter!=0){
                        if (checkUpdate != null && counter != 0) {
                            averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
                            prevDate = (String) averageUpdate.getAttribute("entry_Time");
                            
                            if (averageUnitMgr.updateAverageConten(Average, averageUpdate, prevDate, now, counter)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            try {
                                if (!averageUnitMgr.checkUnit(machineData.getAttribute("equipment_id").toString())) {
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
                            } catch (Exception ex) {
                                logger.error(ex.getMessage());
                            }
                        }
                        
                        
                        
                    }
                }
                
                
                averageUnit = new Vector();
                averageUnitMgr.cashData();
                averageUnit = averageUnitMgr.getAllItems();
                
                servedPage = "/docs/schedule/Average_All_Unit_List.jsp";
                
                request.setAttribute("data", averageUnit);
                request.setAttribute("page", servedPage);
                
                
                
                
                this.forwardToServedPage(request, response);
                break;
            case 13:
                totalRate = 0;
                Integer totalTemp = new Integer(request.getParameter("total").toString());
                totalRate = totalTemp.intValue();
                Average = new WebBusinessObject();
                checkUpdate = null;
                unitScheduleId = null;
                
                equipUnit = request.getParameter("unit");
                //categoryId = unit.getParentId(total);
                
//                servedPage = "/docs/schedule/edit_average_unit.jsp";
                Average = new WebBusinessObject();
                machineRate = new Vector();
                machineData = new WebBusinessObject();
//                WebBusinessObject averageUpdate = new WebBusinessObject();
                
                
                
                
//                if (counter!=0){
                
                
//        }
                
                //// BEGIN  ///
                
                
                try {
                    frequncy = scheduleMgr.getOnArbitraryDoubleKey(equipUnit, "key2", "5", "key6");
                    for (int y = 0; y < frequncy.size(); y++) {
                        schedule = (WebBusinessObject) frequncy.elementAt(y);
                        if (schedule.getAttribute("frequency") != null) {
                            Integer rateTemp = new Integer(schedule.getAttribute("frequency").toString());
                            frequncyRate = rateTemp.intValue();
                            result = totalRate / frequncyRate;
                            totalSchedule = issueMgr.getNumberSchedule(schedule.getAttribute("periodicID").toString());
                            siteWbo = (WebBusinessObject) unit.getOnSingleKey(equipUnit);
                            siteName = siteWbo.getAttribute("site").toString();
                            Integer totalTempSch = new Integer(totalSchedule);
                            
                            numberSchedule = totalTempSch.intValue();
                            if (result > 0) {
                                if (result > numberSchedule) {
                                    result = result - numberSchedule;
                                    //  for (int x = 0; x < result; x++) {
                                    try {
                                        
                                        issueMgr.saveKilSchedule(schedule, equipUnit, session, siteName);
                                        
                                    } catch (NoUserInSessionException ex) {
                                        logger.error(ex.getMessage());
                                    }
                                    ///  }
                                }
                                
                            }
                        }
                        //}
                    }
                    
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                
                
                
                /// End  ///
                
                
                
                request.setAttribute("page", "manager_agenda.jsp");
                this.forwardToServedPage(request, response);
                break;
                
            case 14:
                unitScheduleId = null;
                String schedulefalag=null;
                UnitScheduleMgr unitScheduleMgr=UnitScheduleMgr.getInstance();
                WebBusinessObject unitScheduleRecord = new WebBusinessObject();
                
                unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
                WebBusinessObject unitScheduleHistoryWbo = new WebBusinessObject();
                String savingRecord = null;
                
                        
                schedule = new WebBusinessObject();
                WebBusinessObject issue=null;
                equipUnit = request.getParameter("unitId");
                siteName = request.getParameter("siteName");
                String[] schIdsArr=request.getParameterValues("scheduleId");
                for (int i = 0; i < schIdsArr.length; i++) {
                    issue=new WebBusinessObject();
                    unitScheduleId = schIdsArr[i];
                    unitScheduleHistoryWbo = unitScheduleHistoryMgr.getOnSingleKey(unitScheduleId);
                    try {
                        savingRecord = issueMgr.saveInUnitSchedule (unitScheduleHistoryWbo);
                    } catch (NoUserInSessionException ex) {
                        ex.printStackTrace();
                    }

                    if(!savingRecord.equalsIgnoreCase("saveFail")){
                        unitScheduleRecord = unitScheduleHistoryMgr.getOnSingleKey(unitScheduleId);
                        schedule=scheduleMgr.getOnSingleKey(unitScheduleRecord.getAttribute("periodicId").toString());
                        issue.setAttribute("maintenanceTitle",unitScheduleRecord.getAttribute("maintenanceTitle").toString());
                        issue.setAttribute("workTrade",schedule.getAttribute("workTrade").toString());
                        issue.setAttribute("duration",schedule.getAttribute("duration").toString());
                        issue.setAttribute("id",unitScheduleRecord.getAttribute("id").toString());
                        try {
                            //
                            String issueId = issueMgr.saveKilSchedule2(issue, equipUnit, session, siteName ,savingRecord);
                            if(!issueId.equalsIgnoreCase("saveFail")){
                                schedulefalag="scheduled";
                            // insert new recorde in job order by rate
                                WebBusinessObject wbo = new WebBusinessObject();
                                wbo.setAttribute("totalCount",request.getParameter("totalCount"));
                            jobOrderByRateMgr.saveJobOrderByRate((String)unitScheduleHistoryWbo.getAttribute("periodicId"),
                                                                 (String)unitScheduleHistoryWbo.getAttribute("id") ,
                                                                 issueId,
                                                                 (String) unitScheduleHistoryWbo.getAttribute("rateNo"),
                                                                 session,
                                                                 wbo);
                            // update job order rate
                            unitScheduleHistoryMgr.updateJobOrderRate(unitScheduleId);
                            }
                            else
                                schedulefalag="notscheduled";
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex.getMessage());
                            schedulefalag="notscheduled";
                        }
                    }else{
                        schedulefalag="notscheduled";
                    }
                }
                
                if (request.getParameter("formCat").equalsIgnoreCase("km")) {
                    servedPage = "/docs/schedule/edit_schedule_kil_unit.jsp";
                } else {
                    servedPage = "/docs/schedule/edit_schedule_hr_unit.jsp";
                }
                
                /**************** get equipment current reading to calculate 4 new schedule ********************/
                
                total=new Vector();
                String totalReading="";
                String lastReading="";
                WebBusinessObject averageWbo=new WebBusinessObject();
                averageUnitMgr=AverageUnitMgr.getInstance();
                
                try {
                    total = averageUnitMgr.getOnArbitraryKey(equipUnit, "key1");
                    for (int i = 0; i < total.size(); i++) {
                        averageWbo = (WebBusinessObject) total.elementAt(i);
                    }
                    if (averageWbo.getAttribute("acual_Reading") != null) {
                        
                        totalReading = averageWbo.getAttribute("acual_Reading").toString();
                        lastReading = averageWbo.getAttribute("current_Reading").toString();
                        
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                WebBusinessObject eqpEventLogWbo=new WebBusinessObject();
                eqpEventLogWbo.setAttribute("totalReading",totalReading);
                eqpEventLogWbo.setAttribute("lastReading",lastReading);
                eqpEventLogWbo.setAttribute("unitId",equipUnit);
                eqpEventLogWbo.setAttribute("action","Generate Job Orders");
                
                EqpEventLogMgr eqpEventLogMgr=EqpEventLogMgr.getInstance();

                try {
                    eqpEventLogMgr.saveObject(eqpEventLogWbo);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                
                /****************** End Of get last reading ******************/
                
                
                request.setAttribute("schedulefalag", schedulefalag);
                request.setAttribute("unitId", equipUnit);
//                request.setAttribute("currentMode", currentMode);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 15:
                servedPage = "/docs/schedule/edit_schedule_kil_unit.jsp";
                if (null!=request.getParameter("unit")){
                    request.setAttribute("unit", request.getParameter("unit").toString());
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 16:
                CancelUnitSchedule cancelUnitSchedule=CancelUnitSchedule.getInstance();
                WebBusinessObject varWbo = new WebBusinessObject();
                unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
                unitScheduleHistoryWbo = new WebBusinessObject();
                
                String scheduleId = null;
                schedulefalag=null;
                schedule = new WebBusinessObject();
                siteName = request.getParameter("siteName");
                equipUnit = request.getParameter("unitId");
                String[] checkCanceledSchedule = request.getParameterValues("cancelscheduleId");
                String[] cancelReasons = request.getParameterValues("reason");
                String tempreason="";
                varWbo.setAttribute("totalCount",request.getParameter("totalCount"));
                varWbo.setAttribute("beginScheduleDate",request.getParameter("beginScheduleDate"));
                for (int i = 0; i < checkCanceledSchedule.length; i++) {
                    scheduleId = checkCanceledSchedule[i];
                    unitScheduleHistoryWbo = unitScheduleHistoryMgr.getOnSingleKey(scheduleId);
                    try {
                        tempreason=cancelReasons[i];
                        if(tempreason==null || tempreason.equalsIgnoreCase(""))
                            tempreason="No Notes";
                        if(cancelUnitSchedule.saveObject((String)unitScheduleHistoryWbo.getAttribute("periodicId"),(String)unitScheduleHistoryWbo.getAttribute("id") ,tempreason,(String) unitScheduleHistoryWbo.getAttribute("rateNo"),session,varWbo)){
                            //unitScheduleHistoryMgr.deleteOnSingleKey(scheduleId);
                            unitScheduleHistoryMgr.updateCancelRate(scheduleId);
                            request.setAttribute("cancelStatus","ok");
                        }else{
                            request.setAttribute("cancelStatus","fail");
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
                
            case 17:
                servedPage = "/docs/schedule/edit_schedule_hr_unit.jsp";
                if (null!=request.getParameter("unit")){
                    request.setAttribute("unit", request.getParameter("unit").toString());
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 18:
                SecurityUser securityUser=(SecurityUser)session.getAttribute("securityUser");
                String siteId = securityUser.getSiteId();
                String userId = securityUser.getUserId();
                String searchBy = securityUser.getSearchBy();

                String unitName = (String)request.getParameter("unitName");
                String formName = (String)request.getParameter("formName");
                if(unitName != null && !unitName.equals("")){
                    String[] parts = unitName.split(",");
                    unitName = "";
                    for (int i=0;i<parts.length;i++){
                        char c = (char) new Integer(parts[i]).intValue();
                        unitName +=c;
                    }
                }
                Vector categoryTemp = new Vector();
                int count=0;
                String url="AverageUnitServlet?op=listEquipmentBySite";
                maintainableMgr = MaintainableMgr.getInstance();
                try {
                    if(unitName != null && !unitName.equals("")){
                        if((userId.equals("1")) || (searchBy.equals("all"))){
                            categoryTemp = maintainableMgr.getEquipBySubName(unitName);
                        }else
                            categoryTemp = maintainableMgr.getEquipBySubNameAndSiteId(siteId, unitName);
                    }else {
                        if((userId.equals("1")) || (searchBy.equals("all"))){
                            categoryTemp = maintainableMgr.getOnArbitraryDoubleKeyOracle("1", "key3", "0", "key5");
                        }else
                            categoryTemp = maintainableMgr.getEquipBySiteId(siteId);
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                eqpsArray=new ArrayList();
                for(int i=0;i<categoryTemp.size();i++){
                    unitWbo = (WebBusinessObject) categoryTemp.get(i);
                    if(unitWbo.getAttribute("rateType").equals("By Hour")){
                    eqpsArray.add(categoryTemp.get(i));
                    }
                }
                String tempcount = request.getParameter("count");
                if(tempcount!=null)
                    count=Integer.parseInt(tempcount);

                Vector category = new Vector();

                int index=(count+1)*10;
                String id="";
                Vector checkattched=new Vector();
                WebBusinessObject wbo;
                SupplementMgr supplementMgr=SupplementMgr.getInstance();
                if(eqpsArray.size()<index)
                    index=eqpsArray.size();
                for (int i = count*10; i <index ; i++) {
                    wbo = (WebBusinessObject) eqpsArray.get(i);

                    category.add(wbo);

                }

                float noOfLinks=eqpsArray.size()/10f;
                String temp=""+noOfLinks;
                int intNo=Integer.parseInt(temp.substring(temp.indexOf(".")+1,temp.length()));
                int links=(int)noOfLinks;
                if(intNo>0)
                    links++;
                if(links==1)
                    links=0;

                session.removeAttribute("CategoryID");
                servedPage = "/docs/new_report/equipments_list.jsp";
                request.setAttribute("count",""+count);
                request.setAttribute("noOfLinks",""+links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);
                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);

                // to reload current parant
                String reloadUrl = "AverageUnitServlet?op=GetAverageUnitForm";
                request.setAttribute("reload", "ok");
                request.setAttribute("reloadUrl", reloadUrl);

                this.forward(servedPage, request, response);
                break;

            case 19:
                averageUnit = new Vector();
                allAverageUnit = new Vector();
                averageUnitMgr.cashData();
                equipmentID = request.getParameter("equipmentID").toString();
                
                try {
                    averageUnit = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                    allAverageUnit = readingRateUnitMgr.getAllReadingForEquipment(equipmentID);
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                servedPage = "/docs/equipment/Average_equipment_List_KL_Pupop.jsp";

                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("data", averageUnit);
                request.setAttribute("unitName", request.getParameter("unitName"));
                request.setAttribute("alldata", allAverageUnit);

                this.forward(servedPage, request, response);
                break;

             case 20:
                averageUnit = new Vector();
                allAverageUnit = new Vector();
                averageUnitMgr.cashData();
                equipmentID = request.getParameter("equipmentID").toString();
                try {
                    averageUnit = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                    allAverageUnit = readingRateUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                MaintainableMgr maintainableMgr1=MaintainableMgr.getInstance();
                unitName=maintainableMgr1.getUnitName(equipmentID);
                servedPage = "/docs/equipment/Average_equipment_List_HR_Pupop.jsp";

                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("unitName",unitName);
                request.setAttribute("data", averageUnit);
                request.setAttribute("alldata", allAverageUnit);

                this.forward(servedPage, request, response);

              break;

            case 21:
                averageUnit = new Vector();
                averageUnitMgr.cashData();
                equipmentID = request.getParameter("equipmentID").toString();
                try {
                    averageUnit = averageUnitMgr.getEqpNameCurReading(equipmentID);
                    String eqpCurrentReading =((Row)averageUnit.get(0)).getString("CURRENT_READING");
                    String prvReading =((Row)averageUnit.get(0)).getString("acual_Reading");
                    String eqpName = ((Row)averageUnit.get(0)).getString("UNIT_NAME");
                    request.setAttribute("currentReading", eqpCurrentReading);
                    request.setAttribute("equipName", eqpName);
                    request.setAttribute("prvReading", prvReading);
                  }catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                String reset =(String) request.getParameter("reset");
                request.setAttribute("equipmentID", equipmentID);
                if(reset!=null && !reset.equals("")){
                    servedPage="/docs/equipment/operation/resetEqpReading.jsp";
                }else{
                    servedPage="/docs/equipment/operation/updateEqpReading.jsp";
                }
               
                this.forward(servedPage, request, response);
                break;
            case 22:
                   equipmentID = (String)request.getParameter("equipmentID");
                   WebBusinessObject AveragE = new WebBusinessObject();
                   now=timenow();
                    if (equipmentID != null && !equipmentID.equals("")) {
                        request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                        AveragE.setAttribute("current_Reading", request.getParameter("eqpReading"));
                        //AveragE.setAttribute("prvReading", request.getParameter("prvReading"));
                        AveragE.setAttribute("description", "test");
                        AveragE.setAttribute("unit", equipmentID);
                        String checkUpdatE = averageUnitMgr.getTrueUpdate(equipmentID);
                        if (checkUpdatE != null) {
                                averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdatE);
                                String prevDate = averageUnitMgr.prevDate(equipmentID);
                                if (averageUnitMgr.updateAverage(AveragE, averageUpdate, prevDate, now)) {
                                    request.setAttribute("Status", "Ok");
                                    System.out.println("Save Done");
                                } else {
                                    request.setAttribute("Status", "No");
                                    System.out.println("Error Happened");
                                }
                            } else {
                            try {
                                if (averageUnitMgr.saveObject(AveragE, session, now)) {
                                    request.setAttribute("Status", "Ok");
                                  } else {
                                    request.setAttribute("Status", "No");
                                }
                    
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(AverageUnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }}}
                  String ss =(String)request.getParameter("prvReading");
                  request.setAttribute("currentReading", request.getParameter("eqpReading"));
                  request.setAttribute("currentReading", request.getParameter("eqpReading"));
                  request.setAttribute("prvReading", request.getParameter("prvReading"));
                  request.setAttribute("equipName", request.getParameter("eqpName"));
                 servedPage="/docs/equipment/operation/updateEqpReading.jsp";
                 this.forward(servedPage, request, response);
                 break;

            case 23:
                servedPage = "/docs/new_search/search_schedule_by_reading.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 24:
                servedPage = "/docs/new_search/resault_schedule_by_reading.jsp";
                String mainCatId = (String) request.getParameter("mainCatId");
                scheduleId = (String) request.getParameter("scheduleId");
                siteId = (String) request.getParameter("siteId");
                String sUnitId = (String) request.getParameter("unitId");
                ReadingByScheduleMgr readingByScheduleMgr = ReadingByScheduleMgr.getInstance();
                List dataList = new ArrayList();
                Vector siteV = new Vector();
                siteWbo = new WebBusinessObject();
                if(siteId != null && !siteId.equals("")){
                    ProjectMgr siteMgr = ProjectMgr.getInstance();
                    siteWbo = (WebBusinessObject) siteMgr.getOnSingleKey(siteId);
                    if(siteWbo.getAttribute("mainProjId").toString().equals("0")){
                        try {
                            siteV = siteMgr.getOnArbitraryKey(siteWbo.getAttribute("projectID").toString(), "key2");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                ResultDataReportBean resultDataReportBean ;
                AverageUnitMgr avgUnitMgr = AverageUnitMgr.getInstance();
                WebBusinessObject wboAvgUnit= new WebBusinessObject();
                ScheduleMgr schMgr = ScheduleMgr.getInstance();
                List viewList = new ArrayList();
                WebBusinessObject wboSch;
                if(siteV.size()>0){
                    siteV.add(siteWbo);
                    for(int y=0;y<siteV.size();y++){
                        WebBusinessObject siteObj = new WebBusinessObject();
                        siteObj = (WebBusinessObject) siteV.get(y);
                        siteId = siteObj.getAttribute("projectID").toString();
                        dataList = readingByScheduleMgr.getScheduleWorkByMainType(mainCatId, siteId,sUnitId,scheduleId);
                          for(int i=0;i<dataList.size();i++){
                            try {
                                ResultDataReportBean results = new ResultDataReportBean();
                                resultDataReportBean = new ResultDataReportBean();
                                wboSch = new WebBusinessObject();
                                resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                                Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                                MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                                WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                                resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                                wboAvgUnit = (WebBusinessObject)avgUnitV.get(0);
                                int currReading = new Integer (wboAvgUnit.getAttribute("current_Reading").toString());
                                int prvReading = new Integer (wboAvgUnit.getAttribute("acual_Reading").toString());
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                                Calendar calendar = Calendar.getInstance();
                                java.util.Date resultdate = new Date(new Long(sEntryDate));
                                calendar.setTime(resultdate);
                                String sEntryTime = sdf.format(calendar.getTime());
                                java.util.Date  entDate= sdf.parse(sEntryTime);
                                resultDataReportBean.setCurrentReadingDate(entDate);

                                String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                                calendar = Calendar.getInstance();
                                java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                                calendar.setTime(resultPrvdate);
                                String sPrvTime = sdf.format(calendar.getTime());
                                java.util.Date  prvDate= sdf.parse(sPrvTime);
                                resultDataReportBean.setPrvReadingDate(prvDate);

                               // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                                resultDataReportBean.setLastReadingMachine(currReading);
                                resultDataReportBean.setCurrReading(currReading);
                                resultDataReportBean.setPrvReading(prvReading);
                               // resultDataReportBean.setReadingTravel(distTravel);
                                IssueMgr issueMgr = IssueMgr.getInstance();
                                Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(),"key4");
                                WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
                                java.util.Date  issueDate= sdf.parse(wboIssue.getAttribute("creationTime").toString());
                                SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
                                String sDate = fDate.format(issueDate);
                                resultDataReportBean.setJobOrderDate(sDate);
                                IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
                                String sIssueId = wboIssue.getAttribute("id").toString();
                                WebBusinessObject wboIssCountRead = null;
                                int counterReading =0;
                                try{
                                    wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
                                    counterReading = new Integer (wboIssCountRead.getAttribute("counterReading").toString()).intValue();
                                }catch(NullPointerException e){
                                    counterReading =0;
                                }
                                unitScheduleMgr = UnitScheduleMgr.getInstance();
                                WebBusinessObject unitScheduleWbo = new WebBusinessObject();
                                unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
                                ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                                WebBusinessObject scheduleWbo = new WebBusinessObject();
                                scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                                resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
                                resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());

                                resultDataReportBean.setReadingJobOrder(counterReading);
                                resultDataReportBean.setDiffReading(currReading-counterReading);
                                results = resultDataReportBean;
        //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
        //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
        //                        resultDataReportBean.setSchFrec(shKMm);
                                viewList.add(results);
                            } catch (SQLException ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }

                }else{
                    dataList = readingByScheduleMgr.getScheduleWorkByMainType(mainCatId, siteId,sUnitId,scheduleId);

                    for(int i=0;i<dataList.size();i++){
                        try {
                            ResultDataReportBean results = new ResultDataReportBean();
                            resultDataReportBean = new ResultDataReportBean();
                            wboSch = new WebBusinessObject();
                            resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                            Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                            MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                            WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                            resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                            wboAvgUnit = (WebBusinessObject)avgUnitV.get(0);
                            int currReading = new Integer (wboAvgUnit.getAttribute("current_Reading").toString());
                            int prvReading = new Integer (wboAvgUnit.getAttribute("acual_Reading").toString());
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                            Calendar calendar = Calendar.getInstance();
                            java.util.Date resultdate = new Date(new Long(sEntryDate));
                            calendar.setTime(resultdate);
                            String sEntryTime = sdf.format(calendar.getTime());
                            java.util.Date  entDate= sdf.parse(sEntryTime);
                            resultDataReportBean.setCurrentReadingDate(entDate);

                            String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                            calendar = Calendar.getInstance();
                            java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                            calendar.setTime(resultPrvdate);
                            String sPrvTime = sdf.format(calendar.getTime());
                            java.util.Date  prvDate= sdf.parse(sPrvTime);
                            resultDataReportBean.setPrvReadingDate(prvDate);

                           // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                            resultDataReportBean.setLastReadingMachine(currReading);
                            resultDataReportBean.setCurrReading(currReading);
                            resultDataReportBean.setPrvReading(prvReading);
                           // resultDataReportBean.setReadingTravel(distTravel);
                            IssueMgr issueMgr = IssueMgr.getInstance();
                            Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(),"key4");
                            WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
                            java.util.Date  issueDate= sdf.parse(wboIssue.getAttribute("creationTime").toString());
                            SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
                            String sDate = fDate.format(issueDate);
                            resultDataReportBean.setJobOrderDate(sDate);
                            IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
                            String sIssueId = wboIssue.getAttribute("id").toString();
                            WebBusinessObject wboIssCountRead = null;
                            int counterReading =0;
                            try{
                                wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
                                counterReading = new Integer (wboIssCountRead.getAttribute("counterReading").toString()).intValue();
                            }catch(NullPointerException e){
                                counterReading =0;
                            }
                            unitScheduleMgr = UnitScheduleMgr.getInstance();
                            WebBusinessObject unitScheduleWbo = new WebBusinessObject();
                            unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
                            ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                            WebBusinessObject scheduleWbo = new WebBusinessObject();
                            scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                            resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
                            resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());

                            resultDataReportBean.setReadingJobOrder(counterReading);
                            resultDataReportBean.setDiffReading(currReading-counterReading);
                            results = resultDataReportBean;
    //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
    //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
    //                        resultDataReportBean.setSchFrec(shKMm);
                            viewList.add(results);
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                
                request.setAttribute("viewList", viewList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

                case 25:
                servedPage = "/docs/equipment/Last_Reading_By_Job_Order.jsp";
                mainCatId = (String) request.getParameter("mainCatId");
                scheduleId = (String) request.getParameter("scheduleId");
                siteId = (String) request.getParameter("siteId");
                sUnitId = (String) request.getParameter("unitId");
                unitName = (String) request.getParameter("unitName");
                readingByScheduleMgr = ReadingByScheduleMgr.getInstance();
                dataList = new ArrayList();
                siteV = new Vector();
                siteWbo = new WebBusinessObject();
                if(siteId != null && !siteId.equals("")){
                    ProjectMgr siteMgr = ProjectMgr.getInstance();
                    siteWbo = (WebBusinessObject) siteMgr.getOnSingleKey(siteId);
                    if(siteWbo.getAttribute("mainProjId").toString().equals("0")){
                        try {
                            siteV = siteMgr.getOnArbitraryKey(siteWbo.getAttribute("projectID").toString(), "key2");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
//                ResultDataReportBean resultDataReportBean ;
                avgUnitMgr = AverageUnitMgr.getInstance();
                wboAvgUnit= new WebBusinessObject();
                schMgr = ScheduleMgr.getInstance();
                viewList = new ArrayList();
//                WebBusinessObject wboSch;
                if(siteV.size()>0){
                    siteV.add(siteWbo);
                    for(int y=0;y<siteV.size();y++){
                        WebBusinessObject siteObj = new WebBusinessObject();
                        siteObj = (WebBusinessObject) siteV.get(y);
                        siteId = siteObj.getAttribute("projectID").toString();
                        dataList = readingByScheduleMgr.getScheduleWorkByMainType(mainCatId, siteId,sUnitId,scheduleId);
                          for(int i=0;i<dataList.size();i++){
                            try {
                                ResultDataReportBean results = new ResultDataReportBean();
                                resultDataReportBean = new ResultDataReportBean();
                                wboSch = new WebBusinessObject();
                                resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                                Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                                MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                                WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                                resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                                wboAvgUnit = (WebBusinessObject)avgUnitV.get(0);
                                int currReading = new Integer (wboAvgUnit.getAttribute("current_Reading").toString());
                                int prvReading = new Integer (wboAvgUnit.getAttribute("acual_Reading").toString());
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                                Calendar calendar = Calendar.getInstance();
                                java.util.Date resultdate = new Date(new Long(sEntryDate));
                                calendar.setTime(resultdate);
                                String sEntryTime = sdf.format(calendar.getTime());
                                java.util.Date  entDate= sdf.parse(sEntryTime);
                                resultDataReportBean.setCurrentReadingDate(entDate);

                                String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                                calendar = Calendar.getInstance();
                                java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                                calendar.setTime(resultPrvdate);
                                String sPrvTime = sdf.format(calendar.getTime());
                                java.util.Date  prvDate= sdf.parse(sPrvTime);
                                resultDataReportBean.setPrvReadingDate(prvDate);

                               // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                                resultDataReportBean.setLastReadingMachine(currReading);
                                resultDataReportBean.setCurrReading(currReading);
                                resultDataReportBean.setPrvReading(prvReading);
                               // resultDataReportBean.setReadingTravel(distTravel);
                                IssueMgr issueMgr = IssueMgr.getInstance();
                                Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(),"key4");
                                WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
                                java.util.Date  issueDate= sdf.parse(wboIssue.getAttribute("creationTime").toString());
                                SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
                                String sDate = fDate.format(issueDate);
                                resultDataReportBean.setJobOrderDate(sDate);
                                IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
                                String sIssueId = wboIssue.getAttribute("id").toString();
                                WebBusinessObject wboIssCountRead = null;
                                int counterReading =0;
                                try{
                                    wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
                                    counterReading = new Integer (wboIssCountRead.getAttribute("counterReading").toString()).intValue();
                                }catch(NullPointerException e){
                                    counterReading =0;
                                }
                                unitScheduleMgr = UnitScheduleMgr.getInstance();
                                WebBusinessObject unitScheduleWbo = new WebBusinessObject();
                                unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
                                ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                                WebBusinessObject scheduleWbo = new WebBusinessObject();
                                scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                                resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
                                resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());

                                resultDataReportBean.setReadingJobOrder(counterReading);
                                resultDataReportBean.setDiffReading(currReading-counterReading);
                                results = resultDataReportBean;
        //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
        //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
        //                        resultDataReportBean.setSchFrec(shKMm);
                                viewList.add(results);
                            } catch (SQLException ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }

                }else{
                    dataList = readingByScheduleMgr.getScheduleWorkByMainType(mainCatId, siteId,sUnitId,scheduleId);

                    for(int i=0;i<dataList.size();i++){
                        try {
                            ResultDataReportBean results = new ResultDataReportBean();
                            resultDataReportBean = new ResultDataReportBean();
                            wboSch = new WebBusinessObject();
                            resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                            Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                            MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                            WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                            resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                            wboAvgUnit = (WebBusinessObject)avgUnitV.get(0);
                            int currReading = new Integer (wboAvgUnit.getAttribute("current_Reading").toString());
                            int prvReading = new Integer (wboAvgUnit.getAttribute("acual_Reading").toString());
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                            Calendar calendar = Calendar.getInstance();
                            java.util.Date resultdate = new Date(new Long(sEntryDate));
                            calendar.setTime(resultdate);
                            String sEntryTime = sdf.format(calendar.getTime());
                            java.util.Date  entDate= sdf.parse(sEntryTime);
                            resultDataReportBean.setCurrentReadingDate(entDate);

                            String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                            calendar = Calendar.getInstance();
                            java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                            calendar.setTime(resultPrvdate);
                            String sPrvTime = sdf.format(calendar.getTime());
                            java.util.Date  prvDate= sdf.parse(sPrvTime);
                            resultDataReportBean.setPrvReadingDate(prvDate);

                           // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                            resultDataReportBean.setLastReadingMachine(currReading);
                            resultDataReportBean.setCurrReading(currReading);
                            resultDataReportBean.setPrvReading(prvReading);
                           // resultDataReportBean.setReadingTravel(distTravel);
                            IssueMgr issueMgr = IssueMgr.getInstance();
                            Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(),"key4");
                            WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
                            java.util.Date  issueDate= sdf.parse(wboIssue.getAttribute("creationTime").toString());
                            SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
                            String sDate = fDate.format(issueDate);
                            resultDataReportBean.setJobOrderDate(sDate);
                            IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
                            String sIssueId = wboIssue.getAttribute("id").toString();
                            WebBusinessObject wboIssCountRead = null;
                            int counterReading =0;
                            try{
                                wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
                                counterReading = new Integer (wboIssCountRead.getAttribute("counterReading").toString()).intValue();
                            }catch(NullPointerException e){
                                counterReading =0;
                            }
                            unitScheduleMgr = UnitScheduleMgr.getInstance();
                            WebBusinessObject unitScheduleWbo = new WebBusinessObject();
                            unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
                            ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                            WebBusinessObject scheduleWbo = new WebBusinessObject();
                            scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                            resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
                            resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());

                            resultDataReportBean.setReadingJobOrder(counterReading);
                            resultDataReportBean.setDiffReading(currReading-counterReading);
                            results = resultDataReportBean;
    //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
    //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
    //                        resultDataReportBean.setSchFrec(shKMm);
                            viewList.add(results);
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }

                request.setAttribute("equipmentID", sUnitId);
                request.setAttribute("unitName", request.getParameter("unitName"));
                request.setAttribute("viewList", viewList);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 26:
                servedPage = "/docs/new_search/search_reading_unit_without_job.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 27:
                servedPage = "/docs/new_search/resault_reading_without_job.jsp";
                mainCatId = (String) request.getParameter("mainCatId");
                scheduleId = (String) request.getParameter("scheduleId");
                siteId = (String) request.getParameter("siteId");
                sUnitId = (String) request.getParameter("unitId");
                readingByScheduleMgr = ReadingByScheduleMgr.getInstance();
                dataList = new ArrayList();
                siteV = new Vector();
                siteWbo = new WebBusinessObject();
                if(siteId != null && !siteId.equals("")){
                    ProjectMgr siteMgr = ProjectMgr.getInstance();
                    siteWbo = (WebBusinessObject) siteMgr.getOnSingleKey(siteId);
                    if(siteWbo.getAttribute("mainProjId").toString().equals("0")){
                        try {
                            siteV = siteMgr.getOnArbitraryKey(siteWbo.getAttribute("projectID").toString(), "key2");
                        } catch (SQLException ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
//                ResultDataReportBean resultDataReportBean ;
                avgUnitMgr = AverageUnitMgr.getInstance();
                wboAvgUnit= new WebBusinessObject();
                schMgr = ScheduleMgr.getInstance();
                viewList = new ArrayList();
//                WebBusinessObject wboSch;
                if(siteV.size()>0){
                    siteV.add(siteWbo);
                    for(int y=0;y<siteV.size();y++){
                        WebBusinessObject siteObj = new WebBusinessObject();
                        siteObj = (WebBusinessObject) siteV.get(y);
                        siteId = siteObj.getAttribute("projectID").toString();
                        dataList = readingByScheduleMgr.getReadingUnitWithoutJob(mainCatId, siteId,sUnitId,scheduleId);
                          for(int i=0;i<dataList.size();i++){
                            try {
                                ResultDataReportBean results = new ResultDataReportBean();
                                resultDataReportBean = new ResultDataReportBean();
                                wboSch = new WebBusinessObject();
                                resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                                Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                                MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                                WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                                resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                                wboAvgUnit = (WebBusinessObject)avgUnitV.get(0);
                                int currReading = new Integer (wboAvgUnit.getAttribute("current_Reading").toString());
                                int prvReading = new Integer (wboAvgUnit.getAttribute("acual_Reading").toString());
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                                Calendar calendar = Calendar.getInstance();
                                java.util.Date resultdate = new Date(new Long(sEntryDate));
                                calendar.setTime(resultdate);
                                String sEntryTime = sdf.format(calendar.getTime());
                                java.util.Date  entDate= sdf.parse(sEntryTime);
                                resultDataReportBean.setCurrentReadingDate(entDate);

                                String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                                calendar = Calendar.getInstance();
                                java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                                calendar.setTime(resultPrvdate);
                                String sPrvTime = sdf.format(calendar.getTime());
                                java.util.Date  prvDate= sdf.parse(sPrvTime);
                                resultDataReportBean.setPrvReadingDate(prvDate);

                               // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                                resultDataReportBean.setLastReadingMachine(currReading);
                                resultDataReportBean.setCurrReading(currReading);
                                resultDataReportBean.setPrvReading(prvReading);
                               // resultDataReportBean.setReadingTravel(distTravel);
//                                IssueMgr issueMgr = IssueMgr.getInstance();
//                                Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(),"key4");
//                                WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
//                                java.util.Date  issueDate= sdf.parse(wboIssue.getAttribute("creationTime").toString());
//                                SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
//                                String sDate = fDate.format(issueDate);
//                                resultDataReportBean.setJobOrderDate(sDate);
//                                IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
//                                String sIssueId = wboIssue.getAttribute("id").toString();
//                                WebBusinessObject wboIssCountRead = null;
//                                int counterReading =0;
//                                try{
//                                    wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
//                                    counterReading = new Integer (wboIssCountRead.getAttribute("counterReading").toString()).intValue();
//                                }catch(NullPointerException e){
//                                    counterReading =0;
//                                }
//                                unitScheduleMgr = UnitScheduleMgr.getInstance();
//                                WebBusinessObject unitScheduleWbo = new WebBusinessObject();
//                                unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
//                                ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
//                                WebBusinessObject scheduleWbo = new WebBusinessObject();
//                                scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
//                                resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
//                                resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());
//
//                                resultDataReportBean.setReadingJobOrder(counterReading);
//                                resultDataReportBean.setDiffReading(currReading-counterReading);
                                results = resultDataReportBean;
        //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
        //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
        //                        resultDataReportBean.setSchFrec(shKMm);
                                viewList.add(results);
                            } catch (SQLException ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (Exception ex) {
                                Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }

                }else{
                    dataList = readingByScheduleMgr.getReadingUnitWithoutJob(mainCatId, siteId,sUnitId,scheduleId);

                    for(int i=0;i<dataList.size();i++){
                        try {
                            ResultDataReportBean results = new ResultDataReportBean();
                            resultDataReportBean = new ResultDataReportBean();
                            wboSch = new WebBusinessObject();
                            resultDataReportBean = (ResultDataReportBean) dataList.get(i);
                            Vector avgUnitV = avgUnitMgr.getOnArbitraryKey(resultDataReportBean.getUnitId(), "key1");
                            MainCategoryTypeMgr mainCatMgr = MainCategoryTypeMgr.getInstance();
                            WebBusinessObject wboMainCat = mainCatMgr.getOnSingleKey(resultDataReportBean.getMainCatId());
                            resultDataReportBean.setMainCatName(wboMainCat.getAttribute("typeName").toString());
                            wboAvgUnit = (WebBusinessObject)avgUnitV.get(0);
                            int currReading = new Integer (wboAvgUnit.getAttribute("current_Reading").toString());
                            int prvReading = new Integer (wboAvgUnit.getAttribute("acual_Reading").toString());
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String sEntryDate = wboAvgUnit.getAttribute("entry_Time").toString();
                            Calendar calendar = Calendar.getInstance();
                            java.util.Date resultdate = new Date(new Long(sEntryDate));
                            calendar.setTime(resultdate);
                            String sEntryTime = sdf.format(calendar.getTime());
                            java.util.Date  entDate= sdf.parse(sEntryTime);
                            resultDataReportBean.setCurrentReadingDate(entDate);

                            String sPrvDate = wboAvgUnit.getAttribute("previousTime").toString();
                            calendar = Calendar.getInstance();
                            java.util.Date resultPrvdate = new Date(new Long(sPrvDate));
                            calendar.setTime(resultPrvdate);
                            String sPrvTime = sdf.format(calendar.getTime());
                            java.util.Date  prvDate= sdf.parse(sPrvTime);
                            resultDataReportBean.setPrvReadingDate(prvDate);

                           // int distTravel = readingByScheduleMgr.getSUM_DISTANCE(resultDataReportBean.getUnitName(),sqlDate);
                            resultDataReportBean.setLastReadingMachine(currReading);
                            resultDataReportBean.setCurrReading(currReading);
                            resultDataReportBean.setPrvReading(prvReading);
                           // resultDataReportBean.setReadingTravel(distTravel);
//                            IssueMgr issueMgr = IssueMgr.getInstance();
//                            Vector issueV = issueMgr.getOnArbitraryKey(resultDataReportBean.getJobOrderNo(),"key4");
//                            WebBusinessObject wboIssue = (WebBusinessObject) issueV.get(0);
//                            java.util.Date  issueDate= sdf.parse(wboIssue.getAttribute("creationTime").toString());
//                            SimpleDateFormat fDate = new SimpleDateFormat("dd/MM/yyyy");
//                            String sDate = fDate.format(issueDate);
//                            resultDataReportBean.setJobOrderDate(sDate);
//                            IssueCounterReadingMgr issCountReadMgr = IssueCounterReadingMgr.getInstance();
//                            String sIssueId = wboIssue.getAttribute("id").toString();
//                            WebBusinessObject wboIssCountRead = null;
//                            int counterReading =0;
//                            try{
//                                wboIssCountRead = issCountReadMgr.getOnSingleKey(sIssueId);
//                                counterReading = new Integer (wboIssCountRead.getAttribute("counterReading").toString()).intValue();
//                            }catch(NullPointerException e){
//                                counterReading =0;
//                            }
//                            unitScheduleMgr = UnitScheduleMgr.getInstance();
//                            WebBusinessObject unitScheduleWbo = new WebBusinessObject();
//                            unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(wboIssue.getAttribute("unitScheduleID").toString());
//                            ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
//                            WebBusinessObject scheduleWbo = new WebBusinessObject();
//                            scheduleWbo = (WebBusinessObject) scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
//                            resultDataReportBean.setSchTitle(scheduleWbo.getAttribute("maintenanceTitle").toString());
//                            resultDataReportBean.setWhichCloser(new Integer(scheduleWbo.getAttribute("whichCloser").toString()).intValue());
//
//                            resultDataReportBean.setReadingJobOrder(counterReading);
//                            resultDataReportBean.setDiffReading(currReading-counterReading);
                            results = resultDataReportBean;
    //                        wboSch = (WebBusinessObject)schMgr.getOnSingleKey(resultDataReportBean.getSchId());
    //                        int shKMm = new Integer (wboSch.getAttribute("whichCloser").toString());
    //                        resultDataReportBean.setSchFrec(shKMm);
                            viewList.add(results);
                        } catch (SQLException ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ReportsServletThree.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }

                request.setAttribute("viewList", viewList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

             case 28:
                   equipmentID = (String)request.getParameter("equipmentID");
                   AveragE = new WebBusinessObject();
                   now=timenow();
                    if (equipmentID != null && !equipmentID.equals("")) {
                        request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                        AveragE.setAttribute("current_Reading", request.getParameter("eqpReading"));
                        //AveragE.setAttribute("prvReading", request.getParameter("prvReading"));
                        AveragE.setAttribute("description", "test");
                        AveragE.setAttribute("unit", equipmentID);
                        String checkUpdatE = averageUnitMgr.getTrueUpdate(equipmentID);
                        if (checkUpdatE != null) {
                                averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdatE);
                                String prevDate = averageUnitMgr.prevDate(equipmentID);
                                if (averageUnitMgr.resetAverage(AveragE, averageUpdate, prevDate, now)) {
                                    request.setAttribute("Status", "Ok");
                                    System.out.println("Save Done");
                                } else {
                                    request.setAttribute("Status", "No");
                                    System.out.println("Error Happened");
                                }
                            } else {
                            try {
                                if (averageUnitMgr.saveObject(AveragE, session, now)) {
                                    request.setAttribute("Status", "Ok");
                                  } else {
                                    request.setAttribute("Status", "No");
                                }

                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(AverageUnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }}}
                   
                  request.setAttribute("currentReading", request.getParameter("eqpReading"));
                  request.setAttribute("currentReading", request.getParameter("eqpReading"));
                  request.setAttribute("prvReading", request.getParameter("prvReading"));
                  request.setAttribute("equipName", request.getParameter("eqpName"));
                 servedPage="/docs/equipment/operation/resetEqpReading.jsp";
                 this.forward(servedPage, request, response);
                 break;

               default:
                logger.info("No operation was matched");
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
        return "Search Servlet";
    }
    
    protected int getOpCode(String opName) {
        if (opName.equals("GetAverageUnitForm")) {
            return 1;
        }
        
        if (opName.equals("SaveAverageUnit")) {
            return 2;
        }
        
        if (opName.equals("ListAverageUnit")) {
            return 3;
        }
        
        if (opName.equals("GetAverageeKelUnitForm")) {
            return 4;
        }
        
        if (opName.equals("GetTEST")) {
            return 5;
        }
        
        if (opName.equals("ListAverageeKelUnitForm")) {
            return 6;
        }
        
        if (opName.equals("UpdateAverageUnitForm")) {
            return 7;
        }
        if (opName.equals("SaveAverageUnitForm")) {
            return 8;
        }
        if (opName.equals("UpdateAverageKelUnitForm")) {
            return 9;
        }
        if (opName.equals("ListAverageUnitForm")) {
            return 10;
        }
        if (opName.equals("ListAverageKelUnitForm")) {
            return 11;
        }
        if (opName.equals("AutoReadingMachine")) {
            return 12;
        }
        if (opName.equals("GetJobOrder")) {
            return 13;
        }
        
        if (opName.equals("ExecuteSchedule")) {
            return 14;
        }
        if (opName.equals("GetScheduleForUnitByKil")) {
            return 15;
        }
        if (opName.equals("cancelSchedule")) {
            return 16;
        }
        if (opName.equals("GetScheduleForUnitByHr")) {
            return 17;
        }
        if (opName.equals("listEquipmentBySite")) {
            return 18;
        }
        if (opName.equals("listReadingKelPupop")) {
            return 19;
        }
         if (opName.equals("listReadingHrPupop")) {
            return 20;
        }
         if (opName.equals("upDateCurrentReadingPupop")) {
            return 21;
        }
         if (opName.equals("saveCurrentReading")) {
            return 22;
        }
         if(opName.equals("getschedualByReadingReport")){
            return 23;
        }

        if(opName.equals("resaultScheduleReadingReport")){
            return 24;
        }

        if(opName.equals("resaultScheduleReadingReportByMachine")){
            return 25;
        }

        if(opName.equals("getReadingUnitWithoutJobReport")){
            return 26;
        }

        if(opName.equals("resaultReadingUnitWithoutJobReport")){
            return 27;
        }

        if (opName.equals("saveResetCurrentReading")) {
            return 28;
        }

        return 0;
    }
    
    public String runTime() {
        
        Date d = Calendar.getInstance().getTime();
        long id = d.getTime();
        
        String stringID = new Long(id).toString();
        String test = new String(stringID);
        Long l = new Long(test);
        long sl = l.longValue();
        
        d.setTime(sl);
        
        
        return d.toString();
    }
    
    public long timenow() {
        
        Date d = Calendar.getInstance().getTime();
        
        long nowTime = d.getTime();
        
        return nowTime;
    }
    
    public String prevTime(String enterDate) {
        
        Date d = Calendar.getInstance().getTime();
        long id = d.getTime();
        
        String stringID = new Long(id).toString();
        String test = new String(enterDate);
        Long l = new Long(test);
        long sl = l.longValue();
        
        d.setTime(sl);
        
//    //d.toString();
        return d.toString();
    }
    
    public int month(String mon) {
        
        if (mon.equals("Jan")) {
            return 1;
        }
        if (mon.equals("Feb")) {
            return 2;
        }
        if (mon.equals("Mar")) {
            return 3;
        }
        if (mon.equals("Apr")) {
            return 4;
        }
        if (mon.equals("May")) {
            return 5;
        }
        if (mon.equals("Jun")) {
            return 6;
        }
        if (mon.equals("Jul")) {
            return 7;
        }
        if (mon.equals("Aug")) {
            return 8;
        }
        if (mon.equals("Sep")) {
            return 9;
        }
        if (mon.equals("Oct")) {
            return 10;
        }
        if (mon.equals("Mov")) {
            return 11;
        }
        if (mon.equals("Dec")) {
            return 12;
        }
        
        return 0;
    }
    
    public String monthNum(String mon) {
        
        if (mon.equals("Jan")) {
            return "01";
        }
        if (mon.equals("Feb")) {
            return "02";
        }
        if (mon.equals("Mar")) {
            return "03";
        }
        if (mon.equals("Apr")) {
            return "04";
        }
        if (mon.equals("May")) {
            return "05";
        }
        if (mon.equals("Jun")) {
            return "06";
        }
        if (mon.equals("Jul")) {
            return "07";
        }
        if (mon.equals("Aug")) {
            return "08";
        }
        if (mon.equals("Sep")) {
            return "09";
        }
        if (mon.equals("Oct")) {
            return "10";
        }
        if (mon.equals("Mov")) {
            return "11";
        }
        if (mon.equals("Dec")) {
            return "12";
        }
        
        return "00";
    }
//    public int getSchNunmber(String mon){
//
//
//            return mon;
//    }
    public String operation(String op) {
        
        getOpCode(op);
        return op;
    }
}

