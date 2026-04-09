package com.financials.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteDOMFabricatorBean;
import com.android.persistence.LiteDateValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class InvoiceMgr extends LiteRDBGateWay {

    private static final InvoiceMgr invoiceMgr = new InvoiceMgr();

    public static InvoiceMgr getInstnace() {
        System.out.println("getting InvoiceMgr  .......");
        return invoiceMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(LiteDOMFabricatorBean.getDocument(metaDataMgr.getMetadata("invoice.xml")));
                System.out.println("reading Successfully InvoiceMgr xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList(getCashedTable());
    }

    @Override
    public boolean saveObject(LiteWebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        params.addElement(new LiteStringValue((String) wbo.getAttribute("clientComplaintID")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("businessID")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("invoiceNo")));
        params.addElement(new LiteDateValue((Date) wbo.getAttribute("invoiceDate")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("extractNo")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("userID")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("currentStatus")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option1")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option2")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option3")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option4")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option5")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option6")));
        int queryResult = -1;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("insertInvoice").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeUpdate();
        } catch (SQLException se) {
            System.out.println("Error In executing Query.............!" + se.getMessage());
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public boolean updateObject(LiteWebBusinessObject wbo) {
        Vector params = new Vector();
        LiteSQLCommandBean forUpdate = new LiteSQLCommandBean();
        int queryResult = -1000;
        String query = getQuery("updateInvoice");
        params.addElement(new LiteDateValue((Date) wbo.getAttribute("invoiceDate")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("extractNo")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option1")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("clientComplaintID")));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(query.trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating invoice: " + se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }
    
    public boolean updateInvoiceStatusToEngApprove(String InvoiceID, String statusID) {
        Vector params = new Vector();
        LiteSQLCommandBean forUpdate = new LiteSQLCommandBean();
        int queryResult = -1000;
        
        String query = getQuery("updateInvoiceToEngApprove");
        params.addElement(new LiteStringValue(statusID));
        params.addElement(new LiteStringValue(InvoiceID));
        
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(query.trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating invoice: " + se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }
    
    public ArrayList<LiteWebBusinessObject> getInvoiceByStatus(String fromDate, String toDate, String statusID) {
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        Vector params = new Vector();
        
        params.addElement(new LiteStringValue(statusID));
        
        StringBuilder where = new StringBuilder();
        if(fromDate != null && !fromDate.isEmpty()) {
            where.append(" AND TRUNC(I.CREATION_TIME) >= TO_DATE('").append(fromDate).append("','YYYY/MM/DD')");
        }
        
        if(toDate != null && !toDate.isEmpty()) {
            where.append(" AND TRUNC(I.CREATION_TIME) <= TO_DATE('").append(toDate).append("','YYYY/MM/DD')");
        }
        
        Vector queryResult = null;
        String query = getQuery("getInvoiceByStatus").trim() + where.toString();
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
         //   Logger.getLogger(JobOrderExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }
        
        ArrayList<LiteWebBusinessObject> resultBusObjs = new ArrayList<>();
        LiteWebBusinessObject wbo;
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("FULL_NAME") != null) {
                        wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                    }else {
                        wbo.setAttribute("createdBy", "");
                    }
                    
                    if (r.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", r.getString("BUSINESS_ID"));
                    }else {
                        wbo.setAttribute("businessID", "");
                    }
                    
                    if (r.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("jobOrderCreationTime", r.getString("CREATION_TIME"));
                    }else {
                        wbo.setAttribute("jobOrderCreationTime", "");
                    }
                    
                    if (r.getString("ISSUE_ID") != null) {
                        wbo.setAttribute("issueID", r.getString("ISSUE_ID"));
                    }else {
                        wbo.setAttribute("issueID", "");
                    }
                    
                    if (r.getString("SYS_ID") != null) {
                        wbo.setAttribute("clientID", r.getString("SYS_ID"));
                    }else {
                        wbo.setAttribute("clientID", "");
                    }
                    
                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    }else {
                        wbo.setAttribute("clientName", "");
                    }
                    
                    if (r.getString("PROJECT_NAME") != null) {
                        wbo.setAttribute("branch", r.getString("PROJECT_NAME"));
                    }else {
                        wbo.setAttribute("branch", "");
                    }
                    
                    if (r.getString("CASE_EN") != null) {
                        wbo.setAttribute("statusEn", r.getString("CASE_EN"));
                    }else {
                        wbo.setAttribute("statusEn", "");
                    }
                    
                    if (r.getString("CASE_AR") != null) {
                        wbo.setAttribute("statusAr", r.getString("CASE_AR"));
                    }else {
                        wbo.setAttribute("statusAr", "");
                    }
                } catch (LiteNoSuchColumnException ex) {
                  //  Logger.getLogger(JobOrderExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<LiteWebBusinessObject> getAllInvoices(String fromDate, String toDate) {
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        Vector params = new Vector();
        
        
        StringBuilder where = new StringBuilder();
        if(fromDate != null && !fromDate.isEmpty()) {
            where.append(" AND TRUNC(I.CREATION_TIME) >= TO_DATE('").append(fromDate).append("','YYYY/MM/DD')");
        }
        
        if(toDate != null && !toDate.isEmpty()) {
            where.append(" AND TRUNC(I.CREATION_TIME) <= TO_DATE('").append(toDate).append("','YYYY/MM/DD')");
        }
        
        Vector queryResult = null;
        String query = getQuery("getAllInvoices").trim() + where.toString();
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
         //   Logger.getLogger(JobOrderExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }
        
        ArrayList<LiteWebBusinessObject> resultBusObjs = new ArrayList<>();
        LiteWebBusinessObject wbo;
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("FULL_NAME") != null) {
                        wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                    }else {
                        wbo.setAttribute("createdBy", "");
                    }
                    
                    if (r.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", r.getString("BUSINESS_ID"));
                    }else {
                        wbo.setAttribute("businessID", "");
                    }
                    
                    if (r.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("jobOrderCreationTime", r.getString("CREATION_TIME"));
                    }else {
                        wbo.setAttribute("jobOrderCreationTime", "");
                    }
                    
                    if (r.getString("ISSUE_ID") != null) {
                        wbo.setAttribute("issueID", r.getString("ISSUE_ID"));
                    }else {
                        wbo.setAttribute("issueID", "");
                    }
                    
                    if (r.getString("SYS_ID") != null) {
                        wbo.setAttribute("clientID", r.getString("SYS_ID"));
                    }else {
                        wbo.setAttribute("clientID", "");
                    }
                    
                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    }else {
                        wbo.setAttribute("clientName", "");
                    }
                    
                    if (r.getString("PROJECT_NAME") != null) {
                        wbo.setAttribute("branch", r.getString("PROJECT_NAME"));
                    }else {
                        wbo.setAttribute("branch", "");
                    }
                    
                    if (r.getString("CASE_EN") != null) {
                        wbo.setAttribute("statusEn", r.getString("CASE_EN"));
                    }else {
                        wbo.setAttribute("statusEn", "");
                    }
                    
                    if (r.getString("CASE_AR") != null) {
                        wbo.setAttribute("statusAr", r.getString("CASE_AR"));
                    }else {
                        wbo.setAttribute("statusAr", "");
                    }
                    
                    if (r.getString("CURRENT_STATUS_SINCE") != null) {
                        wbo.setAttribute("currentStatusSince", r.getString("CURRENT_STATUS_SINCE"));
                    }else {
                        wbo.setAttribute("currentStatusSince", "");
                    }
                } catch (LiteNoSuchColumnException ex) {
                 //   Logger.getLogger(JobOrderExpenseItemMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
    
    
    public ArrayList<LiteWebBusinessObject> getContractorApprovedInvoices(String contractorID) throws LiteNoSuchColumnException {
        Vector params = new Vector();
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getContractorApprovedInvoicesN").trim());
            params.addElement(new LiteStringValue(contractorID));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (LiteUnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            endTransaction();
        }
        ArrayList<LiteWebBusinessObject> data = new ArrayList<>();
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = new LiteWebBusinessObject();
                if (r.getString("BUSINESS_ID") != null) {
                    wbo.setAttribute("businessID", r.getString("BUSINESS_ID"));
                } else {
                    wbo.setAttribute("businessID", "");
                }

                if (r.getString("IN_DATE") != null) {
                    wbo.setAttribute("inDate", r.getString("IN_DATE"));
                } else {
                    wbo.setAttribute("inDate", "");
                }

                if (r.getString("ISSUE_ID") != null) {
                    wbo.setAttribute("issueID", r.getString("ISSUE_ID"));
                } else {
                    wbo.setAttribute("issueID", "");
                }

                if (r.getString("TOTAL") != null) {
                    wbo.setAttribute("total", r.getString("TOTAL"));
                } else {
                    wbo.setAttribute("total", "");
                }
                data.add(wbo);
            }
        }
        return data;
    }
       public ArrayList<LiteWebBusinessObject> getContractorApprovedInvoices1(String contractorID,String fromD,String toD) {
        Vector params = new Vector();
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        StringBuilder where = new StringBuilder();
       String query = getQuery("getContractorApprovedInvoices1").trim() + where.toString();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            params.addElement(new LiteStringValue(contractorID));
            params.addElement(new LiteStringValue(fromD));
            params.addElement(new LiteStringValue(toD));
            params.addElement(new LiteStringValue(contractorID));
             params.addElement(new LiteStringValue(fromD));
            params.addElement(new LiteStringValue(toD));
             forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (LiteUnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            endTransaction();
        }
        ArrayList<LiteWebBusinessObject> data = new ArrayList<>();
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                data.add(wbo);
            }
        }
        return data;
    }
    
 
    public ArrayList<LiteWebBusinessObject> getContractorInvoices(java.sql.Date fromDate, java.sql.Date toDate, String client) {
        Vector params = new Vector();
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            StringBuilder query = new StringBuilder(getQuery("getContractorInvoices").trim());
            params.addElement(new LiteDateValue(fromDate));
            params.addElement(new LiteDateValue(toDate));
            //forQuery.setSQLQuery(getQuery("getClientsInvoices").trim());
            if(client != null && client != "" && client != " "){
                query.append(" AND CL.SYS_ID = ?");
                params.addElement(new LiteStringValue(client));
            }
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (LiteUnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            endTransaction();
        }
        ArrayList<LiteWebBusinessObject> data = new ArrayList<>();
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if(r.getString("NAME") != null){
                       wbo.setAttribute("clientNm", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientNm", "---");
                    }
                    if(r.getString("MOBILE") != null){
                       wbo.setAttribute("clientMob", r.getString("MOBILE"));
                    } else {
                        wbo.setAttribute("clientMob", "---");
                    }
                    if(r.getString("EMAIL") != null){
                       wbo.setAttribute("clientMail", r.getString("EMAIL"));
                    } else {
                        wbo.setAttribute("clientMail", "---");
                    }
                    if(r.getString("FULL_NAME") != null){
                       wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                    } else {
                        wbo.setAttribute("createdBy", "---");
                    }
                    if(r.getString("CASE_EN") != null){
                       wbo.setAttribute("ststusEnNm", r.getString("CASE_EN"));
                    } else {
                        wbo.setAttribute("ststusEnNm", "---");
                    }
                    if(r.getString("CASE_AR") != null){
                       wbo.setAttribute("statusArNm", r.getString("CASE_AR"));
                    } else {
                        wbo.setAttribute("statusArNm", "---");
                    }
                } catch (LiteNoSuchColumnException ex) {
                  //  Logger.getLogger(ClientInvoiceMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
}