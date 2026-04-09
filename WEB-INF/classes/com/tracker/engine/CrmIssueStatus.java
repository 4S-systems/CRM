/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tracker.engine;

import com.clients.db_access.ClientComplaintsMgr;
import com.maintenance.db_access.DistributionListMgr;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.UserMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author mahmoud tarek
 */
public class CrmIssueStatus extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private List<WebBusinessObject> issue = new ArrayList<WebBusinessObject>();
    private boolean isClosed = false;//7
    private boolean isFinish = false;//6
    private boolean isAssign = false;//4
    private boolean isRedirect = false;
    private boolean isOpen = false;//2
    private boolean isOwner = false;
    private boolean IsOwnerFound = false;
    private boolean checkUserIsOwner = false;
    private boolean isAcknowledge = false;
    private String ownerId = null;
    private boolean canFinish = false;
    private boolean canClose = false;
    private boolean canAssign = false;

    /**
     * @return the issue
     */
    public List<WebBusinessObject> getIssue() {
        return issue;
    }

    /**
     * @param issue the issue to set
     */
    public void setIssue(List<WebBusinessObject> issue) {
        this.issue = issue;
    }

    private String getCurrentOwner(String compId) throws SQLException, NoSuchColumnException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = null;

        params = new Vector();

        params.addElement(new StringValue(compId));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("getCurrentOwner").trim());
        forInsert.setparams(params);
        try {
            queryResult = forInsert.executeQuery();


            if (queryResult != null && !queryResult.isEmpty()) {
                Vector resultBusObjs = new Vector();
                Row r = null;
//                for (WebBusinessObject wbo:queryResult) {
//                    
//                    WebBusinessObject wbo = new WebBusinessObject();
//                    wbo.setAttribute("id", queryResult.elementAt(0));
//                    System.out.println("result=" + wbo.getAttribute("id"));
//                }
                Enumeration q = queryResult.elements();
                WebBusinessObject wbo = new WebBusinessObject();
                while (q.hasMoreElements()) {

                    r = (Row) q.nextElement();

                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", r.getString(1));

                }
                String originalOwnerId = (String) wbo.getAttribute("id");
                DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
//                EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
                wbo = new WebBusinessObject();
                wbo = distributionListMgr.getOnSingleKey(originalOwnerId);

                if (wbo != null) {
                    setOwnerId((String) wbo.getAttribute("receipId"));
                    IsOwnerFound = true;
                }
                return getOwnerId();


            } else {
                return null;
            }

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            endTransaction();
        }

    }

    public boolean isOwner(String userId, String compId) {
        try {
            getCurrentOwner(compId);
        } catch (SQLException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (IsOwnerFound && (userId.equals(this.getOwnerId()))) {
            isOwner = true;
            return true;
        } else {
            return false;
        }
    }

    private Vector complaintStatus(String compId) throws SQLException, NoSuchColumnException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = null;

        params = new Vector();

        params.addElement(new StringValue(compId));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("complaintStatus").trim());
        forInsert.setparams(params);
        try {
            queryResult = forInsert.executeQuery();


            if (queryResult != null && !queryResult.isEmpty()) {
                Vector resultBusObjs = new Vector();
                Row r = null;
//                for (WebBusinessObject wbo:queryResult) {
//                    
//                    WebBusinessObject wbo = new WebBusinessObject();
//                    wbo.setAttribute("id", queryResult.elementAt(0));
//                    System.out.println("result=" + wbo.getAttribute("id"));
//                }
                Enumeration q = queryResult.elements();
                WebBusinessObject wbo = new WebBusinessObject();
                while (q.hasMoreElements()) {

                    r = (Row) q.nextElement();

                    wbo = new WebBusinessObject();
                    wbo.setAttribute("statusCode", r.getString(2));
                    try {
                        wbo.setAttribute("endDate", r.getString(5));
                    } catch (NullPointerException ne) {

                    }
                    resultBusObjs.add(wbo);

                }
                return resultBusObjs;
            } else {
                return null;
            }

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            endTransaction();
        }

    }

    public boolean canFinish(String compId) {

        Vector status = new Vector();
        try {
            status = complaintStatus(compId);
        } catch (SQLException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (status != null && !status.isEmpty()) {
            for (int i = 0; i < status.size(); i++) {
                WebBusinessObject wbo = new WebBusinessObject();
                wbo = (WebBusinessObject) status.get(i);
                if (wbo.getAttribute("statusCode").equals("6")) {
                    isFinish = true;

                }
            }
            if (isFinish) {
                canFinish = false;
            } else {
                canFinish = true;
            }

        }
        return canFinish;
    }

    public boolean canAssign(String compId) {

        Vector status = new Vector();
        try {
            status = complaintStatus(compId);
        } catch (SQLException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (status != null && !status.isEmpty()) {
            for (int i = 0; i < status.size(); i++) {
                WebBusinessObject wbo = new WebBusinessObject();
                wbo = (WebBusinessObject) status.get(i);
                if (wbo.getAttribute("statusCode").equals("4")) {
                    isAssign = true;

                }
            }
            if (isAssign) {
                canAssign = false;
            } else {
                canAssign = true;
            }

        }
        return canAssign;
    }

    public boolean isAcknowledge(String compId) {

        Vector status = new Vector();
        try {
            status = complaintStatus(compId);
        } catch (SQLException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (status != null && !status.isEmpty()) {
            for (int i = 0; i < status.size(); i++) {
                WebBusinessObject wbo = new WebBusinessObject();
                wbo = (WebBusinessObject) status.get(i);
                if (wbo.getAttribute("statusCode").equals("3")) {
                    isAcknowledge = true;
                }
            }
        }
        return isAcknowledge;
    }

    public boolean canClose(String compId) {

        Vector status = new Vector();
        try {
            status = complaintStatus(compId);
        } catch (SQLException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (status != null && !status.isEmpty()) {
            for (int i = 0; i < status.size(); i++) {
                WebBusinessObject wbo = new WebBusinessObject();
                wbo = (WebBusinessObject) status.get(i);
                if (!canFinish(compId)) {
                    if (wbo.getAttribute("statusCode").equals("7") && wbo.getAttribute("endDate") == null) {
                        isClosed = true;
                    }
                }
            }
            if (isClosed) {
                canClose = false;
            } else {
                canClose = true;
            }

        }
        return canClose;
    }

    public int canRedirectOrderToAnotherEmployee(String compId) {
        boolean check = false;
        int x = 0;
        if (canAssign(compId)) {
        } else {
            if (!isAcknowledge(compId) & !canAssign(compId)) {

                x = 3;


            } else {
                x = 1;
            }
            Vector status = new Vector();
            try {
                status = complaintStatus(compId);
            } catch (SQLException ex) {
                Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CrmIssueStatus.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (status != null && !status.isEmpty()) {
                for (int i = 0; i < status.size(); i++) {
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo = (WebBusinessObject) status.get(i);

                    if (wbo.getAttribute("statusCode").equals("7")) {
                        isClosed = true;
                    }
                    if (wbo.getAttribute("statusCode").equals("6")) {
                        isFinish = true;
                    }
                }

            }
            if (isClosed || isFinish) {
                x = 2;
            }
        }
        return x;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedForm() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    /**
     * @return the ownerId
     */
    public String getOwnerId() {
        return ownerId;
    }

    /**
     * @param ownerId the ownerId to set
     */
    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }
}
