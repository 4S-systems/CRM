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

public class ClientInvoiceMgr extends LiteRDBGateWay {

    private static final ClientInvoiceMgr clientInvoiceMgr = new ClientInvoiceMgr();

    public static ClientInvoiceMgr getInstnace() {
        System.out.println("getting ClientInvoiceMgr  .......");
        return clientInvoiceMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(LiteDOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_invoice.xml")));
                System.out.println("reading Successfully ClientInvoiceMgr xml files....!");
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
        params.addElement(new LiteStringValue((String) wbo.getAttribute("invoiceID")));
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
    
    public ArrayList<LiteWebBusinessObject> getClientApprovedInvoices(String clientID) {
        Vector params = new Vector();
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getClientApprovedInvoices").trim());
            params.addElement(new LiteStringValue(clientID));
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
    
    public ArrayList<LiteWebBusinessObject> getClientsInvoices(java.sql.Date fromDate, java.sql.Date toDate, String client) {
        Vector params = new Vector();
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            StringBuilder query = new StringBuilder(getQuery("getClientsInvoices").trim());
            params.addElement(new LiteDateValue(fromDate));
            params.addElement(new LiteDateValue(toDate));
            //forQuery.setSQLQuery(getQuery("getClientsInvoices").trim());
            if(client != null && !client.isEmpty()){
                query.append("AND CL.SYS_ID = ?");
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
                    Logger.getLogger(ClientInvoiceMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
}