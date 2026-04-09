package com.maintenance.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import java.io.*;
import java.util.*;
import java.sql.SQLException;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.contractor.db_access.MaintainableMgr;
import com.crm.common.CRMConstants;
import com.crm.db_access.CommentsMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.UserGroupConfigMgr;

import com.maintenance.db_access.*;
import com.silkworm.common.GroupMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import java.text.SimpleDateFormat;
import org.json.simple.JSONValue;

public class ReportsServletTwo extends TrackerBaseServlet{
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request,response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        
        int month = 0;
        int year = 0;
        int minDate = 0;
        int maxDate = 0;
        
        String[] monthsArray = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
        String period = null;
        
        ArrayList equipmentsList = new ArrayList();
        ArrayList monthsList = new ArrayList();
        
        Vector eqpMissions = new Vector();
        Vector eqpSchedules = new Vector();
        
        WebBusinessObject equipmentWbo = null;
        WebBusinessObject monthWbo = new WebBusinessObject();
        
        MaintainableMgr equipmentsMgr = MaintainableMgr.getInstance();
        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
        
        Calendar monthCal = Calendar.getInstance();
        
        //Initialize months array list
        for(int i=0; i<12; i++){
            WebBusinessObject wbo = new WebBusinessObject();
            wbo.setAttribute("id", new Integer(i).toString());
            wbo.setAttribute("name", monthsArray[i]);
            monthsList.add(wbo);
        }
        
        switch(operation) {
            case 1:
                servedPage = "/docs/plan_reports/view_equipment_data.jsp";
                
                period = request.getParameter("peroid");
                
                try{
                    //Get Equipments Vector
                    equipmentsList = equipmentsMgr.getMaintenanbleEquAsBusObjects();
                    
                    if(period.equalsIgnoreCase("currentMonth")){
                        //Get current month
                        month = monthCal.getTime().getMonth();
                        
                        //Get first Equipment in the list
                        if(equipmentsList.size() > 0){
                            equipmentWbo = (WebBusinessObject) equipmentsList.get(0);
                        } else {
                            request.setAttribute("equipment", equipmentWbo);
                        }
                        
                        request.setAttribute("period","currentMonth");
                    } else {
                        //Get Selected Month
                        month = new Integer(request.getParameter("month")).intValue();
                        
                        //Get Selected Equipment
                        equipmentWbo = equipmentsMgr.getOnSingleKey(request.getParameter("equipment"));
                        
                        request.setAttribute("period","other");
                    }
                    
                    //period calculations
                    year = monthCal.getTime().getYear();
                    minDate = monthCal.getActualMinimum(monthCal.DATE);
                    maxDate = monthCal.getActualMaximum(monthCal.DATE);
                    
                    java.sql.Date beginDate = new java.sql.Date(year,month,minDate);
                    java.sql.Date endDate = new java.sql.Date(year,month,maxDate);
                    
                    //Get Equipment Schedules
                    eqpSchedules = unitScheduleMgr.getEqpSchedulesDates(equipmentWbo.getAttribute("id").toString(), beginDate, endDate);
                    if(eqpSchedules.size() >0){
                        request.setAttribute("eqpSchedules", eqpSchedules);
                    } else {
                        request.setAttribute("eqpSchedules", eqpSchedules);
                    }
                    
                    //create month wbo
                    monthWbo.setAttribute("id", new Integer(month).toString());
                    monthWbo.setAttribute("name", monthsArray[month]);
                    
                    request.setAttribute("month", monthWbo);
                    request.setAttribute("equipmentsList", equipmentsList);
                    request.setAttribute("monthsList", monthsList);
                    request.setAttribute("equipment",equipmentWbo);
                } catch (Exception ex){
                    System.out.println("Fleet Servlet -- get equipment schedule exception = "+ex.getMessage());
                }
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                servedPage = "/docs/plan_reports/main_report_plan_form.jsp";
                request.getSession().removeAttribute("tabId");
                request.getSession().setAttribute("tabId","1");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 3:
                servedPage = "/docs/plan_reports/view_eqp_day_details.jsp";
                
                //Get Selected Month
                month = new Integer(request.getParameter("month")).intValue();
                //Get Selected Equipment
                equipmentWbo = equipmentsMgr.getOnSingleKey(request.getParameter("equipment"));
                //Get selected day and calculate date
                String day = request.getParameter("day");
                year = monthCal.getTime().getYear();
                java.sql.Date dayDate = new java.sql.Date(year,month,new Integer(day).intValue());
                
                Hashtable unitSchTasks=new Hashtable();
                Hashtable unitSchParts=new Hashtable();
                
                try{
                    //Get Equipment Schedules
                    eqpSchedules = unitScheduleMgr.getEqpDaySchedules(equipmentWbo.getAttribute("id").toString(), dayDate);
                    
                    /*********** Get Schedule Maintenance items and spare parts *************/
                    ConfigureMainTypeMgr configMainTypeMgr=ConfigureMainTypeMgr.getInstance();
                    ScheduleTasksMgr scheduleTasksMgr=ScheduleTasksMgr.getInstance();
                    TaskMgr taskMgr=TaskMgr.getInstance();
                    DistributedItemsMgr DistItemsMgr=DistributedItemsMgr.getInstance();
                    TradeMgr tradeMgr=TradeMgr.getInstance();
                    
                    WebBusinessObject taskWbo=new WebBusinessObject();
                    WebBusinessObject partWbo=new WebBusinessObject();
                    WebBusinessObject schTaskWbo=new WebBusinessObject();
                    WebBusinessObject schPartWbo=new WebBusinessObject();
                    WebBusinessObject tradeWbo=new WebBusinessObject();
                    
                    WebBusinessObject unitSchWbo=new WebBusinessObject();
                    String scheduleId="";
                    Vector scheduleTasks=new Vector();
                    Vector scheduleParts=new Vector();
                    
                    Vector tasks=new Vector();
                    Vector parts=new Vector();
                    
                    for(int i=0;i<eqpSchedules.size();i++){
                        unitSchWbo=new WebBusinessObject();
                        scheduleTasks=new Vector();
                        scheduleParts=new Vector();
                        tasks=new Vector();
                        parts=new Vector();
                        scheduleId="";
                        
                        unitSchWbo=(WebBusinessObject)eqpSchedules.get(i);
                        scheduleId=unitSchWbo.getAttribute("periodicId").toString();
                        scheduleTasks=scheduleTasksMgr.getOnArbitraryKey(scheduleId,"key1");
                        scheduleParts=configMainTypeMgr.getOnArbitraryKey(scheduleId,"key1");
                        
                        for(int c=0;c<scheduleTasks.size();c++){
                            taskWbo=new WebBusinessObject();
                            schTaskWbo=new WebBusinessObject();
                            schTaskWbo=(WebBusinessObject)scheduleTasks.get(c);
                            taskWbo=taskMgr.getOnSingleKey(schTaskWbo.getAttribute("codeTask").toString());
                            tradeWbo=tradeMgr.getOnSingleKey(taskWbo.getAttribute("trade").toString());
                            taskWbo.setAttribute("tradeName",tradeWbo.getAttribute("tradeName").toString());
                            if(taskWbo!=null)
                                tasks.add(taskWbo);
                        }
                        
                        for(int n=0;n<scheduleParts.size();n++){
                            schPartWbo=new WebBusinessObject();
                            partWbo=new WebBusinessObject();
                            schPartWbo=(WebBusinessObject)scheduleParts.get(n);
                            partWbo=DistItemsMgr.getOnSingleKey(schPartWbo.getAttribute("itemId").toString());
                            schPartWbo.setAttribute("itemName",partWbo.getAttribute("itemName").toString());
                            if(partWbo!=null)
                                parts.add(schPartWbo);
                        }
                        unitSchTasks.put(unitSchWbo.getAttribute("id").toString(),tasks);
                        unitSchParts.put(unitSchWbo.getAttribute("id").toString(),parts);
                    }
                    
                    /*********** End of Schedule Maintenance items and spare parts *************/
                    
                } catch(Exception ex){
                    System.out.println("Fleet Servlet -- Get Equipment Day Detaild Excpetion = "+ex.getMessage());
                }
                
                String backTo=request.getParameter("backTo");
                
                
                request.setAttribute("backTo",backTo);
                request.setAttribute("unitSchTasks",unitSchTasks);
                request.setAttribute("unitSchParts",unitSchParts);
                request.setAttribute("dayDate", dayDate.toString());
                request.setAttribute("month", new Integer(month).toString());
                request.setAttribute("equipment", equipmentWbo);
                request.setAttribute("eqpSchedules", eqpSchedules);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                servedPage = "/docs/plan_reports/view_eqp_data_future.jsp";
                
                period = request.getParameter("peroid");
                
                int tempMonth = monthCal.getTime().getMonth();
                ArrayList futureMonths=new ArrayList();
                
                for(int i=tempMonth;i<12;i++){
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", monthsArray[i]);
                    futureMonths.add(wbo);
                }
                
                try{
                    //Get Equipments Vector
                    equipmentsList = equipmentsMgr.getMaintenanbleEquAsBusObjects();
                    
                    if(period.equalsIgnoreCase("currentMonth")){
                        //Get current month
                        month = monthCal.getTime().getMonth();
                        
                        //Get first Equipment in the list
                        if(equipmentsList.size() > 0){
                            equipmentWbo = (WebBusinessObject) equipmentsList.get(0);
                        } else {
                            request.setAttribute("equipment", equipmentWbo);
                        }
                        
                        request.setAttribute("period","currentMonth");
                    } else {
                        //Get Selected Month
                        month = new Integer(request.getParameter("month")).intValue();
                        
                        //Get Selected Equipment
                        equipmentWbo = equipmentsMgr.getOnSingleKey(request.getParameter("equipment"));
                        
                        request.setAttribute("period","other");
                    }
                    
                    //period calculations
                    year = monthCal.getTime().getYear();
                    minDate = monthCal.getActualMinimum(monthCal.DATE);
                    maxDate = monthCal.getActualMaximum(monthCal.DATE);
                    
                    java.sql.Date beginDate = new java.sql.Date(year,month,minDate);
                    java.sql.Date endDate = new java.sql.Date(year,month,maxDate);
                    
                    //Get Equipment Schedules
                    eqpSchedules = unitScheduleMgr.getEqpSchedulesDates(equipmentWbo.getAttribute("id").toString(), beginDate, endDate);
                    if(eqpSchedules.size() >0){
                        request.setAttribute("eqpSchedules", eqpSchedules);
                    } else {
                        request.setAttribute("eqpSchedules", eqpSchedules);
                    }
                    
                    //create month wbo
                    monthWbo.setAttribute("id", new Integer(month).toString());
                    monthWbo.setAttribute("name", monthsArray[month]);
                    
                    request.setAttribute("month", monthWbo);
                    request.setAttribute("equipmentsList", equipmentsList);
                    request.setAttribute("monthsList", futureMonths);
                    request.setAttribute("equipment",equipmentWbo);
                } catch (Exception ex){
                    System.out.println("Fleet Servlet -- get equipment schedule exception = "+ex.getMessage());
                }
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                servedPage = "/docs/plan_reports/view_eqp_data_past.jsp";
                
                period = request.getParameter("peroid");
                
                tempMonth = monthCal.getTime().getMonth();
                futureMonths=new ArrayList();
                
                for(int i=0;i<=tempMonth;i++){
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo.setAttribute("id", new Integer(i).toString());
                    wbo.setAttribute("name", monthsArray[i]);
                    futureMonths.add(wbo);
                }
                
                try{
                    //Get Equipments Vector
                    equipmentsList = equipmentsMgr.getMaintenanbleEquAsBusObjects();
                    
                    if(period.equalsIgnoreCase("currentMonth")){
                        //Get current month
                        month = monthCal.getTime().getMonth();
                        
                        //Get first Equipment in the list
                        if(equipmentsList.size() > 0){
                            equipmentWbo = (WebBusinessObject) equipmentsList.get(0);
                        } else {
                            request.setAttribute("equipment", equipmentWbo);
                        }
                        
                        request.setAttribute("period","currentMonth");
                    } else {
                        //Get Selected Month
                        month = new Integer(request.getParameter("month")).intValue();
                        
                        //Get Selected Equipment
                        equipmentWbo = equipmentsMgr.getOnSingleKey(request.getParameter("equipment"));
                        
                        request.setAttribute("period","other");
                    }
                    
                    //period calculations
                    year = monthCal.getTime().getYear();
                    minDate = monthCal.getActualMinimum(monthCal.DATE);
                    maxDate = monthCal.getActualMaximum(monthCal.DATE);
                    
                    java.sql.Date beginDate = new java.sql.Date(year,month,minDate);
                    java.sql.Date endDate = new java.sql.Date(year,month,maxDate);
                    
                    //Get Equipment Schedules
                    eqpSchedules = unitScheduleMgr.getEqpSchedulesDates(equipmentWbo.getAttribute("id").toString(), beginDate, endDate);
                    if(eqpSchedules.size() >0){
                        request.setAttribute("eqpSchedules", eqpSchedules);
                    } else {
                        request.setAttribute("eqpSchedules", eqpSchedules);
                    }
                    
                    //create month wbo
                    monthWbo.setAttribute("id", new Integer(month).toString());
                    monthWbo.setAttribute("name", monthsArray[month]);
                    
                    request.setAttribute("month", monthWbo);
                    request.setAttribute("equipmentsList", equipmentsList);
                    request.setAttribute("monthsList", futureMonths);
                    request.setAttribute("equipment",equipmentWbo);
                } catch (Exception ex){
                    System.out.println("Fleet Servlet -- get equipment schedule exception = "+ex.getMessage());
                }
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 6:
                servedPage = "/docs/plan_reports/mainCat_report_form.jsp";
                MainCategoryTypeMgr mainCatTypeMgr=MainCategoryTypeMgr.getInstance();
                ArrayList mainCatsList=new ArrayList();
                
                mainCatTypeMgr.cashData();
                mainCatsList=mainCatTypeMgr.getCashedTableAsArrayList();
                
                request.setAttribute("mainCatsList", mainCatsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 7:
                
                ScheduleMgr scheduleMgr=ScheduleMgr.getInstance();
                mainCatTypeMgr=MainCategoryTypeMgr.getInstance();
                
                ArrayList mainCatSchs=new ArrayList();
                servedPage = "/docs/plan_reports/mainCat_schs_report.jsp";
                String mainCatId=request.getParameter("mainCatId");
                WebBusinessObject mainCatWbo=mainCatTypeMgr.getOnSingleKey(mainCatId);
                
                
                mainCatSchs=scheduleMgr.getMainCatSchedules(mainCatId);
                
                request.setAttribute("mainCatWbo",mainCatWbo);
                request.setAttribute("mainCatSchs",mainCatSchs);
                request.setAttribute("page", servedPage);
                this.forward(servedPage,request, response);
                
                break;
                
            case 8:
                
                scheduleMgr=ScheduleMgr.getInstance();
                WebBusinessObject scheduleWbo=new WebBusinessObject();
                ConfigureMainTypeMgr configMainTypeMgr=ConfigureMainTypeMgr.getInstance();
                servedPage = "/docs/plan_reports/sch_tasks_parts_report.jsp";
                Vector schTasks=new Vector();
                Vector schParts=new Vector();
                ScheduleTasksMgr scheduleTasksMgr=ScheduleTasksMgr.getInstance();
                
                String schId=request.getParameter("schId");
                scheduleWbo=scheduleMgr.getOnSingleKey(schId);
                
                try {
                    
                    schParts=configMainTypeMgr.getOnArbitraryKey(schId,"key1");
                    schTasks=scheduleTasksMgr.getOnArbitraryKey(schId,"key1");
                    
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                
                
                request.setAttribute("scheduleWbo",scheduleWbo);
                request.setAttribute("schParts",schParts);
                request.setAttribute("schTasks",schTasks);
                request.setAttribute("page", servedPage);
                this.forward(servedPage,request, response);
                
                break;
                
            case 9:
                servedPage = "/docs/plan_reports/cat_report_form.jsp";
                MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
                ArrayList categoriesList=new ArrayList();
                Vector categoriesVec=new Vector();
                
                try {
                    
                    categoriesVec=maintainableMgr.getOnArbitraryDoubleKey("0","key3","0","key5");
                    
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                for(int i=0;i<categoriesVec.size();i++){
                    categoriesList.add(categoriesVec.get(i));
                }
                
                
                request.setAttribute("categoriesList", categoriesList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 10:
                
                scheduleMgr=ScheduleMgr.getInstance();
                mainCatTypeMgr=MainCategoryTypeMgr.getInstance();
                maintainableMgr=MaintainableMgr.getInstance();
                
                ArrayList cateogrySchsList=new ArrayList();
                Vector cateogrySchsVec=new Vector();
                servedPage = "/docs/plan_reports/category_schs_report.jsp";
                String catId=request.getParameter("catId");
                WebBusinessObject categoryWbo=maintainableMgr.getOnSingleKey(catId);

                try {
                    
                    cateogrySchsVec=scheduleMgr.getOnArbitraryKey(catId,"key4");
                    
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                for(int i=0;i<cateogrySchsVec.size();i++){
                    cateogrySchsList.add(cateogrySchsVec.get(i));
                }
                
                
                request.setAttribute("categoryWbo",categoryWbo);
                request.setAttribute("cateogrySchsList",cateogrySchsList);
                request.setAttribute("page", servedPage);
                this.forward(servedPage,request, response);
                
                break;
            case 11:
                servedPage = "/docs/reports/comments_report.jsp";
                ArrayList<WebBusinessObject> clients;
                CommentsMgr commentsMgr = CommentsMgr.getInstance();
                String fromDateS = request.getParameter("fromDate");
                String toDateS = request.getParameter("toDate");
                String reportType = request.getParameter("reportType");
                Calendar cal = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null && request.getParameter("createdBy") != null) {
                    
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    clients = commentsMgr.getEmployeeComments(request.getParameter("createdBy"), fromDateD, toDateD, reportType);
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }
                ArrayList<WebBusinessObject> usersList = userMgr.getUsersInMyReportDepartments((String) persistentUser.getAttribute("userId"));
                if(usersList.isEmpty()) {
                    usersList = new ArrayList<>(userMgr.getCashedTable());
                } else {
                    usersList.add(userMgr.getOnSingleKey((String) persistentUser.getAttribute("userId")));
                }
                request.setAttribute("usersList", usersList);
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("reportType", reportType);
                request.setAttribute("userID", (String) persistentUser.getAttribute("userId"));
                request.setAttribute("type", request.getParameter("type"));
                request.setAttribute("createdBy", request.getParameter("createdBy"));
                request.setAttribute("clients", clients);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                servedPage = "/docs/reports/closure_note_report.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null && request.getParameter("createdBy") != null
                        && request.getParameter("statusCode") != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    clients = IssueStatusMgr.getInstance().getStatusNotesByType(request.getParameter("createdBy"),
                            request.getParameter("statusCode"), request.getParameter("comment"), fromDateD, toDateD);
                } else {
                    clients = new ArrayList<WebBusinessObject>();
                }
                request.setAttribute("usersList", new ArrayList<WebBusinessObject>(userMgr.getCashedTable()));
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("createdBy", request.getParameter("createdBy"));
                request.setAttribute("statusCode", request.getParameter("statusCode"));
                request.setAttribute("comment", request.getParameter("comment"));
                request.setAttribute("clients", clients);
                this.forwardToServedPage(request, response);
                break;
                                
            case 13:
                servedPage = "/docs/reports/eng_employees_productions.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null && request.getParameter("requestType") != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    request.setAttribute("loads", ClientComplaintsMgr.getInstance().getEngEmployeeProduction(fromDateD, toDateD, request.getParameter("requestType")));
                }
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("requestType", request.getParameter("requestType"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 14:
                servedPage = "/docs/reports/new_client_ratio.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                List<WebBusinessObject> complaintsCounts = null;
                if (fromDateS != null && toDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    complaintsCounts = ClientComplaintsMgr.getInstance().getNewClientComplaintsStatusRatio(fromDateD, toDateD);
                }

                if (complaintsCounts != null && !complaintsCounts.isEmpty()) {
                    ArrayList dataList = new ArrayList();
                    int totalComplaintsCount = 0;
                    HashMap dataEntryMap;
                    // populate series data map
                    for (WebBusinessObject complaintWbo : complaintsCounts) {
                        dataEntryMap = new HashMap();
                        totalComplaintsCount += Integer.parseInt((String) complaintWbo.getAttribute("total"));
                        dataEntryMap.put("name", complaintWbo.getAttribute("statusNameAr"));
                        dataEntryMap.put("y", Integer.parseInt((String) complaintWbo.getAttribute("total")));

                        dataList.add(dataEntryMap);
                    }
                    // convert map to JSON string
                    String jsonText = JSONValue.toJSONString(dataList);

                    request.setAttribute("totalComplaintsCount", totalComplaintsCount);
                    request.setAttribute("complaintsCounts", complaintsCounts);
                    request.setAttribute("jsonText", jsonText);
                }
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 15:
                GroupMgr groupMgr = GroupMgr.getInstance();
                servedPage = "/docs/reports/closure_notes_productions.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null && request.getParameter("statusCode") != null
                        && request.getParameter("groupId") != null) {
                    List<WebBusinessObject> productions = new ArrayList<WebBusinessObject>();
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    try {
                        productions = IssueStatusMgr.getInstance().getClosureNotesProductions(request.getParameter("groupId"),
                                request.getParameter("statusCode"), fromDateD, toDateD);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("loads", productions);
                }
                try {
                    List groups = groupMgr.getCashedTable();
                    request.setAttribute("groups", groups);
                } catch (Exception e) {
                }
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("statusCode", request.getParameter("statusCode"));
                request.setAttribute("groupId", request.getParameter("groupId"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 16:
                groupMgr = GroupMgr.getInstance();
                servedPage = "/docs/reports/group_summary.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null && request.getParameter("groupId") != null) {
                    List<WebBusinessObject> summary = new ArrayList<WebBusinessObject>();
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    try {
                        summary = ClientMgr.getInstance().getGroupSummary(request.getParameter("groupId"), fromDateD, toDateD);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("summary", summary);
                }
                try {
                    UserGroupConfigMgr userGroupCongMgr = UserGroupConfigMgr.getInstance();
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
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("statusCode", request.getParameter("statusCode"));
                request.setAttribute("groupId", request.getParameter("groupId"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 17:
                servedPage = "/docs/requests/overall_performance.jsp";
                String beDate = request.getParameter("beginDate");
                String enDate = request.getParameter("endDate");
                String contractorID = request.getParameter("contractorID");
                String engineerID = request.getParameter("engineerID");
                String itemID = request.getParameter("itemID");
                String projectID = request.getParameter("projectID");
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
                DateParser dateParser = new DateParser();
                IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                if (beDate != null && enDate != null) {
                    try {
                        java.sql.Date beg = dateParser.formatSqlDate(beDate);
                        java.sql.Date en = dateParser.formatSqlDate(enDate);
                        java.sql.Date beginD = new java.sql.Date(beg.getTime());
                        java.sql.Date endD = new java.sql.Date(en.getTime());
                        ArrayList<WebBusinessObject> data = issueByComplaintMgr.getOverallPerformance(beginD, endD, CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY,
                                engineerID, contractorID, itemID, projectID);
                            Object jsonText;
                        HashMap<String, String> statusNames = new HashMap<>();
                        statusNames.put(CRMConstants.ISSUE_STATUS_ACCEPTED, "مقبول");
                        statusNames.put(CRMConstants.ISSUE_STATUS_REJECTED, "رفض مؤقت");
                        statusNames.put(CRMConstants.ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION, "مقبول بملاحظات");
                        statusNames.put(CRMConstants.ISSUE_STATUS_FINAL_REJECTION, "مرفوض نهائيا");
                        statusNames.put(CRMConstants.ISSUE_STATUS_NEW, "جديد");
                        ArrayList dataList = new ArrayList();
                        Map dataEntryMap;
                        String issueCountStr;
                        int totalIssuesCount = 0;
                        for (WebBusinessObject issueCountWbo : data) {
                            dataEntryMap = new HashMap();
                            issueCountStr = (String) issueCountWbo.getAttribute("totalNo");
                            totalIssuesCount += Integer.parseInt(issueCountStr);
                            dataEntryMap.put("name", statusNames.get((String) issueCountWbo.getAttribute("issueStatus")));
                            dataEntryMap.put("y", new Integer(issueCountStr));
                            issueCountWbo.setAttribute("statusName", statusNames.get((String) issueCountWbo.getAttribute("issueStatus")));
                            dataList.add(dataEntryMap);
                        }
                        jsonText = JSONValue.toJSONString(dataList);
                        request.setAttribute("totalIssuesCount", totalIssuesCount);
                        request.setAttribute("data", data);
                        request.setAttribute("jsonText", jsonText);
                        request.setAttribute("endDate", enDate);
                        request.setAttribute("beginDate", beDate);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }

                ProjectMgr projectMgr = ProjectMgr.getInstance();
                ClientMgr clientMgr = ClientMgr.getInstance();
                request.setAttribute("contractorsList", clientMgr.getListOfContractors());
                request.setAttribute("engineersList", userMgr.getAllEngineers());
                try {
                    request.setAttribute("itemsList", new ArrayList<>(projectMgr.getOnArbitraryKey("REQ-ITEM", "key4")));
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("itemsList", new ArrayList<WebBusinessObject>());
                }
                request.setAttribute("contractorID", contractorID);
                request.setAttribute("engineerID", engineerID);
                request.setAttribute("itemID", itemID);
                request.setAttribute("projectID", projectID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 18:
                groupMgr = GroupMgr.getInstance();
                servedPage = "/docs/reports/non_followers_clients_summary.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null && request.getParameter("groupId") != null) {
                    List<WebBusinessObject> summary = new ArrayList<>();
                    Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();
                    Map<String, WebBusinessObject> employeeResult = new HashMap<>();
                    dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    try {
                        if ("detail".equals(request.getParameter("reportType"))) {
                            List<WebBusinessObject> users = userMgr.getUsersByGroup(request.getParameter("groupId"));
                            for (WebBusinessObject userWbo : users) {
                                ArrayList<WebBusinessObject> issuesList = IssueByComplaintUniqueMgr.getInstance().getNonFollowersClientsDetails(request.getParameter("groupId"), fromDateD, toDateD, (String) userWbo.getAttribute("userId"));
                                employeeResult.put((String) userWbo.getAttribute("userId"), userWbo);
                                dataResult.put((String) userWbo.getAttribute("userId"), issuesList);
                            }
                        } else {
                            summary = ClientMgr.getInstance().getNonFollowersClientsSummary(request.getParameter("groupId"), fromDateD, toDateD);
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("employeeResult", employeeResult);
                    request.setAttribute("dataResult", dataResult);
                    request.setAttribute("summary", summary);
                }
                try {
                    UserGroupConfigMgr userGroupCongMgr = UserGroupConfigMgr.getInstance();
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
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("statusCode", request.getParameter("statusCode"));
                request.setAttribute("groupId", request.getParameter("groupId"));
                request.setAttribute("reportType", request.getParameter("reportType"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

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
        return "Equipment Servlet";
    }
    
    protected int getOpCode(String opName) {
        if(opName.indexOf("GetEqpDataForm") == 0)
            return 1;
        if (opName.equals("startPlanReport")) {
            return 2;
        }
        if(opName.indexOf("GetDetails") == 0)
            return 3;
        if(opName.indexOf("getFutureEqpData") == 0)
            return 4;
        if(opName.indexOf("getPastEqpData") == 0)
            return 5;
        if(opName.indexOf("getMainCatReportForm") == 0)
            return 6;
        if(opName.indexOf("listMainCatSchs") == 0)
            return 7;
        if(opName.indexOf("getScheduleData") == 0)
            return 8;
        if(opName.indexOf("getCatsReportForm") == 0)
            return 9;
        if(opName.indexOf("listCatSchs") == 0)
            return 10;
        if(opName.indexOf("listEmployeeComments") == 0)
            return 11;
        if(opName.indexOf("listClosureNotes") == 0)
            return 12;
        if(opName.indexOf("getEngEmployeeProductions") == 0)
            return 13;
        if(opName.indexOf("getNewClientRatio") == 0)
            return 14;
        if(opName.indexOf("getClosureNotesProductions") == 0)
            return 15;
        if(opName.indexOf("getGroupEmplyeeSummary") == 0)
            return 16;
        if(opName.indexOf("getOverallPerformance") == 0)
            return 17;
        if(opName.indexOf("getNonFollowersClientSummary") == 0)
            return 18;
        
        return 0;
    }
}
