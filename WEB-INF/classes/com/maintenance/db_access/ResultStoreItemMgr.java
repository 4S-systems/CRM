package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ResultStoreItemMgr extends RDBGateWay {

    private static ResultStoreItemMgr resultStoreItemMgr = new ResultStoreItemMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ResultStoreItemMgr getInstance() {
        logger.info("Getting ResultStoreItemMgr Instance ....");
        return resultStoreItemMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("result_store_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(Hashtable hash) throws SQLException { return false; }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemID"));
        }

        return cashedData;
    }
    
    public Vector getResultTotalStoreItems(String issueId, String transactionCode) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
       
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(issueId));
        SQLparams.addElement(new StringValue(transactionCode));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getResultTotalStoreItems").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
             
            try {
                wbo.setAttribute("itemID", r.getString("ITEM_CODE"));
                wbo.setAttribute("jobOrderID", r.getString("JOB_ORDER_ID"));
                wbo.setAttribute("total", r.getString("total"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public boolean isIssueHasRespone(String issueId) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        Vector result = new Vector();
        Connection connection = null;

        SQLparams.addElement(new StringValue(issueId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("isIssueHasResponse").trim());
            forQuery.setparams(SQLparams);
            
            result = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return true;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
            return true;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        return result.size() > 0;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
