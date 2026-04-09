package com.tracker.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.Tools;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.IssueProjectMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.RequestItemsDetailsMgr;
import com.tracker.db_access.RequestItemsMgr;
import com.tracker.db_access.StoreTransactionDetailsMgr;
import com.tracker.db_access.StoreTransactionMgr;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SpareItemServlet extends TrackerBaseServlet {

    private ProjectMgr projectMgr;
    private String ids;

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
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        WebBusinessObject wbo;
        String issueId = null;
        projectMgr = ProjectMgr.getInstance();
        try {
            switch (operation) {
                case 1:
                    servedPage = "docs/requests/items.jsp";
                    ids = Tools.concatenation(request.getParameter("ids").split(","), ",");
                    List<WebBusinessObject> items = projectMgr.getProjectByLocationItem(CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM, ids);
                    request.setAttribute("items", items);
                    this.forward(servedPage, request, response);
                    break;
                case 2:
                    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                    IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
                    try {
                        session = request.getSession();
                        String clientId = request.getParameter("clientId");
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                        WebBusinessObject issue = new WebBusinessObject();
                        issue.setAttribute("clientId", clientId);
                        issue.setAttribute("comments", request.getParameter("note"));
                        issue.setAttribute("note", request.getParameter("note"));
                        issue.setAttribute("entryDate", sdf.format(new java.util.Date()));
                        issue.setAttribute("deliveryDate", request.getParameter("deliveryDate"));
                        issue.setAttribute("type", "procurement");
                        issue.setAttribute("callType", request.getParameter("callType"));
                        issue.setAttribute("unitId", "");
                        issue.setAttribute("title", "طلب شراء");
                        issueId = issueMgr.insertIssueProcurement(issue, persistentUser);
                        if (issueId != null) {
                            issue = issueMgr.getOnSingleKey(issueId);
                            request.setAttribute("clientId", clientId);
                            request.setAttribute("status", "ok");
                            request.setAttribute("issueId", issueId);
                            request.setAttribute("issue", issue);
                            String businessId = (String) issue.getAttribute("businessID");
                            String ticketType = CRMConstants.CLIENT_COMPLAINT_TYPE_PROCUREMENT;
                            String notes = request.getParameter("notes");
                            String subject = "طلب شراء";

                            WebBusinessObject departmentWbo = projectMgr.getOnSingleKey(CRMConstants.DEPARTMENT_PROCUREMENT);
                            if (departmentWbo != null && departmentWbo.getAttribute("optionOne") != null
                                    && !"UL".equals(departmentWbo.getAttribute("optionOne"))) {
                                String createdBy = (String) persistentUser.getAttribute("userId");
                                String clientComplaintId = clientComplaintsMgr.createMailInBox((String) departmentWbo.getAttribute("optionOne"), issueId, ticketType, businessId, notes, subject, notes, persistentUser);
                                clientComplaintsMgr.updateClientComplaintsType();
                                if (clientComplaintId != null) {
                                    // insert spare items
                                    RequestItemsMgr requestItemsMgr = RequestItemsMgr.getInstance();
                                    String[] projectIds = request.getParameterValues("requestedItemId");
                                    String[] quantities = request.getParameterValues("quantity");
                                    String requestItemID;
                                    for (int i = 0; i < projectIds.length; i++) {
                                        requestItemID = requestItemsMgr.save(issueId, projectIds[i], quantities[i], "UL", "UL", createdBy, "UL", "procurement",
                                                CRMConstants.SPARE_ITEM_REQUESTED, "UL", "UL", "UL");
                                        wbo = new WebBusinessObject();
                                        wbo.setAttribute("parentId", issueId);
                                        wbo.setAttribute("businessObjectId", requestItemID);
                                        wbo.setAttribute("statusCode", CRMConstants.SPARE_ITEM_REQUESTED);
                                        wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM);
                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                        wbo.setAttribute("issueTitle", "UL");
                                        wbo.setAttribute("statusNote", "UL");
                                        wbo.setAttribute("cuseDescription", "UL");
                                        wbo.setAttribute("actionTaken", "UL");
                                        wbo.setAttribute("preventionTaken", "UL");
                                        try {
                                            issueStatusMgr.changeStatus(wbo, persistentUser, null);
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        }
                                    }
                                    // insert issue status
                                    String statusForIssue = CRMConstants.ISSUE_STATUS_NEW;
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("parentId", "UL");
                                    wbo.setAttribute("businessObjectId", issueId);
                                    wbo.setAttribute("statusCode", statusForIssue);
                                    wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_ISSUE);
                                    wbo.setAttribute("notes", "طلب شراء");
                                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                    wbo.setAttribute("issueTitle", "UL");
                                    wbo.setAttribute("statusNote", "طلب شراء");
                                    wbo.setAttribute("cuseDescription", "UL");
                                    wbo.setAttribute("actionTaken", "UL");
                                    wbo.setAttribute("preventionTaken", "UL");
                                    if (issueStatusMgr.changeStatus(wbo, persistentUser, null)) {
                                        issueMgr.updateCurrentStatus(issueId, statusForIssue);
                                    }

                                } else {
                                    request.setAttribute("status", "Failed");
                                }
                                wbo = new WebBusinessObject();
                                wbo.setAttribute("issueID", issueId);
                                wbo.setAttribute("projectID", request.getParameter("requestType"));
                                wbo.setAttribute("option2", request.getParameter("requestCode"));
                                issueProjectMgr.saveObject(wbo);
                            }
                        } else {
                            request.setAttribute("status", "Failed");
                        }
                    } catch (SQLException | NoUserInSessionException ex) {
                        Logger.getLogger(SpareItemServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    servedPage = "procurement_agenda.jsp";
                    request.setAttribute("page", servedPage);
                    request.setAttribute("issueSaved", "ok");
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    servedPage = "/docs/procurement/update_spare_items_popup.jsp";
                    issueProjectMgr = IssueProjectMgr.getInstance();
                    issueStatusMgr = IssueStatusMgr.getInstance();
                    RequestItemsMgr requestItemsMgr = RequestItemsMgr.getInstance();
                    issueId = request.getParameter("issueID");
                    String nextStatus = request.getParameter("nextStatus");
                    String[] itemIDs = request.getParameterValues("itemID");
                    StoreTransactionMgr storeTransactionMgr = StoreTransactionMgr.getInstance();
                    StoreTransactionDetailsMgr storeTransactionDetailsMgr = StoreTransactionDetailsMgr.getInstance();
                    WebBusinessObject storeTransactionWbo = new WebBusinessObject();
                    WebBusinessObject transactionDetailsWbo = new WebBusinessObject();
                    boolean transactionSaved = false;
                    if (nextStatus != null && itemIDs != null && itemIDs.length > 0) { // save
                        switch (nextStatus) {
                            case CRMConstants.SPARE_ITEM_NEGOTIATED:
                                try {
                                    storeTransactionWbo.setAttribute("dependOnIssueID", issueId);
                                    storeTransactionWbo.setAttribute("transactionType", CRMConstants.STORE_TRANSACTION_TYPE_ADD);
                                    storeTransactionWbo.setAttribute("vendorID", request.getParameter("vendorID"));
                                    storeTransactionWbo.setAttribute("transactionMethod", "UL");
                                    storeTransactionWbo.setAttribute("paymentMethod", request.getParameter("paymentType"));
                                    storeTransactionWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                                    storeTransactionWbo.setAttribute("option1", "UL");
                                    storeTransactionWbo.setAttribute("option2", "UL");
                                    storeTransactionWbo.setAttribute("option3", "UL");
                                    storeTransactionWbo.setAttribute("option4", "UL");
                                    storeTransactionWbo.setAttribute("option5", "UL");
                                    storeTransactionWbo.setAttribute("option6", "UL");
                                    transactionSaved = storeTransactionMgr.saveObject(storeTransactionWbo);
                                    if (transactionSaved) {
                                        wbo = new WebBusinessObject();
                                        wbo.setAttribute("parentId", "UL");
                                        wbo.setAttribute("businessObjectId", storeTransactionWbo.getAttribute("id"));
                                        wbo.setAttribute("statusCode", CRMConstants.STORE_TRANSACTION_PENDING);
                                        wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_STORE_TRANSACTION);
                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                        wbo.setAttribute("issueTitle", "UL");
                                        wbo.setAttribute("statusNote", "UL");
                                        wbo.setAttribute("cuseDescription", "UL");
                                        wbo.setAttribute("actionTaken", "UL");
                                        wbo.setAttribute("preventionTaken", "UL");
                                        issueStatusMgr.changeStatus(wbo, persistentUser, null);
                                    }
                                    transactionDetailsWbo.setAttribute("storeTransactionID", storeTransactionWbo.getAttribute("id"));
                                    transactionDetailsWbo.setAttribute("storeID", "UL");
                                    transactionDetailsWbo.setAttribute("option1", "UL");
                                    transactionDetailsWbo.setAttribute("option2", "UL");
                                    transactionDetailsWbo.setAttribute("option3", "UL");
                                    transactionDetailsWbo.setAttribute("option4", "UL");
                                    transactionDetailsWbo.setAttribute("option5", "UL");
                                    transactionDetailsWbo.setAttribute("option6", "UL");
                                } catch (SQLException ex) {
                                    Logger.getLogger(SpareItemServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }
                                for (String itemID : itemIDs) {
                                    if (requestItemsMgr.update(itemID, request.getParameter("note" + itemID), CRMConstants.SPARE_ITEM_NEGOTIATED, request.getParameter("price" + itemID), request.getParameter("vendorID"), "UL")) {
                                        wbo = new WebBusinessObject();
                                        wbo.setAttribute("parentId", issueId);
                                        wbo.setAttribute("businessObjectId", itemID);
                                        wbo.setAttribute("statusCode", CRMConstants.SPARE_ITEM_NEGOTIATED);
                                        wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM);
                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                        wbo.setAttribute("issueTitle", "UL");
                                        wbo.setAttribute("statusNote", "UL");
                                        wbo.setAttribute("cuseDescription", "UL");
                                        wbo.setAttribute("actionTaken", "UL");
                                        wbo.setAttribute("preventionTaken", "UL");
                                        try {
                                            issueStatusMgr.changeStatus(wbo, persistentUser, null);
                                            if (transactionSaved) {
                                                transactionDetailsWbo.setAttribute("itemID", request.getParameter("spare" + itemID));
                                                transactionDetailsWbo.setAttribute("quantity", request.getParameter("quantity" + itemID));
                                                transactionDetailsWbo.setAttribute("note", request.getParameter("note" + itemID));
                                                transactionDetailsWbo.setAttribute("price", request.getParameter("price" + itemID));
                                                storeTransactionDetailsMgr.saveObject(transactionDetailsWbo);
                                                wbo = new WebBusinessObject();
                                                wbo.setAttribute("parentId", storeTransactionWbo.getAttribute("id"));
                                                wbo.setAttribute("businessObjectId", transactionDetailsWbo.getAttribute("id"));
                                                wbo.setAttribute("statusCode", CRMConstants.SPARE_ITEM_PENDING);
                                                wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM);
                                                wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                                wbo.setAttribute("issueTitle", "UL");
                                                wbo.setAttribute("statusNote", "UL");
                                                wbo.setAttribute("cuseDescription", "UL");
                                                wbo.setAttribute("actionTaken", "UL");
                                                wbo.setAttribute("preventionTaken", "UL");
                                                issueStatusMgr.changeStatus(wbo, persistentUser, null);
                                            }
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        }
                                    }
                                }
                                break;
                            case CRMConstants.SPARE_ITEM_UNAVAILABLE:
                                for (String itemID : itemIDs) {
                                    if (requestItemsMgr.update(itemID, request.getParameter("note" + itemID), CRMConstants.SPARE_ITEM_UNAVAILABLE, "UL", "UL", "UL")) {
                                        wbo = new WebBusinessObject();
                                        wbo.setAttribute("parentId", issueId);
                                        wbo.setAttribute("businessObjectId", itemID);
                                        wbo.setAttribute("statusCode", CRMConstants.SPARE_ITEM_UNAVAILABLE);
                                        wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM);
                                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                        wbo.setAttribute("issueTitle", "UL");
                                        wbo.setAttribute("statusNote", "UL");
                                        wbo.setAttribute("cuseDescription", "UL");
                                        wbo.setAttribute("actionTaken", "UL");
                                        wbo.setAttribute("preventionTaken", "UL");
                                        try {
                                            issueStatusMgr.changeStatus(wbo, persistentUser, null);
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        }
                                    }
                                }
                                break;
                        }
                    }
                    WebBusinessObject issue = issueMgr.getOnSingleKey(issueId);
                    WebBusinessObject department = projectMgr.getManagerByEmployee((String) issue.getAttribute("userId"));
                    if (department == null) {
                        try {
                            ArrayList<WebBusinessObject> departments = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) issue.getAttribute("userId"), "key5"));
                            if (!departments.isEmpty()) {
                                department = departments.get(0);
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(SpareItemServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    request.setAttribute("issue", issue);
                    request.setAttribute("issueProject", issueProjectMgr.getOnSingleKey("key1", issueId));
                    request.setAttribute("requestedBy", userMgr.getOnSingleKey((String) issue.getAttribute("userId")));
                    request.setAttribute("department", department);
                    request.setAttribute("requestedItems", RequestItemsDetailsMgr.getInstance().getByIssueId(issueId));
                    request.setAttribute("contractorsList", ClientMgr.getInstance().getListOfContractors());
                    request.setAttribute("issueID", request.getParameter("issueID"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 4:
                    servedPage = "/docs/store/update_transaction_details.jsp";
                    issueProjectMgr = IssueProjectMgr.getInstance();
                    issueStatusMgr = IssueStatusMgr.getInstance();
                    String transactionID = request.getParameter("transactionID");
                    nextStatus = request.getParameter("nextStatus");
                    itemIDs = request.getParameterValues("itemID");
                    storeTransactionMgr = StoreTransactionMgr.getInstance();
                    storeTransactionDetailsMgr = StoreTransactionDetailsMgr.getInstance();
                    if (nextStatus != null) { // save
                        storeTransactionMgr.updateTransactionStatus(transactionID, CRMConstants.STORE_TRANSACTION_CONFIRMED);
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", "0");
                        wbo.setAttribute("businessObjectId", transactionID);
                        wbo.setAttribute("statusCode", CRMConstants.STORE_TRANSACTION_CONFIRMED);
                        wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_STORE_TRANSACTION);
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        try {
                            issueStatusMgr.changeStatus(wbo, persistentUser, null);
                        } catch (SQLException ex) {
                            logger.error(ex);
                        }
                        if (itemIDs != null) {
                            for (String itemID : itemIDs) {
                                if (storeTransactionDetailsMgr.update(itemID, request.getParameter("note" + itemID), request.getParameter("price" + itemID),
                                        request.getParameter("quantity" + itemID), request.getParameter("storeID" + itemID), nextStatus,
                                        request.getParameter("storePlace" + itemID), request.getParameter("packageNo" + itemID))) {
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("parentId", issueId);
                                    wbo.setAttribute("businessObjectId", itemID);
                                    wbo.setAttribute("statusCode", nextStatus);
                                    wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM);
                                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                    wbo.setAttribute("issueTitle", "UL");
                                    wbo.setAttribute("statusNote", "UL");
                                    wbo.setAttribute("cuseDescription", "UL");
                                    wbo.setAttribute("actionTaken", "UL");
                                    wbo.setAttribute("preventionTaken", "UL");
                                    try {
                                        issueStatusMgr.changeStatus(wbo, persistentUser, null);
                                    } catch (SQLException ex) {
                                        logger.error(ex);
                                    }
                                }
                            }
                        }
                    }
                    storeTransactionWbo = storeTransactionMgr.getOnSingleKey(transactionID);
                    issueId = (String) storeTransactionWbo.getAttribute("dependOnIssueID");
                    issue = issueMgr.getOnSingleKey(issueId);
                    department = projectMgr.getManagerByEmployee((String) issue.getAttribute("userId"));
                    if (department == null) {
                        try {
                            ArrayList<WebBusinessObject> departments = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) issue.getAttribute("userId"), "key5"));
                            if (!departments.isEmpty()) {
                                department = departments.get(0);
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(SpareItemServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    request.setAttribute("issue", issue);
                    request.setAttribute("storeTransactionWbo", storeTransactionWbo);
                    request.setAttribute("issueProject", issueProjectMgr.getOnSingleKey("key1", issueId));
                    request.setAttribute("vendorWbo", storeTransactionWbo != null && storeTransactionWbo.getAttribute("vendorID") != null ? ClientMgr.getInstance().getOnSingleKey((String) storeTransactionWbo.getAttribute("vendorID")) : null);
                    request.setAttribute("requestedBy", userMgr.getOnSingleKey((String) issue.getAttribute("userId")));
                    try {
                        request.setAttribute("storesList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("warehouse", "key6")));
                    } catch (Exception ex) {
                        request.setAttribute("storesList", new ArrayList<>());
                    }
                    request.setAttribute("department", department);
                    request.setAttribute("transactionDetails", storeTransactionDetailsMgr.getByTransactionID(transactionID));
                    request.setAttribute("transactionID", transactionID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 5:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    transactionID = request.getParameter("transactionID");
                    storeTransactionMgr = StoreTransactionMgr.getInstance();
                    storeTransactionDetailsMgr = StoreTransactionDetailsMgr.getInstance();
                    issueStatusMgr = IssueStatusMgr.getInstance();
                    storeTransactionMgr.updateTransactionStatus(transactionID, CRMConstants.STORE_TRANSACTION_CANCELED);
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("parentId", "0");
                    wbo.setAttribute("businessObjectId", transactionID);
                    wbo.setAttribute("statusCode", CRMConstants.STORE_TRANSACTION_CANCELED);
                    wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_STORE_TRANSACTION);
                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                    wbo.setAttribute("issueTitle", "UL");
                    wbo.setAttribute("statusNote", "UL");
                    wbo.setAttribute("cuseDescription", "UL");
                    wbo.setAttribute("actionTaken", "UL");
                    wbo.setAttribute("preventionTaken", "UL");
                    try {
                        issueStatusMgr.changeStatus(wbo, persistentUser, null);
                        ArrayList<WebBusinessObject> details = storeTransactionDetailsMgr.getByTransactionID(transactionID);
                        for (WebBusinessObject detail : details) {
                            if (storeTransactionDetailsMgr.updateTransactionDetailsStatus(transactionID, CRMConstants.SPARE_ITEM_CANCELED)) {
                                wbo.setAttribute("parentId", transactionID);
                                wbo.setAttribute("businessObjectId", detail.getAttribute("id"));
                                wbo.setAttribute("statusCode", CRMConstants.SPARE_ITEM_CANCELED);
                                wbo.setAttribute("objectType", CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM);
                                wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                issueStatusMgr.changeStatus(wbo, persistentUser, null);
                            }
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }
                    wbo.setAttribute("status", "ok");
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                default:
                    System.out.println("No operation was matched");
            }

        } catch (NumberFormatException ex) {
            System.out.println("Error Msg = " + ex.getMessage());
            logger.error(ex.getMessage());
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
        return "Spare Item Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("listSpareItems")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("saveProcurement")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("getUpdateItemsPopup")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("getUpdateTransDetails")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("cancelTransactionAjax")) {
            return 5;
        }
        return 0;
    }
}
