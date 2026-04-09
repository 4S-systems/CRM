package com.SpareParts.servlets;

import com.SpareParts.db_access.*;
import com.maintenance.common.DateParser;
import com.maintenance.db_access.ConfigureMainTypeMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ResultStoreItemMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.TransStoreItemMgr;
import com.maintenance.db_access.TransactionDetailsMgr;
import com.SpareParts.db_access.TransactionMgr;
import com.contractor.db_access.MaintainableMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.jsptags.DropdownDate;
import com.tracker.common.IssueConstants;
import com.tracker.db_access.IssueMgr;
import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

public class TransactionServlet extends TrackerBaseServlet {

    String issueId;
    String businessId;
    String itemId;
    boolean isIssueHasRequest, canDelete;

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
        TransactionDetailsMgr transactionDetailsMgr = TransactionDetailsMgr.getInstance();
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        Vector vecUserTrades = new Vector();
        vecUserTrades = (Vector) user.getAttribute("userTrade");
        QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
        TransStoreItemMgr transStoreItemMgr = TransStoreItemMgr.getInstance();
        TransactionMgr transactionMgr = TransactionMgr.getInstance();
        ItemsMgr itemsMgr = ItemsMgr.getInstance();

        switch (operation) {
            case 1:
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                Vector itemList = new Vector();

                issueId = request.getParameter(IssueConstants.ISSUEID);
                String issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                String issueState = request.getParameter("issueStatus");

                IssueMgr issueMgr = IssueMgr.getInstance();

                if (issueTitle.equalsIgnoreCase("External") || issueTitle.equalsIgnoreCase("Emergency") || ((!issueTitle.equalsIgnoreCase("Emergency") || !issueTitle.equalsIgnoreCase("External")) && (!issueState.equalsIgnoreCase("Schedule")))) {
                    itemList = quantifiedMntenceMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                } else {
                    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                    ConfigureMainTypeMgr configureTypeMgr = ConfigureMainTypeMgr.getInstance();
                    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                    WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                    WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                    itemList = configureTypeMgr.getConfigItemBySchedule(scheduleWbo.getAttribute("periodicID").toString());
                }
                
                Vector issueItemVec = new Vector();
                Vector checkResponseVec = new Vector();
                Vector resultItemVec = new Vector();
                ResultStoreItemMgr resultStoreItemMgr = ResultStoreItemMgr.getInstance();
                WebBusinessObject issueItemWbo = new WebBusinessObject();

                checkResponseVec = transactionMgr.getCheckResponse(issueId, "91");

                // if( checkResponseVec != null && checkResponseVec.size()>0){
                //   issueItemWbo = (WebBusinessObject) checkResponseVec.get(0);
                issueItemVec = transStoreItemMgr.getResponseTotalStoreItems(issueId, "91");
                resultItemVec = resultStoreItemMgr.getResultTotalStoreItems(issueId, "91");

                WebBusinessObject itemListWbo = new WebBusinessObject();
                WebBusinessObject transItemWbo = new WebBusinessObject();
                int countOrder = 0;
                Vector orderItemVec = new Vector();
                for (int y = 0; y < itemList.size(); y++) {
                    countOrder = 0;
                    itemListWbo = (WebBusinessObject) itemList.get(y);

                    for (int x = 0; x < issueItemVec.size(); x++) {
                        transItemWbo = (WebBusinessObject) issueItemVec.get(x);
                        if (transItemWbo.getAttribute("itemID").equals(itemListWbo.getAttribute("itemId")) && transItemWbo.getAttribute("cost_center_id").equals(itemListWbo.getAttribute("attachedOn"))) {
                            countOrder++;
                        }
                    }
                    /*
                     *this code 'itemListWbo.getAttribute("itemId").toString().indexOf("-") != -1' for
                     *old itemId that not form xxx-xxxx it form xxxxx
                     */
                    if (countOrder == 0 && itemListWbo.getAttribute("itemId").toString().indexOf("-") != -1) {
                        orderItemVec.add(itemListWbo);
                    }
                }

                request.setAttribute("issueItemVec", issueItemVec);
                request.setAttribute("resultItem", resultItemVec);

                // }

                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);

                servedPage = "/docs/transaction/request_items.jsp";
                request.setAttribute("vecUserTrades", vecUserTrades);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("data", orderItemVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                itemList = new Vector();
                String trade = (String) request.getParameter("trade");
                request.setAttribute("trade", trade);
                issueId = request.getParameter(IssueConstants.ISSUEID);
                issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
                issueState = request.getParameter("issueStatus");

                String uid = null;

                issueMgr = IssueMgr.getInstance();
                WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);
                uid = issueWbo.getAttribute("unitScheduleID").toString();
                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                MaintainableMgr unitMgr = MaintainableMgr.getInstance();
                WebBusinessObject unitWbo = new WebBusinessObject();
                unitWbo = (WebBusinessObject) unitMgr.getOnSingleKey(issueWbo.getAttribute("unitId").toString());
                String unitNo = unitWbo.getAttribute("unitNo").toString();
                request.setAttribute("unitNo",unitNo);
                if (issueTitle.equalsIgnoreCase("External") || issueTitle.equalsIgnoreCase("Emergency") || ((!issueTitle.equalsIgnoreCase("Emergency") || !issueTitle.equalsIgnoreCase("External")) && (!issueState.equalsIgnoreCase("Schedule")))) {
                    itemList = quantifiedMntenceMgr.getItemSchedule(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                } else {
                    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                    ConfigureMainTypeMgr configureTypeMgr = ConfigureMainTypeMgr.getInstance();
                    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                    WebBusinessObject unitScheduleWbo = unitScheduleMgr.getOnSingleKey(issueMgr.getOnSingleKey(issueId).getAttribute("unitScheduleID").toString());
                    WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey(unitScheduleWbo.getAttribute("periodicId").toString());
                    itemList = configureTypeMgr.getConfigItemBySchedule(scheduleWbo.getAttribute("periodicID").toString());
                }

                transactionMgr = TransactionMgr.getInstance();
                Hashtable tableItem = new Hashtable();
                List savingList = new ArrayList();

                String[] arrItems = request.getParameterValues("itemID");
                String[] itemForm = request.getParameterValues("itemForm");
                String[] costCode = request.getParameterValues("costCode");
                String[] branch   = request.getParameterValues("branch");
                String[] store    = request.getParameterValues("store");
                String itemFormTemp = "";
                String branchTemp   = "";
                String storeTemp    = "";
                String[] itemIds = new String [arrItems.length];
                String[] qty = new String [arrItems.length];
                String[] price = new String [arrItems.length];
                String[] note = new String [arrItems.length];
                String[] attachedOn=new String [arrItems.length];
                String[] efficient = new String [arrItems.length];
                int count = 0;
                UsedSparePartsMgr usedSparePartsMgr = UsedSparePartsMgr.getInstance();
                for (int i = 0; i < arrItems.length; i++) {
                    count++;
                    tableItem = new Hashtable();
                     //tableItem.clear();
                    //tableItem = null;
                    if (storeTemp != null && !storeTemp.equals("")) {
                        if (!itemFormTemp.equals(itemForm[i]) || !branchTemp.equals(branch[i]) || !storeTemp.equals(store[i])) {
                            try {
                                if (transactionMgr.saveMutiFormTrans(request, savingList, "91")) {
                                     if(transactionMgr.saveMutiFormTrans(request, savingList, "92")) {
                                         if(usedSparePartsMgr.saveItemsObject(qty, price, costCode,note, itemIds, branch, store, uid,"0", attachedOn, efficient, session)){
                                              request.setAttribute("status","Ok");
                                        }
                                     }
//                                    request.setAttribute("status", "Ok");
                                    savingList.clear();
                                    itemIds=new String [arrItems.length];
                                    qty=new String [arrItems.length];
                                    price=new String [arrItems.length];
                                    note=new String [arrItems.length];
                                    //savingList = null;
                                    tableItem.put("itemId", arrItems[i]);
                                    tableItem.put("qnty", request.getParameter("itemQuantity" + arrItems[i]));
                                    tableItem.put("isMust", request.getParameter("isMust" + arrItems[i]));
                                    tableItem.put("itemForm", itemForm[i]);
                                    tableItem.put("costCode", costCode[i]);
                                    tableItem.put("branch", branch[i]);
                                    tableItem.put("store", store[i]);
                                    String testQ = request.getParameter("itemQuantity" + arrItems[i]);
                                    itemIds[i]=arrItems[i];
                                    qty[i] = request.getParameter("itemQuantity" + arrItems[i]);
                                    price[i] ="0.0";
                                    note[i]="none";
                                    attachedOn[i]="2";
                                    efficient[i] = "0.0";
                                    itemFormTemp = itemForm[i];
                                    branchTemp = branch[i];
                                    storeTemp = store[i];
                                    savingList.add(tableItem);
                                   
//                        if(count==arrItems.length){
//                             if(transactionMgr.saveMutiFormTrans(request,savingList)){
//                                    request.setAttribute("status", "Ok");
//                            } else {
//                                    request.setAttribute("status", "No");
//                            }
//                        }
                                } else {
                                    request.setAttribute("status", "No");
                                }
                            } catch (SQLException ex) {
                                logger.error(ex.getMessage());
                            }
                        } else {
                            tableItem.put("itemId", arrItems[i]);
                            tableItem.put("qnty", request.getParameter("itemQuantity" + arrItems[i]));
                            tableItem.put("isMust", request.getParameter("isMust" + arrItems[i]));
                            tableItem.put("itemForm", itemForm[i]);
                            tableItem.put("costCode", costCode[i]);
                            tableItem.put("branch", branch[i]);
                            tableItem.put("store", store[i]);
                            String testQ = request.getParameter("itemQuantity" + arrItems[i]);
                            itemIds[i]=arrItems[i];
                            qty[i] = request.getParameter("itemQuantity" + arrItems[i]);
                            price[i] ="0.0";
                            note[i]="none";
                            attachedOn[i]="2";
                            efficient[i] = "0.0";
                            itemFormTemp = itemForm[i];
                            branchTemp = branch[i];
                            storeTemp = store[i];
                            savingList.add(tableItem);

                        }

                    } else {

                        tableItem.put("itemId", arrItems[i]);
                        tableItem.put("qnty", request.getParameter("itemQuantity" + arrItems[i]));
                        tableItem.put("isMust", request.getParameter("isMust" + arrItems[i]));
                        tableItem.put("itemForm", itemForm[i]);
                        tableItem.put("costCode", costCode[i]);
                        tableItem.put("branch", branch[i]);
                        tableItem.put("store", store[i]);
                        String testQ = request.getParameter("itemQuantity" + arrItems[i]);
                        itemIds[i]=arrItems[i];
                        qty[i] = testQ;
                        price[i] ="0.0";
                        note[i]="none";
                        attachedOn[i]="2";
                        efficient[i] = "0.0";
                        itemFormTemp = itemForm[i];
                        branchTemp = branch[i];
                        storeTemp = store[i];
                        savingList.add(tableItem);
                    }

                }
                if (count == arrItems.length) {

                    try {
                        if (transactionMgr.saveMutiFormTrans(request, savingList, "91")) {
                             if(transactionMgr.saveMutiFormTrans(request, savingList, "92")) {
                                if(usedSparePartsMgr.saveItemsObject(qty, price, costCode,note, itemIds, branch, store, uid,"0", attachedOn, efficient, session)){
                                    request.setAttribute("status","Ok");
                                }
                            }
                           
                        } else {
                            request.setAttribute("status", "No");
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(TransactionServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                issueItemVec = new Vector();
                resultItemVec = new Vector();
                transStoreItemMgr = TransStoreItemMgr.getInstance();
                resultStoreItemMgr = ResultStoreItemMgr.getInstance();

                issueItemVec = transStoreItemMgr.getResponseTotalStoreItems(issueId, "91");
                resultItemVec = resultStoreItemMgr.getResultTotalStoreItems(issueId, "91");

                itemListWbo = new WebBusinessObject();
                transItemWbo = new WebBusinessObject();
                countOrder = 0;
                orderItemVec = new Vector();

                for (int y = 0; y < itemList.size(); y++) {
                    countOrder = 0;
                    itemListWbo = (WebBusinessObject) itemList.get(y);

                    for (int x = 0; x < issueItemVec.size(); x++) {
                        transItemWbo = (WebBusinessObject) issueItemVec.get(x);
                        if (transItemWbo.getAttribute("itemID").equals(itemListWbo.getAttribute("itemId"))) {
                            countOrder++;
                        }
                    }
                    if (countOrder == 0) {
                        orderItemVec.add(itemListWbo);
                    }
                }

                request.setAttribute("issueItemVec", issueItemVec);
                request.setAttribute("resultItem", resultItemVec);

                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute(IssueConstants.ISSUETITLE, issueTitle);

                servedPage = "/docs/transaction/request_items.jsp";
                request.setAttribute("vecUserTrades", vecUserTrades);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("data", orderItemVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 3:
                DropdownDate dropdownDate = new DropdownDate();
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                if (null == filterValue) {
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ":" + new Long(dropdownDate.getDate(request.getParameter("endDate")).getTime()).toString();

                    user = (WebBusinessObject) session.getAttribute("loggedUser");
                    String jsDateFormat = user.getAttribute("jsDateFormat").toString();
                    DateParser dateParser = new DateParser();
                    filterValue = new Long(dateParser.getSqlTimeStampDate(request.getParameter("beginDate"), jsDateFormat).getTime()).toString() + ":" + new Long(dateParser.getSqlTimeStampDate(request.getParameter("endDate"), jsDateFormat).getTime()).toString();

                }

                Vector Totalitems = new Vector();
                transactionMgr = TransactionMgr.getInstance();
                Totalitems = transactionMgr.getTransactionsInRange(new Long(filterValue.substring(0, filterValue.indexOf(":"))).longValue(), new Long(filterValue.substring(filterValue.indexOf(":") + 1)).longValue());


                System.out.println("sa ----------------- ");
                servedPage = "/docs/transaction/transaction_list.jsp";
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("data", Totalitems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                servedPage = "/docs/transaction/transaction_report.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                servedPage = "/docs/transaction/transaction_status_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 6:
                
                dropdownDate = new DropdownDate();
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
//                if (null==filterValue){
//                    filterValue = new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime()).toString() + ":" + new Long(dropdownDate.getDate(request.getParameter("endDate")).getTime()).toString();
//                }

                Totalitems = new Vector();

                transactionMgr = TransactionMgr.getInstance();
                WebBusinessObject wboTransaction = transactionMgr.getOnSingleKey(request.getParameter("transactionID"));
                if (wboTransaction != null) {
                    if (wboTransaction.getAttribute("currentStatus").equals("Submitted")) {
                        transactionMgr.updateStatusForTransaction(request);
                    }
                }
                Totalitems = transactionMgr.getTransactionsInRange(new Long(filterValue.substring(0, filterValue.indexOf(":"))).longValue(), new Long(filterValue.substring(filterValue.indexOf(":") + 1)).longValue());


                System.out.println("sa ----------------- ");
                servedPage = "/docs/transaction/transaction_list.jsp";
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("data", Totalitems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                filterName = request.getParameter("filterName");
                filterValue = request.getParameter("filterValue");
                String viewParts = request.getParameter("viewParts");
                if (viewParts == null) {
                    viewParts = "";
                }

                issueItemVec = new Vector();
                checkResponseVec = new Vector();
                resultItemVec = new Vector();
                transStoreItemMgr = TransStoreItemMgr.getInstance();
                resultStoreItemMgr = ResultStoreItemMgr.getInstance();
                issueMgr = IssueMgr.getInstance();
                quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();

                itemList = new Vector();
                issueItemWbo = new WebBusinessObject();
                transactionMgr = TransactionMgr.getInstance();
                issueId = request.getParameter("issueId");
                WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);

                checkResponseVec = transactionMgr.getCheckResponse(issueId, "91");
                resultItemVec = resultStoreItemMgr.getResultTotalStoreItems(issueId, "91");

                if (viewParts.equalsIgnoreCase("ok")) {
                    try {
                        issueItemVec = quantifiedMntenceMgr.getOnArbitraryKey((String) wboIssue.getAttribute("unitScheduleID"), "key1");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    servedPage = "/docs/issue/view_parts_with_response_store_items.jsp";
                } else {
                    issueItemVec = transStoreItemMgr.getResponseTotalStoreItems(issueId, "91");
                    servedPage = "/docs/transaction/response_store_items.jsp";
                }
                request.setAttribute("data", issueItemVec);
                request.setAttribute("resultItem", resultItemVec);
                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute("vecUserTrades", vecUserTrades);
                request.setAttribute("filter", filterName);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                issueItemVec = new Vector();
                checkResponseVec = new Vector();
                resultItemVec = new Vector();
                transStoreItemMgr = TransStoreItemMgr.getInstance();
                resultStoreItemMgr = ResultStoreItemMgr.getInstance();

                itemList = new Vector();
                issueItemWbo = new WebBusinessObject();
                transactionMgr = TransactionMgr.getInstance();
                issueId = request.getParameter("issueId");

                checkResponseVec = transactionMgr.getCheckResponse(issueId, "91");
                issueItemVec = transStoreItemMgr.getResponseTotalStoreItems(issueId, "91");
                //get Returned Quantity
                WebBusinessObject wbo;
                for (int i = 0; i < issueItemVec.size(); i++) {
                    wbo = (WebBusinessObject) issueItemVec.get(i);
                    wbo.setAttribute("returnedQuantity", transStoreItemMgr.getTotalStoreItems((String) wbo.getAttribute("jobOrderID"), "100", (String) wbo.getAttribute("itemID")));
                }
                resultItemVec = resultStoreItemMgr.getResultTotalStoreItems(issueId, "91");

                request.setAttribute(IssueConstants.ISSUEID, issueId);
                request.setAttribute("data", issueItemVec);
                request.setAttribute("resultItem", resultItemVec);
                request.setAttribute("checkResponse", checkResponseVec);

                servedPage = "/docs/transaction/returned_store_items.jsp";
                request.setAttribute("vecUserTrades", vecUserTrades);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 9:
                transactionMgr = TransactionMgr.getInstance();
                String[] returnedList = request.getParameterValues("returned");
                String[] detailIds = request.getParameterValues("detailId");
                String[] returnedQuantityList = request.getParameterValues("returnedQuantity");
                List transactionDetailsList = new ArrayList();
                Hashtable transactionDetails;
                WebBusinessObject wboDetails;
                int index;
                String detailId;

                for (int i = 0; i < returnedList.length; i++) {
                    index = Integer.valueOf(returnedList[i]).intValue();
                    detailId = detailIds[index];
                    transactionDetails = new Hashtable();

                    wboDetails = transactionDetailsMgr.getOnSingleKey(detailId);
                    transactionDetails.put("itemId", wboDetails.getAttribute("itemID"));
                    transactionDetails.put("qnty", returnedQuantityList[index]);
                    transactionDetails.put("isMust", wboDetails.getAttribute("isMost"));
                    transactionDetails.put("itemForm", wboDetails.getAttribute("itemForm"));
                    transactionDetails.put("branch", wboDetails.getAttribute("branch"));
                    transactionDetails.put("store", wboDetails.getAttribute("store"));

                    transactionDetailsList.add(transactionDetails);
                }
                try {
                    if (transactionMgr.saveMutiFormTrans(request, transactionDetailsList, "100")) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                    request.setAttribute("status", "no");
                }
                servedPage = "TransactionServlet?op=GetTransactionReturnedForm";
                this.forward(servedPage, request, response);
                break;

            case 10:
                issueId = request.getParameter("issueId");
                businessId = request.getParameter("businessId");

                issueItemVec = new Vector();
                WebBusinessObject wboItem;
                String itemName;

                canDelete = transactionMgr.canDelete(issueId);
                isIssueHasRequest = transactionMgr.isIssueHasRequestStore(issueId);

                if (canDelete && isIssueHasRequest) {
                    issueItemVec = transStoreItemMgr.getResponseTotalStoreItems(issueId, "91");

                    for (Object object : issueItemVec) {
                        wbo = (WebBusinessObject) object;
                        itemName = "---";

                        itemId = (String) wbo.getAttribute("itemID");
                        wboItem = itemsMgr.getOnSingleKey(itemId);

                        try {
                            itemName = wboItem.getAttribute("itemDscrptn").toString();
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                        wbo.setAttribute("itemName", itemName);
                    }
                }

                servedPage = "/docs/transaction/confirm_delete_transaction.jsp";
                request.setAttribute("data", issueItemVec);
                request.setAttribute("issueId", issueId);
                request.setAttribute("businessId", businessId);
                request.setAttribute("canDelete", canDelete);
                request.setAttribute("isIssueHasRequest", isIssueHasRequest);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                issueId = request.getParameter("issueId");

                if (transactionMgr.deleteTransaction(issueId)) {
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "no");
                }

                servedPage = "TransactionServlet?op=cancelTransaction";
                this.forward(servedPage, request, response);
                break;

            case 12:

                servedPage = "/docs/Adminstration/set_foundation_specification_for_external_transactions.jsp";
                ERPStorTrnsMgr erpStorTrnsMgr = ERPStorTrnsMgr.getInstance();
                Vector ERPTransactions = erpStorTrnsMgr.getAllTransactionsFromERP();
                SpecsOutTrnsMgr specsOutTrnsMgr = SpecsOutTrnsMgr.getInstance();

                Vector specsWboVec = specsOutTrnsMgr.getCashedTable();
                String update = "no";

                if (specsWboVec != null && specsWboVec.size() > 0) {
                    update = "yes";
                    String requestType, fromSide, toSide, fromCode, toCode, fromStoreId, toStoreId;

                    for (int i = 0; i < specsWboVec.size(); i++) {
                        wbo = (WebBusinessObject) specsWboVec.get(i);

                        fromSide = (String) wbo.getAttribute("fromSide");

                        if (fromSide.equals("store")) {
                            wbo.setAttribute("fromCode", "");

                        } else {

                            fromStoreId = fromSide.substring(0, 1);
                            fromCode = fromSide.substring(2);
                            fromSide = (fromStoreId.equals("6")) ? "department" : "consStore";

                            wbo.setAttribute("fromSide", fromSide);
                            wbo.setAttribute("fromCode", fromCode);

                        }

                        toSide = (String) wbo.getAttribute("toSide");

                        if (toSide.equals("store")) {
                            wbo.setAttribute("toCode", "");

                        } else {

                            toStoreId = toSide.substring(0, 1);
                            toCode = toSide.substring(2);
                            toSide = "department";
                            toSide = (toStoreId.equals("6")) ? "department" : "consStore";

                            wbo.setAttribute("toSide", toSide);
                            wbo.setAttribute("toCode", toCode);
                        }

                        requestType = (String) wbo.getAttribute("requestType");
                        if (requestType.equals("sub")) {
                            request.setAttribute("dismissWbo", wbo);

                        } else if (requestType.equals("ret")) {
                            request.setAttribute("returnWbo", wbo);

                        } else {
                            request.setAttribute("consWbo", wbo);

                        }

                    }

                }

                request.setAttribute("update", update);
                request.setAttribute("ERPTransactions", new ArrayList(ERPTransactions));
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;

            case 13:

                servedPage = "TransactionServlet?op=getFoundationSpecificationForExternalTransactionsForm";
                erpStorTrnsMgr = ERPStorTrnsMgr.getInstance();
                ERPTransactions = erpStorTrnsMgr.getAllTransactionsFromERP();
                specsOutTrnsMgr = SpecsOutTrnsMgr.getInstance();

                update = request.getParameter("update");

                WebBusinessObject dismissWbo = new WebBusinessObject();
                WebBusinessObject returnWbo = new WebBusinessObject();
                WebBusinessObject consWbo = new WebBusinessObject();

                String dismissTrnsCode = request.getParameter("dismissTrnsCode");
                String dismissFromSide = request.getParameter("dismiss_from_side");
                String dismissToSide = request.getParameter("dismiss_to_side");
                String dismissFromCode = request.getParameter("dismiss_from_code");
                String dismissToCode = request.getParameter("dismiss_to_code");

                String returnTrnsCode = request.getParameter("returnTrnsCode");
                String returnFromSide = request.getParameter("return_from_side");
                String returnToSide = request.getParameter("return_to_side");
                String returnFromCode = request.getParameter("return_from_code");
                String returnToCode = request.getParameter("return_to_code");

                String retConsTrnsCode = request.getParameter("retConsTrnsCode");
                String retConsFromSide = request.getParameter("ret_cons_from_side");
                String retConsToSide = request.getParameter("ret_cons_to_side");
                String retConsFromCode = request.getParameter("ret_cons_from_code");
                String retConsToCode = request.getParameter("ret_cons_to_code");

                /* prepare dismiss WBO */
                if (request.getParameter("dismissId") != null && !request.getParameter("dismissId").equals("")) {
                    dismissWbo.setAttribute("update","yes");
                    dismissWbo.setAttribute("id", request.getParameter("dismissId"));
                }else{
                    dismissWbo.setAttribute("update","no");
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
                if (request.getParameter("returnId") != null && !request.getParameter("returnId").equals("")) {
                    returnWbo.setAttribute("update", "yes");
                    returnWbo.setAttribute("id", request.getParameter("returnId"));
                }else{
                    returnWbo.setAttribute("update","no");
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

                /* prepare consumption WBO */
                if (request.getParameter("retConsId") != null && !request.getParameter("retConsId").equals("")) {
                    consWbo.setAttribute("update", "yes");
                    consWbo.setAttribute("id", request.getParameter("retConsId"));
                }else{
                    consWbo.setAttribute("update","no");
                }

                consWbo.setAttribute("trnsCode", retConsTrnsCode);
                consWbo.setAttribute("requestType", "use");

                if (retConsFromSide.equals("store")) {
                    consWbo.setAttribute("fromSide", "store");

                } else if (retConsFromSide.equals("department")) {
                    consWbo.setAttribute("fromSide", "6-" + retConsFromCode);

                } else {
                    consWbo.setAttribute("fromSide", "4-" + retConsFromCode);

                }

                if (retConsToSide.equals("store")) {
                    consWbo.setAttribute("toSide", "store");

                } else if (retConsToSide.equals("department")) {
                    consWbo.setAttribute("toSide", "6-" + retConsToCode);

                } else {
                    consWbo.setAttribute("toSide", "4-" + retConsToCode);

                }
                /* - */

                Vector wboVec = new Vector();
                wboVec.add(dismissWbo);
                wboVec.add(returnWbo);
                wboVec.add(consWbo);

                try {

                    if (specsOutTrnsMgr.saveObject(wboVec, update, session)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "no");
                    }

                } catch (SQLException ex) {
                    Logger.getLogger(TransactionServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward(servedPage, request, response);
                break;

            case 14:
                Vector destList = new Vector();
                String formName = (String) request.getParameter("formName");
                String type = (String) request.getParameter("type");
                String sCode =(String) request.getParameter("sCode");
                Vector destV = new Vector();
                ERPDistNamesMgr erpDistNamesMgr = ERPDistNamesMgr.getInstance();
                destV = erpDistNamesMgr.getDestinationByType(type);

                wbo = new WebBusinessObject();

                String sparePart = (String) request.getParameter("sparePart");
                formName = (String) request.getParameter("formName");
                if (sparePart != null && !sparePart.equals("")) {
                    String[] parts = sparePart.split(",");
                    sparePart = "";
                    for (int i = 0; i < parts.length; i++) {
                        char c = (char) new Integer(parts[i]).intValue();
                        sparePart += c;
                    }
                }

                count = 0;
                String url = "TransactionServlet?op=listDest";
                String tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 50;

                    destList = new Vector();

                    if (destV.size() < index) {
                        index = destV.size();
                    }
                    for (int i = count * 50; i < index; i++) {
                        wbo = (WebBusinessObject) destV.get(i);
                        destList.add(wbo);
                    }

                    int intNo=0;
                    float noOfLinks = destV.size() / 50f;
                    String temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    int links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }
                    request.setAttribute("data", destList);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("setupStore", "1");

                    servedPage = "/docs/Adminstration/dest_list.jsp";
                    request.setAttribute("sparePart", sparePart);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("type", type);
                    request.setAttribute("sCode", sCode);
                    request.setAttribute("formName", formName);
                    this.forward(servedPage, request, response);
                break;

            default:
                System.out.println("No operation was matched");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Search Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.indexOf("GetTransactionForm") == 0) {
            return 1;
        }

        if (opName.indexOf("SendOrder") == 0) {
            return 2;
        }

        if (opName.equals("ListTransaction")) {
            return 3;
        }

        if (opName.equals("GetSelectForm")) {
            return 4;
        }

        if (opName.equals("ChangeStatusForm")) {
            return 5;
        }

        if (opName.equals("SaveChangeStatus")) {
            return 6;
        }

        if (opName.equals("GetSubtractCaseStore")) {
            return 7;
        }

        if (opName.equals("GetTransactionReturnedForm")) {
            return 8;
        }

        if (opName.equals("SaveTransactionReturned")) {
            return 9;
        }

        if (opName.equals("cancelTransaction")) {
            return 10;
        }

        if (opName.equals("deleteTransaction")) {
            return 11;
        }

        if (opName.equalsIgnoreCase("getFoundationSpecificationForExternalTransactionsForm")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("saveFoundationSpecificationForExternalTransactionsForm")) {
            return 13;
        }
        if(opName.equals("listDest"))
            return 14;
        return 0;
    }
}
