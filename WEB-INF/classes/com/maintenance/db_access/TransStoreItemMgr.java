package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class TransStoreItemMgr extends RDBGateWay {

    private static TransStoreItemMgr transStoreItemMgr = new TransStoreItemMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static TransStoreItemMgr getInstance() {
        logger.info("Getting TransStoreItemMgr Instance ....");
        return transStoreItemMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("trans_store_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(Hashtable hash) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemID"));
        }

        return cashedData;
    }
    
    public Vector getResponseTotalStoreItems(String issueId, String transactionCode) {
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
            forQuery.setSQLQuery(sqlMgr.getSql("getResponseTotalStoreItems").trim());
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
                wbo.setAttribute("detailId", r.getString("detail_id"));
                wbo.setAttribute("itemID", r.getString("ITEM_ID"));
                wbo.setAttribute("jobOrderID", r.getString("JOB_ORDER_ID"));
                wbo.setAttribute("total", r.getString("total"));
                wbo.setAttribute("cost_center_id", r.getString("cost_center_id"));
            } catch (NoSuchColumnException ex) {
                ex.printStackTrace();
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public String getTotalStoreItems(String issueId, String transactionCode, String itemId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
       
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(issueId));
        SQLparams.addElement(new StringValue(transactionCode));
        SQLparams.addElement(new StringValue(itemId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getTotalStoreItems").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            if(queryResult.size() > 0) {
                Row row = (Row) queryResult.get(0);
                BigDecimal total = row.getBigDecimal("total");

                if(total != null) {
                    return total.toString();
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } catch (NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedConversionException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return "0";
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
