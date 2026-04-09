package com.maintenance.servlets;

import com.maintenance.common.Tools;
import com.maintenance.db_access.ItemBalanceMgr;
import com.maintenance.db_access.ItemFormMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.QuantifiedItemsMgr;
import com.maintenance.db_access.ReconfigTaskMgr;
import com.maintenance.db_access.ScheduleByJobOrderMgr;
import com.maintenance.db_access.StoresErpMgr;
import com.maintenance.db_access.TasksByIssueMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UnitScheduleHistoryMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;

public class PopupServlet extends TrackerBaseServlet {
    
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
        super.processRequest(request,response);
        HttpSession session = request.getSession();
        ScheduleByJobOrderMgr scheduleByJobOrderMgr = ScheduleByJobOrderMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
        QuantifiedItemsMgr quantifiedItemsMgr = QuantifiedItemsMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        TradeMgr tradeMgr = TradeMgr.getInstance();
        UnitScheduleHistoryMgr unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
        ItemBalanceMgr itemBalanceMgr = ItemBalanceMgr.getInstance();
        ItemsMgr itemsMgr = ItemsMgr.getInstance();
        ItemFormMgr itemFormMgr = ItemFormMgr.getInstance();
        StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
        ReconfigTaskMgr reconfigTaskMgr = ReconfigTaskMgr.getInstance();

        Vector<WebBusinessObject> tasks, items, tasksByDistParts;

        Hashtable<String, String> quatities;

        WebBusinessObject wboIssue, wboTrade, wboProject;
        String unitId, scheduleId, unitScheduleHistoryId, issueId, unitSchedule, scheduleTitle, projectId, tradeId;
        String itemCode, itemForm, storeCode, itemName, itemFormName, storeName, balance, quantity;
        
        switch(operation) {
            case 1:
                servedPage = "/docs/popup/issue_details.jsp";
                unitId = request.getParameter("unitId");
                unitScheduleHistoryId = request.getParameter("unitScheduleHistoryId");
                scheduleTitle = request.getParameter("scheduleTitle");

                scheduleId = unitScheduleHistoryMgr.getPeriodicId(unitScheduleHistoryId);
                WebBusinessObject wboIssueDetails = scheduleByJobOrderMgr.getLastIssueByScheduleKM(scheduleId, unitId);

                if(wboIssueDetails != null) {
                    issueId = (String) wboIssueDetails.getAttribute("issueId");
                    unitSchedule = (String) wboIssueDetails.getAttribute("unitSchId");
                    
                    wboIssue = issueMgr.getOnSingleKey(issueId);
                    
                    projectId = (String) wboIssue.getAttribute("projectName");
                    tradeId = (String) wboIssue.getAttribute("workTrade");

                    wboProject = projectMgr.getOnSingleKey(projectId);
                    wboTrade = tradeMgr.getOnSingleKey(tradeId);

                    tasks = new Vector();
                    items = new Vector();

                    try {
                        tasks = tasksByIssueMgr.getOnArbitraryKey(issueId, "key");
                    } catch(Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    try {
                        items = quantifiedItemsMgr.getOnArbitraryKey(unitSchedule, "key1");
                    } catch(Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    wboIssueDetails.setAttribute("issue", wboIssue);
                    wboIssueDetails.setAttribute("tasks", tasks);
                    wboIssueDetails.setAttribute("items", items);
                    wboIssueDetails.setAttribute("tradeName", wboTrade.getAttribute("tradeName"));
                    wboIssueDetails.setAttribute("projectName", wboProject.getAttribute("projectName"));

                    request.setAttribute("issueDetails", wboIssueDetails);
                }
                request.setAttribute("scheduleTitle", Tools.getRealChar(scheduleTitle));
                this.forward(servedPage, request, response);
                break;

            case 2:
                servedPage = "/docs/popup/item_balance.jsp";
                itemCode = request.getParameter("itemCode");
                itemForm = request.getParameter("itemForm");
                storeCode = request.getParameter("storeCode");

                balance = itemBalanceMgr.getBalance(itemCode, itemForm, storeCode);

                itemName = itemsMgr.getItemName(itemForm + "-" +itemCode);
                itemFormName = itemFormMgr.getItemFormName(itemForm);
                storeName = storesErpMgr.getStoreName(storeCode);

                request.setAttribute("itemCode", itemCode);
                request.setAttribute("itemName", itemName);
                request.setAttribute("itemForm", itemForm);
                request.setAttribute("itemFormName", itemFormName);
                request.setAttribute("storeCode", storeCode);
                request.setAttribute("storeName", storeName);
                request.setAttribute("balance", balance);
                this.forward(servedPage, request, response);
                break;

            case 3:
                issueId = request.getParameter("issueId");
                itemCode = request.getParameter("itemCode");
                quantity = request.getParameter("quantity");

                tasks = new Vector<WebBusinessObject>();
                tasksByDistParts = new Vector<WebBusinessObject>();
                try {
                    tasks = tasksByIssueMgr.getOnArbitraryKey(issueId, "key");
                } catch(Exception ex) { logger.error(ex.getMessage()); }

                try {
                    tasksByDistParts = reconfigTaskMgr.getOnArbitraryDoubleKey(issueId, "key1", itemCode, "key3");
                } catch(Exception ex) { logger.error(ex.getMessage()); }

                quatities = Tools.toHashtable(tasksByDistParts, "taskId", "itemQuantity");
                
                servedPage = "/docs/popup/distribution_parts.jsp";
                request.setAttribute("issueId", issueId);
                request.setAttribute("itemCode", itemCode);
                request.setAttribute("tasks", tasks);
                request.setAttribute("quantity", quantity);
                request.setAttribute("quatities", quatities);
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
        return "Search Servlet";
    }
    
    @Override
    protected int getOpCode(String opName) {
        if(opName.indexOf("viewIssueDetails") == 0)
            return 1;
        if(opName.indexOf("getBalance") == 0)
            return 2;
        if(opName.indexOf("distributionParts") == 0)
            return 3;
        return 0;
    }
}
