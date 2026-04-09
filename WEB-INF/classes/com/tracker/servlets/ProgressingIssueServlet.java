/*
 * ProgressingIssueServlet.java
 *
 * Created on March 2, 2004, 6:00 AM
 */
package com.tracker.servlets;

import com.maintenance.common.DateParser;
import com.maintenance.db_access.ActualItemMgr;
import com.maintenance.db_access.ComplexIssueMgr;
import com.maintenance.db_access.EquipmentStatusMgr;
import com.maintenance.db_access.IssueEquipmentMgr;
import com.maintenance.db_access.ItemCatsMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.UnitScheduleMgr;

import com.silkworm.business_objects.WebBusinessObject;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.db_access.ExternalJobMgr;
import com.silkworm.jsptags.DropdownDate;

import com.tracker.business_objects.*;
import com.tracker.common.*;

import java.io.*;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;
import java.util.Calendar;

import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.util.*;
import org.apache.log4j.Logger;

/**
 *
 * @author  walid
 * @version
 */
public class ProgressingIssueServlet extends TrackerBaseServlet {
    
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    MaintainableMgr unitMgr = MaintainableMgr.getInstance();
    EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    String destination = null;
    WebBusinessObject wbo = null;
    String issueId = null;
    String workerNote = null;
    String actual_finish_time = null;
    String direction = null;
    DropdownDate dropdownDate = new DropdownDate();
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(ProgressingIssueServlet.class);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        HttpSession mySession = request.getSession();
        response.setContentType("text/html;charset=UTF-8");
        
        switch (operation) {
            /*
            case 1:
            issueId = request.getParameter("id");
            issueTitle = request.getParameter("issueTitle");
            issueState = request.getParameter("state");
            ais = IssueStatusFactory.getStateClass(issueState);
            viewOrigin = request.getParameter("viewOrigin");
            ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
            ais.setViewOrigin(viewOrigin);
            servedPage = "/docs/assigned_issue/start_working.jsp";
            request.setAttribute("state",ais);
            request.setAttribute("issueId", issueId);
            request.setAttribute("issueTitle", issueTitle);
            request.setAttribute("page",servedPage);
            this.forwardToServedPage(request, response);
            break;
            case 2:
            //
            viewOrigin = request.getParameter("viewOrigin");
            destination = AppConstants.getFullLink(viewOrigin);
            issueId = request.getParameter("issueId");
            workerNote = request.getParameter("workerNote");
            try {
            // issueMgr.saveObject(wIssue, s);
            wbo  = new WebBusinessObject();
            wbo.setAttribute("issueId", issueId);
            wbo.setAttribute("workerNote", workerNote);
            wbo.setAttribute(AppConstants.DIRECTION , AppConstants.FORWARD_DIRECTION);
            issueMgr.saveState(wbo, mySession);
            } catch(Exception ex) {
            logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
            }
            //servedPage = "/docs/issue/assign_issue.jsp";
            //request.setAttribute("page",servedPage);
            // this.forward("/Tracker/IssueServlet?op=ListUnassigned", request,response);
            this.forward(destination, request,response);
            // this.forwardToServedPage(request, response);
            break;
            case 3:
            issueId = request.getParameter("issueId");
            issueTitle = request.getParameter("issueTitle");
            direction = request.getParameter(AppConstants.DIRECTION);
            viewOrigin = request.getParameter("viewOrigin");
            ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
            ais.setViewOrigin(viewOrigin);
            servedPage = "/docs/issue/make_sure.jsp";
            request.setAttribute("state",ais);
            request.setAttribute("issueId", issueId);
            request.setAttribute("issueTitle", issueTitle);
            request.setAttribute(AppConstants.DIRECTION , direction);
            request.setAttribute("page",servedPage);
            this.forwardToServedPage(request, response);
            break;
             */
            case 4:
                
                String projectname = request.getParameter("projectName");
                issueId = request.getParameter("issueId");
                issueTitle = request.getParameter("issueTitle");
                issueState = request.getParameter("state");
                direction = request.getParameter(AppConstants.DIRECTION);
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                String destination = AppConstants.getFullLink(filterName, filterValue);
                
                //////////////////////////////////////////////////////////////////////////////////////
//                ais = IssueStatusFactory.getStateClass(issueState);
//                viewOrigin = request.getParameter("viewOrigin");
//                ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
//                ais.setViewOrigin(viewOrigin);
                ///////////////////////////////////////////////////////////////////////
                servedPage = "/docs/issue/Resolved_Issue_Note_Form.jsp";
                
                request.setAttribute("state", ais);
                request.setAttribute("issueId", issueId);
                request.setAttribute("issueTitle", issueTitle);
                request.setAttribute(AppConstants.DIRECTION, direction);
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                
                projectname = request.getParameter("projectName");
                issueId = request.getParameter("issueId");
                issueTitle = request.getParameter("issueTitle");
                issueState = request.getParameter("state");
                direction = request.getParameter(AppConstants.DIRECTION);
                WebIssue myWebIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                
                String issueTitle = (String) myWebIssue.getAttribute("issueTitle");
                String nextStatus = new String("");
                if (direction.equalsIgnoreCase(AppConstants.FORWARD_DIRECTION)) {
                    nextStatus = myWebIssue.getNextStateAction();
                } else {
                    if (direction.equalsIgnoreCase(AppConstants.BACKWARD_DIRECTION)) {
                        nextStatus = myWebIssue.getReverseStateAction();
                    }
                }
                request.setAttribute("nextStatus", nextStatus);
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                if (request.getParameter("case") != null) {
                    request.setAttribute("case", request.getParameter("case"));
                    request.setAttribute("title", request.getParameter("title"));
                    request.setAttribute("unitName", request.getParameter("unitName"));
                    
                }
                //  ais = IssueStatusFactory.getStateClass(issueState);
                // viewOrigin = request.getParameter("viewOrigin");
                //  ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
                //   ais.setViewOrigin(viewOrigin);
                
                servedPage = "/docs/issue/worker_note_form.jsp";
                
                //   request.setAttribute("state",ais);
                request.setAttribute("issueId", issueId);
                request.setAttribute("issueTitle", issueTitle);
                request.setAttribute(AppConstants.DIRECTION, direction);
                
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 6:
                
                projectname = request.getParameter("projectName");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                
                destination = AppConstants.getFullLink(filterName, filterValue);
                
                if (request.getParameter("case") != null) {
                    if (destination != null) {
                        destination = destination.replaceFirst("StatusProjectListAll", "StatusProjctListTitle");
                    } else {
                        destination = "/SearchServlet?op=StatusProjctListTitle&filterValue=" + filterValue;
                    }
                    
                    String addToURL = "&title=" + request.getParameter("title") + "&unitName=" + (String) request.getParameter("unitName");
                    destination += addToURL;
                    destination = destination.replace(' ', '+');
                }
                String searchType=filterValue.substring(filterValue.indexOf(">")+1,filterValue.indexOf("<"));
                if(searchType.equalsIgnoreCase("begin")||searchType.equalsIgnoreCase("end")) {
                    destination ="/SearchServlet?op=getByoneDate&filterValue="+filterValue;
                }
                // destination = AppConstants.getFullLink(filterName);
                workerNote = request.getParameter("workerNote");
                
                String causeDescription = request.getParameter("causeDescription");
                String actionTaken = request.getParameter("actionTaken");
                String preventionTaken = request.getParameter("preventionTaken");
                
                if (causeDescription == null) {
                    causeDescription = "UL";
                }
                if (actionTaken == null) {
                    actionTaken = "UL";
                }
                if (preventionTaken == null) {
                    preventionTaken = "UL";
                }
                
                actual_finish_time = request.getParameter("actual_finish_time");
                issueId = request.getParameter("issueId");
                direction = request.getParameter(AppConstants.DIRECTION);
                wbo = new WebBusinessObject();
                
                wbo.setAttribute("issueId", issueId);
                
                
                wbo.setAttribute("hour", request.getParameter("hour"));
                wbo.setAttribute("minute", request.getParameter("minute"));
                wbo.setAttribute("actualEndDate", request.getParameter("actualEndDate"));
                wbo.setAttribute("workerNote", workerNote);
                wbo.setAttribute("causeDescription", causeDescription);
                wbo.setAttribute("actionTaken", actionTaken);
                wbo.setAttribute("preventionTaken", preventionTaken);
                wbo.setAttribute("actualEndDate", request.getParameter("actualEndDate"));
                
                if (null != actual_finish_time) {
                    wbo.setAttribute("actual_finish_time", actual_finish_time);
                } else {
                    wbo.setAttribute("actual_finish_time", "0");
                }
                
                wbo.setAttribute(AppConstants.DIRECTION, direction);
                
                try {
                    //Save Issue Status
                    issueMgr.saveState(wbo, mySession);
                    
                    //Change Equipment Status
                    if (request.getParameter("changeState") != null) {
                        WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject wboUnitSchedule = unitScheduleMgr.getOnSingleKey((String) wboIssue.getAttribute("unitScheduleID"));
                        WebBusinessObject unitWbo = unitMgr.getOnSingleKey((String) wboUnitSchedule.getAttribute("unitId"));
                        
                        String equipmentID = (String) wboUnitSchedule.getAttribute("unitId");
                        String currentStatus = unitWbo.getAttribute("equipmentStatus").toString();
                        
                        if (currentStatus.equalsIgnoreCase("2")) {
                            //Build equipment status WebBusinessObject
                            WebBusinessObject wboStatus = new WebBusinessObject();
                            
                            wboStatus.setAttribute("equipmentID", equipmentID);
                            wboStatus.setAttribute("stateID", new String("1"));
                            wboStatus.setAttribute("note", "On Line");
                            wboStatus.setAttribute("beginDate", request.getParameter("actualEndDate"));
                            wboStatus.setAttribute("hour", request.getParameter("hour"));
                            wboStatus.setAttribute("minute", request.getParameter("minute"));
                            
                            equipmentStatusMgr.saveObject(wboStatus, request.getSession());
                        }
                    }
                    // this.forward(destination, request,response);
                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }
                
//                ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
//                String[] quantity = request.getParameterValues("qun");
//                String[] price = request.getParameterValues("price");
//                String[] cost = request.getParameterValues("cost");
//                String[] itemID = request.getParameterValues("code");
//                String[] note = request.getParameterValues("note");
//                WebBusinessObject issue = issueMgr.getOnSingleKey(issueId);
//                String scheduleUnitID = issue.getAttribute("unitScheduleID").toString();
//                float total = 0f;
//                if (request.getParameter("totale") != null) {
//                    total = new Float(request.getParameter("totale")).floatValue();
//                }
//                if (quantity != null) {
//                    for (int i = 0; i < quantity.length; i++) {
//                        Hashtable hash;
//                        if (!quantity[i].equals("") && !quantity[i].equals("0")) {
//                            hash = new Hashtable();
//                            hash.put("scheduleUnitID", scheduleUnitID);
//                            hash.put("itemID", itemID[i]);
//                            hash.put("itemQuantity", quantity[i]);
//                            hash.put("itemPrice", price[i]);
//                            hash.put("totalCost", cost[i]);
//                            hash.put("note", note[i]);
//
////                        scheduleItem = new Vector();
////                        scheduleItem = (Vector) scheduleItemsVec.elementAt(i);
//                            try {
//                                actualItemMgr.saveObject(hash, request.getSession());
//
////                        } catch (SQLException sqlEx) {
//                            } catch (Exception ex) {
//                                logger.error("General Exception:" + ex.getMessage());
//                            }
//                        }
//                        try {
//                            Thread.sleep(200);
//                        } catch (InterruptedException ex) {
//                            logger.error(ex.getMessage());
//                        }
//                    }
//
//                    issueMgr.updateActualCost(issueId, total);
//                }
                
                request.setAttribute("projectName", projectname);
                //servedPage = "/docs/issue/assign_issue.jsp";
                //request.setAttribute("page",servedPage);
                this.forward(destination, request, response);
                // this.forwardToServedPage(request, response);
                break;
                
            case 7:
                
                try {
                    
                    projectname = request.getParameter("projectName");
                    
                    issueId = request.getParameter("issueId");
                    issueTitle = request.getParameter("issueTitle");
                    issueState = request.getParameter("state");
                    direction = request.getParameter(AppConstants.DIRECTION);
                    
                    WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
                    String periodicScheduleId = wboIssue.getAttribute("unitScheduleID").toString();
                    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                    WebBusinessObject wboUnitSchedule = unitScheduleMgr.getOnSingleKey(periodicScheduleId);
                    String machineId = wboUnitSchedule.getAttribute("unitId").toString();
                    QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                    Vector quantifiedItems = quantifiedMntenceMgr.getOnArbitraryKey(periodicScheduleId, "key1");
                    
                    Vector items = new Vector();
                    String isDirect="";
                    if (quantifiedItems != null) {
                        for (int i = 0; i < quantifiedItems.size(); i++) {
                            WebBusinessObject wboTemp = (WebBusinessObject) quantifiedItems.elementAt(i);
                            isDirect=(String)wboTemp.getAttribute("isDirectPrch");
                            if(isDirect.equals("0")){
                                items.add(wboTemp.getAttribute("itemId").toString());
                            } else{
                                quantifiedItems.remove(i);
                                i--;
                            }
                        }
                    }
                    if (request.getParameter("case") != null) {
                        request.setAttribute("case", request.getParameter("case"));
                        request.setAttribute("title", request.getParameter("title"));
                        request.setAttribute("unitName", request.getParameter("unitName"));
                        
                    }
                    filterName = request.getParameter("filterName");
                    filterValue = request.getParameter("filterValue");
                    
                    
                    
                    
                    servedPage = "/docs/issue/QA_verify_form.jsp";
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("issueTitle", issueTitle);
                    request.setAttribute(AppConstants.DIRECTION, direction);
                    
                    request.setAttribute("items", items);
                    request.setAttribute("quantifiedItems", quantifiedItems);
                    request.setAttribute("filterName", filterName);
                    request.setAttribute("filterValue", filterValue);
                    //request.setAttribute("projectName", projectname);
                    request.setAttribute("scheduleID", periodicScheduleId);
                    
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } catch (SQLException sex) {
                    logger.error("SQL Exception " + sex.getMessage());
                } catch (Exception e) {
                    logger.error("General Exception " + e.getMessage());
                }
                
                break;
                
            case 8:
                
                projectname = request.getParameter("projectName");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                destination = AppConstants.getFullLink(filterName, filterValue);
                // destination = AppConstants.getFullLink(filterName);
                workerNote = request.getParameter("workerNote");
                actual_finish_time = request.getParameter("actual_finish_time");
                issueId = request.getParameter("issueId");
                direction = request.getParameter(AppConstants.DIRECTION);
                wbo = new WebBusinessObject();
                
                wbo.setAttribute("issueId", issueId);
                
                //wbo.setAttribute("workerNote", workerNote);
//                if(null!=actual_finish_time)
//                    wbo.setAttribute("actual_finish_time", actual_finish_time);
//                else
//                    wbo.setAttribute("actual_finish_time","0");
//
//                wbo.setAttribute(AppConstants.DIRECTION, direction);
//
                try {
                    //AssignedIssueState assIssueMgr;
                    
                    
                    issueMgr.saveState(wbo, mySession);
                    // this.forward(destination, request,response);
                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }
                
                ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
                ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
                String[] quantity = request.getParameterValues("qun");
                String[] price = request.getParameterValues("price");
                String[] cost = request.getParameterValues("cost");
                String[] itemID = request.getParameterValues("code");
                String[] note = request.getParameterValues("note");
                WebBusinessObject issue = issueMgr.getOnSingleKey(issueId);
                String scheduleUnitID = issue.getAttribute("unitScheduleID").toString();
                float total = 0f;
                if (request.getParameter("totale") != null) {
                    total = new Float(request.getParameter("totale")).floatValue();
                }
                
                if (quantity != null) {
                    for (int i = 0; i < quantity.length; i++) {
                        Hashtable hash;
                        if (!quantity[i].equals("")) {
                            hash = new Hashtable();
                            hash.put("scheduleUnitID", scheduleUnitID);
                            hash.put("itemID", itemID[i]);
                            hash.put("itemQuantity", quantity[i]);
                            hash.put("itemPrice", price[i]);
                            hash.put("totalCost", new String(new Float(new Float(quantity[i]).floatValue() * new Float(price[i]).floatValue()).toString()));
                            hash.put("note", note[i]);
                            total = total + new Float(quantity[i]).floatValue() * new Float(price[i]).floatValue();
//                        scheduleItem = new Vector();
//                        scheduleItem = (Vector) scheduleItemsVec.elementAt(i);
                            try {
                                itemCatsMgr.saveObject(hash, request.getSession());
//                        } catch (SQLException sqlEx) {
                            } catch (Exception ex) {
                                logger.error("General Exception:" + ex.getMessage());
                            }
                        }
                    }
                    issueMgr.updateActualCost(issueId, total);
                }
                request.setAttribute("Status", "OK");
//                request.setAttribute("projectName", projectname);
                servedPage = "/docs/issue/QA_verify_All_Item_Main.jsp";
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 9:
                
                projectname = request.getParameter("projectName");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                issueId = request.getParameter("issueId");
                
                if(!filterValue.equalsIgnoreCase("null")){
                    searchType=filterValue.substring(filterValue.indexOf(">")+1,filterValue.indexOf("<"));
                    if(searchType.equalsIgnoreCase("begin")||searchType.equalsIgnoreCase("end")) {
                        destination ="/SearchServlet?op=getByoneDate&filterValue="+filterValue;
                    }else {
                        destination = AppConstants.getFullLink(filterName, filterValue);
                    }
                }else{
                    destination="/AssignedIssueServlet?op=VIEWDETAILS&issueId="+issueId+"&filterName=null&filterValue=null";
                }
                
                if (request.getParameter("case") != null) {
                    if (destination != null) {
                        destination = destination.replaceFirst("StatusProjectListAll", "StatusProjctListTitle");
                    } else {
                        destination = "/SearchServlet?op=StatusProjctListTitle&filterValue=" + filterValue;
                    }
                    
                    String addToURL = "&title=" + request.getParameter("title") + "&unitName=" + (String) request.getParameter("unitName");
                    destination += addToURL;
                    destination = destination.replace(' ', '+');
                }
                // destination = AppConstants.getFullLink(filterName);
                workerNote = request.getParameter("workerNote");
                
                causeDescription = request.getParameter("causeDescription");
                actionTaken = request.getParameter("actionTaken");
                preventionTaken = request.getParameter("preventionTaken");
                
                if (causeDescription == null) {
                    causeDescription = "UL";
                }
                if (actionTaken == null) {
                    actionTaken = "UL";
                }
                if (preventionTaken == null) {
                    preventionTaken = "UL";
                }
                
                actual_finish_time = request.getParameter("actual_finish_time");
                direction = request.getParameter(AppConstants.DIRECTION);
                wbo = new WebBusinessObject();
                
                wbo.setAttribute("issueId", issueId);
                
                wbo.setAttribute("workerNote", workerNote);
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
                    
                    
                    issueMgr.saveOrderState(wbo, mySession);
                    // this.forward(destination, request,response);
                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }
                
                request.setAttribute("projectName", projectname);
                //servedPage = "/docs/issue/assign_issue.jsp";
                //request.setAttribute("page",servedPage);
                this.forward(destination, request, response);
                // this.forwardToServedPage(request, response);
                break;
                
                
            case 10:
                
                try {
                    
                    projectname = request.getParameter("projectName");
                    
                    issueId = request.getParameter("issueId");
                    WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
                    String actualBeginDate = issueMgr.getActualBeginDate(issueId);
                    
                   // request.getSession().setAttribute("date", actualBeginDate);
                    issueTitle =(String) wboIssue.getAttribute("issueTitle");
                    issueState = (String) wboIssue.getAttribute("currentStatus");
                    direction = request.getParameter(AppConstants.DIRECTION);
                    
                    // WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
                    String periodicScheduleId = wboIssue.getAttribute("unitScheduleID").toString();
                    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                    WebBusinessObject wboUnitSchedule = unitScheduleMgr.getOnSingleKey(periodicScheduleId);
                    String machineId = wboUnitSchedule.getAttribute("unitId").toString();
                    QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                    Vector quantifiedItems = quantifiedMntenceMgr.getOnArbitraryKey(periodicScheduleId, "key1");
                    
                    Vector items = new Vector();
                    String isDirect="";
                    if (quantifiedItems != null) {
                        for (int i = 0; i < quantifiedItems.size(); i++) {
                            WebBusinessObject wboTemp = (WebBusinessObject) quantifiedItems.elementAt(i);
                            isDirect=(String)wboTemp.getAttribute("isDirectPrch");
                            if(isDirect.equals("0")){
                                items.add(wboTemp.getAttribute("itemId").toString());
                            } else{
                                quantifiedItems.remove(i);
                                i--;
                            }
                        }
                    }
                    if (request.getParameter("case") != null) {
                        request.setAttribute("case", request.getParameter("case"));
                        request.setAttribute("title", request.getParameter("title"));
                        request.setAttribute("unitName", request.getParameter("unitName"));
                        
                    }
                    filterName = request.getParameter("filterName");
                    filterValue = request.getParameter("filterValue");
                    
                    String Type="";
                    ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
                    WebBusinessObject externalWbo = externalJobMgr.getOnSingleKey("key2", issueId);
                    if(externalWbo != null)
                    {
                       
                        Type=(String)externalWbo.getAttribute("externalType");
                         request.setAttribute("externalType", Type);
                    }
                    
                    
                    servedPage = "/docs/issue/internalQA_verify_form.jsp";
                    
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("actualBeginDate", actualBeginDate);
                    request.setAttribute("issueTitle", issueTitle);
                    request.setAttribute(AppConstants.DIRECTION, direction);
                    
                    request.setAttribute("items", items);
                    request.setAttribute("quantifiedItems", quantifiedItems);
                    request.setAttribute("filterName", filterName);
                    request.setAttribute("filterValue", filterValue);
                    //request.setAttribute("projectName", projectname);
                    request.setAttribute("scheduleID", periodicScheduleId);
                    
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } catch (SQLException sex) {
                    logger.error("SQL Exception " + sex.getMessage());
                } catch (Exception e) {
                    logger.error("General Exception " + e.getMessage());
                }
                
                break;
            case 11:
                dateAndTime = new DateAndTimeControl();
                int minutes=0;
                projectname = request.getParameter("projectName");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");

                String day = (String)request.getParameter("day");
                String hour = (String)request.getParameter("hours");
                String minute = (String)request.getParameter("minutes");

                if(day != null && !day.equals("")){
                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
                }
                if(hour != null && !hour.equals("")) {
                    minutes = minutes + dateAndTime.getMinuteOfHour(hour);
                }
                if(minute != null && !minute.equals("")) {
                     minutes = minutes + new Integer(minute).intValue();
                }
//                destination = AppConstants.getFullLink(filterName, filterValue);
//
//                if (request.getParameter("case") != null) {
//                    if (destination != null) {
//                        destination = destination.replaceFirst("StatusProjectListAll", "StatusProjctListTitle");
//                    } else {
//                        destination = "/SearchServlet?op=StatusProjctListTitle&filterValue=" + filterValue;
//                    }
//
//                    String addToURL = "&title=" + request.getParameter("title") + "&unitName=" + (String) request.getParameter("unitName");
//                    destination += addToURL;
//                    destination = destination.replace(' ', '+');
//                }
                
                
                // walid
                HttpSession thisSession = request.getSession();
                String currentJobOrder = (String) thisSession.getAttribute("CurrentJobOrder");
                
                if(null!=currentJobOrder)
                    destination = "/AssignedIssueServlet?op=VIEWDETAILS&issueId="+currentJobOrder+"&filterValue=null&filterName=null&mainTitle=Emergency&backTo=all";
                else
                    destination = "/main.jsp";
                
                // walid
                // destination = AppConstants.getFullLink(filterName);
                workerNote = request.getParameter("workerNote");
                
                causeDescription = request.getParameter("causeDescription");
                actionTaken = request.getParameter("actionTaken");
                preventionTaken = request.getParameter("preventionTaken");
                
                if (causeDescription == null) {
                    causeDescription = "UL";
                }
                if (actionTaken == null) {
                    actionTaken = "UL";
                }
                if (preventionTaken == null) {
                    preventionTaken = "UL";
                }
                
                actual_finish_time = request.getParameter("actual_finish_time");
                issueId = request.getParameter("issueId");
                direction = "forward";
                wbo = new WebBusinessObject();
                
                wbo.setAttribute("issueId", issueId);
                
                wbo.setAttribute("hour", request.getParameter("hour"));
                wbo.setAttribute("minute", request.getParameter("minute"));
                wbo.setAttribute("actualEndDate", request.getParameter("actualEndDate"));
                wbo.setAttribute("workerNote", workerNote);
                wbo.setAttribute("causeDescription", causeDescription);
                wbo.setAttribute("actionTaken", actionTaken);
                wbo.setAttribute("preventionTaken", preventionTaken);
                wbo.setAttribute("actualEndDate", request.getParameter("actualEndDate"));
                
//                if (null != actual_finish_time) {
//                    wbo.setAttribute("actual_finish_time", actual_finish_time);
//                } else {
//                    wbo.setAttribute("actual_finish_time", "0");
//                }
                wbo.setAttribute("actual_finish_time", minutes);
                wbo.setAttribute(AppConstants.DIRECTION, direction);
                
                try {
                    //AssignedIssueState assIssueMgr;
                    
                    
                    issueMgr.saveState(wbo, mySession);
                    if (request.getParameter("changeState") != null) {
                        WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
                        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                        WebBusinessObject wboUnitSchedule = unitScheduleMgr.getOnSingleKey((String) wboIssue.getAttribute("unitScheduleID"));
                        String equipmentID = (String) wboUnitSchedule.getAttribute("unitId");
                        EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                        WebBusinessObject wboState = equipmentStatusMgr.getLastStatus(equipmentID);
                        int currentStatus = 2;
                        if (wboState != null) {
                            String stateID = (String) wboState.getAttribute("stateID");
                            currentStatus = new Integer(stateID).intValue();
                        }
                        if (currentStatus == 2) {
                            Calendar c = Calendar.getInstance();
                            WebBusinessObject wboStatus = new WebBusinessObject();
                            wboStatus.setAttribute("equipmentID", equipmentID);
                            wboStatus.setAttribute("stateID", new String("1"));
                            wboStatus.setAttribute("note", "On Line");
                            
                            wboStatus.setAttribute("beginDate", request.getParameter("actualEndDate"));
                            wboStatus.setAttribute("hour", request.getParameter("hour"));
                            wboStatus.setAttribute("minute", request.getParameter("minute"));
                            
//                            wboStatus.setAttribute("beginDate", (c.get(Calendar.MONTH) + 1) + "/" + c.get(Calendar.DAY_OF_MONTH) + "/" + c.get(Calendar.YEAR));
//                            wboStatus.setAttribute("hour", new Integer(c.get(Calendar.HOUR_OF_DAY)).toString());
//                            wboStatus.setAttribute("minute", request.getParameter("minute"));
                            equipmentStatusMgr.saveObject(wboStatus, request.getSession());
                        }
                    }
                    // this.forward(destination, request,response);
                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }
                
                actualItemMgr = ActualItemMgr.getInstance();
//                quantity = request.getParameterValues("qun");
//                price = request.getParameterValues("price");
//                cost = request.getParameterValues("cost");
//                itemID = request.getParameterValues("code");
//                note = request.getParameterValues("note");
//                issue = issueMgr.getOnSingleKey(issueId);
//                scheduleUnitID = issue.getAttribute("unitScheduleID").toString();
//                total = 0f;
//                if (request.getParameter("totale") != null) {
//                    total = new Float(request.getParameter("totale")).floatValue();
//                }
//                if (quantity != null) {
//                    for (int i = 0; i < quantity.length; i++) {
//                        Hashtable hash;
//                        if (!quantity[i].equals("") && !quantity[i].equals("0")) {
//                            hash = new Hashtable();
//                            hash.put("scheduleUnitID", scheduleUnitID);
//                            hash.put("itemID", itemID[i]);
//                            hash.put("itemQuantity", quantity[i]);
//                            hash.put("itemPrice", price[i]);
//                            hash.put("totalCost", cost[i]);
//                            hash.put("note", note[i]);
//
////                        scheduleItem = new Vector();
////                        scheduleItem = (Vector) scheduleItemsVec.elementAt(i);
//                            try {
//                                actualItemMgr.saveObject(hash, request.getSession());
//
////                        } catch (SQLException sqlEx) {
//                            } catch (Exception ex) {
//                                logger.error("General Exception:" + ex.getMessage());
//                            }
//                        }
//                        try {
//                            Thread.sleep(200);
//                        } catch (InterruptedException ex) {
//                            logger.error(ex.getMessage());
//                        }
//                    }
//
//                    issueMgr.updateActualCost(issueId, total);
//                }
//
                request.setAttribute("projectName", projectname);
                //servedPage = "/docs/issue/assign_issue.jsp";
                //request.setAttribute("page",servedPage);
                this.forward(destination, request, response);
                // this.forwardToServedPage(request, response);
                break;
                
            case 12:
                
                projectname = request.getParameter("projectName");
                issueId = request.getParameter("issueId");
                myWebIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                issueTitle = (String) myWebIssue.getAttribute("issueTitle");
                issueState = (String) myWebIssue.getAttribute("currentStatus");
                direction = request.getParameter("direction");
                if(direction != null && !direction.equals("") && !direction.equals("forward")){
                    direction = "backward";
                }else if(direction != null && !direction.equals("") && direction.equals("forward")){
                    direction = "forward";
                }else{
                    direction = "backward";
                }
                
                myWebIssue = (WebIssue) issueMgr.getOnSingleKey(issueId);
                
                issueTitle = (String) myWebIssue.getAttribute("issueTitle");
                nextStatus = new String("");
                if (direction.equalsIgnoreCase(AppConstants.FORWARD_DIRECTION)) {
                    nextStatus = myWebIssue.getNextStateAction();
                } else {
                    if (direction.equalsIgnoreCase(AppConstants.BACKWARD_DIRECTION)) {
                        nextStatus = myWebIssue.getReverseStateAction();
                    }
                }
                request.setAttribute("nextStatus", nextStatus);
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                if (request.getParameter("case") != null) {
                    request.setAttribute("case", request.getParameter("case"));
                    request.setAttribute("title", request.getParameter("title"));
                    request.setAttribute("unitName", request.getParameter("unitName"));
                    
                }
                //  ais = IssueStatusFactory.getStateClass(issueState);
                // viewOrigin = request.getParameter("viewOrigin");
                //  ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
                //   ais.setViewOrigin(viewOrigin);
                
                servedPage = "/docs/issue/internal_worker_note_form.jsp";
                
                //   request.setAttribute("state",ais);
                request.setAttribute("issueId", issueId);
                request.setAttribute("issueTitle", issueTitle);
                request.setAttribute(AppConstants.DIRECTION, direction);
                
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("projectName", projectname);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 13:
                issueId = request.getParameter("issueId");
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                
                request.setAttribute("issueId", issueId);
                request.setAttribute("filterName", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("page", "/docs/Adminstration/waiting_business_roll.jsp");
                forwardToServedPage(request, response);
                break;
                
            case 14:
                
                String eqID=(String)request.getParameter("eqpId");
                String scheduleId=(String)request.getParameter("scheduleId");
                
                causeDescription = request.getParameter("causeDescription");
                actionTaken = request.getParameter("actionTaken");
                preventionTaken = request.getParameter("preventionTaken");
                
                if (causeDescription == null) {
                    causeDescription = "UL";
                }
                if (actionTaken == null) {
                    actionTaken = "UL";
                }
                if (preventionTaken == null) {
                    preventionTaken = "UL";
                }
                
                actual_finish_time = request.getParameter("actual_finish_time");
                issueId = request.getParameter("issueId");
                direction = "forward";
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
                    issueMgr.cancelJopOrder(wbo, mySession);
                    
                } catch (Exception ex) {
                    logger.error("Saving Assigned Issue Exception: " + ex.getMessage());
                }
                
                /*****************Get Plan Issues*********************/
                /****************Get Unit Schedules********************/
                WebBusinessObject composeWbo=new WebBusinessObject();
                WebBusinessObject equipWbo=new WebBusinessObject();
                MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
                unitScheduleMgr=UnitScheduleMgr.getInstance();
                
                equipWbo=maintainableMgr.getOnSingleKey(eqID);
                
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
                Vector issueList=new Vector();
                WebBusinessObject unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(composeWbo.getAttribute("id").toString());
                
                String unit_Name = equipWbo.getAttribute("unitName").toString();
                String title = unitScheduleWbo.getAttribute("maintenanceTitle").toString();
                
                IssueEquipmentMgr issueEquipmentMgr = IssueEquipmentMgr.getInstance();
                
//                filterValue = new Long(dropdownDate.getDate(composeWbo.getAttribute("beginDate").toString()).getTime()).toString() + ":" + new Long(dropdownDate.getDate(composeWbo.getAttribute("endDate").toString()).getTime()).toString() + ">" + eqID + "<ALL";
                
                WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
                String jsDateFormat=loggedUser.getAttribute("jsDateFormat").toString();
                DateParser dateParser=new DateParser();
                
                filterValue = new Long(dateParser.getSqlTimeStampDate(composeWbo.getAttribute("beginDate").toString(),jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(composeWbo.getAttribute("endDate").toString(),jsDateFormat).getTime()).toString() + ">" + eqID + "<ALL";
                
                servedPage = "/docs/issue/schedule_issue_report.jsp";
                issueEquipmentMgr.setUser((WebBusinessObject) request.getSession().getAttribute("loggedUser"));
                
                try {
                    issueList = issueEquipmentMgr.getIssuesInRangeByTitle("ListEqpByTitle", filterValue, title);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                ComplexIssueMgr complexIssueMgr=ComplexIssueMgr.getInstance();
                Vector checkIsCmplx=new Vector();
                WebBusinessObject eqpWbo=new WebBusinessObject();
                for(int i=0;i<issueList.size();i++){
                    WebBusinessObject issueWbo= (WebBusinessObject)issueList.get(i);
                    WebIssue webIssue = (WebIssue) issueWbo;
                    if(!webIssue.getAttribute("issueTitle").toString().equalsIgnoreCase(title)) {
                        issueList.remove(i);
                    }
                    try{
                        checkIsCmplx=complexIssueMgr.getOnArbitraryKey(issueWbo.getAttribute("id").toString(),"key1");
                        if(checkIsCmplx.size()>0){
                            issueWbo.setAttribute("issueType","cmplx");
                        }else{
                            issueWbo.setAttribute("issueType","normal");
                        }
                        eqpWbo=maintainableMgr.getOnSingleKey(issueWbo.getAttribute("unitId").toString());
                        issueWbo.setAttribute("unitName",eqpWbo.getAttribute("unitName").toString());
                    }catch (Exception e){
                        
                    }
                }
                
                
                request.setAttribute("filterName", "All");
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("data", issueList);
                request.setAttribute("beginDate", composeWbo.getAttribute("beginDate").toString());
                request.setAttribute("endDate", composeWbo.getAttribute("endDate").toString());
                request.setAttribute("page", servedPage);
                request.setAttribute("status", "ALL");
                request.setAttribute("UnitName", unit_Name);
                request.setAttribute("Title", title);
                request.setAttribute("eqWbo", equipWbo);
                request.setAttribute("scheduleId", scheduleId);
                this.forwardToServedPage(request, response);
                break;
                
                /******************End******************/
                /********************End*****************/
            default:
        }
        
        
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Progressing Issue Servlet";
    }
    
    protected int getOpCode(String opName) {
        /*
        if(opName.equals("startwork"))
        return 1;
        if(opName.equals("commit"))
        return 2;
        if(opName.equals("removeIssue"))
        return 3;
         */
        if (opName.equals("GetProgrammerNoteForm")) {
            return 4;
        }
        
        if (opName.equalsIgnoreCase("GetWorkerNoteForm")) {
            return 5;
        }
        
        if (opName.equalsIgnoreCase("SaveStatus")) {
            return 6;
        }
        
        if (opName.equalsIgnoreCase("GetQAVerifyForm")) {
            return 7;
        }
        if (opName.equals("SaveStatusEmg")) {
            return 8;
        }
        
        if (opName.equalsIgnoreCase("ChangeStatus")) {
            return 9;
        }
        
        if (opName.equals("internalGetQAVerifyForm")) {
            return 10;
        }
        
        if (opName.equals("SaveinternalGetQAVerifyForm")) {
            return 11;
        }
        
        if (opName.equals("internalGetWorkerNoteForm")) {
            return 12;
        }
        
        if (opName.equals("BusinessRoll")) {
            return 13;
        }
        
        if (opName.equals("cancelIssue")) {
            return 14;
        }
        
        return 0;
    }
    
    
}
